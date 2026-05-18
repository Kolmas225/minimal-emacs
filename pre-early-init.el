;;; pre-early-init.el --- Pre Early Init -*- lexical-binding: t; -*-

;; (setq debug-on-error t)

;; By default, minimal-emacs-package-initialize-and-refresh is set to t, which
;; makes minimal-emacs.d call the built-in package manager. Since Elpaca will
;; replace the package manager, there is no need to call it.
(setq minimal-emacs-package-initialize-and-refresh nil)

;; Disabling both site-run-file and default.el removes system-level
;; interference, reduces startup variability, and establishes a fully controlled
;; initialization environment suitable for minimal and reproducible
;; configurations.
(setq site-run-file nil)
(setq inhibit-default-init t)

(defun display-startup-time ()
  "Display the startup time and number of garbage collections."
  (message "Emacs init loaded in %.2f seconds (Full emacs-startup: %.2fs) with %d garbage collections."
           (float-time (time-subtract after-init-time before-init-time))
           (time-to-seconds (time-since before-init-time))
           gcs-done))

(add-hook 'emacs-startup-hook #'display-startup-time 100)
