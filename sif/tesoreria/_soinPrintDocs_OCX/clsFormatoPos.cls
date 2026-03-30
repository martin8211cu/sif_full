VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsFormatoPos"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Public ColIni     As Integer  'Primera Col
Public ColFin     As Integer  'Ultima Col
Public PosTop     As Double   'Posicion mas alta
Public PosBottom  As Double   'Posicion+altura mas baja
Public PosLeft    As Double   'Posicion mas a la izquierda
Public PosRight   As Double   'Posicion+ancho mas a la derecha


