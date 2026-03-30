<!--- Consultas --->
<!--- Consulta de Almacenes --->
<cf_dbfunction name="now" returnvariable="hoy">
<cfquery name="rsAlmacenes" datasource="#Session.DSN#">
	select Aid, Bdescripcion
	from Almacen 
	where Ecodigo =  #Session.Ecodigo# 
</cfquery>
<cf_dbfunction name="OP_concat" returnvariable="_Cat">
<!--- Javascripts de Validaciones --->
<script language="JavaScript1.2" type="text/javascript" src="../../js/utilesMonto.js"></script>
<table width="100%" border="0" cellspacing="0">
  <tr>
    <td nowrap width="100%" align="center">
		<cf_web_portlet_start titulo="Activos Fijos Asignados">
		<cfoutput>
		<form action="vales_responsale_sql.cfm" method="post" name="formTransferir">
		<input type="hidden" name="action" value="#CurrentPage#">
		<cfif isdefined("form.Aid")>
			<input type="hidden" name="params" value="?Aid=#form.Aid#">
		<cfelse>
			<input type="hidden" name="params" value="?DEid=#form.DEid#">
		</cfif>
		</cfoutput>
			<input name="MODO" type="hidden" value="">
			<table width="100%" border="0" cellspacing="0">
			  <tr>
				<td nowrap width="5%" align="center">&nbsp;</td>
				<td nowrap width="90%" align="center">&nbsp;</td>
				<td nowrap width="5%" align="center">&nbsp;</td>
			  </tr>
			  <tr>
				<td nowrap width="5%" align="center">&nbsp;</td>
				<td nowrap width="90%" align="center">
					<cfif isdefined("form.Aid")>
						<cfset filtro = "and b.Alm_Aid = #form.Aid#">
					<cfelse>
						<cfset filtro = "and b.DEid = #form.DEid#">
					</cfif>
					<cfinvoke 
					 component="sif.Componentes.pListas"
					 method="pLista"
					 returnvariable="pListaRet">
					 	<cfinvokeargument name="debug" value="N">
						<cfinvokeargument name="tabla" value="Activos a, AFResponsables b"/>
																	<!--- convert(varchar,a.Aid) as Aid,	--->
						<cfinvokeargument name="columnas" value="	a.Aplaca,	
																	convert(varchar,b.AFRid) as AFRid,
																	a.Adescripcion,
																	convert(varchar,b.AFRfini,103) as AFRfini,
																	case 
																		when (select count(1) from AFTResponsables c where b.AFRid = c.AFRid) < 1 then 'Normal' 
																		else (	select 'Transferido a ' #_Cat# 	case
																										when d.DEid is not null then d.DEnombre #_Cat# ' ' #_Cat# d.DEapellido1 #_Cat# ' ' #_Cat# d.DEapellido2
																										when e.Aid is not null  then e.Bdescripcion
																									end #_Cat#
																					' desde el ' #_Cat# convert(varchar,c.AFTRfini,103) #_Cat# '.'
																				from AFTResponsables c, DatosEmpleado d, Almacen e 
																				where b.AFRid = c.AFRid	
																				and c.DEid *= d.DEid
																				and c.Aid *= e.Aid
																			)
																	end as Estado,
																	btnConsultar='btnConsultar'"/>
						<cfinvokeargument name="desplegar" value="Aplaca,
																Adescripcion,
																AFRfini,
																Estado"/>
						<cfinvokeargument name="etiquetas" value="Placa, Descripción del Activo, Recibido desde, Estado Actual"/>
						<cfinvokeargument name="formatos" value="S,S,D,S"/>
						<cfinvokeargument name="filtro" value="  a.Ecodigo = #Session.Ecodigo#
																#filtro#
																and #hoy# between b.AFRfini and b.AFRffin
																and a.Aid = b.Aid
																order by a.Aplaca"/>
						<cfinvokeargument name="align" value="left,left,center,left"/>
						<cfinvokeargument name="ajustar" value="N"/>
						<cfinvokeargument name="showLink" value="false"/>
						<cfinvokeargument name="checkboxes" value="S"/>
						<cfinvokeargument name="keys" value="AFRid"/>
						<cfinvokeargument name="incluyeForm" value="false"/>
						<cfinvokeargument name="formname" value="formTransferir"/>
						<cfinvokeargument name="showEmptyListMsg" value="yes"/>
					</cfinvoke>
				</td> 
				<td nowrap width="5%" align="center">&nbsp;</td>
			  </tr>
			  <tr>
				<td nowrap width="5%" align="center">&nbsp;</td>
				<td nowrap width="90%" align="center">
						<fieldset><legend>Transferencia de Activos</legend>
						<table width="90%" border="0" cellspacing="0" align="center">
						  <tr>
						  	<td nowrap colspan="3">&nbsp;</td>
						  </tr>
						  <tr>
							<td nowrap class="tiulolistas">Transferir a Empleado:</td>
							<td nowrap class="tiulolistas">Transferir a Almacén:</td>
							<td nowrap class="tiulolistas">A partir de:</td>
						  </tr>
						  <tr>
							<td nowrap>
								<cf_rhempleado form="formTransferir" size="60">
							</td>
							<td nowrap>
								<select name="Aid">
									<option value=""></option>
								  <cfoutput query="rsAlmacenes"> 
									<option value="#rsAlmacenes.Aid#">#rsAlmacenes.Bdescripcion#</option>
								  </cfoutput> 
								 </select>
							</td>
							<td nowrap>
								<cf_sifcalendario value="#LSDateFormat(Now(),'dd/mm/yyyy')#" form="formTransferir">
							</td>
						  </tr>
						  <tr>
						  	<td nowrap colspan="3" align="center">
								<input name="btnTransferir" type="submit" value="Transferir">
							</td>
						  </tr>
						  <tr>
						  	<td nowrap colspan="3">&nbsp;</td>
						  </tr>
						</table>
						</fieldset>
				</td>
				<td nowrap width="5%" align="center">&nbsp;</td>
			  </tr>
			  <tr>
				<td nowrap width="5%" align="center">&nbsp;</td>
				<td nowrap width="90%" align="center">&nbsp;</td>
				<td nowrap width="5%" align="center">&nbsp;</td>
			  </tr>
			</table>
			<input type="hidden" name="lerror" value="optional">
		</form>
		<cf_web_portlet_end>
	</td>
  </tr>
  <tr>
    <td nowrap width="100%" align="center">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Activos Fijos Por Recibir">
			<table width="100%" border="0" cellspacing="0">
			  <tr>
				<td nowrap width="5%" align="center">&nbsp;</td>
				<td nowrap width="90%" align="center">&nbsp;</td>
				<td nowrap width="5%" align="center">&nbsp;</td>
			  </tr>
			  <tr>
				<td nowrap width="5%" align="center">&nbsp;</td>
				<td nowrap width="90%" align="center">
					<cfif isdefined("form.Aid")>
						<cfset filtro = "and c.Aid = #form.Aid#">
						<cfset params = "'?Aid=#form.Aid#' as params">
					<cfelse>
						<cfset filtro = "and c.DEid = #form.DEid#">
						<cfset params = "'?DEid=#form.DEid#' as params">
					</cfif>
					<cfinvoke 
					 component="sif.Componentes.pListas"
					 method="pLista"
					 returnvariable="pListaRet">
						<cfinvokeargument name="debug" value="N">	
						<cfinvokeargument name="tabla" value="Activos a, AFResponsables b, AFTResponsables c, DatosEmpleado d, Almacen e"/>
						<cfinvokeargument name="columnas" value="	
											a.Aplaca,	
											convert(varchar,c.AFTRid) as AFTRid,
											a.Adescripcion,
											convert(varchar,c.AFTRfini,103) as AFTRfini,
											case when b.DEid is not null then d.DEnombre #_Cat# ' ' #_Cat# d.DEapellido1 #_Cat# ' ' #_Cat# d.DEapellido2
												when b.Aid is not null then e.Bdescripcion
											end as RAnterior,
											case when b.DEid is not null then d.DEidentificacion
												else ''
											end as Cedula,
											btnConsultar='btnConsultar',
											action = '#CurrentPage#',
											#params#
											"/>
						<cfinvokeargument name="desplegar" value="Aplaca,
																Adescripcion,
																AFTRfini,
																RAnterior,
																Cedula"/>
						<cfinvokeargument name="etiquetas" value="Placa, Descripción del Activo, Transferido desde, Transferido por, Cédula"/>
						<cfinvokeargument name="formatos" value="S,S,D,S,S"/>
						<cfinvokeargument name="filtro" value=" b.Ecodigo = #Session.Ecodigo#
																#filtro#
																and b.Aid = a.Aid
																and b.AFRid = c.AFRid
																and b.DEid *= d.DEid
																and b.Alm_Aid *= e.Aid
																order by a.Aplaca"/>
						<cfinvokeargument name="align" value="left,left,center,left,left"/>
						<cfinvokeargument name="ajustar" value="N"/>
						<cfinvokeargument name="showLink" value="false"/>
						<cfinvokeargument name="checkboxes" value="S">
						<cfinvokeargument name="keys" value="AFTRid"/>
						<cfinvokeargument name="botones" value="Recibir, Rechazar">
						<cfinvokeargument name="formName" value="formRecibir">
						<cfinvokeargument name="irA" value="vales_responsale_sql.cfm">
						<cfinvokeargument name="showEmptyListMsg" value="yes"/>
					</cfinvoke>
				</td>
				<td nowrap width="5%" align="center">&nbsp;</td>
			  </tr>
			  <tr>
				<td nowrap width="5%" align="center">&nbsp;</td>
				<td nowrap width="90%" align="center">&nbsp;</td>
				<td nowrap width="5%" align="center">&nbsp;</td>
			  </tr>
			</table>
		<cf_web_portlet_end>
	</td>
  </tr>
</table>
<!--- Validaciones c/ Qforms --->
<cf_qforms form="formTransferir">
<script language="JavaScript1.2" type="text/javascript">
	<!--//
	//AFAdescripcion
	objForm.fecha.required = true;
	objForm.fecha.description = "Fecha";
	//Define el foco
	objForm.DEidentificacion.obj.focus();
	//Agrega validación adicional
	function _customValidations(){
		if (!algunoMarcado(document.formTransferir)){
			objForm.lerror.throwError("Debe marcar uno o más registros, de la lista de activos fijos asignados, para transferirlos.");
		}
		if (objForm.DEidentificacion.getValue()==""&&objForm.Aid.getValue()==""){
			objForm.DEidentificacion.throwError("Debe definir un responsable, un empleado o un almacén, quien va a recibir el Activo.");
		}
		if (objForm.DEidentificacion.getValue()!=""&&objForm.Aid.getValue()!=""){
			objForm.DEidentificacion.throwError("Debe definir un único responsable, no puede ser un empleado y un almacén.");
		}
	}
	objForm.onValidate = _customValidations;
	function algunoMarcado(f) {
		if (f.chk) {
			if (f.chk.value) {
				return (f.chk.checked);
			} else {
				for (var i=0; i<f.chk.length; i++) {
					if (f.chk[i].checked) return true;
				}
			}
		}
		return false;
	}
	function funcRecibir(){
		if (!algunoMarcado(document.formRecibir)){
			alert("Sepresentaron los siguientes errores:\n - Debe marcar uno o más registros, de la lista de activos fijos por recibir, para recibirlos.");
			return false;
		}
		document.formRecibir.ACTION.value = document.formRecibir.ACTION_1.value;
		document.formRecibir.PARAMS.value = document.formRecibir.PARAMS_1.value;
		return true;
	}
	function funcRechazar(){
		if (!algunoMarcado(document.formRecibir)){
			alert("Sepresentaron los siguientes errores:\n - Debe marcar uno o más registros, de la lista de activos fijos por recibir, para rechazarlos.");
			return false;
		}
		document.formRecibir.ACTION.value = document.formRecibir.ACTION_1.value;
		document.formRecibir.PARAMS.value = document.formRecibir.PARAMS_1.value;
		return true;
	}
	//-->
</script>