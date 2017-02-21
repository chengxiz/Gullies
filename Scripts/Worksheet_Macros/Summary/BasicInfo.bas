Attribute VB_Name = "Module9"
Sub BasicInfo(name As String, wbk As Workbook)
    Set ws = wbk.Sheets(name)
    ws.Activate
    ws.range("A1").Value = "GullyName"
    ws.range("A2").Value = "GullyID"
    ws.range("A3").Value = "Interval"
End Sub
