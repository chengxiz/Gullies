Attribute VB_Name = "Module6"
Sub PasteAndAddColNameAllPt(name As String, range_name As String, original_sheet As Worksheet, wbk As Workbook)
    Set ws = wbk.Sheets(name)
    ws.Activate
    original_sheet.range(range_name).Copy
    
    Dim lRow As Long
    ' Find the last non-blank cell in column A(1)
    lRow = Cells(Rows.Count, 1).End(xlUp).Row
    Debug.Print lRow
    
    ws.range("A" & CStr(lRow + 2)).Value = "Elevation , Width, Depth And Distance"
    ws.range("A" & CStr(lRow + 4)).Select
    ws.Paste
    range("B" & CStr(lRow + 3)).Value = "Distance(m)"
    range("C" & CStr(lRow + 3)).Value = "RelativeElevation(m)"
    range("D" & CStr(lRow + 3)).Value = "GID"
    range("E" & CStr(lRow + 3)).Value = "AbsoluteElevation(m)"
    range("F" & CStr(lRow + 3)).Value = "Width(m)"
    range("G" & CStr(lRow + 3)).Value = "Depth(m)"
   

End Sub
