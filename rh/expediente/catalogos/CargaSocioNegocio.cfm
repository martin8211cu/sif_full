<!--- Me premite cagar el Socio de Negocio de acuerdo al TDid. 
	--->

<cfif url.TDid neq 'undefined' and LEN(TRIM(url.TDid))>


<!---Query que busca el Socio de Negocio asociado--->

	<cfquery name="rsSN" datasource="#session.DSN#">
		select b.SNcodigo,b.SNnumero,b.SNnombre
		from TDeduccion a
		inner join SNegocios b
		on a.SNcodigo =b.SNcodigo  
		and a.Ecodigo =b.Ecodigo  
		where a.Ecodigo =#session.Ecodigo#
		and a.TDid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.TDid#">	 
	</cfquery>
	
	<cfset SNcodigo=#rsSN.SNcodigo#>
	<cfset SNnumero=#rsSN.SNnumero#>
	<cfset SNnombre=#rsSN.SNnombre#>
	<cfoutput>
	<script language="javascript1.2" type="text/javascript">		
		window.parent.document.form1.SNcodigo.value ='#SNcodigo#';
		window.parent.document.form1.SNnumero.value ='#SNnumero#';
		window.parent.document.form1.SNnombre.value='#SNnombre#';
	</script>
	</cfoutput>
</cfif>	

