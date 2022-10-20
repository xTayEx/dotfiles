import Data.Char (isSpace)
import Data.Foldable
import qualified Data.Map as M
import Data.Maybe
import Data.Ratio ((%))
import System.Exit
import System.IO
import XMonad
import XMonad.Actions.CycleWS
import XMonad.Actions.GridSelect
import qualified XMonad.Actions.Search as Sch
import XMonad.Actions.Submap
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.StatusBar.PP
import XMonad.Layout.Grid
import XMonad.Layout.IM
import XMonad.Layout.MultiColumns
import XMonad.Layout.NoBorders
import XMonad.Layout.PerWorkspace
import XMonad.Layout.Reflect
import XMonad.Layout.Spacing
import XMonad.Layout.Tabbed
import XMonad.Prompt
import XMonad.Prompt.ConfirmPrompt
import XMonad.Prompt.FuzzyMatch
import XMonad.Prompt.Pass
import qualified XMonad.StackSet as W
import XMonad.Util.EZConfig
import XMonad.Util.NamedScratchpad
import XMonad.Util.Run
import XMonad.Util.SpawnOnce
import XMonad.Util.XUtils

-- nord theme color
nordColor1 :: String
nordColor1 = "#8FBCBB"

nordColor2 :: String
nordColor2 = "#88C0D0"

nordColor3 :: String
nordColor3 = "#81A1C1"

nordColor4 :: String
nordColor4 = "#5E81AC"

myUsername :: String
myUsername = "xtayex"

myTerminal :: String
myTerminal = "kitty"

myModMask :: KeyMask
myModMask = mod4Mask

myFont :: String
myFont = "xft:FiraCode Nerd Font Mono:size=10,WenQuanYi Micro Hei:size=10"

myPromptFont :: String
myPromptFont = "xft:FiraCode Nerd Font Mono:size=13,WenQuanYi Micro Hei:size=13"

myTabbedFont :: String
myTabbedFont = "xft:FiraCode Nerd Font Mono:size=11,WenQuanYi Micro Hei:size=11"

myBrowser :: String
myBrowser = "microsoft-edge"

-- Color of current workspace in xmobar.
xmobarCurrentWorkspaceColor :: String
xmobarCurrentWorkspaceColor = nordColor3

xmobarTitleColor :: String
xmobarTitleColor = nordColor3

myFocusedBorderColor :: String
myFocusedBorderColor = nordColor2

lastN :: Int -> [a] -> [a]
lastN n xs = foldl' (const . drop 1) xs (drop n xs)

myTrim :: String -> String
myTrim = f . f
  where
    f = reverse . dropWhile isSpace

myShorten :: Int -> Int -> String -> String
myShorten prefixLength suffixLength s =
    if prefixLength + suffixLength < threshold
        then myTrim (take prefixLength s) ++
             "..." ++ myTrim (lastN suffixLength s)
        else s
  where
    threshold = length s - thresHelper
    thresHelper = min (length s) 5

myColorizer :: Window -> Bool -> X (String, String)
myColorizer =
    colorRangeFromClassName
        (0x28, 0x2c, 0x34) -- lowest inactive bg
        (0x28, 0x2c, 0x34) -- highest inactive bg
        (0x8f, 0xbc, 0xbb) -- active bg
                -- (0xc7,0x92,0xea) -- active bg
        (0xc0, 0xa7, 0x9a) -- inactive fg
        (0x28, 0x2c, 0x34) -- active fg

-- gridSelect menu layout
mygridConfig :: p -> GSConfig Window
mygridConfig colorizer =
    (buildDefaultGSConfig myColorizer)
        { gs_cellheight = 40
        , gs_cellwidth = 200
        , gs_cellpadding = 6
        , gs_originFractX = 0.5
        , gs_originFractY = 0.5
        , gs_font = myFont
        }

myTabbedConfig =
    def {inactiveColor = "#282C34", activeColor = nordColor3, fontName = myFont}

myWorkspaces :: [String]
myWorkspaces = clickable workspaceLabels
  where
    clickable l =
        [ "<action=xdotool key super+" ++
        show i ++ " button=1>" ++ ws ++ "</action>"
        | (i, ws) <- zip [1 .. 9] l
        ]
    workspaceLabels = zipWith makeLabel [1 .. 9 :: Int] icons
    makeLabel index (fontIndex, icon, subscpritIndex) =
        "  <fn=" ++ show fontIndex ++ ">" ++ icon ++ "</fn>" ++ subscpritIndex
    icons =
        [ (1, "\xf120", "₁") -- 1
        , (1, "\xf0ac", "₂") -- 2
        , (1, "\xf086", "₃") -- 3
        , (1, "\xf2b5", "₄") -- 4
        , (1, "\xf87c", "₅") -- 5
        , (1, "\xf001", "₆") -- 6
        , (1, "\xf1c2", "₇") -- 7
        , (5, "\xe632", "₈") -- 8
        , (5, "\xf4a2", "₉") -- 9
        ]

nonEmptyNonNSPws =
    WSIs (return (\ws -> isJust (W.stack ws) && W.tag ws /= "NSP"))

myAdditionalKeys :: [(String, X ())]
myAdditionalKeys =
    [ ("M-d", spawn "rofi -show drun -modi drun")
    , ( "M-S-d"
      , spawn "rofi -show combi -combi-modes \"run,drun,ssh\" -modes combi")
    , ("M-a", spawn "flameshot gui")
    , ("M-,", mySubmaps)
    , ("M-q", spawn "xmonad --recompile && pkill xmobar && xmonad --restart")
    , ("M-S-q", confirmPrompt def "exit" $ io exitSuccess)
    , ("M-S-s", spawn "rofi -show power-menu -modi power-menu:rofi-power-menu")
    , ("M-S-t", namedScratchpadAction myScratchpad "kitty")
    , ("M-f", goToSelected $ mygridConfig myColorizer)
    , ("M-S-l", moveTo Next nonEmptyNonNSPws)
    , ("M-S-h", moveTo Prev nonEmptyNonNSPws)
    , ("<XF86MonBrightnessUp>", spawn "lux -a 5%")
    , ("<XF86MonBrightnessDown>", spawn "lux -s 5%")
    , ("<XF86AudioMute>", spawn "pulseaudio-ctl mute")
    , ("<XF86AudioRaiseVolume>", spawn "pulseaudio-ctl up 2")
    , ("<XF86AudioLowerVolume>", spawn "pulseaudio-ctl down 2")
    ]

myUnusedKeys :: [String]
myUnusedKeys = ["M-p"]

myScratchpad :: [NamedScratchpad]
myScratchpad =
    [ NS "kitty"
          spawnTerm
          findTerm
          (customFloating $ W.RationalRect (1 / 6) (1 / 6) (2 / 3) (2 / 3))
    , NS "translate_to_zh"
          spawnTranslateZH
          findTranslate
          (customFloating $ W.RationalRect 0 0 (1 / 4) (2.5 / 3))
    , NS "translate_to_en"
          spawnTranslateEN
          findTranslate
          (customFloating $ W.RationalRect 0 0 (1 / 4) (2.5 / 3))
    ]
  where
    spawnTerm = myTerminal ++ " --title scratch_term"
    findTerm = title =? "scratch_term"
    spawnTranslateZH =
        myTerminal ++ " --title translate rlwrap trans_cli.py -t zh"
    spawnTranslateEN =
        myTerminal ++ " --title translate rlwrap trans_cli.py -t en"
    findTranslate = title =? "translate"

myStatusBar :: String
myStatusBar = "xmobar /home/" ++ myUsername ++ "/.config/xmobar/xmobar.hs"

-- myWallpaperPath :: String
-- myWallpaperPath = "matterhorn-mountain-from-alps-2560x1440_47459-mm-90.jpg"
-- myStartupHook :: X ()
-- myStartupHook = spawn "compton --config /home/xtayex/.config/compton.conf"
--                 >> spawn "feh --bg-fill /home/xtayex/Pictures/wallpapers/yunnan001.jpg"
myStartupHook :: X ()
myStartupHook
    -- spawnOnce "gnome-session"
 = do
    spawn ("picom --config /home/" ++ myUsername ++ "/.config/picom.conf")
    -- spawn ("feh --bg-fill /home/" ++ myUsername ++ "/Pictures/wallpapers/" ++ myWallpaperPath)
    spawnOnce
        ("/home/" ++
         myUsername ++
         "/.xmonad/scripts/change_wallpaper.sh " ++
         "/home/" ++ myUsername ++ "/Pictures/wallpapers")
    spawnOnce ("/home/" ++ myUsername ++ "/.config/offlineimap/runner.sh")
    spawnOnce
        ("/home/" ++
         myUsername ++
         "/Downloads/Clash.for.Windows-0.19.14-x64-linux/clash_launch.sh")
    spawn
        ("stalonetray --config /home/" ++ myUsername ++ "/.config/stalonetrayrc")

myLogHook :: Handle -> X ()
myLogHook xmproc
    -- fadeInactiveLogHook 0.80
 = do
    dynamicLogWithPP . filterOutWsPP [scratchpadWorkspaceTag] $
        xmobarPP
            { ppOutput = hPutStrLn xmproc
            , ppTitle = xmobarColor xmobarTitleColor "" . myShorten 10 10
        -- , ppTitle = xmobarFont 4
        -- , ppSep = " : "
            , ppCurrent = xmobarColor xmobarCurrentWorkspaceColor ""
            , ppWsSep = " \57521"
            , ppLayout =
                  (\layoutName ->
                       case layoutName of
                           "Spacing Tall" -> "Tall"
                           "Spacing Grid" -> "Grid"
                           "Spacing MultiCol" -> "MultiCol"
                           "Spacing Full" -> "Full"
                           "Spacing ReflectX Tall" -> "ReflectX Tall"
                           "Spacing Tabbed Simplest" -> "Tabbed")
            }

myLayout =
    spacingWithEdge 5 $
    avoidStruts $
    onWorkspace (myWorkspaces !! 2) layoutTabbed $
    layoutTall |||
    layoutGrid |||
    layoutReflect ||| layoutMultiColumns ||| layoutFull ||| layoutTabbed
  where
    layoutTall = smartBorders $ Tall 1 (3 / 100) (1 / 2)
    layoutGrid = smartBorders $ Grid
    layoutReflect = smartBorders $ reflectHoriz (Tall 1 (3 / 100) (1 / 2))
    layoutMultiColumns = smartBorders $ multiCol [1] 1 0.01 (-0.5)
    layoutFull = noBorders Full
    layoutTabbed = noBorders $ tabbed shrinkText myTabbedConfig

myManageHook :: ManageHook
myManageHook =
    composeAll
        [ manageHook def
        , manageDocks
        , namedScratchpadManageHook myScratchpad
        , title =? "yacpi" --> doFloat
        , title =? "Calendar" --> doFloat
        , title =? "htop" --> doFloat
        , title =? "nmtui" --> doFloat
        ]

myPromptXPConfig :: XPConfig
myPromptXPConfig =
    def
        { font = myPromptFont
        , position = CenteredAt 0.4 0.3
        , promptBorderWidth = 0
        , searchPredicate = fuzzyMatch
        , sorter = fuzzySort
        }

myVisualSubmapConfig =
    WindowConfig myPromptFont "#282C34" nordColor2 CenterWindow

myVisualSubmap = visualSubmap myVisualSubmapConfig

mySubmaps =
    myVisualSubmap . M.fromList $
    [ ( (0, xK_s)
    -- search
      , subName "Search" . myVisualSubmap . M.fromList $
        [ ( (0, xK_g)
          , subName "Search on google" $
            Sch.promptSearchBrowser myPromptXPConfig myBrowser Sch.google)
        , ( (0, xK_h)
          , subName "Search on hoogle" $
            Sch.promptSearchBrowser myPromptXPConfig myBrowser Sch.hoogle)
        , ( (0, xK_w)
          , subName "Search on wikipedia" $
            Sch.promptSearchBrowser myPromptXPConfig myBrowser Sch.wikipedia)
        ])
    -- translate
    , ( (0, xK_t)
      , subName "Translate" . myVisualSubmap . M.fromList $
        [ ( (0, xK_c)
          , subName "Translate to Chinese" $
            namedScratchpadAction myScratchpad "translate_to_zh")
        , ( (0, xK_e)
          , subName "Translate to English" $
            namedScratchpadAction myScratchpad "translate_to_en")
        ])
    -- pass
    , ( (0, xK_p)
      , subName "Password Management" . myVisualSubmap . M.fromList $
        [ ((0, xK_p), subName "Retrieve password" $ passPrompt myPromptXPConfig)
        , ( (0, xK_t)
          , subName "Autofill password" $ passTypePrompt myPromptXPConfig)
        , ( (0, xK_g)
          , subName "Generate a new password" $
            passGenerateAndCopyPrompt myPromptXPConfig)
        ])
    ]

main :: IO ()
main = do
    xmproc <- spawnPipe myStatusBar
    xmonad $
        docks . ewmhFullscreen . ewmh $
        def
            { terminal = myTerminal
            , modMask = myModMask
            , layoutHook = myLayout
            , manageHook = myManageHook
            , startupHook = myStartupHook
            , workspaces = myWorkspaces
            , logHook = myLogHook xmproc
            , focusedBorderColor = myFocusedBorderColor
            , borderWidth = 2
            } `additionalKeysP`
        myAdditionalKeys `removeKeysP`
        myUnusedKeys
