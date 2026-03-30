<cfparam name="lvarSolicitante" default="false">
<!--- Este Script sirve para invocar la nueva ventana --->
<!--- donde se muestran las Cotizaciones generadas. --->
<script language="javascript1.2" type="text/javascript">
	var popUpWin = 0;
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	<cfif isdefined("url.EOidorden") and len(trim(url.EOidorden))>
		<cfoutput>
			function imprimeOrden() {
				var width = 500;
				var height = 200;
				var left = (screen.width-width)/2;
				var top = (screen.height-height)/2;
				var URLStr = "/cfmx/sif/cm/operacion/evaluarCotizacion-resumen.cfm?EOidorden=#url.EOidorden#"
				window.open(URLStr, 'DetalleOrden', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
			}
			imprimeOrden();
		</cfoutput>
	</cfif>
</script>
<cfif isdefined("form.chk") and not isdefined("form.CMPid")>
	<cfset form.CMPid = form.chk >
</cfif>	
<cfif lvarSolicitante>
	<cfset lvarTitulo = "Aprobaci&oacute;n de Cotizaciones(Solicitante)">
<cfelse>
	<cfset lvarTitulo = "Evaluaci&oacute;n de Cotizaciones">
</cfif>
<cf_templateheader title="#lvarTitulo#">
		<cf_web_portlet_start titulo="#lvarTitulo#">
			<cfinclude template="/sif/portlets/pNavegacion.cfm">
			<cfinclude template="evaluarCotConfig.cfm">
            <cfset lvarProcesar = false>
          	<cfif isdefined("form.CMPid") and form.pantalla neq 0>
             <cfquery name="rsCMP" datasource="#Session.DSN#">
                    select CMPestado
                    from CMProcesoCompra
                    where CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMPid#">
                    and Ecodigo = #Session.Ecodigo#
                </cfquery>
                <cfif rsCMP.CMPestado eq '81'>
                	<cfif form.pantalla neq 5>
                   		<cfset form.pantalla = 4>
                    </cfif>
                    <cfset Form.metodo = "L">
                    <cfset lvarProcesar = true>
                </cfif>
            </cfif>
			<cfinclude template="evaluarCotHeader.cfm">
			<cfif isdefined("form.pantalla")>
				<cfswitch expression="#form.pantalla#">
					<cfcase value="0"><cfinclude template="evaluarCotLista.cfm"></cfcase>
					<cfcase value="1">
						<cfif isdefined("Session.Compras.ProcesoCompra")>
							<cfset StructDelete(Session.Compras, "ProcesoCompra")>
						</cfif>
                        <cfif not lvarSolicitante>
							<cfset Regresar = "evaluarCotizaciones.cfm">
                        <cfelse>
                        	<cfset Regresar = "evaluarCotizacionesSolicitante.cfm">
                        </cfif>
                        <cfif lvarSolicitante>
                        	<cfset lvarProcesar = true>
                            <cfset form.metodo = "L">
                        	<cfinclude template="evaluacionProceso.cfm">
                        <cfelse>
							<cfinclude template="compraProceso-importcoti-lista.cfm">
                        </cfif>
					</cfcase>
					<cfcase value="3"><cfinclude template="evaluarCotMetodo.cfm"></cfcase>
					<cfcase value="4"><cfinclude template="evaluacionProceso.cfm"></cfcase>
					<cfcase value="5"><cfinclude template="evaluacionOrden.cfm"></cfcase>
				</cfswitch>
			<cfelse>
				<cf_errorCode	code = "50300" msg = "No está bien definida la pantalla. Acceso Denegado!">
			</cfif>
		<cf_web_portlet_end>
	<cf_templatefooter>
