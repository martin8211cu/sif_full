<!--- Variables por URL --->
<cfif isdefined("url.RHEAMid") and len(trim(url.RHEAMid))>
	<cfset form.RHEAMid = url.RHEAMid>
</cfif>
<cfif isdefined("url.RHAid") and len(trim(url.RHAid))>
	<cfset form.RHAid = url.RHAid>
</cfif>

<!--- Consulta del campo RHEAMjustificacion --->
<cfquery name="rsJustificacion" datasource="#Session.DSN#">
	select rtrim(RHEAMjustificacion) as RHEAMjustificacion, RHEAMreconocido
	from RHEmpleadosAccionMasiva
	where RHEAMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEAMid#">
		and RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHAid#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<!---=================== TRADUCCION =======================---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Justificacion_de_la_Accion_Masiva_de_Personal"
	Default="Justificaci&oacute;n de la Acci&oacute;n Masiva de Personal"	
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
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<cf_templatecss>
</head>

<body>
	<cfoutput>
	<form name="form1" method="post" style="margin: 0;" action="accionesMasiva-justificar_sql.cfm" >
		<!--- Variables Hidden --->
		<input type="hidden" name="RHEAMid" value="#Form.RHEAMid#">
		<input type="hidden" name="RHAid" value="#Form.RHAid#">
		
		<!--- Pintado de la Pantalla --->
		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="areaFiltro">
			<tr><td></td></tr>
			<tr>
				<td align="center">
					<table width="98%" cellpadding="0" cellspacing="0" border="0" >
						<tr>
							<td align="left" >
								<font size="2"><strong><cf_translate key="LB_Justificacion_de_linea_de_la_accion_masiva">Justificaci&oacute;n de l&iacute;nea de la Acci&oacute;n Masiva.</cf_translate></strong></font>
							</td>
						</tr>
						<tr>
							<td align="left" >
								<font size="1">&nbsp;&nbsp;<cf_translate key="LB_Digite_aqui_la_justificacion_de_linea_de_esta_accion_masiva_de_personal">Digite aqu&iacute; la justificaci&oacute;n de  l&iacute;nea de esta Acci&oacute;n Masiva de Personal.</cf_translate></font>
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
								<input type="text" name="RHEAMjustificacion" value="<cfif len(trim(rsJustificacion.RHEAMjustificacion))>#rsJustificacion.RHEAMjustificacion#</cfif>" size="108" maxlength="120">
							</td>
						</tr>
						<tr><td>&nbsp;</td></tr>
						<tr><td>&nbsp;</td></tr>
						<tr>
							<td align="center">
								<cfset etq = Iif(rsJustificacion.RHEAMreconocido EQ 0, DE("#BTN_RECONOCER#"), DE("#BTN_NO_RECONOCER#"))>
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
