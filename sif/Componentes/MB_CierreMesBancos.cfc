<cfcomponent>
<!--- 
	Esta es la nomenclatura para los nombres de las tablas temporales que se van a crear
	en el procedimiento de cierre de auxiliares;
		- Para CC_CierreMesCxC
			* Monedas = CierreMes_M
			* Documentos = CierreMes_D
		- Para CP_CierreMesCxP
			* Monedas = CierreMes_M2
			* Documentos = CierreMes_D2
		- Para MB_CierreMesBancos
			* SaldosBancarios = CierreMesB_SB
--->
<!---	Cierre de Mes de Bancos	--->

	<!--- Cierre de Mes Bancos --->
	<cffunction name='CierreMesBancos' access='public' output='true'>
		<cfargument name='Ecodigo' 	       type='numeric' required='true'>		
		<cfargument name='periodo'         type='numeric' required='true'>				
		<cfargument name='mes' 		       type='numeric' required='true'>				
		<cfargument name='debug' 	       type="boolean" required='false' default='false'>
		<cfargument name='conexion'        type='string'  required='false' default="#Session.DSN#">
		<cfargument name='SaldosBancarios' type="string"  required="yes">
		<cfargument name='Intarc' 		   type="string"  required="yes">
		
		<!--- Parámetros Generales --->
		<cfset Pcodigo_mes = 0>
		<cfset Pcodigo_per = 0>
		<cfset sistema = "">				
		<cfset Pcodigo_aux_mes = 0>		
		<cfset Pcodigo_aux_per = 0>		
		<cfset sistema_aux = "">		
		<cfset Monloc = 0>		
		<cfset num_docs = 0>
		<cfset periodon = 0>		
		<cfset mesn = 0>		
		<cfset descripcion = "MB: Cierre de Bancos Mensual"&arguments.mes&arguments.periodo>		
		<cfset DescMoneda = "">		
		<cfset descerror = "">		
		<cfset error = 0>		
		<cfset Fecha = Now()>		
		<cfset CBcodigo = "Cierre Bancos-"&arguments.mes&arguments.periodo>		
		<cfset cuentaingreso = 0>		
		<cfset cuentaperdida = 0>	
		<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
		
		<cfquery name="rsVerificaParametro" datasource="#arguments.conexion#">
			select count(1) as Cantidad
			from Parametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
			  and Pcodigo = 1100
			  and Pvalor = 'S'
		</cfquery>
		
		<cfif rsVerificaParametro.Cantidad EQ 1>
			<cfreturn>
		</cfif>
		
		<cfset Intarc = Arguments.Intarc>
		<cfset SaldosBancarios = Arguments.SaldosBancarios>
		
		<!--- Borrado de las tablas temporales construidas en CG_CierreAuxiliares.cfc --->
		<cfquery datasource="#arguments.conexion#">
			delete from #Intarc#
		</cfquery>

		<cfquery datasource="#arguments.conexion#">
			delete from  #SaldosBancarios#
		</cfquery>


		<cfquery name="rs_Monloc" datasource="#arguments.conexion#">
			select Mcodigo 
			from Empresas 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
		</cfquery>

		<cfif isdefined('rs_Monloc') and rs_Monloc.recordCount GT 0>
			<cfset Monloc = rs_Monloc.Mcodigo>
		</cfif>

		<!--- Obtener cuentas de ingreso y perdida para el asiento --->	
		<cfquery name="rs_CuentaIngreso" datasource="#arguments.conexion#">
			select Pvalor
			from Parametros 
			where Ecodigo = #arguments.Ecodigo#
			  and Pcodigo = 260
			  and Mcodigo = 'CG'		
		</cfquery>
		
		<cfif isdefined('rs_CuentaIngreso') and rs_CuentaIngreso.recordCount GT 0>
			<cfset cuentaingreso = rs_CuentaIngreso.Pvalor>
		</cfif>

		<cfquery name="rs_CuentaPerdida" datasource="#arguments.conexion#">
			select Pvalor
			from Parametros 
			where Ecodigo = #arguments.Ecodigo#
			  and Pcodigo = 270
			  and Mcodigo = 'CG'
		</cfquery>
	
		<cfif isdefined('rs_CuentaPerdida') and rs_CuentaPerdida.recordCount GT 0>
			<cfset cuentaperdida = rs_CuentaPerdida.Pvalor>
		</cfif>		
		
		<!--- Selecciona el nuevo mes --->	
		<cfif arguments.mes EQ 12>
			<cfset mesn = 1>
			<cfset periodon = arguments.periodo + 1>
		<cfelse>
			<cfset mesn = arguments.mes + 1>
			<cfset periodon = arguments.periodo>
		</cfif>

		<cfquery name="rs_A_SaldosBancarios" datasource="#arguments.conexion#">
			insert INTO #SaldosBancarios# (CBid, Ecodigo, Ocodigo, Periodo, Mes, Mcodigo, TipoCambio, Sinicial, Slocal, SaldoAJ, Ajuste, PeriodoN, MesN)
			select CBid, Ecodigo, Ocodigo, #arguments.periodo#, #arguments.mes#, Mcodigo, 0.00, 0, 0, 0, 0, #periodon#, #mesn#
			from CuentasBancos
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
		</cfquery>

		<cfquery datasource="#arguments.conexion#">
        	update #SaldosBancarios#
            set 
            	Sinicial = coalesce(( select sum(b.Sinicial) from SaldosBancarios b where b.CBid = #SaldosBancarios#.CBid and b.Periodo = #SaldosBancarios#.Periodo and b.Mes = #SaldosBancarios#.Mes), 0),
            	Slocal   = coalesce(( select sum(b.Slocal) from SaldosBancarios b where b.CBid = #SaldosBancarios#.CBid and b.Periodo = #SaldosBancarios#.Periodo and b.Mes = #SaldosBancarios#.Mes), 0)
        </cfquery>

 		<cfquery datasource="#arguments.conexion#">
			update #SaldosBancarios#
			set 
            Sinicial = Sinicial + coalesce(
                 (select sum( MLmonto * ((case MLtipomov  when 'C' then 1 when 'D' then 2 end ) * 2 - 3))
                 from MLibros a
                 where a.CBid = #SaldosBancarios#.CBid
                   and a.MLperiodo = #SaldosBancarios#.Periodo
                   and a.MLmes = #SaldosBancarios#.Mes), 0),

			Slocal = Slocal + coalesce(
				 (select sum( MLmontoloc * ((case MLtipomov  when 'C' then 1 when 'D' then 2 end ) * 2 - 3))
				 from MLibros a
				 where a.CBid = #SaldosBancarios#.CBid
				   and a.MLperiodo = #SaldosBancarios#.Periodo
				   and a.MLmes = #SaldosBancarios#.Mes), 0)
		</cfquery>

		<!--- Actualizar el tipo de cambio de los del cierre por cada moneda del proceso --->
		<cfquery name="rs_A2_SaldosBancarios" datasource="#arguments.conexion#">
			update #SaldosBancarios#
			set TipoCambio = coalesce((	select b.TCEtipocambio
								from TipoCambioEmpresa  b
								where Ecodigo = #SaldosBancarios#.Ecodigo
								  and b.Periodo = #SaldosBancarios#.Periodo
								  and b.Mes = #SaldosBancarios#.Mes
								  and b.Mcodigo = #SaldosBancarios#.Mcodigo),-1)
			where Mcodigo != <cfqueryparam cfsqltype="cf_sql_numeric" value="#Monloc#">
		</cfquery>
		
		<!--- actualizar tipocambio moneda local en 1. --->
		<cfquery name="rs_A2_SaldosBancarios" datasource="#arguments.conexion#">
			update #SaldosBancarios#
			set TipoCambio = 1
			where Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Monloc#">
		</cfquery>

		<!--- 
			Después de este update hay que validar que no exista en Saldos Bancarios
			algun dato con TipoCambio  = 0.00 o negativo 
		--->

		<cfquery name="rs_SaldosBancariosNegativos" datasource="#arguments.conexion#">
			select 1 
			from #SaldosBancarios# 
			where TipoCambio  <= 0.00
		</cfquery>
		
		<cfif isdefined('rs_SaldosBancariosNegativos') and rs_SaldosBancariosNegativos.recordCount GT 0> 
			<cfquery name="rs_DescMoneda" datasource="#arguments.conexion#" maxrows="1">
				select b.Mnombre 
				from #SaldosBancarios#  a
					, Monedas b 
				where   a.TipoCambio   		<= 0.00
					and a.Periodo 		= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.periodo#">
					and a.Mes 		= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mes#">
					and a.Mcodigo 		= b.Mcodigo	   
			</cfquery>
						
			<cfset DescMoneda = "">
			<cfif isdefined('rs_DescMoneda') and rs_DescMoneda.recordCount GT 0>
				<cfset DescMoneda = rs_DescMoneda.Mnombre>
			</cfif>
			<cfset msg = "Error! No se ha definido el Tipo de Cambio para la Moneda: " & DescMoneda & " , Período: " & Periodo & ", Mes: " & Mes & ". Proceso Cancelado!.">

			<cfthrow message="#msg#">					
		</cfif>

		<!--- Actualiza el saldo ajustado por el tipo de cambio --->
		<cfquery name="rs_C_SaldosBanc" datasource="#arguments.conexion#">
			update #SaldosBancarios#
			set SaldoAJ = coalesce(round(Sinicial * coalesce(TipoCambio,0), 2),0)
		</cfquery>
		
		<cfquery name="rs_C2_SaldosBanc" datasource="#arguments.conexion#">
			update #SaldosBancarios#
			set Ajuste = SaldoAJ - Slocal		
		</cfquery>

        <cfquery name="rsVerificaParam" datasource="#session.DSN#">
        	select Pvalor 
            from Parametros
            where Ecodigo = #session.Ecodigo#
            and Pcodigo = 2210
            and Mcodigo = 'CG'
        </cfquery>

		<cfif (rsVerificaParam.recordcount gt 0 and rsVerificaParam.Pvalor eq 0) or rsVerificaParam.recordcount eq 0>
			<!--- 	Contabilizar los Ajustes
                        3) Asiento Contable
                            3a. Bancos 
             --->
            <cfset FechaHoy = DateFormat(Now(),'yyyymmdd')>
            <cfquery name="rs_A_Intarc" datasource="#arguments.conexion#">
                insert INTO #Intarc# ( 
                        INTORI, 
                        INTREL, 
                        INTDOC, 
                        INTREF, 
                        INTMON, 
                        INTTIP, 
                        INTDES, 
                        INTFEC, 
                        INTCAM, 
                        Periodo, 
                        Mes, 
                        Ccuenta, 
                        Mcodigo, 
                        Ocodigo, 
                        INTMOE) 
                select 
                    'MBCM',
                    1,
                    <cf_dbfunction name="sPart"	args="b.CBcodigo,1,20"> as CBcodigo,			<!--- codigo de la cuenta --->
                    'Ajuste', 
                    abs(a.Ajuste), 
                    case when Ajuste > 0 then 'D' else 'C' end,
                    'Revaluacion Cuenta ' #_Cat# rtrim(b.CBcodigo),
                    '#FechaHoy#',
                    0,
                    a.Periodo,
                    a.Mes,
                    b.Ccuenta,
                    b.Mcodigo,
                    b.Ocodigo,
                    0
                from #SaldosBancarios# a
                    , CuentasBancos b
                where a.Ajuste <> 0
                  and b.CBid = a.CBid
            </cfquery>
            
            <!---►►Se valida que la cuenta de ingreso por Diferencial cambiario este configurada◄◄--->
            <cfif NOT isdefined('cuentaingreso') and NOT LEN(TRIM(cuentaingreso))>
            	<cfthrow message="No esta definida la cuenta de Ingreso por Diferencial Cambiario">
            </cfif>
             
            <!--- 3b. Ingreso por Diferencial Cambiario  --->
            <cfquery name="rs_A_Intarc" datasource="#arguments.conexion#">
                insert INTO #Intarc# (
                        INTORI, 
                        INTREL, 
                        INTDOC, 
                        INTREF, 
                        INTMON, 
                        INTTIP, 
                        INTDES, 
                        INTFEC, 
                        INTCAM, 
                        Periodo, 
                        Mes, 
                        Ccuenta, 
                        Mcodigo, 
                        Ocodigo, 
                        INTMOE)
                select 
                    'MBCM',
                    1,
                    <cf_dbfunction name="sPart"	args="b.CBcodigo,1,20"> as CBcodigo,		<!--- codigo de la cuenta --->
                    'Ajuste', 
                    abs(a.Ajuste), 
                    'C',
                    'Revaluacion Cuenta ' #_Cat# b.CBcodigo,
                    '#FechaHoy#',
                    0,
                    a.Periodo,
                    a.Mes,
                    #cuentaingreso#,
                    b.Mcodigo,
                    b.Ocodigo,
                    0
                from #SaldosBancarios# a
                    , CuentasBancos b
                where a.Ajuste > 0
                  and b.CBid = a.CBid
            </cfquery>
           	
			<!---►►Se valida que la cuenta de Perdida por Diferencial cambiario este configurada◄◄--->
            <cfif NOT isdefined('cuentaperdida') and NOT LEN(TRIM(cuentaperdida))>
            	<cfthrow message="No esta definida la cuenta de Perdida por Diferencial Cambiario">
            </cfif>
            
			<!--- 3c. Gasto o Perdida por Diferencial Cambiario  --->
            <cfquery name="rs_A_Intarc" datasource="#arguments.conexion#">
                insert INTO #Intarc# ( 
                        INTORI, 
                        INTREL, 
                        INTDOC, 
                        INTREF, 
                        INTMON, 
                        INTTIP, 
                        INTDES, 
                        INTFEC, 
                        INTCAM, 
                        Periodo, 
                        Mes, 
                        Ccuenta, 
                        Mcodigo, 
                        Ocodigo, 
                        INTMOE)
                select 
                    'MBCM',
                    1,
                    <cf_dbfunction name="sPart"	args="b.CBcodigo,1,20"> as CBcodigo,			<!--- codigo de la cuenta --->
                    'Ajuste', 
                    abs(a.Ajuste), 
                    'D',
                    'Revaluacion Cuenta ' #_Cat# b.CBcodigo,
                    '#FechaHoy#',
                    0,
                    a.Periodo,
                    a.Mes,
                    #cuentaperdida#,
                    b.Mcodigo,
                    b.Ocodigo,
                    0
                from #SaldosBancarios# a, CuentasBancos b
                where a.Ajuste < 0
                  and b.CBid = a.CBid
            </cfquery>
    
            <!--- 4) Ejecutar el Genera Asiento --->
            <cfquery name="rs_IntarcCount" datasource="#arguments.conexion#">
                select count(1) from #Intarc#
            </cfquery>
            
            <cfif isdefined('rs_IntarcCount') and rs_IntarcCount.recordCount GT 0>
                <cfinvoke component="CG_GeneraAsiento" method="GeneraAsiento" >
                    <cfinvokeargument name="Ecodigo" value="#arguments.Ecodigo#"/>
                    <cfinvokeargument name="Oorigen" value="MBCM"/>
                    <cfinvokeargument name="Eperiodo" value="#Periodo#"/>
                    <cfinvokeargument name="Emes" 			value="#Mes#"/>
                    <cfinvokeargument name="Efecha" 		value="#DateAdd('d', -1, DateAdd('m', 1, CreateDate(Periodo, Mes, 1)))#"/>
                    <cfinvokeargument name="Edescripcion" 	value="#descripcion#"/>
                    <cfinvokeargument name="Edocbase" 		value="#CBcodigo#"/>
                    <cfinvokeargument name="Ereferencia" 	value="CM"/>			
                </cfinvoke>		
            </cfif>
        </cfif>

		<!---  Query borra las transacciones que se están eliminando del mes.  Se sustituye --->

		<cfquery name="rs_D_SaldosBancarios" datasource="#arguments.conexion#">
			delete from SaldosBancarios
			where exists(
				Select 1
				from #SaldosBancarios# a
				where a.CBid       = SaldosBancarios.CBid
				  and a.PeriodoN   = SaldosBancarios.Periodo
				  and a.MesN	   = SaldosBancarios.Mes
				)
		</cfquery>


		<!--- 5.1 Insertar en la tabla de saldos de cuentas bancarias --->
		<cfquery name="rs_A_SaldosBancarios" datasource="#arguments.conexion#">
 			insert INTO SaldosBancarios (
				CBid, 
				Periodo, 
				Mes, 
				Sinicial, 
				Slocal,
				SBfecha) 
			select 
				CBid, 
				#periodon#, 
				#mesn#, 
				Sinicial, 
				SaldoAJ,
				<cf_dbfunction name="now">
			from #SaldosBancarios#
			
		</cfquery>

		<!--- 5.2 insertar en Movimientos Libros un movimiento por MLmonto = 0.00,
			 MLmontoloc = Ajuste cuando Ajuste != 0, en el mes #mes# --->
		<cfset BTid = 0>
		
		 <!--- Tipo de Transaccion --->
		<cfquery name="rs_Transac" datasource="#arguments.conexion#">
			select min(BTid) as Min_BTid
			from BTransacciones
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
		</cfquery>
    
		<cfif isdefined('rs_Transac') and rs_Transac.recordCount GT 0>
			<cfset BTid = rs_Transac.Min_BTid>
		</cfif>

		<cfquery name="rs_A_Libros" datasource="#arguments.conexion#">
 			insert INTO MLibros (
				Ecodigo, 
				Bid, 
				BTid, 
				CBid, 
				Mcodigo, 
				MLfecha, 
				MLdescripcion, 
				MLdocumento, 
				MLreferencia, 
				MLconciliado, 
				MLtipocambio, 
				MLmonto, 
				MLmontoloc, 
				MLperiodo, 
				MLmes, 
				MLtipomov, 
				MLusuario, 
				IDcontable)
			select 
				#arguments.Ecodigo#, 
				b.Bid, 
				#BTid#, 
				a.CBid, 
				a.Mcodigo, 
				<cf_dbfunction name="now">,
				'Ajuste Ingreso por Diferencial Cambiario', 
				'Ajuste (' #_Cat# <cf_dbfunction name="to_char" args="a.Periodo"> #_Cat# '/'  #_Cat# <cf_dbfunction name="to_char" args="a.Mes">  #_Cat# ')', 
				'Ajuste',
				'S', 
				a.TipoCambio, 
				CASE
                    WHEN a.TipoCambio  <> 1 then a.Ajuste
                    ELSE 0
                END AS Ajuste,
				CASE
                    WHEN a.TipoCambio  <> 1 then a.Ajuste
                    ELSE 0
                END AS Ajuste,
				a.Periodo, 
				a.Mes, 
				'D', 
				'#session.Usuario#', 
				b.Ccuenta
			from #SaldosBancarios# a, CuentasBancos b
			where a.Ajuste > 0
			  and b.CBid = a.CBid
		</cfquery>

		<cfquery name="rs_A2_Libros" datasource="#arguments.conexion#">
 			insert INTO MLibros (
				Ecodigo, 
				Bid, 
				BTid, 
				CBid, 
				Mcodigo, 
				MLfecha, 
				MLdescripcion, 
				MLdocumento, 
				MLreferencia, 
				MLconciliado, 
				MLtipocambio, 
				MLmonto, 
				MLmontoloc, 
				MLperiodo, 
				MLmes, 
				MLtipomov, 
				MLusuario, 
				IDcontable)
			select 
				#arguments.Ecodigo#,  
				b.Bid, 
				#BTid#,
				a.CBid, 
				a.Mcodigo, 
				<cf_dbfunction name="now">,
				'Ajuste Perdida por Diferencial Cambiario', 
				'Ajuste (' #_Cat# <cf_dbfunction name="to_char" args="a.Periodo"> #_Cat# '/' #_Cat# <cf_dbfunction name="to_char" args="a.Mes"> #_Cat# ')' ,
				'Ajuste',
				'S', 
				a.TipoCambio, 
				CASE
                    WHEN a.TipoCambio  <> 1 then abs(Ajuste)
                    ELSE 0
                END AS Ajuste,
				CASE
                    WHEN a.TipoCambio  <> 1 then abs(Ajuste)
                    ELSE 0
                END AS Ajuste,
				a.Periodo, 
				a.Mes, 
				'C', 
				'#session.Usuario#',  
				b.Ccuenta
			from #SaldosBancarios# a, CuentasBancos b
			where a.Ajuste < 0
			  and b.CBid = a.CBid
		</cfquery>

		<cfif arguments.debug>
			<cfquery datasource="#arguments.conexion#" name="rs_SaldosBancariosTMP">
				select CBid, Ecodigo, Ocodigo, Periodo, Mes, Mcodigo, TipoCambio, Sinicial, Slocal, SaldoAJ, Ajuste, PeriodoN, MesN 
				from #SaldosBancarios#			
			</cfquery>
			
			<cfif isdefined('rs_SaldosBancariosTMP')>
				<cfdump var="#rs_SaldosBancariosTMP#" label="SaldosBancarios TMP CierreMesBancos">
			</cfif>				
			
			<cfquery datasource="#arguments.conexion#" name="rs_SaldosBancarios">
				select s.CBid, s.Periodo, s.Mes, s.Sinicial, s.Slocal
				from CuentasBancos c
					inner join SaldosBancarios s
						on s.CBid = c.CBid
				where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
                  and s.Periodo = #periodon#
				  and s.Mes     = #mesn#
			</cfquery>
			
			<cfif isdefined('rs_SaldosBancarios')>
				<cfdump var="#rs_SaldosBancarios#" label="SaldosBancarios CierreMesBancos">
			</cfif>				
			
			<cfquery datasource="#arguments.conexion#" name="rs_IntarcTMP">
				select INTLIN, INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE 
				from #Intarc#
			</cfquery>
			
			<cfif isdefined('rs_IntarcTMP')>
				<cfdump var="#rs_IntarcTMP#" label="rs_IntarcTMP CierreMesBancos">
			</cfif>				
			
			<cfquery datasource="#arguments.conexion#" name="rs_Libros">
				select MLibros.MLid, MLibros.Ecodigo, MLibros.Bid, MLibros.BTid, MLibros.CBid, MLibros.Mcodigo, MLibros.MLfecha, MLibros.MLdescripcion, MLibros.MLdocumento, MLibros.MLreferencia, MLibros.MLconciliado, MLibros.MLtipocambio, MLibros.MLmonto, MLibros.MLmontoloc, MLibros.MLperiodo, MLibros.MLmes, MLibros.MLtipomov, MLibros.MLusuario, MLibros.IDcontable, MLibros.ts_rversion 
				from MLibros
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
				  and MLperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.periodo#">
				  and MLmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mes#">
			</cfquery>
			
			<cfif isdefined('rs_Libros')>
				<cfdump var="#rs_Libros#" label="rs_Libros CierreMesBancos">
			</cfif>				
		</cfif>
	</cffunction>
</cfcomponent>

