(define-module (config system openpgp)
  #:use-module (gnu)
  #:use-module (gnu packages gnupg)
  #:use-module (gnu home services gnupg)
  #:export (openpgp-capability))


(define openpgp-capability
  (service home-gpg-agent-service-type
	   (home-gpg-agent-configuration (pinentry-program (file-append
							    pinentry-emacs
							    "/bin/pinentry-emacs"))
					 (ssh-support? #t))))
