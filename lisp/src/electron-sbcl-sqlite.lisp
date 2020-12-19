;;;; electron-sbcl-sqlite.lisp

(in-package #:electron-sbcl-sqlite)

(defparameter *server* nil)

(defun start-server (port)
  (setf *server*
        (make-instance 'hunchentoot:easy-acceptor :port port))
  (hunchentoot:start *server*))

(hunchentoot:define-easy-handler (landing :uri "/") ()
  (setf (hunchentoot:content-type*) "text/html")
  (with-open-database (db ":memory:")
    (let* ((sbcl-version (lisp-implementation-version))
           (sbcl-features *features*)
           (sbcl-feature-count (length sbcl-features))
           (sqlite-version (execute-single db "SELECT sqlite_version()"))
           (sqlite-compile-options (execute-to-list db "pragma compile_options")))
      (with-html-output-to-string (out nil :prologue t)
        (:html
         (:head
          (:link :rel "preconnect" :href "https://cdn.jsdelivr.net")
          (:link :rel "stylesheet" :href "https://cdn.jsdelivr.net/npm/@native-elements/core@1/dist/native-elements.css"))
         (:body
          (:script :src "https://unpkg.com/htmx.org@0.0.4")
          (:h1 "electron-sbcl-sqlite")
          (:div
           (:h4 (fmt "Running Hunchentoot on SBCL v~A with SQLite v~A"
                    sbcl-version sqlite-version))
           (:h5 "SBCL *features*:")
           (:p :font-size "8pt" (str sbcl-features))
           (:h5 "SQLite compile_options:")
           (:p :font-size "8pt" (str sqlite-compile-options)))
          (:div
           (:form
            (:input :type "text" :name "msg")
            (:br)
            (:button :class "btn"
                     :hx-post "/btnclick"
                     :hx-target "#response"
                     "Send message")))
          (:div :id "response")))
        (values)))))



(hunchentoot:define-easy-handler (btnclick :uri "/btnclick") (msg)
  (setf (hunchentoot:content-type*) "text/plain")
  (format nil "Received: ~A" msg))

(defun stop-server ()
  (hunchentoot:stop *server*)
  (setf *server* nil))

;;; (start-server 8000)
;;; (stop-server)

(in-package #:cl-user)

(defun main (&optional (port 8000))
  (electron-sbcl-sqlite::start-server port)
  (sb-impl::toplevel-repl nil))

