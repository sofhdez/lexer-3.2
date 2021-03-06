# Manual de Usuario
“lexer-lang.rkt” es un programa desarrollado en Racket, el cual nos permite ingresar un documento de texto que contenga expresiones aritméticas y comentarios; y nos devuelve otro documento de texto con una tabla con cada uno de sus tokens encontrados, en el orden en que fueron encontrados e indicando de qué tipo son.
Todos los archivos necesarios para hacer funcionar dicho programa se pueden descargar haciendo fork del siguiente [repositorio de Github](https://github.com/sofhdez/lexer-3.2.git).

Dicho repositorio contiene 2 archivos de Racket, **“lexer-lang.rkt”** y **“generadorArchivo.rkt”**, por último, para su óptimo funcionamiento, en la misma carpeta, se debe almacenar el documento de entrada deseado. 
Para establecer el documento a ingresar, es necesario **modificar la línea 134 del archivo “lexer-lang.rkt”**, en este caso se sustituiría el archivo “micodigo.txt” por el nombre del archivo deseado.

![line of code](https://github.com/sofhdez/lexer-3.2/blob/sofi/img/fileIn.png)

<samp>Nota: para reconocer los comentarios se debe de hacer un salto de línea al terminar el comentario.</samp>

Una vez realizado lo anterior, el usuario debe correr el programa en el editor de código de su preferencia, en caso de usar DrRacket, debe presionar la flecha verde ubicada en la parte superior derecha de la ventana. Esto le generará al usuario un archivo de salida, nombrado con el nombre del archivo de entrada más un “-output.txt”. Es decir, usando el ejemplo anterior, el nombre del archivo de salida sería “micodigo-output.txt”. Dicho archivo es el que contiene la tabla con cada uno de sus tokens encontrados, mencionada anteriormente.

![output file](https://github.com/sofhdez/lexer-3.2/blob/sofi/img/output.png)
# Anexo 1: Gramática Independiente del Contexto (GIC)
S → int | lambda

S → var

S → S Op S

S → (S)

S → var Asig S


Op → +

Op → -

Op → *

Op → /


Asig → =


var → <char><int><underscore> | <char><underscore><int>

int → 0 - 9

char → a | b | c | … | x | y | z | A | B | C | ... | X | Y | Z 

float → <int> < . > <int | int exp [UnaryOp] int>

underscore → _

exp → E | e

UnaryOp → - | lambda
