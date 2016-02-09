tool_exec <- function(in_params, out_params){
	# workspace<-in_params[[1]]
	points<-in_params[[1]]
	Point_X<-in_params[[2]]
	Point_Y<-in_params[[3]]
	Elevation<-in_params[[4]]
	GID<-in_params[[5]]
	Width<-in_params[[6]]
	Depth<-in_params[[7]]
	Gullies<-in_params[[8]]
	GulliesNew<-out_params[[1]]
	pAllDir<-out_params[[2]]
	p2PtsDir<-out_params[[3]]
	p3PtsDir<-out_params[[4]]
	p5PtsDir<-out_params[[5]]


	# library(rjson)
	#########
	## Variable:
		# "df"
	## Definition:
		# 
	## Input:
		#  
		# 
	## Output:
		# 
	#########
	pointsFeature<-arc.open(points)
	df <- data.frame(arc.select(pointsFeature, c(Point_X, Point_Y,Elevation,GID,Width,Depth)))
	print(typeof(df))
	colnames(df)<-c(Point_X, Point_Y,Elevation,GID,Width,Depth)
	print(df)



	mx<-matrix(ncol = 4, nrow = 0)
	mx2<-matrix(ncol = 5, nrow = 0)
	mx3<-matrix(ncol = 3, nrow = 0)

	pAll<-data.frame(mx)
	p2Pts<-data.frame(mx2)
	p3Pts<-data.frame(mx2)
	p5Pts<-data.frame(mx2)
	pRe<-data.frame(mx3)
	cln<-c("Distance(m)","Differ_Ele(m)","Slope(m/m)","GID")
	cln2<-c("Acc_Distance(m)","Acc_Ele(m)","Slope(m/m)","GID")
	cln3<-c("Distance(m)","RelativeElevation(m)","GID")
	cln4<-c("Distance(m)","Slope(m/m)","GID")
	cln5<-c("Distance(m)","RelativeElevation(m)","GID","AbsoluteElevation(m)","Width(m)","Depth(m)")



	colnames(pAll) <- cln3
	colnames(pRe) <- cln3
	colnames(p2Pts) <- cln4
	colnames(p3Pts) <- cln4
	colnames(p5Pts) <- cln4

	#########
	## Variable:
		# "ls"
	## Definition:
		# All points of the gully table
	## Input:
		# Var "df"
	## Output:
		# Var "subPonts"
	#########
	ls<-list()
	as<-c() # Array for storing average slope
	cc<-c() # Array for storing concavity
	cc2<-c() # Array for storing concavity by slope with 2pts
	cc3<-c() # Array for storing concavity by slope with 3pts
	cc5<-c() # Array for storing concavity by slope with 5pts

	for (i in 1:(nrow(df)-1)){
		#where the two points belonging to the same gully or not 
		if (df[i+1,4]==df[i,4]){
			d=sqrt((df[i+1,1]-df[i,1])^2+(df[i+1,2]-df[i,2])^2)*(0.3048)#distance between two points and feet to meters
			ed=(df[i,3]-df[i+1,3])#difference of elevation between two points
			if (ed==0){
				slope=0.000001 # In case no difference of elevation
				# df[i,3]=df[i,3]+0.000001*d
				ed=0.000001
			}
			else {
				slope=ed/d
			}
			ls[[i]]<-c(d,ed,slope,df[i,4])
		}
		i<-i+1
	}

	print("ls")
	print(ls)


	rlist<-list(row.names(unique(data.frame(df)[GID])))
	ngully<-length(rlist[[1]])
	print(paste("# of gullies",ngully,sep=":"))
	print(rlist)
	# Calculate by gullies
	for (i in 1:ngully){

		#########
		## Variable:
			# "n1"
		## Definition:
			# Start Point Number for every array of points from the same gully
		## Input:
			# Var "rlist" 
		## Output:
			# Var "subPoints"
		#########	
		n1=as.numeric(rlist[[1]][i])

		#########
		## Variable:
			# "ln"
		## Definition:
			# End Point Number for every array of points from the same gully
		## Input:
			# Var "rlist" 
			# Var "ls"
		## Output:
			# Var "subPoints"
		#########
		if (i==ngully){
				n2=as.numeric(length(ls))
				ln=n2	
			}else {
				n2=as.numeric(rlist[[1]][i+1])
				ln=n2-2
			}

		print(paste("Gully Number",i,sep=":"))
		print(paste("Start Point Number",n1,sep=":"))
		print(paste("End Point Number",ln,sep=":"))
		
		#########
		## Variable:
			# "subPoints"
		## Definition:
			# Subpoints, from the same gully, with interval distance, elevation difference 
			# slope is calculated by elevation difference/interval distance
		## Input:
			# Var "ls"
			# Var "cln"
		## Output:
			# Value "AvgSlope"
			# Var "SubPtsIntDifSlp"
			# Renewed "df"
		#########
		subPoints<-t(data.frame(ls[n1:ln]))
		colnames(subPoints) <- cln
		rownames(subPoints) <- c(n1:ln)
		print('n1 and ln')
		print(n1)
		print(ln)
		#Make sure the trendency is from gully head to gully mouth, the differences of elevation keep positive but decrease
		###NROW() is for vectors
		npst<-NROW(subPoints[subPoints[,2]>=0,])
		nnga<-NROW(subPoints[subPoints[,2]<0,])		
		# print(npst)
		# print(nnga)
		print("subPoints")
		print(subPoints)

		if (sum(subPoints[,2])<0){		
		# if ((npst<nnga)&sum(subPoints[,2]<0)){
			print(subPoints[,2])
			print('sum')
			print(sum(subPoints[,2]))
			print('The first pt is gully mouth, so reverse it')
			#from like c(-1,-2,-3) to c(3,2,1) 
			subPoints[,2]<-(-rev(subPoints[,2]))
			subPoints[,1]<-rev(subPoints[,1])
			subPoints[,3]<-(-rev(subPoints[,3]))
			subPoints[,4]<-rev(subPoints[,4])
			df[n1:(ln+1),1]<-rev(df[n1:(ln+1),1])
			df[n1:(ln+1),2]<-rev(df[n1:(ln+1),2])
			df[n1:(ln+1),3]<-rev(df[n1:(ln+1),3])
			df[n1:(ln+1),4]<-rev(df[n1:(ln+1),4])
			df[n1:(ln+1),5]<-rev(df[n1:(ln+1),5])
			df[n1:(ln+1),6]<-rev(df[n1:(ln+1),6])
		

		} else {
			print('The first pt is gully head, so keep it')

		}
		print("subPoints")
		print(subPoints)
		# Calculate the Average Slope value
		AvgSlope=mean(subPoints[,3])

		#########
		## Variable:	
			# "SubPtsIntDifSlp"
		## Definition:
			# Subpoints with accumlated distance and elevation	
		## Input:
			# Var "subPoints"
			# Vec "cln2"
		## Output:
			# Value "Concavity"
			# Var "SubPtsRelCord"
		#########
		SubPtsIntDifSlp<-subPoints
		colnames(SubPtsIntDifSlp) <- cln2	
		for (j in 1:(ln-n1+1)){
			# print(j)
			SubPtsIntDifSlp[j,1]=sum(subPoints[1:j,1])
			SubPtsIntDifSlp[(ln-n1+2-j),2]=sum(subPoints[(ln-n1+2-j):(ln-n1+1),2])
		}
		print("SubPtsIntDifSlp")
		print(SubPtsIntDifSlp)

		#########
		## Variable:	
			# "SubPtsRelCord"
		## Definition:
			# Subpoints with Relative Coordinate System e.g. the first point (gully head) is with distance of zero and highest elevation
		## Input: 
			# Var "SubPtsIntDifSlp"
			# Vec "cln3"
		## Output:
			# Var "subPoints2",
			# Var "subPoints3",
			# Var "subPoints5" 	
		#########
		print("SubPtsRelCord")
		SubPtsRelCord<-data.frame(matrix(ncol = 6, nrow = (ln-n1+2)))
		colnames(SubPtsRelCord)<-cln5
		rownames(SubPtsRelCord)<-c(n1:(ln+1))
		SubPtsRelCord[,1]=as.vector(c(0,SubPtsIntDifSlp[,1]))
		SubPtsRelCord[,2]=as.vector(c(SubPtsIntDifSlp[,2],0))
		SubPtsRelCord[,3]=SubPtsIntDifSlp[1,4]
		SubPtsRelCord[,4]=df[n1:(ln+1),3]
		SubPtsRelCord[,5]=df[n1:(ln+1),5]
		SubPtsRelCord[,6]=df[n1:(ln+1),6]
		print(SubPtsRelCord)

		#########	
		## Variable:
			# "subPoints2"
		## Definition:
			# Subpoints whose slope value is derived by 2 points
		## Input: 
			# Var "SubPtsRelCord"
			# Vec "cln4"
		## Output:
			# Var "p2Pts"
		######### 
		if ((ln-n1+1)>0){
			subPoints2<-data.frame(matrix(ncol = 3, nrow = (ln-n1+1)))
			colnames(subPoints2)<-cln4
			# print(paste(n1:ln,(n1+1):(ln+1),sep=','))
			rownames(subPoints2)<-paste(n1:ln,(n1+1):(ln+1),sep=',')
			for (j in 1:(ln-n1+1)){
				#Distance from the mid point of two points to the origin point
				subPoints2[j,1]=0.5*(SubPtsRelCord[j,1]+SubPtsRelCord[j+1,1])



				#Slope
				subPoints2[j,2]=-((SubPtsRelCord[(j+1),2]-SubPtsRelCord[(j),2])/(SubPtsRelCord[(j+1),1]-SubPtsRelCord[(j),1]))
			}
			#Gully ID
			subPoints2[,3]=SubPtsRelCord[1,3]			
			print("slope within 2 points")
			print(subPoints2)
		}

		#########	
		## Variable:
			# "subPoints3"
		## Definition:
			# Subpoints whose slope value is derived by 3 points
		## Input: 
			# Var "SubPtsRelCord"
			# Vec "cln4"
		## Output:
			# Var "p3Pts"
		######### 		
		if (ln-n1>0){
			print("slope within 3 points")

			subPoints3<-data.frame(matrix(ncol = 3, nrow = (ln-n1)))
			colnames(subPoints3)<-cln4
			rownames(subPoints3)<-paste(n1:(ln-1),(n1+1):ln,(n1+2):(ln+1),sep=',')
			# dis<-c()
			for (j in 2:(ln-n1+1)){
				#Distance from the 2nd point
				subPoints3[j-1,1]=SubPtsRelCord[j,1]
				#Slope				
				DisVec=SubPtsRelCord[(j+1):(j-1),1]
				EleVec=SubPtsRelCord[(j+1):(j-1),2]				
				subPoints3[(j-1),2]=-(coef(lm(EleVec ~ DisVec))[[2]])

			}			
			#Gully ID
			subPoints3[,3]=subPoints[1,4]
			print(subPoints3)
		}

		#########	
		#Variable:
			#"subPoints5"
		## Definition:
			# Subpoints whose slope value is derived by 5 points
		## Input: 
			# Var "SubPtsRelCord"
			# Vec "cln4"
		## Output:
			# Var "p5Pts"
		#########
		if (ln-n1-2>0){
			print("slope within 5 points")
			subPoints5<-data.frame(matrix(ncol = 3, nrow = (ln-n1-2)))
			colnames(subPoints5)<-cln4
			rownames(subPoints5)<-paste(n1:(ln-3),(n1+1):(ln-2),(n1+2):(ln-1),(n1+3):(ln),(n1+4):(ln+1),sep=',')
			for (j in 5:(ln-n1+2)){
				#Distance from the 3rd point to the origin point
				subPoints5[j-4,1]=SubPtsRelCord[j-2,1]				
				#Slope
				DisVec=SubPtsRelCord[(j-4):j,1]
				EleVec=SubPtsRelCord[(j-4):j,2]
				subPoints5[(j-4),2]=-(coef(lm(EleVec ~ DisVec))[[2]])
			}
			#Gully ID
			subPoints5[,3]=subPoints[1,4]
			print(subPoints5)
		}

# 		result = tryCatch({
#     a+b
# }, warning = function(w) {
#     print('wtf')
# }, error = function(e) {
#     print('wtH')
# }, finally = {
#     print('cleanup')
# }
# )

		concavity <- tryCatch({
			coef(lm(log(SubPtsIntDifSlp[,3]) ~ log(SubPtsIntDifSlp[,1])))[[2]]
				}, error = function(e) {
					NaN
				}
			)

		concavity2 <- tryCatch({
			coef(lm(log(subPoints2[,2]) ~ log(subPoints2[,1])))[[2]]
				},	error = function(e) {
					NaN
				}
			)

		concavity3 <- tryCatch({
			coef(lm(log(subPoints3[,2]) ~ log(subPoints3[,1])))[[2]]
				}, error = function(e) {
					NaN
				}
			)

		concavity5 <- tryCatch({
			coef(lm(log(subPoints5[,2]) ~ log(subPoints5[,1])))[[2]]
				}, error = function(e) {
					NaN
				}
			)


		# concavity <- coef(lm(log(SubPtsIntDifSlp[,3]) ~ log(SubPtsIntDifSlp[,1])))[[2]]
		# concavity2 <- coef(lm(log(subPoints2[,2]) ~ log(subPoints2[,1])))[[2]]
		# concavity3 <- coef(lm(log(subPoints3[,2]) ~ log(subPoints3[,1])))[[2]]
		# concavity5 <- coef(lm(log(subPoints5[,2]) ~ log(subPoints5[,1])))[[2]]

		as<-c(as,AvgSlope)
		cc<-c(cc,concavity)
		cc2<-c(cc2,concavity2)
		cc3<-c(cc3,concavity3)
		cc5<-c(cc5,concavity5)

		print(AvgSlope)
		print(concavity)	
		pAll<-rbind(pAll,SubPtsRelCord)
		p2Pts<-rbind(p2Pts,subPoints2)
		p3Pts<-rbind(p3Pts,subPoints3)
		p5Pts<-rbind(p5Pts,subPoints5)

	}
	
	gulliesFeature<-arc.open(Gullies)
	gulliesSlopeAndConcavity<-arc.select(gulliesFeature)
	print(typeof(gulliesSlopeAndConcavity))
	gulliesSlopeAndConcavity['Avg_Slope'] = as
	gulliesSlopeAndConcavity['Concavity'] = cc
	gulliesSlopeAndConcavity['Concavity2'] = cc2
	gulliesSlopeAndConcavity['Concavity3'] = cc3
	gulliesSlopeAndConcavity['Concavity5'] = cc5

	print(typeof(gulliesSlopeAndConcavity))	
	arc.write(GulliesNew,gulliesSlopeAndConcavity)

	print(df)
	# gartf


	print("output csv")
	write.csv(pAll, file = pAllDir)
	write.csv(p2Pts, file = p2PtsDir)
	write.csv(p3Pts, file = p3PtsDir)
	write.csv(p5Pts, file = p5PtsDir)
}
# H:/GIS data/SCRIPTS/p2Pts.csv