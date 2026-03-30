<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Descripcion"
	Default="Descripci&oacute;n"
	returnvariable="LB_Descripcion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_FechaDesde"
	Default="Fecha Desde"
	returnvariable="LB_FechaDesde"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_FechaCorte"
	Default="Fecha Corte"
	returnvariable="LB_FechaCorte"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_FechaHasta"
	Default="Fecha Hasta"
	returnvariable="LB_FechaHasta"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_FechadeCorte"
	Default="Fecha de Corte"
	returnvariable="LB_FechadeCorte"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ItemsEvaluables"
	Default="Items evaluables"
	returnvariable="LB_ItemsEvaluables"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Ambos"
	Default="Ambos"
	returnvariable="LB_Ambos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Conocimientos"
	Default="Conocimientos"
	returnvariable="LB_Conocimientos"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Habilidades"
	Default="Habilidades"
	returnvariable="LB_Habilidades"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ErrorLaFechaDeInicio"
	Default="Error, la fecha de inicio"
	returnvariable="MSG_ErrorLaFechaDeInicio"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_NoDebeSerMayorQueLaFechaFinal"
	Default="no debe ser mayor que la fecha final"
	returnvariable="MSG_NoDebeSerMayorQueLaFechaFinal"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ElValorPara"
	Default="El valor para"
	returnvariable="MSG_ElValorPara"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DebeContenerSolamenteCaracteresAlfanumericosYLosSiguientesSimbolos"
	Default="debe contener solamente caracteres alfanuméricos,\n y los siguientes símbolos"
	returnvariable="MSG_DebeContenerSolamenteCaracteresAlfanumericosYLosSiguientesSimbolos"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_PrecaucionEstaRelacionYaHaSidoHabilitadaParaSerAccesadaDesdeAutoGestionSiempreDeseaEliminarla"
	Default="Precaución!, esta Relación ya ha sido habilitada para ser accesada desde AutoGestión. ¿Siempre desea eliminarla?"
	returnvariable="MSG_PrecaucionEstaRelacionYaHaSidoHabilitadaParaSerAccesadaDesdeAutoGestionSiempreDeseaEliminarla"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DeseaEliminarLaRelacion"
	Default="¿Desea Eliminar la Relación?"
	returnvariable="MSG_DeseaEliminarLaRelacion"/>	


<!--- FIN VARIABLES DE TRADUCCION --->

<cfif isdefined("form.RHRCid") and len(trim(form.RHRCid)) gt 0>
	<cfset Form.modo='CAMBIO'>
<cfelse>
	<cfset Form.modo='ALTA'>
</cfif>

<!--- Consultas en modo Cambio --->
<cfif modo neq 'AlTA'>
	<cfquery name="rsForm" datasource="#session.dsn#"><!--- RHPcodigo,  --->
		select RHRCid, Ecodigo, RHRCdesc, RHRCfdesde, RHRCfhasta, RHRCfcorte, RHRCitems, RHRCestado, BMUsucodigo, ts_rversion
		from RHRelacionCalificacion
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and RHRCid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#"> 
	</cfquery>

	<cfif rsForm.RecordCount lte 0>
		<cfset Form.modo='ALTA'><!--- Devuelve el modo a ALTA para evitar errores--->
	</cfif>
	
	<cfquery name="rsEstado" datasource="#session.dsn#">
		select count(1) as Cont
		from RHRelacionCalificacion
		where RHRCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#">
			and RHRCestado = 10 
	</cfquery>
</cfif>
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
		<cfif isdefined("rsEstado") and rsEstado.Cont gt 0>
			'<cfoutput>#MSG_PrecaucionEstaRelacionYaHaSidoHabilitadaParaSerAccesadaDesdeAutoGestionSiempreDeseaEliminarla#</cfoutput>'
		<cfelse>
			'<cfoutput>#MSG_DeseaEliminarLaRelacion#</cfoutput>'
		</cfif>
		);
	}
	function funcSiguiente(){
		document.form1.SEL.value = "2";
		document.form1.action = "actCompetencias.cfm";
		return true;
	}
</script>
<cfoutput>
<form action="actCompetencias_sql.cfm" method="post" name="form1">
<table width="95%" align="center"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td rowspan="7">&nbsp;</td>
	<td colspan="3">&nbsp;</td>	
    <td rowspan="7">&nbsp;</td>
  </tr>
  <tr>
    <td width="15%" valign="middle" nowrap><strong>#LB_Descripcion#:</strong>&nbsp;</td>
    <td colspan="2" valign="middle" width="50%">
      <cfif modo neq 'AlTA' and isdefined("rsForm.RHRCdesc") and len(trim(rsForm.RHRCdesc)) gt 0>
          <input name="RHRCdesc" type="text" value="#rsForm.RHRCdesc#" size="50" maxlength="100" tabindex="1">
        <cfelse>
        <input name="RHRCdesc" type="text" value="" size="50" maxlength="100" tabindex="1">
      </cfif>
	</td>
  </tr>
  <tr>
  	<td colspan="1" nowrap><strong>#LB_FechaDesde#:</strong>&nbsp;</td>
	<td colspan="2">
		<cfif modo neq 'AlTA' and isdefined("rsForm.RHRCfdesde") and len(trim(rsForm.RHRCfdesde)) gt 0>
			<cf_sifcalendario name="RHRCfdesde" value="#LSDateFormat(rsForm.RHRCfdesde,'dd/mm/yyyy')#" tabindex="1">
		<cfelse>
			<cf_sifcalendario name="RHRCfdesde" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" tabindex="1">
		</cfif>
	</td>
  </tr>
  <tr>
   	<td colspan="1" nowrap><strong>#LB_FechaHasta#:</strong>&nbsp;</td>
	<td colspan="2">
		<cfif modo neq 'AlTA' and isdefined("rsForm.RHRCfhasta") and len(trim(rsForm.RHRCfhasta)) gt 0 and LSDateFormat(rsForm.RHRCfhasta,'dd/mm/yyyy') neq '01/01/6100'>
			<cf_sifcalendario name="RHRCfhasta" value="#LSDateFormat(rsForm.RHRCfhasta,'dd/mm/yyyy')#" tabindex="1">
		<cfelse>
			<cf_sifcalendario name="RHRCfhasta" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" tabindex="1">
		</cfif>
	</td>
  </tr>
  <tr>
   	<td colspan="1" nowrap><strong>#LB_FechadeCorte#:</strong>&nbsp;</td>
	<td colspan="2">
		<cfif modo neq 'AlTA' and isdefined("rsForm.RHRCfcorte") and len(trim(rsForm.RHRCfcorte)) gt 0 and LSDateFormat(rsForm.RHRCfcorte,'dd/mm/yyyy') neq '01/01/6100'>
			<cf_sifcalendario name="RHRCfcorte" value="#LSDateFormat(rsForm.RHRCfcorte,'dd/mm/yyyy')#" tabindex="1">
		<cfelse>
			<cf_sifcalendario name="RHRCfcorte" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" tabindex="1">
		</cfif>
	</td>
  </tr>  
  <tr>
  	<td colspan="1" nowrap><strong>#LB_ItemsEvaluables#:&nbsp;</strong></td>
	<td colspan="2">	
      <input name="RHRCitems" id="r1" type="radio" value="H" <cfif modo NEQ 'CAMBIO'> checked<cfelseif rsForm.RHRCitems EQ 'H'> checked</cfif> tabindex="1">
      <label for="r1" style="font-style:normal; font-variant:normal; font-weight:normal">#LB_Habilidades#</label>
      <input name="RHRCitems" id="r2" type="radio" value="C" <cfif modo NEQ 'ALTA' and rsForm.RHRCitems EQ 'C'> checked</cfif> tabindex="1">
      <label for="r2" style="font-style:normal; font-variant:normal; font-weight:normal">#LB_Conocimientos#</label>
      <input name="RHRCitems" id="r3" type="radio" value="A" <cfif modo NEQ 'ALTA' and rsForm.RHRCitems EQ 'A'> checked</cfif> tabindex="1">
      <label for="r3" style="font-style:normal; font-variant:normal; font-weight:normal">#LB_Ambos#</label></td>
  </tr>
  <tr>
  	<td colspan="4">&nbsp;</td>
  </tr>
  <tr>
    <td colspan="4" align="center">
		<input type="hidden" name="SEL" value="">
		<cfif modo neq 'AlTA' and isdefined("rsForm.RHRCid") and len(trim(rsForm.RHRCid)) gt 0>
			<input type="hidden" name="RHRCid" value="#rsForm.RHRCid#">
			<input type="hidden" name="RHRCestado" value="#rsForm.RHRCestado#">
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
		<cfelseif isdefined('rsForm') and rsForm.RHRCestado EQ 0>
			<cf_botones values="Eliminar,Modificar,Siguiente" names="Baja,Cambio,Siguiente" nbspbefore="4" nbspafter="4" tabindex="3">		
		<cfelse>		
			<cf_botones values="Modificar,Siguiente" names="Cambio,Siguiente" nbspbefore="4" nbspafter="4" tabindex="3">
		</cfif>
	</td>
  </tr>
</table>
</form>
</cfoutput>
<script language="javascript1.2" type="text/javascript">
	//inicializa el form
	funcLimpiar()
	qFormAPI.errorColor = "#FFFFCC";
	function _Field_isAlfaNumerico(){
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
	function _isFechas(){
		var valorINICIO=0;
		var valorFIN=0;
		var INICIO = document.form1.RHRCfdesde.value;
		var FIN = this.value;
		
		INICIO = INICIO.substring(6,10) + INICIO.substring(3,5) + INICIO.substring(0,2)
		FIN = FIN.substring(6,10) + FIN.substring(3,5) + FIN.substring(0,2)
		valorINICIO = parseInt(INICIO)
		valorFIN = parseInt(FIN)

		if (valorINICIO > valorFIN)
			this.error="<cfoutput>#MSG_ErrorLaFechaDeInicio#</cfoutput> (" + document.form1.RHRCfdesde.value + ") <cfoutput>#MSG_NoDebeSerMayorQueLaFechaFinal#</cfoutput> (" + this.value + ")";
	}	
	
	_addValidator("isAlfaNumerico", _Field_isAlfaNumerico);
	_addValidator("isFechas", _isFechas);	
	<cfoutput>
	var objForm = new qForm("form1");
	objForm.RHRCfdesde.description = "#LB_FechaDesde#";
	objForm.RHRCfhasta.description = "#LB_FechaHasta#";
	objForm.RHRCfcorte.description = "#LB_FechaCorte#";
	objForm.RHRCdesc.description = "#LB_Descripcion#";
	</cfoutput>
	//objForm.RHRCdesc.validateAlfaNumerico();
	objForm.RHRCfhasta.validateFechas();
	
	objForm.RHRCfdesde.required = true;
	objForm.RHRCfhasta.required = true;
	objForm.RHRCfcorte.required = true;
	
	objForm.RHRCdesc.required = true;
	function habilitarValidacion(){
		objForm.RHRCfdesde.required = true;
		objForm.RHRCfhasta.required = true;
		objForm.RHRCfcorte.required = true;
		objForm.RHRCdesc.required = true;
	}
	function deshabilitarValidacion(){
		objForm.RHRCfdesde.required = false;
		objForm.RHRCfhasta.required = false;
		objForm.RHRCfcorte.required = false;
		objForm.RHRCdesc.required = false;
	}
	function VALIDAFECHAS(INICIO,FIN){

	}		
	
	
		
	objForm.RHRCdesc.obj.focus();
</script>


