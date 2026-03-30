<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Abierto"
	Default="Abierto"	
	returnvariable="LB_Abierto"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Publicado"
	Default="Publicado"	
	returnvariable="LB_Publicado"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Cerrado"
	Default="Cerrado"	
	returnvariable="LB_Cerrado"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DebeSeleccionarAlMenosUnRegistroParaRelizarEstaAccion"
	Default="Debe seleccionar al menos un registro para relizar esta acci&oacute;n."	
	returnvariable="MSG_DebeSeleccionarAlMenosUnRegistroParaRelizarEstaAccion"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ExistenConceptosPendientesDeCalificarEnLasEvaluacionesSeleccionadasNoSePuedeCerrarLaRelacion"
	Default="Existen conceptos pendientes de calificar en las Evaluaciones seleccionadas. No se puede Cerrar la relaci&oacute;n"	
	returnvariable="MSG_ExistenConceptosPendientesDeCalificarEnLasEvaluacionesSeleccionadasNoSePuedeCerrarLaRelacion"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DeseaMarcarComoListasParaSerEvaluadasLasEvaluacionesMarcadas"
	Default="¿Desea marcar como listas para ser evaluadas las evaluaciones marcadas?"	
	returnvariable="MSG_DeseaMarcarComoListasParaSerEvaluadasLasEvaluacionesMarcadas"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DeseaFinalizarLasRelacionesMarcadas"
	Default="¿Desea finalizar las relaciones marcadas?"	
	returnvariable="MSG_DeseaFinalizarLasRelacionesMarcadas"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_NOSEHAREGISTRADONINGUNAEVALUACION"
	Default="NO SE HA REGISTRADO NINGUNA EVALUACION"	
	returnvariable="MSG_NOSEHAREGISTRADONINGUNAEVALUACION"/>	



<!--- VARIABLES DE TRADUCCION --->
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
	function hayCerrado(){
		var form = document.listaEvaluaciones;
		var result = false;
		if (form.chk!=null) {
			if (form.chk.length){
				for (var i=0; i<form.chk.length; i++){
					var x=i+1;
					var dato = 'form.CERRADA_'+ x +'.value';
					if (eval(dato)==1 && form.chk[i].checked)
						result = true;
				}
			}
			else{
				if (eval('form.CERRADA_1.value')==1 && form.chk.checked)
					result = true;
			}
		}
		if (!result) {
			result= false;
			alert('<cfoutput>#MSG_ExistenConceptosPendientesDeCalificarEnLasEvaluacionesSeleccionadasNoSePuedeCerrarLaRelacion#</cfoutput>');
		}else result = true;
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
		result = (hayMarcados()&&hayCerrado());
		if (result) 
			if (confirm(msg)) form.action = "registro_evaluacion_lista_sql.cfm";
			else return false;
		
		return result;
	}

</script>

<!--- 
	PARA VERIFICAR CUANDO UNA RELACION NO HA SIDO EVALUADA TOTALMENTE Y SE PUEDA CERRAR SE CUENTA
	LA CANTIDAD DE PREGUNTAS QUE SE ASIGNARON PARA AUTOEVALUACION MAS LA CANTIDAD DE PREGUNTAS DE LA JEFATURA,
	SI ESTA SUMA ES IGUAL A LA SUMA DE LAS MISMAS PREGUNTAS PERO DONDE REEfinale, y REEfinalj = 1, 
	QUE QUIERE DECIR QUE YA HA SIDO EVALUADA Y APLICADA ENTONCES SE PUEDE CERRAR,
	DE LO CONTRARIO ENVIA UNA MENSAJE.
	--->
<cfoutput>
<form name="listaEvaluaciones" action="#GetFileFromPath(GetTemplatePath())#" method="post"></cfoutput>
<input name="vCerrar" type="hidden" value="#vCerrar#">
<table width="85%" align="center" border="0" cellspacing="0" cellpadding="0">
	<tr>
    	<td>
			<cfinvoke 
				 component="rh.Componentes.pListas"
				 method="pListaRH"
				 returnvariable="pListaRHRet">
					<cfinvokeargument name="tabla" value="RHRegistroEvaluacion a"/>
					<cfinvokeargument name="columnas" value="	REid, 
																REdescripcion, 
																(	select count(1) 
																					from RHEmpleadoRegistroE
																					where REid = a.REid) as cant_empleados, 
																case REestado when 0 then '#LB_Abierto#' 
																						 when 1 then '#LB_Publicado#' 
																						 when 2 then '#LB_Cerrado#' end as REestado,
																REestado as Estado,
																case when ((select count(1)
																			from RHRegistroEvaluacion a1
																			inner join RHRegistroEvaluadoresE b
																				on a1.REid = b.REid 
																				and b.REEfinale = 1
																								
																			inner join RHConceptosDelEvaluador c
																				on b.REEid =c.REEid
																								
																			inner join RHIndicadoresRegistroE d
																				on c.IREid = d.IREid
																			inner join RHEmpleadoRegistroE e
																				on b.REid = e.REid
																				and b.DEid = e.DEid
																				and e.EREnoempleado = 0
																			where a1.Ecodigo = #session.Ecodigo#
																			  and a1.REid = a.REid
																			  and a1.REaplicaempleado = 1)+
																			
																			(select  count(1)
																			from RHRegistroEvaluadoresE a1 
																			inner join RHConceptosDelEvaluador b
																				on   a1.REid = b.REid
																				and  a1.REEid = b.REEid
																			inner join RHIndicadoresRegistroE c
																				on   b.IREid  = c.IREid 
																				and c.IREevaluajefe = 0
																				and c.IREevaluasubjefe = 0
																			inner join RHEmpleadoRegistroE e
																				on a1.REid = e.REid
																				and a1.DEid = e.DEid
																				and e.EREnojefe = 0
																			where  a1.REid = a.REid
																				and a1.REEfinalj = 1)+
																			
																			(select  count(1)
																			from RHRegistroEvaluadoresE a1 
																			inner join RHConceptosDelEvaluador b
																				on   a1.REid = b.REid
																				and  a1.REEid = b.REEid
																			inner join RHIndicadoresRegistroE c
																				on   b.IREid  = c.IREid 
																			inner join RHIndicadoresAEvaluar d
																				on c.IAEid  = d.IAEid 
																				and  d.IAEtipoconc != 'T'
																			inner join RHEmpleadoRegistroE e
																				on a1.REid = e.REid
																				and a1.DEid = e.DEid
																				and e.EREnojefe = 0	
																			where  a1.REid = a.REid
																			 and a1.REEfinalj = 1)+
																			
																			(select  count(1)
																			from RHRegistroEvaluadoresE a1 
																			inner join RHConceptosDelEvaluador b
																				on   a1.REid = b.REid
																				and  a1.REEid = b.REEid
																			inner join RHIndicadoresRegistroE c
																				on   b.IREid  = c.IREid 
																				and  c.IREevaluasubjefe = 1
																			inner join RHIndicadoresAEvaluar d
																				on 	 c.IAEid  = d.IAEid 
																				and  d.IAEtipoconc = 'T'
																			inner join RHEmpleadoRegistroE e
																				on 	a1.REid = e.REid
																				and a1.DEid = e.DEid
																				and e.EREnojefe = 0	
																			where  a1.REid = a.REid
																			 and a1.REEfinalj = 1
																			)) =
																			
																			((select count(1)
																			from RHRegistroEvaluacion a1
																			inner join RHRegistroEvaluadoresE b
																				on a1.REid = b.REid 
																							
																			inner join RHConceptosDelEvaluador c
																				on b.REEid =c.REEid
																								
																			inner join RHIndicadoresRegistroE d
																				on c.IREid = d.IREid

																			inner join RHEmpleadoRegistroE e
																				on b.REid = e.REid
																				and b.DEid = e.DEid
																				and e.EREnoempleado = 0
																			where a1.Ecodigo = #session.Ecodigo#
																			  and a1.REid = a.REid
																			  and a1.REaplicaempleado = 1)+
																			
																			(select  count(1)
																			from RHRegistroEvaluadoresE a1 
																			inner join RHConceptosDelEvaluador b
																				on   a1.REid = b.REid
																				and  a1.REEid = b.REEid
																			inner join RHIndicadoresRegistroE c
																				on   b.IREid  = c.IREid 
																				and c.IREevaluajefe = 0
																				and c.IREevaluasubjefe = 0
																			inner join RHEmpleadoRegistroE e
																				on a1.REid = e.REid
																				and a1.DEid = e.DEid
																				and e.EREnojefe = 0
																			where  a1.REid = a.REid)+
																			
																			(select  count(1)
																			from RHRegistroEvaluadoresE a1 
																			inner join RHConceptosDelEvaluador b
																				on   a1.REid = b.REid
																				and  a1.REEid = b.REEid
																			inner join RHIndicadoresRegistroE c
																				on   b.IREid  = c.IREid 
																			inner join RHIndicadoresAEvaluar d
																				on c.IAEid  = d.IAEid 
																				and  d.IAEtipoconc != 'T'
																			inner join RHEmpleadoRegistroE e
																				on a1.REid = e.REid
																				and a1.DEid = e.DEid
																				and e.EREnojefe = 0	
																			where  a1.REid = a.REid)+
																			
																			(select  count(1)
																			from RHRegistroEvaluadoresE a1 
																			inner join RHConceptosDelEvaluador b
																				on   a1.REid = b.REid
																				and  a1.REEid = b.REEid
																			inner join RHIndicadoresRegistroE c
																				on   b.IREid  = c.IREid 
																				and  c.IREevaluasubjefe = 1
																			inner join RHIndicadoresAEvaluar d
																				on 	 c.IAEid  = d.IAEid 
																				and  d.IAEtipoconc = 'T'
																			inner join RHEmpleadoRegistroE e
																				on 	a1.REid = e.REid
																				and a1.DEid = e.DEid
																				and e.EREnojefe = 0	
																			where  a1.REid = a.REid))
																			then 1
																			else 0 end as Cerrada"/>
					<cfinvokeargument name="desplegar" value="REdescripcion, REestado, cant_empleados"/>
					<cfinvokeargument name="etiquetas" value="#LB_Descripcion#, #LB_Estado#, #LB_CantidadEmpleados#"/>
					<cfinvokeargument name="formatos" value="S, S, I"/>
					<cfinvokeargument name="filtro" value="a.Ecodigo = #session.Ecodigo# and a.REestado in(0,1) #filtro# order by REestado,REdescripcion"/>
					<cfinvokeargument name="align" value="left, center, right"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="irA" value="registro_evaluacion.cfm"/>
					<cfinvokeargument name="checkboxes" value="S"> 
					<cfinvokeargument name="keys" value="REid">
					<cfinvokeargument name="formName" value="listaEvaluaciones">
					<cfinvokeargument name="incluyeform" value="false">
					<cfinvokeargument name="showEmptyListMsg" value="true">
					<cfinvokeargument name="EmptyListMsg" value="*** #MSG_NOSEHAREGISTRADONINGUNAEVALUACION# ***">
					<cfinvokeargument name="navegacion" value="#navegacion#">
		  </cfinvoke>
		</td>
	</tr>
	<tr>
		<td>
			<cf_botones names="Nuevo,Cerrar" values="Nuevo,Cerrar" nbspbefore="4" nbspafter="4">
		</td>
	</tr>
</table>
</form>