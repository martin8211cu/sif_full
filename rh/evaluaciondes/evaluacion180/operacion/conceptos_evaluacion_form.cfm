
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Concepto"
	Default="Concepto"
	returnvariable="LB_Concepto"/>

<cfset modo='ALTA'>
<cfif isdefined("form.IREid") and len(trim(form.IREid)) and form.IREid gt 0>
	<cfset modo='CAMBIO'>
</cfif>
<!--- Consultas en cualquier modo --->
<cfquery name="rsTablas" datasource="#session.dsn#">
	select TEcodigo, TEnombre
	from TablaEvaluacion
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<!--- Consultas en modo Cambio --->
<cfif modo neq 'ALTA'>
	<cfquery name="rsForm" datasource="#session.dsn#">
		Select IREid, 
			Ecodigo, 
			REid, 
			IAEid, 
			TEcodigo, 
			IREsobrecien, 
			IREpesop, 
			IREpesojefe,
			IREevaluajefe, 
			IREevaluasubjefe, 
			BMfechaalta, 
			BMUsucodigo, 
			ts_rversion
		from RHIndicadoresRegistroE 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and IREid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IREid#">
	</cfquery>
	<!--- <cfdump var="#form#">
	<cf_dump var="#rsForm#"> --->
					

</cfif>
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_PrecaucionEstaRelacionYaContieneResultadosDeseaEliminarla"
	Default="'Precaución!, esta Relación ya contiene Resultados. ¿Desea Eliminarla?'"
	returnvariable="MSG_PrecaucionEstaRelacionYaContieneResultadosDeseaEliminarla"/>
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
	
	function funcLimpiar(){
		document.form1.reset();
	}
	function funcBaja(){
		return confirm(
					<cfif isdefined("rsResultados") and rsResultados.Cont gt 0>
						<cfoutput>#MSG_PrecaucionEstaRelacionYaContieneResultadosDeseaEliminarla#</cfoutput>
					<cfelse>
						'<cfoutput>#MSG_DeseaEliminarLaRelacion#</cfoutput>'
					</cfif>
					);
	}
	function funcSiguiente(){
		document.form1.SEL.value = "3";
		document.form1.action = "registro_evaluacion.cfm";
		return true;
	}
	function funcAlta(){ 
		document.form1.SEL.value = "?SEL=2";
		return true;
	}
</script>
<cfoutput>
<link href="STYLE.CSS" rel="stylesheet" type="text/css">
<form action="conceptos_evaluacion_sql.cfm"  onSubmit="javascript: return activacampos();" method="post" name="form1">

	<table width="95%" align="center"  border="0" cellspacing="2" cellpadding="0">
		<tr>
			<td rowspan="10">&nbsp;</td>
			<td colspan="3">&nbsp;</td>
			<td rowspan="7">&nbsp;</td>
		</tr>
		<tr>
			<td width="15%" valign="middle" nowrap align="right"><strong>#LB_Concepto#:</strong>&nbsp;</td>
			<td colspan="2" valign="middle" width="50%">
				<cfset vConcepto = arraynew(1) >

				<cfif modo NEQ 'ALTA'>
					<cfquery name="rsConcepto" datasource="#session.DSN#">
						Select a.IAEid, 
							a.IAEcodigo, 
							a.IAEdescripcion,a.IAEtipoconc
						from RHIndicadoresAEvaluar a 
						where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and IAEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.IAEid#">
							
					</cfquery>
					<cfif isdefined('rsConcepto') and rsConcepto.recordCount GT 0>
						<cfset vConcepto[1] = rsConcepto.IAEid >
						<cfset vConcepto[2] = rsConcepto.IAEcodigo>
						<cfset vConcepto[3] = rsConcepto.IAEdescripcion >						
					</cfif>
				</cfif>	
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_ListaDeConceptos"
					Default="Lista de Conceptos"
					returnvariable="LB_ListaDeConceptos"/>				
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_Codigo"
					Default="C&oacute;digo"
					XmlFile="/rh/generales.xml"
					returnvariable="LB_Codigo"/>				
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_Descripcion"
					Default="Descripci&oacute;n"
					XmlFile="/rh/generales.xml"
					returnvariable="LB_Descripcion"/>				
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="MSG_NoSeEncontraronUsuarios"
					Default="No se encontraron usuarios"
					returnvariable="MSG_NoSeEncontraronUsuarios"/>					
				<cfif modo eq 'ALTA'>
					<cf_conlis
						campos="IAEid,IAEcodigo,IAEdescripcion"
						desplegables="N,S,S"
						modificables="N,S,N"
						size="0,10,50"
						title="#LB_ListaDeConceptos#"
						
						tabla="RHIndicadoresAEvaluar a ,RHRegistroEvaluacion b"
						columnas="IAEid, 
								IAEcodigo, 
								a.IAEdescripcion,a.IAEevaluajefe as IREevaluajefe,a.IAEevaluasubjefe as IREevaluasubjefe,case a.IAEtipoconc when 'T' then a.IAEpesop else 0 end as IREpesop,case a.IAEtipoconc when 'T' then a.IAEpesop else 0 end as IREpesojefe,a.IAEtipoconc,case a.IAEtipoconc when 'T' then b.TEcodigo else 0 end as TEcodigo"
						filtro=" b.REid = #form.REid# and a.Ecodigo = #session.Ecodigo#
								order by a.IAEcodigo,a.IAEdescripcion"
	
						desplegar="IAEcodigo,IAEdescripcion"
						filtrar_por="IAEcodigo|IAEdescripcion"
						filtrar_por_delimiters="|"
						etiquetas="#LB_Codigo#,#LB_Descripcion#"
						formatos="S,S"
						align="left,left"
						asignar="IAEid,IAEcodigo,IAEdescripcion,IREevaluajefe,IREevaluasubjefe,IREpesop,IREpesojefe,IAEtipoconc,TEcodigo"
						asignarformatos="I,S,S"
						showEmptyListMsg="true"
						EmptyListMsg="-- #MSG_NoSeEncontraronUsuarios# --"
						tabindex="1"
						funcion="sugerir()"
						valuesArray="#vConcepto#"
						alt="ID,#LB_Codigo#,#LB_Descripcion#">
					<cfelse>
						#vConcepto[2]# - #vConcepto[3]#
						<input type="hidden" name="IAEid" 			value="#vConcepto[1]#" />
						<input type="hidden" name="IAEcodigo" 		value="#vConcepto[2]#" />
						<input type="hidden" name="IAEdescripcion" 	value="#vConcepto[3]#" />												
					</cfif>
			</td>
		</tr>		
		<tr>
			<td colspan="1" align="right" nowrap><strong><cf_translate key="LB_PesoEmpleado">Peso Empleado</cf_translate>:</strong>&nbsp;</td>
			<td colspan="2">
				<cfset valor = 0 >
				<cfif modo neq 'ALTA'>
					<cfset valor = rsForm.IREpesop >
				</cfif>
				<cf_monto name="IREpesop" size="3" decimales="0" value="#valor#" tabindex="1">
			</td>
		</tr>		
<tr>
			<td colspan="1" align="right" nowrap><strong><cf_translate key="LB_PesoJefe">Peso Jefe</cf_translate>:</strong>&nbsp;</td>
			<td colspan="2">
				<cfset valor = 0 >
				<cfif modo neq 'ALTA'>
					<cfset valor = rsForm.IREpesojefe >
				</cfif>
				<cf_monto name="IREpesojefe" size="3" decimales="0" value="#valor#" tabindex="1">
			</td>
		</tr>				
		<tr>
			<td colspan="1" nowrap align="right"><strong><cf_translate key=""CHK_AplicaSobreEl100>Aplica sobre el 100%</cf_translate>:</strong>&nbsp;</td>
			<td colspan="2"><input type="checkbox" name="IREsobrecien" tabindex="1" <cfif modo NEQ 'ALTA' and rsForm.IREsobrecien EQ 1> checked</cfif> id="IREsobrecien" value="1">
			</td>
		</tr>
		<tr>
			<td colspan="1" nowrap align="right"><strong><cf_translate key="LB_TablaDeEvaluacion">Tabla de Evaluaci&oacute;n</cf_translate>:</strong>&nbsp;</td>
			<td colspan="2">
				<select name="TEcodigo" tabindex="1">
					<option value="">-<cf_translate key="LB_Seleccionar">seleccionar</cf_translate>-</option>
					<cfloop query="rsTablas">
						<option value="#rsTablas.TEcodigo#" <cfif modo neq 'ALTA' and rsForm.TEcodigo eq rsTablas.TEcodigo>selected</cfif>>#rsTablas.TEnombre#</option>
					</cfloop>
				</select>
			</td>
		</tr>
		<tr>
			<td colspan="1" nowrap align="right"><strong><cf_translate key="CHK_AplicaSoloPorJefe">Aplica solo por Jefe</cf_translate>:&nbsp; </strong></td>
		  <td colspan="2">
			  <input type="checkbox" name="IREevaluajefe" tabindex="1" id="IREevaluajefe" <cfif modo NEQ 'ALTA' and rsForm.IREevaluajefe EQ 1> checked</cfif> value="checkbox">
			</td>
		</tr>
		<tr>
			<td colspan="1" nowrap align="right"><strong><cf_translate key="CHK_AplicaASubalternoJefe">Aplica a Subalterno/Jefe</cf_translate>:&nbsp;</strong></td>
			<td colspan="2"><input type="checkbox" name="IREevaluasubjefe" tabindex="1" id="IREevaluasubjefe" <cfif modo NEQ 'ALTA' and rsForm.IREevaluasubjefe EQ 1> checked</cfif> value="checkbox">
			</td>
		</tr>
		<tr><td colspan="4">&nbsp;</td></tr>
		<tr>
			<td colspan="4" align="center">
				<input type="hidden" name="SEL" value="">
				<input type="hidden" name="IAEtipoconc" value="<cfif modo NEQ 'ALTA' and rsConcepto.recordCount GT 0>#rsConcepto.IAEtipoconc#</cfif>">
				<input type="hidden" name="REid" value="#form.REid#">	
				<input type="hidden" name="Estado" value="<cfif isdefined("form.Estado") and form.Estado EQ 1>#form.Estado#<cfelse>0</cfif>">			
				<cfif modo neq 'AlTA'>
					<input type="hidden" name="IREid" value="#rsForm.IREid#">						
					<cfif isdefined("rsForm.ts_rversion")>
						<cfset ts = "">
						<cfinvoke 	component="sif.Componentes.DButils"
									method="toTimeStamp"
									returnvariable="ts">
							<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
						</cfinvoke>
						<input type="hidden" name="ts_rversion" value="<cfoutput>#ts#</cfoutput>">
					</cfif>
					<cfif isdefined("form.Estado") and form.Estado EQ 1>
						<cfset vs_botones='Anterior,Siguiente'>
						<cfset vs_names='Anterior,Siguiente'>
					<cfelse>
						<cfset vs_botones='Anterior,Eliminar,Modificar,Nuevo,Siguiente'>
						<cfset vs_names='Anterior,Baja,Cambio,Nuevo,Siguiente'>
					</cfif>
					<cf_botones values="#vs_botones#" names="#vs_names#" tabindex="1">
				<cfelse>
					<cfif isdefined("form.Estado") and form.Estado EQ 1>
						<cfset vs_botones='Anterior,Siguiente'>
						<cfset vs_names='Anterior,Siguiente'>
					<cfelse>
						<cfset vs_botones='Anterior,Limpiar, Agregar,Siguiente'>
						<cfset vs_names='Anterior,Limpiar,Alta,Siguiente'>
					</cfif>
					<cf_botones values="#vs_botones#" names="#vs_names#" tabindex="1">					
				</cfif>
			</td>
		</tr>
	</table>
</form>
</cfoutput>
<!---VARIABLES DE TRADUCCION --->


<script language="javascript1.2" type="text/javascript">
	qFormAPI.errorColor = "#FFFFCC";
	
	var objForm = new qForm("form1");
	
	function funcAnterior(){
		deshabilitarValidacion();
	}
	function funcSiguiente(){
		deshabilitarValidacion();
	}	
	
	objForm.IAEcodigo.description = "<cfoutput>#LB_Concepto#</cfoutput>";
	objForm.IAEcodigo.required = true;
	
	objForm.TEcodigo.description = "Tabla de Evaluación";
	objForm.TEcodigo.required = true;


	function habilitarValidacion(){
		objForm.IAEcodigo.required = true;
		objForm.TEcodigo.required = true;
	}
	function deshabilitarValidacion(){
		objForm.IAEcodigo.required = false;
		objForm.TEcodigo.required = false;
	}
	function sugerir(){
		if(document.form1.IREevaluajefe.value == 1){
			document.form1.IREevaluajefe.checked = true;
		}
		else{
			document.form1.IREevaluajefe.checked = false;
		}
		
		if(document.form1.IREevaluasubjefe.value == 1){
			document.form1.IREevaluasubjefe.checked = true;
		}
		else{
			document.form1.IREevaluasubjefe.checked = false;
		}
		
		
		if(document.form1.IAEtipoconc.value == 'T'){
			document.form1.IREpesop.disabled = false;
			document.form1.IREpesojefe.disabled = false;
			document.form1.TEcodigo.disabled = false;
			document.form1.IREsobrecien.disabled = false;		
		}
		else{
			document.form1.IREpesop.disabled = true;
			document.form1.IREpesojefe.disabled = true;
			document.form1.TEcodigo.disabled = true;
			document.form1.IREsobrecien.disabled = true;
			objForm.TEcodigo.required = false;
		}
		
		
	}
	function activacampos(){
		document.form1.IREpesop.disabled = false;
		document.form1.TEcodigo.disabled = false;
		document.form1.IREpesojefe.disabled = false;
		document.form1.IREsobrecien.disabled = false;
		return true;
	}
	<cfif modo neq 'AlTA'>
		sugerir();
	</cfif>
	
	funcLimpiar()
	<cfif modo eq 'AlTA'>
	document.form1.IAEcodigo.focus();
	</cfif>
</script>