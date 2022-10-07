import Data.Function ((&))
import qualified Data.Map
import qualified KS.Key
import qualified KS.Layout
import XMonad
import qualified XMonad.Actions.Navigation2D
import qualified XMonad.Hooks.EwmhDesktops
import qualified XMonad.Hooks.ManageDocks
import qualified XMonad.Hooks.TaffybarPagerHints
import qualified XMonad.Layout.IndependentScreens
import qualified XMonad.StackSet
import XMonad.Util.EZConfig

startup :: X ()
startup =
  spawn "autorandr -c"
    *> spawn "sct 3500"
    *> spawn "hsetroot -solid '#282828'"
    *> spawn "! pgrep '^picom$' && picom --experimental-backends"
    *> spawn "! pgrep '^fcitx5$' && fcitx5"
    -- *> spawn "! pgrep '^polybar$' && polybar -r main-top"
    -- *> spawn "! pgrep '^polybar$' && polybar -r main-bottom"

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
      . XMonad.Hooks.TaffybarPagerHints.pagerHints
      . cardinalNav
  where
    andGo f dir wrap = f dir wrap >> XMonad.Actions.Navigation2D.screenGo dir wrap

    cardinalNav =
      XMonad.Actions.Navigation2D.navigation2D
        ( def
            { XMonad.Actions.Navigation2D.defaultTiledNavigation =
                XMonad.Actions.Navigation2D.sideNavigation
            }
        )
        (xK_d, xK_a, xK_s, xK_h)
        [ (mod4Mask, XMonad.Actions.Navigation2D.windowGo),
          (mod4Mask .|. shiftMask, XMonad.Actions.Navigation2D.windowSwap),
          (mod4Mask .|. mod1Mask .|. controlMask, andGo XMonad.Actions.Navigation2D.windowToScreen),
          (mod4Mask .|. mod1Mask, XMonad.Actions.Navigation2D.screenGo),
          (mod4Mask .|. mod1Mask .|. shiftMask, andGo XMonad.Actions.Navigation2D.screenSwap)
        ]
        False

main :: IO ()
main =
  xmonad cfg
