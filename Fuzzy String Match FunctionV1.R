#install.packages("stringdist")
library(stringdist)

# This function calaculates the string distance between two string variables and selects the match with the 
# smallest distance. It takes 7 arguments:
#  dat1 - Reference dataset, select the one you want to return with appended matches
#  dat2 - Comparison dataset 
#  string1 - dat1 variable name in string format for comparison
#  string2 - dat2 variable name in string format for comparison
#  meth - stringdist(method=) method. See ?stringdist for details
#          osa	      Optimal string aligment, (restricted Damerau-Levenshtein distance).
#          lv	        Levenshtein distance (as in R's native adist).
#          dl	        Full Damerau-Levenshtein distance.
#          hamming	  Hamming distance (a and b must have same nr of characters).
#          lcs	      Longest common substring distance.
#          qgram	    q-gram distance.
#          cosine	    cosine distance between q-gram profiles
#          jaccard	  Jaccard distance between q-gram profiles
#          jw	        Jaro, or Jaro-Winker distance.
#          soundex	  Distance based on soundex encoding (see below)
#  [OPTIONAL] id1 - dat1 variable name you want to retain after matching
#  [OPTIONAL] id2 - dat2 variable name you want to retain after matching


fuzzymatch<-function(dat1,dat2,string1,string2,meth,id1,id2){
  #initialize Variables:
  matchfile <-NULL #iterate appends
  x<-nrow(dat1) #count number of rows in input, for max number of runs
  
  #Check to see if function has ID values. Allows for empty values for ID variables, simple list match
  if(missing(id1)){id1=NULL}
  if(missing(id2)){id2=NULL}
     
  #### lowercase text only
  dat1[,string1]<-as.character(tolower(unlist(dat1[,string1])))#force character, if values are factors
  dat2[,string2]<-as.character(tolower(unlist(dat2[,string2])))
  
    #Loop through dat1 dataset iteratively. This is a work around to allow for large datasets to be matched
    #Can run as long as dat2 dataset fits in memory. Avoids full Cartesian join.
    for(i in 1:x) {
      d<-merge(dat1[i,c(string1,id1), drop=FALSE],dat2[,c(string2,id2), drop=FALSE])#drop=FALSE to preserve 1var dataframe
      
      #Calculate String Distatnce based method specified "meth"
      d$dist <- stringdist(d[,string1],d[,string2], method=meth)
      
      #dedupes A_names selects on the smallest distatnce.
      d<- d[order(d[,string1], d$dist, decreasing = FALSE),]
      d<- d[!duplicated(d[,string1]),]
      
      #append demos on matched file
      matchfile <- rbind(matchfile,d)
     # print(paste(round(i/x*100,2),"% complete",sep=''))
      
    }
  return(matchfile)
}
# test examole:
names1<-c("Aaliyah",
          "Abbey",
          "Abby",
          "Abi",
          "Abia",
          "Abigail",
          "Adalyn",
          "Addison")
dataset1<-data.frame(names1,stringsAsFactors =FALSE)

names2<-c("xAaliyah",
          "xAbbey",
          "xAbby",
          "xAbi",
          "xAbia",
          "xAbigail",
          "xAdalyn",
          "xAddison",
          "xxAaliyah",
          "xxxAbbey",
          "xxAbby",
          "xxAbi",
          "xxAbia",
          "xxAbigail",
          "xxAdalyn",
          "xxAddison")
dataset2<-data.frame(names2,stringsAsFactors =FALSE)

example<-fuzzymatch(dataset1,dataset2,"names1","names2",meth="osa")
head(example)

