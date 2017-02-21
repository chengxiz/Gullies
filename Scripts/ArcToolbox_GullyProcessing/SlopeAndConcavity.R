tool_exec <- function(in_params, out_params){
	# workspace<-in_params[[1]]
	points<-in_params[[1]]
	Point_X<-in_params[[2]]
	Point_Y<-in_params[[3]]
	Elevation<-in_params[[4]]
	GID<-in_params[[5]]
	# Gullies<-in_params[[6]]


	pointsFeature<-arc.open(points)
	df <- data.frame(arc.select(pointsFeature, c(Point_X, Point_Y,Elevation,GID)))
	print(typeof(df))
	colnames(df)<-c(Point_X, Point_Y,Elevation,GID)
	# print(df[1,4])
	pAll<-data.frame(t(c("Distance","Differ_Ele","Slope","GID")))

	ls<-list()
	for (i in 1:(nrow(df)-1)){
		#where the two points belonging to the same gully or not 
		if (df[i+1,4]==df[i,4]){
			d=sqrt((df[i+1,1]-df[i,1])^2+(df[i+1,2]-df[i,2])^2)*(0.3048^2)#distance between two points and feet to meters
			ed=(df[i+1,3]-df[i,3])#difference of elevation between two points
			slope=ed/d
			ls[[i]]<-c(d,ed,slope,df[i,4])
		}
		i<-i+1
	}
	rlist<-list(row.names(unique(data.frame(df)[GID])))
	ngully<-length(rlist[[1]])
	print(ngully)
	print(rlist)
	# filename<-paste(workspace,'Gullies.txt',sep='\')
	# cat("Hello",file="outfile.txt",sep="\n")
	for (i in 1:ngully){
		n1=as.numeric(rlist[[1]][i])
		print(i)
		# print(ngully)
		if (i==ngully){
				n2=as.numeric(length(ls))
				lastn=n2	
			}else {
				n2=as.numeric(rlist[[1]][i+1])
				lastn=n2-2
			}
		# print(n1)
		# print(lastn)
		#All points belong to the same gully
		subPoints<-t(data.frame(ls[n1:lastn]))
		colnames(subPoints) <- c("Distance","Differ_Ele","Slope","GID")
		rownames(subPoints) <- c(n1:lastn)

		print(subPoints)

		#Make sure the trendency is from shell to river, the differences of elevation keep positive but decrease
		npst<-NROW(subPoints[subPoints[,3]>=0,])
		nnga<-NROW(subPoints[subPoints[,3]<0,])
		# print(subPoints[subPoints[,3]<0,])
		# print(typeof(subPoints[subPoints[,3]>=0,]))
		# print(subPoints[subPoints[,3]>=0,])
		# print(typeof(data.frame(subPoints[subPoints[,3]<0,])))		
		# print(subPoints[subPoints[,3]<0,])
		# print(nrow(t(subPoints[subPoints[,3]<0,])))
		print(npst)
		print(nnga)
		if (npst<nnga){
			#from like c(-1,-2,-3) to c(3,2,1) 
			subPoints[,2]<-(-rev(subPoints[,2]))
			subPoints[,1]<-rev(subPoints[,1])
			subPoints[,3]<-(-rev(subPoints[,3]))
			subPoints[,4]<-rev(subPoints[,4])
		}
		
		AvgSlope=mean(subPoints[,3])
		# print(subPoints[,3])
		# print(log(subPoints[,3]))
		# print(log(subPoints[,1]))
		fit <- lm(log(subPoints[,3]) ~ log(subPoints[,1]))
		concavity<-fit$coefficients[[2]]
		pAll<-merge(pAll,subPoints)
		print(subPoints)
		print(AvgSlope)
		print(concavity)
		# recal the distances
		for (j in n1:lastn){
			subPoints[j,1]=sum(subPoints[n1:j,1])
		}
		print(subPoints)
		# print i
	}
	print(pAll)
	print("output csv")
	write.csv(pAll, file = "H:\GIS data\SCRIPTS\MyData.csv")
# 	gulliesFeature<-arc.open(Gullies)
# 	gulliesSlopeAndConcavity<-data.frame(arc.select(gulliesFeature,c('Avg_Slope','Concavity')))
# 	print(typeof(gulliesSlopeAndConcavity))
# 	gulliesSlopeAndConcavity['Avg_Slope'] = AvgSlope
# 	gulliesSlopeAndConcavity['Concavity'] = concavity
# 	print(typeof(gulliesSlopeAndConcavity))	
# 	arc.write(Gullies, gulliesSlopeAndConcavity)
}