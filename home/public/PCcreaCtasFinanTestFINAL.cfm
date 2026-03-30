<cfprocessingdirective suppresswhitespace="yes">
    <cfsilent>
        <cfset LvarPRESUPUESTO = true>
        
        <cfsetting requesttimeout="36000">
        <cfif not isdefined("url.Cmayor") OR url.Cmayor EQ "">
            <cfthrow message="Falta indicar cuenta mayor">
        </cfif>
        <cfquery name="rsMayor" datasource="minisif_tav">
            select c.Cmayor, c.Cdescripcion, c.PCEMid, m.PCEMplanCtas
              from CtasMayor c
                inner join PCEMascaras m 
                 on m.PCEMid = c.PCEMid
             where c.Ecodigo	= 1213
               and c.Cmayor		= '#url.Cmayor#'
        </cfquery>
        <!--- <cfdump var="#rsMayor#"> --->
        
        <cfif rsMayor.Cmayor EQ "">
            <cfthrow message="Cuenta mayor no existe">
        </cfif>
        
        <cfif rsMayor.PCEMplanCtas NEQ "1">
            <cfthrow message="Cuenta mayor no tiene plan de cuentas">
        </cfif>
        
        <cfquery name="rsNiveles" datasource="minisif_tav">
            select PCNid, PCEcatid, PCNdep, PCNlongitud, PCNcontabilidad, PCNpresupuesto
              from PCNivelMascara m 
             where m.PCEMid = #rsMayor.PCEMid#
            order by PCNid
        </cfquery>
        <!--- <cfdump var="#rsNiveles#"> --->
        
        
        <cf_dbtemp name="Gctas_V0" returnvariable="CTAS" datasource="minisif_tav" temp="false">
            <cf_dbtempcol name="formato"	    type="varchar(100)"	mandatory="yes">
            <cf_dbtempcol name="des"			type="varchar(900)"	mandatory="no">
            <cf_dbtempcol name="niv"	    	type="integer"		mandatory="yes">
            <cf_dbtempcol name="ref"			type="numeric"		mandatory="no">
        
            <cf_dbtempindex cols="ref,niv,formato">
            <cf_dbtempindex cols="niv,formato">
            <cf_dbtempindex cols="ref">
            <cf_dbtempindex cols="formato">
             <cf_dbtempindex cols="formato,niv">
            
        </cf_dbtemp>
        
        <!--- Inserta nivel 0 = Cta Mayor --->
        <cfquery datasource="minisif_tav">
            insert into #CTAS#
                ( formato, des, niv, ref )
            values ('#rsMayor.Cmayor#', '#rsMayor.Cdescripcion#', 0, null)
        </cfquery>
        
        
        <cf_dbfunction name="OP_concat" returnvariable="CONCAT" datasource="minisif_tav">
        <cf_dbfunction name="FN_substr" returnvariable="SUBSTR" datasource="minisif_tav">
        
        <cfset LvarConversion = "#SUBSTR#(formato,1,4)">
        <cfset LvarPto=5>
        <cfset LvarSubstituir = false>
        <cfloop query="rsNiveles">
        	<cfset LvarPCNpresupuesto = rsNiveles.PCNpresupuesto>
            <cfset LvarPCNlongitud = rsNiveles.PCNlongitud>
            <cfset LvarNiv = rsNiveles.PCNid>
            <cfset LvarPCNdep = rsNiveles.PCNdep>
            <cfset LvarPCEcatid = rsNiveles.PCEcatid>
            
            <cfif LvarPCNpresupuesto EQ 1>
                <cfset LvarConversion &= " #CONCAT# #SUBSTR#(formato,#LvarPto#,#LvarPCNlongitud+1#)">
            <cfelseif isdefined("LvarPRESUPUESTO")>
                <cfset LvarSubstituir = true>
            </cfif>
            <cfset LvarPto += LvarPCNlongitud+1>
        

            <cfset LvarNivA = LvarNiv - 1>
        
            <!--- Inserta nivel PCNid --->
            <cfif LvarPCNdep EQ "">
                <!--- <cfoutput>entra linea 68</cfoutput><br /> --->
                <cfquery datasource="minisif_tav">
                    insert into #CTAS#
                        ( formato, des, niv, ref )
                    select   c.formato 	#CONCAT# '-' #CONCAT# v.PCDvalor
                            ,c.des 		
                                <cfif NOT LvarSubstituir OR LvarPCNpresupuesto EQ 1>
                                    #CONCAT# ', ' #CONCAT# v.PCDdescripcion
                                </cfif>
                            ,#LvarNiv#, v.PCEcatidref
                      from #CTAS# c
                        inner join PCDCatalogo v
                             on PCEcatid = #LvarPCEcatid#
                            and (v.Ecodigo is null or v.Ecodigo = 1213)
                     where c.niv = #LvarNivA#
                </cfquery>
                <!--- <cfquery name="rs1" datasource="minisif_tav">
                    select   c.formato 	#CONCAT# '-' #CONCAT# v.PCDvalor
                            ,c.des 		
                                <cfif NOT LvarSubstituir OR rsNiveles.PCNpresupuesto EQ 1>
                                    #CONCAT# ', ' #CONCAT# v.PCDdescripcion
                                </cfif>
                            ,#LvarNiv#, v.PCEcatidref
                      from #CTAS# c
                        inner join PCDCatalogo v
                             on PCEcatid = #rsNiveles.PCEcatid#
                            and (v.Ecodigo is null or v.Ecodigo = #session.Ecodigo#)
                     where c.niv = #LvarNivA#
                </cfquery>
                <cfdump var="#rs1#"> --->
                
            <cfelse>
                <!--- <cfoutput>Entra línea 85</cfoutput><br /> --->
                <cfquery datasource="minisif_tav">
                    insert into #CTAS#
                        ( formato, des, niv, ref )
                    select  c.formato #CONCAT# '-' #CONCAT# v.PCDvalor
                            ,c.des 		
                                <cfif NOT LvarSubstituir OR LvarPCNpresupuesto EQ 1>
                                    #CONCAT# ', ' #CONCAT# v.PCDdescripcion
                                </cfif>
                            ,#LvarNiv#, v.PCEcatidref
                      from #CTAS# c
                        inner join #CTAS# d
                            inner join PCDCatalogo v (index PCDCatalogo_FI02)
                                 on v.PCEcatid = d.ref
                                and (v.Ecodigo is null or v.Ecodigo = 1213)
                             on d.niv = #LvarPCNdep#
                             and c.formato like d.formato #CONCAT# '%'
                     where c.niv = #LvarNivA#
                </cfquery>
                <!--- <cfquery name="rs2" datasource="minisif_tav">
                    select   c.formato 	#CONCAT# '-' #CONCAT# v.PCDvalor
                            ,c.des 		
                                <cfif NOT LvarSubstituir OR rsNiveles.PCNpresupuesto EQ 1>
                                    #CONCAT# ', ' #CONCAT# v.PCDdescripcion
                                </cfif>
                            ,#LvarNiv#, v.PCEcatidref
                      from #CTAS# c
                        inner join #CTAS# d
                            inner join PCDCatalogo v
                                 on PCEcatid = d.ref
                                and (v.Ecodigo is null or v.Ecodigo = #session.Ecodigo#)
                             on d.niv = #rsNiveles.PCNdep#
                             and c.formato like d.formato #CONCAT# '%'
                     where c.niv = #LvarNivA#
                </cfquery>
                <cfdump var="#rs2#"> --->
            </cfif>
            <cfquery datasource="minisif_tav">
	            dump tran minisif_tav with truncate_only
            </cfquery>
        </cfloop>
        
        <!--- <cfquery name="rs" datasource="minisif_tav">
            select * from #CTAS#
        </cfquery>
        <cfdump var="#rs#"> --->
        
        
        
        <cfquery datasource="minisif_tav">
            delete from #CTAS#
             where niv < #rsNiveles.recordCount#
        </cfquery>
        
        <cfif LvarSubstituir>
            <!--- <cfoutput>Entra linea 120</cfoutput><br /> --->
            <cfquery name="rsSQL" datasource="minisif_tav">
                update #CTAS#
                   set formato = #LvarConversion#
            </cfquery>
            <cfquery name="rsSQL" datasource="minisif_tav">
                select formato, min(des) as descripcion
                  from #CTAS#
                group by formato
            </cfquery>
        <cfelse>
            <!--- <cfoutput>Entra línea 131</cfoutput><br /> --->
            <cfquery name="rsSQL" datasource="minisif_tav">
                select formato, des as descripcion
                  from #CTAS#
                 order by formato
            </cfquery>
        </cfif>
    </cfsilent>
</cfprocessingdirective>
<!--- <cfquery name="rsSQL" datasource="minisif_tav">
    select formato, min(des) as descripcion
      from Gctas_V0
    group by formato
</cfquery> --->
<!--- <cfdump var="#rsSQL#"> --->
<cfif rsSQL.recordcount gt 0>
	<!--- <cf_queryToFile query="#rsSQL#" filename="ctasPresupuesto.xls"> --->
    <cfoutput>Ya estan los datos en la tabla</cfoutput>
<cfelse>
	<cfoutput><strong>No se generaron registros que exportar</strong></cfoutput>
</cfif>