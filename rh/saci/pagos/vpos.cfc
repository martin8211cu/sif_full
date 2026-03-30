<cfcomponent output="false">
<!---
Parametrización default desarrollo:
	Miso4217n		188: CRC ; 840: USD
	PAidioma		SP-Español, EN-Inglés
	PAlugar		Origen/Lugar de compra

insert into ISBpagoAutorizador (
	PAautoriza, PAdescripcion, Miso4217a, Miso4217n,
	PApubCifrado, PAprvCifrado, PApubFirma, PAprvFirma,
	PAvector, PAurl, PAadquiriente, PAmall,
	PAcomercio, PAterminal, PAidioma, PAlugar,BMUsucodigo)
values (
	'01', 'VISA Banco Uno', 'CRC', '188',
	'/WEB-INF/saci/keys/ALIGNET.TESTING.PHP.CRYPTO.PUBLIC.TXT', '/WEB-INF/saci/keys/cifrado.prv.txt', '/WEB-INF/saci/keys/ALIGNET.TESTING.PHP.SIGNATURE.PUBLIC.TXT', '/WEB-INF/saci/keys/firma.prv.txt',
	'4f928a5f4b3c772a', 'https://servicios.alignet.com/VPOS/MM/transactionStart.do', '2', '0',
	'1900', '00000000', 'SP', 'web',0)


insert into ISBpagoOrigen (PAautoriza, POorigen, POtran, POurl, POdescripcion, BMUsucodigo)
values ('01', 'SACI', 'VS', '/cfmx/saci/faltadefiniradonde.cfm', 'Pruebas del SACI', 0)

insert into ISBpagoOrigen (PAautoriza, POorigen, POtran, POurl, POdescripcion, BMUsucodigo)
values ('01', 'SACI', 'AUAG', '/cfmx/saci/cliente/gestion/gestion-servicios-apply.cfm?pagoenlinea=', 'Agregar servicio por autogestión', 0)

insert into ISBpagoOrigen (PAautoriza, POorigen, POtran, POurl, POdescripcion, BMUsucodigo)
values ('01', 'SACI', 'AUCP', '/cfmx/saci/cliente/gestion/gestion-paquetes-apply.cfm?pagoenlinea=', 'Cambio de paquete por autogestión', 0)

insert into ISBpagoOrigen (PAautoriza, POorigen, POtran, POurl, POdescripcion, BMUsucodigo)
values ('01', 'SACI', 'AURP', '/cfmx/saci/cliente/gestion/gestion-recarga-apply.cfm?pagoenlinea=', 'Recarga de prepago por autogestión', 0)

--->

<cffunction name="seleccionar_autorizador" output="false" access="private" returntype="string">
	<cfargument name="moneda" type="string" required="yes" hint="Código alfanumérico de la moneda según estándar ISO 4217 ">
	<cfargument name="origen" type="string" required="yes">
	<cfargument name="tipoTransaccion" type="string" required="yes">

	<cfquery datasource="#session.dsn#" name="vpos_select_q">
		select a.PAautoriza, a.Miso4217a, a.Miso4217n
		from ISBpagoOrigen o
			join ISBpagoAutorizador a
				on o.PAautoriza = a.PAautoriza
		where o.POorigen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.origen#">
		  and o.POtran = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.tipoTransaccion#">
		order by case when 
			a.Miso4217a = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.moneda#">
			then 0 else 1 end
	</cfquery>
	<!--- Nótese que no hacemos ningún esfuerzo por aplicar un tipo de cambio cuando la moneda varíe --->
	
	<cfif vpos_select_q.RecordCount is 0>
		<cfthrow message="No hay un autorizador para el origen #Arguments.origen# y tipo de transacción #
			Arguments.tipoTransaccion# en moneda #Arguments.moneda#">
	</cfif>
	<!---	Permitir cambio de moneda, al recibir el pago se hace la conversión
	<cfif vpos_select_q.Miso4217a neq Arguments.moneda>
		<cfthrow message="No se permite pagar en una moneda que no sea #
			vpos_select_q.Miso4217a#/#vpos_select_q.Miso4217n# para el origen #
			Arguments.origen# y tipo de transacción #Arguments.tipoTransaccion#">
	</cfif>
	--->
	
	<cfreturn vpos_select_q.PAautoriza>
</cffunction>

<cffunction name="config" output="false" access="private" returntype="query">
	<cfargument name="PAautoriza" type="string" required="yes">

	<cfquery datasource="#session.dsn#" name="vpos_config_q">
		select 
			a.PAautoriza, a.PAdescripcion, a.Miso4217a, a.Miso4217n,
			a.PApubCifrado, a.PAprvCifrado, a.PApubFirma, a.PAprvFirma,
			a.PAvector, a.PAurl, a.PAadquiriente, a.PAmall,
			a.PAcomercio, a.PAterminal, a.PAidioma, a.PAlugar
		from ISBpagoAutorizador a
		where a.PAautoriza = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.PAautoriza#">
	</cfquery>
	<!--- Nótese que no hacemos ningún esfuerzo por aplicar un tipo de cambio cuando la moneda varíe --->
	
	<cfif vpos_config_q.RecordCount is 0>
		<cfthrow message="No se ha configurado el autorizador #Arguments.PAautoriza#">
	</cfif>
	
	<!--- Estos mensajes no contienen la ruta del archivo por seguridad --->
	<cfif Not FileExists(ExpandPath(vpos_config_q.PApubFirma))>
		<cfthrow message="Dato erróneo en config pub firma">
	</cfif>
	<cfif Not FileExists(ExpandPath(vpos_config_q.PAprvFirma))>
		<cfthrow message="Dato erróneo en config prv firma">
	</cfif>
	<cfif Not FileExists(ExpandPath(vpos_config_q.PApubCifrado))>
		<cfthrow message="Dato erróneo en config pub cifrado">
	</cfif>
	<cfif Not FileExists(ExpandPath(vpos_config_q.PAprvCifrado))>
		<cfthrow message="Dato erróneo en config prv cifrado">
	</cfif>
		
	<cfreturn vpos_config_q>
</cffunction>


<cffunction name="insertar_transaccion" output="false" access="private" returntype="numeric">
	<cfargument name="vpos_config" type="query" required="yes">
	<cfargument name="monto" type="numeric" required="yes">
	<cfargument name="moneda" type="string" required="yes" hint="Código alfanumérico de la moneda según estándar ISO 4217 ">
	<cfargument name="origen" type="string" required="yes">
	<cfargument name="tipoTransaccion" type="string" required="yes">
	<cfargument name="login" type="string" default="">
	<cfargument name="descripcion" type="string" default="">
	<cfargument name="nombre" type="string" default="">
	<cfargument name="cuenta" type="string" default="">
	<cfargument name="correo" type="string" default="">
	
	
	<cfif vpos_config.Miso4217a neq Arguments.moneda>
		<!--- Averiguar el tipo de cambio --->

		<cfquery datasource="SACISIIC" name="tipoCambio_q">
			exec sp_CambioDolar
		</cfquery>
		<cfset tipo_cambio = tipoCambio_q.Computed_Column_1>
		<cfif tipoCambio_q.RecordCount is 0>
			<cfthrow message="No se puede consultar el tipo de cambio (0 rows)">
		</cfif>
		<cfif Len(tipo_cambio) is 0>
			<cfthrow message="No se puede consultar el tipo de cambio (null)">
		</cfif>
		<cfif tipo_cambio is 0>
			<cfthrow message="No se puede consultar el tipo de cambio (0)">
		</cfif>
		
		<cfif vpos_config.Miso4217a is 'CRC' and Arguments.moneda is 'USD'>
			<cfset Arguments.moneda = 'CRC'>
			<cfset Arguments.monto = Arguments.monto * tipo_cambio>
		<cfelseif vpos_config.Miso4217a is 'USD' and Arguments.moneda is 'CRC'>
			<cfset Arguments.moneda = 'USD'>
			<cfset Arguments.monto = Arguments.monto / tipo_cambio>
		<cfelse>
			<cfthrow message="Lo siento, no puedo aceptar transacciones en moneda #Arguments.moneda#">
		</cfif>
	</cfif>
	
	<!--- insertar transacción --->
	<cfquery datasource="#session.dsn#" name="insert_pago">
		insert into ISBpago (
			PAautoriza, POorigen, POtran, PTmonto, PTlogin, PTdescripcion, PTnombre, PTcuenta, PTcorreo,
			PTfechaTransaccion, PTdireccionIP, Usucodigo, BMUsucodigo)
		values (
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#vpos_config.PAautoriza#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.origen#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.tipoTransaccion#">,
			<cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.monto#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.login#" null="#Len(Arguments.login) is 0#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.descripcion#" null="#Len(Arguments.descripcion) is 0#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.nombre#" null="#Len(Arguments.nombre) is 0#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.cuenta#" null="#Len(Arguments.cuenta) is 0#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.correo#" null="#Len(Arguments.correo) is 0#">,
			
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.sitio.ip#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
		<cf_dbidentity1 verificar_transaccion="false" name="insert_pago" datasource="#session.dsn#">
	</cfquery>
	<cf_dbidentity2 verificar_transaccion="false" name="insert_pago" datasource="#session.dsn#">
	<cfreturn insert_pago.identity>
</cffunction>

<cffunction name="send" output="false" access="remote" returntype="vpos_prepare_response">
	<cfargument name="monto" type="numeric" required="yes">
	<cfargument name="moneda" type="string" required="yes" hint="Código alfanumérico de la moneda según estándar ISO 4217 ">
	<cfargument name="origen" type="string" required="yes">
	<cfargument name="tipoTransaccion" type="string" required="yes">
	<cfargument name="login" type="string" default="">
	<cfargument name="descripcion" type="string" default="">
	<cfargument name="nombre" type="string" default="">
	<cfargument name="cuenta" type="string" default="">
	<cfargument name="correo" type="string" default="">
	
	<cfset var PAautoriza = seleccionar_autorizador(Arguments.moneda, 
		Arguments.origen, Arguments.tipoTransaccion)>
	<cfset var vpos_config = config(PAautoriza)>
	<cfset var PTid = insertar_transaccion(vpos_config, Arguments.monto, Arguments.moneda, 
		Arguments.origen, Arguments.tipoTransaccion, 
		Arguments.login, Arguments.descripcion,
		Arguments.nombre,Arguments.cuenta,
		Arguments.correo)>
	
	<cfset var ret = CreateObject("component", "vpos_prepare_response")>
	<cfset ret.datos = PTid & ',' & PAautoriza>
	<cfset ret.validar = firmarDato(ret.datos)>
	<cfreturn ret>
</cffunction>

<cffunction name="sendData" output="false" access="public" returntype="struct">
	<cfargument name="datos" type="string" required="yes">
	<cfargument name="validar" type="string" required="yes">
	
	<cfset var vpos_struct = StructNew()>
	<cfset var vpos_config = 0>
	<cfset var vPOSBean = CreateObject("java", "com.alignet.bean.VPOSBean").init()>
	
	<cfif firmarDato(Arguments.datos) neq Arguments.validar>
		<cfthrow message="Firma inválida">
	</cfif>
	<cfset Arguments.orden = ListFirst(Arguments.datos)>
	<cfset vpos_config = config(ListRest(Arguments.datos))>
	
	<!--- datos de la transaccion --->
	<cfquery datasource="#session.dsn#" name="pago_q">
		select PTmonto
		from ISBpago
		where PTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.orden#">
	</cfquery>
	
	<cfset vpos_struct.montoVpos = Int(pago_q.PTmonto * 100)>
	<cfset vpos_struct.PTid = Arguments.orden>
	<cfset vpos_struct.reservado3 = ""><!--- Codigo postal, AVS, size<=10 --->
	<cfset vpos_struct.reservado4 = ""><!--- Dirección calle AVS,  --->
	
	<!--- Establecer los parámetros dentro de las propiedades del objeto Plugin --->
	<cfset vPOSBean.setCodigoAdquirente(vpos_config.PAadquiriente)>
	<cfset vPOSBean.setCodigoMall(vpos_config.PAmall)>
	<cfset vPOSBean.setCodigoComercio(vpos_config.PAcomercio)>
	<cfset vPOSBean.setCodigoTerminal(vpos_config.PAterminal)>
	
	<cfset vPOSBean.setCodigoOperacion(NumberFormat(vpos_struct.PTid, '0'))>
	<cfset vPOSBean.setMonto(JavaCast("long", vpos_struct.montoVpos))>
	<cfset vPOSBean.setCodigoMoneda(vpos_config.Miso4217n)>
	<cfset vPOSBean.setReservado1(vpos_config.PAidioma)><!--- Idioma: SP-Español, EN-Inglés --->
	
	<cfset vPOSBean.setReservado2(vpos_config.PAlugar)><!--- Origen/Lugar de compra --->
	<cfset vPOSBean.setReservado3(vpos_struct.reservado3)><!--- Codigo postal, AVS, size<=10 --->
	<cfset vPOSBean.setReservado4(vpos_struct.reservado4)><!--- Dirección calle AVS,  --->
	
	<!--- establecer valores del plugin para encriptar --->
	<!--- instanciar una clase Send , pasar como parámetro la llave
		pública para encriptar , la privada para firmar y vector de inicialización--->
	
	<cfset send = CreateObject("java", "com.alignet.plugin.Send").init(
		CreateObject("java", "java.io.FileReader").init(ExpandPath(vpos_config.PApubCifrado)),
		CreateObject("java", "java.io.FileReader").init(ExpandPath(vpos_config.PAprvFirma)),
		JavaCast("string", vpos_config.PAvector))>
	
	<!--- encriptar --->
	<cfset send.execute(vPOSBean)>
	<!--- obtener valores encriptados --->
	<cfset vpos_struct.NEXTURL = vpos_config.PAurl>
	<cfset vpos_struct.SESSIONKEY = vPOSBean.getEncryptEncodedSesionKeyReq()>
	<cfset vpos_struct.XMLREQ = vPOSBean.getEncryptEncodedXmlReq()>
	<cfset vpos_struct.DIGITALSIGN = vPOSBean.getEncryptEncodedSignReq()>
	<cfreturn vpos_struct>
</cffunction>

<cffunction name="recv" output="false" access="public" returntype="struct">
	<cfargument name="PAautoriza" type="string" required="yes">
	<cfargument name="SESSIONKEY" type="string" required="yes">
	<cfargument name="XMLRES" type="string" required="yes">
	<cfargument name="DIGITALSIGN" type="string" required="yes">

	<cfset var vpos_struct = StructNew()>
	<cfset var vPOSBean = CreateObject("java", "com.alignet.bean.VPOSBean").init()>
	<cfset var vpos_config = config(Arguments.PAautoriza)>
	
	<!--- Colocar los parámetros dentro de las propiedades del objeto Plug --->
	<cfset vPOSBean.setEncryptEncodedSesionKeyRes(Arguments.SESSIONKEY)>
	<cfset vPOSBean.setEncryptEncodedXmlRes(Arguments.XMLRES)>
	<cfset vPOSBean.setEncryptEncodedSignRes(Arguments.DIGITALSIGN)>
	
	<!---Invocar al método ejecutar de la objeto execute, el cual desencripta el xml--->
	<cfset receive = CreateObject("java","com.alignet.plugin.Receive").init(
		CreateObject("java", "java.io.FileReader").init(ExpandPath(vpos_config.PApubFirma)),
		CreateObject("java", "java.io.FileReader").init(ExpandPath(vpos_config.PAprvCifrado)),
		JavaCast("string", vpos_config.PAvector))>

	<cfset receive.execute(vPOSBean)>

	<!--- Verificando la firma digital, que permitirá verificar la integridad de los datos--->
	<cfset esFirmaValida = vPOSBean.isValidSign()>
	
	<!---recuperación de los datos usando el plug-in --->
	
	<cfset vpos_struct.estadoAutorizacion = vPOSBean.getEstadoAutorizacion()>
	<cfset vpos_struct.PTid = vPOSBean.getCodigoOperacion()>
	<cfset vpos_struct.codigoAutorizacion = vPOSBean.getCodigoAutorizacion()>
	<cfset vpos_struct.codigoError = vPOSBean.getCodigoError()>
	<cfset vpos_struct.mensajeError = vPOSBean.getMensajeError()>
	
	<cfif Not REFind('^[0-9]+$', vpos_struct.PTid)>
		<cfthrow message="Error en respuesta: código de operación inválido (#vpos_struct.PTid#)">
	</cfif>
	<!--- Validar que la operación PTid exista --->
	<cfquery datasource="#session.dsn#" name="validar">
		select p.PTdireccionIP, p.PTrespuesta, o.POurl
		from ISBpago p
			join ISBpagoOrigen o
				on p.PAautoriza = o.PAautoriza
				and p.POorigen = o.POorigen
				and p.POtran = o.POtran
		where PTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vpos_struct.PTid#">
	</cfquery>
	<cfset vpos_struct.NEXTURL = validar.POurl>
	<cfif validar.RecordCount is 0>
		<cfthrow message="La operación no existe.  El codigo de operación no ha sido registrado.">
	</cfif>
	<cfif validar.PTdireccionIP neq session.sitio.IP>
		<cfthrow message="La operación se había iniciado en otra dirección IP. La suya es #session.sitio.ip#">
	</cfif>
	<cfif validar.PTrespuesta>
		<!--- 
		La operación ya había tenido respuesta.  Se descarta la respuesta duplicada y se regresa OK para
		poder probar
		<cfthrow message="La operación ya había tenido respuesta.  Se descarta la respuesta duplicada.">
		--->
	<cfelseif vpos_struct.estadoAutorizacion is '00'>
		<!--- En este caso la transacción fue aprobada:--->
		<cfquery datasource="#session.dsn#">
			update ISBpago
			set PTestado = <cfqueryparam cfsqltype="cf_sql_varchar" value="#vpos_struct.estadoAutorizacion#">,
				PTcodAutorizacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#vpos_struct.codigoAutorizacion#">,
				PTfechaRespuesta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
				PTautorizado = 1,
				PTrespuesta = 1
			where PTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vpos_struct.PTid#">
		</cfquery>
	<cfelse>
		<!--- En este caso la transacción fue denegada --->
		<cfoutput>#vpos_struct.estadoAutorizacion#</cfoutput>
		
		<cfquery datasource="#session.dsn#">
			update ISBpago
			set PTestado = <cfqueryparam cfsqltype="cf_sql_varchar" value="#vpos_struct.estadoAutorizacion#">,
				PTcodError = <cfqueryparam cfsqltype="cf_sql_varchar" value="#vpos_struct.codigoError#">,
				PTmsgError = <cfqueryparam cfsqltype="cf_sql_varchar" value="#vpos_struct.mensajeError#">,
				PTfechaRespuesta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
				PTautorizado = 0,
				PTrespuesta = 1
			where PTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vpos_struct.PTid#">
		</cfquery>
		
	</cfif>
	<cfreturn vpos_struct>
</cffunction>

<cffunction name="renderForm" output="true" returntype="void">
	<cfargument name="vpos_struct" type="struct" required="yes">
	<cfargument name="sendform" type="boolean" required="yes">
	<cfinclude template="vpos-request.cfm">
</cffunction>

<cffunction name="firmarDato" output="false" returntype="string" access="private">
	<cfargument name="dato" type="string" required="yes">
	
	<cfparam name="application.vpos_salt" default="#Rand()#">
	
	<cfreturn Hash ( '*/*/*' & Arguments.dato & application.vpos_salt ) >
</cffunction>

</cfcomponent>