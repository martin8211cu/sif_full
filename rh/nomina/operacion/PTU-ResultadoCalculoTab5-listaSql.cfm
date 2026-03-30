<!--- <cfdump var="#form#">
<cf_dump var="#url#"> --->

<cfsetting requesttimeout="86400">
<cfset Action="PTU.cfm"><!--- PTU-ResultadoCalculoTab5-lista.cfm Por acá sin accion aplicar esta pendiente de probar --->
<cfif isdefined("Url.RCNid")>
	<cftry>
		<cfif Url.Accion eq "Aplicar">
			<!--- Aplicar Relación de Cálculo --->
			<cfset Action="PTU.cfm"><!--- PTU-ResultadoCalculoTab5-aplicar.cfm --->
         </cfif>
	<cfcatch type="any">
		<cfinclude template="/sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>

<cfoutput>
<form action="#Action#" method="post" name="sql">
	<input name="RHPTUEid" type="hidden" value="<cfif isdefined("Url.RHPTUEid")>#Url.RHPTUEid#</cfif>">
    <input name="tab" type="hidden" value="5">
	<input name="RCNid" type="hidden" value="<cfif isdefined("Url.RCNid")>#Url.RCNid#</cfif>">
    <input name="Accion" type="hidden" value="<cfif isdefined("Url.Accion")>#Url.Accion#</cfif>">
    
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>

