(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)

(setq-default indent-tabs-mode nil)

(defvar my-packages '(starter-kit
                      starter-kit-lisp
                      starter-kit-bindings
                      starter-kit-eshell
                      clojure-mode
                      clojure-test-mode
                      cider
                      auto-complete))

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

;; (setq nrepl-hide-special-buffers t)
;; (add-hook 'nrepl-interaction-mode-hook
;;           'nrepl-turn-on-eldoc-mode)
;; (add-hook 'nrepl-mode-hook 'rainbow-delimiters-mode)
;; (add-hook 'nrepl-mode-hook 'paredit-mode)
;; (add-hook 'nrepl-mode-hook 'rainbow-delimiters-mode)
;(add-hook 'cider-repl-mode-hook 'rainbow-delimiters-mode)
(add-hook 'cider-mode-hook 'cider-turn-on-eldoc-mode)
(setq nrepl-hide-special-buffers t)
(setq cider-popup-stacktraces nil)
(setq cider-repl-history-size 10000)
(add-hook 'cider-repl-mode-hook 'subword-mode)
(add-hook 'cider-repl-mode-hook 'paredit-mode)
(add-hook 'cider-repl-mode-hook 'rainbow-delimiters-mode)


;; Autocomplete
(require 'auto-complete-config)
(ac-config-default)
(setq ac-delay 0.3)
(setq ac-dwim nil) ; To get pop-ups with docs even if a word is uniquely completed

(add-hook 'nrepl-interaction-mode-hook
          'nrepl-turn-on-eldoc-mode)

;; ac-slime
;; (require 'ac-slime)
;; (add-hook 'clojure-mode-hook 'set-up-slime-ac)
;; (add-hook 'slime-mode-hook 'set-up-slime-ac)
;; (add-hook 'slime-repl-mode-hook 'set-up-slime-ac)
;; (eval-after-load "auto-complete" '(add-to-list 'ac-modes 'slime-repl-mode))
;; (eval-after-load "auto-complete" '(add-to-list 'ac-modes 'slime-mode))
;; (eval-after-load "auto-complete" '(add-to-list 'ac-modes 'clojure-mode))

;; dirty fix for having AC everywhere
;; (define-globalized-minor-mode real-global-auto-complete-mode
;;   auto-complete-mode (lambda ()                       
;; (if (not (minibufferp (current-buffer)))                           
;;     (auto-complete-mode 1))))
;; (real-global-auto-complete-mode t)

;; CLJS
;; (add-to-list 'auto-mode-alist '("\.cljs$" . clojure-mode))
