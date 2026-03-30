<cfparam name="modo" default="ALTA">

<cfif not isdefined("form.btnNuevo")>
	<cftry>
		<cfquery name="ABC_FPago" datasource="#session.DSN#">
			set nocount on

			<cfif isdefined("form.Alta")>
				insert Paquete (PAdescripcion, PAcod, PAtexto)
				values (
					 	<cfqueryparam value="#form.PAdescripcion#" cfsqltype="cf_sql_varchar">
					 ,	<cfqueryparam value="#form.PAcod#" cfsqltype="cf_sql_varchar">
					 ,	<cfqueryparam value="#form.PAtexto#" cfsqltype="cf_sql_varchar">
						)
				select @@identity as newPaquete
				
			<cfelseif isdefined("form.Cambio")>
				update Paquete
					set PAdescripcion = <cfqueryparam value="#form.PAdescripcion#" cfsqltype="cf_sql_varchar">
					,	PAcod = <cfqueryparam value="#form.PAcod#" cfsqltype="cf_sql_varchar">
					,	PAtexto = <cfqueryparam value="#form.PAtexto#" cfsqltype="cf_sql_varchar">
				where PAcodigo = <cfqueryparam value="#form.PAcodigo#" cfsqltype="cf_sql_numeric">
				  
				  <cfset modo = 'CAMBIO'>
			<cfelseif isdefined("form.Baja")>
				delete PaqueteModulo
				where PAcodigo= <cfqueryparam value="#form.PAcodigo#" cfsqltype="cf_sql_numeric">
		
				delete Paquete
				where PAcodigo= <cfqueryparam value="#form.PAcodigo#" cfsqltype="cf_sql_numeric">				
			<cfelseif isdefined("form.modoModulo") AND form.modoModulo EQ "ALTA">
				insert PaqueteModulo (PAcodigo,modulo)
				values(
					<cfqueryparam value="#form.PAcodigo#" cfsqltype="cf_sql_numeric">,
					<cfqueryparam value="#form.modulo#" cfsqltype="cf_sql_char">
				)
				
			  	<cfset modo = 'CAMBIO'>				
			<cfelseif isdefined("form.BajaM") and form.BajaM NEQ "">
				if exists(	select * from PaqueteTarifas pt, TarifaCalculoIndicador i
							 where PAcodigo= <cfqueryparam value="#form.PAcodigo#" cfsqltype="cf_sql_numeric">
							   and i.modulo= <cfqueryparam value="#form.modulo#" cfsqltype="cf_sql_char">
							   and pt.TCcodigo = i.TCcodigo)
						   raiserror 50000 'Paquete contiene Tarifas asignadas'
				else
				delete PaqueteModulo
				where PAcodigo= <cfqueryparam value="#form.PAcodigo#" cfsqltype="cf_sql_numeric">
					and modulo= <cfqueryparam value="#form.modulo#" cfsqltype="cf_sql_char">
		
			  	<cfset modo = 'CAMBIO'>				
			<cfelseif isdefined("form.NuevoD")>
			  	<cfset modo = 'CAMBIO'>				
			</cfif>

			set nocount off				
		</cfquery>
	<cfcatch type="any">
		<cfinclude template="../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>	

<cfif isdefined('form.Alta') and not isdefined('form.PAcodigo')>
	<cfset form.PAcodigo = ABC_FPago.newPaquete>
	<cfset modo = "CAMBIO">	
</cfif>

<cfoutput>
	<form action="paquete.cfm" method="post" name="sql">
		<input name="modo"   type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
		<cfif modo eq 'CAMBIO'><input name="PAcodigo" type="hidden" value="#form.PAcodigo#"></cfif>
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
