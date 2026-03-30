<cfparam name="modo" default="ALTA">

<cfif not isdefined("form.btnNuevo")>
	<cftry>
		<cfquery name="ABC_TipoIdentif" datasource="#session.DSN#">
			set nocount on

			<cfif isdefined("form.Alta")>
				insert Pais (Ppais,Pnombre)
				values (
					 	<cfqueryparam value="#form.Ppais#" 		cfsqltype="cf_sql_char">
					 , 	<cfqueryparam value="#form.Pnombre#" 	cfsqltype="cf_sql_varchar">)
			<cfelseif isdefined("form.Cambio")>
				update Pais
					set Pnombre = <cfqueryparam value="#form.Pnombre#" cfsqltype="cf_sql_varchar">
				where Ppais = <cfqueryparam value="#form.Ppais#" cfsqltype="cf_sql_char">
				  
				  <cfset modo = 'CAMBIO'>
			<cfelseif isdefined("form.Baja")>
				delete Pais
				where Ppais= <cfqueryparam value="#form.Ppais#" cfsqltype="cf_sql_char">
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
<form action="paises.cfm" method="post" name="sql">
	<input name="modo"   type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<cfif modo eq 'CAMBIO'><input name="Ppais" type="hidden" value="#form.Ppais#"></cfif>
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
