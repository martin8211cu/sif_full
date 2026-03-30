<cfsetting requesttimeout="36000">

<cfset sifinterfacesdb = Application.dsinfo.sifinterfaces.schema>

<cfif (isdefined("form.chk")) AND (isdefined("form.BTNELIMINAR")) >
	<!--- <cfdump var="#form#" label="desde motor uno">
	<cfabort> --->
	<!--- obtenemos el id de la nomina --->
	<cfset datos = ListToArray(Form.chk,",")>
	<cfset limite = ArrayLen(datos)>
	<cfloop from="1" to="#limite#" index="idx">
		<cfset Rdatos = ListToArray(datos[idx],"|")>
		<cftransaction action="begin">
		<cfquery name="delNominaD" datasource="sifinterfaces">
					delete 
						from
							PS_PMI_GL_DET_NOM
						where
						PMI_GL_COD_EJEC like '#Rdatos[1]#'
		</cfquery>
		<cfquery name="delNominaE" datasource="sifinterfaces">
					delete
						from
							PS_PMI_GL_HEADER
						where
						PMI_GL_COD_EJEC like '#Rdatos[1]#'
		</cfquery>
		<cftransaction action="commit"/>
		</cftransaction>
		<cflocation url="/cfmx/interfacesTBS/interfaz925PMI-sql.cfm">
	
	</cfloop>
<cfelseif (isdefined("form.chk")) and (isdefined("form.BTNAPLICAR")) ><!--- Viene de la lista --->

	<cfset datos = ListToArray(Form.chk,",")>
    <cfset limite = ArrayLen(datos)>
	 <cfset varError = false>

	<cfloop from="1" to="#limite#" index="idx">

		<cfset Rdatos = ListToArray(datos[idx],"|")>
		<cfset GvarConexion  = Session.Dsn>
		<cfset GvarEcodigo   = Session.Ecodigo>
		<cfset GvarUsuario   = Session.Usuario>
		<cfset GvarUsucodigo = Session.Usucodigo>
		<cfset GvarEcodigoSDC= Session.EcodigoSDC>
        <cfset varCEcodigo = getCEcodigo(GvarEcodigo)>

		<cfif isdefined('Application.dsinfo.peoplesoft')>
			<cfquery name="rsENomina" datasource="peoplesoft">
				select PMI_GL_COD_EJEC, PMI_GL_DESCRIPCION, PMI_GL_FECHA_EMISI, PMI_GL_COD_EJEC_RE, ltrim(rtrim(PMI_GL_CANCELACION)) as 			            PMI_GL_CANCELACION,  month(PMI_GL_FECHA_EMISI) as MES_NOM, year(PMI_GL_FECHA_EMISI) as PERIODO_NOM
				from
				PS_PMI_GL_HEADER
				where
				PMI_GL_COD_EJEC like '#Rdatos[1]#'
			</cfquery>
		<cfelse>
			<cfquery name="rsENomina" datasource="sifinterfaces">
				select PMI_GL_COD_EJEC, PMI_GL_DESCRIPCION, PMI_GL_FECHA_EMISI, PMI_GL_COD_EJEC_RE, ltrim(rtrim(PMI_GL_CANCELACION)) as 			            PMI_GL_CANCELACION,  month(PMI_GL_FECHA_EMISI) as MES_NOM, year(PMI_GL_FECHA_EMISI) as PERIODO_NOM
				from
				PS_PMI_GL_HEADER
				where
				PMI_GL_COD_EJEC like '#Rdatos[1]#'
			</cfquery>
		</cfif>
	</cfloop>

		<!---Extrae Maximo ID--->
        <cfset varIDmax = ExtraeMaximo("IE925","ID")>
		<cfif isdefined("rsENomina") and rsENomina.recordcount GT 0>
		<cfset InsertaConsola = False>
		<cfloop query="rsENomina">
		<cftry>
			<!----Obtienes periodo abierto en Contabilidad --->
			<cfquery name="rsPeriodo" datasource="#GvarConexion#">
				select Pvalor
				from Parametros
				where Pcodigo = 30
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
			</cfquery>

			<cfif isdefined("rsPeriodo") and rsPeriodo.recordcount EQ 0>
				<cfthrow message="No se ha parametrizado el periodo contable para la empresa">
			<cfelse>
				<cfset Periodo = #rsPeriodo.Pvalor#>
			</cfif>

			<!----Obtienes mes abierto en la contabilidad--->
			<cfquery name="rsMes" datasource="#GvarConexion#">
				select Pvalor
				from Parametros
				where Pcodigo = 40
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
			</cfquery>

			<cfif  isdefined("rsMes") and rsMes.recordcount EQ 0>
				<cfthrow message="No se ha parametrizado el mes contable para la empresa">
			<cfelse>
				<cfset Mes = #rsMes.Pvalor#>
			</cfif>

			<cfif rsENomina.PERIODO_NOM LT Periodo>
				<cfthrow message="La Nómina que desea ejecutar es de un Periodo anterior al periodo abierto en la Contabilidad">
			<cfelseif rsENomina.PERIODO_NOM GTE Periodo>
				<cfif Periodo EQ rsENomina.PERIODO_NOM>
					<cfif rsENomina.MES_NOM LT Mes>
						<cfthrow message="La Nómina que desea ejecutar es de un Mes anterior al Mes abierto en la Contabilidad">
					<cfelseif rsENomina.MES_NOM GT Mes>
						<cfset Mes = rsENomina.MES_NOM>
					</cfif>
            	<cfelseif rsENomina.PERIODO_NOM GT Periodo>
            		<cfset Mes = rsENomina.MES_NOM>
				</cfif>
				<cfset Periodo = rsENomina.PERIODO_NOM>
            </cfif>

            <!---SML 16/02/2015. Inicio Encuentra el tipo de Poliza que se utilizara para el origen TEPN--->
            	<cfset varCodLote = 180>
                <cfquery name="rsOrigenNomina" datasource="#GvarConexion#">
                	SELECT Cconcepto
					FROM ConceptoContable
					WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#"> and Oorigen = 'TEPN'
                </cfquery>

                <cfif isdefined('rsOrigenNomina') and rsOrigenNomina.RecordCount EQ 0>
                	<cf_errorcode msg="Asignar el Concepto Contable por Origen para nómina" code ="80014"/>
                <cfelse>
                	<cfset varCodLote = #rsOrigenNomina.Cconcepto#>
                </cfif>
            <!---SML 16/02/2015. Fin Encuentra el tipo de Poliza que se utilizara para el origen TEPN--->
            <!---SML 18/02/2015. Inicio Validar que exista por lo menos un concepto de servicio  para el Sueldo por Pagar--->
            	<cfquery datasource="#GvarConexion#" name="rsCantCon">
                    select count(1) as cantidad
                    from Conceptos
                    where coalesce(CGeneraSol,0) = 1
                        and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
				</cfquery>

                <cfif isdefined('rsCantCon') and rsCantCon.cantidad EQ 0>
                	<cf_errorcode msg="Asignar un Concepto de Servicio para el Sueldo por Pagar" code ="80015"/>
                </cfif>
            <!---SML 18/02/2015. Fin Validar que exista por lo menos un concepto de servicio  para el Sueldo por Pagar--->
			<cftransaction action="begin">
			<cftry>
				<!---Valida que no exista el numero de Nomina--->
				<cfquery name="rsExisteCodNom" datasource="sifinterfaces">
					select ID from IE925
					where ltrim(rtrim(Num_Nomina)) = ltrim(rtrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsENomina.PMI_GL_COD_EJEC#">))
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
				</cfquery>

				<cfif rsExisteCodNom.recordcount GT 0>
					<cfthrow message="La Nómina que desea procesar ya existe en SIF">
				</cfif>

				<cfquery datasource= "sifinterfaces">
				insert into IE925
					(ID,
					Ecodigo,
					Cconcepto,
					Num_Nomina,
					Fecha_Emision,
					Descripcion_Nomina,
					Cancelacion,
					Nomina_Ref,
					Periodo,
					Mes,
					ECIreversible)
				 values
				 	(<cfqueryparam cfsqltype="cf_sql_integer" value="#varIDmax#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#varCodLote#">,<!---SML 16/02/2015. Inicio Encuentra el tipo de Poliza que se utilizara para el origen TEPN--->
					ltrim(rtrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsENomina.PMI_GL_COD_EJEC#">)),
					<cfqueryparam cfsqltype="cf_sql_date" value="#rsENomina.PMI_GL_FECHA_EMISI#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsENomina.PMI_GL_DESCRIPCION#">,
					<cfif rsENomina.PMI_GL_CANCELACION EQ 'Y'>
						<cfqueryparam cfsqltype="cf_sql_bit" value="True">,
					<cfelseif rsENomina.PMI_GL_CANCELACION EQ 'N'>
						<cfqueryparam cfsqltype="cf_sql_bit" value="False">,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsENomina.PMI_GL_COD_EJEC_RE#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
					0)
				</cfquery>


				<!----Inserta en los historicos de Nómina---->
				<!----Obtiene el maximo  de la tabla de Nómina--->
				<cfquery name="rsMaxHNomina" datasource="sifinterfaces">
					select isnull(max(ID_Nomina),0) + 1 as ID_HMax
					from Enc_Pago_Nomina
				</cfquery>

				<cfset varHMax = rsMaxHNomina.ID_HMax>

				<cfquery datasource="sifinterfaces">
					insert into Enc_Pago_Nomina
							 (ID_Nomina,
					          Num_Nomina,
           					  Fecha_Emision,
							  Descripcion_Nomina,
           					  Estatus_Provision,
           					  Estatus_Pago,
	           				  Cancelacion,
				              Nom_Ref,
							  IE925)
     					values(<cfqueryparam  cfsqltype="cf_sql_integer" value="#varHMax#">,
							  ltrim(rtrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsENomina.PMI_GL_COD_EJEC#">)),
							  <cfqueryparam cfsqltype="cf_sql_date" value="#rsENomina.PMI_GL_FECHA_EMISI#">,
							  <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsENomina.PMI_GL_DESCRIPCION#">,
							  1,
							  1,
		    				  <cfif rsENomina.PMI_GL_CANCELACION EQ 'Y'>
							  	  <cfqueryparam cfsqltype="cf_sql_bit" value="True">,
							  <cfelseif rsENomina.PMI_GL_CANCELACION EQ 'N'>
								  <cfqueryparam cfsqltype="cf_sql_bit" value="False">,
							  </cfif>
			  				  <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsENomina.PMI_GL_COD_EJEC_RE#">,
		    				  <cfqueryparam  cfsqltype="cf_sql_integer" value="#varIDmax#">)
				</cfquery>

				<cftransaction action="commit"/>
				<cfcatch type="any">
				<cftransaction action="rollback"/>
				<!---Elimina el registro insertado--->
				<cfquery datasource="sifinterfaces">
					delete IE925
					where ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#varIDmax#">
				</cfquery>
    	        <cfif isdefined("cfcatch.sql")> <cfset ErrSQL = cfcatch.sql> <cfelse> <cfset ErrSQL = ""> </cfif>
				<cfif isdefined("cfcatch.where")> <cfset ErrPar = cfcatch.where> <cfelse> <cfset ErrPar = ""> </cfif>
            	<cfthrow message="#cfcatch.Message#" detail="#cfcatch.Detail# #ErrSQL# #ErrPar#">
	        	</cfcatch>
    	    	</cftry>
				</cftransaction>

         	<cfquery name="rsDNomina" datasource="sifinterfaces">
			 	select PMI_GL_COD_EJEC, PMI_GL_LINEA, PMI_GL_RUBRO, PMI_GL_SUBRUBRO, PMI_GL_EMPLEADO, PMI_GL_DESCRIPCION,
				PMI_GL_TIPO, PMI_GL_IMPORTE, PMI_GL_CTRO_COSTOS, PMI_GL_CUENTA,
				COD_CONCEPTO = convert(varchar(5),PMI_GL_RUBRO)+right(('00'+convert(varchar,PMI_GL_SUBRUBRO)),3),
				LTRIM(RTRIM(PMI_MONEDA)) AS PMI_MONEDA, PMI_FORMA_PAGO, PMI_GL_COMPLEMENTO
				from PS_PMI_GL_DET_NOM
				where PMI_GL_COD_EJEC = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsENomina.PMI_GL_COD_EJEC#">
    	    </cfquery>

			<cfset DConsecutivo = 1>
			<cfset varDConsecutivoID926 = 0>
			<cfif isdefined("rsDNomina") and rsDNomina.recordcount GT 0>
			<cfloop query="rsDNomina">

				<cfset Cuenta = ''>

				<!----Valida la clasificacion del concepto enviado---->
				<cfif isdefined("rsDNomina.PMI_GL_RUBRO") and rsDNomina.PMI_GL_RUBRO NEQ ''>
					<cfquery name="rsCConcepto" datasource="#GvarConexion#">
						select CCid, CCcodigo, CCdescripcion
						from CConceptos
						where CCcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDNomina.PMI_GL_RUBRO#">
					</cfquery>

					<cfif rsCConcepto.recordcount EQ 0>
						<cfthrow message="El rubro #rsDNomina.PMI_GL_RUBRO# no existe dentro de SIF">
					<cfelse>
						<cfset varCConcepto = #rsCConcepto.CCid#>
					</cfif>
				</cfif>

				<!---Valida que el beneficiario exista en la tesoreria---->
				<cfif trim(rsDNomina.PMI_GL_EMPLEADO) NEQ '' and rsDNomina.PMI_GL_CUENTA EQ 'SUELDOXPAG'>
					<cfquery name="rsBeneficiario" datasource="#GvarConexion#">
						select TESBeneficiarioId, TESBeneficiario, TESBid
						from TESbeneficiario
						where TESBeneficiarioId = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDNomina.PMI_GL_EMPLEADO#">
					</cfquery>

					<cfif rsBeneficiario.recordcount EQ 0>
						<cfthrow message="El beneficiario #rsDNomina.PMI_GL_EMPLEADO# de la Nómina no existe en la Tesoreria del SIF">
					</cfif>
					<cfif isdefined("rsBeneficiario") and rsDNomina.PMI_FORMA_PAGO EQ 2>
						<cfquery name="rsCtaDestino" datasource="#GvarConexion#">
							select TESTPid
							from TEStransferenciaP
							where TESBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsBeneficiario.TESBid#">
							and TESTPestado = 1
						</cfquery>
						<cfif not isdefined ("rsCtaDestino") or rsCtaDestino.recordcount EQ 0>
							<cfthrow message="La cuenta destino para el beneficiario #rsBeneficiario.TESBeneficiarioId# no esta definida">
						</cfif>
					</cfif>
				</cfif>

				<!--- JMRV. Inicio. 07/01/2015 --->
				<!---Valida Unidad Ejecutora--->
				<cfif rsDNomina.PMI_GL_CTRO_COSTOS EQ ''>
					<cfset CTRO_COSTOS = 'RAIZ'>
				<cfelse>
					<cfset CTRO_COSTOS = rsDNomina.PMI_GL_CTRO_COSTOS>
				</cfif>

                <!---Obtiene la equivalencia del Centro Funcional--->
				<cfquery name="rsEquivCF" datasource="sifinterfaces">
					select  SIScodigo, CATcodigo, EQUempOrigen, EQUcodigoOrigen, EQUempSIF, EQUcodigoSIF, EQUidSIF
        	    			from SIFLD_Equivalencia
            				where SIScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="ICTS">
            				and CATcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="CENTRO_FUN">
                			and EQUempSIF = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
	               			and EQUcodigoOrigen = <cfqueryparam cfsqltype= "cf_sql_varchar" value="#CTRO_COSTOS#">
				</cfquery>

				<cfif isdefined("rsEquivCF") and rsEquivCF.recordcount GT 0>
					<cfset CentroFun = rsEquivCF.EQUidSIF>
                    <cfset DescCentroF = rsEquivCF.EQUcodigoSIF>
				<cfelse>
					<cfthrow message="Debe registrar la equivalencia para el Centro Funcional #CTRO_COSTOS#">
				</cfif>

				<!--- Busca si el codigo de centro de costos que viene del sistema externo existe como centro funcional en sif --->
				<cfquery name="rsUnidadEjec" datasource="#GvarConexion#">
					select * from CFuncional
					where CFid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CentroFun#">	<!---SML--->
					and    Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
				</cfquery>

				<!--- Si no encuentra un centro funcional con CFcodigo = CTRO_COSTOS --->
				<cfif rsUnidadEjec.recordcount EQ 0>
                	<cfthrow message="El Centro Funcional #DescCentroF# no existe en el SIF">
					<!--- Verifica si el codigo de centro de costos que proviene del sistema externo tiene un mapeo con un centro funcional en sif --->
					<!---<cfquery name="rsCambiaCtroCostos" datasource="sifinterfaces">
						select  EQUcodigoSIF
        	  				from SIFLD_Equivalencia
            					where SIScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="ICTS">
            					and CATcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="CENTRO_FUN">
            					and EQUempSIF = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
	          				and EQUcodigoOrigen = <cfqueryparam cfsqltype= "cf_sql_varchar" value="#CTRO_COSTOS#">
					</cfquery>	--->
					<!--- Si encuentra un mapeo --->
					<!---<cfif isdefined("rsCambiaCtroCostos") and rsCambiaCtroCostos.recordcount EQ 1>
						<cfset CTRO_COSTOS = #rsCambiaCtroCostos.EQUcodigoSIF#>--->
					<!--- Si no encuentra un mapeo es porque el codigo es invalido --->
					<!---<cfelse>
						<cfthrow message="El Centro Funcional #CTRO_COSTOS# no existe en el SIF">
					</cfif>--->
                <cfelse>
                	<cfset CTRO_COSTOS = #CentroFun#>
				</cfif>

				<!----Obtiene el código de oficina--->
				<cfquery name="rsOficina" datasource="#Gvarconexion#">
					 select o.Ocodigo, o.Oficodigo
					 from Oficinas o
					 	inner join CFuncional cf
					 		on  o.Ecodigo = cf.Ecodigo
					 		and o.Ocodigo = cf.Ocodigo
					 where o.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
					 and cf.CFid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CTRO_COSTOS#">
				</cfquery>
				<cfif isdefined("rsOficina") and rsOficina.recordcount EQ 1>
					<cfset varOficina = #rsOficina.Oficodigo#>
				<cfelse>
					<cfthrow message="No existen oficinas registradas para la empresa #GvarEcodigo#">
				</cfif>
				<!--- JMRV. Fin. 07/01/2015 --->

				<!--- Busca Moneda Local SIF --->
		<!---		<cfquery name="rsMonedaL" datasource="#session.dsn#">
					select e.Ecodigo, m.Mnombre, m.Miso4217, e.Edescripcion
					from Monedas m
					inner join Empresas e
					on m.Ecodigo = e.Ecodigo and m.Mcodigo = e.Mcodigo
					where e.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
				</cfquery>

				<cfif isdefined("rsMonedaL") and rsMonedaL.recordcount EQ 1>
					<cfset varMonedaL = rsMonedaL.Miso4217>
				<cfelse>
					<cfthrow message="Error al Obtener la Moneda Local de la empresa: #GvarEcodigo#">
				</cfif>	--->

				<!---Valida que la moneda exista para la empresa--->
				<cfif isdefined("rsDNomina.PMI_MONEDA") and LEN(rsDNomina.PMI_MONEDA) GT 0>
					<cfquery name="rsMoneda" datasource="#GvarConexion#">
						select Miso4217
						from Monedas
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#GvarEcodigo#">
						and Miso4217 = <cfqueryparam cfsqltype="cf_sql_char" value="#rsDNomina.PMI_MONEDA#">
					</cfquery>
					<!--- JMRV 30/01/2015. Inicio--->
					<!--- Si no encuentra una moneda con Miso4217 = PMI_MONEDA entonces busca si PMI_MONEDA es una equivalencia --->
					<cfif rsMoneda.recordcount EQ 0>
						<!--- Verifica si el codigo de moneda que proviene del sistema externo tiene un mapeo con un codigo de moneda en sif --->
						<cfquery name="rsCambiaMoneda" datasource="sifinterfaces">
							select  EQUcodigoSIF
  	  				from SIFLD_Equivalencia
      					where SIScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="ICTS">
      					and CATcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="MONEDA">
      					and EQUempSIF = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
      					and EQUcodigoOrigen = <cfqueryparam cfsqltype= "cf_sql_varchar" value="#rsDNomina.PMI_MONEDA#">
						</cfquery>
						<!--- Si encuentra un mapeo --->
						<cfif isdefined("rsCambiaMoneda") and rsCambiaMoneda.recordcount EQ 1>
							<cfset varMonedaL = #rsCambiaMoneda.EQUcodigoSIF#>
						<!--- Si no encuentra un mapeo es porque el codigo es invalido --->
						<cfelse>
							<cfthrow message="La moneda #rsDNomina.PMI_MONEDA# no esta definida para esta empresa">
						</cfif>
					<!--- Si encuentra la moneda --->
					<cfelseif rsMoneda.recordcount EQ 1>
						<cfset varMonedaL = #rsMoneda.Miso4217#>
					<cfelse>
						<cfthrow message="Error con la moneda #rsDNomina.PMI_MONEDA#">
					</cfif>
					<!--- JMRV 30/01/2015. Fin--->
				<cfelse>
					<cfquery name="rsMonedaL" datasource="#session.dsn#">
						select m.Miso4217
						from Monedas m
						inner join Empresas e
						on m.Ecodigo = e.Ecodigo and m.Mcodigo = e.Mcodigo
						where e.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
					</cfquery>
					<cfif isdefined("rsMonedaL") and rsMonedaL.recordcount EQ 1>
						<cfset varMonedaL = rsMonedaL.Miso4217>
					<cfelse>
						<cfthrow message="Error al Obtener la Moneda Local de la empresa: #GvarEcodigo#">
					</cfif>
				</cfif>

				<!----Valida el tipo de movimiento---->
				<cfif rsDNomina.PMI_GL_TIPO EQ "">
					<cfthrow message="El tipo de movimiento no es valido">
				</cfif>

				<!---SML 30012016 Inicio. Cambio para el INEE, obtener el parametro del complemento de proyecto (Construcción de Cuentas para Consumo de Inventarios)--->
				<cfquery name = "rsParametroI" datasource="#session.DSN#">
					select Pvalor
					from Parametros
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and Pcodigo = 890
				</cfquery>

				<!---Busca la cuenta de gasto del concepto de servicio---->
				<cfquery datasource="#GvarConexion#" name="rsCtaGasto">
					select C.Cformato, Cid from Conceptos C
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						<cfif rsDNomina.PMI_GL_CUENTA EQ "" and rsDNomina.PMI_GL_RUBRO NEQ "" and rsDNomina.PMI_GL_SUBRUBRO NEQ "">
							and ltrim(rtrim(Ccodigo)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(rsDNomina.COD_CONCEPTO)#">
						<cfelseif rsDNomina.PMI_GL_CUENTA NEQ "">
							and ltrim(rtrim(Ccodigo)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(rsDNomina.PMI_GL_CUENTA)#">
						</cfif>
				</cfquery>

				<cfif rsCtaGasto.recordcount GT 0 and trim(rsCtaGasto.Cformato) NEQ ''>
					<cfif find("?",rsCtaGasto.Cformato) or find("!",rsCtaGasto.Cformato)>
						<cfobject component="sif.Componentes.AplicarMascara" name="mascara">
						<cfif isdefined('rsParametroI') and rsParametroI.Pvalor EQ '3'>
							<cfset vCPformato = mascara.fnComplementoItem(session.Ecodigo, rsUnidadEjec.CFid, -1, 'S', "",rsCtaGasto.Cid, "", "")>
						<cfelseif isdefined('rsParametroI') and rsParametroI.Pvalor EQ '4'>
							<!---SML 04022016. Modificacion para el INEE para enviar el proyecto --->
							<cfquery name="rsComplemento" datasource="#session.DSN#">
								select CGEPid
								from CGEProyecto
								where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
									and ltrim(rtrim(CGEPformato)) = ltrim(rtrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDNomina.PMI_GL_COMPLEMENTO#">))
							</cfquery>
							<cfset vCPformato = mascara.fnComplementoItem(session.Ecodigo, rsUnidadEjec.CFid, -1, 'S', "",rsCtaGasto.Cid, "", "","","","",session.Ecodigo,-1,0,-1,rsComplemento.CGEPid)>
						</cfif>
						<cfset Cuenta = vCPformato>
						<cfquery name="rsCFCuenta" datasource="#GvarConexion#">
							select CFcuenta, Ccuenta,CPcuenta,CFformato
							from CFinanciera
							where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								and  CFformato = <cfqueryparam cfsqltype="cf_sql_char" value="#Cuenta#">
						</cfquery>
						<cfset CFcuenta = rsCFCuenta.CFcuenta>
						<cfif find("?",Cuenta) or find("!",Cuenta)>
							<cfthrow message="Error al armar la Cuenta #Cuenta#">
						</cfif>
					<cfelse>
						<cfif rsDNomina.PMI_GL_CUENTA NEQ "">
							<cfquery name="rsFCuenta" datasource="#GvarConexion#">
								select F.CFformato, F.CFcuenta
								from Conceptos C
									inner join CFinanciera F on C.Cformato = F.CFformato and C.Ecodigo = F.Ecodigo
								where rtrim(ltrim(Ccodigo)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(rsDNomina.PMI_GL_CUENTA)#">
									and F.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							</cfquery>

							<cfif isdefined("rsFCuenta") and rsFCuenta.RecordCount GT 0>
								<cfset Cuenta = rsFCuenta.CFformato>
								<cfset CFcuenta = rsFCuenta.CFcuenta>
							<cfelse>
								<cfthrow message="No se pudo obtener la cuenta a afectar. Linea #rsDNomina.PMI_GL_LINEA# Concepto: #rsDNomina.PMI_GL_CUENTA#">
							</cfif>
						</cfif>
					</cfif>
					<cfif isdefined('Cuenta') and Cuenta NEQ ''>
						<cfset varCuenta = Cuenta>
					<cfelse>
						<cfset varCuenta = rsCtaGasto.Cformato>
					</cfif>
					<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera"
						method="fnGeneraCuentaFinanciera"
						returnvariable="Lvar_MsgError">
						<cfinvokeargument name="Lprm_CFformato"	value="#varCuenta#"/>
						<cfinvokeargument name="Lprm_fecha" value="#now()#"/>
						<cfinvokeargument name="Lprm_EsDePresupuesto" value="false"/>
						<cfinvokeargument name="Lprm_NoCrear" value="false"/>
						<cfinvokeargument name="Lprm_CrearSinPlan" value="false"/>
						<cfinvokeargument name="Lprm_debug" value="false"/>
						<cfinvokeargument name="Lprm_Ecodigo" value="#session.Ecodigo#"/>
						<cfinvokeargument name="Lprm_DSN" value="#Session.DSN#">
					</cfinvoke>
					<cfif isdefined('Lvar_MsgError') AND (Lvar_MsgError NEQ "" AND Lvar_MsgError NEQ "OLD" AND Lvar_MsgError NEQ "NEW")>
						<cfthrow message="Error: #rsDNomina.PMI_GL_RUBRO#, #rsDNomina.PMI_GL_SUBRUBRO#, #rsDNomina.PMI_GL_CUENTA# #Lvar_MsgError#">
					<cfelseif isdefined('Lvar_MsgError') AND (Lvar_MsgError EQ "NEW" OR Lvar_MsgError EQ "OLD")>
						<cfquery name="rsCFCuenta" datasource="#GvarConexion#">
					    	select CFcuenta, Ccuenta,CPcuenta,CFformato
							from CFinanciera
							where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								and CFformato = <cfqueryparam cfsqltype="cf_sql_char" value="#varCuenta#">
						</cfquery>
						<cfif rsCFCuenta.recordcount gt 0>
							<cfset Cuenta = rsCFCuenta.CFformato>
							<cfset CFcuenta = rsCFCuenta.CFcuenta>
						</cfif>
					</cfif>
				<cfelse>
					<cfif rsDNomina.PMI_GL_CUENTA EQ "" and rsDNomina.PMI_GL_RUBRO NEQ "" and rsDNomina.PMI_GL_SUBRUBRO NEQ "">
						<!---Arma la cuenta contable a afectar---->
						<cfinvoke returnvariable="CuentaNomina" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
							Oorigen="PMIH"
							Ecodigo="#GvarEcodigo#"
							Conexion="#GvarConexion#"
							CConceptos="#varCConcepto#"
							PMI_SubRubros="#rsDNomina.PMI_GL_SUBRUBRO#"
							CFuncional="#CentroFun#"
							PMI_Tipo_Contraparte = "N/A"
							SNegocios="N/A"
							>
						</cfinvoke>
						<cfset Cuenta = CuentaNomina.CFformato>
						<cfquery name="rsCFCuenta" datasource="#GvarConexion#">
							select CFcuenta, Ccuenta,CPcuenta,CFformato
							from CFinanciera
							where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								and  CFformato = <cfqueryparam cfsqltype="cf_sql_char" value="#Cuenta#">
						</cfquery>
						<cfset CFcuenta = rsCFCuenta.CFcuenta>
					<cfelse>
						<cfthrow message="Imposible obtener la cuenta a afectar. Linea: #rsDNomina.PMI_GL_LINEA# Rubro: #rsDNomina.PMI_GL_RUBRO#, Subrubro: #rsDNomina.PMI_GL_SUBRUBRO#">
					</cfif>
				</cfif>

                <!---SML 12-02-2015. Inicio Modificacion para Nomina SES Mexico--->
                <cfquery datasource="#GvarConexion#" name="rsCGeneraSol">
					select coalesce(CGeneraSol,0) as CGeneraSol  from Conceptos
					where Ccodigo = ltrim(rtrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDNomina.PMI_GL_CUENTA#">))
                    	and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
				</cfquery>

                <cfif rsCGeneraSol.RecordCount GT 0>
                	<cfset varCGeneraSol = #rsCGeneraSol.CGeneraSol#>
                <cfelse>
                	<cfset varCGeneraSol = 0>
                </cfif>

				 <!---SML 12-02-2015. Fin Modificacion para Nomina SES Mexico--->
				<cftransaction action="begin">
				<cftry>
					<cfquery datasource="sifinterfaces">
						insert into ID925
							(ID,
							DConsecutivo,
							Ecodigo,
							CConcepto,
							Concepto,
							CCodigo,
							Empleado,
							Descripcion_Detalle,
							Tipo,
							Total_Linea,
							Ccuenta,
							CFformato,
							CFuncional,
							Oficodigo,
							Miso4217,
							Id_Solicitud,
							Fecha_Solicitud_Cancelacion,
							Fecha_Cancelacion,
							Usuario_Cancelacion,
							Genera_Orden,
							Gasto)
						values
							(<cfqueryparam cfsqltype="cf_sql_integer" value="#varIDmax#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#DConsecutivo#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDNomina.PMI_GL_RUBRO#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDNomina.PMI_GL_SUBRUBRO#">,
							<cfif rsDNomina.PMI_GL_CUENTA NEQ "">
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDNomina.PMI_GL_CUENTA#">,
							<cfelse>
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDNomina.COD_CONCEPTO#">,
							</cfif>
							<cfif isdefined("rsDNomina.PMI_GL_EMPLEADO") and trim(rsDNomina.PMI_GL_EMPLEADO) NEQ "">
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDNomina.PMI_GL_EMPLEADO#">,
							<cfelse>
								null,
							</cfif>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDNomina.PMI_GL_DESCRIPCION#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDNomina.PMI_GL_TIPO#">,
							round(#PMI_GL_IMPORTE#,2),
							null,
							ltrim(rtrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Cuenta#">)),
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#CTRO_COSTOS#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#varMonedaL#">,
							null,
							<cfqueryparam cfsqltype="cf_sql_date" value="#rsENomina.PMI_GL_FECHA_EMISI#">,
							null,
							null,
							<cfif trim(rsDNomina.PMI_GL_EMPLEADO) NEQ "">
								<cfqueryparam cfsqltype="cf_sql_bit" value="True">,
							<cfelse>
								<cfqueryparam cfsqltype="cf_sql_bit" value="False">,
							</cfif>
							<cfif trim(rsDNomina.PMI_GL_EMPLEADO) NEQ "" and rsDNomina.PMI_GL_CUENTA NEQ "">
								<!---<cfif trim(rsDNomina.PMI_GL_CUENTA) EQ 'PTU'>
									<cfqueryparam cfsqltype="cf_sql_bit" value="True">
								<cfelse>
									<cfqueryparam cfsqltype="cf_sql_bit" value="False">
								</cfif>--->
                                <!---SML 12-02-2015. Inicio Modificacion para Nomina SES Mexico--->
                                <cfif varCGeneraSol EQ 0>
									<cfqueryparam cfsqltype="cf_sql_bit" value="True">
								<cfelse>
									<cfqueryparam cfsqltype="cf_sql_bit" value="False">
								</cfif>
                                <!---SML 12-02-2015. Fin Modificacion para Nomina SES Mexico--->
							<cfelse>
								<cfqueryparam cfsqltype="cf_sql_bit" value="True">
							</cfif>)
					</cfquery>

					<cfif trim(rsDNomina.PMI_GL_EMPLEADO) NEQ ''>
						<cfquery name="rsFormaPago" datasource="sifinterfaces">
							select PMI_GL_EMPLEADO, PMI_FORMA_PAGO
							from PS_PMI_GL_DET_NOM
							where PMI_GL_COD_EJEC = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsENomina.PMI_GL_COD_EJEC#">
							and PMI_GL_EMPLEADO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDNomina.PMI_GL_EMPLEADO#">
							and PMI_FORMA_PAGO is not null
						</cfquery>
					</cfif>
					<!----Inserta Detalle de los historicos de Nómina--->
					<cfquery datasource="sifinterfaces">
						insert into Det_Pago_Nomina
								(ID_Nomina,
           						 ID_Nomina_Det,
					             CConcepto,
    		       				 Concepto,
	    	                     Numero_Empleado,
    	    	   				 Descripcion_Detalle,
					             Tipo,
    	    	   				 Total_Linea,
							     Ccuenta,
        		   				 CFuncional,
								 Fecha_Solicitud_Cancelacion,
								 Moneda,
								 Forma_Pago)
		   				values (<cfqueryparam  cfsqltype="cf_sql_integer" value="#varHMax#">,
							    <cfqueryparam  cfsqltype="cf_sql_integer" value="#DConsecutivo#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDNomina.PMI_GL_RUBRO#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDNomina.PMI_GL_SUBRUBRO#">,
								<cfif isdefined("rsDNomina.PMI_GL_EMPLEADO") and trim(rsDNomina.PMI_GL_EMPLEADO) NEQ "">
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDNomina.PMI_GL_EMPLEADO#">,
								<cfelse>
									null,
								</cfif>
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDNomina.PMI_GL_DESCRIPCION#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDNomina.PMI_GL_TIPO#">,
								round(#PMI_GL_IMPORTE#,2),
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Cuenta#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#CTRO_COSTOS#">,
								<cfif rsENomina.PMI_GL_CANCELACION EQ 'Y'>
									<cfqueryparam cfsqltype="cf_sql_date" value="#rsENomina.PMI_GL_FECHA_EMISI#">,
								<cfelse>
									null,
								</cfif>
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#varMonedaL#">,
								<cfif isdefined("rsFormaPago.PMI_FORMA_PAGO") and rsFormaPago.PMI_FORMA_PAGO NEQ '' and rsDNomina.PMI_FORMA_PAGO NEQ ''>
									<cfqueryparam cfsqltype="cf_sql_integer" value="#rsFormaPago.PMI_FORMA_PAGO#">
								<cfelse>
									null
								</cfif>
								)
					</cfquery>
					<cfset DConsecutivo = DConsecutivo + 1>

					<!----Se inserta el registro en la interfaz 926 para que se generen las solicitudes de pago en Tesorería---->
					<cfif trim(rsDNomina.PMI_GL_EMPLEADO) NEQ "" and #rsENomina.PMI_GL_CANCELACION# EQ 'N'>
						<!----Validamos si ya existe el encabezado--->
						<cfset varIDmax926 = ExtraeMaximo("IE926","ID")>
						<cfquery name="rsExisteEnc" datasource="sifinterfaces">
							select Empleado, ID from IE926
							where Num_Nomina = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsENomina.PMI_GL_COD_EJEC#">
							and Empleado = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDNomina.PMI_GL_EMPLEADO#">
						</cfquery>

						<cfif isdefined('rsExisteEnc') and rsExisteEnc.recordcount EQ 0>
							<cfquery datasource= "sifinterfaces">
								insert into IE926
								(ID,
								Ecodigo,
								Num_Nomina,
								FechaPago,
								FechaSolicitud,
								Descripcion,
								UsucodigoSolicitud,
								Empleado,
								Forma_Pago,
								BMUsucodigo)
							 	values
							 	(<cfqueryparam cfsqltype="cf_sql_integer" value="#varIDmax926#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">,
								ltrim(rtrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsENomina.PMI_GL_COD_EJEC#">)),
								<cfqueryparam cfsqltype="cf_sql_date" value="#rsENomina.PMI_GL_FECHA_EMISI#">,
								<cfqueryparam cfsqltype="cf_sql_date" value="#rsENomina.PMI_GL_FECHA_EMISI#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsENomina.PMI_GL_DESCRIPCION#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#GvarUsuario#">,
								<cfif isdefined("rsDNomina.PMI_GL_EMPLEADO") and trim(rsDNomina.PMI_GL_EMPLEADO) NEQ "">
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDNomina.PMI_GL_EMPLEADO#">,
								<cfelse>
									null,
								</cfif>
								<!---<cfif rsDNomina.PMI_FORMA_PAGO lt 0 or rsDNomina.PMI_FORMA_PAGO gt 3>
									<cfqueryparam cfsqltype="cf_sql_numeric" value="0">,
								<cfelse>
									<cfqueryparam cfsqltype="cf_sql_integer" value="#rsFormaPago.PMI_FORMA_PAGO#">,
								</cfif>	--->
								<cfif isdefined("rsFormaPago.PMI_FORMA_PAGO") and rsFormaPago.PMI_FORMA_PAGO NEQ ''>
									<cfqueryparam cfsqltype="cf_sql_integer" value="#rsFormaPago.PMI_FORMA_PAGO#">,
								<cfelse>
									null,
								</cfif>
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarUsucodigo#">)
							</cfquery>
							<cfset varDConsecutivoID926 = 1>
						<cfelse>
							<cfset varIDmax926 = rsExisteEnc.ID>

							<cfset varDConsecutivoID926 = varDConsecutivoID926 + 1>
						</cfif>
						<cfif CFcuenta eq ''>
						<cfthrow message="CUENTA #CFcuenta# #rsDNomina.PMI_GL_RUBRO#, #rsDNomina.PMI_GL_SUBRUBRO#">
						</cfif>

						<cfquery datasource="sifinterfaces">
							insert into ID926
								(ID,
								DConsecutivo,
								Ecodigo,
								Modulo,
								Documento,
								ReferenciaOri,
								FechaSolicitud,
								Miso4217,
								Total_Linea,
								Descripcion,
								CFcuenta,
								CFformato,
								Tipo,
								Oficodigo,
								TipoCambio,
								CFuncional,
								CConcepto,
								Gasto)
							values
								(<cfqueryparam cfsqltype="cf_sql_integer" value="#varIDmax926#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#varDConsecutivoID926#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">,
								'TEPN',
								ltrim(rtrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsENomina.PMI_GL_COD_EJEC#-#varDConsecutivoID926#">)),
								ltrim(rtrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsENomina.PMI_GL_COD_EJEC#">)),
								<cfqueryparam cfsqltype="cf_sql_date" value="#rsENomina.PMI_GL_FECHA_EMISI#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#varMonedaL#">,
								round(#PMI_GL_IMPORTE#,2),
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDNomina.PMI_GL_DESCRIPCION#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#CFcuenta#">,
								ltrim(rtrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Cuenta#">)),
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDNomina.PMI_GL_TIPO#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
								1,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#CTRO_COSTOS#">,
								<cfif rsDNomina.PMI_GL_CUENTA NEQ "">
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDNomina.PMI_GL_CUENTA#">,
								<cfelse>
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDNomina.COD_CONCEPTO#">,
								</cfif>
								<cfif trim(rsDNomina.PMI_GL_EMPLEADO) NEQ "" and rsDNomina.PMI_GL_CUENTA NEQ "">
									<!---<cfif trim(rsDNomina.PMI_GL_CUENTA) EQ 'PTU'>
										<cfqueryparam cfsqltype="cf_sql_bit" value="True">
									<cfelse>
										<cfqueryparam cfsqltype="cf_sql_bit" value="False">
									</cfif>--->
                                    <!---SML 12-02-2015. Inicio Modificacion para Nomina SES Mexico--->
                                	<cfif varCGeneraSol EQ 0>
										<cfqueryparam cfsqltype="cf_sql_bit" value="True">
									<cfelse>
										<cfqueryparam cfsqltype="cf_sql_bit" value="False">
									</cfif>
                                	<!---SML 12-02-2015. Fin Modificacion para Nomina SES Mexico--->
								<cfelse>
									<cfqueryparam cfsqltype="cf_sql_bit" value="True">
								</cfif>)
						</cfquery>

						<cfquery datasource="sifinterfaces">
							update Det_Pago_Nomina
							set IE926 = <cfqueryparam cfsqltype="cf_sql_integer" value="#varIDmax926#">
							where ID_Nomina = <cfqueryparam  cfsqltype="cf_sql_integer" value="#varHMax#">
							and ID_Nomina_Det = <cfqueryparam  cfsqltype="cf_sql_integer" value="#DConsecutivo-1#">
						</cfquery>
					</cfif>
				<cftransaction action="commit"/>
				<cfcatch type="any">
				<cftransaction action="rollback"/>

				<cfif isdefined("cfcatch.sql")> <cfset ErrSQL = cfcatch.sql> <cfelse> <cfset ErrSQL = ""> </cfif>
				<cfif isdefined("cfcatch.where")> <cfset ErrPar = cfcatch.where> <cfelse> <cfset ErrPar = ""> </cfif>
            	<cfthrow message="#cfcatch.Message#" detail="#cfcatch.Detail# #ErrSQL# #ErrPar#">
	        	</cfcatch>
    	    	</cftry>
				</cftransaction>

			</cfloop>	<!-----DETALLES DE LA NOMINA--->
			<cfelse>
				<cfthrow message="La nomina #rsENomina.PMI_GL_COD_EJEC# no tiene detalles">
			</cfif>
			<cfcatch type="any">>
				<!---Elimina el registro insertado---->
				<cfquery datasource="sifinterfaces">
					delete ID925
					where ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#varIDmax#">
				</cfquery>
				<cfquery datasource="sifinterfaces">
					delete IE925
					where ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#varIDmax#">
				</cfquery>
				<!---Elimina el registro insertado interfaz 926---->
				<cfquery datasource="sifinterfaces">
					delete ID926
					where ID in (select ID from IE926 where Num_Nomina = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsENomina.PMI_GL_COD_EJEC#">)
				</cfquery>
				<cfquery datasource="sifinterfaces">
					delete IE926
					where Num_Nomina = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsENomina.PMI_GL_COD_EJEC#">
				</cfquery>
			<!---	<cfif isdefined("varIDmax926") and varIDmax926 GT 0>
					<cfquery datasource="sifinterfaces">
						delete ID926
						where ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#varIDmax926#">
					</cfquery>
					<cfquery datasource="sifinterfaces">
						delete IE926
						where ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#varIDmax926#">
					</cfquery>
				</cfif>--->
				<cfif isdefined("varHMax") and varHMax GT 0>
					<cfquery datasource="sifinterfaces">
						delete Det_Pago_Nomina
						where ID_Nomina = <cfqueryparam cfsqltype="cf_sql_integer" value="#varHMax#">
					</cfquery>
					<cfquery datasource="sifinterfaces">
						delete Enc_Pago_Nomina
						where ID_Nomina = <cfqueryparam cfsqltype="cf_sql_integer" value="#varHMax#">
					</cfquery>
				</cfif>
				<cfif isdefined("cfcatch.sql")> <cfset ErrSQL = cfcatch.sql> <cfelse> <cfset ErrSQL = ""> </cfif>
				<cfif isdefined("cfcatch.where")> <cfset ErrPar = cfcatch.where> <cfelse> <cfset ErrPar = ""> </cfif>
            	<cfthrow message="#cfcatch.Message#" detail="#cfcatch.Detail# #ErrSQL# #ErrPar#">
			</cfcatch>
			</cftry>
		</cfloop>   <!----ENCABEZADO DE NOMINA---->
		<cfset InsertaConsola = True>
		<cfelse>
			<cfthrow message="No existen Nominas nuevas para procesar">
		</cfif>

		<cfif InsertaConsola>
		<cftry>
			<!----Inserta registro 925 en el Motor de interfaces---->
    	    <cfquery datasource="sifinterfaces">
        	 	insert into InterfazColaProcesos
                        (CEcodigo,
                         NumeroInterfaz,
                         IdProceso,
                         SecReproceso,
                         EcodigoSDC,
                         OrigenInterfaz,
                         TipoProcesamiento,
                         StatusProceso,
                         FechaInclusion,
                         UsucodigoInclusion,
                         Cancelar)
                         values(
                         <cfqueryparam cfsqltype="cf_sql_numeric" value="#varCEcodigo#">,
                         <cfqueryparam cfsqltype="cf_sql_integer" value="925">,
                         <cfqueryparam cfsqltype="cf_sql_numeric" value="#varIDmax#">,
                         0,
                         <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarEcodigoSDC#">,
                         'E',
                         'A',
                         1,
                         <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
                         <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarUsucodigo#">,
                        0)
          	</cfquery>

			<!----Inserta registro 926 en el motor de interfaces--->
			<cfquery datasource="sifinterfaces">
        	 	insert into InterfazColaProcesos
                        (CEcodigo,
                         NumeroInterfaz,
                         IdProceso,
                         SecReproceso,
                         EcodigoSDC,
                         OrigenInterfaz,
                         TipoProcesamiento,
                         StatusProceso,
                         FechaInclusion,
                         UsucodigoInclusion,
                         Cancelar)
                         (select distinct
                         <cfqueryparam cfsqltype="cf_sql_numeric" value="#varCEcodigo#">,
                         <cfqueryparam cfsqltype="cf_sql_integer" value="926">,
                         ID,
                         0,
                         <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarEcodigoSDC#">,
                         'E',
                         'A',
                         1,
                         <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
                         <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarUsucodigo#">,
                        0
						from IE926 where Num_Nomina = ltrim(rtrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsENomina.PMI_GL_COD_EJEC#">)))
          	</cfquery>
			<!----INSERTA EL REGISTRO DE LA NOMINA EN TABLAS DE HISTORICO--->
			<cfquery datasource="sifinterfaces">
				insert into HPS_PMI_GL_HEADER
				select * from PS_PMI_GL_HEADER
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                	and PMI_GL_COD_EJEC = ltrim(rtrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsENomina.PMI_GL_COD_EJEC#">))
			</cfquery>

			<cfquery datasource="sifinterfaces">
				insert into HPS_PMI_GL_DET_NOM
				select * from PS_PMI_GL_DET_NOM
                where PMI_GL_COD_EJEC = ltrim(rtrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsENomina.PMI_GL_COD_EJEC#">))
			</cfquery>
			<cfquery datasource="sifinterfaces">
				delete PS_PMI_GL_DET_NOM
                where PMI_GL_COD_EJEC = ltrim(rtrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsENomina.PMI_GL_COD_EJEC#">))
			</cfquery>
			<cfquery datasource="sifinterfaces">
				delete PS_PMI_GL_HEADER
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                 and PMI_GL_COD_EJEC = ltrim(rtrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsENomina.PMI_GL_COD_EJEC#">))
			</cfquery>
			<cfif isdefined('Application.dsinfo.peoplesoft')>
				<cfquery datasource="peoplesoft">
					delete PS_PMI_GL_DET_NOM
	                where PMI_GL_COD_EJEC = ltrim(rtrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsENomina.PMI_GL_COD_EJEC#">))
				</cfquery>

				<cfquery datasource="peoplesoft">
					delete PS_PMI_GL_HEADER
	               	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	                	and PMI_GL_COD_EJEC = ltrim(rtrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsENomina.PMI_GL_COD_EJEC#">))
				</cfquery>
			</cfif>
			<cfcatch type="any">
				<!---Elimina el registro insertado---->
				<cfquery datasource="sifinterfaces">
					delete ID925
					where ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#varIDmax#">
				</cfquery>
				<cfquery datasource="sifinterfaces">
					delete IE925
					where ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#varIDmax#">
				</cfquery>
				<!---Elimina el registro insertado interfaz 926---->
					<cfquery datasource="sifinterfaces">
						delete ID926
					where ID in (select ID from IE926 where Num_Nomina = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsENomina.PMI_GL_COD_EJEC#">)
					</cfquery>
					<cfquery datasource="sifinterfaces">
						delete IE926
					where Num_Nomina = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsENomina.PMI_GL_COD_EJEC#">
					</cfquery>
				<cfif isdefined("varHMax") and varHMax GT 0>
					<cfquery datasource="sifinterfaces">
						delete Det_Pago_Nomina
						where ID_Nomina = <cfqueryparam cfsqltype="cf_sql_integer" value="#varHMax#">
					</cfquery>
					<cfquery datasource="sifinterfaces">
						delete Enc_Pago_Nomina
						where ID_Nomina = <cfqueryparam cfsqltype="cf_sql_integer" value="#varHMax#">
					</cfquery>
				</cfif>
				<cfif isdefined("cfcatch.sql")> <cfset ErrSQL = cfcatch.sql> <cfelse> <cfset ErrSQL = ""> </cfif>
				<cfif isdefined("cfcatch.where")> <cfset ErrPar = cfcatch.where> <cfelse> <cfset ErrPar = ""> </cfif>
            	<cfthrow message="Error al Insertar en la consola: #cfcatch.Message#" detail="#cfcatch.Detail# #ErrSQL# #ErrPar#">
			</cfcatch>
			</cftry>

	</cfif>

	<!---Validación de compromisos por Programa Rubro y Subrubro siempre y cuando este inactivo el parametro de Validar compromiso por cuenta presupuestal--->
	<cfquery name="rsValidaCtaPptal" datasource="#session.dsn#">
		select Pvalor
		from Parametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
			  and Pcodigo = 1131
	</cfquery>

	<cfif isdefined("rsValidaCtaPptal") and rsValidaCtaPptal.Pvalor EQ 'S' and #rsENomina.PMI_GL_CANCELACION# EQ 'N'>
		 <cfinvoke component="sif.presupuesto.Componentes.PRES_ValidaPptoCompromiso" method="Valida_CompromisosObligatorios">
		 	<cfinvokeargument name="Num_Nomina" value="#rsENomina.PMI_GL_COD_EJEC#">
			<cfinvokeargument name="Periodo" value="#Periodo#">
			<cfinvokeargument name="Mes" value="#Mes#">
			<cfinvokeargument name="ID" value="#varIDmax#">
			<cfinvokeargument name="Ocodigo" value="#rsOficina.Ocodigo#">
			<cfinvokeargument name="Oficodigo" value="#rsOficina.Oficodigo#">
			<cfinvokeargument name="Fecha_Nom" value="#rsENomina.PMI_GL_FECHA_EMISI#">
         </cfinvoke>

		 <cfquery name="rsValidaNRC" datasource="sifinterfaces">
			select count(*) as NRCs
			from NRCE_Nomina
			where NRC_NumNomina = ltrim(rtrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsENomina.PMI_GL_COD_EJEC#">))
		</cfquery>

		<cfif rsValidaNRC.NRCs GT 0>
			<cfthrow message="Existen errores de compromiso, consulte el detalle en la opción de Errores.">
		</cfif>
	</cfif>

	<cfif not varError>
		<cflocation url="/cfmx/interfacesTBS/Interfaz925PMI-Param.cfm">
	<cfelse>
		<form name="form1" action="file:///X|/servers/cfusion/cfusion-ear/cfusion-war/interfacesTBS/Interfaz925PMI-Param.cfm" method="post">
    	<center>
        	<table border="1" align="center">
            	<tr>
                	<td width="100%" align="center">
                    	<strong> SE PRESENTARON ERRORES AL APLICAR REGISTROS</strong>
                    </td>
                </tr>
                <tr>
                	<td width="100%" align="center">
                    	<input type="submit" name="btnRegresa" value="Regresar" />
                    </td>
                </tr>
            </table>
        </center>
    	</form>
	</cfif>
</cfif>

<cffunction name = 'ExtraeMaximo' returntype="numeric">
    <cfargument name='Tabla' type='string'	required='true' hint="Tabla">
    <cfargument name='CampoID' type='string'	required='true' hint="Proceso">

    <cfquery name="rsMaximo_Tabla" datasource="sifinterfaces">
        select coalesce (max(#Arguments.CampoID#), 0) + 1 as Maximo from #Arguments.Tabla#
    </cfquery>

    <cfif rsMaximo_Tabla.RecordCount GT 0 and rsMaximo_Tabla.Maximo NEQ "">
        <cfset Max_Tabla = rsMaximo_Tabla.Maximo>
    <cfelse>
        <cfset Max_Tabla = 0>
    </cfif>

    <cfquery name="rsMaximo_IdProceso" datasource="sifinterfaces">
        select 1
        from IdProceso
    </cfquery>

    <cfif rsMaximo_IdProceso.recordcount LTE 0>
        <cfquery datasource="sifinterfaces">
            insert IdProceso(Consecutivo,BMUsucodigo) values(0,1)
        </cfquery>
    </cfif>

    <cfquery name="rsMaximo_IdProceso" datasource="sifinterfaces">
        select isnull(max(Consecutivo),0) + 1 as Maximo
        from IdProceso
    </cfquery>

    <cfset Max_Cons = rsMaximo_IdProceso.Maximo>

    <cfif  Max_Cons LT Max_Tabla>
        <cfset retvalue = rsMaximo_Tabla>
    <cfelse>
        <cfset retvalue = rsMaximo_IdProceso>
    </cfif>
    <cfquery datasource="sifinterfaces">
        update IdProceso
        set Consecutivo = #retvalue.Maximo#
    </cfquery>
    <cfreturn retvalue.Maximo>
</cffunction>

<!--- FUNCION GETCECODIGO --->
<cffunction name="getCEcodigo" returntype="string" output="no">
	<cfargument name="Ecodigo" type="numeric" required="true" hint="Ecodigo">

	<cfquery name="rsCEcodigo" datasource="#session.dsn#">
        select CEcodigo
        from Empresa e
            inner join Empresas s
            on  e.Ereferencia = s.Ecodigo
			and s.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
    </cfquery>
    <cfreturn rsCEcodigo.CEcodigo>
</cffunction>


