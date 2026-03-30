<cfif isdefined("form.Exportar")>
    <cfset form.btnDownload = true>
</cfif>

<cfset t = createObject("component", "sif.Componentes.Translate")>

<!--- Etiquetas de traduccion --->
<cfset LB_APagar = t.translate('LB_APagar','A pagar')/>
<cfset LB_Funcionarios = t.translate('LB_Funcionarios','Funcionarios')/>
<cfset LB_Concepto = t.translate('LB_Concepto','Concepto','/rh/generales.xml')/>
<cfset LB_Monto = t.translate('LB_Monto','Monto','/rh/generales.xml')/>
<cfset LB_SalarioBasico = t.translate('LB_SalarioBasico','Salario Básico','/rh/generales.xml')/>
<cfset LB_TotalIngresos = t.translate('LB_TotalIngresos','Total Ingresos')/>
<cfset LB_Cuenta = t.translate('LB_Cuenta','Cuenta','/rh/generales.xml')/>
<cfset LB_MenosDeducciones = t.translate('LB_MenosDeducciones','Menos Deducciones')/>
<cfset LB_TotalDeducciones = t.translate('LB_TotalDeducciones','Total Deducciones')/>
<cfset LB_MenosCargas = t.translate('LB_MenosCargas','Menos Cargas')/>
<cfset LB_TotalPrestaciones = t.translate('LB_TotalPrestaciones','Total Prestaciones')/>
<cfset LB_TotalDeduccionesYPrestaciones = t.translate('LB_TotalDeduccionesYPrestaciones','Total Deducciones Y Prestaciones')/>
<cfset LB_TotalAPagar = t.translate('LB_TotalAPagar','Total a pagar')/>
<cfset LB_NoExistenRegistrosQueMostrar = t.Translate('LB_NoExistenRegistrosQueMostrar','No existen registros que mostrar','/rh/generales.xml')/> 
<cfset LB_DepositosAdicionales = t.Translate('LB_DepositosAdicionales','Depósitos Adicionales','/rh/generales.xml')/> 
<cfset LB_subTotal = t.translate('LB_subTotal','Sub Total')/>

<cfset archivo = "ResumenNomina(#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#).xls">

<cf_htmlReportsHeaders filename="#archivo#" irA="ResumenNomina.cfm">
<cf_templatecss/>

<cfset pre = ''>
<cfif isdefined("chk_NominaAplicada")>
	<cfset pre = 'H'>
</cfif>

<cfset form.CPid = 0>
<cfif isdefined("form.CPid1") and len(trim(form.CPid1))>
    <cfset form.CPid = form.CPid1 > 
</cfif>  

<cfif isdefined("form.CPid2") and len(trim(form.CPid2))>
    <cfset form.CPid = form.CPid2 > 
</cfif>  

<cf_translatedata name="get" tabla="CuentaEmpresarial" col="CEnombre" conexion="asp" returnvariable="LvarCEnombre">
<cfquery datasource="asp" name="rsCEmpresa">
	select #LvarCEnombre# as CEnombre 
	from CuentaEmpresarial 
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
</cfquery>

<cfset LB_Corp = rsCEmpresa.CEnombre>
<cfset titulocentrado2 = ''>
<cfset titulocentrado3 = ''>
<cfset lvarCols = 4 >


<!--- obtiene meses para el idioma --->
<cfquery name="rsMeses" datasource="sifcontrol">
    select VSdesc, VSvalor 
    from VSidioma 
    where VSgrupo = 1 and Iid = (select Iid from Idiomas where Icodigo='#session.Idioma#')
    order by <cf_dbfunction name="to_number" args="VSvalor">
</cfquery>

<cfset meses = arrayNew(1)>
<cfloop query="rsMeses">
    <cfset arrayAppend(meses, VSdesc)>
</cfloop>


<!--- Genera el Salario Bruto de Nomina Seleccionada --->
<cfquery name="rsSalario" datasource="#session.dsn#">
    select sum(coalesce(se.SEsalariobruto,0)) as SEsalariobruto
    from #pre#RCalculoNomina rcn  
    inner join #pre#SalarioEmpleado se
        on se.RCNid = rcn.RCNid
    where rcn.Ecodigo  in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.JtreeListaItem#" list="true">)
        and rcn.RCNid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ListaNomina#" list="true">)
</cfquery> 

<!--- Depósitos Adicionales--->
<cfquery name="rsDeduccionesDepositos" datasource="#session.dsn#">
    select rcn.RCNid, <!---de.TDid, td.TDdescripcion,---> sum(dc.DCvalor) as DCvalor, 
    sum(case when coalesce(rcn.RCtc,1) = 1 then 0 else dc.DCvalor/rcn.RCtc end) as DCvalorDolares
    from #pre#RCalculoNomina rcn
    inner join #pre#DeduccionesCalculo dc
        on dc.RCNid = rcn.RCNid
        inner join DeduccionesEmpleado de
            on de.Did = dc.Did   
            inner join TDeduccion td
                on td.TDid = de.TDid
    where 
    	rcn.Ecodigo  in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.JtreeListaItem#" list="true">)
         and rcn.RCNid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ListaNomina#" list="true">)
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
	group by rcn.RCNid<!---, de.TDid, td.TDdescripcion--->
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
	<cfset lvarPeriodo = #meses[rsEncabezado.CPmes]# &" "& rsEncabezado.CPperiodo>
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
    <cfset filtro1 &= '#Edescripcion# - #CPcodigo# - #Tdescripcion# - #CPdescripcion# #vTC#'>
</cfloop>

<cfif len(trim(rsSalario.SEsalariobruto))>	
    <!--- Genera los montos de las Incidencias de Nomina Seleccionada --->
	<cf_translatedata name="get" tabla="CIncidentes" col="ci.CIdescripcion" returnvariable="LvarCIdescripcion">    
    <cfquery name="rsIncidencias" datasource="#session.dsn#">
        select  coalesce(arg.RHARdescripcion,#LvarCIdescripcion#) as CIdescripcion, sum(coalesce(ic.ICmontores,0)) as ICmontores
        from #pre#RCalculoNomina rcn
        inner join #pre#IncidenciasCalculo ic
            on ic.RCNid = rcn.RCNid
            inner join CIncidentes ci
                on ci.CIid = ic.CIid
            left outer join RHDAgrupadorRubro ar
                on ar.RHDARvalor=ci.CIid
                and ar.RHDARtabla = 'CIncidentes'
                and ar.RHDARcampo = 'CIid'
            left outer join RHAgrupadorRubro arg
                on arg.RHARid = ar.RHARid
        where rcn.Ecodigo  in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.JtreeListaItem#" list="true">)
            and rcn.RCNid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ListaNomina#" list="true">)
        group by  coalesce(arg.RHARdescripcion,#LvarCIdescripcion#)
    </cfquery>

    <!--- Genera las Deducciones de Nomina Seleccionada --->
	<cf_translatedata name="get" tabla="TDeduccion" col="td.TDdescripcion" returnvariable="LvarTDdescripcion">    
    <cfquery name="rsDeducciones" datasource="#session.dsn#">
        select #LvarTDdescripcion# as TDdescripcion, sum(coalesce(dc.DCvalor,0)) as DCvalor 
        <cfif len(pre) gt 0>, rct.Cformato as Cuenta </cfif>
        from #pre#RCalculoNomina rcn
        inner join #pre#DeduccionesCalculo dc
            on dc.RCNid = rcn.RCNid
            inner join DeduccionesEmpleado de
                on de.Did = dc.Did   
                inner join TDeduccion td
                    on td.TDid = de.TDid

        <cfif len(pre) gt 0>            
            inner join RCuentasTipo rct
                on rct.referencia = de.Did 
                and rct.RCNid = rcn.RCNid 
                and rct.tiporeg = 60
        </cfif>               

        where rcn.Ecodigo  in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.JtreeListaItem#" list="true">)
            and rcn.RCNid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ListaNomina#" list="true">)
            <!---Excluye los depósitos adicionales siempre y cuando se encuentren dentro de un grupo de deducciones--->
            and td.TDid not in (select distinct b.TDid
                                from RHExportacionDeducciones a
                                    inner join TDeduccion b
                                        on a.TDid = b.TDid
                                        <!---and b.TDcodigo not in ('80','90')--->
                                    inner join <cf_dbdatabase table="EImportador" datasource="sifcontrol"> ei
                                        on a.EIid = ei.EIid
                                     inner join Empresas c
                                        on c.Ecodigo=b.Ecodigo
                                where a.Ecodigo  in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.JtreeListaItem#" list="true">)
                                and a.RHEDesliquido = 1 <!---deducciones correspondientes a salario liquido--->
                             )
        group by  #LvarTDdescripcion# <cfif len(pre) gt 0>, rct.Cformato </cfif>
    </cfquery>

    <!--- Genera las Cargas de Nomina Seleccionada --->
	<cf_translatedata name="get" tabla="ECargas" col="ec.ECdescripcion" returnvariable="LvarECdescripcion">        
	<cf_translatedata name="get" tabla="DCargas" col="dc.DCdescripcion" returnvariable="LvarDCdescripcion">            
    <cfquery name="rsCargas" datasource="#session.dsn#">
        select #LvarECdescripcion# as ECdescripcion, #LvarDCdescripcion# as DCdescripcion, sum(coalesce(cc.CCvaloremp,0)) as CCvalor 
        <cfif len(pre) gt 0>, rct.Cformato as Cuenta </cfif>
        from #pre#RCalculoNomina rcn
        inner join #pre#CargasCalculo cc
            on cc.RCNid = rcn.RCNid
            inner join DCargas dc
                on dc.DClinea = cc.DClinea
            <!---inner join SNegocio sn
                on sn.SNcodigo = dc.SNcodigo--->
            inner join ECargas ec
                on ec.ECid = dc.ECid
        <cfif len(pre) gt 0>            
            inner join RCuentasTipo rct
                on rct.referencia = cc.DClinea 
                and rct.RCNid = cc.RCNid 
                and rct.DEid = cc.DEid
                and rct.tiporeg in (30,31,40,41,50,51,52,55,56,57)
        </cfif>  
                
        where rcn.Ecodigo  in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.JtreeListaItem#" list="true">)
            and rcn.RCNid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ListaNomina#" list="true">)
            and cc.CCvaloremp <> 0 
        group by #LvarECdescripcion#, #LvarDCdescripcion# <cfif len(pre) gt 0>, rct.Cformato </cfif>
        order by #LvarECdescripcion#, #LvarDCdescripcion# <cfif len(pre) gt 0>, rct.Cformato </cfif>
    </cfquery> 

    <cfquery name="rsCantEmpleados" datasource="#session.dsn#">
        select count(distinct se.DEid) as cantEmp
        from #pre#RCalculoNomina rcn  
        inner join #pre#SalarioEmpleado se
            on se.RCNid = rcn.RCNid
            inner join LineaTiempo lt
                on se.DEid = lt.DEid
                and lt.Ecodigo = rcn.Ecodigo
        where rcn.RCNid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ListaNomina#" list="true">)
        and lt.LTdesde <= rcn.RChasta and lt.LThasta >= rcn.RCdesde
    </cfquery>
	
	<cfif isdefined("form.Exportar") or isdefined("form.Consultar")>
     	<cf_HeadReport 
        	addTitulo1='#LB_Corp#' 
            filtro1='#filtro1#'
            filtro2='#lvarPeriodo#'
        	cols="#lvarCols#"
            showline="false">
		<cfoutput>#getHTML()#</cfoutput>
	</cfif>	
<cfelse>
	<cf_HeadReport 
        	addTitulo1='#LB_Corp#' 
            filtro1='#filtro1#'
            filtro2='#lvarPeriodo#'
        	cols="#lvarCols#"
            showline="false">
	<div align="center" style="margin: 15px 0 15px 0"> --- <b><cfoutput>#LB_NoExistenRegistrosQueMostrar#</cfoutput></b> ---</div>
</cfif>		


<cffunction name="getHTML" output="true">
	<table class="reporte" width="100%"> 
    	<cfoutput>
            <thead>
                <tr>
                    <th>&nbsp;</th>
                    <th style="text-align:left;">#LB_APagar# (#rsCantEmpleados.cantEmp# #LB_Funcionarios#)</th>
                    <th>#LB_Monto#</th>
                </tr>
            </thead>
        </cfoutput>	
        
        <cfset totalPagar = 0 >

        <!--- Detalle de los Ingresos --->
        <tbody>  
            <cfset totalIng = 0 >
            <cfoutput query="rsSalario">
                <tr>
                	<td>&nbsp;</td>
                    <td nowrap>#LB_SalarioBasico#</td>
                    <td align="right">
                        <cf_locale name="number" value="#SEsalariobruto#"/>
                        <cfset totalIng += SEsalariobruto>
                    </td> 
                </tr>
            </cfoutput>
            <cfoutput query="rsIncidencias">
                <tr>
                	<td>&nbsp;</td>
                    <td nowrap>#CIdescripcion#</td>
                    <td align="right">
                        <cf_locale name="number" value="#ICmontores#"/>
                        <cfset totalIng += ICmontores>
                    </td> 
                </tr>
            </cfoutput>
            
            <tr><td colspan="3">&nbsp;</td></tr>
            <tr>
                <td>&nbsp;</td>
                <td align="center"><strong>#LB_TotalIngresos#</strong></td>
                <td align="right">
                    <strong><cf_locale name="number" value ="#totalIng#"/></strong>
                </td> 
            </tr>
            <tr><td colspan="3">&nbsp;</td></tr>
            <cfset totalPagar += totalIng >
        </tbody>

        <!--- Detalle de las Deducciones --->
        <cfoutput>
            <thead>
                <tr>
                	<th>#LB_Cuenta#</th>
                    <th style="text-align:left;">#LB_MenosDeducciones#</th>
                    <th>#LB_Monto#</th>
                </tr>
            </thead>
        </cfoutput>	

        <tbody>  
            <cfset totalDed = 0 >
            <cfoutput query="rsDeducciones">
                <tr>
                	<td><cfif len(pre) gt 0>#Cuenta#</cfif></td>
                    <td nowrap>#TDdescripcion#</td>
                    <td align="right">
                        <cf_locale name="number" value="#DCvalor#"/>
                        <cfset totalDed += DCvalor>
                    </td> 
                </tr>
            </cfoutput>
            <tr><td colspan="3">&nbsp;</td></tr>
            <tr>
                <td>&nbsp;</td>
                <td align="center"><strong>#LB_TotalDeducciones#</strong></td>
                <td align="right">
                    <strong><cf_locale name="number" value ="#totalDed#"/></strong>
                </td> 
            </tr>
            <tr><td colspan="3">&nbsp;</td></tr>
			<cfset totalPagar -= totalDed >
        </tbody>  

		<!--- Detalle de las Prestaciones --->
        <cfoutput>
            <thead>
                <tr>
                	<th>#LB_Cuenta#</th>
                    <th style="text-align:left;">#LB_MenosCargas#</th>
                    <th>#LB_Monto#</th>
                </tr>
            </thead>
        </cfoutput>	
        <tbody>  
            <cfset totalCg = 0 >
            <cfset subtotalCg = 0>
            <cfset GrupoG = ''>
            <cfoutput query="rsCargas">
            	 <cfif not len(trim(GrupoG))>
                 	<cfset GrupoG = rsCargas.ECdescripcion>
                 </cfif>
                 <cfif GrupoG NEQ rsCargas.ECdescripcion>
                	<tr>
                        <td>&nbsp;</td>
                        <td align="center"> <strong>#GrupoG# #LB_subTotal#</strong></td>
                        <td align="right">
                            <strong><cf_locale name="number" value="#subtotalCg#"/></strong>
                        </td> 
                    </tr>
                	<cfset GrupoG = rsCargas.ECdescripcion>
                	<cfset subtotalCg = 0>
                </cfif>
                <tr>
                	<td><cfif len(pre) gt 0>#Cuenta#</cfif></td>
                    <td nowrap>#DCdescripcion#</td>
                    <td align="right">
                        <cf_locale name="number" value="#CCvalor#"/>
                        <cfset totalCg += CCvalor>
                        <cfset subtotalCg += CCvalor>
                    </td> 
                </tr>
                
            </cfoutput>
            <tr>
                <td>&nbsp;</td>
                <td align="center"><strong>#GrupoG# #LB_subTotal#</strong></td>
                <td align="right">
                    <strong><cf_locale name="number" value="#subtotalCg#"/></strong>
                </td> 
            </tr>
            <tr><td colspan="3">&nbsp;</td></tr>
            <tr>
                <td>&nbsp;</td>
                <td align="center"><strong>#LB_TotalPrestaciones#</strong></td>
                <td align="right">
                    <strong><cf_locale name="number" value="#totalCg#"/></strong>
                </td> 
            </tr>
            <tr><td colspan="3">&nbsp;</td></tr>
            <tr>
                <td>&nbsp;</td>
                <td align="center"><strong>#LB_TotalDeduccionesYPrestaciones#</strong></td>
                <td align="right">
                    <strong><cf_locale name="number" value="#totalDed + totalCg#"/></strong>
                </td> 
            </tr>
            <cfset totalPagar -= totalCg >
        </tbody>   
        <tr><td colspan="3">&nbsp;</td></tr>
        <tr>
			<td>&nbsp;</td>
            <td align="center"><strong>#LB_TotalAPagar#</strong></td>
            <td align="right">
                <strong><cf_locale name="number" value="#totalPagar#"/></strong>
            </td> 
        </tr>	
        <tr><td colspan="3">&nbsp;</td></tr>
    </table>
</cffunction>


