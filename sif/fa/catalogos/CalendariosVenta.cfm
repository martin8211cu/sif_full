<cf_templateheader title="Calendario de Ventas">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Cat&aacute;logo de Calendario de Ventas'>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr> 
				<td colspan="2">
					<cfinclude template="/sif/portlets/pNavegacion.cfm">
				</td>
			</tr>
			<tr> 
				<td valign="top"> 
                	<table  width="100%" cellspacing="0">
                        <tr>
                            <td align="center" class="tituloListas">Lista de Calendarios</td>
                        </tr>
                    </table>
                    <hr style="margin-top: 1px; margin-bottom: 1px;"/>
                    
					<cfset navegacion = ''>                   
                    <cfif isdefined('form.CVid') and len(trim(form.CVid))>
                       <cfset navegacion = "CVid=#form.CVid#">
                    </cfif>
                    
					<cfquery name="rsLista" datasource="#session.DSN#">
						 select  CVid,CVCodigo,CVDescripcion, case CVTipo 
                         									  when 'D' then  
                                                              	'Descuento'	
                                                              when 'R' then  
                                                              	'Recargos'
                                                              end as tipo
   							from ECalendarioVentas
						 where Ecodigo= #session.Ecodigo#
						 <cfif isdefined ('form.filtro_CVCodigo') and len(trim(form.filtro_CVCodigo)) gt 0>
						 	and lower(CVCodigo) like lower('%#form.filtro_CVCodigo#%')
						 </cfif>
						  <cfif isdefined ('form.filtro_CVDescripcion') and len(trim(form.filtro_CVDescripcion)) gt 0>
						 	and lower(CVDescripcion) like lower('%#form.filtro_CVDescripcion#%')
						 </cfif>
					</cfquery>
					<cfinvoke component="sif.Componentes.pListas" method="pListaQuery">
						<cfinvokeargument name="query" 			  value="#rsLista#"/>
						<cfinvokeargument name="desplegar"  	  value="CVCodigo,CVDescripcion,tipo"/>
						<cfinvokeargument name="etiquetas"  	  value="C&oacute;digo,Descripci&oacute;n,Tipo"/>
						<cfinvokeargument name="formatos"   	  value="S,S,S"/>
						<cfinvokeargument name="align" 			  value="left,left,left"/>
						<cfinvokeargument name="ajustar"   		  value="N"/>
						<cfinvokeargument name="irA"              value="CalendariosVenta.cfm"/>
						<cfinvokeargument name="showEmptyListMsg" value="true"/>
						<cfinvokeargument name="keys"             value="CVid"/>
						<cfinvokeargument name="mostrar_filtro"   value="true"/>
						<cfinvokeargument name="showEmptyListMsg" value="true"/>
					</cfinvoke>
				</td>
				<td width="55%">
					<cfinclude template="CalendariosVenta-form.cfm">
				</td>
			</tr>
	 	</table>
	<cf_web_portlet_end>
<cf_templatefooter> 