VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsFormatoCol"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Public FMT02POS As Integer 'Posicion:  1=Encabezado, 2=Detalle, 3=PostDetalle
Public FMT02_X  As Double  'Posición Horizontal (equivale a CurrentX)
Public FMT02_Y  As Double  'Posición Vertical   (equivale a CurrentY)

Public FMT02TIP As Integer 'Tipo de Campo: 1=Etiqueta, 2=Dato
Public FMT02SQL As String  'Campo cuando tipo Dato o Valor cuando Etiquetas
Public FMT02AJU As Boolean 'Ajusta Linea
Public FMT02FMT As String  'Formato
Public FMT02LON As Double  'Longitud
Public FMT02DEC As Integer 'Decimales
Public FMT02JUS As Integer 'Alineacion:  1=Izquierda, 2=Centrado, 3=Derecha
Public FMT02TPL As String  'Fuente:    Arial, Courier, sans-serif
Public FMT02TAM As Integer 'Tamaño Letra:  6 - 16
Public FMT02CLR As String  'Color
Public FMT02BOL As Boolean 'Negrita
Public FMT02UND As Boolean 'Subrayado
Public FMT02ITA As Boolean 'Itálica
Public FMT02PAG As Boolean 'Salto de Página

Public FMT02PRE As String  'PREFIJO
Public FMT02SUF As String  'SUFIJO

Public PTODATOS As Integer 'Puntero a la columna de Datos

