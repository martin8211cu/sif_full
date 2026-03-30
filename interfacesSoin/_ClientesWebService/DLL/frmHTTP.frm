VERSION 5.00
Object = "{48E59290-9880-11CF-9754-00AA00C00908}#1.0#0"; "MSINET.OCX"
Begin VB.Form frmHTTP 
   Caption         =   "Form1"
   ClientHeight    =   915
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   1560
   LinkTopic       =   "Form1"
   ScaleHeight     =   915
   ScaleWidth      =   1560
   StartUpPosition =   3  'Windows Default
   Begin InetCtlsObjects.Inet Conn 
      Left            =   480
      Top             =   120
      _ExtentX        =   1005
      _ExtentY        =   1005
      _Version        =   393216
   End
End
Attribute VB_Name = "frmHTTP"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
