<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Reporte de Asientos</title>
</head>

<body>

	<cfif isdefined("url.RCNid") and Len(Trim(url.RCNid))>
		<cftransaction>
			<cfinvoke component="rh.Componentes.RH_RepAsientos" method="GenerarDatosReporte" returnvariable="rsReporte">
				<cfinvokeargument name="RCNid" 			value="#url.RCNid#">
				<cfinvokeargument name="Ecodigo" 		value="#Session.Ecodigo#"/>
			</cfinvoke>
		</cftransaction>
		
		<cfset url.formato = "flashpaper">
		<cfreport format="#url.formato#" template="RepAsientos.cfr" query="rsReporte">
			<cfreportparam name="Edescripcion" value="#Session.Enombre#">
		</cfreport>
	</cfif>

</body>
</html>
