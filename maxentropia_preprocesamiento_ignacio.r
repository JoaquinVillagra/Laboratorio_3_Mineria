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
corpus_p <- tm_map(corpus_p, content_transformer(removeWords), ("english"))
corpus_p <- tm_map(corpus_p, stemDocument, language="english")

# carga mi archivo de palabras vacías personalizada y lo convierte a ASCII
sw <- readLines("list_stopwords_english.txt",encoding="UTF-8")
sw = iconv(sw, to="ASCII//TRANSLIT")

#for (i in 1:10) print (corpus_p[[i]]$content) 

dtm <- DocumentTermMatrix(corpus_p) 
dtm.data <- as.matrix(dtm)

matrix <- DocumentTermMatrix(corpus_p)
sparse <- as.compressed.matrix(matrix)
f <- tune.maxent(sparse[1:1552,],data$Topic.Code[1:1552],nfold=3,showall=TRUE, verbose=TRUE)
print(f)
# accuracy            pct_best_fit
# 0.4851456           1.0000000
# l1_regularizer=0.0, l2_regularizer=0.0
f <- tune.maxent(sparse[1:1552,],data$Topic.Code[1:1552],nfold=4,showall=TRUE, verbose=TRUE)
print(f)
# accuracy            pct_best_fit
# 0.5095305           1.0000000
# l1_regularizer=0.2, l2_regularizer=0.0
f <- tune.maxent(sparse[1:1552,],data$Topic.Code[1:1552],nfold=5,showall=TRUE, verbose=TRUE)
print(f)
# accuracy            pct_best_fit
# 0.5123787           1.0000000
# l1_regularizer=0.4, l2_regularizer=0.0
f <- tune.maxent(sparse[1:1552,],data$Topic.Code[1:1552],nfold=6,showall=TRUE, verbose=TRUE)
print(f)
# accuracy            pct_best_fit
# 0.5206016           1.0000000
# l1_regularizer=0.2, l2_regularizer=0.0
f <- tune.maxent(sparse[1:1552,],data$Topic.Code[1:1552],nfold=7,showall=TRUE, verbose=TRUE)
print(f)
# accuracy            pct_best_fit
# 0.5045888           1.0000000
# l1_regularizer=0.0, l2_regularizer=0.2
f <- tune.maxent(sparse[1:1552,],data$Topic.Code[1:1552],nfold=8,showall=TRUE, verbose=TRUE)
print(f)
# accuracy            pct_best_fit
# 0.5259994           1.0000000
# l1_regularizer=0.4, l2_regularizer=0.0
f <- tune.maxent(sparse[1:1552,],data$Topic.Code[1:1552],nfold=9,showall=TRUE, verbose=TRUE)
print(f)
# accuracy            pct_best_fit
# 0.5204197           1.0000000
# l1_regularizer=0.0, l2_regularizer=0.4
f <- tune.maxent(sparse[1:1552,],data$Topic.Code[1:1552],nfold=10,showall=TRUE, verbose=TRUE)
print(f)
# accuracy            pct_best_fit
# 0.5238259           1.0000000
# l1_regularizer=0.4, l2_regularizer=0.0


#se obtiene como mejor modelo el con 8 fold
model<-maxent(sparse[1:1552,],data$Topic.Code[1:1552], l1_regularizer=0.4, l2_regularizer=0.0, use_sgd=FALSE, set_heldout=0, verbose=TRUE)
results <- predict(model,sparse[1553:3104,]) 

vp = 0
fp = 0
fn = 0
vn = 0

for(f in 1:length(results[,1])){
  maxi = results[f,1]
  actual = data$Topic.Code[1553:3104][f]
  if(maxi == actual){
    if(maxi == 16 || maxi == 15 || maxi == 4 || maxi == 3 || maxi == 20 || maxi == 16 || maxi == 19 || maxi == 1){
      vp = vp + 1
    }else{
      fp = fp + 1
    }
  }else{
    if(maxi == 16 || maxi == 15 || maxi == 4 || maxi == 3 || maxi == 20 || maxi == 16 || maxi == 19 || maxi == 1){
      print(actual)
      print(maxi)
      fn = fn + 1
    }else{
      vn = vn + 1
    }
  }
}
precision = vp/(vp+fp)
recall = vp/(vp+fn)

print(recall)
#0.4354207
print(precision)
#0.7355372

print(vp)
#445
print(fp)
#160
print(fn)
#577
print(vn)
#370

#ahora se quiere se pretende obtener resultados similares en la direccion opuesta
#se obtiene como mejor modelo el con 8 fold
model<-maxent(sparse[1553:3104,],data$Topic.Code[1553:3104], l1_regularizer=0.4, l2_regularizer=0.0, use_sgd=FALSE, set_heldout=0, verbose=TRUE)
results <- predict(model,sparse[1:1552,]) 

vp = 0
fp = 0
fn = 0
vn = 0

for(f in 1:length(results[,1])){
  maxi = results[f,1]
  actual = data$Topic.Code[1:1552][f]
  if(maxi == actual){
    if(maxi == 16 || maxi == 15 || maxi == 4 || maxi == 3 || maxi == 20 || maxi == 16 || maxi == 19 || maxi == 1){
      vp = vp + 1
    }else{
      fp = fp + 1
    }
  }else{
    if(maxi == 16 || maxi == 15 || maxi == 4 || maxi == 3 || maxi == 20 || maxi == 16 || maxi == 19 || maxi == 1){
      print(maxi)
      fn = fn + 1
    }else{
      vn = vn + 1
    }
  }
}
precision = vp/(vp+fp)
recall = vp/(vp+fn)

print(recall)
#0.4557087
print(precision)
#0.7223089

print(vp)
#463
print(fp)
#178
print(fn)
#553
print(vn)
#358


#se intenta comprobar que la proporcion de casos relevantes en el conjunto de entrenamiento y en el conjunto de
#test se encuentren en proporciones similares considerando la cantidad de casos relevantes y no relevantes
r = 0
nr = 0
for(f in 1:length(data$Topic.Code[1:1552])){
  maxi = data$Topic.Code[1:1552][f]
  if(maxi == 16 || maxi == 15 || maxi == 4 || maxi == 3 || maxi == 20 || maxi == 16 || maxi == 19 || maxi == 1){
    r = r + 1
  }else{
    nr = nr + 1
  }
}

print(r/(r+nr))
print(nr/(r+nr))

# print(r/(r+nr))
# [1] 0.6101804
# print(nr/(r+nr))
# [1] 0.3898196


r = 0
nr = 0
for(f in 1:length(data$Topic.Code[1553:3104])){
  maxi = data$Topic.Code[1553:3104][f]
  if(maxi == 16 || maxi == 15 || maxi == 4 || maxi == 3 || maxi == 20 || maxi == 16 || maxi == 19 || maxi == 1){
    r = r + 1
  }else{
    nr = nr + 1
  }
}

print(r/(r+nr))
print(nr/(r+nr))

# print(r/(r+nr))
# [1] 0.6443299
# print(nr/(r+nr))
# [1] 0.3556701

#para mejorar este proceso lo que se realiza es comprabar las clases en las que se esta equivocando en clasificador
#de texto donde es posible apreciar que todos los temas se encuentran muy relacionados por lo que sera necesario realizar
#el cambio de etiqueta  auno comun

for(i in 1:3104){
  maxi = data$Topic.Code[1:3104][i]
  if(maxi == 16 || maxi == 15 || maxi == 4 || maxi == 3 || maxi == 20 || maxi == 16 || maxi == 19 || maxi == 1){
    data$Topic.Code[1:3104][i] = 1
  }
}


#los nuevos resultados obtenidos con el cambio de etiqueta  auno comun corresponden a :
model<-maxent(sparse[1:1552,],data$Topic.Code[1:1552], l1_regularizer=0.4, l2_regularizer=0.0, use_sgd=FALSE, set_heldout=0, verbose=TRUE)
results <- predict(model,sparse[1553:3104,]) 

vp = 0
fp = 0
fn = 0
vn = 0

for(f in 1:length(results[,1])){
  maxi = results[f,1]
  actual = data$Topic.Code[1553:3104][f]
  if(maxi == actual){
    if(maxi == 1){
      vp = vp + 1
    }else{
      fp = fp + 1
    }
  }else{
    if(maxi == 1){
      print(actual)
      print(maxi)
      fn = fn + 1
    }else{
      vn = vn + 1
    }
  }
}
precision = vp/(vp+fp)
recall = vp/(vp+fn)

print(recall)
#0.736224
print(precision)
#0.8587987

print(vp)
#815
print(fp)
#134
print(fn)
#292
print(vn)
#311

#ahora se quiere se pretende obtener resultados similares en la direccion opuesta
#se obtiene como mejor modelo el con 8 fold
model<-maxent(sparse[1553:3104,],data$Topic.Code[1553:3104], l1_regularizer=0.4, l2_regularizer=0.0, use_sgd=FALSE, set_heldout=0, verbose=TRUE)
results <- predict(model,sparse[1:1552,]) 

vp = 0
fp = 0
fn = 0
vn = 0

for(f in 1:length(results[,1])){
  maxi = results[f,1]
  actual = data$Topic.Code[1:1552][f]
  if(maxi == actual){
    if(maxi == 1){
      vp = vp + 1
    }else{
      fp = fp + 1
    }
  }else{
    if(maxi == 1){
      print(maxi)
      fn = fn + 1
    }else{
      vn = vn + 1
    }
  }
}
precision = vp/(vp+fp)
recall = vp/(vp+fn)

print(recall)
#0.7140078
print(precision)
#0.8201117

print(vp)
#734
print(fp)
#161
print(fn)
#294
print(vn)
#363