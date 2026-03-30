<!---------
	Creado por: Ana Villavicencio
	Fecha de modificación: 01 de junio del 2005
	Motivo:	Nueva opción para Módulo de Tesorería, 
			Rechazo de Solicitudes de Pago en Tesorería
----------->

<cfif IsDefined("form.Pasar")>
	<cfinclude template="../../Utiles/sifConcat.cfm">
	<cftransaction>
		<cfquery name="rsSP" datasource="#session.dsn#">
			select 	sp.TESSPnumero
			     , 	sp.TESSPestado
			     , 	sp.TESOPid
				 , 	case sp.TESSPestado
						when  0 then 'En Preparación'
						when  1 then 'En Aprobación'
						when  2 then 'Aprobada'
						when  3 then 'Rechazada'
						when 23 then 'Rechazada Tesorería'
						when 10 then 'Preparando OP=' #_Cat# <cf_dbfunction name="to_char" args="op.TESOPnumero">
						when 11 then 'Emitiendo OP=' #_Cat# <cf_dbfunction name="to_char" args="op.TESOPnumero">
                        when 110 then 'Sin Aplicar OP=' #_Cat# <cf_dbfunction name="to_char" args="op.TESOPnumero"> 
						when 12 then 'Pagada en OP=' #_Cat# <cf_dbfunction name="to_char" args="op.TESOPnumero">
						when 13 then 'Anulada en OP=' #_Cat# <cf_dbfunction name="to_char" args="op.TESOPnumero">
						when 101 then 'Aprobando OP=' #_Cat# <cf_dbfunction name="to_char" args="op.TESOPnumero">
						when 103 then 'Rechazada en OP=' #_Cat# <cf_dbfunction name="to_char" args="op.TESOPnumero">
						else 'Estado desconocido'
				   	end as ESTADO
				 , op.TESOPnumero,  case when op.TESOPmsgRechazo is null then 0 else 1 end as TESOPemitida
			  from TESsolicitudPago sp
			  		left join TESordenPago op
						on op.TESOPid = sp.TESOPid
			 where sp.TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#">
			   and sp.TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
		</cfquery>
		<cfif rsSP.recordCount EQ 0>
			<cf_errorCode	code = "50754"
							msg  = "La Solicitud de Pago ID. [@errorDat_1@] no existe"
							errorDat_1="#form.TESSPid#"
			>
		</cfif>
		<cfif not listfind("2,10", rsSP.TESSPestado)>
			<cf_errorCode	code = "50755"
							msg  = "La Solicitud de Pago Num. '@errorDat_1@' está en estado '@errorDat_2@' y no puede ser pasada de Tesorería"
							errorDat_1="#rsSP.TESSPnumero#"
							errorDat_2="#rsSP.ESTADO#"
			>
		</cfif>

		<cfif rsSP.TESOPemitida EQ 1>
			<cfthrow message="La Orden de Pago Num. '#rsSP.TESOPnumero#' ya ha sido emitida, por tanto la Solicitud de Pago Num. '#rsSP.TESSPnumero#' no puede ser pasada de Tesorería">
		</cfif>

		<cfquery datasource="#session.dsn#">
			update TESsolicitudPago 
			   set TESSPestado 	= 2	
			     , TESid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCambioTESid#">
				 , TESOPid	 		= null
				 , CBid	 			= null
				 , TESMPcodigo	 	= null
				 , SNid	 			= null
				 , EcodigoSP	 	= null
				 , TESOPfechaPago	= null
			 where TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#">
			   and TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
		</cfquery>
		<cfquery datasource="#session.dsn#">
			update TESdetallePago 
			   set TESDPestado  = 2
			     , TESid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCambioTESid#">
				 , TESOPid 					= null
				 , TESDPfechaPago 			= null
				 , EcodigoPago				= null
				 , TESDPmontoAprobadoLocal	= null
				 , TESDPtipoCambioOri		= null
				 , TESDPfactorConversion	= null
				 , TESDPmontoPago			= null
				 , TESDPmontoPagoLocal 		= null
			 where TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#">
			   and TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
		</cfquery>

		<cfif rsSP.TESSPestado EQ "10">
			<cfquery datasource="#session.dsn#" name="rsSQL">
				select count(1) as cantidadOP
				  from TESsolicitudPago
				 where TESOPid	= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsSP.TESOPid#">
				   and TESid	= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
			</cfquery>
			<cfif rsSQL.cantidadOP EQ 0>
				<cfquery name="rsSQL" datasource="#session.dsn#">
					select
						{fn concat({fn concat(t.TEScodigo, ' - ')}, t.TESdescripcion)} as TESdescripcion, 
						adm.Edescripcion as ADMdescripcion
					  from Tesoreria t
						inner join Empresas adm
							on adm.Ecodigo = t.EcodigoAdm
					 where t.TESid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCambioTESid#">
				</cfquery>
	
				<cfquery datasource="#session.dsn#">
					update TESordenPago 
					   set  TESOPestado 			= 13	/* TESOPestado = 13:  Anulado */
						  , TESOPmsgRechazo			= <cfqueryparam cfsqltype="cf_sql_varchar" value="SP.Num. #rsSP.TESSPnumero# CAMBIADA A TESORERÍA: #rsSQL.TESdescripcion# (Adm: #rsSQL.ADMdescripcion#)">
						  , TESOPfechaCancelacion	= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
						  , UsucodigoCancelacion	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
					 where TESOPid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSP.TESOPid#">
					   and TESid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
				</cfquery>
			</cfif>
		</cfif>
	</cftransaction>
</cfif>
<cflocation url="solicitudesPasar.cfm">


