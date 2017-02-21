Attribute VB_Name = "Module5"
Function CopyAllPt(wshS As Worksheet, gullyNum As Integer, suffix As String)
    ' Copy ALLpts Part
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
        R = "A" & (startRowNum + 1) & ":G" & endRowNum
        wshS.range(R).name = rangeName
        rangeNameArray(i) = rangeName
        ' Msgox RangeName
        startRowNum = endRowNum
    Next i
    CopyAllPt = rangeNameArray
End Function
