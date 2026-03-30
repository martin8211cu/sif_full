<!---------
	Creado por: Ana Villavicencio
	Fecha de modificación: 30 de junio del 2005
	Motivo:	Nueva opción para Módulo de Tesorería, 
			Entrega de cheques
----------->

<cfif IsDefined("form.Entrega")>
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select cf.TESCFDnumFormulario, TESOPid
		  from TEScontrolFormulariosD cf
		 where cf.TESCFDnumFormulario  = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.TESCFDnumformulario#">
		   and cf.TESid 			   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
		   and cf.CBid				   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
		   and cf.TESMPcodigo		   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESMPcodigo#">
		   and cf.TESCFDestado = 1
	</cfquery>
	<cfif rsSQL.recordcount EQ 0>
		<cf_errorCode	code = "50761"
						msg  = "No se puede entregar el Cheque @errorDat_1@ porque no está en estado Impreso"
						errorDat_1="#form.TESCFDnumformulario#"
		>
	</cfif>
    <cfset LvarTESOPid = rsSQL.TESOPid>
    <cfquery name="rsOP" datasource="#session.DSN#">
        select TESOPestado,TESOPnumero
          from TESordenPago
         where TESid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
           and TESOPid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSQL.TESOPid#">
    </cfquery>
    <cfset LvarTESOPid = rsSQL.TESOPid>
    <cfset LvarTESOPnumero = rsOP.TESOPnumero>    
	<cftransaction>
		<cfquery datasource="#session.dsn#">
			update TEScontrolFormulariosD
				set TESCFDestado = 2,

					TESCFDentregadoId = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESCFDentregadoId#">,
					TESCFDentregado   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESCFDentregado#">,
					TESCFDentregadoFecha = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.fechaEntrega)#">,

					TESCFDfechaEntrega = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					UsucodigoEntrega = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			 where TESCFDnumFormulario = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.TESCFDnumformulario#">
			   and TESid 			   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
			   and CBid				   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
			   and TESMPcodigo		   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESMPcodigo#">
		</cfquery>
        
        <!---
			Contabiliza la entrega de los cheques que no se han contabilizado:
			se supone que parametro=5001 Contabilizar en la Entrega esta prendido
		--->
		<cfif rsOP.TESOPestado EQ 110>
			<cfquery datasource="#session.dsn#">
				update TESordenPago
				   set TESOPfechaPago = <cf_dbfunction name="today">
				 where TESOPid = #LvarTESOPid#
			</cfquery>	
            <cfinvoke 	component="sif.tesoreria.Componentes.TESaplicacion" 
                        method="sbAplicarOrdenPago">
                <cfinvokeargument name="TESOPid"		value="#LvarTESOPid#"/>
            </cfinvoke>
		<cfelseif rsOP.TESOPestado NEQ 12>
        	<cfthrow message="La OP num. #LvarTESOPnumero# no está emitida">
		</cfif>        
        
		<!--- ACTUALIZA LOS REGISTROS DEL FORMULARIO EN LA BITACORA DE FORMULARIOS --->
		<cfquery datasource="#session.DSN#">
			update TEScontrolFormulariosB
			   set TESCFBultimo = 0
			where TESid				   = #session.Tesoreria.TESid#
			   and CBid				   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
			   and TESMPcodigo		   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESMPcodigo#">
			   and TESCFDnumFormulario = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFDnumFormulario#">
		</cfquery>
		<!--- INSERTA UN REGISTRO CON LE MOVIMIENTO REALIZADO EN LA BITACORA DE FORMULARIOS --->	
		<cfset LvarObservacion = "ENTREGADO A: #form.TESCFDentregadoId# : #form.TESCFDentregado#, el #form.fechaEntrega#">
		<cfquery datasource="#session.dsn#">
			insert into TEScontrolFormulariosB
				(
					TESid, CBid, TESMPcodigo,TESCFDnumFormulario, 
					TESCFBfecha, TESCFEid, TESCFLUid, TESCFBultimo, UsucodigoCustodio, TESCFBfechaGenera, UsucodigoGenera, BMUsucodigo
					, TESCFBobservacion
				)
			select 	 TESid, CBid, TESMPcodigo,TESCFDnumFormulario
					,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					,(select min(TESCFEid) from TESCFestados where TESid = #session.Tesoreria.TESid# and TESCFEentregado = 1)
					,NULL
					,1
					,<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
					,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					,<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
					,<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
					,<cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarObservacion#">
			  from TEScontrolFormulariosD
			 where TESid			   = #session.Tesoreria.TESid#
			   and CBid				   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
			   and TESMPcodigo		   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESMPcodigo#">
			   and TESCFDnumFormulario = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFDnumFormulario#">
		</cfquery>
	</cftransaction>
	<cfif isdefined('form.custodia')>
		<cflocation url="entregaChequesCustodia.cfm">
	<cfelse>
		<cflocation url="entregaCheques.cfm">
	</cfif>
<cfelseif IsDefined("form.Devolver")>
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select 	cf.TESCFDentregadoId,
				cf.TESCFDentregado,
				cf.TESCFDfechaEntrega,
				cfb.TESCFBobservacion,
				cbp.Ecodigo as EcodigoPago,
				cbp.CBid as CBidPago,
                cf.TESOPid
		  from TEScontrolFormulariosD cf
			inner join CuentasBancos cbp
			   on cbp.CBid = cf.CBid
			left join TEScontrolFormulariosB cfb
			   on cfb.TESid				   	= cf.TESid
			  and cfb.CBid				   	= cf.CBid
			  and cfb.TESMPcodigo		   	= cf.TESMPcodigo
			  and cfb.TESCFDnumFormulario 	= cf.TESCFDnumFormulario
			  and cfb.TESCFBultimo = 1
		 where cf.TESCFDnumFormulario  = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.TESCFDnumformulario#">
           and cbp.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">			
		   and cf.TESid 			   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
		   and cf.CBid				   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
		   and cf.TESMPcodigo		   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESMPcodigo#">
		   and cf.TESCFDestado = 2
	</cfquery>
    <cfset LvarTESOPid = rsSQL.TESOPid>
    <cfquery name="rsOP" datasource="#session.DSN#">
        select TESOPestado
          from TESordenPago
         where TESid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
           and TESOPid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSQL.TESOPid#">
    </cfquery>
	<cfif rsSQL.recordcount EQ 0>
		<cf_errorCode	code = "50762"
						msg  = "No se puede devolver el Cheque @errorDat_1@ porque no está en estado Entregado"
						errorDat_1="#form.TESCFDnumformulario#"
		>
	</cfif>
	<cfquery name="rsLibros" datasource="#session.dsn#">
		select MLconciliado
		  from MLibros 
		 where MLdocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESCFDnumFormulario#">
		   and BTid	= (select BTid from BTransacciones where Ecodigo=#rsSQL.EcodigoPago# and BTcodigo = 'PC')
		   and CBid = #rsSQL.CBidPago#
	</cfquery>
	<cfif rsLibros.MLconciliado EQ "S">
		<cf_errorCode	code = "50763"
						msg  = "No se puede devolver el Cheque @errorDat_1@ porque ya está Conciliado en Libros Bancarios"
						errorDat_1="#form.TESCFDnumformulario#"
		>
	</cfif>
	<cftransaction>
		<cfquery datasource="#session.dsn#">
			update TEScontrolFormulariosD
				set TESCFDestado = 1,
					TESCFDentregadoId = null,
					TESCFDentregado   = null,
					TESCFDfechaEntrega = null,
					TESCFDentregadoFecha = null,
					UsucodigoEntrega = null
			 where TESCFDnumFormulario = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.TESCFDnumformulario#">
			   and TESid 			   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
			   and CBid				   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
			   and TESMPcodigo		   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESMPcodigo#">
		</cfquery>
		<!--- ACTUALIZA LOS REGISTROS DEL FORMULARIO EN LA BITACORA DE FORMULARIOS --->
		<cfquery datasource="#session.DSN#">
			update TEScontrolFormulariosB
			   set TESCFBultimo = 0
			where TESid				   = #session.Tesoreria.TESid#
			   and CBid				   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
			   and TESMPcodigo		   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESMPcodigo#">
			   and TESCFDnumFormulario = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFDnumFormulario#">
		</cfquery>
		<!--- INSERTA UN REGISTRO CON LE MOVIMIENTO REALIZADO EN LA BITACORA DE FORMULARIOS --->	
		<cfset LvarObservacion = "DEVOLUCION DE ENTREGA POR: #form.TESCFBobservacion#">
		<cfif rsSQL.TESCFBobservacion EQ "">
			<cfset LvarObservacion = LvarObservacion & chr(13) & chr(10) & 
					"(fue entregado a: #rsSQL.TESCFDentregadoId# #rsSQL.TESCFDentregadoId# el #DateFormat(rsSQL.TESCFDentregadoFecha,"DD/MM/YYYY")#)">
		</cfif>
		<cfquery datasource="#session.dsn#">
			insert into TEScontrolFormulariosB
				(
					TESid, CBid, TESMPcodigo,TESCFDnumFormulario, 
					TESCFBfecha, TESCFEid, TESCFLUid, TESCFBultimo, UsucodigoCustodio, TESCFBfechaGenera, UsucodigoGenera, BMUsucodigo
					, TESCFBobservacion
				)
			select 	 TESid, CBid, TESMPcodigo,TESCFDnumFormulario
					,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					,(select max(TESCFEid) from TESCFestados where TESid = #session.Tesoreria.TESid# and TESCFEentregado = 1)
					,NULL
					,1
					,<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
					,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					,<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
					,<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
					,<cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarObservacion#">
			  from TEScontrolFormulariosD
			 where TESid			   = #session.Tesoreria.TESid#
			   and CBid				   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
			   and TESMPcodigo		   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESMPcodigo#">
			   and TESCFDnumFormulario = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFDnumFormulario#">
		</cfquery>

        <!----Contabiliza la entrega de los cheques segun parametro 5001--->
		<cfquery datasource="#session.dsn#" name="rsContabiliza">
            Select Pvalor 
              from Parametros 
             where Ecodigo = #Session.Ecodigo#
               and Pcodigo = 5001
		</cfquery>  
		<cfset ContabilizarEntrega = (rtrim(rsContabiliza.Pvalor) EQ '1')>
            
		<cfif ContabilizarEntrega>
            <cfinvoke 	component="sif.tesoreria.Componentes.TESaplicacion" 
                        method="sbReversarOrdenPago">
                <cfinvokeargument name="TESOPid" value="#LvarTESOPid#"/>
				<cfinvokeargument name="AnularOP"	value="no"/>
            </cfinvoke>
		</cfif>        
	</cftransaction>
	<cflocation url="entregaChequesDevolver.cfm">
</cfif>


