# Laboratorio 3: Taller Minería de datos avanzada

## Integrantes
- Ignacio Ibáñez Aliaga
- Joaquín Villagra Pacheco

### Herramienta a utilizar R

- Máxima Entropia en R
- Acceso a Tutorial básico de R: http://faculty.lagcc.cuny.edu/tnagano/research/R/

## Descripción de la experiencia
### Objetivos:

- Comprender y presentar el problema de clasificación de texto (categorización)
- Realizar pre-procesamiento de texto para problemas de clasificación.
- Selección de muestra para entrenamiento y test
- Realizar proceso de calibración de parámetros del algoritmo de máxima entropía.
- Comprender de forma práctica el funcionamiento del método de máxima entropía mediante la configuración de sus parámetros
- Evaluar el rendimiento del algoritmo mediante sus índices “precisión”, “recall” y “F1”, definiendo un subconjunto de categorías “relevantes” para dicho propósito.

## Características del DataSet
El conjunto de datos es obtenido del package de R Maxent, el cual es un repositorio de regresión logística multinomial de baja memoria con soporte para clasificación de texto.  En particular los datos obtenidos de Maxent son correspondientes a noticias o articulos del New York Times. 

### Variables
- 5 Variables
	- "Article_ID": ID del articulo unico utilizado por New York Times.
	- "Date": Fecha de aparición del articulo en el New York Times.
	- "Title": Titulo con el cual se visualizó el articulo en el New York Times.
	- "Subject": Tema clasificado manualmente a partir del titulo.
	- "Topic.Code": Un código de tema etiquetado manualmente que corresponde con el "Subject". 
- 3104 instancias 
- No existen datos faltantes.
