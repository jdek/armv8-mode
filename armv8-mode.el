;;; -*- lexical-binding: t -*-
;;; armv8-mode.el --- Major mode for editing Advanced RISC Machine (v8) source code
;;; Version: 1
;;; Maintainer: Josh Dekker
;;; URL: https://github.com/jdek/armv8-mode

(defvar armv8-mode-hook nil
  "Hook for ARM major mode.")
(defcustom armv8-tab-width 4
  "Width of tabs for `armv8-mode'.")
(defcustom armv8-comment-char "@"
  "Character to denote inline comments.")
(defvar armv8-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "M-;") #'armv8-insert-comment)
    map)
  "Keymap for ARM major mode.")
;;;###autoload
(add-to-list 'auto-mode-alist '("\\.arm\\'" . armv8-mode))

;;;; font-lock, syntax highlighting
(defconst armv8-font-lock-keywords-1
  (eval-when-compile
    (let ((instrs (regexp-opt '("adc" "adcs" "add" "adds" "adr" "adrp" "and" "ands" "asr" "asrv" "at"
                                "beq" "bne" "bcs" "bhs" "bcc" "blo" "bmi" "bpl" "bvs" "bvc" "bhi" "bls"
                                "bge" "blt" "bgt" "ble" "bal" "bnv"
                                "b.eq" "b.ne" "b.cs" "b.hs" "b.cc" "b.lo" "b.mi" "b.pl" "b.vs" "b.vc"
                                "b.hi" "b.ls" "b.ge" "b.lt" "b.gt" "b.le" "b.al" "b.nv"
                                "b" "bfi" "bfm" "bfxil" "bic" "bics" "bl" "blr" "br" "brk"
                                "cbnz" "cbz" "ccmn" "cinc" "cinv" "clrex" "cls" "clz" "cmn" "cmp"
                                "cneg" "crc32b" "crc32h" "crc32w" "crc32x" "crc32cb" "crc32ch"
                                "crc32cw" "crc32cx"
                                "csel" "cset" "csinc" "csinv" "csneg"
                                "dc" "dcps1" "dcps2" "dcp3" "dmb" "drps" "dsb"
                                "eon" "eor" "eret" "extr"
                                "hint" "hlt" "hvc"
                                "ic" "isb"
                                "ldar" "ldarb" "ldarh" "ldaxp" "ldaxr" "ldaxrb" "ldaxrh" "ldnp"
                                "ldp" "ldpsw" "ldr" "ldrb" "ldrh" "ldrsh" "ldrsw" "ldtr" "ldtrb"
                                "ldtrh" "ldtrsb" "ldtrsh" "ldtrsw" "ldur" "ldurb" "ldurh"
                                "ldursb" "ldursh" "ldursw" "ldxp" "ldxr" "ldxrb" "ldxrh" "lsl"
                                "lslv" "lsr" "lsrv"
                                "madd" "mneg" "mov" "movk" "movn" "movz" "mrs" "msub" "mul" "mvn"
                                "negs" "ngc" "ngcs" "nop"
                                "orn" "orr"
                                "prfm" "prfum"
                                "rbit" "ret" "rev" "rev16" "rev32" "ror" "rorv"
                                "sbc" "sbcs" "sbfiz" "sbfm" "sbfx" "sdiv" "sev" "sevl" "smaddl"
                                "smc" "smnegl" "smsubl" "smulh" "smull" "stlr" "stlrb" "stlrh"
                                "stlxp" "stlxr" "stlxrb" "stlxrh" "xtnp" "stp" "str" "strb" "strh"
                                "stttr" "sttrb" "sttrh" "stur" "sturb" "sturh" "stxp" "stxr"
                                "stxrb" "stxrh" "sub" "subs" "svc" "sxtb" "sxth" "sxtw" "sys" "sysl"
                                "tbnz" "tbz" "tlbi" "tst"
                                "ubfiz" "ubfm" "ubfx" "udiv" "umaddl" "umnegl" "umsubl" "umulh"
                                "umull" "uxtb" "uxth"
                                "wfe" "wfi"
                                "yield"
                                "abs" "add" "addhn" "addhn2" "addp" "addv" "aesd" "aese" "aesimc"
                                "aesmc" "and"
                                "bic" "bif" "bit" "bsl"
                                "cls" "clz" "cmeq" "cmge" "cmgt" "cmhi" "cmhs" "cmle" "cmlt" "cmtst"
                                "cnt"
                                "dup"
                                "eor" "ext"
                                "fabd" "fabs" "facge" "facgt" "fadd" "faddp" "fccmp" "fccmpe"
                                "fcmeq" "fcmge" "fcmgt" "fcmle" "fcmlt" "fcmp" "fcmpe" "fcsel"
                                "fcvt" "fcvtas" "fcvtau" "fcvtl" "fcvtl2" "fcvtns" "fcvtnu"
                                "fcvtps" "fcvtpu" "fcvtxn" "fcvtxn2" "fcvtzs" "fcvtzu" "fdiv"
                                "fmadd" "fmax" "fmaxnm" "fmaxmp" "fmaxnmv" "fmaxp" "fmaxv" "fmin"
                                "fminnm" "fminnmp" "fminnmv" "fminp" "fminv" "fmla" "fmls" "fmov"
                                "fmsub" "fmul" "fmulx" "fneg" "fnmadd" "fnmsub" "fnmul" "frecpe"
                                "frecps" "frecpx" "frinta" "frinti" "frintm" "frintn" "frintp"
                                "frintx" "frintx" "frintz" "frsqrte" "frsqrts" "fsqrt" "fsub"
                                "ins"
                                "ld1" "ld1r" "ld2" "ld2r" "ld3" "ld3r" "ld4" "ld4r" "ldnp" "ldp" "ldr"
                                "ldur"
                                "mla" "mls" "mov" "movi" "mul" "mvn" "mvni"
                                "neg" "not"
                                "orn" "orr"
                                "pmul" "pmull" "pmull2"
                                "rbit" "rev16" "rev32" "rev64" "rshrn" "rshrn2" "rsubhn"
                                "rsubhn2"
                                "saba" "sabal" "sabal2" "sabd" "sabdl" "sabdl2" "sadalp" "saddl"
                                "saddl2" "saddlp" "saddlv" "saddw" "saddw2" "scvtf" "sha1c"
                                "sha1h" "sha1m" "sha1p" "sha1su0" "sha1su1" "sha256h2"
                                "sha256h" "sha256su0" "sha256su1" "shadd" "shl" "shll" "shll2"
                                "shrn" "shrn2" "shsub" "sli" "smax" "smaxp" "smaxv" "smin" "sminp"
                                "sminv" "smlal" "smlal2" "smlsl" "smlsl2" "smov" "smull" "smull2"
                                "sqabs" "sqadd" "sqdmlal" "sqdmlal2" "sqdmlsl" "sqdmlsl2"
                                "sqdmulh" "sqdmull" "sqdmull2" "sqneg" "sqrdmulh" "sqrshl"
                                "sqrshrn" "sqrshrn2" "sqshl" "sqshlu" "sqshrn" "sqshrn2"
                                "sqsub" "sqxtn" "sqxtn2" "sqxtun" "sqxtun2" "shradd" "sri"
                                "srshl" "srshr" "srsra" "sshl" "sshll" "sshll2" "sshhr" "ssra"
                                "ssubl" "ssubl2" "ssubw" "ssubw2" "st1" "st2" "st3" "st4" "stnp"
                                "stp" "str" "stur" "sub" "subhn" "subhn2" "suqadd" "sxtl"
                                "tbl" "tbx" "trn1" "trn2"
                                "uaba" "uabal" "uabal2" "uabd" "uabdl" "uabdl2" "uadalp" "uaddl"
                                "uaddl2" "uaddlp" "uaddlv" "uaddw" "uaddw2" "ucvtf" "uhadd"
                                "uhsub" "umax" "umaxp" "umaxv" "umin" "uminp" "uminv" "umlal"
                                "umlal2" "umlsl" "umlsl2" "umov" "umull" "umull2" "uqadd"
                                "uqrshl" "uqrshrn" "uqrshrn2" "uqshl" "uqshrn" "uqsub" "uqxtn"
                                "uqxtn2" "urecpe" "urhadd" "urshl" "urshr" "ursqrte" "ursra"
                                "ushl" "ushll" "ushll2" "ushr" "usqadd" "usra" "usubl" "usubl2"
                                "usubw" "usubw2" "uxtl" "uzp1" "uzp2"
                                "xtn" "xtn2"
                                "zip1" "zip2")
                              t)))
      (list
       '("^\\s *\\.[[:alpha:]]+" . font-lock-keyword-face) ;.data, .text .global, etc
       '("\\(?:\\b\\|\\_>\\)\\s-+\\.[[:alpha:]]+" . font-lock-type-face) ;data types
       '("^\\([\\s ]*[[:alnum:]]*\\):\\(.*\\)" 1 font-lock-function-name-face) ;labels
       `(,(concat "\\_<" instrs "\\_>") . font-lock-keyword-face)))) ;instructions
  "Lowest level of syntax highlighting: keywords and labels.")
(defconst armv8-font-lock-keywords-2
  (append (list
           '("\\_<\\(w\\|x\\|q\\|d\\|s\\)\\(?:3[0-1]\\|[1-2][0-9]\\|[0-9]\\)\\_>"
             . font-lock-variable-name-face) ;registers
           '("v\\(3[0-1]\\|[1-2][0-9]\\|[0-9]\\)\\.\\(16\\|8\\|4\\|2\\)?\\([HhBbSsDd]\\)"
             . font-lock-builtin-face) ; simd registers
           '("\\_<\\(pc\\|sp\\)\\_>" . font-lock-builtin-face) ;special registers
           '("\\_<\\([wx]zr\\)\\_>" . font-lock-constant-face)) ;zero registers
          armv8-font-lock-keywords-1)
  "Second level of syntax highlighting: keywords, labels, and registers.")
(defconst armv8-font-lock-keywords-3
  (append armv8-font-lock-keywords-2
          (list
           '("#\\(?:0x\\)?[[:xdigit:]]+\\_>" . font-lock-constant-face) ; constant number
           '("\\[\\([[:xdigit:]]+\\)\\]" . (1 font-lock-constant-face t)))) ; simd specifier
  "Third level of syntax highlighting: keywords, labels, registers, and hexidecimal numbers.")
(defvar armv8-font-lock-keywords armv8-font-lock-keywords-3
  "Default syntax highlighting: keywords, labels, registers, and hexidecimal numbers.")

;;;; syntax table
(defvar armv8-mode-syntax-table
  (let ((st (make-syntax-table)))
    (modify-syntax-entry ?: "_" st)
    (modify-syntax-entry ?= "_" st)
    (modify-syntax-entry ?. "." st)
    (modify-syntax-entry ?\' "\"" st)
    ;; comments
    (modify-syntax-entry ?/ ". 14" st)
    (modify-syntax-entry ?* ". 23" st)
    (modify-syntax-entry ?@ "< b" st)
    (modify-syntax-entry ?\n "> b" st)
    st)
  "Syntax tables for `armv8-mode'.")

(defun armv8-mode-find-indent-level ()
	"Return the absolute ammount that an line of arm assembler should be indented."
	(save-excursion
	  (beginning-of-line)
	  (if (bobp)			       ;check for rule 1
		  0					   ;indent all the way to the left
		(if (looking-at "^\\s *\\(/\\*\\|@\\)") ;check for rule 5
			(save-excursion		;indentation of the next line
			  (forward-line 1)
			  (if (not (looking-at "^$")) ;if  not empty line
				  (current-indentation) ;then keep indentation the same as last 
				(progn
				  (forward-line -2)
				  (current-indentation))))	;then keep it the same as last line)
		  (if (looking-at "^.*:")			;check for rule 4
			  (current-indentation)			;don't mess with it
			(let ((not-indented t)
				  (new-indent 0))		;all for rule 2
			  (save-excursion
				(while not-indented
				  (when (bobp)
					(setq not-indented nil))
				  (forward-line -1)
				  (if (looking-at "^.*:") ;check for rule 2
					  (progn
						(setq not-indented nil)
						(setq new-indent (+ (current-indentation) armv8-tab-width)))
					(when (or (looking-at "^.*:\\s-*\\.") ;data label
							  (looking-at "^.[^\\n]")) ;check for rule 3
					  (progn
						(setq not-indented nil) ;exit loop
						(setq new-indent (current-indentation))))))) ;don't mess with it
				new-indent))))))		;indent to the right

(defun armv8-indent-line ()
  "Indent current line of ARM code as follows.
Indentation Rules:
1: If we are at the beginning of the buffer, indent to column 0.
2: If the previous line is a non-data label, indent to the right.
3: else indent the same as previous line of code.
4: if line contains a colon (label), insert a tab character
5: (secret) if the line is a comment allign it to the left"
  (interactive)
  (let ((new-indent (armv8-mode-find-indent-level)))
	(if (< new-indent 0)
		(setq new-indent 0))
	(indent-line-to new-indent)))

(defun armv8-insert-comment ()
  "Insert /*   */ if on an empty line.
Then call `comment-dwim'."
  (interactive)
  (let ((special (and (save-excursion
                        (move-beginning-of-line nil)
                        (looking-at "^\\s-*$"))
                      (not (use-region-p))))) ;empty line
    (when special
	  (insert "/*   */"))
    (comment-dwim nil)
    (when special
      (forward-char))))					;move to middle of /*   */

;; entry function
(define-derived-mode armv8-mode prog-mode "ARM Assembler"()
  "Major mode for editing Advanced RISC Machine language files."
  (set (make-local-variable 'font-lock-defaults) '(armv8-font-lock-keywords nil t))
  (set (make-local-variable 'indent-line-function) #'armv8-indent-line)
  ;; comments
  (setq-local comment-start (concat armv8-comment-char " "))
  (setq-local tab-always-indent nil)
  (setq-local comment-end ""))

(provide 'armv8-mode)
