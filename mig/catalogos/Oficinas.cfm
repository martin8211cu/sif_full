
    <cfinvoke component="mig.Componentes.Translate"
    method="Translate"
    Key="LB_MIGEstructuraJ"
    Default="MIG-Estructura Jer&aacute;rquica"
    XmlFile="/sif/generales.xml"
    returnvariable="LB_MIGEstructuraJ"/>


	<cfinvoke component="mig.Componentes.Translate"
	method="Translate"
	Key="LB_CatalogoDeOficinas"
	Default="Cat&aacute;logo de Oficinas"
	returnvariable="LB_CatalogoDeOficinas"/>
	
	<cfinvoke component="mig.Componentes.Translate"
	method="Translate"
	Key="LB_Codigo"
	Default="C&oacute;digo"
	XmlFile="/sif/generales.xml"
	returnvariable="LB_Codigo"/>
	
	<cfinvoke component="mig.Componentes.Translate"
	method="Translate"
	Key="LB_Telefono"
	Default="Tel&eacute;fono"
	XmlFile="/sif/generales.xml"
	returnvariable="LB_Telefono"/>
	
	<cfinvoke component="mig.Componentes.Translate"
	method="Translate"
	Key="LB_Descripcion"
	Default="Descripci&oacute;n"
	XmlFile="/sif/generales.xml"
	returnvariable="LB_Descripcion"/>
	
<cf_templateheader title="#LB_MIGEstructuraJ#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_CatalogoDeOficinas#'>
		<cfinclude template="../portlets/pNavegacion.cfm">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr> 
				<td valign="top">
					<cfinvoke component="commons.Componentes.pListas" method="pListaRH" returnvariable="pLista">
						<cfinvokeargument name="tabla" 		value="Oficinas"/>
						<cfinvokeargument name="columnas" 	value="Ocodigo, Oficodigo, telefono, Odescripcion "/>
						<cfinvokeargument name="desplegar" 	value="Oficodigo, telefono, Odescripcion"/>
						<cfinvokeargument name="etiquetas" 	value="#LB_Codigo#,#LB_Telefono#,#LB_Descripcion#"/>
						<cfinvokeargument name="formatos" 	value=""/>
						<cfinvokeargument name="filtro" 	value="Ecodigo=#session.Ecodigo# order by Oficodigo"/>
						<cfinvokeargument name="align" 		value="left,left,left"/>
						<cfinvokeargument name="ajustar" 	value="N"/>
						<cfinvokeargument name="checkboxes" value="N"/>
						<cfinvokeargument name="irA" 		value="Oficinas.cfm"/>
					</cfinvoke> 
				</td>
				<td>
			  		<cfinclude template="formOficinas.cfm">
				</td>
		  </tr>
		</table>
	<cf_web_portlet_end>	
<cf_templatefooter>