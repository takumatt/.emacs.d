(defconst ciel-search-mode
  '((paren . ("(" ")" "[()]"))
    (brace . ("[" "]" "[][]"))))

(defun ciel-ci (arg)
  (interactive "cci: ")
  (let ((pos-open  (find-open-paren  "[()]"))
        (pos-close (find-close-paren "[()]")))
    (kill-region pos-open pos-close)))

(defun ciel--search-backward (regexp &optional stack)
  (cond ((ciel--found-open-paren)
         (car stack))
        (t (let ((pos (search-backward-paren regexp)))
             (setq stack (push-or-pop-to-stack pos stack)))
           (ciel--search-backward regexp stack))))

(defun push-or-pop-to-stack (pos stack)
  (let (paren-type (paren-type pos))))

(defun is-same-type-paren (first second)
  (= (cadr first) (cadr second)))

(defun paren-type pos
  (cond ((string= (char-string-after pos) "(")
         '(open  paren))
        ((string= (char-string-after pos) ")")
         '(close paren))))

(defun char-string-after (pos)
  (char-to-string (char-after pos)))

(defun find-open-paren (regexp &optional stack)
  (cond ((and (= (length stack) 1) (is-open (char-after (car stack))))
         (car stack))
        (t (let ((pos (search-backward-paren regexp)))
             (setq stack (stack-ni-tsumuka-kimeru pos stack)))
           (find-open-paren regexp stack))))

(defun find-close-paren (regexp &optional stack)
  (cond ((and (= (length stack) 1) (is-close (char-after (car stack))))
         (car stack))
        (t (let ((pos (search-forward-paren regexp)))
             (setq stack (stack-ni-tsumuka-kimeru pos stack)))
           (find-close-paren regexp stack))))

(defun stack-ni-tsumuka-kimeru (pos stack)
  (cond ((is-opposite pos (car stack))
         (cons pos stack))
        (t (cdr stack))))

(defun is-open (char)
  (string= (char-to-string char) "("))

(defun is-close (char)
  (string= (char-to-string char) ")"))

(defun is-opposite (first second)
  (= (char-after first) (char-after second)))

(defun search-backward-paren (regexp)
  (unless (re-search-backward regexp nil t)
    (signal'no-match-paren-error))
  (point))

(defun search-forward-paren (regexp)
  (unless (re-search-forward regexp nil t)
    (signal'no-match-paren-error))
  (point))

