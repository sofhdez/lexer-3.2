#lang slideshow
; ejemplo de un lexer https://matt.might.net/articles/lexers-in-racket/

(require parser-tools/lex)

(require parser-tools/lex-sre)

(require (prefix-in : parser-tools/lex-sre))

(define calc+-lexer
  (lexer
   [(:+ (:or (char-range #\a #\z) (char-range #\A #\Z)))
    ; =>
    (cons `(ID ,(string->symbol lexeme))
          (calc+-lexer input-port))]

   [#\(
    ; =>
    (cons '(LPAR)
          (calc+-lexer input-port))]

   [#\)
    ; =>
    (cons '(RPAR)
          (calc+-lexer input-port))]

   [(:: (:? #\-) (:+ (char-range #\0 #\9)))
    ; =>
    (cons `(INT ,(string->number lexeme))
          (calc+-lexer input-port))]

   [(:or #\+ #\*)
    ; =>
    (cons `(OP ,(string->symbol lexeme))
          (calc+-lexer input-port))]

   [whitespace
    ; =>
    (calc+-lexer input-port)]

   [(eof)
    '()]))


(calc+-lexer (open-input-string "5+9"))