; Actividad 3.2 Programando parte de un Lenguaje de Programación
; Sofía Margarita Hernández Muñoz A01655084
; Emiliano Saucedo Arriola A01659258
; Alfonso Pineda Castillo A01660394
; Gael Eduardo Pérez Gómez A01753336

#lang slideshow

; -------------- Función que crea el output.txt --------------

(define (nameFileOut input)
  (define endStr (- (string-length input) 4))

  (string-append
   (substring input 0 endStr)
   "-output.txt")
)

(provide (all-defined-out))