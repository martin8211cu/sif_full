<cfparam name="modo" default="ALTA">

<cfif not isdefined("form.btnNuevo")>
	<cftry>
		<cfquery name="ABC_TipoIdentif" datasource="#session.DSN#">
			set nocount on

			<cfif isdefined("form.Alta")>
				insert TipoIdentificacion (TIcodigo, TInombre)
				values (
					<cfqueryparam value="#form.TIcodigo#"		cfsqltype="cf_sql_varchar">
					, <cfqueryparam value="#form.TInombre#" 	cfsqltype="cf_sql_varchar">)
			<cfelseif isdefined("form.Cambio")>
				update TipoIdentificacion
					set TInombre = <cfqueryparam value="#form.TInombre#" cfsqltype="cf_sql_varchar">
				where TIcodigo = <cfqueryparam value="#form.TIcodigo#" cfsqltype="cf_sql_varchar">
<!--- 				  and timestamp = convert(varbinary,#lcase(Form.timestamp)#) --->
				  
				  <cfset modo = 'CAMBIO'>
			<cfelseif isdefined("form.Baja")>
				delete TipoIdentificacion
				where TIcodigo= <cfqueryparam value="#form.TIcodigo#" cfsqltype="cf_sql_varchar">
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
<form action="tipoIdentificacion.cfm" method="post" name="sql">
	<input name="modo"   type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<cfif modo eq 'CAMBIO'><input name="TIcodigo" type="hidden" value="#form.TIcodigo#"></cfif>
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
