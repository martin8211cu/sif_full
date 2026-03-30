<cfsetting 	requesttimeout="900"
			enablecfoutputonly="yes">
<cfinclude template="rptSaldos_nuevos.cfm">

<cfset LvarPagina = 0>
<cfset LvarDebug = false>
<cfset LvarAbort = false>

<cfset LvarMesesHorizontales = false>


<cfset LvarSybase = false>
<cfset LvarSybase = listFind("sybase,sqlserver",Application.dsinfo[#session.dsn#].type)>
<cfset LvarSqlServer = ("sqlserver" EQ Application.dsinfo[#session.dsn#].type)>

<cfif isdefined("form.debug")>
	<cfset LvarDebug = true>
	<cfset LvarAbort = true>
</cfif>

<cfif isdefined("form.CFid") AND form.CFid NEQ "" AND form.CFid GT 0>
	<cfquery name="rsSQL" datasource="#Session.DSN#">
		select CFdescripcion 
		  from CFuncional 
		 where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
	</cfquery>
	<cfset LvarCF = "Cuentas del Centro Funcional: #rsSQL.CFdescripcion#">
<cfelseif isdefined("form.CFid") AND form.CFid EQ -100>
	<cfset LvarCF = "Todas las cuentas permitidas para el usuario">
<cfelse>
	<cfset LvarCF = "">
</cfif>
<cftry>
	<cf_dbtemp name="ctasSegV1" returnvariable="ctasOfiTmp" datasource="#session.dsn#">
		<cf_dbtempcol name="CPcuenta"		type="numeric"		mandatory="yes">
		<cf_dbtempcol name="Ecodigo"		type="integer"		mandatory="yes">
		<cf_dbtempcol name="Ocodigo"		type="integer"		mandatory="yes">
	</cf_dbtemp >
	<cf_dbtemp name="mesesSegV1" returnvariable="mesesTmp" datasource="#session.dsn#">
		<cf_dbtempcol name="CPPid"			type="numeric"		mandatory="yes">
		<cf_dbtempcol name="Ecodigo"		type="integer"		mandatory="yes">
		<cf_dbtempcol name="CPCano"			type="integer"		mandatory="yes">
		<cf_dbtempcol name="CPCmes"			type="integer"		mandatory="yes">
		<cf_dbtempcol name="CPCanoMes"		type="integer"		mandatory="yes">
	</cf_dbtemp >
	<cf_dbtemp name="ctasClaV1" returnvariable="ctasClaTmp" datasource="#session.dsn#">
		<cf_dbtempcol name="Corte"			type="integer"		mandatory="yes">
		<cf_dbtempcol name="CPcuenta"		type="numeric"		mandatory="yes">
		<cf_dbtempcol name="PCCDvalor"		type="char(10)"		mandatory="no">
		<cf_dbtempcol name="PCCDdescripcion"type="varchar(50)"	mandatory="no">

		<cf_dbtempkey cols="CPcuenta, Corte">
	</cf_dbtemp >

	<cfif not isdefined("session.rptRnd")><cfset session.rptRnd = int(rand()*10000)></cfif>
	<cfif isdefined("form.btnCancelar")>
		<cfset session.rptSaldos_Cancel = true>
		<cflocation url="rptSaldos.cfm?CPRid=#form.CPRid#">
		<cfabort>	
	</cfif>
    <cfinclude template="../../Utiles/sifConcat.cfm">
	<cflock timeout="1" name="rptSaldos_#session.rptRnd#" throwontimeout="yes">
		<cfset structDelete(session, "rptSaldos_Cancel")>

		<cf_CPSegUsu_setCFid>
		<cfset LvarNL = chr(13) & chr(10)>
		
		<cfquery name="rsPeriodo" datasource="#Session.DSN#">
			select 'Presupuesto ' #_Cat#
						case CPPtipoPeriodo when 1 then 'Mensual' when 2 then 'Bimestral' when 3 then 'Trimestral' when 4 then 'Cuatrimestral' when 6 then 'Semestral' when 12 then 'Anual' else '' end
							#_Cat# ' de ' #_Cat# 
							case {fn month(CPPfechaDesde)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
							#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(CPPfechaDesde)}">
							#_Cat# ' a ' #_Cat# 
							case {fn month(CPPfechaHasta)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
							#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(CPPfechaHasta)}">
					as Pdescripcion,
					CPPanoMesDesde, CPPfechaDesde,
					CPPanoMesHasta, CPPfechaHasta
			from CPresupuestoPeriodo p
			where p.Ecodigo	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and p.CPPid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPPid#">
		</cfquery>
		<cfif isdefined("form.CPCanoMes1")>
			<cfif form.CPCanoMes1 NEQ "">
				<cfset LvarCPCanoMes1 = form.CPCanoMes1>
				<cfset LvarAno1 = mid(LvarCPCanoMes1,1,4)>
				<cfset LvarMes1 = mid(LvarCPCanoMes1,5,2)>
				<cfif form.CPCanoMes2 EQ "">
					<cfset LvarAno = mid(LvarCPCanoMes1,1,4)>
					<cfset LvarMes = mid(LvarCPCanoMes1,5,2)>
				<cfelse>
					<cfset LvarCPCanoMes2 = form.CPCanoMes2>
					<cfset LvarAno = mid(LvarCPCanoMes2,1,4)>
					<cfset LvarMes = mid(LvarCPCanoMes2,5,2)>
				</cfif>
			<cfelseif form.CPCanoMes2 NEQ "">
				<cfset LvarCPCanoMes1 = rsPeriodo.CPPanoMesDesde>
				<cfset LvarCPCanoMes2 = form.CPCanoMes2>
				<cfset LvarAno1 = mid(LvarCPCanoMes1,1,4)>
				<cfset LvarMes1 = mid(LvarCPCanoMes1,5,2)>
				<cfset LvarAno = mid(LvarCPCanoMes2,1,4)>
				<cfset LvarMes = mid(LvarCPCanoMes2,5,2)>
			<cfelse>
				<cfset LvarAno1 = mid(rsPeriodo.CPPanoMesDesde,1,4)>
				<cfset LvarMes1 = mid(rsPeriodo.CPPanoMesDesde,5,2)>
				<cfset LvarAno = mid(rsPeriodo.CPPanoMesHasta,1,4)>
				<cfset LvarMes = mid(rsPeriodo.CPPanoMesHasta,5,2)>
			</cfif>
			<cfset LvarAno0 = mid(rsPeriodo.CPPanoMesDesde,1,4)>
			<cfset LvarMes0 = mid(rsPeriodo.CPPanoMesDesde,5,2)>
			
			<cfif LvarAno1*100+LvarMes1 EQ LvarAno*100+LvarMes>
				<cfset LvarRANGO_FEC = fnNombreMes(LvarMes1,false)>
			<cfelse>
				<cfset LvarRANGO_FEC = left(fnNombreMes(LvarMes1,false),3) & "&##8209;" & left(fnNombreMes(LvarMes,false),3)>
			</cfif>
			<cfif LvarAno1*100+LvarMes1 EQ rsPeriodo.CPPanoMesDesde>
				<cfset LvarRANGO_ANT = "N/A">
			<cfelseif (LvarMes0 EQ LvarMes1-1) OR (LvarMes0 EQ 12 AND LvarMes1 EQ 1)>
				<cfset LvarRANGO_ANT = fnNombreMes(LvarMes0,false)>
			<cfelseif LvarMes1 EQ 1>
				<cfset LvarRANGO_ANT = left(fnNombreMes(LvarMes0,false),3) & "&##8209;" & left(fnNombreMes(12,false),3)>
			<cfelse>
				<cfset LvarRANGO_ANT = left(fnNombreMes(LvarMes0,false),3) & "&##8209;" & left(fnNombreMes(LvarMes1-1,false),3)>
			</cfif>
		<cfelseif isdefined("form.CPCanoMes")>
			<cfset LvarCPCanoMes = form.CPCanoMes>
			<cfset LvarAno = mid(LvarCPCanoMes,1,4)>
			<cfset LvarMes = mid(LvarCPCanoMes,5,2)>
		</cfif>
		
		<!--- 
			Generales:
				Formato:	
					NOMBRE_REPORTE¦LINEAS_X_PAGINA¦FONT_FAMILY>
		
			Styles: 
				Formato:	
					NOMBRE·SIZEpx·FONT-WEIGHT·PADDING-LEFTpx·PROPIEDAD·VALOR...¦...
		
			Headers[i] y Footers[i]:
				Formato:
					TITULO·CLASE·ESTILO

			Cortes[i]: 
				Formato:	
					TIPO·VALOR¦...
				Corte[1]=Tipos:
					1=Corte por Nivel de Cuenta Presupuesto, VALOR=Nivel de cuenta (PCDCniv) o 'U' para ultimo nivel
					2=Corte por Clasificacion, VALOR=Codigo Clasificacion (PCCEcodigo)
					3=Corte por Mes, VALOR: V=Vertical H=Horizontal
					4=Corte por Oficina, VALOR=N/A
					5=Catalogo de Plan de Cuentas, VALOR=N/A
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
					7=Dato Acumulado en un rango de mes del periodo escogido
					8=Dato Acumulado en un rango de mes del periodo 1 año atrás al escogido
				Dato[2]=TITULO: equivale al nombre que se imprime en el encabezado de columnas
				Dato[3]=EXPRESION: es una formula donde se pueden utilizar los siguientes campos:
					1. 	Si la expresion inicia con *, indica que es una formula que involucra 
						únicamente datos o columnas impresos en el reporte, y que se llaman [C1] [C2] etc.
						Se pueden usar MACROS pero utilizados en el reporte (se sustituyen automáticamente por [C1] [C2])
					2. 	Si la expresion inicia con %, es una formula pero porcentual: Se multiplica por 100, se añade % y se 
						calcula la formula en los totales (no sumariza).
					3.	Columnas del reporte (sin * ni %), es una formula que involucra
						saldos de control de presupuesto, y los datos a utilizar son las siguientes MACROS:
							[A] =	Aprobación Presupuesto Ordinario
							[M] =	Modificación Presupuesto Extraordinario
							[*PF]=	PRESUPUESTO FORMULADO = [A]+[M]
							[T] =	Traslados de Presupuesto Internos
							[TE] =	Traslados con Autorización Externa
							[VC]=	Variacion Cambiaria por modificacion en el Tipo de Cambio Proyectado
							[*PP]=	PRESUPUESTO PLANEADO = [*PF]+[T]+[TE]+[VC]
							[ME]=	Modificación por Excesos Autorizados
							[*PA]=	PRESUPUESTO AUTORIZADO = [*PP]+[ME]
							[RA]=	Reservas Periodo Anterior
							[RC]=	Reservas Consumo
							[*RT]=	TOTAL RESERVAS = [RA] + [RC]
							[CA]=	Compromisos Periodo Anterior
							[CC]=	Compromisos Consumo
							[*CT]=	TOTAL COMPROMISOS = [CA] + [CC]
							[ET] =	Ejecutado Total [E]+[E2]
							[E]  =	Ejecutado Contable
							[E2] =	Ejecutado No Contable
							[E3] =	Devengado o Ejecutado No Pagado
							[*PCA]=	PRESUPUESTO CONSUMIDO DESDE AUXILIARES Y CONTABILIDAD = [*RT]+[*CT]+[E]+[E2]
							[RP]=	Provisiones Presupuestarias
							[*PC]=	PRESUPUESTO CONSUMIDO TOTAL = [*PCA]+[RP]
							[NP]=	NRPs aprobados pero Pendientes de Aplicar (valores Negativos)
							[*DN]=	DISPONIBLE NETO = [*PA] - [*PC] + [NP]

							Si Parametros.Pvalor(Pcodigo=1140) = 'S'
								[EJ]  = Ejercido Total = Devengado y Ejercido (pagado o no)
								[EJ3] = Ejercido no pagado = Ejercido - Pagado
								[P]   = Pagado
							sino
								[P]  = Pagado
			Filtros[i]:
				Formato:
					TIPO·NIVEL_CORTE_O_DATO·VALOR·SUBTIPO·OBLIGATORIO¦...
				Filtro[1]=Tipos:
					0=Filtro fijo
					1=Cuenta, NIVEL=N/A, VALOR=N/A
					2=Clasificacion, NIVEL_CORTE por Clasificacion a filtrar, VALOR=Codigo Clasificacion (PCCEcodigo)
					3=Mes Presupuesto (CPCano CPCmes), NIVEL_CORTE: corte por fecha a filtrar (0=No hay corte por fecha)
					4=Nivel de Cuenta, NIVEL_CORTE=Corte por cuenta a sustituir, VALOR=Niveles a mostar (defaults=U,1,2)
					5=Niveles de Corte, NIVEL=N/A, VALOR=N/A
					6=Tipo de Dato, NIVEL=NIVEL_DATO al que sustituye, VALOR=Default para combo
					7=Tipo de Cuenta, NIVEL=N/A, VALOR=Tipos a mostar (defaults=G,I,A), CAMPO = form.CPCtipoCta
					8=Filtro por Oficina o Grupo de Oficinas, NIVEL_CORTE=Corte por Oficina a sustituir, VALOR = N/A, CAMPO = form.FOficina
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
		<cfobject type="java" class="java.lang.Character" name="string" action="create">
		<cfquery name="rsReporte" datasource="#session.dsn#">
			Select CPRcodigo, CPRnombre, CPRdescripcion, CPRdefinicion, CPRlineasPagina, CPRtipoPagina
			  from CPReportes
			 where CPRid = #form.CPRid#
		</cfquery>
		<cfquery name="rsEmpresa" datasource="#session.dsn#">
			Select e.Edescripcion, m.Miso4217, m.Mnombre
			  from Empresas e
			  	inner join Monedas m
					 on m.Mcodigo = e.Mcodigo
			 where e.Ecodigo = #session.Ecodigo#
		</cfquery>
		
		<cf_htmlReportsHeaders 
			title="#rsReporte.CPRnombre#" 
			bodytag="style=""size:portrait; page:'letter';""" 
			filename="rptSaldos.xls"
			irA="rptSaldos.cfm" 
			>

		<cfif isdefined("form.chkNoCortes")>
			<cfset GvarLineasPagina = 0>
		<cfelseif isdefined("form.CPRlineasPagina") and form.CPRlineasPagina NEQ "" and isnumeric(form.CPRlineasPagina) and form.CPRlineasPagina GT 20 and val(form.CPRlineasPagina) NEQ val(rsReporte.CPRlineasPagina)>
			<cfset GvarLineasPagina = form.CPRlineasPagina>
			<cfif val(form.CPRlineasPagina) LTE 100>
				<cfquery datasource="#session.dsn#">
					update CPReportes
					   set CPRlineasPagina = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CPRlineasPagina#">
					 where CPRid = #form.CPRid#
				</cfquery>
			</cfif>
		<cfelseif rsReporte.CPRlineasPagina EQ "" or not isnumeric(rsReporte.CPRlineasPagina) or rsReporte.CPRlineasPagina LTE 20>
			<cfset GvarLineasPagina = 60>
			<cfquery datasource="#session.dsn#">
				update CPReportes
				   set CPRlineasPagina = 60
				 where CPRid = #form.CPRid#
			</cfquery>
		<cfelse>
			<cfset GvarLineasPagina = rsReporte.CPRlineasPagina>
		</cfif>
		
		<cfset GvarTipoPagina 	= rsReporte.CPRtipoPagina>
		<cfset LvarDefinicion 	= 	fnDefinicion(rsReporte.CPRdefinicion, GvarLineasPagina)>
		
		<cfset rsQuery = fnGeneraQuery()>
		<cfset LvarTotales = arrayNew(2)>
		<cfset LvarTotalesMeses = arrayNew(1)>

		<cfif isdefined("btnDownload")>
			<cfset form.chkNoCortes = "1">
			<cfset LvarRptDef.DecFmt="0.00">
		</cfif>
	<cfoutput>
	<cfset sbGeneraEstilos()>
	<cfif LvarDebug>
		<cfset Lvar_ctasClaTmp = Replace(LvarSQL_ctasClaTmp,"|"," ","ALL")>

<!--
		<cfif LvarSybase>
create table #ctasOfiTmp# (CPcuenta numeric, Ocodigo integer, Ecodigo integer)
create table #mesesTmp# (Ecodigo integer, CPPid numeric, CPCano integer, CPCmes integer, CPCanoMes integer)
		</cfif>
#PreserveSingleQuotes(LvarSQL_ctasOfiTmp)#
#PreserveSingleQuotes(Lvar_ctasClaTmp)#  
#PreserveSingleQuotes(LvarSQL_mesesTmp)#
#PreserveSingleQuotes(LvarSQL)#
-->
	</cfif>
	</cfoutput>

	<cfprocessingdirective suppresswhitespace="yes">
	
	<cfflush interval="32">

	<cfset sbInicioPagina()>
	<cfset sbCorteInicio(0)>
	<cfset LvarControlCorteVal = arraynew(1)>
	<cfset LvarControlCorteDes = arraynew(1)>
	<cfset LvarControlCorteExe = arraynew(1)>
	<cfset temp = arrayset(LvarControlCorteVal, 1, LvarRptDef.CortesN, -1)>
	<cfset temp = arrayset(LvarControlCorteExe, 1, LvarRptDef.CortesN, false)>
	<cfset temp = arrayset(LvarControlCorteDes, 1, LvarRptDef.CortesN, "")>
	<cfoutput query="rsQuery">
		<cfif isdefined("session.rptSaldos_Cancel")>
			<cfset structDelete(session, "rptSaldos_Cancel")>
			<cf_errorCode	code = "50509" msg = "Reporte Cancelado por el Usuario">
		</cfif>

		<cfset sbCorteControl()>

		<cfloop index="i" from="1" to="#LvarRptDef.DatosN#">
			<cfsilent>
				<cfset LvarDato = listGetAt(LvarRptDef.Datos[i],3,"·")>
				
				<!---Sustituye los Totales [Tx] por el valor total del Penúltimo nivel del dato x --->
				<cfset LvarPto1 = find("[T",LvarDato)>
				<cfloop condition="LvarPto1 GT 0">
					<cfset LvarPto2 = find("]",LvarDato, LvarPto1)>
					<cfset LvarDato = mid(LvarDato,1,LvarPto1-1) & LvarTotales[LvarRptDef.CortesN-1][mid(LvarDato,LvarPto1 + 2,LvarPto2-LvarPto1-2)] & mid(LvarDato,LvarPto2+1,4096)>
					<cfset LvarPto1 = find("[T",LvarDato)>
				</cfloop>
				
				<cfif mid(LvarDato,1,1) EQ "*">
					<cftry>
						<cfset LvarDato = replace(LvarDato,"--","- -","ALL")>
						<cfset LvarValor = evaluate(mid(LvarDato,2,100))>
					<cfcatch type="any">
					<cfthrow message="Dato#i#=#LvarDato#">
						<cfset LvarValor = 0>
					</cfcatch>
					</cftry>
				<cfelseif mid(LvarDato,1,1) EQ "%">
					<cftry>
						<cfset LvarDato = replace(LvarDato,"--","- -","ALL")>
						<cfset LvarValor = evaluate(mid(LvarDato,2,100))>
					<cfcatch type="expression">
						<cfset LvarValor = 0>
					</cfcatch>
					</cftry>
				<cfelse>
					<cfset LvarValor = evaluate("Dato#i#")>
				</cfif>
			</cfsilent>
			<cfif LvarMesesHorizontales>
				<cfsilent>
					<cfloop index="c" from="1" to="#LvarRptDef.CortesN - 1#">
						<cfset LvarMesI = evaluate("Corte#LvarRptDef.CortesN#")>
						<cfif i EQ 1>
							<!--- El Valor del Dato=1 es el mensual y hay que acumular todo --->
							<cfset LvarTotales[c][1] = LvarTotales[c][1] + LvarValor>
							<cfset LvarTotalesMeses[c]["#LvarMesI#"] = LvarTotalesMeses[c]["#LvarMesI#"] + LvarValor>
						<cfelse>
							<!--- Para los demas valores solo hay que acumular 1 por linea --->
							<cfif c EQ LvarRptDef.CortesN - 1> 
								<!--- El penúltimo corte es la línea por eso no hay que acumular --->
								<cfset LvarTotales[c][i] = LvarValor>
							<cfelseif LvarMesI EQ LvarUltimoMes>
								<!--- 
									En los demas cortes, acumular una sola vez por linea, 
									pero se debe utilizar el último mes, porque el LvarTotales[x][1] 
									se va acumulando cada mes, y el total esta en el ultimo mes 
								--->
								<cfset LvarTotales[c][i] = LvarTotales[c][i] + LvarValor>
							</cfif>
						</cfif>
					</cfloop>
					<cfif i EQ 1 OR LvarMesI EQ LvarUltimoMes>
						<cfset LvarTotales[11][i] = LvarTotales[11][i] + LvarValor>
					</cfif>
				</cfsilent>
				<cfif i EQ 1>
					<cfset LvarTotalesMeses[11]["#LvarMesI#"] = LvarTotalesMeses[11]["#LvarMesI#"] + LvarValor>
					<cfif mid(listGetAt(LvarRptDef.Datos[i],3,"·"),1,1) EQ "%">
						<td class="Datos">#LSnumberFormat(LvarValor*100,"0.00")#%</td>
					<cfelse>
						<!---<td class="Datos" x:num>#LSnumberFormat(LvarValor, LvarRptDef.DecFmt)#</td>--->
                        <td class="Datos" x:num>#LSnumberFormat(LvarValor,'9.00')#</td>
					</cfif>
				</cfif>
			<cfelse>
				<cfsilent>
					<cfloop index="c" from="1" to="#LvarRptDef.CortesN - 1#">
						<cfset LvarTotales[c][i] = LvarTotales[c][i] + LvarValor>
						<cfif LvarMesesHorizontales AND i EQ 1>
							<cfset LvarMesI = evaluate("Corte#LvarRptDef.CortesN#")>
							<cfset LvarTotalesMeses[c]["#LvarMesI#"] = LvarTotalesMeses[c]["#LvarMesI#"] + LvarValor>
						</cfif>
					</cfloop>
					<cfset LvarTotales[11][i] = LvarTotales[11][i] + LvarValor>
				</cfsilent>
				<cfif mid(listGetAt(LvarRptDef.Datos[i],3,"·"),1,1) EQ "%">
					<td class="Datos">#LSnumberFormat(LvarValor*100,"0.00")#%</td>
				<cfelse>
					<!---<td class="Datos" x:num>#LSnumberFormat(LvarValor, LvarRptDef.DecFmt)#</td>--->
                    <td class="Datos" x:num>#LSnumberFormat(LvarValor,'9.00')#</td>
				</cfif>
			</cfif>
		</cfloop>
		<cfif NOT LvarMesesHorizontales></tr></cfif>
	</cfoutput>

	<cfoutput>
	<cfloop index="i" from="#LvarRptDef.CortesN#" to="1" step="-1">
		<cfif LvarControlCorteExe[i]>
			<cfset sbCorteTotal(i)>
		</cfif>
	</cfloop>
	<cfset sbCorteTotal(0)>
	<cfif LvarLineas + LvarRptDef.FinalesN GT LvarRptDef.LineasPag>
		<cfset LvarLineas = LvarRptDef.LineasPag+1>
		<cfset sbCortePagina(0)>
	</cfif>
	</table>
	<BR>
	<cfset sbHeadersAndFooters (LvarRptDef.Finales,"Final")>
	<cfif GvarLineasPagina NEQ 0>
		<cfloop index="i" from="#LvarLineas#" to="#LvarRptDef.LineasPag#">
			<br style="Datos">
		</cfloop>
	</cfif>
	<cfset sbFinPagina()>
		</body>
		</html>
	</cfoutput>

	</cfprocessingdirective>
	</cflock>

<cfcatch type="lock">
	<cfoutput>
	<script language="javascript">
		alert('Ya existe un reporte en ejecución, debe esperar a que termine su procesamiento');
		location.href = "rptSaldos.cfm?CPRid=#form.CPRid#";
	</script>
	</cfoutput>
</cfcatch>

<cfcatch type="any">
	<cfrethrow>
</cfcatch>
</cftry>
	
<cffunction name="sbGeneraEstilos" output="true">
<style type="text/css">
<!--
	<cfset LvarStyleDatos = 0>
	<cfset LvarLstStyles = "">
	<cfloop index="i" from="1" to="#LvarRptDef.SytlesN#">
		<cfset LvarStyle = listToArray(LvarRptDef.Sytles[i],"·")>
		<cfif LvarStyle[1] EQ "Datos">
			<cfset LvarStyleDatos = i>
		<cfelseif mid(LvarStyle[1],1,5) EQ "Corte">
			<cfif LvarStyleDatos EQ 0>
				<cfset LvarStyleDatos = i>
			</cfif>
			<cfset LvarLstStyles &= "#LvarStyle[1]#,">
			<cfset sbGeneraEstilo(LvarStyle)>
		<cfelse>
			<cfset sbGeneraEstilo(LvarStyle)>
		</cfif>
	</cfloop>
	<cfset LvarStyle = listToArray(LvarRptDef.Sytles[LvarStyleDatos],"·")>
	<cfset LvarStyle[1] = "Datos">
	<cfset sbGeneraEstilo(LvarStyle)>
	body
	{
		font-family:	#LvarRptDef.FontFamily#;
		font-size: 		#LvarStyle[2]#px;
	}
-->
</style>

</cffunction>

<cffunction name="fnIdentCorte" output="false" returntype="numeric">
	<cfargument name="Niv" type="numeric">
	
	<cfreturn (Arguments.Niv-1)*10>
</cffunction>

<cffunction name="fnClassCorte" output="false" returntype="string">
	<cfargument name="Corte" type="string">
	
	<cfif listFind(LvarLstStyles,Arguments.Corte)>
		<cfreturn 'class="#Arguments.Corte#"'>
	<cfelse>
		<cfreturn 'class="Datos" style="text-align:left;padding-left:#fnIdentCorte(mid(Arguments.Corte,6,10))#px;"'>
	</cfif>
</cffunction>

<cffunction name="sbGeneraEstilo" output="true">
	<cfargument name="LvarStyle" type="array">

	.#LvarStyle[1]# 
	{
		font-family:	#LvarRptDef.FontFamily#;
		font-size: 		#LvarStyle[2]#px;
		font-weight: 	#LvarStyle[3]#;
	<cfif LvarStyle[1] NEQ "Datos">
		<cfif left(LvarStyle[1],5) EQ "Corte">
			padding-left: 	#fnIdentCorte(mid(LvarStyle[1],6,10))#px;
		<cfelse>
			padding-left: 	#LvarStyle[4]#px;
		</cfif>
		<cfif LvarStyle[1] EQ "ColHeader">
			border:		1px solid ##CCCCCC;
		</cfif>
	<cfelse>
		text-align:right;
		white-space:nowrap;
		mso-number-format:"\##\,\##\##0\.00";
	</cfif>
	<cfloop index="s" from="5" to="#arrayLen(LvarStyle)#" step="2">
		#LvarStyle[s]#:	#LvarStyle[s+1]#;
	</cfloop>
	}
</cffunction>

<cffunction name="sbCortePagina" output="true">
	<cfargument name="Nivel" type="numeric" required="yes">
	<cfif Arguments.Nivel LT LvarRptDef.CortesN AND LvarLineas GTE LvarRptDef.LineasPag OR LvarLineas GT LvarRptDef.LineasPag-1>
		<cfoutput>
		<cfset sbFinPagina()>
		<BR style="page-break-after:always;">
		<cfset sbInicioPagina()>
		</cfoutput>
	</cfif>
	<cfset LvarLineas = LvarLineas + 1>
</cffunction>

<cffunction name="sbInicioPagina" output="true">
	<cfset LvarLineas = 0>
	<cfoutput>
	<cfset sbHeadersAndFooters (LvarRptDef.Headers,"Header")>
	<cfset LvarLineas = LvarLineas + 3>
	<BR>
	<table width="100%" cellpadding="1" cellspacing="0" style="border-collapse:collapse">
		<tr>
		<td class="ColHeader" rowspan="2" width="10%">#LvarRptDef.Campos[1]#</td>
		<td class="ColHeader" rowspan="2" width="15%">#LvarRptDef.Campos[2]#</td>
			<cfset LvarTipo = mid(LvarRptDef.Datos[1],1,1)>
			<cfif LvarMesesHorizontales>
				<cfset sbColocaEncabezadoTemporal(LvarTipo,rsMeses.recordCount+1)>
				<cfset LvarDatosIni = 2>
			<cfelse>
				<cfset LvarDatosIni = 1>
			</cfif>
			<cfif LvarRptDef.DatosN GTE LvarDatosIni>
				<cfset LvarTipo = mid(LvarRptDef.Datos[LvarDatosIni],1,1)>
				<cfset LvarTipoN = 0>
				<cfloop index="i" from="#LvarDatosIni#" to="#LvarRptDef.DatosN#">
					<cfset LarrDato = listToArray(LvarRptDef.Datos[i],"·")>
					<cfif LvarTipo NEQ LarrDato[1]>
						<cfset sbColocaEncabezadoTemporal(LvarTipo,LvarTipoN)>
						<cfset LvarTipo = LarrDato[1]>
						<cfset LvarTipoN = 0>
					</cfif>
					<cfset LvarTipoN = LvarTipoN+1>
				</cfloop>
				<cfset sbColocaEncabezadoTemporal(LvarTipo,LvarTipoN)>
			</cfif>
		</tr>
		<tr>
		<cfif LvarMesesHorizontales>
			<cfset LvarPrimerMes = rsMeses.MesI>
			<cfloop query="rsMeses">
		<td class="ColHeader" align="right" nowrap>#rsMeses.Mes#</td>
			<cfset LvarUltimoMes = rsMeses.MesI>
			</cfloop>
		<td class="ColHeader" style="font-weight:bold;width:50px" align="right">#ucase(LvarRptDef.Campos[3])#</td>
		</cfif>
			<cfloop index="i" from="#LvarDatosIni+2#" to="#LvarRptDef.CamposN#">
		<td class="ColHeader" align="right" style="width:50px">#LvarRptDef.Campos[i]#</td>
			</cfloop>
		<td style="border-left:1px solid ##0" ></td>
		</tr>
		</cfoutput>
</cffunction>

<cffunction name="sbColocaEncabezadoTemporal" output="true">
	<cfargument name="Tipo"		type="string" required="yes">
	<cfargument name="ColsN"	type="numeric" required="yes">
		<td class="ColHeader" align="center" colspan="#Arguments.ColsN#">
				<cfif Arguments.Tipo EQ "1">
					MENSUAL
				<cfelseif Arguments.Tipo EQ "2">
					ACUMULADO
				<cfelseif Arguments.Tipo EQ "3">
					TOTAL
				<cfelseif Arguments.Tipo EQ "4">
					MENSUAL<BR>AÑO ANTERIOR
				<cfelseif Arguments.Tipo EQ "5">
					ACUMULADO<BR>AÑO ANTERIOR
				<cfelseif Arguments.Tipo EQ "6">
					TOTAL<BR>AÑO ANTERIOR
				<cfelseif Arguments.Tipo EQ "7">
					RANGO
				<cfelseif Arguments.Tipo EQ "8">
					RANGO<BR>AÑO ANTERIOR
				</cfif>
				</td>
</cffunction>

<cffunction name="sbFinPagina" output="true">
	<cfoutput>
	</table>
	<BR>
	<cfset sbHeadersAndFooters (LvarRptDef.Footers, "Footer")>
	</cfoutput>
	<cfset LvarPagina = LvarPagina + 1>
	<cfif LvarPagina EQ 1000+1><cfoutput><font style="font-size:14px">El reporte tiene mas de #LvarPagina-1# páginas...</font></cfoutput><cfabort></cfif>
</cffunction>

<cffunction name="sbHeadersAndFooters" output="true">
	<cfargument name="Lineas" type="array">
	<cfargument name="Tipo" type="string">
	<cfset var i = 0>

	<cfloop index="i" from="1" to="#arrayLen(Arguments.Lineas)#">
		<cfif Arguments.Tipo NEQ "Footer">
			<cfset sbCortePagina(0)>
		</cfif>
		<div style="width:100%; margin:none;" class="#Arguments.Tipo#">
 			<DIV class="#Arguments.Tipo##i#">
 				#Arguments.Lineas[i]#
			</DIV>
		</div>
	</cfloop>
</cffunction>

<cffunction name="sbCorteControl" output="true" returntype="any">
	<cfset var valor="">
	<cfset var xc = 0>
	<cfset var i = 0>

	<cfloop index="xc" from="1" to="#LvarRptDef.CortesN#">
		<cfset valor = evaluate("rsQuery.corte#xc#")>
		<cfif compare(valor , LvarControlCorteVal[xc]) NEQ 0>
			<cfloop index="i" from="#LvarRptDef.CortesN#" to="#xc#" step="-1">
				<cfif LvarControlCorteExe[i]>
					<cfset sbCorteTotal (i)>
					<cfset LvarControlCorteVal[i] = chr(255)>
				</cfif>
			</cfloop>
			<cfset sbCorteInicio(xc)>

			<cfset LvarControlCorteVal[xc] = valor>
			<cfset LvarControlCorteDes[xc] = evaluate("rsQuery.corte#xc#d")>
			<cfset LvarControlCorteExe[xc] = true>
			<cfif xc LT LvarRptDef.CortesN>
				<cfset arrayset(LvarControlCorteExe, xc + 1, LvarRptDef.CortesN, false)>
			</cfif>
		</cfif>
	</cfloop>
</cffunction>

<cffunction name="sbCorteInicio" output="true">
	<cfargument name="Nivel" type="numeric" required="yes">
	
	<cfset LvarCorte = "Corte#Arguments.Nivel#">
	<cfset LvarPonerTitulo	= NOT (Arguments.Nivel EQ LvarRptDef.CortesN AND LvarMesesHorizontales)>
	<cfset LvarBrincarLinea	= (Arguments.Nivel LT LvarRptDef.CortesN AND NOT LvarMesesHorizontales)
						   OR (Arguments.Nivel LT LvarRptDef.CortesN-1 AND LvarMesesHorizontales)>

	<cfif Arguments.Nivel GT LvarRptDef.CortesN>
		<cfreturn>
	<cfelseif Arguments.Nivel EQ 0>
		<cfset Arguments.Nivel = 11>
	<cfelseif LvarPonerTitulo>
		<cfset sbCortePagina(Arguments.Nivel)>
	</cfif>

	<cfloop index="i" from="1" to="#LvarRptDef.DatosN#">
		<cfset LvarTotales[Arguments.Nivel][i] = 0>
	</cfloop>
	<cfif LvarMesesHorizontales>
		<cfloop query="rsMeses">
			<cfset LvarTotalesMeses[Arguments.Nivel]["#rsMeses.MesI#"] = 0>
		</cfloop>
	</cfif>
	<cfif Arguments.Nivel EQ 11>
		<cfreturn>
	</cfif>
	
	<cfif LvarPonerTitulo>
		<cfoutput>
	<tr>
		<td #fnClassCorte(LvarCorte)# nowrap x:str>
			#evaluate(LvarCorte)#
		</td>
		</cfoutput>
			<cfset LvarDescripcion = evaluate(LvarCorte & "d")>
			<cfif Nivel EQ LvarRptDef.CortesN AND listGetAt(LvarRptDef.Cortes[Arguments.Nivel],1,"·") NEQ "1">
				<cfset LvarPto = Find(":",LvarDescripcion)>
				<cfif LvarPto GT 0>
					<cfset LvarDescripcion = mid(LvarDescripcion,LvarPto+2,100)>
				</cfif>
			</cfif>
		<cfoutput>
		<td <cfif LvarBrincarLinea>colspan="#LvarRptDef.CamposN#"<cfelse>nowrap</cfif> #fnClassCorte(LvarCorte)#>
			#LvarDescripcion#
		</td>
		</cfoutput>
	</cfif>
	<cfif LvarBrincarLinea>
		<cfoutput>
	</tr>
		</cfoutput>
	</cfif>
</cffunction>

<cffunction name="sbCorteTotal" output="true">
	<cfargument name="Nivel" type="numeric" required="yes">

	<cfset LvarCorte = "Corte#Arguments.Nivel#">
	<cfset LvarPonerTitulo	= NOT (Arguments.Nivel EQ LvarRptDef.CortesN-1 AND LvarMesesHorizontales)>

	<cfif Arguments.Nivel GTE LvarRptDef.CortesN>
		<cfreturn>
	</cfif>

	<cfif LvarPonerTitulo>
		<cfset sbCortePagina(0)>
		<cfoutput>
	<tr>
		<cfif Arguments.Nivel EQ 0>
		<td colspan="2" class="Corte1">
			<cfset Arguments.Nivel = 11>
			TOTALES GENERALES
		<cfelse>
		<td colspan="2" #fnClassCorte(LvarCorte)#>
			<!--- #repeatString("&nbsp;",(Nivel-1)*4)# --->
			Total #LvarControlCorteDes[Arguments.Nivel]#
		</td>
		</cfif>
		</cfoutput>
	</cfif>		
		
	<cfif LvarMesesHorizontales AND (Arguments.Nivel LT LvarRptDef.CortesN-1 OR Arguments.Nivel EQ 11)>
		<cfloop query="rsMeses">
			<cfoutput>
		<!---<td class="Datos" x:num><strong>#LSnumberFormat(LvarTotalesMeses[Arguments.Nivel]["#rsMeses.MesI#"], LvarRptDef.DecFmt)#</strong></td>--->
     	<td class="Datos" x:num><strong>#LSnumberFormat(LvarTotalesMeses[Arguments.Nivel]["#rsMeses.MesI#"], "9.00")#</strong></td>
			</cfoutput>
		</cfloop>
	</cfif>
	<cfloop index="i" from="1" to="#LvarRptDef.DatosN#">
		<cfoutput>
			<cfif mid(listGetAt(LvarRptDef.Datos[i],3,"·"),1,1) EQ "%">
				<cfif LvarMesesHorizontales and Arguments.Nivel EQ LvarRptDef.CortesN-1>
		<td class="Datos"><strong>#LSnumberFormat(LvarTotales[Arguments.Nivel][i]*100,"0.00")#%</strong></td>
				<cfelse>
					<cfset LvarDato = listGetAt(LvarRptDef.Datos[i],3,"·")>


					<cfset LvarPto1 = find("[T",LvarDato)>
					<cfloop condition="LvarPto1 GT 0">
						<cfset LvarPto2 = find("]",LvarDato, LvarPto1)>
						<cfset LvarDato = mid(LvarDato,1,LvarPto1-1) & LvarTotales[Arguments.Nivel][mid(LvarDato,LvarPto1 + 2,LvarPto2-LvarPto1-2)] & mid(LvarDato,LvarPto2+1,4096)>

						<cfset LvarPto1 = find("[T",LvarDato)>
					</cfloop>

					<cfset LvarPto1 = find("Dato",LvarDato)>
					<cfloop condition="LvarPto1 GT 0">
						<cfloop index="LvarPto2" from="#LvarPto1+4#" to="#len(LvarDato)#">
							<cfif mid(LvarDato,LvarPto2,1) LT "0" OR mid(LvarDato,LvarPto2,1) GT "9">
								<cfbreak>
							</cfif>
						</cfloop>
						<cfset LvarDato = mid(LvarDato,1,LvarPto1-1) & LvarTotales[Arguments.Nivel][mid(LvarDato,LvarPto1 + 4,LvarPto2-LvarPto1-4)] & mid(LvarDato,LvarPto2,4096)>

						<cfset LvarPto1 = find("Dato",LvarDato)>
					</cfloop>
					<cftry>
						<cfset LvarDato = replace(LvarDato,"--","- -","ALL")>
						<cfset LvarValor = evaluate(mid(LvarDato,2,100))>
					<cfcatch type="expression">
						<cfset LvarValor = 0>
					</cfcatch>
					</cftry>
		<td class="Datos"><strong>#LSnumberFormat(LvarValor*100,"0.00")#%</strong></td>
				</cfif>
			<cfelse>
<!---		<td class="Datos" x:num><strong>#LSnumberFormat(LvarTotales[Arguments.Nivel][i], LvarRptDef.DecFmt)#</strong></td>--->
       		<td class="Datos" x:num><strong>#LSnumberFormat(LvarTotales[Arguments.Nivel][i], '9.00')#</strong></td>
			</cfif>
		</cfoutput>
	</cfloop>
	<cfoutput>
	</tr>
	</cfoutput>
	<cfif Arguments.Nivel EQ 1>
		<cfoutput>
	<tr><td>&nbsp;</td></tr>
		</cfoutput>
		<cfset LvarLineas = LvarLineas + 1>
	</cfif>
</cffunction>

<cffunction name="fnGeneraFiltro" returntype="any" output="false">
	<cfset LvarSQL = "">
	<cfset LvarSQL_ctasOfiTmp = "">
	<cfset LvarSQL_ctasClaTmp = "">
	<cfset LvarSQL_mesesTmp = "">
	<cfif isdefined("LvarRptDef.SqlCfm")>
		<cfinclude template="#LvarRptDef.SqlCfm#">
		<cfreturn rsSQL>
	</cfif>

	<cfset LarrWhere = arrayNew(1)>
	<cfloop index="s" from="1" to="8">
		<cfset LarrWhere[s] = "">
	</cfloop>

	<!--- Revisa que haya Corte por Oficina --->
	<cfset LvarWhereNivel = arraynew(1)>
	<cfset LvarCortePorOficina = "">
 	<cfloop index="i" from="1" to="#LvarRptDef.CortesN#">
		<cfset LvarWhereNivel[i] = "">
		<cfset LarrCorte = listToArray(LvarRptDef.Cortes[i],"·")>
		<cfif LarrCorte[1] EQ "4">
			<cfset LvarCortePorOficina = "and m.Ocodigo	= o.Ocodigo">
		</cfif>
	</cfloop>

	<cfset LvarWhere = "">
	<cfset LvarWhereCP = "">
	<cfset LvarWhereMY = "">
	<cfset LvarWhereOF = "">
	<cfset LvarOraIndexes = "">
	<cfset LvarOraIndexesHints = "">
	<cfset LvarDimensionTemporal = false>
	<cfset LvarFiltroTemporal = false>
	<cfset LvarCorteTemporal = false>
	<cfset LvarFiltroCortes = false>
	<!---
		Procesa **FILTROS**
	--->
	<cfloop index="f" from="1" to="#LvarRptDef.FiltrosN#">
		<cfset LvarFiltro = listToArray(LvarRptDef.Filtros[f],"·")>
		<!--- [1]=TIPO·[2]=NIVEL_CORTE·[3]=VALOR·[4]=SUBTIPO·[5]=OBLIGATORIO·[6]=FILTRO_FIJO --->

		<!--- Filtro Fijo --->
		<cfif LvarFiltro[1] EQ "0">
			<cfif find("my.",LvarFiltro[6]) GT 0>
				<cfset LvarWhereMY = LvarWhereMY & "
						and #LvarFiltro[6]#">
			<cfelseif find("cp.",LvarFiltro[6]) GT 0>
					<cfset LvarWhereCP = LvarWhereCP & "
					and #LvarFiltro[6]#
					">
			<cfelse>
					<cfset LvarWhere = LvarWhere & "
   and #LvarFiltro[6]#
					">
			</cfif>
		<!--- Filtro por Tipo de Cuenta --->
		<cfelseif LvarFiltro[1] EQ "7">
			<cfset LvarValor = evaluate("form.CPCtipoCta")>
			<cfif LvarValor NEQ "">
				<cfset LvarWhereMY = LvarWhereMY & "
						and my.Ctipo = '#LvarValor#'">
			</cfif>
		<!--- Filtro por Oficina o Grupo de Oficinas --->
		<cfelseif LvarFiltro[1] EQ "8">
			<cfset LvarValor = evaluate("form.FOficina")>
			<cfset LvarFOfiTipo	= listFirst(LvarValor)>
			<cfset LvarFOfiId	= listLast(LvarValor)>
			<cfif LvarFOfiTipo EQ "OF">
				<cfset LvarWhereOF = "and m.Ocodigo = #LvarFOfiId#">
			<cfelseif LvarFOfiTipo EQ "GO">
				<cfset LvarWhereOF = "and (select count(1) from AnexoGOficinaDet where GOid = #LvarFOfiId# and Ecodigo = m.Ecodigo and Ocodigo=m.Ocodigo) > 0">
			</cfif>
		<!--- Filtro por Cuenta de Presupuesto --->
		<cfelseif LvarFiltro[1] EQ "1">
			<cfif LvarFiltro[4] EQ "1">
				<cfset LvarValor = evaluate("form.CPformato")>
				<cfif LvarValor NEQ "">
					<cfset LvarCPformato = true>
					<cfset LvarWhereCP = LvarWhereCP & "
					and cp.CPformato	= '#LvarValor#'
					and cp.Ecodigo		= #session.Ecodigo#
					">
				</cfif>
			<cfelseif LvarFiltro[4] EQ "2">
				<cfset LvarValor1 = evaluate("form.CPformato1")>
				<cfset LvarValor2 = evaluate("form.CPformato2")>
				<cfif LvarValor1 NEQ "">
					<cfset LvarCPformato = true>
					<cfif LvarValor2 EQ "">
						<cfset LvarWhereCP = LvarWhereCP & "
					and cp.CPformato	= '#LvarValor1#'
					and cp.Ecodigo		= #session.Ecodigo#
						">
					<cfelse>
						<cfset LvarWhereCP = LvarWhereCP & "
					and cp.CPformato	>= '#LvarValor1#'
					and cp.CPformato	<= '#LvarValor2 & chr(255)#'
					and cp.Ecodigo		= #session.Ecodigo#
						">
					</cfif>
				</cfif>
			</cfif>
		<!--- Filtro por Clasificacion de Catalogos de Plan --->
		<cfelseif LvarFiltro[1] EQ "2">
			<cfif ArrayLen(LvarWhereNivel) LT LvarFiltro[2]>
				<cfset LvarWhereNivel[LvarFiltro[2]] = "">
			</cfif>
			<cfif isdefined("LvarNuevoOrdenCortes")>
				<cfset LvarFormIdx = LvarNuevoOrdenCortes[LvarFiltro[2]].Idx>
			<cfelse>
				<cfset LvarFormIdx = LvarFiltro[2]>
			</cfif>
			<cfif LvarFiltro[4] EQ "1">
				<cfparam name="form.PCCDvalor_#LvarFormIdx#" default="">
				<cfset LvarValor = evaluate("form.PCCDvalor_#LvarFormIdx#")>
				<cfif LvarValor NEQ "">
					<cfset LvarWhereNivel[LvarFiltro[2]] = LvarWhereNivel[LvarFiltro[2]] & "
								and pccd#LvarFiltro[2]#.PCCDvalor = '#LvarValor#'
					">
				</cfif>
			<cfelseif LvarFiltro[4] EQ "2">
				<cfset LvarValor1 = evaluate("form.PCCDvalor1_#LvarFormIdx#")>
				<cfset LvarValor2 = evaluate("form.PCCDvalor2_#LvarFormIdx#")>
				<cfif LvarValor1 NEQ "">
					<cfif LvarValor2 EQ "">
						<cfset LvarWhereNivel[LvarFiltro[2]] = LvarWhereNivel[LvarFiltro[2]] & "
								and pccd#LvarFiltro[2]#.PCCDvalor = '#LvarValor1#'
						">
					<cfelse>
						<cfset LvarWhereNivel[LvarFiltro[2]] = LvarWhereNivel[LvarFiltro[2]] & "
								and pccd#LvarFiltro[2]#.PCCDvalor >= '#LvarValor1#'
								and pccd#LvarFiltro[2]#.PCCDvalor <= '#LvarValor2#'
						">
					</cfif>
				</cfif>
			</cfif>
		<!--- Filtro por Fecha (dimension temporal) --->
		<cfelseif LvarFiltro[1] EQ "3">
			<cfif LvarFiltroTemporal>
				<cf_errorCode	code = "50526" msg = "Hay mas de un Filtro por Fecha">
			</cfif>
			<cfif LvarFiltro[2] EQ 0>
				<!--- Sin Corte por fecha --->
				<cfif LvarFiltro[4] EQ "1" OR LvarFiltro[4] EQ "3">
					<cfset LvarDimensionTemporal = true>
					<cfset LvarFiltroTemporal = true>
					<cfset LvarCPCano = mid(LvarCPCanoMes,1,4)>
					<cfset LvarCPCmes = mid(LvarCPCanoMes,5,2)>
					<cfset LarrWhere[1] = LarrWhere[1] & "
						 where m.Ecodigo	= cps.Ecodigo
						   and m.Ocodigo	= cps.Ocodigo
						   and m.CPPid		= #form.CPPid#
						   and m.CPcuenta	= cps.CPcuenta
						   and m.CPCanoMes	= #LvarCPCanoMes#
					">
					<cfset LarrWhere[2] = LarrWhere[2] & "
						 where m.Ecodigo	= cps.Ecodigo
						   and m.CPPid		= #form.CPPid#
						   and m.CPcuenta	= cps.CPcuenta
						   and m.CPCanoMes	<= #LvarCPCanoMes#
						   and m.Ocodigo	= cps.Ocodigo
					">
					<cfset LarrWhere[3] = LarrWhere[3] & "
						 where m.Ecodigo	= cps.Ecodigo
						   and m.CPPid		= #form.CPPid#
						   and m.CPcuenta	= cps.CPcuenta
						   and m.Ocodigo	= cps.Ocodigo
					">
					<cfset LvarAnoMesAnterior = (LvarCPCano-1)*100+LvarCPCMes>
					<cfquery name="rsPeriodoAnterior" datasource="#session.dsn#">
						select CPPid
						  from CPresupuestoPeriodo p
						 where p.Ecodigo	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						   and #LvarAnoMesAnterior# >= CPPanoMesDesde
						   and #LvarAnoMesAnterior# <= CPPanoMesHasta
					</cfquery>
					<cfif rsPeriodoAnterior.recordCount eq 0>
						<cfset LvarCPPidAnterior = -1>
					<cfelse>
						<cfset LvarCPPidAnterior = rsPeriodoAnterior.CPPid>
					</cfif>
					<cfset LarrWhere[4] = LarrWhere[4] & "
						 where m.Ecodigo	= cps.Ecodigo
						   and m.CPPid		= #LvarCPPidAnterior#
						   and m.CPcuenta	= cps.CPcuenta
						   and m.CPCanoMes 	= #LvarAnoMesAnterior#
						   and m.Ocodigo	= cps.Ocodigo
					">
					<cfset LarrWhere[5] = LarrWhere[5] & "
						 where m.Ecodigo	= cps.Ecodigo
						   and m.CPPid		= #LvarCPPidAnterior#
						   and m.CPcuenta	= cps.CPcuenta
						   and m.CPCanoMes	<= #LvarAnoMesAnterior#
						   and m.Ocodigo	= cps.Ocodigo
					">
					<cfset LarrWhere[6] = LarrWhere[6] & "
						 where m.Ecodigo	= cps.Ecodigo
						   and m.CPPid		= #LvarCPPidAnterior#
						   and m.CPcuenta	= cps.CPcuenta
						   and m.Ocodigo	= cps.Ocodigo
					">
				<cfelseif LvarFiltro[4] EQ "2">
					<cfset LvarDimensionTemporal = true>
					<cfset LvarFiltroTemporal = true>
					<cfset LvarCPCano1 = mid(LvarCPCanoMes1,1,4)>
					<cfset LvarCPCmes1 = mid(LvarCPCanoMes1,5,2)>
					<cfset LvarCPCano2 = mid(LvarCPCanoMes2,1,4)>
					<cfset LvarCPCmes2 = mid(LvarCPCanoMes2,5,2)>
					<cfset LarrWhere[1] = LarrWhere[1] & "
						 where m.Ecodigo	= cps.Ecodigo
						   and m.Ocodigo	= cps.Ocodigo
						   and m.CPPid		= #form.CPPid#
						   and m.CPcuenta	= cps.CPcuenta
						   and m.CPCanoMes	= #LvarCPCanoMes2#
					">
					<cfset LarrWhere[2] = LarrWhere[2] & "
						 where m.Ecodigo	= cps.Ecodigo
						   and m.CPPid		= #form.CPPid#
						   and m.CPcuenta	= cps.CPcuenta
						   and m.CPCanoMes	<= #LvarCPCanoMes2#
						   and m.Ocodigo	= cps.Ocodigo
					">
					<cfset LarrWhere[3] = LarrWhere[3] & "
						 where m.Ecodigo	= cps.Ecodigo
						   and m.CPPid		= #form.CPPid#
						   and m.CPcuenta	= cps.CPcuenta
						   and m.Ocodigo	= cps.Ocodigo
					">
					<cfset LarrWhere[7] = LarrWhere[7] & "
						 where m.Ecodigo	= cps.Ecodigo
						   and m.CPPid		= #form.CPPid#
						   and m.CPcuenta	= cps.CPcuenta
						   and m.CPCanoMes	>= #LvarCPCanoMes1#
						   and m.CPCanoMes	<= #LvarCPCanoMes2#
						   and m.Ocodigo	= cps.Ocodigo
					">
					<cfset LvarAnoMesAnterior1 = (LvarCPCano1-1)*100+LvarCPCMes1>
					<cfset LvarAnoMesAnterior2 = (LvarCPCano2-1)*100+LvarCPCMes2>
					<cfquery name="rsPeriodoAnterior" datasource="#session.dsn#">
						select CPPid
						  from CPresupuestoPeriodo p
						 where p.Ecodigo	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						   and #LvarAnoMesAnterior1# >= CPPanoMesDesde
						   and #LvarAnoMesAnterior1# <= CPPanoMesHasta
					</cfquery>
					<cfif rsPeriodoAnterior.recordCount eq 0>
						<cfset LvarCPPidAnterior = -1>
					<cfelse>
						<cfset LvarCPPidAnterior = rsPeriodoAnterior.CPPid>
					</cfif>
					<cfset LarrWhere[4] = LarrWhere[4] & "
						 where m.Ecodigo	= cps.Ecodigo
						   and m.CPPid		= #LvarCPPidAnterior#
						   and m.CPcuenta	= cps.CPcuenta
						   and m.CPCanoMes 	= #LvarAnoMesAnterior2#
						   and m.Ocodigo	= cps.Ocodigo
					">
					<cfset LarrWhere[5] = LarrWhere[5] & "
						 where m.Ecodigo	= cps.Ecodigo
						   and m.CPPid		= #LvarCPPidAnterior#
						   and m.CPcuenta	= cps.CPcuenta
						   and m.CPCanoMes	<= #LvarAnoMesAnterior2#
						   and m.Ocodigo	= cps.Ocodigo
					">
					<cfset LarrWhere[6] = LarrWhere[6] & "
						 where m.Ecodigo	= cps.Ecodigo
						   and m.CPPid		= #LvarCPPidAnterior#
						   and m.CPcuenta	= cps.CPcuenta
						   and m.Ocodigo	= cps.Ocodigo
					">
					<cfset LarrWhere[8] = LarrWhere[8] & "
						 where m.Ecodigo	= cps.Ecodigo
						   and m.CPPid		= #form.CPPid#
						   and m.CPcuenta	= cps.CPcuenta
						   and m.CPCanoMes	>= #LvarAnoMesAnterior1#
						   and m.CPCanoMes	<= #LvarAnoMesAnterior2#
						   and m.Ocodigo	= cps.Ocodigo
					">
				</cfif>
			<cfelse>
				<!--- Con Corte por fecha --->
				<cfif LvarFiltro[4] EQ "1" OR LvarFiltro[4] EQ "3">
					<cfset LvarCPCano = mid(LvarCPCanoMes,1,4)>
					<cfset LvarCPCmes = mid(LvarCPCanoMes,5,2)>
					<cfset LvarWhereNivel[LvarFiltro[2]] = LvarWhereNivel[LvarFiltro[2]] & "
					  and am#LvarFiltro[2]#.Ecodigo   = cps.Ecodigo
					  and am#LvarFiltro[2]#.CPCano	  = #LvarCPCano#
					  and am#LvarFiltro[2]#.CPCmes	  = #LvarCPCmes#
					">
				<cfelseif LvarFiltro[4] EQ "2">
					<cf_errorCode	code = "50528" msg = "Filtro por Rango de Fechas con Corte por Fecha no se ha implementado">
				</cfif>
			</cfif>
		<!--- Filtro por Nivel de Cuenta --->
		<cfelseif LvarFiltro[1] EQ "4">
			<cfset LarrCorte = listToArray(LvarRptDef.Cortes[LvarFiltro[2]],"·")>
			<cfif LarrCorte[1] EQ "1">
				<cfset LarrCorte[2] = form.CPCNivel>
				<cfset LvarRptDef.Cortes[LvarFiltro[2]] = ArrayToList(LarrCorte,"·")>
			</cfif>
		<!--- Filtro Estructura de Cortes --->
		<cfelseif LvarFiltro[1] EQ "5">
			<cfset LvarFiltroCortes = true>
		<!--- Filtro por Tipo de Dato --->
		<cfelseif LvarFiltro[1] EQ "6">
			<cfset LarrDato = listToArray(LvarRptDef.Datos[LvarFiltro[2]],"·")>
			<cfset LarrDato[3] = evaluate("form.Dato#LvarFiltro[2]#")>
			<cfset LarrDato[2] = replace(LarrDato[2],"[TIPODATO]", fnTipoDato(true,LarrDato[3]),"ALL")>
			<cfset LarrDato[2] = replace(LarrDato[2],"[TIPODATOMAY]", ucase(fnTipoDato(true,LarrDato[3])),"ALL")>
			<cfset LvarRptDef.Campos[LvarFiltro[2]+2] = LarrDato[2]>
			<cfset LvarRptDef.Datos[LvarFiltro[2]] = fnSustituirMacros(ArrayToList(LarrDato,"·"),7)>
		</cfif>
	</cfloop>
</cffunction>

<cffunction name="fnGeneraQuery" returntype="any" output="false">
	<cfquery name="rsOficinas" datasource="#session.dsn#">
		select count(1) as cantidad
		  from Oficinas
		 where Ecodigo 	= #session.Ecodigo#
	</cfquery>
	<cfset LvarCorteSelect = "">
	<cfset LvarCorteOrderBy = "">
	<cfset LvarCorteGroupBy = "">

	<cfif not LvarSybase>
		<!--- ORACLE --->
		<cfset LvarOraIndexes = LvarOraIndexes & "cp,CPresupuesto_02¬">
	</cfif>

	<cfset LvarCorteFrom = "
			  from #ctasOfiTmp# cps
				inner join Oficinas o
					 on o.Ecodigo = cps.Ecodigo
					and o.Ocodigo = cps.Ocodigo
				inner join CPresupuesto cp
					inner join CtasMayor my
						 on my.Ecodigo = cp.Ecodigo
						and my.Cmayor  = cp.Cmayor
						#LvarWhereMY#
					on cp.CPcuenta = cps.CPcuenta
	">


	<!--- 
		Ajuste de CORTES eliminando los Cortes Exluidos, 
		pero se guardan los filtros asociados a cortes excluidos para aplicarlos posterior al proceso de cortes
	--->
	<cfset LvarCortesAExluirI = 0>
	<cfif LvarFiltroCortes>
		<cfset LvarCortesAIncluirI = 0>
		<cfset LvarCortesAIncluir = arrayNew(1)>
		<cfset LvarCortesAExluir = arrayNew(1)>
		<cfset LvarCortesAExluirWhere = arrayNew(1)>
	 	<cfloop index="i" from="1" to="#LvarRptDef.CortesN#">
			<cfif isdefined("LvarNuevoOrdenCortes")>
				<cfset LvarFormIdx = LvarNuevoOrdenCortes[i].Idx>
			<cfelse>
				<cfset LvarFormIdx = i>
			</cfif>
			<cfif isdefined("form.chkCorte#LvarFormIdx#")>
				<cfset LvarCortesAIncluirI = LvarCortesAIncluirI + 1>
				<cfset LvarCortesAIncluir[LvarCortesAIncluirI] = LvarRptDef.Cortes[i]>
				<cfif LvarWhereNivel[i] EQ "">
					<cfset LvarWhereNivel[LvarCortesAIncluirI] = "">
				<cfelse>
					<cfset LvarWhereNivel[LvarCortesAIncluirI] = replace(LvarWhereNivel[i],"#i#.","#LvarCortesAIncluirI#.","ALL")>
				</cfif>
			<cfelse>
				<cfset LvarCortesAExluirI = LvarCortesAExluirI + 1>
				<cfset LvarCortesAExluir[LvarCortesAExluirI] = LvarRptDef.Cortes[i]>
				<cfif LvarWhereNivel[i] EQ "">
					<cfset LvarCortesAExluirWhere[LvarCortesAExluirI] = "">
				<cfelse>
					<cfset LvarCortesAExluirWhere[LvarCortesAExluirI] = replace(LvarWhereNivel[i],"#i#.","#LvarCortesAExluirI+100#.","ALL")>
				</cfif>
			</cfif>
		</cfloop>
		
		<cfset LvarRptDef.Cortes = LvarCortesAIncluir>
		<cfset LvarRptDef.CortesN = LvarCortesAIncluirI>
		<cfif LvarCortesAIncluirI EQ 0>
			<cf_errorCode	code = "50529" msg = "Debe incluir por lo menos un corte en el reporte">
		</cfif>
	</cfif>

	<!--- 
		Proceso de **CORTES**
	--->
 	<cfloop index="i" from="1" to="#LvarRptDef.CortesN#">
		<cfif i GT 1>
			<cfset LvarCorteSelect = LvarCorteSelect & ",">
			<cfset LvarCorteOrderBy = LvarCorteOrderBy & ",">
			<cfset LvarCorteGroupBy = LvarCorteGroupBy & ",">
		</cfif>

		<cfset LarrCorte = listToArray(LvarRptDef.Cortes[i],"·")>
		<!--- Corte por Nivel de Cuenta --->
		<cfif LarrCorte[1] EQ "1">
			<cfif LvarSybase>
				<cfset LvarSybIndex = "-- (index PCDCatalogoCuentaP_05)">
			<cfelse>
				<cfset LvarOraIndexes = LvarOraIndexes & "cubo#i#,PCDCatalogoCuentaP_05¬">
				<cfset LvarSybIndex = "">
			</cfif>
			<cfif LarrCorte[2] eq "U">
				<cfset LvarCorteSelect = LvarCorteSelect & "
					rtrim(cp.CPformato) as Corte#i#, substring(coalesce(cp.CPdescripcionF,cp.CPdescripcion),1,50) as Corte#i#d
				">
				<cfset LvarCorteOrderBy = LvarCorteOrderBy & "
					rtrim(cp.CPformato)
				">
				<cfset LvarCorteGroupBy = LvarCorteGroupBy & "
					rtrim(cp.CPformato), substring(coalesce(cp.CPdescripcionF,cp.CPdescripcion),1,50)
				">
			<cfelse>
				<cfset LvarCorteSelect = LvarCorteSelect & "
					rtrim(p#i#.CPformato) as Corte#i#, substring(coalesce(p#i#.CPdescripcionF,p#i#.CPdescripcion),1,50) as Corte#i#d
				">
				<cfset LvarCorteOrderBy = LvarCorteOrderBy & "
					rtrim(p#i#.CPformato)
				">
				<cfset LvarCorteGroupBy = LvarCorteGroupBy & "
					rtrim(p#i#.CPformato), substring(coalesce(p#i#.CPdescripcionF,p#i#.CPdescripcion),1,50)
				">
				<cfset LvarCorteFrom = LvarCorteFrom & "
					inner join PCDCatalogoCuentaP cubo#i# #LvarSybIndex#
						inner join CPresupuesto p#i#
							 on p#i#.CPcuenta = cubo#i#.CPcuentaniv
						 on cubo#i#.CPcuenta = cps.CPcuenta
						and cubo#i#.PCDCniv = #LarrCorte[2]#
				">
			</cfif>
		<!--- Corte por Clasificacion de Catalogos de Plan --->
		<cfelseif LarrCorte[1] EQ "2">
			<cfquery name="rsClasificacion" datasource="#session.dsn#">
				select PCCEclaid, PCCEcodigo, PCCEdescripcion
				  from PCClasificacionE e
				 where CEcodigo = #session.CEcodigo#
				   and PCCEcodigo = '#LarrCorte[2]#'
			</cfquery>
			<cfif rsClasificacion.recordCount EQ 0>
				<cf_errorCode	code = "50530"
								msg  = "La Clasificacion de Catálogos para Plan de Cuentas codigo='@errorDat_1@' no está definida"
								errorDat_1="#LarrCorte[2]#"
				>
			</cfif>
			<cfif LvarSybase>
				<cfset LvarSybIndex1 = "-- (index PCDCatalogoCuentaP_06)">
				<cfset LvarSybIndex2 = "-- (index PCDClasificacionCatalogo_01)">
				<cfset LvarSybIndex3 = "-- (index PCClasificacionD_03)">
			<cfelse>
				<cfset LvarOraIndexes = LvarOraIndexes & "cubo#i#,PCDCatalogoCuentaP_06¬">
				<cfset LvarOraIndexes = LvarOraIndexes & "pcdcc#i#,PCDClasificacionCatalogo_01¬">
				<cfset LvarOraIndexes = LvarOraIndexes & "pccd#i#,PCClasificacionD_03¬">
				<cfset LvarSybIndex1 = "">
				<cfset LvarSybIndex2 = "">
				<cfset LvarSybIndex3 = "">
			</cfif>
			<cfquery name="rsPCCE" datasource="#session.dsn#">
				select PCCEclaid, PCCEcodigo, PCCEdescripcion, PCCEempresa
				  from PCClasificacionE
				 where CEcodigo 	= #session.CEcodigo#
				   and PCCEcodigo	= '#LarrCorte[2]#'
			</cfquery>
		
			<cfset LvarCorteSelect = LvarCorteSelect & "
				coalesce(pccd#i#.PCCDvalor, '0') as Corte#i#, substring('#trim(rsPCCE.PCCEdescripcion)#: ' #_Cat# coalesce(pccd#i#.PCCDdescripcion,'Sin Clasificar'),1,50) as Corte#i#d
			">
			<cfset LvarCorteOrderBy = LvarCorteOrderBy & "
				coalesce(pccd#i#.PCCDvalor, '0')
			">
			<cfset LvarCorteGroupBy = LvarCorteGroupBy & "
				coalesce(pccd#i#.PCCDvalor, '0'), substring('#trim(rsPCCE.PCCEdescripcion)#: ' #_Cat# coalesce(pccd#i#.PCCDdescripcion,'Sin Clasificar'),1,50)
			">
					
			<cfif Len(Trim(LvarWhereNivel[i]))>
				<cfset LvarSQL_ctasClaTmp = LvarSQL_ctasClaTmp & "
					insert into #ctasClaTmp# 
						(Corte, CPcuenta, PCCDvalor, PCCDdescripcion)
					select distinct #i# as Corte, cps.CPcuenta, pccd#i#.PCCDvalor, pccd#i#.PCCDdescripcion
					  from #ctasOfiTmp# cps
					inner join PCDCatalogoCuentaP cubo#i# #LvarSybIndex1#
						 on cubo#i#.CPcuenta = cps.CPcuenta
					inner join PCDClasificacionCatalogo pcdcc#i# #LvarSybIndex2#
							inner join PCClasificacionD pccd#i# #LvarSybIndex3#
								 on pccd#i#.PCCDclaid = pcdcc#i#.PCCDclaid
								 #LvarWhereNivel[i]#
						 on pcdcc#i#.PCCEclaid = #rsPCCE.PCCEclaid#
						and pcdcc#i#.PCDcatid  = cubo#i#.PCDcatid
						|
				">
			<cfelse>
				<!--- left join: No hay filtro por clasificacion, incluye los 'no clasificados' de un encabezado --->
				<cfset LvarSQL_ctasClaTmp = LvarSQL_ctasClaTmp & "
					insert into #ctasClaTmp# 
						(Corte, CPcuenta, PCCDvalor, PCCDdescripcion)
					select distinct #i# as Corte, cps.CPcuenta, pccd#i#.PCCDvalor, pccd#i#.PCCDdescripcion
					  from #ctasOfiTmp# cps
						inner join PCDCatalogoCuentaP cubo#i#
							 on cubo#i#.CPcuenta = cps.CPcuenta
						inner join PCEClasificacionCatalogo pcecc#i#
							 on pcecc#i#.PCEcatid  = cubo#i#.PCEcatid
							and pcecc#i#.PCCEclaid = #rsPCCE.PCCEclaid#
						left join PCDClasificacionCatalogo pcdcc#i#
								inner join PCClasificacionD pccd#i#
									 on pccd#i#.PCCDclaid = pcdcc#i#.PCCDclaid
							 on pcdcc#i#.PCCEclaid = #rsPCCE.PCCEclaid#
							and pcdcc#i#.PCDcatid  = cubo#i#.PCDcatid
							|
				">
			</cfif>
			<cfset LvarCorteFrom = LvarCorteFrom & "
					inner join  #ctasClaTmp# pccd#i# on pccd#i#.CPcuenta = cps.CPcuenta and pccd#i#.Corte=#i#
				">
			<cfset LvarCorteFrom = LvarCorteFrom & "
			">
		<!--- Corte por Meses --->
		<cfelseif LarrCorte[1] EQ "3">
			<cfif LvarCorteTemporal>
				<cf_errorCode	code = "50531" msg = "Hay mas de un Corte por Fecha">
			</cfif>
			<cfset LvarCorteTemporal = true>
			
			<cf_dbfunction name="to_char" args="am#i#.CPCano" returnvariable="LvarToChar">
			<cfset LvarToChar = replace(LvarToChar,"(255)","(4)","ALL")>

			<cfif LarrCorte[2] eq "H">
				<cfif LvarMesesHorizontales>
					<cf_errorCode	code = "50532" msg = "Meses Horizontales sólo se puede definir como último corte">
				</cfif>
				<cfset LvarMesesHorizontales=true>
				<cfset LvarMeses = "case am#i#.CPCmes when 1 then 'ENE' when 2 then 'FEB' when 3 then 'MAR' when 4 then 'ABR' when 5 then 'MAY' when 6 then 'JUN' when 7 then 'JUL' when 8 then 'AGO' when 9 then 'SET' when 10 then 'OCT' when 11 then 'NOV' when 12 then 'DIC' end #_Cat# ' ' #_Cat# #LvarToChar#">
				<cfquery name="rsMeses" datasource="#session.dsn#">
					select am#i#.CPCano*100+am#i#.CPCmes as MesI, #PreserveSingleQuotes(LvarMeses)# as Mes 
					  from CPmeses am#i#
					 where am#i#.Ecodigo 	= #session.Ecodigo#
					   and am#i#.CPPid		= #form.CPPid#
					 order by am#i#.CPCano, am#i#.CPCmes
				</cfquery>
			<cfelse>
				<cfset LvarMeses = "case am#i#.CPCmes when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' end #_Cat# ' ' #_Cat# #LvarToChar#">
			</cfif>
			<cfset LvarCorteFrom = LvarCorteFrom & "
					inner join #mesesTmp# am#i#
						 on am#i#.Ecodigo 	= cps.Ecodigo
						and am#i#.CPPid		= #form.CPPid#
			">
			<cfif not LvarFiltroTemporal>
				<!--- No hay Filtro por Mes: se filtra por el Mes de Corte --->
				<cfset LvarDimensionTemporal = true>
				<cfset LarrWhere[1] = LarrWhere[1] & "
						 where m.CPcuenta	= cps.CPcuenta
						   and m.CPCanoMes	= am#i#.CPCanoMes
						   and m.Ocodigo	= cps.Ocodigo
						   and m.CPPid		= #form.CPPid#
						   and m.Ecodigo	= cps.Ecodigo
					">
				<cfset LarrWhere[2] = LarrWhere[2] & "
						 where m.CPcuenta	= cps.CPcuenta
						   and m.CPCanoMes	<= am#i#.CPCanoMes
						   and m.Ocodigo	= cps.Ocodigo
						   and m.CPPid		= #form.CPPid#
						   and m.Ecodigo	= cps.Ecodigo
					">
				<cfset LarrWhere[3] = LarrWhere[3] & "
						 where m.CPcuenta	= cps.CPcuenta
						   and m.Ocodigo	= cps.Ocodigo
						   and m.CPPid		= #form.CPPid#
						   and m.Ecodigo	= cps.Ecodigo
					">
			</cfif>
			<cfif ArrayLen(LvarWhereNivel) GTE i AND Len(Trim(LvarWhereNivel[i]))>
				<cfset LvarCorteFrom = LvarCorteFrom & "
							#LvarWhereNivel[i]#
				">
			</cfif>

			<cfset LvarCorteSelect = LvarCorteSelect & "
				am#i#.CPCanoMes as Corte#i#, #LvarMeses# as Corte#i#d
			">
			<cfset LvarCorteOrderBy = LvarCorteOrderBy & "
				am#i#.CPCanoMes
			">
			<cfset LvarCorteGroupBy = LvarCorteGroupBy & "
				am#i#.CPCanoMes, #LvarMeses#
			">
		<!--- Corte por Oficinas --->
		<cfelseif LarrCorte[1] EQ "4">
			<cfset LvarCorteSelect = LvarCorteSelect & "
				o.Oficodigo as Corte#i#, substring('Oficina: ' #_Cat# o.Odescripcion, 1, 50) as Corte#i#d
			">
			<cfset LvarCorteOrderBy = LvarCorteOrderBy & "
				o.Oficodigo
			">
			<cfset LvarCorteGroupBy = LvarCorteGroupBy & "
				o.Oficodigo, substring('Oficina: ' #_Cat# o.Odescripcion, 1, 50)
			">
		<!--- Corte por Catalogos de Plan --->
		<cfelseif LarrCorte[1] EQ "5">
			<cfif LvarSybase>
				<cfset LvarSybIndex = "-- (index PCDCatalogoCuentaP_06)">
			<cfelse>
				<cfset LvarOraIndexes = LvarOraIndexes & "cubo#i#,PCDCatalogoCuentaP_06¬">
				<cfset LvarSybIndex = "">
			</cfif>
			<cfquery name="rsCatalogo" datasource="#session.dsn#">
				select PCEcatid, PCEdescripcion
				  from PCECatalogo e
				 where CEcodigo = #session.CEcodigo#
				   and PCEcodigo = '#LarrCorte[2]#'
			</cfquery>
			<cfif rsCatalogo.recordCount EQ 0>
				<cf_errorCode	code = "50530"
								msg  = "La Clasificacion de Catálogos para Plan de Cuentas codigo='@errorDat_1@' no está definida"
								errorDat_1="#LarrCorte[2]#"
				>
			</cfif>
			<cfset LvarCorteSelect = LvarCorteSelect & "
				rtrim(cat#i#.PCDvalor) as Corte#i#, substring(cat#i#.PCDdescripcion,1,50) as Corte#i#d
			">
			<cfset LvarCorteOrderBy = LvarCorteOrderBy & "
				rtrim(cat#i#.PCDvalor)
			">
			<cfset LvarCorteGroupBy = LvarCorteGroupBy & "
				rtrim(cat#i#.PCDvalor), substring(cat#i#.PCDdescripcion,1,50)
			">
			<cfset LvarCorteFrom = LvarCorteFrom & "
					inner join PCDCatalogoCuentaP cubo#i# #LvarSybIndex#
						inner join PCDCatalogo cat#i#
							 on cat#i#.PCDcatid = cubo#i#.PCDcatid
						 on cubo#i#.CPcuenta = cps.CPcuenta
						and cubo#i#.PCEcatid = #rsCatalogo.PCEcatid#
			">
		</cfif>
	</cfloop>

	<!--- 
		Aplicacion de Filtros asociados a Cortes Excluidos
	--->
 	<cfloop index="i" from="1" to="#LvarCortesAExluirI#">
		<cfset LarrCorte = listToArray(LvarCortesAExluir[i],"·")>
		<!--- Filtro por Corte Excluido por Clasificacion --->
		<cfif LarrCorte[1] EQ "2" AND LvarCortesAExluirWhere[i] NEQ "">
			<cfif LvarSybase>
				<cfset LvarSybIndex1 = "-- (index PCDCatalogoCuentaP_06)">
				<cfset LvarSybIndex2 = "-- (index PCDClasificacionCatalogo_01)">
				<cfset LvarSybIndex3 = "-- (index PCClasificacionD_03)">
			<cfelse>
				<cfset LvarOraIndexes = LvarOraIndexes & "cubo#i+100#,PCDCatalogoCuentaP_06¬">
				<cfset LvarOraIndexes = LvarOraIndexes & "pcdcc#i+100#,PCDClasificacionCatalogo_01¬">
				<cfset LvarOraIndexes = LvarOraIndexes & "pccd#i+100#,PCClasificacionD_03¬">
				<cfset LvarSybIndex1 = "">
				<cfset LvarSybIndex2 = "">
				<cfset LvarSybIndex3 = "">
			</cfif>
			<cfquery name="rsPCCE" datasource="#session.dsn#">
				select PCCEclaid, PCCEcodigo, PCCEdescripcion, PCCEempresa
				  from PCClasificacionE
				 where CEcodigo 	= #session.CEcodigo#
				   and PCCEcodigo	= '#LarrCorte[2]#'
			</cfquery>
		
			<cfset LvarCorteFrom = LvarCorteFrom & "
				inner join PCDCatalogoCuentaP cubo#i+100# #LvarSybIndex1#
					 on cubo#i+100#.CPcuenta = cps.CPcuenta
				inner join PCDClasificacionCatalogo pcdcc#i+100# #LvarSybIndex2#
						inner join PCClasificacionD pccd#i+100# #LvarSybIndex3#
							 on pccd#i+100#.PCCDclaid = pcdcc#i+100#.PCCDclaid
							 #LvarCortesAExluirWhere[i]#
					 on pcdcc#i+100#.PCCEclaid = #rsPCCE.PCCEclaid#
					and pcdcc#i+100#.PCDcatid  = cubo#i+100#.PCDcatid
			">
		<cfelseif LarrCorte[1] EQ "3" AND LvarCortesAExluirWhere[i] NEQ "">
			<cf_errorCode	code = "50533" msg = "No se puede excluir un Corte por Mes de Presupuesto">
		</cfif>
	</cfloop>

	<cfif LvarSybase>
		<cfset LvarOraIndexesHints = "">
	<cfelse>
		<cfloop list="#LvarOraIndexes#" index="LvarHint" delimiters="¬">
			<cfif LvarOraIndexesHints EQ "">
				<cfset LvarOraIndexesHints = "/*+">
			</cfif>
			<cfset LvarOraIndexesHints = LvarOraIndexesHints & " INDEX (#LvarHint#)">
		</cfloop>
		<cfif LvarOraIndexesHints NEQ "">
			<cfset LvarOraIndexesHints = LvarOraIndexesHints & " */">
		</cfif>
	</cfif>
	
	<cfif not LvarDimensionTemporal>
		<!--- No hay filtro ni corte por mes: solo se puede usar dimension temporal 3=Total --->
		<cfset LarrWhere[3] = LarrWhere[3] & "
					 where m.Ecodigo	= cps.Ecodigo
					   and m.CPPid		= #form.CPPid#
					   and m.CPcuenta	= cps.CPcuenta
					   and m.Ocodigo	= cps.Ocodigo
		">
	</cfif>

	<!--- 
		Proceso de **DATOS**
	--->
	<cfset LvarSelect  = "SELECT	#LvarOraIndexesHints# 
		">
	<cfset LvarHaving  = "">
	<cfloop index="i" from="1" to="#LvarRptDef.DatosN#">
		<cfset LarrDato = listToArray(LvarRptDef.Datos[i],"·")>
		<cfif i GT 1>
			<cfset LvarSelect  = LvarSelect  & ", ">
		</cfif>
		<cfif mid(LarrDato[3],1,1) EQ "*" OR mid(LarrDato[3],1,1) EQ "%">
			<cfset LvarSelect = LvarSelect & "0.0 as Dato#i#
			">
		<cfelse>
			<cfif LarrWhere[LarrDato[1]] EQ "">
				<cfif LarrDato[1] GT 3 AND LvarDimensionTemporal>
					<cf_errorCode	code = "50534" msg = "No se permite una dimensión temporal de un año atrás si no se define Filtro por Mes de Presupuesto">
				<cfelse>
					<cf_errorCode	code = "50535" msg = "Sólo se permite la dimensión temporal 3=Total si no se define ni Filtro ni Corte por Mes de Presupuesto">
				</cfif>
			</cfif>
			
			<cfif LvarSybase>
				<cfset LvarSybIndex = "-- (index CPresupuestoControl_02)">
				<cfset LvarOraIndex = "">
			<cfelse>
				<cfset LvarSybIndex = "">
				<cfset LvarOraIndex = "/*+ INDEX (m,CPresupuestoControl_02) */">
			</cfif>

			<cfif LvarHaving EQ "">
				<cfset LvarHaving  = " HAVING ">
			<cfelse>
				<cfset LvarHaving  = LvarHaving  & " OR ">
			</cfif>


			<!--- 
				LvarWhereDato:  Filtro para calcular cada Dato
				LvarHavingDato: Filtro para eliminar todo en cero
			--->
			<cfif LvarMesesHorizontales>
				<cfif i EQ 1>
					<cfif LarrDato[1] NEQ 1>
						<cf_errorCode	code = "50536" msg = "Meses Horizontales sólo se puede definir en el Primer Dato y con Dimensión Temporal 1=Mensual">
					</cfif>

					<cfif LvarFiltroTemporal>
						<!--- 
							Horizontal con FiltroTemporal:
								Sacar datos únicamente hasta mes del filtro (como si fuera acumulado)
								Dato correspondiente al mes de Corte
								
								Filtrar en Cero todos los datos hasta mes del filtro (como si fuera acumulado)
						--->
						<cfset LvarWhereDato 	= LarrWhere[2] & "
						   and m.CPCanoMes	= am#LvarRptDef.CortesN#.CPCanoMes"
						>
						<cfset LvarHavingDato 	= LarrWhere[2]> 
					<cfelse>
						<!--- 
							Horizontal sin FiltroTemporal:
								Sacar dato correspondiente al mes de Corte
								
								Filtrar en Cero todos los datos hasta mes de periodo (como si fuera Total)
						--->
						<cfset LvarWhereDato 	= LarrWhere[1]>
						<cfset LvarHavingDato 	= LarrWhere[3]>
					</cfif>
				<cfelseif LarrDato[1] EQ 1>
					<cf_errorCode	code = "50537" msg = "Meses Horizontales sólo se puede definir en el Primer Dato con Dimensión Temporal 1=Mensual, los demás datos deben tener Dimensión Temporal 2=Acumulado o 3=Total">
				<cfelse>
					<!--- 
						Cualquier otro No Horizontal:
							Sacar y Filtrar en Cero dato correspondiente a la dimesion temporal de Corte
					--->
					<cfset LvarWhereDato	= LarrWhere[LarrDato[1]]>
					<cfset LvarHavingDato	= LvarWhereDato>
				</cfif>
			<cfelse>
				<!--- No Horizontal: Sacar y Filtrar en Cero dato correspondiente a la dimesion temporal de Corte --->
				<cfset LvarWhereDato 	= LarrWhere[LarrDato[1]]>
				<cfset LvarHavingDato	= LvarWhereDato>
			</cfif>

			<cfif NOT LvarSqlServer>
				<cfset LvarHaving  = LvarHaving  & "SUM">
				<cfset LvarSelect  = LvarSelect  & "SUM">
			</cfif>
			<cfset LvarHaving  = LvarHaving  & "(coalesce(
				(
					SELECT 	#LvarOraIndex#
							sum(#LarrDato[3]#)
					  FROM 	CPresupuestoControl m #LvarSybIndex#
					  #LvarHavingDato#
				) 
			, 0.0)) <> 0
			">
			<cfset LvarSelect  = LvarSelect  & "(coalesce(
				(
					SELECT 	#LvarOraIndex#
							sum(#LarrDato[3]#)
					  FROM 	CPresupuestoControl m #LvarSybIndex#
					  #LvarWhereDato#
				)
			, 0.0)) as Dato#i#
			">
		</cfif>
	</cfloop>

<!---
	NO SE PARA QUE SE RELLENABA A 10 CORTES
	<cfloop index="i" from="#LvarRptDef.CortesN+1#" to="10">
		<cfif i GT 1>
			<cfset LvarCorteSelect = LvarCorteSelect & ", ">
		</cfif>
		<cfset LvarCorteSelect = LvarCorteSelect & "0 as Corte#i#">
	</cfloop>
--->	
	<cfif form.CFid NEQ -100>
		<CFSET LvarPonerExists = false> <!--- false --->
		<cf_CPSegUsu_where returnVariable="LvarCPSegUsu" Consultar="true" aliasCuentas="cp" aliasOficina="m">
	<cfelse>
		<CFSET LvarPonerExists = true>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			SELECT 	count(1) as cantidad
			  FROM CPSeguridadMascarasCtasP cpm
			 WHERE cpm.Ecodigo		= #session.Ecodigo#
			   and cpm.CFid			IS NULL
			   and cpm.Usucodigo	= #session.Usucodigo#
			   and cpm.CPSMconsultar = 1
			   and rtrim(cpm.CPSMascaraP) = '%'
		</cfquery>
		<cfif rsSQL.Cantidad GT 0>
			<cfset LvarCPSegUsu = "">
		<cfelse>
			<cfquery name="rsSQL" datasource="#session.dsn#">
				SELECT 	count(1) as cantidad
				  FROM CPSeguridadMascarasCtasP cpm
				 WHERE cpm.Ecodigo		= #session.Ecodigo#
				   and cpm.CFid			IS NULL
				   and cpm.Usucodigo	= #session.Usucodigo#
				   and cpm.CPSMconsultar = 1
			</cfquery>
			<cfif rsSQL.Cantidad GT 0>
				<cf_CPSegUsu_where returnVariable="LvarCPSegUsu" Consultar="true" aliasCuentas="cp" aliasOficina="m">
			<cfelse>
				<CFSET LvarPonerExists = false> <!--- false --->
				<cf_CPSegUsu_where returnVariable="LvarCPSegUsu" Consultar="true" aliasCuentas="cp" aliasOficina="m" verSeguridadUsu="no">
			</cfif>
		</cfif>
	</cfif>

	<cfif not LvarSybase and not isdefined("LvarCPformato")>
		<cfset LvarWhereCP = LvarWhereCP & "
					and cp.CPformato >= ' '
					and cp.CPformato <= '#chr(255)#'
					">
	</cfif>
	<cfsavecontent variable="LvarSQL_ctasOfiTmp">
	<cfoutput>
		insert into #ctasOfiTmp#
			(CPcuenta, Ocodigo, Ecodigo)
		select m.CPcuenta, m.Ocodigo , m.Ecodigo 
		  from CPresupuestoControl m
			inner join CPresupuesto cp 
					inner join CtasMayor my
						 on my.Ecodigo = cp.Ecodigo
						and my.Cmayor  = cp.Cmayor
						#LvarWhereMY#
			   on cp.CPcuenta = m.CPcuenta
			  #LvarWhereCP#
		 where m.Ecodigo 	= #session.Ecodigo#
		   and m.CPPid		= #form.CPPid#
		   and m.CPCano		= #mid(rsPeriodo.CPPanoMesDesde,1,4)#
		   and m.CPCmes		= #mid(rsPeriodo.CPPanoMesDesde,5,2)#
		   #LvarWhereOF#
			  #LvarCPSegUsu#
	</cfoutput>
	</cfsavecontent>
	<cfsavecontent variable="LvarSQL_mesesTmp">
	<cfoutput>
		insert into #mesesTmp# (Ecodigo, CPPid, CPCano, CPCmes, CPCanoMes)
		select Ecodigo, CPPid, CPCano, CPCmes, CPCano*100+CPCmes 
		  from CPmeses 
		 where Ecodigo 	= #session.Ecodigo#
		   and CPPid	= #form.CPPid#
	</cfoutput>
	</cfsavecontent>

	<cfif not isdefined("form.chkNoCeros")>
		<cfset LvarHaving = "">
	</cfif>

	<cfif LvarSqlServer>
	 	<cfloop index="i" from="1" to="#LvarRptDef.CortesN#">
			<cfif i EQ 1>
				<cfset LvarSQL = "select Corte#i#, Corte#i#d">
			<cfelse>
				<cfset LvarSQL &= ", Corte#i#, Corte#i#d">
			</cfif>
		</cfloop>
		<cfloop index="i" from="1" to="#LvarRptDef.DatosN#">
			<cfset LvarSQL &= ", sum(Dato#i#) as Dato#i#">
		</cfloop>
		<cfset LvarSQL &= "
FROM (		
#LvarSelect#,
#LvarCorteSelect#
#LvarCorteFrom#
where 1=1
#LvarWhere#
) as x
">
	 	<cfloop index="i" from="1" to="#LvarRptDef.CortesN#">
			<cfif i EQ 1>
				<cfset LvarSQL &= "group by Corte#i#, Corte#i#d">
			<cfelse>
				<cfset LvarSQL &= ", Corte#i#, Corte#i#d">
			</cfif>
		</cfloop>
		<cfif isdefined("form.chkNoCeros")>
			<cfloop index="i" from="1" to="#LvarRptDef.DatosN#">
				<cfif i EQ 1>
					<cfset LvarSQL &= "
having sum(Dato#i#) <> 0">
				<cfelse>
					<cfset LvarSQL &= "or sum(Dato#i#) <> 0">
				</cfif>
			</cfloop>
		</cfif>
	 	<cfloop index="i" from="1" to="#LvarRptDef.CortesN#">
			<cfif i EQ 1>
				<cfset LvarSQL &= "
order by Corte#i#">
			<cfelse>
				<cfset LvarSQL &= ", Corte#i#">
			</cfif>
		</cfloop>
	<cfelse>
		<cfset LvarSQL = "
#LvarSelect#,
#LvarCorteSelect#
#LvarCorteFrom#
where 1=1
#LvarWhere#
group by #LvarCorteGroupBy#
#LvarHaving#
order by #LvarCorteOrderBy#
			">
	</cfif>
	<cfreturn fnEjecutaQuery()>
</cffunction>

<cffunction name="fnEjecutaQuery" output="true" returntype="any">
	<cfif LvarAbort>
		<cfset Lvar_ctasClaTmp = Replace(LvarSQL_ctasClaTmp,"|","<BR>","ALL")>
		<cfoutput>
#PreserveSingleQuotes(LvarSQL_ctasOfiTmp)#<BR>
#PreserveSingleQuotes(Lvar_ctasClaTmp)#<BR>
#PreserveSingleQuotes(LvarSQL_mesesTmp)#<BR>
#PreserveSingleQuotes(LvarSQL)#<BR>
		</cfoutput>
		<cfabort>
	</cfif>

	<cfif LvarSQL_ctasOfiTmp NEQ "">
		<cfquery name="rsQuery" datasource="#session.DSN#">
#PreserveSingleQuotes(LvarSQL_ctasOfiTmp)#
		</cfquery>
	</cfif>
	<cfloop list="#LvarSQL_ctasClaTmp#" index="LvarSQL_Cla" delimiters="|">
		<cfif trim(LvarSQL_Cla) NEQ "">
			<cfquery name="rsQuery" datasource="#session.DSN#">
#PreserveSingleQuotes(LvarSQL_Cla)#
			</cfquery>
		</cfif>
	</cfloop>
	<cfif LvarSQL_mesesTmp NEQ "">
		<cfquery name="rsQuery" datasource="#session.DSN#">
#PreserveSingleQuotes(LvarSQL_mesesTmp)#
		</cfquery>
	</cfif>
	<cfquery name="rsQuery" datasource="#session.DSN#">
#PreserveSingleQuotes(LvarSQL)#
	</cfquery>
<!---
	<cfquery name="rsQuery" datasource="#session.dsn#">
#PreserveSingleQuotes(LvarSQL)#
	</cfquery>
--->
	<cfreturn rsQuery>
</cffunction>

<cffunction name="fnNombreMes" returntype="string">
	<cfargument name="Mes" 		 	type="numeric" required="yes">
	<cfargument name="Mayusculas"	type="boolean" required="yes">

	<cfset var LvarMes = Arguments.Mes>
	
	<cfset LvarMesMay = "MES">
	<cfset LvarMesMin = "Mes">
	<cfif LvarMes EQ 1>
		<cfset LvarMesMay = "ENERO">
		<cfset LvarMesMin = "Enero">
	<cfelseif LvarMes EQ 2>
		<cfset LvarMesMay = "FEBRERO">
		<cfset LvarMesMin = "Febrero">
	<cfelseif LvarMes EQ 3>
		<cfset LvarMesMay = "MARZO">
		<cfset LvarMesMin = "Marzo">
	<cfelseif LvarMes EQ 4>
		<cfset LvarMesMay = "ABRIL">
		<cfset LvarMesMin = "Abril">
	<cfelseif LvarMes EQ 5>
		<cfset LvarMesMay = "MAYO">
		<cfset LvarMesMin = "Mayo">
	<cfelseif LvarMes EQ 6>
		<cfset LvarMesMay = "JUNIO">
		<cfset LvarMesMin = "Junio">
	<cfelseif LvarMes EQ 7>
		<cfset LvarMesMay = "JULIO">
		<cfset LvarMesMin = "Julio">
	<cfelseif LvarMes EQ 8>
		<cfset LvarMesMay = "AGOSTO">
		<cfset LvarMesMin = "Agosto">
	<cfelseif LvarMes EQ 9>
		<cfset LvarMesMay = "SEPTIEMBRE">
		<cfset LvarMesMin = "Septiembre">
	<cfelseif LvarMes EQ 10>
		<cfset LvarMesMay = "OCTUBRE">
		<cfset LvarMesMin = "Octubre">
	<cfelseif LvarMes EQ 11>
		<cfset LvarMesMay = "NOVIEMBRE">
		<cfset LvarMesMin = "Noviembre">
	<cfelseif LvarMes EQ 12>
		<cfset LvarMesMay = "DICIEMBRE">
		<cfset LvarMesMin = "Diciembre">
	</cfif>
	<cfif Arguments.Mayusculas>
		<cfreturn LvarMesMay>
	<cfelse>
		<cfreturn LvarMesMin>
	</cfif>
</cffunction>

<cffunction name="fnDefinicion" returntype="string">
	<cfargument name="Definicion" 	type="string" default="false">

	<cfset var LvarNL = chr(13) & chr(10)>
	<cfset var LvarDefinicion	= "">
	<cfset var LvarGenerales	= "">
	<cfset var LvarStyles 		= "">
	<cfset var LvarHeaders 		= "">
	<cfset var LvarFooters 		= "">
	<cfset var LvarFinales 		= "">
	<cfset var LvarCortes 		= "">
	<cfset var LvarFiltros 		= "">
	<cfset var LvarDatos 		= "">
	<cfset var LvarCampos 		= "">
	
	<cfset LvarDefinicion 	= ListToArray(Arguments.Definicion, LvarNL)>
	<cfloop index="i" from="1" to="#arrayLen(LvarDefinicion)#">
		<cfset LvarDefinicion[i] = fnSustituirMacros(LvarDefinicion[i],i)>
	</cfloop>

	<cfset LvarGenerales	= LvarDefinicion[1]>
	<cfset LvarStyles 		= LvarDefinicion[2]>
	<cfset LvarHeaders 		= LvarDefinicion[3]>
	<cfset LvarFooters 		= LvarDefinicion[4]>
	<cfset LvarFinales 		= LvarDefinicion[5]>
	<cfset LvarCortes 		= LvarDefinicion[6]>
	<cfset LvarDatos 		= LvarDefinicion[7]>
	<cfset LvarFiltros 		= LvarDefinicion[8]>

	<cfset LvarGenerales			= listToArray(LvarGenerales,"¦")>

	<cfset LvarRptDef.FontFamily 	= LvarGenerales[1]>
	<cfif arrayLen(LvarGenerales) GT 1 AND LvarGenerales[2] NEQ ".">
		<cfset LvarRptDef.SqlCfm 	= LvarGenerales[2]>
	</cfif>
	
	<cfif arrayLen(LvarGenerales) GT 2 AND LvarGenerales[3] NEQ ".">
		<cfset LvarRptDef.DecFmt 	= LvarGenerales[3]>
	<cfelse>
		<cfset LvarRptDef.DecFmt 	= ",0">
	</cfif>

	<cfset LvarRptDef.Sytles	= listToArray(LvarStyles,"¦")>
	<cfset LvarRptDef.SytlesN	= arrayLen(LvarRptDef.Sytles)>
	
	<cfset LvarRptDef.Headers	= listToArray(LvarHeaders,"¦")>
	<cfset LvarRptDef.Footers	= listToArray(LvarFooters,"¦")>
	<cfset LvarRptDef.FootersN	= arrayLen(LvarRptDef.Footers)>
	<cfif GvarLineasPagina EQ 0>
		<cfset LvarRptDef.LineasPag	= 1234567>
	<cfelse>
		<cfset LvarRptDef.LineasPag	= GvarLineasPagina - arrayLen(LvarRptDef.Footers)>
	</cfif>
	<cfset LvarRptDef.Finales	= listToArray(LvarFinales,"¦")>
	<cfset LvarRptDef.FinalesN	= arrayLen(LvarRptDef.Finales)>
		
	<cfset LvarRptDef.Cortes = listToArray(LvarCortes,"¦")>
	<cfset LvarRptDef.CortesN = arrayLen(LvarRptDef.Cortes)>
	
	<cfset LvarRptDef.Datos = listToArray(LvarDatos,"¦")>
	<cfset LvarRptDef.DatosN = arrayLen(LvarRptDef.Datos)>

	<cfset LvarCampos = "Codigo¦Descripcion">
	<cfloop index="i" from="1" to="#LvarRptDef.DatosN#">
		<cfset LvarCampos = LvarCampos & "¦" & listGetAt(LvarRptDef.Datos[i],2,"·")>
	</cfloop>
	<cfset LvarRptDef.Campos = listToArray(LvarCampos,"¦")>
	<cfset LvarRptDef.CamposN = LvarRptDef.DatosN + 2>

	<cfset LvarRptDef.Filtros = listToArray(LvarFiltros,"¦")>
	<cfset LvarRptDef.FiltrosN	= arrayLen(LvarRptDef.Filtros)>

	<!--- Ajuste de Filtro por Dimensión Temporal --->
	<cfloop index="i" from="1" to="#LvarRptDef.DatosN#">
		<cfset LarrDato = listToArray(LvarRptDef.Datos[i],"·")>
		<cfif LarrDato[1] EQ "0">
			<cfset LvarDatoTemporal = true>
			<cfif isdefined("form.CPCtemporal")>
				<cfset LarrDato[1] = form.CPCtemporal>
				<cfset LvarRptDef.Datos[i] = arrayToList(LarrDato,"·")>
			<cfelse>
				<cf_errorCode	code = "50538"
								msg  = "No se definió Filtro por Dimensión Temporal para el dato @errorDat_1@=@errorDat_2@"
								errorDat_1="#i#"
								errorDat_2="#LarrDato[2]#"
				>
			</cfif>
		</cfif>
	</cfloop>
	<cfif isdefined("form.CPCtemporal") and not isdefined("LvarDatoTemporal")>
		<cf_errorCode	code = "50539" msg = "Se definió un Filtro por Dimensión Temporal pero no se indicó ningún Dato para ese filtro">
	</cfif>

	<!--- Ajuste de Corte por Orden --->
	<cfif isdefined("form.CPCcortes1")>
		<cfset LvarNuevoOrdenCortes = arrayNew(1)>
		
		<cfloop index="i" from="1" to="#LvarRptDef.CortesN#">
			<cfset LvarNuevoOrdenCortes[i] = structNew()>
			<cfset LvarNuevoOrdenCortes[i].Idx = i>
			<cfparam name="form.CPCcortes#i#" default="0">
			<cfset LvarNuevoOrdenCortes[i].Ord = evaluate("form.CPCcortes#i#")>
		</cfloop>
		<cfset LvarCortes = arrayNew(1)>
		<cfloop index="i" from="1" to="#LvarRptDef.CortesN#">
			<cfset LvarMenor = LvarNuevoOrdenCortes[i].clone()>
			<cfloop index="j" from="#i#" to="#LvarRptDef.CortesN#">
				<cfif LvarNuevoOrdenCortes[j].Ord*10+LvarNuevoOrdenCortes[j].Idx LTE LvarMenor.Ord*10+LvarMenor.Idx>
					<cfset LvarMenor = LvarNuevoOrdenCortes[j]>
					<cfset LvarMenor.j = j>
				</cfif>
			</cfloop>
			<cfset LvarCortes[i] = LvarRptDef.Cortes[LvarMenor.Idx]>

			<cfset LvarSwap = LvarMenor.clone()>
			<cfset LvarNuevoOrdenCortes[LvarMenor.j] = LvarNuevoOrdenCortes[i].clone()>
			<cfset LvarNuevoOrdenCortes[i] = LvarSwap.clone()>
		</cfloop>
		<cfset LvarRptDef.Cortes = LvarCortes>

		<cfloop index="i" from="1" to="#LvarRptDef.FiltrosN#">
			<cfset LarrFiltro = listToArray(LvarRptDef.Filtros[i],"·")>
			<cfif listfind("2,3,4,8",LarrFiltro[1]) AND LarrFiltro[2] NEQ "">
				<cfloop index="j" from="1" to="#LvarRptDef.CortesN#">
					<cfif LarrFiltro[2] EQ LvarNuevoOrdenCortes[j].Idx And LvarNuevoOrdenCortes[j].Idx NEQ j>
						<cfset LarrFiltro[2] = j>
						<cfset LvarRptDef.Filtros[i] = arrayToList(LarrFiltro,"·")>
						<cfbreak>
					</cfif>
				</cfloop>
			</cfif>
		</cfloop>
	</cfif>

	<cfset fnGeneraFiltro()>

	<!--- Ajuste de Nivel de Cuenta --->
	<cfif isdefined("form.CPCNivel") and (isnumeric(form.CPCNivel) OR form.CPCNivel EQ "U")>
		<cfquery name="rsSQL" datasource="#Session.DSN#">
			select PCEMid, count(1) as cantidad
			  from PCNivelMascara m
			 where (
					select count(1)
					  from CPresupuesto cp
						inner join CtasMayor my
							 on my.Ecodigo = cp.Ecodigo
							and my.Cmayor  = cp.Cmayor
							#preserveSingleQuotes(LvarWhereMY)#
						inner join CPVigencia vg
						   on vg.Ecodigo	= cp.Ecodigo
						  and vg.Cmayor 	= cp.Cmayor
						  and vg.CPVid 		= cp.CPVid
						  and #rsPeriodo.CPPanoMesDesde# between vg.CPVdesdeAnoMes and vg.CPVhastaAnoMes
					 where cp.Ecodigo = #session.Ecodigo#
					   and vg.PCEMid = m.PCEMid
					   #preserveSingleQuotes(LvarWhereCP)#
					) > 0
			   and PCNpresupuesto = 1
			group by PCEMid
			order by 2
		</cfquery>
		<cfset LvarNiveles = rsSQL.cantidad>

		<cfif NOT LvarFiltroCortes>
			<cfparam name="form.chkCorte#LvarRptDef.CortesN#" default="1">
		</cfif>

		<cfset LvarNivelCta = 0>
		<cfloop index="i" from="1" to="#LvarRptDef.CortesN#">
			<cfset LarrCorte = listToArray(LvarRptDef.Cortes[i],"·")>
			<cfif LarrCorte[1] EQ "1" AND LarrCorte[2] NEQ "0">
				<cfset LvarNivelCta = i>
				<cfbreak>
			</cfif>
		</cfloop>

		<cfparam name="form.chkTotalizarNiveles" default="0">
		<cfif form.chkTotalizarNiveles EQ "1">
			<cfif NOT isDefined("form.chkCorte#LvarNivelCta#")>
				<cfset form.chkTotalizarNiveles="0">
			<cfelseif LvarNivelCta NEQ LvarRptDef.CortesN>
				<!--- Esto se puede solucionar insertando los nuevos niveles en medio y no al final, y actualizando las referencias en DATOS --->
				<cfthrow message="Sólo se puede totalizar niveles si el último corte es el de Cuenta">
			</cfif>
			<cfif LvarNiveles EQ "">
				<cfset form.chkTotalizarNiveles="0">
			</cfif>
		</cfif>
		<cfif form.chkTotalizarNiveles EQ 1>
			<cfif form.CPCNivel NEQ "U" AND LvarNiveles GT form.CPCNivel>
				<cfset LvarNiveles = form.CPCNivel>
			</cfif>
			<cfset LvarHayCorteXmayor = false>
			<cfloop index="i" from="1" to="#LvarRptDef.CortesN#">
				<cfset LarrCorte = listToArray(LvarRptDef.Cortes[i],"·")>
				<cfif LarrCorte[1] EQ "1" AND LarrCorte[2] eq "0">
					<cfset LvarHayCorteXmayor = true>
					<cfbreak>
				</cfif>
			</cfloop>
			<cfif NOT LvarHayCorteXmayor>
				<cfset LvarRptDef.Cortes[LvarRptDef.CortesN] = "1·0">
				<cfset LvarIni = 1>
			<cfelse>
				<cfset LvarRptDef.Cortes[LvarRptDef.CortesN] = "1·1">
				<cfset LvarIni = 2>
			</cfif>
			<cfloop index="j" from="#LvarIni#" to="#LvarNiveles#">
				<cfset LvarRptDef.CortesN ++>
				<cfif j EQ LvarNiveles AND j LT form.CPCNivel>
					<cfset LvarRptDef.Cortes[LvarRptDef.CortesN] = "1·U">
				<cfelse>
					<cfset LvarRptDef.Cortes[LvarRptDef.CortesN] = "1·#j#">
				</cfif>
				<cfset LvarWhereNivel[LvarRptDef.CortesN] = "">
				<cfparam name="form.chkCorte#LvarRptDef.CortesN#" default="1">
				<cfif isdefined ("LvarNuevoOrdenCortes")>
					<cfset LvarNuevoOrdenCortes[LvarRptDef.CortesN] = structNew()>
					<cfset LvarNuevoOrdenCortes[LvarRptDef.CortesN].Idx = LvarRptDef.CortesN>
					<cfset LvarNuevoOrdenCortes[LvarRptDef.CortesN].Ord = LvarRptDef.CortesN>
				</cfif>
			</cfloop>
			<cfset form.CPCNivel = 1>
		<cfelse>
			<cfif form.CPCNivel NEQ "U" AND LvarNiveles LT form.CPCNivel>
				<cfset form.CPCNivel = "U"> 
				<cfloop index="i" from="1" to="#LvarRptDef.CortesN#">
					<cfset LarrCorte = listToArray(LvarRptDef.Cortes[i],"·")>
					<cfif LarrCorte[1] EQ "1" AND LarrCorte[2] NEQ "0">
						<cfset LvarRptDef.Cortes[i] = "1·U">
						<cfbreak>
					</cfif>
				</cfloop>
			</cfif>
		</cfif>
	</cfif>
</cffunction>

<cffunction name="fnSustituirMacros" returntype="string">
	<cfargument name="Definicion" 	type="string">
	<cfargument name="Tipo" 		type="numeric">

	<cfif Arguments.Definicion EQ "[]">
		<cfset Arguments.Definicion = "">
	<cfelse>
		<cfset Arguments.Definicion = replace(Arguments.Definicion,"[DES]", rsReporte.CPRdescripcion,"ALL")>
		<cfset Arguments.Definicion = replace(Arguments.Definicion,"[EMP]", rsEmpresa.Edescripcion,"ALL")>
		<cfset Arguments.Definicion = replace(Arguments.Definicion,"[EMPMAY]", ucase(rsEmpresa.Edescripcion),"ALL")>
		<cfset Arguments.Definicion = replace(Arguments.Definicion,"[]", " ","ALL")>
		<cfset Arguments.Definicion = replace(Arguments.Definicion,"[TIPOCTA]", "my.Ctipo","ALL")>
		<cfset Arguments.Definicion = replace(Arguments.Definicion,"[CF]", LvarCF,"ALL")>
		<cfset Arguments.Definicion = replace(Arguments.Definicion,"[CFMAY]", ucase(LvarCF),"ALL")>
		<cfset Arguments.Definicion = replace(Arguments.Definicion,"[TEMPORAL]", fnTemporal(),"ALL")>
		<cfset Arguments.Definicion = replace(Arguments.Definicion,"[TIPOCUENTA]", fnTipoCta(),"ALL")>
		<cfset Arguments.Definicion = replace(Arguments.Definicion,"[TIPOCUENTAMAY]", ucase(fnTipoCta()),"ALL")>

		<cfif isdefined("LvarRANGO_FEC")>
			<cfset Arguments.Definicion = replace(Arguments.Definicion,"[RANGO_FEC]", "(#LvarRANGO_FEC#)","ALL")>
		</cfif>
		<cfif isdefined("LvarRANGO_ANT")>
			<cfset Arguments.Definicion = replace(Arguments.Definicion,"[RANGO_ANT]", "(#LvarRANGO_ANT#)","ALL")>
		</cfif>
		<cfif isdefined("LvarMes")>
			<cfset Arguments.Definicion = replace(Arguments.Definicion,"[MES]", LvarMes,"ALL")>
			<cfset Arguments.Definicion = replace(Arguments.Definicion,"[MESMAY]", fnNombreMes(LvarMes, true),"ALL")>
			<cfset Arguments.Definicion = replace(Arguments.Definicion,"[MESMIN]", fnNombreMes(LvarMes, false),"ALL")>
			<cfset Arguments.Definicion = replace(Arguments.Definicion,"[ANO]", LvarAno,"ALL")>
			<cfset Arguments.Definicion = replace(Arguments.Definicion,"[ANOANT]", LvarAno-1,"ALL")>
		</cfif>
		<cfif Arguments.Tipo EQ 3 OR Arguments.Tipo EQ 4 OR Arguments.Tipo EQ 5>
			<cfset Arguments.Definicion = replace(Arguments.Definicion,"[MESINIMAY]", fnNombreMes(DatePart("m",rsPeriodo.CPPfechaDesde),true),"ALL")>
			<cfset Arguments.Definicion = replace(Arguments.Definicion,"[MESINIMIN]", fnNombreMes(DatePart("m",rsPeriodo.CPPfechaDesde),false),"ALL")>
			<cfset Arguments.Definicion = replace(Arguments.Definicion,"[MESFINMAY]", fnNombreMes(DatePart("m",rsPeriodo.CPPfechaHasta),true),"ALL")>
			<cfset Arguments.Definicion = replace(Arguments.Definicion,"[MESFINMIN]", fnNombreMes(DatePart("m",rsPeriodo.CPPfechaHasta),false),"ALL")>
			<cfset Arguments.Definicion = replace(Arguments.Definicion,"[ANOINI]", DatePart("yyyy",rsPeriodo.CPPfechaDesde),"ALL")>
			<cfset Arguments.Definicion = replace(Arguments.Definicion,"[ANOFIN]", DatePart("yyyy",rsPeriodo.CPPfechaHasta),"ALL")>
			<cfset Arguments.Definicion = replace(Arguments.Definicion,"[PER]", rsPeriodo.Pdescripcion,"ALL")>
		</cfif>
		<cfset Arguments.Definicion = fnSutituirTipoDato(Arguments.Definicion,(Arguments.Tipo EQ 7 or Arguments.Tipo EQ 8))>
		<cfif Arguments.Tipo EQ 7 or Arguments.Tipo EQ 8>
			<!--- 
				Se sustituyen las SUPER MACROS por las formulas de MACROS
			--->
			<cfif find("[*",Arguments.Definicion) GT 0>
				<cfset Arguments.Definicion = replace(Arguments.Definicion,"[*DCF]","([*PF]-[*PC])","ALL")>
				<cfset Arguments.Definicion = replace(Arguments.Definicion,"[*DCP]","([*PP]-[*PC])","ALL")>
				<cfset Arguments.Definicion = replace(Arguments.Definicion,"[*DCA]","([*PA]-[*PC])","ALL")>

				<cfset Arguments.Definicion = replace(Arguments.Definicion,"[*DEF]","([*PF]-[ET])","ALL")>
				<cfset Arguments.Definicion = replace(Arguments.Definicion,"[*DEP]","([*PP]-[ET])","ALL")>
				<cfset Arguments.Definicion = replace(Arguments.Definicion,"[*DEA]","([*PA]-[ET])","ALL")>

				<cfset Arguments.Definicion = replace(Arguments.Definicion,"[*DN]","([*PA]-[*PC]+[NP])","ALL")>
				<cfset Arguments.Definicion = replace(Arguments.Definicion,"[*PA]","([*PP]+[ME])","ALL")>
				<cfset Arguments.Definicion = replace(Arguments.Definicion,"[*PP]","([*PF]+[T]+[TE]+[VC])","ALL")>
				<cfset Arguments.Definicion = replace(Arguments.Definicion,"[*PF]","([A]+[M])","ALL")>

				<cfset Arguments.Definicion = replace(Arguments.Definicion,"[*PC]","([*PCA]+[RP])","ALL")>
				<cfset Arguments.Definicion = replace(Arguments.Definicion,"[*PCA]","([*RT]+[*CT]+[ET])","ALL")>
				<cfset Arguments.Definicion = replace(Arguments.Definicion,"[*RT]","([RA]+[RC])","ALL")>
				<cfset Arguments.Definicion = replace(Arguments.Definicion,"[*CT]","([CA]+[CC])","ALL")>
				<cfset Arguments.Definicion = replace(Arguments.Definicion,"[*FE]","([P]+[EJ])","ALL")>
			</cfif>

			<cfif Arguments.Tipo EQ 7>
				<!--- 
					Se sustituyen los MACROS utilizados en formulas por COLUMNAS del query
					Si se utilizan CAMPOS que no corresponden a COLUMNAS da error
					DATO : DIMENSION TEMPORAL·TITULO·EXPRESION
				--->
				<cfset LvarDatos = listToArray(Arguments.Definicion,"¦")>
				<cfloop index="d1" from="1" to="#arrayLen(LvarDatos)#">
					<cfset LvarDatosI = listToArray(LvarDatos[d1],"·")>
					<cfset LvarDato1 = LvarDatosI[3]>
					<cfif mid(LvarDato1,1,1) EQ "*" OR mid(LvarDato1,1,1) EQ "%">
						<cfloop index="d2" from="1" to="#arrayLen(LvarDatos)#">
							<cfif compare(d1, d2) NEQ 0>
								<cfset LvarDato2 = listGetAt(LvarDatos[d2],3,"·")>
								<cfif NOT (mid(LvarDato2,1,1) EQ "*" OR mid(LvarDato2,1,1) EQ "%")>
									<cfset LvarPto = find (LvarDato2,LvarDato1)>
									<cfloop condition="LvarPto GT 0">
										<cfset LvarDato1 	= mid(LvarDato1,1,LvarPto-1)
															& "Dato#d2#"
															& mid(LvarDato1,LvarPto+len(LvarDato2),4096)
										>
										<cfset LvarPto = find (LvarDato2,LvarDato1)>
									</cfloop>
								</cfif>
							</cfif>
						</cfloop>
						<cfset LvarPto = find("[",replace(replace(replace(LvarDato1,"[DATO","","ALL"),"[C","","ALL"),"[T","","ALL"))>
						<cfif LvarPto GT 0>
							<cf_errorCode	code = "50540"
											msg  = "Dato@errorDat_1@ es una formula que utiliza [MACROS] que no están como columnas:<BR>@errorDat_2@"
											errorDat_1="#d1#"
											errorDat_2="#LvarDato1#"
							>
						</cfif>
						<cfset LvarDatosI[3] = LvarDato1>
						<cfset LvarDatos[d1] = arrayToList(LvarDatosI,"·")>
					</cfif>
				</cfloop>
				<cfset Arguments.Definicion = arrayToList(LvarDatos,"¦")>
			</cfif>
			
			<!--- 
				Se sustituyen las MACROS por nombres de CAMPOS
			--->
			<!--- E1=Devengado=Ejecutado no Ejercido ni pagado=	si [EJ]<>0 then [ET]-[EJ] else [ET]-[P] --->
			<!--- E2=Ejercido=Ejercido no pagado=				si [EJ]<>0 then [EJ]-[P] else 0 --->
			<cfset Arguments.Definicion = replace(Arguments.Definicion,"[SGDB]", "case my.Cbalancen when 'D' then +1 else -1 end","ALL")>
			<cfset Arguments.Definicion = replace(Arguments.Definicion,"[SGCR]", "case my.Cbalancen when 'D' then -1 else +1 end","ALL")>
			<cfset Arguments.Definicion = replace(Arguments.Definicion,"[A]" ,"m.CPCpresupuestado","ALL")>
			<cfset Arguments.Definicion = replace(Arguments.Definicion,"[M]" ,"m.CPCmodificado","ALL")>
			<cfset Arguments.Definicion = replace(Arguments.Definicion,"[VC]","m.CPCvariacion","ALL")>
			<cfset Arguments.Definicion = replace(Arguments.Definicion,"[ME]","m.CPCmodificacion_Excesos","ALL")>
			<cfset Arguments.Definicion = replace(Arguments.Definicion,"[T]" ,"m.CPCtrasladado","ALL")>
			<cfset Arguments.Definicion = replace(Arguments.Definicion,"[TE]","m.CPCtrasladadoE","ALL")>
			<cfset Arguments.Definicion = replace(Arguments.Definicion,"[RA]","m.CPCreservado_Anterior","ALL")>
			<cfset Arguments.Definicion = replace(Arguments.Definicion,"[CA]","m.CPCcomprometido_Anterior","ALL")>
			<cfset Arguments.Definicion = replace(Arguments.Definicion,"[RP]","m.CPCreservado_Presupuesto","ALL")>
			<cfset Arguments.Definicion = replace(Arguments.Definicion,"[RC]","m.CPCreservado","ALL")>
			<cfset Arguments.Definicion = replace(Arguments.Definicion,"[CC]","m.CPCcomprometido","ALL")>
			<cfset Arguments.Definicion = replace(Arguments.Definicion,"[NP]","m.CPCnrpsPendientes","ALL")>

			<cfset Arguments.Definicion = replace(Arguments.Definicion,"[E3]","case when [EJ]<>0 then [ET]-[EJ] else [ET]-[P] end","ALL")>
			<cfset Arguments.Definicion = replace(Arguments.Definicion,"[EJ3]","case when [EJ]<>0 then [EJ]-[P] else 0 end","ALL")>
			<cfset Arguments.Definicion = replace(Arguments.Definicion,"[ET]" ,"([E]+[E2])","ALL")>
			<cfset Arguments.Definicion = replace(Arguments.Definicion,"[E]" ,"m.CPCejecutado","ALL")>
			<cfset Arguments.Definicion = replace(Arguments.Definicion,"[E2]" ,"m.CPCejecutadoNC","ALL")>
			<cfset Arguments.Definicion = replace(Arguments.Definicion,"[P]" ,"m.CPCpagado","ALL")>
			<cfset Arguments.Definicion = replace(Arguments.Definicion,"[EJ]","m.CPCejercido","ALL")>

			<cfset LvarPto1 = find("[C",Arguments.Definicion)>
			<cfloop condition="LvarPto1 GT 0">
				<cfset LvarPto2 = find("]",Arguments.Definicion, LvarPto1)>
				<cfset Arguments.Definicion = mid(Arguments.Definicion,1,LvarPto1-1) & "Dato" & mid(Arguments.Definicion,LvarPto1 + 2,LvarPto2-LvarPto1-2) & mid(Arguments.Definicion,LvarPto2+1,4096)>

				<cfset LvarPto1 = find("[C",Arguments.Definicion)>
			</cfloop>
		</cfif>
	</cfif>

	<cfreturn Arguments.Definicion>
</cffunction>

<cffunction name="fnTemporal" returntype="string">
	<cfif isdefined("form.CPCtemporal")>
		<cfif form.CPCtemporal EQ 1>
			<cfreturn "MENSUALES">
		<cfelseif form.CPCtemporal EQ 2>
			<cfreturn "ACUMULADOS">
		<cfelseif form.CPCtemporal EQ 3>
			<cfreturn "TOTALES">
		</cfif>
	<cfelse>
		<cfreturn "[NO SE DEFINIO FILTRO POR DIMENSION TEMPORAL]">
	</cfif>
</cffunction>

<cffunction name="fnSutituirTipoDato" returntype="string">
	<cfargument name="Definicion" 	type="string">
	<cfargument name="EnDatos" 		type="boolean">

	<cfif not Arguments.EnDatos>
		<cfset Arguments.Definicion = replace(Arguments.Definicion,"[TIPODATO]", fnTipoDato(Arguments.EnDatos),"ALL")>
		<cfset Arguments.Definicion = replace(Arguments.Definicion,"[TIPODATOMAY]", ucase(fnTipoDato(Arguments.EnDatos)),"ALL")>
	</cfif>
	
	<cfset LvarPto1 = find("[TIPODATO",Arguments.Definicion)>
	<cfloop condition="LvarPto1 GT 0">
		<cfset LvarPto2 = find("]",Arguments.Definicion,LvarPto1+1)>
		<cfif LvarPto2 GT 0>
			<cfset LvarTipo = mid(Arguments.Definicion,LvarPto1, LvarPto2-LvarPto1+1)>
			<cfset LvarPto3 = find("-",LvarTipo)>
			<cfif LvarPto3 GT 0>
				<cfset LvarPto3 = mid(LvarTipo,LvarPto3+1, len(LvarTipo)-LvarPto3-1)>
				<cfif find("[TIPODATO-",LvarTIPO) EQ 1 AND isnumeric(LvarPto3)>
					<cfset Arguments.Definicion = replace(Arguments.Definicion,LvarTipo, fnTipoDato(Arguments.EnDatos, evaluate("form.Dato#LvarPto3#")))>
				<cfelseif find("[TIPODATOMAY-",LvarTIPO) EQ 1 AND isnumeric(LvarPto3)>
					<cfset Arguments.Definicion = replace(Arguments.Definicion,LvarTipo, ucase(fnTipoDato(Arguments.EnDatos, evaluate("form.Dato#LvarPto3#"))))>
				</cfif>
			</cfif>
		</cfif>

		<cfset LvarPto1 = find("[TIPODATO",Arguments.Definicion,LvarPto1+1)>
	</cfloop>

	<cfset LvarPto1 = find("[DATO-",Arguments.Definicion)>
	<cfloop condition="LvarPto1 GT 0">
		<cfset LvarPto2 = find("]",Arguments.Definicion,LvarPto1+1)>
		<cfif LvarPto2 GT 0>
			<cfset LvarTipo = mid(Arguments.Definicion,LvarPto1, LvarPto2-LvarPto1+1)>
			<cfset LvarPto3 = mid(LvarTipo,7,len(LvarTipo)-7)>
			<cfif isnumeric(LvarPto3)>
				<cfset Arguments.Definicion = replace(Arguments.Definicion,LvarTipo, evaluate("form.Dato#LvarPto3#"))>
			</cfif>
		</cfif>

		<cfset LvarPto1 = find("[DATO-",Arguments.Definicion,LvarPto1+1)>
	</cfloop>
	<cfreturn Arguments.Definicion>
</cffunction>		

<cffunction name="fnTipoDato" returntype="string">
	<cfargument name="Corto" 		type="Boolean"	required="yes">
	<cfargument name="Tipo" 		type="string"	default="">

	<cfif Arguments.Tipo NEQ "">
		<cfset LvarTipoDato = Arguments.Tipo>
	<cfelse>
		<cfif not isdefined("LvarRptDef.Filtros")>
			<cfset LvarDefinicion 	= ListToArray(rsReporte.CPRdefinicion, LvarNL)>
			<cfset LvarRptDef.Filtros = listToArray(LvarDefinicion[8],"¦")>
		</cfif>
		<cfloop index="i" from="1" to="#arrayLen(LvarRptDef.Filtros)#">
			<cfset LvarFiltro = listToArray(LvarRptDef.Filtros[i],"·")>
			<cfif LvarFiltro[1] EQ 6>
				<cfset LvarTipoDato = evaluate("form.Dato#LvarFiltro[2]#")>
				<cfbreak>
			</cfif>
		</cfloop>
	</cfif>
	
	<cfif isdefined("LvarTipoDato")>
		<cfif Arguments.Corto>
			<cfif LvarTipoDato EQ "[A]">
				<cfreturn "Ordinario">
			<cfelseif LvarTipoDato EQ "[M]">
				<cfreturn "Modificiones">
			<cfelseif LvarTipoDato EQ "[*PF]">
				<cfreturn "Formulado">
			<cfelseif LvarTipoDato EQ "[T]">
				<cfreturn "Trasladado">
			<cfelseif LvarTipoDato EQ "[TE]">
				<cfreturn "Trasladado<BR>Aut.Ext.">
			<cfelseif LvarTipoDato EQ "[VC]">
				<cfreturn "Var.Cambiaria">
			<cfelseif LvarTipoDato EQ "[*PP]">
				<cfreturn "Planeado">
			<cfelseif LvarTipoDato EQ "[ME]">
				<cfreturn "Excesos">
			<cfelseif LvarTipoDato EQ "[*PA]">
				<cfreturn "Autorizado">

			<cfelseif LvarTipoDato EQ "[*RT]">
				<cfreturn "Reservado<BR>Total">
			<cfelseif LvarTipoDato EQ "[RA]">
				<cfreturn "Reservado<BR>Per.Ants.">
			<cfelseif LvarTipoDato EQ "[RC]">
				<cfreturn "Reservado">
			<cfelseif LvarTipoDato EQ "[*CT]">
				<cfreturn "Comprometido<BR>Total">
			<cfelseif LvarTipoDato EQ "[CA]">
				<cfreturn "Comprometido<BR>Per.Ants.">
			<cfelseif LvarTipoDato EQ "[CC]">
				<cfreturn "Comprometido">

			<cfelseif LvarTipoDato EQ "[*PCA]">
				<cfreturn "Consumido<BR>Auxiliar/Conta">
			<cfelseif LvarTipoDato EQ "[RP]">
				<cfreturn "Provisiones">
			<cfelseif LvarTipoDato EQ "[*PC]">
				<cfreturn "Consumido">
			<cfelseif LvarTipoDato EQ "[NP]">
				<cfreturn "Rechazos Sin&nbsp;Aplicar">
			<cfelseif LvarTipoDato EQ "[*DN]">
				<cfreturn "Dispon.Neto">

			<cfelseif LvarTipoDato EQ "[ET]">
				<cfreturn "Ejecutado Total">
			<cfelseif LvarTipoDato EQ "[E]">
				<cfreturn "Ejecutado Contable">
			<cfelseif LvarTipoDato EQ "[E2]">
				<cfreturn "Ejecutado No&nbsp;Contable">
			<cfelseif LvarTipoDato EQ "[E3]">
				<cfreturn "Devengado No&nbsp;Pagado">
			<cfelseif LvarTipoDato EQ "[EJ]">
				<cfreturn "Ejercido Total">
			<cfelseif LvarTipoDato EQ "[EJ3]">
				<cfreturn "Ejercido No&nbsp;Pagado">
			<cfelseif LvarTipoDato EQ "[P]">
				<cfreturn "Pagado">
			</cfif>
		<cfelse>
			<cfif LvarTipoDato EQ "[A]">
				<cfreturn "Presupuesto Ordinario">
			<cfelseif LvarTipoDato EQ "[M]">
				<cfreturn "Modificación Presupuesto Extraordinario">
			<cfelseif LvarTipoDato EQ "[*PF]">
				<cfreturn "Presupuesto Formulado">
			<cfelseif LvarTipoDato EQ "[T]">
				<cfreturn "Traslados Presupuestarios">
			<cfelseif LvarTipoDato EQ "[TE]">
				<cfreturn "Traslados con<BR>Autorización Externa">
			<cfelseif LvarTipoDato EQ "[VC]">
				<cfreturn "Variación Cambiaria">
			<cfelseif LvarTipoDato EQ "[*PP]">
				<cfreturn "Presupuesto Planeado">
			<cfelseif LvarTipoDato EQ "[ME]">
				<cfreturn "Excesos Autorizados">
			<cfelseif LvarTipoDato EQ "[*PA]">
				<cfreturn "Presupuesto Autorizado">

			<cfelseif LvarTipoDato EQ "[*RT]">
				<cfreturn "Reservado Total<BR>Período Actual y Anteriores">
			<cfelseif LvarTipoDato EQ "[RA]">
				<cfreturn "Reservado del Período Anteriores">
			<cfelseif LvarTipoDato EQ "[RC]">
				<cfreturn "Presupuesto Reservado">
			<cfelseif LvarTipoDato EQ "[*CT]">
				<cfreturn "Comprometido Total<BR>Período Actual y Anteriores">
			<cfelseif LvarTipoDato EQ "[CA]">
				<cfreturn "Comprometido del Período Anteriores">
			<cfelseif LvarTipoDato EQ "[CC]">
				<cfreturn "Presupuesto Comprometido">

			<cfelseif LvarTipoDato EQ "[*PCA]">
				<cfreturn "Presupuesto Consumido de Auxiliar/Conta">
			<cfelseif LvarTipoDato EQ "[RP]">
				<cfreturn "Provisiones Presupuestarias">
			<cfelseif LvarTipoDato EQ "[*PC]">
				<cfreturn "Presupuesto Consumido">
			<cfelseif LvarTipoDato EQ "[NP]">
				<cfreturn "Rechazos Aprobados Pendientes de Aplicar">
			<cfelseif LvarTipoDato EQ "[*DN]">
				<cfreturn "Disponible Neto">

			<cfelseif LvarTipoDato EQ "[ET]">
				<cfreturn "Presupuesto Ejecutado Total">
			<cfelseif LvarTipoDato EQ "[E]">
				<cfreturn "Presupuesto Ejecutado Contable">
			<cfelseif LvarTipoDato EQ "[E2]">
				<cfreturn "Presupuesto Ejecutado No Contable">
			<cfelseif LvarTipoDato EQ "[E3]">
				<cfreturn "Presupuesto Devengado No Pagado">
			<cfelseif LvarTipoDato EQ "[EJ]">
				<cfreturn "Presupuesto Ejercido Total">
			<cfelseif LvarTipoDato EQ "[EJ3]">
				<cfreturn "Presupuesto Ejercido No Pagado">
			<cfelseif LvarTipoDato EQ "[P]">
				<cfreturn "Presupuesto Pagado">
			</cfif>
		</cfif>
	<cfelse>
		<cfreturn "[NO SE DEFINIO FILTRO POR TIPO DATO]">
	</cfif>
</cffunction>

<cffunction name="fnTipoCta" returntype="string">
	<cfif isdefined("form.CPCtipoCta")>
		<cfif form.CPCtipoCta EQ "">
			<cfreturn "Cualquier Tipo">
		<cfelseif form.CPCtipoCta EQ "G">
			<cfreturn "Gastos">
		<cfelseif form.CPCtipoCta EQ "I">
			<cfreturn "Ingresos">
		<cfelseif form.CPCtipoCta EQ "A">
			<cfreturn "Activos">
		<cfelseif form.CPCtipoCta EQ "P">
			<cfreturn "Pasivos">
		<cfelseif form.CPCtipoCta EQ "C">
			<cfreturn "Capital">
		<cfelseif form.CPCtipoCta EQ "O">
			<cfreturn "Ctas de Orden">
		</cfif>
	<cfelse>
		<cfreturn "[NO SE DEFINIO FILTRO POR TIPO DE CUENTA]">
	</cfif>
</cffunction>



