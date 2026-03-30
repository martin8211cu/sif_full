<!--- 
	Modificado por: Gustavo Fonseca H.
		Fecha: 9-3-2006.
		Motivo: Se agrega filtro por código y descripción en la lista.
 --->
<cfset filtro = "CEcodigo = #Session.CEcodigo#" >	
<script  language="JavaScript" src="/cfmx/sif/js/DHTMLMenu/stm31.js"></script>
<cf_templateheader title="Plan de Cuentas">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Cat&aacute;logode M&aacute;scaras de Cuentas'>
		<cfinclude template="../../portlets/pNavegacionCG.cfm">
			<table width="100%" align="center">
				<tr>
					<td align="right"><cf_sifayudaRoboHelp name="imAyuda" imagen="1" Tip="true" width="500" url="Mascaras_cuentas.htm"></td>
				</tr>
			</table>					
			<table width="100%" border="0" cellspacing="1" cellpadding="1">
			  <tr>
				<td width="40%" valign="top">					
					<cfinvoke 
					 component="sif.Componentes.pListas"
					 method="pListaRH"
					 returnvariable="pListaRet">
						<cfinvokeargument name="tabla" value="PCEMascaras"/>
						<cfinvokeargument name="columnas" value="PCEMid, PCEMcodigo, PCEMdesc, PCEMformato"/>
						<cfinvokeargument name="desplegar" value="PCEMcodigo, PCEMdesc, PCEMformato"/>
						<cfinvokeargument name="etiquetas" value="Código, Descripción, Máscara Finaciera"/>
						<cfinvokeargument name="formatos" value="S,S,U"/>
						<cfinvokeargument name="filtro" value="#filtro# order by PCEMcodigo"/>
						<cfinvokeargument name="mostrar_filtro" value="true"/>
						<cfinvokeargument name="filtrar_automatico" value="true"/>
						<cfinvokeargument name="filtrar_por" value="PCEMcodigo, PCEMdesc, ''"/>
						<cfinvokeargument name="align" value="N,N,N"/>
						<cfinvokeargument name="ajustar" value="N"/>
						<cfinvokeargument name="checkboxes" value="N"/>
						<cfinvokeargument name="keys" value="PCEMid"/>
						<cfinvokeargument name="irA" value=""/>
						<cfinvokeargument name="maxrows" value="15"/>
						
					</cfinvoke>					
				</td>
				<td width="60%" valign="top"><cfinclude template="formMascarasCuentas.cfm"></td>
			  </tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>