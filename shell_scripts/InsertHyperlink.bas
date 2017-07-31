Attribute VB_Name = "Module1"
Sub InsertHypLink(sel As Range)     'rng As Range)
Attribute InsertHypLink.VB_Description = "Macro recorded 6/18/2010 by Cat"
Attribute InsertHypLink.VB_ProcData.VB_Invoke_Func = " \n14"
    Dim c As Integer
    
    For c = 1 To sel.Cells.Count      'rng.Cells.Count
    
        If Len(sel.Cells(c).Text) > 0 Then
            ActiveSheet.Hyperlinks.Add Anchor:=sel.Cells(c), Address:= _
               sel.Cells(c).Text, TextToDisplay:=sel.Cells(c).Text
        End If
    Next c

End Sub

Sub RunInsertHypLink()
 InsertHypLink Selection
End Sub
