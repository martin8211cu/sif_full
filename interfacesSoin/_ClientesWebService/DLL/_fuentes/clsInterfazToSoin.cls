VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsInterfazToSoin"
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

  Public Function sendToSoin(UrlSoin As String, CESoin As String, ESoin As String, UidSoin As String, PwdSoin As String, NumeroInterfaz As String, IdProceso As String) As String

    Dim LvarMSG     As String
    Dim LvarDatos   As String
    Dim LvarHtml    As String
    Dim LvarHeaders As String
    
    On Error GoTo catch1
      LvarDatos = "AU=" + URLencode(fnCodifica(CESoin, ESoin, UidSoin, PwdSoin, NumeroInterfaz, IdProceso))
      LvarDatos = LvarDatos + "&NI=" + URLencode(NumeroInterfaz)
      LvarDatos = LvarDatos + "&ID=" + URLencode(IdProceso)
      
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
      LvarMSG = URLdecode(WinInetGetHeader("SOIN-MSG"))
      LvarID = URLdecode(WinInetGetHeader("SOIN-ID"))
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

  Public Sub sendToSoinXML(UrlSoin As String, CESoin As String, ESoin As String, UidSoin As String, PwdSoin As String, NumeroInterfaz As String, XML_IE As String, XML_ID As String, XML_IS As String, XML_out As Boolean)
    Dim LvarMSG     As String
    Dim LvarDatos   As String
    Dim LvarHtml    As String
    Dim LvarHeaders As String
    
    On Error GoTo catch2
      LvarDatos = "AU=" + URLencode(fnCodifica(CESoin, ESoin, UidSoin, PwdSoin, NumeroInterfaz, "0"))
      LvarDatos = LvarDatos + "&NI=" + URLencode(NumeroInterfaz)
      LvarDatos = LvarDatos + "&ID=0"
      LvarDatos = LvarDatos + "&XML_IE=" + URLencode(XML_IE)
      LvarDatos = LvarDatos + "&XML_ID=" + URLencode(XML_ID)
      LvarDatos = LvarDatos + "&XML_IS=" + URLencode(XML_IS)
      LvarDatos = LvarDatos + "&XML_OUT=" + IIf(XML_out, "1", "0")
      LvarDatos = LvarDatos + "&XML_DBS=0"
      
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
      LvarMSG = URLdecode(WinInetGetHeader("SOIN-MSG"))
      LvarID = URLdecode(WinInetGetHeader("SOIN-ID"))
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

Public Function URLencode(ByVal strData As String) As String
    URLencode = URLencoder(strData)
End Function

Public Function URLdecode(ByVal strData As String) As String
   URLdecode = URLdecoder(strData)
End Function

Public Function STRencode(ByVal strData As String) As String
    STRencode = STRencoder(strData)
End Function

Public Function STRdecode(ByVal strData As String) As String
    STRdecode = STRdecoder(strData)
End Function

Public Function BASE64encode(ByRef binData() As Byte) As String
  BASE64encode = BASE64encoder(binData())
End Function

Public Function BASE64decode(ByVal strData As String) As Byte()
  BASE64decode = BASE64decoder(strData)
End Function

Public Function BASE64encodeFromString(ByVal strData As String) As String
  Dim binData() As Byte
  ReDim binData(0)
  binData = StrConv(UTF8Encoder(strData), vbFromUnicode)
  BASE64encodeFromString = BASE64encoder(binData())
End Function

Public Function BASE64decodeToString(ByVal strData As String) As String
  Dim binData() As Byte
  ReDim binData(0)
  binData = BASE64decoder(strData)
  BASE64decodeToString = UTF8Decoder(StrConv(binData, vbUnicode))
End Function

Public Function DATEencode(ByVal Fecha As Date) As String
  DATEencode = Format(Fecha, "YYYY-MM-DD HH:NN:SS")
End Function

Public Function DATEdecode(ByVal strData As String) As Date
    Dim LvarFecha As Date
    Dim LvarHora  As Date
    
    LvarFecha = -1
    LvarHora = -1
    On Error Resume Next
    If Len(strData) >= 10 Then
        'YYYY-MM-DD
        If (Mid(strData, 5, 1) = "-" Or Mid(strData, 5, 1) = "/") And _
           (Mid(strData, 8, 1) = "-" Or Mid(strData, 8, 1) = "/") Then
           LvarFecha = DateSerial(Mid(strData, 1, 4), Mid(strData, 6, 2), Mid(strData, 9, 2))
        'DD-MM-YYYY
        ElseIf (Mid(strData, 3, 1) = "-" Or Mid(strData, 3, 1) = "/") And _
           (Mid(strData, 6, 1) = "-" Or Mid(strData, 6, 1) = "/") Then
            LvarFecha = DateSerial(Mid(strData, 7, 4), Mid(strData, 4, 2), Mid(strData, 1, 2))
        End If
        If LvarFecha <> -1 And Len(strData) >= 11 Then
            'YYYY-MM-DD HH:NN:SS'
            If Mid(strData, 11, 1) = " " And Mid(strData, 14, 1) = ":" And Mid(strData, 17, 1) = ":" Then
                LvarHora = TimeSerial(Mid(strData, 12, 2), Mid(strData, 15, 2), Mid(strData, 18, 2))
            End If
        
            If LvarHora <> -1 Then
                If InStr(20, UCase(strData), "PM") + InStr(20, UCase(strData), "P.M.") > 0 Then
                    LvarHora = LvarHora + 0.5
                End If
                LvarFecha = LvarFecha + LvarHora
            Else
                LvarFecha = -1
            End If
        End If
    End If
    
    If LvarFecha = -1 Then
      Err.Raise 10000, , "Error en Fecha '" + strData + "'"
    End If
    
    DATEdecode = LvarFecha
End Function


