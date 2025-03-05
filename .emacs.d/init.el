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
  (dired-kill-when-opening-new-dired-buffer t))

(use-package exec-path-from-shell
  :ensure t
  :init
  (exec-path-from-shell-initialize))

(use-package eldoc
  :ensure nil
  :init
  (global-eldoc-mode))

(use-package flymake
  :ensure nil
  :defer t
  :hook (prog-mode . flymake-mode)
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
  :init
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

(use-package embark
  :ensure t
  :defer t)

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
  :defer t)

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

(use-package lsp-mode
  :ensure t
  :config
  (setq lsp-idle-delay 0.500)
  (setq lsp-log-io nil)
  :hook ((c++-mode . lsp-deferred))
  :commands (lsp lsp-deferred))

(use-package evil
  :ensure t
  :defer t
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

  (evil-define-key 'normal 'global (kbd "C-b") 'dired-jump)
  (evil-define-key 'normal 'global (kbd "C-u") 'n/evil-scroll-up)
  (evil-define-key 'normal 'global (kbd "C-d") 'n/evil-scroll-down)
  (evil-define-key 'normal 'global (kbd "[ e") 'flymake-goto-prev-error)
  (evil-define-key 'normal 'global (kbd "] e") 'flymake-goto-next-error)
  (evil-define-key 'normal 'global (kbd "C-p") 'projectile-find-file)

  (evil-define-key 'normal emacs-lisp-mode-map (kbd "<leader> i") 'eval-buffer)

  (evil-define-key 'normal dired-mode-map (kbd "<leader> RET") 'dired-find-file)
  (evil-define-key 'normal dired-mode-map (kbd "<leader> j") 'dired-next-line)
  (evil-define-key 'normal dired-mode-map (kbd "<leader> k") 'dired-previous-line)
  (evil-define-key 'normal dired-mode-map (kbd "<leader> D") 'dired-do-delete)
  (evil-define-key 'normal dired-mode-map (kbd "<leader> O") 'dired-do-open)
  (evil-define-key 'normal dired-mode-map (kbd "<leader> -") 'dired-up-directory)
  (evil-define-key 'normal dired-mode-map (kbd "<leader> q") 'quit-window)
  (evil-define-key 'normal dired-mode-map (kbd "<leader> =") 'dired-diff)
  (evil-define-key 'normal dired-mode-map (kbd "<leader> mm") 'dired-mark)
  (evil-define-key 'normal dired-mode-map (kbd "<leader> mu") 'dired-unmark)
  (evil-define-key 'normal dired-mode-map (kbd "<leader> mU") 'dired-unmark-all-marks)
  (evil-define-key 'normal dired-mode-map (kbd "<leader> !") 'dired-do-shell-command)
  (evil-define-key 'normal dired-mode-map (kbd "<leader> R") 'dired-do-rename)
  (evil-define-key 'normal dired-mode-map (kbd "<leader> C") 'dired-do-copy)
  (evil-define-key 'normal dired-mode-map (kbd "<leader> Z") 'dired-do-compress-to)

  (evil-define-key 'normal 'global (kbd "<leader> /") 'swiper)
  (evil-define-key 'normal 'global (kbd "<leader> r n") 'lsp-rename)
  (evil-define-key 'normal 'global (kbd "<leader> p p") 'projectile-switch-project)
  (evil-define-key 'normal 'global (kbd "<leader> p f") 'project-find-file)
  (evil-define-key 'normal 'global (kbd "<leader> SPC") 'counsel-switch-buffer)
  (evil-define-key 'normal 'global (kbd "<leader> g s") 'magit)
  (evil-define-key 'normal 'global (kbd "<leader> g l") 'magit-log)
  (evil-define-key 'normal 'global (kbd "<leader> m") 'harpoon-add-file)
  (evil-define-key 'normal 'global (kbd "<leader> h l") 'harpoon-quick-menu-hydra)
  (evil-define-key 'normal 'global (kbd "<leader> d 1") 'harpoon-delete-1)
  (evil-define-key 'normal 'global (kbd "<leader> d 2") 'harpoon-delete-2)
  (evil-define-key 'normal 'global (kbd "<leader> d 3") 'harpoon-delete-3)
  (evil-define-key 'normal 'global (kbd "<leader> v t") 'vterm)
  (evil-define-key 'normal 'global (kbd "<leader> 1") 'harpoon-go-to-1)
  (evil-define-key 'normal 'global (kbd "<leader> 2") 'harpoon-go-to-2)
  (evil-define-key 'normal 'global (kbd "<leader> 3") 'harpoon-go-to-3)
  (evil-define-key 'normal 'global (kbd "<leader> 4") 'harpoon-go-to-4)
  (evil-define-key 'normal 'global (kbd "<leader> c a") 'lsp-execute-code-action))

(use-package evil-collection
  :ensure t
  :after evil
  :config
  (evil-collection-init))

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
  :after evil-collection
  :config
  (global-evil-matchit-mode 1))

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

(use-package embark
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
  :hook
  (after-init . projectile-mode))

(use-package doom-modeline
  :ensure t
  :defer t
  :hook
  (after-init . doom-modeline-mode))

(use-package vterm
  :ensure t)

(use-package harpoon
  :ensure t)

(provide 'init)
;;; init.el ends here
