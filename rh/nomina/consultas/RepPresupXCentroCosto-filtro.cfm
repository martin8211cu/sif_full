<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RepPresupXCentroCostos" Default="Reporte de Presupuesto asignado por Centro de Costo " returnvariable="LB_RepPresupXCentroCostos"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Escenario" Default="Escenario" returnvariable="LB_Escenario"/>

<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#LB_RepPresupXCentroCostos#">
		<cfinclude template="/rh/portlets/pNavegacion.cfm">		
		<form name="form1" method="post" action="RepPresupXCentroCosto-form.cfm">
		<cfoutput>
		<table cellpadding="3" cellspacing="0" align="center" border="0">						  
	<tr>
	<td align="right"><strong>#LB_Escenario#:&nbsp;</strong></td>				
		<td>
		<cf_conlis 
					campos="RHEid,RHEdescripcion"
					asignar="RHEid,RHEdescripcion"
					size="0,43"
					desplegables="N,S"
					modificables="N,S"						
					title="Titulo"
					tabla="RHEscenarios a"
					columnas=" RHEid as RHEid,RHEdescripcion as RHEdescripcion"
					filtro="Ecodigo = #Session.Ecodigo#"
					filtrar_por="RHEid,RHEdescripcion"
					desplegar="RHEid,RHEdescripcion"
					etiquetas="codigo,Descripcion"
					formatos="S,S"
					align="left,left"								
					asignarFormatos="S,S"
					form="form1"
					showEmptyListMsg="true"
					EmptyListMsg=" --- No hay Escenarios --- "
				<!---	valuesArray="#valuesArray#" --->
					alt="ID,descr"					
				/>			
		</td></tr>					 
		</tr>		
				<tr>									
					<td nowrap align="center" colspan="10">
					<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="BTN_Consultar"
					Default="Consultar"
					XmlFile="/rh/generales.xml"
					returnvariable="BTN_Consultar"/>

					<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="BTN_Limpiar"
					Default="Limpiar"
					XmlFile="/rh/generales.xml"
					returnvariable="BTN_Limpiar"/>
					<cf_botones exclude="Alta,Baja,Cambio,Limpiar" include="#BTN_Consultar#,#BTN_Limpiar#">
				</tr>		
					
		</table>	
		
		
		</cfoutput>
		</form>
		<cf_qforms> <!--- Siempre debe de ir al final despues del </form> --->		
	<cf_web_portlet_end>
<cf_templatefooter>

<script type="text/javascript" language="javascript1.2">
	<cfoutput>
	objForm.RHEid.required = true;
	objForm.RHEid.description = '#LB_Escenario#';	
	</cfoutput>	
</script>
