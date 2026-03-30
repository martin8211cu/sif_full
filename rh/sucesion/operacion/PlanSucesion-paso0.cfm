<!---*******************************--->
<!--- inicializacion de variables   --->
<!---*******************************--->
<cfset Gpaso = 0>
<!---*******************************--->
<!--- área de pintado               --->
<!---*******************************--->
<!--- Modificado por:               --->
<!--- Rodolfo Jimenez Jara          --->
<!--- Fecha: 11/05/2005  3:00 p.m.  --->

<table width="100%" align="center" cellpadding="0" cellspacing="0">
	<tr>
		<td valign="top">
			<cfinclude template="/rh/portlets/pNavegacion.cfm">				
			<script language="JavaScript1.2" type="text/javascript">
				function limpiar(){
					document.filtro.fRHPcodigo.value = '';
					document.filtro.fRHPdescpuesto.value = '';
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
												<td width="26%" colspan="1" align="left" valign="middle"><strong>C&oacute;d Puesto: &nbsp;&nbsp;</strong>
													<input name="fRHPcodigo" type="text" size="10" maxlength="10" onFocus="this.select();" 
													value="<cfif isdefined("form.fRHPcodigo")><cfoutput>#form.fRHPcodigo#</cfoutput></cfif>">
												</td>
												<td width="47%" colspan="1" align="left" valign="middle"><strong>Descripci&oacute;n: &nbsp;&nbsp;</strong>
													<input name="fRHPdescpuesto" type="text" size="25" maxlength="50" onFocus="this.select();" 
													value="<cfif isdefined("form.fRHPdescpuesto")><cfoutput>#form.fRHPdescpuesto#</cfoutput></cfif>">
												</td>
												
												<td width="27%" colspan="4" align="center">
													<input type="submit" name="btnFiltrar" value="Filtrar">
													<input type="button" name="btnLimpiar" value="Limpiar" onClick="javascript:limpiar();">
													<input name="RHPcodigo" type="hidden" 
													value="<cfif isdefined("form.RHPcodigo")and (form.RHPcodigo GT 0)><cfoutput>#form.RHPcodigo#</cfoutput></cfif>">
													<input name="RHPdescpuesto" type="hidden" 
													value="<cfif isdefined("form.RHPdescpuesto")and (form.RHPdescpuesto GT 0)><cfoutput>#form.RHPdescpuesto#</cfoutput></cfif>">
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
									
									<cf_dbfunction name="to_char" args="a.RHPcodigo" returnvariable="vRHPcodigo">
									<cf_dbfunction name="concat"  args="'<img border=''0'' onClick=''informacion('''|#vRHPcodigo#|''');'' src=''/cfmx/rh/imagenes/findsmall.gif''>'" returnvariable="vInstruccion"  delimiters = "|">
<!---	
									'<img border=''0'' onClick=''informacion('''||<cf_dbfunction name="to_char" args="a.RHPcodigo">||''');'' src=''/cfmx/rh/imagenes/findsmall.gif''>' end as INF,
--->																
									<cfquery name="rsListaPuestos" datasource="#session.DSN#">

										select coalesce(a.RHPcodigoext,a.RHPcodigo) as RHPcodigoext,a.RHPcodigo,RHPdescpuesto , 
											case when b.Ecodigo is null then 'N' else 'S' end  as TIENE,
											case when b.Ecodigo is null then '' else #PreserveSingleQuotes(vInstruccion)# end as INF, 1  as Paso							
										from RHPuestos  a
										left outer join RHPlanSucesion b
										on a.Ecodigo = b.Ecodigo
										and a.RHPcodigo = b.RHPcodigo
										where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">										
 										  and a.RHPactivo = 1
										<cfif isdefined("form.fRHPcodigo") and len(trim(form.fRHPcodigo)) gt 0>
											and upper(a.RHPcodigoext) = <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(form.fRHPcodigo)#">
										</cfif>
										<cfif isdefined("form.fRHPdescpuesto") and len(trim(form.fRHPdescpuesto)) gt 0 >
											and upper(a.RHPdescpuesto) like '%#Ucase(trim(form.fRHPdescpuesto))#%'
										</cfif>
										order by a.RHPcodigo
									</cfquery>

								    <cfinvoke 
										component="rh.Componentes.pListas"
										method="pListaQuery"
										returnvariable="pListaRet">
											<cfinvokeargument name="query" value="#rsListaPuestos#"/>
											<cfinvokeargument name="desplegar" 
											value="RHPcodigoext,RHPdescpuesto,TIENE"/>
											<cfinvokeargument name="etiquetas" 
											value="Cód. Puesto, Descripci&oacute;n,Tiene Plan de Sucesi&oacute;n"/>
											<cfinvokeargument name="formatos" value="V,V,V"/>
											<cfinvokeargument name="align" value="left,left,left"/>
											<cfinvokeargument name="ajustar" value="N"/>
											<cfinvokeargument name="debug" value="N"/>
											<cfinvokeargument name="keys" value="RHPcodigo,TIENE,Paso"/> 
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
	
<script language="javascript" type="text/javascript">
	function informacion(llave){
		alert('Aqui muestra información del plan ')
	}
</script>