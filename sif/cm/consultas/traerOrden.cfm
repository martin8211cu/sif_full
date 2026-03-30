<cfif isdefined("url.EOnumero") and len(trim(url.EOnumero))>
	<cfquery name="rs" datasource="#session.DSN#">
		select a.EOidorden, a.EOnumero, a.Observaciones, a.SNcodigo, b.SNnumero, b.SNnombre
		from EOrdenCM a
	
		inner join SNegocios b
		on a.SNcodigo=b.SNcodigo
		  and a.Ecodigo=b.Ecodigo

		where a.EOestado in (10, 55)
		  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and a.EOnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EOnumero#">
		  and EOidorden in (  select distinct EOidorden 
							  from DOrdenCM
							  where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							  and DOcantidad > DOcantsurtida 
		  )
	</cfquery>
	
	<script language="javascript1.2" type="text/javascript">
		<cfif rs.recordCount gt 0>
			<cfoutput>
			window.parent.document.form1.EOidorden.value = '#rs.EOidorden#';
			window.parent.document.form1.EOnumero.value = '#rs.EOnumero#';
			window.parent.document.form1.Observaciones.value = '#rs.Observaciones#';
			</cfoutput>
		<cfelse>
			window.parent.document.form1.EOidorden.value = '';
			window.parent.document.form1.EOnumero.value = '';
			window.parent.document.form1.Observaciones.value = '';
		</cfif>
	</script>
</cfif>
