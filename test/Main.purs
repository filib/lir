module Test.Main where

import Constraints
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE)
import Data.Foreign (toForeign)
import Node.Process (PROCESS)
import Prelude (Unit, bind, ($))
import Test.Spec (describe, it)
import Test.Spec.Assertions (shouldEqual)
import Test.Spec.Reporter.Console (consoleReporter)
import Test.Spec.Runner (run)

main :: forall eff. Eff (process :: PROCESS, console :: CONSOLE | eff) Unit
main = run [consoleReporter] do
  describe "Constraints" do
    describe "notNullOrUndefined" do
      it "should be true for ''" do
        let result = notNullOrUndefined $ toForeign ""
        result `shouldEqual` true

      it "should be true for 42" do
        let result = notNullOrUndefined $ toForeign 42
        result `shouldEqual` true

      it "should be true 1.0" do
        let result = notNullOrUndefined $ toForeign 1.0
        result `shouldEqual` true

    describe "required" do
      it "should be true for a string of length > 0" do
        let result = required $ toForeign "result"
        result `shouldEqual` true

      it "should be true false for ''" do
        let result = required $ toForeign ""
        result `shouldEqual` false

      it "should be false for all unsupported values" do
        let result = required $ toForeign 42
        result `shouldEqual` false

    describe "isBoolean" do
      it "should be true for 'true'" do
        let result = isBoolean $ toForeign "true"
        result `shouldEqual` true

      it "should be true for 'false'" do
        let result = isBoolean $ toForeign "false"
        result `shouldEqual` true

      it "should be false for all unsupported values" do
        let result = isBoolean $ toForeign 42
        result `shouldEqual` false

    describe "isInt" do
      it "should be true for 0" do
        let result = isInt $ toForeign "0"
        result `shouldEqual` true

      it "should be false for all unsupported values" do
        let result = isInt $ toForeign "1.0"
        result `shouldEqual` false

    describe "isNat" do
      it "should be true for 42" do
        let result = isNat $ toForeign "42"
        result `shouldEqual` true

      it "should be false for all unsupported values" do
        let result = isNat $ toForeign "1.0"
        result `shouldEqual` false

    describe "isNumber" do
      it "should be true for 42" do
        let result = isNumber $ toForeign "42"
        result `shouldEqual` true

      it "should be true for 1.0" do
        let result = isNumber $ toForeign "1.0"
        result `shouldEqual` true

      it "should be false for all unsupported values" do
        let result = isNumber $ toForeign ""
        result `shouldEqual` false

    describe "exactLength 5" do
      let constraint = exactLength 5

      it "should be true for 'hello'" do
        let result = constraint $ toForeign "hello"
        result `shouldEqual` true

      it "should be false for 'lir'" do
        let result = constraint $ toForeign "lir"
        result `shouldEqual` false

      it "should be false for all unsupported values" do
        let result = constraint $ toForeign "1.0"
        result `shouldEqual` false

    describe "maxLength 5" do
      let constraint = maxLength 5

      it "should be true for 'hello'" do
        let result = constraint $ toForeign "hello"
        result `shouldEqual` true

      it "should be false for 'hello lir'" do
        let result = constraint $ toForeign "hello lir"
        result `shouldEqual` false

    describe "minLength 5" do
      let constraint = minLength 5

      it "should be true for 'hello lir'" do
        let result = constraint $ toForeign "hello lir"
        result `shouldEqual` true

      it "should be false for 'hello'" do
        let result = constraint $ toForeign "hey"
        result `shouldEqual` false

    describe "greaterThan 5" do
      let constraint = greaterThan 5

      it "should be true for '42'" do
        let result = constraint $ toForeign "42"
        result `shouldEqual` true

      it "should be false for 3" do
        let result = constraint $ toForeign "3"
        result `shouldEqual` false

      it "should be false for all unsupported values" do
        let result = constraint $ toForeign "hello"
        result `shouldEqual` false

    describe "lessThan 5" do
      let constraint = lessThan 5

      it "should be true for '3'" do
        let result = constraint $ toForeign "3"
        result `shouldEqual` true

      it "should be false for '42'" do
        let result = constraint $ toForeign "42"
        result `shouldEqual` false

      it "should be false for all unsupported values" do
        let result = constraint $ toForeign "hello"
        result `shouldEqual` false
