;; This module generates configuration files for specific software. 
(define-module (config system configurator)
  #:use-module (gnu services configuration)  
  #:export (make-conf-from-key-value
            make-conf-from-key-value-with-heading
            serialize-configuration-with-heading-from-item
            spaced-equal-conf-pair
            mk-lines
	    mk-css-conf-lines))



(define* (make-conf-from-key-value pairs #:key (template "~a=~a\n"))
  ;; This functions returns lines for a config file from key-value pairs.
  ;; The template can control the format of how the key/values should be
  ;; incorporated into the configuration file. 
  (with-output-to-string (lambda ()
                           (for-each
                            (lambda (x)
                              (display (format #f template
                                               (car x)
                                               (cdr x))))
                            pairs)))
  )



(define* (make-conf-from-key-value-with-heading pair
                                                #:key (template "~a=~a\n"))
  ;; This function generates a configuration file from an alist. The alist
  ;; will be of the form [(header . alist)] or alist.
  (with-output-to-string
    (lambda ()
      (for-each (lambda (item)
                  (serialize-configuration-with-heading-from-item
                   template item))
                pair))))


(define (serialize-configuration-with-heading-from-item template item)
  ;; Item should either be a tuple of the form (header . alist) or
  ;; and (key . value) pair.
  (cond
   ;; If the cdr is an alist (item is of the form (header, alist))
   ((alist? (cdr item))
    (cond
     ;; We can add the key as a header in the configuration
     ((string? (car item))
      (display (string-append "\n["
                              (car item) "]\n")))
     (else (display (string-append "\n["
                                   (symbol->string (car item)) "]\n"))))
    ;; And then we add the alist to the configuraiton
    (display (make-conf-from-key-value-with-heading (cdr item)
                                                    #:template template)))
   ;; If the cdr is not an alist, we can assume it is a key value pair and
   ;; add simply append them according to the template.
   (else (display (format #f template
                          (car item)
                          (cdr item))))))



(define spaced-equal-conf-pair
  "~a = ~a\n")

(define (mk-lines items)
  (with-output-to-string (lambda ()
                           (for-each (lambda (x)
                                       (display (format #f "~a\n" x))) items)
)))


(define* (mk-css-conf-lines pairs)
  "Create a CSS coniguration from PAIRS, a selector to values alist"
  (with-output-to-string (lambda ()
			   (for-each (lambda (x)
				       (display (format #f "~a {\n"
							(car x)))
				       (display (make-conf-from-key-value (cdr x)
									  #:template
									  "  ~a: ~a;\n"))
				       (display "}\n\n")) pairs ))))
				       
