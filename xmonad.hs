import Data.Function ((&))
import qualified Data.Map
import qualified KS.Key
import qualified KS.Layout
import qualified KS.Prompt
import XMonad
import qualified XMonad.Actions.CycleWS
import qualified XMonad.Actions.Navigation2D
import qualified XMonad.Hooks.EwmhDesktops
import qualified XMonad.Hooks.ManageDocks
import XMonad.Layout (Tall)
import XMonad.Layout.LayoutModifier (ModifiedLayout)
import qualified XMonad.Layout.NoBorders
import XMonad.Layout.Spacing
import XMonad.Prompt
import qualified XMonad.StackSet
import XMonad.Util.EZConfig

startup :: X ()
startup =
  spawn "sct 3500"
    *> spawn "hsetroot -add '#32302f' -add '#689d6a' -gradient 0"
    *> spawn "! pgrep '^picom$' && picom --experimental-backends"
    *> spawn "! pgrep '^polybar$' && polybar -r main-top"
    *> spawn "! pgrep '^polybar$' && polybar -r main-bottom"

cfg :: XConfig KS.Layout.All
cfg =
  def
    { modMask = mod4Mask,
      terminal = "alacritty",
      layoutHook = KS.Layout.all,
      keys = KS.Key.bindings,
      normalBorderColor = "#32302f",
      focusedBorderColor = "#b8bb26",
      borderWidth = 4,
      workspaces = show <$> [1 .. 5],
      startupHook = startup,
      focusFollowsMouse = False
    }
    & XMonad.Hooks.EwmhDesktops.ewmhFullscreen
      . XMonad.Hooks.EwmhDesktops.ewmh
      . XMonad.Hooks.ManageDocks.docks
      . cardinalNav
  where
    cardinalNav =
      XMonad.Actions.Navigation2D.navigation2D
        (def {XMonad.Actions.Navigation2D.defaultTiledNavigation = XMonad.Actions.Navigation2D.sideNavigation})
        (xK_d, xK_a, xK_s, xK_h)
        [ (mod4Mask, XMonad.Actions.Navigation2D.windowGo),
          (mod4Mask .|. controlMask, XMonad.Actions.Navigation2D.windowSwap)
        ]
        False

main :: IO ()
main =
  xmonad cfg
