<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_Descripcion" default="Descripción" xmlfile="/rh/generales.xml" returnvariable="LB_Descripcion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Estado" default="Estado" xmlfile="/rh/generales.xml" returnvariable="LB_Estado" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_CantidadDeEmpleados" default="Cantidad de Empleados"returnvariable="LB_CantidadDeEmpleados" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_NOSEHAREGISTRADONINGUNAEVALUACION" default="NO SE HA REGISTRADO NINGUNA EVALUACION"returnvariable="MSG_NOSEHAREGISTRADONINGUNAEVALUACION" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_DebeSeleccionarAlMenosUnRegistroParaRelizarEstaAccion" default="¡Debe seleccionar al menos un registro para relizar esta acción!" returnvariable="MSG_DebeSeleccionarAlMenosUnRegistroParaRelizarEstaAccion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_DeseaMarcarComoListasParaSerEvaluadasLasEvaluacionesMarcadas" default="¿Desea marcar como listas para ser evaluadas las evaluaciones marcadas?" returnvariable="MSG_DeseaMarcarComoListasParaSerEvaluadasLasEvaluacionesMarcadas" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_DeseaFinalizarLasRelacionesMarcadas" default="¿Desea finalizar las relaciones marcadas?" returnvariable="MSG_DeseaFinalizarLasRelacionesMarcadas" component="sif.Componentes.Translate" method="Translate"/>

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
		if (!result) alert('<cfoutput>#MSG_DebeSeleccionarAlMenosUnRegistroParaRelizarEstaAccion#</cfoutput>');
		return result;
	}
	
	function funcAbrir(){
		var form = document.listaEvaluaciones;
		var msg = "<cfoutput>#MSG_DeseaMarcarComoListasParaSerEvaluadasLasEvaluacionesMarcadas#</cfoutput>";
		result = (hayMarcados()&&confirm(msg));
		if (result) form.action = "registro_evaluacion_lista_sql.cfm";
		return result;
	}
	
	function funcCerrar(){
		var form = document.listaEvaluaciones;
		var msg = "<cfoutput>#MSG_DeseaFinalizarLasRelacionesMarcadas#</cfoutput>";
		result = (hayMarcados()&&confirm(msg));
		if (result) form.action = "registro_evaluacion_lista_sql.cfm";
		return result;
	}

</script>

<cfoutput><form name="listaEvaluaciones" action="#GetFileFromPath(GetTemplatePath())#" method="post"></cfoutput>
<table width="85%" align="center" border="0" cellspacing="0" cellpadding="0">
	<tr>
    	<td>
			<cfinvoke 
				 component="rh.Componentes.pListas"
				 method="pListaRH"
				 returnvariable="pListaRHRet">
					<cfinvokeargument name="tabla" value="RHEEvaluacionDes a"/><!--- , RHPuestos b --->
					<cfinvokeargument name="columnas" value="RHEEid, RHEEdescripcion, (select count(1) from RHListaEvalDes c where RHEEid = a.RHEEid) as cant_empleados, case RHEEestado when 0 then 'En Captura' when 1 then 'Asociando Empleados' when 2 then 'Lista para Evaluar' else 'Aplicada' end as RHEEestado"/><!--- RHPdescpuesto,  --->
					<cfinvokeargument name="desplegar" value="RHEEdescripcion, RHEEestado, cant_empleados "/><!--- RHPdescpuesto,  --->
					<cfinvokeargument name="etiquetas" value="#LB_Descripcion#, #LB_Estado#, #LB_CantidadDeEmpleados#"/><!--- Puesto,  --->
					<cfinvokeargument name="formatos" value="S, S, I"/><!--- S,  --->
					<cfinvokeargument name="filtro" value="a.Ecodigo = #session.Ecodigo# and a.RHEEestado in (0,1,2) #filtro#"/><!---  and a.Ecodigo = b.Ecodigo and a.RHPcodigo = b.RHPcodigo --->
					<cfinvokeargument name="align" value="left, center, right"/><!--- left,  --->
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="irA" value="registro_evaluacion.cfm"/>
					<cfinvokeargument name="checkboxes" value="S">
					<cfinvokeargument name="keys" value="RHEEid">
					<cfinvokeargument name="formName" value="listaEvaluaciones">
					<cfinvokeargument name="incluyeform" value="false">
					<!--- <cfinvokeargument name="cortes" value="RHPdescpuesto"> --->
					<cfinvokeargument name="showEmptyListMsg" value="true">
					<cfinvokeargument name="EmptyListMsg" value="*** #MSG_NOSEHAREGISTRADONINGUNAEVALUACION# ***">
					<cfinvokeargument name="navegacion" value="#navegacion#">
		  </cfinvoke>
		</td>
	</tr>
	<tr><td><cf_botones names="Nuevo, Abrir, Cerrar" values="Nuevo,Habilitar,Cerrar" nbspbefore="4" nbspafter="4"></td></tr>
</table>
</form>
<br>
<table width="85%" align="center" border="0" cellspacing="0" cellpadding="0" class="AreaFiltro">
	<tr valign="top">
    	<td nowrap><strong><cf_translate key="LB_Habilidad">Habilitar</cf_translate>:</strong>&nbsp;</td>
		<td>
			<div align="justify"> 
				<cf_translate key="AYUDA_HabilitaUnaEvaluacionEstoImplicaQueApartirDelPeriodoDeViegencia">
					Habilita una evaluaci&oacute;n, esto implica que a partir del periodo de vigencia, 
					la misma podr&aacute; ser evaluada hasta la fecha en que se permite evaluar, o hasta que sea cerrada.
				</cf_translate>
			</div>
		</td>
  </tr>
  <tr valign="top">
    <td nowrap><strong><cf_translate key="LB_CerrarEvaluacion">Cerrar Evaluaci&oacute;n</cf_translate>:</strong>&nbsp;</td>
	<td><div align="justify"> <cf_translate key="AYUDA_CierraElPeriodoDeEvaluacionDeUnaRelacion">Cierra el periodo de evaluaci&oacute;n de una relaci&oacute;n.</cf_translate></div></td>
  </tr>
</table>
<br>