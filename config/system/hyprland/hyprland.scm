(define-module (config system hyprland hyprland)
  #:use-module (gnu)
  #:use-module (config system configurator)
  #:use-module (config system hyprland hyprlang)
  #:export (hyprland-capability hypr-startup-programs))









(define (hypr-binds)
  (append hypr-workspace-binds
	  hypr-movetoworkspace-binds
	  hypr-common-exec-binds
	  ))





(define hypr-look-and-feel
  `( ;; ($activeBorderColor . "rgba(33ccffee) rgba(00ff99ee) 45deg")
    ;; ($inactiveBorderColor . "rgba(595959aa)")
    (general
     (gaps_in . 5)
     (gaps_out . 10)
     (border_size . 2) 
     (col.active_border . "rgba(33ccffee) rgba(00ff99ee) 45deg")
     (col.inactive_border . "rgba(595959aa)")
     (layout . dwindle))
    (decoration (rounding . 8) ;; Using round window corners
		(shadow (enabled . "yes") ;; Strangly enough 0 = on, 1 = off
			(range . 2)
			(render_power . 3)
			(color . "rgba(1a1a1aee)")) 
		(blur (enabled . "yes")
		      (size . 2)
		      (passes . 2)
		      (special . "yes")
		      (brightness . 0.60)
		      (contrast . 0.75))
		)
    (group (col.border_active . "rgba(33ccffee) rgba(00ff99ee) 45deg")
	   (col.border_inactive . "rgba(595959aa)")
	   (col.border_locked_active . -1)
	   (col.border_locked_inactive . -1)
	   (groupbar (font_size . 12)
		     (font_family . monospace)
		     (font_weight_active . ultraheavy)
		     (font_weight_inactive . normal)
		     (indicator_height . 0)
		     (indicator_gap . 5)
		     (height . 22)
		     (gaps_in . 5)
		     (gaps_out . 0)
		     (text_color . "rgb(ffffff)")
		     (text_color_inactive . "rgba(ffffff90)")
		     (col.active . "rgba(00000040)")
		     (col.inactive . "rgba(00000020)")
		     (gradients . "yes")
		     (gradient_rounding . 0)
		     (gradient_round_only_edges . "no")))
    (animations (enabled . "yes")
		(bezier . "easeOutQuint,0.23,1,0.32,1")
		(bezier . "easeInOutCubic,0.65,0.05,0.36,1")
		(bezier . "linear,0,0,1,1")
		(bezier . "almostLinear,0.5,0.5,0.75,1.0")
		(bezier . "quick,0.15,0,0.1,1")
		(animation . "global, 1, 10, default")
		(animation . "border, 1, 5.39, easeOutQuint")
		(animation . "windows, 1, 4.79, easeOutQuint")
		(animation . "windowsIn, 1, 4.1, easeOutQuint, popin 87%")
		(animation . "windowsOut, 1, 1.49, linear, popin 87%")
		(animation . "fadeIn, 1, 1.73, almostLinear")
		(animation . "fadeOut, 1, 1.46, almostLinear")
		(animation . "fade, 1, 3.03, quick")
		(animation . "layers, 1, 3.81, easeOutQuint")
		(animation . "layersIn, 1, 4, easeOutQuint, fade")
		(animation . "layersOut, 1, 1.5, linear, fade")
		(animation . "fadeLayersIn, 1, 1.79, almostLinear")
		(animation . "fadeLayersOut, 1, 1.39, almostLinear")
		(animation .  "workspaces, 0, 0, ease"))
    (dwindle (single_window_aspect_ratio . "1 1")
	     (pseudotile . yes)
	     (preserve_split . yes)
	     (force_split . 2))
    (master (new_status . master))
    (misc (disable_hyprland_logo . "true")
	  (disable_splash_rendering . "true")
	  (focus_on_activate . "true")
	  (anr_missed_pings . 3)
	  ;; (on_focus_under_fullscreen . 1)
	  )
    (cursor (hide_on_key_press . "true"))
    ))





(define (hypr-startup-programs)
  (let* ((xs (append '()
		     `("waybar"
		       "nm-applet"
		       "emacs --daemon"
		       "swaybg -i ~/dotfiles/files/1.jpg"))))
	  xs))



(define* (hyprland-config #:key
			  (startup-programs (hypr-startup-programs)))
  (let* ((serialized-key-bindings (string-join (hypr-binds)))
	 (serialized-startup-programs (map (lambda (startup-item)
					     (serialize-hypr-setting "exec-once"
								     startup-item)) startup-programs))
	 (serialized-look-and-feel (hypr-generate-sections hypr-look-and-feel))
         (config-lines (append `("#====== My Personal Hyprland configuration ======"
				 "#"
				 "# auto-generated file, DO NOT EDIT!"
				 "")
			       `("# ====== Look and Feel ======" 
				 ,serialized-look-and-feel)
			       `("# ====== Startup programs ======")
			       serialized-startup-programs
			       `("" "# ====== General configuration ======")
			       `("" "# ====== Key bindings ======"
                                 ,serialized-key-bindings)
			       `(""
				 "misc {"
				 "    disable_hyprland_logo = true"  "}"
				 "# ====== End of My Hyprland configuration ======"
				 ""))))
    (string-join config-lines "\n")))




(define (hyprland-capability)
  `(; Hyperland configuration
    (".config/hypr/hyprland.conf" ,(plain-file "hyprland.conf"
					       (hyprland-config)
					       ))))



	   
      
(define hypr-movetoworkspace-binds
  (map (lambda (wm)
	 (serialize-hypr-setting 'bind
				 (hypr-bind #:mod "s-S"
					    #:bind (format #f "~a" wm)
					    #:dispatch 'movetoworkspacesilent
					    #:cmd (format #f "~a" wm))))
       '(1
	 2
	 3
	 4
	 5
	 6
	 7
	 8
	 9)))







;; (define* hypr-swap-binds
;;   (map (lambda (kb)
;; 	 (serialize-hypr_setting 'bind kb))
;;        (list (hypr-bind #:mod "s-S"
;; 			#:bind "Left"
;; 			#:cmd 'l
;; 			#:dispatch 'swapwindow)
;; 	     (hypr-bind #:mod "s-S"
;; 			#:bind "Right"
;; 			#:cmd 'r
;; 			#:dispatch 'swapwindow)
;; 	     (hypr-bind #:mod "s-S"
;; 			#:bind "Down"
;; 			#:cmd 'b
;; 			#:dispatch 'swapwindow)
;; 	     (hypr-bind #:mod "s-S"
;; 			#:mod "Up"
;; 			#:cmd 'u
;; 			#:dispatch 'swapwindow))))


;; (define* hypr-focus-binds
;;   (map (lambda (kb)
;;          (serialize-hypr-setting 'bind kb))
;;        (list (hypr-bind #:mod "s"
;;                         #:bind "Left"
;;                         #:cmd 'l
;;                         #:dispatch 'movefocus)
;;              (hypr-bind #:mod "s"
;;                         #:bind "Right"
;;                         #:cmd 'r
;;                         #:dispatch 'movefocus)
;;              (hypr-bind #:mod "s"
;;                         #:bind "Down"
;;                         #:cmd 'd
;;                         #:dispatch 'movefocus)
;;              (hypr-bind #:mod "s"
;;                         #:bind "Up"
;;                         #:cmd 'u
;;                         #:dispatch 'movefocus))))





(define hypr-workspace-binds
  (map (lambda (wm)
	 (serialize-hypr-setting 'bind
				 (hypr-bind #:mod "s"
					    #:bind (format #f "~a" wm)
					    #:dispatch 'workspace
					    #:cmd (format #f "~a" wm))))
       '(1
	 2
	 3
	 4
	 5
	 6
	 7
	 8
	 9)))




(define hypr-common-exec-binds
  (map (lambda (kb)
	 (serialize-hypr-setting 'bind kb))
       (list (special-bind #:mod "s"
                           #:bind "W"
                           #:dispatch 'killactive)
	     (special-bind #:mod "s"
			   #:bind "J"
			   #:dispatch 'togglesplit)
	     (special-bind #:mod "s"
			   #:bind "P"
			   #:dispatch 'pseudo)
             (special-bind #:mod "s"
                           #:bind "F"
                           #:dispatch 'fullscreen)
             (special-bind #:mod "s-S"
                           #:bind "Q"
                           #:dispatch 'exit)
             (special-bind #:mod "s-S"
                           #:bind "L"
                           #:dispatch 'forcerendererreload)
             (exec-bind #:mod "s"
                        #:bind "slash"
                        #:cmd "rofi -show drun")
             (exec-bind #:mod "s"
                        #:bind "E"
                        #:cmd "emacsclient -c")
             (exec-bind #:mod "s-S"
                        #:bind "E"
                        #:cmd "emacsclient -t")
	     (exec-bind #:mod "s"
                        #:bind "return"
                        #:cmd "alacritty msg create-window || alacritty")
	     (exec-bind #:mod "s-S"
			#:bind "space"
			#:cmd "/home/driess/Documents/Guix/menu")
	     (exec-bind #:mod "s"
			#:bind "L"
			#:cmd "hyprlock")
             ;; (hypr-bind #:mod "s-S"
             ;;            #:bind "space"
             ;;            #:dispatch "togglefloating"
             ;;            #:cmd "active")
             (hypr-bind #:mod "s-S"
                        #:bind "C"
                        #:dispatch "centerwindow"
                        #:cmd "")
             (hypr-bind #:mod "s"
                        #:bind "tab"
                        #:dispatch "cyclenext"
                        #:cmd ""))))
