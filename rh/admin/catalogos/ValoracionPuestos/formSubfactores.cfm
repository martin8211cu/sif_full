<!--- Sección de Etiquetas de Traducción --->
<!-- Establecimiento del modo -->
<cfif isdefined('url.RHHFid') and not isdefined('form.RHHFid')>
	<cfset form.RHHFid = url.RHHFid>
</cfif>
<cfif isdefined('url.RHHSFid') and not isdefined('form.RHHSFid')>
	<cfset form.RHHSFid = url.RHHSFid>
</cfif>

<cfif isdefined("form.Cambio") or isdefined("form.RHHSFid") and len(trim(form.RHHSFid))>
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
		select upper(rtrim(RHHSFcodigo))as RHHSFcodigo,RHHSFdescripcion,RHHSFponderacion,RHHSFpuntuacion
		from RHHSubfactores 
		where RHHSFid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHHSFid#">
	</cfquery>
</cfif>

	<!--- DATOS DE FACTOR --->
	<cfquery name="rsFactor" datasource="#session.DSN#">
		select RHHFcodigo,RHHFdescripcion,RHHFponderacion,RHHFpuntuacion
		from RHHFactores
		where RHHFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHHFid#">
	</cfquery>
	<cfset Lvar_FactorPuntuacion = rsFactor.RHHFpuntuacion>

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

<form name="form1" method="post" action="SQLSubfactores.cfm">
	<input name="RHHFid" type="hidden" value="<cfoutput>#form.RHHFid#</cfoutput>" />
  <cfoutput>
  <table width="100%" border="0" cellspacing="0" cellpadding="0" >
	<tr>
		<td class="titulolistas"colspan="2" height="20">
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr><td align="center" colspan="2"><cfoutput><strong>#LB_Factor#:</strong>&nbsp;#rsFactor.RHHFcodigo#&nbsp;-&nbsp;#rsFactor.RHHFdescripcion#&nbsp;</cfoutput></td></tr>
				<tr>
					<td align="center"><cfoutput><strong>#LB_Ponderacion#:</strong>&nbsp;#LSCurrencyFormat(rsFactor.RHHFponderacion,'none')#%</cfoutput></td>
					<td align="center"><cfoutput><strong>#LB_RHHSFpuntuacion#:</strong>&nbsp;#LSCurrencyFormat(rsFactor.RHHFpuntuacion,'none')#</cfoutput></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
    <tr> 
      <td nowrap align="right"><cf_translate key="LB_Codigo" XmlFile="/rh/generales.xml">C&oacute;digo</cf_translate>:&nbsp;</td>
      <td nowrap>
	  	<input name="RHHSFcodigo" type="text" tabindex="1" value="<cfif modo neq 'ALTA'>#Trim(rsForm.RHHSFcodigo)#</cfif>" size="10" maxlength="10" onFocus="javascript:this.select();" style="text-transform:uppercase;">
	  </td>
    </tr>
    <tr> 
      <td nowrap align="right"><cf_translate key="LB_Decripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate>:&nbsp;</td>
      <td nowrap><input name="RHHSFdescripcion" type="text" tabindex="1" value="<cfif modo neq 'ALTA'>#rsForm.RHHSFdescripcion#</cfif>" size="55" maxlength="100" onFocus="javascript:this.select();"></td>
    </tr>
    <tr> 
      <td nowrap align="right"><cf_translate key="LB_Ponderacion" >Ponderaci&oacute;n</cf_translate>:&nbsp;</td>
      <td nowrap>
		  <input name="RHHSFponderacion" type="text" style="text-align: right;" tabindex="1"
		   onfocus="javascript:this.value=qf(this); this.select();" 
		   onBlur="javascript:fm(this,2);"  
		   onchange="javascript:sugerir_RHHSFpuntuacion(<cfoutput>#Lvar_FactorPuntuacion#</cfoutput>);"
		   onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
		   value="<cfif modo neq 'ALTA'>#rsForm.RHHSFponderacion#</cfif>" 
		   size="10" maxlength="10" >&nbsp;<b>%</b>
    </tr>
    <tr> 
      <td nowrap align="right"><cf_translate key="LB_RHHSFpuntuacion" >Puntuaci&oacute;n</cf_translate>:&nbsp;</td>
      <td nowrap>
		  <input name="RHHSFpuntuacion" type="text" style="text-align: right;" tabindex="1" readonly
		   onfocus="javascript:this.value=qf(this); this.select();" 
		   onBlur="javascript:fm(this,2);"  
		   onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
		   value="<cfif modo neq 'ALTA'>#rsForm.RHHSFpuntuacion#</cfif>" 
		   size="10" maxlength="10" >
    </tr>
	
	<tr><td colspan="2">&nbsp;</td></tr>
	<tr>
		<td nowrap colspan="2" align="center">
			<cfset tabindex=1>
			<cfif modo eq 'ALTA'>
				<cf_botones modo="#modo#">
			<cfelse>
				<cf_botones modo="#modo#" regresar="Factores.cfm?RHHFid=#form.RHHFid#">
			</cfif>
		</td>
	</tr>
	<tr align="center"> 
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
	
	<cfif modo NEQ 'ALTA'>
			 <input type="hidden" name="RHHSFid" value="#form.RHHSFid#">
			 <input type="hidden" name="RHHSFpuntuacionActual" value="#rsForm.RHHSFpuntuacion#">
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

	objForm.RHHSFcodigo.required 			= true;
	objForm.RHHSFdescripcion.required 	= true;
	objForm.RHHSFponderacion.required 	= true;
	objForm.RHHSFponderacion.validateRango('0','100');
	objForm.RHHSFpuntuacion.required 		= true;
	objForm.RHHSFcodigo.description		="<cfoutput>#MSG_Codigo#</cfoutput>";
	objForm.RHHSFdescripcion.description	="<cfoutput>#MSG_Descripcion#</cfoutput>";
	objForm.RHHSFponderacion.description	="<cfoutput>#MSG_Ponderacion#</cfoutput>";
	objForm.RHHSFpuntuacion.description		="<cfoutput>#MSG_RHHSFpuntuacion#</cfoutput>";
	
	function deshabilitarValidacion(){
		objForm.RHHSFcodigo.required 			= false;
		objForm.RHHSFdescripcion.required 	= false;
		objForm.RHHSFponderacion.required 	= false;
		objForm.RHHSFpuntuacion.required 		= false;
	}	
	
	function habilitarValidacion(){
		objForm.RHHSFcodigo.required 			= true;
		objForm.RHHSFdescripcion.required 	= true;
		objForm.RHHSFponderacion.required 	= true;
		objForm.RHHSFpuntuacion.required 		= true;
	} 
	
	function sugerir_RHHSFpuntuacion(puntos){
		var RHHSFponderacion = new Number(qf(document.form1.RHHSFponderacion.value)) * (puntos/100);
		document.form1.RHHSFpuntuacion.value = RHHSFponderacion;
		fm(document.form1.RHHSFpuntuacion,2);
	}
	
	function funcSubfactores(){
		document.form1.action = 'Subfactores.cfm';
	}
	
	fm(document.form1.RHHSFpuntuacion,2);  
	fm(document.form1.RHHSFponderacion,2);
	
	function funcRegresar(){
		location
	}

</script>