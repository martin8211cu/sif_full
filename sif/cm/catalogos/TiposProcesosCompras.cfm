<cf_templateheader title="Tipos de Procesos de Compras">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Tipos de Procesos de Compras'>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr> 
				<td colspan="2">
					<cfinclude template="../../portlets/pNavegacionCM.cfm">
				</td>
			</tr>
			<tr> 
				<td valign="top"> 
				
		<!---		<cfdump var="#form#">	--->			
				<cfset navegacion = ''>
				
				<cfif isdefined('form.CMTPid') and len(trim(form.CMTPid))>
				   <cfset navegacion = "CMTPid=#form.CMTPid#">
				</cfif>
								
					<cfquery name="rsLista" datasource="#session.DSN#">
						 select CMTPid,CMTPCodigo,CMTPDescripcion,CMTPMontoIni,CMTPMontoFin,Mcodigo 
   							from CMTipoProceso  
							where Ecodigo= #session.Ecodigo#
													
					</cfquery>
					<cfinvoke 
					component="sif.Componentes.pListas"
					method="pListaQuery"
					returnvariable="pListaRet">
						<cfinvokeargument name="query" 			  value="#rsLista#"/>
						<cfinvokeargument name="desplegar"  	  value="CMTPCodigo,CMTPDescripcion"/>
						<cfinvokeargument name="etiquetas"  	  value="C&oacute;digo,Descripci&oacute;n"/>
						<cfinvokeargument name="formatos"   	  value="V, V"/>
						<cfinvokeargument name="align" 			  value="left,left"/>
						<cfinvokeargument name="ajustar"   		  value="N"/>
						<cfinvokeargument name="irA"              value="TiposProcesosCompras.cfm"/>
						<cfinvokeargument name="showEmptyListMsg" value="true"/>
						<cfinvokeargument name="keys"             value="CMTPid"/>
   						<cfinvokeargument name="formName"         value="lista1"/>	
                        <cfinvokeargument name="navegacion"       value="#navegacion#"/>											
					</cfinvoke>
				</td>
				<td width="55%">
					<cfinclude template="TiposProcesosCompras-form.cfm">
				</td>
			</tr>		
					<cfinclude template="TiposActividadesProcesos.cfm">			
	 	</table>
	<cf_web_portlet_end>
<cf_templatefooter>