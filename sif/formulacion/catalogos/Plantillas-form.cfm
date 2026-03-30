<cfif modo EQ 'cambio'>
	<cfquery name="plantilla" datasource="#Session.DSN#">
		select FPEPid,FPEPdescripcion,FPCCtipo,FPEPnotas,ePantilla.ts_rversion,FPCCconcepto,PCGDxCantidad,PCGDxPlanCompras,FPEPmultiperiodo,coalesce(cf.CFid,-1) CFid,CFcodigo,CFdescripcion,coalesce(FPAEid,-1) as FPAEid,CFComplemento,FPEPnomodifica,
			(select count(1) from FPDPlantilla dPlantilla where dPlantilla.FPEPid = ePantilla.FPEPid) as Categoria,
			(select count(1) from FPDEstimacion ed inner join FPEEstimacion ee on ee.FPEEid = ed.FPEEid where ed.FPEPid = ePantilla.FPEPid and ee.FPEEestado <> 7) tieneEstimaciones,
			(select count(1) from PCGDplanCompras pc where pc.Ecodigo = #session.ecodigo# and pc.FPEPid = ePantilla.FPEPid) CcontrolaXPlan
			from FPEPlantilla ePantilla
			left outer join CFuncional cf
				on cf.CFid = ePantilla.CFid
		where FPEPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FPEPid#">
	</cfquery>
	<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp="#plantilla.ts_rversion#" returnvariable="ts"></cfinvoke>
</cfif>
<cfoutput>
<form action="Plantillas-sql.cfm" method="post" name="form1" onsubmit="return habililarCampos();">
	<input type="hidden" name="FPEPid" 		value="#plantilla.FPEPid#" />
	<input type="hidden" name="ts_rversion" value="#ts#">
	<input type="hidden" name="tab" 		value="<cfoutput>#form.tab#</cfoutput>">
	
	<table border="0" cellspacing="1" cellpadding="1">
		<tr><td>Nombre de la Plantilla:</td>
			<td><input name="FPEPdescripcion" type="text" value="#plantilla.FPEPdescripcion#"  size="50" maxlength="100" tabindex="1"></td>
		</tr>
		<tr><td>Tipo:</td>
			<td>
				<select name="FPCCtipo" onchange="fnCambiarIndicadores(this);" <cfif plantilla.Categoria GT 0>disabled="disabled"</cfif>>
				  <option value="G" <cfif #plantilla.FPCCtipo# EQ 'G'> selected="selected"</cfif>>Egreso</option>
				  <option value="I" <cfif #plantilla.FPCCtipo# EQ 'I'> selected="selected"</cfif>>Ingreso</option>
				</select>
			</td>
		</tr>
		<tr><td>Indicador Auxiliar:</td>
			<td>
				<select name="FPCCconcepto"  <cfif plantilla.Categoria>disabled="disabled"</cfif> onchange="fnShowCF(this);"></select>
			</td>
		</tr>
		<tr>
			<td>Controla Cantidades:</td>
			<td><input type="checkbox" name="PCGDxCantidad" value="1" <cfif plantilla.PCGDxCantidad EQ 1> checked="checked"</cfif> <cfif plantilla.tieneEstimaciones gt 0>disabled</cfif>/></td>
		</tr>
		<tr>
			<td>Control Presupuesto:</td>
			<td><select name="PCGDxPlanCompras" <cfif plantilla.CcontrolaXPlan gt 0>disabled</cfif>>
				  <option value="1" <cfif plantilla.PCGDxPlanCompras EQ '1'> selected="selected"</cfif>>Control Por Plan Compras</option>
				  <option value="0" <cfif plantilla.PCGDxPlanCompras EQ '' or plantilla.PCGDxPlanCompras EQ '0'> selected="selected"</cfif>>Control Por Cuenta Presupuestal</option>
				</select></td>
		</tr>
		<tr>
			<td>Es Mutiperiódo:</td>
			<td><input type="checkbox" name="FPEPmultiperiodo" value="1" <cfif plantilla.FPEPmultiperiodo EQ 1> checked="checked"</cfif> <cfif plantilla.CcontrolaXPlan gt 0>disabled</cfif>/></td>
		</tr>
		<tr id="tr_CFcompra">
			<cfif plantilla.tieneEstimaciones or modo NEQ 'cambio'>
				<cfset readonly="true">
			<cfelse>
				<cfset readonly="false">
			</cfif>
			<td>Centro Funcional Que Compra:</td>
			<td><cf_conlis
				Campos="CFid,CFcodigo,CFdescripcion"
				Values="#plantilla.CFid#,#plantilla.CFcodigo#,#plantilla.CFdescripcion#"
				tabindex="1"
				Desplegables="N,S,S"
				Modificables="N,S,N"
				Size="0,15,35"
				Title="Lista de Centros Funcionales"
				Tabla="CFuncional cf"
				Columnas="CFid,CFcodigo,CFdescripcion"
				Filtro="Ecodigo = #Session.Ecodigo# and CFid in (select b.CFid from FPEPlantilla a inner join FPDCentrosF b on b.FPEPid = a.FPEPid where a.Ecodigo = #Session.Ecodigo# and FPCCconcepto = 'A' and b.FPEPid = #plantilla.FPEPid# group by b.CFid) order by CFcodigo,CFdescripcion"
				Desplegar="CFcodigo,CFdescripcion"
				Etiquetas="C&oacute;digo,Descripci&oacute;n"
				filtrar_por="CFcodigo,CFdescripcion"
				Formatos="S,S"
				Align="left,left"
				Asignar="CFid,CFcodigo,CFdescripcion"
				Asignarformatos="I,S,S"
				readonly="#readonly#"/>
			</td>
		</tr>
		<cfinvoke component="sif.Componentes.FPRES_ActividadEmpresarial" method="getParametroActividad" returnvariable="Activo"></cfinvoke>
		<cfif Activo>
		<tr>
			<td>Complemento Actividad Sugerido:</td>
			<td>
				<table border="0" align="center"><tr>
					<td>
						<cfif modo EQ 'cambio'>
							<cfif plantilla.tieneEstimaciones gt 0>
								<cfset readonly="true">
							<cfelse>
								<cfset readonly="false">
							</cfif>
							<cf_ActividadEmpresa etiqueta ="" MostrarTipo="#plantilla.FPCCtipo#" name="CFComplemento" idActividad="#plantilla.FPAEid#" valores="#plantilla.CFComplemento#">
						<cfelse>
							<cf_ActividadEmpresa etiqueta ="" MostrarTipo="#plantilla.FPCCtipo#" name="CFComplemento">
						</cfif>
					</td>
					<td>
						<input type="checkbox" name="FPEPnomodifica" value="1" onclick="fnValidar(this);" <cfif plantilla.FPEPnomodifica EQ 1> checked="checked"</cfif> <cfif plantilla.tieneEstimaciones gt 0>disabled="disabled"</cfif>/>No modificable al formular
					</td>
				</tr></table>
			</td>
		</tr>
		</cfif>
		<tr><td>Notas:</td>
			<td><textarea name="FPEPnotas" cols="50" rows="5" tabindex="1">#plantilla.FPEPnotas#</textarea></td>
		</tr>
		<tr><td colspan="2">
				<cf_botones modo='#MODO#'>
			</td>
		</tr>
	</table>
</form>
</cfoutput>
<cf_qforms>
	<cf_qformsRequiredField name="FPEPdescripcion" 	 description="Descripción">
	<cf_qformsRequiredField name="FPCCtipo"          description="Tipo">
</cf_qforms>
<cfif modo EQ 'cambio'>
	<cf_tabs width="100%">
		<cf_tab text="Asignación de Clasificaciones de Ingreso y Egresos" selected="#form.tab EQ 1#">
			<cfif form.tab EQ 1>
				<cfinclude template="Plantillas-concepto.cfm">
			</cfif>
		</cf_tab>
		<cf_tab text="Asignación de Centros Funcionales" selected="#form.tab EQ 2#">
			<cfif form.tab EQ 2>
				<cfinclude template="Plantillas-centrof.cfm">
			</cfif>
		</cf_tab>
	</cf_tabs>
	
	<script language="javascript1.2" type="text/javascript">
		<!-- Se sobrescribe la funcion para que no redirecciona a otra página -->
		objForm.CFComplementoId.description="Actividad Empresarial";
		<cfif plantilla.FPEPnomodifica EQ 1>
			objForm.CFComplementoId.required=true;
		<cfelse>
			objForm.CFComplementoId.required=false;
		</cfif>
		
		function filtrar_Plista(){
			return true;
		}
		
		function fnValidar(obj){
			if(obj.checked)
				objForm.CFComplementoId.required=true;
			else
				objForm.CFComplementoId.required=false;
		}
		
		<!-- Se carga el tab indicado, esto con el fin de no cargas todos los datos en la página -->
		function tab_set_current(n) {
			location.href = "Plantillas.cfm?FPEPid=<cfoutput>#plantilla.FPEPid#</cfoutput>&tab="+n;
		}
	</script>
</cfif>
<script language="javascript1.2" type="text/javascript">
	
	// Indicadores, se crea un array con los indicadores por si en un futuro se desean ingresar más.
	var indicadoresArray = new Array(
	new Array('F','Activo Fijo','G'), 
	new Array('S','Gastos o Servicio','G'),
	new Array('P','Obras en Proceso','G'),
	new Array('A','Artículos Inventario','G'),
	new Array('2','Concepto Salarial','G'),
	new Array('3','Amortización de Prestamos','G'),
	new Array('1','Otros','G'),
	new Array('4','Financiamiento','I'),
	new Array('5','Patrimonio','I'),
	new Array('6','Ventas','I'));	

	// Muestra los indicadores pertenecientes al tipo(Gasto ó Ingreso)
	function fnCambiarIndicadores(obj){
		combo = document.form1.FPCCconcepto;
		if(combo.hasChildNodes()){
			while(combo.childNodes.length >= 1 )
				combo.removeChild(combo.firstChild );       
		}
		for(var i = 0; i < indicadoresArray.length; i++){
			if (fnBuscarTipo(indicadoresArray[i],obj.value)){
				var option = document.createElement("option");
				option.value = indicadoresArray[i][0];
				option.innerHTML = indicadoresArray[i][1];
				option.selected = ("<cfoutput>#plantilla.FPCCconcepto#</cfoutput>" == indicadoresArray[i][0] ? true : false);
				combo.appendChild(option);
			}
		}
		fnShowCF(document.form1.FPCCconcepto);
		document.form1.CFComplemento_Tipo.value = obj.value;
	}
	
	// Busca en el array el tipo(Gasto ó Ingreso) del indicador
	function fnBuscarTipo(array, indicador){
		if(indicador == array[2])
			return true;
		return false;
	}
	
	function habililarCampos(){
		document.form1.FPCCtipo.disabled="";
		document.form1.FPCCconcepto.disabled="";
		document.form1.FPEPmultiperiodo.disabled="";
		document.form1.PCGDxPlanCompras.disabled="";
		document.form1.PCGDxCantidad.disabled="";
		document.form1.FPEPnomodifica.disabled="";
		return true;
	}
	
	function fnShowCF(obj){
		if(obj.value == 'A')
			document.getElementById("tr_CFcompra").style.display="";
		else
			document.getElementById("tr_CFcompra").style.display="none";
		
	}
	
	fnCambiarIndicadores(document.form1.FPCCtipo);
</script>