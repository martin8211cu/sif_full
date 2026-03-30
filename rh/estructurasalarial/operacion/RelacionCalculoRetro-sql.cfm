<HTML>
<body>
<cfsetting requesttimeout="#3600*24#">
<cfset action = "RelacionCalculoRetro-lista.cfm">
<cfif isdefined("url.btnAplicar")>
	<cfparam name="form.btnAplicar" default="">
	<cfparam name="form.RCNid" default="1">
	<cfparam name="form.Tcodigo" default="1">
</cfif>
<cfif isdefined("Form.btnAplicar")>
	<cfset action = "ResultadoCalculoRetro-lista.cfm">
	<cfoutput>
		<form action="#action#" method="post" name="form1">
			<input type="hidden" name="RCNid" id="RCNid" value="#form.RCNid#">
			<script language="javascript">
				function sbRegresar(RCNid)
				{
					document.form1.RCNid.value = RCNid;
					document.form1.submit();
				}
			</script>
		</form>
		<cfparam name="Application.RelacionCalculoRetro_#form.RCNid#" default="Proceso no existe">
		<cfif not find("Ejecutando Proceso", Application["RelacionCalculoRetro_#form.RCNid#"])>
			<cfset Application["RelacionCalculoRetro_#form.RCNid#"] = "Iniciando Proceso...">
			<cflocation url="/cfmx/rh/nomina/operacion/progreso.cfm?RCNid=#form.RCNid#&Tcodigo=#Form.Tcodigo#&RCDescripcion=#form.RCDescripcion#&RCdesde=#form.RCdesde#&RChasta=#form.RChasta#">
			<iframe id="ifrVerificar" src="RelacionCalculoRetro-sql.cfm?btnVerificar&RCNid=#form.RCNid#&ms=100" width="100%" height="100%" frameborder="0">
			</iframe>
		</cfif>
	</cfoutput>

<cfelseif isdefined("url.btnVerificar")>
		<form action="#action#" method="post" name="sql">
			<input name="RCNid" type="hidden" value="#Form.RCNid#">
		</form>
		<script language="JavaScript">document.form1.submit();</script>
</cfif>
</body>
</HTML>

