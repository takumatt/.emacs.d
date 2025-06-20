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
 '(company-box-icons-alist 'company-box-icons-all-the-icons)
 '(custom-safe-themes
   '("3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa"
     "c74e83f8aa4c78a121b52146eadb792c9facc5b1f02c917e3dbb454fca931223"
     default))
 '(org-agenda-files '("~/memo.org"))
 '(package-selected-packages nil))
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

;; use-package

(eval-when-compile
  (require 'use-package))
(require 'bind-key)

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

(use-package counsel
  :ensure t
  :diminish counsel-mode ivy-mode
  :init
  (setq ivy-use-virtual-buffers t)
  (setq ivy-re-builders-alist
        '((swiper . ivy--regex-plus)
          (t      . ivy--regex-fuzzy)))
  :config
  (ivy-mode 1)
  (counsel-mode 1)
  :bind
  ("C-s" . 'swiper))

(use-package elscreen
  :ensure t
  :init
  (setq elscreen-display-tab nil)
  (setq elscreen-tab-display-kill-screen nil)
  (setq elscreen-tab-display-control nil)
  :hook
  (after-init . (lambda ()
                  (elscreen-start)
                  (elscreen-create)))
  :bind
  ("C-<tab>"     . 'elscreen-next)
  ("<C-iso-tab>" . 'elscreen-previous))

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

(use-package smartparens
  :ensure t
  :diminish smartparens-mode
  :init
  (smartparens-global-mode 1))

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

;; language

; lsp

(use-package company
  :ensure t
  :hook
  (after-init  . (lambda ()
                   (global-company-mode)))
  :bind
  (:map company-active-map
          ("C-n" . 'company-select-next)
          ("C-p" . 'company-select-previous)))

;; (use-package company-lsp
;;   :ensure t
;;   :init
;;   (push 'company-lsp company-backends))

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

