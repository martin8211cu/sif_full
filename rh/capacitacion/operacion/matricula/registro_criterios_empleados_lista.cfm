﻿<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_RecursosHumanos"
	default="Recursos Humanos"
	xmlfile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="MSG_DebeSeleccionarAlMenosUnRegistroParaRelizarEstaAccion"
	default="Debe seleccionar al menos un registro para relizar esta acción"
	returnvariable="MSG_DebeSeleccionarAlMenosUnRegistroParaRelizarEstaAccion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="MSG_DeseaEliminarDeLaEvaluacionLosEmpleadosMarcados"
	default="Desea eliminar de la evaluación, los empleados marcados"
	returnvariable="MSG_DeseaEliminarDeLaEvaluacionLosEmpleadosMarcados"/>
<!--- FIN VARIABLES DE TRADUCCION --->

﻿<cfparam name="FORM.RHRCid" type="numeric">
<link href="STYLE.CSS" rel="stylesheet" type="text/css">
<form action="index.cfm" method="post" name="form0">
	<cfoutput>
		<input type="hidden" name="SEL" value="3">
		<input type="hidden" name="RHRCid" value="#form.RHRCid#">
	</cfoutput>
	<table width="95%" align="center"  border="0" cellspacing="0" cellpadding="0">
		<tr><td colspan="4"><cfinclude template="frame-Empleados.cfm"></td></tr>
		<tr>
			<td colspan="4" align="center">
				<cfif isdefined('Lvar_Solicitud')>				
				<cfset Lvar_Botones = 'Anterior,Eliminar'>
				<cfelse>
					<cfset Lvar_Botones = 'Anterior,Eliminar,Siguiente'>
				</cfif>
				<cf_botones values="#Lvar_Botones#" names="#Lvar_Botones#" nbspbefore="4" nbspafter="4" tabindex="2">
			</td>
		</tr>
	</table>
</form>
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
		var form = document.form0;
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
		var form = document.form0;
		var msg = "¿<cfoutput>#MSG_DeseaEliminarDeLaEvaluacionLosEmpleadosMarcados#</cfoutput>?";
		result = (hayMarcados()&&confirm(msg));
		if (result) {
			form.action = "registro_criterios_empleados_lista_sql.cfm";
			form.BTNELIMINAR.value = 1;
			form.submit();
		}
		return false;
	}
</script>