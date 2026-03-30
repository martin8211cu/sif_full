<cfinclude template="FnScripts.cfm">

<cfquery  name="rsImportador" datasource="#session.dsn#">
  select * from #table_name# 
  order by Cformato, Oficodigo
</cfquery>

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

<cfquery name="rsSQL" datasource="#session.dsn#">
	select Pvalor
	  from Parametros
	 where Ecodigo = #session.ecodigo#
	   and Pcodigo = 45
</cfquery>
<cfset LvarMesFin = rsSQL.Pvalor>

<!--- Obtiene el periodo de presupuesto --->
<cf_dbfunction name="to_char" args="{fn year(CPPfechaDesde)}" datasource="#session.dsn#" returnVariable="LvarDesde" isnumber="no">
<cf_dbfunction name="to_char" args="{fn year(CPPfechaHasta)}" datasource="#session.dsn#" returnVariable="LvarHasta" isnumber="no">

<cfquery name="rsSQL" datasource="#session.dsn#">
	select CPPid, CPPestado, CPPfechaDesde, CPPfechaHasta, CPPanoMesDesde, CPPanoMesHasta, CPPtipoPeriodo,
		
		<cf_dbfunction name="concat" args=
			"case CPPtipoPeriodo when 1 then 'Mensual' when 2 then 'Bimestral' when 3 then 'Trimestral' when 4 then 'Cuatrimestral' when 6 then 'Semestral' when 12 then 'Anual' else '' end
			+ ' de ' + 
			case {fn month(CPPfechaDesde)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
			+ ' ' + #preservesinglequotes(LvarDesde)#
			+ ' a ' + 
			case {fn month(CPPfechaHasta)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
			+ ' ' + #preservesinglequotes(LvarHasta)#" delimiters="+">
		as CPPdescripcion
	  from CPresupuestoPeriodo
	 where Ecodigo = #session.Ecodigo#
	   and #LvarAuxAnoMes# between CPPanoMesDesde and CPPanoMesHasta
</cfquery>


<cfif rsSQL.CPPid EQ "" OR rsSQL.CPPestado EQ "5">
	<cfset LvarCPPid 			= -1>
	<cfset LvarTipo				= "Período Fiscal">
	<cfset LvarMesN   			= 12>
	<cfif LvarMesFin EQ 12>
		<cfset LvarMesIni 		= 1>
		<cfset LvarAnoIni 		= LvarAuxAno>
		<cfset LvarAnoFin 		= LvarAuxAno>
	<cfelse>
		<cfset LvarMesIni = LvarMesFin+1>
		<cfif LvarMesIni LT LvarAuxMes>
			<cfset LvarAnoIni	 = LvarAuxAno - 1>
			<cfset LvarAnoFin 	= LvarAuxAno>
		<cfelse>
			<cfset LvarAnoIni 	= LvarAuxAno>
			<cfset LvarAnoFin 	= LvarAuxAno + 1>
		</cfif>
	</cfif>
	<cfset LvarAnoMesFin		= LvarAnoFin * 100 + LvarMesFin>
<cfelseif rsSQL.CPPestado NEQ "1">
	<cf_errorCode	code = "50455"
					msg  = "No esta abierto el Período de Presupuesto @errorDat_1@"
					errorDat_1="#rsSQL.CPPdescripcion#"
	>
<cfelse>
	<cfset LvarCPPid 			= rsSQL.CPPid>
	<cfset LvarTipo				= "Período de Presupuesto">
	<cfset LvarMesN   			= rsSQL.CPPtipoPeriodo>
	<cfset LvarAnoIni			= datepart("yyyy",rsSQL.CPPfechaDesde)>
	<cfset LvarMesIni			= datepart("m",rsSQL.CPPfechaDesde)>
	<cfset LvarAnoFin			= datepart("yyyy",rsSQL.CPPfechaHasta)>
	<cfset LvarMesFin			= datepart("m",rsSQL.CPPfechaHasta)>
	<cfset LvarAnoMesFin		= LvarAnoFin * 100 + LvarMesFin>
</cfif>


<cfset LobjAjuste = createObject( "component","sif.Componentes.PRES_cargarSaldosContablesP")>
<cfset SaldosContablesP = LobjAjuste.CreaSaldosContablesP()>

<cfif rsImportador.CPCano1 NEQ  LvarAnoIni>
	<cf_errorCode	code = "50492"
					msg  = "El año inicial de la Importacion @errorDat_1@ no corresponde con el año inicial del @errorDat_2@ @errorDat_3@-@errorDat_4@"
					errorDat_1="#rsImportador.CPCano1#"
					errorDat_2="#LvarTipo#"
					errorDat_3="#LvarAnoIni#"
					errorDat_4="#LvarMesIni#"
	>
</cfif>
<cfif rsImportador.CPCmes1 NEQ  LvarMesIni>
	<cf_errorCode	code = "50493"
					msg  = "El mes inicial de la Importacion @errorDat_1@ no corresponde con el mes inicial del @errorDat_2@ @errorDat_3@-@errorDat_4@"
					errorDat_1="#rsImportador.CPCmes1#"
					errorDat_2="#LvarTipo#"
					errorDat_3="#LvarAnoIni#"
					errorDat_4="#LvarMesIni#"
	>
</cfif>

<cfset LvarCtaAnterior	= "">
<cfset LvarOfiAnterior	= "">

<cfset session.Importador.SubTipo = "2">

<cfloop query="rsImportador">
	<cfset session.Importador.Avance = rsImportador.currentRow/rsImportador.recordCount>

	<cfif (rsImportador.currentRow mod 179 EQ 0)>
		<cfoutput>
			<!-- Flush:
				#repeatString("*",1024)#
			-->
		</cfoutput>
		<!--- veamos si hay que cancelar el proceso --->
		<cfflush>
	</cfif>
	
	<cfscript>
		LvarCtaActual = trim(rsImportador.Cformato);
		LvarOfiActual = trim(rsImportador.Oficodigo);
			
		if (LvarCtaAnterior NEQ LvarCtaActual)
		{
			LvarCtaAnterior = LvarCtaActual;
			LvarOfiAnterior = "";
			LvarCcuenta 	= "";

			rsSQL = fnQuery("
								select c.Ccuenta, cf.CFcuenta, cv.CPVid, cf.CPcuenta, CPformato
								  from CContables c
									left join CFinanciera cf 
										left join CPVigencia cv
											 on cv.CPVid = cf.CPVid
											and #LvarAnoMesFin# between cv.CPVdesdeAnoMes and cv.CPVhastaAnoMes
										left join CPresupuesto p 
										  on p.CPcuenta = cf.CPcuenta
									  on cf.Ccuenta = c.Ccuenta
								 where c.Ecodigo	= #session.Ecodigo# 
								   AND c.Cmayor		= '#mid(rsImportador.Cformato,1,4)#'
								   AND c.Cformato	= '#rsImportador.Cformato#'
							");

			if (rsSQL.Ccuenta EQ "")
			{
				sbError ("FATAL", "No existe la Cuenta Contable '#rsImportador.Cformato#'");
				continue;
			}
			if (rsSQL.CFcuenta EQ "")
			{
				sbError ("FATAL", "No existe una Cuenta Financiera vigente asociada a la Cuenta Contable '#rsImportador.Cformato#'");
				continue;
			}
			if (rsSQL.CFcuenta EQ "")
			{
				sbError ("FATAL", "No existe una Cuenta Financiera vigente asociada a la Cuenta Contable '#rsImportador.Cformato#'");
				continue;
			}
			if (rsSQL.CPcuenta NEQ "" AND LvarCPPid NEQ -1)
			{
				sbError ("FATAL", "La Cuenta Contable '#rsImportador.Cformato#' tiene asociada la Cuenta de Presupuesto '#rsSQL.CPformato#', no puede incluirse en el archivo de Importación");
				continue;
			}
			LvarCcuenta = rsSQL.Ccuenta;
		}
		
		if (LvarOfiAnterior NEQ LvarOfiActual)
		{
			LvarOfiAnterior = LvarOfiActual;

			rsQRY = fnQuery("
								select Ocodigo from Oficinas where Ecodigo=#session.Ecodigo# and Oficodigo='#LvarOfiActual#'
							");
			if (rsQRY.Ocodigo NEQ "")
				LvarOcodigo = rsQRY.Ocodigo;
			else
			{
				LvarOcodigo = "";
				sbError ("FATAL", "Codigo de Oficina '#LvarOfiActual#' no existe");
				continue;
			}
		}

		if (LvarCcuenta NEQ "" AND LvarOcodigo NEQ "")
		{
			if (rsImportador.CPCano1 NEQ LvarAnoIni OR rsImportador.CPCmes1 NEQ LvarMesIni)
			{
				sbError ("FATAL", "Se cambio el año y mes inicial de la Importacion con la Fecha Inicial del Período: Cuenta '#rsImportador.Cformato#', Oficina '#rsImportador.Oficodigo#', Moneda '#rsImportador.Miso4217#', Mes Inicial '#rsImportador.CPCano1#-#rsImportador.CPCmes1#'");
				continue;
			}

			rsSQL = fnQuery("
								select count(1) as cantidad
								  from #SaldosContablesP#
								 where Ecodigo	= #session.Ecodigo# 
								   AND Ccuenta	= #LvarCcuenta# 
								   AND Speriodo	= #LvarAnoIni#
								   AND Smes		= #LvarMesIni#
								   AND Ocodigo	= #LvarOcodigo#
							");
			if (rsSQL.cantidad NEQ 0)
			{
				sbError ("FATAL", "Se está intentando cargar más de una vez la misma Cuenta: Cuenta '#rsImportador.Cformato#', Oficina '#rsImportador.Oficodigo#'");
				continue;
			}

			LvarAno = LvarAnoIni;
			LvarMes = LvarMesIni;
			for (i=1; i LTE 12; i=i+1)
			{
				LvarAnoMes = LvarAno*100+LvarMes;
				LvarMonto = rsImportador["Monto" & i];
				if (LvarMonto NEQ "" AND NOT isnumeric(LvarMonto))
				{
					sbError ("FATAL", "El monto debe ser numerico '#LvarMonto#': Cuenta '#rsImportador.Cformato#', Oficina '#rsImportador.Oficodigo#', Moneda '#rsImportador.Miso4217#', Mes '#LvarAno#-#LvarMes#'");
					break;
				}
				if (NOT (LvarMonto EQ "" OR LvarMonto EQ 0 AND LvarAnoMes GT LvarAnoMesFin)) //  AND val(LvarMonto) GT 0 
				{
					if (LvarAnoMes GT LvarAnoMesFin)
					{
						sbError ("FATAL", "Se definieron más montos que el numero de meses del Periodo: Cuenta '#rsImportador.Cformato#', Oficina '#rsImportador.Oficodigo#', Moneda '#rsImportador.Miso4217#', Mes '#LvarAno#-#LvarMes#'");
						break;
					}
					
					sbExecute ("
									insert into #SaldosContablesP# (
										Ecodigo, Ccuenta, Speriodo, Smes, Ocodigo, SPinicial, MLmonto, SPfinal
									)
									values (
										#session.Ecodigo#, #LvarCcuenta#, #LvarAno#, #LvarMes#, #LvarOcodigo#,
										0.00, #round(LvarMonto*100)/100#, 0.00
									 )
								");
				}
				
				LvarMes = LvarMes + 1;
				if (LvarMes GT 12)
				{
					LvarMes = 1;
					LvarAno = LvarAno + 1;
				}
			}
		}
	</cfscript>
</cfloop>

<cfset ERR = fnVerificaErrores()>

<cfquery name="rsERR" dbtype="query">
	select count(1) as cantidad 
	  from ERR
	 where LVL = 'FATAL'
</cfquery>

<cfif rsERR.cantidad EQ "" or rsERR.cantidad EQ 0>
	<cfquery name="rsAnoMes" datasource="#session.dsn#">
		select distinct Speriodo, Smes
		  from #SaldosContablesP#
	</cfquery>

	<!--- La transaccion se controla en el componente, genera error si se hace un "nesting" --->
	<!--- <cftransaction> --->
		<cfset LvarCant1 = LobjAjuste.sbActualizaSaldosContablesP(rsAnoMes, session.dsn)>
	<!--- </cftransaction> --->
	
	<cfoutput>
	<cfif LvarCPPid EQ -1>
		<script language="javascript">
			alert ("Se importaron <cfoutput>#LvarCant1#</cfoutput> Saldos de Presupuesto Contable sin Control de Presupuesto");
		</script>
	<cfelse>
		<cfset LvarCant2 = LobjAjuste.CargaPresupuestoConta(session.Ecodigo, LvarCPPid, session.dsn)>

		<script language="javascript">
			alert ("Se importaron <cfoutput>#LvarCant1#</cfoutput> Saldos de Presupuesto Contable sin Control de Presupuesto\nSe cargaron <cfoutput>#LvarCant2#</cfoutput> Saldos de Presupuesto Contable desde Control de Presupuesto");
		</script>
	</cfif>
	</cfoutput>
</cfif>

<cfset session.Importador.SubTipo = 3>


