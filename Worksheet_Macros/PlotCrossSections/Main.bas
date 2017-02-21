Sub Main()
    ' For the sake of meomory
    Application.ScreenUpdating = False
    Application.EnableEvents = False
    Dim ws As Worksheet
    Set ws = InputAndSort("H:\Results 2015\Area3\CrossSections\Area3CrossSections.csv", "PlotCrossSections.xlsm")
    Dim i As Integer
    For i = 1 To 3
        PlotMultiSeries ws, i
    Next i
    ' For the sake of meomory
    Application.ScreenUpdating = True
    Application.EnableEvents = True
End Sub
 
