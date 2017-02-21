Attribute VB_Name = "Module10"
Sub CreatingChart(name As String, range_name As String, original_sheet As Worksheet, wbk As Workbook, col1 As Integer, col2 As Integer, loc As String, ser As String)
    Set ws = wbk.Sheets(name)
    ws.Activate
    
    Dim cht As Object
    Set cht = ActiveSheet.Shapes.AddChart(Left:=range(loc).Left, Top:=range(loc).Top).Chart

    cht.ChartType = xlXYScatterLines
    
    Set bigRange = Application.Union(original_sheet.range(range_name).Columns(col1), original_sheet.range(range_name).Columns(col2))
    cht.SetSourceData Source:=bigRange
    cht.Location Where:=xlLocationAsObject, name:=name
    
    With cht
        .SeriesCollection(1).name = ser
        .Legend.Position = xlLegendPositionBottom
        .HasTitle = True
        .ChartTitle.Text = name & " profile"
        'x-axis name
        .Axes(xlCategory).HasTitle = True
        .Axes(xlCategory).AxisTitle.Text = "Distance (m)"
        'y-axis name
        .Axes(xlValue, xlPrimary).HasTitle = True
        .Axes(xlValue, xlPrimary).AxisTitle.Characters.Text = ser & " (m)"
    End With
    
End Sub

