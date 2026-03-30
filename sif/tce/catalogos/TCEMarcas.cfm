<cf_templateheader title="Marcas Tarjetas de Credito Empresarial">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Marcas TCE'>
		<cfif isdefined("session.modulo") and session.modulo EQ "CG">
			<cfinclude template="../../portlets/pNavegacionCG.cfm">
		<cfelseif isdefined("session.modulo") and session.modulo EQ "AD">
			<cfinclude template="../../portlets/pNavegacionAD.cfm">
		</cfif>			
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr> 
			<td valign="top"> 
            
            <cfsavecontent variable="helpimg">
					<img src="../../imagenes/Help01_T.gif" width="25" height="23" border="0"/>
				</cfsavecontent>
                         
                         
				<cfinvoke component="sif.Componentes.pListas" method="pListaRH" returnvariable="pListaRet">
					<cfinvokeargument name="tabla" 				value="CBTMarcas"/>
					<cfinvokeargument name="columnas" 			value="CBTMid, CBTMarca,CBTMascara,BMUsucodigo,ts_rversion"/>
					<cfinvokeargument name="desplegar" 			value="CBTMarca,CBTMascara"/>
					<cfinvokeargument name="etiquetas" 			value="Marca, Mascara"/>
					<cfinvokeargument name="formatos" 			value="S,S,S"/>
					<cfinvokeargument name="filtro"				value="1=1"/>
					<cfinvokeargument name="align" 				value="left,left,left"/>
					<cfinvokeargument name="ajustar" 			value="N,N,N"/> 	
					<cfinvokeargument name="keys" 				value="CBTMid"/>
					<cfinvokeargument name="irA" 				value="TCEMarcas.cfm"/>
					<cfinvokeargument name="mostrar_filtro" 	value="true"/>
					<cfinvokeargument name="filtrar_automatico" value="true"/>
				 </cfinvoke>
			</td>				
			<td valign="top">
			  	<cfinclude template="TCEMarcas-form.cfm">
			 </td>
			 <td valign="top" align="right">	
			 </td>
		 	</tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>
