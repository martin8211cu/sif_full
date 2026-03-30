,<!-------- LISTA DE EMPLEADOS A TOMAR EN CUENTA EN EL REPORTE------------------>
<cfset ListaEmpleados =-1>
<cfif isdefined("form.DEid") and len(trim(form.DEid)) gt 0>
	<cfset ListaEmpleados = listAppend(ListaEmpleados,form.DEid,",")>
</cfif>
<cfif isdefined("form.ListaDEidEmpleado")  and len(trim(form.ListaDEidEmpleado)) gt 0>
	<cfset ListaEmpleados = listAppend(ListaEmpleados,form.ListaDEidEmpleado,",")>
</cfif>

<cfif isDefined("form.chkHistorico")>
	<cfset historia = "H">
<cfelse>
	<cfset historia = "" >
</cfif>
<!---- LISTA DE NOMINAS A TOMAR EN CUENTA EN EL REPORTE-------------->
<cfif isdefined("form.chkCorporativo")>
	<!---- si el reporte es coorporativo.
		Debe utilizar todas las nominas entre las fechas indicadas sin importar la empresa
	---->
	<cfquery datasource="#session.dsn#" name="rsNominas">
		select RCNid
		from #historia#RCalculoNomina h
            inner join Empresa e
                on h.Ecodigo = e.Ereferencia
        where e.CEcodigo   = #session.CEcodigo#
		and RChasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.FechaDesde)#">
		and RCdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.FechaHasta)#">
	</cfquery>
	<cfset ListaNomina = valueList(rsNominas.RCNid,',')>
<cfelse>
	<cfif form.radio eq 1><!----- en el caso que se desee Filtrar por NOMINA ------>
		<cfset ListaNomina =-1>
		<cfset listaTcodigos =-1>

		<cfif isdefined("form.Tcodigo1") and len(trim(form.Tcodigo1)) gt 0>
			<cfset listaTcodigos = listAppend(listaTcodigos,form.Tcodigo1,",")>
		</cfif>
		<cfif isdefined("form.listaTipoNomina1") and len(trim(form.listaTipoNomina1)) gt 0 >
			<cfset listaTcodigos = listAppend(listaTcodigos,form.listaTipoNomina1,",")>
		</cfif>

		<cfquery datasource="#session.dsn#" name="rsNominas">
			select RCNid
			from #historia#RCalculoNomina
			where 1=1
			<cfif trim(listaTcodigos) neq -1>
			and Tcodigo in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#listaTcodigos#" list="yes">)
			</cfif>
			and RChasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.FechaDesde)#">
			and RCdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.FechaHasta)#">
			and Ecodigo = #session.Ecodigo#
		</cfquery>

		<cfif rsNominas.recordcount gt 0>
			<cfset ListaNomina = valueList(rsNominas.RCNid,',')>
		</cfif>

	<cfelseif form.radio eq 2><!----- en el caso que se desee Filtrar por Calendario ------>
		<cfset ListaNomina =-1>

		<cfif isdefined("form.CPid2") and len(trim(form.CPid2)) gt 0>
			<cfset ListaNomina = listAppend(ListaNomina,form.CPid2,",")>
		</cfif>
		<cfif isdefined("form.listaTcodigoCalendario2") and len(trim(form.listaTcodigoCalendario2)) gt 0 >
			<cfset ListaNomina = listAppend(ListaNomina,form.listaTcodigoCalendario2,",")>
		</cfif>
		<cfif isdefined("form.listaTcodigoCalendario21") and len(trim(form.listaTcodigoCalendario21)) gt 0 >
			<cfset ListaNomina = listAppend(ListaNomina,form.listaTcodigoCalendario21,",")>
		</cfif>

		<!--- OPARRALES 2019-02-26 Modificacion para reasignar fechas segun la nomina seleccionada --->
		<cfif ListLen(ListaNomina) gt 0>
			<cfset varFechaIni = "">
			<cfquery datasource="#session.dsn#" name="rsNomina">
				select
					Max(RChasta) RChasta,
					Min(RCdesde) RCdesde
				from #historia#RCalculoNomina h
		        inner join Empresa e
		        	on h.Ecodigo = e.Ereferencia
		        where
		        	e.CEcodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
		        and RCNid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ListaNomina#" list="true">)
			</cfquery>
			<cfset form.FechaDesde = rsNomina.RCdesde>
			<cfset form.FechaHasta = rsNomina.RChasta>
		</cfif>
	</cfif>
</cfif>

<cfif len(trim(ListaNomina)) eq 0 or (ListaNomina eq -1 and ListaEmpleados eq -1)>
	<cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=0&ErrMsg=No hay Registros que mostrar<br>&ErrDet=No existen Nominas en el filtro indicado" addtoken="no">
	<cfthrow message="">
	<cfabort>
</cfif>

<!----  ****************************************************** PROCESO DE GENERACION DE REPORTE **************************************** ----->
<cfinvoke component="rh.admin.catalogos.RepDinamicos" method="ReporteDinamico" returnvariable="ReporteHTML">
	<cfinvokeargument name="ListaNomina" 	value="#ListaNomina#">
	<cfinvokeargument name="ListaEmpleados" value="#ListaEmpleados#">
	<cfinvokeargument name="RHRDEid" 		value="#RHRDEid#">
	<cfif isdefined("form.chkCorporativo")>
		<cfinvokeargument name="corporativo" 	value="1">
	</cfif>
	<cfif isDefined("form.chkHistorico")>
		<cfinvokeargument name="historico"		value="1">
	</cfif>
	<cfif isdefined("form.GroupBy") and len(trim(form.GroupBy)) gt 0>
		<cfinvokeargument name="ListaAgrupado" 	value="#form.GroupBy#">
	</cfif>
	<cfinvokeargument name="fechaDesde" 	value="#LSParseDateTime(form.FechaDesde)#">
	<cfinvokeargument name="fechaHasta" 	value="#LSParseDateTime(form.FechaHasta)#">
	<cfif form.radio eq 1 and len(trim(form.CPtipo))>
		<cfinvokeargument name="CPtipo" 	value="#form.CPtipo#">
	</cfif>
	<cfinvokeargument name="MostrarConteo" value="#IsDefined('form.ChkMostrarConteo')#">
</cfinvoke>

<!------------ ************************************** PINTAR REPORTE  *******************************--------------->

<cf_htmlReportsHeaders title="Reporte de Nominas" filename="ReporteDinamic.xls" irA="ConsultaRepDinamicos.cfm" download="false">
<!--- OPARRALES 2019-02-26
	- Se agrega encabezado a la exportacion del reporte
	- Se calcula colspan basado en columnas a pintar + columnas a agrupar
 --->
<cfquery datasource="#session.dsn#" name="rsReporte">
	select RHRDEcodigo,RHRDEdescripcion
	from RHReportesDinamicoE
	where RHRDEid = #form.RHRDEid#
</cfquery>

<cfquery name="rsNumCols" datasource="#session.dsn#">
	select Cdescripcion,CCTEcampo
	from RHReportesDinamicoC a
	left join RHReportesDinamicoCCTE b
		on a.Cid = b.Cid
	where RHRDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRDEid#">
</cfquery>
<cfset varAgrupados = rsNumCols.RecordCount>

<cfif IsDefined('form.GROUPBY')>
	<cfset varAgrupados += ListLen(form.GROUPBY)>
</cfif>

<cfsavecontent variable="header">
	<cf_EncReporte Titulo="#rsReporte.RHRDEdescripcion#" Color="##E3EDEF"
		filtro1="Desde #LSDateFormat(form.FechaDesde,'dd-mm-yyyy')#  Hasta #LSDateFormat(form.FechaHasta,'dd-mm-yyyy')#" cols="#varAgrupados#">
</cfsavecontent>

<style>
	h1.corte {PAGE-BREAK-AFTER: always;}
	.listaCorte {
		font-size:10px;
		font-weight:bold;
		background-color: #F4F4F4;
		text-align:left;}
	.listaCorte3 {
		font-size:10px;
		font-weight:bold;
		background-color:  #E8E8E8;
		text-align:left;}
	.total {
		font-size:11px;
		font-weight:bold;
		background-color:#C5C5C5;
		text-align:right;}
	.detalle {
		font-size:10px;
		text-align:left;}
	.detaller {
		font-size:10px;
		text-align:right;}
	.paginacion {
		font-size:14px;
		text-align:center;}
	.detaller>td{padding: 0 1em 0 1em;}
</style>

<!--- <cf_dump var="#ReporteHTML#"> --->

<cfif isdefined("ExportarExcel")>
	<cfset archivo = "ReporteDinamico_#hour(now())##minute(now())##second(now())#">
	<cfset txtfile = GetTempFile(getTempDirectory(), 'ReporteDinamico')>
	<cffile action="write" nameconflict="overwrite" file="#txtfile#" output="#header##ReporteHTML#" charset="windows-1252">
	<cfheader name="Content-Disposition" value="attachment;filename=#archivo#.xls">
	<cfcontent file="#txtfile#" type="application/vnd.ms-excel" deletefile="yes">
<cfelseif isDefined("ExportarPDF")>

	<!--- obtiene cantidad de columnas que contiene el reporte --->
	<cfset occurrences = ( Len(ReporteHTML) - Len(Replace(ReporteHTML,'<td align="center"','','all'))) / Len('<td align="center"') >
	<cfset txtfile = getTempDirectory()>
	<cfif occurrences GT 6 >
		<cfdocument overwrite="true" filename="reporteDinamico.pdf" format="PDF" orientation="landscape" pagetype="custom" pageheight="30" pagewidth="16">
			<cfoutput>#header# #ReporteHTML#</cfoutput>
		</cfdocument>
	<cfelse>
		<cfdocument overwrite="true" filename="reporteDinamico.pdf" format="PDF" orientation="landscape">
			<cfoutput>#header# #ReporteHTML#</cfoutput>
		</cfdocument>
	</cfif>
	<div>
		<object data="reporteDinamico.pdf" type="application/pdf" style="width:100%;">
		</object>
	</div>
	<cf_importlibs/>
	<script type="text/javascript">
		$("object").css("height",(screen.height-150) );
	</script>
<cfelse>
	<cfflush interval="512">
	<cfsetting requesttimeout="36000">
	<cfoutput>#header# #ReporteHTML#</cfoutput>
</cfif>



