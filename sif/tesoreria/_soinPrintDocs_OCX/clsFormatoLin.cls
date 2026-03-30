VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsFormatoLin"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Public FMT09_X  As Double  'Posición inicial Horizontal
Public FMT09_Y  As Double  'Posición inicial Vertical

Public FMT09CLR As String  'Color de Borde
Public FMT09ALT As Double  'Altura de la linea
Public FMT09ANC As Double  'Ancho de la linea
Public FMT09GRS As Boolean 'Grosor de la Linea
Public FMT09CFN As String  'Color de Fondo

