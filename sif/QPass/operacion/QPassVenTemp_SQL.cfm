<cfif not isdefined("form.CTEidentificacion") and isdefined("form.CTEidentificacionB")>
	<cfset form.CTEidentificacion = form.CTEidentificacionB>
</cfif>
<cfif isdefined("form.CTEidentificacion") and len(trim(form.CTEidentificacion)) eq 0 and isdefined("form.CTEidentificacionB") and len(trim(form.CTEidentificacionB))>
	<cfset form.CTEidentificacion = form.CTEidentificacionB>
</cfif>


<cfif not isdefined("form.CTEidentificacion") or len(trim(form.CTEidentificacion)) eq 0>
	<cfthrow message="No se definió la identificación del cliente, proceso cancelado!">
</cfif>


<cfif IsDefined("form.Nuevo")>
	<cflocation url="QPassVenTemp.cfm?Nuevo" addtoken="no">
</cfif>

<cfif isdefined("Form.Alta")>
	 <cfquery name="rs" datasource="#session.dsn#">
		select 
			distinct(a.QPCdescripcion) 
		from QPventaConvenio co
			inner join QPCausaxConvenio c
				on co.QPvtaConvid = c.QPvtaConvid
			inner join  QPCausa a
				on a.QPCid = c.QPCid
		where co.QPvtaConvid = #form.QPvtaConvid#
		  and a.Ecodigo = #session.Ecodigo#
		  and a.QPCtipo = 4	<!--- Solamente rubros que correspondan a cargos por venta --->
		  and (select count(1) from QPCausaxMovimiento Mov where Mov.QPCid = a.QPCid ) < 1
	</cfquery>
	<cfset errores ="">
	<cfloop query="rs">
		<cfset errores = errores & '<br>'& '-' & rs.QPCdescripcion >
	</cfloop>
	<cfif len(trim(errores)) gt 0>
		<cfthrow message="La(s) causa(s) no está(n) asociada(s) a ningún movimiento, verificar (catálogos - Movimientos en caja):#errores#">
	</cfif>

	<cfif form.QPctaSaldosTipo neq 2>
		<cfif not isdefined("form.QPctaBancoNum") or len(trim(form.QPctaBancoNum)) eq 0>
            <cfthrow message="No se ha definido la Cuenta. Debe de Indicase una Cuenta para procesar una Venta de Post Pago">
        </cfif>
	<cfelse>
		<cfif isdefined("form.QPctaBancoNum") and len(trim(form.QPctaBancoNum))>
            <cfthrow message="Se ha definido la Cuenta. Ventas Pre Pago no pueden ser relacionadas a una Cuenta">
        </cfif>
    </cfif>
    <cflock name="VentaTag#session.Ecodigo#" timeout="3" type="exclusive">
        <cfquery name="rsVerificaEstadoTag" datasource="#session.DSN#">
            select QPTEstadoActivacion
            from QPassTag
            where QPTidTag = #form.QPTidTag#
              and QPTEstadoActivacion in (1, 2, 9)
        </cfquery>

        <cfif rsVerificaEstadoTag.recordcount GT 0 and len(trim(rsVerificaEstadoTag.QPTEstadoActivacion))>
            <cfquery datasource="#session.DSN#">
                update QPassTag
                set QPTEstadoActivacion = 3
                where QPTidTag = #form.QPTidTag#
            </cfquery>
        </cfif>
    </cflock>
    <cfif rsVerificaEstadoTag.recordcount GT 0 and len(trim(rsVerificaEstadoTag.QPTEstadoActivacion))>
        <cfset LvarQPTEstadoActivacion = rsVerificaEstadoTag.QPTEstadoActivacion>
	    <cftry>
            <cfset fnProcesaVenta()>
	
            <cfcatch type="any">
                <!--- Regresar el Tag a su Estado Original --->
                <cfquery datasource="#session.DSN#">
                    update QPassTag
                    set QPTEstadoActivacion = #LvarQPTEstadoActivacion#
                    where QPTidTag = #form.QPTidTag#
                </cfquery>
                <cfthrow message="#cfcatch.message# #cfcatch.detail#">
            </cfcatch>
        </cftry>
    </cfif>
   <cflocation url="PopUp_Contrato.cfm?QPvtaTagid=#QPvtaTagid#" addtoken="no">
   
<cfelseif isdefined("Form.Cambio")>
	<cfif form.QPctaSaldosTipo neq 2>
		<cftransaction>
        <cfset LvarQPctaBancoid = ''>
        <cfif isdefined("form.QPctaBancoNum") and len(trim(form.QPctaBancoNum))>
         <!--- 2 Inserta la cuenta bancaria SI NO EXISTE. --->
				<cfset LvarQPctaBancoNum = ''>
				<cfset LvarQPctaBancoNum = mid(form.QPctaBancoNum,FindNoCase('-', form.QPctaBancoNum, 1)+1,30)>
                <cfif FindNoCase('/', LvarQPctaBancoNum, 1) GT 0>
					<cfset LvarQPctaBancoNum = mid(LvarQPctaBancoNum ,1,FindNoCase('/', LvarQPctaBancoNum, 1)-1)>
                </cfif>
				<cfset LvarQPctaBancoNum = Replace(LvarQPctaBancoNum, chr(160), '','ALL')>
								
            <cfquery name="rsCuentaBanco" datasource="#session.DSN#">
                select a.QPctaBancoid
                from QPcuentaBanco a 
					 inner join QPcuentaSaldos b 
					 on a.QPctaBancoid = b.QPctaBancoid
                where a.Ecodigo 		 = #session.Ecodigo#
                  and a.QPctaBancoNum  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rtrim(ltrim(LvarQPctaBancoNum))#">
                  and b.QPctaSaldosTipo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.QPctaSaldosTipo#">
						and b.QPctaSaldosid = #form.QPctaSaldosid#
            </cfquery>
				
             <cfset LvarQPctaBancoid = rsCuentaBanco.QPctaBancoid>
					<cfif rsCuentaBanco.recordcount eq 0>
						 <cfquery name="rsQPcuentaBanco" datasource="#session.DSN#">
							  insert into QPcuentaBanco (
									Ecodigo,
									QPctaBancoTipo,
									QPctaBancoNum,
									QPctaBancoCC,
									QPcteid,
									Mcodigo,       			<!--- Moneda del cliente con el banco --->
									BMusucodigo,
									BMFecha
							  )
							 values(
									#session.Ecodigo#,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.QPctaBancoTipo#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(LvarQPctaBancoNum)#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.QPctaBancoCC#">,
									#form.QPcteid#,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">,
									#session.Usucodigo#,
									<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
							 )
							  <cf_dbidentity1 datasource="#Session.DSN#" verificar_transaccion="false">
						 </cfquery>
						 <cf_dbidentity2 datasource="#Session.DSN#" name="rsQPcuentaBanco" verificar_transaccion="false" returnvariable="QPctaBancoid">
						 <cfset LvarQPctaBancoid = QPctaBancoid>
					</cfif>
      	 </cfif>
		</cftransaction> 
	
		<cftransaction>
		<!---inserta en la tabla de bitácora la modificación de la venta--->
			<cfquery name="rsModVenta" datasource="#session.DSN#">
				insert into QPventaBitacora(
					QPvtaTagid,
					Ecodigo,
					QPTidTag,				
					QPcteid, 				
					QPctaSaldosid,  	
					QPvtaConvid,
					QPvtaTagPlaca, 	
					QPvtaTagCont,
					QPvtaTagFact,
					QPvtaTagFecha,		
					Ocodigo,
					BMusucodigo,
					UsuarioMod,			
					BMFecha,
					FechaMod,			
					QPvtaAutoriza,
					QPvtaFechaAutoriza,
					QPvtaTarjeta,
					QPvtaEstado,
					QPvtaFCobroUltMem
				 )
					 (select
						a.QPvtaTagid,
						a.Ecodigo,
						a.QPTidTag,				
						a.QPcteid, 				
						a.QPctaSaldosid,  	
						a.QPvtaConvid,
						a.QPvtaTagPlaca, 	
						a.QPvtaTagCont,
						a.QPvtaTagFact,
						a.QPvtaTagFecha,		
						a.Ocodigo,
						a.BMusucodigo,
					#session.Usucodigo#,
						a.BMFecha,
					#now()#,	
						a.QPvtaAutoriza,
						a.QPvtaFechaAutoriza,
						a.QPvtaTarjeta,
						a.QPvtaEstado,
						a.QPvtaFCobroUltMem 
						from QPventaTags a
						where Ecodigo = #session.Ecodigo#
						and QPvtaTagid = #form.QPvtaTagid#
						)
				  <cf_dbidentity1 datasource="#Session.DSN#" verificar_transaccion="false">
			  </cfquery>
			 	 <cf_dbidentity2 datasource="#Session.DSN#" name="rsModVenta" verificar_transaccion="false" returnvariable="QPvtaBTagid">
			  
				<cfquery name="rsModCuentaS" datasource="#session.DSN#">
					insert into QPcuentaSaldosBitacora (
						QPctaSaldosid,
						Ecodigo,
						QPctaSaldosSaldo,
						QPctaBancoid,
						QPctaSaldosTipo,
						Mcodigo,
						BMusucodigo,
						UsuarioMod,
						BMFecha,
						FechaMod
					 )
					 
					(	select
							a.QPctaSaldosid,
							a.Ecodigo,
							a.QPctaSaldosSaldo,				
							a.QPctaBancoid, 				
							a.QPctaSaldosTipo,  	
							a.Mcodigo,
							a.BMusucodigo, 	
							#session.Usucodigo#,
							a.BMFecha,
							#now()#	
							from QPcuentaSaldos a
							where Ecodigo = #session.Ecodigo#
							and QPctaSaldosid = #form.QPctaSaldosid#
						)
					  <cf_dbidentity1 datasource="#Session.DSN#" verificar_transaccion="false">
				 </cfquery>
				  	<cf_dbidentity2 datasource="#Session.DSN#" name="rsModCuentaS" verificar_transaccion="false" returnvariable="QPctaSaldosBid">
	
				<cfquery  datasource="#session.DSN#">
					update QPventaTags set 
						 QPvtaTagPlaca = 
							<cfif isdefined("form.QPvtaTagPlaca") and len(trim(form.QPvtaTagPlaca))>
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.QPvtaTagPlaca#">
						  <cfelse>
								null
						  </cfif>
					where QPvtaTagid = #form.QPvtaTagid#
			  </cfquery>
			  
			  <cfquery name="rsCuentaBanco" datasource="#session.DSN#">
                select a.QPctaBancoid
                from QPcuentaBanco a 
					 inner join QPcuentaSaldos b 
					 on a.QPctaBancoid = b.QPctaBancoid
                where a.Ecodigo 		 = #session.Ecodigo#
                  and a.QPctaBancoNum  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(LvarQPctaBancoNum)#">
                  and b.QPctaSaldosTipo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.QPctaSaldosTipo#">
						and b.QPctaSaldosid = #form.QPctaSaldosid#
            </cfquery>

			  <cfif isdefined("rsCuentaBanco") and rsCuentaBanco.recordcount gt 0>
				 <cfloop query="rsCuentaBanco">
					 <cfquery datasource="#session.DSN#">
						update QPcuentaSaldos set 
							 QPctaBancoid = #rsCuentaBanco.QPctaBancoid#
						where QPctaSaldosid = #form.QPctaSaldosid#
				  </cfquery>
				 </cfloop>
				 
				<cfelseif isdefined("LvarQPctaBancoid") and len(trim(LvarQPctaBancoid))>
					<cfquery datasource="#session.DSN#">
						update QPcuentaSaldos set 
							 QPctaBancoid = #LvarQPctaBancoid#
						where QPctaSaldosid = #form.QPctaSaldosid#
				  </cfquery>
			   </cfif>
    	</cftransaction>
	 
	 	<cflocation url="QPassModificaVenta.cfm?QPvtaTagid=#form.QPvtaTagid#&QPctaBancoNum=#LvarQPctaBancoNum#" addtoken="no">
		<cfset modo = 'CAMBIO'>
	 <cfelse>
	 	<cftransaction>
		<!---inserta en la tabla de bitácora la modificación de la venta--->
			<cfquery name="rsModVenta" datasource="#session.DSN#">
				<cfif session.dsinfo.type eq 'sqlserver'>
					set ANSI_WARNINGS OFF
				</cfif>
				insert into QPventaBitacora(
					QPvtaTagid,
					Ecodigo,
					QPTidTag,				
					QPcteid, 				
					QPctaSaldosid,  	
					QPvtaConvid,
					QPvtaTagPlaca, 	
					QPvtaTagCont,
					QPvtaTagFact,
					QPvtaTagFecha,		
					Ocodigo,
					BMusucodigo,
					UsuarioMod,			
					BMFecha,
					FechaMod,			
					QPvtaAutoriza,
					QPvtaFechaAutoriza,
					QPvtaTarjeta,
					QPvtaEstado,
					QPvtaFCobroUltMem
				 )
					 (select
						a.QPvtaTagid,
						a.Ecodigo,
						a.QPTidTag,				
						a.QPcteid, 				
						a.QPctaSaldosid,  	
						a.QPvtaConvid,
						a.QPvtaTagPlaca, 	
						a.QPvtaTagCont,
						a.QPvtaTagFact,
						a.QPvtaTagFecha,		
						a.Ocodigo,
						a.BMusucodigo,
					#session.Usucodigo#,
						a.BMFecha,
					#now()#,	
						a.QPvtaAutoriza,
						a.QPvtaFechaAutoriza,
						a.QPvtaTarjeta,
						a.QPvtaEstado,
						a.QPvtaFCobroUltMem 
						from QPventaTags a
						where Ecodigo = #session.Ecodigo#
						and QPvtaTagid = #form.QPvtaTagid#
						)
				  <cf_dbidentity1 datasource="#Session.DSN#" verificar_transaccion="false">
			  </cfquery>
				  <cf_dbidentity2 datasource="#Session.DSN#" name="rsModVenta" verificar_transaccion="false" returnvariable="QPvtaBTagid">
	 	 
			 <cfquery  datasource="#session.DSN#">
					update QPventaTags set 
						 QPvtaTagPlaca = 
						<cfif isdefined("form.QPvtaTagPlaca") and len(trim(form.QPvtaTagPlaca))>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.QPvtaTagPlaca#">
						<cfelse>
							null
						</cfif>
					where QPvtaTagid = #form.QPvtaTagid#
			  </cfquery>
		</cftransaction>
		<cflocation url="QPassModificaVenta.cfm?QPvtaTagid=#form.QPvtaTagid#" addtoken="no">
		<cfset modo = 'CAMBIO'>
	</cfif>
</cfif>
<cflocation url="QPassModificaVenta.cfm?QPvtaTagid=#form.QPvtaTagid#&QPctaBancoNum=#rtrim(ltrim(form.QPctaBancoNum))#" addtoken="no">
<cfset modo = 'CAMBIO'>
		
<cffunction name="fnProcesaVenta" access="public" output="no" hint="Procesa las Transacciones de Venta">
	<cfset QPcteid = ''>

    <cfquery name="rscedula" datasource="#session.dsn#">
        select count(1) as cantidad
        from QPcliente
        where Ecodigo = #session.Ecodigo#
        and QPtipoCteid = #form.CTETIPO#
        and QPcteDocumento = '#form.CTEidentificacion#'
    </cfquery>

	<cftransaction>
		<!--- 1 Inserta o actualiza el cliente --->
        <cfif rscedula.cantidad eq 0>
            <cfquery name="insertCliente" datasource="#session.dsn#">
                insert into QPcliente 
                (
                    QPtipoCteid,
                    QPcteDocumento,
                    QPcteNombre,
                    QPcteDireccion,
                    QPcteTelefono1,
                    QPcteTelefono2,
                    QPcteCorreo,
                    BMusucodigo,
                    BMFecha,
                    Ecodigo,
		    		QPCente
                )
                    values(
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CTETIPO#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CTEidentificacion#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.QPcteNombre#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.QPcteDireccion#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.QPcteTelefono1#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.QPcteTelefono2#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.QPcteCorreo#">,
                        #Session.Usucodigo#,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
                        #Session.Ecodigo#,
						<cfif isdefined('form.QPCente') and form.QPCente eq -1>
                            null
                        <cfelse>
                            <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.QPCente#">
                        </cfif>
                        )
                <cf_dbidentity1 datasource="#Session.DSN#" verificar_transaccion="false">
            </cfquery>
            <cf_dbidentity2 datasource="#Session.DSN#" name="insertCliente" verificar_transaccion="false" returnvariable="QPcteid">
            <cfset LvarQPcteid = QPcteid>
        <cfelse>
            <cfquery name="rsQPcliente" datasource="#session.dsn#">
                select min(QPcteid) as QPcteid
                from QPcliente
                where Ecodigo = #session.Ecodigo#
                and QPcteDocumento = '#form.CTEidentificacion#'
		        and QPtipoCteid = #form.CTETIPO#
            </cfquery>
            
            <cfquery datasource="#session.DSN#">
                update 	QPcliente
                set QPcteNombre 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.QPcteNombre#">,
                    QPcteDireccion 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.QPcteDireccion#">,
                    QPcteTelefono1  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.QPcteTelefono1#">,
                    QPcteTelefono2  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.QPcteTelefono2#">,
                    QPcteCorreo     = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.QPcteCorreo#">,
		    		QPCente         = <cfif isdefined('form.QPCente') and form.QPCente neq -1>#form.QPCente#<cfelse>null</cfif>
                where QPcteid  = #rsQPcliente.QPcteid#
            </cfquery>
            <cfset LvarQPcteid = rsQPcliente.QPcteid>
        </cfif>
    
        <cfset LvarQPctaBancoid = ''>
        <cfif isdefined("form.QPctaBancoNum") and len(trim(form.QPctaBancoNum))>
            <!--- 2 Inserta la cuenta bancaria SI NO EXISTE. --->
            <cfquery name="rsCuentaBanco" datasource="#session.DSN#">
                select QPctaBancoid
                from QPcuentaBanco
                where Ecodigo 		 = #session.Ecodigo#
                  and QPctaBancoNum  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.QPctaBancoNum#">
                  and QPctaBancoTipo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.QPctaBancoTipo#">
            </cfquery>
            <cfset LvarQPctaBancoid = rsCuentaBanco.QPctaBancoid>
            <cfif rsCuentaBanco.recordcount eq 0>
				<cfset LvarQPctaBancoNum = ''>
                <cfset LvarQPctaBancoNum = mid(form.QPctaBancoNum,FindNoCase('-', form.QPctaBancoNum, 1)+1,30)>
                <cfif FindNoCase('/', LvarQPctaBancoNum, 1) GT 0>
                    <cfset LvarQPctaBancoNum = mid(LvarQPctaBancoNum ,1,FindNoCase('/', LvarQPctaBancoNum, 1)-1)>
                </cfif>
                <cfset LvarQPctaBancoNum = Replace(LvarQPctaBancoNum, chr(160), '','ALL')>
                <cfquery name="rsQPcuentaBanco" datasource="#session.DSN#">
                    insert into QPcuentaBanco (
                        Ecodigo,
                        QPctaBancoTipo,
                        QPctaBancoNum,
                        QPctaBancoCC,
                        QPcteid,
                        Mcodigo,       			<!--- Moneda del cliente con el banco --->
                        BMusucodigo,
                        BMFecha
                    )
                   values(
                        #session.Ecodigo#,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.QPctaBancoTipo#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#rtrim(ltrim(LvarQPctaBancoNum))#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.QPctaBancoCC#">,
                        #LvarQPcteid#,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">,
                        #session.Usucodigo#,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
                   )
                    <cf_dbidentity1 datasource="#Session.DSN#" verificar_transaccion="false">
                </cfquery>
                <cf_dbidentity2 datasource="#Session.DSN#" name="rsQPcuentaBanco" verificar_transaccion="false" returnvariable="QPctaBancoid">
                <cfset LvarQPctaBancoid = QPctaBancoid>
            </cfif>
       </cfif>
        
        <!--- 3 Inserta siempre la tabla de saldos. --->
        <cfquery name="rsParametroModenaSaldo" datasource="#session.DSN#">
            select Pvalor
            from Parametros
            where Ecodigo = #session.Ecodigo#
            and Pcodigo = 447
        </cfquery>
        <cfif rsParametroModenaSaldo.recordcount eq 0>
            <cfthrow message="Se debe definir la moneda de la cuenta de saldos." detail="Definir la moneda en: Administración del Sistema, Parámetros Adicionales, Parametro Moneda de la Cuenta de Saldos y darle click al botón Aceptar.">
            <cftransaction action="rollback"/>
            <cfabort>
        </cfif>
        
        <cfquery name="rsQPcuentaSaldos" datasource="#session.DSN#">
            insert into QPcuentaSaldos (
                Ecodigo,
                QPctaSaldosSaldo,
                QPctaBancoid,   			<!--- hace referencia a la cuenta de banco (acepta nulos) --->
                QPctaSaldosTipo,			<!--- 1=PostPago, 2=Prepago, 3-TopUp --->
                Mcodigo,	<!--- Moneda de Cuenta de Saldos Parametro y lo leo --->
                BMusucodigo,
                BMFecha
                )
            values(
                #session.Ecodigo#,
                0,

                <cfif len(trim(LvarQPctaBancoid))>
                    #LvarQPctaBancoid#,
                <cfelse>
                    null,
                </cfif>
                <cfqueryparam cfsqltype="cf_sql_integer" value="#form.QPctaSaldosTipo#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsParametroModenaSaldo.Pvalor#">,
                #session.Usucodigo#,
                #now()#
            )
            <cf_dbidentity1 datasource="#Session.DSN#" verificar_transaccion="false">
        </cfquery>
        <cf_dbidentity2 datasource="#Session.DSN#" name="rsQPcuentaSaldos" verificar_transaccion="false" returnvariable="QPctaSaldosid">
         
         
        <!--- 4 Inserta siempre en el alta la tabla de venta --->
        <cfquery name="rsOficinaTag" datasource="#session.DSN#">
            select Ocodigo
            from QPassTag
            where QPTidTag = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.QPTidTag#">
        </cfquery>

		<cfset Lvarfecha = createdate(mid(form.QPvtaTagFecha, 7, 4), mid(form.QPvtaTagFecha, 4, 2), mid(form.QPvtaTagFecha, 1, 2))>
        <cfquery name="rsQPventaTags" datasource="#session.DSN#">
            insert into QPventaTags(
                Ecodigo, 
                QPTidTag, 
                QPcteid, 
                QPctaSaldosid, 
                QPvtaConvid, 
                QPvtaTagPlaca, 
                QPvtaTagFecha, 
                Ocodigo, 
                BMusucodigo, 
                BMFecha,
                QPvtaAutoriza,
                QPvtaTarjeta,
                QPvtaFechaAutoriza
                )
            values(
                #session.Ecodigo#,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.QPTidTag#">,
                #LvarQPcteid#,
                #QPctaSaldosid#,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.QPvtaConvid#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.QPvtaTagPlaca#">,
		#Lvarfecha#,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOficinaTag.Ocodigo#">,
                #session.Usucodigo#,
                #now()#,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.QPvtaAutoriza#">,
                null,
                null
                )
            <cf_dbidentity1 datasource="#Session.DSN#" verificar_transaccion="false">
        </cfquery>
        <cf_dbidentity2 datasource="#Session.DSN#" name="rsQPventaTags" verificar_transaccion="false" returnvariable="QPvtaTagid">
        
        <!--- Actualiza el estado del dispositivo a 3:  En proceso de Venta ( Asignado a Cliente pero no Activado ) --->
        <cfquery datasource="#session.DSN#">
            update QPassTag
            set QPTEstadoActivacion = 3
            where QPTidTag = #form.QPTidTag#
        </cfquery>
        
         <!--- Documentacion de Campo:  Tipo Movimiento ( QPTMovTipoMov)
            1: Adquisicion, 
            2. Modificacion de Informacion de Dispositivo
            3: Traslado hacia Oficinas
            4: Recepcion de Traslado hacia Oficinas		
            5: Traslado a Punto de Ventas
            6: Activacion / Reactivacion  por Venta o por entrega
            7: Inactivacion
            8: Retiro por Robo / Extravio
            9: Recuperacion de TAG por el Banco --->
        
        <!--- Se comenta el registro en la bitácora porque ahora hay una pantalla de aceptación de ventas. para que no se de el caso de vender el tag, 
		aceptar la venta y luego hacer anulación de la venta (acá se grababan dos movimientos con estado 6 lo que hacía que fallara la función del estado anterior y por 
		consecuencia que el tag no se pudiera volver a usar).
		<cfquery datasource="#session.dsn#">
            insert into QPassTagMov (
                    QPTidTag, QPTMovtipoMov, QPTNumParte, 
                    QPTFechaProduccion, QPTNumSerie, QPTPAN, QPTNumLote, 
                    QPTNumPall, QPTEstadoActivacion, 
                    Ecodigo, Ocodigo, OcodigoDest, QPidLote, QPidEstado, BMFecha, BMusucodigo)
            select
                    QPTidTag, 6, QPTNumParte, 
                    QPTFechaProduccion, QPTNumSerie, QPTPAN, QPTNumLote, 
                    QPTNumPall, QPTEstadoActivacion, 
                    Ecodigo, Ocodigo, Ocodigo, QPidLote, QPidEstado, #now()#, #session.Usucodigo#
            from QPassTag
            where QPTidTag = #form.QPTidTag#
        </cfquery> --->
        
        <!--- Si viene un tag asignado a un promotor hay que cambiar el estado del tag y ver si el documento se cambia de estado --->
        <cfif isdefined("form.QPPid") and len(trim(form.QPPid))>
            <!--- Pregunta si el tag está asignado a un promotor y consigue el id del documento --->
            <cfquery name="rsRevisaPromotor" datasource="#session.DSN#">
                select b.QPEAPid
                from QPDAsignaPromotor a
                    inner join QPEAsignaPromotor b
                        on b.QPEAPid = a.QPEAPid
                where a.QPTidTag = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.QPTidTag#">
                and b.QPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.QPPid#"> <!--- Promotor --->
                and a.QPDAPestado = 1 <!--- Asignado promotor --->
            </cfquery>
            <cfif rsRevisaPromotor.recordcount gt 0>
                <!--- Marca el tag como vendido dentro del documento --->
                <cfquery datasource="#session.DSN#">
                    update QPDAsignaPromotor
                    set QPDAPestado = 3	<!--- 3 Vendido --->
                    where QPEAPid = #rsRevisaPromotor.QPEAPid#
                    and QPTidTag = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.QPTidTag#">
                </cfquery>
                
                <!--- Busca tags asignados a un promotor, como ya se vendió el tag (QPassTag.QPTEstadoActivacion =3) ya no cuenta ese tag y si no hay mas tags en el documento,
                le cambia el estado al documento para que no salga en la lista de asignación de tags a sucursales o devolución de tag a sucursales --->
                <cfquery name="rs" datasource="#session.DSN#">
                    select count(1) as cantidad
                    from QPDAsignaPromotor a
                        inner join QPassTag b
                            on b.QPTidTag = a.QPTidTag
                    where a.QPEAPid = #rsRevisaPromotor.QPEAPid#
                    and b.QPTEstadoActivacion = 9 <!--- 9: Asignado a Promotor --->
                    and a.QPDAPestado = 1 <!--- 1: AsignadoPromotor  --->
                </cfquery>
                <cfif rs.cantidad eq 0>
                    <cfquery datasource="#session.DSN#">
                        update QPEAsignaPromotor
                        set QPEAPEstado = 2 <!--- Documento sin Tags, ya se por devoluciones o por ventas --->
                        where QPEAPid = #rsRevisaPromotor.QPEAPid#
                   </cfquery>
                </cfif>
            </cfif>
        </cfif>
	</cftransaction>    
</cffunction>





  


