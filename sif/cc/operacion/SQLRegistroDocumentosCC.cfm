	<cfset Request.error.backs = 1 >

    <cfif isdefined("url.OP") AND url.OP EQ "GENCF">
        <cfobject component="sif.Componentes.AplicarMascara" name="mascara">
        <cfset LvarCFformato = mascara.fnComplementoItem(url.Ecodigo, url.CFid, url.SNid, "S", "", url.Cid, "", "","","","",url.Ecodigo,-1)>
        <cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnGeneraCuentaFinanciera" returnvariable="LvarError">
                <cfinvokeargument name="Lprm_CFformato" 		value="#LvarCFformato#"/>
                <cfinvokeargument name="Lprm_fecha" 			value="#now()#"/>
                <cfinvokeargument name="Lprm_TransaccionActiva" value="no"/>
                <cfinvokeargument name="Lprm_Ecodigo" 			value="#url.Ecodigo#"/>
        </cfinvoke>

        <cfif LvarError EQ 'NEW' OR LvarError EQ 'OLD'>
            <cfquery name="rsTraeCuenta" datasource="#session.DSN#">
                select a.CFcuenta, a.Ccuenta, a.CFformato, a.CFdescripcion
                from CFinanciera a
                    inner join CPVigencia b
                         on a.CPVid     = b.CPVid
                        and <cf_dbfunction name="now"> between b.CPVdesde and b.CPVhasta
                where a.Ecodigo   = #url.Ecodigo#
                  and a.CFformato = '#LvarCFformato#'
            </cfquery>
        </cfif>

        <cfoutput>
            <script language="javascript" type="text/javascript">
                <cfif LvarError neq 'NEW' and LvarError neq 'OLD'>
                    window.parent.fnSetCuentaError ("Cuenta #LvarCFformato#:\n#JSStringFormat(LvarError)#");
                <cfelseif rsTraeCuenta.CFcuenta EQ "">
                    window.parent.fnSetCuentaError ("Cuenta #LvarCFformato#:\nNo existe Cuenta de Presupuesto");
                <cfelse>
                    window.parent.fnSetCuenta ("#rsTraeCuenta.CFcuenta#","#rsTraeCuenta.Ccuenta#","#trim(rsTraeCuenta.CFformato)#","#trim(rsTraeCuenta.CFdescripcion)#");
                </cfif>
            </script>
        </cfoutput>
        <cfabort>
	</cfif>

	<cfif isdefined('url.pintar')>
		<cfinvoke component="sif.Componentes.CC_PosteoDocumentosCxC"
				  method="PosteoDocumento"
					EDid	= "#url.EDid#"
					Ecodigo = "#Session.Ecodigo#"
					usuario = "#Session.usuario#"
					pintaAsiento = "true"
		/>
		PINTADO
        <cfset form.tipo = url.tipo>
        <cfabort>
	<cfelseif isdefined('url.TCsug')>
		<cfquery name="TCsug" datasource="#Session.DSN#">
			select tc.Mcodigo, tc.TCcompra
			from Htipocambio tc
			where tc.Ecodigo =  #Session.Ecodigo#
			  and tc.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Mcodigo#">
			  and tc.Hfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#url.EDfecha#">
			  and tc.Hfechah > <cfqueryparam cfsqltype="cf_sql_date" value="#url.EDfecha#">
		</cfquery>
		<cfoutput>
			<script language="javascript">
				parent.document.form1.EDtipocambio.value = "#numberformat(TCsug.TCcompra,",9.0000")#";
				parent.document.form1.TCsug.value		 = "#numberformat(TCsug.TCcompra,",9.0000")#";
			</script>
		</cfoutput>
        <cfabort>
	</cfif>
	<cfset params = '' >
	<cfif isdefined('form.tipo')>
		<cfset params = params & 'tipo=#form.tipo#'>
	</cfif>
	<cfif isdefined('form.SNidentificacion')>
		<cfset params = params & '&SNidentificacion=#form.SNidentificacion#'>
	</cfif>
	<cfif isdefined('form.SNnumero')>
		<cfset params = params & '&SNnumero=#form.SNnumero#'>
	</cfif>
	<cfif isdefined('form.Filtro_CCTdescripcion')>
		<cfset params = params & '&Filtro_CCTdescripcion=#form.Filtro_CCTdescripcion#'>
	</cfif>
	<cfif isdefined('form.Filtro_EDdocumento')>
		<cfset params = params & '&Filtro_EDdocumento=#form.Filtro_EDdocumento#'>
	</cfif>
	<cfif isdefined('form.Filtro_EDFecha')>
		<cfset params = params & '&Filtro_EDFecha=#form.Filtro_EDFecha#'>
	</cfif>
	<cfif isdefined('form.Filtro_EDUsuario')>
		<cfset params = params & '&Filtro_EDUsuario=#form.Filtro_EDUsuario#'>
	</cfif>
	<cfif isdefined('form.Filtro_Mnombre')>
		<cfset params = params & '&Filtro_Mnombre=#form.Filtro_Mnombre#'>
	</cfif>
	<cfif isdefined('form.Filtro_CCTdescripcion')>
		<cfset params = params & '&hFiltro_CCTdescripcion=#form.Filtro_CCTdescripcion#'>
	</cfif>
	<cfif isdefined('form.Filtro_EDdocumento')>
		<cfset params = params & '&hFiltro_EDdocumento=#form.Filtro_EDdocumento#'>
	</cfif>
	<cfif isdefined('form.Filtro_EDFecha')>
		<cfset params = params & '&hFiltro_EDFecha=#form.Filtro_EDFecha#'>
	</cfif>
	<cfif isdefined('form.Filtro_EDUsuario')>
		<cfset params = params & '&hFiltro_EDUsuario=#form.Filtro_EDUsuario#'>
	</cfif>
	<cfif isdefined('form.Filtro_Mnombre')>
		<cfset params = params & '&hFiltro_Mnombre=#form.Filtro_Mnombre#'>
	</cfif>
	<cfif isdefined('form.Filtro_FechasMayores')>
		<cfset params = params & '&Filtro_FechasMayores=#form.Filtro_FechasMayores#'>
	</cfif>
	<cfif isdefined('form.Pagina')>
		<cfset params = params & '&Pagina=#form.Pagina#'>
	</cfif>

	<cfset existe = false>
	<cfif not isdefined("form.BajaDet")>
		<!--- Averiguar si el tipo de transaccion es debito o credito --->
		<cfquery name="rsCCTransaccion" datasource="#Session.DSN#">
			select CCTtipo
			from CCTransacciones
			where Ecodigo =  #Session.Ecodigo#
			and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CCTcodigo#">
		</cfquery>
	</cfif>


	<!--- Busca estado del parametro: "Indicar Cuentas Contables Manualmente" --->
	<cfquery name="rsPintaCuentaParametro" datasource="#session.DSN#">
		select Pcodigo, Pvalor, Pdescripcion
		from  Parametros
		where Ecodigo =  #Session.Ecodigo#
		and Pcodigo = 2
	</cfquery>
	<!--- Busca el departamento para ese Centro Fucional --->
	<cfif isdefined("form.CFid") and len(trim(form.CFid))>
		<cfquery name="rsCFuncional" datasource="#Session.DSN#">
			select Dcodigo
			from CFuncional
			where Ecodigo =  #Session.Ecodigo#
			and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
		</cfquery>
	</cfif>
	<cfif isdefined ("form.SNidentificacion2")>
		<cfset form.SNidentificacion = form.SNidentificacion2>
	</cfif>

	<!--- si esta en "N" utiliza el componente --->
	<cfif not isdefined("form.Oficinas")>
		<cfparam name="Oficinas" default="">
	</cfif>

<cfif not isdefined('form.Nuevo')>
	<cfif isdefined('form.Aplicar')>
		<cfset params = params & '&EDid='&form.EDid&'&Aplicar=' & form.Aplicar>
	<cfelseif isdefined('form.AplicarRel')>
		<cfset params = params & '&EDid='&form.EDid&'&AplicarRel=' & form.AplicarRel>
	<cfelseif isdefined('form.NuevoDet')>
		<cfset params = params & '&EDid=' & form.EDid>
	<cfelseif isdefined('form.Alta')>
		<cfquery name="rsExisteEncab" datasource="#Session.DSN#">
			select count(1) as cantidad
			  from EDocumentosCxC
			 where Ecodigo =  #Session.Ecodigo#
			   and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CCTcodigo#">
			   and EDdocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.EDdocumento#">
		</cfquery>

		<cfif rsExisteEncab.cantidad GT 0>
			<cflocation url="../../errorPages/BDerror.cfm?errType=0&errMsg=#URLEncodedFormat('El documento ya existe registrado en Documentos sin Aplicar!')#" >
		</cfif>

		<cfquery name="rsExisteEncabEnBitacora" datasource="#Session.DSN#">
			select count(1) as cantidad
			  from BMovimientos
			 where Ecodigo =  #Session.Ecodigo#
			   and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CCTcodigo#">
			   and Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.EDdocumento#">
		</cfquery>
		<cfif rsExisteEncabEnBitacora.cantidad GT 0>
			<cflocation url="../../errorPages/BDerror.cfm?errType=0&errMsg=#URLEncodedFormat('El Documento ya existe en los Documentos Históricos!')#" >
		</cfif>

		<cftransaction>

			<cfquery name="ABC_DocumentosCC" datasource="#Session.DSN#" >
				insert into EDocumentosCxC
					(Ecodigo, CCTcodigo, EDdocumento, SNcodigo, Mcodigo, EDtipocambio, EDdescuento, EDporcdesc,
					EDimpuesto, EDtotal, Ocodigo, Ccuenta, EDfecha, Rcodigo, EDusuario, EDselect, EDdocref, EDtref,
				 	EDvencimiento, EDfechacontrarecibo, DEidVendedor, DEdiasVencimiento, DEordenCompra, DEnumReclamo, DEobservacion, BMUsucodigo,
				 	id_direccionEnvio, id_direccionFact
				 	,TESRPTCid ,TESRPTCietu, EDieps
					)
				values (
					 #Session.Ecodigo# ,
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.CCTcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#replace(trim(Form.EDdocumento),'|','')#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#Replace(Form.EDtipocambio,',','','all')#">,
					<cfqueryparam cfsqltype="cf_sql_money" value="#Replace(Form.EDdescuento,',','','all')#">,
					0.00,
					<cfqueryparam cfsqltype="cf_sql_money" value="#Replace(Form.EDimpuesto,',','','all')#">,
					<cfqueryparam cfsqltype="cf_sql_money" value="#Replace(Form.EDtotal,',','','all')#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ocodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta#">,
					<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.EDfecha)#">,
					<cfif isDefined("Form.Rcodigo") and Trim(Form.Rcodigo) NEQ "-1">
						<cfqueryparam cfsqltype="cf_sql_char" value="#Form.Rcodigo#">,
					<cfelse>
						null,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.usuario#">,
					0,
					<cfif isDefined("Form.EDdocref") and Trim(Form.EDdocref) NEQ "">
						<cfqueryparam cfsqltype="cf_sql_char" value="#Form.EDdocref#">,
					<cfelse>
						null,
					</cfif>
					<cfif isDefined("Form.CCTcodigoConlis") and Trim(Form.CCTcodigoConlis) NEQ "">
						<cfqueryparam cfsqltype="cf_sql_char" value="#Form.CCTcodigoConlis#">,
					<cfelse>
						null,
					</cfif>
					<cfif rsCCTransaccion.CCTtipo EQ 'C'>
						<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
						null,<!--- Fecha contrarecibo --->
						null,0,null,null,
					<cfelse>
						<cfif isdefined('Form.FechaVencimiento') and LEN(trim(Form.FechaVencimiento))>
							<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.FechaVencimiento)#">,
						<cfelse>
							<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
						</cfif>
						<cfif isdefined('Form.FechaContrarecibo') and LEN(trim(Form.FechaContrarecibo))>
							<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.FechaContrarecibo)#">,
						<cfelse>
						  null,
						</cfif>
					  <cfif isdefined ('Form.DEid') and len(Form.DEid)>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">,
					   <cfelse>
					   null,
					   </cfif>
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.DEdiasVencimiento#">,
						<cfif isdefined('Form.DEordenCompra') and LEN(Form.DEordenCompra) GT 0 >
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEordenCompra#">,
						<cfelse>
							null,
						</cfif>
						<cfif isdefined('Form.DEnumReclamo') and LEN(Form.DEnumReclamo) GT 0>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEnumReclamo#">,
						<cfelse>
							null,
						</cfif>
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEobservacion#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,

					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_direccionEnvio#" null="#Len(Form.id_direccionEnvio) EQ 0#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_direccionFact#" null="#Len(Form.id_direccionFact) EQ 0#">
					<cfif isdefined ('form.TESRPTCid') and len(trim(form.TESRPTCid)) gt 0>
						,<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESRPTCid#">
					<cfelse>
						,null
					</cfif>
					<cfif rsCCTransaccion.CCTtipo EQ 'C'>	<!--- 1=Documento Normal DB, 0=Documento Contrario CR --->
					,0
					<cfelse>
					,1
					</cfif>
					,<cfqueryparam cfsqltype="cf_sql_money" value="#Replace(Form.EDieps,',','','all')#">
					)
				<cf_dbidentity1 datasource="#session.DSN#">
			</cfquery>
			<cf_dbidentity2 datasource="#session.DSN#" name="ABC_DocumentosCC">
			<cfset params = params & '&EDid='& ABC_DocumentosCC.identity>

			<!--- Se asocia el CFDI --->
		<cfif isdefined("form.ce_nombre_xTMP") and form.ce_nombre_xTMP NEQ "">
			<cfinvoke component="sif.ce.Componentes.RepositorioCFDIs"  method="AsignaCFDI" >
				<cfinvokeargument name="Documento" 		value="#replace(trim(Form.EDdocumento),'|','')#">
				<cfinvokeargument name="idDocumento" 	value="#ABC_DocumentosCC.identity#">
				<cfinvokeargument name="idLinea" 		value="-1">
				<cfinvokeargument name="cod" 			value="#form.ce_nombre_xTMP#">
				<cfinvokeargument name="SNcodigo" 		value="#Form.SNcodigo#">
				<cfinvokeargument name="origen"			value="#form.ce_origen#">
			</cfinvoke>
		</cfif>


		</cftransaction>
	<cfelseif isdefined('form.AltaDet')>
		<cfif isdefined("rsPintaCuentaParametro") and rsPintaCuentaParametro.Pvalor EQ 'N'>
			<cfif isdefined('form.Cid') and LEN(TRIM(form.Cid))>
				<cfquery name="rsCCid" datasource="#session.DSN#">
					select 	CCid
					from 	Conceptos
					where 	Ecodigo =  #Session.Ecodigo#
				  	and 	Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Cid#">
				</cfquery>
				<cfset Cconcepto = rsCCid.CCid>
			<cfelse>
				<cfset Cconcepto = "">
			</cfif>

			<cfinvoke returnvariable="LvarCuentas" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
			   Oorigen = "CCFC"
			   Ecodigo = "#Session.Ecodigo#"
			   Conexion = "#Session.DSN#"
			   SNegocios = "#form.SNcodigo#"
			   Oficinas = "#form.Ocodigo#"
			   Monedas =  "#form.Mcodigo#"
			   Almacen = "#form.almacen#"
			   Articulos = "#form.Aid#"
			   Conceptos = "#form.Cid#"
			   CConceptos = "#Cconcepto#"
			   Clasificaciones = ""
			   CCTransacciones = "#form.CCTcodigo#"
			   CFuncional = "#form.CFid#"
			   Lprm_TransaccionActiva="true"
			   />
		</cfif>
		<cftransaction>
			<cfquery name="insertD" datasource="#Session.DSN#" >
				INSERT INTO DDocumentosCxC
						(Ecodigo, EDid, Aid, Cid, DDdescripcion, DDdescalterna, Dcodigo, DDcantidad, DDpreciou,
					 	DDdesclinea, DDporcdesclin, DDtotallinea, DDtipo, Ccuenta, Alm_Aid, Icodigo, CFid,
					 	OCid, OCTid, OCIid, BMUsucodigo, codIEPS, DDMontoIEPS, afectaIVA, Rcodigo)
				values (
					 #Session.Ecodigo# ,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EDid#">,
					<cfif  isDefined("Form.DDtipo") and Form.DDtipo eq 'A'>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Aid#">,
					<cfelseif  isDefined("Form.DDtipo") and Form.DDtipo eq 'S'>
						null,
					<cfelseif  isDefined("Form.DDtipo") and listFind("O,OV",Form.DDtipo)>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AidOD#">,
					</cfif>
					<cfif  isDefined("Form.DDtipo") and Form.DDtipo eq 'S'>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Cid#">,
					<cfelse>
						null,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DDdescripcion#">,
					<cfif len(trim(Form.DDdescalterna)) GT 0>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DDdescalterna#">,
					<cfelse>
						null,
					</cfif>
					<cfif isDefined("rsCFuncional.Dcodigo") and rsCFuncional.recordcount EQ 1>
						<cfqueryparam cfsqltype="cf_sql_integer" value="#rsCFuncional.Dcodigo#">,
					<cfelse>
						null,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_float" value="#Replace(Form.DDcantidad,',','','all')#">,
					<cfqueryparam cfsqltype="cf_sql_money" value="#Replace(Form.DDpreciou,',','','all')#">,
					<cfqueryparam cfsqltype="cf_sql_money" value="#Replace(Form.DDdesclinea,',','','all')#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#Replace(Form.DDporcdesclin,',','','all')#">,
					<cfqueryparam cfsqltype="cf_sql_money" value=#Replace(Form.DDtotallinea,',','','all') - Replace(Form.DDIeps,',','','all')#>,

					<cfqueryparam cfsqltype="cf_sql_char" value="#mid(form.DDtipo,1,1)#">,

					<cfif isdefined("rsPintaCuentaParametro") and rsPintaCuentaParametro.Pvalor EQ 'N'>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCuentas.Ccuenta#">,
					<cfelseif isdefined("rsPintaCuentaParametro") and rsPintaCuentaParametro.Pvalor NEQ 'N'>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CcuentaD#">,
					</cfif>
					<cfif  isDefined("Form.DDtipo") and listFind("A,OV",Form.DDtipo)>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Almacen#">,
					<cfelse>
						null,
					</cfif>
					<cfif isDefined("Form.Icodigo") and Len(Trim(Form.Icodigo)) GT 0 >
						<cfqueryparam cfsqltype="cf_sql_char" value="#Form.Icodigo#">,
					<cfelse>
						null,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">,
					<cfif  isDefined("Form.DDtipo") and listFind("O,OV",Form.DDtipo)>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.OCid#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.OCTid#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.OCIid#">,
					<cfelse>
						null,
						null,
						null,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Replace(Form.Iieps,',','','all')#">,
					<cfqueryparam cfsqltype="cf_sql_money" value="#Replace(Form.DDieps,',','','all')#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.IEscalonado#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RcodigoD#">
					)
				<cf_dbidentity1 datasource="#session.DSN#">
			</cfquery>
			<cf_dbidentity2 datasource="#session.DSN#" name="insertD">
			<cfset params = params & '&EDid='& form.EDid >
			<cfquery datasource="#Session.DSN#">
				update EDocumentosCxC 
					set EDMRetencion = (select sum( round( ((DDCantidad * DDpreciou) - d.DDdesclinea) * (ir.Iporcentaje / 100) ,6) ) as sumRetencion
										from DDocumentosCxC d
											left join Impuestos ir
												on ir.Icodigo = d.Rcodigo
													and ir.Ecodigo = d.Ecodigo
										where EDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EDid#">)
				where EDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EDid#">
			</cfquery>
		</cftransaction>
	<cfelseif isdefined('form.Cambio')>
		<cftransaction>
			<cfset LvarControlCambioEnc = CambiaEncabezado()>
		</cftransaction>
		<cfset params = params & '&EDid='& form.EDid>
	<cfelseif isdefined('form.CambioDet')>
		<cfif isdefined("rsPintaCuentaParametro") and rsPintaCuentaParametro.Pvalor EQ 'N'>
			<cfif isdefined('form.Cid') and LEN(TRIM(form.Cid))>
				<cfquery name="rsCCid" datasource="#session.DSN#">
				select CCid
				from Conceptos
				where Ecodigo =  #Session.Ecodigo#
				  and Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Cid#">
				</cfquery>
			</cfif>
		</cfif>
		<cftransaction>
			<cfset LvarControlCambioEnc = CambiaEncabezado()>
			<cfquery name="rsConsulta" datasource="#session.DSN#">
				select a.Icodigo, DDtotallinea, DDdesclinea, Iporcentaje
				from DDocumentosCxC a, Impuestos b
				where a.Ecodigo =  #Session.Ecodigo#
				  and a.EDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EDid#">
				  and a.DDlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DDlinea#">
				  and b.Ecodigo = a.Ecodigo
				  and b.Icodigo = a.Icodigo
			</cfquery>

			<cfif isdefined("rsPintaCuentaParametro") and rsPintaCuentaParametro.Pvalor EQ 'N'>
				<cfif isdefined('form.Cid') and LEN(TRIM(form.Cid))>
					<cfset Cconcepto = rsCCid.CCid>
				<cfelse>
					<cfset Cconcepto = "">
				</cfif>
				 <cfinvoke returnvariable="LvarCuentas" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
				   Oorigen = "CCFC"
				   Ecodigo = "#Session.Ecodigo#"
				   Conexion = "#Session.DSN#"
				   SNegocios = "#form.SNcodigo#"
				   Oficinas = "#form.Ocodigo#"
				   Monedas =  "#form.Mcodigo#"
				   Almacen = "#form.almacen#"
				   Articulos = "#form.Aid#"
				   Conceptos = "#form.Cid#"
				   CConceptos = "#Cconcepto#"
				   Clasificaciones = ""
				   CCTransacciones = "#form.CCTcodigo#"
				   CFuncional = "#form.CFid#"
				   Lprm_TransaccionActiva="true"

				   />
			</cfif>
			<cfparam name="Form.DDtipo" default="#form.DDtipo_hiden#">

			<cfquery name="updated" datasource="#Session.DSN#" >
				update DDocumentosCxC set
					DDdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DDdescripcion#">
					<cfif  isDefined("Form.DDtipo") and Form.DDtipo eq 'A'>
						, Aid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Aid#">
					<cfelseif  isDefined("Form.DDtipo") and Form.DDtipo eq 'S'>
						, Aid = null
					<cfelseif  isDefined("Form.DDtipo") and listFind("O,OV",Form.DDtipo)>
						, Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AidOD#">
					</cfif>
					<cfif  isDefined("Form.DDtipo") and Form.DDtipo eq 'S'>
						, Cid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Cid#">
					<cfelse>
						, Cid =null
					</cfif>
					, DDdescalterna = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DDdescalterna#">
					, DDcantidad = <cfqueryparam cfsqltype="cf_sql_float" value="#Replace(Form.DDcantidad,',','','all')#">
					, DDpreciou = <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(Form.DDpreciou,',','','all')#">
					, DDdesclinea = <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(Form.DDdesclinea,',','','all')#">
					, DDporcdesclin = <cfqueryparam cfsqltype="cf_sql_float" value="#Replace(Form.DDporcdesclin,',','','all')#">
					<cfif isDefined("rsCFuncional.Dcodigo") and rsCFuncional.recordcount EQ 1>
						, Dcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCFuncional.Dcodigo#">
					<cfelse>
						, Dcodigo = null
					</cfif>
					, DDtotallinea = <cfqueryparam cfsqltype="cf_sql_money" value=#Replace(Form.DDtotallinea,',','','all') - Replace(Form.DDIeps,',','','all')#>

					<cfif  isDefined("Form.DDtipo") and listFind("A,OV",Form.DDtipo)>
						, Alm_Aid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Almacen#">
					<cfelse>
						, Alm_Aid =null
					</cfif>
					<cfif isdefined("rsPintaCuentaParametro") and rsPintaCuentaParametro.Pvalor EQ 'N'>
						, Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCuentas.Ccuenta#">
					<cfelseif isdefined("rsPintaCuentaParametro") and rsPintaCuentaParametro.Pvalor NEQ 'N'>
						, Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CcuentaD#">
					</cfif>
					, CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#" null="#len(trim(form.CFid)) EQ 0#">
					<cfif isDefined("Form.Icodigo") and Len(Trim(Form.Icodigo)) GT 0 >
						, Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Icodigo#">
					<cfelse>
						, Icodigo = null
					</cfif>
					<cfif  isDefined("Form.DDtipo") and listFind("O,OV",Form.DDtipo)>
						, OCid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.OCid#">
						, OCTid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.OCTid#">
						, OCIid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.OCIid#">
					<cfelse>
						, OCid =null
						, OCTid =null
						, OCIid =null
					</cfif>
					<cfif isDefined("Form.Iieps")>
						, codIEPS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Replace(Form.Iieps,',','','all')#">
						, DDMontoIEPS = <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(Form.DDieps,',','','all')#">
						, afectaIVA = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.IEscalonado#">
					</cfif>
					<cfif isDefined("Form.RcodigoD") and Len(Trim(Form.RcodigoD)) GT 0 >
						, Rcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.RcodigoD#">
					<cfelse>
						, Rcodigo = null
					</cfif>					
				where EDid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EDid#">
				  and Ecodigo	=  #Session.Ecodigo#
				  and DDlinea	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DDlinea#">
			</cfquery>
			<cfquery datasource="#Session.DSN#">
				update EDocumentosCxC 
					set EDMRetencion = (select sum( round( ((DDCantidad * DDpreciou) - d.DDdesclinea) * (ir.Iporcentaje / 100) ,6) ) as sumRetencion
										from DDocumentosCxC d
											left join Impuestos ir
												on ir.Icodigo = d.Rcodigo
													and ir.Ecodigo = d.Ecodigo
										where EDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EDid#">)
				where EDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EDid#">
			</cfquery>
		</cftransaction>

		<cfset params = params & '&EDid='& form.EDid >
	<cfelseif isdefined('form.Baja')>
		<cftransaction>
			<cfquery name="deleteD" datasource="#Session.DSN#" >
				delete from DDocumentosCxC
				where EDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EDid#">
				  and Ecodigo =  #Session.Ecodigo#
			</cfquery>

			<cfquery name="deleteE" datasource="#Session.DSN#">
				delete from EDocumentosCxC
				where Ecodigo =  #Session.Ecodigo#
				  and EDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EDid#">
			</cfquery>
            <cfquery name="rsDeleteDocCC" datasource="#session.DSN#">
            delete from CERepoTMP
            where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
              and ID_Documento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EDid#">
        </cfquery>
		</cftransaction>
	<cfelseif isdefined('form.BajaDet')>
		<cfquery name="rsConsulta" datasource="#session.DSN#">
			select Icodigo, DDtotallinea, DDdesclinea
			from DDocumentosCxC
			where Ecodigo =  #Session.Ecodigo#
			  and EDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EDid#">
			  and DDlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DDlinea#">
		</cfquery>

		<cftransaction>

		<cfquery name="deleted" datasource="#Session.DSN#" >
			delete from DDocumentosCxC
			where DDocumentosCxC.DDlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DDlinea#">
			  and DDocumentosCxC.EDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EDid#">
		</cfquery>

		<cfquery datasource="#Session.DSN#">
			update EDocumentosCxC 
				set EDMRetencion = (select sum( round( ((DDCantidad * DDpreciou) - d.DDdesclinea) * (ir.Iporcentaje / 100) ,6) ) as sumRetencion
						from DDocumentosCxC d
								left join Impuestos ir
									on ir.Icodigo = d.Rcodigo
									and ir.Ecodigo = d.Ecodigo
					where EDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EDid#">)
				where EDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EDid#">
		</cfquery>

		</cftransaction>
		<cfset params = params & '&EDid='& form.EDid>
	</cfif>

	<cfif isdefined('form.AltaDet') or isdefined('form.CambioDet') or isdefined('form.BajaDet') or isdefined('form.Cambio')>
		<!---ACTUALIZA EL ENCABEZADO DEL DOCUMENTO CON LOS TOTALES --->
		<!--- DDtotallin	= precio * cantidad - DDdesclinea --->
		<!--- EDtotal		= sum(DDtotallin) + EDimpuesto - EDdescuento --->
		<cfset LvarObjCC = createObject("component","sif.Componentes.CC_PosteoDocumentosCxC")>
		<cfset LvarObjCC.CreaTablas(Session.DSN)>
		<cfset LvarObjCC.CalcularDocumento (Form.EDid, true, session.Ecodigo, Session.DSN)>
		<cfinvoke component="sif.ce.Componentes.RepositorioCFDIs"  method="AsignaCFDI" >
			<cfinvokeargument name="idDocumento" 	value="#Form.EDid#">
			<cfinvokeargument name="idLinea" 		value="-1">
			<cfinvokeargument name="origen"			value="CCFC">
		</cfinvoke>
	</cfif>

	<cfif isdefined('form.Calcular')>
		<cfset LvarObjCC = createObject("component","sif.Componentes.CC_PosteoDocumentosCxC")>
		<cfset LvarObjCC.CreaTablas(Session.DSN)>
		<cfset LvarObjCC.CalcularDocumento (Form.EDid, FALSE, session.Ecodigo, Session.DSN)>
		<!--- Forma de Cálculo de Impuesto (0: Desc/Imp, 1: Imp/Desc.) --->
		<cfquery name="rsSQL" datasource="#session.DSN#">
			select 	Pvalor
			from 	Parametros
			where 	Ecodigo = #session.Ecodigo#
			  and 	Pcodigo = 420
		</cfquery>
		<cfset LvarImpuestosAntesDescuento = rsSQL.Pvalor EQ "1">
		<!--- Usar Cuenta de Descuentos en CxC --->
		<cfquery name="rsSQL" datasource="#session.DSN#">
			select Pvalor
			from Parametros
			where Ecodigo = #session.Ecodigo#
			  and Pcodigo = 421
		</cfquery>
		<cfset LvarUsarCuentaDescuento = rsSQL.Pvalor EQ "D">
		<cf_templatecss>
		<cfoutput>
		<table width="100%">
			<tr>
				<td colspan="10"><strong>PRORRATEO DE DESCUENTO DE DOCUMENTO Y CALCULO DE IMPUESTOS</strong></td>
			</tr>
			<tr>
				<td colspan="10">(Manejo del Descuento a nivel de Documento para calcular Impuestos: <cfif LvarImpuestosAntesDescuento>primero Impuestos y luego DescuentoDoc <cfelse>primero DescuentoDoc y luego Impuestos</cfif>)</strong></td>
			</tr>
			<tr>
				<td colspan="10">(Registro del Descuento a nivel de Documento: <cfif LvarUsarCuentaDescuento>Cuenta para Descuentos<cfelse>disminuir el Ingreso</cfif>)</strong></td>
			</tr>
			<tr>
				<td><strong>Lin</strong></td>
				<td><strong>Tipo</strong></td>
				<td><strong>Descripcion</strong></td>
				<td align="right"><strong>Subtotal</strong></td>
				<cfif NOT LvarImpuestosAntesDescuento>
					<td align="right"><strong>Descuen.Doc<BR>Prorrateado</strong></td>
				</cfif>
				<td align="right"><strong>Base del<br>Impuesto</strong></td>
				<td><strong>&nbsp;&nbsp;Tipo<br>&nbsp;&nbsp;Impuesto</strong></td>
				<td align="right"><strong>Impuesto</strong></td>
				<cfif LvarImpuestosAntesDescuento>
					<td align="right"><strong>Descuen.Doc<BR>Prorrateado</strong></td>
				</cfif>
				<td align="right"><strong>Ingreso<br>Linea</strong></td>
				<td align="right"><strong>Total Neto<br>Linea</strong></td>
			</tr>
			<cfquery name="rsSQL" datasource="#session.DSN#">
				select *
				from #request.CC_calculoLin# l
					inner join DDocumentosCxC d
					   on d.EDid 	= l.EDid
					  and d.DDlinea	= l.DDid
					left join #request.CC_impLinea# i
					  on i.DDid = l.DDid
			</cfquery>
			<cfset LvarLinea = "">
			<cfset LvarNumLinea			= 0>
			<cfset LvarSubtotal			= 0>
			<cfset LvarTotDescDoc		= 0>
			<cfset LvarTotImpuesto		= 0>
			<cfset LvarTotCosto			= 0>
			<cfset LvarTotLinea			= 0>
			<cfloop query="rsSQL">
				<cfif LvarLinea NEQ rsSQL.DDid>
					<cfset LvarLinea = rsSQL.DDid>
					<cfset LvarNumLinea ++>
					<cfset LvarCostoLinea		=  (rsSQL.ingresoLinea)>
					<cfset LvarTotalLinea		=  (rsSQL.totalLinea)>
					<cfset LvarSubtotal			+= rsSQL.subtotalLinea>
					<cfset LvarTotDescDoc		+= rsSQL.descuentoDoc>
					<cfset LvarTotImpuesto		+= rsSQL.impuesto>
					<cfset LvarTotCosto			+= LvarCostoLinea>
					<cfset LvarTotLinea			+= LvarTotalLinea>
					<tr>
						<td>#LvarNumLinea#</td>
						<td>#rsSQL.DDtipo#</td>
						<td>#rsSQL.DDdescripcion#</td>
						<td align="right">#numberFormat(rsSQL.subtotalLinea,",9.99")#</td>
						<cfif NOT LvarImpuestosAntesDescuento>
							<td align="right">#numberFormat(rsSQL.descuentoDoc,",9.99")#</td>
						</cfif>
						<td align="right">#numberFormat(rsSQL.impuestoBase,",9.99")#</td>
						<td>&nbsp;&nbsp;#trim(rsSQL.Icodigo)#=
                    		<cfif rsSQL.impuestoBase EQ 0>
                        		0.00%
                        	<cfelse>
	                    		#numberFormat(rsSQL.impuesto/rsSQL.impuestoBase*100,",9.99")#%
                        	</cfif>
                    	</td>
						<td align="right">#numberFormat(rsSQL.impuesto,",9.99")#</td>
						<cfif LvarImpuestosAntesDescuento>
							<td align="right">#numberFormat(rsSQL.descuentoDoc,",9.99")#</td>
						</cfif>
						<td align="right">#numberFormat(LvarCostoLinea,",9.99")#</td>
						<td align="right">#numberFormat(LvarTotalLinea,",9.99")#</td>
					</tr>
				</cfif>
				<cfif rsSQL.Icompuesto EQ '1'>
					<cfset LvarLinea = rsSQL.DDid>
					<tr>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<cfif NOT LvarImpuestosAntesDescuento>
							<td></td>
						</cfif>
						<td></td>
						<td style="font-size:10px; color:##666666">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#trim(rsSQL.DIcodigo)#=#rsSQL.porcentaje#%</td>
						<td align="right" style="font-size:10px; color:##666666;">#numberFormat(rsSQL.impuesto,",9.99")#</td>
					</tr>
				</cfif>
			</cfloop>
			<tr>
				<td></td>
				<td></td>
				<td></td>
				<td align="right"><strong>#numberFormat(LvarSubtotal,",9.99")#</strong></td>
				<cfif NOT LvarImpuestosAntesDescuento>
					<td align="right"><strong>#numberFormat(LvarTotDescDoc,",9.99")#</strong></td>
				</cfif>
				<td></td>
				<td></td>
				<td align="right"><strong>#numberFormat(LvarTotImpuesto,",9.99")#</strong></td>
				<cfif LvarImpuestosAntesDescuento>
					<td align="right"><strong>#numberFormat(LvarTotDescDoc,",9.99")#</strong></td>
				</cfif>
				<td align="right"><strong>#numberFormat(LvarTotCosto,",9.99")#</strong></td>
				<td align="right"><strong>#numberFormat(LvarTotLinea,",9.99")#</strong></td>
			</tr>
			<tr>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td colspan="8" align="right"><strong>Subtotal</strong></td>
				<td></td>
				<td align="right"><strong>#numberFormat(LvarSubtotal,",9.99")#</strong></td>
			</tr>
			<cfif NOT LvarImpuestosAntesDescuento>
				<tr>
					<td colspan="8" align="right"><strong>Descuento Documento</strong></td>
					<td></td>
					<td align="right"><strong>#numberFormat(LvarTotDescDoc,",9.99")#</strong></td>
				</tr>
			</cfif>
			<tr>
				<td colspan="8" align="right"><strong>Impuestos</strong></td>
				<td></td>
				<td align="right"><strong>#numberFormat(LvarTotImpuesto,",9.99")#</strong></td>
			</tr>
			<cfif LvarImpuestosAntesDescuento>
				<tr>
					<td colspan="8" align="right"><strong>Descuento Documento</strong></td>
					<td></td>
					<td align="right"><strong>#numberFormat(LvarTotDescDoc,",9.99")#</strong></td>
				</tr>
			</cfif>
			<tr>
				<td colspan="8" align="right"><strong>Total Documento</strong></td>
				<td></td>
				<td align="right"><strong>#numberFormat(LvarTotLinea,",9.99")#</strong></td>
			</tr>
		</table>
        <table>
        	<tr>
            	<td><strong>RUBRO</strong>&nbsp;&nbsp;</td>
            	<td><strong>DEBITOS</strong>&nbsp;&nbsp;</td>
            	<td><strong>CREDITOS</strong>&nbsp;</td>
			</tr>
			<cfquery name="rsSQL" datasource="#session.DSN#">
				select CCTtipo
				from EDocumentosCxC e
				inner join CCTransacciones t
					 on t.Ecodigo	= e.Ecodigo
					and t.CCTcodigo	= e.CCTcodigo
				where e.Ecodigo =  #Session.Ecodigo#
				  and e.EDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EDid#">
			</cfquery>
			<cfset LvarCCTtipo = rsSQL.CCTtipo>
        	<tr>
            	<td>Cuenta por Cobrar</td>
				<cfif LvarCCTtipo EQ "C">
					<td></td>
					<td align="right">#numberFormat(LvarTotLinea,",9.99")#</td>
				<cfelse>
					<td align="right">#numberFormat(LvarTotLinea,",9.99")#</td>
					<td></td>
				</cfif>
			</tr>
			<cfif LvarUsarCuentaDescuento>
        		<tr>
            		<td>Descuento Documento&nbsp;&nbsp;</td>
					<cfif LvarCCTtipo EQ "C">
						<td></td>
						<td align="right">#numberFormat(LvarTotDescDoc,",9.99")#</td>
					<cfelse>
						<td align="right">#numberFormat(LvarTotDescDoc,",9.99")#</td>
						<td></td>
					</cfif>
				</tr>
			</cfif>
        	<tr>
            	<td>Ingreso de las Lineas&nbsp;&nbsp;</td>
				<cfif LvarCCTtipo EQ "C">
					<td align="right">#numberFormat(LvarTotCosto,",9.99")#</td>
					<td></td>
				<cfelse>
					<td></td>
					<td align="right">#numberFormat(LvarTotCosto,",9.99")#</td>
				</cfif>
			</tr>
        	<tr>
            	<td>Impuestos por Pagar&nbsp;&nbsp;</td>
				<cfif LvarCCTtipo EQ "C">
					<td align="right">#numberFormat(LvarTotImpuesto,",9.99")#</td>
					<td></td>
				<cfelse>
					<td></td>
					<td align="right">#numberFormat(LvarTotImpuesto,",9.99")#</td>
				</cfif>
			</tr>
			<cfquery name="rsSQL" datasource="#session.DSN#">
				select dicodigo, porcentaje, sum(impuesto) as impuesto
				from #request.CC_impLinea# i
				group by dicodigo, porcentaje
			</cfquery>
			<cfloop query="rsSQL">
				<tr>
					<td style="font-size:10px; color:##666666">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#trim(rsSQL.DIcodigo)#=#rsSQL.porcentaje#%</td>
					<cfif LvarCCTtipo NEQ "C">
						<td></td>
					</cfif>
					<td align="right" style="font-size:10px; color:##666666;">#numberFormat(rsSQL.impuesto,",9.99")#</td>
				</tr>
			</cfloop>
		</table>
		<input type="button" value="Ver Asiento" onclick="location.href='SQLRegistroDocumentosCC.cfm?Pintar&EDid=#Form.EDid#&tipo=#form.tipo#';" />
		</cfoutput>
		<cfabort>
	</cfif>
<cfelse>
	<cfset params = params & '&EDid='>
</cfif>

<cfif isdefined("form.tipo") and len(trim(form.tipo)) and form.tipo EQ 'C'>
	<cflocation addtoken="no" url="RegistroNotasCredito.cfm?#params#">
<cfelseif isdefined("form.tipo") and len(trim(form.tipo)) and form.tipo EQ 'D'>
	<cflocation addtoken="no" url="RegistroFacturas.cfm?#params#">
</cfif>


<!--- JARR se agrego el calculo de la Retencion al actualizar --->
<cffunction name="CambiaEncabezado" returntype="boolean">
	<cfquery datasource="#Session.DSN#">
		update EDocumentosCxC set
			Mcodigo 	 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">,
			EDtipocambio = <cfqueryparam cfsqltype="cf_sql_float" value="#Replace(Form.EDtipocambio,',','','all')#">,
			EDdescuento  = <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(Form.EDdescuento,',','','all')#">,
			EDimpuesto   = <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(Form.EDimpuesto,',','','all')#">,
			EDtotal 	 = <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(Form.EDtotal,',','','all')#">,
			Rcodigo 	 =
				<cfif isDefined("Form.Rcodigo") and Trim(Form.Rcodigo) NEQ "-1">
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.Rcodigo#">,
				<cfelse>
					null,
				</cfif>
			Ocodigo 	 = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ocodigo#">,
			Ccuenta 	 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta#">,
			EDusuario 	 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.usuario#">,
			EDfecha 	 = <cfqueryparam cfsqltype="cf_sql_date" 	value="#LSParseDateTime(Form.EDfecha)#">,
			EDdocref 	 =
				<cfif isDefined("Form.EDdocref") and Trim(Form.EDdocref) NEQ "">
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.EDdocref#">,
				<cfelse>
					null,
				</cfif>
			EDtref 		 =
				<cfif isDefined("Form.EDtref") and Trim(Form.EDtref) NEQ "">
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.EDtref#">,
				<cfelse>
					null,
				</cfif>
			<cfif rsCCTransaccion.CCTtipo NEQ 'C'>
				EDvencimiento =
				<cfif isdefined('Form.FechaVencimiento') and LEN(trim(Form.FechaVencimiento))>
					<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.FechaVencimiento)#">,
				<cfelse>
					<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
				</cfif>
				EDfechacontrarecibo =
				<cfif isdefined('Form.FechaContrarecibo') and LEN(trim(Form.FechaContrarecibo))>
					<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.FechaContrarecibo)#">,
				<cfelse>
					null,
				</cfif>
				<cfif isdefined("Form.DEid") and len(Form.DEid)>
					DEidVendedor 	  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">,
				</cfif>
				DEdiasVencimiento = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.DEdiasVencimiento#">,
				<cfif isdefined('Form.DEordenCompra') and LEN(Form.DEordenCompra) GT 0 >
					DEordenCompra 	  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEordenCompra#">,
				</cfif>
				<cfif isdefined('Form.DEnumReclamo') and LEN(Form.DEnumReclamo) GT 0 >
				DEnumReclamo 	  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEnumReclamo#">,
				</cfif>
			</cfif>
			DEobservacion 	  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEobservacion#">,
			BMUsucodigo 	  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
			id_direccionEnvio = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_direccionEnvio#" null="#Len(Form.id_direccionEnvio) EQ 0#">,
			id_direccionFact  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_direccionFact#" null="#Len(Form.id_direccionFact) EQ 0#">
			<cfif isdefined ('form.TESRPTCid') and len(trim(form.TESRPTCid)) gt 0>
				, TESRPTCid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESRPTCid#">
			</cfif>
			,EDMRetencion = (select sum( round( ((DDCantidad * DDpreciou) - d.DDdesclinea) * (ir.Iporcentaje / 100) ,6) ) as sumRetencion
								from DDocumentosCxC d
									left join Impuestos ir
										on ir.Icodigo = d.Rcodigo
											and ir.Ecodigo = d.Ecodigo
								where EDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EDid#">)
		where EDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EDid#">
	</cfquery>
	<cfinvoke component="sif.ce.Componentes.RepositorioCFDIs"  method="AsignaCFDI" >
		<cfinvokeargument name="idDocumento" 	value="#Form.EDid#">
		<cfinvokeargument name="idLinea" 		value="-1">
		<cfinvokeargument name="origen"			value="CCFC">
	</cfinvoke>
	<cfreturn true>
</cffunction>
