<cfparam name="modo" default="ALTA">
<cfset LvarError = 0>
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<!---cfif not isdefined("Form.Empresa")>

		<cfquery datasource="#Session.DSN#">
			INSERT INTO CECuentasSAT(CCuentaSAT, CAgrupador,NombreCuenta,Clasificacion,BMUsucodigo,FechaGeneracion)
            VALUES(<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CCuentaSAT#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CAgrupador#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.NombreCuenta#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Clasificacion#">,#session.Usucodigo#,SYSDATETIME())
		</cfquery>

		<cfelse--->
		<cfquery name="rsVal" datasource="#Session.DSN#">
			select CCuentaSAT from CECuentasSAT where CCuentaSAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CCuentaSAT#">
			and CAgrupador = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CAgrupador#">
		</cfquery>
		<cfif #rsVal.RecordCount# eq 0>
			<cfquery datasource="#Session.DSN#">
				INSERT INTO CECuentasSAT(CCuentaSAT, CAgrupador,NombreCuenta,Clasificacion,Ecodigo,BMUsucodigo,FechaGeneracion)
            	VALUES(<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CCuentaSAT#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CAgrupador#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.NombreCuenta#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Clasificacion#">,
						(select Ecodigo from CEAgrupadorCuentasSAT where CAgrupador = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CAgrupador#">),
						#session.Usucodigo#,SYSDATETIME())
			</cfquery>
			<cfelse>
			<cfset LvarError = 2>
		</cfif>


		<!---/cfif--->
		<cfset modo="CAMBIO">

	<cfelseif isdefined("Form.Baja")>

		<cfquery datasource="#session.DSN#">
			UPDATE cm
		    SET cm.GEid = -1
		    FROM CEMapeoSAT cm
			inner join CContables cc
				on cm.Ccuenta = cc.Ccuenta
				and cm.Ecodigo = cc.Ecodigo
		    WHERE ltrim(rtrim(cm.CAgrupador)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.CAgrupador)#">
		    AND cm.GEid = #form.EGEid#
		    AND ltrim(rtrim(cm.CCuentaSAT)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.CCuentaSATUP)#">
		    and cm.Ecodigo in (SELECT  Ecodigo FROM AnexoGEmpresaDet where GEid = #form.EGEid#)
		</cfquery>

	  	<cfset modo="ALTA">

	<cfelseif isdefined("Form.Cambio")>

		<cfquery datasource="#session.DSN#">
			<!---cfif not isdefined("Form.Empresa")>
				UPDATE CECuentasSAT SET NombreCuenta=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.NombreCuenta#"> ,Clasificacion=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Clasificacion#"> ,Ecodigo=NULL , UsucodigoModifica=#session.Usucodigo# ,FechaModificacion=SYSDATETIME() WHERE CCuentaSAT= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CCuentaSATUP#"> AND CAgrupador= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CAgrupador#">
				<cfelse--->
				UPDATE CECuentasSAT
					SET NombreCuenta=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.NombreCuenta#"> ,
					Clasificacion=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Clasificacion#"> ,
					UsucodigoModifica=#session.Usucodigo# ,
					FechaModificacion=SYSDATETIME()
				WHERE CCuentaSAT= <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.CCuentaSATUP)#">
					AND CAgrupador=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.CAgrupador)#">
			<!--- <cf_dump var="#form#"> --->
			<!---/cfif--->


		</cfquery>
	  	<cfset modo="CAMBIO">
	</cfif>
</cfif>

	<cfset LvarAction = 'CatalogoCuentasSATCE.cfm'>


<form action="<cfoutput>#LvarAction#</cfoutput>" method="post" name="sql">
<cfoutput>
    <input name="Error" type="hidden" value="#LvarError#">

		<cfset modo="CAMBIO">

	 <input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
    <input name="CAgrupador" type="hidden" value="<cfif isdefined("Form.CAgrupador")>#Form.CAgrupador#</cfif>">

	<cfif modo neq 'ALTA'>
		<cfif isdefined('form.CCuentaSAT')>
			<input name="CCuentaSAT" type="hidden" value="#form.CCuentaSAT#">
			<cfelse>
		    <input name="CCuentaSAT" type="hidden" value="#form.CCuentaSATUP#">
		</cfif>

	</cfif>
</cfoutput>
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>