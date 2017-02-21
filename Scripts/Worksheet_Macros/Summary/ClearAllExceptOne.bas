Attribute VB_Name = "Module4"
Sub ClearAllExceptOne(name As String)
    Dim wb As Workbook
    Dim ws As Worksheet
    Set wb = Workbooks(name)
    wb.Activate
    
    Application.DisplayAlerts = False
    For Each ws In Worksheets
    If ws.name <> "Sheet1" Then ws.Delete
    Next
    Application.DisplayAlerts = True
  
End Sub
    
