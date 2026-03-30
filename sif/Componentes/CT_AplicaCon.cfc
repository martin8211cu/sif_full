<cfcomponent>
	<cffunction name="fnAplicaContrato" access="public" output="no" returntype="numeric">
		<cfargument name="CTContid" 			type="numeric">
		<cfargument name="CTCid" 				type="numeric">
        <cfargument name="TransaccionActiva" 	type="boolean" default="false">
        <cfargument name="Ecodigo" 				type="numeric" required="no">
        <cfargument name="EcodigoAlterno" 		type="numeric" required="no">


        <cfif not isdefined('Arguments.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
        <cfif not isdefined('Arguments.EcodigoAlterno')>
        	<cfset Arguments.EcodigoAlterno = Arguments.Ecodigo>
        </cfif>

        <cfif Arguments.TransaccionActiva>
        	<cfinvoke method="fnAplicaContratoPrivate" returnvariable="NAP">
            	<cfinvokeargument name="CTContid" value="#Arguments.CTContid#">
                <cfinvokeargument name="CTCid" value="#Arguments.CTCid#">
                <cfinvokeargument name="EcodigoAlterno" value="#Arguments.EcodigoAlterno#">
            </cfinvoke>
        <cfelse>
        	<cftransaction>
                <cfinvoke method="fnAplicaContratoPrivate" returnvariable="NAP">
                    <cfinvokeargument name="CTContid" value="#Arguments.CTContid#">
                    <cfinvokeargument name="CTCid" value="#Arguments.CTCid#">
                    <cfinvokeargument name="EcodigoAlterno" value="#Arguments.EcodigoAlterno#">
                </cfinvoke>
            </cftransaction>
        </cfif>
        <cfreturn NAP>
     </cffunction>

    <cffunction name="fnAplicaContratoPrivate" access="private" output="no" returntype="numeric">
		<cfargument name="CTContid" 			type="numeric">
		<cfargument name="CTCid" 				type="numeric">
        <cfargument name="TransaccionActiva" 	type="boolean" default="false">
        <cfargument name="Ecodigo" 				type="numeric" required="no">
        <cfargument name="EcodigoAlterno" 		type="numeric" required="no">

        <cfif not isdefined('Arguments.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
        <cfif not isdefined('Arguments.EcodigoAlterno')>
        	<cfset Arguments.EcodigoAlterno = Arguments.Ecodigo>
        </cfif>

		<cfobject component="sif.Componentes.AplicarMascara" name="mascara">
		<cfset LobjControl = createObject( "component","sif.Componentes.PRES_Presupuesto")>

	  	<cfquery datasource="#session.dsn#" name="MonedaLocal">
			select Mcodigo
			from Empresas
			where Ecodigo = #Arguments.EcodigoAlterno#
		</cfquery>

		<cfset GvarMcodigoLocal = MonedaLocal.Mcodigo>

		<cfset puedeComprar = fnValidaMontoContratoComprador(Arguments.CTContid, Arguments.CTCid, Arguments.Ecodigo, Arguments.EcodigoAlterno)>

		<cfquery name="rsComprador" datasource="#session.DSN#">
			select CTCactivo
			  from CTCompradores
			 where CTCid	= #Arguments.CTCid#
		</cfquery>

		<cfquery name="dataCuentaF" datasource="#session.DSN#">
			select  a.CFid, a.CMtipo, a.Aid, a.Cid, a.ACcodigo, a.ACid,
					(select SNid from SNegocios where Ecodigo = b.Ecodigo and SNid = b.SNid) as SNid,
					b.CTfecha as fecha, 	a.CTDCont,a.Ecodigo,
					a.CTDCconsecutivo
			from CTDetContrato a
				inner join CTContrato b
					on  a.CTContid = b.CTContid
			where a.CTContid = #Arguments.CTContid#
		</cfquery>
        <cfif dataCuentaF.RecordCount EQ 0>
        	<cfthrow message="No es posible aplicar un contrato sin detalles!">
        </cfif>

        <cfset LobjControl.CreaTablaIntPresupuesto(session.dsn,false,false,true)>

        <cfquery name="data" datasource="#session.DSN#">
            select CTContid, CTCnumContrato, CTfecha, CTTCid
            from CTContrato
            where CTContid = #Arguments.CTContid#
        </cfquery>

		<cfquery name="rsMesAuxiliar" datasource="#session.DSN#">
            select Pvalor
            from Parametros
            where Ecodigo=#Arguments.EcodigoAlterno#
            and Pcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="60">
        </cfquery>


        <cfquery name="rsPeriodoAuxiliar" datasource="#session.DSN#">
            select Pvalor
            from Parametros
            where Ecodigo=#Arguments.EcodigoAlterno#
            and Pcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="50">
        </cfquery>


		<cfset LvarCTContid = Arguments.CTContid>

        <cfquery name="rsComprometido" datasource="#session.dsn#">
			select
				'CTRC',
				<cf_dbfunction name="to_char" args="b.CTCnumContrato" >,
				'Contrato',
				b.CTfecha,
				case
					when a.CPCano < #rsPeriodoAuxiliar.Pvalor#
	                      	then  #rsPeriodoAuxiliar.Pvalor#
	          	            else  a.CPCano end,
	                    case
					when a.CPCmes < #rsMesAuxiliar.Pvalor#
	                      	then  #rsMesAuxiliar.Pvalor#
	          	            else a.CPCmes end,
				a.CTDCconsecutivo,
				a.CPcuenta,
				b.Ocodigo,
				d.Oficodigo,
				b.CTMcodigo,
				a.CTDCmontoTotalOri
				as MtoOrigen,
				b.CTtipoCambio,
				a.CTDCmontoTotal as Monto,
				'CC',
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">, 	<!---NAPreferencia--->
				<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="null">    <!---LINreferencia--->

			from CTDetContrato a
				inner join CTContrato b
				on b.CTContid = a.CTContid

				inner join Oficinas d
				on d.Ocodigo = b.Ocodigo
				and d.Ecodigo = b.Ecodigo

				left join CFuncional c
				on c.CFid = a.CFid

			where a.CTContid =  #LvarCTContid#
		</cfquery>


         <!--- Valida si viene de una Suficiencia --->
        <cfquery name="rsOCD1" datasource="#session.dsn#">
        	select COUNT(1) as reg from CTContrato eoc
            inner join CTDetContrato doc
            	on doc.CTContid=eoc.CTContid
			left join CPDocumentoD ds
            	on ds.CPDEid = doc.CPDEid
			where eoc.CTContid = #LvarCTContid#
            and eoc.Ecodigo = #session.Ecodigo#
        </cfquery>
        <cfif rsOCD1.reg LTE 0>
           <cfthrow message="No hay relación con suficiencia presupuestal!">
        </cfif>

		<cfset Momentos=1>

		<!--- Compromiso del contrato --->

		<!---- Inserta las lineas sin discribucion --->
		<cfquery name="rs" datasource="#session.DSN#">
			insert into #request.intPresupuesto#(
				ModuloOrigen,
				NumeroDocumento,
				NumeroReferencia,
				FechaDocumento,
				AnoDocumento,
				MesDocumento,
				NumeroLinea,
				CPcuenta,
				Ocodigo,
				CodigoOficina,
				Mcodigo,
				MontoOrigen,
				TipoCambio,
				Monto,
				TipoMovimiento,
                CPCanoP,
                CPCmesP)
			select
				'CTRC',
				<cf_dbfunction name="to_char" args="b.CTCnumContrato">,
				'Contrato',
				b.CTfecha,
                    case
					when a.CPCano < #rsPeriodoAuxiliar.Pvalor#
                       	then  #rsPeriodoAuxiliar.Pvalor#
           	            else  a.CPCano end,
                     case
					when a.CPCmes < #rsMesAuxiliar.Pvalor#
                       	then  #rsMesAuxiliar.Pvalor#
           	            else a.CPCmes end,
                   (a.CTDCconsecutivo * 10000) + a.CTDCconsecutivo,
				a.CPcuenta,
				c.Ocodigo,
				d.Oficodigo,
				b.CTMcodigo,
			    a.CTDCmontoTotal MtoOrigen,
				1,
				a.CTDCmontoTotal as Monto,
				'CC',
                a.CPCano,
                a.CPCmes
			from CTDetContrato  a
				inner join CTContrato  b
				on b.CTContid  = a.CTContid

				inner join CFuncional c
				on c.CFid = a.CFid

				inner join Oficinas d
				on d.Ocodigo = c.Ocodigo
				and d.Ecodigo = c.Ecodigo
			where a.CTContid  =  #LvarCTContid#
			and a.CPDCid is null
		</cfquery>


		<!---- Trae las lineas de servicio con discribucion --->
		<cfquery name="rsLineasConDistribucion" datasource="#session.DSN#">
			select
				'CTRC' as ModuloOrigen,
				<cf_dbfunction name="to_char" args="b.CTCnumContrato" > as NumeroDocumento,
				'Contrato' as NumeroReferencia,
				b.CTfecha as FechaDocumento,
                    case
					when a.CPCano < #rsPeriodoAuxiliar.Pvalor#
                       	then  #rsPeriodoAuxiliar.Pvalor#
           	            else  a.CPCano end as AnoDocumento ,
                     case
					when a.CPCmes < #rsMesAuxiliar.Pvalor#
                       	then  #rsMesAuxiliar.Pvalor#
           	            else a.CPCmes end  as MesDocumento,
				a.CTDCconsecutivo,
				b.Ocodigo as Ocodigo,
				d.Oficodigo as CodigoOficina,
				b.CTMcodigo as Mcodigo,
				a.CTDCmontoTotal	as MtoOrigen,
				b.CTtipoCambio,
				a.CTDCmontoTotal as Monto,
				'CC' as TipoMovimiento,
				a.Cid,
				a.CMtipo as Tipoitem,
				a.CPDCid,
				a.CTDCont,
                   a.Ccodigo,
                   a.CPDEid,
				a.CPCano as Rsvano,
				a.CPCmes as Rsvmes
			from CTDetContrato a
				inner join CTContrato b
				on b.CTContid  = a.CTContid

                   inner join Oficinas d
				on d.Ocodigo = b.Ocodigo
				and d.Ecodigo = a.Ecodigo

				left join  CFuncional c
				on c.CFid = a.CFid
			where a.CTContid =  #LvarCTContid#
			and CPDCid is not null
               and Cid is not null
               and a.CPDEid <> -1
		</cfquery>

		<!--- Para cada linea con distribucion --->


		<cfloop query="rsLineasConDistribucion">
            <cfquery name="rsSaldoDistribuir" datasource="#session.DSN#">
                select sum(CPDDsaldo) as Saldo from CPDocumentoD
                where CPDEid = #rsLineasConDistribucion.CPDEid#
                and CPCmes = #rsLineasConDistribucion.Rsvmes#
                and CPCano = #rsLineasConDistribucion.Rsvano#
            </cfquery>

			<!--- Obtiene la distribucion --->
			<cfinvoke component="sif.Componentes.PRES_Distribucion" method="GenerarDistribucion"
           	  Cid="#rsLineasConDistribucion.Cid#"
              CPDCid="#rsLineasConDistribucion.CPDCid#"
              Tipo="#rsLineasConDistribucion.Tipoitem#"
              Aplica="1"
              cantidad="1"
              monto="#rsLineasConDistribucion.Monto#"
              Modulo="Contratos"
              returnVariable="rsDistribucion"
              >

			<cfquery name="rsMontoDistribuido" dbtype="query">
					select sum(Monto) as Monto from rsDistribucion
			</cfquery>

			<cfset varMonto = #rsMontoDistribuido.Monto#>
			<cfset varMonto = varMonto * 100>
			<cfset varMonto = round(varMonto)>
			<cfset varMonto = varMonto/100>


            <cfif rsSaldoDistribuir.Saldo LTE varMonto>
				<cfset varTotalSuf = true>
            <cfelse>
            	<cfset varTotalSuf = false>
            </cfif>


			<cfif varTotalSuf EQ true>

				<cfset NumLinea = 0>
                <cfloop query="rsDistribucion">
                     <cfquery name="rsCPcuenta" datasource="#session.DSN#">
                        select CPcuenta from CFinanciera
                        where CFformato = '#rsDistribucion.cuenta#'
                        and Ecodigo = #session.Ecodigo#
                     </cfquery>

                    <cfquery name="rsLineasSuficiencia" datasource="#session.DSN#">
	                    select CPDEid,CPcuenta,CPCmes,CPCano,CPDDsaldo from CPDocumentoD
	                    where CPDEid = #rsLineasConDistribucion.CPDEid#
	                    and CPCmes = #rsLineasConDistribucion.Rsvmes#
	                    and CPCano = #rsLineasConDistribucion.Rsvano#
	                    and CPcuenta = #rsCPcuenta.CPcuenta#
                     </cfquery>


					<cfset NumLinea = NumLinea + 1>

                    <cfquery name="rs" datasource="#session.DSN#">
                        insert into #request.intPresupuesto#(
                            ModuloOrigen,
                            NumeroDocumento,
                            NumeroReferencia,
                            FechaDocumento,
                            AnoDocumento,
                            MesDocumento,
                            NumeroLinea,
                            CFcuenta,
                            Ocodigo,
                            CodigoOficina,
                            Mcodigo,
                            MontoOrigen,
                            TipoCambio,
                            Monto,
                            TipoMovimiento,
                            CPCanoP,
                            CPCmesP)

                        values 	(
                                   <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucion.ModuloOrigen#">,
                                   <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucion.NumeroDocumento#">,
                                   <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucion.NumeroReferencia#">,
                                   <cfqueryparam cfsqltype="cf_sql_date" value="#rsLineasConDistribucion.FechaDocumento#">,
                                   <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucion.AnoDocumento#">,
                                   <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucion.MesDocumento#">,
                                    (#rsLineasConDistribucion.CTDCconsecutivo# * 10000) + #NumLinea#,
                                    (select CFcuenta from CFinanciera
                                     where CFformato = '#rsDistribucion.cuenta#'),
                                  <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucion.Ocodigo#">,
                                  <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucion.CodigoOficina#">,
                                  <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucion.Mcodigo#">,
                                  #rsLineasSuficiencia.CPDDsaldo#,
                                    1,
                                  #rsLineasSuficiencia.CPDDsaldo#,
                                 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucion.TipoMovimiento#">,
                                 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucion.Rsvano#">,
                                 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucion.Rsvmes#">
                                )
                	</cfquery>
        		</cfloop> <!--- rsDistribucion --->
            <cfelseif varTotalSuf EQ false>
	            <cfset NumLinea = 0>

				<cfloop query="rsDistribucion">
                	<cfset NumLinea = NumLinea + 1>

                    <cfquery name="rs" datasource="#session.DSN#">
                        insert into #request.intPresupuesto#(
                            ModuloOrigen,
                            NumeroDocumento,
                            NumeroReferencia,
                            FechaDocumento,
                            AnoDocumento,
                            MesDocumento,
                            NumeroLinea,
                            CFcuenta,
                            Ocodigo,
                            CodigoOficina,
                            Mcodigo,
                            MontoOrigen,
                            TipoCambio,
                            Monto,
                            TipoMovimiento,
                            CPCanoP,
                            CPCmesP)

	                	values 	(
	                           <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucion.ModuloOrigen#">,
	                           <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucion.NumeroDocumento#">,
	                           <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucion.NumeroReferencia#">,
	                           <cfqueryparam cfsqltype="cf_sql_date" value="#rsLineasConDistribucion.FechaDocumento#">,
	                           <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucion.AnoDocumento#">,
	                           <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucion.MesDocumento#">,
	                            (#rsLineasConDistribucion.CTDCconsecutivo# * 10000) + #NumLinea#,
	                            (select CFcuenta from CFinanciera
	                             where CFformato = '#rsDistribucion.cuenta#'),
	                          <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucion.Ocodigo#">,
	                          <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucion.CodigoOficina#">,
	                          <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucion.Mcodigo#">,
	                          #rsDistribucion.Monto#,
	                            1,
	                        #rsDistribucion.Monto#,
	                         <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucion.TipoMovimiento#">,
                             <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucion.Rsvano#">,
                             <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucion.Rsvmes#">
	                        )
	                </cfquery>
                </cfloop> <!--- rsDistribucion --->
			</cfif>
		</cfloop>


        <!----Inicia Cambio suficiencias agrupadas RVD--->


		<!---- Trae las lineas de servicio con discribucion --->
		<cfquery name="rsLineasConDistribucionAgr" datasource="#session.DSN#">
						select
				'CTRC' as ModuloOrigen,
				<cf_dbfunction name="to_char" args="b.CTCnumContrato" > as NumeroDocumento,
				'Contrato' as NumeroReferencia,
				b.CTfecha as FechaDocumento,
                    case
					when a.CPCano < #rsPeriodoAuxiliar.Pvalor#
                       	then  #rsPeriodoAuxiliar.Pvalor#
           	            else  a.CPCano end as AnoDocumento ,
                     case
					when a.CPCmes < #rsMesAuxiliar.Pvalor#
                       	then  #rsMesAuxiliar.Pvalor#
           	            else a.CPCmes end  as MesDocumento,
				a.CTDCconsecutivo,
				b.Ocodigo as Ocodigo,
				d.Oficodigo as CodigoOficina,
				b.CTMcodigo as Mcodigo,
				a.CTDCmontoTotal	as MtoOrigen,
				b.CTtipoCambio,
				a.CTDCmontoTotal as Monto,
				'CC' as TipoMovimiento,
				a.Cid,
				a.CMtipo as Tipoitem,
				a.CPDCid,
				a.CTDCont,
                   a.Ccodigo,
                   a.CPDEid,
				a.CPCano as Rsvano,
				a.CPCmes as Rsvmes
			from CTDetContrato a
				inner join CTContrato b
				on b.CTContid  = a.CTContid

                   inner join Oficinas d
				on d.Ocodigo = b.Ocodigo
				and d.Ecodigo = a.Ecodigo

				left join  CFuncional c
				on c.CFid = a.CFid
			where a.CTContid =  #LvarCTContid#
			and CPDCid is not null
               and Cid is not null
               and a.CPDEid = -1
		</cfquery>


		<!--- Para cada linea con distribucion --->


		<cfloop query="rsLineasConDistribucionAgr">

			<!--- Obtiene la distribucion --->
			<cfinvoke component="sif.Componentes.PRES_Distribucion" method="GenerarDistribucion"
           	  Cid="#rsLineasConDistribucionAgr.Cid#"
              CPDCid="#rsLineasConDistribucionAgr.CPDCid#"
              Tipo="#rsLineasConDistribucionAgr.Tipoitem#"
              Aplica="1"
              cantidad="1"
              monto="#rsLineasConDistribucionAgr.Monto#"
              Modulo="Contratos"
              returnVariable="rsDistribucion">

			<cfquery name="rsMontoDistribuido" dbtype="query">
					select sum(Monto) as Monto from rsDistribucion
			</cfquery>

			<cfset varMonto = #rsMontoDistribuido.Monto#>
			<cfset varMonto = varMonto * 100>
			<cfset varMonto = round(varMonto)>
			<cfset varMonto = varMonto/100>



				<cfset NumLinea = 0>
                <cfloop query="rsDistribucion">

					<cfset NumLinea = NumLinea + 1>

                    <cfquery name="rs" datasource="#session.DSN#">
                        insert into #request.intPresupuesto#(
                            ModuloOrigen,
                            NumeroDocumento,
                            NumeroReferencia,
                            FechaDocumento,
                            AnoDocumento,
                            MesDocumento,
                            NumeroLinea,
                            CFcuenta,
                            Ocodigo,
                            CodigoOficina,
                            Mcodigo,
                            MontoOrigen,
                            TipoCambio,
                            Monto,
                            TipoMovimiento,
                            CPCanoP,
                            CPCmesP)

                        values 	(
                                   <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucionAgr.ModuloOrigen#">,
                                   <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucionAgr.NumeroDocumento#">,
                                   <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucionAgr.NumeroReferencia#">,
                                   <cfqueryparam cfsqltype="cf_sql_date" value="#rsLineasConDistribucionAgr.FechaDocumento#">,
                                   <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucionAgr.AnoDocumento#">,
                                   <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucionAgr.MesDocumento#">,
                                    (#rsLineasConDistribucionAgr.CTDCconsecutivo# * 10000) + #NumLinea#,
                                    (select CFcuenta from CFinanciera
                                     where CFformato = '#rsDistribucion.cuenta#'),
                                  <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucionAgr.Ocodigo#">,
                                  <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucionAgr.CodigoOficina#">,
                                  <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucionAgr.Mcodigo#">,
                                  #rsDistribucion.Monto#,
                                    1,
                                  #rsDistribucion.Monto#,
                                 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucionAgr.TipoMovimiento#">,
                                 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucionAgr.Rsvano#">,
                                 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucionAgr.Rsvmes#">
                                )
                	</cfquery>
        		</cfloop>
		</cfloop>
        <!---Termina cambio suficiencias agrupadas RVD--->


		<!---- Trae las lineas de clasificacion con discribucion --->

		<!---- Trae las lineas que son articulos con discribucion --->
		<cfquery name="rsClasificacionConDistribucion" datasource="#session.DSN#">
			select
				'CTRC' as ModuloOrigen,
				<cf_dbfunction name="to_char" args="b.CTCnumContrato" > as NumeroDocumento,
				'Contrato' as NumeroReferencia,
				b.CTfecha as FechaDocumento,
                    case
               	when a.CPCano < #rsPeriodoAuxiliar.Pvalor#
                   	then  #rsPeriodoAuxiliar.Pvalor#
                   else  a.CPCano end as AnoDocumento ,
                     case
					when a.CPCmes < #rsMesAuxiliar.Pvalor#
                       	then  #rsMesAuxiliar.Pvalor#
           	            else a.CPCmes end  as MesDocumento,
				a.CTDCconsecutivo,
				b.Ocodigo as Ocodigo,
				d.Oficodigo as CodigoOficina,
				b.CTMcodigo as Mcodigo,
				a.CTDCmontoTotal	as MtoOrigen,
				b.CTtipoCambio,  <!---TipoCambio--->
				a.CTDCmontoTotal as Monto,
				'CC' as TipoMovimiento,
				a.Cid,
				a.CMtipo as Tipoitem,
				a.CPDCid,
				a.CTDCont,
                   a.Ccodigo,
                   a.CPDEid,
				a.CPCano as Rsvano,
				a.CPCmes as Rsvmes
			from CTDetContrato a
				inner join CTContrato b
				on b.CTContid  = a.CTContid
                inner join Oficinas d
				on d.Ocodigo = b.Ocodigo
				and d.Ecodigo = b.Ecodigo

				left join CFuncional c
				on c.CFid = a.CFid
			where a.CTContid =  #LvarCTContid#
			and CPDCid is not null
               and Ccodigo is not null
               and a.CPDEid <> -1
		</cfquery>


		<!--- Para cada linea con distribucion --->
		<cfloop query="rsClasificacionConDistribucion">
	        <cfquery name="rsSaldoDistribuir" datasource="#session.DSN#">
               select sum(CPDDsaldo) as Saldo from CPDocumentoD
               where CPDEid = #rsClasificacionConDistribucion.CPDEid#
               and CPCmes = #rsClasificacionConDistribucion.Rsvmes#
               and CPCano = #rsClasificacionConDistribucion.Rsvano#
	        </cfquery>


			<!--- Obtiene la distribucion --->
			<cfinvoke component="sif.Componentes.PRES_Distribucion" method="GenerarDistribucion"
	            Ccodigo="#rsClasificacionConDistribucion.Ccodigo#"
	            CPDCid="#rsClasificacionConDistribucion.CPDCid#"
	            Tipo="#rsClasificacionConDistribucion.Tipoitem#"
	            Aplica="1"
	            cantidad="1"
	            monto="#rsClasificacionConDistribucion.Monto#"
                Modulo="Contratos"
	            returnVariable="rsDistribucion">

			<cfquery name="rsMontoDistribuido" dbtype="query">
           		select sum(Monto) as Monto from rsDistribucion
            </cfquery>

			<cfset varMonto = #rsMontoDistribuido.Monto#>
			<cfset varMonto = varMonto * 100>
			<cfset varMonto = round(varMonto)>
			<cfset varMonto = varMonto/100>

			<cfif rsSaldoDistribuir.Saldo LTE varMonto>
				<cfset varTotalSuf = true>
			<cfelse>
				<cfset varTotalSuf = false>
			</cfif>

			<cfif varTotalSuf EQ true>
      			<cfset NumLinea = 0>
                <cfloop query="rsDistribucion">
					<cfquery name="rsCPcuenta" datasource="#session.DSN#">
	                    select CPcuenta from CFinanciera
	                    where CFformato = '#rsDistribucion.cuenta#'
	                    and Ecodigo = #session.Ecodigo#
	                </cfquery>


                    <cfquery name="rsLineasSuficiencia" datasource="#session.DSN#">
                        select CPDEid,CPcuenta,CPCmes,CPCano,CPDDsaldo from CPDocumentoD
                        where CPDEid = #rsClasificacionConDistribucion.CPDEid#
                        and CPCmes = #rsClasificacionConDistribucion.Rsvmes#
                        and CPCano = #rsClasificacionConDistribucion.Rsvano#
                        and CPcuenta = #rsCPcuenta.CPcuenta#
                     </cfquery>

                     <cfset NumLinea = NumLinea + 1>

	                 <cfquery name="rs" datasource="#session.DSN#">
	                 	insert into #request.intPresupuesto#(
	                          ModuloOrigen,
	                          NumeroDocumento,
	                          NumeroReferencia,
	                          FechaDocumento,
	                          AnoDocumento,
	                          MesDocumento,
	                          NumeroLinea,
	                          CFcuenta,
	                          Ocodigo,
	                          CodigoOficina,
	                          Mcodigo,
	                          MontoOrigen,
	                          TipoCambio,
	                          Monto,
	                          TipoMovimiento,
                              CPCanoP,
                              CPCmesP)

			              values 	(

			                         <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsClasificacionConDistribucion.ModuloOrigen#">,
			                         <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsClasificacionConDistribucion.NumeroDocumento#">,
			                         <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsClasificacionConDistribucion.NumeroReferencia#">,
			                         <cfqueryparam cfsqltype="cf_sql_date" value="#rsClasificacionConDistribucion.FechaDocumento#">,
			                         <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsClasificacionConDistribucion.AnoDocumento#">,
			                         <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsClasificacionConDistribucion.MesDocumento#">,
			                          (#rsClasificacionConDistribucion.CTDCconsecutivo# * 10000) + #NumLinea#,
			                          (select CFcuenta from CFinanciera
			                           where CFformato = '#rsDistribucion.cuenta#'),
			                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsClasificacionConDistribucion.Ocodigo#">,
			                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsClasificacionConDistribucion.CodigoOficina#">,
			                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsClasificacionConDistribucion.Mcodigo#">,
			                        #rsLineasSuficiencia.CPDDsaldo#,
			                          1,
			                        #rsLineasSuficiencia.CPDDsaldo#,
			                       <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsClasificacionConDistribucion.TipoMovimiento#">,
                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsClasificacionConDistribucion.Rsvano#">,
                                 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsClasificacionConDistribucion.Rsvmes#">
			                      )
			         </cfquery>
                 </cfloop> <!--- rsDistribucion --->

            <cfelseif varTotalSuf EQ false>
				<cfset NumLinea = 0>
                <cfloop query="rsDistribucion">
                	<cfset NumLinea = NumLinea + 1>

                    <cfquery name="rs" datasource="#session.DSN#">
                        insert into #request.intPresupuesto#(
                            ModuloOrigen,
                            NumeroDocumento,
                            NumeroReferencia,
                            FechaDocumento,
                            AnoDocumento,
                            MesDocumento,
                            NumeroLinea,
                            CFcuenta,
                            Ocodigo,
                            CodigoOficina,
                            Mcodigo,
                            MontoOrigen,
                            TipoCambio,
                            Monto,
                            TipoMovimiento,
                            CPCanoP,
                             CPCmesP)

		                values 	(

		                           <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsClasificacionConDistribucion.ModuloOrigen#">,
		                           <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsClasificacionConDistribucion.NumeroDocumento#">,
		                           <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsClasificacionConDistribucion.NumeroReferencia#">,
		                           <cfqueryparam cfsqltype="cf_sql_date" value="#rsClasificacionConDistribucion.FechaDocumento#">,
		                           <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsClasificacionConDistribucion.AnoDocumento#">,
		                           <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsClasificacionConDistribucion.MesDocumento#">,
		                            (#rsClasificacionConDistribucion.CTDCconsecutivo# * 10000) + #NumLinea#,
		                            (select CFcuenta from CFinanciera
		                             where CFformato = '#rsDistribucion.cuenta#'),
		                          <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsClasificacionConDistribucion.Ocodigo#">,
		                          <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsClasificacionConDistribucion.CodigoOficina#">,
		                          <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsClasificacionConDistribucion.Mcodigo#">,
		                          #rsDistribucion.Monto#,
		                            1,
		                          #rsDistribucion.Monto#,
		                         <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsClasificacionConDistribucion.TipoMovimiento#">,
                                 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsClasificacionConDistribucion.Rsvano#">,
                                 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsClasificacionConDistribucion.Rsvmes#">
		                        )
		            </cfquery>
                </cfloop> <!--- rsDistribucion --->
			</cfif>
		</cfloop> <!--- rsLineasConDistribucion --->
	    <!----Fin Clasificacion--->

        <!---Inicia cambio de agrupación de suficiencias Con distribución de Clasificación--->
        <!---- Trae las lineas que son articulos con discribucion --->
		<cfquery name="rsClasificacionConDistribucionAgr" datasource="#session.DSN#">
			select
				'CTRC' as ModuloOrigen,
				<cf_dbfunction name="to_char" args="b.CTCnumContrato" > as NumeroDocumento,
				'Contrato' as NumeroReferencia,
				b.CTfecha as FechaDocumento,
                    case
               	when a.CPCano < #rsPeriodoAuxiliar.Pvalor#
                   	then  #rsPeriodoAuxiliar.Pvalor#
                   else  a.CPCano end as AnoDocumento ,
                     case
					when a.CPCmes < #rsMesAuxiliar.Pvalor#
                       	then  #rsMesAuxiliar.Pvalor#
           	            else a.CPCmes end  as MesDocumento,
				a.CTDCconsecutivo,
				b.Ocodigo as Ocodigo,
				d.Oficodigo as CodigoOficina,
				b.CTMcodigo as Mcodigo,
				a.CTDCmontoTotal	as MtoOrigen,
				b.CTtipoCambio,  <!---TipoCambio--->
				a.CTDCmontoTotal as Monto,
				'CC' as TipoMovimiento,
				a.Cid,
				a.CMtipo as Tipoitem,
				a.CPDCid,
				a.CTDCont,
                   a.Ccodigo,
                   a.CPDEid,
				a.CPCano as Rsvano,
				a.CPCmes as Rsvmes
			from CTDetContrato a
				inner join CTContrato b
				on b.CTContid  = a.CTContid
                inner join Oficinas d
				on d.Ocodigo = b.Ocodigo
				and d.Ecodigo = b.Ecodigo

				left join CFuncional c
				on c.CFid = a.CFid
			where a.CTContid =  #LvarCTContid#
			and CPDCid is not null
               and Ccodigo is not null
               and a.CPDEid = -1
		</cfquery>

		<!--- Para cada linea con distribucion --->
		<cfloop query="rsClasificacionConDistribucionAgr">

			<!--- Obtiene la distribucion --->
			<cfinvoke component="sif.Componentes.PRES_Distribucion" method="GenerarDistribucion"
	            Ccodigo="#rsClasificacionConDistribucionAgr.Ccodigo#"
	            CPDCid="#rsClasificacionConDistribucionAgr.CPDCid#"
	            Tipo="#rsClasificacionConDistribucionAgr.Tipoitem#"
	            Aplica="1"
	            cantidad="1"
	            monto="#rsClasificacionConDistribucionAgr.Monto#"
                Modulo="Contratos"
	            returnVariable="rsDistribucion">

			<cfquery name="rsMontoDistribuido" dbtype="query">
           		select sum(Monto) as Monto from rsDistribucion
            </cfquery>

			<cfset varMonto = #rsMontoDistribuido.Monto#>
			<cfset varMonto = varMonto * 100>
			<cfset varMonto = round(varMonto)>
			<cfset varMonto = varMonto/100>

      			<cfset NumLinea = 0>
                <cfloop query="rsDistribucion">
					<cfquery name="rsCPcuenta" datasource="#session.DSN#">
	                    select CPcuenta from CFinanciera
	                    where CFformato = '#rsDistribucion.cuenta#'
	                    and Ecodigo = #session.Ecodigo#
	                </cfquery>


                    <cfquery name="rsLineasSuficiencia" datasource="#session.DSN#">
                        select CPDEid,CPcuenta,CPCmes,CPCano,CPDDsaldo from CPDocumentoD
                        where CPDEid = #rsClasificacionConDistribucionAgr.CPDEid#
                        and CPCmes = #rsClasificacionConDistribucionAgr.Rsvmes#
                        and CPCano = #rsClasificacionConDistribucionAgr.Rsvano#
                        and CPcuenta = #rsCPcuenta.CPcuenta#
                     </cfquery>

                     <cfset NumLinea = NumLinea + 1>

	                 <cfquery name="rs" datasource="#session.DSN#">
	                 	insert into #request.intPresupuesto#(
	                          ModuloOrigen,
	                          NumeroDocumento,
	                          NumeroReferencia,
	                          FechaDocumento,
	                          AnoDocumento,
	                          MesDocumento,
	                          NumeroLinea,
	                          CFcuenta,
	                          Ocodigo,
	                          CodigoOficina,
	                          Mcodigo,
	                          MontoOrigen,
	                          TipoCambio,
	                          Monto,
	                          TipoMovimiento,
                              CPCanoP,
                              CPCmesP)

			              values 	(

			                         <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsClasificacionConDistribucionAgr.ModuloOrigen#">,
			                         <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsClasificacionConDistribucionAgr.NumeroDocumento#">,
			                         <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsClasificacionConDistribucionAgr.NumeroReferencia#">,
			                         <cfqueryparam cfsqltype="cf_sql_date" value="#rsClasificacionConDistribucionAgr.FechaDocumento#">,
			                         <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsClasificacionConDistribucionAgr.AnoDocumento#">,
			                         <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsClasificacionConDistribucionAgr.MesDocumento#">,
			                          (#rsClasificacionConDistribucionAgr.CTDCconsecutivo# * 10000) + #NumLinea#,
			                          (select CFcuenta from CFinanciera
			                           where CFformato = '#rsDistribucion.cuenta#'),
			                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsClasificacionConDistribucionAgr.Ocodigo#">,
			                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsClasificacionConDistribucionAgr.CodigoOficina#">,
			                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsClasificacionConDistribucionAgr.Mcodigo#">,
			                        #rsDistribucion.Monto#,
			                          1,
			                        #rsDistribucion.Monto#,
			                       <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsClasificacionConDistribucionAgr.TipoMovimiento#">,
                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsClasificacionConDistribucionAgr.Rsvano#">,
                                 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsClasificacionConDistribucionAgr.Rsvmes#">
			                      )
			         </cfquery>
                 </cfloop>
		</cfloop> <!--- rsLineasConDistribucion --->
	    <!----Fin Clasificacion--->



        <!---Termina cambio de agrupación de suficiencias Con Distribución de Clasificación--->

		<!--- DesReserva de la PROVISION referenciando a la Suficiencia Sin Distribución--->
		<cfquery name="rs" datasource="#session.DSN#">
			insert into #request.intPresupuesto#(
				ModuloOrigen,
				NumeroDocumento,
				NumeroReferencia,
				FechaDocumento,
				AnoDocumento,
				MesDocumento,
				NumeroLinea,
				CPcuenta,
				Ocodigo,
				CodigoOficina,
				Mcodigo,
				MontoOrigen,
				TipoCambio,
				Monto,
				TipoMovimiento,
				NAPreferencia,
				LINreferencia,
                CPCanoP,
                CPCmesP)
			select
				'CTRC',
				<cf_dbfunction name="to_char" args="b.CTCnumContrato" >,
				'Contrato',
				b.CTfecha,
                c.CPCano,
                case when c.CPCmes <= #rsMesAuxiliar.Pvalor#
                	then #rsMesAuxiliar.Pvalor#
                else
                	c.CPCmes end as MesDocumento,
                 -1*((a.CTDCconsecutivo * 10000) + a.CTDCconsecutivo),
				napSC.CPcuenta,
				napSC.Ocodigo,
				<cf_jdbcquery_param cfsqltype="cf_sql_char" value="null">,
				b.CTMcodigo,
				-a.CTDCmontoTotal,
				1,
				-a.CTDCmontoTotal,
				'RP',
				d.NAP,
				c.CPDDlinea,
                a.CPCano,
                a.CPCmes
			from CTDetContrato a
				inner join CTContrato b
				 on b.CTContid = a.CTContid
                    inner join CPDocumentoD c
                    	on c.CPDDid = a.CPDDid
                     inner join CPDocumentoE d
                     	on c.CPDEid = d.CPDEid
                     inner join  CPNAPdetalle napSC
				 on napSC.Ecodigo		= a.Ecodigo
				and napSC.CPNAPnum		= d.NAP
				and napSC.CPNAPDlinea	= c.CPDDlinea
			where b.CTContid = #LvarCTContid#
               and c.CPDCid is null
		</cfquery>
        <!--- DesReserva de las PROVISIONES Agrupadas SIN Distribución--->
        <cfquery name="rsAgrupadas" datasource="#session.DSN#">
			insert into #request.intPresupuesto#(
				ModuloOrigen,
				NumeroDocumento,
				NumeroReferencia,
				FechaDocumento,
				AnoDocumento,
				MesDocumento,
				NumeroLinea,
				CPcuenta,
				Ocodigo,
				CodigoOficina,
				Mcodigo,
				MontoOrigen,
				TipoCambio,
				Monto,
				TipoMovimiento,
				NAPreferencia,
				LINreferencia,
                CPCanoP,
                CPCmesP)
			select
				'CTRC',
				<cf_dbfunction name="to_char" args="b.CTCnumContrato" >,
				'Contrato',
				b.CTfecha,
                c.CPCano,
                case when c.CPCmes <= #rsMesAuxiliar.Pvalor#
                	then #rsMesAuxiliar.Pvalor#
                else
                	c.CPCmes end as MesDocumento,
                 -1*((a.CTDCconsecutivo * 10000) + a.CTDContAgr),
				napSC.CPcuenta,
				napSC.Ocodigo,
				<cf_jdbcquery_param cfsqltype="cf_sql_char" value="null">,
				b.CTMcodigo,
				-a.CTDCmontoTotal,
				1,
				-a.CTDCmontoTotal,
				'RP',
				d.NAP,
				c.CPDDlinea,
                a.CPCano,
                a.CPCmes
			from CTDetContratoAgr a
				inner join CTContrato b
				 on b.CTContid = a.CTContid
                    inner join CPDocumentoD c
                    	on c.CPDDid = a.CPDDid
                     inner join CPDocumentoE d
                     	on c.CPDEid = d.CPDEid
                     inner join  CPNAPdetalle napSC
				 on napSC.Ecodigo		= a.Ecodigo
				and napSC.CPNAPnum		= d.NAP
				and napSC.CPNAPDlinea	= c.CPDDlinea
			where b.CTContid = #LvarCTContid#
               and c.CPDCid is null
		</cfquery>



	<!--- DesReserva de la PROVISION referenciando a la Suficiencia CON Distribución Servicio--->
        <cfquery name="rsConDistribucion" datasource="#session.DSN#">
			select
				'CTRC' as ModuloOrigen,
				<cf_dbfunction name="to_char" args="b.CTCnumContrato" > as NumeroDocumento,
				'Contrato' as NumeroReferencia,
				b.CTfecha as FechaDocumento,
				c.CPCano as AnoDocumento,
				c.CPCmes as MesDocumento,
				napSC.Ocodigo as Ocodigo,
				b.CTMcodigo as Mcodigo,
				a.CTDCmontoTotal as Monto,
				'RP' as TipoMovimiento,
				d.NAP,
                   a.Cid,
                   a.CPDCid,
                   a.CMtipo as TipoItem,
                   f.Oficodigo as CodigoOficina,
                   a.Ccodigo,
                   a.CPDEid,
                   a.CPCano as Rsvano,
				   a.CPCmes as Rsvmes,
                   a.CTDCconsecutivo
			from CTDetContrato a
				inner join CTContrato b
				 on b.CTContid = a.CTContid
                    inner join CPDocumentoD c
                    	on c.CPDEid = a.CPDEid
                       and a.CPCano = c.CPCano
                       and a.CPCmes = c.CPCmes
                     inner join CPDocumentoE d
                     	on c.CPDEid = d.CPDEid
                     inner join  CPNAPdetalle napSC
                        on napSC.Ecodigo		= a.Ecodigo
                       and napSC.CPNAPnum		= d.NAP
      					and napSC.CPNAPDlinea	= c.CPDDlinea
                     inner join CFuncional  e
                      	on a.CFid = e.CFid
                       inner join Oficinas f
				on f.Ocodigo = e.Ocodigo
				and f.Ecodigo = e.Ecodigo

			where b.CTContid = #LvarCTContid#
               and a.CPDCid is not null
               and a.Cid is not null
               and a.CPDEid <> -1
               group by
				b.CTTCid ,CTfecha,c.CPCano, c.CPCmes,b.CTCnumContrato,
				a.CTDCconsecutivo, napSC.Ocodigo, b.CTMcodigo,b.CTtipoCambio,d.NAP,a.Cid, a.CPDCid,a.CMtipo,f.Oficodigo,
                   a.Ccodigo, a.CTDCmontoTotal,a.CPDEid,a.CPCano,a.CPCmes
		</cfquery>

		<cfif rsConDistribucion.recordcount GT 0>
			<cfloop query="rsConDistribucion">
				<cfquery name="rsSaldoDistribuir" datasource="#session.DSN#">
				    select sum(CPDDsaldo) as Saldo from CPDocumentoD
				    where CPDEid = #rsConDistribucion.CPDEid#
				    and CPCmes = #rsConDistribucion.Rsvmes#
				    and CPCano = #rsConDistribucion.Rsvano#
				</cfquery>

				<!--- Obtiene la distribucion --->
				<cfinvoke component="sif.Componentes.PRES_Distribucion" method="GenerarDistribucion"
				Cid = "#rsConDistribucion.Cid#"
				               CPDCid ="#rsConDistribucion.CPDCid#"
				               Tipo ="#rsConDistribucion.Tipoitem#"
				               Aplica ="1"
				               cantidad ="1"
				               monto ="#rsConDistribucion.Monto#"
                               Modulo="Contratos"
				           	returnVariable="rsDistribucion">

			     <cfquery name="rsMontoDistribuido" dbtype="query">
			          select sum(Monto) as Monto from rsDistribucion
			     </cfquery>

			     <cfset varMonto = #rsMontoDistribuido.Monto#>
				 <cfset varMonto = varMonto * 100>
				 <cfset varMonto = round(varMonto)>
				 <cfset varMonto = varMonto/100>

                 <cfif rsSaldoDistribuir.Saldo LTE varMonto>
                     <cfset varTotalSuf = true>
                 <cfelse>
                     <cfset varTotalSuf = false>
                 </cfif>

   			 	<cfif varTotalSuf EQ true>
					<cfquery name="rsFinancieras" datasource="#session.DSN#">
					    select * from CFinanciera
					    where Ecodigo = #Arguments.EcodigoAlterno#
					</cfquery>


					<cfquery name="rsFinanciera" dbtype="query">
					   select rsFinancieras.CPcuenta,rsDistribucion.monto, rsFinancieras.CFcuenta
					   from rsFinancieras,rsDistribucion
					   where rsFinancieras.CFcuenta = rsDistribucion.IDcuenta
					</cfquery>

					<cfquery name="rsLineasSuficiencia" datasource="#session.DSN#">
					     select CPDEid,CPcuenta,CPCmes,CPCano,CPDDsaldo
					     from CPDocumentoD
					     where CPDEid = #rsConDistribucion.CPDEid#
					     and CPCmes = #rsConDistribucion.Rsvmes#
                         and CPCano = #rsConDistribucion.Rsvano#
					</cfquery>


                    <cfquery name="rsNAP" datasource="#session.DSN#">
                        select CPNAPDlinea, CPcuenta,CPNAPnum from CPNAPdetalle
                        where CPNAPnum = #rsConDistribucion.NAP#
                        and CPCmes = #rsConDistribucion.Rsvmes#
                        and CPCano = #rsConDistribucion.Rsvano#
                    </cfquery>


					<cfquery name="rsLineas" dbtype="query">
						select rsFinanciera.CPcuenta,rsNAP.CPNAPnum,rsNAP.CPNAPDlinea ,rsFinanciera.monto,rsFinanciera.CFcuenta
						from rsFinanciera, rsNAP
						where rsFinanciera.CPcuenta = rsNAP.CPcuenta
					</cfquery>

					<cfquery name="rsLineasNAP" dbtype="query">
						select * from rsLineas, rsLineasSuficiencia
						where rsLineas.CPcuenta = rsLineasSuficiencia.CPcuenta
					</cfquery>

					<cfset NumLinea = 0>

					<cfloop query="rsLineasNAP">
						<cfset NumLinea = NumLinea + 1>

						<cfquery name="rs" datasource="#session.DSN#">
				               insert into #request.intPresupuesto#(
				                   ModuloOrigen,
				                   NumeroDocumento,
				                   NumeroReferencia,
				                   FechaDocumento,
				                   AnoDocumento,
				                   MesDocumento,
				                   NumeroLinea,
				                   CPcuenta,
				                   Ocodigo,
				                   CodigoOficina,
				                   Mcodigo,
				                   MontoOrigen,
				                   TipoCambio,
				                   Monto,
				                   TipoMovimiento,
				                   NAPreferencia,
				                   LINreferencia,
                                   CPCmesP,
                                   CPCanoP)
								values(    <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsConDistribucion.ModuloOrigen#">,
								            <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsConDistribucion.NumeroDocumento#">,
								            <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsConDistribucion.NumeroReferencia#">,
								            <cfqueryparam cfsqltype="cf_sql_date" value="#rsConDistribucion.FechaDocumento#">,
								            <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPeriodoAuxiliar.Pvalor#">,
                                           <cfif rsConDistribucion.Rsvmes LTE rsMesAuxiliar.Pvalor>
								            <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsMesAuxiliar.Pvalor#">,
                                           <cfelse>
                                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsConDistribucion.Rsvmes#">,
                                           </cfif>
                                               -1*((#rsConDistribucion.CTDCconsecutivo# * 10000) + #NumLinea#),
								            '#rsLineasNAP.CPcuenta#',
								            <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsConDistribucion.Ocodigo#">,
								            <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsConDistribucion.CodigoOficina#">,
								            <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsConDistribucion.Mcodigo#">,
								            -1*(#rsLineasNAP.CPDDsaldo#),
								            1,
								           -1*(#rsLineasNAP.CPDDsaldo#),
								            <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsConDistribucion.TipoMovimiento#">,
								            #rsLineasNAP.CPNAPnum#, 	<!---NAPreferencia--->
								            #rsLineasNAP.CPNAPDlinea#,    <!---LINreferencia--->
                                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsConDistribucion.Rsvmes#">,
			                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsConDistribucion.Rsvano#">
								   )
						</cfquery>
					</cfloop> <!--- rsDistribucion --->

				<cfelseif varTotalSuf EQ false>

	                <cfquery name="rsFinancieras" datasource="#session.DSN#">
	                    select *
	                    from CFinanciera
	                    where Ecodigo = #Arguments.EcodigoAlterno#
	                </cfquery>

                    <cfquery name="rsFinanciera" dbtype="query">
                        select rsFinancieras.CPcuenta,rsDistribucion.monto, rsFinancieras.CFcuenta
						from rsFinancieras,rsDistribucion
                        where rsFinancieras.CFcuenta = rsDistribucion.IDcuenta
                    </cfquery>


                    <cfquery name="rsNAP" datasource="#session.DSN#">
                        select CPNAPDlinea, CPcuenta,CPNAPnum
						from CPNAPdetalle
                        where CPNAPnum = #rsConDistribucion.NAP#
                        and CPCmes = #rsConDistribucion.Rsvmes#
                        and CPCano = #rsConDistribucion.Rsvano#
                    </cfquery>


                    <cfquery name="rsLineas" dbtype="query">
                        select rsFinanciera.CPcuenta,rsNAP.CPNAPnum,rsNAP.CPNAPDlinea ,rsFinanciera.monto,rsFinanciera.CFcuenta
                        from rsFinanciera, rsNAP
                        where rsFinanciera.CPcuenta = rsNAP.CPcuenta
                    </cfquery>

                    <cfquery name="rsLineasNAP" dbtype="query">
                        select * from rsLineas, rsDistribucion
                        where rsLineas.CFcuenta = rsDistribucion.IdCuenta
                        order by CFid
                    </cfquery>

				    <cfset NumLinea = 0>

                    <cfloop query="rsLineasNAP">
                       <cfset NumLinea = NumLinea + 1>
	                    <cfquery name="rs" datasource="#session.DSN#">
	                        insert into #request.intPresupuesto#(
	                            ModuloOrigen,
	                            NumeroDocumento,
	                            NumeroReferencia,
	                            FechaDocumento,
	                            AnoDocumento,
	                            MesDocumento,
	                            NumeroLinea,
	                            CPcuenta,
	                            Ocodigo,
	                            CodigoOficina,
	                            Mcodigo,
	                            MontoOrigen,
	                            TipoCambio,
	                            Monto,
	                            TipoMovimiento,
	                            NAPreferencia,
	                            LINreferencia,
                                CPCmesP,
                                CPCanoP)
		        			 values(
		                       <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsConDistribucion.ModuloOrigen#">,
		                       <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsConDistribucion.NumeroDocumento#">,
		                       <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsConDistribucion.NumeroReferencia#">,
		                       <cfqueryparam cfsqltype="cf_sql_date" value="#rsConDistribucion.FechaDocumento#">,
		                       <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPeriodoAuxiliar.Pvalor#">,
                               <cfif rsConDistribucion.Rsvmes LTE rsMesAuxiliar.Pvalor>
								  <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsMesAuxiliar.Pvalor#">,
                               <cfelse>
                                  <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsConDistribucion.Rsvmes#">,
                               </cfif>
                               -1*((#rsConDistribucion.CTDCconsecutivo# * 10000) + #NumLinea#),
		                       '#rsLineasNAP.CPcuenta#',
		                       <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsConDistribucion.Ocodigo#">,
		                       <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsConDistribucion.CodigoOficina#">,
		                       <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsConDistribucion.Mcodigo#">,
		                       -1*(#rsLineasNAP.Monto#),
		                       1,
		                      -1*(#rsLineasNAP.Monto#),
		                       <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsConDistribucion.TipoMovimiento#">,
		                       #rsLineasNAP.CPNAPnum#, 	<!---NAPreferencia--->
		                       #rsLineasNAP.CPNAPDlinea#,    <!---LINreferencia--->
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsConDistribucion.Rsvmes#">,
                                 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsConDistribucion.Rsvano#">
		              			)
	                	</cfquery>
                    </cfloop> <!--- rsDistribucion --->
				</cfif>
			</cfloop> <!--- rsLineasConDistribucion --->
		</cfif>


		<!---Inicia cambio de agrupación de suficiencias RVD--->
        <cfquery name="rsConDistribucionAgr" datasource="#session.DSN#">
			select
				'CTRC' as ModuloOrigen,
				<cf_dbfunction name="to_char" args="c.CTCnumContrato" > as NumeroDocumento,
				'Contrato' as NumeroReferencia,
				c.CTfecha as FechaDocumento,
				d.CPCano as AnoDocumento,
				d.CPCmes as MesDocumento,
				napSC.Ocodigo as Ocodigo,
				c.CTMcodigo as Mcodigo,
				a.CTDCmontoTotal as Monto,
				'RP' as TipoMovimiento,
				e.NAP,
                   a.Cid,
                   a.CPDCid,
                   a.CMtipo as TipoItem,
                   g.Oficodigo as CodigoOficina,
                   a.Ccodigo,
                   a.CPDEid,
                   a.CPCano as Rsvano,
				   a.CPCmes as Rsvmes,
                   b.CTDCconsecutivo
                from CTDetContratoAgr a
                    inner join CTDetContrato b
                        on a.IdAgrSuf = b.CTDCont
                    inner join CTContrato c
                        on c.CTContid = b.CTContid
                    inner join CPDocumentoD d
                        on d.CPDEid = a.CPDEid and a.CPCano = d.CPCano and a.CPCmes = d.CPCmes
                    inner join CPDocumentoE e
                        on e.CPDEid = d.CPDEid
                    inner join CPNAPdetalle napSC
                        on napSC.Ecodigo = a.Ecodigo and napSC.CPNAPnum	= e.NAP and napSC.CPNAPDlinea = d.CPDDlinea
                    inner join CFuncional f
                        on d.CFid = f.CFid
                    inner join Oficinas g
                        on f.Ocodigo = d.Ocodigo and f.Ecodigo = e.Ecodigo
                    where b.CTContid = #LvarCTContid#
                    and a.CPDCid is not null and a.Cid is not null
					group by c.CTTCid ,CTfecha,d.CPCano, d.CPCmes,c.CTCnumContrato, b.CTDCconsecutivo, napSC.Ocodigo, c.CTMcodigo,c.CTtipoCambio,e.NAP,a.Cid,
					a.CPDCid,a.CMtipo,g.Oficodigo, a.Ccodigo, a.CTDCmontoTotal,a.CPDEid,a.CPCano,a.CPCmes
		</cfquery>

		<cfif rsConDistribucionAgr.recordcount GT 0>
			<cfset NumLinea = 0>
			<cfloop query="rsConDistribucionAgr">

				<!--- Obtiene la distribucion --->
				<cfinvoke component="sif.Componentes.PRES_Distribucion" method="GenerarDistribucion"
				Cid = "#rsConDistribucionAgr.Cid#"
				               CPDCid ="#rsConDistribucionAgr.CPDCid#"
				               Tipo ="#rsConDistribucionAgr.Tipoitem#"
				               Aplica ="1"
				               cantidad ="1"
				               monto ="#rsConDistribucionAgr.Monto#"
                               Modulo="Contratos"
				           	returnVariable="rsDistribucion">

			     <cfquery name="rsMontoDistribuido" dbtype="query">
			          select sum(Monto) as Monto from rsDistribucion
			     </cfquery>

			     <cfset varMonto = #rsMontoDistribuido.Monto#>
				 <cfset varMonto = varMonto * 100>
				 <cfset varMonto = round(varMonto)>
				 <cfset varMonto = varMonto/100>

					<cfquery name="rsFinancieras" datasource="#session.DSN#">
					    select * from CFinanciera
					    where Ecodigo = #Arguments.EcodigoAlterno#
					</cfquery>


					<cfquery name="rsFinanciera" dbtype="query">
					   select rsFinancieras.CPcuenta,rsDistribucion.monto, rsFinancieras.CFcuenta
					   from rsFinancieras,rsDistribucion
					   where rsFinancieras.CFcuenta = rsDistribucion.IDcuenta
					</cfquery>

					<cfquery name="rsLineasSuficiencia" datasource="#session.DSN#">
					     select CPDEid,CPcuenta,CPCmes,CPCano,CPDDsaldo
					     from CPDocumentoD
					     where CPDEid = #rsConDistribucionAgr.CPDEid#
					     and CPCmes = #rsConDistribucionAgr.Rsvmes#
                         and CPCano = #rsConDistribucionAgr.Rsvano#
					</cfquery>


                    <cfquery name="rsNAP" datasource="#session.DSN#">
                        select CPNAPDlinea, CPcuenta,CPNAPnum from CPNAPdetalle
                        where CPNAPnum = #rsConDistribucionAgr.NAP#
                        and CPCmes = #rsConDistribucionAgr.Rsvmes#
                        and CPCano = #rsConDistribucionAgr.Rsvano#
                    </cfquery>


					<cfquery name="rsLineas" dbtype="query">
						select rsFinanciera.CPcuenta,rsNAP.CPNAPnum,rsNAP.CPNAPDlinea ,rsFinanciera.monto,rsFinanciera.CFcuenta
						from rsFinanciera, rsNAP
						where rsFinanciera.CPcuenta = rsNAP.CPcuenta
					</cfquery>

					<cfquery name="rsLineasNAP" dbtype="query">
						select * from rsLineas, rsLineasSuficiencia
						where rsLineas.CPcuenta = rsLineasSuficiencia.CPcuenta
					</cfquery>


					<cfloop query="rsLineasNAP">
						<cfset NumLinea = NumLinea + 1>

						<cfquery name="rs" datasource="#session.DSN#">
				               insert into #request.intPresupuesto#(
				                   ModuloOrigen,
				                   NumeroDocumento,
				                   NumeroReferencia,
				                   FechaDocumento,
				                   AnoDocumento,
				                   MesDocumento,
				                   NumeroLinea,
				                   CPcuenta,
				                   Ocodigo,
				                   CodigoOficina,
				                   Mcodigo,
				                   MontoOrigen,
				                   TipoCambio,
				                   Monto,
				                   TipoMovimiento,
				                   NAPreferencia,
				                   LINreferencia,
                                   CPCmesP,
                                   CPCanoP)
								values(    <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsConDistribucionAgr.ModuloOrigen#">,
								            <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsConDistribucionAgr.NumeroDocumento#">,
								            <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsConDistribucionAgr.NumeroReferencia#">,
								            <cfqueryparam cfsqltype="cf_sql_date" value="#rsConDistribucionAgr.FechaDocumento#">,
								            <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPeriodoAuxiliar.Pvalor#">,
                                           <cfif rsConDistribucion.Rsvmes LTE rsMesAuxiliar.Pvalor>
								            <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsMesAuxiliar.Pvalor#">,
                                           <cfelse>
                                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsConDistribucion.Rsvmes#">,
                                           </cfif>
                                               -1*((#rsConDistribucionAgr.CTDCconsecutivo# * 10000) + #NumLinea#),
								            '#rsLineasNAP.CPcuenta#',
								            <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsConDistribucionAgr.Ocodigo#">,
								            <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsConDistribucionAgr.CodigoOficina#">,
								            <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsConDistribucionAgr.Mcodigo#">,
								            -1*(#rsLineasNAP.CPDDsaldo#),
								            1,
								           -1*(#rsLineasNAP.CPDDsaldo#),
								            <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsConDistribucionAgr.TipoMovimiento#">,
								            #rsLineasNAP.CPNAPnum#, 	<!---NAPreferencia--->
								            #rsLineasNAP.CPNAPDlinea#,    <!---LINreferencia--->
                                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsConDistribucionAgr.Rsvmes#">,
			                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsConDistribucionAgr.Rsvano#">
								   )
						</cfquery>
					</cfloop>
			</cfloop> <!--- rsLineasConDistribucion --->
		</cfif>

        <!----Termina cambio de la agrupación de suficiencias RVD--->

        <cfquery name="rsClasificacionConDistribucion" datasource="#session.DSN#">
			select
				'CTRC' as ModuloOrigen,
				<cf_dbfunction name="to_char" args="b.CTCnumContrato" > as NumeroDocumento,
				'Contrato' as NumeroReferencia,
				b.CTfecha as FechaDocumento,
				c.CPCano as AnoDocumento,
				c.CPCmes as MesDocumento,
				a.CTDCconsecutivo,
				napSC.Ocodigo as Ocodigo,
				b.CTMcodigo as Mcodigo,
				b.CTtipoCambio,
				a.CTDCmontoTotal as Monto,
				'RP' as TipoMovimiento,
				d.NAP,
			                a.Cid,
			                a.CPDCid,
			                a.CMtipo as TipoItem,
			                f.Oficodigo as CodigoOficina,
			                a.Ccodigo,
			                a.CPDEid,
                            a.CPCano as Rsvano,
							a.CPCmes as Rsvmes
			from CTDetContrato a
				inner join CTContrato b
				 on b.CTContid = a.CTContid
			                 inner join CPDocumentoD c
			                 	on c.CPDEid = a.CPDEid
			                    and a.CPCano = c.CPCano
			                    and a.CPCmes = c.CPCmes
			                  inner join CPDocumentoE d
			                  	on c.CPDEid = d.CPDEid
			                  inner join  CPNAPdetalle napSC
			                     on napSC.Ecodigo		= a.Ecodigo
			                    and napSC.CPNAPnum		= d.NAP
			   					and napSC.CPNAPDlinea	= c.CPDDlinea
			                   inner join CFuncional  e
			                   	on a.CFid = e.CFid
			                    inner join Oficinas f
				on f.Ocodigo = e.Ocodigo
				and f.Ecodigo = e.Ecodigo

			where b.CTContid = #LvarCTContid#
			    and a.CPDCid is not null
			    and a.Ccodigo is not null
                and a.CPDEid <> -1
			group by
				b.CTTCid ,CTfecha,c.CPCano, c.CPCmes,b.CTCnumContrato,
				a.CTDCconsecutivo, napSC.Ocodigo, b.CTMcodigo,b.CTtipoCambio,d.NAP,a.Cid, a.CPDCid,a.CMtipo,f.Oficodigo,
				               a.Ccodigo, a.CTDCmontoTotal,a.CPDEid, a.CPCmes, a.CPCano
		</cfquery>

		<cfif rsClasificacionConDistribucion.recordcount GT 0>
		   	<cfloop query="rsClasificacionConDistribucion">

		        <cfquery name="rsSaldoDistribuir" datasource="#session.DSN#">
		            select sum(CPDDsaldo) as Saldo from CPDocumentoD
		            where CPDEid = #rsClasificacionConDistribucion.CPDEid#
		            and CPCmes = #rsClasificacionConDistribucion.Rsvmes#
		            and CPCano = #rsClasificacionConDistribucion.Rsvano#
		        </cfquery>

			    <!--- Obtiene la distribucion --->
				<cfInvoke component="sif.Componentes.PRES_Distribucion" method="GenerarDistribucion"
					Ccodigo = "#rsClasificacionConDistribucion.Ccodigo#"
					CPDCid ="#rsClasificacionConDistribucion.CPDCid#"
					Tipo ="#rsClasificacionConDistribucion.Tipoitem#"
					Aplica ="1"
					cantidad ="1"
					monto ="#rsClasificacionConDistribucion.Monto#"
                    Modulo="Contratos"
					returnVariable="rsDistribucion">

					<cfquery name="rsMontoDistribuido" dbtype="query">
			             select sum(Monto) as Monto from rsDistribucion
			        </cfquery>

	                <cfset varMonto = #rsMontoDistribuido.Monto#>
					<cfset varMonto = varMonto * 100>
					<cfset varMonto = round(varMonto)>
					<cfset varMonto = varMonto/100>

			        <cfif rsSaldoDistribuir.Saldo LTE varMonto>
	                    <cfset varTotalSuf = true>
	                <cfelse>
	                    <cfset varTotalSuf = false>
	                </cfif>

					<cfif varTotalSuf EQ true>
						<cfquery name="rsFinancieras" datasource="#session.DSN#">
							select * from CFinanciera
							where Ecodigo = #Arguments.EcodigoAlterno#
						</cfquery>

						<cfquery name="rsFinanciera" dbtype="query">
							select rsFinancieras.CPcuenta,rsDistribucion.monto, rsFinancieras.CFcuenta from rsFinancieras,rsDistribucion
							where rsFinancieras.CFcuenta = rsDistribucion.IDcuenta
						</cfquery>

		    			<cfquery name="rsLineasSuficiencia" datasource="#session.DSN#">
		                     select CPDEid,CPcuenta,CPCmes,CPCano,CPDDsaldo from CPDocumentoD
		                     where CPDEid = #rsClasificacionConDistribucion.CPDEid#
		                     and CPCmes = #rsClasificacionConDistribucion.Rsvmes#
		                     and CPCano = #rsClasificacionConDistribucion.Rsvano#
		                </cfquery>

		                <cfquery name="rsNAP" datasource="#session.DSN#">
		                     select CPNAPDlinea, CPcuenta,CPNAPnum from CPNAPdetalle
		                     where CPNAPnum = #rsClasificacionConDistribucion.NAP#
		                     and CPCmes = #rsClasificacionConDistribucion.Rsvmes#
		                     and CPCano = #rsClasificacionConDistribucion.Rsvano#
		                </cfquery>

						<cfquery name="rsLineas" dbtype="query">
							select rsFinanciera.CPcuenta,rsNAP.CPNAPnum,rsNAP.CPNAPDlinea ,rsFinanciera.monto,rsFinanciera.CFcuenta
							from rsFinanciera, rsNAP
							where rsFinanciera.CPcuenta = rsNAP.CPcuenta
						</cfquery>

						<cfquery name="rsLineasNAPs" dbtype="query">
							select * from rsLineas, rsLineasSuficiencia
							where rsLineas.CPcuenta = rsLineasSuficiencia.CPcuenta
						</cfquery>

                        <cfset NumLinea = 0>

						<cfloop query="rsLineasNAPs">
						   <cfset NumLinea = NumLinea + 1>
							<cfquery name="rs" datasource="#session.DSN#">
		                    	insert into #request.intPresupuesto#(
		                           ModuloOrigen,
		                           NumeroDocumento,
		                           NumeroReferencia,
		                           FechaDocumento,
		                           AnoDocumento,
		                           MesDocumento,
		                           NumeroLinea,
		                           CPcuenta,
		                           Ocodigo,
		                           CodigoOficina,
		                           Mcodigo,
		                           MontoOrigen,
		                           TipoCambio,
		                           Monto,
		                           TipoMovimiento,
		                           NAPreferencia,
		                           LINreferencia,
                                   CPCmesP,
                                   CPCanoP)

								values(
				                     <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsClasificacionConDistribucion.ModuloOrigen#">,
				                     <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsClasificacionConDistribucion.NumeroDocumento#">,
				                     <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsClasificacionConDistribucion.NumeroReferencia#">,
				                     <cfqueryparam cfsqltype="cf_sql_date" value="#rsClasificacionConDistribucion.FechaDocumento#">,
				                     <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPeriodoAuxiliar.Pvalor#">,
									<cfif rsClasificacionConDistribucion.Rsvmes LTE rsMesAuxiliar.Pvalor>
                                      <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsMesAuxiliar.Pvalor#">,
                                    <cfelse>
                                      <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsClasificacionConDistribucion.Rsvmes#">,
                                    </cfif>
				                      ((#rsClasificacionConDistribucion.CTDCconsecutivo#*10000) + #NumLinea#)*-1,
				                       '#rsLineasNAPs.CPcuenta#',
				                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsClasificacionConDistribucion.Ocodigo#">,
				                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsClasificacionConDistribucion.CodigoOficina#">,
				                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsClasificacionConDistribucion.Mcodigo#">,
				                    -1*(#rsLineasNAPs.CPDDsaldo#),
				                      1,
				                    -1*(#rsLineasNAPs.CPDDsaldo#),
				                   <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsClasificacionConDistribucion.TipoMovimiento#">,
				                      #rsLineasNAPs.CPNAPnum#, 	<!---NAPreferencia--->
				                      #rsLineasNAPs.CPNAPDlinea#,  <!---LINreferencia--->
                                 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsClasificacionConDistribucion.Rsvmes#">,
                                 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsClasificacionConDistribucion.Rsvano#">
				               )
			          		</cfquery>
	              		</cfloop> <!--- rsDistribucion --->

					 <cfelseif varTotalSuf EQ false>

			            <cfquery name="rsFinancieras" datasource="#session.DSN#">
	            			select * from CFinanciera
	                        where Ecodigo = #Arguments.EcodigoAlterno#
			            </cfquery>

			            <cfquery name="rsFinanciera" dbtype="query">
	            			select rsFinancieras.CPcuenta,rsDistribucion.monto, rsFinancieras.CFcuenta
							from rsFinancieras,rsDistribucion
	                        where rsFinancieras.CFcuenta = rsDistribucion.IDcuenta
	            		</cfquery>

			            <cfquery name="rsNAP" datasource="#session.DSN#">
			            	select CPNAPDlinea, CPcuenta,CPNAPnum from CPNAPdetalle
			                where CPNAPnum = #rsClasificacionConDistribucion.NAP#
			                and CPCmes = #rsClasificacionConDistribucion.Rsvmes#
			                and CPCano = #rsClasificacionConDistribucion.Rsvano#
			            </cfquery>

						<cfquery name="rsLineas" dbtype="query">
							select rsFinanciera.CPcuenta,rsNAP.CPNAPnum,rsNAP.CPNAPDlinea ,rsFinanciera.monto,rsFinanciera.CFcuenta
					         from rsFinanciera, rsNAP
					         where rsFinanciera.CPcuenta = rsNAP.CPcuenta
						</cfquery>

						<cfquery name="rsLineasNAPs" dbtype="query">
							select * from rsLineas, rsDistribucion
				            where rsLineas.CFcuenta = rsDistribucion.IdCuenta
                            order by CFid
						</cfquery>

                         <cfset NumLinea = 0>
						<cfloop query="rsLineasNAPs">
                        	<cfset NumLinea = NumLinea + 1>
							<cfquery name="rs" datasource="#session.DSN#">
								insert into #request.intPresupuesto#(
									ModuloOrigen,
									NumeroDocumento,
									NumeroReferencia,
									FechaDocumento,
									AnoDocumento,
									MesDocumento,
									NumeroLinea,
									CPcuenta,
									Ocodigo,
									CodigoOficina,
									Mcodigo,
									MontoOrigen,
									TipoCambio,
									Monto,
									TipoMovimiento,
									NAPreferencia,
									LINreferencia,
                                    CPCmesP,
                                    CPCanoP)

								 values(
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsClasificacionConDistribucion.ModuloOrigen#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsClasificacionConDistribucion.NumeroDocumento#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsClasificacionConDistribucion.NumeroReferencia#">,
									<cfqueryparam cfsqltype="cf_sql_date" value="#rsClasificacionConDistribucion.FechaDocumento#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPeriodoAuxiliar.Pvalor#">,
									<cfif rsClasificacionConDistribucion.Rsvmes LTE rsMesAuxiliar.Pvalor>
                                      <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsMesAuxiliar.Pvalor#">,
                                    <cfelse>
                                      <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsClasificacionConDistribucion.Rsvmes#">,
                                    </cfif>
                                    ((#rsClasificacionConDistribucion.CTDCconsecutivo#*10000) + #NumLinea#)*-1,
									'#rsLineasNAPs.CPcuenta#',
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsClasificacionConDistribucion.Ocodigo#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsClasificacionConDistribucion.CodigoOficina#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsClasificacionConDistribucion.Mcodigo#">,
									                   -1*(#rsLineasNAPs.Monto#),
									1,
									                   -1*(#rsLineasNAPs.Monto#),
									                  <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsClasificacionConDistribucion.TipoMovimiento#">,
									#rsLineasNAPs.CPNAPnum#, 	<!---NAPreferencia--->
									#rsLineasNAPs.CPNAPDlinea#,  <!---LINreferencia--->
                                     <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsClasificacionConDistribucion.Rsvmes#">,
                                 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsClasificacionConDistribucion.Rsvano#">
									)
							</cfquery>
						</cfloop> <!--- rsDistribucion --->
					</cfif>
			</cfloop> <!--- rsLineasConDistribucion --->
		</cfif>

		<!---Inicia Cambio desreserva suficiencias agrupadas de clasificación con Distribución--->


        <cfquery name="rsClasificacionConDistribucionAgr" datasource="#session.DSN#">
			select
				'CTRC' as ModuloOrigen,
				<cf_dbfunction name="to_char" args="c.CTCnumContrato" > as NumeroDocumento,
				'Contrato' as NumeroReferencia,
				c.CTfecha as FechaDocumento,
				d.CPCano as AnoDocumento,
				d.CPCmes as MesDocumento,
				a.CTDCconsecutivo,
				napSC.Ocodigo as Ocodigo,
				c.CTMcodigo as Mcodigo,
				c.CTtipoCambio,
				a.CTDCmontoTotal as Monto,
				'RP' as TipoMovimiento,
				e.NAP,
                a.Cid,
                a.CPDCid,
                a.CMtipo as TipoItem,
                g.Oficodigo as CodigoOficina,
                a.Ccodigo,
                a.CPDEid,
                a.CPCano as Rsvano,
                a.CPCmes as Rsvmes,
                a.CTDContAgr
         from CTDetContratoAgr a
            inner join CTDetContrato b
                on a.IdAgrSuf = b.CTDCont
             inner join CTContrato c
             	on b.CTContid = c.CTContid
             inner join CPDocumentoD d
             	on d.CPDEid = a.CPDEid
                and a.CPCano = d.CPCano
                and a.CPCmes = d.CPCmes
             inner join CPDocumentoE e
                on d.CPDEid = e.CPDEid
             inner join CPNAPdetalle napSC
                on napSC.Ecodigo = a.Ecodigo
                and napSC.CPNAPnum	= e.NAP
                and napSC.CPNAPDlinea = d.CPDDlinea
             inner join CFuncional f
                on d.CFid = f.CFid
             inner join Oficinas g
                on g.Ocodigo = f.Ocodigo
                    and g.Ecodigo = f.Ecodigo
	        where c.CTContid = #LvarCTContid#
        and a.CPDCid is not null
        and a.Ccodigo is not null
        and b.CPDEid = -1
		group by c.CTTCid ,CTfecha,d.CPCano, d.CPCmes,c.CTCnumContrato, a.CTDCconsecutivo, napSC.Ocodigo, c.CTMcodigo,c.CTtipoCambio,e.NAP,a.Cid,
		a.CPDCid,a.CMtipo,g.Oficodigo, a.Ccodigo, a.CTDCmontoTotal,a.CPDEid, a.CPCmes, a.CPCano,a.CTDContAgr
		</cfquery>

		<cfif rsClasificacionConDistribucionAgr.recordcount GT 0>
		   	<cfloop query="rsClasificacionConDistribucionAgr">


			    <!--- Obtiene la distribucion --->
				<cfInvoke component="sif.Componentes.PRES_Distribucion" method="GenerarDistribucion"
					Ccodigo = "#rsClasificacionConDistribucionAgr.Ccodigo#"
					CPDCid ="#rsClasificacionConDistribucionAgr.CPDCid#"
					Tipo ="#rsClasificacionConDistribucionAgr.Tipoitem#"
					Aplica ="1"
					cantidad ="1"
                    Modulo="Contratos"
					monto ="#rsClasificacionConDistribucionAgr.Monto#"
					returnVariable="rsDistribucion">

					<cfquery name="rsMontoDistribuido" dbtype="query">
			             select sum(Monto) as Monto from rsDistribucion
			        </cfquery>

	                <cfset varMonto = #rsMontoDistribuido.Monto#>
					<cfset varMonto = varMonto * 100>
					<cfset varMonto = round(varMonto)>
					<cfset varMonto = varMonto/100>


			            <cfquery name="rsFinancieras" datasource="#session.DSN#">
	            			select * from CFinanciera
	                        where Ecodigo = #Arguments.EcodigoAlterno#
			            </cfquery>

			            <cfquery name="rsFinanciera" dbtype="query">
	            			select rsFinancieras.CPcuenta,rsDistribucion.monto, rsFinancieras.CFcuenta
							from rsFinancieras,rsDistribucion
	                        where rsFinancieras.CFcuenta = rsDistribucion.IDcuenta
	            		</cfquery>

			            <cfquery name="rsNAP" datasource="#session.DSN#">
			            	select CPNAPDlinea, CPcuenta,CPNAPnum from CPNAPdetalle
			                where CPNAPnum = #rsClasificacionConDistribucionAgr.NAP#
			                and CPCmes = #rsClasificacionConDistribucionAgr.Rsvmes#
			                and CPCano = #rsClasificacionConDistribucionAgr.Rsvano#
			            </cfquery>

						<cfquery name="rsLineas" dbtype="query">
							select rsFinanciera.CPcuenta,rsNAP.CPNAPnum,rsNAP.CPNAPDlinea ,rsFinanciera.monto,rsFinanciera.CFcuenta
					         from rsFinanciera, rsNAP
					         where rsFinanciera.CPcuenta = rsNAP.CPcuenta
						</cfquery>

						<cfquery name="rsLineasNAPs" dbtype="query">
							select * from rsLineas, rsDistribucion
				            where rsLineas.CFcuenta = rsDistribucion.IdCuenta
                            order by CFid
						</cfquery>

                         <cfset NumLinea = 0>
						<cfloop query="rsLineasNAPs">
                        	<cfset NumLinea = NumLinea + 1>
							<cfquery name="rs" datasource="#session.DSN#">
								insert into #request.intPresupuesto#(
									ModuloOrigen,
									NumeroDocumento,
									NumeroReferencia,
									FechaDocumento,
									AnoDocumento,
									MesDocumento,
									NumeroLinea,
									CPcuenta,
									Ocodigo,
									CodigoOficina,
									Mcodigo,
									MontoOrigen,
									TipoCambio,
									Monto,
									TipoMovimiento,
									NAPreferencia,
									LINreferencia,
                                    CPCmesP,
                                    CPCanoP)

								 values(
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsClasificacionConDistribucionAgr.ModuloOrigen#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsClasificacionConDistribucionAgr.NumeroDocumento#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsClasificacionConDistribucionAgr.NumeroReferencia#">,
									<cfqueryparam cfsqltype="cf_sql_date" value="#rsClasificacionConDistribucionAgr.FechaDocumento#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPeriodoAuxiliar.Pvalor#">,
									<cfif rsClasificacionConDistribucionAgr.Rsvmes LTE rsMesAuxiliar.Pvalor>
                                      <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsMesAuxiliar.Pvalor#">,
                                    <cfelse>
                                      <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsClasificacionConDistribucionAgr.Rsvmes#">,
                                    </cfif>
                                    ((#rsClasificacionConDistribucionAgr.CTDContAgr#*10000) + #NumLinea#)*-1,
									'#rsLineasNAPs.CPcuenta#',
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsClasificacionConDistribucionAgr.Ocodigo#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsClasificacionConDistribucionAgr.CodigoOficina#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsClasificacionConDistribucionAgr.Mcodigo#">,
									 -1*(#rsLineasNAPs.Monto#),
									1,
									 -1*(#rsLineasNAPs.Monto#),
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsClasificacionConDistribucionAgr.TipoMovimiento#">,
									#rsLineasNAPs.CPNAPnum#, 	<!---NAPreferencia--->
									#rsLineasNAPs.CPNAPDlinea#,  <!---LINreferencia--->
                                     <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsClasificacionConDistribucionAgr.Rsvmes#">,
                                 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsClasificacionConDistribucionAgr.Rsvano#">
									)
							</cfquery>
						</cfloop>

			</cfloop> <!--- rsLineasConDistribucion --->
		</cfif>

<!---Termina Cambio desreserva suficiencias agrupadas de clasificación con Distribución--->

		<cfquery name="rs" datasource="#session.DSN#">
			select count(*) as cantidad
		    from #request.intPresupuesto#
        </cfquery>


		<cfif rs.cantidad GT 0>
			<cfset LvarNAP = LobjControl.ControlPresupuestario(	'CTRC',
			                     data.CTCnumContrato,
			                     'Contrato',
			                     data.CTfecha,
			                     rsPeriodoAuxiliar.Pvalor,
			                     rsMesAuxiliar.Pvalor,
			session.DSN,
			Arguments.EcodigoAlterno,
			Momentos) >
		</cfif>


		<cfif LvarNAP GTE 0>
			<cfquery name="rsDatos" datasource="#session.DSN#">
				select CPcuenta,CPCano,CPCmes,Monto,NAPreferencia,LINreferencia,CPCanoP,CPCmesP from #request.intPresupuesto#
                where Monto < 0
            </cfquery>


         	<cfloop query="rsDatos">
	            <cfquery name="rsCPDocumentoD" datasource="#session.DSN#">
					select b.NAP,a.CPDEid,a.CPcuenta,a.CPCano,a.CPCmes,a.CPDDid
					from CPDocumentoD a
						inner join CPDocumentoE b
							on a.CPDEid = b.CPDEid
                        inner join CPNAPdetalle c
                        	on b.NAP = c.CPNAPnum
					where a.Ecodigo = #Arguments.EcodigoAlterno#
					and a.Ecodigo = b.Ecodigo
					and a.CPCmes = #rsDatos.CPCmesP#
					and a.CPCano = #rsDatos.CPCanoP#
					and b.NAP = #rsDatos.NAPreferencia#
					and a.CPcuenta = #rsDatos.CPcuenta#
                    and c.CPNAPDlinea = #rsDatos.LINreferencia#
				</cfquery>

				<!--- Actualiza saldo de la Suficiencia --->
				<cfquery datasource="#Session.DSN#">
					update CPDocumentoD
					   set CPDDsaldo = CPDDsaldo + #rsDatos.Monto#
					 where Ecodigo = #Arguments.EcodigoAlterno#
					   and CPCano = #rsCPDocumentoD.CPCano#
                       and CPCmes = #rsCPDocumentoD.CPCmes#
                       and CPcuenta = #rsCPDocumentoD.CPcuenta#
                       and CPDEid = #rsCPDocumentoD.CPDEid#
                       and CPDDid = #rsCPDocumentoD.CPDDid#

        		</cfquery>

        	</cfloop>

			<cfquery name="update" datasource="#session.DSN#">
				update CTContrato
				set NAP         = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarNAP#">
				where CTContid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCTContid#">
			</cfquery>
		</cfif>
		<cfreturn LvarNap>
	</cffunction>


	<cffunction name="fnValidaMontoContratoComprador" access="private" output="no" returntype="boolean">
		<cfargument name="CTContid" 	type="numeric">
		<cfargument name="CTCid" 		type="numeric">
        <cfargument name="Ecodigo" 		type="numeric" required="no">
        <cfargument name="EcodigoAlterno" type="numeric" required="no">

        <cfif not isdefined('Arguments.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
        <cfif not isdefined('Arguments.EcodigoAlterno')>
        	<cfset Arguments.EcodigoAlterno = Arguments.Ecodigo>
        </cfif>

		<cfquery datasource="#session.dsn#" name="Comprador">
			select cm.CTCMcodigo, cm.CTCmontomax
			from CTCompradores cm
			where cm.CTCid   = #Arguments.CTCid#
		</cfquery>

		<cfset LMonedaComprador = Comprador.CTCMcodigo>
		<cfset LMontoComprador = Comprador.CTCmontomax>
		<cfif LMonedaComprador NEQ GvarMcodigoLocal>
			<cfquery datasource="#session.dsn#" name="Htipocambio">
				select TCventa
				from Htipocambio
				where Mcodigo = #LMonedaComprador#
				  and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between Hfecha and Hfechah
			</cfquery>
			<cfif Htipocambio.RecordCount and len(Htipocambio.TCventa)>
				<cfset LTCventa = Htipocambio.TCventa>
			<cfelse>
				<cf_errorCode	code = "50310" msg = "No está definido el tipo de cambio para la moneda de compra del comprador para la fecha de hoy. Proceso Cancelado!">
			</cfif>
			<cfset LMontoComprador = LMontoComprador * LTCventa>
		</cfif>

		<!--- Monto 2: Monto del contrato en MONEDA LOCAL --->
		<cfquery datasource="#session.dsn#" name="EContrato">
			select round(CTtipoCambio * CTmonto,2) as MontoContrato
			from CTContrato
			where CTContid = #Arguments.CTContid#
		</cfquery>
		<cfset LMontoContrato = EContrato.MontoContrato>

		<!--- Comparación de Montos --->
		<cfif len(LMontoComprador) and LMontoContrato gt LMontoComprador>
        		<script language="javascript1.1">
      		    	alert("Usted excedió el monto máximo que tiene definido para comprar y el proceso de autorización del contrato fue rechazado. Proceso Cancelado!");
		       		window.location="../operacion/listaContratos.cfm";
		    	</script>
				<cfabort>
			<cfreturn false >
		</cfif>
		<cfreturn true>
	</cffunction>


	<cffunction name="update_CTContrato" access="public" output="no" returntype="void">
		<cfargument name="Ecodigo" 			default="#session.Ecodigo#" 	type="numeric">
		<cfargument name="CTContid" 		default="-1"  					type="numeric">
		<cfargument name="CTCnumContrato" 	default="-1"  					type="string">
		<cfargument name="CTmonto"			default="0"  					type="string">


		<cfquery name="update" datasource="#session.DSN#">
			update CTContrato
        	set CTmonto  		= #Arguments.CTmonto#
			where CTContid = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.CTContid#">
            and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.Ecodigo#">
		</cfquery>
	</cffunction>


	<cffunction name="insert_CTDetContrato" access="public" output="no" returntype="numeric">
		<cfargument name="Ecodigo" 			    required="no" 			    type="numeric">
        <cfargument name="CPCano" 				default=""  				type="string">
        <cfargument name="CPCmes" 				default=""  				type="string">
		<cfargument name="CTCnumContrato" 		default=""  				type="string">
		<cfargument name="CMtipo" 				default=""  				type="string">
		<cfargument name="Cid" 					default=""  				type="string">
   		<cfargument name="Tipocambio" 			default=""  				type="string">
		<cfargument name="Aid" 					default=""  				type="string">
		<cfargument name="Alm_Aid" 				default=""					type="string">
		<cfargument name="ACcodigo"				default=""					type="string">
		<cfargument name="ACid"					default=""  				type="string">
		<cfargument name="CTDCdescripcion"		default=""  				type="string">
		<cfargument name="DOpreciou"			default="0"			 		type="numeric">
		<cfargument name="DOfechaes"			default=""  				type="string">
		<cfargument name="CFid"					 							type="string">
		<cfargument name="Icodigo"				default=""  				type="string">
		<cfargument name="Ucodigo"				default=""  				type="string">
		<cfargument name="DOfechareq"			default=""  				type="string">
		<cfargument name="Ppais"				default=""  				type="string">
		<cfargument name="tipo"					default=""					type="string">
		<cfargument name="DOmontodesc"			default=""					type="string">
		<cfargument name="DOporcdesc"			default=""					type="string">
		<cfargument name="PCGDid"	     		default=""					type="string">
        <cfargument name="CPDDid"				default=""  				type="string">
        <cfargument name="CFComplemento"	    default="" 				    type="string"  hint="Complemento de la Actividad Empresarial">
   		<cfargument name="CPcuenta"				type="string">
		<cfargument name="CPDCid"				default=""				type="string">
        <cfargument name="Ccodigo"				default=""				type="string">
        <cfargument name="MontoOrigen"			default=""				type="numeric">
        <cfargument name="CPDEid"		     	default=""				type="numeric">
        <cfargument name="MontoSuficiencia"		default=""				type="numeric">


        <cfif NOT ISDEFINED('Arguments.Ecodigo') AND ISDEFINED('Session.Ecodigo')>
        	<cfset Arguments.Ecodigo = Session.Ecodigo>
        </cfif>
        <cfif LEN(TRIM(Arguments.DOfechareq))>
        	<cfset Arguments.DOfechareq = LSParseDateTime(Arguments.DOfechareq)>
        </cfif>


		<cfquery name="consecutivo" datasource="#session.DSN#">
			select max(CTDCconsecutivo) as linea
			from CTDetContrato
			where CTContid = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.CTContid#">
		</cfquery>
		<cfset dlinea = 1 >
		<cfif consecutivo.RecordCount gt 0 and len(trim(consecutivo.linea)) >
			<cfset dlinea = consecutivo.linea + 1>
		</cfif>
        <cfset Monto = (#Arguments.MontoOrigen#* #Arguments.Tipocambio#)>

		<cfquery name="insert" datasource="#session.DSN#">
			insert into CTDetContrato ( Ecodigo, CTContid, CTCnumero, CTDCconsecutivo,
								   CMtipo, Cid, Aid, Alm_Aid, ACcodigo, ACid, CTDCdescripcion, CTDCmontoTotal,
								   CFid,BMUsucodigo, CPDCid,CPDDid,CPCano,CPCmes,CPcuenta,CTDCmontoTotalOri,Ccodigo,CPDEid)
					 values (   <cf_jdbcquery_param cfsqltype="cf_sql_integer" 	value="#Arguments.Ecodigo#">,
								<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Replace(Arguments.CTContid,',','','all')#">,
								<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	value="#Replace(Arguments.CTCnumero,',','','all')#">,
								<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#dlinea#">,
								<cf_jdbcquery_param cfsqltype="cf_sql_char" 	value="#Arguments.CMtipo#">,
								<cfif Arguments.CMtipo eq "S" and ( len(trim(Arguments.Cid)) gt 0 and Arguments.Cid neq "-1")><cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Replace(Arguments.Cid,',','','all')#"><cfelse>null</cfif>,
								<cfif Arguments.CMtipo eq "A"><cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Replace(Arguments.Aid,',','','all')#"><cfelse>null</cfif>,
								<cfif Arguments.CMtipo eq "A"><cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Replace(Arguments.Alm_Aid,',','','all')#"><cfelse>null</cfif>,
								<cfif Arguments.CMtipo eq "F"><cf_jdbcquery_param cfsqltype="cf_sql_integer"	value="#Replace(Arguments.ACcodigo,',','','all')#"><cfelse>null</cfif>,
								<cfif Arguments.CMtipo eq "F"><cf_jdbcquery_param cfsqltype="cf_sql_integer"	value="#Replace(Arguments.ACid,',','','all')#"><cfelse>null</cfif>,
								<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	value="#Arguments.CTDCdescripcion#">,

                                 <cf_jdbcquery_param cfsqltype="cf_sql_money" 	value="#Arguments.MontoSuficiencia#">,

                                <cf_jdbcquery_param cfsqltype="cf_sql_numeric"			value="#Arguments.CFid#"  null="#trim(Arguments.CFid) EQ ''#">,
								<cf_jdbcquery_param cfsqltype="cf_sql_numeric"			value="#session.Usucodigo#" voidnull>,
                                <cf_jdbcquery_param cfsqltype="cf_sql_numeric"			value="#Arguments.CPDCid#"  null="#trim(Arguments.CPDCid) EQ ''#">,
                                <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.CPDDid#" null="#trim(Arguments.CPDDid) EQ ''  or trim(Arguments.CPDDid) EQ '-1' #" >,
                                <cf_jdbcquery_param cfsqltype="cf_sql_numeric"		value="#Arguments.CPCano#">,
                                <cf_jdbcquery_param cfsqltype="cf_sql_numeric"		value="#Arguments.CPCmes#">,
                                <cf_jdbcquery_param cfsqltype="cf_sql_numeric"		value="#Arguments.CPcuenta#" null="#trim(Arguments.CPcuenta) EQ ''#">,

                               #Arguments.MontoOrigen#,
                                <cf_jdbcquery_param cfsqltype="cf_sql_numeric"			value="#Arguments.Ccodigo#"  null="#trim(Arguments.Ccodigo) EQ ''#">,
                                <cf_jdbcquery_param cfsqltype="cf_sql_numeric"			value="#Arguments.CPDEid#">

                            )
                            <cf_dbidentity1 datasource="#session.DSN#">
		</cfquery>
							<cf_dbidentity2 datasource="#session.DSN#" name="insert">
		<cfreturn "#insert.identity#">
	</cffunction>


	<cffunction name="delete_LineaContrato" access="public" output="no" returntype="void">
		<cfargument name="Ecodigo" 				default="#session.Ecodigo#" type="numeric">
		<cfargument name="CTContid" 			default="-1"  				type="numeric">
		<cfargument name="CTDCont" 				default="-1"  				type="numeric">
		<!--- Elimina las lineas Agrupadas --->
		<cfquery name="rsCountAgr" datasource="#session.DSN#">
			select * from CTDetContratoAgr
			where CTContid  = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.CTContid#">
			  and IdAgrSuf  = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.CTDCont#">
		</cfquery>

        <cfif rsCountAgr.recordcount GTE 1>
	        <cfquery name="delete" datasource="#session.DSN#">
				delete from CTDetContratoAgr
				where CTContid  = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.CTContid#">
				  and IdAgrSuf  = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.CTDCont#">
			</cfquery>
       	</cfif>
		<!--- Elimina los detalles del contrato --->
		<cfquery name="delete" datasource="#session.DSN#">
			delete from CTDetContrato
			where CTContid  = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.CTContid#">
			  and CTDCont  = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.CTDCont#">
		</cfquery>
	</cffunction>

</cfcomponent>


