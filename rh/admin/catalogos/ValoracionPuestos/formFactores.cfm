<!--- Sección de Etiquetas de Traducción --->
<!-- Establecimiento del modo -->
<cfif isdefined("form.Cambio") or isdefined("form.RHHFid") and len(trim(form.RHHFid))>
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
		select upper(rtrim(RHHFcodigo))as RHHFcodigo,RHHFdescripcion,RHHFponderacion,RHHFpuntuacion
		from RHHFactores 
		where RHHFid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHHFid#">
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
	  	<input name="RHHFcodigo" type="text" tabindex="1" value="<cfif modo neq 'ALTA'>#Trim(rsForm.RHHFcodigo)#</cfif>" size="10" maxlength="10" onFocus="javascript:this.select();" style="text-transform:uppercase;">
	  </td>
    </tr>
    <tr> 
      <td nowrap align="right"><cf_translate key="LB_Decripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate>:&nbsp;</td>
      <td nowrap><input name="RHHFdescripcion" type="text" tabindex="1" value="<cfif modo neq 'ALTA'>#rsForm.RHHFdescripcion#</cfif>" size="55" maxlength="100" onFocus="javascript:this.select();"></td>
    </tr>
    <tr> 
      <td nowrap align="right"><cf_translate key="LB_Ponderacion" >Ponderaci&oacute;n</cf_translate>:&nbsp;</td>
      <td nowrap>
		  <input name="RHHFponderacion" type="text" style="text-align: right;" tabindex="1"
		   onfocus="javascript:this.value=qf(this); this.select();" 
		   onBlur="javascript:fm(this,2);"  
		   onchange="javascript:sugerir_RHHFpuntuacion();"
		   onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
		   value="<cfif modo neq 'ALTA'>#rsForm.RHHFponderacion#</cfif>" 
		   size="10" maxlength="10" >&nbsp;<b>%</b>
    </tr>
    <tr> 
      <td nowrap align="right"><cf_translate key="LB_RHHFpuntuacion" >Puntuaci&oacute;n</cf_translate>:&nbsp;</td>
      <td nowrap>
		  <input name="RHHFpuntuacion" type="text" style="text-align: right;" tabindex="1"
		   onfocus="javascript:this.value=qf(this); this.select();" 
		   onBlur="javascript:fm(this,2);"  
		   onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
		   value="<cfif modo neq 'ALTA'>#rsForm.RHHFpuntuacion#</cfif>" 
		   size="10" maxlength="10" >
    </tr>
	
	<tr><td colspan="2">&nbsp;</td></tr>
	<tr>
		<td nowrap colspan="2" align="center">
			<cfset tabindex=1>
			<cfif modo eq 'ALTA'>
				<cf_botones modo="#modo#">
			<cfelse>
				<cf_botones modo="#modo#" include="Subfactores">
			</cfif>
		</td>
	</tr>
	<tr align="center"> 
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
	
	<cfif modo NEQ 'ALTA'>
			 <input type="hidden" name="RHHFid" value="#form.RHHFid#">
			 <input type="hidden" name="RHHFpuntuacionActual" value="#rsForm.RHHFpuntuacion#">
	</cfif>
	<tr> 
      <td colspan="2" nowrap="nowrap">
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

	objForm.RHHFcodigo.required 			= true;
	objForm.RHHFdescripcion.required 	= true;
	objForm.RHHFponderacion.required 	= true;
	objForm.RHHFponderacion.validateRango('0','100');
	objForm.RHHFpuntuacion.required 		= true;
	objForm.RHHFcodigo.description		="<cfoutput>#MSG_Codigo#</cfoutput>";
	objForm.RHHFdescripcion.description	="<cfoutput>#MSG_Descripcion#</cfoutput>";
	objForm.RHHFponderacion.description	="<cfoutput>#MSG_Ponderacion#</cfoutput>";
	objForm.RHHFpuntuacion.description		="<cfoutput>#MSG_RHHFpuntuacion#</cfoutput>";
	
	function deshabilitarValidacion(){
		objForm.RHHFcodigo.required 			= false;
		objForm.RHHFdescripcion.required 	= false;
		objForm.RHHFponderacion.required 	= false;
		objForm.RHHFpuntuacion.required 		= false;
	}	
	
	function habilitarValidacion(){
		objForm.RHHFcodigo.required 			= true;
		objForm.RHHFdescripcion.required 	= true;
		objForm.RHHFponderacion.required 	= true;
		objForm.RHHFpuntuacion.required 		= true;
	} 
	
	function sugerir_RHHFpuntuacion(){
		var RHHFponderacion = new Number(qf(document.form1.RHHFponderacion.value)) * 10;
		document.form1.RHHFpuntuacion.value = RHHFponderacion;
		fm(document.form1.RHHFpuntuacion,2);
	}
	
	function funcSubfactores(){
		document.form1.action = 'Subfactores.cfm';
	}
	
	fm(document.form1.RHHFpuntuacion,2);  
	fm(document.form1.RHHFponderacion,2);

</script>