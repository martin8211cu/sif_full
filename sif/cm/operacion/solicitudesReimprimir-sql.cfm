<!--- Si la tipo de transacción de la factura tiene asignado un formato de impresión genera el reporte PDF en pantalla  --->
<cfquery name="rsTipoSolicitud" datasource="#Session.DSN#">
	select a.ESnumero, a.CMSid, rtrim(b.FMT01COD) as formato, a.Ecodigo
	from ESolicitudCompraCM a 
		 inner join CMTiposSolicitud b
			on <!--- a.Ecodigo = b.Ecodigo 
			and  ---> a.CMTScodigo = b.CMTScodigo 
	where a.ESidsolicitud = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ESidsolicitud#">
</cfquery> 
<cfif rsTipoSolicitud.RecordCount GT 0>
	<cfquery datasource="#session.DSN#">
		update ESolicitudCompraCM
		set ESImpresion='R'
		where ESidsolicitud = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ESidsolicitud#">
	</cfquery>

	<cfquery name="rsFormato" datasource="#session.DSN#">
		select FMT01tipfmt, FMT01cfccfm
		from FMT001
		where (Ecodigo is null or Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsTipoSolicitud.Ecodigo#">)
		  and FMT01COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(rsTipoSolicitud.formato)#">
	</cfquery>
	<cfif rsFormato.FMT01tipfmt eq 1 >
		<cfset LvarArchivo = trim(rsFormato.FMT01cfccfm) >
		<cfinclude template="../../Utiles/validaUri.cfm">
		<cfset LvarOk = validarUrl( trim(rsFormato.FMT01cfccfm) ) >
		<cfif not LvarOK ><cf_errorCode	code = "50274"
		                  				msg  = "No existe el archivo indicado para el formato estático: @errorDat_1@"
		                  				errorDat_1="#LvarSPhomeuri#"
		                  ></cfif>
	</cfif>  
	
	<cfif isdefined("LvarArchivo") >
   			<cfif not isdefined('PC')>
			<cf_templateheader title="#Request.Translate('LB_ComprasSolicitudesCompra','Compras - Solicitudes de Compra','/sif/cm/Generales.xml')#">
				<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Solicitudes de Compra'>
					<cfinclude template="../../portlets/pNavegacion.cfm">
			</cfif>
					<cfset parametros = "">
					<cfif isdefined("rsTipoSolicitud.ESnumero") and len(trim(rsTipoSolicitud.ESnumero))>
						<cfset parametros = parametros & "&Ecodigo=" & rsTipoSolicitud.Ecodigo&"&ESnumero=" & rsTipoSolicitud.ESnumero & "&CMSid=" & rsTipoSolicitud.CMSid>
					</cfif>
	
					<cf_rhimprime datos="#LvarArchivo#" paramsuri="#parametros#"> 
					<!---<cfinclude template= "/sif/reportes/1_SOLRapida .cfm">
					<cfinclude template= "/sif/reportes/1_SOLorden  .cfm">--->
					<cfinclude template="#LvarArchivo#">					
					
					<br>
                    <cfif not isdefined('PC')>
					<DIV align="center"><input name="btnRegresar" type="button" value="Regresar" onClick="javascript:location.href='solicitudes-reimprimir.cfm'" ></DIV>
					</cfif>
                    <br>	
                <cfif not isdefined('PC')>				
				<cf_web_portlet_end>
			<cf_templatefooter>
            </cfif>
	<cfelse>
		<cfif isdefined ('rsTipoSolicitud.formato') and rsTipoSolicitud.formato NEQ "">	
			<cfset tipoFormato = "/sif/reportes/#session.Ecodigo#_#rsTipoSolicitud.Formato#.cfm" >
			<cfset fecha_hoy = DateFormat(now(),'dd/mm/yyyy')>
			<cfset hora_hoy = TimeFormat(now())>
			<cfinclude template= "/sif/reportes/#session.Ecodigo#_#rsTipoSolicitud.Formato#.cfm">
		<cfelse>
			<cfthrow message="No hay un formato de Impresión para esta Solicitud">
		</cfif>
	<!---	<cf_jasperreport datasource="#session.DSN#"
						 output_format="html"
						 debug="false"
						 jasper_file="#tipoFormato#">
			<cf_jasperparam name="Ecodigo" value="#session.Ecodigo#">
			<cf_jasperparam name="ESnumero" value="#rsTipoSolicitud.ESnumero#">
			<cf_jasperparam name="CMSid" value="#rsTipoSolicitud.CMSid#">
			<!--- Imprime la fecha y hora de la impresión --->
			<!--- Rodolfo Jiménez Jara, SOIN, 18/08/2004,  --->
			<!---<cf_jasperparam name="FechaHoy"   value="#CreateDateTime(1997,11,21,08,09,15)#">--->
			<cf_jasperparam name="FechaHoy"   value="#fecha_hoy#">
			<cf_jasperparam name="HoraHoy"   value="#hora_hoy#">
		</cf_jasperreport>--->
	</cfif><!---- FIN de si hay ruta para ejecutar HTML ----->
<cfelse>
	<script>alert('No hay Formato de Impresión para esta Solicitud.');</script>
</cfif>

<!-----<form action="solicitudes-reimprimir.cfm" method="post" name="sql"></form>
<html><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></html>
---->



