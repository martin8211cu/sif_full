<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>
		<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
			<script language="JavaScript1.2" type="text/javascript">
				<!--//
				// ============================================================================		
				// Llama a la pantalla del reporte
				// ============================================================================		
				var popUpWin=0;
				
				function funcNuevo(){
					document.lista.action="AF_Traslados.cfm";
				}
				
				function funcFiltrar(){
					document.lista.action="AF_ListaTraslados.cfm";
					return true;
				}
				//-->
			</script>
			 <cfinvoke 
				component="sif.Componentes.pListas"
				method="pLista"
				returnvariable="pListaRet"
				columnas="a.AFMovsID,a.AFMovsDescripcion,a.AFMovsFecha"
				tabla="AFMovsEmpresasE a"
				filtro=" Ecodigo = #session.Ecodigo# and AFMovsEstado = 0 order by AFMovsID"
				desplegar="AFMovsDescripcion,AFMovsFecha"
				filtrar_por="AFMovsDescripcion,AFMovsFecha"
				etiquetas="Descripci&oacute;n,Fecha"
				formatos="S,DI"
				align="left,left"
				<!--- checkboxes="S" --->
				ira="AF_Traslados.cfm"
				nuevo="AF_Traslados.cfm"
				showemptylistmsg="true"
				keys="AFMovsID"
				botones="Nuevo"
				mostrar_filtro="true"
				filtrar_automatico="true"
				maxrows="15"
				/> 
		<cf_web_portlet_end>
	<cf_templatefooter>