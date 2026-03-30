<!---Averiguar si se ingresa desde Autogestion o desde Nomina --->
<cfinvoke component="rh.Componentes.RH_IncidenciasProceso" method="validaLugarConsulta" returnvariable="Menu"/>

<!--- Averiguar rol. -1=Ninguno, 0=Usuario, 1=Jefe, 2=Administrador --->
<cfinvoke component="rh.Componentes.RH_IncidenciasProceso" method="getRol" returnvariable="rol"/>

<!--- Averigua si el usuario es empleado activo en al empresa actual--->
<cfinvoke component="rh.Componentes.RH_IncidenciasProceso" method="getEmpleadoUsuario" returnvariable="rsDEidUser"/>
<cfif rsDEidUser.RecordCount EQ 0><!---No es empleado--->
	<cfset UserDEid = 0>
<cfelse>
	<cfset UserDEid = rsDEidUser.DEid>
</cfif>

<!---Si es jefe u autorizador averigua quienes son sus subalternos --->
<cfinvoke component="rh.Componentes.RH_IncidenciasProceso" method="getSubalternos" returnvariable="rsSubalternos">
<cfinvokeargument name="DEid" value="#UserDEid#"/>
</cfinvoke>

<!---Averigua si el parametro 'Requiere aprobación incidencias' esta encendido --->
<cfinvoke component="rh.Componentes.RH_IncidenciasProceso" method="getParam" returnvariable="reqAprobacion">
	<cfinvokeargument name="Pcodigo" value="1010">
</cfinvoke>

<!---Averigua si el parametro 'Requiere aprobacion de Incidencias de tipo cálculo' esta encendido --->
<cfinvoke component="rh.Componentes.RH_IncidenciasProceso" method="getParam" returnvariable="reqAprobacionCalculo">
	<cfinvokeargument name="Pcodigo" value="1060"/>
</cfinvoke>

<!---Averigua si el parametro 'Requiere aprobacion de Incidencias por el Jefe del Centro Funcional' esta encendido --->
<cfinvoke component="rh.Componentes.RH_IncidenciasProceso" method="getParam" returnvariable="reqAprobacionJefe">
	<cfinvokeargument name="Pcodigo" value="2540"/>
</cfinvoke>

<!---Averigua si se usa presupuesto --->
<cfinvoke component="rh.Componentes.RH_IncidenciasProceso" method="getParam" returnvariable="rsUsaPresupuesto">
	<cfinvokeargument name="Pcodigo" value="540"/>
</cfinvoke>


<cfset aprobarIncidencias = false >
<cfif reqAprobacion eq 1 >
	<cfset aprobarIncidencias = true >
</cfif>

<cfset aprobarIncidenciasCalc = false >
<cfif reqAprobacionCalculo eq 1 >
	<cfset aprobarIncidenciasCalc = true >
</cfif>	

<cfset aprobarIncidenciasJefe= false >
<cfif reqAprobacionJefe eq 1 >
	<cfset aprobarIncidenciasJefe = true >
</cfif>	

<cfset usaPresupuesto = false >
<cfif rsUsaPresupuesto eq 1 >
	<cfset usaPresupuesto = true >
</cfif>

<!---**********************FILTROS PARA EL QUERY DE LA LISTA************************************************--->
<cfset I_ingresadopor = '0,1,2'>		<!---CHECK apagado. En este caso no importa quien ingrese las incidencias pueden verlas todos--->			
<cfset I_estado = '0,1,2'>				
<cfset I_estadoAprobacion = '0,1,2,3'>
	
<cfset filtro_estadoList= '1,2,3,4,5,6'>	<!---filtros que se pueden visualizar--->
										
<cfif isdefined("url.filtro_estado")>		
	
	<cfif url.filtro_estado eq 1 >			<!---filtro pendiente jefe--->
		<cfset I_estadoAprobacion = '1'>
	<cfelseif url.filtro_estado eq 2>		<!---filtro rechaza jefe--->
		<cfset I_estadoAprobacion = '3'>
	<cfelseif url.filtro_estado eq 3>		<!---filtro aprueba jefe--->
		<cfset I_estadoAprobacion = '2'>
		
	<cfelseif url.filtro_estado eq 4 >		<!---filtro pendiente admin--->
		<cfset I_estado = '0'>
	<cfelseif url.filtro_estado eq 5>		<!---filtro rechaza admin--->
		<cfset I_estado = '2'>
	<cfelseif url.filtro_estado eq 6>		<!---filtro aprueba admin--->
		<cfset I_estado = '1'>
	
	<cfelseif url.filtro_estado eq 7>		<!---casos en que se usa presupuesto--->
		<cfset I_estado = '1'>
	<cfelseif url.filtro_estado eq 8>		
		<cfset I_estado = '1'>
	</cfif>
	
</cfif>
<!---
Casos filtro_estado: 
0 = filtro incidencias ingresadas; 
1 = filtro pendiente de aprobar por el jefe; 
2 = filtro rechazado por el jefe; 
3 = filtro apruebado por jefe; 
4 = filtro pendiente de aprobar por el admin; 
5 = filtro rechazado por el admin; 
6 = filtro apruebado por el admin; 
7 = aprobado con presupuesto;
8 = aprobado por el admin pero rechazado por el presupuesto;
--->

<!---**********************FIN FILTROS PARA EL QUERY DE LA LISTA************************************************--->

	<!---modifica para subir nuevamente y agregar en parche--->
	<!--- ============================================= --->
	<!--- Traducciones --->
	<!--- ============================================= --->
	<!--- Empleado --->
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Simbologia"
	Default="Simbolog&iacute;a"
	returnvariable="LB_Simbologia"/>
	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Empleado"
		default="Empleado"
		xmlfile="/rh/generales.xml"
		returnvariable="vEmpleado"/>
	<!--- Concepto_Incidente --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="Concepto_Incidente"
		default="Concepto Incidente"
		xmlfile="/rh/generales.xml"
		returnvariable="vConcepto"/>		
	<!--- Fecha Inicio--->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_FechaInicio"
		default="Fecha inicio"
		xmlfile="/rh/generales.xml"
		returnvariable="vFechaI"/>	
	<!--- Fecha--->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Fecha"
		default="Fecha"
		xmlfile="/rh/generales.xml"
		returnvariable="vFecha"/>	
	<!--- Fecha Fin--->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_FechaFin"
		default="Fecha fin"
		xmlfile="/rh/generales.xml"
		returnvariable="vFechaF"/>		
	<!--- Boton Importar --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Importar"
		default="Importar"
		xmlfile="/rh/generales.xml"
		returnvariable="vImportar"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Mes"
		default="Mes"
		xmlfile="/rh/generales.xml"
		returnvariable="LB_Mes"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Pagada"
		default="Pagada"
		xmlfile="/rh/generales.xml"
		returnvariable="LB_Pagada"/>
	<!----Boton Importar Calculo---->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_ImportarCalculo"
		default="Importar Clculo"
		returnvariable="LB_ImportarCalculo"/>			
	<!--- Boton Filtrar --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Filtrar"
		default="Filtrar"
		xmlfile="/rh/generales.xml"
		returnvariable="vFiltrar"/>		
	<!--- Cantidad/Monto --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Cantidad_Monto"
		default="Cantidad/Monto"
		returnvariable="vCantidadMonto"/>
	<!--- Cantidad horas --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Cantidad_Horas"
		default="Cantidad horas"
		returnvariable="vCantidadHoras"/>
	<!--- Cantidad dias --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Cantidad_Dias"
		default="Cantidad Dias"
		returnvariable="vCantidadDias"/>
	<!--- Monto --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Monto"
		default="Monto"
		xmlfile="/rh/generales.xml"
		returnvariable="vMonto"/>
	<!--- Valor --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Valor"
		default="Valor"
		xmlfile="/rh/generales.xml"		
		returnvariable="vValor"/>		
	<!--- Validacion Cant.digitada fuera de rango --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_La_Cantidad_digitada_se_sale_del_rango_permitido"
		default="La Cantidad digitada se sale del rango permitido"
		returnvariable="vCantidadValidacion"/>
	<!--- No puede ser cero --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="MSG_No_puede_ser_cero"
		default="No puede ser cero"
		returnvariable="vNoCero"/>		
	<!--- Icpespecial --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_CP_Especiales"
		default="CP Especiales"
		returnvariable="vIcpespecial"/>
	<!---Lista conlis--->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_ListaDeIncidencias"
		default="Lista de Incidencias"
		returnvariable="LB_ListaDeIncidencias"/>		
	<!---Etiqueta descripcion--->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Descripcion"
		default="Descripci&oacute;n"
		xmlfile="/rh/generales.xml"
		returnvariable="LB_Descripcion"/>
		
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Se_presentaron_los_siguientes_errores:\n_-_Debe seleccionar_al_menos_un_registro_para_procesar."
		default="Se presentaron los siguientes errores:\n - Debe seleccionar al menos un registro para procesar."
		returnvariable="LB_mensaje"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Estado"
		default="Estado"
		xmlfile="/rh/generales.xml"
		returnvariable="LB_estado"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Todos"
		default="Todos"
		xmlfile="/rh/generales.xml"
		returnvariable="LB_todos"/>
	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_sin_aprobar_jefe"
		default="Sin aprobar por jefe"
		returnvariable="LB_sin_aprobar_jefe"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Rechazadas_Jefe"
		default="Rechazadas por Jefe"
		returnvariable="LB_Rechazadas_Jefe"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Aprobadas_Jefe"
		default="Aprobadas por Jefe "
		returnvariable="LB_Aprobadas_Jefe"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Sin_Aprobar_Admin"
		default="Sin Aprobar por Administrador"
		returnvariable="LB_Sin_Aprobar_Admin"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Rechazadas_Admin"
		default="Rechazadas por Administrador"
		returnvariable="LB_Rechazadas_Admin"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Aprobadas_Admin"
		default="Aprobadas por Administrador"
		returnvariable="LB_Aprobadas_Admin"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_aprobadasAdmSinnap"
		default="Aprobadas por Administrador sin NAP"
		returnvariable="LB_aprobadasAdmSinnap"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_aprobadasAdmConnrp"
		default="Aprobadas por Administrador con NRP"
		returnvariable="LB_aprobadasAdmConnrp"/>
		
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_sinaprobar"
		default="Sin Aprobar"
		returnvariable="LB_sinaprobar"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_rechazadas"
		default="Rechazadas"
		returnvariable="LB_rechazadas"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_aprobadas"
		default="Aprobadas"
		returnvariable="LB_aprobadas"/>
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Aprobadas_sin_NAP"
		default="Aprobadas sin NAP"
		returnvariable="LB_aprobadassinnap"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Aprobadas_con_NRP"
		default="Aprobadas con NRP"
		returnvariable="LB_aprobadasconnrp"/>	
		
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Desea_procesar_los_registros_seleccionados?"
		default="Desea procesar los registros seleccionados?"
		returnvariable="LB_confirm"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Tipo"
		default="Tipo"
		returnvariable="vTipo"/>		
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Centro_Funcional"
		default="Centro Funcional"
		xmlFile="/rh/generales.xml"
		returnvariable="vCentro"/>	

	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Pagadas"
		default="Aplicadas Mes (2)"
		xmlFile="/rh/generales.xml"
		returnvariable="LB_Pagadas"/>	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_PagadasNomina"
		default="Aplicadas C.P. (1)"
		xmlFile="/rh/generales.xml"
		returnvariable="LB_PagadasNomina"/>	
	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_pendientes"
		default="Pendientes Mes (3)"
		xmlFile="/rh/generales.xml"
		returnvariable="LB_pendientes"/>		
						
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Incluir_dependencias"
		default="Incluir dependencias"
		xmlFile="/rh/generales.xml"
		returnvariable="vDependencias"/>		
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Estado"
		default="Estado"
		xmlFile="/rh/generales.xml"
		returnvariable="vestado"/>	
		
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Estado_Admin"
		default="Estado (Admin)"
		xmlFile="/rh/generales.xml"
		returnvariable="vestadoAdmin"/>
		
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Rechazar"
		default="Rechazar"
		xmlFile="/rh/generales.xml"
		returnvariable="vrechazar"/>
		
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Estado_Jefe"
		default="Estado (Jefe)"
		xmlFile="/rh/generales.xml"
		returnvariable="vestadoJefe"/>
		
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Presupuesto"
		default="Presupuesto"
		returnvariable="vpres"/>		

<!--- ============================================= --->
<!--- ============================================= --->
<!--- por defecto se muestran los registros no aplicados, apicados sin nap y aplicados con NRP --->
<cfparam name="url.filtro_estado" default="0">
<cfif isdefined("url.CFpk") and len(trim(url.CFpk)) >
	<cfquery name="rs_centro" datasource="#session.DSN#" >
		select CFid as CFpk, CFcodigo, CFdescripcion, CFpath
		from CFuncional
		where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFpk#">
	</cfquery>
	<cfset vpath = rs_centro.CFpath >
</cfif>

<cfset anno = DatePart("yyyy", now())>
<cfset mes  = DatePart("m", now())>

<cfset SubalternosList = ''>
<cfif Menu EQ 'AUTO'> 
	<cfif isdefined("rsSubalternos.DEid") and len(trim(rsSubalternos.DEid))>
		<cfset SubalternosList = IIF( not listFindNoCase(valuelist(rsSubalternos.DEid),UserDEid,','),
										DE(valuelist(rsSubalternos.DEid)& ',' & UserDEid),
										DE(valuelist(rsSubalternos.DEid)))>
	<cfelse>
		<cfset SubalternosList = UserDEid>
	</cfif>
</cfif>

<cf_dbfunction name="to_char" args="a.Iid" returnvariable="vIid">

<!---Big query--->
<cfquery name="rsLista" datasource="#Session.DSN#">
	select 
		x.Iid, 
		x.CIdescripcion, 
		x.Ifecha,
		x.CItipo,
		x.Ivalor,
		x.NombreEmp,
		x.centro,x.CFcodigo, x.CFdescripcion,
		x.estado,				
		x.estadoPres,
		x.Iestado,
		x.cantidad, 			<!---Suma de las incidencia del mismo tipo para un empleado que ya se hayan pagado x mes. Este dato NO SE MUESTRA pero se deja el codigo en caso de que se desee utilizar mas adelante--->
		x.cantidadcalendario,	<!---Suma de las incidencia del mismo tipo para un empleado que ya se hayan pagado x calendario. Este dato NO SE MUESTRA pero se deja el codigo en caso de que se desee utilizar mas adelante--->
		x.mes,					
		x.Pendientes,			<!---Suma de las incidencia del mismo tipo para un empleado que esten pendientes de ser pagadas. Este dato NO SE MUESTRA pero se deja el codigo en caso de que se desee utilizar mas adelante--->
		x.Iestadoaprobacion,x.estadoJefe, 
		x.Iingresadopor,
		x.usuCF,
		x.pagada,
		x.rechazar,
		x.Imonto,
		' ' as espacio
	from (
	select 	a.Iid, 
			<cf_dbfunction name="concat" args="b.CIcodigo,' -  ',b.CIdescripcion"> as CIdescripcion, 
			a.Ifecha, 
			case b.CItipo  	when 0 then ' Hora(s)' 
							when 1 then ' Da(s)' 
							when 2 then ' Importe' 
							when 3 then ' C&aacute;lculo' 
							end as CItipo,
			a.Ivalor,
			a.Imonto,
			<cf_dbfunction name="concat" args="c.DEidentificacion, ' - ',c.DEnombre,' ',c.DEapellido1,' ',c.DEapellido2"> as NombreEmp,
			<cf_dbfunction name="concat" args="cf.CFcodigo,' -  ',cf.CFdescripcion"> as centro, cf.CFcodigo, cf.CFdescripcion,
			
			
			<cfif aprobarIncidencias and aprobarIncidenciasJefe>			
				case when Iestado = 2  then  
					 <cf_dbfunction name="concat" args="'<img src=/cfmx/rh/imagenes/Borrar01_12x12.gif   onclick=funcShowEstado(6,' | #vIid# |') style=cursor:pointer />'" delimiters="|"><!---rechazado Adm--->
					 when Iestado = 1 and Iestadoaprobacion in (0,1) and NAP is not null then 
					 <cf_dbfunction name="concat" args="'<img src=/cfmx/rh/imagenes/w-check.gif   onclick=funcShowEstado(16,' | #vIid# |') style=cursor:pointer />'" delimiters="|"> <!---aprobado Adm In--->
					 when Iestado = 1 and NAP is not null then 
					 <cf_dbfunction name="concat" args="'<img src=/cfmx/rh/imagenes/w-check.gif   onclick=funcShowEstado(5,' | #vIid# |') style=cursor:pointer />'" delimiters="|"> <!---aprobado Adm--->
					 when Iestado = 0 and Iestadoaprobacion = 2 then 
					 <cf_dbfunction name="concat" args="'<img src=/cfmx/rh/imagenes/sinchequear_verde.gif   onclick=funcShowEstado(4,' | #vIid# |') style=cursor:pointer />'" delimiters="|"><!---pendiente Adm--->
					 when Iestado = 0 and Iestadoaprobacion in (1,2) then 
					 <cf_dbfunction name="concat" args="'<img src=/cfmx/rh/imagenes/sinchequear_verde.gif   onclick=funcShowEstado(17,' | #vIid# |') style=cursor:pointer />'" delimiters="|"><!---pendiente Adm--->
					 when Iestado = 0 and Iestadoaprobacion in (13) then 
					 <cf_dbfunction name="concat" args="'<img src=/cfmx/rh/imagenes/sinchequear_verde.gif   onclick=funcShowEstado(17,' | #vIid# |') style=cursor:pointer />'" delimiters="|"><!---pendiente Adm--->
					 
					 else ''  end as estado,																														<!--- aun no requiere mostrar el estado por parte del administrador, debido a rechazo del jefe o que aun esta en proceso de aprobacion  por jefe --->			
			<cfelse>
				case when Iestado = 2 then 
					<cf_dbfunction name="concat" args="'<img src=/cfmx/rh/imagenes/Borrar01_12x12.gif   onclick=funcShowEstado(6,' | #vIid# |') style=cursor:pointer />'" delimiters="|"><!---rechazado Adm--->
					 when Iestado = 1 and NAP is not null then 
					 <cf_dbfunction name="concat" args="'<img src=/cfmx/rh/imagenes/w-check.gif   onclick=funcShowEstado(5,' | #vIid# |') style=cursor:pointer />'" delimiters="|"><!---aprobado Adm--->
					 else 
					 <cf_dbfunction name="concat" args="'<img src=/cfmx/rh/imagenes/sinchequear_verde.gif   onclick=funcShowEstado(4,' | #vIid# |') style=cursor:pointer />'" delimiters="|"> <!---pendiente Adm--->
					 end as estado,				
			</cfif>
			
			case when NRP is not null then 
				<cf_dbfunction name="concat" args="'<img src=/cfmx/rh/imagenes/Borrar01_12x12.gif   onclick=funcShowEstado(9,' | #vIid# |') style=cursor:pointer />'" delimiters="|">
				 when NAP is not null then 
				 <cf_dbfunction name="concat" args="'<img src=/cfmx/rh/imagenes/w-check.gif   onclick=funcShowEstado(8,' | #vIid# |') style=cursor:pointer />'" delimiters="|">
				 else  
				 <cf_dbfunction name="concat" args="'<img src=/cfmx/rh/imagenes/sinchequear_verde.gif   onclick=funcShowEstado(7,' | #vIid# |') style=cursor:pointer />'" delimiters="|">
				 end as estadoPres,
				 Iestado,
			
			coalesce((	select sum(x.ICvalor)  from HIncidenciasCalculo x  
				where x.DEid = a.DEid 
				and   x.CIid = a.CIid 
				and <cf_dbfunction name="date_part"	args="MM, x.ICfecha"> = <cf_dbfunction name="date_part"	args="MM, a.Ifecha">
				and <cf_dbfunction name="date_part"	args="YY, x.ICfecha"> = <cf_dbfunction name="date_part"	args="YY, a.Ifecha">
			),0) as cantidad 
			,
			coalesce((	select sum(y.ICvalor)  from HIncidenciasCalculo y  , HRCalculoNomina w
				where y.DEid = a.DEid 
				and   y.CIid = a.CIid
				and   y.RCNid = w.RCNid
				and   y.RCNid = (select CPid from CalendarioPagos z
								 where z.CPperiodo  =  #anno#
								 and z.CPmes 		=  #mes#
								 and z.Ecodigo      =  #session.Ecodigo#
								 and z.Tcodigo      =  w.Tcodigo
								<!--- ljimenez se agrega el CPTipo para que tome en 
								cuenta la infomacion que solo corresponde el tipo de calendario reporte --->							
								 and z.CPtipo = (select cp1.CPtipo from CalendarioPagos cp1 where cp1.CPid = w.RCNid)
								 and a.Ifecha  between  z.CPdesde and z.CPhasta)
			),0) as cantidadcalendario, 
			<cf_dbfunction name="date_part"	args="MM, a.Ifecha">as mes,
			coalesce((
				select sum(z.Ivalor)  from Incidencias  z
				where 	z.DEid = a.DEid 
				and   	z.CIid = a.CIid
				and 	z.NAP   is null
				and 	z.Iestado in(1,2)
				and <cf_dbfunction name="date_part"	args="MM, z.Ifecha"> = <cf_dbfunction name="date_part"	args="MM, a.Ifecha">
				and <cf_dbfunction name="date_part"	args="YY, z.Ifecha"> = <cf_dbfunction name="date_part"	args="YY, a.Ifecha">
			),0) as Pendientes,			
			
			Iestadoaprobacion,
			case when Iestadoaprobacion = 3 then 
				 <cf_dbfunction name="concat" args="'<img src=/cfmx/rh/imagenes/Borrar01_12x12.gif   onclick=funcShowEstado(3,' | #vIid# |') style=cursor:pointer />'" delimiters="|"><!---rechazado jefe--->
				 when Iestadoaprobacion = 2 then 
				 <cf_dbfunction name="concat" args="'<img src=/cfmx/rh/imagenes/w-check.gif   onclick=funcShowEstado(2,' | #vIid# |') style=cursor:pointer />'" delimiters="|"><!---aprobado jefe--->
				 when Iestadoaprobacion = 1 and NAP is not null then 
				 <cf_dbfunction name="concat" args="'<img src=/cfmx/rh/imagenes/w-check.gif   onclick=funcShowEstado(16,' | #vIid# |') style=cursor:pointer />'" delimiters="|"><!---Ingresada y aprobada por el Adm Inciden--->
				 when Iestadoaprobacion = 1 and NAP is null then 
				 <cf_dbfunction name="concat" args="'<img src=/cfmx/rh/imagenes/sinchequear_verde.gif   onclick=funcShowEstado(1,' | #vIid# |') style=cursor:pointer />'" delimiters="|"><!---pendiente jefe--->
				 when Iestadoaprobacion = 0 and NAP is not null then 
				 <cf_dbfunction name="concat" args="'<img src=/cfmx/rh/imagenes/w-check.gif   onclick=funcShowEstado(15,' | #vIid# |') style=cursor:pointer />'" delimiters="|"><!---Ingresada y aprobada por el Adm Inciden--->
				 when Iestadoaprobacion = 0 and NAP is null  then 
				 <cf_dbfunction name="concat" args="'<img src=/cfmx/rh/imagenes/sinchequear_verde.gif   onclick=funcShowEstado(13,' | #vIid# |') style=cursor:pointer />'" delimiters="|"><!---Ingresada--->
				 else '-'  end as estadoJefe, 
			Iingresadopor,
			usuCF,
			'No' as pagada,
			
			case when Iestado = 1  and coalesce(Iestadoaprobacion,2) in (0,1,2) then 
			<cf_dbfunction name="concat" args="'<img src=/cfmx/rh/imagenes/w-recycle_black2.gif   onclick=RechazarIncidencia(-1,' | #vIid# |') style=cursor:pointer />'" delimiters="|"> 
			
			when Iestado = 0  and coalesce(Iestadoaprobacion,2) in (0,1,2) then 
			<cf_dbfunction name="concat" args="'<img src=/cfmx/rh/imagenes/w-recycle_black2.gif   onclick=RechazarIncidencia(-1,' | #vIid# |') style=cursor:pointer />'" delimiters="|"> 
			
			else '' end as rechazar
						
	  from  Incidencias a 
		inner join CIncidentes b
			on a.CIid = b.CIid
		 	and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
		inner join DatosEmpleado c
			on a.DEid = c.DEid
		<!---inner join LineaTiempo lt				<!--- incidencia de empleado activo--->
			on lt.DEid=a.DEid
			and a.Ifecha between lt.LTdesde and lt.LThasta
			and lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">--->
		left outer join CFuncional cf
			on a.CFid = cf.CFid
	 where a.Ivalor != 0
	   and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  <!--- filtrar por centro funcional --->
		<cfif isdefined("url.CFpk") and len(trim(url.CFpk)) >
	  		and ( cf.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFpk#">
		    	<cfif isdefined("url.dependencias") >
			    	or cf.CFpath like '#vpath#/%' 	
		    	</cfif>
		  	)
		</cfif>		    
	  
	  <!--- filtro fecha inicio--->
	  <cfif isdefined("url.filtro_fechaI") and len(trim(url.filtro_fechaI))>
		and a.Ifecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.filtro_fechaI)#">
	  </cfif>
	  
	  <!--- filtro fecha fin--->
	  <cfif isdefined("url.filtro_fechaF") and len(trim(url.filtro_fechaF))>
		and a.Ifecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.filtro_fechaF)#">
	  </cfif>
	  
	  <!--- filtro concepto --->
  	  <cfif isdefined("url.filtro_CIid") and len(trim(url.filtro_CIid))>
	  	and a.CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.filtro_CIid#">
	  </cfif>
	  
	  <!--- filtro empleado --->
  	  <cfif isdefined("url.DEid") and len(trim(url.DEid))>
	  	and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
	  </cfif>
	  
	  	<cfif url.filtro_estado eq 1 >			<!---filtro pendiente jefe--->
			and a.Iestadoaprobacion = 1
			and a.Iestado not in(1,2)
			and NAP is null
		<cfelseif url.filtro_estado eq 2>		<!---filtro rechaza jefe--->
			and a.Iestadoaprobacion = 3
			and a.Iestado not in(1,2)
			and NAP is null
		<cfelseif url.filtro_estado eq 3>		<!---filtro aprueba jefe y no rechazadas por el adm--->
			and a.Iestadoaprobacion = 2
			and a.Iestado not in(2)
			and NAP is null
			
		<cfelseif url.filtro_estado eq 4 >		<!---filtro pendiente admin y aprobada por el jefe--->
			and a.Iestadoaprobacion = 2
			and a.Iestado = 0
			and NAP is null
			
		<cfelseif url.filtro_estado eq 5>		<!---filtro rechaza admin y aprobada por el jefe, o sin aprobacin necesaria por el jefe segun parametros RH--->
			and coalesce(a.Iestadoaprobacion,2) = 2
			and a.Iestado = 2
			and NAP is null
		<cfelseif url.filtro_estado eq 6>		<!---filtro aprueba admin y aprobada por el jefe, o sin aprobacin necesaria por el jefe segun parametros RH--->
			and coalesce(a.Iestadoaprobacion,2) = 2	
			and a.Iestado = 1
			and NAP is not null
		
		<cfelseif url.filtro_estado eq 7 >						<!--- mostrar aprobadas manual pero sin aprobacion presupuestaria --->
			and coalesce(a.Iestadoaprobacion,2) = 2	
			and a.Iestado = 1
			and NAP is not  null
			and NRP is null
		<cfelseif url.filtro_estado eq 8 >						<!--- mostrar aprobadas manual con aprobacion presupuestario --->
			and coalesce(a.Iestadoaprobacion,2) = 2	
			and a.Iestado = 1
			and NAP is not null
			and NRP is not  null
		</cfif>
		
	 Union
	  
	  select 	a.Iid, 
			<cf_dbfunction name="concat" args="b.CIcodigo,' -  ',b.CIdescripcion"> as CIdescripcion, 
			a.Ifecha, 
			case b.CItipo  	when 0 then ' Hora(s)' 
							when 1 then ' Da(s)' 
							when 2 then ' Importe' 
							when 3 then ' C&aacute;lculo' 
							end as CItipo,
			a.Ivalor,
			a.Imonto,
			<cf_dbfunction name="concat" args="c.DEidentificacion, ' - ',c.DEnombre,' ',c.DEapellido1,' ',c.DEapellido2"> as NombreEmp,
			<cf_dbfunction name="concat" args="cf.CFcodigo,' -  ',cf.CFdescripcion"> as centro, cf.CFcodigo, cf.CFdescripcion,
			
			
			<cfif aprobarIncidencias and aprobarIncidenciasJefe>			
				case 
				
					 when Iestado = 1 and Iestadoaprobacion = 2 and NAP is null  then  
					 <cf_dbfunction name="concat" args="'<img src=/cfmx/rh/imagenes/Borrar01_12x12.gif   onclick=funcShowEstado(18,' | #vIid# |') style=cursor:pointer />'" delimiters="|"><!---rechazado Adm--->
					 when Iestado = 1 then 
					 <cf_dbfunction name="concat" args="'<img src=/cfmx/rh/imagenes/Borrar01_12x12.gif   onclick=funcShowEstado(10,' | #vIid# |') style=cursor:pointer />'" delimiters="|"><!---rechazado Adm--->
					 when Iestado = 0 and Iestadoaprobacion = 2 then 
					 <cf_dbfunction name="concat" args="'<img src=/cfmx/rh/imagenes/Borrar01_12x12.gif   onclick=funcShowEstado(12,' | #vIid# |') style=cursor:pointer />'" delimiters="|"><!---rechazado Adm--->
					 when Iestado = 2 then 
					 <cf_dbfunction name="concat" args="'<img src=/cfmx/rh/imagenes/Borrar01_12x12.gif   onclick=funcShowEstado(6,' | #vIid# |') style=cursor:pointer />'" delimiters="|"><!---rechazado Adm--->
					 else ''  end as estado,																														<!--- aun no requiere mostrar el estado por parte del administrador, debido a rechazo del jefe o que aun esta en proceso de aprobacion  por jefe --->			
			<cfelse>
				case when Iestado = 2 then 
					<cf_dbfunction name="concat" args="'<img src=/cfmx/rh/imagenes/Borrar01_12x12.gif   onclick=funcShowEstado(6,' | #vIid# |') style=cursor:pointer />'" delimiters="|"><!---rechazado Adm--->
					 when Iestado = 1 and NAP is not null then 
					 <cf_dbfunction name="concat" args="'<img src=/cfmx/rh/imagenes/w-check.gif   onclick=funcShowEstado(5,' | #vIid# |') style=cursor:pointer />'" delimiters="|"><!---aprobado Adm--->
					 else 
					 <cf_dbfunction name="concat" args="'<img src=/cfmx/rh/imagenes/sinchequear_verde.gif   onclick=funcShowEstado(4,' | #vIid# |') style=cursor:pointer />'" delimiters="|"> <!---pendiente Adm--->
					 end as estado,				
			</cfif>
			
			case when NRP is not null then 
				<cf_dbfunction name="concat" args="'<img src=/cfmx/rh/imagenes/Borrar01_12x12.gif   onclick=funcShowEstado(9,' | #vIid# |') style=cursor:pointer />'" delimiters="|">
				 when NAP is not null then 
				 <cf_dbfunction name="concat" args="'<img src=/cfmx/rh/imagenes/w-check.gif   onclick=funcShowEstado(8,' | #vIid# |') style=cursor:pointer />'" delimiters="|">
				 else  
				 <cf_dbfunction name="concat" args="'<img src=/cfmx/rh/imagenes/sinchequear_verde.gif   onclick=funcShowEstado(7,' | #vIid# |') style=cursor:pointer />'" delimiters="|">
				 end as estadoPres,
				 Iestado,
			
			coalesce((	select sum(x.ICvalor)  from HIncidenciasCalculo x  
				where x.DEid = a.DEid 
				and   x.CIid = a.CIid 
				and <cf_dbfunction name="date_part"	args="MM, x.ICfecha"> = <cf_dbfunction name="date_part"	args="MM, a.Ifecha">
				and <cf_dbfunction name="date_part"	args="YY, x.ICfecha"> = <cf_dbfunction name="date_part"	args="YY, a.Ifecha">
			),0) as cantidad	
			,
			coalesce((	select sum(y.ICvalor)  from HIncidenciasCalculo y  , HRCalculoNomina w
				where y.DEid = a.DEid 
				and   y.CIid = a.CIid
				and   y.RCNid = w.RCNid
				and   y.RCNid = (select CPid from CalendarioPagos z
								 where z.CPperiodo  =  #anno#
								 and z.CPmes 		=  #mes#
								 and z.Ecodigo      =  #session.Ecodigo#
								 and z.Tcodigo      =  w.Tcodigo
								<!--- ljimenez se agrega el CPTipo para que tome en 
								cuenta la infomacion que solo corresponde el tipo de calendario reporte --->							
								 and z.CPtipo = (select cp1.CPtipo from CalendarioPagos cp1 where cp1.CPid = w.RCNid)
								 and a.Ifecha  between  z.CPdesde and z.CPhasta)
			),0) as cantidadcalendario,		
			<cf_dbfunction name="date_part"	args="MM, a.Ifecha">as mes,
			coalesce((
				select sum(z.Ivalor)  from Incidencias  z
				where 	z.DEid = a.DEid 
				and   	z.CIid = a.CIid
				and 	z.NAP   is null
				and 	z.Iestado in(1,2)
				and <cf_dbfunction name="date_part"	args="MM, z.Ifecha"> = <cf_dbfunction name="date_part"	args="MM, a.Ifecha">
				and <cf_dbfunction name="date_part"	args="YY, z.Ifecha"> = <cf_dbfunction name="date_part"	args="YY, a.Ifecha">
			),0) as Pendientes,				
			Iestadoaprobacion,
			
			case when Iestadoaprobacion = 3 then 
				 <cf_dbfunction name="concat" args="'<img src=/cfmx/rh/imagenes/Borrar01_12x12.gif   onclick=funcShowEstado(3,' | #vIid# |') style=cursor:pointer />'" delimiters="|"><!---rechazado jefe--->
				 when Iestadoaprobacion = 2 then 
				 <cf_dbfunction name="concat" args="'<img src=/cfmx/rh/imagenes/w-check.gif   onclick=funcShowEstado(2,' | #vIid# |') style=cursor:pointer />'" delimiters="|"><!---aprobado jefe--->
				 when Iestadoaprobacion = 1 then 
				 <cf_dbfunction name="concat" args="'<img src=/cfmx/rh/imagenes/Borrar01_12x12.gif   onclick=funcShowEstado(11,' | #vIid# |') style=cursor:pointer />'" delimiters="|"><!---rechazado jefe--->
				 when Iestadoaprobacion = 0 then 
				 <cf_dbfunction name="concat" args="'<img src=/cfmx/rh/imagenes/sinchequear_verde.gif   onclick=funcShowEstado(14,' | #vIid# |') style=cursor:pointer />'" delimiters="|"><!---Ingresada rechazada--->
				 else '-'  end as estadoJefe, 
			Iingresadopor,
			usuCF,
			case when a.HIEstado = 2 and a.RCNid is not null then 'Si' 
			else 'No' end as pagada,
			'' as rechazar
					
	from  HIncidencias a 
		inner join CIncidentes b
			on a.CIid = b.CIid
			and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
		inner join DatosEmpleado c
			on a.DEid = c.DEid
		left outer join CFuncional cf
			on a.CFid = cf.CFid
	where a.Ivalor != 0
	  and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  
	  <!--- filtrar por centro funcional --->
		<cfif isdefined("url.CFpk") and len(trim(url.CFpk)) >
			and ( cf.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFpk#">
				<cfif isdefined("url.dependencias") >
					or cf.CFpath like '#vpath#/%' 	
				</cfif>
			)
		</cfif>		    
	
	  <!--- filtro fecha inicio--->
	  <cfif isdefined("url.filtro_fechaI") and len(trim(url.filtro_fechaI))>
		and a.Ifecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.filtro_fechaI)#">
	  </cfif>
	  
	  <!--- filtro fecha fin--->
	  <cfif isdefined("url.filtro_fechaF") and len(trim(url.filtro_fechaF))>
		and a.Ifecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.filtro_fechaF)#">
	  </cfif>
	  
	  <!--- filtro concepto --->
  	  <cfif isdefined("url.filtro_CIid") and len(trim(url.filtro_CIid))>
	  	and a.CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.filtro_CIid#">
	  </cfif>
	  
	  <!--- filtro empleado --->
  	  <cfif isdefined("url.DEid") and len(trim(url.DEid))>
	  	and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
	  </cfif>

	  <!--- filtro centro funcional --->
	  <cfif isdefined("url.CFpk") and len(trim(url.CFpk))>
	  	and ( cf.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFpk#"> 
			  <cfif isdefined("url.dependencias")> or cf.CFpath like '#trim(vpath)#%' </cfif>)
	  </cfif>
	  
	  <!--- filtro si usa presupuesto  --->
	  <cfif usaPresupuesto  and isdefined("url.filtro_estado")>
			<cfif url.filtro_estado eq 7 >							<!--- mostrar aprobadas manual pero sin aprobacion presupuestaria --->
				and NAP is null and NRP is null
			<cfelseif url.filtro_estado eq 8 >						<!--- mostrar aprobadas manual con rechazo presupuestario --->
				and NRP is not null
			<cfelse>												<!--- por defecto muestra todo  --->
				and NAP is null
			</cfif>
	  </cfif>
	 
	 
	   <cfif url.filtro_estado eq 1 >			<!---filtro pendiente jefe--->
			and a.Iestadoaprobacion = 1
			and a.Iestado not in(1,2)
			and NAP is null
		<cfelseif url.filtro_estado eq 2>		<!---filtro rechaza jefe--->
			and a.Iestadoaprobacion = 3
			and a.Iestado not in(1,2)
			and NAP is null
		<cfelseif url.filtro_estado eq 3>		<!---filtro aprueba jefe y no rechazadas por el adm--->
			and a.Iestadoaprobacion = 2
			and a.Iestado not in(2)
			and NAP is null
			
		<cfelseif url.filtro_estado eq 4 >		<!---filtro pendiente admin y aprobada por el jefe--->
			and a.Iestadoaprobacion = 2
			and a.Iestado = 0
			and NAP is null
			
		<cfelseif url.filtro_estado eq 5>		<!---filtro rechaza admin y aprobada por el jefe, o sin aprobacin necesaria por el jefe segun parametros RH--->
			and a.Iestadoaprobacion not in (3)
			and NAP is null
		<cfelseif url.filtro_estado eq 6>		<!---filtro aprueba admin y aprobada por el jefe, o sin aprobacin necesaria por el jefe segun parametros RH--->
			and coalesce(a.Iestadoaprobacion,2) = 2	
			and a.Iestado = 1
			and NAP is not null
		
		<cfelseif url.filtro_estado eq 7 >						<!--- mostrar aprobadas manual pero sin aprobacion presupuestaria --->
			and coalesce(a.Iestadoaprobacion,2) = 2	
			and a.Iestado = 1
			and NAP is not  null
			and NRP is null
		<cfelseif url.filtro_estado eq 8 >						<!--- mostrar aprobadas manual con aprobacion presupuestario --->
			and coalesce(a.Iestadoaprobacion,2) = 2	
			and a.Iestado = 1
			and NAP is not null
			and NRP is not  null
		</cfif><!------>
	  
	  ) x
	  
	order by x.CFcodigo, x.Ifecha
</cfquery>	

<!---<cf_dump var="#rsLista#">--->

<cfajaximport tags="cfwindow">

<script language="javascript" type="text/javascript">
	function funcShowEstado(mens,Iid){
		ShowMensaje(Iid,mens);
	}
	function ShowMensaje(Iid,cod){
		ColdFusion.Window.create('Window' + cod + '_' +Iid, 'Mensaje',
        'http://<cfoutput>#session.sitio.host#</cfoutput>/cfmx/rh/nomina/operacion/RegistroIncidenciasProcesoMensaje.cfm?Iid='+Iid + '&cod='+cod,
        {x:100,y:100,height:300,width:400,modal:false,closable:false,
        draggable:true,resizable:true,center:true,initshow:true,
        minheight:200,minwidth:200 })
	}
	
	function RechazarIncidencia(cod,Iid){
		document.formSQL.Accion.value = "BTNRechazar";	
		document.formSQL.Iid.value = Iid;
		document.formSQL.codAccion.value = cod;	
		getJustificacion();
	}
	function AprobarIncidencia(cod,Iid){
		if(confirm("Esta seguro que desea APROBAR la incidencia?")){
			document.formSQL.Accion.value = "BTNAprobar";	
			document.formSQL.Iid.value = Iid;
			document.formSQL.codAccion.value = cod;	
			document.formSQL.submit();
		}
	}
	
	function getJustificacion(){
		ColdFusion.Window.create('Window', 'Mensaje',
		'http://<cfoutput>#session.sitio.host#</cfoutput>/cfmx/rh/nomina/operacion/aprobarIncidenciasProceso-justificacion.cfm',
		{x:100,y:100,height:300,width:400,modal:false,closable:false,
		draggable:true,resizable:true,center:true,initshow:true,
		minheight:200,minwidth:200 })
	}
	
	function CancelarRechazo(){
		document.formSQL.Accion.value = '';	
		document.formSQL.Iid.value = '';
		document.formSQL.codAccion.value = '';	
		document.getElementById("Ijustificacion").value = '';
		document.getElementById("IjustificacionW").value = '';
		ColdFusion.Window.hide('Window');	
	}
	function AceptarRechazo(){
		if(confirm("Esta seguro que desea RECHAZAR la incidencia?")){
			if (document.getElementById("IjustificacionW").value != ''){
				document.getElementById("Ijustificacion").value = document.getElementById("IjustificacionW").value;
				document.getElementById("IjustificacionW").value="";
				document.formSQL.Accion.value = "BTNRechazar";	
				ColdFusion.Window.hide('Window');
				document.formSQL.submit();
			}
			else{
				alert('Ingrese la justificacion');
			}
		}
	}
	
</script>

<cfquery name="rs_combo" datasource="#session.DSN#">
	select distinct x.CIid, x.CIcodigo, x.CIdescripcion
	from(
		select 	distinct b.CIid, b.CIcodigo, b.CIdescripcion
		from  Incidencias a, CIncidentes b
		where a.CIid = b.CIid
		  and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
		  <cfif MENU EQ "AUTO">
			and b.CIautogestion = 1
		  </cfif>
		UNION 
		select 	distinct b.CIid, b.CIcodigo, b.CIdescripcion
		from  HIncidencias a, CIncidentes b
		where a.CIid = b.CIid
		  and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
		  <cfif MENU EQ "AUTO">
			and b.CIautogestion = 1
		  </cfif>
	  )x
	order by x.CIcodigo
</cfquery>

<cfinvoke component="sif.Componentes.Translate"
 method="Translate"
 key="LB_NoSeEncontraronRegistros"
 default="No se encontraron Registros "
 returnvariable="LB_NoSeEncontraronRegistros"/> 
	
<cfset navegacion = '' >
<!--- filtro fecha --->
<cfif isdefined("url.filtro_fechaI") and len(trim(url.filtro_fechaI))>
	<cfset navegacion = navegacion & '&filtro_fechaI=#url.filtro_fechaI#' >
</cfif>
<cfif isdefined("url.filtro_fechaF") and len(trim(url.filtro_fechaF))>
	<cfset navegacion = navegacion & '&filtro_fechaF=#url.filtro_fechaF#' >
</cfif>

<!--- filtro concepto --->
<cfif isdefined("url.filtro_CIid") and len(trim(url.filtro_CIid))>
	<cfset navegacion = navegacion & '&filtro_CIid=#url.filtro_CIid#' >
</cfif>

<!--- filtro empleado --->
<cfif isdefined("url.DEid") and len(trim(url.DEid))>
	<cfset navegacion = navegacion & '&DEid=#url.DEid#' >
</cfif>

<!--- filtro centro funcional  --->
<cfif isdefined("url.CFpk") and len(trim(url.CFpk))>
	<cfset navegacion = navegacion & '&CFpk=#url.CFpk#' >
</cfif>
<!--- filtro centro funcional  --->
<cfif isdefined("url.dependencias") and len(trim(url.dependencias))>
	<cfset navegacion = navegacion & '&dependencias=#url.dependencias#' >
</cfif>

<!--- filtro de estado --->	
<cfif isdefined("url.filtro_estado")>
	<cfset navegacion = navegacion & '&filtro_estado=#url.filtro_estado#' >
</cfif>

<cfset valor_fechaI = '' >
<cfif isdefined("url.filtro_fechaI") and len(trim(url.filtro_fechaI))>
	<cfset valor_fechaI = url.filtro_fechaI >
</cfif>

<cfset valor_fechaF = '' >
<cfif isdefined("url.filtro_fechaF") and len(trim(url.filtro_fechaF))>
	<cfset valor_fechaF = url.filtro_fechaF >
</cfif>

<form name="filtro" method="get" action="RegistroIncidenciasProceso.cfm">
	<cfoutput>
	<input name="ConsultaExterna" type="hidden" value="1"/>
	<table width="100%" cellpadding="2" cellspacing="0" class="areaFiltro" border="0">
		<tr>
			<td>#vCentro#:</td>
			<td>
			<cfif isdefined("rs_centro")>
				<cf_rhcfuncional id="CFpk" form="filtro" query="#rs_centro#" contables="1">
			<cfelse>
				<cf_rhcfuncional id="CFpk" form="filtro" contables="1">
			</cfif>
			</td>
			<td>
				<table cellpadding="2" cellspacing="2" border="0"><tr><td>
				#vFechaI#:</td>
				<td>
				<cf_sifcalendario form="filtro" name="filtro_fechaI" value="#valor_fechaI#">
				</td></tr></table>
			</td>
			<!---<td colspan="2" style="visibility:hidden"><!---se pone hidden es probable que lo vallan a utilizar mas adelante--->
				<table><tr><td width="1%"><input type="checkbox" name="dependencias" id="dependencias" <cfif isdefined("url.dependencias")>checked</cfif> /></td><td><label for="dependencias">#vDependencias#</label></td></tr></table>
			</td>	--->		
		</tr>
		<tr>
			
			<td>#vConcepto#:</td>
			<td>
				<select name="filtro_CIid">
					<option value="">-#LB_todos#-</option>
					<cfloop query="rs_combo">
						<option value="#rs_combo.CIid#" <cfif isdefined("url.filtro_CIid") and url.filtro_CIid eq rs_combo.CIid >selected</cfif>>#trim(rs_combo.CIcodigo)# - #rs_combo.CIdescripcion#</option>
					</cfloop>
				</select>
			</td>
			<td>
				<table cellpadding="2" cellspacing="2"><tr><td>
				#vFechaF#:</td>
				<td><cf_sifcalendario form="filtro" name="filtro_fechaF" value="#valor_fechaF#">
				</td></tr></table>
			</td>
		</tr>
		<tr>
			<td>#vEmpleado#:</td>
			<td>
			<cfif isdefined("url.DEid") and len(trim(url.DEid))>
				<cfif menu EQ 'AUTO'>
					<cf_rhempleado form="filtro" showTipoId="false" idempleado="#url.DEid#" JefeDEid="#UserDEid#">
				<cfelse>
					<cf_rhempleado form="filtro" showTipoId="false" idempleado="#url.DEid#">
				</cfif>
			<cfelse>
				<cfif menu EQ 'AUTO'>
					<cf_rhempleado form="filtro" showTipoId="false" JefeDEid="#UserDEid#">
				<cfelse>
					<cf_rhempleado form="filtro" showTipoId="false">
				</cfif>
			</cfif>
			</td>
				<td>
					<table width="100%" border="0" cellpadding="0" cellspacing="0">
						<tr>
							  <cfif aprobarIncidencias and  not aprobarIncidenciasJefe>
								<td>#LB_estado#:</td>
								<td width="1%">
								  <select name="filtro_estado">
									<option value="" <cfif isdefined("url.filtro_estado") and len(trim(url.filtro_estado)) is 0 >selected</cfif>>-#LB_todos#-</option>
									<option value="4" <cfif isdefined("url.filtro_estado") and url.filtro_estado eq 4 >selected</cfif>>#LB_sinaprobar#</option>
									<cfif not usaPresupuesto >
										<option value="6" <cfif isdefined("url.filtro_estado") and url.filtro_estado eq 6 >selected</cfif>>#LB_aprobadas#</option>
									</cfif>
									<option value="5" <cfif isdefined("url.filtro_estado") and url.filtro_estado eq 5 >selected</cfif>>#LB_rechazadas#</option>
									<cfif usaPresupuesto >
									<option value="7" <cfif isdefined("url.filtro_estado") and url.filtro_estado eq 7 >selected</cfif>>#LB_aprobadassinnap#</option>
									<option value="8" <cfif isdefined("url.filtro_estado") and url.filtro_estado eq 8 >selected</cfif>>#LB_aprobadasconnrp#</option>
									</cfif>
								</select>
								</td>
							<cfelseif aprobarIncidencias and aprobarIncidenciasJefe>
								<td>#LB_estado#:</td>
								<td width="1%">
								<select name="filtro_estado">
									<option value="" <cfif isdefined("url.filtro_estado") and len(trim(url.filtro_estado)) is 0 >selected</cfif>>-#LB_todos#-</option>
									<cfif ListFindNocase(filtro_estadoList,1,',')><option value="1" <cfif isdefined("url.filtro_estado") and url.filtro_estado eq 1 >selected</cfif>>#LB_sin_aprobar_jefe#</option></cfif>
									<cfif ListFindNocase(filtro_estadoList,2,',')><option value="2" <cfif isdefined("url.filtro_estado") and url.filtro_estado eq 2 >selected</cfif>>#LB_Rechazadas_Jefe#</option></cfif>
									<cfif ListFindNocase(filtro_estadoList,3,',')><option value="3" <cfif isdefined("url.filtro_estado") and url.filtro_estado eq 3 >selected</cfif>>#LB_Aprobadas_Jefe#</option></cfif>
									<cfif ListFindNocase(filtro_estadoList,4,',')><option value="4" <cfif isdefined("url.filtro_estado") and url.filtro_estado eq 4 >selected</cfif>>#LB_Sin_Aprobar_Admin#</option></cfif>
									<cfif ListFindNocase(filtro_estadoList,5,',')><option value="5" <cfif isdefined("url.filtro_estado") and url.filtro_estado eq 5 >selected</cfif>>#LB_Rechazadas_Admin#</option></cfif>
									<cfif not usaPresupuesto >
										<cfif ListFindNocase(filtro_estadoList,6,',')><option value="6" <cfif isdefined("url.filtro_estado") and url.filtro_estado eq 6 >selected</cfif>>#LB_Aprobadas_Admin#</option></cfif>
									</cfif>
									
									<cfif usaPresupuesto >
										<option value="7" <cfif isdefined("url.filtro_estado") and url.filtro_estado eq 3 >selected</cfif>>#LB_aprobadasAdmSinnap#</option>
										<option value="8" <cfif isdefined("url.filtro_estado") and url.filtro_estado eq 4 >selected</cfif>>#LB_aprobadasAdmConnrp#</option>
									</cfif>
								</select>	
								</td>		  
							</cfif>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
						</tr>
					</table>
				</td>
				<td align="center"><input type="submit" class="btnFiltrar" name="btnFiltrar" value="Filtrar" /></td>
		
		</tr>		
	</table></cfoutput>
</form>
<form name="form1" method="get" action="">
	
	<table width="100%" cellpadding="1" cellspacing="0">
		<tr>
			<td>
			<cfset maxrows = 25 >
			<cfinvoke component="rh.Componentes.pListas"
			 method="pListaQuery"
			 returnvariable="pListaRet">
				<cfinvokeargument name="query" value="#rsLista#"/>
				<cfif usaPresupuesto >
					<cfinvokeargument name="desplegar" value="NombreEmp,CIdescripcion,Ifecha,CItipo,Ivalor,espacio,Imonto,estadoJefe,estado,rechazar,estadoPres,pagada"/>
					<cfinvokeargument name="etiquetas" value="#vEmpleado#, #vConcepto#,#vFecha#,#vTipo#,#vValor#,&nbsp;,#vMonto#,#vestadoJefe#,#vestadoAdmin#,#vrechazar#,#vPres#,#LB_Pagada#"/>
					<cfinvokeargument name="formatos" value="V,V,D,V,M,V,M,V,V,V,S,S"/>
					<cfinvokeargument name="align" value="left,left,center,left,right,center,right,center,center,center,center,center"/>
				<cfelse>
					<cfinvokeargument name="desplegar" value="NombreEmp,CIdescripcion,Ifecha, CItipo,Ivalor,espacio,Imonto,estadoJefe, estado,rechazar,pagada"/>
					<cfinvokeargument name="etiquetas" value="#vEmpleado#, #vConcepto#,#vFecha#, #vTipo#,#vValor#,&nbsp;,#vMonto#,#vestadoJefe#,#vestadoAdmin#,#vrechazar#,#LB_Pagada#"/>
					<cfinvokeargument name="formatos" value="V,V,D,V,M,V,M,V,V,S,S"/>
					<cfinvokeargument name="align" value="left,left,center,left,right,center,right,center,center,center,center"/>
				</cfif>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="showlink" value="False"/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<cfinvokeargument name="EmptyListMsg" value="#LB_NoSeEncontraronRegistros#"/>
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
				<cfinvokeargument name="maxRows" value="#maxrows#"/>
				<cfinvokeargument name="checkboxes" value="N"/>
				<cfinvokeargument name="form_method" value="get"/>
				<cfinvokeargument name="formname" value="form1"/>
				<cfinvokeargument name="incluyeform" value="false"/>
				<cfinvokeargument name="keys" value="Iid"/>
				<cfinvokeargument name="cortes" value="centro"/>
			</cfinvoke>
				
			</td>
		</tr>	
	</table>


<!--- filtro fecha --->
<cfoutput>
<cfif isdefined("url.filtro_fechaI") and len(trim(url.filtro_fechaI))>
	<input type="hidden" name="filtro_fechaI" value="#url.filtro_fechaI#" />
</cfif>
<cfif isdefined("url.filtro_fechaF") and len(trim(url.filtro_fechaF))>
	<input type="hidden" name="filtro_fechaF" value="#url.filtro_fechaF#" />
</cfif>

<!--- filtro concepto --->
<cfif isdefined("url.filtro_CIid") and len(trim(url.filtro_CIid))>
	<input type="hidden" name="filtro_CIid" value="#url.filtro_CIid#" />
</cfif>

<!--- filtro empleado --->
<cfif isdefined("url.DEid") and len(trim(url.DEid))>
	<input type="hidden" name="DEid" value="#url.DEid#" />
</cfif>
<!--- filtro empleado --->
<cfif isdefined("url.CFpk") and len(trim(url.CFpk))>
	<input type="hidden" name="CFpk" value="#url.CFpk#" />
</cfif>
<!--- filtro empleado --->
<cfif isdefined("url.dependencias") and len(trim(url.dependencias))>
	<input type="hidden" name="dependencias" value="#url.dependencias#" />
</cfif>
<!--- filtro de estado --->	
<cfif isdefined("url.filtro_estado")>
	<input type="hidden" name="filtro_estado" value="#url.filtro_estado#" />
</cfif>

<input type="hidden" name="pageNum_lista" value="<cfif isdefined('url.pageNum_lista')>#url.pageNum_lista#<cfelse>1</cfif>" />

<cfset valor_fechaI = '' >
<cfif isdefined("url.filtro_fechaI") and len(trim(url.filtro_fechaI))>
	<cfset valor_fechaI = url.filtro_fechaI >
</cfif>
<cfset valor_fechaF = '' >
<cfif isdefined("url.filtro_fechaF") and len(trim(url.filtro_fechaF))>
	<cfset valor_fechaF = url.filtro_fechaF >
</cfif>

</cfoutput>

</form>
<cfoutput>
<form name="formSQL" action="RegistroIncidenciasProceso-sql.cfm" method="get">
	<input name="Iid" id="Iid" type="hidden" value="" />
	<input name="Accion" id="Accion" type="hidden" value=""/>
	<input name="codAccion" id="codAccion" type="hidden" value=""/>
	<input name="Ijustificacion" id="Ijustificacion" type="hidden" value=""/>
	
	<!--- filtro fecha --->
	<cfif isdefined("url.filtro_fechaI") and len(trim(url.filtro_fechaI))>
		<input type="hidden" name="filtro_fechaI" value="#url.filtro_fechaI#" />
	</cfif>
	<cfif isdefined("url.filtro_fechaF") and len(trim(url.filtro_fechaF))>
		<input type="hidden" name="filtro_fechaF" value="#url.filtro_fechaF#" />
	</cfif>
	
	<!--- filtro concepto --->
	<cfif isdefined("url.filtro_CIid") and len(trim(url.filtro_CIid))>
		<input type="hidden" name="filtro_CIid" value="#url.filtro_CIid#" />
	</cfif>
	
	<!--- filtro empleado --->
	<cfif isdefined("url.DEid") and len(trim(url.DEid))>
		<input type="hidden" name="DEid" value="#url.DEid#" />
	</cfif>
	<!--- filtro empleado --->
	<cfif isdefined("url.CFpk") and len(trim(url.CFpk))>
		<input type="hidden" name="CFpk" value="#url.CFpk#" />
	</cfif>
	<!--- filtro empleado --->
	<cfif isdefined("url.dependencias") and len(trim(url.dependencias))>
		<input type="hidden" name="dependencias" value="#url.dependencias#" />
	</cfif>
	<!--- filtro de estado --->	
	<cfif isdefined("url.filtro_estado")>
		<input type="hidden" name="filtro_estado" value="#url.filtro_estado#" />
	</cfif>
	<input type="hidden" name="pageNum_lista" value="<cfif isdefined('url.pageNum_lista')>#url.pageNum_lista#<cfelse>1</cfif>" />	
</form>
</cfoutput>