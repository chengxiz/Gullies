import arcpy
PolylineDir=arcpy.GetParameterAsText(0)
NUM=int(arcpy.GetParameterAsText(1))
PointsDir=arcpy.GetParameterAsText(2)
points = []
GullyIDList=[] 
for row in arcpy.da.SearchCursor(PolylineDir, ["SHAPE@"]): # change this to your source line layer
    length = int(row[0].length)
    j=0
    for i in xrange(0, length + NUM, NUM): # assuming units are in meters for feature spatial reference
        point = row[0].positionAlongLine(i)
        points.append(point)
        j=j+1
    GullyIDList.append(j)
arcpy.CopyFeatures_management(points, PointsDir)

k=0
for row in arcpy.da.SearchCursor(PolylineDir, ["ID"]): # [NumOfPoints,GullyID]
    GullyIDList[k]=[GullyIDList[k],row[0]]
    k=k+1
arcpy.AddField_management(PointsDir, "Gully_ID", "LONG", 3, "", "", "", "NULLABLE")
cursor = arcpy.UpdateCursor(PointsDir)
#the ID of points
k1=0
#the ID of the gully points belong to
k2=0
k=GullyIDList[k2][0]
arcpy.AddMessage(GullyIDList)
for row in cursor:
	k1=k1+1
	if k1>k:
		#update k2, the gully ID
		k2=k2+1
		#update k
		k=GullyIDList[k2][0]+k
	row.setValue("Gully_ID", GullyIDList[k2][1])
	cursor.updateRow(row)


