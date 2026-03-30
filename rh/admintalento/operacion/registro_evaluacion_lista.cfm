<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DebeSeleccionarAlMenosUnRegistroParaRelizarEstaAccion"
	Default="¡Debe seleccionar al menos un registro para relizar esta acción!"
	returnvariable="MSG_DebeSeleccionarAlMenosUnRegistroParaRelizarEstaAccion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DeseaEliminarLaRselacionesDeSeguimientoMarcadas"
	Default="¿Desea eliminar las relaciones de seguimiento marcadas?"
	returnvariable="MSG_DeseaEliminarLaRselacionesDeSeguimientoMarcadas"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DeseaFinalizarLasRelacionesMarcadas"
	Default="¿Desea finalizar las relaciones marcadas?"
	returnvariable="MSG_DeseaFinalizarLasRelacionesMarcadas"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DeseaPublicarLasRelacionesMarcadas"
	Default="¿Desea publicar las relaciones marcadas?"
	returnvariable="MSG_DeseaPublicarLasRelacionesMarcadas"/>

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
		
	function funcCerrar(){
		var form = document.listaEvaluaciones;
		var msg = "<cfoutput>#MSG_DeseaFinalizarLasRelacionesMarcadas#</cfoutput>";
		result = (hayMarcados()&&confirm(msg));
		if (result) form.action = "registro_evaluacion_lista_sql.cfm";
		return result;
	}
	
	function funcPublicar(){
		var form = document.listaEvaluaciones;
		var msg = "<cfoutput>#MSG_DeseaPublicarLasRelacionesMarcadas#</cfoutput>";
		result = (hayMarcados()&&confirm(msg));
		if (result) form.action = "registro_evaluacion_lista_sql.cfm";
		return result;	
	}

	function funcEliminar(){
		var form = document.listaEvaluaciones;
		var msg = "<cfoutput>#MSG_DeseaEliminarLaRselacionesDeSeguimientoMarcadas#</cfoutput>";
		result = (hayMarcados()&&confirm(msg));
		if (result) form.action = "registro_evaluacion_lista_sql.cfm";
		return result;	
	}

</script>

<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Descripcion"
	Default="Descripción"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_Descripcion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Estado"
	Default="Estado"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_Estado"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Empleado"
	Default="Empleado"
	returnvariable="LB_Empleado"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_NOSEHAREGISTRADONINGUNAEVALUACION"
	Default="NO SE HA REGISTRADO NINGUNA EVALUACION"
	returnvariable="MSG_NOSEHAREGISTRADONINGUNAEVALUACION"/>

<cfinvoke component="sif.Componentes.Translate"	method="Translate"	Key="LB_EnProceso"	Default="En proceso" returnvariable="LB_EnProceso"/>
<cfinvoke component="sif.Componentes.Translate"	method="Translate"	Key="LB_Publicada"	Default="Publicada" returnvariable="LB_Publicada"/>
<cfinvoke component="sif.Componentes.Translate"	method="Translate"	Key="LB_Cerrada"	Default="Cerrada" returnvariable="LB_Cerrada"/>
<cfinvoke component="sif.Componentes.Translate"	method="Translate"	Key="LB_Competencias"	Default="Competencias" returnvariable="LB_Competencias"/>
<cfinvoke component="sif.Componentes.Translate"	method="Translate"	Key="LB_Objetivo"	Default="Objetivo" returnvariable="LB_Objetivo"/>
<cfinvoke component="sif.Componentes.Translate"	method="Translate"	Key="LB_Tipo"	Default="Tipo" returnvariable="LB_Tipo"/>

<cfoutput><form name="listaEvaluaciones" action="#GetFileFromPath(GetTemplatePath())#" method="post"></cfoutput>
<table width="85%" align="center" border="0" cellspacing="0" cellpadding="0">
	<tr>
    	<td>
			<cf_dbfunction name="concat" args="c.DEidentificacion,' - ',c.DEapellido1 ,' ',c.DEapellido2,' ',c.DEnombre" returnvariable="empleado">
			<cfinvoke 
				 component="rh.Componentes.pListas"
				 method="pListaRH"
				 returnvariable="pListaRHRet">
					<cfinvokeargument name="tabla" value="RHRelacionSeguimiento a, RHEvaluados b, DatosEmpleado c"/>
					<cfinvokeargument name="columnas" value="a.RHRSid, RHRSdescripcion, (select count(1) from RHEvaluados c where RHRSid = a.RHRSid) as cant_empleados, 
														case RHRSestado when 10 then '#LB_EnProceso#' when 20 then '#LB_Publicada#' when 30 then '#LB_Cerrada#' end as RHRSestado
														,case RHRStipo when 'C' then '#LB_Competencias#'
														else '#LB_Objetivo#'
														end as DescTipo
														,#empleado# as Empleado"/>
					<cfinvokeargument name="desplegar" value="RHRSdescripcion, DescTipo, RHRSestado, Empleado "/>
					<cfinvokeargument name="etiquetas" value="#LB_Descripcion#, #LB_Tipo#, #LB_Estado#, #LB_Empleado#"/>
					<cfinvokeargument name="formatos" value="S, S, S, I"/>
					<cfinvokeargument name="filtro" value="a.Ecodigo = #session.Ecodigo# 
															and a.RHRSestado in (10,20) 
															and a.RHRSid = b.RHRSid
															and b.DEid = c.DEid
															#filtro#
															order by RHRStipo"/>
					<cfinvokeargument name="align" value="left, left, center, left"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="irA" value="registro_evaluacion.cfm"/>
					<cfinvokeargument name="checkboxes" value="S">
					<cfinvokeargument name="keys" value="RHRSid">
					<cfinvokeargument name="formName" value="listaEvaluaciones">
					<cfinvokeargument name="incluyeform" value="false">
					<cfinvokeargument name="showEmptyListMsg" value="true">
					<cfinvokeargument name="EmptyListMsg" value="---- #MSG_NOSEHAREGISTRADONINGUNAEVALUACION# ----">
					<cfinvokeargument name="navegacion" value="#navegacion#">
					<cfinvokeargument name="Cortes" value="DescTipo">					
		  </cfinvoke>
		</td>
	</tr>
	<tr>
		<td>
			<cf_botones names="Nuevo,Publicar,Eliminar,Cerrar" values="Nuevo,Publicar,Eliminar,Cerrar Publicación" nbspbefore="4" nbspafter="4">
		</td>
	</tr>
</table>
</form>
