<!--- Variables por URL --->
<cfif isdefined("url.RHPTUEMid") and len(trim(url.RHPTUEMid))>
	<cfset form.RHPTUEMid = url.RHPTUEMid>
</cfif>
<cfif isdefined("url.RHPTUEid") and len(trim(url.RHPTUEid))>
	<cfset form.RHPTUEid = url.RHPTUEid>
</cfif>

<!--- Consulta del campo RHPTUEMjustificacion --->
<cfquery name="rsJustificacion" datasource="#Session.DSN#">
	select rtrim(RHPTUEMjustificacion) as RHPTUEMjustificacion, RHPTUEMreconocido
	from RHPTUEMpleados
	where RHPTUEMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPTUEMid#">
		and RHPTUEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPTUEid#">
		and Ecodigo = #Session.Ecodigo#
</cfquery>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<!---=================== TRADUCCION =======================---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Justificacion_del_PTU_Personal"
	Default="Justificaci&oacute;n de por que no reconoce a este empleado para el pago del PTU"	
	returnvariable="LB_Titulo"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_RECONOCER"
	Default="RECONOCER"
	returnvariable="BTN_RECONOCER"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_NO_RECONOCER"
	Default="NO RECONOCER"
	returnvariable="BTN_NO_RECONOCER"/>

	
<title><cfoutput>#LB_Titulo#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>

<body>
	<cfoutput>
	<form name="formJus" method="post" style="margin: 0;" action="PTU-justificar_sql.cfm" >
		<!--- Variables Hidden --->
		<input type="hidden" name="RHPTUEMid" value="#Form.RHPTUEMid#">
		<input type="hidden" name="RHPTUEid" value="#Form.RHPTUEid#">
		
		<!--- Pintado de la Pantalla --->
		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="areaFiltro">
			<tr><td></td></tr>
			<tr>
				<td align="center">
					<table width="98%" cellpadding="0" cellspacing="0" border="0" >
						<tr>
							<td align="left" >
								<font size="2"><strong><cf_translate key="LB_Justificacion_de_linea_del_PTU">Justificaci&oacute;n de por que no reconoce a este empleado para el pago del PTU.</cf_translate></strong></font>
							</td>
						</tr>
						<tr>
							<td align="left" >
								<font size="1">&nbsp;&nbsp;<cf_translate key="LB_Digite_aqui_la_justificacion_de_linea_de_este_PTU">Digite aqu&iacute; la justificaci&oacute;n de  l&iacute;nea de este empleado para no ser tomado en cuenta en el pago del PTU.</cf_translate></font>
							</td>
						</tr>
						<tr><td>&nbsp;</td></tr>
						<tr><td>&nbsp;</td></tr>
						<tr>
							<td align="left" >
								<strong><font size="1"><cf_translate key="LB_justificacion">Justificaci&oacute;n</cf_translate></font></strong>
							</td>
						</tr>
						<tr>
							<td align="left" >
								<input type="text" name="RHPTUEMjustificacion" value="<cfif len(trim(rsJustificacion.RHPTUEMjustificacion))>#rsJustificacion.RHPTUEMjustificacion#</cfif>" size="108" maxlength="120">
							</td>
						</tr>
						<tr><td>&nbsp;</td></tr>
						<tr><td>&nbsp;</td></tr>
						<tr>
							<td align="center">
								<cfset etq = Iif(rsJustificacion.RHPTUEMreconocido EQ 0, DE("#BTN_RECONOCER#"), DE("#BTN_NO_RECONOCER#"))>
								<input type="submit" name="Aceptar" value="#etq#">
							</td>
						</tr>
						<tr><td>&nbsp;</td></tr>
					</table>
				</td>
			</tr>
		</table>
	</form>
	</cfoutput>
</body>
</html>
