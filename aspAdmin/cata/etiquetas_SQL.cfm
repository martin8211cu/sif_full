<cfparam name="modo" default="ALTA">
<cfparam name="modoD" default="ALTA">

<cftry>
	<cfquery name="ABC_Etiquetas" datasource="#session.DSN#">
		set nocount on

		<cfif isdefined("form.Alta")>
			insert LocaleEtiqueta (LOEnombre)
			values (<cfqueryparam value="#form.LOEnombre#" 	cfsqltype="cf_sql_varchar">)
			
			declare @newEtiq numeric
			select @newEtiq = @@identity
			
			insert LocaleTraduccion 
			(LOEid, Icodigo, LOTdescripcion)
			values (@newEtiq, 'es', <cfqueryparam value="#form.LOTdescripcion#" cfsqltype="cf_sql_varchar">)
			
			select @newEtiq as newEtiqueta
		<cfelseif isdefined("form.Baja")>
			delete LocaleTraduccion
			where LOEid= <cfqueryparam value="#form.LOEid#" cfsqltype="cf_sql_numeric">
					
			delete LocaleEtiqueta
			where LOEid= <cfqueryparam value="#form.LOEid#" cfsqltype="cf_sql_numeric">
		<cfelseif isdefined("form.AltaD")>
			insert LocaleTraduccion 
			(LOEid, Icodigo, LOTdescripcion)
			values (
				<cfqueryparam value="#form.LOEid#" cfsqltype="cf_sql_numeric">
				, <cfqueryparam value="#form.Icodigo#" cfsqltype="cf_sql_char">
				, <cfqueryparam value="#form.LOTdescripcion#" cfsqltype="cf_sql_varchar">
			)
			
			<cfset modo ="CAMBIO">
		<cfelseif isdefined("form.CambioD")>
			update LocaleTraduccion set
				Icodigo =<cfqueryparam value="#form.Icodigo#" cfsqltype="cf_sql_char">
				, LOTdescripcion=<cfqueryparam value="#form.LOTdescripcion#" cfsqltype="cf_sql_varchar">
			where LOEid=<cfqueryparam value="#form.LOEid#" cfsqltype="cf_sql_numeric">
				and LOTid=<cfqueryparam value="#form.LOTid#" cfsqltype="cf_sql_numeric">
				
			<cfset modo ="CAMBIO">
			<cfset modoD ="CAMBIO">
		<cfelseif isdefined("form.NuevoD")>
			<cfset modo ="CAMBIO">		
		</cfif>

		set nocount off				
	</cfquery>
<cfcatch type="any">
	<cftransaction action="rollback"/>
	<cfinclude template="/sif/errorPages/BDerror.cfm">
	<cfabort>
</cfcatch>
</cftry>
<cfoutput>

<cfif isdefined('form.Alta') and modo EQ 'ALTA'>
	<cfset form.LOEid = ABC_Etiquetas.newEtiqueta>
	<cfset modo ="CAMBIO">
</cfif>

<form action="etiquetas.cfm" method="post" name="sql">
	<input name="modo"   type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="modoD"   type="hidden" value="<cfif isdefined("modoD")>#modoD#</cfif>">	
	<input name="LOEid"   type="hidden" value="<cfif isdefined("form.LOEid")>#form.LOEid#</cfif>">	
	<cfif modoD NEQ 'ALTA'>
		<input name="LOTid"   type="hidden" value="<cfif isdefined("form.LOTid")>#form.LOTid#</cfif>">	
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
