import XMonad
import XMonad.Layout.Spacing
import XMonad.Prompt
import XMonad.Util.EZConfig

data MyPrompt = MyPrompt

instance XPrompt MyPrompt where
  showXPrompt s = "prompt>>>"

main :: IO ()
main =
  xmonad $
    def
      { modMask = mod4Mask,
        layoutHook = spacingWithEdge 10 $ layoutHook def
      }
      `additionalKeysP` [ ("M-f", spawn "firefox"),
                          ("M-<Return>", spawn "wezterm"),
                          ("M-a", mkXPrompt MyPrompt def compls process)
                        ]

compls :: ComplFunction
compls s = pure [s <> s]

process :: String -> X ()
process s = pure ()
