<cfset t=createObject("component","sif.Componentes.Translate")>
<cfset LB_AyudaDelSistema = t.Translate('LB_AyudaDelSistema','Ayuda del sistema')>
<cfset LB_VariablesDisponibles = t.Translate('LB_VariablesDisponibles','Variables disponibles')>
<cfset LB_Variable = t.Translate('LB_Variable','Variable')>
<cfset LB_Descripcion = t.Translate('LB_Descripcion','Descripción','/rh/generales.xml')>
<cfset LB_NombreDeLaEmpresaEnLaQueLaboraElEmpleado = t.Translate('LB_NombreDeLaEmpresaEnLaQueLaboraElEmpleado','Nombre de la empresa en la que labora el empleado')>
<cfset LB_IdentificacionDelEmpleado = t.Translate('LB_IdentificacionDelEmpleado','Identificación del empleado')>
<cfset LB_NombreDelEmpleado = t.Translate('LB_NombreDelEmpleado','Nombre del empleado')>
<cfset LB_FechaActual = t.Translate('LB_FechaActual','Fecha actual','/rh/generales.xml')>
<cfset LB_PeriodoEnCurso = t.Translate('LB_PeriodoEnCurso','Periodo en curso')>
<cfset LB_MesEnCurso = t.Translate('LB_MesEnCurso','Mes en curso')>
<cfset LB_SalarioMensualDelEmpleado = t.Translate('LB_SalarioMensualDelEmpleado','Salario mensual del empleado')>
<cfset LB_SalarioBrutoDelEmpleado = t.Translate('LB_SalarioBrutoDelEmpleado','Salario bruto del empleado')>
<cfset LB_SalarioLiquidoDelEmpleado = t.Translate('LB_SalarioLiquidoDelEmpleado','Salario líquido del empleado')>
<cfset LB_MontoTotalDeLasDeduccionesVigentes = t.Translate('LB_MontoTotalDeLasDeduccionesVigentes','Monto total de las deducciones vigentes')>
<cfset LB_MontoCorrespondienteAlImpuestoDeRentaSegunSalario = t.Translate('LB_MontoCorrespondienteAlImpuestoDeRentaSegunSalario','Monto correspondiente al impuesto de renta según salario')>
<cfset LB_FechaDeIngresoDelEmpleado = t.Translate('LB_FechaDeIngresoDelEmpleado','Fecha de ingreso del empleado')>
<cfset LB_Puesto = t.Translate('LB_Puesto','´Puesto','/rh/generales.xml')>
<cfset LB_OficinaDondeLaboraElEmpleado = t.Translate('LB_OficinaDondeLaboraElEmpleado','Oficina donde labora el empleado')>
<cfset LB_MontoEnLetras_Ej = t.Translate('LB_MontoEnLetras_Ej','Monto en letras. Ex')>
<cfset LB_UsuarioQueEmiteLaCertificacion = t.Translate('LB_UsuarioQueEmiteLaCertificacion','Usuario que emite la certificación')>
<cfset LB_Cerrar = t.Translate('LB_Cerrar','Cerrar','/rh/generales.xml')>
<cfset LB_ResponsabilidadesP = t.Translate('LB_ResponsabilidadesP','Responsabilidades del Puesto')>
<cfset LB_CURP = t.Translate('LB_CURP','CURP Empleado')>
<cfset LB_RFC = t.Translate('LB_RFC','RFC Empleado')>
<cfset LB_Dato1 = t.Translate('LB_Dato1','Dato variable 1 del empleado')>
<cfset LB_Dato2 = t.Translate('LB_Dato2','Dato variable 2 del empleado')>
<cfset LB_Dato3 = t.Translate('LB_Dato3','Dato variable 3 del empleado')>
<cfset LB_Dato4 = t.Translate('LB_Dato4','Dato variable 4 del empleado')>
<cfset LB_Dato5 = t.Translate('LB_Dato5','Dato variable 5 del empleado')>
<cfset LB_Dato6 = t.Translate('LB_Dato6','Dato variable 6 del empleado')>
<cfset LB_DEapellido1 = t.Translate('LB_DEapellido1','Apellido Paterno del empleado')>
<cfset LB_DEapellido2 = t.Translate('LB_DEapellido2','Apellido Materno del empleado')>
<cfset LB_SalarioDiario = t.Translate('LB_SalarioDiario','Salario Diario empleado')>
<cfset LB_SalarioDiarioLetra = t.Translate('LB_SalarioDiario','Salario Diario empleado en letra')>
<cfset LB_DEdireccion = t.Translate('LB_DEdireccion','Direccion empleado')>

<cfoutput>
<html>
<head>
<title>#LB_AyudaDelSistema#</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

</head>
<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<P align=center>
				<STRONG>
					<FONT face=Tahoma color=##6666ff size=4>
						#LB_VariablesDisponibles#
					</FONT>
				</STRONG>
			</P>
			<P align=center>
			<TABLE style="WIDTH: 429px; HEIGHT: 209px" cellSpacing=1 cellPadding=1 width=429 border=1>
				<TBODY>
					<TR>
						<TD>
							<FONT face=Tahoma color=##000000>
								<STRONG>
									<U>
										#LB_Variable#
									</U>
								</STRONG>
							</FONT>
						</TD>
						<TD>
							<P align=right>
								<FONT face=Tahoma color=##000000>
									<STRONG>
									</STRONG>
								</FONT>
								&nbsp;
							</P>
						</TD>
						<TD>
							<FONT face=Tahoma color=##000000>
								<STRONG>
									&nbsp;
									<U>
										#LB_Descripcion#
									</U>
								</STRONG>
							</FONT>
						</TD>
					</TR>
					<TR>
						<TD>
							<P align=left>
								<FONT face=Tahoma size=2>
									<STRONG>
										##empresa##
									</STRONG>
								</FONT>
							</P>
						</TD>
						<TD>
							<P align=left>
								<FONT face=Tahoma size=2>
									<STRONG>
										&nbsp;&nbsp;&nbsp;
									</STRONG>
								</FONT>
							</P>
						</TD>
						<TD noWrap>
							<FONT face=Tahoma size=2>
								&nbsp;#LB_NombreDeLaEmpresaEnLaQueLaboraElEmpleado#.
							</FONT>
						</TD>
					</TR>
					<TR>
						<TD>
							<P>
								<FONT face=Tahoma size=2>
									<STRONG>
										##identificacion##
									</STRONG>
								</FONT>
							</P>
						</TD>
						<TD>
							<P>
								<FONT face=Tahoma size=2>
									<STRONG>
									</STRONG>
								</FONT>
								&nbsp;
							</P>
						</TD>
						<TD>
							<FONT face=Tahoma size=2>
								&nbsp;#LB_IdentificacionDelEmpleado#.
							</FONT>
						</TD>
					</TR>
					<TR>
						<TD>
							<P align=left>
								<STRONG>
									<FONT face=Tahoma size=2>
										##nombre##
									</FONT>
								</STRONG>
							</P>
						</TD>
						<TD>
							<FONT face=Tahoma size=2>
								<STRONG>
								</STRONG>
							</FONT>
						</TD>
						<TD>
							<FONT face=Tahoma size=2>
								&nbsp;#LB_NombreDelEmpleado#.
							</FONT>
						</TD>
					</TR>
					<TR>
						<TD>
							<P align=left>
								<STRONG>
									<FONT face=Tahoma size=2>
										##hoy##
									</FONT>
								</STRONG>
							</P>
						</TD>
						<TD>
							<FONT face=Tahoma size=2>
								<STRONG>
								</STRONG>
							</FONT>
						</TD>
						<TD>
							<FONT face=Tahoma size=2>
								&nbsp;#LB_FechaActual#.
							</FONT>
						</TD>
					</TR>
					<TR>
						<TD>
							<P align=left>
								<STRONG>
									<FONT face=Tahoma size=2>
										##periodo##
									</FONT>
								</STRONG>
							</P>
						</TD>
						<TD>
							<FONT face=Tahoma size=2>
								<STRONG>
								</STRONG>
							</FONT>
						</TD>
						<TD>
							<FONT face=Tahoma size=2>
								&nbsp;#LB_PeriodoEnCurso#.
							</FONT>
						</TD>
					</TR>
					<TR>
						<TD>
							<P align=left>
								<STRONG>
									<FONT face=Tahoma size=2>
										##mes##
									</FONT>
								</STRONG>
							</P>
						</TD>
						<TD>
							<FONT face=Tahoma size=2>
								<STRONG>
								</STRONG>
							</FONT>
						</TD>
						<TD>
							<FONT face=Tahoma size=2>
								&nbsp;#LB_MesEnCurso#.
							</FONT>
						</TD>
					</TR>
					<TR>
						<TD>
							<P align=left>
								<STRONG>
									<FONT face=Tahoma size=2>
										##salariomensual##
									</FONT>
								</STRONG>
							</P>
						</TD>
						<TD>
							<FONT face=Tahoma size=2>
								<STRONG>
								</STRONG>
							</FONT>
						</TD>
						<TD>
							<FONT face=Tahoma size=2>
								&nbsp;#LB_SalarioMensualDelEmpleado#.
							</FONT>
						</TD>
					</TR>
					<TR>
						<TD>
							<P align=left>
								<FONT face=Tahoma size=2>
									<STRONG>
										##salariobruto##
									</STRONG>
								</FONT>
							</P>
						</TD>
						<TD>
							<P>
								<FONT face=Tahoma size=2>
									<STRONG>
									</STRONG>
								</FONT>
								&nbsp;
							</P>
						</TD>
						<TD>
							<FONT face=Tahoma size=2>
								&nbsp;#LB_SalarioBrutoDelEmpleado#.
							</FONT>
						</TD>
					</TR>
					<TR>
						<TD>
							<STRONG>
								<FONT face=Tahoma size=2>
									##salarioliquido##
								</FONT>
							</STRONG>
						</TD>
						<TD>
							<FONT size=2>
							</FONT>
						</TD>
						<TD>
							<FONT size=2>
								&nbsp;
								<FONT face=Tahoma>
									#LB_SalarioLiquidoDelEmpleado#.
								</FONT>
							</FONT>
						</TD>
					</TR>
					<TR>
						<TD>
							<P>
								<FONT face=Tahoma size=2>
									<STRONG>
										##deducciones##
									</STRONG>
								</FONT>
							</P>
						</TD>
						<TD>
							<FONT size=2>
							</FONT>
						</TD>
						<TD>
							<FONT face=Tahoma size=2>
								&nbsp;#LB_MontoTotalDeLasDeduccionesVigentes#.
							</FONT>
						</TD>
					</TR>
					<TR>
						<TD>
							<STRONG>
								<FONT face=Tahoma size=2>
									##renta##
								</FONT>
							</STRONG>
						</TD>
						<TD>
							<FONT size=2>
							</FONT>
						</TD>
						<TD noWrap>
							<P>
								<FONT face=Tahoma>
									<FONT size=2>
										<STRONG>
											&nbsp;
										</STRONG>
										#LB_MontoCorrespondienteAlImpuestoDeRentaSegunSalario#.
									</FONT>
								</FONT>
							</P>
						</TD>
					</TR>
					<TR>
						<TD height=24>
							<P align=left>
								<STRONG>
									<FONT face=Tahoma size=2>
										##fechaingreso##
									</FONT>
								</STRONG>
							</P>
						</TD>
						<TD>
							<FONT face=Tahoma size=2>
								<STRONG>
								</STRONG>
							</FONT>
						</TD>
						<TD>
							<P>
								<FONT face=Tahoma size=2>
									&nbsp;#LB_FechaDeIngresoDelEmpleado#.
								</FONT>
							</P>
						</TD>
					</TR>
					<P>
					</P>
					<TR>
						<TD>
							<FONT face=Tahoma size=2>
								<STRONG>
									##puesto##
								</STRONG>
							</FONT>
						</TD>
						<TD>
							<FONT face=Tahoma size=2>
								&nbsp;
							</FONT>
						</TD>
						<TD>
							<P>
								<FONT face=Tahoma size=2>
									&nbsp;#LB_Puesto#.
								</FONT>
							</P>
						</TD>
					</TR>
					<TR>
						<TD>
							<FONT face=Tahoma size=2>
								<STRONG>
									##oficina##
								</STRONG>
							</FONT>
						</TD>
						<TD>
							<FONT face=Tahoma size=2>
								&nbsp;
							</FONT>
						</TD>
						<TD>
							<P>
								<FONT face=Tahoma size=2>
									&nbsp;#LB_OficinaDondeLaboraElEmpleado#.
								</FONT>
							</P>
						</TD>
					</TR>
					<TR>
						<TD>
							<STRONG>
								<FONT face="Tahoma, Arial, Helvetica, sans-serif" size=2>
									##letras##
								</FONT>
							</STRONG>
							&nbsp;
						</TD>
						<TD>
							&nbsp;
						</TD>
						<TD>
							<FONT face="Tahoma, Arial, Helvetica, sans-serif" size=2>
								&nbsp;#LB_MontoEnLetras_Ej#: ##letras(##renta##)##
							</FONT>
						</TD>
					</TR>
					<TR>
						<TD>
							<STRONG>
								<FONT face=Tahoma size=2>
									##usuario##
								</FONT>
							</STRONG>
							&nbsp;&nbsp;
						</TD>
						<TD>
							&nbsp;
						</TD>
						<TD>
							<SPAN lang=ES style="FONT-SIZE: 12pt; BACKGROUND: olive; FONT-FAMILY: 'Times New Roman'; mso-fareast-font-family: 'Times New Roman'; mso-highlight: olive; mso-ansi-language: ES; mso-fareast-language: ES; mso-bidi-language: AR-SA">
								<FONT style="BACKGROUND-COLOR: ##ffffff">
									&nbsp;
									<FONT face="Tahoma, Arial, Helvetica, sans-serif" size=2>
										#LB_UsuarioQueEmiteLaCertificacion#
									</FONT>
								</FONT>
							</SPAN>
						</TD>
					</TR>

					<TR>
						<TD>
							<STRONG>
								<FONT face=Tahoma size=2>
									##CURP##
								</FONT>
							</STRONG>
							&nbsp;&nbsp;
						</TD>
						<TD>
							&nbsp;
						</TD>
						<TD>
							<SPAN lang=ES style="FONT-SIZE: 12pt; BACKGROUND: olive; FONT-FAMILY: 'Times New Roman'; mso-fareast-font-family: 'Times New Roman'; mso-highlight: olive; mso-ansi-language: ES; mso-fareast-language: ES; mso-bidi-language: AR-SA">
								<FONT style="BACKGROUND-COLOR: ##ffffff">
									&nbsp;
									<FONT face="Tahoma, Arial, Helvetica, sans-serif" size=2>
										#LB_CURP#
									</FONT>
								</FONT>
							</SPAN>
						</TD>
					</TR>

					<TR>
						<TD>
							<STRONG>
								<FONT face=Tahoma size=2>
									##RFC##
								</FONT>
							</STRONG>
							&nbsp;&nbsp;
						</TD>
						<TD>
							&nbsp;
						</TD>
						<TD>
							<SPAN lang=ES style="FONT-SIZE: 12pt; BACKGROUND: olive; FONT-FAMILY: 'Times New Roman'; mso-fareast-font-family: 'Times New Roman'; mso-highlight: olive; mso-ansi-language: ES; mso-fareast-language: ES; mso-bidi-language: AR-SA">
								<FONT style="BACKGROUND-COLOR: ##ffffff">
									&nbsp;
									<FONT face="Tahoma, Arial, Helvetica, sans-serif" size=2>
										#LB_RFC#
									</FONT>
								</FONT>
							</SPAN>
						</TD>
					</TR>

					<TR>
						<TD>
							<STRONG>
								<FONT face=Tahoma size=2>
									##Responsabilidades##
								</FONT>
							</STRONG>
							&nbsp;&nbsp
						</TD>
						<TD>
							&nbsp;
						</TD>
						<TD>
							<SPAN lang=ES style="FONT-SIZE: 12pt; BACKGROUND: olive; FONT-FAMILY: 'Times New Roman'; mso-fareast-font-family: 'Times New Roman'; mso-highlight: olive; mso-ansi-language: ES; mso-fareast-language: ES; mso-bidi-language: AR-SA">
								<FONT style="BACKGROUND-COLOR: ##ffffff">
									&nbsp;
									<FONT face="Tahoma, Arial, Helvetica, sans-serif" size=2>
										#LB_ResponsabilidadesP#
									</FONT>
								</FONT>
							</SPAN>
						</TD>
					</TR>

					<TR>
						<TD>
							<STRONG>
								<FONT face=Tahoma size=2>
									##Dato1##
								</FONT>
							</STRONG>
							&nbsp;&nbsp;
						</TD>
						<TD>
							&nbsp;
						</TD>
						<TD>
							<SPAN lang=ES style="FONT-SIZE: 12pt; BACKGROUND: olive; FONT-FAMILY: 'Times New Roman'; mso-fareast-font-family: 'Times New Roman'; mso-highlight: olive; mso-ansi-language: ES; mso-fareast-language: ES; mso-bidi-language: AR-SA">
								<FONT style="BACKGROUND-COLOR: ##ffffff">
									&nbsp;
									<FONT face="Tahoma, Arial, Helvetica, sans-serif" size=2>
										#LB_Dato1#
									</FONT>
								</FONT>
							</SPAN>
						</TD>
					</TR>

					<TR>
						<TD>
							<STRONG>
								<FONT face=Tahoma size=2>
									##Dato2##
								</FONT>
							</STRONG>
							&nbsp;&nbsp;
						</TD>
						<TD>
							&nbsp;
						</TD>
						<TD>
							<SPAN lang=ES style="FONT-SIZE: 12pt; BACKGROUND: olive; FONT-FAMILY: 'Times New Roman'; mso-fareast-font-family: 'Times New Roman'; mso-highlight: olive; mso-ansi-language: ES; mso-fareast-language: ES; mso-bidi-language: AR-SA">
								<FONT style="BACKGROUND-COLOR: ##ffffff">
									&nbsp;
									<FONT face="Tahoma, Arial, Helvetica, sans-serif" size=2>
										#LB_Dato2#
									</FONT>
								</FONT>
							</SPAN>
						</TD>
					</TR>

					<TR>
						<TD>
							<STRONG>
								<FONT face=Tahoma size=2>
									##Dato3##
								</FONT>
							</STRONG>
							&nbsp;&nbsp;
						</TD>
						<TD>
							&nbsp;
						</TD>
						<TD>
							<SPAN lang=ES style="FONT-SIZE: 12pt; BACKGROUND: olive; FONT-FAMILY: 'Times New Roman'; mso-fareast-font-family: 'Times New Roman'; mso-highlight: olive; mso-ansi-language: ES; mso-fareast-language: ES; mso-bidi-language: AR-SA">
								<FONT style="BACKGROUND-COLOR: ##ffffff">
									&nbsp;
									<FONT face="Tahoma, Arial, Helvetica, sans-serif" size=2>
										#LB_Dato3#
									</FONT>
								</FONT>
							</SPAN>
						</TD>
					</TR>

					<TR>
						<TD>
							<STRONG>
								<FONT face=Tahoma size=2>
									##Dato4##
								</FONT>
							</STRONG>
							&nbsp;&nbsp;
						</TD>
						<TD>
							&nbsp;
						</TD>
						<TD>
							<SPAN lang=ES style="FONT-SIZE: 12pt; BACKGROUND: olive; FONT-FAMILY: 'Times New Roman'; mso-fareast-font-family: 'Times New Roman'; mso-highlight: olive; mso-ansi-language: ES; mso-fareast-language: ES; mso-bidi-language: AR-SA">
								<FONT style="BACKGROUND-COLOR: ##ffffff">
									&nbsp;
									<FONT face="Tahoma, Arial, Helvetica, sans-serif" size=2>
										#LB_Dato4#
									</FONT>
								</FONT>
							</SPAN>
						</TD>
					</TR>

					<TR>
						<TD>
							<STRONG>
								<FONT face=Tahoma size=2>
									##Dato5##
								</FONT>
							</STRONG>
							&nbsp;&nbsp;
						</TD>
						<TD>
							&nbsp;
						</TD>
						<TD>
							<SPAN lang=ES style="FONT-SIZE: 12pt; BACKGROUND: olive; FONT-FAMILY: 'Times New Roman'; mso-fareast-font-family: 'Times New Roman'; mso-highlight: olive; mso-ansi-language: ES; mso-fareast-language: ES; mso-bidi-language: AR-SA">
								<FONT style="BACKGROUND-COLOR: ##ffffff">
									&nbsp;
									<FONT face="Tahoma, Arial, Helvetica, sans-serif" size=2>
										#LB_Dato5#
									</FONT>
								</FONT>
							</SPAN>
						</TD>
					</TR>

					<TR>
						<TD>
							<STRONG>
								<FONT face=Tahoma size=2>
									##Dato6##
								</FONT>
							</STRONG>
							&nbsp;&nbsp;
						</TD>
						<TD>
							&nbsp;
						</TD>
						<TD>
							<SPAN lang=ES style="FONT-SIZE: 12pt; BACKGROUND: olive; FONT-FAMILY: 'Times New Roman'; mso-fareast-font-family: 'Times New Roman'; mso-highlight: olive; mso-ansi-language: ES; mso-fareast-language: ES; mso-bidi-language: AR-SA">
								<FONT style="BACKGROUND-COLOR: ##ffffff">
									&nbsp;
									<FONT face="Tahoma, Arial, Helvetica, sans-serif" size=2>
										#LB_Dato6#
									</FONT>
								</FONT>
							</SPAN>
						</TD>
					</TR>

					<TR>
						<TD>
							<STRONG>
								<FONT face=Tahoma size=2>
									##DEapellido1##
								</FONT>
							</STRONG>
							&nbsp;&nbsp;
						</TD>
						<TD>
							&nbsp;
						</TD>
						<TD>
							<SPAN lang=ES style="FONT-SIZE: 12pt; BACKGROUND: olive; FONT-FAMILY: 'Times New Roman'; mso-fareast-font-family: 'Times New Roman'; mso-highlight: olive; mso-ansi-language: ES; mso-fareast-language: ES; mso-bidi-language: AR-SA">
								<FONT style="BACKGROUND-COLOR: ##ffffff">
									&nbsp;
									<FONT face="Tahoma, Arial, Helvetica, sans-serif" size=2>
										#LB_DEapellido1#
									</FONT>
								</FONT>
							</SPAN>
						</TD>
					</TR>

					<TR>
						<TD>
							<STRONG>
								<FONT face=Tahoma size=2>
									##DEapellido2##
								</FONT>
							</STRONG>
							&nbsp;&nbsp;
						</TD>
						<TD>
							&nbsp;
						</TD>
						<TD>
							<SPAN lang=ES style="FONT-SIZE: 12pt; BACKGROUND: olive; FONT-FAMILY: 'Times New Roman'; mso-fareast-font-family: 'Times New Roman'; mso-highlight: olive; mso-ansi-language: ES; mso-fareast-language: ES; mso-bidi-language: AR-SA">
								<FONT style="BACKGROUND-COLOR: ##ffffff">
									&nbsp;
									<FONT face="Tahoma, Arial, Helvetica, sans-serif" size=2>
										#LB_DEapellido2#
									</FONT>
								</FONT>
							</SPAN>
						</TD>
					</TR>

					<TR>
						<TD>
							<STRONG>
								<FONT face=Tahoma size=2>
									##SalarioDiario##
								</FONT>
							</STRONG>
							&nbsp;&nbsp;
						</TD>
						<TD>
							&nbsp;
						</TD>
						<TD>
							<SPAN lang=ES style="FONT-SIZE: 12pt; BACKGROUND: olive; FONT-FAMILY: 'Times New Roman'; mso-fareast-font-family: 'Times New Roman'; mso-highlight: olive; mso-ansi-language: ES; mso-fareast-language: ES; mso-bidi-language: AR-SA">
								<FONT style="BACKGROUND-COLOR: ##ffffff">
									&nbsp;
									<FONT face="Tahoma, Arial, Helvetica, sans-serif" size=2>
										#LB_SalarioDiario#
									</FONT>
								</FONT>
							</SPAN>
						</TD>
					</TR>

					<TR>
						<TD>
							<STRONG>
								<FONT face=Tahoma size=2>
									##SalarioDiarioLetra##
								</FONT>
							</STRONG>
							&nbsp;&nbsp
						</TD>
						<TD>
							&nbsp;
						</TD>
						<TD>
							<SPAN lang=ES style="FONT-SIZE: 12pt; BACKGROUND: olive; FONT-FAMILY: 'Times New Roman'; mso-fareast-font-family: 'Times New Roman'; mso-highlight: olive; mso-ansi-language: ES; mso-fareast-language: ES; mso-bidi-language: AR-SA">
								<FONT style="BACKGROUND-COLOR: ##ffffff">
									&nbsp;
									<FONT face="Tahoma, Arial, Helvetica, sans-serif" size=2>
										#LB_SalarioDiarioLetra#
									</FONT>
								</FONT>
							</SPAN>
						</TD>
					</TR>

					<TR>
						<TD>
							<STRONG>
								<FONT face=Tahoma size=2>
									##DEdireccion##
								</FONT>
							</STRONG>
							&nbsp;&nbsp
						</TD>
						<TD>
							&nbsp;
						</TD>
						<TD>
							<SPAN lang=ES style="FONT-SIZE: 12pt; BACKGROUND: olive; FONT-FAMILY: 'Times New Roman'; mso-fareast-font-family: 'Times New Roman'; mso-highlight: olive; mso-ansi-language: ES; mso-fareast-language: ES; mso-bidi-language: AR-SA">
								<FONT style="BACKGROUND-COLOR: ##ffffff">
									&nbsp;
									<FONT face="Tahoma, Arial, Helvetica, sans-serif" size=2>
										#LB_DEdireccion#
									</FONT>
								</FONT>
							</SPAN>
						</TD>
					</TR>

					<TR>
						<TD>
							&nbsp;
						</TD>
						<TD>
							&nbsp;
						</TD>
						<TD>
							&nbsp;
						</TD>
					</TR>
				</TBODY>
			</TABLE>
			</P>
		</td>
		<td>
			<img name="imasist" src="/cfmx/sif/imagenes/asistente1.gif">
		</td>
		<td>
	</tr>
</table>
<br>
<div align="center">
  <input type="button" name="cerrar" value="#LB_Cerrar#" onClick="window.close();" style="background-color: ##FAFAFA; font-size: xx-small">
</div>

</body>
</html>
</cfoutput>