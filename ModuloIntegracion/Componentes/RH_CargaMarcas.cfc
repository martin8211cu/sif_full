<cfcomponent>

	<cffunction name="Ejecuta" access="public" returntype="string" output="no">
		<!--- <cfargument name="Ecodigo"   type="numeric"> --->
		<!---Invocar al GC para liberar memoria--->
        <cfset javaRT = createobject("java","java.lang.Runtime").getRuntime()>
        <cfset javaRT.gc()>
		<!--- invoca el GC --->

		<!--- <cfargument name="Ecodigo"   type="numeric"> --->
<!--- 		<cf_dump var=#Arguments.Ecodigo#> --->

        <cfquery name="rsDatos" datasource="sifinterfaces">
            Select
                DEid
                , MFecha
                , MHora
                , MInOut
            from MarcasAPH
		</cfquery>

		<!--- Se necesita el id del usuario INTERFAZ debido a adaptaciones que se
		han hecho --->
		<cfquery name="codInclusion" datasource="asp">
			select u.Usucodigo from Usuario u
			where u.Usulogin = 'INTERFAZ'
		</cfquery>

		<!--- <cfset VarEreferncia = #session.Ecodigo#> --->
<!--- 		<cfset VarEcodigoSDC = #session.CEcodigo#> --->
		<cfset VarEreferncia = 2> <!--- Este es el ecodigo de la empresa ***MAFP*** --->
		<cfset VarEcodigoSDC = 3> <!--- Este es el CEcodigo de la empresa ***MAFP*** --->
		<cfset VarUsucodigoInclusion = #codInclusion.Usucodigo#>
        <cfquery datasource="asp" name="__conexiones__">
            select e.Ereferencia, e.CEcodigo, c.Ccache, e.Ereferencia
            from Empresa e
                join Caches c
                on e.Cid = c.Cid
        </cfquery>
        <cfset This.Conexiones = __conexiones__>
        <cfquery dbtype="query" name="ret">
            select * from This.Conexiones where Ereferencia = #VarEreferncia#
        </cfquery>

        <cfquery name="rsCEcodigo" datasource="#ret.Ccache#">
            select CEcodigo, Ereferencia
            from Empresa e
                inner join Empresas s
                on  e.Ereferencia = s.Ecodigo and s.EcodigoSDC = <cfqueryparam cfsqltype="cf_sql_integer" value=#VarEcodigoSDC#>
        </cfquery>
        <cfset varCEcodigo=#rsCEcodigo.CEcodigo#>
        <cfset varEcodigo=#rsCEcodigo.Ereferencia#>

		<cfif isdefined("rsDatos") AND rsDatos.recordcount GT 0>
           <cfloop  query="rsDatos">
            <cfsilent>
                <cfquery name = "rsBuscaMarca" datasource="sifinterfaces">
                	select * from IE717
                    where  Ecodigo = <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo#"> and
                           DEid    = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatos.DEid#"> and
                           FechaMarca = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatos.MFecha#"> and
                           HoraMarca =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatos.MHora#"> and
                           TipoMarca =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatos.MInOut#">
                </cfquery>
                <cfif rsBuscaMarca.recordcount eq 0>
<!---      Extrae Maximo+1 de tabla IE717 para insertar nuevo reg, en IE717 --->
                     <cfquery name="rsMaximo_Tabla" datasource="sifinterfaces">
                        select coalesce (max( ID ), 0) + 1 as Maximo from IE717
                    </cfquery>

                    <cfif isdefined(#rsMaximo_Tabla.Maximo#) or #rsMaximo_Tabla.Maximo# gt 0>
                        <cfset Maximus = #rsMaximo_Tabla.Maximo#>
                    <cfelse>
                        <cfset Maximus = 1>
                    </cfif>

                    <cfquery datasource="sifinterfaces">
                        insert into IE717
                            (ID,
                             Ecodigo,
                             DEid,
                             FechaMarca,
                             HoraMarca,
                             TipoMarca)
                        values
                        (<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
                         <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo#">,
                         <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatos.DEid#">,
                         <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatos.MFecha#">,
                         <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatos.MHora#">,
                         <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatos.MInOut#">)
                    </cfquery>

                    <cfquery datasource="sifinterfaces">
                        insert into InterfazColaProcesos
                            (CEcodigo, NumeroInterfaz, IdProceso, SecReproceso,
                             EcodigoSDC, OrigenInterfaz, TipoProcesamiento, StatusProceso,
                             FechaInclusion, ManejoDatos,Cancelar,UsucodigoInclusion)
                        values(
                            <cfqueryparam cfsqltype="cf_sql_numeric" value="#varCEcodigo#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="717">,
                            <cfqueryparam cfsqltype="cf_sql_numeric" value="#Maximus#">,
                            0,
                            <cfqueryparam cfsqltype="cf_sql_numeric" value=#VarEcodigoSDC#>,
                            'E',
                            'A',
                            1,
                            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
                            'T',
                            0,
                            <cfqueryparam cfsqltype="cf_sql_numeric" value=#VarUsucodigoInclusion#>)
                    </cfquery>
            	</cfif>
            </cfsilent>
            </cfloop>
        </cfif>
	</cffunction>
</cfcomponent>
