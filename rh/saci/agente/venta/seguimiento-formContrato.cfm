<cfif isdefined('url.CTid') and url.CTid NEQ ''>
	<cfquery name="rsContrato" datasource="#Session.DSN#">
		Select CTid, Contratoid
		from ISBproducto
		where CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CTid#">
		<!--- and CTcondicion = 'C' --->
	</cfquery>

	<cfif isdefined('rsContrato') and rsContrato.recordCount GT 0 and rsContrato.Contratoid NEQ ''>
		<cf_formContrato id="#rsContrato.Contratoid#">
	<cfelse>
		<script language="javascript" type="text/javascript">
//			alert('Error, el contrato no se encuentra o su estado es distinto a: Capturado por el agente');
			alert('Error, el contrato no se encuentra.');			
			this.window.close();
		</script>	
	</cfif>
<cfelse>
	<script language="javascript" type="text/javascript">
		alert('Error, debe enviar el código de la cuenta');
		this.window.close();
	</script>
</cfif>
