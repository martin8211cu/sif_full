<!--- Asigna modos Concepto Deduc y Detalle Cconcepto Dedudccion (ConceptoDeduc/DConceptoDeduc)--->
<cfif isDefined("Form.DEid") and len(trim(Form.DEid)) gt 0>
	<cfset Form.modo = "EDITAR">
<cfelse>	
	<cfset Form.modo='ALTA'>
</cfif>
<cfif isdefined('form.btneliminar')>
	<cfinclude template="SalariosOtrosPatronosSQL.cfm">
</cfif>
<!--- VARIABLES DE TRADUCCION --->

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_EsteEmpleadoYaFueAgregado"
	Default="Este Empleado ya fue agregado"
	returnvariable="MSG_EsteEmpleadoYaFueAgregado"/>
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BotonCambiar"
	Default="Modificar"
	XmlFile="/sif/rh/generales.xml"
	returnvariable="BotonCambiar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BotonBorrar"
	Default="Eliminar"
	XmlFile="/sif/rh/generales.xml"
	returnvariable="BotonBorrar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BotonNuevo"
	Default="Nuevo"
	XmlFile="/sif/rh/generales.xml"
	returnvariable="BotonNuevo"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BotonAgregar"
	Default="Agregar"
	XmlFile="/sif/rh/generales.xml"
	returnvariable="BotonAgregar"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Salario_Base"
	Default="Salario Base"	
	returnvariable="LB_Salario_Base"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Identificacion"
	Default="Identificaci&oacute;n"	
	returnvariable="LB_Identificacion"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Nombre"
	Default="Nombre"	
	returnvariable="LB_Nombre"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Nombre"
	Default="Nombre"	
	returnvariable="LB_Nombre"/>		
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Apellido"
	Default="Apellido "	
	returnvariable="LB_Apellido"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Patrono"
	Default="Patrono "	
	returnvariable="LB_Patrono"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_codPatrono"
	Default="C&oacute;digo Patrono "	
	returnvariable="LB_codPatrono"/>	

<!--- JavaScript --->
 
<script language="JavaScript" type="text/javascript">
	function deshabilitarvalidacion(){
			objForm.DEid.required = false;
			objForm.SalarioBase.required = false;
			objForm.OPid.required = false;
	}
		
			//CHEQUEAR
	function funcChkAll(c) {
		if (document.formUsuario.chk) {
			if (document.formUsuario.chk.value) {
				if (!document.formUsuario.chk.disabled) { 
					document.formUsuario.chk.checked = c.checked;
					//funcChkSolicitud(document.filtro.chk);
				}
			} else {
				for (var counter = 0; counter < document.formUsuario.chk.length; counter++) {
					if (!document.formUsuario.chk[counter].disabled) {
						document.formUsuario.chk[counter].checked = c.checked;
						//funcChkSolicitud(document.form1.ESidsolicitud[counter]);
					}
				}
			}
		}
	}
	//Deschequear
	function UpdChkAll(c) {	
		var allChecked = true;
		if (!c.checked) {
			allChecked = false;
		} else {
			if (document.form1.chk.value) {
				if (!document.form1.chk.disabled) allChecked = true;
			} else {
				for (var counter = 0; counter < document.form1.chk.length; counter++) {
					if (!document.form1.chk[counter].disabled && !document.form1.chk[counter].checked) {allChecked=false; break;}
				}
			}
		}
		document.form1.chkAllItems.checked = allChecked;								
	}
	
	
	function fnAlgunoMarcadolista(){
		if (document.form1.chk) {
			if (document.form1.chk.value) {
				return document.form1.chk.checked;
			} else {
				for (var i=0; i<document.form1.chk.length; i++) {
					if (document.form1.chk[i].checked) { 
						return true;
					}
				}
			}
		}
		return false;
	}
	function funcEliminar(){
		if (!fnAlgunoMarcadolista()){
			alert("¡Debe seleccionar al menos un empleado para eliminar!");
			return false;
		}else{
			if ( confirm("¿Desea Eliminar los Empleados marcados?") )	{
				document.form1.action = 'SalariosOtrosPatronosSQL.cfm';
				return true;
			}
			return false;
		}		
	}
	
	function irAmantenimiento(){
		deshabilitarvalidacion();
		document.form1.action = 'MantOtrosPatronos.cfm';	
	}
</script>

	<cf_dbfunction name="OP_concat" returnvariable="concat">
	<cfif isdefined('form.modo') and form.modo eq 'EDITAR'>
		<cfquery name="rsEmp" datasource="#session.dsn#">
			SELECT sop.DEid, DEidentificacion,DEnombre #concat#' '#concat#  DEapellido1#concat#' '#concat#DEapellido2 as NombreEmp, sop.SalarioBase, sop.Ecodigo, sop.BMUsucodigo, sop.ts_rversion 
			FROM SalariosOtrosPatronos sop
				inner join DatosEmpleado de
					on sop.DEid=de.DEid
				inner join RH_OtrosPatronos rhop
					on sop.	OPid=rhop.OPid
			WHERE sop.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			and sop.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		</cfquery>
		
	</cfif>

	<cfquery name="rsEmpleados" datasource="#session.dsn#">
		SELECT sop.DEid, DEidentificacion,DEnombre #concat#' '#concat#  DEapellido1#concat#' '#concat#DEapellido2 as NombreEmp, sop.SalarioBase, sop.Ecodigo, sop.BMUsucodigo, sop.ts_rversion
		FROM SalariosOtrosPatronos sop
				inner join DatosEmpleado de
					on sop.DEid=de.DEid
				inner join RH_OtrosPatronos rhop
					on sop.	OPid=rhop.OPid
		WHERE sop.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	</cfquery>


<link href="STYLE.CSS" rel="stylesheet" type="text/css">
<form action="SalariosOtrosPatronosSQL.cfm" method="post" name="form1">
	<input type="hidden" name="modo" value="">
	<table width="70%"  border="0" cellspacing="0" cellpadding="0" style="margin:0">
		<tr>
			<td rowspan="8">&nbsp;</td>

			<td rowspan="8">&nbsp;</td>
		</tr>
		<tr><td colspan="5">&nbsp;</td></tr>
 <!--- Mantenimiento --->
 		<tr>
		<tr>
		  <table width="70%" border="0" cellspacing="0" cellpadding="0"align="center">	
			  <cfquery datasource="#session.dsn#" name="patronos">
				Select OPid, OPcodigo, OPdescripcion
				from RH_OtrosPatronos
				where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				<cfif isdefined('form.modo') and form.modo eq 'EDITAR'>and OPid=#form.OPid#</cfif>
				order by OPcodigo,OPdescripcion
			  </cfquery> 
			<!---  --->
			<cfif patronos.recordcount eq 0>
			<cfset errs="Por favor ingrese a '<b>Mantenimiento Otros Patronos</b>' y registre un Patrono">
				<cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=1&errTitle=#URLEncodedFormat('No puede continuar esta operaci&oacute;n')#&ErrMsg=#URLEncodedFormat('No existe ning&uacute;n Patrono para esta empresa<br>')#&ErrDet=#URLEncodedFormat(errs)#" addtoken="no">
				<cfabort>
			</cfif>
			  <tr bgcolor="FAFAFA"> 
				<td nowrap class="filelabel"><b>Patrono:</b></td>
			 </tr>	
		  	 <tr>
				 <td>
					<select name="OPid" >
					<cfoutput query="patronos">
						 <option value="#OPid#" >#OPcodigo# - #OPdescripcion#</option>
					</cfoutput>
					</select>
				<input type="submit" value="+"  onclick="javascript: return irAmantenimiento();">
				</td>
			</tr>	
			<tr><td>&nbsp;</td></tr>
			  <tr bgcolor="FAFAFA"> 
				<td nowrap class="filelabel"><b>&nbsp;Empleado:</b></td>
				<td nowrap class="filelabel"><b>&nbsp;Monto:</b></td>
			 </tr>			  
			  <tr>
				<td nowrap>
					<cfif isdefined('form.modo') and form.modo eq 'EDITAR'>
						<cf_rhempleado size="40"  form="form1" query="#rsEmp#" readOnly="true">			
					<cfelse>
						<cf_rhempleado size="40" form="form1">									
					</cfif>
				</td>	

				<td nowrap>
					<cfoutput>
					<cfif isdefined('form.modo') and form.modo eq 'EDITAR'>
						<cf_inputNumber name="SalarioBase" enteros="7" decimales="2" tabindex="1" disabled="true" value="#rsEmp.SalarioBase#"  >
					<cfelse>
						<cf_inputNumber name="SalarioBase" value="" enteros="7" decimales="2" tabindex="1" disabled="true">
					</cfif>
					</cfoutput>
				</td>

				<td nowrap align="center">
					<cfoutput>
					<cfif modo neq 'ALTA'>						
						&nbsp;<input type="submit" alt="9" class="btnGuardar" name='DCambio' value="#BotonCambiar#" onClick="javascript: return setBtn(this);" tabindex="3">						
						<input type="submit" alt="11" name="DNuevo" class="btnNuevo" value="#BotonNuevo#" onClick="javascript: return setBtn(this);" tabindex="3">
					<cfelse>
						&nbsp;<input type="submit" alt="8" name='DAlta' class="btnGuardar" value="#BotonAgregar#" onClick="javascript: return setBtn(this);" tabindex="3">					
					</cfif>					
					</cfoutput>	
				</td>
			  </tr>		  		  
		  </table>
		 </td>
		 </tr> 
		  <!--- /mantenimiento --->
		  <tr><td>&nbsp;</td></tr>
		  <tr><td>&nbsp;</td></tr>
		<!--- Lista --->
		<tr><td>
</form>
<cfset filtro = ''>
<cfset necesitaAND=false>
<cfif isdefined('form.filtro_DEidentificacion') and Len(Trim(form.filtro_DEidentificacion))>
	<cfif necesitaAND><cfset filtro = filtro & " and "></cfif>
		<cf_dbfunction name="to_char"	args="DEidentificacion" returnvariable="varDEidentificacion" >
	<cfset filtro = filtro & "Upper(#varDEidentificacion#) like Upper('%#form.filtro_DEidentificacion#%')">
	<cfset necesitaAND=true>
</cfif>

<cfif isdefined('form.filtro_DEnombre') and Len(Trim(form.filtro_DEnombre))>
	<cfif necesitaAND><cfset filtro = filtro & " and "></cfif>
	<cfset filtro = filtro & "Upper(DEnombre) like Upper('%#form.filtro_DEnombre#%')">
		<cfset necesitaAND=true>
</cfif>
<cfif isdefined('form.filtro_DEapellido1') and Len(Trim(form.filtro_DEapellido1))>
	<cfif necesitaAND><cfset filtro = filtro & " and "></cfif>
	<cfset filtro = filtro & "Upper(DEapellido1) like Upper('%#form.filtro_DEapellido1#%')">
		<cfset necesitaAND=true>
</cfif>
<cfif isdefined('form.filtro_DEapellido2') and Len(Trim(form.filtro_DEapellido2))>
	<cfif necesitaAND><cfset filtro = filtro & " and "></cfif>
	<cfset filtro = filtro & "Upper(DEapellido2) like Upper('%#form.filtro_DEapellido2#%')">
		<cfset necesitaAND=true>
</cfif>
<cfif isdefined('form.filtro_SalarioBase') and Len(Trim(form.filtro_SalarioBase))>
	<cfif necesitaAND><cfset filtro = filtro & " and "></cfif>
	<cfset filtro = filtro & "SalarioBase >= #form.filtro_SalarioBase#">
</cfif>
<cfif isdefined('form.filtro_OPcodigo') and Len(Trim(form.filtro_OPcodigo))>
	<cfif necesitaAND><cfset filtro = filtro & " and "></cfif>
	<cfset filtro = filtro & "Upper(OPcodigo) like Upper('%#form.filtro_OPcodigo#%')">
</cfif>
<cfif isdefined('form.filtro_OPdescripcion') and Len(Trim(form.filtro_OPdescripcion))>
	<cfif necesitaAND><cfset filtro = filtro & " and "></cfif>
	<cfset filtro = filtro & "Upper(OPdescripcion) like Upper('%#form.filtro_OPdescripcion#%')">
</cfif>
<cfif Len(Trim(filtro))>
	<cfset filtro=" and sop.Ecodigo = #session.Ecodigo#">
<cfelse>
	<cfset filtro="sop.Ecodigo = #session.Ecodigo#">
</cfif>

<cfinvoke 
			 component="sif.Componentes.pListas"
			 method="pListaRH"
			 returnvariable="pListaRet">
				<cfinvokeargument name="tabla" value="SalariosOtrosPatronos sop inner join DatosEmpleado de on sop.DEid=de.DEid inner join RH_OtrosPatronos rhop on sop.OPid=rhop.OPid"/>
				<cfinvokeargument name="columnas" value="sop.DEid, sop.OPid,DEidentificacion,DEnombre,DEapellido1,DEapellido2, sop.SalarioBase, rhop.OPcodigo,rhop.OPdescripcion"/>
				<cfinvokeargument name="desplegar" value="DEidentificacion,DEnombre,DEapellido1,DEapellido2,SalarioBase, OPcodigo,OPdescripcion"/>
				<cfinvokeargument name="etiquetas" value="#LB_Identificacion#,#LB_Nombre#,#LB_Apellido#1,#LB_Apellido#2,#LB_Salario_Base#,#LB_codPatrono#,#LB_Patrono#"/>
				<cfinvokeargument name="formatos" value="S,S,S,S,M,S,S"/>
				<cfinvokeargument name="filtro" value="#filtro#"/>
				<cfinvokeargument name="align" value="left,left,left,left,left,left,left"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="irA" value="SalariosOtrosPatronos.cfm"/>
				<cfinvokeargument name="botones" value="Eliminar">
				<cfinvokeargument name="showEmptyListMsg" value="true">
				<cfinvokeargument name="mostrar_filtro" value="true">
				<cfinvokeargument name="debug" value="N">
				<cfinvokeargument name="index" value="10">
				<cfinvokeargument name="checkboxes" value="S"/>
			</cfinvoke>
		</td></tr>		<!---<cfinvokeargument name="formName" value="form1">--->
	<!---		<tr>
		<td>
		<table width="70%" border="0" cellspacing="0" cellpadding="0"align="center">
			<tr bgcolor="FAFAFA"> 				
				<td nowrap>&nbsp;<b>Empleado</b></td>
				<td nowrap align="right">&nbsp;<b>Salario Base</b></td>
			</tr>
					
		<cfoutput query="rsEmpleados">
			<tr <cfif CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>>				
				<td nowrap>&nbsp;#NombreEmp#</a></td>
				<td nowrap align="right">&nbsp;#LSCurrencyFormat(SalarioBase,'none')#</a></td>
				<td nowrap>
				  <input name="btnDEditar#DEid#" type="image" alt="Editar elemento" 
						onClick="javascript: return DModificar(#DEid#);" src="/cfmx/rh/imagenes/edit_o.gif" width="16" height="16">					
				<input name="btnDBorrar#DEid#" type="image" alt="Eliminar elemento" 
						onClick="javascript: return Deliminar(#DEid#);" src="/cfmx/rh/imagenes/Borrar01_T.gif" width="16" height="16">	
				</td>
				<td nowrap>&nbsp;</td>
				<td nowrap>&nbsp;</td>
			</tr>
			</cfoutput>		
		</table>
		<!--- /lista --->
	</table>
	</td>
	</tr>--->	


<cf_qforms>
<script language="JavaScript" type="text/javascript">
	objForm.DEid.required = true;	
	objForm.SalarioBase.required = true;			
	objForm.DEid.description = "Empleado";	
	objForm.SalarioBase.description = "Salario Base";

		function deshabilitarValidacion(){
			objForm.DEid.required = false;
			objForm.SalarioBase.required = false;
		}
</script>
