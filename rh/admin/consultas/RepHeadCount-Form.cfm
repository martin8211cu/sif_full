<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_CentroFuncional"
	Default="Centro Funcional"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_CentroFuncional"/>
<!--- FIN VARIABLES DE TRADUCCION --->

<cfparam name="form.dependenciaR" default="on">
<!--- <cfif isdefined('form.BTNMostrar')> --->
<cfif isdefined('form.dependenciaR') and not isdefined('url.dependenciaR')>
	<cfset url.dependenciaR = form.dependenciaR>
</cfif>
<cfif isdefined('form.dependencia') and LEN(TRIM(form.dependencia)) and not LEN(TRIM(form.dependenciaR))>
	<cfset url.dependenciaR = form.dependencia>
</cfif>

<cfquery name="rsPrimero" datasource="#session.DSN#">
	select CFid as pk
	from CFuncional
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and CFnivel = 0
</cfquery>
<cfif not isdefined('form.primeroR') and not isdefined('url.primeroR') 
		and not isdefined('form.CFpkR') and not isdefined('url.CFpkR')>
	<cfset form.primeroR = rsPrimero.pk>
	<cfset form.CFpkR = rsPrimero.pk>
</cfif>
<cfif not isdefined('form.CFpkR') and isdefined('url.CFpkR')>
	<cfset form.CFpkR = url.CFpkR>
</cfif>
<cfset form.CFpkR = form.CFpk>
<cfset color1= "CCCCCC">
<cfif isdefined('form.CFid') and LEN(TRIM(form.CFid)) and isdefined('BTNFiltrar')>
	<cfset form.CFpkR = form.CFid>
</cfif>

<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="2" align="center">

		<form name="form1" action="RepHeadCount-Rep.cfm" method="get">
			<input name="CFpkR" type="hidden" value="#form.CFpkR#">
			<cfif isdefined('form.dependenciaR')>
			<input name="dependenciaR" type="hidden" value="#form.dependenciaR#">
			</cfif>
			<tr><td colspan="5" align="center"><cf_botones values="Imprimir"></td></tr>
		</form>
		<tr>
			<td align="center">
				<!--- Este Árbol pinta 1 item y todos sus ancestros, y todos los items de la raíz --->
				<!--- <cfparam name="form.CFpkR" default="0" type="numeric"> --->
				<!--- busqueda recursiva de los ancestros del item... se espera que los ancestros sean cuando mucho unos 4...  si son mas de 10 hay que cambiar esta solución. --->
				<cfif isdefined("url.primeroR")and len(trim(url.primeroR)) NEQ 0>
					<cfset form.primeroR = url.primeroR>
				</cfif>
				
				<cfset litemR = "0">
				<cfset rutaR  = "0">
				<cfif isdefined("Form.CFpkR")and len(trim(Form.CFpkR))NEQ 0>
					<cfset litemR = Form.CFpkR>
					<cfset rutaR =  Form.CFpkR>
				<cfelseif isdefined("url.CFpkR")and len(trim(url.CFpkR))NEQ 0>
					<cfset litemR = url.CFpkR>
					<cfset rutaR =  url.CFpkR>
				</cfif>
				<cfif isdefined("Form.CFpk_papaR")and len(trim(Form.CFpk_papaR)) NEQ 0>
					<cfset form.primeroR = form.CFpk_papaR>
					<cfset litemR = Form.CFpk_papaR>
					<cfset rutaR =  Form.CFpk_papaR>
				</cfif>
				<cfset n=0>
				<cfset rutaR = rutaR & iif(len(trim(rutaR)),DE(','),DE('')) & "0">
				<br>
				<cfset pathR=rutaR>
				<cfif IsDefined('form.CFpkR')>
					<cfset url.ARBOL_posR = form.CFpkR>
				<cfelse>
					<cfset url.ARBOL_POSR = ''>
				</cfif>
				<cfset CentrosLista = ''>
				<cfif not isdefined("url.dependenciaR")>
					<cfset CentrosLista = form.CFpkR>
				<cfelseif isdefined('url.dependenciaR') and LEN(TRIM(url.dependenciaR))>
					<cfinvoke component="rh.Componentes.RH_Funciones" method="CFDependencias"
						CFid = "#form.CFpkR#"
						Nivel = 5
						returnvariable="Dependencias"/>
					<cfset CentrosLista = ValueList(Dependencias.CFid)>
				<cfelse>
					<cfset CentrosLista = form.CFpkR>
				</cfif>
				
				<cfquery datasource="#session.dsn#" name="ARBOLR">
					select 	c.CFid as pk, 
							c.CFcodigo as codigo, 
							c.CFidresp,
							c.CFdescripcion as descripcion, 
							c.CFnivel as nivel,  
						(select count(1) from CFuncional c2
							where ( case c2.CFnivel when 0 then 0 else c2.CFidresp end ) = c.CFid
							  and c2.Ecodigo = c.Ecodigo) AS  hijos
					from CFuncional c
					where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  and c.CFid in (#CentrosLista#)
					order by c.CFpath
				</cfquery>
				<cfset vTotalPOcupadas = 0>
				<cfset vTotalPDesocupadas = 0>
				<cfoutput>
					<table cellpadding="1" cellspacing="0" border="0" width="100%">
					<cfset pasoCfpkR=0>
					<cfset pasoPrimeroR=0>
					<cfset vColor = 0>
					<cfloop query="ARBOLR">
						<cfset vColor = ARBOLR.nivel*2+2>
						<cfswitch expression="#vColor#" >
							<cfcase value="2"><cfset vColor = '808080'></cfcase>
							<cfcase value="4"><cfset vColor = '9D9D9D'></cfcase>
							<cfcase value="6"><cfset vColor = 'B5B5B5'></cfcase>
							<cfcase value="8"><cfset vColor = 'C8C8C8'></cfcase>
							<cfcase value="10"><cfset vColor = 'D7D7D7'></cfcase>
							<cfcase value="12"><cfset vColor = 'E4E4E4'></cfcase>
						</cfswitch>
						<tr valign="middle">
								<td nowrap width="100%">
								<strong>#LB_CentroFuncional#: #HTMLEditFormat(Trim(ARBOLR.codigo))# - #HTMLEditFormat(Trim(ARBOLR.descripcion))#</strong>
							</td>
						</tr>
						<tr>	
							<td>
								<cfoutput>
									<cfquery name="rsPlazasActivas" datasource="#session.DSN#">
										select coalesce(count(1),0) as cantplazas, 
											pp.RHPcodigo,RHPdescpuesto,coalesce(pp.RHPcodigoext,pp.RHPcodigo) as RHPcodigoext,
											p.CFid,pp.ptsTotal,
											cf.CFcodigo, cf.CFdescripcion, lt.RHPcodigoAlt 
										from RHPlazas p
										inner join RHPuestos pp
											on p.RHPpuesto = pp.RHPcodigo
											and p.Ecodigo= pp.Ecodigo
										inner join LineaTiempo lt
										   on lt.Ecodigo = p.Ecodigo
										  and lt.RHPid = p.RHPid
										  and lt.RHPcodigo = p.RHPpuesto
										  and getdate() between LTdesde and LThasta
										inner join CFuncional cf
										   on cf.Ecodigo = p.Ecodigo
										  and cf.CFid = p.CFid
										where p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
										  and p.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ARBOLR.pk#">
										group by RHPpuesto,coalesce(pp.RHPcodigoext,pp.RHPcodigo),pp.RHPcodigo,RHPdescpuesto,p.CFid, pp.ptsTotal, cf.CFcodigo, cf.CFdescripcion 
									</cfquery>
									<cfif rsPlazasActivas.RecordCount>
										<table width="90%" border="1" cellspacing="0" cellpadding="2" align="center">
											<tr class="titulolistas">
												<td width="15%"><cf_translate key="LB_Puesto">Puesto</cf_translate></td>
												<td width="37%"><cf_translate key="LB_Descripcion">Descripci&oacute;n</cf_translate></td>
												<td width="15%"><cf_translate key="LB_Ocupadas">Ocupadas</cf_translate></td>
												<td width="20%"><cf_translate key="LB_Desocupadas">Desocupadas</cf_translate></td>
												<td width="13%"><cf_translate key="LB_PtsHAY">Pts HAY</cf_translate></td>
											</tr>
											<cfloop query="rsPlazasActivas">
												<cfquery name="rsTotalPlazas" datasource="#session.DSN#">
													select coalesce(count(1),0.00) as desocupadas
													from RHPlazas p
													inner join RHPuestos pp
														on p.RHPpuesto = pp.RHPcodigo
														and p.Ecodigo= pp.Ecodigo
													where p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
													  and p.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPlazasActivas.CFid#">
													  and pp.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_cahr" value="#rsPlazasActivas.RHPCodigo#">
													group by RHPpuesto,pp.RHPcodigo,RHPdescpuesto
												</cfquery>
												<cfif rsTotalPlazas.RecordCount EQ 0>
													<cfset vTotalPlazas = 0>
												<cfelse>
													<cfset vTotalPlazas = rsTotalPlazas.desocupadas>
												</cfif>
												<cfset vDesocupadas = vTotalPlazas - rsPlazasActivas.cantplazas >
												<cfset vTotalPDesocupadas = vTotalPDesocupadas + vDesocupadas>
												<cfset vTotalPOcupadas = vTotalPOcupadas + cantplazas>
													<tr>
														<td><cfif len(trim(#RHPcodigoAlt#)) gt 0>#RHPcodigoAlt#<cfelse>#RHPcodigoext#</cfif></td>
														<td>#RHPdescpuesto#</td>
														<td align="center">#cantplazas#</td>
														<td align="center">#vDesocupadas#</td>
														<td><cfif LEN(TRIM(ptsTotal))>#ptsTotal#<cfelse>-</cfif></td>
													</tr>
											</cfloop>
													<tr><td colspan="5">&nbsp;</td></tr>
										</table>
									<cfelse>		
										<cfquery name="rsCentroFuncional" datasource="#session.DSN#">
											select CFcodigo, CFdescripcion
											from CFuncional
											where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
											  and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFpk#">
										</cfquery>
										<table width="100%" border="0" cellspacing="0" cellpadding="2" align="center">
											<tr>
												<td align="center" style="font-size:12px; font-family:Arial, Helvetica, sans-serif;  "><cf_translate key="NoHayPuestosAsignadosAEsteCentroFuncional">No hay Puestos asignados a este Centro funcional</cf_translate></td>
											</tr>
										</table>
									</cfif>						
								
								
								</cfoutput>
							</td>
						</tr>
					</cfloop>
					<tr><td colspan="5">&nbsp;</td></tr>
					<tr>
						<td colspan="5" align="center">
							<table width="75%" border="0" cellspacing="2" cellpadding="2" align="center">
								<tr class="tituloAlterno"><td align="center" colspan="2">Resumen de Cantidad de Plazas</td></tr>
								<tr class="tituloListas">
									<td nowrap="true">Total de Plazas Ocupadas</td>
									<td nowrap="true">Total de Plazas Desocupadas</td>
								</tr>
								<tr>
									<td nowrap="true" align="center">#vTotalPOcupadas#</td>
									<td nowrap="true" align="center">#vTotalPDesocupadas#</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr><td colspan="5">&nbsp;</td></tr>
					<form name="form1" action="RepHeadCount-Rep.cfm" method="get">
						<input name="CFpkR" type="hidden" value="#form.CFpkR#">
						<input name="dependenciaR" type="hidden" value="on">
						<tr><td colspan="5" align="center"><cf_botones values="Imprimir"></td></tr>
					</form>

					</table>
				</cfoutput>
			</td>
		</tr>
	</table>
</cfoutput>