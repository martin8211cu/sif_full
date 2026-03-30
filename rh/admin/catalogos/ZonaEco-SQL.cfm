<!--- <cfdump var="#form#">
<cf_dump var="#url#"> --->

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="Error_La_zona_economica_ya_esta_definida_en_la_corporacion_debe_utilizar_un_codigo:distinto_Proceso_Cancelado"
Default="Error! La zona econ&oacute;mica ya est&aacute; definida en la corporaci&oacute;n, debe utilizar un c&oacute;digo distinto. Proceso Cancelado"
returnvariable="MG_ZonaEconomica"/> 



<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="Error_Agregando_Salario_Minimo_La_fecha_indicada_es_menor_o_igual_a_la_ultima_fecha_de_inicio_de_Salario_Mínimo_de_esta_Zona_Proceso_Cancelado"
Default="Error Agregando Salario M&iacute;nimo. La fecha indicada es menor o igual a la &uacute;ltima fecha de inicio de Salario M&iacute;nimo de esta Zona. Proceso Cancelado."
returnvariable="MG_SalarioMinimo"/> 



<cffunction name="fncambio" returntype="boolean">
	<cfargument name="zeid" type="numeric">
	<cfargument name="cod" type="string">
	<cfquery name="rse" datasource="#session.dsn#">
		select count(1) as cambio
		from ZonasEconomicas
		where ZEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.zeid#">
		and rtrim(ltrim(ZEcodigo)) = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(arguments.cod)#">
		and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	</cfquery>
	<cfreturn (rse.cambio EQ 0)/>
</cffunction>
<cffunction name="fnnotExists" returntype="boolean">
	<cfargument name="cod" type="string">
	<cfquery name="rse" datasource="#session.dsn#">
		select count(1) as existen
		from ZonasEconomicas
		where ZEcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(arguments.cod)#">
		and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	</cfquery>
	<cfif rse.existen>
		<cf_throw message="#MG_ZonaEconomica#" errorcode="2130"/>
	</cfif>
	<cfreturn (rse.existen EQ 0)/>
</cffunction>

<cfif isdefined("NUEVOMINIMO")>
	<cflocation url="ZonaEco.cfm?ZEid=#form.ZEid#&PageNum=#form.PageNum#">	
</cfif>
<cfif isdefined("CERRARMINIMO")>
 		<!--- Busca el maximo Fdesde cerrado --->
		<cfquery name="rsFdesdeCerrado" datasource="#session.dsn#">
            select max(SZEdesde) as maxfdesdeCerrado
            from SalarioMinimoZona
            where ZEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ZEid#">
              and SZEestado = 1
        </cfquery>    <!--- <cfdump var="#rsFdesdeCerrado#"> --->
		<!--- Busca el maximo Fdesde abirto, por si cambiaron en el form el campo SZEdesde --->
		<cfquery name="rsFdesdeAbierto" datasource="#session.dsn#">
            select max(SZEdesde) as maxfdesdeAbierto
            from SalarioMinimoZona
            where ZEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ZEid#">
              and SZEestado = 0
        </cfquery>     
        <cftransaction action="begin">
			<!--- Verifica si hay registros cerrados  --->   
            <cfif isdefined("rsFdesdeCerrado") and len(trim(rsFdesdeCerrado.maxfdesdeCerrado))>
                <!--- a esa fecha se le resta para sacar la "fecha Hasta" anterior y se actualiza ese registro con el varlor de form.Fdesde - 1 --->
                <cfquery datasource="#session.dsn#">
                    update SalarioMinimoZona
                        set SZEhasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d',-1,rsFdesdeAbierto.maxfdesdeAbierto)#">
                    where ZEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ZEid#">
                      and SZEdesde = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDatetime(rsFdesdeCerrado.maxfdesdeCerrado)#">
                      and SZEestado = 1
                </cfquery>
            </cfif>
    
            <!--- Cierra  --->
            <cfquery datasource="#session.dsn#">
                update SalarioMinimoZona
                set SZEestado = 1
                where ZEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ZEid#">
                and SZEdesde = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsFdesdeAbierto.maxfdesdeAbierto#"> <!--- por si cambiaron en el form el campo SZEdesde --->
                and SZEestado = 0
            </cfquery>
            <cftransaction action="commit"/>
		</cftransaction>    
	<cflocation url="ZonaEco.cfm?ZEid=#form.ZEid#&PageNum=#form.PageNum#">	
</cfif>


<cfif isdefined("CAMBIOMINIMO")>
	<!--- Buscar el archivo anterior con la "fecha desde" máxima del ZEid actual (porque la del form puede venir diferente). Este es el único registro que en teoría pude 
	estar abierto --->
	<cfquery name="rsmaxfdesde" datasource="#session.dsn#">
        select max(SZEdesde) as maxfdesde 
        from SalarioMinimoZona
        where ZEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ZEid#">
        and SZEestado = 0
    </cfquery>
    
    <!--- Busca el maximo Fdesde cerrado --->
    <cfquery name="rsFdesdeCerrado" datasource="#session.dsn#">
        select max(SZEdesde) as maxfdesdeCerrado
        from SalarioMinimoZona
        where ZEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ZEid#">
          and SZEestado = 1
    </cfquery>

	<!--- si cambia la fechadesde también se tiene que actulizar el registro anterior  --->
    <cfif isdefined("rsmaxfdesde") and rsmaxfdesde.maxfdesde neq LSParseDatetime(form.SZEdesde)> 
		<!--- Valida que la fechadesde del registro abierto no sea menor que la fechadesde del registro cerrado --->
    	<cfif DateCompare(rsFdesdeCerrado.maxfdesdeCerrado, LSParseDatetime(form.SZEdesde)) GTE 0>
            <cf_throw message="#MG_SalarioMinimo#" errorcode="2135">
        </cfif>

		<!--- Ahora se puede actualizar el registro actual --->
        <cfquery datasource="#session.dsn#">
            update SalarioMinimoZona
                set SZEdesde = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDatetime(form.szedesde)#">
            where ZEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ZEid#">
              and SZEdesde = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDatetime(rsmaxfdesde.maxfdesde)#">
               and SZEestado = 0
        </cfquery>
    </cfif>

    <!--- Actualiza el salario minimo --->
    <cfquery datasource="#session.dsn#">
        update SalarioMinimoZona
            set SZEsalarioMinimo  = <cfqueryparam cfsqltype="cf_sql_money" value="#form.SZEsalarioMinimo#">
        where ZEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ZEid#">
          and SZEdesde = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDatetime(form.szedesde)#">
    </cfquery>
    
    
	<cflocation url="ZonaEco.cfm?ZEid=#form.ZEid#&PageNum=#form.PageNum#">
</cfif>

<cfif isdefined("form.BAJAMINIMO")>
	<!--- solo un registro puede estar abierto y siempre va ser el mas reciente --->
    <cfquery datasource="#session.dsn#">
        delete from SalarioMinimoZona
        where ZEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ZEid#">
          and SZEdesde = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDatetime(form.szedesde)#">
          and SZEestado = 0
    </cfquery>
    
    <cfquery name="rsmaxfdesde" datasource="#session.dsn#">
        select max(SZEdesde) as maxfdesde 
        from SalarioMinimoZona
        where ZEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ZEid#">
        and SZEestado = 1
    </cfquery>
    
    <!--- si se borra el actual hay que actualizar la "fecha hasta" del "nuevo" registro actual (que era penúltimo) --->
	<cfif rsmaxfdesde.recordcount eq 1>
		<cfset LvarfHasta = createdate(6100,01,01)>
        <cfquery datasource="#session.dsn#">
            update SalarioMinimoZona
            set SZEhasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#ParseDatetime(LvarfHasta)#">
            where ZEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ZEid#">
            and SZEdesde = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsmaxfdesde.maxfdesde#">
            and SZEestado = 1
        </cfquery>
	</cfif>            
        
    <cflocation url="ZonaEco.cfm?ZEid=#form.ZEid#&PageNum=#form.PageNum#">
</cfif>

<cfif not isdefined("form.Nuevo")>
	<cfif isdefined("form.Alta")>
        <cfif fnnotExists(form.ZEcodigo)>
            <cfquery name="rsInsert" datasource="#session.dsn#">
                insert into ZonasEconomicas (CEcodigo,Ppais,ZEcodigo,ZEdescripcion)
                values(
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
                    , <cfqueryparam cfsqltype="cf_sql_char" value="#form.Ppais#">
                    , <cfqueryparam cfsqltype="cf_sql_char" value="#form.ZEcodigo#">
                    , <cfqueryparam cfsqltype="cf_sql_char" value="#form.ZEdescripcion#">
                )
            <cf_dbidentity1 name="rsInsert" datasource="#session.dsn#">
		</cfquery>
		<cf_dbidentity2 name="rsInsert" datasource="#session.dsn#" returnvariable="rsZEid" >
        </cfif>
    <cflocation url="ZonaEco.cfm?ZEid=#rsZEid#">
    <cfelseif isdefined("form.Cambio")>
        <cf_dbtimestamp
            datasource="#session.dsn#"
            table="ZonasEconomicas"
            redirect="ZonaEco.cfm"
            timestamp="#form.ts#"
            field1="ZEid,numeric,#form.ZEid#">		
        <cfquery datasource="#session.dsn#">
            update ZonasEconomicas
            set Ppais = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Ppais#">
                <cfif fncambio(form.ZEid,form.ZEcodigo) and fnnotExists(form.ZEcodigo)>
                    ,ZEcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.ZEcodigo#">
                </cfif>
                ,ZEdescripcion = <cfqueryparam cfsqltype="cf_sql_char" value="#form.ZEdescripcion#">
            where ZEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ZEid#">
            and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session..CEcodigo#">
        </cfquery>
        <cflocation url="ZonaEco.cfm?ZEid=#form.ZEid#&PageNum=#form.PageNum#">
    <cfelseif isdefined("form.Baja")>
    
    	<cfquery name="rs" datasource="#session.DSN#">
        	select count(1) as cantidad
            from SalarioMinimoZona
            where ZEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ZEid#">
            and SZEestado = 1
        </cfquery>
        <cfif rs.cantidad gt 0>
        	<cfthrow message="No se puede borrar la Zona Económica ya que tiene registros de salarios mínimos cerrados">
        <cfelse>
        	<cfquery datasource="#session.dsn#">
            	delete from SalarioMinimoZona
                where ZEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ZEid#">
            </cfquery>
            <cfquery datasource="#session.dsn#">
                delete from ZonasEconomicas
                where ZEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ZEid#">
                and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session..CEcodigo#">
            </cfquery>
        </cfif>
        
    <cfelseif isdefined("form.ALTAMINIMO")>
        <cfquery name="rsMinimoAnterior" datasource="#session.dsn#">
            select max(SZEdesde) as maxfdesde 
            from SalarioMinimoZona
            where ZEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ZEid#">
        </cfquery><!--- <cfdump var="#rsMinimoAnterior#"> --->
        
        <cfif rsMinimoAnterior.recordcount EQ 0 or len(rsMinimoAnterior.maxfdesde) LT 1>
            <cfset Lvarmaxfdesde = createdate(1899,12,31)>
        <cfelse>
            <cfset Lvarmaxfdesde = rsMinimoAnterior.maxfdesde>
        </cfif>
    
        <cfif DateCompare(Lvarmaxfdesde,LSParseDatetime(form.SZEdesde)) GTE 0>
            <cf_throw message="#MG_SalarioMinimo#" errorcode="2135">
        </cfif>
        <cftransaction action="begin">
            <cfset LvarfHasta = createdate(6100,01,01)>
            
            <cfquery datasource="#session.dsn#">
                insert into SalarioMinimoZona(ZEid,SZEdesde,SZEhasta,SZEsalarioMinimo, SZEestado)
                values(
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ZEid#">
                    , <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDatetime(form.SZEdesde)#">
                    , <cfqueryparam cfsqltype="cf_sql_timestamp" value="#ParseDatetime(LvarfHasta)#">
                    , <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(form.SZEsalarioMinimo,',','','all')#">
                    , 0
                )
            </cfquery>
	    	<cftransaction action="commit"/>
        </cftransaction>
        <cflocation url="ZonaEco.cfm?ZEid=#form.ZEid#&PageNum=#form.PageNum#">
    </cfif>
</cfif>
<cfparam name="params" default="" type="string">
<cflocation url="ZonaEco.cfm#params#">