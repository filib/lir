# Lir

Lir is a JavaScript form validation library written in PureScript. It is designed to be declarative and framework-agnostic.

## Usage

``` javascript
var validate    = Lir["Validate"],
    constraints = Lir["Constraints"];

validate.runValidation({
    validations: [{
        selector: "input#booking-name",
        rules: [{
            message: "Booking name cannot be blank.",
            constraint: function(x) {
                return x !== "";
            }
        }]
    },
    {
        selector: "input#booking-room-number",
        rules: [{
            message: "Booking room must be a number.",
            constraint: constraints.isNumber
        }]
    }]
});
```

## Development

```
% make
doc                            Generate documentation
help                           Print available tasks
install                        Install dependencies
pack                           Pack single JavaScript file for use in the browser
spec                           Run tests
watch                          Recompile on file system changes
```
