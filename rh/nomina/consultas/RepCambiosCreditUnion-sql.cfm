

<cfif isDefined("form.listaTDid") and len(trim(form.listaTDid))>
	<cfset form.TDid = listAppend(form.TDid , form.listaTDid)>
</cfif>

<cfset t = createObject("component","sif.Componentes.Translate")>

<cfset LB_ReporteCambiosEnCreditUnion = t.translate('LB_ReporteCambiosEnCreditUnion','Reporte Cambios en Credit Union')>
<cfset LB_DeduccionParaElMesDe = t.translate('LB_DeduccionParaElMesDe','Deducción para el mes de')>
<cfset LB_TotalDeducidoAl = t.translate('LB_TotalDeducidoAl','Total deducido al')>
<cfset LB_Nombre = t.translate('LB_Nombre','Nombre','/rh/generales.xml')>
<cfset LB_MontoAnterior = t.translate('LB_MontoAnterior','Monto Anterior')>
<cfset LB_MontoActual = t.translate('LB_MontoActual','Monto Actual')>
<cfset LB_MENOS = t.translate('LB_MENOS','MENOS')>
<cfset LB_Subtotal = t.translate('LB_Subtotal','Subtotal','/rh/generales.xml')>
<cfset LB_TotalAl = t.translate('LB_TotalAl','Total al')>

<cfset LvarFileName = "Lst_ChangesCreditUnion_#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">
 
<!----- se realiza el cambio de mes----->
<cfset lvarMes = form.CPmes>
<cfset lvarPeriodo = form.CPperiodo>
<cfif lvarMes eq 1>
	<cfset lvarMesAnt = 12>
	<cfset lvarPeriodoAnt = lvarPeriodo-1>
<cfelse>
	<cfset lvarMesAnt = lvarMes-1>
	<cfset lvarPeriodoAnt = lvarPeriodo>
</cfif>

<!--- Histórica ó en Proceso--->
<cfquery datasource="#session.dsn#" name="rsCP">
	select count(1) as Actual
    from CalendarioPagos cp 
    inner join RCalculoNomina rcn
    on rcn.RCNid = cp.CPid
    where cp.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#lvarPeriodo#">
    and cp.CPmes= <cfqueryparam cfsqltype="cf_sql_integer" value="#lvarMes#">
</cfquery>
<cfset pre = ''>
<cfif rsCP.Actual EQ 0>
	<cfset pre = 'H'>
</cfif>

<cfif form.formato eq 'html'>
	<cf_htmlReportsHeaders title="#LB_ReporteCambiosEnCreditUnion#" filename="#LvarFileName#" irA="RepCambiosCreditUnion.cfm">	
	<cfoutput>#getHTML()#</cfoutput>
<cfelseif form.formato eq 'excel'>
	<cfset form.btnDownload=1>
	<cf_htmlReportsHeaders title="#LB_ReporteCambiosEnCreditUnion#" filename="#LvarFileName#" irA="RepCambiosCreditUnion.cfm">
	<cfoutput>#getHTML()#</cfoutput>
<cfelseif form.formato eq 'pdf'>	
	<cfdocument format="PDF">  
	<cfoutput>#getHTML()#</cfoutput>
	</cfdocument>
</cfif>
 

<cffunction name="getHTML" output="true">
	<cfset LvarHTTP = 'http://'>
	<cfif isdefined("session.sitio.ssl_todo") and session.sitio.ssl_todo> <cfset LvarHTTP = 'https://'> </cfif>
	<link href="<cfoutput>#LvarHTTP##cgi.server_name#<cfif len(trim(cgi.SERVER_PORT))>:#cgi.SERVER_PORT#</cfif></cfoutput>/cfmx/plantillas/IICA/css/reports.css" rel="stylesheet" type="text/css">
	<cf_templatecss/>
	<style type="text/css">
		.tituloDivisor{
		padding-top: 2em !important;
		padding-bottom: 1em !important;
		border-color: ##000 !important;
		border-left: 0 !important;
		border-right: 0 !important;
		}	
		.reporte .subtotal{
			border-top: black;
			border-style: solid;
			border-top-width: 2px;
		} 
		.reporte{width: 100%;}
	</style>	
	<cf_dbfunction name="op_concat" returnvariable="concat">
	<cf_translatedata name="get" tabla="TDeduccion" col="td.TDdescripcion" returnvariable="LvarTDdescripcion">
		
	<!---<cfquery datasource="#session.dsn#" name="rsReporte">
		select * from 
        (select ded.TDid, hd.DEid, de.DEidentificacion, de.DEapellido1#concat#' '#concat#de.DEapellido2#concat#' '#concat#de.DEnombre as nombre, td.TDcodigo#concat#' - '#concat##LvarTDdescripcion# as deduccion, 
			sum(hd.DCvalor) as DCvalor,
			sum(ded.Dvalor) as Dvalor,
			max(rhc.RCtc) as tipocambio,
			(
			select coalesce(sum(hd1.DCvalor),0)
			from CalendarioPagos cp1
				inner join HDeduccionesCalculo hd1
					on cp1.CPid = hd1.RCNid	
				inner join DeduccionesEmpleado ded1
					on hd1.Did = ded1.Did 
			where cp1.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#lvarMesAnt#">
				  and  cp1.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#lvarPeriodoAnt#">
				  and ded1.TDid = ded.TDid
				  and hd1.DEid = hd.DEid
		  ) as DCvalorAnt,
			(
			select coalesce(sum(ded1.Dvalor),0)
			from CalendarioPagos cp1
				inner join HDeduccionesCalculo hd1
					on cp1.CPid = hd1.RCNid	
				inner join DeduccionesEmpleado ded1
					on hd1.Did = ded1.Did 
			where cp1.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#lvarMesAnt#">
				  and  cp1.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#lvarPeriodoAnt#">
				  and ded1.TDid = ded.TDid
				  and hd1.DEid = hd.DEid
		  ) as DvalorAnt,
			<!----- estos dos siguiente queries realizan el total de las deducciones del empleado para el mes consulado y el anterior---->
			(
			select coalesce(sum(hd1.DCvalor),0)
			from CalendarioPagos cp1
				inner join HDeduccionesCalculo hd1
					on cp1.CPid = hd1.RCNid	
				inner join DeduccionesEmpleado ded1
					on hd1.Did = ded1.Did 
			where cp1.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#lvarMes#">
				  and  cp1.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#lvarPeriodo#">
				  and ded1.TDid = ded.TDid
		  ) as DCvalorTotal,
			(
			select coalesce(sum(hd1.DCvalor),0)
			from CalendarioPagos cp1
				inner join HDeduccionesCalculo hd1
					on cp1.CPid = hd1.RCNid	
				inner join DeduccionesEmpleado ded1
					on hd1.Did = ded1.Did 
			where cp1.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#lvarMesAnt#">
				  and  cp1.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#lvarPeriodoAnt#">
				  and ded1.TDid = ded.TDid
		  ) as DCvalorTotalAnt

		from CalendarioPagos cp
			inner join HRCalculoNomina rhc
				on cp.CPid=rhc.RCNid
			inner join HDeduccionesCalculo hd
				on cp.CPid = hd.RCNid	
			inner join DeduccionesEmpleado ded
				on hd.Did = ded.Did
			inner join TDeduccion td
				on ded.TDid = td.TDid	
			inner join DatosEmpleado de
				on hd.DEid = de.DEid	
		where cp.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CPmes#">
			  and  cp.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CPperiodo#">
			  <cfif len(trim(form.TDid))>
			  	and ded.TDid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TDid#" list="true">)
			  </cfif> 	
		group by  ded.TDid,td.TDcodigo, #LvarTDdescripcion#, hd.DEid, de.DEidentificacion, de.DEapellido1,de.DEapellido2,de.DEnombre
		<cfif isdefined("request.usetranslatedata") and session.idioma eq 'en'>
			,td.TDdescripcion_#session.idioma#
		</cfif>	
       
        UNION ALL
        
        select ded.TDid, hd.DEid, de.DEidentificacion, de.DEapellido1#concat#' '#concat#de.DEapellido2#concat#' '#concat#de.DEnombre as nombre, td.TDcodigo#concat#' - '#concat##LvarTDdescripcion# as deduccion, 
			sum(hd.DCvalor) as DCvalor,
			sum(ded.Dvalor) as Dvalor,
			max(rhc.RCtc) as tipocambio,
			(
			select coalesce(sum(hd1.DCvalor),0)
			from CalendarioPagos cp1
				inner join HDeduccionesCalculo hd1
					on cp1.CPid = hd1.RCNid	
				inner join DeduccionesEmpleado ded1
					on hd1.Did = ded1.Did 
			where cp1.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#lvarMesAnt#">
				  and  cp1.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#lvarPeriodoAnt#">
				  and ded1.TDid = ded.TDid
				  and hd1.DEid = hd.DEid
		  ) as DCvalorAnt,
			(
			select coalesce(sum(ded1.Dvalor),0)
			from CalendarioPagos cp1
				inner join HDeduccionesCalculo hd1
					on cp1.CPid = hd1.RCNid	
				inner join DeduccionesEmpleado ded1
					on hd1.Did = ded1.Did 
			where cp1.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#lvarMesAnt#">
				  and  cp1.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#lvarPeriodoAnt#">
				  and ded1.TDid = ded.TDid
				  and hd1.DEid = hd.DEid
		  ) as DvalorAnt,
			<!----- estos dos siguiente queries realizan el total de las deducciones del empleado para el mes consulado y el anterior---->
			(
			select coalesce(sum(hd1.DCvalor),0)
			from CalendarioPagos cp1
				inner join DeduccionesCalculo hd1
					on cp1.CPid = hd1.RCNid	
				inner join DeduccionesEmpleado ded1
					on hd1.Did = ded1.Did 
			where cp1.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#lvarMes#">
				  and  cp1.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#lvarPeriodo#">
				  and ded1.TDid = ded.TDid
		  ) as DCvalorTotal,
			(
			select coalesce(sum(hd1.DCvalor),0)
			from CalendarioPagos cp1
				inner join HDeduccionesCalculo hd1
					on cp1.CPid = hd1.RCNid	
				inner join DeduccionesEmpleado ded1
					on hd1.Did = ded1.Did 
			where cp1.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#lvarMesAnt#">
				  and  cp1.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#lvarPeriodoAnt#">
				  and ded1.TDid = ded.TDid
		  ) as DCvalorTotalAnt
		from CalendarioPagos cp
			inner join RCalculoNomina rhc
				on cp.CPid=rhc.RCNid
			inner join DeduccionesCalculo hd
				on cp.CPid = hd.RCNid	
			inner join DeduccionesEmpleado ded
				on hd.Did = ded.Did
			inner join TDeduccion td
				on ded.TDid = td.TDid	
			inner join DatosEmpleado de
				on hd.DEid = de.DEid	
		where cp.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CPmes#">
			  and  cp.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CPperiodo#">
			  <cfif len(trim(form.TDid))>
			  	and ded.TDid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TDid#" list="true">)
			  </cfif> 	
		group by  ded.TDid,td.TDcodigo, #LvarTDdescripcion#, hd.DEid, de.DEidentificacion, de.DEapellido1,de.DEapellido2,de.DEnombre
		<cfif isdefined("request.usetranslatedata") and session.idioma eq 'en'>
			,td.TDdescripcion_#session.idioma#
		</cfif>) x
      <!--- order by  ded.TDid,td.TDcodigo, #LvarTDdescripcion#, hd.DEid, de.DEidentificacion, de.DEapellido1,de.DEapellido2,de.DEnombre	--->
       order by  x.TDid, x.deduccion, x.DEid, x.DEidentificacion, x.nombre	
	</cfquery> --->
    
    
    <cfquery datasource="#session.dsn#" name="rsReporte">
		select x.TDid, x.DEid, x.DEidentificacion, x.nombre, x.deduccion, 
                sum(x.Dvalor)as Dvalor,
                sum(x.tipocambio)as tipocambio,
                sum(x.DCvalor) as DCvalor,
                sum(x.DCvalorAnt) as DCvalorAnt,
                sum(x.DvalorAnt) as DvalorAnt,
                max(x.DCvalorTotal) as DCvalorTotal,
                max(x.DCvalorTotalAnt) as  DCvalorTotalAnt
        from (
        	
			<!---Nómina Histórica Anterior--->
            select ded.TDid, hd.DEid, de.DEidentificacion, de.DEapellido1#concat#' '#concat#de.DEapellido2#concat#' '#concat#de.DEnombre as nombre, td.TDcodigo#concat#' - '#concat##LvarTDdescripcion# as deduccion, 
                0 as DCvalor,
                0 as Dvalor,
                0 as tipocambio,
                sum(hd.DCvalor) as DCvalorAnt,
                sum(ded.Dvalor) as DvalorAnt,
                (
                    select coalesce(sum(hd1.DCvalor),0)
                    from CalendarioPagos cp1
                        inner join HDeduccionesCalculo hd1
                            on cp1.CPid = hd1.RCNid	
                        inner join DeduccionesEmpleado ded1
                            on hd1.Did = ded1.Did 
                    where cp1.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#lvarMes#">
                          and  cp1.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#lvarPeriodo#">
                          and ded1.TDid = ded.TDid
                  ) as DCvalorTotal,
                (
                    select coalesce(sum(hd1.DCvalor),0)
                    from CalendarioPagos cp1
                    inner join HDeduccionesCalculo hd1
                        on cp1.CPid = hd1.RCNid	
                    inner join DeduccionesEmpleado ded1
                        on hd1.Did = ded1.Did 
                    where cp1.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#lvarMesAnt#">
                          and  cp1.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#lvarPeriodoAnt#">
                          and ded1.TDid = ded.TDid
                ) as DCvalorTotalAnt
    
            from CalendarioPagos cp
                inner join HRCalculoNomina rhc
                    on cp.CPid=rhc.RCNid
                inner join HDeduccionesCalculo hd
                    on cp.CPid = hd.RCNid	
                inner join DeduccionesEmpleado ded
                    on hd.Did = ded.Did
                    and  hd.DEid = ded.DEid
                inner join TDeduccion td
                    on ded.TDid = td.TDid	
                inner join DatosEmpleado de
                    on hd.DEid = de.DEid
                
            where cp.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#lvarMesAnt#">
                  and  cp.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#lvarPeriodoAnt#">
                <cfif len(trim(form.TDid))>
                    and td.TDid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TDid#" list="true">)
                </cfif>  
             group by  ded.TDid,td.TDcodigo, #LvarTDdescripcion#, hd.DEid, de.DEidentificacion, de.DEapellido1,de.DEapellido2,de.DEnombre
            <cfif isdefined("request.usetranslatedata") and session.idioma eq 'en'>
                ,td.TDdescripcion_#session.idioma#
            </cfif>	
        	
            UNION ALL
            <!---Nómina Histórica ó en Proceso Actual--->
            select ded.TDid, hd.DEid, de.DEidentificacion, de.DEapellido1#concat#' '#concat#de.DEapellido2#concat#' '#concat#de.DEnombre as nombre, td.TDcodigo#concat#' - '#concat##LvarTDdescripcion# as deduccion, 
                sum(hd.DCvalor) as DCvalor,
                sum(ded.Dvalor) as Dvalor,
                max(rhc.RCtc) as tipocambio,
                0 as DCvalorAnt,
                0 as DvalorAnt,
                (
                    select coalesce(sum(hd1.DCvalor),0)
                    from CalendarioPagos cp1
                    inner join #pre#DeduccionesCalculo hd1
                        on cp1.CPid = hd1.RCNid	
                    inner join DeduccionesEmpleado ded1
                        on hd1.Did = ded1.Did 
                    where cp1.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#lvarMes#">
                          and  cp1.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#lvarPeriodo#">
                          and ded1.TDid = ded.TDid
                ) as DCvalorTotal,
                0 as DCvalorTotalAnt
    
            from CalendarioPagos cp
                inner join #pre#RCalculoNomina rhc
                    on cp.CPid=rhc.RCNid
                inner join #pre#DeduccionesCalculo hd
                    on cp.CPid = hd.RCNid	
                inner join DeduccionesEmpleado ded
                    on hd.Did = ded.Did
                    and hd.DEid = ded.DEid
                inner join TDeduccion td
                    on ded.TDid = td.TDid	
                inner join DatosEmpleado de
                    on hd.DEid = de.DEid	
            where cp.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CPmes#">
                  and  cp.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CPperiodo#">
                  <cfif len(trim(form.TDid))>
                    and td.TDid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TDid#" list="true">)
                  </cfif> 	
            group by  ded.TDid,td.TDcodigo, #LvarTDdescripcion#, hd.DEid, de.DEidentificacion, de.DEapellido1,de.DEapellido2,de.DEnombre
            <cfif isdefined("request.usetranslatedata") and session.idioma eq 'en'>
                ,td.TDdescripcion_#session.idioma#
            </cfif>	
       ) x
       group by  x.TDid, x.nombre, x.DEidentificacion, x.DEid, x.deduccion 
       order by  x.TDid, x.nombre, x.DEidentificacion, x.DEid, x.deduccion	
	</cfquery> 
    
<cf_translatedata name="get" tabla="CuentaEmpresarial" col="CEnombre"  conexion="asp" returnvariable="LvarCEnombre">
<cfquery datasource="asp" name="rsCEmpresa">
	select #LvarCEnombre# as CEnombre from CuentaEmpresarial where CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
</cfquery>
<cfset LB_IICA=rsCEmpresa.CEnombre>
<cfset LB_TipoDeCambio= t.translate('LB_TipoDeCambio','Tipo de cambio','/rh/generales.xml')/> 
<cfquery name="rsMeses" datasource="sifcontrol">
	select VSdesc,VSvalor from VSidioma where VSgrupo=1 and Iid=(select Iid from Idiomas where Icodigo='#session.idioma#')
</cfquery> 
<cfset titulocentrado2=''>
<cfquery dbtype="query" name="rs1">select VSdesc from rsMeses where VSvalor = '#form.CPmes#'</cfquery>
<cfset LB_InformeAlMesDe= t.translate('LB_InformeAlMesDe','Informe al mes de','/rh/generales.xml')/>
<cfset titulocentrado2='#LB_InformeAlMesDe# #rs1.VSdesc# #form.CPperiodo#'>

<cfset LvarHTTP = 'http://'>
<cfif isdefined("session.sitio.ssl_todo") and session.sitio.ssl_todo> <cfset LvarHTTP = 'https://'> </cfif>
<link href="<cfoutput>#LvarHTTP##cgi.server_name#<cfif len(trim(cgi.SERVER_PORT))>:#cgi.SERVER_PORT#</cfif></cfoutput>/cfmx/plantillas/IICA/css/reports.css" rel="stylesheet" type="text/css">

<cf_HeadReport
	addTitulo1='#LB_IICA#'
	filtro1='#titulocentrado2#'
	filtro2="#LB_TipoDeCambio#: #rsReporte.tipocambio#"
    showEmpresa="true" 
    showline="false"> 

 	<!----- se obtiene el nombre del mes según la traduccion--->
 	<cfquery datasource="#session.dsn#" name="rsMeses">
		select  vs.VSdesc
			from VSidioma vs
			    inner join Idiomas i
			        on vs.Iid = i.Iid
			where vs.VSgrupo=1
			and i.Icodigo = '#session.idioma#'
			and vs.VSvalor = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CPmes#">
	</cfquery>
   	<table class="reporte">
      <tbody>
      		<cfoutput>
	      	<!---<tr>
	      		<td colspan="4" align="center"><h2>#session.CEnombre#</h2></td>
	      	</tr>--->
			<tr>
	      		<td colspan="4" align="center"><h3>#LB_DeduccionParaElMesDe#: #rsMeses.VSdesc#</h3></td>
	      	</tr>
	      	</cfoutput>

      	<cfoutput query="rsReporte" group="TDid">
      		<cfquery dbtype="query" name="rsTotales">
      			select DCvalorTotal, DCvalorTotalAnt
      			from rsReporte
      			where TDid = #rsReporte.TDid#
      		</cfquery>
	      	<tr>
	      		<td colspan="4" <!---style="border-top: black;border-style: solid"--->><b>#deduccion#</b></td>
	      	</tr>
	      	<tr>
	      		<td colspan="3">#LB_TotalDeducidoAl#  #dateformat(dateadd("d",-1,dateAdd("m",1,createdate(lvarPeriodoAnt,lvarMesAnt,1))),'dd/mm')# </td>
	      		<td align="right"><cf_locale name="NUMBER" value="#rsTotales.DCvalorTotalAnt#"/></td>
	      	</tr>
	      	<!---- detalle de la deduccion por empleado---->
	      	<cfset LvarContentMas=''>
	      	<cfset LvarContentMenos=''>
	      	<cfset TotalMas=0>
	      	<cfset TotalMasAnt=0>
	      	<cfset TotalMenos=0>
	      	<cfset TotalMenosAnt=0>
	      	<cfoutput>
	      	<!-------------- montos que aumentaron----->
	      	<cfsavecontent variable="LvarTemp">
		      	<tr>
		      		<td>#DEidentificacion# - #nombre#</td>
		      		<td align="right"><cf_locale name="NUMBER" value="#DCvalorAnt#"/></td>
		      		<td align="right"><cf_locale name="NUMBER" value="#DCvalor#"/></td>
		      	</tr>
	      	</cfsavecontent>
	      		
	      	<cfif DCvalorAnt lt DCvalor>
	      		<cfset LvarContentMas&=LvarTemp>
	      		<cfset TotalMas+=DCvalor>
	      		<cfset TotalMasAnt+=DCvalorAnt>
	      	</cfif>
	      	<cfif DCvalorAnt gt DCvalor>
	      		<cfset LvarContentMenos&=LvarTemp>
	      		<cfset TotalMenos+=DCvalor>
	      		<cfset TotalMenosAnt+=DCvalorAnt>
	      	</cfif>
			
	      	<!------- montos que disminuyeron----->
	      	</cfoutput>
	      	<!----- fin del detalle por empleado----->
	      	<cfif len(trim(LvarContentMas))>
		      	<tr>
		      		<td>#LB_Nombre#</td>
		      		<td align="right">#LB_MontoAnterior#</td>
		      		<td align="right">#LB_MontoActual#</td>
		      	</tr>
		      	#LvarContentMas#
		      	<tr>
		      		<td></td>
		      		<td class="subtotal" align="right"><cf_locale name="NUMBER" value="#TotalMasAnt#"/></td>
		      		<td class="subtotal" align="right"><cf_locale name="NUMBER" value="#TotalMas#"/></td>
		      	</tr>
		      	<tr>
		      		<td colspan="3">#LB_Subtotal#</td>
		      		<td align="right"><cf_locale name="NUMBER" value="#TotalMas-TotalMasAnt#"/></td>
		      	</tr>
		    </cfif>  	
			<cfif len(trim(LvarContentMenos))>	
		      	<tr>
		      		<td colspan="4">#LB_MENOS#</td>
		      	</tr>
		      	<tr>
		      		<td>#LB_Nombre#</td>
		      		<td align="right">#LB_MontoAnterior#</td>
		      		<td align="right">#LB_MontoActual#</td>
		      	</tr>
		      	#LvarContentMenos#
		      	<tr>
		      		<td></td>
		      		<td class="subtotal" align="right"><cf_locale name="NUMBER" value="#TotalMenosAnt#"/></td>
		      		<td class="subtotal" align="right"><cf_locale name="NUMBER" value="#TotalMenos#"/></td>
		      	</tr>
		      	<tr>
		      		<td colspan="3">#LB_Subtotal#</td>
		      		<td align="right"><cf_locale name="NUMBER" value="#TotalMenos-TotalMenosAnt#"/></td>
		      	</tr>
			</cfif>
	      	<!----- total final----->
	      	<tr>
	      		<td colspan="3">#LB_TotalAl#  #dateformat(dateadd("d",-1,dateAdd("m",1,createdate(lvarPeriodo,lvarMes,1))),'dd/mm')# </td>
	      		<td align="right"><cf_locale name="NUMBER" value="#rsTotales.DCvalorTotal#"/></td>
	      	</tr>

      	</cfoutput>
      </tbody>
    </table>
	
</cffunction>