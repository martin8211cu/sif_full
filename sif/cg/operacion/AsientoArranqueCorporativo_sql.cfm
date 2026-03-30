<!--- Concepto Contable --->
<cfquery name="rsConceptoContableE" datasource="#session.dsn#">
	select min(Cconcepto) as Cconcepto
	from ConceptoContable
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and Oorigen = 'CGCF'
</cfquery>

<cfif not isdefined('rsConceptoContableE') or rsConceptoContableE.recordcount LT 1 or len(trim(rsConceptoContableE.Cconcepto)) EQ 0>
	<cfthrow type="toUser" message="No se ha definido el Concepto para el Origen Cierre Anual Fiscal (CGCF). No se puede realizar el proceso de Inicialización de Período Corporativo">
</cfif>
<cfif isdefined("url.btnExportar")>
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select 	s.Ecodigo, s.Speriodo as Periodo, s.Smes as Mes,
				o.Oficodigo as Oficina, c.Cformato as Cuenta, mm.Miso4217 as Moneda_Origen, 
				case when s.SOinicial>=0 then round(s.SOinicial,2) end as debito_Origen, 
				case when s.SOinicial<0 then -round(s.SOinicial,2) end as credito_Origen, 
				case when s.SLinicial>=0 then round(s.SLinicial,2) end as debito_Local, 
				case when s.SLinicial<0 then -round(s.SLinicial,2) end as credito_Local
		  from SaldosContables s
		  	inner join CContables c 
				inner join CtasMayor m 
					 on m.Ecodigo = c.Ecodigo 
					and m.Cmayor  = c.Cmayor 
					and m.Ctipo	in ('I', 'G')
				on c.Ccuenta = s.Ccuenta
				and c.Cmovimiento = 'S'
		  	inner join Oficinas o
				 on o.Ecodigo = s.Ecodigo
				and o.Ocodigo = s.Ocodigo
		  	inner join Monedas mm
				 on mm.Ecodigo = s.Ecodigo
				and mm.Mcodigo = s.Mcodigo
		 where s.Ecodigo	= #session.Ecodigo#
		   and s.Speriodo	= #url.Per#
		   and s.Smes		= #url.Mes#
		 order by o.Oficodigo, c.Cformato, mm.Miso4217
	</cfquery>
	<cf_QueryToFile query="#rsSQL#" filename="SaldosIniciales#url.Per#-#url.Mes#.xls">
	<cfdump var="#rsSQL#">
	<cfabort>
	<cfcontent type="application/vnd.ms-#LvarDLtype#">
	<cfheader name="Content-Disposition" value="attachment; filename=#Attributes.FileName#">
	<cfset getPageContext().getResponse().setHeader("Cache-Control", "public")>

<cfelseif isdefined("form.btnArrancar1")>
	<!--- Inicializa los SaldosIniciales Corporativos de todos los meses existentes --->
	<cfinvoke 
		component	= "sif.Componentes.CG_CierreMes"
		method		= "sbInicializaPeriodoCorporativo"

		Mes			= "#form.MesCorporativo#"
		Ecodigo		= "#session.Ecodigo#"
		Conexion	= "#session.dsn#"
	/>
<cfelseif isdefined("form.btnArrancar2")>
	<cfquery name="rsSQL" datasource="#session.dsn#">
		update Parametros 
		   set Pvalor = '-#form.MesCorporativo#'
		 where Ecodigo = #session.Ecodigo#
		   and Pcodigo = 46
	</cfquery>
	<!--- Inicializa en CERO SaldoInicial de Cuentas de Resultados --->
	<cfquery datasource="#session.dsn#">
		update SaldosContables
		   set 
				SLinicialGE	= 0,
				SOinicialGE	= 0,
				BMFecha = <cf_dbfunction name="now">
		 where SaldosContables.Ecodigo	= #session.Ecodigo#
		   and SaldosContables.Speriodo	= #form.PerArrancar#
		   and SaldosContables.Smes		= #form.MesArrancar#
		   and (
				select count(1)
				  from CContables c 
					inner join CtasMayor m 
						 on m.Ecodigo = c.Ecodigo 
						and m.Cmayor  = c.Cmayor 
				 where c.Ccuenta = SaldosContables.Ccuenta
				   and m.Ctipo	in ('I', 'G')
		   	) > 0
	</cfquery>
	
	<cfset sbActualizaSaldoInicialC()>

<cfelseif isdefined("form.btnArrancar3")>
	<cfquery name="rsSQL" datasource="#session.dsn#">
		update Parametros 
		   set Pvalor = '-#form.MesCorporativo#'
		 where Ecodigo = #session.Ecodigo#
		   and Pcodigo = 46
	</cfquery>
	<!--- Inicializa en CERO SaldoInicial de Cuentas de Resultados --->
	<cfquery datasource="#session.dsn#">
		update SaldosContables
		   set 
				SLinicialGE	= 0,
				SOinicialGE	= 0,
				BMFecha = <cf_dbfunction name="now">
		 where SaldosContables.Ecodigo	= #session.Ecodigo#
		   and SaldosContables.Speriodo	= #form.PerArrancar#
		   and SaldosContables.Smes		= #form.MesArrancar#
		   and (
				select count(1)
				  from CContables c 
					inner join CtasMayor m 
						 on m.Ecodigo = c.Ecodigo 
						and m.Cmayor  = c.Cmayor 
				 where c.Ccuenta = SaldosContables.Ccuenta
				   and m.Ctipo	in ('I', 'G')
		   	) > 0
	</cfquery>
	
	<!--- Carga oficinas --->
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select coalesce(Oficodigo,'0') as Oficodigo, Ocodigo 
		  from Oficinas
		 where Ecodigo = #session.Ecodigo#
	</cfquery>
	<cfset LlstOFIs1 = valueList(rsSQL.Oficodigo)>
	<cfset LlstOFIs2 = valueList(rsSQL.Ocodigo)>

	<!--- Carga monedas --->
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select coalesce(Miso4217,'0') as Miso4217, Mcodigo 
		  from Monedas
		 where Ecodigo = #session.Ecodigo#
	</cfquery>
	<cfset LlstMONs1 = valueList(rsSQL.Miso4217)>
	<cfset LlstMONs2 = valueList(rsSQL.Mcodigo)>

	<!--- Carga el Archivo Importado --->

	<cftry>
		<cfset LobjFile = FileOpen("#form.archivo#", "read")>
		<cfset LvarLin = 0>
		<cfset LvarPri = 0>
		<cfset LvarSinErrores = true>
		<cfloop condition="NOT FileIsEOF(LobjFile)">
			<cfset LvarPri = LvarPri + 1>
			<cfset LvarLinea = replace(FileReadLine(LobjFile),",,",",0,","ALL")>
			<cfif NOT (LvarPri EQ 1 AND listGetAt(LvarLinea,1) EQ "ECODIGO" AND listGetAt(LvarLinea,2) EQ "PERIODO" AND listGetAt(LvarLinea,3) EQ "MES")>
				<cfset LvarLin = LvarLin + 1>
				<cfif right(LvarLinea,1) EQ ",">
					<cfset LvarLinea = "#LvarLinea#0">
				<cfelseif listLen(LvarLinea) EQ 9>
					<cfset LvarLinea = "#LvarLinea#,0">
				</cfif>
		
				<cfset LvarError = "">
				<cfif listLen(LvarLinea) NEQ 10>
					<cfthrow message="Linea #LvarLin# no posee 10 campos">
				<cfelse>
					<cfset LvarEcodigo	= listGetAt(LvarLinea,1)>
					<cfset LvarPeriodo	= listGetAt(LvarLinea,2)>
					<cfset LvarMes		= listGetAt(LvarLinea,3)>
					<cfset LvarOficina	= listGetAt(LvarLinea,4)>
					<cfset LvarCuenta	= listGetAt(LvarLinea,5)>
					<cfset LvarMoneda	= listGetAt(LvarLinea,6)>
					<cfset LvarDBOrigen	= listGetAt(LvarLinea,7)>
					<cfset LvarCROrigen	= listGetAt(LvarLinea,8)>
					<cfset LvarDBLocal	= listGetAt(LvarLinea,9)>
					<cfset LvarCRLocal	= listGetAt(LvarLinea,10)>
					
					<!--- Verifica Ecodigo, Speriodo, Smes --->
					<cfif LvarEcodigo NEQ session.Ecodigo>
						<cfset LvarError = listAppend(LvarError,"Ecodigo debe ser #session.Ecodigo#")>
					</cfif>
					<cfif LvarPeriodo NEQ form.PerArrancar OR LvarMes NEQ form.MesArrancar>
						<cfset LvarError = listAppend(LvarError,"Periodo y Mes debe ser #form.PerArrancar# / #form.MesArrancar#")>
					</cfif>
					<cfif LvarLin EQ 1 and LvarError NEQ "">
						<cfthrow message="El Archivo Importado no pertenece a la Empresa, Periodo y Mes indicados: #LvarError#">
					</cfif>
	
					<!--- Verifica Oficinas y Monedas --->
					<cfif LvarError EQ "">
						<cfset LvarOcodigo = listFind(LlstOFIs1, LvarOficina)>
						<cfif LvarOcodigo GT 0>
							<cfset LvarOcodigo = listGetAt(LlstOFIs2, LvarOcodigo)>
						<cfelse>
							<cfset LvarError = listAppend(LvarError,"Oficina #LvarOficina# no existe")>
						</cfif>
	
						<cfset LvarMcodigo = listFind(LlstMONs1, LvarMoneda)>
						<cfif LvarMcodigo GT 0>
							<cfset LvarMcodigo = listGetAt(LlstMONs2, LvarMcodigo)>
						<cfelse>
							<cfset LvarError = listAppend(LvarError,"Moneda #LvarMcodigo# no existe")>
						</cfif>
					</cfif>
					
					<!--- Verifica Cuenta Contable --->
					<cfquery name="rsSQL" datasource="#session.dsn#">
						select c.Ccuenta, c.Cmovimiento, m.Ctipo
						  from CContables c
							inner join CtasMayor m
								 on m.Ecodigo = c.Ecodigo
								and m.Cmayor  = c.Cmayor
						 where c.Ecodigo	= #LvarEcodigo#
						   and c.Cmayor		= '#mid(LvarCuenta,1,4)#'
						   and c.Cformato	= '#LvarCuenta#'
					</cfquery>
					<cfif rsSQL.Ccuenta EQ "">
						<cfset LvarError = listAppend(LvarError,"Cuenta Contable #LvarCuenta# no existe")>
					<cfelseif rsSQL.Cmovimiento NEQ "S">
						<cfset LvarError = listAppend(LvarError,"Cuenta Contable no admite movimientos (no es de último nivel)")>
					<cfelseif rsSQL.Ctipo NEQ "I" AND rsSQL.Ctipo NEQ "G">
						<cfset LvarError = listAppend(LvarError,"Cuenta Contable no es de Resultados (Ingresos o Gastos)")>
					<cfelse>
						<cfset LvarCcuenta = rsSQL.Ccuenta>
					</cfif>
	
					<!--- Verifica Montos --->
					<cfif NOT isnumeric(LvarDBOrigen) OR NOT isnumeric(LvarCROrigen) OR NOT isnumeric(LvarDBLocal) OR NOT isnumeric(LvarCRLocal)>
						<cfset LvarError = listAppend(LvarError,"Todos los Debitos y Creditos deben ser Numéricos")>
					</cfif>
					<cfif LvarDBOrigen LT 0 OR LvarCROrigen LT 0 OR LvarDBLocal LT 0 OR LvarCRLocal LT 0>
						<cfset LvarError = listAppend(LvarError,"Todos los Debitos y Creditos deben ser Positivos")>
					</cfif>
				</cfif>
				<cfif LvarError NEQ "">
					<cfset LvarSinErrores = false>
					<cfoutput>
						LINEA #LvarLin#: #LvarLinea#<BR>
						ERRORES: #LvarError#<BR><BR>
					</cfoutput>
				<cfelse>
					<cfquery datasource="#session.dsn#">
						update SaldosContables
						   set 
								SLinicialGE	= SLinicialGE + #LvarDBLocal#  - #LvarCRLocal#,
								SOinicialGE	= SOinicialGE + #LvarDBOrigen# - #LvarCROrigen#,
								BMFecha = <cf_dbfunction name="now">
						 where SaldosContables.Speriodo	= #LvarPeriodo#
						   and SaldosContables.Smes		= #LvarMes#
						   and SaldosContables.Ecodigo	= #LvarEcodigo#
						   and SaldosContables.Ocodigo	= #LvarOcodigo#
						   and SaldosContables.Mcodigo	= #LvarMcodigo#
						   and (
								select count(1)
								  from PCDCatalogoCuenta c 
								 where c.Ccuenta 	= #LvarCcuenta#
								   and c.Ccuentaniv = SaldosContables.Ccuenta
							) > 0
					</cfquery>
				</cfif>
			</cfif>		
		</cfloop>
		<cfset fileClose(LobjFile)>
		<cffile action="delete" file="#form.archivo#">
	<cfcatch type="any">
		<cfset fileClose(LobjFile)>
		<cffile action="delete" file="#form.archivo#">
		<cfrethrow>
	</cfcatch>
	</cftry>
	<cfif LvarSinErrores>
		<cfset sbActualizaSaldoInicialC()>
	<cfelse>
		<cfabort>
	</cfif>
</cfif>
<cflocation url="AsientoArranqueCorporativo.cfm">
<cffunction name="sbActualizaSaldoInicialC" output="false">
	<!--- Concepto Contable --->
	<cfquery name="rsConceptoContableE" datasource="#session.dsn#">
		select min(Cconcepto) as Cconcepto
		from ConceptoContable
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Oorigen = 'CGCC'
	</cfquery>
	
	<cfif not isdefined('rsConceptoContableE') or rsConceptoContableE.recordcount LT 1 or len(trim(rsConceptoContableE.Cconcepto)) EQ 0>
		<cfthrow type="toUser" message="No se ha definido el Concepto para el Origen Cierre Anual Corporativo (CGCC). No se puede realizar el proceso de Inicialización de Período Corporativo">
	</cfif>

	<cfquery name="rsCuentaUtilidad" datasource="#session.dsn#">
		select Pvalor as cuenta
		from Parametros
		where Pcodigo = 300
		and Ecodigo = #session.Ecodigo#
	</cfquery>

	<!--- Iguala SaldoInicial de Cuentas de Balance --->
	<cfquery datasource="#session.dsn#">
		update SaldosContables
		   set 
				SLinicialGE	= SLinicial,
				SOinicialGE	= SOinicial,
				BMFecha = <cf_dbfunction name="now">
		 where SaldosContables.Ecodigo	= #session.Ecodigo#
		   and SaldosContables.Speriodo	= #form.PerArrancar#
		   and SaldosContables.Smes		= #form.MesArrancar#
		   and (
				select count(1)
				  from CContables c 
					inner join CtasMayor m 
						 on m.Ecodigo = c.Ecodigo 
						and m.Cmayor  = c.Cmayor 
				 where c.Ccuenta = SaldosContables.Ccuenta
				   and m.Ctipo	in ('I', 'G')
		   	) = 0
	</cfquery>

	<!--- Pasa la diferencia de SaldosIniciales de Cuentas de Resultado (por Cmayor) al Saldo Inicial de la Cuenta de Utilidades --->
	<cfquery name="rsMayor" datasource="#session.dsn#">
		select Cmayor
		  from CtasMayor m 
		 where m.Ecodigo = #session.Ecodigo#
		   and m.Ctipo	in ('I', 'G')
	</cfquery>
	<cfloop query="rsMayor">
		<cfquery datasource="#session.dsn#">
			update SaldosContables
			   set 
					SLinicialGE	= SLinicialGE + 
						coalesce(
							(
								select sum(SLinicial-SLinicialGE)
								  from SaldosContables s
									inner join CContables c
										 on c.Ccuenta = s.Ccuenta
										and c.Ecodigo = s.Ecodigo
										and c.Cmayor  = '#rsMayor.Cmayor#'
										and c.Cmovimiento = 'S'
								 where s.Speriodo	= SaldosContables.Speriodo
								   and s.Smes		= SaldosContables.Smes
								   and s.Ecodigo	= SaldosContables.Ecodigo
								   and s.Ocodigo	= SaldosContables.Ocodigo
								   and s.Mcodigo	= SaldosContables.Mcodigo
							)
						, 0)
				 ,	SOinicialGE	= SOinicialGE + 
						coalesce(
							(
								select sum(SOinicial-SOinicialGE)
								  from SaldosContables s
									inner join CContables c
										 on c.Ccuenta = s.Ccuenta
										and c.Ecodigo = s.Ecodigo
										and c.Cmayor  = '#rsMayor.Cmayor#'
										and c.Cmovimiento = 'S'
								 where s.Speriodo	= SaldosContables.Speriodo
								   and s.Smes		= SaldosContables.Smes
								   and s.Ecodigo	= SaldosContables.Ecodigo
								   and s.Ocodigo	= SaldosContables.Ocodigo
								   and s.Mcodigo	= SaldosContables.Mcodigo
							)
						, 0)
				 ,	BMFecha = <cf_dbfunction name="now">
			 where SaldosContables.Speriodo	= #form.PerArrancar#
			   and SaldosContables.Smes		= #form.MesArrancar#
			   and SaldosContables.Ecodigo	= #session.Ecodigo#
			   and (
					select count(1)
					  from PCDCatalogoCuenta c 
					 where c.Ccuenta 	= #rsCuentaUtilidad.cuenta#
					   and c.Ccuentaniv = SaldosContables.Ccuenta
				) > 0
		</cfquery>
	</cfloop>
	
	<!--- Inicializa los SaldosIniciales Corporativos de todos los meses existentes --->
	<cfinvoke 
		component	= "sif.Componentes.CG_CierreMes"
		method		= "sbInicializaPeriodoCorporativo"

		Mes			= "#form.MesCorporativo#"
		Ecodigo		= "#session.Ecodigo#"
		AnoIniciar	= "#form.PerArrancar#"
		MesIniciar	= "#form.MesArrancar#"
		Conexion	= "#session.dsn#"
	/>
</cffunction>