<!--- Navegacion de la lista --->

<cfif isdefined("url.DEid") and not isdefined("form.DEid")>
	<cfset form.DEid = Url.DEid>
</cfif>
<cfif isdefined("url.fechaI") and not isdefined("form.fechaI")>
	<cfset form.fechaI = Url.fechaI>
</cfif>
<cfif isdefined("url.fechaF") and not isdefined("form.fechaF")>
	<cfset form.fechaF = Url.fechaF>
</cfif>
<!---	<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
	<cfparam name="PageNum_rs" default="1">
	--->
	<cfquery name="rs1" datasource="#session.DSN#">
		select cp.CPid,cp.CPmes,cp.CPperiodo,cp.Ecodigo
		from CalendarioPagos cp
		where   cp.CPdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fechaI)#">
				and cp.CPhasta <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fechaF)#">
				and Ecodigo=#session.Ecodigo#
	</cfquery>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr > 
	  <td> 
	
		<cfif isDefined("Form.DEid") and len(trim(Form.DEid)) gt 0>
				<table width="100%" border="0" cellpadding="0" cellspacing="0" align="center">
				<tr bgcolor="#EEEEEE" style="padding: 3px;"><td align="center"><font size="3"><b><cf_translate key="LB_ConstanciaDeSalarioEnPeriodoEspecial">Constancia de Salario en Periodo Especial</cf_translate></b></font></td></tr>
	
				  <tr>
					<td>
						<cfinclude template="/rh/portlets/pEmpleado.cfm">
					</td>
				  </tr>
				  <tr>
					<td>&nbsp;
					</td>
				  </tr>
				  <tr>
					<td align="center">
						<table width="85%" cellpadding="3" cellspacing="0">
							<tr>
								<td class="tituloListas"><cf_translate key="LB_Periodo">Periodo</cf_translate></td>
								<td class="tituloListas"><cf_translate key="LB_Mes">Mes</cf_translate></td>
								<td class="tituloListas"><div align="right"><cf_translate key="LB_Salario">Salario</cf_translate></div></td>
								<td class="tituloListas"><div align="right"><cf_translate key="LB_Incidencias">Incidencias</cf_translate></div></td>
								<td class="tituloListas"><div align="right"><cf_translate key="LB_IncidenciasExcluidas">Incidencias Excluidas</cf_translate></div></td>
								<td class="tituloListas"><div align="right"><cf_translate key="LB_EspecialesIncluidos">Especiales Incluidos</cf_translate></div></td>
								<td class="tituloListas"><div align="right"><cf_translate key="LB_EspecialesExcluidos">Especiales Excluidos</cf_translate></div></td>
							</tr>
				
							<!--- Query para manejar resultados--->
							<cfset rsResultado = QueryNew("DEid,CPperiodo,CPmes,Salario")>
							<cfset arreglo     = ArrayNew(1)>
				
							<cfset index = 0 >
						<!---	<cfoutput query="rs" startrow="#StartRow_lista#" maxrows="#MaxRows_rs#">--->
						<cfloop query="rs1">
							<cfquery name="rs2" datasource="#session.DSN#">
								 select min(coalesce(sum(i.ICmontores),0.00)) as Incidencias
									  from HIncidenciasCalculo i, CalendarioPagos cp, CIncidentes ci 
									  where 
										i.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
										and cp.CPid = i.RCNid
										and cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
										and cp.CPdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fechaI)#">
										and cp.CPhasta <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fechaF)#">				
										and cp.CPperiodo = #rs1.CPperiodo#
										and cp.CPmes = #rs1.CPmes#
										and cp.Ecodigo=#rs1.Ecodigo#
										and cp.CPtipo = 0
										and ci.CIid = i.CIid
										and cp.CPid=#rs1.CPid#
										<cfif isdefined("form.CIidList") and len(trim(form.CIidList)) NEQ 0>
										   and ci.CIid not in (#Form.CIidList#)
										</cfif>
										group by cp.CPperiodo, cp.CPmes
							</cfquery>
							<cfquery name="rs3" datasource="#session.dsn#">
								  select min(coalesce(sum(i.ICmontores),0.00)) as IncidenciasExcluidas
								  from HIncidenciasCalculo i, CalendarioPagos cp, CIncidentes ci 
								  where 
									i.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
									and cp.CPid = i.RCNid
									and cp.CPperiodo = #rs1.CPperiodo#
									and cp.CPmes = #rs1.CPmes#
									and cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
									and cp.CPdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fechaI)#">
									and cp.CPhasta <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fechaF)#">
									and cp.CPtipo = 0
									and ci.CIid = i.CIid
									and cp.CPid=#rs1.CPid#
									<cfif isdefined("form.CIidList") and len(trim(form.CIidList)) NEQ 0>
									   and ci.CIid in (#Form.CIidList#)
									<cfelse>
										and ci.CIid = -1
									</cfif> 
									group by cp.CPperiodo, cp.CPmes               
							</cfquery>
							
							<cfquery name="rs4" datasource="#session.dsn#">
								select min(coalesce(sum(i.ICmontores),0.00)) as CalculosEspecialesI
								from HIncidenciasCalculo i, CalendarioPagos cp, CIncidentes ci 
								where i.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
								and cp.CPid = i.RCNid
								and cp.CPperiodo = #rs1.CPperiodo#
								and cp.CPmes = #rs1.CPmes#
								and cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								and cp.CPdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fechaI)#">
								and cp.CPhasta <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fechaF)#">
								and cp.CPtipo > 0
								and ci.CIid = i.CIid
								and cp.CPid=#rs1.CPid#
								<cfif isdefined("form.CIidList") and len(trim(form.CIidList)) NEQ 0>
									and ci.CIid not in (#Form.CIidList#)
								</cfif>	
								group by cp.CPperiodo, cp.CPmes
							</cfquery>
							
							<cfquery name="rs5" datasource="#session.dsn#">
								select min(coalesce(sum(i.ICmontores),0.00))  as CalculosEspecialesE
								  from HIncidenciasCalculo i, CalendarioPagos cp, CIncidentes ci 
								  where i.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
									and cp.CPid = i.RCNid
									and cp.CPperiodo = #rs1.CPperiodo#
									and cp.CPmes = #rs1.CPmes#
									and cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
									and cp.CPdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fechaI)#">
									and cp.CPhasta <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fechaF)#">
									and cp.CPtipo > 0
									and ci.CIid = i.CIid
									and cp.CPid=#rs1.CPid#
									<cfif isdefined("form.CIidList") and len(trim(form.CIidList)) NEQ 0>
									   and ci.CIid in (#Form.CIidList#)
									<cfelse>
										and ci.CIid = -1
									</cfif>
									group by cp.CPperiodo, cp.CPmes
							</cfquery>
							
							<cfquery name="rs" datasource="#session.DSN#">
							 select 
							   b.CPperiodo as CPperiodo, 
							   b.CPmes as CPmes, 
							   sum(d.SEsalariobruto) as Salario,
							  <cfif isdefined('rs2') and rs2.recordcount gt 0> #rs2.Incidencias#<cfelse>0.00</cfif> as Incidencias,
							  <cfif isdefined('rs3') and rs3.recordcount gt 0> #rs3.IncidenciasExcluidas#<cfelse>0.00</cfif> as IncidenciasExcluidas,	
							  <cfif isdefined('rs4') and rs4.recordcount gt 0> #rs4.CalculosEspecialesI#<cfelse>0.00</cfif> as CalculosEspecialesI,		
							  <cfif isdefined('rs5') and rs5.recordcount gt 0> #rs5.CalculosEspecialesE#<cfelse>0.00</cfif> as CalculosEspecialesE,
								d.DEid as DEid
								from HSalarioEmpleado d, CalendarioPagos b
								where d.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
								  and b.CPid = d.RCNid
								  and b.CPid=#rs1.CPid#
								  and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								  and b.CPdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fechaI)#">
								  and b.CPhasta <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fechaF)#">
								 
								group by b.CPperiodo, b.CPmes,d.DEid	
							</cfquery>
							<cfoutput>
								<cfif rs.recordcount gt 0>
								<cfset index = index + 1 >
								<tr class="<cfif rs.CurrentRow MOD 2>listaNon<cfelse>listaPar</cfif>" onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif rs.CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';">
									<td nowrap >#rs.CPperiodo#</td>
									<td nowrap >#rs.CPmes#</td>
									<td nowrap align="right">#LSNumberFormat(rs.Salario, ',L.00')#</td>
									<td nowrap ><div align="right">#LSNumberFormat(rs.Incidencias, ',L.00')#</div></td>
									<td nowrap ><div align="right">#LSNumberFormat(rs.IncidenciasExcluidas, ',L.00')#</div></td>
									<td nowrap ><div align="right">#LSNumberFormat(rs.CalculosEspecialesI, ',L.00')#</div></td>
									<td nowrap ><div align="right">#LSNumberFormat(rs.CalculosEspecialesE, ',L.00')#</div></td>
								</tr>

								<cfset arreglo[index] = ArrayNew(1) >
								<cfset arreglo[index][1] = rs.DEid >
								<cfset arreglo[index][2] = rs.CPperiodo >
								<cfset arreglo[index][3] = rs.CPmes >
								<cfset arreglo[index][4] = rs.Salario >
								</cfif>
							</cfoutput>
						</cfloop>
							<cfloop from="#ArrayLen(arreglo)#" to="1" index="i" step="-1">
								<cfset fila = QueryAddRow(rsResultado, 1)>
								<cfset tmp  = QuerySetCell(rsResultado, "DEid",      arreglo[i][1]) >
								<cfset tmp  = QuerySetCell(rsResultado, "CPperiodo",     arreglo[i][2] )>
								<cfset tmp  = QuerySetCell(rsResultado, "CPmes",    arreglo[i][3])>
								<cfset tmp  = QuerySetCell(rsResultado, "Salario", arreglo[i][4]) >
							</cfloop>
				
<!---
							<cfoutput>
								<tr>
									<td align="center" colspan="6">
										<table width="50%" align="center">
											<tr>
												<td align="center">
													<cfif PageNum_rs GT 1>
														<a href="#CurrentPage#?PageNum_rs=1#QueryString_rs#"><img src="/cfmx/rh/imagenes/First.gif" border=0></a>
													</cfif>
													<cfif PageNum_rs GT 1>
														<a href="#CurrentPage#?PageNum_rs=#Max(DecrementValue(PageNum_rs),1)##QueryString_rs#"><img src="/cfmx/rh/imagenes/Previous.gif" border=0></a>
													</cfif>
													<cfif PageNum_rs LT TotalPages_rs>
														<a href="#CurrentPage#?PageNum_rs=#Min(IncrementValue(PageNum_rs),TotalPages_rs)##QueryString_rs#"><img src="/cfmx/rh/imagenes/Next.gif" border=0></a>
													</cfif>
													<cfif PageNum_rs LT TotalPages_rs>
														<a href="#CurrentPage#?PageNum_rs=#TotalPages_rs##QueryString_rs#"><img src="/cfmx/rh/imagenes/Last.gif" border=0></a>
													</cfif>
												</td>
											</tr>
										</table>	
									</td>	
								</tr>
							</cfoutput>
--->							
						
					</table>
						
					</td>
				  </tr>
					<cfif isdefined("url.Imprimir") and url.Imprimir>
						<tr > 
							<td colspan="5" align="center">
								<strong>
									------------------------------
									<cf_translate key="LB_FinDelReporte">Fin del Reporte</cf_translate>
									--------------------------------------
								</strong>	&nbsp;
							</td>
						</tr>  
					</cfif> 
				</table>
		<cfelse>
			<p class="tituloAlterno"><cf_translate key="LB_DebeSeleccionarUnEmpleado">Debe Seleccionar un Empleado</cf_translate>.</p>
		</cfif>
	  </td>
	</tr>
</table>
