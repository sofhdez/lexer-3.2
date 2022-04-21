#lang slideshow

; TODO
;     - Falta que imprima el símbolo de los parentesís

(require "generadorArchivo.rkt"
         racket/generator
         parser-tools/lex
         parser-tools/lex-sre
         (prefix-in : parser-tools/lex-sre))

; -------------- Función que crea el output.txt --------------
(define (generate file lst)
  (if(not(null? lst))
     (begin
       (display (car lst) file)
       (newline file)
       (generate file (cdr lst)))
     (begin
       (list)))
  (close-output-port file))

; -------------------------- Lexer --------------------------
(define lexerAritmetico
  (lexer
   ;[(:+ (:or (char-range #\a #\z) (char-range #\A #\Z)))
   [(::(:+ (char-range #\a #\z)) (:+ (:or (char-range #\a #\z) (char-range #\A #\Z) (char-range #\0 #\9) "_")))

    ; ========> Variable

    (cons `(Variable ,(string->symbol lexeme))
          (lexerAritmetico input-port))]

   ; ========> Comentarios
   [(:: "//" (complement (:: any-string "//" any-string)))  ; falta que reconozca lo que sigue ed //

    (cons `(Comentario ,(string->symbol lexeme))
          (lexerAritmetico input-port))]

   ;; ========> Símbolos especiales
   [#\(
    ; => Paréntesis que abre
    (cons '(Paréntesis que abre)
          (lexerAritmetico input-port))]

   [#\)
    ; => Paréntesis que cierra
    (cons '(Paréntesis que cierra)
          (lexerAritmetico input-port))]

   ;; ========> Números
   [(:: (:? #\-) (:+ (char-range #\0 #\9)))
    ; => Enteros
    (cons `(Entero ,(string->number lexeme))
          (lexerAritmetico input-port))]

   [(:or
     ; Pointfloat
     (:or (:: (:?
               ; Intpart
               (:: (:? #\-) (:+ (char-range #\0 #\9)))
               )
              ; Fraction
              (:: "." (:+ (char-range #\0 #\9)))
              )
          (::
           ; Intpart
           (:: (:? #\-) (:+ (char-range #\0 #\9)))
           ".")
          )
     ; Exponentfloat
     (:: (:or
          ; Intpart
          (:: (:? #\-) (:+ (char-range #\0 #\9)))
          ; Pointfloat
          (:or (:: (:? (:: (:? #\-) (:+ (char-range #\0 #\9))))
                   (:: "." (:: (:? #\-) (:+ (char-range #\0 #\9)))))
               (:: (:: (:? #\-) (:+ (char-range #\0 #\9))) ".")))
         ; Exponent
         (:: (:or "e" "E")
             (:? (:or "+" "-"))
             (:+ (char-range #\0 #\9)))))
    ; => Flotantes (reales)
    (cons `(Real ,(string->number lexeme))
          (lexerAritmetico input-port))]

   ;; ========> Operadores
   [#\=
    ; => Asignación
    (cons `(Asignación ,(string->symbol lexeme))
          (lexerAritmetico input-port))]

   [#\+
    ; => Suma
    (cons `(Suma ,(string->symbol lexeme))
          (lexerAritmetico input-port))]

   [#\-
    ; => Resta
    (cons `(Resta ,(string->symbol lexeme))
          (lexerAritmetico input-port))]

   [#\*
    ; => Multiplicación
    (cons `(Multiplicación ,(string->symbol lexeme))
          (lexerAritmetico input-port))]

   [#\/
    ; => División
    (cons `(División ,(string->symbol lexeme))
          (lexerAritmetico input-port))]

   [#\^
    ; => Potencia
    (cons `(Potencia ,(string->symbol lexeme))
          (lexerAritmetico input-port))]

   [whitespace
    ; =>
    (lexerAritmetico input-port)]

   [(eof)
    '()]
   ))

(define fileIn "micodigo.txt")
(define fileOut (nameFileOut fileIn))

; Creamos el archivo de salida
(define output (open-output-file fileOut))

; Llamamos al lexer
(lexerAritmetico (open-input-file fileIn))

; Generamos el archivo
(generate output (lexerAritmetico (open-input-file fileIn)))
