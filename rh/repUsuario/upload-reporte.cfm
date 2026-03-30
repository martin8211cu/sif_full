
<cfinvoke component="sif.Componentes.TranslateDB"
method="Translate"
VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
Default="Subir reporte al servidor"
VSgrupo="103"
returnvariable="LB_nav__SPdescripcion"/>
			
<!---
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Dept"
	Default="Dept."	
	xmlfile="/rh/generales.xml"
	returnvariable="vDept"/>	
--->	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Codigo"
	Default="Código"	
	xmlfile="/rh/generales.xml"
	returnvariable="vCodigo"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Descripcion"
	Default="Descripción"	
	xmlfile="/rh/generales.xml"
	returnvariable="vDescripcion"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Categoria"
	Default="Categoría"
	xmlfile="/rh/generales.xml"
	returnvariable="vCategoria"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Sistema"
	Default="Sistema"
	xmlfile="/rh/generales.xml"
	returnvariable="vSistema"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Archivo"
	Default="Archivo"
	xmlfile="/rh/generales.xml"
	returnvariable="vArchivo"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Empleados"
	Default="Empleados"
	xmlfile="/rh/generales.xml"
	returnvariable="vEmpleados"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Estructura_Organizacional"
	Default="Estructura Organizacional"
	xmlfile="/rh/generales.xml"
	returnvariable="vEstructura"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Nomina"
	Default="N&oacute;mina"
	xmlfile="/rh/generales.xml"
	returnvariable="vNomina"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Parametros"
	Default="Par&aacute;metros"
	xmlfile="/rh/generales.xml"
	returnvariable="vParametros"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_seleccionar"
	Default="seleccionar"
	xmlfile="/rh/generales.xml"
	returnvariable="vseleccionar"/>	

<!---
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Responsable"
	Default="Resp."	
	xmlfile="/rh/repUsuario/upload-reporte.xml"
	returnvariable="vresp"/>	
--->	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_El_proceso_de_poner_el_reporte_en_el_servidor_concluyo_con_exito"
	Default="El proceso de poner el reporte en el servidor concluyo con &eacute;xito"	
	xmlfile="/rh/repUsuario/upload-reporte.xml"
	returnvariable="vok"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Se_presento_un_error_al_subir_el_reporte_al_servidor._Proceso_cancelado"
	Default="Se presento un error al subir el reporte al servidor. Proceso cancelado"	
	xmlfile="/rh/repUsuario/upload-reporte.xml"
	returnvariable="verror"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_No_mostrar_este_mensaje"
	Default="No mostrar este mensaje"
	xmlfile="/rh/repUsuario/upload-reporte.xml"
	returnvariable="veliminar"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Esta seguro de subir el reporte al servidor?"
	Default="Esta seguro de subir el reporte al servidor?"
	xmlfile="/rh/repUsuario/upload-reporte.xml"
	returnvariable="vseguro"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Error._EL_archivo_que_desea_subir_no_tiene_formato_de_reporte_(extension_cfr)._Verifique_sus_datos."
	Default="EL archivo que desea subir no tiene formato de reporte (extension cfr). Verifique sus datos."
	xmlfile="/rh/repUsuario/upload-reporte.xml"
	returnvariable="verror2"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Reporte"
	Default="Reporte"
	xmlfile="/rh/repUsuario/upload-reporte.xml"
	returnvariable="vReporte"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Listado_de_reportes_actualmente_en_el_servidor"
	Default="Listado de reportes actualmente en el servidor"
	xmlfile="/rh/repUsuario/upload-reporte.xml"
	returnvariable="vListadoReportes"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Requiere_parametros_para_ejecucion"
	Default="Requiere par&aacute;metros para ejecuci&oacute;n"
	xmlfile="/rh/repUsuario/upload-reporte.xml"
	returnvariable="vReqParametros"/>	


<cf_templateheader title="#LB_nav__SPdescripcion#">
	<cf_web_portlet_start border="true" titulo="#LB_nav__SPdescripcion#" skin="#Session.Preferences.Skin#">
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
					<table width="100%" cellpadding="0" cellspacing="0">
						<tr>
							<td class="tituloListas"><cfoutput>#vListadoReportes#</cfoutput></td>
						</tr>
						<tr>
							<td>
								<cfinvoke 
									component="rh.Componentes.pListas" 
									method="pListaRH"
									returnvariable="rsLista"
									columnas="RHRURcodigo as codigo, RHRURnombre as archivo, RHRURdescripcion as descripcion, RHRURsistema as sistema, RHRURcategoria as categoria"
									etiquetas="#vReporte#,#vDescripcion#,#vArchivo#"
									tabla="RHRUReportes"
									filtro="Ecodigo=#Session.Ecodigo# order by RHRURsistema, RHRURcategoria, RHRURcodigo"
									mostrar_filtro="true"
									filtrar_automatico="true"
									desplegar="codigo,descripcion,archivo"
									filtrar_por="RHRURcodigo,RHRURdescripcion,RHRURnombre"
									align="left,left,left"				
									formatos="S,S,S"
									showlink="no"
									maxrows="0"
									showemptylistmsg="true"
								/>		
							</td>
						</tr>
					</table>
				</td>
				<td valign="top" width="50%"><cfinclude template="upload-reporte-form.cfm"></td>
			</tr>
		</table>	
	<cf_web_portlet_end>
<cf_templatefooter>