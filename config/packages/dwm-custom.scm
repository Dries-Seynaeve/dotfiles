(define-module (config packages dwm-custom)
  #:use-module (guix packages)                      
  #:use-module (guix git-download)                  
  #:use-module (guix build-system gnu)              
  #:use-module (guix gexp)                          
  #:use-module (guix utils)                         
  #:use-module ((guix licenses) #:prefix license:)  
  #:use-module (gnu packages fontutils)             
  #:use-module (gnu packages xorg))                  



(define-public dwm
  (package
    (name "dwm")
    (version "6.8")
    (synopsis "Personal configuration of the Dynamic Window Manager")
    (source (origin
	      (method git-fetch)
	      (uri (git-reference
		     (url "https://github.com/Dries-Seynaeve/dwm-custom.git")
		     (commit "86bf8e0")))
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
