module KS.Prompt where

import XMonad.Prompt

data CalcPrompt = CalcPrompt

instance XPrompt CalcPrompt where
  showXPrompt s = "calc> "
  commandToComplete = const id

config :: XPConfig
config =
  def
    { promptBorderWidth = 2,
      height = 32,
      historySize = 0,
      font = "xft:JuliaMono:size=12",
      bgColor = "#32302f",
      fgColor = "#ebdbb2",
      position = CenteredAt (1 / 2) (1 / 3),
      borderColor = "#689d6a"
    }

completionsTest :: ComplFunction
completionsTest s = pure [show (length s) <> ": " <> s]
