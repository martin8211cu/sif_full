<cfquery name="rsPeriodo" datasource="#session.DSN#"> <!--- Periodo--->
	select p1.Pvalor as value 
    from Parametros p1 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#"> 
		and Pcodigo = 50
</cfquery>

<cfquery name="rsMes" datasource="#session.DSN#">  <!--- Mes --->
	select p1.Pvalor as value 
    from Parametros p1 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#"> 
		and Pcodigo = 60
</cfquery>
	
<!--- Crea la FechaAux a partir del periodo / mes de auxiliares y le pone el ultimo da del mes --->
<cfset rsFechaAux.value = CreateDate(rsPeriodo.value, rsMes.value, 01)>
<cfset rsFechaAux.value = DateAdd("m",1,rsFechaAux.value)>
<cfset rsFechaAux.value = DateAdd("d",-1,rsFechaAux.value)>
	
<cfquery name="rsMoneda" datasource="#session.DSN#"><!--- Obtiene la Moneda Local --->
	select Mcodigo as value
	from Empresas 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
</cfquery>	

<cfset LvarPeriodo = rsPeriodo.value>
<cfset LvarMes     = rsMes.value>
<cfset LvarMoneda  = rsMoneda.value>

<!---Tabla para los errores--->
<cf_dbtemp name="errores" returnvariable="errores" datasource="#session.DSN#">
	 <cf_dbtempcol name="Error"   type="varchar(250)" mandatory="no">
     <cf_dbtempcol name="Referencia"   type="varchar(250)" mandatory="no">
     
</cf_dbtemp> 

<!---Verifica que se hayan dado todos los datos necesarios en el archivo--->
<cfquery name="rsVerifica" datasource="#session.DSN#">
	select count(1) as Verifica
	from #table_name# 
    where coalesce(Ltrim(Rtrim(Descripcion)),'') like ''
</cfquery>

<cfif rsVerifica.Verifica GT 0>
    <cfquery name="ERR" datasource="#session.DSN#">
        insert into #errores# (Error, Referencia)
        values ('Error. Existen registros sin Descripción en el Archivo','N/A')
    </cfquery>
</cfif>

<cfquery name="rsVerifica" datasource="#session.DSN#">
	select count(1) as Verifica
	from #table_name# 
    where coalesce(Ltrim(Rtrim(PlacaAnt)),'') like ''
</cfquery>

<cfif rsVerifica.Verifica GT 0>
    <cfquery name="ERR" datasource="#session.DSN#">
        insert into #errores# (Error, Referencia)
        values ('Error. Se debe Indicar la Placa Anterior para todos los registros','N/A')
    </cfquery>
</cfif>

<cfquery name="rsVerifica" datasource="#session.DSN#">
	select count(1) as Verifica
	from #table_name# 
    where coalesce(Ltrim(Rtrim(PlacaNueva)),'') like ''
</cfquery>
<cfif rsVerifica.Verifica GT 0>
    <cfquery name="ERR" datasource="#session.DSN#">
        insert into #errores# (Error, Referencia)
        values ('Error. Se debe Indicar la Placa Nueva para todos los registros','N/A')
    </cfquery>
</cfif>

<!---Verifica que no haya valores repetidos en el Archivo--->
<cfquery name="ERR" datasource="#session.DSN#">
    insert into #errores# (Error, Referencia)
    select 'Error. La Placa Anterior: ' + a.PlacaAnt + ' se encuentra repetida' as Error, '' as Referencia
    from #table_name# a
    group by PlacaAnt
    having count(1) > 1
</cfquery>

<cfquery name="ERR" datasource="#session.DSN#">
    insert into #errores# (Error, Referencia)
    select 'Error. La Placa Nueva: ' + a.PlacaNueva + ' se encuentra repetida' as Error, '' as Referencia
    from #table_name# a
    group by PlacaNueva
    having count(1) > 1
</cfquery>

<!---Verifica que la Placa anterior exista en el catálogo de Activos y que la nueva NO exista en el mismo--->
<cfquery name="ERR" datasource="#session.DSN#">
    insert into #errores# (Error, Referencia)
    select 'Error. La Placa Anterior:' + a.PlacaAnt + ' no esta registrada en el Catálogo de Activos', a.PlacaAnt as Referencia
    from #table_name# a
    where not exists 
    	(select 1 
          from Activos b
          where b.Ecodigo = #session.Ecodigo#
          and lower(b.Aplaca) = lower(a.PlacaAnt))
</cfquery>

<cfquery name="ERR" datasource="#session.DSN#">
    insert into #errores# (Error, Referencia)
    select 'Error. La Placa Nueva:' + a.PlacaNueva + ' ya se encuentra registrada en el Catálogo de Activos', a.PlacaNueva as Referencia
    from #table_name# a
    inner join Activos b
		on b.Ecodigo = #session.Ecodigo#
        and lower(b.Aplaca) = lower(a.PlacaNueva)
</cfquery>

<cfquery name="rsErrores" datasource="#session.DSN#">
	select count(1) as cantidad
	from #errores#
</cfquery>

<cfif rsErrores.cantidad GT 0>
	<cfquery name="ERR" datasource="#session.DSN#">
		select Error as MSG
		from #errores#
		group by Error
	</cfquery>
	<cfreturn>
<cfelseif rsErrores.cantidad EQ 0>
	<!--- Consulta la tabla donde de guardo la informacion para la descripcion del encabezado--->
    <cfquery name="rsDescripcionE" datasource="#session.DSN#">
        select Descripcion
        from #table_name# 
        group by Descripcion
    </cfquery>

    <cfloop query="rsDescripcionE">
        <!---Inserta el Encabezado de la Importacion--->
        <cfinvoke component="sif.Componentes.AF_CAMPLACA" method="AF_CAMPLACAACT" returnvariable="rsResultadosDA">
            <cfinvokeargument name="AGTPdescripcion" value="#rsDescripcionE.Descripcion#">
            <cfinvokeargument name="debug" value="false">
        </cfinvoke>
        <cftransaction>  
            <cfquery datasource="#session.DSN#">
                insert into ADTProceso 
                (
                Ecodigo, 
                AGTPid, 
                Aid, 
                IDtrans, 
                CFid, 
                TAperiodo, 
                TAmes, 
                TAfecha, 
                TAfalta, 
                TAmontooriadq, 
                TAmontolocadq, 
                TAmontoorimej, 
                TAmontolocmej, 
                TAmontoorirev, 
                TAmontolocrev, 
                Mcodigo,
                TAtipocambio, 
                Usucodigo, 
                BMUsucodigo,
                AplacaAnt,
                AplacaNueva
                )
                select
                    #session.Ecodigo#,
                    <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsResultadosDA#">,
                    a.Aid,
                    10,
                    af.CFid,
                    <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#LvarPeriodo#"> as TAperiodo_de_auxiliares,
                    <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#LvarMes#">     as TAmes_de_auxiliares,
                    #rsFechaAux.value# as TAfecha_de_auxiliares,
                    #now()# as TAfalta,
                    af.AFSvaladq,
                    af.AFSvaladq,
                    af.AFSvalmej,
                    af.AFSvalmej,
                    af.AFSvalrev,
                    af.AFSvalrev,
                    <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#LvarMoneda#"> as Mcodigo,
                    1.00 as TAtipocambio,
                    #session.Usucodigo# as Usucodigo,
                    #session.Usucodigo# as BMUsucodigo,
                    a.Aplaca,
                    t.PlacaNueva as newAFCcodigo
                from #table_name# t
                    inner join Activos a
                        inner join 	AFSaldos af	
                            on af.Aid = a.Aid
                            and af.AFSperiodo 	= #LvarPeriodo#
                            and af.AFSmes 		= #LvarMes#
                    on lower(t.PlacaAnt) = lower(a.Aplaca)
                where t.Descripcion like <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDescripcionE.Descripcion#">
                	and a.Ecodigo = #session.Ecodigo#
                    <!---and a.Astatus = 0--->
                    and not exists (
                                    select x.Aid
                                    from ADTProceso x
                                    where x.Ecodigo = a.Ecodigo
                                        and x.Aid = a.Aid
                                        and x.IDtrans = 10
                                    and x.AGTPid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsResultadosDA#">)
            </cfquery>
        </cftransaction>
    </cfloop>
</cfif>



