<cfset modo = "CAMBIO">
	<cftry>			
		<cfif isdefined("Form.btnAgregarDirEscuela") and form.btnAgregarDirEscuela EQ 1>
			<cfquery name="A_MatRequisitos" datasource="#Session.DSN#">
				set nocount on
					insert DirectorEscuela 
						(DIpersona, EScodigo,DIEfecha)
					values (
						<cfqueryparam value="#form.DIpersona#" cfsqltype="cf_sql_numeric">
						, <cfqueryparam value="#form.EScodigoEscuela#" cfsqltype="cf_sql_numeric">
						, getDate())
				set nocount off
			</cfquery>
		<cfelseif isdefined("Form.btnDesactrEscuela") and form.btnDesactrEscuela EQ 1>
			<cfquery name="A_MatRequisitos" datasource="#Session.DSN#">
				set nocount on
					update DirectorEscuela set
						DIEactivo=0
						, DIEfecha = getDate()
						, BMUsucodigo=<cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">
					where DIpersona = <cfqueryparam value="#Form.DIpersona#" cfsqltype="cf_sql_numeric">
						and EScodigo = <cfqueryparam value="#Form.IdEscuelaDesact#" cfsqltype="cf_sql_numeric">
				set nocount off	
			</cfquery>
		<cfelseif isdefined("Form.btnActrEscuela") and form.btnActrEscuela EQ 1>
			<cfquery name="A_MatRequisitos" datasource="#Session.DSN#">
				set nocount on
					update DirectorEscuela set
						DIEactivo=1
						, DIEfecha = getDate()
						, BMUsucodigo=<cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">
					where DIpersona = <cfqueryparam value="#Form.DIpersona#" cfsqltype="cf_sql_numeric">
						and EScodigo = <cfqueryparam value="#Form.IdEscuelaAct#" cfsqltype="cf_sql_numeric">
				set nocount off	
			</cfquery>
		</cfif>
	<cfcatch type="any">
		<cfinclude template="../../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
</cftry>

<form action="director.cfm" method="post" name="sql">
	<cfoutput>
		<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
		<input name="DIpersona" type="hidden" value="<cfif isdefined("Form.DIpersona") and form.DIpersona NEQ ''>#Form.DIpersona#</cfif>">
		<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">	
		<input name="TP" type="hidden" value="DI">		
	</cfoutput>	
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>