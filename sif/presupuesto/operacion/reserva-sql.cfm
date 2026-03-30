<cfif isdefined("url.OP")>
	<cfif isdefined("url.CPCanoMes")>
		<cfset url.CPCano = mid(url.CPCanoMes,1,4)>
		<cfset url.CPCmes = mid(url.CPCanoMes,5,2)>
	</cfif>
	<cfif isdefined('url.CFcodigo') and len(trim(#url.CFcodigo#)) gt 0>
       <cfquery name="rsCFid" datasource="#session.DSN#">
        select CFid, CFcuentainversion, CFdescripcion from CFuncional
         where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
         and CFcodigo =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.CFcodigo)#">
       </cfquery>
         <cfset VarCFid = rsCFid.CFid>
    <cfelseif isdefined('url.CFid') and len(trim(#url.CFid#)) gt 0>
       <cfset VarCFid= url.CFid>
    </cfif>
   	<cfset LvarError = "">
	<cfobject component="sif.Componentes.AplicarMascara" name="mascara">
	<cftry>
	<!----cambio AF--->
	<cfif trim(url.CPDDtipoItem) EQ 'F'>
		<cfif rsCFid.recordcount gt 0 and trim(rsCFid.CFcuentainversion) NEQ ''>
			<cfset vCPCuenta = "#rsCFid.CFid#">
            <cfset vCPformato = "#rsCFid.CFcuentainversion#">
            <cfset vCPCPdescripcion = "#rsCFid.CFdescripcion#">

           <cfif find("?",vCPformato)>
              	<cfif isdefined('url.ACid') and len(trim(#url.ACid#)) gt 0>
                   	<cfset vACid = trim(#url.ACid#)>
                    <cfquery name="rsmask" datasource="#session.DSN#">
                    	select cuentac
                        from AClasificacion
                        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                        and ACid = <cfqueryparam cfsqltype="cf_sql_integer" value="#vACid#">
	                </cfquery>
                    <cfif rsmask.recordCount gt 0 and len(trim(#rsmask.cuentac#)) gt 0>
                    	<cfset vCPformato = mascara.AplicarMascara(#vCPformato#,trim(#rsmask.cuentac#))>
	                <cfelse>
                       	<cfthrow message="No está definida la cuenta complemento en la clasificación">
                    </cfif>
                <cfelse>
                    	<cfthrow message="No está definida la clasificación">
				</cfif>
			</cfif>
		<cfelse>
        	<cfthrow message="El Centro Funcional no tiene Cuenta de Inversión o Compras de Activos Fijos">
		</cfif>
		<cfset LvarCFformato = vCPformato>
	<cfelseif trim(url.CPDDtipoItem) EQ 'S'>
		<cfset LvarCFformato = mascara.fnComplementoItem(session.Ecodigo, VarCFid, -1, url.CPDDtipoItem, "", url.Cid, "","","","","",session.Ecodigo,-1,url.CPDEid)>
	<cfelseif trim(url.CPDDtipoItem) EQ 'C'>

<!--- Validacion de clasificacion enviada --->


			<cfquery name="rsClasificaciones" datasource="#session.DSN#">
				select Ccodigo
				from Clasificaciones
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				and Ccodigoclas = <cfqueryparam cfsqltype="cf_sql_char" value="#url.Ccodigoclas#">
			</cfquery>
			<cfset Ccodigo=#rsClasificaciones.Ccodigo#>

		<cfset TipItm=trim(url.CPDDtipoItem)>
		<cfset LvarCFformato = mascara.fnComplementoItem(session.Ecodigo, VarCFid, -1, TipItm, "", 0, "","","","","",session.Ecodigo,-1,url.CPDEid,Ccodigo)>
	</cfif>
		<!---cambio AF--->
	<cfcatch type="any">
		<cfset LvarError = cfcatch.Message>
    </cfcatch>
    </cftry>

    <cfif LvarError EQ "">
		<cfset LvarFecha = now()>
        <cfquery name="rsCFuncional" datasource="#session.DSN#">
            select Ocodigo
              from CFuncional c
             where c.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#VarCFid#">
        </cfquery>

        <!--- Obtener Cuenta --->
        <cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera"
                  method="fnGeneraCuentaFinanciera"
                  returnvariable="LvarError">
                    <cfinvokeargument name="Lprm_CFformato" 		value="#LvarCFformato#"/>
                    <cfinvokeargument name="Lprm_fecha" 			value="#LvarFecha#"/>
                    <cfinvokeargument name="Lprm_TransaccionActiva" value="no"/>
        </cfinvoke>
	</cfif>

	<cfset LvarDisponible = 0>
	<cfset LvarControlAbierto = true>
	<cfif LvarError EQ 'NEW' OR LvarError EQ 'OLD'>
		<!--- trae el id de la cuenta financiera --->
		<cfquery name="rsTraeCuenta" datasource="#session.DSN#">
			select a.CFcuenta, p.CPcuenta, p.CPformato, p.CPdescripcion
			from CFinanciera a
				inner join CPVigencia b
					 on a.CPVid     = b.CPVid
					and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarFecha#"> between b.CPVdesde and b.CPVhasta
				left join CPresupuesto p
					 on p.CPcuenta = a.CPcuenta
			where a.Ecodigo   = #session.Ecodigo#
			  and a.CFformato = '#LvarCFformato#'
		</cfquery>

		<cfif rsTraeCuenta.CPcuenta NEQ "">
			<cfinvoke component="sif.Componentes.PRES_Presupuesto"
				method			= "CalculoDisponible"
				returnvariable	= "LstrDisponible">

				<cfinvokeargument name="CPPid" 			value="#url.CPPid#">
				<cfinvokeargument name="CPCano" 		value="#url.CPCano#">
				<cfinvokeargument name="CPCmes" 		value="#url.CPCmes#">
				<cfinvokeargument name="CPcuenta" 		value="#rsTraeCuenta.CPcuenta#">
				<cfinvokeargument name="Ocodigo" 		value="#rsCFuncional.Ocodigo#">
				<cfinvokeargument name="TipoMovimiento"	value="RP">
				<cfinvokeargument name="Conexion" 		value="#Session.DSN#">
				<cfinvokeargument name="Ecodigo" 		value="#Session.Ecodigo#">
			</cfinvoke>

			<cfquery name="rsMesAuxiliar" datasource="#session.DSN#">
				select a.Pvalor as Ano, m.Pvalor as Mes
				  from Parametros m, Parametros a
				 where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				   and a.Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="50">
				   and m.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				   and m.Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="60">
			</cfquery>

			<cfset LvarDisponible = LstrDisponible.Disponible>
			<cfset LvarControlAbierto = (LstrDisponible.CPCPtipoControl EQ "0")>
			<cfif URL.CPCanomes GT rsMesAuxiliar.Ano*100+rsMesAuxiliar.Mes>
				<cfset LvarMesFuturo = " (Mes Futuro)">
			<cfelse>
				<cfset LvarMesFuturo = "">
			</cfif>
		</cfif>
	</cfif>

	<cfoutput>
	<script language="javascript" type="text/javascript">
		<cfif LvarError neq 'NEW' and LvarError neq 'OLD'>
			window.parent.fnSetCuenta ("","","");
			window.parent.document.form1.mensaje.value = '#JSStringFormat(LvarError)#';
		<cfelseif rsTraeCuenta.CPcuenta EQ "">
			window.parent.fnSetCuenta ("","#LvarCFformato#","");
			window.parent.document.form1.mensaje.value = 'No existe Cuenta de Presupuesto';
		<cfelseif LvarControlAbierto>
			window.parent.fnSetCuenta ("#rsTraeCuenta.CPcuenta#","#trim(rsTraeCuenta.CPformato)#","#rsTraeCuenta.CPdescripcion#");
			window.parent.document.form1.mensaje.value = 'Control Abierto, Disponible #LvarMesFuturo#: ' + '#LSNumberFormat(LvarDisponible, ',9.00')#';
		<cfelseif LvarDisponible LTE 0>
			window.parent.fnSetCuenta ("","#trim(rsTraeCuenta.CPformato)#","#rsTraeCuenta.CPdescripcion#");
			window.parent.document.form1.mensaje.value = 'No tiene Presupuesto Disponible #LvarMesFuturo#: ' + '#LSNumberFormat(LvarDisponible, ',9.00')#';
		<cfelse>
			window.parent.fnSetCuenta ("#rsTraeCuenta.CPcuenta#","#trim(rsTraeCuenta.CPformato)#","#rsTraeCuenta.CPdescripcion#");
			window.parent.document.form1.mensaje.value = 'Máximo Disponible #LvarMesFuturo#: ' + '#LSNumberFormat(LvarDisponible, ',9.00')#';
		</cfif>

		window.parent.document.form1.disponible.value = '#LSNumberFormat(LvarDisponible, ',9.00')#';
		<cfif LvarControlAbierto>
			window.parent.document.form1.validarDisponible.value = '0';
		<cfelse>
			window.parent.document.form1.validarDisponible.value = '1';
		</cfif>
	</script>
	</cfoutput>
	<cfabort>
</cfif>

<cfif isdefined("form.CPCanoMes")>
	<cfset form.CPCano = mid(form.CPCanoMes,1,4)>
	<cfset form.CPCmes = mid(form.CPCanoMes,5,2)>
</cfif>

<cfparam name="Form.CPDEtc" default="1.00">
<cfset form.CPDEtc = replace(form.CPDEtc,",","","ALL")>
<cfif isdefined("form.CPDDmonto")>
	<cfset form.CPDDmontoOri = replace(form.CPDDmontoOri,",","","ALL")>
	<cfset form.CPDDmonto = replace(form.CPDDmonto,",","","ALL")>
</cfif>


<cfif not isdefined("Form.btnNuevo")>
	<cfif isdefined("Form.btnAgregarE")>
		<cfquery name="rsNumeroDoc" datasource="#Session.DSN#">
			select rtrim(CPDEnumeroDocumento) as CPDEnumeroDocumento
			from CPDocumentoE
			where CPDEid = (
				select max(CPDEid)
				from CPDocumentoE
				where Ecodigo = #Session.Ecodigo#
				and CPDEtipoDocumento = 'R'
			)
		</cfquery>
		<cfif rsNumeroDoc.recordCount EQ 0>
			<cfset numero = 1>
		<cfelse>
			<cfset numero = rsNumeroDoc.CPDEnumeroDocumento + 1>
		</cfif>
		<cftransaction>
			<cfquery name="rsDocsProvision" datasource="#Session.DSN#">
				insert into CPDocumentoE (Ecodigo, CPPid, CPDEfechaDocumento, CPCano, CPCmes, CPDEfecha, CPDEtipoDocumento, CPDEnumeroDocumento, CPDEdescripcion, Usucodigo, CFidOrigen, CPDEaplicado,
							CPDEsuficiencia, CPDEcontrato,CPDEreferencia, Mcodigo, CPDEtc,
							CPDEjustificacion
				)
				values (
					#Session.Ecodigo#,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPPid#">,
					<cfqueryparam cfsqltype="cf_sql_date" value="#LsParseDateTime(Form.CPDEfechaDocumento)#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#DatePart('yyyy', LsParseDateTime(Form.CPDEfechaDocumento))#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#DatePart('m', LsParseDateTime(Form.CPDEfechaDocumento))#">,
					<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="R">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#numero#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CPDEdescripcion#">,
					#session.usucodigo#,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFid#">,
					0,
					<cfparam name="form.CPDEsuficiencia" default="0">
					<cfqueryparam cfsqltype="cf_sql_bit" value="#form.CPDEsuficiencia#">,
                    <cfparam name="form.CPDEcontrato" default="0">
					<cfqueryparam cfsqltype="cf_sql_bit" value="#form.CPDEcontrato#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CPDEreferencia#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#Form.CPDEtc#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CPDEjustificacion#">
				)
				<cf_dbidentity1 datasource="#Session.DSN#">
			</cfquery>
			<cf_dbidentity2 datasource="#Session.DSN#" name="rsDocsProvision">
		</cftransaction>
		<cfset Form.CPDEid = rsDocsProvision.identity>
		<cfset modo="CAMBIO">

	<cfelseif isdefined("Form.btnBajaE")>

		<cftransaction>
			<cfquery name="rsDocsProvision" datasource="#Session.DSN#">
				delete from CPDocumentoD
				where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDEid#">
			</cfquery>

			<cfquery name="rsDocsProvision" datasource="#Session.DSN#">
				delete from CPDocumentoE
				where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDEid#">
				and CPDEtipoDocumento = 'R'
			</cfquery>
			<cfset modo="BAJA">
		</cftransaction>

	<cfelseif isdefined("Form.btnCambiarE")>
		<cf_dbtimestamp
			datasource="#session.dsn#"
			table="CPDocumentoE"
			redirect="reserva.cfm"
			timestamp="#form.ts_rversion#"
			field1="CPDEid,numeric,#form.CPDEid#">

		<cfquery name="rsDocsProvision" datasource="#Session.DSN#">
			update CPDocumentoE set
				CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPPid#">,
				CPDEfechaDocumento = <cfqueryparam cfsqltype="cf_sql_date" value="#LsParseDateTime(Form.CPDEfechaDocumento)#">,
				CPCano = <cfqueryparam cfsqltype="cf_sql_integer" value="#DatePart('yyyy', LsParseDateTime(Form.CPDEfechaDocumento))#">,
				CPCmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#DatePart('m', LsParseDateTime(Form.CPDEfechaDocumento))#">,
				CPDEdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CPDEdescripcion#">,
				CFidOrigen = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFid#">,
				CPDEfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
				<cfparam name="form.CPDEsuficiencia" default="0">
				CPDEsuficiencia = #form.CPDEsuficiencia#,
                <cfparam name="form.CPDEcontrato" default="0">
				CPDEcontrato = #form.CPDEcontrato#,
				CPDEreferencia	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CPDEreferencia#">,
				Mcodigo			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">,
				CPDEtc			= <cfqueryparam cfsqltype="cf_sql_float" value="#Form.CPDEtc#">,
				Usucodigo = #session.usucodigo#,
				CPDEjustificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CPDEjustificacion#">
			where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDEid#">
		</cfquery>

		<cfquery datasource="#Session.DSN#">
			update CPDocumentoD set
				CPDDmonto = round(CPDDmontoOri * #Form.CPDEtc#,2),
				CPDDsaldo = round(CPDDmontoOri * #Form.CPDEtc#,2)
			where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDEid#">
		</cfquery>

		<cfset modo="CAMBIO">
	<cfelseif isdefined("Form.btnAgregarD")>

		<cftransaction>
			<cfset fnAltaDetalle()>
		</cftransaction>
		<cfset Form.CPDDid = rsInsDetProvision.identity>
		<cfset modo="CAMBIO">

	<cfelseif isdefined("Form.btnBajaD")>
		<cfquery name="rsDelDetProvision" datasource="#session.DSN#">
			delete from CPDocumentoD
			 where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDEid#">
			<cfif form.CPDDtipoItem EQ "D">
			   and CPDClinea = 	(
									select CPDClinea from CPDocumentoD
									 where CPDDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDDid#">
								)
			<cfelse>
			   and CPDDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDDid#">
			</cfif>
		</cfquery>
		<cfquery name="rsDocsProvision" datasource="#Session.DSN#">
			delete from CPDocumentoD
			where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDEid#">
			and CPDDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDDid#">
		</cfquery>
		<cfset modo="CAMBIO">

	<cfelseif isdefined("Form.btnCambiarD")>
		<cf_dbtimestamp
			datasource="#session.dsn#"
			table="CPDocumentoD"
			redirect="reserva.cfm"
			timestamp="#form.ts_rversionDet#"
			field1="CPDDid,numeric,#form.CPDDid#">

		<cfset fnCambioDetalle()>
		<cfset modo="CAMBIO">

	<cfelseif isdefined("Form.btnNuevoD")>
		<cfset modo="CAMBIO">

	<cfelseif isdefined("Form.btnAplicar")>
		<!--- Validar Diponibles --->
		<cfquery name="rsMesAuxiliar" datasource="#session.DSN#">
			select Pvalor
			from Parametros
			where Ecodigo = #Session.Ecodigo#
			and Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="60">
		</cfquery>

		<cfquery name="rsPeriodoAuxiliar" datasource="#session.DSN#">
			select Pvalor
			from Parametros
			where Ecodigo = #Session.Ecodigo#
			and Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="50">
		</cfquery>


        <cfquery name="rsAñoMesAuxiliar" datasource="#session.DSN#">
			select a.Pvalor * 100 + m.Pvalor as AñoMesAux
		    from Parametros m, Parametros a
		    where a.Ecodigo = #Session.Ecodigo#
		    and a.Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="50">
            and m.Ecodigo = #Session.Ecodigo#
            and m.Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="60">
		</cfquery>


        <cfquery name="rsAñoMes" datasource="#Session.DSN#">
			select substring(convert(varchar,convert(datetime,b.CPDEfechaDocumento),112),1,6) as AñoMesSufi
			from CPDocumentoD a, CPDocumentoE b, CPresupuesto c
			where a.CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDEid#">
			and a.Ecodigo = #Session.Ecodigo#
			and a.CPDEid = b.CPDEid
			and c.Ecodigo = #Session.Ecodigo#
			and a.CPcuenta = c.CPcuenta
		</cfquery>

        <!---Valida que la suficiencia no sea para meses anteriores al actual en Auxiliares--->

        <cfloop query="rsAñoMes">
            <cfif (rsAñoMes.AñoMesSufi LT rsAñoMesAuxiliar.AñoMesAux)>
              <cfthrow message="La Fecha #AñoMesSufi# de la Suficiencia es Menor a la fecha Actual de Auxiliares. Favor de Corregir la Fecha del Documento!">
    	</cfif>
  		</cfloop>



		<cfquery name="rsDetalles" datasource="#Session.DSN#">
			select a.CPCano,
				   a.CPCmes,
				   a.CPcuenta,
				   a.Ocodigo,
				   b.CPPid,
				   case a.CPCmes when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Septiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end as MesDescripcion,
				   c.CPformato as Cuenta,
				   coalesce(c.CPdescripcionF,c.CPdescripcion) as DescCuenta,
				   a.CPDDmonto
			from CPDocumentoD a, CPDocumentoE b, CPresupuesto c
			where a.CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDEid#">
			and a.Ecodigo = #Session.Ecodigo#
			and a.CPDEid = b.CPDEid
			and c.Ecodigo = #Session.Ecodigo#
			and a.CPcuenta = c.CPcuenta
			order by a.CPDDlinea
		</cfquery>


		<cfloop query="rsDetalles">
			<!--- Si el mes de la Provisión Presupuestaria es distinta al mes auxiliar --->
			<cfif not (Form.CPCano EQ rsPeriodoAuxiliar.Pvalor and Form.CPCmes EQ rsMesAuxiliar.Pvalor)>
				<cfinvoke component="sif.Componentes.PRES_Presupuesto"
					method="CalculoDisponible"
					returnvariable="LvarDisponible">

					<cfinvokeargument name="CPPid" value="#rsDetalles.CPPid#">
					<cfinvokeargument name="CPCano" value="#rsDetalles.CPCano#">
					<cfinvokeargument name="CPCmes" value="#rsDetalles.CPCmes#">
					<cfinvokeargument name="CPcuenta" value="#rsDetalles.CPcuenta#">
					<cfinvokeargument name="Ocodigo" value="#rsDetalles.Ocodigo#">
					<cfinvokeargument name="TipoMovimiento" value="RP">

					<cfinvokeargument name="Conexion" value="#Session.DSN#">
					<cfinvokeargument name="Ecodigo" value="#Session.Ecodigo#">

				</cfinvoke>
				<cfif rsDetalles.CPDDmonto GT LvarDisponible.Disponible>
					<cfif LvarDisponible.Disponible LT LvarDisponible.mes.Autorizado>
						<cf_errorCode	code = "50497"
										msg  = "El monto de la Provisión Presupuestaria en la cuenta @errorDat_1@ para el mes de @errorDat_2@ sobrepasa al monto disponible"
										errorDat_1="#rsDetalles.DescCuenta#"
										errorDat_2="#rsDetalles.MesDescripcion#"
						>
					<cfelse>
						<cf_errorCode	code = "50498"
										msg  = "El monto de la Provisión Presupuestaria en la cuenta @errorDat_1@ para el mes de @errorDat_2@ sobrepasa al monto autorizado en el mes"
										errorDat_1="#rsDetalles.DescCuenta#"
										errorDat_2="#rsDetalles.MesDescripcion#"
						>
					</cfif>
				</cfif>
			</cfif>
		</cfloop>

		<cfscript>
			LobjControl = CreateObject("component", "sif.Componentes.PRES_Presupuesto");
			LobjControl.CreaTablaIntPresupuesto(session.dsn,false,false,true);
		</cfscript>

		<cftransaction>
			<cfquery name="rsInsertarTablaIntPresupuesto" datasource="#Session.DSN#">
				insert into #Request.intPresupuesto# (
					ModuloOrigen,
					NumeroDocumento,
					NumeroReferencia,
					FechaDocumento,
					AnoDocumento,
					MesDocumento,

					NumeroLinea,
					CPPid,
					CPCano,
					CPCmes,
					CPcuenta,
					Ocodigo,
					TipoMovimiento,

					Mcodigo,
					MontoOrigen,
					TipoCambio,
					Monto,

					NAPreferencia,
					LINreferencia
				)

				select 'PRCO' as ModuloOrigen,
					   a.CPDEnumeroDocumento as NumeroDocumento,
					   case a.CPDEtipoDocumento when 'R' then 'Provisión' when 'L' then 'Liberación' when 'T' then 'Traslado' when 'TE' then 'Traslado Aut.Externa' else '' end as NumeroReferencia,
					   a.CPDEfechaDocumento as FechaDocumento,
					   a.CPCano as AnoDocumento,
					   a.CPCmes as MesDocumento,

					   b.CPDDlinea as NumeroLinea,
					   b.CPPid,
					   b.CPCano,
					   b.CPCmes,
					   b.CPcuenta,
					   (select Ocodigo from CFuncional where CFid=coalesce(b.CFid,a.CFidOrigen)) as Ocodigo,
					   case a.CPDEtipoDocumento when 'R' then 'RP' when 'L' then 'RP' when 'T' then 'T' when 'TE' then 'TE' else '' end as TipoMovimiento,

					   c.Mcodigo,
					   b.CPDDmonto as MontoOrigen,
					   1.00 as TipoCambio,
					   b.CPDDmonto as Monto,

					   null as NAPreferencia,
					   null as LINreferencia
				from CPDocumentoE a, CPDocumentoD b, CPresupuestoPeriodo c
				where a.CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDEid#">
				and a.Ecodigo = #Session.Ecodigo#
				and a.Ecodigo = b.Ecodigo
				and a.CPDEid = b.CPDEid
				and b.Ecodigo = c.Ecodigo
				and b.CPPid = c.CPPid
			</cfquery>

			<cfquery name="rsEncabezado" datasource="#Session.DSN#">
				select CPDEnumeroDocumento,
					   CPDEfechaDocumento,
					   case CPDEtipoDocumento when 'R' then 'Provisión' when 'L' then 'Liberación' when 'T' then 'Traslado' when 'TE' then 'Traslado Aut.Externa' else '' end as NumeroReferencia,
					   CPCano,
					   CPCmes
				from CPDocumentoE
				where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDEid#">
				and Ecodigo = #Session.Ecodigo#
			</cfquery>

			<cfscript>
				LvarNAP = LobjControl.ControlPresupuestario('PRCO', rsEncabezado.CPDEnumeroDocumento, rsEncabezado.NumeroReferencia, rsEncabezado.CPDEfechaDocumento, rsEncabezado.CPCano, rsEncabezado.CPCmes);
			</cfscript>
			<cfif LvarNAP LT 0>
				<cfquery name="updDoc" datasource="#Session.DSN#">
					update CPDocumentoE
					set NRP = #-LvarNAP#,
						CPDEfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
						Usucodigo = #session.usucodigo#
					where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDEid#">
					and Ecodigo = #Session.Ecodigo#
				</cfquery>
			<cfelse>
				<cfquery name="updDoc" datasource="#Session.DSN#">
					update CPDocumentoE
					set NAP = #LvarNAP#,
						CPDEaplicado = 1,
						CPDEfechaAprueba = <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
						UsucodigoAprueba = #session.usucodigo#
					where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDEid#">
					and Ecodigo = #Session.Ecodigo#
				</cfquery>
			</cfif>
			<cfset modo="ALTA">
		</cftransaction>
		<cfif LvarNAP LT 0>
			<!---
			<cf_errorCode	code = "50499"
							msg  = "RECHAZO EN CONTROL PRESUPUESTARIO: El documento generó un Número de Rechazo Presupuestario NRP = @errorDat_1@ porque existe un exceso de presupuesto no autorizado"
							errorDat_1="#abs(LvarNAP)#"
			>
			--->
			<cflocation url="/cfmx/sif/presupuesto/consultas/ConsNRP.cfm?ERROR_NRP=#abs(LvarNAP)#">
		</cfif>

         <cfelseif isdefined("form.btnNuevoE")>
  <cfset modo = "ALTA">
	</cfif>
</cfif>

<cfoutput>
<form action="reserva.cfm" method="post" name="sql">
	<cfif modo EQ "CAMBIO">
	   	<input name="CPDEid" type="hidden" value="#CPDEid#">
	</cfif>
	<input name="PageNum" type="hidden" value="<cfif isdefined("Form.PageNum")><cfoutput>#Form.PageNum#</cfoutput></cfif>">
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>


<cffunction name="fnCambioDetalle">
	<cfif form.CPDDtipoItem  EQ "D">
		<cftransaction>
			<cfquery datasource="#session.DSN#">
				delete from CPDocumentoD
				 where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDEid#">
				   and CPDClinea	=
							(
								select CPDClinea
								  from CPDocumentoD
								 where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDEid#">
								   and CPDDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDDid#">
							)
			</cfquery>
			<cfset fnAltaDetalle()>
		</cftransaction>
	<cfelse>
      <cfif isdefined('Form.CFidDet') and len(trim(#Form.CFidDet#)) gt 0 >
        <cfset LvarCFid = Form.CFidDet>
      <cfelse>
        <cfset LvarCFid = Form.CFid>
       </cfif>

		<cfquery name="rsUpdDetProvision" datasource="#Session.DSN#">
			update CPDocumentoD set
				CPCano = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.CPCano#">,
				CPCmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.CPCmes#">,
				CPcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPcuenta#">,
				CPDDmontoOri = <cfqueryparam cfsqltype="cf_sql_money" value="#Form.CPDDmontoOri#">,
				CPDDmonto = <cfqueryparam cfsqltype="cf_sql_money" value="#Form.CPDDmonto#">,
				CPDDsaldo = <cfqueryparam cfsqltype="cf_sql_money" value="#Form.CPDDmonto#">,
				CPDDtipoItem = <cf_jdbcQuery_param cfsqltype="cf_sql_char" scale="0" value="#Form.CPDDtipoItem#">
				<cfif form.CPDDtipoItem EQ "0">
					, Cid = <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0"	value="null">
					, CFid = <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0"	value="null">
				<cfelseif form.CPDDtipoItem EQ "S">
					, Cid = <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#Form.Cid#">
					, CFid = <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#LvarCFid#">
                <cfelseif form.CPDDtipoItem EQ "F">
                   	, ACcodigo = <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#Form.ACcodigo#">
                    , ACid = <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#Form.ACid#">
                <cfelseif form.CPDDtipoItem EQ "C">
					, CFid = <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#LvarCFid#">
					, Ccodigoclas = <cf_jdbcQuery_param cfsqltype="cf_sql_char"  value="#Form.ccodigoclas#"	voidNull>
				</cfif>
              where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDEid#">
			  and CPDDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDDid#">
		</cfquery>
	</cfif>
</cffunction>

<cffunction name="fnAltaDetalle">
	<cfif form.CPDDtipoItem  EQ "D">
		<cfset form.CPDDtipoItem  = "S">
	<cfelse>
		<cfset form.CPDCid = "">
	</cfif>
	<cfquery name="selectDocsProvision" datasource="#Session.DSN#">
		select
			a.CPPid,
			b.Ocodigo
		from CPDocumentoE a, CFuncional b
		where a.CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDEid#">
		and a.Ecodigo = #Session.Ecodigo#
		and a.Ecodigo = b.Ecodigo
		and a.CFidOrigen = b.CFid
	</cfquery>
   	<!--- Obtiene la oficina correspondiente al CFid del Encabezado (se ignora si es distribución o servicio) --->
	<cfset LvarOcodigo = selectDocsProvision.Ocodigo>
	<cfset LvarCPPid = selectDocsProvision.CPPid>
    <cfif isdefined('Form.CFcodigoDet') and len(trim(#Form.CFcodigoDet#)) gt 0 AND isdefined('Form.CPDDtipoItem') and form.CPDDtipoItem EQ "S">
      	<!--- Obtiene la oficina correspondiente al CFid del Servicio (se ignora si es ditribución) --->
       <cfquery name="rsCFid" datasource="#session.DSN#">
         select CFid, Ocodigo from CFuncional
         where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
         and CFcodigo =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CFcodigoDet#">
       </cfquery>
       <cfif rsCFid.recordCount gt 0 and len(trim(#rsCFid.CFid#)) gt 0>
           <cfset LvarCFid =  rsCFid.CFid>
           <cfset LvarOcodigo =  rsCFid.Ocodigo>
       <cfelse>
        <cfthrow message="No se ha podido obtener el CFid con Codigo: #Form.CFcodigoDet#">
       </cfif>
    <cfelse>
      <cfset LvarCFid = Form.CFid>
    </cfif>

<cfif form.CPDDtipoItem eq 'S' and isdefined('form.Ccodigo2') and form.Ccodigo2 neq ''>
	<cfinvoke 	component="sif.Componentes.PRES_Distribucion"
				method="GenerarDistribucion"
				returnVariable="qryDistribucion"

				Ccodigo="#form.Ccodigo2#"
				CFid="#LvarCFid#"
				CPDCid="#form.CPDCid#"
			    Cantidad="0"
			    Monto="#form.CPDDmontoOri#"
		        Presupuesto="true"
	>
<cfelse>
	<cfinvoke 	component="sif.Componentes.PRES_Distribucion"
				method="GenerarDistribucion"
				returnVariable="qryDistribucion"

				Cid="#form.Cid#"
				CFid="#LvarCFid#"
				CPDCid="#form.CPDCid#"
			    Cantidad="0"
			    Monto="#form.CPDDmontoOri#"
		        Presupuesto="true"
	>
</cfif>


	<cfif form.CPDDtipoItem  EQ "S" and isdefined('form.Ccodigoclas') and form.Ccodigoclas neq ''>
		<cfset form.CPDDtipoItem  = "C">
	</cfif>
	<cfset LvarLinea_1 = "">
	<cfloop query="qryDistribucion">
		<!--- Chequear Existencia de Presupuesto Asignado --->
		<cfquery name="rsCheck" datasource="#Session.DSN#">
			select 1, CPDEtc
			from CPDocumentoE a, CPresupuestoControl b
			where a.Ecodigo = #Session.Ecodigo#
			and a.CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDEid#">
			and a.Ecodigo = b.Ecodigo
			and a.CPPid = b.CPPid
			and b.CPCano = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.CPCano#">
			and b.CPCmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.CPCmes#">
			and b.CPcuenta =
			<cfif form.CPDCid EQ "">
			   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#Form.CPcuenta#"		voidNull>
			<cfelse>
			   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#qryDistribucion.IdCuenta#"		voidNull>
			</cfif>
		</cfquery>
		<cfif rsCheck.recordCount EQ 0>
        	<cfquery name="rsCuentaBad" datasource="#Session.DSN#">
            	select CPformato
                from CPresupuesto
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
                and CPcuenta =
				<cfif form.CPDCid EQ "">
                   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#Form.CPcuenta#"		voidNull>
                <cfelse>
                   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#qryDistribucion.IdCuenta#"		voidNull>
                </cfif>
            </cfquery>
			<cfthrow message="La Cuenta de Presupuesto #rsCuentaBad.CPformato# no ha sido Formulada para el Mes #Form.CPCano#/#Form.CPCmes#">
			<cf_errorCode	code = "50496" msg = "La cuenta de presupuesto no ha sido Formulada.">
		</cfif>

		<cfquery name="rsNextDetail" datasource="#Session.DSN#">
			select coalesce(max(CPDDlinea), 0)+1 as linea
			from CPDocumentoD
			where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDEid#">
		</cfquery>

		<cfif form.CPDCid NEQ "">
        	<!--- Obtiene la oficina correspondiente al CFid de la distribución --->
           <cfquery name="rsCFid" datasource="#session.DSN#">
                 select CFid, Ocodigo from CFuncional
                  where CFid = #qryDistribucion.CFid#
           </cfquery>
           <cfset LvarOcodigo =  rsCFid.Ocodigo>
		</cfif>


		<cfquery name="rsInsDetProvision" datasource="#Session.DSN#">
			insert INTO CPDocumentoD (
				Ecodigo, CPDEid, CPDDlinea,
				CPDDtipo, CPPid, CPCano,
				CPCmes, CPcuenta, CPDDmontoOri, CPDDmonto,
				CPDDsaldo, Ocodigo,
				CPDDtipoItem
				<cfif form.CPDDtipoItem EQ "S" and (not isdefined('form.Ccodigoclas') or form.Ccodigoclas eq '')>
					, Cid, CFid
				</cfif>
				, CPDCid
                <cfif form.CPDDtipoItem EQ "F">
                	,ACcodigo,ACid,CFid
                </cfif>
                <cfif form.CPDDtipoItem EQ "A">
                	,Alm_Aid,Aid
                </cfif>
				<cfif form.CPDDtipoItem EQ "C" or (form.CPDDtipoItem EQ "S" and isdefined('form.Ccodigoclas') and form.Ccodigoclas neq '')>
                	,CFid ,Ccodigoclas
                </cfif>
			)
			VALUES (
			   #session.Ecodigo#,
			   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#Form.CPDEid#">,
			   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#rsNextDetail.linea#">,
			   1,
			   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#LvarCPPid#"			voidNull>,
			   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#Form.CPCano#"		voidNull>,
			   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#Form.CPCmes#"		voidNull>,
			<cfif form.CPDCid EQ "">
			   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#Form.CPcuenta#"		voidNull>,
			<cfelse>
			   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#qryDistribucion.IdCuenta#"		voidNull>,
			</cfif>
			   <cf_jdbcQuery_param cfsqltype="cf_sql_money"             value="#qryDistribucion.monto#"	voidNull>,
			   round(<cf_jdbcQuery_param cfsqltype="cf_sql_money"       value="#qryDistribucion.monto*rsCheck.CPDEtc#">,2),
			   round(<cf_jdbcQuery_param cfsqltype="cf_sql_money"       value="#qryDistribucion.monto*rsCheck.CPDEtc#">,2),
			   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#LvarOcodigo#"		voidNull>,
		<cfif form.CPDDtipoItem EQ "S" and isdefined('form.Ccodigoclas') and form.Ccodigoclas neq ''>
			'C'
		<cfelse>
			   <cf_jdbcQuery_param cfsqltype="cf_sql_char" 				value="#Form.CPDDtipoItem#">
		</cfif>
				<cfif form.CPDDtipoItem EQ "S" and (not isdefined('form.Ccodigoclas') or form.Ccodigoclas eq '')>
					, <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#Form.Cid#">
					, <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#qryDistribucion.CFid#">
				</cfif>

				,<CF_jdbcquery_param cfsqltype="cf_sql_numeric"  value="#form.CPDCid#" null="#form.CPDCid EQ ""#">
                <cfif form.CPDDtipoItem EQ "F">
                    ,<cf_jdbcQuery_param cfsqltype="cf_sql_integer"  value="#Form.ACcodigo#"		voidNull>
                    ,<cf_jdbcQuery_param cfsqltype="cf_sql_integer"  value="#Form.ACid#"			voidNull>
					,<cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#qryDistribucion.CFid#">
                </cfif>
                <cfif form.CPDDtipoItem EQ "A">
                    ,<cf_jdbcQuery_param cfsqltype="cf_sql_integer"  value="#Form.Alm_Aid#"		voidNull>
                    ,<cf_jdbcQuery_param cfsqltype="cf_sql_integer"  value="#Form.Aid#"			voidNull>
                </cfif>
				<cfif form.CPDDtipoItem EQ "C" or (form.CPDDtipoItem EQ "S" and isdefined('form.Ccodigoclas') and form.Ccodigoclas neq '')>
					, <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#qryDistribucion.CFid#">
                    ,<cf_jdbcQuery_param cfsqltype="cf_sql_char"  value="#Form.ccodigoclas#"	voidNull>
                </cfif>
			)
			<cf_dbidentity1 datasource="#Session.DSN#" returnvariable="LvarLinea">
		</cfquery>
		<cf_dbidentity2 datasource="#Session.DSN#" name="rsInsDetProvision" returnvariable="LvarLinea">

		<cfif form.CPDCid NEQ "">
			<cfif LvarLinea_1 EQ "">
				<cfset LvarLinea_1 = LvarLinea>
			</cfif>
			<cfquery datasource="#session.DSN#">
				update CPDocumentoD
				   set CPDClinea = #LvarLinea_1#
				 where CPDDid = #LvarLinea#
			</cfquery>
		</cfif>
	</cfloop>
</cffunction>
