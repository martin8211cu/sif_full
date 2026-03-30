
<cfif not isdefined("form.Nuevo")>
	<cftry>
		<cfquery name="ABC_Categorias" datasource="sdc">
			set nocount on			
			<cfif isdefined("form.Alta")>
				insert MSCategoria ( MSCnombre )
							values( <cfqueryparam value="#form.MSCnombre#"    cfsqltype="cf_sql_varchar"> )
				<cfset modo="ALTA">

			<cfelseif isdefined("Form.Baja")>
				delete MSCategoria
				where MSCcategoria = <cfqueryparam value="#form.MSCcategoria#" cfsqltype="cf_sql_numeric">
				<cfset modo="ALTA">

			<cfelseif isdefined("Form.Cambio")>
				 update MSCategoria
				 set MSCnombre = <cfqueryparam value="#form.MSCnombre#" cfsqltype="cf_sql_varchar">
				 where MSCcategoria = <cfqueryparam value="#form.MSCcategoria#" cfsqltype="cf_sql_numeric">
			     <cfset modo="CAMBIO">
			</cfif>
			set nocount off
		</cfquery>

	<cfcatch type="any">
		<cfinclude template="../../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>


<cfoutput>
<form action="Categorias.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<cfif isdefined("modo") and modo neq 'ALTA'>
		<input name="MSCcategoria" type="hidden" value="<cfif isdefined("form.MSCcategoria")>#form.MSCcategoria#</cfif>">
	</cfif>	
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