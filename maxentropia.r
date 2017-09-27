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
corpus_p <- Corpus(VectorSource(data$Title[1:1500]))

##############  Datos sin preprocesamiento
corpus[[1]]$content
for (i in 1:10) print (corpus[[i]]$content) 

dtm1 <- DocumentTermMatrix(corpus) 
dtm1.data <- as.matrix(dtm1)

matrix1 <- DocumentTermMatrix(corpus_p)
sparse1 <- as.compressed.matrix(matrix1)
f1 <- tune.maxent(sparse[1:1500,],data$Topic.Code[1:1500],nfold=3,showall=TRUE, verbose=TRUE)
print(f1)
model1  <- maxent(sparse1[1:1500,],data$Topic.Code[1:1500], l1_regularizer=0.2, l2_regularizer=0.0, use_sgd=FALSE, set_heldout=0, verbose=TRUE)
results <- predict(model1,sparse1[100:120,])

confusion_matrix <- confusionMatrixFor_Neg1_0_1(model1)
statsFromConfusionMatrix(confusion_matrix)
