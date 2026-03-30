<cfset LvarPar = ''>

<cfset IDtrans = 11>

<cfif isdefined("Imprimir")>
 <cflocation url="Salida_Activos_Fijos-rpt.cfm?AFESid=#form.AFESid#">
</cfif>

<cfif isdefined("Alta")>
<cfset Fecha = "#LSDateFormat(form.Fechaa,'YYYY/MM/DD')#">



<cftransaction>
	<cftry>

			<cfif form.Movimiento EQ 2 or form.Movimiento EQ 3>

                <cfquery name="idquery" datasource="#Session.DSN#">
                    insert into AFEntradaSalidaE(
                        Ecodigo
                        , TipoMovimiento
                        , Descripcion
					<cfif form.Movimiento NEQ 3>
                        , AFMSid
					</cfif>
                        , Fecha
                        , AFDSid
                        , FechaRegreso
                        , Autoriza
					<cfif form.Movimiento EQ 3>
						,contrato
					</cfif>
                        , Observaciones
                        , Usuaplica
                    )
                    values (
                             #session.Ecodigo# ,
                             <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Movimiento#">,
                             <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Descripcion#">,
						<cfif form.Movimiento NEQ 3>
                             <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Motivo#">,
                        </cfif>
							<cf_jdbcquery_param cfsqltype="cf_sql_date" 	value="#LSDateFormat(Form.Fechaa,'YYYY/MM/DD')#">,
                             <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Destino#">,
                             <cf_jdbcquery_param cfsqltype="cf_sql_date" 	value="#LSDateFormat(Form.FechaRegreso,'YYYY/MM/DD')#">,
                             <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Autoriza#">,
                        <cfif form.Movimiento EQ 3>
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.contrato#">,
						</cfif>
                             <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Observaciones#">,
                             <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">)

                    <cf_dbidentity1 datasource="#Session.DSN#"  verificar_transaccion="false">
                        </cfquery>
                        <cf_dbidentity2 datasource="#Session.DSN#" name="idquery"  verificar_transaccion="false">
            <cfelseif form.Movimiento EQ 1 or form.Movimiento EQ 4>
                <cfquery name="idquery" datasource="#Session.DSN#">
                     insert into AFEntradaSalidaE(
                        Ecodigo
                        , TipoMovimiento
                        , Fecha
                        , Observaciones
                        , Usuaplica
                    )
                    values (
                             #session.Ecodigo# ,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Movimiento#">,
                           <cf_jdbcquery_param cfsqltype="cf_sql_date" 	value="#LSDateFormat(Form.Fechaa,'YYYY/MM/DD')#">,
                              <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Observaciones#">,
                            <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">)
                    <cf_dbidentity1 datasource="#Session.DSN#"  verificar_transaccion="false">
                        </cfquery>
                        <cf_dbidentity2 datasource="#Session.DSN#" name="idquery"  verificar_transaccion="false">

            </cfif>


 <cfcatch type="database">
 			<cftransaction action="rollback">
           <cfabort showerror="#cfcatch.SQLState#"><!---NativeErrorCode o detail--->
          </cfcatch>
        </cftry>
     </cftransaction>
<cfset AFESid = #idquery.identity#>
</cfif>


<cfif isdefined("Cambio") or isdefined("CambioDet")>
	<cfquery name="rsMovimiento" datasource="#session.dsn#">
		select TipoMovimiento
		from AFEntradaSalidaE
		where AFESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFESid#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>


    <cfif rsMovimiento.TipoMovimiento EQ 1>

            <cfquery datasource="#session.dsn#">
                update AFEntradaSalidaE
                set
                Fecha = <cf_jdbcquery_param cfsqltype="cf_sql_date" 	value="#LSDateFormat(Form.Fechaa,'YYYY/MM/DD')#">
                , Observaciones = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Observaciones#">
                where AFESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFESid#">
                and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
            </cfquery>
    <cfelseif rsMovimiento.TipoMovimiento EQ 2 or rsMovimiento.TipoMovimiento EQ 3>

            <cfquery datasource="#session.dsn#">
                update AFEntradaSalidaE
                set AFDSid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Destino#">
                , Descripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Descripcion#">
                , Fecha = <cf_jdbcquery_param cfsqltype="cf_sql_date" 	value="#LSDateFormat(Form.Fechaa,'YYYY/MM/DD')#">
                , FechaRegreso = <cf_jdbcquery_param cfsqltype="cf_sql_date" 	value="#LSDateFormat(Form.FechaRegreso,'YYYY/MM/DD')#">
			<cfif rsMovimiento.TipoMovimiento NEQ 3>
                , AFMSid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Motivo#">
            </cfif>
			<cfif rsMovimiento.TipoMovimiento EQ 3>
				,contrato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.contrato#">
			</cfif>
				, Autoriza = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.autoriza#">
                , Observaciones = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Observaciones#">
                where AFESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFESid#">
                and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
            </cfquery>

	</cfif>
	<cfset AFESid = form.AFESid>
		
</cfif>


<cfif isdefined("Baja")>
	<cfquery name="rsDelete0" datasource="#session.dsn#">
		select count(1) as Registros
		from AFEntradaSalidaD
		where AFESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFESid#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfquery name="rsCheckToDelete" datasource="#session.dsn#">
		select count(1) as Registros
		from AFEntradaSalidaE
		where AFESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFESid#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">

	</cfquery>
	<cfif (rsDelete0.Registros GT 0)>
		<cfquery datasource="#session.dsn#">
			delete
			from AFEntradaSalidaD
			where AFESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFESid#">
		</cfquery>
	</cfif>
    <cfif (rsCheckToDelete.Registros GT 0)>

		<cfquery datasource="#session.dsn#">
			delete
			from AFEntradaSalidaE
			where AFESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFESid#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
	</cfif>
	<cfset AFESid = 0>
</cfif>

<!---*********************ASOCIAR********************************--->
<!---*Las validaciones del Activos se realizan en el componente**--->
<cfif isdefined("btnAsociar")>
		<cfquery name = "rsVerificaMovimientoActivo" datasource="#session.dsn#">
			select top 1 *,(select TipoMovimiento  from AFEntradaSalidaE where AFESid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFESid#">) as TipoMovimiento
            from Activos
            where  Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">
            and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and AEntradaSalida = (select TipoMovimiento from AFEntradaSalidaE
            where AFESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFESid#">)
		</cfquery>

		<cfquery name = "rsStatusActivo" datasource="#session.dsn#">
			select top 1 *,AEntradaSalida as StsAct,(select TipoMovimiento  from AFEntradaSalidaE where AFESid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFESid#">) as TipoMovimiento
            from Activos
            where  Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">
            and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>


		<cfquery name = "rsVerificaActivoEnMismoRegistro" datasource="#session.dsn#">
			select top 1 *,(select TipoMovimiento  from AFEntradaSalidaE where AFESid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFESid#">) as TipoMovimiento
            from Activos
            where  Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">
			and Aid in (select Aid from AFEntradaSalidaD where AFESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFESid#">)
		</cfquery>

        <cfquery name = "rsVerificaActivoEnOtrosRegistros" datasource="#session.dsn#">
			select top 1 *,(select TipoMovimiento  from AFEntradaSalidaE where AFESid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFESid#">) as TipoMovimiento
            from Activos
            where  Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">
			and Aid in (select Aid from AFEntradaSalidaD a
									inner join AFEntradaSalidaE b
									on a.AFESid = b.AFESid
									and b.Aplicado = 0
                                    where a.AFESid <>  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFESid#">)
		</cfquery>


		<cfquery name = "rsVerificaEstatusActivo" datasource="#session.dsn#">
                select a.Aid,a.Aplaca, a.Adescripcion, a.Aserie, uMov.Fecha,
                  m.AFMdescripcion,mm.AFMMdescripcion,
                  case uMov.TipoMovimiento
                    when 2 then 'Fuera'
                    when 1 then 'Devuelto'
                    else 'Sin salidas'
                  end Status,
                  (select TipoMovimiento from AFEntradaSalidaE where AFESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFESid#">) as TipoMovimiento
                 from Activos a
                 left join AFMarcas m
                  on m.AFMid = a.AFMid
                 left join AFMModelos mm
                  on mm.AFMMid = a.AFMMid
                 left join (
                  select b.Aid, e.TipoMovimiento, e.Fecha
                  from AFEntradaSalidaE e
                  inner join (select Aid, max(AFESid) AFESid
                     from AFBitacoraES
                     group by Aid) b
                   on e.AFESid = b.AFESid
                 ) uMov
                  on uMov.Aid = a.Aid
                 where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                 and  a.Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">
		</cfquery>

        <cfif rsStatusActivo.StsAct neq 3 and rsStatusActivo.TipoMovimiento eq 4>
		  <cfthrow message="Este Activo no puede tener Comodato Devuelto porque no esta asociado a un Comodato!.">
		</cfif>

        <cfif (rsVerificaEstatusActivo.Status EQ  'Sin salidas' or rsVerificaEstatusActivo.Status EQ  'Devuelto' ) and  rsVerificaEstatusActivo.TipoMovimiento EQ 1>
<!---        <cf_dump var ="#rsVerificaEstatusActivo#">--->
			<cfthrow message="Este Activo no puede tener Entradas porque no tiene Salidas!.">
		<cfelseif rsVerificaMovimientoActivo.recordcount GE 1>
        	<cfif rsVerificaMovimientoActivo.TipoMovimiento EQ 1>
            	<cfset TipoMovimiento = "Entrada">
             <cfelseif rsVerificaMovimientoActivo.TipoMovimiento EQ 2>
             	<cfset TipoMovimiento = "Salida">
			 <cfelseif rsVerificaMovimientoActivo.TipoMovimiento EQ 3>
			    <cfset TipoMovimiento = "Comodato">
			 <cfelse>
			    <cfthrow message="Este Activo no puede tener Comodato Devuelto porque no esta asociado a un Comodato!.">
             </cfif>
        		<cfthrow message="Este Activo ya se encuentra en #TipoMovimiento#!.">
        <cfelseif rsVerificaActivoEnMismoRegistro.recordcount GE 1>
        		<cfthrow message="Este Activo ya se agrego a este registro!.">
        <cfelseif rsVerificaActivoEnOtrosRegistros.recordcount GE 1>
         		<cfthrow message="Este Activo ya se agrego a otro registro!.">


		<cfelse>
<!--- <cf_dump var = "#rsVerificaMovimientoActivo.recordcount#"> --->
		<cfif rsStatusActivo.StsAct gt 1 and rsStatusActivo.StsAct neq 4 and rsStatusActivo.TipoMovimiento neq 1 and rsStatusActivo.TipoMovimiento neq 4>
			<cfif rsStatusActivo.StsAct EQ 2>
            	<cfset TipoMovimiento = "Salida">
              <cfelse>
             	<cfset TipoMovimiento = "Comodato">
            </cfif>

			<cfthrow message="Este Activo se encuentra en #TipoMovimiento#!.">
		</cfif>

                <cfquery name="rsInsertaActivos" datasource="#Session.DSN#">
                insert into AFEntradaSalidaD(
                        AFESid,
                        Aid,
                        Ecodigo
                )
                values (
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFESid#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                        )
                        <cf_dbidentity1 datasource="#Session.DSN#"  verificar_transaccion="false">
                    </cfquery>
                        <cf_dbidentity2 datasource="#Session.DSN#" name="rsInsertaActivos"  verificar_transaccion="false">
               <cfset AFESid = #form.AFESid#>
               <cfset AFESDid = #rsInsertaActivos.identity#>

         </cfif>

</cfif>
<!---*****************APLICAR LA ENTRADA O SALIDA**************************--->
<!---************************************************************--->
<cfif isdefined("btnAplicar")>
<!---  BOTON DE APLICAR DESDE AFUERA --->
	<cfif isdefined("form.chk")>
		<cfset datos = ListToArray(form.chk)>
	<cfloop from="1" to="#ArrayLen(datos)#" index="idx">


	<cfquery name="rsAFEntradaSalidaE" datasource="#session.dsn#">
			select a.* from AFEntradaSalidaE a
	        inner join AFEntradaSalidaD b
	        	on a.AFESid = b.AFESid
	            and a.Ecodigo = b.Ecodigo
			where a.AFESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos[idx]#">
			and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfif rsAFEntradaSalidaE.recordcount GE 1>
<cftransaction>
                <cfquery name="rsTransaccionesActivos" datasource="#session.dsn#">
                    insert into AFBitacoraES(
                        AFESid,
                        Aid,
                        Ecodigo,
                        Usuaplica
                    )
                    select
                        a.AFESid,
                        a.Aid,
                        a.Ecodigo,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
                    from AFEntradaSalidaD a
                        inner join AFEntradaSalidaE b
                            on b.Ecodigo = a.Ecodigo
                            and a.AFESid = b.AFESid
                    where a.AFESid = #datos[idx]#
                </cfquery>

                <cfquery name="rsAplicado" datasource="#session.dsn#">
                    Update AFEntradaSalidaE
                    set Aplicado = 1
                    where AFESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos[idx]#">
                    and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                </cfquery>

            	<cfquery name="rsEstatusActivo" datasource="#session.dsn#">
                    Update Activos
                    set AEntradaSalida = (select distinct TipoMovimiento
                    from AFEntradaSalidaD a
                        inner join AFEntradaSalidaE b
                            on b.Ecodigo = a.Ecodigo
                            and a.AFESid = b.AFESid
                    where a.AFESid = #datos[idx]#)
                    where Aid in (select a.Aid
                    from AFEntradaSalidaD a
                        inner join AFEntradaSalidaE b
                            on b.Ecodigo = a.Ecodigo
                            and a.AFESid = b.AFESid
                    where b.AFESid = #datos[idx]#)
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                </cfquery>

	<!--- Genera la poliza --->
	<cfif rsAFEntradaSalidaE.TipoMovimiento eq 3 or rsAFEntradaSalidaE.TipoMovimiento eq 4>
		<cfquery name="rsAF" datasource="#session.dsn#">
		        select Cconcepto
		        from ConceptoContable
		        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		        and Oorigen = <cfqueryparam cfsqltype="cf_sql_char" value="AFSC">
		</cfquery>

		<cfif not isdefined("rsAF") or rsAF.recordcount EQ 0>
			<cfthrow message = "No se ha definido el origen contable AFSC">
		</cfif>

		<cfset periodo = year('#rsAFEntradaSalidaE.Fecha#')>
		<cfset mes = month('#rsAFEntradaSalidaE.Fecha#')>
	
<cfif rsAFEntradaSalidaE.TipoMovimiento eq 3>
			<cfset Tipo=1>
			<cfset TDescripcion="SALIDA POR COMODATO">
			<cfset EDescripcion="SALIDA DE ACTIVO POR COMODATO">
		<cfelse>
		    <cfset Tipo=2>
		    <cfset TDescripcion="ENTRADA POR COMODATO">
		    <cfset EDescripcion="ENTRADA DE ACTIVO POR COMODATO">
		</cfif>
<cfset origen = 'AFSC'>

<cfset referencia='Comodato Activos'>
<cfif isdefined('form.contrato')>
	<cfset referencia=#form.contrato#>
	<cfset EDescripcion=EDescripcion &' ' & #form.contrato#>
</cfif>

		<!--- Invoca funcion para generar la poliza --->
		<cfset LvarPoliza = GenerarPolizaAF(#periodo#,#mes#,#rsAF.Cconcepto#,#origen#,#rsAFEntradaSalidaE.Fecha#,#TDescripcion#,#datos[idx]#,Tipo,referencia,EDescripcion)>
	</cfif>

</cftransaction>
	 <cfelse>
		<cfthrow message="No se puede aplicar un registro sin Activos Asociados!">
	 </cfif>
		</cfloop>

	</cfif>
</cfif>

<!--- BOTON ELIMINAR --->
<cfif isdefined("btnEliminar")>
	<cfif isdefined("form.chk")>
		<cfset datos = ListToArray(form.chk)>
		<cfloop from="1" to="#ArrayLen(datos)#" index="idx">

                <cfquery name="rsEliminaAF" datasource="#session.dsn#">
                    select
                        a.AFESid,
                        a.Aid,
                        a.Ecodigo,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
                    from AFEntradaSalidaD a
                        inner join AFEntradaSalidaE b
                            on b.Ecodigo = a.Ecodigo
                            and a.AFESid = b.AFESid
                    where a.AFESDid = #datos[idx]#
                    and a.AFESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFESid#">
                </cfquery>

                <cfquery name="rsEliminar" datasource="#session.dsn#">
                    delete AFEntradaSalidaD
                    where AFESDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos[idx]#">
                    and AFESid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFESid#">
                    and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                </cfquery>
		</cfloop>
	</cfif>
</cfif>

<!--- BOTON APLICAR --->
<cfif isdefined("Aplicar")>
<!--- CUANDO SE ENTRA EN DETALLE AQUI FUNCIONA EL BOTON APLICAR --->
	<cfquery name="rsAFEntradaSalidaE" datasource="#session.dsn#">
		select a.* from AFEntradaSalidaE a
        inner join AFEntradaSalidaD b
        	on a.AFESid = b.AFESid
            and a.Ecodigo = b.Ecodigo
		where a.AFESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFESid#">
		and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>

	<cfif rsAFEntradaSalidaE.recordcount GE 1>
<cftransaction>
                <cfloop query="rsAFEntradaSalidaE">
                    <cfquery name="rsTransaccionesActivos" datasource="#session.dsn#">
                                    insert into AFBitacoraES(
                                        AFESid,
                                        Aid,
                                        Ecodigo,
                                        Usuaplica
                                    )
                                    select
                                        a.AFESid,
                                        a.Aid,
                                        a.Ecodigo,
                                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
                                    from AFEntradaSalidaD a
                                        inner join AFEntradaSalidaE b
                                            on b.Ecodigo = a.Ecodigo
                                            and a.AFESid = b.AFESid
                                    where a.AFESid = #form.AFESid#
                                </cfquery>
                </cfloop>

                    <cfquery name="rsAplicado" datasource="#session.dsn#">
                        Update AFEntradaSalidaE
                        set Aplicado = 1
                        where AFESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFESid#">
                        and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                    </cfquery>

                    <cfquery name="rsEstatusActivo" datasource="#session.dsn#">
                                    Update Activos
                                    set AEntradaSalida = (select distinct TipoMovimiento
                                    from AFEntradaSalidaD a
                                        inner join AFEntradaSalidaE b
                                            on b.Ecodigo = a.Ecodigo
                                            and a.AFESid = b.AFESid
                                    where a.AFESid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFESid#">)
                                    where Aid in (select a.Aid
                                    from AFEntradaSalidaD a
                                        inner join AFEntradaSalidaE b
                                            on b.Ecodigo = a.Ecodigo
                                            and a.AFESid = b.AFESid
                                    where b.AFESid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFESid#">)
                                    and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                    </cfquery>

		<!--- Genera la polisa --->
	<cfif rsAFEntradaSalidaE.TipoMovimiento eq 3 or rsAFEntradaSalidaE.TipoMovimiento eq 4>
		<cfquery name="rsAF" datasource="#session.dsn#">
		        select Cconcepto
		        from ConceptoContable
		        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		        and Oorigen = <cfqueryparam cfsqltype="cf_sql_char" value="AFSC">
		</cfquery>
	
		<cfif not isdefined("rsAF") or rsAF.recordcount EQ 0>
			<cfthrow message = "No se ha definido el origen contable AFSC">
		</cfif>
		
		<cfset FechaFormato = LSDateFormat(form.fechaa,'YYYY/MM/DD')>
		
		<cfset periodo = year('#form.fechaa#')>
		<cfset mes = month('#FechaFormato#')>
		
		<cfif rsAFEntradaSalidaE.TipoMovimiento eq 3>
			<cfset Tipo=1>
			<cfset TDescripcion="SALIDA POR COMODATO">
			<cfset EDescripcion="SALIDA DE ACTIVO POR COMODATO">
		<cfelse>
		    <cfset Tipo=2>
		    <cfset TDescripcion="ENTRADA POR COMODATO">
		    <cfset EDescripcion="ENTRADA DE ACTIVO POR COMODATO">
		</cfif>
<cfset origen = 'AFSC'>

<cfset referencia='Comodato Activos'>
<cfif isdefined('form.contrato')>
	<cfset referencia=#form.contrato#>
	<cfset EDescripcion=EDescripcion &' ' & #form.contrato#>
</cfif>
<!--- <cfthrow message = #TDescripcion#> --->
		<!--- Invoca funcion para generar la poliza --->
		<cfset LvarPoliza = GenerarPolizaAF(#periodo#,#mes#,#rsAF.Cconcepto#,#origen#,#form.fechaa#,#TDescripcion#,#form.AFESid#,Tipo,referencia,EDescripcion)>
	</cfif>
</cftransaction>

<cfelse>
				<cfthrow message="No se puede aplicar un registro sin Activos Asociados!">
</cfif>
                    <cfset AFESid = 0>
</cfif>
<!---
<cfif session.debug>
	<a href="../MenuAF.cfm">Activos Fijos</a> | <a href="agtProceso_MEJORA.cfm?#params#">Lista de Grupos de Transacciones</a> | <a href="agtProceso_genera_MEJORA.cfm?#params#">Generar MEJORA</a>
	<cfabort>
</cfif>--->

<cfset params = ''>
<cfif isdefined('form.Filtro_AGTPdescripcion')>
	<cfset params = params & 'Filtro_AGTPdescripcion=#form.Filtro_AGTPdescripcion#'>
</cfif>
<cfif isdefined('form.Filtro_AGTPestadoDesc')>
	<cfset params = params & '&Filtro_AGTPestadoDesc=#form.Filtro_AGTPestadoDesc#'>
</cfif>
<cfif isdefined('form.Filtro_AGTPfalta')>
	<cfset params = params & '&Filtro_AGTPfalta=#form.Filtro_AGTPfalta#'>
</cfif>
<cfif isdefined('form.Filtro_AGTPmesDesc')>
	<cfset params = params & '&Filtro_AGTPmesDesc=#form.Filtro_AGTPmesDesc#'>
</cfif>
<cfif isdefined('form.Filtro_AGTPperiodo')>
	<cfset params = params & '&Filtro_AGTPperiodo=#form.Filtro_AGTPperiodo#'>
</cfif>
<cfif isdefined('form.HFiltro_AGTPdescripcion')>
	<cfset params = params & '&HFiltro_AGTPdescripcion=#form.HFiltro_AGTPdescripcion#'>
</cfif>
<cfif isdefined('form.HFiltro_AGTPestadoDesc')>
	<cfset params = params & '&HFiltro_AGTPestadoDesc=#form.HFiltro_AGTPestadoDesc#'>
</cfif>
<cfif isdefined('form.HFiltro_AGTPfalta')>
	<cfset params = params & '&HFiltro_AGTPfalta=#form.HFiltro_AGTPfalta#'>
</cfif>
<cfif isdefined('form.HFiltro_AGTPmesDesc')>
	<cfset params = params & '&HFiltro_AGTPmesDesc=#form.HFiltro_AGTPmesDesc#'>
</cfif>
<cfif isdefined('form.HFiltro_AGTPperiodo')>
	<cfset params = params & '&HFiltro_AGTPperiodo=#form.HFiltro_AGTPperiodo#'>
</cfif>

<cfif isdefined("AFESid") and AFESid GT 0>
	<cfif isdefined("AFESDid") and AFESDid GT 0 and not isdefined("form.NuevoDet")>
		<cflocation url="agtProceso_genera_Salida#LvarPar#.cfm?AFESid=#AFESid#&AFESDid=#AFESDid#&#params#">
	<cfelseif not isdefined("form.Nuevo")>
		<cflocation url="agtProceso_genera_Salida#LvarPar#.cfm?AFESid=#AFESid#&#params#">
	<cfelse>
		<cflocation url="agtProceso_genera_Salida#LvarPar#.cfm?#params#">
	</cfif>
<cfelse>

	<cflocation url="agtProceso_Salida#LvarPar#.cfm?#params#">
</cfif>


<!--- FUNCION PARA GENERAR UNA POLIZA DE ACTIVO FIJO --->
<cffunction name="GenerarPolizaAF" access="private" output="no" returntype="numeric" hint="Regresa el número del Asiento Contable generado ( IDcontable )">
        <cfargument name="Periodo" 	 	type="numeric" required="yes">
		<cfargument name="Mes" 		 	type="numeric" required="yes">
		<cfargument name="Cconcepto" 	type="numeric" required="yes">
		<cfargument name="Oorigen"  	type="string"  required="yes">
		<cfargument name="FechaE"    	type="date"    required="yes">
		<cfargument name="Descripcion"  type="string"  required="yes">
		<cfargument name="ADid"  		type="numeric" required="yes">
		<cfargument name="Tipo"  		type="numeric" required="yes">
		<cfargument name="Refer"	  	type="string"  required="yes">
		<cfargument name="EDescripcion"	type="string"  required="yes">

	<cfquery datasource="#session.dsn#" name="rsOficina">
			select Ocodigo
			from Oficinas
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>

	<cfquery datasource="#session.dsn#" name="rsEmpresas">
		select * from Empresas
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>

	<cfquery name="rsDatosActivo" datasource="#session.dsn#">
		  select a.Aid
          from AFEntradaSalidaD a
          inner join AFEntradaSalidaE b
          on b.Ecodigo = a.Ecodigo
          and a.AFESid = b.AFESid
          where b.AFESid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ADid#">
	</cfquery>

<cfset nolineaD = 1>
<!--- Crea la INTARC --->
			<cfset LobjCONTA	= createObject( "component","sif.Componentes.CG_GeneraAsiento")>
			<cfset INTARC 		= LobjCONTA.CreaIntarc(#session.DSN#)>
<cfloop query="rsDatosActivo">
		<cfinvoke component="sif.af.Componentes.Activo" method="getActivo" Aid="#rsDatosActivo.Aid#" Ecodigo="#session.Ecodigo#" returnvariable="rsActivo"/>
		<cfinvoke component="sif.af.Componentes.Activo" method="getCurrentSaldos" Aid="#rsDatosActivo.Aid#" Ecodigo="#form.Ecodigo#"  returnvariable="rsSaldos">

	<cfquery name="rsCuentasCA" datasource="#session.dsn#">
		  select *
		  from AClasificacion
		  where ACcodigodesc =<cfqueryparam cfsqltype="cf_sql_char" value="#rsActivo.ACcodigodesc#">
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>
	
	<cfif rsCuentasCA.recordcount EQ 0>
		<cfthrow message="No esta definida la cuenta de comodato para la Clasificación #rsActivo.ACcodigodesc#">		
	<cfelse>
		<cfquery name="rsCuentaAdq" datasource="#session.dsn#">
			select * from CFinanciera
			where Ccuenta = #rsCuentasCA.ACcadq#
		</cfquery>
	</cfif>
	
	<cfquery name="rsCuentaCom" datasource="#session.dsn#">
		select * from CFinanciera
		where Ccuenta = #rsCuentasCA.ACccomodato#
	</cfquery>
	
<cfif #rsSaldos.query.AFSvaladq# eq 0 or #rsSaldos.query.AFSvaladq# eq ''>
	<cfthrow message = "No se puede generar la poliza ya que el saldo de Adquisicion del Activo #rsActivo.Adescripcion# es igual a 0!">
</cfif>

					<cfquery datasource="#session.dsn#">
						insert into #INTARC#
						(
						INTORI, INTREL,
						INTDOC, INTREF,
						INTFEC, Periodo, Mes, Ocodigo, Mcodigo,
						INTTIP, INTDES,
						Ccuenta,CFcuenta,
						INTMOE, INTCAM, INTMON
						)
						values(
					 	'#Arguments.Oorigen#', #nolineaD#,
					 	'#Arguments.Descripcion#', '#Arguments.Refer#',
						'#DateFormat(now(),"YYYYMMDD")#', #Arguments.Periodo#, #Arguments.Mes#,#rsOficina.Ocodigo#, #rsEmpresas.Mcodigo#,
						<cfif Arguments.Tipo eq 1>'C'<cfelse>'D'</cfif>, 'Adquisicion',
						#rsCuentaAdq.Ccuenta#,
						#rsCuentaAdq.CFcuenta#,
						#rsSaldos.query.AFSvaladq#, 1, #rsSaldos.query.AFSvaladq#)
					</cfquery>


				<cfquery datasource="#session.dsn#">
						insert into #INTARC#
						(
						INTORI, INTREL,
						INTDOC, INTREF,
						INTFEC, Periodo, Mes, Ocodigo, Mcodigo,
						INTTIP, INTDES,
						Ccuenta,CFcuenta,
						INTMOE, INTCAM, INTMON
						)
						values(
						 	'#Arguments.Oorigen#', #nolineaD#,
					 	'#Arguments.Descripcion#', '#Arguments.Refer#',
						'#DateFormat(now(),"YYYYMMDD")#', #Arguments.Periodo#, #Arguments.Mes#,#rsOficina.Ocodigo#, #rsEmpresas.Mcodigo#,
						<cfif Arguments.Tipo eq 1>'D'<cfelse>'C'</cfif>, 'Comodato',
						#rsCuentaCom.Ccuenta#,
						#rsCuentaCom.CFcuenta#,
						#rsSaldos.query.AFSvaladq#, 1, #rsSaldos.query.AFSvaladq#
						)
					</cfquery>

	<cfset nolineaD = nolineaD+1>
</cfloop>

<!--- Genera el Asiento Contable--->
				<cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="GeneraAsiento" returnvariable="LvarIDcontable">
					<cfinvokeargument name="Ecodigo"		value="#session.Ecodigo#"/>
					<cfinvokeargument name="Eperiodo"		value="#Arguments.Periodo#"/>
					<cfinvokeargument name="Emes"			value="#Arguments.Mes#"/>
					<cfinvokeargument name="Efecha"			value="#Arguments.FechaE#"/>
					<cfinvokeargument name="Oorigen"		value="#Arguments.Oorigen#"/>
				<cfif #Arguments.Refer# neq 'Comodato Activos'>
					<cfinvokeargument name="Edocbase"		value="#Arguments.Oorigen# #Arguments.Refer#"/>
				<cfelse>
					<cfinvokeargument name="Edocbase"		value="#Arguments.Oorigen#"/>
				</cfif>
					<cfinvokeargument name="Ereferencia"	value="#Arguments.Refer#"/>
					<cfinvokeargument name="Edescripcion"	value="#Arguments.EDescripcion#"/>
					<cfinvokeargument name="Ocodigo"		value="#rsOficina.Ocodigo#"/>
				</cfinvoke>
	<cfreturn LvarIDcontable>

</cffunction>
