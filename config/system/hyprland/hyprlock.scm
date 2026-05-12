(define-module (config system hyprland hyprlock)
  #:use-module (gnu)
  #:use-module (config system hyprland hyprlang)
  #:export (hyprlock-config hyprlock-capability))



(define (hyprlock-capability)
  `((".config/hypr/hyprlock.conf" ,(plain-file "hyprlock.conf"
					       (hyprlock-config)))))
