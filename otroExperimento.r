#Laboratorio 3 Mineria de Datos Avanzada
#Ignacio Ibanez Aliaga
#Joaquin Villagra Pacheco

#Importando paquetes y datos
library("tm")
library("SnowballC")
library("wordcloud")
require(maxent)
data <- read.csv(system.file("data/NYTimes.csv.gz",package="maxent"))

#se obtiene una estructura con metadatos obtenidos de los titulos de los 3104 documentos del NY y sus frecuencias de aparici??n en el documento.
corpus <- Corpus(VectorSource(data$Title[1:3104]))

# lleva a minúsculas
d  <- tm_map(corpus, tolower)

# quita espacios en blanco
d  <- tm_map(d, stripWhitespace)

# remueve la puntuación
d <- tm_map(d, removePunctuation)

# remueve palabras vacías genericas
d <- tm_map(d, removeWords, stopwords("english"))

# carga mi archivo de palabras vacías personalizada y lo convierte a ASCII
sw <- readLines("/Volumes/HDD/Google Drive/Ingeniria civil Informatica - Uiversidad de Santiago de Chile/10mo Semestre/Minería de datos Avanzada/Laboratorios/Laboratorio_3_Mineria/list_stopwords_english.txt",encoding="UTF-8")
sw = iconv(sw, to="ASCII//TRANSLIT")

# crea matriz de terminos
tdm <- TermDocumentMatrix(d)

#muestro palabras (Solo aquellas con frecuencia>=20)
findFreqTerms(tdm, lowfreq=20)

#quito palabras que estimo no necesarias
#d <- tm_map(d, removeWords, c("day", "new", "will", "years", ))

m <- as.matrix(tdm)

v <- sort(rowSums(m),decreasing=TRUE)

df <- data.frame(word = names(v),freq=v)

wordcloud(df$word,df$freq,min.freq=6,colors=brewer.pal(8, "Dark2"))

tdm <- TermDocumentMatrix(d)