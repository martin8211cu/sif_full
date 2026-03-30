<!--- Actualiza la Observacion--->
<cfset Obser='#url.Observacion#'>

<cfquery name="rsMoneda" datasource="#session.DSN#">
	update ECuentaBancaria
		set ECobservacion = <cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Obser#" len="255">
		where ECid=#url.ECid# 
</cfquery>

<cfoutput>
<script language="javascript1.2" type="text/javascript">
	alert('actualizado con exito');
</script>
</cfoutput>

