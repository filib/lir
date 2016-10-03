module Types where

import Data.Foreign (Foreign)
import Prelude (class Semigroup, (<>), ($))


-- | Alias Selector to String to make signatures a bit more readable.
type Selector = String

-- | The result type contains a selector that points to a DOM element or an
-- | array of error messages.
newtype Result = Result ResultRecord

-- | JavaScript result representation.
type ResultRecord = { selector :: Selector
                    , messages :: Array String
                    }

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

-- | In order to allow us to accumulate errors our result type forms a
-- | semigroup.
instance semigroupResult :: Semigroup Result where
  append (Result x) (Result y) = Result $
    { selector: x.selector, messages: x.messages <> y.messages }

-- | Unpack a result for easy use in JavaScript.
unResult :: Result -> ResultRecord
unResult (Result x) = x
