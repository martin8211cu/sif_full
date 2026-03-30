<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos"/>	

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DetalleDeComponentesPorCentroCosto" Default="Detalle de Componentes por Centro de Costos " returnvariable="LB_DetalleDeComponentesPorCentroCosto"/>


<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#LB_DetalleDeComponentesPorCentroCosto#">
		<cfinclude template="/rh/portlets/pNavegacion.cfm">		
		<form name="form1" method="post" action="DetallComponentesXCentroCosto-form.cfm">
		<cfoutput>
		<table cellpadding="3" cellspacing="0" align="center" border="0">								
	      <tr>
			<td valign="top">
			<cf_web_portlet_start border="true" titulo="#LB_DetalleDeComponentesPorCentroCosto#" skin="info1">
				 <div align="justify">
					<p>
					<cf_translate key="LB_ReporteDeDetalleDeComponentesPorEmpleado">
					Reporte de Componentes por Centro de Costo. 
					El reporte muestra los componentes por Centro de Costo.
				    </cf_translate>
					</p>
				</div>
		<cf_web_portlet_end>
	     </tr>
		<tr>									
					<td nowrap align="center" colspan="10">
					<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="BTN_Generar"
					Default="Generar"
					XmlFile="/rh/generales.xml"
					returnvariable="BTN_Generar"/>

					
					<cf_botones exclude="Alta,Baja,Cambio,Limpiar" include="#BTN_Generar#">
			</tr>		
			<tr></tr>				
		</table>	
		
		<input type="image" id="imgDel" src="/cfmx/rh/imagenes/Borrar01_S.gif" title="Eliminar" style="display:none;">
		</cfoutput>
		</form>
	
