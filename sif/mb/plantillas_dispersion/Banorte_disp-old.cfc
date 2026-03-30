

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
		<!--- dp.TESDPmontoAprobadoOri  --->
		<cfquery name="q_datosOrdenPago" datasource="#session.DSN#">
			select 
				  mp.TESMPcodigoDisp						q_operacion
				, isNull(tp.TESTPbancoID,'')				q_clave_id
				, '#num_cuenta_origen#' 					q_num_cuenta_origen
				, tp.TESTPcuenta 							q_num_cuenta_destino
				, dp.TESDPmontoPago				q_importe
				, op.TESOPnumero		 					q_referencia
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
			from TESordenPago op 
				inner join TESmedioPago mp
					on mp.TESMPcodigo = op.TESMPcodigo
					and mp.CBid = #BankData.CBid#
				left join Empresa e
					on e.Ereferencia = op.EcodigoPago
				left join TEStransferenciaP tp 
					on tp.TESTPid = op.TESTPid
				left join TESdetallePago dp 
					on dp.TESOPid = op.TESOPid
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
				}else{
					datosOrdenPago[q_datosOrdenPago.q_id].q_iva += NumberFormat(q_datosOrdenPago.q_iva,'0.00');
					datosOrdenPago[q_datosOrdenPago.q_id].q_importe += NumberFormat(q_datosOrdenPago.q_importe,'0.00');
				}
			</cfscript>
		</cfloop>

		<cfif arguments.debug>
			<cfdump var="#datosOrdenPago#">
		</cfif>
		
		
		<cfset NL= Chr(10)>
		
		<cfloop collection="#datosOrdenPago#" item="k" >

			<cfset line ="">
			
			<cfif trim(datosOrdenPago[k].a_TransferenciaP_id) eq ''>
				<cfthrow message="[ERROR] No se puede asociar (#datosOrdenPago[k].q_nombre_destino#) con cuenta de destino, TESTPID = ( #datosOrdenPago[k].a_TransferenciaP_id# )">
			</cfif>
			
			<!--- Codigo de tipo de operacion (SPEI-02,TERCEROS-04,ELSE-00) --->
				<cfif trim(datosOrdenPago[k].q_operacion) eq ''>
					<cfthrow message="[ERROR] No se puede generar ya que no ha definido el codigo de dispersion de pagos para (#datosOrdenPago[k].a_codigo_pago#) en la cuenta (#BankData.BDescripcion# - #BankData.CBcodigo#)">
				</cfif>
				<cfset l_operacion = "#datosOrdenPago[k].q_operacion#">

			<!--- Clave_ID 13 char --->
				<cfif trim(datosOrdenPago[k].q_clave_id) eq ''>
					<cfthrow message="[ERROR] No se puede generar ya que el valor de Banco ID para el beneficiario (#datosOrdenPago[k].q_nombre_destino#) no ha sido configurado">
				</cfif>
				<cfset l_clave_id = "">
				<cfloop index = "i" from = "1" to = "13">
					<cfif Mid(datosOrdenPago[k].q_clave_id, i, 1) eq "">
						<cfset l_clave_id = "#l_clave_id# ">
					<cfelse>
						<cfset l_clave_id = "#l_clave_id##Mid(datosOrdenPago[k].q_clave_id, i, 1)#">
					</cfif>
				</cfloop>
			<!--- Cuenta Origen 20 digitos --->
				<cfset l_num_cuenta_origen = Trim(Mid(datosOrdenPago[k].q_num_cuenta_origen,1,20))>
				<cfif l_num_cuenta_origen eq ''>
					<cfthrow message="[ERROR] No se puede generar ya que el valor de Cuenta de Origen no ha sido configurado">
				</cfif>
				<cfloop index = "i" from = "#len(l_num_cuenta_origen)#" to = "19">
					<cfset l_num_cuenta_origen = "0#l_num_cuenta_origen#">
				</cfloop>
			<!--- Cuenta Destino 20 digitos --->
				<cfset l_num_cuenta_destino = Trim(Mid(datosOrdenPago[k].q_num_cuenta_destino,1,20))>
				<cfif l_num_cuenta_destino eq ''>
					<cfthrow message="[ERROR] No se puede generar ya que el valor de Cuenta de Destino para el beneficiario (#datosOrdenPago[k].q_nombre_destino#) no ha sido configurado">
				</cfif>
				<cfloop index = "i" from = "#len(l_num_cuenta_destino)#" to = "19">
					<cfset l_num_cuenta_destino = "0#l_num_cuenta_destino#">
				</cfloop>
			<!--- Importe 17 digitos con 4 decimales SIN PUNTO --->
				<cfset l_importe_INT = Trim(listToArray (datosOrdenPago[k].q_importe,".",false,false)[1])>
				<cfset l_importe =  Trim(listToArray (NumberFormat(datosOrdenPago[k].q_importe,"9.99"),".",false,false)[2])>
				<cfloop index = "i" from = "#len(l_importe)#" to = "4">
					<cfset l_importe = "#l_importe#0">
				</cfloop>
				<cfset l_importe = "#l_importe_INT##l_importe#">
				<cfloop index = "i" from = "#len(l_importe)#" to = "16">
					<cfset l_importe = "0#l_importe#">
				</cfloop>
			<!--- Referencia 7 digitos--->
				<cfset l_referencia = Trim(Mid(datosOrdenPago[k].q_referencia,1,8))>
				<cfloop index = "i" from = "#len(l_referencia)#" to = "6">
					<cfset l_referencia = "0#l_referencia#">
				</cfloop>
			<!--- Descripcion default "NULL." 29 chars --->
				<cfset l_descripcion = Trim(Mid(datosOrdenPago[k].q_descripcion,1,29))>
				<cfif l_descripcion eq ""><cfset l_descripcion=".NULL."></cfif>
				<cfloop index = "i" from = "#len(l_descripcion)#" to = "29">
					<cfset l_descripcion = "#l_descripcion# ">
				</cfloop>
			<!--- RFC con espacio al final y 14 caracteres completado con 1's al inicio--->
				<cfset l_rfc = Trim(Mid(datosOrdenPago[k].q_rfc,1,13))>
				<cfif l_rfc eq ''>
					<cfthrow message="[ERROR] No se puede generar ya que el valor de RFC de la Empresa no ha sido configurado">
				</cfif>
				<cfloop index = "i" from = "#len(l_rfc)#" to = "13">
					<cfset l_rfc = "1#l_rfc#">
				</cfloop>
				<cfset l_rfc = "#l_rfc# ">
			<!--- IVA 14 digitos con 4 decimales SIN PUNTO --->
				<cfset l_iva_amount = datosOrdenPago[k].q_iva>
				<cfset l_iva_INT = Trim(listToArray (l_iva_amount,".",false,false)[1])>
				<cftry> 
					<cfset l_iva =  Trim(listToArray(l_iva_amount,".",false,false)[2])> 
					<cfcatch> <cfset l_iva = 0> </cfcatch>
				</cftry>
				<cfloop index = "i" from = "#len(l_iva)#" to = "4">
					<cfset l_iva = "#l_iva#0">
				</cfloop>
				<cfset l_iva = "#l_iva_INT##l_iva#">
				<cfloop index = "i" from = "#len(l_iva)#" to = "13">
					<cfset l_iva = "0#l_iva#">
				</cfloop>
			<!--- Instruccion de pago 39 chars --->
				<cfset l_instruccion = "#Trim(Mid(datosOrdenPago[k].q_instruccion,1,39))#">
				<cfif l_instruccion eq ""> <cfset l_instruccion =".NULL."> </cfif>
				<cfloop index = "i" from = "#len(l_instruccion)#" to = "38">
					<cfset l_instruccion ="#l_instruccion# ">
				</cfloop>
			<!--- Fecha actual formato ddmmyyyy --->
				<cfset l_fecha_aplicacion = "#Trim(datosOrdenPago[k].q_fecha_aplicacion)#">
			<!--- Nombre de Destinatario 70 chars --->
				<cfset l_nombre_destino = "#Trim(Mid(datosOrdenPago[k].q_nombre_destino,1,70))#">
				<cfloop index = "i" from = "#len(l_nombre_destino)#" to = "69">
					<cfset l_nombre_destino ="#l_nombre_destino# ">
				</cfloop>
			
			<cfif arguments.debug>
				<cfset line = "#line##l_operacion#|">
				<cfset line = "#line##l_clave_id#|">
				<cfset line = "#line##l_num_cuenta_origen#|">
				<cfset line = "#line##l_num_cuenta_destino#|">
				<cfset line = "#line##l_importe#|">
				<cfset line = "#line##l_referencia#|">
				<cfset line = "#line##l_descripcion#|">
				<cfset line = "#line##l_rfc#|">
				<cfset line = "#line##l_iva#|">
				<cfset line = "#line##l_instruccion#|">
				<cfset line = "#line##l_fecha_aplicacion#|">
				<cfset line = "#line##l_nombre_destino#|"> 
			<cfelse>
				<cfset line = "#line##l_operacion#">
				<cfset line = "#line##l_clave_id#">
				<cfset line = "#line##l_num_cuenta_origen#">
				<cfset line = "#line##l_num_cuenta_destino#">
				<cfset line = "#line##l_importe#">
				<cfset line = "#line##l_referencia#">
				<cfset line = "#line##l_descripcion#">
				<cfset line = "#line##l_rfc#">
				<cfset line = "#line##l_iva#">
				<cfset line = "#line##l_instruccion#">
				<cfset line = "#line##l_fecha_aplicacion#">
				<cfset line = "#line##l_nombre_destino#">
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
