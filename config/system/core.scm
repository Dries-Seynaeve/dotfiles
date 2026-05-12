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
  #:use-module (config packages dwm-custom)
  ;; #:use-module (gnu packages suckless)
  #:export (core-packages))


(define core-packages
  (make-parameter (list htop
                        emacs-pgtk
                        ;;vim
                        git
                        ed
                        btop
                        openssh
                        openssl
                        clang
                        dbus
                        screen
                        tar
			dwm
                        zip
                        unzip
                        binutils
                        gmp
                        gcc
                        gcc-toolchain
                        curl
                        ripgrep
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
