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
	</cfquery>
	
	<cfif isdefined("Url.EOidordenName")>
		<cfparam name="LvarEOidorden" default="#Url.EOidordenName#">
	<cfelse>
		<cfparam name="LvarEOidorden" default="EOidorden">
	</cfif>
	<cfif isdefined("Url.EOnumeroName")>
		<cfparam name="LvarEOnumero" default="#Url.EOnumeroName#">	
	<cfelse>
		<cfparam name="LvarEOnumero" default="EOnumero">
	</cfif>
	<cfif isdefined("Url.ObservacionesName")>
		<cfparam name="LvarObservaciones" default="#Url.ObservacionesName#"> 
	<cfelse>
		<cfparam name="LvarObservaciones" default="Observaciones"> 
	</cfif>
	
	<script language="javascript1.2" type="text/javascript">
		<cfif rs.recordCount gt 0>
			<cfoutput>
			window.parent.document.form1.#LvarEOidorden#.value = '#rs.EOidorden#';
			window.parent.document.form1.#LvarEOnumero#.value = '#rs.EOnumero#';
			window.parent.document.form1.#LvarObservaciones#.value = '#rs.Observaciones#';
			</cfoutput>
		<cfelse>
			<cfoutput>		
				window.parent.document.form1.#LvarEOidorden#.value = '';
				window.parent.document.form1.#LvarEOnumero#.value = '';
				window.parent.document.form1.#LvarObservaciones#.value = '';
			</cfoutput>
		</cfif>
	</script>
</cfif>
