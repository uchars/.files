;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(set-face-attribute 'default nil :height 140)

(setq doom-theme 'doom-solarized-dark)

(setq display-line-numbers-type 'relative)

(setq org-directory "~/org/")

(defun n/evil-scroll-up ()
  "Center page after scroll."
  (interactive)
  (evil-scroll-up nil)
  (evil-scroll-line-to-center nil))

(defun n/evil-scroll-down ()
  "Center page after scroll."
  (interactive)
  (evil-scroll-down nil)
  (evil-scroll-line-to-center nil))

(defvar n/tramp-hosts
      '(("sterz_n@juniper" . "/ssh:sterz_n@10.42.42.10:")))

(defun n/choose-tramp()
  "Choose tramp host to connect to."
  (interactive)
  (let ((host (completing-read "Choose a host: " n/tramp-hosts)))
    (find-file (concat (cdr (assoc host n/tramp-hosts)) "/"))))

(defun n/transparency-enable ()
  "Enables Editor transparency."
  (interactive)
  (set-frame-parameter (selected-frame) 'alpha '(80 . 80))
  (add-to-list 'default-frame-alist '(alpha . (80 . 80))))

(defun n/transparency-disable ()
  "Disable Editor transparency."
  (interactive)
  (set-frame-parameter (selected-frame) 'alpha '(100 . 100))
  (add-to-list 'default-frame-alist '(alpha . (100 . 100))))

(defun n/search-ddg ()
  "Search DuckDuckGo for a query."
  (interactive)
  (let ((q (read-string "Query: ")))
    (eww (concat "https://ddg.gg/?q=" q))))

(defun n/search-google ()
  "Search Google for a query."
  (interactive)
  (let ((q (read-string "Query: ")))
    (eww (concat "https://google.com/search?q=" q))))

(defun n/search-wiki ()
  "Search wikipedia for a query."
  (interactive)
  (let ((q (read-string "Query: ")))
    (eww (concat "https://wikipedia.org/wiki/" q))))

(defun n/search-cpp ()
  "Search wikipedia for a query."
  (interactive)
  (let ((q (read-string "Query: ")))
    (eww (concat "https://ddg.gg/?sites=cppreference.com&q=" q))))

(defun n/search-stackoverflow ()
  "Search StackOverflow for a query."
  (interactive)
  (let ((q (read-string "Query: ")))
    (eww (concat "https://ddg.gg/?sites=stackoverflow.com&q=" q))))

(after! projectile
  (setq projectile-project-search-path '("~/.files" "~/Nextcloud/Documents/Uni/" "~/projects/" "~/work/"))
  (evil-define-key 'normal 'global (kbd "C-p") 'projectile-find-file)
  (evil-define-key 'motion 'global (kbd "C-p") 'projectile-find-file)
  (evil-define-key 'normal 'global (kbd "<leader> p p") 'projectile-switch-project)
  (evil-define-key 'motion 'global (kbd "<leader> p p") 'projectile-switch-project)
  (evil-define-key 'normal 'global (kbd "<leader> p f") 'project-find-file)
  (evil-define-key 'motion 'global (kbd "<leader> p f") 'project-find-file))

(after! evil
  (evil-define-key 'normal 'global (kbd "C-u") 'n/evil-scroll-up)
  (evil-define-key 'normal 'global (kbd "C-b") 'dired-jump)
  (evil-define-key 'normal 'global (kbd "C-d") 'n/evil-scroll-down))

(after! magit
  (evil-define-key 'normal 'global (kbd "<leader> gs") 'magit))

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
