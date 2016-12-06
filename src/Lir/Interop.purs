module Lir.Interop where

import Control.Monad.Eff (Eff)
import DOM (DOM)
import Data.Foreign (Foreign)

foreign import getValue :: forall eff. String -> Eff (dom :: DOM | eff) Foreign
