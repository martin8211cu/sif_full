<!--- 
	Modificado por: Ana Villaviencio
	Fecha: 13 de febrero del 2006
	Motivo: corregir error cuando el empleado no tiene registro dentro de la tabla de EVacacionesEmpleado, se hace la consulta
			para la insercion del registro de vacaciones y el registro en Bregimen.
			Se corrigió para q mantuviera los filtros.
 --->

<cfinvoke component="sif.Componentes.TranslateDB"
method="Translate"
VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
Default="Cambio de Fecha de Anualidad de Vacaciones"
VSgrupo="103"
returnvariable="nombre_proceso"/>

	<!--- Identificacion --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Identificacion"
		Default="Identificaci&oacute;n"
		XmlFile="/rh/generales.xml"
		returnvariable="vIdentificacion"/>		

	<!--- Nombre --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Nombre"
		Default="Nombre"
		XmlFile="/rh/generales.xml"
		returnvariable="vNombre"/>		
		
	<!--- Fecha Anualidad --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Fecha_de_Anualidad"
		Default="Fecha de Anualidad"
		returnvariable="vFechaAnualidad"/>		
		
	<!--- Fecha Anualidad --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Fecha_de_Vacaciones"
		Default="Fecha de Vacaciones"
		returnvariable="vFechaVacaciones"/>		

	<!--- Desea modificar --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_Desea_modificar_la_fecha_de_anualidad_y_de_vacaciones"
		Default="Desea modificar la fecha de anualidad y de vacaciones"
		returnvariable="vMensaje"/>		

	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_RecursosHumanos"
		Default="Recursos Humanos"
		XmlFile="/rh/generales.xml"
		returnvariable="LB_RecursosHumanos"/>
	<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">

 	<cf_web_portlet_start titulo="#nombre_proceso#" >
		<cfinclude template="/rh/portlets/pNavegacion.cfm">
		<table width="100%" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td>
					<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL--->		
					<cfif isdefined("url.Pagina") and len(trim(url.Pagina))>
						<cfset form.Pagina = url.Pagina>
					</cfif>		
					<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
					<cfif isdefined("url.PageNum_Lista") and len(trim(url.PageNum_Lista))>
						<cfset form.Pagina = url.PageNum_Lista>
					</cfif>					
					<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA LISTA--->
					<cfif isdefined("form.PageNum") and len(trim(form.PageNum))>
						<cfset form.Pagina2 = form.PageNum>
					</cfif>
					<cfif isdefined('form.DEid') and LEN(TRIM(form.DEid))>
						<cfinclude template="CambioFAnualidad-form.cfm">
					<cfelse>
					
					
					<cfset filtro = '' >
					<cfif isdefined("form.hfiltro_Empleado") and len(trim(form.hfiltro_Empleado))>
						<cfset filtro = filtro & " and upper(de.DEapellido1) like '%#ucase(trim(form.hfiltro_Empleado))#%' " >
						<cfset filtro = filtro & " or upper(de.DEapellido2) like '%#ucase(trim(form.hfiltro_Empleado))#%' " >
					</cfif>
					
					
					<form name="form1" action="listaEstadosCuentaEnProceso.cfm" method="post">
						<input name="Pagina" type="hidden" value="<cfif isdefined('form.Pagina')><cfoutput>#form.Pagina#</cfoutput></cfif>">
						<cfset vArray = arraynew(1)>
						<cfset varray[1] = 'de.DEidentificacion'>
						<cf_dbfunction name="concat" args="de.DEnombre,' ',de.DEapellido1,' ',de.DEapellido2" returnvariable="nombre" >
						<cfset varray[2] = "#nombre#"> 
						<!---
						<cfset varray[2] = 'de.DEnombre'>
						<cfset varray[3] = 'de.DEapellido1'>
						<cfset varray[4] = 'de.DEapellido2'>
						---->
						
						<cfinvoke 
								 component="rh.Componentes.pListas"
								 method="pListaRH"
								 returnvariable="pListaRet">
							<cfinvokeargument name="columnas"  			value="de.DEid, de.DEidentificacion, #preservesinglequotes(nombre)# as Empleado"/>
							<cfinvokeargument name="tabla"  			value="DatosEmpleado de, LineaTiempo lt"/>
							<cfinvokeargument name="filtro"  			value="de.Ecodigo = #Session.Ecodigo#
																				  and de.Ecodigo = lt.Ecodigo
																				  and de.DEid = lt.DEid
																				  and getdate() between lt.LTdesde and lt.LThasta
																				order by de.DEidentificacion"/>
							<cfinvokeargument name="desplegar"  		value="DEidentificacion, Empleado"/>
							<cfinvokeargument name="filtrar_por_array"  value="#vArray#"/>
							<cfinvokeargument name="etiquetas"  		value="#vIdentificacion#, #vNombre#"/>
							<cfinvokeargument name="formatos"   		value="S,S"/>
							<cfinvokeargument name="align"      		value="left,left"/>
							<cfinvokeargument name="ajustar"    		value="N"/>
							<cfinvokeargument name="irA"        		value="CambioFAnualidad.cfm"/>
							<cfinvokeargument name="showLink" 			value="true"/>
							<cfinvokeargument name="showEmptyListMsg" 	value="true"/>
							<cfinvokeargument name="maxrows" 			value="15"/>
							<cfinvokeargument name="keys"             	value="DEid"/>
							<cfinvokeargument name="mostrar_filtro"		value="true"/>
							<cfinvokeargument name="filtrar_automatico"	value="true"/>
							<cfinvokeargument name="formname"			value="form1"/>
							<cfinvokeargument name="incluyeform"		value="false"/>
						</cfinvoke>
					</form>
					</cfif>
				</td>
			</tr>
		</table>
  <cf_web_portlet_end>
<cf_templatefooter>