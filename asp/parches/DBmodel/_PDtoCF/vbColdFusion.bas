Declare Function SendMessage Lib "User32" Alias _
                               "SendMessageA" ( _
                               ByVal hWnd As Long, ByVal _
                               wMsg As Long, ByVal _
                               wParam As Long, ByVal lParam _
                               As Any) As Long
Public Const LB_SETTABSTOPS = &H192


'Global GvarPD    As PdCommon.Application
'Global GvarPDM   As PdPDM.Model
Public GvarPD As Object
Public GvarPDM As Object

Public GvarTBLs()
Public GvarFileName As String
Public GvarCFproject As String


Public GvarTipoConsulta As String


