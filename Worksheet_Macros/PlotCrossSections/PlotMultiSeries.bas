Sub PlotMultiSeries(ws As Worksheet, gullyNum As Integer)
    Dim rangeX1 As Range
    Dim rangeY1 As Range
    Dim rangeX05 As Range
    Dim rangeY05 As Range
    Dim rangeX025 As Range
    Dim rangeY025 As Range
    With ws
        .UsedRange.AutoFilter field:=2, Criteria1:="1"
        .UsedRange.AutoFilter field:=3, Criteria1:=CStr(gullyNum)
    End With
    
    Set rangeX1 = ws.UsedRange.Columns(6).Rows("2:" & Rows.Count).SpecialCells(xlCellTypeVisible)
    Set rangeY1 = ws.UsedRange.Columns(7).Rows("2:" & Rows.Count).SpecialCells(xlCellTypeVisible)
    
    ws.ShowAllData
    With ws
        .UsedRange.AutoFilter field:=2, Criteria1:="0.5"
        .UsedRange.AutoFilter field:=3, Criteria1:=CStr(gullyNum)
    End With
    Set rangeX05 = ws.UsedRange.Columns(6).Rows("2:" & Rows.Count).SpecialCells(xlCellTypeVisible)
    Set rangeY05 = ws.UsedRange.Columns(7).Rows("2:" & Rows.Count).SpecialCells(xlCellTypeVisible)
    
    ws.ShowAllData
    With ws
        .UsedRange.AutoFilter field:=2, Criteria1:="0.25"
        .UsedRange.AutoFilter field:=3, Criteria1:=CStr(gullyNum)
    End With
    Set rangeX025 = ws.UsedRange.Columns(6).Rows("2:" & Rows.Count).SpecialCells(xlCellTypeVisible)
    Set rangeY025 = ws.UsedRange.Columns(7).Rows("2:" & Rows.Count).SpecialCells(xlCellTypeVisible)
    ' MsgBox "are you ok?"
    ws.ShowAllData
    Dim cht As Object
    'Dim loc As String
    'Set loc = "G1"
    Set cht = ActiveSheet.Shapes.AddChart(Left:=Range("J" & CStr(20 * gullyNum - 19)).Left, Top:=Range("J" & CStr(20 * gullyNum - 19)).Top).Chart
    cht.ChartType = xlXYScatterLines
    'Dim name As String
    'Set name = "Gully"
    cht.SeriesCollection(1).Delete
    
    With cht
        Do While .SeriesCollection.Count > 0
            .SeriesCollection(1).Delete
        Loop
        .SeriesCollection.Add _
                Source:=rangeY1
        .SeriesCollection(1).name = "100%"
        .SeriesCollection(1).XValues = rangeX1
        .SeriesCollection.Add _
                Source:=rangeY05
        .SeriesCollection(2).XValues = rangeX05
        .SeriesCollection(2).name = "50%"
        .SeriesCollection.Add _
                Source:=rangeY025
        .SeriesCollection(3).XValues = rangeX025
        .SeriesCollection(3).name = "25%"
        .Legend.Position = xlLegendPositionBottom
        .HasTitle = True
        '.ChartTitle.Text = name & " profile"
        .ChartTitle.Text = "Gully" & CStr(gullyNum) & " cross sections profile"
        'x-axis name
        .Axes(xlCategory).HasTitle = True
        .Axes(xlCategory).AxisTitle.Text = "Distance (m)"
        'y-axis name
        .Axes(xlValue, xlPrimary).HasTitle = True
        .Axes(xlValue, xlPrimary).AxisTitle.Characters.Text = "Elevation (m)"
        
        .ChartArea.Width = 800
    End With

End Sub
