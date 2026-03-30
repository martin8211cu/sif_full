<cfsavecontent variable="metricas_ret">
<cfquery datasource="#Session.DSN#" name="rsListaMetricas">
  select
	MIGMid,
	MIGMcodigo,
	MIGMnombre,
	MIGRecodigo,
	MIGMdescripcion,
	MIGMnpresentacion,
	MIGMsequencia,
	Ucodigo,
	MIGMcalculo
  from MIGMetricas
 where Dactiva = 1
 order by MIGMnombre
</cfquery>

<cfloop query="rsListaMetricas">
<cfoutput>#rsListaMetricas.MIGMcodigo# = 0;</cfoutput>
</cfloop>
</cfsavecontent>