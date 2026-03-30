<!---<cf_dump var = "#form#">--->
<!--- para instanciar la Clase GeneraCSD --->
<cfif  not isDefined("form.borrar")>	
		<cfobject type="java" class="generacsd.GeneraCSD" name="myCSD">
		
		<cf_foldersFacturacion name = "rutaCert">
			
		<cfset ruta ="#rutaCert#/Certificado/00001000000404705734.cer" >
		<cfset form.nArchivoC =REReplace(form.nArchivoC,".:\\fakepath\\","#rutaCert#/Certificado/") >
		<cfset form.nArchivoK =REReplace(form.nArchivoK,".:\\fakepath\\","#rutaCert#/Certificado/") >
		<cfset ruta ="#form.nArchivoC#">
		<cfset  CertificadoSelloDigital = myCSD.getCertificado(ruta)>       
		<cfset NoCertificado =  CertificadoSelloDigital.getSerialNumber()>
		<cfset Certificado =  CertificadoSelloDigital.getCertificado()> 
</cfif>		
<cftry>
	<cfif isDefined("form.alta")>				
		<cfquery name="rsInsert" datasource="#session.DSN#">
			insert into RH_CFDI_Certificados (Ecodigo, NoCertificado, Certificado, archivoKey, clave)
			values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#NoCertificado#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Certificado#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.nArchivoK)#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.Clave)#">
					) 
		</cfquery>
		<cfset modo = "CAMBIO">	
	<cfelseif isDefined("form.cambio")>	
		<cfquery name="rsCambio" datasource="#session.DSN#">
			update RH_CFDI_Certificados
				set <!---NoCertificado 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#left(right(trim(form.nArchivoC),24),20)#">,--->
				NoCertificado 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#NoCertificado#">,
				Certificado 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Certificado#">,
                archivoKey 			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.nArchivoK)#">,
                clave				= <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.Clave)#">
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
		<cfset modo = "CAMBIO">
	<cfelseif isDefined("form.borrar")>	
		<cfquery name="rsEliminar" datasource="#session.DSN#">
			delete RH_CFDI_Certificados
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
		<cfset modo = "ALTA">
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
	<cflocation url="RH_CFDI_Certificados.cfm#params#">
</cfoutput>
