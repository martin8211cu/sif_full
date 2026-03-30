<cfif isdefined("form.RHVPid") and len(trim(form.RHVPid)) gt 0>
	<cfset Form.modo='CAMBIO'>
</cfif>




<!--- Consultas en modo Cambio --->
<cfif modo neq 'AlTA'>
	<cfquery name="rsForm" datasource="#session.dsn#">
		select RHVPid, Ecodigo, RHVPdescripcion,RHVPfdesde, RHVPfhasta ,RHVUsaPropuestos,ts_rversion
		from RHValoracionPuesto 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and RHVPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHVPid#">
	</cfquery>

	<cfif rsForm.RecordCount lte 0>
		<cfset Form.modo='ALTA'><!--- Devuelve el modo a ALTA para evitar errores--->
	</cfif>
	<cfquery name="rsResultados" datasource="#session.dsn#">
		select count(1) as Cont
		from RHValoracionPuesto
		where RHVPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHVPid#">
	</cfquery>
</cfif>

<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_PrecaucionEstaRelacionYacontieneinformacionDeseaEliminarla"
	Default="Precaución!, esta Relación ya contiene información. ¿Desea Eliminarla?"
	returnvariable="MSG_PrecaucionEstaRelacionYacontieneinformacionDeseaEliminarla"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DeseaEliminarLaRelacion"
	Default="¿Desea Eliminar la Relación?"
	returnvariable="MSG_DeseaEliminarLaRelacion"/>

<script language="javascript1.2" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js">//</script>
<script language="javascript1.2" type="text/javascript">
 	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	// funciones del form

	function funcLimpiar(){
		document.form1.reset();
	}
	function funcBaja(){
		return confirm(
		<cfif isdefined("rsResultados") and rsResultados.Cont gt 0>
			'<cfoutput>#MSG_PrecaucionEstaRelacionYacontieneinformacionDeseaEliminarla#</cfoutput>'
		<cfelse>
			'<cfoutput>#MSG_DeseaEliminarLaRelacion#</cfoutput>'
		</cfif>
		);
	}
	function funcSiguiente(){
		document.form1.SEL.value = "2";
		document.form1.action = "registro_valoracion.cfm";
		return true;
	}
	function funcAlta(){
		document.form1.params.value = "?SEL=2";
		return true;
	}
</script>
<link href="STYLE.CSS" rel="stylesheet" type="text/css">
<form action="registro_valoracion_sql.cfm" method="post" name="form1">
<table width="95%" align="center"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td rowspan="7">&nbsp;</td>
	<td colspan="3">&nbsp;</td>
    <td rowspan="7">&nbsp;</td>
  </tr>
  <tr>
    <td width="15%" valign="middle" nowrap><strong><cf_translate key="LB_Descripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate>:</strong>&nbsp;</td>
    <td colspan="2" valign="middle" width="50%">
      <cfif modo neq 'AlTA' and isdefined("rsForm.RHVPdescripcion") and len(trim(rsForm.RHVPdescripcion)) gt 0>
        <cfoutput>
          <input name="RHVPdescripcion" type="text" value="#rsForm.RHVPdescripcion#" size="50" maxlength="100" tabindex="1">
        </cfoutput>
        <cfelse>
        <input name="RHVPdescripcion" type="text" value="" size="50" maxlength="100" tabindex="1">
      </cfif>
	</td>
  </tr>
  <tr>
  	<td colspan="1" nowrap><strong><cf_translate key="LB_Vigencia">Vigencia</cf_translate>:</strong>&nbsp;</td>
	<td colspan="2">
		<cfif modo neq 'AlTA' and isdefined("rsForm.RHVPfdesde") and len(trim(rsForm.RHVPfdesde)) gt 0>
			<cf_sifcalendario name="RHVPfdesde" value="#LSDateFormat(rsForm.RHVPfdesde,'dd/mm/yyyy')#" tabindex="1">
		<cfelse>
			<cf_sifcalendario name="RHVPfdesde" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" tabindex="1">
		</cfif>
	</td>
  </tr>
  <tr>
   	<td colspan="1" nowrap><strong><cf_translate key="LB_Hasta">Hasta</cf_translate>:</strong>&nbsp;</td>
	<td colspan="2">
		<cfif modo neq 'AlTA' and isdefined("rsForm.RHVPfhasta") and len(trim(rsForm.RHVPfhasta)) gt 0 and LSDateFormat(rsForm.RHVPfhasta,'dd/mm/yyyy') neq '01/01/6100'>
			<cf_sifcalendario name="RHVPfhasta" value="#LSDateFormat(rsForm.RHVPfhasta,'dd/mm/yyyy')#" tabindex="1">
		<cfelse>
			<cf_sifcalendario name="RHVPfhasta" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" tabindex="1">
		</cfif>
	</td>
  </tr>
  <tr>
  	<td colspan="1" >&nbsp;</td>
	<td colspan="2">
		<cfif modo neq 'AlTA'>
        	<cfif isdefined("rsForm.RHVUsaPropuestos") and rsForm.RHVUsaPropuestos EQ 1>
				<img src="/cfmx/rh/imagenes/checked.gif" border="0">
			<cfelse>
				<img src="/cfmx/rh/imagenes/unchecked.gif" border="0">
			</cfif>
		<cfelse>
            <input name="RHVUsaPropuestos"
                   type="checkbox" 
                   <cfif isdefined("rsForm.RHVUsaPropuestos") and rsForm.RHVUsaPropuestos EQ 1>checked</cfif>
             >
		</cfif>        
		<cf_translate key="Utilizar_puestos_Propuestos">Utilizar Puestos Propuestos</cf_translate>	
	  </td>
  </tr>  
  <tr>
  	<td colspan="4">&nbsp;</td>
  </tr>
  <tr>
    <td colspan="4" align="center">
		<input type="hidden" name="SEL" value="">
		<input type="hidden" name="params" value="">
		<cfif modo neq 'AlTA' and isdefined("rsForm.RHVPid") and len(trim(rsForm.RHVPid)) gt 0>
			<cfoutput>
				<input type="hidden" name="RHVPid" value="#rsForm.RHVPid#">
			</cfoutput>
		</cfif>
		<cfif modo neq 'ALTA' and isdefined("rsForm.ts_rversion")>
		  <cfset ts = "">
          <cfinvoke 
				component="sif.Componentes.DButils"
				method="toTimeStamp"
				returnvariable="ts">
            <cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
          </cfinvoke>
		  <input type="hidden" name="ts_rversion" value="<cfoutput>#ts#</cfoutput>">
		</cfif>

		<cfif modo EQ "ALTA">
			<cf_botones values="Limpiar, Agregar" names="Limpiar,Alta" nbspbefore="4" nbspafter="4" tabindex="3">
		<cfelse>	
			<cf_botones values="Eliminar,Modificar,Siguiente" names="Baja,Cambio,Siguiente" nbspbefore="4" nbspafter="4" tabindex="3">
		</cfif>
	</td>
  </tr>
</table>
</form>

<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ElValorPara"
	Default="El valor para "
	returnvariable="MSG_ElValorPara"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DebeContenerSolamenteCaracteresAlfanumericosYLosSiguientesSimbolos"
	Default="debe contener solamente caracteres alfanuméricos,\n y los siguientes símbolos"
	returnvariable="MSG_DebeContenerSolamenteCaracteresAlfanumericosYLosSiguientesSimbolos"/>
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_FechaDesde"
	Default="Fecha desde"
	returnvariable="LB_FechaDesde"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_FechaHasta"
	Default="Fecha hasta"
	returnvariable="LB_FechaHasta"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Descripcion"
	Default="Descripci&oacute;n"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_Descripcion"/>
	
	
<script language="javascript1.2" type="text/javascript">
	//inicializa el form
	funcLimpiar()
	qFormAPI.errorColor = "#FFFFCC";
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
			this.error="<cfoutput>#MSG_ElValorPara#</cfoutput> "+this.description+" <cfoutput>#MSG_DebeContenerSolamenteCaracteresAlfanumericosYLosSiguientesSimbolos#</cfoutput>: (/*-+.:,;{}[]|°!$&()=?).";
		}
	}
	_addValidator("isAlfaNumerico", _Field_isAlfaNumerico);
	var objForm = new qForm("form1");
	<cfoutput>
	objForm.RHVPfdesde.description = "#LB_FechaDesde#";
	objForm.RHVPfhasta.description = "#LB_FechaHasta#";
	objForm.RHVPdescripcion.description = "#LB_Descripcion#";
	objForm.RHVPdescripcion.validateAlfaNumerico();
	objForm.RHVPfdesde.required = true;
	objForm.RHVPfhasta.required = true;
	objForm.RHVPdescripcion.required = true;
	</cfoutput>
	function habilitarValidacion(){
		objForm.RHVPfdesde.required = true;
		objForm.RHVPfhasta.required = true;
		objForm.RHVPdescripcion.required = true;
	}
	function deshabilitarValidacion(){
		objForm.RHVPfdesde.required = false;
		objForm.RHVPfhasta.required = false;
		objForm.RHVPdescripcion.required = false;		
	}
	objForm.RHVPdescripcion.obj.focus();
</script>


