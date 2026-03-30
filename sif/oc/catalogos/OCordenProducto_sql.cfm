
<cfif IsDefined("form.Cambio")>
	<cfquery datasource="#session.dsn#">
		update OCordenProducto
		set OCPlinea = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.OCPlinea#">
		, Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">
		, Ucodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Ucodigo#">
		, OCPcantidad = <cfqueryparam cfsqltype="cf_sql_float" value="#replace(trim(form.OCPcantidad),',','','All')#">
		, OCPprecioUnitario = <cfqueryparam cfsqltype="cf_sql_money" value="#replace(trim(form.OCPprecioUnitario),',','','All')#">
		, OCPprecioTotal = <cfqueryparam cfsqltype="cf_sql_money" value="#replace(trim(form.OCPprecioTotal),',','','All')#">
		, OCitem_num = <cfif isdefined("form.OCitem_num") and Len(Trim(form.OCitem_num))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCitem_num#"><cfelse>null</cfif>
		, OCport_num = <cfif isdefined("form.OCport_num") and Len(Trim(form.OCport_num))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCport_num#"><cfelse>null</cfif>
		, CFformato = <cfif isdefined("form.CFformato") and Len(Trim(form.CFformato))><cfqueryparam cfsqltype="cf_sql_char" value="#form.CFformato#"><cfelse>null</cfif>
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		 where Aid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">
		 and   OCid    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCid#">
		 and   Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
	</cfquery>
	<cflocation url="OCordenComercial.cfm?Aid=#URLEncodedFormat(form.Aid)#&OCid=#URLEncodedFormat(form.OCid)#">
	

<cfelseif IsDefined("form.Baja")>

	<cfquery datasource="#session.dsn#">
		delete OCordenProducto
		 where Aid     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">
		 and   OCid    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCid#">
		 and   Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
	</cfquery>
	<cflocation url="OCordenComercial.cfm?OCid=#URLEncodedFormat(form.OCid)#">
<cfelseif IsDefined("form.Alta")>
<!--- <cfdump var="#form#"> --->
	<cfquery datasource="#session.dsn#">
		insert into OCordenProducto (
			OCid,
			OCPlinea,
			Aid,
			Ecodigo,
			Ucodigo,
			OCPcantidad,
			OCPprecioUnitario,
			OCPprecioTotal,
			OCitem_num,
			OCport_num,
			CFformato,
			BMUsucodigo)
		values (
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCid#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#form.OCPlinea#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#form.Ucodigo#">,
			<cfqueryparam cfsqltype="cf_sql_float" value="#replace(trim(form.OCPcantidad),',','','All')#">,
			<cfqueryparam cfsqltype="cf_sql_money" value="#replace(trim(form.OCPprecioUnitario),',','','All')#">,
			<cfqueryparam cfsqltype="cf_sql_money" value="#replace(trim(form.OCPprecioTotal),',','','All')#">,
			<cfif isdefined("form.OCitem_num") and Len(Trim(form.OCitem_num))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCitem_num#"><cfelse>null</cfif>,
			<cfif isdefined("form.OCport_num") and Len(Trim(form.OCport_num))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCport_num#"><cfelse>null</cfif>,
			<cfif isdefined("form.CFformato") and Len(Trim(form.CFformato))><cfqueryparam cfsqltype="cf_sql_char" value="#form.CFformato#"><cfelse>null</cfif>,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
	</cfquery>

	<cflocation url="OCordenComercial.cfm?OCid=#URLEncodedFormat(form.OCid)#">
<cfelseif IsDefined("form.Nuevo")>
	<cflocation url="OCordenComercial.cfm?OCid=#URLEncodedFormat(form.OCid)#">
<cfelse>
	<!--- Tratar como form.nuevo --->
	<cflocation url="OCordenComercial.cfm">
</cfif>



