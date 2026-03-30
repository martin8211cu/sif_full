<cfif isdefined('Guardar') and isdefined('form.DEid') and len(trim(form.DEid))>
	<cfquery name="rsExiste" datasource="#Session.DSN#">
		select DIEMid
		from DEmpleado 
		where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		  and DIEMtipo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DIEMtipo#">
	</cfquery>
	<cfif len(trim(rsExiste.DIEMid))>
		<cfquery datasource="#Session.DSN#">
			update DEmpleado set 
				<!---DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">,--->
				DGid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.DGid#" voidnull>,
			  	<!---DIEMtipo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DIEMtipo#">,--->
				DIEMdestalles = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DIEMdestalles#">,
				DIEMapartado = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DIEMapartado#">,
				Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
				BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
			where DIEMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsExiste.DIEMid#">
		</cfquery>
	<cfelse>
		<cfquery datasource="#Session.DSN#">
			insert into DEmpleado(DEid,DGid,DIEMdestalles,DIEMapartado,DIEMtipo,Ecodigo,BMUsucodigo)
			values(
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.DGid#" voidnull>,
			  	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DIEMdestalles#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DIEMapartado#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DIEMtipo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
		</cfquery>
	</cfif>
	<cfif isdefined('form.CambiarDir') and form.CambiarDir eq '1'>
		<cfquery datasource="#Session.DSN#">
			update DatosEmpleado 
			  set DEdireccion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.direccion#">
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			<cfif Session.cache_empresarial EQ 0>
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			</cfif>
		</cfquery>
	</cfif>
</cfif>
<form action="expediente-cons.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<input name="DEid" type="hidden" value="<cfif isdefined("form.DEid")><cfoutput>#form.DEid#</cfoutput></cfif>">			
	<input name="o" type="hidden" value="2">		
	<input name="sel" type="hidden" value="1">
	<cfif isdefined('form.Ppais') and len(trim(form.Ppais))>
		<input name="Ppais" type="hidden" value="<cfoutput>#form.Ppais#</cfoutput>">
	</cfif>
	<cfif isdefined('form.DIEMtipo') and len(trim(form.DIEMtipo))>
		<input name="DIEMtipo" type="hidden" value="<cfoutput>#form.DIEMtipo#</cfoutput>">
	</cfif>
	<cfif isdefined('rsExiste.DIEMid') and len(trim(rsExiste.DIEMid))>
		<input name="DIEMid" type="hidden" value="<cfoutput>#rsExiste.DIEMid#</cfoutput>">
	</cfif>
	
</form>
<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>