<!--- -------------------------------- --->
<!--- Nombre: Activos_frameActivo.cfm  --->
<!--- Hecho:  Randall Colomer Villalta --->
<!--- Fecha:  11/05/2005               --->
<!--- -------------------------------- --->

<!--- Parematros --->
<cfparam name="url.titulo" default="Activos Fijos">

<!--- Definición de variables del URL --->
<cfif isdefined("url.placa") and len(trim(url.placa))>
	<cfset form.placa = url.placa >
</cfif>
<cfif isdefined("url.aid") and len(trim(url.aid))>
	<cfset form.aid = url.aid >
</cfif>

<!--- Query's --->
<cfquery name="rsActivos" datasource="#Session.DSN#">
	select 	a.Aserie,
			a.AFMid,
			a.Adescripcion,
			b.AFMcodigo,
			b.AFMdescripcion,
			a.AFMMid,
			c.AFMMcodigo,
			c.AFMMdescripcion,
			d.AFCcodigo as AFCcodigopadre, 
			d.AFCcodigoclas as AFCcodigoclaspadre, 
			d.AFCdescripcion as Cdescpadre, 
			d.AFCnivel as Nnivel
	 
	from Activos a
		inner join AFMarcas b
			on a.AFMid = b.AFMid
			and a.Ecodigo = b.Ecodigo
		inner join AFMModelos c
			on a.AFMMid = c.AFMMid
			and a.Ecodigo = c.Ecodigo
		left outer join AFClasificaciones d
			on a.AFCcodigo = d.AFCcodigo 
			and a.Ecodigo = d.Ecodigo	
					
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.aid#">
</cfquery>

<cfif isdefined("form.Aceptar")>
	<cfquery name="rsUpdateActivos" datasource="#session.DSN#">
		update Activos 
		set Adescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Adescripcion#">, 
			Aserie = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Aserie#">, 
			AFMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFMid#">,
			AFMMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFMMid#">
			
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.aid#">
	</cfquery>
	
	<script language="javascript1.2" type="text/javascript">
		<cfoutput>
		window.opener.location.href = '/cfmx/sif/af/catalogos/Activos.cfm?Aid=#form.aid#';
		</cfoutput>
		window.close();
	</script>
		
</cfif>




<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Modificar Registro de <cfoutput>#url.titulo#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>

<script language="javascript1.2" src="/cfmx/sif/js/utilesMonto.js"></script>
<form name="form1" method="post" >
	<!--- Pintado de la pantalla --->
	<table width="100%" cellpadding="0" cellspacing="0" class="areaFiltro">
		<tr><td nowrap>&nbsp;</td></tr>
		<tr>
			<td align="center">
				<table width="98%" cellpadding="0" cellspacing="0" border="0" align="center" >
					<tr>
						<td align="left" colspan="2"><font size="2"><strong>Modificaci&oacute;n de un Registro de <cfoutput>#url.titulo#</cfoutput></strong></font></td>
					</tr>
					<tr>
						<td colspan="2"><font size="1">Se puede modificar la serie, marca, tipo y modelo de un registro de <cfoutput>#url.titulo#</cfoutput> seleccionado.</font></td>
					</tr>
					<tr><td colspan="2"><hr></td></tr>
					<tr><td colspan="2">&nbsp;</td></tr>
					<tr>
						<td nowrap align="right"><strong>Descripción:</strong>&nbsp;</td>
						<td nowrap align="left">
							<input type="text" name="Adescripcion" size="47" maxlength="100" value="<cfoutput>#rsActivos.Adescripcion#</cfoutput>" >
						</td>
					</tr>
					<tr>
						<td nowrap align="right"><strong>Serie:</strong>&nbsp;</td>
						<td nowrap align="left">
							<input type="text" name="Aserie" size="47" maxlength="50" value="<cfoutput>#rsActivos.Aserie#</cfoutput>" >
						</td>
					</tr>
					<tr>
						<td nowrap align="right"><strong>Marca:</strong>&nbsp;</td>
						<td nowrap rowspan="2" align="left">
							<cf_sifmarcamod query="#rsActivos#">
						</td>
					</tr>
					<tr>
						<td nowrap align="right"><strong>Modelo:</strong>&nbsp;</td>
					</tr>
					<!---
					<tr>
						<td nowrap align="right"><strong>Tipo:</strong>&nbsp;</td>
						<td nowrap align="left">
							<cf_siftipoactivo query="#rsActivos#" id="AFCcodigopadre" name="AFCcodigoclaspadre" desc="Cdescpadre">
						</td>
					</tr>
					--->
					<tr><td colspan="2">&nbsp;</td></tr>
					<tr>
						<td colspan="2" align="center">
							<input type="submit" style=" font-size:11px" name="Aceptar" value="Aceptar" >
							<input type="button" style=" font-size:11px" name="Cerrar" value="Cerrar" onClick="javascript:window.close();">
						</td>
					</tr>
					<tr><td colspan="2">&nbsp;</td></tr>
				</table>
			</td>
		</tr>
	</table>
</form>
</body>
</html>
