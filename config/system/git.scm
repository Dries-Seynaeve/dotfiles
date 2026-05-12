(define-module (config system git)
  #:use-module (gnu)
  #:use-module (config system configurator)
  #:export (gitconfig-personal gitconfig-work gitconfig git-capability)
  )

(define gitconfig-personal
  `((user (name . "Dries Seynaeve")
          (email . "d.sey@muren.io")
          (signingkey . "24F46738CE114AF6"))))

(define gitconfig-work
  `((user (name . "Dries Seynaeve")
          (email . "dries.seynaeve@kuleuven.be")
          (signingkey . "13D79892C3DC098A"))))

(define gitignore-global
  `("*~"))

(define gitconfig
  `((core (editor . "emacsclient")
          (excludesfile . "~/.gitignore-global"))
    (commit (gpgsign . "true"))
    (format (thread . "shallow"))
    (sendemail (thread . "no"))
    (pull (rebase . "false"))
    ("include" ("path" . "~/.gitconfig-work"))
    ;; ("includeIf \"gitdir:~/hacking/\"" ("  path" . "~/.gitconfig-personal"))
    ;; ("includeIf \"gitdir:~/fork/\"" ("  path" . "~/.gitconfig-personal"))
    ;; ("includeIf \"gitdir:~/scratch/\"" ("  path" . "~/.gitconfig-personal"))))
    ))



(define* (git-capability #:key (gitconfig gitconfig)
                         (gitconfig-personal gitconfig-personal)
                         (gitconfig-work gitconfig-work))
  `( ;Global Git configuration
     (".gitconfig" ,(plain-file "gitconfig.ini"
                                (make-conf-from-key-value-with-heading
                                 gitconfig
                                 #:template spaced-equal-conf-pair)))
    ;; Personal Git configuration
    (".gitconfig-personal" ,(plain-file "gitconfig-personal.ini"
                                        (make-conf-from-key-value-with-heading
                                         gitconfig-personal
                                         #:template spaced-equal-conf-pair)))
    ;; Work Git configuration
    (".gitconfig-work" ,(plain-file "gitconfig-work.ini"
                                    (make-conf-from-key-value-with-heading
                                     gitconfig-work
                                     #:template spaced-equal-conf-pair)))

    ;; Global Git ignore
    (".gitignore-global" ,(plain-file "gitignore-global"
                                      (mk-lines gitignore-global)))))
