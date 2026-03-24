;;; init.el --- by Takuma Matsushita -*- coding: utf-8 ; lexical-binding: t -*-

;;; Commentary:

;; ver.2021-08-01
;; This 

;;; Code:

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
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
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; package

(require 'package)

(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
; (add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)

(package-initialize)

;; utility

(use-package ace-window
  :ensure t
  :bind
  ("M-o" . 'ace-window))

(use-package all-the-icons
  :ensure t)

(use-package color-theme-sanityinc-tomorrow
  :ensure t
  :init
  (load-theme 'sanityinc-tomorrow-bright t))

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
  ("C-s" . 'consult-line)
  ("C-x b" . 'consult-buffer))

(savehist-mode 1)
(recentf-mode 1)


(use-package exec-path-from-shell
  :if (memq window-system '(mac ns))
  :ensure t
  :config
  (exec-path-from-shell-initialize))

(use-package imenu-list
  :ensure t
  :bind
  ("C-'" . 'imenu-list-smart-toggle))

(use-package multiple-cursors
  :ensure t
  :bind
  ("C-S-c"   . 'mc/edit-lines)
  ("C->"     . 'mc/mark-next-like-this)
  ("C-<"     . 'mc/mark-previous-like-this)
  ("C-c C-<" . 'mc/mark-all-like-this))

(use-package neotree
  :ensure t
  :config
  (setq neo-vc-integration '(face char))
  :bind
  ("C-]" . 'neotree-toggle))

(use-package quickrun
  :ensure t
  :bind
  ("C-c C-q" . 'quickrun))

(electric-pair-mode 1)

(use-package smart-mode-line
  :ensure t
  :config
  (setq sml/theme 'respectful)
  :hook
  (after-init . sml/setup))

;; git

(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status)
         ("C-x M-g" . magit-dispatch-popup)))

(use-package diff-hl
  :ensure t
  :hook
  (after-init . global-diff-hl-mode))

;; ai-tools

(use-package copilot-chat
  :ensure t
  :bind (("C-c C-c" . copilot-chat-display)))

(use-package vterm
  :ensure t
  :custom
  (vterm-max-scrollback 1000))

;; language

; lsp

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

;; (use-package lsp-mode
;;   :ensure t
;;   :init
;;   (setq lsp-keymap-prefix "s-l")
;;   :hook
;;   (prog-mode . lsp)
;;   :commands lsp)

; lisp

(use-package rainbow-delimiters
  :ensure t
  :config
  (add-hook 'lisp-mode-hook 'rainbow-delimiters-mode)
  (add-hook 'emacs-lisp-mode-hook 'rainbow-delimiters-mode))

; elixir

(use-package elixir-mode
  :ensure t)

; web

;; These packages may break exporting function such as `org-html-export-to-html`.

;; (use-package emmet-mode
;;   :ensure t
;;   :hook
;;   (html-mode . 'emmet-mode))

;; (use-package rainbow-mode
;;   :ensure t
;;   :hook
;;   (css-mode . 'rainbow-mode))

(use-package json-mode
  :ensure t)

;; config

; load-path

(setq load-path (append '("~/.emacs.d/elisp")
			'("~/.emacs.d/config")
			load-path))

(load "util")
;; (load "yatex-config")
;; (load "mode-line-config")
;; (load "sonic-pi-config")

; encoding

(set-language-environment   "UTF-8")
(prefer-coding-system       'utf-8)
(set-default-coding-systems 'utf-8)
(set-keyboard-coding-system 'utf-8)

; titlebar

(when (memq window-system '(mac ns))
  (add-to-list 'default-frame-alist '(ns-appearance . 'dark))
  (add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
  (setq ns-use-proxy-icon nil)
  (setq frame-title-format nil))

; fonts

(when (display-graphic-p)
  (set-face-attribute 'default nil :height 140)
  (set-frame-font "-*-Cica-normal-normal-normal-*-*-*-*-*-m-0-iso10646-1"))

;; ; backup

(setq make-backup-files nil)
(setq auto-save-default nil)
(setq delete-auto-save-files t)

; visual

(set-frame-parameter (selected-frame) 'alpha 80)

; bar

(menu-bar-mode   -1)
(tool-bar-mode   -1)
(scroll-bar-mode -1)

; startup message

(setq inhibit-startup-message t)

; which-function

(which-function-mode 1)

; hl-line

(global-hl-line-mode 0)

; for global-linum-mode

(add-hook 'prog-mode-hook
          (lambda ()
            (display-line-numbers-mode 1)))

; y-or-n-p

(fset 'yes-or-no-p 'y-or-n-p)

; paren

(show-paren-mode 1)

; blink

(blink-cursor-mode 0)

; beep

(setq ring-bell-function 'ignore)

; save excursion

(require 'saveplace)
(if (>= emacs-major-version 25)
    (save-place-mode 1)
  (setq-default save-place t))

; tab space

(setq-default indent-tabs-mode nil)
;; (setq-default show-trailing-whitespace t)

; global

(bind-key* "C-h" 'backward-delete-char)

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

;;; init.el ends here

