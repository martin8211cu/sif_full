Attribute VB_Name = "vbLetras"
Option Explicit
Private LvarLetras(1 To 2, 1 To 3, 1 To 29)  As String
Private LvarInicializado    As Boolean

Public Function fnMontoEnLetras(ByVal pMonto As String, pIngles As Integer) As String
    'Ingles =
    '   0   Español
    '   1   USA
    '   2   Inglaterra
    Dim LvarGrupoEnLetras   As String
    Dim LvarGrupoAnterior   As String
    Dim LvarMonto           As String
    Dim LvarMiles           As Boolean
    Dim LvarDecimales       As String
    Dim LvarGrupos()        As String
    Dim LvarGruposN         As Integer
    Dim LvarGrupoI          As Integer
    Dim LvarGrupoJ          As Integer
    Dim LvarEnLetras        As String
    Dim LvarPlural          As String
        
    If Not LvarInicializado Then
        sbCargarLetras
        LvarInicializado = True
        
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
    End If
    If pIngles > 2 Then
        Err.Raise 100010, , "ERROR Idioma no definido: " & pIngles
    End If
    
    LvarGrupoEnLetras = ""
    LvarGrupoAnterior = ""
    pMonto = Replace(pMonto, ",", "")
    If Not IsNumeric(pMonto) Then
        fnMontoEnLetras = pMonto
        Exit Function
    End If
    
    LvarMonto = NumberFormat(pMonto)
    LvarDecimales = Mid(LvarMonto, find(".", LvarMonto) + 1, 2)
    LvarGruposN = 0
    LvarEnLetras = ""

    LvarMonto = Mid(LvarMonto, 1, find(".", LvarMonto) - 1)
    LvarGrupos = listToArray(LvarMonto)
    LvarGruposN = UBound(LvarGrupos)
    If Abs(pMonto) < 1 Then
        If pIngles = 0 Then
            LvarEnLetras = "Cero"
        Else
            LvarEnLetras = "Zero"
        End If
    Else
        For LvarGrupoI = 1 To LvarGruposN
            LvarGrupoJ = LvarGruposN - LvarGrupoI + 1
            LvarMiles = (LvarGrupoI Mod 2 = 0)
            LvarGrupoEnLetras = fnProcesaGrupo(LvarGrupos(LvarGrupoJ), LvarGrupoI, pIngles)
            If LvarGrupoJ = 1 Then
                LvarGrupoAnterior = ""
            ElseIf LvarGrupos(LvarGrupoJ - 1) = "000" Then
                LvarGrupoAnterior = ""
            Else
                LvarGrupoAnterior = "1"
            End If
            If pIngles = 0 Then
                If LvarMiles And LvarGrupoEnLetras <> "mil" And LvarGrupoEnLetras <> "" Then
                    LvarGrupoEnLetras = LvarGrupoEnLetras & "mil"
                ElseIf LvarGrupoEnLetras <> "" Or LvarGrupoAnterior <> "" Then
                    If LvarGrupos(LvarGrupoJ) = "001" And LvarGrupoAnterior = "" Then
                        LvarPlural = "ón"
                    Else
                        LvarPlural = "ones"
                    End If
                    If LvarGrupoI = 3 Then
                        LvarGrupoEnLetras = LvarGrupoEnLetras & "mill" & LvarPlural
                    ElseIf LvarGrupoI = 5 Then
                            LvarGrupoEnLetras = LvarGrupoEnLetras & "bill" & LvarPlural
                    ElseIf LvarGrupoI = 7 Then
                            LvarGrupoEnLetras = LvarGrupoEnLetras & "trill" & LvarPlural
                    ElseIf LvarGrupoI = 9 Then
                            LvarGrupoEnLetras = LvarGrupoEnLetras & "cuatrill" & LvarPlural
                    End If
                End If
            ElseIf pIngles = 1 Then
                If LvarGrupoEnLetras <> "" Then
                    If LvarGrupos(LvarGrupoJ) = "001" Then
                        LvarPlural = ""
                    Else
                        LvarPlural = "s"
                    End If
                    If LvarGrupoI = 2 Then
                        LvarGrupoEnLetras = LvarGrupoEnLetras & "thousand"
                    ElseIf LvarGrupoI = 3 Then
                        LvarGrupoEnLetras = LvarGrupoEnLetras & "million" & LvarPlural
                    ElseIf LvarGrupoI = 4 Then
                        LvarGrupoEnLetras = LvarGrupoEnLetras & "billion" & LvarPlural
                    ElseIf LvarGrupoI = 5 Then
                        LvarGrupoEnLetras = LvarGrupoEnLetras & "trillion" & LvarPlural
                    ElseIf LvarGrupoI = 6 Then
                        LvarGrupoEnLetras = LvarGrupoEnLetras & "quadrillion" & LvarPlural
                    ElseIf LvarGrupoI = 7 Then
                        LvarGrupoEnLetras = LvarGrupoEnLetras & "quintillion" & LvarPlural
                    ElseIf LvarGrupoI = 8 Then
                        LvarGrupoEnLetras = LvarGrupoEnLetras & "sextillion" & LvarPlural
                    ElseIf LvarGrupoI = 9 Then
                        LvarGrupoEnLetras = LvarGrupoEnLetras & "septillion" & LvarPlural
                    End If
                 End If
            Else
                If LvarGrupos(LvarGrupoJ) = "001" And (LvarGrupoAnterior = "" Or LvarMiles) Then
                    LvarPlural = ""
                Else
                    LvarPlural = "s"
                End If
                If LvarMiles And LvarGrupoEnLetras <> "" Then
                    LvarGrupoEnLetras = LvarGrupoEnLetras & "thousand"
                ElseIf LvarGrupoEnLetras <> "" Or LvarGrupoAnterior <> "" Then
                    If LvarGrupoI = 3 Then
                        LvarGrupoEnLetras = LvarGrupoEnLetras & "million" & LvarPlural
                    ElseIf LvarGrupoI = 5 Then
                        LvarGrupoEnLetras = LvarGrupoEnLetras & "billion" & LvarPlural
                    ElseIf LvarGrupoI = 7 Then
                        LvarGrupoEnLetras = LvarGrupoEnLetras & "trillion" & LvarPlural
                    ElseIf LvarGrupoI = 9 Then
                        LvarGrupoEnLetras = LvarGrupoEnLetras & "quadrillion" & LvarPlural
                    End If
                End If
            End If
            LvarEnLetras = LvarGrupoEnLetras & " " & Trim(LvarEnLetras)
        Next LvarGrupoI
    End If
    If pIngles = 0 Then
        LvarEnLetras = Trim(LvarEnLetras) & " con " & LvarDecimales & "/100"
    Else
        LvarEnLetras = Trim(LvarEnLetras) & " and " & LvarDecimales & "/100"
    End If
    Mid(LvarEnLetras, 1, 1) = UCase(Mid(LvarEnLetras, 1, 1))
    fnMontoEnLetras = LvarEnLetras
End Function
        
Private Function fnProcesaGrupo(pGrupo As String, pGrupoI As Integer, pIngles As Integer) As String
    Dim LvarGrupoEnLetras As String
    Dim LvarDimIdioma As Integer
    Dim LvarIndex1 As Integer
    Dim LvarIndex2 As Integer
    Dim LvarIndex3 As Integer
    Dim LvarMiles As Boolean
    
    LvarGrupoEnLetras = ""

    If pIngles = 0 Then
        LvarDimIdioma = 1
    Else
        LvarDimIdioma = 2
    End If
    pGrupo = Right("000" & pGrupo, 3)
    If pGrupo = "000" Then
        fnProcesaGrupo = ""
        Exit Function
    ElseIf pGrupo = "001" And pIngles = 0 Then
        LvarMiles = (pGrupoI Mod 2 = 0)
        If LvarMiles Then
            fnProcesaGrupo = "mil"    ' Eliminar si se quiere '... un mil'
            Exit Function
        End If
    ElseIf pGrupo = "100" And pIngles = 0 Then
        fnProcesaGrupo = "cien "
        Exit Function
    End If
    
    LvarGrupoEnLetras = ""
    LvarIndex1 = Val(Mid(pGrupo, 1, 1))
    If (LvarIndex1 > 0) Then
        LvarGrupoEnLetras = LvarLetras(LvarDimIdioma, 1, LvarIndex1) & " "
    End If

    LvarIndex1 = Val(Mid(pGrupo, 2, 2))
    LvarIndex2 = Val(Mid(pGrupo, 2, 1))
    LvarIndex3 = Val(Mid(pGrupo, 3, 1))
    If (LvarIndex1 > 0 And LvarIndex1 < 30 And pIngles = 0) Then
        LvarGrupoEnLetras = LvarGrupoEnLetras & LvarLetras(LvarDimIdioma, 3, LvarIndex1)
    ElseIf (LvarIndex1 > 0 And LvarIndex1 < 20 And pIngles <> 0) Then
        LvarGrupoEnLetras = LvarGrupoEnLetras & LvarLetras(LvarDimIdioma, 3, LvarIndex1)
    Else
        If (LvarIndex2 > 0) Then
            LvarGrupoEnLetras = LvarGrupoEnLetras & LvarLetras(LvarDimIdioma, 2, LvarIndex2)
        End If
        If (LvarIndex3 > 0) Then
            If (LvarIndex2 > 0) Then
                If (pIngles = 0) Then
                    LvarGrupoEnLetras = Trim(LvarGrupoEnLetras) & " y "
                Else
                    LvarGrupoEnLetras = Trim(LvarGrupoEnLetras) & " "
                End If
            End If
            LvarGrupoEnLetras = LvarGrupoEnLetras & LvarLetras(LvarDimIdioma, 3, LvarIndex3)
        End If
    End If

    ' Convierte el valor '1' en las unidades de 'un' a 'uno' (excepto en '11')
    If (pGrupoI = 1 And LvarIndex3 = 1 And LvarIndex1 <> 11 And pIngles = 0) Then
        LvarGrupoEnLetras = LvarGrupoEnLetras & "o"
    End If

    LvarGrupoEnLetras = Trim(LvarGrupoEnLetras) & " "
    fnProcesaGrupo = LvarGrupoEnLetras
    Exit Function
End Function

Function find(pSubstr, pString, Optional pStart As Integer) As Integer
    If pStart = 0 Then
        find = InStr(pString, pSubstr)
    Else
        find = InStr(pStart, pString, pSubstr)
    End If
End Function

Function listToArray(pList As String) As String()
    Dim I As Integer
    Dim j As Integer
    Dim LvarLista() As String
    Dim LvarChar    As String
    j = 1
    ReDim LvarLista(1 To j)
    For I = 1 To Len(pList)
        LvarChar = Mid(pList, I, 1)
        If LvarChar = "," Then
            j = j + 1
            ReDim Preserve LvarLista(1 To j)
        Else
            LvarLista(j) = LvarLista(j) + LvarChar
        End If
    Next I
    listToArray = LvarLista()
End Function

Function NumberFormat(ByVal pMonto As String) As String
    Dim I
    
    pMonto = Trim(pMonto)
    If Mid(pMonto, 1, 1) = "-" Then
        pMonto = Mid(pMonto, 2)
    End If
    If GvarPunto <> "." Then
        pMonto = Replace(pMonto, ".", GvarPunto)
    End If
    
    pMonto = Format(pMonto, "#,##0.00")
    If GvarComa <> "," Then
        pMonto = Replace(pMonto, GvarComa, ",")
    End If
    If GvarPunto <> "." Or GvarComa = "." Then
        Mid(pMonto, Len(pMonto) - 2, 1) = "."
    End If
    
    NumberFormat = pMonto
End Function

Sub sbCargarLetras()
    LvarLetras(1, 1, 1) = "ciento"
    LvarLetras(1, 1, 2) = "doscientos"
    LvarLetras(1, 1, 3) = "trescientos"
    LvarLetras(1, 1, 4) = "cuatrocientos"
    LvarLetras(1, 1, 5) = "quinientos"
    LvarLetras(1, 1, 6) = "seiscientos"
    LvarLetras(1, 1, 7) = "setecientos"
    LvarLetras(1, 1, 8) = "ochocientos"
    LvarLetras(1, 1, 9) = "novecientos"

    LvarLetras(1, 2, 1) = "diez"
    LvarLetras(1, 2, 2) = "veinte"
    LvarLetras(1, 2, 3) = "treinta"
    LvarLetras(1, 2, 4) = "cuarenta"
    LvarLetras(1, 2, 5) = "cincuenta"
    LvarLetras(1, 2, 6) = "sesenta"
    LvarLetras(1, 2, 7) = "setenta"
    LvarLetras(1, 2, 8) = "ochenta"
    LvarLetras(1, 2, 9) = "noventa"
    
    LvarLetras(1, 3, 1) = "un"
    LvarLetras(1, 3, 2) = "dos"
    LvarLetras(1, 3, 3) = "tres"
    LvarLetras(1, 3, 4) = "cuatro"
    LvarLetras(1, 3, 5) = "cinco"
    LvarLetras(1, 3, 6) = "seis"
    LvarLetras(1, 3, 7) = "siete"
    LvarLetras(1, 3, 8) = "ocho"
    LvarLetras(1, 3, 9) = "nueve"
    LvarLetras(1, 3, 10) = "diez"
    LvarLetras(1, 3, 11) = "once"
    LvarLetras(1, 3, 12) = "doce"
    LvarLetras(1, 3, 13) = "trece"
    LvarLetras(1, 3, 14) = "catorce"
    LvarLetras(1, 3, 15) = "quince"
    LvarLetras(1, 3, 16) = "dieciseis"
    LvarLetras(1, 3, 17) = "diecisiete"
    LvarLetras(1, 3, 18) = "dieciocho"
    LvarLetras(1, 3, 19) = "diecinueve"
    LvarLetras(1, 3, 20) = "veinte"
    LvarLetras(1, 3, 21) = "veintiun"
    LvarLetras(1, 3, 22) = "veintidos"
    LvarLetras(1, 3, 23) = "veintitres"
    LvarLetras(1, 3, 24) = "veinticuatro"
    LvarLetras(1, 3, 25) = "veinticinco"
    LvarLetras(1, 3, 26) = "veintiseis"
    LvarLetras(1, 3, 27) = "veintisiete"
    LvarLetras(1, 3, 28) = "veintiocho"
    LvarLetras(1, 3, 29) = "veintinueve"
    
    
    LvarLetras(2, 1, 1) = "one hundred"
    LvarLetras(2, 1, 2) = "two hundred"
    LvarLetras(2, 1, 3) = "three hundred"
    LvarLetras(2, 1, 4) = "four hundred"
    LvarLetras(2, 1, 5) = "five hundred"
    LvarLetras(2, 1, 6) = "six hundred"
    LvarLetras(2, 1, 7) = "seven hundred"
    LvarLetras(2, 1, 8) = "eight hundred"
    LvarLetras(2, 1, 9) = "nine hundred"

    LvarLetras(2, 2, 1) = "ten"
    LvarLetras(2, 2, 2) = "twenty"
    LvarLetras(2, 2, 3) = "thirty"
    LvarLetras(2, 2, 4) = "forty"
    LvarLetras(2, 2, 5) = "fifty"
    LvarLetras(2, 2, 6) = "sixty"
    LvarLetras(2, 2, 7) = "seventy"
    LvarLetras(2, 2, 8) = "eighty"
    LvarLetras(2, 2, 9) = "ninety"
    
    LvarLetras(2, 3, 1) = "one"
    LvarLetras(2, 3, 2) = "two"
    LvarLetras(2, 3, 3) = "three"
    LvarLetras(2, 3, 4) = "four"
    LvarLetras(2, 3, 5) = "five"
    LvarLetras(2, 3, 6) = "six"
    LvarLetras(2, 3, 7) = "seven"
    LvarLetras(2, 3, 8) = "eight"
    LvarLetras(2, 3, 9) = "nine"
    LvarLetras(2, 3, 10) = "ten"
    LvarLetras(2, 3, 11) = "eleven"
    LvarLetras(2, 3, 12) = "twelve"
    LvarLetras(2, 3, 13) = "thirteen"
    LvarLetras(2, 3, 14) = "fourteen"
    LvarLetras(2, 3, 15) = "fifteen"
    LvarLetras(2, 3, 16) = "sixteen"
    LvarLetras(2, 3, 17) = "seventeen"
    LvarLetras(2, 3, 18) = "eighteen"
    LvarLetras(2, 3, 19) = "nineteen"
    LvarLetras(2, 3, 20) = "twenty"
End Sub

Public Function fnFechaEnLetras(ByVal pFecha As Date, pIngles As Integer) As String
    'Ingles =
    '   0   Español
    '   1   USA
    '   2   Inglaterra
    
    Dim LvarMes   As String
    
    If pIngles > 2 Then
        Err.Raise 100010, , "ERROR Idioma no definido: " & pIngles
    End If
    
    LvarMes = Format(DatePart("m", pFecha), "00")
    If pIngles = 0 Then
        If LvarMes = "01" Then
            LvarMes = "Enero"
        ElseIf LvarMes = "02" Then
            LvarMes = "Febrero"
        ElseIf LvarMes = "03" Then
            LvarMes = "Marzo"
        ElseIf LvarMes = "04" Then
            LvarMes = "Abril"
        ElseIf LvarMes = "05" Then
            LvarMes = "Mayo"
        ElseIf LvarMes = "06" Then
            LvarMes = "Junio"
        ElseIf LvarMes = "07" Then
            LvarMes = "Julio"
        ElseIf LvarMes = "08" Then
            LvarMes = "Agosto"
        ElseIf LvarMes = "09" Then
            LvarMes = "Septiembre"
        ElseIf LvarMes = "10" Then
            LvarMes = "Octubre"
        ElseIf LvarMes = "11" Then
            LvarMes = "Noviembre"
        ElseIf LvarMes = "12" Then
            LvarMes = "Diciembre"
        End If
        fnFechaEnLetras = Format(pFecha, "d") & " de " & LvarMes & " de " & Format(pFecha, "yyyy")
    Else
        If LvarMes = "01" Then
            LvarMes = "January"
        ElseIf LvarMes = "02" Then
            LvarMes = "February"
        ElseIf LvarMes = "03" Then
            LvarMes = "March"
        ElseIf LvarMes = "04" Then
            LvarMes = "April"
        ElseIf LvarMes = "05" Then
            LvarMes = "May"
        ElseIf LvarMes = "06" Then
            LvarMes = "June"
        ElseIf LvarMes = "07" Then
            LvarMes = "July"
        ElseIf LvarMes = "08" Then
            LvarMes = "August"
        ElseIf LvarMes = "09" Then
            LvarMes = "September"
        ElseIf LvarMes = "10" Then
            LvarMes = "October"
        ElseIf LvarMes = "11" Then
            LvarMes = "November"
        ElseIf LvarMes = "12" Then
            LvarMes = "December"
        End If
        fnFechaEnLetras = LvarMes & " " & Format(pFecha, "d") & ", " & Format(pFecha, "yyyy")
    End If
End Function

