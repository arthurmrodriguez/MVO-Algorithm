# MVO-Algorithm
Estudio sobre una metaheurística llamada Multi-verse Optimizer, donde se estudia su rendimiento frente a algoritmos de Differential Evolution así como posibles diseños de hibridación con Local Search y propuestas de mejora de la metaheurística. Este trabajo se ha realizado de forma voluntaria en la asignatura de Metaheursticas del Grado en Ingeniería Informática de la UGR, guiado por el profesor Francisco Herrera Triguero.

## Parte 1 - Estudio de la metaheurística en bruto y comparación con DE

La primera parte constará del **análisis en bruto de la metaheurística**, la explicación del algoritmo básico y en base a qué fenónemo o comportamiento esta inspirado, realizando finalmente una comparación con distintos modelos de **Differential Evolution** proporcionados en distintos ficheros, todo esto en términos de un conjunto de funciones benchmark propuestas por el profesor.

## Parte 2 - Mejora del algoritmo: Hibridación en Algoritmo Memético a través de una LS

La segunda parte de este estudio consiste en una primera mejora de la metaheurística a través del **diseño de un algoritmo memético**, utilizando una Local Search estándar y buscando el mejor equilibrio posible entre los **procesos de exploración y explotació**n, midiendo además el número de evaluaciones que comprende cada uno de estos dos procesos. Para esta parte se ha utilizado el algoritmo **Covariance Matrix Adaptation Evolution Strategy (CMA-ES)**.

## Parte 3 - Propuestas de mejora del algoritmo

Para la tercera y última parte del estudio se buscaba proponer distintas mejoras potenciales de la metaheurística, ya sea a través de **parámetros adaptativos, componentes, balance optimo entre exploración y explotación**, etc. Estas potenciales mejoras están destinadas a comprobar la flexibilidad y adaptabilidad del algoritmo en haras de obtener mejores resultados en cuanto a las funciones benchmark en caso de que éstas potenciales mejoras lo permitan.

El estudio completo de esta metaheurística se concreta en detalle en la **Memoria de trabajo** que se proporciona en este repositorio. 

Publicació original: S. Mirjalili, S. M. Mirjalili, A. Hatamlou, " Multi-Verse Optimizer: a nature-inspired algorithm for global optimization " , Neural Computing and Applications, in press, 2015, DOI: http://dx.doi.org/10.1007/s00521-015-1870-7
