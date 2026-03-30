<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="LB_Anno" Default="A&ntilde;o" returnvariable="LB_Anno" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_nav__SPdescripcion" Default="#nav__SPdescripcion#" returnvariable="LB_nav__SPdescripcion"/>
<cfinvoke Key="LB_CODIGO" Default="C&oacute;digo" XmlFile="/rh/generales.xml" returnvariable="LB_CODIGO" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_DESCRIPCION" Default="Descripci&oacute;n" XmlFile="/rh/generales.xml" returnvariable="LB_DESCRIPCION" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="LB_RecursosHumanos" Default="Recursos Humanos" returnvariable="LB_RecursosHumanos" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<!--- FIN VARIABLES DE TRADUCCION --->

	<cf_templateheader title="#LB_RecursosHumanos#">
		<cfoutput>#pNavegacion#</cfoutput>
		<cf_web_portlet_start border="true" titulo="#LB_nav__SPdescripcion#" skin="#session.preferences.skin#" >
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr><td colspan="2"><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
				<tr>
					<td width="50%" valign="top">

						 <cfset filtro = ''>
                            <cfset navegacion = ''>
                            <cfinvoke 
                                 component="rh.Componentes.pListas"
                                 method="pListaRH"
                                 returnvariable="pListaEduRet">
                                    <cfinvokeargument name="tabla" value="RHReportesNomina "/>
                                    <cfinvokeargument name="columnas" value="RHRPTNid, RHRPTNcodigo, RHRPTNdescripcion"/>
                                    <cfinvokeargument name="desplegar" value="RHRPTNcodigo, RHRPTNdescripcion"/>
                                    <cfinvokeargument name="etiquetas" value="#LB_CODIGO#, #LB_DESCRIPCION#"/>
                                    <cfinvokeargument name="formatos" value="S,S"/>
                                    <cfinvokeargument name="filtro" value="Ecodigo = #Session.Ecodigo# 
                                                                           #filtro# 
                                                                           order by RHRPTNdescripcion"/>
                                    <cfinvokeargument name="align" value="left, left"/>
                                    <cfinvokeargument name="ajustar" value="N"/>
                                    <cfinvokeargument name="irA" value="ReportesDinamicos.cfm"/>
									<cfinvokeargument name="botones" value="Nuevo,Exportar,Importar"/>
                                    <cfinvokeargument name="keys" value="RHRPTNid"/>
                                    <cfinvokeargument name="debug" value="N"/>
                                    <cfinvokeargument name="navegacion" value="#navegacion#"/>
                                    <cfinvokeargument name="mostrar_filtro" value="true"/>
                                    <cfinvokeargument name="filtrar_automatico" value="true"/>
									<cfinvokeargument name="checkboxes" value="S"/>
                                </cfinvoke>
					</td>
				</tr>
			</table>
		<cf_web_portlet_end>
<cf_templatefooter>

<script>
	function funcExportar(){
		if (document.lista.chk) {
			if (document.lista.chk.value) {
				if (document.lista.chk.checked) {
					if (confirm("¿Desea exportar el reporte Seleccionado?")){
						document.lista.action= 'ExportarRep.cfm';
						return true;
					}
				}
			} else {
				for (var i=0;i<document.lista.chk.length;i++) {
					if (document.lista.chk[i].checked){
						if (confirm("¿Desea exportar el reporte Seleccionado?")){
							document.lista.action= 'ExportarRep.cfm';
							return true;
						}
					}
				}
			}
			alert("Debe seleccionar un reporte de la lista");
		} else {
			alert("Debe seleccionar un reporte de la lista");
		}
		return false;
	}
	
	function funcImportar(){
		document.lista.action= 'ImportarRep.cfm';
		return true;
	}
</script>