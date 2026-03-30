		<cfif isdefined("url.IDgd") and len(trim(url.IDgd)) and not isdefined("form.IDgd")>			
			<cfset form.IDgd = url.IDgd>
		</cfif>

		<cfif isdefined("url.IDdistribucion") and len(trim(url.IDdistribucion)) and not isdefined("form.IDdistribucion")>			
			<cfset form.IDdistribucion = url.IDdistribucion>
		</cfif>
		
		<cfset modo="ALTA">
		<cfif isdefined("form.IDdistribucion") and form.IDdistribucion GT 0>
			<cfset modo="CAMBIO">
		</cfif>

		<cfquery name="rsVerificaDist" datasource="#session.dsn#">
		Select count(1) as total
		from DCGDistribucion A, DCDistribucion B, Origenes C
		where A.IDgd 	= B.IDgd 
		  and A.Ecodigo = B.Ecodigo 
		  and A.Oorigen = C.Oorigen 
		  and A.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and A.IDgd    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDgd#">
		  and B.Tipo    != 5
		</cfquery>
		<cfset Lvardist=rsVerificaDist.total>

		<table width="50%" align="center" border="0" cellspacing="2" cellpadding="0">
		  <tr>
			<td valign="top" nowrap>

				<cfquery datasource="#Session.DSN#" name="rsGrpDist">
				select IDgd, DCdescripcion
				from DCGDistribucion
				where IDgd = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDgd#">
				</cfquery>
				
				<cfif modo neq "ALTA">
				
					<cfquery name="rsForm" datasource="#Session.DSN#">
						select IDdistribucion,	Descripcion, Ecodigo,	IDgd,	Tipo, EliNeg,	ts_rversion
						from DCDistribucion
						where IDdistribucion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDdistribucion#">
					</cfquery>
					
				</cfif>
				<cfquery name="rsDtr" datasource="#Session.DSN#">
					select IDdistribucion,	Ecodigo,	IDgd,	Tipo,	ts_rversion
					from DCDistribucion									
				</cfquery>
				
				<cfoutput>
				<form action="sqlDistribuciones.cfm" method="post" name="fomdist">
					<input type="hidden" name="tab" value="1">					
					<cfif modo neq "ALTA">						
						<input type="hidden" name="IDgd" value="#rsForm.IDgd#">
						<input type="hidden" name="IDdistribucion" value="#rsForm.IDdistribucion#">						
						<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" returnvariable="ts" arTimeStamp = "#rsForm.ts_rversion#"/>
						<input type="hidden" name="ts_rversion" value="#ts#">
					<cfelse>
						<input type="hidden" name="IDgd" value="#form.IDgd#">
					</cfif>
					<br>
					<table width="100%"  border="0" cellspacing="2" cellpadding="0">
					<tr>
						<td colspan="2" class="subTitulo">Distribuciones</td>
					</tr>
					<tr>
						<td width="49%"><strong> Grupo de Distribuci&oacute;n:&nbsp;</strong></td>
						<td width="51%">
						<!---
							<cfif modo eq "ALTA">
							
								<select name="cboIDgd">
								  <cfloop query="rsGrpDist"> 
									<option value="#rsGrpDist.IDgd#" <cfif modo NEQ "ALTA"> 
																			   <cfif (rsGrpDist.IDgd EQ rsForm.IDgd)>selected</cfif>
																		 </cfif>>#rsGrpDist.DCdescripcion#</option>
								  </cfloop> 
								</select>					
							
							<cfelse>--->
								#rsGrpDist.DCdescripcion#
								<input type="hidden" name="cboIDgd" value="#rsGrpDist.IDgd#">
							<!---</cfif>--->
															
						</td>
					</tr>
					<tr>
						<td><strong> Tipo:&nbsp;</strong></td>
						<td>	
							<cfif modo neq "ALTA">
								<cfif rsForm.Tipo eq 1>
									<!---Peso de la cuenta--->
									Distribución por Movimientos del Mes de las cuentas destino
								</cfif>
								<cfif rsForm.Tipo eq 2>
									<!---Peso Relativo--->
									Distribución por Movimientos del Mes X porcentaje dado
								</cfif>
								<cfif rsForm.Tipo eq 3>
									<!---Equivalente--->
									Distribución Equitativa de las cuentas destino
								</cfif>	
								<cfif rsForm.Tipo eq 4>
									<!---Distribución Directa--->
								</cfif>
								<cfif rsForm.Tipo eq 5>
									<!---Distribución por Conductores--->
									Distribución por Peso dado
								</cfif>																								
								<input type="hidden" name="cboTipo" value="#rsForm.Tipo#">
							<cfelse>
								<select name="cboTipo">
								<option value="1" <cfif modo neq "ALTA" and rsForm.Tipo eq 1>selected</cfif>>1 - Distribución por Movimientos del Mes de las cuentas destino</option>
								<option value="2" <cfif modo neq "ALTA" and rsForm.Tipo eq 2>selected</cfif>>2 - Distribución por Movimientos del Mes X porcentaje dado</option>
								<option value="3" <cfif modo neq "ALTA" and rsForm.Tipo eq 3>selected</cfif>>3 - Distribución Equitativa de las cuentas destino</option>
								<option value="4" <cfif modo neq "ALTA" and rsForm.Tipo eq 4>selected</cfif>>4 - Distribución por Peso dado</option>
								<cfif isdefined("Lvardist") and Lvardist eq 0>
									<option value="5" <cfif modo neq "ALTA" and rsForm.Tipo eq 5>selected</cfif>>5 - Distribución por Conductores</option>
								</cfif>
								</select>											
							</cfif>	
						</td>
					</tr>
					<tr>
						<td><strong> Descripci&oacute;n:&nbsp;</strong></td>
						<td>	
							<input type="text" name="txtdesc" maxlength="30" value="<cfif modo neq 'ALTA' and rsForm.Descripcion neq ''>#rsForm.Descripcion#</cfif>">
						</td>
					</tr>
					<tr>
						<td><strong>Descartar saldos negativos:&nbsp;</strong></td>
						<td>	
							<input type="checkbox" name="chkdesc" value="<cfif modo neq 'ALTA' and rsForm.EliNeg neq ''>#rsForm.EliNeg#</cfif>" <cfif modo neq 'ALTA' and rsForm.EliNeg eq 'S'>checked</cfif>>
						</td>
					</tr>
					</table>
					<br>

					<cfif modo neq "ALTA">
						<cfset funcbtndist = "return funcCambiodist()">
						<cfif isdefined("Lvardist") and Lvardist eq 0>
							<cf_botones modo="#modo#" exclude="Nuevo" include="Regresar,Importar" functions="#funcbtndist#">
						<cfelse>
							<cf_botones modo="#modo#" include="Regresar,Importar" functions="#funcbtndist#">
						</cfif>
					<cfelse>
						<cfset funcbtndist = "return funcAltadist()">						
						<cf_botones modo="#modo#" include="Regresar" functions="#funcbtndist#">
					</cfif>
					
				</form>
				
				<script language="javascript" type="text/javascript">
			
					document.fomdist.txtdesc.description = "#JSStringFormat('Descripcion')#";
					function habilitarValidacion(){		
						document.fomdist.txtdesc.required = true;
					}
					function desahabilitarValidacion(){
						document.fomdist.txtdesc.required = false;
					}
					habilitarValidacion();
				
				function funcRegresar()
				{
					document.fomdist.action = 'lstDistribuciones.cfm';
					document.fomdist.submit();
				}
				
				function funcImportar()
				{
					document.fomdist.action = 'importarDC_Cuentas.cfm';
					document.fomdist.submit();
				}
				function funcCambiodist()
				{
					if (document.fomdist.txtdesc.required == true && document.fomdist.txtdesc.value == '')
					{
						alert("ERROR: \n\n -Es necesario digitar una descripción");
						return false;
					}
				}
				function funcAltadist()
				{
					if (document.fomdist.txtdesc.required == true && document.fomdist.txtdesc.value == '')
					{
						alert("ERROR: \n\n -Es necesario digitar una descripción");
						return false;
					}
				}				
				</script>
				</cfoutput>	

			</td>	
		  </tr>
		</table>