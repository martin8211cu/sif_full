<cfset LvarAction = 'NuevaVersionCE.cfm'>
<cfset LvarError = 0>
<cfquery name="rsAgrupador" datasource="#Session.DSN#">
  select * from CEAgrupadorCuentasSAT where CAgrupador = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CAgrupador#">
</cfquery>

<cfif #rsAgrupador.RecordCount# eq 0>

<cfif not isdefined("Form.Empresa")>
     <cfquery datasource="#Session.DSN#">
		INSERT INTO CEAgrupadorCuentasSAT(CAgrupador, Descripcion, Version, CEcodigo, Status, BMUsucodigo, FechaGeneracion)
        VALUES(<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CAgrupador#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Nombre_Agrupador#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Version#">,#session.CEcodigo#,<cfif isdefined("Form.Estado")>'Inactivo'<cfelse>'Activo'</cfif>,#session.Usucodigo#,SYSDATETIME())
	</cfquery>
	<cfelse>
	<cfquery datasource="#Session.DSN#">
		INSERT INTO CEAgrupadorCuentasSAT(CAgrupador, Descripcion, Version, Ecodigo, CEcodigo, Status, BMUsucodigo, FechaGeneracion)
        VALUES(<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CAgrupador#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Nombre_Agrupador#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Version#">,#Session.Ecodigo#,#session.CEcodigo#,<cfif isdefined("Form.Estado")>'Inactivo'<cfelse>'Activo'</cfif>,#session.Usucodigo#,SYSDATETIME())
	</cfquery>
</cfif>
<cfif isdefined("Form.Cuentas")>
	<cfquery name="rscuentas" datasource="#Session.DSN#">
		INSERT INTO CECuentasSAT(CCuentaSAT, CAgrupador,NombreCuenta,Clasificacion,Ecodigo,BMUsucodigo,FechaGeneracion)
		SELECT CCuentaSAT, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CAgrupador#"> AS CAgrupador, NombreCuenta, Clasificacion,
		(select Ecodigo from CEAgrupadorCuentasSAT where CAgrupador = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CAgrupador#">),
		#session.Usucodigo# AS BMUsucodigo, SYSDATETIME() AS FechaGeneracion FROM CECuentasSAT WHERE CAgrupador = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CAgrupadorEx#">
	</cfquery>
</cfif>
<cfif isdefined("Form.Mapeo")>
	<cfquery name="rsMapeo" datasource="#Session.DSN#">
		INSERT INTO CEMapeoSAT(CCuentaSAT, CAgrupador, Ccuenta, Ecodigo, BMUsucodigo, FechaGeneracion)
		SELECT CCuentaSAT, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CAgrupador#"> AS CAgrupador, Ccuenta, #Session.Ecodigo# AS Ecodigo, #session.Usucodigo# AS BMUsucodigo, SYSDATETIME() AS FechaGeneracion FROM  CEMapeoSAT WHERE CAgrupador = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CAgrupadorEx#">
	</cfquery>
</cfif>
<cfelse >
<cfset LvarError = 1>
</cfif>

<cfset modo="ALTA">


<form action="<cfoutput>#LvarAction#</cfoutput>" method="post" name="sql">
	<cfoutput>
		<input type="hidden" name="modoR" value="1">
		<input type="hidden" name="CAgrupador" value="#form.CAgrupador#">
		<input name="Error" type="hidden" value="#LvarError#">
	</cfoutput>
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>