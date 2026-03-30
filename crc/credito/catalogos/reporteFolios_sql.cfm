<cfparam name="modo" default="ALTA">
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_Titulo1 		= t.Translate('LB_Titulo1','Tiendas Full')>
<cfset LB_Titulo2		= t.Translate('LB_Titulo2','Reporte de Folios Otorgados')>
<cfset LB_Titulo3		= t.Translate('LB_Titulo3','Generado el')>
<cfset LB_Numero		= t.Translate('LB_Numero', 'Numero de Cuenta')>
<cfset LB_Nombre		= t.Translate('LB_Nombre', 'Nombre de Socio')>
<cfset LB_Lote			= t.Translate('LB_Lote', 'Lote')>
<cfset LB_Folio			= t.Translate('LB_Folio', 'Numero de Folio')>
<cfset LB_Estado		= t.Translate('LB_Estado', 'Estado')>
<cfset LB_Generado		= t.Translate('LB_Generado', 'Fecha Generado')>
<cfset LB_Expiracion	= t.Translate('LB_Expiracion', 'Fecha Expiracion')>
<cfset LvarPagina = "reporteFolios.cfm">

<cfset prevPag="reporteFolios.cfm">
<cfset targetAction="reporteFolios_sql.cfm">
<cfinclude template="imprimirReporte.cfm" >

<cfquery name="q_DatosReporte" datasource="#Session.DSN#">
	select 
		c.Numero as ctaNum
		, sn.SNnombre
		, f.Lote
		, f.Numero as folio
		, case f.Estado
		    when 'I' then 'Impreso'
			when 'C' then 'Consumido'
			when 'A' then 'Activo'
			when 'G' then 'Generado'
			when 'X' then 'Cancelado'
			else f.Estado end as Estado
		, f.createdat as creado
		, f.FechaExpiracion
		, f.FechaHasta
	from CRCControlFolio f
		inner join CRCCuentas c
			on c.id = f.CRCCuentasid
		inner join SNegocios sn
			on sn.SNid = c.SNegociosSNid
	where
		c.ecodigo = #session.ecodigo#
		<cfif !isDefined('url.p')> and 1=0 </cfif>
		<cfif isdefined ("Form.SNID") and Form.SNID neq "">
			and sn.SNID= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SNID#">
		</cfif>
		<cfif isdefined("Form.FECHAHASTA") && Form.FECHAHASTA neq "">
			<cfset form.FECHAHASTA = ListToArray(form.FECHAHASTA,'/')>
			<cfset form.FECHAHASTA = "#form.FECHAHASTA[3]#-#form.FECHAHASTA[2]#-#form.FECHAHASTA[1]#">
			and f.createdat <= dateAdd(day, 1, <cfqueryparam cfsqltype="cf_sql_date" value="#form.FechaHasta#">)
		</cfif>
		<cfif isdefined("form.slEstado") and form.slEstado neq "">
			and f.Estado = '#form.slEstado#'
		</cfif>
		<cfif isdefined("Form.FECHADESDE") && Form.FECHADESDE neq "">
			<cfset form.FECHADESDE = ListToArray(form.FECHADESDE,'/')>
			<cfset form.FECHADESDE = "#form.FECHADESDE[3]#-#form.FECHADESDE[2]#-#form.FECHADESDE[1]#">
			and f.createdat >= <cfqueryparam cfsqltype="cf_sql_date" value="#form.FECHADESDE#">
		</cfif>	
</cfquery>
<cfset modo="ALTA">

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
									<cfif isdefined('Form.fechaDesde') && Form.fechaDesde neq ''> [Fecha inicial = (#Form.fechaDesde#)]</cfif>
									<cfif isdefined('Form.fechaHasta') && Form.fechaHasta neq ''> [Fecha Final = (#Form.fechaHasta#)]</cfif>
								</td>
							</tr>
							<tr style="background-color: ##A9A9A9;">
								<td>#LB_Numero#</td>
								<td>#LB_Nombre#</td>
								<td>#LB_Lote#</td>
								<td>#LB_Folio#</td>
								<td>#LB_Estado#</td>
								<td>#LB_Generado#</td>
							</tr>
							<cfif q_DatosReporte.RecordCount gt 0>
								<cfloop query="q_DatosReporte">
									<tr>
										<td>#q_DatosReporte.ctaNum#</td>
										<td>#q_DatosReporte.SNnombre#</td>
										<td>#q_DatosReporte.Lote#</td>
										<td>#q_DatosReporte.folio#</td>
										<td>#q_DatosReporte.Estado#</td>
										<td>#DateFormat(q_DatosReporte.creado,"dd/mm/yyyy")#</td>
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

