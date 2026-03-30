<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="LB_Importador" Default="Importador" returnvariable="LB_Importador" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="BTN_Siguiente" Default="Siguiente &gt;" returnvariable="BTN_Siguiente" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="BTN_Regresar" Default="Regresar;" returnvariable="BTN_Regresar" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_nav__SPdescripcion" Default="#nav__SPdescripcion#" returnvariable="LB_nav__SPdescripcion"/>
<cfinvoke Key="MSG_DebeSeleccionarUnArchivoParaRealizarLasImportacion" Default="Debe seleccionar un archivo para realizar las importación." returnvariable="MSG_DebeSeleccionarUnArchivoParaRealizarLasImportacion" component="sif.Componentes.Translate" method="Translate"/> 
<!--- FIN VARIABLES DE TRADUCCION --->
<cf_templateheader title="#LB_Importador#">
	<cfoutput>#pNavegacion#</cfoutput>
	<cf_web_portlet_start border="true" titulo="#LB_nav__SPdescripcion#" skin="#session.preferences.skin#" >
	
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
	

<form name="form1" action="Importar2.cfm" method="post" enctype="multipart/form-data" onSubmit="javascript: return validar(this);">
<table width="50%" border="0" align="center">
	<tr><td class="subTitulo" colspan="2"><cf_translate  key="LB_SeleccioneElArchivoQueDeseaImportar">Seleccione el archivo que desea importar</cf_translate></td></tr>
	<tr><td colspan="2">&nbsp;</td></tr>
	<tr>
		<td><cf_translate  key="LB_ArchivoPorImportar">Archivo por importar</cf_translate>: </td>
		<td><input type="file" name="file"></td>
	</tr>
	<tr><td colspan="2">&nbsp;</td></tr>
	<tr align="center">
		<td colspan="2">
		<cf_botones Regresar='ReportesDinamicos-lista.cfm' values="Siguiente" >
	</td>
</tr>
</table>
</form>
<cf_web_portlet_end>
<cf_templatefooter>
	    <script language="javascript" type="text/javascript">
		function validar(){
			
			if (document.form1.file.value == '' ){
				alert('<cfoutput>#MSG_DebeSeleccionarUnArchivoParaRealizarLasImportacion#</cfoutput>');
				return false
			}
			return true;
		}
	    </script>
				</td>	
			</tr>
		</table>	
