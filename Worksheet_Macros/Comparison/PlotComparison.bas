Attribute VB_Name = "Module4"
Sub PlotComparison(range2010 As Range, range2015 As Range, yvalue As Integer, gullyNum As Integer, ws As Worksheet)
    ws.Activate
    Dim cht As Object
    Dim yAxisTitle As String
    'Dim loc As String
    'Set loc = "G1"
    ' Dim gullyNum As Integer
    ' Set gullyNum = 1
    Select Case yvalue
        Case 1
            yAxisTitle = "Elevation"
        Case 2
            yAxisTitle = "Width"
        Case 3
            yAxisTitle = "Depth"
    End Select
    Set cht = ActiveSheet.Shapes.AddChart(Left:=Range("A" & CStr(20 * yvalue - 19)).Left, Top:=Range("A" & CStr(20 * yvalue - 19)).Top).Chart
    cht.ChartType = xlXYScatterLines
    
    With cht
        Do While .SeriesCollection.Count > 0
            .SeriesCollection(1).Delete
        Loop
        .SeriesCollection.Add _
                Source:=range2010.Columns(4 + yvalue)
        .SeriesCollection(1).name = "2010"
        .SeriesCollection(1).XValues = range2010.Columns(2)
        .SeriesCollection.Add _
                Source:=range2015.Columns(4 + yvalue)
        .SeriesCollection(2).XValues = range2015.Columns(2)
        .SeriesCollection(2).name = "2015"
        .HasTitle = True
        '.ChartTitle.Text = name & " profile"
        .ChartTitle.Text = "Gully" & CStr(gullyNum) & yAxisTitle & " profile"
        'x-axis name
        .Axes(xlCategory).HasTitle = True
        .Axes(xlCategory).AxisTitle.Text = "Distance (m)"
        'y-axis name
        .Axes(xlValue, xlPrimary).HasTitle = True
        .Axes(xlValue, xlPrimary).AxisTitle.Characters.Text = yAxisTitle
        
        .ChartArea.Width = 1200
    End With
End Sub
