;;; parinfer-smart-mode.el --- parinfer-smart-mode   -*- lexical-binding: t; -*-

;; Copyright (C) 2019  Justin Barclay

;; Author: Justin Barclay <justinbarclay@gmail.com>
;; URL: https://github.com/justinbarclay/parinfer-smart-mode
;; Version: 0.1.0
;; Package-Requires: ((emacs "25"))
;; Keywords: lisps

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;; This file is not part of GNU Emacs.

;;; Commentary: A file for functions not strictly related to making parinfer work

;; A helper library to download a precompiled library for you

;;; Code:
(require 'url)
(require 'cl)

(defconst ask-to-download "Could not find the parinfer-rust library, would you like to automatically download it from github?")
(defconst outdated-version "You are using a parinfer-rust library that is not compatible with this file, would you like to download the appropriate file from github?")

(defun check-for-library (library-location lib-name)
  "Checks for the existence of the parinfer-rust library and if it can't be found it offers to download it for the user"
  (when (and (not (file-exists-p library-location)) ;; Using when here instead of unless so we can early exit this if file does exist
             (yes-or-no-p ask-to-download))
    (download-from-github library-location lib-name)))

;; This function has a problem: Emacs can't reload dynamic libraries. This means that if we download a new library the user has to restart Emacs.
(defun check-parinfer-rust-version (supported-version library-location lib-name)
  "Checks to see if parinfer-rust version library currently installed is compatible with parinfer-smart-helper.
   If it is not compatible, offer to download the file for the user"
  (when (and (parinfer-rust-version)
             (not (equalp
                   (parinfer-rust-version)
                   supported-version))
             (yes-or-no-p outdated-version))
    (download-from-github library-location lib-name)
    (message "A new version has been downloaded, you will need to reload Emacs for the changes to take effect.")))

(defun download-from-github (library-location lib-name)
  (url-copy-file (format "https://raw.githubusercontent.com/justinbarclay/parinfer-smart-mode/master/%s" lib-name)
                 library-location
                 't))

(provide 'parinfer-helper)
