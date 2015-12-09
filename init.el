(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(company-abort-manual-when-too-short nil)
 '(company-auto-complete (quote (quote company-explicit-action-p)))
 '(company-auto-complete-chars (quote (32 95 40 41 46 39)))
 '(company-completion-cancelled-hook nil)
 '(company-global-modes t)
 '(company-idle-delay 0.2)
 '(company-require-match nil)
 '(minimap-always-recenter nil)
 '(minimap-dedicated-window t)
 '(minimap-hide-fringes nil)
 '(minimap-minimum-width 10)
 '(minimap-recenter-type (quote middle))
 '(minimap-update-delay 0.1)
 '(minimap-width-fraction 0.1))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(minimap-active-region-background ((t (:background "gray40"))))
 '(minimap-font-face ((t (:height 30)))))

(require 'package)
(setq package-enable-at-startup nil)
(package-initialize)
(setq package-archives
      '(("gnu" . "https://elpa.gnu.org/packages/")
	("marmalade" . "https://marmalade-repo.org/packages/")
	("melpa" . "https://melpa.org/packages/")))
(package-refresh-contents)

(setq inhibit-startup-message t)
(setq inhibit-splash-screen t)
(scroll-bar-mode -1)
(fringe-mode '(1 . 1))
(column-number-mode 1)
(show-paren-mode 1)
(blink-cursor-mode -1)
;; (display-time-mode 1)
;; (display-battery-mode 1)

(require 'smart-mode-line)
(setq sml/no-confirm-load-theme t)
(setq sml/theme 'powerline)
(sml/setup)

(require 'nyan-mode)
(nyan-mode)
(nyan-start-animation)
(setq nyan-wavy-trail t)

(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

(defun font-existsp (font)
  (if (null (x-list-fonts font))
      nil
    t))

(defvar my-font "Droid Sans Mono 10")
(when (font-existsp my-font)
  (progn
    (set-face-attribute 'default nil :font my-font)
    (set-frame-font my-font) nil t))

(require 'color-theme)
(color-theme-initialize)
(color-theme-classic)

(require 'sublimity)
;; (require 'sublimity-scroll)
;; (require 'sublimity-map)
(require 'sublimity-attractive)
(sublimity-mode 1)
;; (setq sublimity-scroll-weight 5)
;; (setq sublimity-scroll-drift-length 10)
(setq sublimity-attractive-centering-width 150)
(sublimity-attractive-hide-vertical-border)
(sublimity-attractive-hide-bars)
;; (sublimity-attractive-hide-fringes)
;; (sublimity-attractive-hide-modelines)
;; (setq sublimity-map-size 30)
;; (setq sublimity-map-fraction 0.3)
;; (setq sublimity-map-text-scale -7)
;; (sublimity-map-set-delay nil)

(require 'fill-column-indicator)
(setq-default fci-rule-column 80)
(setq fci-rule-width 1)
(setq fci-rule-color "darkred")

(require 'minimap)
;; (minimap-mode)

(require 'company)

(add-to-list 'company-backends 'company-jedi)
(add-to-list 'company-backends 'company-auctex)
;; (add-to-list 'company-backends 'company-ghc)
(add-hook 'after-init-hook 'global-company-mode)

(require 'ido)
(ido-mode t)

(require 'smex)
(smex-initialize)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
;; This is your old M-x.
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)
(defadvice smex (around space-inserts-hyphen activate compile)
  (let ((ido-cannot-complete-command
	 `(lambda ()
	    (interactive)
	    (if (string= " " (this-command-keys))
		(insert ?-)
	      (funcall ,ido-cannot-complete-command)))))
    ad-do-it))

(require 'uncrustify-mode)
(add-hook 'c-mode-common-hook
	  '(lambda ()
	     (uncrustify-mode 1)))

(dolist (hook '(text-mode-hook))
  (add-hook hook (lambda () (flyspell-mode 1))))
(dolist (hook '(change-log-mode-hook log-edit-mode-hook))
  (add-hook hook (lambda () (flyspell-mode -1))))
(dolist (hook '(tex-mode-hook))
  (add-hook hook (lambda () (flyspell-mode 1))))

(require 'golden-ratio)
(golden-ratio-mode 1)
