<cfsetting requesttimeout="3600">
<link href="/cfmx/plantillas/login02/sif_login02.css" rel="stylesheet" type="text/css">
<cfinclude template="../../Utiles/sifConcat.cfm">
<cfset INICIO = Now()>
<!--- ---------------------------------------------
----	Activa Debug al cfm			---
	<cfset Session.debug = false>
----------------------------------------------- --->

<cfif isdefined("Form.btnCierre")>
	<cftry>

		<cfset Idgrp = #form.IDgd#>

		<!--- Si para el grupo periodo mes hay un asiento sin postear no se puede generar la distribucion --->
		<cfquery datasource="#Session.DSN#" name="sqlVerificaAsientos">
			select a.IDContable
			from DCAsientos a
				inner join EContables b
					on  b.IDcontable = a.IDContable	
			where a.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			  and a.Eperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.periodo#">
			  and a.Emes     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.mes#">
			  and a.IDgd     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Idgrp#">
		</cfquery>

		
		<cfif sqlVerificaAsientos.recordcount eq 0>
		
			<!--- Crea una tabla temporal para mantener las cuentas --->					 
			<cf_dbtemp name="DT_CUENTASORG" returnvariable="MOVIMIENTOS_CTAS_ORG" datasource="#Session.DSN#">
				<cf_dbtempcol name="ID"   	 type="numeric"	     identity="yes">
				<cf_dbtempcol name="Periodo"     type="int"	     mandatory="yes">
				<cf_dbtempcol name="Mes"   	 type="int"  	     mandatory="yes">
				<cf_dbtempcol name="Ocodigo" 	 type="int"  	     mandatory="yes">
				<cf_dbtempcol name="Ccuenta" 	 type="numeric"      mandatory="yes">
				<cf_dbtempcol name="CcuentaLiq"	 type="numeric"      mandatory="no">
				<cf_dbtempcol name="Cformato"    type="varchar(100)" mandatory="yes">
				<cf_dbtempcol name="MontoDist"   type="money"	     mandatory="yes">
				<cf_dbtempcol name="Complemento" type="varchar(100)" mandatory="no">
				<cf_dbtempcol name="CformatoLiq" type="varchar(100)" mandatory="no">
	
				<cf_dbtempkey cols="ID">
			</cf_dbtemp>
			<cfset Request.movctasorg = MOVIMIENTOS_CTAS_ORG>
	
			<cf_dbtemp name="DT_CUENTAS" returnvariable="MOVIMIENTOS_CTAS_DEST" datasource="#Session.DSN#">
				<cf_dbtempcol name="ID"   	  type="numeric"      identity="yes">
				<cf_dbtempcol name="Periodo"      type="int"	      mandatory="yes">
				<cf_dbtempcol name="Mes"   	  type="int"  	      mandatory="yes">
				<cf_dbtempcol name="Ccuenta" 	  type="numeric"      mandatory="yes">			
				<cf_dbtempcol name="CcuentaLiq"	  type="numeric"      mandatory="no">	
	 			<cf_dbtempcol name="Cformato"     type="char(100)"    mandatory="yes">
				<cf_dbtempcol name="Complemento"  type="varchar(100)" mandatory="no">
				<cf_dbtempcol name="Movimiento"   type="money"        mandatory="yes">
				<cf_dbtempcol name="Ocodigo" 	  type="int"          mandatory="yes">
				<cf_dbtempcol name="CDporcentaje" type="float"        mandatory="yes">
				<cf_dbtempcol name="MontoCal"     type="money"        mandatory="yes">
				<cf_dbtempcol name="CformatoLiq"  type="varchar(100)" mandatory="no">

				<cf_dbtempcol name="Id"		  type="int"          mandatory="no">
				<cf_dbtempcol name="canctas"	  type="int"          mandatory="no">
								
				<cf_dbtempkey cols="ID">
			</cf_dbtemp>
			<cfset Request.movctasdest = MOVIMIENTOS_CTAS_DEST>	

			<cf_dbtemp name="DT_CUENTASCOMP" returnvariable="MOVIMIENTOS_CTAS_COMP" datasource="#Session.DSN#">
				<cf_dbtempcol name="ID"   	  type="numeric"      identity="yes">
				<cf_dbtempcol name="Periodo"      type="int"	      mandatory="yes">
				<cf_dbtempcol name="Mes"   	  type="int"  	      mandatory="yes">
				<cf_dbtempcol name="CcuentaLiq"	  type="numeric"      mandatory="no">	
				<cf_dbtempcol name="Complemento"  type="varchar(100)" mandatory="no">
				<cf_dbtempcol name="Movimiento"   type="money"        mandatory="yes">
				<cf_dbtempcol name="Ocodigo" 	  type="int"          mandatory="yes">
				<cf_dbtempcol name="CDporcentaje" type="float"        mandatory="yes">
				<cf_dbtempcol name="MontoCal"     type="money"        mandatory="yes">
				<cf_dbtempcol name="CformatoLiq"  type="varchar(100)" mandatory="no">

				<cf_dbtempcol name="Id"		  type="int"          mandatory="no">
				<cf_dbtempcol name="canctas"	  type="int"          mandatory="no">
								
				<cf_dbtempkey cols="ID">
			</cf_dbtemp>
			<cfset Request.movctascomp = MOVIMIENTOS_CTAS_COMP>	


			<!------------------------ Busca datos para interfaz contable ------------------------>
			<!--- Consulta la Moneda Local --->
			<cfquery name="rstemp" datasource="#session.dsn#">
				select Mcodigo as Monloc
				from Empresas 
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			</cfquery>		

			<cfset Monloc = rstemp.Monloc>
			
			<!--- Consulta el Periodo en la tabla de parámetros--->
			<cfquery name="rstemp" datasource="#session.dsn#">
				select convert(int, Pvalor) as Periodo
				from Parametros
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				  and Pcodigo = 30
				  and Mcodigo = 'CG'
			</cfquery>

			<cfset Periodo = rstemp.Periodo>		
			<cfif len(trim(periodo)) eq 0>
				<cf_errorCode	code = "50057" msg = "Error 40001! No se pudo obtener el periodo. Proceso Cancelado!">
			</cfif>
			
			<!--- Consulta el Mes en la tabla de parámetros--->
			<cfquery name="rstemp" datasource="#session.dsn#">
				select convert(int, Pvalor) as Mes
				from Parametros
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				  and Pcodigo = 40
				  and Mcodigo = 'CG'
			</cfquery>

			<cfset Mes = rstemp.Mes>		

			<cfif len(trim(Mes)) eq 0>
				<cf_errorCode	code = "50057" msg = "Error 40001! No se pudo obtener el periodo. Proceso Cancelado!">
			</cfif>		
	
			<!--- CREA LA TABLA INTARC --->		
			<cfinvoke component="sif.Componentes.CG_GeneraAsiento" 
				method="CreaIntarc" 
				returnvariable="INTARC">
			</cfinvoke>

			<cfset VOorigen = 'CGDS'>

			<!--- Determina distribuciones que forman parte del Grupo --->
			<cfquery datasource="#Session.DSN#" name="sqlDistGrupos">
				Select a.IDgd, IDdistribucion, Tipo, Oorigen, a.DCdescripcion as NomGrp, b.EliNeg as EliNeg
				from DCGDistribucion a, DCDistribucion b
				where a.Ecodigo = b.Ecodigo
				  and a.IDgd = b.IDgd
				  and a.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				  and a.IDgd = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Idgrp#">
				  and exists (
						Select 1 
						from DCCtasOrigen  c
						where c.IDdistribucion = b.IDdistribucion
						) 
			</cfquery>
			
			<cfset NomGrupo = sqlDistGrupos.NomGrp>

			<cfset fecha = ltrim(LSDateFormat(Now(),"mmm dd yyyy")) & " 12:00:00AM">		
			<cfset descripcion = "Distribucion de Saldos Contables para el grupo: " & #NomGrupo#>

			<!--- Obtiene consecutivo de interfaz para el de asiento --->
			<cfinvoke component= "sif.Componentes.OriRefNextVal"
				method		= "nextVal"
				returnvariable	= "LvarNumDoc"
				ORI		= "#VOorigen#"
				REF		= "DST_SAL"			/>

			<cfset Lvar_Doc = LvarNumDoc>
			<cfset Lvar_Ref = "DST_SAL">

			<!--- Ciclo para procesar 1 a 1 las distribuciones del Grupo --->			
			<cfloop query="sqlDistGrupos">

				<cfset errororigen = false>
				<cfset errordestino = false>
	
				<cfset VIDdistribucion = sqlDistGrupos.IDdistribucion>

				<!--- OBTIENE EL TIPO DE LA DISTRIBUCION --->		
				<cfset Dt_tipo = sqlDistGrupos.Tipo>
	
				<!--- PROCESO DE DISTRIBUCION --->

				<!--- ------------------------------------------------------------------------- --->
				<!--- 	1. Obtiene el monto a distribuir basado en las cuentas Origen		--->	
				<!--- ------------------------------------------------------------------------- --->
				<cfquery datasource="#Session.DSN#">
					Insert into #Request.movctasorg#(
						Periodo,	Mes,		Ocodigo,	Ccuenta,	
						Cformato,	MontoDist,	Complemento,	CformatoLiq
						)
					select 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.periodo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.mes#">,
						a.Ocodigo,
						b.Ccuenta,
						b.Cformato,
						coalesce((
							select sum(c.DLdebitos - c.CLcreditos)
							from SaldosContables c
							where c.Ccuenta = b.Ccuenta
							  and c.Speriodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.periodo#">
							  and c.Smes     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.mes#">
							  and c.Ocodigo  = a.Ocodigo
						), 0.00) * (CDporcentaje/100) as MontoDist, 
						CDcomplemento, 
						null as  CformatoLiq
					from DCCtasOrigen a
						inner join CContables b
						   on b.Ecodigo = a.Ecodigo
							and b.Cformato >= left(a.CDformato, 4)
							and b.Cformato <= left(a.CDformato, 4) #_Cat# '9'
						    and b.Cformato like a.CDformato
					where a.IDdistribucion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#VIDdistribucion#">
					  and a.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				</cfquery>

				<cfquery datasource="#Session.DSN#">
					delete from #Request.movctasorg#
					where MontoDist = 0
				</cfquery>

				<cfquery datasource="#Session.DSN#" name="sqlMontoDist">
					Select coalesce(sum(MontoDist),0) as MontoDist 
					from #Request.movctasorg#
				</cfquery>
				
				<cfset montodistribuir = sqlMontoDist.MontoDist>

				<cfif montodistribuir eq 0>
					<cf_errorCode	code = "50365" msg = "El monto a distribuir es cero. Por Favor verifique. No es posible realizar la distribucion.">
				</cfif>
	
				<!--- Define la cuenta a liquidar, igual al formato de la cuenta porque no existe complemento --->
				<cfquery datasource="#Session.DSN#">
					Update #Request.movctasorg#
					set CformatoLiq = Cformato
					where Complemento is null
				</cfquery>				
	
				<!--- Define la cuenta a liquidar, igual al complemento de la cuenta porque no existen caracteres de sustitución --->
				<cfquery datasource="#Session.DSN#">
					Update #Request.movctasorg#
					set CformatoLiq = Complemento
					where Complemento is not null
					  and charindex('_',Complemento) = 0 
				</cfquery>					
				
				<!--- Sustituye (_) por digitos de acuerdo al complemento --->
				<cfquery datasource="#Session.DSN#" name="rsCCtas">
					Select ID, Cformato, Complemento 
					from #Request.movctasorg#
					where Complemento is not null
					  and charindex('_',Complemento) <> 0
				</cfquery>
	
				<cfloop query="rsCCtas">

					<cfset IDcta = rsCCtas.ID>
					<cfset ctaComplemento = rsCCtas.Complemento>
					<cfset ctaCformato = rsCCtas.Cformato>
					
					<cf_fusioncuentas cuentaorigen="#ctaCformato#" complemento="#ctaComplemento#" returnvariable="cuentaresultante">

					<cfquery datasource="#Session.DSN#" name="sqlActualizaTempCtas">
						Update #Request.movctasorg#
						set CformatoLiq = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cuentaresultante#">
						where ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDcta#">
					</cfquery>
				</cfloop>
				
				<!--- Actualiza el Ccuenta segun la cuenta complementada --->				
				<cfquery datasource="#Session.DSN#">
					Update #Request.movctasorg#
					set CcuentaLiq = (
							select a.Ccuenta
							from CContables a
							where a.Cformato = #Request.movctasorg#.CformatoLiq
							  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						)
					where CcuentaLiq is null
				</cfquery>

				<!--- Obtiene los CcuentaLiq que no existen y genera las cuentas --->
				<cfquery datasource="#Session.DSN#" name="rsCCtas">
					Select distinct CformatoLiq, #Request.movctasorg#.Ocodigo, b.Oficodigo
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
						<cfinvokeargument name="Lprm_CFformato" 		value="#rsCCtas.CformatoLiq#"/>
						<cfinvokeargument name="Lprm_Ocodigo" 			value="#rsCCtas.Ocodigo#"/>
						<cfinvokeargument name="Lprm_fecha" 			value="#LvarFecha#"/>
						<cfinvokeargument name="Lprm_Ecodigo" 			value="#Session.Ecodigo#"/>
						<cfinvokeargument name="Lprm_TransaccionActiva" value="no">
					</cfinvoke>

					<cfif LvarMSG neq "NEW" and LvarMSG neq "OLD">
						<cfset cuenta = cuenta+1>
						<cfif cuenta eq 1>
							
							<table  align="center" border="0" cellspacing="0" cellpadding="0" width="90%">	
							<tr>
								<td colspan="3">
								
									<table id="cfportlet1" width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td colspan="3" valign="top">
										
											 <table width="100%" cellpadding="0" cellspacing="0">
											 <tr>
												<td width="26" class='portlet_thleft' align="left"  id="cfportlet1x" ><img  onClick="cfportlet_toggleTable('1');" style="cursor:pointer;" alt="Haga click para ocultar" title="Haga click para ocultar" src="/cfmx/home/menu/portlets/wh_rt.gif" width="15" height="16" border="0" id="cfportlet1toggle"></td>
												<td class='portlet_thcenter' align="center"	width="">Cuentas Origen con Errores</td>
												<td width="" align="right" class='portlet_thright' style="cursor:pointer;text-align:right"><img src="/cfmx/sif/imagenes/tabs/spacer.gif" width="16" height="1" alt="" /></td>
											</tr>
											</table>
											
										</td>
									</tr>
									</table>
								
								</td>
							</tr>								
							<tr>
								<td class="tituloListas" align="left" valign="bottom" width="30%">Cuenta</td>
								<td class="tituloListas" align="left" valign="bottom" width="10%">Oficina</td>
								<td class="tituloListas" align="left" valign="bottom">Error</td>
							</tr>
						</cfif>
						<tr class="listaNon" onmouseover="this.className='listaNonSel';" onmouseout="this.className='listaNon';">
							<cfoutput>
							<td align="left" class="pStyle_CMD" nowrap style="color:black;" onmouseover="javascript: window.status = ''; return true;" onmouseout="javascript: window.status = ''; return true;">#rsCCtas.CformatoLiq#</td>
							<td align="left" class="pStyle_CMD" nowrap style="color:black;" onmouseover="javascript: window.status = ''; return true;" onmouseout="javascript: window.status = ''; return true;">#rsCCtas.Oficodigo#</td>
							<td align="left" class="pStyle_CMD" nowrap style="color:black;" onmouseover="javascript: window.status = ''; return true;" onmouseout="javascript: window.status = ''; return true;">#LvarMSG#</td>
							</cfoutput>
						</tr>
						

					</cfif>
					
				</cfloop>
				
				<!--- Actualizar Ccuenta en la tabla origen con las nuevas cuentas generadas --->
				<cfquery datasource="#Session.DSN#">
					Update #Request.movctasorg#
					set CcuentaLiq = (
						select a.Ccuenta
						from CContables a
						where a.Cformato = #Request.movctasorg#.CformatoLiq
						  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						  and #Request.movctasorg#.CcuentaLiq is null
					 )
					where CcuentaLiq is null
				</cfquery>

				<cfquery datasource="#Session.DSN#" name="rsRevCCtas">
					Select distinct CformatoLiq, Ocodigo
					from #Request.movctasorg#
					where CcuentaLiq is null
					order by CformatoLiq, Ocodigo
				</cfquery>

				<cfif rsRevCCtas.recordcount gt 0>
					</table>
					<cfset errororigen = true>
				</cfif>

				<!--- ------------------------------------------------------------------------- --->
				<!--- 	2. Obtiene cuenta por cuenta el movimiento de las cuentas destino	--->	
				<!--- 			a exepcion de las que se excluyen.			--->	
				<!--- ------------------------------------------------------------------------- --->
				<cfquery datasource="#Session.DSN#">
					INSERT into #Request.movctasdest#(
							Periodo,     Mes, 	  Ccuenta, CcuentaLiq, 	 Cformato,
							Complemento, Movimiento,  Ocodigo, CDporcentaje, MontoCal, 
							CformatoLiq, Id,	  canctas
							)
					select 	
						#form.periodo#, 
						#form.mes#, 
						cc.Ccuenta,	 
						null,	
						cc.Cformato,
						cd.CDcomplemento,
						coalesce ((select sum(sc.DLdebitos - sc.CLcreditos)
							   from SaldosContables sc
							   where sc.Ccuenta  = cc.Ccuenta
							     and sc.Speriodo = #form.periodo#
							     and sc.Smes     = #form.mes#
							     and sc.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
							     and sc.Ocodigo  = cd.Ocodigo),0.00) as mov,
						cd.Ocodigo, 
						cd.CDporcentaje, 
						$0.00, 
						null,
						cd.Id,
						0
					from DCCtasDestino cd
						inner join CContables cc 
							 on cc.Ecodigo = cd.Ecodigo
							and cc.Cformato >= left(cd.CDformato, 4)
							and cc.Cformato <= left(cd.CDformato, 4) #_Cat# '9'
							and cc.Cformato like cd.CDformato
					where cd.IDdistribucion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#VIDdistribucion#">
					  and cd.Ecodigo        = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
					  and cd.CDexcluir      = 0
					  and not exists (
					  		select 1
							from DCCtasDestino e
							where e.IDdistribucion  = 	cd.IDdistribucion
							  and e.Ecodigo         = 	cd.Ecodigo
							  and cc.Cformato 	like 	e.CDformato
							  and cc.Ecodigo 	= 	e.Ecodigo
							  and e.CDexcluir 	= 		1
							  )
				</cfquery>

				<cfquery datasource="#Session.DSN#">
					delete from #Request.movctasdest#
					where Movimiento = 0
				</cfquery>

				<!--- Define la cuenta a liquidar, igual al formato de la cuenta porque no existe complemento --->
				<cfquery datasource="#Session.DSN#">
					Update #Request.movctasdest#
					set CformatoLiq = Cformato
					where Complemento is null
				</cfquery>
	
				<!--- Define la cuenta a liquidar, igual al complemento de la cuenta porque no existen caracteres de sustitución --->
				<cfquery datasource="#Session.DSN#">
					Update #Request.movctasdest#
					set CformatoLiq = Complemento
					where Complemento is not null
					  and charindex('_',Complemento) = 0 
				</cfquery>
				
				<!--- Sustituye (_) por digitos de acuerdo al complemento, cuando aplica, es decir, cuando existe complemento --->
				<cfquery datasource="#Session.DSN#" name="rsCCtas">
					Select ID, Cformato, Complemento 
					from #Request.movctasdest#
					where Complemento is not null
					  and charindex('_',Complemento) <> 0 
				</cfquery>
					
				<cfloop query="rsCCtas">

					<cfset ctaComplementoD = rsCCtas.Complemento>
					<cfset ctaCformatoD = rsCCtas.Cformato>
					<cfset IDctaD = rsCCtas.ID>
					
					<cf_fusioncuentas cuentaorigen="#ctaCformatoD#" complemento="#ctaComplementoD#" returnvariable="cuentaresultanteD">
					
					<cfquery datasource="#Session.DSN#" name="sqlActualizaTempCtas">
						Update #Request.movctasdest#
						set CformatoLiq = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cuentaresultanteD#">
						where ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDctaD#">
					</cfquery>
				</cfloop>

				<cfquery datasource="#Session.DSN#">
					Update #Request.movctasdest#
					set CcuentaLiq = (
							select a.Ccuenta
							from CContables a
							where a.Cformato = #Request.movctasdest#.CformatoLiq
							  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						)
				</cfquery>

				<!--- Obtiene los CcuentaLiq que no se actualizaron porque la cuenta no existe --->
				<cfquery datasource="#Session.DSN#" name="rsCCtasD">
					Select distinct CformatoLiq, #Request.movctasdest#.Ocodigo, b.Oficodigo
					from #Request.movctasdest#, Oficinas b
					where CcuentaLiq is null
					  and #Request.movctasdest#.Ocodigo = b.Ocodigo
				</cfquery>

				<cfset cuenta = 0>
				<cfloop query="rsCCtasD">
					
					<cfinvoke 
						 component="sif.Componentes.PC_GeneraCuentaFinanciera"
						 method="fnGeneraCuentaFinanciera"
						 returnvariable="LvarMSG">
						<cfinvokeargument name="Lprm_CFformato" 		value="#rsCCtasD.CformatoLiq#"/>
						<cfinvokeargument name="Lprm_Ocodigo" 			value="#rsCCtasD.Ocodigo#"/>
						<cfinvokeargument name="Lprm_fecha" 			value="#LvarFecha#"/>
						<cfinvokeargument name="Lprm_Ecodigo" 			value="#Session.Ecodigo#"/>
						<cfinvokeargument name="Lprm_TransaccionActiva" value="no">
					</cfinvoke>

					<cfif LvarMSG neq "NEW" and LvarMSG neq "OLD">
						<cfset cuenta = cuenta+1>
						<cfif cuenta eq 1>
							<table  align="center" border="0" cellspacing="0" cellpadding="0" width="90%">	
							<tr>
								<td colspan="3">
								
									<table id="cfportlet1" width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td colspan="3" valign="top">
										
											 <table width="100%" cellpadding="0" cellspacing="0">
											 <tr>
												<td width="26" class='portlet_thleft' align="left"  id="cfportlet1x" ><img  onClick="cfportlet_toggleTable('1');" style="cursor:pointer;" alt="Haga click para ocultar" title="Haga click para ocultar" src="/cfmx/home/menu/portlets/wh_rt.gif" width="15" height="16" border="0" id="cfportlet1toggle"></td>
												<td class='portlet_thcenter' align="center"	width="">Cuentas Destino con Errores</td>
												<td width="" align="right" class='portlet_thright' style="cursor:pointer;text-align:right"><img src="/cfmx/sif/imagenes/tabs/spacer.gif" width="16" height="1" alt="" /></td>
											</tr>
											</table>
											
										</td>
									</tr>
									</table>
								</td>
							</tr>							
							<tr>
								<td class="tituloListas" align="left" valign="bottom" width="30%">Cuenta</td>
								<td class="tituloListas" align="left" valign="bottom" width="10%">Oficina</td>
								<td class="tituloListas" align="left" valign="bottom">Error</td>
							</tr>
						</cfif>
						<tr>
							<cfoutput>
							<td align="left" class="pStyle_CMD" nowrap style="color:black;" onmouseover="javascript: window.status = ''; return true;" onmouseout="javascript: window.status = ''; return true;">#rsCCtasD.CformatoLiq#</td>
							<td align="left" class="pStyle_CMD" nowrap style="color:black;" onmouseover="javascript: window.status = ''; return true;" onmouseout="javascript: window.status = ''; return true;">#rsCCtasD.Oficodigo#</td>
							<td align="left" class="pStyle_CMD" nowrap style="color:black;" onmouseover="javascript: window.status = ''; return true;" onmouseout="javascript: window.status = ''; return true;">#LvarMSG#</td>
							</cfoutput>
						</tr>
					</cfif>
				</cfloop>

				<!--- ---------------------------------------------------------------------
					Cuenta ya existe o se creo Actualizar Ccuenta en la tabla origen
				---------------------------------------------------------------------- --->
				<cfquery datasource="#Session.DSN#">
					Update #Request.movctasdest#
					set CcuentaLiq = a.Ccuenta
					from CContables a
					where a.Cformato = #Request.movctasdest#.CformatoLiq
					  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					  and #Request.movctasdest#.CcuentaLiq is null
				</cfquery>

				<cfquery datasource="#Session.DSN#" name="rsRevCCtasD">
					Select distinct CformatoLiq, Ocodigo
					from #Request.movctasdest#
					where CcuentaLiq is null
				</cfquery>

				<cfif rsRevCCtasD.recordcount gt 0>
					</table>
					<cfset errordestino = true>
				</cfif>

				<!--- --------------------------------------------------------- --->
				<!---		Borra las cuentas complementadas con monto	--->
				<!---			Acumulado es = 0			--->
				<!--- --------------------------------------------------------- --->
				<cfif isdefined("sqlDistGrupos.EliNeg") and sqlDistGrupos.EliNeg EQ "S">
					<cfquery datasource="#Session.DSN#">
						Delete from #Request.movctasdest# 
						where exists (select 1
							      from #Request.movctasdest# tmp
							      where tmp.CformatoLiq = #Request.movctasdest#.CformatoLiq
							      group by CformatoLiq
							      having sum(Movimiento) <= 0
							      )
					</cfquery>
				</cfif> 

				<!--- ------------------------------------------------------------------------- --->
				<!---	Optiene la suma de los porcentajes de las mascara para el proceso	--->
				<!---			de distribucion por peso relativo.			--->
				<!--- ------------------------------------------------------------------------- --->
				<cfquery datasource="#Session.DSN#" name="rsPorcentajes">
					Select sum(CDporcentaje) as SumTotPor
					from DCCtasDestino
					where IDdistribucion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#VIDdistribucion#">
					  and Ecodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				</cfquery>
				<cfset SumTotPor = #rsPorcentajes.SumTotPor#>

				<!--- ************************************************************************** --->
				<!--- ******** Inicio Proceso de distribucion para las cuentas obtenidas ******* --->
				<!--- ************************************************************************** --->
				<cfif Dt_tipo eq 2>
					<cfquery datasource="#Session.DSN#" name="rsValidaMascaras">
						Select 	(select Descripcion from DCDistribucion a where a.IDdistribucion = dc.IDdistribucion) as distrib,
							(select Oficodigo from Oficinas a where a.Ocodigo = dc.Ocodigo) as Oficina, 
							CDformato as formato
						from DCCtasDestino dc
						where dc.IDdistribucion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#VIDdistribucion#">
						  and not exists (select 1 
								  from #Request.movctasdest# tmp
								  where dc.Id = tmp.Id)
					</cfquery>

					<cfif isdefined("rsValidaMascaras") and rsValidaMascaras.recordcount GT 0>
						<cf_errorCode	code = "50359"
										msg  = "La mascara @errorDat_1@ de la oficina @errorDat_2@ distribucion @errorDat_3@ no tiene cuentas para distribuir"
										errorDat_1="#rsValidaMascaras.formato#"
										errorDat_2="#rsValidaMascaras.Oficina#"
										errorDat_3="#rsValidaMascaras.distrib#"
						>
						<cfabort>
					</cfif>
				</cfif>

				<cfquery datasource="#Session.DSN#" name="rsValCantCtas">
					Select count(1) as Cantidad
					from #Request.movctasdest# 
				</cfquery>

				<cfif isdefined("rsValCantCtas") and rsValCantCtas.recordcount EQ 0>	
					<cf_errorCode	code = "50360" msg = "No hay cuentas destino para la distribución.">
				</cfif>

				<!--- --------------------------------------------------------------------------------- --->
				<!---		Se Agrupan las cuentas complementadas en tabla movctascomp		--->
				<!---		   Para realizar el proceso de distribucion sobre las  			--->
				<!---		   cuentas Finales con las que se generará el asiento 			--->
				<!--- --------------------------------------------------------------------------------- --->

				<cfquery datasource="#Session.DSN#" >
					insert #Request.movctascomp# (
							Periodo,	Mes, 		CcuentaLiq, 	Complemento,	Movimiento,	
							Ocodigo,	CDporcentaje,	MontoCal, 
							CformatoLiq,	Id,		canctas
						)
					select 		Periodo,	Mes, 		CcuentaLiq, 	Complemento,	sum(Movimiento),	
							Ocodigo,	CDporcentaje,	MontoCal, 	
							CformatoLiq,	Id,		count(1)
					from #Request.movctasdest# 
					group by	Periodo,	Mes, 		CcuentaLiq, 	Complemento,	
							Ocodigo,	CDporcentaje,	MontoCal, 	CformatoLiq,	Id
							
				</cfquery>

				<!--- ------------------------------------------------------------------------------------ --->
				<!---		3. Calcula del monto para cada una de las cuentas Destino		   --->
				<!---				segun el Monto a Distribuir				   --->
				<!--- ------------------------------------------------------------------------------------ --->

				<cfquery datasource="#Session.DSN#" name="sqltotalcts">
					Select count(1) as totalct from #Request.movctascomp#
				</cfquery>
				
				<cfquery datasource="#Session.DSN#" name="sqltotalacum">
					Select 	sum(Movimiento) as total, 
						sum(CDporcentaje) as totalpesos 
					from #Request.movctascomp#
				</cfquery>

				<cfset totcuentas = sqltotalcts.totalct>	<!--- Cantidad Total de cuentas para uso en la distribucion --->
				<cfset totalacumulado = sqltotalacum.total>	<!--- Suma del movimiento Total de las cuentas destino --->
				<cfset totalpesos = sqltotalacum.totalpesos>	<!--- Suma Total de los pesos distribudios  --->

				<cfif Dt_tipo eq 1>
					<!---Peso de la cuenta --->
					<cfquery datasource="#Session.DSN#">
						Update #Request.movctascomp#
						set MontoCal = round((Movimiento / #totalacumulado#) * #montodistribuir#,2)
					</cfquery>

				<cfelseif Dt_tipo eq 2>
					<!---Peso Relativo--->
					<cfquery datasource="#Session.DSN#">
						Update #Request.movctascomp#
						set MontoCal = round(  (convert(float, Movimiento) / convert(float, (select sum(Movimiento) 
															from #Request.movctascomp# b 
															where b.Id = #Request.movctascomp#.Id))
									)
									* (#montodistribuir# * (CDporcentaje / 100))
								, 2)
					</cfquery>				

				<cfelseif Dt_tipo eq 3>
					<!---Equivalente--->			
					<cfquery datasource="#Session.DSN#">
						Update #Request.movctascomp#	
						set MontoCal = round((#montodistribuir# / #totcuentas#), 2)
					</cfquery>					
				</cfif>

				<!----
				<cfquery datasource="#Session.DSN#" name="rstest">
					Select 
						ID,
						Periodo,
						Mes,
						Ccuenta,
						CcuentaLiq,
						Cformato,
						Complemento,
						Movimiento,
						Ocodigo,
						CDporcentaje,
						MontoCal,
						CformatoLiq,
						Id as idmascara,
						canctas
					/*into datos_mac*/
					from #Request.movctasdest#
				</cfquery>
				<cfdump var = "#montodistribuir#">
				<cfdump var = "#rstest#">
				<cfabort>

				<cfquery datasource="#Session.DSN#" name="rstest">
					Select 
						Periodo,	
						Mes, 		
						CcuentaLiq, 	
						Complemento,	
						Movimiento,	
						Ocodigo,	
						CDporcentaje,	
						MontoCal, 	
						CformatoLiq,	
						Id,
						canctas
					/*into datos_mac*/
					from  #Request.movctascomp#
				</cfquery>
				<cfdump var = "#montodistribuir#">
				<cfdump var = "#rstest#">
				<cfabort>

				---->

				<!--- --------------------------------- --->
				<!---	 GENERA EL ASIENTO CONTABLE	--->
				<!--- --------------------------------- --->
			
				<!--- --------------------------------- --->
				<!--- INCLUYE LOS DEBITOS Y CREDITOS	--->
				<!--- CUENTAS OIRIGEN AL CREDITO	--->
				<!--- --------------------------------- --->
				<cfquery name="rstemp" datasource="#Session.DSN#">

					insert #INTARC# ( 
							INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, 
							INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE
							)
					select 
						'#VOorigen#',
						1,
						'#Lvar_Doc#',
						'#Lvar_Ref#',
						sum(a.MontoDist),
						'C',
						b.Cdescripcion,
						getdate(),
						1,
						a.Periodo, 
						a.Mes,
						a.CcuentaLiq,
						<cfqueryparam value="#Monloc#" cfsqltype="cf_sql_numeric">,
						a.Ocodigo,
						sum(a.MontoDist)
					from #Request.movctasorg# a, CContables b
					where a.CcuentaLiq = b.Ccuenta	
					group by b.Cdescripcion, a.Periodo, a.Mes, a.CcuentaLiq, a.Ocodigo

				</cfquery>

				<!--- CUENTAS DESTINO AL DEBITO --->
				<cfquery name="rstemp" datasource="#Session.DSN#">
					insert #INTARC# ( 
							INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, 
							INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE
							)
					select 
						'#VOorigen#',
						1,
						'#Lvar_Doc#',
						'#Lvar_Ref#',
						a.MontoCal,
						'D',
						b.Cdescripcion,
						getdate(),
						1,
						a.Periodo,
						a.Mes,
						a.CcuentaLiq,
						<cfqueryparam value="#Monloc#" cfsqltype="cf_sql_numeric">,
						a.Ocodigo,
						a.MontoCal
					from #Request.movctascomp# a, CContables b
					where a.CcuentaLiq = b.Ccuenta
				</cfquery>

			
				<!--- Cuentas de Relacion (Balance por Oficina) --->
				<!--- Verifica si hay Cuentas de Relacion --->
				<cfquery name="rsHayCuentasBalanceOficina" datasource="#session.dsn#">
					select 1
					from CuentaBalanceOficina
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				</cfquery>		

				<cfif rsHayCuentasBalanceOficina.recordcount GT 0>
			
					<!--- Obtiene las oficinas diferentes a las del origen --->
			
					<cfquery name="rsrevisaoficinas" datasource="#session.dsn#">
						Select  distinct b.Ocodigo as Ofiorigen, c.Ocodigo as Ofidestino
						from DCDistribucion a, DCCtasOrigen b, DCCtasDestino  c
						where a.IDdistribucion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#VIDdistribucion#">
						  and a.Ecodigo =	<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
						  and a.IDdistribucion = b.IDdistribucion
						  and a.Ecodigo = b.Ecodigo
						  and b.IDdistribucion = c.IDdistribucion
						  and b.Ecodigo = c.Ecodigo
						  and b.Ocodigo != c.Ocodigo		
					</cfquery>
				
					<cfif rsrevisaoficinas.recordcount gt 0>
						
						<!--- Se crean las Cuentas de Relacion (Balance por Oficina) --->
						<cfloop query="rsrevisaoficinas">
						
							<cfset Oficina_org = rsrevisaoficinas.Ofiorigen>
							<cfset Oficina_dest = rsrevisaoficinas.Ofidestino>
							
							<cfquery datasource="#session.dsn#" name="rsofi1">
							Select Oficodigo 
							from Oficinas 
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
							  and Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Oficina_org#">
							</cfquery>
							
							<cfquery datasource="#session.dsn#" name="rsofi2">
							Select Oficodigo 
							from Oficinas 
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
							  and Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Oficina_dest#">
							</cfquery>
												
							<cfset Oficodigo1 = rsofi1.Oficodigo>
							<cfset Oficodigo2 = rsofi2.Oficodigo>
							
							
							<!--- Obtiene la cuenta por cobrar --->
							<cfquery name="rsCuentaPorCobrar" datasource="#session.dsn#">
								select CFcuentacxc
								from CuentaBalanceOficina a
									inner join ConceptoContable b
									on b.Ecodigo = a.Ecodigo
									and b.Cconcepto = a.Cconcepto
									and b.Oorigen = '#VOorigen#'
								where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
								and Ocodigoori = <cfqueryparam cfsqltype="cf_sql_integer" value="#Oficina_org#">
								and Ocodigodest = <cfqueryparam cfsqltype="cf_sql_integer" value="#Oficina_dest#">
							</cfquery>
							<!--- Obtiene la cuenta por pagar --->
							<cfquery name="rsCuentaPorPagar" datasource="#session.dsn#">
								select CFcuentacxp
								from CuentaBalanceOficina a
									inner join ConceptoContable b
									 on b.Ecodigo   = a.Ecodigo
									and b.Cconcepto = a.Cconcepto
									and b.Oorigen   = '#VOorigen#'
								where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
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
							<cfquery datasource="#session.dsn#">
								insert #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, CFcuenta, Ccuenta, Mcodigo, Ocodigo, INTMOE)
								select 
										'#VOorigen#', 
										1, 
										<cf_dbfunction name="to_char" args="#Lvar_Doc#">, 
										'#Lvar_Ref#',									
										sum(a.MontoCal),
										'D', 
										'Balance Oficina, Cuenta por Cobrar a la Oficina (#Oficodigo2#)', 
										getdate(), 
										1.00,  
										a.Periodo, 
										a.Mes, 
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCuentaPorCobrar.CFcuentacxc#">, 
										0,
										<cfqueryparam value="#Monloc#" cfsqltype="cf_sql_numeric">,
										<cfqueryparam cfsqltype="cf_sql_integer" value="#Oficina_org#">, 
										sum(a.MontoCal)
								
								from #Request.movctascomp# a
								where a.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Oficina_dest#">
								group by a.Periodo, a.Mes
							</cfquery>

							<!--- 2.3.10 Crédito, Balance Oficina, Cuenta Pagar a la Oficina 1 --->
							<cfquery datasource="#session.dsn#">
								insert #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, CFcuenta, Ccuenta, Mcodigo, Ocodigo, INTMOE)
								select 
										'#VOorigen#', 
										1, 
										<cf_dbfunction name="to_char" args="#Lvar_Doc#">, 
										'#Lvar_Ref#',
										sum(a.MontoCal),
										'C', 
										'Balance Oficina, Cuenta por Pagar a la Oficina (#Oficodigo1#)', 
										getdate(), 
										1.00,  
										a.Periodo, 
										a.Mes, 
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCuentaPorPagar.CFcuentacxp#">, 
										0,
										<cfqueryparam value="#Monloc#" cfsqltype="cf_sql_numeric">,
										<cfqueryparam cfsqltype="cf_sql_integer" value="#Oficina_dest#">, 
										sum(a.MontoCal)
								
								from #Request.movctascomp# a
								where a.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Oficina_dest#">
								group by a.Periodo, a.Mes			
							</cfquery>					
						
						</cfloop>
				
					</cfif>
					
				</cfif>

				<!--- Borra datos de cuentas para seguir ciclo con sig. distribucion del grupo. --->
				<cfquery datasource="#session.dsn#">
					delete from #Request.movctasdest# 
				</cfquery>
				<cfquery datasource="#session.dsn#">
					delete from #Request.movctasorg# 
				</cfquery>
				<cfquery datasource="#session.dsn#">
					delete from #Request.movctascomp# 
				</cfquery>

			</cfloop>

			
			<!--- Obtiene la diferencia si es que existe --->
			<cfquery name="rsDiferenciaDeb" datasource="#session.dsn#">
				Select sum(INTMON) as MontoDebitos
				from #INTARC#
				where INTTIP = 'D'
			</cfquery>

			<cfquery name="rsDiferenciaCre" datasource="#session.dsn#">
				Select sum(INTMON) as MontoCreditos
				from #INTARC#
				where INTTIP = 'C'
			</cfquery>

			<cfset diferencia = rsDiferenciaDeb.MontoDebitos - rsDiferenciaCre.MontoCreditos>

			<cfif errordestino or errororigen>
				<cfoutput>
					INICIO: #INICIO#  FIN: #Now()#
				</cfoutput>
				<cfabort>
			</cfif>	

			<cfif abs(diferencia) gt 5>
				<cf_errorCode	code = "50364" msg = "El asiento se encuentra desbalanceado por mas de 5 colon.">
			</cfif>

			<!--- Le suma la diferencia a la cuenta de mayor monto --->
			<cfquery name="rsMaximaCta" datasource="#session.dsn#">
				Select Max(INTMON) as MaximoMonto
				from #INTARC#
				where Ccuenta != 0
				  and INTTIP = 'D'
			</cfquery>

			<cfset MaxMnt = rsMaximaCta.MaximoMonto>

			<cfquery name="rsMaximaCtaLn" datasource="#session.dsn#">
				Select INTLIN from #INTARC# where INTMON = #MaxMnt# and INTTIP = 'D'
			</cfquery>

			<cfset linea = rsMaximaCtaLn.INTLIN>

			<cfquery name="rsActMaximaCta" datasource="#session.dsn#">
				Update #INTARC#
				set INTMON = INTMON - #diferencia#,
				    INTMOE = INTMOE - #diferencia#
				where INTLIN = #linea#
			</cfquery>


			<!--- 
			<cfquery name="rsDatosIntarc" datasource="#session.dsn#">
				Select 
					INTLIN									as linea, 
					(select Oficodigo from Oficinas o where o.Ocodigo = a.Ocodigo)		as Oficina,
					(select Cformato from CContables cc where cc.Ccuenta = a.Ccuenta)	as cuenta, 
					INTDES									as descripcion,
					case when INTTIP = 'D' then INTMON else 0.00 end			as debitos,
					case when INTTIP = 'C' then INTMON else 0.00 end			as creditos
				from #INTARC#  a
			</cfquery>

			<cfdump var= "#rsDatosIntarc#">
			<cfabort>
			--->




			<cftransaction action="begin">
			<cftry>
			
				<!--- Genera el Asiento --->
				<cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="GeneraAsiento" returnvariable="res_GeneraAsiento">
					<cfinvokeargument name="Ecodigo" value="#Session.Ecodigo#"/>
					<cfinvokeargument name="Oorigen" value="#VOorigen#"/>
					<cfinvokeargument name="Eperiodo" value="#Periodo#"/>
					<cfinvokeargument name="Emes" value="#Mes#"/>
					<cfinvokeargument name="Efecha" value="#fecha#"/>
					<cfinvokeargument name="Edescripcion" value="#descripcion#"/>
					<cfinvokeargument name="Edocbase" value="#Lvar_Doc#"/>
					<cfinvokeargument name="Ereferencia" value="#Lvar_Ref#"/>
					<cfinvokeargument name="Debug" value="false"/>
				</cfinvoke>
				

				<!--- Inserta en la bitacora --->
				<cfquery datasource="#session.dsn#" name="datos_asiento">
				Insert into DCAsientos(IDgd,Ecodigo,Eperiodo,Emes,IDContable)
				values(
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Idgrp#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.periodo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.mes#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#res_GeneraAsiento#">
					  )
				</cfquery>
		
				<cfquery datasource="#session.dsn#" name="datos_asiento">
				select Cconcepto,  Edocumento
				from EContables
				where IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#res_GeneraAsiento#">
					and Ecodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				</cfquery>
				
				<cfset VCconcepto = datos_asiento.Cconcepto>
				<cfset VEdocumento = datos_asiento.Edocumento>
				
				<cftransaction action="commit"/>
			
			<cfcatch type="any">
				<cfinclude template="../../errorPages/BDerror.cfm"> 
				<cftransaction action="rollback" />
				<cfabort>
			</cfcatch>
			</cftry>
			
			</cftransaction>

			<cfset genero_asiento = true>

		<cfelse>

			<cfquery datasource="#session.dsn#" name="datos_asiento">
			select Cconcepto,  Edocumento
			from EContables
			where IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#sqlVerificaAsientos.IDContable#">
				and Ecodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			</cfquery>
			
			<cfset VCconcepto = datos_asiento.Cconcepto>
			<cfset VEdocumento = datos_asiento.Edocumento>				
		
			<cfset genero_asiento = false>
			
		</cfif>

		<cfset showMessage="true">
	<cfcatch type="any">
		<cfinclude template="../../errorPages/BDerror.cfm"> 		
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>

<cf_template template="#session.sitio.template#">
	<script  language="JavaScript" src="/cfmx/sif/js/DHTMLMenu/stm31.js"></script>

	<cf_templatearea name="title">
		Distribucion de Cuentas
	</cf_templatearea>
	
	<cf_templatearea name="body">

<cf_templatecss>
<link href="../../css/rh.css" rel="stylesheet" type="text/css">

	<cf_web_portlet skin="#Session.Preferences.Skin#" titulo="Distribuciones">
	
	
		<center>
		<br>
		<cfoutput>
		<cfif genero_asiento>
		
			El Proceso de Distribución para el grupo: <strong>#NomGrupo#</strong> del Periodo: <strong>#form.periodo#</strong>, Mes: <strong>#form.mes#</strong> se ha realizado exitosamente.
			<br>El asiento correspondiente a la distribucion es: <strong>#VCconcepto# - #VEdocumento#</strong>
		
		<cfelse>

			No es posible realizar el proceso de Distribución, porque el asiento contable <strong>#VCconcepto# - #VEdocumento#</strong> del
			Periodo: <strong>#form.periodo#</strong>, Mes: <strong>#form.mes#</strong> esta pendiente de postear.

		</cfif>
		</cfoutput>		
		<br><br>
		<form action="/cfmx/sif/dc/catalogos/formgrupos.cfm" method="post" name="sql">
			<cfif isdefined("showMessage")>
				<input name="showMessage" type="hidden" value="true">
			</cfif>
			<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")><cfoutput>#Form.Pagina#</cfoutput></cfif>">
			<input type="submit" name="btncerrar" value="Regresar">
		</form>
		</center>
	
	</cf_web_portlet>

</cf_templatearea>
</cf_template>
<!---
<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
--->

