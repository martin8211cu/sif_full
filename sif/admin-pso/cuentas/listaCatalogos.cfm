<cf_template template="#session.sitio.template#">
	<script  language="JavaScript" src="/cfmx/sif/js/DHTMLMenu/stm31.js"></script>

	<cf_templatearea name="title">Lista de Cuentas Contables de Configuración</cf_templatearea>
	
	<cf_templatearea name="body">
		<br>
		<link rel="stylesheet" type="text/css" href="/cfmx/asp/css/asp.css">
		<cfinclude template="/home/menu/pNavegacion.cfm">
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
			
				<td valign="top">
					<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Lista de Cuentas Contables'>

						<cfinvoke component="rh.Componentes.pListas" method="pListaRH"
						 returnvariable="pLista">
							<cfinvokeargument name="tabla" value="WTContable"/>
							<cfinvokeargument name="columnas" value="WTCid,WECdescripcion,WTCmascara "/>
							<cfinvokeargument name="desplegar" value="WECdescripcion,WTCmascara"/>
							<cfinvokeargument name="etiquetas" value="Descripción,Máscara"/>
							<cfinvokeargument name="formatos" value="V,V"/>
							<cfinvokeargument name="filtro" value=""/>
							<cfinvokeargument name="align" value="left,left"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="Conexion" value="#session.DSN#"/>	
							<cfinvokeargument name="irA" value="ccuentas.cfm"/>
							<cfinvokeargument name="debug" value="N"/>
							<cfinvokeargument name="showEmptyListMsg" value="true"/>	
							<cfinvokeargument name="MaxRows" value="20"/>
							<cfinvokeargument name="Conexion" value="asp"/>
							<cfinvokeargument name="botones" value="Nuevo"/>
						</cfinvoke>	
					<cf_web_portlet_end>	
				</td>	
			</tr>
		</table>	
		
	</cf_templatearea>
</cf_template>