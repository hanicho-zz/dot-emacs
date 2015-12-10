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
 '(company-idle-delay 0.3)
 '(company-require-match nil)
 '(indent-guide-recursive nil)
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
(package-initialize)
(setq package-archives
      '(("gnu" . "https://elpa.gnu.org/packages/")
        ("marmalade" . "https://marmalade-repo.org/packages/")
        ("melpa" . "https://melpa.org/packages/")))

(when (not package-archive-contents)
  (package-refresh-contents))

(defvar my-packages
  '(color-theme
    company
    company-ghc
    company-jedi
    direx
    fill-column-indicator
    golden-ratio
    ido-vertical-mode
    ido-yes-or-no
    indent-guide
    latex-preview-pane
    minimap
    nyan-mode
    nyan-prompt
    projectile
    rainbow-delimiters
    rainbow-mode
    smart-mode-line
    smartparens
    smex
    sublimity
    uncrustify-mode
    whitespace-cleanup-mode
    zone))

(dolist (pack my-packages)
  (when (not (package-installed-p pack))
    (package-install pack)))

(setq inhibit-startup-message t)
(setq inhibit-splash-screen t)
(scroll-bar-mode -1)
(fringe-mode '(1 . 1))
(column-number-mode 1)
(show-paren-mode 1)
(blink-cursor-mode -1)
(setq-default indent-tabs-mode nil)
;; (display-time-mode 1)
;; (display-battery-mode 1)

(require 'smart-mode-line)
(setq sml/no-confirm-load-theme t)
(setq sml/theme 'powerline)
(sml/setup)

(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

(require 'battery)
(when (and battery-status-function
           (not (string-match-p "N/A" (battery-format "%B" (funcall battery-status-function)))))
  (display-battery-mode 1))

(require 'color-theme)
(color-theme-initialize)
(color-theme-classic)

(require 'smart-mode-line)
(setq sml/no-confirm-load-theme t)
(setq sml/theme 'powerline)
(sml/setup)

(require 'fill-column-indicator)
(setq-default fci-rule-column 80)
(setq fci-rule-width 1)
(setq fci-rule-color "darkred")

(require 'ido)
(require 'ido-yes-or-no)
(require 'ido-vertical-mode)
(ido-mode 1)
(ido-everywhere 1)
(ido-yes-or-no-mode 1)
(ido-vertical-mode 1)

(global-set-key (kbd "C-c C-c") 'comment-region)
(global-set-key (kbd "C-c C-d") 'uncomment-region)
(global-set-key (kbd "C-c C-r") 'replace-string)

(require 'smex)
(smex-initialize)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
;; This is your old M-x.
;; (global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

(defadvice smex (around space-inserts-hyphen activate compile)
  (let ((ido-cannot-complete-command
         `(lambda ()
            (interactive)
            (if (string= " " (this-command-keys))
                (insert ?-)
              (funcall ,ido-cannot-complete-command)))))
    ad-do-it))

(require 'direx)
(global-set-key (kbd "C-x C-j") 'direx:jump-to-directory)

(require 'company)
(require 'company-jedi)
(require 'company-ghc)
(add-to-list 'company-backends 'company-jedi)
(add-to-list 'company-backends 'company-ghc)
(add-hook 'after-init-hook 'global-company-mode)

(require 'uncrustify-mode)
(add-hook 'c-mode-common-hook
          '(lambda ()
             (uncrustify-mode 1)))

(add-hook 'java-mode-hook
          '(lambda ()
             (uncrustify-mode 1)))

(add-hook 'text-mode-hook
          (lambda ()
            (flyspell-mode 1)))

(add-hook 'tex-mode-hook
          (lambda ()
            (flyspell-mode 1)))

(dolist (hook '(change-log-mode-hook
                log-edit-mode-hook))
  (add-hook hook
            (lambda ()
              (flyspell-mode -1))))

(require 'projectile)
(require 'rainbow-delimiters)
(require 'indent-guide)
(require 'whitespace-cleanup-mode)
(add-hook 'prog-mode-hook
          '(lambda ()
             (projectile-mode 1)
             (rainbow-delimiters-mode 1)
             (indent-guide-mode 1)
             (whitespace-cleanup-mode 1)))
(setq projectile-enable-caching t)

(require 'rainbow-mode)
(rainbow-mode 1)

(require 'smartparens-config)
(smartparens-global-mode 1)

(require 'golden-ratio)
(golden-ratio-mode 1)

(when window-system
    (progn
      (defun font-existsp (font)
        (if (null (x-list-fonts font))
            nil
          t))

      (defvar my-font "Ubuntu Mono 11")
      (let ((set-font "Monospace 10"))
        (when (font-existsp my-font)
          (setq set-font my-font))

        (set-face-attribute 'default nil :font set-font))

      (global-unset-key (kbd "C-z"))

      (require 'minimap)
      ;; (minimap-mode)

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

      (require 'latex-preview-pane)
      (latex-preview-pane-enable)

      (require 'nyan-mode)
      (nyan-mode)
      (nyan-start-animation)
      (setq nyan-wavy-trail t)

      (require 'nyan-prompt)
      (add-hook 'eshell-load-hook 'nyan-prompt-enable)

      (require 'zone)
      (zone-when-idle 600)))
