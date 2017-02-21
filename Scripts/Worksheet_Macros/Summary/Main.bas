Attribute VB_Name = "Module2"
Sub Main()
    ' the CSV file needs to be copyed
    Dim wbkS1 As Workbook
    Dim wshS1 As Worksheet
    Dim wbkS2 As Workbook
    Dim wshS2 As Worksheet
    Dim wbkS3 As Workbook
    Dim wshS3 As Worksheet
    Dim wbkS4 As Workbook
    Dim wshS4 As Worksheet
    ' the CSV file needs to be pasted
    Dim wb As Workbook
    Dim ws As Worksheet
    
    ' Clear the object Excel file to make sure there are no extra sheets
    ClearAllExceptOne "Summary.xlsm"
    
    ' ' ' ' File 1
    ' Determine the CSV file needs to be copyed
    Const strFileName1 = "H:\Results 2015\OnSite\pALL.csv"
    Set wbkS1 = Workbooks.Open(Filename:=strFileName1)
    Set wshS1 = wbkS1.Worksheets(1)
   
    ' Copy the CSV file with the return of an array of Range Names
    arrayRangeNameAll = CopyAllPt(wshS1, 14, "WithALL")

    ' ' ' ' File 2
    ' Determine the CSV file needs to be copyed
    Const strFileName2 = "H:\Results 2015\OnSite\p2Pts.csv"
    Set wbkS2 = Workbooks.Open(Filename:=strFileName2)
    Set wshS2 = wbkS2.Worksheets(1)
   
    ' Copy the CSV file with the return of an array of Range Names
    arrayRangeName2Pts = CopyMultiPt(wshS2, 14, "With2Pts")
    
    ' ' ' ' File 3
    ' Determine the CSV file needs to be copyed
    Const strFileName3 = "H:\Results 2015\OnSite\p3Pts.csv"
    Set wbkS3 = Workbooks.Open(Filename:=strFileName3)
    Set wshS3 = wbkS3.Worksheets(1)
   
    ' Copy the CSV file with the return of an array of Range Names
    arrayRangeName3Pts = CopyMultiPt(wshS3, 14, "With3Pts")

    ' ' ' ' File 4
    ' Determine the CSV file needs to be copyed
    Const strFileName4 = "H:\Results 2015\OnSite\p5Pts.csv"
    Set wbkS4 = Workbooks.Open(Filename:=strFileName4)
    Set wshS4 = wbkS4.Worksheets(1)
   
    ' Copy the CSV file with the return of an array of Range Names
    arrayRangeName5Pts = CopyMultiPt(wshS4, 14, "With5Pts")
    
    ' Determine the excel file needs to be pasted
    Set wb = Workbooks("Summary.xlsm")
    wb.Activate
    
    
    ' Add Worksheets
    AddNewWorksheet "1(NP-1) Gully"
    AddNewWorksheet "2(NP-3) Gully"
    AddNewWorksheet "3(NP-2) Gully"
    AddNewWorksheet "4 Gully"
    AddNewWorksheet "5 Gully"
    AddNewWorksheet "6 Gully"
    AddNewWorksheet "7 Gully"
    AddNewWorksheet "8 Gully"
    AddNewWorksheet "9(EQ-1) Gully"
    AddNewWorksheet "10 Gully"
    AddNewWorksheet "11 Gully"
    AddNewWorksheet "12 Gully"
    AddNewWorksheet "13 Gully"
    AddNewWorksheet "14 Gully"
    
    ' Debug.Print TypeName(arrayRangeNameAll(1))
    
    ' Input Basic Gully Information
    BasicInfo "1(NP-1) Gully", wb
    BasicInfo "2(NP-3) Gully", wb
    BasicInfo "3(NP-2) Gully", wb
    BasicInfo "4 Gully", wb
    BasicInfo "5 Gully", wb
    BasicInfo "6 Gully", wb
    BasicInfo "7 Gully", wb
    BasicInfo "8 Gully", wb
    BasicInfo "9(EQ-1) Gully", wb
    BasicInfo "10 Gully", wb
    BasicInfo "11 Gully", wb
    BasicInfo "12 Gully", wb
    BasicInfo "13 Gully", wb
    BasicInfo "14 Gully", wb
    ' Paste ranges from File 1
    PasteAndAddColNameAllPt "1(NP-1) Gully", (arrayRangeNameAll(1)), wshS1, wb
    PasteAndAddColNameAllPt "2(NP-3) Gully", (arrayRangeNameAll(2)), wshS1, wb
    PasteAndAddColNameAllPt "3(NP-2) Gully", (arrayRangeNameAll(3)), wshS1, wb
    PasteAndAddColNameAllPt "4 Gully", (arrayRangeNameAll(4)), wshS1, wb
    PasteAndAddColNameAllPt "5 Gully", (arrayRangeNameAll(5)), wshS1, wb
    PasteAndAddColNameAllPt "6 Gully", (arrayRangeNameAll(6)), wshS1, wb
    PasteAndAddColNameAllPt "7 Gully", (arrayRangeNameAll(7)), wshS1, wb
    PasteAndAddColNameAllPt "8 Gully", (arrayRangeNameAll(8)), wshS1, wb
    PasteAndAddColNameAllPt "9(EQ-1) Gully", (arrayRangeNameAll(9)), wshS1, wb
    PasteAndAddColNameAllPt "10 Gully", (arrayRangeNameAll(10)), wshS1, wb
    PasteAndAddColNameAllPt "11 Gully", (arrayRangeNameAll(11)), wshS1, wb
    PasteAndAddColNameAllPt "12 Gully", (arrayRangeNameAll(12)), wshS1, wb
    PasteAndAddColNameAllPt "13 Gully", (arrayRangeNameAll(13)), wshS1, wb
    PasteAndAddColNameAllPt "14 Gully", (arrayRangeNameAll(14)), wshS1, wb

    ' chart
    CreatingChart "1(NP-1) Gully", (arrayRangeNameAll(1)), wshS1, wb, 2, 5, "J6", "AbsoluteElevation"
    CreatingChart "1(NP-1) Gully", (arrayRangeNameAll(1)), wshS1, wb, 2, 6, "J22", "Width"
    CreatingChart "1(NP-1) Gully", (arrayRangeNameAll(1)), wshS1, wb, 2, 7, "J38", "Depth"
    CreatingChart "2(NP-3) Gully", (arrayRangeNameAll(2)), wshS1, wb, 2, 5, "J6", "AbsoluteElevation"
    CreatingChart "2(NP-3) Gully", (arrayRangeNameAll(2)), wshS1, wb, 2, 6, "J22", "Width"
    CreatingChart "2(NP-3) Gully", (arrayRangeNameAll(2)), wshS1, wb, 2, 7, "J38", "Depth"
    CreatingChart "3(NP-2) Gully", (arrayRangeNameAll(3)), wshS1, wb, 2, 5, "J6", "AbsoluteElevation"
    CreatingChart "3(NP-2) Gully", (arrayRangeNameAll(3)), wshS1, wb, 2, 6, "J22", "Width"
    CreatingChart "3(NP-2) Gully", (arrayRangeNameAll(3)), wshS1, wb, 2, 7, "J38", "Depth"
    CreatingChart "4 Gully", (arrayRangeNameAll(4)), wshS1, wb, 2, 5, "J6", "AbsoluteElevation"
    CreatingChart "4 Gully", (arrayRangeNameAll(4)), wshS1, wb, 2, 6, "J22", "Width"
    CreatingChart "4 Gully", (arrayRangeNameAll(4)), wshS1, wb, 2, 7, "J38", "Depth"
    CreatingChart "5 Gully", (arrayRangeNameAll(5)), wshS1, wb, 2, 5, "J6", "AbsoluteElevation"
    CreatingChart "5 Gully", (arrayRangeNameAll(5)), wshS1, wb, 2, 6, "J22", "Width"
    CreatingChart "5 Gully", (arrayRangeNameAll(5)), wshS1, wb, 2, 7, "J38", "Depth"
    CreatingChart "6 Gully", (arrayRangeNameAll(6)), wshS1, wb, 2, 5, "J6", "AbsoluteElevation"
    CreatingChart "6 Gully", (arrayRangeNameAll(6)), wshS1, wb, 2, 6, "J22", "Width"
    CreatingChart "6 Gully", (arrayRangeNameAll(6)), wshS1, wb, 2, 7, "J38", "Depth"
    CreatingChart "7 Gully", (arrayRangeNameAll(7)), wshS1, wb, 2, 5, "J6", "AbsoluteElevation"
    CreatingChart "7 Gully", (arrayRangeNameAll(7)), wshS1, wb, 2, 6, "J22", "Width"
    CreatingChart "7 Gully", (arrayRangeNameAll(7)), wshS1, wb, 2, 7, "J38", "Depth"
    CreatingChart "8 Gully", (arrayRangeNameAll(8)), wshS1, wb, 2, 5, "J6", "AbsoluteElevation"
    CreatingChart "8 Gully", (arrayRangeNameAll(8)), wshS1, wb, 2, 6, "J22", "Width"
    CreatingChart "8 Gully", (arrayRangeNameAll(8)), wshS1, wb, 2, 7, "J38", "Depth"
    CreatingChart "9(EQ-1) Gully", (arrayRangeNameAll(9)), wshS1, wb, 2, 5, "J6", "AbsoluteElevation"
    CreatingChart "9(EQ-1) Gully", (arrayRangeNameAll(9)), wshS1, wb, 2, 6, "J22", "Width"
    CreatingChart "9(EQ-1) Gully", (arrayRangeNameAll(9)), wshS1, wb, 2, 7, "J38", "Depth"
    CreatingChart "10 Gully", (arrayRangeNameAll(10)), wshS1, wb, 2, 5, "J6", "AbsoluteElevation"
    CreatingChart "10 Gully", (arrayRangeNameAll(10)), wshS1, wb, 2, 6, "J22", "Width"
    CreatingChart "10 Gully", (arrayRangeNameAll(10)), wshS1, wb, 2, 7, "J38", "Depth"
    CreatingChart "11 Gully", (arrayRangeNameAll(11)), wshS1, wb, 2, 5, "J6", "AbsoluteElevation"
    CreatingChart "11 Gully", (arrayRangeNameAll(11)), wshS1, wb, 2, 6, "J22", "Width"
    CreatingChart "11 Gully", (arrayRangeNameAll(11)), wshS1, wb, 2, 7, "J38", "Depth"
    CreatingChart "12 Gully", (arrayRangeNameAll(12)), wshS1, wb, 2, 5, "J6", "AbsoluteElevation"
    CreatingChart "12 Gully", (arrayRangeNameAll(12)), wshS1, wb, 2, 6, "J22", "Width"
    CreatingChart "12 Gully", (arrayRangeNameAll(12)), wshS1, wb, 2, 7, "J38", "Depth"
    CreatingChart "13 Gully", (arrayRangeNameAll(13)), wshS1, wb, 2, 5, "J6", "AbsoluteElevation"
    CreatingChart "13 Gully", (arrayRangeNameAll(13)), wshS1, wb, 2, 6, "J22", "Width"
    CreatingChart "13 Gully", (arrayRangeNameAll(13)), wshS1, wb, 2, 7, "J38", "Depth"
    CreatingChart "14 Gully", (arrayRangeNameAll(14)), wshS1, wb, 2, 5, "J6", "AbsoluteElevation"
    CreatingChart "14 Gully", (arrayRangeNameAll(14)), wshS1, wb, 2, 6, "J22", "Width"
    CreatingChart "14 Gully", (arrayRangeNameAll(14)), wshS1, wb, 2, 7, "J38", "Depth"

      ' Paste ranges from File 2
    PasteAndAddColNameMultiPt "1(NP-1) Gully", (arrayRangeName2Pts(1)), wshS2, wb, 2
    PasteAndAddColNameMultiPt "2(NP-3) Gully", (arrayRangeName2Pts(2)), wshS2, wb, 2
    PasteAndAddColNameMultiPt "3(NP-2) Gully", (arrayRangeName2Pts(3)), wshS2, wb, 2
    PasteAndAddColNameMultiPt "4 Gully", (arrayRangeName2Pts(4)), wshS2, wb, 2
    PasteAndAddColNameMultiPt "5 Gully", (arrayRangeName2Pts(5)), wshS2, wb, 2
    PasteAndAddColNameMultiPt "6 Gully", (arrayRangeName2Pts(6)), wshS2, wb, 2
    PasteAndAddColNameMultiPt "7 Gully", (arrayRangeName2Pts(7)), wshS2, wb, 2
    PasteAndAddColNameMultiPt "8 Gully", (arrayRangeName2Pts(8)), wshS2, wb, 2
    PasteAndAddColNameMultiPt "9(EQ-1) Gully", (arrayRangeName2Pts(9)), wshS2, wb, 2
    PasteAndAddColNameMultiPt "10 Gully", (arrayRangeName2Pts(10)), wshS2, wb, 2
    PasteAndAddColNameMultiPt "11 Gully", (arrayRangeName2Pts(11)), wshS2, wb, 2
    PasteAndAddColNameMultiPt "12 Gully", (arrayRangeName2Pts(12)), wshS2, wb, 2
    PasteAndAddColNameMultiPt "13 Gully", (arrayRangeName2Pts(13)), wshS2, wb, 2
    PasteAndAddColNameMultiPt "14 Gully", (arrayRangeName2Pts(14)), wshS2, wb, 2

      ' Paste ranges from File 3
    PasteAndAddColNameMultiPt "1(NP-1) Gully", (arrayRangeName3Pts(1)), wshS3, wb, 3
    PasteAndAddColNameMultiPt "2(NP-3) Gully", (arrayRangeName3Pts(2)), wshS3, wb, 3
    PasteAndAddColNameMultiPt "3(NP-2) Gully", (arrayRangeName3Pts(3)), wshS3, wb, 3
    PasteAndAddColNameMultiPt "4 Gully", (arrayRangeName3Pts(4)), wshS3, wb, 3
    PasteAndAddColNameMultiPt "5 Gully", (arrayRangeName3Pts(5)), wshS3, wb, 3
    PasteAndAddColNameMultiPt "6 Gully", (arrayRangeName3Pts(6)), wshS3, wb, 3
    PasteAndAddColNameMultiPt "7 Gully", (arrayRangeName3Pts(7)), wshS3, wb, 3
    PasteAndAddColNameMultiPt "8 Gully", (arrayRangeName3Pts(8)), wshS3, wb, 3
    PasteAndAddColNameMultiPt "9(EQ-1) Gully", (arrayRangeName3Pts(9)), wshS3, wb, 3
    PasteAndAddColNameMultiPt "10 Gully", (arrayRangeName3Pts(10)), wshS3, wb, 3
    PasteAndAddColNameMultiPt "11 Gully", (arrayRangeName3Pts(11)), wshS3, wb, 3
    PasteAndAddColNameMultiPt "12 Gully", (arrayRangeName3Pts(12)), wshS3, wb, 3
    PasteAndAddColNameMultiPt "13 Gully", (arrayRangeName3Pts(13)), wshS3, wb, 3
    PasteAndAddColNameMultiPt "14 Gully", (arrayRangeName3Pts(14)), wshS3, wb, 3

    ' Paste ranges from File 4
    PasteAndAddColNameMultiPt "1(NP-1) Gully", (arrayRangeName5Pts(1)), wshS4, wb, 5
    PasteAndAddColNameMultiPt "2(NP-3) Gully", (arrayRangeName5Pts(2)), wshS4, wb, 5
    PasteAndAddColNameMultiPt "3(NP-2) Gully", (arrayRangeName5Pts(3)), wshS4, wb, 5
    PasteAndAddColNameMultiPt "4 Gully", (arrayRangeName5Pts(4)), wshS4, wb, 5
    PasteAndAddColNameMultiPt "5 Gully", (arrayRangeName5Pts(5)), wshS4, wb, 5
    PasteAndAddColNameMultiPt "6 Gully", (arrayRangeName5Pts(6)), wshS4, wb, 5
    PasteAndAddColNameMultiPt "7 Gully", (arrayRangeName5Pts(7)), wshS4, wb, 5
    PasteAndAddColNameMultiPt "8 Gully", (arrayRangeName5Pts(8)), wshS4, wb, 5
    PasteAndAddColNameMultiPt "9(EQ-1) Gully", (arrayRangeName5Pts(9)), wshS4, wb, 5
    PasteAndAddColNameMultiPt "10 Gully", (arrayRangeName5Pts(10)), wshS4, wb, 5
    PasteAndAddColNameMultiPt "11 Gully", (arrayRangeName5Pts(11)), wshS4, wb, 5
    PasteAndAddColNameMultiPt "12 Gully", (arrayRangeName5Pts(12)), wshS4, wb, 5
    PasteAndAddColNameMultiPt "13 Gully", (arrayRangeName5Pts(13)), wshS4, wb, 5
    PasteAndAddColNameMultiPt "14 Gully", (arrayRangeName5Pts(14)), wshS4, wb, 5
    
    ' Paste comparison between 3 pts
    CreatingChartMultiSer "1(NP-1) Gully", _
                        (arrayRangeName2Pts(1)), (arrayRangeName3Pts(1)), (arrayRangeName5Pts(1)), _
                        wshS2, wshS3, wshS4, _
                        wb, 2, 3, "J54", _
                        "Slope With 2pts", "Slope With 3pts", "Slope With 5pts"
    CreatingChartMultiSer "2(NP-3) Gully", _
                        (arrayRangeName2Pts(2)), (arrayRangeName3Pts(2)), (arrayRangeName5Pts(2)), _
                        wshS2, wshS3, wshS4, _
                        wb, 2, 3, "J54", _
                        "Slope With 2pts", "Slope With 3pts", "Slope With 5pts"
    CreatingChartMultiSer "3(NP-2) Gully", _
                        (arrayRangeName2Pts(3)), (arrayRangeName3Pts(3)), (arrayRangeName5Pts(3)), _
                        wshS2, wshS3, wshS4, _
                        wb, 2, 3, "J54", _
                        "Slope With 2pts", "Slope With 3pts", "Slope With 5pts"
    CreatingChartMultiSer "4 Gully", _
                        (arrayRangeName2Pts(4)), (arrayRangeName3Pts(4)), (arrayRangeName5Pts(4)), _
                        wshS2, wshS3, wshS4, _
                        wb, 2, 3, "J54", _
                        "Slope With 2pts", "Slope With 3pts", "Slope With 5pts"
    CreatingChartMultiSer "5 Gully", _
                        (arrayRangeName2Pts(5)), (arrayRangeName3Pts(5)), (arrayRangeName5Pts(5)), _
                        wshS2, wshS3, wshS4, _
                        wb, 2, 3, "J54", _
                        "Slope With 2pts", "Slope With 3pts", "Slope With 5pts"
    CreatingChartMultiSer "6 Gully", _
                        (arrayRangeName2Pts(6)), (arrayRangeName3Pts(6)), (arrayRangeName5Pts(6)), _
                        wshS2, wshS3, wshS4, _
                        wb, 2, 3, "J54", _
                        "Slope With 2pts", "Slope With 3pts", "Slope With 5pts"
    CreatingChartMultiSer "7 Gully", _
                        (arrayRangeName2Pts(7)), (arrayRangeName3Pts(7)), (arrayRangeName5Pts(7)), _
                        wshS2, wshS3, wshS4, _
                        wb, 2, 3, "J54", _
                        "Slope With 2pts", "Slope With 3pts", "Slope With 5pts"
    CreatingChartMultiSer "8 Gully", _
                        (arrayRangeName2Pts(8)), (arrayRangeName3Pts(8)), (arrayRangeName5Pts(8)), _
                        wshS2, wshS3, wshS4, _
                        wb, 2, 3, "J54", _
                        "Slope With 2pts", "Slope With 3pts", "Slope With 5pts"
    CreatingChartMultiSer "9(EQ-1) Gully", _
                        (arrayRangeName2Pts(9)), (arrayRangeName3Pts(9)), (arrayRangeName5Pts(9)), _
                        wshS2, wshS3, wshS4, _
                        wb, 2, 3, "J54", _
                        "Slope With 2pts", "Slope With 3pts", "Slope With 5pts"
    CreatingChartMultiSer "10 Gully", _
                        (arrayRangeName2Pts(10)), (arrayRangeName3Pts(10)), (arrayRangeName5Pts(10)), _
                        wshS2, wshS3, wshS4, _
                        wb, 2, 3, "J54", _
                        "Slope With 2pts", "Slope With 3pts", "Slope With 5pts"
    CreatingChartMultiSer "11 Gully", _
                        (arrayRangeName2Pts(11)), (arrayRangeName3Pts(11)), (arrayRangeName5Pts(11)), _
                        wshS2, wshS3, wshS4, _
                        wb, 2, 3, "J54", _
                        "Slope With 2pts", "Slope With 3pts", "Slope With 5pts"
    CreatingChartMultiSer "12 Gully", _
                        (arrayRangeName2Pts(12)), (arrayRangeName3Pts(12)), (arrayRangeName5Pts(12)), _
                        wshS2, wshS3, wshS4, _
                        wb, 2, 3, "J54", _
                        "Slope With 2pts", "Slope With 3pts", "Slope With 5pts"

    CreatingChartMultiSer "13 Gully", _
                        (arrayRangeName2Pts(13)), (arrayRangeName3Pts(13)), (arrayRangeName5Pts(13)), _
                        wshS2, wshS3, wshS4, _
                        wb, 2, 3, "J54", _
                        "Slope With 2pts", "Slope With 3pts", "Slope With 5pts"

    CreatingChartMultiSer "14 Gully", _
                        (arrayRangeName2Pts(14)), (arrayRangeName3Pts(14)), (arrayRangeName5Pts(14)), _
                        wshS2, wshS3, wshS4, _
                        wb, 2, 3, "J54", _
                        "Slope With 2pts", "Slope With 3pts", "Slope With 5pts"
End Sub




