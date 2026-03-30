<cfset params="">
<cfif isdefined("Form.PageNum") and len(trim(Form.PageNum)) gt 0 and Form.PageNum gt 0>
	<cfset Form.Pagina = Form.PageNum>
</cfif>
<cfparam name="Form.Pagina" default="1">					
<cfparam name="Form.Filtro_AFTFcodigo_dispositivo" default="">
<cfparam name="Form.Filtro_AFTFnombre_dispositivo" default="">
<cfparam name="Form.Filtro_AFTFestatus_dispositivo" default="-1">
<cfparam name="Form.MaxRows" default="15">
<cfif isdefined("Form.Alta")>
	<cfif isdefined("Form.AFTFestatus_dispositivo")><cfset Form.AFTFestatus_dispositivo = 1></cfif>
	<cfparam name="Form.AFTFestatus_dispositivo" default="0">
    <cfinvoke component="sif.af.tomaFisica.componentes.aftfDispositivosMoviles" method="insertDispositivo" 
		returnvariable="resAFTFid_dispositivo" 
		AFTFcodigo_dispositivo="#Form.AFTFcodigo_dispositivo#"
		AFTFnombre_dispositivo="#Form.AFTFnombre_dispositivo#" 
		AFTFserie_dispositivo="#Form.AFTFserie_dispositivo#" 
		AFTFestatus_dispositivo="#Form.AFTFestatus_dispositivo#"/>
	<cfquery name="rs" datasource="#Session.DSN#">
		select count(1) as cantRegistros
		from AFTFDispositivo
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
	</cfquery>
	<cfset Form.Pagina = Ceiling(rs.cantRegistros / Form.MaxRows)>
	<cfset X = "AFTFid_dispositivo="&resAFTFid_dispositivo>
	<cfset params=ListAppend(params,X,"&")>
<cfelseif isdefined("Form.Cambio")>
	<cf_dbtimestamp 
		table="AFTFDispositivo"
		redirect="aftfDispositivosMoviles.cfm"
		timestamp="#form.ts_rversion#"				
		field1="AFTFid_dispositivo,numeric,#Form.AFTFid_dispositivo#">
	<cfif isdefined("Form.AFTFestatus_dispositivo")><cfset Form.AFTFestatus_dispositivo = 1></cfif>
	<cfparam name="Form.AFTFestatus_dispositivo" default="0">
    <cfinvoke component="sif.af.tomaFisica.componentes.aftfDispositivosMoviles" method="updateDispositivoById" 
		returnvariable="resAFTFid_dispositivo" 
		AFTFid_dispositivo="#Form.AFTFid_dispositivo#"
		AFTFcodigo_dispositivo="#Form.AFTFcodigo_dispositivo#"
		AFTFnombre_dispositivo="#Form.AFTFnombre_dispositivo#" 
		AFTFserie_dispositivo="#Form.AFTFserie_dispositivo#" 
		AFTFestatus_dispositivo="#Form.AFTFestatus_dispositivo#"/>    
	<cfset params=ListAppend(params,"AFTFid_dispositivo="&Form.AFTFid_dispositivo,"&")>
<cfelseif isdefined("Form.Baja")>
    <cfinvoke component="sif.af.tomaFisica.componentes.aftfDispositivosMoviles" method="deleteDispositivoById" 
		returnvariable="resAFTFid_dispositivo" 
		AFTFid_dispositivo="#Form.AFTFid_dispositivo#"/>
<cfelseif isdefined("Form.BtnActivar") and isdefined("Form.Chk")>
    <cfinvoke component="sif.af.tomaFisica.componentes.aftfDispositivosMoviles" method="updateDispositivoById" 
		returnvariable="resAFTFid_dispositivo" 
		AFTFid_dispositivo="#Form.Chk#"
		AFTFestatus_dispositivo="1"/>
<cfelseif isdefined("Form.BtnInactivar") and isdefined("Form.Chk")>
    <cfinvoke component="sif.af.tomaFisica.componentes.aftfDispositivosMoviles" method="updateDispositivoById" 
		returnvariable="resAFTFid_dispositivo" 
		AFTFid_dispositivo="#Form.Chk#"
		AFTFestatus_dispositivo="0"/>
<cfelseif isdefined("Form.BtnEliminar") and isdefined("Form.Chk")>
    <cfinvoke component="sif.af.tomaFisica.componentes.aftfDispositivosMoviles" method="deleteDispositivoById" 
		returnvariable="resAFTFid_dispositivo" 
		AFTFid_dispositivo="#Form.Chk#"/>
</cfif>

<cfset fixedparams="">
<cfset fixedparams=ListAppend(fixedparams,"Pagina="&Form.Pagina,"&")>
<cfset fixedparams=ListAppend(fixedparams,"Filtro_AFTFcodigo_dispositivo="&Form.Filtro_AFTFcodigo_dispositivo,"&")>
<cfset fixedparams=ListAppend(fixedparams,"Filtro_AFTFnombre_dispositivo="&Form.Filtro_AFTFnombre_dispositivo,"&")>
<cfset fixedparams=ListAppend(fixedparams,"Filtro_AFTFestatus_dispositivo="&Form.Filtro_AFTFestatus_dispositivo,"&")>
<cfset fixedparams=ListAppend(fixedparams,"HFiltro_AFTFcodigo_dispositivo="&Form.Filtro_AFTFcodigo_dispositivo,"&")>
<cfset fixedparams=ListAppend(fixedparams,"HFiltro_AFTFnombre_dispositivo="&Form.Filtro_AFTFnombre_dispositivo,"&")>
<cfset fixedparams=ListAppend(fixedparams,"HFiltro_AFTFestatus_dispositivo="&Form.Filtro_AFTFestatus_dispositivo,"&")>
<cflocation url="aftfDispositivosMoviles.cfm?#fixedparams#&#params#">