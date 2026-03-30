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

<cfset color1= "CCCCCC">

<cfoutput>
	<cfdocument format="FlashPaper" marginbottom="1" marginleft="1" marginright="1" margintop="1">
		<cfdocumentitem type="header">
		<cfoutput>
			<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0" bgcolor="##E3EDEF">
				<tr><td colspan="4">&nbsp;</td></tr>
			  	<tr>
					<td width="20%" align="left" valign="top">&nbsp;</td>
					<td width="80%" align="center" style="color:##6188A5; font-size:18px; font-family:Arial, Helvetica, sans-serif; " valign="top">#session.Enombre#</td>
					<td width="20%" align="left" rowspan="2" valign="top">
						<table>
							<tr>
								<td width="50%" align="right" style="font-size:10px; font-family:Arial, Helvetica, sans-serif;  "><cf_translate  key="LB_Usuario">Usuario:</cf_translate></td>
								<td width="50%" align="left" style="font-size:10px; font-family:Arial, Helvetica, sans-serif;  ">#Session.Usuario#</td>
							</tr>
							<tr>
								<td align="right" style="font-size:10px; font-family:Arial, Helvetica, sans-serif;  "><cf_translate  key="LB_Fecha">Fecha:</cf_translate></td>
								<td align="right" style="font-size:10px; font-family:Arial, Helvetica, sans-serif;  ">#LSDateFormat(Now(),'dd/mm/yyyy')#</td>
							</tr>
							<tr>
								<td align="right" style="font-size:10px; font-family:Arial, Helvetica, sans-serif;  ">&nbsp;</td>
								<td align="right" style="font-size:10px; font-family:Arial, Helvetica, sans-serif;  ">#cfdocument.currentpagenumber# - #cfdocument.totalpagecount#</td>
							</tr>
						</table>
					</td>
			  	</tr>
			   	<tr>
					<td align="left" valign="top">&nbsp;</td>
					<td align="center" 
						style="font-size:14px; font-family:Arial, Helvetica, sans-serif; " valign="top"><cf_translate  key="LB_ReporteHeadCount">Reporte HEAD COUNT</cf_translate></td>
					<td align="left" valign="top">&nbsp;</td>
			  	</tr>
			</table>
		</cfoutput>
		</cfdocumentitem>
		<!--- Se define pie de pagina --->
		<cfdocumentitem type="footer">
		<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td align="right" valign="top" style="font-size:10px; font-family:Arial, Helvetica, sans-serif;  " height="12px">
				<cfoutput>#cfdocument.currentpagenumber# - #cfdocument.totalpagecount#</cfoutput>
			</td>
			</td>
		  </tr>
		</table>
		</cfdocumentitem>
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
					<cfcase value="2"><cfset vColor = 'B7D1D5'></cfcase>
					<cfcase value="4"><cfset vColor = 'C6DADD'></cfcase>
					<cfcase value="6"><cfset vColor = 'D7E6E8'></cfcase>
					<cfcase value="8"><cfset vColor = 'E3EDEF'></cfcase>
					<cfcase value="10"><cfset vColor = 'EFF4F5'></cfcase>
					<cfcase value="12"><cfset vColor = 'E4E4E4'></cfcase>
				</cfswitch>
				<tr valign="middle">
						<td nowrap width="100%" style="font-size:12px; font-family:Arial, Helvetica, sans-serif;  ">
						<strong>#RepeatString('&nbsp;', ARBOLR.nivel*5+2)#
						#HTMLEditFormat(Trim(ARBOLR.codigo))# - #HTMLEditFormat(Trim(ARBOLR.descripcion))#	</strong>
					</td>
				</tr>
				<tr>
					<td>
						<!--- #RepeatString('&nbsp;', ARBOLR.nivel*2+2)# --->
						<cfoutput>
							<cfquery name="rsPlazasActivas" datasource="#session.DSN#">
								select coalesce(count(1),0) as cantplazas, 
									pp.RHPcodigo,RHPdescpuesto, coalesce(pp.RHPcodigoext,pp.RHPcodigo) as RHPcodigoext,
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
								group by RHPpuesto,pp.RHPcodigo,coalesce(pp.RHPcodigoext,pp.RHPcodigo),RHPdescpuesto,p.CFid, pp.ptsTotal, cf.CFcodigo, cf.CFdescripcion 
							</cfquery>
							<cfif rsPlazasActivas.RecordCount>
								<table width="90%" border="0" cellspacing="0" cellpadding="2" align="center">
									<tr bgcolor="E3EDEF" style="font-size:11px; font-family:Arial, Helvetica, sans-serif;">
										<td width="15%"><strong><cf_translate key="LB_Puesto">Puesto</cf_translate></strong></td>
										<td width="37%"><strong><cf_translate key="LB_Descripcion">Descripci&oacute;n</cf_translate></strong></td>
										<td width="15%" align="center"><strong><cf_translate key="LB_PlazasOcupadas">Plazas Ocupadas</cf_translate></strong></td>
										<td width="20%" align="center"><strong><cf_translate key="LB_PlazasDesocupadas">Plazas Desocupadas</cf_translate></strong></td>
										<td width="13%" align="center"><strong><cf_translate key="LB_PtsHAY">Pts HAY</cf_translate></strong></td>
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
										<!--- <cfdump var="#rsTotalPlazas#"> --->
											<tr style="font-size:10px; font-family:Arial, Helvetica, sans-serif;  ">
												<td><cfif len(trim(#RHPcodigoAlt#)) gt 0>#RHPcodigoAlt#<cfelse>#RHPcodigoext#</cfif></td>
												<td nowrap="true">#RHPdescpuesto#</td>
												<td nowrap="true" align="center">#cantplazas#</td>
												<td nowrap="true" align="center">#vDesocupadas#</td>
												<td nowrap="true" align="center"><cfif LEN(TRIM(ptsTotal))>#ptsTotal#<cfelse>-</cfif></td>
											</tr>
									</cfloop>
								</table>
							<cfelse>		
								<cfquery name="rsCentroFuncional" datasource="#session.DSN#">
									select CFcodigo, CFdescripcion
									from CFuncional
									where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
									  and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFpkR#">
								</cfquery>
								<table width="75%" border="0" cellspacing="0" cellpadding="2" align="center">
									<tr>
										<td align="center" style="font-size:10px; font-family:Arial, Helvetica, sans-serif;  ">#RepeatString('&nbsp;', ARBOLR.nivel*5+2)# <cf_translate key="NoHayPuestosAsignadosAEsteCentroFuncional">No hay Puestos asignados a este Centro funcional</cf_translate></td>
									</tr>
								</table>
							</cfif>						
						
						
						</cfoutput>
						<cfif isdefined("form.primeroR")><!--- Bloque el arbol para que no se dibuje todo--->
							<cfif not isdefined("url.dependenciaR")>
								<cfif ARBOLR.pk is form.primeroR>  
									<cfset pasoPrimeroR=1>
									<cfif pasoPrimeroR EQ 1 and pasoCfpkR EQ 1>
										<cfbreak> 
									</cfif>
								</cfif>
								<cfif ARBOLR.pk is url.ARBOL_POSR>
									<cfset pasoCfpkR=1>
									<cfif pasoPrimeroR EQ 1 and pasoCfpkR EQ 1>
										<cfbreak> 
									</cfif>
								</cfif> 
							</cfif>
						</cfif>
					</td>
				</tr>
				
				<tr><td>&nbsp;</td></tr>
			</cfloop>
			<tr><td colspan="5">&nbsp;</td></tr>
			<tr><td colspan="5">&nbsp;</td></tr>
			<tr>
				<td colspan="5" align="center">
					<table width="75%" border="0" cellspacing="2" cellpadding="2" align="center">
						<tr  bgcolor="E3EDEF" style="font-size:12px; font-family:Arial, Helvetica, sans-serif;  "><td align="center" colspan="2">Resumen de Cantidad de Plazas</td></tr>
						<tr  bgcolor="EFF4F5" style="font-size:12px; font-family:Arial, Helvetica, sans-serif;  ">
							<td nowrap="true" align="center"><cf_translate key="LB_TotalDePlazasOcupadas">Total de Plazas Ocupadas</cf_translate></td>
							<td nowrap="true" align="center"><cf_translate key="LB_TotalDePlazasDesocupadas">Total de Plazas Desocupadas</cf_translate></td>
						</tr>
						<tr  style="font-size:10px; font-family:Arial, Helvetica, sans-serif;  ">
							<td nowrap="true" align="center">#vTotalPOcupadas#</td>
							<td nowrap="true" align="center">#vTotalPDesocupadas#</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			</table>
		</cfoutput>
</cfdocument>
</cfoutput>
