<!---
    modificado por danim,2005-09-06, para 
    incluir los parametros de Grupo de Empresas
    y Grupo de Oficinas
	Tanto en AnexoCalculo como en AnexoVarValor,
		Ecodigo debe ser -1 cuando GEcodigo != -1,
		es decir, la información para grupos de
		empresas se guarda sin indicar una empresa
		específica, esto permite realizar las búsquedas
		con la empresa -1

    modificado por obonilla66,2005-11-01, para 
    incluir la actualizacion de Anexos Calculados desde Excel
--->

<cfcomponent>
	<!--- calcularAnexo: 
		Hace los calculos del anexo y los inserta en la tabla
	--->
	<cffunction name="calcularAnexo" output="false">
		<cfargument name="DataSource" 		required="yes">
		<cfargument name="ACid"       		required="yes" type="numeric">
		<cfargument name="ACactualizarEn" 	required="no"	type="string" default="S">
		<cfargument name="AnexoCelId"     	required="no" type="numeric" default="-1">
		
		<cfset Arguments.ACactualizarEn = "E">	 

		<cfsetting requesttimeout="36000">
		
		
		<CFSET GvarMeses = "">
		<cfset hora_de_inicio = GetTickCount()>
		
		<cfquery DataSource="#Arguments.DataSource#" name="rsAnexoCalculo">
			select 	c.ACid, 
					c.ACstatus, 
					c.ACano, 
					c.ACmes,
					abs(c.ACunidad) as ACunidad, 
					c.Mcodigo, ACmLocal,
					c.AnexoId, 
					coalesce(a.Ecodigo, -1)                 as EcodigoAnexoDueno, 
					coalesce(c.Ecodigo, -1)                 as EcodigoAnexoCalculo, 
					coalesce(c.Ocodigo,-1) 	                as Ocodigo, 
					coalesce(c.GOid,-1)		                as GOid, 
					coalesce(c.GEid,-1)		                as GEid,
					c.BMUsucodigo                           as Usuario,
					coalesce(a.AnexoSaldoConvertido,0)      as TipoSaldo
			  from AnexoCalculo c
			  	inner join Anexo a
					on a.AnexoId = c.AnexoId
			 where c.ACid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ACid#">
		</cfquery>
		<cfif rsAnexoCalculo.ACstatus EQ 'C' AND Arguments.AnexoCelId EQ "-1">
			<!--- C="Calculandose" ya esta calculándose, salir --->
			<cfreturn>
		</cfif>
		<cfif not isdefined('session.Usucodigo')>
			<cfset session.Usucodigo = rsAnexoCalculo.Usuario>
		</cfif>

		<cfset LvarACsaldos	= structNew()>
		<cfset LvarACsaldos.TipoSaldo	= rsAnexoCalculo.TipoSaldo>
		<cfset LvarACsaldos.Mcodigo		= rsAnexoCalculo.Mcodigo>
		<cfset LvarACsaldos.ACmLocal	= rsAnexoCalculo.ACmLocal>

		<cfif LvarACsaldos.TipoSaldo eq 0>
			<!--- Saldos normales, se puede escoger moneda para todo el calculo --->
			<cfset LvarSaldosConvertidos = false>
		<cfelseif LvarACsaldos.TipoSaldo eq 1>
			<!--- Saldos convertidos, se puede escoger moneda para todo el calculo --->
			<cfset LvarSaldosConvertidos = true>
			<cfset LvarB15 = "0">
			<cfquery name="rsSQL" datasource="#Arguments.DataSource#">
				select m.Miso4217
				  from Parametros p
					inner join Monedas m
						on m.Mcodigo = <cf_dbfunction name="to_number" args="p.Pvalor">
				 where p.Ecodigo = #session.Ecodigo#
				   and p.Pcodigo = 660
			</cfquery>
			<cfset LvarMiso4217_Conversion = rsSQL.Miso4217>
		<cfelseif LvarACsaldos.TipoSaldo eq 2>
			<!--- Saldos multimoneda, cada concepto tiene su moneda --->
			<cfset LvarSaldosConvertidos = false>
			<cfset LvarACsaldos.Mcodigo		= -1>
		<cfelseif LvarACsaldos.TipoSaldo eq 3>
			<!--- Saldos convertidos B15-1, se puede escoger moneda para todo el calculo --->
			<cfset LvarSaldosConvertidos = true>
			<cfset LvarB15 = "1">
			<!--- 21/01/2015 Inicio. JMRV --->
			<cfquery name="rsSQL" datasource="#Arguments.DataSource#">
				select m.Miso4217
				  from Parametros p
					inner join Monedas m
						on m.Mcodigo = <cf_dbfunction name="to_number" args="p.Pvalor">
				 where p.Ecodigo = #session.Ecodigo#
				   and p.Pcodigo = 660
			</cfquery>
			<!--- Fin. JMRV --->
			<cfset LvarMiso4217_Conversion = rsSQL.Miso4217>
		<cfelseif LvarACsaldos.TipoSaldo eq 4>
			<!--- Saldos convertidos B15-2, se puede escoger moneda para todo el calculo --->
			<cfset LvarSaldosConvertidos = true>
			<cfset LvarB15 = "2">
			<!--- 21/01/2015 Inicio. JMRV --->
			<cfquery name="rsSQL" datasource="#Arguments.DataSource#">
				select m.Miso4217
				  from Parametros p
					inner join Monedas m
						on m.Mcodigo = <cf_dbfunction name="to_number" args="p.Pvalor">
				 where p.Ecodigo = #session.Ecodigo#
				   and p.Pcodigo = 660
			</cfquery>
			<!--- Fin. JMRV --->
			<cfset LvarMiso4217_Conversion = rsSQL.Miso4217>
		</cfif>

		<cftry>
			<cfset LvarDir=expandPath("/sif/an/html/" & DateFormat(now(),"YYYYMMDD") & "/AC##")>
			<cfif DirectoryExists(LvarDir)>
				<cfdirectory action="delete" directory="#LvarDir#" recurse="yes">
			</cfif>
		<cfcatch type="any">
			<cf_errorCode	code = "50833" msg = "El anexo calculado está siendo consultado en este momento, reintente más tarde">
		</cfcatch>
		</cftry>
		
		<cfquery  DataSource="#Arguments.DataSource#">
			update AnexoCalculo
			   set ACstatus = 'C'
			     , ACxls = null
				 , ACzip = null
			     , ACxml = null
			 where ACid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ACid#">
		</cfquery>

		<!--- borra los registros en AnexoCalculoRango pararecalcularlos --->
		<cfquery DataSource="#Arguments.DataSource#">
			delete from AnexoCalculoRango
			 where ACid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ACid#">
		</cfquery>

		<!--- ========================================================== --->
		<!--- CALCULO DE LOS ANEXOS    (TOMADO DE AnexoLogic.cfm ) --->
		<!--- ========================================================== --->
		

		<!---
			tmpCeldasCfmts: Expande AnexoCelD (Formatos de una Celda) para cada Ubicacion
		--->
		<cf_dbtemp name="AC_FMTS_V1" returnvariable="tmpCeldasCfmts" datasource="#Arguments.DataSource#">
			<cf_dbtempcol name="AnexoCelId" 	type="numeric">
			<cf_dbtempcol name="Ecodigo" 		type="integer">
			<cf_dbtempcol name="Ocodigo"		type="integer">
			<cf_dbtempcol name="Mcodigo" 		type="numeric">
			<cf_dbtempcol name="Cmayor"			type="numeric"> <!--- JMRV 21/01/2015 --->
			<cf_dbtempcol name="AnexoCelFmt"	type="varchar(100)">
			<cf_dbtempcol name="AnexoSigno"		type="integer">
			<cf_dbtempcol name="Anexolk"		type="integer">
			<cf_dbtempcol name="AnexoCelMov"	type="char(1)">
			<cf_dbtempcol name="PCDcatid"		type="numeric">
			<cf_dbtempindex cols="AnexoCelId,Anexolk,AnexoCelMov">
		</cf_dbtemp>

		<!---
			tmpCeldasCtas: Expande tmpCeldasCtas (Formatos de una Celda por Ubicacion) para cada Periodo+Mes
		--->
		<cf_dbtemp name="AC_CTAS_V3" returnvariable="tmpCeldasCtas" datasource="#Arguments.DataSource#">
			<cf_dbtempcol name="AnexoCelId" 	type="numeric">
			<cf_dbtempcol name="Ecodigo" 	    type="integer">
			<cf_dbtempcol name="Ocodigo"		type="integer">
			<cf_dbtempcol name="Mcodigo" 		type="numeric">
			<cf_dbtempcol name="cuentaID" 		type="numeric">
			<cf_dbtempcol name="Speriodo" 		type="integer">
			<cf_dbtempcol name="Smes"		 	type="integer">
			<cf_dbtempcol name="AnexoSigno" 	type="integer">
			<cf_dbtempcol name="CVid" 			type="numeric" mandatory="no">
			<cf_dbtempindex cols="AnexoCelId">
		</cf_dbtemp>

		<cfset LvarCargarMesesPer = structNew()>
		<cfset LvarCargarMesesPer.Per = 0>
		<cfset LvarCargarMesesPer.Mes = 0>
		<cfset LvarCargarMesesPer.Acum = false>

		<cf_dbtemp name="AC_MESES_V1" returnvariable="tmpMesesPer" datasource="#Arguments.DataSource#">
			<cf_dbtempcol name="Speriodo" 		type="integer">
			<cf_dbtempcol name="Smes"		 	type="integer">
		</cf_dbtemp>

		<cfif LvarACsaldos.TipoSaldo NEQ 2 AND LvarACsaldos.Mcodigo NEQ -1>
			<!--- Se va a utilizar despues con GEid para obtener el Mcodigo de la moneda en cada empresa --->
			<!--- 
				Solo se ocupa cuando es Moneda particular (Mcodigo NEQ -1) y Grupo de Empresas (LvarGEid NEQ -1),
				pero como el GEid es por celda, se guarda la moneda de calculo siempre 
			--->
			<cfquery name="rsSQL" DataSource="#Arguments.DataSource#">
				select Miso4217
				  from Monedas
				 where Mcodigo = #LvarACsaldos.Mcodigo#
			</cfquery>
			<cfset LvarGEmonedaCalculo = rsSQL.Miso4217>
		</cfif>

		<cfquery name="rsRangos" DataSource="#Arguments.DataSource#">
			select 
					AnexoCelId, AnexoId,
					AnexoRan, AnexoCon, 
					AnexoRel, AnexoMes,
					AnexoPer, 
					AnexoNeg, AVid, 
					coalesce(Ecodigocel,-1) as EcodigoCeldaCalculo,
					coalesce(Ocodigo,-1) 	as Ocodigo, 
					coalesce(GOid,-1) 		as GOid, 
					coalesce(GEid,-1) 		as GEid
					,CPtipoSaldo, ANFid, ANHid, ANHCid
					,coalesce(Mcodigo,-1) as Mcodigo,ACmLocal
			  from AnexoCel 
			 where AnexoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAnexoCalculo.AnexoId#">
			   <cfif Arguments.AnexoCelId NEQ "-1">
			   and  AnexoCelId = #Arguments.AnexoCelId#
			   </cfif>
			   and AnexoCon is not null
			   and AnexoFila > 0
			   and AnexoColumna > 0
	    </cfquery>

		<!--- LvarGEidsVerificaciones: 
			Se va a utilizar para verificar una unica vez los Grupos de Empresas (GEid<>-1)
				Saldos de Conversion:
					Misma moneda de coversion, mismo mes de cierre Corporativo y que se haya realizado proceso de conversión
				Saldos Contables cuando se ocupa la moneda local (Mcodigo=-1 OR ACmLocal EQ "1"):
					Misma moneda local
		--->
		<cfset LvarGEidsVerificaciones = "">
		<cfset LvarGEidsVerificacionesPerMes = "">
		<cfloop query="rsRangos">
			<cfset LvarAnexoCelId	= rsRangos.AnexoCelId>
			<cfset concepto 		= rsRangos.AnexoCon>
			<cfset mes      		= rsRangos.AnexoMes>
			<cfset per      		= rsRangos.AnexoPer>
			<cfset rel      		= rsRangos.AnexoRel>
			<cfset neg      		= rsRangos.AnexoNeg>
			<cfset AnexoRan 		= rsRangos.AnexoRan>
			<cfset AVid     		= rsRangos.AVid>
			<cfset LvarCPtipoSaldo	= rsRangos.CPtipoSaldo>
			<cfset LvarANFid		= rsRangos.ANFid>
			<cfset LvarANHid		= rsRangos.ANHid>
			<cfset LvarANHCid		= rsRangos.ANHCid>
			
			<cfif LvarACsaldos.TipoSaldo eq 2>
				<cfset LvarACsaldos.Mcodigo		= rsRangos.Mcodigo>
				<cfset LvarACsaldos.ACmLocal	= rsRangos.ACmLocal>
				<!--- Saldos multimoneda, cada concepto tiene su moneda --->
				<cfif LvarACsaldos.Mcodigo EQ -1>
					<cfset LvarGEmonedaCalculo = "LOCAL">
				<cfelse>
					<cfquery name="rsSQL" DataSource="#Arguments.DataSource#">
						select Miso4217
						  from Monedas
						 where Mcodigo = #LvarACsaldos.Mcodigo#
					</cfquery>
					<cfset LvarGEmonedaCalculo = rsSQL.Miso4217>
				</cfif>
			</cfif>
			
			<!--- 
				ORIGEN DE DATOS: primero por Rangos, luego por AnexoCalculo
			--->
			<cfif rsRangos.GEid NEQ "-1" AND Arguments.AnexoCelId EQ "-1">
				<cfset LvarGrupo	= true>
				<cfset LvarGEid		= rsRangos.GEid>
				<cfset LvarGOid		= "-1">
				<cfset LvarEcodigo	= "*">
				<cfset LvarOcodigo	= "-1">
			<cfelseif rsRangos.GOid NEQ "-1" AND Arguments.AnexoCelId EQ "-1">
				<cfset LvarGrupo	= true>
				<cfset LvarGEid		= "-1">
				<cfset LvarGOid		= rsRangos.GOid>
				<cfif rsRangos.EcodigoCeldaCalculo NEQ "-1">
					<cfset LvarEcodigo	= rsRangos.EcodigoCeldaCalculo>
				<cfelse>
					<cfquery name="rsSQL" DataSource="#Arguments.DataSource#">
						select Ecodigo
						  from AnexoGOficina
						 where GOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarGOid#">
					</cfquery>
					<cfset LvarEcodigo	= rsSQL.Ecodigo>
				</cfif>
				<cfset LvarOcodigo	= "-1">
			<cfelseif rsRangos.Ocodigo NEQ "-1" AND Arguments.AnexoCelId EQ "-1">
				<cfset LvarGrupo	= false>
				<cfset LvarGEid		= "-1">
				<cfset LvarGOid		= "-1">
				<cfset LvarEcodigo	= rsRangos.EcodigoCeldaCalculo>
				<cfset LvarOcodigo	= rsRangos.Ocodigo>
			<cfelseif rsRangos.EcodigoCeldaCalculo NEQ "-1" AND Arguments.AnexoCelId EQ "-1">
				<cfset LvarGrupo	= false>
				<cfset LvarGEid		= "-1">
				<cfset LvarGOid		= "-1">
				<cfset LvarEcodigo	= rsRangos.EcodigoCeldaCalculo>
				<cfset LvarOcodigo	= "-1">


			<cfelseif rsAnexoCalculo.GEid NEQ "-1">
				<cfset LvarGrupo	= true>
				<cfset LvarGEid		= rsAnexoCalculo.GEid>
				<cfset LvarGOid		= "-1">
				<cfset LvarEcodigo	= "*">
				<cfset LvarOcodigo	= "-1">
			<cfelseif rsAnexoCalculo.GOid NEQ "-1">
				<cfset LvarGrupo	= true>
				<cfset LvarGEid		= "-1">
				<cfset LvarGOid		= rsAnexoCalculo.GOid>
				<cfif rsAnexoCalculo.EcodigoAnexoCalculo NEQ "-1">
					<cfset LvarEcodigo	= rsAnexoCalculo.EcodigoAnexoCalculo>
				<cfelse>
					<cfquery name="rsSQL" DataSource="#Arguments.DataSource#">
						select Ecodigo
						  from AnexoGOficina
						 where GOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarGOid#">
					</cfquery>
					<cfset LvarEcodigo	= rsSQL.Ecodigo>
				</cfif>
				<cfset LvarOcodigo	= "-1">
			<cfelseif rsAnexoCalculo.Ocodigo NEQ "-1">
				<cfset LvarGrupo	= false>
				<cfset LvarGEid		= "-1">
				<cfset LvarGOid		= "-1">
				<cfset LvarEcodigo	= rsAnexoCalculo.EcodigoAnexoCalculo>
				<cfset LvarOcodigo	= rsAnexoCalculo.Ocodigo>
			<cfelseif rsAnexoCalculo.EcodigoAnexoCalculo NEQ "-1">
				<cfset LvarGrupo	= false>
				<cfset LvarGEid		= "-1">
				<cfset LvarGOid		= "-1">
				<cfset LvarEcodigo	= rsAnexoCalculo.EcodigoAnexoCalculo>
				<cfset LvarOcodigo	= "-1">
			<cfelse>
				<cf_errorCode	code = "50834" msg = "No se ha definido el Origen de Calculo">
			</cfif>

			<cfset valor = ''> <!--- danim, 20050906, por si el valor no se encuentra que no se arrastre --->

			<cfif rel eq 1 >
				<cfset Mest = rsAnexoCalculo.ACmes - mes>
				<cfset per = rsAnexoCalculo.ACano>
				<cfif Mest lt 1 >
					<cfset mes = 12 + ((rsAnexoCalculo.ACmes - mes) mod 12) >
					<cfset per = rsAnexoCalculo.ACano - 1 - ((mes - rsAnexoCalculo.ACmes) \ 12)>
				<cfelse>
					<cfset mes = Mest >
				</cfif>
			<cfelse>
				<cfset per = rsAnexoCalculo.ACano - per >
			</cfif>

			<!--- 
				Cuando se calcula para "Todas las Monedas" o se expresa en Moneda Local en un Grupo de Empresas:
				verifica que todas las empresas del grupo tengan la misma moneda local 
				(solo lo hace una vez por grupo) 
			--->
			<cfset LvarVerificarGEid = LvarGEid NEQ -1 AND NOT listFind(LvarGEidsVerificaciones, LvarGEid)>
			<cfset LvarVerificarGEidPerMes = LvarGEid NEQ -1 AND NOT listFind(LvarGEidsVerificaciones, "#LvarGEid#|#per#|#mes#")>


			<cfif NOT LvarSaldosConvertidos AND LvarVerificarGEid AND (LvarACsaldos.Mcodigo EQ -1 OR LvarACsaldos.ACmLocal EQ "1")>
				<cfset LvarGEidsVerificaciones = listAppend(LvarGEidsVerificaciones, LvarGEid)>
				<cfquery name="rsSQL" DataSource="#Arguments.DataSource#">
					select distinct m.Miso4217
					  from AnexoGEmpresaDet ge
						inner join Empresas e
								inner join Monedas m
								   on m.Mcodigo = e.Mcodigo
						   on e.Ecodigo = ge.Ecodigo
					 where GEid = #LvarGEid#
				</cfquery>
				<cfif rsSQL.recordCount GT 1>
					<cfquery name="rsSQL" DataSource="#Arguments.DataSource#">
						select GEcodigo, GEnombre
						  from AnexoGEmpresa
						 where GEid = #LvarGEid#
					</cfquery>
					<cfif LvarACsaldos.Mcodigo EQ -1>
						<cf_errorCode	code = "50835"
									msg  = "El grupo de Empresas '@errorDat_1@ - @errorDat_2@' está formado por empresas que tienen diferentes monedas locales. No se puede calcular el anexo para todas las monedas."
									errorDat_1="#rsSQL.GEcodigo#"
									errorDat_2="#rsSQL.GEnombre#"
						>
					<cfelse>
						<cfthrow message="El grupo de Empresas '#rsSQL.GEcodigo# - #rsSQL.GEnombre#' está formado por empresas que tienen diferentes monedas locales. No se puede expresar el calculo en moneda local.">
					</cfif>						
				</cfif>


			<cfelseif LvarSaldosConvertidos AND LvarVerificarGEidPerMes>
				<!--- Verificar Moneda y Proceso de Conversion para empresas en otra moneda --->
				<cfif LvarVerificarGEid>
					<cfset LvarGEidsVerificaciones = listAppend(LvarGEidsVerificaciones, LvarGEid)>
				</cfif>
				<cfset LvarGEidsVerificacionesPerMes = listAppend(LvarGEidsVerificaciones, "#LvarGEid#|#per#|#mes#")>

				<cfquery name="rsEmpresas" datasource="#Arguments.DataSource#">
					select e.Ecodigo, m.Mcodigo, m.Miso4217, e.Edescripcion
					  from AnexoGEmpresaDet ge
						inner join Empresas e
								inner join Monedas m
								   on m.Mcodigo = e.Mcodigo
						   on e.Ecodigo = ge.Ecodigo
					 where GEid = #LvarGEid#
					   and m.Miso4217 <> '#LvarMiso4217_Conversion#'
				</cfquery>
				
				<cfloop query="rsEmpresas">
					<cfif LvarVerificarGEid>
						<cfquery name="rsSQL" datasource="#Arguments.DataSource#">
							select m.Miso4217
							from Parametros p
								inner join Monedas m
									on m.Mcodigo = <cf_dbfunction name="to_number" args="p.Pvalor">
							where p.Pcodigo = 660
							and p.Ecodigo = #rsEmpresas.Ecodigo#
						</cfquery>
						
						<cfif rsSQL.Miso4217 NEQ LvarMiso4217_Conversion>
							<cfthrow message="La empresa #rsEmpresas.Edescripcion#, tiene una moneda de Conversi&oacute;n de Estados Financieros '#rsSQL.Miso4217#' diferente a #LvarMiso4217_Conversion#">
						</cfif>
					</cfif>
									
					<cfquery name="rsSQL" datasource="#Arguments.DataSource#">
						select count(1) as cantidad
						 from SaldosContablesConvertidos scc
						  inner join Monedas m
							on m.Mcodigo = scc.Mcodigo
						   and m.Ecodigo = scc.Ecodigo
						where scc.Ecodigo  = #rsEmpresas.Ecodigo#
						  and scc.Speriodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#per#">
						  and scc.Smes     = <cfqueryparam cfsqltype="cf_sql_integer" value="#mes#">
						  and m.Miso4217   = '#LvarMiso4217_Conversion#'
					</cfquery>
					<cfif rsSQL.cantidad eq 0>
						<cfthrow message="La empresa #rsEmpresas.Edescripcion#, no se le ha realizado el proceso de Conversi&oacute;n de Estados Financieros para el Periodo: #per# y Mes: #mes#">
					</cfif>
				</cfloop>
			</cfif>

			<cfif concepto EQ 1>
				<!--- Empresa --->
				<cfquery name="Empresa" DataSource="#Arguments.DataSource#">
					<cfif LvarGEid NEQ "-1">
						select GEnombre as Edescripcion 
						  from AnexoGEmpresa 
						 where GEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarGEid#">
					<cfelse>
						select Edescripcion 
						  from Empresas 
						 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarEcodigo#">
					</cfif>
				</cfquery>
				<cfset valor = Trim(Empresa.Edescripcion)>
			<cfelseif concepto EQ 2>
				<!--- Oficina --->
				<cfif LvarOcodigo EQ "-1" AND LvarGOid EQ "-1">
					<cfset valor = "** No se puede definir el Concepto='Nombre Oficina' con Origen<>'Oficina o Grupo Oficinas' **">
				<cfelse>
					<cfquery name="Oficinas" DataSource="#Arguments.DataSource#">
						<cfif LvarGOid NEQ "-1">
							select GOnombre as Odescripcion 
							  from AnexoGOficina
							 where GOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarGOid#">
						<cfelse>
							select Odescripcion 
							  from Oficinas 
							 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarEcodigo#">
							   and Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarOcodigo#">
						</cfif>
					</cfquery>
					<cfif Oficinas.recordCount GT 0>
						<cfset valor = trim(Oficinas.Odescripcion)>
					<cfelse>
						<cfset valor = "** Oficina no existe en la Empresa **">
					</cfif>
				</cfif>
			<cfelseif concepto EQ 3>
				<!--- variable de entrada --->
				<cfif AVid eq "">
					<cfset valor = "**FALTA VARIABLE**">
				<cfelse>
					<cfquery name="rsAVvariable" DataSource="#Arguments.DataSource#">
						select v.AVtipo, v.AVvalor_anual, v.AVvalor_arrastrar
						  from AnexoVar v
						 where v.AVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#AVid#">
					</cfquery>
					<cfquery name="rsAVvalor" DataSource="#Arguments.DataSource#">
						select vv.AVvalor
						  from AnexoVarValor vv
						 where vv.AVid = <cfqueryparam cfsqltype="cf_sql_numeric"		value="#AVid#">
						   and vv.AVano = <cfqueryparam cfsqltype="cf_sql_integer"		value="#per#">
						   and vv.AVmes = 
						   		<cfif rsAVvariable.AVvalor_anual EQ "1">
											1
								<cfelse>
											<cfqueryparam cfsqltype="cf_sql_integer" value="#mes#">
								</cfif>
						<cfif LvarGEid NEQ -1>
						   and vv.Ecodigo = -1
						<cfelse>
						   and vv.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer"	value="#LvarEcodigo#"> 
						</cfif>
						   and vv.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer"	value="#LvarOcodigo#">
						   and vv.GOid = <cfqueryparam cfsqltype="cf_sql_numeric"		value="#LvarGOid#">
						   and vv.GEid = <cfqueryparam cfsqltype="cf_sql_numeric"		value="#LvarGEid#">
					</cfquery>
					
					<!--- Si el valor no existe y debe Arrastrar el ultimo valor, obtiene el ultimo valor y lo graba en el mes/año consultado --->
					<cfif rsAVvalor.recordCount EQ 0 AND rsAVvariable.AVvalor_arrastrar EQ "1">
						<cfquery name="rsSQL" DataSource="#Arguments.DataSource#">
							select max(vv.AVano*100 + vv.AVmes) as ultimo
							  from AnexoVarValor vv
							 where vv.AVid = <cfqueryparam cfsqltype="cf_sql_numeric"		value="#AVid#">
							   and  (	vv.AVano = <cfqueryparam cfsqltype="cf_sql_integer"	value="#per#">
									and vv.AVmes < <cfqueryparam cfsqltype="cf_sql_integer" value="#mes#">
									 OR vv.AVano < <cfqueryparam cfsqltype="cf_sql_integer"	value="#per#">
									)
							<cfif LvarGEid NEQ -1>
							   and vv.Ecodigo = -1
							<cfelse>
							   and vv.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer"	value="#LvarEcodigo#"> 
							</cfif>
							   and vv.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer"	value="#LvarOcodigo#">
							   and vv.GOid = <cfqueryparam cfsqltype="cf_sql_numeric"		value="#LvarGOid#">
							   and vv.GEid = <cfqueryparam cfsqltype="cf_sql_numeric"		value="#LvarGEid#">
						</cfquery>
						<cfif rsSQL.ultimo NEQ "">
							<cfset LvarUltimoAno = int(rsSQL.ultimo/100)>
							<cfset LvarUltimoMes = rsSQL.ultimo mod 100>

							<cfquery name="rsAVvalor" DataSource="#Arguments.DataSource#">
								select vv.AVvalor
								  from AnexoVarValor vv
								 where vv.AVid = <cfqueryparam cfsqltype="cf_sql_numeric"	value="#AVid#">
								   and vv.AVano = <cfqueryparam cfsqltype="cf_sql_integer"	value="#LvarUltimoAno#">
								   and vv.AVmes = <cfqueryparam cfsqltype="cf_sql_integer"	value="#LvarUltimoMes#">
								<cfif LvarGEid NEQ -1>
								   and vv.Ecodigo = -1
								<cfelse>
								   and vv.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer"	value="#LvarEcodigo#"> 
								</cfif>
								   and vv.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer"	value="#LvarOcodigo#">
								   and vv.GOid = <cfqueryparam cfsqltype="cf_sql_numeric"		value="#LvarGOid#">
								   and vv.GEid = <cfqueryparam cfsqltype="cf_sql_numeric"		value="#LvarGEid#">
							</cfquery>
							<cfquery DataSource="#Arguments.DataSource#">
								insert into AnexoVarValor
									(AVid, AVano, AVmes, Ecodigo, Ocodigo, GOid, GEid, BMfecha, BMUsucodigo, AVvalor)
								values (
										<cfqueryparam cfsqltype="cf_sql_numeric"		value="#AVid#">
									,	<cfqueryparam cfsqltype="cf_sql_integer"		value="#per#">
						   		<cfif rsAVvariable.AVvalor_anual EQ "1">
									,	1
								<cfelse>
									,	<cfqueryparam cfsqltype="cf_sql_integer"		value="#mes#">
								</cfif>
								<cfif LvarGEid NEQ -1>
									,	-1
								<cfelse>
									,	<cfqueryparam cfsqltype="cf_sql_integer"		value="#LvarEcodigo#"> 
								</cfif>
									,	<cfqueryparam cfsqltype="cf_sql_integer"		value="#LvarOcodigo#">
									,	<cfqueryparam cfsqltype="cf_sql_numeric"		value="#LvarGOid#">
									,	<cfqueryparam cfsqltype="cf_sql_numeric"		value="#LvarGEid#">
									,	<cfqueryparam cfsqltype="cf_sql_timestamp"		value="#now()#">
									,	<cfqueryparam cfsqltype="cf_sql_numeric"		value="#session.Usucodigo#">

									,	<cfqueryparam cfsqltype="cf_sql_varchar"		value="#rsAVvalor.AVvalor#">
									)
							</cfquery>
						</cfif>
					</cfif>

					<cfif rsAVvalor.recordCount EQ 0>
						<cfset valor = "**VACIO**">
					<cfelseif rsAVvariable.AVtipo EQ "M">
						<cfset valor = fnExpresarValor (rsAVvalor.AVvalor,rsAnexoCalculo.ACunidad)>
						<cfset ResultadoCalculo.Tipo = "M">
					<cfelse>
						<cfset valor = rsAVvalor.AVvalor>
					</cfif>
				</cfif>
			<cfelseif Concepto EQ 4>
				<cfset LvarNombreMoneda = "">
				<!---
				<cfif LvarACsaldos.TipoSaldo EQ 2> 
					<cfset LvarNombreMoneda = "Multimoneda">
				<cfelseif LvarACsaldos.Mcodigo EQ -1>
					<cfif LvarACsaldos.TipoSaldo EQ 0>
						<cfquery name="rsSQL" DataSource="#Arguments.DataSource#">
							select m.Mnombre
							  from Empresas e
								inner join Monedas m
								   on m.Mcodigo = e.Mcodigo
							 where e.Ecodigo = #session.Ecodigo#
						</cfquery>
						<cfset LvarNombreMoneda = "LOCAL - #rsSQL.Mnombre#">
					<cfelseif LvarACsaldos.TipoSaldo EQ 1>
						<cfquery name="rsSQL" DataSource="#Arguments.DataSource#">
							select m.Mnombre
							  from Parametros p
								inner join Monedas m
									on m.Mcodigo = <cf_dbfunction name="to_number" args="p.Pvalor">
							 where p.Ecodigo = #session.Ecodigo#
							   and p.Pcodigo = 660
						</cfquery>
						<cfset LvarNombreMoneda = "CONVERSION - #rsSQL.Mnombre#">
					<cfelseif LvarACsaldos.TipoSaldo EQ 3>
						<cfset LvarNombreMoneda = "B15 FUNCIONAL - #???#">
					<cfelseif LvarACsaldos.TipoSaldo EQ 4>
						<cfset LvarNombreMoneda = "B15 EXPRESION - #???#">
				<cfelse>
					<cfquery name="rsSQL" DataSource="#Arguments.DataSource#">
						select Mnombre
						  from Monedas
						 where Mcodigo = #LvarACsaldos.Mnombre#
					</cfquery>
					<cfset LvarNombreMoneda = rsSQL.Miso4217>
				</cfif>
				--->				
				<cfif LvarACsaldos.Mcodigo EQ -1 and LvarEcodigo NEQ "*" and LvarEcodigo GT 0>
					<cfquery name="rsNomMoneda" DataSource="#Arguments.DataSource#">
						select Mnombre
						from Empresas e
							inner join Monedas m
							on m.Mcodigo = e.Mcodigo
						where e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric"	value="#LvarEcodigo#">
					</cfquery>
					<cfif rsNomMoneda.recordcount GT 0>
						<cfset LvarNombreMoneda = rsNomMoneda.Mnombre>
					</cfif>
				<cfelseif NOT (LvarACsaldos.Mcodigo EQ -1 or LvarACsaldos.ACmLocal EQ "1")>
					<cfquery name="rsNomMoneda" DataSource="#Arguments.DataSource#">
						select Mnombre
						from Monedas m
						where m.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric"	value="#LvarACsaldos.Mcodigo#">
					</cfquery>
					<cfif rsNomMoneda.recordcount GT 0>
						<cfset LvarNombreMoneda = rsNomMoneda.Mnombre>
					</cfif>
				</cfif>
				<cfif len(LvarNombreMoneda) GT 1>
					<cfif rsAnexoCalculo.ACunidad EQ "1000000">
						<cfset valor = "(Millones de " & trim(LvarNombreMoneda) & ")">
					<cfelseif rsAnexoCalculo.ACunidad EQ "1000">
						<cfset valor = "(Miles de " & trim(LvarNombreMoneda) & ")">
					<cfelse>
						<cfset rsAnexoCalculo.ACunidad = "1">
						<cfset valor = "(Movimientos en " & trim(LvarNombreMoneda) & ")">
					</cfif>
				<cfelse>
					<cfif rsAnexoCalculo.ACunidad EQ "1000000">
						<cfset valor = "(Millones)">
					<cfelseif rsAnexoCalculo.ACunidad EQ "1000">
						<cfset valor = "(Miles)">
					<cfelse>
						<cfset rsAnexoCalculo.ACunidad = "1">
						<cfset valor = "">
					</cfif>
				</cfif> 

			<cfelseif Concepto EQ 10>
				<!--- Número de Mes seleccionado en la celda--->
				<cfset valor = NumberFormat(Mes,"00")>
			<cfelseif Concepto EQ 11>
				<!--- Nombre del Mes seleccionado en la celda--->
				<cfif LvarGEid NEQ -1>
					<cfset LvarEcodigo = rsAnexoCalculo.EcodigoAnexoDueno>
				</cfif>
				<cfset valor = fnNombreMes(LvarEcodigo, Arguments.DataSource, Mes)>
			<cfelseif Concepto EQ 12>
				<!--- Número el Año seleccionado en la celda--->
				<cfset valor = Trim(Per)>
			<cfelseif Concepto EQ 13>
				<!--- MM / YYYY: Numero del mes / Numero del año seleccionado de la celda --->
				<cfset valor = "#NumberFormat(Mes,"00")# / #Per#">
			<cfelseif Concepto EQ 14>
				<!--- Leyenda de Fin de Mes --->
				<cfif LvarGEid NEQ -1>
					<cfset LvarEcodigo = rsAnexoCalculo.EcodigoAnexoDueno>
				</cfif>
				<cfset valor = "Al #DaysInMonth(CreateDate(Per, Mes, 1))# de #fnNombreMes(LvarEcodigo, Arguments.DataSource, Mes)# de #Per#" >
			<cfelseif Concepto EQ 15>
				<!--- Nombre Corto del Mes seleccionado en la celda--->
				<cfif LvarGEid NEQ -1>
					<cfset LvarEcodigo = rsAnexoCalculo.EcodigoAnexoDueno>
				</cfif>
				<cfset valor = ucase(mid(fnNombreMes(LvarEcodigo, Arguments.DataSource, Mes),1,3))>
			<cfelseif Concepto EQ 16>
				<!--- MMM / YYYY: Nombre del mes / Numero del año seleccionado de la celda --->
				<cfif LvarGEid NEQ -1>
					<cfset LvarEcodigo = rsAnexoCalculo.EcodigoAnexoDueno>
				</cfif>
				<cfset valor = "#ucase(mid(fnNombreMes(LvarEcodigo, Arguments.DataSource, Mes),1,3))# / #Per#">
			<cfelseif Concepto EQ 17>
				<!--- YYYY-MM: Numero del mes / Numero del año seleccionado de la celda --->
				<cfset valor = "#Per#-#NumberFormat(Mes,"00")#">
			<cfelseif Concepto EQ 18>
				<!--- Leyenda del Inicio período al Fin de Mes --->
				<cfset LvarPer = fnPeriodo (Arguments.DataSource)>
				<cfset MesInicial	= LvarPer.MesInicial>
				<cfset PerInicial	= LvarPer.PerInicial>

				<cfif LvarGEid NEQ -1>
					<cfset LvarEcodigo = rsAnexoCalculo.EcodigoAnexoDueno>
				</cfif>
				<cfif PerInicial EQ per>
					<cfset valor = "Del 1 de #fnNombreMes(LvarEcodigo, Arguments.DataSource, MesInicial)# al #DaysInMonth(CreateDate(Per, Mes, 1))# de #fnNombreMes(LvarEcodigo, Arguments.DataSource, Mes)# de #Per#">
				<cfelse>
					<cfset valor = "Del 1 de #fnNombreMes(LvarEcodigo, Arguments.DataSource, MesInicial)# de #PerInicial# al #DaysInMonth(CreateDate(Per, Mes, 1))# de #fnNombreMes(LvarEcodigo, Arguments.DataSource, Mes)# de #Per#">
				</cfif>

			<cfelseif Concepto EQ 25>
				<!--- Flujo Efectivo --->
				<cfset valor = fnCalcularFlujoEfectivo(Arguments.DataSource)>
				<cfset ResultadoCalculo.Tipo = "M">

			<cfelseif concepto GTE 20 and concepto LTE 35>
				<!--- Operaciones con Cuentas para el periodo de tiempo del año --->
				<cfquery name="rsVerificaConceptosCelda" datasource="#Arguments.DataSource#">
					select count(1) as CantidadConceptos
					from AnexoCelConcepto
					where AnexoCelId = #rsRangos.AnexoCelId#
					  <cfif LvarGEid EQ "-1">
						  and Ecodigo = #LvarEcodigo#
					  </cfif>
				</cfquery>

				<cfif concepto GTE 22 and rsVerificaConceptosCelda.CantidadConceptos GT 0>
					<cfif  LvarSaldosConvertidos>
						<cfthrow message="No se permite filtrar por concepto con Saldos Convertidos">
					</cfif>
					<cfset valor = fnCalcularContabilidadMovs(Arguments.DataSource)>
				<cfelse>
					<cfset valor = fnCalcularContabilidad(Arguments.DataSource, "SaldosContablesConvertidos")>
				</cfif>
				<cfset ResultadoCalculo.Tipo = "M">
			<cfelseif concepto GTE 50 and concepto LTE 59>
				<!--- Control de Presupuesto --->
				<cfset valor = fnCalcularControlPresupuesto(Arguments.DataSource)>
				<cfset ResultadoCalculo.Tipo = "M">

			<cfelseif concepto GTE 60 and concepto LTE 69>
				<!--- Control de Presupuesto --->
				<cfset valor = fnCalcularFormulacionPresupuesto(Arguments.DataSource)>
				<cfset ResultadoCalculo.Tipo = "M">
			</cfif>
			<!--- inserta en AnexoCalculoRango --->
			<cfquery DataSource="#Arguments.DataSource#">
				insert into AnexoCalculoRango(
					ACid, AnexoCelId, AnexoId, ACvalor, BMfecha, BMUsucodigo)
				values(
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#ACid#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRangos.AnexoCelId#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRangos.AnexoId#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#valor#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,

					<cfif IsDefined('session.Usucodigo')>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
					<cfelse> 
						0
					</cfif> 
					)
			</cfquery>

			<cfif Arguments.AnexoCelId NEQ "-1">
				<cfset ResultadoCalculo.Valor = valor>
				<cfreturn "termino">
			</cfif>
		</cfloop>
	
		<!--- obonilla66: Cambia el estado dependiendo si se calcula en el Servidor o en Excel --->
		<!--- obonilla66: Se elimina el Campo XML y por tanto el Cálculo en el Servidor --->
		<cfif Arguments.ACactualizarEn EQ "S">
			<cfset rellenarXML(Arguments.DataSource, rsAnexoCalculo.AnexoId, ACid)>
			<cfset hora_de_final = GetTickCount()>
			<cfquery  DataSource="#Arguments.DataSource#">
				update AnexoCalculo
				   set ACstatus = 'T',
					   ACduracion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#hora_de_final-hora_de_inicio#">
				 where ACid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ACid#">
			</cfquery>
			<cfset distribuir(Arguments.DataSource, rsAnexoCalculo.AnexoId, ACid)>
		<cfelse>
			<cfset hora_de_final = GetTickCount()>
			<cfquery  DataSource="#Arguments.DataSource#">
				update AnexoCalculo
				   set ACstatus = 'F',
					   ACduracion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#hora_de_final-hora_de_inicio#">
				 where ACid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ACid#">
			</cfquery>
		</cfif>

		<cfreturn "termino">

	</cffunction>
	<!--- ======================================================================================== --->

  	<cffunction name="fnProcesarTablasTemporales" output="false" access="private">
		<cfargument name="DataSource" required="yes">
		<cfargument name="tipocuenta" required="yes">


		<!---  Borrar los registros que ya existan en las tablas temporales --->
		<cfquery datasource="#Arguments.DataSource#">
			delete from #tmpCeldasCfmts#
		</cfquery>
		<cfquery datasource="#Arguments.DataSource#">
			delete from #tmpCeldasCtas#
		</cfquery>

		<!--- Insertar los Formatos de la Celda para cada Origen de datos: 
			GEid:		AnexoGEmpresaDet.Ecodigo
			GOid:		AnexoGOficinaDet.Ecodigo + AnexoGOficinaDet.Ocodigo
			Ocodigo:	#Ecodigo# + #Ocodigo#
			Ecodigo:	#Ecodigo#
		--->
		<cfquery DataSource="#Arguments.DataSource#">
			insert into #tmpCeldasCfmts# 
				(
					AnexoCelId, 
					Ecodigo, Ocodigo, Mcodigo,
					Cmayor, AnexoCelFmt, 
					AnexoSigno, Anexolk, AnexoCelMov, PCDcatid
				)
			select 
					#LvarAnexoCelId#, 
				<cfif LvarGEid NEQ "-1">   
					ge.Ecodigo, <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="null">,<!---Ocodigo no puede ser NULO, compatibilidad db2--->
						<cfif LvarACsaldos.Mcodigo NEQ -1 and concepto LT 40>
							(
								select mm.Mcodigo 
								  from Monedas mm
								 where mm.Ecodigo	=  ge.Ecodigo 
								   and mm.Miso4217	= '#LvarGEmonedaCalculo#'
							)
						<cfelse>
							-1
						</cfif>,
				<cfelseif LvarGOid NEQ "-1">
					go.Ecodigo, go.Ocodigo, #LvarACsaldos.Mcodigo#,
				<cfelse>
					#LvarEcodigo#, #LvarOcodigo#, #LvarACsaldos.Mcodigo#,
				</cfif>
					d.Cmayor, d.AnexoCelFmt, d.AnexoSigno, 
			<cfif LvarANHid EQ "">
					d.Anexolk, d.AnexoCelMov, PCDcatid
			  from AnexoCelD d
			<cfelse>
					1, 'S', <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null"> <!---PCDcatid no puede ser NULO, compatibilidad db2--->  
			  from ANhomologacionFmts d
			</cfif>
				<cfif LvarGEid NEQ -1>
					inner join AnexoGEmpresaDet ge 
					   on ge.GEid = #LvarGEid#
				<cfelseif LvarGOid NEQ "-1">
					inner join AnexoGOficinaDet go 
					   on go.GOid = #LvarGOid#
				</cfif>
			<cfif LvarANHid EQ "">
			 where d.AnexoCelId = #LvarAnexoCelId#
			<cfelse>
			 where d.ANHCid = #LvarANHCid#
			</cfif>
		</cfquery>

		<!-------------------------------------------------------
			AJUSTA LA MASCARA FINANCIERA A CONTABLE O PRESUPUESTO
		--------------------------------------------------------->
		<cfset LvarFormatoPresupuesto = (arguments.tipocuenta EQ "Presupuesto") OR (arguments.tipocuenta EQ "Formulacion")>
		<cfset LvarFormatoFinanciero = (arguments.tipocuenta EQ "Financiero")>
		<cfif NOT LvarFormatoFinanciero>
			<cftry>
				<cfquery name="rsSQL" DataSource="#Arguments.DataSource#">
					select distinct c.Ecodigo, c.Cmayor, m.PCEMid, m.PCEMformato, m.PCEMformatoC, m.PCEMformatoP
					  from #tmpCeldasCfmts#  c
						left join CPVigencia v
							left join PCEMascaras m
								on m.PCEMid = v.PCEMid
						 on v.Ecodigo	= c.Ecodigo
						and v.Cmayor	= c.Cmayor
						and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CREATEDATE(per,mes,1)#"> between CPVdesde and CPVhasta
					where c.AnexoCelId = #LvarAnexoCelId#
					<cfif LvarFormatoPresupuesto>
					  and m.PCEMformato <> m.PCEMformatoP
					<cfelse>
					  and m.PCEMformato <> m.PCEMformatoC
					</cfif>
				</cfquery>
			<cfcatch type="any">
				<cfthrow message="AnexoCelId = #LvarAnexoCelId#, Rango = #AnexoRan#: #cfcatch.Message# #cfcatch.Detail#">
			</cfcatch>
			</cftry>
			<cfloop query="rsSQL">
				<cfset LvarEcodigo	= rsSQL.Ecodigo>
				<cfset LvarCmayor	= rsSQL.Cmayor>
				<cfquery name="rsNiv" DataSource="#Arguments.DataSource#">
					select PCNlongitud, PCNcontabilidad, PCNpresupuesto
					  from PCNivelMascara n
					where PCEMid = #rsSQL.PCEMid#
					order by PCNid
				</cfquery>
				<cf_dbfunction name="string_part" args="AnexoCelFmt;1;4" returnvariable="LvarSubstituir" delimiters=";">
				<cfset LvarPto=5>
				<cfloop query="rsNiv">
					<cf_dbfunction name="string_part" args="AnexoCelFmt;#LvarPto#;#rsNiv.PCNlongitud+1#" returnvariable="LvarSubstr" delimiters=";">
					<cfif LvarFormatoPresupuesto>
						<cfif rsNiv.PCNpresupuesto EQ 1>
							<cf_dbfunction name="concat" args="#LvarSubstituir#;#LvarSubstr#" returnvariable="LvarSubstituir" delimiters=";">
						</cfif>
					<cfelse>
						<cfif rsNiv.PCNcontabilidad EQ 1>
							<cf_dbfunction name="concat" args="#LvarSubstituir#;#LvarSubstr#" returnvariable="LvarSubstituir" delimiters=";">
						</cfif>
					</cfif>
					<cfset LvarPto=LvarPto+rsNiv.PCNlongitud+1>
				</cfloop>
				<cf_dbfunction name="string_find" args="AnexoCelFmt,'%'" returnvariable="LvarFind">
				<cfset LvarFind = "case when #LvarFind# > 0 then '%' else rtrim(' ') end">
				<cf_dbfunction name="concat" args="#LvarSubstituir#;#LvarFind#" returnvariable="LvarSubstituir" delimiters=";">			
				<cf_dbfunction name="sreplace" args="#LvarSubstituir#;'%%';'%'" returnvariable="LvarSubstituir" delimiters=";">
				<cfquery name="rsNiv" DataSource="#Arguments.DataSource#">
					update #tmpCeldasCfmts#
					   set AnexoCelFmt = #preservesinglequotes(LvarSubstituir)#
					 where Ecodigo	= #LvarEcodigo#
					   and Cmayor	= '#Cmayor#'
				</cfquery>
			</cfloop>
		</cfif>
		
		<!--------------------
			PROCESA EL Anexolk
		--------------------->
		
		<!--- Buscar Cuentas para Anexolk = 1 y UltimoNivel : c.formato like d.AnexoCelFmt + '%' AND c.movimiento = 'S' --->
		<cftransaction isolation="read_uncommitted">
			<cfquery DataSource="#Arguments.DataSource#">
				insert into #tmpCeldasCtas# 
					(
						AnexoCelId, 
						Ecodigo, Ocodigo, Mcodigo,
						Speriodo, Smes,
						cuentaID,
						AnexoSigno
						<cfif arguments.tipocuenta EQ "Formulacion">
							,CVid
						</cfif>
					)
				select 	DISTINCT
						d.AnexoCelId, 
						d.Ecodigo, d.Ocodigo, d.Mcodigo,
						#per#,   #mes#,   
						<cfif Arguments.tipoCuenta EQ "Presupuesto">
							c.CPcuenta
						<cfelseif arguments.tipocuenta EQ "Formulacion">
							c.CVPcuenta
						<cfelseif arguments.tipocuenta EQ "Financiero">
							c.CFcuenta
						<cfelse>
							c.Ccuenta
						</cfif>, 
						d.AnexoSigno
						<cfif arguments.tipocuenta EQ "Formulacion">
							,c.CVid
						</cfif>
				  from #tmpCeldasCfmts# d
				<cfif arguments.tipocuenta EQ "Presupuesto">
					inner join CPresupuesto c
						inner join CPVigencia v
						 on v.Ecodigo	= c.Ecodigo
						and v.Cmayor	= c.Cmayor
						and v.CPVid		= c.CPVid
						and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CREATEDATE(per,mes,1)#"> between CPVdesde and CPVhasta
					 on c.Ecodigo  = d.Ecodigo
					and c.Cmayor   = d.Cmayor
					and c.CPmovimiento = 'S'
					and <cf_dbfunction name="like" args="c.CPformato , d.AnexoCelFmt">
				<cfelseif arguments.tipocuenta EQ "Formulacion">
					inner join CVPresupuesto c
						inner join ANformulacionVersion f
							inner join CPresupuestoPeriodo p
							 on p.CPPid	= f.CPPid
							and #per*100+mes# between p.CPPanoMesDesde and p.CPPanoMesHasta
						and f.ANFid = #LvarANFid#
						 on f.CVid 	= c.CVid
					 on c.Ecodigo   = d.Ecodigo
					and <cf_dbfunction name="like" args="c.CPformato , d.AnexoCelFmt">
					and c.CVid	= 
						(
							select max(CVid)
							  from CVPresupuesto
							 where Ecodigo		= c.Ecodigo
							   and CVid			= f.CVid
							   and Cmayor		= c.Cmayor
							   and CPformato	= c.CPformato
						)
				<cfelseif arguments.tipocuenta EQ "Financiero">
					inner join CFinanciera c
					 on <cf_dbfunction name="like" args="c.CFformato , d.AnexoCelFmt">
					and c.CFformato 	<> c.Cmayor
					and c.Ecodigo  		= d.Ecodigo
					and c.Cmayor		= d.Cmayor
					and c.CFmovimiento 	= 'S'
				<cfelse>
					inner join CContables c
					 on c.Cmayor 		=  d.Cmayor
					and c.Cmovimiento 	= 'S'
					and c.Ecodigo  		= d.Ecodigo
					and <cf_dbfunction name="like" args="c.Cformato , d.AnexoCelFmt">
					and c.Cformato 		<> c.Cmayor
				</cfif>
				 where d.AnexoCelId  = #LvarAnexoCelId#
				   and d.Anexolk     = 1
				   and d.AnexoCelMov <> 'N'
			</cfquery>
		</cftransaction>

		<!--- 
				Se tiene el control de que cuando son Conceptos de Control de Presupuesto o Formulación o flujo Efectivo
				solo procesen Cuentas de Ultimo Nivel
				siempre termina con %
				por tanto, siempre anexolk = 1
		 --->
		<cfif LvarFormatoPresupuesto OR LvarFormatoFinanciero>
			<cftransaction isolation="read_uncommitted">
				<cfquery name="rsSQL" DataSource="#Arguments.DataSource#">
					select count(1) as cantidad
					  from #tmpCeldasCfmts# d
					 where d.AnexoCelId  = #LvarAnexoCelId#
					   and (d.AnexoCelMov = 'N' or d.Anexolk <> 1)
				</cfquery>
			</cftransaction>
			<cfif LvarFormatoFinanciero AND rsSQL.cantidad GT 0>
				<cfthrow message="No se permite procesar Cuentas para Flujo de Efectivo que no sean a último nivel, Rango: #AnexoRan#">
			</cfif>
			<cfif rsSQL.cantidad GT 0>
				<cfthrow message="No se permite procesar Cuentas de Presupuesto que no sean a último nivel, Rango: #AnexoRan#">
			</cfif>
		<cfelse>
			<!--- Buscar Ccuentas para Anexolk = 0 : c.Cformato = d.AnexoCelFmt --->
			<cftransaction isolation="read_uncommitted">
				<cfquery DataSource="#Arguments.DataSource#">
					insert into #tmpCeldasCtas# 
						(
							AnexoCelId, 
							Ecodigo, Ocodigo, Mcodigo,
							Speriodo, Smes,
							cuentaID,
							AnexoSigno
						)
					select 	DISTINCT
							d.AnexoCelId, 
							d.Ecodigo, d.Ocodigo, d.Mcodigo,
							#per#,   #mes#,   
							c.Ccuenta, 
							d.AnexoSigno
					  from #tmpCeldasCfmts# d
						inner join CContables c
						 on c.Ecodigo  = d.Ecodigo
						and c.Cformato = d.AnexoCelFmt
					 where d.AnexoCelId = #LvarAnexoCelId#
					   and d.Anexolk    = 0
				</cfquery>
			</cftransaction>
	
			<!--- Buscar Ccuentas para Anexolk = 1 : c.Cformato like d.AnexoCelFmt --->
			<!--- AnexoCelMov = 'N' implica que es de contabilidad --->
			<cftransaction isolation="read_uncommitted">
				<cfquery DataSource="#Arguments.DataSource#">
					insert into #tmpCeldasCtas# 
						(
							AnexoCelId, 
							Ecodigo, Ocodigo, Mcodigo,
							Speriodo, Smes,
							cuentaID,
							AnexoSigno
						)
					select 	DISTINCT
							d.AnexoCelId, 
							d.Ecodigo, d.Ocodigo, d.Mcodigo,
							#per#,   #mes#,   
							c.Ccuenta, 
							d.AnexoSigno
					  from #tmpCeldasCfmts# d
						inner join CContables c
						 on c.Ecodigo  = d.Ecodigo
						and <cf_dbfunction name="like" args="c.Cformato , d.AnexoCelFmt">
					 where d.AnexoCelId  = #LvarAnexoCelId#
					   and d.Anexolk     = 1
					   and d.AnexoCelMov = 'N'
				</cfquery>
			</cftransaction>
	
	
			<!--- Buscar Ccuentas para Anexolk = 2 : c.Cformato like d.AnexoCelFmt por PCDcatid --->
			<!--- AnexoCelMov = 'N' implica que es de contabilidad --->
			<cftransaction isolation="read_uncommitted">
				<cfquery DataSource="#Arguments.DataSource#">
					insert into #tmpCeldasCtas# 
						(
							AnexoCelId, 
							Ecodigo, Ocodigo, Mcodigo,
							Speriodo, Smes,
							cuentaID,
							AnexoSigno
						)
					select 	DISTINCT
							d.AnexoCelId, 
							d.Ecodigo, d.Ocodigo, d.Mcodigo,
							#per#,   #mes#,   
							c.Ccuenta, 
							d.AnexoSigno
					  from #tmpCeldasCfmts# d
						inner join CContables c
						 on c.PCDcatid 	= d.PCDcatid
						and c.Ecodigo  	= d.Ecodigo
						and <cf_dbfunction name="like" args="c.Cformato , d.AnexoCelFmt">
					 where d.AnexoCelId = #LvarAnexoCelId#
					   and d.Anexolk    = 2
					   and d.AnexoCelMov = 'N'
				</cfquery>
			</cftransaction>
	
			<cftransaction isolation="read_uncommitted">
				<cfquery DataSource="#Arguments.DataSource#">
					insert into #tmpCeldasCtas# 
						(
							AnexoCelId, 
							Ecodigo, Ocodigo, Mcodigo,
							Speriodo, Smes,
							cuentaID,
							AnexoSigno
						)
					select 	DISTINCT
							d.AnexoCelId, 
							d.Ecodigo, d.Ocodigo, d.Mcodigo,
							#per#,   #mes#,   
							c.Ccuenta, 
							d.AnexoSigno
					  from #tmpCeldasCfmts# d
						inner join CContables c
						 on c.PCDcatid 		= d.PCDcatid
						and c.Cmayor 		= d.Cmayor
						and c.Cmovimiento 	= 'S'
						and c.Ecodigo  		= d.Ecodigo
						and <cf_dbfunction name="like" args="c.Cformato , d.AnexoCelFmt">
						and c.Cformato 		<> c.Cmayor
					 where d.AnexoCelId  = #LvarAnexoCelId#
					   and d.Anexolk     = 2
					   and d.AnexoCelMov <> 'N'
				</cfquery>
			</cftransaction>
		</cfif>

		<!--- 
			Conceptos Acumulados del periodo (Excepto Control Presupuesto): 
				debe cargar todos los meses del periodo hasta mes actual 
		--->
		<cfif concepto GTE 32 and concepto LTE 34>
			<cfset sbCargarMesesPer(Arguments.DataSource)>
		</cfif>

		<!--- Cargar las cuentas que aceptan movimientos si se requiere procesar por Asientos ( Conceptos Contables ) en la funcion de obtener los valores --->
		<cfif Arguments.tipocuenta eq "Movimientos">
			<cfquery DataSource="#Arguments.DataSource#">
				insert into #tmpCeldasCtas# 
				(
					AnexoCelId, 
					Ecodigo, Ocodigo, Mcodigo,
					Speriodo, Smes,
					cuentaID,
					AnexoSigno
				)
				select
					t.AnexoCelId, 
					t.Ecodigo, t.Ocodigo, t.Mcodigo,
					t.Speriodo, t.Smes,
					cu.Ccuenta,
					t.AnexoSigno
				from #tmpCeldasCtas# t
					inner join PCDCatalogoCuenta cu
					 on cu.Ccuentaniv = t.cuentaID
				where cu.Ccuenta <> t.cuentaID 
			</cfquery>
		</cfif>

		<cfif concepto GTE 35 AND concepto LTE 39>
			<!--- Verificar que sólo se utilicen cuentas de Resultados o de Utilidad --->
			<cftransaction isolation="read_uncommitted">
			<cfquery name="rsCuentaUtilidad" datasource="#Arguments.DataSource#">
				select distinct Pvalor 
				  from Parametros 
				<cfif LvarGEid NEQ -1>
				 where exists 
						(
							select 1 
							  from AnexoGEmpresaDet ge 
							 where GEid		= #LvarGEid#
							   and Ecodigo	= Parametros.Ecodigo
						)
				<cfelse>
				 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarEcodigo#">
				</cfif>
				   and Pcodigo = 300
			</cfquery>
			<cfif rsCuentaUtilidad.recordcount EQ 0 or len(rsCuentaUtilidad.Pvalor) EQ 0>
				<cfthrow message="No ha definido la Cuenta de Utilidad">
			</cfif>

			<cfquery name="rsSQL" DataSource="#Arguments.DataSource#">
				select distinct c.Cmayor
				  from #tmpCeldasCtas# d
					inner join CContables c
					 on c.Ccuenta  = d.cuentaID
					inner join CtasMayor m
					 on m.Ecodigo = c.Ecodigo
					and m.Cmayor  = c.Cmayor
				 where d.AnexoCelId = #LvarAnexoCelId#
				   and m.Ctipo NOT in ('I','G')
				   and c.Ccuenta not in (#valueList(rsCuentaUtilidad.Pvalor)#)
			</cfquery>
			<cfif rsSQL.recordCount GT 0>
				<cfthrow message="Solo se puede usar Saldos de Cierres con cuentas de Resultado o de Utilidad: Rango: #AnexoRan#, Ctas: #valueList(rsSQL.Cmayor)#">
			</cfif>
			</cftransaction>
		</cfif>
		
	</cffunction>
  
	<!--- 
		Obtiene los meses acumulados del inicio del período al mes actual y
		expande las cuentas que ya se obtuvieron en el mes para los demas meses

		Proceso por eficiencia:
			Si la ultima carga es igual, 
				no la vuelve a hacer
			SINO Si el mes actual está incluido en la ultima carga, 
				Si es acumulado Borra los meses posteriores, sino ya está cargado
			SINO 
				Borra todo y ejecuta la carga 
	 --->
	<cffunction name="sbCargarMesesPer" output="false">
		<cfargument name="DataSource" 	required="yes">
		<cfargument name="Acumulado"	default="true" type="boolean" required="no">

		<cfset var LvarCargar = false>

		<cfif LvarCargarMesesPer.Per*100+LvarCargarMesesPer.Mes NEQ per*100+mes or LvarCargarMesesPer.Acum NEQ Arguments.Acumulado>
			<cfset LvarCargarMesesPer.Per = per>
			<cfset LvarCargarMesesPer.Mes = mes>

			<cfif LvarCargarMesesPer.Acum NEQ Arguments.Acumulado>
				<cfset LvarCargar = true>
				<cfset LvarCargarMesesPer.Acum = Arguments.Acumulado>
			<cfelse>
				<cfquery name="rsMesesPer" DataSource="#Arguments.DataSource#">
					select count(1) as cantidad
					  from #tmpMesesPer#
					 where Speriodo = #per# and Smes = #mes#
				</cfquery>

				<cfif rsMesesPer.cantidad EQ 0>
					<cfset LvarCargar = true>
				<cfelseif Arguments.Acumulado>
					<!--- ACUMULADO: borra los meses posteriores --->
					<cfset LvarCargar = false>
					<cfquery name="rsMesesPer" DataSource="#Arguments.DataSource#">
						delete from #tmpMesesPer#
						 where Speriodo*100+Smes > #per*100+mes#
					</cfquery>
				<cfelse>
					<!--- TOTAL: es igual al anterior --->
					<cfset LvarCargar = false>
				</cfif>
			</cfif>

			<cfif LvarCargar>
				<cfquery name="rsMesesPer" DataSource="#Arguments.DataSource#">
					delete from #tmpMesesPer#
				</cfquery>

				<!--- Cargar la tabla Temporal de Meses si no se ha cargado --->
				<cfset LvarPer = fnPeriodo (Arguments.DataSource)>
				<cfset MesInicial	= LvarPer.MesInicial>
				<cfset PerInicial	= LvarPer.PerInicial>
				<cfset MesFinal		= LvarPer.MesFinal>
				<cfset PerFinal		= LvarPer.PerFinal>

				<cfif Arguments.Acumulado>
					<cfset MesFinal = (per*100)+mes>
				<cfelse>
					<cfset MesFinal = (PerFinal*100)+MesFinal>
				</cfif>

				<cfset LvarMesControl = (PerInicial*100)+MesInicial>
				<cfloop  condition="LvarMesControl LTE MesFinal">
						<cfquery datasource="#Arguments.DataSource#">
							insert into #tmpMesesPer# (Speriodo, Smes)
							values (#PerInicial#, #MesInicial#)
						</cfquery>
		
						<cfset MesInicial = MesInicial + 1>
		
						<cfif MesInicial GT 12>
							<cfset MesInicial = 1>
							<cfset PerInicial = PerInicial + 1>
						</cfif>
						<cfset LvarMesControl = ( PerInicial*100 ) + MesInicial >
				</cfloop> 
			</cfif>
		</cfif>

		<!--- Expande las cuentas para cada mes del periodo --->
		<cfquery datasource="#Arguments.DataSource#">
			insert into #tmpCeldasCtas# 
				( 
					AnexoCelId,   
					Ecodigo, Ocodigo, Mcodigo, 
					Speriodo, Smes,   
					cuentaID,   
					AnexoSigno
				)
			select 
					c.AnexoCelId,   
					c.Ecodigo, c.Ocodigo, c.Mcodigo, 
					m.Speriodo, m.Smes,   
					c.cuentaID,   
					c.AnexoSigno
			  from #tmpCeldasCtas# c, #tmpMesesPer# m
			 where m.Speriodo*100+m.Smes <> #per*100+mes#
		</cfquery>
	</cffunction>

	<cffunction name="fnCalcularContabilidad" output="false" access="private">
		<cfargument name="DataSource" required="yes">
		<cfargument name="TablaSaldos" required="yes">

		<cfset fnProcesarTablasTemporales(Arguments.DataSource, "Totales")>
		<cfset valor = 0 >
		
		<!--- calculo de valores de la celda --->
		<!---
			select round(coalesce(-sum(-1*(monto)) / 1000.00,0.00),2)
			select round(coalesce	(
							-
							sum(-1*(
								monto
							)) / 1000.00,0.00)
					,2)
		--->
		<cfparam name ="LvarB15" default="0">
		<cfif rsRangos.AnexoNeg EQ 1>
			<cfset LvarSigno = "-">
		<cfelse>
			<cfset LvarSigno = "">
		</cfif>
		<cfquery name="rsDatos" DataSource="#Arguments.DataSource#">
			<cfif LvarSaldosConvertidos>
				SELECT coalesce(#LvarSigno# sum( d.AnexoSigno * coalesce(#fnSaldoContabilidad("ss")#, 0) ) , 0.00) as total
			<cfelse>
				SELECT coalesce(#LvarSigno# sum( d.AnexoSigno * (#fnSaldoContabilidad("s")#) ), 0.00) as total
			</cfif>
			FROM #tmpCeldasCtas# d
			<cfif concepto LT 35>
				<cfif LvarB15 NEQ 2>
					INNER JOIN SaldosContables s
					<cfif LvarSaldosConvertidos>
						LEFT JOIN SaldosContablesConvertidos ss
							on ss.Ccuenta		= s.Ccuenta
							and ss.Speriodo	= s.Speriodo
							and ss.Smes		= s.Smes
							and ss.Ecodigo		= s.Ecodigo	
							and ss.Ocodigo		= s.Ocodigo
							and ss.McodigoOri	= s.Mcodigo
							and ss.B15			= #LvarB15#
					</cfif>
				<cfelseif LvarB15 EQ 2>
					INNER JOIN SaldosContablesConvertidos ss
				</cfif>
			<cfelseif concepto LT 40>
				<cfif LvarSaldosConvertidos>
					<cfthrow message="No se puede usar Saldos de Cierres en Anexos Convertidos, Rango: #AnexoRan#">
				</cfif>
				inner join SaldosContablesCierre s
			<cfelse>
				<cfif LvarSaldosConvertidos>
					<cfthrow message="No se puede usar Presupuesto Contable en Anexos Convertidos, Rango: #AnexoRan#">
				</cfif>
				INNER JOIN SaldosContablesP s
			</cfif>
			<cfif LvarSaldosConvertidos and LvarB15 EQ 2>
				<cfset t = 'ss'>
			<cfelse>
				<cfset t = 's'>
			</cfif>
				  on #t#.Ccuenta	= d.cuentaID
				 and #t#.Speriodo = d.Speriodo
				 and #t#.Smes     = d.Smes
				 and #t#.Ecodigo	= d.Ecodigo
				 <cfif LvarSaldosConvertidos and LvarB15 EQ 2>
				 	and ss.B15			= #LvarB15#
				 </cfif>
			<cfif concepto GTE 35 AND concepto LTE 39>
				<cfif LvarGEid EQ -1>
				 and #t#.ECtipo	= 1
				<cfelse>
				 and #t#.ECtipo	= 11
				</cfif>
			</cfif>
			<cfif LvarGOid neq "-1" OR LvarOcodigo neq "-1">
				 and #t#.Ocodigo	= d.Ocodigo
			</cfif>
			<cfif LvarACsaldos.Mcodigo NEQ -1>
				<cfif concepto LT 40>
					and #t#.Mcodigo = d.Mcodigo
				<cfelse>
					and #t#.Mcodigo = -1
				</cfif>
			</cfif>
			where d.AnexoCelId = #rsRangos.AnexoCelId#
		</cfquery>
<!--- <cf_dump var=#rsdatos#> --->
		<cfif isdefined("rsDatos.total") and rsDatos.recordcount GT 0>
			<cfreturn fnExpresarValor (rsDatos.total,rsAnexoCalculo.ACunidad)>
		<cfelse>
			<cfreturn "0.00">
		</cfif>
	</cffunction>
	
	<cffunction name="fnSaldoContabilidad" output="false" access="private" returntype="string">
		<cfargument name="Alias" required="yes">

		<cfif concepto  EQ 40>
			<cfreturn "#Arguments.Alias#.SPinicial">
		<cfelseif concepto  EQ 41>
			<cfreturn "#Arguments.Alias#.MLmonto">
		<cfelseif concepto  EQ 42>
			<cfreturn "#Arguments.Alias#.SPfinal">
		<cfelseif LvarACsaldos.Mcodigo EQ -1 or LvarACsaldos.ACmLocal EQ "1">
			<cfif concepto EQ 20>
				<cfif LvarGEid EQ -1>
					<cfreturn "#Arguments.Alias#.SLinicial + #Arguments.Alias#.DLdebitos - #Arguments.Alias#.CLcreditos">
				<cfelse>
					<cfreturn "#Arguments.Alias#.SLinicialGE + #Arguments.Alias#.DLdebitos - #Arguments.Alias#.CLcreditos">
				</cfif>
			<cfelseif (concepto  EQ 21 OR concepto EQ 35 OR concepto EQ 39)>
				<cfif LvarGEid EQ -1>
					<cfreturn "#Arguments.Alias#.SLinicial">
				<cfelse>
					<cfreturn "#Arguments.Alias#.SLinicialGE">
				</cfif>
			<cfelseif (concepto  EQ 22 or concepto EQ 32 OR concepto EQ 36)>
				<cfreturn "#Arguments.Alias#.DLdebitos">
			<cfelseif (concepto  EQ 23 or concepto EQ 33 OR concepto EQ 37)>
				<cfreturn "#Arguments.Alias#.CLcreditos">
			<cfelseif (concepto  EQ 24 or concepto EQ 34 OR concepto EQ 38)>
				<cfreturn "#Arguments.Alias#.DLdebitos - #Arguments.Alias#.CLcreditos">
			</cfif>
		<cfelse>
			<cfif concepto EQ 20>
				<cfif LvarGEid EQ -1>
					<cfreturn "#Arguments.Alias#.SOinicial + #Arguments.Alias#.DOdebitos - #Arguments.Alias#.COcreditos">
				<cfelse>
					<cfreturn "#Arguments.Alias#.SOinicialGE + #Arguments.Alias#.DOdebitos - #Arguments.Alias#.COcreditos">
				</cfif>
			<cfelseif (concepto  EQ 21 OR concepto EQ 35 OR concepto EQ 39)>
				<cfif LvarGEid EQ -1>
					<cfreturn "#Arguments.Alias#.SOinicial">
				<cfelse>
					<cfreturn "#Arguments.Alias#.SOinicialGE">
				</cfif>
			<cfelseif (concepto  EQ 22 or concepto EQ 32 OR concepto EQ 36)>
				<cfreturn "#Arguments.Alias#.DOdebitos">
			<cfelseif (concepto  EQ 23 or concepto EQ 33 OR concepto EQ 37)>
				<cfreturn "#Arguments.Alias#.COcreditos">
			<cfelseif (concepto  EQ 24 or concepto EQ 34 OR concepto EQ 38)>
				<cfreturn "#Arguments.Alias#.DOdebitos - #Arguments.Alias#.COcreditos">
			</cfif>
		</cfif>
	</cffunction>

  	<cffunction name="fnCalcularContabilidadMovs" output="false" access="private">
		<cfargument name="DataSource" required="yes">

		<!--- 
			Proceso de Calculo del valor de las celdas cuando el concepto está entre 32 y 39
			y Existen Conceptos de Filtro Asociados a la Celda que se procesa
			Es igual que el proceso de calcular el valor de las cuentas
			pero limitado al acceso a la tabla HDContables
		--->

		<cfset fnProcesarTablasTemporales(Arguments.DataSource, "Movimientos")>
		
		<cfset valor = 0 >
		
		<!--- calculo de valores de la celda --->
		<!---
			select round(coalesce(-sum(-1*(monto)) / 1000.00,0.00),2)
			select round(coalesce	(
							-
							sum(-1*(
								monto
							)) / 1000.00,0.00)
					,2)
		--->
		<cftransaction isolation="read_uncommitted">
			<cfquery name="rsDatos" DataSource="#Arguments.DataSource#">
				select coalesce	(
						<cfif rsRangos.AnexoNeg EQ 1>  -  </cfif>
								sum(d.AnexoSigno * (

				<cfif LvarACsaldos.Mcodigo EQ -1 or LvarACsaldos.ACmLocal EQ "1">
					<cfif (concepto  EQ 22 or concepto EQ 32 OR concepto EQ 36) or (concepto  EQ 23 or concepto EQ 33 OR concepto EQ 37)>
						Dlocal
					<cfelse>
						case when Dmovimiento = 'D' then Dlocal else -Dlocal end
					</cfif>
				<cfelse>
					<cfif (concepto  EQ 22 or concepto EQ 32 OR concepto EQ 36) or (concepto  EQ 23 or concepto EQ 33 OR concepto EQ 37)>
						Doriginal
					<cfelse>
						case when Dmovimiento = 'D' then Doriginal else -Doriginal end
					</cfif>
				</cfif>
								)),0.00) as total
				from #tmpCeldasCtas# d
						inner join AnexoCelConcepto con
						 on con.AnexoCelId = d.AnexoCelId
						and con.Ecodigo    = d.Ecodigo

						inner join HDContables s  <cf_dbforceindex name="HDContables_Index1"> 
							 on s.Ccuenta    = d.cuentaID
							and s.Eperiodo   = d.Speriodo
							and s.Emes       = d.Smes
							and s.Ecodigo    = d.Ecodigo
							and s.Ecodigo    = con.Ecodigo
							and s.Cconcepto  = con.Cconcepto
							<cfif LvarGOid neq "-1" OR LvarOcodigo neq "-1">
								 and s.Ocodigo	= d.Ocodigo
							</cfif>
							<cfif LvarACsaldos.Mcodigo NEQ -1 and concepto LT 40>
								 and s.Mcodigo = d.Mcodigo
							</cfif>
									
						<!--- FILTRO DE ASIENTOS --->
						inner join HEContables hec
							on hec.IDcontable = s.IDcontable
						   and hec.ECtipo != 1
						<!--- FILTRO DE ASIENTOS --->
							
				where d.AnexoCelId = #rsRangos.AnexoCelId#
				<cfif (concepto  EQ 22 or concepto EQ 32 OR concepto EQ 36)>
					and s.Dmovimiento = 'D'
				</cfif>
				<cfif (concepto  EQ 23 or concepto EQ 33 OR concepto EQ 37)>
					and s.Dmovimiento = 'C'
				</cfif>
			</cfquery>
		</cftransaction>

		<cfif isdefined("rsDatos.total") and rsDatos.recordcount GT 0>
			<cfreturn fnExpresarValor (rsDatos.total,rsAnexoCalculo.ACunidad)>
		<cfelse>
			<cfreturn "0.00">
		</cfif>
	</cffunction>
  
  	<cffunction name="fnCalcularControlPresupuesto" output="false" access="private">
		<cfargument name="DataSource" required="yes">
		
		<cfset fnProcesarTablasTemporales(Arguments.DataSource, "Presupuesto")>


		<!--- SALDOS DISPONIBLE --->
		<cfset LvarCPtipoSaldo = replace(LvarCPtipoSaldo,"[*PD]","[*PA]-[*PC]","ALL")>

		<!--- SALDOS AUTORIZADOS --->
		<cfset LvarCPtipoSaldo = replace(LvarCPtipoSaldo,"[*PA]","[*PP]+[ME]","ALL")>
		<cfset LvarCPtipoSaldo = replace(LvarCPtipoSaldo,"[*PP]","[*PF]+[T]+[TE]+[VC]","ALL")>
		<cfset LvarCPtipoSaldo = replace(LvarCPtipoSaldo,"[*PF]","[A]+[M]","ALL")>
		<cfset LvarCPtipoSaldo = replace(LvarCPtipoSaldo,"[A]","CPCpresupuestado","ALL")>
		<cfset LvarCPtipoSaldo = replace(LvarCPtipoSaldo,"[M]","CPCmodificado","ALL")>
		<cfset LvarCPtipoSaldo = replace(LvarCPtipoSaldo,"[VC]","CPCvariacion","ALL")>
		<cfset LvarCPtipoSaldo = replace(LvarCPtipoSaldo,"[ME]","CPCmodificacion_Excesos","ALL")>
		<cfset LvarCPtipoSaldo = replace(LvarCPtipoSaldo,"[T]","CPCtrasladado","ALL")>
		<cfset LvarCPtipoSaldo = replace(LvarCPtipoSaldo,"[TE]","CPCtrasladadoE","ALL")>

		<!--- SALDOS CONSUMIDOS --->
		<cfset LvarCPtipoSaldo = replace(LvarCPtipoSaldo,"[*PC]","[*PCA]+[RP]","ALL")>
		<cfset LvarCPtipoSaldo = replace(LvarCPtipoSaldo,"[*PCA]","[RA]+[CA]+[RC]+[CC]+[ET]","ALL")>
		<cfset LvarCPtipoSaldo = replace(LvarCPtipoSaldo,"[RA]","CPCreservado_Anterior","ALL")>
		<cfset LvarCPtipoSaldo = replace(LvarCPtipoSaldo,"[CA]","CPCcomprometido_Anterior","ALL")>
		<cfset LvarCPtipoSaldo = replace(LvarCPtipoSaldo,"[RP]","CPCreservado_Presupuesto","ALL")>
		<cfset LvarCPtipoSaldo = replace(LvarCPtipoSaldo,"[RC]","CPCreservado","ALL")>
		<cfset LvarCPtipoSaldo = replace(LvarCPtipoSaldo,"[CC]","CPCcomprometido","ALL")>
		<cfset LvarCPtipoSaldo = replace(LvarCPtipoSaldo,"[NP]","CPCnrpsPendientes","ALL")>

		<!--- Presupuesto Pagado en Efectivo --->

		<!--- E1=Devengado=Ejecutado no Ejercido ni pagado=	si [EJ]<>0 then ([E]+[E2])-[EJ] else ([E]+[E2])-[P] --->
		<!--- E2=Ejercido=Ejercido no pagado=				si [EJ]<>0 then [EJ]-[P] else 0 --->
		<cfset LvarCPtipoSaldo = replace(LvarCPtipoSaldo,"[E3]","case when [EJ]<>0 then [ET]-[EJ] else [ET]-[P] end","ALL")>
		<cfset LvarCPtipoSaldo = replace(LvarCPtipoSaldo,"[EJ3]","case when [EJ]<>0 then [EJ]-[P] else 0 end","ALL")>

		<cfset LvarCPtipoSaldo = replace(LvarCPtipoSaldo,"[ET]","([E]+[E2])","ALL")>
		<cfset LvarCPtipoSaldo = replace(LvarCPtipoSaldo,"[E]","CPCejecutado","ALL")>
		<cfset LvarCPtipoSaldo = replace(LvarCPtipoSaldo,"[E2]","CPCejecutadoNC","ALL")>
		<cfset LvarCPtipoSaldo = replace(LvarCPtipoSaldo,"[P]","CPCpagado","ALL")>
		<cfset LvarCPtipoSaldo = replace(LvarCPtipoSaldo,"[EJ]","CPCejercido","ALL")>
        <cfset LvarCPtipoSaldo = replace(LvarCPtipoSaldo,"[PA]","CPCPagado_Anterior","ALL")>

		<cfquery name="rsSQL" datasource="#Arguments.DataSource#">
			select coalesce	(
					<cfif rsRangos.AnexoNeg EQ 1>  -  </cfif>
						sum(d.AnexoSigno * (#LvarCPtipoSaldo#))
					,0) as Total
			  from #tmpCeldasCtas# d
				inner join CPresupuestoControl s
					inner join CPresupuestoPeriodo p
						 on p.Ecodigo	= s.Ecodigo
						and p.CPPid 	= s.CPPid
						and #per*100+mes# between p.CPPanoMesDesde and p.CPPanoMesHasta
				   on s.Ecodigo	= d.Ecodigo
				  and s.CPcuenta = d.cuentaID
				<cfif concepto EQ 50>
				  and s.CPCano 	= <cfqueryparam  cfsqltype="cf_sql_numeric" value="#per#">
				  and s.CPCmes 	= <cfqueryparam  cfsqltype="cf_sql_numeric" value="#mes#">
				<cfelseif concepto EQ 51>
				  and s.CPCanoMes <=  <cfqueryparam  cfsqltype="cf_sql_numeric" value="#per*100+mes#">
				</cfif>
				<cfif LvarGOid neq "-1" OR LvarOcodigo neq "-1">
				  and s.Ocodigo	= d.Ocodigo
				</cfif>

				<cfif LvarACsaldos.Mcodigo  NEQ -1>
					 and 1=2	<!--- Se puede consultar CPresupuestoControlMonedas --->
				</cfif>

			where d.AnexoCelId = #rsRangos.AnexoCelId#
		</cfquery>
		<cfset valor = rsSQL.Total>

		<cfreturn fnExpresarValor (valor,rsAnexoCalculo.ACunidad)>
	</cffunction>

  	<cffunction name="fnCalcularFormulacionPresupuesto" output="false" access="private">
		<cfargument name="DataSource" required="yes">
		
		<cfset fnProcesarTablasTemporales(Arguments.DataSource, "Formulacion")>

		<cfset LvarSaldo = "round((CVFMmontoBase + CVFMajusteUsuario + CVFMajusteFinal) * coalesce(CVFMtipoCambio,1),2)">

		<cfquery name="rsSQL" datasource="#Arguments.DataSource#">
			select coalesce	(
					<cfif rsRangos.AnexoNeg EQ 1>  -  </cfif>
						sum(d.AnexoSigno * (#LvarSaldo#))
					,0) as Total
			  from #tmpCeldasCtas# d
				inner join CVFormulacionMonedas s
					inner join ANformulacionVersion afv
						 on afv.ANFid 	= #LvarANFid#
						and afv.CVid	= s.CVid
					inner join CPresupuestoPeriodo p
						 on p.Ecodigo	= afv.Ecodigo
						and p.CPPid 	= afv.CPPid
						and #per*100+mes# between p.CPPanoMesDesde and p.CPPanoMesHasta
				   on s.Ecodigo		= d.Ecodigo
				  and s.CVid		= d.CVid
				<cfif concepto EQ 60>
				  and s.CPCano 	= <cfqueryparam  cfsqltype="cf_sql_numeric" value="#per#">
				  and s.CPCmes 	= <cfqueryparam  cfsqltype="cf_sql_numeric" value="#mes#">
				<cfelseif concepto EQ 61>
				  and s.CPCano*100+s.CPCmes <=  <cfqueryparam  cfsqltype="cf_sql_numeric" value="#per*100+mes#">
				</cfif>
				  and s.CVPcuenta	= d.cuentaID
				<cfif LvarGOid neq "-1" OR LvarOcodigo neq "-1">
				  and s.Ocodigo	= d.Ocodigo
				</cfif>

				<cfif LvarACsaldos.Mcodigo  NEQ -1>
					 and 1=2	<!--- Se puede consultar CPresupuestoControlMonedas --->
				</cfif>

			where d.AnexoCelId = #rsRangos.AnexoCelId#
		</cfquery>
		<cfset valor = rsSQL.Total>

		<cfreturn fnExpresarValor (valor,rsAnexoCalculo.ACunidad)>
	</cffunction>

  	<cffunction name="fnCalcularFlujoEfectivo" output="false" access="private">
		<cfargument name="DataSource" required="yes">
		
		<cfset fnProcesarTablasTemporales(Arguments.DataSource, "Financiero")>

		<cfif LvarSaldosConvertidos>
			<cfthrow message="No se puede usar Flujo de Efectivo en Anexos Convertidos, Rango: #AnexoRan#">
		</cfif>

		<cfquery name="rsSQL" datasource="#Arguments.DataSource#">
			select coalesce	(
					<cfif rsRangos.AnexoNeg EQ 1>  -  </cfif>
						sum(MLmontoDet) 
					,0) as Total
			  from #tmpCeldasCtas# d
				inner join MLibrosDetalle s
				   on s.CFcuenta 	= d.cuentaID
				  and s.MLperiodo	= <cfqueryparam  cfsqltype="cf_sql_numeric" value="#per#">
				  and s.MLmes		= <cfqueryparam  cfsqltype="cf_sql_numeric" value="#mes#">

				<cfif LvarACsaldos.Mcodigo  NEQ -1>
					 and s.Mcodigo=d.Mcodigo	<!--- Se puede consultar CPresupuestoControlMonedas --->
				</cfif>

			where d.AnexoCelId = #rsRangos.AnexoCelId#
		</cfquery>
		<cfset valor = rsSQL.Total>

		<cfreturn fnExpresarValor (valor,rsAnexoCalculo.ACunidad)>
	</cffunction>

	<cffunction name="fnPeriodo" output="false" returntype="struct">
		<cfargument name="DataSource" 	required="yes">

		<cfset var LvarPer = structNew()>
		<cfset var MesInicial	= 0>
		<cfset var PerInicial	= 0>
		<cfset var MesFinal 	= 0>
		<cfset var PerFinal		= 0>

		<cfquery name="rsParametros" DataSource="#Arguments.DataSource#">
			select distinct Pvalor 
			  from Parametros 
			<cfif LvarGEid NEQ -1>
			 where exists 
			 		(
						select 1 
						  from AnexoGEmpresaDet ge 
						 where GEid		= #LvarGEid#
						   and Ecodigo	= Parametros.Ecodigo
				 	)
			<cfelse>
			 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarEcodigo#">
			</cfif>
			   and Pcodigo = 45
		</cfquery>
		<cfif rsParametros.recordCount GT 1>
			<cfquery name="rsSQL" DataSource="#Arguments.DataSource#">
				select GEcodigo, GEnombre
				  from AnexoGEmpresa
				 where GEid = #LvarGEid#
			</cfquery>
			<cf_errorCode	code = "50836"
							msg  = "El grupo de Empresas '@errorDat_1@ - @errorDat_2@' está formado por empresas que tienen diferentes Meses de Cierre Contable. No se puede calcular el anexo."
							errorDat_1="#rsSQL.GEcodigo#"
							errorDat_2="#rsSQL.GEnombre#"
			>
		</cfif>
		
		<cfset MesFinal = rsParametros.Pvalor>
		<cfif MesFinal EQ 12>
			<cfset MesInicial	= 1>
			<cfset PerInicial	= per>
			<cfset PerFinal		= per>
		<cfelseif MesFinal GTE mes>
			<cfset MesInicial	= MesFinal + 1>
			<cfset PerInicial	= per - 1>
			<cfset PerFinal		= per>
		<cfelse>
			<cfset MesInicial	= MesFinal + 1>
			<cfset PerInicial	= per>
			<cfset PerFinal		= per + 1>
		</cfif>

		<cfset LvarPer.MesInicial	= MesInicial>
		<cfset LvarPer.PerInicial	= PerInicial>
		<cfset LvarPer.MesFinal		= MesFinal>
		<cfset LvarPer.PerFinal		= PerFinal>

		<cfreturn LvarPer>
	</cffunction>
	
	<cffunction name="rellenarXML" output="false">
		<cfargument name="DataSource" required="yes">
		<cfargument name="AnexoId" type="numeric" required="yes">
		<cfargument name="ACid" type="numeric" required="yes">

		<cfquery DataSource="#Arguments.DataSource#" name="rsXML">
			select AnexoDef
			from Anexoim
			where AnexoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AnexoId#">
		</cfquery>
		<cfif Len(Trim(rsXML.AnexoDef)) EQ 0>
			<cf_errorCode	code = "50837" msg = "No hay Excel definido para este Anexo">
		</cfif>
		<cfset xmlDoc = XMLParse(rsXML.AnexoDef)>
		<cfquery DataSource="#Arguments.DataSource#" name="rsAnexoCalculoRango">
			select x.AnexoHoja, x.AnexoRan, c.ACvalor
			from AnexoCalculoRango c
				join AnexoCel x
					on x.AnexoCelId = c.AnexoCelId
			where c.AnexoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AnexoId#">
			  and c.ACid    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ACid#">
		</cfquery>

		<!--- Agregar los rangos no definidos en la base de datos --->
		<!---  Names puede aparecer tanto en WorBook (cuando el rango no se repite en varias hojas) como en WorkSheet ---->
		<cfset xmlNamedRanges = XMLSearch(xmlDoc, "//ss:Names/ss:NamedRange")>
		
		<cfloop from="1" to="#ArrayLen(xmlNamedRanges)#" index="i">
			<cfset RangeName = xmlNamedRanges[i].XmlAttributes['ss:Name']>
			<cfset RefersTo  = xmlNamedRanges[i].XmlAttributes['ss:RefersTo']>
			<cfset SheetName = Replace(Replace(ListFirst(RefersTo,"!"),'=',''),"'",'','all')>
			<cfif RangeName neq 'Print_Titles'>
				<cfquery dbtype="query" name="VerSiExiste">
					select 1
					from rsAnexoCalculoRango
					where AnexoHoja = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(SheetName)#">
					  and AnexoRan  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(RangeName)#">
				</cfquery>
	  
				<cfif VerSiExiste.RecordCount EQ 0>
					<cfset QueryAddRow(rsAnexoCalculoRango,1)>
					<cfset QuerySetCell(rsAnexoCalculoRango, "AnexoHoja", SheetName,             rsAnexoCalculoRango.RecordCount)>
					<cfset QuerySetCell(rsAnexoCalculoRango, "AnexoRan",  RangeName,             rsAnexoCalculoRango.RecordCount)>
					<cfset QuerySetCell(rsAnexoCalculoRango, "ACvalor",   "Valor sin definir: " & SheetName & "!" & RangeName, rsAnexoCalculoRango.RecordCount)>
				</cfif>
			</cfif>
		</cfloop>

		<!---
			danim,18-oct-2005,guardar celdas con rangos en un struct
			se espera que esto mejore la eficiencia del ciclo de reemplazo,
			porque tendrá que buscar en un struct en lugar de un xml
		--->
		<cfset DataCells = XMLSearch(xmlDoc, '//ss:Worksheet[@ss:Name]//ss:Cell[ss:NamedCell/@ss:Name]/ss:Data')>
		<cfset cells_struct = StructNew()>
	  
		<cfloop from="1" to="#ArrayLen(DataCells)#" index="i2">
	  		<cfset cell = DataCells[i2]>
			<cfset chld = cell.XmlParent.XmlChildren>
			<cfset NamedCellNode = "">
			<cfloop from="1" to="#ArrayLen(chld)#"  index="ich">
				<cfif ListLast(chld[ich].XmlName,':') is 'NamedCell'>
					<cfset NamedCellNode = chld[ich]>
					<cfbreak>
				</cfif>
			</cfloop>
			<cfif NamedCellNode neq "">
				<cfset AnexoRan = NamedCellNode.XmlAttributes['ss:Name']>
				<cfset AnexoHoja = cell.XmlParent.XmlParent.XmlParent.XmlParent.XmlAttributes['ss:Name']>
				<cfif ListFind('Print_Titles,Print_Area',AnexoRan) EQ 0>
					<cfset StructInsert(cells_struct, Trim(AnexoHoja) & '!' & Trim(AnexoRan), cell, true)>
				</cfif>
			</cfif>
		</cfloop>
	
		<!--- <cfdump var="#rsAnexoCalculoRango#"> --->
		<cfloop query="rsAnexoCalculoRango">
			<cfset AnexoRan = rsAnexoCalculoRango.AnexoRan>
			<cfset AnexoHoja = rsAnexoCalculoRango.AnexoHoja>
			<!---danim,18-oct-2005,
			<cfset cell = XMLSearch(xmlDoc, '//ss:Worksheet[@ss:Name="#Trim(AnexoHoja)#"]//ss:Cell[ss:NamedCell/@ss:Name="#Trim(AnexoRan)#"]/ss:Data')>
			--->
			<!--- danim,18-oct-2005,buscar en el struct en lugar del XML --->
			<cfif StructKeyExists( cells_struct, Trim(AnexoHoja) & '!' & Trim(AnexoRan)) >
				<cfset cell = StructFind( cells_struct, Trim(AnexoHoja) & '!' & Trim(AnexoRan)) >
				<!--- <cfif ArrayLen(cell)> danim,18-oct-2005, --->
				<!---
					Si tenemos un rango calculado que no esta en la hoja de excel, se ignora.
					--->
				<!--- cfdump var="#XMLSearch(xmlDoc, '//ss:Cell[ss:NamedCell/@ss:Name="#Trim(AnexoRan)#"]/ss:Data')#" --->
				<!--- agregado -? --->
				<cfif REFind('^-?([0-9])+(\.[0-9]*)?$', Trim(rsAnexoCalculoRango.ACvalor))>
					<cfset Cell_Type = 'Number'>
				<cfelse>
					<cfset Cell_Type = 'String'>
				</cfif>
				<cfset cell.XMLText = rsAnexoCalculoRango.ACvalor>
				<cfset cell.XMLAttributes['ss:Type'] = Cell_Type>
				<!--- danim,18-oct-2005,ahora no se hace un ciclo porque solamente hay una celda por cada rango en el struct
				<cfloop from="1" to="#ArrayLen(cell)#" index="cell_index">
					<cfset cell[cell_index].XMLText = rsAnexoCalculoRango.ACvalor>
					<cfset cell[cell_index].XMLAttributes['ss:Type'] = Cell_Type>
				</cfloop> --->
				<!--- cfdump var="#XMLSearch(xmlDoc, '//ss:Cell[ss:NamedCell/@ss:Name="#Trim(AnexoRan)#"]/ss:Data')#" --->
			</cfif>
		</cfloop>
		<!---<cfset xml_string = ToString(xmlDoc)>--->
		<cfxml variable="xslIdentity">
		<xsl:stylesheet version="1.0"
							xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
							xmlns="http://www.w3.org/TR/xhtml1/strict"> <xsl:output encoding="ASCII"/> <xsl:template match="node()|@*"> <xsl:copy> <xsl:apply-templates select="@*"/> <xsl:apply-templates/> </xsl:copy> </xsl:template> </xsl:stylesheet>
		</cfxml>
		<cfset xml_string = ToString(XMLTransform(xmlDoc,xslIdentity))>
		<cfset excel_progid = '<?mso-application progid="Excel.Sheet"?>'>
		<cfif Find(excel_progid, xml_string) EQ 0>
			<!--- asegurarse de que tenga el identificador de Excel para Internet Explorer --->
			<cfset prolog_close = Find('?>', xml_string)+1>
			<cfset xml_string = Mid(xml_string,1,prolog_close) & excel_progid & Chr(13) & Chr(10) & Mid(xml_string,prolog_close+1,Len(xml_string)-prolog_close)>
		</cfif>
		<cfquery  DataSource="#Arguments.DataSource#">
			update AnexoCalculo
			set ACxml = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#xml_string#">
			where ACid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ACid#">
		</cfquery>
	</cffunction>

	<cffunction name="programarEjecucion" returntype="numeric" output="false">
		<!--- requiere session.Ecodigo, session.DSN y session.Usucodigo --->
		<cfargument name="AnexoId"     required="yes" type="string">
		<cfargument name="ACano"     required="yes" type="string">
		<cfargument name="ACmes"     required="yes" type="string">
		<cfargument name="Ecodigo"     required="yes" type="string">
		<!--- agregado por danim,2005-09-06,Grupo Empresas y Grupo Oficinas --->
		<cfargument name="GEid" required="yes" type="numeric" default="-1">
		<cfargument name="GOid" required="yes" type="numeric" default="-1">
		<!--- /agregado por danim,2005-09-06,Grupo Empresas y Grupo Oficinas --->
		<cfargument name="Ocodigo"     required="yes" type="string">
		<cfargument name="ACunidad" required="yes" type="string">
		<cfargument name="Mcodigo"     	required="yes" type="string">
		<cfargument name="ACmLocal" 	required="yes" type="numeric" default="0">
		<cfargument name="ACfechaCalculo" required="yes" type="date">
		<cfargument name="ACactualizarEn" required="no" default="S" type="string">
		<cfargument name="ACdistribucion" required="no" default="N" type="string">

		<cfif len(Arguments.Mcodigo) eq 0 or Arguments.Mcodigo eq "-1">
			<cfset Arguments.Mcodigo	= -1>
			<cfset Arguments.ACmLocal	= 1>
		</cfif> 
		
		<cfquery datasource="#session.dsn#" name="rsAnexoCalculo">
			select ACid, 
					GOid, GEid, Ocodigo, Ecodigo
			  from AnexoCalculo
			 where AnexoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AnexoId#">
			   and ACano = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.ACano#">
			   and ACmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.ACmes#">
			<cfif Arguments.GEid EQ -1>
			   and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			<cfelse>
			   and Ecodigo = -1
			</cfif>
			   and Mcodigo	= <cfqueryparam cfsqltype="cf_sql_integer"	value="#Arguments.Mcodigo#">
			   and ACmLocal	= <cfqueryparam cfsqltype="cf_sql_bit"		value="#Arguments.ACmLocal#">

			   and Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ocodigo#">
			   and ACunidad = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ACunidad#">
			   <!--- agregado por danim,2005-09-06,Grupo Empresas y Grupo Oficinas --->
			   and GEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GEid#">
			   and GOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GOid#">
			   <!--- agregado por danim,2005-09-06,Grupo Empresas y Grupo Oficinas --->
		</cfquery>
		<cfif Len(rsAnexoCalculo.ACid)>
			<cfquery datasource="#session.dsn#">
				update AnexoCalculo
				set ACstatus = 'P',
					ACfechaCalculo = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.ACfechaCalculo#">,
					ACactualizarEn = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ACactualizarEn#">,
					ACdistribucion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ACdistribucion#">,
					ACduracion = 0,
					ACxml = null, ACxls = null, ACzip = null,
					BMfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
					
				where ACid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAnexoCalculo.ACid#">
			</cfquery>
			<cfreturn rsAnexoCalculo.ACid>
		<cfelse>
			<cftransaction>
			<cfquery datasource="#session.DSN#" name="rsProgramarAnexoCalculo">
				insert into AnexoCalculo( 
					AnexoId, ACano, ACmes, Ecodigo, 
	<!--- agregado por danim,2005-09-06,Grupo Empresas y Grupo Oficinas --->
					GEid, GOid,
	<!--- /agregado por danim,2005-09-06,Grupo Empresas y Grupo Oficinas --->
					Mcodigo, ACmLocal,

					Ocodigo, ACunidad, ACstatus, 
					ACfechaCalculo, ACactualizarEn, ACdistribucion, BMfecha, BMUsucodigo
				) values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AnexoId#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ACano#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ACmes#">,
					 <cfif Arguments.GEid EQ -1>
					   <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
					 <cfelse>
						-1,
					 </cfif>
					<!--- agregado por danim,2005-09-06,Grupo Empresas y Grupo Oficinas --->
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GEid#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GOid#">,
					<!--- agregado por danim,2005-09-06,Grupo Empresas y Grupo Oficinas --->
					 <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.Mcodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_bit"		value="#Arguments.ACmLocal#">,
					 
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ocodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ACunidad#">,
					 'P',
					 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.ACfechaCalculo#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ACactualizarEn#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ACdistribucion#">,
					 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
					 )
				<cf_dbidentity1>
			</cfquery>
			<cf_dbidentity2 name="rsProgramarAnexoCalculo">
			</cftransaction>
			<cfreturn rsProgramarAnexoCalculo.identity>
		</cfif>
	</cffunction>

	<cffunction name="procesarCola" returntype="numeric" output="false">
		<cfargument name="DataSource" required="yes">
		<cfargument name="MaxRecordCount" required="yes" type="numeric">

		<cfset var cantidad = 0>
		<cfloop from="1" to="#Arguments.MaxRecordCount#" index="dummy">
			<cfquery DataSource="#Arguments.DataSource#" name="rsAnexoCalculo" maxrows="1">
				select ACid, ACactualizarEn
				  from AnexoCalculo
				 where ACstatus = 'P'
				   and ACfechaCalculo <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
			</cfquery>
			<cfif rsAnexoCalculo.RecordCount EQ 0>
				<cfbreak>
			</cfif>
			<cfset cantidad = cantidad + 1>
			<cfset calcularAnexo(Arguments.DataSource, rsAnexoCalculo.ACid, rsAnexoCalculo.ACactualizarEn)>
		</cfloop>
		<cfreturn cantidad>
	</cffunction>

	<cffunction name="distribuir" returntype="numeric" hint="Distribuye un anexo por correo, y regresa la cantidad de correos enviados" output="false">
		<!--- Distribuye un anexo por correo, y regresa la cantidad de correos enviados --->
		<cfargument name="DataSource" required="yes">
		<cfargument name="AnexoId" type="numeric" required="yes">
		<cfargument name="ACid" type="numeric" required="yes">
        <cfinclude template="../../../Utiles/sifConcat.cfm">
		<cfquery datasource="#Arguments.DataSource#" name="lista">
			<!--- lista de recipentes del anexo --->
			select 
				a.AnexoDes,
				case 
					when pd.Usucodigo is null 
						then pd.APnombre
						else dp.Pnombre#_Cat#' '#_Cat#dp.Papellido1#_Cat#' '#_Cat#dp.Papellido2 
				end as NombreUsuario,
				case 
					when pd.Usucodigo is null 
						then pd.APemail
						else dp.Pemail1
				end as APemail,

				ac.ACxls, 
				
				ac.ACmes, ac.ACano,
				
				ac.ACfechaCalculo,
				ac.GEid, ac.Ecodigo, ac.GOid, ac.Ocodigo,
				ge.GEnombre, e.Edescripcion, go.GOnombre, o.Odescripcion,
				case ac.ACunidad
					when 1000000 	then 'Millones de '
					when 1000		then 'Miles de '
				end as Expresion,
				ac.Mcodigo,	m.Mnombre
				
			from AnexoCalculo ac
				inner join Anexo a
						inner join AnexoPermisoDef pd
						   on (pd.GAid = a.GAid or pd.AnexoId = a.AnexoId)
						  and pd.APrecip = 1
				   on a.AnexoId = ac.AnexoId
				 left outer join Usuario u
				   on u.Usucodigo = pd.Usucodigo
				 left outer join DatosPersonales dp
				   on u.datos_personales = dp.datos_personales

				 left outer join Empresas e
				   on e.Ecodigo		= ac.Ecodigo
				
				 left outer join Oficinas o
				   on o.Ecodigo		= ac.Ecodigo
				  and o.Ocodigo		= ac.Ocodigo
				
				 left outer join AnexoGOficina go
				   on go.GOid		= ac.GOid
				
				 left outer join AnexoGEmpresa ge
				   on ge.GEid		= ac.GEid
				
				 left outer join Monedas m
				   on m.Mcodigo		= ac.Mcodigo
			where ac.ACid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ACid#">
			  and ac.AnexoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AnexoId#">
			  and ac.ACstatus = 'T'
			  and 
				rtrim(coalesce(case 
					when pd.Usucodigo is null 
						then pd.APemail
						else dp.Pemail1
				end,'')) <> ''
		</cfquery>

		<cfif lista.RecordCount EQ 0>
			<cfreturn 0>
		</cfif>

		<cfif lista.Mcodigo EQ -1>
			<cfif lista.GEid NEQ -1>
				<cfquery datasource="#Arguments.DataSource#" name="rsMonedaLocal">
					select m.Mcodigo, m.Mnombre
					  from AnexoGEmpresaDet g
						inner join Empresas e
								inner join Monedas m
								   on m.Mcodigo = e.Ecodigo
						   on e.Ecodigo = g.Ecodigo
					 where m.GEid = #lista.GEid#
				</cfquery>
			<cfelse>
				<cfquery datasource="#Arguments.DataSource#" name="rsMonedaLocal">
					select m.Mcodigo, m.Mnombre
					  from Empresas e
							inner join Monedas m
							   on m.Mcodigo = e.Ecodigo
					 where e.Ecodigo = #lista.Ecodigo#
				</cfquery>
			</cfif>
		</cfif>
		
		<!--- myfile = "<TEMP>/<DESCRIPCION_ANEXO>_<ANO>_<MES>.xls  --->
		<!--- myfile = "<TEMP>/<DESCRIPCION_ANEXO>_<ANO>_<MES>(2).xls  --->
		<!--- myfile = "<TEMP>/<DESCRIPCION_ANEXO>_<ANO>_<MES>(3).xls  --->
		<!--- myfile = "<TEMP>/<DESCRIPCION_ANEXO>_<ANO>_<MES>(100).xls  --->
		<cfset LvarName = 	REReplace(lista.AnexoDes, '[^A-Za-z0-9]', '', 'all') & "_" &
							lista.ACano & "_" & lista.ACmes>
		<cfset myfile = GetTempDirectory() & "/" & LvarName>
		<cfset LvarXLS = lista.ACxls>

		<cfif LvarXLS[1] EQ 80 AND LvarXLS[2] EQ 75>
			<cfset LvarExt = ".zip">
			<cfset LvarMIME = "application/zip">
		<cfelse>
			<cfset LvarExt = ".xls">
			<cfset LvarMIME = "application/vnd.ms-excel">
		</cfif>
		<cfset suffix = ''>
		<cfloop from="1" to="100" index="i">
			<cfif not FileExists(myfile & suffix & "#LvarExt#")>
				<cfbreak>
			</cfif>
			<cfset suffix = "(" & i & ")">
		</cfloop>
		<cfset LvarName = LvarName & suffix & "#LvarExt#">
		<cfset myfile = myfile & suffix & "#LvarExt#">

		<cfinvoke component="home.Componentes.Politicas"
				method="trae_parametro_global"
				parametro="correo.cuenta"
				returnvariable="remitente"
		/>
		<cffile action="write" file="#myfile#" output="#lista.ACxls#">
	    <cftry>
			<cfmail 
				query="lista" type="html"
				from="#remitente#" to="""'#lista.NombreUsuario#'""<#lista.APemail#>" 
				subject="Distribución Anexo Calculado #lista.AnexoDes#"
			>
				<cfmailparam file="#myfile#" type="#LvarMIME#" disposition="Attachment;filename=#LvarName#">

<table style="font:Arial, Helvetica, sans-serif">
	<tr>
		<td colspan="4">
			<h2><strong>Distribución del Anexo Calculado #lista.AnexoDes#.</strong></h2>
		</td>
	</tr>
	<tr>
		<td width="1%" rowspan="50">
			&nbsp;&nbsp;&nbsp;
		</td>
		<td width="10%">
			Fecha de Cálculo:	
		</td>
		<td width="10%">
			#DateFormat(lista.ACfechaCalculo,"DD/MM/YYYY")# #TimeFormat(lista.ACfechaCalculo,"HH:MM:SS")#
		</td>
		<td width="50%">&nbsp;
			
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td colspan="3">
			<strong>Parámetros de Cálculo:</strong>
		</td>
	</tr>

	<tr>
		<td>
			Año:
		</td>
		<td>
			#lista.ACano#
		</td>
	</tr>
	<tr>
		<td>
			Mes:
		</td>
		<td>
			#lista.ACmes#
		</td>
	</tr>
	<tr>
	<cfif lista.GEid NEQ -1>
		<td>
			Grupo de Empresas:
		</td>
		<td>
			#lista.GEnombre#
		</td>
	<cfelse>
		<td>
			Empresa:
		</td>
		<td>
			#lista.Edescripcion#
		</td>
		<td>&nbsp;
			
		</td>
	</cfif>
	</tr>
	<tr>
	<cfif lista.GOid NEQ -1>
		<td>
			Grupo de Oficinas:
		</td>
		<td>
			#lista.GOnombre#
		</td>
	<cfelseif lista.Ocodigo NEQ -1>
		<td>
			Oficina:
		</td>
		<td>
			#lista.Odescripcion#
		</td>
	<cfelse>
		<td colspan="3">
			(Todas las oficinas)
		</td>
	</cfif>
	</tr>
	<tr>
		<td colspan="3">
		<cfif lista.Mcodigo EQ -1>
			Montos expresados en #lista.Expresion# #rsMonedaLocal.Mnombre#
		<cfelse>
			Montos expresados en #lista.Expresion# #lista.Mnombre# (incluye únicamente transacciones registradas en #lista.Mnombre#)
		</cfif>
		</td>
	</tr>
</table>
			</cfmail>
			<cfquery datasource="#arguments.DataSource#">
				update AnexoCalculo
				set ACdistribucion = 'D'
				where ACid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ACid#">
			</cfquery>
		<cfcatch type="any">
			<cfquery datasource="#arguments.DataSource#">
				update AnexoCalculo
				   set ACdistribucion = 'S'
				 where ACid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ACid#">
			</cfquery>
			<cfrethrow>
		</cfcatch>
		</cftry>
    	<!---
		<cffile action="delete" file="#myfile#">
		--->
		<cfreturn lista.RecordCount>
	</cffunction>

	<!--- ================================================================ --->
	<!--- CALCULO DE UNA CELDA    (SE CALCULA SOLO UNA DETERMINADA CELDA) --->
	<!--- ================================================================ --->  

	<cffunction name="calcularCeldaAnexo" returntype="struct" output="false">
		<cfargument name="DataSource" required="yes">
		<cfargument name="AnexoCelId"     required="yes" type="numeric">
		<!--- Parametros Necesarios para Obtener el ACid --->
		<cfargument name="AnexoId"     required="yes" type="string">
		<cfargument name="ACano"     required="yes" type="string">
		<cfargument name="ACmes"     required="yes" type="string">
		<cfargument name="Ecodigo"     required="yes" type="string">
		<cfargument name="Ocodigo"     required="yes" type="string">
		<cfargument name="ACunidad" 	required="yes" type="string">
		<cfargument name="Mcodigo"		required="yes" type="string">
		<cfargument name="ACmLocal" 	required="yes" type="numeric" default="0">
		<cfargument name="GEid" required="yes" type="numeric" default="-1">
		<cfargument name="GOid" required="yes" type="numeric" default="-1">
	
		<cfset LvarEcodigo = Arguments.Ecodigo>
		
		<cfif len(LvarEcodigo) eq 0 or LvarEcodigo eq "-1">
			<cfset LvarEcodigo = #session.Ecodigo#>
		</cfif> 

		<cfif len(Arguments.Mcodigo) eq 0 or Arguments.Mcodigo eq "-1">
			<cfset Arguments.Mcodigo	= -1>
			<cfset Arguments.ACmLocal	= 1>
		</cfif> 
		
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select *
			  from AnexoCalculo
			 where AnexoId 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AnexoId#">
			   and ACano 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.ACano#">
			   and ACmes 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.ACmes#">
			   and Ecodigo	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			   and Ocodigo	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ocodigo#">
			   and GEid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GEid#">
			   and GOid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GOid#">

			   and Mcodigo 	= <cfqueryparam cfsqltype="cf_sql_integer" 	value="#Arguments.Mcodigo#">
			   and ACmLocal	= <cfqueryparam cfsqltype="cf_sql_bit"		value="#Arguments.ACmLocal#">
			   and ACunidad	= -<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ACunidad#">
		</cfquery>

		<cfif rsSQL.recordCount NEQ 0>
			<cfquery  DataSource="#Arguments.DataSource#">
				delete from AnexoCalculoRango
				 where ACid = #rsSQL.ACid#
			</cfquery>
			
			<cfquery  DataSource="#Arguments.DataSource#">
				delete from AnexoCalculo
				 where ACid = #rsSQL.ACid#
			</cfquery>
		</cfif>

		<cftransaction>
			<cfquery datasource="#session.DSN#" name="rsProgramarAnexoCalculo">
				insert into AnexoCalculo( 
					AnexoId, ACano, ACmes, ACunidad, 
					Mcodigo, ACmLocal,

	<!--- agregado por danim,2005-09-06,Grupo Empresas y Grupo Oficinas --->
					Ecodigo, Ocodigo, GOid, GEid,
	<!--- /agregado por danim,2005-09-06,Grupo Empresas y Grupo Oficinas --->
					ACstatus, 
					ACfechaCalculo, ACactualizarEn, ACdistribucion, BMfecha, BMUsucodigo
				) values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AnexoId#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ACano#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ACmes#">,
					 -<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ACunidad#">,

					 <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.Mcodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_bit"		value="#Arguments.ACmLocal#">,
					<!--- agregado por danim,2005-09-06,Grupo Empresas y Grupo Oficinas --->
				     <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ocodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GOid#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GEid#">,
					<!--- agregado por danim,2005-09-06,Grupo Empresas y Grupo Oficinas --->
					 'C',		<!--- En Calculo --->
					 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					 'E',		<!--- En Excel: para que no cambie XML --->
					 'N',	
					 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
					 )
				<cf_dbidentity1>
			</cfquery>
			<cf_dbidentity2 name="rsProgramarAnexoCalculo" returnvariable="LvarACid">
		</cftransaction>
		
		<cfset ResultadoCalculo = structNew()>
		<cfset ResultadoCalculo.Tipo = "">
		<cfset ResultadoCalculo.Valor = "">

		<cfset calcularAnexo (session.DSN, LvarACid, "E", Arguments.AnexoCelId)>
		<cfquery  DataSource="#Arguments.DataSource#">
			delete from AnexoCalculoRango
			 where ACid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarACid#">
		</cfquery>
		
		<cfquery  DataSource="#Arguments.DataSource#">
			delete from AnexoCalculo
			 where ACid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarACid#">
		</cfquery>
		<cfreturn ResultadoCalculo>
		<!--- ========================================================== --->
		<!--- ========================================================== --->
	</cffunction>  

	<cffunction name="fnNombreMes" returntype="string" output="false">
		<cfargument name="Ecodigo" 		required="yes" type="numeric">
		<cfargument name="DataSource"	required="yes" type="string">
		<cfargument name="Mes" 			required="yes" type="numeric">

		<cfif not isArray(GvarMeses)>
			<cfif isdefined('Session.CEcodigo')>
				<cfset LvarCEcodigo = session.CEcodigo>
			<cfelse>
				<cfquery name="rsSQL" datasource="#Arguments.DataSource#">
					select cliente_empresarial
					  from Empresas
					 where Ecodigo = #Arguments.Ecodigo#
				</cfquery>
				<cfset LvarCEcodigo = rsSQL.cliente_empresarial>
			</cfif>
			
			<cfquery name="rsSQL" datasource="asp">
				select LOCIdioma
				  from CuentaEmpresarial
				 where CEcodigo = #LvarCEcodigo#
			</cfquery>
			<cfquery name="rsSQL" datasource="sifControl">
				select b.VSdesc as NomMes
				from Idiomas a, VSidioma b 
				where a.Icodigo = '#rsSQL.LOCIdioma#'
				and b.VSgrupo = 1
				and a.Iid = b.Iid
				order by <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor">
			</cfquery>
			<cfif rsSQL.recordCount NEQ 12>
				<cfset GvarMeses = listToArray("Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Setiembre,Octubre,Noviembre,Diciembre")>
			<cfelse>
				<cfset GvarMeses = listToArray(valueList(rsSQL.NomMes))>
			</cfif>
		</cfif>
		
		<cfif Arguments.Mes GTE 1 AND Arguments.Mes LTE 12>
			<cfreturn GvarMeses[Arguments.Mes]>
		<cfelse>
			<cfreturn "MES #Arguments.Mes#">
		</cfif>
	</cffunction>

	<cffunction name="fnExpresarValor" returntype="string">
		<cfargument name="Valor" required="yes">
		<cfargument name="Unidad" required="yes">
		
		<cfif Arguments.Valor EQ "" or Arguments.Valor EQ 0>
			<cfreturn "0.00">
		<cfelseif len(Arguments.Valor) LTE 12>
			<cfreturn Arguments.Valor/Arguments.Unidad>
		</cfif>
		<cfset LvarDecimal = createobject("java","java.math.BigDecimal")>
		<cfset LvarDecimal.init("#Arguments.Valor#"&"")>
		<cfset LvarUnidades = createobject("java","java.math.BigDecimal")>
		<cfset LvarUnidades.init("#Arguments.Unidad#"&"")>
		<cfset LvarValor = LvarDecimal.divide(LvarUnidades,10,4).toString()>

		<cfloop index="i" from="#len(LvarValor)#" to="1" step="-1">
			<cfif mid(LvarValor,i,1) EQ ".">
				<cfreturn mid(LvarValor,1,i) & "00">
			<cfelseif mid(LvarValor,i,1) NEQ "0">
				<cfreturn mid(LvarValor,1,i)>
			</cfif>
		</cfloop>
		<cfreturn LvarValor>
	</cffunction>
</cfcomponent>


