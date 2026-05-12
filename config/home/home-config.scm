(use-modules (gnu)
             (gnu home)
             (gnu home services)
             (gnu home services shells)
             (gnu home services dotfiles)
	     (gnu services xorg)
	     (gnu services desktop)
	     (guix ui)
	     ;; (xlibre)
	     (guix gexp)
             (config system configurator)
             (config system gtk)
             (config system git)
             (config system waybar)
	     (config system openpgp)
             (config system hyprland hyprland))



;; XLIBRE - Simple configuration
;; (define my-xlibre-config
;;   (xlibre-configuration
;;     (modules (list xlibre-video-amdgpu xlibre-input-libinput))
;;     (drivers '("amdgpu"))
;;     (keyboard-layout (keyboard-layout "br"))))



(define my-home-files-service
  (service home-files-service-type
           (append (gtk3-capability)
                   (git-capability)
                   (waybar-capability)
                   (hyprland-capability)
)))




(home-environment
 ;; Packages that are defined in our home environment
 (packages (specifications->packages
            (list "git"
                  "emacs-no-x-toolkit"
		  "emacs-pinentry"
		  "emacs-all-the-icons"
		  "emacs-counsel"
		  "emacs-ivy-rich"
		  "emacs-ivy-clipmenu"
		  "emacs-ivy-posframe"
		  "emacs-slack"
		  "emacs-ledger-mode"
		  "ledger"
                  "waybar"
		  ;; "xlibre-server"
		  ;; "xlibre-input-libinput"
		  "hyprlock"
		  "the-silver-searcher"
		  "python-lsp-server"
		  "pipewire"
		  "wireplumber"
		  ;; Software development
		  "cppcheck"
                  )))
 (services (list (service home-bash-service-type 
                          (home-bash-configuration
                           ;; This defines environment variable in our .bash_profile file [run once at long for every session]
                           (environment-variables '(("PS1" . "\\[\\e[1;32m\\]\\u \\[\\e[1;34m\\]\\w \\[\\e[0m\\]☯ ")
                                                    ("EDITOR" . "emacsclient")
						    ("BOOST_ROOT" . "$HOME/.guix-profile/include")))
                           ;; This defines alias in our .bashrc file [run every time we open a terminal]
                           (aliases '(("gs" . "git status")
				      ("reconfigure" . "guix home reconfigure -L ~/dotfiles ~/dotfiles/config/home/home-config.scm")
				      ))))
                 ;; This will symbolically link the files from ../../files in the $HOME directory
                 (service home-dotfiles-service-type
                          (home-dotfiles-configuration
                           (directories '("../../files"))))
                 my-home-files-service
		 openpgp-capability
                 )
	   ))

