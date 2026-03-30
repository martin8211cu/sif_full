<cfcomponent extends="base">
	<cffunction name="IngresaGarantia" access="public" returntype="void" output="false">
		<cfargument name="Gid" type="string">
		<cfargument name="origen" type="string" default="saci">
		<cfargument name="TipoEvento" type="string">

		
		<cfset control_inicio( Arguments, 'H029b','Gid=' & Arguments.Gid & ' - '  & 'TipoEvento=' & Arguments.TipoEvento)>
		<cftry>
			<cfset control_servicio( 'saci' )>
			
				<cfquery datasource="#session.dsn#" name="ISBgarantia">
					select g.Gtipo, isnull(g.Gmonto,0) as Gmonto, g.Gref, g.Ginicio, g.Miso4217, ef.INSCOD,LGlogin,g.Contratoid
					from ISBgarantia g
					left join ISBentidadFinanciera ef
					on ef.EFid = g.EFid
					left join ISBlogin lo
					on g.Contratoid = lo.Contratoid
					and lo.LGprincipal = 1
					where g.Gid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Gid#">
				</cfquery>
				
				<cfquery datasource="#session.dsn#" name="getCTtipoUso">
					Select cue.CTtipoUso from ISBgarantia g
    				inner join ISBproducto c 
    				on g.Contratoid = c.Contratoid
    				inner join ISBcuenta cue
    				on c.CTid = cue.CTid   
					where g.Gid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Gid#">
					and cue.CTtipoUso = 'A'
				</cfquery>
						
			   <cfif NOT Len(ISBgarantia.LGlogin) and NOT Len(getCTtipoUso.CTtipoUso) >
			   	<cfthrow message="No hay Login principal para el Contrato #ISBgarantia.Contratoid#">
			   </cfif>
				
				<cfif TipoEvento eq 'insert'>
					<cfquery datasource="SACISIIC" name="depositos">
						exec sp_Alta_SSXDEP
						<!---El monto se indica en la interfaz SACI-03-H029b--->
						@DEPMON = <cfqueryparam cfsqltype="cf_sql_float" value="#ISBgarantia.Gmonto#"> 
						, @DEPMOD = <cfif ISBgarantia.Miso4217 is 'USD'>'D'<cfelse>'C'</cfif>
						, @SERIDS = null
						, @SERCLA = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBgarantia.LGlogin#" null="#Len(ISBgarantia.LGlogin) is 0#">
						, @INSCOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#ISBgarantia.INSCOD#" null="#Len(ISBgarantia.INSCOD) is 0#">
						, @DEPDOC = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBgarantia.Gref#" null="#Len(ISBgarantia.Gref) is 0#">
						, @DEPFED =
						<cfif Len(ISBgarantia.Ginicio)>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="# DateFormat(ISBgarantia.Ginicio, 'yyyymmdd')#">
						<cfelse> NULL </cfif>
						
						, @FIDCOD = <cfif Len(ISBgarantia.Gtipo)>
						<cfqueryparam cfsqltype="cf_sql_integer" value="#ISBgarantia.Gtipo#" null="#Len(ISBgarantia.Gtipo) is 0#">
						<cfelse> 1 </cfif>
						, @MAAT 	= 1
						, @RETORNO = 1
						, @DEPEST  = -1
					</cfquery>

					<cfquery datasource="#session.dsn#" name="actualizaISBgarantia">
						Update ISBgarantia Set DEPNUM = <cfqueryparam cfsqltype="cf_sql_float" value="#depositos.DEPNUM#">
						Where Gid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Gid#">
					</cfquery>
				<cfelseif TipoEvento eq 'update'>
				
					<cfquery datasource="#session.dsn#" name="getDEPNUM">
						Select DEPNUM from ISBgarantia
						Where Gid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Gid#">
					</cfquery>
				
				<cfif Not Len(getDEPNUM.DEPNUM)>
					<cfthrow message="No se encontro el DEPNUM en la tabla ISBgarantia">
				</cfif>				
					<!---<cfquery datasource="SACISIIC">
						Update SSXDEP Set 
						  DEPMON = <cfqueryparam cfsqltype="cf_sql_float" value="#ISBgarantia.Gmonto#"> 
						, DEPMOD = <cfif ISBgarantia.Miso4217 is 'USD'>'D'<cfelse>'C'</cfif>
						, SERIDS = null
						, SERCLA = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBgarantia.LGlogin#" null="#Len(ISBgarantia.LGlogin) is 0#">
						, INSCOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#ISBgarantia.INSCOD#" null="#Len(ISBgarantia.INSCOD) is 0#">
						, DEPDOC = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBgarantia.Gref#" null="#Len(ISBgarantia.Gref) is 0#">
						, DEPFED =
						<cfif Len(ISBgarantia.Ginicio)>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="# DateFormat(ISBgarantia.Ginicio, 'yyyymmdd')#">
						<cfelse> NULL </cfif>
						
						, FIDCOD = <cfif Len(ISBgarantia.Gtipo)>
						<cfqueryparam cfsqltype="cf_sql_integer" value="#ISBgarantia.Gtipo#" null="#Len(ISBgarantia.Gtipo) is 0#">
						<cfelse> 1 </cfif>
						Where DEPNUM = <cfqueryparam cfsqltype="cf_sql_float" value="#getDEPNUM.DEPNUM#">--->
					<cfquery datasource="SACISIIC" name="depositos_q">
							exec sp_Cambio_SSXDEP
								<!---El monto se indica en la interfaz SACI-03-H029b--->
								 @DEPMON = <cfqueryparam cfsqltype="cf_sql_float" value="#ISBgarantia.Gmonto#"> 
								, @DEPMOD = <cfif ISBgarantia.Miso4217 is 'USD'>'D'<cfelse>'C'</cfif>
								, @SERIDS = null
								, @SERCLA = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBgarantia.LGlogin#" null="#Len(ISBgarantia.LGlogin) is 0#">
								, @INSCOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#ISBgarantia.INSCOD#" null="#Len(ISBgarantia.INSCOD) is 0#">
								, @DEPDOC = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBgarantia.Gref#" null="#Len(ISBgarantia.Gref) is 0#">
								, @DEPFED =
								<cfif Len(ISBgarantia.Ginicio)>
									<cfqueryparam cfsqltype="cf_sql_varchar" value="# DateFormat(ISBgarantia.Ginicio, 'yyyymmdd')#">
								<cfelse> NULL </cfif>
								
								, @FIDCOD = <cfif Len(ISBgarantia.Gtipo)>
								<cfqueryparam cfsqltype="cf_sql_integer" value="#ISBgarantia.Gtipo#" null="#Len(ISBgarantia.Gtipo) is 0#">
								<cfelse> 1 </cfif>
								, @MAAT 	= 1
								, @RETORNO = 1
								, @DEPNUM = <cfqueryparam cfsqltype="cf_sql_float" value="#getDEPNUM.DEPNUM#">				
					</cfquery>
				</cfif>	
						
				
							
			<cfset control_final( )>
		<cfcatch type="any">
			<!--- error --->
			<cfset control_catch( cfcatch )>
		</cfcatch>
		</cftry>
	</cffunction>
</cfcomponent>