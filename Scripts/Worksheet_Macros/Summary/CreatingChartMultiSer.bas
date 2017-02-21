Attribute VB_Name = "Module11"
Sub CreatingChartMultiSer(name As String, _
                    range_name1 As String, range_name2 As String, range_name3 As String, _
                    original_sheet1 As Worksheet, original_sheet2 As Worksheet, original_sheet3 As Worksheet, _
                    wbk As Workbook, col1 As Integer, col2 As Integer, loc As String, _
                    ser1 As String, ser2 As String, ser3 As String)
    Set ws = wbk.Sheets(name)
    ws.Activate
    
    Dim cht As Object
    Set cht = ActiveSheet.Shapes.AddChart(Left:=range(loc).Left, Top:=range(loc).Top).Chart
    cht.ChartType = xlXYScatterLines
    
    cht.SeriesCollection(1).Delete
    
    With cht
        Do While .SeriesCollection.Count > 0
            .SeriesCollection(1).Delete
        Loop
        .SeriesCollection.Add _
                Source:=original_sheet1.range(range_name1).Columns(col2)
        .SeriesCollection(1).name = ser1
        .SeriesCollection(1).XValues = original_sheet1.range(range_name1).Columns(col1)
        .SeriesCollection.Add _
                Source:=original_sheet2.range(range_name2).Columns(col2)
        .SeriesCollection(2).XValues = original_sheet2.range(range_name2).Columns(col1)
        .SeriesCollection(2).name = ser2
        .SeriesCollection.Add _
                Source:=original_sheet3.range(range_name3).Columns(col2)
        .SeriesCollection(3).XValues = original_sheet3.range(range_name3).Columns(col1)
        .SeriesCollection(3).name = ser3
        .Legend.Position = xlLegendPositionBottom
        .HasTitle = True
        .ChartTitle.Text = name & " profile"
        'x-axis name
        .Axes(xlCategory).HasTitle = True
        .Axes(xlCategory).AxisTitle.Text = "Distance (m)"
        'y-axis name
        .Axes(xlValue, xlPrimary).HasTitle = True
        .Axes(xlValue, xlPrimary).AxisTitle.Characters.Text = "Slope (m/m)"
        
        .ChartArea.Width = 800
    End With

End Sub
    


