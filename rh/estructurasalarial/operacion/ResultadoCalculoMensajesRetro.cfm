<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_Errores" default="Errores Presentados en el C&aacute;lculo de la N&oacute;omina Actual"	 returnvariable="LB_Errores" component="sif.Componentes.Translate" method="Translate"/>
<!--- Variables por URL --->
<cfif isdefined("url.RCNid") and len(trim(url.RCNid))>
	<cfset form.RCNid = url.RCNid>
</cfif>

<!--- DATOS DE LA RELACION DE CALCULO --->
<cfquery name="CalendarioPagos" datasource="#session.DSN#">
	select CPtipo, CPdesde, CPhasta, Tcodigo
	from CalendarioPagos
	where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">
</cfquery>

<!--- VERIFICA SI DENTRO DE LA RELACIÓN HAY EMPLEADOS CON SALARIO LIQUIDO EN NEGATIVO --->
<cfquery name="rsSalNegativos" datasource="#session.DSN#">
	select DEidentificacion, {fn concat({fn concat({fn concat({ fn concat(b.DEapellido1, ' ') },b.DEapellido2)}, ' ')},b.DEnombre) } as nombreEmpl
	from SalarioEmpleado a
		inner join DatosEmpleado b
			on b.DEid = a.DEid
	where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">
	  and SEliquido < 0
</cfquery>
	<!--- SE DEBE DE VER CUALES VERIFICACIONES SE TIENE QUE TOMAR EN CUENTA PARA LASNÓMINAS DE RETROACTIVO --->
	<cfif CalendarioPagos.CPtipo EQ 3>
	</cfif>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title><cfoutput>#LB_Errores#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<cf_templatecss>
</head>

<body>
	<cfoutput>
	
		<!--- Pintado de la Pantalla --->
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td align="center">
					<table width="98%" cellpadding="5" cellspacing="5" border="0" >
						<tr>
							<td align="Center" class="areaFiltro" colspan="2">
								<font size="2"><strong><cf_translate key="LB_ErroresPresentadosEnElCalculoDeLaNominaActual">
									Errores presentados en la n&oacute;mina actual.
								</cf_translate></strong></font>
							</td>
						</tr>
						<cfif isdefined('rsSalNegativos') and rsSalNegativos.RecordCount>
							<tr>	
								<td align="left" colspan="2"><cf_translate key="LB_LasSiguientesPersonasTieneSalarioNegativo">Las siguientes personas tienen el salario Negativo</cf_translate></td>
							</tr>
							<cfloop query="rsSalNegativos">
								<tr>
									<td width="5%">&nbsp;</td>
									<td align="left">#DEidentificacion#&nbsp;&nbsp;-&nbsp;&nbsp;#nombreEmpl# </td>
								</tr>
							</cfloop>
						</cfif>
						<cfif isdefined('Lvar_Error') and Lvar_Error EQ 1>
							<tr>	
								<td align="left" colspan="2">
									<cf_translate key="LB_Error1">
										Existe una nómina anterior que no ha sido cerrada o no hay sido generada. Favor verifique.
									</cf_translate>
								</td>
							</tr>
						</cfif>
						<cfif isdefined('Lvar_ErrorEsp') and Lvar_ErrorEsp EQ 1>
							<tr>	
								<td align="left" colspan="2">
									<cf_translate key="LB_Error2">
										Existe un calendario del mismo tipo de nomina abierto y con fecha hasta menor a la fecha  
									  hasta del calendario especial que se esta generando. Favor verifique.
									</cf_translate>
								</td>
							</tr>
						</cfif>
					</table>
				</td>
			</tr>
		</table>
	</cfoutput>
</body>
</html>
