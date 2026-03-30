<cfparam name="modo" default="ALTA">
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_Titulo1 		= t.Translate('LB_Titulo1','Tiendas Full')>
<cfset LB_Titulo2		= t.Translate('LB_Titulo2','Reporte de Promociones')>
<cfset LB_Titulo3		= t.Translate('LB_Titulo3','Generado el')>

<cfset LB_Codigo			= t.Translate('LB_Codigo', 'Codigo Promocion')>
<cfset LB_Descripcion		= t.Translate('LB_Descripcion', 'Descripcion')>
<cfset LB_FechaDesde		= t.Translate('LB_', 'Fecha Inicio')>
<cfset LB_FechaHasta		= t.Translate('LB_', 'Fecha Fin')>
<cfset LB_Monto				= t.Translate('LB_Monto', 'Monto Promocional')>
<cfset LB_Porciento		= t.Translate('LB_Porciento', 'Porcentaje Promocional')>

<cfset prevPag="reportePromociones.cfm">
<cfset targetAction="reportePromociones_sql.cfm">
<cfinclude template="imprimirReporte.cfm" >

<cfquery name="q_DatosReporte" datasource="#Session.DSN#">
	select
	  Codigo
	, Descripcion
	, FechaDesde
	, FechaHasta
	, Porciento
	, Monto
from CRCPromocionCredito
	where
		ecodigo = #session.ecodigo#
		<cfif !isDefined('url.p')> and 1=0 </cfif>
		<cfif isDefined('form.GenerarA')>
			<cfif isdefined("Form.FECHAHASTA") && Form.FECHAHASTA neq "">
				<cfset form.FECHAHASTA = ListToArray(form.FECHAHASTA,'/')>
				<cfset form.FECHAHASTA = "#form.FECHAHASTA[3]#-#form.FECHAHASTA[2]#-#form.FECHAHASTA[1]#">
				and FechaHasta <= dateAdd(day, 1, <cfqueryparam cfsqltype="cf_sql_date" value="#form.FechaHasta#">)
			</cfif>
			<cfif isdefined("Form.FECHADESDE") && Form.FECHADESDE neq "">
				<cfset form.FECHADESDE = ListToArray(form.FECHADESDE,'/')>
				<cfset form.FECHADESDE = "#form.FECHADESDE[3]#-#form.FECHADESDE[2]#-#form.FECHADESDE[1]#">
				and FechaDesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#form.FECHADESDE#">
			</cfif>
		</cfif>
		<cfif isDefined('form.GENERARB')>
			<cfif isdefined("Form.FECHAEN") && Form.FECHAEN neq "">
				<cfset form.FECHAEN = ListToArray(form.FECHAEN,'/')>
				<cfset form.FECHAEN = "#form.FECHAEN[3]#-#form.FECHAEN[2]#-#form.FECHAEN[1]#">
				and <cfqueryparam cfsqltype="cf_sql_date" value="#form.FECHAEN#"> between FechaDesde and FechaHasta
			</cfif>
		</cfif>	
</cfquery>

<cfset modo="ALTA">


<cfoutput>
<!--- Tabla para mostrar resultados del reporte generado --->
<div id="#printableArea#">
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td valign="top">
			
				<table  width="100%" cellpadding="2" cellspacing="0" border="0">
					<tr><td colspan="4">&nbsp;</td></tr>
					
					<tr>
						<td height="22" align="center" width="40%">
							<span class="style1" style="font-family: verdana; font-size: 200%">#LB_Titulo1#</span><br>
							<span style="font-family: verdana; font-size: 100%"><strong>#LB_Titulo2#</strong><br></span>
							<strong>#LB_Titulo3# #LSDateFormat(Now(),'dd/mm/yyyy')#</strong><br>
						</td>
					</tr>
					<tr height="22" align="center"></tr>
					<tr>
						<table width="100%" border="0">
							<tr>
								<td colspan="9" align="right">
									Filtros:
									<cfif isdefined('Form.Nombre') && Form.Nombre neq ''> [Cliente = #Form.Nombre#]</cfif>
									<cfif isDefined('form.GenerarA')>
										<cfif isdefined('Form.fechaDesde') && Form.fechaDesde neq ''> [Fecha inicial = (#Form.fechaDesde#)]</cfif>
										<cfif isdefined('Form.fechaHasta') && Form.fechaHasta neq ''> [Fecha Final = (#Form.fechaHasta#)]</cfif>
									</cfif>
									<cfif isDefined('form.GenerarB')>
										<cfif isdefined('Form.fechaEn') && Form.fechaEn neq ''> [Fecha En = (#Form.fechaEn#)]</cfif>
									</cfif>	
								</td>
							</tr>
							<tr style="background-color: ##A9A9A9;">
								<td>#LB_Codigo#</td>
								<td>#LB_Descripcion#</td>
								<td>#LB_FechaDesde#</td>
								<td>#LB_FechaHasta#</td>
								<td>#LB_Monto#</td>
								<td>#LB_Porciento#</td>
							</tr>
							<cfif q_DatosReporte.RecordCount gt 0>
								<cfloop query="q_DatosReporte">
									<tr>
										<td>#q_DatosReporte.codigo#</td>
										<td>#q_DatosReporte.Descripcion#</td>
										<td>#DateFormat(q_DatosReporte.FechaDesde,"dd/mm/yyyy")#</td>
										<td>#DateFormat(q_DatosReporte.FechaHasta,"dd/mm/yyyy")#</td>
										<cfif q_DatosReporte.Porciento neq 1>
											<td>#lsCurrencyFormat(q_DatosReporte.Monto)#</td>
											<td>-</td>
										<cfelse>
											<td>-</td>
											<td>#lsNumberFormat(q_DatosReporte.Monto,"0.00")# %</td>
										</cfif>
									</tr>
								</cfloop>
							<cfelse>
									<tr><td colspan="9">&nbsp;</td></tr>
									<tr><td colspan="9" align="center"><font color="red"><span style="text-align: center;">--- No se encontraron resultados ---</span></font></td></tr>
							</cfif>
						</table>
					</tr>
				</table>
			</td>	
		</tr>
	</table>
</div>
</cfoutput>

