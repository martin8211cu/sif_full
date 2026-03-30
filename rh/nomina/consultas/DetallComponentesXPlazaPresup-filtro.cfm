<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos"/>	

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Detall_Componentes_XPlazaPresupues" Default="Detalle de Componentes por Plaza Presupuestada " returnvariable="LB_Detall_Componentes_XPlazaPresupues"/>


<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#LB_Detall_Componentes_XPlazaPresupues#">
		<cfinclude template="/rh/portlets/pNavegacion.cfm">		
		<form name="form1" method="post" action="DetallComponentesXPlazaPresup-form.cfm">
		<cfoutput>
		<table cellpadding="3" cellspacing="0" align="center" border="0">								
	      <tr>
		<td width="37%" align="right"><strong><cf_translate  key="LB_PlazaDesde">Plaza desde</cf_translate>:&nbsp;</strong></td>
		<td colspan="3"><cf_rhplazapresupuestaria id="RHPPidD" codigo="RHPPcodigoD" descripcion="RHPPdescripcionD"></td>
	     </tr>
				
		<tr>
		<td align="right"><strong><cf_translate  key="LB_PlazaHasta">Plaza hasta</cf_translate>:&nbsp;</strong></td>
		<td colspan="3"><cf_rhplazapresupuestaria id="RHPPidH" codigo="RHPPcodigoH" descripcion="RHPPdescripcion"></td>
	</tr>	
	<tr>
	<td align="right"><strong><cf_translate  key="LB_Escenario">Escenario</cf_translate>:&nbsp;</strong></td>				
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
		 
		 <tr>
			<td width="37%" align="right"><strong><cf_translate key="LB_Unidad">Unidad</cf_translate>:&nbsp;</strong></td>
			
			<td><cf_conlis 
					campos="CFid,CFcodigo, CFdescripcion "
					asignar="CFid,CFcodigo,CFdescripcion"					
					size="0,10,30"
					desplegables="N,S,S"
					modificables="N,S,S"						
					title="Titulo"
					tabla="CFuncional a"
					columnas="CFid as CFid, CFcodigo as CFcodigo, CFdescripcion as CFdescripcion "
					filtro="Ecodigo = #Session.Ecodigo#"
					filtrar_por="CFcodigo, CFdescripcion"
					desplegar=" CFcodigo, CFdescripcion"
					etiquetas="codigo,Descripcion"
					formatos="S,S"
					align="left,left"								
					asignarFormatos="S,S"
					form="form1"
					showEmptyListMsg="true"
					EmptyListMsg=" --- No hay Escenarios --- "
				<!---	valuesArray="#valuesArray#" --->
					alt="ID,descr"	/>	</td>			
			</tr>
		 
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
			<tr></tr>				
		</table>	
		
		<input type="image" id="imgDel" src="/cfmx/rh/imagenes/Borrar01_S.gif" title="Eliminar" style="display:none;">
		</cfoutput>
		</form>
		<cf_qforms> <!--- Siempre debe de ir al final despues del </form> --->
	<cf_web_portlet_end>
<cf_templatefooter>

<script type="text/javascript" language="javascript1.2">
	<cfoutput>
	
<!---	objForm.periodo.required = true;
	objForm.periodo.description = '#LB_Periodo#';--->
	
		
	</cfoutput>	
</script>
