            <cfif isdefined('form.CPDCid') and len(trim(form.CPDCid))>
            	<tr>
       				<td>&nbsp;</td>
                    <td align="center"><strong>Centros Funcionales:</strong></td>
    			</tr>
            </cfif>
            <tr>
            	<td>&nbsp;</td>
				<td valign="top">     
				   <cfif isdefined('form.CPDCid') and len(trim(form.CPDCid))>
                       <cfset navegacion = "CPDCid=#form.CPDCid#">
                   </cfif>
                    
				   <cfif isdefined('form.CPDCid') and len(trim(form.CPDCid))>				         
						<cfquery name="rsLista" datasource="#session.DSN#">
							select
							    a.CPDCid, 
							    a.CFid, 
							   	a.CPDCCFporc,
                                case a.CPDCCFdefault when 1 then 'Si' when 0 then 'No' end as CPDCCFdefault,
                                b.CFcodigo,
                                b.CFdescripcion
							from CPDistribucionCostosCF as a
                            	 inner join CFuncional as b
                                 	on a.CFid = b.CFid   
							where CPDCid= #form.CPDCid#
						</cfquery>
                        
                        <cfinclude template="TipoCentroFuncionalForm.cfm">
						<table  width="100%" cellspacing="0">
                        	<tr>
                            	<td align="center" class="tituloListas">Lista de Centros Funcionales:</td>
                        	</tr>
                        </table>
						<cfinvoke 
						component="sif.Componentes.pListas"
						method="pListaQuery"
						returnvariable="pListaRet1">
							<cfinvokeargument name="query" 			  value="#rsLista#"/>
							<cfinvokeargument name="desplegar"  	  value="CFcodigo, CFdescripcion, CPDCCFporc,CPDCCFdefault"/>
							<cfinvokeargument name="etiquetas"  	  value="Codigo, Centro Funcional, Porcentaje, Default"/>
							<cfinvokeargument name="formatos"   	  value="V, S, V, S"/>
							<cfinvokeargument name="align" 			  value="left,left,left,left"/>
							<cfinvokeargument name="ajustar"   		  value="N"/>
                            <cfinvokeargument name="formName"  		  value="form2s"/>                            
							<cfinvokeargument name="irA"              value="TipoDistribucion.cfm"/>
							<cfinvokeargument name="showEmptyListMsg" value="true"/>
							<cfinvokeargument name="keys"             value="CPDCid,CFid"/>
                            <cfinvokeargument name="PageIndex" 		  value="2"/>
                            <cfinvokeargument name="MaxRows" value="0"/>
                            <cfinvokeargument name="usaAJAX" value="true"/>
                            <cfinvokeargument name="Conexion" value="#session.DSN#"/>
						</cfinvoke>
					</cfif>
				</td>				
			</tr>
            <tr>
            	<td>&nbsp;</td>
            </tr>			
