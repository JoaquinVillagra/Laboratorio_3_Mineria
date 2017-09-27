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
Summary(data[,5])

##############  Datos con preprocesamiento
corpus_p <- tm_map(corpus_p, stripWhitespace)
corpus_p <- tm_map(corpus_p, content_transformer(tolower))
corpus_p <- tm_map(corpus_p, content_transformer(removeNumbers))
corpus_p <- tm_map(corpus_p, content_transformer(removePunctuation))
corpus_p <- tm_map(corpus_p, content_transformer(removeWords), stopwords("english"))
corpus_p <- tm_map(corpus_p, stemDocument, language="english")

# carga mi archivo de palabras vacías personalizada y lo convierte a ASCII
sw <- readLines("/Volumes/HDD/Google Drive/Ingeniria civil Informatica - Uiversidad de Santiago de Chile/10mo Semestre/Minería de datos Avanzada/Laboratorios/Laboratorio_3_Mineria/list_stopwords_english.txt",encoding="UTF-8")
sw = iconv(sw, to="ASCII//TRANSLIT")

#for (i in 1:10) print (corpus_p[[i]]$content) 

dtm <- DocumentTermMatrix(corpus_p) 
dtm.data <- as.matrix(dtm)

matrix <- DocumentTermMatrix(corpus_p)
sparse <- as.compressed.matrix(matrix)
f <- tune.maxent(sparse[1:2100,],data$Topic.Code[1:2100],nfold=3,showall=TRUE, verbose=TRUE)
print(f)
# accuracy            pct_best_fit
# 0.5103830           1.0000000
# l1_regularizer=0.0, l2_regularizer=0.4

model<-maxent(sparse[1:2100,],data$Topic.Code[1:2100], l1_regularizer=0.0, l2_regularizer=0.8, use_sgd=FALSE, set_heldout=0, verbose=TRUE)
results <- predict(model,sparse[2200:2220,]) 