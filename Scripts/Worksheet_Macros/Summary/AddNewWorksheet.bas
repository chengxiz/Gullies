Attribute VB_Name = "Module3"
Sub AddNewWorksheet(name As String)
    With Worksheets.Add()
        .name = name
    End With
End Sub
