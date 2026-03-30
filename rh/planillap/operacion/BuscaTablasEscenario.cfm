<cfif isdefined("url.RHEid") and len(trim(url.RHEid))>
	<!---//////////////////////////////////////////////////////////////////////////////////
		Se carga en el value del combo el RHETEid (Llave de RHETablasEscenario).
		Se traen las tablas del escenario seleccionado del conlis, siempre y cuando 
		la fecha de la tabla este dentro de las fechas del escenario al que se exportaran.
	///////////////////////////////////////////////////////////////////////////////////////----->
	<cfquery name="rsTablas" datasource="#session.DSN#">
		select 	a.RHETEdescripcion,
				a.RHETEid, 
				a.RHETEfdesde as desde, 
				a.RHETEfhasta as hasta 
		from RHETablasEscenario a	
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and a.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHEid#">	
			and a.RHETEfdesde <=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.RHEfhasta)#"> 	
			and a.RHETEfhasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.RHEfdesde)#"> 
	</cfquery>
	
	<script type="text/javascript" language="javascript1.2">
		window.parent.document.form1.RHVTid.options.length = 0;
		 var i = 0;
		<cfoutput query="rsTablas">
			<cfset vdesde = IIf( len(rsTablas.desde), DE(' Desde: ' & LSDateFormat(rsTablas.desde, 'dd/mm/yyyy')), DE('') ) >
			<cfset vhasta = IIf( len(rsTablas.hasta), DE(' Hasta: '& LSDateFormat(rsTablas.hasta, 'dd/mm/yyyy')), DE('') ) >

			window.parent.document.form1.RHVTid.options.length++;
			window.parent.document.form1.RHVTid.options[i].text = '#JSStringFormat(rsTablas.RHETEdescripcion)#, #JSStringFormat(vdesde)# #JSStringFormat(vhasta)#';
			window.parent.document.form1.RHVTid.options[i].value = '#rsTablas.RHETEid#';
			i++;
		 </cfoutput>
	</script>
</cfif>
