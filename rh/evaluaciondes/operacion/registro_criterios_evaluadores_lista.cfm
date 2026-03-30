<cfparam name="FORM.RHEEID" type="numeric">
<link href="STYLE.CSS" rel="stylesheet" type="text/css">
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="MSG_DebeSeleccionarAlMenosUnRegistroParaRelizarEstaAccion" default="¡Debe seleccionar al menos un registro para relizar esta acción!" returnvariable="MSG_DebeSeleccionarAlMenosUnRegistroParaRelizarEstaAccion" component="sif.Componentes.Translate" method="Translate"/>			
<cfinvoke key="MSG_DeseaEliminarDeLaEvaluacionLosEvaluadoresMarcadosSoloSeEliminaranParaElEmpleadoBajoElQueSeEncuentreEnLaListaYNoParaLosDemasEmpleadosQueSeEncuentreEvaluando." default="¿Desea eliminar de la evaluación, los evaluadores marcados?, solo se eliminarán para el empleado bajo el que se encuentre en la lista y no para los demás empleados que se encuentre evaluando." returnvariable="MSG_DeseaEliminarDeLaEvaluacionLosEvaluadoresMarcadosSoloSeEliminaranParaElEmpleadoBajoElQueSeEncuentreEnLaListaYNoParaLosDemasEmpleadosQueSeEncuentreEvaluando" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="BTN_Reporte" default="Reporte" xmlfile="/rh/generales.xml" returnvariable="BTN_Reporte" component="sif.Componentes.Translate" method="Translate" />				
 
<table width="100%" align="center"  border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td rowspan="7">&nbsp;</td>
		<td colspan="4">&nbsp;</td>
		<td rowspan="7">&nbsp;</td>
	</tr> 
	<tr>
		<cfset vsFiltro = ''>
		<cfif isdefined("Form.FDEnombre") and Len(Trim(Form.FDEnombre)) NEQ 0>   		
			<cfset vsFiltro = vsFiltro & Iif(Len(Trim(vsFiltro)) NEQ 0, DE("&"), DE("")) & "FDEnombre=" & Form.FDEnombre>
		</cfif>
		<cfif isdefined("Form.FDEidentificacion") and Len(Trim(Form.FDEidentificacion)) NEQ 0>
			<cfset vsFiltro = vsFiltro & Iif(Len(Trim(vsFiltro)) NEQ 0, DE("&"), DE("")) & "FDEidentificacion=" & Form.FDEidentificacion>
		</cfif>	
		<cfif isdefined("Form.fRHPcodigo") and Len(Trim(Form.fRHPcodigo)) NEQ 0>
			<cfset vsFiltro = vsFiltro & Iif(Len(Trim(vsFiltro)) NEQ 0, DE("&"), DE("")) & "fRHPcodigo=" & Form.fRHPcodigo>
		</cfif>
		<cfoutput>
			<td colspan="4" align="right">
				<input type="button" class="btnNormal" name="btnReporte" value="#BTN_Reporte#" 
					onclick="javasccript: funcReporte(#form.RHEEid#,'#vsFiltro#')">
			</td>
		</cfoutput>
	</tr>
	<tr>
		<td colspan="4">
			<cfinclude template="frame-Evaluadores.cfm">
		</td>
	</tr>
	<tr>
		<td colspan="4" align="center">
			<script language="javascript" type="text/javascript">
				function funcAnterior(){
					document.form0.SEL.value = "4";
					return true;
				}
				function funcFinalizar(){
					document.form0.SEL.value = "0";
					document.form0.RHEEid.value = "";
					return true;
				}
				function hayMarcados(){
					var form = document.listaEvaluadores;
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
					if (!result) alert('<cfoutput>#MSG_DebeSeleccionarAlMenosUnRegistroParaRelizarEstaAccion#</cfoutput>');
					return result;
				}
				
				function funcEliminar(){
					var form = document.listaEvaluadores;
					var msg = "<cfoutput>#MSG_DeseaEliminarDeLaEvaluacionLosEvaluadoresMarcadosSoloSeEliminaranParaElEmpleadoBajoElQueSeEncuentreEnLaListaYNoParaLosDemasEmpleadosQueSeEncuentreEvaluando#</cfoutput>";
					result = (hayMarcados()&&confirm(msg));
					if (result) {
						form.action = "registro_criterios_evaluadores_lista_sql.cfm";
						form.RHEEID.value = <cfoutput>#FORM.RHEEID#</cfoutput>;
						form.BTNELIMINAR.value = 1;
						form.submit();
					}
					return false;
				}
				
				var popUpWin = 0;
				function popUpWindow(URLStr, left, top, width, height){
					if(popUpWin){
						if(!popUpWin.closed) popUpWin.close();
					}
					popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
				}
			
				//Conlis Ordenes de compra (Pantalla que se muestra al dar click sobre la lista)
				function funcReporte(paramRHEEid,paramFiltro) {	
					popUpWindow("/cfmx/rh/evaluaciondes/consultas/RelacEvalEvaluadores.cfm?RHEEid="+paramRHEEid+"&"+paramFiltro,30,30,700,500);
				}
		
		
			</script>
			<form action="registro_evaluacion.cfm" method="post" name="form0">
				<cfoutput>
					<input type="hidden" name="SEL" value="">
					<input type="hidden" name="RHEEid" value="#form.RHEEid#">
				</cfoutput>
				<cf_botones values="Anterior,Eliminar,Finalizar" names="Anterior,Eliminar,Finalizar" nbspbefore="4" nbspafter="4" tabindex="2">
			</form>
		</td>
  	</tr>
</table>
