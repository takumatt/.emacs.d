;; (require 'all-the-icons)

;; window number

;; (defun custom-modeline-window-number ()
;;   (propertize (format " %c" (+ 9311 (window-numbering-get-number)))
;;               'face `(:height ,(/ (* 0.90 powerline/default-height) 100.0))
;;               'display '(raise 0.0)))

;; ;; mode icon

;; (defun custom-modeline-mode-icon ()
;;   (format " %s"
;;     (propertize icon
;;                 'help-echo (format "Major-mode: `%s`" major-mode)
;;                 'face `(:height 1.2 :family ,(all-the-icons-icon-family-for-buffer)))))

;; ;; version control

;; (defun -custom-modeline-github-vc ()
;;   (let ((branch (mapconcat 'concat (cdr (split-string vc-mode "[:-]")) "-")))
;;     (concat
;;      (propertize (format " %s" (all-the-icons-alltheicon "git")) 'face `(:height 1.2) 'display '(raise -0.1))
;;      " · "
;;      (propertize (format "%s" (all-the-icons-octicon "git-branch"))
;;                  'face `(:height 1.3 :family ,(all-the-icons-octicon-family))
;;                  'display '(raise -0.1))
;;      (propertize (format " %s" branch) 'face `(:height 0.9)))))

;; (defun -custom-modeline-svn-vc ()
;;   (let ((revision (cadr (split-string vc-mode "-"))))
;;     (concat
;;      (propertize (format " %s" (all-the-icons-faicon "cloud")) 'face `(:height 1.2) 'display '(raise -0.1))
;;      (propertize (format " · %s" revision) 'face `(:height 0.9)))))

;; (defun custom-modeline-icon-vc ()
;;   (when vc-mode
;;     (cond
;;       ((string-match "Git[:-]" vc-mode) (-custom-modeline-github-vc))
;;       ((string-match "SVN-" vc-mode) (-custom-modeline-svn-vc))
;;       (t (format "%s" vc-mode)))))

;; ;; time

;; (defun custom-modeline-time ()
;;   (let* ((hour (string-to-number (format-time-string "%I")))
;;          (icon (all-the-icons-wicon (format "time-%s" hour) :height 1.3 :v-adjust 0.0)))
;;     (concat
;;      (propertize (format-time-string " %H:%M ") 'face `(:height 0.9))
;;      (propertize (format "%s " icon) 'face `(:height 1.0 :family ,(all-the-icons-wicon-family)) 'display '(raise -0.0)))))

;; ;; mode-line-format

;; (setq mode-line-format '("%e" (:eval 
;;   (concat
;;     (custom-modeline-window-number)
;;     (custom-modeline-mode-icon)
;;     (custom-modeline-icon-vc)
;;     (custom-modeline-time)))))

