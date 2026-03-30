<!--- 
	Interfaces desde SOIN hacia BN Valores.
	Interfaz 150 : "Orden de Pago"
	Entradas :
		ID : ID del Proceso a crear.
		TESOPid : PK de EDocumentosRecepcion.
		MODO : Accin a realizar.
	Salidas :
		1 Registro en la Tabla IE150 : Datos del Encabezado de la Recepcin (TESOPid).
--->

<!--- instancia componente de interfaces --->
<cfobject name="interfaz" component="interfacesSoin.Componentes.interfaces">

<cfset interfaz.sbReportarActividad(150, url.ID)>

<!--- Parmetros Requeridos --->

<cfparam name="url.ID" type="numeric">
<cfparam name="url.TESOPid" type="numeric">

<!--- Valida Parmetros de entrada --->
<cfquery name="rsid_vexists" datasource="sifinterfaces">
	select 1 
	from IE150
	where ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ID#">
</cfquery>
<cfif rsid_vexists.Recordcount GT 0>
	<!--- (Intento de Reprocesar) --->
	<cfthrow message="Error en interfaz BN Valores 150, Registro de Orden de Pago, EL proceso ya fu ejecutado anteriormente, Proceso Cancelado!">
</cfif>

<cfquery name="rsedr_vexists" datasource="#Session.Dsn#">
	select 1 
	from TESOrdenPago
	where TESOPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.TESOPid#">
	  <!---and EDRestado = 10 ---> <!--- Solo si ya fue aplicada --->
</cfquery>
<cfif rsedr_vexists.Recordcount EQ 0>
	<!--- (Error de datos en la Cola) --->
	<cfthrow message="Error en interfaz BN Valores 150, Registro de Orden de Pago, Codigo de Orden no est definido, Proceso Cancelado!">
</cfif>

<cfquery name="rs" datasource="#Session.Dsn#">
	select  TESOPid as idpago,
			( select min(TEScodigo) from Tesoreria where TESid = op.TESid ) as tesoreria,			
			TESOPnumero as ordenPago,
			op.TESOPfechaPago as FechaPagoSolicitada,
			substr(op.TESOPbeneficiario || ' ' || op.TESOPbeneficiarioSuf, 1, 100) as beneficiario,
			Miso4217Pago as moneda,
			TESOPtotalPago as monto,
			substr(op.TESOPobservaciones,1,255) as observaciones,			
			( select substr(b.Bcodigocli, 1, 50)
			  from CuentasBancos cb, Bancos b
			  where cb.Cbid = op.CBidPago
              	and cb.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
			    and cb.Bid = b.Bid ) as banco,
			( select substr(cb.CBcodigo, 1, 50)
			  from CuentasBancos cb, Bancos b
			  where cb.Cbid = op.CBidPago
              	and cb.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
			    and cb.Bid = b.Bid ) as cuentaBancaria,
			( select min(substr(b.TESTMPdescripcion, 1, 3))  
			  from TESMedioPago a, TESTipoMedioPago b
			  where b.TESTMPtipo = a.TESTMPtipo
			  and a.CBid = op.CBidPago
			  and a.TESid = op.TESid
			  and a.TESMPcodigo = op.TESMPcodigo ) as TipoMedioPago,
			TESOPinstruccion as instruccionbanco,
			TESOPfechaGeneracion as fechaAutorizacion,
			(select Usulogin from Usuario where usucodigo = op.UsucodigoGenera ) as usuario,			
			( select Pvalor
			 from Parametros
			 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			   and Pcodigo = 50 ) as periodo,
			( select Pvalor
			  from Parametros
			  where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			    and Pcodigo = 60 )  as mes,
			ctasdestino.testpcodigo as BancoDestino,
			ctasdestino.testpcuenta as CuentaDestino
	from TESOrdenPago op
		left outer join TESTRANSFERENCIAP ctasdestino
		on op.TESTPID = ctasdestino.TESTPID
	where TESOPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.TESOPid#">
</cfquery>

<!--- Salida --->
<cftransaction>
	<cfset interfaz.sbReportarActividad(150, url.ID)>
	<cfquery datasource="sifinterfaces">
		insert into IE150(	ID, 
							Tesoreria,
							OrdenPago,
							FechaPagoSolicitada,
							Beneficiario,
							Moneda_ISO,
							Monto,
							Observaciones,
							Banco,
							CuentaBancaria,
							TipoMedioPago,
							InstruccionBanco,
							FechaAutorizacion,
							UsuarioAutorizacion,
							PeriodoContable,
							MesContable,
							BANCODESTINO,
							CTABANCARIADESTINO)
		values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ID#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#rs.tesoreria#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#rs.ordenPago#">,
				<cfqueryparam cfsqltype="cf_sql_date" 	 value="#rs.FechaPagoSolicitada#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#rs.beneficiario#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#rs.moneda#">,
				<cfqueryparam cfsqltype="cf_sql_money" 	 value="#rs.monto#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#rs.observaciones#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#rs.Banco#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#rs.cuentaBancaria#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#rs.TipoMedioPago#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#rs.instruccionbanco#">,
				<cfqueryparam cfsqltype="cf_sql_date" 	 value="#rs.fechaAutorizacion#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#rs.Usuario#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#rs.periodo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#rs.mes#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#rs.BancoDestino#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#rs.CuentaDestino#">)
	</cfquery>

	<cfset interfaz.sbReportarActividad(150, url.ID)>
</cftransaction>