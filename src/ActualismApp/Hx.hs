-- | Simple Lucid adapter for https://htmx.org/
module ActualismApp.Hx where

import Data.Text qualified as T
import Lucid
import Lucid.Base (makeAttributes)

data Hx
  = HxGet Text
  | HxTrigger HxTriggerType
  | HxSwap HxSwapType
  | HxTarget Text

data HxTriggerType = Click | Mouseover
  deriving stock (Show)

data HxSwapType = Afterend | Delete
  deriving stock (Show)

-- | Convert 'Hx' to Lucid 'Attributes'
hx :: Hx -> Attributes
hx = \case
  HxGet url -> makeAttributes "hx-get" url
  HxTrigger t -> makeAttributes "hx-trigger" $ T.toLower . show $ t
  HxSwap t -> makeAttributes "hx-swap" $ T.toLower . show $ t
  HxTarget s -> makeAttributes "hx-target" s
