module Interop where

import Effect (Effect)
import Foreign (Foreign)

foreign import getValue :: String -> Effect Foreign
