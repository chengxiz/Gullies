import arcpy
PointsDir=arcpy.GetParameterAsText(0)

arcpy.AddField_management(PointsDir, "LOCATION_X", "DOUBLE", "", "", "", "", "NULLABLE")
arcpy.AddField_management(PointsDir, "LOCATION_Y", "DOUBLE", "", "", "", "", "NULLABLE")
Points=arcpy.CopyFeatures_management(PointsDir,arcpy.Geometry())
PointsStats=[]
for point in Points:
	Point_X=point.labelPoint.X
	Point_Y=point.labelPoint.Y
	PointsStats.append([Point_X,Point_Y])

cursor = arcpy.UpdateCursor(PointsDir)
j=0
for row in cursor:
	row.setValue("LOCATION_X",PointsStats[j][0])
	row.setValue("LOCATION_Y",PointsStats[j][1])
	cursor.updateRow(row)
	j=j+1