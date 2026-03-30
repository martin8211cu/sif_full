<cftry>
	<cfif isDefined("form.alta")>				
		<cfquery name="rsMonedas" datasource="#session.DSN#">
			insert into MensajeBoleta (Ecodigo, Mensaje, BMUsucodigo, BMfechaalta)
			values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#mid(trim(Form.Mensaje),1,700)#">,
					 <!----<cfqueryparam cfsqltype="cf_sql_varchar" value="#lcase(mid(trim(Form.Mensaje),1,255))#">,--->
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">, 
					 <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
					) 
		</cfquery>
		<cfset modo = "CAMBIO">	
	<cfelseif isDefined("form.cambio")>	
		<cfquery name="rsMonedas" datasource="#session.DSN#">
			update MensajeBoleta
				set Mensaje = <cfqueryparam cfsqltype="cf_sql_varchar" value="#mid(trim(Form.Mensaje),1,700)#">
				<!----<cfqueryparam cfsqltype="cf_sql_varchar" value="#lcase(mid(trim(Form.Mensaje),1,255))#">----->
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
		<cfset modo = "CAMBIO">
	</cfif>
		
	<cfcatch type="any">
		<cfinclude template="/sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
</cftry>

<cfoutput>
	<cfset params = ''>
	<cfif isdefined("modo") and len(trim(modo))>
		<cfset params = '?modo=#modo#'>
	</cfif>	
	<cfif isdefined("form.ruta") and len(trim(form.ruta))>
		<cfset params = params & '&ruta=#form.ruta#'>
	</cfif>		
	<cflocation url="MensajeBoletaPago.cfm#params#">
</cfoutput>
