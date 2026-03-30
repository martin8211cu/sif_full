<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<!---filtro descripcion--->
	<cfif isdefined('form.CMPdescripcion') and len(trim(form.CMPdescripcion)) GT 0><cfset CMPdescripcion= form.CMPdescripcion>
	<cfelse><cfset CMPdescripcion = ""></cfif>
<!---Filtro Fecha desde--->
	<cfif isdefined('form.fechaD') and len(trim(form.fechaD)) GT 0><cfset fechaD=form.fechaD>
	<cfelse><cfset fechaD = ""></cfif>
<!---Filtro Fecha Hasta--->
	<cfif isdefined('form.fechaH') and len(trim(form.fechaH)) GT 0><cfset fechaH=form.fechaH>
	<cfelse><cfset fechaH = ""></cfif>
<!---Filtro Estado--->	
	<cfif isdefined('form.CMPestado') and len(trim(form.CMPestado)) GT 0><cfset CMPestado=form.CMPestado>
	<cfelse><cfset CMPestado = -1></cfif>
<!---Filtro Tipo de Proceso--->	
	<cfif isdefined('form.CMTPid') and len(trim(form.CMTPid)) GT 0><cfset TPvalor=form.CMTPid>
	<cfelse><cfset TPvalor = -1></cfif>
	
<!---Tipo de Proceso de compra--->
	<cfquery name="TipoProceso" datasource="#Session.DSN#">
		select CMTPid, CMTPCodigo, CMTPDescripcion 
		from CMTipoProceso
		where Ecodigo = #Session.Ecodigo#
	</cfquery>
<!---Listado--->
	<cfquery name="rsLista" datasource="#Session.DSN#">
		   select CMPestado,CMPid, CMPnumero,CMPdescripcion,CMPfechapublica, CMPfmaxofertas
			from CMProcesoCompra
			where Ecodigo = #Session.Ecodigo#
		<cfif len(CMPdescripcion) GT 0>
			 and upper(CMPdescripcion) like upper('%#CMPdescripcion#%')
		</cfif>
		<cfif len(fechaD) GT 0>
			and CMPfechapublica > = <cf_dbfunction name="to_date" args="'#fechaD#'">
		</cfif>
		<cfif len(fechaH) GT 0>
			and CMPfechapublica < = <cf_dbfunction name="to_date" args="'#fechaH#'">
		</cfif>
		<cfif CMPestado NEQ -1 >
			and CMPestado = #CMPestado#
		</cfif>
		<cfif TPvalor NEQ -1 >
			and CMTPid = #TPvalor#
		</cfif>
	</cfquery>
	
<cf_templateheader title="Procesos de Publicaciónes de Compra">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Procesos de Publicaciónes de Compra'>
			<cfinclude template="../../portlets/pNavegacionCM.cfm">
			  <cfoutput>
				<form name="form1" action="TiposProcesosCompras-lista.cfm" method="post">
					<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0" class="areaFiltro">
						<tr>      				
							<CFIF TipoProceso.RecordCount>
                                <td align="right" class="fileLabel" nowrap >
                                    <strong>Tipo de Proceso:&nbsp;</strong>
                                </td>
                                <td nowrap align="left">		
                                    <select name="CMTPid">
                                      <option value="-1">--Todos--</option>
                                      <cfloop query="TipoProceso">
                                        <cfoutput><option value="#TipoProceso.CMTPid#"<cfif TipoProceso.CMTPid EQ TPvalor>selected="selected"</cfif>>#TipoProceso.CMTPCodigo#-#TipoProceso.CMTPDescripcion# </option></cfoutput>
                                      </cfloop>
                                    </select>														
                                </td>  
                            <CFELSE>
                            	<input name="CMTPid" id="CMTPid" type="hidden" value="-1"/>
                            </CFIF>  	
                            			
							<td align="right" class="fileLabel" nowrap >
								<strong>Estado del Proceso:&nbsp;</strong>
							</td>
							<td nowrap align="left">		
								<select name="CMPestado">
								  <option value="-1" <cfif CMPestado EQ -1>selected="selected"</cfif>>--Todos--</option>
								  <option value="0"  <cfif CMPestado EQ 0>selected="selected"</cfif>>No Publicado</option>
                                  <option value="10" <cfif CMPestado EQ 10>selected="selected"</cfif>>Publicado</option>
								  <option value="50" <cfif CMPestado EQ 50>selected="selected"</cfif>>Orden de Compra</option>
                                  <option value="79" <cfif CMPestado EQ 79>selected="selected"</cfif>>Pediente de Aprobación Solicitante</option>
                                  <option value="81" <cfif CMPestado EQ 81>selected="selected"</cfif>>Aprobado por Solicitante</option>
                                  <option value="83" <cfif CMPestado EQ 83>selected="selected"</cfif>>Rechazado por Solicitante</option>
                                  <option value="85" <cfif CMPestado EQ 85>selected="selected"</cfif>>Anulados</option>
								</select>														
						    </td>
							<td align="right" class="fileLabel" nowrap >
								<strong>Descripción:&nbsp;</strong>
							</td>
							<td nowrap align="left">		
								<input type="text" name="CMPdescripcion" size="40" maxlength="100" value="#CMPdescripcion#">					
						    </td>
							<td align="right" colspan="2">
							    <input type="submit" name="btnFiltro"  value="Filtrar" class="btnFiltrar">
							</td> 
					  </tr>
					  <tr>
						  <td nowrap align="right"><strong>Fecha Desde:&nbsp;</strong></td>
						  <td>
								<cf_sifcalendario conexion="#session.DSN#" form="form1" name="fechaD" value="#fechaD#">
						  </td>
						    <td nowrap align="right"><strong>Fecha Hasta:&nbsp;</strong></td>
						  <td>
								<cf_sifcalendario conexion="#session.DSN#" form="form1" name="fechaH" value="#fechaH#">
						  </td>
					  </tr> 
					 </table>
				 </form>
			   </cfoutput>
					 <cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet">
					<cfinvokeargument name="query" 				value="#rsLista#"/>
					<cfinvokeargument name="desplegar" 			value="CMPnumero, CMPdescripcion,  CMPfechapublica, CMPfmaxofertas"/>
					<cfinvokeargument name="etiquetas" 			value="Num.<br>Proceso, Descripción, Fecha de<br>Publicación, Fecha Máxima para<br>Cotizaciones"/>
					<cfinvokeargument name="formatos" 			value="V, V, D, D"/>
					<cfinvokeargument name="align" 				value="left, left, left, left"/>
					<cfinvokeargument name="ajustar" 			value="S"/>
					<cfinvokeargument name="irA"		 		value="TiposProcesosCompras-Vista.cfm"/>
					<cfinvokeargument name="showEmptyListMsg" 	value="true"/>
					<cfinvokeargument name="keys" 				value="CMPid"/>			
					</cfinvoke>
	<cf_web_portlet_end>
<cf_templatefooter>