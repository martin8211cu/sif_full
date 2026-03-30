<!--- Asignacion de valores por form u url --->
<cfif not isdefined("url.tipo") and not isdefined("form.tipo")>
	<cfparam name="form.tipo" default="R">
</cfif>
<cfif isdefined("Url.EDRid") and not isdefined("Form.EDRid")>
	<cfparam name="Form.EDRid" default="#Url.EDRid#">
</cfif>
<cfif isdefined("Url.DOlinea") and not isdefined("Form.DOlinea")>
	<cfparam name="Form.DOlinea" default="#Url.DOlinea#">
</cfif>

<cfset titulo = "Recepci&oacute;n">
<cfif form.tipo eq 'D'>
	<cfset titulo = "Devoluci&oacute;n">
</cfif>

<!--- Obtiene el valor del parámetro de Aprobación de Excesos de Tolerancia por Compradores --->
<cfquery name="rsParametroTolerancia" datasource="#session.dsn#">
	select Pvalor
	from Parametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="760">
</cfquery>
<!--- Obtiene el valor del parámetro para validar los excesos en la recepcion de Documentos --->
<cfquery name="rsParametroExcesos" datasource="#session.dsn#">
	select Pvalor
	from Parametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="15651">
</cfquery>

<cf_templateheader title="Compras">
	<script language="javascript1.2" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Registro de Documentos de <cfoutput>#titulo#</cfoutput>'>
		
		<!--- Establecimiento de los modos (ENC y DET)--->	
		<cfset modo  = 'ALTA'>
		<cfset dmodo = 'ALTA'>
		<cfif isdefined("form.EDRid") and len(trim(form.EDRid))>
			<cfset modo = 'CAMBIO'>
			<cfif isdefined("form.DDRLinea") and len(trim(form.DDRlinea))>
				<cfset dmodo = 'CAMBIO'>
			</cfif>
		</cfif>

		<cfif modo neq 'ALTA'>
			<cfquery name="rsDetalles" datasource="#session.DSN#">
				select * 
				from DDocumentosRecepcion 
				where EDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDRid#">
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>
		</cfif>

		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td colspan="2"><cfinclude template="../../portlets/pNavegacion.cfm"></td>
			</tr>
			
			<form action="documentos-sql.cfm" method = "post" name = "form1" onSubmit="javascript: return valida();" >
				<tr>
					<td>
						<table width="99%" cellpadding="0" cellspacing="0" align="center">
							<tr>
								<td class="subTitulo" align="center"><font size="2">Encabezado de Documentos de <cfoutput>#titulo#</cfoutput></font></td>
							</tr>
							<tr> 
								<td align="center"><cfinclude template="documentosE-form.cfm"></td>
							</tr>
							<!--- ======================================= --->
							<!---  		          Botones				  --->
							<!--- ======================================= --->		
							<tr><td >&nbsp;</td></tr>						
							<!-- Caso 1: Alta de Encabezados -->
							<cfif modo EQ 'ALTA'>
								<tr>
									<td align="center">
										<input type="submit" name="btnAgregarE" value="Agregar" >
										<input type="reset"  name="btnLimpiar"  value="Limpiar">
										<input type="button" name="btnRegresar" value="Regresar" onClick="javascript: funcRegresar()">
									</td>	
								</tr>
							<cfelse>
								<tr>
									<td align="center">
										<!---*******************************************************--->
										<!---*****  Se verficia que el proveedor      			****--->
										<!---*****  tenga activado el bit de cerficacion      	****--->
										<!---*****  si es uno verifica que los articulos      	****--->
										<!---*****  tenga activado el bit de cerficacion        ****--->
										<!---*****  dependiendo de estos resultado activa o no  ****--->
										<!---*****  el boton de Notificar                       ****--->
										<!---*******************************************************--->
										<!---*****             Inicio                 			****--->
										<!---*******************************************************--->
										<cfquery name="rsCertifica" datasource="#Session.DSN#">
											SELECT coalesce(SNcertificado,0) as SNcertificado FROM SNegocios
											where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
												and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsForm.SNcodigo#">
										</cfquery>
										<cfif isdefined("rsCertifica") and rsCertifica.SNcertificado eq 0>
											<cfquery name="rsArtCheck" datasource="#Session.DSN#">
												select a.Aid
												from DDocumentosRecepcion a
													inner join Articulos b
															on a.Aid = b.Aid
															and a.Ecodigo = b.Ecodigo
															and b.Areqcert = 1
												where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
													and a.EDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.EDRid#">
													and a.Aid is not null
													and a.DDRtipoitem = 'A'
											</cfquery>
											<cfif isdefined("rsArtCheck") and rsArtCheck.RecordCount gt 0>
												<input type="submit" name="btnNotificar" class="btnnormal"  value="Notificar">
											</cfif>
										</cfif>
										<!---*******************************************************--->
										<!---*****             FIN                   			****--->
										<!---*******************************************************--->
										<cfif not (rsParametroTolerancia.RecordCount gt 0 and rsParametroTolerancia.Pvalor eq 1 and rsForm.EDRestado eq 5 and form.tipo eq "R")>
												<input type="submit" name="btnModificarE" class="btnGuardar"  value="Modificar">
											<cfif len(trim(rsForm.EPDid)) EQ 0>
												<input type="submit" name="btnBorrarE"    class="btneliminar" value="Borrar Documento" onClick="javascript:if ( confirm('Desea eliminar el Documento?') ){validar=false; return true;} return false;" >
											</cfif>
										</cfif>
										<cfif isdefined("rsDetalles") and rsDetalles.recordCount gt 0>
											<input type="submit" name="btnAplicar"  		class="btnAplicar" value="Aplicar" onClick="javascript:if( confirm('Desea aplicar el Documento?') ){ validar=false; return true;} return false;">
											<input type="button" name="btnReporteReclamos"  class="btnnormal"  value="Reporte de Reclamos" onClick="javascript: imprimeReclamos();">
										</cfif>										
										<input type="button" name="btnRegresar" value="Regresar" class="btnAnterior" onClick="javascript: funcRegresar()">
									</td>
								</tr>
							</cfif>
						</form>
					
						<cfif modo neq "ALTA">
							<tr><td>&nbsp;</td></tr>
							<tr>
								<td class="subTitulo" align="center"><font size="2">Detalle de Documentos de <cfoutput>#titulo#</cfoutput></font></td>
							</tr>
							<tr> 
								<td><cfinclude template="documentosD-form.cfm"></td>
							</tr>
						</cfif>		
					</table>	
				</td>
			</tr>
		</table>
		
		<cf_qforms>
		<script language="javascript1.2" type="text/javascript">
			<cfif isdefined("form.msg")>
				alert("<cfoutput>#form.msg#</cfoutput>");
			</cfif>		
			var validar = true;
			function valida(){				
				if (validar){
					var error = false;
					var mensaje = "Se presentaron los siguientes errores:\n";
					// Validacion de Encabezado	
					if ( trim(document.form1.TDRcodigo.value) == '' ){
						error = true;
						mensaje += " - El campo Tipo es requerido.\n";
					}
					if ( trim(document.form1.Mcodigo.value) == '' ){
						error = true;
						mensaje += " - El campo Moneda es requerido.\n";
					}
					if ( trim(document.form1.EDRtc.value) == '' ){
						error = true;
						mensaje += " - El campo Tipo de Cambio es requerido.\n";
					}
					if ( new Number(qf(document.form1.EDRtc.value)) == 0 ){
						error = true;
						mensaje += " - El campo Tipo de Cambio debe ser mayor que cero.\n";
					}
					if ( trim(document.form1.Aid.value) == '' && trim(document.form1.CFid.value) == ''){
						error = true;
						mensaje += " - Debe seleccionar un Almacén ó un Centro Funcional.\n";
					}
					if ( trim(document.form1.EDRnumero.value) == '' ){
						error = true;
						mensaje += " - El campo Número es requerido.\n";
					}
					if ( trim(document.form1.EDRfechadoc.value) == '' ){
						error = true;
						mensaje += " - El campo Fecha del Documento es requerido.\n";
					}
					if ( trim(document.form1.EDRfecharec.value) == '' ){
						error = true;
						mensaje += " - El campo Fecha de Recepción es requerido.\n";
					}
					if ( trim(document.form1.SNcodigo.value) == '' ){
						error = true;
						mensaje += " - El campo Socio de Negocio es requerido.\n";
					}
					if ( trim(document.form1.EDRreferencia.value) == '' ){
						error = true;
						mensaje += " - El campo Referencia es requerido.\n";
					}
					if ( trim(document.form1.EDRdescpro.value) == '' ){
						error = true;
						mensaje += " - El campo Descuento es requerido.\n";
					}
					if ( trim(document.form1.EDRimppro.value) == '' ){
						error = true;
						mensaje += " - El campo Impuesto es requerido.\n";
					}
	
					if ( error ){
						alert(mensaje);
						return false;
					}
					else {
						document.form1.EDRtc.value = qf(document.form1.EDRtc.value);
						document.form1.EDRtc.disabled = false;
						document.form1.EDRdescpro.value = qf(document.form1.EDRdescpro.value);
						document.form1.EDRimppro.value = qf(document.form1.EDRimppro.value);
						if (window.formatMontos) {
							formatMontos();
						}
						return true;
					}
				}
				else{
					if (window.formatMontos) {
						formatMontos();
					}
					return true;
				}
			}
			
			//Función para regresar a la lista
			function funcRegresar(){				
				location.href = 'documentos-lista.cfm';
			}
			
			function imprimeReclamos(){
				location.href= "repDocumReclamos.cfm?EDRid=<cfoutput>#form.EDRid#</cfoutput>";
			}

			function formatMontos() {
				/*document.form2.DDRcantorigen.value = qf(document.form2.DDRcantorigen.value);
				document.form2.DDRcantrec.value = qf(document.form2.DDRcantrec.value);
				document.form2.DDRpreciou.value = qf(document.form2.DDRpreciou.value);*/
				return true;	
			}			
			
			try{
				_addEvent("document.form1.EDRfechadoc", "onBlur", "asignaTC();");
			} 
			catch(e){}
		</script>
			
	<cf_web_portlet_end>
<cf_templatefooter>