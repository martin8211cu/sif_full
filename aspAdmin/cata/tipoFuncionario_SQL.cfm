<cfparam name="modo" default="ALTA">

<cfif not isdefined("form.btnNuevo")>
	<cftry>
		<cfquery name="ABC_TipoIdentif" datasource="#session.DSN#">
			set nocount on

			<cfif isdefined("form.Alta")>
				insert TipoFuncionario (TFdescripcion)
				values (
					 <cfqueryparam value="#form.TFdescripcion#" 	cfsqltype="cf_sql_varchar">)
			<cfelseif isdefined("form.Cambio")>
				update TipoFuncionario
					set TFdescripcion = <cfqueryparam value="#form.TFdescripcion#" cfsqltype="cf_sql_varchar">
				where TFcodigo = <cfqueryparam value="#form.TFcodigo#" cfsqltype="cf_sql_numeric">
<!--- 				  and timestamp = convert(varbinary,#lcase(Form.timestamp)#) --->
				  
				  <cfset modo = 'CAMBIO'>
			<cfelseif isdefined("form.Baja")>
				delete TipoFuncionario
				where TFcodigo= <cfqueryparam value="#form.TFcodigo#" cfsqltype="cf_sql_numeric">
			</cfif>

			set nocount off				
		</cfquery>
	<cfcatch type="any">
		<cfinclude template="/sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>	

<cfoutput>
<form action="tipoFuncionario.cfm" method="post" name="sql">
	<input name="modo"   type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<cfif modo eq 'CAMBIO'><input name="TFcodigo" type="hidden" value="#form.TFcodigo#"></cfif>
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
