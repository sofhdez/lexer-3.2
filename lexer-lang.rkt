#lang slideshow
; main
; Faltan
;     - Flotantes (reales)
;     - Regla de incio de las variables

(require parser-tools/lex)

(require parser-tools/lex-sre)

(require (prefix-in : parser-tools/lex-sre))

(define calc-lexer
  (lexer
   [(:+ (:or (char-range #\a #\z) (char-range #\A #\Z)))

    ; ========> Variable

    (cons `(Variable ,(string->symbol lexeme))
          (calc-lexer input-port))]

   ; ========> Comentarios
   [(:: "//" (complement (:: any-string "//" any-string)))  ; falta que reconozca lo que sigue ed //

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

;; archivo muchas líneas
(calc-lexer (open-input-file "micodigo.txt"))
