<!---
	Realiza un cargo a una tarjeta de crédito
	a través de los autorizadores establecidos en la base de datos aspsecure.

	Atributos:
		action      Solamente "autorizar" por ahora
		Ecodigosdc  Empresa receptora del cargo (iglesia, tienda, facturador, etc)
		id_tarjeta  Tarjeta por utilizar
		monto       Monto por cargar a la tarjeta
		moneda      Monto por cargar a la tarjeta
		control     Número de control (pedido, referencia, etc)

	Resultado:
		La variable cf_tarjeta_cobro contiene el resultado de la operacion.
	(*) cf_tarjeta_cobro.error:        0 = ok, otra cosa es error
	(*) cf_tarjeta_cobro.mensaje:      Contiene el mensaje correspondiente al numero de error
		                               Este mensaje es específico del autorizador
	(*) cf_tarjeta_cobro.autorizacion: Contiene el numero de autorizacion, si aplica
	(*) cf_tarjeta_cobro.respuesta:    Respuesta completa del emisor a esta transacción
		cf_tarjeta_cobro.autorizador:  Nombre del autorizador (Credomatic, ATH, etc)
		cf_tarjeta_cobro.transaccion:  Contiene el registro insertado en la tabla de TarjetaTransaccion,
		                               siempre y cuando la transaccion haya sido autorizada
	Los datos con (*) se obtienen en el componente del autorizador, los demas se generan en este programa
	
--->
<cfparam name="Attributes.action"     type="string">
<cfparam name="Attributes.Ecodigosdc" type="numeric">
<cfparam name="Attributes.id_tarjeta" type="numeric">
<cfparam name="Attributes.monto"      type="numeric">
<cfparam name="Attributes.moneda"     type="string">
<cfparam name="Attributes.control"    type="string">

<cfif Attributes.action is 'autorizar'>
	<!---
	1. Obtener el Autorizador/ComercioAfiliado segun Ecodigo/moneda/tipo tarjeta
	 --->
	<cf_tarjeta action="select" key="#Attributes.id_tarjeta#" name="tarjeta">
	<cfif Len(tarjeta.id_tarjeta) is 0>
		<cf_errorCode	code = "50709"
						msg  = "No existe la tarjeta (id_tarjeta = @errorDat_1@)"
						errorDat_1="#Attributes.id_tarjeta#"
		>
	</cfif>
	<cfquery datasource="aspsecure" name="autorizador">
		select a.autorizador, a.programa, a.nombre_autorizador,
			ca.comercio, ca.configuracion
		from AutorizadorEmpresa ae, ComercioAfiliado ca, Autorizador a, AutorizadorTipoTarjeta att
		where ae.Ecodigosdc = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.Ecodigosdc#">
		  and ca.autorizador = ae.autorizador
		  and ca.comercio = ae.comercio
		  and a.autorizador = ca.autorizador
		  and att.autorizador = ca.autorizador
		  and att.tc_tipo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#tarjeta.tc_tipo#">
		  and ca.moneda = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Attributes.moneda#">
		order by ae.prioridad
	</cfquery>
	<cfif autorizador.RecordCount IS 0>
		<cf_errorCode	code = "50710"
						msg  = "No es posible autorizar cargos en moneda @errorDat_1@ para la empresa @errorDat_2@ cuando la tarjeta es de tipo @errorDat_3@"
						errorDat_1="#Attributes.moneda#"
						errorDat_2="#Attributes.EcodigoSDC#"
						errorDat_3="#tarjeta.tc_tipo#"
		>
	</cfif>
	
	<!---
	2. Invocar el componente del autorizador segun sea el caso
	 2a. Autorizador.programa es el nombre del directorio donde esta el componente debajo de /cfmx/autorizaciones
	 2b. ComercioAfiliado.configuracion es especifico segun el autorizador, en credomatic es el archivo cgi.dat 
	 --->
	<cfinvoke component="autorizaciones.#autorizador.programa#.conexion" method="autorizar" returnvariable="status">
		<cfinvokeargument name="config"  value="#autorizador.configuracion#">
		<cfinvokeargument name="tarjeta" value="#tarjeta#">
		<cfinvokeargument name="monto"   value="#Attributes.monto#">
		<cfinvokeargument name="moneda"  value="#Attributes.moneda#">
		<cfinvokeargument name="control" value="#Attributes.control#">
	</cfinvoke>
	<cfset status.autorizador = autorizador.nombre_autorizador>

	<!--- 3. Si el estatus del componente tiene .error == 0, insertar registro en TarjetaTransaccion --->
	<cfset transaccion_generada = "no">
	<cfif status.error is 0>
		<cfquery datasource="aspsecure" name="inserted">
			insert TarjetaTransaccion (
				id_tarjeta, autorizador, comercio,
				Ecodigosdc, importe, moneda,
				num_preautorizacion, num_voucher, num_autorizacion, num_control,
				BMUsucodigo, BMfechamod)
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.id_tarjeta#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#autorizador.autorizador#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#autorizador.comercio#">,

				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.Ecodigosdc#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.monto#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Attributes.moneda#">,

				<cfqueryparam cfsqltype="cf_sql_numeric" value="" null="yes">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="" null="yes">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#status.autorizacion#" null="#Len(status.autorizacion) IS 0#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.control#" null="#Len(Attributes.control) IS 0#">,

				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">)
			select *
			from TarjetaTransaccion
			where id_transaccion = @@identity
		</cfquery>
		<cfset status.transaccion = inserted>
		<cfset transaccion_generada = inserted.id_transaccion>
	</cfif>
	
	<!--- 4. Regresar el resultado --->
	<cfset Caller.cf_tarjeta_cobro = status>

	<cflog application="no" file="autorizaciones" text="
		#status.autorizador#
		Tarjeta: #tarjeta.tc_numero# #tarjeta.tc_nombre# #tarjeta.tc_vence_mes#/#tarjeta.tc_vence_ano# #Attributes.moneda# #Attributes.monto#
		Respuesta: #status.respuesta#
		Error: #status.error# - #status.mensaje#
		Num aut: #status.autorizacion#
		Transaccion Generada: #transaccion_generada#">
<cfelse>
	<cf_errorCode	code = "50622"
					msg  = "action invalido: @errorDat_1@"
					errorDat_1="#Attributes.action#"
	>
</cfif>



