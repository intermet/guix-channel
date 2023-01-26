(use-modules
 (guix packages)
 (guix git-download)
 (guix build-system perl)
 (guix licenses)
 (gnu packages)
 (gnu packages perl)
 (gnu packages perl-check)
 (gnu packages xml)
 (gnu packages web)
 (gnu packages rust-apps)
 (gnu packages tex))

(define biber
  (package
 (name "biber")
 (version "2.17")
 (source (origin
          (method git-fetch)
          (uri (git-reference
                (url "https://github.com/plk/biber/")
                (commit (string-append "v" version))))
          (file-name (git-file-name name version))
          (sha256
           (base32
            "0b8a8lldz9xx3yr1h5bh2akbqq1ljydqyhr6bdf6qd7ncqvsrpaf"))))
 (build-system perl-build-system)
 (arguments
  `(#:phases
    (modify-phases %standard-phases
                   (add-after 'install 'wrap-programs
                              (lambda* (#:key outputs #:allow-other-keys)
                                (let* ((out (assoc-ref outputs "out"))
                                       (perl5lib (getenv "PERL5LIB")))
                                  (wrap-program (string-append out "/bin/biber")
                                                `("PERL5LIB" ":" prefix
                                                  (,(string-append perl5lib ":" out
                                                                   "/lib/perl5/site_perl")))))
                                #t)))))
 (inputs
  (list perl-autovivification
        perl-class-accessor
        perl-data-dump
        perl-data-compare
        perl-data-uniqid
        perl-datetime-format-builder
        perl-datetime-calendar-julian
        perl-file-slurper
        perl-io-string
        perl-ipc-cmd
        perl-ipc-run3
        perl-list-allutils
        perl-list-moreutils
        perl-mozilla-ca
        perl-regexp-common
        perl-log-log4perl
        perl-parse-recdescent
        perl-unicode-collate
        perl-unicode-normalize
        perl-unicode-linebreak
        perl-encode-eucjpascii
        perl-encode-jis2k
        perl-encode-hanextra
        perl-xml-libxml
        perl-xml-libxml-simple
        perl-xml-libxslt
        perl-xml-writer
        perl-sort-key
        perl-text-csv
        perl-text-csv-xs
        perl-text-roman
        perl-uri
        perl-text-bibtex
        perl-libwww
        perl-lwp-protocol-https
        perl-business-isbn
        perl-business-issn
        perl-business-ismn
        perl-lingua-translit))
 (native-inputs
  `(("perl-config-autoconf" ,perl-config-autoconf)
    ("perl-extutils-libbuilder" ,perl-extutils-libbuilder)
    ("perl-module-build" ,perl-module-build)
    ;; for tests
    ("perl-file-which" ,perl-file-which)
    ("perl-test-more" ,perl-test-most) ; FIXME: "more" would be sufficient
    ("perl-test-differences" ,perl-test-differences)))
 (home-page "http://biblatex-biber.sourceforge.net/")
 (synopsis "Backend for the BibLaTeX citation management tool")
 (description "Biber is a BibTeX replacement for users of biblatex.  Among
other things it comes with full Unicode support.")
 (license artistic2.0)))

;; (packages->manifest (list tectonic biber))

