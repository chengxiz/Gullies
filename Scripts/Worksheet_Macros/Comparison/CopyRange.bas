Attribute VB_Name = "Module2"
Function CopyRange(strFileName1 As String, sheetNum As Integer) As Range
    ' the CSV file needs to be copyed
    Dim wbkS1 As Workbook
    Dim wshS1 As Worksheet
     ' the CSV file needs to be pasted
    Dim wb As Workbook
    Dim ws As Worksheet
    ' Determine the CSV file needs to be copyed
    ' Const strFileName1 = "H:\Results 2015\Area6\Summary_Area6.xlsx"
    Set wbkS1 = Workbooks.Open(Filename:=strFileName1)
    Set wshS1 = wbkS1.Worksheets(sheetNum)
    wshS1.Activate
    Set CopyRange = SelectRangeAndReturn(wshS1)
End Function
