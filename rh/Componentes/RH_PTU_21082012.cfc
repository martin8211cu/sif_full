<cfcomponent>
	<cffunction name="generarEmpleados" access="public" output="true" returntype="numeric"  hint="Generación de Empleados Para cálculo del PTU">
		<cfargument name="RHPTUEid" type="numeric" required="yes" hint="ID del encabezado del PTU (tab1)">
		<cfargument name="Ecodigo" type="numeric" required="no" default="#Session.Ecodigo#" hint="Empresa">
		<cfargument name="conexion" type="string" required="no" default="#Session.DSN#" hint="cache">
        <cfargument name="TransaccionActiva"  type="boolean" required="no" default="true">
        <cfargument name="validaTcodigo"  type="boolean" required="no" hint=" Codigo de la Nomina" default="false">
		
        <cfif Arguments.TransaccionActiva>
        	<cfset fnGenerarEmpleados(Arguments.RHPTUEid,Arguments.Ecodigo,Arguments.conexion,Arguments.validaTcodigo)>
        <cfelse>
            <cftransaction action="begin">
                <cfset fnGenerarEmpleados(Arguments.RHPTUEid,Arguments.Ecodigo,Arguments.conexion,Arguments.validaTcodigo)>
                <cftransaction action="commit"/>
            </cftransaction>	
        </cfif>	
		<cfset error = 0>
        <cfreturn error>
	</cffunction>
    
    <cffunction name="fnGenerarEmpleados" access="private" output="true" returntype="numeric"  hint="Privada - Generación de Empleados Para cálculo del PTU">
		<cfargument name="RHPTUEid" type="numeric" required="yes" hint="ID del encabezado del PTU (tab1)">
		<cfargument name="Ecodigo" type="numeric" required="no" default="#Session.Ecodigo#" hint="Empresa">
		<cfargument name="conexion" type="string" required="no" default="#Session.DSN#" hint="cache">
        <cfargument name="validaTcodigo"  type="boolean" required="no" hint=" Codigo de la Nomina" default="false">
			<!--- Eliminar Empleados que ya existiesen en la acción masiva --->
            <cfquery name="rsDelEmp" datasource="#Arguments.conexion#">
                delete from RHPTUEMpleados
                where RHPTUEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHPTUEid#">
            </cfquery>
            <cf_dbfunction name="now" returnvariable="lvarHoy">
            <cfif Arguments.validaTcodigo>
				<!--- Insertar Empleados que pertenecen a una nomina --->
                <cfquery name="rsDepen2" datasource="#Arguments.conexion#">
                    insert into RHPTUEMpleados (
                            DEid, 
                            RHPTUEid, 
                            Ecodigo, 
                            FechaDesde, 
                            FechaHasta, 
                            Dcodigo, 
                            Ocodigo, 
                            RHPcodigo, 
                            RHPTUEMfecha, 
                            BMUsucodigo)
            		select 	c.DEid, 
                            a.RHPTUEid, 
                            a.Ecodigo, 
                                <!---- ==== Para la fecha desde toma la mayor entre la fecha desde de la accion masiva y la fecha desde de la linea del tiempo ==== ----->
                            case when c.LTdesde <  a.FechaDesde then  a.FechaDesde else c.LTdesde end as FechaDesde,
                            <!---- ==== Para la fecha hasta toma la menor entre la fecha hasta de la accion masiva y la fecha hasta de la linea del tiempo ==== ----->
                            case when c.LThasta >  a.FechaHasta then  a.FechaHasta else c.LThasta end as FechaHasta,
                            b.Dcodigo, 
                            b.Ocodigo, 
                            b.RHPcodigo,
                            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
                            <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#"> as BMUsucodigo
                    from RHPTUE a
                        inner join RHPTUD b
                            on b.RHPTUEid = a.RHPTUEid
                        <!----- ==== Se pega con la línea del tiempo para utilizar la fecha del corte ==== ----->
                        inner join LineaTiempo c
                            on b.Ecodigo = c.Ecodigo
                            and a.FechaDesde between c.LTdesde and c.LThasta	
                                                    
                    where a.RHPTUEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHPTUEid#">
                    
                    and not exists (
                        select 1
                        from RHPTUEMpleados eam
                        where eam.RHPTUEid = a.RHPTUEid
                        and eam.DEid = c.DEid
                    )
                    <!--- Chequear que el empleado no se haya cambiado de empresa en ese rango de fechas --->
                    and (select count(distinct Ecodigo) 
                            from LineaTiempo lt 
                                    where lt.DEid = b.DEid 
                                    and (lt.LTdesde between a.FechaDesde 
                                                    and coalesce(a.FechaHasta, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime('01/01/6100')#">) 
                                                    or lt.LThasta between a.FechaDesde 
                                                    and coalesce(a.FechaHasta, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime('01/01/6100')#">))) <= 1
                  	and (exists (select 1 
                    			from LineaTiempo lts 
                                 where lts.DEid = c.DEid 
                                 and (lts.LTdesde between b.Fcorte and '61000101'
                                 or lts.LThasta between b.Fcorte and '61000101')
                                 and lts.Tcodigo = b.Tcodigo
                   		) or (b.Tcodigo is null and b.DEid is null and b.RHPcodigo is null and b.Dcodigo is null and b.Ocodigo is null and b.CFid is null and b.RHTPid is null))
                </cfquery>
            </cfif>
            <!--- Insertar Empleados seleccionados directamente si la acción NO TRABAJA CON PERIODOS --->
            <cfquery datasource="#Arguments.conexion#">
                    insert into RHPTUEMpleados (
                            DEid, 
                            RHPTUEid, 
                            Ecodigo, 
                            FechaDesde, 
                            FechaHasta, 
                            Dcodigo, 
                            Ocodigo, 
                            RHPcodigo, 
                            RHPTUEMfecha, 
                            BMUsucodigo)
                    select 	b.DEid, 
                            a.RHPTUEid, 
                            a.Ecodigo, 
                                <!---- ==== Para la fecha desde toma la mayor entre la fecha desde de la accion masiva y la fecha desde de la linea del tiempo ==== ----->
                            case when c.LTdesde <  a.FechaDesde then  a.FechaDesde else c.LTdesde end as FechaDesde,
                            <!---- ==== Para la fecha hasta toma la menor entre la fecha hasta de la accion masiva y la fecha hasta de la linea del tiempo ==== ----->
                            case when c.LThasta >  a.FechaHasta then  a.FechaHasta else c.LThasta end as FechaHasta,
                            b.Dcodigo, 
                            b.Ocodigo, 
                            b.RHPcodigo,
                            <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
                            <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#"> as BMUsucodigo
                    from RHPTUE a
                        inner join RHPTUD b
                            on b.RHPTUEid = a.RHPTUEid
                            and b.DEid is not null
                            and not exists (
                                select 1
                                from RHPTUEMpleados x
                                where x.RHPTUEid = a.RHPTUEid
                                and x.DEid = b.DEid
                            )
                        <!----- ==== Se pega con la línea del tiempo para utilizar la fecha del corte ==== ----->
                        inner join LineaTiempo c
                            on b.Ecodigo = c.Ecodigo
                            and b.DEid = c.DEid
                            and a.FechaDesde between c.LTdesde and c.LThasta	
                                                    
                    where a.RHPTUEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHPTUEid#">
                    
                    and not exists (
                        select 1
                        from RHPTUEMpleados eam
                        where eam.RHPTUEid = a.RHPTUEid
                        and eam.DEid = b.DEid
                    )
                    <!--- Chequear que el empleado no se haya cambiado de empresa en ese rango de fechas --->
                    and (select count(distinct Ecodigo) 
                            from LineaTiempo lt 
                                    where lt.DEid = b.DEid 
                                    and (lt.LTdesde between a.FechaDesde 
                                                    and coalesce(a.FechaHasta, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(6100, 01, 01)#">) 
                                                    or lt.LThasta between a.FechaDesde 
                                                    and coalesce(a.FechaHasta, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(6100, 01, 01)#">))) <= 1
            </cfquery>
        
            <!--- Insertar Empleados que tienen un puesto --->
            <cfquery datasource="#Arguments.conexion#">
                insert into RHPTUEMpleados (
                        DEid, 
                        RHPTUEid, 
                        Ecodigo, 
                        FechaDesde, 
                        FechaHasta, 
                        Dcodigo, 
                        Ocodigo, 
                        RHPcodigo, 
                        RHPTUEMfecha, 
                        BMUsucodigo)
                select 	c.DEid, 
                        a.RHPTUEid, 
                        a.Ecodigo, 
                        <!---- ==== Para la fecha desde toma la mayor entre la fecha desde de la accion masiva y la fecha desde de la linea del tiempo ==== ---->
                        case when c.LTdesde <  a.FechaDesde then  a.FechaDesde else c.LTdesde end as FechaDesde,
                        <!---- ==== Para la fecha hasta toma la menor entre la fecha hasta de la accion masiva y la fecha hasta de la linea del tiempo ==== ---->
                        case when c.LThasta >  a.FechaHasta then  a.FechaHasta else c.LThasta end as FechaHasta,					
                        b.Dcodigo, 
                        b.Ocodigo, 
                        b.RHPcodigo,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#"> as BMUsucodigo
                from RHPTUE a 
                    inner join RHPTUD b
                        on b.RHPTUEid = a.RHPTUEid
                        and b.RHPcodigo is not null
                    inner join LineaTiempo c
                        on c.Ecodigo = a.Ecodigo
                        <!--- and c.RHPcodigo = b.RHPcodigo --->
                        and a.FechaDesde between c.LTdesde and c.LThasta
                        and not exists (select 1
                                        from RHPTUEMpleados x
                                        where x.RHPTUEid = a.RHPTUEid
                                            and x.DEid = c.DEid
                                        )
                        <!----========= VALIDAR QUE LA PLAZA DE LOS EMPLEADOS EN EL RANGO DE FECHAS DE LA ACCION NO SEAN NEGOCIADAS ===========----->
                        and not exists (select 1 
                                        from  RHLineaTiempoPlaza d
                                        where c.RHPid = d.RHPid
                                            and d.RHMPnegociado = 'N'
                                            and a.FechaDesde <= d.RHLTPfhasta
                                            and a.FechaHasta >= d.RHLTPfdesde
                                        )
                        <!----=======================================================================================================---->							
                inner join RHPlazas pl
                    on pl.RHPid 	= c.RHPid
                    and    pl.RHPpuesto = b.RHPcodigo
                    and    pl.Ecodigo	= c.Ecodigo															
                where a.RHPTUEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHPTUEid#">
                and not exists (select 1
                                from RHPTUEMpleados eam
                                where eam.RHPTUEid = a.RHPTUEid
                                and eam.DEid = c.DEid)			
                <!--- Chequear que el empleado no se haya cambiado de empresa en ese rango de fechas --->
                and (select count(distinct Ecodigo) 
                	 from LineaTiempo lt 
                     where lt.DEid = c.DEid 
                     and (lt.LTdesde between a.FechaDesde 
                     				 and coalesce(a.FechaHasta, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(6100, 01, 01)#">) 
                                     or lt.LThasta between a.FechaDesde 
                                     			   and coalesce(a.FechaHasta, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(6100, 01, 01)#">))) <= 1
            	<cfif Arguments.validaTcodigo>
                and (exists (select 1 
                    			from LineaTiempo lts 
                                 where lts.DEid = c.DEid 
                                 and (lts.LTdesde between b.Fcorte and '61000101'
                                 or lts.LThasta between b.Fcorte and '61000101')
                                 and lts.Tcodigo = b.Tcodigo
                   		) or b.Tcodigo is null)
            	</cfif>
            </cfquery>
            
            <!--- Insertar Empleados que tienen un tipo de Puesto --->
            <cfquery datasource="#arguments.conexion#">
                insert into RHPTUEMpleados (
                        DEid, 
                        RHPTUEid, 
                        Ecodigo, 
                        FechaDesde, 
                        FechaHasta, 
                        Dcodigo, 
                        Ocodigo, 
                        RHPcodigo, 
                        RHPTUEMfecha, 
                        BMUsucodigo)
                select 	c.DEid, 
                        a.RHPTUEid, 
                        a.Ecodigo, 
                        <!---- ==== Para la fecha desde toma la mayor entre la fecha desde de la accion masiva y la fecha desde de la linea del tiempo ==== ---->
                        case when c.LTdesde <  a.FechaDesde then  a.FechaDesde else c.LTdesde end as FechaDesde,
                        <!---- ==== Para la fecha hasta toma la menor entre la fecha hasta de la accion masiva y la fecha hasta de la linea del tiempo ==== ---->
                        case when c.LThasta >  a.FechaHasta then  a.FechaHasta else c.LThasta end as FechaHasta,					
                        b.Dcodigo, 
                        b.Ocodigo, 
                        b.RHPcodigo,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#"> as BMUsucodigo
                from RHPTUE a 
                    inner join RHPTUD b
                        on b.RHPTUEid = a.RHPTUEid
                        and b.RHTPid is not null
                    inner join LineaTiempo c
                        on c.Ecodigo = a.Ecodigo
                        <!--- and c.RHPcodigo = b.RHPcodigo --->
                        and a.FechaDesde between c.LTdesde and c.LThasta
                        and not exists (select 1
                                        from RHPTUEMpleados x
                                        where x.RHPTUEid = a.RHPTUEid
                                            and x.DEid = c.DEid
                                        )
                        <!----========= VALIDAR QUE LA PLAZA DE LOS EMPLEADOS EN EL RANGO DE FECHAS DE LA ACCION NO SEAN NEGOCIADAS ===========----->
                        and not exists (select 1 
                                        from  RHLineaTiempoPlaza d
                                        where c.RHPid = d.RHPid
                                            and d.RHMPnegociado = 'N'
                                            and a.FechaDesde <= d.RHLTPfhasta
                                            and a.FechaHasta >= d.RHLTPfdesde
                                        )
                        <!----=======================================================================================================---->							
                        inner join RHPlazas pl
                            on pl.Ecodigo = c.Ecodigo
                             and pl.RHPid = c.RHPid
                        inner join RHPuestos p
                            on p.Ecodigo = pl.Ecodigo
                            and p.RHPcodigo = pl.RHPpuesto
                        inner join RHTPuestos t
                            on t.RHTPid = p.RHTPid
                            and t.RHTPid = b.RHTPid															
                where a.RHPTUEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHPTUEid#">
                and not exists (select 1
                                from RHPTUEMpleados eam
                                where eam.RHPTUEid = a.RHPTUEid
                                and eam.DEid = c.DEid)			
                <!--- Chequear que el empleado no se haya cambiado de empresa en ese rango de fechas --->
                and (select count(distinct Ecodigo) from LineaTiempo lt where lt.DEid = c.DEid and (lt.LTdesde between a.FechaDesde and coalesce(a.FechaHasta, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(6100, 01, 01)#">) or lt.LThasta between a.FechaDesde and coalesce(a.FechaHasta, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(6100, 01, 01)#">))) <= 1
            	<cfif Arguments.validaTcodigo>
                and (exists (select 1 
                    			from LineaTiempo lts 
                                 where lts.DEid = c.DEid 
                                 and (lts.LTdesde between b.Fcorte and '61000101'
                                 or lts.LThasta between b.Fcorte and '61000101')
                                 and lts.Tcodigo = b.Tcodigo
                   		) or b.Tcodigo is null)
            	</cfif>
            </cfquery>
            
            <!--- Insertar Empleados que pertenecen a un Depto y Oficina --->
            <cfquery datasource="#Arguments.conexion#">
                insert into RHPTUEMpleados (
                        DEid, 
                        RHPTUEid, 
                        Ecodigo, 
                        FechaDesde, 
                        FechaHasta, 
                        Dcodigo, 
                        Ocodigo, 
                        RHPcodigo, 
                        RHPTUEMfecha, 
                        BMUsucodigo)
                select 	c.DEid, 
                        a.RHPTUEid, 
                        a.Ecodigo, 
                        <!---- ==== Para la fecha desde toma la mayor entre la fecha desde de la accion masiva y la fecha desde de la linea del tiempo ==== ---->
                        case when c.LTdesde <  a.FechaDesde then  a.FechaDesde else c.LTdesde end as FechaDesde,
                        <!---- ==== Para la fecha hasta toma la menor entre la fecha hasta de la accion masiva y la fecha hasta de la linea del tiempo ==== ---->
                        case when c.LThasta >  a.FechaHasta then  a.FechaHasta else c.LThasta end as FechaHasta, 
                        b.Dcodigo, 
                        b.Ocodigo, 
                        b.RHPcodigo,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#"> as BMUsucodigo
                from RHPTUE a
                    inner join RHPTUD b
                        on b.RHPTUEid = a.RHPTUEid
                        and b.Dcodigo is not null
                        and b.Ocodigo is not null
                    inner join LineaTiempo c
                        on c.Ecodigo = a.Ecodigo
                        and c.Dcodigo = b.Dcodigo
                        and c.Ocodigo = b.Ocodigo
                        and a.FechaDesde between c.LTdesde and c.LThasta
                        and not exists (
                            select 1
                            from RHPTUEMpleados x
                            where x.RHPTUEid = a.RHPTUEid
                            and x.DEid = c.DEid
                        )
                        <!----========= VALIDAR QUE LA PLAZA DE LOS EMPLEADOS EN EL RANGO DE FECHAS DE LA ACCION NO SEAN NEGOCIADAS ===========----->
                        and not exists (select 1 
                                        from  RHLineaTiempoPlaza d
                                        where c.RHPid = d.RHPid
                                            and d.RHMPnegociado = 'N'
                                            and a.FechaDesde <= d.RHLTPfhasta
                                            and a.FechaHasta >= d.RHLTPfdesde
                                        )
                        <!----=======================================================================================================---->
                where a.RHPTUEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHPTUEid#">
                and not exists (
                    select 1
                    from RHPTUEMpleados eam
                    where eam.RHPTUEid = a.RHPTUEid
                    and eam.DEid = c.DEid
                )
                <!--- Chequear que el empleado no se haya cambiado de empresa en ese rango de fechas --->
                and (select count(distinct Ecodigo) from LineaTiempo lt where lt.DEid = c.DEid and (lt.LTdesde between a.FechaDesde and coalesce(a.FechaHasta, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(6100, 01, 01)#">) or lt.LThasta between a.FechaDesde and coalesce(a.FechaHasta, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(6100, 01, 01)#">))) <= 1
            	<cfif Arguments.validaTcodigo>
                and (exists (select 1 
                    			from LineaTiempo lts 
                                 where lts.DEid = c.DEid 
                                 and (lts.LTdesde between b.Fcorte and '61000101'
                                 or lts.LThasta between b.Fcorte and '61000101')
                                 and lts.Tcodigo = b.Tcodigo
                   		) or b.Tcodigo is null)
            	</cfif>
            </cfquery>
    
            <!--- Insertar Empleados que pertenecen a un Centro Funcional --->
            <cfquery datasource="#Arguments.conexion#">
                insert into RHPTUEMpleados (
                        DEid, 
                        RHPTUEid, 
                        Ecodigo, 
                        FechaDesde, 
                        FechaHasta, 
                        Dcodigo, 
                        Ocodigo, 
                        RHPcodigo, 
                        RHPTUEMfecha, 
                        BMUsucodigo)
                select 	c.DEid, 
                        a.RHPTUEid, 
                        a.Ecodigo, 
                        <!---- ==== Para la fecha desde toma la mayor entre la fecha desde de la accion masiva y la fecha desde de la linea del tiempo ==== ---->
                        case when c.LTdesde <  a.FechaDesde then  a.FechaDesde else c.LTdesde end as FechaDesde,
                        <!---- ==== Para la fecha hasta toma la menor entre la fecha hasta de la accion masiva y la fecha hasta de la linea del tiempo ==== ---->
                        case when c.LThasta >  a.FechaHasta then  a.FechaHasta else c.LThasta end as FechaHasta,
                        b.Dcodigo, 
                        b.Ocodigo, 
                        b.RHPcodigo,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#"> as BMUsucodigo
                from RHPTUE a
                    inner join RHPTUD b
                        on b.RHPTUEid = a.RHPTUEid
                        and b.CFid is not null
                    inner join LineaTiempo c
                        on c.Ecodigo = a.Ecodigo
                        and a.FechaDesde between c.LTdesde and c.LThasta
                        and not exists (
                            select 1
                            from RHPTUEMpleados x
                            where x.RHPTUEid = a.RHPTUEid
                            and x.DEid = c.DEid
                        )
                    inner join RHPlazas d
                        on d.Ecodigo = c.Ecodigo
                        and d.RHPid = c.RHPid
                        and d.CFid = b.CFid
                        <!----========= VALIDAR QUE LA PLAZA DE LOS EMPLEADOS EN LA FECHA DE LA ACCION NO SEAN NEGOCIADAS ===========----->
                        and not exists( select 1 from  RHLineaTiempoPlaza e
                                        where d.RHPid = e.RHPid	
                                            and e.RHMPnegociado = 'N'
                                            and a.FechaDesde <= e.RHLTPfhasta
                                            and a.FechaHasta >= e.RHLTPfdesde
                                        )
                        <!----=======================================================================================================---->				
    
                where a.RHPTUEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHPTUEid#">
                and not exists (
                    select 1
                    from RHPTUEMpleados eam
                    where eam.RHPTUEid = a.RHPTUEid
                    and eam.DEid = c.DEid
                )
                <!--- Chequear que el empleado no se haya cambiado de empresa en ese rango de fechas --->
                and (select count(distinct Ecodigo) from LineaTiempo lt where lt.DEid = c.DEid and (lt.LTdesde between a.FechaDesde and coalesce(a.FechaHasta, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(6100, 01, 01)#">) or lt.LThasta between a.FechaDesde and coalesce(a.FechaHasta, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(6100, 01, 01)#">))) <= 1
            	<cfif Arguments.validaTcodigo>
                and (exists (select 1 
                    			from LineaTiempo lts 
                                 where lts.DEid = c.DEid 
                                 and (lts.LTdesde between b.Fcorte and '61000101'
                                 or lts.LThasta between b.Fcorte and '61000101')
                                 and lts.Tcodigo = b.Tcodigo
                   		) or b.Tcodigo is null)
            	</cfif>
            </cfquery>	
            
            <!---Elimina aquellos empleados que fueron nombrados despues de la fecha de corte--->
            <cfquery datasource="#arguments.conexion#">
                delete from RHPTUEMpleados 
                        where DEid in (	select distinct l.DEid  from LineaTiempo l
                                            inner join RHPTUD r
                                            on l.DEid=r.DEid
                                        where l.DEid in (select DEid from RHPTUEMpleados where RHPTUEid=#Arguments.RHPTUEid#)
                                        and LTdesde = (select min(LTdesde) from LineaTiempo where DEid=l.DEid)
                                        and LTdesde>=r.Fcorte )
                        and  RHPTUEid=#Arguments.RHPTUEid#
            </cfquery>
            
                    <!--- Actualizar el estado de la acción masiva --->
            <cfquery datasource="#Arguments.conexion#">
                update RHPTUE set
                    RHPTUEaplicado = 1
                where RHPTUEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHPTUEid#">
            </cfquery>
		<cfset error = 0>
        <cfreturn error>
	</cffunction>
    
    <!--- Cálculo del PTU --->
    <cffunction name="CalculoPTU" access="public" output="true" returntype="numeric"  hint="Cálculo del PTU">
		<cfargument name="RHPTUEid" type="numeric" required="yes" hint="ID del encabezado del PTU (tab1)">
		<cfargument name="Ecodigo" type="numeric" required="no" default="#Session.Ecodigo#" hint="Empresa">
		<cfargument name="conexion" type="string" required="no" default="#Session.DSN#" hint="cache">
        
        <cfquery name="rsParamSalMin" datasource="#arguments.conexion#">
        	select Pvalor
            from RHParametros
            where Ecodigo = #session.Ecodigo#
            and Pcodigo = 2024
        </cfquery>
        
         <cfif rsParamSalMin.recordcount eq 0>
        	<cfthrow message="No se ha definido el parámetro: Salario Minimo General Zona A, en el catálogo de parámetros de RH, proceso cancelado!">
        </cfif>
        
        <cfquery name="rsRHPTUE" datasource="#arguments.conexion#">
        	select 
				RHPTUEMonto,
                RHPTUEDescFaltas,
                RHPTUEDescIncapa
            from RHPTUE
            where RHPTUEid = #arguments.RHPTUEid#
        </cfquery>
        <cfset LvarRHPTUEMonto = rsRHPTUE.RHPTUEMonto>
        <cfset LvarRHPTUEDescFaltas = rsRHPTUE.RHPTUEDescFaltas>
        <cfset LvarRHPTUEDescIncapa = rsRHPTUE.RHPTUEDescIncapa>
        
        <cfquery name="rsEmpleados" datasource="#arguments.conexion#">
        	select 
            	RHPTUEMid,
            	DEid, 
                FechaDesde, 
                FechaHasta 
            from RHPTUEMpleados 
            where RHPTUEid = #arguments.RHPTUEid#
        </cfquery>
                
        <cfloop query="rsEmpleados">
        	<cfset LvarRHPTUEMid = rsEmpleados.RHPTUEMid>
			<cfset LvarDeid 	  = rsEmpleados.DEid>
            <cfset LvarFechaDesde = rsEmpleados.FechaDesde>
            <cfset LvarFechaHasta = rsEmpleados.FechaHasta>
            
            <!--- Calculo de todos los valores --->
        	<cfset LvarRHPTUEMDiasAPagar 			= fnDiasPagar(LvarDeid,arguments.RHPTUEid,LvarRHPTUEMid,LvarFechaDesde,LvarFechaHasta,LvarRHPTUEDescFaltas,LvarRHPTUEDescIncapa)>
		    <!--- <cfset LvarRHPTUEMSueldoAnual 	= fnSueldoAnual(LvarDeid,LvarFechaDesde,LvarFechaHasta)>  ---> <!--- se comenta ya que ahora se saca el sueldo anual = sueldoMensual / 30 * DíasaPagar, solicitado por el cliente a Luis --->

            <cfquery datasource="#arguments.conexion#">
            	update RHPTUEMpleados
                set RHPTUEMDiasAPagar 				= #LvarRHPTUEMDiasAPagar#,
                RHPTUEMSueldoAnual 				    = ((RHPTUEMSueldoMensual / 30) * #LvarRHPTUEMDiasAPagar#)
                where RHPTUEMid = #LvarRHPTUEMid#
                and DEid = #LvarDeid#
            </cfquery>
        </cfloop>
        
		
        <cfquery name="rsSumas" datasource="#arguments.conexion#">
            select 
                sum(RHPTUEMSueldoAnual) as RHPTUEMTotalSueldoPagado,
                sum(RHPTUEMDiasAPagar) as RHPTUEMTotalDiasLaborados
            from RHPTUEMpleados
            where RHPTUEid = #arguments.RHPTUEid#
        </cfquery>
        
        <cfif rsSumas.RHPTUEMTotalSueldoPagado gt 0>
            <cfset LvarTotalSueldoPagado = rsSumas.RHPTUEMTotalSueldoPagado>
        <cfelse>
            <cfset LvarTotalSueldoPagado = 0>
        </cfif>

        <cfif rsSumas.RHPTUEMTotalDiasLaborados gt 0>
            <cfset LvarTotalDiasLaborados = rsSumas.RHPTUEMTotalDiasLaborados>
        <cfelse>
            <cfset LvarTotalDiasLaborados = 0>
        </cfif>
        
        <cfquery datasource="#arguments.conexion#">
            update RHPTUEMpleados
            set 
                RHPTUEMTotalSueldoPagado 		= #LvarTotalSueldoPagado#,
                RHPTUEMTotalDiasLaborados 		= #LvarTotalDiasLaborados#,
                RHPTUEMMontoParcialPTU			= round(#LvarRHPTUEMonto# / 2,2),
                RHPTUEMFactorXDias 				= (#LvarRHPTUEMonto# / 2) / #LvarTotalDiasLaborados#,
                RHPTUEMFactorCuotaDiaria		= (#LvarRHPTUEMonto# / 2) / <cfif LvarTotalSueldoPagado eq 0>1<cfelse>#LvarTotalSueldoPagado#</cfif>,
                RHPTUEMxDiasLaborados			= (RHPTUEMDiasAPagar * ((#LvarRHPTUEMonto# / 2) / #LvarTotalDiasLaborados#)),
                RHPTUEMCuotaDiaria				= (RHPTUEMSueldoAnual * ((#LvarRHPTUEMonto# / 2) / <cfif LvarTotalSueldoPagado eq 0>1<cfelse>#LvarTotalSueldoPagado#</cfif>)),
                RHPTUEMTotalPTU					= (RHPTUEMDiasAPagar * ((#LvarRHPTUEMonto# / 2) / #LvarTotalDiasLaborados#)) + (RHPTUEMSueldoAnual * ((#LvarRHPTUEMonto# / 2) / <cfif LvarTotalSueldoPagado eq 0>1<cfelse>#LvarTotalSueldoPagado#</cfif>)),
                RHPTUEMSalarioMinimo			= #rsParamSalMin.Pvalor#,
                RHPTUEMExenta					= #rsParamSalMin.Pvalor# * 15,
                RHPTUEMGravable					= ((RHPTUEMDiasAPagar * ((#LvarRHPTUEMonto# / 2) / #LvarTotalDiasLaborados#)) + (RHPTUEMSueldoAnual * ((#LvarRHPTUEMonto# / 2) / <cfif LvarTotalSueldoPagado eq 0>1<cfelse>#LvarTotalSueldoPagado#</cfif>))) - (#rsParamSalMin.Pvalor# * 15)
            where RHPTUEid = #arguments.RHPTUEid#
        </cfquery>
        
        <!--- Si el total del PTU es menor o igual que la parte exenta, el importe total del PTU se considera PTU Exenta y el PTU Gravable es cero --->
        <cfquery datasource="#arguments.conexion#">
        	update RHPTUEMpleados
            	set RHPTUEMTotalPTU = case when RHPTUEMTotalPTU <= RHPTUEMExenta then RHPTUEMExenta else RHPTUEMTotalPTU end, 
                RHPTUEMGravable = case when RHPTUEMTotalPTU <= RHPTUEMExenta then 0.00 else RHPTUEMGravable end
            from RHPTUEMpleados
            where RHPTUEid = #arguments.RHPTUEid#
        </cfquery>
        
        <cfquery datasource="#arguments.conexion#">
        	update RHPTUEMpleados
            set RHPTUEMGravadaMensual = ((RHPTUEMGravable / 365) * 30.4),
            	RHPTUEMBaseGravable =  ((RHPTUEMGravable / 365) * 30.4) + RHPTUEMSueldoMensual
            where RHPTUEid = #arguments.RHPTUEid#
        </cfquery>
        
        
        <cfquery name="rsParamTablaImp" datasource="#arguments.conexion#">
        	select Pvalor
            from RHParametros
            where Ecodigo = #session.Ecodigo#
            and Pcodigo = 30
        </cfquery>
        
         <cfif rsParamSalMin.recordcount eq 0>
        	<cfthrow message="No se ha definido el parámetro: Tabla de Impuesto de Renta, en el catálogo de parámetros de RH, proceso cancelado!">
        </cfif>

        <cfquery name="rsTablaImp" datasource="#arguments.conexion#">
            select EIRid, IRcodigo, EIRdesde, EIRhasta, EIRestado, ts_rversion 
            from EImpuestoRenta
            where IRcodigo = '#rsParamTablaImp.Pvalor#'
        </cfquery>
        
        
        
        <!--- <cfquery name="rsde" datasource="#arguments.conexion#">
            select RHPTUEMpleados.RHPTUEMSueldoMensual,
                    
                        (select ((((RHPTUEMpleados.RHPTUEMSueldoMensual - b.DIRinf) * b.DIRporcentaje) / 100) + b.DIRmontofijo)
                        from  EImpuestoRenta a
                            inner join DImpuestoRenta b
                            on a.EIRid = b.EIRid
                        where a.IRcodigo = '#rsTablaImp.IRcodigo#'
                        and a.EIRestado > 0
                        and RHPTUEMpleados.FechaDesde >= EIRdesde 
                        and RHPTUEMpleados.FechaHasta <=  EIRhasta 
                        and RHPTUEMpleados.RHPTUEMBaseGravable >= DIRinf 
                        and RHPTUEMpleados.RHPTUEMBaseGravable <= DIRsup) as aa,

                        (select b.DIRmontofijo
                        from  EImpuestoRenta a
                            inner join DImpuestoRenta b
                            on a.EIRid = b.EIRid
                            inner join ImpuestoRenta c
                            on c.IRcodigo = a.IRcodigo
                        where c.IRcodigoPadre = '#rsTablaImp.IRcodigo#'
                        and a.EIRestado > 0
                        and RHPTUEMpleados.FechaDesde >= EIRdesde 
                        and RHPTUEMpleados.FechaHasta <=  EIRhasta 
                        and RHPTUEMpleados.RHPTUEMBaseGravable >= DIRinf 
                        and RHPTUEMpleados.RHPTUEMBaseGravable <= DIRsup) as bb
                    
            from  RHPTUEMpleados
            where RHPTUEid = #arguments.RHPTUEid#
        </cfquery><cf_dump var="#rsde#"> --->
        
        <!--- ImpuestoCalculado --->
        <cfquery datasource="#arguments.conexion#">
            update RHPTUEMpleados
                    set RHPTUEMImpuestoCalculado = 
                    (
                        (select ((((RHPTUEMpleados.RHPTUEMBaseGravable - b.DIRinf) * b.DIRporcentaje) / 100) + b.DIRmontofijo)
                        from  EImpuestoRenta a
                            inner join DImpuestoRenta b
                            on a.EIRid = b.EIRid
                        where a.IRcodigo = '#rsTablaImp.IRcodigo#'
                        and a.EIRestado > 0
                        and RHPTUEMpleados.FechaDesde >= a.EIRdesde 
                        and RHPTUEMpleados.FechaHasta <=  a.EIRhasta 
                        and RHPTUEMpleados.RHPTUEMBaseGravable >= b.DIRinf 
                        and RHPTUEMpleados.RHPTUEMBaseGravable <= b.DIRsup)
                        -
                        (select b.DIRmontofijo
                        from  EImpuestoRenta a
                            inner join DImpuestoRenta b
                            on a.EIRid = b.EIRid
                            inner join ImpuestoRenta c
                            on c.IRcodigo = a.IRcodigo
                        where c.IRcodigoPadre = '#rsTablaImp.IRcodigo#'
                        and a.EIRestado > 0
                        and RHPTUEMpleados.FechaDesde >= a.EIRdesde 
                        and RHPTUEMpleados.FechaHasta <=  a.EIRhasta 
                        and RHPTUEMpleados.RHPTUEMBaseGravable >= b.DIRinf 
                        and RHPTUEMpleados.RHPTUEMBaseGravable <= b.DIRsup)
                    )
            where RHPTUEid = #arguments.RHPTUEid#
        </cfquery>
        
        <!--- ImpuestoOrdinario --->
        <cfquery datasource="#arguments.conexion#">
            update RHPTUEMpleados
                    set RHPTUEMImpuestoOrdinario = 
                    (
                        (select ((((RHPTUEMpleados.RHPTUEMSueldoMensual - b.DIRinf) * b.DIRporcentaje) / 100) + b.DIRmontofijo)
                        from  EImpuestoRenta a
                            inner join DImpuestoRenta b
                            on a.EIRid = b.EIRid
                        where a.IRcodigo = '#rsTablaImp.IRcodigo#'
                        and a.EIRestado > 0
                        and RHPTUEMpleados.FechaDesde >= a.EIRdesde 
                        and RHPTUEMpleados.FechaHasta <=  a.EIRhasta 
                        and RHPTUEMpleados.RHPTUEMBaseGravable >= b.DIRinf 
                        and RHPTUEMpleados.RHPTUEMBaseGravable <= b.DIRsup)
                        -
                        (select b.DIRmontofijo
                        from  EImpuestoRenta a
                            inner join DImpuestoRenta b
                            on a.EIRid = b.EIRid
                            inner join ImpuestoRenta c
                            on c.IRcodigo = a.IRcodigo
                        where c.IRcodigoPadre = '#rsTablaImp.IRcodigo#'
                        and a.EIRestado > 0
                        and RHPTUEMpleados.FechaDesde >= a.EIRdesde 
                        and RHPTUEMpleados.FechaHasta <=  a.EIRhasta 
                        and RHPTUEMpleados.RHPTUEMSueldoMensual >= b.DIRinf 
                        and RHPTUEMpleados.RHPTUEMSueldoMensual <= b.DIRsup)
                    )
            where RHPTUEid = #arguments.RHPTUEid#
        </cfquery>

		<!--- Si el impuesto ordinario es mayor al impuesto calculado no se descuenta impuesto al PTU se da intregro el importe calculado la Diferencia ISPT es cero,
			  en caso contrario se resta el impuesto Calculado al impuesto ordinario y se obtiene una diferencia --->
        <cfquery datasource="#arguments.conexion#">
       		update RHPTUEMpleados
        		set RHPTUEMDiferenciaISPT = 
                	case when RHPTUEMImpuestoOrdinario > RHPTUEMImpuestoCalculado 
                        then 
                            0.00
                        else
                            RHPTUEMImpuestoCalculado - RHPTUEMImpuestoOrdinario
                    end
            where RHPTUEid = #arguments.RHPTUEid#
        </cfquery>
        
        <!--- Si la Diferencia ISPT es mayor que la PTU Gravable mensual Calculado no se descuenta impuesto al PTU y la Proporción del PTU es cero, se da integro el importe 
			   Calculado, en caso contrario divide la Diferencia ISPT entre la PTU Gravable mensual  --->
        <cfquery datasource="#arguments.conexion#">
       		update RHPTUEMpleados
        		set RHPTUEMProporcionPTU = 
                	case when RHPTUEMDiferenciaISPT > RHPTUEMGravadaMensual 
                        then 
                            0.00
                        else
                            RHPTUEMDiferenciaISPT / RHPTUEMGravadaMensual
                    end
            where RHPTUEid = #arguments.RHPTUEid#
            and RHPTUEMGravadaMensual <> 0 <!--- Evita division por cero --->
        </cfquery>
         
        <cfquery datasource="#arguments.conexion#">
            update RHPTUEMpleados
            set   	RHPTUEMISPTRetencionPTU = coalesce(RHPTUEMProporcionPTU,0) * coalesce(RHPTUEMGravable,0),
            		RHPTUEMNetaRecibir =	RHPTUEMTotalPTU - (coalesce(RHPTUEMProporcionPTU,0) * coalesce(RHPTUEMGravable,0)) 
            where RHPTUEid = #arguments.RHPTUEid#
        </cfquery>
        
        <cfset error = 0>
        <cfreturn error>
    </cffunction>
    
    <cffunction name="fnDiasPagar" access="public" output="true" returntype="numeric"  hint="Calculos de Días a Pagar">
		<cfargument name="DEid" type="numeric" required="yes" hint="ID del encabezado del PTU (tab1)">
		<cfargument name="RHPTUEid" type="numeric" required="yes" hint="Empleado">
        <cfargument name="RHPTUEMid" type="numeric" required="yes" hint="ID lista empleados">
        <cfargument name="FvarFechaDesde" type="date" required="yes" hint="Fecha Desde">
        <cfargument name="FvarFechaHasta" type="date" required="yes" hint="Fecha Hasta">
        <cfargument name="FvarDescFaltas" type="numeric" required="yes" hint="Descontar Faltas">
        <cfargument name="FvarDescIncapa" type="numeric" required="yes" hint="Descontar Incapacidades">
		<cfargument name="conexion" type="string" required="no" default="#Session.DSN#" hint="cache">
        
        <cfquery name="rsLineaTiempo" datasource="#arguments.conexion#">
            select b.EVfantig, min(a.LTdesde) as LTdesde, max(LThasta) as LThasta
            from LineaTiempo a 
            inner join EVacacionesEmpleado b
                on b.DEid = a.DEid
            where a.Ecodigo = (select Ecodigo 
            				   from RHPTUE 
                               where RHPTUEid = #arguments.RHPTUEid#)
            and a.DEid = #arguments.DEid#
            group by a.DEid, b.EVfantig
    	</cfquery>
        
        <cfif rsLineaTiempo.recordcount gt 0>
			<!--- 
                DateCompare:
                  -1: La fecha 1 es anterior a la fecha 2, 
                  0: las dos fechas son iguales, 
                  1: la fecha 1 es porsterior a la fecha 2--->
            <!--- La fecha Desde compara primero la fecha de antiguedad (no considera Ecodigo) contra LTdesde el resultado contra la Fecha Desde Periodo PTU --->
            <cfset LvarFechaDesde = 0>
            <cfif DateCompare(rsLineaTiempo.EVfantig, rsLineaTiempo.LTdesde, 'd') LTE 0>
                <cfif DateCompare(rsLineaTiempo.LTdesde, arguments.FvarFechaDesde, 'd') LTE 0>
                    <cfset LvarFechaDesde = arguments.FvarFechaDesde>
                <cfelse>
                    <cfset LvarFechaDesde = rsLineaTiempo.LTdesde>
                </cfif>
            <cfelse>
                <cfif DateCompare(rsLineaTiempo.EVfantig, arguments.FvarFechaDesde, 'd') LTE 0>
                    <cfset LvarFechaDesde = arguments.FvarFechaDesde>
                <cfelse>
                    <cfset LvarFechaDesde = rsLineaTiempo.EVfantig>
                </cfif>
            </cfif>
            <!--- <cfdump var=" Fecha Desde: #LvarFechaDesde#"><br>
            <cfoutput>FvarFechaHasta: #arguments.FvarFechaHasta#</cfoutput><br>
            <cfoutput>rsLineaTiempo.LThasta :#rsLineaTiempo.LThasta#</cfoutput><br> --->
            
            <!--- La fecha hasta solo compara LThasta contra FechaHasta Periodo PTU --->
            <cfset LvarFechaHasta = 0>
            <!--- <cfoutput>Datecompare: #DateCompare(rsLineaTiempo.LThasta, arguments.FvarFechaHasta, 'd')#</cfoutput><br> --->
            <cfif DateCompare(rsLineaTiempo.LThasta, arguments.FvarFechaHasta, 'd') GT 0><!--- Entra1<br> --->
                <cfset LvarFechaHasta = arguments.FvarFechaHasta>
            <cfelse><!--- Entra2<br> --->
                <cfset LvarFechaHasta = rsLineaTiempo.LThasta>
            </cfif>
            <!--- <cfdump var=" Fecha Hasta: #LvarFechaHasta#"><br> --->
            
            <!--- Si entra por acá se debe calcular los días laborados (menos de 1 año) --->
            <cfset LvarDias = DateDiff("d", LvarFechaDesde, LvarFechaHasta)+1> <!---  FechaHasta - FechaDesde --->

			<!--- Puede ser que se quieran los días nómina pero tienen que confirmar los 360 días, en vez de los 365, se deja la prevista
			 <cfquery name="rsDiasNomina" datasource="#arguments.conexion#">
				select sum(a.PEcantdias) as PEcantdias
				from HPagosEmpleado a
					inner join HRCalculoNomina b
					on b.RCNid = a.RCNid
				where and b.RCdesde >= '#LvarFechaDesde#'
					and b.RChasta <= '#LvarFechaHasta#'
					and a.DEid = #arguments.DEid#
					and a.PEtiporeg = 0 <!--- Normales --->
			</cfquery>
            <cfset LvarDias = 0>
            <cfif isdefined("rsDiasNomina") and rsDiasNomina.recordcount gt 0>
            	<cfset LvarDias = rsDiasNomina.PEcantdias>
            </cfif> --->
			
            <cfif LvarDias gt 365>
                <cfset LvarDias = 365>
            </cfif>
            
            <cfset LvarDiasFalta = 0>
            <cfif arguments.FvarDescFaltas>
                <cfquery name="rsDiasFalta" datasource="#arguments.conexion#">
                    select coalesce(sum(b.PEcantdias),0) as DiasFalta
                    from HRCalculoNomina a
                        inner join HPagosEmpleado b
                          on b.RCNid = a.RCNid
                        inner join RHTipoAccion c
                          on c.RHTid = b.RHTid
                    where b.DEid = #arguments.DEid#
                        and c.RHTcomportam = 13 <!--- Ausencia / Falta --->
                        and b.PEtiporeg = 0 <!--- Tipo de Registro: 0 :Normal --->
                        and a.Ecodigo = #session.Ecodigo#
                        and a.RCdesde >= '#LvarFechaDesde#'
                        and a.RChasta <= '#LvarFechaHasta#'
                        and b.PEdesde >= '#LvarFechaDesde#'
                        and b.PEhasta <= '#LvarFechaHasta#'
                </cfquery>
                
                <cfif rsDiasFalta.recordcount gt 0 and rsDiasFalta.DiasFalta gt 0>
                    <cfset LvarDiasFalta = rsDiasFalta.DiasFalta * -1>
                </cfif>
            </cfif>
            
            <cfset LvarDiasIncapacidad = 0>
            <cfif arguments.FvarDescIncapa>
                <cfquery name="rsDiasIncapacidad" datasource="#arguments.conexion#">
                    select coalesce(sum(b.PEcantdias),0) as DiasIncapacidad
                    from HRCalculoNomina a
                        inner join HPagosEmpleado b
                          on b.RCNid = a.RCNid
                        inner join RHTipoAccion c
                          on c.RHTid = b.RHTid
                    where b.DEid = #arguments.DEid#
                        and c.RHTcomportam = 5 <!--- Incapacidad --->
                        and b.PEtiporeg = 0 <!--- Tipo de Registro: 0 :Normal --->
                        and a.Ecodigo = #session.Ecodigo#
                        and a.RCdesde >= '#LvarFechaDesde#'
                        and a.RChasta <= '#LvarFechaHasta#'
                        and b.PEdesde >= '#LvarFechaDesde#'
                        and b.PEhasta <= '#LvarFechaHasta#'
                </cfquery>
                
                <cfif rsDiasIncapacidad.recordcount gt 0 and rsDiasIncapacidad.DiasIncapacidad gt 0>
                    <cfset LvarDiasIncapacidad = rsDiasIncapacidad.DiasIncapacidad * -1>
                </cfif>
            </cfif>
            
            <!--- <cfoutput>dias: #LvarDias#</cfoutput><br>
            <cfoutput>diasFalta: #LvarDiasFalta#</cfoutput><br> --->
            <cfset LvarResultado = LvarDias + (LvarDiasFalta) + (LvarDiasIncapacidad)>
        <cfelse>
        	 <cfset LvarResultado = 0>
        </cfif> 

        <cfquery name="rsSueldoMensualLT" datasource="#arguments.conexion#">
        	select coalesce(max(LTsalario),0) as LTsalario
            from LineaTiempo a 
            where a.Ecodigo = (select Ecodigo 
            				   from RHPTUE 
                               where RHPTUEid = #arguments.RHPTUEid#)
            and a.DEid = #arguments.DEid#
            and '#LvarFechaDesde#' >= a.LTdesde
            <!--- and '#LvarFechaHasta#' <= a.LThasta ---><!--- a solicitud por correo del cliete a Luis tiene que ser el último salario recibido a la fecha del cálculo --->
			and #now()# <= a.LThasta
        </cfquery>
        
        <!--- si rsSueldoMensualLT da 0 entonces se debe calcular el último salario del empleado (solicitado por Guillermo en México) --->
        <cfif rsSueldoMensualLT.LTsalario eq 0>
        	<cfquery name="rsSueldoMensualLT" datasource="#arguments.conexion#">
                select coalesce(LTsalario,0) as LTsalario, a.LThasta
                from LineaTiempo a 
                where a.Ecodigo = (select Ecodigo 
                                   from RHPTUE 
                                   where RHPTUEid = #arguments.RHPTUEid#)
                  and a.DEid = #arguments.DEid#
                group by a.LTsalario, a.LThasta
				order by a.LThasta desc
            </cfquery>
        </cfif>
        <cfset LvarSueldoMensual = rsSueldoMensualLT.LTsalario>
        
        <cfquery datasource="#arguments.conexion#">
        	update RHPTUEMpleados
            	set RHPTUEMSueldoMensual = #rsSueldoMensualLT.LTsalario#,
                FechaDesde = '#LvarFechaDesde#',
                FechaHasta = '#LvarFechaHasta#'
            where RHPTUEMid = #arguments.RHPTUEMid#
            and DEid = #arguments.DEid#
        </cfquery>
        
        <cfreturn LvarResultado>
    </cffunction>
    
    <cffunction name="fnSueldoAnual" access="public" output="true" returntype="numeric"  hint="Calculos de Días a Pagar">
		<cfargument name="DEid" type="numeric" required="yes" hint="ID del encabezado del PTU (tab1)">
        <cfargument name="FechaDesde" type="date" required="yes" hint="Fecha Desde">
        <cfargument name="FechaHasta" type="date" required="yes" hint="Fecha Hasta">
		<cfargument name="conexion" type="string" required="no" default="#Session.DSN#" hint="cache">
        
        <cfquery name="rsSueldoAnual" datasource="#arguments.conexion#">
        	select 
            	coalesce(sum(PEmontores),0) as SueldoAnual
            from HRCalculoNomina a
                inner join HPagosEmpleado b
                  on b.RCNid = a.RCNid
            where b.DEid = #arguments.DEid#
                and a.RCdesde >= '#arguments.FechaDesde#'
                and a.RChasta <= '#arguments.FechaHasta#'
                and b.PEdesde >= '#arguments.FechaDesde#'
                and b.PEhasta <= '#arguments.FechaHasta#'
        </cfquery>
        
        
        <cfset LvarResultado = rsSueldoAnual.SueldoAnual>
        <cfreturn LvarResultado>
    </cffunction>
    
    <cffunction name="fnGetEPTU" access="public" returntype="query">
        <cfargument name="RHPTUEid" 	type="numeric" 	required="no">
        <cfargument name="RHPTUEPagado" type="numeric" 	required="no">
        <cfargument name="Ecodigo" 	  	type="numeric" 	required="no">
		<cfargument name="Conexion" 	type="string" 	required="no">
        
        <cfif not isdefined('Arguments.Conexion')>
        	<cfset Arguments.Conexion = Session.DSN>
        </cfif>
        <cfif not isdefined('Arguments.Ecodigo')>
        	<cfset Arguments.Ecodigo = Session.Ecodigo>
        </cfif>
        
        <cfquery name="rsPTU" datasource="#Arguments.conexion#">
			select RHPTUEid, RHPTUEcodigo, RHPTUEdescripcion, CIid, FechaDesde, FechaHasta, Ecodigo, BMUsucodigo, BMFecha, RHPTUEaplicado, 
           	  RHPTUEMonto, ts_rversion, RHPTUEEstado, RHPTUEPagado, RHPTUEDescFaltas, RHPTUEDescIncapa, RHPTUEEstado
           	from RHPTUE 
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
            <cfif isdefined('Arguments.RHPTUEid')>
            	and RHPTUEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHPTUEid#">
            </cfif>
            <cfif isdefined('Arguments.RHPTUEPagado')>
            	and RHPTUEPagado = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.RHPTUEPagado#">
            </cfif>
        </cfquery>
        <cfreturn rsPTU>
    </cffunction>
    
    <cffunction name="fnAltaEPTU" access="public" returntype="numeric">
        <cfargument name="RHPTUEcodigo" 		type="string" 	required="no" default="">
        <cfargument name="RHPTUEdescripcion" 	type="string" 	required="no" default="">
        <cfargument name="CIid" 				type="numeric" 	required="yes">
        <cfargument name="FechaDesde" 			type="date" 	required="yes">
        <cfargument name="FechaHasta" 			type="date" 	required="yes"> 
        <cfargument name="RHPTUEMonto" 			type="numeric" 	required="yes">
        <cfargument name="BMFecha" 				type="date" 	required="yes" default="#now()#">
        <cfargument name="RHPTUEDescFaltas" 	type="numeric" 	required="no" default="0">
        <cfargument name="RHPTUEDescIncapa" 	type="numeric" 	required="no" default="0">
        <cfargument name="Usucodigo" 	  		type="numeric" 	required="no">
        <cfargument name="Ecodigo" 	  			type="numeric" 	required="no">
		<cfargument name="Conexion" 			type="string" 	required="no">
        
        <cfif not isdefined('Arguments.Conexion')>
        	<cfset Arguments.Conexion = Session.DSN>
        </cfif>
        <cfif not isdefined('Arguments.Ecodigo')>
        	<cfset Arguments.Ecodigo = Session.Ecodigo>
        </cfif>
        <cfif not isdefined('Arguments.Usucodigo')>
        	<cfset Arguments.Usucodigo = Session.Usucodigo>
        </cfif>
        
        <cfquery name="rsInsert" datasource="#Arguments.Conexion#">
            insert into RHPTUE(RHPTUEcodigo, RHPTUEdescripcion, CIid, FechaDesde, FechaHasta, Ecodigo, RHPTUEMonto, BMUsucodigo, BMFecha, RHPTUEDescFaltas, RHPTUEDescIncapa)
            values(
                <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.RHPTUEcodigo)#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RHPTUEdescripcion#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CIid#">,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.FechaDesde#">,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.FechaHasta#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">,
                <cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.RHPTUEMonto#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.BMFecha#">,
                <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.RHPTUEDescFaltas#">,
                <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.RHPTUEDescIncapa#">
        		)
    		<cf_dbidentity1 datasource="#session.DSN#">
        </cfquery>
        <cf_dbidentity2 datasource="#session.DSN#" name="rsInsert">
    	<cfreturn rsInsert.identity>
    </cffunction>
    
    <cffunction name="fnBajaEPTU" access="public">
        <cfargument name="RHPTUEid"	type="numeric" 	required="yes">
        <cfargument name="Ecodigo"	type="numeric" 	required="no">
		<cfargument name="Conexion" type="string" 	required="no">
        
        <cfif not isdefined('Arguments.Conexion')>
        	<cfset Arguments.Conexion = Session.DSN>
        </cfif>
        <cfif not isdefined('Arguments.Ecodigo')>
        	<cfset Arguments.Ecodigo = Session.Ecodigo>
        </cfif>
        
        <cfquery datasource="#Arguments.Conexion#">
            delete from RHPTUE
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
              and RHPTUEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHPTUEid#">
        </cfquery>
    </cffunction>
    
    <cffunction name="fnAltaDPTU" access="public" returntype="numeric">
        <cfargument name="RHPTUEid" 	type="numeric" 	required="yes">
        <cfargument name="DEid" 		type="numeric" 	required="no">
        <cfargument name="RHPcodigo" 	type="string" 	required="no" default="">
        <cfargument name="Dcodigo" 		type="numeric" 	required="no">
        <cfargument name="Ocodigo" 		type="numeric" 	required="no"> 
        <cfargument name="CFid" 		type="numeric" 	required="no">
        <cfargument name="RHTPid" 		type="numeric" 	required="no">
        <cfargument name="Fcorte" 		type="date" 	required="no">
        <cfargument name="Tcodigo" 		type="string" 	required="no" default="">
        <cfargument name="Usucodigo" 	type="numeric" required="no">
        <cfargument name="Ecodigo" 	  	type="numeric" 	required="no">
		<cfargument name="Conexion" 	type="string" 	required="no">
        
        <cfif not isdefined('Arguments.Conexion')>
        	<cfset Arguments.Conexion = Session.DSN>
        </cfif>
        <cfif not isdefined('Arguments.Ecodigo')>
        	<cfset Arguments.Ecodigo = Session.Ecodigo>
        </cfif>
        <cfif not isdefined('Arguments.Usucodigo')>
        	<cfset Arguments.Usucodigo = Session.Usucodigo>
        </cfif>
        <cfif not isdefined('Arguments.DEid')>
        	<cfset Arguments.DEid = "">
        </cfif>
        <cfif not isdefined('Arguments.Dcodigo')>
        	<cfset Arguments.Dcodigo = "">
        </cfif>
        <cfif not isdefined('Arguments.Ocodigo')>
        	<cfset Arguments.Ocodigo = "">
        </cfif>
        <cfif not isdefined('Arguments.CFid')>
        	<cfset Arguments.CFid = "">
        </cfif>
        <cfif not isdefined('Arguments.RHTPid')>
        	<cfset Arguments.RHTPid = "">
        </cfif>
        <cfif not isdefined('Arguments.Fcorte')>
        	<cfset Arguments.Fcorte = "">
        </cfif>
        
        <cfquery name="rsInsert" datasource="#Arguments.Conexion#">
            insert into RHPTUD(RHPTUEid, DEid, RHPcodigo, Dcodigo, Ocodigo, CFid, RHTPid, Fcorte, Tcodigo, Ecodigo, BMUsucodigo)
            values(
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHPTUEid#">,
                <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.DEid#" voidnull>,
                <cf_jdbcquery_param cfsqltype="cf_sql_char" 	value="#Arguments.RHPcodigo#" voidnull>,
                <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.Dcodigo#" voidnull>,
                <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.Ocodigo#" voidnull>,
                <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.CFid#" voidnull>,
                <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.RHTPid#" voidnull>,
                <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#Arguments.Fcorte#" voidnull>,
                <cf_jdbcquery_param cfsqltype="cf_sql_char" 	value="#Arguments.Tcodigo#" voidnull>,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
        		)
    		<cf_dbidentity1 datasource="#session.DSN#">
        </cfquery>
        <cf_dbidentity2 datasource="#session.DSN#" name="rsInsert">
    	<cfreturn rsInsert.identity>
    </cffunction>
    
    <cffunction name="fnExisteDPTU" access="public" returntype="boolean">
    	<cfargument name="RHPTUEid" 	type="numeric" 	required="yes">
        <cfargument name="DEid" 		type="numeric" 	required="no">
        <cfargument name="RHPcodigo" 	type="string" 	required="no">
        <cfargument name="Dcodigo" 		type="numeric" 	required="no">
        <cfargument name="Ocodigo" 		type="numeric" 	required="no"> 
        <cfargument name="CFid" 		type="numeric" 	required="no">
        <cfargument name="RHTPid" 		type="numeric" 	required="no">
        <cfargument name="Fcorte" 		type="date" 	required="no">
        <cfargument name="Tcodigo" 		type="string" 	required="no">
        <cfargument name="Ecodigo" 	  	type="numeric" 	required="no">
		<cfargument name="Conexion" 	type="string" 	required="no">
        
        <cfif not isdefined('Arguments.Conexion')>
        	<cfset Arguments.Conexion = Session.DSN>
        </cfif>
        <cfif not isdefined('Arguments.Ecodigo')>
        	<cfset Arguments.Ecodigo = Session.Ecodigo>
        </cfif>
        
        <cfquery name="rsExiste" datasource="#Arguments.Conexion#">
            select count(1) as cantidad
            from RHPTUD
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
              and RHPTUEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHPTUEid#">
              <cfif isdefined('Arguments.DEid')>
              and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.DEid#">
              </cfif>
              <cfif isdefined('Arguments.RHPcodigo') and len(trim(Arguments.RHPcodigo)) gt 0>
              and RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" 	value="#Arguments.RHPcodigo#">
              </cfif>
              <cfif isdefined('Arguments.Dcodigo')>
              and Dcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.Dcodigo#">
              </cfif>
              <cfif isdefined('Arguments.Ocodigo')>
              and Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.Ocodigo#">,
              </cfif>
              <cfif isdefined('Arguments.CFid')>
              and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.CFid#">
              </cfif>
              <cfif isdefined('Arguments.RHTPid')>
              and RHTPid = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.RHTPid#">
              </cfif>
              <cfif isdefined('Arguments.Fcorte')>
              and Fcorte = <cfqueryparam cfsqltype="cf_sql_timestamp" 	value="#Arguments.Fcorte#">
              </cfif>
              <cfif isdefined('Arguments.Tcodigo') and len(trim(Arguments.Tcodigo)) gt 0>
              and Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" 	value="#Arguments.Tcodigo#">
              </cfif>
        </cfquery>
    	<cfreturn rsExiste.cantidad gt 0>
    </cffunction>
    
    <cffunction name="fnBajaDPTU" access="public">
        <cfargument name="RHPTUEid" 	type="numeric" 	required="yes">
        <cfargument name="RHPTUDid" 	type="numeric" 	required="no">
        <cfargument name="Ecodigo" 	  	type="numeric" 	required="no">
		<cfargument name="Conexion" 	type="string" 	required="no">
        
        <cfif not isdefined('Arguments.Conexion')>
        	<cfset Arguments.Conexion = Session.DSN>
        </cfif>
        <cfif not isdefined('Arguments.Ecodigo')>
        	<cfset Arguments.Ecodigo = Session.Ecodigo>
        </cfif>
        
        <cfquery datasource="#Arguments.Conexion#">
            delete from RHPTUD
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
              and RHPTUEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHPTUEid#">
              <cfif isdefined('Arguments.RHPTUDid')>
              and RHPTUDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHPTUDid#">
              </cfif>
        </cfquery>
        
    </cffunction>
    
    <cffunction name="fnBajaDEPTU" access="public">
        <cfargument name="RHPTUEid" 	type="numeric" 	required="yes">
        <cfargument name="RHPTUEMid" 		type="numeric" 	required="no">
        <cfargument name="Ecodigo" 	  	type="numeric" 	required="no">
		<cfargument name="Conexion" 	type="string" 	required="no">
        
        <cfif not isdefined('Arguments.Conexion')>
        	<cfset Arguments.Conexion = Session.DSN>
        </cfif>
        <cfif not isdefined('Arguments.Ecodigo')>
        	<cfset Arguments.Ecodigo = Session.Ecodigo>
        </cfif>
        
        <cfquery datasource="#Arguments.Conexion#">
            delete from RHPTUEMpleados
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
              and RHPTUEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHPTUEid#">
              <cfif isdefined('Arguments.RHPTUEMid')>
              and RHPTUEMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHPTUEMid#">
              </cfif>
        </cfquery>
        
    </cffunction>
    
    <cffunction name="fnReconocerDEPTU" access="public" returntype="numeric">
        <cfargument name="RHPTUEid" 			type="numeric" 	required="yes">
        <cfargument name="RHPTUEMid" 			type="numeric" 	required="no">
        <cfargument name="RHPTUEMreconocido" 	type="numeric" 	required="no" default="1">
        <cfargument name="RHPTUEMjustificacion" type="string" 	required="no" default="">
        <cfargument name="Ecodigo" 	  			type="numeric" 	required="no">
		<cfargument name="Conexion" 			type="string" 	required="no">
        
        <cfif not isdefined('Arguments.Conexion')>
        	<cfset Arguments.Conexion = Session.DSN>
        </cfif>
        <cfif not isdefined('Arguments.Ecodigo')>
        	<cfset Arguments.Ecodigo = Session.Ecodigo>
        </cfif>
        
        <cfquery datasource="#Arguments.Conexion#">
            update RHPTUEMpleados set
            	RHPTUEMreconocido = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.RHPTUEMreconocido#">,
                RHPTUEMjustificacion = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Arguments.RHPTUEMjustificacion#" voidnull>
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
              and RHPTUEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHPTUEid#">
              and RHPTUEMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHPTUEMid#">
        </cfquery>
        <cfreturn Arguments.RHPTUEMid>
        
    </cffunction>
    
    <cffunction name="fnCerrarCalculoEPTU" access="public">
        <cfargument name="RHPTUEid" 			type="numeric" 	required="yes">
        <cfargument name="Ecodigo" 	  			type="numeric" 	required="no">
		<cfargument name="Conexion" 			type="string" 	required="no">
        
        <cfif not isdefined('Arguments.Conexion')>
        	<cfset Arguments.Conexion = Session.DSN>
        </cfif>
        <cfif not isdefined('Arguments.Ecodigo')>
        	<cfset Arguments.Ecodigo = Session.Ecodigo>
        </cfif>
        
        <cfquery datasource="#Arguments.Conexion#">
            update RHPTUE
            set RHPTUEEstado = 1
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
              and RHPTUEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHPTUEid#">
        </cfquery>
        
    </cffunction>
    
</cfcomponent>