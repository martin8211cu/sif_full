<!---Define el Modo--->
<cfset MODOCAMBIO = isdefined("Session.Compras.Configuracion.CMTScodigo") and len(trim(Session.Compras.Configuracion.CMTScodigo))>
<!---Consultas--->
<!---Formatos de Impresión--->
<cfquery name="rsFormatoSolicitud" datasource="#session.DSN#">
	select FMT01COD, FMT01DES, FMT01TIP
	from FMT001
	where (Ecodigo is null or Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
	  and FMT01TIP in (9,11)
	order by FMT01DES
</cfquery>

<!---Consultas del Modo Cambio--->
<cfif MODOCAMBIO>
	<!---Tipo de Solicitud Modo Cambio--->
	<cfquery name="data" datasource="#session.DSN#">
		select CMTScodigo, CMTSdescripcion, Mcodigo, CMTSmontomax, id_tramite,
			CMTStarticulo, CMTSaInventario, CMTSconRequisicion,
			CMTSservicio, CMTSactivofijo, CMTSobras, CMTScompradirecta, FMT01COD, ts_rversion,
            CMTSempleado, CMTSaprobarsolicitante, CMTScontratos
		from CMTiposSolicitud
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and CMTScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Compras.Configuracion.CMTScodigo#">
	</cfquery>
	<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp="#data.ts_rversion#" returnvariable="ts"/>

	<!--- Query para saber si hay alguna solicitud en proceso de publicacion con este tipo de solicitud ---->
	<cfquery name="rsLineasPublicacion" datasource="#session.DSN#">
		select count(c.CMTScodigo) as contador
		from CMLineasProceso a
			inner join DSolicitudCompraCM b
				on a.ESidsolicitud = b.ESidsolicitud
				and a.DSlinea = b.DSlinea

			inner join ESolicitudCompraCM c
				on b.ESidsolicitud = c.ESidsolicitud
				and b.Ecodigo = c.Ecodigo
		where  b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and CMTScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Compras.Configuracion.CMTScodigo#">
	</cfquery>
</cfif>

<!---Tramites--->
<cfinvoke component="sif.Componentes.Workflow.plantillas" method="CrearPkg" returnvariable="WfPackage">
	<cfinvokeargument name="PackageBaseName" value="CM"/>
</cfinvoke>

<cfif isdefined('data') and Len(data.id_tramite)>
	<cfquery name="rsVersionTipo" datasource="#session.DSN#"><!---Versión de trámite del tipo de solicitud---->
		select upper(Name) as upper_name
		from WfProcess
		where WfProcess.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and ProcessId =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.id_tramite#">
	</cfquery>
	<!----Obtener la última versión del trámite---->
	<cfif isdefined("rsVersionTipo") and len(trim(rsVersionTipo.upper_name))>
		<cfquery name="rsUltimaVersion" datasource="#session.DSN#">
			select max(ProcessId) as ProcessId
			from WfProcess
			where WfProcess.Ecodigo     = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and upper(WfProcess.Name) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsVersionTipo.upper_name#">
		</cfquery>
		<cfif isdefined("rsUltimaVersion") and rsUltimaVersion.recordcount GT 0 and len(rsUltimaVersion.ProcessId)>
			<cfset vnTramite = rsUltimaVersion.ProcessId>
		</cfif>
	</cfif>
</cfif>

<!----Obtener lista de trámites---->
<cfquery name="rsProcesos" datasource="#Session.DSN#">
	select ProcessId, Name, upper(Name) as upper_name, PublicationStatus
	from WfProcess
	where WfProcess.Ecodigo = #session.Ecodigo#
		and (PackageId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#WfPackage.PackageId#">
		and PublicationStatus = 'RELEASED'
		<!----
		<cfif isdefined('data') and Len(data.id_tramite)>
			or ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.id_tramite#">
		</cfif>
		----->
		)
	order by upper_name
</cfquery>


<!---Utilidades de Montos y Números--->
<script language="JavaScript" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
<!---QFORMS--->
<script language="JavaScript" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/JavaScript">
	<!--//
		// specify the path where the "/qforms/" subfolder is located
		qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
		// loads all default libraries
		qFormAPI.include("*");
	//-->
</script>
<!---Pintado del Form--->
<form name="form1" action="CompraConfig-Paso1-sql.cfm" method="post" onSubmit="javascript:if (window._finalizarform) _finalizarform(); return validar()" style="margin:0;">
<cfoutput>
<table border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td>
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td nowrap><strong>C&oacute;digo&nbsp;:&nbsp; </strong></td>
					<td><input type="text" name="CMTScodigo" size="5" maxlength="5" value="<cfif MODOCAMBIO>#data.CMTScodigo#</cfif>" onFocus="this.select();" tabindex="1"></td>
				</tr>
				<tr>
					<td nowrap><strong>Descripci&oacute;n&nbsp;:&nbsp; </strong></td>
					<td><input type="text" name="CMTSdescripcion" size="60" maxlength="80" value="<cfif MODOCAMBIO>#data.CMTSdescripcion#</cfif>" onFocus="this.select();" tabindex="1"></td>
				</tr>
				<tr>
					<td nowrap><strong>Moneda&nbsp;:&nbsp; </strong></td>
					<td><cfif MODOCAMBIO><cf_sifmonedas query="#data#" tabindex="1"><cfelse><cf_sifmonedas tabindex="1"></cfif></td>
				</tr>
				<tr>
					<td nowrap><strong>Monto M&aacute;ximo&nbsp;:&nbsp; </strong></td>
					<td>
						<table border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td><input type="text" name="CMTSmontomax" size="20" value="<cfif MODOCAMBIO>#LSCurrencyFormat(data.CMTSmontomax,'none')#<cfelse>0.00</cfif>" style="text-align:right;" onBlur="javascript:fm(this,2);" onFocus="javascript:this.value=qf(this); this.select();" onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" tabindex="1"></td>
								<cfif MODOCAMBIO>
								<td>&nbsp;&nbsp;&nbsp;</td>
								<td><input type="submit" name="AplicarMonto" value="Aplicar Monto a Centros Funcionales" onClick="javascript: deshabilitarValidacion();" tabindex="3"></td>
								</cfif>
								<td>&nbsp;</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td nowrap><strong>Tr&aacute;mite:</strong></td>
					<td>
						<select name="id_tramite" tabindex="1">
							<option value="">(Ninguno)</option>
							<cfloop query="rsProcesos">
								<option value="#rsProcesos.ProcessId#"
								<!----<cfif MODOCAMBIO and rsProcesos.ProcessId eq data.id_tramite>	---->
								<cfif MODOCAMBIO>
									<cfif isdefined("vnTramite") and rsProcesos.ProcessId eq vnTramite>
										selected
									<cfelseif  rsProcesos.ProcessId eq data.id_tramite>
										selected
									</cfif>
								</cfif>>#rsProcesos.upper_name#</option>
							</cfloop>
						</select>
					</td>
				</tr>
				<tr>
					<td nowrap><strong>Formato Impresi&oacute;n:</strong></td>
					<td nowrap>
						<select name="FMT01COD" tabindex="1">
							<option value=""></option>
							<cfloop query="rsFormatoSolicitud">
								<option value="#rsFormatoSolicitud.FMT01COD#" <cfif MODOCAMBIO and data.FMT01COD eq rsFormatoSolicitud.FMT01COD>selected</cfif> >#rsFormatoSolicitud.FMT01DES#</option>
							</cfloop>
						</select>
					</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td><input type="checkbox" name="CMTScompradirecta" id="CMTScompradirecta"
						value="<cfif MODOCAMBIO>
									#data.CMTScompradirecta#
							   </cfif>"
							   <cfif MODOCAMBIO and data.CMTScompradirecta EQ "1">checked</cfif>
							   <cfif MODOCAMBIO and rsLineasPublicacion.contador NEQ 0>disabled</cfif>
					    tabindex="1"><label for="CMTScompradirecta"><strong>Compra Directa</strong></label></td>
				</tr>
                <!---Registrar Empleado --->
				<tr><!---							   <cfif MODOCAMBIO and rsLineasPublicacion.contador NEQ 0>disabled</cfif>
--->
					<td>&nbsp;</td>
					<td><input type="checkbox" name="CMTSempleado" id="CMTSempleado"
						value="<cfif MODOCAMBIO>
									#data.CMTSempleado#
							   </cfif>"
							   <cfif MODOCAMBIO and data.CMTSempleado EQ "1">checked</cfif>
					    tabindex="1"><label for="CMTSempleado"><strong>Registrar Empleado</strong></label></td>
				</tr>
                <tr><!---							   <cfif MODOCAMBIO and rsLineasPublicacion.contador NEQ 0>disabled</cfif>
--->
					<td>&nbsp;</td>
					<td><input type="checkbox" name="CMTSaprobarsolicitante" id="CMTSaprobarsolicitante"
						value="<cfif MODOCAMBIO>
									#data.CMTSaprobarsolicitante#
							   </cfif>"
							   <cfif MODOCAMBIO and data.CMTSaprobarsolicitante EQ "1">checked</cfif>
					    tabindex="1"><label for="CMTSaprobarsolicitante"><strong>Cotizaciones Aprobadas por Solicitante</strong></label></td>
				</tr>
			</table>
		</td>
    <td valign="top" width="1%">
			<fieldset><legend>Tipos Compra</legend>
				<table border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td>&nbsp;</td><td nowrap>
							<input type="checkbox" name="CMTSarticulo" id="CMTSarticulo" value="1" <cfif MODOCAMBIO and data.CMTStarticulo EQ "1">checked</cfif> tabindex="1"
								onclick="
									if (!this.checked){
										document.getElementById('tblTipoArticulo').style.display ='none';
									} else {
										document.getElementById('tblTipoArticulo').style.display ='block';
									}
									if (this.checked && !document.getElementById('CMTSaInventario').checked && !document.getElementById('CMTSconRequisicionChk').checked)
									{
										document.getElementById('CMTSaInventario').checked=true;
										document.getElementById('CMTSconRequisicionChk').checked=true;
									} else if (document.getElementById('CMTSaInventario').checked || document.getElementById('CMTSconRequisicionChk').checked){
										document.getElementById('CMTSaInventario').checked=false;
										document.getElementById('CMTSconRequisicionChk').checked=false;
									}
								"
							>
							<strong>Art&iacute;culo&nbsp;de&nbsp;Inventario</strong>
							<!--- <cfdump var=#form#> --->
							<table id="tblTipoArticulo" <cfif not IsDefined("form.CMTStarticulo") || form.CMTStarticulo eq  "<img border='0' src='/cfmx/sif/imagenes/unchecked.gif'>"> style="display:none" </cfif> >
								<tr>
									<td style="font-size:10px">
										&nbsp;&nbsp;&nbsp;
										<cfif isdefined("data.CMTSaInventario")>
											<cfset LvarCMTSaInventario = data.CMTSaInventario>
										<cfelse>
											<cfset LvarCMTSaInventario = 0>
										</cfif>
										<input type="checkbox" value="1" name="CMTSaInventario" id="CMTSaInventario" <cfif LvarCMTSaInventario NEQ 0> checked </cfif> style="border:none;"
											onclick="if (!this.checked) document.getElementById('CMTSconRequisicionChk').checked=true;"
										/>
									</td>
									<td style="font-size:10px">
										Entrada&nbsp;al&nbsp;Almacén
									</td>
								</tr>
								<tr>
									<td style="font-size:10px">
										&nbsp;&nbsp;&nbsp;
										<cfif isdefined("data.CMTSconRequisicion")>
											<cfset LvarCMTSconRequisicion = data.CMTSconRequisicion>
										<cfelse>
											<cfset LvarCMTSconRequisicion = 0>
										</cfif>
										<input type="checkbox"  value="1" name="CMTSconRequisicionChk" id="CMTSconRequisicionChk" <cfif LvarCMTSconRequisicion NEQ 0> checked </cfif> style="border:none"
											onclick="if (!this.checked) document.getElementById('CMTSaInventario').checked=true;"
										/>
									</td>
									<td style="font-size:10px">
										Con&nbsp;Requisición y
									</td>
								</tr>
								<tr>
									<td style="font-size:10px">
									</td>
									<td style="font-size:10px">
										<select style="font-size:10px" name="CMTSconRequisicion" id="CMTSconRequisicion">
											<option value="1"<cfif LvarCMTSconRequisicion EQ 1> selected</cfif>>Entrada al Gasto</option>
<!---										NO SE HA IMPLEMENTADO
											<option value="2"<cfif LvarCMTSconRequisicion EQ 2> selected</cfif>>Entrada al Almacén</option>
--->
										</select>
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr><td>&nbsp;</td><td nowrap><input type="checkbox" name="CMTSactivofijo"  value="1" <cfif MODOCAMBIO and data.CMTSactivofijo EQ "1">checked</cfif> tabindex="1"><strong>Activo Fijo</strong></td></tr>
					<tr><td>&nbsp;</td><td nowrap><input type="checkbox" name="CMTSservicio" 	value="1" <cfif MODOCAMBIO and data.CMTSservicio EQ "1">checked</cfif> tabindex="1"><strong>Servicio</strong></td></tr>
					<tr><td>&nbsp;</td><td nowrap><input type="checkbox" name="CMTSobras" 		value="1" <cfif MODOCAMBIO and data.CMTSobras EQ "1">checked</cfif> tabindex="1"><strong>Obras en Contrucción</strong></td></tr>
					<tr><td>&nbsp;</td><td nowrap><input type="checkbox" name="CMTScontratos" 	value="1" <cfif MODOCAMBIO and data.CMTScontratos EQ "1">checked</cfif> tabindex="1"
					onclick="
					if(this.checked){
						document.getElementById('CMTScompradirecta').checked=true;
						document.getElementById('CMTScompradirecta').addEventListener('click', function(){event.stopPropagation();});
					}"><strong>Contratos</strong></td></tr>
				</table>
			</fieldset>
		</td>
		<td width="1%">&nbsp;&nbsp;&nbsp;</td>
  </tr>
</table>
<br>
<cfif MODOCAMBIO>
	<input type="hidden" name="ts_rversion" value="#ts#">
	<input type="hidden" name="xCMTScodigo" value="#data.CMTScodigo#">
	<cf_botones values="<< Anterior,Eliminar,Guardar,Guardar y Continuar >>" names="Anterior, Baja, Cambio, CambioEsp" tabindex="2">
<cfelse>
	<cf_botones values="<< Anterior,Agregar,Agregar y Continuar >>" names="Anterior, Alta, AltaEsp" tabindex="2">
</cfif>
</form>
</cfoutput>
<!---Validaciones con QFORMS, Otras Validaciones y Funciones en General--->
<script language="JavaScript" type="text/javascript">
	<!--//
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

//************************************************
	//Funcion para validar que se haya chequeado
	function validar(){
		var va_chequeo;
		if (!document.form1.CMTSarticulo.checked & !document.form1.CMTSactivofijo.checked & !document.form1.CMTSservicio.checked & !document.form1.CMTSobras.checked & !document.form1.CMTScontratos.checked){
			alert('Debe seleccionar el tipo de compra');
			return false;
		}
		else{
			return true;
		}
	}
//************************************************

	objForm.CMTScodigo.description="Código";
	objForm.CMTSdescripcion.description="Descripción";

	function habilitarValidacion(){
		objForm.CMTScodigo.required = true;
		objForm.CMTSdescripcion.required = true;
	}

	function deshabilitarValidacion(){
		objForm.CMTScodigo.required = false;
		objForm.CMTSdescripcion.required = false;
	}

	function eliminar(){
		document.form1.accion.value = 'delete';
		return confirm('Desea eliminar el registro?');
	}

	function _finalizarform() {
		document.form1.CMTSmontomax.value = qf(document.form1.CMTSmontomax.value);
	}

	function _iniciarform(){
		objForm.CMTScodigo.obj.focus();
		habilitarValidacion();
	}

	_iniciarform();

	//-->
</script>