<cfset LvarTipoDocumento = 6>
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cfparam name="form.GECid" default="">
<cfif isdefined('form.GECid') and len(trim(form.GECid))>
<cfelse>
	<cf_errorCode	code = "50724" msg = "No se puede incluir una Comision Manualmente">
</cfif>

<cfquery datasource="#session.dsn#" name="rsForm">
	select
			a.GECid,
			a.Ecodigo,
			a.CFid,
			a.GECnumero,
			a.GECestado,
			a.GECdescripcion,
			a.GECfechaSolicitud,
			a.UsucodigoSolicitud,
			a.GECdesde, GEChoraini,
			a.GEChasta, GEChorafin,
			a.GECautomovil, a.GEChotel, a.GECavion,

			a.TESBid,
			a.TESid,
			a.ts_rversion,
			b.CFdescripcion,
			b.CFcodigo
	from GEcomision a
	  inner join CFuncional b
		on a.CFid=b.CFid
	where a.Ecodigo	 = #session.Ecodigo#
	  and a.GECid	 = #form.GECid#
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
<table align="center" summary="Tabla de entrada" border="0">
	<tr>
		<td valign="top" align="right"><strong>Núm. Comisión:&nbsp;</strong></td>
		<td valign="top"><strong>#LSNumberFormat(rsForm.GECnumero)#</strong></td>
		<td valign="top" align="right"><strong>Fecha Solicitud:&nbsp;</strong></td>
		<td valign="top"><strong>#LSDateFormat(rsForm.GECfechaSolicitud,"DD/MM/YYYY")#</strong></td>
		<td valign="top" align="right" nowrap>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<strong>Descripción:</strong></td>
		<td valign="top" style="width:250px"><strong>#trim(rsForm.GECdescripcion)#</strong></td>
	</tr>
	<tr>
		<td valign="top" align="right"><strong>Centro&nbsp;Funcional:&nbsp;</strong></td>
		<td valign="top" colspan="3"><strong>#rsForm.CFcodigo# - #rsForm.CFdescripcion#</strong></td>
		<td valign="top" align="right" nowrap>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<strong>Desde:</strong></td>
		<td valign="top">
			<strong>
			#dateFormat(rsForm.GECdesde,"DD/MM/YYYY")#&nbsp;#timeFormat(rsForm.GEChoraini,"HH:MM:SS")#
			&nbsp;&nbsp;&nbsp;Hasta:&nbsp;
			#dateFormat(rsForm.GEChasta,"DD/MM/YYYY")#&nbsp;#timeFormat(rsForm.GEChorafin,"HH:MM:SS")#
			</strong>
		</td>
	</tr>									
	<tr>
		<td valign="top" nowrap align="right"><strong>Empleado:&nbsp;</strong></td>
		<td valign="top" colspan="3"><strong>#rsEmpleado.DEidentificacion# -#rsEmpleado.NombreEmp1#</strong></td>
		<td valign="top" align="right" nowrap><strong>Incluye:&nbsp;</strong></td>
		<td valign="top">
			<cfif rsForm.GECautomovil EQ "1">&nbsp;&nbsp;&nbsp;<strong>Automóvil</strong></cfif>
			<cfif rsForm.GEChotel EQ "1">&nbsp;&nbsp;&nbsp;<strong>Hotel</strong></cfif>
			<cfif rsForm.GECavion EQ "1">&nbsp;&nbsp;&nbsp;<strong>Avión</strong></cfif>
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
	  and a.GECid	 = #form.GECid#
	  and a.GEAestado = 1
</cfquery>
<cf_web_portlet_start border="true" titulo="Anticipos a Aprobar<BR>(cada Anticipo se debe aprobar independientemente)" skin="#Session.Preferences.Skin#" width="80%">
<cfif NOT isdefined('form.GEAid')>
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
</cfif>

<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
	query="#rsListaAnticipos#"
	desplegar	= "GEAnumero, GEAdescripcion, Miso4217, GEAtotalOri"
	etiquetas	= "Anticipo, Descripcion, Moneda, Total"
	formatos	= "S,S,S,M"
	align		= "left,left,right,right"
	showEmptyListMsg="yes"
	ira="AprobarTrans.cfm"
	maxRows="10"
	width="100%"
/>
<cf_web_portlet_end>
<cfinclude template="AprobarTrans_formAnt.cfm">
