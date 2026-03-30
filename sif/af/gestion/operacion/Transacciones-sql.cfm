<cfset params="?sql=1">
<cfif (isdefined("form.Alta"))>
	<cftransaction>
	<cfquery name="rsCFuncional" datasource="#session.dsn#">
		select CFuncional.CFid, CFuncional.Ocodigo, CFuncional.Dcodigo
		from CFuncional
			inner join HDContables 
				on HDContables.Ecodigo = CFuncional.Ecodigo
				and HDContables.Ocodigo = CFuncional.Ocodigo 
				and Eperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GATperiodo#">
				and Emes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GATmes#">
				and Cconcepto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Cconcepto#">
				and Edocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Edocumento#">
		where CFuncional.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
		  and CFuncional.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	</cfquery>
	<cfif rsCFuncional.recordcount eq 0>
		<cf_errorCode	code = "50074" msg = "El Centro Funcional seleccionado no corresponde con la oficina del Asiento Contable">
	</cfif>
	<cfquery name="rsHDContables" datasource="#session.dsn#">
		select he.IDcontable from HEContables he
		where he.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and he.Eperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GATperiodo#">
		  and he.Emes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GATmes#">
		  and he.Cconcepto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Cconcepto#">
		  and he.Edocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Edocumento#">
	</cfquery>
	<cfif rsHDContables.recordcount eq 0>
		<cf_errorCode	code = "50075" msg = "No se encontró el asiento contable, Proceso Cancelado!">
	</cfif>
	<cfif (isdefined("form.Aid") and len(trim(form.Aid)) and form.Aid gt 0)
			and (0.00+Replace(form.GATmonto,',','','all') GTE 0)
			and not (isdefined("form.GATvutil") and len(trim(form.GATvutil)))>
		<cf_errorCode	code = "50076" msg = "Error de definición de valores, Cuando el monto es positivo y el activo existe requiere definir un valor de vida útil. Proceso Cancelado!">		
	<cfelseif (isdefined("form.Aid") and len(trim(form.Aid)) and form.Aid gt 0)
			and (0.00+Replace(form.GATmonto,',','','all') LT 0)
			and not (isdefined("form.AFRmotivo") and len(trim(form.AFRmotivo)) and form.AFRmotivo GT 0)>
		<cf_errorCode	code = "50077" msg = "Error de definición de valores, Cuando el monto es negativo y el activo existe requiere definir un motivo de retiro. Proceso Cancelado!">		
	</cfif>
	<cfquery name="rsinsert" datasource="#session.dsn#">
		insert into GATransacciones (
			Ecodigo, Cconcepto, GATperiodo, GATmes, Edocumento, IDcontable, GATfecha, GATdescripcion, Ocodigo, ACid, ACcodigo, AFMid, AFMMid, GATserie, GATplaca, GATfechainidep, GATfechainirev, CFid, CRCCid, CRTDid, DEid, GATmonto, AFRmotivo, GATvutil, fechaalta, BMUsucodigo, CFcuenta, AFCcodigo, GATestado, GATReferencia )
		values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">, 
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Cconcepto#" null="#form.Cconcepto eq -10#">, 
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GATperiodo#">, 
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GATmes#">, 
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Edocumento#" null="#form.Cconcepto eq 'NA'#">, 
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsHDContables.IDcontable#">, 
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.GATfecha)#">, 
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.GATdescripcion#">, 
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCFuncional.Ocodigo#">, 
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ACid#">, 
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ACcodigo#">, 
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFMid#">, 
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFMMid#">, 
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.GATserie#" null="#(len(trim(form.GATserie)) eq 0)#">, 
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.GATplaca#">, 
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.GATfechainidep)#">, 
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.GATfechainirev)#">, 
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">, 
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CRCCid#">, 
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CRTDid#">, 
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">, 		
		<cfqueryparam cfsqltype="cf_sql_money" value="#Replace(form.GATmonto,',','','all')#">, 
		<cfif isdefined("form.Aid") and len(trim(form.Aid)) and form.Aid gt 0>
			<cfif (0.00+Replace(form.GATmonto,',','','all') GTE 0)
					and (isdefined("form.GATvutil") and len(trim(form.GATvutil)))>
				null, <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GATvutil#">, 
			<cfelseif (0.00+Replace(form.GATmonto,',','','all') LT 0)
					and (isdefined("form.AFRmotivo") and len(trim(form.AFRmotivo)) and form.AFRmotivo GT 0)>
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFRmotivo#">, 0, 
			</cfif>
		<cfelse>
			null,
			0,
		</cfif>
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFcuenta#">, 
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFCcodigo#">,
		1,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.GATreferencia#" null="#(len(trim(form.GATreferencia)) eq 0)#"> )
		<cf_dbidentity1>
	</cfquery>
	<cf_dbidentity2 name="rsinsert">
	</cftransaction>
	<cfset params=params&"&GATid="&rsinsert.identity>
<cfelseif isdefined("form.Cambio") or isdefined("form.Siguiente")>
	<cfif (isdefined("form.Aid") and len(trim(form.Aid)) and form.Aid gt 0)
			and (0.00+Replace(form.GATmonto,',','','all') GTE 0)
			and not (isdefined("form.GATvutil") and len(trim(form.GATvutil)))>
		<cf_errorCode	code = "50076" msg = "Error de definición de valores, Cuando el monto es positivo y el activo existe requiere definir un valor de vida útil. Proceso Cancelado!">		
	<cfelseif (isdefined("form.Aid") and len(trim(form.Aid)) and form.Aid gt 0)
			and (0.00+Replace(form.GATmonto,',','','all') LT 0)
			and not (isdefined("form.AFRmotivo") and len(trim(form.AFRmotivo)) and form.AFRmotivo GT 0)>
		<cf_errorCode	code = "50077" msg = "Error de definición de valores, Cuando el monto es negativo y el activo existe requiere definir un motivo de retiro. Proceso Cancelado!">		
	</cfif>
	<cfquery name="rsCFuncional" datasource="#session.dsn#">
		select CF.CFid, CF.Ocodigo, CF.Dcodigo
		  from CFuncional CF
			 inner join GATransacciones GAT
			    on GAT.Ecodigo = CF.Ecodigo
			   and GAT.Ocodigo = CF.Ocodigo
			   and GAT.ID 	   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GATid#">
		where CF.CFid    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
		  and CF.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">	
	</cfquery>
	<cfif rsCFuncional.recordcount eq 0>
		<cf_errorCode	code = "50074" msg = "El Centro Funcional seleccionado no corresponde con la oficina del Asiento Contable">
	</cfif>
	<cfquery datasource="#session.dsn#">
		update GATransacciones 
		set Cconcepto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Cconcepto#" null="#form.Cconcepto eq -10#">, 
			GATperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GATperiodo#">, 
			GATmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GATmes#">, 
			Edocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Edocumento#" null="#form.Cconcepto eq 'NA'#">, 
			GATfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.GATfecha)#">, 
			GATdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.GATdescripcion#">, 
			<!--- Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCFuncional.Ocodigo#">, --->
			ACid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ACid#">, 
			ACcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ACcodigo#">, 
			AFMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFMid#">, 
			AFMMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFMMid#">, 
			GATserie = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.GATserie#" null="#(len(trim(form.GATserie)) eq 0)#">, 
			GATplaca = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.GATplaca#">, 
			GATfechainidep = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.GATfechainidep)#">, 
			GATfechainirev = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.GATfechainirev)#">, 
			CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">, 
			CRCCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CRCCid#">, 
			CRTDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CRTDid#">, 
			DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">, 
			GATmonto = <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(form.GATmonto,',','','all')#">, 
			<cfif isdefined("form.Aid") and len(trim(form.Aid)) and form.Aid gt 0>
				<cfif (0.00+Replace(form.GATmonto,',','','all') GTE 0)
						and (isdefined("form.GATvutil") and len(trim(form.GATvutil)))>
					AFRmotivo = null, 
					GATvutil = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GATvutil#">, 
				<cfelseif (0.00+Replace(form.GATmonto,',','','all') LT 0)
						and (isdefined("form.AFRmotivo") and len(trim(form.AFRmotivo)) and form.AFRmotivo GT 0)>
					AFRmotivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFRmotivo#">, 
					GATvutil = 0, 
				</cfif>
			<cfelse>
				AFRmotivo = null, 
				GATvutil = 0, 
			</cfif>
			BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
			CFcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFcuenta#">, 
			AFCcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFCcodigo#">,
			GATestado = 1,
			GATReferencia = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.GATreferencia#" null="#(len(trim(form.GATreferencia)) eq 0)#">,
			GATdiferencias = 0
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		  and ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GATid#">
	</cfquery>
	<cfif isdefined("form.Cambio")>
		<cfset params=params&"&GATid="&form.GATid>
	<cfelseif isdefined("form.Siguiente")>
		<cfquery name="rsSiguiente" datasource="#session.dsn#">
			select ID as GATid
			from GATransacciones
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			and GATperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.GATPeriodo#">
			and GATmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.GATMes#">
			and Cconcepto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Cconcepto#">
			and Edocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Edocumento#">
			and ID > <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.GATid#">
		</cfquery>
		<cfset params=params&"&GATid="&rsSiguiente.GATid>
	</cfif>
<cfelseif (isdefined("form.Baja"))>
	<cfquery datasource="#session.dsn#">
		delete from GATransacciones 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		  and ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GATid#">
	</cfquery>
<cfelseif (isdefined("form.BajaTodos"))>
	<cfquery datasource="#session.dsn#">
		insert into GABTransacciones (ID, Ecodigo, Cconcepto, GATperiodo, GATmes, Edocumento, GATfecha, GATdescripcion, Ocodigo, ACid, ACcodigo, AFMid, AFMMid, GATserie, GATplaca, GATfechainidep, GATfechainirev, CFid, GATmonto, fechaalta, BMUsucodigo, Referencia1, Referencia2, Referencia3, AFCcodigo, CFcuenta, GATestado, IDcontable, AFRmotivo, GATReferencia, DEid, CRTDid, CRCCid, GATvutil, GATeliminado)
		(
		select
			ID, Ecodigo, Cconcepto, GATperiodo, GATmes, Edocumento, GATfecha, GATdescripcion, Ocodigo, ACid, ACcodigo, AFMid, AFMMid, GATserie, GATplaca, GATfechainidep, GATfechainirev, CFid, GATmonto, fechaalta, BMUsucodigo, Referencia1, Referencia2, Referencia3, AFCcodigo, CFcuenta, GATestado, IDcontable, AFRmotivo, GATReferencia, DEid, CRTDid, CRCCid, GATvutil, 1 as GATeliminado
		from GATransacciones
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and Cconcepto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Cconcepto#">
		and Edocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDocumento#">
		and GATperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GATperiodo#">
		and GATmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GATmes#">
		)
	</cfquery>
	<cfquery datasource="#session.dsn#">
		delete from GATransacciones 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			and Cconcepto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Cconcepto#">
			and Edocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDocumento#">
			and GATperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GATperiodo#">
			and GATmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GATmes#">
	</cfquery>
<cfelseif (isdefined("form.Nuevo"))>	
	<cfset params=params&"&Nuevo=Nuevo">
<cfelseif (isdefined("form.Completar"))>	
	<cfif isdefined("form.GATid") and len(trim(form.GATid))>
		<cfset params=params&"&GATid="&form.GATid>
	</cfif>
	<cfset params=params&"&Completar=Completar">
</cfif>
<cfset params=params&"&GATPeriodo=#Form.GATPeriodo#">
<cfset params=params&"&GATMes=#Form.GATMes#">
<cfset params=params&"&Cconcepto=#Form.Cconcepto#">
<cfset params=params&"&EDocumento=#Form.EDocumento#">

<cflocation url="Transacciones.cfm#params#">


