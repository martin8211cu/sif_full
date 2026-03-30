<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class frmGenerar
    Inherits System.Windows.Forms.Form

    'Form overrides dispose to clean up the component list.
    <System.Diagnostics.DebuggerNonUserCode()> _
    Protected Overrides Sub Dispose(ByVal disposing As Boolean)
        Try
            If disposing AndAlso components IsNot Nothing Then
                components.Dispose()
            End If
        Finally
            MyBase.Dispose(disposing)
        End Try
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()> _
    Private Sub InitializeComponent()
        Me.btnAbrir = New System.Windows.Forms.Button
        Me.Label2 = New System.Windows.Forms.Label
        Me.Label3 = New System.Windows.Forms.Label
        Me.lstPackage = New System.Windows.Forms.ListBox
        Me.lstTables = New System.Windows.Forms.CheckedListBox
        Me.btnGenerarP = New System.Windows.Forms.Button
        Me.btnGenerarT = New System.Windows.Forms.Button
        Me.Label4 = New System.Windows.Forms.Label
        Me.cboEsquema = New System.Windows.Forms.ComboBox
        Me.dlgOpenOpen = New System.Windows.Forms.OpenFileDialog
        Me.lblFileName = New System.Windows.Forms.Label
        Me.chkAbrir = New System.Windows.Forms.CheckBox
        Me.btnGenerarD = New System.Windows.Forms.Button
        Me.Label1 = New System.Windows.Forms.Label
        Me.lstDiagrams = New System.Windows.Forms.ListBox
        Me.btnGenerarTodo = New System.Windows.Forms.Button
        Me.btnAddModelo = New System.Windows.Forms.Button
        Me.Label5 = New System.Windows.Forms.Label
        Me.txtDescripcion = New System.Windows.Forms.TextBox
        Me.btnSalvar = New System.Windows.Forms.Button
        Me.lblModelo = New System.Windows.Forms.Label
        Me.SuspendLayout()
        '
        'btnAbrir
        '
        Me.btnAbrir.Location = New System.Drawing.Point(16, 10)
        Me.btnAbrir.Name = "btnAbrir"
        Me.btnAbrir.Size = New System.Drawing.Size(84, 25)
        Me.btnAbrir.TabIndex = 2
        Me.btnAbrir.Text = "Abrir PDM"
        Me.btnAbrir.UseVisualStyleBackColor = True
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.Location = New System.Drawing.Point(26, 103)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(58, 13)
        Me.Label2.TabIndex = 3
        Me.Label2.Text = "Packages:"
        '
        'Label3
        '
        Me.Label3.AutoSize = True
        Me.Label3.Location = New System.Drawing.Point(521, 103)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(42, 13)
        Me.Label3.TabIndex = 4
        Me.Label3.Text = "Tables:"
        '
        'lstPackage
        '
        Me.lstPackage.FormattingEnabled = True
        Me.lstPackage.Location = New System.Drawing.Point(27, 125)
        Me.lstPackage.Name = "lstPackage"
        Me.lstPackage.Size = New System.Drawing.Size(228, 290)
        Me.lstPackage.Sorted = True
        Me.lstPackage.TabIndex = 5
        '
        'lstTables
        '
        Me.lstTables.CheckOnClick = True
        Me.lstTables.FormattingEnabled = True
        Me.lstTables.Location = New System.Drawing.Point(524, 125)
        Me.lstTables.Name = "lstTables"
        Me.lstTables.Size = New System.Drawing.Size(223, 289)
        Me.lstTables.Sorted = True
        Me.lstTables.TabIndex = 7
        Me.lstTables.ThreeDCheckBoxes = True
        '
        'btnGenerarP
        '
        Me.btnGenerarP.Enabled = False
        Me.btnGenerarP.Location = New System.Drawing.Point(27, 428)
        Me.btnGenerarP.Name = "btnGenerarP"
        Me.btnGenerarP.Size = New System.Drawing.Size(108, 27)
        Me.btnGenerarP.TabIndex = 8
        Me.btnGenerarP.Text = "Upload Package"
        Me.btnGenerarP.UseVisualStyleBackColor = True
        '
        'btnGenerarT
        '
        Me.btnGenerarT.Enabled = False
        Me.btnGenerarT.Location = New System.Drawing.Point(524, 428)
        Me.btnGenerarT.Name = "btnGenerarT"
        Me.btnGenerarT.Size = New System.Drawing.Size(91, 27)
        Me.btnGenerarT.TabIndex = 10
        Me.btnGenerarT.Text = "Upload Tablas"
        Me.btnGenerarT.UseVisualStyleBackColor = True
        '
        'Label4
        '
        Me.Label4.AutoSize = True
        Me.Label4.Location = New System.Drawing.Point(12, 52)
        Me.Label4.Name = "Label4"
        Me.Label4.Size = New System.Drawing.Size(54, 13)
        Me.Label4.TabIndex = 11
        Me.Label4.Text = "Esquema:"
        '
        'cboEsquema
        '
        Me.cboEsquema.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboEsquema.FormattingEnabled = True
        Me.cboEsquema.Location = New System.Drawing.Point(125, 51)
        Me.cboEsquema.Name = "cboEsquema"
        Me.cboEsquema.Size = New System.Drawing.Size(196, 21)
        Me.cboEsquema.TabIndex = 12
        '
        'dlgOpenOpen
        '
        Me.dlgOpenOpen.Filter = "PowerDesigner Physical Data Model|*.pdm"
        Me.dlgOpenOpen.Title = "PDM Open"
        '
        'lblFileName
        '
        Me.lblFileName.BackColor = System.Drawing.SystemColors.Control
        Me.lblFileName.Cursor = System.Windows.Forms.Cursors.Default
        Me.lblFileName.Font = New System.Drawing.Font("Arial", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblFileName.ForeColor = System.Drawing.SystemColors.ControlText
        Me.lblFileName.Location = New System.Drawing.Point(143, 15)
        Me.lblFileName.Name = "lblFileName"
        Me.lblFileName.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.lblFileName.Size = New System.Drawing.Size(577, 15)
        Me.lblFileName.TabIndex = 13
        '
        'chkAbrir
        '
        Me.chkAbrir.AutoSize = True
        Me.chkAbrir.Location = New System.Drawing.Point(125, 17)
        Me.chkAbrir.Name = "chkAbrir"
        Me.chkAbrir.Size = New System.Drawing.Size(15, 14)
        Me.chkAbrir.TabIndex = 14
        Me.chkAbrir.UseVisualStyleBackColor = True
        '
        'btnGenerarD
        '
        Me.btnGenerarD.Enabled = False
        Me.btnGenerarD.Location = New System.Drawing.Point(278, 428)
        Me.btnGenerarD.Name = "btnGenerarD"
        Me.btnGenerarD.Size = New System.Drawing.Size(100, 27)
        Me.btnGenerarD.TabIndex = 17
        Me.btnGenerarD.Text = "Upload Diagram"
        Me.btnGenerarD.UseVisualStyleBackColor = True
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(276, 103)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(54, 13)
        Me.Label1.TabIndex = 15
        Me.Label1.Text = "Diagrams:"
        '
        'lstDiagrams
        '
        Me.lstDiagrams.FormattingEnabled = True
        Me.lstDiagrams.Location = New System.Drawing.Point(278, 125)
        Me.lstDiagrams.Name = "lstDiagrams"
        Me.lstDiagrams.Size = New System.Drawing.Size(228, 290)
        Me.lstDiagrams.Sorted = True
        Me.lstDiagrams.TabIndex = 18
        '
        'btnGenerarTodo
        '
        Me.btnGenerarTodo.Enabled = False
        Me.btnGenerarTodo.Location = New System.Drawing.Point(346, 47)
        Me.btnGenerarTodo.Name = "btnGenerarTodo"
        Me.btnGenerarTodo.Size = New System.Drawing.Size(160, 27)
        Me.btnGenerarTodo.TabIndex = 19
        Me.btnGenerarTodo.Text = "Upload de Todo el Modelo"
        Me.btnGenerarTodo.UseVisualStyleBackColor = True
        '
        'btnAddModelo
        '
        Me.btnAddModelo.Enabled = False
        Me.btnAddModelo.Location = New System.Drawing.Point(346, 48)
        Me.btnAddModelo.Name = "btnAddModelo"
        Me.btnAddModelo.Size = New System.Drawing.Size(160, 27)
        Me.btnAddModelo.TabIndex = 21
        Me.btnAddModelo.Text = "Agregar Modelo"
        Me.btnAddModelo.UseVisualStyleBackColor = True
        '
        'Label5
        '
        Me.Label5.AutoSize = True
        Me.Label5.Location = New System.Drawing.Point(12, 83)
        Me.Label5.Name = "Label5"
        Me.Label5.Size = New System.Drawing.Size(103, 13)
        Me.Label5.TabIndex = 22
        Me.Label5.Text = "Descripcion Parche:"
        '
        'txtDescripcion
        '
        Me.txtDescripcion.Location = New System.Drawing.Point(125, 79)
        Me.txtDescripcion.MaxLength = 80
        Me.txtDescripcion.Name = "txtDescripcion"
        Me.txtDescripcion.Size = New System.Drawing.Size(381, 20)
        Me.txtDescripcion.TabIndex = 23
        '
        'btnSalvar
        '
        Me.btnSalvar.Enabled = False
        Me.btnSalvar.Location = New System.Drawing.Point(524, 77)
        Me.btnSalvar.Name = "btnSalvar"
        Me.btnSalvar.Size = New System.Drawing.Size(75, 23)
        Me.btnSalvar.TabIndex = 24
        Me.btnSalvar.Text = "Salvar"
        Me.btnSalvar.UseVisualStyleBackColor = True
        '
        'lblModelo
        '
        Me.lblModelo.AutoSize = True
        Me.lblModelo.Location = New System.Drawing.Point(565, 104)
        Me.lblModelo.Name = "lblModelo"
        Me.lblModelo.Size = New System.Drawing.Size(0, 13)
        Me.lblModelo.TabIndex = 26
        '
        'frmGenerar
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(776, 461)
        Me.Controls.Add(Me.lblModelo)
        Me.Controls.Add(Me.btnSalvar)
        Me.Controls.Add(Me.txtDescripcion)
        Me.Controls.Add(Me.Label5)
        Me.Controls.Add(Me.btnAddModelo)
        Me.Controls.Add(Me.btnGenerarTodo)
        Me.Controls.Add(Me.lstDiagrams)
        Me.Controls.Add(Me.btnGenerarD)
        Me.Controls.Add(Me.Label1)
        Me.Controls.Add(Me.chkAbrir)
        Me.Controls.Add(Me.lblFileName)
        Me.Controls.Add(Me.cboEsquema)
        Me.Controls.Add(Me.Label4)
        Me.Controls.Add(Me.btnGenerarT)
        Me.Controls.Add(Me.btnGenerarP)
        Me.Controls.Add(Me.lstTables)
        Me.Controls.Add(Me.lstPackage)
        Me.Controls.Add(Me.Label3)
        Me.Controls.Add(Me.Label2)
        Me.Controls.Add(Me.btnAbrir)
        Me.Name = "frmGenerar"
        Me.Text = "Upload de Definiciones PowerDesigner a Coldfusion"
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents btnAbrir As System.Windows.Forms.Button
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents Label3 As System.Windows.Forms.Label
    Friend WithEvents lstPackage As System.Windows.Forms.ListBox
    Friend WithEvents lstTables As System.Windows.Forms.CheckedListBox
    Friend WithEvents btnGenerarP As System.Windows.Forms.Button
    Friend WithEvents btnGenerarT As System.Windows.Forms.Button
    Friend WithEvents Label4 As System.Windows.Forms.Label
    Friend WithEvents cboEsquema As System.Windows.Forms.ComboBox
    Public WithEvents dlgOpenOpen As System.Windows.Forms.OpenFileDialog
    Public WithEvents lblFileName As System.Windows.Forms.Label
    Friend WithEvents chkAbrir As System.Windows.Forms.CheckBox
    Friend WithEvents btnGenerarD As System.Windows.Forms.Button
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents lstDiagrams As System.Windows.Forms.ListBox
    Friend WithEvents btnGenerarTodo As System.Windows.Forms.Button
    Friend WithEvents btnAddModelo As System.Windows.Forms.Button
    Friend WithEvents Label5 As System.Windows.Forms.Label
    Friend WithEvents txtDescripcion As System.Windows.Forms.TextBox
    Friend WithEvents btnSalvar As System.Windows.Forms.Button
    Friend WithEvents lblModelo As System.Windows.Forms.Label
End Class
