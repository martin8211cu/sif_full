
<cfset t = createObject("component", "sif.Componentes.Translate")>
<!--- Etiquetas de traducción --->
<cfset LB_ReporteDetalleIngresosPorEmpleado = t.translate('LB_ReporteDetalleIngresosPorEmpleado','Reporte Detalle de Ingresos Por Empleado')>
<cfset LB_Usuario = t.translate('LB_Usuario','Usuario','../rh/generales.xml')>
<cfset LB_Fecha = t.translate('LB_Fecha','Fecha','../rh/generales.xml')>
<cfset LB_DetalleIngresosEmpleado = t.translate('LB_DetalleIngresosEmpleado','Detalle de Ingresos por Empleado','../rh/generales.xml')>
<!----<cfset LB_Empleado = t.translate('LB_Empleado','Empleado','../rh/generales.xml')>----->
<cfset LB_Periodo = t.translate('LB_Periodo','Periodo','../rh/generales.xml')>
<cfset LB_SalarioBasico = t.translate('LB_SalarioBasico','Salario Básico','../rh/generales.xml')>
<cfset LB_Subsidio = t.translate('LB_Subsidio','Subsidio','../rh/generales.xml')>
<cfset LB_Total = t.translate('LB_Total','Total','../rh/generales.xml')>
<cfset LB_subTotal = t.translate('LB_subTotal','Sub-Total','../rh/generales.xml')>
<cfset LB_GranTotal = t.translate('LB_GranTotal','Gran Total','../rh/generales.xml')>
<cfset LB_InformeParaElPeriodo = t.translate('LB_InformeParaElPeriodo','Informe para el periodo','../rh/generales.xml')/>
<cfset LB_InformeAlMesDe = t.translate('LB_InformeAlMesDe','Informe al mes de','../rh/generales.xml')/>
<cfset LB_NoExistenRegistrosQueMostrar = t.Translate('LB_NoExistenRegistrosQueMostrar','No existen registros que mostrar','../rh/generales.xml')>


<cf_translatedata name="get" tabla="CIncidentes" col="ci.CIdescripcion" returnvariable="LvarCIdescripcion">


<cfinvoke Key="LB_Empleado" Default="Empleado" XmlFile="/rh/generales.xml" returnvariable="LB_Empleado" component="sif.Componentes.Translate" method="Translate"/>	





<cfset LvarBack = "ReporteDetalleIngresosPorEmpleado.cfm">
<cfset archivo = "ReporteDetalleIngresosPorEmpleado(#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#).xls">

<cf_htmlReportsHeaders irA="#LvarBack#" FileName="#archivo#">

<cfset LvarHTTP = 'http://'>
<cfif isdefined("session.sitio.ssl_todo") and session.sitio.ssl_todo> <cfset LvarHTTP = 'https://'> </cfif>
<link href="<cfoutput>#LvarHTTP##cgi.server_name#<cfif len(trim(cgi.SERVER_PORT))>:#cgi.SERVER_PORT#</cfif></cfoutput>/cfmx/plantillas/IICA/css/reports.css" rel="stylesheet" type="text/css">

<cfif isdefined('form.sMesDesde') and isdefined('form.sAnoDesde')>
	<cfset fechDesde = '#form.sMesDesde#/01/#form.sAnoDesde#' >
</cfif>

<cfif isdefined('form.sMesHasta') and isdefined('form.sAnoHasta')>
	<cfset fechTemp = Createdate( form.sAnoHasta, form.sMesHasta, 1 ) >
	<cfset fechTemp = ( DateAdd( "m", 1, fechTemp ) - 1 ) >
	<cfset lastDayOfMonth = DateFormat( fechTemp, "dd" ) >
	<cfset fechHasta = '#form.sMesHasta#/#lastDayOfMonth#/#form.sAnoHasta#' > 
</cfif>

<cf_translatedata name="get" tabla="CuentaEmpresarial" col="CEnombre"  conexion="asp" returnvariable="LvarCEnombre">
<cfquery datasource="asp" name="rsCEmpresa">
	select #LvarCEnombre# as CEnombre 
	from CuentaEmpresarial 
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
</cfquery>

<cfset LB_Corp = rsCEmpresa.CEnombre>
<cfset titulocentrado2 = ''>
<cfset lvarCols = 4>

<cfquery name="rsMeses" datasource="sifcontrol">
	select VSdesc, VSvalor 
	from VSidioma 
	where VSgrupo = 1 and Iid = (select Iid from Idiomas where Icodigo = '#session.idioma#')
</cfquery> 

<cfset rsIngresosEmp = getQuery() >  <!--- Detalle de Ingresos por Empleado --->

<cfif rsIngresosEmp.recordcount>
	<cfif isdefined('form.sMesDesde') and isdefined('form.sAnoDesde') and isdefined('form.sMesHasta') and isdefined('form.sAnoHasta')>
		<cfquery dbtype="query" name="rs1">
			select VSdesc 
			from rsMeses 
			where VSvalor = '#form.sMesDesde#'		
		</cfquery>
		
		<cfif form.sMesDesde neq form.sMesHasta >
			<cfquery dbtype="query" name="rs2">
				select VSdesc 
				from rsMeses 
				where VSvalor = '#form.sMesHasta#'
			</cfquery>

			<cfset titulocentrado2 = '#LB_InformeParaElPeriodo# #rs1.VSdesc# #form.sAnoDesde# - #rs2.VSdesc# #form.sAnoHasta#'>
		<cfelse>
			<cfif form.sAnoDesde neq form.sAnoHasta >
				<cfset titulocentrado2 = '#LB_InformeParaElPeriodo# #rs1.VSdesc# #form.sAnoDesde# - #rs1.VSdesc# #form.sAnoHasta#'>
			<cfelse>
				<cfset titulocentrado2 = '#LB_InformeAlMesDe# #rs1.VSdesc# #form.sAnoDesde#'>
			</cfif>	
		</cfif>
	</cfif>

	<cfswitch expression="#Form.sFormato#">
		<cfcase value="html">
<!---			<cf_EncReporte titulocentrado1='#LB_Corp#' titulocentrado2='#titulocentrado2#' cols="#lvarCols#">--->
			
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
                table { page-break-inside:auto;}
                tr { page-break-inside:avoid; page-break-after:auto }			
            </style>
            <meta http-equiv="Content-Type" content="text/html; charset=windows-1252" />
            <title>#LB_Corp#</title>
            </head>
            <body>
            
                <cf_HeadReport 
                addTitulo1='#LB_Corp#' 
                filtro1='#titulocentrado2#' 
                showEmpresa="true" 
                cols="#lvarCols#"
                showline="false">
                    <cfoutput>#getHTML(rsIngresosEmp)#</cfoutput>	
			</body>
			</html>
        
        </cfcase>
		<cfcase value="pdf">
			<cfdocument format="#Form.sFormato#">
				<!--- Se define el encabezado de pagina --->
				<cfdocumentitem type="header">
					<cfoutput>
						<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0" bgcolor="##E3EDEF">
							<tr>
								<td width="20%" align="left" valign="top">&nbsp;</td>
								<td width="80%" align="center" style="color:##6188A5; font-size:16px; font-family:Arial, Helvetica, sans-serif; " valign="top">#session.Enombre#</td>
								<td width="20%" align="left" rowspan="2" valign="top">
									<table>
										<tr>
											<td width="50%" align="right" style="font-size:9px; font-family:Arial, Helvetica, sans-serif;  ">#LB_Usuario#</td>
											<td width="50%" align="right" style="font-size:9px; font-family:Arial, Helvetica, sans-serif; ">#session.Usuario#</td>
										</tr>
										<tr>
											<td align="right" style="font-size:9px; font-family:Arial, Helvetica, sans-serif;  ">#LB_Fecha#</td>
											<td align="right" style="font-size:9px; font-family:Arial, Helvetica, sans-serif;  ">#LSDateFormat(Now(),'dd/mm/yyyy')#</td>
										</tr>
										<tr>
											<td align="right" style="font-size:9px; font-family:Arial, Helvetica, sans-serif;  ">&nbsp;</td>
											<td align="right" style="font-size:9px; font-family:Arial, Helvetica, sans-serif;  ">#cfdocument.currentpagenumber# - #cfdocument.totalpagecount#</td>
										</tr>
									</table>
								</td>
						    </tr>
						    <tr>
								<td align="left" valign="top">&nbsp;</td>
								<td align="center" style="font-size:14px; font-family:Arial, Helvetica, sans-serif; " valign="top">#LB_ReporteDetalleIngresosPorEmpleado#</td>
								<td align="left" valign="top">&nbsp;</td>
							</tr>
						</table>
					</cfoutput>
				</cfdocumentitem>		

				<!--- Se define pie de pagina --->
				<cfdocumentitem type="footer">
					<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
				    	<tr>
							<td align="right" valign="top" style="font-size:8px; font-family:Arial, Helvetica, sans-serif;  " height="12px">
								<cfoutput>#cfdocument.currentpagenumber# - #cfdocument.totalpagecount#</cfoutput>
					    	</td>
				  		</tr>
					</table>
				</cfdocumentitem>
				<!--- Se define cuerpo del reporte --->
				<br>
				<cfoutput>#getHTML(rsIngresosEmp)#</cfoutput>	
			</cfdocument>
		</cfcase>
		<cfcase value="excel">
			<cfcontent type="application/vnd.ms-excel; charset=utf-8">
			<cfheader name="Content-Disposition" value="attachment; filename=#archivo#">
			<!---<cf_EncReporte titulocentrado1='#LB_Corp#' titulocentrado2='#titulocentrado2#' cols="#lvarCols#">--->
            <cf_HeadReport 
            addTitulo1='#LB_Corp#' 
            filtro1='#titulocentrado2#' 
            showEmpresa="true" 
            cols="#lvarCols#"
            showline="false">
			<cfoutput>#getHTML(rsIngresosEmp)#</cfoutput>	
		</cfcase>
	</cfswitch>	
<cfelse>	 
	<cf_HeadReport 
            addTitulo1='#LB_Corp#' 
            filtro1='#titulocentrado2#' 
            showEmpresa="true" 
            cols="#lvarCols#"
            showline="false">
            
    <!---<cf_EncReporte titulocentrado1='#LB_Corp#' titulocentrado2='#titulocentrado2#' cols="#lvarCols#">--->
	<div align="center" style="margin: 15px 0 15px 0"> --- <b><cfoutput>#LB_NoExistenRegistrosQueMostrar#</cfoutput></b> ---</div>
</cfif>	

<cffunction name="getQuery" returntype="query">
	<cfquery name="rsIngresosEmp" datasource="#session.DSN#">
		select de.DEid, de.DEidentificacion, de.DEnombre, de.DEapellido1, de.DEapellido2, cp.CPperiodo, cp.CPmes, 
		#LvarCIdescripcion# as CIdescripcion, coalesce(sum(hic.ICmontores),0) as mtoSubsidio,
		(
			select sum(x.SEsalariobruto) 
			from HSalarioEmpleado x
            inner join CalendarioPagos y
                on x.RCNid = y.CPid
			where x.DEid = de.DEid
				and y.CPmes = cp.CPmes
				and y.CPperiodo = cp.CPperiodo            
			group by y.CPmes, y.CPperiodo              
		) as salarioBasico,
		coalesce((
			select sum(x.ICmontores) 
	        from HIncidenciasCalculo x
            inner join CalendarioPagos y
                on x.RCNid = y.CPid
            inner join CIncidentes z
                on x.CIid = z.CIid
                and z.CInoanticipo = 0    
			where x.DEid = de.DEid
				and y.CPmes = cp.CPmes
				and y.CPperiodo = cp.CPperiodo            
			group by y.CPmes, y.CPperiodo              
		),0) 
			+ 
		(
			select sum(x.SEsalariobruto) 
	        from HSalarioEmpleado x
            inner join CalendarioPagos y
                on x.RCNid = y.CPid
			where x.DEid = de.DEid
				and y.CPmes = cp.CPmes
				and y.CPperiodo = cp.CPperiodo            
			group by y.CPmes, y.CPperiodo              
		) as total

        from DatosEmpleado de
		inner join HSalarioEmpleado hse
		    inner join CalendarioPagos cp
		        on hse.RCNid = cp.CPid
		    inner join HRCalculoNomina hrcn
		    	on cp.CPid=hrcn.RCNid
		    left join HIncidenciasCalculo hic    
		            inner join CIncidentes ci
                        on ci.CIid = hic.CIid
                        and ci.CInoanticipo = 0
		        on hse.DEid = hic.DEid 
		        and hse.RCNid = hic.RCNid  
		on de.DEid = hse.DEid                  
	             
		where de.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			<!---and cp.CPtipo <> 5--->
		<cfif isDefined("form.DEid") and len(trim(form.DEid))>
			and de.DEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.DEid#"> 	
		</cfif>  
		<cfif isDefined("fechDesde") and isDefined("fechHasta")>
			and cp.CPdesde >= <cfqueryparam value="#fechDesde#" cfsqltype="cf_sql_date"> and 
			cp.CPhasta <= <cfqueryparam value="#fechHasta#" cfsqltype="cf_sql_date">
		</cfif>
		<cfif isdefined("form.LISTADEIDEMPLEADO") and len(trim(form.LISTADEIDEMPLEADO))>
            and de.DEid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.LISTADEIDEMPLEADO#" list="true" />) 
        </cfif>
		group by de.DEid, de.DEidentificacion, de.DEnombre, de.DEapellido1, de.DEapellido2, cp.CPperiodo, cp.CPmes, #LvarCIdescripcion#
		order by de.DEidentificacion, cp.CPperiodo, cp.CPmes
	</cfquery>

	<cfreturn rsIngresosEmp>
</cffunction>

<cffunction name="getHTML" output="true">	
	<cfargument name="rsIngresosEmp" type="query" required="true">
    
	<table  class="reporte"  width="100%" cellspacing="0" cellpadding="0">
		<cfset Gtotal = 0>
        <cfoutput query='Arguments.rsIngresosEmp' group="DEid">
			<tbody style="page-break-before:inherit; page-break-after:always;">
            <tr>
				<td colspan="#lvarCols#">
					<strong>#LB_Empleado#</strong> #DEidentificacion# #DEapellido1# #DEapellido2# #DEnombre#
				</td>
			</tr>
			<tr><td colspan="#lvarCols#"></td></tr>
            <cfset GtotalEmp = 0>
			<cfoutput group="CPperiodo">
				<cfoutput group="CPmes">
					<tr>
						<td colspan="#lvarCols#">
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<strong>#LB_Periodo# #CPmes#/#CPperiodo#</strong>
						</td>
					</tr>
					<tr>
						<td width="20%">&nbsp;</td>
						<td width="25%" nowrap>
							#LB_SalarioBasico#
						</td>
						<td style="text-align: right; padding-right: 7%;" width="20%">
							<cf_locale name="number" value="#salarioBasico#"/>
						</td>
						<td>&nbsp;</td>
					</tr>
					<cfoutput>
						<cfif mtoSubsidio gt 0 >
							<tr>
								<td width="20%">&nbsp;</td>
								<td width="25%" nowrap>
									<cfif len(CIdescripcion) eq 0 >
										#LB_Subsidio#
									<cfelse>
										#CIdescripcion#
									</cfif>
								</td>
								<td style="text-align: right; padding-right: 7%;" width="20%">
									<cf_locale name="number" value="#mtoSubsidio#"/>
								</td>
								<td>&nbsp;</td>
							</tr>			
						</cfif>
					</cfoutput>	
					<!---<tr>
						<td colspan="2">&nbsp;</td>
						<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;------------------------------</td>
						<td>&nbsp;</td>
					</tr>--->
					<tr>
						<td colspan="2" align="right"><strong>#LB_subTotal#</strong></td>
						<td style="text-align: right; padding-right: 7%;">
							<cf_locale name="number" value="#total#"/>
						</td>
						<td>&nbsp;</td>
					</tr>
					<cfset GtotalEmp += total>
				</cfoutput>	
            </cfoutput>
           <!--- <tr>
            	<td colspan="2">&nbsp;</td>
            	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;______________________</td>
            	<td>&nbsp;</td>
            </tr>--->
            <tr>
                <td colspan="2" align="right"><strong>#LB_Total#</strong></td>
                <td style="text-align: right; padding-right: 7%;">
                	<strong><cf_locale name="number" value="#GtotalEmp#"/></strong>
                </td>
                <td>&nbsp;</td>
            </tr>	
            <cfset Gtotal += GtotalEmp>
            </tbody>
        </cfoutput>
		<tr><td colspan="#lvarCols#"></td></tr>
		<!---<tr>
        	<td colspan="2">&nbsp;</td>
        	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;______________________</td>
        	<td>&nbsp;</td>
        </tr>--->
		<!---<tr>
			<td align="right" colspan="2"><strong>#LB_GranTotal#</strong></td>
			<td align="right">
            	<strong><cf_locale name="number" value="#Gtotal#"/></strong>
            </td>
            <td>&nbsp;</td>
		</tr>
		<tr><td colspan="#lvarCols#">&nbsp;</td></tr>--->
	</table>
</cffunction>	


           
             
