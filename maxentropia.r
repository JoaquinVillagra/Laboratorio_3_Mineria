#Laboratorio 3 Miner??a de Datos Avanzada
#Ignacio Ibanez Aliaga
#Joaquin Villagra Pacheco

#Importando datos
require(maxent)
data <- read.csv(system.file("data/NYTimes.csv.gz",package="maxent"))

corpus <- Corpus(VectorSource(data$Title[1:300]))
#se obtiene una estructura con metadatos obtenidos de los t??tulos de los 300 documentos del NY y sus frecuencias de aparici??n en el documento.