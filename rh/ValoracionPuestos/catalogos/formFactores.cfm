<!--- Sección de Etiquetas de Traducción --->
<cfsilent>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DeseaEliminarElDetalle"
	Default="Desea Eliminar el Detalle"
	returnvariable="MSG_DeseaEliminarElDetalle"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Modificar"
	Default="Modificar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Modificar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Agregar"
	Default="Agregar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Agregar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Codigo"
	Default="Código"
	XmlFile="/rh/generales.xml"
	returnvariable="MSG_Codigo"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Descripcion"
	Default="Descripción"
	XmlFile="/rh/generales.xml"
	returnvariable="MSG_Descripcion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Puntuacion"
	Default="Puntuación"
	returnvariable="MSG_Puntuacion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Ponderacion"
	Default="Ponderación"
	returnvariable="MSG_Ponderacion"/>		
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Limpiar"
	Default="Limpiar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Limpiar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Agregar"
	Default="Agregar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Agregar"/>
</cfsilent>

<!-- Establecimiento del modo -->
<cfif isdefined("form.Cambio") or isdefined("form.RHFid") and len(trim(form.RHFid))>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<!--- Consultas --->
<cfif modo neq 'ALTA'>
	<!--- Form --->
	<cfquery name="rsForm" datasource="#session.DSN#">
		select upper(rtrim(RHFcodigo))as RHFcodigo,RHFdescripcion,RHFponderacion,Puntuacion
		from RHFactores 
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and RHFid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHFid#">
	</cfquery>
</cfif>


<!--- Javascript --->
<script language="JavaScript1.2" src="/cfmx/rh/js/utilesMonto.js"></script>
<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<script language="JavaScript1.2" type="text/javascript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>

<form name="form1" method="post" action="SQLFactores.cfm">
  <cfoutput>
  <table width="100%" border="0" cellspacing="0" cellpadding="0" >
    <tr> 
      <td nowrap align="right"><cf_translate key="LB_Codigo" XmlFile="/rh/generales.xml">C&oacute;digo</cf_translate>:&nbsp;</td>
      <td nowrap>
	  	<input name="RHFcodigo" type="text" tabindex="1" value="<cfif modo neq 'ALTA'>#Trim(rsForm.RHFcodigo)#</cfif>" size="10" maxlength="10" onFocus="javascript:this.select();" style="text-transform:uppercase;">
	  </td>
    </tr>
    <tr> 
      <td nowrap align="right"><cf_translate key="LB_Decripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate>:&nbsp;</td>
      <td nowrap><input name="RHFdescripcion" type="text" tabindex="1" value="<cfif modo neq 'ALTA'>#rsForm.RHFdescripcion#</cfif>" size="55" maxlength="100" onFocus="javascript:this.select();"></td>
    </tr>
    <tr> 
      <td nowrap align="right"><cf_translate key="LB_Ponderacion" >Ponderaci&oacute;n</cf_translate>:&nbsp;</td>
      <td nowrap>
		  <input name="RHFponderacion" type="text" style="text-align: right;" tabindex="1"
		   onfocus="javascript:this.value=qf(this); this.select();" 
		   onBlur="javascript:fm(this,2);"  
		   <cfif modo eq 'ALTA'>onchange="javascript:sugerir_puntuacion();"</cfif>
		   onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
		   value="<cfif modo neq 'ALTA'>#rsForm.RHFponderacion#</cfif>" 
		   size="10" maxlength="10" >&nbsp;<b>%</b>
    </tr>
    <tr> 
      <td nowrap align="right"><cf_translate key="LB_Puntuacion" >Puntuaci&oacute;n</cf_translate>:&nbsp;</td>
      <td nowrap>
		  <input name="Puntuacion" type="text" style="text-align: right;" tabindex="1"
		   onfocus="javascript:this.value=qf(this); this.select();" 
		   onBlur="javascript:fm(this,2);"  
		   onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
		   value="<cfif modo neq 'ALTA'>#rsForm.Puntuacion#</cfif>" 
		   size="10" maxlength="10" >
    </tr>
	
	<tr><td colspan="2">&nbsp;</td></tr>
	<tr>
		<td nowrap colspan="2" align="center">
			<cfset tabindex=1>
			<cfif modo eq 'ALTA'>
				<cf_botones modo="#modo#">
			<cfelse>
				<cf_botones modo="#modo#" include="Grados">
			</cfif>
		</td>
	</tr>
	<tr align="center"> 
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>

	<cfif modo NEQ 'ALTA'>
			 <input type="hidden" name="RHFid" value="#form.RHFid#">
			 <input type="hidden" name="PuntuacionActual" value="#rsForm.Puntuacion#">
	</cfif>
	<tr> 
      <td colspan="2">
	  	<fieldset>
		<legend><cf_translate key="LB_Recomendaciones" >Recomendaciones</cf_translate></legend>
		<table width="100%" border="0" cellpadding="2" cellspacing="2">
			<tr>
				<td width="5%"><img src="/cfmx/rh/imagenes/TBP_0077.JPG"/></td>
				<td><cf_translate key="LB_AsignarElPorcentajeDeImportanciaACadaFactorDeAcuerdoConLasCaracteristicasParticularesDeLaempresa" >Asignar el porcentaje de importancia a cada factor de acuerdo con las caracter&iacute;sticas particulares de la empresa</cf_translate></td>
			</tr>
			<tr>
				<td width="5%"><img src="/cfmx/rh/imagenes/TBP_0077.JPG"/></td>
				<td><cf_translate key="LB_LaSumatoriaDeLosPesosDeTodosLosFactoresDebeTotalizar100" >La sumatoria de los pesos de todos los factores debe totalizar 100%.</cf_translate></td>
			</tr>
		</table>
		</fieldset>
	  </td>
    </tr>
  </table>  
  </cfoutput>
</form>
	
<script language="JavaScript1.2" type="text/javascript">

	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_El_campo"
	Default="El campo"
	returnvariable="MSG_El_campo"/>	
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DebeContenerUnValorEntre"
	Default="debe contener un valor entre"
	returnvariable="MSG_DebeContenerUnValorEntre"/>	
	
	function _Field_isRango(low, high){var low=_param(arguments[0], 0, "number");
		var high=_param(arguments[1], 9999999, "number");
		var iValue=parseInt(qf(this.value));
		if(isNaN(iValue))iValue=0;
		if((low>iValue)||(high<iValue)){
			this.error="<cfoutput>#MSG_El_campo#</cfoutput> "+this.description+" <cfoutput>#MSG_DebeContenerUnValorEntre#</cfoutput> "+low+" y "+high+".";
		}
	}
	_addValidator("isRango", _Field_isRango);	

	objForm.RHFcodigo.required 			= true;
	objForm.RHFdescripcion.required 	= true;
	objForm.RHFponderacion.required 	= true;
	objForm.RHFponderacion.validateRango('0','100');
	objForm.Puntuacion.required 		= true;
	objForm.RHFcodigo.description		="<cfoutput>#MSG_Codigo#</cfoutput>";
	objForm.RHFdescripcion.description	="<cfoutput>#MSG_Descripcion#</cfoutput>";
	objForm.RHFponderacion.description	="<cfoutput>#MSG_Ponderacion#</cfoutput>";
	objForm.Puntuacion.description		="<cfoutput>#MSG_Puntuacion#</cfoutput>";
	
	function deshabilitarValidacion(){
		objForm.RHFcodigo.required 			= false;
		objForm.RHFdescripcion.required 	= false;
		objForm.RHFponderacion.required 	= false;
		objForm.Puntuacion.required 		= false;
	}	
	
	function habilitarValidacion(){
		objForm.RHFcodigo.required 			= true;
		objForm.RHFdescripcion.required 	= true;
		objForm.RHFponderacion.required 	= true;
		objForm.Puntuacion.required 		= true;
	} 
	
	function sugerir_puntuacion(){
		var RHFponderacion = new Number(qf(document.form1.RHFponderacion.value)) * 10;
		document.form1.Puntuacion.value = RHFponderacion;
		fm(document.form1.Puntuacion,2);
	}
	
	function funcGrados(){
		document.form1.action = 'Grados.cfm';
	}
	
	fm(document.form1.Puntuacion,2);  
	fm(document.form1.RHFponderacion,2);

</script>