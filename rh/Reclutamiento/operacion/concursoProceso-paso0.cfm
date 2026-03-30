<cfinclude template="/rh/portlets/pNavegacion.cfm">				
<script language="JavaScript" src="/cfmx/rh/js/utilesMonto.js"></script>
<table width="100%" align="center" cellpadding="0" cellspacing="0">
	<tr>
		<td valign="top">
			<cfoutput>
				<table align="center" width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr><td colspan="2" align="center"></td></tr>	
					<tr><td colspan="2">&nbsp;</td></tr>
					<tr>
						<td valign="top" width="100%">
							<form style="margin:0" name="filtro" method="post">
								<table width="100%" cellpadding="2" cellspacing="0" class="areaFiltro">
									<tr>
										<td valign="middle"><strong>N&ordm;. Solicitud:&nbsp;</strong> 
											<input name="fRHCconcurso" type="text" size="6" maxlength="5" 
											align="middle" onFocus="this.select();" 
											onKeyUp="javascript: if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}};"
											value="<cfif isdefined("form.fRHCconcurso")>#form.fRHCconcurso#</cfif>">
										</td>
										<td valign="middle" align="left">
											<strong>&nbsp;C&oacute;digo de Concurso: &nbsp;&nbsp;</strong>
											<input name="fRHCcodigo" type="text" size="6" maxlength="5" align="middle" 
											onFocus="this.select();" 
											value="<cfif isdefined("form.fRHCcodigo")>#form.fRHCcodigo#</cfif>">
										</td>
										<td align="left" valign="middle" colspan="2">
											<strong>C&oacute;digo de puesto: &nbsp;&nbsp;</strong>
											<input name="fRHPcodigo" type="text" size="10" maxlength="10" 
											onFocus="this.select();" 
											value="<cfif isdefined("form.fRHPcodigo")>#form.fRHPcodigo#</cfif>">
										</td>
										<cfif not isdefined("Form.flag")>
											<!--- Estado --->
											<td valign="middle" align="left"><strong>&nbsp;Estado: &nbsp;&nbsp;</strong>
												<select name="fLAestado" id="fLAestado">
													<option value="2">-- Todos --</option>
													<option value="10">Solicitado</option>
													<option value="15">Verificado</option>
												</select>
											</td>
										</cfif>								 
										<td colspan="4" align="center">
											<input type="submit" name="btnFiltrar" value="Filtrar">
											<input type="button" name="btnLimpiar" value="Limpiar" onClick="javascript:limpiar();">
											<input name="RHCcodigo" type="hidden" 
											value="<cfif isdefined("form.RHCcodigo")and (form.RHCcodigo GT 0)>#form.RHCcodigo#</cfif>">
											<input name="RHCconcurso" type="hidden" 
											value="<cfif isdefined("form.RHCconcurso")and (form.RHCconcurso GT 0)>#form.RHCconcurso#</cfif>">
											<input name="pasoante" type="hidden" value="0">
										</td>
									</tr>
								</table>
							</form>
						</td>
					</tr>
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td>
							<form name="lista" method="post">
								<table align="right" width="98%" cellpadding="0" cellspacing="0" border="0">
									<tr>
										<td>
											<cfif isdefined("Form.flag")>
												<cfset ir = #CurrentPage# & "?flag=" & Form.flag>
											<cfelse>
												<cfset ir = #CurrentPage#>
											</cfif>
											<cfset navegacion = "">
											<cfquery name="rsListaConcursos" datasource="#session.DSN#">
												select a.RHCconcurso, 
													{fn concat(<cf_dbfunction name="to_char" args="a.RHCconcurso">,{fn concat(' - ',a.RHCcodigo)})} as concurso,
													<!---<cf_dbfunction name="to_char" args="a.RHCconcurso"> || ' - ' || a.RHCcodigo as concurso, --->
													a.RHPcodigo,coalesce(b.RHPcodigoext,b.RHPcodigo) as RHPcodigoext,b.RHPdescpuesto, 1 as paso 
												from RHConcursos a inner join RHPuestos b
												  on a.RHPcodigo = b.RHPcodigo and
													 a.Ecodigo   = b.Ecodigo
												where a.Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
												<cfif isdefined("form.flag")>
												  and a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
												</cfif>
												<cfif isdefined("form.fRHCconcurso") and len(trim(form.fRHCconcurso)) gt 0>
												  and a.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fRHCconcurso#">
												</cfif>
												<cfif isdefined("form.fRHCcodigo") and len(trim(form.fRHCcodigo)) gt 0>
												  and upper(a.RHCcodigo) like '%#Ucase(trim(form.fRHCcodigo))#%'
												</cfif>
												<cfif isdefined("form.fLAestado") and len(trim(form.fLAestado)) gt 0 
													  and (form.fLAestado NEQ 2)>
												  and  RHCestado = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fLAestado#">
												<cfelseif isdefined("form.flag")>
												  and  RHCestado = 0
												<cfelse>
												  and  RHCestado in (10,15)
												</cfif>
												<cfif isdefined("form.fRHPcodigo") and len(trim(form.fRHPcodigo)) gt 0> 
												  and upper(b.RHPcodigoext) like '%#Ucase(trim(form.fRHPcodigo))#%'
												</cfif> 
												order by RHCconcurso, RHCdescripcion
											</cfquery> 
		
											<cfinvoke 
												component="rh.Componentes.pListas"
												method="pListaQuery"
												returnvariable="pListaRet">
													<cfinvokeargument name="query" value="#rsListaConcursos#"/>
													<cfinvokeargument name="desplegar" value="concurso,  RHPcodigoext, RHPdescpuesto"/>
													<cfinvokeargument name="etiquetas" 
													value="N&ordm;. Solicitud - Concurso, C&oacute;digo de Puesto, Descripci&oacute;n"/>
													<cfinvokeargument name="formatos" value="S, S, S"/>
													<cfinvokeargument name="align" value="left, left, left"/>
													<cfinvokeargument name="ajustar" value="S"/>
													<cfinvokeargument name="debug" value="N"/>
													<cfinvokeargument name="keys" value="RHCconcurso"/> 
													<cfinvokeargument name="showEmptyListMsg" value= "1"/>
													<cfinvokeargument name="checkboxes" value="S"/>
													<cfinvokeargument name="incluyeform" value="false">
													<cfinvokeargument name="formname" value="lista"/>
													<cfinvokeargument name="botones" value="Nuevo, Eliminar"/>
													<cfinvokeargument name="irA" value= "#ir#"/>
											</cfinvoke>
											<cfset modo="cambio">
										</td>
									</tr>
									<tr><td>&nbsp;</td></tr>
									<tr>
										<td>
											<!--- <cf_botones modo="#modo#" regresarMenu= "true" exclude='Cambio' formName="lista" > --->
										</td>
									</tr>			
								</table>
							</form>																  
						</td>				
					</tr>  		
				</table>
			</cfoutput>
		</td>	
	</tr>
</table>	

<cf_qforms form="lista">
<script language="JavaScript1.2" type="text/javascript">
	function limpiar(){
		document.filtro.fLAestado.value = '2';
		document.filtro.fRHPcodigo.value = '';
		document.filtro.fRHCconcurso.value = '';
		document.filtro.fRHCcodigo.value = '';
	}
	function estado(){
		document.filtro.fLAestado.value = '#fLAestado#';
	}
	
	function funcNuevo(){
		document.lista.PASO.value=1;
	}
	function funcEliminar(){
		document.lista.PASO.value=0;
	}

</script>