import arcpy
import math
# Run the CopyFeatures tool, setting the output to the geometry object.
# geometries is returned as a list of geometry objects.
GulliesDir=arcpy.GetParameterAsText(0)

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
	gullystats.append([Sinuosity,Start_Point_X,Start_Point_Y,End_Point_X,End_Point_Y,Mid_Point_X,Mid_Point_Y,ID])

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

fieldName="Orientation"
fieldPrecision=18
fieldScale=11
arcpy.AddField_management(GulliesDir,fieldName,"DOUBLE",fieldPrecision,fieldScale)
arcpy.CalculateField_management(GulliesDir,
	fieldName,
	"90-math.atan((!End_Point_Y! - !Start_Point_Y! )/( !End_Point_X! - !Start_Point_X! ))/math.pi * 180 if ( !End_Point_X! - !Start_Point_X! )>0 else 270-math.atan(( !End_Point_Y! - !Start_Point_Y! )/( !End_Point_X! - !Start_Point_X! ))/math.pi * 180",
	"PYTHON")