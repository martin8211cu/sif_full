<!--- PROCESO DE del Contrato --->

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_NohayFormato" Default= "No hay Formato de Impresión para esta Solicitud." XmlFile="imprimeContrato.xml" returnvariable="LB_NohayFormato"/>

<cfparam name="url.Ecodigo" default="#Session.Ecodigo#">
<cfset bandImpreso = false>

<cfif isdefined("url.ctcontid") and len(trim(url.ctcontid))>

	<!--- Busca el formato según el tipo de transacción que se le ha asignado --->
	<cfquery name="rsTipoCON" datasource="#Session.DSN#">
		select  a.CTContid, a.CTCnumContrato,rtrim(b.FMT01COD) as formato
		from CTContrato a
			inner join CTTipoContrato b
			ON a.CTTCid = b.CTTCid
                <!--- Se quita el Ecodigo por efectos Intercompany --->
		where a.CTContid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ctcontid#">
	</cfquery>

	<cfif rsTipoCON.recordcount gt 0 and len(trim(rsTipoCON.formato)) >
		<cfquery name="rsFormato" datasource="#session.DSN#">
			select FMT01tipfmt, FMT01cfccfm
			from FMT001
			where (Ecodigo is null or Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Ecodigo#">)
			  and FMT01COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(rsTipoCON.formato)#">
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
							<cfset parametros = parametros & "&CTContid=" & url.ctcontid & "&Ecodigo=" & url.Ecodigo>
							<cfif isdefined("url.primeravez") and len(trim(url.primeravez)) >
								<cfset parametros = parametros & "&primeravez=ok" >
							</cfif>
							<cf_rhimprime datos="#LvarArchivo#" paramsuri="#parametros#">
							<cfinclude template="#LvarArchivo#">
							<br>
	
			</cfif>
			<cfset bandImpreso = true>

		</cfif>
	<cfelse>
		<!--- Si la tipo de transacción de la factura tiene asignado un formato de impresión genera el reporte PDF en pantalla  --->
		<cfif rsTipoCON.RecordCount GT 0>
			<cfset fecha_hoy = DateFormat(now(),'dd/mm/yyyy')>
			<cfset hora_hoy = TimeFormat(now())>
		<cfinclude template="/sif/reportes/#session.Ecodigo#_#rsTipoCON.formato#.cfm">

			<cfset bandImpreso = true>
		<cfelse>
			<script>
				alert('#LB_NohayFormato#');
				window.close();
			</script>
		</cfif>
	</cfif>

</cfif>


