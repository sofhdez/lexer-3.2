#lang slideshow
; main
; Faltan
;     - Flotantes (reales) solo los negativos
;     - Regla de incio de las variables

(require racket/generator)
(require parser-tools/lex)

(require parser-tools/lex-sre)

(require (prefix-in : parser-tools/lex-sre))

; Función que crea el output.txt
(define file (open-output-file "output.txt"))
(define (generate file lst)
  (if(not(null? lst))
     (begin
       (display (car lst) file)
       (newline file)
       (generate file (cdr lst)))
     (begin
       (list)))
  (close-output-port file))

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

   [
    (:or (:or (:: (:? (:+ (char-range #\0 #\9))) 
    (:: "." (:+ (char-range #\0 #\9)))) 
    (:: (:+ (char-range #\0 #\9)) ".")) 
    (:: (:or (:+ (char-range #\0 #\9)) 
    (:or (:: (:? (:+ (char-range #\0 #\9))) 
    (:: "." (:+ (char-range #\0 #\9)))) 
    (:: (:+ (char-range #\0 #\9)) "."))) 
    (:: (:or "e" "E") 
    (:? (:or "+" "-")) 
    (:+ (char-range #\0 #\9)))))
    ;     (floatnumber (:or pointfloat exponentfloat))
    ;     (pointfloat (:or (:: (:? intpart) fraction) (:: intpart ".")))
    ;     (exponentfloat (:: (:or intpart pointfloat) exponent))
    ;     (intpart (:+ (char-range #\0 #\9)))
    ;     (fraction (:: "." (:+ (char-range #\0 #\9))))
    ;     (exponent (:: (:or "e" "E") (:? (:or "+" "-")) (:+ (char-range #\0 #\9))))
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

(generate file (lang-lexer (open-input-file "micodigo.txt")))
