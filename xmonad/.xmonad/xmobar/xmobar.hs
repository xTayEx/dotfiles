Config {
    font = "xft:FiraCode Nerd Font Mono:size=10,WenQuanYi Micro Hei:size=10",
    additionalFonts = [
        "xft:Font Awesome 6 Free Solid:size=10",
        "xft:Font Awesome 6 Brands Regular:size=10",
        "xft:Font Awesome 6 Free Regular:size=10",
        "xft:Microsoft Yahei:size=10"
    ],
    alpha = 100,
    bgColor = "#2E3440",
    fgColor = "#D8DEE9",
    iconRoot = "/home/xtayex/.config/xmobar/icons/", 
    border = NoBorder,
    position = TopSize C 100 24,
    lowerOnStart = True,
    allDesktops = True,
    commands = [
        -- Run Com "echo" ["<fn=2>\xf17c</fn>"] "penguin" 3600,
        Run Date " <action=`gnome-calendar` button=1><fn=1>\xf073</fn> %a %_d %b <fn=1>\xf017</fn> %H:%M</action>" "date" 10, 
        Run UnsafeStdinReader,
        Run Cpu
            [ "--template", "<action=`kitty --title htop -e htop` button=1><fn=1>\xf2db</fn> <total>%</action>",
              "-L", "3",
              "-H", "50",
              "--low", "#A3BE8C",
              "--normal", "#EBCB8b",
              "--high", "#BF616A"
            ] 10,
        Run Memory ["-t", "<action=`kitty --title htop -e htop` button=1><fn=1>\xf538</fn></action> <usedratio>%","-L","30","-H","80","--low","#A3BE8C","--normal","#EBCB8b","--high","#BF616A"] 10,
        Run Wireless "wlp3s0" [ "-t", "<action=`kitty --title nmtui -e nmtui` button=1><fn=1>\xf1eb</fn> <essid></action>" ] 10,
        -- Run Battery [
        --     "-t", "<action=`kitty --title yacpi -e yacpi` button=1><acstatus></action>",
        --     "--Low", "20",
        --     "--High", "80",
        --     "--high", "#A3BE8C",
        --     "--low", "#BF616A",
        --     "--",
        --     "-O", "<leftipat> <left>%",
        --     "-o", "<leftipat> <left>%",
        --     "-i", "<leftipat> <left>%",
        --     "--on-icon-pattern", "<fn=1>\xf1e6</fn>",
        --     "--off-icon-pattern", "<fn=1>\xf240</fn>",
        --     "--idle-icon-pattern", "<fn=1>\xf240</fn>"
        -- ] 10,
        Run Com "/home/xtayex/.config/xmobar/cpu_temp.sh" [] "cpu_temp" 10,
        Run Com "/home/xtayex/.config/xmobar/volume.sh" [] "volume" 5,
        Run Com "/home/xtayex/.config/xmobar/brightness.sh" [] "brightness" 5,
        Run Com "/home/xtayex/.config/xmobar/fan.sh" [] "fan" 10,
        Run Com "/home/xtayex/.config/xmobar/uptime.py" [] "uptime" 10,
        Run Com "/home/xtayex/.config/xmobar/xpm_icon.sh" [] "tray_space" 1,
        Run Com "/home/xtayex/.config/xmobar/battery.py" [] "mybattery" 10,
        Run Com "/home/xtayex/.config/xmobar/netease_cloud_music.sh" ["--all"] "netease" 10
    ],
    sepChar = "%", 
    alignSep = "}{", 
    template = "%UnsafeStdinReader% %netease% } %date% { %uptime%  %cpu% %cpu_temp% %fan%  %memory%  %wlp3s0wi%  %volume% %brightness%  %mybattery%%tray_space% "
}
