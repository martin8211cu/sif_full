<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_AnticiposAprobar" default ="Anticipos a Aprobar<BR>(cada Anticipo se debe aprobar independientemente)" returnvariable="LB_AnticiposAprobar" xmlfile = "AprobarTrans_formCom.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Anticipo" default ="Anticipos a Aprobar<BR>(cada Anticipo se debe aprobar independientemente)" returnvariable="LB_Anticipo" xmlfile = "AprobarTrans_formCom.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Moneda" default ="Moneda" returnvariable="LB_Moneda" xmlfile = "AprobarTrans_formCom.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Total" default ="Total" returnvariable="LB_Total" xmlfile = "AprobarTrans_formCom.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Descripcion" default ="Descripci&oacute;n" returnvariable="LB_Descripcion" xmlfile = "AprobarTrans_formCom.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_NoSePuedeIncluirUnaComisionManualmente" default ="No se puede incluir una Comision Manualmente" returnvariable="MSG_NoSePuedeIncluirUnaComisionManualmente" xmlfile = "AprobarTrans_formCom.xml">
        
<cfset LvarTipoDocumento = 6>
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cfparam name="form.GECid_comision" default="">
<cfif isdefined('form.GECid_comision') and len(trim(form.GECid_comision))>
<cfelse>
	<cf_errorCode	code = "50724" msg = "#MSG_NoSePuedeIncluirUnaComisionManualmente#">
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
<table align="center" summary="Tabla de entrada" border="0">
	<tr>
		<td valign="top" align="right"><strong><cf_translate key = LB_NumComision xmlfile = "AprobarTrans_formCom.xml">Núm. Comisión</cf_translate>:&nbsp;</strong></td>
		<td valign="top"><strong>#LSNumberFormat(rsForm.GECnumero)#</strong></td>
		<td valign="top" align="right"><strong><cf_translate key = LB_FechaSolicitud xmlfile = "AprobarTrans_formCom.xml">Fecha Solicitud</cf_translate>:&nbsp;</strong></td>
		<td valign="top">#LSDateFormat(rsForm.GECfechaSolicitud,"DD/MM/YYYY")#</td>
		<td valign="top" align="right" nowrap>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<strong><cf_translate key = LB_Descripcion xmlfile = "AprobarTrans_formCom.xml">Descripción</cf_translate>:&nbsp;</strong></td>
		<td valign="top" style="width:300px">#trim(rsForm.GECdescripcion)#</td>
	</tr>
	<tr>
		<td valign="top" align="right"><strong><cf_translate key = LB_CentroFuncional xmlfile = "AprobarTrans_formCom.xml">Centro&nbsp;Funcional</cf_translate>:&nbsp;</strong></td>
		<td valign="top" colspan="3"><strong>#rsForm.CFcodigo# - #rsForm.CFdescripcion#</strong></td>
		<td valign="top" align="right" nowrap>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<strong><cf_translate key = LB_Desde xmlfile = "AprobarTrans_formCom.xml">Desde</cf_translate>:</strong></td>
		<td valign="top">
			#dateFormat(rsForm.GECdesde,"DD/MM/YYYY")#&nbsp;#numberFormat(rsForm.GEChoraini/60,"00.00")#
			&nbsp;&nbsp;&nbsp;<strong><cf_translate key = LB_Hasta xmlfile = "AprobarTrans_formCom.xml">Hasta</cf_translate>:</strong>&nbsp;
			#dateFormat(rsForm.GEChasta,"DD/MM/YYYY")#&nbsp;#numberFormat(rsForm.GEChorafin/60,"00.00")#
		</td>
	</tr>									
	<tr>
		<td valign="top" nowrap align="right"><strong><cf_translate key = LB_Empleado xmlfile = "AprobarTrans_formCom.xml">Empleado</cf_translate>:&nbsp;</strong></td>
		<td valign="top" colspan="3"><strong>#rsEmpleado.DEidentificacion# -#rsEmpleado.NombreEmp1#</strong></td>
		<td valign="top" align="right" nowrap><strong><cf_translate key = LB_Tipo xmlfile = "AprobarTrans_formCom.xml">Tipo</cf_translate>:&nbsp;</strong></td>
		<td valign="top">
			<cfif rsForm.GECtipo eq 1><cf_translate key = LB_Exterior xmlfile = "AprobarTrans_formCom.xml">Exterior</cf_translate><cfelse><cf_translate key = LB_Nacional xmlfile = "AprobarTrans_formCom.xml">Nacional</cf_translate></cfif>
			&nbsp;&nbsp;&nbsp;<strong><cf_translate key = LB_Incluye xmlfile = "AprobarTrans_formCom.xml">Incluye</cf_translate>:</strong>
			<cfif rsForm.GECautomovil EQ "1">&nbsp;&nbsp;<cf_translate key = LB_Automovil xmlfile = "AprobarTrans_formCom.xml">Automóvil</cf_translate></cfif>
			<cfif rsForm.GEChotel EQ "1">&nbsp;&nbsp;<cf_translate key = LB_Hotel xmlfile = "AprobarTrans_formCom.xml">Hotel</cf_translate></cfif>
			<cfif rsForm.GECavion EQ "1">&nbsp;&nbsp;<cf_translate key = LB_Avion xmlfile = "AprobarTrans_formCom.xml">Avión</cf_translate></cfif>
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
<cf_web_portlet_start border="true" titulo="#LB_AnticiposAprobar#" skin="#Session.Preferences.Skin#" width="80%">
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
	etiquetas	= "#LB_Anticipo#, #LB_Descripcion#, #LB_Moneda#, #LB_Total#"
	formatos	= "S,S,S,M"
	align		= "left,left,right,right"
	showEmptyListMsg="yes"
	ira="AprobarTrans.cfm"
	maxRows="10"
	width="100%"
/>
<cf_web_portlet_end>
<cfinclude template="AprobarTrans_formAnt.cfm">
