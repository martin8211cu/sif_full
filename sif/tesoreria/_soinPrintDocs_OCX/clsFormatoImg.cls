VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsFormatoImg"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Public FMT03_X  As Double  'Posición Inicial Horizontal
Public FMT03_Y  As Double  'Posición Inicial Vertical

Public FMT03ALT As Double  'Altura de la imagen
Public FMT03ANC As Double  'Ancho de la imagen
Public FMT03BOR As Boolean 'Tiene Borde
Public FMT03CFN As String  'Color de Fondo
Public FMT03CBR As String  'Color de Borde
Public FMT03EMP As String  'Es logo de Empresa

Public Imagen   As String  'Nombre del Archivo
