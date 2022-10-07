module KS.Key where

import Data.Map (Map, fromList)
import qualified KS.Prompt
import XMonad
import qualified XMonad.Actions.CycleWS
import qualified XMonad.Actions.SwapWorkspaces
import qualified XMonad.Prompt
import qualified XMonad.StackSet

bindings :: XConfig l -> Map (ButtonMask, KeySym) (X ())
bindings cfg = fromList bindingsList
  where
    mod = modMask cfg
    modCtrl = mod .|. controlMask

    wsKeys = [(xK_1, "1"), (xK_2, "2"), (xK_3, "3"), (xK_4, "4"), (xK_5, "5")]
    wsBindings (k, w) =
      [ ((mod, k), windows $ XMonad.StackSet.greedyView w),
        ((mod .|. shiftMask, k), windows (XMonad.Actions.SwapWorkspaces.swapWithCurrent w)),
        ((mod .|. controlMask, k), windows (XMonad.StackSet.greedyView w . XMonad.StackSet.shift w))
      ]

    bindingsList =
      [ --
        ((mod, xK_c), kill),
        ((mod, xK_z), sendMessage Shrink),
        ((mod, xK_x), sendMessage Expand),
        ((mod, xK_comma), sendMessage Shrink),
        ((mod, xK_period), sendMessage Expand),
        ((mod, xK_w), sendMessage NextLayout),
        ((modCtrl, xK_w), sendMessage NextLayout),
        --
        ((mod, xK_q), XMonad.Actions.CycleWS.prevWS),
        ((mod, xK_r), XMonad.Actions.CycleWS.nextWS),
        ((modCtrl, xK_q), XMonad.Actions.CycleWS.shiftToPrev *> XMonad.Actions.CycleWS.prevWS),
        ((modCtrl, xK_r), XMonad.Actions.CycleWS.shiftToNext *> XMonad.Actions.CycleWS.nextWS),
        ( (mod .|. shiftMask, xK_q),
          XMonad.Actions.SwapWorkspaces.swapTo
            XMonad.Actions.SwapWorkspaces.Prev
        ),
        ( (mod .|. shiftMask, xK_r),
          XMonad.Actions.SwapWorkspaces.swapTo
            XMonad.Actions.SwapWorkspaces.Next
        ),
        --
        ((mod, xK_Tab), windows XMonad.StackSet.focusDown),
        ((mod .|. shiftMask, xK_Tab), windows XMonad.StackSet.swapDown),
        ((modCtrl, xK_Tab), windows XMonad.StackSet.focusUp),
        ((modCtrl .|. shiftMask, xK_Tab), windows XMonad.StackSet.swapUp),
        ((mod, xK_space), windows XMonad.StackSet.focusMaster),
        ((mod .|. shiftMask, xK_space), windows XMonad.StackSet.swapMaster),
        --
        ((mod, xK_f), spawn "firefox"),
        ((mod, xK_Return), spawn $ terminal cfg),
        ((mod .|. shiftMask, xK_Return), spawn "rofi -modi run -show run"),
        ( (mod, xK_equal),
          XMonad.Prompt.mkXPrompt
            KS.Prompt.CalcPrompt
            KS.Prompt.config
            KS.Prompt.completionsTest
            (const $ pure ())
        ),
        --
        ((mod, xK_bracketleft), spawn "maim -su | xclip -t 'image/png' -selection 'clipboard'"),
        --
        ((mod, xK_Escape), restart ".cabal/bin/xmonad" True),
        ((modCtrl, xK_Escape), spawn "pkill xmonad"),
        --
        -- per <https://mail.haskell.org/pipermail/xmonad/2010-January/009535.html>
        -- XF86AudioLowerVolume
        ((0, 0x1008ff11), spawn "pamixer --decrease 5"),
        -- XF86AudioRaiseVolume
        ((0, 0x1008ff13), spawn "pamixer --increase 5"),
        -- XF86AudioMute
        ((0, 0x1008ff12), spawn "pamixer --toggle-mute")
      ]
        <> (wsKeys >>= wsBindings)
