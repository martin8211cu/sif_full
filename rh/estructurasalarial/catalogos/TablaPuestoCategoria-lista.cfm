<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RelacionDeCategorisPuestoPorTabla"
	Default="Relaci&oacute;n de Categor&iacute;s-Puesto Por Tabla"
	returnvariable="LB_RelacionDeCategorisPuestoPorTabla"/>	
	<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos"/>	
	<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Codigo" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_Codigo"/>	
	<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Descripcion" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_Descripcion"/>	

<cf_templateheader template="#session.sitio.template#">
	<cf_web_portlet_start skin="#Session.Preferences.Skin#">
		<cfinclude template="/rh/portlets/pNavegacion.cfm">
		<table width="98%"  border="0" cellspacing="0" cellpadding="0" align="center">
			<tr>
				<td colspan="2">
					<cf_translatedata name="get" tabla="RHTTablaSalarial" col="RHTTdescripcion" returnvariable="LvarRHTTdescripcion"> 

					<cfinvoke 
						component="rh.Componentes.pListas" 
						method="pListaRH"
						returnvariable="rsLista"
						columnas="distinct z.RHTTid, f.RHTTcodigo, #LvarRHTTdescripcion# as RHTTdescripcion"
						etiquetas="#LB_Codigo#,#LB_Descripcion#"
						tabla="RHCategoriasPuesto z
								inner join RHTTablaSalarial f
									on z.RHTTid = f.RHTTid"
						keys="RHTTid"
						filtro="z.Ecodigo = #Session.Ecodigo# order by RHTTcodigo"
						mostrar_filtro="true"
						filtrar_automatico="true"
						desplegar="RHTTcodigo, RHTTdescripcion"
						filtrar_por="f.RHTTcodigo, f.RHTTdescripcion"
						align="left,left"
						botones="Nuevo"
						formatos="S,S"
						ira="TablaPuestoCategoria.cfm"
						maxrows="20"
						translatedatacols="RHTTdescripcion"
						showemptylistmsg="true"
					/>						
				</td>
			</tr>
		</table>		
	<cf_web_portlet_end>
<cf_templatefooter>	
