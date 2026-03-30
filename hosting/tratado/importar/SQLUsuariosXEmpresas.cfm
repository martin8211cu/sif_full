<cfset modo = 'CAMBIO'>
<cfset action = 'IMP_UsuariosXEmpresas.cfm'>
<cftry>
	<cfif isDefined("form.MODODET") and form.MODODET eq "ALTA">
		<cfquery name="rsEImportadorEmpresa" datasource="sifcontrol">
			insert into EImportadorUsuario (EIid,Ecodigo,Usucodigo,BMUsucodigo,BMfechaalta)
			values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EIid#">,
					 <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ecodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Usucodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">, 
					 <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
					) 
		</cfquery>
		<cfset MODODET = "ALTA">
	<cfelseif isDefined("form.MODODET") and form.MODODET eq "BAJA">
		<cfquery name="rsEImportadorEmpresa" datasource="sifcontrol">
			delete EImportadorUsuario
			where EIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EIid#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ecodigo#">
			  and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">
		</cfquery>
		<cfset MODODET = "ALTA">
	</cfif>
		
	<cfcatch type="any">
		<cfinclude template="/sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
</cftry>

<cfoutput>
<form action="#action#" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="MODODET" type="hidden" value="<cfif isdefined("modo")>#MODODET#</cfif>">
	<input name="EIid"  type="hidden" value="<cfif isdefined("form.EIid")>#Form.EIid#</cfif>">
	<input name="CEcodigo"  type="hidden" value="<cfif isdefined("form.CEcodigo")>#Form.CEcodigo#</cfif>">
	<input name="Ecodigo"  type="hidden" value="<cfif isdefined("form.Ecodigo")>#Form.Ecodigo#</cfif>">
	<input name="Enombre"  type="hidden" value="<cfif isdefined("form.Enombre")>#Form.Enombre#</cfif>">
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