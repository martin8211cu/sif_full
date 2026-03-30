<cfsetting requesttimeout="84600">
<!--- VARIABLES DE TRADUCCCION  --->
<cfinvoke key="No_se_han_definido_un_tipo_de_movimiento_para_creacion_de_Plazas_Proceso_cancelado." default="No se han definido un tipo de movimiento para creaci&oacute;n de Plazas. Proceso cancelado."returnvariable="MG_TipoMovimentoCrea" component="sif.Componentes.Translate" method="Translate"/> 
<cfinvoke key="No_se_han_definido_un_tipo_de_movimiento_para_modificacion_de_Plazas_Proceso_cancelado" default="No se han definido un tipo de movimiento para modificaci&oacute;n de Plazas. Proceso cancelado." returnvariable="MG_TipoMovimentoCambio" component="sif.Componentes.Translate" method="Translate"/> 
<cfinvoke key="Las_tablas_salariales_del_escenario_ya_existen_Verifique_las_fechas" default="Las tablas salariales del escenario ya existen. Verifique las fechas." returnvariable="MG_TablasSalariales" component="sif.Componentes.Translate" method="Translate"/> 
<!--- VARIABLES DE TRADUCCCION  --->

<!--- VALIDACIONES GENERALES --->
<cfinclude template="PR-ValidaEscenario.cfm" >

<!--- VALIDACION DE CENTAS FINANCIERAS --->
<!--- TABLA TEMPORAL DE TRABAJO --->
<cf_dbtemp name="ValidaCF" returnvariable="ValidaCF" datasource="#session.DSN#">
	<cf_dbtempcol name="formato"	type="varchar(100)"	mandatory="yes" > 
</cf_dbtemp>

<cfquery name="rsCuentas" datasource="#session.dsn#">
	select distinct CFformato
	from RHCFormulacion a

	inner join RHFormulacion b
	on b.RHFid = a.RHFid
	and b.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
	and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
    
    union 
			 
    select distinct d.CFformato 
    from RHOPFormulacion a
    inner join RHOPDFormulacion d
        on d.RHOPFid = a.RHOPFid
    inner join RHOtrasPartidas c
        on c.RHOPid = a.RHOPid
    inner join RHPOtrasPartidas b
        on b.RHPOPid = c.RHPOPid
    where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
      and a.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">	
    group by d.CFformato
     
    union
    
    select distinct CFformato
    from RHCPFormulacion
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
      and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">	
      and ltrim(rtrim(CFformato))!= ''
</cfquery>
<cfquery name="rsCuentas" dbtype="query">
	select distinct CFformato as CFformato
    from rsCuentas
</cfquery>
<cfset LvarErrores = false>
<cfloop query="rsCuentas">
	<cfinvoke 
	component="sif.Componentes.PC_GeneraCuentaFinanciera"
	method="fnGeneraCuentaFinanciera"
	returnvariable="LvarResultado">
	<cfinvokeargument name="Lprm_CFformato"			value="#rsCuentas.CFformato#"/>
	<cfinvokeargument name="Lprm_fecha"             value="#now()#"/>
	<cfinvokeargument name="Lprm_EsDePresupuesto"   value="false"/>
	<cfinvokeargument name="Lprm_SoloVerificar"     value="true"/>
	<cfinvokeargument name="Lprm_NoVerificarPres"   value="true"/>
	<cfinvokeargument name="Lprm_TransaccionActiva" value="false"/>
	</cfinvoke>
	<cfif NOT (LvarResultado EQ "NEW" OR LvarResultado EQ "OLD")>
    	<cfset LvarErrores = true>
		<cfquery datasource="#session.DSN#">
			insert into #ValidaCF#( formato )	
			values ( <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCuentas.CFformato#"> )
		</cfquery>
	</cfif>
</cfloop>

<cfif LvarErrores >
	<cfinclude template="PR-ErroresCuenta.cfm">
	<cfabort>
</cfif>

<!--- 	1.	CREACION DE MOVIMIENTOS DE PLAZA QUE NO SON POR SOLICITUD
			Copia toda la tabla RHFormulacion a RHMovPlaza.
			Ojo, debe darse cuenta si va a crear un plaza o si va 
			a modificar una. Se va a crear plaza presupuestaria, el campo RHPPid de fortmulacion es vacio.
			Si va a modificar plaza este campo viene lleno. De algun lado debe darse cuenta cual tipo de movimiento [id de movimiento]
			va a ejecutar.
			Este insert es masivo.
--->


<!--- Tipo de Movimiento para crear los movimientos --->
<cfquery name="rsTipo10" datasource="#session.DSN#">
	select min(RHTMid) as tipo
	from RHTipoMovimiento
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and RHTMcomportamiento = 10
</cfquery>
<cfif len(rsTipo10.tipo) is 0 >
	<cf_throw message="#MG_TipoMovimentoCrea#" errorcode="7045">
	<cfabort>
</cfif>

<!--- Tipo de Movimiento para crear los movimientos --->
<cfquery name="rsTipo20" datasource="#session.DSN#">
	select min(RHTMid) as tipo
	from RHTipoMovimiento
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and RHTMcomportamiento = 20
</cfquery>
<cfif len(rsTipo20.tipo) is 0 >
	<cf_throw message="#MG_TipoMovimentoCambio#" errorcode="7050">
	<cfabort>
</cfif>

<!--- Tabla Temporal para Solicitudes de Plaza --->
<cf_dbtemp name="solicitudes" returnvariable="solicitudes" datasource="#session.DSN#">
	<cf_dbtempcol name="RHSPid" 		type="numeric"	mandatory="yes" >  
	<cf_dbtempcol name="consecutivo" 	type="integer"	mandatory="yes" >  
	<cf_dbtempcol name="desde" 			type="datetime"	mandatory="yes" >  
	<cf_dbtempcol name="hasta"			type="datetime"	mandatory="yes" > 
	<cf_dbtempcol name="cantidad"		type="integer"	mandatory="no" > 
	<cf_dbtempcol name="RHMPPid"		type="numeric"	mandatory="no" >  
	<cf_dbtempcol name="RHCid"	 		type="numeric"	mandatory="no" >  
	<cf_dbtempcol name="RHTTid" 		type="numeric"	mandatory="no" > 
	<cf_dbtempcol name="negociado" 		type="char(1)"	mandatory="no" > 
	<cf_dbtempcol name="monto" 			type="numeric"	mandatory="no" > 
	<cf_dbtempcol name="Mcodigo" 		type="numeric"	mandatory="no" > 
	<cf_dbtempcol name="CFid"	 		type="numeric"	mandatory="no" > 
	<cf_dbtempcol name="grupo"	 		type="integer"	mandatory="no" > 
	<cf_dbtempcol name="RHFid"	 		type="numeric"	mandatory="no" >
    <cf_dbtempcol name="codigo" 		type="char(10)"	mandatory="no" > 
</cf_dbtemp>

<cftransaction>
	<!--- ============================================================================ --->
	<!--- INSERTA LOS MOVIMIENTOS QUE VIENEN POR SOLICITUD --->
	<!--- ============================================================================ --->
	<cfquery datasource="#session.DSN#">
		insert into ##solicitudes( RHSPid, consecutivo, RHFid, desde, hasta, cantidad, RHMPPid, RHCid, RHTTid, negociado, monto, Mcodigo, CFid, codigo )

		select sa.RHSPid, sp.RHSPconsecutivo, f.RHFid, f.fdesdeplaza, coalesce(f.fhastaplaza, '61000101'), sp.RHSPcantidad, f.RHMPPid, f.RHCid, f.RHTTid, f.RHMPnegociado, f.RHFmonto, f.Mcodigo, f.CFidnuevo, sp.RHSPcodigo
		from RHFormulacion f

		inner join RHEscenarios	e
		on e.RHEid=f.RHEid
		and e.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
		and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">

		inner join RHSituacionActual sa
		on f.RHSAid=sa.RHSAid
		and sa.RHSPid is not null
		
		inner join RHSolicitudPlaza sp
		on sp.RHSPid=sa.RHSPid
		
		where f.RHPPid is null
		order by sa.RHSPid
	</cfquery>
	
	<!--- ========================== --->
	<!---    Agrupar los registros   --->
	<!--- ========================== --->
	<!--- 1. Obtiene las diferentes solicitudes que se van a procesar --->
	<cfquery name="rsSolicitud" datasource="#session.DSN#">
		select distinct RHSPid
		from ##solicitudes
		order by RHSPid
	</cfquery>
	<cfloop query="rsSolicitud">
		<cfset vRHSPid = rsSolicitud.RHSPid >
		<cfquery name="rsFechas" datasource="#session.DSN#" >
			select distinct desde, hasta
			from ##solicitudes
			where RHSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vRHSPid#" >
			order by desde
		</cfquery>
		
		<cfloop query="rsfechas">
			<cfset continuar = true >
			<cfset i = 1 >
			<cfloop condition="continuar eq true">
				<cfquery name="rsModificar" datasource="#session.DSN#">
					select min(RHFid) as RHFid
					from ##solicitudes
					where RHSPid = #vRHSPid#
					  and desde = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsFechas.desde#" >
					  and grupo is null
				</cfquery>
	
				<cfif rsModificar.recordcount gt 0 and len(trim(rsModificar.RHFid)) >
					<cfquery datasource="#session.DSN#">
						update ##solicitudes
						set grupo = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#">
						where RHFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsModificar.RHFid#">
						  and RHSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vRHSPid#">
					</cfquery>

					<cfset i = i + 1 >
				<cfelse>
					<cfset continuar = false >
				</cfif>	
				
			</cfloop>
		</cfloop>
	</cfloop>
	<!--- ========================== --->	
	
	<cfquery name="data" datasource="#session.DSN#">
		select 	a.RHSPid,
				a.consecutivo,
				min(b.RHFid) as RHFid, 
				sp.RHSPfdesde as desde,
				sp.RHSPfhasta as hasta,
				a.cantidad, 
				a.RHMPPid, 
				a.RHCid, 
				a.RHTTid, 
				'T' as Tipo,
				min(a.monto) as monto, 
				a.Mcodigo, 
				a.CFid,
				a.grupo,
                a.codigo,
                case when a.negociado is null then 'N' else a.negociado end as negociado
		from ##solicitudes a
        	inner join ##solicitudes b 
             	on b.grupo = a.grupo and b.consecutivo = a.consecutivo
           	inner join RHSolicitudPlaza sp
				on sp.RHSPid = a.RHSPid
      	where b.monto = (select min(c.monto) from ##solicitudes c where c.grupo = a.grupo and c.consecutivo = a.consecutivo)
       	group by a.RHSPid, a.consecutivo, sp.RHSPfdesde, sp.RHSPfhasta, a.cantidad, a.RHMPPid, a.RHCid, a.RHTTid, a.Mcodigo, a.CFid, a.grupo, a.codigo, a.negociado
        order by a.RHSPid, a.grupo, a.consecutivo
	</cfquery>
	<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
	<cfoutput query="data">
		<cfset vRHSPid = data.RHSPid >
		<cfset vConsecutivo = data.consecutivo >
        <cfloop from="1" to="#data.cantidad#" index="i">
			<cfset corte = true >
			<cfset vRHPPid = '' >
            <cfquery name="insMov" datasource="#session.DSN#">
                insert into RHMovPlaza(	Ecodigo, 
                                        RHPPid, 
                                        RHPPcodigo, 
                                        RHPPdescripcion, 
                                        RHMPPid, 
                                        RHCid, 
                                        RHTTid, 
                                        RHTMid, 
                                        RHMPfdesde, 
                                        RHMPfhasta, 
                                        RHMPestado, 	
                                        RHMPnegociado, 
                                        RHMPmonto, 
                                        Mcodigo, 
                                        CFidant, 	
                                        CFidnuevo, 
                                        CFidcostoant, 
                                        CFidcostonuevo,
                                        RHFid,
                                        BMfecha, 
                                        BMUsucodigo,
                                        RHTMporcentaje)
                values( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#" >,
                        <cfif corte >null<cfelse><cfqueryparam cfsqltype="cf_sql_numeric" value="#vRHPPid#"></cfif>, 
                        <cfif corte ><cfif data.cantidad gt 0>'#trim(data.codigo)#<cfif data.cantidad gt 1>#i#</cfif>'<cfelse>'PP#vConsecutivo#-#data.grupo#'</cfif><cfelse>null</cfif>,
                        <cfif corte >'Plaza generada por solicitud ' #LvarCNCT# convert(varchar, #vConsecutivo# ) #LvarCNCT# ':#data.grupo#'<cfelse>null</cfif>,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.RHMPPid#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.RHCid#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.RHTTid#">,
                        <cfif corte>
                            <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTipo10.tipo#">
                        <cfelse>	
                            <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTipo20.tipo#">
                        </cfif>,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#data.desde#">,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#data.hasta#">,
                        'P',
                        <cfqueryparam cfsqltype="cf_sql_char" value="#data.negociado#">,
                        <cfqueryparam cfsqltype="cf_sql_money4" value="#data.monto#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.Mcodigo#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.CFid#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.CFid#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.CFid#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.CFid#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.RHFid#">,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
                        100)
                <cf_dbidentity1 datasource="#session.DSN#" verificar_transaccion="no">
            </cfquery>
            <cf_dbidentity2 datasource="#session.DSN#" name="insMov" verificar_transaccion="no">
			<!--- Detalle del Movimiento ( componentes salariales ) --->
            <cfquery datasource="#session.DSN#" name="x">
                select <cfqueryparam cfsqltype="cf_sql_numeric" value="#insMov.identity#">,
                       c.CSid, 
                       <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#" >,
                       c.Cantidad, 
                       c.Monto, 
                       c.CFformato,
                       <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                       <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
                from RHMovPlaza a
                	inner join RHFormulacion b
                		on b.RHFid = a.RHFid and b.RHEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
                	inner join RHCFormulacion c
                		on c.RHFid=b.RHFid
                where a.RHMPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#insMov.identity#">
            </cfquery>

            <cfquery datasource="#session.DSN#">
                insert RHCMovPlaza( RHMPid, CSid, Ecodigo, Cantidad, Monto, CFformato, BMfecha, BMUsucodigo )
                select <cfqueryparam cfsqltype="cf_sql_numeric" value="#insMov.identity#">,
                       c.CSid, 
                       <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#" >,
                       c.Cantidad, 
                       c.Monto, 
                       c.CFformato,
                       <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                       <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
                from RHMovPlaza a
                    inner join RHFormulacion b
                    	on b.RHFid = a.RHFid and b.RHEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
                    inner join RHCFormulacion c
                    	on c.RHFid=b.RHFid
                where a.RHMPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#insMov.identity#">
            </cfquery>	
            <cfinvoke component="rh.Componentes.RH_AplicaMovimientoPlaza" method="AplicaMovimientoPlaza" returnvariable="rvRHPPid" > 
                <cfinvokeargument name="RHMPid" value="#insMov.identity#">
                <cfinvokeargument name="acciones" value="false">
                <cfinvokeargument name="debug" value="no">
            </cfinvoke>
			<cfset vRHPPid = rvRHPPid >				
            <cfset corte = false >
		</cfloop>
	</cfoutput> 
	<!--- ============================================================================ --->

	<!--- ============================================================================ --->
	<!--- INSERTA LOS MOVIMIENTOS QUE TIENEN PLAZA PRESUPUESTARIA DEFINIDA --->
	<!--- ============================================================================ --->

	<!--- ============================================================================ --->
	<!--- Inserta movimientos de plaza que NO vienen de solicitudes  --->
	<!--- ============================================================================ --->
	<cfquery datasource="#session.DSN#" >
		insert RHMovPlaza(	Ecodigo, 
							RHPPid, 
							RHPPcodigo, 
							RHPPdescripcion, 
							RHMPPid, 
							RHCid, 
							RHTTid, 
							RHTMid, 
							RHMPfdesde, 
							RHMPfhasta, 
							RHMPestado, 	
							RHMPnegociado, 
							RHMPmonto, 
							Mcodigo, 
							CFidant, 	
							CFidnuevo, 
							CFidcostoant, 
							CFidcostonuevo, 
							BMfecha, 
							BMUsucodigo, 
							RHFid)
		select 	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				f.RHPPid,
		   		null,
				null,	
				f.RHMPPid,
				f.RHCid,
				f.RHTTid,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTipo20.tipo#">,
				fdesdecorte,
				fhastacorte,
				'P',
				case when f.RHTTid is not null and f.RHCid is not null and f.RHMPPid is not null then 'T' else 'N' end, 
				f.RHFmonto,
				f.Mcodigo,
				f.CFidant,
				f.CFidnuevo,
				f.CFidcostoant,
				f.CFidcostonuevo,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
				f.RHFid
		from RHFormulacion f
		inner join RHEscenarios e
		on e.RHEid=f.RHEid
		where f.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
		  and f.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and f.RHPPid is not null
	</cfquery>

	<cfquery datasource="#session.DSN#">
		insert into RHCMovPlaza( RHMPid, 
								 CSid, 
								 Ecodigo, 
								 Cantidad, 
								 Monto, 
								 CFformato, 
								 BMfecha, 
								 BMUsucodigo )
		
		select mp.RHMPid, 
			   cf.CSid, 
			   <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">, 
			   cf.Cantidad, 
			   cf.Monto, 
			   cf.CFformato, 
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		from RHCFormulacion cf
		
		inner join RHFormulacion f
		on f.RHFid = cf.RHFid
		and f.RHPPid is not null <!--- solo movimientos con plaza ya generada --->
	
		inner join RHEscenarios e
		on e.RHEid = f.RHEid
		and e.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
		and e.Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	
		inner join RHMovPlaza mp
		on mp.RHFid=cf.RHFid

	</cfquery>

	<!--- 	=============================================================================
			Inserta un corte para el rango donde cae la fecha hasta del movimiento
			Seria desde al fecha hast adel mov +1 dia, hasta la fecha hasta del corte
			donde cae la fecha hasta del mov
			=============================================================================  --->
	
	<!--- Encabezado LT --->
	<cfquery datasource="#session.DSN#">
		insert into RHLineaTiempoPlaza( Ecodigo,
								RHPPid,
								RHCid,
								RHMPPid,
								RHTTid,
								RHMPid,
								RHPid,
								CFidautorizado,
								RHLTPfdesde,
								RHLTPfhasta,
								CFcentrocostoaut,
								RHMPestadoplaza,
								RHMPnegociado,
								RHLTPmonto,
								Mcodigo,
								BMfecha,
								BMUsucodigo )
		select 	a.Ecodigo,
				a.RHPPid,
				a.RHCid,
				a.RHMPPid,
				a.RHTTid,
				a.RHMPid,
				a.RHPid,
				a.CFidautorizado,
				dateadd( dd, 1, b.RHMPfhasta), 
				a.RHLTPfhasta, 
				a.CFidautorizado,
				a.RHMPestadoplaza,
				a.RHMPnegociado,
				a.RHLTPmonto,
				a.Mcodigo,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
		
		from RHLineaTiempoPlaza a
		
		inner join RHMovPlaza b
		on b.RHPPid=a.RHPPid
		and b.RHMPfhasta between a.RHLTPfdesde and  a.RHLTPfhasta
		and b.RHMPfhasta != a.RHLTPfhasta
		and b.RHMPestado = 'P'
		<!---and b.RHFid = 225471--->
		<!---and b.RHPPid = 500000000024189--->
		
		inner join RHFormulacion f
		on f.RHFid = b.RHFid
		
		inner join RHEscenarios e
		on e.RHEid = f.RHEid
		and e.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
		
		where  a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>

	<!--- Detalle LT --->
	<cfquery datasource="#session.DSN#">
		insert into RHCLTPlaza( RHLTPid, CSid, Ecodigo, Cantidad, Monto, CFformato, BMfecha, BMUsucodigo )
		select 	a1.RHLTPid, 
				c.CSid, 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">, 
				c.Cantidad,
				c.Monto, 
				c.CFformato, 
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
		
		from RHLineaTiempoPlaza a1
		
		inner join RHLineaTiempoPlaza a2
		on a2.RHLTPid = a1.referencia
		
		inner join RHCLTPlaza c
		on c.RHLTPid=a2.RHLTPid
		
		where a1.referencia is not null
		 and a1.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		 and a1.RHPPid in ( select p.RHPPid
							from RHMovPlaza p
							inner join RHFormulacion f
							on f.RHFid=p.RHFid
							inner join RHEscenarios e
							on e.RHEid=f.RHEid
							and e.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#"> )
	</cfquery>

	<!--- limpia el campo de referencia --->
	<cfquery datasource="#session.DSN#">
		update RHLineaTiempoPlaza
		set referencia = null
		where referencia is not null
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>

	<!--- 	=============================================================================
			Corre la fecha hasta de la linea del tiempo a la fecha desde del movimiento menos un dia  
			=============================================================================  --->
	<cfquery datasource="#session.DSN#">
		update RHLineaTiempoPlaza 
		set RHLTPfhasta = dateadd(dd, -1, b.RHMPfdesde )
		from RHLineaTiempoPlaza a
		
		inner join RHMovPlaza b
		on b.RHPPid=a.RHPPid
		and b.RHMPfdesde between a.RHLTPfdesde and  a.RHLTPfhasta
		and b.RHMPfdesde != a.RHLTPfdesde
		and b.RHMPestado = 'P'
		<!---and b.RHFid = 225471 --->
		<!---and b.RHPPid = 500000000024189 --->
		
		inner join RHFormulacion c
		on c.RHFid=b.RHFid
		
		inner join RHEscenarios e
		on e.RHEid=c.RHEid
		and e.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
		
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>	


	<!--- 	=============================================================================
			Borra los cortes que estan en medio del desde y hasta del movimiento 
			============================================================================= ----->

	<!--- Borra Componentes asociados a la LT --->
	<cfquery datasource="#session.DSN#">
		delete RHCLTPlaza
		
		from RHLineaTiempoPlaza a
		
		inner join  RHMovPlaza b
		on b.RHPPid=a.RHPPid
		and b.RHMPfdesde  <= a.RHLTPfhasta
		and b.RHMPfhasta >= a.RHLTPfdesde
		and b.RHMPestado = 'P'
		<!---and b.RHFid = 225471 --->
		<!---and b.RHPPid = 500000000024189 --->
		
		inner join RHFormulacion c
		on c.RHFid=b.RHFid
		
		inner join RHEscenarios d
		on d.RHEid=c.RHEid
		and d.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
		
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.RHLTPid=RHCLTPlaza.RHLTPid
	</cfquery>

	<!--- Borra el registro relacionado a la LT --->
	<cfquery datasource="#session.DSN#">
		delete RHLineaTiempoPlaza
		
		from  RHMovPlaza b
		
		inner join RHFormulacion c
		on c.RHFid=b.RHFid
		
		inner join RHEscenarios d
		on d.RHEid = c.RHEid
		and d.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
		
		where RHLineaTiempoPlaza.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and b.RHPPid=RHLineaTiempoPlaza.RHPPid
		and b.RHMPfdesde  <= RHLineaTiempoPlaza.RHLTPfhasta
		and b.RHMPfhasta >= RHLineaTiempoPlaza.RHLTPfdesde
		and b.RHMPestado = 'P'
		<!---and b.RHFid = 225471 ----->
		<!---and RHLineaTiempoPlaza.RHPPid = 500000000024189 ----->
	</cfquery>

	<!--- 	============================================================================= 
			INSERTAR CORTE NUEVO
			=============================================================================  --->
	<!--- Inserta registro en la linea del tiempo --->
	<cfquery datasource="#session.DSN#">
		insert into RHLineaTiempoPlaza( Ecodigo,
								RHPPid,
								RHCid,
								RHMPPid,
								RHTTid,
								RHMPid,
								RHPid,
								CFidautorizado,
								RHLTPfdesde,
								RHLTPfhasta,
								CFcentrocostoaut,
								RHMPestadoplaza,
								RHMPnegociado,
								RHLTPmonto,
								Mcodigo,
								BMfecha,
								BMUsucodigo )
		select 	a.Ecodigo,
				a.RHPPid,
				a.RHCid,
				a.RHMPPid,
				a.RHTTid,
				a.RHMPid,
				( select max(p.RHPid) 
				  from RHLineaTiempoPlaza p
				  where p.RHPPid = a.RHPPid
					and p.Ecodigo = a.Ecodigo ),
				a.CFidnuevo,
				a.RHMPfdesde,
				coalesce(a.RHMPfhasta, '61000101'),
				a.CFidcostonuevo,
				a.RHMPestadoplaza,
				a.RHMPnegociado,
				a.RHMPmonto,
				a.Mcodigo,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
		from RHMovPlaza a
		
		inner join RHFormulacion b
		on b.RHFid = a.RHFid
		
		inner join RHEscenarios e
		on e.RHEid=b.RHEid
		and e.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
		
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.RHMPestado = 'P'
		<!---and exists ( select 1 from RHPlazas pl where pl.RHPPid = a.RHPPid )--->
	</cfquery>

	<!--- Inserta componentes relacionados a los movimientos --->
	<cfquery datasource="#session.DSN#">
		insert into RHCLTPlaza( RHLTPid, CSid, Ecodigo, Cantidad, Monto, CFformato, BMfecha, BMUsucodigo )
		select d.RHLTPid, 
			   a.CSid, 
			   <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">, 
			   a.Cantidad, 
			   a.Monto, 
			   a.CFformato, 
			   <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, 
			   <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
		from RHCFormulacion a
		
		inner join RHFormulacion b
		on b.RHFid=a.RHFid
		
		inner join RHMovPlaza c
		on c.RHFid=b.RHFid
		and c.RHMPestado = 'P'
		<!---and c.RHFid = 225471 --->
		<!---and c.RHPPid = 500000000024189--->
		
		inner join RHEscenarios e
		on b.RHEid = e.RHEid
		and e.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
		and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		
		inner join RHLineaTiempoPlaza d
		on d.RHMPid = c.RHMPid
	</cfquery>

	<!--- Calcula el CPcuenta --->

	<cfquery datasource="#session.DSN#">
		update RHEscenarios
		   set RHEestado = 'A'
		where RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
	</cfquery>

	<!--- Escenario/Presupuesto --->
	<cfinvoke component="sif.Componentes.PRES_Formulacion" method="sbGenerarEscenario" >
		<cfinvokeargument name="RHEid" value="#form.RHEid#"/>
	</cfinvoke>

	<!--- Modifica los movimientos para ponerlos procesados --->
	<cfquery datasource="#session.DSN#">
		update RHMovPlaza
		set RHMPestado = 'A'
		
		from RHFormulacion f
		
		inner join RHEscenarios e
		on e.RHEid=f.RHEid
		and e.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
		
		where RHMovPlaza.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and RHMovPlaza.RHMPestado='P'
		and f.RHFid=RHMovPlaza.RHFid
	</cfquery>
	
	<!--- ============================================================================= 
				Inserción de Tablas Salariales del Escenario y sus componentes
		  ============================================================================= --->	
	<!---Validar que no exista ya una tabla salarial VIGENTE (Aplicada) que contenga las fechas del escenario----->
	<cfquery name="rsVerifica" datasource="#session.DSN#">
		select count(1) as rsCantidad
		from RHVigenciasTabla a
			inner join RHETablasEscenario b
				on a.RHVTfecharige  <= b.RHETEfhasta		
				and a.RHVTfechahasta >= b.RHETEfdesde		
				and b.RHEid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
				and b.RHVTestado = 'A'
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">		
	<cfif rsVerifica.RecordCount NEQ 0 and rsVerifica.rsCantidad EQ 0>
		<!---Insertar las tablas salariales del escenario---->
		<cfquery name="rsEncabezado" datasource="#session.DSN#">					
			select 	a.RHETEid,
					'TS- ' #LvarCNCT#convert(varchar,b.RHEdescripcion) as RHVTdescripcion,
					a.RHTTid,
					a.RHETEfdesde as RHVTfecharige,
					a.RHETEfhasta as RHVTfechahasta
			from RHETablasEscenario a
				inner join RHEscenarios b
					on a.RHEid = b.RHEid
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and a.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
		</cfquery>

		<cfloop query="rsEncabezado">
			<cfquery name="rsUltimoCodigo" datasource="#session.DSN#"><!----Obtener el último RHVTcodigo---->
				select coalesce(max(RHVTcodigo),0) + 1 as NuevoRHVTcodigo
				from RHVigenciasTabla
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>
			
			<cfquery name="rsInserta" datasource="#session.DSN#">
				insert into RHVigenciasTabla (Ecodigo, 
											RHVTcodigo, 
											RHVTdescripcion, 
											RHTTid, 
											RHVTfecharige, 
											RHVTfechahasta, 
											RHVTtablabase, 
											RHVTporcentaje, 
											RHVTdocumento, 
											RHVTestado, 
											BMfalta, 
											BMfmod, 
											BMUsucodigo)
				values(	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#rsUltimoCodigo.NuevoRHVTcodigo#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEncabezado.RHVTdescripcion#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.RHTTid#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsEncabezado.RHVTfecharige#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsEncabezado.RHVTfechahasta#">,	
						null,
						null,
						null,
						'A',
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
						)
				<cf_dbidentity1 datasource="#session.DSN#">									
			</cfquery>
			<cf_dbidentity2 datasource="#session.DSN#" name="rsInserta">
			
			<!----- Inserta los componentes ----->						
			<cfquery name="rsInsertaComp" datasource="#session.DSN#">
				insert into RHMontosCategoria (RHVTid, 
												CSid, 
												RHCPlinea, 
												RHMCmonto, 
												RHVTfrige, 
												RHVTfhasta, 
												BMfalta, 
												BMfmod, 
												BMUsucodigo
												)
				select 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsInserta.Identity#">,			
						CSid,
						null,
						RHDTEmonto,
						RHDTEfdesde,
						RHDTEfhasta,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">		
				from RHDTablasEscenario 
				where RHETEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.RHETEid#">					
			</cfquery>
		</cfloop>
	<cfelse>
		<cf_throw message="#MG_TablasSalariales#" errorcode="7055">
	</cfif><!----Fin de verificacion de tablas salariales---->	
	
	<!--- =================================================================================== 
			Actualiza el saldo de las solicitudes de plaza atendidas por el escenario
	  =================================================================================== --->
	<cfquery name="rsDatosUpdate" datasource="#session.DSN#">
		select RHSPid, count(RHSPid) as saldo
		from RHSituacionActual 
		where RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#"> 
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and RHSPid is not null
		group by RHSPid		
	</cfquery>
	<cfloop query="rsDatosUpdate">
		<cfquery name="rsUpdateSaldoSol" datasource="#session.DSN#">
			Update RHSolicitudPlaza 
				set saldo = saldo - <cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatosUpdate.saldo#">
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and RHSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatosUpdate.RHSPid#">
		</cfquery>
	</cfloop>		
	<!----Actualizar el estado de las solicitudes de plaza si el saldo es 0---->
	<cfquery name="rsUpdateEstadoSol" datasource="#session.DSN#">
		update RHSolicitudPlaza
			set RHSPestado = 40
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
			and saldo = 0
	</cfquery>				

</cftransaction>

<cflocation url="RHEscenarios-lista.cfm">

