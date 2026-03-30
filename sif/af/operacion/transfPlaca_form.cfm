<cfif isdefined("form.AGTPid")>
    <cfset navegacion = navegacion & '&AGTPid=#form.AGTPid#'>
</cfif>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<cfinvoke 
				component="sif.Componentes.pListas"
				method="pListaRH"
				returnvariable="pListaRet"
					columnas="
						a.ADTPlinea, 
						a.AGTPid,  
						b.Aplaca as Placa,
						b.Adescripcion as Descripcion,
						a.AplacaAnt,
						a.AplacaNueva"
					tabla="ADTProceso a
						 inner join Activos b
							on b.Aid = a.Aid"
					filtro="  a.AGTPid = #form.AGTPid# and IDtrans = 10 and a.Ecodigo = #session.Ecodigo# "									
					desplegar="Placa,Descripcion,AplacaAnt,AplacaNueva"
					etiquetas="Placa,Descripci&oacute;n,Placa Anterior,Placa Nueva"
					formatos="S,S,S,S"
					align="left,left,left,left"
					showlink="false"
					incluyeForm="true"
					formName="fagtproceso"
					ajustar="N,N,N,N"
					keys="ADTPlinea"
					checkboxes="S"
					botones="Cambiar,CambiarTodo,Eliminar,EliminarTodo"
					MaxRows="15"
					filtrar_automatico="true"
					filtrar_por="b.Aplaca,b.Adescripcion,a.AplacaAnt,a.AplacaNueva"
					mostrar_filtro="true"
					irA="agtProceso_sql_CAMPLACA.cfm"
                    navegacion = "#navegacion#" />
		</td>
	</tr>
</table>

<script language="javascript1.2" type="text/javascript">
	function algunoMarcado(){
		var aplica = false;
		if (document.fagtproceso.chk) {
			if (document.fagtproceso.chk.value) {
				aplica = document.fagtproceso.chk.checked;
			} else {
				for (var i=0; i<document.fagtproceso.chk.length; i++) {
					if (document.fagtproceso.chk[i].checked) { 
						aplica = true;
						break;
					}
				}
			}
		}
		return aplica;
	}
	
	function funcCambiar() {
		if (!algunoMarcado()) {
			alert('Debe de seleccionar al menos un activo.');
			return false;			
		}	
		if (confirm('Desea realizar el cambio de placa a los activos seleccionadas?')){
		}else{
			return false;
		}
	}
	
	function funcCambiarTodo() {
		if (confirm('Desea realizar todos los cambios de placa de la lista?')){
		}else{
			return false;
		}
	}
	
	function funcEliminarTodo() {
		if (confirm('Desea eliminar TODOS los cambios de placa de la lista?')){
		}else{
			return false;
		}
	}	
	
	
	function funcEliminar() {
		if (!algunoMarcado()) {
			alert('Debe de seleccionar al menos un activo.');
			return false;			
		}	
	}
</script>