<!--- Recibe conexion, form, name, desc, ecodigo y dato --->
<cfdump var="#url#">
<cfif isdefined("url.RHCcodigo") and Len(Trim(url.RHCcodigo)) and isdefined("url.RHTTId") and Len(Trim(url.RHTTid)) and isdefined("url.RHMPPid") and Len(Trim(url.RHMPPid))>
	<cfquery name="rs" datasource="#session.dsn#">
		select a.RHCid, 
			   b.RHCcodigo,
			   b.RHCdescripcion
		from RHCategoriasPuesto a
		
		inner join RHCategoria b
		on b.RHCid=a.RHCid
		and upper(b.RHCcodigo) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(trim(url.RHCcodigo))#">
		
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHTTid#">
		and a.RHMPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHMPPid#">
					
	</cfquery>
	<script language="JavaScript">
		<cfif rs.recordcount gt 0 >
			window.parent.document.form1.RHCid.value="<cfoutput>#rs.RHCid#</cfoutput>";
			window.parent.document.form1.RHCcodigo.value="<cfoutput>#trim(rs.RHCcodigo)#</cfoutput>";
			window.parent.document.form1.RHCdescripcion.value="<cfoutput>#trim(rs.RHCdescripcion)#</cfoutput>";
		<cfelse>
			window.parent.document.form1.RHCid.value="";
			window.parent.document.form1.RHCcodigo.value="";
			window.parent.document.form1.RHCdescripcion.value="";
		</cfif>
	</script>
<cfelse>
	<script language="JavaScript">
		window.parent.document.form1.RHCid.value="";
		window.parent.document.form1.RHCcodigo.value="";
		window.parent.document.form1.RHCdescripcion.value="";
	</script>
</cfif>