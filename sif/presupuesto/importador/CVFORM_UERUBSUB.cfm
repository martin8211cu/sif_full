<cfinclude template="FnScripts.cfm">
<cfset LobjAjuste = createObject( "component","sif.Componentes.PRES_Formulacion")>
<cfquery name="rsSQL" datasource="#session.dsn#">
	select Pvalor
	  from Parametros
	 where Ecodigo = #session.Ecodigo#
	   and Pcodigo = 50
</cfquery>
<cfset LvarAuxAno = rsSQL.Pvalor>

<cfquery name="rsSQL" datasource="#session.dsn#">
	select Pvalor
	  from Parametros
	 where Ecodigo = #session.Ecodigo#
	   and Pcodigo = 60
</cfquery>
<cfset LvarAuxMes = rsSQL.Pvalor>
<cfset LvarAuxAnoMes = LvarAuxAno*100+LvarAuxMes>

<cfparam name="session.CVid" default="-1">

<cfquery name="rsSQL" datasource="#session.dsn#">
	select CVtipo, CVaprobada, v.CPPid, CPPestado, CPPfechaDesde, CPPtipoPeriodo, CPPanoMesDesde, CPPanoMesHasta
	  from CVersion v
			INNER JOIN CPresupuestoPeriodo p
				ON p.CPPid = v.CPPid
	 where v.CVid = #session.CVid#
</cfquery>

<cfquery  name="rsImportador" datasource="#session.dsn#">
  select * from #table_name# 
  order by UnidadEjecutora,Rubro,Subrubro, Oficodigo, Miso4217
</cfquery>


<cfparam name="session.chkNuevas" default="false">
<cfif rsSQL.recordCount EQ 0>
	<cf_errorCode	code = "50484" msg = "No se ha indicado la Version de Presupuesto a Trabajar">
<cfelseif rsSQL.CVaprobada NEQ "0">
	<cf_errorCode	code = "50485" msg = "La Version de Presupuesto ya fue Aprobada">
<cfelseif trim(rsImportador.UnidadEjecutora) EQ "">
	<cf_errorCode	code = "50486" msg = "El primer valor del archivo viene en blanco">
<cfelseif rsSQL.CVtipo EQ "1">
	<cfset LvarAprobacion = true>
	<cfset LvarChkNuevas = true>
	<cfif rsSQL.CPPestado NEQ "0">
		<cfquery name="rsSQL1" datasource="#session.dsn#">
			select 	count(1) as cantidad
			  from CVersion v
					INNER JOIN CPresupuestoPeriodo p
						ON p.CPPid = v.CPPid
			 where v.Ecodigo 	= #session.Ecodigo#
			   and v.CPPid 		= #rsSQL.CPPid#
			   and v.CVtipo		= '2'
			   and v.CVaprobada	= 1
		</cfquery>
		<cfif rsSQL1.cantidad NEQ 0>
			<cf_errorCode	code = "50487" msg = "La versión de Formulación es de Aprobación de Presupuesto Ordinario pero el Período ya tiene Modificación Presupuesto Extraordinario aprobadas">
		</cfif>
	</cfif>
<cfelse>
	<cfset LvarAprobacion = false>
	<cfset LvarChkNuevas = session.chkNuevas>
	<cfif rsSQL.CPPestado NEQ "1">
		<cf_errorCode	code = "50488" msg = "La versión de Formulación es de Modificación Presupuesto Extraordinario pero el Período de Presupuesto no está abierto">
	<cfelseif LvarChkNuevas>
		<cfset sbError ("INFO", "Se va a validar que la Modificación Presupuesto Extraordinario sólo permita Formulaciones Nuevas")>
	</cfif>
</cfif>

<cfset LvarCPPid = rsSQL.CPPid>

<cfif LvarAprobacion>
	<cfif (rsImportador.CPCano1*100+rsImportador.CPCmes1) NEQ rsSQL.CPPanoMesDesde>
		<cf_errorCode	code = "50489" msg = "El mes inicial de la Importacion no corresponde con el Inicio del Período">
	</cfif>
	<cfset LvarFechaIni = rsSQL.CPPfechaDesde>
	<cfset LvarAnoIni = datepart("yyyy",LvarFechaIni)>
	<cfset LvarMesIni = datepart("m",LvarFechaIni)>
	<cfset LvarAnoMesFin = rsSQL.CPPanoMesHasta>
<cfelse>
	<cfif NOT session.chkMesesAnt AND (rsImportador.CPCano1*100+rsImportador.CPCmes1) LT LvarAuxAnoMes>
		<cf_errorCode	code = "50490"
						msg  = "El mes inicial de la Importacion debe comenzar igual o despues del Mes de Auxiliares: @errorDat_1@-@errorDat_2@"
						errorDat_1="#LvarAuxAno#"
						errorDat_2="#LvarAuxMes#"
		>
	<cfelseif (rsImportador.CPCano1*100+rsImportador.CPCmes1) LT rsSQL.CPPanoMesDesde OR (rsImportador.CPCano1*100+rsImportador.CPCmes1) GT rsSQL.CPPanoMesHasta>
		<cf_errorCode	code = "50491" msg = "El mes inicial de la Importacion no está dentro del Período de Presupuesto">
	</cfif>
	<cfset LvarFechaIni = createDate(rsImportador.CPCano1, rsImportador.CPCmes1, 1)>
	<cfset LvarAnoIni = datepart("yyyy",LvarFechaIni)>
	<cfset LvarMesIni = datepart("m",LvarFechaIni)>
	<cfset LvarAnoMesFin = rsSQL.CPPanoMesHasta>
</cfif>

<cfset LvarMesN   = rsSQL.CPPtipoPeriodo>

<cfset session.Importador.SubTipo = "2">

<cfset LvarCtaAnterior = "">

<cf_dbtemp name="Datos" returnvariable="Cuentas" datasource="#session.dsn#">
	<cf_dbtempcol name="UnidadEjecutora"	type="varchar(100)"  	 mandatory="yes">
	<cf_dbtempcol name="Rubro"				type="varchar(100)"  	 mandatory="yes">
	<cf_dbtempcol name="Subrubro"			type="varchar(100)"  	 mandatory="yes">
	<cf_dbtempcol name="Oficina"  			type="varchar(100)"  	 mandatory="yes">
	<cf_dbtempcol name="Moneda"  			type="varchar(100)"  	 mandatory="yes">
	<cf_dbtempcol name="TipoControl"  		type="varchar(100)"  	 mandatory="yes">
	<cf_dbtempcol name="CalculoControl"  	type="varchar(100)"  	 mandatory="yes">
	<cf_dbtempcol name="Mes"  				type="varchar(100)"  	 mandatory="yes">
 	<cf_dbtempcol name="Periodo"  			type="varchar(100)"  	 mandatory="yes">
 	<cf_dbtempcol name="Cuenta"  			type="varchar(100)"  	 mandatory="yes">
 	<cf_dbtempcol name="RubroSub"  			type="varchar(100)"  	 mandatory="yes">
 	<cf_dbtempcol name="Monto1"  			type="numeric"		  	 mandatory="yes">
 	<cf_dbtempcol name="Monto2"  			type="numeric"  	 	 mandatory="yes">
 	<cf_dbtempcol name="Monto3"  			type="numeric"  	 	 mandatory="yes">
 	<cf_dbtempcol name="Monto4"  			type="numeric"  	 	 mandatory="yes">
 	<cf_dbtempcol name="Monto5"  			type="numeric"  	 	 mandatory="yes">
 	<cf_dbtempcol name="Monto6"  			type="numeric"  	 	 mandatory="yes">
 	<cf_dbtempcol name="Monto7"  			type="numeric"  	 	 mandatory="yes">
 	<cf_dbtempcol name="Monto8"  			type="numeric"  	 	 mandatory="yes">
 	<cf_dbtempcol name="Monto9"  			type="numeric"  	 	 mandatory="yes">
 	<cf_dbtempcol name="Monto10"  			type="numeric"  	 	 mandatory="yes">
 	<cf_dbtempcol name="Monto11"  			type="numeric"  	 	 mandatory="yes">
 	<cf_dbtempcol name="Monto12"  			type="numeric"  	 	 mandatory="yes">
 	
</cf_dbtemp>




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

		<cfquery datasource="#Session.Dsn#">
			insert into #Cuentas#
					(
					UnidadEjecutora,
					Rubro,
					Subrubro,
					Oficina,
					Moneda,
					TipoControl,
					CalculoControl,
					Mes,
					Periodo,
					Cuenta,
					RubroSub,
					Monto1,Monto2,Monto3,Monto4,Monto5,Monto6,Monto7,Monto8,Monto9,Monto10,Monto11,Monto12
					)
			select 	distinct a.UnidadEjecutora,
					a.Rubro,
					a.Subrubro,
					a.Oficodigo,
					a.Miso4217,
					a.CVPtipoControl,
					a.CVPcalculoControl,
					a.CPCmes1,
					a.CPCano1,
					'',
					a.Rubro+a.Subrubro,
					Monto1,Monto2,Monto3,Monto4,Monto5,Monto6,Monto7,Monto8,Monto9,Monto10,Monto11,Monto12
			from #table_name#  a
			where UnidadEjecutora = '#rsImportador.UnidadEjecutora#'
			and Rubro = '#rsImportador.Rubro#'
			and Subrubro = '#rsImportador.Subrubro#'
		</cfquery>
 
		<cfquery name="rsConceptos" datasource="#session.dsn#">
			select substring(a.Cformato,1,4) + '-' + b.UnidadEjecutora + '-' + b.Rubro + '-' + b.Subrubro as Cuenta,
			substring(a.CtaAnticipo,1,4) + '-' + b.UnidadEjecutora + '-' + b.Rubro + '-' + b.Subrubro as CtaAnticipo,
			substring(a.Cformato,1,4) as CtaMayor, b.Rubro + b.Subrubro as RubroSub,b.UnidadEjecutora,b.Subrubro,
			b.Rubro,a.PorcentajeCtaGasto,
			Monto1,Monto2,Monto3,Monto4,Monto5,Monto6,Monto7,Monto8,Monto9,Monto10,Monto11,Monto12
			from Conceptos a
				inner join #Cuentas# b
			on a.Ccodigo = b.Rubro+b.Subrubro
			where Ecodigo = '#Session.Ecodigo#'
			and b.UnidadEjecutora = '#rsImportador.UnidadEjecutora#'
			and b.Rubro = '#rsImportador.Rubro#'
			and b.Subrubro = '#rsImportador.Subrubro#'
		</cfquery>

		<cfquery name="rs" datasource="#session.dsn#">
			Update #Cuentas#
			set Cuenta = '#rsConceptos.Cuenta#'
			where UnidadEjecutora = '#rsConceptos.UnidadEjecutora#'
			and Rubro = '#rsConceptos.Rubro#'
			and Subrubro = '#rsConceptos.Subrubro#'
		</cfquery>

		<cfif isdefined("rsConceptos.CtaAnticipo") and rsConceptos.CtaAnticipo NEQ ''>				
			<cfquery datasource="#Session.Dsn#">
			insert into #Cuentas#
					(
					UnidadEjecutora,
					Rubro,
					Subrubro,
					Oficina,
					Moneda,
					TipoControl,
					CalculoControl,
					Mes,
					Periodo,
					Cuenta,
					RubroSub,
					Monto1,Monto2,Monto3,Monto4,Monto5,Monto6,Monto7,Monto8,Monto9,Monto10,Monto11,Monto12
					)
			select 	distinct a.UnidadEjecutora,
					a.Rubro,
					a.Subrubro,
					a.Oficodigo,
					a.Miso4217,
					a.CVPtipoControl,
					a.CVPcalculoControl,
					a.CPCmes1,
					a.CPCano1,
					'#rsConceptos.CtaAnticipo#',
					a.Rubro+a.Subrubro,
					Monto1,Monto2,Monto3,Monto4,Monto5,Monto6,Monto7,Monto8,Monto9,Monto10,Monto11,Monto12
			from #table_name#  a
			where UnidadEjecutora = '#rsImportador.UnidadEjecutora#'
			and Rubro = '#rsImportador.Rubro#'
			and Subrubro = '#rsImportador.Subrubro#'
		</cfquery>

		<cfquery name="rsCtasGasto" datasource="#session.dsn#">
			Update #Cuentas#
			set Monto1  = (Monto1  * #rsConceptos.PorcentajeCtaGasto#)/100,
				Monto2  = (Monto2  * #rsConceptos.PorcentajeCtaGasto#)/100,
				Monto3  = (Monto3  * #rsConceptos.PorcentajeCtaGasto#)/100,
				Monto4  = (Monto4  * #rsConceptos.PorcentajeCtaGasto#)/100,
				Monto5  = (Monto5  * #rsConceptos.PorcentajeCtaGasto#)/100,
				Monto6  = (Monto6  * #rsConceptos.PorcentajeCtaGasto#)/100,
				Monto7  = (Monto7  * #rsConceptos.PorcentajeCtaGasto#)/100,
				Monto8  = (Monto8  * #rsConceptos.PorcentajeCtaGasto#)/100,
				Monto9  = (Monto9  * #rsConceptos.PorcentajeCtaGasto#)/100,
				Monto10 = (Monto10 * #rsConceptos.PorcentajeCtaGasto#)/100,
				Monto11 = (Monto11 * #rsConceptos.PorcentajeCtaGasto#)/100,
				Monto12 = (Monto12 * #rsConceptos.PorcentajeCtaGasto#)/100
			where UnidadEjecutora = '#rsConceptos.UnidadEjecutora#'
			and Rubro = '#rsConceptos.Rubro#'
			and Subrubro = '#rsConceptos.Subrubro#'
			and Cuenta = '#rsConceptos.Cuenta#'
		</cfquery>

		<cfquery name="rs" datasource="#session.dsn#">
			Update #Cuentas#
			set Monto1 = Monto1-
						(select Monto1 from #Cuentas#
							where UnidadEjecutora = '#rsConceptos.UnidadEjecutora#'
							and Rubro = '#rsConceptos.Rubro#'
							and Subrubro = '#rsConceptos.Subrubro#'
							and Cuenta = '#rsConceptos.Cuenta#'),
				Monto2 = Monto2-
						(select Monto2 from #Cuentas#
							where UnidadEjecutora = '#rsConceptos.UnidadEjecutora#'
							and Rubro = '#rsConceptos.Rubro#'
							and Subrubro = '#rsConceptos.Subrubro#'
							and Cuenta = '#rsConceptos.Cuenta#'),
				Monto3 = Monto3-
						(select Monto3 from #Cuentas#
							where UnidadEjecutora = '#rsConceptos.UnidadEjecutora#'
							and Rubro = '#rsConceptos.Rubro#'
							and Subrubro = '#rsConceptos.Subrubro#'
							and Cuenta = '#rsConceptos.Cuenta#'),
				Monto4 = Monto4-
						(select Monto4 from #Cuentas#
							where UnidadEjecutora = '#rsConceptos.UnidadEjecutora#'
							and Rubro = '#rsConceptos.Rubro#'
							and Subrubro = '#rsConceptos.Subrubro#'
							and Cuenta = '#rsConceptos.Cuenta#'),
				Monto5 = Monto5-
						(select Monto5 from #Cuentas#
							where UnidadEjecutora = '#rsConceptos.UnidadEjecutora#'
							and Rubro = '#rsConceptos.Rubro#'
							and Subrubro = '#rsConceptos.Subrubro#'
							and Cuenta = '#rsConceptos.Cuenta#'),
				Monto6 = Monto6-
						(select Monto6 from #Cuentas#
							where UnidadEjecutora = '#rsConceptos.UnidadEjecutora#'
							and Rubro = '#rsConceptos.Rubro#'
							and Subrubro = '#rsConceptos.Subrubro#'
							and Cuenta = '#rsConceptos.Cuenta#'),
				Monto7 = Monto7-
						(select Monto7 from #Cuentas#
							where UnidadEjecutora = '#rsConceptos.UnidadEjecutora#'
							and Rubro = '#rsConceptos.Rubro#'
							and Subrubro = '#rsConceptos.Subrubro#'
							and Cuenta = '#rsConceptos.Cuenta#'),
				Monto8 = Monto8-
						(select Monto8 from #Cuentas#
							where UnidadEjecutora = '#rsConceptos.UnidadEjecutora#'
							and Rubro = '#rsConceptos.Rubro#'
							and Subrubro = '#rsConceptos.Subrubro#'
							and Cuenta = '#rsConceptos.Cuenta#'),
				Monto9 = Monto9-
						(select Monto9 from #Cuentas#
							where UnidadEjecutora = '#rsConceptos.UnidadEjecutora#'
							and Rubro = '#rsConceptos.Rubro#'
							and Subrubro = '#rsConceptos.Subrubro#'
							and Cuenta = '#rsConceptos.Cuenta#'),
				Monto10 = Monto10-
						(select Monto10 from #Cuentas#
							where UnidadEjecutora = '#rsConceptos.UnidadEjecutora#'
							and Rubro = '#rsConceptos.Rubro#'
							and Subrubro = '#rsConceptos.Subrubro#'
							and Cuenta = '#rsConceptos.Cuenta#'),
				Monto11 = Monto11-
						(select Monto11 from #Cuentas#
							where UnidadEjecutora = '#rsConceptos.UnidadEjecutora#'
							and Rubro = '#rsConceptos.Rubro#'
							and Subrubro = '#rsConceptos.Subrubro#'
							and Cuenta = '#rsConceptos.Cuenta#'),
				Monto12 = Monto12-
						(select Monto12 from #Cuentas#
							where UnidadEjecutora = '#rsConceptos.UnidadEjecutora#'
							and Rubro = '#rsConceptos.Rubro#'
							and Subrubro = '#rsConceptos.Subrubro#'
							and Cuenta = '#rsConceptos.Cuenta#')
			where UnidadEjecutora = '#rsConceptos.UnidadEjecutora#'
			and Rubro = '#rsConceptos.Rubro#'
			and Subrubro = '#rsConceptos.Subrubro#'
			and Cuenta = '#rsConceptos.CtaAnticipo#'
		</cfquery>

		</cfif>
	</cfloop>


	<cfquery  name="rsDatos" datasource="#session.dsn#">
	  select * from #Cuentas#
	</cfquery>


	<cfloop query="rsDatos">
		<cfscript>
			LvarCtaActual = trim(rsDatos.Cuenta);
			LvarOfiActual = trim(rsDatos.Oficina);
			LvarMoneda = trim(rsDatos.Moneda);

			/* if (LvarCtaAnterior NEQ LvarCtaActual)
			{ */
				/* LvarCtaAnterior = LvarCtaActual;
				LvarOfiAnterior = "";
				LvarCPcuenta 	= "";
 */

				if (LvarCtaActual EQ "")
				{	
					sbError 
					(
						"FATAL", "No se ha definido la cuenta de Gasto en el Concepto de Servicio 
						#rsDatos.RubroSub#"
					);
					break;
				}

				if (rsDatos.TipoControl EQ "")
					LvarCVPtipoControl = -1;	
				else
					LvarCVPtipoControl = rsDatos.TipoControl;
				
				if (rsDatos.CalculoControl EQ "")
					LvarCVPcalculoControl = -1;
				else
					LvarCVPcalculoControl = rsDatos.CalculoControl;
				
				LvarError = fnGeneraCuentaVersion (rsDatos.Cuenta, LvarFechaIni, session.CVid, LvarCVPtipoControl, LvarCVPcalculoControl, 'Cuenta creada en Formulación');

				if (LvarError EQ "NEW" OR LvarError EQ "OLD")
				{
					rsSQL = fnQuery("
										select 	cp.CPcuenta
										  from CPresupuesto cp
											inner join CPVigencia vg
											   on vg.Ecodigo	= cp.Ecodigo
											  and vg.Cmayor 	= cp.Cmayor
											  and vg.CPVid 		= cp.CPVid
											  and #rsDatos.Periodo*100 + rsDatos.Mes# between vg.CPVdesdeAnoMes and vg.CPVhastaAnoMes
										 where cp.CPformato 	='#rsDatos.Cuenta#'
										   and cp.Ecodigo		= #session.Ecodigo#
									");
					LvarCPcuenta  = rsSQL.CPcuenta;

					rsSQL = fnQuery("
										select CVPcuenta, CVPtipoControl, CVPcalculoControl, CPdescripcion
										  from CVPresupuesto
										 where Ecodigo=#session.Ecodigo# 
										   AND CVid=#session.CVid# 
										   AND Cmayor='#mid(rsDatos.Cuenta,1,4)#'
										   AND CPformato='#rsDatos.Cuenta#'
									");
					LvarCVPcuenta = rsSQL.CVPcuenta;

					if ( (LvarCVPtipoControl NEQ -1 AND LvarCVPtipoControl NEQ rsSQL.CVPtipoControl and LvarCVPcuenta NEQ '' ) OR (LvarCVPcalculoControl NEQ -1 AND LvarCVPcalculoControl NEQ rsSQL.CVPcalculoControl and LvarCVPcuenta NEQ '') )
					{
						sbExecute ("
									update CVPresupuesto
									   set CVPtipoControl 		= #LvarCVPtipoControl#
										 , CVPcalculoControl 	= #LvarCVPcalculoControl#
									 where Ecodigo		=#session.Ecodigo# 
									   AND CVid			=#session.CVid# 
									   AND CVPcuenta	=#LvarCVPcuenta#
									");
						sbError ("INFO", "La Cuenta de Presupuesto '#rsConceptos.Cuenta#' ya existía y se actualizó su tipo y método de Control");
					}
					/* if (rsImportador.CPdescripcion NEQ "" AND rsImportador.CPdescripcion NEQ rsSQL.CPdescripcion)
					{
						sbExecute ("
									update CVPresupuesto
									   set CPdescripcion = '#rsImportador.CPdescripcion#'
									 where Ecodigo		= #session.Ecodigo# 
									   AND CVid			= #session.CVid# 
									   AND CVPcuenta	= #LvarCVPcuenta#
									");
						sbError ("INFO", "La Cuenta de Presupuesto '#rsImportador.CPformato#' ya existía y se actualizó su Descripcion");
					} */
				}
				 else
				{
					LvarCVPcuenta = "";
					sbError ("FATAL", "Cuenta de Presupuesto '#rsConceptos.Cuenta#': " & LvarError);
					continue;
				} 
			/* } */
			
			/* if (LvarOfiAnterior NEQ LvarOfiActual)
			{ */
				LvarOfiAnterior = LvarOfiActual;

				LvarPrimerMonedaXoficina = arraynew(1);
				for (i=1; i LTE 12; i = i +1)
					LvarPrimerMonedaXoficina[i] = true;
			/* } */
			
			if (LvarCVPcuenta NEQ "")
			{
				LvarMonAnterior = "";

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

			if (LvarCVPcuenta NEQ "" AND LvarOcodigo NEQ "")
			{
				if (LvarChkNuevas AND LvarCPcuenta NEQ "")
				{
					rsSQL = fnQuery("
										select p.CPformato
										  from CPresupuestoControl c
											inner join CPresupuesto p
												 on p.CPcuenta = c.CPcuenta
										   where c.Ecodigo 	= #session.Ecodigo# 
											 and c.CPPid 	= #LvarCPPid#
											 and c.CPcuenta = #LvarCPcuenta#
											 and c.Ocodigo	= #LvarOcodigo#
									");
					if (rsSQL.CPformato NEQ "")
					{
						if (LvarAprobacion)
								sbError ("FATAL", "Cuenta de Presupuesto '#rsSQL.CPformato#' ya fue formulada en la Oficina='#LvarOfiActual#'. No puede volver a incluirse en una Version de Presupuesto Original.");
							else
								sbError ("FATAL", "Cuenta de Presupuesto '#rsSQL.CPformato#' ya fue formulada en la Oficina='#LvarOfiActual#'. Sólo se permiten Formulaciones Nuevas.");
						continue;
					}
				}
				rsQRY = fnQuery("
									select Mcodigo from Monedas where Ecodigo=#session.Ecodigo# and Miso4217='#LvarMoneda#'
								");
				if (rsQRY.Mcodigo NEQ "")
					LvarMcodigo = rsQRY.Mcodigo;
				else
				{
					sbError ("FATAL", "Codigo de Moneda '#LvarMoneda#' no existe");
					continue;
				}

				if (rsDatos.Periodo NEQ LvarAnoIni OR rsDatos.Mes NEQ LvarMesIni)
				{
					sbError ("FATAL", "Se cambio el año y mes inicial de la Importacion con la Fecha Inicial del Período: Cuenta '#rsDatos.Cuenta#', Oficina '#rsDatos.Oficina#', Moneda '#rsDatos.Moneda#', Mes Inicial '#rsDatos.Periodo#-#rsDatos.Mes#'");
					continue;
				}

				LvarAno = LvarAnoIni;
				LvarMes = LvarMesIni;
				for (i=1; i LTE 12; i=i+1)
				{
					LvarAnoMes = LvarAno*100+LvarMes;
					LvarMonto = rsDatos["Monto" & i];
					if (LvarMonto NEQ "" AND NOT isnumeric(LvarMonto))
					{
						sbError ("FATAL", "El monto debe ser numerico '#LvarMonto#': Cuenta '#rsDatos.Cuenta#', Oficina '#rsDatos.Oficina#', Moneda '#rsDatos.Moneda#', Mes '#LvarAno#-#LvarMes#'");
						break;
					}
					if (NOT (LvarMonto EQ "" OR LvarMonto EQ 0 AND LvarAnoMes GT LvarAnoMesFin)) //  AND val(LvarMonto) GT 0 
					{
						if (LvarAnoMes GT LvarAnoMesFin)
						{
							sbError ("FATAL", "Se definieron más montos que el numero de meses del Periodo: Cuenta '#rsDatos.Cuenta#', Oficina '#rsDatos.Oficina#', Moneda '#rsDatos.Moneda#', Mes '#LvarAno#-#LvarMes#'");
							break;
						}
						
						if (LvarPrimerMonedaXoficina[i] or true)
						{
							LvarPrimerMonedaXoficina[i] = false;						

							rsSQL = fnQuery("
												select count(1) as cantidad
												  from CVFormulacionTotales
												 where Ecodigo	=#session.Ecodigo# 
												   AND CVid		=#session.CVid# 
												   AND CPCano	=#LvarAno#
												   AND CPCmes	=#LvarMes#
												   AND CVPcuenta=#LvarCVPcuenta#
												   AND Ocodigo	=#LvarOcodigo#
											");
							if (rsSQL.cantidad GT 0)
							{
								sbError ("INFO", "Se sustituyó la Formulación para: Cuenta '#rsDatos.Cuenta#', Oficina '#rsDatos.Oficina#', Mes '#LvarAno#-#LvarMes#'");
								sbExecute ("
												update CVFormulacionTotales
												   set CVFTmontoSolicitado = 0
												 where Ecodigo	=#session.Ecodigo# 
												   AND CVid		=#session.CVid# 
												   AND CPCano	=#LvarAno#
												   AND CPCmes	=#LvarMes#
												   AND CVPcuenta=#LvarCVPcuenta#
												   AND Ocodigo	=#LvarOcodigo#
											");
							}
							else
							{
								sbExecute ("
											 insert into CVFormulacionTotales (
											   Ecodigo, CVid, CPCano, CPCmes, CVPcuenta, Ocodigo,
											   CVFTmontoSolicitado)
											 values( 
											   #session.Ecodigo#, #session.CVid#, #LvarAno#, #LvarMes#, #LvarCVPcuenta#, #LvarOcodigo#,
											   0)
											");
							}
						}
						
						sbExecute ("
										delete from CVFormulacionMonedas
										 where Ecodigo	= #session.Ecodigo# 
										   AND CVid		= #session.CVid# 
										   AND CPCano	= #LvarAno#
										   AND CPCmes	= #LvarMes#
										   AND CVPcuenta= #LvarCVPcuenta#
										   AND Ocodigo	= #LvarOcodigo#
										   AND Mcodigo	= #LvarMcodigo#
									");

						sbExecute ("
									 insert into CVFormulacionMonedas (
									   Ecodigo, CVid, CPCano, CPCmes, CVPcuenta, Ocodigo,
									   Mcodigo, CVFMtipoCambio, CVFMmontoBase)
									 values( 
									   #session.Ecodigo#, #session.CVid#, #LvarAno#, #LvarMes#, #LvarCVPcuenta#, #LvarOcodigo#,  
									   #LvarMcodigo#, null, #round(LvarMonto*100)/100#)
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
		<!--- Obtiene las Cuentas de Presupuesto existentes (correspondientes a las cuentas de Version) --->
		<!--- Actualiza los tipos de Cambio Proyectados por Mes y actualiza el monto a aplicar--->
		<!--- Actualiza los Totales de Formulacion por Cuenta+Año+Mes+Oficina (sin Moneda) --->
		<cfif LvarCVPcuenta NEQ "" and isnumeric(LvarCVPcuenta)>
			<cfif LvarOcodigo NEQ "" and isnumeric(LvarOcodigo)>
				<cfif isdefined("session.chkMesesAnt") and session.chkMesesAnt>
					<cfset request.CFaprobacion_MesesAnt = true>
				</cfif>
				<cfset LobjAjuste.AjustaFormulacion(session.CVid, LvarCVPcuenta, LvarOcodigo)>
			</cfif>
		</cfif>
	</cfloop>

	<cfthread	name="CreacionCPresupuesto" 
				action="run" 
				priority="LOW" 
	> 
		<cfinvoke 
			component="sif.Componentes.PC_GeneraCuentaFinanciera"
			method="sbCreaCPresupuestoDeVersion"
			Lprm_CVid="#session.CVid#"
			Lprm_Verificar="true"
		/>
	</cfthread> 
	<cfset ERR = fnVerificaErrores()>

<cffunction name="fnGeneraCuentaVersion" returntype="string" access="private">
	<cfargument name="LprmFormato" 				type="string" 	required="yes">
	<cfargument name="LprmFecha" 				type="date" 	required="yes">
	<cfargument name="LprmCVid" 				type="numeric" 	required="yes">
	<cfargument name="LprmCVPtipoControl" 		type="numeric" 	required="yes">
	<cfargument name="LprmCVPcalculoControl"	type="numeric" 	required="yes">
	<cfargument name="LprmCPdescripcion" 		type="string" 	required="yes">

	<cfinvoke 
		component="sif.Componentes.PC_GeneraCuentaFinanciera"
		method="fnGeneraCuentaFinanciera"
		returnvariable="Lvar_MsgError">
			<cfinvokeargument name="Lprm_CFformato" 			value="#Arguments.LprmFormato#"/>
			<cfinvokeargument name="Lprm_fecha" 				value="#Arguments.LprmFecha#"/>
			<cfinvokeargument name="Lprm_CrearPresupuesto"		value="yes"/>
			<cfinvokeargument name="Lprm_CVid"					value="#session.CVid#"/>
			<cfinvokeargument name="Lprm_CVPtipoControl"		value="#LprmCVPtipoControl#"/>
			<cfinvokeargument name="Lprm_CVPcalculoControl"		value="#LprmCVPcalculoControl#"/>
			<cfinvokeargument name="Lprm_Cdescripcion"			value="#LprmCPdescripcion#"/>
			<cfinvokeargument name="Lprm_TransaccionActiva" 	value="no"/>
	</cfinvoke>
	
	<cfreturn Lvar_MsgError>
</cffunction>

<cffunction name="fnTipoCambio" access="private" returntype="string">
	<cfargument name="CPCano"  type="numeric" required="yes">
	<cfargument name="CPCmes"  type="numeric" required="yes">
	<cfargument name="Mcodigo" type="numeric" required="yes">
	<cfargument name="Cmayor"  type="string"  required="yes">
	
	<!--- Obtiene Tipo Cambio Proyectado del mes --->
	<cfif Arguments.Mcodigo EQ qry_monedaEmpresa.Mcodigo>
		<cfreturn "1.00">
	<cfelse>
		<cfquery name="qry_CVTipoCambioProyectadoMes" datasource="#session.dsn#">
			select 	case when m.Ctipo='A' or m.Ctipo='G' 
							then CPTipoCambioVenta
							else CPTipoCambioCompra
					end as TipoCambio
			  from CPTipoCambioProyectadoMes p, CVMayor m
			 where p.Ecodigo = #Session.Ecodigo#
			   and p.CPCano 	= #Arguments.CPCano#
			   and p.CPCmes 	= #Arguments.CPCmes#
			   and p.Mcodigo 	= #Arguments.Mcodigo#
			   and m.Ecodigo 	= #Session.Ecodigo#
			   and m.CVid 		= #session.CVid#
			   and m.Cmayor 	= '#Arguments.Cmayor#'
		</cfquery>
		
		<cfif qry_CVTipoCambioProyectadoMes.TipoCambio EQ "">
			<cfreturn "null">
		<cfelse>
			<cfreturn qry_CVTipoCambioProyectadoMes.TipoCambio & "">
		</cfif>
	</cfif>
</cffunction>

