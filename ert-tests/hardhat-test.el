
;;; requires and setup

(when load-file-name
  (setq package-enable-at-startup nil)
  (setq package-load-list '((ignoramus t)))
  (when (fboundp 'package-initialize)
    (package-initialize)))

(require 'ignoramus)
(require 'hardhat)

;;; working-directory

(ert-deftest hardhat-aaa-working-directory-01 nil
  "Check that we are running from the ert-tests directory"
  (should
   (file-exists-p "./examples/elisp_nopat.el"))
  (should
   (string-match-p "/ert-tests/\\'" default-directory)))


;;; example files

(ert-deftest hardhat-example-file-01 nil
  (let ((hardhat-bof-content-editable-regexps '("^;+ *allow editing this file")))
    (find-file "./examples/elisp_nopat.el")
    (should-not
     (hardhat-buffer-included-p (current-buffer)))
    (should
     (equal nil
            hardhat-reasons))
    (kill-buffer (current-buffer))))

(ert-deftest hardhat-example-file-02 nil
  "cover hardhat-protected-by-ignoramus"
  (let ((hardhat-bof-content-editable-regexps '("^;+ *allow editing this file")))
    (find-file "./examples/elisp_nopat.bak")
    (should
     (hardhat-buffer-included-p (current-buffer)))
    (should
     (equal (list 'protected 'function 'hardhat-protected-by-ignoramus)
            hardhat-reasons))
    (kill-buffer (current-buffer))))

(ert-deftest hardhat-example-file-03 nil
  (let ((hardhat-bof-content-editable-regexps '("^;+ *allow editing this file")))
    (find-file "./examples/elisp_editpat.el")
    (should-not
     (hardhat-buffer-included-p (current-buffer)))
    (should
     (equal (list 'editable 'bof-content ";; allow editing this file")
            hardhat-reasons))
    (kill-buffer (current-buffer))))

(ert-deftest hardhat-example-file-04 nil
  (let ((hardhat-bof-content-editable-regexps '("^;+ *allow editing this file")))
    (find-file "./examples/elisp_editpat_localnil.el")
    (hardhat-local-variables-hook)
    (should-not
     (hardhat-buffer-included-p (current-buffer)))
    (should-not
     hardhat-mode)
    (should
     (equal (list 'editable 'file-local-variable nil)
            hardhat-reasons))
    (kill-buffer (current-buffer))))

(ert-deftest hardhat-example-file-05 nil
  (let ((hardhat-bof-content-editable-regexps '("^;+ *allow editing this file")))
    (find-file "./examples/elisp_editpat_localt.el")
    (hardhat-local-variables-hook)
    (should-not
     (hardhat-buffer-included-p (current-buffer)))
    (should
     hardhat-mode)
    (should
     (equal (list 'protected 'file-local-variable t)
            hardhat-reasons))
    (kill-buffer (current-buffer))))

(ert-deftest hardhat-example-file-06 nil
  (let ((hardhat-bof-content-editable-regexps '("^;+ *allow editing this file")))
    (find-file "./examples/elisp_editpat_readonlyfile.el")
    (should-not
     (hardhat-buffer-included-p (current-buffer)))
    (should
     (equal nil
            hardhat-reasons))
    (kill-buffer (current-buffer))))

(ert-deftest hardhat-example-file-07 nil
  (let ((hardhat-bof-content-editable-regexps '("^;+ *allow editing this file")))
    (find-file "./examples/elisp_protpat.el")
    (should
     (hardhat-buffer-included-p (current-buffer)))
    (should
     (equal (list 'protected 'bof-content "DO NOT EDIT")
            hardhat-reasons))
    (kill-buffer (current-buffer))))

(ert-deftest hardhat-example-file-08 nil
  (let ((hardhat-bof-content-editable-regexps '("^;+ *allow editing this file")))
    (find-file "./examples/elisp_protpat_editpat.el")
    (should-not
     (hardhat-buffer-included-p (current-buffer)))
    (should
     (equal (list 'editable 'bof-content ";; allow editing this file")
            hardhat-reasons))
    (kill-buffer (current-buffer))))

(ert-deftest hardhat-example-file-09 nil
  (let ((hardhat-bof-content-editable-regexps '("^;+ *allow editing this file")))
    (find-file "./examples/elisp_protpat_localnil.el")
    (hardhat-local-variables-hook)
    (should-not
     (hardhat-buffer-included-p (current-buffer)))
    (should-not
     hardhat-mode)
    (should
     (equal (list 'editable 'file-local-variable nil)
            hardhat-reasons))
    (kill-buffer (current-buffer))))

(ert-deftest hardhat-example-file-10 nil
  (let ((hardhat-bof-content-editable-regexps '("^;+ *allow editing this file")))
    (find-file "./examples/elisp_protpat_localt.el")
    (hardhat-local-variables-hook)
    (should-not
     (hardhat-buffer-included-p (current-buffer)))
    (should
     hardhat-mode)
    (should
     (equal (list 'protected 'file-local-variable t)
            hardhat-reasons))
    (kill-buffer (current-buffer))))

(ert-deftest hardhat-example-file-11 nil
  (let ((hardhat-eof-content-protected-regexps '((perl-mode  . "protect me")
                                                 (cperl-mode . "protect me")))
        (hardhat-bof-content-editable-regexps '("^;+ *allow editing this file")))
    (find-file "./examples/perl_endpat.pl")
    (should
     (hardhat-buffer-included-p (current-buffer)))
    (should
     (equal (list 'protected 'eof-content "protect me")
            hardhat-reasons))
    (kill-buffer (current-buffer))))

(ert-deftest hardhat-example-file-12 nil
  "cover hardhat-protected-by-perl-semantic-eof"
  (let ((hardhat-eof-content-protected-regexps '((perl-mode  . "protect me")
                                                 (cperl-mode . "protect me")))
        (hardhat-bof-content-editable-regexps '("^;+ *allow editing this file")))
    (find-file "./examples/perl_endpat_semantic.pl")
    (should
     (hardhat-buffer-included-p (current-buffer)))
    (should
     (equal (list 'protected 'function 'hardhat-protected-by-perl-semantic-eof)
            hardhat-reasons))
    (kill-buffer (current-buffer))))

(ert-deftest hardhat-example-file-13 nil
  (let ((hardhat-eof-content-protected-regexps '((perl-mode  . "protect me")
                                                 (cperl-mode . "protect me")))
        (hardhat-bof-content-editable-regexps '("^;+ *allow editing this file")))
    (find-file "./examples/perl_endpat_toofar.pl")
    (should-not
     (hardhat-buffer-included-p (current-buffer)))
    (should
     (equal nil
            hardhat-reasons))
    (kill-buffer (current-buffer))))

(ert-deftest hardhat-example-file-14 nil
  (let ((hardhat-bof-content-editable-regexps '("^;+ *allow editing this file")))
    (find-file "./examples/perl_modepat.pl")
    (should
     (hardhat-buffer-included-p (current-buffer)))
    (should
     (equal (list 'protected 'bof-content "# Changes made here will be lost when autosplit is run again")
            hardhat-reasons))
    (kill-buffer (current-buffer))))

(ert-deftest hardhat-example-file-15 nil
  (let ((hardhat-bof-content-editable-regexps '("^;+ *allow editing this file")))
    (find-file "./examples/text_perlmodepat.txt")
    (should-not
     (hardhat-buffer-included-p (current-buffer)))
    (should
     (equal nil
            hardhat-reasons))
    (kill-buffer (current-buffer))))

(ert-deftest hardhat-example-file-16 nil
  (let ((hardhat-bof-content-editable-regexps '("^;+ *allow editing this file"))
        (hardhat-buffer-protected-functions nil))
    (find-file "./examples/protected-autoloads.el")
    (should
     (hardhat-buffer-included-p (current-buffer)))
    (should
     (equal (list 'protected 'basename "-autoloads.el")
            hardhat-reasons))
    (kill-buffer (current-buffer))))

(ert-deftest hardhat-example-file-17 nil
  (let ((hardhat-bof-content-editable-regexps '("^;+ *allow editing this file"))
        (hardhat-buffer-protected-functions nil))
    (find-file "./examples/editpat-autoloads.el")
    (should-not
     (hardhat-buffer-included-p (current-buffer)))
    (should
     (equal (list 'editable 'bof-content ";; allow editing this file")
            hardhat-reasons))
    (kill-buffer (current-buffer))))

(ert-deftest hardhat-example-file-18 nil
  (find-file "./examples/shell-editpat.sh")
  (should-not
   (hardhat-buffer-included-p (current-buffer)))
  (should
   (equal (list 'editable 'bof-content "THIS IS A GENERATED FILE\\")
          hardhat-reasons))
  (kill-buffer (current-buffer)))

(ert-deftest hardhat-example-file-19 nil
  (let ((hardhat-bof-content-editable-regexps '("^;+ *allow editing this file")))
    (find-file "./examples/CVS/text_protpath.txt")
    (should
     (hardhat-buffer-included-p (current-buffer)))
    (should
     (equal (list 'protected 'fullpath "/CVS/")
            hardhat-reasons))
    (kill-buffer (current-buffer))))

(ert-deftest hardhat-example-file-20 nil
  (let ((hardhat-bof-content-editable-regexps '("^;+ *allow editing this file")))
    (find-file "./examples/CVS/text_protpath_editpat.txt")
    (should-not
     (hardhat-buffer-included-p (current-buffer)))
    (should
     (equal (list 'editable 'bof-content ";; allow editing this file")
            hardhat-reasons))
    (kill-buffer (current-buffer))))

(ert-deftest hardhat-example-file-21 nil
  (let ((hardhat-bof-content-editable-regexps '("^;+ *allow editing this file")))
    (find-file "./examples/CVS/elisp_protpath_localnil.el")
    (hardhat-local-variables-hook)
    (should-not
     (hardhat-buffer-included-p (current-buffer)))
    (should-not
     hardhat-mode)
    (should
     (equal (list 'editable 'file-local-variable nil)
            hardhat-reasons))
    (kill-buffer (current-buffer))))

(ert-deftest hardhat-example-file-22 nil
  (let ((hardhat-bof-content-editable-regexps '("^;+ *allow editing this file")))
    (find-file "./examples/CVS/elisp_protpath_localt.el")
    (hardhat-local-variables-hook)
    (should-not
     (hardhat-buffer-included-p (current-buffer)))
    (should
     hardhat-mode)
    (should
     (equal (list 'protected 'file-local-variable t)
            hardhat-reasons))
    (kill-buffer (current-buffer))))

(ert-deftest hardhat-example-file-23 nil
  (let ((hardhat-bof-content-editable-regexps '("^;+ *allow editing this file")))
    (find-file "./examples/CVS/bash-fc-0")
    (should-not
     (hardhat-buffer-included-p (current-buffer)))
    (should
     (equal (list 'editable 'basename "bash-fc-0")
            hardhat-reasons))
    (kill-buffer (current-buffer))))

(ert-deftest hardhat-example-file-24 nil
  "cover hardhat-protected-osx-homebrew"
  :expected-result (if (and (eq system-type 'darwin)
                            (file-writable-p "/usr/local/README.md")) :passed :failed)
  (let ((hardhat-bof-content-editable-regexps '("^;+ *allow editing this file")))
    (find-file "/usr/local/README.md")
    (should
     (hardhat-buffer-included-p (current-buffer)))
    (should
     (equal (list 'protected 'function 'hardhat-protected-osx-homebrew)
            hardhat-reasons))
    (kill-buffer (current-buffer))))

;;; hardhat-customize-set-regexp (symbol value) -- todo

;;; hardhat-local-hook (&rest args) -- todo

;;; hardhat-global-hook (&rest args) -- todo

;;
;; Emacs
;;
;; Local Variables:
;; indent-tabs-mode: nil
;; mangle-whitespace: t
;; require-final-newline: t
;; coding: utf-8
;; byte-compile-warnings: (not cl-functions)
;; End:
;;

;;; hardhat-test.el ends here
