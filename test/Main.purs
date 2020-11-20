module Test.Main where

import Constraints
import Effect (Effect)
import Effect.Aff (launchAff_)
import Foreign (unsafeToForeign)
import Prelude (Unit, discard, ($))
import Test.Spec (describe, it)
import Test.Spec.Assertions (shouldEqual)
import Test.Spec.Reporter.Console (consoleReporter)
import Test.Spec.Runner (runSpec)

main :: Effect Unit
main = launchAff_ $ runSpec [consoleReporter] do
  describe "Constraints" do
    describe "notNullOrUndefined" do
      it "should be true for ''" do
        let result = notNullOrUndefined $ unsafeToForeign ""
        result `shouldEqual` true

      it "should be true for 42" do
        let result = notNullOrUndefined $ unsafeToForeign 42
        result `shouldEqual` true

      it "should be true 1.0" do
        let result = notNullOrUndefined $ unsafeToForeign 1.0
        result `shouldEqual` true

    describe "required" do
      it "should be true for a string of length > 0" do
        let result = required $ unsafeToForeign "result"
        result `shouldEqual` true

      it "should be true false for ''" do
        let result = required $ unsafeToForeign ""
        result `shouldEqual` false

      it "should be false for all unsupported values" do
        let result = required $ unsafeToForeign 42
        result `shouldEqual` false

    describe "isBoolean" do
      it "should be true for 'true'" do
        let result = isBoolean $ unsafeToForeign "true"
        result `shouldEqual` true

      it "should be true for 'false'" do
        let result = isBoolean $ unsafeToForeign "false"
        result `shouldEqual` true

      it "should be false for all unsupported values" do
        let result = isBoolean $ unsafeToForeign 42
        result `shouldEqual` false

    describe "isInt" do
      it "should be true for 0" do
        let result = isInt $ unsafeToForeign "0"
        result `shouldEqual` true

      it "should be false for all unsupported values" do
        let result = isInt $ unsafeToForeign "1.0"
        result `shouldEqual` false

    describe "isNat" do
      it "should be true for 42" do
        let result = isNat $ unsafeToForeign "42"
        result `shouldEqual` true

      it "should be false for all unsupported values" do
        let result = isNat $ unsafeToForeign "1.0"
        result `shouldEqual` false

    describe "isNumber" do
      it "should be true for 42" do
        let result = isNumber $ unsafeToForeign "42"
        result `shouldEqual` true

      it "should be true for 1.0" do
        let result = isNumber $ unsafeToForeign "1.0"
        result `shouldEqual` true

      it "should be false for all unsupported values" do
        let result = isNumber $ unsafeToForeign ""
        result `shouldEqual` false

    describe "exactLength 5" do
      let constraint = exactLength 5

      it "should be true for 'hello'" do
        let result = constraint $ unsafeToForeign "hello"
        result `shouldEqual` true

      it "should be false for 'lir'" do
        let result = constraint $ unsafeToForeign "lir"
        result `shouldEqual` false

      it "should be false for all unsupported values" do
        let result = constraint $ unsafeToForeign "1.0"
        result `shouldEqual` false

    describe "maxLength 5" do
      let constraint = maxLength 5

      it "should be true for 'hello'" do
        let result = constraint $ unsafeToForeign "hello"
        result `shouldEqual` true

      it "should be false for 'hello lir'" do
        let result = constraint $ unsafeToForeign "hello lir"
        result `shouldEqual` false

    describe "minLength 5" do
      let constraint = minLength 5

      it "should be true for 'hello lir'" do
        let result = constraint $ unsafeToForeign "hello lir"
        result `shouldEqual` true

      it "should be false for 'hello'" do
        let result = constraint $ unsafeToForeign "hey"
        result `shouldEqual` false

    describe "greaterThan 5" do
      let constraint = greaterThan 5

      it "should be true for '42'" do
        let result = constraint $ unsafeToForeign "42"
        result `shouldEqual` true

      it "should be false for 3" do
        let result = constraint $ unsafeToForeign "3"
        result `shouldEqual` false

      it "should be false for all unsupported values" do
        let result = constraint $ unsafeToForeign "hello"
        result `shouldEqual` false

    describe "lessThan 5" do
      let constraint = lessThan 5

      it "should be true for '3'" do
        let result = constraint $ unsafeToForeign "3"
        result `shouldEqual` true

      it "should be false for '42'" do
        let result = constraint $ unsafeToForeign "42"
        result `shouldEqual` false

      it "should be false for all unsupported values" do
        let result = constraint $ unsafeToForeign "hello"
        result `shouldEqual` false
