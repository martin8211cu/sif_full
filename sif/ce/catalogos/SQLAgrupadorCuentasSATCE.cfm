<cfparam name="modo" default="ALTA">
<cfset LvarError = 0>

<cfif not isdefined("Form.Nuevo")>
    <cfquery name="rsAgrupador" datasource="#Session.DSN#">
		select * from CEAgrupadorCuentasSAT where CAgrupador = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CAgrupador#">
	</cfquery>
	<cfif isdefined("Form.Alta")>
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
		<cfelse>
		<cfset LvarError = 2>
		</cfif>
		<cfset modo="ALTA">

	<cfelseif isdefined("Form.Baja")>
		<cftransaction>
			<cfquery datasource="#session.DSN#" name="numCue">
				SELECT * FROM CECuentasSAT WHERE CAgrupador = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CAgrupador#">
			</cfquery>
			<cfif #numCue.RecordCount# eq 0>
				<cfquery datasource="#session.DSN#">
					DELETE FROM CEAgrupadorCuentasSAT WHERE CAgrupador = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CAgrupador#">
				</cfquery>
			<cfelse>
			<cfset LvarError = 1>

			</cfif>

		</cftransaction>
	  	<cfset modo="ALTA">

	<cfelseif isdefined("Form.Cambio")>
		<cfquery datasource="#session.DSN#">
			<cfif not isdefined("Form.Empresa")>
				UPDATE CEAgrupadorCuentasSAT SET Descripcion=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Nombre_Agrupador#"> ,Version=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Version#"> ,Ecodigo=NULL , UsucodigoModifica=#session.Usucodigo# ,FechaModificacion=SYSDATETIME()
				<cfif isdefined("Form.Estado")>
					,Status = 'Inactivo'
					<cfelse>
					,Status = 'Activo'
				</cfif>
				WHERE CAgrupador= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CAgrupador#">

			<cfelse>
				UPDATE CEAgrupadorCuentasSAT SET Descripcion=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Nombre_Agrupador#"> ,Version=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Version#"> ,Ecodigo=#Session.Ecodigo# , UsucodigoModifica=#session.Usucodigo# ,FechaModificacion=SYSDATETIME()
				<cfif isdefined("Form.Estado")>
					,Status = 'Inactivo'
					<cfelse>
					,Status = 'Activo'
				</cfif>
				WHERE CAgrupador= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CAgrupador#">

			</cfif>
		</cfquery>

		<cfif isdefined("Form.Empresa")>
			<cfquery datasource="#session.DSN#">
				update cs set Ecodigo = ca.Ecodigo
				from CECuentasSAT cs
				inner join CEAgrupadorCuentasSAT ca
					on cs.CAgrupador = ca.CAgrupador
			</cfquery>
		</cfif>
	  	<cfset modo="CAMBIO">

	</cfif>
</cfif>

	<cfset LvarAction = 'AgrupadorCuentasSATCE.cfm'>


<form action="<cfoutput>#LvarAction#</cfoutput>" method="post" name="sql">
<cfoutput>
    <input name="Error" type="hidden" value="#LvarError#">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<cfif modo neq 'ALTA'>
		<input name="CAgrupador" type="hidden" value="<cfif isdefined("Form.CAgrupador")>#Form.CAgrupador#</cfif>">

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