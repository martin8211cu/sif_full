<cfinclude template="FnScripts.cfm">

<cfquery  name="rsImportador" datasource="#session.dsn#">
  select * from #table_name# 
  order by ANOMESDESDE,Cuenta
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
<cfset LvarAuxAnoMes = LvarAuxAno*100+LvarAuxMes>   <!---201301--->

<cfset LvarCtaAnterior	= "">
<cfset Lvarerror	= "0">
<cfloop query="rsImportador">
	<cfset session.Importador.Avance = rsImportador.currentRow/rsImportador.recordCount>

	<cfif left(rsImportador.ANOMESDESDE,4) gt rsImportador.PERIODO>
        <cfset sbError("FATAL", "El Periodo '#rsImportador.PERIODO#' es menor al periodo de inicio '#left(rsImportador.ANOMESDESDE,4)#' definido'")>
        <cfset Lvarerror	= "1">
    </cfif>
    
    <cfif left(rsImportador.ANOMESHASTA,4) lt rsImportador.PERIODO>
        <cfset sbError ("FATAL", "El Periodo '#rsImportador.PERIODO#' es mayor al periodo final '#left(rsImportador.ANOMESHASTA,4)#' definido'")>
        <cfset Lvarerror	= "1">
    </cfif>
        
    <cfif (left(rsImportador.ANOMESDESDE,4) eq rsImportador.PERIODO) and (right(rsImportador.ANOMESDESDE,2) gt rsImportador.MES)>
        <cfset sbError ("FATAL", "El mes '#rsImportador.MES#' es menor al mes de inicio '#right(rsImportador.ANOMESDESDE,2)#' definido'")>
        <cfset Lvarerror	= "1">
    </cfif>
    <cfif (left(rsImportador.ANOMESHASTA,4) eq rsImportador.PERIODO) and (right(rsImportador.ANOMESHASTA,2) lt rsImportador.MES)>
        <cfset sbError ("FATAL", "El mes '#rsImportador.MES#' es mayor al mes final '#right(rsImportador.ANOMESHASTA,2)#' definido'")>
        <cfset Lvarerror	= "1">
    </cfif>
    <cfif rsImportador.PERIODO lt LvarAuxAno>
        <cfset sbError ("FATAL", "El periodo '#rsImportador.PERIODO#' es menor al periodo de cierre de auxiliares'")>
        <cfset Lvarerror	= "1">
    </cfif>
    <cfif (rsImportador.PERIODO eq LvarAuxAno) and (rsImportador.MES lt LvarAuxMes)>
        <cfset sbError ("FATAL", "El mes '#rsImportador.MES#' es menor al mes de cierre de auxiliares'")>
        <cfset Lvarerror	= "1">
    </cfif>
    <cfif Lvarerror eq "1">
        <cfbreak>
    </cfif>
	
	<!---Busco el PresupuestoPeriodo--->
	<cfquery name ="rs_periodo" datasource="#session.dsn#"> 
			select 	CPPid, CPPestado,			
			case CPPtipoPeriodo 
			when 1 then 1 
			when 2 then 2 
			when 3 then 3 
			when 4 then 4 
			when 6 then 6 
			when 12 then 12 
			else 0 end as Num_Meses,
			CPPanoMesDesde, CPPanoMesHasta,left(CPPanoMesDesde,4) as Anio, 
			right(CPPanoMesDesde,2)as Mes
			from CPresupuestoPeriodo p
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and CPPanoMesDesde = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsImportador.ANOMESDESDE#">
				and CPPanoMesHasta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsImportador.ANOMESHASTA#">
	</cfquery>
	<cfif rs_periodo.recordCount eq 0>
		<cfset sbError ("FATAL", "El periodo contable no está definido'")>
        <cfbreak>
	</cfif>
	
	<cfif (rs_periodo.CPPestado NEQ "1")>
		<cfset sbError ("FATAL", "El periodo #rs_periodo.CPPanoMesDesde# - #rs_periodo.CPPanoMesHasta# no esta abierto")>
        <cfbreak>
	</cfif>	
    
	<cfset 	Anio_ini = #rs_periodo.Anio#>
	<cfset 	Mes_ini  = #rs_periodo.Mes#>
	<cfset 	Meses 	 = #rs_periodo.Num_Meses#>
	<cfset 	CPPid 	 = #rs_periodo.CPPid#>
		
	<cfset 	LvarCtaActual = #trim(rsImportador.Cuenta)#>
			
	<cfif LvarCtaAnterior NEQ LvarCtaActual>
		<cfset 	LvarCtaAnterior = LvarCtaActual>
		<cfset 	LvarCcuenta 	= "">
		<!---Verifico Cuenta--->
		<cfquery name ="rsSQLCuenta" datasource="#session.dsn#"> 
        	select c.Ccuenta, cf.CFcuenta, cv.CPVid, p.CPcuenta, p.CPformato, p.CPdescripcion 
			    from CPresupuesto p
				  inner join CPVigencia cv on cv.CPVid = p.CPVid 
				       and #rsImportador.ANOMESDESDE# between cv.CPVdesdeAnoMes and cv.CPVhastaAnoMes
					  ----- and #rsImportador.ANOMESHASTA# between cv.CPVdesdeAnoMes and cv.CPVhastaAnoMes
				    left join CFinanciera cf 
     			  	on cf.CPcuenta = p.CPcuenta
			     left join CContables c on cf.Ccuenta = c.Ccuenta 
  				where p.Ecodigo	= #session.Ecodigo# 
               		AND p.Cmayor		= '#mid(rsImportador.Cuenta,1,4)#'
		            AND p.CPformato	= '#rsImportador.Cuenta#'	
		</cfquery>
	<!---	<cfif rsSQLCuenta.CFcuenta EQ "">
			<cfset 	sbError ("FATAL", "No existe una Cuenta Financiera vigente asociada a la Cuenta Contable '#rsImportador.Cuenta#'")>
            <cfbreak>
        </cfif>--->
		<cfif rsSQLCuenta.CPcuenta EQ "">
			<cfset sbError ("FATAL", "No existe una Cuenta Presupuestal vigente asociada a la Cuenta Contable '#rsImportador.Cuenta#'")>
            <cfbreak>
        </cfif>
		<cfset LvarCcuenta = #rsSQLCuenta.CPcuenta#>
	</cfif>
		
	<cfif LvarCcuenta NEQ "">
		<!---Busco la cuenta en la tabla CPresupuestoComprAut--->
		<cfquery name ="rsSQLCPresupuestoComprAut" datasource="#session.dsn#"> 
            select CPCCid
              from CPresupuestoComprAut c
            where c.Ecodigo	= #session.Ecodigo# 
                and c.CPPid		=  <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_periodo.CPPid#">	
                and c.Cmayor	= '#mid(rsImportador.Cuenta,1,4)#'
                and c.CPCCmascara	= '#rsImportador.Cuenta#'
		</cfquery>			
		<cfif rsSQLCPresupuestoComprAut.recordCount eq 0>
        	<cfquery name ="rsSQLinsert" datasource="#session.dsn#"> 
				insert into CPresupuestoComprAut(CPPid, CPcuenta, Ecodigo, Cmayor, CPCCmascara, CPCCdescripcion, CPcambioAplicado, BMUsucodigo) 
				values ( 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_periodo.CPPid#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSQLCuenta.CPcuenta#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,                        
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#mid(rsImportador.Cuenta,1,4)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsImportador.Cuenta#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#left(rsSQLCuenta.CPdescripcion,40)#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="0">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usucodigo#">
						)
				<cf_dbidentity1 datasource="#Session.DSN#">
			</cfquery>
            <cf_dbidentity2 datasource="#Session.DSN#" name="rsSQLinsert">
            <cfset CPCCid = rsSQLinsert.identity>
            
            <cfloop index= i from = "1" to ="#Meses#">
                <cfquery name ="rsSQLinsert" datasource="#session.dsn#"> 
                    insert into CPresupuestoComprAutD
                    (CPPid, CPCCid, CPperiodo, CPmes, CPComprOri, CPComprMod, BMUsucodigo)
                    values
                    (<cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_periodo.CPPid#">,
                     <cfqueryparam cfsqltype="cf_sql_numeric" value="#CPCCid#">,
                     <cfqueryparam cfsqltype="cf_sql_numeric" value="#Anio_ini#">,
                     <cfqueryparam cfsqltype="cf_sql_numeric" value="#Mes_ini#">,
                     0,0,
                     <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usucodigo#">
                    )
                </cfquery>
					
				<cfset 	Mes_ini = #Mes_ini# + 1>
				<cfif Mes_ini gt 12>
					<cfset Mes_ini = 1>
					<cfset Anio_ini = #Anio_ini# + 1>
				</cfif>
			</cfloop>
        <cfelse>				
            <cfset CPCCid = #rsSQLCPresupuestoComprAut.CPCCid#>
            <cfquery name="rsUpdatestatus" datasource="#session.DSN#">
                update CPresupuestoComprAut
                set CPcambioAplicado = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                where CPCCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CPCCid#">
            </cfquery>
        </cfif>
        <!---Podria estar creada la cuenta de Compromiso automatico y no estar creado el mes--->
		<cfquery name ="rsSQLCPresupuestoComprAutD" datasource="#session.dsn#"> 
            select CPCCid
              from CPresupuestoComprAutD c
            where c.CPPid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_periodo.CPPid#">
                and c.CPCCid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#CPCCid#">	
                and CPperiodo	= <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#rsImportador.PERIODO#">
                and CPmes		= <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#rsImportador.MES#">
		</cfquery>			
		<cfif rsSQLCPresupuestoComprAutD.recordCount eq 0>
            <cfquery name ="rsSQLinsert" datasource="#session.dsn#"> 
                insert into CPresupuestoComprAutD
                (CPPid, CPCCid, CPperiodo, CPmes, CPComprOri, CPComprMod, BMUsucodigo)
                values
                (<cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_periodo.CPPid#">,
                 <cfqueryparam cfsqltype="cf_sql_numeric" value="#CPCCid#">,
                 <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsImportador.PERIODO#">,
                 <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsImportador.MES#">,
                 0,0,
                 <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usucodigo#">
                )
            </cfquery>
    	</cfif>    
        
        <cfquery name ="rsSQLinsert" datasource="#session.dsn#"> 
            update CPresupuestoComprAutD
            set CPComprOri 	= <cfqueryparam cfsqltype="cf_sql_money" 	value="#rsImportador.Monto#">
            where CPCCid 	= <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#CPCCid#">
            and CPperiodo	= <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#rsImportador.PERIODO#">
            and CPmes		= <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#rsImportador.MES#">
            and CPComprOri	= 0
		</cfquery>
        
        <cfquery name ="rsSQLinsert" datasource="#session.dsn#"> 
            update CPresupuestoComprAutD
            set CPComprMod 	= <cfqueryparam cfsqltype="cf_sql_money" 	value="#rsImportador.Monto#">
            where CPCCid 	= <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#CPCCid#">
            and CPperiodo	= <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#rsImportador.PERIODO#">
            and CPmes		= <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#rsImportador.MES#">
		</cfquery>
	</cfif>
</cfloop>

<cfset ERR = fnVerificaErrores()>

<cfquery name="rsERR" dbtype="query">
	select count(1) as cantidad 
	  from ERR
	 where LVL = 'FATAL'
</cfquery>

