# Proyecto-2.-Validacion-de-entradas-usando-automata

# Automaton String Validator (Racket)

## Descripción

Este proyecto implementa una función en Racket que permite validar si una o varias cadenas son aceptadas por un **autómata finito determinista (DFA)**.

La validación se realiza simulando el comportamiento del autómata: se procesa cada símbolo de la cadena y se determina si el estado final alcanzado pertenece al conjunto de estados de aceptación.

---

## Funcionamiento

El algoritmo sigue el flujo clásico de un DFA:

1. Inicia en el **estado inicial**.
2. Lee la cadena símbolo por símbolo.
3. Para cada símbolo:
   - Busca una transición válida.
   - Cambia al siguiente estado.
4. Al finalizar:
   - Si el estado actual es final → `#t`
   - Si no → `#f`

---

## Entrada

### Autómata

El autómata se representa como una lista profunda:

```racket
(estados alfabeto transiciones estado-inicial estados-finales)
```
### Ejemplo:
```racket
'((0 1 2 3 4)
  (a b)
  ((0 a 1) (0 b 2) (1 a 1) (1 b 3) ...)
  0
  (4))
```
### Cadenas:
Listas de cadenas para validar

``` racket
'((a b b) (a b) (a a b))
```
### Salida
El programa devuelve una lista de valores booleanos
```racket
'(#t #f #f)
```
### Valor

`#t` - cadena aceptada
`#f` - cadena rechazada


## Estructura del proyecto

### Funcion

`next-state` - Busca la transicion correspondiente a un estado y simbolo
`valid-string` - valida una cadena de texto
`validate-strings` - valida multiples cadenas de texto usando valid-string como funcion auxiliar
`validate` - funcion principal


## Complejidad
Sea:
* `m` = numero de cadenas
* `n` = longitud promedio de cada cadena
* `t` = numero de transiciones

La complejidad del algoritmo es entonces:
`O(m * n * t)`



