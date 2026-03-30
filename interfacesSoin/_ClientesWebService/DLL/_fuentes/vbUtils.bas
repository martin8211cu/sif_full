Attribute VB_Name = "vbUtils"
Option Explicit

Private Declare Function getUserName Lib "advapi32.dll" Alias "GetUserNameA" (ByVal lpBuffer As String, nSize As Long) As Long
Private Declare Function WideCharToMultiByte Lib "kernel32" (ByVal CodePage As Long, ByVal dwFlags As Long, ByVal lpWideCharStr As Long, ByVal cchWideChar As Long, ByRef lpMultiByteStr As Any, ByVal cchMultiByte As Long, ByVal lpDefaultChar As String, ByVal lpUsedDefaultChar As Long) As Long
Private Declare Function MultiByteToWideChar Lib "kernel32" (ByVal CodePage As Long, ByVal dwFlags As Long, ByRef lpMultiByteStr As Any, ByVal cchMultiByte As Long, ByVal lpWideCharStr As Long, ByVal cchWideChar As Long) As Long
Private Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" _
   (hpvDest As Any, hpvSource As Any, ByVal cbCopy As Long)

Private Const BASE64_t2 As Long = &H30  '00110000
Private Const BASE64_m2 As Long = &HC   '00001100
Private Const BASE64_b2 As Long = &H3   '00000011
Private Const BASE64_t4 As Long = &H3C  '00111100
Private Const BASE64_b4 As Long = &HF   '00001111
Private Const BASE64_h2 As Long = &HC0  '11000000
Private Const BASE64_b6 As Long = &H3F  '00111111
Private Const CP_UTF8 = 65001

Private GvarByteBASE64Chars(64) As Byte

Function URLencoder(ByVal strData As String) As String
    Dim i As Long
    Dim strTemp As String
    Dim strChar As String
    Dim strOut As String
    Dim intAsc As Integer
    
    strTemp = Trim(strData)
    For i = 1 To Len(strTemp)
       strChar = Mid(strTemp, i, 1)
       intAsc = AscW(strChar)
       Select Case intAsc
          Case 32
            strOut = strOut & "+"
          Case 48 To 57, 97 To 122, 65 To 90
            strOut = strOut & strChar
          Case 0 To 15
            strOut = strOut & "%0" & Hex(intAsc)
          Case Else
            strOut = strOut & "%" & Hex(intAsc)
       End Select
    Next i
    
    URLencoder = strOut
End Function

Public Function URLdecoder(ByVal strData As String) As String
    Dim i As Long
    Dim strTemp As String
    Dim strChar As String
    Dim strOut As String
    Dim intAsc As Integer
    Dim pPos As Integer
    Dim pos As Integer
        
    strTemp = Trim(strData)
    
    strTemp = Replace(strData, "+", " ")
    
    pPos = 1
    pos = InStr(pPos, strTemp, "%")
    If pos = 0 Then
      URLdecoder = strTemp
    Else
        Do While pos > 0
          strOut = strOut + Mid(strTemp, pPos, pos - pPos) + _
            ChrW(CLng("&H" & Mid(strTemp, pos + 1, 2)))
          pPos = pos + 3
          pos = InStr(pPos, strTemp, "%")
        Loop
        If pPos <= Len(strTemp) Then
          strOut = strOut + Mid(strTemp, pPos)
        End If
        URLdecoder = strOut
    End If
End Function

Public Function STRencoder(ByVal strData As String) As String
    Dim i As Long
    Dim strTemp As String
    Dim strChar As String
    Dim strOut As String
    Dim intAsc As Integer
    Dim lenData As Long
    
    strTemp = Trim(strData)
    lenData = Len(strTemp)
    For i = 1 To lenData
       strChar = Mid(strTemp, i, 1)
       intAsc = AscW(strChar)
       Select Case intAsc
          Case 13               ' chr(13) + chr(10) o chr(13) lo convierte a chr(10)
            If i = lenData Then
              strOut = strOut & Chr(10)
            ElseIf Asc(Mid(strTemp, i + 1, 1)) <> 10 Then
              strOut = strOut & Chr(10)
            End If
          Case 34
            strOut = strOut & "&quot;"
          Case 38
            strOut = strOut & "&amp;"
          Case 39
            strOut = strOut & "&apos;"
          Case 60
            strOut = strOut & "&lt;"
          Case 62
            strOut = strOut & "&gt;"
          Case 9, 10, 32 To 126 ' ok in range 32 to 126 and not any other special character so just append the character
            strOut = strOut & strChar
          Case 0 To 31
            'strOut = strOut & ""    ' Caracter incorrecto: se ignora
          Case 128 To 255
            strOut = strOut & "&#x" & Hex(intAsc) & ";"
          Case Else       ' 128 to 65535
            strOut = strOut & "&#x" & Hex(intAsc) & ";"
       End Select
    Next i
    
    STRencoder = strOut
End Function

Public Function STRdecoder(ByVal strData As String) As String
    Dim i As Long
    Dim strTemp As String
    Dim strChar As String
    Dim strOut As String
    Dim intAsc As Integer
    Dim pPos As Long
    Dim pos As Long
    Dim pos3 As Long
    
    strTemp = Trim(strData)
    
    pPos = 1
    pos = InStr(pPos, strTemp, "&")
    If pos = 0 Then
      STRdecoder = strTemp
    Else
        Do While pos > 0
          strOut = strOut + Mid(strTemp, pPos, pos - pPos)
          pos3 = InStr(pos, strTemp, ";")
          If pos3 > pos + 1 Then
            strChar = LCase(Mid(strTemp, pos, pos3 - pos + 1))
            If strChar = "&gt;" Then
              strOut = strOut + ">"
            ElseIf strChar = "&lt;" Then
              strOut = strOut + "<"
            ElseIf strChar = "&apos;" Then
              strOut = strOut + "'"
            ElseIf strChar = "&quot;" Then
              strOut = strOut + """"
            ElseIf strChar = "&amp;" Then
              strOut = strOut + "&"
            ElseIf Mid(strChar, 1, 2) = "&#" And IsNumeric(Mid(strChar, 3, Len(strChar) - 3)) Then
              strOut = strOut + ChrW(Val(Mid(strChar, 3, Len(strChar) - 3)))
            ElseIf Mid(strChar, 1, 3) = "&#x" And IsNumeric("&H" & Mid(strChar, 4, Len(strChar) - 4)) Then
              strOut = strOut + ChrW(Val("&H" & Mid(strChar, 4, Len(strChar) - 4)))
            Else
              strOut = strOut + "&"
              pos3 = pPos
            End If
          Else
            strOut = strOut + "&"
            pos3 = pPos
          End If
          pPos = pos3 + 1
          pos = InStr(pPos, strTemp, "&")
        Loop
        If pPos <= Len(strTemp) Then
          strOut = strOut + Mid(strTemp, pPos)
        End If
        STRdecoder = strOut
    End If
End Function

Private Sub BASE64Ini()
  Dim lIndex As Long

  If GvarByteBASE64Chars(0) = 65 Then
    Exit Sub
  End If
  
  For lIndex = 65 To 90
    GvarByteBASE64Chars(lIndex - 65) = lIndex
  Next
  
  For lIndex = 97 To 122
    GvarByteBASE64Chars(lIndex - 71) = lIndex
  Next
  
  For lIndex = 0 To 9
    GvarByteBASE64Chars(lIndex + 52) = 48 + lIndex
  Next
  GvarByteBASE64Chars(62) = 43
  GvarByteBASE64Chars(63) = 47
  GvarByteBASE64Chars(64) = 61

End Sub

Public Function BASE64encoder(ByRef a_bytDataIn() As Byte) As String

  Dim a_bytDataOut() As Byte
  
  Dim lDataInUBound As Long
  Dim lDataInLBound As Long
  Dim lDataInLength As Long
  
  Dim lGroupsOf3 As Long
  Dim lLeftover As Long
  
  Dim lOutputBufferLength As Long
  
  BASE64Ini
  
  lDataInUBound = UBound(a_bytDataIn)
  lDataInLBound = LBound(a_bytDataIn)
  
  lDataInLength = (lDataInUBound - lDataInLBound) + 1
  
  ' how many groups and leftovers
  lGroupsOf3 = lDataInLength \ 3
  
  Dim lGroupsOf3ByteCount As Long
  lGroupsOf3ByteCount = lGroupsOf3 * 3
  
  'iLeftover = 3 - (DataLength Mod 3)
  lLeftover = lDataInLength - lGroupsOf3ByteCount
  
  lOutputBufferLength = lGroupsOf3
  
  If lLeftover Then
    lOutputBufferLength = lOutputBufferLength + 1
  End If
  lOutputBufferLength = lOutputBufferLength * 4
  
  'Debug.Print DataLength, lGroupsOf3, lLeftover, lOutputBufferLength

  ReDim a_bytDataOut(0 To lOutputBufferLength - 1)
  
  Dim lDataInPointer As Long
  Dim lMaxDataInGroupPos As Long
  
  Dim a As Byte
  Dim b As Byte
  Dim c As Byte
  
  Dim r As Byte
  
  Dim lDataOutPos As Long
  
  ' encode
  'n = 0
  lMaxDataInGroupPos = lGroupsOf3ByteCount - 1
  For lDataInPointer = 0 To lMaxDataInGroupPos Step 3
  
    a = a_bytDataIn(lDataInPointer)            ' aaaaaabb
    b = a_bytDataIn(lDataInPointer + 1)        ' bbbbcccc
    c = a_bytDataIn(lDataInPointer + 2)       ' ccdddddd

    ' first character
    'r = a \ 4                   ' aaaaaabb
    'r = r \ 4                ' 00aaaaaa
    '*pBuffer++ = cBASE64Alphabet[r]
    a_bytDataOut(lDataOutPos) = GvarByteBASE64Chars(a \ 4)

    ' second character
    'r = a And BASE64_b2       ' aaaaaabb
    'r = r And BASE64_b2      ' 000000bb
    'r = r << 4;           // 00bb0000
    'r = r + (b >> 4);       // 00bb0000 + 0000bbbb = 00bbbbbb
    '*pBuffer++ = cBASE64Alphabet[r];
    a_bytDataOut(lDataOutPos + 1) = GvarByteBASE64Chars((a And BASE64_b2) * 16 Or (b \ 16) And &HF)
    
    ' third character
    'r = b              ' bbbbcccc
    'r = b << 2;           // bbcccc00
    'r = r & BASE64_t4;        // 00cccc00
    'r = r + (c >> 6);       // 00cccc00 + 000000cc = 00cccccc
    '*pBuffer++ = cBASE64Alphabet[r];
    a_bytDataOut(lDataOutPos + 2) = GvarByteBASE64Chars(((b * 4) And BASE64_t4) + c \ 64)
    
    ' fourth character
    'r = c              ' ccdddddd
    'r = r & BASE64_b6;        // 00dddddd
    '*pBuffer++ = cBASE64Alphabet[r];
    a_bytDataOut(lDataOutPos + 3) = GvarByteBASE64Chars(c And BASE64_b6)
    
    'n = n + 3
    lDataOutPos = lDataOutPos + 4
  Next

  ' handle non multiple of 3 data and insert padding
  If lLeftover Then
  
    lDataInPointer = lGroupsOf3ByteCount
    
    Select Case lLeftover
    
    Case 2:
      
      a = a_bytDataIn(lDataInPointer)        ' aaaaaabb
      b = a_bytDataIn(lDataInPointer + 1)        ' bbbbcccc
      c = 0
      
      ' first character
      'r = a              ' aaaaaabb
      'r = r >> 2;           // 00aaaaaa
      '*pBuffer++ = cBASE64Alphabet[r];
      a_bytDataOut(lDataOutPos) = GvarByteBASE64Chars(a \ 4)
      
      ' second character
      'r = a              ' aaaaaabb
      'r = r & BASE64_b2;        // 000000bb
      'r = r << 4;           // 00bb0000
      'r = r + (b >> 4);       // 00bbcccc
      '*pBuffer++ = cBASE64Alphabet[r];
      a_bytDataOut(lDataOutPos + 1) = GvarByteBASE64Chars(((a And BASE64_b2) * 16) Or (b \ 16))
      
      ' third character
      'r = b              ' bbbbcccc
      'r = b << 2;           // bbcccc00
      'r = r & BASE64_t4;        // 00cccc00
      '*pBuffer++ = cBASE64Alphabet[r];
      a_bytDataOut(lDataOutPos + 2) = GvarByteBASE64Chars(((b * 4) And BASE64_t4) + (c \ 64))
      
      ' insert padding
      '*pBuffer++ = cBASE64Alphabet[64];
      'break;
      'a_bytDataOut(lDataOutPos + 3) = GvarByteBASE64Chars(63) '= (Code = 61)
      a_bytDataOut(lDataOutPos + 3) = 61
    
    Case 1:
      a = a_bytDataIn(lDataInPointer)        ' aaaaaabb
      b = 0        ' aaaaaabb
      
      ' first character
      'r = a              ' aaaaaabb
      'r = r >> 2           ' 00aaaaaa
      '*pBuffer++ = cBASE64Alphabet[r];
      a_bytDataOut(lDataOutPos) = GvarByteBASE64Chars(a \ 4)
      
      ' second character
      'r = a              ' aaaaaabb
      'r = r & BASE64_b2;        // 000000bb
      'r = r << 4;           // 00bb0000
      'r = r + (b >> 4);       // 00bbcccc
      '*pBuffer++ = cBASE64Alphabet[r];
      a_bytDataOut(lDataOutPos + 1) = GvarByteBASE64Chars(((a And BASE64_b2) * 16) + (b \ 16))
      
      ' insert padding x 2
      '*pBuffer++ = cBASE64Alphabet[64];
      '*pBuffer++ = cBASE64Alphabet[64];
      'a_bytDataOut(lDataOutPos + 2) = GvarByteBASE64Chars(63) '= (Code = 61)
      'a_bytDataOut(lDataOutPos + 3) = GvarByteBASE64Chars(63) '= (Code = 61)
      a_bytDataOut(lDataOutPos + 2) = 61
      a_bytDataOut(lDataOutPos + 3) = 61
    End Select
  End If
  BASE64encoder = StrConv(a_bytDataOut, vbUnicode)
End Function

Public Function BASE64decoder(ByRef sDataIn As String) As Byte()
  
  Dim a_bytDataIn() As Byte
  Dim a_bytDataOut() As Byte

  Dim bytDataIn As Byte
  Dim a_bytDataInTidy() As Byte

  Dim lDataInUBound As Long
  Dim lDataInLBound As Long
  Dim lDataInLength As Long
  
  ReDim a_bytDataIn(0)
  a_bytDataIn() = StrConv(sDataIn, vbUnicode)
  
  lDataInLBound = LBound(a_bytDataIn)
  lDataInUBound = UBound(a_bytDataIn)
  
  lDataInLength = (lDataInUBound - lDataInLBound) + 1
  
  Dim lStartPos As Long
  Dim lBytesToCopy As Long
  lStartPos = lDataInLBound
  lBytesToCopy = 0
  
  Dim booInvalidByte As Boolean
  
  Dim lStartPosTidy As Long
  
  ReDim a_bytDataInTidy(lDataInLBound To lDataInUBound) As Byte
  Dim lDataInPointer As Long
  For lDataInPointer = lDataInLBound To lDataInUBound
    booInvalidByte = False
    
    bytDataIn = a_bytDataIn(lDataInPointer)
    Select Case bytDataIn
      Case 65 To 90
      Case 97 To 122
      Case 48 To 57
      Case 43
      Case 47
      Case 61
      Case Else
        booInvalidByte = True
    End Select
    
    If booInvalidByte Then
      Call CopyMemory(a_bytDataInTidy(lStartPosTidy), a_bytDataIn(lStartPos), lBytesToCopy)
      lStartPosTidy = lStartPosTidy + lBytesToCopy
      lBytesToCopy = 0
      lStartPos = lDataInPointer + 1
    Else
      lBytesToCopy = lBytesToCopy + 1
    End If
  Next
  
  Dim lArraySizeTidy As Long
  Dim lUBoundTidy As Long
  Dim lUBoundOut As Long
  
  If lBytesToCopy Then
    lArraySizeTidy = lStartPosTidy + lBytesToCopy
    Call CopyMemory(a_bytDataInTidy(lStartPosTidy), a_bytDataIn(lStartPos), lBytesToCopy)
  Else
    lArraySizeTidy = lStartPosTidy
  End If
  lUBoundTidy = (lArraySizeTidy - 1)
  ReDim Preserve a_bytDataInTidy(lDataInLBound To lUBoundTidy)
  
  'May need to resize if there were pad chars at the end?
  lUBoundOut = ((lArraySizeTidy \ 4) * 3) - 1
  
  Dim lLeftoverFound As Long
  If a_bytDataInTidy(lUBoundTidy) = 61 Then
    If a_bytDataInTidy(lUBoundTidy - 1) = 61 Then
      lLeftoverFound = 2
    Else
      lLeftoverFound = 1
    End If
  Else
    lLeftoverFound = 0
  End If
  
  lUBoundOut = lUBoundOut - lLeftoverFound
  
  ReDim a_bytDataOut(0 To lUBoundOut)
  
  Dim lDataInPointerTidy As Long
  Dim lDataInLBoundTidy As Long
  Dim lDataInUBoundTidy As Long
  Dim lDataInLengthTidy As Long
  
  lDataInLBoundTidy = LBound(a_bytDataInTidy)
  lDataInUBoundTidy = UBound(a_bytDataInTidy)
  
  lDataInLengthTidy = (lDataInUBoundTidy - lDataInLBoundTidy) + 1
  
  Dim lLeftover As Long
  Dim lOffsetAtEnd As Long
  If a_bytDataInTidy(lDataInUBoundTidy - 1) = 61 Then
    lLeftover = 2
    lOffsetAtEnd = 4
  ElseIf a_bytDataInTidy(lDataInUBoundTidy) = 61 Then
    lLeftover = 1
    lOffsetAtEnd = 4
  End If
  
  Dim lValue As Long
  Dim lAccum As Long
  Dim lShift As Long
  
  Dim a As Byte
  Dim b As Byte
  Dim c As Byte
  Dim d As Byte
  
  Dim r As Byte
  
  Dim lDataOutPointer As Long
  Dim lDataInTidyMax As Long
  lDataInTidyMax = lDataInUBoundTidy - lOffsetAtEnd
  For lDataInPointerTidy = lDataInLBoundTidy To lDataInTidyMax Step 4
  
    a = a_bytDataInTidy(lDataInPointerTidy)
    a = LookupChar64(a)
    
    b = a_bytDataInTidy(lDataInPointerTidy + 1)
    b = LookupChar64(b)
    
    c = a_bytDataInTidy(lDataInPointerTidy + 2)
    c = LookupChar64(c)
    
    d = a_bytDataInTidy(lDataInPointerTidy + 3)
    d = LookupChar64(d)
  
    ' first 64
    r = a              ' 00aaaaaa
    r = r * (2 ^ 2)    ' aaaaaa00
    r = r + ((b And BASE64_t2) \ (2 ^ 4))   ' aaaaaa00 + 000000bb = aaaaaabb
    a_bytDataOut(lDataOutPointer) = r
    
    ' second 64
    r = b              ' 00bbbbbb
    r = r And BASE64_b4        ' 0000bbbb
    r = r * (2 ^ 4)            ' bbbb0000
    r = r + (c \ (2 ^ 2))       ' bbbb0000 + 0000cccc = bbbbcccc
    a_bytDataOut(lDataOutPointer + 1) = r
    
    ' third 64
    r = c              ' 00cccccc
    r = r * (2 ^ 6) And &HFF          ' cc000000
    r = r And BASE64_h2        ' cc000000
    r = r + d            ' cc000000 + 00dddddd = ccdddddd
    a_bytDataOut(lDataOutPointer + 2) = r
    
    lDataOutPointer = lDataOutPointer + 3
  Next
  
  If lLeftover Then
    lDataInPointerTidy = lDataInTidyMax + 1
    
    a = a_bytDataInTidy(lDataInPointerTidy)
    a = LookupChar64(a)
    
    b = a_bytDataInTidy(lDataInPointerTidy + 1)
    b = LookupChar64(b)
    
    c = a_bytDataInTidy(lDataInPointerTidy + 2)
    c = LookupChar64(c)
    
    ' first 64
    r = a              ' 00aaaaaa
    r = r * (2 ^ 2)    ' aaaaaa00
    r = r + ((b And BASE64_t2) \ (2 ^ 4))   ' aaaaaa00 + 000000bb = aaaaaabb
    a_bytDataOut(lDataOutPointer) = r

    If lLeftover = 1 Then
    
      ' second 64
      r = b              ' 00bbbbbb
      r = r And BASE64_b4        ' 0000bbbb
      r = r * (2 ^ 4)            ' bbbb0000
      r = r + (c \ (2 ^ 2))       ' bbbb0000 + 0000cccc = bbbbcccc
      a_bytDataOut(lDataOutPointer + 1) = r
      
    End If
    
  End If
  BASE64decoder = a_bytDataOut
End Function

Private Function LookupChar64(ByVal lChar As Byte) As Long

  Dim lIndex As Long

  For lIndex = 0 To 64
    If GvarByteBASE64Chars(lIndex) = lChar Then
      LookupChar64 = lIndex
      Exit Function
    End If
  Next

End Function

Public Function UTF8Decoder(ByVal sUTF8 As String) As String
   Dim lngUtf8Size      As Long
   Dim strBuffer        As String
   Dim lngBufferSize    As Long
   Dim lngResult        As Long
   Dim bytUtf8()        As Byte
   Dim n                As Long
   
   If LenB(sUTF8) = 0 Then Exit Function
    On Error GoTo EndFunction
    bytUtf8 = StrConv(sUTF8, vbFromUnicode)
    lngUtf8Size = UBound(bytUtf8) + 1
    On Error GoTo 0
    'Set buffer for longest possible string i.e. each byte is
    'ANSI, thus 1 unicode(2 bytes)for every utf-8 character.
    lngBufferSize = lngUtf8Size * 2
    strBuffer = String$(lngBufferSize, vbNullChar)
    'Translate using code page 65001(UTF-8)
    lngResult = MultiByteToWideChar(CP_UTF8, 0, bytUtf8(0), _
       lngUtf8Size, StrPtr(strBuffer), lngBufferSize)
    'Trim result to actual length
    
    strBuffer = Replace(strBuffer, vbCrLf, vbLf)
    strBuffer = Replace(strBuffer, vbLf, vbCrLf)
    If lngResult Then
       UTF8Decoder = Left$(strBuffer, lngResult)
    End If
EndFunction:
End Function

Public Function UTF8Encoder(ByVal strUnicode As String, Optional ByVal bHTML As Boolean = False) As String
    Dim i                As Long
    Dim TLen             As Long
    Dim lPtr             As Long
    Dim UTF16            As Long
    Dim LvarUTFLong  As String
    Dim LvarUTF      As String
   
    TLen = Len(strUnicode)
    If TLen = 0 Then Exit Function
    Dim lngBufferSize    As Long
    Dim lngResult        As Long
    Dim bytUtf8()        As Byte
    'Set buffer for longest possible string.
    lngBufferSize = TLen * 3 + 1
    ReDim bytUtf8(lngBufferSize - 1)
    'Translate using code page 65001(UTF-8).
    lngResult = WideCharToMultiByte(CP_UTF8, 0, StrPtr(strUnicode), _
       TLen, bytUtf8(0), lngBufferSize, vbNullString, 0)
    'Trim result to actual length.
    If lngResult Then
       lngResult = lngResult - 1
       ReDim Preserve bytUtf8(lngResult)
       LvarUTF = StrConv(bytUtf8, vbUnicode)
    End If
   
    'Substitute vbCrLf with HTML line breaks if requested.
    If bHTML Then
        LvarUTF = Replace$(LvarUTF, vbCrLf, "<BR>")
    End If
    UTF8Encoder = LvarUTF
End Function


Function getUID() As String
    Dim strBuffer As String * 25
    Dim ret As Long
    
    ret = getUserName(strBuffer, 25)
    getUID = Left(strBuffer, InStr(strBuffer, Chr(0)) - 1)
End Function

