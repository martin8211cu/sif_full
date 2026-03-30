<!--- Recibe conexion, form, name, desc, ecodigo y dato --->
<cfif isdefined("url.dato") and url.dato NEQ "">
	<cfquery name="rs" datasource="#session.Fondos.dsn#">
		select CJM005.CP9COD,CP9DES 
		from CJM005,CPM009,CJM001 
		where CJM005.CP9COD = CPM009.CP9COD 
		AND CJM005.CJM00COD = CJM001.CJM00COD 
		AND CJM005.CJM05EST = 'A' 
		AND CJM001.CJ01ID  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Fondos.Caja#">
		and CJM005.CP9COD  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.dato#">
	</cfquery>
	
	<script language="JavaScript">
		<cfif rs.recordcount gt 0>
		window.parent.document.<cfoutput>#url.form#.#url.name#</cfoutput>.value="<cfoutput>#trim(rs.CP9COD)#</cfoutput>";
		window.parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value="<cfoutput>#trim(rs.CP9DES)#</cfoutput>";
		<cfelse>
			window.parent.document.<cfoutput>#url.form#.#url.name#</cfoutput>.value="";
			window.parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value="";
			alert("El autorizador no existe")
		</cfif>
	</script>
</cfif>
