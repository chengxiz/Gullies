Attribute VB_Name = "Module1"
Sub Main()
    Dim range2010 As Range, range2015 As Range
    Dim wb As Workbook, ws As Worksheet
    Dim gullyNum As Integer
    gullyNum = 4
    For j = 1 To gullyNum
        Worksheets.Add After:=Worksheets(j)
    Next j
    For i = 1 To gullyNum
        ' Worksheets.Add
        Set range2015 = CopyRange("H:\ResultsAndComparisons\Results2015ForSean\Summary_Area6_2015.xlsx", 5 - i)
        Set range2010 = CopyRange("H:\ResultsAndComparisons\Results2010ForSean\Summary_Area6_2010.xlsx", (i))
        Set wb = Workbooks("comparison.xlsm")
        wb.Activate
        Set ws = wb.Worksheets(i)
        ' ActiveSheet.ChartObjects.Delete
        PlotComparison range2010, range2015, 1, (i), ws
        PlotComparison range2010, range2015, 2, (i), ws
        PlotComparison range2010, range2015, 3, (i), ws
    Next i
End Sub
