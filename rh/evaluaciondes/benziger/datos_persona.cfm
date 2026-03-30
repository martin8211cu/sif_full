<!--- busca cuestionario para modificar --->
<cfif isdefined("url.Modificar") and isdefined("url.BUidentificacion")>
	<cfquery name="rsForm" datasource="sifcontrol" maxrows="1">
		select 	BUid, 
				BUnombre, 
				BUapellido1, 
				BUapellido2,
				BUfecha,
				BUcompanyname,
				BUbuAddress,
				BUbuphone,
				BUbuemail,
				BUphone,
				BUaddress,
				BUemail,
				BUidentificacion
		from BenzigerUsuario				
		where BUidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.BUidentificacion)#">
		order by BUfecha desc
	</cfquery>
</cfif>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Recursos Humanos - Test de Benziger</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="/cfmx/rh/css/soinasp01_azul.css" rel="stylesheet" type="text/css">

<!---<link href="/cfmx/asp/css/asp.css" type="text/css" rel="stylesheet">
<link href="/cfmx/plantillas/soinasp01/css/soinasp01_azul.css" rel="stylesheet" type="text/css">--->
<link href="/cfmx/asp/css/asp.css" type="text/css" rel="stylesheet">

<body>

	<form name="form1" method="post" action="datos_persona-sql.cfm" style="margin:0;" onSubmit="return validar();">

		<input type="hidden" name="PCcodigo" value="<cfoutput>#url.PCcodigo#</cfoutput>">
		<cfif isdefined("rsForm")>
			<input type="hidden" name="BUid" value="<cfoutput>#rsForm.BUid#</cfoutput>">
		</cfif>
		
		<cfif isdefined("url.Nuevo")>
			<input type="hidden" name="Nuevo" value="Nuevo">
		<cfelseif isdefined("url.Modificar")>
			<input type="hidden" name="Modificar" value="Modificar">
		</cfif>
		
		<cfinclude template="header.cfm">

	<br>

		<table width="100%" cellpadding="2" cellspacing="0">
		<tr><td align="center" class="tituloProceso">
			Cuestionario de Estilos de Pensamiento de Benziger
		</td></tr>
		</table>
		<br>

		<cfoutput>
		<table width="40%" align="center" border="0" cellpadding="3" cellspacing="0">
			<tr>
				<td colspan="3" bgcolor="##A0BAD3"><strong>Datos Generales:</strong></td>
			</tr>			
			<tr>
				<td><strong>Identificaci&oacute;n:</strong></td>
				<td><input name="BUidentificacion" type="text" size="20" maxlength="60" value="<cfif isdefined("rsForm")>#rsForm.BUidentificacion#<cfelseif isdefined("url.BUidentificacion")>#url.BUidentificacion#</cfif>"></td>
			</tr>
			<tr>
				<td><strong>Nombre:</strong></td>
				<td colspan="2"><input name="BUnombre" type="text" size="20" maxlength="60" value="<cfif isdefined("rsForm")>#rsForm.BUnombre#</cfif>"></td>
			</tr>
			<tr>
				<td><strong>Apellidos:</strong></td>
				<td><input name="BUapellido1" type="text" size="20" maxlength="60" value="<cfif isdefined("rsForm")>#rsForm.BUapellido1#</cfif>"></td>
				<td><input name="BUapellido2" type="text" size="20" maxlength="60" value="<cfif isdefined("rsForm")>#rsForm.BUapellido2#</cfif>"></td>				
			</tr>

			<tr>
				<td><strong>Fecha:</strong></td>
				<cfset vFecha = LSDateFormat(now(), 'dd/mm/yyyy') >
				<cfif isdefined("rsForm.BUfecha") and len(trim(rsForm.BUfecha))>
					<cfset vFecha = LSDateFormat(rsForm.BUfecha, 'dd/mm/yyyy')>
				</cfif>
				<td colspan="2"><cf_sifcalendario form="form1" name="BUfecha" value="#vFecha#"></td>
			</tr>
			
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td colspan="3" bgcolor="##A0BAD3"><strong>Informaci&oacute;n Comercial:</strong></td>
			</tr>			
			<tr>
				<td nowrap="nowrap"><strong>Nombre de la Compa&ntilde;&iacute;a:</strong></td>
				<td colspan="2"><input name="BUcompanyname" type="text" size="20" maxlength="60" value="<cfif isdefined("rsForm")>#rsForm.BUcompanyname#</cfif>" ></td>
			</tr>
			<tr>
				<td><strong>Direcci&oacute;n profesional:</strong></td>
				<td colspan="2"><input name="BUbuAddress" type="text" size="40" maxlength="255" value="<cfif isdefined("rsForm")>#rsForm.BUbuAddress#</cfif>"></td>
			</tr>
			<tr>
				<td><strong>Tel&eacute;fono profesional:</strong></td>
				<td colspan="2"><input name="BUbuphone" type="text" size="20" maxlength="60" value="<cfif isdefined("rsForm")>#rsForm.BUbuphone#</cfif>"></td>
			</tr>

			<tr>
				<td><strong>e-Mail Comercial:</strong></td>
				<td colspan="2"><input name="BUbuemail" type="text" size="20" maxlength="60" value="<cfif isdefined("rsForm")>#rsForm.BUbuemail#</cfif>"></td>
			</tr>

			<tr><td>&nbsp;</td></tr>
			<tr>
				<td colspan="3" bgcolor="##A0BAD3"><strong>Informaci&oacute;n Personal:</strong></td>
			</tr>			
			<tr>
				<td><strong>Domicilio particular:</strong></td>
				<td colspan="2"><input name="BUaddress" type="text" size="20" maxlength="60" value="<cfif isdefined("rsForm")>#rsForm.BUaddress#</cfif>"></td>
			</tr>
			<tr>
				<td><strong>Tel&eacute; particular:</strong></td>
				<td colspan="2"><input name="BUphone" type="text" size="20" maxlength="60" value="<cfif isdefined("rsForm")>#rsForm.BUphone#</cfif>"></td>
			</tr>
			<tr>
				<td><strong>e-Mail particular:</strong></td>
				<td colspan="2"><input name="BUemail" type="text" size="20" maxlength="60" value="<cfif isdefined("rsForm")>#rsForm.BUemail#</cfif>"></td>
			</tr>

			<tr><td>&nbsp;</td></tr>
			<tr><td colspan="3" align="center">
				<cfif isdefined("rsForm") >
					<cf_botones values="Modificar Cuestionario, Generar Archivo de Resultados" names="Cambio,Generar" exclude="Alta,Limpiar">
				<cfelse>
					<cf_botones>
				</cfif>	
			</td></tr>

		</table>
		</cfoutput>

	</form>
	
	<script type="text/javascript" language="javascript1.2">
		function validar(){
			var msg = '' ;
			if ( document.form1.BUidentificacion.value == '' ){
				msg += ' - El campo Identificación es requerido.\n';
			}
			
			if (document.form1.BUnombre.value == '' ){
				msg += ' - El campo Nombre es requerido.\n';
			}
			
			if (document.form1.BUapellido1.value == '' ){
				msg += ' - El campo Apellido 1 es requerido.\n';
			}

			if (document.form1.BUapellido2.value == '' ){
				msg += ' - El campo Apellido 2 es requerido.\n';
			}

			if (document.form1.BUfecha.value == '' ){
				msg += ' - El campo Fecha es requerido.\n';
			}
			
			if (msg != ''){
				alert('Se presentaron los siguientes errores:\n' + msg);
				return false
			}
			return true;
		}	
	</script>
	

</body>
</html>
