module Lir (
    validate
  , Result(..)
  , ResultRecord
) where

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.JQuery (Selector, getValue, select)
import DOM (DOM)
import Data.Foreign (Foreign)
import Data.Traversable (foldl, sequence)
import Prelude

-- | JavaScript result representation.
type ResultRecord = { selector :: Selector
                    , messages :: Array String
                    }

-- | The result type contains a selector that points to a DOM element or an
-- | array of error messages.
newtype Result = Result ResultRecord

-- | Unpack a result for easy use in JavaScript.
unResult :: Result -> ResultRecord
unResult (Result x) = x

-- | In order to allow us to accumulate errors our result type forms a
-- | semigroup.
instance semigroupResult :: Semigroup Result where
  append (Result x) (Result y) = Result $
    { selector: x.selector, messages: x.messages <> y.messages }

-- | The rule type consists of an error message and a predicate function.
type Rule = { message    :: String
            , constraint :: Foreign -> Boolean
            }

-- | A validation contains a selector that points to a DOM element and an array
-- | of rules.
type Validation = { selector :: Selector
                  , rules    :: Array Rule
                  }

-- | A validation config points to an array of validations.
type ValidationConfig = { validations :: Array Validation }

-- | Entry point that runs a validation config on the DOM.
runValidation :: forall eff. ValidationConfig -> Eff (dom :: DOM | eff) (Array Result)
runValidation config = sequence $ map validate config.validations

-- | Constructs a default result with no error messages.
defaultResult :: Selector -> Result
defaultResult selector = Result { selector: selector
                                , messages: [  ]
                                }

-- | Applies a rule to a value from JavaScript.
applyRule :: Selector -> Rule -> (Foreign -> Result)
applyRule selector rule value =
  if rule.constraint value then result else defaultResult selector
  where
    result :: Result
    result = Result { selector: selector
                    , messages: [ rule.message ]
                    }

-- | Validates a DOM element adheres to our specified constraints.
validate :: forall eff. Validation -> Eff (dom :: DOM | eff) Result
validate validation = do
  value <- select validation.selector >>= getValue
  collect >>> reduce >>> pure $ value
  where
    validations :: Array (Foreign -> Result)
    validations = applyRule validation.selector <$> validation.rules

    collect :: Foreign -> Array Result
    collect value = (\f -> f value) <$> validations

    reduce :: Array Result -> Result
    reduce results =
      foldl (\acc x -> x <> acc) (defaultResult validation.selector) results
