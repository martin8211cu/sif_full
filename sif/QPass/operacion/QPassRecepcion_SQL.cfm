
<cfif isdefined("form.BTNBORRAR.X")>
	<cftransaction>
        <cfquery datasource="#session.DSN#">
            update QPassTraslado
                set QPTtrasEstado = 0,
				BMFecha = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
                Usucodigo = #session.Usucodigo#
            where QPTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.QPTid#">
            and QPTtrasEstado in (1,2)
        </cfquery>
        
        <!--- Inserta en la bitácora indicando 10: Rechazo documento en Recepción de tags en el campo QPTMovtipoMov --->
        <cfquery datasource="#session.dsn#">
            insert into QPassTagMov (
                    QPTidTag, 
                    QPTMovtipoMov, 
                    QPTNumParte, 
                    QPTFechaProduccion, 
                    QPTNumSerie, 
                    QPTPAN, 
                    QPTNumLote, 
                    QPTNumPall, 
                    QPTEstadoActivacion, 
                    Ecodigo, 
                    Ocodigo, 
                    OcodigoDest, 
                    QPidLote, 
                    QPidEstado, 
                    BMFecha, 
                    BMusucodigo)
            select
                    a.QPTidTag, 
                    10,  <!--- 10 --->
                    a.QPTNumParte, 
                    a.QPTFechaProduccion, 
                    a.QPTNumSerie, 
                    a.QPTPAN, 
                    a.QPTNumLote, 
                    a.QPTNumPall, 
                    a.QPTEstadoActivacion, 
                    a.Ecodigo, 
                    a.Ocodigo, 
                    a.Ocodigo, 
                    a.QPidLote, 
                    a.QPidEstado, 
                    #now()#, 
                    #session.Usucodigo#
            from QPassTag a
            	inner join QPassTrasladoOfi b
                	on b.QPTidTag = a.QPTidTag
            where b.QPTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.QPTid#">
	          and b.QPTOEstado =0
        </cfquery>
   	</cftransaction>
    
	<cflocation url="QPassRecepcion.cfm" addtoken="no">

<cfelseif isdefined("BTNACEPTAR_TRASLADO")>
	<cftransaction>
		<!--- Actualiza el estado del documento a 2, luego verifica cuantos fueron aceptados --->
        <cfquery datasource="#session.DSN#">
            update QPassTraslado
            set QPTtrasEstado = 2, <!--- Aceptados no todos los tags del documento --->
				BMFecha = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
                Usucodigo = #session.Usucodigo#
            where QPTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.QPTid#">
        </cfquery>
    
        
        <cfloop list="#form.chk#" delimiters="," index="i">
            <!--- Pasar el estado de todos los Tags seleccionados, de 8 a 1 (1: En Banco / Almacen o Sucursal a 8: En traslado sucurcal/PuntoVenta) y actualizar la oficina --->
            <cfquery datasource="#session.DSN#">
                update QPassTag 
                set QPTEstadoActivacion = 1,
                	Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OcodigoDest#">,
					BMFecha = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
               		BMusucodigo = #session.Usucodigo#
                where QPTidTag = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
                and QPTEstadoActivacion = 8
            </cfquery>
            
            <!--- Pasa el estado del tag en la tabla QPassTrasladoOfi  a Aceptado--->
            <cfquery datasource="#session.DSN#">
                update QPassTrasladoOfi
                set QPTOEstado = 1, <!--- 1 Traslado aceptado --->
				BMFecha = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
                where QPTidTag = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
                and QPTOEstado = 0 <!--- 0 En traslado --->
            </cfquery>

            <!--- Inserta en la bitácora indicando 4:  Recepcion de Traslado hacia Oficinas en el campo QPTMovtipoMov --->
            <cfquery datasource="#session.dsn#">
                insert into QPassTagMov (
                        QPTidTag, 
                        QPTMovtipoMov, 
                        QPTNumParte, 
                        QPTFechaProduccion, 
                        QPTNumSerie, 
                        QPTPAN, 
                        QPTNumLote, 
                        QPTNumPall, 
                        QPTEstadoActivacion, 
                        Ecodigo, 
                        Ocodigo, 
                        OcodigoDest, 
                        QPidLote, 
                        QPidEstado, 
                        BMFecha, 
                        BMusucodigo)
                select
                        QPTidTag, 
                        4, 
                        QPTNumParte, 
                        QPTFechaProduccion, 
                        QPTNumSerie, 
                        QPTPAN, 
                        QPTNumLote, 
                        QPTNumPall, 
                        QPTEstadoActivacion, <!--- como ya actualice el estado en 1 arriba, no tengo que poner 1 fijo --->
                        Ecodigo, 
                        Ocodigo, 
                        Ocodigo, 
                        QPidLote, 
                        QPidEstado, 
                        #now()#, 
                        #session.Usucodigo#
                from QPassTag
                where QPTidTag = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
        	</cfquery>
        </cfloop>
        
        
        <!--- Busca la cantidad de tags para un documento --->
        <cfquery name="rsCantTagsxDoc" datasource="#session.DSN#">
            select count(1) as cantidad
            from QPassTrasladoOfi
            where QPTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.QPTid#">
        </cfquery>
        
        <!--- Busca la cantidad de tags aceptados para un documento --->
        <cfquery name="rsCantTagsPasados" datasource="#session.DSN#">
            select count(1) as cantidad
            from QPassTrasladoOfi
            where QPTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.QPTid#">
            and QPTOEstado = 1 <!--- Tags aceptados --->
        </cfquery>
        
        <!--- Si encuentra que ya todos los tags del documento fueron aceptados, actualiza el estado del documento a 'todos aceptados' --->
        <cfif rsCantTagsxDoc.cantidad eq  rsCantTagsPasados.cantidad>
            <cfquery datasource="#session.DSN#">
                update QPassTraslado
                set QPTtrasEstado = 3, <!--- Aceptados todos los tags del documento --->
				BMFecha = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
                Usucodigo = #session.Usucodigo#
                where QPTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.QPTid#">
            </cfquery>
        </cfif>
    </cftransaction>
    <cfif rsCantTagsxDoc.cantidad eq  rsCantTagsPasados.cantidad>
	    <cflocation url="QPassRecepcion.cfm" addtoken="no">
    <cfelse>
    	<cflocation url="QPassRecepcion_form.cfm?QPTid=#form.QPTid#" addtoken="no">
    </cfif>
    
</cfif>