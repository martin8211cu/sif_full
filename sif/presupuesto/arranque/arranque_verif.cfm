<cfset LvarModuloOri	 = "CGDC">
<cfset LvarReferenciaOri = "ARRANQUE PRESUPUESTO">
<cfset LvarCVdescripcion = "ARRANQUE SALDOS CONTABLES PRESUPUESTALES">

<cf_dbtemp name="ACPMAS_1" returnvariable="PCEM" datasource="#session.dsn#">
	<cf_dbtempcol name="PCEMid"		type="numeric"      mandatory="yes">
</cf_dbtemp>

<cf_dbtemp name="ACPMAY_1" returnvariable="CMAYOR" datasource="#session.dsn#">
	<cf_dbtempcol name="PCEMid"			type="numeric"		mandatory="yes">
	<cf_dbtempcol name="CPVid"			type="numeric"		mandatory="yes">
	<cf_dbtempcol name="Cmayor"			type="char(4)"		mandatory="yes">
	<cf_dbtempcol name="Ctipo"			type="char(1)"		mandatory="yes">
	<cf_dbtempcol name="PCEMformatoP"	type="char(100)"	mandatory="yes">
</cf_dbtemp>

<cffunction name="rsEcodigos" access="private" returntype="query">
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select distinct e.Ecodigo, sp.Ecodigo as EcodigoSP, e.Edescripcion, e.Mcodigo
		  from Empresas e
			left join SaldosContablesP sp
				 on e.Ecodigo = sp.Ecodigo
		  where e.cliente_empresarial = #session.CEcodigo#
		  <cfif isdefined("form.chkEcodigo")>
		  	and #fnInEcodigos(form.chkEcodigo,"e.Ecodigo")#
		  </cfif>
	</cfquery>

	<cfquery name="rsSQL1" dbtype="query">
		select count(1) as cantidad
		  from rsSQL
		  where EcodigoSP is not null
	</cfquery>

	<cfif rsSQL1.recordCount EQ 0>
		<cf_errorCode	code = "50454" msg = "No se han importado SaldosContablesP">
	</cfif>
	<cfreturn rsSQL>
</cffunction>

<cffunction name="fnFormatMes" access="private" returntype="string">
	<cfargument name="Mes" type="numeric" required="yes">
	
	<cfreturn Mes mod 100 & "/" & int(Mes/100)>
</cffunction>

<cffunction name="verifica_arranque" access="private" returntype="struct">
	<cfargument name="Ecodigo" required="yes">
	
	<cfset LvarRet = structNew()>
	<cfset LvarRet.Ecodigo			= Arguments.Ecodigo>
	<cfset LvarRet.CVid				= 0>
	<cfset LvarRet.ERROR			= "">
	<cfset LvarRet.AjustarMascaras	= false>
	<cfset LvarRet.CrearVersion		= false>
	<cfset LvarRet.AplicarVersion	= false>
	<cfset LvarRet.GenerarEjecucion	= false>
	<cfset LvarRet.GenerarFaltantes	= false>
	<cfset LvarRet.MesAct			= 0>
	<cfset LvarRet.MesIni			= 0>
	<cfset LvarRet.MesFin			= 0>
	
	<!---
		1. Obtiene el Periodo Contable
	--->
	<cfquery name="rsParametros" datasource="#session.DSN#">
		select 	ano.Pvalor as Ano,
				mes.Pvalor as Mes,
				ult.Pvalor as UltMes
		  from Parametros ano, Parametros mes, Parametros ult
		 where 	ano.Ecodigo = #Arguments.Ecodigo# and ano.Pcodigo=30
		   and 	mes.Ecodigo = #Arguments.Ecodigo# and mes.Pcodigo=40
		   and 	ult.Ecodigo = #Arguments.Ecodigo# and ult.Pcodigo=45
	</cfquery>

	<cfif rsParametros.Ano EQ 0 or rsParametros.Mes EQ 0 or not isnumeric(rsParametros.Ano) or not isnumeric(rsParametros.Mes)>
		<cfset LvarRet.ERROR = "Empresa no ha sido iniciada">
		<cfreturn LvarRet>
	</cfif>
	
	<cfset LvarRet.MesAct = rsParametros.Ano*100+rsParametros.Mes>
	<cfif rsParametros.UltMes EQ 12>
		<cfset LvarRet.MesIni = (rsParametros.Ano)*100+1>
		<cfset LvarRet.MesFin = (rsParametros.Ano)*100+12>
	<cfelseif rsParametros.Mes GT rsParametros.UltMes>
		<cfset LvarRet.MesIni = (rsParametros.Ano)*100+(rsParametros.UltMes+1)>
		<cfset LvarRet.MesFin = (rsParametros.Ano+1)*100+(rsParametros.UltMes)>
	<cfelse>
		<cfset LvarRet.MesIni = (rsParametros.Ano-1)*100+(rsParametros.UltMes+1)>
		<cfset LvarRet.MesFin = (rsParametros.Ano)*100+(rsParametros.UltMes)>
	</cfif>
	
	<cfquery name="rsSQL" datasource="#session.DSN#">
		select CPNAPnum
		  from CPNAP
		 where Ecodigo 				= #Arguments.Ecodigo#
		   and CPNAPmoduloOri		= '#LvarModuloOri#'
		   and CPNAPdocumentoOri	like 'MES%'
		   and CPNAPreferenciaOri	= '#LvarReferenciaOri#'
	</cfquery>

	<cfif rsSQL.recordCount EQ 0>
		<cfset LvarRet.CrearVersion		= true>
		<cfset LvarRet.CrearPeriodo		= true>
		<cfset LvarRet.AplicarVersion	= true>
		<cfset LvarRet.GenerarEjecucion	= true>

		<!---
			2. Verifica que no exista ningún Período de Presupuesto ni ninguna Cuenta de Presupuesto
		--->
		<cfquery name="rsSQL" datasource="#session.DSN#">
			select CPPid, CPPestado
			  from CPresupuestoPeriodo
			 where Ecodigo = #Arguments.Ecodigo#
		</cfquery>
		
		<cfif rsSQL.recordCount NEQ 0>
			<cfif rsSQL.recordCount EQ 1>
				<cfif rsSQL.CPPestado EQ "0">
					<cfset LvarRet.CrearPeriodo = false>
				</cfif>

				<cfquery name="rsSQL" datasource="#session.DSN#">
					select CVid, CVaprobada
					  from CVersion
					 where Ecodigo = #Arguments.Ecodigo#
					   and CVdescripcion = '#LvarCVdescripcion#'
				</cfquery>
			
				<cfif rsSQL.recordCount EQ 1>
					<cfset LvarRet.CVid = rsSQL.CVid>
					<cfset LvarRet.AplicarVersion = (rsSQL.CVaprobada EQ 0)>
					<cfset LvarRet.CrearVersion = false>
				</cfif>
			</cfif>
			
			<cfif LvarRet.CrearVersion and LvarRet.CrearPeriodo>
				<cfset LvarRet.ERROR = "Ya existen Períodos de Presupuesto">
				<cfreturn LvarRet>
			</cfif>
		</cfif>
		
		<cfif LvarRet.CrearVersion>
			<cfif LvarRet.CrearPeriodo>
				<cfquery name="rsSQL" datasource="#session.DSN#">
					select CPcuenta
					  from CPresupuesto
					 where Ecodigo = #Arguments.Ecodigo#
				</cfquery>
				
				<cfif rsSQL.recordCount NEQ 0>
					<cfset LvarRet.ERROR = "Ya existen Cuentas de Presupuesto">
					<cfreturn LvarRet>
				</cfif>
			</cfif>
		
			<!---
				3. Obtiene las máscaras asociadas a las cuentas mayores en SaldosContablesP
			--->
			<cfquery datasource="#session.dsn#">
				delete from #PCEM#
			</cfquery>
			
			<cfquery datasource="#session.dsn#">
				insert into #PCEM# (PCEMid)
				select distinct vg.PCEMid
				  from SaldosContablesP sp
					inner join CFinanciera c
						inner join CPVigencia vg
							 on vg.Ecodigo=c.Ecodigo and vg.CPVid = c.CPVid and vg.Cmayor=c.Cmayor
							and (#LvarRet.MesIni# >= CPVdesdeAnoMes 
								OR #LvarRet.MesFin# <= CPVhastaAnoMes)
						 on c.Ccuenta = sp.Ccuenta
				 where sp.Speriodo*100+Smes between #LvarRet.MesIni# AND #LvarRet.MesFin#
				   and PCEMid is not null
				<!---
					Se toman de todas las empresas
					and sp.Ecodigo = #Arguments.Ecodigo#
				--->
			</cfquery>
		
			<!---
				4. Ajusta las máscaras con todos sus niveles de presupuesto: EsPresupuesto, FormatoP y NivelesP
			--->
			<cfquery name="rsPCEM" datasource="#Session.DSN#">
				select PCEMid
				  from #PCEM#
			</cfquery>
			<cfloop query="rsPCEM">
				<cfquery name="rsSQL" datasource="#Session.DSN#">
					select count(1) as cantidad
					  from PCNivelMascara
					 where PCEMid = #rsPCEM.PCEMid#
				</cfquery>
				<cfset LvarNivelesTotal = rsSQL.cantidad>
	
				<cfquery name="rsSQL" datasource="#Session.DSN#">
					select count(1) as cantidad
					  from PCNivelMascara
					 where PCEMid = #rsPCEM.PCEMid#
					   and PCNpresupuesto = 1
				</cfquery>
				<cfset LvarNivelesPres = rsSQL.cantidad>
	
				<cfquery name="rsSQL" datasource="#Session.DSN#">
					select count(1) as cantidad
					  from PCNivelMascara
					 where PCEMid = #rsPCEM.PCEMid#
					   and PCNpresupuesto = 0
				</cfquery>
				<cfset LvarNivelesNoPres = rsSQL.cantidad>
				
				<cfif 	LvarNivelesTotal NEQ LvarNivelesNoPres AND 
						LvarNivelesTotal NEQ LvarNivelesPres>
					<cfset LvarRet.ERROR = "Ya existen Niveles de Presupuesto en máscaras">
					<cfreturn LvarRet>
				</cfif>
			</cfloop>

			<cfquery datasource="#session.dsn#">
				delete from #CMAYOR#
			</cfquery>
		
			<cfquery datasource="#session.dsn#">
				insert into #CMAYOR# (PCEMid, CPVid, Cmayor, Ctipo, PCEMformatoP)
				select distinct vg.PCEMid, vg.CPVid, vg.Cmayor, m.Ctipo, mas.PCEMformato
				  from CPVigencia vg
					inner join CtasMayor m
						 on m.Ecodigo = vg.Ecodigo
						and m.Cmayor  = vg.Cmayor
					inner join PCEMascaras mas
						 on mas.PCEMid = vg.PCEMid
				 where vg.Ecodigo = #Arguments.Ecodigo#
				   and exists (select 1 from #PCEM# m where m.PCEMid = vg.PCEMid)
				   and (#LvarRet.MesIni# >= vg.CPVdesdeAnoMes 
					OR #LvarRet.MesFin# <= vg.CPVhastaAnoMes)
			</cfquery>
		</cfif>
	<cfelseif isdefined("form.chkEcodigo")>
		<cfset LvarRet.GenerarFaltantes	= true>
		<cfquery name="rsSQL" datasource="#session.DSN#">
			select max(CPCano*100+CPCmes) as MesIni
			  from CPNAP
			 where Ecodigo 				= #Arguments.Ecodigo#
			   and CPNAPmoduloOri		= '#LvarModuloOri#'
			   and CPNAPdocumentoOri	like 'MES%'
			   and CPNAPreferenciaOri	= '#LvarReferenciaOri#'
		</cfquery>
		
		<cfif rsSQL.MesIni NEQ "">
			<cfif (rsSQL.MesIni mod 100) EQ 12>
				<cfset LvarMesIni		= int(rsSQL.MesIni / 100)*100+101>
			<cfelse>
				<cfset LvarMesIni		= rsSQL.MesIni + 1>
			</cfif>
			<cfif LvarMesIni GT LvarRet.MesFin>
				<cfset LvarRet.GenerarFaltantes	= false>
			<cfelse>
				<cfset LvarRet.MesIni = LvarMesIni>
			</cfif>
		</cfif>

	</cfif>
	
	<cfreturn LvarRet>
</cffunction>

<cffunction name="fnInEcodigos" output="false" returntype="string">
	<cfargument name="chkList"	required="yes" type="string">
	<cfargument name="Field"	required="yes" type="string">

	<cfset LvarFields = listToArray(chkList)>
	<cfset LvarFieldsWhere = createObject("java","java.lang.StringBuffer")>
	<cfloop index="LvarIdx" from="1" to="#ArrayLen(LvarFields)#">
		<cfif LvarIdx EQ 1>
			<cfset LvarFieldsWhere.append(" (#Field# in (")>
		<cfelseif (LvarIdx mod 10) EQ 1>
			<cfset LvarFieldsWhere.append(") or #Field# in (")>
		<cfelse>
			<cfset LvarFieldsWhere.append(",")>
		</cfif>
		<cfset LvarFieldsWhere.append("#LvarFields[LvarIdx]#")>
	</cfloop>
	<cfset LvarFieldsWhere.append("))")>
	<cfreturn LvarFieldsWhere.toString()>
</cffunction>


