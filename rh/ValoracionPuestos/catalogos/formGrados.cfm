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
s<cfinvoke component="sif.Componentes.Translate"
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
<cfif isdefined("form.Cambio") or isdefined("form.RHGid") and len(trim(form.RHGid))>
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
		select upper(rtrim(RHGcodigo))as RHGcodigo,RHGdescripcion,RHGporcvalorfactor
		from RHGrados 
		where RHFid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHFid#">
		  and RHGid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHGid#">
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

<form name="form1" method="post" action="SQLGrados.cfm">
  <cfoutput>
  <table width="100%" border="0" cellspacing="0" cellpadding="0" >
    <tr> 
      <td nowrap align="right"><cf_translate key="LB_Codigo" XmlFile="/rh/generales.xml">C&oacute;digo</cf_translate>:&nbsp;</td>
      <td nowrap>
	  	<input name="RHGcodigo" type="text" tabindex="1" value="<cfif modo neq 'ALTA'>#Trim(rsForm.RHGcodigo)#</cfif>" size="10" maxlength="10" onFocus="javascript:this.select();" style="text-transform:uppercase;">
	  </td>
    </tr>
    <tr> 
      <td nowrap align="right"><cf_translate key="LB_Decripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate>:&nbsp;</td>
      <td nowrap><input name="RHGdescripcion" type="text" tabindex="1" value="<cfif modo neq 'ALTA'>#rsForm.RHGdescripcion#</cfif>" size="55" maxlength="100" onFocus="javascript:this.select();"></td>
    </tr>
    <cfif modo neq 'ALTA'>
		<tr> 
		  <td nowrap align="right"><cf_translate key="LB_Puntuacion" >Puntuaci&oacute;n</cf_translate>
		    :&nbsp;</td>
		  <td nowrap>
			   #LSNumberFormat(rsForm.RHGporcvalorfactor,'____.__')#&nbsp;<b>%</b>
		  </td>	
		</tr>
	</cfif>
	<tr><td colspan="2">&nbsp;</td></tr>
	<tr>
		<td nowrap colspan="2" align="center">
			<cfset tabindex=1>
			<cf_botones modo="#modo#" include="Regresar">

		</td>
	</tr>
	<tr align="center"> 
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
	<input type="hidden" name="RHFid" value="#form.RHFid#">
	<cfif modo NEQ 'ALTA'>
		 <input type="hidden" name="RHGid" value="#form.RHGid#">
	</cfif>
	<tr> 
      <td colspan="2">
	  	<fieldset>
		<legend>
		<cf_translate key="LB_Recomendaciones" >Recomendaciones</cf_translate>
		</legend>
		<table width="100%" border="0" cellpadding="2" cellspacing="2">
			<tr>
				<td width="5%"><img src="/cfmx/rh/imagenes/TBP_0077.JPG"/></td>
				<td><cf_translate key="LB_NoCrearGradosInexistentes" >No crear grados inexistentes</cf_translate></td>
			</tr>
			<tr>
				<td width="5%"><img src="/cfmx/rh/imagenes/TBP_0077.JPG"/></td>
				<td><cf_translate key="LB_ElPrimerGradoNoDebeSerLaNegacionDelFactor" >El primer grado no debe ser la negaci&oacute;n del factor</cf_translate></td>
			</tr>
			<tr>
				<td width="5%"><img src="/cfmx/rh/imagenes/TBP_0077.JPG"/></td>
				<td><cf_translate key="LB_ElOrdenDeLosGradosDebeSerContinuo" >El orden de los grados debe ser continuo</cf_translate></td>
			</tr>
			<tr>
				<td width="5%"><img src="/cfmx/rh/imagenes/TBP_0077.JPG"/></td>
				<td><cf_translate key="LB_ElOrdenDeImportanciaAcordeConElNumeroDelGrado" >El orden de importancia acorde con el n&uacute;mero del grado</cf_translate></td>
			</tr>			
			<tr>
				<td width="5%"><img src="/cfmx/rh/imagenes/TBP_0077.JPG"/></td>
				<td><cf_translate key="LB_ElNumeroDeGradosNoDebeSerMenorDe3" >El n&uacute;mero de grados no debe ser menor de 3</cf_translate></td>
			</tr>
            <tr>
				<td width="5%"><img src="/cfmx/rh/imagenes/TBP_0077.JPG"/></td>
				<td><cf_translate key="LB_El_primer_grado_que_se_inserta_tomara_el_menor_valor" >El primer grado que se inserta tendr&aacute; el menor valor</cf_translate></td>
			</tr>
		</table>
		</fieldset>
	  </td>
    </tr>
  </table>  
	
	
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

	objForm.RHGcodigo.required 			= true;
	objForm.RHGdescripcion.required 	= true;
	objForm.RHGcodigo.description		="<cfoutput>#MSG_Codigo#</cfoutput>";
	objForm.RHGdescripcion.description	="<cfoutput>#MSG_Descripcion#</cfoutput>";
	
	function deshabilitarValidacion(){
		objForm.RHGcodigo.required 			= false;
		objForm.RHGdescripcion.required 	= false;
	}	
	
	function habilitarValidacion(){
		objForm.RHGcodigo.required 			= true;
		objForm.RHGdescripcion.required 	= true;
	} 
	
	function funcRegresar(){
		deshabilitarValidacion();
		document.form1.action = 'Factores.cfm';
	}
	
</script>