<cfif isdefined("session.Usulogin") and len(trim(session.Usulogin))>
	

    <cf_dbfunction name="now" returnvariable="hoy">
    <!--- Empleados que se encuentran inactivos en el vale --->
    <cfquery name="rsInactivos" datasource="#session.DSN#">
    	select 
        	a.AFRid,
        	a.DEid, 
            c.CFid,
            c.CFcodigo + ' ' + c.CFdescripcion as CFcodigo,
            b.DEidentificacion + ' ' + b.DEnombre + ' ' + b.DEapellido1 + ' ' + b.DEapellido2 as Empleado,
            a1.Aplaca
    	from AFResponsables a 
            inner join Activos a1
                on a1.Aid = a.Aid
            inner join DatosEmpleado b
               	on b.DEid = a.DEid
            inner join CFuncional c
            	on c.CFid = a.CFid
        where a.Ecodigo = #session.Ecodigo#
          and a.AFRfini <= #hoy#
          and a.AFRffin >= #hoy#
          and #hoy# between a.AFRfini and a.AFRffin
		  and (	
	        select count(1) 
            from EmpleadoCFuncional b 
            where a.DEid = b.DEid 
            and a.Ecodigo = b.Ecodigo 
            and #hoy# between b.ECFdesde and b.ECFhasta
            ) = 0
          
    </cfquery>
    <cfdump var="#rsInactivos#" label="Inconsistentes">
    
    
	<cftransaction>
    	<cfloop query="rsInactivos">
        	<!--- Empleados Encargados del centro funcional vigentes--->
            <cfquery name="rsEncargados" datasource="#session.DSN#">
                select 
                    coalesce(min(a.DEid), -1) as DEid,
                    coalesce(min(b.DEidentificacion + ' ' + b.DEnombre + ' ' + b.DEapellido1 + ' ' + b.DEapellido2), 'No hay Encargado') as Empleado,
                    coalesce(min(c.CFcodigo + ' ' + c.CFdescripcion), 'No hay Encargado') as CFcodigo,
                    coalesce(min(c.CFid), -1) as CFid
                from EmpleadoCFuncional a 
                	inner join DatosEmpleado b
               			on b.DEid = a.DEid
                    inner join CFuncional c
                    	on c.CFid = a.CFid
                where a.Ecodigo = #session.Ecodigo#
                and a.CFid = #rsInactivos.CFid#
                and #hoy# between a.ECFdesde and a.ECFhasta
                and a.ECFencargado  = 1
            </cfquery>
            Empleado inactivo: <cfoutput>#rsInactivos.Empleado#</cfoutput> Centro Funcional del Vale: <cfoutput>#rsInactivos.CFcodigo#</cfoutput> Tiene asignado el activo con la placa: <cfoutput>#rsInactivos.Aplaca#</cfoutput><br />
            Empleado Encargado del Centro Funcional al que ser&aacute;n asignados los activos:  <cfoutput>#rsEncargados.Empleado#</cfoutput> Centro Funcional <cfoutput>#rsEncargados.CFcodigo#</cfoutput><br /><br />
            <!---<cfdump var="#rsEncargados#"><br />--->
			<cfif rsEncargados.DEid neq -1 and rsEncargados.CFid neq -1>
                <cfquery datasource="#session.DSN#">
                    update AFResponsables
                    set DEid = #rsEncargados.DEid#,
                    	CFid = #rsEncargados.CFid#
                    where AFRid = #rsInactivos.AFRid#
                </cfquery>
                Actualizado<br /><br />
            </cfif>
        </cfloop>
    
		<cftransaction action="commit"/>
        
        
        <cftransaction>
        	<cfquery datasource="#session.DNS#">
                update AFResponsables
                set CFid = (
                				select CFid
                                from EmpleadoCFuncional b
                                where AFResponsables.Ecodigo = b.Ecodigo 
                                  and AFResponsables.DEid = b.DEid 
                                  and AFResponsables.CFid = b.CFid 
                                  and getdate() between b.ECFdesde and b.ECFhasta 
                			)

            </cfquery>

        </cftransaction>
        
        
        
        
        
        <!--- <cfabort> --->
	</cftransaction>

    
   	Asignación de Activos a encargados de sucursal (cuando el empleado actual no está vigente) finalizada<br />
    <a href="/cfmx/home/menu/empresa.cfm">Regresar</a><br />
</cfif>