;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Emacs Configuration file
;;
;;written by Isis Lovecruft
;;
;;v.0.0.3 - Make sure "tab" is always four spaces
;;v.0.0.2 - Fix Tab funtionality and disable Yasnippet
;;v.0.0.1 - Initial config
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Initialize paths for modules

(add-to-list 'load-path "~/.emacs.d/vendor")
(progn (cd "~/.emacs.d/vendor")
       (normal-top-level-add-subdirs-to-load-path))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Four spaces, not tabs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq-default indent-tabs-mode nil)
(setq-default tab-width 4) ; set tab to 4 for all buffers
(custom-set-variables
 '(fill-column 78)
 '(tab-always-indent (quote complete)))
(custom-set-faces)

(add-hook 'html-mode-hook
        (lambda ()
          ;; Default indentation is 2 spaces, changing to 4.
          (set (make-local-variable 'sgml-basic-offset) 4)))
;(add-hook 'html-mode-hook
;              (lambda ()
;                (setq indent-line-function 'indent-relative)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Python Autocompletion
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Code for autocomplete.el and dictionaries

(add-to-list 'load-path "~/.emacs.d/")
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict/")
(ac-config-default)

(require 'python)
(require 'auto-complete)
;; Uncomment the following to load Yasnippet
;;(require 'yasnippet)

;; Reconfigure python-mode
 
(autoload 'python-mode "python-mode" "Python Mode." t)
(add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))
(add-to-list 'interpreter-mode-alist '("python" . python-mode))

;; Initialize Pymacs                                                                                           
(autoload 'pymacs-apply "pymacs")
(autoload 'pymacs-call "pymacs")
(autoload 'pymacs-eval "pymacs" nil t)
(autoload 'pymacs-exec "pymacs" nil t)
(autoload 'pymacs-load "pymacs" nil t)

;; Initialize Rope 
                            
(pymacs-load "ropemacs" "rope-")
(setq ropemacs-enable-autoimport t)

;; Initialize Yasnippet                                                            
;Don't map TAB to yasnippet                                                        
;In fact, set it to something we'll never use because                              
;we'll only ever trigger it indirectly. 
;                              
;(setq yas/trigger-key (kbd "C-c <kp-multiply>"))
;(yas/initialize)
;(yas/load-directory "~/.emacs.d/snippets")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;             
;;; Auto-completion                                                                
;;;  Integrates:                                                                   
;;;   1) Rope                             
;;;   2) Yasnippet                 
;;;   all with AutoComplete.el        
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
(defun prefix-list-elements (list prefix)
  (let (value)
    (nreverse
     (dolist (element list value)
      (setq value (cons (format "%s%s" prefix element) value))))))
(defvar ac-source-rope
  '((candidates
     . (lambda ()
         (prefix-list-elements (rope-completions) ac-target))))
  "Source for Rope")
(defun ac-python-find ()
  "Python `ac-find-function'."
  (require 'thingatpt)
  (let ((symbol (car-safe (bounds-of-thing-at-point 'symbol))))
    (if (null symbol)
        (if (string= "." (buffer-substring (- (point) 1) (point)))
            (point)
          nil)
      symbol)))
(defun ac-python-candidate ()
  "Python `ac-candidates-function'"
  (let (candidates)
    (dolist (source ac-sources)
      (if (symbolp source)
          (setq source (symbol-value source)))
      (let* ((ac-limit (or (cdr-safe (assq 'limit source)) ac-limit))
             (requires (cdr-safe (assq 'requires source)))
             cand)
        (if (or (null requires)
                (>= (length ac-target) requires))
            (setq cand
                  (delq nil
                        (mapcar (lambda (candidate)
                                  (propertize candidate 'source source))
                                (funcall (cdr (assq 'candidates source)))))))
        (if (and (> ac-limit 1)
                 (> (length cand) ac-limit))
            (setcdr (nthcdr (1- ac-limit) cand) nil))
        (setq candidates (append candidates cand))))
    (delete-dups candidates)))
(add-hook 'python-mode-hook
          (lambda ()
                 (auto-complete-mode 1)
                 (set (make-local-variable 'ac-sources)
                      (append ac-sources '(ac-source-rope)))
                 (set (make-local-variable 'ac-find-function) 'ac-python-find)
                 (set (make-local-variable 'ac-candidate-function) 'ac-python-candidate)
                 (set (make-local-variable 'ac-auto-start) nil)))

;;Isis' python specific tab completion
  ; Try the following in order:
  ; 1) If at the beginning of the line, indent
  ; 2) If at the end of the line, try to autocomplete
  ; 3) If the char after point is not alpha-numerical, try autocomplete
  ; 4) Try to do a regular python indent.
  ; 5) If at the end of a word, try autocomplete.

(define-key python-mode-map "\t" 'isis-python-expand)
(add-hook 'python-mode-hook
          (lambda ()
            (set (make-local-variable 'isis-indent/trigger-fallback) 'isis-python-expand)))
(defun isis-indent ()
  "Runs indent-for-tab-command but returns t if it actually did an indent; nil otherwise"
  (let ((prev-point (point)))
    (indent-for-tab-command)
    (if (eql (point) prev-point)
        nil
      t)))
(defun isis-python-expand ()
  (interactive)
  ;;1) Try indent at beginning of the line
  (let ((prev-point (point))
        (beginning-of-line nil))
    (save-excursion
      (move-beginning-of-line nil)
      (if (eql 0 (string-match "\\W*$" (buffer-substring (point) prev-point)))
          (setq beginning-of-line t)))
    (if beginning-of-line
        (isis-indent)))
  ;;2) Try autocomplete if at the end of a line, or
  ;;3) Try autocomplete if the next char is not alpha-numerical
  (if (or (string-match "\n" (buffer-substring (point) (+ (point) 1)))
          (not (string-match "[a-zA-Z0-9]" (buffer-substring (point) (+ (point) 1)))))
      (ac-start)
    ;;4) Try a regular indent
    (if (not (isis-indent))
        ;;5) Try autocomplete at the end of a word
        (if (string-match "\\W" (buffer-substring (point) (+ (point) 1)))
            (ac-start)))))

;; End Tab completion

;;Workaround so that Autocomplete is by default is only invoked explicitly,
;;but still automatically updates as you type while attempting to complete.
(defadvice ac-start (before advice-turn-on-auto-start activate)
  (set (make-local-variable 'ac-auto-start) t))
(defadvice ac-cleanup (after advice-turn-off-auto-start activate)
  (set (make-local-variable 'ac-auto-start) nil))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; End Auto Completion
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Begin .Org mode configuration
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The following lines are always needed.  Choose your own keys.
;     (add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
;     (add-hook 'org-mode-hook 'turn-on-font-lock) ; not needed when global-font-lock-mode is on
;     (global-set-key "\C-cl" 'org-store-link)
;     (global-set-key "\C-ca" 'org-agenda)
;     (global-set-key "\C-cb" 'org-iswitchb)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; End .Org mode configuration
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
