<cf_template template="#session.sitio.template#">
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Importador"
	Default="Importador"
	returnvariable="LB_Importador"/>

	<cf_templatearea name="title">
		<cfoutput>#LB_Importador#</cfoutput>
	</cf_templatearea>
	
	<cf_templatearea name="body">
		
	
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#LB_Importador#">
	

<table width="100%" cellpadding="0" cellspacing="0">
	<tr>
		<td>
			<table width="100%" border="0" cellpadding="4" cellspacing="0" bgcolor="#DFDFDF">
			  <tr align="left"> 
				<td width="100%"><a href="/cfmx/sif/importar/ListaImportador.cfm">
				<cf_translate  key="LB_ListaDeImportaciones">Lista de Importaciones</cf_translate>
				</a></td>
			  </tr>
			</table>
		</td>
	</tr>
</table>				
<form name="form1" action="Importar2.cfm" method="post" enctype="multipart/form-data" onSubmit="javascript: return validar(this);">
<table border="0">
  <tr>
    <td colspan="2" class="subTitulo"><cf_translate  key="LB_SeleccioneElArchivoQueDeseaImportar">Seleccione el archivo que desea importar</cf_translate> </td>
    </tr>
  <tr>
    <td><cf_translate  key="LB_ArchivoPorImportar">Archivo por importar</cf_translate>: </td>
    <td><input type="file" name="file"></td>
    </tr>
  <tr align="right">
    <td colspan="2">
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Siguiente"
	Default="Siguiente &gt;"
	returnvariable="BTN_Siguiente"/>
	
	
	<input type="submit" name="Submit" value="<cfoutput>#BTN_Siguiente#</cfoutput>"></td>
    </tr>
</table>
</form>
	    <cf_web_portlet_end>
	    <script language="javascript" type="text/javascript">
		function validar(){
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_DebeSeleccionarUnArchivoParaRealizarLasImportacion"
			Default="Debe seleccionar un archivo para realizar las importación."
			returnvariable="MSG_DebeSeleccionarUnArchivoParaRealizarLasImportacion"/> 
			
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
	</cf_templatearea>
</cf_template>