<cfsetting requesttimeout="36000">
<cf_dbtemp name="Gctas_V0" returnvariable="CTAS" datasource="#session.dsn#" temp="false">
	<cf_dbtempcol name="id"				type="numeric, identity"  	mandatory="yes" 
	<cf_dbtempcol name="formato"	    type="varchar(100)"			mandatory="yes">
	<cf_dbtempcol name="des"			type="varchar(900)"			mandatory="no">
	<cf_dbtempcol name="niv"	    	type="integer"				mandatory="yes">
	<cf_dbtempcol name="ref"			type="numeric"				mandatory="no">
	<cf_dbtempcol name="idpadre"		type="numeric"				mandatory="yes">

	<cf_dbtempindex cols="id">
	<cf_dbtempindex cols="niv">
</cf_dbtemp>

<cffunction name="fnProcesaMayor" output="no" access="private">
        <cfset LvarPRESUPUESTO = true>
        
        <cfif not isdefined("url.Cmayor") OR url.Cmayor EQ "">
            <cfthrow message="Falta indicar cuenta mayor">
        </cfif>
        <cfquery name="rsMayor" datasource="#session.dsn#">
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
        
        <cfquery name="rsNiveles" datasource="#session.dsn#">
            select PCNid, PCEcatid, PCNdep, PCNlongitud, PCNcontabilidad, PCNpresupuesto
              from PCNivelMascara m 
             where m.PCEMid = #rsMayor.PCEMid#
            order by PCNid
        </cfquery>
        <!--- <cfdump var="#rsNiveles#"> --->
        
        
        
        <!--- Inserta nivel 0 = Cta Mayor --->
        <cfquery datasource="#session.dsn#">
            insert into #CTAS#
                ( formato, des, niv, ref, idpadre )
            values ('#rsMayor.Cmayor#', '#rsMayor.Cdescripcion#', 0, null, 0)
        </cfquery>
        
        
        <cf_dbfunction name="OP_concat" returnvariable="CONCAT" datasource="#session.dsn#">
        <cf_dbfunction name="FN_substr" returnvariable="SUBSTR" datasource="#session.dsn#">
        
        <cfset LvarConversion = "#SUBSTR#(formato,1,4)">
        <cfset LvarPto=5>
        <cfset LvarSubstituir = false>
        <cfloop query="rsNiveles">
			<cfsilent>
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
        	</cfsilent>
            <!--- Inserta nivel PCNid --->
            <cfif LvarPCNdep EQ "">
                <!--- <cfoutput>entra linea 68</cfoutput><br /> --->
				<cfsilent>
                <cfquery datasource="#session.dsn#">
                    insert into #CTAS#
                        ( formato, des, niv, ref, idpadre )
                    select   c.formato 	#CONCAT# '-' #CONCAT# v.PCDvalor
                            ,c.des 		
                                <cfif NOT LvarSubstituir OR LvarPCNpresupuesto EQ 1>
                                    #CONCAT# ', ' #CONCAT# v.PCDdescripcion
                                </cfif>
                            ,#LvarNiv#, v.PCEcatidref, c.id
                      from #CTAS# c
                        inner join PCDCatalogo v
                             on PCEcatid = #LvarPCEcatid#
                            and (v.Ecodigo is null or v.Ecodigo = 1213)
                     where c.niv = #LvarNivA#
                </cfquery>
                <!--- <cfquery name="rs1" datasource="#session.dsn#">
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
                </cfsilent>
            <cfelse>
                <!--- <cfoutput>Entra línea 85</cfoutput><br /> --->
				<cfsilent>
				<cfquery datasource="#session.dsn#">
						insert into #CTAS#
							( formato, des, niv, ref, idpadre )
						select  c.formato #CONCAT# '-' #CONCAT# v.PCDvalor
								,c.des 		
									<cfif NOT LvarSubstituir OR LvarPCNpresupuesto EQ 1>
										#CONCAT# ', ' #CONCAT# v.PCDdescripcion
									</cfif>
								,#LvarNiv#, v.PCEcatidref, c.id
						  from #CTAS# c
							inner join #CTAS# d
								inner join PCDCatalogo v (index PCDCatalogo_FI02)
									 on v.PCEcatid = d.ref
									and (v.Ecodigo is null or v.Ecodigo = 1213)
								 on d.niv = #LvarPCNdep#
								 and d.id = c.idpadre
						 where c.niv = #LvarNivA#
				</cfquery>
				</cfsilent>
<!--- 
				<cfquery name="rs2" datasource="#session.dsn#">
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
				<cfdump var="#rs2#"> 
--->
            </cfif>
        </cfloop>

        <cfquery datasource="#session.dsn#">
            delete from #CTAS#
             where niv < #rsNiveles.recordCount#
        </cfquery>
        
        <cfif LvarSubstituir>
            <!--- <cfoutput>Entra linea 120</cfoutput><br /> --->
            <cfquery name="rsSQL" datasource="#session.dsn#">
                update #CTAS#
                   set formato = #LvarConversion#
            </cfquery>
            <cfquery name="rsSQL" datasource="#session.dsn#">
                select formato, min(des) as descripcion
                  from #CTAS#
                group by formato
            </cfquery>
        <cfelse>
            <!--- <cfoutput>Entra línea 131</cfoutput><br /> --->
            <cfquery name="rsSQL" datasource="#session.dsn#">
                select formato, des as descripcion
                  from #CTAS#
                 order by formato
            </cfquery>
        </cfif>
</cffunction>
<cfset fnProcesaMayor()>

<!--- <cfquery name="rsSQL" datasource="#session.dsn#">
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