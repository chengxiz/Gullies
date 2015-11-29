import arcpy
import math
import os
from arcpy.sa import *

###### STEP0: Import Parameters ######

#Set variables from parameters
GulliesDir=arcpy.GetParameterAsText(0)
NUM=arcpy.GetParameter(1)
Raster=arcpy.GetParameterAsText(2)
OutputPointsDir=arcpy.GetParameterAsText(3)
# Set temp points data
PointsDir=os.path.dirname(GulliesDir)+"\\temp"
points = []
GullyIDList=[] 
arcpy.AddMessage("Success of STEP0: Import Parameters")
###### STEP1: Update Gullies Data ######


# Run the CopyFeatures tool, setting the output to the geometry object.
# geometries is returned as a list of geometry objects.
Gullies = arcpy.CopyFeatures_management(GulliesDir,arcpy.Geometry())
gullystats=[]
I=0
for gully in Gullies:
    Start_Point_X=gully.firstPoint.X
    Start_Point_Y=gully.firstPoint.Y
    Mid_Point_X=gully.centroid.X
    Mid_Point_Y=gully.centroid.Y
    End_Point_X=gully.lastPoint.X
    End_Point_Y=gully.lastPoint.Y
    EucliDis=math.sqrt((Start_Point_X - End_Point_X)**2 + (Start_Point_Y - End_Point_Y)**2)
    Sinuosity=gully.length/EucliDis
    I=I+1
    ID=I
    gullystats.append(
        [Sinuosity,
        Start_Point_X,Start_Point_Y,
        End_Point_X,End_Point_Y,
        Mid_Point_X,Mid_Point_Y,
        ID]
        )
cursor = arcpy.UpdateCursor(GulliesDir)
i=0
for row in cursor:
    row.setValue("Sinuosity",gullystats[i][0])
    row.setValue("Start_Point_X",gullystats[i][1])
    row.setValue("Start_Point_Y",gullystats[i][2])
    row.setValue("End_Point_X",gullystats[i][3])
    row.setValue("End_Point_Y",gullystats[i][4])
    row.setValue("Mid_Point_X",gullystats[i][5])
    row.setValue("Mid_Point_Y",gullystats[i][6])
    row.setValue("ID",gullystats[i][7])
    cursor.updateRow(row)
    i=i+1
arcpy.AddMessage("Success of STEP1: Update Gullies Data")

###### STEP2: Add Points ALong Gullies ######

for row in arcpy.da.SearchCursor(GulliesDir, ["SHAPE@"]): # change this to your source line layer
    length = int(row[0].length)
    j=0
    for i in xrange(0, length + NUM, NUM): # assuming units are in feet for feature spatial reference
        point = row[0].positionAlongLine(i)
        points.append(point)
        j=j+1
    GullyIDList.append(j)
arcpy.CopyFeatures_management(points, PointsDir)
arcpy.AddMessage("Success of STEP2: Add Points ALong Gullies")

###### STEP3: Update Points Data ######

# Set Gully_ID
k=0
for row in arcpy.da.SearchCursor(GulliesDir, ["ID"]): # [NumOfPoints,GullyID]
    GullyIDList[k]=[GullyIDList[k],row[0]]
    k=k+1
arcpy.AddField_management(PointsDir, "Gully_ID", "LONG", 3, "", "", "", "NULLABLE")
cursor = arcpy.UpdateCursor(PointsDir)
#the ID of points
k1=0
# The ID of the gully points belong to
k2=0
k=GullyIDList[k2][0]
# Update Gully_ID
for row in cursor:
	k1=k1+1
	if k1>k:
		#update k2, the gully ID
		k2=k2+1
		#update k
		k=GullyIDList[k2][0]+k
	row.setValue("Gully_ID", GullyIDList[k2][1])
	cursor.updateRow(row)
# Set Location X and Location Y
arcpy.AddField_management(PointsDir, "LOCATION_X", "DOUBLE", "", "", "", "", "NULLABLE")
arcpy.AddField_management(PointsDir, "LOCATION_Y", "DOUBLE", "", "", "", "", "NULLABLE")
Points=arcpy.CopyFeatures_management(PointsDir,arcpy.Geometry())
PointsStats=[]
for point in Points:
    Point_X=point.labelPoint.X
    Point_Y=point.labelPoint.Y
    PointsStats.append([Point_X,Point_Y])
# Update Location X and Location Y
cursor = arcpy.UpdateCursor(PointsDir)
j=0
for row in cursor:
    row.setValue("LOCATION_X",PointsStats[j][0])
    row.setValue("LOCATION_Y",PointsStats[j][1])
    cursor.updateRow(row)
    j=j+1
arcpy.AddMessage("Success of STEP3: Update Points Data")

###### STEP4: Extract Points With Elevation with the raster data ######

ExtractValuesToPoints(PointsDir, Raster,
                      OutputPointsDir,"",
                      "VALUE_ONLY")
arcpy.AddMessage("Success of STEP4: Extract Points With Elevation with the raster data")

###### STEP5: Delete temp data ######
arcpy.Delete_management(PointsDir)
arcpy.AddMessage("Success of STEP5: Delete temp data")

arcpy.AddMessage("Succeed!")

