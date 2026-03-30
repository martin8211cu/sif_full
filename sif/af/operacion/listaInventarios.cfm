<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<cf_templateheader title="#nav__SPdescripcion#">
		<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>"><cfoutput>#pNavegacion#</cfoutput>

			<script language="JavaScript1.2" type="text/javascript">
				<!--//
				// ============================================================================		
				// Llama a la pantalla del reporte
				// ============================================================================		
				var popUpWin=0;
				
				function funcNuevo(){
					document.lista.action="AFInventarioFis.cfm";
				}
				
				function funcFiltrar(){
					document.lista.action="listaInventarios.cfm";
					return true;
				}
				//-->
			</script>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
<!--- 				<tr>
					<td class="tituloMantenimiento">Inventario Fisico de a</td>
				</tr> --->
			</table>
			<cfinvoke 
				component="sif.Componentes.pListas"
				method="pLista"
				returnvariable="pListaRet"
				columnas="LCAid,LCAdescripcion,LCAfecha,Oficodigo,Odescripcion,CFcodigo,CFdescripcion"
				tabla="AFEListaConteoActivos a 
					   left outer join Oficinas  b
 							on a.Ecodigo  = b.Ecodigo  
 							and a.Ocodigo = b.Ocodigo
						left outer join  CFuncional c
							on a.Ecodigo  = c.Ecodigo  
 							and a.CFid= c.CFid"
				filtro=" a.Ecodigo = #session.Ecodigo# order by LCAid"
				desplegar="LCAdescripcion,LCAfecha,Oficodigo,Odescripcion,CFcodigo,CFdescripcion"
				filtrar_por="LCAdescripcion,LCAfecha,Oficodigo,Odescripcion,CFcodigo,CFdescripcion"
				etiquetas="Descripci&oacute;n, Fecha,Cód. Oficina,Descripción,Cód.Centro Funcional,Descripción"
				formatos="S,D,S,S,S,S"
				align="left, left, left, left, left, left"
				checkboxes="N"
				ira="AFInventarioFis.cfm"
				nuevo="AFInventarioFis.cfm"
				showemptylistmsg="true"
				keys="LCAid"
				botones="Nuevo"
				mostrar_filtro="true"
				filtrar_automatico="true"
				maxrows="15"
				/>
		<cf_web_portlet_end>
	<cf_templatefooter>