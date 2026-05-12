(define-module (config system waybar)
  #:use-module (gnu)
  #:use-module (config system configurator)
  #:use-module (json)
  #:export (waybar-audio-icon waybar-capability ))





(define (waybar-conf)
  (let ((modules-left #(custom/start-button hyprland/workspaces))
        (modules-right #(group/tray-expander bluetooth network
                                             pulseaudio cpu battery))
        (modules-center #(clock)))
    `(,custom/reload
      (layer . top)
      (position . top)
      (spacing . 0)
      (height . 32)
      (modules-left unquote modules-left)
      (modules-center unquote modules-center)
      (modules-right unquote modules-right)
      ,waybar-hyprland-workspaces
      ,(waybar-start-button)
      (cpu (format . "\uf2db")
           (on-click . "exec firefox")) ;; Should still implement to get gtop
      ,waybar-clock
      ,network
      ,waybar-battery
      ,bluetooth
      ,waybar-audio-icon
      ,group/tray-expander
      ,custom/expand-icon
      (tray (spacing . 17)
            (icon-size . 12))
      )))



(define (waybar-capability)
  `( ;Waybar configuration (for status bar)
    (".config/waybar/config.jsonc" ,(plain-file "config.jsonc"
                                                (scm->json-string (waybar-conf))))
    (".config/waybar/style.css" ,(plain-file "waybar.css"
					     (mk-css-conf-lines (waybar-css))))
     ))




(define* (waybar-start-button #:key (content "☯"))
  `(custom/start-button (format unquote content)
                        (on-click . "rofi -show drun")
			(tooltip-format . "Custom Menu (should still implement)\n\nSuper + Alt + Space")
			))


(define waybar-clock
  `(clock (format . "{:L%A %H:%M}")
          (tooltip-format . "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>")
          (on-click-right . "gnome-calendar")
  ))

(define waybar-battery
  `(battery (states (warning . 30)
                    (critical . 15))
            (format . "{capacity}% {icon}")
            (format-discharging . "{icon}")
            (format-charging . "{icon}")
            (format-plugged . "")
            (format-icons . #("\uf244" "\uf243" "\uf242" "\uf241" "\uf240"))
            ))

(define bluetooth
  `(bluetooth (format . "")
	      (format-disabled . "")
	      (format-connected . "")
	      (format-no-controller . "")
              (tooltip-format . "Devices connected: {num_connections}")
              ))

(define waybar-audio-icon
  `(pulseaudio (format . "{icon}")
               (format-bluetooth . "{volume}% {icon}\uf294 {format_source}")
               (format-bluetooth-muted . "\uf6a9 {icon}\uf294 {format_source}")
               (format-muted . "\uf6a9 {format_source}")
               (format-source . "{volume}% \uf130")
               (format-source-muted . "\uf131")
               (format-icons (headphone . "\uf025")
                             (hands-free . "\uf590")
                             (headset . "\uf590")
                             (phone . "\uf095")
                             (portable . "\uf095")
                             (car . "\uf1b9")
                             (default . #("\uf026" "\uf027" "\uf028")))
               (on-click . "pavucontrol")))



(define waybar-hyprland-workspaces
  `(hyprland/workspaces (on-clock . activate)
			(format . "{icon}")
                        (format-icons ("1" . "1")
                                      ("2" . "2")
                                      ("3" . "3")
                                      ("4" . "4")
                                      ("5" . "5")
                                      ("6" . "6")
                                      ("7" . "7")
                                      ("8" . "8")
                                      ("9" . "9")
                                      ("10" . "0")
                                      ("default" . "\uf111")
                                      ("active" . "\uf111"))
                        (persistent-workspaces ("1" . "[]")
                                               ("2" . "[]")
                                               ("3" . "[]")
                                               ("4" . "[]")
                                               ("5" . "[]"))
                        ))


(define group/tray-expander
  `(group/tray-expander ("orientation" . "inherit")
                        (drawer ("transition-duration" . 600)
                                ("children-class" . "tray-group-item"))
                        (modules . #("custom/expand-icon" "tray"))))


(define custom/expand-icon
  `(custom/expand-icon   ("format"  . "")
                         ("tooltip" . #f)
                         ("on-scroll-up" . "")
                         ("on-scroll-down". "")
                         ("on-scroll-left". "")
                         ("on-scroll-right". "")))

(define custom/reload
  `(reload_style_on_change . #t))


(define network
  `(network (format-icons        . #("󰤯" "󰤟" "󰤢" "󰤥" "󰤨"))
            (format              . "{icon}")
            (format-wifi         . "{icon}")
            (format-ethernet     . "󰀂")
            (format-disconnected . "󰤮")
            (tooltip-format-wifi . "{essid} ({frequency} GHz)\n⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}")
            (tooltip-format-ethernet . "⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}")
            (tooltip-format-disconnected . "Disconnected")
            (interval . 3)
            (spacing . 1)))

            

(define (waybar-css)
  `((* (background-color . "#0B0C16" )
       (color . "#ddf7ff" )
       (border . none)
       (border-radius . 0)
       (min-height . 0)
       (font-family . "JetBrainsMono Nerd Font")
       (font-size . "12px"))
    (.modules-left (margin-left . "8px"))
    (.modules-right (margin-right . "8px"))
    ( "#workspaces button" (all . initial)
      (padding . "0 6px")
      (margin . "0 1.5px")
      (min-width . "9px"))
    ("#workspaces button.empty" (opacity . 0.5))
    ("#cpu" (min-width . "12px") (margin . "0 7.5px"))
    ("#battery" (min-width . "12px") (margin . "0 7.5px"))
    ("#pulseaudio" (min-width . "12px") (margin . "0 7.5px"))
    ("#tray" (margin-right . "16px"))
    ("#bluetooth" (margin-right . "17px"))
    ("#network" (margin-right . "13px"))
    ("#custom-expand-icon" (margin-right . "18px"))
    ("#tooltip" (padding . "2px"))
    ("#clock" (margin-left . "8.75px"))
    (.hidden (opacity . 0))
))	     


		     

