;;;; electron-sbcl-sqlite.asd

#-quicklisp
(let ((quicklisp-init (merge-pathnames "quicklisp/setup.lisp"
                                       (user-homedir-pathname))))
  (when (probe-file quicklisp-init)
    (load quicklisp-init)))

(ql:quickload :hunchentoot)
(ql:quickload :cl-who)
(ql:quickload :sqlite)

(asdf:defsystem #:electron-sbcl-sqlite
  :description "Describe electron-sbcl-sqlite here"
  :author "Your Name <your.name@example.com>"
  :license  "Specify license here"
  :version "0.0.1"
  :serial t
  :depends-on (:sqlite :hunchentoot :cl-who)
  :components ((:module "src"
                        :serial t
                        :components ((:file "package")
                                     (:file "electron-sbcl-sqlite")))))

;;; (asdf:load-system :electron-sbcl-sqlite)

(defun buildapp ()
  (asdf:load-system :electron-sbcl-sqlite)
  (save-lisp-and-die "lispapp"
                     :toplevel 'cl-user::main
                     :executable t))

