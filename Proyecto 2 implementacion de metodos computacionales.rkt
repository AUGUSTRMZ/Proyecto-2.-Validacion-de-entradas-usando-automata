#lang racket
;===========================================================================================================
; Funcion next-state
; Se encarga de buscar la transicion que le corresponde
; al estado actual y su simbolo

; Recibe
; State: estado actual
; Symbol: Simbolo que esta leyendo
; Transitions: la lista que contiene las transiciones del automata

(define next-state
  (lambda (state symbol transitions)
    (cond
      ; si ya no hay transiciones o la
      ; lista esta vacia entonces significa
      ; que ya no existe una transicion valida
      ((null? transitions) #f)

      ; comparamos si el estao actual = estado de salida
      ((and (equal? state(car(car transitions))) ; estado de salida
            ; comparamos si simbolo actual = simbolo de la transicion
            (equal? symbol (cadr (car transitions)))) ; simbolo
       ; si coincide, vamos a regresar el estado destino
       (caddr (car transitions)))
      ;si la transicion no coincide
      ; se debe seguir buscando en el resto de la lista
      ; y si nunca coincide eventualmente caera en el caso base 
      (else
       (next-state state symbol (cdr transitions))))))
;=================================================================================================
; Funcion valid-string
; Funcion auxiliar de validate-string
; Valida una cadena
; Recibe:
; string: cadena a revisar
; alphabet: el alfabeto que se permite en el automata
; transitions: la lista de transiciones que se uso en la funcion anterior
; state: el estado actual
; finals: lista de los estados finales

(define valid-string
  (lambda (string alphabet transitions state finals)
    (cond
      ; si la cadena esta vacia, ya se termino revisar
      ; todos los simbolos

      ((null? string)
       (cond
         ((member state finals) #t) ; si el estado actual esta dentro de finals #t
         (else #f))) ; si no pues #fsota
      ; si el primer simobolo de la cadena no esta en el alfabeto
      ((not (member (car string) alphabet)) #f) ;fsota
      ;si todavia quedan simbolos que revisar y si pertenecen al alfabeto
      (else
      ; entonces buscamos a que estado hay que moverse
      (let ((new-state (next-state state (car string) transitions))) ; en new-state guardamos el resultado de buscar la transicion
        (cond
          ; si el new-state termina siendo #f, entonces la transicion no existe
          ((equal? new-state #f) #f) ; entonces rechazamos la cadena (fsota)
          ; si la transicion si existe, hay que seguir validando
          (else
           ; quitamos el primer simbolo con cdr, cambiamos ahora al nuevo estado
           ; con esto represento que ya leyo el simbolo y que va a avanzar a otro estado
           (valid-string (cdr string)
                         alphabet
                         transitions
                         new-state
                         finals))))))))
;=========================================================================================================================================
; Funcion validate-strings
; Con esta funcion se validan todas las cadenas
; llamando a valid-string para cada una de ellas
; y retorna una lista que contiene si se acepta o no la cadena
; Recibe:
; strings: lista con una lista de cadenas ((a b c) (a a b) (b b a))
; alphabet: el alfabeto que se permite en el automata
; transitions: la lista de transiciones que se uso en la funcion anterior
; initial: el estado inicial
; finals: lista de los estados finales

(define validate-strings
  (lambda (strings alphabet transitions initial finals)
    (cond
      ;si ya no hay cadenas por revisar
      ((null? strings) '()) ; regresar una lista vacia
      ; validar la primer cadena y despues el resto y construimos una lista de resultados
      (else
       (cons
        ;primer cadena
        (valid-string (car strings)
                      alphabet
                      transitions
                      initial
                      finals)
        ;resto de la cadena
        (validate-strings (cdr strings)
                          alphabet
                          transitions
                          initial
                          finals))))))
;===========================================================================================================================================
; Funcion validate
; Recibe:
; automaton: todo el automata completo
; strings: la lista de cadenas
;                               1       2       3           4       5
; para esto uso el formato (estados alfabeto transiciones inicial finales)
; y para que funcione los separo por partes para poder usarlos

(define validate
  (lambda (automaton strings)
    ; aqui es donde desmenuzo el automata como si fuera pollito
    (let ((states (car automaton)) ; estados
          (alphabet (cadr automaton)) ; alfabeto
          (transitions (caddr automaton)) ; transiciones
          (initial (cadddr automaton)) ; estado inicial
          (finals (car (cddddr automaton)))) ; estados finales 

    
          ; esto lo hacemos porque todo esto se usa para poder validar las cadenas
          ; con esto ya podemos mandar llamar a validate-strings para que se encargue
          ; de validar las cadenas entrantes
          (validate-strings strings
                            alphabet
                            transitions
                            initial
                            finals))))
;=============================================================================================================================================
; Definicion de pruebas para testear el programa
; Ejemplo de un automata

(define automaton-example
  '((0 1 2 3 4); estados
    (a b) ; alfabeto
    ((0 a 1) ; lista transitions
    (0 b 2)
    (1 a 1)
    (1 b 3)
    (2 b 2)
    (2 a 1)
    (3 a 1)
    (3 b 4) ; estado de aceptacion
    (4 a 1)
    (4 b 2))
  0 ; estado inicial
  (4))) ; estado final
;==============================================================================================================================================
; Cadenas de prueba
(define strings-example
  '((a b a b a a b b) ; cadena valida porque para poder ser aceptada debe llegar a 4 
    (a a a a a a a b) ; cadena no validas 
    (a b))) ; cadena no validas
; en teoria esta prueba deberia darme # t f f
    

