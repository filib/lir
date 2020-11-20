{-
Welcome to your new Dhall package-set!

Below are instructions for how to edit this file for most use
cases, so that you don't need to know Dhall to use it.

## Warning: Don't Move This Top-Level Comment!

Due to how `dhall format` currently works, this comment's
instructions cannot appear near corresponding sections below
because `dhall format` will delete the comment. However,
it will not delete a top-level comment like this one.

## Use Cases

Most will want to do one or both of these options:
1. Override/Patch a package's dependency
2. Add a package not already in the default package set

This file will continue to work whether you use one or both options.
Instructions for each option are explained below.

### Overriding/Patching a package

Purpose:
- Change a package's dependency to a newer/older release than the
    default package set's release
- Use your own modified version of some dependency that may
    include new API, changed API, removed API by
    using your custom git repo of the library rather than
    the package set's repo

Syntax:
where `entityName` is one of the following:
- dependencies
- repo
- version
-------------------------------
let upstream = --
in  upstream
  with packageName.entityName = "new value"
-------------------------------

Example:
-------------------------------
let upstream = --
in  upstream
  with halogen.version = "master"
  with halogen.repo = "https://example.com/path/to/git/repo.git"

  with halogen-vdom.version = "v4.0.0"
-------------------------------

### Additions

Purpose:
- Add packages that aren't already included in the default package set

Syntax:
where `<version>` is:
- a tag (i.e. "v4.0.0")
- a branch (i.e. "master")
- commit hash (i.e. "701f3e44aafb1a6459281714858fadf2c4c2a977")
-------------------------------
let upstream = --
in  upstream
  with new-package-name =
    { dependencies =
       [ "dependency1"
       , "dependency2"
       ]
    , repo =
       "https://example.com/path/to/git/repo.git"
    , version =
        "<version>"
    }
-------------------------------

Example:
-------------------------------
let upstream = --
in  upstream
  with benchotron =
      { dependencies =
          [ "arrays"
          , "exists"
          , "profunctor"
          , "strings"
          , "quickcheck"
          , "lcg"
          , "transformers"
          , "foldable-traversable"
          , "exceptions"
          , "node-fs"
          , "node-buffer"
          , "node-readline"
          , "datetime"
          , "now"
          ]
      , repo =
          "https://github.com/hdgarrood/purescript-benchotron.git"
      , version =
          "v7.0.0"
      }
-------------------------------
-}

let upstream =
      https://github.com/purescript/package-sets/releases/download/psc-0.13.8-20201007/packages.dhall sha256:35633f6f591b94d216392c9e0500207bb1fec42dd355f4fecdfd186956567b6b

in  upstream
  with aff.version = "v2.0.2"
  with arraybuffer-types.version = "v1.0.0"
  with console.version = "v2.0.0"
  with datetime.version = "v3.0.0"
  with enums.version = "v3.0.0"
  with exceptions.version = "v3.0.0"
  with foldable-traversable.version = "v3.0.0"
  with foreign.version = "v4.0.0"
  with js-date.version = "v4.0.0"
  with maybe.version = "v2.0.0"
  with media-types.version = "v3.0.0"
  with node-fs.version = "v3.0.0"
  with node-streams.version = "v2.0.0"
  with nullable.version = "v3.0.0"
  with partial.version = "v1.1.2"
  with posix-types.version = "v2.0.0"
  with prelude.version = "v3.0.0"
  with spec.version = "v0.9.0"
  with transformers.version = "v2.0.0"
  with unsafe-coerce.version = "v3.0.0"
  with dom =
    { repo = "https://github.com/purescript-deprecated/purescript-dom.git"
    , version = "v3.0.0"
    , dependencies = [
          "arraybuffer-types"
        , "datetime"
        , "enums"
        , "exceptions"
        , "foldable-traversable"
        , "foreign"
        , "js-date"
        , "media-types"
        , "nullable"
        , "prelude"
        , "unsafe-coerce"
        , "eff"
    ]
    }
  with eff =
    { repo = "https://github.com/purescript-deprecated/purescript-eff.git"
    , version = "v3.2.1"
    , dependencies = [
          "prelude"
    ]
    }
  with maps =
    { repo = "https://github.com/purescript-deprecated/purescript-maps.git"
    , version = "v2.0.0"
    , dependencies = [
          "prelude"
    ]
    }
  with node =
    { repo = "https://github.com/purescript-node/purescript-node-process.git"
    , version = "v3.0.0"
    , dependencies = [
        "console"
      , "exceptions"
      , "maps"
      , "maybe"
      , "node-fs"
      , "node-streams"
      , "posix-types"
      , "unsafe-coerce"
      , "partial"
    ]
    }
