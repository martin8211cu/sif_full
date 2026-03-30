<cfcomponent>
	<cffunction name="CG_Distribucion" access="public">
		<cfargument name="Idgrp"		      	type="numeric" required="yes">
		<cfargument name="IDdistribucion"      	type="numeric" required="yes">		
		<cfargument name="CGCperiodo"      		type="numeric" required="no" default="0">
		<cfargument name="CGCmes"          		type="numeric" required="no" default="0">
		<cfargument name="Mcodigo"         		type="numeric" required="no" default="-1">
		<cfargument name="Ecodigo"         		type="numeric" default="#Session.Ecodigo#" required="no">
		<cfargument name="Conexion"        		type="string"  default="#Session.DSN#" required="no">	
		<cfargument name="Simular"		      	type="string"  required="no" default="N">
		<cfargument name="BajarExc"		      	type="string"  required="no" default="N">

		<!--- Consulta la Moneda Local --->
		<cfif Arguments.Mcodigo eq -1>
		
			<cfquery name="rstemp" datasource="#Arguments.Conexion#">
				select Mcodigo as Monloc
				from Empresas 
				where Ecodigo = <cfqueryparam value="#Arguments.Ecodigo#" cfsqltype="cf_sql_integer">
			</cfquery>		
	
			<cfset Monloc = rstemp.Monloc>
			<cfif len(trim(Monloc)) eq 0>
				<cf_errorCode	code = "51049" msg = "Error 40001! No se pudo obtener la moneda local. Proceso Cancelado!">
			</cfif>		

		<cfelse>
			<cfset Monloc = Arguments.Mcodigo>
		</cfif>
		
		<cfif Arguments.CGCperiodo eq 0>
		
			<!--- Consulta el Periodo en la tabla de parámetros--->
			<cfquery name="rstemp" datasource="#Arguments.Conexion#">
				select convert(int, Pvalor) as Periodo
				from Parametros
				where Ecodigo = #Arguments.Ecodigo#
				  and Pcodigo = 30
				  and Mcodigo = 'CG'
			</cfquery>
	
			<cfset Periodo = rstemp.Periodo>		
			<cfif len(trim(periodo)) eq 0>
				<cf_errorCode	code = "50057" msg = "Error 40001! No se pudo obtener el periodo. Proceso Cancelado!">
			</cfif>
		
		<cfelse>
			<cfset Periodo = Arguments.CGCperiodo>
		</cfif>
		
		<cfif Arguments.CGCmes eq 0>
		
			<!--- Consulta el Mes en la tabla de parámetros--->
			<cfquery name="rstemp" datasource="#Arguments.Conexion#">
				select convert(int, Pvalor) as Mes
				from Parametros
				where Ecodigo = #Arguments.Ecodigo#
				  and Pcodigo = 40
				  and Mcodigo = 'CG'
			</cfquery>
	
			<cfset Mes = rstemp.Mes>		
	
			<cfif len(trim(Mes)) eq 0>
				<cf_errorCode	code = "50057" msg = "Error 40001! No se pudo obtener el periodo. Proceso Cancelado!">
			</cfif>	

		<cfelse>
			<cfset Mes = Arguments.CGCmes>
		</cfif>

		<!--- Si para el grupo periodo mes hay un asiento sin postear no se puede generar la distribucion --->
		<cfquery datasource="#Session.DSN#" name="sqlVerificaAsientos">
			select a.IDContable
			from DCAsientos a
				inner join EContables b
					on  b.IDcontable = a.IDContable	
			where a.Ecodigo  = #Arguments.Ecodigo#
			  and a.Eperiodo = #Arguments.CGCperiodo#
			  and a.Emes     = #Arguments.CGCmes#
			  and a.IDgd     = #Arguments.Idgrp#
		</cfquery>

		<cfif sqlVerificaAsientos.Recordcount gt 0>
			<cf_errorCode	code = "51050" msg = "Existen Asientos pendientes de postear. No es posible realizar el proceso de distribución">
		</cfif>

		<!--- Crea tablas temporales para mantener las cuentas --->		
		<cf_dbtemp name="DT_CUENTASORG" returnvariable="MOVIMIENTOS_CTAS_ORG" datasource="#Arguments.Conexion#">
			<cf_dbtempcol name="ID"   	 	 	type="numeric"	     identity="yes">
			<cf_dbtempcol name="Periodo"     	type="int"	     	 mandatory="yes">
			<cf_dbtempcol name="Mes"   	 	 	type="int"  	     mandatory="yes">
			<cf_dbtempcol name="CGCidc" 	 	type="numeric"      mandatory="yes">
			<cf_dbtempcol name="Ocodigo"	 	type="int"  	     mandatory="yes">
			<cf_dbtempcol name="Ccuenta" 	 	type="numeric"      mandatory="yes">
			<cf_dbtempcol name="Cformato"    	type="varchar(100)" mandatory="yes">
			<cf_dbtempcol name="CcuentaLiq"	 	type="numeric"      mandatory="no">
			<cf_dbtempcol name="CcuentaLiqOrg"	type="numeric"      mandatory="no">
			<cf_dbtempcol name="CformatoLiq" 	type="varchar(100)" mandatory="no">
			<cf_dbtempcol name="CformatoLiqOrg" type="varchar(100)" mandatory="no">
			<cf_dbtempcol name="Complemento" 	type="varchar(100)" mandatory="no">
			<cf_dbtempcol name="ComplementoOrg" type="varchar(100)" mandatory="no">
			<cf_dbtempcol name="MontoDist"   	type="money"	     mandatory="yes">
			<cf_dbtempcol name="CGCid" 	  	 	type="numeric" 	 mandatory="yes">

			<cf_dbtempkey cols="ID">
		</cf_dbtemp>
		<cfset Request.movctasorg = MOVIMIENTOS_CTAS_ORG>			
		
		<cf_dbtemp name="DT_UENS" returnvariable="DT_UENS" datasource="#Arguments.Conexion#">
			<cf_dbtempcol name="ID"   	       type="numeric"   identity="yes">
			<cf_dbtempcol name="Periodo"       type="money"	    mandatory="yes">
			<cf_dbtempcol name="Mes"   	       type="money"	    mandatory="yes">
			<cf_dbtempcol name="Ocodigo"	   type="int"  	    mandatory="yes">
			<cf_dbtempcol name="Ccuenta" 	   type="numeric"   mandatory="yes">
			<cf_dbtempcol name="CcuentaLiqOrg" type="numeric"   mandatory="no">
			<cf_dbtempcol name="PCCDclaid"     type="numeric"   mandatory="yes">
			<cf_dbtempcol name="MntDist"   	   type="money"	    mandatory="yes">
			
			<cf_dbtempkey cols="ID">
		</cf_dbtemp>		
		<cfset Request.distuens = DT_UENS>

		<cf_dbtemp name="DT_OFICINAS" returnvariable="DT_OFICINAS" datasource="#Arguments.Conexion#">
			<cf_dbtempcol name="ID"   	       type="numeric"   identity="yes">			
			<cf_dbtempcol name="Periodo"       type="int"	    mandatory="yes">
			<cf_dbtempcol name="Mes"   	   	   type="int"  	    mandatory="yes">
			<cf_dbtempcol name="Ocodigo"	   type="int"  	    mandatory="yes">			
			<cf_dbtempcol name="Ccuenta" 	   type="numeric"   mandatory="yes">
			<cf_dbtempcol name="CcuentaLiqOrg" type="numeric"   mandatory="no">
			<cf_dbtempcol name="PCCDclaid" 	   type="numeric"   mandatory="yes">
			<cf_dbtempcol name="OcodigoD"	   type="int"  	    mandatory="yes">			
			<cf_dbtempcol name="MntOficina"	   type="money"	    mandatory="yes">
							
			<cf_dbtempkey cols="ID">
		</cf_dbtemp>		
		<cfset Request.OficinasxUen = DT_OFICINAS>
			
		

		<!--- CREA LA TABLA INTARC PARA GENERAR EL ASIENTO --->		
		<cfinvoke component="sif.Componentes.CG_GeneraAsiento" 
			method="CreaIntarc" 
			returnvariable="INTARC">
		</cfinvoke>
		
		
		<!--- Obtiene el origen de acuerdo al grupo --->
		<cfquery name="RsOrigen" datasource="#session.DSN#">
		Select Oorigen 
		from DCGDistribucion 
		where IDgd=#Arguments.Idgrp#
		</cfquery>

		<cfif RsOrigen.recordcount eq 0>
			<cf_errorCode	code = "51051" msg = "No hay un origen definido para el grupo de distribución">
		</cfif>
		<cfset VOorigen = RsOrigen.Oorigen>
		
		<cfset fecha = ltrim(LSDateFormat(Now(),"mmm dd yyyy")) & " 12:00:00AM">		
		<cfset descripcion = "Distribucion de Saldos Contables por Conductores">
		
		<cfinclude template="../Utiles/sifConcat.cfm">
		<!--- OBTIENE LAS CUENTAS ORIGEN --->
		<cfquery datasource="#Arguments.Conexion#">
			Insert into #Request.movctasorg#(Periodo,  
											Mes,
											CGCidc,
											Ocodigo, 	
											Ccuenta,
											Cformato,
											CGCid, 	
											MontoDist, 	
											Complemento,
											ComplementoOrg
											)
			Select 	
					#Periodo#,
					#Mes#,			
					b.CGCidc,
					a.Ocodigo,
					c.Ccuenta,
					c.Cformato,
					b.CGCid,

					coalesce((
							select sum(d.DLdebitos - d.CLcreditos)
							from SaldosContables d
							where d.Ccuenta    = c.Ccuenta
							  and d.Ocodigo  = a.Ocodigo
							  and d.Speriodo = #Periodo#
							  and d.Smes     = #Mes#
						), 0.00) as MontoDist,

					a.CDcomplemento, 
					a.CDcomplementoOrg
								
			from DCCtasOrigen  a
					inner join  CGConductores b
					on a.CGCid = b.CGCid

					inner join CContables c
					on  c.Cmayor = <cf_dbfunction name="sPart"	args="a.CDformato,1,4">
					and c.Ecodigo = a.Ecodigo
					and <cf_dbfunction name="like"	args="c.Cformato;a.CDformato" delimiters=";">
					and c.Cformato >= <cf_dbfunction name="sPart"	args="a.CDformato,1,4">
					and c.Cformato <= <cf_dbfunction name="sPart"	args="a.CDformato,1,4"> #_Cat# '9'
					and c.Cmovimiento = 'S'
						
			where a.IDdistribucion = #Arguments.IDdistribucion#
		</cfquery>

		<!--- Elimina las cuentas que no tuvieron movimiento --->
		<cfquery datasource="#Arguments.Conexion#">
			delete from #Request.movctasorg#
			where MontoDist = 0
		</cfquery>
		
		<!--- Si no hay cuentas orgien no se puede distribuir nada --->	
		<cfquery datasource="#Arguments.Conexion#" name="rsCtasOrg">
		Select count(1) as totalCtas
		from #Request.movctasorg#
		</cfquery>
		
		<cfif rsCtasOrg.totalCtas eq 0>
			<cf_errorCode	code = "51052" msg = "No es posible generar la distribución porque no hay cuentas origenes generadas">
		</cfif>
		
		<!--- Define la cuenta a liquidar (CREDITO), igual al formato de la cuenta porque no existe complemento --->
		<cfquery datasource="#Arguments.Conexion#">
			Update #Request.movctasorg#
			set CformatoLiq = Cformato
			where Complemento is null
		</cfquery>

		<!--- Define la cuenta a liquidar (DEBITO), igual al formato de la cuenta porque no existe complemento --->
		<cfquery datasource="#Arguments.Conexion#">
			Update #Request.movctasorg#
			set CformatoLiqOrg = Cformato
			where ComplementoOrg is null
		</cfquery>

		<!--- Define la cuenta a liquidar(CREDITO), igual al complemento de la cuenta porque no existen caracteres de sustitución --->
		<cfquery datasource="#Arguments.Conexion#">
			Update #Request.movctasorg#
			set CformatoLiq = Complemento
			where Complemento is not null
			  and <cf_dbfunction name="sFind" args="Complemento,'_'"> = 0 
		</cfquery>					
		
		<!--- Define la cuenta a liquidar(DEBITO), igual al complemento de la cuenta porque no existen caracteres de sustitución --->
		<cfquery datasource="#Arguments.Conexion#">
			Update #Request.movctasorg#
			set CformatoLiqOrg = ComplementoOrg
			where ComplementoOrg is not null
			  and <cf_dbfunction name="sFind" args="ComplementoOrg,'_'"> = 0 
		</cfquery>					

		<!--- ******************************************************
		TRABAJA LOS COMPLEMENTOS PARA FORMAR LAS CUENTAS DEL CREDITO
		--->  ******************************************************

		<!--- Sustituye (_) por digitos de acuerdo al complemento --->
		<cfquery datasource="#Arguments.Conexion#" name="rsCCtas">
			Select ID, Cformato, Complemento
			from #Request.movctasorg#
			where Complemento is not null
			  and <cf_dbfunction name="sFind" args="Complemento,'_'"> <> 0
		</cfquery>

		<!--- Genera la sustitucion de las cuentas, de acuerdo al complemento --->		
		<cfloop query="rsCCtas">

			<cfset IDcta = rsCCtas.ID>
			<cfset ctaComplemento = rsCCtas.Complemento>
			<cfset ctaCformato = rsCCtas.Cformato>
			
			<cf_fusioncuentas cuentaorigen="#ctaCformato#" complemento="#ctaComplemento#" returnvariable="cuentaresultante">

			<cfquery datasource="#Arguments.Conexion#" name="sqlActualizaTempCtas">
				Update #Request.movctasorg#
				set CformatoLiq = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cuentaresultante#">
				where ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDcta#">
			</cfquery>
			
		</cfloop>
		
		<!--- Actualiza el Ccuenta segun la cuenta complementada --->
		<cfquery datasource="#Arguments.Conexion#">
			Update #Request.movctasorg#
			set CcuentaLiq = (select a.Ccuenta
					  from CContables a <cf_dbforceindex name="CContables_03">
					  where a.Ecodigo = #Arguments.Ecodigo#
					    and a.Cformato = #Request.movctasorg#.CformatoLiq
					)
			where CcuentaLiq is null
		</cfquery>

		<!--- Obtiene los CcuentaLiq que no existen y genera las cuentas --->
		<cfquery datasource="#Arguments.Conexion#" name="rsCCtas">
			Select distinct CformatoLiq, 
					#Request.movctasorg#.Ocodigo, 
					b.Oficodigo
			from #Request.movctasorg#, Oficinas b
			where CcuentaLiq is null
			  and #Request.movctasorg#.Ocodigo = b.Ocodigo
		</cfquery>

		<cfset LvarFecha = createdate (year(now()), month(now()), day(now()))>

		<cfset cuenta = 0>
		<cfloop query="rsCCtas">
			<cfinvoke 
				 component="sif.Componentes.PC_GeneraCuentaFinanciera"
				 method="fnGeneraCuentaFinanciera"
				 returnvariable="LvarMSG">
				<cfinvokeArgument name="Lprm_CFformato" 		value="#rsCCtas.CformatoLiq#"/>
				<cfinvokeArgument name="Lprm_Ocodigo" 			value="#rsCCtas.Ocodigo#"/>
				<cfinvokeArgument name="Lprm_fecha" 			value="#LvarFecha#"/>
				<cfinvokeArgument name="Lprm_Ecodigo" 			value="#Arguments.Ecodigo#"/>
				<cfinvokeArgument  name="Lprm_TransaccionActiva" value="no">
			</cfinvoke>

			<cfif LvarMSG neq "NEW" and LvarMSG neq "OLD">
				<cf_errorCode	code = "51053"
								msg  = "Se presentaron errores creando las cuentas Origen: @errorDat_1@"
								errorDat_1="#LvarMSG#"
				>
			</cfif>
		</cfloop>
				
		<!--- Actualizar Ccuenta en la tabla origen con las nuevas cuentas generadas --->
		<cfquery datasource="#Arguments.Conexion#">
			Update #Request.movctasorg#
			set CcuentaLiq = (
					select a.Ccuenta
					from CContables a <cf_dbforceindex name="CContables_03">
					where a.Ecodigo = #Arguments.Ecodigo#
					  and a.Cformato = #Request.movctasorg#.CformatoLiq
					  and #Request.movctasorg#.CcuentaLiq is null
			 		)
			where CcuentaLiq is null
		</cfquery>

		<cfquery datasource="#Arguments.Conexion#" name="rsRevCCtas">
			Select distinct CformatoLiq, Ocodigo
			from #Request.movctasorg#
			where CcuentaLiq is null
			order by CformatoLiq, Ocodigo
		</cfquery>

		<cfif rsRevCCtas.recordcount gt 0>
			<cf_errorCode	code = "51054" msg = "Se presentaron errores con la creación de cuentas de acuerdo al complemento del credito">
		</cfif>


		<!--- ******************************************************
		TRABAJA LOS COMPLEMENTOS PARA FORMAR LAS CUENTAS DEL DEBITO
		--->  ******************************************************

		<!--- Sustituye (_) por digitos de acuerdo al complemento --->
		<cfquery datasource="#Arguments.Conexion#" name="rsCCtas">
			Select ID, Cformato, ComplementoOrg
			from #Request.movctasorg#
			where ComplementoOrg is not null
			  and <cf_dbfunction name="sFind" args="ComplementoOrg,'_'"> <> 0
		</cfquery>

		<!--- Genera la sustitucion de las cuentas, de acuerdo al complemento --->		
		<cfloop query="rsCCtas">

			<cfset IDcta = rsCCtas.ID>
			<cfset ctaComplemento = rsCCtas.ComplementoOrg>
			<cfset ctaCformato = rsCCtas.Cformato>
			
			<cf_fusioncuentas cuentaorigen="#ctaCformato#" complemento="#ctaComplemento#" returnvariable="cuentaresultante">

			<cfquery datasource="#Arguments.Conexion#" name="sqlActualizaTempCtas">
				Update #Request.movctasorg#
				set CformatoLiqOrg = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cuentaresultante#">
				where ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDcta#">
			</cfquery>
			
		</cfloop>
		
		<!--- Actualiza el Ccuenta segun la cuenta complementada --->
		<cfquery datasource="#Arguments.Conexion#">
			Update #Request.movctasorg#
			set CcuentaLiqOrg = (select a.Ccuenta
					  from CContables a <cf_dbforceindex name="CContables_03">
					  where a.Ecodigo = #Arguments.Ecodigo#
					    and a.Cformato = #Request.movctasorg#.CformatoLiqOrg
					)
			where CcuentaLiqOrg is null
		</cfquery>

		<!--- Obtiene los CcuentaLiq que no existen y genera las cuentas --->
		<cfquery datasource="#Arguments.Conexion#" name="rsCCtas">
			Select distinct CformatoLiqOrg, 
					#Request.movctasorg#.Ocodigo, 
					b.Oficodigo
			from #Request.movctasorg#, Oficinas b
			where CcuentaLiqOrg is null
			  and #Request.movctasorg#.Ocodigo = b.Ocodigo
		</cfquery>

		<cfset LvarFecha = createdate (year(now()), month(now()), day(now()))>

		<cfset cuenta = 0>
		<cfloop query="rsCCtas">
			<cfinvoke 
				 component="sif.Componentes.PC_GeneraCuentaFinanciera"
				 method="fnGeneraCuentaFinanciera"
				 returnvariable="LvarMSG">
				<cfinvokeArgument name="Lprm_CFformato" 		value="#rsCCtas.CformatoLiqOrg#"/>
				<cfinvokeArgument name="Lprm_Ocodigo" 			value="#rsCCtas.Ocodigo#"/>
				<cfinvokeArgument name="Lprm_fecha" 			value="#LvarFecha#"/>
				<cfinvokeArgument name="Lprm_Ecodigo" 			value="#Arguments.Ecodigo#"/>
				<cfinvokeArgument  name="Lprm_TransaccionActiva" value="no">
			</cfinvoke>

			<cfif LvarMSG neq "NEW" and LvarMSG neq "OLD">
				<cf_errorCode	code = "51055"
								msg  = "Se presentaron errores creando las cuentas Origen(DEBITO): @errorDat_1@"
								errorDat_1="#LvarMSG#"
				>
			</cfif>
		</cfloop>
				
		<!--- Actualizar Ccuenta en la tabla origen con las nuevas cuentas generadas --->
		<cfquery datasource="#Arguments.Conexion#">
			Update #Request.movctasorg#
			set CcuentaLiqOrg = (
					select a.Ccuenta
					from CContables a <cf_dbforceindex name="CContables_03">
					where a.Ecodigo = #Arguments.Ecodigo#
					  and a.Cformato = #Request.movctasorg#.CformatoLiqOrg
					  and #Request.movctasorg#.CcuentaLiqOrg is null
			 		)
			where CcuentaLiqOrg is null
		</cfquery>

		<cfquery datasource="#Arguments.Conexion#" name="rsRevCCtas">
			Select distinct CformatoLiqOrg, Ocodigo
			from #Request.movctasorg#
			where CcuentaLiqOrg is null
			order by CformatoLiqOrg, Ocodigo
		</cfquery>

		<cfif rsRevCCtas.recordcount gt 0>
			<cf_errorCode	code = "51056" msg = "Se presentaron errores con la creación de cuentas de acuerdo al complemento del debito">
		</cfif>

		<!--- Determina el monto que le toca a cada una de las UENS por cuentas --->
		<cfquery datasource="#Arguments.Conexion#">
			INSERT #Request.distuens# (	Periodo, Mes, Ocodigo, 	Ccuenta, CcuentaLiqOrg, PCCDclaid, MntDist)
			Select 				
					org.Periodo,
					org.Mes,
					org.Ocodigo, 	
					org.Ccuenta,	
					org.CcuentaLiqOrg,
					b.PCCDclaid,

					coalesce(
						convert(money,
								(
								( org.MontoDist / 	(Select sum(d.CGCvalor) 
												from CGParamConductores d
												where d.Ecodigo 	= c.Ecodigo
												  and d.CGCperiodo	= c.CGCperiodo
												  and d.CGCmes		= c.CGCmes
												  and d.CGCid 		= c.CGCid) ) * c.CGCvalor)  
								 )
								,0.00) as MntDist
			
			from #Request.movctasorg# org			
			
					inner join  CGConductores cd
						on org.CGCid = cd.CGCid
			
					inner join PCClasificacionE a
						on a.PCCEclaid = cd.CGCidc
						and a.PCCEclaid = org.CGCidc
							
					inner join PCClasificacionD b
						on a.PCCEclaid = b.PCCEclaid
							
					inner join CGParamConductores c
						 on c.Ecodigo 		= #Arguments.ecodigo#
					  	and c.CGCperiodo	= org.Periodo
					  	and c.CGCmes		= org.Mes
					  	and c.CGCid 		= org.CGCid
					  	and c.PCCDclaid 	= b.PCCDclaid
		</cfquery>
		
		<!--- Borra las UENS a las que no les toco nada --->
		<cfquery datasource="#Arguments.Conexion#" name="rsBorraUEN">			
			delete from #Request.distuens#
			where MntDist = 0.00
		</cfquery>
	
		<!--- Verifica que todas las UENS que existen parametrizadas con valores para
		el periodo-mes, tengan oficinas con el 100% de distribucion definidas --->	
		<cfquery datasource="#Arguments.Conexion#" name="rsVerDistxUEN">		
			Select count(1) as Total 
			from PCClasificacionD a
			where 100.00 != coalesce((Select round(sum(b.CGCporcentaje),2)
									  from OficinasxClasificacion b
									  where a.PCCDclaid  = b.PCCDclaid
										and b.CGCperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Periodo#">
										and b.CGCmes     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Mes#">) ,0.00)
									  
			  and a.PCCDclaid in (Select distinct PCCDclaid from #Request.distuens#)
		</cfquery>
		
		<cfif rsVerDistxUEN.Total gt 0>
			<cf_errorCode	code = "51057" msg = "Existen UENS asociadas al catálogo de clasificaciones que no tienen oficinas parametrizadas y presentan valor para el periodo-mes">
		</cfif>
			
		<!--- Determina el monto que le toca a cada una de las Oficinas de la UEN de acuerdo al porcentaje --->
		<cfquery datasource="#Arguments.Conexion#" name="rsDistribucionOficinas">
			INSERT into #Request.OficinasxUen#(Periodo, Mes, Ocodigo, Ccuenta, CcuentaLiqOrg, PCCDclaid, OcodigoD, MntOficina)
			Select 	a.Periodo,
					a.Mes,
					a.Ocodigo, 
					a.Ccuenta, 
					a.CcuentaLiqOrg,
					a.PCCDclaid, 
					b.Ocodigo,	
					((MntDist * b.CGCporcentaje) / 100) as MntDist
 			from #Request.distuens# a
					inner join OficinasxClasificacion b
						 on a.PCCDclaid  = b.PCCDclaid
						and b.CGCperiodo = a.Periodo
						and b.CGCmes = a.Mes
						and b.CGCporcentaje != 0
		</cfquery>
		<!--- Generacion del Asiento Contable --->
		<cfif Arguments.Simular eq "N">
			<cfinvoke component= "sif.Componentes.OriRefNextVal"
				method		= "nextVal"
				returnvariable	= "LvarNumDoc"
				ORI		= "#VOorigen#"
				REF		= "DST_SAL"			/>

			<cfset Lvar_Doc = LvarNumDoc>
			<cfset Lvar_Ref = "DST_SAL">
		<cfelse>
			<cfset Lvar_Doc = 0>
			<cfset Lvar_Ref = "DST_SAL">
		</cfif>		
	

		<!--- --------------------------------- --->
		<!---	 GENERA EL ASIENTO CONTABLE	--->
		<!--- --------------------------------- --->		
		
		<!--- CREDITO A LAS CUENTAS ORIGEN SEGUN LA CUENTA DE LIQUIDACION --->		
		<cfquery name="rstemp" datasource="#Arguments.Conexion#">
			insert into #INTARC# ( 
					INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, 
					INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE
					)
			select 
				'#VOorigen#',
				1,
				'#Lvar_Doc#',
				'#Lvar_Ref#',
				round(sum(a.MontoDist),2),
				'C',
				b.Cdescripcion,
				<cf_dbfunction name="now">,
				1,
				a.Periodo, 
				a.Mes,
				a.CcuentaLiq,
				<cfqueryparam value="#Monloc#" cfsqltype="cf_sql_numeric">,
				a.Ocodigo,
				round(sum(a.MontoDist),2)
			from #Request.movctasorg# a, CContables b
			where a.CcuentaLiq = b.Ccuenta	
			group by b.Cdescripcion, a.Periodo, a.Mes, a.CcuentaLiq, a.Ocodigo

		</cfquery>

		<cfquery name="rsImpr" datasource="#Arguments.Conexion#">
			insert into #INTARC# ( 
					INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, 
					INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE
					)		
			Select 
				'#VOorigen#',
				1,
				'#Lvar_Doc#',
				'#Lvar_Ref#',
				round(sum(a.MntOficina),2) as MntOficina,
				'D',
				b.Cdescripcion,
				<cf_dbfunction name="now">,
				1,
				a.Periodo,
				a.Mes,
				a.CcuentaLiqOrg,
				<cfqueryparam value="#Monloc#" cfsqltype="cf_sql_numeric">,
				a.OcodigoD,
				round(sum(a.MntOficina),2) as MntOficina1
			from #Request.OficinasxUen# a, CContables b
			where a.CcuentaLiqOrg = b.Ccuenta	
			group by b.Cdescripcion, a.Periodo, a.Mes, a.CcuentaLiqOrg, a.OcodigoD
		</cfquery>
		
		<!--- ******************************************************************* --->
		<!--- ***** MANEJO DE LAS CUENTAS DE RELACION (BALANCE POR OFICINA) ***** --->
		<!--- ******************************************************************* --->
		
		<!--- Verifica si hay Cuentas de Relacion --->
		<cfquery name="rsHayCuentasBalanceOficina" datasource="#Arguments.Conexion#">
			select 1
			from CuentaBalanceOficina
			where Ecodigo = #Arguments.Ecodigo#
		</cfquery>		

		<cfif rsHayCuentasBalanceOficina.recordcount GT 0>
	
			<!--- Obtiene las oficinas diferentes a las del origen --->
	
			<cfquery name="rsrevisaoficinas" datasource="#Arguments.Conexion#">			
				Select  distinct 
						Ocodigo as Ofiorigen, 
						OcodigoD as Ofidestino
				from #Request.OficinasxUen# a
				where a.Ocodigo != a.OcodigoD
			</cfquery>

			<cfif rsrevisaoficinas.recordcount gt 0>
				
				<!--- Se crean las Cuentas de Relacion (Balance por Oficina) --->
				<cfloop query="rsrevisaoficinas">
				
					<cfset Oficina_org = rsrevisaoficinas.Ofiorigen>
					<cfset Oficina_dest = rsrevisaoficinas.Ofidestino>
					
					<cfquery datasource="#Arguments.Conexion#" name="rsofi1">
					Select Oficodigo 
					from Oficinas 
					where Ecodigo = #Arguments.Ecodigo#
					  and Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Oficina_org#">
					</cfquery>
					
					<cfquery datasource="#Arguments.Conexion#" name="rsofi2">
					Select Oficodigo 
					from Oficinas 
					where Ecodigo = #Arguments.Ecodigo#
					  and Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Oficina_dest#">
					</cfquery>
										
					<cfset Oficodigo1 = rsofi1.Oficodigo>
					<cfset Oficodigo2 = rsofi2.Oficodigo>
					
					
					<!--- Obtiene la cuenta por cobrar --->
					<cfquery name="rsCuentaPorCobrar" datasource="#Arguments.Conexion#">
						select CFcuentacxc
						from CuentaBalanceOficina a
							inner join ConceptoContable b
							on b.Ecodigo = a.Ecodigo
							and b.Cconcepto = a.Cconcepto
							and b.Oorigen = '#VOorigen#'
						where a.Ecodigo = #Arguments.Ecodigo#
						and Ocodigoori = <cfqueryparam cfsqltype="cf_sql_integer" value="#Oficina_org#">
						and Ocodigodest = <cfqueryparam cfsqltype="cf_sql_integer" value="#Oficina_dest#">
					</cfquery>
					<!--- Obtiene la cuenta por pagar --->
					<cfquery name="rsCuentaPorPagar" datasource="#Arguments.Conexion#">
						select CFcuentacxp
						from CuentaBalanceOficina a
							inner join ConceptoContable b
							 on b.Ecodigo   = a.Ecodigo
							and b.Cconcepto = a.Cconcepto
							and b.Oorigen   = '#VOorigen#'
						where a.Ecodigo = #Arguments.Ecodigo#
						and Ocodigoori = <cfqueryparam cfsqltype="cf_sql_integer" value="#Oficina_dest#">
						and Ocodigodest = <cfqueryparam cfsqltype="cf_sql_integer" value="#Oficina_org#">
					</cfquery>
					
				
					<!--- Se generan las validaciones para saber si ambas cuentas existen --->
					<cfset ErrorCuentaBalance = 0>
					<cfif (rsCuentaPorCobrar.recordcount 
						and len(trim(rsCuentaPorCobrar.CFcuentacxc)) gt 0 
						and rsCuentaPorCobrar.CFcuentacxc)
						and not (rsCuentaPorPagar.recordcount 
						and len(trim(rsCuentaPorPagar.CFcuentacxp)) gt 0 
						and rsCuentaPorPagar.CFcuentacxp)>
						
						<cfset ErrorCuentaBalance = 1>
						<cfset ErrorCuentaBalanceDesc = "No se encontró la Cuenta por Pagar, de Balance Por Oficina, Entre la Oficina #Oficodigo2# y la Oficina #Oficodigo1#.">
	
					<cfelseif not (rsCuentaPorCobrar.recordcount 
						and len(trim(rsCuentaPorCobrar.CFcuentacxc)) gt 0 
						and rsCuentaPorCobrar.CFcuentacxc)
						and (rsCuentaPorPagar.recordcount 
						and len(trim(rsCuentaPorPagar.CFcuentacxp)) gt 0 
						and rsCuentaPorPagar.CFcuentacxp)>
	
						<cfset ErrorCuentaBalance = 2>
						<cfset ErrorCuentaBalanceDesc = "No se encontró la Cuenta por Cobrar, de Balance Por Oficina, Entre la Oficina #Oficodigo1# y la Oficina #Oficodigo2#.">
						
					<cfelseif not (rsCuentaPorCobrar.recordcount 
						and len(trim(rsCuentaPorCobrar.CFcuentacxc)) gt 0 
						and rsCuentaPorCobrar.CFcuentacxc)
						and not (rsCuentaPorPagar.recordcount 
						and len(trim(rsCuentaPorPagar.CFcuentacxp)) gt 0 
						and rsCuentaPorPagar.CFcuentacxp)>
	
						<cfset ErrorCuentaBalance = 3>
						<cfset ErrorCuentaBalanceDesc = "No se encontró la Cuenta por Cobrar, de Balance Por Oficina, Entre la Oficina #Oficodigo1# y la Oficina #Oficodigo2# y No se encontró la Cuenta por Pagar, de Balance Por Oficina, Entre la Oficina #Oficodigo2# y la Oficina #Oficodigo1#">
					</cfif>
					<cfif ErrorCuentaBalance GT 0>
						<cf_errorCode	code = "50363"
										msg  = "Error de definición de Cuenta de Balance por Oficina. @errorDat_1@ Proceso Cancelado!"
										errorDat_1="#ErrorCuentaBalanceDesc#"
						>
					</cfif>
					
					<!--- Se insertan las cuentas de relacion --->
					<cfquery datasource="#Arguments.Conexion#">
						insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, CFcuenta, Ccuenta, Mcodigo, Ocodigo, INTMOE)
						select 
								'#VOorigen#', 
								1, 
								<cf_dbfunction name="to_char" args="#Lvar_Doc#">, 
								'#Lvar_Ref#',									
								round(sum(a.MntOficina),2),
								'D', 
								'Balance Oficina, Cuenta por Cobrar a la Oficina (#Oficodigo2#)', 
								<cf_dbfunction name="now">, 
								1.00,  
								a.Periodo, 
								a.Mes, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCuentaPorCobrar.CFcuentacxc#">, 
								0,
								<cfqueryparam value="#Monloc#" cfsqltype="cf_sql_numeric">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Oficina_org#">, 
								round(sum(a.MntOficina),2)
						
						from #Request.OficinasxUen# a
						where a.OcodigoD = <cfqueryparam cfsqltype="cf_sql_integer" value="#Oficina_dest#">
						group by a.Periodo, a.Mes
					</cfquery>

					<!--- 2.3.10 Crédito, Balance Oficina, Cuenta Pagar a la Oficina 1 --->
					<cfquery datasource="#Arguments.Conexion#">
						insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, CFcuenta, Ccuenta, Mcodigo, Ocodigo, INTMOE)
						select 
								'#VOorigen#', 
								1, 
								<cf_dbfunction name="to_char" args="#Lvar_Doc#">, 
								'#Lvar_Ref#',
								round(sum(a.MntOficina),2),
								'C', 
								'Balance Oficina, Cuenta por Pagar a la Oficina (#Oficodigo1#)', 
								<cf_dbfunction name="now">, 
								1.00,  
								a.Periodo, 
								a.Mes, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCuentaPorPagar.CFcuentacxp#">, 
								0,
								<cfqueryparam value="#Monloc#" cfsqltype="cf_sql_numeric">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Oficina_dest#">, 
								round(sum(a.MntOficina),2)
						
						from #Request.OficinasxUen# a
						where a.OcodigoD = <cfqueryparam cfsqltype="cf_sql_integer" value="#Oficina_dest#">
						group by a.Periodo, a.Mes			
					</cfquery>					
				
				</cfloop>
		
			</cfif>
			
		</cfif>		
		
		<!--- ******************************************************************* --->
		<!--- *** MANEJO DE LAS DIFERENCIAS EN EL ASIENTO LUEGO DE DISTRIBUIR *** --->
		<!--- ******************************************************************* --->
		
		<!--- Obtiene la diferencia si es que existe --->
		<cfquery name="rsDiferenciaDeb" datasource="#Arguments.Conexion#">
			Select sum(coalesce(INTMON,0.00)) as MontoDebitos
			from #INTARC#
			where INTTIP = 'D'
		</cfquery>

		<cfquery name="rsDiferenciaCre" datasource="#Arguments.Conexion#">
			Select sum(coalesce(INTMON,0.00)) as MontoCreditos
			from #INTARC#
			where INTTIP = 'C'
		</cfquery>		
		

		<!--- En caso de una diferencia se carga la cuenta de mayor monto --->		
		<cfif isdefined('rsDiferenciaDeb') and rsDiferenciaDeb.MontoDebitos GTE 0>
			<cfif isdefined('rsDiferenciaCre') and rsDiferenciaCre.MontoCreditos GTE 0>
				<cfset diferencia = rsDiferenciaDeb.MontoDebitos - rsDiferenciaCre.MontoCreditos>
			<cfelse>
				<cfset diferencia = rsDiferenciaDeb.MontoDebitos>
			</cfif>
		<cfelseif isdefined('rsDiferenciaCre') and rsDiferenciaCre.MontoCreditos GTE 0>
			<cfset diferencia = 0 - rsDiferenciaCre.MontoCreditos>	
		<cfelse>
			<cfset diferencia = 0>	
		</cfif>

		<cfif abs(diferencia) gt 5>
			<cf_errorCode	code = "51058"
							msg  = "El asiento se encuentra desbalanceado por mas de 5 colones. Diferencia=>@errorDat_1@ Débitos: @errorDat_2@ Créditos: @errorDat_3@"
							errorDat_1="#diferencia#"
							errorDat_2="#rsDiferenciaDeb.MontoDebitos#"
							errorDat_3="#rsDiferenciaCre.MontoCreditos#"
			>
		</cfif>

		<!--- Le suma la diferencia a la cuenta de mayor monto --->
		<cfquery name="rsMaximaCta" datasource="#Arguments.Conexion#">
			Select Max(INTMON) as MaximoMonto
			from #INTARC#
			where Ccuenta != 0
			  and INTTIP = 'D'
		</cfquery>

		<cfset MaxMnt = rsMaximaCta.MaximoMonto>

		<cfquery name="rsMaximaCtaLn" datasource="#Arguments.Conexion#">
			Select INTLIN from #INTARC# where INTMON = #MaxMnt# and INTTIP = 'D'
		</cfquery>

		<cfset linea = rsMaximaCtaLn.INTLIN>

		<cfquery name="rsActMaximaCta" datasource="#Arguments.Conexion#">
			Update #INTARC#
			set INTMON = INTMON - #diferencia#,
				INTMOE = INTMOE - #diferencia#
			where INTLIN = #linea#
		</cfquery>		
			
			
		<cfif Arguments.Simular eq "S">
			
			<!--- Simulacion del proceso del Asiento --->
			
			<cfquery datasource="#session.dsn#">
				update #INTARC#
				set Ccuenta = (select Ccuenta from CFinanciera cf where cf.CFcuenta = #INTARC#.CFcuenta)
				where Ccuenta = 0 and CFcuenta is not null
			</cfquery>


			<cfquery name="rsDatosIntarc" datasource="#session.dsn#">
				Select 
					INTLIN as linea, 
					(select Oficodigo 
						from Oficinas o 
							where o.Ocodigo = a.Ocodigo 
							  and o.Ecodigo = #Arguments.Ecodigo#)	as Oficina,
					(select Cformato from CContables cc where cc.Ccuenta = a.Ccuenta)	as cuenta, 
					INTDES									as descripcion,
					case when INTTIP = 'D' then INTMON else 0.00 end			as debitos,
					case when INTTIP = 'C' then INTMON else 0.00 end			as creditos
				from #INTARC#  a
				Order by INTTIP, 3, 2 
			</cfquery>
			
			<cfquery name="rsRetusuario" datasource="#session.DSN#">
				select Usulogin
				from Usuario
				where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			</cfquery>	
			
			<cfquery datasource="#Session.DSN#" name="rsGrpDist">
			select IDgd, DCdescripcion from DCGDistribucion where IDgd = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDgd#">
			</cfquery>
			<cfquery datasource="#Session.DSN#" name="rsget_periodo">
				select ltrim(rtrim(Pvalor)) as Pvalor from Parametros
				where Ecodigo = #Arguments.Ecodigo#
				and Pcodigo = 30
			</cfquery>
			
			<cfquery datasource="#Session.DSN#" name="rsget_mes">
				select ltrim(rtrim(Pvalor)) as Pvalor from Parametros
				where Ecodigo = #Arguments.Ecodigo#
				and Pcodigo = 40
			</cfquery>	
			<cfif Arguments.BajarExc eq "N">
				<cf_templatecss>
			</cfif>
			<cfoutput>
				<cfif Arguments.BajarExc eq "S">
					<cfcontent type="application/msexcel">
					<cfheader 	name="Content-Disposition"  
					value="attachment;filename=SimulacionDistribucion_#Form.IDgd#_#session.Usulogin##LSDateFormat(now(),'yyyymmdd')#.xls" >
				</cfif> 
			
				<cfif Arguments.BajarExc eq "N">
					<table width="100%" cellpadding="2" cellspacing="0" class="noprint">
						<tr >
							<td align="right">
								<a onClick="fnImgBack();">		<img class="noprint" src="/cfmx/sif/imagenes/back.png" 			border="0" style="cursor:pointer" class="noprint" title="Regresar"></a>
								<a onClick="fnImgPrint();">		<img src="/cfmx/sif/imagenes/Hardware16x16.gif"	border="0" style="cursor:pointer" class="noprint" title="Imprimir"></a>
							</td>
						</tr>
					</table>
					
					<form name="frmImgImprimir" method="post" action="SQLDistribuirConductor.cfm" style="display:none;">
						<input type="hidden" name="btnSimular" value="btnSimular"> 
						<input type="hidden" name="IDgd"       value="#Form.IDgd#">
						<input type="hidden" name="toExcel"    value="1"/>

						<input type="hidden" name="periodo"       value="#Form.periodo#">	
						<input type="hidden" name="mes"       value="#Form.mes#">
					</form>
					<script language="javascript">
						function fnImgDownload()
						{
							document.frmImgImprimir.submit();
						}
					
						function fnImgBack()
						{
							document.frmImgImprimir.action = "Distribuir.cfm?IDgd=#Form.IDgd#";
							document.frmImgImprimir.submit();
						}
						
						function fnImgPrint()
						{
							if (document.all)
								{
								try
									{
									var OLECMDID = 7;
									/* OLECMDID values:
									* 6 - print
									* 7 - print preview
									* 1 - open window
									* 4 - Save As
									*/
									var PROMPT = 1; // 2 DONTPROMPTUSER 
									var WebBrowser = '<OBJECT ID="WebBrowser1" WIDTH=0 HEIGHT=0 CLASSID="CLSID:8856F961-340A-11D0-A96B-00C04FD705A2"></OBJECT>';
									document.body.insertAdjacentHTML('beforeEnd', WebBrowser); 
									WebBrowser1.ExecWB(OLECMDID, PROMPT);
									WebBrowser1.outerHTML = "";
								}
								catch (e)
								{
									window.print();
								}
							}
							else
								window.print();
						}
					</script>
				</cfif>
			
			
				<table  align="center" border="0" cellspacing="0" cellpadding="0" width="100%">
					<tr>
						<td colspan="3" align="left"><strong>Fecha:</strong> #dateformat(now(),"dd/mm/yyyy")# </td>
						<td colspan="3" align="right"><strong>Usuario:</strong> #rsRetusuario.Usulogin# </td>
					</tr>
					<tr>
						<td colspan="6" align="left"><strong>Hora:</strong>&nbsp;&nbsp;#timeformat(now(),"HH:mm:ss")# </td>
					</tr>			
					<tr><td align="center" colspan="6"><font size="3"><strong>#session.Enombre#</strong></font></td></tr>
					<tr><td align="center" colspan="6"><font size="3"><strong>Simulaci&oacute;n De La Distribuci&oacute;n</strong></font></td></tr>
					<tr><td align="center" colspan="6"><font size="3"><strong>#rsGrpDist.DCdescripcion#</strong></font></td></tr>
					<tr><td align="center" colspan="6"><font size="2"><strong>Periodo&nbsp;&nbsp;&nbsp;#rsget_periodo.Pvalor#&nbsp;&nbsp;&nbsp;Mes&nbsp;&nbsp;&nbsp;#rsget_mes.Pvalor#</strong></font></td></tr>
					<tr>
						<td colspan="6">&nbsp;</td>
					</tr>
					<tr bgcolor="##CCCCCC">
						<td><b>L&iacute;nea</b></td>
						<td><b>Oficina</b></td>
						<td><b>Cuenta</b></td>
						<td><b>Descripci&oacute;n</b></td>
						<td align="right"><b>D&eacute;bitos</b></td>
						<td align="right"><b>Cr&eacute;ditos</b></td>
					</tr>
					<cfloop query="rsDatosIntarc">	
						<tr>
							<td>#rsDatosIntarc.linea#</td>
							<td>#rsDatosIntarc.Oficina#</td>
							<td>#rsDatosIntarc.cuenta#</td>
							<td>#rsDatosIntarc.descripcion#</td>
							<td align="right">#LSCUrrencyFormat(rsDatosIntarc.debitos,'none')#</td>
							<td align="right">#LSCUrrencyFormat(rsDatosIntarc.creditos,'none')#</td>
						</tr>
					</cfloop>
					<tr>
						<td colspan="6">&nbsp;</td>
					</tr>
					<tr>
						<td align="center" colspan="6"><b>---- &Uacute;ltima L&iacute;nea ---</b></td>
					</tr>
					<tr bgcolor="##CCCCCC">
						<td colspan="6">&nbsp;</td>
					</tr>
				</table>
			</cfoutput>
			<cfset LvarMSG = "">
			
		<cfelse>	
				
			<cfquery name="rsBuscaOficinaMinima" datasource="#session.dsn#">
				select min(Ocodigo) as Ocodigo 
				  from #INTARC#
				where Ocodigo is not null
			</cfquery>
			<cfset LvarOficina = 1>
			<cfif rsBuscaOficinaMinima.recordcount GT 0 and len(trim(rsBuscaOficinaMinima.Ocodigo)) GT 0>
				<cfset LvarOficina = rsBuscaOficinaMinima.Ocodigo>
			</cfif>

			
			<cftransaction action="begin">
			<cftry>
	
				<cfset LvarMSG = "">
				<!--- Genera el Asiento --->
				<cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="GeneraAsiento" returnvariable="res_GeneraAsiento">
					<cfinvokeargument name="Ecodigo" value="#Arguments.Ecodigo#"/>
					<cfinvokeargument name="Oorigen" value="#VOorigen#"/>
					<cfinvokeargument name="Eperiodo" value="#Periodo#"/>
					<cfinvokeargument name="Emes" value="#Mes#"/>
					<cfinvokeargument name="Efecha" value="#fecha#"/>
					<cfinvokeargument name="Edescripcion" value="#descripcion#"/>
					<cfinvokeargument name="Edocbase" value="#Lvar_Doc#"/>
					<cfinvokeargument name="Ereferencia" value="#Lvar_Ref#"/>
					<cfinvokeargument name="Debug" value="false"/>
					<cfinvokeargument name="Ocodigo" value="#LvarOficina#"/>
				</cfinvoke>
				
	
				<!--- Inserta en la bitacora --->
				<cfquery datasource="#Arguments.Conexion#" name="datos_asiento">
				Insert into DCAsientos(IDgd,Ecodigo,Eperiodo,Emes,IDContable)
				values(
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Idgrp#">,
						#Arguments.Ecodigo#,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.periodo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.mes#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#res_GeneraAsiento#">
					  )
				</cfquery>
				
				<cfquery datasource="#session.dsn#" name="datos_asiento">
				select Cconcepto,  Edocumento
				from EContables
				where IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#res_GeneraAsiento#">
					and Ecodigo  = #Arguments.Ecodigo#
				</cfquery>
				
				<cfset VCconcepto = datos_asiento.Cconcepto>
				<cfset VEdocumento = datos_asiento.Edocumento>				
				
				<cftransaction action="commit"/>
				
				<cfset LvarMSG = VCconcepto & "-" & VEdocumento>
				
				<cfcatch type="any">
					<cfinclude template="../errorPages/BDerror.cfm"> 
					<cftransaction action="rollback" />
					<cf_abort errorInterfaz="">
				</cfcatch>
				</cftry>
				</cftransaction>		
				
		</cfif>
		<cfreturn LvarMSG>

	</cffunction>
</cfcomponent>		

