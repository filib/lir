module Validate (
    allValid
  , runValidation
) where

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Unsafe (unsafePerformEff)
import DOM (DOM)
import Data.Array (length)
import Data.Foreign (Foreign)
import Data.Traversable (foldl, sequence)
import Interop (getValue)
import Prelude (pure, map, (==), ($), (>>>), (>>=), (<>), (<$>))
import Types (Validation, Rule, ValidationConfig, ResultRecord, Result(..), Selector, unResult)

-- | Report whether all results are valid.
allValid :: Array ResultRecord -> Boolean
allValid results = length allMessages == 0
  where
    allMessages :: Array String
    allMessages = foldl (\acc x -> x.messages <> acc) [ ] results

-- | Entry point that runs a validation config on the DOM.
runValidation :: ValidationConfig -> Array ResultRecord
runValidation config = unsafePerformEff $ runValidation' config
                       >>= map unResult
                       >>> pure

-- | Entry point that runs a validation config on the DOM.
runValidation' :: forall eff. ValidationConfig
                 -> Eff (dom :: DOM | eff) (Array Result)
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
validate :: forall eff. Validation -> Eff (dom :: DOM | eff) Result
validate validation = getValue validation.selector
                      >>= collect
                      >>> reduce
                      >>> pure
  where
    validations :: Array (Foreign -> Result)
    validations = applyRule validation.selector <$> validation.rules

    collect :: Foreign -> Array Result
    collect value = (\f -> f value) <$> validations

    reduce :: Array Result -> Result
    reduce results =
      foldl (\acc x -> x <> acc) (defaultResult validation.selector) results
