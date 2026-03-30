VERSION 5.00
Begin VB.UserControl cntImpresora 
   BackColor       =   &H80000005&
   ClientHeight    =   1800
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   5010
   DefaultCancel   =   -1  'True
   ScaleHeight     =   1800
   ScaleWidth      =   5010
   Begin VB.TextBox Text1 
      Appearance      =   0  'Flat
      BackColor       =   &H00FFFFFF&
      BorderStyle     =   0  'None
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Left            =   4680
      Locked          =   -1  'True
      MousePointer    =   10  'Up Arrow
      TabIndex        =   7
      Top             =   480
      Width           =   180
   End
   Begin VB.CommandButton cmdImprimir 
      Caption         =   "Imprimir"
      Default         =   -1  'True
      Height          =   300
      Left            =   1440
      TabIndex        =   2
      Top             =   1440
      Width           =   855
   End
   Begin VB.CommandButton cmdCancelar 
      Cancel          =   -1  'True
      Caption         =   "Cancelar"
      Height          =   300
      Left            =   2400
      TabIndex        =   6
      Top             =   1440
      Width           =   855
   End
   Begin VB.PictureBox picBarraFija 
      Appearance      =   0  'Flat
      BackColor       =   &H80000005&
      ForeColor       =   &H80000008&
      Height          =   255
      Left            =   120
      ScaleHeight     =   225
      ScaleWidth      =   4425
      TabIndex        =   3
      Top             =   1080
      Visible         =   0   'False
      Width           =   4455
      Begin VB.PictureBox picBarraMovil 
         Appearance      =   0  'Flat
         BackColor       =   &H00FF0000&
         BorderStyle     =   0  'None
         FillColor       =   &H0000FFFF&
         FillStyle       =   0  'Solid
         ForeColor       =   &H80000008&
         Height          =   255
         Left            =   0
         ScaleHeight     =   255
         ScaleWidth      =   4455
         TabIndex        =   4
         Top             =   0
         Width           =   4455
      End
   End
   Begin VB.ComboBox cboImpresora 
      Height          =   315
      Left            =   1920
      TabIndex        =   1
      Text            =   "Combo1"
      Top             =   480
      Width           =   2775
   End
   Begin VB.Label lblProceso 
      Alignment       =   2  'Center
      Appearance      =   0  'Flat
      BackColor       =   &H80000005&
      BackStyle       =   0  'Transparent
      Caption         =   "Cargando datos..."
      ForeColor       =   &H80000008&
      Height          =   255
      Left            =   120
      TabIndex        =   5
      Top             =   840
      Width           =   4455
   End
   Begin VB.Label Label1 
      BackColor       =   &H80000005&
      BackStyle       =   0  'Transparent
      Caption         =   "Impresora Destino:"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   120
      TabIndex        =   0
      Top             =   480
      Width           =   1815
   End
End
Attribute VB_Name = "cntImpresora"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit


Private MvarIdioma          As Integer    '0=Español, 1=Inglés USA, 2=Inglés Inglaterra

Private MvarFormatoDoc      As New clsFormatoDoc
Private MvarFormatosCol()   As clsFormatoCol
Private MvarFormatosImg()   As clsFormatoImg
Private MvarFormatosLin()   As clsFormatoLin
Private MvarDatosCol()      As String
Private MvarDatosLin()      As String
Private MvarRowI            As Integer
Private MvarColI            As Integer
Private MvarImgI            As Integer
Private MvarLinI            As Integer
Private MvarTotAvance       As Integer

'La Posicion me indica los limites 1=Encabezado, 2=Detalle, 3=Totales
Private MvarPos(1 To 3)     As clsFormatoPos
Private MvarCurrentY        As Double
Private MvarMasDetalle      As Integer
Private Mvar1Impreso        As Boolean
Private MvarInicio          As Boolean

Private MvarOrigen          As String

Private MvarInicializado    As String

Const MvarEntreLin = 0.075

Public Version              As String
Public Event Inicio()
Public Event NoInicio()
Public Event TerminoConExito(UltimoDocumento, TotPaginas)
Public Event TerminoConError(UltimoDocumento, TotPaginas)

Private Sub Text1_Click()
  MsgBox "soinPrintDoc.ocx " & Version
End Sub

Private Sub UserControl_Initialize()
  MvarIdioma = 0
  MvarInicializado = False
  lblProceso.Caption = ""
  cmdImprimir.Visible = False
  cmdCancelar.Visible = False
  picBarraFija.Visible = False
  sbLeerImpresoras
  Me.Version = App.Major & "." & App.Minor & "." & App.Revision
End Sub

Sub sbLeerImpresoras()
  Dim LvarPrn As Printer
  Dim LvarDeviceName As String
  Dim LvarIdxParam As Integer
  Dim LvarIdxPrinter As Integer
  
  If cboImpresora.ListCount > 0 Then
      LvarDeviceName = cboImpresora.Text
  End If
  If LvarDeviceName = "" Then
      LvarDeviceName = GetSetting("soinPrintDocs", "Defaults", "Printer", Printer.DeviceName)
  End If
  
  cboImpresora.Clear
  If Printers.Count = 0 Then
    MsgBox "ERROR: No existen Impresoras definidas en esta Computadora"
  Else
    For Each LvarPrn In Printers
      cboImpresora.AddItem LvarPrn.DeviceName
      If LvarPrn.DeviceName = LvarDeviceName Then
        LvarIdxParam = cboImpresora.ListCount
      ElseIf LvarPrn.DeviceName = Printer.DeviceName Then
        LvarIdxPrinter = cboImpresora.ListCount
      End If
    Next
    If LvarIdxParam > 0 Then
        cboImpresora.ListIndex = LvarIdxParam - 1
    Else
        cboImpresora.ListIndex = LvarIdxPrinter - 1
    End If
  End If
End Sub

Public Sub setIdioma(ByVal vNewValue As Integer)
    MvarIdioma = vNewValue
    If MvarIdioma > 2 Then
        Err.Raise 100010, , "ERROR Idioma no definido: " & MvarIdioma
    End If
End Sub

Public Sub FormatoDoc(ByVal vFMT01COD As String, ByVal vFMT01DES As String, ByVal vFMT01TIP As String, ByVal vFMT01KEY As String, ByVal vFMT01TOT As Integer, ByVal vFMT01LIN As Integer, ByVal vFMT01DET As Integer, ByVal vFMT01PDT As Integer, ByVal vFMT01SPC As Double, ByVal vFMT01ENT As Boolean, ByVal vFMT01REF As String, ByVal vFMT01LAR As Double, ByVal vFMT01ANC As Double, ByVal vFMT01ORI As Integer, ByVal vFMT01LFT As Double, ByVal vFMT01TOP As Double, ByVal vFMT01RGT As Double, ByVal vFMT01BOT As Double, ByVal vNumImagenes As Integer, ByVal vNumLineas As Integer, ByVal vNumColFmt As Integer, ByVal vNUMCOLSQL As Integer, ByVal vNUMFILSQL As Integer, ByVal vNumDocumento As Variant, ByVal vTotDocumentos As Integer, ByVal vHacerCortePag As Boolean)
  Dim I As Integer
  lblProceso.Caption = "Cargando datos..."
  sbActualizaAvance True, vNumColFmt + vNUMFILSQL + 2  '2=FormatoDoc y DatosCol
  picBarraFija.Visible = True
  
  'INICIALIZA LAS VARIABLES
  If MvarInicializado Then
    Set MvarFormatoDoc = Nothing
    If MvarColI > 0 Then
      For I = 0 To MvarColI - 1
        Set MvarFormatosCol(I) = Nothing
      Next I
    End If
    If MvarImgI > 0 Then
      For I = 0 To MvarImgI - 1
        Set MvarFormatosImg(I) = Nothing
      Next I
    End If
    If MvarLinI > 0 Then
      For I = 0 To MvarLinI - 1
        Set MvarFormatosLin(I) = Nothing
      Next I
    End If
    Set MvarPos(1) = Nothing
    Set MvarPos(2) = Nothing
    Set MvarPos(3) = Nothing
  End If
  
  MvarRowI = 0
  MvarColI = 0
  MvarImgI = 0
  MvarLinI = 0
  MvarTotAvance = 0
  Set MvarPos(1) = New clsFormatoPos
  Set MvarPos(2) = New clsFormatoPos
  Set MvarPos(3) = New clsFormatoPos
  MvarCurrentY = 0
  MvarMasDetalle = 0
  Mvar1Impreso = False
  MvarInicio = False
  MvarOrigen = ""
  
  Set MvarFormatoDoc = New clsFormatoDoc
  MvarFormatoDoc.NumLineas = vNumLineas - 1     'Numero de Lineas
  MvarFormatoDoc.NumImagenes = vNumImagenes - 1 'Numero de Imagenes
  MvarFormatoDoc.NumColFMT = vNumColFmt - 1     'Numero de columnas a imprimir
  MvarFormatoDoc.NumColSQL = vNUMCOLSQL - 1     'Numero de columnas en datos
  MvarFormatoDoc.NumFilSQL = vNUMFILSQL - 1     'Numero de filas en datos
  
  If vNumImagenes > 0 Then
    ReDim MvarFormatosImg(MvarFormatoDoc.NumImagenes)
  End If
  If vNumLineas > 0 Then
    ReDim MvarFormatosLin(MvarFormatoDoc.NumLineas)
  End If
  ReDim MvarFormatosCol(MvarFormatoDoc.NumColFMT)
  ReDim MvarDatosCol(MvarFormatoDoc.NumColSQL)
  ReDim MvarDatosLin(MvarFormatoDoc.NumFilSQL, MvarFormatoDoc.NumColSQL)
  
  MvarInicializado = True
  
  MvarFormatoDoc.FMT01COD = vFMT01COD   'Codigo Formato
  MvarFormatoDoc.FMT01DES = vFMT01DES   'Descripción
  MvarFormatoDoc.FMT01TIP = vFMT01TIP   'Tipo de Formato
  MvarFormatoDoc.FMT01KEY = UCase(Trim(vFMT01KEY))   'Numero Doc para corte

  MvarFormatoDoc.FMT01TOT = vFMT01TOT   'Lineas Formato TOTAL
  MvarFormatoDoc.FMT01LIN = vFMT01LIN   'Lineas Encabezado
  MvarFormatoDoc.FMT01DET = vFMT01DET   'Lineas Detalle
  MvarFormatoDoc.FMT01PDT = vFMT01PDT   'Lineas PostDetalle
  MvarFormatoDoc.FMT01SPC = vFMT01SPC   'Espacio entre Lineas Detalle
  MvarFormatoDoc.FMT01ENT = vFMT01ENT   'Mantener retorno de Linea
  MvarFormatoDoc.FMT01REF = vFMT01REF   'Referencia

  MvarFormatoDoc.FMT01LAR = vFMT01LAR   'Alto o Largo
  MvarFormatoDoc.FMT01ANC = vFMT01ANC   'Ancho

  'Orientación: 1=Vertical, 0=Horizontal
  If vFMT01ORI = 1 Then
    MvarFormatoDoc.FMT01ORI = 1
  Else
    MvarFormatoDoc.FMT01ORI = 2
  End If

  MvarFormatoDoc.FMT01LFT = vFMT01LFT   'Margen Izquierdo
  MvarFormatoDoc.FMT01TOP = vFMT01TOP   'Margen Superior
  MvarFormatoDoc.FMT01RGT = vFMT01RGT   'Margen Derecho
  MvarFormatoDoc.FMT01BOT = vFMT01BOT   'Margen Inferior

  MvarFormatoDoc.NumDocumento = CDec(vNumDocumento)   'Numero del Formulario Inicial
  MvarFormatoDoc.TotDocumentos = vTotDocumentos 'Total de Documentos a Imprimir
  MvarFormatoDoc.HacerCortePag = vHacerCortePag 'Indica si hace corte de pagina o pone leyenda de mas detalles sin imprimir

  sbActualizaAvance
End Sub

Public Sub FormatosImg(ByVal vFMT03_X As Double, ByVal vFMT03_Y As Double, ByVal vFMT03ALT As Double, ByVal vFMT03ANC As Double, ByVal vFMT03BOR As Boolean, ByVal vFMT03CFN As String, ByVal vFMT03CBR As String, ByVal vFMT03EMP As String, ByVal vTipoImagen As String, ByVal vImagen As String)
  Set MvarFormatosImg(MvarImgI) = New clsFormatoImg

  MvarFormatosImg(MvarImgI).FMT03_X = vFMT03_X   'Posición Horizontal (equivale a CurrentX)
  MvarFormatosImg(MvarImgI).FMT03_Y = vFMT03_Y   'Posición Vertical   (equivale a CurrentY)

  MvarFormatosImg(MvarImgI).FMT03ALT = vFMT03ALT 'Altura de la imagen
  MvarFormatosImg(MvarImgI).FMT03ANC = vFMT03ANC 'Ancho de la imagen
  MvarFormatosImg(MvarImgI).FMT03BOR = vFMT03BOR 'Tiene Borde
  MvarFormatosImg(MvarImgI).FMT03CFN = vFMT03CFN 'Color de Fondo
  MvarFormatosImg(MvarImgI).FMT03CBR = vFMT03CBR 'Color de Borde
  MvarFormatosImg(MvarImgI).FMT03EMP = vFMT03EMP 'Es logo de Empresa
  If vTipoImagen = "A" Then
    MvarFormatosImg(MvarImgI).Imagen = vImagen   'Nombre del Archivo
  Else
    MsgBox "No se ha implementado la Carga de Imagen Binaria"
    MvarFormatosImg(MvarImgI).Imagen = "IMGDOC" & MvarImgI & "." & vTipoImagen
  End If

  MvarImgI = MvarImgI + 1
End Sub

Public Sub FormatosLin(ByVal vFMT09_X As Double, ByVal vFMT09_Y As Double, ByVal vFMT09CLR As String, ByVal vFMT09ALT As Double, ByVal vFMT09ANC As Double, ByVal vFMT09GRS As Boolean, ByVal vFMT09CFN As String)
  Set MvarFormatosLin(MvarLinI) = New clsFormatoLin

  MvarFormatosLin(MvarLinI).FMT09_X = vFMT09_X   'Posición Horizontal
  MvarFormatosLin(MvarLinI).FMT09_Y = vFMT09_Y   'Posición Vertical

  MvarFormatosLin(MvarLinI).FMT09CLR = vFMT09CLR 'Color de Fondo
  MvarFormatosLin(MvarLinI).FMT09ALT = vFMT09ALT 'Altura de la imagen
  MvarFormatosLin(MvarLinI).FMT09ANC = vFMT09ANC 'Ancho de la imagen
  MvarFormatosLin(MvarLinI).FMT09GRS = vFMT09GRS 'Tiene Borde
  MvarFormatosLin(MvarLinI).FMT09CFN = vFMT09CFN 'Color de Borde

  MvarLinI = MvarLinI + 1
End Sub

Public Sub FormatosCol(ByVal vFMT02POS As Integer, ByVal vFMT02_X As Double, ByVal vFMT02_Y As Double, ByVal vFMT02TIP As Integer, ByVal vFMT02SQL As String, ByVal vFMT02AJU As Boolean, ByVal vFMT02FMT As String, ByVal vFMT02LON As Double, ByVal vFMT02DEC As Integer, ByVal vFMT02JUS As Integer, ByVal vFMT02TPL As String, ByVal vFMT02TAM As Integer, ByVal vFMT02CLR As String, ByVal vFMT02BOL As Boolean, ByVal vFMT02UND As Boolean, ByVal vFMT02ITA As Boolean, ByVal vFMT02PAG As Boolean, ByVal vFMT02PRE As String, ByVal vFMT02SUF As String)
  Set MvarFormatosCol(MvarColI) = New clsFormatoCol
  MvarFormatosCol(MvarColI).FMT02POS = vFMT02POS        'Posicion: 1=Encabezado, 2=Detalle, 3=PostDetalle
  MvarFormatosCol(MvarColI).FMT02_X = vFMT02_X          'Posición Horizontal (equivale a CurrentX)
  MvarFormatosCol(MvarColI).FMT02_Y = vFMT02_Y          'Posición Vertical   (equivale a CurrentY)
  MvarFormatosCol(MvarColI).FMT02TIP = vFMT02TIP        'Tipo de Campo:  1=Etiqueta, 2=Dato
  MvarFormatosCol(MvarColI).FMT02SQL = Trim(vFMT02SQL)  'Campo cuando tipo Dato o Valor cuando tipo Etiqueta
  MvarFormatosCol(MvarColI).FMT02AJU = vFMT02AJU        'Ajusta Linea
  MvarFormatosCol(MvarColI).FMT02FMT = vFMT02FMT        'Formato
  MvarFormatosCol(MvarColI).FMT02LON = vFMT02LON        'Longitud
  MvarFormatosCol(MvarColI).FMT02DEC = vFMT02DEC        'Decimales
  MvarFormatosCol(MvarColI).FMT02JUS = vFMT02JUS        'Alineacion: 1=Izquierda, 2=Centrado, 3=Derecha
  MvarFormatosCol(MvarColI).FMT02TPL = vFMT02TPL        'Fuente:   Arial, Courier, sans-serif
  MvarFormatosCol(MvarColI).FMT02TAM = vFMT02TAM        'Tamaño Letra: 6 - 16
  MvarFormatosCol(MvarColI).FMT02CLR = vFMT02CLR        'Color
  MvarFormatosCol(MvarColI).FMT02BOL = vFMT02BOL        'Negrita
  MvarFormatosCol(MvarColI).FMT02UND = vFMT02UND        'Subrayado
  MvarFormatosCol(MvarColI).FMT02ITA = vFMT02ITA        'Itálica
  MvarFormatosCol(MvarColI).FMT02PAG = vFMT02PAG        'Salto de Página

  MvarFormatosCol(MvarColI).FMT02PRE = vFMT02PRE        'PREFIJO
  MvarFormatosCol(MvarColI).FMT02SUF = vFMT02SUF        'SUFIJO
  
  MvarFormatosCol(MvarColI).PTODATOS = -1               'Puntero a la Columna en Datos
  MvarColI = MvarColI + 1
  
  sbActualizaAvance
End Sub

Public Sub DatosCol(ParamArray vColumn() As Variant)
  Dim LvarCol As Integer
  
  For LvarCol = 0 To MvarFormatoDoc.NumColSQL
    MvarDatosCol(LvarCol) = vColumn(LvarCol)
  Next LvarCol
  
  sbActualizaAvance
End Sub

Public Sub DatosLin(ParamArray vColumn() As Variant)
  Dim LvarCol As Integer
  
  For LvarCol = 0 To MvarFormatoDoc.NumColSQL
    MvarDatosLin(MvarRowI, LvarCol) = vColumn(LvarCol)
  Next LvarCol
  MvarRowI = MvarRowI + 1
  
  sbActualizaAvance
End Sub

Public Sub DatosFin(Optional vImpresora As String)
  Dim I As Integer
  
  lblProceso.Caption = ""
  
  picBarraFija.Visible = False
  
  On Error GoTo ErrorPRN
  If Printers.Count = 0 Then
    Err.Raise 2003, , "Debe definir primero una impresora"
  End If
  
  lblProceso.Caption = ""
  cmdImprimir.Visible = True
  cmdCancelar.Visible = True
  
  DoEvents
  Exit Sub
ErrorPRN:
    MsgBox "No se imprimió ningún documento: " + MvarOrigen + vbCrLf + vbCrLf + Err.Description
    RaiseEvent NoInicio
  Exit Sub
  Resume
End Sub

Public Sub Imprimir(vImpresora As String)
  Dim I As Integer
  
  cboImpresora.ListIndex = -1
  For I = 0 To cboImpresora.ListCount - 1
    If cboImpresora.List(I) = vImpresora Then
      cboImpresora.ListIndex = I
      Exit For
    End If
  Next I
  
  sbImprimir
End Sub

Private Sub cmdImprimir_Click()
  sbImprimir
End Sub

Private Sub cmdCancelar_Click()
  cmdImprimir.Visible = False
  cmdCancelar.Visible = False
  picBarraFija.Visible = False
  lblProceso.Caption = "Impresion Cancelada..."
  If MvarInicio Then
    cmdCancelar.Tag = "CANCELAR"
  Else
    RaiseEvent NoInicio
  End If
End Sub

Private Sub sbImprimir()
  Dim LvarDocAnt As String
  Dim LvarLin As Integer
  Dim LvarHeight As Double
  
  MvarOrigen = "cmdImprimir_Click"
  cmdImprimir.Visible = False
  lblProceso.Caption = "Imprimiendo datos..."
  
  On Error GoTo ErrorPRN
  
  If Printers.Count = 0 Then
    Err.Raise 2000, , "Debe definir primero una impresora en esta computadora"
  End If
  
    '-----------------------------------------------
    ' Determina la Coma y el Punto del Control Panel
    GvarComa = Mid(Format("1000", "#,##0.0"), 2, 1)
    GvarPunto = Mid(Format("1000", "#,##0.0"), 6, 1)
    If Len(GvarComa) <> 1 Then
        Err.Raise 100010, , "ERROR en formato numérico: el separador de miles debe definirse de un caracter. Debe cambiarlo en el Panel de Control"
    End If
    If Len(GvarPunto) <> 1 Then
        Err.Raise 100010, , "ERROR en formato numérico: el separador de decimales debe definirse de un caracter. Debe cambiarlo en el Panel de Control"
    End If
    If GvarComa >= "0" And GvarComa <= "9" Then
        Err.Raise 100010, , "ERROR en formato numérico: tiene definido el separador de miles con un dígito numérico. Debe cambiarlo en el Panel de Control"
    End If
    If GvarPunto >= "0" And GvarPunto <= "9" Then
        Err.Raise 100010, , "ERROR en formato numérico: tiene definido el separador de decimales con un dígito numérico. Debe cambiarlo en el Panel de Control"
    End If
    If GvarComa = GvarPunto Then
        Err.Raise 100010, , "ERROR en formato numérico: tiene definido el separador de miles y de decimales con el mismo caracter. Debe cambiarlo en el Panel de Control"
    End If
    '-----------------------------------------------
  
  Set Printer = Printers(cboImpresora.ListIndex)
  SaveSetting "soinPrintDocs", "Defaults", "Printer", Printer.DeviceName
  
  LvarHeight = Printer.Height
  'Printer.Height = MvarFormatoDoc.FMT01LAR * 567
  If Printer.Height = LvarHeight Then
    sbSetPrinterForm UserControl.hwnd, MvarFormatoDoc.FMT01LAR, MvarFormatoDoc.FMT01ANC, MvarFormatoDoc.FMT01ORI
  Else
    Printer.Height = MvarFormatoDoc.FMT01LAR * 567
    Printer.Width = MvarFormatoDoc.FMT01ANC * 567
    Printer.Orientation = MvarFormatoDoc.FMT01ORI
  End If
  
  Printer.ScaleMode = 7
  sbDireccionarCol
  
  Printer.CurrentX = 0
  Printer.CurrentY = 0
  Printer.Print " ";
  MvarInicio = True
  RaiseEvent Inicio
  MvarFormatoDoc.TotPaginas = 0
  
  sbActualizaAvance True, MvarFormatoDoc.TotDocumentos + 1
  picBarraFija.Visible = True
  
  LvarDocAnt = Chr(255)
  sbImprimeImagenes
  For LvarLin = 0 To MvarFormatoDoc.NumFilSQL
    If LvarDocAnt <> MvarDatosLin(LvarLin, MvarFormatoDoc.PtoColKEY) Then
      If LvarLin > 0 Then
        sbImprimeTotal LvarLin
        sbNewPage
        MvarFormatoDoc.NumDocumento = MvarFormatoDoc.NumDocumento + 1
        Mvar1Impreso = True
      End If
      LvarDocAnt = MvarDatosLin(LvarLin, MvarFormatoDoc.PtoColKEY)
      sbImprimeEncabezado LvarLin, False
      sbActualizaAvance
    End If
    sbImprimeDetalle LvarLin
    If cmdCancelar.Tag = "CANCELAR" Then
      Err.Raise 20000, , "Cancelación despues de imprimir documento numero " & (MvarFormatoDoc.NumDocumento - 1)
    End If
  Next LvarLin
  sbImprimeTotal LvarLin
  sbImprimeLineas
  
  cmdImprimir.Visible = False
  cmdCancelar.Visible = False
  picBarraFija.Visible = False
  lblProceso.Caption = "Datos Impresos..."
  Printer.CurrentX = 0
  Printer.EndDoc
  RaiseEvent TerminoConExito(MvarFormatoDoc.NumDocumento, MvarFormatoDoc.TotPaginas)
  Exit Sub
ErrorPRN:
  If cmdCancelar.Tag <> "CANCELAR" Then
    cmdImprimir.Visible = False
    cmdCancelar.Visible = False
    picBarraFija.Visible = False
    lblProceso.Caption = "Impresion con Error..."
  End If
  Printer.CurrentX = 0
  Printer.EndDoc
  If Mvar1Impreso Then
    MsgBox "Error despues de imprimir documento numero " & (MvarFormatoDoc.NumDocumento - 1) & ":" + vbCrLf + vbCrLf + Err.Description
    RaiseEvent TerminoConError(MvarFormatoDoc.NumDocumento - 1, MvarFormatoDoc.TotPaginas)
  Else
    MsgBox "No se imprimió ningún documento: " + MvarOrigen + vbCrLf + vbCrLf + Err.Description
    RaiseEvent NoInicio
  End If
  Exit Sub
  Resume
End Sub

Private Sub sbDireccionarCol()
  Dim LvarCol As Integer
  Dim LvarPos As Integer
  Dim LvarColSQL As Integer
  Dim LvarErr As Boolean
  Dim LvarHeight As Double
  
  MvarOrigen = "sbDireccionarCol"
  If MvarFormatoDoc.FMT01KEY = "" Then
    Err.Raise 1001, "soinPrintDocs.Imprimir", "El Formato de Impresión no tiene definido el campo para realizar el Corte por Número de Documento"
  End If
  MvarFormatoDoc.PtoColKEY = -1
  For LvarColSQL = 0 To MvarFormatoDoc.NumColSQL
    If UCase(MvarFormatoDoc.FMT01KEY) = UCase(MvarDatosCol(LvarColSQL)) Then
      MvarFormatoDoc.PtoColKEY = LvarColSQL
      Exit For
    End If
  Next LvarColSQL
  If MvarFormatoDoc.PtoColKEY = -1 Then
    Err.Raise 1002, "soinPrintDocs.Imprimir", "El dato '" + MvarFormatoDoc.FMT01KEY + "' definido como Numero de Consecutivo del Primer Documento en el Formato de Impresion no está incluido en la Consulta SQL de los Datos"
  ElseIf MvarFormatoDoc.NumDocumento <> MvarDatosLin(0, MvarFormatoDoc.PtoColKEY) Then
    Err.Raise 1003, , "El dato '" + MvarFormatoDoc.FMT01KEY + "=" & MvarFormatoDoc.NumDocumento & "' definido como Número Consecutivo del Primer Documento en el Formato de Impresion no coincide con el '" & MvarFormatoDoc.FMT01KEY & "=" & MvarDatosLin(0, MvarFormatoDoc.PtoColKEY) & "' de la Primera fila de datos "
  End If
  
  MvarPos(1).ColIni = -1
  MvarPos(2).ColIni = -1
  MvarPos(3).ColIni = -1
  For LvarCol = 0 To MvarFormatoDoc.NumColFMT
    'Procesa la POSicion: Direcciones y posiciones
    
    'Posicion: 1=Encabezado, 2=Detalle, 3=PostDetalle
    LvarPos = MvarFormatosCol(LvarCol).FMT02POS
    
    If LvarPos = 2 And MvarFormatosCol(LvarCol).FMT02AJU Then
      Err.Raise 1003, "soinPrintDocs.Imprimir", "El dato '" + MvarFormatosCol(LvarCol).FMT02SQL + "' del Formato de Impresion tiene definido el atributo de Ajuste y no está permitido en el detalle"
    End If
    
    Printer.FontName = MvarFormatosCol(LvarCol).FMT02TPL
    Printer.FontSize = MvarFormatosCol(LvarCol).FMT02TAM
    LvarHeight = Printer.TextHeight("Ñy")
    If MvarPos(LvarPos).ColIni = -1 Then
      'Direcciona unicamente el primer dato del formato de la POSicion
      MvarPos(LvarPos).ColIni = LvarCol
      'Coordenadas Iniciales
      MvarPos(LvarPos).PosTop = MvarFormatosCol(LvarCol).FMT02_Y
      MvarPos(LvarPos).PosLeft = MvarFormatosCol(LvarCol).FMT02_X
      MvarPos(LvarPos).PosRight = MvarFormatosCol(LvarCol).FMT02_X + MvarFormatosCol(LvarCol).FMT02LON
      MvarPos(LvarPos).PosBottom = MvarFormatosCol(LvarCol).FMT02_Y + LvarHeight
    Else
      'Coordenadas de extremos
      If MvarPos(LvarPos).PosTop > MvarFormatosCol(LvarCol).FMT02_Y Then
        MvarPos(LvarPos).PosTop = MvarFormatosCol(LvarCol).FMT02_Y
      End If
      If MvarPos(LvarPos).PosLeft > MvarFormatosCol(LvarCol).FMT02_X Then
        MvarPos(LvarPos).PosLeft = MvarFormatosCol(LvarCol).FMT02_X
      End If
      If MvarPos(LvarPos).PosRight < MvarFormatosCol(LvarCol).FMT02_X + MvarFormatosCol(LvarCol).FMT02LON Then
        MvarPos(LvarPos).PosRight = MvarFormatosCol(LvarCol).FMT02_X + MvarFormatosCol(LvarCol).FMT02LON
      End If
      If MvarPos(LvarPos).PosBottom < MvarFormatosCol(LvarCol).FMT02_Y + LvarHeight Then
        MvarPos(LvarPos).PosBottom = MvarFormatosCol(LvarCol).FMT02_Y + LvarHeight
      End If
    End If
    'Direcciona el ultimo dato del formato de la POSicion
    MvarPos(LvarPos).ColFin = LvarCol
    
    'Direcciona cada columna tipo dato del formato con la columna de los datos
    If MvarFormatosCol(LvarCol).FMT02TIP = 2 Then
      LvarErr = True
      For LvarColSQL = 0 To MvarFormatoDoc.NumColSQL
        If UCase(MvarFormatosCol(LvarCol).FMT02SQL) = UCase(MvarDatosCol(LvarColSQL)) Then
          MvarFormatosCol(LvarCol).PTODATOS = LvarColSQL
          LvarErr = False
          Exit For
        End If
      Next LvarColSQL
      If LvarErr Then
        Err.Raise 1004, "soinPrintDocs.Imprimir", "El dato '" + MvarFormatosCol(LvarCol).FMT02SQL + "' del Formato de Impresion no está incluido en la Consulta SQL de los Datos"
      End If
    Else
      MvarFormatosCol(LvarCol).PTODATOS = -1
    End If
  Next LvarCol

  If MvarPos(2).ColIni <> -1 And MvarPos(3).ColIni = -1 Then
    Err.Raise 1005, "soinPrintDocs.Imprimir", "El Formato de Impresión tiene líneas de detalle pero no se definieron líneas de postdetalle"
  End If
  If MvarPos(2).PosBottom > MvarPos(3).PosTop Then
    Err.Raise 1006, "soinPrintDocs.Imprimir", "Existen líneas de postdetalle que están encima del final de la línea de detalle"
  End If
End Sub

Private Function sbActualizaAvance(Optional vInicio As Boolean, Optional vTotal As Integer) As Integer
  Static LvarNum As Integer
  Static LvarTotal As Integer
  
  If vInicio Then
    LvarNum = 0
    LvarTotal = vTotal
  Else
    LvarNum = LvarNum + 1
  End If
  picBarraMovil.Width = picBarraFija.Width / LvarTotal * LvarNum
  DoEvents
End Function

Sub sbImprimeEncabezado(LvarLin As Integer, LvarNewPage As Boolean)
  MvarOrigen = "sbImprimeEncabezado"
  
  If LvarNewPage Then
    sbNewPage
  End If
  MvarFormatoDoc.TotPaginas = MvarFormatoDoc.TotPaginas + 1
  
  If MvarPos(1).ColIni <> -1 Then
    'La Posición Vertical es absoluta en Encabezados
    MvarCurrentY = 0    'MvarPos(1).PosTop
    sbImprimeFormato LvarLin, 1
  End If
  If MvarPos(2).ColIni <> -1 Then
    'La Posición Vertical es absoluta en la Primera Linea del Detalle
    'Las siguientes líneas de detalle son relativas a la anterior
    MvarCurrentY = 0    'MvarPos(2).PosTop
    MvarMasDetalle = 0  ' 0=No hay más detalles
  End If
End Sub

Sub sbImprimeDetalle(LvarLin As Integer)
  Dim LvarDetNoCabe       As Boolean
  MvarOrigen = "sbImprimeDetalle"
  
  If MvarPos(2).ColIni <> -1 Then
    Printer.FontBold = True
    Printer.FontName = "Courier New"
    Printer.FontSize = 10
    
    'Altura de la línea mas altura del mensaje caben con respecto a la posición del total
    LvarDetNoCabe = MvarCurrentY + (MvarPos(2).PosTop + MvarPos(2).PosBottom - MvarPos(2).PosTop + MvarEntreLin) + (Printer.TextHeight("*H8áLí") + MvarEntreLin) > MvarPos(3).PosTop
    If LvarDetNoCabe Then
      If MvarFormatoDoc.HacerCortePag Then
        'Imprime la leyenda de continuación
        Printer.CurrentY = MvarCurrentY + MvarPos(2).PosTop
        Printer.CurrentX = 2.56
        Printer.Print "*** CONTINUA EN LA SIGUIENTE PAGINA ***"
        'Salta de pagina e imprime el Encabezado
        
        sbImprimeEncabezado LvarLin, True
        'Imprime la siguiente linea (primera linea de la nueva pagina)
        sbImprimeFormato LvarLin, 2
        'La posición Vertical de las líneas de detalle son relativas a la anterior
        MvarCurrentY = MvarCurrentY + MvarPos(2).PosBottom - MvarPos(2).PosTop + MvarEntreLin
      Else
        'Se brinca las lineas de detalle que no caben en la pagina
        'La leyenda de mas detalles no impresos se imprime en el Total
        '  porque existe la posibilidad de que si solo es una línea sí se imprime
        MvarMasDetalle = MvarMasDetalle + 1
      End If
    Else
      'Imprime la siguiente linea
      sbImprimeFormato LvarLin, 2
      MvarCurrentY = MvarCurrentY + MvarPos(2).PosBottom - MvarPos(2).PosTop + MvarEntreLin
    End If
  End If
End Sub

Sub sbImprimeTotal(LvarLin As Integer)
  Dim LvarDetalleSiCabe As Boolean
  
  MvarOrigen = "sbImprimeTotal"
  
  'Se imprime LvarLin-1 porque LvarLin contiene en este momento el siguiente documento
  If MvarPos(3).ColIni <> -1 Then
    'Altura de la línea cabe con respecto a la posición del total
    LvarDetalleSiCabe = MvarCurrentY + (MvarPos(2).PosTop + MvarPos(2).PosBottom - MvarPos(2).PosTop + MvarEntreLin) <= MvarPos(3).PosTop
    If MvarMasDetalle = 1 And LvarDetalleSiCabe Then
      'Como solo hay una línea y cabe, sí se imprime
      sbImprimeFormato LvarLin - 1, 2
    ElseIf MvarMasDetalle > 1 Then
      'Se imprime la leyenda de que hay mas detalle no impresos
      Printer.FontBold = True
      Printer.FontName = "Courier New"
      Printer.FontSize = 10
      Printer.CurrentY = MvarCurrentY + MvarPos(2).PosTop
      Printer.CurrentX = 2.56
      If MvarMasDetalle = 1 Then
        Printer.Print "*** Hay una línea más de detalle ***"
      Else
        Printer.Print "*** Hay " & MvarMasDetalle & " líneas más de detalle ***"
      End If
    End If
    'La Posición Vertical es absoluta en Totales
    MvarCurrentY = 0  'MvarPos(3).PosTop
    sbImprimeFormato LvarLin - 1, 3
  End If
End Sub

Sub sbImprimeFormato(LvarLin As Integer, LvarPos As Integer)
  Dim LvarCol As Integer
  Dim LvarDato As String
  Dim LvarColor As String
  
  MvarOrigen = "sbImprimeFormato"
  If MvarPos(LvarPos).ColIni = -1 Then Exit Sub
  
  For LvarCol = MvarPos(LvarPos).ColIni To MvarPos(LvarPos).ColFin
    Printer.CurrentY = MvarCurrentY + MvarFormatosCol(LvarCol).FMT02_Y    'Posición Vertical   (equivale a CurrentY)
    Printer.CurrentX = MvarFormatosCol(LvarCol).FMT02_X                   'Posición Horizontal (equivale a CurrentX)
    If MvarFormatosCol(LvarCol).FMT02TIP = 1 Then                         'Tipo de Campo:  1=Etiqueta, 2=Dato
      LvarDato = MvarFormatosCol(LvarCol).FMT02SQL                        'Valor cuando tipo Etiqueta
    Else
      LvarDato = MvarDatosLin(LvarLin, MvarFormatosCol(LvarCol).PTODATOS) 'Puntero a la Columna en Datos
    End If
    'FORMATO
    'PREFIJO
    'SUFIJO
    LvarDato = MvarFormatosCol(LvarCol).FMT02PRE & fnPoneFormato(LvarDato, MvarFormatosCol(LvarCol).FMT02FMT) & MvarFormatosCol(LvarCol).FMT02SUF
    'MvarFormatosCol(LvarCol).FMT02DEC = vFMT02DEC                        'Decimales
    
    Printer.FontName = MvarFormatosCol(LvarCol).FMT02TPL                  'Fuente:   Arial, Courier, sans-serif
    Printer.FontSize = MvarFormatosCol(LvarCol).FMT02TAM                  'Tamaño Letra: 6 - 16
    Printer.FontBold = MvarFormatosCol(LvarCol).FMT02BOL                  'Negrita
    Printer.FontUnderline = MvarFormatosCol(LvarCol).FMT02UND             'Subrayado
    Printer.FontItalic = MvarFormatosCol(LvarCol).FMT02ITA                'Itálica
    
    'Color
    LvarColor = Trim(MvarFormatosCol(LvarCol).FMT02CLR)
    If Len(LvarColor) = 6 Then
      Printer.ForeColor = RGB(Val("&" & Mid(LvarColor, 1, 2)), Val("&" & Mid(LvarColor, 3, 2)), Val("&" & Mid(LvarColor, 5, 2)))
    End If
    
    'Ajusta Linea
    If MvarFormatosCol(LvarCol).FMT02AJU Then
      'Longitud
      'Alineacion: 1=Izquierda, 2=Centrado, 3=Derecha
      sbImprimeConAjuste LvarDato, MvarFormatosCol(LvarCol).FMT02JUS, MvarFormatosCol(LvarCol).FMT02LON
    Else
      'Longitud
      'Alineacion: 1=Izquierda, 2=Centrado, 3=Derecha
      sbImprimeSinAjuste LvarDato, MvarFormatosCol(LvarCol).FMT02JUS, MvarFormatosCol(LvarCol).FMT02LON
    End If
    
    'Salto de Página
    If MvarFormatosCol(LvarCol).FMT02PAG Then
      sbNewPage
      MvarFormatoDoc.TotPaginas = MvarFormatoDoc.TotPaginas + 1
    End If
  Next LvarCol
End Sub

Function fnPoneFormato(LvarDato, LvarFMT)
    Dim LvarDEC As String
    Dim LvarPto As Integer
    Dim LvarNum As String
    Dim LvarFecha As Date
    
    If LvarFMT = "-1" Then
       ' No hace nada
    ElseIf InStr(LvarFMT, "0") > 0 Or InStr(LvarFMT, "#") > 0 Then
        LvarNum = fnToNumero(LvarDato)
        If IsNumeric(LvarNum) Then
            If InStr(LvarFMT, ".") > 0 Then
                LvarDEC = Mid(LvarFMT, InStr(LvarFMT, "."))
            Else
                LvarDEC = ""
            End If
            If LvarFMT = "#" Then
                ' No hace nada
            ElseIf InStr(LvarFMT, ",") > 0 Then
                LvarFMT = "#,##0" & LvarDEC
            ElseIf InStr(LvarFMT, ",") > 0 Then
                LvarFMT = "0" & LvarDEC
            End If
            LvarDato = Format(LvarNum, LvarFMT)
        End If
    ElseIf UCase(LvarFMT) = "MONTOENLETRAS" Then
        LvarNum = fnToNumero(LvarDato)
        If IsNumeric(LvarNum) Then
            LvarDato = fnMontoEnLetras(LvarDato, MvarIdioma)
        End If
    ElseIf InStr(LCase(LvarFMT), "dd") + InStr(LCase(LvarFMT), "hh") > 0 Then
        LvarFecha = fnToFecha(LvarDato)
        If LvarFecha <> -1 Then
            If InStr(LCase(LvarFMT), "dd") > 0 Then
                LvarDato = Format(LvarFecha, LvarFMT)
            ElseIf InStr(LCase(LvarFMT), "hh") > 0 Then
                LvarFMT = Replace(LvarFMT, "mm", "nn")
                LvarDato = Format(LvarFecha, LvarFMT)
            End If
        End If
    ElseIf UCase(LvarFMT) = "FECHAENLETRAS" Then
        LvarFecha = fnToFecha(LvarDato)
        If LvarFecha <> -1 Then
            LvarDato = fnFechaEnLetras(LvarFecha, MvarIdioma)
        End If
    End If

    fnPoneFormato = LvarDato
End Function

Function fnToNumero(LvarDato) As String
    Dim LvarNum As String
    
    LvarNum = Replace(CStr(LvarDato), ",", "")
    If GvarPunto <> "." Then
        LvarNum = Replace(LvarNum, ".", GvarPunto)
    End If
    
    fnToNumero = LvarNum
End Function

Function fnToFecha(LvarDato) As Date
    Dim LvarFecha As Date
    Dim LvarHora  As Date
    
    LvarFecha = -1
    LvarHora = -1
    On Error Resume Next
    If Len(LvarDato) >= 10 Then
        'YYYY-MM-DD
        If (Mid(LvarDato, 5, 1) = "-" Or Mid(LvarDato, 5, 1) = "/") And _
           (Mid(LvarDato, 8, 1) = "-" Or Mid(LvarDato, 8, 1) = "/") Then
           LvarFecha = DateSerial(Mid(LvarDato, 1, 4), Mid(LvarDato, 6, 2), Mid(LvarDato, 9, 2))
        'DD-MM-YYYY
        ElseIf (Mid(LvarDato, 3, 1) = "-" Or Mid(LvarDato, 3, 1) = "/") And _
           (Mid(LvarDato, 6, 1) = "-" Or Mid(LvarDato, 6, 1) = "/") Then
            LvarFecha = DateSerial(Mid(LvarDato, 7, 4), Mid(LvarDato, 4, 2), Mid(LvarDato, 1, 2))
        End If
        If LvarFecha <> -1 And Len(LvarDato) >= 11 Then
            'YYYY-MM-DD HH:NN:SS'
            If Mid(LvarDato, 11, 1) = " " And Mid(LvarDato, 14, 1) = ":" And Mid(LvarDato, 17, 1) = ":" Then
                LvarHora = TimeSerial(Mid(LvarDato, 12, 2), Mid(LvarDato, 15, 2), Mid(LvarDato, 18, 2))
            End If
        
            If LvarHora <> -1 Then
                If InStr(20, UCase(LvarDato), "PM") + InStr(20, UCase(LvarDato), "P.M.") > 0 Then
                    LvarHora = LvarHora + 0.5
                End If
                LvarFecha = LvarFecha + LvarHora
            Else
                LvarFecha = -1
            End If
        End If
    End If
    
    fnToFecha = LvarFecha
End Function

Sub sbImprimeImagenes()
  Dim I As Integer
  Dim LvarColor As Long
  Dim LvarBackColor As Long
  
  If MvarImgI = 0 Then
    Exit Sub
  End If
  
  MvarOrigen = "sbImprimeImagenes"
  For I = 0 To MvarImgI - 1
    'Falta MvarFormatosLin(i).FMT09GRS
    LvarBackColor = fnRGB(MvarFormatosImg(I).FMT03CFN, -1)
    If LvarBackColor <> -1 Then
      Printer.Line (MvarFormatosImg(I).FMT03_X, MvarFormatosImg(I).FMT03_Y)-Step(MvarFormatosImg(I).FMT03ANC, MvarFormatosImg(I).FMT03ALT), LvarBackColor, BF
    End If
    If MvarFormatosImg(I).Imagen <> "" Then
      Printer.PaintPicture LoadPicture(MvarFormatosImg(I).Imagen), MvarFormatosImg(I).FMT03_X, MvarFormatosImg(I).FMT03_Y, MvarFormatosImg(I).FMT03ANC, MvarFormatosImg(I).FMT03ALT
    End If
    
    If MvarFormatosImg(I).FMT03BOR Then
      LvarColor = fnRGB(MvarFormatosImg(I).FMT03CBR, 0)
      Printer.Line (MvarFormatosImg(I).FMT03_X, MvarFormatosImg(I).FMT03_Y)-Step(MvarFormatosImg(I).FMT03ANC, MvarFormatosImg(I).FMT03ALT), LvarColor, B
    End If
  Next I
End Sub

Sub sbImprimeLineas()
  Dim I As Integer
  Dim LvarColor As Long
  Dim LvarBackColor As Long
  
  If MvarLinI = 0 Then
    Exit Sub
  End If
  MvarOrigen = "sbImprimeLineas"
  
  For I = 0 To MvarLinI - 1
    'Falta MvarFormatosLin(i).FMT09GRS
    LvarColor = fnRGB(MvarFormatosLin(I).FMT09CLR, 0)
    If MvarFormatosLin(I).FMT09ANC > 0 And MvarFormatosLin(I).FMT09ALT > 0 Then
      'Imprime un cuadro
      LvarBackColor = fnRGB(MvarFormatosLin(I).FMT09CFN, -1)
      If LvarBackColor <> -1 Then
        Printer.Line (MvarFormatosLin(I).FMT09_X, MvarFormatosLin(I).FMT09_Y)-Step(MvarFormatosLin(I).FMT09ANC, MvarFormatosLin(I).FMT09ALT), LvarBackColor, BF
      End If
      Printer.Line (MvarFormatosLin(I).FMT09_X, MvarFormatosLin(I).FMT09_Y)-Step(MvarFormatosLin(I).FMT09ANC, MvarFormatosLin(I).FMT09ALT), LvarColor, B
    Else
      'Imprime una Linea
      Printer.Line (MvarFormatosLin(I).FMT09_X, MvarFormatosLin(I).FMT09_Y)-Step(MvarFormatosLin(I).FMT09ANC, MvarFormatosLin(I).FMT09ALT), LvarColor
    End If
  Next I
End Sub

Private Sub sbImprimeConAjuste(LvarDato As String, LvarAlineacion As Integer, LvarLongitud As Double)
  Dim LvarCurrentY As Double
  Dim LvarCurrentX As Double
  Dim LvarIni As Integer
  Dim LvarFin As Integer
  Dim LvarPto As Integer
  Dim LvarPto10 As Integer
  Dim LvarPto13 As Integer
  Dim LvarLinea As Integer
  
  MvarOrigen = "sbImprimeConAjuste"
  LvarCurrentY = Printer.CurrentY
  LvarCurrentX = Printer.CurrentX
  
  LvarDato = RTrim(LvarDato) + " "
  LvarIni = 1
  Do While LvarIni < Len(LvarDato) And LvarCurrentY + Printer.TextHeight("Ñy") + MvarEntreLin < MvarFormatoDoc.FMT01LAR
    Printer.CurrentX = LvarCurrentX
    Printer.CurrentY = LvarCurrentY
    LvarFin = Len(LvarDato)
    
    LvarPto13 = InStr(LvarIni, LvarDato, Chr(13))
    LvarPto10 = InStr(LvarIni, LvarDato, Chr(10))
    If LvarPto13 > 0 And LvarPto13 < LvarPto10 Then
      LvarFin = LvarPto13
      Mid(LvarDato, LvarFin, 1) = " "
    ElseIf LvarPto10 > 0 And LvarPto10 < LvarPto13 Then
      LvarFin = LvarPto10
      Mid(LvarDato, LvarFin, 1) = " "
    End If
    
    Do Until Printer.TextWidth(RTrim(Mid(LvarDato, LvarIni, LvarFin - LvarIni + 1))) <= LvarLongitud
      LvarFin = LvarFin - 1
      If LvarFin < LvarIni Then
        LvarDato = ""
        Exit Do
      End If
    Loop
    
    If LvarDato = "" Then
      Exit Do
    End If
    
    LvarPto = LvarFin
    Do Until Mid(LvarDato, LvarPto, 1) = " "
      LvarPto = LvarPto - 1
      If LvarPto <= 0 Then
        Exit Do
      End If
    Loop
    If LvarPto > 0 Then
      LvarFin = LvarPto
    End If
    
    sbImprimeDato RTrim(Mid(LvarDato, LvarIni, LvarFin - LvarIni + 1)), LvarAlineacion, LvarLongitud
    
    LvarCurrentY = LvarCurrentY + Printer.TextHeight("Ñy") + MvarEntreLin
    
    LvarIni = LvarFin + 1
    If LvarFin = LvarPto13 Then
      If LvarIni = LvarPto10 Then
        LvarIni = LvarIni + 1
      End If
    ElseIf LvarFin = LvarPto10 Then
      If LvarIni = LvarPto13 Then
        LvarIni = LvarIni + 1
      End If
    End If
  Loop
End Sub

Sub sbImprimeSinAjuste(LvarDato As String, LvarAlineacion As Integer, LvarLongitud As Double)
  MvarOrigen = "sbImprimeSinAjuste"
  On Error Resume Next
  Err.Clear
  If InStr(LvarDato, Chr(13)) > 0 Then
    LvarDato = Left(LvarDato, InStr(LvarDato, Chr(13)) - 1)
    If Err.Number <> 0 Then LvarDato = ""
  End If
  
  If InStr(LvarDato, Chr(10)) > 0 Then
    LvarDato = Left(LvarDato, InStr(LvarDato, Chr(10)) - 1)
    If Err.Number <> 0 Then LvarDato = ""
  End If
  
  Do Until Printer.TextWidth(LvarDato) <= LvarLongitud
    LvarDato = RTrim(Mid(LvarDato, 1, Len(LvarDato) - 1))
    If Err.Number <> 0 Then LvarDato = ""
  Loop
  On Error GoTo 0
  
  If LvarDato <> "" Then
    sbImprimeDato RTrim(LvarDato), LvarAlineacion, LvarLongitud
  End If
End Sub

Sub sbImprimeDato(LvarDato As String, LvarAlineacion As Integer, LvarLongitud As Double)
  If LvarAlineacion = 2 Then
    'Centrado
    Printer.CurrentX = Printer.CurrentX + ((LvarLongitud - Printer.TextWidth(LvarDato)) / 2)
  ElseIf LvarAlineacion = 3 Then
    'Derecha
    Printer.CurrentX = Printer.CurrentX + LvarLongitud - Printer.TextWidth(LvarDato)
  End If
  
  Printer.Print LvarDato
End Sub

Function fnRGB(ByVal LvarColor As String, LvarDefault As Long) As Long
  Dim I As Integer
  Dim LvarHex As String
    
  LvarColor = UCase(Trim(LvarColor))
  If Len(LvarColor) <> 6 Then
    fnRGB = LvarDefault
    Exit Function
  End If
    
  For I = 1 To 6
    LvarHex = Mid(LvarColor, I, 1)
    If InStr(LvarHex, "0123456789ABCDEF") = 0 Then
      fnRGB = LvarDefault
      Exit Function
    End If
  Next I
  fnRGB = RGB(Val("&" & Mid(LvarColor, 1, 2)), Val("&" & Mid(LvarColor, 3, 2)), Val("&" & Mid(LvarColor, 5, 2)))
End Function

Sub sbNewPage()
  sbImprimeLineas
  Printer.NewPage
  sbImprimeImagenes
End Sub
