<!--- Cierra este popup luego de hacer la actualización --->
<cfif isdefined("url.cerrar") and url.cerrar eq 1>
	<script language="javascript" type="text/javascript">
		window.close();
	</script>
	<cfabort>
</cfif>
<!--- Este fuente requiere saber que vista debe mostrar --->
<cfif isdefined("url.id_vistapopup") and len(url.id_vistapopup)><cfset form.id_vista = url.id_vistapopup></cfif>
<cfif isdefined("url.id_tipo") and len(url.id_tipo)><cfset form.id_tipo = url.id_tipo></cfif>
<cfif isdefined("url.id_persona") and len(url.id_persona)><cfset form.id_persona = url.id_persona></cfif>
<cfif isdefined("url.id_instancia") and len(url.id_instancia)>
	<cfset form.id_instancia = url.id_instancia>
<cfelse>
<!--- trae la instancia de tramite--->
<cfinvoke component="home.tramites.componentes.tramites"
	method="obtener_instancia"
	id_persona="#url.id_persona#"
	id_tramite="#url.id_tramite#"
	returnvariable="instancia" />
	<cfset form.id_instancia = instancia>
</cfif>
<cfif isdefined("url.id_requisito") and len(url.id_requisito)><cfset form.id_requisito = url.id_requisito></cfif>
<cfif isdefined("url.id_registro") and len(url.id_registro)>
	<cfset form.id_registro = url.id_registro>
<cfelse>
	<cftransaction>
	<cfquery name="InsertaRegistro" datasource="#session.tramites.dsn#">
		insert into DDRegistro(id_persona,id_tipo,BMfechamod,BMUsucodigo)
		values(
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_persona#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tipo#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
		)
		<cf_dbidentity1 datasource="#session.tramites.dsn#">
	</cfquery>
	<cf_dbidentity2 datasource="#session.tramites.dsn#" name="InsertaRegistro">
	<cfquery name="InsertaCampos" datasource="#session.tramites.dsn#">
		insert into DDCampo(id_registro,id_campo,BMfechamod,BMUsucodigo)
		select #InsertaRegistro.identity#,id_campo,#Now()#,#session.Usucodigo#
		from DDVistaCampo
		where id_vista = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_vista#">
	</cfquery>
	<cfquery name="UpdateTPInstancia" datasource="#session.tramites.dsn#">
		update TPInstanciaRequisito
		set id_registro = <cfqueryparam cfsqltype="cf_sql_numeric" value="#InsertaRegistro.identity#">
		where id_instancia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_instancia#">
		  and id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_requisito#">
	</cfquery>
	</cftransaction>
	<cfset form.id_registro = InsertaRegistro.identity>
</cfif>
<!--- Inserta el id_registro cuando no viene definido --->

<cfif isdefined("url.btnNuevo") and len(url.btnNuevo)><cfset form.btnNuevo = url.btnNuevo></cfif>
<cfif isdefined("form.id_vista") and isdefined("form.id_tipo") and isdefined("form.id_persona")
		and len(trim(form.id_vista)) and len(trim(form.id_tipo)) and len(trim(form.id_persona))
		and ((isdefined("form.id_registro") and len(trim(form.id_registro))) or isdefined("form.btnNuevo"))>
	<cfset rsVista ="rsVista_#form.id_vista#_#form.id_tipo#_#form.id_persona#">
	<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
	<!--- 	LECTURA DE LA VISTA  --->
	<cfinvoke component="home.tramites.componentes.vistas" method="getVista" id_vista="#form.id_vista#" id_tipo="#form.id_tipo#" returnvariable="rsVista">
	<cfset rsVista_titulo_vista = rsVista.titulo_vista>
<cfelse>
	<cfthrow message="Error, La Ventana de Registro Individual de Documentos requiere mas parámetros. Proceso Cancelado!">
</cfif>
<cf_web_portlet_start titulo='#rsVista_titulo_vista#'>
	<cfset ventana_popup = "1">
	<body style="margin:0 ">
	<cfinclude template="vistasind-form.cfm">
	</body>
<cf_web_portlet_end>