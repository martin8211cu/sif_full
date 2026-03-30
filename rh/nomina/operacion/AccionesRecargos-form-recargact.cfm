<cfif isdefined ('rsAccion') and not isdefined ('form.DEid')>
	<cfset Form.DEid=rsAccion.DEid>
</cfif>
<cfif isdefined('Form.DEid') and len(trim(Form.DEid))>
	<cfquery name="rsRecargoPlazas" datasource="#session.DSN#">
	/*Este es para sacar los detalles de la linea de tiempo de Recargo*/
	select a.LTRid, a.LTdesde as desde, a.LThasta as hasta, a.LTsalario as SalarioNominal, 
			((a.LTsalario/coalesce( convert(numeric(30,10),t.FactorDiasSalario) , (30.0) ))*30) as SalarioMensual, 
			((a.LTsalario/coalesce( convert(numeric(30,10),t.FactorDiasSalario) , (30.0) ))*360) as SalarioAnual, 
			((a.LTsalario/coalesce( convert(numeric(30,10),t.FactorDiasSalario) , (30.0) ))*1) as SalarioDiario, 
			p.RHPdescripcion, cf.CFdescripcion 
	from LineaTiempoR a 
		inner join TiposNomina t 
			on t.Ecodigo = a.Ecodigo 
			and t.Tcodigo = a.Tcodigo 
		inner join RHPlazas p 
			 on p.RHPid = a.RHPid 
			inner join CFuncional cf 
				on cf.CFid = p.CFid 
			inner join RHPuestos e 
				on e.RHPcodigo = p.RHPpuesto 
				and e.Ecodigo = p.Ecodigo 
		
	where a.DEid = #Form.DEid#
	order by LTdesde desc
	</cfquery>
	
	
	<cfquery name="rsRecargoPlazasAll" datasource="#Session.DSN#">
		select a.LTRid, 
			   c.CSid, 
			   c.CScodigo, 
			   c.CSdescripcion,
			   c.CSusatabla,
			   c.CSsalariobase,
			   b.DLTtabla, 
			   coalesce(b.DLTunidades, 0.00) as DLTunidades, 
			   b.DLTmonto as DLTmontobase,
			   coalesce(b.DLTmonto, 0.00) as DLTmonto, 
			   coalesce(c.CIid, -1) as CIid
			   ,e.RHPcodigo
			   ,e.RHPdescpuesto
			   ,cf.CFcodigo
			   ,cf.CFdescripcion
			   ,p.RHPdescripcion
			   ,p.RHPcodigo as RHPPcodigo
			   ,a.LTporcplaza
			   ,a.LTporcsal
			   ,a.LTdesde as desde
			   ,a.LThasta as hasta
               ,a.RHPid
		from 
			LineaTiempoR a	
			 inner join DLineaTiempoR b
			 	on a.LTRid =  b.LTRid
			 inner join ComponentesSalariales c
				on c.CSid = b.CSid
			 inner join RHPlazas p 
				 on p.RHPid = a.RHPid 
			 inner join CFuncional cf 
					on cf.CFid = p.CFid 
			 inner join RHPuestos e 
					on e.RHPcodigo = p.RHPpuesto 
					and e.Ecodigo = p.Ecodigo 
			 
		where a.DEid = #Form.DEid#
          and (<cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaActRecI#"> between LTdesde and LThasta or
          		<cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaActRecF#"> between LTdesde and LThasta)
		order by c.CSorden, c.CScodigo, c.CSdescripcion
	</cfquery>
	
	<!---diferentes plazas de recargo--->
	<cfquery name="rsLineasRecargo" dbtype="query">	
		select distinct LTRid from rsRecargoPlazasAll
	</cfquery>
	
	<cfif rsLineasRecargo.RecordCount GT 0>
	<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="sectionTitle" style="padding-left: 5px; padding-right: 5px;">
		<tr><td class="#Session.Preferences.Skin#_thcenter"><div align="center"><cf_translate key="LB_Recargos">Recargos</cf_translate></div></td></tr>
		<cfloop query="rsLineasRecargo">
			<cfset id = rsLineasRecargo.LTRid>
			<cfquery name="rsRecargoPlazas" dbtype="query">
				select * from rsRecargoPlazasAll where LTRid = #id#
			</cfquery>
			<cfquery name="rsSumComponentesAccionR" dbtype="query">
				select sum(DLTmonto) as Total 
				from rsRecargoPlazas
				where CIid = -1
			</cfquery>
			<cfset vTotalRec = rsSumComponentesAccionR.Total >
			<tr >
				<td>
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr bgcolor="##E4E4E4" height="20">
							<td class="fileLabel" nowrap width="5%" <cfif not(isdefined("Request.ConsultaAcciones") and Request.ConsultaAcciones EQ 1) and not isdefined('Lvar_RecargosC')>style="cursor:pointer"</cfif>>
								<img  id="menos#id#" src="../../imagenes/menos.gif" style="cursor:pointer" onclick="javascript: document.getElementById('TR#id#').style.display='none'; document.getElementById('mas#id#').style.display=''; document.getElementById('menos#id#').style.display='none'; "/>
								<img style ="display:none;cursor:pointer" id="mas#id#" src="../../imagenes/mas.gif" onclick="javascript: document.getElementById('TR#id#').style.display=''; document.getElementById('menos#id#').style.display=''; document.getElementById('mas#id#').style.display='none'; "/>
								<strong><cf_translate key="LB_Plaza_RHR">Plaza</cf_translate></strong>&nbsp;
							</td>
							<td align="left"  width="30%" <cfif not(isdefined("Request.ConsultaAcciones") and Request.ConsultaAcciones EQ 1) and not isdefined('Lvar_RecargosC')>style="cursor:pointer" onclick="javascript:document.form1.indicaRecargo.value = 1; document.form1.LTidRecargo.value='#rsRecargoPlazas.LTRid#';document.form1.CambioAccion.value='1';document.form1.submit();"</cfif>>
                            	#rtrim(rsRecargoPlazas.RHPPcodigo)#&nbsp;-&nbsp;#rsRecargoPlazas.RHPdescpuesto#</td>
							<td nowrap  width="15%">
                            	<strong><cf_translate key="LB_%Porcentaje_de_Plaza">% Plaza</cf_translate>:&nbsp;</strong>
								<cfif rsRecargoPlazas.LTporcplaza NEQ "">#LSCurrencyFormat(rsRecargoPlazas.LTporcplaza,'none')# <cfelse>0.00 </cfif>%
                            </td>
							<td align="left"  width="25%"<cfif not(isdefined("Request.ConsultaAcciones") and Request.ConsultaAcciones EQ 1) and not isdefined('Lvar_RecargosC')>style="cursor:pointer" onclick="javascript:document.form1.indicaRecargo.value = 1; document.form1.LTidRecargo.value='#rsRecargoPlazas.LTRid#';document.form1.CambioAccion.value='1';document.form1.submit();"</cfif>>
                            	<strong><cf_translate key="LB_FechaV">Fecha Vigencia</cf_translate>:</strong> #LSDateFormat(rsRecargoPlazas.desde,'dd/mm/yyyy')#</td>
							<td align="left" width="25%" <cfif not(isdefined("Request.ConsultaAcciones") and Request.ConsultaAcciones EQ 1) and not isdefined('Lvar_RecargosC')>style="cursor:pointer" onclick="javascript:document.form1.indicaRecargo.value = 1; document.form1.LTidRecargo.value='#rsRecargoPlazas.LTRid#';document.form1.CambioAccion.value='1';document.form1.submit();"</cfif>>
                            	<strong><cf_translate key="LB_FechaV">Fecha Vencimiento</cf_translate>:</strong> #LSDateFormat(rsRecargoPlazas.hasta,'dd/mm/yyyy')#</td>
						</tr>
						
						<tr id="TR#id#">
							<td colspan="3">
								<table width="100%" border="0" cellspacing="2" cellpadding="2">
									<tr height="20" class="fileLabel" >
										<td nowrap><strong><cf_translate key="LB_PuestoR">Puesto</cf_translate></strong></td>
										<td nowrap><strong><cf_translate key="LB_Centro_FuncionalR">C.Funcional</cf_translate></strong></td>
										<td nowrap><strong><cf_translate key="LB_%Porcentaje_de_Salario_Fijo">% Salario Fijo</cf_translate></strong></td>
									</tr>
									<tr height="20">
										<td nowrap>#rsRecargoPlazas.RHPcodigo# - #rsRecargoPlazas.RHPdescripcion#</td>
										<td align="center">#rsRecargoPlazas.CFcodigo# - #rsRecargoPlazas.CFdescripcion#</td>
										<td nowrap align="center"><cfif rsRecargoPlazas.LTporcsal NEQ "">#LSCurrencyFormat(rsRecargoPlazas.LTporcsal,'none')# <cfelse>0.00 </cfif></td>
									</tr>
									<tr>
										<td colspan="4" class="fileLabel" nowrap>
											<strong><cf_translate key="LB_CompoAsociados_RH">Plaza Componentes Asociados y Montos</cf_translate></strong>
										</td>
									</tr>
									<tr>
										<td colspan="4">
											<table width="100%" cellpadding="0" cellspacing="0" border="0">
												<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
													<td>
														<cfinvoke component="rh.Componentes.RH_CompSalarial" method="pComponentes" returnvariable="result">
															<cfinvokeargument name="query" value="#rsRecargoPlazas#">
															<cfinvokeargument name="totalComponentes" value="#vTotalRec#">
															<cfinvokeargument name="permiteAgregar" value="false">
															<cfinvokeargument name="unidades" value="DLTunidades">
															<cfinvokeargument name="montobase" value="DLTmontobase">
															<cfinvokeargument name="montores" value="DLTmonto">
															<cfinvokeargument name="readonly" value="true">
															<cfinvokeargument name="incluyeHiddens" value="false">
															<cfinvokeargument name="presentarMontos" value="false">
															<cfinvokeargument name="presentarMontoBase" value="false">
															<cfinvokeargument name="presentarUnidades" value="false">
															<cfinvokeargument name="myHeight" value="15">
														</cfinvoke>
													</td>
												</tr>
											</table>
										</td>
									</tr>	
								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</cfloop>
		
	</table>
	</cfoutput>
	</cfif>
</cfif>
<script>
	<cfloop query="rsLineasRecargo">
	document.getElementById('TR<cfoutput>#rsLineasRecargo.LTRid#</cfoutput>').style.display='none';
	document.getElementById('menos<cfoutput>#rsLineasRecargo.LTRid#</cfoutput>').style.display='none'; 
	document.getElementById('mas<cfoutput>#rsLineasRecargo.LTRid#</cfoutput>').style.display=''; 
	</cfloop>
</script>