<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="LB_Descripcion" Default="Descripci&oacute;n" XmlFile="/rh/generales.xml" returnvariable="LB_Descripcion" component="sif.Componentes.Translate" method="Translate"/>		
<cfinvoke Key="LB_Desde" Default="Desde" returnvariable="LB_Desde" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Hasta" Default="Hasta" returnvariable="LB_Hasta" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_EstadoDeLaEvaluacion" Default="Estado de Evaluaci&oacute;n" returnvariable="LB_EstadoDeLaEvaluacion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_NoSeEncontraronRegistros" Default="No se encontraron Registros" XmlFile="/rh/generales.xml" returnvariable="MSG_NoSeEncontraronRegistros" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_DebeAeleccionarAlMenosUnRegistroParaRealizarEstaAccion" Default="Debe seleccionar al menos un registro para realizar esta acción." returnvariable="MSG_DebeAeleccionarAlMenosUnRegistroParaRealizarEstaAccion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_DeseaTerminarLaEvaluacion" Default="Desea Terminar la Evaluación?" returnvariable="MSG_DeseaTerminarLaEvaluacion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_YaNoPodraEvaluarNuevamenteEstaRelacionLaEvaluacion" Default="¡Ya no podrá evaluar nuevamente este relación!" returnvariable="MSG_YaNoPodraEvaluarNuevamenteEstaRelacionLaEvaluacion" component="sif.Componentes.Translate" method="Translate"/>

<!--- FIN DE VARIABLES DE TRADUCCION --->

<!--- LISTA DE EVALUACIONES
	LOS DATOS QUE SE MUESTRAN SON DESCRIPCION, FECHA DESDE, FECHA HASTA.
	LA EVALUACIÓN PUEDE SER TERMINADA SOLO SI TODOS LOS EMPLEADOS ASIGNADOS A LA RELACION HAN SIDO CALIFICADOS
	SI EL CHK ESTA HABILITADO SE PUEDE CERRAR.
	EL INDICADOR SE ASIGNA VERIFICANDO LA CANTIDAD DE REGISTROS DE LA EVALUACION EN DONDE LOS PUNTOS A EVALUAR
	DE LAS COMPENTENCIAS O PLANES DE ACCION TENGAN EN "NOTANUEVA" <> A 0, Y LO COMPARA.
	SI ES CERO ENTONCES NO HA INICIADO LA EVALUACION
	SI ES MAYOR A CERO PERO DIFERENTE A LA CANTIDAD DE REGISTROS ENTONCES ESTA EVALUANDO
	DE LO CONTRARIO YA SE HA TERMINADO LA EVALUACION Y SE PUEDE CERRAR.
--->
	<cfinvoke 
		component="rh.Componentes.pListas"
		method="pListaRH"
		returnvariable="pListaRel">
			<cfinvokeargument name="tabla" value="RHRelacionCalificacion a
													inner join RHEvaluadoresCalificacion b
														on a.RHRCid = b.RHRCid
														and b.RHECestado = 0
													inner join UsuarioReferencia u
														on convert(numeric,u.llave) = b.DEid
														and u.Usucodigo = #session.usucodigo#
														and u.STabla = 'DatosEmpleado'
														and u.Ecodigo = #session.ecodigosdc#"/>
			<cfinvokeargument name="columnas" value="a.RHRCid, RHRCdesc, RHRCfdesde, 
													RHRCfhasta, RHRCfcorte, RHRCitems, RHRCestado,
													RHRCdesc as descripcion, 
													 case (select count(1)
															from RHEmpleadosCF ecf
															inner join UsuarioReferencia u
															on convert(numeric,u.llave) = ecf.DEidJefe
															and u.Usucodigo = #session.usucodigo#
															and u.STabla = 'DatosEmpleado'
															and u.Ecodigo = #session.ecodigosdc#
																where ecf.Ecodigo = #session.ecodigo#
																  and ecf.RHRCid = a.RHRCid
																  and ((select coalesce(sum(nuevanota),0) from RHEvaluacionComp  x where x.RHRCid = ecf.RHRCid and x.DEid = ecf.DEid) 
																	+ (select coalesce(sum(nuevanota),0) from RHEvalPlanSucesion x where x.RHRCid = ecf.RHRCid and x.DEid = ecf.DEid)) = 0
	


													 	) when 0 
															then null
															else a.RHRCid end as inactivecol
														,'' as BOTON 
													"/>
			<cfinvokeargument name="desplegar" value="descripcion, RHRCfdesde, RHRCfhasta"/>
			<cfinvokeargument name="etiquetas" value="#LB_Descripcion#, #LB_Desde#, #LB_Hasta#"/>
			<cfinvokeargument name="formatos" value="S, D, D"/>
			<cfinvokeargument name="filtro" value="a.Ecodigo = #session.ecodigo#
												   and #LSParseDateTime(LSDateFormat(Now(),'dd/mm/yyyy'))#
													 	between a.RHRCfdesde and a.RHRCfhasta
												   and a.RHRCestado = 10
												   order by RHRCfdesde"/>
			<cfinvokeargument name="align" value="left, left, left"/>
			<cfinvokeargument name="ajustar" value=""/>				
			<cfinvokeargument name="irA" value="evaluacion.cfm"/>
			<cfinvokeargument name="showEmptyListMsg" value="true"/>
			<cfinvokeargument name="debug" value="N"/>
			<cfinvokeargument name="maxRows" value="30"/>
			<cfinvokeargument name="keys" value="RHRCid"/>
			<cfinvokeargument name="checkboxes" value="S">
			<cfinvokeargument name="botones" value="Terminar"/>
			<cfinvokeargument name="mostrar_filtro" value="true"/>
			<cfinvokeargument name="filtrar_automatico" value="true"/>
			<cfinvokeargument name="filtrar_por" value="RHRCdesc, RHRCfdesde, 
													RHRCfhasta"/>
			<cfinvokeargument name="EmptyListMsg" value="#MSG_NoSeEncontraronRegistros#"/>
			<cfinvokeargument name="inactivecol" value="inactivecol"/>
		</cfinvoke>	

<script language="javascript" type="text/javascript">
	function hayMarcados(){
		var form = document.lista;
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
		if (!result) alert('¡<cfoutput>#MSG_DebeAeleccionarAlMenosUnRegistroParaRealizarEstaAccion#</cfoutput>!');
		return result;
	}
	function funcTerminar(){
		if (hayMarcados()) {
			if (confirm('<cfoutput>#MSG_DeseaTerminarLaEvaluacion#</cfoutput>. <cfoutput>#MSG_YaNoPodraEvaluarNuevamenteEstaRelacionLaEvaluacion#</cfoutput>')){
				document.lista.action = "evaluacion-formlistaevaluacionesSQL.cfm";
				document.lista.BOTON.value = 'Terminar';
				document.lista.submit();		
				return true;
			}
		}
		return false; 
	}
</script>