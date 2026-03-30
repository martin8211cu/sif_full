<!--- Recibe conexion, form, name, desc, ecodigo y dato --->
<cfif isdefined("url.dato") and url.dato NEQ "">
	<cfquery name="dataSolicitud" datasource="#session.DSN#">
		select CMTScodigo
		from ESolicitudCompraCM
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and ESidsolicitud = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ESidsolicitud#">
	</cfquery>

	<cfquery name="rs" datasource="#session.DSN#">
		select a.CFid, b.CFcodigo, b.CFdescripcion 
		from CMTSolicitudCF a
		
		inner join CFuncional b
		 on a.CFid=b.CFid
		and a.Ecodigo=b.Ecodigo
		
		where a.Ecodigo    = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
		  and a.CMTScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#dataSolicitud.CMTScodigo#">
		  and upper(ltrim(rtrim(b.CFcodigo))) =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(ucase(url.dato))#">
	</cfquery>

	<cfif rs.recordCount gt 0>
		<script language="JavaScript">
			window.parent.document.form1.CFid_Detalle.value="<cfoutput>#rs.CFid#</cfoutput>";
			window.parent.document.form1.CFcodigo_Detalle.value="<cfoutput>#trim(rs.CFcodigo)#</cfoutput>";
			window.parent.document.form1.CFdescripcion_Detalle.value="<cfoutput>#trim(rs.CFdescripcion)#</cfoutput>";
		</script>
	<cfelse>
		<script language="JavaScript">
			window.parent.document.form1.CFid_Detalle.value="";
			window.parent.document.form1.CFcodigo_Detalle.value="";
			window.parent.document.form1.CFdescripcion_Detalle.value="";
		</script>
	</cfif>
</cfif>
