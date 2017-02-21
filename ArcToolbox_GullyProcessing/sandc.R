tool_exec <- function(in_params, out_params){
	# workspace<-in_params[[1]]
	points<-in_params[[1]]
	Point_X<-in_params[[2]]
	Point_Y<-in_params[[3]]
	Elevation<-in_params[[4]]
	GID<-in_params[[5]]
	Gullies<-in_params[[6]]
	GulliesNew<-out_params[[1]]
	pointsFeature<-arc.open(points)
	df <- data.frame(arc.select(pointsFeature, c(Point_X, Point_Y,Elevation,GID)))
	print(typeof(df))
	colnames(df)<-c(Point_X, Point_Y,Elevation,GID)
	# print(df[1,4])
	ls<-list()
	as<-c()
	cc<-c()
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
		###NROW() is for vectors
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
		print(subPoints[,3])
		# print(log(subPoints[,3]))
		# print(log(subPoints[,1]))
		fit <- lm(log(subPoints[,3]) ~ log(subPoints[,1]))
		concavity<-fit$coefficients[[2]]
		as<-c(as,AvgSlope)
		cc<-c(cc,concavity)
		# print(subPoints)
		print(AvgSlope)
		print(concavity)
		# print i
	}
	print(as)
	print(cc)
	gulliesFeature<-arc.open(Gullies)
	gulliesSlopeAndConcavity<-arc.select(gulliesFeature)
	print(typeof(gulliesSlopeAndConcavity))
	gulliesSlopeAndConcavity['Avg_Slope'] = as
	gulliesSlopeAndConcavity['Concavity'] = cc
	print(typeof(gulliesSlopeAndConcavity))	
	arc.write(GulliesNew,gulliesSlopeAndConcavity)
}