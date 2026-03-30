<cfinclude template="ReporteAguinaldo_SQL.cfm">
<!--- <cf_dump var="#rsReporte#"> --->
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Nombre"
	Default="Nombre"
	returnvariable="LB_Nombre"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_CentroFuncional"
	Default="Centro Funcional"
	returnvariable="LB_CentroFuncional"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Total"
	Default="Total"
	returnvariable="LB_Total"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Totales"
	Default="Totales"
	returnvariable="LB_Totales"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Subtotal"
	Default="SubTotal"
	returnvariable="LB_Subtotal"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_MontoDeAguinaldo"
	Default="Monto de Aguinaldo"
	returnvariable="LB_MontoDeAguinaldo"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ReporteDeAquinaldos"
	Default="Reporte de Aguinaldo"
	returnvariable="LB_ReporteDeAquinaldos"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ReporteDeAquinaldoPorEmpleado"
	Default="Reporte de Aguinaldo por Empleado"
	returnvariable="LB_ReporteDeAquinaldoPorEmpleado"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ReporteDeAquinaldoPorEmpleadoYCentroFuncional"
	Default="Reporte de Aguinaldo por Empleado y Centro Funcional"
	returnvariable="LB_ReporteDeAquinaldoPorEmpleadoYCentroFuncional"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ReporteDeAquinaldoPorCentroFuncional"
	Default="Reporte de Aguinaldo por Centro Funcional"
	returnvariable="LB_ReporteDeAquinaldoPorCentroFuncional"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_FechaDesde"
	Default="Fecha Desde"
	returnvariable="LB_FechaDesde"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_FechaHasta"
	Default="Fecha Hasta"
	returnvariable="LB_FechaHasta"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ParaNomina"
	Default="Para N&oacute;mina"
	returnvariable="LB_ParaNomina"/>		
<cfif isdefined("url.back")>
    <cf_htmlReportsHeaders 
    back="false"
    irA=""
    FileName="ReporteAguinaldos.xls"
    method="url"
    title="#LB_ReporteDeAquinaldos#">
<cfelse>
    <cf_htmlReportsHeaders 
	irA="ReporteAguinaldo.cfm"
	FileName="ReporteAguinaldos.xls"
	method="url"
	title="#LB_ReporteDeAquinaldos#">
</cfif>

<!--- FIN VARIABLES DE TRADUCCION --->
<style>
	h1.corte {
		PAGE-BREAK-AFTER: always;}
	.titulo_empresa2 {
		font-size:16px;
		font-weight:bold;
		text-align:center;}
	.titulo_columnar {
		font-size:12px;
		font-weight:bold;
		background-color:#CCCCCC;
		text-align:left;
		height:20px}
	.detalle {
		font-size:12px;
		text-align:left;}
	.detaller {
		font-size:12px;
		text-align:right;}
	.detallec {
		font-size:12px;
		text-align:center;}	
	.totales {
		font-size:12px;
		text-align:right;
		font-weight:bold;}	
</style>
<cf_templatecss>

<cfif isdefined('url.Corte') and url.Corte EQ '0'>
	<table width="100%" cellpadding="2" cellspacing="1" align="center">
		<!--- ENCABEZADO --->
		<cfset vColspan = Columnas.recordcount + 3>
		<cfquery name="rsTipoNomina" datasource="#session.DSN#">
			select Tdescripcion
			from TiposNomina
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			  and Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#url.Tcodigo#">
		</cfquery>
		<!-----======================== ENCABEZADO ANTERIOR ========================
		<tr><td colspan="<cfoutput>#vColspan#</cfoutput>">&nbsp;</td></tr>
		<tr><td colspan="<cfoutput>#vColspan#</cfoutput>" align="center"><strong><cfoutput>#Trim(Session.Enombre)#</cfoutput></strong></td></tr>
		<tr><td colspan="<cfoutput>#vColspan#</cfoutput>" align="center"><strong><cfoutput>#Trim(LB_ReporteDeAquinaldoPorEmpleado)#</cfoutput></strong></td></tr>
		<tr>
			<td colspan="<cfoutput>#vColspan#</cfoutput>" align="center">
				<strong><cfoutput>#LB_FechaDesde#:&nbsp;#url.Fdesde# #LB_FechaHasta#:&nbsp;#url.Fhasta#</cfoutput></strong>			
			</td>
		</tr>		
		<tr>
			<td colspan="<cfoutput>#vColspan#</cfoutput>" align="center">
				<strong><cfoutput>#LB_ParaNomina#:&nbsp;#rsTipoNomina.Tdescripcion#</cfoutput></strong>			
			</td>
		</tr>
		<tr><td colspan="<cfoutput>#vColspan#</cfoutput>">&nbsp;</td></tr>
		------>
		<tr>
			<td colspan="<cfoutput>#vColspan#</cfoutput>">
				<table width="100%" cellpadding="0" cellspacing="0" align="center">
					<tr>
						<td>
							<cf_EncReporte
								Titulo="#Trim(LB_ReporteDeAquinaldoPorEmpleado)#"
								Color="##E3EDEF"
								filtro1="#LB_FechaDesde#: #url.Fdesde#  #LB_FechaHasta#: #url.Fhasta#"	
								filtro2="#LB_ParaNomina#: #rsTipoNomina.Tdescripcion#"								
							>
						</td>
					</tr>
				</table>
			</td>
		</tr>			
		
		<!--- TITULOS --->
		<tr class="titulo_columnar">
			<td nowrap><cfoutput>#LB_Nombre#</cfoutput></td>
		  <cfoutput query="columnas">
				<td align="right"><span class="style5">#CPcodigo#</span></td>
		  </cfoutput>
			<td align="right"><cfoutput><span class="style5">#LB_Total#</span></cfoutput></td>
		  <td align="right" nowrap><cfoutput><span class="style5">#LB_MontoDeAguinaldo#</span></cfoutput></td>
	  </tr>
		<cfset vTotal = 0>
		<cfset vTotales = 0>
		<cfset vTotalesA = 0>
		<cfset cont=0>

		<cfoutput query="rsReporte" group="DEid">
			<cfset cont = cont +1>
			<cfset vDEid = rsReporte.DEid>
			<cfset vTotalEmp = 0>
			<cfquery name="rsTotal" dbtype="query">
				select MontoAg, DEid
				from rsReporte
				where DEid = #vDEid#
			</cfquery>

			<cfquery name="rsTotal" dbtype="query">
				select sum(MontoAg) as Total, DEid
				from rsReporte
				where DEid = #vDEid#
				group by DEid
			</cfquery>
			<!---<cfset vTotalEmp = rsTotal.Total>--->
			<cfset vTotalEmp = 0>
			<cfset vTotal = vTotal + vTotalEmp>
			<tr <cfif not cont MOD 2>bgcolor="##E2E2E2"<cfelse>bgcolor="##E4E4E4"</cfif>>
				<td nowrap>#Ucase(Nombre)#</td>
				<cfloop query="columnas">
	
					<cfquery name="rsCP" dbtype="query">
						select MontoAg
						from rsReporte
						where DEid = #vDEid#
						  and RCNid = #columnas.CPid#
					</cfquery>
					<td align="right">
						<cfif rsCP.RecordCount GT 0>#LSCurrencyFormat(rsCP.MontoAg,'none')#<cfelse><div align="center">-</div></cfif>					
					</td>
					<cfif len(trim(rsCP.MontoAg))>
						<cfset vTotalEmp = vTotalEmp + rsCP.MontoAg >
					</cfif>
				</cfloop>
				<td align="right" bgcolor="##CCCCCC" >#LSCurrencyFormat(vTotalEmp,'none')#</td>
				<td align="right" bgcolor="##CCCCCC">#LSCurrencyFormat(vTotalEmp/12,'none')#</td>
			</tr>
			<cfset vTotales = vTotales + vTotalEmp>
			<cfset vTotalesA = vTotalesA + vTotalEmp/12>
		</cfoutput>

		<cfoutput>
			<tr style="font-weight:bold;">
				<td bgcolor="##CCCCCC">#LB_Totales#</td>
				<cfloop query="columnas">
					<cfquery name="rsCP2" dbtype="query">
						select distinct *
						from rsReporte
						where RCNid = #columnas.CPid#
					</cfquery>
					<cfquery name="rsCP" dbtype="query">
						select RCNid, sum(MontoAg) as TotalCP
						from rsCP2
						where RCNid = #columnas.CPid#
						group by RCNid
					</cfquery>
					<td align="right" bgcolor="##CCCCCC">
						<cfif rsCP.RecordCount GT 0>#LSCurrencyFormat(rsCP.TotalCP,'none')#<cfelse><div align="center">-</div></cfif>					
					</td>
				</cfloop>
				<td align="right" bgcolor="##CCCCCC">#LSCurrencyFormat(vTotales,'none')#</td>
				<td align="right" bgcolor="##CCCCCC">#LSCurrencyFormat(vTotalesA,'none')#</td>
			</tr>
		</cfoutput>
	</table>

<!--- CORTE POR CENTRO FUNCIONAL/EMEPLADO --->
<cfelseif url.Corte EQ '1'>
	<table width="90%" cellpadding="2" cellspacing="1" align="center">
		<!--- ENCABEZADO --->
		<cfset vColspan = columnas.RecordCount + 3>
		<cfquery name="rsTipoNomina" datasource="#session.DSN#">
			select Tdescripcion
			from TiposNomina
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			  and Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#url.Tcodigo#">
		</cfquery>
		<!----======================= ENCABEZADO ANTERIOR =======================
		<tr><td colspan="<cfoutput>#vColspan#</cfoutput>">&nbsp;</td></tr>
		<tr><td colspan="<cfoutput>#vColspan#</cfoutput>" align="center"><strong><cfoutput>#Trim(Session.Enombre)#</cfoutput></strong></td></tr>
		<tr><td colspan="<cfoutput>#vColspan#</cfoutput>" align="center"><strong><cfoutput>#Trim(LB_ReporteDeAquinaldoPorEmpleadoYCentroFuncional)#</cfoutput></strong></td></tr>
		<tr>
			<td colspan="<cfoutput>#vColspan#</cfoutput>" align="center">
				<strong><cfoutput>
					#LB_FechaDesde#:&nbsp;#url.Fdesde# #LB_FechaHasta#:&nbsp;#url.Fhasta#
				</cfoutput></strong>			
			</td>
		</tr>
		<tr>
			<td colspan="<cfoutput>#vColspan#</cfoutput>" align="center">
				<strong><cfoutput>
					#LB_ParaNomina#:&nbsp;#rsTipoNomina.Tdescripcion#					
				</cfoutput></strong>			
			</td>
		</tr>
		<tr><td colspan="<cfoutput>#vColspan#</cfoutput>">&nbsp;</td></tr>
		------>
		<tr>
			<td colspan="<cfoutput>#vColspan#</cfoutput>">
				<table width="100%" cellpadding="0" cellspacing="0" align="center">
					<tr>
						<td>
							<cf_EncReporte
								Titulo="#Trim(LB_ReporteDeAquinaldoPorEmpleadoYCentroFuncional)#"
								Color="##E3EDEF"
								filtro1="#LB_FechaDesde#: #url.Fdesde#  #LB_FechaHasta#: #url.Fhasta#"	
								filtro2="#LB_ParaNomina#: #rsTipoNomina.Tdescripcion#"								
							>
						</td>
					</tr>
				</table>
			</td>
		</tr>					
		
		<cfset vTotal = 0>
		<cfset vTotalCF = 0>
		<cfset vTotales_1 = 0>
		<cfset vTotales = 0>
		
		<cfset vTotalesEmpl = 0>	
		<cfoutput query="rsReporte" group="CFid">
			<cfset vCFid = rsReporte.CFid>
			<cfset cont=0>
			<tr ><td colspan="<cfoutput>#vColspan#</cfoutput>"nowrap><strong>#LB_CentroFuncional#&nbsp;:&nbsp;#CFdescripcion#</strong></td></tr>
			<!--- TITULOS --->
		  <tr bgcolor="##CCCCCC" >
				<td nowrap ><span class="style5"><strong>#LB_Nombre#</strong></span></td>
				<cfloop query="columnas">
					<td align="right" nowrap ><span class="style5"><strong>#CPcodigo#</strong></span></td>
				</cfloop>
				<td align="right" ><span class="style5"><strong>#LB_Total#</strong></span></td>
		 	    <td align="right" nowrap><span class="style5"><strong>#LB_MontoDeAguinaldo#</span></strong></td>			
		  </tr>
			<cfoutput group="DEid">
				<cfset vDEid = rsReporte.DEid>
				<cfset vTotalEmp = 0>
				<cfset cont = cont +1>
				<cfquery name="rsTotal" dbtype="query">
					select sum(MontoAg) as Total
					from rsReporte
					where DEid = #vDEid#
					  and CFid = #vCFid#
				</cfquery>
				<!---<cfset vTotalEmp = rsTotal.Total>--->
				<cfset vTotalEmp = 0>
				<cfset vTotal = vTotal + vTotalEmp>
				<tr <cfif not cont MOD 2>bgcolor="##E2E2E2"<cfelse>bgcolor="##E4E4E4"</cfif>>
					<td nowrap>#Ucase(Nombre)#</td>
					<cfloop query="columnas">
		
						<cfquery name="rsCP" dbtype="query">
							select MontoAg
							from rsReporte
							where DEid = #vDEid#
							  and RCNid = #columnas.CPid#
							  and CFid = #vCFid#
						</cfquery>
						<td align="right">
							<cfif rsCP.RecordCount GT 0>#LSCurrencyFormat(rsCP.MontoAg,'none')#<cfelse><div align="center">-</div></cfif>						
						</td>
						<cfif len(trim(rsCP.MontoAg))>
							<cfset vTotalEmp = vTotalEmp + rsCP.MontoAg >
						</cfif>
					</cfloop>
					<td align="right" bgcolor="##CCCCCC">#LSCurrencyFormat(vTotalEmp,'none')#</td>
					<td align="right">#LSCurrencyFormat(vTotalEmp/12,'none')#</td>
					
				</tr>
				<cfset vTotales = vTotales + vTotalEmp>
				<cfset vTotalCF = VTotalCF + vTotalEmp>
				<cfset vTotalesEmpl = vTotalesEmpl + (vTotalEmp/12)>	
			</cfoutput>

			<!--- datos --->
			<tr style="font-weight:bold;">
				<td bgcolor="##CCCCCC">#LB_Subtotal# #CFdescripcion#</td>
				<cfloop query="columnas">
					<cfquery name="rsCP2" dbtype="query">
						select distinct *
						from rsReporte
						where RCNid = #columnas.CPid#
						  and CFid = #vCFid#
					</cfquery>
					<cfquery name="rsCP" dbtype="query">
						select sum(MontoAg) as TotalCP
						from rsCP2
						where RCNid = #columnas.CPid#
						  and CFid = #vCFid#
					</cfquery>
					<td align="right" bgcolor="##CCCCCC">
						<cfif rsCP.RecordCount GT 0>#LSCurrencyFormat(rsCP.TotalCP,'none')#<cfelse><div align="center">-</div></cfif>
					</td>
				</cfloop>
				<td align="right" bgcolor="##CCCCCC">#LSCurrencyFormat(vTotalCF,'none')#</td>
				<td align="right" bgcolor="##CCCCCC">#LSCurrencyFormat(vTotalCF/12,'none')#</td>				
			</tr>
			<tr><td colspan="<cfoutput>#vColspan#</cfoutput>">&nbsp;</td></tr>
			<cfset vTotalCF = 0>
		</cfoutput>
		<cfoutput>

		<!--- linea de totales--->
		<tr style="font-weight:bold;" bgcolor="##CCCCCC">
			<td>#LB_Totales#</td>
			<cfloop query="columnas">
				<cfquery name="rsCP2" dbtype="query">
					select distinct *
					from rsReporte
					where RCNid = #columnas.CPid#
				</cfquery>

				<cfquery name="rsCP" dbtype="query">
					select sum(MontoAg) as TotalCP
					from rsCP2
					where RCNid = #columnas.CPid#
				</cfquery>
				<td align="right">
					<cfif rsCP.RecordCount GT 0>#LSCurrencyFormat(rsCP.TotalCP,'none')#<cfelse><div align="center">-</div></cfif>
				</td>
			</cfloop>
			<td align="right">#LSCurrencyFormat(vTotales,'none')#</td>
			<td align="right">#LSCurrencyFormat(vTotales/12,'none')#</td>
		</tr>
		</cfoutput>
	</table>

<!--- CORTE POR CENTRO FUNCIONAL --->
<cfelseif url.Corte EQ '2'>
	<table width="90%" align="center" cellpadding="2" cellspacing="1">
		<!--- ENCABEZADO --->
		<cfset vColspan = columnas.RecordCount + 3>
		<cfquery name="rsTipoNomina" datasource="#session.DSN#">
			select Tdescripcion
			from TiposNomina
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			  and Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#url.Tcodigo#">
		</cfquery>
		<!----======================== ENCABEZADO ANTERIOR ========================
		<tr><td colspan="<cfoutput>#vColspan#</cfoutput>">&nbsp;</td></tr>
		<tr><td colspan="<cfoutput>#vColspan#</cfoutput>" align="center" bordercolor="#000000"><strong><cfoutput>#Trim(Session.Enombre)#</cfoutput></strong></td></tr>
		<tr><td colspan="<cfoutput>#vColspan#</cfoutput>" align="center"><strong><cfoutput>#Trim(LB_ReporteDeAquinaldoPorCentroFuncional)#</cfoutput></strong></td></tr>
		<tr>
			<td colspan="<cfoutput>#vColspan#</cfoutput>" align="center">
				<strong><cfoutput>
					#LB_FechaDesde#:&nbsp;#url.Fdesde# #LB_FechaHasta#:&nbsp;#url.Fhasta#					
				</cfoutput></strong>			
			</td>
		</tr>
		<tr>
			<td colspan="<cfoutput>#vColspan#</cfoutput>" align="center">
				<strong><cfoutput>#LB_ParaNomina#:&nbsp;#rsTipoNomina.Tdescripcion#</cfoutput></strong>
			</td>
		</tr>
		<tr><td colspan="<cfoutput>#vColspan#</cfoutput>">&nbsp;</td></tr>
		----->
		<tr>
			<td colspan="<cfoutput>#vColspan#</cfoutput>">
				<table width="100%" cellpadding="0" cellspacing="0" align="center">
					<tr>
						<td>
							<cf_EncReporte
								Titulo="#Trim(LB_ReporteDeAquinaldoPorCentroFuncional)#"
								Color="##E3EDEF"
								filtro1="#LB_FechaDesde#: #url.Fdesde#  #LB_FechaHasta#: #url.Fhasta#"	
								filtro2="#LB_ParaNomina#: #rsTipoNomina.Tdescripcion#"								
							>
						</td>
					</tr>
				</table>
			</td>
		</tr>				
		
		<!--- TITULOS --->
	  <tr bgcolor="#CCCCCC">
			<td bgcolor="#CCCCCC" nowrap="nowrap"><cfoutput><span class="style5"><strong>#LB_CentroFuncional#</strong></span></cfoutput></td>
			<cfoutput query="columnas">
				<td align="right" bgcolor="##CCCCCC"><span class="style5"><strong>#CPcodigo#</strong></span></td>
			</cfoutput>
			<td bgcolor="#CCCCCC" align="right" ><cfoutput><span class="style5"><strong>#LB_Total#</strong></span></cfoutput></td>
	 	    <td align="right" nowrap><cfoutput><span class="style5"><strong>#LB_MontoDeAguinaldo#</span></strong></cfoutput></td>			
	  </tr>
		<cfset vTotal = 0>
		<cfset vTotalCF = 0>
		<cfset vTotales = 0>
		<cfset vTotalesAgui = 0>
		<cfset cont = 0>
		<cfoutput query="rsReporte" group="CFid">
			<cfset vCFid = rsReporte.CFid>
			<cfset cont = cont +1>
			<tr <cfif not cont MOD 2>bgcolor="##E2E2E2"<cfelse>bgcolor="##E4E4E4"</cfif>>
				<td nowrap>#CFdescripcion#</td>
				<cfloop query="columnas">
					<cfquery name="rsCP" dbtype="query">
						select sum(MontoAg) as TotalCP
						from rsReporte
						where RCNid = #columnas.CPid#
						  and CFid = #vCFid#
					</cfquery>
				  <cfif rsCP.RecordCount GT 0>
						<cfset vTotalCP = rsCP.TotalCP>
					<cfelse>
						<cfset vTotalCP = 0>
				  </cfif>
					<td align="right">
						<cfif rsCP.RecordCount GT 0>#LSCurrencyFormat(rsCP.TotalCP,'none')#<cfelse><div align="center">-</div></cfif>					</td>
					<cfset vTotal = vTotal + vTotalCP>
				</cfloop>
				<td align="right">#LSCurrencyFormat(vTotal,'none')#</td>
				<td align="right">#LSCurrencyFormat(vTotal/12,'none')#</td>				
				<cfset vTotales = vTotales + vTotal>
				<cfset vTotalesAgui = vTotalesAgui + (vTotal/12)>				
				<cfset vTotal = 0>
			</tr>
		</cfoutput>
		<cfoutput>
		<tr style="font-weight:bold;">
			<td bgcolor="##CCCCCC">#LB_Totales#</td>
			<cfloop query="columnas">
				<cfquery name="rsCP" dbtype="query">
					select sum(MontoAg) as TotalCP
					from rsReporte
					where RCNid = #columnas.CPid#
				</cfquery>
				<td align="right" bgcolor="##CCCCCC">
					<cfif rsCP.RecordCount GT 0>#LSCurrencyFormat(rsCP.TotalCP,'none')#<cfelse><div align="center">-</div></cfif>				</td>
			</cfloop>
			<td align="right" bgcolor="##CCCCCC">#LSCurrencyFormat(vTotales,'none')#</td>
			<td align="right" bgcolor="##CCCCCC">#LSCurrencyFormat(vTotalesAgui,'none')#</td>
		</tr>
		</cfoutput>
	</table>	
</cfif>		