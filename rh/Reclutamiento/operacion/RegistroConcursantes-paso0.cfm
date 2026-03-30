<!---*******************************--->
<!--- inicializacion de variables   --->
<!---*******************************--->
<cfset Gpaso = 0>
<!---*******************************--->
<!--- área de pintado               --->
<!---*******************************--->
<table width="100%" align="center" cellpadding="0" cellspacing="0">
	<tr>
		<td valign="top">
			<cfinclude template="/rh/portlets/pNavegacion.cfm">				
			<script language="JavaScript1.2" type="text/javascript">
				function limpiar(){
					document.filtro.fRHCconcurso.value = '';
					document.filtro.fRHCdescripcion.value = '';
					document.filtro.fRHPcodigo.value = '';
					
				}
			</script>
<!---*******************************--->
<!--- Filtros de la lista           --->
<!---*******************************--->
			<table align="center" width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr><td colspan="2" align="center"></td></tr>	
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td> 
						<table align="right" width="98%" cellpadding="0" cellspacing="0" border="0">
							<tr>
							<td></td>
							<tr><td>&nbsp;</td></tr>
								<td valign="top" width="100%">
									<form style="margin:0" name="filtro" method="post">
										<input type="hidden" name="paso" value="<cfoutput>#Gpaso#</cfoutput>">
										<table width="100%" cellpadding="2" cellspacing="0" class="areaFiltro">
											<tr>
												<td width="22%" valign="middle"><strong>N&ordm;. Concurso:&nbsp;</strong> 
												<input name="fRHCconcurso" type="text" size="7" maxlength="7" onFocus="this.select();" 
												value="<cfif isdefined("form.fRHCconcurso")><cfoutput>#form.fRHCconcurso#</cfoutput></cfif>">
												</td>
												<td width="35%" colspan="1" align="left" valign="middle"><strong>Descripci&oacute;n: &nbsp;&nbsp;</strong>
													<input name="fRHCdescripcion" type="text" size="25" maxlength="50" onFocus="this.select();" 
													value="<cfif isdefined("form.fRHCdescripcion")><cfoutput>#form.fRHCdescripcion#</cfoutput></cfif>">
												</td>
												<td width="23%" colspan="1" align="left" valign="middle"><strong>C&oacute;d Puesto: &nbsp;&nbsp;</strong>
													<input name="fRHPcodigo" type="text" size="10" maxlength="10" onFocus="this.select();" 
													value="<cfif isdefined("form.fRHPcodigo")><cfoutput>#form.fRHPcodigo#</cfoutput></cfif>">
												</td>
												<td width="20%" colspan="4" align="center">
													<input type="submit" name="btnFiltrar" value="Filtrar">
													<input type="button" name="btnLimpiar" value="Limpiar" onClick="javascript:limpiar();">
													<input name="RHCcodigo" type="hidden" 
													value="<cfif isdefined("form.RHCcodigo")and (form.RHCcodigo GT 0)><cfoutput>#form.RHCcodigo#</cfoutput></cfif>">
													<input name="RHCdescripcion" type="hidden" 
													value="<cfif isdefined("form.RHCdescripcion")and (form.RHCdescripcion GT 0)><cfoutput>#form.RHCdescripcion#</cfoutput></cfif>">
													<input name="RHPcodigo" type="hidden" 
													value="<cfif isdefined("form.RHPcodigo")and (form.RHPcodigo GT 0)><cfoutput>#form.RHPcodigo#</cfoutput></cfif>">
													
												</td>
											</tr>
									  	</table>
										
									</form>
<!---*******************************--->
<!--- definición de la lista        --->
<!---*******************************--->
									<cfif isdefined("Form.flag")>
										<cfset ir = #CurrentPage# & "?flag=" & Form.flag>
									<cfelse>
										<cfset ir = #CurrentPage#>
									</cfif>
									<cfquery name="rsListaConcursos" datasource="#session.DSN#">
										select RHCconcurso,RHCdescripcion,a.RHPcodigo,coalesce(b.RHPcodigoext,b.RHPcodigo) as RHPcodigoext,RHPdescpuesto,RHCcantplazas, 1 as paso
										from RHConcursos a , RHPuestos b
										where a.Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">

										<cfif isdefined("form.fRHCconcurso") and len(trim(form.fRHCconcurso)) gt 0>
											and a.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fRHCconcurso#">
										</cfif>
										<cfif isdefined("form.fRHCdescripcion") and len(trim(form.fRHCdescripcion)) gt 0 >
											and upper(a.RHCdescripcion) like '%#Ucase(trim(form.fRHCdescripcion))#%'
										</cfif>
										<cfif isdefined("form.fRHPcodigo") and len(trim(form.fRHPcodigo)) gt 0>
											and upper(b.RHPcodigoext) like '%#Ucase(trim(form.fRHPcodigo))#%'
										</cfif>
										and a.RHPcodigo = b.RHPcodigo and a.Ecodigo = b.Ecodigo
										and a.RHCestado = 50 
										and a.RHCfcierre >= <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
										order by RHCconcurso, RHCdescripcion
									</cfquery>
									
								    <cfinvoke 
										component="rh.Componentes.pListas"
										method="pListaQuery"
										returnvariable="pListaRet">
											<cfinvokeargument name="query" value="#rsListaConcursos#"/>
											<cfinvokeargument name="desplegar" 
											value="RHCconcurso,RHCdescripcion,RHPcodigoext,RHPdescpuesto,RHCcantplazas"/>
											<cfinvokeargument name="etiquetas" 
											value="N&ordm;. Concurso, Descripci&oacute;n, C&oacute;d. Puesto,Descripci&oacute;n,Plazas"/>
											<cfinvokeargument name="formatos" value="V,V,V,V,V"/>
											<cfinvokeargument name="align" value="left,left,left,left,left"/>
											<cfinvokeargument name="ajustar" value="N"/>
											<cfinvokeargument name="debug" value="N"/>
											<cfinvokeargument name="keys" value="RHCconcurso"/> 
											<cfinvokeargument name="showEmptyListMsg" value= "1"/>
											<cfinvokeargument name="irA" value= "#ir#"/>
									</cfinvoke>
								</td>
							</tr>																									  
						</table>
					</td>																									  
				</tr>  		
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td  align="center">
						<cf_botones regresarMenu='true' exclude='Alta,Limpiar'> 
					</td>
				</tr>
			</table>
		</td>	
	</tr>
</table>	
	