<cfif isdefined("url.placa") and Len(Trim(url.placa)) GT 0>
	<cfquery name="rsPlaca" datasource="#Session.DSN#">
		select coalesce(Aid,0) as Aid, coalesce(Astatus, 0) as Astatus
		from Activos
		where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">		
		and rtrim(ltrim(Aplaca)) = <cfqueryparam value="#Trim(url.placa)#" cfsqltype="cf_sql_char">
	</cfquery>
	<!--- <cfdump var="#rsPlaca#"> --->
	<cfoutput>
	<script language="JavaScript">
		<!--//
		<cfif rsPlaca.recordcount and isdefined("rsPlaca.Aid") and rsPlaca.Aid and rsPlaca.Astatus eq 0>
			window.parent.document.form1.DSplaca_text2.value='Mejora';
		<cfelseif rsPlaca.recordcount and isdefined("rsPlaca.Aid") and rsPlaca.Aid and rsPlaca.Astatus eq 60>
			alert("El Activo Fué Retirado");
			window.parent.document.form1.DSplaca_text2.value="";
			window.parent.document.form1.DSplaca.value="";
			window.parent.document.form1.DSplaca.focus();
		<cfelse>
			window.parent.document.form1.DSplaca_text2.value="Adquisición";	
		</cfif>
		//-->
	</script>
	</cfoutput>
</cfif> 