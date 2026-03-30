VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   9015
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   10965
   LinkTopic       =   "Form1"
   ScaleHeight     =   9015
   ScaleWidth      =   10965
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox txtHTML 
      Height          =   6735
      Left            =   120
      MultiLine       =   -1  'True
      TabIndex        =   3
      Top             =   2040
      Width           =   10575
   End
   Begin VB.TextBox txtID 
      Height          =   285
      Left            =   2280
      TabIndex        =   2
      Text            =   "0"
      Top             =   240
      Width           =   1215
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Get"
      Height          =   495
      Left            =   240
      TabIndex        =   1
      Top             =   120
      Width           =   1935
   End
   Begin VB.TextBox txtMSG 
      Height          =   855
      Left            =   120
      MultiLine       =   -1  'True
      TabIndex        =   0
      Top             =   960
      Width           =   10575
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Dim LvarConn As New soinInterfaz.clsInterfazToSoin
Dim xmlPrueba As String

Private Sub Command1_Click()

Dim xml1$, xml2$
Me.txtMSG.Text = " ... Comunicandose con el Servidor ... "
DoEvents

    xml1 = _
"<resultset>" + _
"    <row> " + _
"       <moduloOrigen>01</moduloOrigen> " + _
"       <numeroDocumento>11111111</numeroDocumento> " + _
"       <numeroReferencia>11111111</numeroReferencia> " + _
"       <FechaDocumento>2000-01-01 01:01:01</FechaDocumento> " + _
"       <anoPRESUPUESTO>2000</anoPRESUPUESTO> " + _
"       <MESPRESUPUESTO>1</MESPRESUPUESTO> " + _
"       <NAPreversado></NAPreversado> " + _
"       <SoloConsultar>0</SoloConsultar> " + _
"       <BMUsucodigo></BMUsucodigo> " + _
"    </row> " + _
"</resultset> "

    xml2 = _
"<resultset>" + _
"    <row>" + _
"        <NumeroLinea>-123456789</NumeroLinea>" + _
"        <TipoMovimiento>Esto es una Prueba</TipoMovimiento>" + _
"        <CuentaFinanciera>" & LvarConn.STRencode("Esto es una '<Prueba>' de Ángel ") & "</CuentaFinanciera>" + _
"        <CodigoOficina>Esto es una Prueba</CodigoOficina>" + _
"        <CodigoMonedaOrigen>Esto es una Prueba</CodigoMonedaOrigen>" + _
"        <MontoOrigen>-12345678901234.5678</MontoOrigen>" + _
"        <TipoCambio>-0.1234567890123456</TipoCambio>" + _
"        <Monto>-12345678901234.5678</Monto>" + _
"        <NAPreferencia>-123456789012345678</NAPreferencia>" + _
"        <LINreferencia>-123456789</LINreferencia>" + _
"    </row>" + _
"</resultset>"
  LvarConn.sendToSoinXML _
    "http://localhost:8300/cfmx/interfacesSoin/webService/interfaz-serviceXML.cfm", _
    "soin", "2", "marcel", "sup3rman", "8", xml1, xml2, "", True
  
xmlPrueba = ""
If xmlPrueba = "" Then
    xmlPrueba = _
"<resultset>" + _
"    <row> " + _
"       <Hilera>" + LvarConn.STRencode(fnPruebaStr()) + "</Hilera> " + _
"       <Binario>" + LvarConn.Base64Encode(fnPruebaBin()) + "</Binario> " + _
"    </row> " + _
"</resultset> "
End If
xmlPrueba = "0011-03-02,0,2005-01-01,V"
  LvarConn.sendToSoinXML _
    "http://localhost:8300/cfmx/interfacesSoin/webService/interfaz-serviceXML.cfm", _
    "soin", "2", "marcel", "sup3rman", "17", xmlPrueba, "", "", True
    
  Me.txtID = LvarConn.ID
  Me.txtMSG = LvarConn.MSG
  Me.txtHTML = LvarConn.XML_OE & vbCrLf & "-------------" & vbCrLf & LvarConn.XML_Od & "-------------" & vbCrLf & LvarConn.XML_OS
End Sub

Public Function URLEncode(ByVal strData As String) As String
    Dim I As Integer
    Dim strTemp As String
    Dim strChar As String
    Dim strOut As String
    Dim intAsc As Integer
    
    strTemp = Trim(strData)
    For I = 1 To Len(strTemp)
       strChar = Mid(strTemp, I, 1)
       intAsc = Asc(strChar)
       If (intAsc >= 48 And intAsc <= 57) Or _
          (intAsc >= 97 And intAsc <= 122) Or _
          (intAsc >= 65 And intAsc <= 90) Then
          strOut = strOut & strChar
       Else
          strOut = strOut & "%" & Hex(intAsc)
       End If
    Next I
    
    URLEncode = strOut
End Function

Public Function URLDecode(ByVal strData As String) As String
    Dim I As Integer
    Dim strTemp As String
    Dim strChar As String
    Dim strOut As String
    Dim intAsc As Integer
    
    strTemp = Trim(strData)
    
    pPos = 1
    Pos = InStr(pPos, strTemp, "%")
    If Pos = 0 Then
      URLDecode = strTemp
    Else
        Do While Pos > 0
          strOut = strOut + Mid(strTemp, pPos, Pos - pPos) + _
            Chr(CLng("&H" & Mid(strTemp, Pos + 1, 2)))
          pPos = Pos + 3
          Pos = InStr(pPos, strTemp, "%")
        Loop
        
        URLDecode = strOut
    End If
End Function

Function fnPruebaStr() As String
    Dim LvarLin As String
    fnPruebaStr = "Ésto es una <Pruevita>"
    Exit Function
    
    LvarLin = ""
    For I = 0 To 10000
        LvarLin = LvarLin + ChrW(I)
    Next I
    fnPruebaStr = LvarLin
End Function

Function fnPruebaBin() As Byte()
    Dim LvarBin(1000) As Byte
    For I = 0 To 1000
        LvarBin(I) = I Mod 256
    Next I
    fnPruebaBin = LvarBin
End Function


