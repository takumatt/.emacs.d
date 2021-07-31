;; nippo

(defun nippo ()
  (interactive)
  (let ((time-string (parse-time-string (current-time-string))))
    (insert (format "【日報】 %d/%d まっと
```
やったこと
- 

ひとこと

```" (nth 4 time-string) (nth 3 time-string)))))

(defun hour-and-minute-to-string (lst)
  (format "%02d:%02d" (car lst) (cadr lst)))

(defun get-current-hour-and-minute-string ()
  (let ((time-string (parse-time-string (current-time-string))))
    (hour-and-minute-to-string
     (list (nth 2 time-string) (nth 1 time-string)))))

;; json

(defun json-format ()
  (interactive)
  (save-excursion
    (shell-command-on-region (region-beginning)
                             (region-end)
                             "python -m json.tool"
                             (buffer-name)
                             t)))

;; unix epoch

(defun unix-ts-to-str (&optional time zone)
  "Convert unix timestamp integer to human-readable string in RFC3339 format."
  (interactive "nTimestamp: ")
  (setq zone (or zone "UTC"))
  (setq ts-str (format "%s" (or time (current-word))))
  (if (numberp (read ts-str))
      (progn
        (setq ts-int (string-to-number ts-str))
        (setq rfc_str (format-time-string "%Y-%m-%dT%H:%M:%S%z" ts-int zone))
        (message (format "%d %s ==> %s" ts-int zone rfc_str))
        (kill-new rfc_str))
    (message "not a number")))
