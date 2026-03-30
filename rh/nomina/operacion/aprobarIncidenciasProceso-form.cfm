<!------>
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
	<cfinvokeargument name="incluirJefesCFhijos" value="1"/>
	<cfinvokeargument name="incluirEmpleadosCFhijos" value="1"/>
	<cfinvokeargument name="incluirDEid" value="0"/>
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

<cfset aprobarIncidencias = false >
<cfif reqAprobacion eq 1 >
	<cfset aprobarIncidencias = true >
</cfif>

<cfset aprobarIncidenciasCalc = false >
<cfif reqAprobacionCalculo eq 1 >
	<cfset aprobarIncidenciasCalc = true >
</cfif>	

<!---**********************FILTROS PARA EL QUERY DE LA LISTA************************************************--->
<cfif rol EQ 2>											<!---NOMINA--->
	
	<cfif reqAprobacion EQ 1>
		<cfset I_ingresadopor = '0,1,2'>				<!---Ingresado por jefe o usuario--->		
		<cfset I_estado = 0>							<!---pendiente de aprobar por el Admin--->		
		<cfset I_estadoAprobacion = 2>					<!---aprobado por el jefe--->	
	<cfelse>
		<cfset I_ingresadopor = -1>						<!---No requiere aprobacion del Admin segun la parametrizacion--->	
		<cfset I_estado = -1>							
		<cfset I_estadoAprobacion = -1>					
	</cfif>

<cfelse>												<!---AUTOGESTION--->
	<cfif reqAprobacion EQ 1>
		<cfif reqAprobacionJefe EQ 1>
			
			<cfif rol EQ 1> 							<!---JEFE--->
				
				<cfset I_ingresadopor = '0,1'>			<!---Puede aprobar incidencias para subalternos(estos pueden resultar ser jefes), si es su propio jefe las incidencias se autoaprueban al ingresarlas, las incidencias del usuario por aprobar no aparecen en esta pantalla.--->		
				<cfset I_estado = 0>					<!---Requiere aprobacion del Administrador--->
				<cfset I_estadoAprobacion = 1>			<!---Requiere aprobacion del JEFE--->
				
			<cfelse>									<!---USUARIO--->
				<cfset I_ingresadopor = -1>				<!---El usuario desde Autogestion no aprueba --->	
				<cfset I_estado = -1>							
				<cfset I_estadoAprobacion = -1>	
			</cfif>
		
		<cfelse>
			<cfset I_ingresadopor = -1>					<!---No requiere aprobacion del JEFE segun la parametrizacion--->	
			<cfset I_estado = -1>							
			<cfset I_estadoAprobacion = -1>	
		</cfif>
	<cfelse>
		<cfset I_ingresadopor = -1>						<!---No requiere aprobacion del ADMIN segun la parametrizacion--->	
		<cfset I_estado = -1>							
		<cfset I_estadoAprobacion = -1>	
	</cfif>
</cfif>
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
		default="Concepto"
		xmlfile="/rh/generales.xml"
		returnvariable="vConcepto"/>		
	<!--- Fecha --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Fecha"
		default="Fecha"
		xmlfile="/rh/generales.xml"
		returnvariable="vFecha"/>		
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Mes"
		default="Mes"
		xmlfile="/rh/generales.xml"
		returnvariable="LB_Mes"/>
			
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
	<!--- Monto Calculado --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_MontoCalculado"
		default="Monto Calculado*"
		xmlfile="/rh/generales.xml"		
		returnvariable="vMontoCalculado"/>	
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
		key="LB_Sin_Aprobar"
		default="Sin aprobar"
		returnvariable="LB_sinaprobar"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Rechazadas"
		default="Rechazadas"
		returnvariable="LB_rechazadas"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Aprobadas"
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
		key="LB_Presupuesto"
		default="Presupuesto"
		returnvariable="vpres"/>	
		
	<!---Etiqueta Monto Calculado--->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_NotaMontoCalculado"
		default=" Unicamente para  Incidencias tipo C&aacute;lculo. Representa el monto calculado de la incidencia"
		xmlfile="/rh/generales.xml"
		returnvariable="LB_NotaMontoCalculado"/>		
		
<!--- ============================================= --->
<!--- ============================================= --->
<!--- por defecto se muestran los registros no aplicados, aplicados sin nap y aplicados con NRP --->
<cfparam name="url.filtro_estado" default="0">
<cfif isdefined("url.CFpk") and len(trim(url.CFpk)) >
	<cfquery name="rs_centro" datasource="#session.DSN#" >
		select CFid as CFpk, CFcodigo, CFdescripcion, CFpath
		from CFuncional
		where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFpk#">
	</cfquery>
	<cfset vpath = rs_centro.CFpath >
</cfif>

<cfset usaPresupuesto = false >
<cfquery name="rs_pres" datasource="#session.DSN#">
	select Pvalor
	from RHParametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and Pcodigo = 540
</cfquery>
<cfif trim(rs_pres.Pvalor) eq 1 >
	<cfset usaPresupuesto = true >
</cfif>

<cfset aprobarIncidencias = false >
<cfquery name="rs_aprueba" datasource="#session.DSN#">
	select Pvalor
	from RHParametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and Pcodigo = 1010
</cfquery>
<cfif trim(rs_aprueba.Pvalor) eq 1 >
	<cfset aprobarIncidencias = true >
</cfif>

<cfset aprobarIncidenciasCalc = false >
<cfquery name="rs_apruebacalc" datasource="#session.DSN#">
	select Pvalor
	from RHParametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and Pcodigo = 1060
</cfquery>
<cfif trim(rs_apruebacalc.Pvalor) eq 1 >
	<cfset aprobarIncidenciasCalc = true >
</cfif>

<cfset anno = DatePart("yyyy", now())>
<cfset mes  = DatePart("m", now())>

<cf_dbfunction name="to_char" args="a.Iid" returnvariable="vIid">
<cfquery name="rsLista" datasource="#Session.DSN#">
	select 	a.Iid, 
			<cf_dbfunction name="concat" args="b.CIcodigo,' -  ',b.CIdescripcion"> as CIdescripcion, 
			a.Ifecha, 
			case b.CItipo  	when 3 then <cf_dbfunction name="to_char" args="Imonto"> 
			else ''  end as Imonto,
			case b.CItipo  	when 0 then ' Hora(s)' 
							when 1 then ' Da(s)' 
							when 2 then ' Importe' 
							when 3 then ' C&aacute;lculo' 
							end as CItipo,
			a.Ivalor,
			<cf_dbfunction name="concat" args="c.DEidentificacion, ' - ',c.DEnombre,' ',c.DEapellido1,' ',c.DEapellido2"> as NombreEmp,
			<cf_dbfunction name="concat" args="cf.CFcodigo,' -  ',cf.CFdescripcion"> as centro, cf.CFcodigo, cf.CFdescripcion,
			
			case when Iestado = 2 then '<img src=/cfmx/rh/imagenes/Borrar01_12x12.gif />' 
				 when Iestado = 1 and NAP is not null then '<img src=/cfmx/rh/imagenes/w-check.gif />' 
				 else '<img src=/cfmx/rh/imagenes/sinchequear_verde.gif />'  end as estado,
				 
			case when NRP is not null then '<img src=/cfmx/rh/imagenes/Borrar01_12x12.gif />' 
				 when NAP is not null then '<img src=/cfmx/rh/imagenes/w-check.gif />' 
				 else '<img src=/cfmx/rh/imagenes/sinchequear_verde.gif />'  end as estadoPres,
				 Iestado,
			
			<cf_dbfunction name="concat" args="'<img src=/cfmx/rh/imagenes/edit_o.gif   onclick=CambiarCF(' | #vIid# |') style=cursor:pointer />'" delimiters="|"> as CambiaCF
			
			, Iespecial as Icpespecial
		
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
	  
	  <!--- filtrar por centro funcional --->
		<cfif isdefined("url.CFpk") and len(trim(url.CFpk)) >
	  		and ( cf.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFpk#">
		    	<!---<cfif isdefined("url.dependencias") and len(trim(url.dependencias))>
			    	or cf.CFpath like '#vpath#/%' 	
		    	</cfif>--->
		  	)
		</cfif>		    
	  
	  <!--- filtro fecha --->
	  <cfif isdefined("url.filtro_fecha") and len(trim(url.filtro_fecha))>
		and a.Ifecha = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.filtro_fecha)#">
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
			  <!---<cfif isdefined("url.dependencias")> or cf.CFpath like '#trim(vpath)#%' </cfif>--->)
	  </cfif>
	  
	  <!--- si empresa no requiere qu es eaprueben incidencias, esta lista no debe mostrar nada--->
	  <cfif not aprobarIncidencias and not aprobarIncidenciasCalc>
	  	and 1=2
	  </cfif>
	  
	  <!--- proceso de aprobacion--->
	  and a.Iestadoaprobacion in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#I_estadoAprobacion#" list="yes">)
	  and a.Iingresadopor in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#I_ingresadopor#" list="yes">)
	  and a.Iestado = <cfqueryparam cfsqltype="cf_sql_numeric" value="#I_estado#">
	  
	  <!---Si esta en Autogestion (y es jefe) filtra por sus subAlternos--->
	  <cfif Menu EQ 'AUTO' and len(trim(rsSubalternos.DEid))>
			and a.DEid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#valueList(rsSubalternos.DEid)#" list="yes">)
	  </cfif>
	  
	order by cf.CFcodigo, a.Ifecha	  

</cfquery>	

<!--- <cfdump var="#rsLista#"> --->
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
<cfif isdefined("url.filtro_fecha") and len(trim(url.filtro_fecha))>
	<cfset navegacion = navegacion & '&filtro_fecha=#url.filtro_fecha#' >
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

<cfset valor_fecha = '' >
<cfif isdefined("url.filtro_fecha") and len(trim(url.filtro_fecha))>
	<cfset valor_fecha = url.filtro_fecha >
</cfif>

<form name="filtro" method="get" action="aprobarIncidenciasProceso.cfm">
	<cfoutput>
	<table width="100%" cellpadding="2" cellspacing="0" class="areaFiltro">
		<tr>
			<td>#vCentro#:</td>
			<td>
			<cfif isdefined("rs_centro")>
				<cf_rhcfuncional id="CFpk" form="filtro" query="#rs_centro#" contables="1">
			<cfelse>
				<cf_rhcfuncional id="CFpk" form="filtro" contables="1">
			</cfif>
			</td>
			<td colspan="2" style="visibility:hidden"><!---se pone hidden es probable que lo vallan a utilizar mas adelante--->
				<table><tr><td width="1%"><input type="checkbox" name="dependencias" id="dependencias" <cfif isdefined("url.dependencias")>checked</cfif> /></td><td><label for="dependencias">#vDependencias#</label></td></tr></table>
			</td>
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
			<td>#vFecha#:</td>
			<td>
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td><cf_sifcalendario form="filtro" name="filtro_fecha" value="#valor_fecha#"></td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td align="center"><input type="submit" class="btnFiltrar" name="btnFiltrar" value="Filtrar" /></td>
					</tr>
				</table>
			</td>
		</tr>		
	</table>
	<input name="Iid" id="Iid" type="hidden" value=""/>
	</cfoutput>
</form>

<form name="form1" method="get" action="aprobarIncidenciasProceso-sql.cfm" onSubmit="javascript: return validar();">
	 <input name="Ijustificacion" id="Ijustificacion" type="hidden" value=""/>
	<table width="100%" cellpadding="1" cellspacing="0">
		<tr><td>
			<table border="0">
				<tr>
					<td width="1%" >
						<input name="chk_todos" id="chk_todos" type="checkbox" onClick="javascript:todos(this);" />
					</td>
					<td width="40%"><label for="chk_todos"><cf_translate key="LB_Seleccionar_todos_los_reguistros" xmlfile="/rh/generales.xml">Seleccionar todos los registros</cf_translate></label></td>
					<td>&nbsp;</td>
					
				</tr>
			</table>
		</td></tr>
		<tr>
			<td>
				<cfset maxrows = 25 >
				<!---<img src="../../imagenes/edit_o.gif" />--->
				
				<cfif rol EQ 2> 
					<cfset desplegar = "NombreEmp,CIdescripcion,Ifecha,CItipo,Ivalor,Imonto,CambiaCF">
					<cfset etiquetas = "#vEmpleado#,#vConcepto#,#vFecha#, #vTipo#, #vValor#,#vMontoCalculado#,&nbsp;">
					<cfset formatos = "V,V,D,V,M,S,I">
					<cfset align = "left,left,center,left,right,right,center">
				<cfelse>
					<cfset desplegar = "Ifecha, CIdescripcion, NombreEmp, Ivalor,Icpespecial">
					<cfset etiquetas = "#vFecha#, #vConcepto#, #vEmpleado#, #vCantidadMonto#,#vIcpespecial#">
					<cfset formatos = "D,V,V,V,V,V">
					<cfset align = "center, left, left, right,right, center">
				</cfif>
				
				
				<cfinvoke component="rh.Componentes.pListas"
				 method="pListaQuery"
				 returnvariable="pListaRet">
					<cfinvokeargument name="query" value="#rsLista#"/>					
					<cfinvokeargument name="desplegar" value="#desplegar#"/>
					<cfinvokeargument name="etiquetas" value="#etiquetas#"/>
					<cfinvokeargument name="formatos" value="#formatos#"/>
					<cfinvokeargument name="align" value="#align#"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="showlink" value="False"/>
					<cfinvokeargument name="showEmptyListMsg" value="true"/>
					<cfinvokeargument name="EmptyListMsg" value="#LB_NoSeEncontraronRegistros#"/>
					<cfinvokeargument name="navegacion" value="#navegacion#"/>
					<cfinvokeargument name="maxRows" value="#maxrows#"/>
					<cfinvokeargument name="checkboxes" value="S"/>
					<cfinvokeargument name="form_method" value="get"/>
					<cfinvokeargument name="formname" value="form1"/>
					<cfinvokeargument name="incluyeform" value="false"/>
					<cfinvokeargument name="keys" value="Iid"/>
					<cfinvokeargument name="cortes" value="centro"/>
				</cfinvoke>
				
			</td>
		</tr>	
		<tr>
			<td align="center">
				<input type="submit" class="btnAplicar" name="btnAprobar" value="Aprobar" />
				<input type="button" class="btnEliminar" name="btnRech" value="Rechazar" onClick="javascript: getJustificacion()<!---rechazar()--->;"/>
				<input  type="hidden" name="btnRechazar" id="btnRechazar" value="0"/>
			<cfif rol EQ 2> 
				<br><br><div align="left"><cfoutput><b>#vMontoCalculado#</b>: #LB_NotaMontoCalculado#</cfoutput></div>
			</cfif>
			</td>
		</tr>
	</table>


	<!--- filtro fecha --->
	<cfoutput>
	<cfif isdefined("url.filtro_fecha") and len(trim(url.filtro_fecha))>
		<input type="hidden" name="filtro_fecha" value="#url.filtro_fecha#" />
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
	
	<cfset valor_fecha = '' >
	<cfif isdefined("url.filtro_fecha") and len(trim(url.filtro_fecha))>
		<cfset valor_fecha = url.filtro_fecha >
	</cfif>
	</cfoutput>

</form>
 
<cfajaximport tags="cfwindow">
<script language="javascript1.2" type="text/javascript">
	var cont = <cfoutput>#rsLista.recordcount#</cfoutput>;
	<cfoutput>
	if (cont > #maxrows#){
		cont = #maxrows#;
	}
	</cfoutput>
	
	function getJustificacion(){
		if( validarCheks()){
			ColdFusion.Window.create('Window', 'Mensaje',
			'http://<cfoutput>#session.sitio.host#</cfoutput>/cfmx/rh/nomina/operacion/aprobarIncidenciasProceso-justificacion.cfm',
			{x:100,y:100,height:300,width:400,modal:false,closable:false,
			draggable:true,resizable:true,center:true,initshow:true,
			minheight:200,minwidth:200 })
		}
	}
	
	function CancelarRechazo(){
		document.getElementById("Ijustificacion").value = "";
		document.getElementById("IjustificacionW").value = "";
		ColdFusion.Window.hide('Window');	
	}
	function AceptarRechazo(){
		if (document.getElementById("IjustificacionW").value != ''){
			document.getElementById("Ijustificacion").value = document.getElementById("IjustificacionW").value;
			document.getElementById("IjustificacionW").value="";
			document.getElementById("btnRechazar").value =1;
			ColdFusion.Window.hide('Window');
			document.form1.submit();
		}
		else{
			alert('Ingrese la justificacion');
		}
	}
	
	function CambiarCF(Iid){
		var CFpk = document.filtro.CFpk.value;
		var dependencias = document.filtro.dependencias.value;
		var filtro_CIid = document.filtro.filtro_CIid.value;
		var DEid = document.filtro.DEid.value;
		var filtro_fecha = document.filtro.filtro_fecha.value;
		document.location.href='/cfmx/rh/nomina/operacion/aprobarIncidenciasProceso-CF.cfm?Iid='+Iid + '&CFpk='+ CFpk + '&DEid='+ DEid + '&dependencias=' + dependencias + '&filtro_CIid=' + filtro_CIid + '&filtro_fecha=' + filtro_fecha;;
	}
	
	function validarCheks(){
		if ( cont > 0 ){
			if ( cont == 1 ){
				if ( document.form1.chk.checked ){
					return true;
				}
				alert('<cfoutput>#LB_mensaje#</cfoutput>');
				return false;
			}
			else{
				for (i=0; i<cont; i++){
					if ( document.form1.chk[i] ){
						if (document.form1.chk[i].checked){
							return confirm('<cfoutput>#LB_confirm#</cfoutput>');
						}
					}
				}
				alert('<cfoutput>#LB_mensaje#</cfoutput>');
				return false;
			}
		}	

		return false;
	}
	
	function validar(){
		if ( cont > 0 ){
			if ( cont == 1 ){
				if ( document.form1.chk.checked ){
					return confirm('<cfoutput>#LB_confirm#</cfoutput>');
				}
				else {
					alert('<cfoutput>#LB_mensaje#</cfoutput>');
					return false;
				}
			}
			else{
				for (i=0; i<cont; i++){
					if ( document.form1.chk[i] ){
						if (document.form1.chk[i].checked){
							return confirm('<cfoutput>#LB_confirm#</cfoutput>');
						}
					}
				}
				alert('<cfoutput>#LB_mensaje#</cfoutput>');
				return false;
			}
		}	

		return false;
	}

	function todos(obj){
		if (obj.checked){
			if ( cont > 0 ){
				if ( cont == 1 ){
					document.form1.chk.checked = true;
				}
				else{
					for (i=0; i<cont; i++){
						if ( document.form1.chk[i] ){
							document.form1.chk[i].checked = true;
						}	
					}
				}
			}
		}
	}
	
	function no_todos(){
		if ( cont > 0 ){
			if ( cont == 1 ){
				document.form1.chk.onclick = function(){ if(!document.form1.chk.checked){ document.form1.chk_todos.checked = false; }  };
			}
			else{
				for (i=0; i<cont; i++){
					if ( document.form1.chk[i] ){
						document.form1.chk[i].onclick = function(){ if(!this.checked){ document.form1.chk_todos.checked = false; } };
					}
				}
			}
		}
	}
	no_todos();
	
</script>
