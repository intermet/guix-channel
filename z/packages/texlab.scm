(define-module (z packages texlab)
  #:use-module (gnu packages)
  #:use-module (nonguix build-system binary)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages base)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system cargo)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix profiles))

(define-public texlab-bin
  (package
   (name "texlab")
   (version "5.1.0")
   (source
    (origin
     (method url-fetch)
     (uri (string-append
           "https://github.com/latex-lsp/texlab/releases/download/v"
           version
           "/texlab-x86_64-linux.tar.gz"))
     (sha256
      (base32 "16gn9j1f08cm807dag9p2jmzp5yfzlq7xqiqrnsvwdv4nbv5g389"))))
   (build-system binary-build-system)
   (arguments
    `(#:install-plan
      `(("texlab" "/bin/"))
      #:patchelf-plan
      '(("texlab" ("glibc" "gcc")))))
   (inputs (list glibc (list gcc "lib")))
   (synopsis "An implementation of the Language Server Protocol for LaTeX ")
   (description "An implementation of the Language Server Protocol for LaTeX.")
   (home-page "https://texlab.netlify.app/")
   (license license:gpl3)))
