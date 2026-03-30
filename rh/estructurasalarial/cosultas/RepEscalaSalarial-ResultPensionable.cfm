
<cfset t = createObject("component", "sif.Componentes.Translate")>

<!--- Etiquetas de traducción --->
<cfset LB_ReporteEscalaSalarialSalarioPensionable = t.translate('LB_ReporteEscalaSalarialSalarioPensionable','Reporte Escala Salarial </br>Salario pensionable para calcular las contribuciones al Plan de Jubilaciones y Pensiones de la OEA')>
<cfset LB_TablaSalarial = t.translate('LB_TablaSalarial','Tabla Salarial')>
<cfset LB_Vigencia = t.translate('LB_Vigencia','Vigencia')>
<cfset LB_RemuneracionPensionable = t.translate('LB_RemuneracionPensionable','Remuneración pensionable')> 

<cfset LB_SalarioBasicoAnual = t.translate('LB_SalarioBasicoAnual','Salario Básico Anual')>

<cfset LB_NoExistenRegistrosQueMostrar = t.Translate('LB_NoExistenRegistrosQueMostrar','No existen registros que mostrar','/rh/generales.xml')>

<cfset LvarBack = "RepEscalaSalarialPensionable.cfm">
<cfset archivo = "ReporteEscalaSalarialPensionable(#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#).xls">

<!--- Asigna formato de salida --->
<cfif isdefined("form.BTNDOWNLOAD")>
    <cfset vFormato = "excel" >
<cfelse>
    <cfset vFormato = "html" >    
</cfif>

<!--- Obtiene un array con los id de las tablas salariales --->
<cfif isdefined("form.TCodListTS") and len(trim(form.TCodListTS)) >
    <cfset list = form.TCodListTS > 
    <cfset aRHTTid = ListToArray(list) >
</cfif> 

<!--- Obtiene un array con los id de las vigencias --->
<cfif isdefined("form.TCodListVG") and len(trim(form.TCodListVG)) >
    <cfset list = form.TCodListVG > 
    <cfset aRHVTid = ListToArray(list) >
</cfif> 


<cfset rsFiltroEncab = getFiltroEncab() >

<cfset filtro1 = "" > 
<cfset filtro2 = "" > 




<cfquery name="rsVigencia" dbtype="query">
    select distinct RHVTfecharige, RHVTfechahasta
    from rsFiltroEncab
</cfquery>

<cfloop query="rsFiltroEncab">
    <cfif RHVTtipocambio neq 1 >
        <cfset vTC = "(TC: #RHVTtipocambio#)">
    <cfelse>
        <cfset vTC = "" >   
    </cfif>
    <cfset filtro1 &= '<strong>#RHTTcodigo# - #RHTTdescripcion# - #RHVTdescripcion# #vTC#</strong><br/>'>
    <cf_locale name="date" value="#RHVTfecharige#" returnvariable="desde"/>
    <cf_locale name="date" value="#RHVTfechahasta#" returnvariable="hasta"/>

    <cfif isDefined('rsVigencia') and rsVigencia.recordcount NEQ 1>
        <cfset fvigente = createDate(6100, 1, 1)>
        
        <cfif RHVTfechahasta EQ fvigente>
            <cfset filtro1 &= '<strong>#LB_Vigencia#:</strong> #desde# <br/>'>    
        <cfelse>
            <cfset filtro1 &= '<strong>#LB_Vigencia#:</strong> #desde# - #hasta# <br/>'>    
        </cfif>
    </cfif>    
</cfloop>

<cfif isDefined('rsVigencia') and rsVigencia.recordcount EQ 1>
    <cf_locale name="date" value="#rsVigencia.RHVTfecharige#" returnvariable="desde"/>
    <cf_locale name="date" value="#rsVigencia.RHVTfechahasta#" returnvariable="hasta"/>
    <cfset fvigente = createDate(6100, 1, 1)>
    <cfif rsVigencia.RHVTfechahasta EQ fvigente>
        <cfset filtro1 &= '<strong>#LB_Vigencia#:</strong> #desde# <br/>'>    
    <cfelse>
        <cfset filtro1 &= '<strong>#LB_Vigencia#:</strong> #desde# - #hasta# <br/>'>    
    </cfif>
</cfif>



<cfset rsEscalaSalarial = getQuery() >  <!--- Reporte de Escala Salarial ---> 

<cfif compare(vFormato,'excel') eq 0 >  
    <cfset form.BTNDOWNLOAD = 1 >
</cfif>      

<cf_htmlReportsHeaders irA="#LvarBack#" FileName="#archivo#" title="#LB_ReporteEscalaSalarialSalarioPensionable#">

<style> 
    .sortable { font-family: "Lucida Sans Unicode", "Lucida Grande", Sans-Serif; font-size: 12px; width: 93%; text-align: left;border-collapse: collapse; }
    .sortable td { padding: 4px; background: #FFFFFF; border: 1px solid #b9c9fe; color: #669; white-space:nowrap; }
    .sortable .titulo > td { padding: 8px; font-size: 13px; color: #039; font-weight: bold; border-left: 0; border-right: 0; border-top: 0; padding-top: 16px; }
    .sortable .categoria > td { background-color: #E0E7FF; } 
    .sortable .categoria .codCateg { mso-number-format:\@; text-align: center; }
</style>

<cfif rsEscalaSalarial.recordcount>   
    <cfset cols = getColsEncab(rsEscalaSalarial) + 2> 
    <cfif compare(vFormato,'excel') eq 0 >  
        <cf_EncReporte Titulo="#LB_ReporteEscalaSalarialSalarioPensionable#" Color="##E3EDEF" filtro1="#filtro1#" filtro2= "#filtro2#" cols="#cols#">
        <cfoutput>#getHTML(rsEscalaSalarial, cols)#</cfoutput>
    <cfelseif compare(vFormato,'html') eq 0 >   
        <cf_EncReporte Titulo="#LB_ReporteEscalaSalarialSalarioPensionable#" Color="##E3EDEF" filtro1="#filtro1#" filtro2= "#filtro2#"> 
        <cfoutput>#getHTML(rsEscalaSalarial, cols)#</cfoutput>  
    </cfif>
<cfelse>     
    <cf_EncReporte Titulo="#LB_ReporteEscalaSalarialSalarioPensionable#" Color="##E3EDEF" filtro1="#filtro1#"> 
    <div align="center" style="margin: 15px 0 15px 0"> --- <b><cfoutput>#LB_NoExistenRegistrosQueMostrar#</cfoutput></b> ---</div>
</cfif>


<cffunction name="getColsEncab" returntype="Numeric">
    <cfargument name="rsEscalaSalarial" type="query" required="true">

    <cfquery name="rs" dbtype="query" maxrows="1">
        select max(count(RHCcodigo)) as cantidad 
        from Arguments.rsEscalaSalarial
        group by tablaVigTC, RHCcodigoPadre
    </cfquery>

    <cfreturn rs.cantidad - 1 >
</cffunction>


<cffunction name="getFiltroEncab" returntype="query">
    <cf_translatedata name="get" tabla="RHVigenciasTabla" col="vt.RHVTdescripcion" returnvariable="LVarRHVTdescripcion">
    <cf_translatedata name="get" tabla="RHTTablaSalarial" col="ts.RHTTdescripcion" returnvariable="LVarRHTTdescripcion">
    <cfquery name="rsFiltroEncab" datasource="#session.DSN#">
        select ts.RHTTcodigo, #LVarRHTTdescripcion# as RHTTdescripcion, vt.RHVTcodigo, #LVarRHVTdescripcion# as RHVTdescripcion, coalesce(vt.RHVTtipocambio,1) as RHVTtipocambio
        ,vt.RHVTfecharige, vt.RHVTfechahasta, ot.orden
        from RHVigenciasTabla vt 
        inner join RHTTablaSalarial ts
            on vt.RHTTid = ts.RHTTid
            and vt.Ecodigo = ts.Ecodigo
        <!--- 20160927-ljimenez  se genera un columna orden para mostrar las tablas salariales segun sean agregadas en el filtro 
              20170926 mparra se quitan parentesis del union pues el motor de db no reconocia al alias ot si estaba el select dentro de 2 parentesis
        --->
        inner join (<cfloop from="1" to="#ArrayLen(aRHTTid)#" index="i">
                                select  <cfqueryparam cfsqltype="cf_sql_numeric" value="#aRHTTid[i]#">  as RHTTid
                                ,<cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">   as orden
                                from dual 
                                <cfif ArrayLen(aRHTTid) neq i > union  </cfif>
                            </cfloop>
                    ) ot
            on ts.RHTTid = ot.RHTTid
        where
            ts.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
            <cfif isdefined("aRHTTid") and isdefined("aRHVTid") >
            and(
                <cfloop from="1" to="#ArrayLen(aRHTTid)#" index="i">
                    (ts.RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#aRHTTid[i]#"> 
                    and vt.RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#aRHVTid[i]#">)
                    <cfif ArrayLen(aRHTTid) neq i > or </cfif>
                </cfloop>                      
                )
            </cfif>    
        order by ot.orden, ts.RHTTcodigo, #LVarRHTTdescripcion#
    </cfquery>

    <cfreturn rsFiltroEncab>
</cffunction>


<cffunction name="getQuery" returntype="query">   
    <cf_dbfunction name="op_concat" returnvariable="concat"> 
    <cf_dbfunction name="to_char" args="ts.RHTTcodigo" returnvariable="vRHTTcodigo">
    <cf_dbfunction name="to_char" args="vt.RHVTcodigo" returnvariable="vRHVTcodigo">
    <cf_dbfunction name="to_char" args="vt.RHVTtipocambio" returnvariable="vRHVTtipocambio">

    <cf_translatedata name="get" tabla="RHVigenciasTabla" col="vt.RHVTdescripcion" returnvariable="LVarRHVTdescripcion">
    <cf_translatedata name="get" tabla="RHTTablaSalarial" col="ts.RHTTdescripcion" returnvariable="LVarRHTTdescripcion">
    <cf_translatedata name="get" tabla="RHCategoria" col="c.RHCdescripcion" returnvariable="LVarRHCdescripcionC">
    <cf_translatedata name="get" tabla="RHCategoria" col="cp.RHCdescripcion" returnvariable="LVarRHCdescripcionCP">


   <!---20150623-ljimenez se agrega un orden convertido a numero ya que esun campo tipo texto salen desordenados ITCR
    se cambia el inner por un left ya que en el caso del itcr el campo RHCidpadre es nulo--->

    <cfquery name="rsEscalaSalarial" datasource="#session.dsn#">  
        select 
            #vRHTTcodigo# #concat#' - '#concat# #LVarRHTTdescripcion# #concat#' - ' #concat#
            #LVarRHVTdescripcion# #concat# case when coalesce(vt.RHVTtipocambio,1) > 1 then ' (TC: ' #concat# #vRHVTtipocambio# #concat# ')' else '' end as tablaVigTC, 
            mc.RHCid, mc.RHMCid, mc.RHVTid, mc.RHMCmonto, 
            left(ltrim(c.RHCcodigo),2) #concat#' - '#concat# right(rtrim(c.RHCcodigo),2) as RHCcodigo, 
           #LVarRHCdescripcionC# as RHCdescripcion, c.nivel, c.RHCidpadre, cp.RHCcodigo as RHCcodigoPadre,
            #LVarRHCdescripcionCP# as RHCdescripcionPadre, coalesce(vt.RHVTtipocambio,1) as RHVTtipocambio
            ,c.RHCcodigo as RHCcodigoOrden
            ,RHVTfecharige as rige
            , 
            ot.orden

        from RHMontosCategoria mc
        inner join RHCategoria c
            on mc.RHCid = c.RHCid
        inner join RHVigenciasTabla vt
            on mc.RHVTid = vt.RHVTid    
            inner join RHTTablaSalarial ts
                on vt.RHTTid = ts.RHTTid
                and vt.Ecodigo = ts.Ecodigo

            <!--- 20160927-ljimenez  se genera un columna orden para mostrar las tablas salariales segun sean agregadas en el filtro --->
            inner join ( <cfloop from="1" to="#ArrayLen(aRHTTid)#" index="i">
                                    select  <cfqueryparam cfsqltype="cf_sql_numeric" value="#aRHTTid[i]#">  as RHTTid
                                    ,<cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">   as orden
                                    from dual 
                                    <cfif ArrayLen(aRHTTid) neq i > union  </cfif>
                                </cfloop>
                        ) ot
            on ts.RHTTid = ot.RHTTid
        left join RHCategoria cp
            on c.RHCidpadre = cp.RHCid
            
        where ts.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
            <cfif isdefined("aRHTTid") and isdefined("aRHVTid") >
            and(
                <cfloop from="1" to="#ArrayLen(aRHTTid)#" index="i">
                    (ts.RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#aRHTTid[i]#"> 
                    and vt.RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#aRHVTid[i]#">)
                    <cfif ArrayLen(aRHTTid) neq i > or </cfif>
                </cfloop>                      
                )
            </cfif>       
    </cfquery> 

    
    
    <cfquery name="rsEscalaSalarial" dbtype="query">
        select *
        from rsEscalaSalarial
        order by orden,  RHCcodigoPadre,  RHCcodigoOrden
    </cfquery>
    <cfreturn rsEscalaSalarial>
</cffunction>


<cffunction name="getHTML" output="true">   
    <cfargument name="rsEscalaSalarial" type="query" required="true">
    <cfargument name="cols" type="numeric" required="true"> 


    <table class="sortable" border="0">
        <cfoutput query="Arguments.rsEscalaSalarial" group="tablaVigTC">
            <tr class="titulo"><td colspan="#Arguments.cols#"><strong>#tablaVigTC#</strong></td></tr>
            <cfoutput group="RHCcodigoPadre">
                <tr class="categoria">
                    <td><strong>#RHCdescripcionPadre#</strong></td> 
                    <cfoutput group="RHCcodigo">
                        <td class="codCateg"><strong>#RHCcodigo#</strong></td> 
                    </cfoutput>    
                </tr>   
                <tr>
                    <td>#LB_SalarioBasicoAnual#($)</td> 
                    <cfoutput group="RHCcodigo">
                        <td align="right">
                            <cf_locale name="number" value="#(RHMCmonto/RHVTtipocambio)*12#"/>
                        </td> 
                    </cfoutput>
                </tr>
                <tr>
                    <td>Remuneración pensionable</td> 
                    <cfoutput group="RHCcodigo">
                        <td align="right">
                            <cfset montoPensionable = getSalarioPensionable((RHMCmonto/RHVTtipocambio)*12, Arguments.rsEscalaSalarial.Rige)>
                            <cf_locale name="number" value="#montoPensionable#"/>
                        </td> 
                    </cfoutput>
                </tr>       
            </cfoutput>
        </cfoutput> 
    </table>
</cffunction>    

<cffunction name="getSalarioPensionable" returntype="Numeric">
    <cfargument name="LvarMonto"    type="numeric" required="true">
    <cfargument name="LvarRige"     type="date" required="true">

    <cfquery name="rsPensionable" datasource="#session.DSN#">
        select  ((#Arguments.LvarMonto# - b.DCTDconstante) / b.DCTDfactor) as pensionable , b.DCTDconstante, b.DCTDfactor
        from DCargasTablaE a
        inner join DCargasTablaD b
            on b.DCTEid = a.DCTEid
        where <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#Arguments.LvarRige#">  between a.DCTEdesde and a.DCTEhasta 
            and a.Ecodigo = #session.Ecodigo#
            and <cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.LvarMonto#"> between DCTDmin and DCTDmax
    </cfquery>

    <cfif isDefined('rsPensionable') and rsPensionable.recordcount gt 0>
        <cfreturn rsPensionable.pensionable>        
    <cfelse>
        <cfreturn 0>    
    </cfif>
</cffunction>


    
    
