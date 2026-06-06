;;; post-init.el --- Post Init -*- lexical-binding: t; -*-

(use-package compile-angel
  :demand t
  :config
  ;; Set `compile-angel-verbose' to nil to disable compile-angel messages.
  ;; (When set to nil, compile-angel won't show which file is being compiled.)
  (setq compile-angel-verbose t)

  ;; Uncomment the line below to compile automatically when an Elisp file is saved
  ;; (add-hook 'emacs-lisp-mode-hook #'compile-angel-on-save-local-mode)

  ;; The following directive prevents compile-angel from compiling your init
  ;; files. If you choose to remove this push to `compile-angel-excluded-files'
  ;; and compile your pre/post-init files, ensure you understand the
  ;; implications and thoroughly test your code. For example, if you're using
  ;; the `use-package' macro, you'll need to explicitly add:
  ;; (eval-when-compile (require 'use-package))
  ;; at the top of your init file.
  (push "/init.el" compile-angel-excluded-files)
  (push "/early-init.el" compile-angel-excluded-files)
  (push "/pre-init.el" compile-angel-excluded-files)
  (push "/post-init.el" compile-angel-excluded-files)
  (push "/pre-early-init.el" compile-angel-excluded-files)
  (push "/post-early-init.el" compile-angel-excluded-files)
  (push "/local.el" compile-angel-excluded-files)

  ;; A global mode that compiles .el files before they are loaded
  ;; using `load' or `require'.
  (compile-angel-on-load-mode 1))

;;; Font
(set-face-attribute 'default nil :font "Maple Mono-13")
(set-face-attribute 'fixed-pitch nil :font "Maple Mono-13")
(set-face-attribute 'fixed-pitch-serif nil :font "Maple Mono-13")

(set-face-attribute 'variable-pitch nil :family "Inter-13")

;; CJK font
(dolist (script '(cjk-misc han kana hangul))
  (set-fontset-font t script "LXGW WenKai Screen"))

;; Maximise initial frame
;; (add-hook 'window-setup-hook #'toggle-frame-maximized)
(add-to-list 'initial-frame-alist '(fullscreen . maximized))

(use-package batppuccin
  :config
  (let ((inhibit-redisplay t))
    ;; Disable all other active themes
    (mapc #'disable-theme custom-enabled-themes)
    (load-theme 'batppuccin-macchiato t)))

;;; Enable automatic insertion and management of matching pairs of characters
;;; (e.g., (), {}, "") globally using `electric-pair-mode'.
(use-package elec-pair
  :ensure nil
  :commands (electric-pair-mode
             electric-pair-local-mode
             electric-pair-delete-pair)
  :hook (after-init . electric-pair-mode))

;; repeat-mode
(use-package repeat
  :ensure nil
  :custom
  (repeat-exit-timeout 5)
  (repeat-exit-key "<escape>")
  (repeat-echo-function #'repeat-echo-message)
  (set-mark-command-repeat-pop t)
  :init
  ;; FIXME: fixed in emacs-31
  (defun shut-up--advice (fn &rest args)
    (let* ((inhibit-message t)
           (message-log-max))
      (apply fn args)))
  (advice-add #'repeat-mode :around #'shut-up--advice)
  
  (repeat-mode 1))

;; save-place-mode enables Emacs to remember the last location within a file
;; upon reopening. This feature is particularly beneficial for resuming work at
;; the precise point where you previously left off.
(use-package saveplace
  :ensure nil
  :commands (save-place-mode save-place-local-mode)
  :hook
  (after-init . save-place-mode)
  :init
  (setq save-place-limit 400))

;; auto-save-visited
(use-package files
  :ensure nil
  :custom
  (auto-save-visited-interval 30)
  :init
  (auto-save-visited-mode 1))

;; Set the fringes to match the pixel height of a character. This ensures the
;; fringe is wide enough, scaling dynamically with the current font size.
(fringe-mode (frame-char-width))

;; When Delete Selection mode is enabled, typed text replaces the selection
;; if the selection is active.
(use-package delsel
  :ensure nil
  :init
  (delete-selection-mode 1))

;; Highlight current line
(use-package hl-line
  :ensure nil
  :init
  (global-hl-line-mode 1))

;; Display the current line and column numbers in the mode line
(setq line-number-mode t)
(setq column-number-mode t)

;; Display of line numbers in the buffer:
(use-package display-line-numbers
  :ensure nil
  :custom
  (display-line-numbers-type 'visual)
  (display-line-numbers-width-start t)
  (display-line-numbers-widen t)
  :hook
  ((prog-mode conf-mode text-mode) . #'display-line-numbers-mode))

(use-package simple
  :ensure nil
  :custom
  (global-visual-line-mode t))

(use-package treesit
  :ensure nil
  :custom
  ;; Set the maximum level of syntax highlighting for Tree-sitter modes
  (treesit-font-lock-level 4))

;; Paren match highlighting
(add-hook 'after-init-hook #'show-paren-mode)

(setopt tab-width 4
        c-basic-offset 4
        echo-keystrokes 0.01
        history-delete-duplicates t
        ;; kill-ring
        mark-ring-max 8
        global-mark-ring-max 10
        kill-ring-max 50
        bookmark-fringe-mark nil)

(unless (and (eq window-system 'mac)
             (bound-and-true-p mac-carbon-version-string))
  ;; Enables `pixel-scroll-precision-mode' on all operating systems and Emacs
  ;; versions, except for emacs-mac.
  ;;
  ;; Enabling `pixel-scroll-precision-mode' is unnecessary with emacs-mac, as
  ;; this version of Emacs natively supports smooth scrolling.
  ;; https://bitbucket.org/mituharu/emacs-mac/commits/65c6c96f27afa446df6f9d8eff63f9cc012cc738
  (setq pixel-scroll-precision-use-momentum nil) ; Precise/smoother scrolling
  (pixel-scroll-precision-mode 1))

;; Track changes in the window configuration, allowing undoing actions such as
;; closing windows.
(setq winner-boring-buffers '("*Completions*"
                              "*Minibuf-0*"
                              "*Minibuf-1*"
                              "*Minibuf-2*"
                              "*Minibuf-3*"
                              "*Minibuf-4*"
                              "*Compile-Log*"
                              "*inferior-lisp*"
                              "*Fuzzy Completions*"
                              "*Apropos*"
                              "*Help*"
                              "*cvs*"
                              "*Buffer List*"
                              "*Ibuffer*"
                              "*esh command on file*"))
(add-hook 'after-init-hook #'winner-mode)

;; Windmove
(use-package windmove
  :ensure nil
  :custom
  (windmove-wrap-around 't)
  :config
  ;; Shift-arrow
  (windmove-default-keybindings)
  ;; Ctrl-arrow
  (windmove-display-default-keybindings)
  ;; Ctrl-Shift-arrow
  (windmove-swap-states-default-keybindings '(control))
  ;; C-x Shift-arrow
  (windmove-delete-default-keybindings))

;; tab-bar
(use-package tab-bar
  :ensure nil
  :custom
  (tab-bar-show 1)
  (tab-bar-new-tab-choice "*scratch*")
  (tab-bar-auto-width nil))

(use-package uniquify
  :ensure nil
  :custom
  (uniquify-buffer-name-style 'reverse)
  (uniquify-separator "•")
  (uniquify-after-kill-buffer-p t))

(use-package dired
  :ensure nil
  :custom
  (dired-dwim-target t)
  (dired-listing-switches
   "-AGFhlv --group-directories-first --time-style=long-iso")
  ;; Constrain vertical cursor movement to lines within the buffer
  (dired-movement-style 'bounded-files)
  (dired-omit-files (concat "\\`[.]\\'"
                            "\\|\\(?:\\.js\\)?\\.meta\\'"
                            "\\|\\.\\(?:elc|a\\|o\\|pyc\\|pyo\\|swp\\|class\\)\\'"
                            "\\|^\\.DS_Store\\'"
                            "\\|^\\.\\(?:svn\\|git\\)\\'"
                            "\\|^\\.ccls-cache\\'"
                            "\\|^__pycache__\\'"
                            "\\|^\\.project\\(?:ile\\)?\\'"
                            "\\|^flycheck_.*"
                            "\\|^flymake_.*"))
  (dired-kill-when-opening-new-dired-buffer t)
  ;; dired-aux
  (dired-do-revert-buffer t)
  (dired-movement-style 'cycle)
  :hook
  ;; Dired buffers: Automatically hide file details (permissions, size,
  ;; modification date, etc.) and all the files in the `dired-omit-files' regular
  ;; expression for a cleaner display.
  (dired-mode . dired-hide-details-mode)
  (dired-mode . dired-omit-mode)
  (dired-mode . dired-isearch-filenames-mode)
  :bind
  ("C-x d" . #'dired-jump)
  (:map ctl-x-4-map
        ("d" . #'dired-jump-other-window))
  (:map dired-mode-map
        ("C-M-k" . #'dired-kill-subdir)
        ("C-+" . dired-create-empty-file)))

(use-package wdired
  :ensure nil
  :bind
  (:map dired-mode-map
        ("C-c C-e" . #'wdired-change-to-wdired-mode)))

;; Enables visual indication of minibuffer recursion depth after initialization.
(add-hook 'after-init-hook #'minibuffer-depth-indicate-mode)

;; Configure Emacs to ask for confirmation before exiting
(setq confirm-kill-emacs 'y-or-n-p)

;; compile-mode
(use-package compile
  :ensure nil
  :custom
  (compilation-always-kill t)
  (compilation-scroll-output t)
  ;; (compilation-auto-jump-to-first-error t)
  :bind
  ("<f5>" . #'compile)
  ("<f6>" . #'recompile)
  :config
  (add-hook 'compilation-filter-hook #'ansi-color-compilation-filter)

  ;; ref: https://github.com/LionyxML/emacs-solo/blob/df3354b01ef9128a70d7213805e6d5ef63209d4e/init.el#L240C3-L242C80
  (defun my/ignore-compilation-status (&rest _)
    (setq compilation-in-progress nil))
  (advice-add 'compilation-start :after #'my/ignore-compilation-status))

;; Eldoc
(use-package eldoc
  :ensure nil
  :custom
  (eldoc-idle-delay 0.5)
  (eldoc-echo-area-use-multiline-p nil)
  (eldoc-echo-area-display-truncation-message nil)
  :config
  ;; from doom
  (defun my/emacs-lisp-append-value-to-eldoc-a (fn sym)
    "Display variable value next to documentation in eldoc."
    (when-let (ret (funcall fn sym))
      (if (boundp sym)
          (concat ret " "
                  (let* ((truncated " [...]")
                         (print-escape-newlines t)
                         (str (symbol-value sym))
                         (str (prin1-to-string str))
                         (limit (- (frame-width) (length ret) (length truncated) 1)))
                    (format (format "%%0.%ds%%s" (max limit 0))
                            (propertize str 'face 'warning)
                            (if (< (length str) limit) "" truncated))))
        ret)))
  (advice-add #'elisp-get-var-docstring
              :around
              #'my/emacs-lisp-append-value-to-eldoc-a))

(use-package which-func
  :ensure nil
  :custom
  (which-func-modes '(prog-mode))
  ;; (which-func-display 'header)
  (which-func-format `((:propertize (" ➤ " which-func-current)
                                    local-map ,which-func-keymap
                                    face which-func
                                    mouse-face mode-line-highlight
                                    help-echo "mouse-1: go to beginning\n\
mouse-2: toggle rest visibility\n\
mouse-3: go to end")))
  :hook
  (after-init . which-function-mode)
  :config
  (setq which-func-unknown "N/A"))

;;; Keybindings

(defun my/open-line-and-indent (n)
  "Like `newline-and-indent' for the `open-line' command."
  (interactive "*p")
  (let ((inhibit-message t)
        (eol (copy-marker (line-end-position))))
    (open-line n)
    (indent-region (point) eol)
    (set-marker eol nil)))

;; taken from doom
(defun my/empty-newline-above ()
  "Insert an indented new line before the current one."
  (interactive)
  (beginning-of-line)
  (save-excursion (newline))
  (indent-according-to-mode))

(defun my/empty-newline-below ()
  "Insert an indented new line after the current one."
  (interactive)
  (end-of-line)
  (newline-and-indent))

(defun my/backward-kill-line (&optional arg)
  (interactive "P")
  (if arg
      (kill-line (- arg))
    (kill-line 0)))

;; modified from https://stackoverflow.com/a/25212377
(defun my/rename-current-buffer-file ()
  "Renames current buffer and file it is visiting."
  (interactive)
  (let* ((name (buffer-name))
         (filename (buffer-file-name))
         (basename (and filename (file-name-nondirectory filename))))
    (if (not (and filename (file-exists-p filename)))
        (error "Buffer '%s' is not visiting a file!" name)
      (let ((new-name (read-file-name "Rename to: " (file-name-directory filename) basename nil basename)))
        (if (get-buffer new-name)
            (error "A buffer named '%s' already exists!" new-name)
          (rename-file filename new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil)
          (message "File '%s' successfully renamed to '%s'"
                   name (file-name-nondirectory new-name)))))))

(defun my/rename-current-or-write-new-file (&optional arg)
  "Write to new file / Rename current buffer file (when C-u)"
  (interactive "P")
  (if arg
      (call-interactively #'my/rename-current-buffer-file)
    (call-interactively #'write-file)))

(keymap-global-unset "<f2>")            ; 2C-mode

(keymap-global-set "C-o" #'my/open-line-and-indent)
(keymap-global-set "C-S-o" #'open-line)
(keymap-global-set "C-S-<return>" #'my/empty-newline-above)
(keymap-global-set "C-<return>" #'my/empty-newline-below)
(keymap-global-set "C-S-k" #'my/backward-kill-line)

(keymap-set mode-specific-map "q r" #'restart-emacs)
(keymap-set mode-specific-map "o x" #'scratch-buffer)

(keymap-set ctl-x-map "C-w" #'my/rename-current-or-write-new-file)
(keymap-set ctl-x-map "k" #'kill-current-buffer)

(keymap-global-set "M-=" #'count-words)
(keymap-global-set "M-c" #'capitalize-dwim)
(keymap-global-set "M-l" #'downcase-dwim)
(keymap-global-set "M-u" #'upcase-dwim)

;;; Packages

(use-package compat)

;; nerd-icons
(use-package nerd-icons
  :custom
  (nerd-icons-font-family "Symbols Nerd Font")
  :bind
  ("C-x 8 n" . #'nerd-icons-insert))

(use-package nerd-icons-completion
  :after marginalia
  :config
  (nerd-icons-completion-mode 1)
  (add-hook 'marginalia-mode-hook #'nerd-icons-completion-marginalia-setup))

(use-package nerd-icons-corfu
  :after corfu
  :config
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

(use-package nerd-icons-dired
  :hook
  (dired-mode . nerd-icons-dired-mode))

(use-package doom-modeline
  :custom
  (doom-modeline-enable-word-count t)
  (doom-modeline-total-line-number t)
  (doom-modeline-battery t)
  (doom-modeline-workspace-name nil)
  :config
  (doom-modeline-mode 1))

;; Helpful is an alternative to the built-in Emacs help that provides much more
;; contextual information.
(use-package helpful
  :commands (helpful-callable
             helpful-variable
             helpful-key
             helpful-command
             helpful-at-point
             helpful-function)
  :bind
  ("<remap> <describe-command>" . helpful-command)
  ("<remap> <describe-function>" . helpful-callable)
  ("<remap> <describe-key>" . helpful-key)
  ("<remap> <describe-symbol>" . helpful-symbol)
  ("<remap> <describe-variable>" . helpful-variable)
  ("C-h C-k" . #'helpful-kill-buffers)
  ("C-h F" . #'helpful-function)
  (:map emacs-lisp-mode-map
        ("C-h C-." . #'helpful-at-point))
  :custom
  (helpful-max-buffers 7))

(use-package rainbow-delimiters
  ;; :custom
  ;; (rainbow-delimiters-max-face-count 4)
  :hook
  (prog-mode . rainbow-delimiters-mode))

(use-package transient)
;;; Magit
(use-package magit
  :commands (magit magit-status)
  :after transient
  :custom
  ;; (magit-delete-by-moving-to-trash nil)
  (magit-copy-revision-abbreviated t)
  :bind
  ("C-x g" . #'magit-status)
  :config
  (with-eval-after-load 'project
    (keymap-set project-prefix-map "m" #'magit-project-status)
    (add-to-list 'project-switch-commands '(magit-project-status "Magit") t)))

;;; Completion
;; Vertico provides a vertical completion interface, making it easier to
;; navigate and select from completion candidates (e.g., when `M-x` is pressed).
(use-package vertico
  :custom
  ;; (resize-mini-windows t)        ;resizing as results narrow down
  (vertico-resize nil)
  (vertico-count 13)
  (vertico-cycle t)
  :bind
  (:map vertico-map
        ("DEL" . #'vertico-directory-delete-char)
        ("C-<backspace>" . #'vertico-directory-delete-word)
        ("M-DEL" . #'vertico-directory-delete-word)
        ("M-s" . #'vertico-toggle-sort))
  :init
  (vertico-mode 1)
  :config  
  ;; toggle between history-length-alpha & alpha only
  (defun vertico-toggle-sort ()
    (interactive)
    (setq-local vertico-sort-override-function
                (and (not vertico-sort-override-function)
                     #'vertico-sort-alpha)
                vertico--input t)))

(use-package vertico-quick
  :ensure nil
  :after vertico
  :custom
  (vertico-quick1 "neiaho")
  (vertico-quick2 "crstdy")
  ;; unsetting the face then inherit from avy
  :custom-face
  (vertico-quick1 ((t (:foreground unspecified :background unspecified :inherit avy-lead-face))))
  (vertico-quick2 ((t (:foreground unspecified :background unspecified :inherit avy-lead-face-0))))
  :bind
  (:map vertico-map
        ("C-'" . #'vertico-quick-exit)))

;; Vertico leverages Orderless' flexible matching capabilities, allowing users
;; to input multiple patterns separated by spaces, which Orderless then
;; matches in any order against the candidates.
(use-package orderless
  :custom
  ;; (orderless-smart-case nil)
  ;; (completion-ignore-case t)
  ;; (read-buffer-completion-ignore-case t)
  ;; (read-file-name-completion-ignore-case t)
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '(;(file (styles partial-completion))
                                   (eglot (styles orderless))))
  (orderless-component-separator #'orderless-escapable-split-on-space) ; Use backslash for literal space
  ;; (completion-pcm-leading-wildcard t) ; emacs-31
  )

;; Marginalia allows Embark to offer you preconfigured actions in more contexts.
;; In addition to that, Marginalia also enhances Vertico by adding rich
;; annotations to the completion candidates displayed in Vertico's interface.
(use-package marginalia
  :init 
  (marginalia-mode t))

;; Embark integrates with Consult and Vertico to provide context-sensitive
;; actions and quick access to commands based on the current selection, further
;; improving user efficiency and workflow within Emacs. Together, they create a
;; cohesive and powerful environment for managing completions and interactions.
(use-package embark
  ;; Embark is an Emacs package that acts like a context menu, allowing
  ;; users to perform context-sensitive actions on selected items
  ;; directly from the completion interface.
  :commands (embark-act
             embark-dwim
             embark-export
             embark-collect
             embark-bindings
             embark-prefix-help-command)
  :custom
  (embark-indicators
   '(embark-minimal-indicator  ; default is embark-mixed-indicator
     embark-highlight-indicator
     embark-isearch-highlight-indicator))
  ;; (embark-prompter #'embark-completing-read-prompter) ;always prompt for action
  :bind
  ("C-." . embark-act)
  ("C-;" . embark-dwim)
  ("C-h C-h" . nil)
  ("<remap> <describe-bindings>" . #'embark-bindings)
  (:map embark-file-map
        ("0" . #'make-empty-file))
  :init
  (setq prefix-help-command #'embark-prefix-help-command)

  :init
  (setq prefix-help-command #'embark-prefix-help-command)

  :config
  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

(use-package embark-consult)

;; Consult offers a suite of commands for efficient searching, previewing, and
;; interacting with buffers, file contents, and more, improving various tasks.
(use-package consult
  :bind (;; C-c bindings in `mode-specific-map'
         ("C-c M-x" . consult-mode-command)
         ("C-c h" . consult-history)
         ("C-c k" . consult-kmacro)
         ("C-c m" . consult-man)
         ("C-c i" . consult-info)
         ("<remap> <Info-search>" . consult-info)
         ;; C-x bindings in `ctl-x-map'
         ("C-x M-:" . consult-complex-command)
         ("C-x b" . consult-buffer)
         ("C-x 4 b" . consult-buffer-other-window)
         ("C-x 5 b" . consult-buffer-other-frame)
         ("C-x t b" . consult-buffer-other-tab)
         ("C-x r b" . consult-bookmark)
         ("C-x p b" . consult-project-buffer)
         ;; Custom M-# bindings for fast register access
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)
         ;; M-g bindings in `goto-map'
         ("M-g e" . consult-compile-error)
         ("M-g f" . consult-flymake)
         ("M-g g" . consult-goto-line)
         ("M-g M-g" . consult-goto-line)
         ("M-g o" . consult-outline)
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; M-s bindings in `search-map'
         ("M-s d" . consult-fd)
         ("M-s r" . consult-ripgrep)
         ("M-s c" . consult-locate)
         ("M-s g" . consult-git-grep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ;; Isearch integration
         ("M-s e" . consult-isearch-history)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)
         ("M-s e" . consult-isearch-history)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ;; Minibuffer history
         :map minibuffer-local-map
         ("M-s" . consult-history)
         ("M-r" . consult-history))

  :init
  ;; Optionally configure the register formatting. This improves the register
  (setq register-preview-delay 0.5
        register-preview-function #'consult-register-format)

  ;; Optionally tweak the register preview window.
  (advice-add #'register-preview :override #'consult-register-window)

  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  ;; Aggressive asynchronous that yield instantaneous results. (suitable for
  ;; high-performance systems.) Note: Minad, the author of Consult, does not
  ;; recommend aggressive values.
  ;; Read: https://github.com/minad/consult/discussions/951
  ;;
  ;; However, the author of minimal-emacs.d uses these parameters to achieve
  ;; immediate feedback from Consult.
  ;; (setq consult-async-input-debounce 0.02
  ;;       consult-async-input-throttle 0.05
  ;;       consult-async-refresh-delay 0.02)

  :config
  (consult-customize
   consult-theme :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file consult-xref
   consult-source-bookmark consult-source-file-register
   consult-source-recent-file consult-source-project-recent-file
   ;; :preview-key "M-."
   :preview-key '(:debounce 0.4 any))
  (setq consult-narrow-key "<"))

;; Corfu enhances in-buffer completion by displaying a compact popup with
;; current candidates, positioned either below or above the point. Candidates
;; can be selected by navigating up or down.
(use-package corfu
  :commands (corfu-mode global-corfu-mode)
  :custom
  ;; Hide commands in M-x which do not apply to the current mode.
  (read-extended-command-predicate #'command-completion-default-include-p)
  ;; Disable Ispell completion function. As an alternative try `cape-dict'.
  (text-mode-ispell-word-completion nil)
  (tab-always-indent 'complete)
  (tab-first-completion nil)
  
  (corfu-auto t)
  (corfu-preselect 'directory)
  (corfu-popupinfo-max-height 20)
  (corfu-preview-current nil)
  (corfu-auto-delay 0.25)
  (corfu-popupinfo-delay 0.25)
  ;; (corfu-echo-delay 0.25)
  (corfu-on-exact-match 'show)

  :bind
  (:map corfu-map
        ("RET" . nil)
        ("C-_" . #'corfu-reset))
  ;; Enable Corfu
  :init
  (global-corfu-mode 1)
  (corfu-popupinfo-mode 1)
  :config
  ;; add more command that will trigger corfu-auto
  (dolist (com '("\\`backward-kill-word"
                 "\\`kill-word"
                 "delete-forward-char\\'"))
    (add-to-list 'corfu-auto-commands com))
  
  ;; Completing in the minibuffer for some commands
  (defun corfu-enable-in-minibuffer ()
    "Enable Corfu in the minibuffer."
    (when (local-variable-p 'completion-at-point-functions)
      ;; (setq-local corfu-auto nil) ;; Enable/disable auto completion
      (setq-local corfu-echo-delay nil ;; Disable automatic echo and popup
                  corfu-popupinfo-delay nil)
      (corfu-mode 1)))
  (add-hook 'minibuffer-setup-hook #'corfu-enable-in-minibuffer))

(use-package corfu-quick
  :ensure nil
  :after corfu
  :custom
  (corfu-quick1 "neiaho")
  (corfu-quick2 "crstdy")
  :custom-face
  (corfu-quick1 ((t (:foreground unspecified :background unspecified :inherit avy-lead-face))))
  (corfu-quick2 ((t (:foreground unspecified :background unspecified :inherit avy-lead-face-0))))
  :bind
  (:map corfu-map
        ("C-'" . #'corfu-quick-complete)))

;; Cape, or Completion At Point Extensions, extends the capabilities of
;; in-buffer completion. It integrates with Corfu or the default completion UI,
;; by providing additional backends through completion-at-point-functions.
(use-package cape
  :commands (cape-dabbrev cape-file cape-elisp-block)
  :bind ("C-c p" . cape-prefix-map)
  :init
  (defun my/elisp-setup-capf ()
    (setq-local completion-at-point-functions
                '(cape-elisp-symbol t)))
  (add-hook 'emacs-lisp-mode-hook #'my/elisp-setup-capf)

  (defun my/elisp-block-capf ()
    (setq-local completion-at-point-functions
                `(cape-elisp-block
                  ,@completion-at-point-functions)))
  (add-hook 'org-mode-hook #'my/elisp-block-capf)
  (add-hook 'markdown-mode-hook #'my/elisp-block-capf)

  (dolist (capfs '(cape-keyword
                   cape-file
                   cape-dabbrev))
    (add-to-list 'completion-at-point-functions capfs t)))

(use-package vundo
  :commands vundo
  :custom
  (vundo-glyph-alist vundo-unicode-symbols)
  (vundo-compact-display t)
  :bind ("C-x u" . #'vundo))

;; `vterm' is an Emacs terminal emulator that provides a fully interactive shell
;; experience within Emacs, supporting features such as color, cursor movement,
;; and advanced terminal capabilities. Unlike standard Emacs terminal modes,
;; `vterm' utilizes the libvterm C library for high-performance emulation. This
;; ensures accurate terminal behavior when running shell programs, text-based
;; applications, and REPLs.
(use-package vterm
  :if (bound-and-true-p module-file-suffix)
  :commands (vterm
             vterm-send-string
             vterm-send-return
             vterm-send-key
             vterm-module-compile)

  :bind
  ("C-c o T" . #'vterm)

  :preface
  (when noninteractive
    ;; vterm unnecessarily triggers compilation of vterm-module.so upon loading.
    ;; This prevents that during byte-compilation (`use-package' eagerly loads
    ;; packages when compiling).
    (advice-add #'vterm-module-compile :override #'ignore))

  (defun my-vterm--setup ()
    ;; Hide the mode-line
    (setq mode-line-format nil)

    ;; Inhibit early horizontal scrolling
    (setq-local hscroll-margin 0)

    ;; Suppress prompts for terminating active processes when closing vterm
    (setq-local confirm-kill-processes nil))

  :init
  (add-hook 'vterm-mode-hook #'my-vterm--setup)

  (setq vterm-timer-delay 0.05  ; Faster vterm
        vterm-kill-buffer-on-exit t
        vterm-max-scrollback 5000))

;; The easysession Emacs package is a session manager for Emacs that can persist
;; and restore file editing buffers, indirect buffers/clones, Dired buffers,
;; windows/splits, the built-in tab-bar (including tabs, their buffers, and
;; windows), and Emacs frames. It offers a convenient and effortless way to
;; manage Emacs editing sessions and utilizes built-in Emacs functions to
;; persist and restore frames.
(use-package easysession
  :commands (easysession-switch-to
             easysession-save-as
             easysession-save-mode
             easysession-load-including-geometry)

  :custom
  (easysession-mode-line-misc-info t)  ; Display the session in the modeline
  (easysession-save-interval (* 10 60))  ; Save every 10 minutes
  (easysession-buffer-list-function 'easysession-visible-buffer-list)

  :bind
  ("C-c ss" . #'easysession-save)
  ("C-c sl" . #'easysession-switch-to)
  ("C-c sL" . #'easysession-switch-to-and-restore-geometry)
  ("C-c sr" . #'easysession-rename)
  ("C-c sR" . #'easysession-reset)
  ("C-c sd" . #'easysession-delete)
  
  :init
  (easysession-setup)

  :config
  ;; vterm with associated session naming
  (defun my/vterm-for-session ()
    "Create a new vterm instance for current session."
    (interactive)
    (let ((vterm-session-name (concat "vterm-" (easysession-get-session-name))))
      (vterm vterm-session-name)))
  (keymap-set mode-specific-map "o t" #'my/vterm-for-session))
(use-package easysession-scratch
  :ensure nil
  :after easysession
  :init
  (easysession-scratch-mode 1))

(use-package buffer-terminator
  :custom
  ;; Enable/Disable verbose mode to log buffer cleanup events
  (buffer-terminator-verbose nil)

  ;; Set the inactivity timeout (in seconds) after which buffers are considered
  ;; inactive (default is 30 minutes):
  (buffer-terminator-inactivity-timeout (* 30 60)) ; 30 minutes

  ;; Define how frequently the cleanup process should run (default is every 10
  ;; minutes):
  (buffer-terminator-interval (* 10 60)) ; 10 minutes

  :config
  (buffer-terminator-mode 1))

;;; Avy
(use-package avy
  :commands (avy-goto-char-timer
             avy-goto-word-or-subword-1)
  :custom
  ;; (avy-background t)
  (avy-single-candidate-jump nil)
  (avy-all-windows nil)
  (avy-all-windows-alt t)
  (avy-keys '(?n ?e ?i ?a ?t ?s ?r ?c))
  (avy-dispatch-alist
   '((?x . avy-action-kill-move)
     (?d . avy-action-kill-stay)
     (?p . avy-action-teleport)
     (?m . avy-action-mark)
     (?v . avy-action-copy)
     (?y . avy-action-yank)
     (?z . avy-action-zap-to-char)
     (?. . avy-action-embark)))
  :bind
  ("C-'" . #'avy-goto-word-or-subword-1)
  ("C-\"" . #'avy-goto-char-timer)
  ("M-p" . #'avy-prev)
  ("M-n" . #'avy-next)
  :config
  ;; Taken from karthink's avy blog
  (defun avy-action-embark (pt)
    "embark-act on PT."
    (unwind-protect
        (save-excursion
          (goto-char pt)
          (embark-act))
      (select-window
       (cdr (ring-ref avy-ring 0))))
    t))

(use-package mwim
  :bind (("C-a" . mwim-beginning-of-code-or-line)
         ("C-e" . mwim-end-of-code-or-line)))

;;; isearch
(use-package isearch-mb
  :custom
  (isearch-lazy-count t)
  (isearch-regexp-lax-whitespace t)
  (search-whitespace-regexp ".*?")
  (search-ring-max 50)
  (regexp-search-ring-max 50)
  (lazy-count-prefix-format "[%s/%s] ")
  (isearch-repeat-on-direction-change t)
  (isearch-wrap-pause nil)      ;not needed with `isearch-mb' keybinds
  :bind
  (:map isearch-mb-minibuffer-map
        ;; ("M-e"  . #'consult-isearch-history)
        ("C-w" . #'isearch-yank-word-or-char)
        ("C-M-w" . #'isearch-yank-symbol-or-char)
        ("C-'" . #'avy-isearch)
        ;; ("M-s M-s" . #'consult-line)
        )
  :config
  (isearch-mb-mode 1)
  (add-to-list 'isearch-mb--with-buffer #'consult-isearch-history)
  (add-to-list 'isearch-mb--with-buffer #'isearch-yank-word-or-char)
  (add-to-list 'isearch-mb--with-buffer #'isearch-yank-symbol-or-char)
  (add-to-list 'isearch-mb--after-exit #'avy-isearch)
  (add-to-list 'isearch-mb--after-exit #'consult-line))

(use-package hl-todo
  ;; HACK https://github.com/alphapapa/magit-todos/issues/171#issuecomment-1934362142
  ;; :ensure (:depth nil)
  :ensure (:branch "main")
  :custom
  (hl-todo-highlight-punctuation ":")
  :bind
  ("M-s t i" . #'hl-todo-insert)
  :init
  (global-hl-todo-mode))

(use-package consult-todo
  :bind
  (:map search-map
        ("t t" . #'consult-todo)
        ("t d" . #'consult-todo-dir)
        ("t p" . #'consult-todo-project)
        ("t a" . #'consult-todo-all)))

;;; Spellchecking
(use-package jinx
  :custom
  (jinx-languages "en_GB")
  :bind
  ("M-$" . #'jinx-correct)
  ("C-M-$" . #'jinx-languages))

(use-package ligature
  :config
  ;; JetBrains Mono
  ;; disabled "-<"
  ;; removed from org-mode: "***"
  (let ((jetbrains-base-ligatures
         '("--" "---" "==" "===" "!=" "!==" "=!="
           "=:=" "=/=" "<=" ">=" "&&" "&&&" "&=" "++" "+++" ";;" "!!"
           "??" "???" "?:" "?." "?=" "<:" ":<" ":>" ">:" "<:<" "<>" "<<<" ">>>"
           "<<" ">>" "||" "-|" "_|_" "|-" "||-" "|=" "||=" "##" "###" "####"
           "#{" "#[" "]#" "#(" "#?" "#_" "#_(" "#:" "#!" "#=" "^=" "<$>" "<$"
           "$>" "<+>" "<+" "+>" "<*>" "<*" "*>" "</" "</>" "/>" "<!--" "<#--"
           "-->" "->" "->>" "<<-" "<-" "<=<" "=<<" "<<=" "<==" "<=>" "<==>"
           "==>" "=>" "=>>" ">=>" ">>=" ">>-" ">-" "-<<" ">->" "<-<" "<-|"
           "<=|" "|=>" "|->" "<->" "<~~" "<~" "<~>" "~~" "~~>" "~>" "~-" "-~"
           "~@" "[||]" "|]" "[|" "|}" "{|" "[<" ">]" "|>" "<|" "||>" "<||"
           "|||>" "<|||" "<|>" "..." ".." ".=" "..<" ".?" "::" ":::" ":=" "::="
           ":?" ":?>" "//" "///" "/*" "*/" "/=" "//=" "/==" "@_" "__" "???"
           "<:<" ";;;")))
    
    (ligature-set-ligatures
     'prog-mode
     (append jetbrains-base-ligatures '("***")))

    (ligature-set-ligatures
     'org-mode
     (append jetbrains-base-ligatures)))
  
  (global-ligature-mode t))

(use-package goggles
  :hook ((prog-mode text-mode) . goggles-mode))

(use-package indent-bars
  :custom
  (indent-bars-no-descend-lists t))

(use-package highlight-parentheses
  :custom
  (global-highlight-parentheses-mode t)
  (highlight-parentheses-delay 0.2)
  (highlight-parentheses-colors 'nil)
  (highlight-parentheses-attributes
   '((:underline t))))

(use-package puni
  :hook
  ((prog-mode sgml-mode nxml-mode tex-mode
              lisp-data-mode
              eval-expression-minibuffer-setup) . puni-mode)
  :bind
  (:map puni-mode-map
        ("M-(" . nil)
        ("M-)" . nil)
        ("C-{" . #'puni-syntactic-backward-punct)
        ("C-}" . #'puni-syntactic-forward-punct)
        ;; ("C-(" . #'puni-contract-region)
        ;; ("C-)" . #'puni-expand-region)
        ("C-<backspace>" . #'puni-backward-kill-word)
        ("C-M-t" . #'puni-transpose)
        ("C-, m" . #'puni-mark-sexp-around-point)
        ("C-, /" . #'puni-split)
        ("C-, ." . #'puni-raise)
        ("C-, ," . #'puni-splice)
        ("C-, i" . #'puni-splice-killing-backward)
        ("C-, e" . #'puni-splice-killing-forward)
        ("C-, n" . #'puni-slurp-backward)
        ("C-, a" . #'puni-slurp-forward)
        ("C-, N" . #'puni-barf-backward)
        ("C-, A" . #'puni-barf-forward)
        ("C-, c" . #'puni-convolute)
        ("C-, k" . #'puni-squeeze))
  :config
  ;; TEMP find a better way to do this
  (add-hook 'corfu-mode-hook
            (lambda ()
              (dolist (com '("\\`puni-backward-kill-word"
                             "\\`puni-backward-delete-char"
                             "puni-forward-kill-word\\'"
                             "puni-forward-delete-char\\'"))
                (add-to-list 'corfu-auto-commands com)))))

;; Context-aware 'go to definition' functionality for 50+ programming languages
(use-package dumb-jump
  :commands dumb-jump-xref-activate
  :init
  ;; Register `dumb-jump' as an xref backend so it integrates with
  ;; `xref-find-definitions'. A priority of 90 ensures it is used only when no
  ;; more specific backend is available.
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate 90)

  (setq dumb-jump-aggressive nil)
  ;; (setq dumb-jump-quiet t)

  ;; Number of seconds a rg/grep/find command can take before being warned to
  ;; use ag and config.
  (setq dumb-jump-max-find-time 3)

  ;; Use `completing-read' so that selection of jump targets integrates with the
  ;; active completion framework (e.g., Vertico, Ivy, Helm, Icomplete),
  ;; providing a consistent minibuffer-based interface whenever multiple
  ;; definitions are found.
  (setq dumb-jump-selector 'completing-read)

  ;; If ripgrep is available, force `dumb-jump' to use it because it is
  ;; significantly faster and more accurate than the default searchers (grep,
  ;; ag, etc.).
  (when (executable-find "rg")
    (setq dumb-jump-force-searcher 'rg)
    (setq dumb-jump-prefer-searcher 'rg)))

;;; Templates
(use-package tempel
  ;; :custom
  ;; (tempel-trigger-prefix "&")
  ;; (tempel-path (concat user-data-directory "templates/*.eld"))
  :bind
  ("M-+" . #'tempel-expand)
  ;; ("C-c i t" . #'tempel-insert)
  :config
  ;; NOTE corfu-on-exact-match is 'show globally
  ;; but 'insert works better with tempel-expand
  (when (featurep 'corfu)
    (advice-add #'tempel-expand :around
                (lambda (f &rest args)
                  "call `tempel-expand' with
`corfu-on-exact-match' being 'insert"
                  (let ((corfu-on-exact-match 'insert))
                    (apply f args))))))

;; TODO copy only needed templates instead of pulling the whole
;; package
(use-package tempel-collection
  :after tempel)

(use-package flymake
  :ensure nil
  :hook
  ;; use next-error for navigation
  (flymake-mode . (lambda ()
                    (setq-local next-error-function #'flymake-goto-next-error))))

(use-package flymake-popon
  :ensure
  (:repo "https://codeberg.org/akib/emacs-flymake-popon.git")
  :hook
  (prog-mode . flymake-popon-mode))

;; Set up the Language Server Protocol (LSP) servers using Eglot.
(use-package eglot
  :ensure nil
  :commands (eglot-ensure
             eglot-rename
             eglot-format-buffer)
  :hook
  (eglot-managed-mode . (lambda ()
                          ;; NOTE: ignore case for easier completion
                          (setq-local orderless-smart-case nil
                                      completion-ignore-case t)))
  :bind
  (:map eglot-mode-map
        ("M-` d" . #'eglot-find-declaration)
        ("M-` i" . #'eglot-find-implementation)
        ("M-` t" . #'eglot-find-typeDefinition)
        ("M-` r" . #'eglot-rename)
        ("M-` a" . #'eglot-code-actions)
        ("M-` o" . #'eglot-code-action-organize-imports)
        ("M-` q" . #'eglot-code-action-quickfix)
        ("M-` =" . #'eglot-format)))

(use-package consult-eglot
  :after eglot
  :bind
  (:map eglot-mode-map
        ("<remap> <xref-find-apropos>" . #'consult-eglot-symbols)))

(use-package consult-eglot-embark
  :after (consult-eglot embark)
  :config (consult-eglot-embark-mode 1))

(use-package eglot-tempel
  :preface (eglot-tempel-mode)
  :init
  (eglot-tempel-mode t))

(use-package eldoc-box
  :after eglot
  :custom
  (eldoc-box-clear-with-C-g t)
  :bind
  (:map eglot-mode-map
        ("C-h ." . #'eldoc-box-help-at-point)))

(use-package org
  :ensure nil
  :custom
  (org-directory "~/Documents/org/")
  (org-startup-folded "show2levels")
  (org-startup-indented t)
  (org-hide-emphasis-markers t)
  (org-refile-targets '((nil :maxlevel . 3)))
  (org-archive-location "~/Documents/org/archive.org::* From %s")
  ;; (org-auto-align-tags nil)
  (org-tags-column 0)
  (org-special-ctrl-a/e t)
  (org-special-ctrl-k t)
  (org-pretty-entities t)
  (org-log-done 'time)
  (org-return-follows-link t)
  :bind
  ("C-c l s" . #'org-store-link)
  ("C-M-<return>" . #'org-insert-subheading)
  (:map org-mode-map
        ("M-g i" . #'consult-org-heading)
        ("C-'" . #'avy-goto-char-2)
        ("C-," . nil))
  :config
  ;; open linke in current window
  (setf (alist-get 'file org-link-frame-setup) 'find-file))

(use-package org-appear
  :hook
  (org-mode . org-appear-mode))

(use-package org-modern
  :after org
  :custom
  (org-modern-star 'replace)
  (org-modern-hide-stars nil)
  ;; (org-modern-table nil)
  (org-modern-list
   '(;; (?- . "-")
     (?* . "•")
     (?+ . "‣")))
  (org-modern-block-name '("" . "")) ; or other chars; so top bracket is drawn promptly
  :hook
  (org-mode . org-modern-mode)
  (org-agenda-finalize . org-modern-agenda))

(use-package org-modern-indent
  :ensure
  (org-modern-indent
   :host github
   :repo "jdtsmith/org-modern-indent")
  :config ; add late to hook
  (add-hook 'org-mode-hook #'org-modern-indent-mode 90)
  ;; HACK https://github.com/jdtsmith/org-modern-indent/issues/10#issuecomment-1671726529
  (add-hook 'org-mode-hook (lambda () (aset org-indent--text-line-prefixes 0 (propertize " " 'face 'org-indent)))))

;; org-babel & source blocks
(use-package org
  :ensure nil
  :custom
  (org-edit-src-content-indentation 0)
  ;; trust the programmer, it can never go wrong
  (org-confirm-babel-evaluate nil)
  :config
  (setf (alist-get :noweb org-babel-default-header-args) "strip-export")
  (add-to-list 'org-src-lang-modes '("sh" . bash-ts))
  (add-to-list 'org-src-lang-modes '("bash" . bash-ts)))

(use-package apheleia
  :bind
  ("<f7>" . apheleia-format-buffer)
  ;; :init
  ;; ;; enabling auto format for all buffer
  ;; (apheleia-global-mode t)
  )

(use-package diff-hl
  :commands (diff-hl-mode
             global-diff-hl-mode)
  :hook (prog-mode . diff-hl-mode)
  :init
  (setq diff-hl-flydiff-delay 0.4)  ; Faster
  (setq diff-hl-show-staged-changes nil)  ; Realtime feedback
  (setq diff-hl-update-async t)  ; Do not block Emacs
  (setq diff-hl-global-modes '(not pdf-view-mode image-mode)))

;; Support for Git files (.gitconfig, .gitignore, .gitattributes...)
(use-package git-modes
  :commands (gitattributes-mode
             gitconfig-mode
             gitignore-mode)
  :mode (("/\\.gitignore\\'" . gitignore-mode)
         ("/info/exclude\\'" . gitignore-mode)
         ("/git/ignore\\'" . gitignore-mode)
         ("/.gitignore_global\\'" . gitignore-mode)  ; jc-dotfiles

         ("/\\.gitconfig\\'" . gitconfig-mode)
         ("/\\.git/config\\'" . gitconfig-mode)
         ("/modules/.*/config\\'" . gitconfig-mode)
         ("/git/config\\'" . gitconfig-mode)
         ("/\\.gitmodules\\'" . gitconfig-mode)
         ("/etc/gitconfig\\'" . gitconfig-mode)

         ("/\\.gitattributes\\'" . gitattributes-mode)
         ("/info/attributes\\'" . gitattributes-mode)
         ("/git/attributes\\'" . gitattributes-mode)))

(use-package markdown-ts-mode
  ;; FIXME: built-in in emacs-31
  ;; :ensure nil
  :mode ("\\.md\\'" . markdown-ts-mode)
  :config
  (add-to-list 'treesit-language-source-alist '(markdown "https://github.com/tree-sitter-grammars/tree-sitter-markdown" "split_parser" "tree-sitter-markdown/src"))
  (add-to-list 'treesit-language-source-alist '(markdown-inline "https://github.com/tree-sitter-grammars/tree-sitter-markdown" "split_parser" "tree-sitter-markdown-inline/src")))

(use-package go-ts-mode
  :ensure nil
  :mode "\\.go\\'"
  :custom
  (go-ts-mode-indent-offset 4)
  :hook 
  (go-ts-mode . subword-mode)
  (go-ts-mode . eglot-ensure)
  (go-ts-mode . (lambda () 
                  (add-hook 'before-save-hook #'eglot-format-buffer nil t))))

(use-package ruby-mode
  :ensure nil
  :custom
  (ruby-insert-encoding-magic-comment nil)
  (ruby-block-indent nil)
  (ruby-method-call-indent nil)
  :hook
  ;; FIXME Disabling popupinfo until this resolves
  ;; https://github.com/dgutov/robe/issues/144
  (ruby-base-mode . (lambda () (setq-local corfu-popupinfo-delay '(nil . 0.2))))
  ;; (ruby-base-mode . eglot-ensure)
  (ruby-base-mode . (lambda () (setq-local flycheck-checkers '(ruby-standard))))
  (ruby-base-mode . indent-bars-mode)
  (ruby-base-mode . subword-mode)
  :init
  (add-to-list 'major-mode-remap-alist '(ruby-mode . ruby-ts-mode))
  (add-to-list 'auto-mode-alist '("\\`[Rr]akefile\\(?:\\.rb\\)?\\'" . ruby-ts-mode))
  :config
  (with-eval-after-load 'apheleia
    (setf (alist-get 'ruby-mode apheleia-mode-alist)
          '(ruby-standard))
    (setf (alist-get 'ruby-ts-mode apheleia-mode-alist)
          '(ruby-standard)))
  ;; (with-eval-after-load 'eglot
  ;;   (add-to-list 'eglot-server-programs '((ruby-mode ruby-ts-mode) "ruby-lsp")))
  (with-eval-after-load 'org
    (add-to-list 'org-src-lang-modes '("ruby" . ruby-ts)))
  )

(use-package ruby-end
  :ensure
  (:host github :repo "Kolmas225/ruby-end.el" :files ("*.el"))
  :custom
  (ruby-end-insert-newline nil)
  :hook
  (ruby-base-mode . ruby-end-mode))

(use-package elixir-ts-mode
  :ensure nil
  :mode "\\.exs\\'")

(use-package rustic
  :after rust-mode
  :custom
  (rust-mode-treesitter-derive t)
  (rustic-lsp-client 'eglot)
  (rustic-cargo-use-last-stored-arguments t))

(use-package odin-mode
  :ensure
  (:host github :repo "mattt-b/odin-mode")
  :mode "\\.odin\\'"
  :hook
  (odin-mode . eglot-ensure)
  :config
  (with-eval-after-load 'apheleia
    (setf (alist-get 'odinfmt apheleia-formatters)
          '("odinfmt" "-stdin"))
    (setf (alist-get 'odin-mode apheleia-mode-alist)
          'odinfmt))
  (with-eval-after-load 'eglot
    (add-to-list 'eglot-server-programs '(odin-mode . ("ols")))))

(use-package just-ts-mode
  :mode ("\\(Justfile\\|justfile\\)\\'" . just-ts-mode))

;; Loading machine specific configs if exist
(minimal-emacs-load-user-init "local.el")
