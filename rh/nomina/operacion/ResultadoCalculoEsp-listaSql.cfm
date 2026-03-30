<cfsetting requesttimeout="86400">
<cfset Action="ResultadoCalculoEsp-lista.cfm">
<cfif isdefined("Url.RCNid")>
	<cftry>
    	<!---►►►►►Aplicación de la Nomina Especial◄◄◄◄--->
		<cfif Url.Accion eq "Aplicar">
			<cfset Action="ResultadoCalculoEsp-aplicar.cfm">
		<!---►►►►►Recalculo de la Nomina Especial◄◄◄◄--->
		<cfelseif Url.Accion eq "Recalcular">
			<cfinvoke component="rh.Componentes.RH_CalculoNomina" method="CalculoNomina">
            	<cfinvokeargument name="RCNid" value="#Url.RCNid#">
            </cfinvoke>
		<!---►►►►►Restaurar de la Nomina Especial◄◄◄◄--->	
		<cfelseif Url.Accion eq "Restaurar">
			<cfinvoke component="rh.Componentes.RH_RelacionCalculo" method="RelacionCalculo">
            	<cfinvokeargument name="RCNid" value="#Url.RCNid#">
            </cfinvoke>
		</cfif>
	<cfcatch type="any">
		<cfinclude template="/sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>

<cfoutput>
<form action="#Action#" method="post" name="sql">
	<input name="RCNid" type="hidden" value="<cfif isdefined("Url.RCNid")>#Url.RCNid#</cfif>">
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>