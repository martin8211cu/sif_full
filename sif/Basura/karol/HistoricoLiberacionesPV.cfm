<script language="javascript" type="text/javascript">
	
	function hayMarcados(){
		var form = document.listaEvaluaciones;
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
	
	function funcAbrir(){
		var form = document.listaEvaluaciones;
		var msg = "¿Desea marcar como listas para ser evaluadas las evaluaciones marcadas?";
		result = (hayMarcados()&&confirm(msg));
		if (result) form.action = "registro_evaluacion_lista_sql.cfm";
		return result;
	}
	
	function funcCerrar(){
		var form = document.listaEvaluaciones;
		var msg = "¿Desea finalizar las relaciones marcadas?";
		result = (hayMarcados()&&confirm(msg));
		if (result) form.action = "registro_evaluacion_lista_sql.cfm";
		return result;
	}

</script>
<cfoutput><form name="listaEvaluaciones" action="#GetFileFromPath(GetTemplatePath())#" method="post"></cfoutput>
<table width="85%" align="center" border="0" cellspacing="0" cellpadding="0">
	<tr>
    	<td>
			<cfquery name="rsFALiberaCre" datasource="#session.dns#">
				select 	FAM01COD as caja , FAX01NTR as Transaccion, FAX01NTE as TransaccionExterna,
						Mcodigo as moneda, MontoMax as montoAutorizado, FechaFactura as fechaFactura, 
						MontoUtilizado as montoUtilizado
				from 	FALiberaCredito
				where	MotivoAnula=null
			</cfquery>
			<cfinvoke 
				 component="sif.Componentes.pListas"
				 method="pListaQuery"
				 returnvariable="pListaPVRet">
					<cfinvokeargument name="desplegar" value="rsFALiberaCre.caja,rsFALiberaCre.Transaccion,
											rsFALiberaCre.TransaccionExterna, rsFALiberaCre.moneda,rsFALiberaCre.montoAtorizado,
											rsFALiberaCre.fechaFactura, rsFALiberaCre.montoUtilizado "/><!--- RHPdescpuesto,  --->
					<cfinvokeargument name="etiquetas" value="Caja,No Transacción,No Trans Externa,Moneda, Monto Autorizado,Fecha Factura,Monto Utilizado"/><!--- Puesto,  --->
					<cfinvokeargument name="formatos" value="S, I, S, N, M, D,M"/>
					<cfinvokeargument name="align" value="left,center,center,center,center,center,center"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<!--- <cfinvokeargument name="irA" value="registro_evaluacion.cfm"/> 
					<cfinvokeargument name="checkboxes" value="S">
					<cfinvokeargument name="keys" value="RHEEid">
					<cfinvokeargument name="formName" value="listaEvaluaciones">--->
					<cfinvokeargument name="incluyeform" value="false">
					<cfinvokeargument name="showEmptyListMsg" value="true">
					<cfinvokeargument name="EmptyListMsg" value="*** NO SE HA REGISTRADO NINGUNA TRANSACCION ***">
					<cfinvokeargument name="navegacion" value="#navegacion#">
		  </cfinvoke>
		</td>
	</tr>
	<tr>
	
		<td>
			<cf_botones names="Nuevo, Abrir, Cerrar" values="Nuevo, Habilitar, Cerrar Evaluaci&oacute;n" nbspbefore="4" nbspafter="4">
		</td>
	</tr>
</table>
</form>
