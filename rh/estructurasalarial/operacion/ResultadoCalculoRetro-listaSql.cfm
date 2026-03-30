<cfsetting requesttimeout="86400">
<cfset Action="ResultadoCalculoRetro-lista.cfm">
<cfif isdefined("Url.RCNid")>
	<cftry>
		<cfif Url.Accion eq "Aplicar">
			<!--- Aplicar Relación de Cálculo --->
			<cfset Action="ResultadoCalculoRetro-aplicar.cfm">
		<cfelseif Url.Accion eq "Recalcular">
			<!--- Regenerar Relación de Cálculo --->
			<cfinvoke component="rh.Componentes.RH_CalculoNomina" method="CalculoNomina"
				datasource="#session.dsn#"
				Ecodigo = "#Session.Ecodigo#"
				RCNid = "#Url.RCNid#"
				Usucodigo = "#Session.Usucodigo#"
				Ulocalizacion = "#Session.Ulocalizacion#" />
		<cfelseif Url.Accion eq "Restaurar">
			<cfinvoke component="rh.Componentes.RH_RelacionCalculo" method="RelacionCalculo"
				datasource="#session.dsn#"
				Ecodigo = "#Session.Ecodigo#"
				RCNid = "#Url.RCNid#"
				Tcodigo = "#Url.Tcodigo#"
				Usucodigo = "#Session.Usucodigo#"
				Ulocalizacion = "#Session.Ulocalizacion#" />
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
