<cfparam name="FORM.RHEEID" type="numeric">
<link href="STYLE.CSS" rel="stylesheet" type="text/css">

<table width="95%" align="center"  border="0" cellspacing="0" cellpadding="0">
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
		<td colspan="4" align="right"><input type="button" name="btnReporte" value="Reporte" onClick="javasccript: funcReporte(#form.RHEEid#,'#vsFiltro#')"></td>
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
			if (!result) alert('¡Debe seleccionar al menos un registro para relizar esta acción!');
			return result;
		}
		
		function funcEliminar(){
			var form = document.listaEvaluadores;
			var msg = "¿Desea eliminar de la evaluación, los evaluadores marcados?, solo se eliminarán para el empleado bajo el que se encuentre en la lista y no para los demás empleados que se encuentre evaluando.";
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
			popUpWindow("../consultas/RelacEvalEvaluadores.cfm?RHEEid="+paramRHEEid+"&"+paramFiltro,30,30,700,500);
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
		<input type="submit" name="Finalizar" value="&nbsp;&nbsp;&nbsp;&nbsp;Finalizar&nbsp;&nbsp;&nbsp;&nbsp;" onClick="javascript: if (window.habilitarValidacion) habilitarValidacion(); if (window.siguiente) return siguiente();" <cfif isDefined("Botones.TabIndex")>tabindex="<cfoutput>#Botones.TabIndex#</cfoutput>"</cfif>> --->
		<cf_botones values="<< Anterior,Eliminar,Finalizar" names="Anterior,Eliminar,Finalizar" nbspbefore="4" nbspafter="4" tabindex="2">
	</form>
	</td>
  </tr>
</table>
