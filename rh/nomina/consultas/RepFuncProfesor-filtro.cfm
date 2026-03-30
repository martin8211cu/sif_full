<cfinvoke key="LB_ListaDePuestos" default="Lista de Puestos" returnvariable="LB_ListaDePuestos" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos"/>	
<cfinvoke key="LB_Codigo" default="C&oacute;digo" returnvariable="LB_Codigo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Descripcion" default="Descripcion" returnvariable="LB_Descripcion" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke key="LB_CodigoPuesto" default="Puesto" returnvariable="LB_CodigoPuesto" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke key="LB_FechaPublic" default="Fecha de Corte" returnvariable="LB_FechaPublic" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke key="LB_FuncXPuesto" default="Reporte de Funcionarios por Puesto" returnvariable="LB_FuncXPuesto" component="sif.Componentes.Translate" method="Translate"/>	



<script language="JavaScript" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/javascript">
 	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
</script>

<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#LB_FuncXPuesto#">

<form name="form1" method="post" action="RepFuncProfesor-form.cfm">
<table width="100%" border="0" cellpadding="1" cellspacing="1" class="areaFiltro" align="center"> 	
 	<tr>
		<td align="right"><strong><cf_translate key="LB_FechaDeCorte">Fecha de Corte</cf_translate>:&nbsp;</strong></td>
		<td colspan="3"><cf_sifcalendario form="form1" name="FechaPublic"></td>
	</tr>
	<tr>
		<td align="right"><strong><cf_translate key="LB_Puestos">Puestos</cf_translate>:&nbsp;</strong></td>
		<!---<td><select name="puestos" >
			<option value="1">Profesor </option>
			<option value="2">Administrativos </option>
			</select></td>	--->		
			<td>
					<cf_conlis title="#LB_ListaDePuestos#"
						campos = "RHPcodigo,RHPdescpuesto" 
						desplegables = "S,S" 
						modificables = "S,N" 
						size = "10,30"
						asignar="RHPcodigo,RHPdescpuesto"
						asignarformatos="S,S"
						tabla="RHPuestos"																	
						columnas="RHPcodigo,RHPdescpuesto"
						filtro="Ecodigo =#session.Ecodigo#"
						desplegar="RHPcodigo,RHPdescpuesto"
						etiquetas="#LB_Codigo#,#LB_Descripcion#"
						formatos="S,S"
						align="left,left"
						showEmptyListMsg="true"
						debug="false"
						form="form1"
						width="800"
						height="500"
						left="70"
						top="20"
						filtrar_por="RHPcodigo,RHPdescpuesto">			
				</td>			
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
					</td>
				</tr>
</table>
</form>
<cf_qforms> <!--- Siempre debe de ir al final despues del </form> --->		

	<cf_web_portlet_end>
<cf_templatefooter>

<script type="text/javascript" language="javascript1.2">
	<cfoutput>
	objForm.RHPcodigo.required = true;
	objForm.RHPcodigo.description = '#LB_CodigoPuesto#';	
	objForm.FechaPublic.required = true;
	objForm.FechaPublic.description = '#LB_FechaPublic#';	
	</cfoutput>	
</script>

