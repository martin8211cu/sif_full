<cfsetting requesttimeout="3600">
<cfparam name="form.CPid" default="0">
	
<cfset p=''>
<cfif isDefined("chkHistorico")>
	<cfset p='H'>
</cfif>

<cfset t = createObject("component","sif.Componentes.Translate")>

<!--- Etiquetas de traduccion --->
<cfset LB_EmpresasSeleccionadas = t.translate('LB_EmpresasSeleccionadas','Empresas seleccionadas')/>
<cfset LB_Beneficiario = t.translate('LB_Beneficiario','Beneficiario')/>
<cfset LB_Concepto = t.translate('LB_Concepto','Concepto','/rh/generales.xml')/>
<cfset LB_Banco = t.translate('LB_Banco','Banco','/rh/generales.xml')/>
<cfset LB_CuentaBancaria = t.translate('LB_CuentaBancaria','Cuenta Bancaria')/>
<cfset LB_Monto = t.translate('LB_Monto','Monto','/rh/generales.xml')/>
<cfset LB_CuentaContable = t.translate('LB_CuentaContable','Cuenta Contable')/>
<cfset LB_Transferencia = t.translate('LB_Transferencia','Transferencia')/>
<cfset LB_PagoCheque = t.translate('LB_PagoCheque','Pago por Cheque')/>
<cfset LB_Total = t.translate('LB_Total','Total','/rh/generales.xml')/>
<cfset LB_Autorizaciones = t.translate('LB_Autorizaciones','Autorizaciones')/>
<cfset LB_SueldosAPagar = t.translate('LB_SueldosAPagar','Sueldos a Pagar')/>
<cfset LB_OtrasTransferencias = t.translate('LB_OtrasTransferencias','Otras Transferencias')/>
<cfset LB_GranTotal = t.translate('LB_GranTotal','Gran Total')/>
<cfset LB_TipoDeCambio = t.translate('LB_TipoDeCambio','Tipo de cambio','/rh/generales.xml')/> 
<cfset LB_InformeParaElPeriodo = t.translate('LB_InformeParaElPeriodo','Informe para el periodo','/rh/generales.xml')/>
<cfset LB_InformeAlMesDe = t.translate('LB_InformeAlMesDe','Informe al mes de','/rh/generales.xml')/>
<cfset LB_ElaboradorPor = t.translate('LB_ElaboradorPor','Elaborado por')/>
<cfset LB_PorLaDivisionDeGestionFinanciera = t.translate('LB_PorLaDivisionDeGestionFinanciera','Por La División de Gestión Financiera')/>
<cfset LB_RevisadoPor = t.translate('LB_RevisadoPor','Revisado por')/>
<cfset LB_EncargadoNomina = t.translate('LB_EncargadoNomina','Encargado Nómina')/>
<cfset LB_PorLaDivisionGestionTalHumano = t.translate('LB_PorLaDivisionGestionTalHumano','Por la División de Gestión Talento Humano')/>
<cfset LB_CoordinadorUnidadOperaciones = t.translate('LB_CoordinadorUnidadOperaciones','Coordinador Unidad Operaciones')/>
<cfset LB_Tesoreria = t.translate('LB_Tesoreria','Tesorería')/>
<cfset LB_PorLaSecretariaServiciosCorporativos = t.translate('LB_PorLaSecretariaServiciosCorporativos','Por la Secretaría de Servicios Corporativos')/>
<cfset LB_CoordinadorUnidadTesoreria = t.translate('LB_CoordinadorUnidadTesoreria','Coordinador Unidad Tesorería')/>
<cfset LB_NoExistenRegistrosQueMostrar = t.Translate('LB_NoExistenRegistrosQueMostrar','No existen registros que mostrar','/rh/generales.xml')>

<cfset archivo = "DesgloseDeTransferencia(#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#).xls">

<cf_htmlReportsHeaders irA="IICADesgloseTransferencia.cfm" FileName="#archivo#">

<cfset LvarHTTP = 'http://'>
<cfif isdefined("session.sitio.ssl_todo") and session.sitio.ssl_todo> <cfset LvarHTTP = 'https://'> </cfif>
<link href="<cfoutput>#LvarHTTP##cgi.server_name#<cfif len(trim(cgi.SERVER_PORT))>:#cgi.SERVER_PORT#</cfif></cfoutput>/cfmx/plantillas/IICA/css/reports.css" rel="stylesheet" type="text/css">
<cf_templatecss/>

<style type="text/css">
	.tituloDivisor { padding-top: 1em !important; padding-bottom: 1em !important; border-color: #000 !important;
	border-left: 0 !important; border-right: 0 !important; }

</style>	

<cfinvoke component="rh.Componentes.RH_Funciones" method="DeterminaEmpresasPermiso" returnvariable="EmpresaLista">

<cf_translatedata name="get" tabla="CuentaEmpresarial" col="CEnombre" conexion="asp" returnvariable="LvarCEnombre">
<cfquery name="rsCEmpresa" datasource="asp">
    select #LvarCEnombre# as CEnombre 
    from CuentaEmpresarial 
    where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
</cfquery>

<cfset LB_Corp = rsCEmpresa.CEnombre>
<cfset lvarCols = 6>
<cfset filtro1 = ''>
<cfset filtro2 = "" > 
<cfset lvEmpresasSelect = '' >


<cfset showEmpresa = true>
<cfif isDefined("form.esCorporativo")>
    <cfif form.JtreeListaItem eq 0>
        <cfset form.JtreeListaItem = EmpresaLista>  
    </cfif>
    <cfset showEmpresa = false>
<cfelse>
    <cfset form.JtreeListaItem = session.Ecodigo>       
</cfif>


<cfif isDefined("form.esCorporativo")>
    <cf_translatedata name="get" tabla="Empresas" col="Edescripcion" returnvariable="LvarEdescripcion">
	<cfquery name="rsEmpresa" datasource="#session.dsn#">
	    select #LvarEdescripcion# as Edescripcion 
	    from Empresas 
	    where Ecodigo in(<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.jtreeListaItem#" list="true">)
	</cfquery>

	<cfset rsCont = rsEmpresa.recordcount >
	<cfset vCont = 0 > 

	<cfloop query="rsEmpresa">
		<cfset lvEmpresasSelect &= '#Edescripcion#' >
		<cfset vCont += 1 >
		<cfif vCont lt rsCont>
			<cfset lvEmpresasSelect &= ', ' >
		</cfif>
	</cfloop>
</cfif> 


<cfquery name="rsMeses" datasource="sifcontrol">
	select VSdesc, VSvalor 
	from VSidioma 
	where VSgrupo = 1 and Iid = (select Iid from Idiomas where Icodigo = '#session.idioma#')
</cfquery> 


<cfquery name="rsReporte" datasource="#session.dsn#">
	select coalesce(cp.CPdescripcion,hrcn.RCDescripcion) as RCDescripcion, ba.Bdescripcion, 
		sum(hse.SEliquido) as monto, max(hrcn.RCtc) as tipocambio, min(cp.CPfpago) as mesMin, max(cp.CPfpago) as mesMax
	from #p#RCalculoNomina hrcn
	inner join CalendarioPagos cp
		on hrcn.RCNid = cp.CPid
	inner join #p#SalarioEmpleado hse
		on hrcn.RCNid = hse.RCNid
		inner join DatosEmpleado de
			on hse.DEid = de.DEid	
			inner join Bancos b
				on de.Bid = b.Bid
            left outer join RHExportacionBancos eb
            	on eb.Bid_add=de.Bid
            left outer join Bancos ba
            	on eb.Bid=ba.Bid             
	where hrcn.Ecodigo in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.JtreeListaItem#" list="true">)
	<cfif isdefined("form.TcodigoListNom") and len(trim(form.TcodigoListNom)) GT 0>
		and cp.CPid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TcodigoListNom#" list="true" />) 
	</cfif>	
	group by coalesce(cp.CPdescripcion,hrcn.RCDescripcion), ba.Bdescripcion
	order by coalesce(cp.CPdescripcion,hrcn.RCDescripcion), ba.Bdescripcion
</cfquery>

<cf_translatedata name="get" col="DCdescripcion" tabla="DCargas" returnvariable="LvarDCdescripcion">
<cfquery name="rsReporteTr" datasource="#session.dsn#">
	select tot.RCDescripcion, tot.Bdescripcion, 
		sum(tot.monto) as monto, max(tot.tipocambio) as tipocambio, min(tot.mesMin) as mesMin, max(tot.mesMax) as mesMax
     from (      
           select coalesce(cp.CPdescripcion,hrcn.RCDescripcion) as RCDescripcion, ba.Bdescripcion, 
			hse.SEliquido as monto, hrcn.RCtc as tipocambio, cp.CPfpago as mesMin, cp.CPfpago as mesMax
            from #p#RCalculoNomina hrcn
            inner join CalendarioPagos cp
                on hrcn.RCNid = cp.CPid
            inner join #p#SalarioEmpleado hse
                on hrcn.RCNid = hse.RCNid
                inner join DatosEmpleado de
                    on hse.DEid = de.DEid	
                    inner join Bancos b
                        on de.Bid = b.Bid
                    left outer join RHExportacionBancos eb
                        on eb.Bid_add=de.Bid
                    left outer join Bancos ba
                        on eb.Bid=ba.Bid             
            where hrcn.Ecodigo in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.JtreeListaItem#" list="true">)
            <cfif isdefined("form.TcodigoListNom") and len(trim(form.TcodigoListNom)) GT 0>
                and cp.CPid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TcodigoListNom#" list="true" />) 
            </cfif>	
      ) tot
	group by tot.RCDescripcion, tot.Bdescripcion
	order by tot.RCDescripcion, tot.Bdescripcion
</cfquery>

<cfquery name="rsReporte" dbtype="query">
	select * from rsReporteTr
    where 	Bdescripcion is not null
    		and Bdescripcion <> ''
    order by RCDescripcion, Bdescripcion
</cfquery>

<cfquery name="rsCheque" dbtype="query">
	select * from rsReporteTr
    where 	Bdescripcion is  null
    		or Bdescripcion = ''
    order by RCDescripcion
</cfquery>

<cfquery name="rsDepAdicional" datasource="#session.dsn#">
    select coalesce(cp.CPdescripcion,hrcn.RCDescripcion) as RCDescripcion, 'Depósitos Adicionales' as Bdescripcion , 
        sum(dc.DCvalor) as monto, hrcn.RCtc as tipocambio, cp.CPfpago as mesMin, cp.CPfpago as mesMax
        from #p#RCalculoNomina hrcn
        inner join CalendarioPagos cp
            on hrcn.RCNid = cp.CPid
        inner join #p#DeduccionesCalculo dc
            on hrcn.RCNid = dc.RCNid
        inner join DeduccionesEmpleado dec
            on dec.DEid = dc.DEid	
             and dec.Did = dc.Did	
        inner join RHExportacionDeducciones exd     
            on exd.TDid = dec.TDid  
            and exd.RHEDesliquido = 1 <!---deducciones correspondientes a salario liquido--->              
        where hrcn.Ecodigo in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.JtreeListaItem#" list="true">)
        <cfif isdefined("form.TcodigoListNom") and len(trim(form.TcodigoListNom)) GT 0>
            and cp.CPid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TcodigoListNom#" list="true" />) 
        </cfif>
      group by coalesce(cp.CPdescripcion,hrcn.RCDescripcion),hrcn.RCtc , cp.CPfpago, cp.CPfpago
</cfquery>
	
<cfif rsReporte.recordcount>
	<cfif createDate(year(rsReporte.mesMax), month(rsReporte.mesMax), 1) neq createDate(year(rsReporte.mesMin), month(rsReporte.mesMin), 1) >
		<cfquery dbtype="query" name="rs1">
			select VSdesc 
			from rsMeses 
			where VSvalor = '#month(rsReporte.mesMin)#'
		</cfquery>

		<cfquery dbtype="query" name="rs2">
			select VSdesc 
			from rsMeses 
			where VSvalor = '#month(rsReporte.mesMax)#'
		</cfquery>

		<cfset filtro1 = '#LB_InformeParaElPeriodo# #rs1.VSdesc# #year(rsReporte.mesMin)# - #rs2.VSdesc# #year(rsReporte.mesMax)#'>
	<cfelse>	
		<cfquery dbtype="query" name="rs1">
			select VSdesc 
			from rsMeses 
			where VSvalor = '#month(rsReporte.mesMax)#'
		</cfquery>

		<cfset filtro1 = '#LB_InformeAlMesDe# #rs1.VSdesc# #year(rsReporte.mesMax)#'>
	</cfif>	 

	<cfif not isDefined("form.esCorporativo") and isdefined("form.TcodigoListNom") and listlen(form.TcodigoListNom) eq 1>
		<cfset filtro2 = "#LB_TipoDeCambio#: #rsReporte.tipocambio#"> 
	</cfif>
    <cfif len(lvEmpresasSelect)>
		<cfset filtro3 = "#LB_EmpresasSeleccionadas#: #lvEmpresasSelect#">
    <cfelse>
    	<cfset filtro3 = "">
	</cfif>

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
            filtro1='#filtro1#' 
            filtro2="#filtro2#" 
            filtro3="#filtro3#" 
            showEmpresa="#showEmpresa#" 
            cols="#lvarCols-2#"
            showline="false">
        <cfoutput>#getHTML()#</cfoutput> 
    
	</body>
	</html>
 
<cfelse>     
    <cf_HeadReport 
    	addTitulo1='#LB_Corp#' 
        filtro1='#filtro1#' 
        filtro2="#filtro2#" 
    	filtro3="#filtro3#" 
        showEmpresa="#showEmpresa#" 
        cols="#lvarCols-2#"
        showline="false">
        
    <div align="center" style="margin: 15px 0 15px 0"> --- <b><cfoutput>#LB_NoExistenRegistrosQueMostrar#</cfoutput></b> ---</div>
</cfif>  

 
<cffunction name="getHTML" output="true"> 
	
	<table class="reporte" width="100%">
		<cfoutput>
			<thead style="display: table-header-group">
				<tr>
					<th>#LB_Beneficiario#</th>
					<th>#LB_Concepto#</th>
					<th>#LB_Banco#</th>
					<th>#LB_CuentaBancaria#</th>
					<th>#LB_Monto#</th>
					<th>#LB_CuentaContable#</th>
				</tr>
		    </thead>
	    </cfoutput>	
		<tbody>
			<cfoutput>
				<!--- Transferencia 1 --->
				<tr>
					<td colspan="6" class="tituloDivisor"><u>#LB_Transferencia# 1</u></td>
				</tr>
                
	  			<cfinvoke component="rh.Componentes.RHParametros" method="get" pvalor="150" default="0" returnvariable="cuentaBancaria"/>
				<cfquery datasource="#session.dsn#" name="cuentaBancaria">
					<cfif cuentaBancaria neq 0>
						select Cformato as valor from CContables where Ccuenta = #cuentaBancaria#
					<cfelse>
						select '' as valor from dual	
					</cfif>
				</cfquery>

				<cfset total = 0 >
				<cfset TotalSueldosPorPagar = 0 >
				<cfset TotalOtrasTransferencias = 0 >

				<cfloop query="rsReporte">
					<tr>
						<td nowrap="nowrap">Funcionarios</td>
						<td nowrap="nowrap">#RCDescripcion#</td>
						<td nowrap="nowrap">#Bdescripcion#</td>
						<td nowrap="nowrap">Cuentas Varias</td>
						<td nowrap="nowrap" align="right"><cf_locale name="number" value="#monto#"/></td>
						<td nowrap="nowrap">#cuentaBancaria.valor#</td>
					</tr>
					<cfset total += monto >
				</cfloop>
                <cfset monto=0>
				<cfloop query="rsDepAdicional">
					<tr>
						<td nowrap="nowrap">Funcionarios</td>
						<td nowrap="nowrap">#RCDescripcion#</td>
						<td nowrap="nowrap">#Bdescripcion#</td>
						<td nowrap="nowrap">Cuentas Varias</td>
						<td nowrap="nowrap" align="right"><cf_locale name="number" value="#monto#"/></td>
						<td nowrap="nowrap">#cuentaBancaria.valor#</td>
					</tr>
					<cfset total += monto >
				</cfloop>
				<tr>
					<td colspan="4"><b><font style="text-transform: uppercase;">#LB_Total#</font></b></td>
					<td align="right"><b><cf_locale name="number" value="#total#"/></b></td>
				</tr>
				<cfset TotalSueldosPorPagar += total >
				
				<tr>
					<td colspan="6" class="tituloDivisor"><u>#LB_PagoCheque#</u></td>
				</tr>
                
				<cfset total=0>
				<cfloop query="rsCheque">
					<tr>
						<td nowrap="nowrap">Funcionarios</td>
						<td nowrap="nowrap">#RCDescripcion#</td>
						<td nowrap="nowrap">#Bdescripcion#</td>
						<td nowrap="nowrap">Cuentas Varias</td>
						<td nowrap="nowrap" align="right"><cf_locale name="number" value="#monto#"/></td>
						<td nowrap="nowrap">#cuentaBancaria.valor#</td>
					</tr>
					<cfset total += monto >
				</cfloop>
				<tr>
					<td colspan="4"><b><font style="text-transform: uppercase;">#LB_Total#</font></b></td>
					<td align="right"><b><cf_locale name="number" value="#total#"/></b></td>
				</tr>
				<cfset TotalSueldosPorPagar += total >
            
            	<!--- Autorizaciones --->
				<cf_dbfunction name="op_concat" returnvariable="concat">
				<cfquery datasource="#session.dsn#" name="rsReporte">
					select de.DEnombre #concat#' '#concat# de.DEapellido1 #concat#' '#concat# de.DEapellido2 as nombre,
					coalesce(cp.CPdescripcion,hrcn.RCDescripcion) as RCDescripcion,
					case when de.DEtipocuenta = 1 then <!---- por cuenta--->
						de.DEcuenta
					when de.DEtipocuenta = 2 then <!---- por Cuenta  Cliente---->
						de.CBcc
					else <!--- en el caso de ninguno --->
						coalesce(de.DEcuenta,de.CBcc,'')
					end as cuenta,
					sum(hse.SEliquido) as monto
					from #p#RCalculoNomina hrcn
					inner join CalendarioPagos cp
	    				on hrcn.RCNid = cp.CPid
					inner join #p#SalarioEmpleado hse
						on hrcn.RCNid = hse.RCNid
						inner join DatosEmpleado de
							on hse.DEid = de.DEid
					where hrcn.Ecodigo in (<cfif not isDefined("form.esCorporativo")>
					                            <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
					                        <cfelse>    
					                            <cfif form.jtreeListaItem neq 0 >
					                                <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.jtreeListaItem#" list="true">
					                            <cfelse>
					                                select Ecodigo from Empresas where
					                                cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
					                            </cfif>
					                        </cfif>
					                    ) 
					<cfif isdefined("form.TcodigoListNom") and len(trim(form.TcodigoListNom)) GT 0>
						and cp.CPid in (<cfqueryparam  cfsqltype="cf_sql_numeric" value="#form.TcodigoListNom#" list="true" />) 
					</cfif>		
						and de.Bid is null
					group by de.DEnombre,de.DEapellido1,de.DEapellido2,coalesce(cp.CPdescripcion,hrcn.RCDescripcion),de.DEtipocuenta,de.DEcuenta,de.CBcc
					order by de.DEnombre,de.DEapellido1,de.DEapellido2,coalesce(cp.CPdescripcion,hrcn.RCDescripcion),de.DEtipocuenta
				</cfquery>

				<tr>
					<td colspan="6" class="tituloDivisor"><u>#LB_Autorizaciones#</u></td>
				</tr>

				<cfset total = 0 >
				<cfloop query="rsReporte">
					<tr>
						<td nowrap="nowrap">#nombre#</td>
						<td nowrap="nowrap">#RCDescripcion#</td>
						<td nowrap="nowrap">Autorizaciones</td>
						<td nowrap="nowrap">#cuenta#</td>
						<td nowrap="nowrap" align="right"><cf_locale name="number" value="#monto#"/></td>
						<td nowrap="nowrap">#cuentaBancaria.valor#</td>
					</tr>
					<cfset total += monto >
				</cfloop>

				<tr>
					<td colspan="4"><b><font style="text-transform: uppercase;">#LB_Total#</font></b></td>
					<td align="right"><b><cf_locale name="number" value="#total#"/></b></td>
					<td></td>
				</tr>
				<cfset TotalSueldosPorPagar += total >
				<tr>
					<td colspan="4" class="tituloDivisor">
						<b><font style="text-transform: uppercase;">#LB_SueldosAPagar#</font></b>
					</td>
					<td align="right" class="tituloDivisor"><b><cf_locale name="number" value="#TotalSueldosPorPagar#"/></b></td>
					<td class="tituloDivisor"></td>
				</tr>
                
	    		<!--- Transferencia 3: Cargas --->
                <cf_translatedata name="get" col="DCdescripcion" tabla="DCargas" returnvariable="LvarDCdescripcion">
                <cfquery name="rsReporte" datasource="#session.dsn#">
					select coalesce(sn.SNidentificacion,dc.DCcodigo) #concat#' - '#concat# coalesce(sn.SNnombre,#LvarDCdescripcion#)as carga, cc.Cformato, sum(case when hcc.CCvalorpat > 0 then hcc.CCvalorpat else hcc.CCvaloremp end) as monto 
					from #p#RCalculoNomina hrcn
					inner join CalendarioPagos cp
	    				on hrcn.RCNid = cp.CPid
					inner join #p#CargasCalculo hcc
						on hrcn.RCNid = hcc.RCNid
						inner join DCargas dc
							on hcc.DClinea = dc.DClinea	
						left join SNegocios sn
							inner join CContables cc
								on cc.Ccuenta = sn.SNcuentacxp
							on sn.SNcodigo = dc.SNcodigo
							and sn.Ecodigo = hrcn.Ecodigo
                   where hrcn.Ecodigo in (<cfif not isDefined("form.esCorporativo")>
					                            <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
					                        <cfelse>    
					                            <cfif form.jtreeListaItem neq 0 >
					                                <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.jtreeListaItem#" list="true">
					                            <cfelse>
					                                select Ecodigo from Empresas where
					                                cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
					                            </cfif>
					                        </cfif>
					                    )
						and dc.DCtipoc = 1  <!--- es socio de negocios --->
					<cfif isdefined("form.TcodigoListNom") and len(trim(form.TcodigoListNom)) GT 0 >
						and cp.CPid in (<cfqueryparam  cfsqltype="cf_sql_numeric" value="#form.TcodigoListNom#" list="true" />) 
					</cfif>	
					<cfif isdefined("form.TcodigoListCg") and len(trim(form.TcodigoListCg)) GT 0 >
						and dc.DClinea in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TcodigoListCg#" list="true" />)
					</cfif>		
					group by coalesce(sn.SNidentificacion,dc.DCcodigo),coalesce(sn.SNnombre,#LvarDCdescripcion#),cc.Cformato
					order by coalesce(sn.SNidentificacion,dc.DCcodigo),coalesce(sn.SNnombre,#LvarDCdescripcion#),cc.Cformato 
				</cfquery>
               
				<tr>
					<td colspan="6"  class="tituloDivisor"><u>#LB_Transferencia# 3</u></td>
				</tr>

				<cfset total = 0 >
				<cfloop query="rsReporte">
					<tr>
						<td nowrap="nowrap">#carga#</td>
						<td nowrap="nowrap">Contribución</td>
						<td nowrap="nowrap"></td>
						<td nowrap="nowrap"></td>
						<td nowrap="nowrap" align="right"><cf_locale name="number" value="#monto#"/></td>
						<td nowrap="nowrap">#Cformato#</td>
					</tr>
					<cfset total += monto >
				</cfloop>
				<cfset TotalOtrasTransferencias += total >

				<tr>
					<td colspan="4"><b><font style="text-transform: uppercase;">#LB_Total#</font></b></td>
					<td align="right"><b><cf_locale name="number" value="#total#"/></b></td>
				</tr>

	    		<!--- Transferencia 4: Deducciones --->
				<cfquery datasource="#session.dsn#" name="rsReporte">
					select td.TDcodigo #concat#' - '#concat# td.TDdescripcion as deduccion, coalesce(cp.CPdescripcion,hrcn.RCDescripcion) as RCDescripcion, cc.Cformato, 
					sum(hde.DCvalor) as monto
					from #p#RCalculoNomina hrcn
					inner join CalendarioPagos cp
	    				on hrcn.RCNid = cp.CPid
					inner join #p#DeduccionesCalculo hde
						on hrcn.RCNid = hde.RCNid
						inner join DeduccionesEmpleado de
							on hde.Did = de.Did	
							inner join TDeduccion td
								on de.TDid = td.TDid	
								left join SNegocios sn
									inner join CContables cc
										on cc.Ccuenta = sn.SNcuentacxp
									on sn.SNcodigo = td.SNcodigo
									and sn.Ecodigo = td.Ecodigo
                              
					where hrcn.Ecodigo in (<cfif not isDefined("form.esCorporativo")>
					                            <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
					                        <cfelse>    
					                            <cfif form.jtreeListaItem neq 0 >
					                                <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.jtreeListaItem#" list="true">
					                            <cfelse>
					                                select Ecodigo from Empresas where
					                                cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
					                            </cfif>
					                        </cfif>
					                    )
					<cfif isdefined("form.TcodigoListNom") and len(trim(form.TcodigoListNom)) GT 0>
						and cp.CPid in (<cfqueryparam  cfsqltype="cf_sql_numeric" value="#form.TcodigoListNom#" list="true" />) 
					</cfif>	
					<cfif isdefined("form.TcodigoListDD") and len(trim(form.TcodigoListDD)) GT 0>
						and td.TDid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TcodigoListDD#" list="true" />) 
					</cfif>
                    
                    <!--- Excluye las Deducciones de Bancos --->
                   	and td.TDid not in (select distinct b.TDid
                                from RHExportacionDeducciones a
                                    inner join TDeduccion b
                                        on a.TDid = b.TDid
                                    inner join <cf_dbdatabase table="EImportador" datasource="sifcontrol"> ei
                                        on a.EIid = ei.EIid
                                     inner join Empresas c
                                        on c.Ecodigo=b.Ecodigo
                                where a.Ecodigo = hrcn.Ecodigo
                                and a.RHEDesliquido = 1 <!---deducciones correspondientes a salario liquido--->              
                             )
                    
					group by td.TDcodigo,td.TDdescripcion,coalesce(cp.CPdescripcion,hrcn.RCDescripcion),cc.Cformato
					order by td.TDcodigo,td.TDdescripcion,coalesce(cp.CPdescripcion,hrcn.RCDescripcion),cc.Cformato
				</cfquery>

				<tr>
					<td colspan="6"  class="tituloDivisor"><u>#LB_Transferencia# 4</u></td>
				</tr>

				<cfset total = 0 >
				<cfloop query="rsReporte">
					<tr>
						<td nowrap="nowrap">#deduccion#</td>
						<td nowrap="nowrap">Contribución</td>
						<td nowrap="nowrap"></td>
						<td nowrap="nowrap"></td>
						<td nowrap="nowrap" align="right"><cf_locale name="number" value="#monto#"/></td>
						<td nowrap="nowrap">#Cformato#</td>
					</tr>
					<cfset total += monto >
				</cfloop>
				<cfset TotalOtrasTransferencias += total >

				<tr>
					<td colspan="4"><b><font style="text-transform: uppercase;">#LB_Total#</font></b></td>
					<td align="right"><b><cf_locale name="number" value="#total#"/></b></td>
				</tr>
				<tr>
					<td colspan="4" class="tituloDivisor">
						<b><font style="text-transform: uppercase;">#LB_OtrasTransferencias#</font></b>
					</td>
					<td class="tituloDivisor" align="right">
						<b><cf_locale name="number" value="#TotalOtrasTransferencias#"/></b>
					</td>
				</tr>
				<tr>
					<td colspan="4" class="tituloDivisor">
						<b><font style="text-transform: uppercase;">#LB_GranTotal#</font></b>
					</td>
					<td class="tituloDivisor" align="right">
						<b><cf_locale name="number" value="#TotalSueldosPorPagar+TotalOtrasTransferencias#"/></b>
					</td>
					<td class="tituloDivisor"></td>
				</tr>
			</cfoutput>
		</tbody>
	</table>
	
	<table width="100%" style="font-family:Verdana, Geneva, sans-serif; font-size:10px">
		<tr><td colspan="4"><br /><br /><br /><br /><br /><br /></td></tr>
	    <cfoutput>
	    	<tr>
		      	<td>#LB_ElaboradorPor#:</td>
		      	<td>______________________________________</td>
				<td>#LB_PorLaDivisionGestionTalHumano#:</td>
		      	<td>______________________________________</td>				
            </tr>
            <tr>
		      	<td></td>
		      	<td>#LB_EncargadoNomina#</td>
		      	<td></td>
		      	<td></td>
	    	</tr>
	    	<tr><td colspan="4"><br /><br /><br /><br /><br /><br /></td></tr>
	    	<tr>
		      	<td>#LB_RevisadoPor#:</td>
		      	<td>______________________________________</td>

                <td>#LB_PorLaDivisionDeGestionFinanciera#:</td>
		      	<td>______________________________________</td>	
	    	</tr>
	    	<tr>
		      	<td></td>
		      	<td>#LB_CoordinadorUnidadOperaciones#</td>
		      	<td></td>
		      	<td></td>
	    	</tr>
			<tr><td colspan="4"><br /><br /><br /><br /><br /><br /></td></tr>
	    	<tr>
		      	<td>#LB_Tesoreria#:</td>
		      	<td>______________________________________</td>

                <td>#LB_PorLaSecretariaServiciosCorporativos#:</td>
		      	<td>______________________________________</td>
	    	</tr>
	    	<tr>
		      	<td></td>
		      	<td>#LB_CoordinadorUnidadTesoreria#</td>
		      	<td></td>
		      	<td></td>
	    	</tr>
	    </cfoutput>	
	    <tr><td colspan="4"><br><br></td></tr>
	</table>
</cffunction> 
