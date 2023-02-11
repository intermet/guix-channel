(define-module (z packages shellutils)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix gexp)
  #:use-module (guix utils)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system copy)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system go)
  #:use-module (guix build-system python)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages base)
  #:use-module (gnu packages bison)
  #:use-module (gnu packages check)
  #:use-module (gnu packages flex)
  #:use-module (gnu packages golang)
  #:use-module (gnu packages libunistring)
  #:use-module (gnu packages ncurses)
  #:use-module (gnu packages pcre)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages readline)
  #:use-module (gnu packages ruby)
  #:use-module (gnu packages shells)
  #:use-module (gnu packages textutils)
  #:use-module (gnu packages tmux)
  #:use-module (gnu packages vim))

(define-public z-direnv
  (package
    (name "direnv")
    (version "2.32.2")
    (source
     (origin (method git-fetch)
             (uri (git-reference
                   (url "https://github.com/direnv/direnv")
                   (commit (string-append "v" version))))
             (file-name (git-file-name name version))
             (sha256
              (base32
               "17nn4qg1fj4i9rh1gdpbddn2nky71h9dkxyz5a4jsdq25bsx0ps2"))))
    (build-system go-build-system)
    (arguments
     '(#:import-path "github.com/direnv/direnv"
       #:phases
       (modify-phases %standard-phases
         (add-after 'install 'install-manpages
           (lambda* (#:key outputs #:allow-other-keys)
             (let* ((out (assoc-ref outputs "out"))
                    (man (string-append out "/share/man/man1")))
               (mkdir-p man)
               (with-directory-excursion "src/github.com/direnv/direnv"
                 (install-file "man/direnv.1" man)
                 (install-file "man/direnv-stdlib.1" man)
                 (install-file "man/direnv.toml.1" man)))))
         (replace 'check
           (lambda* (#:key tests? #:allow-other-keys)
             (when tests?
               (setenv "HOME" "/tmp")
               (with-directory-excursion "src/github.com/direnv/direnv"
                 ;; The following file needs to be writable so it can be
                 ;; modified by the testsuite.
                 (make-file-writable "test/scenarios/base/.envrc")
                 ;; We need to manually run test because make test
                 ;; tries to use go modules
                 (invoke "go" "test" "./...")
                 ;; Clean up from the tests, especially so that the extra
                 ;; direnv executable that's generated is removed.
                 (invoke "make" "clean"))))))))
    (native-inputs
     (list go-github-com-burntsushi-toml go-github-com-direnv-go-dotenv
           go-github-com-mattn-go-isatty go-golang-org-x-mod which))
    (home-page "https://direnv.net/")
    (synopsis "Environment switcher for the shell")
    (description
     "direnv can hook into the bash, zsh, tcsh, and fish shells to load
or unload environment variables depending on the current directory.  This
allows project-specific environment variables without using @file{~/.profile}.

Before each prompt, direnv checks for the existence of a @file{.envrc} file in
the current and parent directories.  This file is then used to alter the
environment variables of the current shell.")
    (license license:expat)))
