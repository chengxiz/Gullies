tool_exec <- function(in_params, out_params){
	###### STEP0: Import Parameters ######
	points<-in_params[[1]]
	out_points<-out_params[[1]]

	###### STEP1: Read Data ######
	pointsFeature<-arc.open(points)
	df <- data.frame(arc.select(pointsFeature, c("Position", "Gully_ID","LOCATION_X","LOCATION_Y","RASTERVALU")))
	colnames(df)<-c("Position", "Gully_ID","LOCATION_X","LOCATION_Y","RASTERVALU")
	# print(df)
	###### STEP2: Create Data Frame and Calculate ######
	df.all <- data.frame(matrix(ncol = 6, nrow = 0))
	colnames(df.all)<-data.frame("Position", "Gully_ID","LOCATION_X","LOCATION_Y","RASTERVALU","DISTANCE")
	df$DISTANCE=NA
	CalDis <- function (x) {
		x$DISTANCE[1]<-0
		for (i in 2:dim(x)[1]){
			x$DISTANCE[i]<-sqrt((x$LOCATION_X[i]-x$LOCATION_X[i-1])^2+(x$LOCATION_Y[i]-x$LOCATION_Y[i-1])^2)*(0.3048)+x$DISTANCE[i-1]
		}
		return(x)
	}	
	for (i in unique(df$Gully_ID)){
		df.sub<-df[df$Gully_ID==i,]
		tryCatch(
			{
				df.sub.025<-df.sub[df.sub$Position==0.25,]
				df.sub.025<-CalDis(df.sub.025)
				df.all<-rbind(df.all,df.sub.025)
			},
			error = function(e)
			{
				print(e)
			}
			)
		tryCatch(
			{
				df.sub.050<-df.sub[df.sub$Position==0.50,]
				df.sub.050<-CalDis(df.sub.050)
				df.all<-rbind(df.all,df.sub.050)
			},
			error = function(e)
			{
				print(e)
			}
			)
		tryCatch(
			{
				df.sub.100<-df.sub[df.sub$Position==1.00,]
				df.sub.100<-CalDis(df.sub.100)
				df.all<-rbind(df.all,df.sub.100)
			},
			error = function(e)
			{
				print(e)
			}
			)

		# df.sub.025<-df.sub[df.sub$Position==0.25,]
		# df.sub.050<-df.sub[df.sub$Position==0.50,]
		# df.sub.100<-df.sub[df.sub$Position==1.00,]
		# df.sub.025<-CalDis(df.sub.025)
		# df.sub.050<-CalDis(df.sub.050)
		# df.sub.100<-CalDis(df.sub.100)
		# df.all<-rbind(df.all,df.sub.025,df.sub.050,df.sub.100)
	}
	#Reorder colomns	
	df.all<-df.all[c(1,2,3,4,6,5)]	
	df.all[,6] <- df.all[,6]*(0.3048) # convert feet to meters
	print(df.all)

	###### STEP3: Output Data ######
	write.csv(df.all, file = out_points)
}