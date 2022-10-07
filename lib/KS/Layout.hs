module KS.Layout where

import XMonad (Window)
import XMonad.Hooks.ManageDocks (AvoidStruts, avoidStruts)
import XMonad.Layout (Choose, Full (Full), Tall (Tall), (|||))
import XMonad.Layout.LayoutModifier (ModifiedLayout)
import XMonad.Layout.NoBorders (WithBorder, noBorders)
import XMonad.Layout.Spacing (Spacing, spacingWithEdge)
import XMonad.Layout.Spiral (SpiralWithDir, spiral)

type TiledSide = ModifiedLayout AvoidStruts (ModifiedLayout Spacing Tall)

tiledSide :: TiledSide Window
tiledSide = avoidStruts . spacingWithEdge 4 $ Tall 1 (1 / 16) (2 / 3)

type FullScreen = ModifiedLayout WithBorder Full

fullScreen :: FullScreen Window
fullScreen = noBorders Full

type All = Choose TiledSide FullScreen

all :: All Window
all = tiledSide ||| fullScreen
