<cf_templateheader title="Tarjetas de Credito Empresarial">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Tipos de TCE'>
		<cfif isdefined("session.modulo") and session.modulo EQ "CG">
			<cfinclude template="../../portlets/pNavegacionCG.cfm">
		<cfelseif isdefined("session.modulo") and session.modulo EQ "AD">
			<cfinclude template="../../portlets/pNavegacionAD.cfm">
		</cfif>			
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr> 
			<td valign="top"> 
				<cfinvoke component="sif.Componentes.pListas" method="pListaRH" returnvariable="pListaRet">
					<cfinvokeargument name="tabla" 				value="CBTipoTarjetaCredito"/>
					<cfinvokeargument name="columnas" 			value="CBTTid,CBTTDescripcion,CBTTcodigo,Ecodigo,BMUsucodigo,ts_rversion"/>
					<cfinvokeargument name="desplegar" 			value="CBTTcodigo, CBTTDescripcion"/>
					<cfinvokeargument name="etiquetas" 			value="C&oacute;digo, Descripci&oacute;n "/>
					<cfinvokeargument name="formatos" 			value="I,S"/>
					<cfinvokeargument name="filtro"				value="Ecodigo= #Session.Ecodigo#"/>
					<cfinvokeargument name="align" 				value="left,left"/>
					<cfinvokeargument name="ajustar" 			value="N,N"/>
					<cfinvokeargument name="checkboxes" 		value="N"/>
					<cfinvokeargument name="keys" 				value="CBTTid"/>
					<cfinvokeargument name="irA" 				value="TCETipoTarjetas.cfm"/>
					<cfinvokeargument name="mostrar_filtro" 	value="true"/>
					<cfinvokeargument name="filtrar_automatico" value="true"/>
				 </cfinvoke>
			</td>				
			<td valign="top">
			  	<cfinclude template="TCEformTipoTarjetas.cfm">
			 </td>
			 <td valign="top" align="right">	
			 </td>
		 	</tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>
