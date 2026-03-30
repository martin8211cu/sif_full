<cfinvoke Key="LB_RecursosHumanos" Default="Recursos Humanos" returnvariable="LB_RecursosHumanos" XmlFile="/rh/generales.xml" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_IndicadoresDeAccidentabilidad" Default="Indicadores de Accidentabilidad" returnvariable="LB_IndAccidentabilidad" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Consultar" Default="Consultar" returnvariable="LB_Consultar" component="sif.Componentes.Translate" method="Translate"/>
<cfoutput>
<cf_templateheader title="#LB_RecursosHumanos#">
	<cf_web_portlet_start skin="#Session.Preferences.Skin#" titulo="#LB_IndAccidentabilidad#">
		<script type="text/javascript" language="javascript1.2">			
			var width = 1150;
			var height = 650;
			var top = (screen.height - height) / 2;
			var left = (screen.width - width) / 2;
			window.open('/cfmx/rh/indicadores/accidentabilidad/ind-accidentabilidad.cfm','GraficoAccidentabilidad','menubar=yes,resizable=yes,scrollbars=yes,top='+top+',left='+left+',height='+height+',width='+width);
		</script>		
		<!---
		<form method="get" name="form1" action="" >
			<table width="60%" border="0" align="center" cellpadding="2" cellspacing="0">
				<tr>
					<td align="right"><strong><cf_translate key="LB_CentroFuncional">Centro Funcional</cf_translate>:</strong>&nbsp;</td>
					<td><cf_rhcfuncional></td>
				</tr>
				<tr>
					<td></td>
					<td>
						<table width="100%" cellpadding="0" cellspacing="0">
							<tr>
								<td width="1%"><input type="checkbox" name="dependencias" id="dependencias" /></td>
								<td><label for="dependencias"><cf_translate key="LB_IncluirDependencias">Incluir dependencias</cf_translate></label></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr><td colspan="2" align="center"><input type="button" class="btnFiltrar" name="Consultar" id="Consultar" value="#LB_Consultar#" onclick="javascript: desplegar();" /></td></tr>
			</table>
		</form>		
		<script type="text/javascript" language="javascript1.2">
			function desplegar(){
				var params = ''
				var width = 1150;
				var height = 575;
				var top = (screen.height - height) / 2;
				var left = (screen.width - width) / 2;
				if ( document.form1.CFid.value != '' ){ 
					params = params + '?CFid='+document.form1.CFid.value 
					if ( document.form1.dependencias.checked ){ 
						params = params + '&dependencias=on';
					}
				}
				var nuevo = window.open('/cfmx/rh/indicadores/accidentabilidad/ind-accidentabilidad.cfm'+params,'GraficoAccidentabilidad','menubar=yes,resizable=yes,scrollbars=yes,top='+top+',left='+left+',height='+height+',width='+width);
			}
		</script>
		---->		
	<cf_web_portlet_end>
<cf_templatefooter>
</cfoutput>
