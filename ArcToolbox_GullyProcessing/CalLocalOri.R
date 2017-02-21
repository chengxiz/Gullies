tool_exec <- function(in_params, out_params){
	points<-in_params[[1]]
	Point_X<-in_params[[2]]
	Point_Y<-in_params[[3]]
	Elevation<-in_params[[4]]
	GID<-in_params[[5]]
	Local_Orientation<-in_params[[6]]

	PointsNewDir<-out_params[[1]]

	pointsFeature<-arc.open(points)
	df <- data.frame(arc.select(pointsFeature, c(Point_X, Point_Y,Elevation,GID,Local_Orientation)))
	colnames(df)<-c(Point_X, Point_Y,Elevation,GID,Local_Orientation)

	print(df)
	rlist<-list(row.names(unique(data.frame(df)[GID])))

	for (i in 1:(nrow(df)-1)){
		#where the two points belonging to the same gully or not 
		if (df[i+1,4]==df[i,4]){
			vector_x<-(df[i+1,1]-df[i,1])
			vector_y<-(df[i+1,2]-df[i,2])
			radian=atan2(vector_y,vector_x)/pi*180
			if (radian<0){
				df[i,5]=radian+360
				} else{
				df[i,5]=radian
			}
		} else(
			df[i,5]=df[i-1,5]
			)
		i<-i+1
	}
	df[nrow(df),5]=df[nrow(df)-1,5]
	print(rlist)
	print(df)
	PointsFeatures<-arc.open(points)
	PointsFeatures_Local<-arc.select(PointsFeatures)
	PointsFeatures_Local['Local_Orientation'] = df[,5]
	arc.write(PointsNewDir,PointsFeatures_Local)

}