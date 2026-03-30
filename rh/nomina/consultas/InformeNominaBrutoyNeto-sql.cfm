
<style type="text/css">
	.linDiv { margin-right: 15px; }
	.linDivDet { margin-right: 30px; }
</style>

<cfset t = createObject("component", "sif.Componentes.Translate")>

<!--- Etiquetas de traducción --->
<cfset LB_InformeNominaBrutosyNetos = t.translate('LB_InformeNominaBrutosyNetos','Informe de Nómina Brutos y Netos')>
<cfset LB_Nomina = t.translate('LB_Nomina','Nómina','/rh/generales.xml')>
<cfset LB_CalendarioPago = t.translate('LB_CalendarioPago','Calendario de Pago','/rh/generales.xml')>
<cfset LB_DireccionDeFinanzas = t.translate('LB_DireccionDeFinanzas','Dirección de Finanzas')>
<cfset LB_InformePagoNominaBrutoyNeto = t.translate('LB_InformePagoNominaBrutoyNeto','Informe de pago de Nómina Brutos y Netos')>
<cfset LB_Usuario = t.translate('LB_Usuario','Usuario','/rh/generales.xml')>
<cfset LB_Fecha = t.translate('LB_Fecha','Fecha','/rh/generales.xml')>
<cfset LB_TipoEmpleado = t.translate('LB_TipoEmpleado','Tipo Empleado','/rh/generales.xml')>
<cfset LB_Nombre = t.translate('LB_Nombre','Nombre','/rh/generales.xml')>
<cfset LB_SalarioBruto = t.translate('LB_SalarioBruto','Salario Bruto','/rh/generales.xml')>
<cfset LB_SalarioNeto = t.translate('LB_SalarioNeto','Salario Neto','/rh/generales.xml')>
<cfset LB_Total = t.translate('LB_Total','Total','/rh/generales.xml')>
<cfset LB_subTotal = t.translate('LB_subTotal','Sub-Total','/rh/generales.xml')>
<cfset LB_NoExistenRegistrosQueMostrar = t.Translate('LB_NoExistenRegistrosQueMostrar','No existen registros que mostrar','/rh/generales.xml')>

<cfset LvarBack = "InformeNominaBrutoyNeto.cfm">
<cfset archivo = "InformeNominaBrutosyNetos(#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#).xls">


<!--- Valida si empresa tiene habilitado opcion de mostrar los montos segun tipo de cambio de dolar en los reportes --->
<cfinvoke component="rh.Componentes.RHParametros" method="get" pvalor="2696" default="0" returnvariable="LvarMostrarColDolar">


<!--- Asigna formato de salida --->
<cfif isdefined("form.sFormato") and len(trim(form.sFormato)) >
	<cfset vFormato = form.sFormato >
</cfif>	

<cfif isdefined("form.BTNDOWNLOAD")>
	<cfset vFormato = "excel" >
</cfif>


<cfif LvarMostrarColDolar> <!--- Mostrar columnas tipo de cambio de Dolar --->
	<cfset cols = 7 >
<cfelse>
	<cfset cols = 5 >	
</cfif>


<cfset rsFiltroEncab = getFiltroEncab() >
<cfset filtro1 = "" >

<cfloop query="rsFiltroEncab">
	<cfif RCtc neq 1 >
        <cfset vTC = "(TC: #RCtc#)">
    <cfelse>
        <cfset vTC = "" >   
    </cfif>
	<cfset filtro1 &= '#CPcodigo# - #Tcodigo# - #Tdescripcion# - #CPdescripcion# #vTC#<br/>'>
</cfloop>


<cfset rsPagoNomina = getQuery() >  <!--- Informe de Nómina Brutos y Netos --->

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
<cfif rsPagoNomina.recordcount>
	<cfif createDate(year(rsPagoNomina.mesMax), month(rsPagoNomina.mesMax), 1) neq createDate(year(rsPagoNomina.mesMin), month(rsPagoNomina.mesMin), 1) >
		<cfquery dbtype="query" name="rs1">select VSdesc from rsMeses where VSvalor = '#month(rsPagoNomina.mesMin)#'</cfquery>
		<cfquery dbtype="query" name="rs2">select VSdesc from rsMeses where VSvalor = '#month(rsPagoNomina.mesMax)#'</cfquery>
		<cfset LB_InformeParaElPeriodo= t.translate('LB_InformeParaElPeriodo','Informe para el periodo','/rh/generales.xml')/>
		<cfset titulocentrado2='#LB_InformeParaElPeriodo# #rs1.VSdesc# #year(rsPagoNomina.mesMin)# - #rs2.VSdesc# #year(rsPagoNomina.mesMax)#'>
	<cfelse>	
		<cfquery dbtype="query" name="rs1">select VSdesc from rsMeses where VSvalor = '#month(rsPagoNomina.mesMax)#'</cfquery>
		<cfset LB_InformeAlMesDe= t.translate('LB_InformeAlMesDe','Informe al mes de','/rh/generales.xml')/>
		<cfset titulocentrado2='#LB_InformeAlMesDe# #rs1.VSdesc# #year(rsPagoNomina.mesMax)#'>
	</cfif>	
</cfif>

<cfset LvarHTTP = 'http://'>
<cfif isdefined("session.sitio.ssl_todo") and session.sitio.ssl_todo> <cfset LvarHTTP = 'https://'> </cfif>
<link href="<cfoutput>#LvarHTTP##cgi.server_name#<cfif len(trim(cgi.SERVER_PORT))>:#cgi.SERVER_PORT#</cfif></cfoutput>/cfmx/plantillas/IICA/css/reports.css" rel="stylesheet" type="text/css">

<cfif rsPagoNomina.recordcount>
	<cfswitch expression="#vFormato#">
		<cfcase value="html">
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
            <title><cfoutput>#LB_IICA#</cfoutput></title>
            </head>
            <body>    
                <cf_htmlReportsHeaders irA="#LvarBack#" FileName="#archivo#" title="#LB_InformeNominaBrutosyNetos#">
				<cf_HeadReport
                    addTitulo1='#LB_IICA#'
                    filtro1='#titulocentrado2#'
                    filtro2="#LB_TipoDeCambio#: #rsPagoNomina.tipocambio#"
                    filtro3="#filtro1#"
                    showEmpresa="true" 
                    showline="false">
                
			<cfoutput>#getHTML(rsPagoNomina)#</cfoutput>
            </body>
		</html>

		</cfcase>
		<cfcase value="pdf">
			<cfdocument format="#vFormato#">
				<!--- Se define el encabezado de pagina --->
				<cfdocumentitem type="header">
					<cf_HeadReport
                    addTitulo1='#LB_IICA#'
                    filtro1='#titulocentrado2#'
                    filtro2="#LB_TipoDeCambio#: #rsPagoNomina.tipocambio#"
                    filtro3="#filtro1#"
                    showEmpresa="true" 
                    showline="false">
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
				<cfoutput>#getHTML(rsPagoNomina)#</cfoutput>	
			</cfdocument>
		</cfcase>
		<cfcase value="excel"> 
			<cfcontent type="application/vnd.ms-excel; charset=windows-1252">
			<!---<cf_htmlReportsHeaders irA="#LvarBack#" FileName="#archivo#" title="#LB_InformeNominaBrutosyNetos#">--->
			<cfheader name="Content-Disposition" value="attachment; filename=#archivo#" >
			
			    <cf_HeadReport
				addTitulo1='#LB_IICA#'
				filtro1='#titulocentrado2#'
				filtro2="#LB_TipoDeCambio#: #rsPagoNomina.tipocambio#"
				filtro3="#filtro1#"
				cols="#cols-2#"
                showEmpresa="true" 
                showline="false"
				setStyle="false">
            <cfoutput>#getHTML(rsPagoNomina)#</cfoutput>	
		</cfcase>
	</cfswitch>	
<cfelse>	 
	<cf_htmlReportsHeaders irA="#LvarBack#" FileName="#archivo#" title="#LB_InformeNominaBrutosyNetos#">
	    <cf_HeadReport
            addTitulo1='#LB_IICA#'
            filtro1='#titulocentrado2#'
            filtro2="<b>#LB_TipoDeCambio#: #rsPagoNomina.tipocambio#</b>"
            filtro3="#filtro1#"
            cols="#cols-2#"
            showEmpresa="true" 
            showline="false">
   	 <div align="center" style="margin: 15px 0 15px 0"> --- <b><cfoutput>#LB_NoExistenRegistrosQueMostrar#</cfoutput></b> ---</div>
</cfif>	


<cffunction name="getFiltroEncab" returntype="query">
	<cfquery name="rsFiltroEncab" datasource="#session.DSN#">
		select distinct tn.Tcodigo, tn.Tdescripcion, cp.CPcodigo, cp.CPdescripcion, coalesce(rcn.RCtc,1) as RCtc
		from DatosEmpleado de
		left join TiposEmpleado te
		    on de.TEid = te.TEid
		inner join HSalarioEmpleado hse
			on de.DEid = hse.DEid
	    	inner join HRCalculoNomina rcn
	        	on hse.RCNid = rcn.RCNid
	        	inner join CalendarioPagos cp
	        		on rcn.RCNid = cp.CPid
	        	inner join TiposNomina tn 
		        	on rcn.Ecodigo = tn.Ecodigo
		        	and rcn.Tcodigo = tn.Tcodigo
	    	left join HIncidenciasCalculo ic
	        	on hse.DEid = ic.DEid
	        	and hse.RCNid = ic.RCNid
	    		left join CIncidentes ci
	         		on ic.CIid = ci.CIid 
	         		and ci.CInoanticipo = 0
		         		
		where 1=1
		<cfif isdefined("form.TcodigoListNom") and len(trim(form.TcodigoListNom)) GT 0>
			and rcn.RCNid in (<cfqueryparam cfsqltype="cf_sql_integer" value="#form.TcodigoListNom#" list="true" />)
		</cfif>	
		<cfif isdefined("form.TcodigoListTE") and len(trim(form.TcodigoListTE)) GT 0 >
			and te.TEid in(<cfqueryparam cfsqltype="cf_sql_integer" value="#form.TcodigoListTE#" list="true" />)
		</cfif>
	</cfquery>

	<cfreturn rsFiltroEncab>
</cffunction>


<cffunction name="getQuery" returntype="query">
	<cf_translatedata name="get" tabla="TiposEmpleado" col="TEdescripcion" returnvariable="LvarTEdescripcion">
	
   <!--- <cfquery name="rsPagoNomina" datasource="#session.DSN#">
		select rcn.RCNid, de.DEid, de.DEidentificacion, de.DEnombre, de.DEapellido1, de.DEapellido2, #LvarTEdescripcion# as TipoEmpleado, 
       	hse.SEsalariobruto as salarioBruto, 
		coalesce(( 	select sum(ic.ICmontores)
                    from HIncidenciasCalculo ic
                    where ic.DEid = hse.DEid
                    and ic.RCNid = hse.RCNid
                    <cfif isdefined("form.TcodigoListNom") and len(trim(form.TcodigoListNom)) GT 0>
                        and ic.RCNid in (<cfqueryparam cfsqltype="cf_sql_integer" value="#form.TcodigoListNom#" list="true" />)
                    </cfif>
                    and exists (select 1 from CIncidentes ci where ci.CIid = ic.CIid and  ci.CInoanticipo = 0)
                )
            ,0) as Incidencias,  
         	(case when coalesce(rcn.RCtc,1) = 1 
            		then 0 
                    else ( hse.SEsalariobruto + coalesce( 
                    										
                            							( select sum(ic.ICmontores)
                                                            from HIncidenciasCalculo ic
                                                            where ic.DEid = hse.DEid
                                                            and dc.RCNid =  hse.RCNid
                                                            <cfif isdefined("form.TcodigoListNom") and len(trim(form.TcodigoListNom)) GT 0>
                                                                and ic.RCNid in (<cfqueryparam cfsqltype="cf_sql_integer" value="#form.TcodigoListNom#" list="true" />)
                                                            </cfif>
                                                            and exists (select 1 from CIncidentes ci where ci.CIid = ic.CIid and  ci.CInoanticipo = 0)
                                                        )
                                                	,0)
                                                    
                          )/rcn.RCtc end) as salarioBrutoDolares,
            	hse.SEliquido + coalesce( (Select sum(DCvalor) 
                                    from  DeduccionesCalculo dc
                                    inner join DeduccionesEmpleado dec
                                        on dec.DEid = dc.DEid	
                                         and dec.Did = dc.Did	
                                    inner join RHExportacionDeducciones exd     
                                        on exd.TDid = dec.TDid  
                                        and exd.TDid not in (50,136,139,148)
                                    where dc.DEid = hse.DEid
                                   	and dc.RCNid =  hse.RCNid
									<cfif isdefined("form.TcodigoListNom") and len(trim(form.TcodigoListNom)) GT 0>
                                        and dc.RCNid in (<cfqueryparam cfsqltype="cf_sql_integer" value="#form.TcodigoListNom#" list="true" />)
                                    </cfif>	
                                ),0) as salarioNeto,
                
		 	case when coalesce(rcn.RCtc,1) = 1 
            	then 0 
            	else (hse.SEliquido)/rcn.RCtc end  as salarioNetoDolares,
            coalesce( 
            	(Select sum(DCvalor) 
                    from  DeduccionesCalculo dc
                    inner join DeduccionesEmpleado dec
                        on dec.DEid = dc.DEid	
                         and dec.Did = dc.Did	
                    inner join RHExportacionDeducciones exd     
                        on exd.TDid = dec.TDid  
                        and exd.TDid not in (50,136,139,148)
                    where dc.DEid = hse.DEid
                    and dc.RCNid =  hse.RCNid
                    <cfif isdefined("form.TcodigoListNom") and len(trim(form.TcodigoListNom)) GT 0>
                        and dc.RCNid in (<cfqueryparam cfsqltype="cf_sql_integer" value="#form.TcodigoListNom#" list="true" />)
                    </cfif>	
                ),0) as Otros_Depositos,
            max(rcn.RCtc) as tipocambio,
		 	max(cp.CPfpago) as mesMax,
		 	min(cp.CPfpago) as mesMin
		from HSalarioEmpleado hse
        inner join HRCalculoNomina rcn
	        	on hse.RCNid = rcn.RCNid
        inner join CalendarioPagos cp
            on cp.CPid=rcn.RCNid	
		inner join DatosEmpleado de
			on de.DEid = hse.DEid
        left join TiposEmpleado te
		    on de.TEid = te.TEid
        
        	<!---left join HIncidenciasCalculo ic
	        	on ic.DEid = hse.DEid
	        	and ic.RCNid = hse.RCNid
	    		and exists (select 1 from CIncidentes ci where ci.CIid = ic.CIid and  ci.CInoanticipo = 0)--->
		where 1=1
		<cfif isdefined("form.TcodigoListNom") and len(trim(form.TcodigoListNom)) GT 0>
			and rcn.RCNid in (<cfqueryparam cfsqltype="cf_sql_integer" value="#form.TcodigoListNom#" list="true" />)
		</cfif>	
		<cfif isdefined("form.TcodigoListTE") and len(trim(form.TcodigoListTE)) GT 0 >
			and te.TEid in(<cfqueryparam cfsqltype="cf_sql_integer" value="#form.TcodigoListTE#" list="true" />)
		</cfif>
		group by rcn.RCNid, de.DEid, de.DEidentificacion, de.DEnombre, de.DEapellido1, de.DEapellido2, #LvarTEdescripcion#, 
		hse.SEsalariobruto, hse.SEliquido, rcn.RCtc <!------>
		order by #LvarTEdescripcion#, de.DEapellido1, de.DEapellido2
	</cfquery>
    --->
    
    <!---<cfquery name="rsPagoNomina" datasource="#session.DSN#">
		select rcn.RCNid, de.DEid, de.DEidentificacion, de.DEnombre, de.DEapellido1, de.DEapellido2, #LvarTEdescripcion# as TipoEmpleado, 
        (hse.SEsalariobruto + sum(coalesce(ic.ICmontores,0))) as salarioBruto, 
		 	(case when coalesce(rcn.RCtc,1) = 1 then 0 else (hse.SEsalariobruto + sum(coalesce(ic.ICmontores,0)))/rcn.RCtc end) as salarioBrutoDolares, hse.SEliquido as salarioNeto,
		 	(case when coalesce(rcn.RCtc,1) = 1 then 0 else hse.SEliquido/rcn.RCtc end) as salarioNetoDolares,
		 	max(rcn.RCtc) as tipocambio,
		 	max(cp.CPfpago) as mesMax,
		 	min(cp.CPfpago) as mesMin
		from DatosEmpleado de
		left join TiposEmpleado te
		    on de.TEid = te.TEid
		inner join HSalarioEmpleado hse
			on de.DEid = hse.DEid
	    	inner join HRCalculoNomina rcn
	        	on hse.RCNid = rcn.RCNid
	        inner join CalendarioPagos cp
	        	on cp.CPid=rcn.RCNid	
	    	left join HIncidenciasCalculo ic
	        	on ic.DEid = hse.DEid
	        	and ic.RCNid = hse.RCNid
	    		and exists (select 1 from CIncidentes ci where ci.CIid = ic.CIid and  ci.CInoanticipo = 0)
		where 1=1
		<cfif isdefined("form.TcodigoListNom") and len(trim(form.TcodigoListNom)) GT 0>
			and rcn.RCNid in (<cfqueryparam cfsqltype="cf_sql_integer" value="#form.TcodigoListNom#" list="true" />)
		</cfif>	
		<cfif isdefined("form.TcodigoListTE") and len(trim(form.TcodigoListTE)) GT 0 >
			and te.TEid in(<cfqueryparam cfsqltype="cf_sql_integer" value="#form.TcodigoListTE#" list="true" />)
		</cfif>
		group by rcn.RCNid, de.DEid, de.DEidentificacion, de.DEnombre, de.DEapellido1, de.DEapellido2, #LvarTEdescripcion#, 
		hse.SEsalariobruto, hse.SEliquido, rcn.RCtc
		order by #LvarTEdescripcion#, de.DEapellido1, de.DEapellido2
	</cfquery>--->

	<!--- <cfquery name="rsPagoNomina" dbtype="query">
        select DEid, DEidentificacion, DEnombre, DEapellido1, DEapellido2, TipoEmpleado, sum(salarioBruto + Incidencias) as salarioBruto,
        sum(salarioBrutoDolares) as salarioBrutoDolares, 
        sum(salarioNeto) as salarioNeto, 
        sum(salarioNetoDolares) + sum(Otros_Depositos/tipocambio)  as salarioNetoDolares, 
        max(mesMax) as mesMax,min(mesMin) as mesMin, max(tipocambio) as tipocambio
        from rsPagoNomina
        group by TipoEmpleado, DEapellido1, DEapellido2, DEnombre, DEidentificacion,DEid
        order by TipoEmpleado, DEapellido1, DEapellido2, DEnombre, DEidentificacion,DEid
    </cfquery>--->
    
    
    <cfquery name="rsPagoNomina" datasource="#session.DSN#">
		select rcn.RCNid, de.DEid, de.DEidentificacion, de.DEnombre, de.DEapellido1, de.DEapellido2, #LvarTEdescripcion# as TipoEmpleado, 
        (hse.SEsalariobruto + coalesce(( select sum(ic.ICmontores)
                                        from HIncidenciasCalculo ic
                                        where ic.DEid = de.DEid
                                        and ic.RCNid =  rcn.RCNid
                                        <cfif isdefined("form.TcodigoListNom") and len(trim(form.TcodigoListNom)) GT 0>
                                            and ic.RCNid in (<cfqueryparam cfsqltype="cf_sql_integer" value="#form.TcodigoListNom#" list="true" />)
                                        </cfif>
                                        and exists (select 1 from CIncidentes ci where ci.CIid = ic.CIid and  ci.CInoanticipo = 0)
                                     ),0)) as salarioBruto, 
		 	(case when coalesce(rcn.RCtc,1) = 1 then 0 
            		else (hse.SEsalariobruto 
                    		+ coalesce(
                            	( select sum(ic.ICmontores)
                                        from HIncidenciasCalculo ic
                                        where ic.DEid = de.DEid
                                        and ic.RCNid =  rcn.RCNid
                                        <cfif isdefined("form.TcodigoListNom") and len(trim(form.TcodigoListNom)) GT 0>
                                            and ic.RCNid in (<cfqueryparam cfsqltype="cf_sql_integer" value="#form.TcodigoListNom#" list="true" />)
                                        </cfif>
                                        and exists (select 1 from CIncidentes ci where ci.CIid = ic.CIid and  ci.CInoanticipo = 0)
                                     )
                            ,0))/rcn.RCtc end) as salarioBrutoDolares,
                            
            hse.SEliquido + coalesce( (Select sum(DCvalor) 
                                        from  HDeduccionesCalculo dc
                                        inner join DeduccionesEmpleado dec
                                            on dec.DEid = dc.DEid	
                                             and dec.Did = dc.Did	
                                        inner join RHExportacionDeducciones exd     
                                            on exd.TDid = dec.TDid  
                                            and exd.RHEDesliquido = 1 <!---deducciones correspondientes a salario liquido--->
                                        where dc.DEid = de.DEid
                                        and dc.RCNid =  rcn.RCNid
                                        <cfif isdefined("form.TcodigoListNom") and len(trim(form.TcodigoListNom)) GT 0>
                                            and dc.RCNid in (<cfqueryparam cfsqltype="cf_sql_integer" value="#form.TcodigoListNom#" list="true" />)
                                        </cfif>	
                                    ),0) as salarioNeto,
		 	(case when coalesce(rcn.RCtc,1) = 1 then 0 
            		else 
                    	(hse.SEliquido + coalesce( (Select sum(DCvalor) 
                                        from  HDeduccionesCalculo dc
                                        inner join DeduccionesEmpleado dec
                                            on dec.DEid = dc.DEid	
                                             and dec.Did = dc.Did	
                                        inner join RHExportacionDeducciones exd     
                                            on exd.TDid = dec.TDid  
                                            and exd.RHEDesliquido = 1 <!---deducciones correspondientes a salario liquido--->
                                        where dc.DEid = de.DEid
                                        and dc.RCNid =  rcn.RCNid
                                        <cfif isdefined("form.TcodigoListNom") and len(trim(form.TcodigoListNom)) GT 0>
                                            and dc.RCNid in (<cfqueryparam cfsqltype="cf_sql_integer" value="#form.TcodigoListNom#" list="true" />)
                                        </cfif>	
                                    ),0))/rcn.RCtc                     
                    end) as salarioNetoDolares,
		 	max(rcn.RCtc) as tipocambio,
		 	max(cp.CPfpago) as mesMax,
		 	min(cp.CPfpago) as mesMin
		from HRCalculoNomina rcn
        inner join HSalarioEmpleado hse 
            on hse.RCNid = rcn.RCNid
        inner join CalendarioPagos cp
            on cp.CPid=rcn.RCNid	
	    inner join DatosEmpleado de
        	on de.DEid = hse.DEid
		left join TiposEmpleado te
		    on de.TEid = te.TEid
		where 1=1
		<cfif isdefined("form.TcodigoListNom") and len(trim(form.TcodigoListNom)) GT 0>
			and rcn.RCNid in (<cfqueryparam cfsqltype="cf_sql_integer" value="#form.TcodigoListNom#" list="true" />)
		</cfif>	
		<cfif isdefined("form.TcodigoListTE") and len(trim(form.TcodigoListTE)) GT 0 >
			and te.TEid in(<cfqueryparam cfsqltype="cf_sql_integer" value="#form.TcodigoListTE#" list="true" />)
		</cfif>
		group by rcn.RCNid, de.DEid, de.DEidentificacion, de.DEnombre, de.DEapellido1, de.DEapellido2, #LvarTEdescripcion#, 
		hse.SEsalariobruto, hse.SEliquido, rcn.RCtc 
		order by #LvarTEdescripcion#, de.DEapellido1, de.DEapellido2
	</cfquery>
    
     <cfquery name="rsPagoNomina" dbtype="query">
        select DEid, DEidentificacion, DEnombre, DEapellido1, DEapellido2, TipoEmpleado, sum(salarioBruto) as salarioBruto,
        sum(salarioBrutoDolares) as salarioBrutoDolares, sum(salarioNeto) as salarioNeto, sum(salarioNetoDolares) as salarioNetoDolares, max(mesMax) as mesMax,min(mesMin) as mesMin, max(tipocambio) as tipocambio
        from rsPagoNomina
        group by TipoEmpleado, DEapellido1, DEapellido2, DEnombre, DEidentificacion,DEid
        order by TipoEmpleado, DEapellido1, DEapellido2, DEnombre, DEidentificacion,DEid
    </cfquery>

	<cfreturn rsPagoNomina>
</cffunction>


<cffunction name="getHTML" output="true">	
	<cfargument name="rsPagoNomina" type="query" required="true">
		
	<table  class="reporte" width="100%" cellspacing="0" cellpadding="5">
		<!---<tr>
			<td style="font-size: 24px; text-align: center;" colspan="#cols#">
				<strong>#LB_DireccionDeFinanzas#</strong>
			</td>
		</tr>  
		<tr>
			<td style="font-size: 20px; text-align: center;" colspan="#cols#">
				<strong>#LB_InformePagoNominaBrutoyNeto#</strong>
			</td>
		</tr>---> 
		<tr>
			<td colspan="#cols#">
				<cfif compare("#vFormato#","html") eq 0 >
					<!---<hr class="linDiv" style="width:100%; border:1px solid ##000;"/>--->
				<cfelseif compare("#vFormato#","pdf") eq 0 >
					<cfif LvarMostrarColDolar>
						<span>_______________________________________________________________________________________________________________________________________________________________________________</span> 
					<cfelse>	
						<span>_______________________________________________________________________________________________</span> 
					</cfif>	
				<cfelse> <!--- excel --->
					<cfif LvarMostrarColDolar>
						<span>__________________________________________________________________________________________________________________________________________________________________</span>
					<cfelse>	
				   		<span>______________________________________________________________________________________________________________________________</span>
				   	</cfif>		
				</cfif>	
			</td>
		</tr>
		<cfset vTotGBruto = 0 >
		<cfset vTotGNeto = 0 >

		<cfif LvarMostrarColDolar>
			<cfset vTotGBrutoDolar = 0 >
			<cfset vTotGNetoDolar = 0 >
		</cfif>

		<cfoutput query='Arguments.rsPagoNomina' group="TipoEmpleado">
			<cfif compare("#vFormato#","excel") eq 0 > <tr><td colspan="#cols#"></td></tr> </cfif>
			<tr>
				<td colspan="#cols#"><strong>#LB_TipoEmpleado#: #TipoEmpleado#</strong></td>
			</tr>
			<cfif compare("#vFormato#","excel") neq 0 > <tr><td colspan="#cols#"></td></tr> </cfif>
			<tr>
				<td colspan="#cols#">
					<cfif compare("#vFormato#","html") eq 0 >
						<!---<hr class="linDivDet" style="width:95%; border:1px solid ##000;"/>--->
					<cfelseif compare("#vFormato#","pdf") eq 0 >
						<cfif LvarMostrarColDolar>
							<span style="padding-left: 60px;">__________________________________________________________________________________________________________________________________________________________________</span>
						<cfelse>	
							<span style="padding-left: 60px;">_________________________________________________________________________________</span>
						</cfif>	
					<cfelse> <!--- excel --->
						<cfif LvarMostrarColDolar>
							<span>__________________________________________________________________________________________________________________________________________________________________</span>
						<cfelse>	
							<span>_____________________________________________________________________________________________________________________________</span>	
						</cfif>	
					</cfif>	
				</td>
			</tr>
			<thead style="display: table-header-group">
            <tr>
				<td <cfif LvarMostrarColDolar>width="5%"<cfelse>width="10%"</cfif> ></td> 
				<td width="30%" <cfif compare("#vFormato#","pdf") eq 0 > style="padding-left: 70px;" </cfif> >
					<strong>#LB_Nombre#</strong>
				</td>

				<cfif LvarMostrarColDolar> <!--- Mostrar columnas tipo de cambio de Dolar --->
					<td width="15%" <cfif compare("#vFormato#","pdf") eq 0 > style="padding-left: 47px;"
						<cfelseif compare("#vFormato#","html") eq 0 > style="text-align: right; padding-right: 45px;" 
						<cfelse> style="text-align: right;" </cfif> > <strong>#LB_SalarioBruto#</strong>
					</td>	

					<td width="15%" <cfif compare("#vFormato#","pdf") eq 0 > style="padding-left: 47px;"
						<cfelseif compare("#vFormato#","html") eq 0 > style="text-align: right; padding-right: 45px;" 
						<cfelse> style="text-align: right;" </cfif> > <strong>#LB_SalarioBruto#(USD)</strong>
					</td>

					<td width="15%" <cfif compare("#vFormato#","pdf") eq 0 > style="padding-left: 47px;" 
						<cfelseif compare("#vFormato#","html") eq 0 > style="text-align: right; padding-right: 45px;" 
						<cfelse> style="text-align: right;" </cfif> > <strong>#LB_SalarioNeto#</strong>
					</td>

					<td width="15%" <cfif compare("#vFormato#","pdf") eq 0 > style="padding-left: 47px;" 
						<cfelseif compare("#vFormato#","html") eq 0 > style="text-align: right; padding-right: 45px;" 
						<cfelse> style="text-align: right;" </cfif> > <strong>#LB_SalarioNeto#(USD)</strong>
					</td>
				<cfelse>
					<td width="25%" <cfif compare("#vFormato#","pdf") eq 0 > style="padding-left: 47px;" 
						<cfelseif compare("#vFormato#","html") eq 0 > style="padding-left: 17px;" 
						<cfelse> style="text-align: right;" </cfif> > <strong>#LB_SalarioBruto#</strong>	
					</td>
					<td width="25%" <cfif compare("#vFormato#","pdf") eq 0 > style="padding-left: 47px;" 
						<cfelseif compare("#vFormato#","html") eq 0 > style="padding-left: 17px;" 
						<cfelse> style="text-align: right;" </cfif> > <strong>#LB_SalarioNeto#</strong>
					</td>	
				</cfif>
				<td <cfif LvarMostrarColDolar>width="5%"<cfelse>width="10%"</cfif> ></td>
			</tr>
            </thead>
			<tr>
				<td colspan="#cols#">
					<cfif compare("#vFormato#","html") eq 0 >
						<!---<hr class="linDivDet" style="width:95%; border:1px solid ##000;"/>--->
					<cfelseif compare("#vFormato#","pdf") eq 0 >
						<cfif LvarMostrarColDolar>
							<span style="padding-left: 60px;">__________________________________________________________________________________________________________________________________________________________________ </span>
						<cfelse>	
							<span style="padding-left: 60px;">_________________________________________________________________________________</span>
						</cfif>	
					<cfelse> <!--- excel ---> 
						<cfif LvarMostrarColDolar>
							<span>__________________________________________________________________________________________________________________________________________________________________</span>	
						<cfelse>	
							<span>_____________________________________________________________________________________________________________________________</span>	
						</cfif>		
					</cfif>	
				</td>
			</tr>
			<cfset vTotBruto = 0 >
			<cfset vTotNeto = 0 >

			<cfif LvarMostrarColDolar>
				<cfset vTotBrutoDolar = 0 >
				<cfset vTotNetoDolar = 0 >
			</cfif>

			<cfoutput>
				<tr>
					<td <cfif LvarMostrarColDolar>width="5%"<cfelse>width="10%"</cfif> ></td>
					<td width="30%" nowrap <cfif compare("#vFormato#","pdf") eq 0 > style="padding-left: 70px;" </cfif> >#DEapellido1# #DEapellido2# #DEnombre#</td>

					<cfif LvarMostrarColDolar> <!--- Mostrar columnas tipo de cambio de Dolar --->
						<td width="15%" <cfif compare("#vFormato#","pdf") eq 0 > style="text-align: right; padding-right: 85px;" 
							<cfelseif compare("#vFormato#","html") eq 0 > style="text-align: right; padding-right: 45px;" 
							<cfelse> style="text-align: right;" </cfif> > <cf_locale name="number" value="#salarioBruto#"/>
						</td>
						<td width="15%" <cfif compare("#vFormato#","pdf") eq 0 > style="text-align: right; padding-right: 95px;" 
							<cfelseif compare("#vFormato#","html") eq 0 > style="text-align: right; padding-right: 45px;" 
							<cfelse> style="text-align: right;" </cfif> > <cf_locale name="number" value="#salarioBrutoDolares#"/>
						</td>
						<td width="15%" <cfif compare("#vFormato#","pdf") eq 0 > style="text-align: right; padding-right: 105px;" 
							<cfelseif compare("#vFormato#","html") eq 0 > style="text-align: right; padding-right: 45px;" 
							<cfelse> style="text-align: right;" </cfif> > <cf_locale name="number" value="#salarioNeto#"/>
						</td>
						<td width="15%" <cfif compare("#vFormato#","pdf") eq 0 > style="text-align: right; padding-right: 115px;" 
							<cfelseif compare("#vFormato#","html") eq 0 > style="text-align: right; padding-right: 45px;" 
							<cfelse> style="text-align: right;" </cfif> > <cf_locale name="number" value="#salarioNetoDolares#"/>
						</td>
					<cfelse>
						<td width="25%" <cfif compare("#vFormato#","pdf") eq 0 > style="text-align: right; padding-right: 85px;" 
							<cfelseif compare("#vFormato#","html") eq 0 > style="text-align: right; padding-right: 245px;" 
							<cfelse> style="text-align: right;" </cfif> > <cf_locale name="number" value="#salarioBruto#"/>
						</td>
						<td width="25%" <cfif compare("#vFormato#","pdf") eq 0 > style="text-align: right; padding-right: 95px;" 
							<cfelseif compare("#vFormato#","html") eq 0 > style="text-align: right; padding-right: 245px;" 
							<cfelse> style="text-align: right;" </cfif> > <cf_locale name="number" value="#salarioNeto#"/>
						</td>
					</cfif>	
					<td <cfif LvarMostrarColDolar>width="5%"<cfelse>width="10%"</cfif> ></td>
				</tr>
				<cfset vTotBruto += salarioBruto >
				<cfset vTotNeto += salarioNeto >

				<cfif LvarMostrarColDolar>
					<cfset vTotBrutoDolar += salarioBrutoDolares >
					<cfset vTotNetoDolar += salarioNetoDolares >
				</cfif>
			</cfoutput>
			<tr>
				<td width="40%" colspan="2"></td>

				<cfif LvarMostrarColDolar> <!--- Mostrar columnas tipo de cambio de Dolar --->
					<td width="15%">
						<cfif compare("#vFormato#","html") eq 0 >
							<!---<hr style="width:95%; border:1px solid ##000; margin-right: -2px;"/>--->
						<cfelseif compare("#vFormato#","pdf") eq 0 >
							<span style="padding-right: 30px;">_____________________</span>
						<cfelse>
							<span>________________________</span>	
						</cfif>	
					</td>
					<td width="15%">
						<cfif compare("#vFormato#","html") eq 0 >
							<!---<hr style="width:95%; border:1px solid ##000; margin-right: -2px;;"/>--->
						<cfelseif compare("#vFormato#","pdf") eq 0 >
							<span style="padding-right: 45px;">_____________________</span>
						<cfelse>
							<span>________________________</span>	
						</cfif>	
					</td>
					<td width="15%">
						<cfif compare("#vFormato#","html") eq 0 >
							<!---<hr style="width:95%; border:1px solid ##000; margin-right: -2px;;"/>--->
						<cfelseif compare("#vFormato#","pdf") eq 0 >
							<span style="padding-right: 60px;">_____________________</span>
						<cfelse>
							<span>________________________</span>	
						</cfif>	
					</td>
					<td width="15%">
						<cfif compare("#vFormato#","html") eq 0 >
							<!---<hr style="width:95%; border:1px solid ##000; margin-right: -2px;;"/>--->
						<cfelseif compare("#vFormato#","pdf") eq 0 >
							<span style="padding-right: 75px;">_____________________</span>
						<cfelse>
							<span>________________________</span>	
						</cfif>	
					</td>
				<cfelse>
					<td width="25%">
						<cfif compare("#vFormato#","html") eq 0 >
							<!---<hr style="width:70%; border:1px solid ##000; margin-right: 165px;"/>--->
						<cfelseif compare("#vFormato#","pdf") eq 0 >
							<span style="padding-right: 30px;">_____________________</span>
						<cfelse>
							<span style="text-align: right;">_____________________</span>	
						</cfif>	
					</td>
					<td width="25%">
						<cfif compare("#vFormato#","html") eq 0 >
							<!---<hr style="width:70%; border:1px solid ##000; margin-right: 165px;"/>--->
						<cfelseif compare("#vFormato#","pdf") eq 0 >
							<span style="padding-right: 45px;">_____________________</span>
						<cfelse>
							<span style="text-align: right;">_____________________</span>	
						</cfif>	
					</td>
					<td width="10%"></td>
				</cfif>	
			</tr>
			<tr>
				<td  align="right"<cfif LvarMostrarColDolar>width="35%"<cfelse>width="40%"</cfif> colspan="2"> <strong>#LB_subTotal#:</strong></td>

				<cfif LvarMostrarColDolar> <!--- Mostrar columnas tipo de cambio de Dolar --->
					<td width="15%" <cfif compare("#vFormato#","pdf") eq 0 > style="text-align: right; padding-right: 88px;" 
						<cfelseif compare("#vFormato#","html") eq 0 > style="text-align: right; padding-right: 45px;" 
						<cfelse> style="text-align: right;" </cfif> > <cf_locale name="number" value="#vTotBruto#"/>
					</td>
					<td width="15%" <cfif compare("#vFormato#","pdf") eq 0 > style="text-align: right; padding-right: 98px;" 
						<cfelseif compare("#vFormato#","html") eq 0 > style="text-align: right; padding-right: 45px;" 
						<cfelse> style="text-align: right;" </cfif> > <cf_locale name="number" value="#vTotBrutoDolar#"/>
					</td>
					<td width="15%" <cfif compare("#vFormato#","pdf") eq 0 > style="text-align: right; padding-right: 108px;"
					    <cfelseif compare("#vFormato#","html") eq 0 > style="text-align: right; padding-right: 45px;" 
						<cfelse> style="text-align: right;" </cfif> > <cf_locale name="number" value="#vTotNeto#"/>
					</td>
					<td width="15%" <cfif compare("#vFormato#","pdf") eq 0 > style="text-align: right; padding-right: 118px;"
					    <cfelseif compare("#vFormato#","html") eq 0 > style="text-align: right; padding-right: 45px;" 
						<cfelse> style="text-align: right;" </cfif> > <cf_locale name="number" value="#vTotNetoDolar#"/>
					</td>
				<cfelse>
					<td width="25%" <cfif compare("#vFormato#","pdf") eq 0 > style="text-align: right; padding-right: 88px;" 
						<cfelseif compare("#vFormato#","html") eq 0 > style="text-align: right; padding-right: 245px;" 
						<cfelse> style="text-align: right;" </cfif> > <cf_locale name="number" value="#vTotBruto#"/>
					</td>
					<td width="25%" <cfif compare("#vFormato#","pdf") eq 0 > style="text-align: right; padding-right: 98px;"
					    <cfelseif compare("#vFormato#","html") eq 0 > style="text-align: right; padding-right: 245px;" 
						<cfelse> style="text-align: right;" </cfif> > <cf_locale name="number" value="#vTotNeto#"/>
					</td>
				</cfif>	
				<td <cfif LvarMostrarColDolar>width="5%"<cfelse>width="10%"</cfif> ></td>
			</tr>	
			<cfif compare("#vFormato#","excel") neq 0 > 
				<tr><td colspan="#cols#"></td></tr> 
				<tr><td colspan="#cols#"></td></tr>
			</cfif>
			<cfset vTotGBruto += vTotBruto >	
			<cfset vTotGNeto += vTotNeto >

			<cfif LvarMostrarColDolar>
				<cfset vTotGBrutoDolar += vTotBrutoDolar >
				<cfset vTotGNetoDolar += vTotNetoDolar >
			</cfif>
		</cfoutput>
		<tr><td colspan="#cols#"></td></tr>
		<tr>
			<td <cfif LvarMostrarColDolar>width="35%"<cfelse>width="40%"</cfif> colspan="2" style="text-align: right;">
				<strong>#LB_Total#:</strong>
			</td>

			<cfif LvarMostrarColDolar> <!--- Mostrar columnas tipo de cambio de Dolar --->
				<td width="15%" <cfif compare("#vFormato#","pdf") eq 0 > style="text-align: right; padding-right: 85px;" 
					<cfelseif compare("#vFormato#","html") eq 0 > style="text-align: right; padding-right: 45px;" 
					<cfelse> style="text-align: right;" </cfif> >
					<strong> <cf_locale name="number" value="#vTotGBruto#"/> </strong>
				</td>
				<td width="15%" <cfif compare("#vFormato#","pdf") eq 0 > style="text-align: right; padding-right: 95px;" 
					<cfelseif compare("#vFormato#","html") eq 0 > style="text-align: right; padding-right: 45px;" 
					<cfelse> style="text-align: right;" </cfif> >
					<strong> <cf_locale name="number" value="#vTotGBrutoDolar#"/> </strong>
				</td>
				<td width="15%" <cfif compare("#vFormato#","pdf") eq 0 > style="text-align: right; padding-right: 105px;" 
					<cfelseif compare("#vFormato#","html") eq 0 > style="text-align: right; padding-right: 45px;" 
				    <cfelse> style="text-align: right;" </cfif> >
					<strong> <cf_locale name="number" value="#vTotGNeto#"/> </strong>
				</td>
				<td width="15%" <cfif compare("#vFormato#","pdf") eq 0 > style="text-align: right; padding-right: 115px;" 
					<cfelseif compare("#vFormato#","html") eq 0 > style="text-align: right; padding-right: 45px;" 
				    <cfelse> style="text-align: right;" </cfif> >
					<strong> <cf_locale name="number" value="#vTotGNetoDolar#"/> </strong>
				</td>
			<cfelse>
				<td width="25%" <cfif compare("#vFormato#","pdf") eq 0 > style="text-align: right; padding-right: 85px;" 
					<cfelseif compare("#vFormato#","html") eq 0 > style="text-align: right; padding-right: 245px;" 
					<cfelse> style="text-align: right;" </cfif> >
					<strong> <cf_locale name="number" value="#vTotGBruto#"/> </strong>
				</td>
				<td width="25%" <cfif compare("#vFormato#","pdf") eq 0 > style="text-align: right; padding-right: 95px;" 
					<cfelseif compare("#vFormato#","html") eq 0 > style="text-align: right; padding-right: 245px;" 
				    <cfelse> style="text-align: right;" </cfif> >
					<strong> <cf_locale name="number" value="#vTotGNeto#"/> </strong>
				</td>
			</cfif>	
			<td <cfif LvarMostrarColDolar>width="5%"<cfelse>width="10%"</cfif> ></td>
		</tr>
		<cfif compare("#vFormato#","excel") neq 0 > 
			<tr><td colspan="#cols#"></td></tr> 
			<tr><td colspan="#cols#"></td></tr>
		</cfif>
		<tr><td colspan="#cols#"></td></tr>
		<tr><td colspan="#cols#"></td></tr>
	</table>	
</cffunction>	