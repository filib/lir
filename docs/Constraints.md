## Module Constraints

#### `notNullOrUndefined`

``` purescript
notNullOrUndefined :: Foreign -> Boolean
```

Checks that a value is not null or undefined.

#### `required`

``` purescript
required :: Foreign -> Boolean
```

Checks that the value isn't an empty string i.e. is at least one char in
length.

#### `isBoolean`

``` purescript
isBoolean :: Foreign -> Boolean
```

Checks that the value looks like a typical boolean value.

#### `isInt`

``` purescript
isInt :: Foreign -> Boolean
```

Checks that the value is an integer.

#### `isNat`

``` purescript
isNat :: Foreign -> Boolean
```

Checks that a value is a natural number.

#### `isNumber`

``` purescript
isNumber :: Foreign -> Boolean
```

Checks that a value is a number i.e. floating point number.

#### `exactLength`

``` purescript
exactLength :: Int -> Foreign -> Boolean
```

Checks that a value has length n.

#### `maxLength`

``` purescript
maxLength :: Int -> Foreign -> Boolean
```

Checks that a value does not exceed length n.

#### `minLength`

``` purescript
minLength :: Int -> Foreign -> Boolean
```

Checks value is at least length n.

#### `greaterThan`

``` purescript
greaterThan :: Int -> Foreign -> Boolean
```

Checks that number is greater than n.

#### `lessThan`

``` purescript
lessThan :: Int -> Foreign -> Boolean
```

Checks that value is less than n.


