Sub ticker():

'worksheet loop
 
Dim ws As Worksheet
    For Each ws In ActiveWorkbook.Worksheets
    
    'click worksheet
    ws.Activate
    
        'find last row
        last_row = ws.Cells(Rows.Count, 1).End(xlUp).row
        
        'dim variables
        Dim open_price As Double
        Dim close_price As Double
        Dim quarterly_change As Double
        Dim ticker As String
        Dim percent_change As Double
        
        Dim volume As Double
        Dim row As Double
        Dim column As Double
        
        'starting places
        volume = 0
        row = 2
        column = 1
       
        ' add headers
        Cells(1, 9).Value = "Ticker"
        Cells(1, 10).Value = "Quarterly Change"
        Cells(1, 11).Value = "Percent Change"
        Cells(1, 12).Value = "Total Stock Volume"
        
        'set the initial price
        open_price = Cells(2, column + 2).Value
        
        'loop tickers to find change
        For i = 2 To last_row
        
         
            If Cells(i + 1, column).Value <> Cells(i, column).Value Then
            
                'ticker name
                ticker = Cells(i, column).Value 'name
                Cells(row, column + 8).Value = ticker 'where it goes
                
                ' setting close price
                close_price = Cells(i, column + 5).Value
                
                ' calculate quarterly change
                quarterly_change = close_price - open_price 'math
                Cells(row, column + 9).Value = quarterly_change 'where it goes
               
               ' calculate percent change
                percent_change = quarterly_change / open_price 'math
                Cells(row, column + 10).Value = percent_change 'where it goes
                Cells(row, column + 10).NumberFormat = "0.00%" 'change to %
               
               
               ' calculate total volume per quater
                volume = volume + Cells(i, column + 6).Value 'math
                Cells(row, column + 11).Value = volume 'where it goes
                
                ' iterate to the next row
                row = row + 1
                
                ' reset open_price for next ticker
                open_price = Cells(i + 1, column + 2)
                
                ' reset volume for next ticker
                volume = 0
                
            Else
                volume = volume + Cells(i, column + 6).Value
            End If
        Next i
        
        
        ' find the last row of new ticker column
        quarterly_change_last_row = ws.Cells(Rows.Count, 9).End(xlUp).row
        
        'set red and green +/-
        For j = 2 To quarterly_change_last_row
            If (Cells(j, 10).Value > 0 Or Cells(j, 10).Value = 0) Then
                Cells(j, 10).Interior.ColorIndex = 10
            ElseIf Cells(j, 10).Value < 0 Then
                Cells(j, 10).Interior.ColorIndex = 3
            End If
        Next j
        
        'more headers
        Cells(1, 16).Value = "Ticker"
        Cells(1, 17).Value = "Value"
        Cells(2, 15).Value = "Greatest % Increase"
        Cells(3, 15).Value = "Greatest % Decrease"
        Cells(4, 15).Value = "Greatest Total Volume"
        
        
        ' find the highest value of EACH ticker
        For k = 2 To quarterly_change_last_row
            If Cells(k, 11).Value = Application.WorksheetFunction.Max(ws.Range("K2:K" & quarterly_change_last_row)) Then
                Cells(2, 16).Value = Cells(k, 9).Value
                Cells(2, 17).Value = Cells(k, 11).Value
                Cells(2, 17).NumberFormat = "0.00%"
            ElseIf Cells(k, 11).Value = Application.WorksheetFunction.Min(ws.Range("K2:K" & quarterly_change_last_row)) Then
                Cells(3, 16).Value = Cells(k, 9).Value
                Cells(3, 17).Value = Cells(k, 11).Value
                Cells(3, 17).NumberFormat = "0.00%"
            ElseIf Cells(k, column + 11).Value = Application.WorksheetFunction.Max(ws.Range("L2:L" & quarterly_change_last_row)) Then
                Cells(4, 16).Value = Cells(k, 9).Value
                Cells(4, 17).Value = Cells(k, 12).Value
            End If
        Next k

        ActiveSheet.Range("I:Q").EntireColumn.AutoFit
        Worksheets("Q1").Select
        
    Next ws

End Sub
