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

##############  Datos con preprocesamiento
corpus_p <- tm_map(corpus_p, stripWhitespace)
corpus_p <- tm_map(corpus_p, content_transformer(tolower))
corpus_p <- tm_map(corpus, content_transformer(removeNumbers))
corpus_p <- tm_map(corpus_p, content_transformer(removePunctuation))
corpus_p <- tm_map(corpus_p, content_transformer(removeWords), stopwords("english"))
corpus_p <- tm_map(corpus_p, stemDocument, language="english")
for (i in 1:10) print (corpus_p[[i]]$content) 

dtm <- DocumentTermMatrix(corpus_p) 
dtm.data <- as.matrix(dtm)

matrix <- DocumentTermMatrix(corpus_p)
sparse <- as.compressed.matrix(matrix)
f <- tune.maxent(sparse[1:1500,],data$Topic.Code[1:1500],nfold=3,showall=TRUE, verbose=TRUE)
print(f)
model<-maxent(sparse[1:1500,],data$Topic.Code[1:1500], l1_regularizer=0.2, l2_regularizer=0.0, use_sgd=FALSE, set_heldout=0, verbose=TRUE)
results <- predict(model,sparse[101:120,]) 
confusionMatrixFor_Neg1_0_1(results)
