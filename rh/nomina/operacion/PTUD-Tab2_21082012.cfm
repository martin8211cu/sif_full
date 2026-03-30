<cfset modoD = "ALTA">
<cfif not isdefined("form.RHPTUDid") and isdefined("url.RHPTUDid") and len(trim(url.RHPTUDid))>
	<cfset form.RHPTUDid = url.RHPTUDid>
</cfif>

<cfif isdefined("form.RHPTUDid") and len(trim(form.RHPTUDid))>
	<cfset modoD = "Cambio">
</cfif>

<!--- <cfdump var="#form#">
<cfdump var="#url#"> ---> 
<!--- Consultas de Seleccin de Empleados --->
<cfquery name="rsOficina" datasource="#session.DSN#">
	select Ocodigo, Oficodigo, Odescripcion 
	from Oficinas 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<cfquery name="rsDepartamento" datasource="#session.DSN#">
	select Dcodigo, Deptocodigo, Ddescripcion 
	from Departamentos 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<cfquery name="rsAccion" datasource="#session.DSN#">
	select FechaDesde, FechaHasta
	from RHPTUE
	where RHPTUEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPTUEid#"> 
</cfquery>

<!---================ TRADUCCION =================----->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_el_Centro_Funcional"
	Default="el Centro Funcional?"	
	returnvariable="MSG_el_Centro_Funcional"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_TipoPuesto"
	Default="el Tipo de Puesto?"	
	returnvariable="MSG_TipoPuesto"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_la_OficinaDepartamento"
	Default="la Oficina/Departamento?"	
	returnvariable="MSG_la_OficinaDepartamento"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_el_Tipo_de_Puesto"
	Default="el Tipo de Puesto?"	
	returnvariable="MSG_el_Tipo_de_Puesto"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_el_Empleado"
	Default="el Empleado?"	
	returnvariable="MSG_el_Empleado"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Desea_eliminar"
	Default="Desea eliminar"	
	returnvariable="MSG_Desea_eliminar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Agregar"
	Default="Agregar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Agregar"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Lista_de_empleados"
	Default="Lista de empleados"	
	returnvariable="LB_Lista_de_empleados"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Eliminar_el_Centro_Funcional"
	Default="Eliminar el Centro Funcional"	
	returnvariable="LB_Eliminar_el_Centro_Funcional"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Eliminar_la_OficinaDepartamento"
	Default="Eliminar la Oficina/Departamento"	
	returnvariable="LB_Eliminar_la_OficinaDepartamento"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Eliminar_el_Tipo_de_Puesto"
	Default="Eliminar el Tipo de Puesto"	
	returnvariable="LB_Eliminar_el_Tipo_de_Puesto"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Eliminar_el_Empleado"
	Default="Eliminar el Empleado"	
	returnvariable="LB_Eliminar_el_Empleado"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Generar_Empleados"
	Default="Generar Empleados"
	returnvariable="BTN_Generar_Empleados"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Centro_Funcional"
	Default="Centro Funcional"	
	returnvariable="MSG_Centro_Funcional"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Oficina"
	Default="Oficina"	
	returnvariable="MSG_Oficina"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Departamento"
	Default="Departamento"	
	returnvariable="MSG_Departamento"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Tipo_de_Puesto"
	Default="Tipo de Puesto"	
	returnvariable="MSG_Tipo_de_Puesto"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Empleado"
	Default="Empleado"	
	returnvariable="MSG_Empleado"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Puesto"
	Default="Puesto"	
	returnvariable="MSG_Puesto"/>	



<!--- Seccin de Java Script --->
<script src="/cfmx/rh/js/utilesMonto.js"></script>
<script language="JavaScript" type="text/javascript">
	function showDependencia(p) {
	
		var a = document.getElementById("trCentroFuncional");
		var b = document.getElementById("trOficinaDepto");
		var c = document.getElementById("trPuesto");
		var d = document.getElementById("trEmpleado");
		var e = document.getElementById("trTipoPuesto");
				
		if (a) a.style.display = ((p==1)?"":"none");
		if (b) b.style.display = ((p==2)?"":"none");
		if (c) c.style.display = ((p==3)?"":"none");
		if (d) d.style.display = ((p==4)?"":"none");
		if (e) e.style.display = ((p==5)?"":"none");

		objFormD.CFid.required      = ((p==1)?true:false);
		objFormD.Ocodigo.required   = ((p==2)?true:false);
		objFormD.Dcodigo.required   = ((p==2)?true:false);
		objFormD.RHPcodigo.required = ((p==3)?true:false);
		objFormD.DEid.required      = ((p==4)?true:false);
		objFormD.RHTPcodigo.required= ((p==5)?true:false);
		
	}
	
	function EliminarDAM(id,valor) {
		<cfoutput>
		if (valor == 1) { var msg = '#MSG_el_Centro_Funcional#'; }
		if (valor == 2) { var msg = '#MSG_la_OficinaDepartamento#'; }
		if (valor == 3) { var msg = '#MSG_el_Tipo_de_Puesto#'; }
		if (valor == 4) { var msg = '#MSG_el_Empleado#'; }
		if (valor == 5) { var msg = '#MSG_TipoPuesto#'; }

		if (confirm('#MSG_Desea_eliminar# ' + msg)) {
			document.formD.RHPTUDid.value = id;
			document.formD.RHPTUaccion.value = "BAJA";
			deshabilitar();
			return true;
		}
		return false;
		</cfoutput>
	}
	
	function deshabilitar() {
		objFormD.CFid.required      = false;
		objFormD.Ocodigo.required   = false;
		objFormD.Dcodigo.required   = false;
		objFormD.RHPcodigo.required = false;
		objFormD.DEid.required      = false;
		objFormD.RHTPcodigo.required= false;
	}
	
	function ResetEmployee() {
		document.formD.DEid.value = "";
		document.formD.DEidentificacion.value = "";
		document.formD.Nombre.value = "";
	}
	
	var popUpWin = 0;
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
	
	function doConlisEmpleados(){
		var params = '';
		params = params + '?po_form=formD';
 		<cfif isdefined("rsAccion") and rsAccion.RecordCount NEQ 0 and len(trim(rsAccion.FechaDesde)) and len(trim(rsAccion.FechaHasta))>
			<cfoutput>
				params = params + '&pd_acciondesde=#LSDateFormat(rsAccion.FechaDesde,"dd/mm/yyyy")#&pd_accionhasta=#LSDateFormat(rsAccion.FechaHasta,"dd/mm/yyyy")#';
			</cfoutput>
		</cfif>
		popUpWindow("/cfmx/rh/nomina/masiva/ConlisEmpleadosAccionMasiva.cfm"+params,200,180,650,400);		
	}
	
	function funcTraerEmpleado(prn_DEidentificacion){
		var params = '';
		if (prn_DEidentificacion!=''){	
			<cfif isdefined("rsAccion") and rsAccion.RecordCount NEQ 0 and len(trim(rsAccion.FechaDesde)) and len(trim(rsAccion.FechaHasta))>
				<cfoutput>
					params = params + '&pd_acciondesde=#LSDateFormat(rsAccion.FechaDesde,"dd/mm/yyyy")#&pd_accionhasta=#LSDateFormat(rsAccion.FechaHasta,"dd/mm/yyyy")#';
				</cfoutput>
			</cfif>
	   		document.getElementById("fr_empleados").src = '/cfmx/rh/nomina/masiva/SQLTraeEmpleadosAccionMasiva.cfm?DEidentificacion='+prn_DEidentificacion+'&po_form=formD'+params;
	  	}
	 	else{
	   		document.formD.DEid.value = '';
			document.formD.DEidentificacion.value = '';
	   		document.formD.Nombre.value = '';
	  	}
	}
</script>

<!--- Inicia el pintado de la pantalla de Seleccin de Empleados --->
<style type="text/css">
	.style2 {color: #000066}
</style>

<cfoutput>
<form name="formD" method="post" style="margin: 0;" action="PTU-sql.cfm">
	<input name="RHPTUEid" type="hidden" value="<cfif isdefined("form.RHPTUEid")>#form.RHPTUEid#</cfif>" />
    <input type="hidden" name="RHPTUDid" id="RHPTUDid" value="">
	<input type="hidden" name="RHPTUaccion" id="RHPTUaccion" value="">
	<table width="50%" border="0" cellspacing="0" cellpadding="1" align="center">
		<tr><td colspan="4" align="left"><strong><cf_translate key="LB_Este_proceso_no_incluye_a_los_empleados_que_cuenten_con_un_salario_negociado">Este proceso no incluye a los empleados que cuenten con un salario negociado</cf_translate></strong></td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td colspan="4">
				<table width="100%" border="0" cellspacing="0" cellpadding="1" align="center">
					<tr>
						<td nowrap><input name="opcion" type="radio" value="1" onClick="javascript: showDependencia(1);" checked></td>
						<td class="fileLabel"><cf_translate key="LB_Centro_funcional">Centro Funcional</cf_translate></td>
						<td nowrap><input name="opcion" type="radio" value="2" onClick="javascript: showDependencia(2);"></td>
						<td class="fileLabel"><cf_translate key="LB_Oficina_Departamento">Oficina/Departamento</cf_translate></td>
						<td nowrap><input name="opcion" type="radio" value="3" onClick="javascript: showDependencia(3);"></td>
						<td class="fileLabel"><cf_translate key="LB_Tipo_de_Puesto">Puesto</cf_translate></td>
						<td nowrap><input name="opcion" type="radio" value="5" onClick="javascript: showDependencia(5);"></td>
						<td class="fileLabel"><cf_translate key="LB_Puesto">Tipo de Puesto</cf_translate></td>
						<!--- <cfif isdefined("rsDatosAccion") and  rsDatosAccion.RHTAperiodos EQ 0> --->
							<td nowrap><input name="opcion" type="radio" value="4" onClick="javascript: showDependencia(4);"></td>
							<td class="fileLabel"><cf_translate key="LB_Empleado">Empleado</cf_translate></td>
						<!--- </cfif> --->
					</tr>
					<tr>
						<td colspan="2">
							<strong>Fecha Corte:</strong>
						</td>
					</tr>
					<tr>
						<td colspan="2">
					
							<cfif isdefined ('form.RHPTUEid') and len(trim(form.RHPTUEid)) gt 0>
								<cfquery  name="rsData" datasource="#session.dsn#">
									select max(Fcorte) as Fcorte 
                                    from RHPTUD 
                                    where RHPTUEid = #form.RHPTUEid#
								</cfquery>
							<cfif len(trim(rsData.Fcorte)) gt 0>
								<cfset fecha=DateFormat(rsData.Fcorte,'DD/MM/YYYY')>
								<cf_sifcalendario form="formD" value="#fecha#" name="fecha" tabindex="1" readonly="true">
							<cfelse>
								<cfset fecha=DateFormat(Now(),'DD/MM/YYYY')>
								<cf_sifcalendario form="formD" value="#fecha#" name="fecha" tabindex="1">
							</cfif>
							</cfif>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		

		<!--- Inicia el pintado del los conlis segun lo seleccionado en los radios button --->
		<tr id="trCentroFuncional" style="display: none;">
			<td colspan="4">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
					<tr>
						<td colspan="4" class="tituloListas">&nbsp;</td>
					</tr>
					<tr>
						<td colspan="4" class="fileLabel"><cf_translate key="LB_Centro_funcional">Centro Funcional</cf_translate>:</td>
					</tr>
					<tr>
						<td nowrap><cf_rhcfuncional form="formD"></td>
						<td nowrap class="fileLabel"><input type="checkbox" name="CFdependencias" ><cf_translate key="LB_Incluir_dependencias">Incluir Dependencias</cf_translate></td>
						<td nowrap colspan="2">
							<input type="submit" name="BTN_Alta" id="BTN_Alta" value="#BTN_Agregar#" >
						</td>
					</tr>
				</table>
			</td>
		</tr>
		
		<tr id="trPuesto" style="display: none;">
			<td colspan="4">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
					<tr>
						<td colspan="4" class="tituloListas">&nbsp;</td>
					</tr>
					<tr>
						<td colspan="4" class="fileLabel"><cf_translate key="LB_Puesto">Puesto</cf_translate>:</td>
					</tr>
					<tr>
						<td nowrap><cf_rhpuesto form="formD"></td>
						<td nowrap colspan="2">
							<input type="submit" name="BTN_Alta" id="BTN_Alta" value="#BTN_Agregar#" >
						</td>
					</tr>
				</table>
			</td>
		</tr>
		
		<tr id="trOficinaDepto" style="display: none;">
			<td colspan="4">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
					<tr>
						<td colspan="4" class="tituloListas">&nbsp;</td>
					</tr>
					<tr>
						<td nowrap class="fileLabel"><cf_translate key="LB_Oficina">Oficina</cf_translate>:</td>
                        <td nowrap>
							<select name="Ocodigo">
								<cfloop query="rsOficina">
									<option value="#rsOficina.Ocodigo#" <cfif modoD EQ "CAMBIO" and isdefined('rsForm') and rsForm.Ocodigo EQ rsOficina.Ocodigo> selected</cfif>>#rsOficina.Oficodigo# - #rsOficina.Odescripcion#</option>
								</cfloop>
							</select>
						</td>
                    </tr>
                    <tr>
						<td nowrap class="fileLabel"><cf_translate key="LB_Departamento">Departamento</cf_translate>:</td>
                        <td nowrap>
							<select name="Dcodigo">
								<cfloop query="rsDepartamento">
									<option value="#rsDepartamento.Dcodigo#" <cfif modoD EQ "CAMBIO" and isdefined('rsForm') and rsForm.Dcodigo EQ rsDepartamento.Dcodigo> selected</cfif>>#rsDepartamento.Deptocodigo# - #rsDepartamento.Ddescripcion#</option>
								</cfloop>
							</select>
						</td>
					</tr>
					<tr>
						<td nowrap colspan="4" align="center">
							<input type="submit" name="BTN_Alta" id="BTN_Alta" value="#BTN_Agregar#" >
						</td>
					</tr>
				</table>
			</td>
		</tr>
		
		<tr id="trTipoPuesto" style="display: none;">
			<td colspan="4">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
					<tr>
						<td colspan="4" class="tituloListas">&nbsp;</td>
					</tr>
					<tr>
						<td colspan="4" class="fileLabel"><cf_translate key="LB_Tipo_de_puesto">Tipo de Puestos</cf_translate>:</td>
					</tr>
					<tr>			
						<td nowrap colspan="3">
							<cf_rhtipo_puesto form="formD">
						</td>
						<td nowrap>
							<input type="submit" name="BTN_Alta" id="BTN_Alta" value="#BTN_Agregar#" >
						</td>
					</tr>
				</table>
			</td>
		</tr>

		<tr id="trEmpleado" style="display: none;">
			<td colspan="4">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
					<tr>
						<td colspan="4" class="tituloListas">&nbsp;</td>
					</tr>
					<tr>
						<td colspan="4" class="fileLabel"><cf_translate key="LB_Empleado">Empleado</cf_translate>:</td>
					</tr>
					<tr>			
						<td nowrap colspan="3">
							<table>
								<tr>																
								  	<td>
										<input type="hidden" name="DEid" value="">
                                        <input type="text" name="DEidentificacion" id="DEidentificacion" value="" tabindex="" size="20" onBlur="javascript: funcTraerEmpleado(this.value);">
										<input type="text" name="Nombre" id="Nombre" value="" tabindex="" size="40" disabled>
										<a href="javascript: doConlisEmpleados();" onMouseOver="javascript: window.status=''; return true;" onMouseOut="javascript: window.status=''; return true;" tabindex="-1"><img src="/cfmx/rh/imagenes/Description.gif" alt="#LB_Lista_de_empleados#" name="imagen" width="18" height="14" border="0" align="absmiddle"></a>
									</td>	
								</tr>
							</table>
						</td>
						<td nowrap>
							<input type="submit" name="BTN_Alta" id="BTN_Alta" value="#BTN_Agregar#" >
						</td>
					</tr>
					
				</table>
			</td>
		</tr>		
		<!--- Final el pintado del los conlis segun lo seleccionado en los radios button --->

		<tr>
			<td colspan="4">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="4">
				<table width="100%" cellpadding="0" cellspacing="0" border="0">
					<tr>
						<td colspan="4" class="tituloListas"><span class="style2"><cf_translate key="LB_Lista_de_Dependientes">Lista de Dependientes</cf_translate></span></td>
					</tr>
				</table>
				<div id="divComponentes" style="overflow:auto; height: 135; margin:0" >
					<table width="600" cellpadding="0" cellspacing="0" border="0">
						
						<!--- Consulta de los Centros Funcionales --->
						<cfif isdefined("Form.RHPTUEid") and len(trim(Form.RHPTUEid))>
							<cfquery name="rsCentroFuncional" datasource="#session.DSN#">
								select a.RHPTUDid, a.CFid, b.CFcodigo, b.CFdescripcion
								from RHPTUD a
									inner join CFuncional b
										on a.CFid = b.CFid
										and a.Ecodigo = b.Ecodigo
								where a.RHPTUEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPTUEid#">
									and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
									and a.CFid is not null
							</cfquery>			
						</cfif>
						<cfif isdefined("rsCentroFuncional") and rsCentroFuncional.recordcount GT 0 >
							<tr>
								<td class="fileLabel">&nbsp;&nbsp;<cf_translate key="LB_Centro_Funcional">Centro Funcional</cf_translate></td>
							</tr>
							<tr>
								<td>
									<table width="90%" cellpadding="0" cellspacing="0" border="0" align="center">
										<tr>
											<td width="90%"><strong><cf_translate key="LB_Descripcion">Descripci&oacute;n</cf_translate></strong></td>
											<td width="10%" align="center">&nbsp;</td>
										</tr>
										<cfloop query="rsCentroFuncional">
											<tr nowrap align="left" class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif> onMouseOver="style.backgroundColor='##E4E8F3';" onMouseOut="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';" >
												<td width="90%" height="20">&nbsp;&nbsp;#rsCentroFuncional.CFcodigo# - #rsCentroFuncional.CFdescripcion#</td>
												<td width="10%" align="right">
													<input name="btnEliminar" type="image" alt="#LB_Eliminar_el_Centro_Funcional#"  onClick="javascript: return EliminarDAM('#rsCentroFuncional.RHPTUDid#','1');"  src="/cfmx/rh/imagenes/Borrar01_T.gif" width="16" height="16" tabindex="-1">
												</td>
											</tr>					
										</cfloop>
									</table>
								</td>
							</tr>
							<tr>
								<td nowrap>&nbsp;</td>
							</tr>
						</cfif>
						
						<!--- Consulta de Oficinas y Departamentos --->						
						<cfif isdefined("Form.RHPTUEid") and len(trim(Form.RHPTUEid))>
							<cfquery name="rsOficinaDepto" datasource="#session.DSN#">
								select a.RHPTUDid, a.Ocodigo, a.Dcodigo, b.Oficodigo, b.Odescripcion, c.Deptocodigo, Ddescripcion
								from RHPTUD a
									left outer join Oficinas b
										on a.Ocodigo = b.Ocodigo
										and a.Ecodigo = b.Ecodigo		
									left outer join Departamentos c
										on a.Dcodigo = c.Dcodigo
										and a.Ecodigo = c.Ecodigo
								where a.RHPTUEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPTUEid#">
									and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
									and a.Ocodigo is not null
									and a.Dcodigo is not null
							</cfquery>
						</cfif>
						<cfif isdefined("rsOficinaDepto") and rsOficinaDepto.recordcount GT 0 >
							<tr>
								<td class="fileLabel">&nbsp;&nbsp;<cf_translate key="LB_Oficina/Departamento">Oficina/Departamento</cf_translate></td>
							</tr>
							<tr>
								<td>
									<table width="90%" cellpadding="0" cellspacing="0" border="0" align="center">
										<tr>
											<td class="fileLabel"><cf_translate key="LB_Oficina">Oficina</cf_translate></td>
											<td nowrap>&nbsp;</td>
											<td class="fileLabel"><cf_translate key="LB_Departamento">Departamento</cf_translate></td>
											<td nowrap>&nbsp;</td>

										</tr>
										<cfloop query="rsOficinaDepto">
											<tr nowrap align="left" class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif> onMouseOver="style.backgroundColor='##E4E8F3';" onMouseOut="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';" >
												<td height="20">&nbsp;&nbsp;#rsOficinaDepto.Oficodigo# - #rsOficinaDepto.Odescripcion#</td>
												<td nowrap>&nbsp;</td>
												<td height="20">&nbsp;&nbsp;#rsOficinaDepto.Deptocodigo# - #rsOficinaDepto.Ddescripcion#</td>
												<td width="10%" align="right">
													<input name="btnEliminar" type="image" alt="#LB_Eliminar_la_OficinaDepartamento#"  onClick="javascript: return EliminarDAM('#rsOficinaDepto.RHPTUDid#','2');"  src="/cfmx/rh/imagenes/Borrar01_T.gif" width="16" height="16" tabindex="-1">
												</td>
											</tr>					
										</cfloop>
									</table>
								</td>
							</tr>
							<tr>
								<td nowrap>&nbsp;</td>
							</tr>
						</cfif>
						
						<!--- Consulta de Puesto --->						
						<cfif isdefined("Form.RHPTUEid") and len(trim(Form.RHPTUEid))>
							<cfquery name="rsTipoPuesto" datasource="#session.DSN#">
								select a.RHPTUDid, 
								coalesce(ltrim(rtrim(b.RHPcodigoext)),ltrim(rtrim(b.RHPcodigo))) as RHPcodigo
								, b.RHPdescpuesto
								from RHPTUD a
									inner join RHPuestos b
									on a.RHPcodigo = b.RHPcodigo
									and a.Ecodigo = b.Ecodigo
								where a.RHPTUEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPTUEid#">
									and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
									and a.RHPcodigo is not null
							</cfquery>
						</cfif>
						<cfif isdefined("rsTipoPuesto") and rsTipoPuesto.recordcount GT 0 >
							<tr>
								<td class="fileLabel">&nbsp;&nbsp;<cf_translate key="LB_Tipo_de_puesto">Puestos</cf_translate></td>
							</tr>
							<tr>
								<td>
									<table width="90%" cellpadding="0" cellspacing="0" border="0" align="center">
										<tr>
											<td class="fileLabel"><cf_translate key="LB_Descripcion">Descripci&oacute;n</cf_translate></td>
											<td nowrap>&nbsp;</td>
										</tr>
										<cfloop query="rsTipoPuesto">
											<tr nowrap align="left" class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif> onMouseOver="style.backgroundColor='##E4E8F3';" onMouseOut="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';" >
												<td height="20">&nbsp;&nbsp;#rsTipoPuesto.RHPcodigo# - #rsTipoPuesto.RHPdescpuesto#</td>
												<td width="10%" align="right">
													<input name="btnEliminar" type="image" alt="#LB_Eliminar_el_Tipo_de_Puesto#"  onClick="javascript: return EliminarDAM('#rsTipoPuesto.RHPTUDid#','3');"  src="/cfmx/rh/imagenes/Borrar01_T.gif" width="16" height="16" tabindex="-1">
												</td>
											</tr>					
										</cfloop>
									</table>
								</td>
							</tr>
							<tr><td nowrap>&nbsp;</td></tr>
						</cfif>
						
						<!--- Consulta de Tipo de Puesto --->						
						<cfif isdefined("Form.RHPTUEid") and len(trim(Form.RHPTUEid))>
							<cfquery name="rsTipoPuesto" datasource="#session.DSN#">
								select a.RHTPid, a.RHPTUDid,
								b.RHTPcodigo, b.RHTPdescripcion
								from RHPTUD a
									inner join RHTPuestos b
									on a.RHTPid = b.RHTPid
									and a.Ecodigo = b.Ecodigo
								where a.RHPTUEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPTUEid#">
									and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
							</cfquery>
						</cfif>
						<cfif isdefined("rsTipoPuesto") and rsTipoPuesto.recordcount GT 0 >
							<tr>
								<td class="fileLabel">&nbsp;&nbsp;<cf_translate key="LB_Tipo_de_puesto">Tipo de Puesto</cf_translate></td>
							</tr>
							<tr>
								<td>
									<table width="90%" cellpadding="0" cellspacing="0" border="0" align="center">
										<tr>
											<td class="fileLabel"><cf_translate key="LB_Descripcion">Descripci&oacute;n</cf_translate></td>
											<td nowrap>&nbsp;</td>
										</tr>
										<cfloop query="rsTipoPuesto">
											<tr nowrap align="left" class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif> onMouseOver="style.backgroundColor='##E4E8F3';" onMouseOut="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';" >
												<td height="20">&nbsp;&nbsp;#rsTipoPuesto.RHTPcodigo# - #rsTipoPuesto.RHTPdescripcion#</td>
												<td width="10%" align="right">
													<input name="btnEliminar" type="image" alt="#LB_Eliminar_el_Tipo_de_Puesto#"  onClick="javascript: return EliminarDAM('#rsTipoPuesto.RHPTUDid#','5');"  src="/cfmx/rh/imagenes/Borrar01_T.gif" width="16" height="16" tabindex="-1">
												</td>
											</tr>					
										</cfloop>
									</table>
								</td>
							</tr>
							<tr><td nowrap>&nbsp;</td></tr>
						</cfif>
						<!--- Consulta de Empleados --->												
						<cfif isdefined("Form.RHPTUEid") and len(trim(Form.RHPTUEid))>
							<cfquery name="rsEmpleados" datasource="#session.DSN#">
								select a.RHPTUDid, a.DEid,
									{fn concat({fn concat({fn concat({ fn concat(rtrim(b.DEnombre), ' ') },rtrim(b.DEapellido1))}, ' ')},rtrim(b.DEapellido2)) } as nombre,
									b.DEidentificacion
								from RHPTUD a
									left outer join DatosEmpleado b
									on a.DEid = b.DEid
									and a.Ecodigo = b.Ecodigo
								where a.RHPTUEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPTUEid#">
									and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
									and a.DEid is not null
							</cfquery>
						</cfif>
						<cfif isdefined("rsEmpleados") and rsEmpleados.recordcount GT 0 >
							<tr>
								<td class="fileLabel">&nbsp;&nbsp;<cf_translate key="LB_Empleados">Empleados</cf_translate></td>
							</tr>
							<tr>
								<td>
									<table width="90%" cellpadding="0" cellspacing="0" border="0" align="center">
										<tr>
											<td class="fileLabel"><cf_translate key="LB_Nombre">Nombre</cf_translate></td>
											<td nowrap>&nbsp;</td>
										</tr>
										<cfloop query="rsEmpleados">
											<tr nowrap align="left" class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif> onMouseOver="style.backgroundColor='##E4E8F3';" onMouseOut="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';" >
												<td height="20">&nbsp;&nbsp;#rsEmpleados.DEidentificacion# - #rsEmpleados.nombre#</td>
												<td width="10%" align="right">
													<input name="btnEliminar" type="image" alt="#LB_Eliminar_el_Empleado#"  onClick="javascript: return EliminarDAM('#rsEmpleados.RHPTUDid#','4');"  src="/cfmx/rh/imagenes/Borrar01_T.gif" width="16" height="16" tabindex="-1">
												</td>
											</tr>					
										</cfloop>
									</table>
								</td>
							</tr>
							<tr>
								<td nowrap>&nbsp;</td>
							</tr>
						</cfif>
					</table>
				</div>
			</td>
		</tr>
		<tr>
			<td colspan="4">
				<cf_botones names="btnGenerar" values="#BTN_Generar_Empleados#">
			</td>
		</tr>
		<tr>
			<td colspan="4">&nbsp;</td>
		</tr>
	</table>
	<iframe id="fr_empleados" name="fr_empleados" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src=""></iframe>
</form>
</cfoutput>

<cf_qforms form="formD" objForm="objFormD">	
<script language="javascript" type="text/javascript">
	<cfoutput>	
	objFormD.CFid.description = "#MSG_Centro_Funcional#";
	objFormD.Ocodigo.description = "#MSG_Oficina#";
	objFormD.Dcodigo.description = "#MSG_Departamento#";
	objFormD.RHPcodigo.description = "#MSG_Puesto#";
	objFormD.DEid.description = "#MSG_Empleado#";
	objFormD.RHTPcodigo.description = "#MSG_Tipo_de_Puesto#";
	</cfoutput>
	
	function funcbtnRegresar(){
		deshabilitar();
		document.formD.paso.value = "3";
	}
	function funcbtnSiguiente(){
		deshabilitar();
		document.formD.paso.value = "5";
	}
	
	function funcbtnGenerar() {
		deshabilitar();
	}

	showDependencia(1);

</script>
