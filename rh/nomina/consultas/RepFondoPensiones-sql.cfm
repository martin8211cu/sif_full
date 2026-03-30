<cfif isdefined("Exportar")>
  <cfset form.btnDownload = true> 
</cfif>

<cfset t = createObject("component","sif.Componentes.Translate")>

<!--- Las etiquetas son fijas debido a que este es un archivo que se importa a otro sistema (Fondo de Penciones) --->
<cfset LB_Beneficiario = 'Participid'>
<cfset LB_Agencia = 'Agency'>
<cfset LB_Apellido = 'Lastname'>
<cfset LB_PrimerNombre = 'Firstname'>
<cfset LB_Nacimiento = 'Birthdate'>
<cfset LB_CuentaContable = t.translate('LB_CuentaContable','Cuenta Contable','/rh/nomina/consultas/RepFondoPensiones.xml')/>
<cfset LB_MontoPension = 'Penssalary'>
<cfset LB_Total = t.translate('LB_Total','Total','/rh/generales.xml')>
<cfset LB_Estado = 'Status'>
<cfset LB_FechaIngreso = 'Entry_date'>
<cfset LB_Anno = 'Year'>
<cfset LB_Mes = 'Month'>
<cfset LB_titulo = t.translate('LB_titulo','Reporte de Fondo de Pensiones','/rh/nomina/consultas/RepFondoPensiones.xml')/>
<cfset LB_TipoDeCambio = t.translate('LB_TipoDeCambio','Tipo de cambio','/rh/generales.xml')/> 
<cfset LB_InformeParaElPeriodo = t.translate('LB_InformeParaElPeriodo','Informe para el periodo','/rh/generales.xml')/>
<cfset LB_InformeAlMesDe = t.translate('LB_InformeAlMesDe','Informe al mes de','/rh/generales.xml')/>
<cfset LB_NoExistenRegistrosQueMostrar = t.Translate('LB_NoExistenRegistrosQueMostrar','No existen registros que mostrar','/rh/generales.xml')>

<cfset archivo = "RepFondoPensiones(#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#).xls">

<cf_htmlReportsHeaders filename="#archivo#" irA="RepFondoPensiones.cfm">

<cfset LvarHTTP = 'http://'>
<cfif isdefined("session.sitio.ssl_todo") and session.sitio.ssl_todo> <cfset LvarHTTP = 'https://'> </cfif>
<link href="<cfoutput>#LvarHTTP##cgi.server_name#<cfif len(trim(cgi.SERVER_PORT))>:#cgi.SERVER_PORT#</cfif></cfoutput>/cfmx/plantillas/IICA/css/reports.css" rel="stylesheet" type="text/css">
<cf_templatecss/>

<style type="text/css">
  .tituloDivisor { padding-top: 2em !important; padding-bottom: 1em !important; border-color: #000 !important; border-left: 0 !important; border-right: 0 !important; }
  .reporte{ width: 100%; }
</style>

<cfif not isdefined("Exportar") or not isdefined("Consultar")> 
  <cfset Exportar = true>
</cfif> 

<cfinvoke component="rh.Componentes.RH_Funciones" method="DeterminaEmpresasPermiso" returnvariable="EmpresaLista">

<cf_translatedata name="get" tabla="CuentaEmpresarial" col="CEnombre"  conexion="asp" returnvariable="LvarCEnombre">
<cfquery datasource="asp" name="rsCEmpresa">
  select #LvarCEnombre# as CEnombre 
  from CuentaEmpresarial 
  where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
</cfquery>

<cfset LB_Corp = rsCEmpresa.CEnombre>
<cfset titulocentrado2 = ''>
<cfset Lvar_TipoCambio = 1 >
<cfset form.CPid = 0 > 
<cfset form.ECid = 0 > 
<cfset lvarCols = 14 >


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
<cfif isdefined("chk_NominaAplicada")>
  <cfset pre = 'H'>
</cfif>

<cfif not isDefined("form.FechaDesde")>
  <cfset form.FechaDesde = DateFormat(Now(),'dd/mm/yyyy') >
</cfif> 

<cfif not isDefined("form.fechaHasta")>
  <cfset form.fechaHasta = DateFormat(Now(),'dd/mm/yyyy') >
</cfif> 


<!--- Verifica si se selecciono alguna nomina para aplicar al filtro de la consulta --->
<cfif isDefined("form.ListaNomina") and len(trim(form.ListaNomina))>
  <cfset form.CPid = listAppend(form.CPid, form.ListaNomina)>
</cfif> 

 <cfif isDefined("form.ListaECid")>
  <cfset form.ECid = listAppend(form.ECid,form.ListaECid)>
</cfif>
  
<cfquery name="rsMeses" datasource="sifcontrol">
  select VSdesc ,VSvalor 
  from VSidioma 
  where VSgrupo = 1 and Iid = (select Iid from Idiomas where Icodigo='#session.idioma#')
</cfquery> 

<!--- Obtiene el resulset con el detalle de los fondos de pensiones --->
<cfset rsReporte = getQuery() >  

<cfif rsReporte.recordcount>
  <cfset Lvar_TipoCambio = rsReporte.tipocambio>
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

    <cfset titulocentrado2 = '#LB_InformeParaElPeriodo# #rs1.VSdesc# #year(rsReporte.mesMin)# - #rs2.VSdesc# #year(rsReporte.mesMax)#'>
  <cfelse>  
    <cfquery dbtype="query" name="rs1">
      select VSdesc 
      from rsMeses 
      where VSvalor = '#month(rsReporte.mesMax)#'
    </cfquery>

    <cfset titulocentrado2 = '#LB_InformeAlMesDe# #rs1.VSdesc# #year(rsReporte.mesMax)#'>
  </cfif> 

  <cfif isdefined("Exportar") or isdefined("Consultar")>    
        <cfoutput>#getHTML(rsReporte)#</cfoutput>   
    </cfif>
<cfelse>   
  <div align="center" style="margin: 15px 0 15px 0"> --- <b><cfoutput>#LB_NoExistenRegistrosQueMostrar#</cfoutput></b> ---</div>
</cfif>




<cffunction name="getQuery" returntype="query">
  <cf_dbfunction name="op_concat" returnvariable="concat">

  <cfif isdefined('form.chk_FiltroFechas') >
    <cfquery name="rsCalMes" datasource="#session.dsn#">
      select a.CPid
      from CalendarioPagos a
      where a.CPhasta >= <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#form.FechaDesde#"> 
            and a.CPdesde <= <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#form.FechaHasta#"> 
            and a.Ecodigo in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.JtreeListaItem#" list="true">)
   </cfquery>
  </cfif>

  <cfquery name="rsRangos" datasource="#session.dsn#">
    select min(a.CPdesde) as desde, max(a.CPhasta) as hasta
      from CalendarioPagos a
      where <cfif isdefined('form.chk_FiltroFechas') >
             a.CPid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCalMes.CPid#" list="true">)   
          <cfelse>
             a.CPid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#" list="true">)   
          </cfif>
  </cfquery>
 


  <cfquery name="rsReporte" datasource="#session.dsn#">
    select de.DEid, de.DEinfo4 as DEidentificacion, de.DEnombre, de.DEapellido1#concat#' '#concat#de.DEapellido2 as apellido,
     de.DEfechanac as nacimiento, ev.EVfantig as ingreso, cp.CPperiodo, cp.CPmes, coalesce(sum(cc.CCvaloremp),0) as empl, 
     coalesce(sum(cc.CCvalorpat),0) as patr,
     coalesce(
        (select  
          (sum(((b.DLTmonto * 12)- dct1.DCTDconstante) / dct1.DCTDfactor)/30) *

          (coalesce((select sum(hp.PEcantdias)
                    from #pre#PagosEmpleado hp
                    where hp.DEid = de.DEid
                    and hp.PEtiporeg = 0
                    <cfif isdefined('form.chk_FiltroFechas') >
                      and hp.RCNid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCalMes.CPid#" list="true">)   
                    <cfelse>
                      and hp.RCNid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#" list="true">)   
                    </cfif>
                  ),0)
          )

          from LineaTiempo a
          inner join DLineaTiempo b
            on b.LTid = a.LTid
              and coalesce(b.CIid,0) = 0
          inner join DCargasTablaE dc1
            on <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#rsRangos.desde#"> between dc1.DCTEdesde and dc1.DCTEhasta  
            and dc1.Ecodigo = a.Ecodigo
          inner join DCargasTablaD dct1
            on dc1.DCTEid = dct1.DCTEid
              and (b.DLTmonto*12) between dct1.DCTDmin and dct1.DCTDmax

          where a.DEid = de.DEid
          and not ((a.LTdesde < <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#rsRangos.desde#">   
                and a.LThasta < <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#rsRangos.desde#"> ) 
            or  (<cf_jdbcquery_param cfsqltype="cf_sql_date" value="#rsRangos.hasta#">  < a.LTdesde 
                and  <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#rsRangos.hasta#">   < a.LThasta))
          
          and LTdesde = (
          					select max(x.LTdesde) 
          					from LineaTiempo x
                        	where x.DEid = a.DEid
                          	and not ((x.LTdesde < <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#rsRangos.desde#">   
                                and x.LThasta < <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#rsRangos.desde#"> ) 
                            or  (<cf_jdbcquery_param cfsqltype="cf_sql_date" value="#rsRangos.hasta#">  < x.LTdesde 
                                and  <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#rsRangos.hasta#">   < x.LThasta))
                            and x.RHTid not in (select y.RHTid from RHTipoAccion y where y.RHTcomportam = 5)<!---donde no haya  incapacidad--->
                        )
          
        ),0) as salariopen,

      max(coalesce(left(DCcodigo,1),'-')) as estado,
      max(rhc.RCtc) as tipocambio,
      max(cp.CPfpago) as mesMin,
      min(cp.CPfpago) as mesMax

      ,coalesce(
              (select coalesce(sum(cca.CCvaloremp),0)
               from HCargasCalculo cca <!---Siempre debe salir de la Historia por ser el valor del mes anterior--->
               inner join DCargas dca
              on cca.DClinea = dca.DClinea 
               where cca.RCNid in   (select ant.CPid
                          from CalendarioPagos ant
                          inner join CalendarioPagos a
                            on  a.Tcodigo = ant.Tcodigo
                          where 
                          <cfif isdefined('form.chk_FiltroFechas') >
                             a.CPid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCalMes.CPid#" list="true">)   
                          <cfelse>
                             a.CPid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#" list="true">)    
                          </cfif>
                          and ant.CPhasta >= <cf_dbfunction name="dateadd" args="-1, a.CPdesde, MM">
                          and ant.CPdesde <= <cf_dbfunction name="dateadd" args="-1, a.CPhasta, MM">
                        )
                <cfif isdefined("form.TcodigoListCg") and len(trim(form.TcodigoListCg)) GT 0>
                and dca.DCcodigo in (<cfqueryparam cfsqltype="cf_sql_char" value="#form.TcodigoListCg#" list="true"/>)
              </cfif>
               and cca.DEid = de.DEid
            ),0) as emplAnt ,
            
            

         coalesce(
              (select coalesce(sum(cca.CCvalorpat),0)
               from HCargasCalculo cca	<!---Siempre debe salir de la Historia por ser el valor del mes anterior--->
               inner join DCargas dca
              on cca.DClinea = dca.DClinea 
               where cca.RCNid in   (select ant.CPid
                          from CalendarioPagos ant
                          inner join CalendarioPagos a
                            on  a.Tcodigo = ant.Tcodigo
                          where <cfif isdefined('form.chk_FiltroFechas') >
                            a.CPid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCalMes.CPid#" list="true">)
                          <cfelse>
                            a.CPid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#" list="true">)    
                          </cfif>
                          and ant.CPhasta >= <cf_dbfunction name="dateadd" args="-1, a.CPdesde, MM">
                          and ant.CPdesde <= <cf_dbfunction name="dateadd" args="-1, a.CPhasta, MM">
                        )
                <cfif isdefined("form.TcodigoListCg") and len(trim(form.TcodigoListCg)) GT 0>
                and dca.DCcodigo in (<cfqueryparam cfsqltype="cf_sql_char" value="#form.TcodigoListCg#" list="true"/>)
              </cfif>
                and cca.DEid = de.DEid
            ),0) as patrAnt

    from CalendarioPagos cp
    inner join #pre#SalarioEmpleado se
      on cp.CPid = se.RCNid
    inner join #pre#RCalculoNomina rhc
      on rhc.RCNid = se.RCNid
    inner join DatosEmpleado de
      on se.DEid = de.DEid  
    inner join EVacacionesEmpleado ev
      on de.DEid = ev.DEid  
    inner join #pre#CargasCalculo cc
      on cc.RCNid = cp.CPid
      and cc.DEid = se.DEid
    inner join DCargas dc
      on cc.DClinea = dc.DClinea
    where dc.Ecodigo in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.JtreeListaItem#" list="true">)
    <cfif isdefined("form.TcodigoListCg") and len(trim(form.TcodigoListCg)) GT 0>
      and dc.DCcodigo in (<cfqueryparam cfsqltype="cf_sql_char" value="#form.TcodigoListCg#" list="true"/>)
    </cfif>

    <cfif isdefined('form.chk_FiltroFechas') >
      and cp.CPhasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#form.FechaDesde#"> 
      and cp.CPdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#form.FechaHasta#"> 
     <!--- and cp.CPid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCalMes.CPid#" list="true">) --->
    <cfelse>
      and cp.CPid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#" list="true">)    
    </cfif>
    group by de.DEid, de.DEinfo4, de.DEnombre, de.DEapellido1, de.DEapellido2, de.DEfechanac, ev.EVfantig, cp.CPperiodo, cp.CPmes
    order by 12,4
  </cfquery> 
 
  <cfreturn rsReporte>
</cffunction> 


<cffunction name="getHTML" output="true">
  <cfargument name="rsReporte" type="query" required="true">

  <table class="reporte">
    <thead>
      <tr>
        <th>#LB_Beneficiario#</th>
        <th>#LB_Agencia#</th>
        <th>#LB_Apellido#</th>
        <th>#LB_PrimerNombre#</th>
        <th>#LB_Nacimiento#</th>
        <th>#LB_MontoPension#</th>
        <th>#LB_Estado#</th>
        <th>#LB_FechaIngreso#</th>
        <th>Imemcontr</th>
        <th>Imorgcontr</th>
        <th>#LB_Anno#</th>
        <th>#LB_Mes#</th>
        <th>Emp_contr</th>
        <th>Org_contr</th>
      </tr>
    </thead> 
    <tbody>
      <cfset LvarTotalImemcontr = 0>
      <cfset LvarTotalImorgcontr = 0>
      <cfset LvarTotalEmp_contr = 0>
      <cfset LvarTotalOrg_contr = 0> 
      <cfset LvarTotalSalarioPen = 0> 
        
      <cfloop query="Arguments.rsReporte">
        <tr>
          <td>#DEidentificacion#</td>
          <td>IICA</td>
          <td nowrap>#apellido#</td>
          <td nowrap>#DEnombre#</td>
          <td><cf_locale name="date" value="#nacimiento#"/></td>
          <td align="right"><cf_locale name="number" value="#salariopen#"/></td>
          <td>#estado#</td>
          <td><cf_locale name="date" value="#ingreso#"/></td>
          <td align="right"><cf_locale name="number" value="#emplAnt#"/></td>
          <td align="right"><cf_locale name="number" value="#patrAnt#"/></td>
          <td align="right">#CPperiodo#</td>
          <td align="right">#CPmes#</td>
          <td align="right"><cf_locale name="number" value="#empl#"/></td>
          <td align="right"><cf_locale name="number" value="#patr#"/></td>
        </tr>

        <cfset LvarTotalImemcontr += emplAnt>
        <cfset LvarTotalImorgcontr += patrAnt>
        <cfset LvarTotalEmp_contr += empl>
        <cfset LvarTotalOrg_contr += patr> 
        <cfset LvarTotalSalarioPen += salariopen>
      </cfloop>

      <tr><td colspan="#lvarCols#">&nbsp;</td></tr>
      <tr>
        <td colspan="5" align="right"><strong>#LB_Total#</strong></td> 
        <td align="right"><strong><cf_locale name="number" value="#LvarTotalSalarioPen#"/></strong></td>
        <td colspan="2"></td>
        <td align="right"><strong><cf_locale name="number" value="#LvarTotalImemcontr#"/></strong></td>
        <td align="right"><strong><cf_locale name="number" value="#LvarTotalImorgcontr#"/></strong></td>
        <td align="right" colspan="2"></td>
        <td align="right"><strong><cf_locale name="number" value="#LvarTotalEmp_contr#"/></strong></td>
        <td align="right"><strong><cf_locale name="number" value="#LvarTotalOrg_contr#"/></strong></td>
      </tr>
      <tr><td colspan="#lvarCols#">&nbsp;</td></tr>
    </tbody>
  </table>
</cffunction>   