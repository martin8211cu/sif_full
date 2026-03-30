

<cfif IsDefined("form.Cambio")>
	
		<cf_dbtimestamp datasource="asp"
				table="SPortlet"
				redirect="metadata.code.cfm"
				timestamp="#form.ts_rversion#"
			
				field1="id_portlet"
				type1="numeric"
				value1="#form.id_portlet#"
			
		>
	
	<cfquery datasource="asp">
		update SPortlet
		set nombre_portlet = <cfqueryparam cfsqltype="cf_sql_char" value="#form.nombre_portlet#" null="#Len(form.nombre_portlet) Is 0#">
		, url_portlet = <cfqueryparam cfsqltype="cf_sql_char" value="#form.url_portlet#" null="#Len(form.url_portlet) Is 0#">
		, w_portlet = <cfqueryparam cfsqltype="cf_sql_char" value="#form.w_portlet#" null="#Len(form.w_portlet) Is 0#">
		, h_portlet = <cfqueryparam cfsqltype="cf_sql_char" value="#form.h_portlet#" null="#Len(form.h_portlet) Is 0#">
		, BMfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		where id_portlet = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_portlet#" null="#Len(form.id_portlet) Is 0#">
	</cfquery>

	<cflocation url="SPortlet.cfm?id_portlet=#URLEncodedFormat(form.id_portlet)#">

<cfelseif IsDefined("form.Baja")>
	<cfquery datasource="asp">
		delete from SPortlet
		where id_portlet = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_portlet#" null="#Len(form.id_portlet) Is 0#">
	</cfquery>
<cfelseif IsDefined("form.Nuevo")>
<cfelseif IsDefined("form.Alta")>
	<cfquery datasource="asp">
		insert into SPortlet (
			nombre_portlet,
			url_portlet,
			w_portlet,
			h_portlet,
			BMfecha,
			BMUsucodigo)
		values (
			<cfqueryparam cfsqltype="cf_sql_char" value="#form.nombre_portlet#" null="#Len(form.nombre_portlet) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#form.url_portlet#" null="#Len(form.url_portlet) Is 0#">,

			<cfqueryparam cfsqltype="cf_sql_char" value="#form.w_portlet#" null="#Len(form.w_portlet) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#form.h_portlet#" null="#Len(form.h_portlet) Is 0#">,

			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
	</cfquery>
<cfelse>
	<!--- Tratar como form.nuevo --->
</cfif>

<cflocation url="SPortlet.cfm">


