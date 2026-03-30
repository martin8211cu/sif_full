<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="LB_NoHaSidoEvaluado" Default="No ha sido evaluado" returnvariable="LB_NoHaSidoEvaluado" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="LB_Evaluado" Default="Evaluado" returnvariable="LB_Evaluado" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="LB_EnProcesoDeEvaluacion" Default="En Proceso de Evaluaci&oacute;n" returnvariable="LB_EnProcesoDeEvaluacion" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="LB_Nombre" Default="Nombre" returnvariable="LB_Nombre" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Identificacion" Default="Identificaci&oacute;n" returnvariable="LB_Identificacion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_EstadoDeLaEvaluacionn" Default="Estado de la Evaluaci&oacute;n" returnvariable="LB_EstadoDeLaEvaluacionn" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Todos" Default="Todos" returnvariable="LB_Todos" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="MSG_NoSeEncontraronRegistros" Default="No se encontraron Registros" XmlFile="/rh/generales.xml" returnvariable="MSG_NoSeEncontraronRegistros" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->

<!---QUERY PARA EL FILTRO DE LA LISTA, PARA EL CAMPO ESTADO--->
<cfquery datasource="#session.dsn#" name="rsEstado">
	select '' as value, '#LB_Todos#' as description, '0' as ord
	union
	select '0' as value, '#LB_NoHaSidoEvaluado#' as description, '1' as ord
	union
	select '1' as value, '#LB_Evaluado#' as description, '2' as ord
	union
	select '2' as value, '#LB_EnProcesoDeEvaluacion#' as description, '3' as ord
	order by 3,2
</cfquery>
<!--- LISTA DE EMPLEADOS ASIGNADOS A LA RELACION
	LA LISTA MUESTA LA IDENTIFICACION, NOMBRE Y ESTADO DE LA EVALUACION PARA UN EMPLEADO
	TODOS LOS PUNTOS A EVALUAR TIENEN NOTA DE CERO EL EMPLEADO TIENE UN INDICADOR DE  "NO HA SIDO EVALUADO"
	SI EL EMPLEADO TIENE ALGUNAS NOTAS EN CERO  SE INDICA COMO "EN PROCESO DE EVALUACION"
	Y SI TODOS LOS PUNTOS YA HAN SIDO EVALUADOS SE INDICA COMO "EVALUADO"
	EL INDICADOR SE ASIGNA VERIFICANDO LA CANTIDAD DE REGISTROS DEL EMPLEADO EN LA EVALUACION EN DONDE LOS PUNTOS A EVALUAR
	DE LAS COMPENTENCIAS O PLANES DE ACCION TENGAN EN "NOTANUEVA" <> A 0, Y LO COMPARA.
	SI ES CERO ENTONCES NO HA INICIADO LA EVALUACION
	SI ES MAYOR A CERO PERO DIFERENTE A LA CANTIDAD DE REGISTROS ENTONCES ESTA EVALUANDO
	DE LO CONTRARIO YA SE HA TERMINADO LA EVALUACION Y SE PUEDE CERRAR.	
--->
	
 <cfinvoke 
		component="rh.Componentes.pListas"
		method="pListaRH"
		returnvariable="pListaRel">
			<cfinvokeargument name="tabla" value="RHEmpleadosCF a
													inner join RHEvaluadoresCalificacion b
															inner join UsuarioReferencia u
																on convert(numeric,u.llave) = b.DEid
																and u.Usucodigo = #session.usucodigo#
																and u.STabla = 'DatosEmpleado'
																and u.Ecodigo = #session.ecodigosdc#
														on b.RHRCid = a.RHRCid
														and b.DEid = a.DEidJefe
													inner join DatosEmpleado c
														on c.DEid = a.DEid"/>
			<cfinvokeargument name="columnas" value="a.RHRCid, a.CFid, a.DEid, a.RHPcodigo, 
														c.DEidentificacion, 
														{fn concat(c.DEapellido1,{fn concat(' ',{fn concat( c.DEapellido2,{fn concat(' ',DEnombre)})})})} as DEnombrecompleto,
														 case ((select count(1)
															from RHEmpleadosCF ecf
															inner join RHEvaluadoresCalificacion ec
																on ec.RHRCid = ecf.RHRCid
																and ec.DEid = ecf.DEidJefe
																and ec.RHECestado = 0
															inner join UsuarioReferencia u1
																on convert(numeric,u1.llave) = ec.DEid
																and u1.Usucodigo = #session.Usucodigo#
																and u1.STabla = 'DatosEmpleado'
																and u1.Ecodigo = #session.EcodigoSDC#
															inner join RHEvaluacionComp c
																on ecf.RHRCid = c.RHRCid 
																and nuevanota <> 0
																and ecf.DEid = c.DEid
															where ecf.Ecodigo =#session.Ecodigo#
															  and ecf.RHRCid = a.RHRCid
															  and ecf.DEid = a.DEid)+
														    (select count(1)
															from RHEmpleadosCF ecf
															inner join RHEvaluadoresCalificacion ec
																on ec.RHRCid = ecf.RHRCid
																and ec.DEid = ecf.DEidJefe
																and ec.RHECestado = 0
															inner join UsuarioReferencia u1
																on convert(numeric,u1.llave) = ec.DEid
																and u1.Usucodigo = #session.Usucodigo#
																and u1.STabla = 'DatosEmpleado'
																and u1.Ecodigo = #session.EcodigoSDC#
															inner join RHEvalPlanSucesion c
																on ecf.RHRCid = c.RHRCid 
																and nuevanota <> 0
																and ecf.DEid = c.DEid
															where ecf.Ecodigo =#session.Ecodigo#
															  and ecf.RHRCid = a.RHRCid
															  and ecf.DEid = a.DEid)) 
														when 0 then '#LB_NoHaSidoEvaluado#'
														when ((select count(1)
															from RHEmpleadosCF ecf
															inner join RHEvaluadoresCalificacion ec
																on ec.RHRCid = ecf.RHRCid
																and ec.DEid = ecf.DEidJefe
																and ec.RHECestado = 0
															inner join UsuarioReferencia u1
																on convert(numeric,u1.llave) = ec.DEid
																and u1.Usucodigo = #session.Usucodigo#
																and u1.STabla = 'DatosEmpleado'
																and u1.Ecodigo = #session.EcodigoSDC#
															inner join RHEvaluacionComp c
																on ecf.RHRCid = c.RHRCid 
																and ecf.DEid = c.DEid
															where ecf.Ecodigo =#session.Ecodigo#
															  and ecf.RHRCid = a.RHRCid
															  and ecf.DEid = a.DEid)+
														    (select count(1)
															from RHEmpleadosCF ecf
															inner join RHEvaluadoresCalificacion ec
																on ec.RHRCid = ecf.RHRCid
																and ec.DEid = ecf.DEidJefe
																and ec.RHECestado = 0
															inner join UsuarioReferencia u1
																on convert(numeric,u1.llave) = ec.DEid
																and u1.Usucodigo = #session.Usucodigo#
																and u1.STabla = 'DatosEmpleado'
																and u1.Ecodigo = #session.EcodigoSDC#
															inner join RHEvalPlanSucesion c
																on ecf.RHRCid = c.RHRCid 
																and ecf.DEid = c.DEid
															where ecf.Ecodigo =#session.Ecodigo#
															  and ecf.RHRCid = a.RHRCid
															  and ecf.DEid = a.DEid)) 
															then '#LB_Evaluado#'
															else '#LB_EnProcesoDeEvaluacion#' end
															as estado
														
													"/>
			<cfinvokeargument name="desplegar" value="DEidentificacion, DEnombrecompleto, estado"/>
			<cfinvokeargument name="etiquetas" value="#LB_Identificacion#, #LB_Nombre#, #LB_EstadoDeLaEvaluacionn#"/>
			<cfinvokeargument name="formatos" value="S, S, S"/>
			<cfinvokeargument name="filtro" value="a.Ecodigo = #session.ecodigo#
													and a.RHRCid = #form.RHRCid#
												   order by c.DEidentificacion"/>
			<cfinvokeargument name="align" value="left, left, left"/>
			<cfinvokeargument name="ajustar" value=""/>				
			<cfinvokeargument name="irA" value="evaluacion.cfm"/>
			<cfinvokeargument name="showEmptyListMsg" value="true"/>
			<cfinvokeargument name="debug" value="N"/>
			<cfinvokeargument name="maxRows" value="20"/>
			<cfinvokeargument name="keys" value="DEid"/>
			<cfinvokeargument name="botones" value="Regresar"/>
			<cfinvokeargument name="mostrar_filtro" value="true"/>
			<cfinvokeargument name="filtrar_automatico" value="true"/>
			<cfinvokeargument name="filtrar_por" value="DEidentificacion|{fn concat(c.DEapellido1,{fn concat(' ',{fn concat( c.DEapellido2,{fn concat(' ',DEnombre)})})})}|case ((select count(1) from RHEvaluacionComp xx where xx.RHRCid = a.RHRCid and xx.CFid = a.CFid and xx.DEid = a.DEid and nuevanota <> 0)+
																(select count(1) from RHEvalPlanSucesion yy where yy.RHRCid = a.RHRCid and yy.CFid = a.CFid and yy.DEid = a.DEid and nuevanota <> 0)) 
														when 0 
															then 0
														when ((select count(1) from RHEvaluacionComp xx where xx.RHRCid = a.RHRCid and xx.CFid = a.CFid and xx.DEid = a.DEid)+
																(select count(1) from RHEvalPlanSucesion yy where yy.RHRCid = a.RHRCid and yy.CFid = a.CFid and yy.DEid = a.DEid)) 
															then 1
														else
															2
														end"/>
			<cfinvokeargument name="filtrar_por_delimiters" value="|"/>
			<cfinvokeargument name="EmptyListMsg" value="#MSG_NoSeEncontraronRegistros#"/>
			<cfinvokeargument name="rsEstado" value="#rsEstado#"/>
		</cfinvoke>	


<cfoutput>
<script language="javascript" type="text/javascript">
	function funcFiltrar(){
		document.lista.RHRCID.value = "#form.RHRCid#";
		return true;
	}
	function funcRegresar(){
		document.lista.action = 'evaluacion.cfm';
		return true;
	}
</script>
</cfoutput>