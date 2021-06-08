;;; flex.el --- Flexible Matching Library  -*- lexical-binding: t; -*-

;; Copyright (C) 2021  Shen, Jen-Chieh
;; Created date 2021-06-08 12:59:19

;; Author: Shen, Jen-Chieh <jcs090218@gmail.com>
;; Description: Flexible Matching Library
;; Keyword: flex fuzzy matching
;; Version: 0.0.2
;; Package-Requires: ((emacs "24.3"))
;; URL: https://github.com/jcs-elpa/flex

;; This file is NOT part of GNU Emacs.

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
;;
;; Flexible Matching Library
;;

;;; Code:

(require 'cl-lib)

(defconst flex-no-match 0.0
  "The score indicating a negative match.")

(defconst flex-match 1.0
  "The score indicating a full-match.")

(defconst flex-empty 0.8
  "The score to return when the abrreviation string is empty.")

;;;###autoload
(defun flex-score (string abbreviation)
  "Computes the score of matching STRING with ABBREVIATION.

The return value is in the range 0.0 to 1.0 the later being full-match."
  (let ((len (length abbreviation)))
    (cond ((= 0 len) flex-empty)
          ((> len (length string)) flex-no-match)
          (t (flex-build-score string abbreviation)))))

(defun flex-position (av string start end from-end)
  "Searchs a character AV on STRING backwards up until index END.
Arguments START and FROM-END are arguments fed to function `cl-position'."
  (or (cl-position (upcase av) string :start start :end end :from-end from-end)
      (cl-position (downcase av) string :start start :end end :from-end from-end)))

(defun flex-bits (string abbreviation)
  "Construct a float number representing the match score to STRING of given ABBREVIATION."
  (let ((score 0) (fws 0) (st 0) (ls (length string)) fe index av n)
    (catch 'failed
      (dotimes (i (length abbreviation))

        (setq av (elt abbreviation i) fe nil)
        (setq index (flex-position av string st ls fe))

        (unless index  ; could not find foward, try to backtrack
          (setq fe t)
          (setq index (flex-position
                       av string 0 (if (> st 0) st ls) fe)))

        (while (and index
                    (setq n (- (length string) index 1))
                    (= 1 (logand 1 (lsh score (* -1 n))))
                    (setq index (flex-position
                                 av string
                                 (if fe 0 (+ 1 index)) (if fe index ls) fe))))

        (unless index (throw 'failed flex-no-match))

        ;; rank first if we had a forward-match
        (unless fe (setq fws (+ 1 fws)))

        (setq st (+ 1 index))
        (setq score (logior score (lsh 1 n))))

      (logior score (lsh fws ls)))))

(defun flex-build-score (string abbreviation)
  "Calculates the fuzzy score of matching STRING with ABBREVIATION.

The score is a float number calculated based on the number characters
from `abbreviation' that match `string' and how immediate they are to each
other.

For example, for an `abbreviation' of 'instpkg', the score of

   'package-install' is 6.5819

and for

   'install-package' is 7.9400

meaning that the second one will appear first on text completion.

The numbers left to the decimal point are the count of how many
characters did match on a forward search, eg, in the first example,
'instpkg' matches 'inst' from chars 8 then has to backtrack for p but
'kg' are forward-found again, so the number of forward-matched chars is 6.
This means that abbreviations having not to backtrack are high scored
as it is a better extact match.

The numbers right to the decimal point are the ratio of how many
chars did matches in the string from the start position."
  (let ((bits (flex-bits string abbreviation)))
    (/ (* bits flex-match) (- (expt 2 (length string)) 1))))

(provide 'flex)
;;; flex.el ends here
