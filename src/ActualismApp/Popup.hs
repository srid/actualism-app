module ActualismApp.Popup where

import ActualismApp.Hx
import Lucid
import Web.Scotty qualified as S

popupHandler :: S.ScottyM ()
popupHandler = do
  S.get "/close" $ do
    S.text ""

popup :: Text -> Html () -> Html ()
popup title content = do
  div_ [class_ "popup"] $ do
    -- close button
    closeButton
    -- content
    div_ [class_ "popup-title"] $ fromString . toString $ title
    div_ [class_ "popup-content"] content

closeButton :: Html ()
closeButton = do
  span_
    [ class_ "popup-close"
    , title_ "Close"
    , hx $ HxGet "/close"
    , hx $ HxTrigger Click
    , hx $ HxSwap Delete
    , hx $ HxTarget "closest .popup"
    ]
    "×"
