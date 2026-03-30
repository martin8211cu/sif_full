<!--- Componente que hace la interfaz con presupuesto--->
<cfcomponent>
	<!--- Funcion que hace un +Anticipo en presupuesto--->
	<cffunction name="ReservaAnticipo" access="public" returntype="numeric">
		<cfargument name="GEAid" 		type="numeric" required="yes">
		<cfargument name="CCHtipoCaja"	type="numeric" required="yes">
        <cfargument name="Comision"	    type="numeric" required="no" default="0">
      	<cfargument name="Cancela"		 	type="string" default ="0" required="false">
		
		<cf_dbfunction name="OP_concat" returnvariable="_CAT">
		
		<cfset LobjControl = createObject( "component","sif.Componentes.PRES_Presupuesto")>
        

		<cfquery name="rsMesAuxiliar" datasource="#session.DSN#">
			select Pvalor
			from Parametros
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Pcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="60">
		</cfquery>
	
		<cfquery name="rsPeriodoAuxiliar" datasource="#session.DSN#">
			select Pvalor
			from Parametros
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Pcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="50">
		</cfquery>
	
		<cfquery name="rsSQL" datasource="#session.DSN#">
			select GEADid, GEAnumero
				from GEanticipoDet d
						inner join GEanticipo e
							inner join CFuncional f
								on f.CFid = e.CFid
								on d.GEAid = e.GEAid
			where e.GEAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GEAid#">
			and e.Ecodigo = #session.Ecodigo#
		</cfquery>

		<cfloop query="rsSQL">
			<cfquery datasource="#session.DSN#" name="Actualiza">
				update GEanticipoDet
				set Linea =  #rsSQL.currentRow#
				where GEADid = #rsSQL.GEADid#
			</cfquery>
		</cfloop>
		<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
		
		<!--- Determina el signo de los montos de DB/CR a Reservar --->
		<cfinvoke 	component			= "sif.Componentes.PRES_Presupuesto"	
					method				= "fnSignoDB_CR" 	
					returnvariable		= "LvarSignoDB_CR"
					
					INTTIP				= "d.GEADmonto"
					INTTIPxMonto		= "true"
					Ctipo				= "m.Ctipo"
					CPresupuestoAlias	= "cp"
					
					Ecodigo				= "#session.Ecodigo#"
					AnoDocumento		= "#rsPeriodoAuxiliar.Pvalor#"
					MesDocumento		= "#rsMesAuxiliar.Pvalor#"
		/>
        <cf_dbfunction name="to_char" args="e.GEAnumero" returnvariable="LvarGEAnumero">
        <cf_dbfunction name="to_char" args="#arguments.Comision#" returnvariable="LvarComision">
		<cf_dbfunction name="concat"  args="#LvarGEAnumero#+' - '+(#LvarComision#)" delimiters='+' returnvariable='LvarNumero'>
				
		<!---SML.Uso del parametro 1231 para considerar la cuenta presupuestal solo si es una aprobación de anticipo--->
	    <cfquery name="rsCPCuentaAnticipo" datasource="#session.DSN#">
    	   	select Pvalor 
			from Parametros  --Pcodigo 1231, Pvalor = Cuenta Empleado 1, Gasto 2, Mcodigo = GE
			where Pcodigo = '1231'
			and Ecodigo = #session.Ecodigo#
        </cfquery>			
		
		<!----CAMBIO ANGELES--->		
			
		<cfquery name="rsAfectaCxPEmpleado" datasource="#session.DSN#">
    	   	select Pvalor 
			from Parametros  
			where Pcodigo = '1232'
			and Ecodigo = #session.Ecodigo#
        </cfquery>	
		
		<cfquery name="rsAnticipo" datasource="#session.dsn#">
			select 	coalesce(GEAtotalOri,0) as GEAtotalOri,c.GEAid, a.GEAnumero, GEADmonto, GEADutilizado, GEAmanual,
				a.CCHid, cch.CCHtipo as CCHtipo_caja, a.CPNAPnum, a.Mcodigo, a.GECid as GECid_comision, a.Ecodigo, GEAfechaSolicitud, GECnumero, 
				'CANC.ANT-'#_CAT# <cf_dbfunction name="to_char" args="a.GEAnumero"> as Documento,a.CPNAPnum_Pago,c.GEADid,
				a.CCHid, cch.CCHtipo as CCHtipo_caja, a.CPNAPnum, a.Mcodigo, a.GECid as GECid_comision, a.Ecodigo, GEAfechaSolicitud, GECnumero, GEAfechaPagar
			  from GEanticipo a
				inner join GEanticipoDet c
				on c.GEAid=a.GEAid
				inner join CCHica cch
				on cch.CCHid=a.CCHid
				inner join GEcomision co
				on co.GECid = a.GECid
			 where a.GEAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GEAid#">
		</cfquery>
			
		<cfif isdefined("rsAfectaCxPEmpleado") and rsAfectaCxPEmpleado.Pvalor EQ 1>
			<cfquery name="rsCxPEmpleado" datasource="#session.DSN#">
    		   	select Pvalor 
				from Parametros  
				where Pcodigo = '1233'
				and Ecodigo = #session.Ecodigo#
        	</cfquery>	
			
			<cfif isdefined("rsCxPEmpleado") and len(rsCxPEmpleado.Pvalor) EQ 0>
				<cfthrow message="Debe especifica la cuenta por pagar al empleado">
			</cfif>
            
			
            
            <cfquery name="rsNAP" datasource="#session.dsn#">
       		select d.CPNAPDlinea, d.CFcuenta,d.CPcuenta,d.Ocodigo,d.Mcodigo,
            d.CPNAPDmontoOri,d.CPNAPDtipoCambio,d.CPNAPDmonto,d.CPNAPDtipoMov,
			d.CPNAPnum,d.CPNAPDlinea,d.PCGDid, d.PCGDcantidad
                    from CPNAP n
				inner join CPNAPdetalle d
					 on d.Ecodigo	= n.Ecodigo
					and d.CPNAPnum	= n.CPNAPnum
				inner join GEanticipo c
                on c.CPNAPnum = d.CPNAPnum
			where n.Ecodigo		=  #session.Ecodigo#
            and c.GEAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GEAid#">
  			</cfquery>
        </cfif>


<!--- Control Evento Inicia --->
	            <cfinvoke 
    	            component		= "sif.Componentes.CG_ControlEvento" 
        	        method			= "ValidaEvento"  
            	    Origen			= "TEAE"
                	Transaccion		= "ANT"
	                Conexion		= "#session.dsn#"
    	            Ecodigo			= "#session.Ecodigo#"
        	        returnvariable	= "varValidaEvento"
            	    />
	            <cfset varNumeroEvento = "">
    	        <cfif varValidaEvento GT 0>
        	        <cfinvoke 
            	    component		= "sif.Componentes.CG_ControlEvento" 
                	method			= "CG_GeneraEvento"  
	                Origen			= "TEAE"
    	            Transaccion		= "ANT"
        	        Documento 		= "#rsAnticipo.GEAnumero#"
            	    Conexion		= "#session.dsn#"
                	Ecodigo			= "#session.Ecodigo#"
	                returnvariable	= "arNumeroEvento"
    	            />
        	        <cfif arNumeroEvento[3] EQ "">
            	        <cfthrow message="ERROR CONTROL EVENTO: No se obtuvo un control de evento valido para la operación">
                	</cfif>
	                <cfset varNumeroEvento = arNumeroEvento[3]>
					<cfset varIDEvento = arNumeroEvento[4]>
        	
      				<cfinvoke component="sif.Componentes.CG_ControlEvento" 
		        	    method="CG_RelacionaEvento" 
	        		    IDNEvento="#varIDEvento#"
			            Origen="GECM"
        			    Transaccion="COM"
		    	        Documento="#rsAnticipo.GECnumero#"
        			    Conexion="#session.dsn#"
		            	Ecodigo="#session.Ecodigo#"
	        		    returnvariable="arRelacionEvento"
    	   			 /> 
        			 <cfif isdefined("arRelacionEvento") and arRelacionEvento[1]>
						<cfset varNumeroEvento = arRelacionEvento[4]>
        			 </cfif>
	            </cfif>
                
 <!----Control Evento Fin --->


			<cfinvoke component="sif.Componentes.CG_GeneraAsiento" 	method="CreaIntarc"  	 returnvariable="INTARC" />
		
			<!---<cfset sbFechaContable(#rsAnticipo.Ecodigo#, #rsAnticipo.GEAnumero#, #rsAnticipo.GEAfechaSolicitud#)>--->
		
			<!---OFICINA--->
			<cfquery datasource="#session.dsn#" name="rsOficina">
				select Ocodigo
				from Oficinas
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAnticipo.Ecodigo#">
			</cfquery>
			
			<cfset Documento = '#rsAnticipo.GEAnumero#(#rsAnticipo.GECnumero#)'>

			<!----cuenta del empleado o cuenta de gasto---->
			<cfquery datasource="#session.dsn#">
				insert into #INTARC# 
				( 
				INTORI, INTREL, 
				INTDOC, INTREF, 
				INTFEC, Periodo, Mes, Ocodigo, 
				INTTIP, INTDES, 
				CFcuenta, Ccuenta, 

				Mcodigo, INTMOE, INTCAM, INTMON, INTMON2,
				
				LIN_IDREF,PCGDid<!---, NumeroEvento--->
				)
				select 'TEAE', 1,
				 '#Documento#',
				 'TEAE Anticipo a Empleado',
				 '#DateFormat(now(),"YYYYMMDD")#', #rsMesAuxiliar.Pvalor#, #rsPeriodoAuxiliar.Pvalor#, #rsOficina.Ocodigo#,
				 'D', 'TES:Aplica ANT.' #_CAT# '#Documento#',
				 <cfif isdefined('rsCPCuentaAnticipo') and rsCPCuentaAnticipo.Pvalor EQ 1>
					a.CFcuenta, <!--- CFuenta --->
                <cfelse>
    	            c.CFcuenta,
                </cfif>
				0,
				a.Mcodigo, GEADmonto, GEADtipocambio, round(GEADmonto * GEADtipocambio,2), GEADmonto * GEADtipocambio,
				GEADid, PCGDid<!---, '#varNumeroEvento#'--->
				from GEanticipo a
				inner join GEanticipoDet c
					on c.GEAid=a.GEAid
				inner join CCHica cch
					on cch.CCHid=a.CCHid
				inner join GEcomision co
					on co.GECid = a.GECid
				 where a.GEAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GEAid#">
			</cfquery>		 
	
			<!---cuenta puente parametrizada--->
			<cfquery datasource="#session.dsn#">
				insert into #INTARC# 
				( 
				INTORI, INTREL, 
				INTDOC, INTREF, 
				INTFEC, Periodo, Mes, Ocodigo, 
				INTTIP, INTDES, 
				CFcuenta, Ccuenta, 

				Mcodigo, INTMOE, INTCAM, INTMON, INTMON2,
				
				LIN_IDREF,PCGDid<!---, NumeroEvento--->
				)
				select 'TEAE', 1,
				 '#Documento#',
				 'TEAE Anticipo a Empleado',
				 '#DateFormat(now(),"YYYYMMDD")#', #rsMesAuxiliar.Pvalor#, #rsPeriodoAuxiliar.Pvalor#, #rsOficina.Ocodigo#,
				 'C', 'TES:Aplica ANT. Cuenta por pagar al empleado',
				#rsCxPEmpleado.Pvalor#,
				0,
				a.Mcodigo, GEADmonto, GEADtipocambio, round(GEADmonto * GEADtipocambio,2), GEADmonto * GEADtipocambio,
				GEADid, PCGDid<!---, '#varNumeroEvento#'--->
			 	 from GEanticipo a
				inner join GEanticipoDet c
					on c.GEAid=a.GEAid
				inner join CCHica cch
					on cch.CCHid=a.CCHid
				inner join GEcomision co
					on co.GECid = a.GECid
				 where a.GEAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GEAid#">
			</cfquery>		 
<!---<cfelse>


	<!----cuenta del empleado o cuenta de gasto---->
			<cfquery datasource="#session.dsn#">
				insert into #INTARC# 
				( 
				INTORI, INTREL, 
				INTDOC, INTREF, 
				INTFEC, Periodo, Mes, Ocodigo, 
				INTTIP, INTDES, 
				CFcuenta, Ccuenta, 

				Mcodigo, INTMOE, INTCAM, INTMON, INTMON2,
				
				LIN_IDREF,PCGDid<!---, NumeroEvento--->
				)
				select 'TEAE', 1,
				 '#Documento#',
				 'TEAE Anticipo Empleado',
				 '#DateFormat(now(),"YYYYMMDD")#', #LvarAuxPeriodo#, #LvarAuxMes#, #rsOficina.Ocodigo#,
				 'C', 'TES:CANC ANT.' #_CAT# '#Documento#',
				 <cfif isdefined('rsCPCuentaAnticipo') and rsCPCuentaAnticipo.Pvalor EQ 1>
					a.CFcuenta, <!--- CFuenta --->
                <cfelse>
    	            c.CFcuenta,
                </cfif>
				0,
				a.Mcodigo, GEADmonto, GEADtipocambio, round(GEADmonto * GEADtipocambio,2), GEADmonto * GEADtipocambio,
				GEADid, PCGDid<!---, '#varNumeroEvento#'--->
				from GEanticipo a
				inner join GEanticipoDet c
					on c.GEAid=a.GEAid
				inner join CCHica cch
					on cch.CCHid=a.CCHid
				inner join GEcomision co
					on co.GECid = a.GECid
				 where a.GEAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GEAid#">
			</cfquery>		 
	
			<!---cuenta puente parametrizada--->
			<cfquery datasource="#session.dsn#">
				insert into #INTARC# 
				( 
				INTORI, INTREL, 
				INTDOC, INTREF, 
				INTFEC, Periodo, Mes, Ocodigo, 
				INTTIP, INTDES, 
				CFcuenta, Ccuenta, 

				Mcodigo, INTMOE, INTCAM, INTMON, INTMON2,
				
				LIN_IDREF,PCGDid<!---, NumeroEvento--->
				)
				select 'TEAE', 1,
				 '#Documento#',
				 'TEAE Anticipo Empleado',
				 '#DateFormat(now(),"YYYYMMDD")#', #LvarAuxPeriodo#, #LvarAuxMes#, #rsOficina.Ocodigo#,
				 'D', 'TES:CANC ANT. Cuenta por pagar al empleado',
				#rsCxPEmpleado.Pvalor#,
				0,
				a.Mcodigo, GEADmonto, GEADtipocambio, round(GEADmonto * GEADtipocambio,2), GEADmonto * GEADtipocambio,
				GEADid, PCGDid<!---, '#varNumeroEvento#'--->
			 	 from GEanticipo a
				inner join GEanticipoDet c
					on c.GEAid=a.GEAid
				inner join CCHica cch
					on cch.CCHid=a.CCHid
				inner join GEcomision co
					on co.GECid = a.GECid
				 where a.GEAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GEAid#">
			</cfquery>		 
            </cfif>
		</cfif>--->
		<!----TERMINA CAMBIO ANGELES---->	
				
<!---<cfif Arguments.Cancela EQ "0">--->
		<!-----COMPROMETIDO ----->
		<cfquery datasource="#session.DSN#">
			insert into #request.intPresupuesto#
				(
				ModuloOrigen,
				NumeroDocumento,
				NumeroReferencia,
				FechaDocumento, 
				AnoDocumento,
				MesDocumento,
				NumeroLinea, 
				CFcuenta,
				Ocodigo,
				Mcodigo,
				MontoOrigen,
				TipoCambio,
				Monto,
				TipoMovimiento,
				PCGDid,
				PCGDcantidad
			)
				select distinct 'TEAE', <!--- as ModuloOrigen --->
				<cfif Arguments.Comision gt 0>#preserveSingleQuotes(LvarNumero)#<cfelse><cf_dbfunction name="to_char" args="e.GEAnumero"></cfif> as GEAnumero, <!--- NumeroDocumento --->
				'GE.ANT,Aprobacion', <!--- NumeroReferencia --->
				e.GEAfechaSolicitud, <!--- FechaDocumento --->
				#rsPeriodoAuxiliar.Pvalor# as Periodo, <!--- AnoDocumento --->
				#rsMesAuxiliar.Pvalor# as Mes, <!--- as MesDocumento --->
				<cfif Arguments.CCHtipoCaja EQ 2></cfif>
				d.Linea, 	<!--- NumeroLinea --->
				<cfif isdefined('rsCPCuentaAnticipo') and rsCPCuentaAnticipo.Pvalor EQ 1>
					e.CFcuenta, <!--- CFuenta --->
                <cfelse>
    	            d.CFcuenta,
                </cfif>
				f.Ocodigo, 	<!--- Oficina --->
				e.Mcodigo, 	<!--- Mcodigo --->
				#PreserveSingleQuotes(LvarSignoDB_CR)# * round(abs(d.GEADmonto),2) as INTMOE,
				e.GEAmanual, <!--- as TipoCambio --->
				#PreserveSingleQuotes(LvarSignoDB_CR)# * round(round(abs(d.GEADmonto),2) * e.GEAmanual,2) as INTMON,
				'CC' as Tipo, <!--- as TipoMovimiento --->
				d.PCGDid,
				1
			from 
			<cfif isdefined("rsAfectaCxPEmpleado") and rsAfectaCxPEmpleado.Pvalor EQ 1>
				#INTARC# i
				inner join GEanticipo e
			<cfelse>
				GEanticipo e
			</cfif>
				inner join GEanticipoDet d
					on d.GEAid = e.GEAid
				inner join CFuncional f
					on f.CFid = e.CFid
				inner join CFinanciera cf
					left join CPresupuesto cp
						 on cp.CPcuenta = cf.CPcuenta
					inner join CtasMayor m
						on m.Ecodigo = cf.Ecodigo
						and m.Cmayor = cf.Cmayor
				on cf.CFcuenta = d.CFcuenta
			<cfif isdefined("rsAfectaCxPEmpleado") and rsAfectaCxPEmpleado.Pvalor EQ 1>
				on d.GEADid 		= i.LIN_IDREF
			</cfif>
			where e.GEAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GEAid#">
			  and e.Ecodigo = #session.Ecodigo#			
		</cfquery>
        
<!---<cfelse>
		<cfquery datasource="#session.DSN#">


       		insert into #request.intPresupuesto#
				(
				ModuloOrigen,
				NumeroDocumento,
				NumeroReferencia,
				FechaDocumento, 
				AnoDocumento,
				MesDocumento,
				NumeroLinea, 
				CFcuenta,
                CPcuenta,
				Ocodigo,
				Mcodigo,
				MontoOrigen,
				TipoCambio,
				Monto,
				TipoMovimiento,
				PCGDid,
				PCGDcantidad,
                NAPreferencia,
                LINreferencia
			)
				select distinct 'TEAE', <!--- as ModuloOrigen --->
				<cfif Arguments.Comision gt 0>#preserveSingleQuotes(LvarNumero)#<cfelse><cf_dbfunction name="to_char" args="e.GEAnumero"></cfif> as GEAnumero, <!--- NumeroDocumento --->
				'ROSALBA', <!--- NumeroReferencia --->
				e.GEAfechaSolicitud, <!--- FechaDocumento --->
				#rsPeriodoAuxiliar.Pvalor# as Periodo, <!--- AnoDocumento --->
				#rsMesAuxiliar.Pvalor# as Mes, <!--- as MesDocumento --->
				<cfif Arguments.CCHtipoCaja EQ 2></cfif>
				d.Linea, 	<!--- NumeroLinea --->
				<cfif isdefined('rsCPCuentaAnticipo') and rsCPCuentaAnticipo.Pvalor EQ 1>
					e.CFcuenta, <!--- CFuenta --->
                <cfelse>
    	            d.CFcuenta,
                </cfif>
                #rsNAP.CPcuenta#,
				f.Ocodigo, 	<!--- Oficina --->
				e.Mcodigo, 	<!--- Mcodigo --->
				-#rsNAP.CPNAPDmontoOri#,
				#rsNAP.CPNAPDtipoCambio#, <!--- as TipoCambio --->
				-#rsNAP.CPNAPDmonto#,
				'CC' as Tipo, <!--- as TipoMovimiento --->
				d.PCGDid,
				-1,
                #rsAnticipo.CPNAPnum#,
                #rsNAP.CPNAPDlinea#
			from 
			<cfif isdefined("rsAfectaCxPEmpleado") and rsAfectaCxPEmpleado.Pvalor EQ 1>
				#INTARC# i
				inner join GEanticipo e
			<cfelse>
				GEanticipo e
			</cfif>
				inner join GEanticipoDet d
					on d.GEAid = e.GEAid
				inner join CFuncional f
					on f.CFid = e.CFid
				inner join CFinanciera cf
					left join CPresupuesto cp
						 on cp.CPcuenta = cf.CPcuenta
					inner join CtasMayor m
						on m.Ecodigo = cf.Ecodigo
						and m.Cmayor = cf.Cmayor
				on cf.CFcuenta = d.CFcuenta
			<cfif isdefined("rsAfectaCxPEmpleado") and rsAfectaCxPEmpleado.Pvalor EQ 1>
				on d.GEADid 		= i.LIN_IDREF
			</cfif>
			where e.GEAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GEAid#">
			  and e.Ecodigo = #session.Ecodigo#			
		</cfquery>
        	
	
</cfif>---->
		
	<!---	<cf_dump var = "#x1#">--->
	
		<!----RESERVA DE PRESUPUESTO
		<cfquery datasource="#session.DSN#">
			insert into #request.intPresupuesto#
				(
				ModuloOrigen,
				NumeroDocumento,
				NumeroReferencia,
				FechaDocumento, 
				AnoDocumento,
				MesDocumento,
				NumeroLinea, 
				CFcuenta,
				Ocodigo,
				Mcodigo,
				MontoOrigen,
				TipoCambio,
				Monto,
				TipoMovimiento,
				PCGDid,
				PCGDcantidad
			)
				select 'TEAE', <!--- as ModuloOrigen --->
				<cfif Arguments.Comision gt 0>#preserveSingleQuotes(LvarNumero)#<cfelse><cf_dbfunction name="to_char" args="e.GEAnumero"></cfif> as GEAnumero, <!--- NumeroDocumento --->
				'GE.ANT,Aprobacion', <!--- NumeroReferencia --->
				e.GEAfechaSolicitud, <!--- FechaDocumento --->
				#rsPeriodoAuxiliar.Pvalor# as Periodo, <!--- AnoDocumento --->
				#rsMesAuxiliar.Pvalor# as Mes, <!--- as MesDocumento --->
				<cfif Arguments.CCHtipoCaja EQ 2>-</cfif>
				d.Linea, 	<!--- NumeroLinea --->
				d.CFcuenta, <!--- CFuenta --->
				f.Ocodigo, 	<!--- Oficina --->
				e.Mcodigo, 	<!--- Mcodigo --->
				#PreserveSingleQuotes(LvarSignoDB_CR)# * round(abs(d.GEADmonto),2) as INTMOE,
				e.GEAmanual, <!--- as TipoCambio --->
				#PreserveSingleQuotes(LvarSignoDB_CR)# * round(round(abs(d.GEADmonto),2) * e.GEAmanual,2) as INTMON,
				'RC' as Tipo, <!--- as TipoMovimiento --->
				d.PCGDid,
				1
			from GEanticipo e
				inner join GEanticipoDet d
					on d.GEAid = e.GEAid
				inner join CFuncional f
					on f.CFid = e.CFid
				inner join CFinanciera cf
					left join CPresupuesto cp
						 on cp.CPcuenta = cf.CPcuenta
					inner join CtasMayor m
						on m.Ecodigo = cf.Ecodigo
						and m.Cmayor = cf.Cmayor
				on cf.CFcuenta = d.CFcuenta
			where e.GEAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GEAid#">
			  and e.Ecodigo = #session.Ecodigo#
		</cfquery>---->
		
		<cfquery name="rsSQL" datasource="#session.DSN#" maxrows="1">
			select	ModuloOrigen,
					NumeroDocumento,
					NumeroReferencia,
					FechaDocumento,
					AnoDocumento,
					MesDocumento
			  from #request.intPresupuesto#
		</cfquery>
        
	
        
        
		
		<cfset LvarNAP = LobjControl.ControlPresupuestario	
									(	
										rsSQL.ModuloOrigen,
										rsSQL.NumeroDocumento,
										rsSQL.NumeroReferencia,
										rsSQL.FechaDocumento,
										rsSQL.AnoDocumento,
										rsSQL.MesDocumento,
										session.DSN,
										session.Ecodigo
									)>
		<cfif LvarNAP lt 0>
			<cflocation url="/cfmx/sif/presupuesto/consultas/ConsNRP.cfm?ERROR_NRP=#abs(LvarNAP)#">
		</cfif>

		
		<cfreturn LvarNAP>


	</cffunction>

<!---EMPIEZA CANCELACION DE ANTICIPO RVD--->

<cffunction name="CancelaAnticipo" access="public" returntype="numeric">
		<cfargument name="GEAid" 		type="numeric" required="yes">
		<cfargument name="CCHtipoCaja"	type="numeric" required="yes">
        <cfargument name="Comision"	    type="numeric" required="no" default="0">
      	<cfargument name="Cancela"		 type="string" default ="0" required="false">
		
		<cf_dbfunction name="OP_concat" returnvariable="_CAT">
		
		<cfset LobjControl = createObject( "component","sif.Componentes.PRES_Presupuesto")>
   		<cfset LobjControl.CreaTablaIntPresupuesto (session.dsn)/>

		<cfquery name="rsMesAuxiliar" datasource="#session.DSN#">
			select Pvalor
			from Parametros
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Pcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="60">
		</cfquery>
	
		<cfquery name="rsPeriodoAuxiliar" datasource="#session.DSN#">
			select Pvalor
			from Parametros
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Pcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="50">
		</cfquery>
	
		<cfquery name="rsSQL" datasource="#session.DSN#">
			select GEADid, GEAnumero
				from GEanticipoDet d
						inner join GEanticipo e
							inner join CFuncional f
								on f.CFid = e.CFid
								on d.GEAid = e.GEAid
			where e.GEAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GEAid#">
			and e.Ecodigo = #session.Ecodigo#
		</cfquery>

		<cfloop query="rsSQL">
			<cfquery datasource="#session.DSN#" name="Actualiza">
				update GEanticipoDet
				set Linea =  #rsSQL.currentRow#
				where GEADid = #rsSQL.GEADid#
			</cfquery>
		</cfloop>
		<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
		
		<!--- Determina el signo de los montos de DB/CR a Reservar --->
		<cfinvoke 	component			= "sif.Componentes.PRES_Presupuesto"	
					method				= "fnSignoDB_CR" 	
					returnvariable		= "LvarSignoDB_CR"
					
					INTTIP				= "d.GEADmonto"
					INTTIPxMonto		= "true"
					Ctipo				= "m.Ctipo"
					CPresupuestoAlias	= "cp"
					
					Ecodigo				= "#session.Ecodigo#"
					AnoDocumento		= "#rsPeriodoAuxiliar.Pvalor#"
					MesDocumento		= "#rsMesAuxiliar.Pvalor#"
		/>
        <cf_dbfunction name="to_char" args="e.GEAnumero" returnvariable="LvarGEAnumero">
        <cf_dbfunction name="to_char" args="#arguments.Comision#" returnvariable="LvarComision">
		<cf_dbfunction name="concat"  args="#LvarGEAnumero#+' - '+(#LvarComision#)" delimiters='+' returnvariable='LvarNumero'>
				
	    <cfquery name="rsCPCuentaAnticipo" datasource="#session.DSN#">
    	   	select Pvalor 
			from Parametros  --Pcodigo 1231, Pvalor = Cuenta Empleado 1, Gasto 2, Mcodigo = GE
			where Pcodigo = '1231'
			and Ecodigo = #session.Ecodigo#
        </cfquery>			
		
		
		<cfquery name="rsAfectaCxPEmpleado" datasource="#session.DSN#">
    	   	select Pvalor 
			from Parametros  
			where Pcodigo = '1232'
			and Ecodigo = #session.Ecodigo#
        </cfquery>	
		
		<cfif isdefined("rsAfectaCxPEmpleado") and rsAfectaCxPEmpleado.Pvalor EQ 1>
			<cfquery name="rsCxPEmpleado" datasource="#session.DSN#">
    		   	select Pvalor 
				from Parametros  
				where Pcodigo = '1233'
				and Ecodigo = #session.Ecodigo#
        	</cfquery>	
			
			<cfif isdefined("rsCxPEmpleado") and len(rsCxPEmpleado.Pvalor) EQ 0>
				<cfthrow message="Debe especifica la cuenta por pagar al empleado">
			</cfif>
            
			
			<cfquery name="rsAnticipo" datasource="#session.dsn#">
				select 	coalesce(GEAtotalOri,0) as GEAtotalOri,c.GEAid, a.GEAnumero, GEADmonto, GEADutilizado, GEAmanual,
					a.CCHid, cch.CCHtipo as CCHtipo_caja, a.CPNAPnum, a.Mcodigo, a.GECid as GECid_comision, a.Ecodigo, GEAfechaSolicitud, GECnumero, 
                    'CANC.ANT-'#_CAT# <cf_dbfunction name="to_char" args="a.GEAnumero"> as Documento,a.CPNAPnum_Pago,c.GEADid
				  from GEanticipo a
					inner join GEanticipoDet c
					on c.GEAid=a.GEAid
					inner join CCHica cch
					on cch.CCHid=a.CCHid
					inner join GEcomision co
					on co.GECid = a.GECid
				 where a.GEAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GEAid#">
			</cfquery>
            
            <cfquery name="rsNAP" datasource="#session.dsn#">
       		select d.CPNAPDlinea, d.CFcuenta,d.CPcuenta,d.Ocodigo,d.Mcodigo,
            d.CPNAPDmontoOri,d.CPNAPDtipoCambio,d.CPNAPDmonto,d.CPNAPDtipoMov,
			d.CPNAPnum,d.CPNAPDlinea,d.PCGDid, d.PCGDcantidad
                    from CPNAP n
				inner join CPNAPdetalle d
					 on d.Ecodigo	= n.Ecodigo
					and d.CPNAPnum	= n.CPNAPnum
				inner join GEanticipo c
                on c.CPNAPnum = d.CPNAPnum
			where n.Ecodigo		=  #session.Ecodigo#
            and c.GEAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GEAid#">
  			</cfquery>



<!--- Control Evento Inicia --->
	            <cfinvoke 
    	            component		= "sif.Componentes.CG_ControlEvento" 
        	        method			= "ValidaEvento"  
            	    Origen			= "TEAE"
                	Transaccion		= "ANT"
	                Conexion		= "#session.dsn#"
    	            Ecodigo			= "#session.Ecodigo#"
        	        returnvariable	= "varValidaEvento"
            	    />
	            <cfset varNumeroEvento = "">
    	        <cfif varValidaEvento GT 0>
        	        <cfinvoke 
            	    component		= "sif.Componentes.CG_ControlEvento" 
                	method			= "CG_GeneraEvento"  
	                Origen			= "TEAE"
    	            Transaccion		= "ANT"
        	        Documento 		= "#rsAnticipo.Documento#"
            	    Conexion		= "#session.dsn#"
                	Ecodigo			= "#session.Ecodigo#"
	                returnvariable	= "arNumeroEvento"
    	            />
        	        <cfif arNumeroEvento[3] EQ "">
            	        <cfthrow message="ERROR CONTROL EVENTO: No se obtuvo un control de evento valido para la operación">
                	</cfif>
	                <cfset varNumeroEvento = arNumeroEvento[3]>
					<cfset varIDEvento = arNumeroEvento[4]>
        	
      				<cfinvoke component="sif.Componentes.CG_ControlEvento" 
		        	    method="CG_RelacionaEvento" 
	        		    IDNEvento="#varIDEvento#"
			            Origen="GECM"
        			    Transaccion="COM"
		    	        Documento="#rsAnticipo.Documento#"
        			    Conexion="#session.dsn#"
		            	Ecodigo="#session.Ecodigo#"
	        		    returnvariable="arRelacionEvento"
    	   			 /> 
        			 <cfif isdefined("arRelacionEvento") and arRelacionEvento[1]>
						<cfset varNumeroEvento = arRelacionEvento[4]>
        			 </cfif>
	            </cfif>
                
 			    <!----Control Evento Fin --->

			<cfinvoke component="sif.Componentes.CG_GeneraAsiento" 	method="CreaIntarc"  	 returnvariable="INTARC" />
		
<!---			<cfset sbFechaContable(#rsAnticipo.Ecodigo#, #rsAnticipo.GEAnumero#, #rsAnticipo.GEAfechaPagar#)>--->
		
			<!---OFICINA--->
			<cfquery datasource="#session.dsn#" name="rsOficina">
				select Ocodigo
				from Oficinas
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAnticipo.Ecodigo#">
			</cfquery>
			
			<cfset Documento = '#rsAnticipo.GEAnumero#(#rsAnticipo.GECnumero#)'>

<!---<cfif Arguments.Cancela EQ "0">--->
			<!----cuenta del empleado o cuenta de gasto---->
			<cfquery datasource="#session.dsn#">
				insert into #INTARC# 
				( 
				INTORI, INTREL, 
				INTDOC, INTREF, 
				INTFEC, Periodo, Mes, Ocodigo, 
				INTTIP, INTDES, 
				CFcuenta, Ccuenta, 

				Mcodigo, INTMOE, INTCAM, INTMON, INTMON2,
				
				LIN_IDREF,PCGDid<!---, NumeroEvento--->
				)
				select 'TEAE', 1,
				 '#Documento#',
				 'TEAE Anticipo a Empleado',
				 '#DateFormat(now(),"YYYYMMDD")#', #rsPeriodoAuxiliar.Pvalor#, #rsMesAuxiliar.Pvalor#, #rsOficina.Ocodigo#,
				 'C', 'TES:Cancela ANT.' #_CAT# '#Documento#',
				 <cfif isdefined('rsCPCuentaAnticipo') and rsCPCuentaAnticipo.Pvalor EQ 1>
					a.CFcuenta, <!--- CFuenta --->
                <cfelse>
    	            c.CFcuenta,
                </cfif>
				0,
				a.Mcodigo, GEADmonto, GEADtipocambio, round(GEADmonto * GEADtipocambio,2), GEADmonto * GEADtipocambio,
				GEADid, PCGDid<!---, '#varNumeroEvento#'--->
				from GEanticipo a
				inner join GEanticipoDet c
					on c.GEAid=a.GEAid
				inner join CCHica cch
					on cch.CCHid=a.CCHid
				inner join GEcomision co
					on co.GECid = a.GECid
				 where a.GEAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GEAid#">
			</cfquery>		 
	
			<!---cuenta puente parametrizada--->
			<cfquery datasource="#session.dsn#">
				insert into #INTARC# 
				( 
				INTORI, INTREL, 
				INTDOC, INTREF, 
				INTFEC, Periodo, Mes, Ocodigo, 
				INTTIP, INTDES, 
				CFcuenta, Ccuenta, 

				Mcodigo, INTMOE, INTCAM, INTMON, INTMON2,
				
				LIN_IDREF,PCGDid<!---, NumeroEvento--->
				)
				select 'TEAE', 1,
				 '#Documento#',
				 'TEAE Anticipo a Empleado',
				 '#DateFormat(now(),"YYYYMMDD")#', #rsPeriodoAuxiliar.Pvalor#, #rsMesAuxiliar.Pvalor#, #rsOficina.Ocodigo#,
				 'D', 'TES:Cancela ANT. Cuenta por pagar al empleado',
				#rsCxPEmpleado.Pvalor#,
				0,
				a.Mcodigo, GEADmonto, GEADtipocambio, round(GEADmonto * GEADtipocambio,2), GEADmonto * GEADtipocambio,
				GEADid, PCGDid<!---, '#varNumeroEvento#'--->
			 	 from GEanticipo a
				inner join GEanticipoDet c
					on c.GEAid=a.GEAid
				inner join CCHica cch
					on cch.CCHid=a.CCHid
				inner join GEcomision co
					on co.GECid = a.GECid
				 where a.GEAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GEAid#">
			</cfquery>	
            
                        </cfif>	 

		<!-----COMPROMETIDO ----->
<cfquery datasource="#session.DSN#">


       		insert into #request.intPresupuesto#
				(
				ModuloOrigen,
				NumeroDocumento,
				NumeroReferencia,
				FechaDocumento, 
				AnoDocumento,
				MesDocumento,
				NumeroLinea, 
				CFcuenta,
                CPcuenta,
				Ocodigo,
				Mcodigo,
				MontoOrigen,
				TipoCambio,
				Monto,
				TipoMovimiento,
				PCGDid,
				PCGDcantidad,
                NAPreferencia,
                LINreferencia
			)
				select distinct 'TEAE', <!--- as ModuloOrigen --->
				e.GEAnumero, <!--- NumeroDocumento --->
				'GE.ANT,Cancelado', <!--- NumeroReferencia --->
				e.GEAfechaSolicitud, <!--- FechaDocumento ANTES GEAfechaSolicitud--->
				#rsPeriodoAuxiliar.Pvalor# as Periodo, <!--- AnoDocumento --->
				#rsMesAuxiliar.Pvalor# as Mes, <!--- as MesDocumento --->

				d.Linea, 	<!--- NumeroLinea --->
				<cfif isdefined('rsCPCuentaAnticipo') and rsCPCuentaAnticipo.Pvalor EQ 1>
					e.CFcuenta, <!--- CFuenta --->
                <cfelse>
    	            d.CFcuenta,
                </cfif>
                #rsNAP.CPcuenta#,
				f.Ocodigo, 	<!--- Oficina --->
				e.Mcodigo, 	<!--- Mcodigo --->
				-#rsNAP.CPNAPDmontoOri#,
				#rsNAP.CPNAPDtipoCambio#, <!--- as TipoCambio --->
				-#rsNAP.CPNAPDmonto#,
				'CC' as Tipo, <!--- as TipoMovimiento --->
				d.PCGDid,
				-1,
                #rsAnticipo.CPNAPnum#,
                #rsNAP.CPNAPDlinea#
			from 
			<cfif isdefined("rsAfectaCxPEmpleado") and rsAfectaCxPEmpleado.Pvalor EQ 1>
				#INTARC# i
				inner join GEanticipo e
			<cfelse>
				GEanticipo e
			</cfif>
				inner join GEanticipoDet d
					on d.GEAid = e.GEAid
				inner join CFuncional f
					on f.CFid = e.CFid
				inner join CFinanciera cf
					left join CPresupuesto cp
						 on cp.CPcuenta = cf.CPcuenta
					inner join CtasMayor m
						on m.Ecodigo = cf.Ecodigo
						and m.Cmayor = cf.Cmayor
				on cf.CFcuenta = d.CFcuenta
			<cfif isdefined("rsAfectaCxPEmpleado") and rsAfectaCxPEmpleado.Pvalor EQ 1>
				on d.GEADid 		= i.LIN_IDREF
			</cfif>
			where e.GEAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.GEAid#">
			  and e.Ecodigo = #session.Ecodigo#			
		</cfquery>
        	

		
		<cfquery name="rsSQL" datasource="#session.DSN#" maxrows="1">
			select	ModuloOrigen,
					NumeroDocumento,
					NumeroReferencia,
					FechaDocumento,
					AnoDocumento,
					MesDocumento
			  from #request.intPresupuesto#
		</cfquery>
        
        	<cfquery name="rsIntarc" datasource="#session.DSN#" maxrows="1">
			select	INTDES,
					INTREF,
					Ocodigo
				  from #INTARC#
		</cfquery>
        
	
        
		
		<cfset LvarNAP = LobjControl.ControlPresupuestario	
									(	
										rsSQL.ModuloOrigen,
										rsSQL.NumeroDocumento,
										rsSQL.NumeroReferencia,
										rsSQL.FechaDocumento,
										rsSQL.AnoDocumento,
										rsSQL.MesDocumento,
										session.DSN,
										session.Ecodigo
									)>
		<cfif LvarNAP lt 0>
			<cflocation url="/cfmx/sif/presupuesto/consultas/ConsNRP.cfm?ERROR_NRP=#abs(LvarNAP)#">
		</cfif>
	<cfinvoke 	component="sif.Componentes.CG_GeneraAsiento" 
				method="GeneraAsiento"
				returnvariable="LvarIDcontable" 
		Oorigen 		= "TEAE"
		Eperiodo		= "#rsSQL.AnoDocumento#"
		Emes			= "#rsSQL.MesDocumento#"
		Efecha			= "#rsSQL.FechaDocumento#"
		Edescripcion	= "#rsIntarc.INTDES#"
		Edocbase		= "#rsSQL.NumeroDocumento#"
		Ereferencia		= "#rsIntarc.INTREF#"
		usuario 		= "#session.Usucodigo#"
		Ocodigo 		= "#rsIntarc.Ocodigo#"
		Usucodigo 		= "#session.Usucodigo#"
		Ecodigo         = "#session.Ecodigo#"
        debug			= "false"
		NAP				= "#LvarNAP#"
	/>
		
		<cfreturn LvarNAP>


	</cffunction>


<!---TERMINA CANCELACION DE ANTICIPO RVD--->


<!--- Funcion que hace un -Anticipo o +Anticipo en presupuesto --->
<!--- Se agrega logica para realizar anulacion de los movimientos en Caja Chica. Se copia el NAP, se modifica el signo de los montos y la referencia. --->
	<cffunction name="PresupuestoLiquidacionCCh" access="public">
		<cfargument name="GELid"     type="numeric" required="yes">
        <cfargument name="Anulacion" type="boolean" required="no" default="false">
        <cfargument name="Comision"	    type="numeric" required="no" default="0">
        
		<cfset LobjControl = createObject( "component","sif.Componentes.PRES_Presupuesto")>
		<cfset LobjControl.CreaTablaIntPresupuesto (session.dsn)/>
 
		<cfquery name="rsMesAuxiliar" datasource="#session.DSN#">
			select Pvalor
			from Parametros
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Pcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="60">
		</cfquery>
	
		<cfquery name="rsPeriodoAuxiliar" datasource="#session.DSN#">
			select Pvalor
			from Parametros
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Pcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="50">
		</cfquery>
	
        <cfif Arguments.Anulacion>
            <cfquery name="rsLiq" datasource="#session.dsn#">
                select GELnumero, CPNAPnum
                  from GEliquidacion 
                 where GELid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GELid#">
            </cfquery>
            <cfif rsLiq.CPNAPnum NEQ "">
                <cfquery datasource="#session.DSN#">
	                insert into #request.intPresupuesto#
                    (
                        ModuloOrigen,
                        NumeroDocumento,
                        NumeroReferencia,
                        FechaDocumento,
                        AnoDocumento,
                        MesDocumento,
                        NumeroLinea, 
                        CFcuenta,
                        Ocodigo,
                        Mcodigo,
                        MontoOrigen,
                        TipoCambio,
                        Monto,
                        TipoMovimiento,
                        NAPreferencia, 
                        LINreferencia,
                        PCGDid,
                        PCGDcantidad
                    )
                    select  cp.CPNAPmoduloOri,
                            '#rsLiq.GELnumero#' as GELnumero, 	<!--- NumeroDocumento --->
                            'GE.LIQ,Cancelacion', 				<!--- NumeroReferencia --->
                            cp.CPNAPfecha,
                            #rsPeriodoAuxiliar.Pvalor# as Periodo, <!--- Año --->
							#rsMesAuxiliar.Pvalor# as Mes, <!--- as Mes --->
                            cpd.CPNAPDlinea, 
                            cpd.CFcuenta,
                            cpd.Ocodigo,
                            cpd.Mcodigo,
                            -cpd.CPNAPDmontoOri,
                            cpd.CPNAPDtipoCambio,
                            -cpd.CPNAPDmonto,       
                            cpd.CPNAPDtipoMov,
                            #rsLiq.CPNAPnum#, 
                            <cf_dbfunction name="to_number" args="cpd.CPNAPDlinea">,
                            cpd.PCGDid,
							cpd.PCGDcantidad
                    from CPNAP cp
                    inner join CPNAPdetalle cpd
                    on cpd.Ecodigo = cp.Ecodigo
                    and cpd.CPNAPnum = cp.CPNAPnum
                    where cpd.Ecodigo  = #session.Ecodigo#  
                      and cpd.CPNAPnum = #rsLiq.CPNAPnum#
                </cfquery>
            </cfif>
        <cfelse>
			<!--- 1) Anticipos --->
            <!--- 1.1) Genera secuencia de Anticipos --->
            <cfquery name="rsSQLA" datasource="#session.DSN#">
                select a.GELid,a.GEADid from GEliquidacionAnts  a
                inner join GEliquidacion l
                on  a.GELid=l.GELid	
                where a.GELid=<cfqueryparam value="#Arguments.GELid#" cfsqltype="cf_sql_numeric">
            </cfquery>
            
            <cfset LvarAntsN = rsSQLA.recordcount>
            <cfloop query="rsSQLA">
                <cfquery name="Cualquier" datasource="#session.dsn#">
                    update GEliquidacionAnts 
                    set Linea=#rsSQLA.currentRow#
                    where GEADid=#rsSQLA.GEADid#
                    and GELid=<cfqueryparam value="#Arguments.GELid#" cfsqltype="cf_sql_numeric">
                </cfquery>
            </cfloop>
        
            <!--- Determina el signo de los montos de DB/CR a Reservar o DesReservar--->
            <cfinvoke 	component			= "sif.Componentes.PRES_Presupuesto"	
                        method				= "fnSignoDB_CR" 	
                        returnvariable		= "LvarSignoDB_CR"
                        
                        INTTIP				= "x.GELAtotal"
                        INTTIPxMonto		= "true"
                        Ctipo				= "cm.Ctipo"
                        CPresupuestoAlias	= "cp"
                        
                        Ecodigo				= "#session.Ecodigo#"
                        AnoDocumento		= "#rsPeriodoAuxiliar.Pvalor#"
                        MesDocumento		= "#rsMesAuxiliar.Pvalor#"
            />
        	<cf_dbfunction name="to_char" args="le.GELnumero" returnvariable="LvarGELnumero">
        	<cf_dbfunction name='concat' args="#LvarGELnumero#+'(#arguments.Comision#)'" delimiters='+' returnvariable='LvarNumeroL'>
            <!--- 1.2) DesReserva o Reserva Anticipo-CtaGasto --->
            <cfquery datasource="#session.DSN#" name="rsDESRESERVA">
	            insert into #request.intPresupuesto#
                (
                    ModuloOrigen,
                    NumeroDocumento,
                    NumeroReferencia,
                    FechaDocumento,
                    AnoDocumento,
                    MesDocumento,
                    NumeroLinea, 
                    CFcuenta,
                    Ocodigo,
                    Mcodigo,
                    MontoOrigen,
                    TipoCambio,
                    Monto,
                    TipoMovimiento,
                    NAPreferencia, 
                    LINreferencia,
                    PCGDid,
                    PCGDcantidad
                )
                select 'TEGE', <!--- as ModuloOrigen --->
                	<cfif Arguments.Comision gt 0>#preserveSingleQuotes(LvarNumeroL)#<cfelse><cf_dbfunction name="to_char" args="le.GELnumero"></cfif> as GELnumero, <!--- NumeroDocumento --->
                    'GE.LIQ,Aprobacion', <!--- NumeroReferencia --->
                    <cf_dbfunction name="date_format" args="le.GELfecha,yyyy-mm-dd hh:mi:ss">
                    as GELfecha, <!--- FechaDocumento --->
                    #rsPeriodoAuxiliar.Pvalor# as Periodo, <!--- AnoDocumento --->
                    #rsMesAuxiliar.Pvalor# as Mes, <!--- as MesDocumento --->
                    x.Linea as linea,
                    d.CFcuenta, <!--- GEanticipoDet.CFuenta = Cta Anticipo Gasto --->
                    f.Ocodigo, <!--- Oficina --->
                    e.Mcodigo, <!--- Mcodigo --->
                    -#PreserveSingleQuotes(LvarSignoDB_CR)# * round(abs(x.GELAtotal),2) as INTMOE,
                    e.GEAmanual, <!--- as TipoCambio --->
                    -#PreserveSingleQuotes(LvarSignoDB_CR)# * round(round(abs(x.GELAtotal),2) * e.GEAmanual,2) as INTMON,
                    'RC' as Tipo, <!--- as TipoMovimiento --->
                    e.CPNAPnum,
                    d.Linea,
                    d.PCGDid,
                    -1	
                from GEliquidacionAnts x
                    inner join GEliquidacion le
                        on le.GELid = x.GELid
                    inner join GEanticipoDet d
                        on d.GEADid = x.GEADid
                    inner join GEanticipo e
                        inner join CFuncional f
                            on f.CFid = e.CFid
                        on e.GEAid = d.GEAid
                    inner join CFinanciera cf
                        left join CPresupuesto cp
                             on cp.CPcuenta = cf.CPcuenta
                        inner join CtasMayor cm
                            on cm.Ecodigo = cf.Ecodigo
                            and cm.Cmayor = cf.Cmayor
                    on cf.CFcuenta = d.CFcuenta
                where  x.GELid =<cfqueryparam value="#Arguments.GELid#" cfsqltype="cf_sql_numeric">
            </cfquery>
                
            <!--- 2) Gastos --->
            <!--- 2.1) Genera secuencia de Gastos --->
            <cfquery name="rsSQL" datasource="#session.DSN#">
                select d.GELGid, e.GELnumero
                    from GEliquidacionGasto d
                            inner join GEliquidacion e
                                inner join CFuncional f
                                    on f.CFid = e.CFid
                                    on d.GELid = e.GELid
                where e.GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GELid#">
                and e.Ecodigo = #session.Ecodigo#
            </cfquery>
    
            <cfloop query="rsSQL">
                <cfquery datasource="#session.DSN#" name="Actualiza">
                    update GEliquidacionGasto
                    set Linea =  #rsSQL.currentRow# + #LvarAntsN#
                    where GELGid = #rsSQL.GELGid#
                </cfquery>
            </cfloop>
    
            <!--- 2.2) Reserva o DesReserva Gastos-CtaGasto --->
            <!--- Determina el signo de los montos de DB/CR a Reservar o DesReserva --->
            <cfinvoke 	component			= "sif.Componentes.PRES_Presupuesto"	
                        method				= "fnSignoDB_CR" 	
                        returnvariable		= "LvarSignoDB_CR"
                        
                        INTTIP				= "d.GELGtotalOri"
                        INTTIPxMonto		= "true"
                        Ctipo				= "m.Ctipo"
                        CPresupuestoAlias	= "cp"
                        
                        Ecodigo				= "#session.Ecodigo#"
                        AnoDocumento		= "#rsPeriodoAuxiliar.Pvalor#"
                        MesDocumento		= "#rsMesAuxiliar.Pvalor#"
            />
        
            <cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
            <cf_dbfunction name="to_char" args="e.GELnumero" returnvariable="LvarGELnumero2">
        	<cf_dbfunction name='concat' args="#LvarGELnumero2#+'(#arguments.Comision#)'" delimiters='+' returnvariable='LvarNumeroL2'>
            <cfquery datasource="#session.DSN#">
                insert into #request.intPresupuesto#
                    (
                    ModuloOrigen,
                    NumeroDocumento,
                    NumeroReferencia,
                    FechaDocumento, 
                    AnoDocumento,
                    MesDocumento,
                    NumeroLinea, 
                    CFcuenta,
                    Ocodigo,
                    Mcodigo,
                    MontoOrigen,
                    TipoCambio,
                    Monto,
                    TipoMovimiento,
                    PCGDid,
                    PCGDcantidad
                )
                    select 'TEGE', <!--- as ModuloOrigen --->
                    <cfif Arguments.Comision gt 0>#preserveSingleQuotes(LvarNumeroL2)#<cfelse><cf_dbfunction name="to_char" args="e.GELnumero"></cfif> as GELnumero, <!--- NumeroDocumento --->
                    'GE.LIQ,Aprobacion', <!--- NumeroReferencia --->
                    e.GELfecha, <!--- FechaDocumento --->
                    #rsPeriodoAuxiliar.Pvalor# as Periodo, <!--- AnoDocumento --->
                    #rsMesAuxiliar.Pvalor# as Mes, <!--- as MesDocumento --->
                    d.Linea, <!--- NumeroLinea --->
                    d.CFcuenta, <!--- CFuenta --->
                    f.Ocodigo, <!--- Oficina --->
                    e.Mcodigo, <!--- Mcodigo --->
                    #PreserveSingleQuotes(LvarSignoDB_CR)# * round(abs(d.GELGtotalOri),2) as INTMOE,
                    e.GELtipoCambio, <!--- as TipoCambio --->
                    #PreserveSingleQuotes(LvarSignoDB_CR)# * round(round(abs(d.GELGtotalOri),2) * e.GELtipoCambio,2) as INTMON,
                    'RC' as Tipo, <!--- as TipoMovimiento --->
                    d.PCGDid,
                    1
                from GEliquidacion e
                    inner join GEliquidacionGasto d
                        on d.GELid = e.GELid
                    inner join CFuncional f
                        on f.CFid = e.CFid
                    inner join CFinanciera cf
                        left join CPresupuesto cp
                             on cp.CPcuenta = cf.CPcuenta
                        inner join CtasMayor m
                            on m.Ecodigo = cf.Ecodigo
                            and m.Cmayor = cf.Cmayor
                    on cf.CFcuenta = d.CFcuenta
                where e.GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GELid#">
                  and e.Ecodigo = #session.Ecodigo#
            </cfquery>
        </cfif>

		<cfquery name="rsSQL" datasource="#session.DSN#" maxrows="1">
			select	ModuloOrigen,
					NumeroDocumento,
					NumeroReferencia,
					FechaDocumento,
					AnoDocumento,
					MesDocumento
			  from #request.intPresupuesto#
		</cfquery>
			
		<cfif rsSQL.recordCount GT 0>
			<cfset LvarNAP = LobjControl.ControlPresupuestario	
                                        (	
                                            rsSQL.ModuloOrigen,
                                            rsSQL.NumeroDocumento,
                                            rsSQL.NumeroReferencia,
                                            rsSQL.FechaDocumento,
                                            rsSQL.AnoDocumento,
                                            rsSQL.MesDocumento,
                                            session.DSN,
                                            session.Ecodigo
                                        )>
            <cfif LvarNAP lt 0>
                <cflocation url="/cfmx/sif/presupuesto/consultas/ConsNRP.cfm?ERROR_NRP=#abs(LvarNAP)#">
            </cfif>
    
            <cfquery datasource="#session.dsn#">
                update GEliquidacion 
                <cfif Anulacion>
                   set CPNAPnum_cancelacion = #LvarNAP#
                <cfelse>
                   set CPNAPnum = #LvarNAP#
                   <!---, SEC_NAP = SEC_NAP + 1 En caso de que se necesita secuencia, se debe crear el capo y habilitar esto--->
                </cfif>
                 where GELid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GELid#">
            </cfquery>
        </cfif>
	</cffunction>
	
	<cffunction name="sbFechaContable" output="false" access="private" returntype="void">
		<cfargument name="Ecodigo"				type="numeric"	required="yes">
		<cfargument name="Numero"				type="string"	required="yes">
		<cfargument name="FechaPago"			type="date"		required="yes">

		<cfset LvarNow = now()>
		<cfset LvarHoy = createodbcdate(LvarNow)>

		<!---- Carga el periodo del Ecodigo --->
		<cfquery name="rsParametros" datasource="#session.DSN#">
			select 	<cf_dbfunction name="to_number" args="p1.Pvalor"> as AuxPeriodo,
					<cf_dbfunction name="to_number" args="p2.Pvalor"> as AuxMes,
					e.Edescripcion
			  from Parametros p1, Parametros p2, Empresas e
			 where p1.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			   and p1.Mcodigo = 'GN'
			   and p1.Pcodigo = 50

			   and p2.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			   and p2.Mcodigo = 'GN'
			   and p2.Pcodigo = 60
		   
			   and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
		</cfquery>	
    

		<cfset LvarPrimerDiaAux		= createdate(rsParametros.AuxPeriodo,rsParametros.AuxMes,1)>
		<cfset LvarUltimoDiaAux		= dateadd("d",-1,dateadd("m",1,LvarPrimerDiaAux))>
		<cfset LvarUltimoDiaSigAux	= dateadd("d",-1,dateadd("m",2,LvarPrimerDiaAux))>

		<!--- El Mes de Auxiliares no puede estar definido a futuro --->
		<!--- La Fecha de Pago no puede ser posterior al siguiente periodo de auxiliares --->
		<cfif LvarHoy LT LvarPrimerDiaAux>
			<cf_errorCode	code = "51607"
						msg  = "El Periodo de Auxiliares está configurado en el Futuro: Empresa = '@errorDat_1@', Fecha Actual = '@errorDat_2@', Período Auxiliares = '@errorDat_3@/@errorDat_4@'"
						errorDat_1="#rsParametros.Edescripcion#"
						errorDat_2="#DateFormat(LvarHoy,"DD/MM/YYYY")#"
						errorDat_3="#rsParametros.AuxPeriodo#"
						errorDat_4="#rsParametros.AuxMes#"
			>
		</cfif>
	
		<!---<cfif LvarAnulacion>
			<!---- ANULACION: La FechaContable es la mayor entre 
							la fecha de pago y 
							la menor entre hoy y ultimo dia del mes de pago --->
			<cfif Arguments.FechaPago GT LvarUltimoDiaSigAux>
				<!---- ANULACION: La Fecha de Pago no puede ser Posterior al Mes de Auxiliares --->
				<cf_errorCode	code = "51608"
							msg  = "La Fecha de Pago es posterior al Siguiente Período de Auxiliares: Empresa = '@errorDat_1@', Orden de Pago = '@errorDat_2@', Fecha de Pago = '@errorDat_3@', Período Auxiliares = '@errorDat_4@/@errorDat_5@'"
							errorDat_1="#rsParametros.Edescripcion#"
							errorDat_2="#Arguments.Numero#"
							errorDat_3="#DateFormat(Arguments.FechaPago,"DD/MM/YYYY")#"
							errorDat_4="#rsParametros.AuxPeriodo#"
							errorDat_5="#rsParametros.AuxMes#"
				>
			<cfelseif Arguments.FechaPago GTE LvarHoy>
				<cfset LvarFechaContable = Arguments.FechaPago>
			<cfelse>
				<cfif Arguments.FechaPago LTE LvarUltimoDiaAux>
					<cfset LvarUltimoDiaMesPago = LvarUltimoDiaAux>
				<cfelse>
					<cfset LvarUltimoDiaMesPago = LvarUltimoDiaSigAux>
				</cfif>

				<cfif LvarHoy LTE LvarUltimoDiaMesPago>
					<cfset LvarFechaContable = LvarHoy>
				<cfelse>
					<cfset LvarFechaContable =  LvarUltimoDiaMesPago>
				</cfif>
			</cfif>
		<cfelse>--->
			<!---- PAGO: La FechaContable es la Fecha de Pago, que sólo se permite del Mes de Auxiliares o del Siguiente --->
			<cfset LvarFechaContable = Arguments.FechaPago>

			<cfif Arguments.FechaPago GT LvarUltimoDiaSigAux>
       
			<!---- PAGO: La Fecha de Pago no puede ser Posterior al Mes de Auxiliares --->
			<cf_errorCode	code = "51608"
							msg  = "La Fecha de Pago es posterior al Siguiente Período de Auxiliares: Empresa = '@errorDat_1@', Orden de Pago = '@errorDat_2@', Fecha de Pago = '@errorDat_3@', Período Auxiliares = '@errorDat_4@/@errorDat_5@'"
							errorDat_1="#rsParametros.Edescripcion#"
							errorDat_2="#Arguments.Numero#"
							errorDat_3="#DateFormat(Arguments.FechaPago,"DD/MM/YYYY")#"
							errorDat_4="#rsParametros.AuxPeriodo#"
							errorDat_5="#rsParametros.AuxMes#"
			>
			<cfelseif Arguments.FechaPago LT LvarPrimerDiaAux>
			<!---- PAGO: La Fecha de Pago no puede ser anterior al Mes de Auxiliares --->
			<cf_errorCode	code = "51609"
							msg  = "La Fecha de Pago es anterior al Período de Auxiliares: Empresa = '@errorDat_1@', Orden de Pago = '@errorDat_2@', Fecha de Pago = '@errorDat_3@', Período Auxiliares = '@errorDat_4@/@errorDat_5@'"
							errorDat_1="#rsParametros.Edescripcion#"
							errorDat_2="#Arguments.Numero#"
							errorDat_3="#DateFormat(Arguments.FechaPago,"DD/MM/YYYY")#"
							errorDat_4="#rsParametros.AuxPeriodo#"
							errorDat_5="#rsParametros.AuxMes#"
			>
			</cfif>
		<!---</cfif>
--->
		<cfif LvarFechaContable LT LvarPrimerDiaAux OR LvarFechaContable GT LvarUltimoDiaSigAux>
			<cf_errorCode	code = "51610"
						msg  = "La Fecha Contable debe estar en el Período de Auxiliares o en el Siguiente: Empresa = '@errorDat_1@', Orden de Pago = '@errorDat_2@', Fecha de Pago = '@errorDat_3@', Fecha Contable = '@errorDat_4@', Período Auxiliares = '@errorDat_5@/@errorDat_6@'"
						errorDat_1="#rsParametros.Edescripcion#"
						errorDat_2="#Arguments.Numero#"
						errorDat_3="#DateFormat(Arguments.FechaPago,"DD/MM/YYYY")#"
						errorDat_4="#DateFormat(LvarFechaContable,"DD/MM/YYYY")#"
						errorDat_5="#rsParametros.AuxPeriodo#"
						errorDat_6="#rsParametros.AuxMes#"
			>
		</cfif>

			<cfset LvarAuxPeriodo 	= DateFormat(LvarFechaContable,"YYYY")>			
			<cfset LvarAuxMes 		= DateFormat(LvarFechaContable,"MM")>			
	</cffunction>

</cfcomponent>
