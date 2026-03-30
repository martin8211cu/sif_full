<cfinvoke component="sif.Componentes.TranslateDB"
method="Translate"
VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
Default="Adelanto de Cesant&iacute;a"
VSgrupo="103"
returnvariable="proceso"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Regresar"
	Default="Regresar"	
	xmlfile="/rh/generales.xml"
	returnvariable="vRegresar"/>	
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
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_No_se_encontraron_empleados_para_proceso_de_Adelanto_de_Cesantia"
	Default="No se encontraron empleados para proceso de Adelanto de Cesant&iacute;a"	
	xmlfile="/rh/nomina/operacion/cesantia/liquidacion.xml"	
	returnvariable="LB_NoRegistros"/>	

<cf_dbfunction name="concat" args="de.DEapellido1,' ',de.DEapellido2,' ',de.DEnombre" returnvariable="_nombre_select" >
<cfquery name="data" datasource="#session.DSN#">
	select 	cl.DEid, 
			de.DEidentificacion, 
			#preservesinglequotes(_nombre_select)# as nombre,  
			sum(cl.RHCLmontoCesantia) as cesantia, 
			sum(cl.RHCLmontoInteres) as intereses, 
			sum(cl.RHCLmontoCesantia)+sum(cl.RHCLmontoInteres) as total
	from RHCesantiaLiquidacion cl
	
	inner join DatosEmpleado de
	on de.DEid=cl.DEid
	and de.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and cl.RHCLaprobada = 0
	
	<cfif isdefined("form.f_identificacion") and len(trim(form.f_identificacion)) >
		and upper(de.DEidentificacion) like '%#ucase(form.f_identificacion)#%'
	</cfif>
	<cfif isdefined("form.f_nombre") and len(trim(form.f_nombre)) >
		and ( upper(de.DEnombre) like '%#ucase(form.f_nombre)#%' or upper(de.DEapellido1) like '%#ucase(form.f_nombre)#%' or upper(de.DEapellido2) like '%#ucase(form.f_nombre)#%' )
	</cfif>
	
	where cl.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	
	group by cl.DEid, de.DEidentificacion, #preservesinglequotes(_nombre_select)#
</cfquery>

<cf_templateheader title="#proceso#">
	<cf_web_portlet_start titulo="#proceso#">
		<cfoutput>
 		<table style="vertical-align:top" width="100%" border="0" align="center" cellpadding="4" cellspacing="4">
			<tr><td><strong>Listado de empleados que van a recibir el Adelanto de Cesant&iacute;a</strong></td></tr>

				<cfset navegacion = '' >
				<cfset filtro = '' >
				<cfset extra = '' >
				<cfif isdefined("form.f_identificacion") and len(trim(form.f_identificacion)) >
					<cfset filtro = " and upper(de.DEidentificacion) like '%#ucase(form.f_identificacion)#%' " >
					<cfset extra = ", '#form.f_identificacion#' as f_identificacion" >
				</cfif>
				<cfif isdefined("form.f_nombre") and len(trim(form.f_nombre)) >
					<cfset filtro = filtro & " and ( upper(de.DEnombre) like '%#ucase(form.f_nombre)#%' or upper(de.DEapellido1) like '%#ucase(form.f_nombre)#%' or upper(de.DEapellido2) like '%#ucase(form.f_nombre)#%' ) " >
					<cfset extra = extra & ", '#form.f_nombre#' as f_nombre" >								
				</cfif>
			  <cfoutput>
			  <tr>
				<td>
					<form name="filtro" method="post" action="liquidacion-resumen.cfm"  >
					<table width="100%" cellpadding="1" cellspacing="0" class="areaFiltro">
						<tr>
							<td><strong>#vIdentificacion#</strong></td>
							<td><strong>#vNombre#</strong></td>
						</tr>
						<tr>
							<td><input type="text" size="30" maxlength="30" name="f_identificacion" value="<cfif isdefined("form.f_identificacion") and len(trim(form.f_identificacion)) >#form.f_identificacion#</cfif>" ></td>
							<td><input type="text" size="60" maxlength="60" name="f_nombre" value="<cfif isdefined("form.f_nombre") and len(trim(form.f_nombre)) >#form.f_nombre#</cfif>" ></td>
							<td><input type="submit" name="Filtrar" class="btnFiltrar" value="#LB_Filtrar#">
							</td>
						</tr>
						<tr></tr>
					</table>
					</form>
				</td>
			  </tr>
			  </cfoutput>

			<form name="form1" method="post" action="liquidacion-sql.cfm" style="margin:0;"> 
			<input type="hidden" name="btnEliminar" value="0" >

			<cfif data.recordcount gt 0 >
				<tr><td>
					<table cellpadding="2" cellspacing="0">
						<tr>
							<td width="1%" nowrap="nowrap"><a href="javascript: funcTodos();">Seleccionar todos</a> | <a href="javascript: funcNinguno()">Ninguno</a></td>
						</tr>
					</table>
				</td></tr>
			</cfif>
			<tr>
				<td valign="top" align="center">
					<cfif data.Recordcount gt 0 >
						<cfinvoke component="rh.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet">
							<cfinvokeargument name="query" value="#data#"/>
							<cfinvokeargument name="desplegar" value="DEidentificacion,Nombre,cesantia,intereses,total"/>
							<cfinvokeargument name="etiquetas" value="#videntificacion#,#vNombre#,#vcesantia#,#vintereses#,#vtotal#"/>
							<cfinvokeargument name="formatos" value="S,S,M,M,M"/>
							<cfinvokeargument name="align" value="left,left,right,right,right"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="checkboxes" value="S"/>
							<cfinvokeargument name="checkedcol" value="DEid"/>
							<cfinvokeargument name="keys" value="DEid"/>
							<cfinvokeargument name="MaxRows" value="0"/>
							<cfinvokeargument name="formName" value="form1"/>
							<cfinvokeargument name="incluyeform" value="false"/>
							<cfinvokeargument name="showlink" value="false"/>
							<cfinvokeargument name="debug" value="N"/>
						</cfinvoke>
					<cfelse>
						#LB_NoRegistros#
					</cfif>
				</td>
			</tr>
			<tr><td></td></tr>
			<cfif data.Recordcount gt 0 >
				<tr>
					<td align="center">
						<table>
							<tr>
								<td><cf_botones form="form1" values="#vAplicarsel#,#vAplicarTodos#" names="Aprobar,AprobarTodos"></td>
								<td><input type="button" class="btnAnterior" name="btnRegresar" value="Regresar" onclick="javascript:location.href='liquidacion.cfm';" /></td>
							</tr>
						</table>
					</td>
				</tr>
			</cfif>
			</form>
			<cfif data.Recordcount eq 0 >
			<form name="form2" method="get" action="liquidacion.cfm" style="margin:0;">
			<tr>
				<td><cf_botones form="form2" values="#vRegresar#" names="Anterior"></td>
			</tr>
			</form> 
			</cfif>
		</table>

		</cfoutput>	
		
		<script language="javascript1.2" type="text/javascript">
			function funcAprobar(){
				return confirm('Va a ejecutar el proceso de Adelanto de Cesantia unicamente para los empleados seleccionados. Desea continuar?');
			}
			function funcAprobarTodos(){
				return confirm('Va a ejecutar el proceso de Adelanto de Cesantia para todos los empleados. Desea continuar?');
			}
			function agregar(){
				var height = 500;
				var width = 500;
				var top = (screen.height - height) / 2;
				var left = (screen.width - width) / 2;
				window.open('/cfmx/rh/nomina/operacion/cesantia/liquidacion-agregar.cfm','ListaEmpleados','menu=no,scrollbars=yes,top='+top+',left='+left+',width='+width+',height='+height);
			}
			
			function funcTodos(){
				<cfif data.recordcount eq 1 >
					document.form1.chk.checked = true;
				<cfelseif data.recordcount gt 1 >
					procesar_checks(true);
				</cfif>
			}
			function funcNinguno(){
				<cfif data.recordcount eq 1 >
					document.form1.chk.checked = false;				
				<cfelseif data.recordcount gt 1 >
					procesar_checks(false);
				</cfif>
			}
			function procesar_checks(valor){
				for (i=0;i<document.form1.chk.length;i++){
					document.form1.chk[i].checked = valor;
				}
			}
		</script>

	<cf_web_portlet_end>
	
<cf_templatefooter>
