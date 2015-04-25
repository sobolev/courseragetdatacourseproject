activity_labels<-read.csv(".\\UCI HAR Dataset\\activity_labels.txt",header=FALSE,sep="")

features<-read.csv(".\\UCI HAR Dataset\\features.txt",header=FALSE,sep="")
the.ones.we.want<-grepl("mean\\(\\)|std\\(\\)",features$V2)

subject_test<-read.csv(".\\UCI HAR Dataset\\test\\subject_test.txt",header=FALSE,sep="")
names(subject_test)[1]<-"subject"

X_test<-read.csv(".\\UCI HAR Dataset\\test\\X_test.txt",header=FALSE,sep="")
names(X_test)<-features$V2
X_test<-X_test[,the.ones.we.want]

y_test<-read.csv(".\\UCI HAR Dataset\\test\\y_test.txt",header=FALSE,sep="")
names(y_test)[1]<-"activity"
y_test$activity <- activity_labels[,2][match(y_test$activity, activity_labels[,1])]

subject_train<-read.csv(".\\UCI HAR Dataset\\train\\subject_train.txt",header=FALSE,sep="")
names(subject_train)[1]<-"subject"

X_train<-read.csv(".\\UCI HAR Dataset\\train\\X_train.txt",header=FALSE,sep="")
names(X_train)<-features$V2
X_train<-X_train[,the.ones.we.want]

y_train<-read.csv(".\\UCI HAR Dataset\\train\\y_train.txt",header=FALSE,sep="")
names(y_train)[1]<-"activity"
y_train$activity <- activity_labels[,2][match(y_train$activity, activity_labels[,1])]

temp.test<-cbind(subject_test,X_test,y_test)
temp.train<-cbind(subject_train,X_train,y_train)

library(data.table)
final.data<-data.table(rbind(temp.test,temp.train))
summary.data<-final.data[,lapply(.SD,mean),by=c("subject","activity")]
write.table(summary.data,file="tidy_data.txt",row.names=FALSE)

write.table(cbind(names(summary.data),sapply(summary.data,typeof)),file="names.txt",row.names=FALSE,sep=",")

