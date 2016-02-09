import arcpy
import math
from arcpy import env
from arcpy.sa import *
###### STEP0: Import Parameters ######

GullyPointsDir = arcpy.GetParameterAsText(0)
GullyPolylineDir = arcpy.GetParameterAsText(1)
GullyMarginDir = arcpy.GetParameterAsText(2)
DEMRasterDir = arcpy.GetParameterAsText(3)

GullyMarginPointsDir = arcpy.GetParameterAsText(4)

shapeName1 = arcpy.Describe(GullyMarginDir).shapeFieldName
shapeName2 = arcpy.Describe(GullyPointsDir).shapeFieldName

GullyMargins = arcpy.CopyFeatures_management(GullyMarginDir,arcpy.Geometry())
GullyPoints = arcpy.CopyFeatures_management(GullyPointsDir,arcpy.Geometry())

###### STEP1: Get UNIQUE Gully_ID field value list ######

Gully_ID_list=[]
field="Gully_ID"
Gully_ID_list=[row[0] for row in arcpy.da.SearchCursor(GullyMarginDir,(field))]
# arcpy.AddMessage(Gully_ID_list)
Gully_ID_list=list(set(Gully_ID_list))
# arcpy.AddMessage(Gully_ID_list)

###### STEP2: Get LENGTH of DIAGONAL from the extent of two margins of one gully ######

extentpool=[]
LenDiag=dict()
for j in Gully_ID_list:
	expression = arcpy.AddFieldDelimiters(GullyMarginDir, field) + " = " + str(j)
	for row in arcpy.SearchCursor(GullyMarginDir,where_clause=expression):
		feat = row.getValue(shapeName1)
		extent = feat.extent		
		extentpool.append([extent.XMin,extent.YMin,extent.XMax,extent.YMax])
	if len(extentpool)==2:		
		XMin2=min(extentpool[0][0],extentpool[1][0])
		YMin2=min(extentpool[0][1],extentpool[1][1])
		XMax2=max(extentpool[0][2],extentpool[1][2])
		YMax2=max(extentpool[0][3],extentpool[1][3])
		length_diagonal=math.sqrt(math.pow((XMax2-XMin2),2)+math.pow((YMax2-YMin2),2))
		# arcpy.AddMessage(extentpool)
		# arcpy.AddMessage(length_diagonal)
		extentpool=[]
		LenDiag[str(j)]=length_diagonal
	else:
		arcpy.AddMessage("NOT exact two margins for the gully whose Gully_ID is "+str(j))
		arcpy.AddMessage("Please EDIT the corresponding margin polyline feature")
		Gully_ID_list.remove(j)

arcpy.AddMessage(LenDiag)

###### STEP3: draw perpendicular lines to intersect with margins  ######

desc = arcpy.Describe(GullyMarginDir)

# Set local variables
out_path = desc.path
out_name = desc.baseName + "_perpendicular_lines"
geometry_type = "POLYLINE"
template = []
has_m = "DISABLED"
has_z = "DISABLED"
spatial_reference = desc.spatialReference
#Set overwrite option
env.workspace = out_path
env.overwriteOutput = True
arcpy.CreateFeatureclass_management(out_path, out_name, geometry_type, template, has_m, has_z, spatial_reference)

perpendicular_lines_dir=out_path+'/'+out_name

arcpy.AddField_management(perpendicular_lines_dir,field,"Short")
arcpy.AddField_management(perpendicular_lines_dir,"Point_OBJECTID","Short")



# Open an InsertCursor and insert the new geometry
cursor = arcpy.da.InsertCursor(perpendicular_lines_dir, ['Point_OBJECTID','Gully_ID','SHAPE@'])


field2='Orientation'
field3='OBJECTID;LOCATION_X;LOCATION_Y'
searchfield='ID'
featureList = []
for j in Gully_ID_list:	
	expression = arcpy.AddFieldDelimiters(GullyPolylineDir, searchfield) + " = " + str(j)
	for row in arcpy.SearchCursor(GullyPolylineDir,where_clause=expression, fields=field2):		
		
		# Get the Orientation of gully and get the Orientation of the perpendicular lines by adding 90 degrees 
		# arcpy.AddMessage(row.Orientation)
		ORIEN= row.Orientation +90 if (row.Orientation +90)<360 else (row.Orientation + 90 - 360)
		
		# Create new perpendicular lines
		expression = arcpy.AddFieldDelimiters(GullyPointsDir, field) + " = " + str(j)
		rows = arcpy.SearchCursor(GullyPointsDir,where_clause=expression, fields=field3)
		delta_x=math.sin(math.radians(ORIEN))*LenDiag[str(j)]
		delta_y=math.cos(math.radians(ORIEN))*LenDiag[str(j)]
		# arcpy.AddMessage('delta'+str(delta_x)+':'+str(delta_y))
		for row in rows:
			Point1 = arcpy.Point()
			Point1.X=row.LOCATION_X + delta_x
			Point1.Y=row.LOCATION_Y + delta_y
			Point2 = arcpy.Point()
			Point2.X=row.LOCATION_X - delta_x  
			Point2.Y=row.LOCATION_Y - delta_y	
			array = arcpy.Array()
			array.add(Point1)
			array.add(Point2)
			polyline = arcpy.Polyline(array)
			cursor.insertRow([row.OBJECTID,str(j),polyline])
			array.removeAll()
			# featureList.append(polyline)
# arcpy.CopyFeatures_management(featureList,perpendicular_lines_dir)

# Stop editing and delete cursor
del cursor

# Intersection
inFeatures = [desc.baseName, out_name]
intersectOutput = "Crossings"
arcpy.Intersect_analysis(inFeatures, intersectOutput, "", "", "point")

# Delete the points features whose field "Gully_ID" and field "Gully_ID_1" are different

fc=desc.path+'/'+intersectOutput
fields=("Gully_ID", "Gully_ID_1")
with arcpy.da.UpdateCursor(fc, fields) as cursor:
	 for row in cursor:
	 	if row[0]!=row[1]:
	 		cursor.deleteRow()
del cursor
#The margin of Gully whether provides correct points pair for each point extracted from corresponding gully

in_table = desc.path+'/'+intersectOutput
out_view1= "Count_Margin_Pts_View"
out_view2= "Count_Gully_Pts_View"
for j in Gully_ID_list:
	arcpy.MakeTableView_management(in_table,out_view1, field + " = " + str(j))
	result1 = arcpy.GetCount_management(out_view1)
	count1 = float(result1.getOutput(0))

	arcpy.MakeTableView_management(GullyPointsDir,out_view2, field + " = " + str(j))
	result2 = arcpy.GetCount_management(out_view2)
	count2 = float(result2.getOutput(0))
	
	if (count1/2) != count2:
		arcpy.AddMessage("# of points pair is " + str(count1/2))
		arcpy.AddMessage("# of points extracted from this gully is " + str(count2))
		Notification="The margin of Gully whose ID is " + str(j) + " doesn't provide correct points pair for each point extracted from corresponding gully"
		arcpy.AddMessage(Notification)
		arcpy.AddMessage("Please EDIT the corresponding margin polyline feature")
		# Remove that Gully ID from the list
		Gully_ID_list.remove(j)
		# Remove the Gully Margin points with problems
		arcpy.DeleteRows_management(out_view1)

#Convert a multipoint feature class into a point feature class
fc_point=fc+'_point'
arcpy.FeatureToPoint_management(fc, fc_point)

## Extract Points With Elevation with the raster data ######

ExtractValuesToPoints(fc_point, DEMRasterDir,
                      GullyMarginPointsDir,"",
                      "VALUE_ONLY")

## Add fields
arcpy.AddField_management(GullyPointsDir,"Width","DOUBLE")
arcpy.AddField_management(GullyPointsDir,"Depth","DOUBLE")


#Calculation

Point_OBJECTID_list=[row[0] for row in arcpy.da.SearchCursor(GullyMarginPointsDir,("Point_OBJECTID"))]

# Calculate Width and Depth and update 

out_view="points_pair"
# field4='X;Y;RASTERVALU'
# field4='RASTERVALU'
field4=["SHAPE@X","SHAPE@Y","RASTERVALU"]
# arcpy.AddMessage(arcpy.ListFields(GullyMarginPointsDir))

field5=["Width","Depth"]
for k in Point_OBJECTID_list:
	# Check the points pair
	arcpy.MakeTableView_management(GullyMarginPointsDir,out_view, "Point_OBJECTID" + " = " + str(k))
	result = arcpy.GetCount_management(out_view)
	count = int(result.getOutput(0))
	if count!=2:
		arcpy.AddMessage("Wrong Points Pair")
		break
	else:
		expression = arcpy.AddFieldDelimiters(GullyMarginPointsDir,"Point_OBJECTID" + " = " + str(k))
		xyz_list=[]
		for row in arcpy.da.SearchCursor(GullyMarginPointsDir, field4 ,where_clause=expression):
			# arcpy.AddMessage("wow")
			# arcpy.AddMessage(row[0])
			xyz_list.append([row[0],row[1],row[2]])
		Width=math.sqrt(math.pow((xyz_list[0][0]-xyz_list[1][0]),2)+math.pow((xyz_list[0][1]-xyz_list[1][1]),2))
		# Read Data from Gully Polygon
		expression = arcpy.AddFieldDelimiters(GullyMarginPointsDir,"OBJECTID" + " = " + str(k))		
		onlyrow=[row for row in arcpy.da.SearchCursor(GullyPointsDir,field4,where_clause=expression)]
		# arcpy.AddMessage(onlyrow)
		# arcpy.AddMessage("xyz_list")
		# arcpy.AddMessage(xyz_list)
		vector3D=[(xyz_list[0][0]-xyz_list[1][0]),(xyz_list[0][1]-xyz_list[1][1]),(xyz_list[0][2]-xyz_list[1][2])]
		Height1=(onlyrow[0][0]-xyz_list[0][0])/vector3D[0]*vector3D[2]+xyz_list[0][2]
		Height2=(onlyrow[0][1]-xyz_list[0][1])/vector3D[1]*vector3D[2]+xyz_list[0][2]
		# arcpy.AddMessage(str(Height1)+"AND"+str(Height2))
		if math.fabs((Height1 - Height2)>=0.001):
			arcpy.AddMessage("Point_OBJECTID"+str(k)+"may be not accurate")
		Depth=(Height1+Height2)/2-onlyrow[0][2]
		expression = arcpy.AddFieldDelimiters(GullyPointsDir ,"OBJECTID" + " = " + str(k))		
		with arcpy.da.UpdateCursor(GullyPointsDir ,field5,where_clause=expression) as cursor:
			for onlyupdaterow in cursor:
				# arcpy.AddMessage(onlyupdaterow)					
				onlyupdaterow[0]=Width*(0.3048) # convert feet to meters
				onlyupdaterow[1]=Depth
				# arcpy.AddMessage(onlyupdaterow)
				cursor.updateRow(onlyupdaterow) 

# Create gully polygon objects and calculate its area then update it
# for j in Gully_ID_list:
# 	expression = arcpy.AddFieldDelimiters(GullyPointsDir, field) + " = " + str(j)
# 	rows = arcpy.SearchCursor(GullyPointsDir,where_clause=expression, fields=field3)


dgsdg