<cfcomponent>
 <cffunction name="RetornaXML" access="remote"  returntype="xml"    output="no">
        <cfargument name="Ecodigo" type="string"    required="yes">  
        <cfargument name="DEid"    type="string"    required="yes">
        <cfargument name="Puesto"  type="string"    required="yes">
			<cfset Var xmlDoc = "">
            <cfset Var partnerList = "">
            <cfquery datasource="minisif" name="partnerList">
                select top 8
                    b.RHHcodigo as CodigoRS, 
                    b.RHHdescripcion as DescripcionRS, 
                    coalesce(c.RHHpeso,0) - (coalesce(c.RHHpeso,0) *a.RHCEdominio/100) as FaltaRS, 
                    100 - a.RHCEdominio as BrechaRS, 
                    coalesce(c.RHHpeso,0) as PesoRS,  
                    c.RHHpeso - (c.RHHpeso - (c.RHHpeso * a.RHCEdominio / 100)) as PoseeRS,
                    a.RHCEdominio as CumplimientoRS,
                    a.DEid as DEidRS,
                    lt.RHPcodigo as PuestoRS,
                    de.DEnombre || ' ' || de.DEapellido1 || ' ' || de.DEapellido2 as NombreERS,
                    p.RHPdescpuesto as NombrePRS
                from RHCompetenciasEmpleado a
                inner join DatosEmpleado de 
                    on de.DEid = a.DEid
                inner join LineaTiempo lt
                  on lt.DEid = a.DEid
                  and getdate() between lt.LTdesde and lt.LThasta
                  and a.Ecodigo = lt.Ecodigo
                inner join RHPuestos p
                    on lt.RHPcodigo = p.RHPcodigo
                    and p.Ecodigo = lt.Ecodigo
                inner join RHHabilidades b
                on a.Ecodigo=b.Ecodigo
                and a.idcompetencia=b.RHHid
                left outer join RHHabilidadesPuesto c
                  on a.Ecodigo = c.Ecodigo
                  and b.RHHid = c.RHHid
                  and c.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Puesto#">
                where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
                and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
                and a.tipo='H'
                and getdate() between a.RHCEfdesde and a.RHCEfhasta
                and coalesce(c.RHHpeso,0) - (coalesce(c.RHHpeso,0) *a.RHCEdominio/100) > 0
                order by c.RHHpeso desc
             </cfquery>

            <cfsavecontent variable="xmlDoc">
                <data>
                    <cfoutput>
                    <variable name="#xmlformat('BrechaCapacitacion')#">
                    <row>
                        <column>#xmlformat("Codigo")#</column>
                        <column>#xmlformat("Decripcion")#</column>
                        <column>#xmlformat("Falta")#</column>
                        <column>#xmlformat("Brecha")#</column>
                        <column>#xmlformat("Peso")#</column>
                        <column>#xmlformat("Posee")#</column>
                        <column>#xmlformat("Cumplimiento")#</column>
                        <column>#xmlformat("DEid")#</column>
                        <column>#xmlformat("Puesto")#</column>
                        <column>#xmlformat("NombreE")#</column>
                        <column>#xmlformat("NombreP")#</column>
                    </row>
                   
					   <cfif partnerList.recordCount GT 0>
                        
                        <cfloop query="partnerList">
                            <row>
                                <column>#xmlformat(partnerList.CodigoRS)#</column>
                                <column>#xmlformat(partnerList.DescripcionRS)#</column>
                                <column>#xmlformat(partnerList.FaltaRS)#</column>
                                <column>#xmlformat(partnerList.BrechaRS)#</column>
                                <column>#xmlformat(partnerList.PesoRS)#</column>
                                <column>#xmlformat(partnerList.PoseeRS)#</column>
                                <column>#xmlformat(partnerList.CumplimientoRS)#</column>
                                <column>#xmlformat(partnerList.DEidRS)#</column>
                                <column>#xmlformat(partnerList.PuestoRS)#</column>
                                <column>#xmlformat(partnerList.NombreERS)#</column>
                                <column>#xmlformat(partnerList.NombrePRS)#</column>
                            </row>
                        </cfloop>
                       </cfif> 
                    </cfoutput>
                </variable>
                 <cfoutput>
                    <variable name="#xmlformat('Puesto')#">
                    <row>
                        <column>#xmlformat(Arguments.Puesto)#</column>
                    </row>
                    </variable>
                    <variable name="#xmlformat('Empleado')#">
                    <row>
                        <column>#xmlformat(Arguments.DEid)#</column>
                    </row>
                    </variable>
                   </cfoutput>
              </data>
            </cfsavecontent>
        <cfreturn xmlDoc>
    </cffunction>
</cfcomponent>    
    

