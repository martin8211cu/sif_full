VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsSoinInterfaz"
Attribute VB_GlobalNameSpace = True
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Public MSG      As String
Public ID       As String
Public XML_OE   As String
Public XML_OD   As String
Public XML_OS   As String

Private GvarLastCookies() As String
Private GvarLastURL As String
Private GvarLastUID As String
Private GvarLastPWD As String
Private GvarUserDB As String

  Private Function fnUserDB() As String
    fnUserDB = "WIN:" & getUID()
  End Function

  '----------------------------------------------------------------------------------- */

  Public Function InterfazToSoin(UrlSoin As String, CESoin As String, ESoin As String, UidSoin As String, PwdSoin As String, NumeroInterfaz As String, IdProceso As String) As String

    Dim LvarMSG     As String
    Dim LvarDatos   As String
    Dim LvarHtml    As String
    Dim LvarHeaders As String
    
    On Error GoTo catch1
      LvarDatos = "AU=" + URLEncode(fnCodifica(CESoin, ESoin, UidSoin, PwdSoin, NumeroInterfaz, IdProceso))
      LvarDatos = LvarDatos + "&NI=" + URLEncode(NumeroInterfaz)
      LvarDatos = LvarDatos + "&ID=" + URLEncode(IdProceso)
      
      If UrlSoin = GvarLastURL And UidSoin = GvarLastUID And PwdSoin = GvarLastPWD Then
        writeCookies
      Else
        LvarHeaders = ""
        ReDim GvarLastCookies(1 To 2, 0)
        GvarLastURL = UrlSoin
        GvarLastUID = UidSoin
        GvarLastPWD = PwdSoin
      End If
      
      LvarHtml = WinInetConnect("GET", UrlSoin, LvarDatos)
      
      readCookies
      LvarMSG = URLDecode(WinInetGetHeader("SOIN-MSG"))
      LvarID = URLDecode(WinInetGetHeader("SOIN-ID"))
      If LvarMSG = "" Then
        LvarMSG = "ERROR ANTES DE LA INVOCACION DE LA INTERFAZ: no hubo resultado"
      End If
    GoTo catch1_end
catch1:
      LvarMSG = "ERROR ANTES DE LA INVOCACION DE LA INTERFAZ: " + Err.Description
catch1_end:

    If Len(LvarMSG) > 255 Then
      LvarMSG = Mid(LvarMSG, 1, 255)
    End If
    
    InterfazToSoin = LvarMSG
  End Function

  Public Sub InterfazToSoinXML(UrlSoin As String, CESoin As String, ESoin As String, UidSoin As String, PwdSoin As String, NumeroInterfaz As String, XML_IE As String, XML_ID As String, XML_IS As String, XML_out As Boolean)
    Dim LvarMSG     As String
    Dim LvarDatos   As String
    Dim LvarHtml    As String
    Dim LvarHeaders As String
    
    On Error GoTo catch2
      LvarDatos = "AU=" + URLEncode(fnCodifica(CESoin, ESoin, UidSoin, PwdSoin, NumeroInterfaz, "0"))
      LvarDatos = LvarDatos + "&NI=" + URLEncode(NumeroInterfaz)
      LvarDatos = LvarDatos + "&ID=0"
      LvarDatos = LvarDatos + "&XML_IE=" + URLEncode(XML_IE)
      LvarDatos = LvarDatos + "&XML_ID=" + URLEncode(XML_ID)
      LvarDatos = LvarDatos + "&XML_IS=" + URLEncode(XML_IS)
      LvarDatos = LvarDatos + "&XML_OUT=" + IIf(XML_out, "1", "0")
      
      If UrlSoin = GvarLastURL And UidSoin = GvarLastUID And PwdSoin = GvarLastPWD Then
        writeCookies
      Else
        LvarHeaders = ""
        ReDim GvarLastCookies(1 To 2, 0)
        GvarLastURL = UrlSoin
        GvarLastUID = UidSoin
        GvarLastPWD = PwdSoin
      End If
      
      LvarHtml = WinInetConnect("POST", UrlSoin, LvarDatos)
      
      readCookies
      LvarMSG = URLDecode(WinInetGetHeader("SOIN-MSG"))
      LvarID = URLDecode(WinInetGetHeader("SOIN-ID"))
      If LvarMSG = "" Then
        LvarMSG = "ERROR ANTES DE LA INVOCACION DE LA INTERFAZ: no hubo resultado"
      End If
    GoTo catch2_end
catch2:
      LvarMSG = "ERROR ANTES DE LA INVOCACION DE LA INTERFAZ: " + Err.Description
catch2_end:
      WinInetClose
    
    MSG = LvarMSG
    ID = LvarID

    XML_OE = readXML("XML_OE", LvarHtml)
    XML_OD = readXML("XML_OD", LvarHtml)
    XML_OS = readXML("XML_OS", LvarHtml)
  End Sub

  Public Function readXML(response As String, LvarHtml As String) As String

    Dim LvarPtoIni As Long
    Dim LvarPtoFin As Long
    Dim LvarXML     As String

    LvarPtoIni = InStr(LvarHtml, "<response name=""" + response + """>")
    If LvarPtoIni > 0 Then
        LvarPtoIni = InStr(LvarPtoIni, LvarHtml, ">") + 1

        LvarPtoFin = InStr(LvarPtoIni, LvarHtml, "</response>")
        If LvarPtoFin > 0 Then
            LvarXML = Trim(Mid(LvarHtml, LvarPtoIni, LvarPtoFin - LvarPtoIni))
            'readXML = Replace(Replace(LvarXML, vbTab, ""), vbCrLf, "")
            readXML = LvarXML
            Exit Function
        End If
    End If
    readXML = ""
  End Function
  
  Private Sub writeCookies()
    Dim i As Integer
    Dim LvarCookies As String
    
    LvarCookies = ""
    For i = 1 To UBound(GvarLastCookies, 2)
      If i > 1 Then
        LvarCookies = LvarCookies + "; "
      End If
      LvarCookies = LvarCookies + GvarLastCookies(1, i) + "=" + GvarLastCookies(2, i)
    Next i
    WinInetCookies = LvarCookies & vbCrLf
  End Sub
  
  Private Sub readCookies()
    Dim LvarHdrCookies  As String
    Dim LvarHdrCookie  As String
    Dim LvarPto1 As Integer
    Dim LvarPto2 As Integer
    Dim LvarPto3 As Integer
    
    
    LvarHdrCookies = Trim(WinInetGetHeader("Set-Cookie")) + " "
    If LvarHdrCookies <> " " Then
      LvarPto1 = InStr(LvarHdrCookies & ",", ",")
      Do While (LvarPto1 > 0)
        LvarHdrCookie = Mid(LvarHdrCookies, 1, LvarPto1 - 1)
        LvarCookie = Mid(LvarHdrCookie, 1, InStr(LvarHdrCookie, ";") - 1)
        LvarPto2 = InStr(LvarCookie, "=")
        If LvarPto2 > 0 Then
          LvarSiguiente = UBound(GvarLastCookies, 2) + 1
          ReDim Preserve GvarLastCookies(1 To 2, 0 To LvarSiguiente)
          GvarLastCookies(1, LvarSiguiente) = Mid(LvarCookie, 1, LvarPto2 - 1)
          GvarLastCookies(2, LvarSiguiente) = Mid(LvarCookie, LvarPto2 + 1)
        End If
        LvarHdrCookies = Trim(Mid(LvarHdrCookies, LvarPto1 + 1))
        LvarPto1 = InStr(LvarHdrCookies, ",")
      Loop
    End If
  End Sub

  Private Function fnCodifica(CESoin As String, ESoin As String, UidSoin As String, PwdSoin As String, NumeroInterfaz As String, IdProceso As String) As String
    Dim LvarAU      As String
    Dim LvarAUstr   As String
    Dim LvarAUbts() As Byte
    Dim LvarXor     As Integer
    Dim ID          As Long
    Dim LN          As Long
    Dim LvarPos     As Integer
    Dim LvarRnd     As Integer
    Dim LvarAUcod   As String
    Dim LvarChar    As Integer
    
    If Not IsNumeric(ESoin) Then
      Err.Raise 10000, , "El codigo de Empresa no es numérico"
    End If
    If Not IsNumeric(NumeroInterfaz) Then
      Err.Raise 10000, , "El Número de Interfaz no es numérico"
    End If
    If Not IsNumeric(IdProceso) Then
      Err.Raise 10000, , "El ID de Proceso no es numérico"
    End If
    If Trim(GvarUserDB) = "" Then
      GvarUserDB = fnUserDB()
    End If
    
    LvarAUstr = CESoin & "," & ESoin & "," & UidSoin & "," & PwdSoin & "," & GvarUserDB
    
     ID = CLng(IdProceso)
     LN = CLng(Len(LvarAUstr))
     LvarPos = Int(ID Mod LN) + 1
     LvarRnd = Int(Rnd() * 256)

     LvarAUbts() = LvarAUstr
     LvarXor = 1
     For i = 0 To UBound(LvarAUbts)
        LvarXor = LvarXor Xor LvarAUbts(i)
     Next i

     LvarAUcod = ""
     For i = 0 To UBound(LvarAUbts)
        LvarChar = LvarAUbts(i) Xor LvarRnd
        If i + 1 = LvarPos Then
          LvarAUcod = LvarAUcod + fnHex(LvarRnd)
          LvarAUcod = LvarAUcod + fnHex(LvarXor)
        End If
        LvarAUcod = LvarAUcod + fnHex(LvarChar)
     Next i
     fnCodifica = LvarAUcod
End Function
  
  Private Function fnHex(LprmInt As Integer) As String
    If LprmInt < 16 Then
      fnHex = "0" & Hex(LprmInt)
    Else
      fnHex = Hex(LprmInt)
    End If
  End Function

Public Function URLEncode(ByVal strData As String) As String
    URLEncode = URLEncoder(strData)
End Function

Public Function URLDecode(ByVal strData As String) As String
   URLDecode = URLDecoder(strData)
End Function

Public Function XMLEncode(ByVal strData As String) As String
    XMLEncode = XMLEncoder(strData)
End Function

Public Function XMLDecode(ByVal strData As String) As String
    XMLDecode = XMLDecoder(strData)
End Function

Public Function Base64Encode(ByRef binData() As Byte) As String
  Base64Encode = Base64Encoder(binData())
End Function

Public Function Base64Decode(ByVal strData As String) As Byte()
  Base64Decode = Base64Decoder(strData)
End Function

Public Function Base64EncodeFromString(ByVal strData As String) As String
  Dim binData() As Byte
  ReDim binData(0)
  binData = StrConv(UTF8Encoder(strData), vbFromUnicode)
  Base64EncodeFromString = Base64Encoder(binData())
End Function

Public Function Base64DecodeToString(ByVal strData As String) As String
  Dim binData() As Byte
  ReDim binData(0)
  binData = Base64Decoder(strData)
  Base64DecodeToString = UTF8Decoder(StrConv(binData, vbUnicode))
End Function
