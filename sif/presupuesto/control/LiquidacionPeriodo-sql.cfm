<cfsetting requesttimeout="36000">
<cfif isdefined("Form.btnGenerar")>
	<cfset lstCtipo = "A,G,O,P,E,I">
	<cfset lstMtipo = "RC,CC">
	<cfloop index="LvarCtipo" list="#lstCtipo#">
		<cfloop index="LvarMtipo" list="#lstMtipo#">
			<cfif isdefined('form.TipoLiq_#LvarCtipo#_#LvarMtipo#')>
				<cfquery datasource="#Session.DSN#">
					update CPLiquidacionParametros 
					   set CPLtipoLiquidacion = <cfqueryparam cfsqltype="cf_sql_char" value="#evaluate('form.TipoLiq_#LvarCtipo#_#LvarMtipo#')#">
					 where Ecodigo 		= #session.Ecodigo#
					   and CPPid		= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CPPid#">
					   and Ctipo		= '#LvarCtipo#'
					   and CPNAPDtipoMov= '#LvarMtipo#'
				</cfquery>
			</cfif>
		</cfloop>
	</cfloop>
	<cfset fnGenerar()>
<cfelseif isdefined("Form.btnLiquidar")>
	<cfset LvarNow = now()>
	<cfset LvarTotales1 = fnTotales()>
	<cfset fnGenerar()>
	<cfset LvarTotales2 = fnTotales()>
	<cfif	LvarTotales1.Total_RC NEQ LvarTotales2.Total_RC
		OR 	LvarTotales1.Total_CC NEQ LvarTotales2.Total_CC
		OR 	LvarTotales1.Total_M  NEQ LvarTotales2.Total_M
		OR 	LvarTotales1.Total_SF NEQ LvarTotales2.Total_SF
		OR 	LvarTotales1.Total_ErrSD NEQ LvarTotales2.Total_ErrSD
		OR 	LvarTotales1.Total_ErrSC NEQ LvarTotales2.Total_ErrSC
	>
		<cf_errorCode	code = "50473" msg = "Se generó una nueva Liquidación, revísela antes de Aprobarla">
	</cfif>

	<cfinvoke 
		 component		= "sif.Componentes.PRES_Presupuesto"
		 method			= "CreaTablaIntPresupuesto">
			<cfinvokeargument name="conIdentity" value="yes"/>
	</cfinvoke>

	<cfquery datasource="#Session.DSN#">
		insert into #Request.intPresupuesto#
		(
			ModuloOrigen
			,NumeroDocumento
			,NumeroReferencia
			,FechaDocumento
			,AnoDocumento
			,MesDocumento

			,CPPid
			,CPCano , CPCmes
			,CPcuenta, Ocodigo, TipoMovimiento, Mcodigo
			,DisponibleAnterior
			,MontoOrigen, TipoCambio, Monto, SignoMovimiento
			,TipoControl, CalculoControl
		)
		select * from  (
			select 	'PRFO' as ModuloOrigen, 
					'#form.CPLnumeroLiquidacion#' as NumeroDocumento, 'LIQUIDACION' as NumeroReferencia, 
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarNow#"> as FD, #LvarAuxAno# as AnoDocumento, #LvarAuxMes# as MesDocumento,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CPPidNuevo#"> as CPPid,
					#LvarAuxAno# as CPCano, #LvarAuxMes# as CPCmes,
					l.CPcuenta, l.Ocodigo, 'M' as CPNAPDtipoMov, #rsEmpresa.Mcodigo# as Mcodigo, 
					l.CPLCdisponibleAntes as CPCNAPDdisponibleAnterior,
					l.CPLCmontoModificacion as CPNAPDmontoOri, 1 as CPNAPDtipoCambio, l.CPLCmontoModificacion as CPNAPDmonto, +1 as CPNAPDsigno,
					p.CPCPtipoControl, p.CPCPcalculoControl
			  from CPLiquidacionCuentas l
							inner join CPCuentaPeriodo p
								 on p.Ecodigo 	= l.Ecodigo
								and p.CPPid		= l.CPPid
								and p.CPcuenta	= l.CPcuenta
			 where l.Ecodigo				= #session.Ecodigo#
			   and l.CPPid					= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CPPid#">
			   and l.CPLnumeroLiquidacion 	= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CPLnumeroLiquidacion#">

			   and l.CPLCresultado = 0
			   and l.CPLCmontoModificacion > 0
			UNION
			select 	'PRFO', '#form.CPLnumeroLiquidacion#', 'LIQUIDACION', <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarNow#">, #LvarAuxAno#, #LvarAuxMes#,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CPPidNuevo#"> as CPPid,
					#LvarAuxAno# as CPCano, #LvarAuxMes# as CPCmes,
					l.CPcuenta, l.Ocodigo, 'RA' as CPNAPDtipoMov, #rsEmpresa.Mcodigo#, 
					l.CPLCdisponibleAntes+l.CPLCmontoModificacion as CPCNAPDdisponibleAnterior,
					l.CPLCmontoReservas as CPNAPDmontoOri, 1 as CPNAPDtipoCambio, l.CPLCmontoReservas as CPNAPDmonto, -1 as CPNAPDsigno,
					p.CPCPtipoControl, p.CPCPcalculoControl
			  from CPLiquidacionCuentas l
							inner join CPCuentaPeriodo p
								 on p.Ecodigo 	= l.Ecodigo
								and p.CPPid		= l.CPPid
								and p.CPcuenta	= l.CPcuenta
			 where l.Ecodigo				= #session.Ecodigo#
			   and l.CPPid					= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CPPid#">
			   and l.CPLnumeroLiquidacion 	= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CPLnumeroLiquidacion#">

			   and l.CPLCresultado = 0
			   and l.CPLCmontoReservas > 0
			UNION
			select 	'PRFO', '#form.CPLnumeroLiquidacion#', 'LIQUIDACION', <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarNow#">, #LvarAuxAno#, #LvarAuxMes#,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CPPidNuevo#"> as CPPid,
					#LvarAuxAno# as CPCano, #LvarAuxMes# as CPCmes,
					l.CPcuenta, l.Ocodigo, 'CA' as CPNAPDtipoMov, #rsEmpresa.Mcodigo#, 
					l.CPLCdisponibleAntes+l.CPLCmontoModificacion-
						case 
							when l.CPLCmontoReservas > 0 then l.CPLCmontoReservas
							else 0
						end as CPCNAPDdisponibleAnterior,
					l.CPLCmontoCompromisos as CPNAPDmontoOri, 1 as CPNAPDtipoCambio, l.CPLCmontoCompromisos as CPNAPDmonto, -1 as CPNAPDsigno,
					p.CPCPtipoControl, p.CPCPcalculoControl
			  from CPLiquidacionCuentas l
							inner join CPCuentaPeriodo p
								 on p.Ecodigo 	= l.Ecodigo
								and p.CPPid		= l.CPPid
								and p.CPcuenta	= l.CPcuenta
			 where l.Ecodigo				= #session.Ecodigo#
			   and l.CPPid					= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CPPid#">
			   and l.CPLnumeroLiquidacion 	= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CPLnumeroLiquidacion#">

			   and l.CPLCresultado = 0
			   and l.CPLCmontoCompromisos > 0
		) liq
		order by Ocodigo,CPcuenta,CPNAPDsigno desc, CPNAPDmonto asc
	</cfquery>

	<cftransaction>
		<cfquery name="rsSQL" datasource="#Session.DSN#">
			update 	CPresupuestoControl
			   set	CPCmodificado 				= CPCmodificado				+ 
			   		(
			   			select l.CPLCmontoModificacion
						  from CPLiquidacionCuentas l
						 where l.Ecodigo 				= CPresupuestoControl.Ecodigo
						   and l.CPPid					= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CPPid#">
						   and l.CPLnumeroLiquidacion 	= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CPLnumeroLiquidacion#">
						   and l.Ocodigo	= CPresupuestoControl.Ocodigo
   						   and l.CPcuenta	= CPresupuestoControl.CPcuenta
   						   and l.CPLCresultado = 0
					)
			     ,	CPCreservado_Anterior		= CPCreservado_Anterior		+ 
			   		(
			   			select l.CPLCmontoReservas
						  from CPLiquidacionCuentas l
						 where l.Ecodigo 				= CPresupuestoControl.Ecodigo
						   and l.CPPid					= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CPPid#">
						   and l.CPLnumeroLiquidacion 	= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CPLnumeroLiquidacion#">
						   and l.Ocodigo	= CPresupuestoControl.Ocodigo
   						   and l.CPcuenta	= CPresupuestoControl.CPcuenta
   						   and l.CPLCresultado = 0
					)
			     ,	CPCcomprometido_Anterior	= CPCcomprometido_Anterior	+ 
			   		(
			   			select l.CPLCmontoCompromisos
						  from CPLiquidacionCuentas l
						 where l.Ecodigo 				= CPresupuestoControl.Ecodigo
						   and l.CPPid					= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CPPid#">
						   and l.CPLnumeroLiquidacion 	= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CPLnumeroLiquidacion#">
						   and l.Ocodigo	= CPresupuestoControl.Ocodigo
   						   and l.CPcuenta	= CPresupuestoControl.CPcuenta
   						   and l.CPLCresultado = 0
					)
			 where Ecodigo		= #session.Ecodigo#
			   and CPPid		= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CPPidNuevo#">
			   and CPCano		= #LvarAuxAno#
			   and CPCmes		= #LvarAuxMes#
			   and 
					(	<!--- exists --->
						select count(1)
						  from CPLiquidacionCuentas l
						 where l.Ecodigo 				= CPresupuestoControl.Ecodigo
						   and l.CPPid					= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CPPid#">
						   and l.CPLnumeroLiquidacion 	= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CPLnumeroLiquidacion#">
						   and l.Ocodigo	= CPresupuestoControl.Ocodigo
   						   and l.CPcuenta	= CPresupuestoControl.CPcuenta
   						   and l.CPLCresultado = 0
			   		) > 0
		</cfquery>

		<cfinvoke 
			 component		= "sif.Componentes.PRES_Presupuesto"
			 method			= "fnGeneraNAP"
			 returnvariable = "LvarNAP">
				<cfinvokeargument name="EcodigoOrigen" 		value="#session.Ecodigo#"/>
				<cfinvokeargument name="ModuloOrigen" 		value="PRFO"/>
				<cfinvokeargument name="NumeroDocumento" 	value="#form.CPLnumeroLiquidacion#"/>
				<cfinvokeargument name="NumeroReferencia" 	value="LIQUIDACION"/>
				<cfinvokeargument name="FechaDocumento" 	value="#LvarNow#"/>
				<cfinvokeargument name="AnoDocumento" 		value="#LvarAuxAno#"/>
				<cfinvokeargument name="MesDocumento" 		value="#LvarAuxMes#"/>
				<cfinvokeargument name="NAPreversado" 		value="0"/>
				<cfinvokeargument name="Conexion" 			value="#session.dsn#"/>
				<cfinvokeargument name="Ecodigo"	 		value="#session.Ecodigo#"/>
				<cfinvokeargument name="LvarCPPid"		 	value="#form.CPPidNuevo#"/>
		</cfinvoke>

		<!--- Incluye los detalles de NAP liquidados del período a liquidar --->
		<cfquery datasource="#Session.DSN#">
			insert into CPLiquidacionNAPdetalle
				(
				 	Ecodigo,
					CPPid,
					CPLnumeroLiquidacion,
					CPNAPnum,
					CPNAPDlinea
				)
			select 
				 	Ecodigo,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CPPid#"> as CPPid,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CPLnumeroLiquidacion#"> as CPLnumeroLiquidacion,
					CPNAPnum,
					CPNAPDlinea
			  from CPNAPdetalle
			 where Ecodigo 			= #session.ecodigo#
			   and CPPid			= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CPPid#">
			   and CPPidLiquidacion is null

			   and CPNAPDmonto - CPNAPDutilizado > 0
			   and CPNAPnumRef is null
			   and 
					(	<!--- exists --->
			   			select count(1)
						  from CPNAP n, CPLiquidacionCuentas l
						 where n.Ecodigo	= CPNAPdetalle.Ecodigo
						   and n.CPNAPnum	= CPNAPdetalle.CPNAPnum
						   and n.CPNAPcongelado = 0
						   and l.Ecodigo	= CPNAPdetalle.Ecodigo
						   and l.CPPid		= CPNAPdetalle.CPPid
						   and l.CPLnumeroLiquidacion = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CPLnumeroLiquidacion#">
						   and l.Ocodigo	= CPNAPdetalle.Ocodigo
						   and l.CPcuenta	= CPNAPdetalle.CPcuenta
						   and l.CPLCresultado = 0
						   and	(CPNAPdetalle.CPNAPDtipoMov = 'RC' and l.CPLCmontoReservas > 0 
						   	  OR CPNAPdetalle.CPNAPDtipoMov = 'CC' and l.CPLCmontoCompromisos > 0
								)
					) > 0
		</cfquery>

		<!--- Incluye los detalles de NAP liquidados de otros períodos pero liquidados anteriormente en el período a liquidar --->
		<cfquery name="insert" datasource="#Session.DSN#">
			insert into CPLiquidacionNAPdetalle
				(
				 	Ecodigo,
					CPPid,
					CPLnumeroLiquidacion,
					CPNAPnum,
					CPNAPDlinea
				)
			select 
				 	Ecodigo,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CPPid#"> as CPPid,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CPLnumeroLiquidacion#"> as CPLnumeroLiquidacion,
					CPNAPnum,
					CPNAPDlinea
			  from CPNAPdetalle
			 where Ecodigo 			= #session.ecodigo#
			   and CPPid			<> <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CPPid#">
			   and CPPidLiquidacion = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CPPid#">

			   and CPNAPDmonto - CPNAPDutilizado > 0
			   and CPNAPnumRef is null
			   and 
			   		(	<!--- exists --->
			   			select count(1)
						  from CPNAP n, CPLiquidacionCuentas l
						 where n.Ecodigo	= CPNAPdetalle.Ecodigo
						   and n.CPNAPnum	= CPNAPdetalle.CPNAPnum
						   and n.CPNAPcongelado = 0
						   and l.Ecodigo	= CPNAPdetalle.Ecodigo
						   and l.CPPid		= CPNAPdetalle.CPPidLiquidacion
						   and l.CPLnumeroLiquidacion = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CPLnumeroLiquidacion#">
						   and l.Ocodigo	= CPNAPdetalle.Ocodigo
						   and l.CPcuenta	= CPNAPdetalle.CPcuenta
						   and l.CPLCresultado = 0
						   and	(CPNAPdetalle.CPNAPDtipoMov = 'RC' and l.CPLCmontoReservas > 0 
						   	  OR CPNAPdetalle.CPNAPDtipoMov = 'CC' and l.CPLCmontoCompromisos > 0
								)
					) > 0
		</cfquery>

		<cfquery datasource="#Session.DSN#">
			update CPNAPdetalle
			   set CPPidLiquidacion = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CPPidNuevo#">
			 where 
					(	<!--- exists --->
						select count(1)
						  from CPLiquidacionNAPdetalle ld
						 where ld.Ecodigo 				= CPNAPdetalle.Ecodigo
						   and ld.CPPid					= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CPPid#">
						   and ld.CPLnumeroLiquidacion 	= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CPLnumeroLiquidacion#">
						   and ld.CPNAPnum				= CPNAPdetalle.CPNAPnum
						   and ld.CPNAPDlinea			= CPNAPdetalle.CPNAPDlinea
					) > 0
		</cfquery>

		<cfquery datasource="#Session.DSN#">
			update CPLiquidacion
			   set CPNAPnumLiquidacion 	= #LvarNAP#
			   	 , CPPidLiquidacion 	= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CPPidNuevo#">
			     , CPLfechaLiquidacion 	= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarNow#">
			 where Ecodigo 				= #session.Ecodigo#
			   and CPPid				= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CPPid#">
			   and CPLnumeroLiquidacion = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CPLnumeroLiquidacion#">
		</cfquery>

		<cfquery datasource="#Session.DSN#">
			update CPresupuestoPeriodo
			   set CPPidLiquidacion = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CPPidNuevo#">
			 where Ecodigo 	= #session.Ecodigo#
			   and CPPid	= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CPPid#">
		</cfquery>
	</cftransaction>
</cfif>

<HTML>
<head>
</head>
<body>

<cfif isdefined("Form.btnLiquidar")>
	<cfoutput>
	<form action="/cfmx/home/menu/modulo.cfm?s=SIF&m=PRES" method="post" name="sql">
	   	<input name="CPPid" type="hidden" value="#form.CPPid#">
		<input name="PageNum" type="hidden" value="<cfif isdefined("Form.PageNum")><cfoutput>#Form.PageNum#</cfoutput></cfif>">
	</form>
	</cfoutput>
	
	<script language="JavaScript1.2" type="text/javascript">
		alert("Liquidacion terminada con Exito, NAP=<cfoutput>#LvarNAP#</cfoutput>");
		document.forms[0].submit();
	</script>
<cfelse>
	<cfoutput>
	<form action="LiquidacionPeriodo.cfm" method="post" name="sql">
	   	<input name="CPPid" type="hidden" value="#form.CPPid#">
		<input name="PageNum" type="hidden" value="<cfif isdefined("Form.PageNum")><cfoutput>#Form.PageNum#</cfoutput></cfif>">
	</form>
	</cfoutput>
	
	<script language="JavaScript1.2" type="text/javascript">
		document.forms[0].submit();
	</script>
</cfif>

</body>
</HTML>

<cffunction name="fnTotales" returntype="struct">
	<cfquery name="rsTotal" datasource="#Session.DSN#">
		select sum(CPLCmontoReservas) as Total_RC
				,sum(CPLCmontoCompromisos) as Total_CC
				,sum(CPLCmontoModificacion) as Total_M
				,sum(CPLCmontoReservas+CPLCmontoCompromisos-CPLCmontoModificacion) as Total_SF
		  from CPLiquidacionCuentas
		 where Ecodigo 				= #session.Ecodigo#
		   and CPPid				= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CPPid#">
		   and CPLnumeroLiquidacion = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CPLnumeroLiquidacion#">

		   and CPLCresultado 		= 0
	</cfquery>
	<cfquery name="rsTotal_ErrSD" datasource="#Session.DSN#">
		select coalesce(sum(CPLCmontoReservas+CPLCmontoCompromisos),0) as Total
		  from CPLiquidacionCuentas
		 where Ecodigo 				= #session.Ecodigo#
		   and CPPid				= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CPPid#">
		   and CPLnumeroLiquidacion = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CPLnumeroLiquidacion#">

		   and CPLCresultado 		= 1
	</cfquery>
	
	<cfquery name="rsTotal_ErrSC" datasource="#Session.DSN#">
		select coalesce(sum(CPLCmontoReservas+CPLCmontoCompromisos),0) as Total
		  from CPLiquidacionCuentas
		 where Ecodigo 				= #session.Ecodigo#
		   and CPPid				= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CPPid#">
		   and CPLnumeroLiquidacion = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CPLnumeroLiquidacion#">

		   and CPLCresultado 		= 2 
	</cfquery>

	<cfset LvarTotales.Total_RC = rsTotal.Total_RC>
	<cfset LvarTotales.Total_CC = rsTotal.Total_CC>
	<cfset LvarTotales.Total_M  = rsTotal.Total_M>
	<cfset LvarTotales.Total_SF = rsTotal.Total_SF>
	<cfset LvarTotales.Total_ErrSD = rsTotal_ErrSD.Total>
	<cfset LvarTotales.Total_ErrSC = rsTotal_ErrSC.Total>
	<cfreturn LvarTotales>
</cffunction>

<cffunction name="fnGenerar">
	<cfquery name="rsEmpresa" datasource="#session.dsn#">
		select Mcodigo 
		from Empresas 
		where Ecodigo = #Session.Ecodigo#
	</cfquery>
	<cfinclude template="../../Utiles/sifConcat.cfm">
	<cfquery name="rsPeriodos" datasource="#Session.DSN#">
		select 
			'Presupuesto ' #_Cat#
				case n.CPPtipoPeriodo when 1 then 'Mensual' when 2 then 'Bimestral' when 3 then 'Trimestral' when 4 then 'Cuatrimestral' when 6 then 'Semestral' when 12 then 'Anual' else '' end
				#_Cat# ' de ' #_Cat# 
				case {fn month(n.CPPfechaDesde)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
				#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(n.CPPfechaDesde)}">
				#_Cat# ' a ' #_Cat# 
				case {fn month(n.CPPfechaHasta)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
				#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(n.CPPfechaHasta)}">
			as Nuevo,
			'Presupuesto ' #_Cat#
				case v.CPPtipoPeriodo when 1 then 'Mensual' when 2 then 'Bimestral' when 3 then 'Trimestral' when 4 then 'Cuatrimestral' when 6 then 'Semestral' when 12 then 'Anual' else '' end
				#_Cat# ' de ' #_Cat# 
				case {fn month(v.CPPfechaDesde)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
				#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(v.CPPfechaDesde)}">
				#_Cat# ' a ' #_Cat# 
				case {fn month(v.CPPfechaHasta)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
				#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(v.CPPfechaHasta)}">
			as Viejo
		  from CPresupuestoPeriodo v
		  	inner join CPresupuestoPeriodo n
				on n.CPPid = v.CPPidLiquidacion
		 where v.Ecodigo 			 = #session.Ecodigo#
		   and v.CPPid				 = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CPPid#">
		   and v.CPPidLiquidacion	<> <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CPPidNuevo#">
	</cfquery>
	<cfif rsPeriodos.recordCount GT 0>
		<cf_errorCode	code = "50474"
						msg  = "El Período de Presupuesto '@errorDat_1@' fue Liquidado en el '@errorDat_2@', diferente al Nuevo Período Abierto"
						errorDat_1="#rsPeriodos.Viejo#"
						errorDat_2="#rsPeriodos.Nuevo#"
		>
	</cfif>

	<!--- Obtiene el mes de Auxiliares --->
	<cfquery name="rsSQL" datasource="#session.dsn#">
	select Pvalor
	  from Parametros
	 where Ecodigo = #session.ecodigo#
	   and Pcodigo = 50
	</cfquery>
	<cfset LvarAuxAno = rsSQL.Pvalor>
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select Pvalor
		  from Parametros
		 where Ecodigo = #session.ecodigo#
		   and Pcodigo = 60
	</cfquery>
	<cfset LvarAuxMes = rsSQL.Pvalor>
	<cfset LvarAuxAnoMes = LvarAuxAno*100+LvarAuxMes>

	<cfquery name="rsSQL" datasource="#Session.DSN#">
		delete from CPLiquidacionCuentas
		 where Ecodigo 				= #session.Ecodigo#
		   and CPPid				= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CPPid#">
		   and CPLnumeroLiquidacion = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CPLnumeroLiquidacion#">
	</cfquery>
	
	
	<cfquery name="insert" datasource="#Session.DSN#">
		insert into CPLiquidacionCuentas
			(Ecodigo, CPPid, CPLnumeroLiquidacion, Ocodigo, CPcuenta, 
			 CPLCdisponibleAntes, CPLCpendientesAntes, 
			 CPLCmontoReservas, CPLCmontoCompromisos, CPLCmontoModificacion, CPLCresultado)
		select 
			 Ecodigo, CPPid, CPLnumeroLiquidacion, Ocodigo, CPcuenta, 
			 CPLCdisponibleAntes, CPLCpendientesAntes, 
			 sum(CPLCmontoReservas) as CPLCmontoReservas, sum(CPLCmontoCompromisos) as CPLCmontoCompromisos, sum(CPLCmontoModificacion) as CPLCmontoModificacion, sum(CPLCresultado)  as CPLCresultado
		from (
		<!--- Liquida todos los Detalles de NAP origen con saldo del periodo que no hayan sido Liquidados --->
		select 	d.Ecodigo, d.CPPid, 
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CPLnumeroLiquidacion#"> as CPLnumeroLiquidacion,
				d.Ocodigo, d.CPcuenta, 0 as CPLCdisponibleAntes, 0 as CPLCpendientesAntes, 
				sum(case d.CPNAPDtipoMov 		when 'RC' then d.CPNAPDmonto - d.CPNAPDutilizado else 0 end) as CPLCmontoReservas, 
				sum(case d.CPNAPDtipoMov 		when 'CC' then d.CPNAPDmonto - d.CPNAPDutilizado else 0 end) as CPLCmontoCompromisos, 
				sum(case p.CPLtipoLiquidacion 	when 'C'  then d.CPNAPDmonto - d.CPNAPDutilizado else 0 end) as CPLCmontoModificacion, 
				0 as CPLCresultado
		  from CPNAPdetalle d
		  	inner join CPNAP n 
				 on n.Ecodigo 	= d.Ecodigo
				and n.CPNAPnum	= d.CPNAPnum
				and n.CPNAPcongelado = 0
			inner join CPresupuesto c
				inner join CtasMayor m
					 on m.Ecodigo	= c.Ecodigo
					and m.Cmayor	= c.Cmayor
				 on c.CPcuenta	= d.CPcuenta
			, CPLiquidacionParametros p
		 where d.Ecodigo			= #session.ecodigo#
		   and d.CPPid 				= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CPPid#">
		   and d.CPPidLiquidacion 	is null				<!--- Unicamente NAPs del período que no hayan sido liquidados --->
		   and d.CPNAPnumRef 		is null				<!--- Unicamente NAPs origenes del movimiento --->
		   and d.CPNAPDmonto - d.CPNAPDutilizado > 0	<!--- Unicamente NAPs origenes con saldo (a liquidar) --->

		   and p.Ecodigo			= #session.ecodigo#
		   and p.CPPid				= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CPPid#">
		   and 	case
					when p.Ctipo = 'A' AND n.CPNAPmoduloOri in ('CMSC','CMOC') AND m.Ctipo = 'A'	 			then 1
					when p.Ctipo = 'G' AND n.CPNAPmoduloOri in ('CMSC','CMOC') AND m.Ctipo = 'G'	 			then 1
					when p.Ctipo = 'O' AND n.CPNAPmoduloOri in ('CMSC','CMOC') AND m.Ctipo not in ('A','G') 	then 1
					when p.Ctipo = 'P' AND n.CPNAPmoduloOri in ('TESP','TEOP') 									then 1
					when p.Ctipo = 'E' AND n.CPNAPmoduloOri in ('TEAE','TEGE','TECH') 							then 1
					when p.Ctipo = 'I' AND (select Otipo from Origenes where Oorigen=n.CPNAPmoduloOri) = 'E' 	then 1
					else -1
				end = 1
		   and p.CPNAPDtipoMov 		= d.CPNAPDtipoMov
		   and p.CPLtipoLiquidacion not in ('N','-')
		   group by d.Ecodigo, d.CPPid, d.Ocodigo, d.CPcuenta
		UNION
		<!--- Liquida todos los Detalles de NAP origen con saldo que fueron Liquidados en el Período anteriormente --->
		select 	d.Ecodigo, d.CPPidLiquidacion as CPPid, 
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CPLnumeroLiquidacion#">,
				d.Ocodigo, d.CPcuenta, 0, 0, 

				sum(case d.CPNAPDtipoMov 		when 'RC' then d.CPNAPDmonto - d.CPNAPDutilizado else 0 end), 
				sum(case d.CPNAPDtipoMov 		when 'CC' then d.CPNAPDmonto - d.CPNAPDutilizado else 0 end), 
				sum(case p.CPLtipoLiquidacion 	when 'C'  then d.CPNAPDmonto - d.CPNAPDutilizado else 0 end), 
				0
		  from CPNAPdetalle d
		  	inner join CPNAP n 
				 on n.Ecodigo 	= d.Ecodigo
				and n.CPNAPnum	= d.CPNAPnum
				and n.CPNAPcongelado = 0
			inner join CPresupuesto c
				inner join CtasMayor m
					 on m.Ecodigo	= c.Ecodigo
					and m.Cmayor	= c.Cmayor
				 on c.CPcuenta	= d.CPcuenta
			, CPLiquidacionParametros p
		 where d.Ecodigo			= #session.ecodigo#
				<!--- Unicamente NAPs de otro período que fueron Liquidados en el período --->
		   and d.CPPid 				<> <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CPPid#">
		   and d.CPPidLiquidacion 	= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CPPid#">	

		   and d.CPNAPnumRef 		is null				<!--- Unicamente NAPs origenes del movimiento --->
		   and d.CPNAPDmonto - d.CPNAPDutilizado > 0	<!--- Unicamente NAPs origenes con saldo (a liquidar) --->

		   and p.Ecodigo			= #session.ecodigo#
		   and p.CPPid				= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CPPid#">
		   and 	case 
					when p.Ctipo = 'A' AND n.CPNAPmoduloOri in ('CMSC','CMOC') AND m.Ctipo = 'A'	 			then 1
					when p.Ctipo = 'G' AND n.CPNAPmoduloOri in ('CMSC','CMOC') AND m.Ctipo = 'G'	 			then 1
					when p.Ctipo = 'O' AND n.CPNAPmoduloOri in ('CMSC','CMOC') AND m.Ctipo not in ('A','G') 	then 1
					when p.Ctipo = 'P' AND n.CPNAPmoduloOri in ('TESP','TEOP') 									then 1
					when p.Ctipo = 'E' AND n.CPNAPmoduloOri in ('TEAE','TEGE','TECH') 							then 1
					when p.Ctipo = 'I' AND (select Otipo from Origenes where Oorigen=n.CPNAPmoduloOri) = 'E' 	then 1
					else -1
				end = 1
		   and p.CPNAPDtipoMov 		= d.CPNAPDtipoMov
		   and p.CPLtipoLiquidacion not in ('N','-')
		   group by d.Ecodigo, d.CPPidLiquidacion, d.Ocodigo, d.CPcuenta
		 ) d
		 group by 
			 Ecodigo, CPPid, CPLnumeroLiquidacion, Ocodigo, CPcuenta, 
			 CPLCdisponibleAntes, CPLCpendientesAntes
	</cfquery>

	<cfquery datasource="#Session.DSN#">
		update CPLiquidacionCuentas
		   set CPLCresultado = 2
		 where Ecodigo 				= #session.Ecodigo#
		   and CPPid				= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CPPid#">
		   and CPLnumeroLiquidacion = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CPLnumeroLiquidacion#">

		   and
				(	<!--- NOT exists --->
					select count(1) 
					  from CPresupuestoControl cp
						inner join CPCuentaPeriodo p
							 on p.Ecodigo 	= cp.Ecodigo
							and p.CPPid		= cp.CPPid
							and p.CPcuenta	= cp.CPcuenta
					 where cp.Ecodigo	= CPLiquidacionCuentas.Ecodigo
					   and cp.CPPid		= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CPPidNuevo#">
					   and cp.CPcuenta	= CPLiquidacionCuentas.CPcuenta
					   and cp.Ocodigo	= CPLiquidacionCuentas.Ocodigo
				) = 0
	</cfquery>
	<cfquery datasource="#Session.DSN#">
		update CPLiquidacionCuentas
		   set CPLCresultado = 3
		 where Ecodigo 				= #session.Ecodigo#
		   and CPPid				= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CPPid#">
		   and CPLnumeroLiquidacion = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CPLnumeroLiquidacion#">

		   and
				(	<!--- NOT exists --->
					select count(1) 
					from CPresupuestoControl cp
						inner join CPCuentaPeriodo p
							 on p.Ecodigo 	= cp.Ecodigo
							and p.CPPid		= cp.CPPid
							and p.CPcuenta	= cp.CPcuenta
					 where cp.Ecodigo	= CPLiquidacionCuentas.Ecodigo
					   and cp.CPPid		= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CPPidNuevo#">
					   and cp.CPcuenta	= CPLiquidacionCuentas.CPcuenta
					   and cp.Ocodigo	= CPLiquidacionCuentas.Ocodigo
					   and cp.CPCanoMes	>= 
											case p.CPCPcalculoControl
												when 1 then #LvarAuxAnoMes# else 0
											end
					   and cp.CPCanoMes	<= 
											case p.CPCPcalculoControl
												when 3 then 600001 else #LvarAuxAnoMes#
											end
				) = 0
	</cfquery>

	<cfquery datasource="#Session.DSN#">
		update CPLiquidacionCuentas
		   set 	 CPLCdisponibleAntes = 
		   			coalesce(
		   			(
						select sum(
									(CPCpresupuestado + CPCmodificado + CPCvariacion + CPCtrasladado + CPCtrasladadoE + CPCmodificacion_Excesos)
								-
									(CPCreservado_Anterior		+ CPCreservado		+ 
									 CPCcomprometido_Anterior	+ CPCcomprometido	+
									 CPCreservado_Presupuesto	+ CPCejecutado + CPCejecutadoNC
									)
								)
						  from CPresupuestoControl cp
						  	inner join CPCuentaPeriodo p
								 on p.Ecodigo 	= cp.Ecodigo
								and p.CPPid		= cp.CPPid
								and p.CPcuenta	= cp.CPcuenta
						 where cp.Ecodigo	= CPLiquidacionCuentas.Ecodigo
						   and cp.CPPid		= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CPPidNuevo#">
						   and cp.CPcuenta	= CPLiquidacionCuentas.CPcuenta
						   and cp.Ocodigo	= CPLiquidacionCuentas.Ocodigo
						   and cp.CPCanoMes	>= 
												case p.CPCPcalculoControl
													when 1 then #LvarAuxAnoMes# else 0
												end
						   and cp.CPCanoMes	<= 
												case p.CPCPcalculoControl
													when 3 then 600001 else #LvarAuxAnoMes#
												end
					), 0)
		   		,CPLCpendientesAntes = 
		   			coalesce (
					(
						select sum(CPCnrpsPendientes)
						  from CPresupuestoControl cp
						  	inner join CPCuentaPeriodo p
								 on p.Ecodigo 	= cp.Ecodigo
								and p.CPPid		= cp.CPPid
								and p.CPcuenta	= cp.CPcuenta
						 where cp.Ecodigo	= CPLiquidacionCuentas.Ecodigo
						   and cp.CPPid		= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CPPidNuevo#">
						   and cp.CPcuenta	= CPLiquidacionCuentas.CPcuenta
						   and cp.Ocodigo	= CPLiquidacionCuentas.Ocodigo
						   and cp.CPCanoMes	>= 
												case p.CPCPcalculoControl
													when 1 then #LvarAuxAnoMes# else 0
												end
						   and cp.CPCanoMes	<= 
												case p.CPCPcalculoControl
													when 3 then 600001 else #LvarAuxAnoMes#
												end
					), 0)
		 where Ecodigo 				= #session.Ecodigo#
		   and CPPid				= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CPPid#">
		   and CPLnumeroLiquidacion = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CPLnumeroLiquidacion#">
		   and CPLCresultado=0
	</cfquery>

	<cfquery datasource="#Session.DSN#">
		update CPLiquidacionCuentas
		   set CPLCresultado = 1
		 where Ecodigo 				= #session.Ecodigo#
		   and CPPid				= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CPPid#">
		   and CPLnumeroLiquidacion = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CPLnumeroLiquidacion#">

		   and CPLCdisponibleAntes-CPLCpendientesAntes-CPLCmontoReservas-CPLCmontoCompromisos+CPLCmontoModificacion < 0
		   and CPLCresultado = 0
		   and coalesce(
		   		(
					select p.CPCPtipoControl
					  from CPCuentaPeriodo p
					 where p.Ecodigo 	= CPLiquidacionCuentas.Ecodigo
					   and p.CPPid		= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CPPidNuevo#">
					   and p.CPcuenta	= CPLiquidacionCuentas.CPcuenta
				)
					, -1) <>  0 		<!--- Permite que el disponible sea negativo si el control es abierto = 0 --->
	</cfquery>
</cffunction>

