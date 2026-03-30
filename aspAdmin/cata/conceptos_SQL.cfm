<cfparam name="modo" default="ALTA">
<cfparam name="modoD" default="ALTA">

<cfif not isdefined("form.btnNuevo")>
	<cftry>
		<cfquery name="ABC_Conceptos" datasource="#session.DSN#">
			set nocount on

			<cfif isdefined("form.Alta")>
				insert LocaleConcepto 
					(LOCnombre, LOCtipo, LOCorden)
				values (
					<cfqueryparam value="#form.LOCnombre#" 	cfsqltype="cf_sql_varchar">
					, <cfqueryparam value="#form.LOCtipo#" 	cfsqltype="cf_sql_char">
					, <cfqueryparam value="#form.LOCorden#" 	cfsqltype="cf_sql_char">
				)
				declare @newConc numeric
				select @newConc = @@identity

				insert LocaleValores 
					(LOCid, Icodigo, LOVsecuencia, LOVdescripcion, LOVvalor)
				Select LOCid=@newConc
					, Icodigo
					, LOVsecuencia=0
					, LOVdescripcion=<cfqueryparam value="#form.LOCnombre#" cfsqltype="cf_sql_varchar">
					, LOVvalor='-'
				from Idioma
				
				select @newConc as nuevoConc
			<cfelseif isdefined("form.Cambio")>
			
				update LocaleConcepto
					set LOCorden = <cfqueryparam value="#form.LOCorden#" 	cfsqltype="cf_sql_char">
				where LOCid = <cfqueryparam value="#form.LOCid#" cfsqltype="cf_sql_numeric">
				  
				  <cfset modo = 'CAMBIO'>
			<cfelseif isdefined("form.Baja")>
				delete LocaleValores
				where LOCid= <cfqueryparam value="#form.LOCid#" cfsqltype="cf_sql_numeric">
				
				delete LocaleConcepto
				where LOCid= <cfqueryparam value="#form.LOCid#" cfsqltype="cf_sql_numeric">
			<cfelseif isdefined("form.AltaD")>
				insert LocaleValores (LOCid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion)
				values (
					<cfqueryparam value="#form.LOCid#" cfsqltype="cf_sql_numeric">
					, null
					, <cfqueryparam value="#form.Icodigo#" cfsqltype="cf_sql_char">
					, <cfqueryparam value="#form.LOVsecuencia#" cfsqltype="cf_sql_integer">
					, <cfqueryparam value="#form.LOVvalor#" cfsqltype="cf_sql_char">
					, <cfqueryparam value="#form.LOVdescripcion#" cfsqltype="cf_sql_varchar">
				)
				
				<cfset modo = 'CAMBIO'>
			</cfif>

			set nocount off				
		</cfquery>
	<cfcatch type="any">
		<cfinclude template="/sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>	

<cfif isdefined('form.Alta') and not isdefined('form.LOCid') and isdefined('ABC_Conceptos') and ABC_Conceptos.recordCount GT 0>
	<cfset form.LOCid = ABC_Conceptos.nuevoConc>
	<cfset modo = "CAMBIO">
</cfif>

<cfoutput>
<form action="conceptos.cfm" method="post" name="sql">
	<input name="modo"   type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="modoD"   type="hidden" value="<cfif isdefined("modoD")>#modoD#</cfif>">	
	<input name="LOCid" type="hidden" value="<cfif modo EQ 'CAMBIO'>#form.LOCid#</cfif>">
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
