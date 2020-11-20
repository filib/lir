module Validate (
    allMessages
  , allValid
  , runValidation
) where

import Effect (Effect)
import Effect.Unsafe (unsafePerformEffect)
import Data.Array (length)
import Foreign (Foreign)
import Data.Traversable (foldl, sequence)
import Interop (getValue)
import Prelude (bind, pure, map, (==), ($), (>>>), (>>=), (<>), (<$>))
import Types (Validation, Rule, ValidationConfig, ResultRecord, Result(..), Selector, unResult)

-- | Pull all messages out of validation results.
allMessages :: Array ResultRecord -> Array String
allMessages results = foldl (\acc x -> x.messages <> acc) [ ] results

-- | Report whether all results are valid.
allValid :: Array ResultRecord -> Boolean
allValid results = length (allMessages results) == 0

-- | Entry point that runs a validation config on the DOM.
runValidation :: ValidationConfig -> Array ResultRecord
runValidation config = unsafePerformEffect $ runValidation' config
                       >>= map unResult
                       >>> pure

-- | Entry point that runs a validation config on the DOM.
runValidation' :: ValidationConfig -> Effect (Array Result)
runValidation' config = sequence $ map validate config.validations

-- | Constructs a default result with no error messages.
defaultResult :: Selector -> Result
defaultResult selector = Result { selector: selector
                                , messages: [  ]
                                }

-- | Applies a rule to a value from JavaScript.
applyRule :: Selector -> Rule -> (Foreign -> Result)
applyRule selector rule value =
  if rule.constraint value then defaultResult selector else error
  where
    error :: Result
    error = Result { selector: selector
                   , messages: [ rule.message ]
                   }

-- | Validates a DOM element adheres to our specified constraints.
validate :: Validation -> Effect Result
validate validation = do
  val <- getValue validation.selector
  pure $ reduce (collect val)
  where
    validations :: Array (Foreign -> Result)
    validations = applyRule validation.selector <$> validation.rules

    collect :: Foreign -> Array Result
    collect value = (\f -> f value) <$> validations

    reduce :: Array Result -> Result
    reduce results =
      foldl (\acc x -> x <> acc) (defaultResult validation.selector) results
