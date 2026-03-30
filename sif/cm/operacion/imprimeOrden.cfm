<!--- PROCESO DE IMPRESIÓN DE LA Orden --->
<cfparam name="url.Ecodigo" default="#Session.Ecodigo#">
<cfset bandImpreso = false>
<cfif isdefined("url.EOidorden") and len(trim(url.EOidorden))>	
	<!--- Busca el formato según el tipo de transacción que se le ha asignado --->
	<cfquery name="rsTipoOC" datasource="#Session.DSN#">
		select a.EOnumero, a.CMTOcodigo, rtrim(b.FMT01COD) as formato
		from EOrdenCM a 
			 inner join CMTipoOrden b
				on a.Ecodigo = b.Ecodigo
				and a.CMTOcodigo = b.CMTOcodigo 
                <!--- Se comenta el Ecodigo por efectos Intercompany --->
		where <!---a.Ecodigo   = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Ecodigo#">
		  and ---> a.EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EOidorden#">
	</cfquery>

	<cfif rsTipoOC.recordcount gt 0 and len(trim(rsTipoOC.formato)) >
		<cfquery name="rsFormato" datasource="#session.DSN#">
			select FMT01tipfmt, FMT01cfccfm
			from FMT001
			where (Ecodigo is null or Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Ecodigo#">)
			  and FMT01COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(rsTipoOC.formato)#">
		</cfquery>

		<cfif rsFormato.FMT01tipfmt eq 1 or rsFormato.FMT01tipfmt eq 0 >
			<cfset continuar = true >
			<cfif rsFormato.FMT01tipfmt eq 0 and len(trim(rsFormato.FMT01cfccfm)) eq 0 >
				<cfset LvarOK = true >
				<cfset continuar = false >
			</cfif>
		
			<cfif continuar >
				<cfset LvarArchivo = trim(rsFormato.FMT01cfccfm) >
				<cfinclude template="../../Utiles/validaUri.cfm">
				<cfset LvarOk = validarUrl( trim(rsFormato.FMT01cfccfm) ) >
				<cfif not LvarOK ><cf_errorCode	code = "50274"
				                  				msg  = "No existe el archivo indicado para el formato estático: @errorDat_1@"
				                  				errorDat_1="#LvarSPhomeuri#"
				                  ></cfif>
			</cfif>
		</cfif>		
	</cfif>
			 
	<cfif isdefined("LvarArchivo") >	
		<cfif rsFormato.FMT01tipfmt eq 1>
			<cfif isdefined('url.tipoImpresion') and url.tipoImpresion EQ '1'>			
							<cf_templatecss>
							<cfset parametros = "">
							<cfset parametros = parametros & "&EOidorden=" & url.EOidorden & "&EOnumero=" & rsTipoOC.EOnumero & "&Ecodigo=" & url.Ecodigo>
							<cfif isdefined("url.primeravez") and len(trim(url.primeravez)) >
								<cfset parametros = parametros & "&primeravez=ok" >	
							</cfif>
							<!---<cf_rhimprime datos="/sif/cm/consultas/OrdenCompraLocal-html.cfm" paramsuri="#parametros#"> --->
							<cf_rhimprime datos="#LvarArchivo#" paramsuri="#parametros#">
							<cfinclude template="#LvarArchivo#">
							<br>
			<cfelse>
				<cfset parametros = "">
				<cfset parametros = parametros & "&EOidorden=" & url.EOidorden >	
				<cfif isdefined("url.primeravez") and len(trim(url.primeravez)) >
					<cfset parametros = parametros & "&primeravez=ok" >	
				</cfif>
				<cfif isdefined("rsTipoOC.EOnumero") and len(trim(rsTipoOC.EOnumero)) >
					<cfset parametros = parametros & "&EOnumero=" & rsTipoOC.EOnumero >	
				</cfif>
	
				<cf_rhimprime datos="#LvarArchivo#" paramsuri="#parametros#">
				<cf_templatecss>			
				<!--- <cfinclude template="#LvarArchivo#"> --->	
				<cfinclude template="ImpresionOrdenCompraRP1.cfm">	
			</cfif>
			<cfset bandImpreso = true>	
		<cfelse>
			<!--- NO BORRAR PROBAR EN EL MOMENTO QUE SEA NECESARIO --->
			<!--- se supone que el archivo debe tener los mismos parametros que el estatico y el jasper que esta aqui --->
			<!---
			<cf_jasperreport datasource="#session.DSN#"
					 output_format="html"
					 jasper_file="#LvarArchivo#">
				<cf_jasperparam name="Ecodigo"   value="#session.Ecodigo#">
				<cf_jasperparam name="EOnumero"   value="#rsTipoOC.EOnumero#">
				<cf_jasperparam name="CMTOcodigo"   value="#rsTipoOC.CMTOcodigo#">
				
				<!--- Datos adicionales del Comprador que se ocupan en la OC. --->
				<cf_jasperparam name="PhoneComprador"   	value="#session.datos_personales.oficina#">
				<cf_jasperparam name="FaxComprador"   		value="#session.datos_personales.fax#">
				<cf_jasperparam name="ApartadoComprador"   	value="#session.datos_personales.email2#">
				<cf_jasperparam name="EmailComprador"   	value="#session.datos_personales.email1#">
				<!--- Imprime la fecha y hora de la impresión --->
				<!--- Rodolfo Jiménez Jara, SOIN, 18/08/2004,  --->
				<cf_jasperparam name="FechaHoy"   value="#Now()#">
				<cf_jasperparam name="HoraHoy"   value="#hora_hoy#">
			</cf_jasperreport>
			--->
		</cfif>	
	<cfelse>
		<!--- Si la tipo de transacción de la factura tiene asignado un formato de impresión genera el reporte PDF en pantalla  --->
		<cfif rsTipoOC.RecordCount GT 0>
			<cfset fecha_hoy = DateFormat(now(),'dd/mm/yyyy')>
			<cfset hora_hoy = TimeFormat(now())>
		<cfinclude template="/sif/reportes/#session.Ecodigo#_#rsTipoOC.formato#.cfm">
			<!---<cfset tipoFormato = "/sif/reportes/#session.Ecodigo#_#rsTipoOC.formato#.jasper" >
			<cf_jasperreport datasource="#session.DSN#"
							 output_format="pdf"
							 jasper_file="#tipoFormato#">
				<cf_jasperparam name="Ecodigo"   value="#session.Ecodigo#">
				<cf_jasperparam name="EOnumero"   value="#rsTipoOC.EOnumero#">
				<cf_jasperparam name="CMTOcodigo"   value="#rsTipoOC.CMTOcodigo#">
				
				<!--- Datos adicionales del Comprador que se ocupan en la OC. --->
				<cf_jasperparam name="PhoneComprador"   	value="#session.datos_personales.oficina#">
				<cf_jasperparam name="FaxComprador"   		value="#session.datos_personales.fax#">
				<cf_jasperparam name="ApartadoComprador"   	value="#session.datos_personales.email2#">
				<cf_jasperparam name="EmailComprador"   	value="#session.datos_personales.email1#">
				<!--- Imprime la fecha y hora de la impresión --->
				<!--- Rodolfo Jiménez Jara, SOIN, 18/08/2004,  --->
				<cf_jasperparam name="FechaHoy"   value="#Now()#">
				<cf_jasperparam name="HoraHoy"   value="#hora_hoy#">
			</cf_jasperreport>			--->		
			<cfset bandImpreso = true>
		<cfelse>
			<script>
				alert('No hay Formato de Impresión para esta Solicitud.');
				window.close();
			</script>
		</cfif>
	</cfif>
	<cfif bandImpreso>
		<cfquery datasource="#session.DSN#">
			update EOrdenCM
			set EOImpresion='I'
			where Ecodigo   = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Ecodigo#">
			  and EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EOidorden#">
		</cfquery>	
	</cfif>
</cfif>


