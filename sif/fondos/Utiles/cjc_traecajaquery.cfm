<!--- Recibe conexion, form, name, desc, ecodigo y dato --->
<cfif isdefined("url.dato") and url.dato NEQ "">
	<!--- Trae las cajas que tienen relaciones --->
	<cfquery name="rs" datasource="#session.Fondos.dsn#">
		select A.CJ01ID,A.CJ1DES 
		from CJM001 A
		where A.CJ01ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.dato#">
		  and exists(Select 1 from CJX019 B where A.CJ01ID = B.CJ01ID)
	</cfquery>
	
	<script language="JavaScript">
		<cfif rs.recordcount gt 0>
		window.parent.document.<cfoutput>#url.form#.#url.name#</cfoutput>.value="<cfoutput>#trim(rs.CJ01ID)#</cfoutput>";
		window.parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value="<cfoutput>#trim(rs.CJ1DES)#</cfoutput>";
		<cfelse>
			window.parent.document.<cfoutput>#url.form#.#url.name#</cfoutput>.value="";
			window.parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value="";
			alert("La caja no existe, o no ha utiliza relaciones")
		</cfif>
	</script>
</cfif>