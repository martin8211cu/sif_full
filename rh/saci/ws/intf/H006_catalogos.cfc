<cfcomponent extends="base">
	<cffunction name="sincroniza_catalogos" access="public" returntype="void" output="false">
		<cfargument name="origen" type="string" required="yes" default="siic">
		<cfargument name="tabla" type="string" required="yes">
		<cfargument name="operacion" type="string" required="yes">
		<cfargument name="S02VA2" type="string" required="yes">
		<cfargument name="S02CON" type="numeric" required="yes">
		
		<cfset control_inicio( Arguments, 'H006','TABLA=' & Arguments.tabla & ' - ' & Arguments.S02VA2)>
		<cftry>
			<cfset control_servicio( 'siic' )>
				<cfif Not ListFind('A,C,B',Arguments.operacion)>
					<cfthrow message="La operación debe ser una ('A','B','C')">	
				</cfif>		
			<cfset llave = ListToArray(S02VA2,'*')>
			<cfswitch expression="#Arguments.tabla#">
				<cfcase value="SSXACT">
					<cfif ArrayLen(llave) neq 1>
						<cfthrow message="Llave invalida para SSXACT">
					</cfif>	
					<cfinvoke component="#This#" method="SSXACT"
						ACTCOD ="#getValueAt(llave,1)#" 
						operacion="#Arguments.operacion#"/>
				</cfcase>
				<cfcase value="SSXPRO">
					<cfif ArrayLen(llave) neq 1>
						<cfthrow message="Llave invalida para SSXPRO">
					</cfif>		
					<cfinvoke component="#This#" method="SSXPRO"
						PRVCOD ="#getValueAt(llave,1)#"
						operacion="#Arguments.operacion#"/>
				</cfcase>
				<cfcase value="SSXCAN">
					<cfif ArrayLen(llave) neq 2>
						<cfthrow message="Llave invalida para SSXCAN">
					</cfif>		
					<cfinvoke component="#This#" method="SSXCAN"
						PRVCOD ="#getValueAt(llave,1)#"
						CANCOD ="#getValueAt(llave,2)#" 
						operacion="#Arguments.operacion#"/>
				</cfcase>
				<cfcase value="SSXDIS">
					<cfif ArrayLen(llave) neq 3>
						<cfthrow message="Llave invalida para SSXDIS">
					</cfif>		
					<cfinvoke component="#This#" method="SSXDIS"
					PRVCOD ="#getValueAt(llave,1)#"
					CANCOD ="#getValueAt(llave,2)#"
					DISCOD ="#getValueAt(llave,3)#"
					operacion="#Arguments.operacion#"/>
				</cfcase>
				<cfcase value="SSXGRU">
					<cfif ArrayLen(llave) neq 1>
						<cfthrow message="Llave invalida para SSXGRU">
					</cfif>		
					<cfinvoke component="#This#" method="SSXGRU"
					GRUCOD ="#getValueAt(llave,1)#"
					operacion="#Arguments.operacion#"/>
				</cfcase>
				<cfcase value="SSXCLA">
					<cfif ArrayLen(llave) neq 1>
						<cfthrow message="Llave invalida para SSXCLA">
					</cfif>		
					<cfinvoke component="#This#" method="SSXCLA"
					CLACOD ="#getValueAt(llave,1)#"
					operacion="#Arguments.operacion#"/>
				</cfcase>
				<cfcase value="SSXMRE">
					<cfif ArrayLen(llave) neq 1>
						<cfthrow message="Llave invalida para SSXMRE">
					</cfif>		
					<cfinvoke component="#This#" method="SSXMRE"
					MRECOD ="#getValueAt(llave,1)#"
					operacion="#Arguments.operacion#"/>
				</cfcase>
				<cfcase value="SSXIFC">
					<cfif ArrayLen(llave) neq 1>
						<cfthrow message="Llave invalida para SSXIFC">
					</cfif>		
					<cfinvoke component="#This#" method="SSXIFC"
					IFCCOD ="#getValueAt(llave,1)#"
					operacion="#Arguments.operacion#"/>									
				</cfcase>
				<cfcase value="SSXINS">
					<cfif ArrayLen(llave) neq 1>
						<cfthrow message="Llave invalida para SSXINS">
					</cfif>		
					<cfinvoke component="#This#" method="SSXINS"
					INSCOD ="#getValueAt(llave,1)#"
					operacion="#Arguments.operacion#"/>
				</cfcase>
				<cfcase value="SSXECG">
					<cfif ArrayLen(llave) neq 1>
						<cfthrow message="Llave inválida para SSXECG">
					</cfif>		
					<cfinvoke component="#This#" method="SSXECG"
					ECGCOD ="#getValueAt(llave,1)#"
					operacion="#Arguments.operacion#"/>
				</cfcase>
				<cfcase value="SSXPRE">
					<cfif ArrayLen(llave) neq 1>
						<cfthrow message="Llave inválida para SSXPRE">
					</cfif>		
					<cfinvoke component="#This#" method="SSXPRE"
					PRETAR ="#getValueAt(llave,1)#"
					operacion="#Arguments.operacion#"/>
				</cfcase>
				<cfcase value="SSXCEC">
					<cfif ArrayLen(llave) neq 2>
						<cfthrow message="Llave inválida para SSXCEC">
					</cfif>		
					<cfinvoke component="#This#" method="SSXCEC"
					ESCCOD ="#getValueAt(llave,1)#"
					CONCGO ="#getValueAt(llave,2)#"
					operacion="#Arguments.operacion#"/>
				</cfcase>
				<cfcase value="SSMTRA">
					<cfif ArrayLen(llave) neq 3>
						<cfthrow message="Llave inválida para SSMTRA">
					</cfif>		
					<cfinvoke component="#This#" method="SSMTRA"
					trafer ="#getValueAt(llave,1)#"
					sevcod ="#getValueAt(llave,2)#"
					tranuc ="#getValueAt(llave,3)#"
					operacion="#Arguments.operacion#"/>
				</cfcase>
			
				<cfdefaultcase>
					<cfthrow message="La tabla #Arguments.tabla# no se puede replicar">
				</cfdefaultcase>
			</cfswitch>
		
			<cfinvoke component="SSXS02" method="Cumplimiento"
			 S02CON="#Arguments.S02CON#"
			 EnviarCumplimiento="false"
			 EnviarHistorico="true"/>
	
		<cfset control_final( )>
		<cfcatch type="any">
			<!--- error --->
			<cfset control_catch( cfcatch )>
			<cfinvoke component="SSXS02" method="Error"
			S02CON="#Arguments.S02CON#"
			Error="#Request._saci_intf.Error#"/>
			</cfcatch>
		</cftry>
	</cffunction>
	
	
	<cffunction name="SSXACT" access="public" returntype="void" output="true">
		<cfargument name="ACTCOD" type="string" required="yes">
		<cfargument name="operacion" type="string" required="yes">
		
					<cfquery datasource="SACISIIC" name="querydatos">
						Select ACTCOD, ACTDES FROM SSXACT
						Where ACTCOD = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ACTCOD#">
					</cfquery>	
								

										
				<cfif Arguments.operacion eq 'A'>
					<cfquery datasource="#session.dsn#" name="querydatos">
						insert ISBactividadEconomica 
						(AEactividad
						, AEnombre
						, Ecodigo
						, BMUsucodigo)
						values (
						<cfqueryparam cfsqltype="cf_sql_integer" value="#querydatos.ACTCOD#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#querydatos.ACTDES#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)								
					</cfquery>
					
				<cfelseif Arguments.operacion eq 'C'>
				
					<cfquery datasource="#session.dsn#" name="querydatos">
						update ISBactividadEconomica set 
						 AEactividad = <cfqueryparam cfsqltype="cf_sql_integer" value="#querydatos.ACTCOD#">
						, AEnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#querydatos.ACTDES#">
						, Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
						where AEactividad = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.ACTCOD#">
						select @@rowcount as update_rowcount
					</cfquery>
									
					<cfif querydatos.update_rowcount is 0>
						<cfthrow message="No se realizó la actualización ACTCOD=#Arguments.ACTCOD#">
					</cfif>
				 	
				
				<cfelse>						
					<cfquery datasource="#session.dsn#" name="querydatos">
						delete ISBactividadEconomica 
						where AEactividad = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.ACTCOD#">
						select @@rowcount as delete_rowcount					
					</cfquery>
					<cfif querydatos.delete_rowcount is 0>
						<cfthrow message="No se realizó el borrado ACTCOD=#Arguments.ACTCOD#">
					</cfif>
	
				</cfif>
		
	</cffunction>	
	<cffunction name="SSMTRA" access="public" returntype="void" output="true">
		<cfargument name="trafer" type="string" required="yes">
		<cfargument name="sevcod" type="string" required="yes">
		<cfargument name="tranuc" type="string" required="yes">
		<cfargument name="operacion" type="string" required="yes">
		
					<cfquery datasource="SACISIIC" name="querydatos">
						Select TRAFER,SEVCOD,TRANUC,TRADET,TRAHAB FROM SSMTRA
						Where TRAFER = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.trafer#">
						and SEVCOD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.sevcod#">
						and TRANUC = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.tranuc#">
					</cfquery>	
								

										
				<cfif Arguments.operacion eq 'A'>
					<cfquery datasource="#session.dsn#" name="querydatos">
						insert ISBtransaccionDepositos 
						(Trafer
						, Sevcod
						, Tranuc
						, Tradet
						, Trahab
						, Ecodigo)
						values (
						<cfqueryparam cfsqltype="cf_sql_char" value="#querydatos.TRAFER#">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#querydatos.SEVCOD#">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#querydatos.TRANUC#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#querydatos.TRADET#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#querydatos.TRAHAB#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
					</cfquery>
					
				<cfelseif Arguments.operacion eq 'C'>
				
					<cfquery datasource="#session.dsn#" name="querydatos">
						update ISBtransaccionDepositos  set 
						 Tradet = <cfqueryparam cfsqltype="cf_sql_varchar" value="#querydatos.TRADET#">
						 , Trahab = <cfqueryparam cfsqltype="cf_sql_varchar" value="#querydatos.TRAHAB#">
						where Trafer = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.trafer#">
						and Sevcod = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.sevcod#">
						and Tranuc = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.tranuc#">
						select @@rowcount as update_rowcount
					</cfquery>
									
					<cfif querydatos.update_rowcount is 0>
						<cfthrow message="No se realizó la actualización TRANUC=#Arguments.tranuc#">
					</cfif>
				 	
				
				<cfelse>						
					<cfquery datasource="#session.dsn#" name="querydatos">
						delete ISBtransaccionDepositos 
						where Trafer = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.trafer#">
						and Sevcod = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.sevcod#">
						and Tranuc = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.tranuc#">
						select @@rowcount as delete_rowcount					
					</cfquery>
					<cfif querydatos.delete_rowcount is 0>
						<cfthrow message="No se realizó el borrado TRANUC=#Arguments.tranuc#">
					</cfif>
	
				</cfif>
		
	</cffunction>	
	<cffunction name="SSXCEC" access="public" returntype="void" output="true">
		<cfargument name="ESCCOD" type="string" required="yes">
		<cfargument name="CONCGO" type="string" required="yes">
		<cfargument name="operacion" type="string" required="yes">
		
					<cfquery datasource="SACISIIC" name="querydatos">
						Select ESCCOD, CONCGO, CECNOM FROM SSXCEC
						Where ESCCOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.ESCCOD#">
						 And CONCGO = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.CONCGO#">
					</cfquery>	
										
				<cfif Arguments.operacion eq 'A'>
				
					<cfquery datasource="#session.dsn#" name="querydatos_duplicados">
						 Select * from ISBcuentaEstado
						 Where ECestado = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.ESCCOD#">
						 And ECsubEstado = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.CONCGO#">
					</cfquery>
						
					<cfif querydatos_duplicados.RecordCount gt 0>
						<cfthrow message="Los estados #Arguments.ESCCOD# y #Arguments.CONCGO# ya existe">
					</cfif>			
				
					<cfquery datasource="#session.dsn#" name="querydatos">
						insert ISBcuentaEstado
						(ECestado
						, ECsubEstado
						, ECnombre
						, BMUsucodigo)
						values (
						<cfqueryparam cfsqltype="cf_sql_integer" value="#querydatos.ESCCOD#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#querydatos.CONCGO#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#querydatos.CECNOM#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)

					</cfquery>
					
				<cfelseif Arguments.operacion eq 'C'>
				
					<cfquery datasource="#session.dsn#" name="querydatos">
						update ISBcuentaEstado set 
						 ECnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#querydatos.CECNOM#">
						where ECestado = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.ESCCOD#">
						and ECsubEstado = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.CONCGO#">
						select @@rowcount as update_rowcount
					</cfquery>
				
				 	 <cfif querydatos.update_rowcount is 0>
						<cfthrow message="No se realizó la actualización ESCCOD=#Arguments.ESCCOD# CONCGO=#Arguments.CONCGO#">
					</cfif>
			
				
				<cfelse>						
					<cfquery datasource="#session.dsn#" name="querydatos">
						delete ISBcuentaEstado
						where ECestado  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.ESCCOD#">
						and ECsubEstado = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.CONCGO#">
						select @@rowcount as delete_rowcount
					</cfquery>
				
				 	 <cfif querydatos.delete_rowcount is 0>
						<cfthrow message="No se realizó el borrado ESCCOD=#Arguments.ESCCOD# CONCGO=#Arguments.CONCGO#">
					</cfif>
			
				</cfif>
		
	</cffunction>	
	<cffunction name="SSXPRE" access="public" returntype="void" output="true">
		<cfargument name="PRETAR" type="string" required="yes">
		
		
					<cfquery datasource="SACISIIC" name="querydatos">
						Select  PRETAR,PREMON,PREDUR,PREFAC,PRESER,
 								PREDEC,PREMAX,PREMOD,PREEST 
								FROM SSXPRE						    
						Where PRETAR = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.PRETAR#">
					</cfquery>	
					
										
				<cfif Arguments.operacion eq 'A'>
					<cfquery datasource="#session.dsn#" name="querydatos">
						insert ISBprefijoPrepago 
						(Ecodigo
						, prefijo
						, BMUsucodigo
						, recargable
						, precio
						, Miso4217
						, preciohora
						, preciotarjeta
						, vigencia
						, cobrale
						, descuento
						, maxconse
						, estado)

						values (
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#querydatos.PRETAR#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,								
						<cfqueryparam cfsqltype="cf_sql_bit" value="0">,
						<cfqueryparam cfsqltype="cf_sql_money" value="0">,
						<cfif querydatos.PREMOD is 'C'>
							<cfset moneda = 'CRC'>
						<cfelseif querydatos.PREMOD is 'D'>
							<cfset moneda = 'USD'>
						<cfelse> 
							<cfthrow message="La moneda no es válida.">
						</cfif>			
						<cfqueryparam cfsqltype="cf_sql_char" value="#moneda#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#querydatos.PREFAC#">,
						<cfqueryparam cfsqltype="cf_sql_money" value="#querydatos.PREMON#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#querydatos.PREDUR#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#querydatos.PRESER#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#querydatos.PREDEC#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#querydatos.PREMAX#">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#querydatos.PREEST#">)							
					</cfquery>
					
				<cfelseif Arguments.operacion eq 'C'>
				
					<cfquery datasource="#session.dsn#" name="querydatos">
						update ISBprefijoPrepago set 
						 recargable = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
						, precio = 	<cfqueryparam cfsqltype="cf_sql_money" value="0">						
						<cfif querydatos.PREMOD is 'C'>
							<cfset moneda = 'CRC'>
						<cfelseif querydatos.PREMOD is 'D'>
							<cfset moneda = 'USD'>
						<cfelse> 
							<cfthrow message="La moneda no es válida.">	
						</cfif>	
						, Miso4217 = <cfqueryparam cfsqltype="cf_sql_char" value="#moneda#">
						, preciohora = <cfqueryparam cfsqltype="cf_sql_integer" value="#querydatos.PREFAC#">
						, preciotarjeta = <cfqueryparam cfsqltype="cf_sql_money" value="#querydatos.PREMON#">
						, vigencia = <cfqueryparam cfsqltype="cf_sql_integer" value="#querydatos.PREDUR#">
						, cobrale = <cfqueryparam cfsqltype="cf_sql_integer" value="#querydatos.PRESER#">
						, descuento = <cfqueryparam cfsqltype="cf_sql_integer" value="#querydatos.PREDEC#">
						, maxconse = <cfqueryparam cfsqltype="cf_sql_integer" value="#querydatos.PREMAX#">
						, estado = <cfqueryparam cfsqltype="cf_sql_char" value="#querydatos.PREEST#">
						where prefijo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#querydatos.PRETAR#">
						select @@rowcount as update_rowcount
					</cfquery>
				 	 
					 <cfif querydatos.update_rowcount is 0>
						<cfthrow message="No se realizó la actualización PRETAR=#querydatos.PRETAR#">
					</cfif>
			
				<cfelse>						
					<cfquery datasource="#session.dsn#" name="querydatos">
						delete ISBprefijoPrepago  
						where prefijo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#querydatos.PRETAR#">
						select @@rowcount as delete_rowcount
					</cfquery>
				
					<cfif querydatos.delete_rowcount is 0>
						<cfthrow message="No se realizó el borrado PRETAR=#querydatos.PRETAR#">
					</cfif>
				</cfif>
		
	</cffunction>	
	<cffunction name="SSXGRU" access="public" returntype="void" output="true">
		<cfargument name="GRUCOD" type="string" required="yes">
		<cfargument name="operacion" type="string" required="yes">
		
					<cfquery datasource="SACISIIC" name="querydatos_g">
						Select GRUCOD, GRUDES, GRUFEC from SSXGRU
						Where GRUCOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.GRUCOD#">
					</cfquery>	
										
				<cfif Arguments.operacion eq 'A'>
					<cfquery datasource="#session.dsn#" name="querydatos">
						insert ISBgrupoCobro
						(GCcodigo
						, GCnombre
						, Ecodigo
						, Gdiacorte
						, BMUsucodigo)
						values (
						<cfqueryparam cfsqltype="cf_sql_integer" value="#querydatos_g.GRUCOD#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#querydatos_g.GRUDES#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#querydatos_g.GRUFEC#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)								
					</cfquery>
					
				<cfelseif Arguments.operacion eq 'C'>
				
					<cfquery datasource="#session.dsn#" name="querydatos">
						update ISBgrupoCobro set 
						 GCnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#querydatos_g.GRUDES#">
						, Gdiacorte = <cfqueryparam cfsqltype="cf_sql_varchar" value="#querydatos_g.GRUFEC#">
						, Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
						where GCcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.GRUCOD#">
						select @@rowcount as update_rowcount
					</cfquery>
					
					<cfif querydatos.update_rowcount is 0>
						<cfthrow message="No se realizó la actualización GRUCOD=#Arguments.GRUCOD#">
					</cfif>
				
				<cfelse>						
					<cfquery datasource="#session.dsn#" name="querydatos">
						delete ISBgrupoCobro 
						where GCcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.GRUCOD#">
						select @@rowcount as delete_rowcount
					</cfquery>
				
					<cfif querydatos.delete_rowcount is 0>
						<cfthrow message="No se  realizó el borrado GRUCOD=#Arguments.GRUCOD#">
					</cfif>
				</cfif>
		
	</cffunction>	
	
	<cffunction name="SSXMRE" access="public" returntype="void" output="true">
		<cfargument name="MRECOD" type="string" required="yes">
		<cfargument name="operacion" type="string" required="yes">
		
					<cfquery datasource="SACISIIC" name="querydatos_g">
						Select MRECOD, MREDES from SSXMRE
						Where MRECOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MRECOD#">
					</cfquery>	
										
				<cfif Arguments.operacion eq 'A'>
					
					<cfquery datasource="#session.dsn#" name="querydatos_duplicados">
						 Select * from ISBmotivoRetiro
						 Where MRcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.MRECOD#">
					</cfquery>
						
					<cfif querydatos_duplicados.RecordCount gt 0>
						<cfthrow message="El motivo de retiro MRcodigo=#Arguments.MRECOD# ya existe">
					</cfif>					
					
					<cfquery datasource="#session.dsn#" name="querydatos">
						insert ISBmotivoRetiro
						(MRcodigo
						, MRnombre
						, Ecodigo
						, BMUsucodigo)
						values (
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#querydatos_g.MRECOD#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#querydatos_g.MREDES#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)								
					</cfquery>
					
				<cfelseif Arguments.operacion eq 'C'>
				
					<cfquery datasource="#session.dsn#" name="querydatos">
						update ISBmotivoRetiro set 
						 MRnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#querydatos_g.MREDES#">
						, Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
						where MRcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.MRECOD#">
						select @@rowcount as update_rowcount
					</cfquery>
					
					<cfif querydatos.update_rowcount is 0>
						<cfthrow message="No se realizó la actualización MRECOD=#Arguments.MRECOD#">
					</cfif>
				<cfelse>						
					<cfquery datasource="#session.dsn#" name="querydatos">
						delete ISBmotivoRetiro 
						where MRcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.MRECOD#">
						select @@rowcount as delete_rowcount
					</cfquery>
				
					<cfif querydatos.delete_rowcount is 0>
						<cfthrow message="No se realizó el borrado MRECOD=#Arguments.MRECOD#">
					</cfif>
				</cfif>
		
	</cffunction>	
	<cffunction name="SSXIFC" access="public" returntype="void" output="true">
		<cfargument name="IFCCOD" type="string" required="yes">
		<cfargument name="operacion" type="string" required="yes">
		
					<cfquery datasource="SACISIIC" name="querydatos_g">
						Select IFCCOD, IFCDES, IFCTIP from SSXIFC
						Where IFCCOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.IFCCOD#">
					</cfquery>	

					<cfquery datasource="#session.dsn#" name="querydatos_cod">
						Select max(convert(int,EFid))+1 EFid 
						from ISBentidadFinanciera
					</cfquery>	

				<cfset entidad = RepeatString("0", 4 - Len(querydatos_cod.EFid)) & querydatos_cod.EFid>
				
			<cftransaction>							
				<cfif Arguments.operacion eq 'A'>
	
					<cfquery datasource="#session.dsn#" name="querydatos_duplicados">
						 Select * from ISBentidadFinanciera 
						 Where IFCCOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.IFCCOD#">
					</cfquery>
						
					<cfif querydatos_duplicados.RecordCount gt 0>
						<cfthrow message="El código de Entidad IFCCOD= #Arguments.IFCCOD# ya existe en ISBentidadFinanciera">
					</cfif>		
					
					<cfquery datasource="#session.dsn#" name="querydatos_duplicados">
						 Select * from ISBtarjeta
						 Where IFCCOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.IFCCOD#">
					</cfquery>
						
					<cfif querydatos_duplicados.RecordCount gt 0>
						<cfthrow message="El código de Entidad IFCCOD= #Arguments.IFCCOD# ya existe en ISBtarjeta">
					</cfif>					
												
					<cfquery datasource="#session.dsn#" name="querydatos_in">
					insert ISBentidadFinanciera 
					(EFid
					,Ecodigo
					, EFtipo
					, EFnombre
					, EFvalidador
					, Habilitado
					, BMUsucodigo
					, IFCCOD)
					values (
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#entidad#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="1">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#querydatos_g.IFCDES#">,
						<cfqueryparam cfsqltype="cf_sql_bit" value="1">,
						<cfqueryparam cfsqltype="cf_sql_smallint" value="1">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#querydatos_g.IFCCOD#">)
					</cfquery>
					
					<cfif querydatos_g.IFCTIP eq 'T'>
						<cfquery datasource="#session.dsn#" name="querydatos_in">
						insert ISBtarjeta
						(MTnombre
						,Habilitado
						, BMUsucodigo
						, IFCCOD)
						values (
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#querydatos_g.IFCDES#">,
							<cfqueryparam cfsqltype="cf_sql_bit" value="1">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#querydatos_g.IFCCOD#">)
						</cfquery>
					</cfif>
				<cfelseif Arguments.operacion eq 'C'>
				
					<cfquery datasource="#session.dsn#" name="querydatos">
						update ISBentidadFinanciera  set 
						 EFnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#querydatos_g.IFCDES#">
						, Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
						where IFCCOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.IFCCOD#">
						select @@rowcount as update_rowcount
					</cfquery>
					
					<cfif querydatos.update_rowcount is 0>
						<cfthrow message="No se realizó la actualización IFCCOD=#Arguments.IFCCOD# en ISBtarjeta">
					</cfif>
				
					<cfif querydatos_g.IFCTIP eq 'T'>
						<cfquery datasource="#session.dsn#" name="querydatos">
							update ISBtarjeta  set 
							 MTnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#querydatos_g.IFCDES#">
							, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
							where IFCCOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.IFCCOD#">
							select @@rowcount as update_rowcount
						</cfquery>
						
						<cfif querydatos.update_rowcount is 0>
							<cfthrow message="No se realizó la actualización IFCCOD=#Arguments.IFCCOD# en ISBtarjeta">
						</cfif>
					</cfif>
				<cfelse>						
					<cfquery datasource="#session.dsn#" name="querydatos">
						delete ISBentidadFinanciera 
						where IFCCOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.IFCCOD#">
						select @@rowcount as delete_rowcount
					</cfquery>
				
					<cfif querydatos.delete_rowcount is 0>
						<cfthrow message="No se realizó el borrado IFCCOD=#Arguments.IFCCOD# en ISBentidadFinanciera">
					</cfif>
									
					<cfquery datasource="#session.dsn#" name="querydatos">
						delete ISBtarjeta
						where IFCCOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.IFCCOD#">
						select @@rowcount as delete_rowcount
					</cfquery>									
					
				</cfif>
		</cftransaction>	
	</cffunction>	
		
	<cffunction name="SSXINS" access="public" returntype="void" output="true">
		<cfargument name="INSCOD" type="string" required="yes">
		<cfargument name="operacion" type="string" required="yes">
		
					<cfquery datasource="SACISIIC" name="querydatos_g">
						Select INSCOD, INSDES from SSXINS
						Where INSCOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.INSCOD#">
					</cfquery>	

					<cfquery datasource="#session.dsn#" name="querydatos_cod">
						Select max(convert(int,EFid))+1 EFid 
						from ISBentidadFinanciera
					</cfquery>	
					
				<cfset entidad = RepeatString("0", 4 - Len(querydatos_cod.EFid)) & querydatos_cod.EFid>

				<cfif Arguments.operacion eq 'A'>
					
					<cfquery datasource="#session.dsn#" name="querydatos_duplicados">
					 Select * from ISBentidadFinanciera 
					 Where INSCOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.INSCOD#">
					</cfquery>
						
					<cfif querydatos_duplicados.RecordCount gt 0>
						<cfthrow message="El código de Entidad INSCOD= #Arguments.INSCOD# ya existe">
					</cfif>					

					
					<cfquery datasource="#session.dsn#" name="querydatos_in">
					insert ISBentidadFinanciera 
					(EFid
					,Ecodigo
					, EFtipo
					, EFnombre
					, EFvalidador
					, Habilitado
					, BMUsucodigo
					, INSCOD)
					values (
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#entidad#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="1">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#querydatos_g.INSDES#">,
						<cfqueryparam cfsqltype="cf_sql_bit" value="1">,
						<cfqueryparam cfsqltype="cf_sql_smallint" value="1">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#querydatos_g.INSCOD#">)
					</cfquery>
					
				<cfelseif Arguments.operacion eq 'C'>
				
					<cfquery datasource="#session.dsn#" name="querydatos">
						update ISBentidadFinanciera  set 
						 EFnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#querydatos_g.INSDES#">
						, Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
						where INSCOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.INSCOD#">
						select @@rowcount as update_rowcount
					</cfquery>
					
					<cfif querydatos.update_rowcount is 0>
						<cfthrow message="No se realizó la actualización INSCOD=#Arguments.INSCOD#">
					</cfif>
				<cfelse>						
					<cfquery datasource="#session.dsn#" name="querydatos">
						delete ISBentidadFinanciera 
						where INSCOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.INSCOD#">
						select @@rowcount as delete_rowcount
					</cfquery>
				
					<cfif querydatos.delete_rowcount is 0>
						<cfthrow message="No se realizó el borrado INSCOD=#Arguments.INSCOD#">
					</cfif>
				</cfif>
		
	</cffunction>	
		
	<cffunction name="SSXECG" access="public" returntype="void" output="true">
		<cfargument name="ECGCOD" type="string" required="yes">
		<cfargument name="operacion" type="string" required="yes">
		
					<cfquery datasource="SACISIIC" name="querydatos_g">
						Select ECGCOD, ECGNOM, ECGDES, ECGSEV, ECGPEN from SSXECG
						Where ECGCOD = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ECGCOD#">
					</cfquery>	

											
				<cfif Arguments.operacion eq 'A'>
					<cfquery datasource="#session.dsn#" name="querydatos_in">
					
					set identity_insert ISBinconsistencias ON
					insert ISBinconsistencias 
					(Iid
					, Ecodigo
					, Inombre
					, Idescripcion
					, Iseveridad
					, Ipenalizada
					, BMUsucodigo)
					
					values (
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#querydatos_g.ECGCOD#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#querydatos_g.ECGNOM#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#querydatos_g.ECGDES#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#querydatos_g.ECGSEV#">,
						<cfqueryparam cfsqltype="cf_sql_bit" value="#querydatos_g.ECGPEN#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
					set identity_insert ISBinconsistencias  OFF
					</cfquery>
					
				<cfelseif Arguments.operacion eq 'C'>
				
					<cfquery datasource="#session.dsn#" name="querydatos">
						update ISBinconsistencias  set 
						 Inombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#querydatos_g.ECGNOM#">
						, Idescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#querydatos_g.ECGDES#">
						, Iseveridad = <cfqueryparam cfsqltype="cf_sql_varchar" value="#querydatos_g.ECGSEV#">
						, Ipenalizada = <cfqueryparam cfsqltype="cf_sql_bit" value="#querydatos_g.ECGPEN#">
						, Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
						where Iid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ECGCOD#">
						select @@rowcount as update_rowcount
					</cfquery>
					
					<cfif querydatos.update_rowcount is 0>
						<cfthrow message="No se realizó la actualización ECGCOD=#Arguments.ECGCOD#">
					</cfif>
				<cfelse>						
					<cfquery datasource="#session.dsn#" name="querydatos">
						delete ISBinconsistencias
						where Iid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ECGCOD#">
						select @@rowcount as delete_rowcount
					</cfquery>
				
					<cfif querydatos.delete_rowcount is 0>
						<cfthrow message="No se realizó el borrado ECGCOD=#Arguments.ECGCOD#">
					</cfif>
				</cfif>
		
	</cffunction>
	
	<cffunction name="SSXCLA" access="public" returntype="void" output="true">
		<cfargument name="CLACOD" type="string" required="yes">
		<cfargument name="operacion" type="string" required="yes">
		
					<cfquery datasource="SACISIIC" name="querydatos_g">
						Select CLACOD, CLADES from SSXCLA
						Where CLACOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.CLACOD#">
					</cfquery>	
										
				<cfif Arguments.operacion eq 'A' >
					<cfquery datasource="#session.dsn#" name="querydatos">
						insert ISBclaseCuenta
						(CCclaseCuenta
						, CCnombre
						, Ecodigo
						, BMUsucodigo)
						values (
						<cfqueryparam cfsqltype="cf_sql_integer" value="#querydatos_g.CLACOD#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#querydatos_g.CLADES#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)								
					</cfquery>
					
				<cfelseif Arguments.operacion eq 'C'>
				
					<cfquery datasource="#session.dsn#" name="querydatos">
						update ISBclaseCuenta set 
						 CCnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#querydatos_g.CLADES#">
						, Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
						where CCclaseCuenta = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.CLACOD#">
						select @@rowcount as update_rowcount
					</cfquery>
					
					<cfif querydatos.update_rowcount is 0>
						<cfthrow message="No se realizó la actualización CLACOD=#Arguments.CLACOD#">
					</cfif>
				<cfelse>						
					<cfquery datasource="#session.dsn#" name="querydatos">
						delete ISBclaseCuenta 
						where CCclaseCuenta = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.CLACOD#">
						select @@rowcount as delete_rowcount
					</cfquery>
					
					<cfif querydatos.delete_rowcount is 0>
						<cfthrow message="No se realizó el borrado CLACOD=#Arguments.CLACOD#">
					</cfif>
				</cfif>
		
	</cffunction>	

	
	<cffunction name="SSXCAN" access="public" returntype="void" output="true">
		<cfargument name="PRVCOD" type="string" required="yes">
		<cfargument name="CANCOD" type="string" required="yes">
		<cfargument name="operacion" type="string" required="yes">
		

					<cfquery datasource="SACISIIC" name="querydatos_CAN">
						Select PRVCOD, CANCOD,CANDES 
						from SSXCAN
						Where PRVCOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PRVCOD#">
						And CANCOD =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.CANCOD#">
					</cfquery>	


					<cfquery datasource="#session.dsn#" name="querydatos">
						Select LCid from Localidad
						Where LCcod = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.PRVCOD#">
						And DPnivel =  <cfqueryparam cfsqltype="cf_sql_integer" value="1">
					</cfquery>	

										
				<cfif Arguments.operacion eq 'A'>
					<cfquery datasource="#session.dsn#" name="querydatos_INSERT">
						insert Localidad 
						(Ppais
						, DPnivel
						, LCcod
						, LCnombre
						, LCidPadre
						, Habilitado
						, BMUsucodigo
						)
						values (
						<cfqueryparam cfsqltype="cf_sql_char" value="CR">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="2">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#querydatos_CAN.CANCOD#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#querydatos_CAN.CANDES#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#querydatos.LCid#">,
						<cfqueryparam cfsqltype="cf_sql_smallint" value="1">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)								
					</cfquery>
					
				<cfelseif Arguments.operacion eq 'C'>
				
					<cfquery datasource="#session.dsn#" name="querydatos_UPD">
						Update Localidad set 
						 LCnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#querydatos_CAN.CANDES#">
						Where LCidPadre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#querydatos.LCid#">
						And LCcod = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CANCOD#">
						And DPnivel =  <cfqueryparam cfsqltype="cf_sql_integer" value="2">
						select @@rowcount as update_rowcount
					</cfquery>
					
					<cfif querydatos.update_rowcount is 0>
						<cfthrow message="No se realizó la actualización  CANCOD=#Arguments.CANCOD#">
					</cfif>
				<cfelse>						
					<cfquery datasource="#session.dsn#" name="querydatos">
						delete Localidad 
						Where LCidPadre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#querydatos.LCid#">
						And LCcod = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CANCOD#">
						And DPnivel =  <cfqueryparam cfsqltype="cf_sql_integer" value="2">
						select @@rowcount as delete_rowcount
					</cfquery>
				
					<cfif querydatos.delete_rowcount is 0>
						<cfthrow message="No se realizó el borrado CANCOD=#Arguments.CANCOD#">
					</cfif>
				</cfif>
		
	</cffunction>	
	<cffunction name="SSXDIS" access="public" returntype="void" output="true">
		<cfargument name="PRVCOD" type="string" required="yes">
		<cfargument name="CANCOD" type="string" required="yes">
		<cfargument name="DISCOD" type="string" required="yes">
		<cfargument name="operacion" type="string" required="yes">
		

					<cfquery datasource="SACISIIC" name="querydatos_DIS">
						Select PRVCOD, CANCOD, DISCOD, DISDES 
						from SSXDIS
						Where PRVCOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PRVCOD#">
						And CANCOD =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.CANCOD#">
						And DISCOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.DISCOD#">
					</cfquery>	


					<cfquery datasource="#session.dsn#" name="querydatos">
						Select cant.LCid  
						from Localidad prov
						inner join Localidad cant
						on prov.LCid = cant.LCidPadre
						and prov.DPnivel =  1
						and prov.LCcod = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.PRVCOD#">
						and cant.LCcod = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CANCOD#">
					</cfquery>	

										
				<cfif Arguments.operacion eq 'A'>
					<cfquery datasource="#session.dsn#" name="querydatos_IN">
						insert Localidad 
						(Ppais
						, DPnivel
						, LCcod
						, LCnombre
						, LCidPadre
						, Habilitado
						, BMUsucodigo
						)
						values (
						<cfqueryparam cfsqltype="cf_sql_char" value="CR">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="3">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#querydatos_DIS.DISCOD#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#querydatos_DIS.DISDES#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#querydatos.LCid#">,
						<cfqueryparam cfsqltype="cf_sql_smallint" value="1">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)								
					</cfquery>
					
				<cfelseif Arguments.operacion eq 'C'>
				
					<cfquery datasource="#session.dsn#" name="querydatos_upd">
						Update Localidad set 
						 LCnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#querydatos_DIS.DISDES#">
						Where LCidPadre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#querydatos.LCid#">
						And LCcod = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.DISCOD#">
						And DPnivel =  <cfqueryparam cfsqltype="cf_sql_integer" value="3">
						select @@rowcount as update_rowcount
					</cfquery>
					
					<cfif querydatos.update_rowcount is 0>
						<cfthrow message="No se realizó la actualización DISCOD=#Arguments.DISCOD#">
					</cfif>
				<cfelse>						
					<cfquery datasource="#session.dsn#" name="querydatos_del">
						delete Localidad 
						Where LCidPadre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#querydatos.LCid#">
						And LCcod = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.DISCOD#">
						And DPnivel =  <cfqueryparam cfsqltype="cf_sql_integer" value="3">
						select @@rowcount as delete_rowcount
					</cfquery>
				
					<cfif querydatos.delete_rowcount is 0>
						<cfthrow message="No se realizó el borrado DISCOD=#Arguments.DISCOD#">
					</cfif>
				</cfif>
		
	</cffunction>	

	<cffunction name="SSXPRO" access="public" returntype="void" output="true">
		<cfargument name="PRVCOD" type="string" required="yes">
		<cfargument name="operacion" type="string" required="yes">
		

					<cfquery datasource="SACISIIC" name="querydatos_PRO">
						Select PRVCOD, PRVDES from SSXPRO
						Where PRVCOD = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PRVCOD#">						
					</cfquery>	


					<cfquery datasource="#session.dsn#" name="querydatos">
						Select LCid from Localidad
						Where LCcod = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(Arguments.PRVCOD)#">
						And DPnivel =  <cfqueryparam cfsqltype="cf_sql_integer" value="1">
					</cfquery>	
				
				
				<cfif not Len(querydatos.LCid) and Arguments.operacion neq 'A'>
					<cfthrow message="Error al Seleccionar el LCid">
				</cfif>
										
				<cfif Arguments.operacion eq 'A'>
					<cfquery datasource="#session.dsn#" name="querydatos_IN">
						insert Localidad 
						(Ppais
						, DPnivel
						, LCcod
						, LCnombre
						, LCidPadre
						, Habilitado
						, BMUsucodigo
						)
						values (
						<cfqueryparam cfsqltype="cf_sql_char" value="CR">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="1">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#querydatos_PRO.PRVCOD#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#querydatos_PRO.PRVDES#">,	
						<cfqueryparam cfsqltype="cf_sql_numeric"  null="yes">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="1">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.usucodigo#">)							
					</cfquery>
					
				<cfelseif Arguments.operacion eq 'C'>
				
					<cfquery datasource="#session.dsn#" name="querydatos_CAMBIO">
						Update Localidad set 
						 LCnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#querydatos_PRO.PRVDES#">
						Where LCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#querydatos.LCid#">
						And DPnivel =  <cfqueryparam cfsqltype="cf_sql_integer" value="1">
						select @@rowcount as update_rowcount
					</cfquery>
					
					<cfif querydatos.update_rowcount is 0>
						<cfthrow message="No se realizó la actualización #querydatos.LCid#">
					</cfif>
				<cfelse>						
					<cfquery datasource="#session.dsn#" name="querydatos">
						delete Localidad
						where LCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#querydatos.LCid#">
						select @@rowcount as delete_rowcount
					</cfquery>
				
					<cfif querydatos.delete_rowcount is 0>
						<cfthrow message="No se realizó el borrado #querydatos.LCid#">
					</cfif>
				</cfif>
		
	</cffunction>	
	
	<cffunction name="getValueAt" access="private" returntype="any">
		<cfargument name="trama" type="array" required="yes">
		<cfargument name="index" type="numeric" required="yes">
		
		<cfif ArrayLen(Arguments.trama) ge index>
			<cfreturn trama[index]>
		<cfelse>
			<cfreturn "">	
		</cfif>
		
	</cffunction>
	
</cfcomponent>