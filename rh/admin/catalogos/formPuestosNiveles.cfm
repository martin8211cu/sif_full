<!-- Establecimiento del modo -->
<cfif isdefined("form.Cambio")>
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
		select upper(rtrim(RHNcodigo)) as RHNcodigo, RHNdescripcion, RHNhabcono, RHNequivalencia, ts_rversion
		from RHNiveles
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and RHNid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHNid#">
	</cfquery>
</cfif>

<!--- registros existentes --->
<cfquery name="rsCodigos" datasource="#session.DSN#">
	select upper(rtrim(RHNcodigo)) as RHNcodigo
	from RHNiveles
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

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

<form name="form1" method="post" action="SQLPuestosNiveles.cfm">
  	<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
    	<tr><td colspan="2">&nbsp;</td></tr>
    	<tr> 
      		<td nowrap align="right"><cf_translate key="LB_Codigo" XmlFile="/rh/generales.xml">C&oacute;digo</cf_translate>:&nbsp;</td>
      		<td nowrap>
			<input name="RHNcodigo" type="text" size="10" maxlength="1" style="text-transform:uppercase;" tabindex="1"
				value="<cfif modo neq 'ALTA'>#Trim(rsForm.RHNcodigo)#</cfif>" onFocus="javascript:this.select();" >
			</td>
		</tr>
		<tr> 
			<td nowrap align="right"><cf_translate key="LB_Decripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate>:&nbsp;</td>
			<td nowrap>
			<input name="RHNdescripcion" type="text"  size="53" maxlength="120" tabindex="1"
				value="<cfif modo neq 'ALTA'>#rsForm.RHNdescripcion#</cfif>" onFocus="javascript:this.select();">
			</td>
		</tr>

    	<tr> 
			<td nowrap align="right"><cf_translate key="LB_Tipo" XmlFile="/rh/generales.xml">Tipo</cf_translate>:&nbsp;</td>
			<td nowrap>
				<select name="RHNhabcono" tabindex="1">
					<option value="H" <cfif modo neq 'ALTA' and rsForm.RHNhabcono eq 'H' >selected</cfif> ><cf_translate key="CMB_Habilidad">Habilidad</cf_translate></option>
					<option value="C" <cfif modo neq 'ALTA' and rsForm.RHNhabcono eq 'C' >selected</cfif> ><cf_translate key="CMB_Conocimiento">Conocimiento</cf_translate></option>
				</select>
			</td>
   		</tr>

    	<tr> 
      		<td nowrap align="right"><cf_translate key="LB_Porcentaje">Porcentaje</cf_translate>:&nbsp;</td>
      		<td nowrap>
				<input type="text" name="RHNequivalencia" size="5" maxlength="4" style="text-align:right" tabindex="1" 
					value="<cfif modo neq 'ALTA' and len(trim(rsForm.RHNequivalencia))>#LSNumberFormat(rsForm.RHNequivalencia,',9')#</cfif>" 
					onkeyup="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" 
					onBlur="javascript:fm(this,0); porcentaje(this);" 
					onfocus="this.select();">
			</td>
    	</tr>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr>
			<td nowrap colspan="2" align="center">
				<cfset tabindex=1>
				<cfinclude template="/rh/portlets/pBotones.cfm">
			</td>
		</tr>
	
		<cfif modo NEQ 'ALTA'>
			<cfset ts = "">	
			<cfif modo neq "ALTA">
				<cfinvoke 
					component="sif.Componentes.DButils"
					method="toTimeStamp"
					returnvariable="ts">
					<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
				</cfinvoke>
			</cfif>
			<tr>
				<td>
					<input type="hidden" name="ts_rversion" value="#ts#">
					<input type="hidden" name="RHNid" value="#form.RHNid#">
				</td>
			</tr>
		</cfif>
  </table>  
  </cfoutput>
</form>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ElCodigoDeNivelYaExisteDefinaUnoDistinto"
	Default="El Código de Nivel ya existe, defina uno distinto"
	returnvariable="MSG_ElCodigoDeNivelYaExisteDefinaUnoDistinto"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ElPorcentajeDebeEstarEnElRango0_100"
	Default="El porcentaje debe estar en el rango 0-100"
	returnvariable="MSG_ElPorcentajeDebeEstarEnElRango0_100"/>

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
	Key="MSG_Porcentaje"
	Default="Porcentaje"
	returnvariable="MSG_Porcentaje"/>


<script language="JavaScript1.2" type="text/javascript">

	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	function _Field_CodigoNoExiste(){
		<cfoutput query="rsCodigos">
			if (("#ucase(trim(RHNcodigo))#"==this.obj.value.toUpperCase())
			<cfif modo neq "ALTA">
			&&("#ucase(trim(rsForm.RHNcodigo))#"!=this.obj.value.toUpperCase())
			</cfif>
			)
				this.error = "#MSG_ElCodigoDeNivelYaExisteDefinaUnoDistinto#.";
		</cfoutput>
	}
	
	function __isPorcentaje() {
		if (objForm.RHNequivalencia.value < 0 || objForm.RHNequivalencia.value > 100 ){
				this.error = "<cfoutput>#MSG_ElPorcentajeDebeEstarEnElRango0_100#</cfoutput>."
		}
	}

	_addValidator("isCods", _Field_CodigoNoExiste);
	_addValidator("isPorcentaje", __isPorcentaje);
<cfoutput>
	objForm.RHNcodigo.required = true;
	objForm.RHNcodigo.description="#MSG_Codigo#";
	objForm.RHNcodigo.validateCods();
	objForm.RHNequivalencia.validatePorcentaje();		
	
	objForm.RHNdescripcion.required = true;
	objForm.RHNdescripcion.description="#MSG_Descripcion#";

	objForm.RHNequivalencia.required = true;
	objForm.RHNequivalencia.description="#MSG_Porcentaje#";
</cfoutput>
	function deshabilitarValidacion(){
		objForm.RHNcodigo.required = false;
		objForm.RHNdescripcion.required = false;
		objForm.RHNequivalencia.required = false;
	}

	function habilitarValidacion(){
		objForm.RHNcodigo.required = true;
		objForm.RHNdescripcion.required = true;
		objForm.RHNequivalencia.required = true;
	}
	
	function porcentaje(obj){
		if (trim(obj.value) != '' && ( obj.value < 0 || obj.value > 100 ) ){
			mensaje = '<cfoutput>#MSG_ElPorcentajeDebeEstarEnElRango0_100#</cfoutput>.';
			obj.value = '';
			alert(mensaje);
			return false;
		}
		return true;
	}

	objForm.RHNcodigo.obj.focus();

</script>