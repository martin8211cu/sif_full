<cfif isdefined("Form.Alta")>
	<cflock name="ConseAsig#session.Ecodigo#" type="exclusive" timeout="3">
        <cfquery name="rsNewDiq" datasource="#session.dsn#">
            select coalesce(max(<cf_dbfunction name="to_integer" args="QPEAPDocumento">),0) + 1 as newDoc
            from QPEAsignaPromotor 
            where Ecodigo = #session.Ecodigo#
        </cfquery>
        <cfquery name="insertTras" datasource="#session.dsn#">
            insert into QPEAsignaPromotor (Usucodigo, Ecodigo, QPPid, QPEAPDocumento, QPEAPDescripcion, QPEAPEstado, QPEAPFechaAsignacion, BMFecha)
            values(
                    #session.Usucodigo#,
                    #session.Ecodigo#,
                    #form.QPPid#,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsNewDiq.newDoc#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.QPEAPDescripcion#">,
                    0,
                    #now()#,
                    #now()#
                    )
            <cf_dbidentity1 datasource="#Session.DSN#" verificar_transaccion="false">
        </cfquery>
        <cf_dbidentity2 datasource="#Session.DSN#" name="insertTras" verificar_transaccion="false" returnvariable="QPEAPid">
    </cflock>
	<cflocation url="TagPromotores.cfm?QPEAPid=#QPEAPid#" addtoken="no">

<cfelseif isdefined("Form.btnSeleccionar")>
	<cfif isdefined("form.chk") and len(trim(form.chk)) GT 0>
		<cfloop delimiters="," list="#form.chk#" index="i">
			<cfquery datasource="#session.dsn#">
					insert into QPDAsignaPromotor 
						(	
							QPEAPid,
							QPTidTag,
							QPDAPestado, 
							BMFecha
						)
						values
						(
							#form.QPEAPid#,
							#i#,
							0,
							#now()#
						)
				</cfquery>
		
			<cfquery name="updateEstado" datasource="#session.dsn#">
				update QPassTag
				set QPTEstadoActivacion = 9 <!--- Asignando Promotor --->
				where QPTidTag=#i#
			</cfquery>
		</cfloop>
		<cflocation url="Promotores.cfm?QPEAPid=#form.QPEAPid#" addtoken="no">
	</cfif>

<cfelseif isdefined("form.btnAceptar")>
	<cfif isdefined("form.QPEAPid") and len(trim(form.QPEAPid)) GT 0>
		<cfquery name="rsDoc" datasource="#session.dsn#">
			select a.QPTidTag, b.QPPid
            from QPDAsignaPromotor a
            	inner join QPEAsignaPromotor b
                	on b.QPEAPid = a.QPEAPid
			where a.QPEAPid = #form.QPEAPid#
		</cfquery>
		<cftransaction>		
            <cfloop query="rsDoc">
                <cfquery name="InsertMov" datasource="#session.DSN#">
                    insert into QPassTagMov 
                    (
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
                        BMusucodigo,
                        QPPid,
                        QPTFAsignaPromot
                    )
                    select
                        a.QPTidTag, 
                        11,  <!--- 11: Asignado a Promotor --->
                        a.QPTNumParte, 
                        a.QPTFechaProduccion, 
                        a.QPTNumSerie, 
                        a.QPTPAN, 
                        a.QPTNumLote, 
                        a.QPTNumPall, 
                        QPTEstadoActivacion, 
                        a.Ecodigo, 
                        a.Ocodigo, 
                        a.Ocodigo, 
                        a.QPidLote, 
                        a.QPidEstado, 
                        #now()#, 
                        #session.Usucodigo#,
                        #rsDoc.QPPid#,
                        #now()#
                    from QPassTag a
                        inner join QPDAsignaPromotor b
                        on a.QPTidTag = b.QPTidTag
                    where b.QPEAPid = #form.QPEAPid#
                    and a.QPTidTag = #rsDoc.QPTidTag#
                </cfquery>
                <cfquery datasource="#session.DSN#">
                    update QPDAsignaPromotor
                    set QPDAPestado = 1
                    where QPEAPid = #form.QPEAPid#
                    and QPTidTag = #rsDoc.QPTidTag#
                </cfquery>
                <cfquery name="updateEstado" datasource="#session.dsn#">
                    update QPassTag
                    set QPPid = #rsDoc.QPPid#,
                        QPTFAsignaPromot = #now()#
                    where QPTidTag=#rsDoc.QPTidTag#
                </cfquery>
            </cfloop>
            
            <cfquery datasource="#session.DSN#">
                update QPEAsignaPromotor
                set QPEAPEstado = 1
                where QPEAPid=#form.QPEAPid#
            </cfquery>
        </cftransaction>	
	</cfif>
<cflocation url="Promotores.cfm" addtoken="no">

<cfelseif isdefined("form.BorrarDet") and len(trim(form.BorrarDet))>
	<cftransaction>
        <cfquery datasource="#session.DSN#">
            delete from QPDAsignaPromotor
            where  QPTidTag  = #form.BorrarDet#
        </cfquery>	
    
        <cfquery datasource="#session.DSN#">
            update QPassTag
                set QPTEstadoActivacion = 1,
                QPPid = null,
                QPTFAsignaPromot = null
                where QPTidTag=#form.BorrarDet#
        </cfquery>
    </cftransaction>
	<cflocation url="Promotores.cfm?QPEAPid=#form.QPEAPid#" addtoken="no">
</cfif>
<cflocation url="TagPromotores.cfm" addtoken="no">