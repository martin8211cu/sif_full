<cfparam name="FORM.RHEEID" type="numeric">
<link href="STYLE.CSS" rel="stylesheet" type="text/css">

<table width="95%" align="center"  border="0" cellspacing="0" cellpadding="0">
  <tr>
	<td rowspan="7">&nbsp;</td>
  	<td colspan="4">&nbsp;</td>
	<td rowspan="7">&nbsp;</td>
  </tr>
   <tr>
  	<td colspan="4">
		<cfinclude template="frame-Empleados.cfm">
	</td>
  </tr>
  <tr>
  	<td colspan="4" align="center">
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
			var form = document.listaEmpleados;
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
			if (!result) alert('¡Debe seleccionar al menos un registro para relizar esta acción!');
			return result;
		}
		
		function funcEliminar(){
			var form = document.listaEmpleados;
			var msg = "¿Desea eliminar de la evaluación, los empleados marcados?";
			result = (hayMarcados()&&confirm(msg));
			if (result) {
				form.action = "registro_criterios_empleados_lista_sql.cfm";
				form.RHEEID.value = <cfoutput>#FORM.RHEEID#</cfoutput>;
				form.BTNELIMINAR.value = 1;
				form.submit();				
			}
			return false;
		}
		
		function funcGenerar(vDEid){
			var form = document.listaEmpleados;
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
			var form = document.listaEmpleados;
			var msg = "¿Desea generar nuevamente los evaluadores e items a evaluar para los empleados marcados?";
			result = (hayMarcados()&&confirm(msg));
			if (result) {
				form.action = "registro_criterios_empleados_lista_sql.cfm";
				form.RHEEID.value = <cfoutput>#FORM.RHEEID#</cfoutput>;
				form.BTNGENERAREMPLS.value = 1;
				form.DEID.value = 0;
				form.submit();
			}
			return false;
		}
	</script>
	<form action="registro_evaluacion.cfm" method="post" name="form0">
		
		<cfoutput>
			<input type="hidden" name="SEL" value="">
			<input type="hidden" name="RHEEid" value="#form.RHEEid#">
		</cfoutput>
		<!--- <cfset Botones.TabIndex = 4>
		<input type="submit" name="Regresar" value="<< Anterior" onclick="javascript: if (window.deshabilitarValidacion) deshabilitarValidacion(); if (window.anterior) return anterior();" <cfif isDefined("Botones.TabIndex")>tabindex="<cfoutput>#Botones.TabIndex#</cfoutput>"</cfif>>
		<input type="button" name="btnEliminar" value="&nbsp;&nbsp;&nbsp;&nbsp;Eliminar&nbsp;&nbsp;&nbsp;&nbsp;" onclick="javascript: if (window.deshabilitarValidacion) deshabilitarValidacion(); if (window.funcEliminar) return funcEliminar();" <cfif isDefined("Botones.TabIndex")>tabindex="<cfoutput>#Botones.TabIndex#</cfoutput>"</cfif>>
		<input type="submit" name="Siguiente" value="Siguiente >>" onClick="javascript: if (window.habilitarValidacion) habilitarValidacion(); if (window.siguiente) return siguiente();" <cfif isDefined("Botones.TabIndex")>tabindex="<cfoutput>#Botones.TabIndex#</cfoutput>"</cfif>> --->
		<cf_botones values="<< Anterior,Eliminar,Generar,Siguiente >>" names="Anterior,Eliminar,GenerarEmpls,Siguiente" nbspbefore="4" nbspafter="4" tabindex="2">
	</form>
	</td>
  </tr>
</table>
