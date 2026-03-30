<cfparam name="modo" default="ALTA">
<cfset LvarError = 0>

<cfif not isdefined("Form.Nuevo")>
    <cfquery name="rsAgrupador" datasource="#Session.DSN#">
		select * from CEAgrupadorCuentasSAT where CAgrupador = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CAgrupador#">
	</cfquery>
	<cfif isdefined("Form.Baja")>
		<cfif Len(trim(form.gpoEmpresaid))>
				<cfquery datasource="#session.DSN#">
					UPDATE cm
				    SET cm.GEid = -1
				    FROM CEMapeoSAT cm
					inner join CContables cc
						on cm.Ccuenta = cc.Ccuenta
						and cm.Ecodigo = cc.Ecodigo
				    WHERE ltrim(rtrim(cm.CAgrupador)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.CAgrupador)#">
				    AND cm.GEid = #form.gpoEmpresaid#
				    and cm.Ecodigo in (SELECT  Ecodigo FROM AnexoGEmpresaDet where GEid = #form.gpoEmpresaid#)
				</cfquery>
				<cfquery datasource="#session.DSN#">
					DELETE FROM CEMapeoGE
					WHERE Id_Agrupador = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CAgrupador#">
						and GEid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.gpoEmpresaid#">
						and Ecodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Ecodigo#">
				</cfquery>
		  	<cfset modo="ALTA">
		</cfif>
	<cfelseif isdefined("Form.Cambio")>
		<!--- <cf_dump var="#session.DSN#"> --->
			
		<cfif Len(trim(form.gpoEmpresaid)) is 0>
			<cfquery datasource="#session.DSN#">
				DELETE FROM CEMapeoGE
				WHERE Id_Agrupador = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CAgrupador#">
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Ecodigo#">
			</cfquery>
		<cfelse>
			<cfquery datasource="#session.DSN#">
				INSERT INTO CEMapeoGE
			           (Id_Agrupador
			           ,CEcodigo
			           ,GEid
			           ,Ecodigo)
			     VALUES
			           (<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CAgrupador#">
			           ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.CEcodigo#">
			           ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.gpoEmpresaid#" null="#Len(trim(form.gpoEmpresaid)) is 0#">
			           ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Ecodigo#">)

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