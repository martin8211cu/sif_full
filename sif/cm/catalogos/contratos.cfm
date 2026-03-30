<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init(true)>

<cfif isdefined("url.ECid") and not isdefined('form.ECid')>
	<cfset form.ECid = url.ECid>
</cfif>

<cf_templateheader title="	Compras">

		<script language="javascript1.2" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Registro de Contratos'>

			<!--- establecimiento de los modos (ENC y DET)--->
			<cfset modo  = 'ALTA'>
			<cfset dmodo = 'ALTA'>
			<cfif isdefined("form.ECid") and len(trim(form.ECid)) GT 0>
				<cfset modo = 'CAMBIO'>
				<cfif isdefined("form.DClinea") and len(trim(form.DClinea))>
					<cfset dmodo = 'CAMBIO'>
				</cfif>
			</cfif>

			<table width="100%" border="0" cellspacing="0" cellpadding="0">
            	<tr><td colspan="2"><cfinclude template="../../portlets/pNavegacion.cfm"></td></td></tr>

				<form action="contratos-sql.cfm" method = "post" name = "form1" id="form1" onSubmit="return valida();" style="margin: 0;">
					<tr><td>
						<table width="99%" cellpadding="0" cellspacing="0" align="center">
							<tr><td class="subTitulo" align="center"><font size="2">Encabezado de Contrato</font></td></tr>
							<tr>
								<td align="center"><cfinclude template="contratosE-form.cfm"></td>
							</tr>

							<cfif modo neq "ALTA">
								<tr><td>&nbsp;</td></tr>
								<tr><td class="subTitulo" align="center"><font size="2">Detalle de Contrato</font></td></tr>
								<tr>
									<td><cfinclude template="contratosD-form.cfm"></td>
								</tr>
							</cfif>
							<!--- ============================================================================================================ --->
							<!---  											Botones													           --->
							<!--- ============================================================================================================ --->
							<tr><td >&nbsp;</td></tr>
							<cfif aprobado>
								<tr>
									<td align="center">
										<input tabindex="2" type="button" name="btnCancelar" value="Cancelar" onClick="javascript:validar=false;ColdFusion.Window.show('wCancelar')">
									</td>
								</tr>
							<cfelse>
								<!-- Caso 1: Alta de Encabezados -->
								<cfif modo EQ 'ALTA'>
									<tr>
										<td align="center">
											<input tabindex="2" type="submit" name="btnAgregarE" value="Agregar" >
											<input tabindex="2" type="reset"  name="btnLimpiar"  value="Limpiar" >
										</td>
									</tr>
								</cfif>

								<!-- Caso 2: Cambio de Encabezados / Alta de detalles -->
								<cfif modo neq 'ALTA' and dmodo eq 'ALTA' >
									<tr>
										<td align="center" valign="baseline" colspan="8">
											<input tabindex="2" type="submit" name="btnImportarD" value="Importar" onClick="javascipt: validarD=false;importar();">
											<input tabindex="2" type="submit" name="btnAgregarD"  value="Agregar">
											<input tabindex="2" type="submit" name="btnCambiarE"  value="Cambiar Contrato" onClick="javascipt: validarD=false;">
											<input tabindex="2" type="submit" name="btnBorrarE"   value="Borrar Contrato" onClick="javascript:if ( confirm('Desea eliminar el registro de 	solicitud?') ){validar=false; return true;} return false;" >
											<input tabindex="2" type="reset"  name="btnLimpiar"   value="Limpiar" >
                        	               	<input tabindex="2" type="button" name="btnImprimir"  value="Imprimir " onClick="javascript: funcImprimir();" >
                        	               	<input tabindex="2" type="Submit" name="btnAplicar"   value="Aplicar " onClick="javascript: validarD=false" >
										</td>
									</tr>
								</cfif>

								<!-- Caso 3: Cambio de Encabezados / Cambio de detalle -->
								<cfif modo neq 'ALTA' and dmodo neq 'ALTA' >
									<tr>
										<td align="center" valign="baseline" colspan="8">
											<input tabindex="2" type="submit" name="btnCambiarD" value="Cambiar" >
											<input tabindex="2" type="submit" name="btnBorrarD"  value="Borrar L&iacute;nea" onClick="javascript:if ( confirm('Desea eliminar el registro de 	detalle?') ){validar=false; return true;} return false;" >
											<input tabindex="2" type="submit" name="btnBorrarE"  value="Borrar Contrato" onClick="javascript:if ( confirm('Desea eliminar el registro de 	solicitud?') ){validar=false; return true;} return false;" >
											<input tabindex="2" type="submit" name="btnNuevoD"   value="Nueva L&iacute;nea" onClick="javascript:validar=false;" >
											<input tabindex="2" type="reset"  name="btnLimpiar"  value="Limpiar" >
                        	               	<input tabindex="2" type="button" name="btnImprimir"  value="Imprimir " onClick="javascript: funcImprimir();" >
										</td>
									</tr>
								</cfif>
							</cfif>
							<input type="hidden" name="Motivo" id="Motivo" value="">
							<input type="hidden" name="Cancel" id="Cancel" value="">
							<cfwindow name="wCancelar" center="true" resizable="false" draggable="false" modal="true" height="200" width="360">
								<div align="center">
									<br>
									<label for="mwMotivo">Motivo de la cancelación</label><br>
									<textarea name="mwMotivo" id="mwMotivo" cols="40" rows="5"></textarea>
									<br>
									<input type="button" name="Cancelar" id="Cancelar" value="Cancelar" onClick="javascript: doSubmit();">
								</div>
							</cfwindow>
							<!-- ============================================================================================================ -->
							<!-- ============================================================================================================ -->
						</table>
					</td></tr>
					<tr><td colspan="2">&nbsp;</td></tr>
				</form>

				<tr>
					<td align="center">
						<table width="99%" align="center" ><tr><td>
							<cfif modo neq 'ALTA' >
								<cfset navegacion = "">

								<cfif isdefined("Form.ECid") and Len(Trim(Form.ECid)) NEQ 0>
									<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "ECid=" & Form.ECid>
								</cfif>
								<cfinclude template="../../Utiles/sifConcat.cfm">
								<cfquery datasource="#session.DSN#" name="rsListaContratos">
									select     a.Mcodigo,
													(<cf_dbfunction name="to_char" datasource="#session.DSN#" args="a.Mcodigo"> #_Cat# '-' #_Cat# Mnombre) as Mnombre,
													a.ECid,
													a.DClinea,
													a.DCdescripcion,
													case DCtipoitem when 'A' then 'Artículo' when 'F' then 'Activo Fijo' when 'S' then 'Servicio' end as Tipo,
													case DCtipoitem when 'A' then
																	coalesce((select ART.Acodigo  from  Articulos ART where ART.Ecodigo = a.Ecodigo and ART.Aid = a.Aid),'-')
													 			    when 'S' then
																	coalesce((select CON.Ccodigo  from  Conceptos CON where CON.Ecodigo = a.Ecodigo and CON.Cid = a.Cid),'-')
																	else '-' end as CodigoA,
													DCgarantia,
													#LvarOBJ_PrecioU.enSQL_AS("a.DCpreciou")#
									from DContratosCM a
											inner join EContratosCM b
												on a.Ecodigo = b.Ecodigo
													and a.ECid = b.ECid
											inner join Monedas m
												on a.Ecodigo = m.Ecodigo
													and a.Mcodigo = m.Mcodigo
									where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
										and a.ECid = <cfqueryparam value="#Form.ECid#" cfsqltype="cf_sql_numeric">
									order by Tipo
								</cfquery>

								<cfinvoke
								component="sif.Componentes.pListas"
								method="pListaQuery"
								returnvariable="pListaRet">
									<cfinvokeargument name="query" value="#rsListaContratos#"/>
									<cfinvokeargument name="desplegar" value="Tipo, CodigoA,DCdescripcion, Mnombre, DCgarantia, DCpreciou"/>
									<cfif verifica_Parametro.recordcount GT 0>
										<cfinvokeargument name="etiquetas" value="Tipo, Código, Descripcion, Moneda, Garant&iacute;a, Subtotal"/>
									<cfelse>
										<cfinvokeargument name="etiquetas" value="Tipo, Código, Descripcion, Moneda, Garant&iacute;a, Precio Unitario"/>
									</cfif>
									<cfinvokeargument name="formatos" value="V, V, V, V, M, M"/>
									<cfinvokeargument name="align" value="left, left, left, left, right, right"/>
									<cfinvokeargument name="ajustar" value="N"/>
									<cfinvokeargument name="checkboxes" value="n"/>
									<cfinvokeargument name="navegacion" value="#navegacion#"/>
									<cfinvokeargument name="irA" value="contratos.cfm"/>
									<cfinvokeargument name="showEmptyListMsg" value="true"/>
								</cfinvoke>
							<cfelse>
								<cfif not isdefined('Form.btnNuevo')>
									<cflocation addtoken="no" url='contratos-lista.cfm'>
								</cfif>
							</cfif>
						</table>
					</td>
				</tr>
			</table>

		<script language="javascript1.2" type="text/javascript">
			var validar = true;
			var validarD = true;
			function valida(){
				<cfif modo neq 'ALTA' and verifica_Parametro.recordcount GT 0>
					document.form1.DCcantsurtida.disabled = false;
				</cfif>
				if (validar){
					var error = false;
					var mensaje = "Se presentaron los siguientes errores:\n";
					// Validacion de Encabezado
					if ( trim(document.form1.SNcodigo.value) == '' ){
						error = true;
						mensaje += " - El campo Proveedor es requerido.\n";
					}
					if ( trim(document.form1.ECdesc.value) == '' ){
						error = true;
						mensaje += " - El campo Descripción es requerido.\n";
					}
					if ( trim(document.form1.ECfechaini.value) == '' ){
						error = true;
						mensaje += " - El campo Fecha Inicial es requerido.\n";
					}else{
						if ( trim(document.form1.ECfechafin.value) == '' ){
							error = true;
							mensaje += " - El campo Fecha de Vencimiento es requerido.\n";
						}else{
							var a = document.form1.ECfechaini.value.split("/");
							var ini = new Date(parseInt(a[2], 10), parseInt(a[1], 10)-1, parseInt(a[0], 10));
							var b = document.form1.ECfechafin.value.split("/");
							var fin = new Date(parseInt(b[2], 10), parseInt(b[1], 10)-1, parseInt(b[0], 10));

							if(ini > fin){
								mensaje += " - El campo Fecha de Vencimiento debe ser mayor que la Fecha de Inicio.\n";
								error = true;
							}
						}
					}

					if ( trim(document.form1.CMFPid.value) == '' ){
						error = true;
						mensaje += " - El campo Forma de Pago es requerido.\n";
					}
					if ( trim(document.form1.ECplazocredito.value) == '' ){
						error = true;
						mensaje += " - El campo Plazo Crédito es requerido.\n";
					}
					if ( trim(document.form1.ECporcanticipo.value) == '' ){
						error = true;
						mensaje += " - El campo Porcentaje Anticipo es requerido.\n";
					}

					<cfif modo neq 'ALTA'>
						// VALIDACION POR TIPO DE ITEM
						if (validarD){
							if (document.form1.DCtipoitem.value == 'A'){
								if ( trim(document.form1.Aid.value) == '' ){
									error = true;
									mensaje += " - El campo Artículo es requerido.\n";
								}
							}
							else if(document.form1.DCtipoitem.value == 'S'){
								if ( trim(document.form1.Cid.value) == '' ){
									error = true;
									mensaje += " - El campo Concepto es requerido.\n";
								}
							}
							else{
								if ( trim(document.form1.ACcodigo.value) == '' ){
									error = true;
									mensaje += " - El campo Categoría es requerido.\n";
								}
								if ( trim(document.form1.ACid.value) == '' ){
									error = true;
									mensaje += " - El campo Clasificación es requerido.\n";
								}
							}

							if ( trim(document.form1.DCgarantia.value) == '' ){
								error = true;
								mensaje += " - El campo Garantía es requerido.\n";
							}

							if ( trim(document.form1.DCdescripcion.value) == '' ){
								error = true;
								mensaje += " - El campo Descripcion es requerido.\n";
							}

							if ( trim(document.form1.DCpreciou.value) == '' ){
								error = true;
								mensaje += " - El campo Precio es requerido.\n";
							}

							if ( new Number(qf(document.form1.DCpreciou.value)) == 0 ){
								error = true;
								mensaje += " - El campo Precio debe ser mayor que cero.\n";
							}

							if ( trim(document.form1.Limpuestos.value) == '' ){
								error = true;
								mensaje += " - El campo Impuesto es requerido.\n";
							}
							<cfif verifica_Parametro.recordcount GT 0>
								if(parseFloat(qf(document.form1.DCcantcontrato.value)) < parseFloat(qf(document.form1.DCcantsurtida.value))){
									mensaje += "La cantidad del contrato " + document.form1.DCcantcontrato.value + " no puede ser menor a la cantidad surtida " +  document.form1.DCcantsurtida.value;
									error = true;
								}
							</cfif>
						}
					</cfif>

					if ( error ){
						alert(mensaje);
						return false;
					}
					else{
						<cfif modo neq 'ALTA'>
							document.form1.DCtipoitem.disabled = false;
							document.form1.DCtc.disabled = false;
							document.form1.DCgarantia.value = qf(document.form1.DCgarantia.value);
							document.form1.DCpreciou.value = qf(document.form1.DCpreciou.value);
						</cfif>
						return true;
					}
				}
				else{
					return true;
				}
			}
			function funcImprimir()
			{
				var indice =document.form1.ECid.value;
				window.open('imprimirContrato.cfm?indice='+indice, 'mywindow','location=1, align= absmiddle,status=1,scrollbars=1, top=100, left=100 width=500,height=500');
			}
			function importar() {
				document.form1.action = 'importarDC.cfm';
				document.form1.submit();
			}
	<cfif aprobado EQ true>
		var f = document.forms['form1'];
		for(var i=0,fLen=f.length;i<fLen;i++){
			if(f.elements[i].name != 'mwMotivo'){
  				f.elements[i].readOnly = true;
  				f.elements[i].className += 'cajasinborde';
  			}
  			if (f.elements[i].name == 'AlmObjecto' || f.elements[i].tagName == 'SELECT'){
  				f.elements[i].disabled = true;
  			}
  			if (f.elements[i].name == 'UsuariosAsoc' || f.elements[i].name == 'btnCancelar'){
  				f.elements[i].className = 'btnNormal';
  			}
  			if (f.elements[i].name == 'Cancelar'){
  				f.elements[i].className = 'btnEliminar';
  			}
		}
		function doSubmit() {
		  var Motivo = document.getElementById("Motivo");
		  var mwMotivo = document.getElementById("mwMotivo");
		  var Cancel = document.getElementById("Cancel");
		  var Cancelar = document.getElementById("Cancelar");
		  Motivo.value = mwMotivo.value;
		  Cancel.value = Cancelar.value;
		  document.getElementById("form1").submit();
		}
	</cfif>
		</script>
		<cf_web_portlet_end>
	<cf_templatefooter>