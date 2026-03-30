

<cfcomponent>

	<cffunction name="genDispersion" output="no">
		<cfargument name="OP_IDs" required="yes">
		<cfargument name="BankName" required="yes">
		<cfargument name="BankData" required="yes">
		<cfargument name="debug" default="false">

		<cfset fileName = #DateTimeFormat(now(), "yyyymmddHHnnss")# >
		<cfset fileName = "#BankName#_#filename#.txt">
		<cfset filePath = "ram:///#fileName#">
		<cfset outputText = []>

		<cfset num_operacion = 0>
		<cfset num_cuenta_origen = "#BankData.CBcodigo#">


		<cfquery name="rsGetParam5002" datasource="#session.DSN#">
			SELECT Pvalor
			FROM Parametros
			WHERE Pcodigo = 5002
			AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		<cfif rsGetParam5002.RecordCount GT 0>
			<cfset lVarTipoCuentaParametro = #rsGetParam5002.Pvalor#>
		<cfelse>
			<cfthrow message="[ERROR] Es necesario confugurar el parametro (Tipo de cuenta para Dispersi�n de pagos (Bancomer)) en Administracion del Sistema.">
		</cfif>


		<!--- dp.TESDPmontoAprobadoOri  --->
		<cfquery name="q_datosOrdenPago" datasource="#session.DSN#">
			select
				  mp.TESMPcodigoDisp						q_operacion
				, isNull(tp.TESTPbancoID,'')				q_clave_id
				, '#num_cuenta_origen#' 					q_num_cuenta_origen
				, tp.TESTPcuenta 							q_num_cuenta_destino
				, ba.Bdescripcion                           q_nombre_banco
				, ba.Iaba                                   q_codigo_banxico
				, dp.TESDPmontoPago				q_importe
				, isnull(op.TESOPReferenciaCIE, op.TESOPnumero)		q_referencia
				, op.TESOPobservaciones 					q_descripcion
				, e.Eidentificacion 						q_rfc
				, dp.TESDPmontoAprobadoOri *
					(isNull(i.Iporcentaje,0)/100)			q_iva
				, op.TESOPinstruccion 						q_instruccion
				, op.TESOPfechaPago 					 	q_fecha_aplicacion
				, op.TESOPbeneficiario 						q_nombre_destino
				, op.TESOPid								q_id
				, mp.TESMPcodigo							a_codigo_pago
				, op.TESTPid								a_TransferenciaP_id
				, op.Miso4217Pago
				, op.TESOPConceptoCIE
				, op.TESOPConvenioCIE
			from TESordenPago op
				inner join TESmedioPago mp
					on mp.TESMPcodigo = op.TESMPcodigo
					and mp.CBid = #BankData.CBid#
				left join Empresa e
					on e.Ereferencia = op.EcodigoPago
				left join TEStransferenciaP tp
					on tp.TESTPid = op.TESTPid
				LEFT JOIN Bancos ba ON tp.Bid = ba.Bid
				left join TESdetallePago dp
					on dp.TESOPid = op.TESOPid
					and dp.RlineaId is null
				left join Impuestos i
					on dp.Icodigo = i.Icodigo
			where op.TESOPid in (#ArrayToList(OP_IDs,',')#);
		</cfquery>

		<cfif arguments.debug>
			<cfdump var="#q_datosOrdenPago#">
		</cfif>

		<cfset datosOrdenPago = structNew()>

		<cfloop query="q_datosOrdenPago">
			<cfscript>
				if(!StructKeyExists(datosOrdenPago, q_datosOrdenPago.q_id)){
					datosOrdenPago[q_datosOrdenPago.q_id] = structNew();
					datosOrdenPago[q_datosOrdenPago.q_id].q_operacion 			= q_datosOrdenPago.q_operacion;
					datosOrdenPago[q_datosOrdenPago.q_id].q_clave_id 			= q_datosOrdenPago.q_clave_id;
					datosOrdenPago[q_datosOrdenPago.q_id].q_num_cuenta_origen 	= q_datosOrdenPago.q_num_cuenta_origen;
					datosOrdenPago[q_datosOrdenPago.q_id].q_num_cuenta_destino 	= q_datosOrdenPago.q_num_cuenta_destino;
					datosOrdenPago[q_datosOrdenPago.q_id].q_importe 			= NumberFormat(q_datosOrdenPago.q_importe,'0.00');
					datosOrdenPago[q_datosOrdenPago.q_id].q_referencia 			= q_datosOrdenPago.q_referencia;
					datosOrdenPago[q_datosOrdenPago.q_id].q_descripcion 		= q_datosOrdenPago.q_descripcion;
					datosOrdenPago[q_datosOrdenPago.q_id].q_rfc 				= q_datosOrdenPago.q_rfc;
					datosOrdenPago[q_datosOrdenPago.q_id].q_iva 				= NumberFormat(q_datosOrdenPago.q_iva,'0.00');
					datosOrdenPago[q_datosOrdenPago.q_id].q_instruccion 		= q_datosOrdenPago.q_instruccion;
					datosOrdenPago[q_datosOrdenPago.q_id].q_fecha_aplicacion 	= '#DateTimeFormat(q_datosOrdenPago.q_fecha_aplicacion, "ddmmyyyy")#';
					datosOrdenPago[q_datosOrdenPago.q_id].q_nombre_destino 		= q_datosOrdenPago.q_nombre_destino;
					datosOrdenPago[q_datosOrdenPago.q_id].q_id 					= q_datosOrdenPago.q_id;
					datosOrdenPago[q_datosOrdenPago.q_id].a_codigo_pago 		= q_datosOrdenPago.a_codigo_pago;
					datosOrdenPago[q_datosOrdenPago.q_id].a_TransferenciaP_id 	= q_datosOrdenPago.a_TransferenciaP_id;
					datosOrdenPago[q_datosOrdenPago.q_id].Miso4217Pago 	        = q_datosOrdenPago.Miso4217Pago;
					/*DATOS BANCARIOS*/
					datosOrdenPago[q_datosOrdenPago.q_id].q_nombre_banco 	        = q_datosOrdenPago.q_nombre_banco;
					datosOrdenPago[q_datosOrdenPago.q_id].q_codigo_banxico 	        = q_datosOrdenPago.q_codigo_banxico;
					/*UNICAMENTE CIE*/
					datosOrdenPago[q_datosOrdenPago.q_id].q_concepto_cie 	        = q_datosOrdenPago.TESOPConceptoCIE;
					datosOrdenPago[q_datosOrdenPago.q_id].q_convenio_cie 	        = q_datosOrdenPago.TESOPConvenioCIE;
				}else{
					datosOrdenPago[q_datosOrdenPago.q_id].q_iva += NumberFormat(q_datosOrdenPago.q_iva,'0.00');
					datosOrdenPago[q_datosOrdenPago.q_id].q_importe += NumberFormat(q_datosOrdenPago.q_importe,'0.00');
				}
			</cfscript>
		</cfloop>

		<cfif arguments.debug>
			<cfdump var="#datosOrdenPago#">
		</cfif>


		<cfset NL = Chr(13)&Chr(10)>

		<cfset ListOperaciones= "CIL,TNN,PTC,TSC,PSC">

		<cfloop collection="#datosOrdenPago#" item="k" >

			<cfset line ="">
			<!--- VALIDACIONES --->
			<!--- Codigo de tipo de operacion --->
			<cfif FindNoCase(#TRIM(UCASE(datosOrdenPago[k].q_operacion))#,#ListOperaciones#) EQ 0>
				<cfthrow message="[ERROR] El codigo de dispersion de pagos (#TRIM(UCASE(datosOrdenPago[k].q_operacion))#) para el medio de pago (#TRIM(datosOrdenPago[k].a_codigo_pago)#) en la cuenta (#BankData.BDescripcion# - #BankData.CBcodigo#) no es correcto. Los codigos aceptados son (CIL, TNN, PTC, TSC, PSC).">
			</cfif>
			<cfset l_operacion = MID(datosOrdenPago[k].q_operacion,1,3)>
			<cfif TRIM(UCASE(#l_operacion#)) EQ "CIL">
				<!--- CIE(CIL) --->
				<!--- *****************************************************************
				      ************************ PAGOS CIE (CIL) ************************
				      ***************************************************************** --->

				<!--- Concepto CIE, sino lo trae se llena de espacios (30 Caracteres) --->
				<cfset lConceptoCIE = Trim(UCASE(Mid(datosOrdenPago[k].q_concepto_cie,1,30)))>
				<cfloop index = "i" from = "#len(lConceptoCIE)#" to = "29">
					<cfset lConceptoCIE ="#lConceptoCIE# ">
				</cfloop>

				<!--- Convenio CIE, sino lo trae se llena de 0 (7 Caracteres) --->
				<cfset lConvenioCIE = Trim(UCASE(Mid(datosOrdenPago[k].q_convenio_cie,1,30)))>
				<cfloop index = "i" from = "#len(lConvenioCIE)#" to = "6">
					<cfset lConvenioCIE ="0#lConvenioCIE#">
				</cfloop>

				<!--- Cuenta Origen 18 digitos --->
				<cfset l_num_cuenta_origen = Trim(Mid(datosOrdenPago[k].q_num_cuenta_origen,1,18))>
				<cfif l_num_cuenta_origen eq ''>
					<cfthrow message="[ERROR] La cuenta Origen, no ha sido configurada.">
				</cfif>
				<cfloop index = "i" from = "#len(l_num_cuenta_origen)#" to = "17">
					<cfset l_num_cuenta_origen = "0#l_num_cuenta_origen#">
				</cfloop>

				<!--- Importe de Operacion (16 Caracteres) --->
				<cfset l_importe = #numberformat(datosOrdenPago[k].q_importe,9.99)#>

				<cfloop index = "i" from = "#len(l_importe)#" to = "15">
					<cfset l_importe = "0#l_importe#">
				</cfloop>

				<!--- Motivo de pago (30 Caracteres) --->
				<cfset l_descripcion = Trim(UCASE(Mid(datosOrdenPago[k].q_descripcion,1,30)))>
				<cfif l_descripcion eq ''>
					<cfthrow message="[ERROR] El motivo de pago es requerido..">
				</cfif>
				<cfloop index = "i" from = "#len(l_descripcion)#" to = "29">
					<cfset l_descripcion ="#l_descripcion# ">
				</cfloop>

				<!--- Referencia numerica --->
				<!--- Referencia 20 digitos--->
				<cfset l_referencia = Trim(Mid(datosOrdenPago[k].q_referencia,1,20))>
				<cfif l_referencia eq ''>
					<cfthrow message="[ERROR] La referencia CIE es requerido.">
				</cfif>
				<cfloop index = "i" from = "#len(l_referencia)#" to = "19">
					<cfset l_referencia = "#l_referencia# ">
				</cfloop>

				<!--- Armado de linea TXT --->
				<cfif arguments.debug>
					<!--- <cfset line = "#line##l_operacion# | "> --->
					<cfset line = "#line##lConceptoCIE# | ">
					<cfset line = "#line##lConvenioCIE# | ">
					<cfset line = "#line##l_num_cuenta_origen# | ">
					<cfset line = "#line##l_importe# | ">
					<cfset line = "#line##l_descripcion# | ">
					<cfset line = "#line##l_referencia# | ">
				<cfelse>
					<!--- <cfset line = "#line##l_operacion#"> --->
					<cfset line = "#line##lConceptoCIE#">
					<cfset line = "#line##lConvenioCIE#">
					<cfset line = "#line##l_num_cuenta_origen#">
					<cfset line = "#line##l_importe#">
					<cfset line = "#line##l_descripcion#">
					<cfset line = "#line##l_referencia#">
				</cfif>


			<cfelseif FindNoCase(#TRIM(UCASE(datosOrdenPago[k].q_operacion))#,"TNN,PTC") GT 0>
				<!--- *****************************************************************
				      ********** PAGOS CUENTAS PROPIAS (TNN y PTC) **********
				      ***************************************************************** --->
				<!--- Cuenta Origen 18 digitos --->
				<cfset l_num_cuenta_origen = Trim(Mid(datosOrdenPago[k].q_num_cuenta_origen,1,18))>
				<cfif l_num_cuenta_origen eq ''>
					<cfthrow message="[ERROR] La cuenta Origen, no ha sido configurada.">
				</cfif>
				<cfloop index = "i" from = "#len(l_num_cuenta_origen)#" to = "17">
					<cfset l_num_cuenta_origen = "0#l_num_cuenta_origen#">
				</cfloop>

				<!--- Cuenta Destino 18 digitos --->
				<cfset l_num_cuenta_destino = Trim(Mid(datosOrdenPago[k].q_num_cuenta_destino,1,18))>
				<cfif l_num_cuenta_destino eq ''>
					<cfthrow message="[ERROR] La cuenta Destino, no ha sido configurada.">
				</cfif>
				<cfloop index = "i" from = "#len(l_num_cuenta_destino)#" to = "17">
					<cfset l_num_cuenta_destino = "0#l_num_cuenta_destino#">
				</cfloop>

				<!--- Divisa de operacion (3 Caracteres) --->
				<cfset l_Miso4217Pago = Trim(UCASE(MID(datosOrdenPago[k].Miso4217Pago,1,3)))>
				<cfif l_Miso4217Pago eq ''>
					<cfthrow message="[ERROR] La divisa de operacion, no ha sido configurada.">
				<cfelseif len(l_Miso4217Pago) NEQ 3>
					<cfthrow message="[ERROR] La divisa de operacion (#l_Miso4217Pago#), debe ser de 3 digitos.">
				</cfif>
				<!--- Si la moneda es MXN, por solicitud del funcional Fernando Reyes,
				      se cambia a MXP, debido a que Bancomer lo solicita en MXP. --->
				<cfif l_Miso4217Pago EQ "MXN">
					<cfset l_Miso4217Pago = "MXP">
				</cfif>

				<!--- Importe de Operacion (16 Caracteres) --->
				<cfset l_importe = #numberformat(datosOrdenPago[k].q_importe,9.99)#>

				<cfloop index = "i" from = "#len(l_importe)#" to = "15">
					<cfset l_importe = "0#l_importe#">
				</cfloop>

				<!--- Motivo de pago (30 Caracteres) --->
				<cfset l_descripcion = Trim(UCASE(Mid(datosOrdenPago[k].q_descripcion,1,30)))>
				<cfif l_descripcion eq ''>
					<cfthrow message="[ERROR] El motivo de pago es requerido..">
				</cfif>
				<cfloop index = "i" from = "#len(l_descripcion)#" to = "29">
					<cfset l_descripcion ="#l_descripcion# ">
				</cfloop>

				<!--- Armado de linea TXT --->
				<cfif arguments.debug>
					<!--- <cfset line = "#line##l_operacion# | "> --->
					<cfset line = "#line##l_num_cuenta_destino# | ">
					<cfset line = "#line##l_num_cuenta_origen# | ">
					<cfset line = "#line##l_Miso4217Pago# | ">
					<cfset line = "#line##l_importe# | ">
					<cfset line = "#line##l_descripcion# | ">
				<cfelse>
					<!--- <cfset line = "#line##l_operacion#"> --->
					<cfset line = "#line##l_num_cuenta_destino#">
					<cfset line = "#line##l_num_cuenta_origen#">
					<cfset line = "#line##l_Miso4217Pago#">
					<cfset line = "#line##l_importe#">
					<cfset line = "#line##l_descripcion#">
				</cfif>
			<cfelseif FindNoCase(#TRIM(UCASE(datosOrdenPago[k].q_operacion))#,"TSC,PSC") GT 0>
				<!--- *****************************************************************
				      ********** PAGOS INTERBANCARIOS: TERCEROS (TSC y PSC) ***********
				      ***************************************************************** --->
				<!--- Cuenta Origen 18 digitos --->
				<cfset l_num_cuenta_origen = Trim(Mid(datosOrdenPago[k].q_num_cuenta_origen,1,18))>
				<cfif l_num_cuenta_origen eq ''>
					<cfthrow message="[ERROR] La cuenta Origen, no ha sido configurada.">
				</cfif>
				<cfloop index = "i" from = "#len(l_num_cuenta_origen)#" to = "17">
					<cfset l_num_cuenta_origen = "0#l_num_cuenta_origen#">
				</cfloop>

				<!--- Cuenta Destino 18 digitos --->
				<cfset l_num_cuenta_destino = Trim(Mid(datosOrdenPago[k].q_num_cuenta_destino,1,18))>
				<cfif l_num_cuenta_destino eq ''>
					<cfthrow message="[ERROR] La cuenta Destino, no ha sido configurada.">
				</cfif>
				<cfloop index = "i" from = "#len(l_num_cuenta_destino)#" to = "17">
					<cfset l_num_cuenta_destino = "0#l_num_cuenta_destino#">
				</cfloop>

				<!--- Divisa de operacion (3 Caracteres) --->
				<cfset l_Miso4217Pago = Trim(UCASE(MID(datosOrdenPago[k].Miso4217Pago,1,3)))>
				<cfif l_Miso4217Pago eq ''>
					<cfthrow message="[ERROR] La divisa de operacion, no ha sido configurada.">
				<cfelseif len(l_Miso4217Pago) NEQ 3>
					<cfthrow message="[ERROR] La divisa de operacion (#l_Miso4217Pago#), debe ser de 3 digitos.">
				</cfif>
				<!--- Si la moneda es MXN, por solicitud del funcional Fernando Reyes,
				      se cambia a MXP, debido a que Bancomer lo solicita en MXP. --->
				<cfif l_Miso4217Pago EQ "MXN">
					<cfset l_Miso4217Pago = "MXP">
				</cfif>

				<!--- Importe de Operacion (16 Caracteres) --->
				<cfset l_importe = #numberformat(datosOrdenPago[k].q_importe,9.99)#>

				<cfloop index = "i" from = "#len(l_importe)#" to = "15">
					<cfset l_importe = "0#l_importe#">
				</cfloop>

				<!--- Titular Asunto Beneficiario (Nombre SN) q_nombre_destino(30 Caracteres) --->
				<cfset l_nombre_destino = "#Trim(Mid(datosOrdenPago[k].q_nombre_destino,1,30))#">
				<cfif l_nombre_destino eq ''>
					<cfthrow message="[ERROR] El nombre del beneficiario es requerido.">
				</cfif>
				<cfloop index = "i" from = "#len(l_nombre_destino)#" to = "29">
					<cfset l_nombre_destino ="#l_nombre_destino# ">
				</cfloop>

				<!--- Tipo de cuenta --->
				<cfset l_tipo_Cuenta = #lVarTipoCuentaParametro#>


				<!--- Numero de Banco del Asunto Beneficiario --->
				<cfset lVarLen = LEN(TRIM(datosOrdenPago[k].q_codigo_banxico))>
				<cfif lVarLen GT 2>
					<cfset l_Num_Banco_B = TRIM(MID(datosOrdenPago[k].q_codigo_banxico,lVarLen-2,lVarLen))>
					<cfif l_Num_Banco_B eq ''>
						<cfthrow message="[ERROR] El codigo del banco es requerido para el banco #Trim(datosOrdenPago[k].q_nombre_banco)#">
					</cfif>
				<cfelse>
					<cfthrow message="[ERROR] El codigo del banco debe ser de al menos 3 digitos.">
				</cfif>


				<!--- Motivo de pago (30 Caracteres) --->
				<cfset l_descripcion = Trim(UCASE(Mid(datosOrdenPago[k].q_descripcion,1,30)))>
				<cfif l_descripcion eq ''>
					<cfthrow message="[ERROR] El motivo de pago es requerido.">
				</cfif>
				<cfloop index = "i" from = "#len(l_descripcion)#" to = "29">
					<cfset l_descripcion ="#l_descripcion# ">
				</cfloop>


				<!--- Referencia numerica --->
				<!--- Referencia 7 digitos--->
				<cfset l_referencia = Trim(Mid(datosOrdenPago[k].q_referencia,1,7))>
				<cfif l_referencia eq ''>
					<cfthrow message="[ERROR] La referencia numerica es requerido.">
				</cfif>
				<cfloop index = "i" from = "#len(l_referencia)#" to = "6">
					<cfset l_referencia = "0#l_referencia#">
				</cfloop>

				<!--- Disponibilidad  --->
				<cfif TRIM(UCASE(datosOrdenPago[k].a_codigo_pago)) EQ 'SPEI'>
					<!--- Mismo dia --->
					<cfset l_Disponibilidad = "H">
				<cfelseif TRIM(UCASE(datosOrdenPago[k].a_codigo_pago)) EQ 'TEF'>
					<!--- Dia siguiente --->
					<cfset l_Disponibilidad = "M">
				<cfelse>
					<cfthrow message="[ERROR] Se requiere un medio de pago SPEI o TEF.">
				</cfif>

				<!--- Armado de linea TXT --->
				<cfif arguments.debug>
					<!--- <cfset line = "#line##l_operacion# | "> --->
					<cfset line = "#line##l_num_cuenta_destino# | ">
					<cfset line = "#line##l_num_cuenta_origen# | ">
					<cfset line = "#line##l_Miso4217Pago# | ">
					<cfset line = "#line##l_importe# | ">
					<cfset line = "#line##l_nombre_destino# | ">
					<cfset line = "#line##l_tipo_Cuenta# | ">
					<cfset line = "#line##l_Num_Banco_B# | ">
					<cfset line = "#line##l_descripcion# | ">
					<cfset line = "#line##l_referencia# | ">
					<cfset line = "#line##l_Disponibilidad# | ">
				<cfelse>
					<!--- <cfset line = "#line##l_operacion#"> --->
					<cfset line = "#line##l_num_cuenta_destino#">
					<cfset line = "#line##l_num_cuenta_origen#">
					<cfset line = "#line##l_Miso4217Pago#">
					<cfset line = "#line##l_importe#">
					<cfset line = "#line##l_nombre_destino#">
					<cfset line = "#line##l_tipo_Cuenta#">
					<cfset line = "#line##l_Num_Banco_B#">
					<cfset line = "#line##l_descripcion#">
					<cfset line = "#line##l_referencia#">
					<cfset line = "#line##l_Disponibilidad#">
				</cfif>
			</cfif>

			<cfset arrayAppend(outputText, line)>

		</cfloop>
		<cfif arguments.debug>
			<cfdump var="#outputText#" abort>
		</cfif>
		<cfset outputText = arrayToList(outputText,"#NL#")>



		<cffile action = "write"
			file 		= "#filePath#"
			charset 	= "utf-8"
			output 		= "#outputText#"
		>
		 <cfheader name="Content-Disposition" value="attachment; filename=#fileName#">
		<cfcontent type="text/plain" file="#filePath#" deletefile="yes">


		<cfreturn>
	</cffunction>

</cfcomponent>
