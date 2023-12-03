;;; correct-or-translate-by-gpt.el --- A small function for correcting or translating a selected text region.-*- lexical-binding: t; -*-

;; @2023 Xiang Ruan All rights reserved

;; The tool simply correct or translate selected text in English/Chinese/Japanese
;; It is based on [[https://github.com/rksm/org-ai][org-ai]], a great ChatGPT frontend in Emacs.
;; To use this tool, you need to first install org-ai mode in Emacs. Check org-ai (https://github.com/rksm/org-ai) for how to install the mode
;; Once you have installed org-ai, copy this code to your init file or just evaluate it in Emacs, then you can M-x my/correct-or-translate-by-gpt to invoke the function

;; ;; Usage
;; Select any words or text, and M-x my/correct-or-translate-by-gpt
;; The function will first ask to choose the mission: "Correct" or "Translate", then you got another question about which lanuage you want GPT to work with including "English", "Chinese" and "Japanese". You can certainly input any other language as you like.
;; After answer the questions, the function will show up a help buffer with its results. Check the result and copy it (if you need), and click "q" to quick the help buffer and go back to your working buffer

;; ;; Tips
;; As you can see, the tools is very simple, just give some pre-defined prompt to org-ai, thus, you can actually modify the tools for your own usage with whatever prompt you want to use


(require 'org-ai)
(defun targetlan (choice)
  "Choose target language"
  (interactive
   (let ((completion-ignore-case  t))
     (list (completing-read "Choose: " '("Chinese" "Japanese" "English") nil t))))
  choice)

(defun mission (choice)
  "Choose mission"
  (interactive
   (let ((completion-ignore-case  t))
     (list (completing-read "Choose: " '("Correct" "Translate" ) nil t))))
  choice)
(defun my/correct-or-translate-by-gpt (start end)
  "Translate selected region"
  (interactive "r")
  (setq mesg (concat 
              (call-interactively 'mission)
              " the below in "
              (call-interactively 'targetlan)
              ": '"
              (buffer-substring start end) "'"))
  (with-help-window
      (let ((buf (get-buffer-create "*ans*")))
        (with-current-buffer buf
          (setq buffer-read-only t)
          (buffer-name)))
    (org-ai-prompt mesg)
                                       )    
  (pop-to-buffer "*ans*" nil t)
  )


