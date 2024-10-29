module ActualismApp.Definition where

import ActualismApp.Hx
import ActualismApp.Popup qualified as Popup
import Data.HashMap.Strict as Map
import Data.Text qualified as T
import Lucid
import Web.Scotty qualified as S

definitionHandler :: HashMap Text (Html ()) -> S.ScottyM ()
definitionHandler definitions = do
  S.get "/def/:id" $ do
    k <- S.pathParam "id"
    S.html $
      renderText $
        Popup.popup k $
          Map.lookup k definitions & fromMaybe "Definition not found!"

parseDefinition :: Text -> Maybe Text
parseDefinition s = do
  guard $ T.isPrefixOf "#" s
  pure $ T.drop 1 s

definitionLink :: Text -> Html () -> Html ()
definitionLink def w = do
  span_
    [ class_ "definition-link"
    , hx $ HxGet $ "/def/" <> def
    , hx $ HxTrigger Click
    , hx $ HxSwap Afterend
    ]
    w
