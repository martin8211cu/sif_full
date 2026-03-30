<cfif isDefined("url.ajaxresponse") and isDefined("url.DClinea")>
	<cf_translatedata name="get" col="DCdescripcion" tabla="DCargas" returnvariable="LvarDCdescripcion">
	<cfquery datasource="#session.dsn#" name="rs">
		select  DClinea,DCcodigo,#LvarDCdescripcion# as DCdescripcion 
		from DCargas 
		where DClinea in(<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DClinea#" list="true">)
	</cfquery>

	<cfoutput query="rs">
		<tr><td><input type="hidden" id="ListaDClinea" name="ListaDClinea" value="#rs.DClinea#"></td><td>#DCcodigo#</td><td>#DCdescripcion#</td><td><i class="fa fa-times fa-1x" style="color:red" onClick="$(this).parent().parent().remove()"></i></td></tr>
	</cfoutput>.
	<cfabort>
</cfif>

<cfif isDefined("url.ajaxresponse") and isDefined("url.TDid")>
	<cf_translatedata name="get" col="TDdescripcion" tabla="TDeduccion" returnvariable="LvarTDdescripcion">
	<cfquery datasource="#session.dsn#" name="rs">
		select distinct TDid,TDcodigo,#LvarTDdescripcion# as TDdescripcion 
		from TDeduccion 
		where  TDid in(<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.TDid#" list="true">)
	</cfquery>

	<cfoutput query="rs">
		<tr><td><input type="hidden" id="ListaTDid" name="ListaTDid" value="#rs.TDid#"></td><td>#TDcodigo#</td><td>#TDdescripcion#</td><td><i class="fa fa-times fa-1x" style="color:red" onClick="$(this).parent().parent().remove()"></i></td></tr>
	</cfoutput>
	<cfabort>
</cfif>.

<cfset t = createObject("component","sif.Componentes.Translate")>
<cfset rut = '/rh/nomina/consultas/RepDetallePlanillaRevision.xml'>
<cfset LvarFileName = "Lst_RepDetallePlanillaRevision_#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">
<cfset LB_titulo = t.translate('LB_titulo','Reporte de Planilla para revisión',rut)/>
<cfset LB_Empleado = t.translate('LB_Empleado','Empleado','/rh/generales.xml')/>
<cfset LB_Codigo = t.translate('LB_Codigo','Código','/rh/generales.xml')/>
<cfset LB_Salario = t.translate('LB_Salario','Salario','/rh/generales.xml')/>
<cfset LB_Liquido = t.translate('LB_Liquido','Líquido','/rh/generales.xml')/>
<cfset LB_Total = t.translate('LB_Total','Total','/rh/generales.xml')/>
 	 
<cf_htmlReportsHeaders title="#LB_titulo#" filename="#LvarFileName#" irA="RepDetallePlanillaRevision.cfm">

<cfset LvarHTTP = 'http://'>
<cfif isdefined("session.sitio.ssl_todo") and session.sitio.ssl_todo> <cfset LvarHTTP = 'https://'> </cfif>
<link href="<cfoutput>#LvarHTTP##cgi.server_name#<cfif len(trim(cgi.SERVER_PORT))>:#cgi.SERVER_PORT#</cfif></cfoutput>/cfmx/plantillas/IICA/css/reports.css" rel="stylesheet" type="text/css">
<cf_templatecss/>

<style type="text/css">
	.tituloDivisor { padding-top: 2em !important; padding-bottom: 1em !important; border-color: #000 !important;
		border-left: 0 !important; border-right: 0 !important; }
	.reporte { width: 100%;
			   font-size:9px;
			   font-family:Verdana, Geneva, sans-serif}
	th {font-size:10px;
		font-family:Verdana, Geneva, sans-serif}
</style>

<cfset pre = ''>
<cfif isDefined("form.chk_NominaAplicada") or isDefined("form.chkFiltroFechas")>
	<cfset pre = 'H'>
</cfif>	

<cf_dbfunction name="op_concat" returnvariable="concat">

<cfif isDefined("form.ListaDClinea")>
	<cfset form.DClinea = listAppend(form.DClinea,form.ListaDClinea)>
</cfif>

<cfif isDefined("form.ListaTDid")>
	<cfset form.TDid = listAppend(form.TDid,form.ListaTDid)>
</cfif>
  
<cf_translatedata name="get" tabla="CIncidentes" col="ci.CIdescripcion" returnvariable="LvarCIdescripcion">
<cf_translatedata name="get" tabla="DCargas" col="dc.DCdescripcion" returnvariable="LvarDCdescripcion">
<cf_translatedata name="get" tabla="TDeduccion" col="td.TDdescripcion" returnvariable="LvarTDdescripcion">

<!---coalesce(arg.RHARdescripcion, #LvarCIdescripcion# ) as tipo, coalesce(arg.RHARid,ic.CIid)--->
<cfquery datasource="#session.dsn#" name="rsReporte" >
	select de.DEapellido1 #concat#' '#concat# de.DEapellido2 #concat#' '#concat# de.DEnombre as nombre, x.orden, x.tipo, x.ref, 
	x.DEid, de.DEidentificacion, sum(x.valor) as valor
	from
	(
    	select 1 as orden, se.DEid,'#LB_Salario#' as tipo, 1 as ref, SEsalariobruto as valor
		from #pre#SalarioEmpleado se
		where se.RCNid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ListaNomina#" list="true">)
		
        union all   <!--- consulta para incidencias --->
		<cfif isdefined("form.Detallado")>
        	select 2 as orden, ic.DEid, ci.CIcodigo#concat#' - '#concat# #LvarCIdescripcion# as tipo, ic.CIid as red, ic.ICmontores as valor
        <cfelse>
        	select case when arg.RHARdescripcion is null then 3 else 2 end  as orden , ic.DEid, coalesce(arg.RHARdescripcion, #LvarCIdescripcion# ) as tipo, coalesce(arg.RHARid,ic.CIid) as ref, ic.ICmontores as valor
		</cfif>
        from #pre#IncidenciasCalculo ic
		inner join CIncidentes ci
			on ic.CIid = ci.CIid
        <cfif not isdefined("form.Detallado")>
        left outer join RHDAgrupadorRubro ar
        	on ar.RHDARvalor=ci.CIid
            and ar.RHDARtabla = 'CIncidentes'
            and ar.RHDARcampo = 'CIid'
        left outer join RHAgrupadorRubro arg
        	on arg.RHARid = ar.RHARid
        </cfif>
        where ic.RCNid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ListaNomina#" list="true">)
		
        union all    <!--- consulta para cargas --->
		<cfif isdefined("form.Detallado")>
        	select 3 as orden, cc.DEid, dc.DCcodigo#concat#' - '#concat# #LvarDCdescripcion# as tipo, cc.DClinea as ref, (cc.CCvalorpat+cc.CCvaloremp) as valor
        <cfelse>
        	select case when arg.RHARdescripcion is null then 7 else 6 end  as orden, cc.DEid, coalesce(arg.RHARdescripcion,#LvarDCdescripcion#) as tipo, coalesce(arg.RHARid, cc.DClinea) as ref, (cc.CCvalorpat+cc.CCvaloremp) as valor
		</cfif>
		from #pre#CargasCalculo cc
		inner join DCargas dc
			on cc.DClinea = dc.DClinea
        <cfif not isdefined("form.Detallado")>
        left outer join RHDAgrupadorRubro ar
        	on ar.RHDARvalor=dc.DClinea
            and ar.RHDARtabla = 'DCargas'
            and ar.RHDARcampo = 'DClinea'
        left outer join RHAgrupadorRubro arg
        	on arg.RHARid = ar.RHARid
        </cfif>
		where cc.RCNid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ListaNomina#" list="true">)
		<cfif len(trim(form.DClinea))>
			and cc.DClinea not in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DClinea#" list="true">)
		</cfif>
		
        union  all   <!--- consulta para deducciones --->
		<cfif isdefined("form.Detallado")>
        	select 4 as orden, dc.DEid, td.TDcodigo#concat#' - '#concat# #LvarTDdescripcion# as tipo, td.TDid as ref, dc.DCvalor as valor
        <cfelse>
        	select case when arg.RHARdescripcion is null then 5 else 4 end  as orden, dc.DEid, coalesce(arg.RHARdescripcion,#LvarTDdescripcion#) as tipo, coalesce(arg.RHARid,td.TDid) as ref, dc.DCvalor as valor
		</cfif>
		from #pre#DeduccionesCalculo dc
		inner join DeduccionesEmpleado de
			on dc.Did = de.Did
		inner join TDeduccion td
			on de.TDid = td.TDid
        <cfif not isdefined("form.Detallado")>
        left outer join RHDAgrupadorRubro ar
        	on ar.RHDARvalor=td.TDid
            and ar.RHDARtabla = 'TDeduccion'
            and ar.RHDARcampo = 'TDid'
        left outer join RHAgrupadorRubro arg
        	on arg.RHARid = ar.RHARid
        </cfif>
		where dc.RCNid  in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ListaNomina#" list="true">)
		<cfif len(trim(form.TDid))>
			and td.TDid not in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TDid#" list="true">)
		</cfif>
        <cfif not isdefined("form.Detallado")>
        and td.TDid not in (select distinct b.TDid
                            from RHExportacionDeducciones a
                                inner join TDeduccion b
                                    on a.TDid = b.TDid
                                inner join <cf_dbdatabase table="EImportador" datasource="sifcontrol"> ei
                                    on a.EIid = ei.EIid
                                 inner join Empresas c
                                    on c.Ecodigo=b.Ecodigo
                            where a.Ecodigo  in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.JtreeListaItem#" list="true">)
                            and a.RHEDesliquido = 1 <!---deducciones correspondientes a salario liquido--->
                         )
		</cfif>
        
        <cfif not isdefined("form.Detallado")>
        union all  <!--- consulta para depósitos adicionales--->
        select 20 as orden, dc.DEid, '#LB_Liquido#' as tipo, 2 as ref, dc.DCvalor as valor
		from #pre#DeduccionesCalculo dc
		inner join DeduccionesEmpleado de
			on dc.Did = de.Did
		inner join TDeduccion td
			on de.TDid = td.TDid
        left outer join RHDAgrupadorRubro ar
        	on ar.RHDARvalor=td.TDid
            and ar.RHDARtabla = 'TDeduccion'
            and ar.RHDARcampo = 'TDid'
        left outer join RHAgrupadorRubro arg
        	on arg.RHARid = ar.RHARid
        where dc.RCNid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ListaNomina#" list="true">)
		<cfif len(trim(form.TDid))>
			and td.TDid not in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TDid#" list="true">)
		</cfif>
        and td.TDid in (select distinct b.TDid
                            from RHExportacionDeducciones a
                                inner join TDeduccion b
                                    on a.TDid = b.TDid
                                inner join <cf_dbdatabase table="EImportador" datasource="sifcontrol"> ei
                                    on a.EIid = ei.EIid
                                 inner join Empresas c
                                    on c.Ecodigo=b.Ecodigo
                            where a.Ecodigo  in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.JtreeListaItem#" list="true">)
                            and a.RHEDesliquido = 1 <!---deducciones correspondientes a salario liquido--->
                         )
        
        </cfif>
        union  all  <!--- consulta para Líquido--->
		select 20 as orden, se.DEid, '#LB_Liquido#' as tipo, 2 as ref, SEliquido as valor
		from #pre#SalarioEmpleado se
		where se.RCNid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ListaNomina#" list="true">)
	) x
	inner join DatosEmpleado de
		on x.DEid = de.DEid
	group by de.DEidentificacion,de.DEapellido1, de.DEapellido2, de.DEnombre, x.orden, x.tipo, x.ref, x.DEid
	order by de.DEidentificacion,x.orden, x.ref
</cfquery>

<cfquery dbtype="query" name="rsColumnas">
	select distinct orden, ref, tipo
	from rsReporte
	order by orden, ref
</cfquery>

<cfquery name="rsEncabezado" datasource="#session.dsn#">
		select e.Edescripcion,b.CPcodigo,b.CPperiodo, b.CPmes,b.CPdescripcion, a.RCDescripcion,tn.Tcodigo,tn.Tdescripcion,a.RCtc
		from #pre#RCalculoNomina a
		inner join CalendarioPagos b
			on a.RCNid = b.CPid
        inner join Empresas e 
                on b.Ecodigo = e.Ecodigo
        inner join TiposNomina tn 
                on b.Ecodigo = tn.Ecodigo
                and b.Tcodigo = tn.Tcodigo 
		where a.RCNid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ListaNomina#" list="true">)
</cfquery>

<cfset lvarPeriodo = "">
<cfif rsEncabezado.RecordCount EQ 1>
	<cfset lvarPeriodo = rsEncabezado.CPmes &" "& rsEncabezado.CPperiodo>
</cfif>

<cfset filtro1="">
<cfloop query="rsEncabezado">
    <cfif RCtc neq 1 >
        <cfset vTC = "(TC: #RCtc#)">
    <cfelse>
        <cfset vTC = "" >   
    </cfif>
    <cfif len(trim(filtro1))> 
		<cfset filtro1 &= '<br/>'> 
    </cfif>
    <cfset filtro1 &= '#Edescripcion# - #CPcodigo# - #Tcodigo# - #Tdescripcion# - #CPdescripcion# #vTC#'>
</cfloop>


<cfquery datasource="#session.dsn#" name="rsEncabezado">
	select min(cp.CPfpago) as mesMin, max(cp.CPfpago) as mesMax, max(rc.RCtc) as tipocambio
	from CalendarioPagos cp
	inner join #pre#RCalculoNomina rc
		on cp.CPid = rc.RCNid
	where rc.RCNid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ListaNomina#" list="true">)		
</cfquery>

<cfset StructCol = StructNew()>
<cfloop query="rsColumnas">
	<cfset StructCol["orden#orden#ref#ref#tipo"] = tipo>
	<cfset StructCol["orden#orden#ref#ref#total"] = 0>
</cfloop>

 
<cf_translatedata name="get" tabla="CuentaEmpresarial" col="CEnombre"  conexion="asp" returnvariable="LvarCEnombre">
<cfquery datasource="asp" name="rsCEmpresa">
	select #LvarCEnombre# as CEnombre 
	from CuentaEmpresarial 
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
</cfquery>

<cfset LB_IICA = rsCEmpresa.CEnombre>
<cfset LB_TipoDeCambio = t.translate('LB_TipoDeCambio','Tipo de cambio','/rh/generales.xml')/> 
<cfquery name="rsMeses" datasource="sifcontrol">
	select VSdesc, VSvalor 
	from VSidioma 
	where VSgrupo = 1 and Iid = (select Iid from Idiomas where Icodigo='#session.idioma#')
</cfquery> 

<cfset titulocentrado2 = ''>
<cfif rsEncabezado.recordcount and isdefined("rsEncabezado.mesMax") and len(trim(rsEncabezado.mesMax)) and isdefined("rsEncabezado.mesMin") and len(trim(rsEncabezado.mesMin)) >
	<cfif createDate(year(rsEncabezado.mesMax), month(rsEncabezado.mesMax), 1) neq createDate(year(rsEncabezado.mesMin), month(rsEncabezado.mesMin), 1) >
		<cfquery dbtype="query" name="rs1">select VSdesc from rsMeses where VSvalor = '#month(rsEncabezado.mesMin)#'</cfquery>
		<cfquery dbtype="query" name="rs2">select VSdesc from rsMeses where VSvalor = '#month(rsEncabezado.mesMax)#'</cfquery>
		<cfset LB_InformeParaElPeriodo = t.translate('LB_InformeParaElPeriodo','Informe para el periodo','/rh/generales.xml')/>
		<cfset titulocentrado2 = '#LB_InformeParaElPeriodo# #rs1.VSdesc# #year(rsEncabezado.mesMin)# - #rs2.VSdesc# #year(rsEncabezado.mesMax)#'>
	<cfelse>	
		<cfquery dbtype="query" name="rs1">select VSdesc from rsMeses where VSvalor = '#month(rsEncabezado.mesMax)#'</cfquery>
		<cfset LB_InformeAlMesDe = t.translate('LB_InformeAlMesDe','Informe al mes de','/rh/generales.xml')/>
		<cfset titulocentrado2 = '#LB_InformeAlMesDe# #rs1.VSdesc# #year(rsEncabezado.mesMax)#'>
	</cfif>	
</cfif>

<cfset vTituloStyle="font-size: 10pt; font-family: Verdana; font-weight: bold; text-align:left;">
<cfset vSubTituloStyle="font-size: 9pt; font-family: Verdana; font-weight: bold; text-align:left;">
 
 
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
<title>#LB_IICA#</title>
</head>
<body>

    <cf_HeadReport 
    addTitulo1='#LB_IICA#'
    filtro1="#filtro1#" 
    cols="17"
    showline="false">

	<cfoutput>	
            <table class="reporte">
                <thead style="display: table-header-group">
                    <tr>
                        <th>#LB_Codigo#</th>
                        <th>#LB_Empleado#</th>
                        <cfloop query="rsColumnas">
                            <th><cfoutput>#StructCol["orden#orden#ref#ref#tipo"]#</cfoutput></th>
						</cfloop>
                    </tr>
                </thead> 
                <tbody> 
                    <cfloop query="rsReporte" group="DEid">
                        <tr>
                            <td>#DEidentificacion#</td>
                            <td>#nombre#</td>
                            <cfset tupla = structNew()>
                            <cfloop query="rsColumnas">
                                <cfset tupla["orden#orden#ref#ref#total"] = 0>
                            </cfloop>
        
                            <cfloop> 
                                <cfset tupla["orden#orden#ref#ref#total"] = rsReporte.valor>
                                <cfset StructCol["orden#orden#ref#ref#total"] += rsReporte.valor>
                            </cfloop>
                             
                            <cfloop query="rsColumnas">
                                <td align="right">
                                    <cf_locale name="number" value="#tupla['orden#orden#ref#ref#total']#"/>
                                </td>	
                            </cfloop>
                        </tr>
                    </cfloop> 
                    <tr>
                        <td colspan="2" align="right"><b>#LB_Total#</b></td>
                        <cfloop query="rsColumnas">
                            <td align="right"><b><cf_locale name="number" value="#StructCol['orden#orden#ref#ref#total']#"/></b></td>
                        </cfloop>
                    </tr>
                </tbody>
            </table>
        </cfoutput>
	</body>
</html>
