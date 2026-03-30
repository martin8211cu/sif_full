<cfif isdefined("url.DEid") and len(trim(url.DEid)) and isdefined("url.RHEEid") and len(trim(url.RHEEid)) >
	<cfquery name="data" datasource="#session.DSN#">
		select a.DEideval, 	{fn concat( de.DEnombre, {fn concat(' ' , {fn concat(de.DEapellido1, {fn concat(' ', de.DEapellido2)})})}  )} as DEnombre
		
		from RHEvaluadoresDes a
		
		inner join DatosEmpleado de
		on de.DEid=a.DEideval
		
		where a.RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHEEid#">
		and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
		and a.RHEDtipo in ('C', 'S')
	</cfquery>
	<cfif data.recordcount gt 0>

			<script type="text/javascript" language="javascript1.2">
				var combo = window.parent.document.form1.DEidotro;
				combo.length = 0;
				
				<cfoutput query="data">
					combo.length = combo.length + 1;
					combo.options[combo.length-1].text = '#data.DEnombre#';
					combo.options[combo.length-1].value = '#data.DEideval#';
				</cfoutput>			

			</script>
	</cfif>
</cfif>