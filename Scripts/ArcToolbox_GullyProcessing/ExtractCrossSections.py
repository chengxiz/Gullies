import arcpy
import csv
import re
import os
from arcpy.sa import *

###### STEP0: Import Parameters ######
GullyMarginPtsDir=arcpy.GetParameterAsText(0)
LocationListDir=arcpy.GetParameterAsText(1)
NUM=arcpy.GetParameter(2)
RasterDir=arcpy.GetParameterAsText(3)
OutputPointsDir=arcpy.GetParameterAsText(4)

###### STEP1: Read Data ######
LocationList=[]
with open(LocationListDir) as csvfile:
    readCSV = csv.reader(csvfile, delimiter=',')
    for k in readCSV:
        LocationList.append(k)

# arcpy.AddMessage(LocationList)
FilterList=dict()
for i in LocationList[1:]:
	FilterList[int(i[1])]=[i[0],i[2]]
# arcpy.AddMessage(FilterList)
# arcpy.AddMessage(FilterList.keys())
# GullyMarginPts = arcpy.CopyFeatures_management(GullyMarginPtsDir,arcpy.Geometry())

arcpy.AddMessage("Success of STEP1: Read Data")


###### STEP2: Add perpendicular lines to intersect with margins  ######
desc = arcpy.Describe(GullyMarginPtsDir)
shapefieldname = desc.ShapeFieldName
# Set local variables
out_path = desc.path
out_name = desc.baseName + "_3_perpendicular_lines"
geometry_type = "POLYLINE"
template = []
has_m = "DISABLED"
has_z = "DISABLED"
spatial_reference = desc.spatialReference
#Set overwrite option
arcpy.workspace = out_path
arcpy.overwriteOutput = True
arcpy.CreateFeatureclass_management(out_path, out_name, geometry_type, template, has_m, has_z, spatial_reference)

perpendicular_lines_dir=out_path+'/'+out_name

arcpy.AddField_management(perpendicular_lines_dir,"Position","Double")
arcpy.AddField_management(perpendicular_lines_dir,"Gully_ID","Short")

# Open an InsertCursor and insert the new geometry
cursor = arcpy.da.InsertCursor(perpendicular_lines_dir, ['Position','Gully_ID','SHAPE@'])

arcpy.AddMessage("Success of STEP2: Add Polylines")

###### STEP3: Draw Polylines ######
for i in FilterList.keys():
	# Filter Points with specific Point_OBJECTID
	Expression= arcpy.AddFieldDelimiters(GullyMarginPtsDir, "Point_OBJECTID") + " = " + str(i)
	arcpy.AddMessage(Expression)
	rows = arcpy.SearchCursor(GullyMarginPtsDir,where_clause=Expression)
	array = arcpy.Array()
	for row in rows:
		feat = row.getValue(shapefieldname)
		pnt = feat.getPart()
		arcpy.AddMessage(pnt)
		Point = arcpy.Point()
		Point.X=pnt.X
		Point.Y=pnt.Y
		array.add(Point)
	arcpy.AddMessage(row.Side)
	# Here the variable 'row' belongs to the second point
	# The second point is on the left side, 
	# which means we have to reverse the order to make the first point in array is the left one
	if row.Side=="L":
		array_re=arcpy.Array()
		array_re.add(array.getObject(1))
		array_re.add(array.getObject(0))
		arcpy.AddMessage("REVERSE")
		polyline = arcpy.Polyline(array_re)
	else:
		arcpy.AddMessage(array)
		polyline = arcpy.Polyline(array)
	cursor.insertRow([FilterList[row.Point_OBJECTID][1],FilterList[row.Point_OBJECTID][0],polyline])
	array.removeAll()
arcpy.AddMessage("Success of STEP3: Draw Polylines")

###### STEP4: Stop Editing ######
del cursor
arcpy.AddMessage("Success of STEP4: Stop Editing")

###### STEP5: Add Points ALong Cross-Sections ######
# desc = arcpy.Describe(PtsDir)
# shapefieldname = desc.ShapeFieldName
# Set local variables
out_path = desc.path
out_name = desc.baseName+"CrossSectionPts"
geometry_type = "POINT"
template = []
has_m = "DISABLED"
has_z = "DISABLED"
spatial_reference = desc.spatialReference
#Set overwrite option
arcpy.workspace = out_path
arcpy.overwriteOutput = True
arcpy.CreateFeatureclass_management(out_path, out_name, geometry_type, template, has_m, has_z, spatial_reference)
PtsDir=out_path+'/'+out_name
#Add fields
arcpy.AddField_management(PtsDir,"Position","Double")
arcpy.AddField_management(PtsDir,"Gully_ID","Short")
arcpy.AddField_management(PtsDir,"LOCATION_X","Double")
arcpy.AddField_management(PtsDir,"LOCATION_Y","Double")

cursor_point=arcpy.da.InsertCursor(PtsDir, ['Position','Gully_ID','LOCATION_X','LOCATION_Y','SHAPE@'])
arcpy.AddMessage("WTF")

for row in arcpy.da.SearchCursor(perpendicular_lines_dir, ["SHAPE@","Gully_ID","Position"]):
	arcpy.AddMessage("WTF")
	length = int(row[0].length)
	arcpy.AddMessage(length)
	arcpy.AddMessage(NUM)
	for i in xrange(0, length + NUM, NUM):
		point = row[0].positionAlongLine(i)
		cursor_point.insertRow([row[2],row[1],point.centroid.X,point.centroid.Y,point])
arcpy.AddMessage("Success of STEP5: Add Points ALong Cross-Sections")

###### STEP6: Stop Editing ######
del cursor_point

###### STEP7: Extract Elevation ALong Cross-Sections ######
ExtractValuesToPoints(PtsDir, RasterDir,
                      OutputPointsDir,"",
                      "VALUE_ONLY")
arcpy.AddMessage("Success of STEP7: Extract Elevation ALong Cross-Sections")

