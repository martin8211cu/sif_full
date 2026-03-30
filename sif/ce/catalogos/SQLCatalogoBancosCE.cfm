<cfparam name="modo" default="ALTA">


<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cfif not isdefined("Form.Empresa")>
		<cfquery datasource="#Session.DSN#">
			INSERT INTO CEBancos(Clave,Nombre_Corto,Nombre,BMUsucodigo,FechaGeneracion)
            VALUES(RIGHT('000' + Ltrim(Rtrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Clave#">)),3),<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Nombre_Corto#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Nombre#">,#session.Usucodigo#,SYSDATETIME())
		</cfquery>

		<cfelse>
		<cfquery datasource="#Session.DSN#">
			INSERT INTO CEBancos(Clave,Nombre_Corto,Nombre,Ecodigo,BMUsucodigo,FechaGeneracion)
            VALUES(RIGHT('000' + Ltrim(Rtrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Clave#">)),3),<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Nombre_Corto#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Nombre#">,#Session.Ecodigo#,#session.Usucodigo#,SYSDATETIME())
		</cfquery>

		</cfif>
		<cfset modo="ALTA">

	<cfelseif isdefined("Form.Baja")>
		<cftransaction>
			<cfquery datasource="#session.DSN#">
				DELETE FROM CEBancos WHERE Clave=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Clave#">
			</cfquery>

		</cftransaction>
	  	<cfset modo="ALTA">

	<cfelseif isdefined("Form.Cambio")>
		<cfquery datasource="#session.DSN#">
			<cfif not isdefined("Form.Empresa")>
				UPDATE CEBancos SET Nombre_Corto=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Nombre_Corto#"> ,Nombre=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Nombre#"> ,Ecodigo=NULL , BMUsucodigo=#session.Usucodigo# ,FechaModificacion=SYSDATETIME() WHERE Clave= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Clave#">
				<cfelse>
				UPDATE CEBancos SET Nombre_Corto=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Nombre_Corto#"> ,Nombre=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Nombre#"> ,Ecodigo=#Session.Ecodigo# , BMUsucodigo=#session.Usucodigo# ,FechaModificacion=SYSDATETIME() WHERE Clave= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Clave#">

			</cfif>


		</cfquery>
	  	<cfset modo="CAMBIO">
	</cfif>
</cfif>

	<cfset LvarAction = 'CatalogoBancosCE.cfm'>


<form action="<cfoutput>#LvarAction#</cfoutput>" method="post" name="sql">
<cfoutput>

	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<cfif modo neq 'ALTA'>
		<input name="clave" type="hidden" value="<cfif isdefined("Form.clave")>#Form.clave#</cfif>">
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