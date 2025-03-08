;;; init.el --- Personal emacs config -*- lexical-binding: t; -*-
;;; Author: Nils Sterz

;;; Commentary: Works on my machine (tm)
;;; Code:
(setq gc-cons-threshold #x40000000)

;(setq url-proxy-services '(("http" . "user%40mail:password@proxy:8080")
;                           ("https" . "user%40mail:password@proxy:8080")))

(setq read-process-output-max (* 1024 1024 4))
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)


(use-package emacs
  :ensure nil
  :custom
  (column-number-mode t)
  (auto-save-default nil)
  (create-lockfiles nil)
  (delete-by-moving-to-trash t)
  (display-line-numbers-type 'relative)
  (history-length 42)
  (inhibit-startup-message t)
  (ispell-dictionary "en_US")
  (pixel-scroll-precision-mode t)
  (pixel-scroll-precision-use-momentum nil)
  (ring-bell-function 'ignore)
  (split-width-threshold 300)
  (tab-width 4)
  (truncate-lines t)
  (use-dialog-box nil)
  (warning-minimum-level :emergency)
  :hook
  (prog-mode . display-line-numbers-mode)
  :config
  (setq custom-file (locate-user-emacs-file "custom-vars.el"))
  (load custom-file 'noerror 'nomessage)
  (global-set-key (kbd "<escape>")      'keyboard-escape-quit)
  (set-face-attribute 'default nil :family "JetBrainsMono Nerd Font"  :height 140)
  (setq scroll-margin 8)
  (setq scroll-conservatively 100)
  (setq use-short-answers t)
  (setq global-hl-line-mode nil)
  (set-display-table-slot standard-display-table 'vertical-border (make-glyph-code ?│))
  (add-hook 'before-save-hook 'delete-trailing-whitespace)
  :init
  (tool-bar-mode -1)
  (menu-bar-mode -1)
  (add-hook 'after-init-hook
    (lambda ()
      (with-current-buffer (get-buffer-create "*scratch*")
        (insert (format
                 ";; Loading (%s) Packages(%s)"
                  (emacs-init-time)
                  (number-to-string (length package-activated-list)))))))
  (when scroll-bar-mode (scroll-bar-mode -1))
  (save-place-mode 1)
  (savehist-mode 1)
  (indent-tabs-mode -1)
  (global-hl-line-mode 1)
  (modify-coding-system-alist 'file "" 'utf-8))

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

(use-package evil
  :ensure t
  :hook
  (after-init . evil-mode)
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  :config
  (evil-set-undo-system 'undo-tree)
  (setq evil-leader/in-all-states t)
  (setq evil-want-fine-undo t)

  (evil-set-leader 'normal (kbd "SPC"))
  (evil-set-leader 'visual (kbd "SPC"))

  (evil-define-key 'normal 'global (kbd "C-u") 'n/evil-scroll-up)
  (evil-define-key 'normal 'global (kbd "C-d") 'n/evil-scroll-down)
  (evil-define-key 'normal 'global (kbd "<leader> c c") 'compile)
  (evil-define-key 'normal 'global (kbd "<leader> r c") 'recompile)
  (evil-define-key 'normal emacs-lisp-mode-map (kbd "<leader> i") 'eval-buffer)
  (evil-define-key 'normal emacs-lisp-mode-map (kbd "<leader> i") 'eval-buffer)

  (setq evil-emacs-state-modes '())
  (evil-set-initial-state 'eshell-mode 'normal)
  (evil-set-initial-state 'term-mode 'normal)
  (evil-set-initial-state 'image-mode 'motion)
  (evil-set-initial-state 'special-mode 'motion)
  (evil-set-initial-state 'pdf-view-mode 'motion)
  (evil-set-initial-state 'org-agenda-mode 'motion)
  (evil-set-initial-state 'compilation-mode 'motion)
  (evil-set-initial-state 'grep-mode 'motion)
  (evil-set-initial-state 'Info-mode 'motion)
  (evil-set-initial-state 'magit--mode 'motion)
  (evil-set-initial-state 'magit-status-mode 'motion)
  (evil-set-initial-state 'magit-diff-mode 'motion)
  (evil-set-initial-state 'magit-stashes-mode 'motion)
  (evil-set-initial-state 'epa-key-list-mode 'motion)
  (evil-set-initial-state 'fuel-debug-mode 'motion))

(use-package evil-commentary
  :ensure t
  :defer t
  :init
  (evil-commentary-mode))

(use-package evil-surround
  :ensure t
  :config
  (global-evil-surround-mode 1))

(use-package evil-matchit
  :ensure t
  :after evil
  :config
  (global-evil-matchit-mode 1))

(use-package dired
  :ensure nil
  :custom
  (setq dired-compress-files-alist
    '(("\\.tar\\.gz\\'" . "tar -c %i | gzip -c9 > %o")
      ("\\.zip\\'" . "zip %o -r --filesync %i")))
  (dired-listing-switches "-lah --group-directories-first")
  (dired-guess-shell-alist-user
   '(("\\.\\(png\\|jpe?g\\|tiff\\)" "feh" "xdg-open" "open") ;; Open image files with `feh' or the default viewer.
     ("\\.\\(mp[34]\\|m4a\\|ogg\\|flac\\|webm\\|mkv\\)" "mpv" "xdg-open" "open") ;; Open audio and video files with `mpv'.
     (".*" "open" "xdg-open")))
  (dired-kill-when-opening-new-dired-buffer t)
  :config
  (setq dired-mode-map (make-keymap))
  (evil-set-initial-state 'dired-mode 'motion)
  (evil-define-key 'normal 'global (kbd "C-b") 'dired-jump)
  (evil-define-key 'motion dired-mode-map
    (kbd "RET") 'dired-find-file
    (kbd "j") 'dired-next-line
    (kbd "k") 'dired-previous-line
    (kbd "D") 'dired-do-delete
    (kbd "O") 'dired-do-open
    (kbd "-") 'dired-up-directory
    (kbd "q") 'quit-window
    (kbd "=") 'dired-diff
    (kbd "mm") 'dired-mark
    (kbd "mu") 'dired-unmark
    (kbd "mU") 'dired-unmark-all-marks
    (kbd "!") 'dired-do-shell-command
    (kbd "R") 'dired-do-rename
    (kbd "C") 'dired-do-copy
    (kbd "Z") 'dired-do-compress-to))

(unless (eq system-type 'windows-nt)
  (use-package exec-path-from-shell
    :ensure t
    :init
    (exec-path-from-shell-initialize)))

(use-package eldoc
  :ensure nil
  :init
  (global-eldoc-mode))

(use-package flymake
  :ensure nil
  :defer t
  :hook (prog-mode . flymake-mode)
  :config
  (evil-define-key 'normal 'global (kbd "[ e") 'flymake-goto-prev-error)
  (evil-define-key 'normal 'global (kbd "] e") 'flymake-goto-next-error)
  :custom
  (flymake-margin-indicators-string
   '((error "!»" compilation-error) (warning "»" compilation-warning)
	 (note "»" compilation-info))))

(use-package org
  :ensure nil
  :defer t)

(use-package ivy
  :ensure t
  :config
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t)
  (evil-define-key 'normal 'global (kbd "<leader> /") 'swiper)
  (define-key ivy-minibuffer-map (kbd "TAB") 'ivy-next-line)
  (define-key ivy-minibuffer-map (kbd "<backtab>") 'ivy-previous-line)
  (ivy-mode))

(use-package vertico
  :ensure t
  :hook
  (after-init . vertico-mode)
  :custom
  (vertico-count 10)
  (vertico-resize nil)
  (vertico-cycle nil))

(use-package counsel
  :ensure t
  :after ivy
  :config
  (evil-define-key 'normal 'global (kbd "<leader> SPC") 'counsel-switch-buffer)
  :bind (("M-x" . counsel-M-x)
         ("C-h f" . counsel-describe-function)))

(use-package orderless
  :ensure t
  :defer t
  :after vertico
  :init
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))

(use-package marginalia
  :ensure t
  :hook
  (after-init . marginalia-mode))

(use-package treesit-auto
  :ensure t
  :after emacs
  :custom
  (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode t))

(use-package diff-hl
  :defer t
  :ensure t
  :hook
  (find-file . (lambda ()
                 (global-diff-hl-mode)
                 (diff-hl-flydiff-mode)
                 (diff-hl-margin-mode))))

(use-package magit
  :ensure t
  :config
  (setq magit-mode-map (make-keymap)
        magit-status-mode-map (make-keymap)
        magit-diff-mode-map (make-keymap)
       magit-stashes-mode-map (make-keymap))
  (evil-define-key 'motion 'global (kbd "<leader> g s") 'magit)
  (evil-define-key 'motion 'global (kbd "<leader> g l") 'magit-log)
  (evil-define-key 'motion magit-mode-map
    (kbd "RET") #'magit-visit-thing
    (kbd "TAB") #'magit-section-cycle
    (kbd "=") #'magit-section-cycle
    (kbd "R") #'magit-refresh
    (kbd "s") #'magit-stage
    (kbd "u") #'magit-unstage
    (kbd "x") #'magit-discard
  ))

(use-package xclip
  :ensure t
  :defer t
  :hook
  (after-init . xclip-mode))

(use-package indent-guide
  :defer t
  :ensure t
  :hook
  (prog-mode . indent-guide-mode)
  :config
  (setq indent-guide-char "│"))

(use-package flycheck
  :ensure t)

;; Tramp hosts
(setq n/tramp-hosts
      '(("sterz_n@juniper" . "/ssh:sterz_n@10.42.42.10:")))

(defun n/choose-tramp()
  "Choose tramp host to connect to."
  (interactive)
  (let ((host (completing-read "Choose a host: " n/tramp-hosts)))
	(find-file (concat (cdr (assoc host n/tramp-hosts)) "/"))))

(use-package lsp-mode
  :ensure t
  :config
  (setq lsp-idle-delay 0.500)
  (setq lsp-log-io nil)
  (evil-define-key 'normal prog-mode-map
    (kbd "<leader> r n") 'lsp-rename
    (kbd "<leader> c a") 'lsp-execute-code-action)
  :hook ((c++-mode . lsp-deferred))
  :commands (lsp lsp-deferred))

(use-package undo-tree
  :defer t
  :ensure t
  :hook
  (after-init . global-undo-tree-mode)
  :init
  (setq undo-tree-visualizer-timestamps t
        undo-tree-visualizer-diff t
        undo-limit 800000
        undo-strong-limit 12000000)
  :config
  (evil-define-key 'normal 'global (kbd "<leader> u") 'undo-tree-visualize)
  (setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/.cache/undo"))))

(use-package rainbow-delimiters
  :ensure t
  :defer t
  :hook
  (prog-mode . rainbow-delimiters-mode))

(use-package nerd-icons
  :ensure t
  :defer t)

(use-package nerd-icons-dired
  :ensure t
  :defer t
  :hook
  (dired-mode . nerd-icons-dired-mode))

(use-package nerd-icons-completion
  :ensure t
  :after (:all nerd-icons marginalia)
  :config
  (nerd-icons-completion-mode)
  (add-hook 'marginalia-mode-hook #'nerd-icons-completion-marginalia-setup))

(use-package catppuccin-theme
  :ensure t
  :config
  (load-theme 'catppuccin :no-confirm))

(defun n/evil-scroll-up ()
  (interactive)
  (evil-scroll-up nil)
  (recenter))

(defun n/evil-scroll-down ()
  (interactive)
  (evil-scroll-down nil)
  (recenter))

(use-package haskell-mode
  :ensure t
  :defer t)

(use-package company
  :ensure t
  :hook
  (after-init . global-company-mode))


(use-package lsp-haskell
  :ensure t
  :defer t
  :config
  (setq lsp-haskell-server-path "~/.ghcup/bin/haskell-language-server-wrapper"))


(use-package projectile
  :ensure t
  :config
  (setq projectile-project-search-path '("~/.files" "~/projects/" "~/work/"))
  (evil-define-key 'normal 'global (kbd "C-p") 'projectile-find-file)
  (evil-define-key 'normal 'global (kbd "<leader> p p") 'projectile-switch-project)
  (evil-define-key 'normal 'global (kbd "<leader> p f") 'project-find-file)
  :hook
  (after-init . projectile-mode))

(use-package mood-line
  :ensure t
  :config
  (mood-line-mode))

(use-package vterm
  :ensure t
  :config
  (evil-define-key 'normal 'global (kbd "<leader> v t") 'vterm))

(use-package harpoon
  :ensure t
  :config
  (evil-define-key 'normal 'global
	(kbd "<leader> 1") 'harpoon-go-to-1
	(kbd "<leader> 2") 'harpoon-go-to-2
	(kbd "<leader> 3") 'harpoon-go-to-3
	(kbd "<leader> 4") 'harpoon-go-to-4
	(kbd "<leader> m") 'harpoon-add-file
	(kbd "<leader> h l") 'harpoon-quick-menu-hydra
	(kbd "<leader> d 1") 'harpoon-delete-1
	(kbd "<leader> d 2") 'harpoon-delete-2
	(kbd "<leader> d 3") 'harpoon-delete-3))

(use-package pdf-tools
  :ensure t
  :mode ("\\.pdf'" . pdf-view-mode)
  :config
  (define-key pdf-view-mode-map (kbd "q") nil)
  (evil-define-key motion pdf-view-mode-map
    "h" 'scroll-left
    "l" 'scroll-right
	"j" 'pdf-view-next-line-or-next-page
    "k" 'pdf-view-previous-line-or-previous-page
    "J" 'pdf-view-scroll-up-or-next-page
    "K" 'pdf-view-scroll-down-or-previous-page
	"]" 'pdf-view-next-page-command
    "[" 'pdf-view-previous-page-command
	"-" 'pdf-view-shrink
    "+" 'pdf-view-enlarge
    ))

(provide 'init)
;;; init.el ends here
