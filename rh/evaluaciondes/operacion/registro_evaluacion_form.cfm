<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="MSG_PrecaucionEstaRelacionYacontieneResultadosDeseaEliminarla" default="Precaución!, esta Relación ya contiene Resultados. ¿Desea Eliminarla?" returnvariable="MSG_PrecaucionEstaRelacionYacontieneResultadosDeseaEliminarla" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_DeseaEliminarLaRelacion" default="¿Desea Eliminar la Relación?" returnvariable="MSG_DeseaEliminarLaRelacion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_CuestionarioEspecifico" default="Cuestionario específico" returnvariable="LB_CuestionarioEspecifico" component="sif.Componentes.Translate" method="Translate"/>

<!--- FIN VARIABLES DE TRADUCCION--->
<cfif isdefined("form.RHEEid") and len(trim(form.RHEEid)) gt 0>
	<cfset Form.modo='CAMBIO'>
</cfif>
<!--- Consultas en cualquier modo --->
<cfquery name="rsTablas" datasource="#session.dsn#">
	select TEcodigo, TEnombre
	from TablaEvaluacion
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfquery name="data" datasource="#session.DSN#">
	select a.PCid, a.PCnombre, a.PCdescripcion, 1 as agrupador
	from PortalCuestionario a
	  inner join RHEvaluacionCuestionarios b
		on a.PCid = b.PCid
		and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<!--- Consultas en modo Cambio --->
<cfif modo neq 'AlTA'>
	<cfquery name="rsForm" datasource="#session.dsn#">
		select RHEEid, Ecodigo, Usucodigo, RHEEdescripcion, RHEEfecha, RHEEfdesde, RHEEfhasta, RHEEestado, RHEEtipoeval, TEcodigo,coalesce(RHEEMostrarTitulo, 'N') as  RHEEMostrarTitulo,
		PCid,Aplica, AplicaPara, ts_rversion,CFid,Porc_dist 
		from RHEEvaluacionDes 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#">
	</cfquery>

	<cfif rsForm.RecordCount lte 0>
		<cfset Form.modo='ALTA'><!--- Devuelve el modo a ALTA para evitar errores--->
	</cfif>
	<cfquery name="rsResultados" datasource="#session.dsn#">
		select count(1) as Cont
		from RHDEvaluacionDes
		where RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#">
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
		//mostrarTabla(<cfif modo neq 'AlTA' and isdefined("rsForm.RHEEtipoeval") and rsForm.RHEEtipoeval eq 'T'>true<cfelse>false</cfif>);
	}
	function funcBaja(){
		return confirm(
		<cfif isdefined("rsResultados") and rsResultados.Cont gt 0>
			'<cfoutput>#MSG_PrecaucionEstaRelacionYacontieneResultadosDeseaEliminarla#</cfoutput>'
		<cfelse>
			'<cfoutput>#MSG_DeseaEliminarLaRelacion#</cfoutput>'
		</cfif>
		);
	}
	function funcSiguiente(){
		document.form1.SEL.value = "2";
		document.form1.action = "registro_evaluacion.cfm";
		return true;
	}
	function funcAlta(){
		document.form1.params.value = "?SEL=2";
		return true;
	}
</script>
<link href="STYLE.CSS" rel="stylesheet" type="text/css">
<form action="registro_evaluacion_sql.cfm" method="post" name="form1">
<table width="95%" align="center"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td rowspan="7">&nbsp;</td>
	<td colspan="3">&nbsp;</td>
    <td rowspan="7">&nbsp;</td>
  </tr>
  <tr>
    <td width="15%" valign="middle" nowrap><strong><cf_translate key="LB_Descripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate>:</strong>&nbsp;</td>
    <td colspan="2" valign="middle" width="50%">
      <cfif modo neq 'AlTA' and isdefined("rsForm.RHEEdescripcion") and len(trim(rsForm.RHEEdescripcion)) gt 0>
        <cfoutput>
          <input name="RHEEdescripcion" type="text" value="#rsForm.RHEEdescripcion#" size="50" maxlength="100" tabindex="1">
        </cfoutput>
        <cfelse>
        <input name="RHEEdescripcion" type="text" value="" size="50" maxlength="100" tabindex="1">
      </cfif>
	</td>
  </tr>
  <tr>
  	<td colspan="1" nowrap><strong><cf_translate key="LB_Vigencia">Vigencia</cf_translate>:</strong>&nbsp;</td>
	<td colspan="2">
		<cfif modo neq 'AlTA' and isdefined("rsForm.RHEEfdesde") and len(trim(rsForm.RHEEfdesde)) gt 0>
			<cf_sifcalendario name="RHEEfdesde" value="#LSDateFormat(rsForm.RHEEfdesde,'dd/mm/yyyy')#" tabindex="1">
		<cfelse>
			<cf_sifcalendario name="RHEEfdesde" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" tabindex="1">
		</cfif>
	</td>
  </tr>
  <tr>
   	<td colspan="1" nowrap><strong><cf_translate key="LB_PermiteEvaluarHasta">Permite Evaluar hasta</cf_translate>:</strong>&nbsp;</td>
	<td colspan="2">
		<cfif modo neq 'AlTA' and isdefined("rsForm.RHEEfhasta") and len(trim(rsForm.RHEEfhasta)) gt 0 and LSDateFormat(rsForm.RHEEfhasta,'dd/mm/yyyy') neq '01/01/6100'>
			<cf_sifcalendario name="RHEEfhasta" value="#LSDateFormat(rsForm.RHEEfhasta,'dd/mm/yyyy')#" tabindex="1">
		<cfelse>
			<cf_sifcalendario name="RHEEfhasta" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" tabindex="1">
		</cfif>
	</td>
  </tr>
  <tr>
  	<td colspan="1"><strong><cf_translate key="LB_TipoDeEvaluacion">Tipo de evaluación</cf_translate>:&nbsp;</strong></td>
	<td colspan="2">	
		<select name="PCid" id="PCid" onchange="javascript:muestracampos();" tabindex="1"  <cfif modo eq 'Cambio'>disabled="disabled"</cfif> >
			<option value="-2" style="font-style:italic" <cfif isdefined("rsForm.PCid") and rsForm.PCid EQ -2>selected</cfif>><cf_translate key="LB_CuenstionariosPorHabilidadyConocimientos">Cuestionarios por habilidad y conocimientos</cf_translate></option>
   			<option value="-1" style="font-style:italic" <cfif isdefined("rsForm.PCid") and rsForm.PCid EQ -1>selected</cfif>><cf_translate key="LB_CuenstionariosPorHabilidad">Cuestionarios por habilidad</cf_translate></option>
			<option value="0" style="font-style:italic" <cfif isdefined("rsForm.PCid") and rsForm.PCid EQ 0>selected</cfif>><cf_translate key="LB_CuenstionariosPorConocimiento">Cuestionarios por Conocimiento</cf_translate></option>
			   <cfoutput  query="data" group="agrupador">
					<optgroup label="#LB_CuestionarioEspecifico#">
						<cfoutput>
				  			<option value="#data.PCid#" <cfif isdefined("rsForm.PCid") and rsForm.PCid EQ data.PCid>selected</cfif>>#data.PCdescripcion#</option>
						</cfoutput>
					</optgroup>
			   </cfoutput>
  		 </select>
	  </td>
  </tr>
  <tr><!---- fcastro 12/11/12 se agrega los evaluadores y para quienes aplica--->
  	<td><strong><cf_translate key="LB_AplicaPara">Aplica Para</cf_translate>:&nbsp;</strong></td>
	<td>
		<select name="AplicaPara" id="AplicaPara"tabindex="1">
			<option value="1" <cfif isdefined("rsForm.AplicaPara") and rsForm.AplicaPara EQ 1>selected</cfif>><cf_translate key="LB_Jefe">Jefe</cf_translate></option>
			<option value="2" <cfif isdefined("rsForm.AplicaPara") and rsForm.AplicaPara EQ 2>selected</cfif>><cf_translate key="LB_Jefe">Colaboradores</cf_translate></option>
		</select>
	</td>
  </tr>
  <tr><!---- linea de evaluadores---->
  	<td><strong><cf_translate key="LB_Evaluadores">Evaluadores</cf_translate>:&nbsp;</strong></td>
	<td>
		<select name="Aplica" id="Aplica"tabindex="1">
    		<option value="0" <cfif isdefined("rsForm.Aplica") and rsForm.Aplica EQ 0>selected</cfif>><cf_translate key="LB_Jefe">Ambos</cf_translate></option>
			<option value="1" <cfif isdefined("rsForm.Aplica") and rsForm.Aplica EQ 1>selected</cfif>><cf_translate key="LB_Jefe">Jefe</cf_translate></option>
			<option value="2" <cfif isdefined("rsForm.Aplica") and rsForm.Aplica EQ 2>selected</cfif>><cf_translate key="LB_Jefe">Colaboradores</cf_translate></option>
		</select>
	</td>
  </tr>
  <cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#" ecodigo="#session.Ecodigo#" pvalor="2106" default="" returnvariable="LvarPorc"/>
  <cfif LvarPorc gt 0>
  	<tr>
		<td>&nbsp;</td>
		<td>
			<strong>Porcentaje de jefatura:</strong>
		</td>
		<td><CF_inputNumber 
			name			= "porc"
			value			= "#rsform.Porc_dist#"
			default			= "0"
			enteros			= "3"
			decimales		= "0"
			negativos		= "false"
			comas			= "false"
			tabindex		= "1"/>
		</td>
	</tr>
  </cfif>
  <cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#" ecodigo="#session.Ecodigo#" pvalor="2107" default="" returnvariable="LvarCF"/>
  <cfif LvarCF gt 0>
  	<tr>
	  	<cfif LvarPorc gt 0>
			<td>&nbsp;</td>
		</cfif>
		<td>
			<strong>Centro Funcional:</strong>		
		</td>
		<td colspan="2">
			<cfif modo  neq 'AlTA' and len(trim(rsform.CFid)) gt 0>
				<cfquery name="rsCFid" datasource="#session.DSN#">
					select	
					CFid,
					CFcodigo,
					CFdescripcion
					from  CFuncional 
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsform.CFid#">
				</cfquery>
				<cf_rhcfuncional query="#rsCFid#" tabindex="1">
			<cfelse>
				<cf_rhcfuncional tabindex="1">
			</cfif>
		</td>
	</tr>
  </cfif>

  
   <tr id="TR_Titulo" style="display: none;">
  	<td colspan="1" >&nbsp;</td>
	<td colspan="2">
		<input name="RHEEMostrarTitulo"
			   type="checkbox" 
			   <cfif isdefined("rsForm.RHEEMostrarTitulo") and rsForm.RHEEMostrarTitulo EQ 'S'>checked</cfif>
		 >
		<cf_translate key="LB_Quitar_titulos_de_cuestionarios">Quitar titulos de cuestionarios</cf_translate>	
	  </td>
  </tr>
  <tr>
  	<td colspan="4">&nbsp;</td>
  </tr>
  <tr>
    <td colspan="4" align="center">
		<input type="hidden" name="SEL" value="">
		<input type="hidden" name="params" value="">
		<cfif modo neq 'AlTA' and isdefined("rsForm.RHEEid") and len(trim(rsForm.RHEEid)) gt 0>
			<cfoutput>
				<input type="hidden" name="RHEEid" value="#rsForm.RHEEid#">
				<input type="hidden" name="RHEEestado" value="#rsForm.RHEEestado#">
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
<cfinvoke key="MSG_ElValorPara" default="El valor para " returnvariable="MSG_ElValorPara"component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_DebeContenerSolamenteCaracteresAlfanumericosYLosSiguientesSimbolos" default="debe contener solamente caracteres alfanuméricos,\n y los siguientes símbolos" returnvariable="MSG_DebeContenerSolamenteCaracteresAlfanumericosYLosSiguientesSimbolos" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_FechaDesde" default="Fecha desde" returnvariable="LB_FechaDesde" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke key="LB_FechaHasta" default="Fecha hasta" returnvariable="LB_FechaHasta" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke key="LB_Descripcion" default="Descripci&oacute;n" xmlfile="/rh/generales.xml" returnvariable="LB_Descripcion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Cuestionario" default="Cuestionario" returnvariable="LB_Cuestionario" component="sif.Componentes.Translate" method="Translate"/>
	
	
<script language="javascript1.2" type="text/javascript">
	function muestracampos(){

			
		var tr = document.getElementById("TR_Titulo");
		if (document.form1.PCid.value == '0' || document.form1.PCid.value == '-1' || document.form1.PCid.value == '-2'){
			tr.style.display = "";
		}
		else{
		   tr.style.display = "none";
		}
	}
	muestracampos();
	
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
	//objForm.RHPcodigo.description = "Puesto";
	<cfoutput>
	objForm.RHEEfdesde.description = "#LB_FechaDesde#";
	objForm.RHEEfhasta.description = "#LB_FechaHasta#";
	objForm.RHEEdescripcion.description = "#LB_Descripcion#";
	objForm.PCid.description = "#LB_Cuestionario#";
	objForm.RHEEdescripcion.validateAlfaNumerico();
	//objForm.RHEEtipoeval.description = "Tipo de Evaluación";
	//objForm.TEcodigo.description = "Tabla de Evaluación";
	//objForm.RHPcodigo.required = true;
	objForm.RHEEfdesde.required = true;
	objForm.RHEEfhasta.required = true;
	objForm.RHEEdescripcion.required = true;
	objForm.PCid.required = true;
	
	//objForm.TEcodigo.required = (objForm.RHEEtipoeval.getValue()=='T');
	</cfoutput>
	function habilitarValidacion(){
		//objForm.RHPcodigo.required = true;
		objForm.RHEEfdesde.required = true;
		objForm.RHEEdescripcion.required = true;
		objForm.PCid.required = true;
		//objForm.TEcodigo.required = (objForm.RHEEtipoeval.getValue()=='T');
	}
	function deshabilitarValidacion(){
		//objForm.RHPcodigo.required = false;
		objForm.RHEEfdesde.required = false;
		objForm.RHEEdescripcion.required = false;
		objForm.PCid.required = false;
		//objForm.TEcodigo.required = false;
	}
	/*function requerirTEcodigo(v){
		if (objForm) objForm.TEcodigo.required = v;
	}*/
	objForm.RHEEdescripcion.obj.focus();
	function funcCambio(){
		document.form1.PCid.disabled=false;
	}
	
</script>


