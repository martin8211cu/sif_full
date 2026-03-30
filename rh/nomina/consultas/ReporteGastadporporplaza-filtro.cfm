<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RepGastoxPlanxPLZ" Default="Reporte de Gastado por Planilla por Plaza " returnvariable="LB_RepGastoxPlanxPLZ"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Escenario" Default="Escenario" returnvariable="LB_Escenario"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Fecha_hasta" Default="Fecha Hasta" returnvariable="LB_Fecha_hasta"/>


<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#LB_RepGastoxPlanxPLZ#">
		<cfinclude template="/rh/portlets/pNavegacion.cfm">		
		<form name="form1" method="post" action="ReporteGastadporplaza-form.cfm">
		<cfoutput>
		<table cellpadding="3" cellspacing="0" align="center" border="0">					
		<tr> <td class="fileLabel" align="right"><strong><cf_translate key="LB_CodigoDelCalendarioDePago">Código del Calendario de Pago</cf_translate> :&nbsp;</strong></td>
    	<td>		
			<cf_rhcalendariopagos form="form1" historicos="true" tcodigo="true" descsize=40 >
		</td>
  		</tr>			
     	<tr>		   
		   <td align="center" colspan="2"><strong><cf_translate key="LB_Anno">A&ntilde;o</cf_translate>:</strong>
		   <cf_rhperiodos name="anno" tabindex="1"></td>
        </tr>		
		 <tr>		 	
			<td align="center" colspan="2"><strong>#LB_Fecha_hasta#&nbsp;:&nbsp;</strong>&nbsp; 			
			<cf_sifcalendario  value="#LSDateFormat(Now(),'dd/mm/yyyy')#"></td>					
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
					
		</table>	
		
		
		</cfoutput>
		</form>
		<cf_qforms> <!--- Siempre debe de ir al final despues del </form> --->		
	<cf_web_portlet_end>
<cf_templatefooter>

<script type="text/javascript" language="javascript1.2">
	<cfoutput>
	<!---objForm.RHEid.required = true;
	objForm.RHEid.description = '#LB_Escenario#';	--->
	</cfoutput>	
</script>
