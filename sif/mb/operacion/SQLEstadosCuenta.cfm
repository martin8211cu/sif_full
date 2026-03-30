<!---
	Modificado por Gustavo Fonseca H.
		Fecha 14-10-2005.
		Motivo: Se modifica el combo del detalle para que muestre las transacciones del banco.
	Modificado por Gustavo Fonseca H.
		Fecha 19-10-2005.
		Motivo: Se elimina la referencia del insert y del update, se cambia la forma en que se llena el campo
		DCtipo ahora utiliza el "form.BTEtipo".
 --->

<cfset LvarIrAEstadosCuenta ="EstadosCuenta.cfm">
<cfif isdefined("LvarTCESQLEstadosCuenta")>
	<cfset LvarIrAEstadosCuenta ="EstadosCuentaTCE.cfm">
	<cfif isdefined("LvarIrConciliacion")>
		<cfset LvarIrAEstadosCuenta ="EstadosCuentaCONCTCE.cfm">
 	</cfif>
</cfif>

<!--- actualizar fechas y saldo ini del encabezado --->
<cfif isdefined("form.updateEnc") and form.updateEnc EQ 1>
	<cfquery datasource="#session.DSN#" name="rsSaldoIni">
		SELECT DISTINCT
			ECsaldoini, ECdebitos, ECcreditos
		FROM ECuentaBancaria
		where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
	</cfquery>

	<!--- saldo inicial --->
	<cfset ECsaldoini=0>
	<cfif IsDefined("form.ECsaldoini")>
		<cfset ECsaldoini = replace(trim(form.ECsaldoini),",","","ALL")>
	</cfif>

	<cfif IsDefined("form.ECdesde")>
		<cfset desde = form.ECdesde>
	</cfif>
	<cfif IsDefined("form.EChasta")>
		<cfset hasta = form.EChasta>
	</cfif>
	<cfif rsSaldoIni.recordcount GT 0>

		<!---Formula de saldo final es: (saldoIni+debitos-creditos)--->
		<cfset LvarSaldoFinal=#ECsaldoini# + #rsSaldoIni.ECdebitos# - #rsSaldoIni.ECcreditos# >
		<!--- ACTUALIZAR ENCABEZADO --->
		<cfquery datasource="#session.DSN#">
			update ECuentaBancaria
			set ECsaldofin	= #LvarSaldoFinal#,
				ECsaldoini	= #ECsaldoini#
				<cfif IsDefined("desde")>
					,ECdesde = #LSParseDateTime(desde)#
				</cfif>
				<cfif IsDefined("hasta")>
					,EChasta = #LSParseDateTime(hasta)#
				</cfif>
			where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.ImportarECuenta.ECid#">
		</cfquery>
	<cfelse>
		<cf_dump var="No se encuentra saldo inicial para la cuenta bancaria.">
	</cfif>

	<!--- cargar la pagina normalmente --->
	<cfset NuevoD="0">
	<cfset form.NuevoD="0">

</cfif>


<cfparam name="modo" default="ALTA">
<cfparam name="modoDet" default="CAMBIO">
<cfif not isdefined("NuevoD") and not isdefined("form.Revisar")>

	<cfset cambioEncab = false>
	<cfif not (isDefined("Form.Bid") and Trim(Form.Bid) EQ Trim(Form._Bid)
		and isDefined("Form.CBid") and Trim(Form.CBid) EQ Trim(Form._CBid)
		and isDefined("Form.ECdescripcion") and Trim(Form.ECdescripcion) EQ Trim(Form._ECdescripcion)
		and isDefined("Form.ECdesde") and Trim(Form.ECdesde) EQ Trim(Form._ECdesde)
		and isDefined("Form.EChasta") and Trim(Form.EChasta) EQ Trim(Form._EChasta)
		and isDefined("Form.ECsaldoini") and Trim(Form.ECsaldoini) EQ Trim(Form._ECsaldoini)
		and isDefined("Form.ECsaldofin") and Trim(Form.ECsaldofin) EQ Trim(Form._ECsaldofin))>
		<cfset cambioEncab = true>
	</cfif>

	<cfif isDefined("Form.AgregarE")>
		<cftransaction>
			<cfquery name="rsConsulta" datasource="#session.DSN#">
				select 1
				from ECuentaBancaria
				where Bid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Bid#">
			    <cfif isdefined('Form.CBid') and len(trim(#Form.CBid#)) gt 0>
                    and CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CBid#">
                 <cfelseif isdefined('form.Id') and len(trim(#form.Id#)) gt 0>
                    and CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Id#">
                 </cfif>
				  and (ECdesde between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.ECdesde)#">
				  			  and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.EChasta)#">
				   or EChasta between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.ECdesde)#">
				  			  and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.EChasta)#">)
			</cfquery>
			<cfif isdefined('rsConsulta') and rsConsulta.RecordCount GT 0>
				<cfabort showerror="Ya existe un estado de cuenta para ese rango de fecha. Verifique.">
			</cfif>
			<cfquery name="ABC_EstadosCuenta" datasource="#Session.DSN#" >
				insert into ECuentaBancaria (Bid, ECfecha, CBid, ECsaldoini, ECsaldofin, ECdescripcion, ECusuario, ECdesde, EChasta, ECdebitos, ECcreditos, ECaplicado, EChistorico)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Bid#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
	 			  <cfif isdefined('Form.CBid') and len(trim(#Form.CBid#)) gt 0>
                      <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CBid#">,
                  <cfelseif isdefined('form.Id') and len(trim(#form.Id#)) gt 0>
                      <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Id#">,
                  </cfif>
					<cfqueryparam cfsqltype="cf_sql_money" value="#Form.ECsaldoini#">,
					<cfqueryparam cfsqltype="cf_sql_money" value="#Form.ECsaldoini#">, <!---igual al saldo inicial para que muestre el mismo cuando se entra al detalle y en caso de no insertar lineas de detalle--->
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ECdescripcion#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.usuario#">,
					<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.ECdesde)#">,
					<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.EChasta)#">,
					<cfqueryparam cfsqltype="cf_sql_money" value="#Form.ECdebitos#">,
					<cfqueryparam cfsqltype="cf_sql_money" value="#Form.ECcreditos#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="N">,
					<cfqueryparam cfsqltype="cf_sql_char" value="N">

				)
				<cf_dbidentity1 datasource="#session.DSN#">
			</cfquery>
			<cf_dbidentity2 datasource="#session.DSN#" name="ABC_EstadosCuenta">
		</cftransaction>
		<cfset modo="CAMBIO">
		<cfset modoDet="ALTA">

	<cfelseif isdefined("Form.BorrarE")>

		<cfquery name="ABC_EstadosCuenta" datasource="#Session.DSN#" >
			delete from CDBancos
			where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
		</cfquery>
		<cfquery name="ABC_EstadosCuenta" datasource="#Session.DSN#" >
			delete from CDLibros
			where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
		</cfquery>

		<cfquery name="ABC_EstadosCuenta" datasource="#Session.DSN#" >
			delete from DCuentaBancaria
			where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
		</cfquery>

		<cfquery name="ABC_EstadosCuenta" datasource="#Session.DSN#" >
			delete from ECuentaBancaria
			where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
		</cfquery>
		<cfset modo="ALTA">
		<cfset modoDet="ALTA">

	<cfelseif isdefined("Form.AgregarD")>
		<cftransaction>

			<cfif cambioEncab>
				<!---Redireccion EstadosCuenta.cfm o EstadosCuentaTCE.cfm--->
				<cf_dbtimestamp datasource="#session.dsn#"
					table="ECuentaBancaria"
					redirect="#LvarIrAEstadosCuenta#"
					timestamp="#form.timestampE#"
					field1="ECid"
					type1="numeric"
					value1="#Form.ECid#">

				<cfquery name="ABC_EstadosCuenta" datasource="#Session.DSN#" >
					update ECuentaBancaria set
						Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Bid#">,
					  <cfif isdefined('Form.CBid') and len(trim(#Form.CBid#)) gt 0>
                          CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CBid#">,
                      <cfelseif isdefined('form.Id') and len(trim(#form.Id#)) gt 0>
                          CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Id#">,
                      </cfif>
						ECdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ECdescripcion#">,
						ECusuario = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.usuario#">,
						ECdesde = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.ECdesde)#">,
						EChasta = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.EChasta)#">,
						ECsaldoini = <cfqueryparam cfsqltype="cf_sql_money" value="#form.ECsaldoini#">
					where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
				</cfquery>
			</cfif>


			<!--- <cfquery name="rsBTEcodigo" datasource="#session.DSN#">
				select BTEcodigo
				from BTransaccionesEq
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and Bid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Bid#">
					and BTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.BTid#">
			</cfquery>
			<cfif isdefined("rsBTEcodigo") and len(trim(rsBTEcodigo.BTEcodigo)) and rsBTEcodigo.recordcount EQ 1>
				<cfset LvarBTEcodigo = rsBTEcodigo.BTEcodigo>
			</cfif>--->

			<cfquery name="ABC_EstadosCuenta" datasource="#Session.DSN#" >
				insert into DCuentaBancaria (ECid, BTid, DCfecha, Documento,  DCReferencia, DCconciliado, DCmontoori, DCmontoloc, DCtipo, DCtipocambio, Ecodigo, Bid, BTEcodigo)
				values (
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Form.ECid#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">,
					<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.DCfecha)#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Form.Documento#">,
					 <cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Form.DCReferencia#">,<!--- --->
					'N',
					<cf_jdbcquery_param cfsqltype="cf_sql_money" value="#Form.DCmontoori#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_money" value="#Form.DCmontoloc#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Left(Form.BTEtipo, 1)#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_float" value="#Form.DCtipocambio#">,
					#session.Ecodigo#,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.Bid#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_char" value="#form.BTEcodigo#"><!---  --->
				)

			</cfquery>

			<cfif isdefined("LvarTCESQLEstadosCuenta")>
				<!---	actualiza los totales en el encabezado para TCE --->
				<cfquery name="ABC_EstadosCuenta" datasource="#Session.DSN#">
					update ECuentaBancaria set
						ECdebitos = coalesce((select sum(DCmontoori) from DCuentaBancaria
											  where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
											  and DCtipo = 'D'
						), 0),
						ECcreditos = coalesce((select sum(DCmontoori)*-1 from DCuentaBancaria
											  where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
											  and DCtipo = 'C'
						), 0),
						ECsaldofin = ECsaldoini + coalesce((select sum(DCmontoori) from DCuentaBancaria
											  where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
											  and DCtipo = 'D'
						), 0)
						-
						coalesce((select sum(DCmontoori) from DCuentaBancaria
											  where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
											  and DCtipo = 'C'
						), 0)
					where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
				</cfquery>
			<cfelse>
				<!---	actualiza los totales en el encabezado para Bancos --->
				<cfquery name="ABC_EstadosCuenta" datasource="#Session.DSN#">
					update ECuentaBancaria set
						ECdebitos = coalesce((select sum(DCmontoori) from DCuentaBancaria
											  where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
											  and DCtipo = 'D'
						), 0),
						ECcreditos = coalesce((select sum(DCmontoori) from DCuentaBancaria
											  where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
											  and DCtipo = 'C'
						), 0),
						ECsaldofin = ECsaldoini + coalesce((select sum(DCmontoori) from DCuentaBancaria
											  where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
											  and DCtipo = 'D'
						), 0)
						-
						coalesce((select sum(DCmontoori) from DCuentaBancaria
											  where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
											  and DCtipo = 'C'
						), 0)
					where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
				</cfquery>
			</cfif>
		</cftransaction>
		<cfset modo="CAMBIO">
		<cfset modoDet="ALTA">
	<cfelseif isdefined("Form.BorrarD")>

		<cfquery name="ABC_EstadosCuenta" datasource="#Session.DSN#" >
			delete from DCuentaBancaria
			where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
			and Linea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Linea#">
		</cfquery>

		<cfif isdefined("LvarTCESQLEstadosCuenta")>
			<!---	actualiza los totales en el encabezado para TCE --->
			<cfquery name="ABC_EstadosCuenta" datasource="#Session.DSN#">
				update ECuentaBancaria set
					ECdebitos = coalesce((select sum(DCmontoori) from DCuentaBancaria
										  where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
										  and DCtipo = 'D'
					), 0),
					ECcreditos = coalesce((select sum(DCmontoori)*-1 from DCuentaBancaria
										  where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
										  and DCtipo = 'C'
					), 0),
					ECsaldofin = ECsaldoini + coalesce((select sum(DCmontoori) from DCuentaBancaria
										  where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
										  and DCtipo = 'D'
					), 0)
					-
					coalesce((select sum(DCmontoori) from DCuentaBancaria
										  where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
										  and DCtipo = 'C'
					), 0)
				where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
			</cfquery>
		<cfelse>
			<!---	actualiza los totales en el encabezado para Bancos --->
			<cfquery name="ABC_EstadosCuenta" datasource="#Session.DSN#">
				update ECuentaBancaria set
					ECdebitos = coalesce((select sum(DCmontoori) from DCuentaBancaria
										  where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
										  and DCtipo = 'D'
					), 0),
					ECcreditos = coalesce((select sum(DCmontoori) from DCuentaBancaria
										  where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
										  and DCtipo = 'C'
					), 0),
					ECsaldofin = ECsaldoini + coalesce((select sum(DCmontoori) from DCuentaBancaria
										  where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
										  and DCtipo = 'D'
					), 0)
					-
					coalesce((select sum(DCmontoori) from DCuentaBancaria
										  where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
										  and DCtipo = 'C'
					), 0)
				where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
			</cfquery>

		</cfif>

		<cfset modo="CAMBIO">
		<cfset modoDet="ALTA">

	<cfelseif isdefined("Form.CambiarD")>
		<cfif cambioEncab>
        	<!---Redireccion EstadosCuenta.cfm o EstadosCuentaTCE.cfm--->
			<cf_dbtimestamp datasource="#session.dsn#"
				table="ECuentaBancaria"
				redirect="#LvarIrAEstadosCuenta#"
				timestamp="#form.timestampE#"
				field1="ECid"
				type1="numeric"
				value1="#Form.ECid#">

			<cfquery name="ABC_EstadosCuenta" datasource="#Session.DSN#" >
				update ECuentaBancaria set
					Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Bid#">,
				  <cfif isdefined('Form.CBid') and len(trim(#Form.CBid#)) gt 0>
                      CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CBid#">,
                  <cfelseif isdefined('form.Id') and len(trim(#form.Id#)) gt 0>
                      CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Id#">,
                  </cfif>
					ECdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ECdescripcion#">,
					ECusuario = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.usuario#">,
					ECdesde = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.ECdesde)#">,
					EChasta = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.EChasta)#">,
					ECsaldoini = <cfqueryparam cfsqltype="cf_sql_money" value="#form.ECsaldoini#">
				where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
			</cfquery>
  		</cfif>

        <!---Redireccion EstadosCuenta.cfm o EstadosCuentaTCE.cfm--->
		<cf_dbtimestamp datasource="#session.DSN#"
			table="DCuentaBancaria"
			redirect="#LvarIrAEstadosCuenta#"
			timestamp="#form.timestampD#"
			field1="ECid"
			type1="numeric"
			value1="#Form.ECid#"
			field2="Linea"
			type2="numeric"
			value2="#Form.Linea#">

		<cfquery name="ABC_EstadosCuenta" datasource="#Session.DSN#" >
			update DCuentaBancaria set
				<!--- BTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.BTid#">, --->
				DCfecha      = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.DCfecha)#">,
				Documento    = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Documento#">,
				DCReferencia = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.DCReferencia#">,<!--- --->
				DCmontoori   = <cfqueryparam cfsqltype="cf_sql_money" value="#Form.DCmontoori#">,
				DCmontoloc   = <cfqueryparam cfsqltype="cf_sql_money" value="#Form.DCmontoloc#">,
				DCtipo       = <cfqueryparam cfsqltype="cf_sql_char" value="#Left(Form.BTEtipo, 1)#">,
				DCtipocambio = <cfqueryparam cfsqltype="cf_sql_float" value="#Form.DCtipocambio#">,
				BTEcodigo    = <cfqueryparam cfsqltype="cf_sql_char" value="#form.BTEcodigo#">
			where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
			  and Linea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Linea#">
		</cfquery>

		<cfif isdefined("LvarTCESQLEstadosCuenta")>
			<!---	actualiza los totales en el encabezado para TCE --->
			<cfquery name="ABC_EstadosCuenta" datasource="#Session.DSN#">
				update ECuentaBancaria set
					ECdebitos = coalesce((select sum(DCmontoori) from DCuentaBancaria
										  where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
										  and DCtipo = 'D'
					), 0),
					ECcreditos = coalesce((select sum(DCmontoori)*-1 from DCuentaBancaria
										  where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
										  and DCtipo = 'C'
					), 0),
					ECsaldofin = ECsaldoini + coalesce((select sum(DCmontoori) from DCuentaBancaria
										  where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
										  and DCtipo = 'D'
					), 0)
					-
					coalesce((select sum(DCmontoori) from DCuentaBancaria
										  where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
										  and DCtipo = 'C'
					), 0)
				where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
			</cfquery>
		<cfelse>
			<!---	actualiza los totales en el encabezado para Bancos --->
			<cfquery name="ABC_EstadosCuenta" datasource="#Session.DSN#">
				update ECuentaBancaria set
					ECdebitos = coalesce((select sum(DCmontoori) from DCuentaBancaria
										  where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
										  and DCtipo = 'D'
					), 0),
					ECcreditos = coalesce((select sum(DCmontoori) from DCuentaBancaria
										  where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
										  and DCtipo = 'C'
					), 0),
					ECsaldofin = ECsaldoini + coalesce((select sum(DCmontoori) from DCuentaBancaria
										  where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
										  and DCtipo = 'D'
					), 0)
					-
					coalesce((select sum(DCmontoori) from DCuentaBancaria
										  where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
										  and DCtipo = 'C'
					), 0)
				where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
			</cfquery>

		</cfif>

		<cfset modo="CAMBIO">
		<cfset modoDet="CAMBIO">
	</cfif>
<cfelseif isdefined("form.Revisar") and len(trim(form.Revisar))>
	<cfloop index="LvarECid" list="#Form.chk#" delimiters=",">
    	<cfquery name="rsUpStatus" datasource="#session.dsn#">
        	update ECuentaBancaria set ECStatus = 1
			where  ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarECid#">
        </cfquery>
	</cfloop>
    <cfset LvarIrAEstadosCuenta = "listaEstadosCuentaTCE.cfm">
<cfelse>
	<cfset modo    = 'CAMBIO'>
	<cfset modoDet = 'ALTA' >
</cfif>
<!---Actualiza el status de la cuenta--->
<cfoutput>
	<cfif isdefined("Form.Status")>
		<cfquery name="rsUpdateStatus" datasource="#session.dsn#">
			update ECuentaBancaria set ECStatus = 1
			where  ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
		</cfquery>
 		<cfset modo    = 'CAMBIO'>
 		<form action="<cfoutput>#LvarIrAEstadosCuenta#</cfoutput>" method="post" name="sql">
		<input name="modo" type="hidden"   value="#modo#">
 		<input name="ECid" type="hidden" value="#Form.ECid#">
		</form>
	</cfif>
</cfoutput>

<cfoutput>
<!---Redireccion EstadosCuenta.cfm o EstadosCuentaTCE.cfm--->
 	<form action="<cfoutput>#LvarIrAEstadosCuenta#</cfoutput>" method="post" name="sql">
		<cfif not isdefined("form.Revisar")>
            <input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
            <input name="modoDet" type="hidden" value="<cfif isdefined("modoDet")>#modoDet#</cfif>">
            <input name="Bid" type="hidden" value="<cfif isdefined("Form.Bid") and len(trim(Form.Bid))>#Form.Bid#</cfif>">
            <cfif isdefined("form.CambiarD")>
                <input name="BTEcodigo" type="hidden" value="<cfif isdefined("Form.BTEcodigo") and len(trim(Form.BTEcodigo))>#Form.BTEcodigo#</cfif>">
            </cfif>

            <cfif isdefined("ABC_EstadosCuenta.identity")>
                <input name="ECid" type="hidden" value="<cfif isdefined("ABC_EstadosCuenta.identity")>#ABC_EstadosCuenta.identity#</cfif>">
            <cfelse>
                <input name="ECid" type="hidden" value="<cfif isdefined("Form.ECid") and not isDefined("Form.BorrarE")>#Form.ECid#</cfif>">
            </cfif>
            <cfif isdefined("Form.Linea")>
                <input name="Linea" type="hidden" value="#Form.Linea#">
            </cfif>
            <cfif isdefined("Form.Aplicar")>
                <input name="Aplicar" type="hidden" value="<cfif isdefined("Form.Aplicar")>#Form.Aplicar#</cfif>">
            </cfif>
        </cfif>
	</form>
</cfoutput>

<HTML>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
