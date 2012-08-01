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
;;
;;    "Everytime you insert a tab into your code, a kitten
;;     somewhere dies..." -Arturo Filasto
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Defaults
;; ------------------
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4) ; set tab to 4 for all buffers

;; HTML
;; ------------------
(add-hook 'html-mode-hook
        (lambda ()
          ;; Default indentation is 2 spaces, changing to 4.
          (set (make-local-variable 'sgml-basic-offset) 4)))
;(add-hook 'html-mode-hook
;              (lambda ()
;                (setq indent-line-function 'indent-relative)))

;; C/C++
;; ------------------
;; Let's control C indentation separately, since Nick Mathewson is picky. :D
;;
;; Default styles include: 
;;   * "gnu":The default style for GNU projects
;;   * “k&r”: What Kernighan and Ritchie, the authors of C used in their book
;;   * “bsd”: What BSD developers use, aka “Allman style” after Eric Allman.
;;   * “whitesmith”: Popularized by the examples that came with Whitesmiths C, 
;;                   an early commercial C compiler.
;;   * “stroustrup”: What Stroustrup, the author of C++ used in his book
;;   * “ellemtel”: Popular C++ coding standards as defined by “Programming in 
;;                 C++, Rules and Recommendations” 
;;   * “linux”: What the Linux developers use for kernel development
;;   * “python”: What Python developers use for extension modules
;;   * “java”: The default style for java-mode (see below)
;;   * “user”: When you want to define your own style
;; --------------------

(setq c-default-style "linux"
      c-basic-offset 4)

;; The following autoindents after hitting return:
(require 'cc-mode)
(define-key c-mode-base-map (kbd "RET") 'newline-and-indent)

;; Automatically put parameters on their own lines if the function definition
;; line is too long:
(defconst my-c-lineup-maximum-indent 30)
(defun my-c-lineup-arglist (langelem)
  (let ((ret (c-lineup-arglist langelem)))
    (if (< (elt ret 0) my-c-lineup-maximum-indent)
        ret
      (save-excursion
        (goto-char (cdr langelem))
        (vector (+ (current-column) 8))))))
(defun my-indent-setup ()
  (setcdr (assoc 'arglist-cont-nonempty c-offsets-alist)
     '(c-lineup-gcc-asm-reg my-c-lineup-arglist)))
(add-hook 'cc-mode-hook 'my-indent-setup) ; NOTE: maybe 'java-mode-hook

;;
;; Colours & Keybindings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Prompt for a line and go to it with Ctrl-x+g
(global-set-key "\C-xg" 'goto-line)


;; LET ME USE ALL CAPS ON SELECTIONS, DAMMIT.
;; I LIKE YELLING IN MY CODE COMMENTS!
(put 'upcase-region 'disabled nil)

;; Customizations
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(fill-column 78)
 '(python-guess-indent nil)
 '(save-place t nil (saveplace))
 '(tab-always-indent (quote complete)))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(ac-gtags-candidate-face ((t (:background "red" :foreground "lightgray"))))
 '(ac-gtags-selection-face ((t (:foreground "red"))))
 '(ac-selection-face ((t (:background "red" :foreground "white"))))
 '(bold ((t (:weight extra-bold))))
 '(buffer-menu-buffer ((t (:inherit mode-line :inverse-video t))))
 '(cua-global-mark ((((class color)) (:background "cyan" :foreground "black"))))
 '(isearch ((((class color) (min-colors 8)) (:background "cyan" :foreground "black"))))
 '(isearch-fail ((((class color) (min-colors 8)) (:background "red" :foreground "black"))))
 '(italic ((((supports :underline t)) (:underline t :slant italic))))
 '(lazy-highlight ((((class color) (min-colors 8)) (:background "yellow" :foreground "black"))))
 '(match ((((class color) (min-colors 8) (background dark)) (:background "blue" :foreground "grey8"))))
 '(menu ((((type tty)) (:background "green" :foreground "black"))))
 '(mode-line ((t (:background "green" :foreground "black"))))
 '(mode-line-buffer-id ((t (:foreground "red"))))
 '(mode-line-highlight ((t (:inherit highlight))))
 '(mode-line-inactive ((default (:inherit mode-line)) (nil nil)))
 '(popup-isearch-match ((t (:background "sky blue" :foreground "black"))))
 '(popup-menu-selection-face ((t (:background "steelblue" :foreground "black"))))
 '(popup-scroll-bar-background-face ((t (:background "gray6" :foreground "cyan"))))
 '(query-replace ((t (:inherit isearch))))
 '(region ((((class color) (min-colors 8)) (:background "violet" :foreground "black")))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; EasyPG Auto(en|de)cryption
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; To use with orgmode, put this at the top of <file>.gpg:
;; -*- mode: org -*- 
;; -*- epa-file-encrypt-to: ("me@foo.org") -*-

;; Enable EasyPG in Emacs>=23
(require 'epa-file)
(epa-file-enable)

;; Enable EasyPG installed in path/to/epg
;(add-to-list 'load-path "path/to/epg")
;(require 'epa-setup)
;(epa-file-enable)

;; Disable use of gpg-agent while in remote shell:
(defadvice epg--start (around advice-epg-disable-agent disable)
  "Make epg--start not able to find a gpg-agent"
  (let ((agent (getenv "GPG_AGENT_INFO")))
    (setenv "GPG_AGENT_INFO" nil)
    ad-do-it
    (setenv "GPG_AGENT_INFO" agent)))

;; Bind (en|dis)abling of gpg-agent to M-x epg-enable-agent and
;; M-x epg-disable-agent respectively:
(defun epg-disable-agent ()
  "Make EasyPG bypass any gpg-agent"
  (interactive)
  (ad-enable-advice 'epg--start 'around 'advice-epg-disable-agent)
  (ad-activate 'epg--start)
  (message "EasyPG gpg-agent bypassed"))

(defun epg-enable-agent ()
  "Make EasyPG use a gpg-agent after having been disabled 
 with epg-disable-agent"
  (interactive)
  (ad-disable-advice 'epg--start 'around 'advice-epg-disable-agent)
  (ad-activate 'epg--start)
  (message "EasyPG gpg-agent re-enabled"))

;; Disable gpg-agent by default:
(epg-disable-agent)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Screen lock with zone mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; NOTE: requires package xtrlock to be installed
(require 'zone)
;(setq zone-idle (* 60 20))
;(zone-when-idle zone-idle)

;(defun lock-screen ()
;   "Lock screen using (zone) and xtrlock calls M-x zone on all frames
; and runs xtrlock"
;   (interactive)
;   (save-excursion
;     ;(shell-command "xtrlock &")
;     (set-process-sentinel
;      (start-process "xtrlock" nil "xtrlock")
;      '(lambda (process event)
;         (zone-leave-me-alone)))
;     ;(zone-when-idle 1)))
;     (zone-when-idle zone-idle)))

;; Activate the zone mode screensaver!
;;(lock-screen)

;; When not using X, don't show the menu bar
;(when (and (not window-system)
;           (fboundp 'menu-bar-mode))
;  (menu-bar-mode 0))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Python Autocompletion
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Code for autocomplete.el and dictionaries

(require 'python)
(require 'auto-complete)
;; Uncomment the following to load Yasnippet
;(require 'yasnippet)

;(add-to-list 'load-path "~/.emacs.d/vendor/auto-complete")
(add-to-list 'ac-dictionary-directories "~/.emacs.d/vendor/auto-complete/dict")
(require 'auto-complete-config)
(ac-config-default)

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
                 (set (make-local-variable 'ac-candidate-function) 
                      'ac-python-candidate)
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

