(define-module (z packages emacs)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:use-module (gnu packages emacs)
  #:use-module (gnu packages text-editors)
  #:use-module (guix build-system gnu))

(define-public emacs)
(package
 (inherit emacs-next)
 (name "emacs-next-treesitter")
 (arguments
  (substitute-keyword-arguments (package-arguments emacs)
                                ((#:configure-flags flags ''())
                                 `(cons* "--with-tree-sitter"
                                         ,flags))))
 (inputs (modify-inputs (package-inputs emacs-next)
                        (prepend tree-sitter)))
