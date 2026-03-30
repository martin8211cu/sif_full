<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DebeSeleccionarAlMenosUnRegistroParaRelizarEstaAccion"
	Default="Debe seleccionar al menos un registro para relizar esta acción"
	returnvariable="MSG_DebeSeleccionarAlMenosUnRegistroParaRelizarEstaAccion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DeseaEliminarDeLaEvaluacionLosEmpleadosMarcados"
	Default="Desea eliminar de la evaluación, los empleados marcados"
	returnvariable="MSG_DeseaEliminarDeLaEvaluacionLosEmpleadosMarcados"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_HayEvaluadoresQueFinalizaronLaEvaluacionDeseaContinuar"
	Default="Hay evaluadores que finalizaron la evaluación, Desea continuar?"
	returnvariable="MSG_HayEvaluadoresQueFinalizaronLaEvaluacionDeseaContinuar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ElEvaluadorSeleccionadoYaHaFinalizadoSuEvaluacion"
	Default="El evaluador seleccionado ya ha finalizado su evaluación"
	returnvariable="MSG_ElEvaluadorSeleccionadoYaHaFinalizadoSuEvaluacion"/>	
<!--- FIN VARIABLES DE TRADUCCION --->
﻿<cfparam name="form.RHRCid" type="numeric">
<link href="STYLE.CSS" rel="stylesheet" type="text/css">

<cfif isdefined('form.RHRCid') and form.RHRCid NEQ ''>
	<cfquery name="rsForm" datasource="#session.dsn#">
		select RHRCestado
		from RHRelacionCalificacion
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and RHRCid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#"> 
	</cfquery>
</cfif>

<table width="95%" align="center"  border="0" cellspacing="0" cellpadding="0">
	<tr><td colspan="4"><cfinclude template="frame-Evaluadores.cfm"></td></tr>
	<tr><td colspan="4">&nbsp;</td></tr>  
	<tr>
  		<td colspan="4" align="center">
			<form action="actCompetencias.cfm" method="post" name="form0">
				<input type="hidden" name="SEL" value="">
				<input type="hidden" name="RHRCid" value="<cfoutput>#form.RHRCid#</cfoutput>">
				
				<!--- Solo se pueden eliminar evaluadores si la relacion esta en Proceso --->		
				<!--- <cfif isdefined('rsForm') and rsForm.recordCount GT 0 and rsForm.RHRCestado EQ 0> --->
					<cf_botones values="Anterior,Eliminar,Siguiente" names="Anterior,Eliminar,Siguiente" nbspbefore="4" nbspafter="4" tabindex="2">
				<!--- <cfelse>
					<cf_botones values="Anterior,Siguiente" names="Anterior,Siguiente" nbspbefore="4" nbspafter="4" tabindex="2">
				</cfif> --->
			</form>
		</td>
	</tr>
</table>
	<script language="javascript" type="text/javascript">
		function funcAnterior(){
			document.form0.SEL.value = "2";
			return true;
		}
		function funcSiguiente(){
			document.form0.SEL.value = "4";
			return true;
		}
		function hayMarcados(){
			var form = document.lista;
			var result = false;
			if (form.chk!=null) {
				if (form.chk.length){
					for (var i=0; i<form.chk.length; i++){
						if (form.chk[i].checked)
							result = true;
					}
				}
				else{
					if (form.chk.checked)
						result = true;
				}
			}
			if (!result) alert('¡<cfoutput>#MSG_DebeSeleccionarAlMenosUnRegistroParaRelizarEstaAccion#</cfoutput>!');
			return result;
		}
		
		function funcEliminar(){
			var form = document.lista;
			var msg = "¿<cfoutput>#MSG_DeseaEliminarDeLaEvaluacionLosEmpleadosMarcados#</cfoutput>?";
			var msgEval = "<cfoutput>#MSG_HayEvaluadoresQueFinalizaronLaEvaluacionDeseaContinuar#</cfoutput>"
			if (form.Elimina.value == 1) result = (hayMarcados()&&confirm(msg)&&confirm(msgEval));
			else result = (hayMarcados()&&confirm(msg));
			if (result) {
				form.action = "actCompe_evaluadores_lista_sql.cfm";
				//form.RHRCID.value = <cfoutput>#FORM.RHRCid#</cfoutput>;
				form.BTNELIMINAR.value = 1;
				form.submit();				
			}
			return false;
		}
		
		function funcGenerar(vDEid){
			var form = document.listaEvaluadores;
			//no se consulta porque en el evento que ejecuta esta funcion se lanza también y sin control de esta funcion un submit del form
			//lista, por tanto no se puede controlar no realizar la acción.
			//* las lineas que se comentaron con un * no son necesarias porque estos campos toman la información de la función Procesar,
			//por tanto aunque aquí se les de un valor posteriormente este valor es planchado por el valor asignado por la funcion Procesar.
			//var msg = "¿Desea generar nuevamente los evaluadores e items a evlauar para este empleado?";
			//result = (confirm(msg));
			//if (result){
				//form.BTNGENERAREMPL.value = 1;
				form.action = "registro_criterios_empleados_lista_sql.cfm";
				//*form.DEID.value = vDEid;
				//el submit se ejecuta sin control de esta función
				//form.submit();
			//}
			//return false;
		}
		
		function funcGenerarEmpls(){
			var form = document.lista;
			var msg = "¿Desea generar nuevamente los evaluadores e items a evaluar para los empleados marcados?";
			result = (hayMarcados()&&confirm(msg));
			if (result) {
				form.action = "registro_criterios_empleados_lista_sql.cfm";
				//form.RHRCid.value = <cfoutput>#FORM.RHRCid#</cfoutput>;
				form.BTNGENERAREMPLS.value = 1;
				form.DEID.value = 0;
				form.submit();
			}
			return false;
		}
		
		function funcSel(){
			document.lista.SEL.value = "4";
			document.lista.submit();
			return true;
		}
		
		function funcValida(chk){
			var empleado = chk.value.split("|");
			if (empleado[1] == 10 && chk.checked) {
				alert('<cfoutput>#MSG_ElEvaluadorSeleccionadoYaHaFinalizadoSuEvaluacion#</cfoutput>');
				document.lista.Elimina.value = 1;
			}
			return true;
		}
	</script>