<!--- necesario para convertir una fecha string '24/10/2002' en '20021024'  --->
<cffunction name="convertir_fecha" access="public" returntype="string">
<cfargument name="fecha" type="string" required="true">
	<cfset dia = Mid(fecha,1,2)>
	<cfset mes = Mid(fecha,4,2)>	
	<cfset anio = Mid(fecha,7,4)>	
	<cfset fechaConv = anio & mes & dia>			
	<cfreturn #fechaConv#>
</cffunction>
<!--- <cfdump var="#form#">
<cfabort> --->
<CF_JasperReport DATASOURCE="#session.dsn#"
                 OUTPUT_FORMAT="#form.formato#"
                 JASPER_FILE="/sif/cg/consultas/DocumentosEnProceso_jas.jasper">
	<CF_JasperParam name="Ecodigo"   value="#session.Ecodigo#">
	<CF_JasperParam name="Edesc"   value="#session.Cenombre#">
	
	<cfif isdefined("Form.PeriodoIni") and len(trim(Form.PeriodoIni)) and Form.PeriodoIni NEQ -1> 
		<CF_JasperParam name="PeriodoIni" value="#form.PeriodoIni#">
	<cfelse>
		<CF_JasperParam name="PeriodoIni" value="1900">
	</cfif>
	<cfif isdefined("Form.PeriodoFin") and len(trim(Form.PeriodoFin)) and Form.PeriodoFin NEQ -1> 
		<CF_JasperParam name="PeriodoFin" value="#form.PeriodoFin#">		
	<cfelse>
		<CF_JasperParam name="PeriodoFin" value="6100">
	</cfif>
	<cfif isdefined("Form.MesIni") and len(trim(Form.MesIni)) and Form.MesIni NEQ -1> 
		<CF_JasperParam name="MesIni" value="#form.MesIni#">		
	<cfelse>
		<CF_JasperParam name="MesIni" value="1">
	</cfif>
	<cfif isdefined("Form.MesFin") and len(trim(Form.MesFin)) and Form.MesFin NEQ -1> 
		<CF_JasperParam name="MesFin" value="#form.MesFin#">		
	<cfelse>
		<CF_JasperParam name="MesFin" value="12">
	</cfif>
	<cfif isdefined("Form.loteini") and len(trim(Form.loteini)) and Form.loteini NEQ -1> 
		<CF_JasperParam name="LoteIni" value="#form.loteini#">		
	<cfelse>
		<CF_JasperParam name="LoteIni" value="0">
	</cfif>
	<cfif isdefined("Form.lotefin") and len(trim(Form.lotefin)) and Form.lotefin NEQ -1> 
		<CF_JasperParam name="LoteFin" value="#form.lotefin#">		
	<cfelse>
		<CF_JasperParam name="LoteFin" value="999999999999">
	</cfif>

	<cfif isdefined("Form.Oficodigo") and len(trim(Form.Oficodigo))  and Form.Oficodigo NEQ -1> 
		<CF_JasperParam name="OficinaOrigen" value="#form.CCTcodigo#">
	<cfelse>
		<CF_JasperParam name="OficinaOrigen" value="-1">
	</cfif>
	
	<cfif isdefined("Form.Origen") and len(trim(Form.Origen)) and Form.Origen NEQ -1> 
		<CF_JasperParam name="Origen" value="%#Ucase(trim(form.Origen))#%">
	<cfelse>
		<CF_JasperParam name="Origen" value="-1">
	</cfif>	
	<cfif isdefined("Form.Usuario") and len(trim(Form.Usuario)) and Form.Usuario NEQ 'Todos'> 
		<CF_JasperParam name="UsuarioOrigen" value="#Ucase(trim(form.Usuario))#">
	<cfelse>
		<CF_JasperParam name="UsuarioOrigen" value="Todos">
	</cfif>	

	<cfif isdefined("Form.fechaIni") and len(trim(Form.fechaIni)) NEQ 0> 
		<CF_JasperParam name="fechaini" value="#form.fechaIni#">
	</cfif>
	<cfif isdefined("Form.fechaFin") and len(trim(Form.fechaFin)) NEQ 0> 
		<CF_JasperParam name="fechafin" value="#form.fechaFin#">
	</cfif>

	
</CF_JasperReport>
