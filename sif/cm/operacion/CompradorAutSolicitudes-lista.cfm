<script language="javascript1.2" type="text/javascript">
	var popUpWin = 0;
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

<cfif isdefined("url.impOrden") and isdefined("url.ESidsolicitud") and len(trim(url.ESidsolicitud))>
	<cfoutput>
		function imprimeOrden() {
			var width = 500;
			var height = 200;
			var left = (screen.width-width)/2;
			var top = (screen.height-height)/2;
			//var URLStr = "/cfmx/sif/cm/operacion/ordenCompra-resumen.cfm?ESidsolicitud=#url.ESidsolicitud#"
			var URLStr = "/cfmx/sif/cm/operacion/ordenCompraSeleccion-resumen.cfm?ESidsolicitud=#url.ESidsolicitud#"
			window.open(URLStr, 'DetalleOrden', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
		}
		imprimeOrden();
	</cfoutput>
</cfif>
</script>

<cf_templateheader title="Solicitudes de Compra ">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Solicitudes de Compra'>
			<cfinclude template="../../portlets/pNavegacionCM.cfm">
            <cfinclude template="../../Utiles/sifConcat.cfm">
			<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
	    		<tr>
      				<td>
						<cfinclude template="CompradorAutSolicitudes-filtroglobal.cfm">
						<cfset navegacion = "">

						<cfif isdefined("form.fCMTScodigo") and len(trim(form.fCMTScodigo)) >
							<cfset navegacion = navegacion & "&fCMTScodigo=#Trim(form.fCMTScodigo)#">
						</cfif>
						<cfif isdefined("form.fCMTSdescripcion") and len(trim(form.fCMTSdescripcion)) >
							<cfset navegacion = navegacion & "&fCMTSdescripcion=#form.fCMTSdescripcion#">
						</cfif>							

						<cfif isdefined("form.fESnumero") and len(trim(form.fESnumero)) >
							<cfset navegacion = navegacion & "&fESnumero=#form.fESnumero#">
						</cfif>

						<cfif isdefined("form.fESnumero2") and len(trim(form.fESnumero2)) >
							<cfset navegacion = navegacion & "&fESnumero2=#form.fESnumero2#">
						</cfif>

						<cfif isdefined("form.fObservaciones") and len(trim(form.fObservaciones)) >
							<cfset navegacion = navegacion & "&fObservaciones=#form.fObservaciones#">
						</cfif>
						<cfif isdefined("Form.CFid_filtro") and len(trim(form.CFid_filtro)) >
							<cfset navegacion = navegacion & "&CFid_filtro=#form.CFid_filtro#">
						</cfif>
						<cfif isdefined("Form.CFcodigo_filtro") and len(trim(form.CFcodigo_filtro)) >
							<cfset navegacion = navegacion & "&CFcodigo_filtro=#form.CFcodigo_filtro#">
						</cfif>
						
						<cfif isdefined("Form.fESfecha") and len(trim(form.fESfecha))>
							<cfset navegacion = navegacion & "&fESfecha=#form.fESfecha#">
						</cfif>
						
						<cfif isdefined("Form.CMSnombre1") and len(trim(form.CMSnombre1))>
							<cfset navegacion = navegacion & "&CMSnombre1=#form.CMSnombre1#">
						</cfif>
						
						<cfif isdefined("Form.CMScodigo1") and len(trim(form.CMScodigo1))>
							<cfset navegacion = navegacion & "&CMScodigo1=#form.CMScodigo1#">
						</cfif>
						
						<cfif isdefined("Form.CMSid1") and len(trim(form.CMSid1))>
							<cfset navegacion = navegacion & "&CMSid1=#form.CMSid1#">
						</cfif>
						
						<!----Verificar si esta encendido el parámetro de múltiples contratos---->
						<cfquery name="rsParametro_MultipleContrato" datasource="#session.DSN#">
							select Pvalor 
							from Parametros 
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
								and Pcodigo = 730 
						</cfquery>
						
						<!----
						<cfif isdefined("rsParametro_MultipleContrato") and rsParametro_MultipleContrato.Pvalor EQ 1>
							<!----Verificar que el usuario logueado sea un usuario autorizador de OC's---->
							<cfquery name="rsUsuario_autorizado" datasource="#session.DSN#"><!---Maxrows="1" = El maxrows es porque aun no se ha indicado si un Usuario puede ser autorizado por mas de 1 comprador---->
								select CMCid from CMUsuarioAutorizado
								where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
									and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
							</cfquery>
							<cfset vnCompradores = valueList(rsUsuario_autorizado.CMCid)>
							<cfif isdefined("session.compras.comprador") and len(trim(session.compras.comprador))>
								<cfset vnCompradores = vnCompradores &','& session.compras.comprador>
							</cfif>
						</cfif>
						----->
						<cfquery name="rsLista" datasource="#session.DSN#">							
							select 	distinct a.ESidsolicitud, EStotalest, a.Ecodigo, a.ESnumero, a.CFid, 
									a.CMSid, a.CMTScodigo, a.SNcodigo, a.Mcodigo, Mnombre,
									a.CMCid, a.CMElinea, a.EStipocambio, a.ESfecha, 
									a.ESobservacion, a.NAP, a.NRP, a.NAPcancel, 
									a.EStotalest, a.ESestado, a.Usucodigo, a.ESfalta, 
									a.Usucodigomod, a.fechamod, a.ESreabastecimiento,
									b.CFdescripcion,
									c.CMTScodigo#_Cat#'-'#_Cat# c.CMTSdescripcion as descripcion,
									c.CMTScompradirecta, 
									case when NRP is not null then 'Rechazada' else '' end as Rechazada
							
							from DSProvLineasContrato d
								inner join DSolicitudCompraCM e
									on d.DSlinea = e.DSlinea
									and d.Ecodigo = e.Ecodigo
									
									inner join ESolicitudCompraCM a
										on e.ESidsolicitud = a.ESidsolicitud
										and e.Ecodigo = a.Ecodigo
										and a.ESestado in (20, 40)
										
										inner join CFuncional b
											on b.CFid = a.CFid
											<!--- Si el usuario logueado es usuario autorizado y NO es un comprador --->
											<!---
											<cfif isdefined("rsUsuario_autorizado") and rsUsuario_autorizado.RecordCount NEQ 0 and not len(trim(session.compras.comprador))>
												and b.CFautoccontrato in (#vnCompradores#)
												or b.CFComprador in (#vnCompradores#)
											<cfelse>
											</cfif>
											--->
											<!--- and b.CFautoccontrato = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.compras.comprador#"> --->
														
										inner join CMTiposSolicitud c 			
											on c.Ecodigo = a.Ecodigo 
											and c.CMTScodigo = a.CMTScodigo
															
										inner join Monedas m
											on a.Ecodigo = m.Ecodigo 
											and a.Mcodigo = m.Mcodigo
							
							where d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								and d.Estado = 0 <!---0= Sin aplicar, 10= Aplicadas--->
								and e.CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.compras.comprador#">
															
							<cfif isdefined("form.fCMTScodigo") and len(trim(form.fCMTScodigo)) >
								and a.CMTScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Trim(form.fCMTScodigo)#">
							</cfif>

							<cfif isdefined("form.fESnumero") and len(trim(form.fESnumero)) and isdefined("form.fESnumero2") and len(trim(form.fESnumero2))>
								and a.ESnumero between <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fESnumero#"> and <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fESnumero2#">
							<cfelseif isdefined("form.fESnumero") and len(trim(form.fESnumero))>
								and a.ESnumero >= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fESnumero#">
							<cfelseif isdefined("form.fESnumero2") and len(trim(form.fESnumero2))>
								and a.ESnumero <= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fESnumero2#">
							</cfif>
			
							<cfif isdefined("form.CFid_filtro") and len(trim(form.CFid_filtro)) >
								and a.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid_filtro#">
							</cfif>
								
							<cfif isdefined("form.fObservaciones") and len(trim(form.fObservaciones)) >
								and upper(ESobservacion) like  upper('%#form.fObservaciones#%')
							</cfif>
			
							<cfif isdefined("Form.fESfecha") and len(trim(Form.fESfecha)) >
								and ESfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fESfecha)#">
							</cfif>
							
							<cfif isdefined("Form.CMSid1") and len(trim(Form.CMSid1)) >
								and a.CMSid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CMSid1#">
							</cfif>
							
							order by descripcion,a.ESnumero
						</cfquery>

						<cfinvoke 
								component="sif.Componentes.pListas"
								method="pListaQuery"
								returnvariable="pListaRet">
							<cfinvokeargument name="query" value="#rsLista#"/>
							<cfinvokeargument name="cortes" value="descripcion"/>
							<cfinvokeargument name="desplegar" value="ESnumero, ESobservacion, CFdescripcion, ESfecha, Mnombre, EStotalest"/>
							<cfinvokeargument name="etiquetas" value="N&uacute;mero, Descripci&oacute;n, Centro Funcional, Fecha, Moneda, Total Estimado"/>
							<cfinvokeargument name="formatos" value="V, V, V, D, V, M"/>
							<cfinvokeargument name="align" value="left, left, left, left, left, right"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="irA" value="CompradorAutDetalle.cfm"/>
							<cfinvokeargument name="botones" value="Aplicar"/>
							<cfinvokeargument name="radios" value="S"/>
							<cfinvokeargument name="showEmptyListMsg" value="true"/>
							<cfinvokeargument name="keys" value="ESidsolicitud"/>
							<cfinvokeargument name="navegacion" value="#navegacion#"/>
						</cfinvoke>
					</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
			</table>
		<cf_web_portlet_end>
	<cf_templatefooter>

<script language="javascript1.2" type="text/javascript">
	var directa = new Object();
	<cfoutput query="rsLista">directa['#rsLista.ESidsolicitud#'] = #rsLista.CMTScompradirecta#;</cfoutput>

	function funcAplicar(){
		var continuar = false;
		var solID = "0";
		if (document.lista.chk) {
			if (document.lista.chk.value) {
				continuar = document.lista.chk.checked;				
				solID = document.lista.chk.value;
			}
			else {
				for (var k = 0; k < document.lista.chk.length; k++) {
					if (document.lista.chk[k].checked) {
						continuar = true;
						solID = document.lista.chk[k].value;						
						break;
					}
				}
			}
			if (!continuar) { 
				alert('Debe seleccionar una solicitud de compra'); 			
				return false;
			}
			else{
				document.lista.action = 'CompradorAutDetalle-aplicar.cfm?ESidsolicitud='+solID;				
				return true;
			}
		}
		else {
			alert('No existen solicitudes de compra')
			return false;
		}		
	}
</script>

