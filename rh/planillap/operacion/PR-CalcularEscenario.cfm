<cfsetting requesttimeout="3600">
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="No_se_han_definido_Tablas_Salariales_para_el_escenario_Proceso_cancelado" default="No se han definido Tablas Salariales para el escenario. Proceso cancelado." returnvariable="MG_TablasSalariales" component="sif.Componentes.Translate" method="Translate"/> 
<cfinvoke key="No_se_ha_generado_la_Situacion_Actual_para_el_escenario_Proceso_cancelado" default="No se ha generado la Situaci&oacute;n Actual para el escenario. Proceso cancelado." returnvariable="MG_SituacionActual" component="sif.Componentes.Translate" method="Translate"/> 
<!--- FIN VARIABLES DE TRADUCCION --->

<cfquery name="rsCalculado" datasource="#session.DSN#">
	select RHEcalculado
	from RHEscenarios
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#" >
	and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#" >
</cfquery>
<!--- /***********************************************************/ --->
<cfset  rsCalculado.RHEcalculado = 0>
<!--- /***********************************************************/ --->
<cfif rsCalculado.RHEcalculado eq 0 >
	<!--- VALIDACIONES --->
	
		<!--- Valida la existencia de Tablas Salariales para el Escenario --->
		<cfquery name="tablas" datasource="#session.DSN#">
			select RHETEid 
			from RHETablasEscenario
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
		</cfquery>
		<cfif tablas.recordcount eq 0>
			<cf_throw message="#MG_TablasSalariales#" errorcode="7040">
		</cfif>
	
		<!--- Valida la existencia de Situacion Actual para el Escenario --->
		<cfquery name="rsValidarDatos" datasource="#session.DSN#">
			select count(1) as total
			from RHSituacionActual
			where RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
		</cfquery>
		<cfif rsValidarDatos.total eq 0 >
			<cf_throw message="#MG_SituacionActual#" errorcode="7035">
		</cfif>
	
		<!---Obtener la moneda de la empresa---->
		<cfquery name="rsMoneda" datasource="#session.DSN#">
			select Mcodigo
			from Empresas
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		
        <!--- SE ELIMINAN LOS DATOS DE LAS CARGAS --->
    	<cfquery datasource="#session.DSN#">
        	delete from RHCPFormulacion
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
              and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
        </cfquery>
		<cfquery datasource="#session.DSN#">
			delete RHCortesPeriodoF 
			from  RHCortesPeriodoF a
			
			inner join RHCFormulacion b
			on b.RHCFid = a.RHCFid
			
			inner join RHFormulacion c
			on c.RHFid = b.RHFid
			and c.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
			
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		</cfquery>
		
		<!--- ELIMINA EL DETALLE DE OTRAS PARTIDAS --->
		<cfquery name="deleteOP" datasource="#session.DSN#">
			delete RHOPDFormulacion
			from RHOPDFormulacion a
			inner join RHOPFormulacion b
				on b.RHOPFid = a.RHOPFid
			where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and b.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
		</cfquery>
		<!--- ELIMINA LOS DATOS DE LAS OTRAS PARTIDAS --->
		<cfquery name="deleteOP" datasource="#session.DSN#">
			delete from RHOPFormulacion
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
		</cfquery>
		
		<!---- Elimina detalle de formulacion --->
		<cfquery datasource="#session.DSN#">
			delete RHCFormulacion 
			from RHCFormulacion a
			inner join RHFormulacion b
			on b.RHFid=a.RHFid
			and b.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
	
	
		<!----Eliminar datos del escenario------>
		<cfquery name="rsElimina" datasource="#session.DSN#">
			delete 
			from RHFormulacion
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
		</cfquery>
		
		
	<cftransaction>
		<!----Inserta datos---->
		<cfquery name="rsInserta" datasource="#session.DSN#">
		insert into RHFormulacion (Ecodigo, 
										RHEid, 
										RHPPid, 
										RHMPPid, 
										RHCid, 
										RHTTid, 
										RHTMid, 									
										RHETEid, 
										CFidant, 
										CFidnuevo, 
										CFidcostoant, 
										CFidcostonuevo, 
										RHFmonto, 
										Mcodigo, 
										RHFreal, 
										RHMPnegociado, 
										fdesdeplaza, 
										fhastaplaza, 
										fdesdecorte, 
										fhastacorte, 
										BMfecha, 
										BMUsucodigo,
										RHSAid
										)

				select 	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> as Ecodigo,
					a.RHEid as RHEid,
					a.RHPPid as RHPPid,
					a.RHMPPid as RHMPPid,
					a.RHCid as RHCid,
					a.RHTTid as RHTTid,
					null as RHTMid,
					b.RHETEid,
					case when a.RHPPid is not null then  d.CFidautorizado else e.CFid end as CFidant,
					case when a.RHPPid is not null then  d.CFidautorizado else e.CFid end as CFidnuevo,
					case when a.RHPPid is not null then  d.CFidautorizado else e.CFid end as CFidcostoant,
					case when a.RHPPid is not null then  d.CFidautorizado else e.CFid end as CFidcostonuevo,
					0.00 as RHFmonto,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMoneda.Mcodigo#"> as Mcodigo,
					case when a.RHPPid is not null then  1 else 0 end as RHFreal,
					null as RHMPnegociado,			
					a.fdesdeplaza as fdesdeplaza,
					a.fhastaplaza	as fhastaplaza,
					case when b.RHETEfdesde <  a.fdesdeplaza then  a.fdesdeplaza else b.RHETEfdesde end as fdesdecorte,
					case when b.RHETEfhasta > a.fhastaplaza then a.fhastaplaza else b.RHETEfhasta end as fhastacorte,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					a.RHSAid
					
			from RHSituacionActual a
				inner join RHEscenarios es
					on a.RHEid = es.RHEid
					and es.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and es.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
					
				inner join RHETablasEscenario b
					on a.RHEid = b.RHEid
					and b.RHTTid=a.RHTTid
					and a.fdesdeplaza <= b.RHETEfhasta
					and a.fhastaplaza >= b.RHETEfdesde
		
				left join RHLineaTiempoPlaza d
					on a.RHPPid = d.RHPPid
					and a.Ecodigo = d.Ecodigo
					and a.fdesdeplaza = d.RHLTPfdesde
					and a.fhastaplaza = d.RHLTPfhasta
			
				left outer join RHSolicitudPlaza e
					on a.RHSPid = e.RHSPid
					
			where a.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
			and exists (  select 1
					   from RHDTablasEscenario dte
					  where dte.RHEid=a.RHEid
					    and dte.RHTTid=a.RHTTid
					    and dte.RHMPPid=a.RHMPPid
					    and dte.RHCid=a.RHCid  )
			order by a.RHTTid
		</cfquery>
		<!--- Inserta Componentes para la formulacion --->
		<!--- Inserta los componentes asociados a la plaza presupuestaria	--->
		<cfquery name="rsInserta" datasource="#session.DSN#">
			  insert into RHCFormulacion( RHFid, CSid, Ecodigo, Cantidad, Monto, CFformato, BMfecha, BMUsucodigo )  
			select fm.RHFid, 
				   csa.CSid, 
				   <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">, 
				   csa.Cantidad, 
				   csa.Monto, 
				   csa.CFformato, 
				   <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, 
				   <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			from RHFormulacion fm		 
				inner join RHSituacionActual st
					on fm.RHSAid = st.RHSAid
	
					inner join RHEscenarios es
						on fm.RHEid = es.RHEid
						and es.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
						and es.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	
	
				inner join RHCSituacionActual csa
					on csa.RHSAid = st.RHSAid
			where st.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
		</cfquery>
		<!--- Actualiza montos del la Formulacion --->
		<!--- NOTA: no me dejo hacer un update from con group by, por eso hice esto --->
		<!--- DUDA: Hace sum de RHCFormulacion a RHFormulacion, no esta tomando en cuenta los cortes( aqui estan los calculos segun los dias trabajados)
				Esto esta correcto asi....??
		--->
		<cf_dbtemp name="montos" returnvariable="montos" datasource="#session.DSN#">
			<cf_dbtempcol name="RHFid"		 type="numeric"  mandatory="yes"> 
			<cf_dbtempcol name="monto"		 type="money"    mandatory="yes">
		</cf_dbtemp>
		<cfquery datasource="#session.DSN#">
			insert into #montos#(RHFid, monto)
			select a.RHFid, sum(b.Monto) as monto
	
			from RHFormulacion a
			
				inner join RHEscenarios es
					on a.RHEid = es.RHEid
					and es.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
					and es.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				
				inner join RHCFormulacion b
					on b.RHFid=a.RHFid
			
			where a.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
			group by a.RHFid
		</cfquery>
		<cfquery datasource="#session.DSN#" >
			update RHFormulacion
			set RHFmonto = #montos#.monto,
				BMfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			from #montos#
			where RHFormulacion.RHFid =#montos#.RHFid
			  and RHFormulacion.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		
		<!--- DATOS DE OTRAS PARTIDAS --->
		<cfquery name="rsInserta" datasource="#session.DSN#">
			insert into RHOPFormulacion(RHEid,RHOPid,Ecodigo,RHOPFmonto,Mcodigo,fdesde,fhasta,BMfecha,BMUsucodigo)
			select RHEid,RHOPid,Ecodigo,0.00,<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMoneda.Mcodigo#">,fechadesde,fechahasta,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			from  RHOtrasPartidas
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
		</cfquery>
		<!--- INSERTA EL DETALLE DE OTRAS PARTIDAS --->
		<cfquery name="rsInsertaD" datasource="#session.DSN#">
			insert into RHOPDFormulacion(RHOPFid,CFid,Mes,Periodo,Monto,BMfecha,BMUsucodigo)
			select a.RHOPFid,c.CFid,
					c.Mes, c.Periodo, c.Monto,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			from RHOPFormulacion a
			inner join RHOtrasPartidas b
				on b.RHEid = a.RHEid
				and b.RHOPid = a.RHOPid
			inner join RHDOtrasPartidas c
				on c.RHOPid = b.RHOPid 
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and a.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
		</cfquery>
		<cfquery name="UpdateOPF" datasource="#session.DSN#">
			update RHOPFormulacion
			set RHOPFmonto = (select sum(Monto)
							  from RHOPDFormulacion op
							  where op.RHOPFid = RHOPFormulacion.RHOPFid)
			where exists( select 1
							from RHOPFormulacion a
							inner join RHOtrasPartidas b
								on b.RHEid = a.RHEid
								and b.RHOPid = a.RHOPid
							inner join RHDOtrasPartidas c
								on c.RHOPid = b.RHOPid 
							where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							  and a.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
							  and a.RHOPFid = RHOPFormulacion.RHOPFid)
		</cfquery>
	</cftransaction>	

		<!--- ============================================================================================================= --->
		<!---	Update  del CFformato. La cuenta se arma de la siguiente manera:
					Los comodines ? --> Se sustituyen por el complemento tomado del Componente(Guardado en CFformato temporalmente)
					Los comodines * --> Se sustituyen por el complemento de la plaza (RHPlazaPresupuestaria.Complemento)
					Los comodines ! --> Se sustituyen por el complemento del puesto (RHMaestroPuestoP.Complemento) --->
		<!--- ============================================================================================================= --->		
		<!----**********************	USANDO EL COMPONENTE DE COLDFUSION ***************************************---->
		<cfobject component="sif.Componentes.AplicarMascara" name="Obj_CFormato">
		<cfquery name="rsUpdateCuenta" datasource="#session.DSN#">
			select 	distinct 	cfu.CFid,
								cfu.CFcuentac as Formato, 
								cf.CFformato as Complemento, 														
								mp.Complemento as ComplementoMP, 
								pp.Complemento as ComplementoPP
			from RHFormulacion fm
				inner join RHEscenarios es
					on fm.RHEid = es.RHEid
				
				inner join CFuncional cfu
					on fm.CFidant = cfu.CFid
			
				inner join RHCFormulacion cf
					on cf.RHFid = fm.RHFid
					
				left outer join RHMaestroPuestoP mp
					on fm.RHMPPid = mp.RHMPPid
				
				left outer join RHPlazaPresupuestaria pp
					on fm.RHPPid = pp.RHPPid
			
			where fm.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">	
					and es.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	
					and cfu.CFcuentac is not null
					and ltrim(rtrim(cfu.CFcuentac)) != ''
					and cf.CFformato is not null				
					and ltrim(rtrim(cf.CFformato))!= ''
		</cfquery>
		<cfloop query="rsUpdateCuenta">
			<cfset vs_fcomplemento =''>
			<cfset vs_CPformato    =''>
			<!---Sustituye el comodín ? ---->
			<cfset vs_fcomplemento = Obj_CFormato.AplicarMascara(rsUpdateCuenta.Formato,rsUpdateCuenta.Complemento)>
			<!---Sustituye el comodín * ---->
			<cfset vs_fcomplemento = Obj_CFormato.AplicarMascara(vs_fcomplemento, rsUpdateCuenta.ComplementoPP,'*')>
			<!---Sustituye el comodín ! ---->
			<cfset vs_fcomplemento = Obj_CFormato.AplicarMascara(vs_fcomplemento,rsUpdateCuenta.ComplementoMP,'!')>

			<!----///////////////// PARA PRESUPUESTO /////////////////////////----->
			<cfif len(trim(vs_fcomplemento))>			
				<cfset vn_posicionInicial = Find('-',vs_fcomplemento,0)><!---Posicion del primer - que separa la cuenta de mayor--->
				<cfif vn_posicionInicial NEQ 0>
					<cfset vs_cuentaMayor = Mid(vs_fcomplemento,1,vn_posicionInicial-1)><!----Separar la cuenta de mayor del CFformato---->
					<cfif FindOneOf('*?!',vs_cuentaMayor,1) EQ 0><!---Si no se encontro ningun caracter de comodin en la cuenta mayor---->
						<cfquery name="rsNiveles" datasource="#session.DSN#">
							select PCEMnivelesP
							from CPVigencia vig
								inner join PCEMascaras mas
								 on	mas.PCEMid = vig.PCEMid
							where vig.Cmayor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#vs_cuentaMayor#">
								and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between CPVdesde and CPVhasta
						</cfquery>

						<cfif isdefined("rsNiveles") and rsNiveles.RecordCount neq 0 and len(trim(rsNiveles.PCEMnivelesP))>
							<cfset vs_CPformato = Obj_CFormato.ExtraerNivelesP(vs_fcomplemento,rsNiveles.PCEMnivelesP)>
						</cfif>
					</cfif>
				</cfif>
			</cfif>	
			
			<!----///////////////// UPDATE DEL CAMPO CPformato (Para presupuesto) /////////////////////////----->		
			<cfif isdefined("vs_CPformato") and len(trim(vs_CPformato))>
				<cfquery name="rsUpdateCPformato" datasource="#session.DSN#">			
					update RHCFormulacion 
								set CPformato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#vs_CPformato#">
					from RHFormulacion fm		
						inner join RHEscenarios es
							on fm.RHEid = es.RHEid
							and es.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
							and es.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	
						inner join CFuncional cfu
							on fm.CFidant = cfu.CFid
							and cfu.CFcuentac = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsUpdateCuenta.Formato#">
							and cfu.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsUpdateCuenta.CFid#"> 
					
						inner join RHCFormulacion cf
							on cf.RHFid = fm.RHFid
							and cf.CFformato is not null				
							and ltrim(rtrim(cf.CFformato))!= ''
							and cf.CFformato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsUpdateCuenta.Complemento#">
							
						inner join RHMaestroPuestoP mp
							on fm.RHMPPid = mp.RHMPPid
							<cfif len(trim(rsUpdateCuenta.ComplementoMP)) gt 0>
								and mp.Complemento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsUpdateCuenta.ComplementoMP#">
							<cfelse>
								and mp.Complemento is null
							</cfif>
						<!--- 	
						inner join RHPlazaPresupuestaria pp
							on fm.RHPPid = pp.RHPPid
							and pp.Complemento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsUpdateCuenta.ComplementoPP#"> --->
				
					where fm.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">		
						<!----and fm.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">---->
				</cfquery>
			
			</cfif>
			<!----///////////////// UPDATE DEL CAMPO CFformato /////////////////////////------>		
			<!---Actualizar los registros con la combinacion de: Formato(Del ctro funcional), Complemento(del Componente), Complemento Plaza Presup.y Complemento Puesto Presup ----->	
			<cfquery name="rsActualiza" datasource="#session.DSN#">
				update RHCFormulacion 
					set CFformato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#vs_fcomplemento#"> 
				from RHFormulacion fm
			
					inner join RHEscenarios es
						on fm.RHEid = es.RHEid
						and es.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
						and es.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							
					inner join CFuncional cfu
						on fm.CFidant = cfu.CFid
						and cfu.CFcuentac = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsUpdateCuenta.Formato#">
						and cfu.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsUpdateCuenta.CFid#"> 
				
					inner join RHCFormulacion cf
						on cf.RHFid = fm.RHFid
						and cf.CFformato is not null				
						and ltrim(rtrim(cf.CFformato))!= ''
						and cf.CFformato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsUpdateCuenta.Complemento#">
						
					inner join RHMaestroPuestoP mp
						on fm.RHMPPid = mp.RHMPPid
						and mp.Complemento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsUpdateCuenta.ComplementoMP#">
						
			
				where  fm.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#"> 
			</cfquery>
		</cfloop>
		
		<!--- ======================================================================== --->
		<!--- ======================================================================== --->	
		<!--- CALCULO DEL ESCENARIO --->

		<!--- ======================================================================== --->
		<!--- ======================================================================== --->	
		

		<!--- ========================================================================== --->
		<!--- PRESUPUESTO: Llenado de la tabla RHCortesPeriodoF, de meses presupuestaros --->
		<!--- ========================================================================== --->	
		<!--- TABLA TEMPORAL DE MESES:
			  Se usa para poder partir un rango de fechas en los mese que la comprenden.
			  Se llena con el rango de fechas que va desde la fecha minima de formulacion
			  Hasta la fecha maxima de formulacion. Con eso se obtienen todas las fechas
			  en juego.
		--->
		<cf_dbtemp name="Mes" returnvariable="mes" datasource="#session.DSN#">
			<cf_dbtempcol name="mes"		type="int"      mandatory="yes">
			<cf_dbtempcol name="periodo"	type="int"     mandatory="yes">
		</cf_dbtemp>
	<cftransaction>

		<cfquery name="rsInicio" datasource="#session.DSN#">
			select min(fdesdecorte) as desde
			from RHFormulacion
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
		</cfquery>
		<cfquery name="rsFinal" datasource="#session.DSN#">
			select max(fhastacorte) as hasta
			from RHFormulacion
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
		</cfquery>
		<cfset inicio = rsInicio.desde >
		<cfset fin = rsFinal.hasta >
		<cfloop condition=" inicio lte fin " >
			<cfquery datasource="#session.DSN#">
				insert into #mes#(mes, periodo)
				values( <cfqueryparam cfsqltype="cf_sql_integer" value="#datepart('m', inicio)#">, 
						<cfqueryparam cfsqltype="cf_sql_integer" value="#datepart('yyyy', inicio)#"> )
			</cfquery>
			<cfset inicio = dateadd('m', 1, inicio) >
		</cfloop>
		<!--- TABLA TEMPORAL DE TRABAJO --->
		<cf_dbtemp name="cortes" returnvariable="cortes" datasource="#session.DSN#">
			<cf_dbtempcol name="RHFid"		 type="numeric"  mandatory="yes"> 
			<cf_dbtempcol name="RHCFid"		 type="numeric"  mandatory="yes"> 
			<cf_dbtempcol name="Ecodigo"	 type="int"      mandatory="yes"> 
			<cf_dbtempcol name="periodo"	 type="int"      mandatory="yes"> 
			<cf_dbtempcol name="mes"		 type="int"      mandatory="yes"> 
			<cf_dbtempcol name="fdesdecorte" type="datetime" mandatory="yes"> 
			<cf_dbtempcol name="fhastacorte" type="datetime" mandatory="yes"> 
			<cf_dbtempcol name="permes"		 type="int" 		mandatory="yes"> 
			<cf_dbtempcol name="CSid"		 type="numeric"  mandatory="yes"> 
			<cf_dbtempcol name="Cantidad"	 type="float"    mandatory="yes"> 
			<cf_dbtempcol name="Monto"		 type="money"    mandatory="yes">
		</cf_dbtemp>
		<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
		<cfquery name="consulta" datasource="#session.DSN#" >
			 insert into #cortes#( RHFid, RHCFid, Ecodigo, periodo, mes, fdesdecorte, fhastacorte, permes, CSid, Cantidad, Monto ) 
			select 	f.RHFid, 
					cf.RHCFid ,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					m.periodo, 
					m.mes, 
					f.fdesdecorte , 
					f.fhastacorte, 
					convert(int, convert(varchar, m.periodo) #LvarCNCT# case when mes < 10 then '0' #LvarCNCT# convert(varchar,mes) else  convert(varchar,mes) end) as permes,
					cf.CSid,
					cf.Cantidad,
					cf.Monto
			from RHFormulacion f
			
			inner join RHCFormulacion cf
			on cf.RHFid = f.RHFid
			
			inner join #mes# m
			on convert( int, convert(varchar, m.periodo) #LvarCNCT#  ltrim(rtrim((case when m.mes < 10 then '0' else ''  end))) #LvarCNCT#  convert(varchar, m.mes) #LvarCNCT# '01')*100  
				 >=  convert(int,  convert(varchar,	( convert(datetime, rtrim(convert(varchar,datepart(yy,f.fdesdecorte))) #LvarCNCT# case when datepart(mm,f.fdesdecorte) < 10 then '0' #LvarCNCT# rtrim(convert(varchar,datepart(mm,f.fdesdecorte))) else convert(varchar,datepart(mm,f.fdesdecorte)) end #LvarCNCT# '01' )	)	, 112)  )*100
				and  convert( int,  convert(varchar, m.periodo) #LvarCNCT# ltrim(rtrim((case when m.mes < 10 then '0' else ''  end))) #LvarCNCT# convert(varchar, m.mes) #LvarCNCT# '01' )*100 
				<= convert(int,  convert(varchar, f.fhastacorte, 112))*100
			where RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
			order by f.RHFid, CSid, periodo, mes
		</cfquery>
		<!--- Modificacion de las fechas de los diferentes meses y periodos generados. 
			  Estas fechas ir desde el primer dia del mes, hasta el ultimo,
			  con la excepcion cuando el movimiento no empieze ni el primer ni el 
			  ultimo dia del mes
			  Los dos querys hacen lo mismo.
		--->
		<cfquery datasource="#session.DSN#">
			update #cortes# set fdesdecorte =  convert( datetime,
													 convert(varchar, periodo) #LvarCNCT# case when mes < 10 then '0' #LvarCNCT# convert(varchar, mes) else  convert(varchar, mes) end #LvarCNCT# '01')
			where permes != (select min(permes) from #cortes# a where a.RHFid = RHFid)
			  and abs(datediff(mm,fdesdecorte, fhastacorte)) > 0
		</cfquery>
	 
		<cfquery datasource="#session.DSN#">
			update #cortes# set fhastacorte = convert( datetime,
													convert( varchar,periodo) #LvarCNCT# 
															 case when mes < 10 then '0' #LvarCNCT# 
																					  convert(varchar,mes) 
																	else  convert(varchar,mes) end #LvarCNCT# 
																		  case when mes in (1,3,5,7,8,12) then '31' 
																			   when mes = 2 then '28' 
																			   else '30' end)
			where permes != (select max(permes) from #cortes# a where a.RHFid = RHFid)
			  and abs(datediff(mm,fdesdecorte, fhastacorte)) > 0
		</cfquery>
	
		<cfquery datasource="#session.DSN#">
			insert into RHCortesPeriodoF( RHCFid, Ecodigo, Periodo, Mes, fdesde, fhasta, CSid, Cantidad, Monto, BMfecha, BMUsucodigo )
			select 	RHCFid, 
					Ecodigo, 
					periodo, 
					mes, 
					fdesdecorte, 
					fhastacorte, 
					CSid, 
					Cantidad, 
					Monto, 
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			from #cortes#
		</cfquery>
		
		<cfquery datasource="#session.DSN#">
			update RHCortesPeriodoF
			set Monto = (b.Monto * (abs(datediff(dd, fdesde, fhasta ))+1)) / 
						( abs(datediff( dd, 
										convert(varchar, RHCortesPeriodoF.Periodo) #LvarCNCT# convert(varchar, case when RHCortesPeriodoF.Mes < 10 then '0'#LvarCNCT# convert(varchar, RHCortesPeriodoF.Mes) else convert(varchar, RHCortesPeriodoF.Mes)  end ) #LvarCNCT# '01',  
										convert(varchar, dateadd(dd, -1, dateadd(mm, 1,  convert(varchar, RHCortesPeriodoF.Periodo)#LvarCNCT#convert(varchar, case when RHCortesPeriodoF.Mes < 10 then '0'#LvarCNCT# convert(varchar, RHCortesPeriodoF.Mes) else convert(varchar, RHCortesPeriodoF.Mes)  end ) #LvarCNCT# '01')) ,112) )) + 1 )
			from RHCFormulacion b
			
			inner join RHFormulacion c
			on c.RHFid = b.RHFid
			and c.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
			
			where b.RHCFid=RHCortesPeriodoF.RHCFid
			  and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>	
		<!--- ACTUALIZA LOS CAMPOS DE DISPONIBLE PARA EL PROCESO DE VALIDACION --->
		<cfquery name="UpdateDisponible" datasource="#session.DSN#">
			update RHFormulacion
			set RHFdisponible = RHFmonto,
				BMfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
		</cfquery>
		<cfquery name="UpdateDisponible" datasource="#session.DSN#">
			update RHCFormulacion
			set RHCFdisponible = (select sum(cp.Monto)
									from RHCortesPeriodoF cp
									inner join RHCFormulacion cf
										on cf.RHCFid = cp.RHCFid     
									where cf.RHFid = b.RHFid
									  and cf.RHCFid = b.RHCFid),
				RHCFPresupuestado = (select sum(cp.Monto)
									from RHCortesPeriodoF cp
									inner join RHCFormulacion cf
										on cf.RHCFid = cp.RHCFid     
									where cf.RHFid = b.RHFid
									  and cf.RHCFid = b.RHCFid),
				BMfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			from RHFormulacion a
			inner join RHCFormulacion b
				on b.RHFid = a.RHFid
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and a.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
		</cfquery>
		<cfquery name="UpdateDisponible" datasource="#session.DSN#">
			update RHOPFormulacion
			set RHOPFdisponible = RHOPFmonto,
				BMfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
		</cfquery>
        
        <!--- *******************   CALCULO DEL LAS CARGAS SOBRE LOS MONTOS PRESUPUESADOS ************************** --->
        <!--- CONSULTAR LOS PERIODOS, MES QUE SE DEFINIDIERON--->
        <cfquery name="rsCortesPM" datasource="#session.DSN#">
        	select distinct periodo,mes
            from #cortes#
            union
            select distinct Periodo,Mes
            from RHDOtrasPartidas
        </cfquery>
        <!--- CONSULTAR LOS CENTROS FUNCIONALES QUE SE DEFINIDIERON--->
        <cfquery name="rsCFuncional" datasource="#session.DSN#">
        	select distinct CFidnuevo as CFid
            from RHFormulacion
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
              and CFidnuevo > 0
            union
            select distinct CFid
            from RHOtrasPartidas a
            inner join RHDOtrasPartidas b
            	on b.RHOPid = a.RHOPid
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
              and CFid > 0
        </cfquery>
        <!--- CONSULTAR LOS CENTROS FUNCIONALES  --->
        <!--- PARA CADA CARGA PATRONAL, SE GENERA UN REGISTRO PERIODO MES PARA EL CALCULO --->
        <cfloop query="rsCFuncional">
            <cfloop query="rsCortesPM">
                <cfquery datasource="#session.DSN#">
                    insert into RHCPFormulacion(Ecodigo, RHEid, DClinea,CFid,Mes,Periodo,CFformato,Mcodigo,BMfecha,BMUsucodigo )
                    select Ecodigo,RHEid,DClinea,
                    	<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCFuncional.CFid#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCortesPM.Mes#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCortesPM.Periodo#">,
                        RHECPcuentac,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMoneda.Mcodigo#">,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
                    from RHECargasPatronales
                    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                      and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
                </cfquery>
            </cfloop>
        </cfloop>
        <!--- ACTUALIZA LOS MONTO PARA CADA UNA DE LAS CARGAS --->
        <cfquery datasource="#session.DSN#">
        	update RHCPFormulacion
            set RHCPFmontoTotal = coalesce((select sum(a.Monto)
                                            from RHCortesPeriodoF a
                                            inner join RHCFormulacion d
                                                on d.RHCFid = a.RHCFid
                                            inner join ComponentesSalariales b
                                                on b.CSid = a.CSid
                                                and b.Ecodigo = a.Ecodigo
                                            inner join RHFormulacion e
                                                    on e.RHFid = d.RHFid
                                                    and e.Ecodigo = a.Ecodigo
                                            inner join CIncidentes c
                                                on c.CIid = b.CIid
                                                and c.Ecodigo = a.Ecodigo
                                            where a.Ecodigo = RHCPFormulacion.Ecodigo
                                              and c.CInocargasley = 0
                                              and e.RHEid = RHCPFormulacion.RHEid
                                              and a.Periodo = RHCPFormulacion.Periodo
                                              and a.Mes = RHCPFormulacion.Mes
                                              and e.CFidnuevo = RHCPFormulacion.CFid),0.00)
	   		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">                                   
        </cfquery>
        <cfquery datasource="#session.DSN#">
            update RHCPFormulacion
            set RHCPFmontoTotal = RHCPFmontoTotal + coalesce((select sum(Monto)
                                                            from RHOPFormulacion a
                                                            inner join RHOPDFormulacion b
                                                                on b.RHOPFid = a.RHOPFid
                                                            where a.Ecodigo = RHCPFormulacion.Ecodigo
                                                              and a.RHEid = RHCPFormulacion.RHEid
                                                              and b.Mes = RHCPFormulacion.Mes
                                                              and b.Periodo = RHCPFormulacion.Periodo
                                                              and b.CFid = RHCPFormulacion.CFid),0.00)
           where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">           
        </cfquery>
        <!--- CALCULA EL MONTO POR CARGAS PARA CADA UNO DE LOS MONTOS POR MES CUANDO ES METODO PORCENTAJE --->
        <cfquery datasource="#session.DSN#">
        	update RHCPFormulacion
            set RHCPFmontoCarga = RHCPFmontoTotal * coalesce((select RHECPvalor 
            										from RHECargasPatronales a
                                                    where a.Ecodigo = RHCPFormulacion.Ecodigo
                                                      and a.RHEid = RHCPFormulacion.RHEid
                                                      and a.DClinea = RHCPFormulacion.DClinea
                                                      and a.RHECPmetodo = 1),0.00)/100
           where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">           
        </cfquery>
        <!--- CALCULA EL MONTO POR CARGAS PARA CADA UNO DE LOS MONTOS POR MES CUANDO ES METODO MONTO --->
        <cfquery datasource="#session.DSN#">
        	update RHCPFormulacion
            set RHCPFmontoCarga = RHCPFmontoCarga + coalesce((select RHECPvalor 
            										from RHECargasPatronales a
                                                    where a.Ecodigo = RHCPFormulacion.Ecodigo
                                                      and a.RHEid = RHCPFormulacion.RHEid
                                                      and a.DClinea = RHCPFormulacion.DClinea
                                                      and a.RHECPmetodo = 0),0.00)
           where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">           
        </cfquery>

        <!--- SUMAR A LOS MONTOS TOTALES EL MONTO DE LAS CARGAS A LAS QUE SE LES CALCULA DE NUEVO CARGAS --->
        <cfquery datasource="#session.DSN#">
        	update RHCPFormulacion
            set RHCPFmontoTotal = RHCPFmontoTotal + coalesce((select sum(RHCPFmontoCarga)
                                                    from RHCPFormulacion a
                                                    inner join RHECargasPatronales b
                                                        on b.DClinea = a.DClinea
                                                        and b.Ecodigo = a.Ecodigo
                                                        and b.RHEid = a.RHEid
                                                    where a.Ecodigo = c.Ecodigo
                                                      and a.RHEid = c.RHEid
                                                      and RHECPaplicaCargas = 1
                                                      and a.Mes = c.Mes
                                                      and a.Periodo = c.Periodo
                                                      and a.CFid = c.CFid),0)
	   		from RHCPFormulacion c
            inner join RHECargasPatronales b
                on b.DClinea = c.DClinea
                and b.Ecodigo = c.Ecodigo
                and b.RHEid = c.RHEid
            where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and c.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">    
              and b.RHECPaplicaCargas = 0
                                             
        </cfquery>
        <!--- DE NUEVO CALCULA EL MONTO POR CARGAS PARA CADA UNO DE LOS MONTOS POR MES CUANDO ES METODO PORCENTAJE --->
        <cfquery datasource="#session.DSN#">
        	update RHCPFormulacion
            set RHCPFmontoCarga = RHCPFmontoTotal * (coalesce((select RHECPvalor 
            										from RHECargasPatronales a
                                                    where a.Ecodigo = RHCPFormulacion.Ecodigo
                                                      and a.RHEid = RHCPFormulacion.RHEid
                                                      and a.DClinea = RHCPFormulacion.DClinea
                                                      and a.RHECPmetodo = 1),0.00)/100)
           where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">           
        </cfquery>
        <!--- DE NUEVO  CALCULA EL MONTO POR CARGAS PARA CADA UNO DE LOS MONTOS POR MES CUANDO ES METODO MONTO --->
        <cfquery datasource="#session.DSN#">
        	update RHCPFormulacion
            set RHCPFmontoCarga = RHCPFmontoCarga + coalesce((select RHECPvalor 
            										from RHECargasPatronales a
                                                    where a.Ecodigo = RHCPFormulacion.Ecodigo
                                                      and a.RHEid = RHCPFormulacion.RHEid
                                                      and a.DClinea = RHCPFormulacion.DClinea
                                                      and a.RHECPmetodo = 0),0.00)
           where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">           
        </cfquery>
		<!--- ******************************* --->
        <cf_dumptable var="RHCPFormulacion" top="10" abort="false">
        
     <!--- ACTUALIZA LA CUENTA  DE LAS CARGAS --->
		<cfquery name="rsUpdateCuenta" datasource="#session.DSN#">
			select 	distinct 	cfu.CFid,
								cfu.CFcuentac as Formato, 
								fm.CFformato as Complemento
			from RHCPFormulacion fm
				inner join RHEscenarios es
					on fm.RHEid = es.RHEid
				
				inner join CFuncional cfu
					on fm.CFid = cfu.CFid
			
			where fm.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">	
              and es.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	
              and ltrim(rtrim(cfu.CFcuentac)) != ''
              and cfu.CFcuentac is not null
              and fm.CFformato is not null				
              and ltrim(rtrim(fm.CFformato))!= ''
		</cfquery>
		<cfloop query="rsUpdateCuenta">
			<cfset vs_fcomplemento =''>
			<cfset vs_CPformato    =''>
			<!---Sustituye el comodín ? ---->
			<cfset vs_fcomplemento = Obj_CFormato.AplicarMascara(rsUpdateCuenta.Formato,rsUpdateCuenta.Complemento)>

			<!----///////////////// PARA PRESUPUESTO /////////////////////////----->
			<cfif len(trim(vs_fcomplemento))>			
				<cfset vn_posicionInicial = Find('-',vs_fcomplemento,0)><!---Posicion del primer - que separa la cuenta de mayor--->
				<cfif vn_posicionInicial NEQ 0>
					<cfset vs_cuentaMayor = Mid(vs_fcomplemento,1,vn_posicionInicial-1)><!----Separar la cuenta de mayor del CFformato---->
					<cfif FindOneOf('*?!',vs_cuentaMayor,1) EQ 0><!---Si no se encontro ningun caracter de comodin en la cuenta mayor---->
						<cfquery name="rsNiveles" datasource="#session.DSN#">
							select PCEMnivelesP
							from CPVigencia vig
								inner join PCEMascaras mas
								 on	mas.PCEMid = vig.PCEMid
							where vig.Cmayor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#vs_cuentaMayor#">
								and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between CPVdesde and CPVhasta
						</cfquery>

						<cfif isdefined("rsNiveles") and rsNiveles.RecordCount neq 0 and len(trim(rsNiveles.PCEMnivelesP))>
							<cfset vs_CPformato = Obj_CFormato.ExtraerNivelesP(vs_fcomplemento,rsNiveles.PCEMnivelesP)>
						</cfif>
					</cfif>
				</cfif>
			</cfif>	
			
			<!----///////////////// UPDATE DEL CAMPO CPformato (Para presupuesto) /////////////////////////----->		
			<cfif isdefined("vs_CPformato") and len(trim(vs_CPformato))>
				<cfquery name="rsUpdateCPformato" datasource="#session.DSN#">			
					update RHCPFormulacion 
					set CPformato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#vs_CPformato#">
                    
                    from RHCPFormulacion fm
                    inner join RHEscenarios es
                        on fm.RHEid = es.RHEid
                    
                    inner join CFuncional cfu
                        on fm.CFid = cfu.CFid
                
                    where fm.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">	
                      and es.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	
                      and ltrim(rtrim(cfu.CFcuentac)) != ''
                      and cfu.CFcuentac = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsUpdateCuenta.Formato#">
                      and fm.CFformato is not null				
                      and ltrim(rtrim(fm.CFformato))!= ''
                      and cfu.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsUpdateCuenta.CFid#">   
                      and fm.CFformato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsUpdateCuenta.Complemento#">    
					
				</cfquery>
			
			</cfif>
			<!----///////////////// UPDATE DEL CAMPO CFformato /////////////////////////------>		
			<!---Actualizar los registros con la combinacion de: Formato(Del ctro funcional), Complemento(del Componente), Complemento Plaza Presup.y Complemento Puesto Presup ----->	
			<cfquery name="rsActualiza" datasource="#session.DSN#">
				update RHCPFormulacion 
					set CFformato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#vs_fcomplemento#"> 
				from RHCPFormulacion fm
                inner join RHEscenarios es
                    on fm.RHEid = es.RHEid
                
                inner join CFuncional cfu
                    on fm.CFid = cfu.CFid
            
                where fm.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">	
                  and es.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	
                  and ltrim(rtrim(cfu.CFcuentac)) != ''
                  and cfu.CFcuentac = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsUpdateCuenta.Formato#">
                  and fm.CFformato is not null				
                  and ltrim(rtrim(fm.CFformato))!= ''
                  and cfu.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsUpdateCuenta.CFid#">   
                  and fm.CFformato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsUpdateCuenta.Complemento#">    
                
			</cfquery>
		</cfloop>
	

		<!--- <!--- Pone calculado el escenario --->
		<cfquery datasource="#session.DSN#">
			update RHEscenarios
			set RHEcalculado = 1
			where RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
		</cfquery> --->
	
	</cftransaction>	
		<!--- ======================================================================== --->
		<!--- ======================================================================== --->	
</cfif>

<cfoutput>
<form action="Resumen-CalculoEscenario.cfm" method="post" name="sql">
	<input name="RHEid" type="hidden" value="#Form.RHEid#">
</form>
</cfoutput>	
<html><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></html>