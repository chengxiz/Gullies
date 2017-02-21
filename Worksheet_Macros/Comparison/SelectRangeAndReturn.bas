Attribute VB_Name = "Module3"
Function SelectRangeAndReturn(ws As Worksheet) As Range
    Dim sourceCol As Integer, rowCount As Integer, currentRow As Integer
    Dim selecRange As Range
    Dim currentRowValue As String

    sourceCol = 1   'column A has a value of 1
    rowCount = Cells(Rows.Count, sourceCol).End(xlUp).Row

    'for every row, find the first blank cell and select it
    For currentRow = 7 To rowCount
        currentRowValue = Cells(currentRow, sourceCol).Value
        If IsEmpty(currentRowValue) Or currentRowValue = "" Then
            'Cells(currentRow, sourceCol).Select
            MsgBox currentRow
            Set SelectRangeAndReturn = ws.Range("A" & CStr(7), "G" & CStr(currentRow - 1))
            Exit For
        End If
    Next
End Function
