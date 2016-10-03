## Module Types

#### `Result`

``` purescript
newtype Result
  = Result ResultRecord
```

The result type contains a selector that points to a DOM element or an
array of error messages.

##### Instances
``` purescript
Semigroup Result
```

#### `ResultRecord`

``` purescript
type ResultRecord = { selector :: Selector, messages :: Array String }
```

JavaScript result representation.

#### `Rule`

``` purescript
type Rule = { message :: String, constraint :: Foreign -> Boolean }
```

The rule type consists of an error message and a predicate function.

#### `Validation`

``` purescript
type Validation = { selector :: Selector, rules :: Array Rule }
```

A validation contains a selector that points to a DOM element and an array
of rules.

#### `ValidationConfig`

``` purescript
type ValidationConfig = { validations :: Array Validation }
```

A validation config points to an array of validations.

#### `unResult`

``` purescript
unResult :: Result -> ResultRecord
```

Unpack a result for easy use in JavaScript.


