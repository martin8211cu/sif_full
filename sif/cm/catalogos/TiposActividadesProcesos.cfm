			<tr> 
				<td valign="top"> 
				
				   <cfif isdefined('form.CMTPid') and len(trim(form.CMTPid))>				         
						<cfquery name="rsLista" datasource="#session.DSN#">
							 select
							    CMTPid, 
							    CMTPAid, 
							   CMTPAdescripcionActividad,
							   CMTPAduracion
							   from CMTPActividades  
								where CMTPid= #form.CMTPid#
						</cfquery>
						<cfinvoke 
						component="sif.Componentes.pListas"
						method="pListaQuery"
						returnvariable="pListaRet1">
							<cfinvokeargument name="query" 			  value="#rsLista#"/>
							<cfinvokeargument name="desplegar"  	  value="CMTPAdescripcionActividad,CMTPAduracion"/>
							<cfinvokeargument name="etiquetas"  	  value="Descripci&oacute;n,Duraci&oacute;n"/>
							<cfinvokeargument name="formatos"   	  value="V, V"/>
							<cfinvokeargument name="align" 			  value="left,left"/>
							<cfinvokeargument name="ajustar"   		  value="N"/>
							<cfinvokeargument name="irA"              value="TiposProcesosCompras.cfm"/>
							<cfinvokeargument name="showEmptyListMsg" value="true"/>
							<cfinvokeargument name="keys"             value="CMTPid,CMTPAid"/>
							
						</cfinvoke>
					</cfif>			
				</td>
				<td>
     				<cfinclude template="TiposActividadesProcesos-form.cfm">
				</td>				
			</tr>			
