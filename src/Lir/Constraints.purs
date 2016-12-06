module Lir.Constraints (
    notNullOrUndefined
  , required
  , isBoolean
  , isInt
  , isNat
  , isNumber
  , exactLength
  , maxLength
  , minLength
  , greaterThan
  , lessThan
) where

import Data.Either (Either(..))
import Data.Foreign (Foreign, readString, isUndefined, isNull)
import Data.Int (toNumber, fromString)
import Data.Maybe (Maybe(..), maybe)
import Data.String as String
import Global (readFloat, isNaN)
import Prelude (not, const, (>>>), (<), (>), (<=), ($), (==), (>=), (||))

-- | Checks that a value is not null or undefined.
notNullOrUndefined :: Foreign -> Boolean
notNullOrUndefined value = not $ isNull value || isUndefined value

-- | Checks that the value isn't an empty string i.e. is at least one char in
-- | length.
required :: Foreign -> Boolean
required value = stringCompare value $ \x ->
  x > 0

-- | Checks that the value looks like a typical boolean value.
isBoolean :: Foreign -> Boolean
isBoolean value = case readString value of
  Right "true"  -> true
  Right "false" -> true
  _             -> false

-- | Checks that the value is an integer.
isInt :: Foreign -> Boolean
isInt value = case readString value of
  Right string -> maybe false (const true) (fromString string)
  _            -> false

-- | Checks that a value is a natural number.
isNat :: Foreign -> Boolean
isNat value = case readString value of
  Right string -> maybe false (\i -> i >= 0) (fromString string)
  _            -> false

-- | Checks that a value is a number i.e. floating point number.
isNumber :: Foreign -> Boolean
isNumber value = case readNumberFromString value of
  Just _ -> true
  _      -> false

-- | Checks that a value has length n.
exactLength :: Int -> Foreign -> Boolean
exactLength i value = stringCompare value $ \x ->
  x == i

-- | Checks that a value does not exceed length n.
maxLength :: Int -> Foreign -> Boolean
maxLength i value = stringCompare value $ \x ->
  x <= i

-- | Checks value is at least length n.
minLength :: Int -> Foreign -> Boolean
minLength i value = stringCompare value $ \x ->
  x >= i

-- | Checks that number is greater than n.
greaterThan :: Int -> Foreign -> Boolean
greaterThan i value = case readNumberFromString value of
  Just number -> toNumber i < number
  _           -> false

-- | Checks that value is less than n.
lessThan :: Int -> Foreign -> Boolean
lessThan i value = case readNumberFromString value of
  Just number -> toNumber i > number
  _           -> false

--------------------------------------------------------------------------------

-- | Compresses result of applying foreign transform into boolean.
compress :: forall a b c. (b -> Either a c) -> b -> Boolean
compress f x = case f x of
  Right _ -> true
  _       -> false

-- | Takes a string and attempts to safely coerce it to a number.
readNumberFromString :: Foreign -> Maybe Number
readNumberFromString value = case readString value of
  Right string -> let number = readFloat string in
    if notNaN number then Just number else Nothing
  _            -> Nothing
  where
    notNaN :: Number -> Boolean
    notNaN = isNaN >>> not

-- | Compares string lengths.
stringCompare :: Foreign -> (Int -> Boolean) -> Boolean
stringCompare value compare = case readString value of
  Right string -> compare (String.length string)
  _            -> false
