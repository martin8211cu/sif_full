VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsFormatoDoc"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Public FMT01COD As String  'Codigo Formato
Public FMT01DES As String  'Descripción
Public FMT01TIP As String  'Tipo de Formato
Public FMT01KEY As String  'Campo del Numero Doc para corte
Public FMT01TOT As Integer 'Lineas Formato TOTAL
Public FMT01LIN As Integer 'Lineas Encabezado
Public FMT01DET As Integer 'Lineas Detalle
Public FMT01PDT As Integer 'Lineas PostDetalle
Public FMT01SPC As Double  'Espacio entre Lineas Detalle
Public FMT01ENT As Boolean 'Mantener retorno de Linea
Public FMT01REF As String  'Referencia

Public FMT01LAR As Double  'Alto o Largo
Public FMT01ANC As Double  'Ancho

Public FMT01ORI As Integer 'Orientación: 1=Vertical, 0=Horizontal

Public FMT01LFT As Double  'Margen Izquierdo
Public FMT01TOP As Double  'Margen Superior
Public FMT01RGT As Double  'Margen Derecho
Public FMT01BOT As Double  'Margen Inferior

Public NumColFMT     As Integer    'Numero de columnas en el formato
Public NumColSQL     As Integer    'Numero de columnas en datos
Public NumFilSQL     As Integer    'Numero de filas en datos
Public NumDocumento  As Variant    'Numero del formulario de Documento inicial (Decimal)
Public NumLineas     As Integer
Public NumImagenes   As Integer
Public TotDocumentos As Integer    'Total de Documentos a imprimir
Public TotPaginas    As Integer    'Total de Paginas impresas
Public PtoColKEY     As Integer    'Puntero al Campo del Numero Doc para corte

Public HacerCortePag As Boolean    'Indica si hace corte de pagina o pone leyenda de mas detalles sin imprimir
