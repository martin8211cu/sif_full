<cfobject name="session.objInterfazSoin" component="interfacesSoin.Componentes.interfaces">
<cfset session.objInterfazSoin.sbReportarActividad(GvarNI, GvarID)>

<!--- Busca el periodo mes con que se va a trabajar --->
<cfquery name="rsInterfaz1" datasource="sifinterfaces">
    select 
        min(CPPano) as CPPano,
        min(CPPmes) as CPPmes
    from IE401
    where ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#">
</cfquery>
<cfif rsInterfaz1.recordcount EQ 0>
    <cfthrow message="No existen datos de Entrada para el ID='#GvarID#' en la Interfaz 401 (1) ">
</cfif>	
<cfset LvarPeriodoMes = rsInterfaz1.CPPano *100 + rsInterfaz1.CPPmes>

<cfset LvarCPPid = -1>
<cfquery name="rsPerMes" datasource="#session.DSN#">
    select CPPid, CPPtipoPeriodo
    from CPresupuestoPeriodo
    where Ecodigo = #session.Ecodigo#
    and CPPanoMesDesde = #LvarPeriodoMes#
</cfquery>
<cfif rsPerMes.recordcount eq 0>
    <cfthrow message="No se encontró un periodo configurado para #LvarPeriodoMes#, proceso cancelado.">
<cfelse>
    <cfset LvarCPPid = rsPerMes.CPPid>
    <cfset LvarCPPtipoPeriodo = rsPerMes.CPPtipoPeriodo>
</cfif>

<cfquery name="rsInterfaz2" datasource="sifinterfaces">
    select 
    	a.CVdescripcion,
        a.CVtipo, <!--- 1: ordinario, 2: Extraordinario --->
        a.CPPano,
        a.CPPmes,        
        Ecodigo,

        b.CPformato,
        b.CPdescripcion,
        b.CVPtipoControl,
        b.CVPcalculoControl,
        
        b.Oficodigo,
        b.Miso4217,
        b.CPCano1,
        b.CPCmes1,
        
       	b.MonTotal as Monto1, 
        0 as Monto2,
        0 as Monto3,
        0 as Monto4,
        0 as Monto5,
        0 as Monto6,
        0 as Monto7,
        0 as Monto8,
        0 as Monto9,
        0 as Monto10,
        0 as Monto11,
        0 as Monto12
        
        from IE401 a
        inner join ID401 b
        on b.ID = a.ID
     where a.ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#">
     order by b.CPformato, b.Oficodigo, b.Miso4217
</cfquery>
<cfif rsInterfaz2.recordcount EQ 0>
    <cfthrow message="No existen datos de Entrada para el ID='#GvarID#' en la Interfaz 401 (2) ">
</cfif>	


<!--- ********************************************************************** CVForm.cfm ********************************************************************** --->
<cfinclude template="/sif/presupuesto/importador/FnScripts.cfm">
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

<cfset LvarCVid = fnAltaFormulacion(session.DSN, rsInterfaz2.CVtipo, rsInterfaz2.CVdescripcion, LvarPeriodoMes, 0)>

<cfparam name="LvarCVid" default="-1">
<cfset LvarProcesaInterfaz = fnProcesaInterfaz401()>


<cffunction name="fnProcesaInterfaz401" returntype="string" access="public">
	
	<cfloop query="rsInterfaz2">
		<cfif (rsInterfaz2.currentRow mod 179 EQ 0)>
			<cfoutput>
				<!-- Flush:
					#repeatString("*",1024)#
				-->
			</cfoutput>
			<!--- veamos si hay que cancelar el proceso --->
			<cfflush>
		</cfif>
		
		<cfscript>
			LvarCtaActual = trim(rsInterfaz2.CPformato);
			LvarOfiActual = trim(rsInterfaz2.Oficodigo);
			LvarMoneda = trim(rsInterfaz2.Miso4217);
				
			if (LvarCtaAnterior NEQ LvarCtaActual)
			{
				LvarCtaAnterior = LvarCtaActual;
				LvarOfiAnterior = "";
				LvarCPcuenta 	= "";

				if (rsInterfaz2.CVPtipoControl EQ "")
					LvarCVPtipoControl = -1;
				else
					LvarCVPtipoControl = rsInterfaz2.CVPtipoControl;
				
				if (rsInterfaz2.CVPcalculoControl EQ "")
					LvarCVPcalculoControl = -1;
				else
					LvarCVPcalculoControl = rsInterfaz2.CVPcalculoControl;
				
				LvarError = fnGeneraCuentaVersion (rsInterfaz2.CPformato, LvarFechaIni, LvarCVid, LvarCVPtipoControl, LvarCVPcalculoControl, rsInterfaz2.CPdescripcion);

				if (LvarError EQ "NEW" OR LvarError EQ "OLD")
				{
					rsSQL = fnQuery("
										select 	cp.CPcuenta
										  from CPresupuesto cp
											inner join CPVigencia vg
											   on vg.Ecodigo	= cp.Ecodigo
											  and vg.Cmayor 	= cp.Cmayor
											  and vg.CPVid 		= cp.CPVid
											  and #rsInterfaz2.CPCano1*100 + rsInterfaz2.CPCmes1# between vg.CPVdesdeAnoMes and vg.CPVhastaAnoMes
										 where cp.CPformato 	='#rsInterfaz2.CPformato#'
										   and cp.Ecodigo		= #session.Ecodigo#
									");
					LvarCPcuenta  = rsSQL.CPcuenta;

					rsSQL = fnQuery("
										select CVPcuenta, CVPtipoControl, CVPcalculoControl, CPdescripcion
										  from CVPresupuesto
										 where Ecodigo=#session.Ecodigo# 
										   AND CVid=#LvarCVid# 
										   AND Cmayor='#mid(rsInterfaz2.CPformato,1,4)#'
										   AND CPformato='#rsInterfaz2.CPformato#'
									");
					LvarCVPcuenta = rsSQL.CVPcuenta;

					if ( (LvarCVPtipoControl NEQ -1 AND LvarCVPtipoControl NEQ rsSQL.CVPtipoControl) OR (LvarCVPcalculoControl NEQ -1 AND LvarCVPcalculoControl NEQ rsSQL.CVPcalculoControl) )
					{
						sbExecute ("
									update CVPresupuesto
									   set CVPtipoControl 		= #LvarCVPtipoControl#
										 , CVPcalculoControl 	= #LvarCVPcalculoControl#
									 where Ecodigo		=#session.Ecodigo# 
									   AND CVid			=#LvarCVid# 
									   AND CVPcuenta	=#LvarCVPcuenta#
									");
						sbError ("INFO", "La Cuenta de Presupuesto '#rsInterfaz2.CPformato#' ya existía y se actualizó su tipo y método de Control");
					}
					if (rsInterfaz2.CPdescripcion NEQ "" AND rsInterfaz2.CPdescripcion NEQ rsSQL.CPdescripcion)
					{
						sbExecute ("
									update CVPresupuesto
									   set CPdescripcion = '#rsInterfaz2.CPdescripcion#'
									 where Ecodigo		= #session.Ecodigo# 
									   AND CVid			= #LvarCVid# 
									   AND CVPcuenta	= #LvarCVPcuenta#
									");
						sbError ("INFO", "La Cuenta de Presupuesto '#rsInterfaz2.CPformato#' ya existía y se actualizó su Descripcion");
					}
				}
				else
				{
					LvarCVPcuenta = "";
					sbError ("FATAL", "Cuenta de Presupuesto '#rsInterfaz2.CPformato#': " & LvarError);
					continue;
				}
			}
			
			if (LvarOfiAnterior NEQ LvarOfiActual)
			{
				LvarOfiAnterior = LvarOfiActual;

				LvarPrimerMonedaXoficina = arraynew(1);
				for (i=1; i LTE 12; i = i +1)
					LvarPrimerMonedaXoficina[i] = true;
			}
			
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

				if (rsInterfaz2.CPCano1 NEQ LvarAnoIni OR rsInterfaz2.CPCmes1 NEQ LvarMesIni)
				{
					sbError ("FATAL", "Se cambio el año y mes inicial de la Importacion con la Fecha Inicial del Período: Cuenta '#rsInterfaz2.CPformato#', Oficina '#rsInterfaz2.Oficodigo#', Moneda '#rsInterfaz2.Miso4217#', Mes Inicial '#rsInterfaz2.CPCano1#-#rsInterfaz2.CPCmes1#'");
					continue;
				}

				LvarAno = LvarAnoIni;
				LvarMes = LvarMesIni;
				for (i=1; i LTE 12; i=i+1)
				{
					LvarAnoMes = LvarAno*100+LvarMes;
					LvarMonto = rsInterfaz2["Monto" & i];
					if (LvarMonto NEQ "" AND NOT isnumeric(LvarMonto))
					{
						sbError ("FATAL", "El monto debe ser numerico '#LvarMonto#': Cuenta '#rsInterfaz2.CPformato#', Oficina '#rsInterfaz2.Oficodigo#', Moneda '#rsInterfaz2.Miso4217#', Mes '#LvarAno#-#LvarMes#'");
						break;
					}
					if (NOT (LvarMonto EQ "" OR LvarMonto EQ 0 AND LvarAnoMes GT LvarAnoMesFin)) //  AND val(LvarMonto) GT 0 
					{
						if (LvarAnoMes GT LvarAnoMesFin)
						{
							sbError ("FATAL", "Se definieron más montos que el numero de meses del Periodo: Cuenta '#rsInterfaz2.CPformato#', Oficina '#rsInterfaz2.Oficodigo#', Moneda '#rsInterfaz2.Miso4217#', Mes '#LvarAno#-#LvarMes#'");
							break;
						}
						
						if (LvarPrimerMonedaXoficina[i] or true)
						{
							LvarPrimerMonedaXoficina[i] = false;						

							rsSQL = fnQuery("
												select count(1) as cantidad
												  from CVFormulacionTotales
												 where Ecodigo	=#session.Ecodigo# 
												   AND CVid		=#LvarCVid# 
												   AND CPCano	=#LvarAno#
												   AND CPCmes	=#LvarMes#
												   AND CVPcuenta=#LvarCVPcuenta#
												   AND Ocodigo	=#LvarOcodigo#
											");
							if (rsSQL.cantidad GT 0)
							{
								sbError ("INFO", "Se sustituyó la Formulación para: Cuenta '#rsInterfaz2.CPformato#', Oficina '#rsInterfaz2.Oficodigo#', Mes '#LvarAno#-#LvarMes#'");
								sbExecute ("
												update CVFormulacionTotales
												   set CVFTmontoSolicitado = 0
												 where Ecodigo	=#session.Ecodigo# 
												   AND CVid		=#LvarCVid# 
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
											   #session.Ecodigo#, #LvarCVid#, #LvarAno#, #LvarMes#, #LvarCVPcuenta#, #LvarOcodigo#,
											   0)
											");
							}
						}
						
						sbExecute ("
										delete from CVFormulacionMonedas
										 where Ecodigo	= #session.Ecodigo# 
										   AND CVid		= #LvarCVid# 
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
									   #session.Ecodigo#, #LvarCVid#, #LvarAno#, #LvarMes#, #LvarCVPcuenta#, #LvarOcodigo#,  
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
				<cfset LobjAjuste.AjustaFormulacion(LvarCVid, LvarCVPcuenta, LvarOcodigo)>
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
			Lprm_CVid="#LvarCVid#"
			Lprm_Verificar="true"
		/>
	</cfthread> 
	<cfset ERR = fnVerificaErrores()>
</cffunction>    

<cffunction name="fnGeneraCuentaVersion" returntype="string" access="public">
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
			<cfinvokeargument name="Lprm_CVid"					value="#LvarCVid#"/>
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
			   and m.CVid 		= #LvarCVid#
			   and m.Cmayor 	= '#Arguments.Cmayor#'
		</cfquery>
		
		<cfif qry_CVTipoCambioProyectadoMes.TipoCambio EQ "">
			<cfreturn "null">
		<cfelse>
			<cfreturn qry_CVTipoCambioProyectadoMes.TipoCambio & "">
		</cfif>
	</cfif>
</cffunction>

<cffunction name="fnAltaFormulacion" access="private" output="no" returntype="any">
	<cfargument name="conexion" 		required="yes" default="#session.DSN#">
    <cfargument name="CVtipo" 			required="yes">
    <cfargument name="CVdescripcion" 	required="yes" type="string">
    <cfargument name="PeriodoMes"		type="numeric" required="yes">
    <cfargument name="TipoCarga"		type="numeric" required="yes" default="0"> <!--- 0:Solo Cargar Cuentas de Mayor Existentes, 1: Cargar Montos ya Aprobados durante Período --->
    <cfargument name="CVestado" 		type="numeric" required="no" default="0"> <!--- 0: Formulación de Versión Base --->
    
    
    <cfquery name="rsSQL" datasource="#arguments.conexion#">
        select Pvalor
          from Parametros
         where Ecodigo = #Session.Ecodigo#
           and Pcodigo = 50
    </cfquery>
    <cfset LvarAuxAno = rsSQL.Pvalor>
    <cfquery name="rsSQL" datasource="#arguments.conexion#">
        select Pvalor
          from Parametros
         where Ecodigo = #Session.Ecodigo#
           and Pcodigo = 60
    </cfquery>
    <cfset LvarAuxMes = rsSQL.Pvalor>
    <cfset LvarAuxAnoMes = LvarAuxAno*100+LvarAuxMes>

    
    
	<cftransaction>
			<cfquery name="rsSQL" datasource="#arguments.conexion#">
				insert into CVersion
				(Ecodigo, CVtipo, CVdescripcion, CPPid, CVestado, CVaprobada)
				values(#Session.Ecodigo#,
					<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.CVtipo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CVdescripcion#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCPPid#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CVestado#">,
					0)
				<cf_dbidentity1 datasource="#arguments.conexion#">
			</cfquery>
			<cf_dbidentity2 datasource="#arguments.conexion#" name="rsSQL">
			<cfset LvarCVid = rsSQL.identity>
            
			<!--- Alta de las cuentas de Mayor para esta Versión --->
            <cfinclude template="/sif/Utiles/sifConcat.cfm">
			<cfquery datasource="#arguments.conexion#">
				insert into CVMayor
					(Ecodigo, 
					CVid, 
					Cmayor, 
					Ctipo, 
					CPVidOri, 
					PCEMidOri, 
					Cmascara,
					CVMtipoControl,
					CVMcalculoControl)
				select distinct
					a.Ecodigo, 
					#LvarCVid#, 
					a.Cmayor, 
					a.Ctipo, 
					b.CPVid as CPVidOri, 
					b.PCEMid as PCEMidOri, 
					d.PCEMformatoP as Cmascara,
					(case Ctipo when 'A' then 1 when 'G' then 1 else 0 end),
					2
				from CtasMayor a
					inner join CPVigencia b	<!--- Primera Vigencia del Inicio del Periodo o que empiece despues del Inicio --->
							inner join PCEMascaras d
							  on d.PCEMid = b.PCEMid
							 <cfif arguments.CVtipo EQ "2">
							 and coalesce(rtrim(d.PCEMformatoP) #_Cat# ' ',' ') <> ' '
							 </cfif>
						 ON b.Ecodigo = a.Ecodigo
						and b.Cmayor  = a.Cmayor
						
				where a.Ecodigo = #Session.Ecodigo#
                and b.CPVdesde =
							(select min(v.CPVdesde)
							   from CPVigencia v, CPresupuestoPeriodo p
							  where v.Ecodigo = a.Ecodigo
								and v.Cmayor  = a.Cmayor
							    and p.CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCPPid#">
							    and (
										p.CPPfechaDesde between v.CPVdesde 		and v.CPVhasta
									OR 
										v.CPVdesde		between p.CPPfechaDesde and p.CPPfechaHasta
									)
							)
			</cfquery>

			<cfif isdefined(arguments.TipoCarga) and arguments.TipoCarga EQ 1>
				<cfsetting requesttimeout="36000">
				<cfquery datasource="#arguments.conexion#">
					insert into CVPresupuesto
						 (Ecodigo,
						 CVid,
						 CVPcuenta,
						 Cmayor,
						 CPcuenta,
						 CPformato,
						 CPdescripcion,
						 CVPtipoControl,
						 CVPcalculoControl
						 )
					select 	a.Ecodigo, 
							#LvarCVid#, 
							a.CPcuenta,
							a.Cmayor, 
							a.CPcuenta, 
							a.CPformato,
							coalesce(a.CPdescripcionF, a.CPdescripcion),
							b.CPCPtipoControl, 
							b.CPCPcalculoControl
					  from CPresupuesto a
						inner join CPCuentaPeriodo b
							 ON b.Ecodigo 	= a.Ecodigo
							and b.CPPid  	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCPPid#">
							and b.CPcuenta	= a.CPcuenta
					 where a.Ecodigo = #Session.Ecodigo#
					   and exists
					   		(
								select 1
								  from CPControlMoneda c
								 where c.Ecodigo 	= a.Ecodigo
								   and c.CPPid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCPPid#">
								   and c.CPCano*100+c.CPCmes>=#LvarAuxAnoMes#
								   and c.CPcuenta	= a.CPcuenta
							)
				</cfquery>
				<cfquery datasource="#arguments.conexion#">
					insert into CVFormulacionTotales
						 (
							Ecodigo,
							CVid,
							CPCano,
							CPCmes,
							CVPcuenta,
							Ocodigo,
							CVFTmontoSolicitado,
							CVFTmontoAplicar
						)
					select 	a.Ecodigo, 
							#LvarCVid#, 
							a.CPCano,
							a.CPCmes,
							a.CPcuenta,
							a.Ocodigo,
							sum((CPCMpresupuestado+CPCMmodificado)*CPCMtipoCambioAplicado),
							0
					  from CPControlMoneda a
					 where a.Ecodigo 	= #Session.Ecodigo#
					   and a.CPPid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCPPid#">
					   and a.CPCano*100+a.CPCmes >= #LvarAuxAnoMes#
					 group by a.Ecodigo, a.CPCano, a.CPCmes, a.CPcuenta, a.Ocodigo
				</cfquery>
				<cfquery datasource="#arguments.conexion#">
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
							 CVFMmontoBase,
							 CVFMmontoAplicar
						)
					select 	a.Ecodigo, 
							#LvarCVid#, 
							a.CPCano,
							a.CPCmes,
							a.CPcuenta,
							a.Ocodigo,
							a.Mcodigo,
							CPCMtipoCambioAplicado,
							CPCMpresupuestado+CPCMmodificado,
							0
					  from CPControlMoneda a
					 where a.Ecodigo 	= #Session.Ecodigo#
					   and a.CPPid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCPPid#">
					   and a.CPCano*100+a.CPCmes >= #LvarAuxAnoMes#
				</cfquery>
			</cfif>
            <cfset LvarValidaciones = fnValidaciones()>
		</cftransaction>
        <cfreturn LvarCVid>
</cffunction>


<cffunction name="fnValidaciones" access="public" returntype="any">
	<!--- Como se hace para saber con cual versión se va a trabajar: se escoge una (no hay codigos) o se hace una nueva??? --->
    <cfquery name="rsSQL" datasource="#session.dsn#">
        select CVtipo, CVaprobada, v.CPPid, CPPestado, CPPfechaDesde, CPPtipoPeriodo, CPPanoMesDesde, CPPanoMesHasta
          from CVersion v
                INNER JOIN CPresupuestoPeriodo p
                    ON p.CPPid = v.CPPid
         where v.CVid = #LvarCVid#
    </cfquery>
    
    <!---  --->
    
    <cfparam name="session.chkNuevas" default="false">
    <cfif rsSQL.recordCount EQ 0>
        <cf_errorCode	code = "50484" msg = "No se ha indicado la Version de Presupuesto a Trabajar">
    <cfelseif rsSQL.CVaprobada NEQ "0">
        <cf_errorCode	code = "50485" msg = "La Version de Presupuesto ya fue Aprobada">
    <cfelseif trim(rsInterfaz2.CPformato) EQ "">
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
        <cfif (rsInterfaz2.CPCano1*100+rsInterfaz2.CPCmes1) NEQ rsSQL.CPPanoMesDesde>
            <cf_errorCode	code = "50489" msg = "El mes inicial de la Importacion no corresponde con el Inicio del Período">
        </cfif>
        <cfset LvarFechaIni = rsSQL.CPPfechaDesde>
        <cfset LvarAnoIni = datepart("yyyy",LvarFechaIni)>
        <cfset LvarMesIni = datepart("m",LvarFechaIni)>
        <cfset LvarAnoMesFin = rsSQL.CPPanoMesHasta>
    <cfelse>
        <cfif (rsInterfaz2.CPCano1*100+rsInterfaz2.CPCmes1) LT LvarAuxAnoMes>
            <cf_errorCode	code = "50490"
                            msg  = "El mes inicial de la Importacion debe comenzar igual o despues del Mes de Auxiliares: @errorDat_1@-@errorDat_2@"
                            errorDat_1="#LvarAuxAno#"
                            errorDat_2="#LvarAuxMes#"
            >
        <cfelseif (rsInterfaz2.CPCano1*100+rsInterfaz2.CPCmes1) LT rsSQL.CPPanoMesDesde OR (rsInterfaz2.CPCano1*100+rsInterfaz2.CPCmes1) GT rsSQL.CPPanoMesHasta>
            <cf_errorCode	code = "50491" msg = "El mes inicial de la Importacion no está dentro del Período de Presupuesto">
        </cfif>
        <cfset LvarFechaIni = createDate(rsInterfaz2.CPCano1, rsInterfaz2.CPCmes1, 1)>
        <cfset LvarAnoIni = datepart("yyyy",LvarFechaIni)>
        <cfset LvarMesIni = datepart("m",LvarFechaIni)>
        <cfset LvarAnoMesFin = rsSQL.CPPanoMesHasta>
    </cfif>
    
    <cfset LvarMesN   = rsSQL.CPPtipoPeriodo>
    
    
    <cfset LvarCtaAnterior = "">
</cffunction>