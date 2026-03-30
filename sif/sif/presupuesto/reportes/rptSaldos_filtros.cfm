<cfinclude template="../../Utiles/sifConcat.cfm">
<cfquery name="rsPeriodos" datasource="#Session.DSN#">
	select CPPid, 
				'Presupuesto ' #_Cat#
				case CPPtipoPeriodo when 1 then 'Mensual' when 2 then 'Bimestral' when 3 then 'Trimestral' when 4 then 'Cuatrimestral' when 6 then 'Semestral' when 12 then 'Anual' else '' end
					#_Cat# ' de ' #_Cat# 
					case {fn month(CPPfechaDesde)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
					#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(CPPfechaDesde)}">
					#_Cat# ' a ' #_Cat# 
					case {fn month(CPPfechaHasta)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
					#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(CPPfechaHasta)}">
			as Pdescripcion,
		   CPPtipoPeriodo, 
		   CPPfechaDesde, 
		   CPPfechaHasta, 
		   CPPfechaUltmodif, 
		   CPPestado
	from CPresupuestoPeriodo p
	where p.Ecodigo = #Session.Ecodigo#
	  and p.CPPestado <> 0
	order by CPPfechaHasta desc, CPPfechaDesde desc
</cfquery>

<cfif #rsPeriodos.CPPid# eq ''>			
	<cf_errorCode	code = "50542"
					msg  = "No existen Períodos de Presupuesto definidos"
					errorDat_1 = ''
	>
<cfelse>
<cfparam name="form.CPPid"	default="#rsPeriodos.CPPid#">
<cfset session.CPPid = form.CPPid>

<cf_CPSegUsu_setCFid>

<cfparam name="form.CPCano"	default="0">
<cfparam name="form.CPPmes"	default="0">

<cfquery name="rsReporte" datasource="#session.dsn#">
	select CPRnombre, CPRdescripcion, CPRdefinicion, CPRlineasPagina, 
			case CPRtipoPagina
				when 'CH' then 'Carta Horizontal (Letter Landscape)'
				when 'CV' then 'Carta Vertical (Letter Portrait)'
				when 'LH' then 'Legal Horizontal (Legal Landscape)'
				when 'LV' then 'Legal Vertical (Legal Portrait)'
			end as CPRtipoPagina
	  from CPReportes
	 where CPRid = #form.CPRid#
</cfquery>

<cfset LvarNL = chr(13) & chr(10)>
<cfset LvarDefinicion 	= rsReporte.CPRdefinicion>
<cfset LarrDefinicion 	= ListToArray(LvarDefinicion, LvarNL)>
<cfset LvarLineasPagina	= rsReporte.CPRlineasPagina>
<cfset LvarTipoPagina	= rsReporte.CPRtipoPagina>

<cfset LvarCortes 		= LarrDefinicion[6]>
<cfset LvarDatos 		= LarrDefinicion[7]>
<cfset LvarFiltros 		= LarrDefinicion[8]>

<cfset LarrCortes 		= listToArray(LvarCortes,"¦")>
<cfset LarrDatos 		= listToArray(LvarDatos,"¦")>
<cfset LarrFiltros 		= listToArray(LvarFiltros,"¦")>

<!--- 
	Cortes[i]: 
		Formato:	
			TIPO·VALOR¦...
		Corte[1]=Tipos:
			1=Corte por Nivel de Cuenta Presupuesto, VALOR=Nivel de cuenta (PCDCniv) o 'U' para ultimo nivel
			2=Corte por Clasificacion, VALOR=Codigo Clasificacion (PCCEcodigo)
			3=Corte por Mes, VALOR: V=Vertical H=Horizontal
			4=Corte por Oficina, VALOR=N/A
			5=Catálogo para Plan de Cuentas, VALOR=N/A
		Corte[2]=Valor que completa el corte

	Datos[i]:
		Formato:
			DIMENSION TEMPORAL·TITULO·EXPRESION¦...
		Dato[1]=Dimensiones Temporales:
			0=Se define en el Filtro de dimensión temporal
			1=Dato Mensual del período y mes escogido
			2=Dato Acumulado al mes del periodo escogido
			3=Dato Total o Acumulado de todo el período escogido
			4=Dato Mensual del período y mes 1 año atrás al escogido
			5=Dato Acumulado al mes del periodo 1 año atrás al escogido
			6=Dato Total o Acumulado de todo el período 1 año atrás al escogido
		Dato[2]=TITULO: equivale al nombre que se imprime en el encabezado de columnas
		Dato[3]=EXPRESION: es una formula donde se pueden utilizar los siguientes campos:
			1. 	Si la expresion inicia con *, indica que es una formula que involucra 
				únicamente datos o columnas impresos en el reporte, y que se llaman [C1] [C2] etc.
				Se pueden usar MACROS pero utilizados en el reporte (se sustituyen automáticamente por [C1] [C2])
			2. 	Si la expresion inicia con %, es una formula pero porcentual: Se multiplica por 100, se añade % y se 
				calcula la formula en los totales (no sumariza).
			3.	Columnas del reporte (sin * ni %), es una formula que involucra
				saldos de control de presupuesto, y los datos a utilizar son las MACROS
	Filtros[i]:
		Formato:
			TIPO·NIVEL_CORTE_O_DATO·VALOR·SUBTIPO·OBLIGATORIO¦...
		Filtro[1]=Tipos:
			0=Filtro fijo
			1=Cuenta, NIVEL_CORTE=N/A, VALOR=N/A
		*	2=Clasificacion, NIVEL_CORTE por Clasificacion a filtrar, VALOR=Codigo Clasificacion (PCCEcodigo)
		*	3=Mes Presupuesto (CPCano CPCmes), NIVEL_CORTE: corte por fecha a filtrar (0=No hay corte por fecha)
		*	4=Nivel de Cuenta, NIVEL_CORTE=Corte por cuenta a sustituir, VALOR=Niveles a mostar (defaults=U,1,2)
			5=Niveles de Corte, NIVEL_CORTE=N/A, VALOR=N/A
		*	6=Tipo de Dato, NIVEL_DATO=Dato al que sustituye, VALOR=N/A
			7=Tipo de Cuenta, NIVEL_CORTE=N/A, VALOR=Tipos a mostar (defaults=G,I,A)
		Filtro[2]=Nivel de Corte o de Dato asociado al filtro
		Filtro[3]=Valores que completan el filtro
		Filtro[4]=SubTipos:
			1=Valor
			2=Rango
			3=Dimensión Temporal y una Fecha (solo por Mes Presupuesto) (está asociado a todos los datos con Dimensión temporal 0)
		Filtro[5]=OBLIGATORIO:
			S=Obligatorio
			N=Opcional
 --->

<!--- Verifica Asociaciones entre Filtro y Cortes/Datos --->
<cfloop index="f" from="1" to="#arrayLen(LarrFiltros)#">
	<cfset LvarFiltro = listToArray(LarrFiltros[f],"·")>
	<cfif LvarFiltro[1] EQ "2">
		<cfif not isnumeric(LvarFiltro[2]) OR LvarFiltro[2] EQ 0>
			<cf_errorCode	code = "50510"
							msg  = "Filtro @errorDat_1@ por Clasificación '@errorDat_2@' no tiene asociado un Nivel de Corte"
							errorDat_1="#f#"
							errorDat_2="#LvarFiltro[3]#"
			>
		<cfelseif LvarFiltro[2] GT arrayLen(LarrCortes)>
			<cf_errorCode	code = "50511"
							msg  = "Filtro @errorDat_1@ por Clasificación '@errorDat_2@' está asociado a un Nivel de Corte no existente"
							errorDat_1="#f#"
							errorDat_2="#LvarFiltro[3]#"
			>
		</cfif>
		<cfset LvarCorte = listToArray(LarrCortes[LvarFiltro[2]],"·")>
		<cfif LvarCorte[1] NEQ 2>
			<cf_errorCode	code = "50512"
							msg  = "Filtro @errorDat_1@ por Clasificación '@errorDat_2@' está asociado a un Nivel de Corte que no es por Clasificación"
							errorDat_1="#f#"
							errorDat_2="#LvarFiltro[3]#"
			>
		<cfelseif LvarCorte[2] NEQ LvarFiltro[3]>
			<cf_errorCode	code = "50513"
							msg  = "Filtro @errorDat_1@ por Clasificación '@errorDat_2@' está asociado a un Nivel de Corte por Clasificacion '@errorDat_3@'"
							errorDat_1="#f#"
							errorDat_2="#LvarFiltro[3]#"
							errorDat_3="#LvarCorte[2]#"
			>
		</cfif>
	<cfelseif LvarFiltro[1] EQ "3">
		<cfif not isnumeric(LvarFiltro[2])>
			<cf_errorCode	code = "50514"
							msg  = "Filtro @errorDat_1@ por Fecha no tiene asociado un Nivel de Corte"
							errorDat_1="#f#"
			>
		<cfelseif LvarFiltro[2] GT arrayLen(LarrCortes)>
			<cf_errorCode	code = "50515"
							msg  = "Filtro @errorDat_1@ por Fecha '@errorDat_2@' está asociado a un Nivel de Corte no existente"
							errorDat_1="#f#"
							errorDat_2="#LvarFiltro[3]#"
			>
		</cfif>
		<cfif LvarFiltro[2] GT 0>
			<cfset LvarCorte = listToArray(LarrCortes[LvarFiltro[2]],"·")>
			<cfif LvarCorte[1] NEQ 3>
				<cf_errorCode	code = "50516"
								msg  = "Filtro @errorDat_1@ por Fecha está asociado a un Nivel de Corte que no es por Fecha"
								errorDat_1="#f#"
				>
			</cfif>
		</cfif>
		<cfif LvarFiltro[4] EQ 3>
			<cfloop index="d" from="1" to="#arrayLen(LarrDatos)#">
				<cfset LvarDato = listToArray(LarrDatos[d],"·")>
				<cfif LvarDato[1] EQ 0>
					<cfbreak>
				</cfif>
			</cfloop>
			<cfif d GT arrayLen(LarrDatos)>
				<cf_errorCode	code = "50517"
								msg  = "Filtro @errorDat_1@ por Dimensión Temporal no está asociado a ningún Nivel de Datos (Falta Dato con Dimensión Temporal = 0)"
								errorDat_1="#f#"
				>
			</cfif>
		</cfif>
	</cfif>
</cfloop>

<cfset LvarCortesExcluir = "">
<form name="form1" method="post" action="rptSaldos_imprimir.cfm" onSubmit="return sbSubmit();">
	<cfif isdefined("url.debug") OR isdefined("form.debug")>
	<input type="hidden" name="debug" value="1">
	</cfif>
	<cfoutput>
	<input type="hidden" name="CPRid" value="#form.CPRid#">
	</cfoutput>
	<table width="100%" border="0">
		<tr>
			<td width="20%">
				Reporte:
			</td>
			<td colspan="3">
				<cfoutput>
				<strong>#rsReporte.CPRnombre#<br>#rsReporte.CPRdescripcion#</strong>
				</cfoutput>
			</td>
		</tr>
		<tr>
			<td>
				Período Presupuestario:
			</td>
			<td colspan="2">
				<cf_cboCPPid value="#session.CPPid#" onChange="javascript: this.form.action='';this.form.submit();" CPPestado="1,2">
			</td>
			<td width="300">&nbsp;
				
			</td>
		</tr>
		<tr>
			<td>
				Centro Funcional:
			</td>
			<td colspan="2">
				<cf_CPSegUsu_cboCFid value="#form.CFid#" Consultar="true">
			</td>
		</tr>
	
	<cfloop index="f" from="1" to="#arrayLen(LarrFiltros)#">
		<cfset LvarFiltro = listToArray(LarrFiltros[f],"·")>
		<!--- [1]=TIPO·[2]=NIVEL_CORTE·[3]=VALOR·[4]=SUBTIPO·[5]=OBLIGATORIO·[6]=FILTRO_FIJO --->
		<cfif LvarFiltro[5] NEQ "F">
			<!--- Filtro Fijo no hace nada --->
			<cfif LvarFiltro[1] EQ "0">
			<!--- Filtro por Cuenta de Presupuesto --->
			<cfelseif LvarFiltro[1] EQ "1">
			<tr>
				<td>
					Cuentas de Presupuesto:
				</td>
				<cfif LvarFiltro[4] EQ "1">
					<cfparam name="form.CPformato" default="">
					<td colspan="2">
						<cf_CuentaPresupuesto name="CPformato" value="#form.CPformato#">
					</td>
				<cfelseif LvarFiltro[4] EQ "2">
					<cfparam name="form.CPformato1" default="">
					<cfparam name="form.CPformato2" default="">
					<td>
						<cf_CuentaPresupuesto name="CPformato1" value="#form.CPformato1#">
					</td>
					<td>
						<cf_CuentaPresupuesto name="CPformato2" value="#form.CPformato2#">
					</td>
				</cfif>
			</tr>
			<!--- Filtro por Clasificacion de Catalogos de Plan --->
			<cfelseif LvarFiltro[1] EQ "2">
				<cfquery name="rsClasificacion" datasource="#session.dsn#">
					select PCCEclaid, PCCEcodigo, PCCEdescripcion
					  from PCClasificacionE e
					 where CEcodigo = #session.CEcodigo#
					   and PCCEcodigo = '#LvarFiltro[3]#'
				</cfquery>
				<cfif rsClasificacion.recordCount EQ 0>
					<cf_errorCode	code = "50518"
									msg  = "Este Reporte requiere la Clasificacion de Catálogos para Plan de Cuentas codigo='@errorDat_1@' pero no está definida"
									errorDat_1="#LvarFiltro[3]#"
					>
				<cfelseif rsClasificacion.recordCount GT 1>
					<cf_errorCode	code = "50519"
									msg  = "Existen más de una Clasificacion de Catálogos para Plan de Cuentas con codigo='@errorDat_1@'"
									errorDat_1="#LvarFiltro[3]#"
					>
				</cfif>

				<cfset LvarError = "">
				<cfquery name="rsValores" datasource="#session.dsn#">
					select PCCDvalor, 
							PCCDvalor #_Cat# '-' #_Cat# PCCDdescripcion as Vdescripcion
					  from PCClasificacionD d
					 where coalesce(Ecodigo,#session.Ecodigo#) = #session.Ecodigo#
					   and PCCEclaid = #rsClasificacion.PCCEclaid#
					 order by PCCDvalor
				</cfquery>
				<cfif rsValores.recordCount EQ 0>
					<cfset LvarError = "No hay valores definidos en esta Clasificación">
				<cfelse>
					<cfquery name="rsSQL" datasource="#session.dsn#">
						select count(1) as cantidad
						  from PCEClasificacionCatalogo cl
							inner join PCDCatalogoCuentaP cubo
								inner join CPresupuesto p
								   on p.CPcuenta = cubo.CPcuenta
								  and p.Ecodigo = #session.Ecodigo#
							   on cubo.PCEcatid  = cl.PCEcatid
						 where cl.PCCEclaid = #rsClasificacion.PCCEclaid#
					</cfquery>
					<cfif rsSQL.cantidad EQ 0>
						<cfset LvarError = "No existen Cuentas de Presupuesto para esta Clasificación">
					</cfif>
				</cfif>
			<tr>
				<td>
					<cfoutput>
					#rsClasificacion.PCCEdescripcion#:
					</cfoutput>
				</td>
				<cfif LvarError NEQ "">
					<td colspan="2" style="color:red;">
						<cfoutput>#LvarError#</cfoutput>
						<cfset LvarCortesExcluir = LvarCortesExcluir & "," & LvarFiltro[2]>
					</td>
				<cfelseif LvarFiltro[4] EQ "1">
					<cfparam name="form.PCCDvalor_#LvarFiltro[2]#" default="">
					<cfset LvarValor = evaluate("PCCDvalor_#LvarFiltro[2]#")>
					<td colspan="2">
						<cfoutput>
						<select name="PCCDvalor_#LvarFiltro[2]#">
						</cfoutput>
							<cfif LvarFiltro[5] EQ "N">
								<option value=""></option>
							</cfif>
							<cfoutput query="rsValores">
								<option value="#rsValores.PCCDvalor#" <cfif LvarValor EQ rsValores.PCCDvalor>selected</cfif>>#rsValores.Vdescripcion#</option>
							</cfoutput>
						</select>
					</td>
				<cfelseif LvarFiltro[4] EQ "2">
					<cfparam name="form.PCCDvalor1_#LvarFiltro[2]#" default="">
					<cfset LvarValor1 = evaluate("PCCDvalor1_#LvarFiltro[2]#")>
					<cfparam name="form.PCCDvalor2_#LvarFiltro[2]#" default="">
					<cfset LvarValor2 = evaluate("PCCDvalor2_#LvarFiltro[2]#")>
					<td>
						<cfoutput>
						<select name="PCCDvalor1_#LvarFiltro[2]#">
						</cfoutput>
							<cfif LvarFiltro[5] EQ "N">
								<option value=""></option>
							</cfif>
							<cfoutput query="rsValores">
								<option value="#rsValores.PCCDvalor#" <cfif LvarValor1 EQ rsValores.PCCDvalor>selected</cfif>>#rsValores.Vdescripcion#</option>
							</cfoutput>
						</select>
					</td>
					<td>
						<cfoutput>
						<select name="PCCDvalor2_#LvarFiltro[2]#">
						</cfoutput>
							<cfif LvarFiltro[5] EQ "N">
								<option value=""></option>
							</cfif>
							<cfoutput query="rsValores">
								<option value="#rsValores.PCCDvalor#" <cfif LvarValor2 EQ rsValores.PCCDvalor>selected</cfif>>#rsValores.Vdescripcion#</option>
							</cfoutput>
						</select>
					</td>
				</cfif>
			</tr>
			<!--- Filtro por Fecha --->
			<cfelseif LvarFiltro[1] EQ "3">
				<cfquery name="rsMeses" datasource="#session.dsn#">
					select a.CPCano, a.CPCmes,
							<cf_dbfunction name="to_char" datasource="sifControl" args="a.CPCano"> #_Cat# ' - ' #_Cat#
							case a.CPCmes
								when 1 then 'Enero'
								when 2 then 'Febrero'
								when 3 then 'Marzo'
								when 4 then 'Abril'
								when 5 then 'Mayo'
								when 6 then 'Junio'
								when 7 then 'Julio'
								when 8 then 'Agosto'
								when 9 then 'Septiembre'
								when 10 then 'Octubre'
								when 11 then 'Noviembre'
								when 12 then 'Diciembre'
							end as descripcion
					  from CPmeses a
					 where a.Ecodigo = #session.ecodigo#
					   and a.CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPPid#">
					 order by a.CPCano, a.CPCmes
				</cfquery>
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
					<cfset LvarAnoIni = 0>
					<cfset LvarMesIni = 0>
					<cfset LvarAnoFin = 0>
					<cfset LvarMesFin = 0>
				<cfelseif rsParametros.UltMes EQ 12>
					<cfset LvarAnoIni = rsParametros.Ano>
					<cfset LvarMesIni = 1>
					<cfset LvarAnoFin = rsParametros.Ano>
					<cfset LvarMesFin = 12>
				<cfelseif rsParametros.Mes GT rsParametros.UltMes>
					<cfset LvarAnoIni = rsParametros.Ano>
					<cfset LvarMesIni = rsParametros.UltMes+1>
					<cfset LvarAnoFin = rsParametros.Ano+1>
					<cfset LvarMesFin = rsParametros.UltMes>
				<cfelse>
					<cfset LvarAnoIni = rsParametros.Ano-1>
					<cfset LvarMesIni = rsParametros.UltMes+1>
					<cfset LvarAnoFin = rsParametros.Ano>
					<cfset LvarMesFin = rsParametros.UltMes>
				</cfif>
				
				<cfset LvarAnoMesActual	= rsParametros.Ano*100+rsParametros.Mes>
				<cfset LvarAnoMesInicio	= LvarAnoIni*100+LvarMesIni>
				<cfset LvarAnoMesFinal	= LvarAnoFin*100+LvarMesFin>
			<tr>
				<td>
					Mes de Presupuesto:
				</td>
				<cfif LvarFiltro[4] EQ "1">
					<cfparam name="form.CPCanoMes" default="#LvarAnoMesActual#">
					<td colspan="2">
						<select name="CPCanoMes">
							<cfoutput query="rsMeses">
								<option value="#rsMeses.CPCano*100+rsMeses.CPCmes#" <cfif form.CPCanoMes mod 100 EQ rsMeses.CPCmes>selected</cfif>>#rsMeses.descripcion#</option>
							</cfoutput>
						</select>
					</td>
				<cfelseif LvarFiltro[4] EQ "2">
					<cfparam name="form.CPCanoMes1" default="#LvarAnoMesInicio#">
					<cfparam name="form.CPCanoMes2" default="#LvarAnoMesFinal#">
					<td>
						<select name="CPCanoMes1">
							<cfoutput query="rsMeses">
								<option value="#rsMeses.CPCano*100+rsMeses.CPCmes#" <cfif form.CPCanoMes1 mod 100 EQ rsMeses.CPCmes>selected</cfif>>#rsMeses.descripcion#</option>
							</cfoutput>
						</select>
					</td>
					<td>
						<select name="CPCanoMes2">
							<cfoutput query="rsMeses">
								<option value="#rsMeses.CPCano*100+rsMeses.CPCmes#" <cfif form.CPCanoMes2 mod 100 EQ rsMeses.CPCmes>selected</cfif>>#rsMeses.descripcion#</option>
							</cfoutput>
						</select>
					</td>
				<cfelseif LvarFiltro[4] EQ "3">
					<cfparam name="form.CPCanoMes" default="#LvarAnoMesActual#">
					<cfparam name="form.CPCtemporal" default="">
					<td colspan="2">
						<cfif trim(LvarFiltro[3]) EQ "" OR trim(LvarFiltro[3]) EQ "[]">
							<cfset LvarFiltro[3] = "1,2,3">
						</cfif>
						<select name="CPCtemporal"
							 	onchange=
										"
											if (this.value == '3')
											{
												this.form.CPCanoMes.options[this.form.CPCanoMes.options.length - 1].selected = true;
												this.form.CPCanoMes.style.display = 'none';
											}
											else
												this.form.CPCanoMes.style.display = '';

										"
								>
						<cfif listFind(LvarFiltro[3],"1")>
							<option value="1" <cfif form.CPCtemporal EQ "1">selected</cfif>>Saldos Mensuales de</option>
						</cfif>
						<cfif listFind(LvarFiltro[3],"2")>
							<option value="2" <cfif form.CPCtemporal EQ "2">selected</cfif>>Saldos Acumulados a</option>
						</cfif>
						<cfif listFind(LvarFiltro[3],"3")>
							<option value="3" <cfif form.CPCtemporal EQ "3">selected</cfif>>Saldos Totales del Periodo</option>
						</cfif>
						</select>
						<select name="CPCanoMes">
							<cfoutput query="rsMeses">
								<option value="#rsMeses.CPCano*100+rsMeses.CPCmes#" <cfif form.CPCanoMes mod 100 EQ rsMeses.CPCmes>selected</cfif>>#rsMeses.descripcion#</option>
							</cfoutput>
						</select>
					</td>
				</cfif>
			</tr>
			<!--- Filtro por Nivel de Cuenta --->
			<cfelseif LvarFiltro[1] EQ "4">
			<tr>
				<td>
					Nivel de Cuenta:
				</td>
				<td colspan="2">
					<cfparam name="form.CPCNivel" default="">
					<cfparam name="form.chkTotalizarNiveles" default="0">
					<select name="CPCNivel">
						<cfif trim(LvarFiltro[3]) EQ "" OR trim(LvarFiltro[3]) EQ "[]">
							<cfset LvarFiltro[3] = "U,1,2">
						</cfif>
						<cfoutput>
						<cfloop list="#LvarFiltro[3]#" index="i">
							<option value="#i#" <cfif form.CPCNivel EQ i>selected</cfif>><cfif i EQ "U">Último Nivel<cfelse>Nivel #i#</cfif></option>
						</cfloop>
						</cfoutput>
					</select>
					<input type="checkbox" name="chkTotalizarNiveles" value="1"/> Totalizar por Nivel
				</td>
			</tr>
			<!--- Filtro por estructura del reporte --->
			<cfelseif LvarFiltro[1] EQ "5">
			<tr>
				<td valign="top">
					Nivel de Detalle de Cortes:
				</td>
				<td colspan="2">
					<table style="border:solid 1px ##CCCCCC">
						<tr>
							<td><strong>Indique los Cortes que desea incluir en el reporte</strong>&nbsp;&nbsp;&nbsp;&nbsp;</td>
							<td align="center">Orden</td>
						</tr>
					<cfoutput>
					<cfloop index="i" from="1" to="#arrayLen(LarrCortes)#">
						<cfset LarrCorte = listToArray(LarrCortes[i],"·")>
						<tr>
							<td>
							<cfif LarrCorte[1] EQ "3">
								<input type="hidden" name="chkCorte#i#" value="1"/>
								<input type="checkbox" checked="checked" disabled="disabled"/>
									Mes de Presupuesto
								<input type="hidden" name="CPCcortes#i#" value="1000"/>
							</td>
							<cfelse>
								<cfif isdefined("form.CPCcortes#i#")>
									<cfset LvarChecked = isdefined("form.chkCorte#i#")>
								<cfelse>
									<cfset LvarChecked = true>
								</cfif>
								<input 	type="checkbox" name="chkCorte#i#" value="1" 
									<cfif listFind(LvarCortesExcluir,i)>
										disabled
									<cfelseif LvarChecked>
										checked
									</cfif>
								>
								<cfif LarrCorte[1] EQ "1">
									<cfif LarrCorte[2] EQ "0">
										Cuenta de Mayor
									<cfelseif LarrCorte[2] EQ "U">
										Cuenta de Presupuesto
									<cfelse>
										Nivel #LarrCorte[2]# de Cuenta de Presupuesto
									</cfif>
								<cfelseif LarrCorte[1] EQ "2">
									<cfquery name="rsClasificacion" datasource="#session.dsn#">
										select PCCEdescripcion
										  from PCClasificacionE e
										 where CEcodigo = #session.CEcodigo#
										   and PCCEcodigo = '#LarrCorte[2]#'
									</cfquery>
									<cfif rsClasificacion.recordCount EQ 0>
										<cf_errorCode	code = "50518"
														msg  = "Este Reporte requiere la Clasificacion de Catálogos para Plan de Cuentas codigo='@errorDat_1@' pero no está definida"
														errorDat_1="#LarrCorte[2]#"
										>
									<cfelseif rsClasificacion.recordCount GT 1>
										<cf_errorCode	code = "50519"
														msg  = "Existen más de una Clasificacion de Catálogos para Plan de Cuentas con codigo='@errorDat_1@'"
														errorDat_1="#LarrCorte[2]#"
										>
									</cfif>
									#rsClasificacion.PCCEdescripcion#
								<cfelseif LarrCorte[1] EQ "3">
									Mes de Presupuesto
								<cfelseif LarrCorte[1] EQ "4">
									Oficina
								<cfelseif LarrCorte[1] EQ "5">
									<cfquery name="rsCatalogo" datasource="#session.dsn#">
										select PCEdescripcion
										  from PCECatalogo e
										 where CEcodigo = #session.CEcodigo#
										   and PCEcodigo = '#LarrCorte[2]#'
									</cfquery>
									<cfif rsCatalogo.recordCount EQ 0>
										<cf_errorCode	code = "50523"
														msg  = "Este Reporte requiere el Catálogo para Plan de Cuentas codigo='@errorDat_1@' pero no está definida"
														errorDat_1="#LarrCorte[2]#"
										>
									<cfelseif rsCatalogo.recordCount GT 1>
										<cf_errorCode	code = "50524"
														msg  = "Existen más de un Catálogo para Plan de Cuentas con codigo='@errorDat_1@'"
														errorDat_1="#LarrCorte[2]#"
										>
									</cfif>
									#rsCatalogo.PCEdescripcion#
								</cfif>
							</td>
							<td align="center">
							<cfif NOT listFind(LvarCortesExcluir,i)>
								<cfparam name="form.CPCcortes#i#" default="#i#">
								<cfset LvarValor = evaluate("form.CPCcortes#i#")>
								<cf_monto value="#LvarValor#" name="CPCcortes#i#" size="2" decimales="0">
							<cfelseif i EQ 1>
								<input type="hidden" name="CPCcortes1" value="1000"/>
							</cfif>
							</td>
							</cfif>
						</tr>
					</cfloop>
					</cfoutput>
					</table>
				</td>
			</tr>
			<!--- Filtro por Tipo de Dato --->
			<cfelseif LvarFiltro[1] EQ "6">
			<tr>
				<td>
					Tipo de Dato <cfoutput>#LvarFiltro[2]#</cfoutput>:
				</td>
				<cfparam name="form.Dato#LvarFiltro[2]#" default="#listGetAt("[A],[M],[*PF],[T],[TE],[VC],[*PP],[ME],[*PA],[RA],[CA],[RC],[CC],[E],[*PCA],[RP],[*PC],[NP],[*DN]",LvarFiltro[2])#">
				<cfset LvarValor = evaluate("form.Dato#LvarFiltro[2]#")>
				
				<td colspan="2">
					<select name="Dato<cfoutput>#LvarFiltro[2]#</cfoutput>">
						<option value="[A]" 	<cfif LvarValor EQ "[A]">	selected</cfif>>[A]  = Aprobación Presupuesto Ordinario</option>
						<option value="[M]" 	<cfif LvarValor EQ "[M]">	selected</cfif>>[M]  = Modificación Presupuesto Extraordinario</option>
						<option value="[*PF]" 	<cfif LvarValor EQ "[*PF]">	selected</cfif>>[*PF]:PRESUPUESTO FORMULADO =[A]+[M]</option>
						<option value="[T]" 	<cfif LvarValor EQ "[T]">	selected</cfif>>[T]  = Traslados de Presupuesto Internos</option>
						<option value="[TE]" 	<cfif LvarValor EQ "[TE]">	selected</cfif>>[TE] = Traslados con Autorización Externa</option>
						<option value="[VC]" 	<cfif LvarValor EQ "[VC]">	selected</cfif>>[VC] = Variación Cambiaria</option>
						<option value="[*PP]" 	<cfif LvarValor EQ "[*PP]">	selected</cfif>>[*PP]:PRESUPUESTO PLANEADO =[*PF]+[T]+[TE]+[VC]=[A]+[M]+[T]+[TE]+[VC]</option>
						<option value="[ME]"	<cfif LvarValor EQ "[ME]">	selected</cfif>>[ME] = Modificación por Excesos Autorizados</option>
						<option value="[*PA]" 	<cfif LvarValor EQ "[*PA]">	selected</cfif>>[*PA]:PRESUPUESTO AUTORIZADO =[*PP]+[ME]=[A]+[M]+[T]+[TE]+[VC]+[ME]</option>
						<option value="[RA]" 	<cfif LvarValor EQ "[RC]">	selected</cfif>>[RA] = Presupuesto Reservado Período Anterior</option>
						<option value="[CA]" 	<cfif LvarValor EQ "[CC]">	selected</cfif>>[CA] = Presupuesto Comprometido Período Anterior</option>
						<option value="[RC]" 	<cfif LvarValor EQ "[RC]">	selected</cfif>>[RC] = Presupuesto Reservado</option>
						<option value="[CC]" 	<cfif LvarValor EQ "[CC]">	selected</cfif>>[CC] = Presupuesto Comprometido</option>
						<option value="[E]" 	<cfif LvarValor EQ "[E]">	selected</cfif>>[E]  = Presupuesto Ejecutado</option>
						<option value="[*PCA]" 	<cfif LvarValor EQ "[*PCA]">selected</cfif>>[*PCA]:CONSUMO DE AUXILIARES Y CONTABILIDAD =[RA]+[CA]+[RC]+[CC]+[E]</option>
						<option value="[RP]" 	<cfif LvarValor EQ "[RP]">	selected</cfif>>[RP] = Provisiones Presupuestarias</option>
						<option value="[*PC]" 	<cfif LvarValor EQ "[*PC]">	selected</cfif>>[*PC]:PRESUPUESTO CONSUMIDO =[*PCA]+[RP]=[RA]+[CA]+[RC]+[CC]+[E]+[RP]</option>
						<option value="[NP]" 	<cfif LvarValor EQ "[NP]">	selected</cfif>>[NP] = Rechazos Aprobados Pendientes de Aplicar</option>
						<option value="[*DN]" 	<cfif LvarValor EQ "[*DN]">	selected</cfif>>[*DN]:DISPONIBLE NETO = [*PA] - [*PC] - [NP]</option>
					</select>
				</td>
			</tr>
			<!--- Filtro por Tipo de Cuenta --->
			<cfelseif LvarFiltro[1] EQ "7">
			<tr>
				<td>
					Tipo de Cuenta:
				</td>
				<td colspan="2">
					<cfparam name="form.CPCtipoCta" default="">
					<select name="CPCtipoCta">
						<cfif trim(LvarFiltro[3]) EQ "" OR trim(LvarFiltro[3]) EQ "[]">
							<cfset LvarFiltro[3] = "A,I,G">
						</cfif>
						<cfif LvarFiltro[5] EQ "N">
							<option value="" <cfif form.CPCtipoCta EQ "">selected</cfif>>(Cualquier Tipo)</option>
						</cfif>
						<cfif listFind(LvarFiltro[3],"G")>
							<option value="G" <cfif form.CPCtipoCta EQ "G">selected</cfif>>Gastos</option>
						</cfif>
						<cfif listFind(LvarFiltro[3],"I")>
							<option value="I" <cfif form.CPCtipoCta EQ "I">selected</cfif>>Ingresos</option>
						</cfif>
						<cfif listFind(LvarFiltro[3],"A")>
							<option value="A" <cfif form.CPCtipoCta EQ "A">selected</cfif>>Activos</option>
						</cfif>
					</select>
				</td>
			<!--- Filtro por Oficina o Grupo de Oficinas --->
			<cfelseif LvarFiltro[1] EQ "8">
			<tr>
				<td>
					Oficina:
				</td>
				<td colspan="2">
					<cfquery name="rsOficinas" DataSource="#Session.DSN#">
						select Ocodigo, Oficodigo, Odescripcion
						  from Oficinas
						 where Ecodigo = #session.Ecodigo#
					</cfquery>
					<cfquery name="rsGOficinas" DataSource="#Session.DSN#">
						select GOid, GOcodigo, GOnombre
						  from AnexoGOficina
						 where Ecodigo = #session.Ecodigo#
					</cfquery>
					<cfparam name="form.FOficina" default="">
					<cfset LvarFOfiTipo	= listFirst(form.FOficina)>
					<cfset LvarFOfiId	= listLast(form.FOficina)>
					<cfoutput>
					<select name="FOficina">
						<option value="">(Todas las Oficinas)</option>
						<cfif rsGOficinas.recordCount GT 0>
							<optgroup label="Grupo de Oficinas:">
							<cfloop query="rsGOficinas">
								<option value="GO,#rsGOficinas.GOid#" <cfif LvarFOfiTipo EQ "GO" AND LvarFOfiId EQ rsGOficinas.GOid>selected</cfif>>#rsGOficinas.GOcodigo# - #rsGOficinas.GOnombre#</option>
							</cfloop>
							</optgroup>
						</cfif>
						<optgroup label="Oficinas:">
						<cfloop query="rsOficinas">
							<option value="OF,#rsOficinas.Ocodigo#" <cfif LvarFOfiTipo EQ "OF" AND LvarFOfiId EQ rsOficinas.Ocodigo>selected</cfif>>#rsOficinas.Oficodigo# - #rsOficinas.Odescripcion#</option>
						</cfloop>
						</optgroup>
					</select>
					</cfoutput>
				</td>
			<cfelse>
				<cf_errorCode	code = "50525"
								msg  = "Filtro=@errorDat_1@ no ha sido implementado"
								errorDat_1="#LvarFiltro[1]#"
				>
			</cfif>
		</cfif>
	</cfloop>
		<tr>
			<td>
				Eliminar detalles en Cero:
			</td>
			<td colspan="2">
				<input type="checkbox" name="chkNoCeros" value="1" <cfif isdefined("form.chkNoCeros")>checked</cfif>/>
			</td>
		</tr>
		<tr>
			<cf_btnImprimir name="rptSaldos" TipoPagina="#LvarTipoPagina#">
		</tr>
	</table>
</form>
</cfif>
<script>
	var GvarSubmit = false;
	function sbSubmit()
	{
		GvarSubmit = true;
		return true;
	}
</script>
