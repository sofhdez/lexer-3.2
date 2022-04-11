#lang slideshow
; main

(require parser-tools/lex)

(require parser-tools/lex-sre)

(require (prefix-in : parser-tools/lex-sre))

(define calc-lexer
  (lexer
   [(:+ (:or (char-range #\a #\z) (char-range #\A #\Z)))
    ; (:: "/*" (:* (complement "*/")) "*/")
    ; Matches any string that starts with "/*" and ends with "*/", including "/* */ */ */".
    ; (complement "*/") matches any string except "*/". This includes "*" and "/" separately.
    ; Thus (:* (complement "*/")) matches "*/" by first matching "*" and then matching "/".
    ; Any other string is matched directly by (complement "*/").
    ; In other words, (:* (complement "xx")) = any-string.
    ; It is usually not correct to place a :* around a complement.

    ; ========> Variable

    (cons `(Variable ,(string->symbol lexeme))
          (calc-lexer input-port))]

   ; ========> Comentarios
   [(:: "//" (:* (complement (:: any-string))))  ; falta que reconozca lo que sigue ed //

    (cons `(Comentario ,(string->symbol lexeme))
          (calc-lexer input-port))]

   ;; ========> Símbolos especiales
   [#\(
    ; => Paréntesis que abre
    (cons '(Paréntesis que abre)
          (calc-lexer input-port))]

   [#\)
    ; => Paréntesis que cierra
    (cons '(Paréntesis que cierra)
          (calc-lexer input-port))]

   [(:: (:? #\-) (:+ (char-range #\0 #\9)))
    ; => Enteros
    (cons `(INT ,(string->number lexeme))
          (calc-lexer input-port))]

   ;; ========> Operadores
   [#\=
    ; => Asignación
    (cons `(Asignación ,(string->symbol lexeme))
          (calc-lexer input-port))]

   [#\+
    ; => Suma
    (cons `(Suma ,(string->symbol lexeme))
          (calc-lexer input-port))]

   [#\-
    ; => Resta
    (cons `(Resta ,(string->symbol lexeme))
          (calc-lexer input-port))]

   [#\*
    ; => Multiplicación
    (cons `(Multiplicación ,(string->symbol lexeme))
          (calc-lexer input-port))]

   [#\/
    ; => División
    (cons `(División ,(string->symbol lexeme))
          (calc-lexer input-port))]

   [#\^
    ; => Potencia
    (cons `(Potencia ,(string->symbol lexeme))
          (calc-lexer input-port))]

   [whitespace
    ; =>
    (calc-lexer input-port)]

   [(eof)
    '()]
   ))

  (calc-lexer (open-input-string "-3 * (foo + 12) //hola"))