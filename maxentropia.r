#Laboratorio 3 Mineria de Datos Avanzada
#Ignacio Ibanez Aliaga
#Joaquin Villagra Pacheco

#Importando paquetes y datos
library("tm")
library("heuristica")
library("SnowballC")
library("wordcloud")
require(maxent)
data <- read.csv(system.file("data/NYTimes.csv.gz",package="maxent"))

#se obtiene una estructura con metadatos obtenidos de los titulos de los 3104 documentos del NY y sus frecuencias de aparici??n en el documento.
corpus_p <- Corpus(VectorSource(data$Title[1:3104]))

##############  Datos sin preprocesamiento
corpus_p[[1]]$content
#for (i in 1:10) print (corpus_p[[i]]$content) 

matrix1 <- DocumentTermMatrix(corpus_p)
sparse1 <- as.compressed.matrix(matrix1)
f1 <- tune.maxent(sparse1[1:2100,],data$Topic.Code[1:2100],nfold=3,showall=TRUE, verbose=TRUE)
print(f1)

model1  <- maxent(sparse1[1:2100,],data$Topic.Code[1:2100], l1_regularizer=0.0, l2_regularizer=0.2, use_sgd=FALSE, set_heldout=0, verbose=TRUE)
results <- predict(model1,sparse1[2200:2220,])
