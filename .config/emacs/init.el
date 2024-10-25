(add-to-list 'default-frame-alist
             '(background-color . "#17191a"))

(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)

(setq make-backup-files nil) 

;; Start in scratch buffer
(setq inhibit-startup-screen t)

(if (member "IsoVeka" (font-family-list))
    (set-face-attribute 'default nil :font "IsoVeka-12")
  (set-face-attribute 'default nil :font "Monospace-12"))

(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

;; Ignore warnings
(setq warning-minimum-level :emergency)

;; Remove terminal bell
(setq visible-bell nil)

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)


;; Install package manager (package.el is included in Emacs 24 and later)
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Optionally, you can install a package manager like use-package
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(dolist (mode '(org-mode-hook doc-view-mode-hook image-view-hook term-mode-hook eshell-mode-hook)) (add-hook mode  (lambda () (display-line-numbers-mode 0))))

(require 'use-package)
(setq use-package-always-ensure t)

(use-package solarized-theme
  :config
  (load-theme 'solarized-dark t))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package counsel
  :bind (("M-x" . counsel-M-x)
	 ("C-x b" . counsel-ibuffer)))

(use-package swiper)

(defun nils/evil-scroll-up ()
  (interactive)
  (evil-scroll-up nil)
  (evil-scroll-line-to-center))

(defun nils/evil-scroll-down ()
  (interactive)
  (evil-scroll-down nil)
  (evil-scroll-line-to-center))

(use-package command-log-mode)

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

(use-package drag-stuff
  :after evil
  :config
  (define-key evil-visual-state-map (kbd "J") 'drag-stuff-down)
  (define-key evil-visual-state-map (kbd "K") 'drag-stuff-up))

(use-package evil-commentary
  :after evil
  :config
  (evil-commentary-mode 1))

(use-package undo-tree
  :config
  (setq undo-tree-history-directory-alist
      `(("." . "~/.local/undo-tree-history/")))
  :init
  (global-undo-tree-mode))

(use-package evil-surround
  :after evil
  :config
  (global-evil-surround-mode 1))

(use-package general
  :config
  (general-create-definer nils/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC"))

(use-package hydra)

(defhydra hydra-text-scale (:timeout 4)
  "scale text"
  ("j" text-scale-increase "in")
  ("k" text-scale-decrease "out")
  ("f" nil "finished" :exit t))

(nils/leader-keys
  "ts" '(hydra-text-scale/body :which-key "scale text")
  "pf" 'projectile-find-file
  "pp" 'projectile-switch-project
  "gs" 'magit
  "ca" 'lsp-execute-code-action
  "SPC" 'projectile-switch-to-buffer)

(use-package rg)
(use-package projectile
  :diminish projectile-mode
  :after evil
  :config
  (define-key evil-normal-state-map (kbd "C-f") 'counsel-projectile-rg)
  (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :init
  (when (file-directory-p "~/Documents/edu")
    (setq projectile-project-search-path '(( "~/Documents/edu" . 5))))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
  :config (counsel-projectile-mode))

(use-package magit
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(defun nils/lsp-mode-setup ()
  (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
  (lsp-headerline-breadcrumb-mode))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook
  (lsp-mode . nils/lsp-mode-setup)
  :init
  (setq lsp-keymap-prefix "C-c l"))

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :bind ("K" . lsp-ui-doc-toggle)
  :custom
  (lsp-ui-doc-position 'at-point))

(use-package lsp-treemacs
  :after lsp)

(use-package lsp-ivy)

(use-package company
  :after lsp-mode
  :hook (lsp-mode . company-mode)
  :bind (:map company-active-map
         ("<tab>" . company-complete-selection))
        (:map lsp-mode-map
         ("<tab>" . company-indent-or-complete-common))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))

(use-package company-box
  :hook (company-mode . company-box-mode))

(use-package haskell-mode
  :hook
  (haskell-mode . lsp))

(use-package lsp-haskell
  :ensure t
  :config
  (setq lsp-haskell-server-path "haskell-language-server-wrapper")
  (setq lsp-haskell-server-args nil))

(use-package flycheck
  :ensure t
  :after evil
  :config
  (define-key evil-normal-state-map (kbd "]e") 'flycheck-next-error)
  (define-key evil-normal-state-map (kbd "[e") 'flycheck-previous-error)
  :hook (lsp-mode . flycheck-mode))

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  (setq evil-undo-system 'undo-tree)
  :config
  (define-key evil-normal-state-map (kbd "C-d") 'nils/evil-scroll-down)
  (define-key evil-normal-state-map (kbd "gcc") 'evil-commentary)
  (define-key evil-normal-state-map (kbd "u") 'undo-tree-undo)
  (define-key evil-normal-state-map (kbd "C-r") 'undo-tree-redo)
  :bind (("C-u" . nils/evil-scroll-up)))

(evil-mode 1)

(eval-after-load "evil-maps"
  (define-key evil-motion-state-map "K" nil))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(lsp-clangd flycheck haskell-mode company-box company lsp-ivy lsp-treemacs lsp-ui lsp-mode drag-stuff rg evil-magit magit counsel-projectile hydra evil-collection general undo-tree ivy-rich evil-surround command-log-mode rainbow-delimiters counsel ivy solarized-theme evil-commentary)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
