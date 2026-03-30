<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_LaCaja" default = "La caja" returnvariable="LB_LaCaja" xmlfile = "CancelarEntregasEfectivo.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_NoEstaDefinida" default = "no esta definida" returnvariable="LB_NoEstaDefinida" xmlfile = "CancelarEntregasEfectivo.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_NoRecepcionEfe" default = "no está definida para RECEPCION de Efectivo" returnvariable="LB_NoRecepcionEfe" xmlfile = "CancelarEntregasEfectivo.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_NoDefCtaCaja" default = "No se ha definido la cuenta de la Caja" returnvariable="LB_NoDefCtaCaja" xmlfile = "CancelarEntregasEfectivo.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_NoDefCtaTransitoriaCaja" default = "No se ha definido la cuenta transitoria para Recepcion de Efectivo de la Caja" returnvariable="LB_NoDefCtaTransitoriaCaja" xmlfile = "CancelarEntregasEfectivo.xml">

<cfquery name="rsCajaEspecial" datasource="#session.dsn#">
	Select 
		CCHEMid, me.CCHid, CCHEMtipo, CCHEMnumero, convert(date,CCHEMfecha,103) as CCHEMfecha, me.Mcodigo, CCHEMmontoOri, CCHEMtipoCambio, 					        CCHEMfalta, GELid, CCHEMfuso, CCHEMdescripcion, CCHEMdepositadoPor, CCHEMCancelado, MSG_CCHEMCancelacion, m.Mnombre
		from CCHespecialMovs me
		inner join CCHica cc on me.CCHid = cc.CCHid
		inner join Monedas m on m.Mcodigo = me.Mcodigo
		where me.Ecodigo		= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and CCHEMtipo = 'E'	
		and CCHEMnumero = #url.NumDocumento#
</cfquery>

<!---<cfthrow message="ENTRA AQUI #url.Mensaje#, #url.NumDocumento#">--->
<cfif rsCajaEspecial.recordcount GT 0>
	<cfparam name="form.TipoCambio" default="1">
	<cfset LvarHoy 		= Now()>
	<cfset LvarCCHid 	= rsCajaEspecial.CCHid>
	<cfset LvarMonto	= replace(rsCajaEspecial.CCHEMmontoOri,",","","ALL")>
	<cfset LvarTC		= replace(rsCajaEspecial.CCHEMtipoCambio,",","","ALL")>
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select CCHid, CCHcodigo, CCHtipo, Mcodigo, CCHdescripcion, CFcuenta, CFcuentaRecepcion,
				Ocodigo
		  from CCHica ch
		  	inner join CFuncional cf
				on cf.CFid = ch.CFid
		 where ch.CCHid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCajaEspecial.CCHid#">
	</cfquery>
	<cfif rsSQL.CCHid EQ "">
		<cfthrow type="toUser" message="<cfoutput>#LB_LaCaja# id=#LvarCCHid# #LB_NoEstaDefinida#</cfoutput>">
	<cfelseif rsSQL.CCHtipo NEQ 2>
			<cfthrow type="toUser" message="<cfoutput>#LB_LaCaja# '#rsSQL.CCHcodigo# - #rsSQL.CCHdescripcion#' #LB_NoRecepcionEfe#</cfoutput>">
	<cfelseif rsSQL.CFcuenta EQ "">
		<cfthrow type="toUser" message="<cfoutput>#LB_NoDefCtaCaja#</cfoutput> '#rsSQL.CCHcodigo# - #rsSQL.CCHdescripcion#'">
	<cfelseif rsSQL.CFcuentaRecepcion EQ "">
		<cfthrow type="toUser" message="<cfoutput>#LB_NoDefCtaTransitoriaCaja#</cfoutput> '#rsSQL.CCHcodigo# - #rsSQL.CCHdescripcion#'">
	</cfif>
		
	<cfinvoke component="sif.Componentes.CG_GeneraAsiento" returnvariable="INTARC" method="CreaIntarc" />
	<cftransaction>
     <cfquery datasource="#session.dsn#">
	 	update CCHespecialMovs 
		set CCHEMCancelado = 1,
		MSG_CCHEMCancelacion = <cfqueryparam cfsqltype="varchar" value="#url.Mensaje#">
		where Ecodigo		= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and CCHEMtipo = 'E'	
		and CCHEMnumero = #rsCajaEspecial.CCHEMnumero#
	</cfquery>
	
	<cfquery datasource="#session.dsn#">
		update CCHImportes
		set CCHIsalidas	= CCHIsalidas	-	#rsCajaEspecial.CCHEMmontoOri#
		where CCHid = #rsCajaEspecial.CCHid#
		and Ecodigo		= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
        <!---
			Modificado: 30/06/2012
			Alejandro Bolaños APH-Mexico ABG
			
			CONTROL DE EVENTOS
		--->	
		<!--- Se valida el control de eventos para la transaccion de Liquidacion Gasto Empleado --->
		<cfinvoke component="sif.Componentes.CG_ControlEvento" 
			method="ValidaEvento" 
			Origen="TEGE"
			Transaccion="GERE"
			Conexion="#session.dsn#"
			Ecodigo="#session.Ecodigo#"
			returnvariable="varValidaEvento"
		/> 	
		<cfset varNumeroEvento = "">
		<cfif varValidaEvento GT 0>
        	<cfif isdefined("form.GECnumero") and len(form.GECnumero)>
	        	<cfset varGECnumero = form.GECnumero>
            <cfelse>
            	<cfset varGECnumero = 0>
            </cfif>
			<cfinvoke component="sif.Componentes.CG_ControlEvento" 
				method="CG_GeneraEvento" 
				Origen="TEGE"
				Transaccion="GERE"
				Documento="#rsCajaEspecial.CCHEMnumero#"
				Conexion="#session.dsn#"
				Ecodigo="#session.Ecodigo#"
				returnvariable="arNumeroEvento"
			/> 
			
			<cfif arNumeroEvento[3] EQ "">
				<cfthrow message="ERROR CONTROL EVENTO: No se obtuvo un control de evento valido para la operación">
			</cfif>
			<cfset varNumeroEvento = arNumeroEvento[3]>
			<cfset varIDEvento = arNumeroEvento[4]>
			
			<cfinvoke component="sif.Componentes.CG_ControlEvento" 
				method="CG_RelacionaEvento" 
				IDNEvento="#varIDEvento#"
				Origen="GECM"
				Transaccion="COM"
				Documento="#varGECnumero#"
				Conexion="#session.dsn#"
				Ecodigo="#session.Ecodigo#"
				returnvariable="arRelacionEvento"
			/> 
			 <cfif isdefined("arRelacionEvento") and arRelacionEvento[1]>
				<cfset varNumeroEvento = arRelacionEvento[4]>
			</cfif>
		</cfif>
    
		<!--- Debito a la cuenta de la Caja --->
		<cfquery datasource="#session.dsn#">
			insert into #INTARC# 
			( 
				INTORI, INTREL, INTDOC, INTREF, 
				INTFEC, Periodo, Mes, Ocodigo, 
				INTTIP, INTDES, 
				CFcuenta, Ccuenta,
				Mcodigo, INTMOE, INTCAM, INTMON,
                NumeroEvento
			)
			values (
				'TEGE', 1, '#rsCajaEspecial.CCHEMnumero#', 'CEE.RECEPCION',
				'#DateFormat(LvarHoy,"YYYYMMDD")#',#year(LvarHoy)#, #month(LvarHoy)#, 
				#rsSQL.Ocodigo#, 
				'C', 
				<cf_dbfunction name="spart" args="'CEE.CANCELACIÓN DE ENTRADA DE EFECTIVO CAJA #rsSQL.CCHcodigo# - #rsSQL.CCHdescripcion#'|1|80" delimiters="|">, 
				#rsSQL.CFcuenta#, 0,
				#rsSQL.Mcodigo#, #LvarMonto#, #LvarTC#, round(#LvarMonto# * #LvarTC#,2),
                '#varNumeroEvento#'
			)			   
		</cfquery>
		<!--- Credito a la cuenta Transitoria de Recepcion de Efectivo --->
		<cfquery datasource="#session.dsn#">
			insert into #INTARC# 
			( 
				INTORI, INTREL, INTDOC, INTREF, 
				INTFEC, Periodo, Mes, Ocodigo, 
				INTTIP, INTDES, 
				CFcuenta, Ccuenta,
				Mcodigo, INTMOE, INTCAM, INTMON,
                NumeroEvento
			)
			values (
				'TEGE', 1, '#rsCajaEspecial.CCHEMnumero#', 'CEE.RECEPCION',
				'#DateFormat(LvarHoy,"YYYYMMDD")#',#year(LvarHoy)#, #month(LvarHoy)#, 
				#rsSQL.Ocodigo#, 
				'D',
				<cf_dbfunction name="spart" args="'CEE.CANCELACIÓN RECEPCION EFECTIVO #rsCajaEspecial.CCHEMnumero#: #rsCajaEspecial.CCHEMdescripcion#'|1|80" delimiters="|">, 				#rsSQL.CFcuentaRecepcion#, 0,
				#rsSQL.Mcodigo#, #LvarMonto#, #LvarTC#, round(#LvarMonto# * #LvarTC#,2),
                '#varNumeroEvento#'
			)			   
		</cfquery>
		<cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="GeneraAsiento" returnvariable="LvarIDcontable">
			<cfinvokeargument name="Ecodigo" value="#session.Ecodigo#"/>
			<cfinvokeargument name="Eperiodo" value="#year(LvarHoy)#"/>
			<cfinvokeargument name="Emes" value="#month(LvarHoy)#"/>
			<cfinvokeargument name="Efecha" value="#LvarHoy#"/>
			<cfinvokeargument name="Oorigen" value="TEGE"/>
			<cfinvokeargument name="Ocodigo" value="#rsSQL.Ocodigo#"/>
			<cfinvokeargument name="Edocbase" value="#rsCajaEspecial.CCHEMnumero#"/>
			<cfinvokeargument name="Ereferencia" value="CEE.CANCELACIÓN RECEPCION"/>						
			<cfinvokeargument name="Edescripcion" value="CEE.CANCELACIÓN RECEPCION DE EFECTIVO #rsCajaEspecial.CCHEMnumero#: #rsCajaEspecial.CCHEMdescripcion#"/>
		</cfinvoke>
	</cftransaction>
	<cflocation url="CancelarEntregasEfectivo.cfm">
</cfif>





