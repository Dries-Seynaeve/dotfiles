(define-module (config system wm)
  #:declarative? #t
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system gnu)
  #:use-module (guix gexp)
  #:use-module (guix utils)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages fontutils)
  #:use-module (guix download)
  #:use-module (gnu packages ncurses)
  #:use-module (gnu packages xorg))

;; Packages we need:
;;- dwm
;;- menu
;;- feh

(define-public dwm
  (package
    (name "dwm")
    (version "6.8")
    (synopsis "Personal configuration of the Dynamic Window Manager")
    (source (origin
	      (method git-fetch)
	      (uri (git-reference
		     (url "https://github.com/Dries-Seynaeve/dwm-custom.git")
		     (commit "HEAD")))
	    (file-name (git-file-name name version))
	    (sha256
	     (base32 "1wp37da4bys56d01hgp3y6cs2msdwqqvpd60xn2h9sz8bm7q1ifs"))))
    (build-system gnu-build-system)
    (arguments
     (list
      #:tests? #f
      #:make-flags
      #~(list
	 (string-append "CC=" #$(cc-for-target))
	 "PREFIX="
	 (string-append "DESTDIR=" #$output)
	 (string-append "FREETYPEINC="
			#$(this-package-input "freetype")
			"/include/freetype2"))
      #:phases
      #~(modify-phases %standard-phases
	  (delete 'configure)
	  (add-after 'build 'install-xsession
	    (lambda _
	      ;; Add a .desktop file to xsessions.
	      (let ((apps (string-append #$output "/share/xsessions")))
		(mkdir-p apps)
		(make-desktop-entry-file
		 (string-append apps "/dwm.desktop")
		 #:name "dwm"
		 #:generic-name #$synopsis
		 #:exec (string-append #$output "/bin/dwm")
		 #:comment
		 `(("en" ,#$synopsis)
		   (#f ,#$synopsis)))))))))
    (inputs
     (list freetype libx11 libxft libxinerama))
    (home-page "https://dwm.suckless.org/")
    (description
     "dwm is a dynamics window manager for X. It manages windows in tiled, monocle and
floating layouts (by default). This is my configuration of the dwm system.")
    (license license:x11)))


;; Still to edit

(define-public st
  (package
    (name "st")
    (version "0.9.3")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://dl.suckless.org/st/st-"
                           version ".tar.gz"))
       (sha256
        (base32 "16v4dsjrsh5jwah38ygg8808zc536szwxj1qxm6kswgdrnmzxncy"))))
    (build-system gnu-build-system)
    (arguments
     (list
      #:tests? #f                      ;no tests
      #:make-flags
      #~(list
         (string-append "CC=" #$(cc-for-target))
         (string-append "TERMINFO=" #$output "/share/terminfo")
         (string-append "PREFIX=" #$output))
      #:phases
      #~(modify-phases %standard-phases
          (delete 'configure))))
    (inputs
     (list libx11
           libxft
           fontconfig
           freetype))
    (native-inputs
     (list ncurses ;provides tic program
           pkg-config))
    (home-page "https://st.suckless.org/")
    (synopsis "Simple terminal emulator")
    (description
     "St implements a simple and lightweight terminal emulator.  It
implements 256 colors, most VT10X escape sequences, utf8, X11 copy/paste,
antialiased fonts (using fontconfig), fallback fonts, resizing, and line
drawing.")
    (license (list license:x11
                   license:expat))))





(define-public tabbed
  (package
    (name "tabbed")
    (version "0.9")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://dl.suckless.org/tools/tabbed-"
                           version ".tar.gz"))
       (sha256
        (base32 "1a0842lw666cnx5mx2xqqrad4ipvbz4wxad3pxpyc6blgd2qgkqa"))))
    (build-system gnu-build-system)
    (arguments
     (list
      #:tests? #f                      ; no check target
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'unpack 'patch
            (lambda* (#:key inputs outputs #:allow-other-keys)
              (substitute* "Makefile"
                (("/usr/local") #$output)
                (("/usr/X11R6") #$(this-package-input "libx11"))
                (("/usr/include/freetype2")
                 (string-append #$(this-package-input "freetype")
                                "/include/freetype2"))
                (("\\$\\{CC\\}")
                 (string-append #$(cc-for-target))))))
          (delete 'configure))))         ; no configure script
    (inputs
     (list fontconfig
           freetype
           libx11
           libxft))
    (home-page "https://tools.suckless.org/tabbed/")
    (synopsis "Tab interface for application supporting Xembed")
    (description "Tabbed is a generic tabbed frontend to xembed-aware
applications.  It was originally designed for surf but also usable with many
other applications, i.e., st, uzbl, urxvt and xterm.")
    (license
     ;; Dual-licensed.
     (list
      license:expat
      license:x11))))

(define-public slstatus
  (package
    (name "slstatus")
    (version "1.1")
    (source
     (origin
       (method git-fetch)
       (uri
        (git-reference
          (url "git://git.suckless.org/slstatus")
          (commit version)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1bxmhvagmlqjyi9ws8i71r0k7fd6fg8286zv2b5zkcjhkayyh41i"))))
    (build-system gnu-build-system)
    (arguments
     (list
      #:tests? #f                    ;no test suite
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'unpack 'patch
            (lambda* (#:key inputs outputs #:allow-other-keys)
              (substitute* "config.mk"
                (("/usr/local") #$output)
                (("/usr/X11R6") #$(this-package-input "libx11"))
                (("CC = cc")
                 (string-append "CC = " #$(cc-for-target))))))
          (delete 'configure))))       ;no configure script
    (inputs (list libx11))
    (home-page "https://tools.suckless.org/slstatus/")
    (synopsis "Status monitor for window managers")
    (description "SlStatus is a suckless status monitor for window managers
that use WM_NAME or stdin to fill the status bar.
It provides the following features:
@itemize
@item Battery percentage/state/time left
@item CPU usage
@item CPU frequency
@item Custom shell commands
@item Date and time
@item Disk status (free storage, percentage, total storage and used storage)
@item Available entropy
@item Username/GID/UID
@item Hostname
@item IP address (IPv4 and IPv6)
@item Kernel version
@item Keyboard indicators
@item Keymap
@item Load average
@item Network speeds (RX and TX)
@item Number of files in a directory (hint: Maildir)
@item Memory status (free memory, percentage, total memory and used memory)
@item Swap status (free swap, percentage, total swap and used swap)
@item Temperature
@item Uptime
@item Volume percentage
@item WiFi signal percentage and ESSID
@end itemize")
    (license license:isc)))

(define-public blind
  (package
    (name "blind")
    (version "1.1")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://dl.suckless.org/tools/blind-"
                                  version ".tar.gz"))
              (sha256
               (base32
                "0nncvzyipvkkd7zlgzwbjygp82frzs2hvbnk71gxf671np607y94"))))
    (build-system gnu-build-system)
    (arguments
     (list
      #:tests? #f                      ; no check target
      #:make-flags
      #~(list (string-append "CC=" #$(cc-for-target))
              (string-append "PREFIX=" #$output))
      #:phases
      #~(modify-phases %standard-phases
          (delete 'configure))))         ; no configure script
    (synopsis "Command line video editing utilities")
    (home-page "https://tools.suckless.org/blind/")
    (description
     "Blind is a collection of command line video editing utilities.  It uses
a custom raw video format with a simple container.")
    (license license:isc)))
