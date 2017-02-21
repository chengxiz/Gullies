Attribute VB_Name = "Module8"
Function CopyMultiPt(wshS As Worksheet, gullyNum As Integer, suffix As String)
    ' Copy 2pts,3pts,5pts Part
    Dim startRowNum As Integer
    startRowNum = 1
    Dim rangeNameArray() As String
    ReDim rangeNameArray(0 To gullyNum)
    For i = 1 To gullyNum
        rowNam = Application.WorksheetFunction.CountIf(wshS.range("D:D"), CStr(i))
        Gully = "G"
        Dim rangeName As String
        rangeName = Gully & CStr(i) & suffix
        endRowNum = startRowNum + rowNam
        R = "A" & (startRowNum + 1) & ":D" & endRowNum
        wshS.range(R).name = rangeName
        rangeNameArray(i) = rangeName
        startRowNum = endRowNum
    Next i
    CopyMultiPt = rangeNameArray
End Function
