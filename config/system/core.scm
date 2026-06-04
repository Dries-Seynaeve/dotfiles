(define-module (config system core)
  #:declarative? #t
  #:use-module (gnu packages admin)
  #:use-module (gnu packages base)
  #:use-module (gnu packages commencement)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages curl)
  #:use-module (gnu packages emacs)
  #:use-module (gnu packages file-systems)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages gdb)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages llvm)
  #:use-module (gnu packages multiprecision)
  #:use-module (gnu packages package-management)
  #:use-module (gnu packages rust-apps)
  #:use-module (gnu packages screen)
  #:use-module (gnu packages shellutils)
  #:use-module (gnu packages ssh)
  #:use-module (gnu packages text-editors)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages vim)
  #:use-module (gnu packages xorg)
  #:use-module (gnu)
  #:use-module (guix packages)
  #:use-module (config system wm)
  ;; #:use-module (gnu packages suckless)
  #:export (core-packages))

(define home-packages
  (make-parameter (list
		    htop
		    btop
		    ;; development
		    emacs
		    clang
		    gcc
                    gcc-toolchain
		    )))

(define core-packages
  (make-parameter (list emacs
                        vim
                        git
                        openssh
                        openssl
                        dbus
                        screen
			dries-dwm
			dries-st
                        zip
                        unzip
                        binutils
                        gmp
                        curl
			the-silver-searcher
                        net-tools
                        dstat
                        gsettings-desktop-schemas
                        glib
                        dconf
                        dconf-editor
                        (specification->package "make")
                        nix
                        coreutils
                        seatd
                        libseat
                        elogind
                        pango
                        cairo
                        ;; xorg-server
                        desktop-file-utils
                        direnv
                        exfatprogs
                        exfat-utils
                        gdb)))
