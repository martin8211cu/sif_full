Public Class frmGenerar
    Private GvarIDXs As New Collection
    Private GvarFKs As New Collection
    Private GvarTabs As New Collection
    Private GvarTabsN As Integer
    Private GvarSalvar As Boolean
    Private GvarPD As New PdCommon.Application
    Private GvarSVN As New LibSubWCRev.SubWCRev
    Private GvarWS As New DBmodel.WSService
    'Private GvarIE As SHDocVw.ShellBrowserWindow

    Private GvarPDM As PdPDM.Model
    Private GvarUID As String
    Private GvarPDMfile As String
    Private GvarPDMname As String

    Private Structure tipoLon
        Public LvarTipo As String
        Public LvarTipo2 As String
        Public LvarLong As String
        Public LvarDecs As String
    End Structure



    Private Sub sbSetPDMfile(ByVal LprmPDMfile As String)
        GvarPDMfile = LprmPDMfile
        If LprmPDMfile = "" Then
            GvarPDMname = ""
        Else
            Dim LvarFileNames As String() = LprmPDMfile.Split("\")
            GvarPDMname = LvarFileNames(UBound(LvarFileNames))
            'GvarPDMname = Mid(GvarPDMname, 1, InStr(GvarPDMname, ".") - 1)
        End If
    End Sub
    Private Sub frmGenerar_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        sbSetPDMfile(GetSetting("vbColdFusion", "Defaults", "PDM File Name", ""))

        dlgOpenOpen.InitialDirectory = GvarPDMfile
        If GvarPDMfile <> "" Then
            chkAbrir.Checked = True
            lblFileName.Text = GvarPDMfile
        End If

    End Sub

    Private Sub sbAbrirPDM(ByVal LprmPDMfile As String)
        Dim LvarSchemas As Object()
        Dim LvarTipoError As String

        GvarSalvar = False
        GvarPDM = Nothing
        sbSetPDMfile("")
        lblFileName.Text = ""
        chkAbrir.Enabled = False
        chkAbrir.Checked = False
        btnAddModelo.Visible = False
        btnGenerarTodo.Enabled = False
        btnGenerarP.Enabled = False
        btnGenerarD.Enabled = False
        btnGenerarT.Enabled = False
        cboEsquema.Enabled = False
        cboEsquema.SelectedIndex = -1
        lstTables.Items.Clear()
        lstDiagrams.Items.Clear()
        lstPackage.Items.Clear()

        If Dir(LprmPDMfile) = "" Then
            MsgBox("El Archivo '" + LprmPDMfile + "' no existe")
            Exit Sub
        End If
        Me.Cursor = Cursors.WaitCursor
        Try
            LvarTipoError = "No se pudo comunicar con el SVN"

            GvarSVN.GetWCInfo(LprmPDMfile, False, False)
            'gvarsvn.IsSvnItem, gvarsvn.NeedsLocking, gvarsvn.LockOwner, gvarsvn.Author
            If Not GvarSVN.IsLocked Then
                MsgBox("Debe bloquear el modelo antes de trabajar con el")
                Me.Cursor = Cursors.Arrow
                Exit Sub
            End If
            sbSetPDMfile(LprmPDMfile)
            GvarUID = GvarSVN.LockOwner
            LvarTipoError = "No se pudo comunicar con Coldfusion"
            LvarSchemas = GvarWS.qryEsquemasModelo(GvarPDMname)
            cboEsquema.Items.Clear()
            Dim i As Integer
            For i = LBound(LvarSchemas) To UBound(LvarSchemas)
                cboEsquema.Items.Add(LvarSchemas(i))
            Next i
            If UBound(LvarSchemas) > 1 Then
                If MsgBox("El modelo '" & GvarPDMname & "' no ha sido registrado en el Servidor. ¿Desea registar el nuevo modelo?", MsgBoxStyle.OkCancel) = MsgBoxResult.Ok Then
                    btnAddModelo.Visible = True
                    btnAddModelo.Enabled = True
                    cboEsquema.Enabled = True
                End If
            Else
                cboEsquema.SelectedIndex = 0
                'GvarPD = CreateObject("PowerDesigner.Application")
                LvarTipoError = "El Archivo '" + LprmPDMfile + "' no se pudo abrir como PDM"
                GvarPDM = GvarPD.OpenModel(LprmPDMfile)
                SaveSetting("vbColdFusion", "Defaults", "PDM File Name", GvarPDMfile)
                btnGenerarTodo.Enabled = True
                btnGenerarP.Enabled = True
                btnGenerarD.Enabled = True
                btnGenerarT.Enabled = True
                chkAbrir.Enabled = True
                chkAbrir.Checked = True
            End If
            sbSetPDMfile(LprmPDMfile)
            lblFileName.Text = LprmPDMfile
        Catch ex As Exception
            GvarPDM = Nothing
            GvarPD = Nothing
            sbSetPDMfile("")
            lblFileName.Text = ""
            MsgBox(LvarTipoError + vbCrLf + Err.Description)
        End Try
        If Not GvarPDM Is Nothing Then
            lstPackage.Items.Clear()
            lstDiagrams.Items.Clear()
            lstTables.Items.Clear()
            sbGetPackages(GvarPDM)
        End If
        Me.Cursor = Cursors.Arrow
    End Sub

    Sub sbGetPackages(ByVal LprmModel As PdPDM.Model)
        Dim LvarPck As PdPDM.Package
        Dim LvarPackage As New clsPDMlists

        LvarPackage.code = LprmModel.Code
        LvarPackage.obj = LprmModel
        lstPackage.Items.Add(LvarPackage)

        For Each LvarPck In LprmModel.GetAttribute("Packages")
            sbGetPackages(LvarPck)
        Next LvarPck
    End Sub

    Sub sbGetPackages(ByVal LprmModel As PdPDM.Package)
        Dim LvarPck As PdPDM.Package
        Dim LvarPackage As New clsPDMlists

        LvarPackage.code = LprmModel.Code
        LvarPackage.obj = LprmModel
        lstPackage.Items.Add(LvarPackage)

        For Each LvarPck In LprmModel.GetAttribute("Packages")
            sbGetPackages(LvarPck)
        Next LvarPck
    End Sub

    Private Sub btnAbrir_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnAbrir.Click
        If chkAbrir.Checked Then
            sbAbrirPDM(GvarPDMfile)
        Else
            dlgOpenOpen.DefaultExt = "pdm"
            dlgOpenOpen.FileName = ""
            dlgOpenOpen.Filter = "PowerDesigner Physical Data Model|*.pdm"

            dlgOpenOpen.ShowDialog()
            If dlgOpenOpen.FileName = "" Then Exit Sub
            sbAbrirPDM((dlgOpenOpen.FileName))
        End If
    End Sub

    Private Sub lstPackage_DoubleClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles lstPackage.DoubleClick
        sbGetTables(lstPackage.Items(lstPackage.SelectedIndex).obj)
        sbGetDiagrams(lstPackage.Items(lstPackage.SelectedIndex).obj)
    End Sub

    Sub sbGetDiagrams(ByRef LprmModel As Object)
        Dim LvarDiag As clsPDMlists
        Dim LvarDiagram As PdCommon.PackageDiagram

        lstDiagrams.Items.Clear()
        For Each LvarDiagram In CType(LprmModel, PdCommon.BasePackage).GetAttribute("AllDiagrams")
            LvarDiag = New clsPDMlists
            LvarDiag.code = LvarDiagram.Code
            LvarDiag.obj = LvarDiagram
            lstDiagrams.Items.Add(LvarDiag)
        Next LvarDiagram
    End Sub

    Sub sbGetTablesDiag(ByRef LprmDiagram As PdCommon.PackageDiagram, Optional ByVal LprmSelected As Boolean = False)
        Dim LvarObj As PdCommon.BaseSymbol
        Dim LvarTbl As PdPDM.Table
        Dim LvarTable As clsPDMlists
        Dim LvarTS As PdPDM.TableSymbol

        '        LprmDiagram.Symbols
        lstTables.Items.Clear()
        lblModelo.Text = CType(LprmDiagram, PdCommon.BaseDiagram).GetAttribute("Code")
        For Each LvarObj In LprmDiagram.Symbols
            LvarTable = New clsPDMlists
            If LvarObj.ObjectType = "TableSymbol" Then
                LvarTS = LvarObj
                LvarTbl = LvarTS.Object

                LvarTable.code = LvarTbl.Code
                LvarTable.obj = LvarTbl
                lstTables.Items.Add(LvarTable, LprmSelected)
            End If
            Try
            Catch ex As Exception

            End Try
        Next LvarObj
        Me.Show()
        Application.DoEvents()
        Me.Show()
    End Sub

    Sub sbGetTables(ByVal LprmModel As Object, Optional ByVal LprmSelected As Boolean = False)
        Dim LvarObj As Object
        Dim LvarTbl As PdPDM.Table
        Dim LvarShortcut As PdCommon.Shortcut
        Dim LvarTable As clsPDMlists

        lstTables.Items.Clear()
        lblModelo.Text = CType(LprmModel, PdCommon.BasePackage).GetAttribute("Code")
        For Each LvarObj In CType(LprmModel, PdCommon.BasePackage).GetAttribute("Tables")
            LvarTable = New clsPDMlists
            Try
                If TypeName(LvarObj) = "Shortcut" Then
                    LvarShortcut = CType(LvarObj, PdCommon.Shortcut)
                    LvarTable.code = LvarShortcut.Code
                    LvarTable.obj = LvarShortcut
                    lstTables.Items.Add(LvarTable, LprmSelected)
                Else
                    LvarTbl = CType(LvarObj, PdPDM.Table)
                    LvarTable.code = LvarTbl.Code
                    LvarTable.obj = LvarTbl
                    lstTables.Items.Add(LvarTable, LprmSelected)
                End If
            Catch ex As Exception
                MsgBox(ex.Message)
            End Try
        Next LvarObj
        Me.Refresh()
        Application.DoEvents()
    End Sub

    Private Sub btnGenerarT_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnGenerarT.Click
        GvarSalvar = False
        fnGenerarTablasMarcadas()
        btnSalvar.Enabled = GvarSalvar And GvarTabsN > 0
        MsgBox(GvarTabsN & " Tablas generadas")
    End Sub

    Sub fnGenerarTablasMarcadas()
        Dim LvarObj As clsPDMlists
        Dim XMLs As New System.Xml.XmlWriterSettings
        Dim LvarShortcut As PdCommon.Shortcut
        Dim i As Integer
        Dim LvarIdx As Integer

        If txtDescripcion.Text = "" Then
            MsgBox("Debe digitar una descripcion para identificar el parche a generar")
            Exit Sub
        End If
        XMLs.Indent = 1
        XMLs.IndentChars = " "
        XMLs.NewLineHandling = Xml.NewLineHandling.Entitize
        XMLs.NewLineOnAttributes = False
        Me.Cursor = Cursors.WaitCursor
        GvarTabs.Clear()
        GvarTabsN = 0
        Dim LvarFile As String = "C:\prueba.xml"
        Using XMLtables As System.Xml.XmlWriter = System.Xml.XmlWriter.Create(LvarFile)
            XMLtables.WriteStartElement("upload")

            LvarIdx = lstTables.SelectedIndex
            lstTables.SelectedIndex = -1
            For Each i In lstTables.CheckedIndices
                lstTables.SelectedIndex = i
                Me.Refresh()

                LvarObj = lstTables.Items(i)
                If TypeName(LvarObj.obj) = "Shortcut" Then
                    LvarShortcut = CType(LvarObj.obj, PdCommon.Shortcut)
                    If Not LvarShortcut.Generated Or LvarShortcut.External Then
                        XMLtables.WriteStartElement("tab")
                        XMLtables.WriteAttributeString("cod", Trim(LvarShortcut.Code))
                        XMLtables.WriteAttributeString("des", Trim(LvarShortcut.name))
                        XMLtables.WriteAttributeString("gen", "0")
                        XMLtables.WriteEndElement()
                    ElseIf LvarShortcut.TargetObject Is Nothing Then
                        MsgBox("Shortcut '" + Trim(LvarShortcut.Code) + "=" + Trim(LvarShortcut.name) + "' esta mal definida en: " + vbCrLf + LvarShortcut.UOL)
                        GvarTabsN = -1
                        Exit For
                    Else
                        If Not fnGenerarTabla(LvarObj.obj, XMLtables) Then Exit For
                    End If
                Else
                    If Not fnGenerarTabla(LvarObj.obj, XMLtables) Then Exit For
                End If
                XMLtables.Flush()
            Next
            lstTables.SelectedIndex = LvarIdx
            XMLtables.WriteEndElement()
            XMLtables.Close()
            If GvarTabsN > 0 Then
                sbSalvar(LvarFile)
            End If
        End Using
        Me.Cursor = Cursors.Arrow
    End Sub


    Function fnGenerarTabla(ByRef LprmTable As PdPDM.Table, ByRef XMLtables As System.Xml.XmlWriter) As Boolean
        Dim LvarTipo As String
        Dim LvarTipo2 As String
        Dim LvarDfl As String
        Dim LvarLong As String
        Dim LvarDecs As String
        Dim LvarCol As PdPDM.Column
        Dim LvarTip As tipoLon

        'TABLA
        If InStr(LprmTable.Comment, "<DBM:NO_UPLOAD>") Or Mid(LprmTable.Code, 1, 1) = "_" Or LCase(LprmTable.Code) = "dual" Then
            fnGenerarTabla = True
            Exit Function
        ElseIf GvarTabs.Contains(LprmTable.Code) Then
            fnGenerarTabla = True
            Exit Function
        Else
            GvarTabs.Add(LprmTable.Name, LprmTable.Code)
        End If

        If Len(LprmTable.Code) > 30 Then
            MsgBox("Codigo de Tabla mayor que 30: Tabla='" & LprmTable.Code & "'. Corrija antes de Generar!")
            GvarTabsN = -1
            fnGenerarTabla = False
            Exit Function
        End If

        If LprmTable.Columns.Count = 0 Then
            MsgBox("Tabla no contiene campos: Tabla='" & LprmTable.Code & "'. Corrija antes de Generar!")
            If MsgBox("¿Desea borrarla?", MsgBoxStyle.OkCancel) = MsgBoxResult.Ok Then
                LprmTable.delete()
                GvarSalvar = True
                fnGenerarTabla = True
                Exit Function
            Else
                GvarTabsN = -1
                fnGenerarTabla = False
                Exit Function
            End If
        End If

        GvarTabsN = GvarTabsN + 1
        XMLtables.WriteStartElement("tab")
        XMLtables.WriteAttributeString("cod", Trim(LprmTable.Code))
        XMLtables.WriteAttributeString("des", Trim(LprmTable.Name))
        If LprmTable.ServerCheckExpression <> "" And LprmTable.ServerCheckExpression <> "%RULES%" Then
            Dim LvarCheck As String
            LvarCheck = Trim(Replace(LprmTable.ServerCheckExpression, "%RULES%", ""))
            If Microsoft.VisualBasic.Left(UCase(LvarCheck), 4) = "AND " Then
                LvarCheck = Mid(LvarCheck, 5)
            ElseIf Microsoft.VisualBasic.Right(UCase(LvarCheck), 4) = " AND" Then
                LvarCheck = Mid(LvarCheck, 1, Len(LvarCheck) - 4)
            End If
            If Trim(LvarCheck) <> "" Then XMLtables.WriteAttributeString("rul", Trim(LvarCheck))
        End If

        If InStr(LprmTable.Comment, "<DBM:NO_GENERATE>") Or Not LprmTable.Generated Then XMLtables.WriteAttributeString("gen", "0")
        If InStr(LprmTable.Comment, "<DBM:NO_VERSION>") Or InStr(LprmTable.Comment, "<DBM:DESARROLLO>") Then XMLtables.WriteAttributeString("genVer", "0")
        If InStr(LprmTable.Comment, "<DBM:DROP>") Then XMLtables.WriteAttributeString("del", "1")
        If InStr(LprmTable.Comment, "<DBM:RENAME:") Then
            Dim LvarPto As Integer = InStr(LprmTable.Comment, "<DBM:RENAME:") + Len("<DBM:RENAME:")
            Dim LvarRen As String = Mid(LprmTable.Comment, LvarPto)
            LvarRen = Mid(LvarRen, 1, InStr(LvarRen, ">") - 1)
            XMLtables.WriteAttributeString("ren", LvarRen)
        End If

        'CAMPOS
        Dim LvarBMUsuObl As Boolean = False
        Dim LvarBMUsuDfl As String = ""
        For Each LvarCol In LprmTable.Columns
            If LCase(LvarCol.Code) = "ts_rversion" Or InStr("timestamp", LCase(LvarCol.DataType)) Then
                If LvarCol.Code <> "ts_rversion" Then
                    MsgBox("'ts_rversion' mal escrito: Tabla='" & LprmTable.Code & "',Col='" & LvarCol.Code & "'. Corrija antes de Generar!")
                    GvarTabsN = -1
                    fnGenerarTabla = False
                    Exit Function
                End If
            ElseIf LCase(LvarCol.Code) = "bmusucodigo" Then
                If LvarCol.Code <> "BMUsucodigo" Then
                    MsgBox("'BMUsucodigo' mal escrito: Tabla='" & LprmTable.Code & "',Col='" & LvarCol.Code & "'. Corrija antes de Generar!")
                    GvarTabsN = -1
                    fnGenerarTabla = False
                    Exit Function
                End If
                LvarBMUsuObl = LvarCol.Mandatory
                LvarBMUsuDfl = LvarCol.DefaultValue
            Else
                If LvarCol.ServerCheckExpression <> "" And LvarCol.ServerCheckExpression <> "%MINMAX% and %LISTVAL% and %UPPER% and %LOWER% and %RULES%" Then
                    MsgBox("No se permiten checks particulares a nivel de Columna: Tabla='" & LprmTable.Code & "',Col='" & LvarCol.Code & "'. Corrija antes de Generar (coloquelos a nivel de tabla)!")
                    GvarTabsN = -1
                    fnGenerarTabla = False
                    Exit Function
                End If
                If Len(LvarCol.Code) > 30 Then
                    MsgBox("Codigo de Columna mayor que 30: Tabla='" & LprmTable.Code & "',Col='" & LvarCol.Code & "'. Corrija antes de Generar!")
                    GvarTabsN = -1
                    fnGenerarTabla = False
                    Exit Function
                End If

                LvarTip = fnGetTipoLon(LvarCol)
                If GvarTabsN = -1 Then
                    MsgBox("Tipo de dato no soportado: Tabla='" & LprmTable.Code & "',Col='" & LvarCol.Code & "' Tipo='" & LvarCol.DataType & "'. Corrija antes de Generar!")
                End If
                LvarLong = LvarTip.LvarLong
                LvarDecs = LvarTip.LvarDecs
                LvarTipo = LvarTip.LvarTipo
                LvarTipo2 = LvarTip.LvarTipo2

                If InStr(LvarCol.Comment, "<DBM:NO_UPLOAD>") = 0 Then
                    XMLtables.WriteStartElement("col")
                    XMLtables.WriteAttributeString("cod", Trim(LvarCol.Code))
                    XMLtables.WriteAttributeString("des", Trim(LvarCol.Name))
                    XMLtables.WriteAttributeString("tip", Trim(LvarTipo))
                    If LvarLong <> "" Then XMLtables.WriteAttributeString("lon", LvarLong)
                    If LvarDecs <> "" Then XMLtables.WriteAttributeString("dec", LvarDecs)
                    If LvarCol.Identity Then XMLtables.WriteAttributeString("ide", "1")
                    If LvarCol.Mandatory Or LvarTipo = "L" Then XMLtables.WriteAttributeString("obl", "1")

                    If LvarCol.DefaultValue <> "" Then
                        LvarDfl = Trim(LvarCol.DefaultValue)
                        If LvarDfl <> "'" Then
                            LvarDfl = Replace(LvarDfl, "'", "")
                        End If

                        If LvarDfl <> "(" And InStr(LvarDfl, "(") > 0 Then
                            If InStr(LvarDfl, "user_name") + InStr(LvarDfl, "getdate") = 0 Then
                                MsgBox("Función en Default no soportado (no se permiten parentesis): Tabla='" & LprmTable.Code & "',Col='" & LvarCol.Code & "' Default='" & LvarDfl & "'. Corrija antes de Generar!")
                                GvarTabsN = -1
                                fnGenerarTabla = False
                                Exit Function
                            End If
                        ElseIf LvarTipo2 = "B" Then
                            If LvarDfl Like "*[!0-9A-Fa-f]*" Then
                                MsgBox("Default Hexadecimal no soportado: Tabla='" & LprmTable.Code & "',Col='" & LvarCol.Code & "' Default='" & LvarDfl & "'. Corrija antes de Generar!")
                                GvarTabsN = -1
                                fnGenerarTabla = False
                                Exit Function
                            End If
                        ElseIf LvarTipo2 = "N" Then
                            LvarDfl = Replace(LvarDfl, "+", "")
                            If Not IsNumeric(LvarDfl) Then
                                MsgBox("Default Numerico no soportado: Tabla='" & LprmTable.Code & "',Col='" & LvarCol.Code & "' Default='" & LvarDfl & "'. Corrija antes de Generar!")
                                GvarTabsN = -1
                                fnGenerarTabla = False
                                Exit Function
                            End If
                        ElseIf LvarTipo2 = "D" Then
                            If Not IsNumeric(LvarDfl) Or Len(LvarDfl) <> 8 Then
                                MsgBox("Default Fecha no soportado (Formato YYYYMMDD): Tabla='" & LprmTable.Code & "',Col='" & LvarCol.Code & "' Default='" & LvarDfl & "'. Corrija antes de Generar!")
                                GvarTabsN = -1
                                fnGenerarTabla = False
                                Exit Function
                            End If
                        ElseIf LvarTipo2 = "TS" Then
                            MsgBox("Campo ts_rversion no debe tener default: Tabla='" & LprmTable.Code & "',Col='" & LvarCol.Code & "' Default='" & LvarDfl & "'. Corrija antes de Generar!")
                            GvarTabsN = -1
                            fnGenerarTabla = False
                            Exit Function
                        End If
                        XMLtables.WriteAttributeString("dfl", LvarDfl)
                    End If

                    If LvarTipo <> "L" Then
                        If LvarCol.LowValue <> "" Then XMLtables.WriteAttributeString("min", Trim(LvarCol.LowValue))
                        If LvarCol.HighValue <> "" Then XMLtables.WriteAttributeString("max", Trim(LvarCol.HighValue))
                        If LvarCol.ListOfValues <> "" And Trim(LvarCol.ListOfValues) <> vbTab Then XMLtables.WriteAttributeString("lov", Trim(Replace(Replace(Replace(LvarCol.ListOfValues, "\", "/"), vbCrLf, "\n"), vbTab, "\t")))
                    End If
                    If InStr(LvarCol.Comment, "<DBM:NO_VERSION>") Or InStr(LvarCol.Comment, "<DBM:DESARROLLO>") Then XMLtables.WriteAttributeString("genVer", "0")
                    If InStr(LvarCol.Comment, "<DBM:DROP>") Then XMLtables.WriteAttributeString("del", "1")
                    If InStr(LvarCol.Comment, "<DBM:RENAME:") Then
                        Dim LvarPto As Integer = InStr(LvarCol.Comment, "<DBM:RENAME:") + Len("<DBM:RENAME:")
                        Dim LvarRen As String = Mid(LvarCol.Comment, LvarPto)
                        LvarRen = Mid(LvarRen, 1, InStr(LvarRen, ">") - 1)
                        XMLtables.WriteAttributeString("ren", LvarRen)
                    End If
                    XMLtables.WriteEndElement()
                End If
            End If
        Next LvarCol
        '<col cod="BMUsucodigo" des="Usucodigo para Log del Portal" tip="N" lon="18" dec="0" />
        XMLtables.WriteStartElement("col")
        XMLtables.WriteAttributeString("cod", "BMUsucodigo")
        XMLtables.WriteAttributeString("des", "Usucodigo para Log del Portal")
        XMLtables.WriteAttributeString("tip", "N")
        XMLtables.WriteAttributeString("lon", "18")
        XMLtables.WriteAttributeString("dec", "0")
        If LvarBMUsuObl Then XMLtables.WriteAttributeString("obl", "1")
        If LvarBMUsuDfl <> "" Then XMLtables.WriteAttributeString("dfl", LvarBMUsuDfl)
        XMLtables.WriteEndElement()
        '<col cod="ts_rversion" des="timestamp version de registro" tip="TS" />
        XMLtables.WriteStartElement("col")
        XMLtables.WriteAttributeString("cod", "ts_rversion")
        XMLtables.WriteAttributeString("des", "Timestamp version de registro")
        XMLtables.WriteAttributeString("tip", "TS")
        XMLtables.WriteEndElement()

        GvarIDXs.Clear()
        GvarFKs.Clear()

        'PKs            KEY.tip='P'
        sbGetKEYs_PK_AK(LprmTable, XMLtables, "P")
        If GvarTabsN = -1 Then fnGenerarTabla = False : Exit Function
        'AKs            KEY.tip='A'
        sbGetKEYs_PK_AK(LprmTable, XMLtables, "A")
        If GvarTabsN = -1 Then fnGenerarTabla = False : Exit Function
        'INDICES UNICOS KEY.tip='U'
        sbGetKEYs_IDX(LprmTable, XMLtables, "U")
        If GvarTabsN = -1 Then fnGenerarTabla = False : Exit Function
        'FKs            KEY.tip='F'
        sbGetKEYs_FK(LprmTable, XMLtables)
        If GvarTabsN = -1 Then fnGenerarTabla = False : Exit Function
        'INDICES        KEY.tip='I'
        sbGetKEYs_IDX(LprmTable, XMLtables, "I")
        If GvarTabsN = -1 Then fnGenerarTabla = False : Exit Function

        'For Each LvarRel In LprmTable.InReferences
        '    XMLtables.WriteStartElement("dep")
        '    XMLtables.WriteAttributeString("tab", Trim(LvarRel.ChildTable.GetAttribute("code")))
        '    XMLtables.WriteAttributeString("cols", Trim(LvarRel.ForeignKeyColumnList.Replace("; ", ",")))
        '    XMLtables.WriteAttributeString("colsR", Trim(LvarRel.ParentKeyColumnList.Replace("; ", ",")))
        '    If Not LvarRel.Generated Then XMLtables.WriteAttributeString("gen", "0")
        '    XMLtables.WriteEndElement()
        'Next
        XMLtables.WriteEndElement()
        fnGenerarTabla = True
    End Function

    Private Function fnGetTipoLon(ByVal LvarCol As PdPDM.Column) As tipoLon
        'LvarTipo, LvarTipo2, LvarLong, LvarDecs
        Dim respuesta As tipoLon
        Dim LvarTipo As String
        Dim LvarTipo2 As String
        Dim LvarLong As String
        Dim LvarDecs As String

        LvarTipo = Trim(LCase(LvarCol.DataType))
        If InStr(LvarTipo, "(") Then
            LvarTipo = Trim(Mid(LvarTipo, 1, InStr(LvarTipo, "(") - 1))
        End If
        If LvarTipo = "small" Then
            LvarCol.DataType = "smallint"
            LvarTipo = LCase(LvarCol.DataType)
        ElseIf LvarTipo = "tiny" Then
            LvarCol.DataType = "tinyint"
            LvarTipo = LCase(LvarCol.DataType)
        ElseIf LvarTipo = "big" Then
            LvarCol.DataType = "bigint"
            LvarTipo = LCase(LvarCol.DataType)
        End If
        'TIPOS DE DATOS:
        '   String:
        '       char,nchar,varchar,nvarchar,sysname     C=CHAR,V=VarChar         n,1
        '   Binarios:
        '       binary,varbinary                        B=Binary,VB=VarBinary    n,1
        '   LOB:
        '       text, image                             CL=CLOB,BL=BLOB          0
        '   Numéricos Entero:
        '       biginteger,integer,int,smallint,tinyint I=Integer                20,10,5,3
        '   Numéricos Punto Fijo:
        '       numeric,decimal,dec                     N=Numeric                n,d
        '   Numéricos Punto Flotante:
        '       real, float, double precision           F=Float                  7,15
        '   Numéricos Montos:
        '       money,smallmoney                        M=Money                  18,4
        '   Logicos:
        '       bit                                     L=Logico                 1
        '   Fecha:
        '       date, datetime, smalldatetime           D=DateTime               0
        '   Control de Concurrencia optimístico:
        '       timestamp                               TS=Timestamp             0
        'If LvarCol.Comment <> "" Then Stop
        LvarLong = ""
        LvarDecs = ""
        If InStr(",char,nchar,", "," & LvarTipo & ",") Then
            If LvarCol.Length = 0 Then
                LvarLong = 1
            Else
                LvarLong = LvarCol.Length
            End If
            LvarDecs = ""
            LvarTipo = "C"
            LvarTipo2 = "S"
        ElseIf InStr(",varchar,nvarchar,sysname,", "," & LvarTipo & ",") Then
            If LvarTipo = "sysname" Then
                LvarLong = 30
            ElseIf LvarCol.Length = 0 Then
                LvarLong = 1
            Else
                LvarLong = LvarCol.Length
            End If
            LvarDecs = ""
            LvarTipo = "V"
            LvarTipo2 = "S"
        ElseIf InStr(",binary,", "," & LvarTipo & ",") Then
            If LvarCol.Length = 0 Then
                LvarLong = 1
            Else
                LvarLong = LvarCol.Length
            End If
            LvarDecs = ""
            LvarTipo = "B"
            LvarTipo2 = "B"
        ElseIf InStr(",varbinary,", "," & LvarTipo & ",") Then
            If LvarCol.Length = 0 Then
                LvarLong = 1
            Else
                LvarLong = LvarCol.Length
            End If
            LvarDecs = ""
            LvarTipo = "VB"
            LvarTipo2 = "B"
        ElseIf InStr(",text,", "," & LvarTipo & ",") Then
            LvarLong = ""
            LvarDecs = ""
            LvarTipo = "CL"
            LvarTipo2 = "S"
        ElseIf InStr(",image,", "," & LvarTipo & ",") Then
            LvarLong = ""
            LvarDecs = ""
            LvarTipo = "BL"
            LvarTipo2 = "B"
        ElseIf InStr(",bigint,biginteger,integer,int,smallint,tinyint,", "," & LvarTipo & ",") Then
            If InStr(LvarTipo, "big") > 0 Then
                LvarLong = 19
            ElseIf InStr(LvarTipo, "small") > 0 Then
                LvarLong = 5
            ElseIf InStr(LvarTipo, "tiny") > 0 Then
                LvarLong = 3
            Else
                LvarLong = 10
            End If
            LvarDecs = ""
            LvarTipo = "I"
            LvarTipo2 = "N"
        ElseIf InStr(",numeric,decimal,dec,", "," & LvarTipo & ",") Then
            If LvarCol.Length = 0 Then
                LvarLong = 18
            Else
                LvarLong = LvarCol.Length
            End If
            LvarDecs = LvarCol.Precision
            LvarTipo = "N"
            LvarTipo2 = "N"
        ElseIf InStr(",real,float,double,double precision,", "," & LvarTipo & ",") Then
            If LvarTipo = "real" Then
                LvarLong = 7
            ElseIf InStr(LvarTipo, "double") > 0 Or LvarCol.Length >= 16 Then
                LvarLong = 30
            ElseIf LvarCol.Length = 0 Or LvarCol.Length >= 8 Then
                LvarLong = 15
            Else
                LvarLong = 7
            End If
            LvarDecs = ""
            LvarTipo = "F"
            LvarTipo2 = "N"
        ElseIf InStr(",money,smallmoney,", "," & LvarTipo & ",") Then
            LvarLong = ""
            LvarDecs = ""
            LvarTipo = "M"
            LvarTipo2 = "N"
        ElseIf InStr(",bit,", "," & LvarTipo & ",") Then
            LvarLong = ""
            LvarDecs = ""
            LvarTipo = "L"
            LvarTipo2 = "N"
        ElseIf InStr(",time,date,datetime,smalldatetime,", "," & LvarTipo & ",") Then
            LvarLong = ""
            LvarDecs = ""
            LvarTipo = "D"
            LvarTipo2 = "D"
        ElseIf InStr(",timestamp,", "," & LvarTipo & ",") Then
            LvarLong = ""
            LvarDecs = ""
            LvarTipo = "TS"
            LvarTipo2 = "TS"
        Else
            GvarTabsN = -1
            fnGetTipoLon = respuesta
            Exit Function
        End If
        respuesta.LvarLong = LvarLong
        respuesta.LvarDecs = LvarDecs
        respuesta.LvarTipo = LvarTipo
        respuesta.LvarTipo2 = LvarTipo2
        fnGetTipoLon = respuesta
    End Function
    Function fnColsR(ByVal join As String) As String
        Dim LvarCols As String = ""
        Dim LvarJoin() As String
        Dim LvarAnd() As String = {vbCrLf}
        Dim i As Integer

        LvarJoin = join.Split(LvarAnd, StringSplitOptions.None)
        LvarCols = ""
        For i = 0 To UBound(LvarJoin)
            If i > 0 Then LvarCols = LvarCols & ","
            LvarCols = LvarCols & Trim(LvarJoin(i).Split("=")(0))
        Next i
        fnColsR = LvarCols
    End Function

    Sub sbGetKEYs_PK_AK(ByRef LprmTable As PdPDM.Table, ByRef XMLtables As System.Xml.XmlWriter, ByVal LprmTipo As String)
        Dim LvarCols As String
        Dim LvarKey As PdPDM.Key
        Dim LvarCol As PdPDM.Column
        Dim LvarTipo As String
        Dim LvarAKi As Integer = 0
        Dim LvarConstraintName As String

        Dim LvarDeleted As Boolean

        For Each LvarKey In LprmTable.Keys
            LvarDeleted = False
            If LvarKey.Primary Then
                LvarTipo = "P"
            Else
                LvarTipo = "A"
                LvarAKi = LvarAKi + 1
            End If
            If LprmTipo = LvarTipo And InStr(LvarKey.Comment, "<DBM:NO_UPLOAD>") = 0 Then
                LvarConstraintName = LvarKey.ConstraintName
                If LvarConstraintName = "" Then
                    If InStr(LCase(LvarKey.Preview), "constraint") > 0 Then
                        LvarConstraintName = Trim(Mid(LvarKey.Preview, InStr(LCase(LvarKey.Preview), " constraint") + 12))
                        LvarConstraintName = Replace(LvarConstraintName, Chr(13), " ")
                        LvarConstraintName = Mid(LvarConstraintName, 1, InStr(LvarConstraintName, " ") - 1)
                    End If
                End If
                If LvarConstraintName = "" Then
                    If LvarTipo = "P" Then
                        LvarConstraintName = UCase(LprmTable.Code) & "_PK"
                    Else
                        LvarAKi = LvarAKi + 1
                        LvarConstraintName = UCase(LprmTable.Code) & "_AK" & Format(LvarAKi, "00")
                    End If
                    LvarKey.ConstraintName = LvarConstraintName
                End If

                If LvarKey.Columns.Count = 0 Then
                    MsgBox("Definición de Llave no contiene campos: Tabla='" & LprmTable.Code & "', Key='" & LvarConstraintName & "'. Corrija antes de Generar!")
                    If MsgBox("¿Desea borrarla?", MsgBoxStyle.OkCancel) = MsgBoxResult.Ok Then
                        LvarKey.delete()
                        LvarDeleted = True
                        GvarSalvar = True
                    Else
                        GvarTabsN = -1
                        Exit Sub
                    End If
                End If

                If Not LvarDeleted Then
                    LvarCols = ""
                    For Each LvarCol In LvarKey.Columns
                        If Not LvarCol.Mandatory And InStr(LvarKey.Comment, "<DBM:DB2:IU>") = 0 Then
                            If MsgBox("PRECAUCION: Definición de ALTERNATE KEY con campos nulos: Tabla='" & LprmTable.Code & "', Key='" & LvarConstraintName & "', Tipo='" & LvarTipo & "', Col='" & LvarCol.Code & "'. En DB2 se van a convertir a Indices Unicos pero no se va a generar ninguna relación a la tabla. ¿Desea Continuar?", MsgBoxStyle.OkCancel) = MsgBoxResult.Ok Then
                                LvarKey.Comment = LvarKey.Comment & "<DBM:DB2:IU>"
                                GvarSalvar = True
                            Else
                                GvarTabsN = -1
                                Exit Sub
                            End If
                        End If
                        If LvarCols = "" Then
                            LvarCols = LvarCol.Code
                        Else
                            LvarCols = LvarCols & "," & Trim(LvarCol.Code)
                        End If
                    Next LvarCol

                    LvarCols = Trim(LvarCols)
                    If InStr(LvarKey.Comment, "<DBM:DROP>") = 0 Then
                        If GvarIDXs.Contains(LvarCols) Then
                            MsgBox("Definición de IDX repetido: Tabla='" & LprmTable.Code & "', Key='" & LvarConstraintName & "'. Corrija antes de Generar!")
                            If MsgBox("¿Desea borrarla?", MsgBoxStyle.OkCancel) = MsgBoxResult.Ok Then
                                LvarKey.delete()
                                LvarDeleted = True
                                GvarSalvar = True
                            Else
                                GvarTabsN = -1
                                Exit Sub
                            End If
                        Else
                            GvarIDXs.Add(LvarConstraintName, LvarCols)
                        End If
                    End If
                End If

                If Not LvarDeleted Then
                    XMLtables.WriteStartElement("key")
                    XMLtables.WriteAttributeString("tip", LvarTipo)
                    XMLtables.WriteAttributeString("cols", LvarCols)

                    If LvarKey.Clustered Then XMLtables.WriteAttributeString("clu", "1")

                    If InStr(LvarKey.Comment, "<DBM:NO_VERSION>") Or InStr(LvarKey.Comment, "<DBM:DESARROLLO>") Then XMLtables.WriteAttributeString("genVer", "0")
                    If InStr(LvarKey.Comment, "<DBM:DROP>") Then XMLtables.WriteAttributeString("del", "1")

                    XMLtables.WriteEndElement()
                End If
            End If
        Next LvarKey
    End Sub

    Sub sbGetKEYs_FK(ByRef LprmTable As PdPDM.Table, ByRef XMLtables As System.Xml.XmlWriter)
        Dim LvarCols As String
        Dim LvarRef As String
        Dim LvarColsR As String
        Dim LvarRel As PdPDM.Reference
        Dim LvarConstraintName As String
        Dim LvarFKi As Integer = 0
        Dim LvarColF As PdPDM.Column
        Dim LvarColR As PdPDM.Column
        Dim LvarColFtip As tipoLon
        Dim LvarColRtip As tipoLon
        Dim LvarJoin As PdPDM.ReferenceJoin

        Dim LvarDeleted As Boolean

        For Each LvarRel In LprmTable.OutReferences
            LvarDeleted = False
            If InStr(LvarRel.Comment, "<DBM:NO_UPLOAD>") = 0 Then
                LvarCols = Trim(LvarRel.ForeignKeyColumnList.Replace("; ", ","))
                'Verifica sin campos
                If LvarCols = "" Then
                    MsgBox("Definición de Referencia no contiene campos: Tabla='" & LprmTable.Code & "', Referencia='" & LvarRel.Code & "'. Corrija antes de Generar!")
                    If MsgBox("¿Desea borrarla?", MsgBoxStyle.OkCancel) = MsgBoxResult.Ok Then
                        LvarRel.delete()
                        LvarDeleted = True
                        GvarSalvar = True
                    Else
                        GvarTabsN = -1
                        Exit Sub
                    End If
                End If

                'Verifica tipo de campos
                Dim LvarExterno As Boolean = False
                Try
                    If LvarRel.Object2.IsShortcut Then
                        LvarExterno = LvarRel.Object2.GetAttribute("external")
                    End If
                Catch ex As Exception
                    LvarExterno = True
                End Try
                If Not LvarExterno Then
                    For Each LvarJoin In LvarRel.Joins
                        'Verifica tipo de PK o AK
                        LvarColF = LvarJoin.ChildTableColumn
                        LvarColR = LvarJoin.ParentTableColumn
                        If InStr("pk", LvarColR.KeyIndicator) Or InStr("ak", LvarColR.KeyIndicator) Then
                            MsgBox("Definición de FK no hace referencia a un PK o AK: Tabla='" & LprmTable.Code & "', Referencia='" & LvarRel.Code & "', Tabla Ref='" & LvarRel.ParentTable.GetAttribute("code") & "', Cols Ref='" & LvarRel.ParentKeyColumnList & "'. Corrija antes de Generar!")
                            GvarTabsN = -1
                            Exit Sub
                        End If
                        LvarColFtip = fnGetTipoLon(LvarJoin.ChildTableColumn)
                        LvarColRtip = fnGetTipoLon(LvarJoin.ParentTableColumn)
                        If LvarColFtip.LvarTipo <> LvarColRtip.LvarTipo Or LvarColFtip.LvarLong <> LvarColRtip.LvarLong Then
                            MsgBox("Definición de FK no coincide tipos de dato con PK o AK: Tabla='" & LprmTable.Code & "', Referencia='" & LvarRel.Code & "', Tabla Ref='" & LvarRel.ParentTable.GetAttribute("code") & "', Cols Ref='" & LvarRel.ParentKeyColumnList & "' Tipos:'" & LvarColFtip.LvarTipo & "(" & LvarColFtip.LvarLong & ")<>" & LvarColRtip.LvarTipo & "(" & LvarColRtip.LvarLong & ")'. Corrija antes de Generar!")
                            GvarTabsN = -1
                            Exit Sub
                        End If
                    Next
                End If

                LvarConstraintName = LvarRel.ForeignKeyConstraintName
                If LvarConstraintName = "" Then
                    If InStr(LCase(LvarRel.Preview), "constraint") > 0 Then
                        LvarConstraintName = Trim(Mid(LvarRel.Preview, InStr(LCase(LvarRel.Preview), " constraint") + 12))
                        LvarConstraintName = Replace(LvarConstraintName, Chr(13), " ")
                        LvarConstraintName = Mid(LvarConstraintName, 1, InStr(LvarConstraintName, " ") - 1)
                    End If
                End If
                If LvarConstraintName = "" Then
                    LvarFKi = LvarFKi + 1
                    LvarConstraintName = "FK" & LvarFKi & "_" & UCase(LprmTable.Code)
                End If

                If Not LvarDeleted Then
                    LvarRef = Trim(LvarRel.ParentTable.GetAttribute("code"))
                    If InStr(LvarRel.Comment, "<DBM:DROP>") = 0 Then
                        If GvarFKs.Contains(LvarCols & ":" & LvarRef) Then
                            MsgBox("Definición de FK repetido: Tabla='" & LprmTable.Code & "', Ref='" & LvarRef & "', Key='" & LvarConstraintName & "'. Corrija antes de Generar!")
                            If MsgBox("¿Desea borrarla?", MsgBoxStyle.OkCancel) = MsgBoxResult.Ok Then
                                LvarRel.delete()
                                LvarDeleted = True
                                GvarSalvar = True
                            Else
                                GvarTabsN = -1
                                Exit Sub
                            End If
                        Else
                            GvarFKs.Add(LvarConstraintName, LvarCols & ":" & LvarRef)
                        End If
                    End If
                End If

                If Not LvarDeleted Then
                    XMLtables.WriteStartElement("key")
                    XMLtables.WriteAttributeString("tip", "F")
                    XMLtables.WriteAttributeString("cols", LvarCols)
                    XMLtables.WriteAttributeString("ref", LvarRef)
                    LvarColsR = Trim(LvarRel.ParentKeyColumnList.Replace("; ", ","))
                    If LvarColsR = "" Then LvarColsR = fnColsR(LvarRel.JoinExpression)
                    If LvarColsR = "" Then
                        MsgBox("No se pudo obtener una llave foranea: Tabla='" & LprmTable.Code & "', Referencia='" & LvarRel.Code & "'. Corrija antes de Generar!")
                        GvarTabsN = -1
                        Exit Sub
                    End If
                    XMLtables.WriteAttributeString("colsR", LvarColsR)
                    If GvarIDXs.Contains(LvarCols) Then
                        XMLtables.WriteAttributeString("idxTip", "U") 'Se encontro una PK, AK o IU
                    Else
                        GvarIDXs.Add(LvarConstraintName, LvarCols)
                    End If

                    If InStr(LvarRel.Comment, "<DBM:NO_GENERATE>") Or Not LvarRel.Generated Then XMLtables.WriteAttributeString("gen", "0")
                    If InStr(LvarRel.Comment, "<DBM:NO_VERSION>") Or InStr(LvarRel.Comment, "<DBM:DESARROLLO>") Then XMLtables.WriteAttributeString("genVer", "0")
                    If InStr(LvarRel.Comment, "<DBM:DROP>") Then XMLtables.WriteAttributeString("del", "1")

                    XMLtables.WriteEndElement()
                End If
            End If
        Next
    End Sub

    Sub sbGetKEYs_IDX(ByRef LprmTable As PdPDM.Table, ByRef XMLtables As System.Xml.XmlWriter, ByVal LprmTipo As String)
        Dim LvarCols As String
        Dim LvarIdx As PdPDM.index
        Dim LvarIdxCol As PdPDM.IndexColumn
        Dim LvarTipo As String

        Dim LvarDeleted As Boolean

        For Each LvarIdx In LprmTable.Indexes
            LvarDeleted = False
            If Not (LvarIdx.Primary Or LvarIdx.AlternateKey Or LvarIdx.ForeignKey) Or LvarIdx.Unique Then
                If LvarIdx.Unique Then
                    LvarTipo = "U"
                Else
                    LvarTipo = "I"
                End If
                If LprmTipo = LvarTipo And InStr(LvarIdx.Comment, "<DBM:NO_UPLOAD>") = 0 Then
                    If LvarIdx.IndexColumns.Count = 0 Then
                        MsgBox("Definición de Indice no contiene campos: Tabla='" & LprmTable.Code & "', Indice='" & LvarIdx.Code & "'. Corrija antes de Generar!")
                        If MsgBox("¿Desea borrarlo?", MsgBoxStyle.OkCancel) = MsgBoxResult.Ok Then
                            LvarIdx.delete()
                            LvarDeleted = True
                            GvarSalvar = True
                        Else
                            GvarTabsN = -1
                            Exit Sub
                        End If
                    End If

                    If Not LvarDeleted Then
                        LvarCols = ""
                        For Each LvarIdxCol In LvarIdx.IndexColumns
                            If LvarCols = "" Then
                                LvarCols = LvarIdxCol.Code
                            Else
                                LvarCols = LvarCols & "," & Trim(LvarIdxCol.Code)
                            End If
                            If Not LvarIdxCol.Ascending Then
                                LvarCols = LvarCols & "-"
                            End If
                        Next LvarIdxCol

                        If InStr(LvarIdx.Comment, "<DBM:DROP>") = 0 Then
                            If GvarIDXs.Contains(LvarCols) Then
                                MsgBox("Definición de INDICE repetido en indices o llaves: Tabla='" & LprmTable.Code & "', Idx='" & LvarIdx.Code & "', Cols='" & LvarCols & "'. Corrija antes de Generar!")
                                If MsgBox("¿Desea borrarlo?", MsgBoxStyle.OkCancel) = MsgBoxResult.Ok Then
                                    LvarIdx.delete()
                                    LvarDeleted = True
                                    GvarSalvar = True
                                Else
                                    GvarTabsN = -1
                                    Exit Sub
                                End If
                            Else
                                GvarIDXs.Add(LvarIdx.Code, LvarCols)
                            End If
                        End If
                    End If

                    If Not LvarDeleted Then
                        XMLtables.WriteStartElement("key")
                        XMLtables.WriteAttributeString("tip", LvarTipo)

                        If LvarIdx.Clustered Then XMLtables.WriteAttributeString("clu", "1")

                        XMLtables.WriteAttributeString("cols", Trim(LvarCols))

                        If InStr(LvarIdx.Comment, "<DBM:NO_VERSION>") Or InStr(LvarIdx.Comment, "<DBM:DESARROLLO>") Then XMLtables.WriteAttributeString("genVer", "0")
                        If InStr(LvarIdx.Comment, "<DBM:DROP>") Then XMLtables.WriteAttributeString("del", "1")

                        XMLtables.WriteEndElement()
                    End If
                End If
            End If
        Next LvarIdx
    End Sub

    Private Sub lstDiagrams_DoubleClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles lstDiagrams.DoubleClick
        sbGetTablesDiag(lstDiagrams.Items(lstDiagrams.SelectedIndex).obj)
    End Sub

    Private Sub btnGenerarP_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnGenerarP.Click
        If lstPackage.SelectedIndex = -1 Then
            MsgBox("Escoja un Package")
            Exit Sub
        End If
        sbGetDiagrams(lstPackage.Items(lstPackage.SelectedIndex).obj)
        sbGetTables(lstPackage.Items(lstPackage.SelectedIndex).obj, True)
        GvarTabs.Clear()
        GvarTabsN = 0
        GvarSalvar = False
        fnGenerarTablasMarcadas()
        btnSalvar.Enabled = GvarSalvar And GvarTabsN > 0
        MsgBox(GvarTabsN & " Tablas del Package generadas")
    End Sub

    Private Sub btnGenerarD_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnGenerarD.Click
        If lstDiagrams.SelectedIndex = -1 Then
            MsgBox("Escoja un Diagram")
            Exit Sub
        End If
        If txtDescripcion.Text = "" Then
            txtDescripcion.Text = "Diagram: " & lstDiagrams.Items(lstDiagrams.SelectedIndex).ToString
        End If
        sbGetTablesDiag(lstDiagrams.Items(lstDiagrams.SelectedIndex).obj, True)
        GvarTabs.Clear()
        GvarTabsN = 0
        GvarSalvar = False
        fnGenerarTablasMarcadas()
        btnSalvar.Enabled = GvarSalvar And GvarTabsN > 0
        MsgBox(GvarTabsN & " Tablas del Diagram generadas")
    End Sub


    Private Sub btnGenerarTodo_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnGenerarTodo.Click
        If MsgBox("Este proceso puede durar mucho tiempo", MsgBoxStyle.OkCancel) = MsgBoxResult.Ok Then
            GvarTabs.Clear()
            GvarTabsN = 0
            GvarSalvar = False
            sbGenerarTodo(GvarPDM)
            btnSalvar.Enabled = GvarSalvar And GvarTabsN > 0
            If GvarTabsN < 0 Then
                MsgBox("Se encontró un Error en la Generación")
            Else
                MsgBox(GvarTabsN & " Tablas del Modelo generadas")
            End If

        End If
    End Sub

    Sub sbGenerarTodo(ByVal LprmModel As PdPDM.Model)
        Dim LvarPck As PdPDM.Package
        Dim XMLs As New System.Xml.XmlWriterSettings
        Dim i As Integer

        txtDescripcion.Text = "BASE CERO: " & Replace(GvarPDMname, ".pdm", "")
        XMLs.Indent = 1
        XMLs.IndentChars = " "
        XMLs.NewLineHandling = Xml.NewLineHandling.Entitize
        XMLs.NewLineOnAttributes = False
        Me.Cursor = Cursors.WaitCursor
        Dim LvarFile As String = "C:\prueba.xml"
        Using XMLtables As System.Xml.XmlWriter = System.Xml.XmlWriter.Create(LvarFile)
            XMLtables.WriteStartElement("upload")

            For i = 0 To lstPackage.Items.Count - 1
                lstPackage.SelectedIndex = i
                If lstPackage.Items(lstPackage.SelectedIndex).obj.Equals(LprmModel) Then
                    sbGetTables(LprmModel, True)
                    sbGenerarT(XMLtables)
                Else
                    LvarPck = lstPackage.Items(lstPackage.SelectedIndex).obj
                    sbGenerarTodo2(LvarPck, XMLtables)
                End If
                If GvarTabsN < 0 Then Exit For
            Next i
            lstPackage.SelectedIndex = 0
            lstPackage.SelectedIndex = -1

            XMLtables.WriteEndElement()
            XMLtables.Close()
            If GvarTabsN > 0 Then
                sbSalvar(LvarFile)
            End If
        End Using
        Me.Cursor = Cursors.Arrow
    End Sub

    Sub sbGenerarTodo2(ByVal LprmModel As PdPDM.Package, ByVal XMLtables As System.Xml.XmlWriter)
        Dim LvarPck As PdPDM.Package

        sbGetTables(LprmModel, True)
        sbGenerarT(XMLtables)

        For Each LvarPck In LprmModel.GetAttribute("Packages")
            If GvarTabsN < 0 Then Exit For
            sbGenerarTodo2(LvarPck, XMLtables)
        Next LvarPck
    End Sub

    Private Sub sbGenerarT(ByVal XMLtables As System.Xml.XmlWriter)
        Dim LvarObj As clsPDMlists
        Dim LvarShortcut As PdCommon.Shortcut
        Dim i As Integer

        For i = 0 To lstTables.Items.Count - 1
            lstTables.SelectedIndex = i
            Me.Refresh()

            LvarObj = lstTables.Items(i)

            If TypeName(LvarObj.obj) = "Shortcut" Then
                LvarShortcut = CType(LvarObj.obj, PdCommon.Shortcut)
                If Not LvarShortcut.Generated Or LvarShortcut.External Then
                    XMLtables.WriteStartElement("tab")
                    XMLtables.WriteAttributeString("cod", Trim(LvarShortcut.Code))
                    XMLtables.WriteAttributeString("des", Trim(LvarShortcut.name))
                    XMLtables.WriteAttributeString("gen", "0")
                    XMLtables.WriteEndElement()
                ElseIf LvarShortcut.TargetObject Is Nothing Then
                    MsgBox("Shortcut '" + Trim(LvarShortcut.Code) + "=" + Trim(LvarShortcut.name) + "' esta mal definida en: " + vbCrLf + LvarShortcut.UOL)
                    GvarTabsN = -1
                    Exit For
                Else
                    If Not fnGenerarTabla(LvarObj.obj, XMLtables) Then Exit For
                End If
            Else
                If Not fnGenerarTabla(LvarObj.obj, XMLtables) Then Exit For
            End If
            XMLtables.Flush()
        Next i
        lstTables.SelectedIndex = 0
        lstTables.SelectedIndex = -1
    End Sub

    Private Sub sbSalvar(ByVal LprmFile As String)
        Dim LvarZip As New Ionic.Zip.ZipFile
        Dim LvarXML As String
        Dim LvarBin As Byte()
        Dim LvarFileXML As String
        Dim LvarIDuploap As String

        LvarXML = System.IO.File.ReadAllText(LprmFile)
        LvarZip.AddFile(LprmFile)
        LvarFileXML = LprmFile & ".zip"
        LvarZip.Save(LvarFileXML)
        LvarBin = System.IO.File.ReadAllBytes(LvarFileXML)

        'Dim LvarCredCache As New System.Net.CredentialCache
        'Dim LvarCred As New System.Net.NetworkCredential("obonilla66", "sup3rman", "")
        'LvarCredCache.Add(New Uri(GvarWS.Url), "Basic", LvarCred)
        'GvarWS.PreAuthenticate = True
        'GvarWS.UseDefaultCredentials = False
        'GvarWS.Credentials = LvarCredCache

        GvarWS.Timeout = 500000
        LvarIDuploap = GvarWS.upload(GvarUID, GvarPDMname, txtDescripcion.Text, GvarTabsN, LvarBin)

        Dim LvarPage As String = Replace(GvarWS.Url, "/Componentes/WS.cfc", "/DBMuploads.cfm?IDU=" & LvarIDuploap)
        Shell("explorer.exe """ & LvarPage & """")

        'GvarIE.Visible = True

    End Sub

    Private Sub btnAddModelo_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnAddModelo.Click
        If cboEsquema.Text = "" Then
            MsgBox("Debe escoger un Esquema")
            Exit Sub
        ElseIf GvarSVN.LockOwner = "" Then
            MsgBox("El Modelo debe estar bloqueado en SVN")
            Exit Sub
        End If
        Dim GvarPDMnames As String() = GvarPDMfile.Split("\")
        Dim GvarPDMname As String = GvarPDMnames(UBound(GvarPDMnames))
        GvarWS.addModelo(GvarPDMname, cboEsquema.Text, GvarUID)
        sbAbrirPDM(GvarPDMfile)
    End Sub

    Private Sub btnSalvar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnSalvar.Click
        GvarPDM.Save()
        btnSalvar.Enabled = False
        GvarSalvar = False
    End Sub
End Class