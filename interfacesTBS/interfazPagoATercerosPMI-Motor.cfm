<!--- JMRV. Inicio. Pagos a terceros. 27/10/2014 --->
			
<cfsetting requesttimeout="36000">

<cfset sifinterfacesdb = Application.dsinfo.sifinterfaces.schema>
		
<cfif (isdefined("form.chk"))><!--- Pagos elegidos con el check --->
	<cfset datos = ListToArray(Form.chk,",")>
  <cfset limite = ArrayLen(datos)>
	<cfset varError = false>	

<!--- Tabla temporal de errores --->
<cf_dbtemp name="TempErrores" returnvariable="TempErrores" datasource="#session.DSN#">
	<cf_dbtempcol name="Pago"			type="varchar(15)" 	mandatory="yes">
	<cf_dbtempcol name="Mensaje"	type="text" 				mandatory="yes">
</cf_dbtemp>
	 
	<cfloop from="1" to="#limite#" index="idx"><!--- Para cada una de las lineas de pago --->

		<cfset Rdatos = ListToArray(datos[idx],"|")>
		<cfset GvarConexion  = Session.Dsn>
		<cfset GvarEcodigo   = Session.Ecodigo>	
		<cfset GvarUsuario   = Session.Usuario>
		<cfset GvarUsucodigo = Session.Usucodigo>
		<cfset GvarEcodigoSDC= Session.EcodigoSDC>
    <cfset varCEcodigo = getCEcodigo(GvarEcodigo)>
		
		<!--- Encabezado, lo toma de los datos de la linea de pago --->
		<cfquery name="rsENomina" datasource="sifinterfaces">	
			select 	PMI_COD_PAGO, PMI_OBSERVACIONES, PMI_FECHA_EMISI, PMI_LINEA,
							PMI_MONEDA, isnull(PMI_FORMA_PAGO,0) as PMI_FORMA_PAGO 
			from 	PS_PMI_INTFZ_PGTR
			where 	PMI_COD_PAGO = '#Rdatos[1]#'
			and 	PMI_LINEA = #Rdatos[2]#
		</cfquery>
			
		<!---Extrae Maximo ID--->
    <cfset varIDmax = ExtraeMaximo("IE925","ID")>
    <cfset InsertaConsola = False>
    <cfset insertaColaDeProcesos = False>
        
		<cfif isdefined("rsENomina") and rsENomina.recordcount GT 0>

		<cftry>		
			<!---Valida que no se duplique el número de pago a tercero---> 
			<cfquery name="rsExisteCodNom" datasource="sifinterfaces">
				select ID from IE926
				where ltrim(rtrim(Num_Nomina)) = ltrim(rtrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsENomina.PMI_COD_PAGO#">))
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
			</cfquery>
				
			<cfif rsExisteCodNom.recordcount GT 0>
				<cfthrow message="El pago #Rdatos[1]# ya existe en SIF">
			</cfif>	

			<!---Valida que la moneda exista para la empresa--->
			<cfif isdefined("rsENomina.PMI_MONEDA") and rsENomina.PMI_MONEDA NEQ ''>
				<cfquery name="rsMoneda" datasource="#GvarConexion#">
					select Miso4217
					from Monedas
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#GvarEcodigo#">
					and Miso4217 = <cfqueryparam cfsqltype="cf_sql_char" value="#rsENomina.PMI_MONEDA#">
				</cfquery>				
				<cfif rsMoneda.recordcount EQ 0>
					<cfthrow message="La moneda #rsENomina.PMI_MONEDA# no esta definida para esta empresa">
				<cfelse>	
					<cfset varMonedaL = rsMoneda.Miso4217>
				</cfif>	
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
			
			<!--- Detalle, lo toma de los datos de la linea de pago --->
      			<cfquery name="rsDNomina" datasource="sifinterfaces">
		   		select  ltrim(rtrim(PMI_COD_PAGO)) as PMI_COD_PAGO, 
				   case when (convert (int, PMI_RUBRO)) = 0 then null else (convert (int, PMI_RUBRO)) end as PMI_RUBRO,
				   case when convert(int, PMI_SUBRUBRO) = 0 then null else convert(int, PMI_SUBRUBRO) end as PMI_SUBRUBRO, 
           			   PMI_BENEFICIARIO,
           			   PMI_DESCRIPCION, 
				   PMI_IMPORTE, 
				   case when (convert (int, PMI_CTRO_COSTOS)) = 0 then null else (convert (int,	PMI_CTRO_COSTOS)) end as PMI_CTRO_COSTOS, 
           			   PMI_CUENTA, 
           			   case when convert(int, PMI_SNEGOCIOS) = 0 then null else convert(int, PMI_SNEGOCIOS) end as PMI_SNEGOCIOS,
           			   COD_CONCEPTO = convert(varchar(5),PMI_RUBRO)+right(('00'+convert(varchar,PMI_SUBRUBRO)),3)      
	               
		       		from  PS_PMI_INTFZ_PGTR
  		  		where PMI_COD_PAGO = '#rsENomina.PMI_COD_PAGO#'
  		  		and	 PMI_LINEA = #rsENomina.PMI_LINEA#
  	  		</cfquery>
			
				<!---Extrae el consecutivo para el detalle--->
				<cfquery name="maxID926" datasource="sifinterfaces">
					select isnull(MAX(DConsecutivo),0) as DConsecutivo
					from ID926
					where ReferenciaOri =ltrim(rtrim('#rsENomina.PMI_COD_PAGO#'))
				</cfquery>
			
				<cfset varDConsecutivoID926 = maxID926.DConsecutivo + 1>
			
			<cfif isdefined("rsDNomina") and rsDNomina.recordcount GT 0>

					<cfset Cuenta = ''>

					<!----Valida la clasificacion del concepto enviado---->
					<cfif isdefined("rsDNomina.PMI_RUBRO") and rsDNomina.PMI_RUBRO NEQ ''>
						<cfquery name="rsCConcepto" datasource="#GvarConexion#">
							select CCid, CCcodigo, CCdescripcion 
							from CConceptos
							where CCcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDNomina.PMI_RUBRO#">
						</cfquery>				
				
						<cfif rsCConcepto.recordcount EQ 0>
							<cfthrow message="El rubro #rsDNomina.PMI_RUBRO# no existe dentro de SIF">
						<cfelse>	
							<cfset varCConcepto = #rsCConcepto.CCid#>
						</cfif>	
					</cfif>			
								
					<!---Valida que el beneficiario exista en la tesoreria, si no se tiene beneficiario valida el socio de negocios---->
					<cfif rsDNomina.PMI_BENEFICIARIO NEQ '' and len(trim(rsDNomina.PMI_BENEFICIARIO))>
						<cfquery name="rsBeneficiario" datasource="#GvarConexion#">
							select TESBeneficiarioId, TESBeneficiario, TESBid
							from TESbeneficiario
							where TESBeneficiarioId = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDNomina.PMI_BENEFICIARIO#">	
						</cfquery>
						<cfif rsBeneficiario.recordcount EQ 0>
							<cfthrow message="El beneficiario #rsDNomina.PMI_BENEFICIARIO# del pago a realizar no existe">
						</cfif>
					<cfelseif rsDNomina.PMI_SNEGOCIOS NEQ ''>
						<cfquery name="rsSocio" datasource="#GvarConexion#">
							select SNid, SNcodigo
							from SNegocios
							where SNcodigoext = '#rsDNomina.PMI_SNEGOCIOS#'						
						</cfquery>
						<cfif rsSocio.recordcount EQ 0>
							<cfthrow message="El socio de negocios #rsDNomina.PMI_SNEGOCIOS# del pago a realizar no existe">
						<cfelse>
							<cfset SNcodigo = rsSocio.SNcodigo>
						</cfif>
					<cfelse>
						<cfthrow message="No estan definidos ni el socio de negocios ni un beneficiario para el pago #rsENomina.PMI_COD_PAGO#">
					</cfif>	

					<!---Si el tipo de pago es 2(TEF) entonces valida que exista la cuenta destino--->
					<cfif isdefined("rsENomina.PMI_FORMA_PAGO") and rsENomina.PMI_FORMA_PAGO EQ 2>
						<cfif rsDNomina.PMI_BENEFICIARIO NEQ ''>
							<cfquery name="rsCtaDestino" datasource="#GvarConexion#">
								select TESTPid
								from TEStransferenciaP	 
								where TESBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsBeneficiario.TESBid#">
								and TESTPestado = 1
							</cfquery>	
						<cfelse>
							<cfquery name="rsCtaDestino" datasource="#GvarConexion#">
								select TESTPid
								from TEStransferenciaP	 
								where SNidP = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSocio.SNid#">
								and TESTPestado = 1
							</cfquery>	
						</cfif>	
						<cfif rsCtaDestino.recordcount EQ 0>
							<cfthrow message="La cuenta destino para la forma de pago TEF del pago #Rdatos[1]# no esta definida">
						</cfif>	
					</cfif>
				
					<!--- JMRV. Inicio. 12/01/2015 --->
					<!---Valida Unidad Ejecutora--->
					<cfif rsDNomina.PMI_CTRO_COSTOS EQ ''>
						<cfset CTRO_COSTOS = 'RAIZ'>		
					<cfelse>
						<cfset CTRO_COSTOS = rsDNomina.PMI_CTRO_COSTOS>		
					</cfif>		

					<!--- Busca si el codigo de centro de costos que viene del sistema externo existe como centro funcional en sif --->
					<cfquery name="rsUnidadEjec" datasource="#GvarConexion#">
						select * from CFuncional 
						where CFcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CTRO_COSTOS#">	
						and    Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">	
					</cfquery>		

					<!--- Si no encuentra un centro funcional con CFcodigo = CTRO_COSTOS --->
					<cfif rsUnidadEjec.recordcount EQ 0>
						<!--- Verifica si el codigo de centro de costos que proviene del sistema externo tiene un mapeo con un centro funcional en sif --->
						<cfquery name="rsCambiaCtroCostos" datasource="sifinterfaces">
							select  EQUcodigoSIF
	        	  				from SIFLD_Equivalencia
	            					where SIScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="ICTS">  
	            					and CATcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="CENTRO_FUN">
	            					and EQUempSIF = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
		          				and EQUcodigoOrigen = <cfqueryparam cfsqltype= "cf_sql_varchar" value="#CTRO_COSTOS#">
						</cfquery>	
						<!--- Si encuentra un mapeo --->
						<cfif isdefined("rsCambiaCtroCostos") and rsCambiaCtroCostos.recordcount EQ 1>
							<cfset CTRO_COSTOS = #rsCambiaCtroCostos.EQUcodigoSIF#>
						<!--- Si no encuentra un mapeo es porque el codigo es invalido --->
						<cfelse>
							<cfthrow message="El Centro Funcional #CTRO_COSTOS# no existe en el SIF">
						</cfif>
					</cfif>
							
					<!---Obtiene la equivalencia del Centro Funcional--->
					<cfquery name="rsEquivCF" datasource="sifinterfaces">
						select  SIScodigo, CATcodigo, EQUempOrigen, EQUcodigoOrigen, EQUempSIF, EQUcodigoSIF, EQUidSIF 
    	    					from SIFLD_Equivalencia
        					where SIScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="ICTS">  
        					and CATcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="CENTRO_FUN">
            					and EQUempSIF = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
             					and EQUcodigoSIF = <cfqueryparam cfsqltype= "cf_sql_varchar" value="#CTRO_COSTOS#">
					</cfquery>	
					<cfif isdefined("rsEquivCF") and rsEquivCF.recordcount GT 0>
						<cfset CentroFun = rsEquivCF.EQUidSIF>
					<cfelse>
						<cfthrow message="Debe registrar la equivalencia para el Centro Funcional #CTRO_COSTOS#">
					</cfif>	
								
					<!----Obtiene el codigo de oficina--->
					<cfquery name="rsOficina" datasource="#Gvarconexion#">
						 select o.Ocodigo, o.Oficodigo
						 from Oficinas o
						 	inner join CFuncional cf
						 		on  o.Ecodigo = cf.Ecodigo
						 		and o.Ocodigo = cf.Ocodigo
						 where o.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
						 and cf.CFcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CTRO_COSTOS#">
					</cfquery>
					<cfif isdefined("rsOficina") and rsOficina.recordcount EQ 1>
						<cfset varOficina = #rsOficina.Oficodigo#>	
					<cfelse>
						<cfthrow message="No existen oficinas registradas para la empresa #GvarEcodigo#">
					</cfif>	
					<!--- JMRV. Fin. 07/01/2015 --->
					
					<!--- Cuenta --->	
					<cfif rsDNomina.PMI_CUENTA EQ "" and rsDNomina.PMI_RUBRO NEQ "" and rsDNomina.PMI_SUBRUBRO NEQ "">
						<!---Busca la cuenta de gasto del concepto de servicio---->
						<cfquery datasource="#GvarConexion#" name="rsCtaGasto">
							select C.Cformato, Cid from Conceptos C
							where Ccodigo = ltrim(rtrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDNomina.COD_CONCEPTO#">))
						</cfquery>	
						
						<cfif rsCtaGasto.recordcount GT 0 and trim(rsCtaGasto.Cformato) NEQ ''>
							<cfif find("?",rsCtaGasto.Cformato) or find("!",rsCtaGasto.Cformato)>
								<cfobject component="sif.Componentes.AplicarMascara" name="mascara">
								<cfset vCPformato = mascara.fnComplementoItem(session.Ecodigo, rsUnidadEjec.CFid, -1, 'S', "",rsCtaGasto.Cid, "", "")> 
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
                				<cfthrow message="Error: #rsDNomina.PMI_RUBRO#, #rsDNomina.PMI_SUBRUBRO#, #rsDNomina.PMI_CUENTA# #Lvar_MsgError#"> 
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
							<!---Arma la cuenta contable a afectar---->
							<cfinvoke returnvariable="CuentaNomina" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
							Oorigen="PMIH"
							Ecodigo="#GvarEcodigo#"
							Conexion="#GvarConexion#"
							CConceptos="#varCConcepto#"
							PMI_SubRubros="#rsDNomina.PMI_SUBRUBRO#"
							CFuncional="#CentroFun#"
							PMI_Tipo_Contraparte = "N/A"
							SNegocios="N/A">				
							</cfinvoke>          			
							<cfset Cuenta = CuentaNomina.CFformato>		
							<cfquery name="rsCFCuenta" datasource="#GvarConexion#">
        	            			select CFcuenta, Ccuenta,CPcuenta,CFformato   
				                    from CFinanciera 
    	    			            where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">			
			        	            and  CFformato = <cfqueryparam cfsqltype="cf_sql_char" value="#Cuenta#">
        			    	</cfquery>
							<cfset CFcuenta = rsCFCuenta.CFcuenta>		
						</cfif>						
					<cfelseif rsDNomina.PMI_CUENTA NEQ "">
						<cfquery name="rsFCuenta" datasource="#GvarConexion#">
							select F.CFformato, F.CFcuenta from Conceptos C
							inner join CFinanciera F on C.Cformato = F.CFformato
							where Ccodigo = ltrim(rtrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDNomina.PMI_CUENTA#">))						
						</cfquery>
						<cfif isdefined("rsFCuenta") and rsFCuenta.recordcount GT 0>
							<cfset Cuenta = rsFCuenta.CFformato>
							<cfset CFcuenta = rsFCuenta.CFcuenta>
						<cfelse>
							<cfthrow message="No se pudo obtener la cuenta a afectar. Concepto: #rsDNomina.PMI_CUENTA#">
						</cfif>
					<cfelse>
						<cfthrow message="Imposible obtener la cuenta a afectar. Rubro: #rsDNomina.PMI_RUBRO#, Subrubro: #rsDNomina.PMI_SUBRUBRO#">
					</cfif><!--- Cuenta --->
				
					<cftransaction action="begin">				
					<cftry>
					<!----Se inserta el registro en la interfaz 926 para que se generen las solicitudes de pago en Tesoreria---->

						<!----Validamos si ya existe el encabezado--->
						<cfset varIDmax926 = ExtraeMaximo("IE926","ID")>
						<cfquery name="rsExisteEnc" datasource="sifinterfaces">
							select Empleado, ID from IE926 
							where Num_Nomina = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsENomina.PMI_COD_PAGO#">
							and Ecodigo =<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
						</cfquery>
												
						<!---Si no existe encabezado con el COD_PAGO se inserta uno--->
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
								SNcodigo,
								Observaciones,
								BMUsucodigo,
								Forma_Pago)						<!--- JMRV. 14/10/2014 --->
							 	values
							 	(<cfqueryparam cfsqltype="cf_sql_integer" value="#varIDmax926#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">,
								ltrim(rtrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsENomina.PMI_COD_PAGO#">)),
								<cfqueryparam cfsqltype="cf_sql_date" value="#rsENomina.PMI_FECHA_EMISI#">,
								<cfqueryparam cfsqltype="cf_sql_date" value="#rsENomina.PMI_FECHA_EMISI#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDNomina.PMI_DESCRIPCION#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#GvarUsuario#">,								
								<cfif isdefined("rsDNomina.PMI_BENEFICIARIO") and rsDNomina.PMI_BENEFICIARIO NEQ "">
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDNomina.PMI_BENEFICIARIO#">,
								<cfelse>
									null,
								</cfif>					
								<cfif isdefined("rsDNomina.PMI_BENEFICIARIO") and rsDNomina.PMI_BENEFICIARIO EQ "" and isdefined("SNcodigo") and SNcodigo NEQ "">
									<cfqueryparam cfsqltype="cf_sql_integer" value="#SNcodigo#">,
								<cfelse>
									null,
								</cfif>		
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsENomina.PMI_OBSERVACIONES#">,		
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarUsucodigo#">,
								<cfif rsENomina.PMI_FORMA_PAGO lt 0 or rsENomina.PMI_FORMA_PAGO gt 3>
									<cfqueryparam cfsqltype="cf_sql_numeric" value="0">
								<cfelse>
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsENomina.PMI_FORMA_PAGO#">
								</cfif>)						
							</cfquery>
							
							<cfset varDConsecutivoID926 = 1>
							<cfset insertaColaDeProcesos = True>
						
						<!---Si ya existe un encabezado no se inserta nada--->
						<cfelse>			
							<cfset varIDmax926 = rsExisteEnc.ID>
							<cfset varDConsecutivoID926 = varDConsecutivoID926 + 1>
							<cfset insertaColaDeProcesos = False>
						</cfif><!---Encabezado--->
						
						<cfif CFcuenta eq ''>
						<cfthrow message="CUENTA #CFcuenta# #rsDNomina.PMI_RUBRO#, #rsDNomina.PMI_SUBRUBRO#">
						</cfif>
						
						<!---Inserta el detalle--->
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
								'TESP',
								ltrim(rtrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsENomina.PMI_COD_PAGO#-#varDConsecutivoID926#">)),
								ltrim(rtrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsENomina.PMI_COD_PAGO#">)),
								<cfqueryparam cfsqltype="cf_sql_date" value="#rsENomina.PMI_FECHA_EMISI#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#varMonedaL#">,
								round(#rsDNomina.PMI_IMPORTE#,2),
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDNomina.PMI_DESCRIPCION#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#CFcuenta#">,
								ltrim(rtrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Cuenta#">)),
								'D',
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
								1,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#CTRO_COSTOS#">,
								<cfif rsDNomina.PMI_CUENTA NEQ ""> 
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDNomina.PMI_CUENTA#">,								
								<cfelse>
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDNomina.COD_CONCEPTO#">,	
								</cfif>
								<cfqueryparam cfsqltype="cf_sql_bit" value="False">)								
						</cfquery>
						
						<cftransaction action="commit"/>
						<cfset InsertaConsola = True>

					<cfcatch type="any">
						<cftransaction action="rollback"/>
						<cfset insertaColaDeProcesos = False>
						<cfif isdefined("cfcatch.sql")> <cfset ErrSQL = cfcatch.sql> <cfelse> <cfset ErrSQL = ""> </cfif>
						<cfif isdefined("cfcatch.where")> <cfset ErrPar = cfcatch.where> <cfelse> <cfset ErrPar = ""> </cfif>
          	<!---<cfthrow message="#cfcatch.Message#" detail="#cfcatch.Detail# #ErrSQL# #ErrPar#">--->
          	<cfquery datasource="#session.DSN#">
          		insert into #TempErrores# (Pago,Mensaje)
          		values('#Rdatos[1]#','#cfcatch.Message#')
          	</cfquery>
        	</cfcatch>
  	    	</cftry>
					</cftransaction>
				<cfelse>
					<cfthrow message="El pago #rsENomina.PMI_COD_PAGO# no tiene detalles">
				</cfif>
			<cfcatch>
				<cfset insertaColaDeProcesos = False>
				<cfif isdefined("cfcatch.sql")> <cfset ErrSQL = cfcatch.sql> <cfelse> <cfset ErrSQL = ""> </cfif>
				<cfif isdefined("cfcatch.where")> <cfset ErrPar = cfcatch.where> <cfelse> <cfset ErrPar = ""> </cfif>
        <!---<cfthrow message="#cfcatch.Message#" detail="#cfcatch.Detail# #ErrSQL# #ErrPar#">--->
        <cfquery datasource="#session.DSN#">
      		insert into #TempErrores# (Pago,Mensaje)
      		values('#Rdatos[1]#','#cfcatch.Message#')
        </cfquery>
			</cfcatch>				
			</cftry>
			
		<cfelse>
			<cfthrow message="No existen pagos nuevos para procesar">
		</cfif>

		<cfif insertaColaDeProcesos>
			<cfif InsertaConsola>

			<cftransaction action="begin">		
			<cftry>
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
				from IE926 where Num_Nomina = ltrim(rtrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsENomina.PMI_COD_PAGO#">)))
      	</cfquery>
	          	
				<!----INSERTA EL REGISTRO DE LA NOMINA EN TABLAS DE HISTORICO--->
				<cfquery datasource="sifinterfaces">
					insert into HPS_PMI_INTFZ_PGTR 		(PMI_COD_PAGO, PMI_OBSERVACIONES, PMI_FECHA_EMISI, PMI_LINEA,
														PMI_RUBRO, PMI_SUBRUBRO,
														PMI_BENEFICIARIO, PMI_DESCRIPCION,
														PMI_IMPORTE, PMI_CTRO_COSTOS, PMI_CUENTA,
														PMI_SNEGOCIOS, Id_926
														, PMI_MONEDA, PMI_FORMA_PAGO)<!---JMRV 14/10/2014--->
														
					select 	PMI_COD_PAGO, PMI_OBSERVACIONES, PMI_FECHA_EMISI, PMI_LINEA,
							PMI_RUBRO, PMI_SUBRUBRO,
							PMI_BENEFICIARIO, PMI_DESCRIPCION,  
							PMI_IMPORTE, PMI_CTRO_COSTOS, PMI_CUENTA,
							PMI_SNEGOCIOS, #varIDmax926# as Id_926
							, PMI_MONEDA, isnull(PMI_FORMA_PAGO,0) as PMI_FORMA_PAGO<!---JMRV 14/10/2014--->
							
					from PS_PMI_INTFZ_PGTR
					where 	PMI_COD_PAGO = '#Rdatos[1]#'
					and 	PMI_LINEA = #Rdatos[2]#
				</cfquery>

				<!----Borra los datos de la tabla--->
				<cfquery datasource="sifinterfaces">
					delete PS_PMI_INTFZ_PGTR
					where 	PMI_COD_PAGO = '#Rdatos[1]#'
					and 	PMI_LINEA = #Rdatos[2]#
				</cfquery>
				<cftransaction action="commit"/>

				<cfcatch type="any">
					<cftransaction action="rollback"/>
					<cfif isdefined("cfcatch.sql")> <cfset ErrSQL = cfcatch.sql> <cfelse> <cfset ErrSQL = ""> </cfif>
					<cfif isdefined("cfcatch.where")> <cfset ErrPar = cfcatch.where> <cfelse> <cfset ErrPar = ""> </cfif>
	        <!---<cfthrow message="Error al Insertar en la consola: #cfcatch.Message#" detail="#cfcatch.Detail# #ErrSQL# #ErrPar#">--->
        	<cfquery datasource="#session.DSN#">
    				insert into #TempErrores# (Pago,Mensaje)
    				values('#Rdatos[1]#','#cfcatch.Message#')
    			</cfquery>
				</cfcatch>	
				</cftry>
				</cftransaction>
			</cfif><!--- insertaConsola --->
		</cfif><!--- insertaColaDeProcesos --->	
	
	</cfloop> <!----Lineas de pago---->

	<cfquery name="Errores" datasource="#session.DSN#">
		select * from #TempErrores# 
	</cfquery>
	<cfif Errores.recordcount gt 0><!--- Si la insercion de alguno de los pagos provoco un error --->
		<cfset MensajeError = ''>
		<cfloop query="Errores">
			<cfset MensajeError = MensajeError & "Pago NO aplicado: #Errores.Pago# Error: #Mensaje#<br>">
		</cfloop>
		<cfif limite gt Errores.recordcount>
			<cfset MensajeError = MensajeError & "<p>&nbsp;</p>El resto de los pagos fueron aplicados<p>&nbsp;</p>">
		<cfelse>
			<cfset MensajeError = MensajeError & "<p>&nbsp;</p>Ningun pago fue aplicado<p>&nbsp;</p>">
		</cfif>
		<cfthrow message="#MensajeError#">
	</cfif><!--- error al insertar un pago --->
	       
	<cfif not varError>	
		<cflocation url="/cfmx/interfacesTBS/InterfazPagoATercerosPMI-Param.cfm?Exito=1">
	<cfelse>
		<form name="form1" action="file:///X|/servers/cfusion/cfusion-ear/cfusion-war/interfacesTBS/InterfazPagoATercerosPMI-Param.cfm" method="post">
    	<center>
        	<table border="1" align="center">
            	<tr>
                	<td width="100%" align="center">
                    	<strong>SE PRESENTARON ERRORES AL APLICAR REGISTROS</strong>
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
    
    <cfif rsMaximo_Tabla.Maximo NEQ "">
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

<!--- JMRV. Fin. Pagos a terceros. 27/10/2014 --->

             