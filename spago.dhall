{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name = "lir"
, dependencies = [ "spec", "foreign", "node-process", "web-html" ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
