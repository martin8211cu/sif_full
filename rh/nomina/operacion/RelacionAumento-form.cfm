<cfif isdefined("Url.RHAid") and not isdefined("Form.RHAid")>
	<cfset Form.RHAid = Url.RHAid>
</cfif>
<cfif isdefined("Url.DEidentificacion") and not isdefined("Form.DEidentificacion")>
	<cfset Form.DEidentificacion = Url.DEidentificacion>
</cfif>

<cfif isdefined("Url.fidentificacion") and not isdefined("Form.fidentificacion")>
	<cfset Form.fidentificacion = Url.fidentificacion>
</cfif>

<cfif isdefined("Form.RHAid") and Len(Trim(Form.RHAid)) NEQ 0>
	<cfset modo = "CAMBIO">
<cfelse>
	<cfset modo = "ALTA">
</cfif>

<cfif isdefined("Form.RHDAlinea") and Len(Trim(Form.RHDAlinea)) NEQ 0>
	<cfset modoDet = "CAMBIO">
<cfelse>
	<cfset modoDet = "ALTA">
</cfif>

<cfset filtro = "">
<cfif isdefined("Form.RHAid") and Len(Trim(Form.RHAid)) NEQ 0>
	<cfset navegacion = "RHAid=" & Form.RHAid>
<cfelse>
	<cfset navegacion = "">
</cfif>

<cfif isdefined("Form.NTIcodigo") and Len(Trim(Form.NTIcodigo)) NEQ 0>
	<cfset filtro = filtro & " and a.NTIcodigo = '" & Form.NTIcodigo & "'">
	<cfset navegacion = navegacion & "&NTIcodigo=" & Form.NTIcodigo>
</cfif>

<cfif isdefined("Form.DEidentificacion") and Len(Trim(Form.DEidentificacion)) NEQ 0>
	<cfset filtro = filtro & " and a.DEidentificacion = '" & Form.DEidentificacion & "'">
	<cfset navegacion = navegacion & "&DEidentificacion=" & Form.DEidentificacion>
</cfif>

<cfif isdefined("Form.fidentificacion") and Len(Trim(Form.fidentificacion)) NEQ 0>
	<cfset filtro = filtro & " and b.DEidentificacion = '" & Form.fidentificacion & "'">
	<cfset navegacion = navegacion & "&fidentificacion=" & Form.fidentificacion>
</cfif>

<cfif isdefined("Form.fnombre") and Len(Trim(Form.fnombre)) NEQ 0>
	<cfset filtro = filtro & " and ( upper(b.DEnombre) like '%" & ucase(Form.fnombre) & "%'">
	<cfset filtro = filtro & " or upper(b.DEapellido1) like '%" & ucase(Form.fnombre) & "%'">	
	<cfset filtro = filtro & " or upper(b.DEapellido2) like '%" & ucase(Form.fnombre) & "%')">	
	<cfset navegacion = navegacion & "&fnombre=" & Form.fnombre>
</cfif>
<!--- VERIFICA SI TIENE CONTROL PRESUPUESTARIO --->
<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.DSN#" ecodigo="#session.Ecodigo#" pvalor="540" default="" returnvariable="ControlP"/>
<!--- VERIFICA  SI USA ESTRUCTURA SALARIAL --->
<cfquery name="UsaTabla" datasource="#session.DSN#">
	select CSusatabla
	from ComponentesSalariales
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and CSsalariobase = 1
</cfquery>
<cfif Usatabla.CSusatabla EQ 1>
	<cfset usaEstructuraSal = true>
<cfelse>
	<cfset usaEstructuraSal = false>
</cfif> 

<cfif modo EQ "CAMBIO">
	<cfquery name="rsEncabezado" datasource="#Session.DSN#">
		select a.RHAlote, 
				RHAfdesde,
				RHAtipo,RHTTid,RHVTid,RHAinactivos
		from RHEAumentos a
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#">
	</cfquery>
	
	<cfif modoDet EQ "CAMBIO">
		<cfquery name="rsDetalle" datasource="#Session.DSN#">
			select a.DEid,
				   {fn concat({fn concat({fn concat({ fn concat( b.DEnombre, ' ') },b.DEapellido1)}, ' ')},b.DEapellido2) } as NombreEmp,
				   b.DEidentificacion,
				   b.NTIcodigo,
				   <cf_dbfunction name="to_char" args="a.RHDvalor"> as RHDvalor, RHDporcentaje,
				   a.ts_rversion
			from RHDAumentos a, DatosEmpleado b
			where a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#">
			and a.RHDAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHDAlinea#">
			and a.NTIcodigo = b.NTIcodigo
			and a.DEidentificacion = b.DEidentificacion
			and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
		</cfquery>
	</cfif>
</cfif>

<!---Titulo del porlet ---->
<cfif modoDet EQ "CAMBIO">
	<cfset tit = "Trabajar con Empleados">
<cfelse>
	<cfset tit = "Trabajar con Empleados">
</cfif>
<cfinclude template="RelacionAumento-translate.cfm">
<script language="JavaScript" src="/cfmx/sif/js/qForms/qforms.js">//</script>
<script language="javascript" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js">//utiles</script>
<script language="javascript" type="text/javascript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");

	function validaForm(f) {
		<cfif modo EQ "CAMBIO" and not usaEStructuraSal>
			f.obj.RHDvalor.value = qf(f.obj.RHDvalor.value);
		</cfif>	
		return true;
	}

	function doConlisImport() {
		window.open("RelacionAumento-import.cfm", "ImportarRelacion");
	}

	//-->
</script>

<cfoutput>
<form name="form1" method="post" action="RelacionAumento-sql.cfm" onSubmit="javascript: return validaForm(this);" style="margin: 0;">
	<cfif modo EQ "CAMBIO">
		<input type="hidden" name="RHAid" id="RHAid" value="#Form.RHAid#">
	</cfif>
	<cfif modoDet EQ "CAMBIO">
		<input type="hidden" name="RHDAlinea" id="RHDAlinea" value="#Form.RHDAlinea#">
		<cfset ts = "">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" arTimeStamp="#rsDetalle.ts_rversion#" returnvariable="ts">
		</cfinvoke>
		<input type="hidden" name="ts_rversion" id="ts_rversion" value="#ts#">
	</cfif>
	<cfif isdefined("Form.PageNum")>
		<input type="hidden" name="Pagina" id="Pagina" value="#Form.PageNum#">
	</cfif>
	<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
		<tr><td colspan="<cfif modo EQ 'CAMBIO'>9<cfelse>7</cfif>" align="center" nowrap>&nbsp;</td></tr>

	  	<cfif modo EQ "ALTA">
			<tr><td colspan="<cfif modo EQ 'CAMBIO'>9<cfelse>7</cfif>" align="left"><strong><cf_translate key="Debe_especificar_la_fecha_a_partir_de_la_cual_van_a_regir_los_aumentos_salariales_que_se_van_a_registrar">Debe especificar la fecha a partir de la cual van a regir los aumentos salariales que se van a registrar. Ademas es necesario especificar el tipo de aumento que ser&aacute; aplicado.</cf_translate></strong></td></tr>
	  		<tr><td colspan="<cfif modo EQ 'CAMBIO'>9<cfelse>7</cfif>" align="center" nowrap>&nbsp;</td></tr>
		</cfif>

	  	<tr valign="top">
	  		<cfif modo EQ "CAMBIO">
				<td align="right" nowrap class="fileLabel"><strong><cf_translate key="LB_lote">Lote</cf_translate>:</strong>&nbsp;</td>
				<td nowrap>#rsEncabezado.RHAlote#</td>
			</cfif>
			<td align="right" class="fileLabel" nowrap><strong><cf_translate key="Fecha_de_Vigencia">Fecha de Vigencia</cf_translate>:</strong>&nbsp;</td>
			<td nowrap>
				<cfif modo EQ "CAMBIO">
					#LSDateFormat(rsEncabezado.RHAfdesde,'dd/mm/yyyy')#
					<input type="hidden" name="RHAfdesde" id="RHAfdesde" value="#LSDateFormat(rsEncabezado.RHAfdesde, 'dd/mm/yyyy')#"/>
				<cfelse>
					<cf_sifcalendario form="form1" name="RHAfdesde">
				</cfif>
			</td>
		
			<td width="1%" nowrap="nowrap" ><strong><cf_translate key="Tipo_de_Aumento">Tipo de Aumento</cf_translate>:</strong>&nbsp;</td>
			<td>
				<cfif modo EQ 'CAMBIO'>
					<cfif isdefined("rsEncabezado.RHAtipo") and rsEncabezado.RHAtipo eq 'P'>
						<cf_translate key="LB_Porcentaje">Porcentaje</cf_translate>
					<cfelseif isdefined("rsEncabezado.RHAtipo") and rsEncabezado.RHAtipo eq 'T'>
						<cf_translate key="LB_TablaSalarial">Tabla Salarial</cf_translate>
					<cfelse>	
						<cf_translate key="LB_Monto">Monto</cf_translate>
					</cfif>
					<input type="hidden" name="RHAtipo" id="RHAtipo" value="#rsEncabezado.RHAtipo#" />
				<cfelse>
					<select name="RHAtipo" id="RHAtipo" onchange="javascript:muestraDatos(this.value);">
						<option value="M"><cf_translate key="LB_Monto">Monto</cf_translate></option>
						<option value="P"><cf_translate key="LB_Porcentaje">Porcentaje</cf_translate></option>
						<cfif usaEstructuraSal>
							<option value="T"><cf_translate key="LB_TablaSalarial">Tabla Salarial</cf_translate></option>
						</cfif>
					</select>
				</cfif>
			</td>
			<cfif usaEstructuraSal>
				<td id="TablaSE" style="display:none" align="right"><strong><cf_translate key="LB_TablaSalarial">Tabla Salarial</cf_translate>:</strong>&nbsp;<br /><br /><strong><cf_translate key="LB_Vigencia">Vigencia</cf_translate>:</strong>&nbsp;</td>
				<td id="TablaS" align="left" style="display:none">
				
					<cfif modo EQ "CAMBIO" and rsEncabezado.RHTTid GT 0	and rsEncabezado.RHVTid GT 0>
						 <cfquery name="rsTabla" datasource="#session.DSN#">
							select RHTTid, RHTTcodigo,RHTTdescripcion
							from RHTTablaSalarial
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							  and RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.RHTTid#">
						</cfquery>
						<cfquery name="rsVigencia" datasource="#session.DSN#">
							select RHVTid, RHVTcodigo,RHVTdescripcion
							from RHVigenciasTabla
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							  and RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.RHTTid#">
							  and RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.RHVTid#">
						</cfquery>
						#rsTabla.RHTTcodigo# - #rsTabla.RHTTdescripcion#<br /><br />
						#rsVigencia.RHVTcodigo# - #rsVigencia.RHVTdescripcion# <br /><br />
						<input type="checkbox" id="Inactivos" name="Inactivos" value=""<cfif rsEncabezado.RHAinactivos EQ 1>checked</cfif>>
						<strong><cf_translate key="CHK_EmpleadosInactivos">Incluir Empleados Inactivos</cf_translate></strong>
					<cfelse>
						<cf_conlis 
							campos="RHTTid,RHTTcodigo,RHTTdescripcion"
							size="0,10,30"
							desplegables="N,S,S"
							modificables="N,S,N"
							title="#LB_ListaTablas#"
							tabla="RHTTablaSalarial"
							columnas="RHTTid,RHTTcodigo,RHTTdescripcion"
							filtro="Ecodigo = #session.Ecodigo#"
							filtrar_por="RHTTid,RHTTcodigo,RHTTdescripcion"
							desplegar="RHTTcodigo,RHTTdescripcion"
							etiquetas="#LB_Codigo#,#LB_Descripcion#"
							formatos="S,S"
							align="left,left"
							asignar="RHTTid,RHTTcodigo,RHTTdescripcion"
							asignarFormatos="S,S,S"
							form="form1"
							showEmptyListMsg="true"
							EmptyListMsg=" --- No se encotraron vigencias --- "/>
                            
						<cf_conlis 
							campos="RHVTid,RHVTcodigo,RHVTdescripcion"
							size="0,10,30"
							desplegables="N,S,S"
							modificables="N,S,N"
							title="#LB_ListaVigencias#"
							tabla="RHVigenciasTabla"
							columnas="RHTTid,RHVTcodigo,RHVTdescripcion,RHVTid,RHVTfecharige,case convert(varchar,RHVTfechahasta,103) when '01/01/6100' then 'Indefinido' else convert(varchar,RHVTfechahasta,103) end as RHVTfechahasta,case RHVTestado when 'A' then 'Aplicado' when 'P' then 'Pendiente' else RHVTestado end as RHVTestado"
							filtro="Ecodigo = #session.Ecodigo# and RHTTid = $RHTTid,numeric$ and RHVTestado = 'A' #filtro# order by RHVTfecharige,RHVTfechahasta,RHVTestado"
							filtrar_por="RHVTcodigo,RHVTdescripcion,RHVTfecharige,RHVTfechahasta,RHVTestado"
							desplegar="RHVTcodigo,RHVTdescripcion,RHVTfecharige,RHVTfechahasta,RHVTestado"
							etiquetas="#LB_Codigo#,#LB_Descripcion#,#LB_FechaRige#,#LB_FechaHasta#,#LB_Estado#"
							formatos="S,S,D,S,S"
							align="left,left"
							asignar="RHTTid,RHVTid,RHVTcodigo,RHVTdescripcion"
							asignarFormatos="S,S,S"
							form="form1"
							showEmptyListMsg="true"
							EmptyListMsg=" --- No se encotraron vigencias --- "/>
						<br />
						<input type="checkbox" id="Inactivos" name="Inactivos"  checked="checked" >
						<label for="Inactivos" style="font-style:normal; font-variant:normal; font-weight:normal"><strong><cf_translate key="CHK_EmpleadosInactivos">Incluir Empleados Inactivos</cf_translate></strong>		</label>
					</cfif>
				</td>
			</cfif>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr>
			<cfif modo EQ 'CAMBIO'>
				<td align="center" nowrap colspan="<cfif usaEstructuraSal>8<cfelse>6</cfif>">
					<input type="submit" class="btnAplicar" name="btnAplicar" id="btnAplicar" value="#BTN_Aplicar#" onClick="javascript: inhabilitarValidacion(); return (confirm('#LB_AplicarRelacAumento#'));">
					<input type="submit" class="btnEliminar" name="btnEliminar" id="btnEliminar" value="#BTN_EliminarLote#" onClick="javascript: inhabilitarValidacion(); return (confirm('#LB_EliminarLote#'));">
				</td>
			<cfelse>
				<td align="center" colspan="<cfif usaEstructuraSal>6<cfelse>4</cfif>" width="50%" nowrap><input type="submit" class="btnGuardar" name="btnAgregar" id="btnAgregar" value="#BTN_Agregar#"></td>
			</cfif>
		</tr>
		
	  	<cfinclude template="RelacionAumento-Observacion.cfm">
	
		<cfif modo EQ "CAMBIO">
	  		<tr><td colspan="<cfif modo EQ 'CAMBIO'>9<cfelse>7</cfif>" align="center" nowrap>&nbsp;</td></tr>
	  		<tr>

	  			<td colspan="<cfif modo EQ 'CAMBIO'>9<cfelse>7</cfif>" align="center" nowrap>		 
		  			<cf_web_portlet_start border="true" titulo="#LB_TituloPorletCF#" skin="#Session.Preferences.Skin#">
						<table width="100%" cellpadding="1" cellspacing="0" >
							<tr>
								<td colspan="2">
									<table class="areaFiltro" width="100%" cellpadding="2">
										<tr><td>Esta opci&oacute;n le permite agregar todos los empleados pertenecientes al Centro Funcional espec&iacute;ficado</td></tr>
									</table>
								</td>
							</tr>
							<tr>
								<td nowrap class="fileLabel">
									<strong><cf_translate key="LB_CentroFuncional">Centro Funcional</cf_translate>&nbsp;</strong>
								</td>
								<cfif isdefined("rsEncabezado.RHAtipo") and rsEncabezado.RHAtipo eq 'P'>
									<td nowrap class="fileLabel"><strong><cf_translate key="LB_Porcentaje_de_Aumento">Porcentaje de Aumento</cf_translate></strong></td>
								<cfelseif isdefined("rsEncabezado.RHAtipo") and rsEncabezado.RHAtipo eq 'M'>
									<td nowrap class="fileLabel"><strong><cf_translate key="LB_Monto_del_Aumento">Monto del Aumento</cf_translate></strong></td>
								</cfif>				
							</tr>
			  				<tr>
								<td nowrap>
									<table width="100%" cellpadding="0" cellspacing="0">
										<tr>
											<td><cf_rhcfuncional size="53" form="form1"></td>
											<td><input type="checkbox" name="dependencias"  /></td>
											<td><strong><cf_translate key="LB_Incluir_dependencias">Incluir dependencias</cf_translate>&nbsp;</strong></td>
										</tr>
									</table>	
								<cfif isdefined("rsEncabezado.RHAtipo") and rsEncabezado.RHAtipo eq 'P'>
									<td nowrap><input name="RHDporcentajecf" id="RHDporcentajecf" type="text" size="10" maxlength="6" style="text-align: right;" onBlur="javascript: fm(this,2);"  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" value=""></td>
								<cfelseif isdefined("rsEncabezado.RHAtipo") and rsEncabezado.RHAtipo eq 'M'>
									<td nowrap><input name="RHDvalorcf" id="RHDvalorcf" type="text" size="20" maxlength="18" style="text-align: right;" onBlur="javascript: fm(this,2);"  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" value=""></td>
								</cfif>				
							</tr>
			  				<tr>
								<td colspan="3" align="center" nowrap class="fileLabel"><input type="submit" class="btnGuardar" name="btnAgregarDCF" id="btnAgregarDCF" value="#BTN_Agregar#" onClick="javascript: habilitarValidacionCF(); "></td>
		      				</tr>
						</table>
					<cf_web_portlet_end>

					<br />

					<cf_web_portlet_start border="true" titulo="#LB_TituloPorletDetalleAumentoSalarial#" skin="#Session.Preferences.Skin#">
						<table width="100%" border="0" cellspacing="0" cellpadding="3" align="center">
							<tr>
								<td colspan="2">
									<table class="areaFiltro" width="100%" cellpadding="2">
										<tr><td>Esta opci&oacute;n le permite agregar empleados a la relaci&oacute;n uno por uno<cfif isdefined("rsEncabezado.RHAtipo") and rsEncabezado.RHAtipo Neq 'T'> &oacute; modificar individualmente el monto o porcentaje definido para su aumento</cfif> .</td></tr>
									</table>
								</td>
							</tr>
							<tr>
								<td nowrap class="fileLabel"><strong><cf_translate key="LB_Empleado">Empleado</cf_translate></strong></td>
								<cfif isdefined("rsEncabezado.RHAtipo") and rsEncabezado.RHAtipo eq 'P'>
									<td nowrap class="fileLabel"><strong><cf_translate key="LB_Porcentaje_de_Aumento">Porcentaje de Aumento</cf_translate></strong></td>
								<cfelseif isdefined("rsEncabezado.RHAtipo") and rsEncabezado.RHAtipo eq 'M'>
									<td nowrap class="fileLabel"><strong><cf_translate key="LB_Monto_del_Aumento">Monto del Aumento</cf_translate></strong></td>
								</cfif>		
							</tr>
			  				<tr>

								<td nowrap width="51%">
									<cfif modoDet NEQ "ALTA">
										<input type="hidden" name="NTIcodigo" value="#rsDetalle.NTIcodigo#">
										<input type="hidden" name="DEidentificacion" value="#rsDetalle.DEidentificacion#">
										<input type="hidden" name="DEid" value="#rsDetalle.DEid#">
										<input type="hidden" name="DEid" value="#rsDetalle.NombreEmp#">
										#rsDetalle.DEidentificacion# - #rsDetalle.NombreEmp# 
									<cfelse>
										<cf_rhempleado size="40" form="form1"> 
									</cfif> 
								</td>

								<cfif isdefined("rsEncabezado.RHAtipo") and rsEncabezado.RHAtipo eq 'P'>
									<td nowrap><input name="RHDporcentaje" id="RHDporcentaje" type="text" size="10" maxlength="6" style="text-align: right;" onBlur="javascript: fm(this,2);"  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" value="<cfif modoDet EQ 'CAMBIO'>#rsDetalle.RHDporcentaje#<cfelse>0.00</cfif>"></td>
								<cfelseif isdefined("rsEncabezado.RHAtipo") and rsEncabezado.RHAtipo eq 'M'>
									<td nowrap><input name="RHDvalor" id="RHDvalor" type="text" size="14" maxlength="14" style="text-align: right;" onBlur="javascript: fm(this,2);"  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" value="<cfif modoDet EQ 'CAMBIO'>#rsDetalle.RHDvalor#<cfelse>0.00</cfif>"></td>
								</cfif>		
		      				</tr>

			  				<tr>
								<td colspan="2" align="center" nowrap class="fileLabel">
									<cfif modoDet EQ "ALTA">
										<input type="submit" class="btnGuardar" name="btnAgregarD" id="btnAgregarD" value="#BTN_Agregar#" onClick="javascript: habilitarValidacion(); ">
									<cfelse>
										<cfif not usaEstructuraSal>
										<input type="submit" class="btnGuardar" name="btnCambiarD" id="btnCambiarD" value="#BTN_Modificar#" onClick="javascript: habilitarValidacion(); ">
										</cfif>
										<input type="submit" class="btnEliminar" name="btnEliminarD" id="btnEliminarD" value="#BTN_Eliminar#" onClick="javascript: inhabilitarValidacion(); return (confirm('#HTMLEditFormat(LB_EliminarDeduccion)#'));">
										<input type="submit" class="btnNuevo" name="btnNuevoD" id="btnNuevoD" value="#BTN_Nuevo#" onClick="javascript: inhabilitarValidacion(); ">
									</cfif>				
			    				</td>
			  				</tr>
						</table>
					<cf_web_portlet_end>
				</td>
	  		</tr>
		</cfif>
	  	<tr><td colspan="<cfif modo EQ 'CAMBIO'>5<cfelse>5</cfif>" align="center" nowrap>&nbsp;</td>
	  	</tr>
  	</table>
</form>

<cfif modo EQ "CAMBIO">
	<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
		<tr><td class="tituloListas"><strong>#vlistado#</strong></td></tr>
		<tr><td>
			<form name="filtro" method="post" style="margin:0;">
			<input type="hidden" name="RHAid" value="#form.RHAid#" />
			<table width="100%" cellpadding="1" cellspacing="0" class="areaFiltro">
				<tr>
					<td><strong>#LB_Identificacion#</strong></td>
					<td><input type="text" name="fIdentificacion" id="fIdentificacion" size="20" maxlength="60" value="<cfif isdefined("Form.fidentificacion") and Len(Trim(Form.fidentificacion)) NEQ 0>#trim(Form.fidentificacion)#</cfif>" /></td>
					<td><strong>#LB_NombreCompleto#</strong></td>
					<td><input type="text" size="50" maxlength="255" name="fNombre" id="fNombre" value="<cfif isdefined("Form.fnombre") and Len(Trim(Form.fnombre)) NEQ 0>#trim(Form.fnombre)#</cfif>"/></td>
					<td><input type="submit" class="btnFiltrar" name="btnFiltrar" id="btnFiltrar" value="#BTN_Filtrar#" ></td>
				</tr>
			</table>
			</form>
		</td></tr>
		<tr>
			<td>
		    <cfif  usaEstructuraSal>
	                	<cfset lvar_salariopropuesto ="">                    
						<cfset Lvar_desplegar = "identificacion, nombrecompleto, salario, aumento, salariopropuesto">
						<cfset 	Lvar_etiquetas = "#LB_Identificacion#,#LB_NombreCompleto#,#LB_Salario_Actual#,#LB_Aumento#,#LB_SalarioPropuesto#">
                    <cfelse>
                      	<cfset lvar_salariopropuesto ="+ a.RHDsalario">
						<cfset Lvar_desplegar = "identificacion, nombrecompleto, salario, aumento, porcentaje,salariopropuesto">
						<cfset 	Lvar_etiquetas = "#LB_Identificacion#,#LB_NombreCompleto#,#LB_Salario_Actual#,#LB_Aumento#,Porcentaje,#LB_SalarioPropuesto#">
	                </cfif>
                    
                	<cfset Lvar_col ="a.RHAid, a.RHDAlinea, c.RHAlote, 
														   {fn concat({fn concat({fn concat({ fn concat(b.DEapellido1, ' ') },b.DEapellido2)}, ' ')},b.DEnombre) } as nombrecompleto, 
														   b.DEidentificacion as identificacion, 												  
														   a.RHDvalor as aumento,
														   
														   a.RHDsalario as salario,	
														   a.RHDporcentaje as porcentaje,
														   a.RHDvalor #lvar_salariopropuesto# as salariopropuesto">
				
						<cfset Lvar_filtro = " a.RHAid = #Form.RHAid#
															and a.RHAid = c.RHAid
															and c.Ecodigo = #Session.Ecodigo#
															and a.NTIcodigo = b.NTIcodigo
															and a.DEidentificacion = b.DEidentificacion
															and b.Ecodigo = c.Ecodigo
															#filtro#
															order by a.DEidentificacion
															">
			<!---	<cfelse>
					<!---<cfset Lvar_col ="a.RHAid, a.RHDAlinea, c.RHAlote, 
														   {fn concat({fn concat({fn concat({ fn concat(b.DEapellido1, ' ') },b.DEapellido2)}, ' ')},b.DEnombre) } as nombrecompleto, 
														   b.DEidentificacion as identificacion, 												  
														   a.RHDvalor as aumento,
														   
														   a.RHDsalario as salario,	
														   a.RHDporcentaje as porcentaje,
														   a.RHDvalor as salariopropuesto">
					<cfset Lvar_desplegar = "identificacion, nombrecompleto, salario, aumento, porcentaje, salariopropuesto">
					<cfset Lvar_etiquetas = "#LB_Identificacion#,#LB_NombreCompleto#,#LB_Salario_Actual#,#LB_Aumento#,Porcentaje,#LB_SalarioPropuesto#">
					<cfset Lvar_filtro = " a.RHAid = #Form.RHAid#
															and a.RHAid = c.RHAid
															and c.Ecodigo = #Session.Ecodigo#
															and a.NTIcodigo = b.NTIcodigo
															and a.DEidentificacion = b.DEidentificacion
															and b.Ecodigo = d.Ecodigo
															and b.DEid = d.DEid
															and c.RHAfdesde between d.LTdesde and d.LThasta
															and b.Ecodigo = c.Ecodigo
															#filtro#
															order by a.DEidentificacion
															">--->
                                                            
                	<cfset Lvar_col ="a.RHAid, a.RHDAlinea, c.RHAlote, 
														   {fn concat({fn concat({fn concat({ fn concat(b.DEapellido1, ' ') },b.DEapellido2)}, ' ')},b.DEnombre) } as nombrecompleto, 
														   b.DEidentificacion as identificacion, 												  
														   a.RHDvalor as aumento,
														   
														   a.RHDsalario as salario,	
														   a.RHDporcentaje as porcentaje,
														   a.RHDvalor+a.RHDsalario as salariopropuesto">
				
						<cfset Lvar_desplegar = "identificacion, nombrecompleto, salario, aumento, salariopropuesto">
						<cfset 	Lvar_etiquetas = "#LB_Identificacion#,#LB_NombreCompleto#,#LB_Salario_Actual#,#LB_Aumento#,#LB_SalarioPropuesto#">
						<cfset Lvar_filtro = " a.RHAid = #Form.RHAid#
															and a.RHAid = c.RHAid
															and c.Ecodigo = #Session.Ecodigo#
															and a.NTIcodigo = b.NTIcodigo
															and a.DEidentificacion = b.DEidentificacion
															and b.Ecodigo = c.Ecodigo
															#filtro#
															order by a.DEidentificacion
															">                                                       
				</cfif> --->
				<cfinvoke 
				 component="rh.Componentes.pListas"
				 method="pListaRH"
				 returnvariable="pListaRet">
					<cfinvokeargument name="tabla" value="RHDAumentos a, DatosEmpleado b, RHEAumentos c"/>
					<cfinvokeargument name="columnas" value="#preservesinglequotes(Lvar_col)#"/>
					<cfinvokeargument name="desplegar" value="#Lvar_desplegar#"/>
					<cfinvokeargument name="etiquetas" value="#Lvar_etiquetas#"/>
					<cfinvokeargument name="formatos" value="V,V,M,M,M,M"/>
					<cfinvokeargument name="filtro" value=" #Lvar_filtro#
															"/>
					<cfinvokeargument name="align" value="left, left, right, right, right,right"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#"/>
					<cfinvokeargument name="keys" value="RHAid, RHDAlinea"/>
					<cfinvokeargument name="MaxRows" value="30"/>
					<cfinvokeargument name="formName" value="listaAumentos"/>
					<cfinvokeargument name="navegacion" value="#navegacion#"/>
					<cfinvokeargument name="debug" value="N"/>
					<cfinvokeargument name="showemptylistmsg" value="true"/>
				</cfinvoke>
			</td>
		</tr>
	</table>
</cfif>

</cfoutput>

<script language="javascript" type="text/javascript">
	<cfif isdefined("rsEncabezado.RHAtipo") and rsEncabezado.RHAtipo eq 'P'>
		function __isNotCero() {
			if (this.required && ((this.value == "") || (this.value == " ") || (new Number(qf(this.value)) == 0))) {
				this.error = this.description + <cfoutput>"#LB_ElCampoNoPuedeSerCero#"</cfoutput>;
			}

			if (this.required && ((this.value != "") && (new Number(qf(this.value)) > 100))) {
				this.error = this.description + <cfoutput>"#LB_ElCampoNoPuedeSerMayorA100#"</cfoutput>;
			}
		}
	<cfelse>
		function __isNotCero() {
			if (this.required && ((this.value == "") || (this.value == " ") || (new Number(qf(this.value)) == 0))) {
				this.error = this.description + <cfoutput>"#LB_ElCampoNoPuedeSerCero#"</cfoutput>;
			}
		}
	</cfif>

	<cfif modo EQ "CAMBIO">
		function inhabilitarValidacion() {
			objForm.DEidentificacion.required = false;
			objForm.CFid.required = false;		
			<cfif isdefined("rsEncabezado.RHAtipo") and rsEncabezado.RHAtipo eq 'P'>
				objForm.RHDporcentaje.required = false;
				objForm.RHDporcentajecf.required = false;
			<cfelseif isdefined("rsEncabezado.RHAtipo") and rsEncabezado.RHAtipo eq 'M'>
				objForm.RHDvalor.required = false;
				objForm.RHDvalorcf.required = false;
			</cfif>	
		}
	
		function habilitarValidacion() {
			objForm.DEidentificacion.required = true;
			objForm.CFid.required = false;		
			<cfif isdefined("rsEncabezado.RHAtipo") and rsEncabezado.RHAtipo eq 'P'>
				objForm.RHDporcentaje.required = true;
				objForm.RHDporcentajecf.required = false;			
			<cfelseif isdefined("rsEncabezado.RHAtipo") and rsEncabezado.RHAtipo eq 'M'>
				objForm.RHDvalor.required = true;
				objForm.RHDvalorcf.required = false;
			</cfif>	
		}
	
		function habilitarValidacionCF() {
			objForm.CFid.required = true;
			objForm.DEidentificacion.required = false;		
			<cfif isdefined("rsEncabezado.RHAtipo") and rsEncabezado.RHAtipo eq 'P'>
				objForm.RHDporcentajecf.required = true;
				objForm.RHDporcentaje.required = false;
			<cfelseif  isdefined("rsEncabezado.RHAtipo") and rsEncabezado.RHAtipo eq 'M'>
				objForm.RHDvalorcf.required = true;
				objForm.RHDvalor.required = false;
			</cfif>	
		}
	</cfif>

	qFormAPI.errorColor = "#FFFFCC";
	_addValidator("isNotCero", __isNotCero);
	objForm = new qForm("form1");

	<cfoutput>
		<cfif modo EQ "CAMBIO">		
			objForm.DEidentificacion.required = true;
			objForm.DEidentificacion.description = "#LB_Empleado#";

			objForm.CFid.required = true;
			objForm.CFid.description = "Centro Funcional";

			<cfif isdefined("rsEncabezado.RHAtipo") and rsEncabezado.RHAtipo eq 'P'>
				objForm.RHDporcentaje.required = true;
				objForm.RHDporcentaje.description = "#LB_Porcentaje#";
				objForm.RHDporcentaje.validateNotCero();	
				
				objForm.RHDporcentajecf.required = true;
				objForm.RHDporcentajecf.description = "#LB_Porcentaje#";				
				objForm.RHDporcentajecf.validateNotCero();	
				
			<cfelseif isdefined("rsEncabezado.RHAtipo") and rsEncabezado.RHAtipo eq 'M'>
				objForm.RHDvalor.required = true;
				objForm.RHDvalor.description = "#LB_Monto#";
				objForm.RHDvalor.validateNotCero();	

				objForm.RHDvalorcf.required = true;
				objForm.RHDvalorcf.description = "#LB_Monto#";
				objForm.RHDvalorcf.validateNotCero();	
			<cfelse>
				document.getElementById('TablaSE').style.display = '';
				document.getElementById('TablaS').style.display = '';
			</cfif>
		<cfelse>
			objForm.RHAfdesde.required = true;
			objForm.RHAfdesde.description = "#LB_FechaDeVigencia#";
		</cfif>
	</cfoutput>
	function muestraDatos(valor){
		if (valor == 'T'){
			document.getElementById('TablaSE').style.display = '';
			document.getElementById('TablaS').style.display = '';
			objForm.RHTTid.required = true;
			objForm.RHTTid.description = "<cfoutput>#LB_TablaSalarial#</cfoutput>";
			objForm.RHVTid.required = true;
			objForm.RHVTid.description = "<cfoutput>#LB_Vigencia#</cfoutput>";
		}else{
			document.getElementById('TablaSE').style.display = 'none';
			document.getElementById('TablaS').style.display = 'none';
		}
	}
</script>
