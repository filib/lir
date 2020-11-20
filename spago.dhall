{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name = "lir"
, dependencies =
  [ "console", "foreign", "globals", "spec", "dom", "eff", "node" ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
