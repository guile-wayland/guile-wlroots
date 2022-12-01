(define-module (wlroots backend)
  #:use-module (wlroots types)
  #:use-module (wlroots config)
  #:use-module (wlroots utils)
  #:use-module (wayland util)
  #:use-module (wayland signal)
  #:use-module (wayland display)
  #:use-module ((system foreign) #:prefix ffi:)
  #:use-module (oop goops)
  #:use-module (bytestructures guile)
  #:export (wlr-backend-autocreate
            unwrap-wlr-backend
            wrap-wlr-backend
            wlr-backend-start
            wlr-backend-destroy))
;; (define ffi:int (@ (system foreign) int))
;; (define (wlr->pointer name)
;;   (dynamic-func name (dynamic-link %libwlroots)))
;; (define (wlr->procedure return name params)
;;   (let ((ptr (wlr->pointer name)))
;;     (pointer->procedure return ptr params)))

(define-class <wlr-backend> ()
  (bytestructure #:accessor .bytestructure #:init-keyword #:bytestructures))


(define %wlr-backend-struct
  (bs:struct
   `((wlr-backend-impl ,(bs:pointer '*))
     (events ,(bs:struct
               `((destroy ,%wl-signal-struct)
                 (new-input ,%wl-signal-struct)
                 (new-output ,%wl-signal-struct)))))))
(define (wrap-wlr-backend p)
  (make <wlr-backend> #:bytestructures (pointer->bytestructure p %wlr-backend-struct)))
(define (unwrap-wlr-backend o)
  (bytestructure->pointer (.bytestructure o)))

(define-method (get-event-signal (b <wlr-backend>) (signal-name <symbol>))
  (let* ((unwrap-b (unwrap-wlr-backend b))
         (o (bytestructure-ref
             (pointer->bytestructure
              unwrap-b
              %wlr-backend-struct)
             'events signal-name)))
    (wrap-wl-signal (+ o 8))))

(define-wlr-procedure (wlr-backend-autocreate display)
  ('* "wlr_backend_autocreate" (list '*))
  (wrap-wlr-backend (% (unwrap-wl-display display))))

(define-wlr-procedure (wlr-backend-start backend)
  (ffi:int "wlr_backend_start" (list '*))
  (% (unwrap-wlr-backend backend)))

(define-wlr-procedure (wlr-backend-destroy backend)
  (ffi:void "wlr_backend_destroy" (list '*))
  (% (unwrap-wlr-backend backend)))
