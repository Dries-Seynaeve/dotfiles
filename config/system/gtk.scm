(define-module (config system gtk)
  #:use-module (gnu)
  #:use-module (config system configurator)
  #:export (gtk3-capability))




(define (gtk3-config)
  ;; Key/value pairs that will make up the gtk3 configuration file
  `((gtk-enable-event-sounds . 0)
   (gtk-enable-input-feedback-sounds . 0)
   (gtk-cursor-theme-name . "Adwaita")
   (gtk-cursor-theme-size . 24)
   (gtk-application-prefer-dark-theme . 1)
  ))

(define (gtk4-config)
  ;; Key/value pairs that will make up the gtk4 configuration file
  `((gtk-enable-event-sounds . 0)
    (gtk-enable-input-feedback-sounds . 0)
    (gtk-cursor-theme-name . "Adwaita")
    (gtk-cursor-theme-size . 24)
    (gtk-application-prefer-dark-theme . 1)
  ))



(define (gtk3-capability)
  ;; Generates the configuration file for gtk3
  `((".config/gtk-3.0/settings.ini"
     ,(plain-file "settings.ini"
                  (string-append "[Settings]\n"
                                 (make-conf-from-key-value
                                  (gtk3-config)))))))
