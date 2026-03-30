<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_ReporteDeDescuentoDeAnticiposSolidaristas" default="Reporte de Descuento de Anticipos de Solidaristas" returnvariable="LB_ReporteDeDescuentoDeAnticiposSolidaristas" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Fecha" default="Fecha" returnvariable="LB_Fecha" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->
<cfquery name="rsReporte" datasource="#session.DSN#">
	 select c.ACPPfecha
			,coalesce(c.ACPPpagoPrincipal,0) as AbonoAnticipo
			,coalesce(c.ACPPpagoInteres,0) as Ingresos
			,coalesce(c.ACPPpagoPrincipal,0) + coalesce(c.ACPPpagoInteres,0) as Anticipo
			,{fn concat(e.DEnombre,{fn concat(' ',{fn concat(e.DEapellido1,{fn concat(' ',e.DEapellido2)})})})} as Nombre			
			,c.Did	   
			,e.DEidentificacion as Codigo
	 from HRCalculoNomina a  
		inner join HDeduccionesCalculo b
			on a.RCNid = b.RCNid				
			
			inner join ACPlanPagos c
				on b.Did = c.Did    
				and c.ACPPfecha between a.RCdesde and a.RChasta
				and c.ACPPestado = 'S' 	<!---Prestamos pagados---->
				
			inner join ACCreditosAsociado d
				on c.ACCAid = d.ACCAid 
				<cfif isdefined("url.ACCTid") and len(trim(url.ACCTid))>
					and d.ACCTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ACCTid#">
				</cfif>
				 and (d.ACCTcapital - d.ACCTamortizado) > 0
		 
		inner join DatosEmpleado e
			on b.DEid = e.DEid
			<cfif isdefined("url.DEidentificacion") and len(trim(url.DEidentificacion)) and isdefined("url.DEidentificacion_h") and len(trim(url.DEidentificacion_h))><!---DEid inicial y DEid final---->
				<cfif url.DEidentificacion GT url.DEidentificacion_h>
					and e.DEidentificacion between <cfqueryparam cfsqltype="cf_sql_char" value="#url.DEidentificacion_h#">
						 					and <cfqueryparam cfsqltype="cf_sql_char" value="#url.DEidentificacion#">	
				<cfelse>
					and e.DEidentificacion between <cfqueryparam cfsqltype="cf_sql_char" value="#url.DEidentificacion#">
								 			and <cfqueryparam cfsqltype="cf_sql_char" value="#url.DEidentificacion_h#">	
				</cfif>			  
			<cfelseif isdefined("url.DEidentificacion") and len(trim(url.DEidentificacion)) and (not isdefined("url.DEidentificacion_h") or len(trim(url.DEidentificacion_h)) EQ 0)><!----Solo DEid inicial---->
				and e.DEidentificacion = <cfqueryparam cfsqltype="cf_sql_char" value="#url.DEidentificacion#"> 
			<cfelseif isdefined("url.DEidentificacion_h") and len(trim(url.DEidentificacion_h)) and (not isdefined("url.DEidentificacion") or len(trim(url.DEidentificacion)) EQ 0)><!----Solo DEid final---->
				and e.DEidentificacion = <cfqueryparam cfsqltype="cf_sql_char" value="#url.DEidentificacion_h#"> 
			</cfif>	
				   
	 where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
		<cfif isdefined("url.RCNid") and len(trim(url.RCNid))>
			and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">
		</cfif>
	order by {fn concat(e.DEnombre,{fn concat(' ',{fn concat(e.DEapellido1,{fn concat(' ',e.DEapellido2)})})})}
	
</cfquery>

<!--- Busca el nombre de la Empresa --->
<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion
	from Empresas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
<cfif isdefined("url.RCNid") and len(trim(url.RCNid))><!----Descripcion de la planilla---->
	<cfquery name="rsPlanilla" datasource="#session.DSN#">
		select RCDescripcion, RCdesde, RChasta
		from HRCalculoNomina
		where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">
	</cfquery>
</cfif>
<cfif isdefined("url.ACCTid") and len(trim(url.ACCTid))><!----Descripcion del tipo de anticipo--->
	<cfquery name="rsTipoAnticipo" datasource="#session.DSN#">
		select ACCTdescripcion
		from ACCreditosTipo
		where ACCTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ACCTid#">
	</cfquery>
</cfif>

<style>
	.titulo_empresa2 {
		font-size:16px;
		font-weight:bold;
		text-align:center;}
	.titulo_columna {
		font-size:14px;
		font-weight:bold;
		background-color:#CCCCCC;
		height:20px}
	.detalle {font-size:14px;}		
</style>
<!---Variables con sumatorias---->
<cfset vn_anticipo = 0>
<cfset vn_abono = 0>
<cfset vn_ingresos = 0>
<cfif rsReporte.RecordCount>
	<table width="700" align="center" border="0" cellspacing="0" cellpadding="0">
		<cfoutput>
		<tr><td align="center" colspan="5" class="titulo_empresa2"><strong>#rsEmpresa.Edescripcion#</strong></td></tr>
		<tr><td align="center" colspan="5" class="titulo_empresa2"><strong>#LB_ReporteDeDescuentoDeAnticiposSolidaristas#</strong></td></tr>
		<tr><td align="right" colspan="5" class="detalle">#LB_Fecha#:#LSDateFormat(now(),'dd/mm/yyyy')#&nbsp;&nbsp;#TimeFormat(now(),'hh:mm:ss')#</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td colspan="5">
				<table width="100%" cellpadding="0" cellspacing="0">
					<tr>
						<td colspan="2">
							<cf_translate key="LB_Planilla">Planilla</cf_translate>:&nbsp;#rsPlanilla.RCdescripcion#&nbsp;
							<cf_translate key="LB_del">del</cf_translate>&nbsp;#LSDateFormat(rsPlanilla.RCdesde,'dd/mm/yyyy')#&nbsp;
							<cf_translate key="LB_al">al</cf_translate>&nbsp;#LSDateFormat(rsPlanilla.RChasta,'dd/mm/yyyy')#&nbsp;
						</td>						
					</tr>
					<cfif isdefined("rsTipoAnticipo") and rsTipoAnticipo.RecordCount NEQ 0>
						<tr>
							<td colspan="2"><cf_translate key="LB_TipoDeAnticipo">Tipo de Anticipo</cf_translate>:&nbsp;#rsTipoAnticipo.ACCTdescripcion#</td>
						</tr>	
					</cfif>
					<cfif isdefined("url.DEidentificacion") and len(trim(url.DEidentificacion)) and isdefined("url.DEidentificacion_h") and len(trim(url.DEidentificacion_h))>
						<tr>							
							<td class="detalle"><cf_translate key="LB_EmpleadoDesde">Empleado desde</cf_translate>:&nbsp;#url.DEidentificacion#</td>
							<td class="detalle"><cf_translate key="LB_EmpleadoHasta">Empleado hasta</cf_translate>:&nbsp;#url.DEidentificacion_h#</td>
						</tr>
					<cfelseif isdefined("url.DEidentificacion") and len(trim(url.DEidentificacion)) and (not isdefined("url.DEidentificacion_h") or len(trim(url.DEidentificacion_h)) EQ 0)><!----Solo DEid inicial---->
						<tr>							
							<td class="detalle"><cf_translate key="LB_Empleado">Empleado</cf_translate>:&nbsp;#url.DEidentificacion#</td>
						</tr>
					<cfelseif isdefined("url.DEidentificacion_h") and len(trim(url.DEidentificacion_h)) and (not isdefined("url.DEidentificacion") or len(trim(url.DEidentificacion)) EQ 0)><!----Solo DEid final---->
						<tr>							
							<td class="detalle"><cf_translate key="LB_Empleado">Empleado</cf_translate>:&nbsp;#url.DEidentificacion_h#</td>
						</tr>
					<cfelse>
						<tr><td><cf_translate key="LB_TodosLosEmpleados">Todos los Empleados</cf_translate></td></tr>
					</cfif>
				</table>
			</td>
		</tr>
		</cfoutput>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td class="titulo_columna" width="15%"><strong><cf_translate key="LB_Codigo">C&oacute;digo</cf_translate></strong></td>
			<td class="titulo_columna" width="28%"><strong><cf_translate key="LB_Nombre">Nombre</cf_translate></strong></td>
			<td class="titulo_columna" align="right" width="15%"><strong><cf_translate key="LB_Anticipo">Anticipo</cf_translate></strong></td>
			<td class="titulo_columna" align="right" width="17%" nowrap><strong><cf_translate key="LB_AbonoAnticipo">Abono Anticipo</cf_translate></strong></td>
			<td class="titulo_columna" align="right" width="15%"><strong><cf_translate key="LB_Ingresos">Ingresos</cf_translate></strong></td>				
		</tr>
		<cfoutput query="rsReporte">
			<tr>
				<td width="15%" class="detalle">#Codigo#</td>
				<td width="28%" class="detalle">#Nombre#</td>
				<td align="right" width="15%" class="detalle">#LSCurrencyFormat(rsReporte.Anticipo,'none')#</td>
				<td align="right" width="17%" class="detalle">#LSCurrencyFormat(rsReporte.AbonoAnticipo,'none')#</td>
				<td align="right" width="15%" class="detalle">#LSCurrencyFormat(rsReporte.Ingresos,'none')#</td>
			</tr>
			<cfset vn_anticipo = vn_anticipo + rsReporte.Anticipo>
			<cfset vn_abono = vn_abono + rsReporte.AbonoAnticipo>
			<cfset vn_ingresos = vn_ingresos + rsReporte.Ingresos>
		</cfoutput>
		<!---Totales--->
		<tr>
			<td colspan="2" align="right"><strong><cf_translate key="LB_Totales">Totales</cf_translate>:</strong></td>
			<cfoutput>
			<td align="right" width="15%" class="detalle" style="border-top:0.5px solid black;">#LSCurrencyFormat(vn_anticipo,'none')#</td>
			<td align="right" width="15%" class="detalle" style="border-top:0.5px solid black;">#LSCurrencyFormat(vn_abono,'none')#</td>
			<td align="right" width="15%" class="detalle" style="border-top:0.5px solid black;">#LSCurrencyFormat(vn_ingresos,'none')#</td>
			</cfoutput>
		</tr>
	</table>
<cfelse>
	<table width="700" align="center" border="0" cellspacing="0" cellpadding="0">
		<tr><td align="center"><cf_translate key="MSG_NoHayDatosRelacionados">No hay datos relacionados</cf_translate></td></tr>
	</table>
</cfif>
