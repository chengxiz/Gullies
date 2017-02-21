Attribute VB_Name = "Module7"
Sub PasteAndAddColNameMultiPt(name As String, range_name As String, original_sheet As Worksheet, wbk As Workbook, npts As Integer)
    Set ws = wbk.Sheets(name)
    ws.Activate
    original_sheet.range(range_name).Copy
    
    Dim lRow As Long
    ' Find the last non-blank cell in column A(1)
    lRow = Cells(Rows.Count, 1).End(xlUp).Row
    Debug.Print lRow
    
    ws.range("A" & CStr(lRow + 2)).Value = "Slope with " & CStr(npts) & "Pts"
    ws.range("A" & CStr(lRow + 4)).Select
    ws.Paste
    range("B" & CStr(lRow + 3)).Value = "Distance(m)"
    range("C" & CStr(lRow + 3)).Value = "Slope(m)"
    range("D" & CStr(lRow + 3)).Value = "GID"
   
End Sub
