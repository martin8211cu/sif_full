<cfset msg = "">
<cfset _id = "">
<cfset modo = "">
<cftry>
	<cfif isDefined('form.btnNuevo') or isDefined('form.Nuevo')>
		<cfset modo = "alta">
	</cfif>
	
	<cfif isDefined('form.ALTA')>

		<cfquery name="rsTransaccion" datasource="#Session.dsn#">
			select * from CRCTipoTransaccion where id = #form.tipotransid#
		</cfquery>
		<cfquery name="rsCuenta" datasource="#Session.dsn#">
			select * from CRCCuentas where id = #form.id#
		</cfquery>
		
		<cfquery datasource="#Session.dsn#">
			INSERT INTO CRCAjusteCuenta
				(CRCCuentasid
				,Observaciones
				,CRCTipoTransaccionid
				,TipoTransaccion
				,TipoMov
				,Monto
				,Aplicada
				,createdat
				,Ecodigo)
			VALUES
				(#form.id#
				,'#form.Observaciones#'
				,#form.tipotransid#
				,'#rsTransaccion.Codigo#'
				,'#rsTransaccion.TipoMov#'
				,#lsParseNumber(form.Monto)#
				,0
				,getDate()
				,#Session.Ecodigo#)
				<cf_dbidentity1 datasource="#session.dsn#">
		</cfquery>
		<cf_dbidentity2 datasource="#Session.dsn#" name="ins">
		<cfset modo = "cambio">
		<cfset _id = ins.identity>
	</cfif>

	<cfif isDefined('form.cambio')>

		<cfquery name="rsTransaccion" datasource="#Session.dsn#">
			select * from CRCTipoTransaccion where id = #form.tipotransid#
		</cfquery>
		<cfquery name="rsCuenta" datasource="#Session.dsn#">
			select * from CRCCuentas where id = #form.id#
		</cfquery>
		
		<cfquery datasource="#Session.dsn#">
			Update CRCAjusteCuenta
				set CRCCuentasid = #form.id#
				,Observaciones = '#form.Observaciones#'
				,CRCTipoTransaccionid = #form.tipotransid#
				,TipoTransaccion = '#rsTransaccion.Codigo#'
				,TipoMov = '#rsTransaccion.TipoMov#'
				,Monto = #lsParseNumber(form.Monto)#
				,updatedat = getDate()
			Where id = #form.id_aj#
		</cfquery>
		<cfset modo = "cambio">
		<cfset _id = form.id_aj>
	</cfif>
	
	<cfif isDefined('form.baja')>

		<cfquery datasource="#Session.dsn#">
			delete CRCAjusteCuenta
			Where id = #form.id_aj#
		</cfquery>
		
	</cfif>
	
	<cfif isDefined('form.btnAplicar') or isDefined('form.Aplicar')>
		<cfset _ajustes = form.id_aj>
		<cfif isDefined("form.chk")>
			<cfset _ajustes = form.chk>
		</cfif>
		
		<cfset debug = "false">
<cftry>
	<cftransaction>
			<cfloop list="#_ajustes#" item="aj">
				
				<cfquery name="rsAjuste" datasource="#Session.dsn#">
					select * from CRCAjusteCuenta
					Where id = #aj#
				</cfquery>	
	<cfif debug><cfdump var='#rsAjuste#' abort='false' label="Datos de Ajuste"></cfif> 
				<!--- OBTENCION DE ID PARA TIPO DE TRANSACCION --->
				<cfquery name="q_TipoTransaccion" datasource="#Session.DSN#">
					select id, Codigo,TipoMov
					from   CRCTipoTransaccion
					where  Codigo = '#rsAjuste.TipoTransaccion#'
						and afectaPagos = 1
						and	TipoMov = 'D'
						and Ecodigo = #Session.Ecodigo#
				</cfquery>	
	<cfif debug><cfdump var='#q_TipoTransaccion#' abort='false' label="Datos de Ajuste"></cfif> 			
				
				<cfset crcTransaccion = createObject("component", "crc.Componentes.pago.CRCTransaccionPago").init(dns=session.Ecodigo, Ecodigo=Session.Ecodigo)>
				<cfset crcTransaccion.Create_CRCDESGLOSE()>
				<cfset lavarFechaPago = crcTransaccion.formatStringToDate("#LSDateFormat(now(),'dd/mm/yyyy')#")>
				<cfif q_TipoTransaccion.recordcount eq 0>
					<cfthrow errorcode="#q_TipoTransaccion.Codigo#" type="TransaccionException" message = "Tipo de Transaccion [#trim(q_TipoTransaccion.Codigo)#] No reconocida">
				</cfif>	
				<cfset montoTotal = rsAjuste.Monto>
				<cfset tranID = crcTransaccion.crearTransaccion(CuentaID=rsAjuste.CRCCuentasid,
										Tipo_TransaccionID = q_TipoTransaccion.id,
										Fecha_Transaccion= lavarFechaPago,
										Monto = montoTotal,
										Observaciones = rsAjuste.Observaciones)>
	<cfif debug><cfdump var='#tranID#' abort='false' label="Datos de Ajuste"></cfif> 
				<cfset cortes = crcTransaccion.aPagoMC(
							CuentaID = rsAjuste.CRCCuentasid,
							Monto = rsAjuste.Monto,
							MontoDescuento = 0,
							FechaPago = lavarFechaPago,
							transaccionID = tranID,
							debug = debug,
							AplicaDescuento = false
				)> 
	
				<cfquery name="rsTran" datasource="#Session.DSN#">
					select  Monto ,Descuento 
					from CRCTransaccion
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#tranID#">
				</cfquery>
				<cfset lvarTotalPago = rsTran.Monto>
	
				<cfset crcTransaccion.caMccPorCorteCuenta(cortes= cortes ,CuentaID= rsAjuste.CRCCuentasid, acumularMontoPagado = true)>
	
	
				<cfset crcTransaccion.afectarCuenta(Monto= lvarTotalPago ,
											CuentaID= rsAjuste.CRCCuentasid ,
											CodigoTipoTransaccion= rsAjuste.TipoTransaccion ,
											TipoMovimiento= q_TipoTransaccion.TipoMov )>
	
	
	
				<cfset crcTransaccion.ajsuteEstadoCuentaPorPago(CuentaID= rsAjuste.CRCCuentasid)>
				
				<cfset objParams = createObject("component", "crc.Componentes.CRCParametros")>
				<cfset val = objParams.GetParametroInfo('30200505')>
				<cfif val.valor eq ''><cfthrow message="El parametro [30200505 - Concepto de Servicio por Pronto Pago] no esta definido"></cfif>
				<cfset valCF = objParams.GetParametroInfo('30300107')>
				<cfif valCF.valor eq ''><cfthrow message="El parametro [30300107 - Centro Funcional por Defecto] no esta definido"></cfif>
				
				<cfset crcGenerarNC= createObject("component", "crc.Componentes.pago.CRCGeneraNC")>
				<cfset crcGenerarNC.CreaNC(CentroFuncionalID=valCF.valor, ConceptoId=val.valor, Monto=lvarTotalPago)>

				<cfquery datasource="#Session.dsn#">
					Update CRCAjusteCuenta
						set Aplicada = 1
					Where id = #aj#
				</cfquery>
	
			</cfloop>
		</cftransaction>	
<cfcatch type="any">
	<cftransaction action="rollback">
	<cfrethrow>
</cfcatch>
</cftry>
	</cfif>
	
	<cfif isDefined('form.modo') and lcase(form.modo) eq 'cambio' and isDefined('form.id_aj')>
		<cfset modo = "cambio">
		<cfset _id = form.id_aj>
	</cfif>

	<cfif 1 eq 2>
		
		<cfdump  var="#form#" abort>
		<cfset aplicar = 1>
		<cfif isDefined('form.btnEliminar')> <cfset aplicar = 3> </cfif>

		<cfif aplicar eq 1>
			<cfquery name="q_Incidencias" datasource="#session.DSN#">
				select id,TransaccionPendiente from CRCIncidenciasCuenta 
					where 
						id in (#form.chk#) 
						and ecodigo = #session.ecodigo# 
						and TransaccionPendiente = 0
			</cfquery>

			<cfloop query="q_Incidencias">
				<cfinvoke  component ="crc.Componentes.incidencias.CRCIncidencia" method="AplicarIncidencia">
					<cfinvokeargument name="ID_Incidencia" value="#q_Incidencias.id#" >
				</cfinvoke>
			</cfloop>
		</cfif>

		
		<cfquery name="q_update" datasource="#session.DSN#">
			update CRCIncidenciasCuenta set 
					TransaccionPendiente = #aplicar#
				,	updatedat = CURRENT_TIMESTAMP
				,	Usumodif = #session.usucodigo#
				where id in (#form.chk#)
					and TransaccionPendiente = 0
					and ecodigo = #session.ecodigo#;
		</cfquery>

		<cfif aplicar eq 1>
			<cfset msg = "Se aplicaron correctamente">
		<cfelse>
			<cfset msg = "Se rechazaron correctamente">
		</cfif>
	</cfif>
<cfcatch>
	<cfrethrow>
	<cfset msg = "#cfcatch.message#">
</cfcatch>
</cftry>

<form name="form1" action="AplicarAjuste.cfm" method="post">
	<cfif _id neq "">
		<input type="hidden" name="id_aj" value="<cfoutput>#_id#</cfoutput>">
	</cfif>
	<input type="hidden" name="resultT" value="<cfoutput>#msg#</cfoutput>">
	<input type="hidden" name="modo" value="<cfoutput>#modo#</cfoutput>">
</form>
<script>
	document.form1.submit();
</script>
