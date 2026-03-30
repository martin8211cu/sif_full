	<cf_templateheader title="Lista de Cuentas Contables de Configuración<">
	<script  language="JavaScript" src="/cfmx/sif/js/DHTMLMenu/stm31.js"></script>
		<br>
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td width="1%" valign="top"><cfinclude template="/sif/menu.cfm"></td>
			
				<td valign="top">
					<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Lista de Cuentas Contables'>
					<cf_dbfunction name="to_date" args="WTCid"  returnvariable="WTCid" >
						<cfinvoke component="sif.Componentes.pListas" method="pListaRH"
						 returnvariable="pLista">
							<cfinvokeargument name="tabla" value="WTContable"/>
							<cfinvokeargument name="columnas" value="#WTCid# as WTCid,WECdescripcion,WTCmascara "/>
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
		
<cf_templatefooter>
