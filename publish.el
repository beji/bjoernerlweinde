;; load up straight
;; the directory was already created by doom-emacs, might not fit for other setups
;; (defvar bootstrap-version)
;; (let ((bootstrap-file
;;        (expand-file-name ".local/straight/repos/straight.el/bootstrap.el" user-emacs-directory))
;;       (bootstrap-version 6))
;;   (load bootstrap-file nil 'nomessage))

;; ;; TODO: doom-emacs should have installed this, no idea why this is necessary
;; (straight-use-package 'htmlize)

(require 'org)
(require 'ox-publish)

(setq user-full-name "Björn Erlwein")

(defun bde/get-content (x)
  "Returns the contents of a file as a string"
  (with-temp-buffer
    (insert-file-contents x)
    (buffer-string)))

(defun bde/sitemap-format-entry (entry style project)
  "Custom sitemap entry formatting with date"
  (format
   "[[file:%s][%s \[%s\]]]"
   entry
   (org-publish-find-title entry project)
   (format-time-string "%Y-%m-%d" (org-publish-find-date entry project))))

(setq html-head (bde/get-content "./html/head.html"))
(setq html-preamble (bde/get-content "./html/preamble.html"))
(setq html-postamble (bde/get-content "./html/postamble.html"))

;; Some global settings that should apply everywhere, unless explicitely set locally
(setq
 ;; Don't want 1. or 2. in front of every headline
 org-export-with-section-numbers nil
 org-export-with-smart-quotes t
 org-export-with-toc nil
 ;; This wraps the different sections in the specified html tags, useful for styling
 org-html-divs '((preamble "header" "top")
                 (content "main" "content")
                 (postamble "footer" "postamble"))
 org-html-container-element "section"
 ;; Creates a small comment with a timestamp, why not
 org-html-metadata-timestamp-format "%d.%m.%Y"
 ;; Create html5 instead of xhtml 4
 org-html-html5-fancy t
 ;; For some reason not setting this will result in a xhtml doctype no matter if html5-fancy is set
 org-html-doctype "html5"
 ;; The default includes stuff I don't want/need, just use a fully custom styling
 org-html-head-include-default-style nil
 ;; these 3 replace the default sections with custom html files
 org-html-head html-head
 org-html-preamble html-preamble
 org-html-postamble html-postamble)

;; NOTE: Not used for now, static files are copied by the Makefile
(defvar site-attachments
  (regexp-opt '("css"))
  "File types that are published as static files.")

(setq org-publish-project-alist
      (list
       (list "bde-root"
             :base-directory "."
             :recursive t
             :publishing-function '(org-html-publish-to-html)
             :publishing-directory "./public"
             :exclude (regexp-opt '("README" "posts")))
       (list "bde-posts"
             :base-directory "./posts"
             :publishing-directory "./public/posts"
             :recursive t
             :with-toc t
             ;; The sitemap will serve as an automatic list of all posts
             ;; there is also :makeindex but I have no idea what this is supposed to do...
             :auto-sitemap t
             :sitemap-filename "index.org"
             :sitemap-format-entry (lambda (entry style project) (bde/sitemap-format-entry entry style project))
             ;; this has to be empty or it will be merged with the title of the index page...
             :sitemap-title ""
             ;; Newest posts should be at the top
             :sitemap-sort-files 'anti-chronologically)
       ;; (list "bde-static"
       ;;       :base-directory "."
       ;;       :exclude "public/"
       ;;       :base-extension site-attachments
       ;;       :publishing-directory "./public"
       ;;       :publishing-function 'org-publish-attachment
       ;;       :recursive t)
       ;; The order is important here
       ;; bde-posts creates posts/index.org which bde-root references
       (list "bde" :components '("bde-posts" "bde-root"))))

(provide 'publish)
