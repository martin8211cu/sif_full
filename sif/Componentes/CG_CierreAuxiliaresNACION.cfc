<!--- 
	Esta es la nomenclatura para los nombres de las tablas temporales que se van a crear
	en el procedimiento de cierre de auxiliares;
		- Para CC_CierreMesCxC
			* Monedas = CierreMes_M
			* Documentos = CierreMes_D
		- Para CP_CierreMesCxP
			* Monedas = CierreMes_M2
			* Documentos = CierreMes_D2
		- Para MB_CierreMesBancos
			* SaldosBancarios = CierreMesB_SB
--->
<!---	Cierre Auxiliares	--->
<cfcomponent output="no">
	<cffunction name='CierreAuxiliares' access='public' output='no'>
		<cfargument name='Ecodigo' type='numeric' required='true'>
		<cfargument name='debug' type='string' required='false' default='false'>
		<cfargument name='conexion' type='string' required='false' default="#Session.DSN#">

		<cfsetting requesttimeout="3600">
		<cfset LvarEsPrimerMensajeCierre = true>
		
		<!--- Parámetros Generales --->
		<cfset Pcodigo_mes = 60>
		<cfset Pcodigo_per = 50>
		<cfset periodo = 0>	
		<cfset periodoant = 0>		
		<cfset mes = 0>		
		<cfset mesant = 0>
		<cfset sistema = "GN">				
		<cfset error = 0>		
		<cfset Monloc = 0>		

		<cfquery name="rs_Monloc" datasource="#arguments.conexion#">
		    select Mcodigo 
			from Empresas 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
		</cfquery>

		<cfif isdefined('rs_Monloc') and rs_Monloc.recordCount GT 0>
			<cfset Monloc = rs_Monloc.Mcodigo>
		</cfif>
		
		<cfquery name="rs_ParMes" datasource="#arguments.conexion#">
			select <cf_dbfunction name="to_number" datasource="#arguments.conexion#" args="Pvalor"> as Pvalor
			from Parametros
			where Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Pcodigo_mes#">
			  and Mcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#sistema#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
		</cfquery>
		
		<cfif isdefined('rs_ParMes') and rs_ParMes.recordCount GT 0>
			<cfset mes = rs_ParMes.Pvalor>
			<cfset mesant = rs_ParMes.Pvalor>
		</cfif>

		<cfquery name="rs_ParPer" datasource="#arguments.conexion#">
			select <cf_dbfunction name="to_number" datasource="#arguments.conexion#" args="Pvalor"> as Pvalor
			from Parametros 
			where Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Pcodigo_per#">
			  and Mcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#sistema#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
		</cfquery>
	
		<cfif isdefined('rs_ParPer') and rs_ParPer.recordCount GT 0>
			<cfset periodo = rs_ParPer.Pvalor>
			<cfset periodoant = rs_ParPer.Pvalor>
		</cfif>		

		<cfset fnReportaActividad("Validaciones Iniciales del Cierre #numberformat(periodoant, "9999")#-#numberformat(mesant, "99")# ")>

		<cfquery name="rsVerifica" datasource="#arguments.conexion#">
			select count(1) as CantidadCxC
			from Documentos
			where Ecodigo = #arguments.Ecodigo#
		</cfquery>

		<cfset LvarExistenDocumentosCxC = rsVerifica.CantidadCxC>

		<cfquery name="rsVerifica" datasource="#arguments.conexion#">
			select count(1) as CantidadCxP
			from EDocumentosCP
			where Ecodigo = #arguments.Ecodigo#
		</cfquery>
		<cfset LvarExistenDocumentosCxP = rsVerifica.CantidadCxP>

		<cfquery name="rsVerifica" datasource="#arguments.conexion#">
			select count(1) as CantidadMB
			from CuentasBancos
			where Ecodigo = #arguments.Ecodigo#
		</cfquery>
		<cfset LvarExistenBancos = rsVerifica.CantidadMB>

		<cfquery name="rsVerifica" datasource="#arguments.conexion#">
			select count(1) as CantidadActivos
			from Activos
			where Ecodigo = #arguments.Ecodigo#
		</cfquery>
		<cfset LvarExistenActivos = rsVerifica.CantidadActivos>
		
		<!--- Validaciones con el componente CG_VALIDA. Se hace para minimizar el desperdicio de procesamiento
		del servidor de Base de Datos, EJ: procesa cierre de activos fijos, CxP, pero, procesando el cierre de CxC
		da el error "no se ha definido el periodo 1" y por ese error se pierde todo lo procesado anteriormente --->
		<cfif LvarExistenActivos GT 0>
			<cfinvoke component="CG_VALIDA" method="VALIDA_AF">
				<cfinvokeargument name="Ecodigo" value="#arguments.Ecodigo#"/>
				<cfinvokeargument name="debug" value="#arguments.debug#"/>	
				<cfinvokeargument name="periodo" value="#periodo#"/>
				<cfinvokeargument name="mes" value="#mes#"/>						
				<cfinvokeargument name="conexion" value="#arguments.conexion#"/>
			</cfinvoke>
				
		</cfif>
		<cfif LvarExistenDocumentosCxP GT 0>
			<cfinvoke component="CG_VALIDA" method="VALIDA_CXP">
				<cfinvokeargument name="Ecodigo" value="#arguments.Ecodigo#"/>
				<cfinvokeargument name="debug" value="#arguments.debug#"/>							
					<cfinvokeargument name="periodo" value="#periodo#"/>
					<cfinvokeargument name="mes" value="#mes#"/>
				<cfinvokeargument name="conexion" value="#arguments.conexion#"/>
			</cfinvoke>
		</cfif>
		<cfif LvarExistenDocumentosCxC GT 0>
			<cfinvoke component="CG_VALIDA" method="VALIDA_CXC">
				<cfinvokeargument name="Ecodigo" value="#arguments.Ecodigo#"/>
				<cfinvokeargument name="debug" value="#arguments.debug#"/>							
				<cfinvokeargument name="conexion" value="#arguments.conexion#"/>
			</cfinvoke>
		</cfif>
        
        <!--- Como solo se valida la cantidad de registros en una tabla de bancos, se invoca el componente de una vez --->
        <cfinvoke component="CG_VALIDA" method="VALIDA_MB">
            <cfinvokeargument name="Ecodigo" value="#arguments.Ecodigo#"/>
            <cfinvokeargument name="debug" value="#arguments.debug#"/>							
            <cfinvokeargument name="conexion" value="#arguments.conexion#"/>
        </cfinvoke>
	
		<cfset fnReportaActividad("Creando Estructuras de Datos de Control")>

		<!--- ************************************************************************************************ --->
		<cfset SaldosBancarios   = this.Crea_SaldosBancarios()>
		<cfset TCP_Monedas       = this.CreaMonedasCxP()>
		<cfset TCP_CPDocumentos  = this.Crea_CPDocs()>
		<cfset TCP_SIdocumentos  = this.CreaSIDocsCP() >
		<cfset TCC_Monedas       = this.CreaMonedas()>
		<cfset TCC_CCDocumentos  = this.CreaDocsCxC()>
		<cfset TCC_SIdocumentos  = this.CreaSIDocsCC() >

		<cfinvoke component="CG_GeneraAsiento" returnvariable="Intarc" method="CreaIntarc" ></cfinvoke>	

		<cftransaction>
			<!--- 	Cierre Mes Activos Fijos	--->
			<cfif LvarExistenActivos GT 0>
				<cfset fnReportaActividad("Activos Fijos")>
				<cfinvoke component="AF_CierreMes" method="CierreMes">
					<cfinvokeargument name="Ecodigo" value="#arguments.Ecodigo#"/>
					<cfinvokeargument name="debug" value="#arguments.debug#"/>							
					<cfinvokeargument name="periodo" value="#periodo#"/>
					<cfinvokeargument name="mes" value="#mes#"/>
					<cfinvokeargument name="conexion" value="#arguments.conexion#"/>
				</cfinvoke>
			</cfif>
			<!---- Cierre de Inventarios ---->
			<cfset fnReportaActividad("Inventarios")>
			<cfset INnuevoMes = ((Mes mod 12) + 1)>
			<cfset INnuevoPeriodo = iif(INnuevoMes is 1,periodo + 1,periodo)>
			<cfquery datasource="#arguments.conexion#">		
				insert into CostoProduccionSTD (Aid, Ecodigo, CTDcosto, CTDperiodo, CTDmes, fechaalta, BMUsucodigo)
					select 	a.Aid,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">,		
							coalesce (CTDcosto,Acosto,0) as Acosto,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#INnuevoPeriodo#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#INnuevoMes#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">				
					from Articulos a
						left outer join CostoProduccionSTD b
							on a.Aid = b.Aid
							and a.Ecodigo = b.Ecodigo
					where a.Ecodigo = #arguments.Ecodigo#
					and   b.CTDperiodo = #periodo#
					and   b.CTDmes     = #mes#
					and (	
						select count(1)
						from CostoProduccionSTD c
						where c.Aid = a.Aid
						and c.CTDperiodo =  #INnuevoPeriodo#
						and c.CTDmes     =  #INnuevoMes#
					) = 0
			</cfquery>
			<cfquery datasource="#arguments.conexion#">  
				insert into ExistenciaInicial( 
						Aid, 
						Alm_Aid, 
						EIperiodo, 
						EIMes, 
						EIexistencia, 
						EIcosto, 
						BMUsucodigo )
				select e.Aid, 
					   e.Alm_Aid, 
					   #INnuevoPeriodo#, 
					   #INnuevoMes#, 
					   e.Eexistencia, 
					   e.Ecostototal, 
					   #session.Usucodigo#
				from Articulos a
					inner join Existencias e
					  on a.Aid=e.Aid
				where a.Ecodigo = #arguments.Ecodigo#
			</cfquery>
	
			<cfif LvarExistenBancos GT 0>
				<cfset fnReportaActividad("Bancos")>
				<!--- 	Cierre Mes Bancos 	--->
				<cfinvoke component="MB_CierreMesBancos" method="CierreMesBancos">
					<cfinvokeargument name="Ecodigo" value="#arguments.Ecodigo#"/>
					<cfinvokeargument name="debug" value="#arguments.debug#"/>							
					<cfinvokeargument name="periodo" value="#periodo#"/>
					<cfinvokeargument name="mes" value="#mes#"/>
					<cfinvokeargument name="conexion" value="#arguments.conexion#"/>
					<cfinvokeargument name="SaldosBancarios" value="#SaldosBancarios#"/>
					<cfinvokeargument name="Intarc" value="#Intarc#"/>
				</cfinvoke>		
			</cfif>
			
			<cfif LvarExistenDocumentosCxP GT 0>
				<cfset fnReportaActividad("Cuentas Por Pagar")>
				<!--- 	Cierre Mes CxP 	--->
				<cfinvoke component="CP_CierreMesCxP" method="CierreMesCxP">
					<cfinvokeargument name="Ecodigo" value="#arguments.Ecodigo#"/>
					<cfinvokeargument name="debug" value="#arguments.debug#"/>				
					<cfinvokeargument name="conexion" value="#arguments.conexion#"/>
					<cfinvokeargument name="Monedas" value="#TCP_Monedas#"/>
					<cfinvokeargument name="CPDocumentos" value="#TCP_CPDocumentos#"/>
					<cfinvokeargument name="SIdocumentos" value="#TCP_SIdocumentos#"/>
					<cfinvokeargument name="Intarc" value="#Intarc#"/>
				</cfinvoke>		
			</cfif>
			
			<cfif LvarExistenDocumentosCxC GT 0>
				<cfset fnReportaActividad("Cuentas por Cobrar")>
				<!--- Inicio de la ejecucion de los componentes de los Procedimientos Almacenados --->
				<!--- 	Cierre Mes CxC 	--->
				<cfinvoke component="CC_CierreMesCxC" method="CierreMes">
					<cfinvokeargument name="Ecodigo" value="#arguments.Ecodigo#"/>
					<cfinvokeargument name="debug" value="#arguments.debug#"/>				
					<cfinvokeargument name="conexion" value="#arguments.conexion#"/>
					<cfinvokeargument name="Monedas" value="#TCC_Monedas#"/>
					<cfinvokeargument name="CCDocumentos" value="#TCC_CCDocumentos#"/>
					<cfinvokeargument name="SIdocumentos" value="#TCC_SIdocumentos#"/>
					<cfinvokeargument name="Intarc" value="#Intarc#"/>
				</cfinvoke>		
			</cfif>
			<cfset fnReportaActividad("Actualizando Par&aacute;metros")>
			<!--- actualizar el mes --->
			<cfset mes = ((mes mod 12) + 1)>
			<cfquery name="rs_ParPvalor" datasource="#arguments.conexion#">
				update Parametros
				set   Pvalor  = <cf_dbfunction name="to_char" datasource="#arguments.conexion#" args="#mes#">
				where Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Pcodigo_mes#">
					and Mcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#sistema#">
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
			</cfquery>
	
			<!--- actualizar el periodo, si hay un cambio de año --->
			<cfif mes EQ 1>
				<cfset Periodo = periodo + 1>
				<cfquery name="rs_MesPer" datasource="#arguments.conexion#">
					update Parametros
						set   Pvalor  = <cf_dbfunction name="to_char" datasource="#arguments.conexion#" args="#(periodo)#">
					where Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Pcodigo_per#"> 
						and Mcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#sistema#">
						and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">			
				</cfquery>
			</cfif>
	
			<!--- Inserta en la bitácora --->
			<cfset fnReportaActividad("Actualizando bit&aacute;coras")>
			<cfquery name="rsBitacora" datasource="#Arguments.Conexion#">
				insert into BitacoraCierres (Ecodigo,BCperiodo,BCmes,BCtipocierre,Mcodigo,BCfcierre,Usucodigo,BMUsucodigo)
				values (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#periodoant#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#mesant#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="2">, <!--- Cierre Auxiliar --->
					<cfqueryparam cfsqltype="cf_sql_char" value="#sistema#">,
					<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,				
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">)
			</cfquery>
			<!--- Inserta en CGPeriodosProcesados --->
			
			<!---  a) Insertar el periodo Actual si no existe --->
			<cfquery name="rsPerProcexists" datasource="#Arguments.Conexion#">
				select count(1) as Cantidad 
				from CGPeriodosProcesados 
				where Ecodigo = #Arguments.Ecodigo# 
				  and Speriodo = #periodoant#
				  and Smes = #mesant#
			</cfquery>
			<cfif rsPerProcexists.Cantidad eq 0>
				<cfquery name="rsinsPerProc" datasource="#Arguments.Conexion#">
					insert into CGPeriodosProcesados (Ecodigo, Speriodo, Smes, BMUsucodigo, BMFecha)
					values (
						#Arguments.Ecodigo#, 
						#periodoant#, 
						#mesant#, 
						#session.Usucodigo#, 
						<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">)
				</cfquery>
			</cfif>
	
			<!---  b) Insertar el nuevo periodo si no existe --->
			<cfquery name="rsPerProcexists" datasource="#Arguments.Conexion#">
				select count(1) as Cantidad 
				from CGPeriodosProcesados 
				where Ecodigo = #Arguments.Ecodigo# 
				  and Speriodo = #periodo#
				  and Smes = #mes#
			</cfquery>
			
			<cfif rsPerProcexists.Cantidad eq 0>
				<cfquery name="rsinsPerProc" datasource="#Arguments.Conexion#">
					insert into CGPeriodosProcesados (Ecodigo, Speriodo, Smes, BMUsucodigo, BMFecha)
					values (
						#Arguments.Ecodigo#, 
						#periodo#, 
						#Mes#, 
						#session.Usucodigo#, 
						<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">)
				</cfquery>
			</cfif>
	
			<cfif arguments.debug>
				<cfquery datasource="#arguments.conexion#" name="rs_ParamPer">
					select Ecodigo, Pcodigo, Mcodigo, Pdescripcion, Pvalor
					from Parametros 
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
						and Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Pcodigo_per#">
				</cfquery>
				
				<cfif isdefined('rs_ParamPer')>
					<cfdump var="#rs_ParamPer#" label="Tabla de Parametros con Pcodigo #Pcodigo_per# en CierreAuxiliares">
				</cfif>
				
				<cfquery datasource="#arguments.conexion#" name="rs_ParamMes">
					select Ecodigo, Pcodigo, Mcodigo, Pdescripcion, Pvalor
					from Parametros 
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
						and Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Pcodigo_mes#">
				</cfquery>
							
				<cfif isdefined('rs_ParamMes')>
					<cfdump var="#rs_ParamMes#" label="Tabla de Parametros con Pcodigo #Pcodigo_mes# en CierreAuxiliares">
				</cfif>
			</cfif>
		</cftransaction>

		<cfset fnReportaActividad("Borrando Documentos Sin Saldo en CxP")>
		<!--- Se borran los documentos en cero de CxP y CxC fuera de la transacción.  No se requieren luego del cierre de mes --->
		<cfif LvarExistenDocumentosCxP GT 0>
			<cfinvoke component="CP_CierreMesCxP" method="CMA_CierreMesCxP_BorrarCeros">
				<cfinvokeargument name="Ecodigo" value="#arguments.Ecodigo#"/>
				<cfinvokeargument name="conexion" value="#arguments.conexion#"/>
			</cfinvoke>		
		</cfif>

		<cfset fnReportaActividad("Borrando Documentos Sin Saldo en CxC")>
		<cfif LvarExistenDocumentosCxC GT 0>
			<cfinvoke component="CC_CierreMesCxC" method="CMA_CierreMesCxC_BorrarCeros">
				<cfinvokeargument name="Ecodigo" value="#arguments.Ecodigo#"/>
				<cfinvokeargument name="conexion" value="#arguments.conexion#"/>
			</cfinvoke>		
		</cfif>
		
		<!--- 
			Borrar los registros que existan en las tablas temporales
			porque no se pueden eliminar las tablas.
			De esta forma quedan las estructuras pero sin datos
			
			Se incluyeron dentro de un try porq algunas veces las tablas ya no existen si se cambia de coneccion. Sugerido por Mauricio E.
		--->
		<cfset fnReportaActividad("Borrando Tablas de Trabajo del Proceso de Cierre")>
		<cftry>
			<cfquery datasource="#arguments.conexion#">
				delete from #SaldosBancarios#
			</cfquery>
			<cfquery datasource="#arguments.conexion#">
				delete from #TCP_Monedas#
			</cfquery>
			<cfquery datasource="#arguments.conexion#">
				delete from #TCP_CPDocumentos#
			</cfquery>
			<cfquery datasource="#arguments.conexion#">
				delete from #TCP_SIdocumentos#
			</cfquery>
			<cfquery datasource="#arguments.conexion#">
				delete from #TCC_Monedas#
			</cfquery>
			<cfquery datasource="#arguments.conexion#">
				delete from #TCC_CCDocumentos#
			</cfquery>
			<cfquery datasource="#arguments.conexion#">
				delete from #TCC_SIdocumentos#
			</cfquery>
		   <cfcatch type="any"></cfcatch>
		</cftry>
		<cfset fnReportaActividad("Proceso Terminado")>
	</cffunction>

	<cffunction name="fnReportaActividad" access="private" output="yes" hint="Reporta la actividad del cierre de mes para que el usuario pueda saber si el proceso está avanzando">
		<cfargument name="LvarProceso" type="string" default="*** Cierre ***">
		<cfif LvarEsPrimerMensajeCierre>
			<cfoutput>
			<br />
			<strong>Cierre de Auxiliares</strong>
			<br />
			</cfoutput>
			<cfset LvarEsPrimerMensajeCierre = false>
		<cfelse>
			<cfoutput>Terminado<br /></cfoutput>
		</cfif>
		<cfoutput>#Arguments.LvarProceso#:&nbsp;#DateFormat(now(), "DD/MM/YYYYY")#:#TimeFormat(now(), "HH:MM:SS")#.....</cfoutput>
		<!---<cfflush>--->
	</cffunction>
	
	<cffunction name="Crea_SaldosBancarios" access="public" output="no" returntype="string">
		<cf_dbtemp name="CMA_Bancos_SB" returnvariable="CMA_Bancos_SB">
			<cf_dbtempcol name="CBid"  			type="numeric"     	mandatory="yes">
			<cf_dbtempcol name="Mes"  		    type="int"		    mandatory="yes">										
			<cf_dbtempcol name="Periodo"  		type="int"		    mandatory="yes">									
			<cf_dbtempcol name="Ecodigo"  		type="numeric">			
			<cf_dbtempcol name="Ocodigo"  		type="numeric">
			<cf_dbtempcol name="Mcodigo"  		type="numeric">
			<cf_dbtempcol name="TipoCambio"  	type="float">
			<cf_dbtempcol name="Sinicial"		type="money">
			<cf_dbtempcol name="Slocal"  		type="money">
			<cf_dbtempcol name="SaldoAJ"  		type="money">			
			<cf_dbtempcol name="Ajuste"  		type="money">
			<cf_dbtempcol name="MesN"  		    type="int"		mandatory="yes">										
			<cf_dbtempcol name="PeriodoN"  		type="int"		mandatory="yes">		
										
			<cf_dbtempkey cols="CBid,Mes,Periodo">
		</cf_dbtemp>
		
		<cfreturn CMA_Bancos_SB>
	</cffunction>		

	<cffunction name="CreaMonedasCxP" access="public" returntype="string" output="no">
		<cf_dbtemp name="CMA_CxPMonedas" returnvariable="CMA_CxPMonedas">
			<cf_dbtempcol name="Mcodigo"  	type="numeric"     	mandatory="yes">
			<cf_dbtempcol name="Ecodigo"  	type="int"    		mandatory="yes">			
			<cf_dbtempcol name="Periodo"  	type="int"    		mandatory="yes">						
			<cf_dbtempcol name="Mes"  	    type="int"    		mandatory="yes">						
			<cf_dbtempcol name="Ocodigo"  	type="int"    		mandatory="yes">
			<cf_dbtempcol name="TC"		    type="float"    	mandatory="yes">
			<cf_dbtempcol name="Mnombre"  	type="char(80)">
			<cf_dbtempcol name="Total"  	type="money"	 	mandatory="yes">
			<cf_dbtempcol name="Ccuenta"  	type="numeric">

			<cf_dbtempkey cols="Mcodigo,Ocodigo">
		</cf_dbtemp>
		
		<cfreturn CMA_CxPMonedas>
	</cffunction>	

	<cffunction name="Crea_CPDocs" access="public" output="no" returntype="string">
		<cf_dbtemp name="CMA_CxPDocs" returnvariable="CMA_CxPDocs">
			<cf_dbtempcol name="IDdocumento"  	type="numeric"     	mandatory="yes">
			<cf_dbtempcol name="Ecodigo"  		type="int">			
			<cf_dbtempcol name="Periodo"  		type="int">						
			<cf_dbtempcol name="Mes"  			type="int">							
			<cf_dbtempcol name="CPTcodigo"  	type="char(2)">
			<cf_dbtempcol name="Ddocumento"		type="char(20)">
			<cf_dbtempcol name="Ocodigo"  		type="int">
			<cf_dbtempcol name="SNcodigo"  		type="int">
			<cf_dbtempcol name="Mcodigo"  		type="numeric">
			<cf_dbtempcol name="Ccuenta"  		type="numeric">			
			<cf_dbtempcol name="EDsaldo"  		type="money">			
			<cf_dbtempcol name="Saldo"  		type="money">						
			<cf_dbtempcol name="EDtcultrev"  	type="float">									
 
			<cf_dbtempkey cols="IDdocumento">
		</cf_dbtemp>
		
		<cfreturn CMA_CxPDocs>		
	</cffunction>
	
	<cffunction name="CreaSIDocsCP" access="public" output="no" returntype="string">
		<cf_dbtemp name="CMA_CxPDocsSI" returnvariable="CMA_CxPDocsSI">
			<cf_dbtempcol name="Ecodigo"  			type="int"  	mandatory="yes">			
			<cf_dbtempcol name="SNcodigo"  			type="int"     	mandatory="yes">
			<cf_dbtempcol name="SNid"  				type="numeric"  mandatory="yes">
			<cf_dbtempcol name="Mcodigo"  			type="numeric"  mandatory="yes">
			<cf_dbtempcol name="CPTcodigo"  		type="char(2)"  mandatory="yes">
			<cf_dbtempcol name="Ddocumento"  		type="char(20)"	mandatory="yes">
			<cf_dbtempcol name="id_direccion"  		type="numeric"	mandatory="yes">
			<cf_dbtempcol name="fecha"  			type="datetime"	mandatory="yes">
			<cf_dbtempcol name="saldo"  			type="money"	mandatory="yes">
			<cf_dbtempcol name="fechavencimiento"	type="datetime"	mandatory="yes">
		</cf_dbtemp>
		<cfreturn CMA_CxPDocsSI>		
	</cffunction>

	<cffunction name="CreaMonedas" access="public" returntype="string" output="no">
		<cf_dbtemp name="CMA_CxCMonedas" returnvariable="CMA_CxCMonedas">
			<cf_dbtempcol name="Mcodigo"  	type="numeric"     	mandatory="yes">
			<cf_dbtempcol name="Ecodigo"  	type="int"    		mandatory="yes">			
			<cf_dbtempcol name="Periodo"  	type="int"    		mandatory="yes">						
			<cf_dbtempcol name="Mes"  		type="int"    		mandatory="yes">						
			<cf_dbtempcol name="Ocodigo"  	type="int"    		mandatory="yes">
			<cf_dbtempcol name="TC"			type="float"    	mandatory="yes">
			<cf_dbtempcol name="Mnombre"  	type="char(80)">
			<cf_dbtempcol name="Total"  	type="money"	 	mandatory="yes">
			<cf_dbtempcol name="Ccuenta"  	type="numeric">
			<cf_dbtempkey cols="Mcodigo,Ocodigo,Ecodigo,Periodo,Mes">
		</cf_dbtemp>
		
		<cfreturn CMA_CxCMonedas>
	</cffunction>	

	<cffunction name="CreaDocsCxC" access="public" output="no" returntype="string">
		<cf_dbtemp name="CMA_CxCDocs" returnvariable="CMA_CxCDocs">
			<cf_dbtempcol name="CCTcodigo"  	type="char(2)"     	mandatory="yes">
			<cf_dbtempcol name="Ddocumento"  	type="char(20)"		mandatory="yes">
			<cf_dbtempcol name="Ecodigo"  		type="int"    		mandatory="yes">			
			<cf_dbtempcol name="Periodo"  		type="int"    		mandatory="yes">						
			<cf_dbtempcol name="Mes"  			type="int"    		mandatory="yes">							
			<cf_dbtempcol name="Ocodigo"		type="int">
			<cf_dbtempcol name="SNcodigo"  		type="int">
			<cf_dbtempcol name="Mcodigo"  		type="numeric">
			<cf_dbtempcol name="Ccuenta"  		type="numeric">
			<cf_dbtempcol name="Dsaldo"  		type="money">			
			<cf_dbtempcol name="Saldo"  		type="money">			
			<cf_dbtempcol name="Dtcultrev"  	type="float">						
 
			<cf_dbtempkey cols="CCTcodigo,Ddocumento">
		</cf_dbtemp>
		<cfreturn CMA_CxCDocs>		
	</cffunction>

	<cffunction name="CreaSIDocsCC" access="public" output="no" returntype="string">
		<cf_dbtemp name="CMA_CxCDocsSI_v1" returnvariable="CMA_CxCDocsSI">
			<cf_dbtempcol name="Ecodigo"  			type="int"  	mandatory="yes">			
			<cf_dbtempcol name="SNcodigo"  			type="int"     	mandatory="yes">
			<cf_dbtempcol name="SNid"  				type="numeric"  mandatory="yes">
			<cf_dbtempcol name="Mcodigo"  			type="numeric"  mandatory="yes">
			<cf_dbtempcol name="CCTcodigo"  		type="char(2)"  mandatory="yes">
			<cf_dbtempcol name="Ddocumento"  		type="char(20)"	mandatory="yes">
			<cf_dbtempcol name="id_direccion"  		type="numeric"	mandatory="yes">
			<cf_dbtempcol name="fecha"  			type="datetime"	mandatory="yes">
			<cf_dbtempcol name="saldo"  			type="money"	mandatory="yes">
			<cf_dbtempcol name="fechavencimiento"	type="datetime"	mandatory="yes">
			<cf_dbtempcol name="tipo"				type="char(1)"	mandatory="yes">
			<cf_dbtempcol name="HDid"				type="numeric"	mandatory="yes">
		</cf_dbtemp>
		<cfreturn CMA_CxCDocsSI>		
	</cffunction>
</cfcomponent>