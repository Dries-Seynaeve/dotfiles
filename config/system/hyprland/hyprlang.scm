(define-module (config system hyprland hyprlang)
  #:export (serialize-hypr-setting hypr-bind special-bind exec-bind hypr-generate-sections))


(define* (serialize-hypr-setting type setting)
  (format #f "~a = ~a" type setting))

;; (define x '("a" ("b" ("c" . "d"))))








(define (hypr-generate-sections sections)
  ;; Assumes we are giving a list of header/key-value
  (with-output-to-string (lambda ()
			   (for-each (lambda (x)
				       (display (generate-section (car x) (cdr x) "")))
				     sections))))





;; (define (hypr-generate-sections sections)
;;   ;; Assume we are given a list of header/key-values of header / (header / key-values)
;;   (with-output-to-string (lambda ()
;; 			   (for-each (lambda (x)
;; 				       (if (pair? (cadr x))
;; 					   (display (generate-section (car x) (cdr x) ))
;; 					   (display (format #f "~a {\n~a\n}\n" (car x) (hypr-generate-sections (cdr x)))) 
;; 					   ))
;; 				     sections))))





(define (generate-section header key-values whitespace)
  (with-output-to-string
    (lambda ()
      (display (format #f "~a {\n" header))
      (for-each (lambda (x)
		  (if (list? (cdr x))
		      (display (format #f "    ~a" (generate-section (car x) (cdr x) (string-append whitespace "   "))))
		      (display (format #f "~a    ~a = ~a\n" whitespace (car x) (cdr x)))))
		key-values)
      (display (format #f "~a}\n" whitespace))
      )))




(define (hypr-translate-mod mod)
  (cond
    ((equal? "s" mod)
     "SUPER")
    ((equal? "s-S" mod)
     "SUPER_SHIFT")
    ((equal? "M" mod)
     "ALT")
    (else mod)))


(define (hypr-translate-bind bind)
  (cond
    ((equal? "mouse-left" bind)
     "mouse:272")
    ((equal? "mouse-right" bind)
     "mouse:273")
    (else bind)))




(define* (hypr-bind #:key bind dispatch
                    (cmd "")
                    (mod ""))
  (format #f
          "~a, ~a, ~a, ~a\n"
          (hypr-translate-mod mod)
          (hypr-translate-bind bind)
          dispatch
          cmd))




(define* (special-bind #:key bind dispatch
                       (mod ""))
  (format #f "~a, ~a, ~a\n"
          (hypr-translate-mod mod)
          (hypr-translate-bind bind) dispatch))


(define* (exec-bind #:key bind
                    (cmd "")
                    (mod ""))
  (hypr-bind #:bind bind
             #:dispatch 'exec
             #:cmd cmd
             #:mod mod))


