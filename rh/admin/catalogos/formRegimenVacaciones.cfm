<!--- Consultas Originales
select convert(varchar,RVid) as RVid, Ecodigo, RVcodigo, Descripcion, RVfecha, Usucodigo, Ulocalizacion, ts_rversion from RegimenVacaciones where RVid = 9999
select convert(varchar,DRVlinea) as DRVlinea, RVid, DRVcant, DRVdias, Usucodigo, Ulocalizacion, ts_rversion from DRegimenVacaciones where DRVlinea = 9999
--->

<!--- 
	Modificado por: Ana Villavicencio
	Fecha: 12 de diciembre del 2005
	Motivo: agregar un nuevo campo en el catalogo, dias de verificacion de compensacion.
 --->
 
<!---ljimenez 2009-07-16
Se agregan dos nuevos campos para el uso de nomina mexico
DRVdiasgratifica, DRVdiasprima
se usan para sacar el factor utilizado en el calculo de salario base de cotizacion SBC--->
 
<!--- Establecimiento del modo --->
<cfif not isdefined("Form.modo")>
	<cfset modo='ALTA'>
<cfelseif Form.modo EQ "CAMBIO">
	<cfset modo="CAMBIO">
<cfelse>
	<cfset modo='ALTA'>
</cfif>

<cfquery name="rsCodigo" datasource="#session.DSN#">
	select RVcodigo
	from RegimenVacaciones 
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	<cfif modo neq 'ALTA'>
		and RVid!=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RVid#">
	</cfif>
</cfquery>

<!--- Consultas --->
<cfif modo neq 'ALTA'>
	<cfquery name="rsRV" datasource="#Session.DSN#">
		select RVid, RVcodigo, Descripcion, ts_rversion 
		from RegimenVacaciones 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and RVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RVid#">
	</cfquery>
	<cfquery name="rsDRV" datasource="#Session.DSN#">
		select DRVlinea, RVid, DRVcant, DRVdias, DRVdiasadic, DRcantcomp, DRVdiasenf, DRVdiasvericomp,DRVdiasgratifica,DRVdiasprima,ts_rversion 
		from DRegimenVacaciones 
		where RVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RVid#">
		order by DRVcant, DRVdias, DRVdiasadic
		<!---
			and DRVlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DRVlinea#">
			Trae todos para pintar lista y seleccionar de ahí, así no se hace post par modificar un detalle.
		--->
	</cfquery>
</cfif>
<script language="JavaScript" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js"></script>
<script language="JavaScript" type="text/javascript" src="/cfmx/rh/js/calendar.js"></script>
<script language="JavaScript" type="text/javascript">
 	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//Acciones de los Botones
	function setBtn(opc) {
		var result = true;
		switch (opc) {
		case '0' :
			document.form.Accion.value='Alta';
			break;
		case '1' :
			document.form.Accion.value='Cambio';
			break;
		case '2' :
			if (confirm('¿Desea Eliminar el Registro completo del Régimen de Vacaciones y todos sus Detalles?'))
				document.form.Accion.value='Baja';
			else
				result = false;
			break;
		case '3' :
			document.form.Accion.value='Nuevo';
			break;
<cfif modo neq 'ALTA'>
		case '4' :
			document.form.Accion.value='AltaDetalle';
			break;
		case '5' :
			document.form.Accion.value='CambioDetalle';
			break;
		case '6' :
			if (confirm('¿Desea Eliminar el Detalle?'))
					document.form.Accion.value='BajaDetalle';
			else
				result = false;
			break;
		case '7' :
			document.form.Accion.value='NuevoDetalle';
			break;
</cfif>
		}
		//Para que no valide en Baja ni Baja Detalle
		if (document.form.Accion.value=='Baja' || document.form.Accion.value=='BajaDetalle' ||
			document.form.Accion.value=='Nuevo' || document.form.Accion.value=='NuevoDetalle')
			fnNoValidar();
		if (document.form.Accion.value=='Alta' || document.form.Accion.value=='Baja' ||
			document.form.Accion.value=='Cambio' || document.form.Accion.value=='Nuevo')
			fnNoValidarE();
		//Resultado de la función
		return result;
	}

	function fnNoValidar() {
		objForm.RVcodigo.required    = false;
		objForm.Descripcion.required = false;
		<cfif modo neq 'ALTA'>
			objForm.DRVcant.required    = false;
			objForm.DRVdias.required    = false;
			objForm.DRcantcomp.required = false;
			objForm.DRVdiasadic.required = false;
			objForm.DRVdiasenf.required = false;
			objForm.DRVdiasvericomp.required = false;
			
			objForm.DRVdiasgratifica.required = false;
			objForm.DRVdiasprima.required = false;
			
		</cfif>
	}

	function fnValidar() {
		objForm.RVcodigo.required    = true;
		objForm.Descripcion.required = true;
		<cfif modo neq 'ALTA'>
			objForm.DRVcant.required    = true;
			objForm.DRVdias.required    = true;
			objForm.DRcantcomp.required = true;
			objForm.DRVdiasenf.required = true;
		</cfif>
	}

	function fnNoValidarE() {
		<cfif modo neq 'ALTA'>
			objForm.DRVcant.required    = false;
			objForm.DRVdias.required    = false;
			objForm.DRVdiasadic.required = false;
			objForm.DRcantcomp.required = false;
			objForm.DRVdiasenf.required = false;
			objForm.DRVdiasvericomp.required = false;
			
			objForm.DRVdiasgratifica.required = false;
			objForm.DRVdiasprima.required = false;
			
		</cfif>
	}
	//Funciones al iniciar la pantalla
	function initPage(f) {
		
	}
	//Funciones al Finalizar la pantalla
	function fnfinalizar(f) {
		
	}
	<cfif modo neq 'ALTA'>
	//carga el mantenimiento del detalle
	function fnCargaDetalle(DRVlinea, DRVcant, DRVdias, DRVdiasadic, DRcantcomp, DRVdiasenf, DRVdiasvericomp, DRVdiasgratifica, DRVdiasprima, ts){
		objForm.DRVlinea.obj.value = DRVlinea;
		objForm.DRVcant.obj.value = DRVcant;
		objForm.DRVdias.obj.value = DRVdias;
		objForm.DRVdiasadic.obj.value = DRVdiasadic;
		objForm.DRcantcomp.obj.value = DRcantcomp;
		objForm.DRVdiasenf.obj.value = DRVdiasenf;
		objForm.DRVdiasvericomp.obj.value = DRVdiasvericomp;
		
		objForm.DRVdiasgratifica.obj.value = DRVdiasgratifica;
		objForm.DRVdiasprima.obj.value = DRVdiasprima;
		
		objForm.dtimestamp.obj.value = ts;
		objForm.btnDetalle45.obj.alt='5';
		objForm.btnDetalle45.obj.value='Modificar';
	}
	function Borrar(DRVlinea){
		if (confirm('¿Desea Eliminar el Detalle?')){
			objForm.Accion.obj.value='BajaDetalle';
			objForm.DRVlinea.obj.value=DRVlinea;
			fnNoValidar();
			return true;
		}
		else
			return false;	
	}
	function fnDesCargaDetalle(){
		objForm.DRVlinea.obj.value = '';
		objForm.DRVcant.obj.value = '';
		objForm.DRVdias.obj.value = '';
		objForm.DRVdiasadic.obj.value = '';
		objForm.DRcantcomp.obj.value = '';
		objForm.DRVdiasenf.obj.value = '';
		objForm.DRVdiasvericomp.obj.value = '';
		
		objForm.DRVdiasgratifica.obj.value = '';
		objForm.DRVdiasprima.obj.value = '';
		
		
		objForm.dtimestamp.obj.value = '';
		objForm.btnDetalle45.obj.alt='4';
		objForm.btnDetalle45.obj.value='Agregar';
	}
	</cfif>
</script>
<cf_templatecss>
<form action="SQLRegimenVacaciones.cfm" method="post" name="form">
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td nowrap align="right"><cfoutput>#LB_CODIGO#</cfoutput>:&nbsp;</td>
    <td nowrap >
		<input name="RVcodigo" type="text" size="10" maxlength="5" tabindex="1"
			value="<cfif modo neq 'ALTA'><cfoutput>#trim(rsRV.RVcodigo)#</cfoutput></cfif>" onfocus="this.select();">
	</td>
  </tr>
  <tr>
    <td nowrap align="right"><cfoutput>#LB_DESCRIPCION#</cfoutput>:&nbsp;</td>
    <td nowrap><input name="Descripcion" type="text" size="40" maxlength="80" tabindex="1"
	value="<cfif modo neq 'ALTA'><cfoutput>#rsRV.Descripcion#</cfoutput></cfif>" onfocus="this.select();" ></td>
  </tr>
  <tr>
  	<td nowrap colspan="2">
		<input type="hidden" name="RVid" value="<cfif modo neq 'ALTA'><cfoutput>#rsRV.RVid#</cfoutput></cfif>">
		<cfif modo neq 'ALTA'>
			<cfset ts = "">
			<cfinvoke
			component="sif.Componentes.DButils"
			method="toTimeStamp"
			returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#rsRV.ts_rversion#"/>
			</cfinvoke>
			<input type="hidden" name="ts_rversion" value="<cfoutput>#ts#</cfoutput>">
		</cfif>
	</td>
  </tr>
  <tr>
  	<td nowrap colspan="2">&nbsp;
	</td>
  </tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
	<tr><td>&nbsp;</td></tr>
  <tr>
    <td nowrap align="center">
			<cfoutput> 
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="BTN_Agregar"
			Default="Agregar"
			XmlFile="/rh/generales.xml"
			returnvariable="BTN_Agregar"/>	
			
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="BTN_Limpiar"
			Default="Limpiar"
			XmlFile="/rh/generales.xml"
			returnvariable="BTN_Limpiar"/>			
			
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="BTN_Modificar"
			Default="Modificar"
			XmlFile="/rh/generales.xml"
			returnvariable="BTN_Modificar"/>	
			
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="BTN_Eliminar"
			Default="Eliminar"
			XmlFile="/rh/generales.xml"
			returnvariable="BTN_Eliminar"/>	
			
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="BTN_Nuevo"
			Default="Nuevo"
			XmlFile="/rh/generales.xml"
			returnvariable="BTN_Nuevo"/>	
			
			
				<cfif modo eq 'ALTA'>
					<input type="submit" alt="0" tabindex="2" name='ALTA' value="#BTN_Agregar#" onClick="javascript: return setBtn(this.alt);" >
					<input type="reset" name="Limpiar" value="#BTN_Limpiar#" >
				<cfelse>
					<input type="submit" alt="1" tabindex="2" name="Cambio" value="#BTN_Modificar#" onClick="javascript: return setBtn(this.alt);" >
					<input type="submit" alt="2" tabindex="2" name="Baja" value="#BTN_Eliminar#" onClick="javascript: return setBtn(this.alt);" >
					<input type="submit" alt="3" tabindex="2" name="Nuevo" value="#BTN_Nuevo#" onClick="javascript: return setBtn(this.alt);" >
				</cfif>
			</cfoutput> 
	  </td>
	</tr>
</table>
<cfif modo neq 'ALTA'>
	<table width="95%" border="0" cellspacing="0" cellpadding="0"align="center">
		<tr>
			<td>
				<fieldset><legend><cf_translate key="LB_Detalle">Detalle</cf_translate></legend>
					<table width="80%" border="0" cellspacing="0" cellpadding="1" align="center">
						<tr> 
							<td nowrap colspan="4" align="right"><b><cf_translate key="LB_AnnosLaborados">Años Laborados</cf_translate>:&nbsp;</b></td>
							<td nowrap>
								<input name="DRVcant" type="text" tabindex="2" style="text-align:right" value="" size="8" maxlength="2"
									onFocus="javascript:this.select();" 
									onblur="javascript:fm(this,-1);" 
									onkeyup="if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}">
							</td>
							<td nowrap align="right"><b><cf_translate key="LB_DiasDeCompensacion">Días de Compensación</cf_translate>:&nbsp;</b></td>
							<td nowrap >
								<input name="DRcantcomp" type="text" tabindex="5" style="text-align:right" value="" size="8" maxlength="2"
									onFocus="javascript:this.select();" 
									onblur="javascript:fm(this,-1);" 
									onkeyup="if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}" >
							</td>
						</tr>
						<tr>
							<td nowrap colspan="4" align="right"><b><cf_translate key="LB_DiasDeVacaciones">Días de Vacaciones</cf_translate>:&nbsp;</b></td>
							<td nowrap>
								<input name="DRVdias" type="text" tabindex="3" style="text-align:right" value="" size="8" maxlength="2"
									onFocus="javascript:this.select();" 
									onblur="javascript:fm(this,-1);" 
									onkeyup="if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}" >
							</td>
							<td nowrap align="right"><b><cf_translate key="LB_DiasDeVerificacionDeComp">Días de Verificaci&oacute;n de Comp.</cf_translate>:&nbsp;</b></td>
							<td nowrap>
								<input name="DRVdiasvericomp"  type="text" tabindex="6" style="text-align:right"  value="" size="8" maxlength="3"
									onFocus="javascript:this.select();"
									onblur="javascript:fm(this,-1);" 
									onkeyup="if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}">
							</td>
						</tr>
						<tr>
							<td nowrap colspan="4" align="right"><strong><cf_translate key="LB_DiasAdicionales">D&iacute;as Adicionales</cf_translate>:&nbsp;</strong></td>
							<td nowrap>
								<input name="DRVdiasadic" type="text" tabindex="4" style="text-align:right" value="" size="8" maxlength="2"
									onFocus="javascript:this.select();" 
									onblur="javascript:fm(this,-1);" 
									onkeyup="if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}" >
							</td>
							<td nowrap align="right"><b><cf_translate key="LB_DiasEnfermedad">Días de Enfermedad</cf_translate>:&nbsp;</b></td>
							<td nowrap >
								<input name="DRVdiasenf"  type="text" tabindex="7" style="text-align:right"  value="" size="8" maxlength="2"
									onFocus="javascript:this.select();"
									onblur="javascript:fm(this,-1);" 
									onkeyup="if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}">
							</td>
						</tr>
						
						
						<tr>
							<td nowrap colspan="4" align="right"><strong><cf_translate key="LB_DiasGratifica">D&iacute;as Gratificaci&oacute;n</cf_translate>:&nbsp;</strong></td>
							<td nowrap>
								<input name="DRVdiasgratifica" type="text" tabindex="4" style="text-align:right" value="" size="8" maxlength="2"
									onFocus="javascript:this.select();" 
									onblur="javascript:fm(this,-1);" 
									onkeyup="if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}" >
							</td>
							<td nowrap align="right"><b><cf_translate key="LB_Diasprima">D&iacute;as de Prima</cf_translate>:&nbsp;</b></td>
							<td nowrap >
								<input name="DRVdiasprima"  type="text" tabindex="7" style="text-align:right" size="8" maxlength="5"  
									onfocus="javascript:this.value=qf(this); this.select();"
									onblur="javascript:fm(this,2);"
									onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
									value="<cfif isdefined("rsForm.DRVdiasprima") and len(trim(rsForm.DRVdiasprima)) gt 0 >#rsForm.DRVdiasprima#</cfif>" >
							</td>
						</tr>
					
						
						<tr> 
							<td nowrap colspan="8">&nbsp;</td>
						</tr>
						
						<tr>
							<td colspan="8" align="center">
								<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="BTN_Agregar"
								Default="Agregar"
								XmlFile="/rh/generales.xml"
								returnvariable="BTN_Agregar"/>
								
								
								<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="BTN_Limpiar"
								Default="Limpiar"
								XmlFile="/rh/generales.xml"
								returnvariable="BTN_Limpiar"/>	
							
								<cfoutput>
								<input type="submit" alt="4" tabindex="8" name='btnDetalle45' value="#BTN_Agregar#" onClick="javascript: fnValidar(); return setBtn(this.alt);" >
								<cfif modo neq 'ALTA'>
								<input type="button" name='DesCargaDetalle' tabindex="8"  value="#BTN_Limpiar#" onClick="javascript: fnDesCargaDetalle(); return false;" >
								</cfif>
								<input type="hidden" name="DRVlinea" value="">
								<input type="hidden" name="dtimestamp" value="">
								</cfoutput>
							</td>
						</tr>
						<tr><td colspan="8">&nbsp;</td></tr>
					</table>
					<table width="90%" cellspacing="0" cellpadding="0" align="center" border="0">
						<tr bgcolor="CCCCCC" bordercolor="#000000"> 
							<td nowrap style="border-style:solid; border-width:thin; border-right-style:none"><strong>&nbsp;<cf_translate key="LB_Laborados">Laborados</cf_translate>&nbsp;</strong></td>
							<td nowrap style=" border-style:solid; border-width:thin; border-right-style:none"><strong>&nbsp;<cf_translate key="LB_Vacaciones">Vacaciones</cf_translate>&nbsp;</strong></td>
							<td nowrap style="border-style:solid; border-width:thin; border-right-style:none"><strong>&nbsp;<cf_translate key="LB_Adicionales">Adicionales</cf_translate>&nbsp;</strong></td>
							<td nowrap style="border-style:solid; border-width:thin;border-right-style:none"><strong>&nbsp;<cf_translate key="LB_Compensacion">Compensaci&oacute;n</cf_translate>&nbsp;</strong></td>
							<td nowrap style="border-style:solid; border-width:thin; border-right-style:none"><strong>&nbsp;<cf_translate key="LB_Verificacion">Verificaci&oacute;n Comp.</cf_translate>&nbsp;</strong></td>
							<td  nowrap style="border-style:solid; border-width:thin"><strong>&nbsp;<cf_translate key="LB_Enfermedad">Enfermedad</cf_translate>&nbsp;</strong></td>
							<td  nowrap style="border-style:solid; border-width:thin"><strong>&nbsp;<cf_translate key="LB_Gratificacion">Gratificaci&oacute;n</cf_translate>&nbsp;</strong></td>
							<td  nowrap style="border-style:solid; border-width:thin"><strong>&nbsp;<cf_translate key="LB_Prima">Prima</cf_translate>&nbsp;</strong></td>
						</tr>						
						<cfoutput query="rsDRV"> 
							<cfset ts = "">
							<cfinvoke
							component="sif.Componentes.DButils"
							method="toTimeStamp"
							returnvariable="ts">
							<cfinvokeargument name="arTimeStamp" value="#ts_rversion#"/>
							</cfinvoke>
							<tr <cfif CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>> 
								<td nowrap align="center" style="cursor: pointer;"
									onMouseOut="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';" 
									onClick="javascript: fnCargaDetalle(#rsDRV.DRVlinea#, #rsDRV.DRVcant#, #rsDRV.DRVdias#, #rsDRV.DRVdiasadic#, #rsDRV.DRcantcomp#, #rsDRV.DRVdiasenf#, #rsDRV.DRVdiasvericomp#,  #rsDRV.DRVdiasgratifica#,  #rsDRV.DRVdiasprima#, #ts#);">
									#rsDRV.DRVcant#</td>
								<td nowrap align="center" style="cursor: pointer;"
									onMouseOut="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';" 
									onClick="javascript: fnCargaDetalle(#rsDRV.DRVlinea#, #rsDRV.DRVcant#, #rsDRV.DRVdias#, #rsDRV.DRVdiasadic#, #rsDRV.DRcantcomp#, #rsDRV.DRVdiasenf#, #rsDRV.DRVdiasvericomp#, #rsDRV.DRVdiasgratifica#,  #rsDRV.DRVdiasprima#,#ts#);">
									#rsDRV.DRVdias#</td>
								<td nowrap align="center" style="cursor: pointer;"
									onMouseOut="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';" 
									onClick="javascript: fnCargaDetalle(#rsDRV.DRVlinea#, #rsDRV.DRVcant#, #rsDRV.DRVdias#, #rsDRV.DRVdiasadic#, #rsDRV.DRcantcomp#, #rsDRV.DRVdiasenf#, #rsDRV.DRVdiasvericomp#, #rsDRV.DRVdiasgratifica#,  #rsDRV.DRVdiasprima#,#ts#);">
									#rsDRV.DRVdiasadic#</td>
								<td nowrap align="center" style="cursor: pointer;"
									onMouseOut="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';" 
									onClick="javascript: fnCargaDetalle(#rsDRV.DRVlinea#, #rsDRV.DRVcant#, #rsDRV.DRVdias#, #rsDRV.DRVdiasadic#, #rsDRV.DRcantcomp#, #rsDRV.DRVdiasenf#, #rsDRV.DRVdiasvericomp#, #rsDRV.DRVdiasgratifica#,  #rsDRV.DRVdiasprima#,#ts#);">
									#rsDRV.DRcantcomp#</td>
								<td nowrap align="center" style="cursor: pointer;"
									onMouseOut="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';" 
									onClick="javascript: fnCargaDetalle(#rsDRV.DRVlinea#, #rsDRV.DRVcant#, #rsDRV.DRVdias#, #rsDRV.DRVdiasadic#, #rsDRV.DRcantcomp#, #rsDRV.DRVdiasenf#, #rsDRV.DRVdiasvericomp#, #rsDRV.DRVdiasgratifica#,  #rsDRV.DRVdiasprima#,#ts#);">
									#rsDRV.DRVdiasvericomp#</td>
								
								<td  nowrap align="center" style="cursor: pointer;"
									onMouseOut="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';" 
									onClick="javascript: fnCargaDetalle(#rsDRV.DRVlinea#, #rsDRV.DRVcant#, #rsDRV.DRVdias#, #rsDRV.DRVdiasadic#, #rsDRV.DRcantcomp#, #rsDRV.DRVdiasenf#, #rsDRV.DRVdiasvericomp#, #rsDRV.DRVdiasgratifica#,  #rsDRV.DRVdiasprima#,#ts#);">
									#rsDRV.DRVdiasenf#</td>
								
								<td nowrap align="center" style="cursor: pointer;"
									onMouseOut="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';" 
									onClick="javascript: fnCargaDetalle(#rsDRV.DRVlinea#, #rsDRV.DRVcant#, #rsDRV.DRVdias#, #rsDRV.DRVdiasadic#, #rsDRV.DRcantcomp#, #rsDRV.DRVdiasenf#, #rsDRV.DRVdiasvericomp#, #rsDRV.DRVdiasgratifica#,  #rsDRV.DRVdiasprima#, #ts#);">
									#rsDRV.DRVdiasgratifica#</td>
								
								<td nowrap align="center" style="cursor: pointer;"
									onMouseOut="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';" 
									onClick="javascript: fnCargaDetalle(#rsDRV.DRVlinea#, #rsDRV.DRVcant#, #rsDRV.DRVdias#, #rsDRV.DRVdiasadic#, #rsDRV.DRcantcomp#, #rsDRV.DRVdiasenf#, #rsDRV.DRVdiasvericomp#, #rsDRV.DRVdiasgratifica#,  #rsDRV.DRVdiasprima#, #ts#);">
									#rsDRV.DRVdiasprima#</td>
								<td nowrap>	
									<input name="btnBorrar#DRVlinea#" type="image" alt="Eliminar elemento" tabindex="8" 
										onClick="javascript: return Borrar(#rsDRV.DRVlinea#)" 
										src="/cfmx/rh/imagenes/Borrar01_T.gif" width="16" height="16" border="0"> 
									<input name="btnEditar#DRVlinea#" type="image" alt="Editar elemento" tabindex="8" 
										onClick="javascript: fnCargaDetalle(#rsDRV.DRVlinea#, #rsDRV.DRVcant#, #rsDRV.DRVdias#, #rsDRV.DRVdiasadic#, #rsDRV.DRcantcomp#, #rsDRV.DRVdiasenf#, #rsDRV.DRVdiasvericomp#, #rsDRV.DRVdiasgratifica#, #rsDRV.DRVdiasprima#,#ts#); return false;" 
										src="/cfmx/rh/imagenes/edit_o.gif" width="16" height="16" border="0">
								</td>
							</tr>
				
							<cfif RecordCount lte 0>
								<tr>
									<td nowrap colspan="8" align="center" class="fileLabel"><cf_translate key="MSG_NoExistenDetalles">No existen detalles</cf_translate>.</td>
								</tr>
							</cfif>
						</cfoutput>
						<tr>
							<td nowrap colspan="8">&nbsp;</td>
						</tr>
					</table>
				</fieldset>
			</td>	
		</tr>
	</table>
</cfif>
<input type="hidden" name="Accion" value="">
</form>
<script language="JavaScript" type="text/javascript">
	//Validaciones del Encabezado Registro de Nomina
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form");
	//Inicializa algunos detalles de la pantalla
	initPage(document.form);
	//Funciones adicionales de validación

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ElCodigoDeRegimenDeVacacionesYaExiste"
	Default="El Código de Regimen de Vacaciones ya existe."
	returnvariable="MSG_ElCodigoDeRegimenDeVacacionesYaExiste"/>

	function Codigo(){
		<cfloop query="rsCodigo">
			var codigo = '<cfoutput>#rsCodigo.RVcodigo#</cfoutput>';
			if ( trim(codigo) == trim(this.value) ){
				this.error = "<cfoutput>#MSG_ElCodigoDeRegimenDeVacacionesYaExiste#</cfoutput>";
			}
		</cfloop>
	}

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ElValorPara"
	Default="El valor para "
	returnvariable="MSG_ElValorPara"/>
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DebeContenerSolamenteCaracteresAlfanumericos"
	Default="debe contener solamente caracteres alfanuméricos,\n y los siguientes simbolos: (/*-+.:,;{}[]|°!$&()=?)."
	returnvariable="MSG_DebeContenerSolamenteCaracteresAlfanumericos"/>
	

	function _Field_isAlfaNumerico()
	{
		var validchars=" áéíóúabcdefghijklmnñopqrstuvwxyz1234567890/*-+.:,;{}[]|°!$&()=?";
		var tmp="";
		var string = this.value;
		var lc=string.toLowerCase();
		for(var i=0;i<string.length;i++) {
			if(validchars.indexOf(lc.charAt(i))!=-1)tmp+=string.charAt(i);
		}
		if (tmp.length!=this.value.length)
		{
			this.error="<cfoutput>#MSG_ElValorPara#</cfoutput>"+this.description+"<cfoutput>#MSG_DebeContenerSolamenteCaracteresAlfanumericos#</cfoutput>";
		}
	}
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ElCampo"
	Default="El campo "
	returnvariable="MSG_ElCampo"/>
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DebeContenerUnValorEntre"
	Default="debe contener un valor entre"
	returnvariable="MSG_DebeContenerUnValorEntre"/>	
	
	
	
	function _Field_isRango(low, high){var low=_param(arguments[0], 0, "number");
	var high=_param(arguments[1], 9999999, "number");
	var iValue=parseInt(qf(this.value));
	if(isNaN(iValue))iValue=0;
	if((low>iValue)||(high<iValue)){this.error="<cfoutput>#MSG_ElCampo#</cfoutput> "+this.description+" <cfoutput>#MSG_DebeContenerUnValorEntre#</cfoutput> "+low+" y "+high+".";
	}}
	_addValidator("isAlfaNumerico", _Field_isAlfaNumerico);
	_addValidator("isRango", _Field_isRango);
	_addValidator("isCodigo", Codigo);

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Codigo"
	Default="Código"
	returnvariable="MSG_Codigo"/>		
	
	//Validaciones del Encabezado
	objForm.RVcodigo.required = true;
	objForm.RVcodigo.description = "<cfoutput>#MSG_Codigo#</cfoutput> ";
	objForm.RVcodigo.validateCodigo();
	objForm.RVcodigo.validateAlfaNumerico();
	//objForm.RVcodigo.validate = true;
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Descripcion"
	Default="Descripción"
	returnvariable="MSG_Descripcion"/>	

	objForm.Descripcion.required = true;
	objForm.Descripcion.description = "<cfoutput>#MSG_Descripcion#</cfoutput>";
	objForm.Descripcion.validateAlfaNumerico();
	//objForm.Descripcion.validate = true;
	//Validaciones del Detalle
	<cfif modo eq 'ALTA'>
		objForm.RVcodigo.obj.focus();
	<cfelse>
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_AnnosLaborados"
		Default="Años Laborados"
		returnvariable="MSG_AnnosLaborados"/>		
	
		objForm.DRVcant.required = true;
		objForm.DRVcant.description = "<cfoutput>#MSG_AnnosLaborados#</cfoutput>";
		
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_DiasDeVacaciones"
		Default="Días de Vacaciones"
		returnvariable="MSG_DiasDeVacaciones"/>			

		objForm.DRVdias.required = true;
		objForm.DRVdias.description = "<cfoutput>#MSG_DiasDeVacaciones#</cfoutput>";

		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_DiasAdicionales"
		Default="Días Adicionales"
		returnvariable="MSG_DiasAdicionales"/>			

		objForm.DRVdiasadic.required = true;
		objForm.DRVdiasadic.description = "<cfoutput>#MSG_DiasAdicionales#</cfoutput>";
		
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_DiasDeCompensacion"
		Default="Días de Compensación"
		returnvariable="MSG_DiasDeCompensacion"/>			


		objForm.DRcantcomp.required = true;
		objForm.DRcantcomp.description = "<cfoutput>#MSG_DiasDeCompensacion#</cfoutput>";
		
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_DiasDeVerificacionDeCompensacion"
		Default="Días de Verificación de Compensación"
		returnvariable="MSG_DiasDeVerificacionDeCompensacion"/>			
		

		objForm.DRVdiasvericomp.required = true;
		objForm.DRVdiasvericomp.description = "<cfoutput>#MSG_DiasDeVerificacionDeCompensacion#</cfoutput>";
		
		
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_DiasDeGratificacion"
		Default="Días de Gratificación"
		returnvariable="MSG_DiasDeGratificacion"/>			
		

		objForm.DRVdiasgratifica.required = true;
		objForm.DRVdiasgratifica.description = "<cfoutput>#MSG_DiasDeGratificacion#</cfoutput>";
		
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_DiasDePrima"
		Default="Días de Prima"
		returnvariable="MSG_DiasDePrima"/>			
		

		objForm.DRVdiasprima.required = true;
		objForm.DRVdiasprima.description = "<cfoutput>#MSG_DiasDePrima#</cfoutput>";
		
		
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_DiasDeEnfermedad"
		Default="Días de Enfermedad"
		returnvariable="MSG_DiasDeEnfermedad"/>			
		

		objForm.DRVdiasenf.required = true;
		objForm.DRVdiasenf.description = "<cfoutput>#MSG_DiasDeEnfermedad#</cfoutput>";

		objForm.DRVcant.obj.focus();
	</cfif>
</script>
<br>
