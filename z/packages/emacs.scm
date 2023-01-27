(define-module (my-channel)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix utils)
  #:use-module (gnu packages emacs)
  #:use-module (gnu packages sqlite)
  #:use-module (gnu packages text-editors)
  #:use-module (gnu packages xorg)
  #:use-module (gnu packages image)
  #:use-module (guix build-system gnu)
  #:use-module (guix git-download)
  #:use-module (guix licenses)
  #:export (emacs-next-treesitter))


(define-public emacs-next-treesitter
  (package
   (inherit emacs-next)
   (name "emacs-next-treesitter")
   (arguments
    (substitute-keyword-arguments (package-arguments emacs)
                                  ((#:configure-flags flags ''())
                                   `(cons* "--with-tree-sitter"
                                           ,flags))))
   
   (inputs (modify-inputs (package-inputs emacs-next)
                          (prepend tree-sitter))))
  )
