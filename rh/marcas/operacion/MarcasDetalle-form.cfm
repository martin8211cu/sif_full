<cfif isdefined("Form.RHDMid") and Len(Trim(Form.RHDMid))>
	<cfset modo = "CAMBIO">
<cfelse>
	<cfset modo = "ALTA">
</cfif>

<!--- Verificacion de si el usuario actual tiene derechos para generar incidencias --->
<cfquery name="rsPermisoGenIncidencia" datasource="#Session.DSN#">
	select 1
	from DatosEmpleado a, LineaTiempo lt, RHPlazas r, RHProcesamientoMarcas b, RHUsuariosMarcas um
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
	and a.Ecodigo = lt.Ecodigo
	and a.DEid = lt.DEid
	and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between lt.LTdesde and lt.LThasta
	and lt.Ecodigo = r.Ecodigo
	and lt.RHPid = r.RHPid
	and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and b.RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPMid#">
	and b.Ecodigo = r.Ecodigo
	and b.CFid = r.CFid
	and b.Ecodigo = um.Ecodigo
	and b.CFid = um.CFid
	and um.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
	and um.RHUMgincidencias = 1
</cfquery>

<cfif rsPermisoGenIncidencia.recordCount GT 0>
	<!--- Generar Automaticamente los registros si no hay ninguno --->
	<cfif isdefined("Form.GenDetalle") and Form.GenDetalle EQ 1>
 		<cfquery name="rsCount" datasource="#Session.DSN#">
			select count(1) as cant
			from RHDetalleIncidencias a
			where a.RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPMid#">
			and a.RHCMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCMid#">
		</cfquery>
		
		<!----**************************************************************------>
		<!---- ====== Se cambió para que se ejecute en el SQL de las marcas ========
		<cfif rsCount.cant EQ 0>
			<!--- Agrega incidencias positivas cuando existen excepciones de jornada --->
			<cfinclude template="verificaExcepciones.cfm"> 
			<cfinclude template="GenerarDetalle.cfm">
  </cfif>
		<cfinclude template="modificaResultado.cfm">
		------>
		<!----**************************************************************------>
</cfif>

	<cfquery name="rsEmpleado" datasource="#Session.DSN#">
		select a.DEid, 
			   a.NTIcodigo, 
			   a.DEidentificacion, 
			   a.DEnombre, 
			   a.DEapellido1, 
			   a.DEapellido2, 
			   n.NTIdescripcion
		from DatosEmpleado a, NTipoIdentificacion n
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
		and a.NTIcodigo = n.NTIcodigo
	</cfquery>
	<cfquery name="rsMarca" datasource="#Session.DSN#">
		select a.RHCMid, a.RHPMid, a.RHASid, a.DEid, a.RHCMfregistro, a.RHCMfcapturada, a.RHCMtiempoefect, a.RHJid, 
			   a.RHCMhoraentrada, a.RHCMhorasalida, a.RHCMhoraentradac, a.RHCMhorasalidac, a.RHCMusuario, 
			   a.RHCMjustificacion, a.RHCMusuarioautor, coalesce(a.RHCMhorasadicautor, 0.00) as RHCMhorasadicautor, coalesce(a.RHCMhorasrebajar, 0.00) as RHCMhorasrebajar, a.RHCMdialibre, 
			   a.RHCMinconsistencia, a.BMUsucodigo, a.BMfecha, a.BMfmod, a.ts_rversion,
			   b.RHJdescripcion,
			   (case when c.RHASid is not null then 
			   		{fn concat(rtrim(c.RHAScodigo),{fn concat(' - ',c.RHASdescripcion)})}
				else '' end) as AccionSeguir
		from RHControlMarcas a 
			inner join RHJornadas b
				on a.RHJid = b.RHJid
				and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			left outer join RHAccionesSeguir c
				on a.RHASid = c.RHASid
				and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		where a.RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPMid#">
			and a.RHCMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCMid#">
			and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">			
	</cfquery>
	
	<cfif modo EQ "CAMBIO">
		<cfquery name="rsDetalleIncidencia" datasource="#Session.DSN#">
			select a.RHDMid, coalesce(a.RHDMhorascalc, 0.00) as RHDMhorascalc, coalesce(a.RHDMhorasautor, 0.00) as RHDMhorasautor, a.ts_rversion,
				   b.CIid, b.CIcodigo, b.CIdescripcion, b.CInegativo
			from RHDetalleIncidencias a, CIncidentes b
			where a.RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPMid#">
			and a.RHCMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCMid#">
			and a.RHDMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHDMid#">
			and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and a.CIid = b.CIid
		</cfquery>
	</cfif>
	
	<cfquery name="rsDisponiblePos" datasource="#Session.DSN#">
		select coalesce(a.RHCMhorasadicautor, 0.00) - 
				(select coalesce(sum(b.RHDMhorasautor), 0.00)
				 from RHDetalleIncidencias b, CIncidentes c
				 where a.RHCMid = b.RHCMid
				 and a.RHPMid = b.RHPMid
				 and b.CIid = c.CIid
				 and c.CInegativo = 1
				 <cfif modo EQ "CAMBIO">
				 and b.RHDMid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHDMid#">
				 </cfif>
				) as total
		from RHControlMarcas a 
		where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
		and a.RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPMid#">
		and a.RHCMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCMid#">
	</cfquery>

	<cfquery name="rsDisponibleNeg" datasource="#Session.DSN#">
		select coalesce(a.RHCMhorasrebajar, 0.00) - 
				(select coalesce(sum(b.RHDMhorasautor), 0.00)
				 from RHDetalleIncidencias b, CIncidentes c
				 where a.RHCMid = b.RHCMid
				 and a.RHPMid = b.RHPMid
				 and b.CIid = c.CIid
				 and c.CInegativo = -1
				 <cfif modo EQ "CAMBIO">
				 and b.RHDMid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHDMid#">
				 </cfif>
				) as total
		from RHControlMarcas a 
		where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
		and a.RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPMid#">
		and a.RHCMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCMid#">
	</cfquery>

	<cfset filtro = "">
	
	<SCRIPT language="javascript" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js"></SCRIPT>
	<SCRIPT language="javascript" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
	<script language="javascript" type="text/javascript">
		// specify the path where the "/qforms/" subfolder is located
		qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
		// loads all default libraries
		qFormAPI.include("*");
		
		function regresar() {
			document.goControl.submit();
		}
		
	</script>
	
	<!----=================== TRADUCCION ======================----->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_no_puede_ser_cero"
		Default=" no puede ser cero"	
		returnvariable="MSG_no_puede_ser_cero"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_Las_horas_autorizadas_no_pueden_ser_mayor_a"
		Default="Las horas autorizadas no pueden ser mayor a"	
		returnvariable="MSG_Las_horas_autorizadas_no_pueden_ser_mayor_a"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_Las_horas_a_rebajar_no_pueden_ser_mayor_a"
		Default="Las horas a rebajar no pueden ser mayor a"	
		returnvariable="MSG_Las_horas_a_rebajar_no_pueden_ser_mayor_a"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_Concepto_de_Incidencia"
		Default="Concepto de Incidencia"	
		returnvariable="MSG_Concepto_de_Incidencia"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_Horas_Autorizadas"
		Default="Horas Autorizadas"	
		returnvariable="MSG_Horas_Autorizadas"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Concepto_de_Incidencias"
		Default="Concepto de Incidencias"	
		returnvariable="LB_Concepto_de_Incidencias"/>	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Signo"
		Default="Signo"	
		returnvariable="LB_Signo"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Horas_Autorizadas"
		Default="Horas Autorizadas"	
		returnvariable="LB_Horas_Autorizadas"/>
	
	<cfoutput>
	  <cfinclude template="../../expediente/consultas/frame-infoEmpleado.cfm">
		<form name="goControl" method="post" action="Marcas.cfm" style="margin: 0; ">
			<input type="hidden" name="RHPMid" value="#Form.RHPMid#">
			<input type="hidden" name="RHCMid" value="#Form.RHCMid#">
			<input type="hidden" name="DEid" value="#Form.DEid#">
		</form>
		
		<table width="98%"  border="0" cellspacing="0" cellpadding="0" align="center">
		  <tr>
			<td>&nbsp;
			</td>
		  </tr>
		  <tr>
			<td>&nbsp;</td>
		  </tr>
		  <tr>
			<td>
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td width="50%" rowspan="2" valign="top" style="padding-right: 10px; ">
						<table width="100%" border="0" cellspacing="0" cellpadding="2" style="border: 1px solid black;">
						  <tr>
							<td class="tituloAlterno" colspan="4" align="center" style="border-bottom: 1px solid black;" nowrap><cf_translate key="LB_Datos_de_marca">Datos de Marca</cf_translate></td>
						  </tr>
						  <tr>
							<td class="fileLabel" align="right" nowrap><cf_translate key="LB_Fecha_de_Captura">Fecha de Captura:</cf_translate></td>
							<td nowrap>#LSDateFormat(rsMarca.RHCMfcapturada, 'dd/mm/yyyy')#</td>
							<td class="fileLabel" align="right" nowrap><cf_translate key="LB_Fecha_de_Marca">Fecha de Marca:</cf_translate></td>
							<td nowrap><cfif Len(Trim(rsMarca.RHCMfregistro))>#LSDateFormat(rsMarca.RHCMfregistro, 'dd/mm/yyyy')#</cfif></td>
						  </tr>
						  <tr>
							<td class="fileLabel" align="right" nowrap><cf_translate key="LB_Hora_Entrada">Hora Entrada:</cf_translate></td>
							<td nowrap>#LSTimeFormat(rsMarca.RHCMhoraentradac, 'hh:mm tt')#</td>
							<td class="fileLabel" align="right" nowrap><cf_translate key="LB_Marca_Entrada">Marca Entrada:</cf_translate></td>
							<td nowrap><cfif Len(Trim(rsMarca.RHCMhoraentrada))>#LSTimeFormat(rsMarca.RHCMhoraentrada, 'hh:mm tt')#</cfif></td>
						  </tr>
						  <tr>
							<td class="fileLabel" align="right" nowrap><cf_translate key="LB_Hora_Salida">Hora Salida:</cf_translate></td>
							<td nowrap>#LSTimeFormat(rsMarca.RHCMhorasalidac, 'hh:mm tt')#</td>
							<td class="fileLabel" align="right" nowrap><cf_translate key="LB_Marca_Salida">Marca Salida:</cf_translate></td>
							<td nowrap><cfif Len(Trim(rsMarca.RHCMhorasalida))>#LSTimeFormat(rsMarca.RHCMhorasalida, 'hh:mm tt')#</cfif></td>
						  </tr>
						  <tr>
							<td align="right" nowrap class="fileLabel"><cf_translate key="LB_Jornada">Jornada:</cf_translate></td>
							<td colspan="3" nowrap>#rsMarca.RHJdescripcion#</td>
						  </tr>
						  <tr>
							<td align="right" nowrap class="fileLabel"><cf_translate key="LB_Horas_Adicionales">Horas Adicionales: </cf_translate></td>
							<td nowrap>#LSNumberFormat(rsMarca.RHCMhorasadicautor, '9.00')#</td>
						    <td align="right" nowrap><span class="fileLabel"><cf_translate key="LB_Horas_a_Rebajar">Horas a Rebajar:</cf_translate></span></td>
						    <td nowrap>#LSNumberFormat(rsMarca.RHCMhorasrebajar, '9.00')#</td>
						  </tr>
						  <tr>
							<td align="right" nowrap class="fileLabel"><cf_translate key="LB_Dia_libre">D&iacute;a Libre: </cf_translate></td>
							<td colspan="3" nowrap>
								<cfif rsMarca.RHCMdialibre EQ 1>
									<img src="/cfmx/rh/imagenes/checked.gif">
								<cfelse>
									<img src="/cfmx/rh/imagenes/unchecked.gif">
								</cfif>
							</td>
						  </tr>
						  <tr>
							<td align="right" valign="top" nowrap class="fileLabel"><cf_translate key="LB_Justificacion">Justificaci&oacute;n:</cf_translate></td>
							<td colspan="3" nowrap>
								<textarea name="RHCMjustificacion" cols="45" rows="5" id="RHCMjustificacion" style="border:none;" readonly>#rsMarca.RHCMjustificacion#</textarea>
							</td>
						  </tr>
						  <tr>
							<td align="right" nowrap class="fileLabel"><cf_translate key="LB_Accion_a_Seguir">Accion a Seguir:</cf_translate></td>
							<td colspan="3" nowrap>
								<cfif Len(Trim(rsMarca.AccionSeguir))>
									#rsMarca.AccionSeguir#
								<cfelse>
									<cf_translate key="LB_Ninguna">(Ninguna)</cf_translate>
								</cfif>
							</td>
						  </tr>
						  <tr>
							<td colspan="4" valign="top" nowrap class="fileLabel">&nbsp;</td>
						  </tr>
						</table>
						<!--- Fin Despliegue de Datos de Marca --->
					</td>
					<td width="50%" valign="top">
						<form name="form1" method="post" action="MarcasDetalle-SQL.cfm">
							<cfif isdefined("Form.RHPMid") and Len(Trim(Form.RHPMid))>
							  <input type="hidden" name="RHPMid" value="<cfoutput>#Form.RHPMid#</cfoutput>">
							</cfif>
							<cfif isdefined("Form.DEid") and Len(Trim(Form.DEid))>
							  <input type="hidden" name="DEid" value="<cfoutput>#Form.DEid#</cfoutput>">
							</cfif>
							<cfif isdefined("Form.RHCMid") and Len(Trim(Form.RHCMid))>
							  <input type="hidden" name="RHCMid" value="<cfoutput>#Form.RHCMid#</cfoutput>">
							</cfif>
							<cfif isdefined("Form.RHDMid") and Len(Trim(Form.RHDMid))>
							  <input type="hidden" name="RHDMid" value="<cfoutput>#Form.RHDMid#</cfoutput>">
							</cfif>
							<input type="hidden" name="dispPos" value="#rsDisponiblePos.total#">
							<input type="hidden" name="dispNeg" value="#rsDisponibleNeg.total#">
							<table width="100%" border="0" cellspacing="0" cellpadding="2">
							  <tr>
								<td class="tituloAlterno" colspan="2" align="center" nowrap>
									<cfif modo EQ 'CAMBIO'>
										<cf_translate key="LB_Modificar">Modificar</cf_translate>
									<cfelse>
										<cf_translate key="LB_Agregar">Agregar</cf_translate>
									</cfif> 
									<cf_translate key="LB_Incidencias_por_Horas_Extra">Incidencias por Horas Extra</cf_translate>
								</td>
							  </tr>
							  <tr>
								<td nowrap class="fileLabel" align="right"><cf_translate key="LB_Concepto_de_Incidencia">Concepto de Incidencia:</cf_translate></td>
								<td nowrap>
								  <cfif modo NEQ "ALTA">
									<cf_rhCIncidentes query="#rsDetalleIncidencia#" IncluirTipo="0">
								  <cfelse>
									<cf_rhCIncidentes IncluirTipo="0">
								  </cfif>			
								</td>
							  </tr>
							  <tr>
							    <td nowrap class="fileLabel" align="right"><cf_translate key="LB_Horas_Autorizadas">Horas Autorizadas:</cf_translate></td>
							    <td nowrap>
									<input name="RHDMhorasautor" type="text" size="5" maxlength="5" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,2);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="<cfif modo EQ 'CAMBIO' and Len(Trim(rsDetalleIncidencia.RHDMhorasautor)) NEQ 0>#LSNumberFormat(rsDetalleIncidencia.RHDMhorasautor, '9.00')#</cfif>">
								</td>
						      </tr>
							  <tr>
								<td colspan="2" nowrap>&nbsp;</td>
							  </tr>
							  <tr>
								<td colspan="2" valign="top" nowrap class="fileLabel" align="center">
								  <cfinclude template="/rh/portlets/pBotones.cfm">
								  <input type="button" name="btnRegresar" value="Regresar" onClick="javascript: regresar();">
								  <cfif modo EQ "CAMBIO">
									<cfset ts = "">
									<cfinvoke 
										component="sif.Componentes.DButils"
										method="toTimeStamp"
										returnvariable="ts">
									  <cfinvokeargument name="arTimeStamp" value="#rsDetalleIncidencia.ts_rversion#"/>
									</cfinvoke>
									<input type="hidden" name="ts_rversion" value="<cfif modo NEQ 'ALTA'>#ts#</cfif>">
								  </cfif>
								</td>
							  </tr>
							  <tr>
							    <td colspan="2" align="center" nowrap>&nbsp;</td>
						      </tr>
							</table>
						</form>
					</td>
				  </tr>
				  <tr>
				    <td valign="top">
						<cfinvoke 
						 component="rh.Componentes.pListas"
						 method="pListaRH"
						 returnvariable="pListaEmpl">
							<cfinvokeargument name="tabla" value="RHDetalleIncidencias a, CIncidentes b"/>
							<cfinvokeargument name="columnas" value="a.RHDMid, b.CIdescripcion, a.RHDMhorasautor, 
																	case b.CInegativo when 1 then '+' else '-' end as sumaresta,
																	'#Form.RHCMid#' as RHCMid,'#Form.DEid#' as DEid, '#Form.RHPMid#' as RHPMid, '1' as showDetail"/>
							<cfinvokeargument name="desplegar" value="CIdescripcion, sumaresta, RHDMhorasautor"/>
							<cfinvokeargument name="etiquetas" value="#LB_Concepto_de_Incidencias#, #LB_Signo#, #LB_Horas_Autorizadas#"/>
							<cfinvokeargument name="formatos" value="V, V, M"/>
							<cfinvokeargument name="formName" value="listaDetalle"/>	
							<cfinvokeargument name="filtro" value=" a.RHPMid = #Form.RHPMid# 
																	and a.RHCMid = #Form.RHCMid#
																	and a.CIid = b.CIid
																	and b.Ecodigo = #Session.Ecodigo#
																	#filtro# 
																	order by b.CIdescripcion"/>
							<cfinvokeargument name="align" value="left, center, right"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="irA" value="Marcas.cfm"/>
							<cfinvokeargument name="keys" value="RHDMid"/>
							<cfinvokeargument name="maxRows" value="0"/>
							<cfinvokeargument name="debug" value="N"/>
							<cfinvokeargument name="PageIndex" value="4"/>
						</cfinvoke>
					</td>
			      </tr>
				</table>
			</td>
		  </tr>
		</table>
	</cfoutput>
	
	<script language="javascript" type="text/javascript">		
		// Valida el rango en caso de que el tipo de concepto de incidencia sea de días y horas
		function __isHoras() {			
			<cfoutput>
			if (this.required) {
				if ((this.value == "") || (this.value == " ") || (parseFloat(qf(this.value)) == 0)) {
					this.error = this.description +' '+"#MSG_no_puede_ser_cero#";
				} else if (this.obj.form.negativo.value == 1 && (parseFloat(qf(this.value)) > parseFloat(qf(this.obj.form.dispPos.value)))) {
					this.error = "#MSG_Las_horas_autorizadas_no_pueden_ser_mayor_a#" +' '+ this.obj.form.dispPos.value;
				} else if (this.obj.form.negativo.value == -1 && (parseFloat(qf(this.value)) > parseFloat(qf(this.obj.form.dispNeg.value)))) {
					this.error = "#MSG_Las_horas_a_rebajar_no_pueden_ser_mayor_a#"+' '+ this.obj.form.dispNeg.value;
				}
			}
			</cfoutput>
		}
		
		function habilitarValidacion() {
			objForm.CIcodigo.required = true;
			objForm.RHDMhorasautor.required = true;
		}

		function deshabilitarValidacion() {
			objForm.CIcodigo.required = false;
			objForm.RHDMhorasautor.required = false;
		}
	
		qFormAPI.errorColor = "#FFFFCC";
		objForm = new qForm("form1");
		_addValidator("isHoras", __isHoras);
		<cfoutput>
		objForm.CIcodigo.required = true;
		objForm.CIcodigo.description = "#MSG_Concepto_de_Incidencia#";
		objForm.RHDMhorasautor.required = true;
		objForm.RHDMhorasautor.description = "#MSG_Horas_Autorizadas#";
		objForm.RHDMhorasautor.validateHoras();
		</cfoutput>
	</script>
	
<cfelse>
	<div align="center"><strong><cf_translate key="LB_UstedNoEstaAutorizadoParaIngresarAEstaPantalla">Usted no est&aacute; autorizado para ingresar a esta pantalla</cf_translate></strong></div>
</cfif>
