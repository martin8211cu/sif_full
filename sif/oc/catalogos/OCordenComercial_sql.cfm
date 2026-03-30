
<cfif IsDefined("form.Cambio")>
	<cfquery datasource="#session.dsn#">
		update OCordenComercial
		set Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		, OCfecha = <cfif isdefined("form.OCfecha") and Len(Trim(form.OCfecha))><cfqueryparam cfsqltype="cf_sql_date" value="#form.OCfecha#"><cfelse>null</cfif>
		, SNid = <cfif isdefined("form.OCtipoIC") and form.OCtipoIC eq 'C'><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNid#"><cfelse>null</cfif>
		, Mcodigo = <cfif isdefined("form.Mcodigo") and Len(Trim(form.Mcodigo))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#"><cfelse>null</cfif>
		, OCmodulo = <cfif isdefined("form.OCmodulo") and Len(Trim(form.OCmodulo))><cfqueryparam cfsqltype="cf_sql_char" value="#form.OCmodulo#"><cfelse>null</cfif>
		, OCincoterm = <cfif isdefined("form.OCincoterm") and Len(Trim(form.OCincoterm))><cfqueryparam cfsqltype="cf_sql_char" value="#form.OCincoterm#"><cfelse>null</cfif>
		, OCtrade_num = <cfif isdefined("form.OCtrade_num") and Len(Trim(form.OCtrade_num))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCtrade_num#"><cfelse>null</cfif>
		, OCorder_num = <cfif isdefined("form.OCorder_num") and Len(Trim(form.OCorder_num))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCorder_num#"><cfelse>null</cfif>
		, OCVid 	  = <cfif isdefined("form.OCtipoOD") and form.OCtipoOD eq 'D'><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCVid#"><cfelse>null</cfif>
		, OCfechaAllocationDefault = <cfif isdefined("form.OCfechaAllocationDefault") and Len(Trim(form.OCfechaAllocationDefault))><cfqueryparam cfsqltype="cf_sql_date" value="#form.OCfechaAllocationDefault#"><cfelse>null</cfif>
		, OCfechaPropiedadDefault = <cfif isdefined("form.OCfechaPropiedadDefault") and Len(Trim(form.OCfechaPropiedadDefault))><cfqueryparam cfsqltype="cf_sql_date" value="#form.OCfechaPropiedadDefault#"><cfelse>null</cfif>
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		where OCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCid#" null="#Len(form.OCid) Is 0#">
	</cfquery>
	<cflocation url="OCordenComercial.cfm?OCid=#URLEncodedFormat(form.OCid)#">
<cfelseif IsDefined("form.Baja")>
	<cftransaction>
		<cfquery datasource="#session.dsn#">
			delete OCordenProducto
			 where OCid    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCid#">
			 and   Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
		</cfquery>
		<cfquery datasource="#session.dsn#">
			delete OCordenComercial
			where OCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCid#">
		</cfquery>
	</cftransaction>
	<cflocation url="OCordenComercial.cfm?btnNuevo=btnNuevo">
<cfelseif IsDefined("form.Alta")>	
	<cftransaction>
	<cfquery name="RSInsert" datasource="#session.DSN#">
		insert into OCordenComercial (
			Ecodigo,
			OCtipoOD,
			OCtipoIC,
			OCcontrato,
			OCfecha,
			SNid,
			Mcodigo,
			OCestado,
			OCmodulo,
			OCincoterm,
			OCtrade_num,
			OCorder_num,
			OCVid,
			OCfechaAllocationDefault,
			OCfechaPropiedadDefault,
			BMUsucodigo)
		values (
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#form.OCtipoOD#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#form.OCtipoIC#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#form.OCcontrato#">,
			<cfif isdefined("form.OCfecha") and Len(Trim(form.OCfecha))><cfqueryparam cfsqltype="cf_sql_date" value="#form.OCfecha#"><cfelse>null</cfif>,
			<cfif isdefined("form.OCtipoIC") and form.OCtipoIC eq 'C'><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNid#"><cfelse>null</cfif>,
			<cfif isdefined("form.Mcodigo") and Len(Trim(form.Mcodigo))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#"><cfelse>null</cfif>,
			'A',
			<cfif isdefined("form.OCmodulo") and Len(Trim(form.OCmodulo))><cfqueryparam cfsqltype="cf_sql_char" value="#form.OCmodulo#"><cfelse>null</cfif>,
			<cfif isdefined("form.OCincoterm") and Len(Trim(form.OCincoterm))><cfqueryparam cfsqltype="cf_sql_char" value="#form.OCincoterm#"><cfelse>null</cfif>,
			<cfif isdefined("form.OCtrade_num") and Len(Trim(form.OCtrade_num))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCtrade_num#"><cfelse>null</cfif>,
			<cfif isdefined("form.OCorder_num") and Len(Trim(form.OCorder_num))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCorder_num#"><cfelse>null</cfif>,
			<cfif isdefined("form.OCtipoOD") and form.OCtipoOD eq 'D'><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCVid#"><cfelse>null</cfif>,
			<cfif isdefined("form.OCfechaAllocationDefault") and Len(Trim(form.OCfechaAllocationDefault))><cfqueryparam cfsqltype="cf_sql_date" value="#form.OCfechaAllocationDefault#"><cfelse>null</cfif>,
			<cfif isdefined("form.OCfechaPropiedadDefault") and Len(Trim(form.OCfechaPropiedadDefault))><cfqueryparam cfsqltype="cf_sql_date" value="#form.OCfechaPropiedadDefault#"><cfelse>null</cfif>,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
			<cf_dbidentity1 datasource="#session.DSN#">
		</cfquery>
		<cf_dbidentity2 datasource="#session.DSN#" name="RSInsert">
		<cfset form.OCid = RSInsert.identity >
	</cftransaction>
	<cflocation url="OCordenComercial.cfm?OCid=#URLEncodedFormat(form.OCid)#">
<cfelseif IsDefined("form.Nuevo")>
	<cflocation url="OCordenComercial.cfm?btnNuevo=btnNuevo">
<cfelse>
	<!--- Tratar como form.nuevo --->
	<cflocation url="OCordenComercial.cfm">
</cfif>



