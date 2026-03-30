<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos"/>	
<cfinvoke key="LB_FechaPublic" default="Fecha de Corte" returnvariable="LB_FechaPublic" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke key="LB_CentroFunc" default="La Escuela" returnvariable="LB_CentroFunc" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke key="LB_FuncXDepto" default="Reporte funcionarios de Departamento" returnvariable="LB_FuncXDepto" component="sif.Componentes.Translate" method="Translate"/>

<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#LB_FuncXDepto#">

<script language="JavaScript" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/javascript">
 	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
</script>

<form name="form1" method="post" action="RepFuncXDepto-form.cfm">
<table width="100%" border="0" cellpadding="1" cellspacing="1" class="areaFiltro" align="center">
 	<tr>
		<td width="37%" align="right"><strong><cf_translate key="LB_EscuelaDepto">Escuela / Departamento</cf_translate>:&nbsp;</strong></td>
		<td colspan="3"><cf_rhcfuncional form="form1" ></td>
	</tr>
 	<tr>
		<td align="right"><strong><cf_translate key="LB_FechaDeCorte">Fecha de Corte</cf_translate>:&nbsp;</strong></td>
		<td colspan="3"><cf_sifcalendario form="form1" name="FechaPublic"></td>
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
	objForm.CFid.required = true;
	objForm.CFid.description = '#LB_CentroFunc#';	
	objForm.FechaPublic.required = true;
	objForm.FechaPublic.description = '#LB_FechaPublic#';	
	</cfoutput>	
</script>