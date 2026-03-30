<cfif isdefined('form.btnAgregarU')>
	<cfquery datasource ="sifcontrol">
		INSERT INTO RT_ReportePermiso (RPTId,Usucodigo)
		VALUES (<cfqueryparam cfsqltype="cf_sql_integer" value="#form.RPTId#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Usucodigo1#">)
	</cfquery>
	<cflocation url = "/cfmx/commons/GeneraReportes/GestionReportes/GestionReportes.cfm" addtoken="no">
<cfelseif isdefined('url.btnEliminar')>
	<cfquery datasource="sifcontrol">
		DELETE
		FROM RT_ReportePermiso
		WHERE RPTId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.RPTId#">
		AND Usucodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Usucodigo#">
	</cfquery>
	<cflocation url = "/cfmx/commons/GeneraReportes/GestionReportes/GestionReportes.cfm" addtoken="no">
<cfelseif isdefined('form.btnAgregarR')>
	<cfquery datasource ="sifcontrol">
		INSERT INTO RT_ReportePermiso (RPTId,SScodigo,SRcodigo)
		VALUES (<cfqueryparam cfsqltype="cf_sql_integer" value="#form.RPTId#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.SScodigo1#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.SRcodigo1#">)
	</cfquery>
	<cflocation url = "/cfmx/commons/GeneraReportes/GestionReportes/GestionReportes.cfm" addtoken="no">
<cfelseif isdefined('url.btnEliminarR')>
	<cfquery datasource="sifcontrol">
		DELETE
		FROM RT_ReportePermiso
		WHERE RPTId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.RPTId#">
		AND UPPER(SScodigo) = <cfqueryparam cfsqltype="cf_sql_char" value="#url.SScodigo#">
		AND UPPER(SRcodigo) = <cfqueryparam cfsqltype="cf_sql_char" value="#url.SRcodigo#">
	</cfquery>
	<cflocation url = "/cfmx/commons/GeneraReportes/GestionReportes/GestionReportes.cfm" addtoken="no">
</cfif>