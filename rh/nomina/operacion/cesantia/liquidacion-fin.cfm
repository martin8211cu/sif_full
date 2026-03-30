
<cfinvoke component="sif.Componentes.TranslateDB"
method="Translate"
VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
Default="Adelanto de Cesant&iacute;a"
VSgrupo="103"
returnvariable="proceso"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Aplicar_seleccionados"
	Default="Aplicar seleccionados"	
	xmlfile="/rh/nomina/operacion/cesantia/liquidacion.xml"
	returnvariable="vAplicarSel"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Aplicar_todos"
	Default="Aplicar todos"	
	xmlfile="/rh/nomina/operacion/cesantia/liquidacion.xml"
	returnvariable="vAplicarTodos"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Descripcion_proceso"
	xmlfile="/rh/nomina/operacion/cesantia/liquidacion.xml"	
	Default="Este proceso va a calcular el pago que debe hacerse al empleado sobre el monto acumulado por cesant&iacute;a y sus inter&eacute;ses. El c&aacute;lculo se realiza para los empleados que cumplen cinco a&ntilde;os de antiguedad en la empresa, ya sea desde su ingreso o desde la &uacute;ltima vez que se liquidaron sus beneficios por cesant&iacute;a."	
	returnvariable="vDescripcionProceso"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Identificacion"
	Default="Identificaci&oacute;n"	
	xmlfile="/rh/generales.xml"
	returnvariable="vIdentificacion"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Nombre"
	Default="Nombre"	
	xmlfile="/rh/generales.xml"
	returnvariable="vnombre"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Cesantia"
	Default="Cesantia"	
	returnvariable="vCesantia"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Intereses"
	Default="Inter&eacute;ses"	
	returnvariable="vIntereses"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Total"
	Default="Total"	
	xmlfile="/rh/generales.xml"
	returnvariable="vTotal"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Filtrar"
	Default="Filtrar"	
	xmlfile="/rh/generales.xml"
	returnvariable="LB_Filtrar"/>	

<cf_dbfunction name="concat" args="de.DEapellido1,' ',de.DEapellido2,' ',de.DEnombre" returnvariable="_nombre_select" >
<cfquery name="data" datasource="#session.DSN#">
	select 	cl.DEid, 
			de.DEidentificacion, 
			#preservesinglequotes(_nombre_select)# as nombre,  
			sum(cl.RHCLBmontocesantia) as cesantia, 
			sum(cl.RHCLBmontointeres) as intereses, 
			sum(cl.RHCLBmontocesantia)+sum(cl.RHCLBmontointeres) as total
	from RHCesantiaLiqBitacora cl
	
	inner join DatosEmpleado de
	on de.DEid=cl.DEid
	and de.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	
	<!---
	<cfif isdefined("form.f_identificacion") and len(trim(form.f_identificacion)) >
		and upper(de.DEidentificacion) like '%#ucase(form.f_identificacion)#%'
	</cfif>
	<cfif isdefined("form.f_nombre") and len(trim(form.f_nombre)) >
		and ( upper(de.DEnombre) like '%#ucase(form.f_nombre)#%' or upper(de.DEapellido1) like '%#ucase(form.f_nombre)#%' or upper(de.DEapellido2) like '%#ucase(form.f_nombre)#%' )
	</cfif>
	--->
	
	where cl.RHCLBfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
	<cfif isdefined("url.lote") and len(trim(url.lote))>
		and cl.RHCLBlote = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.lote#">
	</cfif>
	
	group by cl.DEid, de.DEidentificacion, #preservesinglequotes(_nombre_select)#
</cfquery>

<cf_templateheader title="#proceso#">
	<cf_web_portlet_start titulo="#proceso#">
		<cfoutput>
 		<table style="vertical-align:top" width="100%" border="0" align="center" cellpadding="4" cellspacing="4">
			<tr><td><strong>Se realiz&oacute; exitosamente el Adelanto de Cesant&iacute;a para los siguientes empleados:</strong></td></tr>

			<tr>
				<td valign="top" align="center">
					<cfinvoke component="rh.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet">
						<cfinvokeargument name="query" value="#data#"/>
						<cfinvokeargument name="desplegar" value="DEidentificacion,Nombre,cesantia,intereses,total"/>
						<cfinvokeargument name="etiquetas" value="#videntificacion#,#vNombre#,#vcesantia#,#vintereses#,#vtotal#"/>
						<cfinvokeargument name="formatos" value="S,S,M,M,M"/>
						<cfinvokeargument name="align" value="left,left,right,right,right"/>
						<cfinvokeargument name="ajustar" value="N"/>
						<cfinvokeargument name="keys" value="DEid"/>
						<cfinvokeargument name="MaxRows" value="0"/>
						<cfinvokeargument name="formName" value="form1"/>
						<cfinvokeargument name="showlink" value="false"/>
						<cfinvokeargument name="debug" value="N"/>
					</cfinvoke>
				</td>
			</tr>
			<tr><td align="center"></td></tr>
		</table>
		</cfoutput>	
	<cf_web_portlet_end>
	
<cf_templatefooter>
