
<cfif isdefined("Exportar")>
	<cfset form.btnDownload = true>	
</cfif>

<cfset t = createObject("component", "sif.Componentes.Translate")>

<!--- Etiquetas de traduccion --->
<cfset LB_ReporteDistribucionPresupuestariaPPI = t.translate('LB_ReporteDistribucionPresupuestariaPPI','Reporte de Distribución Presupuestaria','/rh/ReporteDistribucionPresupuestariaPPI.xml')>
<cfset LB_Identificacion = t.translate('LB_Identificacion','Identificación','/rh/generales.xml')> 
<cfset LB_Nombre = t.translate('LB_Nombre','Nombre','/rh/generales.xml')>
<cfset LB_TotalGanado = t.translate('LB_TotalGanado','Total Ganado','/rh/ReporteDistribucionPresupuestariaPPI.xml')>
<cfset LB_Cuenta = t.translate('LB_Cuenta','Cuenta','/rh/generales.xml')>
<cfset LB_Porcentaje = t.translate('LB_Porcentaje','Porcentaje','/rh/generales.xml')>
<cfset LB_TipoDeCambio = t.translate('LB_TipoDeCambio','Tipo de cambio','/rh/generales.xml')/> 
<cfset LB_Total = t.translate('LB_Total','Total','/rh/generales.xml')>
<cfset LB_NoExistenRegistrosQueMostrar = t.Translate('LB_NoExistenRegistrosQueMostrar','No existen registros que mostrar','/rh/generales.xml')>

<cfset archivo = "ReporteDistribucionPresupuestariaPPI(#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#).xls">

<cf_htmlReportsHeaders filename="#archivo#" irA="ReporteDistribucionPresupuestariaPPI.cfm">

<cf_templatecss/> 
<cfset LvarHTTP = 'http://'>
<cfif isdefined("session.sitio.ssl_todo") and session.sitio.ssl_todo> <cfset LvarHTTP = 'https://'> </cfif>
<link href="<cfoutput>#LvarHTTP##cgi.server_name#<cfif len(trim(cgi.SERVER_PORT))>:#cgi.SERVER_PORT#</cfif></cfoutput>/cfmx/plantillas/IICA/css/reports.css" rel="stylesheet" type="text/css">


<cfif isdefined('form.chk_FiltroFechas') >	
	<cfset filtro1 = 'Desde #form.FechaDesde# Hasta #form.FechaHasta#'>
<cfelse>
	<cfset filtro1 = '#form.Tdescripcion1# - #form.CPdescripcion1#'/>		
</cfif>

<!--- Asigna formato de salida --->
<cfif isdefined("form.chkOpcion") and len(trim(form.chkOpcion))>
	<cfset vFormato = form.chkOpcion >
</cfif>	

<cf_translatedata name="get" tabla="CuentaEmpresarial" col="CEnombre" returnvariable="LvarCEnombre" conexion="asp">
<cfquery datasource="asp" name="rsCEmpresa">
	select #LvarCEnombre# as CEnombre 
	from CuentaEmpresarial 
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
</cfquery>

<cfset LB_Corp = rsCEmpresa.CEnombre>
<cfset titulocentrado2 = ''>
<cfset Lvar_TipoCambio = 1>
<cfset form.RCNid = 0 > 
<cfset lvarCols = 5 >


<!--- Verifica si se selecciono alguna nomina para aplicar al filtro de la consulta --->
<cfif isDefined("form.ListaNomina") and len(trim(form.ListaNomina))>
	<cfset form.RCNid = listAppend(form.RCNid, form.ListaNomina)>
</cfif> 

<cfquery name="rsMeses" datasource="sifcontrol">
	select VSdesc, VSvalor 
	from VSidioma 
	where VSgrupo = 1 and Iid = (select Iid from Idiomas where Icodigo='#session.idioma#')
</cfquery> 


<!--- Obtiene el resulset con el detalle de las nominas seleccionadas --->
<cfset rsDistPresPPI = getQuery() >  

<cfif rsDistPresPPI.recordcount>
	<cfset Lvar_TipoCambio = rsDistPresPPI.tipocambio>
	<cfif createDate(year(rsDistPresPPI.mesMax), month(rsDistPresPPI.mesMax), 1) neq createDate(year(rsDistPresPPI.mesMin), month(rsDistPresPPI.mesMin), 1) >
		<cfquery dbtype="query" name="rs1">
			select VSdesc 
			from rsMeses 
			where VSvalor = '#month(rsDistPresPPI.mesMin)#'
		</cfquery>
		
		<cfquery dbtype="query" name="rs2">
			select VSdesc 
			from rsMeses 
			where VSvalor = '#month(rsDistPresPPI.mesMax)#'
		</cfquery>
		<cfset LB_InformeParaElPeriodo = t.translate('LB_InformeParaElPeriodo','Informe para el periodo','/rh/generales.xml')/>
		<cfset titulocentrado2 = '#LB_InformeParaElPeriodo# #rs1.VSdesc# #year(rsDistPresPPI.mesMin)# - #rs2.VSdesc# #year(rsDistPresPPI.mesMax)#'>
	<cfelse>	
		<cfquery dbtype="query" name="rs1">
			select VSdesc 
			from rsMeses 
			where VSvalor = '#month(rsDistPresPPI.mesMax)#'
		</cfquery>
		<cfset LB_InformeAlMesDe = t.translate('LB_InformeAlMesDe','Informe al mes de','/rh/generales.xml')/>
		<cfset titulocentrado2 = '#LB_InformeAlMesDe# #rs1.VSdesc# #year(rsDistPresPPI.mesMax)#'>
	</cfif>	

	<cfif isdefined("Exportar") or isdefined("Consultar")>
		<cf_HeadReport addTitulo1='#LB_Corp#' filtro1='#titulocentrado2#' filtro2="#LB_TipoDeCambio#: #Lvar_TipoCambio#" cols="#lvarCols-2#"  showEmpresa="true" showline="false">
		<cfoutput>#getHTML(rsDistPresPPI)#</cfoutput>
	</cfif>	
<cfelse>	 
	<cf_HeadReport addTitulo1='#LB_Corp#' filtro1='#titulocentrado2#' showEmpresa="true" showline="false">
	<div align="center" style="margin: 15px 0 15px 0"> --- <b><cfoutput>#LB_NoExistenRegistrosQueMostrar#</cfoutput></b> ---</div>
</cfif>


<cffunction name="getQuery" returntype="query">
	<cf_dbfunction name="op_concat" returnvariable="concat">
	<cfquery name="rsDistPresPPI" datasource="#session.DSN#">
		select x.Cedula, x.Nombre, x.Cuenta, sum(x.TotalGanado) as TotalGanado, max(x.Porcentaje) as Porcentaje, min(x.mesMin) as mesMin, max(x.mesMax) as mesMax, max(x.tipocambio) as tipocambio
		from(
			select r.Cedula, r.Nombre, r.Cuenta, r.TotalGanado, case when r.Total > 0 then (r.TotalGanado*100)/r.Total else 0 end as Porcentaje, r.referencia,r.mesMin,r.mesMax,r.tipocambio
			from(
				select dte.DEid, dte.DEidentificacion as Cedula, dte.DEnombre #concat#' '#concat# dte.DEapellido1 #concat#' '#concat# 
				dte.DEapellido2 as Nombre, rct.Cformato as Cuenta, case when rct.tiporeg =10 then 1 else rct.referencia end as referencia,  sum(coalesce(rct.montores,0)) as TotalGanado,
				min(rcn.RCdesde) as mesMin, max(rcn.RChasta) as mesMax,
				max(rcn.RCtc) as tipocambio,
				(   
					select sum(coalesce(rc.montores,0)) 
					from RCuentasTipo rc 
					inner join CFuncional cf
					    on rc.CFid = cf.CFid
					where rc.RCNid = rcn.RCNid 
						and rc.Ecodigo = rcn.Ecodigo
				    	and rc.DEid = dte.DEid
				    	and rc.referencia = rct.referencia
						and (rc.tiporeg = 10 or (rc.tiporeg = 20 and exists(select 1
																                from HIncidenciasCalculo hic
																                inner join CIncidentes ci
																                    on hic.CIid = ci.CIid
																                    and ci.CInoanticipo = 0 
																                where hic.RCNid = rcn.RCNid
		        															)))  
				) as Total
				from HRCalculoNomina rcn
				inner join RCuentasTipo rct
				    on rcn.RCNid = rct.RCNid
				    and rcn.Ecodigo = rct.Ecodigo 
					inner join CFuncional cf
				        on rct.CFid = cf.CFid  
				    inner join DatosEmpleado dte
						on rct.DEid = dte.DEid    
				where rcn.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                	<!---and x.Porcentaje <= 100--->
					and (rct.tiporeg = 10 or (rct.tiporeg = 20 and exists(  select 1
																		        from HIncidenciasCalculo hic
																		        inner join CIncidentes ci
																		            on hic.CIid = ci.CIid
																		            and ci.CInoanticipo = 0 
																		        where hic.RCNid = rcn.RCNid
																			)))
				<cfif isdefined('form.chk_FiltroFechas') >
					<cfif isdefined('form.FechaDesde') and LEN(TRIM(form.FechaDesde))>
						and rcn.RChasta >= <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#LSParseDateTime(form.FechaDesde)#"> 		
				    </cfif>
				    <cfif isdefined('form.FechaHasta') and LEN(TRIM(form.FechaHasta))>
				  		and rcn.RCdesde <= <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#LSParseDateTime(form.FechaHasta)#"> 		
				    </cfif>		 
				<cfelse>
				    <cfif isdefined("form.RCNid") and len(trim(form.RCNid)) GT 0>
						and rcn.RCNid in (<cfqueryparam cfsqltype="cf_sql_integer" value="#form.RCNid#" list="true" />) 
					</cfif>	
				</cfif>             
				group by 
					dte.DEid, dte.DEidentificacion, dte.DEnombre, dte.DEapellido1, dte.DEapellido2, rct.Cformato, rct.tiporeg, rct.referencia, rcn.RCNid, rcn.Ecodigo	
			) r	
		) x
		group by x.Cedula, x.Nombre, x.Cuenta
		order by x.Cedula, x.Nombre, x.Cuenta 
	</cfquery>
	

	<cfreturn rsDistPresPPI>
</cffunction>	

<cffunction name="getHTML" output="true">	
	<cfargument name="rsDistPresPPI" type="query" required="true">

	<table class="reporte" width="100%">	
		<thead>
			<tr>
				<th style="text-align:left;"><strong>#LB_Identificacion#</strong></th>
	            <th style="text-align:left;"><strong>#LB_Nombre#</strong></th> 
	            <th><strong>#LB_TotalGanado#</strong></th>  
	            <th><strong>#LB_Cuenta#</strong></th>
	            <th><strong>#LB_Porcentaje#</strong></th> 
			</tr>	
		</thead>	
		<tbody>
			<cfset totGanadoGen = 0>
			<cfloop query='Arguments.rsDistPresPPI'>
				<tr>
					<td align='left'>#Cedula#</td>
					<td align='left' nowrap>#Nombre#</td>
					<td align='right'><cf_locale name="number" value="#TotalGanado#"/></td>
					<td align='left' nowrap>#Cuenta#</td>
					<td align='right'><cfif Porcentaje neq 0>#NumberFormat(Porcentaje,"00.00")# % <cfelse>0</cfif></td>
				</tr>	
				<cfset totGanadoGen += TotalGanado>
			</cfloop>
			<tr><td colspan="#lvarCols#">&nbsp;</td></tr>
			<tr>
				<td align="right" colspan="#lvarCols-3#"><strong>#LB_Total#</strong></td>
				<td align='right'><strong><cf_locale name="number" value="#totGanadoGen#"/></strong></td>
				<td colspan="#lvarCols-3#">&nbsp;</td>
			</tr>	
			<tr><td colspan="#lvarCols#">&nbsp;</td></tr>
		</tbody>
	</table>
</cffunction>	