#lang slideshow

; -------------- Función que crea el output.txt --------------

(define (nameFileOut fileIn)
  (define endStr (- (string-length fileIn) 4))

  (string-append
   (substring fileIn 0 endStr)
   "-output.txt")
)

(provide (all-defined-out))