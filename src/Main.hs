module Main where

import ActualismApp.Definition qualified as Definition
import ActualismApp.Markdown
import ActualismApp.Popup qualified as Popup
import ActualismApp.Style (style)
import Clay qualified as C
import Data.HashMap.Strict as Map
import Lucid
import Main.Utf8 qualified as Utf8
import Network.Wai.Middleware.RequestLogger (logStdout)
import Paths_actualism_app (getDataDir)
import Relude.Unsafe (fromJust)
import System.Directory (listDirectory)
import System.FilePath ((</>))
import Web.Scotty qualified as S

{- |
 Main entry point.

 `just run` will invoke this function.
-}
main :: IO ()
main = do
  -- For withUtf8, see https://serokell.io/blog/haskell-with-utf8
  Utf8.withUtf8 $ do
    defs <- loadDefinitions
    S.scotty 3000 $ do
      S.middleware logStdout
      S.get "/" $ do
        S.html $ renderText $ pageHome $ fromJust $ Map.lookup "index" defs
      Definition.definitionHandler defs
      Popup.popupHandler

loadDefinitions :: IO (HashMap Text (Html ()))
loadDefinitions = do
  contentDir <- getDataDir
  files <- listDirectory contentDir
  fmap Map.fromList $ forM files $ \file -> do
    let name = toText $ takeWhile (/= '.') file
    let path = contentDir </> file
    content <- decodeUtf8 <$> readFileBS path
    pure (name, renderMarkdown . parseMarkdown $ content)

pageHome :: Html () -> Html ()
pageHome index = do
  layout $ do
    index
    footer_ $ do
      "This website is a work in progress. To view recent changes, see the change history "
      a_ [href_ "https://github.com/srid/actualism-app/commits/master/content"] "here"
      "."

layout :: Html () -> Html ()
layout content = do
  doctype_
  html_ $ do
    head_ $ do
      meta_ [charset_ "utf-8", name_ "viewport", content_ "width=device-width, initial-scale=1"]
      title_ "Srid's Actualism Practice"
      -- reset css
      script_ [src_ "https://unpkg.com/htmx.org@2.0.3", integrity_ "sha384-0895/pl2MU10Hqc6jd4RvrthNlDiE9U1tWmX7WRESftEDRosgxNsQG/Ze9YMRzHq", crossorigin_ "anonymous"] $ fromString @Text ""
      link_ [rel_ "stylesheet", type_ "text/css", href_ "https://unpkg.com/modern-css-reset/dist/reset.min.css"]
      style_ "@import url('https://fonts.googleapis.com/css2?family=DM+Serif+Display:ital@0;1&family=EB+Garamond:ital,wght@0,400..800;1,400..800&family=Fira+Sans:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap');"
      style_ $ toStrict $ C.render style
    body_ $ do
      div_
        [class_ "container"]
        content
