<cfset modo = 'ALTA'>
<cfset action = 'IMP_EmpresasXFormato.cfm'>
<cftry>
	<cfif isDefined("form.ALTA")>
		<cfquery name="rsEImportadorEmpresa" datasource="sifcontrol">
			insert into EImportadorEmpresa (EIid,Ecodigo,BMUsucodigo,BMfechaalta)
			values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EIid#">,
					 <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ecodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">, 
					 <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
					) 
		</cfquery>
		<cfset modo = "ALTA">
	<cfelseif isDefined("form.BAJA")>	
		<cfquery name="EImportadorUsuario" datasource="sifcontrol">
			delete EImportadorUsuario
			where EIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EIid#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ecodigo#">
		</cfquery>
		<cfquery name="rsEImportadorEmpresa" datasource="sifcontrol">
			delete EImportadorEmpresa
			where EIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EIid#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ecodigo#">
		</cfquery>
		<cfset modo = "ALTA">
	</cfif>
		
	<cfcatch type="any">
		<cfinclude template="/sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
</cftry>

<cfoutput>
<form action="#action#" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="EIid"  type="hidden" value="<cfif isdefined("form.EIid")>#Form.EIid#</cfif>">
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
	<script language="JavaScript1.2" type="text/javascript">
		document.forms[0].submit();
	</script>	
</body>
</HTML>