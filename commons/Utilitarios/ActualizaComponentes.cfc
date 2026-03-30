<cfcomponent>
	<!--- RECALCULO DE LOS COMPONENTES DE LA LINEA DE TIEMPO --->    
   	<cffunction name="RecalculoComponentes" access="public" output="true" returntype="boolean">
            <cfargument name="conexion" 	type="string" 	required="no" 	default="#Session.DSN#">
            <cfargument name="TipoLinea" 	type="numeric" 	required="no" 	default="0"> <!--- 0 ninguna 1 Principal 2 Recargo 3 Ambas--->
			<cfargument name="DEid" 		type="numeric" 	required="no" 	default="0"> 
            <cfargument name="ListaCSid" 	type="any" 		required="no" 	default="">
            <cfargument name="Desde" 		type="any"		required="no" 	default="">
            <cfargument name="Hasta" 		type="any"		required="no" 	default="">
            
            <cfargument name="debug" 		type="boolean" 	required="no" 	default="TRUE">
            
            <cf_dump var="#Arguments#">
            
            
          
        
        <!--- LINEAS DE TIEMPO QUE SE TIENEN QUE RECALCULAR --->
        
        <!---
		Notas importantes
       		- Verificar las fechas de las lineas que queremos modificar
            - ver el componente salarial que queremos recalcular
            - ver los empleado que queremos recalcular
		--->
            
            
        
       
            <cfquery name="rsLTid" datasource="#conexion#">
                select 
                    lt.DEid
                    , a.LTid
                    , a.CSid
                    , b.CSdescripcion
                    , a.DLTmonto
                    , a.DLTunidades
                    , a.DLTtabla
                    , a.CIid
                    , a.DLTmetodoC
                    , a.DLTporcplazacomponente
                    , a.DLTmontobase
                    from DLineaTiempo a
                    inner join ComponentesSalariales b
	                    on a.CSid = b.CSid
                    inner join LineaTiempo lt
                    	on lt.LTid = a.LTid
                        and not ((lt.LTdesde < <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.Desde#">  and lt.LThasta < <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.Desde#">) 
                                                or  (<cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.Hasta#"> < lt.LTdesde and  <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.Hasta#">   < lt.LThasta))
						<cfif isdefined('Arguments.DEid') and Arguments.DEid>
                            and lt.DEid in (#Arguments.DEid#)
                        </cfif>
                                            
                    <!---where a.LTid in (select lt.LTid
                                        from LineaTiempo lt
                                        where not ((lt.LTdesde < <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.Desde#">  and lt.LThasta < <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.Desde#">) 
                                                or  (<cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.Hasta#"> < lt.LTdesde and  <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.Hasta#">   < lt.LThasta))
                                            <cfif isdefined('Arguments.DEid') and Arguments.DEid>
                                            	and lt.DEid in (#Arguments.DEid#)
                                            </cfif>
                                     )--->
                    where a.DLTmonto >= 0
                    and a.CIid > 0
                    <cfif isdefined('Arguments.ListaCSid')>
    	                and a.CSid in (#Arguments.ListaCSid#)
	                </cfif>
                    <!---and a.LTid  = 18796--->
                    order by a.LTid, a.CSid 
            </cfquery>
            
      <!---      <cfif arguments.debug>
            	<cfdump var="Lineas de tiempo normales">
                <cfdump var="#rsLTid#">
            </cfif>--->
        
            <cfquery name="rsLTRid" datasource="#conexion#">
                select 
                    lt.DEid
                    , a.LTRid as LTid
                    , a.CSid
                    , b.CSdescripcion
                    , a.DLTmonto
                    , a.DLTunidades
                    , a.DLTtabla
                    , a.CIid
                    , a.DLTmetodoC
                    , a.RHPid
                    , a.RHPcodigo
                    , a.DLTmontobase
                    from DLineaTiempoR a
                    inner join ComponentesSalariales b
                    on a.CSid = b.CSid
                    inner join LineaTiempoR lt
                    	on lt.LTRid = a.LTRid
                        and not ((lt.LTdesde < <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.Desde#">  and lt.LThasta < <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.Desde#">) 
                                                or  (<cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.Hasta#"> < lt.LTdesde and  <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.Hasta#">   < lt.LThasta))
						<cfif isdefined('Arguments.DEid') and Arguments.DEid>
                            and lt.DEid in (#Arguments.DEid#)
                        </cfif>
                    
                    <!--- 
                    where a.LTRid in (select lt.LTRid
                                        from LineaTiempoR lt
                                        where not ((lt.LTdesde < <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.Desde#">  and lt.LThasta < <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.Desde#">) 
                                                or  (<cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.Hasta#"> < lt.LTdesde and  <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.Hasta#">   < lt.LThasta))
                                            <cfif isdefined('Arguments.DEid') and Arguments.DEid>
                                            	and lt.DEid in (#Arguments.DEid#)
                                            </cfif>
                                     )--->
                    where a.DLTmonto >= 0
                    and a.CIid > 0
                    <cfif isdefined('Arguments.ListaCSid')>
    	                and a.CSid in (#Arguments.ListaCSid#)
	                </cfif>

                    order by a.LTRid, a.CSid 
            </cfquery>
        
        
<!---			<cfif arguments.debug>
                <cfdump var="Lineas de tiempo Recargo">
                <cfdump var="#rsLTRid#">
            </cfif>--->
            
        <cftransaction>
			<cfif #Arguments.TipoLinea# EQ 1 or #Arguments.TipoLinea# EQ 3>
                <cfloop query="rsLTid">
                    <!--- Recalcular todos los componentes --->
                    <cfquery name="rsComp" datasource="#Session.DSN#">
                        select c.DEid,a.LTid, a.CSid, a.DLTunidades, a.DLTmonto,
                               c.LTdesde,coalesce(c.LThasta,'61000101') as LThasta, coalesce(c.RHCPlinea,0) as RHCPlinea, LTporcsal,c.RHPcodigoAlt,
                               coalesce(RHCPlineaP,0) as RHCPlineaP,a.DLTmetodoC, b.CSorden, b.CSusatabla
                        from DLineaTiempo a
                            inner join ComponentesSalariales b
                                on b.CSid = a.CSid
                            inner join LineaTiempo c
                                on c.LTid = a.LTid
                                and c.Ecodigo = b.Ecodigo
                        where a.LTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLTid.LTid#">
                            and a.CSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLTid.CSid#">
                          and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                        order by b.CSorden,  b.CSusatabla, b.CScodigo, b.CSdescripcion
                    </cfquery>
          
                    
                    <cfset Lvar_CatAlt = rsComp.RHCPlinea>
                     <!--- VERIFICA SI LA ACCIN DEBE DE APLICAR UN PUESTO ALTERNO --->

                    <cfif isdefined('LvarRHPcodigoAlt') and LvarRHPcodigoAlt EQ 1>
                        <cfquery name="rsAccion" datasource="#session.DSN#">
                            select RHPcodigoAlt
                            from RHAcciones
                            where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHAlinea#">
                        </cfquery>
                        <cfif rsAccion.RecordCount and LEN(TRIM(rsAccion.RHPcodigoAlt)) GT 0>
                            <cfset rsComp.RHPcodigoAlt = rsAccion.RHPcodigoAlt>
                        </cfif>
                    </cfif>
                    
                    <!--- VERIFICAR SI TIENE UN PUESTO ALTERNO QUE CAMBIA LA CATEGORIA --->
                    <cfset Lvar_RHTTid = 0>
                    <cfset Lvar_RHMPPid = 0>
                    <cfset Lvar_RHCid = 0>
                    <cfif rsComp.RecordCount GT 0 and rsComp.RHPcodigoAlt GT 0>
                        <cfquery name="rsCatPuestoAlt" datasource="#session.DSN#">
                            select RHCPlinea
                            from RHPuestos a
                            inner join RHMaestroPuestoP b
                                on b.RHMPPid = a.RHMPPid
                                and b.Ecodigo = a.Ecodigo
                            inner join RHCategoriasPuesto c
                                on c.RHMPPid = b.RHMPPid
                                and c.Ecodigo = b.Ecodigo
                            where RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsComp.RHPcodigoAlt#">
                              and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                        </cfquery>
                        
                        <cfset Lvar_CatAlt = rsCatPuestoAlt.RHCPlinea>
                        <cfif isdefined('rsCatPuestoAlt') and rsCatPuestoAlt.RecordCount>
                            <cfset Lvar_CatAlt = rsCatPuestoAlt.RHCPlinea>
                       <cfelse>
                            <cfset Lvar_CatAlt = 0>
                        </cfif>
                    </cfif>

                    
                    <!---<br>Lvar_CatAlt:<cfdump var="#Lvar_CatAlt#">--->
                    
                    <cfloop query="rsComp">
                        <cfinvoke component="rh.Componentes.RH_EstructuraSalarial" method="calculaComponente" returnvariable="calculaComponenteR">
                            <cfinvokeargument name="CSid" 				value="#rsComp.CSid#"/>
                            <cfinvokeargument name="fecha" 				value="#rsComp.LTdesde#"/>
                            <cfinvokeargument name="fechah" 			value="#rsComp.LThasta#"/>
                            <cfinvokeargument name="DEid" 				value="#rsComp.DEid#"/>
                            <cfinvokeargument name="RHCPlinea" 			value="#Lvar_CatAlt#"/>
                            <cfinvokeargument name="BaseMontoCalculo" 	value="0.00"/>
                            <cfinvokeargument name="Unidades" 			value="#rsComp.DLTunidades#"/>
                            <cfinvokeargument name="Monto" 				value="#rsComp.DLTmonto#"/>
                            <cfinvokeargument name="Metodo" 			value="#rsComp.DLTmetodoC#"/>
                            <cfinvokeargument name="TablaComponentes" 	value="DLineaTiempo"/>
                            <cfinvokeargument name="CampoLlaveTC" 		value="LTid"/>
                            <cfinvokeargument name="ValorLlaveTC" 		value="#rsLTid.LTid#"/>
                            <cfinvokeargument name="CampoMontoTC" 		value="DLTmonto"/>
                            <cfinvokeargument name="RHTTid" 			value="0">
                            <cfinvokeargument name="RHCid" 				value="0">
                            <cfinvokeargument name="RHMPPid" 			value="0">
                            <cfinvokeargument name="PorcSalario"		value="#rsComp.LTporcsal#"/>
                            <cfinvokeargument name="RHCPlineaP" 		value="#rsComp.RHCPlineaP#"/>
                        </cfinvoke>
                        
                       <!--- <br>calculaComponenteR:<cfdump var="#calculaComponenteR#">--->
                        
                        <cfquery name="ABC_RHAcciones" datasource="#Session.DSN#">
                            update DLineaTiempo
                               set DLTunidades 	= <cfqueryparam cfsqltype="cf_sql_float" value="#calculaComponenteR.Unidades#">,
                                   DLTmonto		= <cfqueryparam cfsqltype="cf_sql_money" value="#calculaComponenteR.Monto#">,
                                   DLTmetodoC 	= <cfqueryparam cfsqltype="cf_sql_char" value="#calculaComponenteR.Metodo#">,
                                   DLTmontobase	= <cfqueryparam cfsqltype="cf_sql_char" value="#calculaComponenteR.MontoBase#">,
                                   BMUsucodigo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
                             where LTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLTid.LTid#">
                               and CSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsComp.CSid#">
                        </cfquery>
                    </cfloop>
                    
                    <!--- se hace la suma de los componente para el total del salario --->
                    <cfquery datasource="#session.DSN#">
                        update LineaTiempo
                        set LTsalario = coalesce((select sum(DLTmonto)
                                        from LineaTiempo a
                                        inner join DLineaTiempo b
                                            on b.LTid = a.LTid
                                        where a.LTid = LineaTiempo.LTid
                                          and a.Ecodigo = LineaTiempo.Ecodigo),0),
                             BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
                        where LTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLTid.LTid#">
                          and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                    </cfquery>
                </cfloop>
                
                 <cfquery name="rsFin" datasource="#conexion#">
                    select 
                        a.LTid
                        , a.CSid
                        , b.CSdescripcion
                        , a.DLTmonto
                        , a.DLTunidades
                        , a.DLTtabla
                        , a.CIid
                        , a.DLTmetodoC
                        , a.DLTporcplazacomponente
                        , a.DLTmontobase
                        from DLineaTiempo a
                        inner join ComponentesSalariales b
                        on a.CSid = b.CSid
                        where a.LTid in (select lt.LTid
                                            from LineaTiempo lt
                                            where not ((lt.LTdesde < <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.Desde#">  and lt.LThasta < <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.Desde#">) 
                                                or  (<cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.Hasta#"> < lt.LTdesde and  <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.Hasta#">   < lt.LThasta))
                                            <cfif isdefined('Arguments.DEid') and Arguments.DEid>
                                            	and lt.DEid in (#Arguments.DEid#)
                                            </cfif>
                                         )
                                                
                        and a.DLTmonto >= 0
                        and a.CIid > 0
                        <cfif isdefined('Arguments.ListaCSid')>
                            and a.CSid in (#Arguments.ListaCSid#)
                        </cfif>
                        order by a.LTid, a.CSid 
                </cfquery>
                
                <cfif arguments.debug>
                	<cfdump var="Lineas de tiempo normales">
               		<cfdump var="#rsLTid#">
                    
                	<cfdump var="Cortes Despues de aplicado Linea Principal">
                    <cfdump var="#rsFin#">
                </cfif>
			</cfif>        
        
       		<cfif #Arguments.TipoLinea# EQ 2 or #Arguments.TipoLinea# EQ 3>
                <cfloop query="rsLTRid">
                    <!--- Recalcular todos los componentes --->
            
                    <!---Recalcular todos los componentes LT recargo--->
                    <cfquery name="rsComp" datasource="#Session.DSN#">
                        select c.DEid,a.LTRid, a.CSid, a.DLTunidades, a.DLTmonto,
                               c.LTdesde,coalesce(c.LThasta,'61000101') as LThasta, coalesce(c.RHCPlinea,0) as RHCPlinea, LTporcsal,c.RHPcodigoAlt,
                               coalesce(RHCPlineaP,0) as RHCPlineaP,a.DLTmetodoC, b.CSorden, b.CSusatabla
                        from DLineaTiempoR a
                            inner join ComponentesSalariales b
                                on b.CSid = a.CSid
                            inner join LineaTiempoR c
                                on c.LTRid = a.LTRid
                                and c.Ecodigo = b.Ecodigo
                        where a.LTRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLTRid.LTid#">
                            and a.CSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLTRid.CSid#">
                          and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                        order by b.CSorden,  b.CSusatabla, b.CScodigo, b.CSdescripcion
                    </cfquery>
            
					<cfset Lvar_CatAlt = rsComp.RHCPlinea>
                     <!--- VERIFICA SI LA ACCIN DEBE DE APLICAR UN PUESTO ALTERNO --->
                     
                     
        
                    <cfif isdefined('LvarRHPcodigoAlt') and LvarRHPcodigoAlt EQ 1>
                        <cfquery name="rsAccion" datasource="#session.DSN#">
                            select RHPcodigoAlt
                            from RHAcciones
                            where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHAlinea#">
                        </cfquery>
                        <cfif rsAccion.RecordCount and LEN(TRIM(rsAccion.RHPcodigoAlt)) GT 0>
                            <cfset rsComp.RHPcodigoAlt = rsAccion.RHPcodigoAlt>
                        </cfif>
                    </cfif>
                    
                    <!--- VERIFICAR SI TIENE UN PUESTO ALTERNO QUE CAMBIA LA CATEGORIA --->
                    <cfset Lvar_RHTTid = 0>
                    <cfset Lvar_RHMPPid = 0>
                    <cfset Lvar_RHCid = 0>
                    <cfif rsComp.RecordCount GT 0 and rsComp.RHPcodigoAlt GT 0>
                        <cfquery name="rsCatPuestoAlt" datasource="#session.DSN#">
                            select RHCPlinea
                            from RHPuestos a
                            inner join RHMaestroPuestoP b
                                on b.RHMPPid = a.RHMPPid
                                and b.Ecodigo = a.Ecodigo
                            inner join RHCategoriasPuesto c
                                on c.RHMPPid = b.RHMPPid
                                and c.Ecodigo = b.Ecodigo
                            where RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsComp.RHPcodigoAlt#">
                              and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                        </cfquery>
                        
                        <cfset Lvar_CatAlt = rsCatPuestoAlt.RHCPlinea>
                        <cfif isdefined('rsCatPuestoAlt') and rsCatPuestoAlt.RecordCount>
                            <cfset Lvar_CatAlt = rsCatPuestoAlt.RHCPlinea>
                       <cfelse>
                            <cfset Lvar_CatAlt = 0>
                        </cfif>
                    </cfif>
            
                    
                    <!---<br>Lvar_CatAlt:<cfdump var="#Lvar_CatAlt#">--->
                    
                    <cfloop query="rsComp">
                        <cfinvoke component="rh.Componentes.RH_EstructuraSalarial" method="calculaComponente" returnvariable="calculaComponenteR">
                            <cfinvokeargument name="CSid" 				value="#rsComp.CSid#"/>
                            <cfinvokeargument name="fecha" 				value="#rsComp.LTdesde#"/>
                            <cfinvokeargument name="fechah" 			value="#rsComp.LThasta#"/>
                            <cfinvokeargument name="DEid" 				value="#rsComp.DEid#"/>
                            <cfinvokeargument name="RHCPlinea" 			value="#Lvar_CatAlt#"/>
                            <cfinvokeargument name="BaseMontoCalculo" 	value="0.00"/>
                            <cfinvokeargument name="Unidades" 			value="#rsComp.DLTunidades#"/>
                            <cfinvokeargument name="Monto" 				value="#rsComp.DLTmonto#"/>
                            <cfinvokeargument name="Metodo" 			value="#rsComp.DLTmetodoC#"/>
                            <cfinvokeargument name="TablaComponentes" 	value="DLineaTiempoR"/>
                            <cfinvokeargument name="CampoLlaveTC" 		value="LTRid"/>
                            <cfinvokeargument name="ValorLlaveTC" 		value="#rsLTRid.LTid#"/>
                            <cfinvokeargument name="CampoMontoTC" 		value="DLTmonto"/>
                            <cfinvokeargument name="RHTTid" 			value="0">
                            <cfinvokeargument name="RHCid" 				value="0">
                            <cfinvokeargument name="RHMPPid" 			value="0">
                            <cfinvokeargument name="PorcSalario"		value="#rsComp.LTporcsal#"/>
                            <cfinvokeargument name="RHCPlineaP" 		value="#rsComp.RHCPlineaP#"/>
                        </cfinvoke>
                        
                       <!--- <br>calculaComponenteR:<cfdump var="#calculaComponenteR#">--->
                        
                       <cfquery name="ABC_RHAcciones" datasource="#Session.DSN#">
                            update DLineaTiempoR
                               set DLTunidades 	= <cfqueryparam cfsqltype="cf_sql_float" value="#calculaComponenteR.Unidades#">,
                                   DLTmonto		= <cfqueryparam cfsqltype="cf_sql_money" value="#calculaComponenteR.Monto#">,
                                   DLTmetodoC 	= <cfqueryparam cfsqltype="cf_sql_char" value="#calculaComponenteR.Metodo#">,
                                   DLTmontobase	= <cfqueryparam cfsqltype="cf_sql_char" value="#calculaComponenteR.MontoBase#">,
                                   BMUsucodigo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
                             where LTRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLTRid.LTid#">
                               and CSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsComp.CSid#">
                        </cfquery>
                    </cfloop>
                    
                    <!--- se hace la suma de los componente para el total del salario --->
                    
                    
                    <cfquery datasource="#session.DSN#">
                        update LineaTiempoR
                        set LTsalario = coalesce((select sum(DLTmonto)
                                        from LineaTiempoR a
                                        inner join DLineaTiempoR b
                                            on b.LTRid = a.LTRid
                                        where a.LTRid = LineaTiempoR.LTRid
                                          and a.Ecodigo = LineaTiempoR.Ecodigo),0),
                             BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
                        where LTRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLTRid.LTid#">
                          and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                    </cfquery>
                 </cfloop>
                
                <cfquery name="rsRFin" datasource="#conexion#">
                   select 
                        a.LTRid as LTid
                        , a.CSid
                        , b.CSdescripcion
                        , a.DLTmonto
                        , a.DLTunidades
                        , a.DLTtabla
                        , a.CIid
                        , a.DLTmetodoC
                        , a.RHPid
                        , a.RHPcodigo
                        , a.DLTmontobase
                        from DLineaTiempoR a
                        inner join ComponentesSalariales b
                        on a.CSid = b.CSid
                        where a.LTRid in (select lt.LTRid
                                            from LineaTiempoR lt
                                           	where not ((lt.LTdesde < <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.Desde#">  and lt.LThasta < <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.Desde#">) 
                                                or  (<cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.Hasta#"> < lt.LTdesde and  <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.Hasta#">   < lt.LThasta))
                                            <cfif isdefined('Arguments.DEid') and Arguments.DEid>
                                            	and lt.DEid in (#Arguments.DEid#)
                                            </cfif>
                                         )
                                                
                        and a.DLTmonto >= 0
                        and a.CIid > 0
                        <cfif isdefined('Arguments.ListaCSid')>
                            and a.CSid in (#Arguments.ListaCSid#)
                        </cfif>
                        order by a.LTRid, a.CSid 
                </cfquery>
                
                <cfif arguments.debug>
                	<cfdump var="Lineas de tiempo Recargo antes de aplicar">
                    <cfdump var="#rsLTRid#">
                    
	                <cfdump var="Cortes Despues de aplicado Linea Recargo">
                    <cfdump var="#rsRFin#">
                </cfif>
        	</cfif>
        
			<cfif arguments.debug>
                <cftransaction action="rollback">
                <cfdump var="Final de proceso se regresa la transaccion">
                <cfabort>
            </cfif>

        </cftransaction>

        <cfreturn true>
	</cffunction>
</cfcomponent>