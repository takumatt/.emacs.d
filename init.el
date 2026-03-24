;;; init.el --- by Takuma Matsushita -*- coding: utf-8; lexical-binding: t -*-

;;; Commentary:

;; Personal Emacs configuration.

;;; Code:

;; Custom variables (managed by Emacs, do not edit manually)

(custom-set-variables
 '(custom-safe-themes
   '("9b21c848d09ba7df8af217438797336ac99cbbbc87a08dc879e9291673a6a631"
     "3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa"
     "c74e83f8aa4c78a121b52146eadb792c9facc5b1f02c917e3dbb454fca931223"
     default))
 '(org-agenda-files '("~/memo.org"))
 '(package-selected-packages nil)
 '(package-vc-selected-packages
   '((claude-code :url "https://github.com/stevemolitor/claude-code.el")))
 '(warning-suppress-types '((use-package))))
(custom-set-faces)

;;; Package Management

(require 'package)

(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

(add-to-list 'package-archives '("melpa"        . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(add-to-list 'package-archives '("org"          . "http://orgmode.org/elpa/") t)

(package-initialize)

;;; Environment

(use-package exec-path-from-shell
  :if (memq window-system '(mac ns))
  :ensure t
  :config
  (exec-path-from-shell-initialize))

;; Load path

(setq load-path (append '("~/.emacs.d/elisp" "~/.emacs.d/config") load-path))

(load "util")

;; Encoding

(set-language-environment   "UTF-8")
(prefer-coding-system       'utf-8)
(set-default-coding-systems 'utf-8)
(set-keyboard-coding-system 'utf-8)

;;; UI / Appearance

(use-package color-theme-sanityinc-tomorrow
  :ensure t
  :init
  (load-theme 'sanityinc-tomorrow-bright t))

(use-package all-the-icons
  :ensure t)

(use-package smart-mode-line
  :ensure t
  :custom
  (sml/theme 'respectful)
  :hook
  (after-init . sml/setup))

;; Frame

(set-frame-parameter (selected-frame) 'alpha 80)

(when (memq window-system '(mac ns))
  (add-to-list 'default-frame-alist '(ns-appearance . 'dark))
  (add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
  (setq ns-use-proxy-icon nil)
  (setq frame-title-format nil))

;; Bars

(menu-bar-mode   -1)
(tool-bar-mode   -1)
(scroll-bar-mode -1)

;; Fonts

(when (display-graphic-p)
  (set-face-attribute 'default nil :height 140)
  (set-frame-font "-*-Cica-normal-normal-normal-*-*-*-*-*-m-0-iso10646-1"))

;;; Built-in Settings

;; Startup

(setq inhibit-startup-message t)

(setq initial-scratch-message
      (format "%s\
 _______ _______ _______ _______ _______
 |______ |  |  | |_____| |       |______
 |______ |  |  | |     | |_____  ______|

;; %d packages loaded in %s.
;; Welcome to Emacs %s, %s.

"
              initial-scratch-message
              (length package-alist)
              (emacs-init-time)
              emacs-version
              user-full-name))

;; Files

(setq make-backup-files nil)
(setq auto-save-default nil)
(setq delete-auto-save-files t)

;; History

(savehist-mode 1)
(recentf-mode 1)

(require 'saveplace)
(if (>= emacs-major-version 25)
    (save-place-mode 1)
  (setq-default save-place t))

;; Editing

(setq-default indent-tabs-mode nil)
(electric-pair-mode 1)
(show-paren-mode 1)
(blink-cursor-mode 0)
(fset 'yes-or-no-p 'y-or-n-p)
(setq ring-bell-function 'ignore)

;; Display

(which-function-mode 1)
(global-hl-line-mode 0)
(add-hook 'prog-mode-hook #'display-line-numbers-mode)

;; Keybindings

(bind-key* "C-h" 'backward-delete-char)

;;; Completion

(use-package vertico
  :ensure t
  :init
  (vertico-mode 1))

(use-package orderless
  :ensure t
  :init
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))

(use-package marginalia
  :ensure t
  :init
  (marginalia-mode 1))

(use-package consult
  :ensure t
  :bind
  ("C-s"   . consult-line)
  ("C-x b" . consult-buffer))

(use-package corfu
  :ensure t
  :init
  (global-corfu-mode 1)
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.2)
  :bind
  (:map corfu-map
        ("C-n" . corfu-next)
        ("C-p" . corfu-previous)))

(use-package kind-icon
  :ensure t
  :after corfu
  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

;;; Navigation & Utilities

(use-package ace-window
  :ensure t
  :bind
  ("M-o" . ace-window))

(use-package imenu-list
  :ensure t
  :bind
  ("C-'" . imenu-list-smart-toggle))

(use-package multiple-cursors
  :ensure t
  :bind
  ("C-S-c"   . mc/edit-lines)
  ("C->"     . mc/mark-next-like-this)
  ("C-<"     . mc/mark-previous-like-this)
  ("C-c C-<" . mc/mark-all-like-this))

(use-package neotree
  :ensure t
  :custom
  (neo-vc-integration '(face char))
  :bind
  ("C-]" . neotree-toggle))

(use-package quickrun
  :ensure t
  :bind
  ("C-c C-q" . quickrun))

;;; Git

(use-package magit
  :ensure t
  :bind
  ("C-x g"   . magit-status)
  ("C-x M-g" . magit-dispatch-popup))

(use-package diff-hl
  :ensure t
  :hook
  (after-init . global-diff-hl-mode))

;;; AI Tools

(use-package copilot-chat
  :ensure t
  :bind
  ("C-c C-c" . copilot-chat-display))

;;; Terminal

(use-package vterm
  :ensure t
  :custom
  (vterm-max-scrollback 1000))

;;; Language Support

(use-package rainbow-delimiters
  :ensure t
  :hook
  (lisp-mode       . rainbow-delimiters-mode)
  (emacs-lisp-mode . rainbow-delimiters-mode))

(use-package elixir-mode
  :ensure t)

(use-package json-mode
  :ensure t)

;;; Disabled Packages
;;
;; Packages below are kept for reference but not currently active.

;; LSP
;;
;; (use-package lsp-mode
;;   :ensure t
;;   :init
;;   (setq lsp-keymap-prefix "s-l")
;;   :hook
;;   (prog-mode . lsp)
;;   :commands lsp)

;; Web
;;
;; (use-package emmet-mode
;;   :ensure t
;;   :hook
;;   (html-mode . emmet-mode))
;;
;; (use-package rainbow-mode
;;   :ensure t
;;   :hook
;;   (css-mode . rainbow-mode))

;;; init.el ends here
