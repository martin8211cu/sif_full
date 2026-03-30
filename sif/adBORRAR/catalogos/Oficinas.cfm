<cfif isdefined("LvarSucursal")>
	<cfinvoke component="sif.Componentes.Translate"
    method="Translate"
    Key="LB_Quick Pass"
    Default="Quick Pass"
    XmlFile="/sif/generales.xml"
    returnvariable="LB_SIFAdministracionDelSistema"/>
<cfelse>
    <cfinvoke component="sif.Componentes.Translate"
    method="Translate"
    Key="LB_SIFAdministracionDelSistema"
    Default="SIF - Administraci&oacute;n del Sistema"
    XmlFile="/sif/generales.xml"
    returnvariable="LB_SIFAdministracionDelSistema"/>
</cfif>
<cfif isdefined("LvarSucursal")>
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_CatalogoDeSucursales"
	Default="Cat&aacute;logo de Sucursales"
	returnvariable="LB_CatalogoDeOficinas"/>
<cfelse>
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_CatalogoDeOficinas"
	Default="Cat&aacute;logo de Oficinas"
	returnvariable="LB_CatalogoDeOficinas"/>
</cfif>
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Codigo"
	Default="C&oacute;digo"
	XmlFile="/sif/generales.xml"
	returnvariable="LB_Codigo"/>
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Telefono"
	Default="Tel&eacute;fono"
	XmlFile="/sif/generales.xml"
	returnvariable="LB_Telefono"/>
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Descripcion"
	Default="Descripci&oacute;n"
	XmlFile="/sif/generales.xml"
	returnvariable="LB_Descripcion"/>
	
<cfif isdefined('url.desde') and trim(url.desde) EQ 'rh'>
	<cfset form.desde = url.desde >
</cfif>	
	<cfset desde = "" >
<cfset LvarIrA = 'Oficinas.cfm'>
<cfif isdefined("LvarSucursal")>
	<cfset LvarIrA = '/cfmx/sif/QPass/catalogos/QPassSucursal.cfm'>
</cfif>	
<cfif isdefined("LvarSucursal")>
	<cfset LvarIn = '/sif/QPass/catalogos/QPassSucursal_form.cfm'>
<cfelse>
	<cfset LvarIn = 'formOficinas.cfm'>
</cfif>

<cf_templateheader title="#LB_SIFAdministracionDelSistema#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_CatalogoDeOficinas#'>
		<cfif isdefined('form.desde') and trim(form.desde) EQ 'rh'>
			<cfset desde = ", 'rh' as desde" >
			<cfset navBarItems = ArrayNew(1)>
			<cfset navBarLinks = ArrayNew(1)>
			<cfset navBarStatusText = ArrayNew(1)>			 
			<cfset navBarItems[1] = "Estructura Organizacional">
			<cfset navBarLinks[1] = "/cfmx/rh/indexEstructura.cfm">
			<cfset navBarStatusText[1] = "/cfmx/rh/indexEstructura.cfm">			
			<cfinclude template="/sif/portlets/pNavegacion.cfm">					
		<cfelse>
			<cfinclude template="../../portlets/pNavegacionAD.cfm">
		</cfif>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr> 
				<td valign="top">
					<cfinvoke component="sif.Componentes.pListas" method="pListaRH" returnvariable="pLista">
						<cfinvokeargument name="tabla" 				value="Oficinas"/>
						<cfinvokeargument name="columnas" 			value="Ecodigo, Ocodigo, Oficodigo, telefono, Odescripcion #desde#"/>
						<cfinvokeargument name="desplegar" 			value="Oficodigo, telefono, Odescripcion"/>
						<cfinvokeargument name="etiquetas" 			value="#LB_Codigo#,#LB_Telefono#,#LB_Descripcion#"/>
						<cfinvokeargument name="formatos" 			value="S,S,S"/>
						<cfinvokeargument name="filtro" 			value="Ecodigo=#session.Ecodigo# order by Oficodigo"/>
						<cfinvokeargument name="align" 				value="left,left,left"/>
						<cfinvokeargument name="ajustar" 			value="N"/>
						<cfinvokeargument name="checkboxes" 		value="N"/>
						<cfinvokeargument name="filtrar_automatico" value="true"/>
						<cfinvokeargument name="mostrar_filtro" 	value="true"/>	
						<cfinvokeargument name="keys"  				value="Ecodigo,Ocodigo"/>
						<cfinvokeargument name="irA" 				value="#LvarIrA#"/>
					</cfinvoke> 
				</td>
				<td>
			  		<cfinclude template="#preservesinglequotes(LvarIn)#">
				</td>
		  </tr>
		</table>
	<cf_web_portlet_end>	
<cf_templatefooter>