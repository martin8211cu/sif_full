<cfparam name="form.tipo" default="D">

<cf_templateheader title="	Compras">

		<script language="javascript1.2" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Registro de Documentos de Devoluci&oacute;n'>

			<!--- establecimiento de los modos (ENC y DET)--->	
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
            	<tr><td colspan="2"><cfinclude template="../../portlets/pNavegacion.cfm"></td></td></tr>
              	
				<form action="devolucion-sql.cfm" method="post" name="form1" onSubmit="javascript: return valida();" >
					<tr><td>
						<table width="99%" cellpadding="0" cellspacing="0" align="center">
							<tr><td class="subTitulo" align="center"><strong><font size="2">Encabezado de Documentos de Devoluci&oacute;n</font></strong></td></tr>
							<tr> 
								<td align="center">
								<cfset Request.Devoluciones = true>
								<cfinclude template="documentosE-form.cfm">
								</td>
							</tr>
						  
							<cfif modo neq "ALTA">
								<tr><td>&nbsp;</td></tr>
								<tr><td class="subTitulo" align="center"><strong><font size="2">Detalle de Documentos de Devoluci&oacute;n</font></strong></td></tr>
								<tr> 
									<td><cfinclude template="devolucionD-form.cfm"></td>
								</tr>
							</cfif>		
		
							<!--- ============================================================================================================ --->
							<!---  											Botones													           --->
							<!--- ============================================================================================================ --->		
							<tr><td >&nbsp;</td></tr>						
							<!-- Caso 1: Alta de Encabezados -->
							<cfif modo EQ 'ALTA'>
								<tr>
									<td align="center">
										<input type="submit" name="btnAgregarE" value="Agregar" tabindex="1" >
										<input type="reset"  name="btnLimpiar"  value="Limpiar" tabindex="1" >
									</td>	
								</tr>
							</cfif>
							
							<!-- Caso 2: Cambio de Encabezados / Alta de detalles -->
							<cfif modo neq 'ALTA' and dmodo eq 'ALTA' >
								<tr>
									<td align="center" valign="baseline" colspan="8">
										<input type="submit" name="btnModificar"  value="Modificar" tabindex="1">
										<cfif isdefined("rsDetalles") and rsDetalles.recordCount gt 0>
											<input type="submit" name="btnAplicar"  value="Aplicar" onClick="javascript:if( confirm('Desea aplicar el Documento?') ){ validar=false; return true;} return false;" tabindex="1">
										</cfif>
										<input type="submit" name="btnBorrarE"  tabindex="1"  value="Borrar Documento" onClick="javascript:if ( confirm('Desea eliminar el Documento?') ){validar=false; return true;} return false;" >
										<input type="reset"  name="btnLimpiar"   value="Limpiar" tabindex="1" >
									</td>	
								</tr>
							</cfif>
							<!-- ============================================================================================================ -->
							<!-- ============================================================================================================ -->		
						</table>	
					</td></tr>
					<tr><td colspan="2">&nbsp;</td></tr>						
				</form>

				<tr><td>&nbsp;</td></tr>
			</table>
		  
		<script language="javascript1.2" type="text/javascript">
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

					if ( trim(document.form1.EOidorden.value) == '' ){
						error = true;
						mensaje += " - El campo Orden de Compra es requerido.\n";
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
					else{
						document.form1.EDRtc.value = qf(document.form1.EDRtc.value);
						document.form1.EDRtc.disabled = false;
						document.form1.EDRdescpro.value = qf(document.form1.EDRdescpro.value);
						document.form1.EDRimppro.value = qf(document.form1.EDRimppro.value);
						
						return true;
					}
				}
				else{
					return true;
				}	
			}
		</script>	
		<cf_web_portlet_end>
	<cf_templatefooter>