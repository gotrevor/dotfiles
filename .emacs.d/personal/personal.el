;; turned off smie, so that "to receive" broken lines indent reasonably
;; http://emacs.stackexchange.com/questions/4208/do-not-align-nested-calls-when-using-ruby-smie
(setq ruby-use-smie nil)

(add-to-list 'default-frame-alist '(height . 60))
(add-to-list 'default-frame-alist '(width . 112))


(require 'evil)
;(evil-mode t)
(global-set-key (kbd "H-SPC") 'hs-toggle-hiding)
(global-set-key (kbd "H-n") 'next-line)
(global-set-key (kbd "H-p") 'previous-line)

;; http://blog.jakubarnold.cz/2014/06/23/evil-mode-how-to-switch-from-vim-to-emacs.html
(define-key evil-normal-state-map (kbd ",f") 'projectile-find-file)
(define-key evil-normal-state-map (kbd ",,") 'evil-buffer)
(define-key evil-normal-state-map (kbd "q") nil)

(define-key evil-insert-state-map (kbd "C-e") nil)
(define-key evil-insert-state-map (kbd "C-d") nil)
(define-key evil-insert-state-map (kbd "C-k") nil)
(define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
(define-key evil-visual-state-map (kbd "C-c") 'evil-normal-state)

(define-key evil-normal-state-map (kbd "C-p") 'evil-previous-line)
(define-key evil-normal-state-map (kbd "C-n") 'evil-next-line)

(define-key evil-normal-state-map (kbd "H-SPC") 'hs-toggle-hiding)

;;(define-key evil-motion-state-map (kbd "C-e") nil)
;;(define-key evil-visual-state-map (kbd "C-c") 'evil-exit-visual-state)



(add-hook 'ruby-mode-hook
          (lambda () (linum-mode)))



;;https://coderwall.com/p/u-l0ra/ruby-code-folding-in-emacs
(add-hook 'ruby-mode-hook
          (lambda () (hs-minor-mode)))

(eval-after-load "hideshow"
  '(add-to-list 'hs-special-modes-alist
                `(ruby-mode
                  ,(rx (or "def" "class" "module" "do" "{" "[")) ; Block start
                  ,(rx (or "}" "]" "end"))                       ; Block end
                  ,(rx (or "#" "=begin"))                        ; Comment start
                  ruby-forward-sexp nil)))

(global-set-key (kbd "C-c h") 'hs-hide-block)
(global-set-key (kbd "C-c s") 'hs-show-block)

;;(set global-semantic-tag-folding-mode 1)

(add-hook 'before-save-hook 'delete-trailing-whitespace)

(add-hook 'after-init-hook #'global-flycheck-mode)

(setq-default flycheck-disabled-checkers '(ruby-rubylint))
