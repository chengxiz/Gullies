import arcpy
from arcpy.sa import *
InputPointsDir=arcpy.GetParameterAsText(0)
Raster=arcpy.GetParameterAsText(1)
OutputPointsDir=arcpy.GetParameterAsText(2)
ExtractValuesToPoints(InputPointsDir, Raster,
                      OutputPointsDir,"",
                      "VALUE_ONLY")
