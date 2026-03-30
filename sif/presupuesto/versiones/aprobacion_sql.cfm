<cfsetting requesttimeout="36000">
<cflock scope="session" type="exclusive" timeout="5" throwontimeout="yes">
	<cfif session.CFaprobacion.Paso NEQ -1001><cfabort></cfif>
	<cfset session.CFaprobacion.Paso = 0>
</cflock>
<cfsetting enablecfoutputonly="yes">
<cfif isdefined("url.MesesAnt")>
	<cfset request.CFaprobacion_MesesAnt = true>
</cfif>
<!--- Obtiene la Moneda de la Empresa --->
<cftry>
<cflog type="information" file="FormulacionAplica" text="================================================================">
<cflog type="information" file="FormulacionAplica" text="INICIO PASO 0">
	<cfquery name="qry_monedaEmpresa" datasource="#session.dsn#">
		select Mcodigo
		  from Empresas 
		 where Ecodigo = #session.Ecodigo#
	</cfquery>
	
	<cfscript>
		sbDesactivaTs_rversion ("CVMayor");
		sbDesactivaTs_rversion ("CVPresupuesto");
		sbDesactivaTs_rversion ("CVFormulacionTotales");
		sbDesactivaTs_rversion ("CVFormulacionMonedas");
	
		sbDesactivaTs_rversion ("CPresupuesto");
		sbDesactivaTs_rversion ("CPresupuestoControl");
		sbDesactivaTs_rversion ("CPControlMoneda");
	</cfscript>
	
		<!--- Obtiene el tipo de Periodo de Presupuesto --->
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select 	v.CVid, v.CVtipo, 
					p.CPPid, p.CPPfechaDesde, p.CPPfechaHasta,
					v.RHEid
			  from CVersion v
					INNER JOIN CPresupuestoPeriodo p
						ON p.CPPid = v.CPPid
			 where v.Ecodigo 	= #session.Ecodigo#
			   and CVid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CVid#">
		</cfquery>
		
		<cfset LvarCVid 	= rsSQL.CVid>
		<cfset LvarRHEid 	= rsSQL.RHEid>
		<cfset LvarCPPid 	= rsSQL.CPPid>
		<cfset LvarFechaIni = rsSQL.CPPfechaDesde>
		<cfset LvarFechaFin = rsSQL.CPPfechaHasta>

		<cfset LvarAprobacion = rsSQL.CVtipo EQ "1">
	
		<cfset LvarFecha	= LvarFechaIni>
		<cfset LvarAno		= datepart("yyyy",LvarFechaIni)>
		<cfset LvarMes		= datepart("m",LvarFechaIni)>

		<cfif LvarRHEid NEQ "">
			<cfquery name="rsRHEscenario" datasource="#session.dsn#">
				select RHEestado, Ecodigo
				  from RHEscenarios
				 where RHEid = #LvarRHEid#
			</cfquery>
			<cfif rsRHEscenario.Ecodigo NEQ #session.Ecodigo#>
				<cf_errorCode	code = "50547" msg = "La Version de Formulación Presupuestaria está asociada a un Escenario de Planilla Presupuestaria de otra Empresa">
			<cfelseif rsRHEscenario.RHEestado NEQ "V">
				<cf_errorCode	code = "50548" msg = "La Version de Formulación Presupuestaria está asociada a un Escenario de Planilla Presupuestaria que no está en Versión Generada">
			</cfif>
		</cfif>
		
		<cfif LvarAprobacion>
			<cfquery name="rsSQL" datasource="#session.dsn#">
				select count(1) as cantidad
				  from CPresupuestoPeriodo p
				 where Ecodigo 	= #session.Ecodigo#
				   and CPPestado = 1
				   and CPPid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCPPid#">
			</cfquery>
			<cfif rsSQL.cantidad GT 1>
				<cf_errorCode	code = "50549" msg = "Ya existe más de un Período de Presupuesto Abierto. Para aprobar y abrir el Período Actual, debe primero Liquidar un Período abierto">
			</cfif>
		<cfelse>
			<!--- Obtiene el mes de Auxiliares --->
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

			<!--- Si el Mes de Auxiliares está dentro del Período de Presupuesto --->
			<cfset LvarFechaAux = createDate(LvarAuxAno,LvarAuxMes,1)>
			<cfif LvarFechaAux GTE LvarFechaIni AND LvarFechaAux LTE LvarFechaFin>
				<cfset LvarAno = datepart("yyyy",LvarFechaAux)>
				<cfset LvarMes = datepart("m",LvarFechaAux)>
				<cfif datepart("yyyy",now()) EQ LvarAno AND datepart("m",now()) EQ LvarMes>
					<cfset LvarFecha = createODBCdate(now())>
				<cfelse>
					<cfset LvarFecha = LvarFechaAux>
				</cfif>
			</cfif>
		</cfif>	
        
      <cfquery name="rsTipoControl" datasource="#session.dsn#">
        select Pvalor as value
         from Parametros
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
         and Pcodigo = 1120
      </cfquery>
      
      <!---(No Permite Cuentas con Tipo de Control Restringido)--->
      <cfif rsTipoControl.value EQ 'N'>
            <cfquery name="rsCRestringidas" datasource="#session.dsn#">
                select count(1) as cantidad
                from CVPresupuesto 
                where Ecodigo	= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                  and CVid		= <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarCVid#">
                  and CVPtipoControl = 1
            </cfquery>
      
			<cfif rsCRestringidas.cantidad GT 0>
				<cfthrow message="Parametros generales. No se permiten Cuentas con Control Restringido.">
			</cfif>
      </cfif>   

	<!--- Crea la tabla temporal para Control de Presupuesto --->
	<cfset LobjControl = createObject( "component","sif.Componentes.PRES_Presupuesto")>
	<cfset LobjControl.CreaTablaIntPresupuesto(#session.dsn#,true,true,true)>
	
	<cfset LvarTipPres = LobjControl.fnTipoPresupuesto(LvarCPPid,"my.Ctipo","cvp",false)>
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select DISTINCT #preserveSingleQuotes(LvarTipPres)# as TipoPres
		  from CVPresupuesto cvp
		  	inner join CtasMayor my
				 on my.Ecodigo = cvp.Ecodigo
				and my.Cmayor  = cvp.Cmayor
		 where cvp.Ecodigo	= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		   and cvp.CVid 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarCVid#">
	</cfquery>
	<cfset LvarTiposI = 0>
	<cfset LvarTiposE = 0>
	<cfloop query="rsSQL">
		<cfif rsSQL.TipoPres EQ "X">
			<cfthrow message="FORMULACION DE PRESUPUESTO: No se permite Formular cuentas de EXCLUSION">
		<cfelseif rsSQL.TipoPres EQ "I">
			<cfset LvarTiposI = LvarTiposI + 1>
		<cfelse>
			<cfset LvarTiposE = LvarTiposE + 1>
		</cfif>
	</cfloop>
	<cfif LvarTiposI GT 0 and LvarTiposE GT 0>
		<cfthrow message="FORMULACION DE PRESUPUESTO: No se permite Formular cuentas de INGRESOS Y EGRESOS en la misma versión">
	</cfif>
<cflog type="information" file="FormulacionAplica" text="INICIO PASO 1">
	<!--- Obtiene las Cuentas de Presupuesto existentes (correspondientes a las cuentas de Version) --->
	<!--- Actualiza los tipos de Cambio Proyectados por Mes y actualiza el monto a aplicar--->
	<!--- Actualiza los Totales de Formulacion por Cuenta+Año+Mes+Oficina (sin Moneda) --->
	<cfset session.CFaprobacion.Paso = 1>
	
	<cftransaction>
	<cfset LobjAjuste = createObject( "component","sif.Componentes.PRES_Formulacion")>
	<cfset LobjAjuste.AjustaFormulacion(LvarCVid,-1,-1,-1,-1,isdefined("LvarVerifArranque"))>

	<!--- Permitir Formulaciones Negativas --->
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select Pvalor
		  from Parametros
		 where Ecodigo = #session.Ecodigo#
		   and Pcodigo = 1121
	</cfquery>
	<cfif rsSQL.Pvalor NEQ "S" AND NOT isdefined("request.CFaprobacion_MesesAnt")>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select 	case when c.CPcuenta IS NOT NULL then
						(select CPformato from CPresupuesto where CPcuenta = c.CPcuenta)
					else
						c.CPformato
					end as CPformato, c.CVPcuenta, CVFTmontoSolicitado
			  from CVFormulacionTotales t
				inner join CVPresupuesto c 
					 on c.Ecodigo	= t.Ecodigo
					and c.CVid		= t.CVid
					and c.CVPcuenta	= t.CVPcuenta
			 where t.Ecodigo 	= #session.Ecodigo#
			   and t.CVid 		= #LvarCVid#
			   and t.CVFTmontoSolicitado < 0
		</cfquery>
		<cfloop query="rsSQL">
			<cflog type="warning" file="FormulacionAplica" text="Formulaciones negativas: CVPcuenta #rsSQL.CVPcuenta#, cuenta #rsSQL.CPformato#, solicitado #numberFormat(rsSQL.CVFTmontoSolicitado,",9.99")#">
		</cfloop>
		<cfif rsSQL.recordCount NEQ 0>
			<cfthrow message="FORMULACION DE PRESUPUESTO: No se permite solicitar Formulaciones negativas:<BR>cuenta #rsSQL.CPformato#, solicitado #numberFormat(rsSQL.CVFTmontoSolicitado,",9.99")# (ver log)">
		</cfif>
	</cfif>

<cflog type="information" file="FormulacionAplica" text="INICIO PASO 2">
	<cfset session.CFaprobacion.Paso = 2>
		<cfif isdefined("url.conFormulacion") AND url.conFormulacion EQ "1">
			<!--- 	Elimina las formulaciones por moneda donde no se va a aplicar ningun movimiento en ningun mes --->
			<cfquery datasource="#session.dsn#">
				delete from CVFormulacionMonedas
				 where Ecodigo 	= #session.Ecodigo#
				   and CVid 	= #LvarCVid#
				   and CVFMmontoAplicar = 0
			</cfquery>
		
			<!--- Elimina formulaciones totales sin formulaciones por moneda --->
			<cfquery datasource="#session.dsn#">
				delete from CVFormulacionTotales
				 where Ecodigo 	= #session.Ecodigo#
				   and CVid 	= #LvarCVid#
				   and not exists 
						(
							select 1 
							  from CVFormulacionMonedas fm
							 where fm.Ecodigo 	= CVFormulacionTotales.Ecodigo
							   and fm.CVid 		= CVFormulacionTotales.CVid
							   and fm.CPCano	= CVFormulacionTotales.CPCano
							   and fm.CPCmes	= CVFormulacionTotales.CPCmes
							   and fm.CVPcuenta	= CVFormulacionTotales.CVPcuenta
							   and fm.Ocodigo	= CVFormulacionTotales.Ocodigo
						)
			</cfquery>
		</cfif>
	
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select count(1) as cantidad
			  from CVFormulacionMonedas
			where Ecodigo 	= #session.Ecodigo#
			  and CVid 		= #LvarCVid#
			  and coalesce(CVFMtipoCambio,0.00) = 0.00
			  and CVFMmontoAplicar <> 0
		</cfquery>
		<cfif rsSQL.cantidad GT 0>
			<cf_errorCode	code = "50545" msg = "Falta definir Tipos de Cambio Proyectados por Mes">
		</cfif>
		
<cflog type="information" file="FormulacionAplica" text="INICIO PASO 3">
	<cfset session.CFaprobacion.Paso = 3>
		<!--- Ajusta Vigencias --->
		<!--- 
				Toma la menor Vigencia del Inicio del Periodo o que inicie despues del Inicio del Período 
				y la transforma en la última Vigencia:
				  Borra las Vigencias Posteriores
				  Si la Vigencia inicia despues del inicio del periodo ajusta la Fecha Inicial de la Vigencia al Inicio del Período
				  Ajusta la Fecha Final de la Vigencia al infinito.
		--->
		<cfquery name="rsNuevasVigencias" datasource="#session.dsn#">
			select m.Cmayor, vg.CPVid, vg.CPVdesdeAnoMes, vg.CPVhastaAnoMes
			  from CVMayor m
					inner join CPVigencia vg
						on vg.Ecodigo = m.Ecodigo
					   and vg.Cmayor  = m.Cmayor
					   and (#dateformat(LvarFechaIni,"YYYYMM")# between vg.CPVdesdeAnoMes and vg.CPVhastaAnoMes
							OR #dateformat(LvarFechaIni,"YYYYMM")# < vg.CPVdesdeAnoMes
							)
			where m.Ecodigo = #session.Ecodigo#
			  and m.CVid = #LvarCVid#
			order by vg.CPVdesdeAnoMes
		</cfquery>
		<cfset LvarCmayorAnt = "">
		<cfloop query="rsNuevasVigencias">
			<cfset LvarVigenciaID = rsNuevasVigencias.CPVid>
			<!--- Ajusta unicamente la primera vigencia, las demas las borra --->
			<cfif LvarCmayorAnt NEQ rsNuevasVigencias.Cmayor>
				<cfset LvarCmayorAnt = rsNuevasVigencias.Cmayor>
				<cfif rsNuevasVigencias.CPVdesdeAnoMes GT dateFormat(LvarFechaIni,"YYYYMM")>
					<!--- Si no esta vigente ajusta el desde al inicio del periodo --->
					<cfquery name="rsSQL" datasource="#session.dsn#">
						update CPVigencia
						   set CPVdesde = <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFechaIni#">,
							   CPVdesdeAnoMes = #dateformat(LvarFechaIni,"YYYYMM")#
						 where CPVid = #LvarVigenciaID#
					</cfquery>
				</cfif>
				<cfif rsNuevasVigencias.CPVhastaAnoMes NEQ "610001">
					<!--- Si no es la ultima vigencia ajusta el hasta al infinito y luego borra las siguientes vigencias --->
					<cfquery name="rsSQL" datasource="#session.dsn#">
						update CPVigencia
						   set CPVhasta = <cfqueryparam cfsqltype="cf_sql_date" value="#createDate(6100,1,1)#">,
							   CPVhastaAnoMes = 61000101
						 where CPVid = #LvarVigenciaID#
					</cfquery>
				</cfif>
			<cfelse>
				<!--- Borra las siguientes vigencias porque se ajusto la primera al infinito --->
				<cfquery name="rsSQL" datasource="#session.dsn#">
					delete from CPVigencia
					 where CPVid = #LvarVigenciaID#
				</cfquery>
			</cfif>
		</cfloop>
	
		<!--- Crea Nuevas Vigencias cuando cambia la Máscara Original --->
		<cfquery name="rsNuevasVigencias" datasource="#session.dsn#">
			select m.Cmayor, vg.CPVid, coalesce(m.PCEMidNueva,m.PCEMidOri,vg.PCEMid) as PCEMidNueva
			  from CVMayor m
					left outer join CPVigencia vg
						on vg.Ecodigo = m.Ecodigo
					   and vg.Cmayor  = m.Cmayor
					   and #dateformat(LvarFechaIni,"YYYYMM")# between vg.CPVdesdeAnoMes and vg.CPVhastaAnoMes
			where m.Ecodigo = #session.Ecodigo#
			  and m.CVid = #LvarCVid#
			  and coalesce(vg.PCEMid,-1) <> coalesce(m.PCEMidNueva,m.PCEMidOri,-1)	
		</cfquery>
		<cfloop query="rsNuevasVigencias">
			<cfset LvarVigenciaID = rsNuevasVigencias.CPVid>
			<!--- Actualizar Vigencia para utilizar la nueva máscara --->
			<cfquery name="rsSQL" datasource="#session.dsn#">
				select CPVhasta, CPVdesdeAnoMes, CPVhastaAnoMes
				  from CPVigencia
				where CPVid = #LvarVigenciaID#
			</cfquery>
			<!--- Se supone que pasa de Sin Máscara a Máscara o de Máscara a Máscara --->
			<!--- No se permite de Máscara a Sin Máscara --->
			<cfif rsNuevasVigencias.PCEMidNueva EQ "">
				<cfset rsNuevasVigencias.PCEMidNueva = 'null'>
				<cfset rsMascara.PCEMformato = "">
			</cfif>
	
			<cfquery name="rsMascara" datasource="#session.dsn#">
				select PCEMformato
				  from PCEMascaras
				 where PCEMid = #rsNuevasVigencias.PCEMidNueva#
			</cfquery>
			<cfif rsSQL.CPVdesdeAnoMes LT dateFormat(LvarFechaIni,"YYYYMM")>
				<!--- 
					Si la Vigencia Actual inicia antes del Periodo ajusta la Vigencia Actual y añade nueva Vigencia:
						Ajusta la fecha final de la Vigencia Actual con el dia anterior del incio del periodo
						Inserta la nueva vigencia a partir del inicio del periodo hasta infinito
				--->
				<cfquery datasource="#session.dsn#">
					update CPVigencia
					   set CPVhasta = <cfqueryparam cfsqltype="cf_sql_date" value="#dateadd('d',-1,LvarFechaIni)#">,
						   CPVhastaAnoMes = #dateformat(dateadd('d',-1,LvarFechaIni),"YYYYMM")#
					where CPVid = #LvarVigenciaID#
				</cfquery>
				<cfquery name="rsSQL" datasource="#session.dsn#">
					insert into CPVigencia
						(Ecodigo, Cmayor, PCEMid, CPVdesde, CPVhasta, CPVdesdeAnoMes, CPVhastaAnoMes, CPVformatoF, CPVformatoPropio)
					values
						(
						#session.Ecodigo#,
						'#rsNuevasVigencias.Cmayor#',
						#rsNuevasVigencias.PCEMidNueva#,
						<cfqueryparam cfsqltype="cf_sql_date" value="#LvarFechaIni#">,
						<cfqueryparam cfsqltype="cf_sql_date" value="#rsSQL.CPVhasta#">,
						#dateformat(LvarFechaIni,"YYYYMM")#,
						#dateformat(rsSQL.CPVhasta,"YYYYMM")#,
						'#rsMascara.PCEMformato#',
						0
						)
				</cfquery>
			<cfelse>
				<!--- 
					Si la Vigencia Actual inicia [despues o] igual del Periodo no se va a utilizar nunca, por lo que se reutiliza la vigencia:
						Actualiza la Mascara con la nueva Mascara
				--->
				<!--- Vigencia empieza con el Periodo por lo que se ocupa --->
				<cfquery datasource="#session.dsn#">
					update CPVigencia
					   set PCEMid 			= #rsNuevasVigencias.PCEMidNueva#,
						   CPVformatoF		='#rsMascara.PCEMformato#', 
						   CPVformatoPropio	= 0
					 where CPVid = #LvarVigenciaID#
				</cfquery>
			</cfif>
		</cfloop>
	
		<!--- Obtiene el numero de documento de aprobacion de version --->
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select CVdocumentoAprobo
			  from CVersion v
			 where Ecodigo 	= #session.Ecodigo#
			   and CVid 	= #LvarCVid#
		</cfquery>
	
		<cfif rsSQL.CVdocumentoAprobo NEQ "">
			<cfset LvarDocumentoAprobo = rsSQL.CVdocumentoAprobo>
		<cfelse>
			<cfquery name="rsSQL" datasource="#session.dsn#">
				select max(CVdocumentoAprobo) as ultimo
				  from CVersion v
				 where Ecodigo = #session.Ecodigo#
				   and CVtipo  = <cfif LvarAprobacion>'1'<cfelse>'2'</cfif>
			</cfquery>
			
			<cfif rsSQL.ultimo EQ "">
				<cfset LvarDocumentoAprobo = 1>
			<cfelse>
				<cfset LvarDocumentoAprobo = rsSQL.ultimo + 1>
			</cfif>
		</cfif>
	
		<!--- Crea las cuentas nuevas de Presupuesto --->
<cflog type="information" file="FormulacionAplica" text="INICIO PASO 4">
	<cfset session.CFaprobacion.Paso = 4>
	<cfset sbCreaCtasNuevas()>
	
<cflog type="information" file="FormulacionAplica" text="INICIO PASO 5">
	<cfset session.CFaprobacion.Paso = 5>
		<!--- Crea los saldos en PresupuestoControl para todos los Ano+Mes de cada Cuenta+Oficina que no existan--->
		<cfquery name="rsSQL" datasource="#session.dsn#">
			insert into CPresupuestoControl
				(Ecodigo, CPPid, CPCano, CPCmes, CPcuenta, Ocodigo, CPCanoMes)
			select distinct 
					#session.Ecodigo#, #LvarCPPid#,
					m.CPCano, m.CPCmes, 
					c.CPcuenta,	f.Ocodigo,
					m.CPCano*100+m.CPCmes
			  from CVFormulacionTotales f
					inner join CVPresupuesto c
						on c.Ecodigo   = f.Ecodigo
					   and c.CVid 	   = f.CVid
					   and c.CVPcuenta = f.CVPcuenta
					inner join CPmeses m
						on m.Ecodigo   = f.Ecodigo
					   and m.CPPid 	   = #LvarCPPid#
			 where f.Ecodigo = #session.Ecodigo#
			   and f.CVid 	 = #LvarCVid#
			   and not exists 
					(
						select 1
						  from CPresupuestoControl
						 where Ecodigo 	= m.Ecodigo
						   and CPPid 	= m.CPPid
						   and CPcuenta = c.CPcuenta
						   and Ocodigo	= f.Ocodigo
						   and CPCano	= m.CPCano
						   and CPCmes	= m.CPCmes
					)
		</cfquery>
		
	<cfset session.CFaprobacion.Paso = 6>
		<cf_dbtemp 	name="PC_MONED_v1" 
					returnvariable="MONEDAS"
					datasource="#session.dsn#"
					>
			<cf_dbtempcol name="CPCano" 			type="numeric">
			<cf_dbtempcol name="CPCmes"				type="numeric">
			<cf_dbtempcol name="CPcuenta"			type="numeric">
			<cf_dbtempcol name="Ocodigo"			type="numeric">
			<cf_dbtempcol name="Mcodigo"			type="numeric">
			<cf_dbtempcol name="TipoCambio"			type="money">
			<cf_dbtempcol name="Monto"				type="money">
	
			<cf_dbtempkey cols="CPCano,CPCmes,CPcuenta,Ocodigo,Mcodigo">
		</cf_dbtemp>			
<cflog type="information" file="FormulacionAplica" text="INICIO PASO 6: insert into #MONEDAS#">
 		<cfquery name="rsSQL" datasource="#session.dsn#">
			insert into #MONEDAS#
				(CPCano,CPCmes,CPcuenta,Ocodigo,Mcodigo,TipoCambio,Monto)
			select fm.CPCano,fm.CPCmes,c.CPcuenta,fm.Ocodigo,fm.Mcodigo,fm.CVFMtipoCambio,fm.CVFMmontoAplicar
			  from CVPresupuesto c, CVFormulacionMonedas fm
			 where fm.Ecodigo 	 = #session.Ecodigo#
			   and fm.CVid 	     = #LvarCVid#
			   and c.Ecodigo	 = fm.Ecodigo
			   and c.CVid	     = fm.CVid
			   and c.CVPcuenta	 = fm.CVPcuenta
			   and fm.CVFMmontoAplicar <> 0
		</cfquery>
		
<cflog type="information" file="FormulacionAplica" text="INICIO PASO 6: insert into CPControlMoneda">
		<!--- Incluye los montos solicitados por moneda por cada CPcuenta + Ocodigo --->
		<cfquery name="rsSQL" datasource="#session.dsn#">
			insert into CPControlMoneda
				(Ecodigo, CPPid, CPCano, CPCmes, CPcuenta, Ocodigo, Mcodigo, CPCMtipoCambioAplicado)
			select #session.Ecodigo#, #LvarCPPid#, m.CPCano, m.CPCmes, m.CPcuenta, m.Ocodigo, m.Mcodigo, 0
			  from #MONEDAS# m
			 where not exists 
					(
						select 1
						  from CPControlMoneda
						 where Ecodigo 	= #session.Ecodigo#
						   and CPPid 	= #LvarCPPid#
						   and CPCano 	= m.CPCano
						   and CPCmes	= m.CPCmes
						   and CPcuenta = m.CPcuenta
						   and Ocodigo	= m.Ocodigo
						   and Mcodigo	= m.Mcodigo
					)
		</cfquery>
<cflog type="information" file="FormulacionAplica" text="INICIO PASO 6: update CPControlMoneda">
 		<cfquery name="rsSQL" datasource="#session.dsn#">
			update CPControlMoneda
				set CPCMtipoCambioAplicado =
					(
						select TipoCambio
						  from #MONEDAS# m
						 where m.CPCano 	= CPControlMoneda.CPCano
						   and m.CPCmes		= CPControlMoneda.CPCmes
						   and m.CPcuenta 	= CPControlMoneda.CPcuenta
						   and m.Ocodigo	= CPControlMoneda.Ocodigo
						   and m.Mcodigo	= CPControlMoneda.Mcodigo
					)					
				<cfif LvarAprobacion>
				  , CPCMpresupuestado =
				<cfelse>
				  , CPCMmodificado = CPCMmodificado +
				</cfif>
					(
						select Monto
						  from #MONEDAS# m
						 where m.CPCano 	= CPControlMoneda.CPCano
						   and m.CPCmes		= CPControlMoneda.CPCmes
						   and m.CPcuenta 	= CPControlMoneda.CPcuenta
						   and m.Ocodigo	= CPControlMoneda.Ocodigo
						   and m.Mcodigo	= CPControlMoneda.Mcodigo
					)					
			 where Ecodigo 	= #session.Ecodigo#
			   and CPPid 	= #LvarCPPid#
			   and exists
					(
						select 1
						  from #MONEDAS# m
						 where m.CPCano 	= CPControlMoneda.CPCano
						   and m.CPCmes		= CPControlMoneda.CPCmes
						   and m.CPcuenta 	= CPControlMoneda.CPcuenta
						   and m.Ocodigo	= CPControlMoneda.Ocodigo
						   and m.Mcodigo	= CPControlMoneda.Mcodigo
					)
		</cfquery>

 <cflog type="information" file="FormulacionAplica" text="INICIO PASO 7">
	
	<cfset session.CFaprobacion.Paso = 7>
			<cfquery name="rsSQL" datasource="#session.dsn#">
				insert into #request.intPresupuesto#
					(
						ModuloOrigen,
						NumeroDocumento,
						NumeroReferencia,
						FechaDocumento,
						AnoDocumento,
						MesDocumento,
						
						CPPid, 
						CPCano, CPCmes, CPCanoMes,
						CPcuenta, Ocodigo,
						CuentaPresupuesto, CodigoOficina,
						TipoControl, CalculoControl, SignoMovimiento,	
						TipoMovimiento,
						Mcodigo, 	MontoOrigen, 
						TipoCambio, Monto
					)
				select 'PRFO', '#LvarDocumentoAprobo#', 'FORMULACION', 
						
						<!---<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarFecha#">,--->
						<cf_dbfunction name="now">,
                        
						#LvarAno#, #LvarMes#, 
						
						#LvarCPPid#,
						f.CPCano, f.CPCmes, f.CPCano*100+f.CPCmes,
						c.CPcuenta, f.Ocodigo,
						c.CPformato, o.Oficodigo,
						c.CVPtipoControl, CVPcalculoControl, +1,
						<cfif LvarAprobacion>
						'A', 
						<cfelse>
						'M', 
						</cfif>
						#qry_monedaEmpresa.Mcodigo#, 	f.CVFTmontoAplicar,
						1, 								f.CVFTmontoAplicar
			  from CVFormulacionTotales f
					inner join CVPresupuesto c
						on c.Ecodigo   = f.Ecodigo
					   and c.CVid 	   = f.CVid
					   and c.CVPcuenta = f.CVPcuenta
					inner join Oficinas o
						on o.Ecodigo   = f.Ecodigo
					   and o.Ocodigo   = f.Ocodigo
			where f.Ecodigo = #session.Ecodigo#
			  and f.CVid 	= #LvarCVid#
		<cfif isdefined("url.conFormulacion") AND url.conFormulacion EQ "1">
			  and f.CVFTmontoAplicar <> 0
		 </cfif>
			order by c.CPformato, o.Oficodigo, f.CPCano, f.CPCmes
			</cfquery>
	
<cflog type="information" file="FormulacionAplica" text="INICIO PASO 8">
	<cfset session.CFaprobacion.Paso = 8>
		<cfif LvarAprobacion>
			<cfset LvarNAP = LobjControl.ControlPresupuestario("PRFO", LvarDocumentoAprobo, "APROBACION", LvarFecha, LvarAno, LvarMes)>
		<cfelse>
			<cfset LvarNAP = LobjControl.ControlPresupuestario("PRFO", LvarDocumentoAprobo, "MODIFICACION", LvarFecha, LvarAno, LvarMes)>
		</cfif>
	
<cflog type="information" file="FormulacionAplica" text="INICIO PASO 9">
	<cfset session.CFaprobacion.Paso = 9>
		<cfif LvarNAP GTE 0>
			<cfquery name="rsSQL" datasource="#session.dsn#">
				update CVersion
				   set CVaprobada = 1
					 , UsucodigoAprobo = #session.Usucodigo#
					 , CVfechaAprobo = 	<cfqueryparam cfsqltype="cf_sql_date"		value="#now()#">
					 , CVdocumentoAprobo = #LvarDocumentoAprobo#
					 , NAP = #LvarNAP#
				 where Ecodigo 	= #session.Ecodigo#
				   and CVid 		= #LvarCVid#
			</cfquery>
	
			<cfif LvarAprobacion>
				<cfquery name="rsSQL" datasource="#session.dsn#">
					update CPresupuestoPeriodo
					   set CPPestado = 1
					 where CPPid = #LvarCPPid#
				</cfquery>
			</cfif>	

			<cfif LvarRHEid NEQ "">
				<cfquery name="rsRHEscenario" datasource="#session.dsn#">
					update RHEscenarios
					   set RHEestado = 'T'
					 where RHEid = #LvarRHEid#
				</cfquery>
			</cfif>	
		<cfelse>
			<cfquery name="rsSQL" datasource="#session.dsn#">
				update CVersion
				   set NRP = #abs(LvarNAP)#
				 where Ecodigo 	= #session.Ecodigo#
				   and CVid 	= #LvarCVid#
			</cfquery>
		</cfif>
<cfquery name="rsParam2300" datasource="#session.dsn#">
	select Pvalor from Parametros where Ecodigo = #session.Ecodigo# and Pcodigo = 2300
</cfquery>
<cfif rsParam2300.Pvalor EQ 1><!---1=Por Plan de Compras/ 0 Por cuentas--->
<cflog type="information" file="FormulacionAplica" text="Generando Plan de Compras">
	<cfinvoke component="sif.Componentes.PlanCompras" method="GenerarPlanCompras">
		<cfinvokeargument name="CPPid" 				value="#LvarCPPid#">
		<cfinvokeargument name="CVid" 				value="#LvarCVid#">
	</cfinvoke>
	<cfinvoke component="sif.Componentes.FPRES_Equilibrio" method="CambioEstadoMasivo">
		<cfinvokeargument name="FPEEestado" value="6">
		<cfinvokeargument name="Filtro" 	value="CPPid = #LvarCPPid# and FPEEestado = 5">
	</cfinvoke>
</cfif>
<cflog type="information" file="FormulacionAplica" text="================================================================">
	</cftransaction>
	<cfscript>
		sbActivaTs_rversion ("CVMayor");
		sbActivaTs_rversion ("CVPresupuesto");
		sbActivaTs_rversion ("CVFormulacionTotales");
		sbActivaTs_rversion ("CVFormulacionMonedas");
	
		sbActivaTs_rversion ("CPresupuesto");
		sbActivaTs_rversion ("CPresupuestoControl");
		sbActivaTs_rversion ("CPControlMoneda");
	</cfscript>
	
	<cfif isdefined("LvarNAP") AND LvarNAP LT 0>
		<cfset session.CFaprobacion.Paso = 10>
	<cfelse>
		<cfset session.CFaprobacion.Paso = 11>
	</cfif>
<cfcatch type="any">
 	<cfset ErrorMsg = cfcatch.Message & ", " & cfcatch.Detail>
<cflog type="error" file="FormulacionAplica" text="ERROR en aprobacion.sql: #ErrorMsg#">
	<cfinclude template="/home/public/error/log_cfcatch.cfm">
	<cfparam name="request.ErrorId" default="????">
<cflog type="error" file="FormulacionAplica" text="ERROR en aprobacion.sql: ErrorId=#request.ErrorId#">
	<cfset session.CFaprobacion.ErrorId = request.ErrorId>
	<cfset session.CFaprobacion.Paso = "-1">
	<cftransaction action="rollback"/>
</cfcatch>
</cftry>

<cffunction name="sbDesactivaTs_rversion">
	<cfargument name="Tabla" type="string" required="yes">
	<cftry>
		<cfquery datasource="#session.DSN#">
			alter trigger tuts_#Arguments.Tabla# disable
		</cfquery>
	<cfcatch type="any"></cfcatch>
	</cftry>
</cffunction>

<cffunction name="sbActivaTs_rversion">
	<cfargument name="Tabla" type="string" required="yes">
	<cftry>
		<cfquery datasource="#session.DSN#">
			alter trigger tuts_#Arguments.Tabla# enable
		</cfquery>
	<cfcatch type="any"></cfcatch>
	</cftry>
</cffunction>

<cffunction name="sbCreaCtasNuevas_versionIndividual">
	<cfquery name="rsFormulacion" datasource="#session.dsn#">
		select 	distinct c.CPcuenta, c.CVPcuenta,
				c.Cmayor, c.CPformato, c.CPdescripcion, c.CVPtipoControl, c.CVPcalculoControl, 
				vg.CPVid
		  from CVFormulacionTotales f
				inner join CVPresupuesto c
					on c.Ecodigo   = f.Ecodigo
				   and c.CVid 	   = f.CVid
				   and c.CVPcuenta = f.CVPcuenta
				left outer join CPVigencia vg
					on vg.Ecodigo = f.Ecodigo
				   and vg.Cmayor  = c.Cmayor
				   and #dateformat(LvarFechaIni,"YYYYMM")# between vg.CPVdesdeAnoMes and vg.CPVhastaAnoMes
		where f.Ecodigo = #session.Ecodigo#
		  and f.CVid = #LvarCVid#
		  and c.CPcuenta is NULL
	</cfquery>
	
<cfset session.CFaprobacion.Total = rsFormulacion.recordCount>
	<cfloop query="rsFormulacion">
<cfset session.CFaprobacion.Avance = rsFormulacion.currentRow>
		
		<cfset LvarCFformato = trim(rsFormulacion.CPformato)>
		<cfinvoke 
			component="sif.Componentes.PC_GeneraCuentaFinanciera"
			method="fnGeneraCuentaFinanciera"
			returnvariable="LvarError">
				<cfinvokeargument name="Lprm_CFformato" 		value="#LvarCFformato#"/>
				<cfinvokeargument name="Lprm_fecha" 			value="#LvarFechaIni#"/>
				<cfinvokeargument name="Lprm_CrearPresupuesto" 	value="yes"/>
				<cfinvokeargument name="Lprm_CPPid" 			value="#LvarCPPid#"/>
				<cfinvokeargument name="Lprm_CVPtipoControl" 	value="#rsFormulacion.CVPtipoControl#"/>
				<cfinvokeargument name="Lprm_CVPcalculoControl" value="#rsFormulacion.CVPcalculoControl#"/>
				<cfinvokeargument name="Lprm_CPdescripcion" 	value="#rsFormulacion.CPdescripcion#"/>
				<cfinvokeargument name="Lprm_TransaccionActiva" value="yes"/>
		</cfinvoke>
	
		<cfif (LvarError EQ "NEW" OR LvarError EQ "OLD")>
			<cfquery name="rsSQL" datasource="#session.dsn#">
				update CVPresupuesto
				   set CPcuenta = 
				   		(
							select CPcuenta
							  from CPresupuesto
							 where Ecodigo	 = #session.Ecodigo# 
							   AND Cmayor	 = '#rsFormulacion.Cmayor#'
							   AND CPVid	 = #rsFormulacion.CPVid# 
							   AND CPformato = '#LvarCFformato#'
						)
				  where CVPcuenta = #rsFormulacion.CVPcuenta#
			</cfquery>
		<cfelse>
			<cf_errorCode	code = "50546"
							msg  = "Cuenta de Presupuesto '@errorDat_1@': @errorDat_2@"
							errorDat_1="#rsFormulacion.CPformato#"
							errorDat_2="#LvarError#"
			>
		</cfif>
	</cfloop>
</cffunction>

<cffunction name="sbCreaCtasNuevas">

	<cfquery datasource="#session.dsn#">
		update CPresupuesto
		   set 	CPdescripcionF = NULL
		where Ecodigo = #session.Ecodigo#
		  and CPmovimiento = 'S'
		  and exists
			(
				select 1 
				  from CVPresupuesto cv
				 where 	cv.Ecodigo	= #session.Ecodigo#
				   and 	cv.CVid		= #LvarCVid#
				   and	cv.CPcuenta = CPresupuesto.CPcuenta
			)
	</cfquery>

	<cfquery datasource="#session.dsn#">
		update CPresupuesto
		   set 	CPdescripcionF = 
			(
				select min(cv.CPdescripcion)
				  from CVPresupuesto cv
				 where 	cv.Ecodigo	= #session.Ecodigo#
				   and 	cv.CVid		= #LvarCVid#
				   and	cv.CPcuenta = CPresupuesto.CPcuenta
				   and  cv.CPdescripcion <> CPresupuesto.CPdescripcion
			)
		where Ecodigo = #session.Ecodigo#
		  and CPmovimiento = 'S'
		  and exists
			(
				select 1 
				  from CVPresupuesto cv
				 where 	cv.Ecodigo	= #session.Ecodigo#
				   and 	cv.CVid		= #LvarCVid#
				   and	cv.CPcuenta = CPresupuesto.CPcuenta
				   and  cv.CPdescripcion <> CPresupuesto.CPdescripcion
			)
	</cfquery>

	<cf_dbtemp 	name="CTASP_v1_" 
				returnvariable="CTASP"
				datasource="#session.dsn#"
				>
		<cf_dbtempcol name="ID" 				type="numeric" identity="true">					<!--- ID temporal de la transaccion --->
		<cf_dbtempcol name="CVPcuenta"			type="numeric">			<!--- Valor en el Nivel --->
		<cf_dbtempcol name="CPcuenta"			type="numeric">			<!--- Valor en el Nivel --->
		<cf_dbtempcol name="CPVid"				type="numeric">			<!--- Valor en el Nivel --->
		<cf_dbtempcol name="PCEMid"				type="numeric">			<!--- Valor en el Nivel --->
		<cf_dbtempcol name="Ecodigo"			type="numeric">			<!--- Valor en el Nivel --->
		<cf_dbtempcol name="Cmayor"				type="char(4)">			<!--- Valor en el Nivel --->
		<cf_dbtempcol name="CPformato"			type="varchar(100)">		<!--- Formato de la Cuenta a Generar --->
		<cf_dbtempcol name="CPdescripcion" 		type="varchar(80)">			<!--- Descripcion de la Cuenta a Generar --->
		<cf_dbtempcol name="CPCPtipoControl"	type="int">			<!--- Descripcion de la Cuenta a Generar --->
		<cf_dbtempcol name="CPCPcalculoControl"	type="int">			<!--- Descripcion de la Cuenta a Generar --->

		<cf_dbtempkey cols="ID">

		<cf_dbtempindex cols="CPcuenta">
		<cf_dbtempindex cols="CVPcuenta">
	</cf_dbtemp>			
<cflog type="information" file="FormulacionAplica" text="-----------------------------------------------------">
<cflog type="information" file="FormulacionAplica" text="INICIO CREACION CUENTAS">
	<cfquery datasource="#session.dsn#">
		insert into #CTASP#
			(
				CVPcuenta,
				CPVid,
				PCEMid,
				Ecodigo,
				Cmayor,
				CPformato,
				CPdescripcion,
				CPCPtipoControl,
				CPCPcalculoControl
			)
		select	distinct
				cv.CVPcuenta,
				vg.CPVid,
				vg.PCEMid,
				cv.Ecodigo,
				cv.Cmayor,
				cv.CPformato,
				cv.CPdescripcion,
				cv.CVPtipoControl,
				cv.CVPcalculoControl
		  from	CVPresupuesto cv
				  inner join CPVigencia vg
					 on vg.Ecodigo 	= cv.Ecodigo
					and vg.Cmayor 	= cv.Cmayor
					and #dateformat(LvarFechaIni,"YYYYMM")# between CPVdesdeAnoMes and CPVhastaAnoMes
				  inner join CVFormulacionTotales t
					 on t.Ecodigo	= cv.Ecodigo
					and t.CVid		= cv.CVid
					and t.CVPcuenta	= cv.CVPcuenta
		 where 	cv.Ecodigo	= #session.Ecodigo#
		   and 	cv.CVid		= #LvarCVid#
		   and	cv.CPcuenta is null
	</cfquery>

<cflog type="information" file="FormulacionAplica" text="insert into PC_CTASP">
	<cf_dbtemp 	name="CTASPNiv_v2_" 
				returnvariable="CTASPNiv"
				datasource="#session.dsn#"
				>
		<cf_dbtempcol name="ID" 			type="numeric">		<!--- ID temporal de la transaccion --->
		<cf_dbtempcol name="niv"			type="int">			<!--- Valor en el Nivel --->
		<cf_dbtempcol name="nivP"			type="int">			<!--- Valor en el Nivel --->
		<cf_dbtempcol name="CPmovimiento"	type="char(1)">		<!--- Valor en el Nivel --->
		<cf_dbtempcol name="ini"			type="int">			<!--- Valor en el Nivel --->
		<cf_dbtempcol name="lon"			type="int">			<!--- Valor en el Nivel --->
		<cf_dbtempcol name="fin"			type="int">			<!--- Valor en el Nivel --->
		<cf_dbtempcol name="CPformato"		type="char(100)">	<!--- Formato de la Cuenta a Generar --->
		<cf_dbtempcol name="valor" 			type="varchar(20)">	<!--- Valor en el Nivel --->
		<cf_dbtempcol name="nivDep" 		type="numeric">		<!--- Codigo del Catalogo --->
		<cf_dbtempcol name="PCEcatid" 		type="numeric">		<!--- Codigo del Catalogo --->
		<cf_dbtempcol name="PCDcatid" 		type="numeric">		<!--- Codigo del Detalle de Catalogo (al Identificar Tipo y Valor) --->
		<cf_dbtempcol name="PCEcatidref"	type="numeric">		<!--- Codigo del Catalogo --->
		<cf_dbtempcol name="CPcuenta"		type="numeric">			

		<cf_dbtempkey cols="ID,niv">

		<cf_dbtempindex cols="CPcuenta">
	</cf_dbtemp>	
	
	<cfquery datasource="#session.dsn#">
		insert into #CTASPNiv#
			(ID, niv, lon, nivDep, PCEcatid)
		select c.ID, n.PCNid, n.PCNlongitud, n.PCNdep, n.PCEcatid
		  from #CTASP# c
			inner join PCNivelMascara n
				 on n.PCEMid = c.PCEMid
				and n.PCNpresupuesto = 1
	</cfquery>
<cflog type="information" file="FormulacionAplica" text="insert into PC_CTASP_niv from PC_CTASP x PCNivelMascara">
	<cfquery datasource="#session.dsn#">
		insert into #CTASPNiv#
			(ID, niv, nivP, lon, ini, fin, CPformato, valor)
		select ID, 0, 0, 4, 1, 4, Cmayor, Cmayor
		  from #CTASP# c
	</cfquery>
<cflog type="information" file="FormulacionAplica" text="insert into PC_CTASP_niv Cmayores de PC_CTASP">

	<cfquery datasource="#session.dsn#">
		update #CTASPNiv#
		   set 	nivP = 
			(
				select count(1) 
				  from #CTASPNiv# n
				 where n.ID 	= #CTASPNiv#.ID
				   and n.niv 	< #CTASPNiv#.niv
			)
			,	ini =
			(
				select coalesce(sum(lon),0)+count(1)+1 
				  from #CTASPNiv# n
				 where n.ID 	= #CTASPNiv#.ID
				   and n.niv 	< #CTASPNiv#.niv
			)
			,	fin = lon - 1 +
			(
				select coalesce(sum(lon),0)+count(1)+1 
				  from #CTASPNiv# n
				 where n.ID 	= #CTASPNiv#.ID
				   and n.niv 	< #CTASPNiv#.niv
			)
	</cfquery>
<cflog type="information" file="FormulacionAplica" text="update CP_CTASP_niv set nivP,ini,fin">
	<cfquery datasource="#session.dsn#">
		update #CTASPNiv#
		   set 	CPformato = 
					rtrim((
						select {fn SUBSTRING(c.CPformato,1,#CTASPNiv#.fin)}
						  from #CTASP# c
						 where c.ID 	= #CTASPNiv#.ID
					))
			,	valor = 
					rtrim((
						select {fn SUBSTRING(c.CPformato,#CTASPNiv#.ini,#CTASPNiv#.lon)}
						  from #CTASP# c
						 where c.ID 	= #CTASPNiv#.ID
					))
			,	CPmovimiento = 
			(
				select case when {fn LENGTH({fn RTRIM(c.CPformato)})} = #CTASPNiv#.fin then 'S' else 'N' end
				  from #CTASP# c
				 where c.ID 	= #CTASPNiv#.ID
			)
	</cfquery>

<cflog type="information" file="FormulacionAplica" text="update CP_CTASP_niv set CPformato, valor, CPmovimiento">
	<cfquery datasource="#session.dsn#">
		update #CTASPNiv#
		   set 	PCDcatid = 
			(
				select min(v.PCDcatid)
				  from PCDCatalogo v
				 where v.PCEcatid 	= #CTASPNiv#.PCEcatid
				   and v.PCDvalor 	= #CTASPNiv#.valor
				   and coalesce(v.Ecodigo,#session.Ecodigo#) = #session.Ecodigo#
			)
			,	PCEcatidref =
			(
				select min(v.PCEcatidref)
				  from PCDCatalogo v
				 where v.PCEcatid 	= #CTASPNiv#.PCEcatid
				   and v.PCDvalor 	= #CTASPNiv#.valor
				   and coalesce(v.Ecodigo,#session.Ecodigo#) = #session.Ecodigo#
			)
		  where #CTASPNiv#.PCEcatid IS NOT NULL
	</cfquery>
<cflog type="information" file="FormulacionAplica" text="update CP_CTASP_niv set PCDcatid, PCEcatidref">

	<cfquery name="rsSQL" datasource="#session.dsn#">
		select min(nivP) as NivIni ,max(nivP) as NivFin
		  from #CTASPNiv#
		 where PCDcatid is null
		   and nivP>0
	</cfquery>
	
	<cfif rsSQL.NivIni NEQ "">
<cflog type="information" file="FormulacionAplica" text="cfloop FROM=#rsSQL.NivIni# TO=#rsSQL.NivFin#">
		<cfloop index="i" from="#rsSQL.NivIni#" to="#rsSQL.NivFin#">
			<cfquery datasource="#session.dsn#">
				update #CTASPNiv#
				   set 	PCEcatid = 
					(
						select p.PCEcatidref
						  from #CTASPNiv# p
						 where p.ID 	= #CTASPNiv#.ID
						   and p.niv 	= #CTASPNiv#.nivDep
					)
					,	PCDcatid = 
					(
						select v.PCDcatid
						  from #CTASPNiv# p, PCDCatalogo v
						 where p.ID 	= #CTASPNiv#.ID
						   and p.niv 	= #CTASPNiv#.nivDep
		
						   and v.PCEcatid 	= p.PCEcatidref
						   and v.PCDvalor 	= #CTASPNiv#.valor
						   and coalesce(v.Ecodigo,#session.Ecodigo#) = #session.Ecodigo#
					)
					,	PCEcatidref =
					(
						select v.PCEcatidref
						  from #CTASPNiv# p, PCDCatalogo v
						 where p.ID 	= #CTASPNiv#.ID
						   and p.niv 	= #CTASPNiv#.nivDep
		
						   and v.PCEcatid 	= p.PCEcatidref
						   and v.PCDvalor 	= #CTASPNiv#.valor
						   and coalesce(v.Ecodigo,#session.Ecodigo#) = #session.Ecodigo#
					)
				  where exists
					(
						select 1
						  from #CTASPNiv# p
						 where p.ID 	= #CTASPNiv#.ID
						   and p.niv 	= #CTASPNiv#.nivDep
					)
			</cfquery>
	<cflog type="information" file="FormulacionAplica" text="busca #i#: update CP_CTASP_niv set PCEcatid, PCDcatid, PCEcatidref">
		</cfloop>
	</cfif>
	<cfinclude template="../../Utiles/sifConcat.cfm">
	<cfquery datasource="#session.dsn#">
		insert into CPresupuesto
			(CPVid, Ecodigo, Cmayor, CPformato, PCDcatid, CPdescripcion, CPdescripcionF, CPmovimiento)
		select DISTINCT 
				c.CPVid, #session.Ecodigo#, c.Cmayor, rtrim(n.CPformato), n.PCDcatid, 
					coalesce(v.PCDdescripcion, 'Nivel ' #_Cat# <cf_dbfunction name="to_char" args="n.niv">), 
					case when CPmovimiento='S' then c.CPdescripcion end,
					n.CPmovimiento
		  from #CTASPNiv# n
		  	left join PCDCatalogo v
				on v.PCDcatid 	= n.PCDcatid
			inner join #CTASP# c
				on c.ID	= n.ID
		  where not exists
		  	(
				select 1
				  from CPresupuesto
				 where Ecodigo   	= #session.Ecodigo#
				   and Cmayor    	= c.Cmayor
				   and CPVid     	= c.CPVid
				   and CPformato 	= n.CPformato
			)
	</cfquery>
<cflog type="information" file="FormulacionAplica" text="insert into CPpresupuesto">
	<cfquery datasource="#session.dsn#">
		update #CTASPNiv#
		   set 	CPcuenta = 
			(
				select cp.CPcuenta
				  from CPresupuesto cp, #CTASP# ct
				 where ct.ID   			= #CTASPNiv#.ID
				   and cp.Ecodigo   	= #session.Ecodigo#
				   and cp.Cmayor    	= ct.Cmayor
				   and cp.CPVid     	= ct.CPVid
				   and cp.CPformato 	= #CTASPNiv#.CPformato
			)
	</cfquery>
<cflog type="information" file="FormulacionAplica" text="update CP_CTASP_niv set CPcuenta">

	<cfquery datasource="#session.dsn#">
		update #CTASP#
		   set 	CPcuenta = 
			(
				select h.CPcuenta
				  from #CTASPniv# h
				 where h.ID   			= #CTASP#.ID
				   and h.CPmovimiento  	= 'S'
			)
	</cfquery>
<cflog type="information" file="FormulacionAplica" text="update CP_CTASP set CPcuenta">

	<cfquery datasource="#session.dsn#">
		update CPresupuesto
		   set 	CPpadre = 
			(
				select min(p.CPcuenta)
				  from #CTASPNiv# n, #CTASPNiv# p
				 where n.CPcuenta = CPresupuesto.CPcuenta
				   and n.niv > 0
				   and p.ID  = n.ID
				   and p.niv = n.niv-1
			)
		where Ecodigo = #session.Ecodigo#
		  and CPpadre is null
		  and exists
			(
				select 1 
				  from #CTASPNiv# n
				 where n.CPcuenta = CPresupuesto.CPcuenta
			)
	</cfquery>
<cflog type="information" file="FormulacionAplica" text="update CPresupuesto set CPadre">

	<cfquery datasource="#session.dsn#">
		update #CTASP#
		   set 	CPdescripcion = null
		 where CPdescripcion =
			(
				select CPdescripcion
				  from CPresupuesto
				 where CPcuenta	= #CTASP#.CPcuenta
			)
	</cfquery>

	<cfquery datasource="#session.dsn#">
		update CPresupuesto
		   set 	CPdescripcionF = 
			(
				select min(CPdescripcion)
				  from #CTASP#
				 where CPcuenta = CPresupuesto.CPcuenta
			)
		where Ecodigo = #session.Ecodigo#
		  and CPmovimiento = 'S'
		  and exists
			(
				select 1 
				  from #CTASP#
				 where CPcuenta = CPresupuesto.CPcuenta
			)
	</cfquery>
<cflog type="information" file="FormulacionAplica" text="update CPresupuesto set CPdescripcionF">

	<cfquery datasource="#session.dsn#">
		insert into PCDCatalogoCuentaP
			(CPcuenta, PCEMid, PCEcatid, PCDcatid, CPcuentaniv, PCDCniv)
		select c.CPcuenta, c.PCEMid, n.PCEcatid, n.PCDcatid, n.CPcuenta, n.nivP
		  from #CTASPNiv# n
			inner join #CTASP# c
				 on c.ID = n.ID
		  where not exists
		  	(
				select 1
				  from PCDCatalogoCuentaP
				 where CPcuenta = c.CPcuenta
				   and PCDCniv	= n.nivP
			)
	</cfquery>
<cflog type="information" file="FormulacionAplica" text="insert into PCDCatalogoCuentaP">

	<cfquery datasource="#session.dsn#">
		update CVPresupuesto
		   set 	CPcuenta = 
			(
				select c.CPcuenta
				  from #CTASP# c
				 where CVPcuenta = CVPresupuesto.CVPcuenta
			)
		where Ecodigo	= #session.Ecodigo#
		  and CVid 		= #LvarCVid#
		  and CPcuenta IS NULL
		  and exists
			(
				select 1
				  from #CTASP# c
				 where CVPcuenta = CVPresupuesto.CVPcuenta
			)
	</cfquery>
<cflog type="information" file="FormulacionAplica" text="update CVPresupuesto set CPcuenta">

	<cfif isdefined("url.ActualizarControl") AND url.ActualizarControl EQ "1">
		<cfquery datasource="#session.dsn#">
			update CPCuentaPeriodo
			   set CPCPtipoControl		= 
			   		(	
						select CVPtipoControl 
						  from CVPresupuesto 
						 where Ecodigo	= #session.Ecodigo#
						   and CVid 	= #LvarCVid#
						   and CPcuenta = CPCuentaPeriodo.CPcuenta
				   )
				 , CPCPcalculoControl	=
			   		(	
						select CVPcalculoControl
						  from CVPresupuesto 
						 where Ecodigo	= #session.Ecodigo#
						   and CVid 	= #LvarCVid#
						   and CPcuenta = CPCuentaPeriodo.CPcuenta
				   )
			where Ecodigo	= #session.Ecodigo#
			  and CPPid		= #LvarCPPid#
			  and exists
					(
						select 1
						  from CVPresupuesto
						 where Ecodigo	= #session.Ecodigo#
						   and CVid 	= #LvarCVid#
						   and CPcuenta = CPCuentaPeriodo.CPcuenta
					)
		</cfquery>
	</cfif>

	<cfquery datasource="#session.dsn#">
		insert into CPCuentaPeriodo
			(Ecodigo, CPPid, CPcuenta, CPCPtipoControl, CPCPcalculoControl)
		select 	#session.Ecodigo#, #LvarCPPid#, c.CPcuenta, c.CVPtipoControl, c.CVPcalculoControl
		  from CVPresupuesto c
		where Ecodigo	= #session.Ecodigo#
		  and CVid 		= #LvarCVid#
		  and CPcuenta IS NOT NULL
		  and not exists
		  	(
				select 1
				  from CPCuentaPeriodo
				 where Ecodigo	= #session.Ecodigo#
				   and CPPid	= #LvarCPPid#
				   and CPcuenta = c.CPcuenta
			)
	</cfquery>
<cflog type="information" file="FormulacionAplica" text="insert into CPCuentaPeriodo">

	<cfquery name="rsSQL" datasource="#session.dsn#">
		select CPformato 
		  from #CTASP# 
		 where CPcuenta IS NULL
	</cfquery>
	<cfloop query="rsSQL">
		<cflog type="information" file="FormulacionAplica" text="Cuenta no creada: #rsSQL.CPformato#">
	</cfloop>
<cflog type="information" file="FormulacionAplica" text="FINAL CREACION CUENTAS">
<cflog type="information" file="FormulacionAplica" text="-----------------------------------------------------">
</cffunction>


