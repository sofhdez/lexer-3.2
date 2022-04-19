#lang slideshow
; main
; Faltan
;     - Flotantes (reales)
;     - Regla de incio de las variables

(require parser-tools/lex)

(require parser-tools/lex-sre)

(require (prefix-in : parser-tools/lex-sre))

(define lang-lexer
  (lexer
   [(:+ (:or (char-range #\a #\z) (char-range #\A #\Z)))

    ; ========> Variable

    (cons `(Variable ,(string->symbol lexeme))
          (lang-lexer input-port))]

   ; ========> Comentarios
   [(:: "//" (complement (:: any-string "//" any-string)))  ; falta que reconozca lo que sigue ed //

    (cons `(Comentario ,(string->symbol lexeme))
          (lang-lexer input-port))]

   ;; ========> Símbolos especiales
   [#\(
    ; => Paréntesis que abre
    (cons '(Paréntesis que abre)
          (lang-lexer input-port))]

   [#\)
    ; => Paréntesis que cierra
    (cons '(Paréntesis que cierra)
          (lang-lexer input-port))]

   ;; ========> Números
   [(:: (:? #\-) (:+ (char-range #\0 #\9)))
    ; => Enteros
    (cons `(Entero ,(string->number lexeme))
          (lang-lexer input-port))]

   ;; ------------------haciendo------------------
   [(:: (:? #\-) (:+ (char-range #\0 #\9)))
    ; => Flotantes (reales)
    (cons `(Real ,(string->number lexeme))
          (lang-lexer input-port))]

   ;; ========> Operadores
   [#\=
    ; => Asignación
    (cons `(Asignación ,(string->symbol lexeme))
          (lang-lexer input-port))]

   [#\+
    ; => Suma
    (cons `(Suma ,(string->symbol lexeme))
          (lang-lexer input-port))]

   [#\-
    ; => Resta
    (cons `(Resta ,(string->symbol lexeme))
          (lang-lexer input-port))]

   [#\*
    ; => Multiplicación
    (cons `(Multiplicación ,(string->symbol lexeme))
          (lang-lexer input-port))]

   [#\/
    ; => División
    (cons `(División ,(string->symbol lexeme))
          (lang-lexer input-port))]

   [#\^
    ; => Potencia
    (cons `(Potencia ,(string->symbol lexeme))
          (lang-lexer input-port))]

   [whitespace
    ; =>
    (lang-lexer input-port)]

   [(eof)
    '()]
   ))

;; archivo muchas líneas
(lang-lexer (open-input-file "micodigo.txt"))
