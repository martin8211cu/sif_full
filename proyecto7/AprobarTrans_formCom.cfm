<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<link href="css/MenuModulos.css" rel="stylesheet" type="text/css">
<cfinclude template="detectmobilebrowser.cfm">
<cfif ismobile EQ true>
	<div align="center" class="containerlightboxMobile">
<cfelse>
	<div align="center" class="containerlightbox">
</cfif>
<cfset LvarTipoDocumento = 6>
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cfparam name="url.GECid_comision" default="">
<cfif isdefined('url.GECid_comision') and len(trim(url.GECid_comision))>
<cfset form.GECid_comision = url.GECid_comision>
	<cfset form.idTransaccion=url.GECid_comision>
	<cfset form.CCHTrelacionada=url.GECid_comision>
<cfelse>
	<cf_errorCode	code = "50724" msg = "No se puede incluir una Comision Manualmente">
</cfif>

<cfquery datasource="#session.dsn#" name="rsForm">
	select
			a.GECid as GECid_comision,
			a.Ecodigo,
			a.CFid,
			a.GECnumero,
			a.GECestado,
			a.GECdescripcion,
			a.GECfechaSolicitud,
			a.UsucodigoSolicitud,
			a.GECdesde, GEChoraini,
			a.GEChasta, GEChorafin,
			a.GECtipo, a.GECautomovil, a.GEChotel, a.GECavion,

			a.TESBid,
			a.TESid,
			a.ts_rversion,
			b.CFdescripcion,
			b.CFcodigo
	from GEcomision a
	  inner join CFuncional b
		on a.CFid=b.CFid
	where a.Ecodigo	 = #session.Ecodigo#
	  and a.GECid	 = #form.GECid_comision#
</cfquery>

<cfquery name="rsEmpleado" datasource="#session.DSN#">
	select a.TESBid, 
	       a.DEid, 
		   b.DEidentificacion,
		   b.DEapellido1 #_Cat#' '#_Cat# b.DEapellido2#_Cat#', '#_Cat# b.DEnombre as NombreEmp1
	from TESbeneficiario  a
		inner join DatosEmpleado b
			on a.DEid = b.DEid
	where a.TESBid    = #rsForm.TESBid#
</cfquery>

<cfquery name="rsEmpresa" datasource="#session.dsn#">
	select Edescripcion
	from Empresas
	where Ecodigo = #session.Ecodigo#
</cfquery>
	
<cfoutput>
<!---<div style="width:600px;height:97%;overflow:auto;" >--->
<table align="center"summary="Tabla de entrada" border="0" >
	<tr>
		<td valign="top" align="right"><strong>Núm. Comisión:&nbsp;</strong></td>
		<td valign="top"><strong>#LSNumberFormat(rsForm.GECnumero)#</strong></td>
		<td valign="top" align="right"><strong>Fecha Solicitud:&nbsp;</strong></td>
		<td valign="top">#LSDateFormat(rsForm.GECfechaSolicitud,"DD/MM/YYYY")#</td>
		<td valign="top" align="right" nowrap>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<strong>Descripción:&nbsp;</strong></td>
		<td valign="top" style="width:200px">#trim(rsForm.GECdescripcion)#</td>
	</tr>
	<tr>
		<td valign="top" align="right"><strong>Centro&nbsp;Funcional:&nbsp;</strong></td>
		<td valign="top" colspan="3"><strong>#rsForm.CFcodigo# - #rsForm.CFdescripcion#</strong></td>
		<td valign="top" colspan="2"><strong>Desde:</strong>
			#dateFormat(rsForm.GECdesde,"DD/MM/YYYY")#&nbsp;#numberFormat(rsForm.GEChoraini/60,"00.00")#
			&nbsp;&nbsp;&nbsp;<strong>Hasta:</strong>&nbsp;
			#dateFormat(rsForm.GEChasta,"DD/MM/YYYY")#&nbsp;#numberFormat(rsForm.GEChorafin/60,"00.00")#
		</td>
	</tr>									
	<tr>
		<td valign="top" nowrap align="right"><strong>Empleado:&nbsp;</strong></td>
		<td valign="top" colspan="3"><strong>#rsEmpleado.DEidentificacion# -#rsEmpleado.NombreEmp1#</strong></td>
		<td valign="top" align="right" nowrap><strong>Tipo:&nbsp;</strong></td>
		<td valign="top">
			<cfif rsForm.GECtipo eq 1>Exterior<cfelse>Nacional</cfif>
			&nbsp;&nbsp;&nbsp;<strong>Incluye:</strong>
			<cfif rsForm.GECautomovil EQ "1">&nbsp;&nbsp;Automóvil</cfif>
			<cfif rsForm.GEChotel EQ "1">&nbsp;&nbsp;Hotel</cfif>
			<cfif rsForm.GECavion EQ "1">&nbsp;&nbsp;Avión</cfif>
		</td>
	</tr>						
</table>
</cfoutput>
<cf_dbfunction name="to_char" args="a.GEAnumero" returnvariable="LvarNumero">
<cf_dbfunction name="to_char_currency" args="a.GEAtotalOri" returnvariable="LvarMonto">
<cfquery datasource="#session.dsn#" name="rsListaAnticipos">
	select
			#form.CCHTRELACIONADA# as CCHTRELACIONADA,
			#form.idTransaccion# as idTransaccion,
			a.GEAid,
			0 as GEADid,
			a.GEAdescripcion,
			<cf_dbfunction name="concat" args="'Anticipo ';#LvarNumero#;': ';m.Miso4217;' ';#LvarMonto#" delimiters=";"> as Anticipo,
			a.CFid,
			a.GEAnumero,
			m.Miso4217,
			GEAtotalOri,
			'COMISION' as tipo
	from GEanticipo a
	  inner join Monedas m
		on a.Mcodigo=m.Mcodigo
	where a.Ecodigo	 = #session.Ecodigo#
	  and a.GECid	 = #form.GECid_comision#
	  and a.GEAestado = 1
</cfquery>
<cfif rsListaAnticipos.recordcount gt 1>
	<cfset devolver = true>
<cfelse>
	<cfset devolver = false>
</cfif>
<!---<cf_web_portlet_start border="true" titulo="Anticipos a Aprobar<BR>(cada Anticipo se debe aprobar independientemente)" skin="#Session.Preferences.Skin#" width="80%">
---><!---<cfif NOT isdefined('form.GEAid')>--->
	<cfset form.GEAid			= rsListaAnticipos.GEAid>
	<cfset form.GEAnumero		= rsListaAnticipos.GEAnumero>
	<cfset form.CCHTrelacionada	= rsListaAnticipos.CCHTrelacionada>
	<cfset form.idTransaccion	= rsListaAnticipos.idTransaccion>
	<cfset form.GEADid			= rsListaAnticipos.GEADid>
	<cfset form.GEAdescripcion	= rsListaAnticipos.GEAdescripcion>
	<cfset form.Anticipo		= rsListaAnticipos.Anticipo>
	<cfset form.CFid			= rsListaAnticipos.CFid>
	<cfset form.Miso4217		= rsListaAnticipos.Miso4217>
	<cfset form.GEAtotalOri		= rsListaAnticipos.GEAtotalOri>
	<cfset form.tipo			= rsListaAnticipos.tipo>
    
	<cfset url.GEAid = form.GEAid>
	<cfset url.GEAnumero		= form.GEAnumero>
	<cfset url.CCHTrelacionada	= form.CCHTrelacionada>
	<cfset url.idTransaccion	= form.idTransaccion>
	<cfset url.GEADid			= form.GEADid>
	<cfset url.GEAdescripcion	= form.GEAdescripcion>
	<cfset url.Anticipo		= form.Anticipo>
	<cfset url.CFid			= form.CFid>
	<cfset url.Miso4217		= form.Miso4217>
	<cfset url.GEAtotalOri		= form.GEAtotalOri>
	<cfset url.tipo			= form.tipo>

<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
	query="#rsListaAnticipos#"
	desplegar	= "GEAnumero, GEAdescripcion, Miso4217, GEAtotalOri"
	etiquetas	= "Anticipo, Descripcion, Moneda, Total"
	formatos	= "S,S,S,M"
	align		= "left,left,right,right"
	showEmptyListMsg="yes"
	ira=""
	maxRows="10"
	width="100%"
/>
<cfinclude template="AprobarTrans_formAnt.cfm">
