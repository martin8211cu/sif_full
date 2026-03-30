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
					document.lista.action="CentroCustodia.cfm";
				}
				
				function funcFiltrar(){
					document.lista.action="listaCentroCustodia.cfm";
					return true;
				}
				//-->
			</script>
		
				<cf_dbfunction name="concat" args="DEapellido1,' ',DEapellido2,' ',DEnombre" returnvariable="DEnombrecompleto" >
			<cfinvoke 
				component="sif.Componentes.pListas"
				method="pLista"
				returnvariable="pListaRet"
				columnas="CRCCid, CRCCcodigo, CRCCdescripcion, DEidentificacion, #DEnombrecompleto# as DEnombrecompleto"
				tabla="CRCentroCustodia a 
						inner join DatosEmpleado b
							on a.Ecodigo = b.Ecodigo
							and a.DEid  = b.DEid"
				filtro=" a.Ecodigo = #session.Ecodigo# order by CRCCcodigo"
				desplegar="CRCCcodigo, CRCCdescripcion, DEidentificacion, DEnombrecompleto"
				filtrar_por="CRCCcodigo,CRCCdescripcion, DEidentificacion, #DEnombrecompleto#"
				etiquetas="C&oacute;digo, Descripci&oacute;n, Identificaci&oacute;n Responsable, Responsable"
				formatos="S,S,S,S"
				align="left, left, left, left"
				checkboxes="N"
				ira="CentroCustodia.cfm"
				nuevo="CentroCustodia.cfm"
				showemptylistmsg="true"
				keys="CRCCid"
				botones="Nuevo"
				mostrar_filtro="true"
				filtrar_automatico="true"
				maxrows="15"
				ajustar="N"
				/>
		<cf_web_portlet_end>
	<cf_templatefooter>

<script language="javascript">
	document.lista.filtro_CRCCcodigo.focus();
</script>