Function InputAndSort(strFileName1 As String, name As String) As Worksheet
    ' the CSV file needs to be copyed
    Dim wbkS1 As Workbook
    Dim wshS1 As Worksheet
     ' the CSV file needs to be pasted
    Dim wb As Workbook
    Dim ws As Worksheet
    
    ' Determine the CSV file needs to be copyed
    'Const strFileName1 = "H:\Results 2015\OnSite\CrossSections\OnSiteCrossSections.csv"
    Set wbkS1 = Workbooks.Open(Filename:=strFileName1)
    Set wshS1 = wbkS1.Worksheets(1)
    wshS1.Activate
    wshS1.UsedRange.Copy
    ' Determine the worksheet needs to be pasted
    'Const name = "PlotCrossSections.xlsm"
    Set wb = Workbooks(name)
    wb.Activate
    ' Delete existing content
    Set ws = wb.Sheets(1)
    ' ws.UsedRange.ClearContents
    ' Application.CutCopyMode = False
    With ws
        '.UsedRange.Delete
        .Range("A1").Select
        .Paste
        ' Sort
        .UsedRange.Sort key1:=Range("C2"), order1:=xlAscending, Header:=xlYes
    End With
    Set InputAndSort = ws
End Function
