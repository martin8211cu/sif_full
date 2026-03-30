<cfif isdefined("Exportar")>
    <cfset form.btnDownload = true> 
</cfif>

<cfset t = createObject("component","sif.Componentes.Translate")> 

<!--- Etiquetas de traduccion --->
<cfset LB_SalarioBasico = t.translate('LB_SalarioBasico','Salario Básico','/rh/generales.xml')/>
<cfset LB_Concepto = t.translate('LB_Concepto','Concepto','/rh/generales.xml')/>
<cfset LB_Colones = t.translate('LB_Colones','Colones','/rh/generales.xml')/>
<cfset LB_Monto = t.translate('LB_Monto','Monto','/rh/generales.xml')/>
<cfset LB_Dolares = t.translate('LB_Dolares','Dólares','/rh/generales.xml')/>
<cfset LB_Ingresos = t.translate('LB_Ingresos','Ingresos','/rh/generales.xml')/>
<cfset LB_Prestaciones = t.translate('LB_Prestaciones','Prestaciones','/rh/nomina/consultas/ReporteNominasResumen-sql.xml')/>
<cfset LB_Deducciones = t.translate('LB_Deducciones','Deducciones','/rh/generales.xml')/>
<cfset LB_Transferencias = t.translate('LB_Transferencias','Transferencias','/rh/nomina/consultas/ReporteNominasResumen-sql.xml')/>
<cfset LB_DepCuentaCorriente = t.translate('LB_DepCuentaCorriente','Depósito en Cuenta Corriente','/rh/generales.xml')/>
<cfset LB_DepCuentaAhorro = t.translate('LB_DepCuentaAhorro','Depósito en Cuenta Ahorro','/rh/generales.xml')/>
<cfset LB_Cheques = t.translate('LB_Cheques','Cheques','/rh/generales.xml')/>
<cfset LB_Total = t.translate('LB_Total','Total','/rh/generales.xml')>
<cfset LB_subTotal = t.translate('LB_subTotal','Subtotal','/rh/generales.xml')>
<cfset LB_NoExistenRegistrosQueMostrar = t.Translate('LB_NoExistenRegistrosQueMostrar','No existen registros que mostrar','/rh/generales.xml')>
<cfset LB_Renta = t.translate('LB_Renta','Renta','/rh/nomina/consultas/ReporteNominasResumen-sql.xml')/>
<cfset LB_RetencionRenta = t.translate('LB_RetencionRenta','Retención Renta','/rh/nomina/consultas/ReporteNominasResumen-sql.xml')/>

<cfset archivo = "ReporteNominasResumen(#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#).xls">

<cf_htmlReportsHeaders filename="#archivo#" irA="ReporteNominasResumen.cfm">
<cf_templatecss>    

<!---- mostrar los montos segun tipo de cambio de dolar en los reportes----->
<cfinvoke component="rh.Componentes.RHParametros" method="get" pvalor="2696" default="0" returnvariable="LvarMostrarColDolar">

<cfinvoke component="rh.Componentes.RH_Funciones" method="DeterminaEmpresasPermiso" returnvariable="EmpresaLista">

<cfif isdefined("form.sPeriodo") and len(trim(form.sPeriodo))>
    <cfset lvarYer = form.sPeriodo > 
<cfelse>
    <cfset lvarYer = year(now()) >
</cfif>    

<cfif isdefined("form.sMes") and len(trim(form.sMes))>
    <cfset lvarMes = form.sMes > 
<cfelse>
    <cfset lvarMes = month(now()) >
</cfif>    

<cfset lvarTipoCalendarPG = '' >
<cfif isdefined("form.chkNormal")>
    <cfset lvarTipoCalendarPG &= '0' > 
</cfif>  
<cfif isdefined("form.chkEspecial")>
    <cfif len(trim(lvarTipoCalendarPG))><cfset lvarTipoCalendarPG &= ','></cfif>
    <cfset lvarTipoCalendarPG &= '1' > 
</cfif> 
<cfif isdefined("form.chkAnticipo")>
    <cfif len(trim(lvarTipoCalendarPG))><cfset lvarTipoCalendarPG &= ','></cfif>
    <cfset lvarTipoCalendarPG &= '2' > 
</cfif> 
<cfif isdefined("form.chkLiquidacion")>
    <cfif len(trim(lvarTipoCalendarPG))><cfset lvarTipoCalendarPG &= ','></cfif>
    <cfset lvarTipoCalendarPG &= '5' > 
</cfif>  

<cfif not len(trim(lvarTipoCalendarPG)) >
    <cfset lvarTipoCalendarPG = '0' >
</cfif>

<cfset showEmpresa = true>
<cfif isDefined("form.esCorporativo")>
    <cfif form.JtreeListaItem eq 0>
        <cfset form.JtreeListaItem = EmpresaLista>  
    </cfif>
    <cfset showEmpresa = false>
<cfelse>
    <cfset form.JtreeListaItem = session.Ecodigo>       
</cfif>

<cfset pre = ''>
<cfif isdefined("form.chk_NominaAplicada")>
    <cfset pre = 'H'>
</cfif>

<cfif isdefined("form.radRep") and len(trim(form.radRep))>
    <cfset vTipoSelect = form.radRep >
<cfelse>
    <cfset vTipoSelect = 1 >   
</cfif>    


<!--- Se realiza al seleccionar todas las opciones(1) o Ingresos(2), genera los montos de los salarios y las incidencias --->
<cfif vTipoSelect eq 1 or vTipoSelect eq 2 > 
    <!--- Genera los Salarios Brutos agrupados por nomina --->
    <cfquery name="rsSalario" datasource="#session.dsn#">
        select rcn.RCNid, '#LB_SalarioBasico#' as SEdescripcion, sum(se.SEsalariobruto) as SEsalariobruto, 
        sum(case when coalesce(rcn.RCtc,1) = 1 then 0 else se.SEsalariobruto/rcn.RCtc end) as SEsalariobrutoDolar   
        from #pre#RCalculoNomina rcn  
        inner join #pre#SalarioEmpleado se
            on se.RCNid = rcn.RCNid
        where 
            rcn.Ecodigo in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.JtreeListaItem#" list="true">)
            and rcn.RCNid in (select CPid 
                            from CalendarioPagos
                            where CPperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarYer#">
                            and CPmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarMes#"> 
                            and CPtipo in(<cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarTipoCalendarPG#" list="true">)
                            <cfif isdefined("form.ListaTipoNomina") and len(trim(form.ListaTipoNomina)) >
                            and Tcodigo in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ListaTipoNomina#" list="true">)
                            </cfif>
                            and Ecodigo in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.JtreeListaItem#" list="true">)
                            ) 
        group by rcn.RCNid 
    </cfquery>

    <!--- Genera los salarios brutos totales de todas las nominas relacionadas --->
    <cfquery name="rsSalario" dbtype="query">
        select SEdescripcion, sum(SEsalariobruto) as SEsalariobruto, sum(SEsalariobrutoDolar) as SEsalariobrutoDolar
        from rsSalario
        group by SEdescripcion 
    </cfquery>

    <!--- Genera los montos de las Incidencias agrupados por nomina --->
    <cf_translatedata name="get" tabla="CIncidentes" col="ci.CIdescripcion" returnvariable="LvarCIdescripcion"/>
    <cfquery name="rsIncidencias" datasource="#session.dsn#">
        select rcn.RCNid, ic.CIid, #LvarCIdescripcion# as CIdescripcion, sum(ic.ICmontores) as ICmontores, 
        sum(case when coalesce(rcn.RCtc,1) = 1 then 0 else ic.ICmontores/rcn.RCtc end) as ICmontoresDolar
        from #pre#RCalculoNomina rcn
        inner join #pre#IncidenciasCalculo ic
            on ic.RCNid = rcn.RCNid
            inner join CIncidentes ci
                on ci.CIid = ic.CIid
        where 
            rcn.Ecodigo in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.JtreeListaItem#" list="true">)
            and rcn.RCNid in (select CPid 
                            from CalendarioPagos
                            where CPperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarYer#">
                            and CPmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarMes#"> 
                            and CPtipo in(<cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarTipoCalendarPG#" list="true">)
                            <cfif isdefined("form.ListaTipoNomina") and len(trim(form.ListaTipoNomina)) >
                            and Tcodigo in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ListaTipoNomina#" list="true">)
                            </cfif>
                            and Ecodigo in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.JtreeListaItem#" list="true">)
                            ) 
        group by rcn.RCNid, ic.CIid, #LvarCIdescripcion# 
	</cfquery>
    
    <!--- Genera los montos totales de las Incidencias de todas las nominas relacionadas --->
    <cfquery name="rsIncidencias" dbtype="query">
        select CIdescripcion, sum(ICmontores) as ICmontores, sum(ICmontoresDolar) as ICmontoresDolar
        from rsIncidencias
        group by CIdescripcion 
    </cfquery> 
</cfif> 

<!--- Se realiza al seleccionar todas las opciones(1) o Prestaciones(3), genera los montos de las cargas empleados y patron --->
<cfif vTipoSelect eq 1 or vTipoSelect eq 3 >
    <!--- Genera las cargas agrupadas por nomina --->
    <cf_translatedata name="get" tabla="DCargas" col="dc.DCdescripcion" returnvariable="LvarDCdescripcion"/>
    <cfquery name="rsCargas" datasource="#session.dsn#">
        select rcn.RCNid, cc.DClinea, #LvarDCdescripcion# as DCdescripcion, sum(cc.CCvaloremp) as CCvaloremp,
        sum(case when coalesce(rcn.RCtc,1) = 1 then 0 else cc.CCvaloremp/rcn.RCtc end) as CCvalorempDolares, 
        sum(cc.CCvalorpat) as CCvalorpat, 
        sum(case when coalesce(rcn.RCtc,1) = 1 then 0 else cc.CCvalorpat/rcn.RCtc end) as CCvalorpatDolares
        from #pre#RCalculoNomina rcn
        inner join #pre#CargasCalculo cc
            on cc.RCNid = rcn.RCNid
            inner join DCargas dc
                on dc.DClinea = cc.DClinea
        where
            rcn.Ecodigo in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.JtreeListaItem#" list="true">)
            and rcn.RCNid in (select CPid 
                            from CalendarioPagos
                            where CPperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarYer#">
                            and CPmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarMes#"> 
                            and CPtipo in(<cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarTipoCalendarPG#" list="true">)
                            <cfif isdefined("form.ListaTipoNomina") and len(trim(form.ListaTipoNomina)) >
                            and Tcodigo in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ListaTipoNomina#" list="true">)
                            </cfif>
                            and Ecodigo in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.JtreeListaItem#" list="true">)
                                )
            <!---and (cc.CCvalorpat > 0 or cc.CCvaloremp > 0)--->
        group by rcn.RCNid, cc.DClinea, #LvarDCdescripcion#
    </cfquery> 
     
    <!--- Genera los montos totales de las cargas de todas las nominas relacionadas --->
    <cfquery name="rsCargas" dbtype="query">
        select DCdescripcion, (sum(CCvaloremp) + sum(CCvalorpat)) as CCvalor, 
        (sum(CCvalorempDolares) + sum(CCvalorpatDolares)) as CCvalorDolares
        from rsCargas
        group by  DCdescripcion 
    </cfquery>
</cfif>

<!--- Se realiza al seleccionar todas las opciones(1) o Deducciones(4), genera los montos de las deducciones --->
<cfif vTipoSelect eq 1 or vTipoSelect eq 4 >
    <!--- Genera las deducciones agrupadas por nomina --->
    <cf_translatedata name="get" tabla="TDeduccion" col="td.TDdescripcion" returnvariable="LvarTDdescripcion"/>
    <cfquery name="rsDeducciones" datasource="#session.dsn#">
        select rcn.RCNid, de.TDid, #LvarTDdescripcion# as TDdescripcion, sum(dc.DCvalor) as DCvalor, 
        sum(case when coalesce(rcn.RCtc,1) = 1 then 0 else dc.DCvalor/rcn.RCtc end) as DCvalorDolares
        from #pre#RCalculoNomina rcn
        inner join #pre#DeduccionesCalculo dc
            on dc.RCNid = rcn.RCNid
            inner join DeduccionesEmpleado de
                on de.Did = dc.Did   
                inner join TDeduccion td
                    on td.TDid = de.TDid
        where 
            rcn.Ecodigo in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.JtreeListaItem#" list="true">)
            and rcn.RCNid in (select CPid 
                            from CalendarioPagos
                            where CPperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarYer#">
                            and CPmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarMes#"> 
                            and CPtipo in(<cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarTipoCalendarPG#" list="true">)
                            <cfif isdefined("form.ListaTipoNomina") and len(trim(form.ListaTipoNomina)) >
                            and Tcodigo in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ListaTipoNomina#" list="true">)
                            </cfif>
                            and Ecodigo in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.JtreeListaItem#" list="true">)
                                )
           and td.TDid not in (select distinct b.TDid
                                from RHExportacionDeducciones a
                                    inner join TDeduccion b
                                        on a.TDid = b.TDid
                                    inner join <cf_dbdatabase table="EImportador" datasource="sifcontrol"> ei
                                        on a.EIid = ei.EIid
                                     inner join Empresas c
                                        on c.Ecodigo=b.Ecodigo
                                where a.Ecodigo in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.JtreeListaItem#" list="true">) 
                             )
        group by rcn.RCNid, de.TDid, #LvarTDdescripcion#
    </cfquery>
    
    <!--- Genera los montos totales de las deducciones de todas las nominas relacionadas --->
    <cfquery name="rsDeducciones" dbtype="query">
        select TDdescripcion, sum(DCvalor) as DCvalor, sum(DCvalorDolares) as DCvalorDolares
        from rsDeducciones
        group by TDdescripcion
    </cfquery> 
</cfif>

<!--- Se realiza al seleccionar todas las opciones(1), genera los montos de las transferencias --->
<cfif vTipoSelect eq 1 >
    <!--- Genera total de transferencias x tipo de cuenta y cheques agrupadas por nomina --->
    <cfquery name="rsTransferencias" datasource="#session.dsn#">
        select rcn.RCNid
            , sum(
                case when de.CBTcodigo = 0 
                    and de.Bid is not null 
                    and  ((de.CBcc is not null and  rtrim(ltrim(de.CBcc)) <> '0')
                        or (de.DEcuenta is not null and  rtrim(ltrim(de.DEcuenta)) <> '0'))
                    then hse.SEliquido else 0 end
                ) as depCtaCorriente,

            sum(case when de.CBTcodigo = 0 and de.Bid is not null and coalesce(rcn.RCtc,1) > 1 then 
                hse.SEliquido/rcn.RCtc else 0 end) as depCtaCorrienteDolar,

            sum(
                case when de.CBTcodigo = 1 
                    and de.Bid is not null 
                    and  (de.CBcc is not null and rtrim(ltrim(de.CBcc)) <> '0' 
                            or (de.DEcuenta is not null and  rtrim(ltrim(de.DEcuenta)) <> '0')
                            )
                    then hse.SEliquido else 0 end
                ) as depCtaAhorro,

            sum(case when de.CBTcodigo = 1 and de.Bid is not null and coalesce(rcn.RCtc,1) > 1 then 
                hse.SEliquido/rcn.RCtc else 0 end) as depCtaAhorroDolar,

            sum(case when (de.Bid is null)  or (( de.DEcuenta is null or rtrim(ltrim(de.DEcuenta)) = '0') and (de.CBcc is null or rtrim(ltrim(de.CBcc)) = '0')) then hse.SEliquido else 0 end) as cheques,

            sum(case when de.Bid is null and coalesce(rcn.RCtc,1) > 1 then hse.SEliquido/rcn.RCtc else 0 end) as chequesDolar,

            sum(hse.SERentaT+hse.SERentaR) as Renta
            
        from DatosEmpleado de
        inner join #pre#SalarioEmpleado hse
            on de.DEid = hse.DEid   
            inner join #pre#RCalculoNomina rcn
                on hse.RCNid = rcn.RCNid
        where 
            rcn.Ecodigo in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.JtreeListaItem#" list="true">)
            and rcn.RCNid in (  select CPid 
                            from CalendarioPagos
                            where CPperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarYer#">
                            and CPmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarMes#"> 
                            and CPtipo in(<cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarTipoCalendarPG#" list="true">)
                            <cfif isdefined("form.ListaTipoNomina") and len(trim(form.ListaTipoNomina)) >
                            and Tcodigo in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ListaTipoNomina#" list="true">)
                            </cfif>
                            and Ecodigo in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.JtreeListaItem#" list="true">)
                        ) 
            <!---and de.CBTcodigo in(0,1)--->
        group by rcn.RCNid
    </cfquery> 

    
    <!--- Genera deducciones agrupadas por nomina de Depósitos Adicionales--->
    <cf_translatedata name="get" tabla="TDeduccion" col="td.TDdescripcion" returnvariable="LvarTDdescripcion"/>
    <cfquery name="rsDeduccionesDepositos" datasource="#session.dsn#">
        select rcn.RCNid, de.TDid, #LvarTDdescripcion# as TDdescripcion, sum(dc.DCvalor) as DCvalor, 
        sum(case when coalesce(rcn.RCtc,1) = 1 then 0 else dc.DCvalor/rcn.RCtc end) as DCvalorDolares
        from #pre#RCalculoNomina rcn
        inner join #pre#DeduccionesCalculo dc
            on dc.RCNid = rcn.RCNid
            inner join DeduccionesEmpleado de
                on de.Did = dc.Did   
                inner join TDeduccion td
                    on td.TDid = de.TDid
        where 
            rcn.Ecodigo in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.JtreeListaItem#" list="true">)
            and rcn.RCNid in (
            			select CPid 
                            from CalendarioPagos
                            where CPperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarYer#">
                            and CPmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarMes#"> 
                            and CPtipo in(<cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarTipoCalendarPG#" list="true">)
                            <cfif isdefined("form.ListaTipoNomina") and len(trim(form.ListaTipoNomina)) >
                            and Tcodigo in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ListaTipoNomina#" list="true">)
                            </cfif>
                            and Ecodigo in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.JtreeListaItem#" list="true">)
                         )
        	and td.TDid in (select distinct b.TDid
                                from RHExportacionDeducciones a
                                    inner join TDeduccion b
                                        on a.TDid = b.TDid
                                    inner join <cf_dbdatabase table="EImportador" datasource="sifcontrol"> ei
                                        on a.EIid = ei.EIid
                                     inner join Empresas c
                                        on c.Ecodigo=b.Ecodigo
                                where a.Ecodigo in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.JtreeListaItem#" list="true">) 
                             )
        group by rcn.RCNid, de.TDid, #LvarTDdescripcion#
    </cfquery>
    <!--- Genera los montos totales de las deducciones de todas las nominas relacionadas --->
    <cfquery name="rsDeduccionesDepositos" dbtype="query">
        select TDdescripcion, sum(DCvalor) as DCvalor, sum(DCvalorDolares) as DCvalorDolares
        from rsDeduccionesDepositos
        group by  TDdescripcion
    </cfquery> 

    <!--- Genera total de transferencias de todas las nominas relacionadas --->
    <cfquery name="rsTransferencias" dbtype="query">
        select sum(depCtaCorriente) as depCtaCorriente, sum(depCtaCorrienteDolar) as depCtaCorrienteDolar,
        sum(depCtaAhorro) as depCtaAhorro, sum(depCtaAhorroDolar) as depCtaAhorroDolar, sum(cheques) as cheques,
        sum(chequesDolar) as chequesDolar,
        sum(Renta) as Renta
        from rsTransferencias
    </cfquery>
</cfif>

<cfif not isdefined("Exportar") or not isdefined("Consultar")> 
    <cfset Consultar = true>
</cfif> 

<cf_translatedata name="get" tabla="CuentaEmpresarial" col="CEnombre"  conexion="asp" returnvariable="LvarCEnombre">
<cfquery datasource="asp" name="rsCEmpresa">
    select #LvarCEnombre# as CEnombre 
    from CuentaEmpresarial 
    where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
</cfquery>

<cfset LB_Corp = rsCEmpresa.CEnombre>
<cfif LvarMostrarColDolar>
	<cfset lvarCols = 3>
<cfelse>
	<cfset lvarCols = 2>
</cfif>

<cfset rsFiltroEncab = getFiltroEncab() >
<cfset filtro1 = "" > 

<cfloop query="rsFiltroEncab">
    <cfif RCtc neq 1 >
        <cfset vTC = "(TC: #RCtc#)">
    <cfelse>
        <cfset vTC = "" >   
    </cfif>
    <cfset filtro1 &= '#Edescripcion# - #CPcodigo# - #Tcodigo# - #Tdescripcion# - #CPdescripcion# #vTC#<br/>'>
</cfloop>


<cfif vTipoSelect eq 1 > <!--- Todas las opciones: Ingresos, Prestaciones, Deducciones y Transferencias ---> 
    <cfif not rsSalario.recordcount gt 0 and not rsIncidencias.recordcount gt 0 and not rsCargas.recordcount gt 0 
    and not rsDeducciones.recordcount gt 0 and not rsTransferencias.recordcount gt 0 >
        <cfset vDataReport = false >
    <cfelse>
        <cfset vDataReport = true >    
    </cfif>
<cfelseif vTipoSelect eq 2 > <!--- Ingresos(2) --->   
    <cfif not rsSalario.recordcount gt 0 and not rsIncidencias.recordcount gt 0 >
        <cfset vDataReport = false >
    <cfelse>
        <cfset vDataReport = true >    
    </cfif>
<cfelseif vTipoSelect eq 3 > <!--- Prestaciones(3) ---> 
    <cfif not rsCargas.recordcount gt 0>
        <cfset vDataReport = false >
    <cfelse>
        <cfset vDataReport = true >    
    </cfif>
<cfelse> <!--- Deducciones(4) ---> 
    <cfif not rsDeducciones.recordcount gt 0 >
        <cfset vDataReport = false >
    <cfelse>
        <cfset vDataReport = true >    
    </cfif>
</cfif>

<cfif vDataReport>
    <cfif isdefined("Exportar") or isdefined("Consultar")>     
       <table width="100%" cellpadding="0" cellspacing="0"><tr><td>
        <cf_HeadReport 
   			addTitulo1='#LB_Corp#' 
            filtro1="#filtro1#" 
            showEmpresa="#showEmpresa#" 
            showline="false"
            cols="#lvarCols#"> 
         </td></tr>
         <tr><td>
		<cfoutput>#getHTML()#</cfoutput>  
        </td></tr></table>
        
    </cfif>
<cfelse>
	<table width="100%" cellpadding="0" cellspacing="0"><tr><td>
    <cf_HeadReport 
    	addTitulo1='#LB_Corp#' 
        filtro1="#filtro1#" 
        showEmpresa="#showEmpresa#" 
        showline="false" 
        cols="#lvarCols#">
    </td></tr>
     <tr><td>
	<div align="center" style="margin: 15px 0 15px 0"> --- <b><cfoutput>#LB_NoExistenRegistrosQueMostrar#</cfoutput></b> ---</div>
     </td></tr></table>
</cfif>    


<cffunction name="getFiltroEncab" returntype="query">
    <cf_translatedata name="get" tabla="Empresas" col="e.Edescripcion" returnvariable="LvarEdescripcion"/>
    <cf_translatedata name="get" tabla="TiposNomina" col="tn.Tdescripcion" returnvariable="LvarTdescripcion"/>
    <cfquery name="rsFiltroEncab" datasource="#session.DSN#">
        select #LvarEdescripcion# as Edescripcion, tn.Tcodigo, #LvarTdescripcion# as Tdescripcion, cp.CPcodigo, cp.CPdescripcion, coalesce(rcn.RCtc,1) as RCtc
        from CalendarioPagos cp  
        inner join #pre#RCalculoNomina rcn 
            on rcn.RCNid = cp.CPid
            inner join TiposNomina tn 
                on rcn.Ecodigo = tn.Ecodigo
                and rcn.Tcodigo = tn.Tcodigo 
            inner join Empresas e 
                on rcn.Ecodigo = e.Ecodigo    
        where rcn.RCNid in (  select CPid 
                            from CalendarioPagos
                            where CPperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarYer#">
                            and CPmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarMes#"> 
                            and CPtipo in(<cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarTipoCalendarPG#" list="true">)
                            <cfif isdefined("form.ListaTipoNomina") and len(trim(form.ListaTipoNomina)) >
                            and Tcodigo in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ListaTipoNomina#" list="true">)
                            </cfif>
                            and Ecodigo in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.JtreeListaItem#" list="true">)
                        )
    </cfquery>

    <cfreturn rsFiltroEncab>
</cffunction>
  
<cffunction name="getHTML" output="true">
    <table class="reporte" width="100%"> 
        <thead>
            <tr>
                <th>&nbsp;</th>
                <cfif not LvarMostrarColDolar>
                	<th>USD #LB_Monto#</th>
                <cfelse>
                    <th>CRC #LB_Colones#</th>
                    <th>USD #LB_Dolares#</th>
                </cfif>
            </tr>
        </thead>
        
        <!--- Seleccionado todas las opciones(1) o Ingresos(2), muestra los montos de los salarios y las incidencias --->
        <cfif vTipoSelect eq 1 or vTipoSelect eq 2 >
    		<!--- Detalle de las Ingresos --->
            <thead>
                <tr>
                    <th colspan="#lvarCols#">#LB_Ingresos#</th>
                </tr>
            </thead>
            <tbody>  
                <cfset total = 0 >
                <cfset totalDolares = 0 >
                <cfoutput query="rsSalario">
                    <tr>
                        <td nowrap="nowrap">#SEdescripcion#</td>
                        <td align="right">
                            <cf_locale name="number" value="#SEsalariobruto#"/>
                            <cfset total += SEsalariobruto>
                        </td> 
                        <cfif LvarMostrarColDolar>
                            <td align="right">
                                <cf_locale name="number" value="#SEsalariobrutoDolar#"/>
                                <cfset totalDolares += SEsalariobrutoDolar>
                            </td> 
                        </cfif>
                    </tr>
                </cfoutput>
                <cfoutput query="rsIncidencias">
                    <tr>
                        <td nowrap="nowrap">#CIdescripcion#</td>
                        <td align="right">
                            <cf_locale name="number" value="#ICmontores#"/>
                            <cfset total += ICmontores>
                        </td> 
                        <cfif LvarMostrarColDolar>
                            <td align="right">
                                <cf_locale name="number" value="#ICmontoresDolar#"/>
                                <cfset totalDolares += ICmontoresDolar>
                            </td> 
                        </cfif>
                    </tr>
                </cfoutput>
                <tr>
                    <td align="left"><strong>#LB_Total#</strong></td>
                    <td align="right">
                        <strong><cf_locale name="number" value ="#total#"/></strong>
                    </td> 
                    <cfif LvarMostrarColDolar>
                        <td align="right">
                            <strong><cf_locale name="number" value="#totalDolares#"/></strong>
                        </td> 
                    </cfif>
                </tr>
            </tbody>
        </cfif>

        <!--- Seleccionado todas las opciones(1) o Prestaciones(3), muestra los montos de las cargas empleados y patron --->
    	<cfif vTipoSelect eq 1 or vTipoSelect eq 3 >
    		<!--- Detalle de las Prestaciones --->
            <thead>
                <tr>
                    <th colspan="#lvarCols#">#LB_Prestaciones#</th>
                </tr>
            </thead>
            <tbody>  
                <cfset total = 0 >
                <cfset totalDolares = 0 >
                <cfoutput query="rsCargas">
                    <tr>
                        <td nowrap="nowrap">#DCdescripcion#</td>
                        <td align="right">
                            <cf_locale name="number" value="#CCvalor#"/>
                            <cfset total += CCvalor>
                        </td> 
                        <cfif LvarMostrarColDolar>
                            <td align="right">
                                <cf_locale name="number" value="#CCvalorDolares#"/>
                                <cfset totalDolares += CCvalorDolares>
                            </td> 
                        </cfif>
                    </tr>
                </cfoutput>
                <tr>
                    <td align="left"><strong>#LB_Total#</strong></td>
                    <td align="right">
                        <strong><cf_locale name="number" value="#total#"/></strong>
                    </td> 
                    <cfif LvarMostrarColDolar>
                        <td align="right">
                            <strong><cf_locale name="number" value="#totalDolares#"/></strong>
                        </td> 
                    </cfif>
                </tr>
            </tbody>
        </cfif>    

        <!--- Seleccionado todas las opciones(1) o Deducciones(4), muestra los montos de las deducciones --->
        <cfif vTipoSelect eq 1 or vTipoSelect eq 4 >
    		<!--- Detalle de las Deducciones --->
            <thead>
                <tr>
                    <th colspan="#lvarCols#">#LB_Deducciones#</th>
                </tr>
            </thead>
            <tbody>  
                <cfset total = 0 >
                <cfset totalDolares = 0 >
                <cfoutput query="rsDeducciones">
                    <tr>
                        <td nowrap="nowrap">#TDdescripcion#</td>
                        <td align="right">
                            <cf_locale name="number" value="#DCvalor#"/>
                            <cfset total += DCvalor>
                        </td> 
                        <cfif LvarMostrarColDolar>
                            <td align="right">
                                <cf_locale name="number" value="#DCvalorDolares#"/>
                                <cfset totalDolares += DCvalorDolares>
                            </td> 
                        </cfif>
                    </tr>
                </cfoutput>
                <tr>
                    <td align="left"><strong>#LB_Total#</strong></td>
                    <td align="right">
                        <strong><cf_locale name="number" value ="#total#"/></strong>
                    </td> 
                    <cfif LvarMostrarColDolar>
                        <td align="right">
                            <strong><cf_locale name="number" value="#totalDolares#"/></strong>
                        </td> 
                    </cfif>
                </tr>
            </tbody>  
    	</cfif>  
        <!--- Renta --->

        <!--- Seleccionado todas las opciones(1), muestra los montos de las transferencias --->
        <cfif vTipoSelect eq 1 >
            <thead>
                <tr>
                    <th colspan="#lvarCols#">#LB_Renta#</th>
                </tr>
            </thead>
            <cfset vTotalRenta = rsTransferencias.renta>
            <tbody>
                <tr>
                    <td nowrap="nowrap">#LB_RetencionRenta#</td>
                    <td align="right"><cf_locale name="number" value ="#rsTransferencias.Renta#"/></td> 
                </tr>

            </tbody>
        </cfif>



        <!--- Seleccionado todas las opciones(1), muestra los montos de las transferencias --->
        <cfif vTipoSelect eq 1 >
            <thead>
                <tr>
                    <th colspan="#lvarCols#">#LB_Transferencias#</th>
                </tr>
            </thead>
            <cfset vTotalTrans = rsTransferencias.depCtaCorriente + rsTransferencias.depCtaAhorro + rsTransferencias.cheques >
            <cfset vTotalTransDolar = rsTransferencias.depCtaCorrienteDolar + rsTransferencias.depCtaAhorroDolar + rsTransferencias.chequesDolar >
            <tbody>
                <tr>
                    <td nowrap="nowrap">#LB_DepCuentaCorriente#</td>
                    <td align="right"><cf_locale name="number" value ="#rsTransferencias.depCtaCorriente#"/></td> 
                    <cfif LvarMostrarColDolar>
                        <td align="right"><cf_locale name="number" value ="#rsTransferencias.depCtaCorrienteDolar#"/></td>
                    </cfif>    
                </tr>
                <tr>
                    <td nowrap="nowrap">#LB_DepCuentaAhorro#</td>
                    <td align="right"><cf_locale name="number" value ="#rsTransferencias.depCtaAhorro#"/></td> 
                    <cfif LvarMostrarColDolar>
                        <td align="right"><cf_locale name="number" value ="#rsTransferencias.depCtaAhorroDolar#"/></td> 
                    </cfif>    
                </tr>
                <tr>
                    <td nowrap="nowrap">#LB_Cheques#</td>
                    <td align="right"><cf_locale name="number" value ="#rsTransferencias.cheques#"/></td> 
                    <cfif LvarMostrarColDolar>
                        <td align="right"><cf_locale name="number" value ="#rsTransferencias.chequesDolar#"/></td> 
                    </cfif>    
                </tr>
                <tr>
                    <td align="left">&nbsp;&nbsp;&nbsp;<strong>#LB_subTotal#</strong></td>
                    <td align="right"><strong><cf_locale name="number" value="#vTotalTrans#"/></strong></td> 
                    <cfif LvarMostrarColDolar>
                        <td align="right"><strong><cf_locale name="number" value="#vTotalTransDolar#"/></strong></td>
                    </cfif>  
                </tr>
            </tbody>
            
                <cfset total = 0 >
                <cfset totalDolares = 0 >
                <cfoutput query="rsDeduccionesDepositos">
                    <tr>
                        <td nowrap="nowrap">#TDdescripcion#</td>
                        <td align="right">
                            <cf_locale name="number" value="#DCvalor#"/>
                            <cfset total += DCvalor>
                        </td> 
                        <cfif LvarMostrarColDolar>
                            <td align="right">
                                <cf_locale name="number" value="#DCvalorDolares#"/>
                                <cfset totalDolares += DCvalorDolares>
                            </td> 
                        </cfif>
                    </tr>
                </cfoutput>
                <cfset vTotalTrans= vTotalTrans + total>
                <cfset vTotalTransDolar= vTotalTransDolar + totalDolares>
                <cfif LvarMostrarColDolar>
                    <tr>
                    <td align="left">&nbsp;&nbsp;&nbsp;<strong>#LB_subTotal#</strong></td>
                    <td align="right"><strong><cf_locale name="number" value="#total#"/></strong></td> 
                    
                        <td align="right"><strong><cf_locale name="number" value="#totalDolares#"/></strong></td>
                    </tr>
                </cfif>
                <tr>
                    <td align="left"><strong>#LB_Total#</strong></td>
                    <td align="right"><strong><cf_locale name="number" value="#vTotalTrans#"/></strong></td> 
                    <cfif LvarMostrarColDolar>
                        <td align="right"><strong><cf_locale name="number" value="#vTotalTransDolar#"/></strong></td>
                    </cfif>  
                </tr>
            </tbody>
        </cfif>
    </table>
</cffunction>