module ActualismApp.Style where

import Clay
import Prelude (One (one), ($))

style :: Css
style = do
  body ? do
    fontFamily ["EB Garamond", "sans-serif"] []
    backgroundColor whitesmoke
    fontSize (px 19)
    padding (px 0) (px 0) (px 0) (px 0)
  blockquote ? do
    marginLeft (px 20)
    marginRight (px 20)
    paddingLeft (px 20)
    borderLeft (px 3) solid lightgray
    fontSize $ em 0.8
  div # ".container" ? do
    maxWidth (px 800)
    marginTop (px 40)
    marginLeft auto
    marginRight auto
    paddingLeft (px 20)
    paddingRight (px 20)
  div # ".box" ? do
    padding (px 20) (px 20) (px 20) (px 20)
    marginBottom (px 20)
    backgroundColor white
    border (px 1) solid black
    borderRadius (px 5) (px 5) (px 5) (px 5)
    boxShadow $ one $ bsColor darkslateblue $ shadow (px 7) (px 7)
  span # ".definition-link" ? do
    color blueviolet
    cursor pointer
    borderBottom (px 1) dotted blueviolet
  div # ".popup" ? do
    border (px 1) solid black
    backgroundColor cornsilk
    fontSize $ em 0.9
    borderRadius (px 5) (px 5) (px 5) (px 5)
    boxShadow $ one $ shadow (px 7) (px 7)
    padding (px 4) (px 8) (px 8) (px 8)
    span # ".popup-close" ? do
      cursor pointer
      float floatRight
      fontSize $ px 20
      ":hover" & do
        color red
        fontWeight bold
    div # ".popup-title" ? do
      fontWeight bold
      fontSize $ em 1.5
  "h1, h2, h3, h4, h5, h6" ? do
    fontFamily ["DM Serif Display", "serif"] []
    marginBottom (px 20)
  h1 ? do
    fontSize (px 48)
    textAlign center
  h2 ? do
    fontSize (px 36)
    color blueviolet
    borderRadius (px 5) (px 5) (px 5) (px 5)
    paddingBottom (px 8)
    paddingTop (px 8)
    paddingLeft (px 10)
    paddingRight (px 10)
    textAlign center
  p ? do
    marginTop (px 20)
    marginBottom (px 20)
  footer ? do
    marginTop (px 40)
    marginBottom (px 40)
    fontSize (px 14)
    textAlign center
