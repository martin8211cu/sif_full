﻿<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_EnCapturaDeAutogestion"
	Default="En Captura de Autogesti&oacute;n"
	returnvariable="LB_EnCapturaDeAutogestion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Solicitada"
	Default="Solicitada"
	returnvariable="LB_Solicitada"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Rechazada"
	Default="Rechazada"
	returnvariable="LB_Rechazada"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_EnRevision"
	Default="En Revisión"
	returnvariable="LB_EnRevision"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Aplicada"
	Default="Aplicada"
	returnvariable="LB_Aplicada"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Estado"
	Default="Estado"
	returnvariable="LB_Estado"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Descripcion"
	Default="Descripci&oacute;n"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_Descripcion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_CantidadDeEmpleados"
	Default="Cantidad de Empleados"
	returnvariable="LB_CantidadDeEmpleados"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_NOSEHAREGISTRADONINGUNAMATRICULA"
	Default="NO SE HA REGISTRADO NINGUNA MATRÍCULA"
	returnvariable="LB_NOSEHAREGISTRADONINGUNAMATRICULA"/>


<!--- FIN VARIABLES DE TRADUCCION --->
<!--- CONSULTAS --->
<!---QUERY PARA EL FILTRO DE LA LISTA, PARA EL CAMPO ESTADO--->
<cfset rsEstado = queryNew("value,description","Integer,Varchar")>
<cfset queryAddRow(rsEstado,3)>
<cfset querySetCell(rsEstado,"value",10,1)>
<cfset querySetCell(rsEstado,"description","#LB_Solicitada#",1)>
<cfset querySetCell(rsEstado,"value",30,2)>
<cfset querySetCell(rsEstado,"description","#LB_EnRevision#",2)>
<!---  FIN DE CONSULTAS--->


<form name="listaEvaluaciones" action="<cfoutput>#GetFileFromPath(GetTemplatePath())#</cfoutput>" method="post">
<table width="85%" align="center" border="0" cellspacing="0" cellpadding="0">
	<tr>
    	<td>
			<cf_dbfunction name="to_char" args="RHRCestado" returnvariable="Lvar_RHRCestado">
			<cfinvoke 
				 component="rh.Componentes.pListas"
				 method="pListaRH"
				 returnvariable="pListaRHRet">
					<cfinvokeargument name="tabla" value="RHRelacionCap a"/>
					<cfinvokeargument name="columnas" value="RHRCid, RHRCdescripcion, (select count(1) 
																					 	from RHDRelacionCap c 
																					 	where RHRCid = a.RHRCid) as cant_empleados, 
															RHRCestado as Estado,
															(case RHRCestado 
															when 0 then '#LB_EnCapturaDeAutogestion#' 
															when 10 then '#LB_Solicitada#' 
															when 20 then '#LB_Rechazada#' 
															when 30 then '#LB_EnRevision#' 
															when 40 then '#LB_Aplicada#' 
															else {fn concat('#LB_Estado# ',#Lvar_RHRCestado#)} end) as RHRCestado"/>
					<cfinvokeargument name="desplegar" value="RHRCdescripcion, RHRCestado, cant_empleados "/>
					<cfinvokeargument name="etiquetas" value="#LB_Descripcion#, #LB_Estado#, #LB_CantidadDeEmpleados#"/>
					<cfinvokeargument name="formatos" value="S, S, I"/>
					<cfinvokeargument name="filtro" value="a.Ecodigo = #session.Ecodigo# and a.RHRCestado in (10,30)"/>
					<cfinvokeargument name="align" value="left, center, right"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="irA" value="index.cfm"/>
					<cfinvokeargument name="checkboxes" value="N">
					<cfinvokeargument name="keys" value="RHRCid">
					<cfinvokeargument name="formName" value="listaEvaluaciones">
					<cfinvokeargument name="incluyeform" value="false">
					<cfinvokeargument name="showEmptyListMsg" value="true">
					<cfinvokeargument name="EmptyListMsg" value="*** #LB_NOSEHAREGISTRADONINGUNAMATRICULA# ***">
					<cfinvokeargument name="mostrar_Filtro" value="true">
					<cfinvokeargument name="filtrar_automatico" value="true">
					<cfinvokeargument name="filtrar_por" value="RHRCdescripcion,RHRCestado,(select count(1) 
																					 	from RHDRelacionCap c 
																					 	where RHRCid = a.RHRCid)">
					<cfinvokeargument name="rsRHRCestado" value="#rsEstado	#">
		  </cfinvoke>
		</td>
	</tr>
	<tr><td><cf_botones names="Nuevo" values="Nuevo" nbspbefore="4" nbspafter="4"></td></tr>
</table>
</form>
﻿<script language="javascript" type="text/javascript">
	
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
		if (result) form.action = "index_lista_sql.cfm";
		return result;
	}
	
	function funcCerrar(){
		var form = document.listaEvaluaciones;
		var msg = "¿Desea finalizar las relaciones marcadas?";
		result = (hayMarcados()&&confirm(msg));
		if (result) form.action = "index_lista_sql.cfm";
		return result;
	}

</script>