<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="BTN_Anterior" Default="Anterior" returnvariable="BTN_Anterior" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="BTN_Generar_Empleados" Default="Generar Empleados" returnvariable="BTN_Generar_Empleados" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="BTN_Siguiente" Default="Siguiente" returnvariable="BTN_Siguiente" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_el_Centro_Funcional" Default="el Centro Funcional?"	 returnvariable="MSG_el_Centro_Funcional" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_TipoPuesto" Default="el Tipo de Puesto?"	 returnvariable="MSG_TipoPuesto" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_la_OficinaDepartamento" Default="la Oficina/Departamento?"	 returnvariable="MSG_la_OficinaDepartamento" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_el_Tipo_de_Puesto" Default="el Tipo de Puesto?"	 returnvariable="MSG_el_Tipo_de_Puesto" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_el_Empleado" Default="el Empleado?"	 returnvariable="MSG_el_Empleado" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_Desea_eliminar" Default="Desea eliminar" returnvariable="MSG_Desea_eliminar" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="BTN_Agregar" Default="Agregar" XmlFile="/rh/generales.xml" returnvariable="BTN_Agregar"component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="LB_Lista_de_empleados" Default="Lista de empleados"	 returnvariable="LB_Lista_de_empleados" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Eliminar_el_Centro_Funcional" Default="Eliminar el Centro Funcional"	returnvariable="LB_Eliminar_el_Centro_Funcional" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Eliminar_la_OficinaDepartamento" Default="Eliminar la Oficina/Departamento"	 returnvariable="LB_Eliminar_la_OficinaDepartamento" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Eliminar_el_Tipo_de_Puesto" Default="Eliminar el Tipo de Puesto"	 returnvariable="LB_Eliminar_el_Tipo_de_Puesto" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Eliminar_el_Empleado" Default="Eliminar el Empleado"	 returnvariable="LB_Eliminar_el_Empleado" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="MSG_Centro_Funcional" Default="Centro Funcional"	 returnvariable="MSG_Centro_Funcional" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_Oficina" Default="Oficina"	 returnvariable="MSG_Oficina" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_Departamento" Default="Departamento"	 returnvariable="MSG_Departamento" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_Tipo_de_Puesto" Default="Tipo de Puesto"	 returnvariable="MSG_Tipo_de_Puesto" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_Empleado" Default="Empleado"	 returnvariable="MSG_Empleado" component="sif.Componentes.Translate" method="Translate" />	
<cfinvoke Key="MSG_Puesto" Default="Puesto"	 returnvariable="MSG_Puesto" component="sif.Componentes.Translate" method="Translate"/>	

<!--- FIN VARIABLES DE TRADUCCION --->
<!--- Consultas de Seleccin de Empleados --->
<!---En caso de que el tipo de accion que estoy manejando sea tipo anualidad--->
<cfquery name="Anua" datasource="#session.dsn#">
	select RHTAanualidad 
	from RHAccionesMasiva a
		inner join RHTAccionMasiva b
		on b.RHTAid=a.RHTAid
	where RHAid=#form.RHAid#
</cfquery>

<cfif len(trim(Anua.RHTAanualidad)) eq 0 or Anua.RHTAanualidad eq 0>
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
		select RHAfdesde, RHAfhasta
		from RHAccionesMasiva
		where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHAid#"> 
	</cfquery>
	
	<!---================ TRADUCCION =================----->
	
	
	
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
	
			objForm.CFid.required      = ((p==1)?true:false);
			objForm.Ocodigo.required   = ((p==2)?true:false);
			objForm.Dcodigo.required   = ((p==2)?true:false);
			objForm.RHPcodigo.required = ((p==3)?true:false);
			objForm.DEid.required      = ((p==4)?true:false);
			objForm.RHTPcodigo.required= ((p==5)?true:false);
			
		}
		
		function EliminarDAM(id,valor) {
			<cfoutput>
			if (valor == 1) { var msg = '#MSG_el_Centro_Funcional#'; }
			if (valor == 2) { var msg = '#MSG_la_OficinaDepartamento#'; }
			if (valor == 3) { var msg = '#MSG_el_Tipo_de_Puesto#'; }
			if (valor == 4) { var msg = '#MSG_el_Empleado#'; }
			if (valor == 5) { var msg = '#MSG_TipoPuesto#'; }
	
			if (confirm('#MSG_Desea_eliminar# ' + msg)) {
				document.form1.RHDAMid.value = id;
				document.form1.DAMAccion.value = "BAJA";
				deshabilitar();
				return true;
			}
			return false;
			</cfoutput>
		}
		
		function deshabilitar() {
			objForm.CFid.required      = false;
			objForm.Ocodigo.required   = false;
			objForm.Dcodigo.required   = false;
			objForm.RHPcodigo.required = false;
			objForm.DEid.required      = false;
			objForm.RHTPcodigo.required= false;
		}
		
		function ResetEmployee() {
			document.form1.DEid.value = "";
			document.form1.DEidentificacion.value = "";
			document.form1.Nombre.value = "";
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
			params = params + '?po_form=form1';
			<cfif isdefined("rsAccion") and rsAccion.RecordCount NEQ 0 and len(trim(rsAccion.RHAfdesde)) and len(trim(rsAccion.RHAfhasta))>
				<cfoutput>
					params = params + '&pd_acciondesde=#LSDateFormat(rsAccion.RHAfdesde,"dd/mm/yyyy")#&pd_accionhasta=#LSDateFormat(rsAccion.RHAfhasta,"dd/mm/yyyy")#';
				</cfoutput>
			</cfif>
			popUpWindow("/cfmx/rh/nomina/masiva/ConlisEmpleadosAccionMasiva.cfm"+params,200,180,650,400);		
		}
		
		function funcTraerEmpleado(prn_DEidentificacion){
			var params = '';
			if (prn_DEidentificacion!=''){	
				<cfif isdefined("rsAccion") and rsAccion.RecordCount NEQ 0 and len(trim(rsAccion.RHAfdesde)) and len(trim(rsAccion.RHAfhasta))>
					<cfoutput>
						params = params + '&pd_acciondesde=#LSDateFormat(rsAccion.RHAfdesde,"dd/mm/yyyy")#&pd_accionhasta=#LSDateFormat(rsAccion.RHAfhasta,"dd/mm/yyyy")#';
					</cfoutput>
				</cfif>
				document.getElementById("fr_empleados").src = '/cfmx/rh/nomina/masiva/SQLTraeEmpleadosAccionMasiva.cfm?DEidentificacion='+prn_DEidentificacion+'&po_form=form1'+params;
			}
			else{
				document.form1.DEid.value = '';
				document.form1.DEidentificacion.value = '';
				document.form1.Nombre.value = '';
			}
		}
	</script>
	
	<!--- Inicia el pintado de la pantalla de Seleccin de Empleados --->
	<style type="text/css">
		.style2 {color: #000066}
	</style>
	
	<cfoutput>
	<form name="form1" method="post" style="margin: 0;" action="accionesMasiva-sql.cfm">
		<cfinclude template="accionesMasiva-hiddens.cfm">	
		<input type="hidden" name="RHDAMid" id="RHDAMid" value="">
		<input type="hidden" name="DAMAccion" id="DAMAccion" value="">
		<table width="90%" border="0" cellspacing="0" cellpadding="1" align="center">
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
							<cfif isdefined("rsDatosAccion") and  rsDatosAccion.RHTAperiodos EQ 0>
								<td nowrap><input name="opcion" type="radio" value="4" onClick="javascript: showDependencia(4);"></td>
								<td class="fileLabel"><cf_translate key="LB_Empleado">Empleado</cf_translate></td>
							</cfif>
						</tr>
						<tr>
							<td colspan="2">
								<strong>Fecha Corte:</strong>
							</td>
						</tr>
						<tr>
							<td colspan="2">
						
								<cfif isdefined ('form.RHAid') and len(trim(form.RHAid)) gt 0>
									<cfquery  name="rsData" datasource="#session.dsn#">
										select max(Fcorte) as Fcorte from RHDepenAccionM where RHAid = #form.RHAid#
									</cfquery>
								<cfif len(trim(rsData.Fcorte)) gt 0>
									<cfset fecha=DateFormat(rsData.Fcorte,'DD/MM/YYYY')>
									<cf_sifcalendario form="form1" value="#fecha#" name="fecha" tabindex="1" readonly="true">
								<cfelse>
									<cfset fecha=DateFormat(Now(),'DD/MM/YYYY')>
									<cf_sifcalendario form="form1" value="#fecha#" name="fecha" tabindex="1">
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
							<td nowrap><cf_rhcfuncional></td>
							<td nowrap class="fileLabel"><input type="checkbox" name="CFdependencias" ><cf_translate key="LB_Incluir_dependencias">Incluir Dependencias</cf_translate></td>
							<td nowrap colspan="2">
								<input type="submit" name="DAMAlta" id="DAMAlta" value="#BTN_Agregar#" >
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
							<td nowrap><cf_rhpuesto></td>
							<td nowrap colspan="2">
								<input type="submit" name="DAMAlta" id="DAMAlta" value="#BTN_Agregar#" >
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
							<td nowrap class="fileLabel"><cf_translate key="LB_Departamento">Departamento</cf_translate>:</td>
							<td nowrap colspan="2">&nbsp;</td>
						</tr>
						<tr>
							<td nowrap>
								<select name="Ocodigo">
									<cfloop query="rsOficina">
										<option value="#rsOficina.Ocodigo#" <cfif modo EQ "CAMBIO" and isdefined('rsForm') and rsForm.Ocodigo EQ rsOficina.Ocodigo> selected</cfif>>#rsOficina.Oficodigo# - #rsOficina.Odescripcion#</option>
									</cfloop>
								</select>
							</td>
							<td nowrap>
								<select name="Dcodigo">
									<cfloop query="rsDepartamento">
										<option value="#rsDepartamento.Dcodigo#" <cfif modo EQ "CAMBIO" and isdefined('rsForm') and rsForm.Dcodigo EQ rsDepartamento.Dcodigo> selected</cfif>>#rsDepartamento.Deptocodigo# - #rsDepartamento.Ddescripcion#</option>
									</cfloop>
								</select>
							</td>
							<td nowrap colspan="2">
								<input type="submit" name="DAMAlta" id="DAMAlta" value="#BTN_Agregar#" >
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
								<cf_rhtipo_puesto>
							</td>
							<td nowrap>
								<input type="submit" name="DAMAlta" id="DAMAlta" value="#BTN_Agregar#" >
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
								<input type="submit" name="DAMAlta" id="DAMAlta" value="Agregar" >
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
							<cfif isdefined("Form.RHAid") and len(trim(Form.RHAid))>
								<cfquery name="rsCentroFuncional" datasource="#session.DSN#">
									select a.RHDAMid, a.CFid, b.CFcodigo, b.CFdescripcion
									from RHDepenAccionM a
										inner join CFuncional b
											on a.CFid = b.CFid
											and a.Ecodigo = b.Ecodigo
									where a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#">
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
														<input name="btnEliminar" type="image" alt="#LB_Eliminar_el_Centro_Funcional#"  onClick="javascript: return EliminarDAM('#rsCentroFuncional.RHDAMid#','1');"  src="/cfmx/rh/imagenes/Borrar01_T.gif" width="16" height="16" tabindex="-1">
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
							<cfif isdefined("Form.RHAid") and len(trim(Form.RHAid))>
								<cfquery name="rsOficinaDepto" datasource="#session.DSN#">
									select a.RHDAMid, a.Ocodigo, a.Dcodigo, b.Oficodigo, b.Odescripcion, c.Deptocodigo, Ddescripcion
									from RHDepenAccionM a
										left outer join Oficinas b
											on a.Ocodigo = b.Ocodigo
											and a.Ecodigo = b.Ecodigo		
										left outer join Departamentos c
											on a.Dcodigo = c.Dcodigo
											and a.Ecodigo = c.Ecodigo
									where a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#">
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
														<input name="btnEliminar" type="image" alt="#LB_Eliminar_la_OficinaDepartamento#"  onClick="javascript: return EliminarDAM('#rsOficinaDepto.RHDAMid#','2');"  src="/cfmx/rh/imagenes/Borrar01_T.gif" width="16" height="16" tabindex="-1">
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
							<cfif isdefined("Form.RHAid") and len(trim(Form.RHAid))>
								<cfquery name="rsTipoPuesto" datasource="#session.DSN#">
									select a.RHDAMid, 
									coalesce(ltrim(rtrim(b.RHPcodigoext)),ltrim(rtrim(b.RHPcodigo))) as RHPcodigo
									, b.RHPdescpuesto
									from RHDepenAccionM a
										inner join RHPuestos b
										on a.RHPcodigo = b.RHPcodigo
										and a.Ecodigo = b.Ecodigo
									where a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#">
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
														<input name="btnEliminar" type="image" alt="#LB_Eliminar_el_Tipo_de_Puesto#"  onClick="javascript: return EliminarDAM('#rsTipoPuesto.RHDAMid#','3');"  src="/cfmx/rh/imagenes/Borrar01_T.gif" width="16" height="16" tabindex="-1">
													</td>
												</tr>					
											</cfloop>
										</table>
									</td>
								</tr>
								<tr><td nowrap>&nbsp;</td></tr>
							</cfif>
							
							<!--- Consulta de Tipo de Puesto --->						
							<cfif isdefined("Form.RHAid") and len(trim(Form.RHAid))>
								<cfquery name="rsTipoPuesto" datasource="#session.DSN#">
									select a.RHTPid, a.RHDAMid,
									b.RHTPcodigo,b.RHTPdescripcion
									from RHDepenAccionM a
										inner join RHTPuestos b
										on a.RHTPid = b.RHTPid
										and a.Ecodigo = b.Ecodigo
									where a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#">
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
														<input name="btnEliminar" type="image" alt="#LB_Eliminar_el_Tipo_de_Puesto#"  onClick="javascript: return EliminarDAM('#rsTipoPuesto.RHDAMid#','5');"  src="/cfmx/rh/imagenes/Borrar01_T.gif" width="16" height="16" tabindex="-1">
													</td>
												</tr>					
											</cfloop>
										</table>
									</td>
								</tr>
								<tr><td nowrap>&nbsp;</td></tr>
							</cfif>
							<!--- Consulta de Empleados --->												
							<cfif isdefined("Form.RHAid") and len(trim(Form.RHAid))>
								<cfquery name="rsEmpleados" datasource="#session.DSN#">
									select a.RHDAMid, a.DEid,
										{fn concat({fn concat({fn concat({ fn concat(rtrim(b.DEnombre), ' ') },rtrim(b.DEapellido1))}, ' ')},rtrim(b.DEapellido2)) } as nombre,
										b.DEidentificacion
									from RHDepenAccionM a
										left outer join DatosEmpleado b
										on a.DEid = b.DEid
										and a.Ecodigo = b.Ecodigo
									where a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#">
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
														<input name="btnEliminar" type="image" alt="#LB_Eliminar_el_Empleado#"  onClick="javascript: return EliminarDAM('#rsEmpleados.RHDAMid#','4');"  src="/cfmx/rh/imagenes/Borrar01_T.gif" width="16" height="16" tabindex="-1">
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
				<td colspan="4">&nbsp;</td>
			</tr>		
			<tr>
				<td colspan="4">
					<cf_botones names="btnRegresar,btnGenerar,btnSiguiente" values="<< #BTN_Anterior#,#BTN_Generar_Empleados#,#BTN_Siguiente# >>">
				</td>
			</tr>
			<tr>
				<td colspan="4">&nbsp;</td>
			</tr>
		</table>
		<iframe id="fr_empleados" name="fr_empleados" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src=""></iframe>
	</form>
	</cfoutput>
	
	<cf_qforms>	
	<script language="javascript" type="text/javascript">
		<cfoutput>	
		objForm.CFid.description = "#MSG_Centro_Funcional#";
		objForm.Ocodigo.description = "#MSG_Oficina#";
		objForm.Dcodigo.description = "#MSG_Departamento#";
		objForm.RHPcodigo.description = "#MSG_Puesto#";
		objForm.DEid.description = "#MSG_Empleado#";
		objForm.RHTPcodigo.description = "#MSG_Tipo_de_Puesto#";
		</cfoutput>
		
		function funcbtnRegresar(){
			deshabilitar();
			document.form1.paso.value = "3";
		}
		function funcbtnSiguiente(){
			deshabilitar();
			document.form1.paso.value = "5";
		}
		
		function funcbtnGenerar() {
			deshabilitar();
		}
	
		showDependencia(1);
	
	</script>
<cfelse>
	<form name="form1" method="post" style="margin: 0;" action="accionesMasiva-sql.cfm">
	<cfinclude template="accionesMasiva-hiddens.cfm">	
	<input type="hidden" id="RHAnua" value="1" name="RHAnua" />
	<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
	<cfif isdefined ('form.RHAid') and len(trim(form.RHAid)) gt 0>
		<cfquery  name="rsData" datasource="#session.dsn#">
			select RHAfdesde from RHAccionesMasiva where RHAid = #form.RHAid#
		</cfquery>
		<cfset LvarFecha=#rsData.RHAfdesde#>
	<cfelse>
		<cfset LvarFecha=#now()#>
	</cfif>
	
	<cfquery name="rsEmp" datasource="#session.dsn#">
		select e.DEid,d.DEidentificacion,d.DEnombre#LvarCNCT#' ' #LvarCNCT#d.DEapellido1#LvarCNCT#' '#LvarCNCT#d.DEapellido2 as nombre ,EAid,DAtipoConcepto,e.Ecodigo
		from EAnualidad e
			inner join DatosEmpleado d
			on d.DEid=e.DEid
			and d.Ecodigo=#session.Ecodigo#
			inner join LineaTiempo c
			on  d.Ecodigo = c.Ecodigo
			and d.DEid = c.DEid
			and <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFecha#"> between c.LTdesde and c.LThasta	
		where 
		e.Ecodigo=#session.Ecodigo#
		and EAacum >= 345
		and EAacum <= 360
		and e.DAtipoConcepto=2
	</cfquery>

	<table width="100%">
		<tr>
			<td colspan="4" align="left"><strong><cf_translate key="LB_Este_proceso_no_incluye_a_los_empleados_que_cuenten_con_un_salario_negociado">Este proceso no incluye a los empleados que cuenten con un salario negociado</cf_translate></strong></td>
		</tr>
		<cfif rsEmp.recordcount gt 0>
            <tr>
                <td>
                    <cfinvoke 
						component="rh.Componentes.pListas"
						method="pListaQuery"
						returnvariable="pListaRet">
							<cfinvokeargument name="query" value="#rsEmp#"/>
							<cfinvokeargument name="desplegar" value="DEidentificacion,nombre"/>
							<cfinvokeargument name="etiquetas" value="Identificación, Nombre"/>
							<cfinvokeargument name="formatos" value="S,S"/>
							<cfinvokeargument name="showLink" value="false"/>
							<cfinvokeargument name="incluyeForm" value="false"/>	
							<cfinvokeargument name="align" value="left,left"/>
							<cfinvokeargument name="ajustar" value="S,S"/>
							<cfinvokeargument name="checkboxes" value="N"/>				
							<cfinvokeargument name="showEmptyListMsg" value="true"/>
							<cfinvokeargument name="keys" value="DEid"/>
							<cfinvokeargument name="ira" value="#CurrentPage#"/>
							<cfinvokeargument name="emptylistmsg" value="No existe empleados que cumplan con anualidades en estos momentos"/>
							<cfinvokeargument name="maxrows" value="0"/>
					</cfinvoke>			
				</td>
			</tr>
			<tr>
				<td colspan="4">
					<cf_botones names="btnRegresar,btnGenerar,btnSiguiente" values="<< #BTN_Anterior#,#BTN_Generar_Empleados#,#BTN_Siguiente# >>">
				</td>
			</tr>
		<cfelse>
			<tr><td colspan="2" align="center">No existe empleados que cumplan con anualidades en estos momentos</td></tr>
		</cfif>
	</table>
	</form>
</cfif>