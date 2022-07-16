module KS.Key where

import Data.Map (Map, fromList)
import qualified KS.Prompt
import XMonad
import qualified XMonad.Actions.CycleWS
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
        ((modCtrl, k), windows (XMonad.StackSet.greedyView w . XMonad.StackSet.shift w))
      ]

    bindingsList =
      [ ((mod, xK_f), spawn "firefox"),
        ((mod, xK_c), kill),
        ((mod, xK_r), XMonad.Actions.CycleWS.nextWS),
        ((mod, xK_q), XMonad.Actions.CycleWS.prevWS),
        ((modCtrl, xK_r), XMonad.Actions.CycleWS.shiftToNext *> XMonad.Actions.CycleWS.nextWS),
        ((modCtrl, xK_q), XMonad.Actions.CycleWS.shiftToPrev *> XMonad.Actions.CycleWS.prevWS),
        ((mod, xK_Return), spawn $ terminal cfg),
        ((mod, xK_space), spawn "rofi -modi run -show run"),
        ( (mod, xK_equal),
          XMonad.Prompt.mkXPrompt
            KS.Prompt.CalcPrompt
            KS.Prompt.config
            KS.Prompt.completionsTest
            (const $ pure ())
        ),
        ((mod, xK_Tab), windows XMonad.StackSet.focusDown),
        ((modCtrl, xK_Tab), sendMessage NextLayout),
        ((mod, xK_Escape), restart ".cabal/bin/xmonad" True),
        ((modCtrl, xK_Escape), spawn "pkill xmonad")
      ]
        <> (wsKeys >>= wsBindings)
