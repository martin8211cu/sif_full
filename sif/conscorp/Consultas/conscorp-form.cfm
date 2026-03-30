<cfif isdefined('url.ckEmpresa') and not isdefined('form.ckEmpresa')>
	<cfset form.ckEmpresa = url.ckEmpresa>
</cfif>
<cfif isdefined('url.fechaIni_f') and not isdefined('form.fechaIni_f')>
	<cfset form.fechaIni_f = url.fechaIni_f>
</cfif>
<cfif isdefined('url.fechaFin_f') and not isdefined('form.fechaFin_f')>
	<cfset form.fechaFin_f = url.fechaFin_f>
</cfif>
<!--- Query en el Framework para saber el total de las Corporaciones --->
<cfquery name="rsEmpresas" datasource="asp">
	select a.CEcodigo, ce.CEnombre, a.Ecodigo as EcodigoSDC, a.Ereferencia as Ecodigo, a.Enombre, m.Mnombre, c.Ccache
	from CuentaEmpresarial ce,
		 Empresa a,
		 CECaches b,
		 Caches c,
		 Moneda m
	where ce.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	  and ce.CEcodigo = a.CEcodigo
	  and a.Cid = b.Cid
	  and a.CEcodigo = b.CEcodigo
	  and b.Cid = c.Cid
	  and a.Mcodigo = m.Mcodigo
 	  <cfif isdefined('form.ckEmpresa') and form.ckEmpresa NEQ ''>
		  and a.Ecodigo in (#form.ckEmpresa#)
	  </cfif>
	 order by Mnombre, Ccache, Enombre
</cfquery>

<cfquery name="rsCorporacion" dbtype="query">
	Select distinct CEnombre
	from rsEmpresas
</cfquery>

<style type="text/css">
<!--
.style1 {
	font-size: 16px;
	font-weight: bold;
	font-family: Arial, Helvetica, sans-serif;
}
.style3 {
	font-family: Arial, Helvetica, sans-serif;
	font-weight: bold;
	font-size: 14px;
}
.style4 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 14px;
}
.style13 {
	font-size: 14px;
	font-weight: bold;
}
-->
</style>

<cfset varMoneda = ''>
<cfset varEmpresa = ''>
<cfset varMaxTotal = 0>
<cfset varformat = 'flash'>
<!--- Contadores para la linea de totales --->
<cfset varTotEmplAct = 0>
<cfset varTotTipNom = 0>
<cfset varTotNomPag = 0>
<cfset varTotPagado = 0>

<cfif isdefined('url.imprimir')>
	<cfset varformat = 'jpg'>
</cfif>
<!--- Query para graficos --->
<cfset rsTotales = QueryNew("empresa,total")>

<table align="center" width="100%" border="0" style="border-top:1px solid buttonshadow; border-left: 1px solid buttonshadow; border-right: 1px solid buttonshadow; border-bottom: 1px solid buttonshadow;">
  <!--- ENCABEZADO --->
  <tr>
    <td colspan="3" align="center" class="areaFiltro">
		<table width="200" border="0">
		  <tr>
			<td align="center" nowrap><cfoutput><span class="style1">#HTMLEditFormat(rsCorporacion.CEnombre)#</span></cfoutput></td>
		  </tr>
		  <tr>
			<td align="center" nowrap><span class="style1">Planillas Pagadas por Empresa </span></td>
		  </tr>
		  <tr>
			<td abbr="center" nowrap><span class="style13">Entre las fechas <cfoutput>#form.fechaIni_f# y #form.fechaFin_f#</cfoutput></span></td>
		  </tr>
		  <tr>
			<td>&nbsp;</td>
		  </tr>
		</table>
	</td>
  </tr>
	<cfoutput query="rsEmpresas">
		<cfset LvarListaNon = (CurrentRow MOD 2)>	  
		<cfif varMoneda NEQ Mnombre>
			<cfif varMoneda NEQ ''>
							<!--- Coloca la linea de detalles para todas las empresas con la misma moneda --->
						  <tr class=<cfif LvarListaNon>"listaNon"<cfelse>"listaPar"</cfif> onmouseover="this.className='listaParSel';" onmouseout="this.className='<cfif LvarListaNon>listaNon<cfelse>listaPar</cfif>';">
							<td colspan="5"><hr></td>
						  </tr>									
						  <tr class=<cfif LvarListaNon>"listaNon"<cfelse>"listaPar"</cfif> onmouseover="this.className='listaParSel';" onmouseout="this.className='<cfif LvarListaNon>listaNon<cfelse>listaPar</cfif>';">
							<td nowrap align="right"><strong>Totales</strong></td>
							<!--- (Nota 1) --->							
							<td width="13%" align="right"><strong>#LSNumberFormat(varTotEmplAct)#</strong></td>
							<!--- (Nota 2) --->
							<td width="12%" align="right"><strong>#LSNumberFormat(varTotTipNom)#</strong></td>
							<!--- (Nota 3) --->
							<td width="12%" align="right"><strong>#LSNumberFormat(varTotNomPag)#</strong></td>
							<!--- (Nota 4) --->
							<td width="57%" align="right"><strong>#LSNumberFormat(varTotPagado)#</strong></td>
						  </tr>			
						</table>
						<!--- Cierra la linea para las empresas de esta moneda --->
					</td>
					<td align="center" valign="middle">
						<cfchart gridlines="5"
								 xaxistitle="Empresa" 
								 yaxistitle="Monto" 
								 scalefrom="0"
								 show3d="yes" 
								 showborder="no" 
								 showlegend="yes"
								 chartwidth="320"
								 format="#varformat#"> 											  
						<cfchartseries 
							colorlist="##0099FF,##66CC33,##996699,##009999,##99CCFF,##A9A0C0,##D6C172,##C19B79,##92AC6C,##9F9F9F,##ACADD2,##D099AA"
							type="pie" 
							query="rsTotales" 
							valuecolumn="total" 
							itemcolumn="empresa">
						</cfchart> 					
						<!--- Query para graficos --->
						<cfset rsTotales = QueryNew("empresa,total")>						
						<!--- Inicializaci[on de los contadores para la linea de totales --->
						<cfset varTotEmplAct = 0>
						<cfset varTotTipNom = 0>
						<cfset varTotNomPag = 0>
						<cfset varTotPagado = 0>						
					</td>
				</tr>						
			</cfif>
			<tr>
				<td width="7%"><span class="style3">Moneda:</span></td>
				<td>
					<span class="style4">#HTMLEditFormat(Mnombre)#</span>
				</td>
				<td>&nbsp;</td>
			</tr>			
			<tr nowrap>
				<td width="7%">&nbsp;</td>
				<td valign="top">
					<!--- Abre linea para todas las empresas de esta moneda --->				
					<table width="100%" border="0" align="center">
						  <tr class="areaFiltro">
							<td width="6%" align="center" nowrap><strong>Empresa</strong></td>
							<td nowrap align="center"><strong>Empleados Activos</strong></td>
							<td nowrap align="center"><strong>Tipos de Nóminas</strong></td>
							<td nowrap align="center"><strong>N&oacute;minas Pagadas</strong></td>
							<td nowrap align="center"><strong>Total Pagado</strong></td>
						  </tr>					
					
			<cfset varMoneda = Mnombre>	
		</cfif>
		<cfif varEmpresa NEQ Enombre>
			<cfset varEmpresa = HTMLEditFormat(Enombre)>		
			<!--- Cantidad de empleados Activos para una Empresa    (Nota 1) --->
			<cfquery name="rsNota1" datasource="#Ccache#">
				select count(1) as cantEmpl
				from LineaTiempo
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEmpresas.Ecodigo#">
				  and <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
				  	between LTdesde and LThasta
			</cfquery>
			<!--- Cantidad de Tipos de Nóminas Pagadas (Nota 2) --->
			<cfquery name="rsNota2" datasource="#Ccache#">
				select count(distinct Tcodigo) as cantTcodigo     
				from HRCalculoNomina 
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEmpresas.Ecodigo#">
				  and RCdesde between 
				  		<cfqueryparam cfsqltype="cf_sql_date" value="#form.fechaIni_f#">
					and 
				  		<cfqueryparam cfsqltype="cf_sql_date" value="#form.fechaFin_f#">
			</cfquery>

			<!--- Cantidad de Nóminas Pagadas   (Nota 3) --->
			<cfquery name="rsNota3" datasource="#Ccache#">
				select count(1) as canNom
				from HRCalculoNomina 
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEmpresas.Ecodigo#">
				  and RCdesde between 
				  	<cfqueryparam cfsqltype="cf_sql_date" value="#form.fechaIni_f#"> 
						and 
					<cfqueryparam cfsqltype="cf_sql_date" value="#form.fechaFin_f#">
			</cfquery>
			
			<!--- Monto Total Pagado para una Empresa   (Nota 4) --->
			<cfquery name="rsNota4" datasource="#Ccache#">
				select (coalesce(sum(SEliquido),0)) as montoTot
				from HRCalculoNomina h, HSalarioEmpleado se
				where h.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEmpresas.Ecodigo#">
				  and h.RCdesde between 
				  	<cfqueryparam cfsqltype="cf_sql_date" value="#form.fechaIni_f#"> 
						and 
					<cfqueryparam cfsqltype="cf_sql_date" value="#form.fechaFin_f#">
				  and h.RCNid = se.RCNid			
			</cfquery>
			
			<cfif rsNota4.montoTot GT varMaxTotal>
				<cfset varMaxTotal = rsNota4.montoTot>
			</cfif>
			
			<cfif rsNota4.montoTot GT 0>
				<!---Totales--->
				<cfset QueryAddRow(rsTotales,1)>
				<cfset QuerySetCell(rsTotales,"empresa",varEmpresa)>
				<cfset QuerySetCell(rsTotales,"total",rsNota4.montoTot)>			
			</cfif>

			  <tr class=<cfif LvarListaNon>"listaNon"<cfelse>"listaPar"</cfif> onmouseover="this.className='listaParSel';" onmouseout="this.className='<cfif LvarListaNon>listaNon<cfelse>listaPar</cfif>';">
				<td>#HTMLEditFormat(Enombre)#</td>
				<td width="13%" align="right">		
					<!--- (Nota 1) --->					
					<cfif isdefined('rsNota1') and rsNota1.recordCount GT 0>#LSNumberFormat(rsNota1.cantEmpl)#<cfelse>0</cfif>
				</td>
				<!--- (Nota 2) --->
				<td width="12%" align="right">#LSNumberFormat(rsNota2.cantTcodigo)#</td>
				<!--- (Nota 3) --->
				<td width="12%" align="right">#LSNumberFormat(rsNota3.canNom)#</td>
				<!--- (Nota 4) --->
				<td width="57%" align="right">#LSNumberFormat(rsNota4.montoTot)#</td>
			  </tr>
				<cfset varTotEmplAct = varTotEmplAct + rsNota1.cantEmpl>
				<cfset varTotTipNom = varTotTipNom + rsNota2.cantTcodigo>
				<cfset varTotNomPag = varTotNomPag + rsNota3.canNom>
				<cfset varTotPagado = varTotPagado + rsNota4.montoTot>
		</cfif>
	</cfoutput>
				<!--- Coloca la linea de detalles para todas las empresas con la misma moneda --->
			  <tr class=<cfif LvarListaNon>"listaNon"<cfelse>"listaPar"</cfif> onmouseover="this.className='listaParSel';" onmouseout="this.className='<cfif LvarListaNon>listaNon<cfelse>listaPar</cfif>';">
				<td colspan="5"><hr></td>
			  </tr>				
			  <tr class=<cfif LvarListaNon>"listaNon"<cfelse>"listaPar"</cfif> onmouseover="this.className='listaParSel';" onmouseout="this.className='<cfif LvarListaNon>listaNon<cfelse>listaPar</cfif>';">
				<td nowrap align="right"><strong>Totales</strong></td>
				<cfoutput>
					<!--- (Nota 1) --->							
					<td width="13%" align="right"><strong>#LSNumberFormat(varTotEmplAct)#</strong></td>
					<!--- (Nota 2) --->
					<td width="12%" align="right"><strong>#LSNumberFormat(varTotTipNom)#</strong></td>
					<!--- (Nota 3) --->
					<td width="12%" align="right"><strong>#LSNumberFormat(varTotNomPag)#</strong></td>
					<!--- (Nota 4) --->
					<td width="57%" align="right"><strong>#LSNumberFormat(varTotPagado)#</strong></td>
				</cfoutput>
			  </tr>		
			</table>
			<!--- Cierra la linea para las empresas --->
		</td>
		<td align="center" valign="middle">
			<cfchart gridlines="5"
					 xaxistitle="Nombre" 
					 yaxistitle="Monto" 
					 scalefrom="0" 
					 show3d="yes" 
					 showborder="no" 
					 showlegend="yes"
					 chartwidth="320"
					 format="#varformat#"> 											  
			<cfchartseries 
				colorlist="##0099FF,##66CC33,##996699,##009999,##99CCFF,##A9A0C0,##D6C172,##C19B79,##92AC6C,##9F9F9F,##ACADD2,##D099AA" 			
				type="pie" 
				query="rsTotales" 
				valuecolumn="total" 
				itemcolumn="empresa">
			</cfchart> 		
		</td>
	</tr>	
	<tr>	
		<td colspan="3" align="center">-- Fin del Reporte --</td>
	</tr>				
</table>