<cfif isdefined("Form.btnDevolver")>
	<cfif isdefined("form.chk") and len(trim(form.chk)) GT 0>
        <cfloop delimiters="," list="#form.chk#" index="i">
            <!--- Acutaliza el Tag en poder del Banco y pone los campos QPPid y QPTFAsignaPromot en null --->
            <cftransaction>
                <!--- Bloqueo el registro --->
                <cfquery datasource="#session.dsn#">
                    update QPassTag
                    set QPTEstadoActivacion = QPTEstadoActivacion
                    where QPTidTag = #i#
                </cfquery>

                <!--- inserta en la bitácora --->
                <cfquery datasource="#session.DSN#">
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
                        12,  <!--- 12: Asignado a Encargado --->
                        a.QPTNumParte, 
                        a.QPTFechaProduccion, 
                        a.QPTNumSerie, 
                        a.QPTPAN, 
                        a.QPTNumLote, 
                        a.QPTNumPall, 
                        1, 
                        a.Ecodigo, 
                        a.Ocodigo, 
                        a.Ocodigo, 
                        a.QPidLote, 
                        a.QPidEstado, 
                        #now()#, 
                        #session.Usucodigo#,
                        null,
                        null
                    from QPassTag a
                    where a.QPTidTag = #i#
                    and a.QPTEstadoActivacion in (9)
                </cfquery>
                <cfquery datasource="#session.DSN#">
                	update QPDAsignaPromotor
                    set BMFecha = #now()#,
                    QPDAPestado = 2 <!--- 2 Devuelto --->
                    where QPTidTag = #i#
                    and QPEAPid = #form.QPEAPid#
                </cfquery>
                <cfquery datasource="#session.dsn#">
                    update QPassTag
                    set QPTEstadoActivacion = 1, <!--- En Banco / Almacen o Sucursal --->
                        QPPid = null,
                        QPTFAsignaPromot = null
                    where QPTidTag = #i#
                    and QPTEstadoActivacion in (9)
                </cfquery>
            </cftransaction>
        </cfloop>

         <cfquery name="rs" datasource="#session.DSN#">
            select count(1) as cantidad
            from QPDAsignaPromotor a
                inner join QPassTag b
                    on b.QPTidTag = a.QPTidTag
            where a.QPEAPid = #form.QPEAPid#
            and b.QPTEstadoActivacion = 9
        </cfquery>
      	<cfif rs.cantidad eq 0>
            <cfquery datasource="#session.DSN#">
                update QPEAsignaPromotor
                set QPEAPEstado = 2 <!--- Documento sin Tags, ya se por devoluciones o por ventas --->
                where QPEAPid = #form.QPEAPid#
           </cfquery>
        </cfif>

        <cfif rs.cantidad eq 0>
			<cfset form.irA="DevulveSucursal.cfm">
        <cfelse>
        	<cfset form.irA="DevulveSucursal.cfm?QPEAPid=#form.QPEAPid#">
        </cfif>
        <cfinclude template="Comprobante_Devolucion.cfm">
	</cfif>
</cfif>