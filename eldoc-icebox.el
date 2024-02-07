;;; eldoc-icebox.el --- Pop-up buffer with frozen copy of eldoc  -*- lexical-binding: t; -*-

;; Copyright (C) 2024  Paul D. Nelson

;; Author: Paul D. Nelson <nelson.paul.david@gmail.com>
;; Version: 0.0
;; URL: https://github.com/ultronozm/eldoc-icebox.el
;; Package-Requires: ((emacs "29.1"))
;; Keywords: docs

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; This package allows you to store a frozen copy of the content of
;; the `eldoc' buffer in a pop-up window.
;;
;; `eldoc-icebox-store': stores the copy, displays the window.
;; 
;; `eldoc-icebox-toggle-display': toggles the display.

;;; Code:

(defun eldoc-icebox-store ()
  "Freeze and display a copy of the *eldoc* buffer."
  (interactive)
  (let ((eldoc-content
         (with-current-buffer (eldoc-doc-buffer)
           (buffer-string)))
        (parent-buffer (current-buffer)))
    (with-current-buffer (get-buffer-create "*eldoc-icebox*")
      (let ((inhibit-read-only t))
        (special-mode)
        (erase-buffer)
        (insert eldoc-content)
        (setq-local eldoc-icebox-parent-buffer parent-buffer))
      (eldoc-icebox--display (current-buffer)))))

(defcustom eldoc-icebox-display-action
  '((display-buffer-in-direction)
    (direction . above)
    (window-height . 0.25))
  "Display action for the *eldoc-icebox* buffer."
  :type display-buffer--action-custom-type
  :group 'eldoc-icebox)

(defun eldoc-icebox--display (buffer)
  "Display BUFFER using `eldoc-icebox-display-action'."
  (let ((display-buffer-base-action
         eldoc-icebox-display-action))
    (display-buffer buffer)))

(defun eldoc-icebox-toggle-display ()
  "Toggle display of *eldoc-icebox* buffer."
  (interactive)
  (if-let ((buffer (get-buffer "*eldoc-icebox*")))
      (if-let (window (get-buffer-window buffer))
          (quit-window nil window)
        (eldoc-icebox--display buffer))
    (eldoc-icebox-store)))


(provide 'eldoc-icebox)
;;; eldoc-icebox.el ends here
