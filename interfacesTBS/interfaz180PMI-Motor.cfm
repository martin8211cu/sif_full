<cfif (isdefined("form.chk"))><!--- Viene de la lista --->
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
					
        <cfquery name="rsENomina" datasource="sifinterfaces">
         	select PMI_GL_COD_EJEC, PMI_GL_DESCRIPCION, PMI_GL_FECHA_EMISI, PMI_GL_COD_EJEC_REF, <!---campo nuevo checar el nombre--->PMI_GL_CANCELACION
			from 
			PS_PMI_GL_HEADER	
			where 
			PMI_GL_COD_EJEC like <cfqueryparam cfsqltype="cf_sql_varchar" value="#Rdatos[1]#">
			<!---and PMI_GL_CANCELACION = <cfqueryparam cfsqltype="cf_sql_bit" value="#Rdatos[2]#">--->
        </cfquery>
	</cfloop>
		
		<!---Extrae Maximo ID--->
        <cfset varIDmax = ExtraeMaximo("IE180","ID")>
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
			
			<cftransaction action="begin">
			<cftry>
				<cfquery datasource= "sifinterfaces">
				insert into IE180
					(ID,
					Ecodigo,
					Cconcepto,
					Num_Nomina,
					Fecha_Emision,
					Descripcion_Nomina,
					Cancelacion,
					Nomina_Ref,
					Periodo,
					Mes)
				 values
				 	(<cfqueryparam cfsqltype="cf_sql_integer" value="#varIDmax#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">,
					180,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsENomina.PMI_GL_COD_EJEC#">,
					<cfqueryparam cfsqltype="cf_sql_date" value="#rsENomina.PMI_GL_FECHA_EMISI#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsENomina.PMI_GL_DESCRIPCION#">,
					<cfqueryparam cfsqltype="cf_sql_bit" value="#rsENomina.PMI_GL_CANCELACION#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsENomina.PMI_GL_COD_EJEC_REF#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">)														
				</cfquery>
				
				<cftransaction action="commit"/>				
				<cfcatch type="any">
				<cftransaction action="rollback"/>
				<!---Elimina el registro insertado--->
				<cfquery datasource="sifinterfaces">
					delete IE180 
					where ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#varIDmax#"> 
				</cfquery>
    	        <cfif isdefined("cfcatch.sql")> <cfset ErrSQL = cfcatch.sql> <cfelse> <cfset ErrSQL = ""> </cfif>
				<cfif isdefined("cfcatch.where")> <cfset ErrPar = cfcatch.where> <cfelse> <cfset ErrPar = ""> </cfif>
            	<cfthrow message="Error al Insertar el Encabezado: #cfcatch.Message#" detail="#cfcatch.Detail# #ErrSQL# #ErrPar#">
	        	</cfcatch>
    	    	</cftry>
				</cftransaction>		
			
         	<cfquery name="rsDNomina" datasource="sifinterfaces">
			 	select PMI_GL_COD_EJEC, PMI_GL_LINEA, PMI_GL_RUBRO, PMI_GL_SUBRUBRO, PMI_GL_EMPLEADO, PMI_GL_DESCRIPCION,
				PMI_GL_TIPO, PMI_GL_IMPORTE, PMI_GL_CTRO_COSTOS, PMI_GL_CUENTA
				from PS_PMI_GL_DET_NOM
				where PMI_GL_COD_EJEC = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsENomina.PMI_GL_COD_EJEC#">
    	    </cfquery>
			
			<cfset DConsecutivo = 1>
			<cfif isdefined("rsDNomina") and rsDNomina.recordcount GT 0>
			<cfloop query="rsDNomina">
				<!----Valida la clasificacion del concepto enviado---->
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
								
				<!---Valida que el beneficiario exista en la tesoreria---->
				<cfif rsDNomina.PMI_GL_EMPLEADO NEQ '' and rsDNomina.PMI_GL_DESCRIPCION EQ 'SUELDOS POR PAGAR'>
					<cfquery name="rsBeneficiario" datasource="#GvarConexion#">
						select TESBeneficiarioId, TESBeneficiario,
						from TESbeneficiario
						where TESBeneficiarioId = <cfqueryparam cfsqltype="cf_sql_integer" value="#PMI_GL_EMPLEADO#">						
					</cfquery>
				
					<cfif rsBeneficiario.recordcount EQ 0>
						<cfthrow message="El beneficiario #rsDNomina.PMI_GL_EMPLEADO# de la Nómina no existe en la Tesoreria del SIF">
					</cfif>
				</cfif>	
				
				<!---Valida Unidad Ejecutora--->
				<cfquery name="rsUnidadEjec" datasource="#GvarConexion#">
					select * from CFuncional 
					where CFcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDNomina.PMI_GL_CTRO_COSTOS#">					
				</cfquery>
				
				<cfif rsUnidadEjec.recordcount EQ 0>
					<cfthrow message="El Centro Funcional #rsDNomina.PMI_GL_CTRO_COSTOS# no existe en el SIF">
				</cfif>
				
				<!---Obtiene la equivalencia del Centro Funcional--->
				<cfquery name="rsEquivCF" datasource="sifinterfaces">
					select  SIScodigo, CATcodigo, EQUempOrigen, EQUcodigoOrigen, EQUempSIF, EQUcodigoSIF, EQUidSIF 
            		from SIFLD_Equivalencia
            		where SIScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="ICTS">  
            		and CATcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="CENTRO_FUN">
                	and EQUempSIF = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
                	and EQUcodigoSIF = <cfqueryparam cfsqltype= "cf_sql_varchar" value="#rsDNomina.PMI_GL_CTRO_COSTOS#">
				</cfquery>	
				
				<cfif isdefined("rsEquivCF") and rsEquivCF.recordcount GT 0>
					<cfset CentroFun = rsEquivCF.EQUidSIF>
				<cfelse>
					<cfthrow message="Debe registrar la equivalencia para el Centro Funcional #PMI_GL_CTRO_COSTOS#">
				</cfif>	
				
				<!----Obtiene el código de oficina--->
				<cfquery name="rsOficina" datasource="#Gvarconexion#">
					 select top 1 Oficodigo 
					 from Oficinas 
					 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#GvarEcodigo#">
				</cfquery>
				
				<cfif isdefined("rsOficina") and rsOficina.recordcount GT 0>
					<cfset varOficina = #rsOficina.Oficodigo#>	
				<cfelse>
					<cfthrow message="No existen oficinas registradas para la empresa #GvarEcodigo#">
				</cfif>	
				
				<!--- Busca Moneda Local SIF ---> 
				<cfquery name="rsMonedaL" datasource="#session.dsn#">
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
				</cfif>	
				
				<!----Valida el tipo de movimiento---->
				<cfif rsDNomina.PMI_GL_TIPO EQ ' ' >
					<cfthrow message="El tipo de movimiento no es valido">				
				</cfif>		
				
						
				<cfif rsDNomina.PMI_GL_CUENTA EQ '' and PMI_GL_RUBRO NEQ '' and PMI_GL_SUBRUBRO NEQ ''>  
					<!---Arma la cuenta contable a afectar---->
					<cfinvoke returnvariable="CuentaNomina" component="sif.Componentes.CG_Complementos" method="Tra	eCuenta"
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
						<cfset Cuenta = CuentaNomina>						
				<cfelseif rsDNomina.PMI_GL_CUENTA NEQ ''>
					<cfquery name="rsFCuenta" datasource="#GvarConexion#">
						select Cformato from CContables
						where Ccuenta = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsDNomina.PMI_GL_CUENTA#">
					</cfquery>
					
					<cfif isdefined("rsFCuenta") and rsFCuenta.recordcount GT 0>
						<cfset Cuenta = rsFCuenta.Cformato>
					</cfif>
				<cfelse>
					<cfthrow message="Imposible obtener la cuenta a afectar">
				</cfif>
		
				<cftransaction action="begin">				
				<cftry>
					<cfquery datasource="sifinterfaces">
						insert into ID180
							(ID,
							DConsecutivo,
							Ecodigo,
							CConcepto,
							Concepto,
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
							Genera_Orden)
						values
							(<cfqueryparam cfsqltype="cf_sql_integer" value="#varIDmax#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#DConsecutivo#">, 
							<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDNomina.PMI_GL_RUBRO#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDNomina.PMI_GL_SUBRUBRO#">,
							<cfif isdefined("rsDNomina.PMI_GL_EMPLEADO") and rsDNomina.PMI_GL_EMPLEADO NEQ "">
								<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDNomina.PMI_GL_EMPLEADO#">,
							<cfelse>
								null,
							</cfif>							
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDNomina.PMI_GL_DESCRIPCION#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDNomina.PMI_GL_TIPO#">,
							<cfqueryparam cfsqltype="cf_sql_money" value="#rsDNomina.PMI_GL_IMPORTE#">,
							null,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Cuenta.CFformato#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDNomina.PMI_GL_CTRO_COSTOS#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#varMonedaL#">,
							null,
							<cfqueryparam cfsqltype="cf_sql_date" value="#rsENomina.PMI_GL_FECHA_EMISI#">,
							null,
							null,
							<cfif rsDNomina.PMI_GL_CUENTA EQ ''>
								<cfqueryparam cfsqltype="cf_sql_bit" value="False">
							<cfelse>
								<cfqueryparam cfsqltype="cf_sql_bit" value="True">
							</cfif>)
					</cfquery>
					<cfset DConsecutivo = DConsecutivo + 1>
				
				<cftransaction action="commit"/>
				<cfcatch type="any">
				<cftransaction action="rollback"/>
				<cfif isdefined("cfcatch.sql")> <cfset ErrSQL = cfcatch.sql> <cfelse> <cfset ErrSQL = ""> </cfif>
				<cfif isdefined("cfcatch.where")> <cfset ErrPar = cfcatch.where> <cfelse> <cfset ErrPar = ""> </cfif>
            	<cfthrow message="Error al Insertar el Detalle: #cfcatch.Message#" detail="#cfcatch.Detail# #ErrSQL# #ErrPar#">
	        	</cfcatch>
    	    	</cftry>
				</cftransaction>
						
			</cfloop>	<!-----DETALLES DE LA NOMINA--->
			<cfelse>
				<cfthrow message="La nomina #rsENomina.PMI_GL_COD_EJEC# no tiene detalles">
			</cfif>
			<cfcatch type="any">
				<!---Elimina el registro insertado---->
				<cfquery datasource="sifinterfaces">
					delete ID180 
					where ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#varIDmax#"> 					
				</cfquery>
				<cfquery datasource="sifinterfaces">
					delete IE180 
					where ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#varIDmax#"> 
				</cfquery>	
				<cfif isdefined("cfcatch.sql")> <cfset ErrSQL = cfcatch.sql> <cfelse> <cfset ErrSQL = ""> </cfif>
				<cfif isdefined("cfcatch.where")> <cfset ErrPar = cfcatch.where> <cfelse> <cfset ErrPar = ""> </cfif>
            	<cfthrow message="Error al Insertar el Detalle: #cfcatch.Message#" detail="#cfcatch.Detail# #ErrSQL# #ErrPar#">
			</cfcatch>				
			</cftry>
		</cfloop>   <!----ENCABEZADO DE NOMINA---->
		<cfset InsertaConsola = True>
		<cfelse>
			<cfthrow message="No existen Nominas nuevas para procesar">
		</cfif>

		<cfif InsertaConsola>
		<cftry>
			<!----Inserta registro en el Motor de interfaces---->
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
                         <cfqueryparam cfsqltype="cf_sql_integer" value="180">,
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
			<cfcatch type="any">
				<cfif isdefined("cfcatch.sql")> <cfset ErrSQL = cfcatch.sql> <cfelse> <cfset ErrSQL = ""> </cfif>
				<cfif isdefined("cfcatch.where")> <cfset ErrPar = cfcatch.where> <cfelse> <cfset ErrPar = ""> </cfif>
            	<cfthrow message="Error al Insertar en la consola: #cfcatch.Message#" detail="#cfcatch.Detail# #ErrSQL# #ErrPar#">
			</cfcatch>	
			</cftry>
		</cfif>
		
	         
           
	<cfif not varError>
		<cflocation url="/cfmx/interfacesTBS/Interfaz180PMI-Param.cfm">
	<cfelse>
		<form name="form1" action="Interfaz40PMI-Param.cfm" method="post">
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
	<cfargument name='Ecodigo' type='numeric' required='true' hint="Ecodigo">

	<cfquery name="rsCEcodigo" datasource="#session.dsn#">
        select CEcodigo 
        from Empresa e
            inner join Empresas s
            on  e.Ereferencia = s.Ecodigo and s.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
    </cfquery>
    <cfreturn rsCEcodigo.CEcodigo>
</cffunction>

             