<cfparam name="form.ubicacion" default="">
<cfparam name="form.Ocodigo" default="">
<cfparam name="form.GOid"    default="">
<cfparam name="form.GEid"    default="">
<cfparam name="form.AVid"    default="">

<!--- Oficinas de la Empresa --->
<cfquery name="rsOficinas" datasource="#session.DSN#">
	select Ocodigo, Odescripcion
	from Oficinas
	where Ecodigo = #session.ecodigo#
	order by Odescripcion
</cfquery>
<!--- Grupos de Empresas --->
<cfquery name="rsGE" datasource="#session.DSN#">
	select ge.GEid, ge.GEnombre
	from AnexoGEmpresa ge
		join AnexoGEmpresaDet gd
			on ge.GEid = gd.GEid
	where ge.CEcodigo = #session.CEcodigo#
	  and gd.Ecodigo = #session.ecodigo#
	order by ge.GEnombre
</cfquery>

<cf_templateheader title="Costos e Ingresos Autom&aacute;ticos">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Consulta de Costos e Ingresos Autom&aacute;ticos'>
		
		
	<cfoutput>
		<form method="post" name="form1" action="CosIng-form.cfm"> 
			<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
				<tr>
					<td colspan="2"><cfinclude template="/sif/portlets/pNavegacion.cfm"></td>
				</tr>
				<tr>
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr>
					<td width="40%" valign="top">
						<table width="100%">
							<tr valign="top">
								<td valign="top">	
									<cf_web_portlet_start border="true" titulo="Consulta Detallada de Costos e Ingresos Autom&aacute;ticos" skin="info1">
										<div align="justify">
										  <p>Esta consulta muestra el detalle de los Costos e Ingresos Autom&aacute;ticos generados de las diferentes transacciones realizadas.</p>
								    	</div>
									<cf_web_portlet_end>
								</td>
							</tr>
						</table>  
					</td>
					<td width="60%" valign="top">
						<table width="100%" border="0" cellpadding="1" cellspacing="0" align="center">
							<tr>
							  	<td align="right" nowrap><strong>Empresa u Oficina :</strong>&nbsp;</td>
							  	<td nowrap>
							  		<select name="ubicacion" >
									<option value="-1" <cfif -1 eq form.Ocodigo> selected</cfif>> - Variables de Empresa - </option>
									<option value="1" > #session.enombre#</option>
									<cfif rsGE.RecordCount>
										<optgroup label="Grupos de Empresas">
									  	<option value="ge," <cfif form.ubicacion eq 'ge,'>selected</cfif> >(Todos los grupos de empresas)</option>
									  	<cfloop query="rsGE">
											<option value="ge,#rsGE.GEid#" <cfif rsGE.GEid EQ form.GEid> selected</cfif>> #rsGE.GEnombre#</option>
									  	</cfloop>
									  	</optgroup>
									</cfif>
									<optgroup label="Oficinas">
									<option value="of," <cfif form.ubicacion eq 'of,'>selected</cfif> >(Todas las oficinas)</option>
									<cfloop query="rsOficinas">
										<option value="of,#rsOficinas.Ocodigo#" <cfif rsOficinas.Ocodigo EQ form.Ocodigo> selected</cfif>> #rsOficinas.Odescripcion#</option>
									</cfloop>
									</optgroup>
								  </select>
								</td>
							  	<td width="1%">&nbsp;</td>
						  	</tr>
                            
                            <tr>
								<td align="right" nowrap><strong>Gasto :</strong>&nbsp;</td>						
							 	<td nowrap width="1%">							
                                	<cf_conlis
                                        Campos="Cid,Ccodigo,Cdescripcion"
                                        Desplegables="N,S,S"
                                        Modificables="N,S,N"
                                        Size="0,10,40"
                                        tabindex="5"
                                        Title="Lista de Gastos"
                                        Tabla="Conceptos"
                                        Columnas="Cid, Ccodigo, Cdescripcion"
                                        Filtro=" Ecodigo = #Session.Ecodigo# and Ctipo = 'G'"
                                        Desplegar="Ccodigo,Cdescripcion"
                                        Etiquetas="Codigo,Descripcion"
                                        filtrar_por="Ccodigo,Cdescripcion"
                                        Formatos="S,S"
                                        Align="left,left"
                                        form="form1"
                                        Asignar="Cid,Ccodigo,Cdescripcion"
                                        Asignarformatos="S,S,S"											
                                    /> 	
								</td>
							</tr>

                            <tr>
								<td align="right" nowrap><strong>Ingreso :</strong>&nbsp;</td>						
							 	<td nowrap width="1%">							
		                           <cf_conlis
                                        Campos="Cid2,Ccodigo2,Cdescripcion2"
                                        Desplegables="N,S,S"
                                        Modificables="N,S,N"
                                        Size="0,10,40"
                                        tabindex="5"
                                        Title="Lista de Ingresos"
                                        Tabla="Conceptos"
                                        Columnas="Cid as Cid2, Ccodigo as Ccodigo2, Cdescripcion as Cdescripcion2"
                                        Filtro=" Ecodigo = #Session.Ecodigo# and Ctipo = 'I'"
                                        Desplegar="Ccodigo2,Cdescripcion2"
                                        Etiquetas="Codigo,Descripcion"
                                        filtrar_por="Ccodigo,Cdescripcion"
                                        Formatos="S,S"
                                        Align="left,left"
                                        form="form1"
                                        Asignar="Cid2,Ccodigo2,Cdescripcion2"
                                        Asignarformatos="S,S,S"											
                                    /> 	 
								</td>
							</tr>
                        
							<tr align="left">
							  <td width="50%" nowrap align="right"><strong>De la Fecha :</strong>&nbsp;</td>
							  <td width="50%" nowrap><cf_sifcalendario name="fechai" value="" tabindex="1"></td>
							  <td width="1%">&nbsp;</td>
						    </tr>

							<tr align="left">
							  <td nowrap align="right"><strong>Hasta :</strong>&nbsp;</td>
							  <td width="50%" nowrap><div align="left"><cf_sifcalendario name="fechaf" value="" tabindex="1"></div></td>
							  <td width="1%">&nbsp;</td>
						    </tr>
                            
                            <tr>
                            	<td width="11%" align="right" nowrap><strong>Ctro.Funcional :</strong>&nbsp;</td>
                              	<td width="21%" nowrap class="fileLabel">
                                	<cfif isdefined("Form.fCFid") and Len(Trim(Form.fCFid))>
                                  		<cfquery name="rscfuncional" datasource="#Session.DSN#">
                                        	select CFid as fCFid, CFcodigo, CFdescripcion 
                                        	from CFuncional where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                                            and CFid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.fCFid#">
                                  		</cfquery>
                                    	<cf_rhcfuncional id="fCFid" form="form1" query="#rscfuncional#">
                                  	<cfelse>
                                    	<cf_rhcfuncional id="fCFid" form="form1">
                                	</cfif>
                              	</td>
							</tr>

                           	<tr>
								<td align="right" nowrap><strong>Moneda :</strong>&nbsp;</td>
								<td align="left">
	          				    <cf_sifmonedas  FechaSugTC="#LSDateformat(Now(),'DD/MM/YYYY')#" form="form1" Mcodigo="McodigoOri"  tabindex="1" Todas="S">
    	                        </td> 
						  	</tr>
                            
                            <tr>
								<td align="right" nowrap><strong>Resumido :</strong>&nbsp;</td>
								<td align="left">
	          				    <input type="checkbox" tabindex="6" id="resumido" name="resumido">
    	                        </td> 
						  	</tr>
                             	
							<tr>
							  <td colspan="3" align="center"><input type="submit" value="Consultar" name="Reporte" id="Reporte">
							    <input type="button" name="Limpiar" value="Limpiar" onClick="javascript: limpiar();"></td>
								</tr>
						</table>
					</td>
				</tr>
			</table>
		 </form>
		<script language="JavaScript" type="text/javascript">
			
			
			function limpiar() {
				document.form1.ubicacion.value = "";
				document.form1.Cid.value = "";
				document.form1.Ccodigo.value = "";
				document.form1.Cdescripcion.value = "";
				document.form1.Cid2.value = "";
				document.form1.Ccodigo2.value = "";
				document.form1.Cdescripcion2.value = "";
				document.form1.CFdescripcion.value = "";
				document.form1.CFcodigo.value = "";
				document.form1.fechai.value = "";
				document.form1.fechaf.value = "";
				document.form1.fCFid.value = "";
			}
		</script>
		
		 
		 </cfoutput>	
		<cf_web_portlet_end>
	<cf_templatefooter>