<!---
	Proceso que activa el Control de Presupuesto de una Cuenta de Mayor a medio periodo
	
	OPCION DE MENU Y PANTALLA:
		. PASO 1: 
			Poner en un combo todas las cuentas de mayor que no tienen presupuesto, para que el usuario indique cual desea activarle el presupuesto.
		. PASO 2: 
			Pintar la estructura de la máscara para que el usuario indique cuales van a ser los niveles que desea que sean de Presupuesto
			En caso de que la cuenta de mayor no tenga máscara asociada (Formato de Parámetros) se pinta una estructura con cada nivel en la máscara de parámetros 
			(Pero no van a tener catálogos)
			Dos combos adicionales para indicar el tipo y el calculo de control default para todas las cuentas a generar

	PROCESO:
		. Se cambia/crea la nueva mascara para utilizarla con la cuenta de mayor:
			1. Si la máscara se utiliza únicamente en la cuenta de mayor, se cambia los niveles de esta máscara
			2. Si no, si existe una máscara igual a la que se definió, se utiliza dicha máscara, y se cambia CPVigencia con la nueva máscara
			3. Si no, se crea una máscara nueva con dicha definición, y se cambia CPVigencia con la nueva máscara
			La descripción de la nueva máscara o de la máscara cambiada será la descripción original +  con Presupuesto
		. Se generan todas las cuentas de presupuesto en CPrespuesto a partir de las cuentas financieras existentes
		. Se generan los saldos en CPresupuestoControl con la información existente de Presupuesto Contable (SaldosContablesP) de la cuenta de mayor
		. Se crea un NAP de Ejecución Formulación por cada mes del periodo, con la información existente de pólizas contables (HEContables, HDContables)
--->
<cf_templateheader title="Activar Control Presupuestario a una Cuenta de Mayor">
	<cf_navegacion name="Cmayor"		default="">

	<!--- Obtiene el Periodo Contable --->
	<cfquery name="rsParametros" datasource="#session.DSN#">
		select 	ano.Pvalor as Ano,
				mes.Pvalor as Mes,
				ult.Pvalor as UltMes
		  from Parametros ano, Parametros mes, Parametros ult
		 where 	ano.Ecodigo = #session.Ecodigo# and ano.Pcodigo=30
		   and 	mes.Ecodigo = #session.Ecodigo# and mes.Pcodigo=40
		   and 	ult.Ecodigo = #session.Ecodigo# and ult.Pcodigo=45
	</cfquery>

	<cfif rsParametros.Ano EQ 0 or rsParametros.Mes EQ 0 or not isnumeric(rsParametros.Ano) or not isnumeric(rsParametros.Mes)>
		<cfset LvarRet.ERROR = "Empresa no ha sido iniciada">
		<cfreturn LvarRet>
	</cfif>
	
	<cfset LvarMesAct = rsParametros.Ano*100+rsParametros.Mes>
	<cfif rsParametros.UltMes EQ 12>
		<cfset LvarContaAnoMesIni = (rsParametros.Ano)*100+1>
		<cfset LvarContaAnoMesFin = (rsParametros.Ano)*100+12>
		<cfset LvarPeriodoConta = "De Enero a Diciembre de #rsParametros.Ano#">
	<cfelseif rsParametros.Mes GT rsParametros.UltMes>
		<cfset LvarContaAnoMesIni = (rsParametros.Ano)*100+(rsParametros.UltMes+1)>
		<cfset LvarContaAnoMesFin = (rsParametros.Ano+1)*100+(rsParametros.UltMes)>
		<cfset LvarPeriodoConta = "De #fnMesDeAno(LvarContaAnoMesIni)# a #fnMesDeAno(LvarContaAnoMesFin)#">
	<cfelse>
		<cfset LvarContaAnoMesIni = (rsParametros.Ano-1)*100+(rsParametros.UltMes+1)>
		<cfset LvarContaAnoMesFin = (rsParametros.Ano)*100+(rsParametros.UltMes)>
		<cfset LvarPeriodoConta = "De #fnMesDeAno(LvarContaAnoMesIni)# a #fnMesDeAno(LvarContaAnoMesFin)#">
	</cfif>

	<!--- Obtiene el Periodo de Presupuesto --->
	<cfquery name="rsCPP" datasource="#session.DSN#">
		select CPPid, CPPestado, CPPanoMesDesde, CPPanoMesHasta, CPPfechaDesde, CPPfechaHasta,
			<cf_dbfunction name="to_char" args="{fn year(CPPfechaDesde)}" datasource="#session.dsn#" returnVariable="LvarDesde">
			<cf_dbfunction name="to_char" args="{fn year(CPPfechaHasta)}" datasource="#session.dsn#" returnVariable="LvarHasta">
			<cf_dbfunction name="concat" args=
				"case CPPtipoPeriodo when 1 then 'Mensual' when 2 then 'Bimestral' when 3 then 'Trimestral' when 4 then 'Cuatrimestral' when 6 then 'Semestral' when 12 then 'Anual' else '' end
				+ ' de ' + 
				case {fn month(CPPfechaDesde)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
				+ ' ' + #LvarDesde#
				+ ' a ' + 
				case {fn month(CPPfechaHasta)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
				+ ' ' + #LvarHasta#" delimiters="+">
				as PeriodoPresupuesto
		  from CPresupuestoPeriodo
		 where Ecodigo = #session.Ecodigo#
		   and #LvarMesAct# between CPPanoMesDesde and CPPanoMesHasta
	</cfquery>

	<cfif rsCPP.recordCount EQ 0>
		<cf_errorCode	code = "50456" msg = "No existe un Período de Presupuesto para el Mes Contable Actual">
	<cfelseif rsCPP.CPPestado NEQ 1>
		<cf_errorCode	code = "50457" msg = "El Período de Presupuesto para el Mes Contable Actual no está Abierto">
	</cfif>
	
	<!--- 
		Obtiene los meses a procesar:
			LvarAnoMesInicial 	= mayor(ContaIni,PresIni)
			LvarAnoMesFinal 	= PresFin
	--->
	<cfif LvarContaAnoMesIni GT rsCPP.CPPanoMesDesde>
		<cfset LvarAnoMesInicial = LvarContaAnoMesIni>
	<cfelse>
		<cfset LvarAnoMesInicial = rsCPP.CPPanoMesDesde>
	</cfif>
	<cfset LvarAnoMesFinal = rsCPP.CPPanoMesHasta>
	<cfset LvarPeriodoProcesar = "De #fnMesDeAno(LvarAnoMesInicial)# a #fnMesDeAno(LvarAnoMesFinal)#">

	<cfoutput>
	<form name="frmArranque" method="post" action="CtasMayor.cfm">
		<table>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td width="80%" align="center" colspan="2" style="font-size:16px; font-weight:bold; color:##0000FF">
					Este proceso activa el Control de Presupuesto de una Cuenta de Mayor a medio periodo
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td>
					&nbsp;&nbsp;Mes Contable Actual: 
				</td>
				<td>
					#fnMesDeAno(LvarMesAct)#
				</td>
			</tr>
			<tr>
				<td>
					&nbsp;&nbsp;Período Contable: 
				</td>
				<td>
					#LvarPeriodoConta#
				</td>
			</tr>
			<tr>
				<td>
					&nbsp;&nbsp;Período de Presupuesto: 
				</td>
				<td>
					#rsCPP.PeriodoPresupuesto#
				</td>
			</tr>
			<tr>
				<td>
					&nbsp;&nbsp;Meses a Procesar: 
				</td>
				<td>
					<strong>#LvarPeriodoProcesar#</strong>
				</td>
			</tr>
			<tr>
				<td>
					&nbsp;&nbsp;Cuenta de Mayor
				</td>
				<td>
				<cfif form.Cmayor NEQ "">
					<cfquery name="rsCM" datasource="#session.DSN#">
						select m.Cmayor, m.Cdescripcion, 
								vg.CPVid, vg.PCEMid, vg.CPVformatoF, vg.CPVformatoPropio,
								coalesce(mp.PCEMplanCtas,0) as conPlan,
								mp.PCEMcodigo, mp.PCEMdesc,
								mp.PCEMformato, mp.PCEMformatoC, mp.PCEMformatoP
						  from CtasMayor m
							inner join CPVigencia vg
								left join PCEMascaras mp 
									 on mp.PCEMid = vg.PCEMid
							   on vg.Ecodigo	= m.Ecodigo
							  and vg.Cmayor 	= m.Cmayor
							  and #LvarMesAct# between vg.CPVdesdeAnoMes and vg.CPVhastaAnoMes
							  and PCEMformatoP IS NULL
						 where m.Ecodigo = #session.Ecodigo#
						   and m.Cmayor  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Cmayor#">
					</cfquery>
					<strong>
						#rsCM.Cmayor# - #rsCM.Cdescripcion#
						<input type="hidden" name="Cmayor" id="Cmayor" value="#rsCM.Cmayor#" />
					</strong>
					<cfif rsCM.PCEMid EQ "">
						(Sin Máscara)
						<cfif rsCM.CPVformatoPropio EQ 0>
							<cfset LvarTipo = "Sin Máscara, tiene formato de parámetros">
							<!--- Obtiene el formato de Parametros --->
							<cfquery name="rsSQL" datasource="#session.DSN#">
								select Pvalor
								  from Parametros
								 where Ecodigo = #session.Ecodigo# 
								   AND Pcodigo = 10
							</cfquery>
							<cfset rsCM.CPVformatoF = ucase(rsSQL.Pvalor)>
						<cfelse>
							<cfset LvarTipo = "Sin Máscara, tiene formato propio">
						</cfif>
						<cfset LvarTipo = LvarTipo & "<BR>Se va a crear una nueva máscara sin plan de cuentas">

						<!--- Determina si hay que crear una nueva mascara --->
						<cfset LvarCrearNueva = true>
						<!--- Crea los niveles de la máscara --->
						<cfset LvarNiv = listToArray(mid(rsCM.CPVformatoF,6,100),"-")>
						<cfset rsNiveles = queryNew(
									"PCNid, PCNdescripcion, PCEcatid, PCEcodigo, PCEdescripcion, PCNdep, PCNlongitud",
									"Integer, VarChar,      BigInt,   VarChar,   VarChar,        Integer, Integer"
						)>
						<cfset QueryAddRow(rsNiveles, arrayLen(LvarNiv))>
						<cfloop index="LvarPCNid" from="1" to="#arrayLen(LvarNiv)#">
							<cfset QuerySetCell(rsNiveles, "PCNid", 			LvarPCNid, LvarPCNid)>
							<cfset QuerySetCell(rsNiveles, "PCNdescripcion",	"Nivel #LvarPCNid#", LvarPCNid)>
							<cfset QuerySetCell(rsNiveles, "PCNlongitud",		len(trim(LvarNiv[LvarPCNid])), LvarPCNid)>
						</cfloop>
					<cfelse>
						<cfif rsCM.CPVformatoF NEQ rsCM.PCEMformato>
							<cf_errorCode	code = "50458"
											msg  = "Hay un error en la definición de la vigencia de la máscara de la cuenta @errorDat_1@"
											errorDat_1="#rsCM.Cmayor#"
							>
						<cfelseif rsCM.PCEMformato NEQ rsCM.PCEMformatoC>
							<cf_errorCode	code = "50459"
											msg  = "Hay un error en la definición de la máscara de la cuenta @errorDat_1@, todos los niveles tienen que ser contables"
											errorDat_1="#rsCM.Cmayor#"
							>
						</cfif>
					
						<cfif rsCM.conPlan EQ "1">
							(Con Plan)
							<cfset LvarTipo = "Con Plan de Cuentas (utiliza Catálogos de Valores por cada nivel de la Máscara)">
						<cfelse>
							(Sin Plan)
							<cfset LvarTipo = "Sin Plan de Cuentas">
						</cfif>

						<!--- Determina si hay que mantener o crear una nueva mascara --->
						<cfquery name="rsSQL" datasource="#session.DSN#">
							select count(1) as cantidad
							  from CPVigencia vg
							 where vg.PCEMid = #rsCM.PCEMid#
							   and NOT (vg.Ecodigo = #session.Ecodigo# AND vg.Cmayor = '#rsCM.Cmayor#')
						</cfquery>
						<cfset LvarCrearNueva = (rsSQL.cantidad GT 0)>
						<!--- Lee los niveles de la máscara --->
						<cfquery name="rsNiveles" datasource="#session.DSN#">
							select 	n.PCNid, n.PCNdescripcion, 
									n.PCEcatid, c.PCEcodigo, c.PCEdescripcion,
									n.PCNdep,
									n.PCNlongitud
							  from PCNivelMascara n
								left join PCECatalogo c
									 on c.PCEcatid = n.PCEcatid
							 where n.PCEMid = #rsCM.PCEMid#
						</cfquery>
					</cfif>
				<cfelse>
					<cfquery name="rsCM" datasource="#session.DSN#">
						select m.Cmayor, m.Cdescripcion, vg.PCEMid,
								coalesce((select PCEMplanCtas from PCEMascaras where PCEMid = vg.PCEMid),0) as conPlan
						  from CtasMayor m
							inner join CPVigencia vg
							   on vg.Ecodigo	= m.Ecodigo
							  and vg.Cmayor 	= m.Cmayor
							  and #LvarMesAct# between vg.CPVdesdeAnoMes and vg.CPVhastaAnoMes
							  and (select PCEMformatoP from PCEMascaras where PCEMid = vg.PCEMid) IS NULL
							  <!--- Solo se pueden activar cuentas con mascaras porque las otras son de tamaño variable --->
							  and vg.PCEMid is not null
						 where m.Ecodigo = #session.Ecodigo#
						 order by m.Cmayor
					</cfquery>
					<select name="Cmayor" id="Cmayor" onchange="this.form.btnSiguiente.disabled = this.value == '';">
						<option value="">(Escoja una Cuenta de Mayor)</option>
					<cfloop query="rsCM">
						<option value="#rsCM.Cmayor#">
							#rsCM.Cmayor# - #rsCM.Cdescripcion# 
							<cfif rsCM.PCEMid EQ "">
								(Sin Máscara)
							<cfelseif rsCM.conPlan EQ "1">
								(Con Plan)
							<cfelse>
								(Sin Plan)
							</cfif>
						</option>
					</cfloop>
					</select>
				</cfif>
				</td>
			</tr>
		</table>


		<cfif isdefined("url.Activar") and url.Activar EQ "1">
			<cfset application.CPactCMayor = false>
		</cfif>
		<cfparam name="application.CPactCMayor" default="false">
		<cfif application.CPactCMayor>
			<table align="center">	
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td style="color:##00FF00"><strong>Proceso en Ejecucion</strong></td>
				</tr>
			</table>
		<cfelseif isdefined("form.btnActivar")>
			<!--- cboTipo eq 2: Se presiono btnActivar y se visualiza la pantalla --->
			<cfoutput>
			<BR><BR><BR>
			<strong>Activando Control de Presupuesto para la Cuenta Mayor #form.Cmayor#...</strong>
			<BR><BR><BR>
			<strong>POR FAVOR ESPERE</strong>
			</cfoutput>
			<cfset LvarParams = "Cmayor=#URLEncodedFormat(form.Cmayor)#&PCEMcodigo=#URLEncodedFormat(form.PCEMcodigo)#&PCEMdesc=#URLEncodedFormat(form.PCEMdesc)#&CVMcalculoControl=#form.CVMcalculoControl#&CVMtipoControl=#form.CVMtipoControl#&CtaOfiFormular=#form.CtaOfiFormular#">
			<cfloop query="rsNiveles">
				<cfparam name="form.chkNivP_#rsNiveles.PCNid#" default="0">
				<cfset LvarParams = LvarParams & "&chkNivP_#rsNiveles.PCNid#=" & form["chkNivP_#rsNiveles.PCNid#"]>
			</cfloop>
			<iframe src="CtasMayor.cfm?activar&#LvarParams#" 
				style="display:none" height="000" width="000">
		<cfelseif isdefined("url.Activar")>
			<!--- cboTipo eq 2: La pantalla que visualiza ejecuta por iframe la carga --->
			<cfsetting requesttimeout="36000"> 
			<cfset LvarResultado = fnActivarCmayor()>
			<script language="javascript">
				alert ("#LvarResultado#");
				parent.location.href="/cfmx/home/menu/modulo.cfm?s=SIF&m=PRES";
			</script>
		<cfelseif form.Cmayor NEQ "">
			<table align="center">
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td colspan="2">
						<strong>Redefinición de Máscara Financiera</strong>
					</td>
				</tr>

				<tr>
					<td>
						&nbsp;&nbsp;&nbsp;&nbsp;
						Tipo Máscara:
					</td>
					<td>
						#LvarTipo#
					</td>
				</tr>

				<tr>
					<td>
						&nbsp;&nbsp;&nbsp;&nbsp;
						Máscara:
					</td>
					<td>
						#rsCM.PCEMcodigo#&nbsp;&nbsp;&nbsp;&nbsp;#rsCM.PCEMdesc#
					</td>
				</tr>

				<tr>
					<td>
						&nbsp;&nbsp;&nbsp;&nbsp;
						Formato Financiero:
					</td>
					<td>
						#rsCM.CPVformatoF#
					</td>
				</tr>

				<tr>
					<td>&nbsp;</td>
				</tr>

				<tr>
					<td colspan="2">
						&nbsp;&nbsp;&nbsp;&nbsp;
						<strong>Indique los Niveles Presupuestarios en la máscara:</strong>
					</td>
				</tr>

				<tr>
					<td colspan="2">
						<table width="800px">
							<tr>
								<td>
									&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								</td>
								<td>
									<strong>Nivel</strong>
								</td>
								<td>
									<strong>Descripcion</strong>
								</td>
								<td>
									<strong>Catálogo</strong>
								</td>
								<td>
									<strong>Depende</strong>
								</td>
								<td>
									<strong>Longitud</strong>
								</td>
								<td>
									<strong>Presupuesto</strong>
								</td>
							</tr>
						<cfloop query="rsNiveles">
							<tr>
								<td>&nbsp;
									
								</td>
										
								<td>
									#rsNiveles.PCNid#
								</td>
								<td>
									#rsNiveles.PCNdescripcion#
								</td>
								<td>
									#rsNiveles.PCEcodigo#
								</td>
								<td>
									#rsNiveles.PCNdep#
								</td>
								<td>
									#rsNiveles.PCNlongitud#
								</td>
								<td>
									<input type="checkbox" name="chkNivP_#rsNiveles.PCNid#" id="chkNivP_#rsNiveles.PCNid#" value="1"
									 onclick="sbArmaFormatoP();">
								</td>
							</tr>
						</cfloop>
						</table>
					</td>
				</tr>

				<tr>
					<td>
						&nbsp;&nbsp;&nbsp;&nbsp;
						<strong>Formato Presupuestario:</strong>
					</td>
					<td>
						<input type="input" name="formatoP" id="formatoP" value="" 
								size="60" readonly tabindex="-1" style="border:none;"
						/>
					</td>
				</tr>

				<tr>
					<td>
						&nbsp;&nbsp;&nbsp;&nbsp;
						<cfif LvarCrearNueva>
							<strong>Nueva Máscara:</strong>
						<cfelse>
							<strong>Máscara a Modificar:</strong>
						</cfif>
					</td>
					<td>
						<input type="input" name="PCEMcodigo" id="PCEMcodigo" size="10" maxlength="10"
							<cfif NOT LvarCrearNueva>
								value="#trim(rsCM.PCEMcodigo)#"  readonly
							<cfelseif rsCM.PCEMid EQ "">
								value="#rsCM.Cmayor#P"
							<cfelse>
								value="#trim(mid(rsCM.PCEMcodigo,1,9))#P"
							</cfif>
						>
						<input type="input" name="PCEMdesc" id="PCEMdesc" size="60" 
							<cfif NOT LvarCrearNueva>
								value="#trim(rsCM.PCEMdesc)# (con Presupuesto)"
							<cfelseif rsCM.PCEMid EQ "">
								value="Máscara para la Cuenta #rsCM.Cmayor# (con Presupuesto)"
							<cfelse>
								value="#trim(rsCM.PCEMdesc)# (con Presupuesto)"
							</cfif>
						>
					</td>
				</tr>

				<tr>
					<td>
						&nbsp;&nbsp;&nbsp;&nbsp;
						<strong>Tipo Control Default:</strong>
					</td>
					<td nowrap>
						<select name="CVMtipoControl" accesskey="1" tabindex="1" id="CVMtipoControl">
						  <option value="0">Abierto</option>
						  <option value="1">Restringido</option>
						  <option value="2">Restrictivo</option>
						</select>
					</td>
				</tr>
				<tr>
					<td>
						&nbsp;&nbsp;&nbsp;&nbsp;
						<strong>M&eacute;todo Calculo Default:</strong>
					</td>
					<td nowrap>
					  <select name="CVMcalculoControl" accesskey="2" tabindex="2" id="CVMcalculoControl">
						<option value="1">Mensual</option>
						<option value="2" selected>Acumulado</option>
						<option value="3">Total</option>
					</select>
					</td>
				</tr>
				<tr>
					<td>
						&nbsp;&nbsp;&nbsp;&nbsp;
						<strong>Cuentas y Oficinas a Formular:</strong>
					</td>
					<td nowrap>
					  <select name="CtaOfiFormular" accesskey="2" tabindex="2" id="CVMcalculoControl">
						<option value="">(Escoja un tipo de Formulación)</option>
						<option value="T">TODAS las cuentas en TODAS las oficinas</option>
						<option value="M">UNICAMENTE las cuentas en las oficinas que hayan tenido movimiento contable o presupuesto contable</option>
					</select>
					</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
				</tr>
			</table>
			<table align="center" align="100%">
				<tr>
					<td>
						<input type="button" name="btnAnterior" value="Anterior" onclick="this.form.Cmayor.value='';this.form.submit();">
						<input type="submit" name="btnActivar" value="Activar" onclick="if (this.form.CtaOfiFormular.value == '') {alert('Debe escoger el tipo de Formulación'); return false;} if (this.form.formatoP.value == ''){alert ('Debe indicar por lo menos un nivel de presupuesto'); return false;}; return confirm('¿Desea Activar el Control de Presupuesto para la Cuenta #rsCM.Cmayor# con el siguiente Formato de Presupuesto?\n\n'+this.form.formatoP.value);" disabled>
					</td>
				</tr>
			</table>
			<table align="center" align="100%">
				<tr>
					<td>
						<strong>PROCESO A EJECUTAR:</strong>
					</td>
				</tr>
				<tr>
					<td>
						&nbsp;&nbsp;&nbsp;&nbsp;
					<cfif LvarCrearNueva>
						. Se <strong>crea una nueva máscara</strong> con los niveles de presupuesto indicados
					<cfelse>
						. Se <strong>modifica máscara de la cuenta de mayor</strong> con los niveles de presupuesto indicados
					</cfif>
					</td>
				</tr>
				<tr>
					<td>
						&nbsp;&nbsp;&nbsp;&nbsp;
						. Se generan todas las cuentas de presupuesto en CPrespuesto a partir de las cuentas financieras existentes
					</td>
				</tr>
				<tr>
					<td>
						&nbsp;&nbsp;&nbsp;&nbsp;
						. Se generan los saldos en CPresupuestoControl y se actualiza con la información existente de Presupuesto Contable (SaldosContablesP) de la cuenta de mayor
					</td>
				</tr>
				<tr>
					<td>
						&nbsp;&nbsp;&nbsp;&nbsp;
						. Se crea un NAP de Ejecución Formulación por cada mes del periodo, con la información existente de pólizas contables (HEContables, HDContables)
					</td>
				</tr>
			</table>
			<script language="javascript">
				function sbArmaFormatoP()
				{
					var LvarFmt = "";
				<cfloop query="rsNiveles">
					if (document.getElementById("chkNivP_#rsNiveles.PCNid#").checked)	LvarFmt += "-#repeatString("X",rsNiveles.PCNlongitud)#";
				</cfloop>
					if (LvarFmt == "")
						document.getElementById("formatoP").value = "";
					else
						document.getElementById("formatoP").value = "#rsCM.Cmayor#" + LvarFmt;
					document.frmArranque.btnActivar.disabled = LvarFmt == '';						
				}
			</script>
		<cfelse>
			<table align="center" width="100%">
				<tr>
					<td align="center">
						<input type="button" name="btnSiguiente" value="Siguiente" onclick="this.form.submit();" disabled>
					</td>
				</tr>
			</table>
		</cfif>
	</form>
	</cfoutput>
<cf_templatefooter>
<cffunction name="fnMesDeAno" returntype="string" output="false">
	<cfargument name="YYYYMM" type="numeric" required="yes">
	
	<cfset LvarAno = int(YYYYMM/100)>
	<cfset LvarMes = YYYYMM - LvarAno*100>
	<cfif LvarMes EQ 1>
		<cfset LvarResultado = "Enero">
	<cfelseif LvarMes EQ 2>
		<cfset LvarResultado = "Febrero">
	<cfelseif LvarMes EQ 3>
		<cfset LvarResultado = "Marzo">
	<cfelseif LvarMes EQ 4>
		<cfset LvarResultado = "Abril">
	<cfelseif LvarMes EQ 5>
		<cfset LvarResultado = "Mayo">
	<cfelseif LvarMes EQ 6>
		<cfset LvarResultado = "Junio">
	<cfelseif LvarMes EQ 7>
		<cfset LvarResultado = "Julio">
	<cfelseif LvarMes EQ 8>
		<cfset LvarResultado = "Agosto">
	<cfelseif LvarMes EQ 9>
		<cfset LvarResultado = "Setiembre">
	<cfelseif LvarMes EQ 10>
		<cfset LvarResultado = "Octubre">
	<cfelseif LvarMes EQ 11>
		<cfset LvarResultado = "Noviembre">
	<cfelseif LvarMes EQ 12>
		<cfset LvarResultado = "Diciembre">
	</cfif>	
	<cfreturn "#LvarResultado# #LvarAno#">
</cffunction>

<cffunction name="fnActivarCmayor" returntype="string" output="false">
	<cf_dbtemp name="CPC_O_V1" returnvariable="CPcuenta_Ocodigo" datasource="#session.DSN#">
		<cf_dbtempcol name="CPcuenta" 		type="numeric"      mandatory="yes">
		<cf_dbtempcol name="Ocodigo" 		type="int"      	mandatory="yes">
	</cf_dbtemp>
	<cfset LobjControl = createObject( "component","sif.Componentes.PRES_Presupuesto")>
	<cfset LobjControl.CreaTablaIntPresupuesto(#session.dsn#,false,true)>

	<cfquery name="rsSQL" datasource="#session.dsn#">
		select 	count(1) as cantidad
		  from	CFinanciera c
		  where c.Ecodigo	= #session.Ecodigo#
			and c.Cmayor	= '#rsCM.Cmayor#'
			and c.CPVid		= #rsCM.CPVid#
			and c.CPcuenta is not null
	</cfquery>
	<cfif rsSQL.cantidad NEQ 0>
		<cf_errorCode	code = "50460"
						msg  = "La cuenta '@errorDat_1@' ya tiene cuentas de presupuesto"
						errorDat_1="#rsCM.Cmayor#"
		>
	</cfif>

	<cftransaction>
		<cfset LvarResultadoMascara = fnCrearMascara()>
		<cfset LvarResultado = LvarResultadoMascara.msg>
		<cfset LvarResultado = LvarResultado & fnCrearCtasPresupuesto()>
		<cfset LvarResultado = LvarResultado & fnGenerarSaldosPresupuesto()>
		<cfset LvarResultado = LvarResultado & fnEjecucion()>
	</cftransaction>

	<cfreturn LvarResultado>
</cffunction>

<cffunction name="fnCrearMascara" output="false" returntype="struct">
	<!---
		Se cambia/crea la nueva mascara para utilizarla con la cuenta de mayor
	--->
	<cfset var LvarResultado = structNew()>
	<cfif LvarCrearNueva>
		
	<cfquery name="selectInsert" datasource="#session.DSN#">
		select
					 CEcodigo
					,PCEMplanCtas
					,<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.PCEMcodigo#" null="#url.PCEMcodigo EQ ''#">  as PCEMcodigo
					,<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.PCEMdesc#" null="#url.PCEMdesc EQ ''#"> as PCEMdesc
					,''	as PCEMformato
					,'' as PCEMformatoC
					,'' as PCEMformatoP
					,'' as PCEMnivelesP
					,'00' as Ulocalizacion
				  from PCEMascaras
				 where PCEMid = #rsCM.PCEMid#
	</cfquery>			 
		
		<cfquery name="insert" datasource="#session.DSN#">
			insert into PCEMascaras 
				(
					 CEcodigo
					,PCEMplanCtas
					,PCEMcodigo
					,PCEMdesc
					,PCEMformato	
					,PCEMformatoC
					,PCEMformatoP
					,PCEMnivelesP	
					,Ulocalizacion 
					,Usucodigo		
					,BMUsucodigo
				)
			<cfif rsCM.PCEMid EQ "">
				values (
					 #session.CEcodigo#
					,0
					,<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.PCEMcodigo#" null="#url.PCEMcodigo EQ ''#">
					,<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.PCEMdesc#" null="#url.PCEMdesc EQ ''#">
					,''	
					,''
					,''
					,''
					,'00'
					,#session.Usucodigo#
					,#session.Usucodigo#
				)
			<cfelse>
				VALUES(
					   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectInsert.CEcodigo#"      voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_bit"               value="#selectInsert.PCEMplanCtas#"  voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="10"  value="#selectInsert.PCEMcodigo#"    voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="80"  value="#selectInsert.PCEMdesc#"      voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="100" value="#selectInsert.PCEMformato#"   voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="100" value="#selectInsert.PCEMformatoC#"  voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="100" value="#selectInsert.PCEMformatoP#"  voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="255" value="#selectInsert.PCEMnivelesP#"  voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="2"   value="#selectInsert.Ulocalizacion#" voidNull>,
					   #session.Usucodigo#,
					   #session.Usucodigo#
				)
			</cfif>
			<cf_dbidentity1 name="insert" datasource="#session.DSN#" verificar_transaccion="false" returnVariable="LvarPCEMid">
		</cfquery>
		<cf_dbidentity2 name="insert" datasource="#session.DSN#" verificar_transaccion="false" returnVariable="LvarPCEMid">
		<cfquery name="insert" datasource="#session.DSN#">
			update CPVigencia
			   set PCEMid = #LvarPCEMid#
			 where CPVid = #rsCM.CPVid#
		</cfquery>
		<cfset LvarResultado.msg = "Se creó la Máscara '#url.PCEMcodigo#    #url.PCEMdesc#'">
		<cfloop query="rsNiveles">
			<cfquery datasource="#session.DSN#">
				insert into PCNivelMascara
					(
						 PCEMid         
						,PCNid           
						,PCNdescripcion  
						,PCEcatid        
						,PCNdep          
						,PCNlongitud    
						,PCNcontabilidad 
						,PCNpresupuesto 
						,Ulocalizacion   
						,Usucodigo       
						,BMUsucodigo
					)
				values
					(
						 #LvarPCEMid#
						,#rsNiveles.PCNid#
						,<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsNiveles.PCNdescripcion#" null="#rsNiveles.PCNdescripcion EQ ''#">
						,<cfqueryparam cfsqltype="cf_sql_integer" value="#rsNiveles.PCEcatid#" null="#rsNiveles.PCEcatid EQ ''#">
						,<cfqueryparam cfsqltype="cf_sql_integer" value="#rsNiveles.PCNdep#" null="#rsNiveles.PCNdep EQ ''#">
						,#rsNiveles.PCNlongitud#
						,1
						,#url["chkNivP_#rsNiveles.PCNid#"]#
						,'00'
						,#session.Usucodigo#
						,#session.Usucodigo#
					)
			</cfquery>
		</cfloop>
	<cfelse>
		<cfquery datasource="#session.DSN#">
			update PCEMascaras 
			   set PCEMcodigo	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.PCEMcodigo#" null="#url.PCEMcodigo EQ ''#">
				 , PCEMdesc		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.PCEMdesc#" null="#url.PCEMdesc EQ ''#">
			 where PCEMid = #rsCM.PCEMid#
		</cfquery>
		<cfloop query="rsNiveles">
			<cfquery datasource="#session.DSN#">
				update PCNivelMascara
				   set PCNpresupuesto	= #url["chkNivP_#rsNiveles.PCNid#"]#
				 where PCEMid = #rsCM.PCEMid#
				   and PCNid  = #rsNiveles.PCNid#
			</cfquery>
		</cfloop>
		<cfset LvarPCEMid = rsCM.PCEMid>
		<cfset LvarResultado.msg = "Se modificó la Máscara '#url.PCEMcodigo#    #url.PCEMdesc#'">
	</cfif>

	<!--- Construye los niveles --->
	<cfset LvarMascaraF = "">
	<cfset LvarMascaraC = "">
	<cfset LvarMascaraP = "">
	<cfset LvarNivelesP = "">
	<cfset LvarSubstring = "">
	<cfset LvarPos = "5">
	<cfloop query="rsNiveles">
		<cfset LvarMascaraF = LvarMascaraF & iif(LvarMascaraF EQ "",de(""),de("-")) & RepeatString("X",rsNiveles.PCNlongitud)>
		<cfset LvarMascaraC = LvarMascaraC & iif(LvarMascaraC EQ "",de(""),de("-")) & RepeatString("X",rsNiveles.PCNlongitud)>
		<cfif url["chkNivP_#rsNiveles.PCNid#"] EQ 1>
			<cfset LvarMascaraP = LvarMascaraP & iif(LvarMascaraP EQ "",de(""),de("-")) & RepeatString("X",rsNiveles.PCNlongitud)>
			<cfset LvarNivelesP = LvarNivelesP & iif(LvarNivelesP EQ "",de("1-4,"),de(",")) & LvarPos & "-" & (rsNiveles.PCNlongitud+1)>
			<cfset LvarSubstring = LvarSubstring & iif(LvarSubstring EQ "",de("substring(CFformato,1,4) + substring(CFformato,"),de(" + substring(CFformato,")) & LvarPos & "," & (rsNiveles.PCNlongitud+1) & ")">
		</cfif>
		<cfset LvarPos = LvarPos + rsNiveles.PCNlongitud + 1>
	</cfloop>

	<cfset LvarMascaraF = "XXXX-" & LvarMascaraF>
	<cfset LvarMascaraC = "XXXX-" & LvarMascaraC>
	<cfset LvarMascaraP = "XXXX-" & LvarMascaraP>
	<cfif LvarMascaraF EQ LvarMascaraP>
		<cfset LvarNivelesP = "1-#len(LvarMascaraF)#">
		<cfset LvarSubstring = "CFformato">
	</cfif>
	<cfset LvarResultado.SQL_CPformato = LvarSubstring>
	<cfset LvarResultado.MascaraF = LvarMascaraF>
	<cfset LvarResultado.MascaraP = LvarMascaraP>

	<cfquery datasource="#Session.DSN#">
		update PCEMascaras set
			   PCEMformato  = '#LvarMascaraF#'
			 , PCEMformatoC = '#LvarMascaraC#'
			 , PCEMformatoP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarMascaraP#" null="#LvarMascaraP EQ ''#">
			 , PCEMnivelesP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarNivelesP#" null="#LvarNivelesP EQ ''#">
		 where PCEMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPCEMid#">
		   and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
	</cfquery>
	<cfreturn LvarResultado>
</cffunction>


<cffunction name="fnCrearCtasPresupuesto" output="false" returntype="string">
	<!--- Genera las Cuentas de Presupuesto --->
	<cfset var LvarResultado  = "">
	<cfquery name="rsCFinanciera" datasource="#session.dsn#">
		select 	distinct c.CFcuenta, c.CFformato, #LvarResultadoMascara.SQL_CPformato# as CPformato
		  from	CFinanciera c
		  where c.Ecodigo	= #session.Ecodigo#
			and c.Cmayor	= '#rsCM.Cmayor#'
			and c.CPVid		= #rsCM.CPVid#
			and c.CFmovimiento = 'S'
	</cfquery>
	<cfset LvarMascaraN = len(trim(LvarResultadoMascara.MascaraF))>
	<cfloop query="rsCFinanciera">
		<cfif len(trim(rsCFinanciera.CFformato)) NEQ LvarMascaraN>
			<cf_errorCode	code = "50461"
							msg  = "La cuenta financiera @errorDat_1@ no coincide con su mascara @errorDat_2@"
							errorDat_1="#rsCFinanciera.CFformato#"
							errorDat_2="#LvarResultadoMascara.MascaraF#"
			>
		</cfif>
		<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera"
				  method="fnGeneraCPformato"
				  returnvariable="LvarError"
		>
					<cfinvokeargument name="Lprm_Ecodigo" 			value="#session.Ecodigo#"/>
					<cfinvokeargument name="Lprm_CPformato" 		value="#rsCFinanciera.CPformato#"/>
					<cfinvokeargument name="Lprm_Ocodigo" 			value="-1"/>
					<cfinvokeargument name="Lprm_fecha" 			value="#rsCPP.CPPfechaDesde#"/>
					<cfinvokeargument name="Lprm_CPPid" 			value="#rsCPP.CPPid#"/>
					<cfinvokeargument name="Lprm_CVPtipoControl"	value="#url.CVMtipoControl#"/>
					<cfinvokeargument name="Lprm_CVPcalculoControl"	value="#url.CVMcalculoControl#"/>

					<cfinvokeargument name="Lprm_TransaccionActiva" value="yes"/>
					<cfinvokeargument name="Lprm_DSN" 				value="#session.DSN#"/>
		</cfinvoke>
		<cfif LvarError NEQ "OLD" AND LvarError NEQ "NEW">
			<cf_errorCode	code = "50462"
							msg  = "ERROR EN PRES_cargarSaldosContablesP: @errorDat_1@"
							errorDat_1="#LvarERROR#"
			>
		</cfif>
	</cfloop>

	<cfquery datasource="#session.dsn#">
		update	CFinanciera
		   set  CPcuenta =
		   		(
					select CPcuenta
					  from CPresupuesto
					 where Ecodigo = CFinanciera.Ecodigo
					   and CPformato = #replace(LvarResultadoMascara.SQL_CPformato,"CFformato","CFinanciera.CFformato","ALL")#
				)
		  where Ecodigo		 = #session.Ecodigo#
			and Cmayor		 = '#rsCM.Cmayor#'
			and CPVid		 = #rsCM.CPVid#
			and CFmovimiento = 'S'
	</cfquery>

	<cfset LvarResultado = LvarResultado & "\nSe activaron #rsCFinanciera.recordCount# Cuentas Financieras">
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select count(1) as Cantidad 
		  from CPresupuesto 
		 where Ecodigo 	= #session.Ecodigo#
		   and Cmayor 	= '#rsCM.Cmayor#' 
		   and CPVid	= #rsCM.CPVid#
		   and CPmovimiento = 'S'
		   and CPformato	<> Cmayor
	</cfquery>
	<cfset LvarResultado = LvarResultado & "\nSe crearon #rsSQL.cantidad# Cuentas de Control de Presupuesto">

	<cfquery name="rsSQL" datasource="#session.dsn#">
		select count(1) - #rsSQL.cantidad# as Cantidad 
		  from CPresupuesto 
		 where Ecodigo 	= #session.Ecodigo#
		   and Cmayor 	= '#rsCM.Cmayor#' 
		   and CPVid	= #rsCM.CPVid#
	</cfquery>
	<cfset LvarResultado = LvarResultado & " (más #rsSQL.cantidad# Cuentas padres)">

	<cfreturn LvarResultado>
</cffunction>
	
<cffunction name="fnGenerarSaldosPresupuesto" output="false" returntype="string">
	<!---
		7. Crea una Version de Presupuesto para el Período de Presupuesto
	--->
	<cfset LvarCVdescripcion = "ACTIVA PRESUPUESTO A CUENTAS #rsCM.Cmayor#">
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select max(CVtipo) as CVtipo
		  from CVersion
		 where CPPid		= #rsCPP.CPPid#
		   and CVaprobada	= 1
	</cfquery>
	<cfset LvarUltimoCVtipo = rsSQL.CVtipo>
	<cfset LvarPresupuestoOriginal = (LvarUltimoCVtipo EQ 1)>

	<cfif rsSQL.CVtipo EQ "">
		<cfset LvarUltimoCVtipo = 1>
	<cfelse>
		<cfset LvarUltimoCVtipo = rsSQL.CVtipo>
	</cfif>

	<cfquery name="rsSQL" datasource="#session.dsn#">
		select max(CVdocumentoAprobo) as ultimo
		  from CVersion v
		 where Ecodigo = #session.Ecodigo#
		   and CVtipo  = '#LvarUltimoCVtipo#'
	</cfquery>
	
	<cfif rsSQL.ultimo EQ "">
		<cfset LvarDocumentoAprobo = 1>
	<cfelse>
		<cfset LvarDocumentoAprobo = rsSQL.ultimo + 1>
	</cfif>

	<cfquery name="rsSQL" datasource="#session.dsn#">
		insert into CVersion
			(
				 Ecodigo            ,
				 CVtipo             ,
				 CVdescripcion      ,
				 CPPid              ,
				 CVestado			,
				 CVaprobada, 
				 CVdocumentoAprobo, UsucodigoAprobo, CVfechaAprobo
			)
		values (
				#session.Ecodigo#,
				'#LvarUltimoCVtipo#', 	<!--- Tipo = Igual que la última aprobada --->
				'#LvarCVdescripcion#',
				#rsCPP.CPPid#,
				0,						<!--- Estado 0 = Etapa Base --->
				1,						<!--- Aprobada --->
				#LvarDocumentoAprobo#, #session.Usucodigo#, <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
			)
		<cf_dbidentity1 name="rsSQL" datasource="#session.dsn#" verificar_transaccion="false">
	</cfquery>
	<cf_dbidentity2 name="rsSQL" datasource="#session.dsn#" verificar_transaccion="false" returnvariable="LvarCVid">

	<!---
		8. Agrega las Cuentas de Presupuesto a la Versión: 
			CVMayor, 
			CVPresupuesto, 
			CVFormulacionTotales: Ocodigo, y cada mes del Período, monto=0
			CVFormulacionMonedas: Ocodigo, y cada mes del Período, monto=0, McodigoLocal, TipoCambio=1, Monto=0
	--->
	<cfquery name="rsSQL" datasource="#session.dsn#">
		insert into CVMayor
			(
				Ecodigo,
				CVid,
				Cmayor,
				Ctipo,
				CPVidOri,
				PCEMidOri,
				Cmascara,
				CVMtipoControl,
				CVMcalculoControl
			)
		select	Ecodigo,
				#LvarCVid#,
				Cmayor,
				Ctipo,
				#rsCM.CPVid#,
				#LvarPCEMid#,
				'#LvarResultadoMascara.MascaraP#',
				#url.CVMtipoControl#, 
				#url.CVMcalculoControl#
		  from CtasMayor m
		 where Ecodigo	= #session.Ecodigo#
		   and Cmayor 	= '#rsCM.Cmayor#'
	</cfquery>

	<!--- CVPcuenta = Ccuenta, para optimizar el join con SaldosContablesP --->
	<cfif url.CtaOfiFormular EQ "M">
		<cfquery datasource="#session.dsn#">
			insert into #CPcuenta_Ocodigo# (CPcuenta, Ocodigo)
			select 	DISTINCT c.CPcuenta, d.Ocodigo
			  from	CFinanciera c
				inner join HDContables d
					inner join CPmeses m
						 on m.CPPid  = #rsCPP.CPPid#
						and m.CPCano = d.Eperiodo
						and m.CPCmes = d.Emes
						and m.CPCano*100+CPCmes >= #LvarContaAnoMesIni#
					on d.Ccuenta = c.Ccuenta
			  where c.Ecodigo	= #session.Ecodigo#
				and c.Cmayor	= '#rsCM.Cmayor#'
				and c.CPVid		= #rsCM.CPVid#
				and c.CFmovimiento	= 'S'
				and c.CFformato		<> c.Cmayor
			UNION
			select 	DISTINCT c.CPcuenta, s.Ocodigo
			  from	CFinanciera c
				inner join SaldosContablesP s
					inner join CPmeses m
						 on m.CPPid  = #rsCPP.CPPid#
						and m.CPCano = s.Speriodo
						and m.CPCmes = s.Smes
						and m.CPCano*100+CPCmes >= #LvarContaAnoMesIni#
					on s.Ccuenta = c.Ccuenta
			  where c.Ecodigo	= #session.Ecodigo#
				and c.Cmayor	= '#rsCM.Cmayor#'
				and c.CPVid		= #rsCM.CPVid#
				and c.CFmovimiento	= 'S'
				and c.CFformato		<> c.Cmayor
		</cfquery>
	<cfelse>
		<cfquery datasource="#session.dsn#">
			insert into #CPcuenta_Ocodigo# (CPcuenta, Ocodigo)
			select 	c.CPcuenta, o.Ocodigo
			  from	CFinanciera c
				inner join Oficinas o
					on o.Ecodigo = c.Ecodigo
			  where c.Ecodigo	= #session.Ecodigo#
				and c.Cmayor	= '#rsCM.Cmayor#'
				and c.CPVid		= #rsCM.CPVid#
				and c.CFmovimiento	= 'S'
				and c.CFformato		<> c.Cmayor
		</cfquery>
	</cfif>

	<cfquery name="rsSQL" datasource="#session.dsn#">
		insert into CVPresupuesto
			(
				Ecodigo,
				CVid,
				Cmayor,
				CVPcuenta,
				CPcuenta,
				CPformato,
				CPdescripcion,
				CVPtipoControl,
				CVPcalculoControl
			)
		select	DISTINCT 
				cp.Ecodigo,
				#LvarCVid#,
				cp.Cmayor,
				cp.CPcuenta,
				cp.CPcuenta,
				cp.CPformato,
				cp.CPdescripcion,
				#url.CVMtipoControl#, 
				#url.CVMcalculoControl#
		  from CPresupuesto cp
		  	inner join #CPcuenta_Ocodigo# co
				on co.CPcuenta = cp.CPcuenta
		 where cp.Ecodigo 		= #session.Ecodigo#
		   and cp.CPmovimiento 	= 'S'
		   and cp.CPformato 	<> cp.Cmayor
		   and cp.Cmayor		= '#rsCM.Cmayor#'
		   and cp.CPVid			= #rsCM.CPVid#
	</cfquery>
				
	<cfquery name="rsSQL" datasource="#session.dsn#">
		insert into CVFormulacionTotales
			(
				Ecodigo,
				CVid,
				CPCano,
				CPCmes,
				CVPcuenta,
				Ocodigo
			)
		select	DISTINCT 
				cvp.Ecodigo,
				cvp.CVid,
				m.CPCano,
				m.CPCmes,
				cvp.CVPcuenta,
				co.Ocodigo
		  from CVPresupuesto cvp
		  	inner join #CPcuenta_Ocodigo# co
				on co.CPcuenta = cvp.CVPcuenta
		  	inner join CPmeses m
				on m.CPPid		= #rsCPP.CPPid#
		 where cvp.Ecodigo	= #session.Ecodigo#
		   and cvp.CVid		= #LvarCVid#
	</cfquery>

	<cfquery name="rsSQL" datasource="#session.dsn#">
		insert into CVFormulacionMonedas
			(
				Ecodigo,
				CVid,
				CPCano,
				CPCmes,
				CVPcuenta,
				Ocodigo,
				Mcodigo,
				CVFMtipoCambio,
				CVFMmontoBase
			)
		select	cvft.Ecodigo,
				cvft.CVid,
				cvft.CPCano,
				cvft.CPCmes,
				cvft.CVPcuenta,
				cvft.Ocodigo,
				e.Mcodigo,
				1,
				0
		  from CVFormulacionTotales cvft
		  	inner join Empresas e
				on e.Ecodigo = cvft.Ecodigo
		 where cvft.Ecodigo	= #session.Ecodigo#
		   and cvft.CVid	= #LvarCVid#
	</cfquery>
				
	<!---
		10. Actualiza CVFormulacionMonedas con SaldosContablesP
	--->
	<cfquery name="rsSQL" datasource="#session.dsn#">
		update CVFormulacionMonedas
		   set CVFMmontoBase =
				coalesce(
					(
						select sum(case when m.Ctipo IN ('A','G') then MLmonto else -MLmonto end)
						  from SaldosContablesP scp
							inner join CFinanciera c
								inner join CtasMayor m
								   on m.Ecodigo = c.Ecodigo
								  and m.Cmayor = c.Cmayor
							    on c.Ccuenta 	= scp.Ccuenta
							   and c.CPcuenta	= CVFormulacionMonedas.CVPcuenta
						 where scp.Speriodo	= CVFormulacionMonedas.CPCano
						   and scp.Smes		= CVFormulacionMonedas.CPCmes
						   and scp.Ecodigo	= CVFormulacionMonedas.Ecodigo
						   and scp.Ocodigo	= CVFormulacionMonedas.Ocodigo
					)
				,0)
		  where Ecodigo	= #session.Ecodigo#
			and CVid	= #LvarCVid#
	</cfquery>

	<!---
		10. Ajusta la Formulacion
	--->
	<cfquery datasource="#session.dsn#">
		update CVFormulacionMonedas
		   set CVFMmontoAplicar = CVFMmontoBase
		 where Ecodigo 	= #session.Ecodigo#
		   and CVid 	= #LvarCVid#
	</cfquery>

	<cfquery datasource="#session.dsn#">
		update CVFormulacionTotales
		   set CVFTmontoSolicitado = 
						(
							select b.CVFMmontoBase 
							  from CVFormulacionMonedas b
							 where b.Ecodigo 	= CVFormulacionTotales.Ecodigo
							   and b.CVid 		= CVFormulacionTotales.CVid
							   and b.CVPcuenta 	= CVFormulacionTotales.CVPcuenta
							   and b.CPCano 	= CVFormulacionTotales.CPCano
							   and b.CPCmes 	= CVFormulacionTotales.CPCmes
							   and b.Ocodigo 	= CVFormulacionTotales.Ocodigo
						)
		 where Ecodigo 	= #session.Ecodigo#
		   and CVid 	= #LvarCVid#
	</cfquery>

	<cfquery datasource="#session.dsn#">
		update CVFormulacionTotales
		   set CVFTmontoAplicar = CVFTmontoSolicitado
		 where Ecodigo 	= #session.Ecodigo#
		   and CVid 	= #LvarCVid#
	</cfquery>

	<cfquery name="rsSQL" datasource="#session.dsn#">
		insert into CPresupuestoControl
			(Ecodigo, CPPid, CPCano, CPCmes, CPcuenta, Ocodigo, CPCanoMes,
			<cfif LvarPresupuestoOriginal>
			  CPCpresupuestado
			<cfelse>
			  CPCmodificado
			</cfif>
			 )
		select #session.Ecodigo#, #rsCPP.CPPid#, fm.CPCano, fm.CPCmes, fm.CVPcuenta, fm.Ocodigo, fm.CPCano*100+fm.CPCmes, 
				fm.CVFMmontoAplicar
		  from CVFormulacionMonedas fm
		 where fm.Ecodigo 	 = #session.Ecodigo#
		   and fm.CVid 	     = #LvarCVid#
	</cfquery>

	<cfquery name="rsSQL" datasource="#session.dsn#">
		insert into CPControlMoneda
			(Ecodigo, CPPid, CPCano, CPCmes, CPcuenta, Ocodigo, 
			 Mcodigo, CPCMtipoCambioAplicado, CPCMpresupuestado)
		select 	#session.Ecodigo#, #rsCPP.CPPid#, fm.CPCano, fm.CPCmes, fm.CVPcuenta, fm.Ocodigo,
				fm.Mcodigo, fm.CVFMtipoCambio, fm.CVFMmontoAplicar
		  from CVFormulacionMonedas fm
		 where fm.Ecodigo 	 = #session.Ecodigo#
		   and fm.CVid 	     = #LvarCVid#
	</cfquery>

	<cfquery name="rsSQL" datasource="#session.dsn#">
		select max(CPNAPnum) as NAP
		  from CPNAP
		 where Ecodigo = #session.Ecodigo#
	</cfquery>
	<cfif rsSQL.NAP EQ "">
		<cfset LvarNAP = 1>
	<cfelse>
		<cfset LvarNAP = rsSQL.NAP + 1>
	</cfif>

	<cfquery name="rsSQL" datasource="#session.dsn#">
		insert into CPNAP
				(Ecodigo, CPNAPnum, 
				 CPPid, CPCano, CPCmes, CPNAPfecha, 
				 CPNAPmoduloOri, CPNAPdocumentoOri, CPNAPreferenciaOri, CPNAPfechaOri,
				 UsucodigoOri, UsucodigoAutoriza, 
				 CPOid, CPNAPnumReversado
				 )
		values 	(#session.Ecodigo#, #LvarNAP#, 
				 #rsCPP.CPPid#, #dateformat(now(),"YYYY")#, #dateformat(now(),"MM")#,
				 <cfqueryparam cfsqltype="cf_sql_timestamp"	value="#now()#">,
				 <cfqueryparam cfsqltype="cf_sql_varchar" 	value="PRFO">,
				 <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#LvarDocumentoAprobo#">,
				 <cfqueryparam cfsqltype="cf_sql_varchar" 	value="APROBACION">,
				 <cfqueryparam cfsqltype="cf_sql_date" 		value="#now()#">,
				 #session.Usucodigo#, #session.Usucodigo#, 
				 null, null
			)
	</cfquery>

	<cfquery name="rsSQL" datasource="#session.dsn#">
		insert into CPNAPdetalle
				(Ecodigo, CPNAPnum, CPNAPDlinea, 
				 CPPid, CPCano, CPCmes, CPcuenta, Ocodigo, 
				 CFcuenta, 
				 CPCPtipoControl, CPCPcalculoControl, 
				 CPNAPDtipoMov, CPNAPDsigno, 
				 Mcodigo, CPNAPDtipoCambio, CPNAPDmontoOri, CPNAPDmonto, 
				 CPNAPDdisponibleAntes, CPNAPDconExceso, CPNAPDreferenciado, CPNAPDutilizado, 
				 BMUsucodigo
				 )
		select 	#session.Ecodigo#, #LvarNAP#, 
				(
					select count(1) from CVFormulacionMonedas 
					 where Ecodigo	= #session.Ecodigo#
					   and CVid		= #LvarCVid#
					   and 	CVPcuenta*10000000000+(CPCano*100+CPCmes)*10000+Ocodigo <=
							fm.CVPcuenta*10000000000+(fm.CPCano*100+fm.CPCmes)*10000+fm.Ocodigo
				),
				#rsCPP.CPPid#, fm.CPCano, fm.CPCmes, fm.CVPcuenta, fm.Ocodigo, 
				(select min(CFcuenta) from CFinanciera where CPcuenta = fm.CVPcuenta),
				#url.CVMtipoControl#, #url.CVMcalculoControl#,
				<cfif LvarPresupuestoOriginal>
				  'A', +1, 
				<cfelse>
				  'M', +1, 
				</cfif>
				fm.Mcodigo, 1.00, fm.CVFMmontoAplicar, fm.CVFMmontoAplicar,
				0, 0, 0, 0,
				#session.usucodigo#
		  from CVFormulacionMonedas fm
		 where fm.Ecodigo 	 = #session.Ecodigo#
		   and fm.CVid 	     = #LvarCVid#
	</cfquery>

	<cfquery name="rsSQL" datasource="#session.dsn#">
		select 	count(1) as Cantidad,
				count(distinct s.CPcuenta) as CantidadC,
				count(distinct s.Ocodigo) as CantidadO,
				count(distinct s.CPCmes) as CantidadM
		  from CPresupuesto p
		  	inner join CPresupuestoControl s
				 on s.Ecodigo	= #session.Ecodigo#
				and s.CPPid		= #rsCPP.CPPid#
				and s.CPcuenta	= p.CPcuenta
		 where p.Cmayor = '#rsCM.Cmayor#' 
		   and p.CPVid	= #rsCM.CPVid#
	</cfquery>

	<cfreturn "\nSe Formularon #rsSQL.Cantidad# Saldos de Control de Presupuesto en:\n\t#rsSQL.CantidadC# cuentas, #rsSQL.CantidadO# oficinas, #rsSQL.CantidadM# meses">
</cffunction>

<cffunction name="fnEjecucion" output="false" returntype="string">
	<cfset LvarModuloOri	 = "CGDC">
	<cfset LvarReferenciaOri = "ACTIVA PRESUP. #rsCM.Cmayor#">

	<!--- Bloquea Parametros para que no se apliquen asientos contables --->
	<cfquery datasource="#session.dsn#">
		update Parametros
		   set Pvalor = Pvalor
		 where Ecodigo = #session.Ecodigo#
		   and Pcodigo = 40
	</cfquery>

	<!--- Abre el control de Contabilidad para que no se generen NRPs --->
	<cfquery name="rsOrigenAbierto" datasource="#session.dsn#">
		select CPOid, CPOborrado, CPOdesde, CPOhasta
		  from CPOrigenesControlAbierto
		 where Ecodigo = #session.Ecodigo#
		   and Oorigen = '#LvarModuloOri#'
	</cfquery>
	
	<cfif rsOrigenAbierto.CPOid EQ "">
		<cfquery datasource="#session.dsn#">
			insert into CPOrigenesControlAbierto
				(Ecodigo, Oorigen, CPOdesde, CPOhasta, Usucodigo)
			values(
					#session.Ecodigo#,
					'#LvarModuloOri#',
					<cfqueryparam cfsqltype="cf_sql_date" 		value="#CreateDate(2000,1,1)#">,
					<cfqueryparam cfsqltype="cf_sql_date" 		value="#CreateDate(2010,1,1)#">,
					#session.Usucodigo#
				)
		</cfquery>
	<cfelse>
		<cfquery datasource="#session.dsn#">
			update CPOrigenesControlAbierto
			   set CPOborrado	= 0,
			       CPOdesde		= <cfqueryparam cfsqltype="cf_sql_date" 		value="#CreateDate(2000,1,1)#">,
				   CPOhasta		= <cfqueryparam cfsqltype="cf_sql_date" 		value="#CreateDate(2010,1,1)#">
			 where Ecodigo = #session.Ecodigo#
			   and Oorigen = '#LvarModuloOri#'
		</cfquery>
	</cfif>

	<cfset LvarCantidad = 0>
	<cfset LvarMes = LvarContaAnoMesIni>
	<cfloop condition="LvarMes LTE LvarMesAct">
		<cfset LvarDocumentoOri	 = "MES #LvarMes#">
		
		<cfquery datasource="#session.DSN#">
			delete from #request.intPresupuesto#
		</cfquery>

		<cfif LvarMes EQ LvarMesAct and LvarMesAct EQ dateFormat(now(),"YYYYMM")>
			<cfset LvarFecha = createODBCdate(now())>
		<cfelse>
			<cfset LvarFecha = createDate(int(LvarMes/100),LvarMes mod 100, 1)>
			<cfset LvarFecha = createDate(int(LvarMes/100),LvarMes mod 100, DaysInMonth(LvarFecha))>
		</cfif>
		
		<cfquery datasource="#session.DSN#">
			insert into #request.intPresupuesto#
				(
					ModuloOrigen,
					NumeroDocumento,
					NumeroReferencia,
					FechaDocumento,
					AnoDocumento,
					MesDocumento,
					
					Ccuenta, CFcuenta, CPcuenta,
					Ocodigo,
					TipoMovimiento,
					Mcodigo, 	MontoOrigen, 
					TipoCambio, Monto,
					
					CPPid, CPCano, CPCmes
				)
			select 	'#LvarModuloOri#', '#LvarDocumentoOri#', '#LvarReferenciaOri#',
					<cfqueryparam cfsqltype="cf_sql_date" value="#LvarFecha#">,
					#DateFormat(LvarFecha,"YYYY")#, #DateFormat(LvarFecha,"MM")#,
					f.Ccuenta, f.CFcuenta, f.CPcuenta,
					s.Ocodigo,
					'E',
					e.Mcodigo,		
						CASE 
							when m.Ctipo IN ('A','G') 
								then sum(case when s.Dmovimiento = 'D' then s.Dlocal else -s.Dlocal end)
								else sum(case when s.Dmovimiento = 'C' then s.Dlocal else -s.Dlocal end)
						END as Doriginal, 
					1.00 as Dtipocambio, 	
						CASE 
							when m.Ctipo IN ('A','G') 
								then sum(case when s.Dmovimiento = 'D' then s.Dlocal else -s.Dlocal end)
								else sum(case when s.Dmovimiento = 'C' then s.Dlocal else -s.Dlocal end)
						END as Dlocal, 
					#rsCPP.CPPid#, #DateFormat(LvarFecha,"YYYY")#, #DateFormat(LvarFecha,"MM")#
				  from 	HDContables s
					inner join Empresas e
						 on e.Ecodigo = s.Ecodigo
					inner join CFinanciera f
						inner join CtasMayor m
							 on m.Ecodigo	= f.Ecodigo
							and m.Cmayor	= f.Cmayor
						 on f.Ccuenta	= s.Ccuenta
						and f.Cmayor	= '#rsCM.Cmayor#'
				 where s.Ecodigo	= #session.Ecodigo#
				   and s.Eperiodo	= #DateFormat(LvarFecha,"YYYY")#
				   and s.Emes		= #DateFormat(LvarFecha,"MM")#
				group by f.Ccuenta, f.CFcuenta, f.CPcuenta, s.Ocodigo, e.Mcodigo, m.Ctipo
				having sum(case when s.Dmovimiento = 'D' then s.Dlocal else -s.Dlocal end) <> 0
		</cfquery>

		<cfquery name="rsSQL" datasource="#session.DSN#">
			select count(1) as cantidad
			  from #request.intPresupuesto#
		</cfquery>
		
		<cfif rsSQL.cantidad GT 0>
			<cfset LvarCantidad = LvarCantidad +1>
			<cfset LvarNAP = LobjControl.ControlPresupuestario (LvarModuloOri, LvarDocumentoOri, LvarReferenciaOri, 
													LvarFecha, DateFormat(LvarFecha,"YYYY"), DateFormat(LvarFecha,"MM"), 
													session.DSN, session.Ecodigo)>
		</cfif>
				
		<cfif (LvarMes mod 100) EQ 12>
			<cfset LvarMes = (int(LvarMes/100)+1)*100>
		</cfif>
		<cfset LvarMes = LvarMes + 1>
	</cfloop>

	<!--- Vuelve el control de Contabilidad a su original --->
	<cfif rsOrigenAbierto.CPOid EQ "">
		<cfquery datasource="#session.dsn#">
			delete from CPOrigenesControlAbierto
			 where Ecodigo = #session.Ecodigo#
			   and Oorigen = '#LvarModuloOri#'
		</cfquery>
	<cfelse>
		<cfquery datasource="#session.dsn#">
			update CPOrigenesControlAbierto
			   set CPOborrado	= #rsOrigenAbierto.CPOborrado#,
			       CPOdesde		= <cfqueryparam cfsqltype="cf_sql_date" 		value="#rsOrigenAbierto.CPOdesde#">,
				   CPOhasta		= <cfqueryparam cfsqltype="cf_sql_date" 		value="#rsOrigenAbierto.CPOhasta#">
			 where Ecodigo = #session.Ecodigo#
			   and Oorigen = '#LvarModuloOri#'
		</cfquery>
	</cfif>
	<cfreturn "\nSe Generaron y Aprobaron #LvarCantidad# NAPs de Ejecución">
</cffunction>


