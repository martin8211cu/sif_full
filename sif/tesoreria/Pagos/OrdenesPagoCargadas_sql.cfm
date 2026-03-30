<!--- SE CONSULTAN LOS DATOS QUE SE CARGARON EN EL IMPORTADOR --->
<cfquery name="rsDatos" datasource="#session.dsn#">
	select
		NoOrdPago,
		FecGenManual,
		FecPago,
		Referencia
	from
		TESDatosOPImportador
	where IdTransaccion = '#session.idTransaccion#'
</cfquery>

<cfquery name="miTesoreria" datasource="#session.dsn#">
	select TESid,TEScodigo,TESdescripcion,Edescripcion
	from Tesoreria t
		inner join Empresas e
			on e.Ecodigo=t.EcodigoAdm
	WHERE t.CEcodigo  = #session.CEcodigo# and e.Ecodigo = #session.Ecodigo#
</cfquery>

<cfset session.Tesoreria.TESid = miTesoreria.TESid>
<!--- SE ITERA LA TABLA DE LOS DATOS QUE SE IMPORTARON --->
<cfset lineNumber = 0>
<cfset listErrores = 0>
<cfset idTrasnf = 0>

<!---
  --- Tabla temporal para guardar los estados (TESOPestado,TESSPestado,TESDPestado)
  --- y fechas de Emision y Pago de la OP en caso de que ocurra un error
--->
<cf_dbtemp name="tblTemp" returnvariable="tblTemp" datasource="#session.dsn#">
	<!--- Estado de idOP --->
    <cf_dbtempcol name="IdOP"           type="numeric"      mandatory="no">
	<!--- Estado de TESordenPago --->
    <cf_dbtempcol name="Estado1"           type="numeric"      mandatory="no">
	<!--- Estado de TESsolicitudPago --->
    <cf_dbtempcol name="Estado2"           type="numeric"      mandatory="no">
	<!--- Estado de TESdetallePago --->
    <cf_dbtempcol name="Estado3"           type="numeric"      mandatory="no">
	<!--- Fecha Emision OP --->
	<cf_dbtempcol name="FechaE"           type="date"      mandatory="no">
	<!--- Fecha Pago OP --->
	<cf_dbtempcol name="FechaP"           type="date"      mandatory="no">
 </cf_dbtemp>
<cfset count = 1>
<cfloop query="rsDatos">


	<cftry>
		<cftransaction action="begin">
		<cfquery name="codigoOP" datasource="#session.dsn#">
			select TESMPcodigo
			from TESordenPago
			where TESMPcodigo is not null
			and TESMPcodigo != ''
			and TESOPnumero = #rsDatos.NoOrdPago#
		</cfquery>

		<cfif codigoOP.RecordCount eq 0>
			<cfquery datasource="#session.dsn#">
				update TESordenPago set TESMPcodigo = 'CC-TRM' WHERE TESOPnumero = #rsDatos.NoOrdPago#
			</cfquery>
		</cfif>

		<cfquery name="rsCampos" datasource="#session.dsn#">
			select
				mp.TESTMPtipo,
				coalesce(mp.TESMPcodigo,'') as TESMPcodigo,
				op.TESOPid,
				op.CBidPago
			from TESordenPago op
			left join TESmedioPago mp on op.TESMPcodigo = mp.TESMPcodigo
			where op.TESOPnumero = #rsDatos.NoOrdPago#
			and op.TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
		</cfquery>

		<!--- Select del primer update dentro del catch --->
		<cfquery name="update1" datasource="#session.dsn#">
				select
					TESOPestado,
					TESOPfechaEmision,
					UsucodigoEmision,
					TESOPfechaPago,
					TESTDid
				from
					TESordenPago
				where TESid = #session.Tesoreria.TESid#
				and TESOPid = #rsCampos.TESOPid#
				<!--- and TESOPestado = 110 --->
			</cfquery>

			<!--- Select del segundo update dentro del catch --->
			<cfquery name="update2" datasource="#session.dsn#">
				select
					TESSPestado
				from
					TESsolicitudPago
				where TESid = #session.Tesoreria.TESid#
				and TESOPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCampos.TESOPid#">
				<!--- and TESSPestado in 110 --->
			</cfquery>

			<!--- Select del tercer update dentro del catch --->
			<cfquery name="update3" datasource="#session.dsn#">
				select TESDPestado
				from TESdetallePago
				where TESid = #session.Tesoreria.TESid#
				and TESOPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCampos.TESOPid#">
				<!--- and TESDPestado = 110 --->
			</cfquery>

			<cfif update2.recordCount eq 0>

				<cfquery datasource="#session.dsn#">
					INSERT INTO #tblTemp# (IdOP, Estado1, Estado2, Estado3,FechaE,FechaP)
					VALUES
				    (
				    	<cfqueryparam cfsqltype="cf_sql_numeric"   value="#rsCampos.TESOPid#">,
				    	<cfqueryparam cfsqltype="cf_sql_numeric"   value="#update1.TESOPestado#">,
				    	<cfqueryparam cfsqltype="cf_sql_numeric"   value="#update1.TESOPestado#">,
				    	<cfqueryparam cfsqltype="cf_sql_numeric"   value="#update1.TESOPestado#">,
				    	<cfqueryparam cfsqltype="cf_sql_date"   value="#update1.TESOPfechaEmision#">,
				    	<cfqueryparam cfsqltype="cf_sql_date"   value="#update1.TESOPfechaPago#">
				    )
				</cfquery>

				<cftransaction action="commit">
				<cfset quote = "'">
				<cfset salto1 = '<BR>'>
				<cfset salto2 = "<br>">
				<cfset message1 = replace('La orden de pago #rsDatos.NoOrdPago# no tiene una solicitud asociada',quote," ","all")>
				<cfset message2 = replace(message1,salto1," ","all")>
				<cfset message3 = replace(message2,salto2," ","all")>
				<cfsetting requesttimeout="5500">
				<cfoutput>#ReverseAndInsertError(tipo = 1,mensajeE = message3,rsCampos = rsCampos)#</cfoutput>
				<cfcontinue>
			<cfelse>
				<cfquery datasource="#session.dsn#">
					INSERT INTO #tblTemp# (IdOP, Estado1, Estado2, Estado3,FechaE,FechaP)
					VALUES
				    (
				    	<cfqueryparam cfsqltype="cf_sql_numeric"   value="#rsCampos.TESOPid#">,
				    	<cfqueryparam cfsqltype="cf_sql_numeric"   value="#update1.TESOPestado#">,
				    	<cfqueryparam cfsqltype="cf_sql_numeric"   value="#update2.TESSPestado#">,
				    	<cfqueryparam cfsqltype="cf_sql_numeric"   value="#update3.TESDPestado#">,
				    	<cfqueryparam cfsqltype="cf_sql_date"   value="#update1.TESOPfechaEmision#">,
				    	<cfqueryparam cfsqltype="cf_sql_date"   value="#update1.TESOPfechaPago#">
				    )
				</cfquery>
			</cfif>

		<cftransaction action="begin">
			<cfset lineNumber++>
			<cfquery name="insert" datasource="#session.dsn#">
				insert into TEStransferenciasD
					(
					 TESid
					,CBid
					,TESMPcodigo
					,TESOPid
					,TESTLid
					,TESTDreferencia
					,TESTDestado
					,UsucodigoEmision
					,TESTDfechaEmision
					,TESTDfechaGeneracion
					,BMUsucodigo
					)
				values
					(
					 #session.Tesoreria.TESid#
					,<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCampos.CBidPago#">
					,<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCampos.TESMPcodigo#">
					,<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCampos.TESOPid#">
					,NULL
					,<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatos.Referencia#">
					,1	/* Impreso o generado o manual (Registrado) */
					,#session.Usucodigo#
					,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> 	<!--- TESTDfechaEmision --->
					,<cfqueryparam cfsqltype="cf_sql_date" 		value="#LSParseDateTime(rsDatos.FecGenManual)#">
					,#session.Usucodigo#
					)
				<cf_dbidentity1 datasource="#session.DSN#">
				</cfquery>
			<cf_dbidentity2 datasource="#session.DSN#" name="insert" returnvariable="LvarTESTDid">
			<cfset idTrasnf = LvarTESTDid>
			<cfquery datasource="#session.dsn#">
				update TESordenPago
					set  TESOPestado  = 110
						,TESOPfechaEmision = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
						,UsucodigoEmision  = #session.Usucodigo#
						,TESOPfechaPago = <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(rsDatos.FecPago)#">
						,TESTDid = #LvarTESTDid#
				 where TESid = #session.Tesoreria.TESid#
				   and TESOPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCampos.TESOPid#">
				   and TESOPestado in (10,11)
			</cfquery>
			<cfquery datasource="#session.dsn#">
				update TESsolicitudPago
					set TESSPestado  = 110
				 where TESid = #session.Tesoreria.TESid#
				   and TESOPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCampos.TESOPid#">
				   and TESSPestado in (10,11)
			</cfquery>
			<cfquery datasource="#session.dsn#">
				update TESdetallePago
					set TESDPestado  = 110
				 where TESid = #session.Tesoreria.TESid#
				   and TESOPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCampos.TESOPid#">
				   and TESDPestado in (10,11)
			</cfquery>

			<cfset Contabilizar = true>
			<cfif rsCampos.TESTMPtipo EQ 1>
				<!----Contabiliza la entrega de los cheques segun parametro 5001--->
				<cfquery datasource="#session.dsn#" name="rsContabiliza">
					Select Pvalor
					  from Parametros
					 where Ecodigo = #Session.Ecodigo#
					   and Pcodigo = 5001
				</cfquery>
				<cfset ContabilizarEntrega = (trim(rsContabiliza.Pvalor) EQ '1')>
				<cfif ContabilizarEntrega>
					<cfif isdefined("Form.chkEntrega")>
						<cfset Contabilizar = true>
						<cfquery datasource="#session.dsn#">
							update TESordenPago
							   set TESOPfechaPago = <cf_dbfunction name="today">
							 where TESOPid = #rsCampos.TESOPid#
						</cfquery>
					<cfelse>
						<cfset Contabilizar = false>
					</cfif>
				</cfif>
	        </cfif>

			<cfif Contabilizar>
	            <cfinvoke component="sif.tesoreria.Componentes.TESaplicacion"
	                        method="sbAplicarOrdenPago">
	                <cfinvokeargument name="TESOPid" value="#rsCampos.TESOPid#"/>
	            </cfinvoke>
	        </cfif>
		<cftransaction action="commit">

	<cfcatch type="ErrorCode">
		<cftransaction action="commit">
		<cfset quote = "'">
		<cfset salto1 = '<BR>'>
		<cfset salto2 = "<br>">
		<cfset message1 = replace(cfcatch.message,quote," ","all")>
		<cfset message2 = replace(message1,salto1," ","all")>
		<cfset message3 = replace(message2,salto2," ","all")>
		<cfsetting requesttimeout="5500">
		<cfoutput>#ReverseAndInsertError(tipo = 1,mensajeE = message3,rsCampos = rsCampos)#</cfoutput>
		<cfset count++>

	</cfcatch>
	<cfcatch type="application">
		<cftransaction action="commit">
		<cfset quote = "'">
		<cfset salto1 = '<BR>'>
		<cfset salto2 = "<br>">
		<cfset message1 = replace(cfcatch.Message,quote," ","all")>
		<cfset message2 = replace(message1,salto1," ","all")>
		<cfset message3 = replace(message2,salto2," ","all")>
		<cfsetting requesttimeout="5500">
		<cfoutput>#ReverseAndInsertError(tipo = 1,mensajeE = message3, rsCampos = rsCampos)#</cfoutput>

	</cfcatch>
	<cfcatch type="any">

		<cftransaction action="commit">
		<cfset message3 = "Ocurrio un error al aplicar la Orden de Pago: " & rsDatos.NoOrdPago >
		<cfdump var="#cfcatch.Detail#">
		<cfdump var="#cfcatch.Message#">
		<cfsetting requesttimeout="5500">
		<cfoutput>#ReverseAndInsertError(tipo = 3,mensajeE = message3, rsCampos = rsCampos )#</cfoutput>

	</cfcatch>
	</cftry>
	<cftransaction action="commit">

</cfloop>

<cffunction access="public" name="ReverseAndInsertError" output="false" >
	<cfargument type="numeric" name="tipo" default="0">
	<cfargument type="string" name="mensajeE" default="">
	<cfargument type="query" name="rsCampos">

	<cfquery name="rsAnterior" datasource="#session.dsn#">
		select IdOP, Estado1, Estado2, Estado3,FechaE,FechaP
		from #tblTemp#
		where IdOP = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCampos.TESOPid#">
	</cfquery>
	<cfquery name="update3" datasource="#session.dsn#">
		select TESDPestado
		from TESdetallePago
		where TESid = #session.Tesoreria.TESid#
		and TESOPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCampos.TESOPid#">
		<!--- and TESDPestado = 110 --->
	</cfquery>
	<cfquery name="update2" datasource="#session.dsn#">
		select
			TESSPestado
		from
			TESsolicitudPago
		where TESid = #session.Tesoreria.TESid#
		and TESOPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCampos.TESOPid#">
		<!--- and TESSPestado in 110 --->
	</cfquery>
	<cfquery name="update1" datasource="#session.dsn#">
		select
			TESOPestado,
			TESOPfechaEmision,
			UsucodigoEmision,
			TESOPfechaPago,
			TESTDid
		from
			TESordenPago
		where TESid = #session.Tesoreria.TESid#
		and TESOPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCampos.TESOPid#">
		<!--- and TESOPestado = 110 --->
	</cfquery>
	<cfquery datasource="#session.DSN#">
			update TEStransferenciasD
			   set TESTDestado = 3, <!--- ANULADA --->
				   TESTDmsgAnulacion 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="Anulacion desde Importador OP">,
				   UsucodigoAnulacion 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				   TESTDfechaAnulacion	= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
			 where TESid				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
			   and CBid					= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCampos.CBidPago#">
			   and TESMPcodigo			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCampos.TESMPcodigo#">
			   and TESTDid				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#idTrasnf#">
			   and TESOPid 			   	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCampos.TESOPid#">
	</cfquery>
	<cfquery datasource="#session.dsn#">
		update TESordenPago
			set  TESOPestado  = #rsAnterior.Estado1#
				,TESOPfechaEmision = <cfqueryparam cfsqltype="cf_sql_date" value="#update1.TESOPfechaEmision#" null="true">
				,UsucodigoEmision  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#update1.UsucodigoEmision#" null="true">
				,TESOPfechaPago = <cfqueryparam cfsqltype="cf_sql_date" value="#update1.TESOPfechaPago#" null="false">
				,TESTDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#update1.TESTDid#" null="true">
		 where TESid = #session.Tesoreria.TESid#
		   and TESOPid = #rsAnterior.IdOP#
		   and TESOPestado = 110
	</cfquery>
	<cfquery datasource="#session.dsn#">
		update TESsolicitudPago
			set TESSPestado  = #rsAnterior.Estado2#
		 where TESid = #session.Tesoreria.TESid#
		   and TESOPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCampos.TESOPid#">
		   and TESSPestado = 110
	</cfquery>
	<cfquery datasource="#session.dsn#">
		update TESdetallePago
			set TESDPestado  = #rsAnterior.Estado3#
		 where TESid = #session.Tesoreria.TESid#
		   and TESOPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCampos.TESOPid#">
		   and TESDPestado = 110
	</cfquery>
	<cfquery name="eii" datasource="sifcontrol">
		select ib.IBid, ib.IBhash from IBitacora ib
		where ib.IBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.IdBitacora#">
	</cfquery>
	<cfquery datasource="sifcontrol">
          insert into IErrores (IBid, IEid, IBdatos, IBlinea, IBerror, IBcolumna)
          values (#eii.IBid#,
                  #lineNumber#,
                 	'#mensajeE#',
                  #lineNumber#,
                  11,
                  0
              )
      </cfquery>
	<cfset session.HashB = eii.IBhash>


</cffunction>

<!--- <cflocation url="importadorOrdenesPago.cfm"> --->