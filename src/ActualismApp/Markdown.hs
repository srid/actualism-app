module ActualismApp.Markdown where

import ActualismApp.Definition qualified as Definition
import Commonmark.Simple qualified as CS
import Lucid
import Lucid.Base (makeAttributes)
import Text.Pandoc.Definition (Pandoc (Pandoc))
import Text.Pandoc.Definition qualified as P

md :: Text -> Html ()
md = renderMarkdown . parseMarkdown

parseMarkdown :: Text -> Pandoc
parseMarkdown s = do
  let res = CS.parseMarkdown "<>" s
  case res of
    Left e -> error $ show e
    Right (x :: Pandoc) -> x

renderMarkdown :: Pandoc -> Html ()
renderMarkdown (Pandoc _ blocks) =
  mapM_ go blocks
  where
    go = \case
      P.Para inlines -> do
        p_ $ do
          mapM_ goInline inlines
      P.Plain inlines -> do
        mapM_ goInline inlines
      P.Header level attr inlines -> do
        case level of
          1 -> h1_ (renderAttrs attr) $ mapM_ goInline inlines
          2 -> h2_ (renderAttrs attr) $ mapM_ goInline inlines
          3 -> h3_ (renderAttrs attr) $ mapM_ goInline inlines
          4 -> h4_ (renderAttrs attr) $ mapM_ goInline inlines
          5 -> h5_ (renderAttrs attr) $ mapM_ goInline inlines
          6 -> h6_ (renderAttrs attr) $ mapM_ goInline inlines
          _ -> error $ "unsupported header level: " <> show level
      P.BulletList xs -> do
        ul_ $ do
          forM_ xs $ \x -> do
            li_ $ do
              mapM_ go x
      P.HorizontalRule -> hr_ []
      P.Div attr xs -> do
        div_ (renderAttrs attr) $ mapM_ go xs
      P.BlockQuote xs -> do
        blockquote_ $ mapM_ go xs
      x -> error $ "unsupported block: " <> show x
    goInline = \case
      P.Space -> " " :: Html ()
      P.Quoted quote inlines -> do
        quoted quote
        mapM_ goInline inlines
        quoted quote
      P.Str s -> fromString . toString $ s
      P.Emph inlines -> do
        i_ $ mapM_ goInline inlines
      P.Strong inlines -> do
        b_ $ mapM_ goInline inlines
      P.Link attrs inlines (url, title) ->
        case Definition.parseDefinition url of
          Just def ->
            Definition.definitionLink def $ mapM_ goInline inlines
          Nothing ->
            a_ ([href_ url, title_ title] <> renderAttrs attrs) $ mapM_ goInline inlines
      P.Image attr _inlines (url, title) ->
        img_ ([src_ url, title_ title] <> renderAttrs attr)
      P.Span attr inlines ->
        span_ (renderAttrs attr) $ mapM_ goInline inlines
      x -> error $ "unsupported inline: " <> show x
    quoted = \case
      P.SingleQuote -> "'"
      P.DoubleQuote -> "\""

renderAttrs :: P.Attr -> [Attributes]
renderAttrs (ident, cls, attrs) =
  catMaybes $
    [ if ident == "" then Nothing else Just $ id_ ident
    , if null cls then Nothing else Just $ class_ $ unwords cls
    ]
      <> fmap (Just . uncurry makeAttributes) attrs
