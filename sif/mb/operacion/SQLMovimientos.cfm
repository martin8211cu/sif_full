
<!--- 	ULTIMA ACTUALIZACION 10/08/2005
		Versión Actualizada el 10 de Agosto de 2005 a nueva versión de fuentes.
		Actualizado por Dorian A.G.
		Utiliza Tags de Montos, Qforms, y Nuevos Tags creados a la fecha.
 --->

<!--- ========================================= --->
<!--- MANTENER NAVEGACION DE LA LISTA DE INICIO --->
<!--- ========================================= --->

<cfif isdefined("url.getImpCta") and len(trim(url.getImpCta)) gt 0>
		<cfquery name="rsImpuestos" datasource="#session.dsn#">
			select Icodigo, Idescripcion, c.CFcuenta, rtrim(c.CFformato) as CFformato,c.Cmayor,i.CFcuentaCxPAcred, c.Ccuenta,
				RIGHT(rtrim(ltrim(c.CFformato)),(len(rtrim(ltrim(c.CFformato))) - len(rtrim(ltrim(c.Cmayor))) -1 )) as Formato,
				c.CFdescripcion
			from Impuestos i
				inner join CFinanciera c
					on c.Ecodigo = i.Ecodigo
			where i.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and i.Icompuesto		= 0
			  and i.Icreditofiscal	= 1
			  <!--- Solo Impuestos Simples porque SP manual no maneja detalle de impuestos al generar contabilidad --->
			  and Icompuesto = 0
			  and c.CFcuenta = (select min(CFcuenta) from CFinanciera cf where cf.Ccuenta = coalesce(i.CcuentaCxPAcred,i.Ccuenta))
			  and i.Icodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.Icodigo#">
		</cfquery>
		<cfset data = {Cmayor="#rsImpuestos.Cmayor#", Cformato="#rsImpuestos.Formato#", Cdescripcion="#rsImpuestos.CFdescripcion#", CFcuenta="#rsImpuestos.CFcuentaCxPAcred#",
		Ccuenta="#rsImpuestos.Ccuenta#"}>
		<cfset serializedStr = serializeJSON(data)>
		<cfset writeoutput(serializedStr)>
		<cfabort>
</cfif>

<cfif isdefined('LvarTCE') and len(trim(#LvarTCE#)) gt 0><!---  varTCE  indica si es para TCE o bancos--->
<cfset _CBesTCE = 1>
<cfset _Pagina = 'TCEMovimientos.cfm'>
<cfset _PaginaLista = 'TCEListaMovimientos.cfm'>
		<cfquery name="getCBid" datasource="#session.dsn#"><!--- se obtiene la CBid(id de la cuenta bancaria) y el Bid(id de Bancos) en el caso que el que sea por tarjeta de crédito empresarial, la cual está relacionada con una tarjeta--->
			select cb.CBid,cb.Bid, cb.CBcodigo, tc.CBTCDescripcion,mo.Miso4217, *
			from CuentasBancos cb
				inner join CBTarjetaCredito tc  on cb.CBTCid= tc.CBTCid
				 inner join Monedas mo on cb.Mcodigo=mo.Mcodigo
			 where  	cb.CBcodigo=<cfqueryparam value="#form.codigoTar#" cfsqltype="cf_sql_varchar">
					and tc.CBTCDescripcion=<cfqueryparam value="#form.CBTCDescripcion#" cfsqltype="cf_sql_varchar">
					and mo.Miso4217=<cfqueryparam value="#form.Miso4217#" cfsqltype="cf_sql_varchar">
					and cb.Ecodigo=<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_numeric">
		</cfquery>

		<cfset form.CBid=#getCBid.CBid#>
		<cfset form.Bid=#getCBid.CBid#>

<cfelse>
<cfset _CBesTCE = 0>
<cfset _Pagina = 'Movimientos.cfm'>
<cfset _PaginaLista = 'listaMovimientos.cfm'>
</cfif>

	<cfset navegacion_lista = '&pagenum_lista=1' >
	<cfif isdefined("form.pagenum_lista") >
		<cfset navegacion_lista = '&pagenum_lista=#form.pagenum_lista#' >
	</cfif>

	<cfif isdefined("form.pagenum_lista2") >
		<cfset navegacion_lista = navegacion_lista & '&pagenum_lista2=#form.pagenum_lista2#' >
	</cfif>
	<cfif isdefined("form.filtro_DMdescripcion") >
		<cfset navegacion_lista = navegacion_lista & '&filtro_DMdescripcion=#form.filtro_DMdescripcion#' >
	</cfif>
	<cfif isdefined("form.filtro_Cdescripcion") >
		<cfset navegacion_lista = navegacion_lista & '&filtro_Cdescripcion=#form.filtro_Cdescripcion#' >
	</cfif>

	<cfif isdefined("form.filtro_EMdocumento") >
		<cfset navegacion_lista = navegacion_lista & '&filtro_EMdocumento=#form.filtro_EMdocumento#' >
	</cfif>
	<cfif isdefined("form.filtro_CBid") >
		<cfset navegacion_lista = navegacion_lista & '&filtro_CBid=#form.filtro_CBid#' >
	</cfif>
	<cfif isdefined("form.filtro_BTid") >
		<cfset navegacion_lista = navegacion_lista & '&filtro_BTid=#form.filtro_BTid#' >
	</cfif>
	<cfif isdefined("form.filtro_EMdescripcion") >
		<cfset navegacion_lista = navegacion_lista & '&filtro_EMdescripcion=#form.filtro_EMdescripcion#' >
	</cfif>
	<cfif isdefined("form.filtro_EMfecha") >
		<cfset navegacion_lista = navegacion_lista & '&filtro_EMfecha=#form.filtro_EMfecha#' >
	</cfif>
	<cfif isdefined("form.filtro_usuario") >
		<cfset navegacion_lista = navegacion_lista & '&filtro_usuario=#form.filtro_usuario#' >
	</cfif>
<!--- ========================================= --->
<cfif isdefined("Form.Alta") or isdefined("Form.Cambio") or isdefined("Form.AltaDet") or isdefined("Form.CambioDet") >

	<cfquery name="rsInsertar" datasource="#session.DSN#">
		select 1
		from MLibros
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and MLdocumento=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.EMdocumento)#">
			and BTid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.BTid#">
			and CBid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
	</cfquery>

	<cfquery name="rsInsertarEM" datasource="#session.DSN#">
		select 1
		from EMovimientos
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and EMdocumento=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.EMdocumento)#">
			and BTid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.BTid#">
			and CBid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">

		<cfif isdefined("form.EMid") and len(trim(form.EMid))>
			and EMid != <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EMid#">
		</cfif>

	</cfquery>

	<cfif rsInsertar.recordcount gt 0 or rsInsertarEM.recordcount gt 0 >
		<cfquery name="transaccion" datasource="#session.DSN#">
			select BTdescripcion
			from BTransacciones
			where BTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.BTid#">
		</cfquery>
		<cfquery name="cuenta" datasource="#session.DSN#">
			select CBdescripcion
			from CuentasBancos
			where CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
            	and CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
		</cfquery>
		<cfset Request.Error.Backs = 1 >
		<cf_errorCode	code = "50412"
						msg  = "No se puede procesar el Movimiento pues ya existe uno con mismos datos: <br> -Documento: @errorDat_1@ <br> -Transacción: @errorDat_2@ <br> -Cuenta Bancaria: @errorDat_3@. <br>El proceso fue cancelado"
						errorDat_1="#form.EMdocumento#"
						errorDat_2="#transaccion.BTdescripcion#"
						errorDat_3="#cuenta.CBdescripcion#"
		>
	</cfif>
</cfif>

<!--- 	VALIDACIÓN DEL DOCUMENTO --->
<cfif isdefined("Form.btnAgregarE") or isdefined("Form.btnAgregarD") or isdefined("Form.btnCambiarD")>
	<cfquery datasource="#Session.DSN#" name="rsDocumentos">
		select rtrim(EMdocumento) as EMdocumento
		from EMovimientos
		where Ecodigo		= 	<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" >
		  and EMdocumento 	= 	<cfqueryparam value="#Form.EMdocumento#"   cfsqltype="cf_sql_char">
		<cfif not isdefined("Form.btnAgregarE")>
			and EMid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EMid#">
		</cfif>
	</cfquery>
	<cfif rsDocumentos.recordcount gt 0>
		<cf_errorCode	code = "50413"
						msg  = "El Documento @errorDat_1@ ya existe, por favor defina un documento distinto. Proceso Cancelado!"
						errorDat_1="#Form.EMdocumento#"
		>
	</cfif>
</cfif>

<cfif isdefined("form.Aplicar") >
	<cfif isDefined("form.Virtual") and form.virtual eq 1>
		<cfthrow message="No se pueden aplicar registros con Banco Virtual. Modifica el banco Origen a uno que no sea Virtual">
	</cfif>

	<!--- APLICACIÓN DEL MB, SE GUARDA EN LAS TABLAS HISTORICAS! --->
	<cfquery datasource="#Session.DSN#" name="insertHDMovimientos">
		INSERT INTO HDMovimientos (EMid, DMlinea, Ecodigo, Ccuenta, Dcodigo, CFid, DMmonto, DMdescripcion, BMUsucodigo, PCGDid, CFcuenta, Icodigo)
		SELECT EMid,
		       DMlinea,
		       Ecodigo,
		       Ccuenta,
		       Dcodigo,
		       CFid,
		       DMmonto,
		       DMdescripcion,
		       BMUsucodigo,
		       PCGDid,
		       CFcuenta,
		       Icodigo
		FROM DMovimientos
		WHERE EMid = <cfqueryparam value="#form.EMid#" cfsqltype="cf_sql_integer">
		  AND Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfquery datasource="#Session.DSN#" name="insertHEMovimientos">
		INSERT INTO HEMovimientos (EMid, BTid, Ecodigo, CBid, CFid, Ocodigo, EMtipocambio, EMdocumento, EMtotal, EMreferencia, EMfecha, EMdescripcion, EMusuario, EMselect, BMUsucodigo, SNcodigo, id_direccion, TpoSocio, TpoTransaccion, Documento, SNid, CDCcodigo, EMdescripcionOD, EMBancoIdOD, Tipo, EMNombreBenefic, EMRfcBenefic, EMdocumentoRef, ERNid, EIid, CodTipoPago)
		SELECT EMid,
		       BTid,
		       Ecodigo,
		       CBid,
		       CFid,
		       Ocodigo,
		       EMtipocambio,
		       EMdocumento,
		       EMtotal,
		       EMreferencia,
		       EMfecha,
		       EMdescripcion,
		       EMusuario,
		       EMselect,
		       BMUsucodigo,
		       SNcodigo,
		       id_direccion,
		       TpoSocio,
		       TpoTransaccion,
		       Documento,
		       SNid,
		       CDCcodigo,
		       EMdescripcionOD,
		       EMBancoIdOD,
		       Tipo,
		       EMNombreBenefic,
		       EMRfcBenefic,
		       EMdocumentoRef,
		       ERNid,
		       EIid,
		       CodTipoPago
		FROM EMovimientos
		WHERE EMid = <cfqueryparam value="#form.EMid#" cfsqltype="cf_sql_integer">
		  AND Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
	</cfquery>
	<cfinvoke component="sif.Componentes.CP_MBPosteoMovimientosB" method="PosteoMovimientos">
		<cfinvokeargument name="Ecodigo" value="#session.Ecodigo#"/>
		<cfinvokeargument name="EMid" value="#form.EMid#"/>
		<cfinvokeargument name="usuario" value="#session.usucodigo#"/>
		<cfinvokeargument name="debug" value="Y"/>
        <cfinvokeargument name="ubicacion" value="#_CBesTCE#"/>

	</cfinvoke>
	<cflocation addtoken="no" url="#_Pagina#?sqlDone=ok#navegacion_lista#">
</cfif>

<cfif isdefined("Form.AltaDet") or isdefined("Form.CambioDet")>
	<cfquery name="rsIndicador" datasource="#session.DSN#">
		select Pvalor from Parametros
		where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" >
			and Pcodigo = 2
	</cfquery>
	<cfif rsIndicador.Pvalor EQ 'N'>
		<!----Obtener el Ocodigo, Dcodigo según el centro funcional---->

		<cfquery name="CFuncional" datasource="#session.DSN#">
			select Ocodigo, Dcodigo from CFuncional
			where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				and CFid = <cfqueryparam value="#form.CFid#" cfsqltype="cf_sql_numeric">
		</cfquery>
		<cfinvoke returnvariable="Cuentas" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
			Oorigen 		= "MBMV"
			Ecodigo			= "#Session.Ecodigo#"
			Conexion 		= "#Session.DSN#"
			BTransacciones  = "#form.BTid#"
			Bancos 			= "#form.Bid#"
			CFuncional      = "#form.CFid#"
			CuentasBancos   = "#form.CBid#"
			Monedas         = "#form.Mcodigo#"
			Oficinas       = "#CFuncional.Ocodigo#"
		/>
		<cfif not isdefined('LvarTCE')>
			<cfset form.Ccuenta = Cuentas.Ccuenta>
		</cfif>
	</cfif>
</cfif>

<cftransaction>
	<cfif isdefined("Form.Alta")>
		<!--- Ocodigo --->
		<cfif isdefined('LvarTCE') and len(trim(#LvarTCE#)) gt 0>
			<cfset varCBESTCE=1>
		<cfelse>
			<cfset varCBESTCE=0>
		</cfif>

		<cfquery name="rsOficina" datasource="#session.DSN#">
			select Ocodigo
			from CuentasBancos
			where CBid = #Form.CBid#
            	and CBesTCE = <cfqueryparam value="#varCBESTCE#" cfsqltype="cf_sql_bit">
		</cfquery>
		<cfset LvarOcodigo = rsOficina.Ocodigo>

		<cfquery name="insert" datasource="#session.DSN#" >
			insert into EMovimientos (
								Ecodigo,
								BTid,
								CBid,
								EMtipocambio,
								EMdocumento,
								EMreferencia,
								EMfecha,
								EMdescripcion,
								EMtotal,
								TpoSocio,
								SNcodigo,
								id_direccion,
								TpoTransaccion,
								Documento,
								SNid,
								Ocodigo,
								EMusuario,
								CDCcodigo,
								EMBancoIdOD,
								EMdescripcionOD,
								Tipo,
								EMNombreBenefic,
								EMRfcBenefic,
								CodTipoPago
								 )
					 values ( <cfqueryparam value="#session.Ecodigo#"    cfsqltype="cf_sql_integer">,
							  <cfqueryparam value="#Form.BTid#"          cfsqltype="cf_sql_numeric">,
							  <cfqueryparam value="#Form.CBid#"          cfsqltype="cf_sql_numeric">,
							  <cfqueryparam value="#Replace(Form.EMtipocambio,',','','all')#" cfsqltype="cf_sql_float">,
							  <cfqueryparam value="#Form.EMdocumento#"   cfsqltype="cf_sql_char">,
							  <cfqueryparam value="#Form.EMreferencia#"  cfsqltype="cf_sql_char">,
							  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.EMfecha)#">,
							  <cfqueryparam value="#Form.EMdescripcion#" cfsqltype="cf_sql_varchar">,
							  <cfqueryparam value="#Replace(Form.EMtotal,',','','all')#" cfsqltype="cf_sql_money">,
							  <cfqueryparam value="#Form.TpoSocio#"    cfsqltype="cf_sql_integer">,
							  <cfif form.TpoSocio eq '0'>
								null,
								null,
								null,
								null,
								null,
							  <cfelseif form.TpoSocio eq '1'>
								<cfqueryparam value="#Form.SNcodigo#"    cfsqltype="cf_sql_integer">,
								<cfqueryparam value="#Form.id_direccion#"    cfsqltype="cf_sql_numeric">,
								<cfqueryparam value="#Form.CCTCodigo#"    cfsqltype="cf_sql_char">,
								null,
								<cfqueryparam value="#Form.SNid#"    cfsqltype="cf_sql_numeric">,
							  <cfelseif form.TpoSocio eq '2'>
								<cfqueryparam value="#Form.SNcodigo#"    cfsqltype="cf_sql_integer">,
								<cfqueryparam value="#Form.id_direccion#"    cfsqltype="cf_sql_numeric">,
								<cfqueryparam value="#Form.CPTCodigo#"    cfsqltype="cf_sql_char">,
								null,
								<cfqueryparam value="#Form.SNid#"    cfsqltype="cf_sql_numeric">,
							 <cfelseif form.TpoSocio eq '3'>
								<cfqueryparam value="#Form.SNcodigo#"    cfsqltype="cf_sql_integer">,
								<cfqueryparam value="#Form.id_direccion#"    cfsqltype="cf_sql_numeric">,
								<cfqueryparam value="#Form.CCTCodigoD#"    cfsqltype="cf_sql_char">,
								<cfqueryparam value="#Form.DocumentoC#"    cfsqltype="cf_sql_varchar">,
								<cfqueryparam value="#Form.SNid#"    cfsqltype="cf_sql_numeric">,

							  <cfelseif form.TpoSocio eq '4'>
								<cfqueryparam value="#Form.SNcodigo#"    cfsqltype="cf_sql_integer">,
								<cfqueryparam value="#Form.id_direccion#"    cfsqltype="cf_sql_numeric">,
								<cfqueryparam value="#Form.CPTCodigoD#"    cfsqltype="cf_sql_char">,
								<cfqueryparam value="#Form.DocumentoP#"    cfsqltype="cf_sql_varchar">,
								<cfqueryparam value="#Form.SNid#"    cfsqltype="cf_sql_numeric">,
							  </cfif>
							  <cfqueryparam value="#LvarOcodigo#"       cfsqltype="cf_sql_integer">,
							  <cfqueryparam value="#session.usuario#"    cfsqltype="cf_sql_varchar">
							  <cfif isdefined("form.CDCcodigo") and len(trim(form.CDCcodigo))>
							  	, #form.CDCcodigo#,
							  <cfelse>
							    , null,
							  </cfif>
							  <cfif isdefined("Form.bcoIdInfo")><cfqueryparam value="#Form.bcoIdInfo#" cfsqltype="cf_sql_numeric"><cfelse>null</cfif>,
							  <cfif isdefined("Form.ctaBancariaInfo")><cfqueryparam value="#Form.ctaBancariaInfo#"    cfsqltype="cf_sql_varchar"><cfelse>null</cfif>,
							  <!--- SI BTtipo ES IGUAL A D, PERTENECE A DEPOSITO Y SI ES C ES RETIRO --->
							  <cfqueryparam value="#Form.BTtipo#"    cfsqltype="cf_sql_char">,
							  <cfif isdefined("Form.nameBenefic")><cfqueryparam value="#Form.nameBenefic#"    cfsqltype="cf_sql_char"><cfelse>null</cfif>,
							  <cfif isdefined("Form.rfcBenefic")><cfqueryparam value="#Form.rfcBenefic#"    cfsqltype="cf_sql_char"><cfelse>null</cfif>,
							  <cfqueryparam value="#Form.tipoPagoFA#"    cfsqltype="cf_sql_varchar">

							)
			<cf_dbidentity1 datasource="#session.DSN#">
		</cfquery>
		<cf_dbidentity2 datasource="#session.DSN#" name="insert">
		<cfset form.EMid = "#insert.identity#">

	<cfelseif isdefined("Form.Baja")>
		<cfquery name="rsAccion" datasource="#Session.DSN#">
			delete from TESRPTcontables
			 where EMid 	= <cfqueryparam cfsqltype="cf_sql_numeric"	value="#Form.EMid#">
		</cfquery>
		<cfquery name="deleted" datasource="#session.DSN#">
			delete from DMovimientos
			where EMid = <cfqueryparam value="#Form.EMid#" cfsqltype="cf_sql_numeric">
			and Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		</cfquery>
		<cfquery name="deleted" datasource="#session.DSN#">
			delete from EMovimientos
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and EMid    = <cfqueryparam value="#Form.EMid#" cfsqltype="cf_sql_numeric">
		</cfquery>

	<cfelseif isdefined("Form.AltaDet")>
		<!---  Obtener el Dcodigo según el centro funcional --->
		<cfif isdefined("form.CFid") and len(trim(form.CFid))>
			<cfquery name="rsCFuncional" datasource="#session.DSN#">
				select Dcodigo from CFuncional
				where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
					and CFid = <cfqueryparam value="#form.CFid#" cfsqltype="cf_sql_numeric">
			</cfquery>
		</cfif>
		<cfquery name="inserted" datasource="#session.DSN#">

			insert into DMovimientos ( EMid, Ecodigo,  Ccuenta, Dcodigo, DMmonto, DMdescripcion,CFid,CFcuenta,Icodigo)
			values ( <cfqueryparam value="#Form.EMid#" cfsqltype="cf_sql_numeric">,
					 	 <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">,
					     <cfqueryparam value="#Form.Ccuenta#" cfsqltype="cf_sql_numeric">,
						  <cfif isdefined("rsCFuncional") and rsCFuncional.recordcount and len(trim(rsCFuncional.Dcodigo))><cfqueryparam value="#rsCFuncional.Dcodigo#" cfsqltype="cf_sql_integer"><cfelse>null</cfif>,

					  	<cfqueryparam value="#Replace(Form.DMmonto,',','','all')#" cfsqltype="cf_sql_money">,
					    <cfqueryparam value="#Form.DMdescripcion#" cfsqltype="cf_sql_varchar">,

						<cfif isdefined("form.CFid") and len(trim(form.CFid))><cfqueryparam value="#Form.CFid#" cfsqltype="cf_sql_numeric"><cfelse>null</cfif>,
					    <cfif isdefined("form.CFcuenta") and len(trim(form.CFcuenta))> <cfqueryparam value="#Form.CFcuenta#" cfsqltype="cf_sql_numeric"><cfelse>null</cfif>,
						<cfif isdefined("form.Icodigo") and len(trim(form.Icodigo))> <cfqueryparam value="#Form.Icodigo#" cfsqltype="cf_sql_varchar"><cfelse>null</cfif>
					)
			<cf_dbidentity1 datasource="#session.DSN#" returnVariable="LvarLinea">
		</cfquery>
		<cf_dbidentity2 datasource="#session.DSN#" name="inserted"  returnVariable="LvarLinea">
		<cf_conceptoPagoSQL name="TESRPTCid" EMid="#form.EMid#" Dlinea="#LvarLinea#">

	<cfelseif isdefined("Form.CambioDet")>
		<!----Obtener el Dcodigo según el centro funcional---->
		<cfif isdefined("form.CFid") and len(trim(form.CFid))>
			<cfquery name="rsCFuncional" datasource="#session.DSN#">
				select Dcodigo from CFuncional
				where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
					and CFid = <cfqueryparam value="#form.CFid#" cfsqltype="cf_sql_numeric">
			</cfquery>
		</cfif>

		<cf_dbtimestamp table="DMovimientos" redirect="#_Pagina#?EMid=#form.EMid#&DMlinea=#form.DMlinea#" timestamp="#form.timestampdet#" field1="EMid,numeric,#Form.EMid#" field2="DMlinea,numeric,#Form.DMlinea#">

		<cfquery name="updated" datasource="#session.DSN#">
			update DMovimientos
			set	Ccuenta = <cfqueryparam value="#Form.Ccuenta#" cfsqltype="cf_sql_numeric">,
				Dcodigo = <cfif isdefined("rsCFuncional") and rsCFuncional.recordcount and len(trim(rsCFuncional.Dcodigo))><cfqueryparam value="#rsCFuncional.Dcodigo#" cfsqltype="cf_sql_integer"><cfelse>null</cfif>,
				DMmonto = <cfqueryparam value="#Replace(Form.DMmonto,',','','all')#" cfsqltype="cf_sql_money">,
					DMdescripcion = <cfqueryparam value="#Form.DMdescripcion#" cfsqltype="cf_sql_varchar">,
				CFid = <cfif isdefined("form.CFid") and len(trim(form.CFid))><cfqueryparam value="#Form.CFid#" cfsqltype="cf_sql_numeric"><cfelse>null</cfif>,
				CFcuenta = <cfif isdefined("form.CFcuenta") and len(trim(form.CFcuenta))><cfqueryparam value="#Form.CFcuenta#" cfsqltype="cf_sql_numeric"><cfelse>null</cfif>,
				Icodigo = <cfif isdefined("form.Icodigo") and len(trim(form.Icodigo))><cfqueryparam value="#Form.Icodigo#" cfsqltype="cf_sql_varchar"><cfelse>null</cfif>
			where EMid      = <cfqueryparam value="#Form.EMid#"    cfsqltype="cf_sql_numeric">
			  and DMlinea   = <cfqueryparam value="#Form.DMlinea#" cfsqltype="cf_sql_numeric">
		</cfquery>
		<cf_conceptoPagoSQL name="TESRPTCid" EMid="#form.EMid#" Dlinea="#Form.DMlinea#">
	<cfelseif isdefined("Form.BajaDet")>
		<cfquery name="rsAccion" datasource="#Session.DSN#">
			delete from TESRPTcontables
			 where EMid 	= <cfqueryparam cfsqltype="cf_sql_numeric"	value="#Form.EMid#">
			   and Dlinea	= <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Form.DMlinea#">
		</cfquery>
		<cfquery name="deleted" datasource="#session.DSN#">
			delete from DMovimientos
			 where EMid = <cfqueryparam value="#Form.EMid#" cfsqltype="cf_sql_numeric">
			   and DMlinea = <cfqueryparam value="#Form.DMlinea#" cfsqltype="cf_sql_numeric">
		</cfquery>

	</cfif>


	<cfif not isdefined("Form.Alta") and not isdefined("Form.Baja") and not isdefined("Form.Nuevo") and not isdefined("Form.NuevoDet")>

		<cf_dbtimestamp table="EMovimientos" redirect="#_Pagina#?EMid=#form.EMid#" timestamp="#form.timestamp#" field1="EMid,numeric,#Form.EMid#">

		<!--- Ocodigo --->
		<cfif isdefined('LvarTCE') and len(trim(#LvarTCE#)) gt 0>
			<cfset CBesTCEvar=1>
		<cfelse>
			<cfset CBesTCEvar=0>
		</cfif>
		<cfquery name="rsOficina" datasource="#session.DSN#">
			select Ocodigo
			from CuentasBancos
			where CBid = #Form.CBid#
            	and CBesTCE = <cfqueryparam value="#CBesTCEvar#" cfsqltype="cf_sql_bit">
		</cfquery>
		<cfset LvarOcodigo = rsOficina.Ocodigo>


		<cfquery datasource="#session.DSN#" name="pruebass">
			update EMovimientos
			set BTid = <cfqueryparam value="#Form.BTid#" cfsqltype="cf_sql_numeric">,
				CBid = <cfqueryparam value="#Form.CBid#" cfsqltype="cf_sql_numeric">,
				EMtipocambio  =	<cfqueryparam value="#Replace(Form.EMtipocambio,',','','all')#" cfsqltype="cf_sql_float">,
				EMdocumento   = <cfqueryparam value="#Form.EMdocumento#"  cfsqltype="cf_sql_char">,
				EMreferencia  = <cfqueryparam value="#Form.EMreferencia#" cfsqltype="cf_sql_char">,
				EMfecha       = <cfqueryparam value="#LSParseDateTime(form.EMfecha)#" cfsqltype="cf_sql_timestamp">,
				EMdescripcion = <cfqueryparam value="#Form.EMdescripcion#" cfsqltype="cf_sql_varchar">,
				Ocodigo       = <cfqueryparam value="#LvarOcodigo#" cfsqltype="cf_sql_integer">,
				TpoSocio      = <cfqueryparam value="#Form.TpoSocio#"    cfsqltype="cf_sql_integer">,
				CodTipoPago   = <cfqueryparam value="#Form.tipoPagoFA#"    cfsqltype="cf_sql_varchar">,
				<cfif form.TpoSocio eq '0'>
					EMtotal = ( select coalesce(sum(DMmonto),0)
							from DMovimientos
							where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
							  and EMid      = <cfqueryparam value="#Form.EMid#"       cfsqltype="cf_sql_numeric">
						  ),
					SNcodigo  		= null,
					id_direccion  	= null,
					TpoTransaccion  = null,
					Documento  		= null,
					SNid            = null
				  <cfelseif form.TpoSocio eq '1'>
				  	EMtotal         = <cfqueryparam value="#Replace(Form.EMtotal,',','','all')#" cfsqltype="cf_sql_money">,
					SNcodigo  		= <cfqueryparam value="#Form.SNcodigo#"    cfsqltype="cf_sql_integer">,
					<cfif isdefined("Form.id_direccion")>
					id_direccion  	= <cfqueryparam value="#Form.id_direccion#"    cfsqltype="cf_sql_numeric">,
					<cfelse>
					id_direccion  	= <cf_jdbcquery_param value="-1"    cfsqltype="cf_sql_numeric">,
					</cfif>
					TpoTransaccion  = <cfqueryparam value="#Form.CCTCodigo#"    cfsqltype="cf_sql_char">,
					Documento  		= null,
					SNid            =<cfqueryparam value="#Form.SNid#"    cfsqltype="cf_sql_numeric">
				  <cfelseif form.TpoSocio eq '2'>
   				  	EMtotal         = <cfqueryparam value="#Replace(Form.EMtotal,',','','all')#" cfsqltype="cf_sql_money">,
					SNcodigo  		= <cfqueryparam value="#Form.SNcodigo#"    cfsqltype="cf_sql_integer">,
					<cfif isdefined("Form.id_direccion")>
					id_direccion  	= <cfqueryparam value="#Form.id_direccion#"    cfsqltype="cf_sql_numeric">,
					<cfelse>
					id_direccion  	= <cf_jdbcquery_param value="-1"    cfsqltype="cf_sql_numeric">,
					</cfif>
					TpoTransaccion  = <cfqueryparam value="#Form.CPTCodigo#"    cfsqltype="cf_sql_char">,
					Documento  		= null,
					SNid            =<cfqueryparam value="#Form.SNid#"    cfsqltype="cf_sql_numeric">
				   <cfelseif form.TpoSocio eq '3'>
				  	EMtotal         = <cfqueryparam value="#Replace(Form.EMtotal,',','','all')#" cfsqltype="cf_sql_money">,
					SNcodigo  		= <cfqueryparam value="#Form.SNcodigo#"    cfsqltype="cf_sql_integer">,
					<cfif isdefined("Form.id_direccion")>
					id_direccion  	= <cfqueryparam value="#Form.id_direccion#"    cfsqltype="cf_sql_numeric">,
					<cfelse>
					id_direccion  	= <cf_jdbcquery_param value="-1"    cfsqltype="cf_sql_numeric">,
					</cfif>
					TpoTransaccion  = <cfqueryparam value="#Form.CCTCodigoD#"    cfsqltype="cf_sql_char">,
					Documento  		= <cfqueryparam value="#Form.DocumentoC#"    cfsqltype="cf_sql_varchar">,
					SNid            =<cfqueryparam value="#Form.SNid#"    cfsqltype="cf_sql_numeric">
				  <cfelseif form.TpoSocio eq '4'>
   				  	EMtotal         = <cfqueryparam value="#Replace(Form.EMtotal,',','','all')#" cfsqltype="cf_sql_money">,
					SNcodigo  		= <cfqueryparam value="#Form.SNcodigo#"    cfsqltype="cf_sql_integer">,
					<cfif isdefined("Form.id_direccion")>
					id_direccion  	= <cfqueryparam value="#Form.id_direccion#"    cfsqltype="cf_sql_numeric">,
					<cfelse>
					id_direccion  	= <cf_jdbcquery_param value="-1"    cfsqltype="cf_sql_numeric">,
					</cfif>
					TpoTransaccion  = <cfqueryparam value="#Form.CPTCodigoD#"    cfsqltype="cf_sql_char">,
					Documento  		=<cfqueryparam value="#Form.DocumentoP#"    cfsqltype="cf_sql_varchar">,
					SNid            =<cfqueryparam value="#Form.SNid#"    cfsqltype="cf_sql_numeric">
				  </cfif>
				  <cfif isdefined("form.CDCcodigo") and len(trim(form.CDCcodigo))>
				  	, CDCcodigo = #form.CDCcodigo#
				  </cfif>
				  <cfif isdefined("form.bcoIdInfo")>
				  	, EMBancoIdOD = <cfqueryparam value="#Form.bcoIdInfo#"    cfsqltype="cf_sql_numeric">
				  </cfif>
				  <cfif isdefined("form.ctaBancariaInfo")>
				  	, EMdescripcionOD = <cfqueryparam value="#Form.ctaBancariaInfo#"    cfsqltype="cf_sql_varchar">
				  </cfif>
			where Ecodigo   = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and EMid      = <cfqueryparam value="#Form.EMid#" cfsqltype="cf_sql_numeric">
		</cfquery>


	</cfif>

</cftransaction>

<cfif isdefined("Form.Baja")>
	<cflocation addtoken="no" url="#_PaginaLista#?sqlDone=ok#navegacion_lista#">
</cfif>

<cfif isdefined("Form.Importar")>
	<cflocation addtoken="no" url="MovimientosImportacion.cfm?EMid=#form.EMid#">
</cfif>
<cfset UrlParams = "?sqlDone=ok">
<cfif isdefined("form.Nuevo")>
	<cfset UrlParams = UrlParams & "&Nuevo=Nuevo">
</cfif>
<cfif isdefined("form.EMid") and len(trim(form.EMid)) and not isdefined("form.Nuevo")>
	<cfset UrlParams = UrlParams & "&EMid="&form.EMid>
</cfif>
<cfif isdefined("form.EMusuario") and len(trim(form.EMusuario)) and not isdefined("form.Nuevo")>
	<cfset UrlParams = UrlParams & "&EMusuario="&form.EMusuario>
</cfif>
<cfif isdefined("form.DMlinea") and len(trim(form.DMlinea)) and not isdefined("form.NuevoDet") and not isdefined("form.BajaDet")>
	<cfset UrlParams = UrlParams & "&DMlinea="&form.DMlinea>
</cfif>
<cfif isdefined("form.Pagina") and len(trim(form.Pagina))>
	<cfset UrlParams = UrlParams & "&Pagina="&form.Pagina>
</cfif>

<cflocation url="#_Pagina##UrlParams##navegacion_lista#">
