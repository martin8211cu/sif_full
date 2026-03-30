<!--- Actualiza la Observacion--->
<cfset Obser=trim('#url.Observacion#')>

<cfquery name="rsMoneda" datasource="#session.DSN#">
	update CCHarqueo
		set CCHobservacion = <cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Obser#" len="255">
		where CCHAid=#url.CCHAid# 
</cfquery>

<cfoutput>
<script language="javascript1.2" type="text/javascript">
	alert('actualizado con exito');
</script>
</cfoutput>

