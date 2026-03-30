<!--- MODIFICACIÓN MANUAL DE MARCAS --->
<cfif isdefined("form.Cambio") and isdefined("form.CAMid") and len(trim(form.CAMid))>
	<cfquery datasource="#session.DSN#">
		update RHCMCalculoAcumMarcas set
			CAMcanthorasreb = <cfqueryparam cfsqltype="cf_sql_money" scale="1" value="#form.CAMsuphorasreb#">,
			CAMcanthorasjornada = <cfqueryparam cfsqltype="cf_sql_money" value="#form.CAMsuphorasjornada#">,
			CAMcanthorasextA = <cfqueryparam cfsqltype="cf_sql_money" value="#form.CAMsuphorasextA#">,
			CAMcanthorasextB = <cfqueryparam cfsqltype="cf_sql_money" value="#form.CAMsuphorasextB#">,
			CAMmontoferiado = <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(form.CAMsupmontoferiado,',','','all')#">,
			CAMsuphorasreb = <cfqueryparam cfsqltype="cf_sql_money" scale="1" value="#form.CAMsuphorasreb#">,
			CAMsuphorasjornada = <cfqueryparam cfsqltype="cf_sql_money" value="#form.CAMsuphorasjornada#">,
			CAMsuphorasextA = <cfqueryparam cfsqltype="cf_sql_money" value="#form.CAMsuphorasextA#">,
			CAMsuphorasextB = <cfqueryparam cfsqltype="cf_sql_money" value="#form.CAMsuphorasextB#">,
			CAMsupmontoferiado = <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(form.CAMsupmontoferiado,',','','all')#">
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and CAMid = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#form.CAMid#">
	</cfquery>
<cfelseif isdefined("form.Baja")>
	<!----Actualiza la tabla de marcas (RHControlMarcas) poner nulo el NumeroLote(es el CAMid de RHCMCalculoAcumMarcas)--->
	<cfquery datasource="#session.DSN#">
		update RHControlMarcas set numlote = null, grupomarcas = null, registroaut = 0
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and numlote = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CAMid#">
	</cfquery>
	<!---Eliminar registro ---->
	<cfquery datasource="#session.DSN#">
		delete from RHCMCalculoAcumMarcas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and CAMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CAMid#">
	</cfquery>
</cfif>
<!--- se actualiza la pantalla padre y se cierra la ventana emergente  --->
<script type="text/javascript" language="javascript1.2">	
	window.opener.document.form3.submit();
	window.close();
</script>