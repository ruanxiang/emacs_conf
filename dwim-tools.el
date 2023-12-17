;;; dwim-tools.el --- My dwim functions -*- lexical-binding: t; -*-

;; @2023 Xiang Ruan All rights reserved

;; My dwim functions
;; Copy the functions that you find useful to the Emacs init file and evaluate them.
;; Do not forget to install dwim-shell-commands mode. 

;; ;; Usage
;; Refer to the comments at the beginning of each funtion.


;; dwim
;; https://github.com/xenodium/dwim-shell-command
(require 'dwim-shell-commands)

;; my functions

;; ;; Convert the marked files to PDF
;; ;; 
;; Note: dwim includes some functions that can convert different file formats to PDF. However, I believe using the libreoffice command is better than other methods such as LaTeX, which is used by dwim's default functions.
;; It is important to mention that in order to use this function, you need to have libreoffice installed on your system.'
;; ;; Usage
;; Mark files
;; M-x my/dwim-shell-commands-file-to-pdf
(defun my/dwim-shell-commands-file-to-pdf()
  "Convert the marked files to PDF"
  (interactive)
  (dwim-shell-command-on-marked-files
   "Convert to pdf"
   (format "libreoffice --headless --invisible --convert-to pdf '<<f>>'")
   :utils "libreoffice"))

;; ;; Extract pages from a PDF and merge them into a new PDF.
;; ;;
;; This function extracts pages from a PDF file and merges the extracted pages into a new PDF.
;; To use the function, you need to have pdftk installed on your system.
;; Usage:
;; Find the PDF in dired.
;; M-x my/dwim-shell-command-extract-pdf-to-new-pdf.
;; Input the page number(s) you want to extract. The format to specify page numbers follows pdftk's:
;; For a single page, simply input the page number (e.g., 3, 4, 16).
;; For a page range, use the format: 1-4, 30-43.
;; Use commas to separate individual pages or page range. For example, if you want to extract pages 1, 3, 10, 11, 12, 13, and 50, you can input the function as: 1, 3, 10-13, 50.
;; After inputting the page number(s), you will be asked to input a new merged PDF file name. Press enter to use the default output file name: merged.pdf.
(defun my/dwim-shell-command-extract-pdf-to-new-pdf()
  "Extract pdf pages and merge to new pdf"
  (interactive)
  (dwim-shell-command-on-marked-files
   "Extract pdf pages and merge to new pdf"
   (format "pdftk '<<f>>' cat %s output '<<%s(u)>>'"
           (read-string "Page numbers: ")
           (dwim-shell-command-read-file-name
            "output file name (default \"merged.pdf\"): "
            :extension "pdf"
            :default "merged.pdf"))
   :utils "pdftk"))

;; ;; Remove PDF password
;; ;;
;; This function uses pdftk to remove the password from a PDF and save it to another file.
;; To use the function, you need to have pdftk installed on your system.
;; Usage:
;; 1. Find the PDF in dired.
;; 2. M-x my/dwim-shell-command-remove-pdf-pwd()
;; 3. You will be asked for the password of the PDF.
;; 4. Then you need to input a new PDF file name. Press enter to use the default output file name: removed.pdf.
(defun my/dwim-shell-command-remove-pdf-pwd()
  "Remove password from a PDF and save it to another file"
  (interactive)
  (dwim-shell-command-on-marked-files
   "Remove password of the PDF and save to another file"
   (format "pdftk '<<f>>' input_pw %s output '<<%s(u)>>'"
           (read-passwd "Password: ")
           (dwim-shell-command-read-file-name
            "output file name (default \"removed.pdf\"): "
            :extension "pdf"
            :default "removed.pdf"))
   :utils "pdftk"))

;; ;; Shrink a PDF file to a smaller size
;; ;;
;; This function. utilizes ps2pdf to resize the PDF file, so make sure you have ps2pdf installed on your system.
;; Usage: 
;; 1. Navigate to the PDF file in dired.
;; 2. Run the command 'M-x my/dwim-shell-command-shrink-pdf'.
;; 3. You will be prompted to enter the image resolution. The default is 200, which generally works well unless you have specific requirements. Press enter to use the default value.
;; 4. Next, you will be asked to provide a new name for the resized PDF file. Press enter to use the default output file name: resized.pdf.
(defun my/dwim-shell-command-shrink-pdf()
  "Shrink a PDF file to a small size"
  (interactive)
  (dwim-shell-command-on-marked-files
   "Resize PDF file to small size"
   (format "ps2pdf -dPDFSETTINGS=/screen -dDownsampleColorImages=true -dColorImageResolution=%d -dColorImageDownsampleType=/Bicubic '<<f>>' '<<%s(u)>>'"
           (read-number "Image Resolution:(default:200): ")
           (dwim-shell-command-read-file-name
            "output file name (default \"resized.pdf\"): "
            :extension "pdf"
            :default "resized.pdf"))
   :utils "ps2pdf"))

;; ;; Merge multiple PDF files into a new file.
;; ;; 
;; This function merges multiple PDF files into one.
;; Make sure you have ps2pdf installed on your system.
;; Usage:
;; 1. Mark the PDF files you want to merge in dired.
;; 2. Run the command 'M-x my/dwim-shell-command-merge-pdfs'.
;; 3. You will be prompted to enter a new name for the merged PDF file. Press enter to use the default output file name: merged.pdf.
(defun my/dwim-shell-command-merge-pdfs()
  "Merge multiple PDF files into a new file."
  (interactive)
  (dwim-shell-command-on-marked-files
   "Merge multiple pdf files"
   (format "pdftk '<<*>>' cat output '<<%s(u)>>'"
           (dwim-shell-command-read-file-name
            "output file name (default \"merged.pdf\"): "
            :extension "pdf"
            :default "merged.pdf"))
   :utils "pdftk"))

;; ;; Merging multiple video files into a new mp4 file.
;; ;; 
;; This function is used to merge multiple video files into a new mp4 file.
;; Make sure you have ffmpeg installed on your system.
;; Usage:
;; 1. Mark the video files you want to merge in dired.
;; 2. Run the command 'M-x my/dwim-shell-command-merge-videos'.
;; 3. You will be prompted to enter a new name for the merged video files. Press enter to use the default output file name: output.mp4.
;; NOTE: The videos being merged should be in the same format or codec, otherwise the result may not be as expected.
(defun my/dwim-shell-command-merge-videos()
  "Generate merged mp4 video "
  (interactive)
  (dwim-shell-command-on-marked-files
   "Merge videos: the videos being merged should be the same format or codec, otherwise the result may not be as expected."
   (format "ffmpeg -f concat -safe 0 -i ./mergedfilelist.txt -c copy '<<%s(u)>>'; rm -rf ./mergedfilelist.txt"
           (dwim-shell-command-read-file-name
            "output file name (default \"output.mp4\"): "
            :extension "mp4"
            :default "output.mp4")
           (dwim-shell-command-on-marked-files
            "Make file list for merging"
            (format "echo file '<<f>>' >> ./mergedfilelist.txt"
                    :extension "txt"
                    ))
           :utils "ffmpeg")
   ))

;; ;; Uncompress file with password
;; ;; 
;; This function uncompresses a file with a password.
;; The function uses unrar to uncompress the file, so make sure you have unar installed on your system.
;; Usage:
;; 1. Navigate to the file in dired.
;; 2. Run the command 'M-x my/dwim-shell-command-unar-with-password'.
;; 3. You will be prompted to enter the password.
;; NOTE: From my personal experience, I find unar to be a better tool than unzip for uncompressing files.
(defun my/dwim-shell-command-unar-with-password()
  "Uncompress file with password"
  (interactive)
  (dwim-shell-command-on-marked-files
   "Extract compression file with password"
   (format "unar -p %s '<<f>>'"
           (read-passwd "Password: ")
           )
   :utils "unar"))


;; ;; Convert images to PDF
;; ;; 
;; This function uses the convert command to convert images to a PDF file.
;; Make sure you have ImageMagick installed on your system.
;; Usage:
;; 1. Mark files in dired.
;; 2. Run the command 'M-x my/dwim-shell-command-convert-images-to-pdf'.
;; 3. You will be prompted to enter the quality, default is 100. A higher quality number will result in a larger output file size. From my personal experience, 100 works well most of the time.
;; 4. Then you will be asked to input the output file name. Press enter to use the default file name: merged.pdf.

;; NOTE: dwim-shell-commands has a tool called dwim-shell-commands-join-as-pdf. However, I found that dwim's function produces output files with very small resolution. I didn't check its source code, so maybe I didn't use the function correctly. Anyway, I created my own function.

;; Troubleshooting:
;; If you receive the below error message while using my function:
;; "convert: attempt to perform an operation not allowed by the security policy `PDF' @ error/constitute.c/IsCoderAuthorized/408"
;; This is caused by ImageMagick's security policy setting; it is not a bug.
;; You can fix it by editing /etc/ImageMagick-6/coder.xml (Find the file in its proper location on your system, as different systems or different versions of ImageMagick may have different file locations).
;; Find <policy domain="coder" rights="none" pattern="PDF" />, and modify it to:
;; <policy domain="coder" rights="read|write" pattern="PDF" />.

(defun my/dwim-shell-command-convert-images-to-pdf()
  "Covert images to PDF"
  (interactive)
  (dwim-shell-command-on-marked-files
   "Covert images to pdf"
   (format "convert '<<f>>' -quality %s '<<%s(u)>>'"
           (read-string "Quality (number like 100): ")
           (dwim-shell-command-read-file-name
            "output file name (default \"merged.pdf\"): "
            :extension "pdf"
            :default "merged.pdf"))
   :utils "convert"))
