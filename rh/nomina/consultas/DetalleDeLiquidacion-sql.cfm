<cfset Resumido=True>

<!--- Etiquetas de traducción --->
<cfset t = createObject("component","sif.Componentes.Translate")> 
<cfset LB_Total = t.translate('LB_Total','Total','/rh/generales.xml')/>
<cfset LB_Codigo = t.translate('LB_Codigo','Código','/rh/generales.xml')/>
<cfset LB_Nombre = t.translate('LB_Nombre','Nombre','/rh/generales.xml')/>
<cfset LB_Unidad = t.translate('LB_Unidad','Unidad','/rh/generales.xml')/>
<cfset LB_Puesto = t.translate('LB_Puesto','Puesto','/rh/generales.xml')/>
<cfset LB_CategoriaDePago = t.translate('LB_CategoriaDePago','Categoría de pago','/rh/generales.xml')/>
<cfset LB_FechaDeIngreso = t.translate('LB_FechaDeIngreso','Fecha de ingresos','/rh/generales.xml')/>
<cfset LB_Mes = t.translate('LB_Mes','Mes','/rh/generales.xml')/>
<cfset LB_Anno = t.translate('LB_Anno','Año','/rh/generales.xml')/>
<cfset LB_Accion = t.translate('LB_Accion','Acción','/rh/generales.xml')/>
<cfset LB_Edad = t.translate('Edad','Edad','expediente-cons.xml')/>
<cfset LB_FechaDeSalida = t.translate('LB_FechaDeSalida','fecha de salida')/>
<cfset LB_TotalAPagarEnLiquidacion = t.translate('LB_TotalAPagarEnLiquidacion','Total a pagar en liquidación')/>
<cfset LB_NoExistenRegistrosQueMostrar = t.Translate('LB_NoExistenRegistrosQueMostrar','No existen registros que mostrar','/rh/generales.xml')>

<cfset archivo = "DetalleLiquidacion(#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#).xls">

<cf_htmlreportsheaders ira="DetalleDeLiquidacion.cfm" filename="#archivo#">
<cf_templatecss>

<cfinvoke component="rh.Componentes.RH_Funciones" method="DeterminaEmpresasPermiso" returnvariable="EmpresaLista">

<cfif not isDefined("Form.fechadesde")>
	<cfset Form.fechadesde = DateFormat(Now(),'dd/mm/yyyy')>
</cfif>	

<cfif not isDefined("Form.fechahasta")>
	<cfset Form.fechahasta = DateFormat(Now(),'dd/mm/yyyy')>
</cfif>

<cf_translatedata name="get" tabla="CuentaEmpresarial" col="CEnombre" conexion="asp" returnvariable="LvarCEnombre">
<cfquery datasource="asp" name="rsCEmpresa">
	select #LvarCEnombre# as CEnombre 
	from CuentaEmpresarial 
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
</cfquery>

<cfset LB_Corp = rsCEmpresa.CEnombre>
<cfset lvarCols = 11 >

<cfset showEmpresa = true>
<cfif isDefined("form.esCorporativo")>
	<cfif form.JtreeListaItem eq 0>
		<cfset form.JtreeListaItem = EmpresaLista>	
	</cfif>
	<cfset showEmpresa = false>
<cfelse>
	<cfset form.JtreeListaItem = session.Ecodigo>		
</cfif>

<cfsavecontent variable="LvarWhere">
	where rh.Ecodigo in (<cfoutput>#form.JtreeListaItem#</cfoutput>)
		and dle.DLfvigencia between <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.fechadesde)#"> and <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.fechahasta)#">
</cfsavecontent>
	
<cf_dbfunction name="op_concat" returnvariable="concat">
<cf_translatedata name="get" tabla="CFuncional" col="cf.CFdescripcion" returnvariable="LvarCFdescripcion">
<cf_translatedata name="get" tabla="RHTipoAccion" col="ta.RHTdesc" returnvariable="LvarRHTdesc">
<cf_translatedata name="get" tabla="CIncidentes" col="ci.CIdescripcion" returnvariable="LvarCIdescripcion">
<cf_translatedata name="get" tabla="DCargas" col="dc.DCdescripcion" returnvariable="LvarDCdescripcion">
<cf_translatedata name="get" tabla="TDeduccion" col="td.TDdescripcion" returnvariable="LvarTDdescripcion">
<cf_translatedata name="get" tabla="RHPuestos" col="rhpu.RHPdescpuesto" returnvariable="LvarRHPdescpuesto">

<cfquery name="rsLiquidacion" datasource="#session.dsn#">
	select dle.DLlinea, de.DEidentificacion, de.DEapellido1 #concat#' '#concat#de.DEapellido2#concat#' '#concat#de.DEnombre as emp, rhpu.RHPcodigo#concat#' - '#concat##LvarRHPdescpuesto# as puesto,    
	cf.CFcodigo#concat#' - '#concat##LvarCFdescripcion# as centrofuncional,
	rhc.RHCcodigo#concat#' / '#concat# rhtt.RHTTcodigo as categoria,
	coalesce(eve.EVfantigCorp, eve.EVfantig) as ingreso,
	dle.DLfvigencia as fechasalida,
	<cf_dbfunction name="datediff" args="de.DEfechanac,dle.DLfvigencia,yyyy"> as edadfechasalida,
	ta.RHTcodigo#concat#' - '#concat##LvarRHTdesc# as accion,
	x.tipo
	<cfif Resumido>
    	,coalesce(rhar.RHARid, x.ref) as  ref
        ,coalesce(rhar.RHARdescripcion, x.descr) as descr
        ,sum(x.monto) as monto
    <cfelse>
    	, x.ref
        , x.descr
    	, x.monto
    </cfif>
    
	from (
		select rh.DLlinea,rh.DEid,1 as tipo, ci.CIid as ref, coalesce(coalesce(i.RHLIresultado,i.importe),0) as monto, #LvarCIdescripcion# as descr, 'CIncidentes' as tabla,'CIid' as campo
		from RHLiquidacionPersonal rh
	    inner join RHLiqIngresos i
	        on rh.DLlinea = i.DLlinea
	    inner join CIncidentes ci
	        on i.CIid = ci.CIid
	    inner join DLaboralesEmpleado dle
	    	on dle.DLlinea = rh.DLlinea    
	    #preserveSingleQuotes(LvarWhere)#
		union
		select rh.DLlinea,rh.DEid,2 as tipo, dc.DClinea as ref, coalesce(i.importe,0) as monto, #LvarDCdescripcion# as descr, 'DCargas' as tabla,'DClinea' as campo
		from RHLiquidacionPersonal rh
	    inner join RHLiqCargas i
	        on rh.DLlinea = i.DLlinea
	    inner join DCargas dc
	        on i.DClinea = dc.DClinea
	    inner join DLaboralesEmpleado dle
	    	on dle.DLlinea = rh.DLlinea
	    #preserveSingleQuotes(LvarWhere)#    
		union
		select rh.DLlinea,rh.DEid,3 as tipo, td.TDid as ref , coalesce(i.importe,0) as monto, #LvarTDdescripcion# as descr, 'TDeduccion' as tabla,'TDid' as campo
		from RHLiquidacionPersonal rh
	    inner join RHLiqDeduccion i
	        on rh.DLlinea = i.DLlinea
	    inner join DeduccionesEmpleado de
	        on i.Did = de.Did
	    inner join TDeduccion td
	        on de.TDid = td.TDid
	    inner join DLaboralesEmpleado dle
	    	on dle.DLlinea = rh.DLlinea
	    #preserveSingleQuotes(LvarWhere)#    
	) x
	inner join DLaboralesEmpleado dle
	    on x.DLlinea = dle.DLlinea
	inner join DatosEmpleado de
	    on dle.DEid = de.DEid
	inner join EVacacionesEmpleado eve
	    on eve.DEid = de.DEid
	inner join RHTipoAccion ta
	    on dle.RHTid = ta.RHTid
	inner join RHPlazas rhp
	    on rhp.RHPid = dle.RHPid
	inner join RHPuestos rhpu
		on rhp.RHPpuesto = rhpu.RHPcodigo
		and rhp.Ecodigo = rhpu.Ecodigo   
	inner join CFuncional cf
	    on cf.CFid = rhp.CFid
	left join RHCategoriasPuesto rhcp
	    on rhcp.RHCPlinea = dle.RHCPlinea
	left join RHCategoria rhc  
	    on rhc.RHCid = rhcp.RHCid
	left join RHTTablaSalarial rhtt
	    on rhtt.RHTTid = rhcp.RHTTid  
    <cfif Resumido>
    	left outer join RHDAgrupadorRubro rhdar
            on  rhdar.RHDARtabla = x.tabla
            and rhdar.RHDARcampo = x.campo 
            and rhdar.RHDARvalor = x.ref
        left outer join RHAgrupadorRubro rhar
            on  rhdar.RHARid = rhar.RHARid
    </cfif>
    <cfif Resumido>
    	group by dle.DLlinea, de.DEidentificacion, de.DEapellido1, de.DEapellido2,de.DEnombre,rhpu.RHPcodigo,rhpu.RHPdescpuesto,cf.CFcodigo,cf.CFdescripcion, rhc.RHCcodigo,rhtt.RHTTcodigo,coalesce(eve.EVfantigCorp, eve.EVfantig), dle.DLfvigencia, ta.RHTcodigo, ta.RHTdesc, x.tipo, rhpu.RHPdescpuesto_es_CR, cf.CFdescripcion_es_CR, de.DEfechanac, ta.RHTdesc_es_CR,coalesce(rhar.RHARid, x.ref),coalesce(rhar.RHARdescripcion, x.descr)
    </cfif>
	<!---order by de.DEapellido1, de.DEapellido2, de.DEnombre, x.ref, x.descr--->
</cfquery>

<!---Empresas--->
<cfquery datasource="#session.DSN#" name="rsEmpresa">
	select Edescripcion
	from Empresas 
	where Ecodigo in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.JtreeListaItem#" list="true">)
</cfquery>
<cfset vEmpresa =  valuelist(rsEmpresa.Edescripcion,', ')>

<cfset filtro1 = "<strong>Empresas:</strong> #vEmpresa# <br/>">
<cfset filtro1 = filtro1 & '<strong>Desde</strong> #form.FechaDesde# <strong>Hasta</strong> #form.FechaHasta#'>

<cfif rsLiquidacion.recordcount>
	<cfquery name="rsColumnas" dbtype="query">
		select distinct tipo, descr, ref 
		from rsLiquidacion 
		order by tipo, descr, ref
	</cfquery>

	<cfset StructCol = StructNew()>
	<cfloop query="rsColumnas">
		<cfset StructCol["orden#tipo#ref#ref#tipo"] = descr>
		<cfset StructCol["orden#tipo#ref#ref#total"] = 0>
	</cfloop>
	<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
    <html xmlns="http://www.w3.org/1999/xhtml">
    <head>
    <style>
        thead { display: table-header-group; }
        tfoot { display: table-footer-group; }
        
        @media print {
        thead { display: table-header-group; }
        tfoot { display: table-footer-group; }
        }
        @media screen {
            thead { display: none; }
            tfoot { display: none; }
        }
        table { page-break-inside:auto }
        tr { page-break-inside:avoid; page-break-after:auto }
    </style>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>#LB_Corp#</title>
    </head>
    <body> 
        <cf_HeadReport 
            addTitulo1='#LB_Corp#'
            filtro1="#filtro1#"
            showEmpresa="false"
            showline="false" 
            cols="#lvarCols-2#">
        <cfoutput>#getHTML()#</cfoutput> 
    </body>
    </html>	
    
<cfelse>	 
	<cf_HeadReport 
    	addTitulo1='#LB_Corp#'
        filtro1="#filtro1#" 
        showEmpresa="false"
        showline="false">
	<div align="center" style="margin: 15px 0 15px 0"> --- <b><cfoutput>#LB_NoExistenRegistrosQueMostrar#</cfoutput></b> ---</div>
</cfif>


<cffunction name="getHTML" output="true">
	<table class="reporte">
		<thead style="display: table-header-group">
			<th>#LB_Codigo#</th>
			<th>#LB_Nombre#</th>
			<th>#LB_Unidad#</th>
			<th>#LB_Puesto#</th>
			<th>#LB_CategoriaDePago#</th>
			<th>#LB_FechaDeIngreso#</th>
			<!---<th>#LB_Mes#</th>
			<th>#LB_Anno#</th>--->
			<th>#LB_FechaDeSalida#</th>
			<th>#LB_Edad#</th>
			<th>#LB_Accion#</th>
			<cfloop query="rsColumnas">
				<th>#StructCol["orden#tipo#ref#ref#tipo"]#</th>	
			</cfloop>
			<th>#LB_TotalAPagarEnLiquidacion#</th>
		</thead>
		<tbody>
			<cfset montoTotal = 0>
			<cfloop query="rsLiquidacion" group="DLlinea">
				<cfset montoEmp = 0>
				<tr>
					<cfoutput>
						<td nowrap>#DEidentificacion#</td>
						<td nowrap>#emp#</td>
						<td>#centrofuncional#</td>
						<td>#puesto#</td>
						<td>#categoria#</td>
						<td align="right"><cf_locale name="date" value="#ingreso#"/></td>
						<!---<td align="right">#month(fechasalida)#</td>
						<td align="right">#year(fechasalida)#</td>--->
						<td align="right"><cf_locale name="date" value="#fechasalida#"/></td>
						<td align="right">#edadfechasalida#</td>
						<td align="left">#accion#</td>
					</cfoutput>
					<cfset tupla = structNew()>
					<cfloop> 
						<cfset tupla["orden#rsLiquidacion.tipo#ref#rsLiquidacion.ref#total"] = rsLiquidacion.monto>
						<cfset StructCol["orden#rsLiquidacion.tipo#ref#rsLiquidacion.ref#total"] += rsLiquidacion.monto>
						<cfif rsLiquidacion.tipo eq 1>
							<cfset montoEmp += rsLiquidacion.monto>
						<cfelse>
							<cfset montoEmp -= rsLiquidacion.monto>
						</cfif>
					</cfloop>
					<cfloop query="rsColumnas">
						<td align="right">
							<cfif StructKeyExists(tupla, 'orden#tipo#ref#ref#total')>
								<cf_locale name="number" value="#tupla['orden#tipo#ref#ref#total']#"/>
							<cfelse>
								<cf_locale name="number" value="0"/>		
							</cfif>
						</td>	
					</cfloop>
					<td align="right"><cf_locale name="number" value="#montoEmp#"/></td>
				</tr>
				<cfset montoTotal += montoEmp>
			</cfloop>
			<tr>
				<td colspan="9" align="right"><strong>#LB_Total#</strong></td>
				<cfloop query="rsColumnas">
					<td align="right">
						<cfif StructKeyExists(StructCol, 'orden#tipo#ref#ref#total')>
							<cf_locale name="number" value="#StructCol['orden#tipo#ref#ref#total']#"/>
						<cfelse>
							<cf_locale name="number" value="0"/>		
						</cfif>
					</td>	
				</cfloop>
				<td align="right"><cf_locale name="number" value="#montoTotal#"/></td>
			</tr>
		</tbody>	
	</table>
</cffunction>	
