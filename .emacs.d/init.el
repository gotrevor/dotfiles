(add-to-list 'load-path "~/third/rspec-mode")
(require 'rspec-mode)


;; from http://stackoverflow.com/questions/5710334/how-can-i-get-mouse-selection-to-work-in-emacs-and-iterm2-on-mac
;; see also: http://www.emacswiki.org/emacs/SmoothScrolling
;; Enable mouse support
(unless window-system
  (require 'mouse)
  (xterm-mouse-mode t)
  (global-set-key [mouse-4] (lambda ()
                              (interactive)
                              (scroll-down 1)))
  (global-set-key [mouse-5] (lambda ()
                              (interactive)
                              (scroll-up 1)))
  (defun track-mouse (e))
  (setq mouse-sel-mode t)

;; NOTE(tmorris) these don't appear to do anything
;; scroll one line at a time (less "jumpy" than defaults)
    (setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
    (setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
    (setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
    (setq scroll-step 1) ;; keyboard scroll one line at a time
)

;;; The Package Manager
;; this is most important addition to emacs24
;; M-x list-packages to view available packages
;; i to mark to install ;; d to mark to delete
;; x to execute those actions
(require 'package)
(setq package-archives
'(("gnu" . "http://elpa.gnu.org/packages/")
("marmalade" . "http://marmalade-repo.org/packages/")))
(package-initialize)

;;; Making things pretty
(setq inhibit-splash-screen t) ; turn off splash screen

;; To change the font
;; (set-frame-font "Font Name 16")

;; To load a theme
;; (load-theme 'theme-name)

;; disable pesky menus and scroll bars (uncomment to unclutter)
;; (menu-bar-mode -1)
;; (tool-bar-mode -1)
;; (scroll-bar-mode -1)
;; prevent the whole window from flashing on bell
(when (equal system-type 'darwin)
(setq ring-bell-function #'ignore
visible-bell nil))

(setq-default indent-tabs-mode nil) ; turn off tabs, use spaces instead
(column-number-mode t) ; shows column number next to line number

;;; Loading Code
;; add common directories for extensions to the load-path
;; so they can be require'd
(mapc (apply-partially #'add-to-list 'load-path)
'("~/.emacs.d/lisp"
"~/.emacs.d/site-lisp"
"~/.emacs.d/themes"))

(add-to-list 'load-path "~/third/rspec-mode")
(require 'rspec-mode)



;;; Language Modes
;; Set ruby mode for some extra extensions that aren't on by default in Emacs 24:
(add-to-list 'auto-mode-alist (cons "\.rake$" 'ruby-mode))
(add-to-list 'auto-mode-alist (cons "Gemfile$" 'ruby-mode))

;;; Customizations
;; Don't edit this section by hand, instead call M-x customize or
;; customize-group and use the menus.
(custom-set-variables
'(uniquify-buffer-name-style (quote post-forward) nil (uniquify)))
