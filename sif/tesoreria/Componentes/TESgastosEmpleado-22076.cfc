<cfcomponent>
<cf_dbfunction name="FN_substr" returnvariable="_SUBSTR">
<!---Aprobacion de Anticipos por Caja Chica--->
<cffunction access="public" name="AACCH">
	<cfargument name="GEAid" 		type="numeric" required="yes">
	<cfargument name="CCHid" 		type="numeric" required="yes">
	<cfargument name="CCHTidProc" type="numeric" required="yes">
	<cfargument name="monto" type="numeric" required="yes">

	<!--- Pasos:
			1- Verifica Presupuesto
			2- Verifica Disponible en caja
			3- Inicia Transacción
			4- Actualiza el estado de la transacción
			5- Componente que crea la Transacción en proceso (Crea las transacciones en seguimiento---Actualiza el estado de las transacciones En proceso)
			6- Actulización del estado del Anticipo
			7- 
	--->
	<!--- Valida El Usuario Aprobador--->

		<cfquery datasource="#session.dsn#" name="rsAnticipo">
				select 
						a.GEAid,
						a.GEAtotalOri,
						a.CCHTid, 
						a.CFid,
						a.Mcodigo,
						a.GEAdescripcion,
						a.GEAtotalOri
				from GEanticipo a
				where a.GEAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.GEAid#">	
		</cfquery>
		
		<cfquery name="rsCajaChica" datasource="#session.dsn#">
				select 
						CCHid,
						CCHresponsable
				from CCHica 
				where 	CCHid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CCHid#">
				and		Ecodigo=#session.Ecodigo#
		</cfquery>
	
		<cfset LvarCCHTid=rsAnticipo.CCHTid>
		<cfquery name="rsSPaprobador" datasource="#session.dsn#">
			Select TESUSPmontoMax, TESUSPcambiarTES
			from TESusuarioSP
			where CFid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAnticipo.CFid#"> 
			and Usucodigo	= #session.Usucodigo#
			and TESUSPaprobador = 1
		</cfquery>
	<!--- Valida El Usuario Aprobador--->
		
		<!--- Invoka componente de Presupuesto--->
		<cfinvoke component="sif.tesoreria.Componentes.TESCajaChicaPresupuesto" method="ReservaAnticipo">
			<cfinvokeargument name="GEAid" value="#rsAnticipo.GEAid#"/>	
		</cfinvoke>	
		
		
			<!---Inserta en transacciones Aplicadas.--->
			<cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="TAplicadas">
				<cfinvokeargument name="CCHid"    				value="#rsCajaChica.CCHid#"/>
				<cfinvokeargument name="Mcodigo" 				value="#rsAnticipo.Mcodigo#"/>
				<cfinvokeargument name="CCHTdescripcion"    	value="#rsAnticipo.GEAdescripcion#"/>
				<cfinvokeargument name="CCHTestado"		    	value="APLICADO"/>
				<cfinvokeargument name="CCHTmonto"   			value="#arguments.monto#"/>
				<cfinvokeargument name="CCHTidCustodio"    		value="#rsCajaChica.CCHresponsable#"/>
				<cfinvokeargument name="Sufijo" 				value="ANTICIPO"/>
				<cfinvokeargument name="CCHTid"    				value="#LvarCCHTid#"/>
				<cfinvokeargument name="CCHTtipo"		    	value="ANTICIPO"/>
			</cfinvoke>	
			
			<!---Actualiza el estado de las transacciones En proceso He inserta en seguimiento--->
			<cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="CambiaEstadoTP">
				<cfinvokeargument name="CCHTid"    			value="#LvarCCHTid#"/>
				<cfinvokeargument name="CCHTestado" 		value="POR CONFIRMAR"/>
				<cfinvokeargument name="CCHtipo"    		value="ANTICIPO"/>
				<cfinvokeargument name="CCHTrelacionada"    value="#rsAnticipo.GEAid#"/>
				<cfinvokeargument name="CCHTtrelacionada"   value="ANTICIPO"/>
			</cfinvoke>	
			
			<!--- Actulización del estado del Anticipo--->
			<cfquery name="rsActualiza" datasource="#session.DSN#">
				update GEanticipo set 
						GEAestado =2, 
						CCHid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CCHid#">,
						GEAtipoP=0
				where GEAid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAnticipo.GEAid#">
				and Ecodigo=#session.Ecodigo#
			</cfquery>
			<!--- Crea la transaccion del Custodio--->
			<cfinvoke component="sif.tesoreria.Componentes.TESCustodio" method="TranCustodioP" returnvariable="LvarCCHTCid">
				<cfinvokeargument name="CCHTCestado"        value="POR CONFIRMAR"/>
				<cfinvokeargument name="CCHTtipo"       	value="ANTICIPO"/>
				<cfinvokeargument name="CCHTCconfirmador"	value="#session.usucodigo#"/>
				<cfinvokeargument name="CCHTCrelacionada"   value="#arguments.GEAid#"/>
				<cfinvokeargument name="CCHTid"         	value="#arguments.CCHTidProc#"/>
			</cfinvoke>
	
	
</cffunction>

<!---Funcion que Aprueba las Liquidacione por CAJA CHICA--->
<cffunction name="ALCAJACHICA" access="public">
	<cfargument name="GELid" type="numeric" required="yes">
	<cfargument name="CCHid" type="numeric" required="yes">

	<!---Validaciones De la Liquidacion.--->
	<!---Interfas con Presupuesto--->
	<!---Llamado de Componenete--->
	<!---Actualizacion de Liquidaciones--->
	
	<!--- Valida El Usuario Aprobador--->
	<cfquery datasource="#session.dsn#" name="rsLiquidacion">
		select GELid,CCHTid, CFid,Mcodigo,GELdescripcion,GELtotalGastos, GELtotalDepositos,GELtotalAnticipos, coalesce(GELtotalDevoluciones,0) as GELtotalDevoluciones
		from GEliquidacion 
		where GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GELid#">	
	</cfquery>
	
	<cfquery name="rsCajaChica" datasource="#session.dsn#">
		select 
				CCHid,
				CCHresponsable
		from CCHica 
		where 	CCHid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CCHid#">
		and		Ecodigo=#session.Ecodigo#
	</cfquery>
	
	<cfset LvarCCHTid=rsLiquidacion.CCHTid>
	
	<cfquery name="rsSPaprobador" datasource="#session.dsn#">
		Select TESUSPmontoMax, TESUSPcambiarTES
		from TESusuarioSP
		where CFid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLiquidacion.CFid#">
		and Usucodigo	= #session.Usucodigo#
		and TESUSPaprobador = 1
	</cfquery>
	
	<cfset LvarEsAprobadorSP = (rsSPaprobador.RecordCount GT 0)>
	
	<cfif not LvarEsAprobadorSP>
		<cfabort showerror="El Usuario no es Aprobador">	
	</cfif>
	<!--- FIN Valida El Usuario Aprobador--->	
	
	<cfset LvarTipo='GASTOS'>
	
	<!--- Validaciones Liquidaciones--->	
		<cfquery name="Busqueda" datasource="#session.dsn#">
			select TESBid,Mcodigo,Ecodigo,GELreembolso from GEliquidacion
			where GELid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLiquidacion.GELid#">
		</cfquery>	
	
		<cfif Busqueda.GELreembolso GT 0>
			
			<cfquery name="rsAnticipos" datasource="#session.dsn#">
				select a.GEAid,a.GEAnumero, sum(GEADmonto - GEADutilizado - TESDPaprobadopendiente - coalesce(GELAtotal,0)) as SaldoSinLiquidar
					from GEanticipo a
						inner join GEanticipoDet b
							left join GEliquidacionAnts c 
								inner join GEliquidacion e
								on e.GELid  = c.GELid
								and e.GELestado  in (0,1)
							on c.GELid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLiquidacion.GELid#">
							and c.GEADid = b.GEADid
						on b.GEAid = a.GEAid
					where a.TESBid            = #Busqueda.TESBid#
					  and a.GEAestado      = 4  -- DEBE SER 4=Pagado
					  and a.Mcodigo              = #Busqueda.Mcodigo#
					  and a.Ecodigo               = #Busqueda.Ecodigo#
				group by a.GEAid,a.GEAnumero
				having sum(GEADmonto - GEADutilizado - TESDPaprobadopendiente - coalesce(GELAtotal,0)) > 0
			</cfquery>
	
			<cfif rsAnticipos.recordcount gt 0>
				<font color="FF0000" size="+2">
				El empleado tiene Anticipos con saldos en contra que debe liquidar antes de poderle reintegar dinero
				</font>			
				<table border="1" width="75%" bordercolor="333399">
					<tr>
						<td align="center"><strong><font color="0000FF">
							NumeroAnticipo
						</font></strong>
						</td>				
						<td align="center"><strong><font color="0000FF">
							Saldo a Liquidar</font></strong>
						</td>
						
					</tr>
					<cfoutput>
					<tr>
						<td>#rsAnticipos.GEAnumero#</td>
						<td>#rsAnticipos.SaldoSinLiquidar#</td>
					
					</tr>
					</cfoutput>
				</table>	
				<cfabort>		
			<cfelse>
			
				<!---Verificación de Presupuesto--->
				<cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="ApruebaImporte" returnvariable="LvarImporte">
					<cfinvokeargument name="CCHid"				value="#rsCajaChica.CCHid#">
					<cfinvokeargument name="CCHTtipo" 			value="GASTOS" > 
					<cfinvokeargument name="ImporteA"      		value="#rsLiquidacion.GELtotalAnticipos#">
					<cfinvokeargument name="ImporteL"      		value="#rsLiquidacion.GELtotalGastos#">  
					<cfinvokeargument name="Id_liquidacion"  	value="#rsLiquidacion.GELid#">
					<cfinvokeargument name="ImporteD"  	        value="#rsLiquidacion.GELtotalDepositos#"> 
				</cfinvoke>
				<!---Verificación de Presupuesto--->
				<cfif LvarImporte>
						<cfinvoke component="sif.tesoreria.Componentes.TESCajaChicaPresupuesto" method="PresupuestoLiquidacionCCh">
							<cfinvokeargument name="GELid" value="#rsLiquidacion.GELid#">
						</cfinvoke>
	
						<!---Inserta en transacciones Aplicadas.--->
						<cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="TAplicadas">
							<cfinvokeargument name="CCHid"    				value="#rsCajaChica.CCHid#"/>
							<cfinvokeargument name="Mcodigo" 				value="#rsLiquidacion.Mcodigo#"/>
							<cfinvokeargument name="CCHTdescripcion"    	value="#rsLiquidacion.GELdescripcion#"/>
							<cfinvokeargument name="CCHTestado"		    	value="APLICADO"/>
							<cfinvokeargument name="CCHTmonto"   			value="#rsLiquidacion.GELtotalGastos#"/>
							<cfinvokeargument name="CCHTidCustodio"    		value="#rsCajaChica.CCHresponsable#"/>
							<cfinvokeargument name="Sufijo" 				value="GASTO"/>
							<cfinvokeargument name="CCHTid"    				value="#LvarCCHTid#"/>
							<cfinvokeargument name="CCHTtipo"		    	value="GASTO"/>
						</cfinvoke>	
						
						<!---Actualiza el estado de las transacciones En proceso He inserta en seguimiento--->
						<cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="CambiaEstadoTP">
							<cfinvokeargument name="CCHTid"    			value="#LvarCCHTid#"/>
							<cfinvokeargument name="CCHTestado" 		value="POR CONFIRMAR"/>
							<cfinvokeargument name="CCHtipo"    		value="GASTO"/>
							<cfinvokeargument name="CCHTrelacionada"    value="#rsLiquidacion.GELid#"/>
							<cfinvokeargument name="CCHTtrelacionada"   value="GASTO"/>
						</cfinvoke>	
						<!--- Actulización del estado del Anticipo--->
						<cfquery name="rsActualiza" datasource="#session.DSN#">
							update GEliquidacion set 
									GELestado =2, 
									CCHid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CCHid#">
							where GELid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLiquidacion.GELid#">
							and Ecodigo=#session.Ecodigo#
						</cfquery>
						
						<!--- Crea la transaccion del Custodio--->
						<cfinvoke component="sif.tesoreria.Componentes.TESCustodio" method="TranCustodioP" returnvariable="LvarCCHTCid">
							<cfinvokeargument name="CCHTCestado"        value="POR CONFIRMAR"/>
							<cfinvokeargument name="CCHTtipo"       	value="#LvarTipo#"/>
							<cfinvokeargument name="CCHTCconfirmador"	value="#session.usucodigo#"/>
							<cfinvokeargument name="CCHTCrelacionada"   value="#rsLiquidacion.GELid#"/>
							<cfinvokeargument name="CCHTid"         	value="#LvarCCHTid#"/>
						</cfinvoke>  
												
					<!---Verificación de Presupuesto--->
					<cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="CreaReintegro" returnvariable="LvarImporte">
					<cfinvokeargument name="CCHid"				value="#rsCajaChica.CCHid#">
					<cfinvokeargument name="CCHTtipo" 			value="GASTOS" > 
					<cfinvokeargument name="ImporteA"      		value="#rsLiquidacion.GELtotalAnticipos#">
					<cfinvokeargument name="ImporteL"      		value="#rsLiquidacion.GELtotalGastos#">  
					<cfinvokeargument name="Id_liquidacion"  	value="#rsLiquidacion.GELid#">
					<cfinvokeargument name="ImporteD"  	        value="#rsLiquidacion.GELtotalDepositos#"> 
				</cfinvoke>
				
				<cfelse>
					<cf_errorCode	code = "50726" msg = "No hay disponible en Caja.">
				</cfif>
			</cfif>
		<cfelse>
			
		
				<!---Verificación de Presupuesto en Caja--->
				<cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="ApruebaImporte" returnvariable="LvarImporte">
					<cfinvokeargument name="CCHid"			   	value="#rsCajaChica.CCHid#">
					<cfinvokeargument name="CCHTtipo" 		   	value="GASTOS" > 
					<cfinvokeargument name="ImporteA"      		value="#rsLiquidacion.GELtotalAnticipos#">
					<cfinvokeargument name="ImporteL"      		value="#rsLiquidacion.GELtotalGastos#">  
					<cfinvokeargument name="Id_liquidacion"    	value="#rsLiquidacion.GELid#">
					<cfinvokeargument name="ImporteD"  	         value="#rsLiquidacion.GELtotalDevoluciones#"> 
				</cfinvoke>
			<cfif LvarImporte>
				<!--- Desreserva el Anticipo--->
				<cfinvoke component="sif.tesoreria.Componentes.TESCajaChicaPresupuesto" method="PresupuestoLiquidacionCCh">
					<cfinvokeargument name="GELid" value="#rsLiquidacion.GELid#">
				</cfinvoke>
				
				<!---Inserta en transacciones Aplicadas.--->
					<cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="TAplicadas">
						<cfinvokeargument name="CCHid"    				value="#rsCajaChica.CCHid#"/>
						<cfinvokeargument name="Mcodigo" 				value="#rsLiquidacion.Mcodigo#"/>
						<cfinvokeargument name="CCHTdescripcion"    	value="#rsLiquidacion.GELdescripcion#"/>
						<cfinvokeargument name="CCHTestado"		    	value="APLICADO"/>
						<cfinvokeargument name="CCHTmonto"   			value="#rsLiquidacion.GELtotalGastos#"/>
						<cfinvokeargument name="CCHTidCustodio"    	value="#rsCajaChica.CCHresponsable#"/>
						<cfinvokeargument name="Sufijo" 				   value="GASTO"/>
						<cfinvokeargument name="CCHTid"    				value="#LvarCCHTid#"/>
						<cfinvokeargument name="CCHTtipo"		    	value="GASTO"/>
					</cfinvoke>	
				<!---Actualiza el estado de las transacciones En proceso He inserta en seguimiento--->
				<cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="CambiaEstadoTP">
					<cfinvokeargument name="CCHTid"    			value="#LvarCCHTid#"/>
					<cfinvokeargument name="CCHTestado" 		value="POR CONFIRMAR"/>
					<cfinvokeargument name="CCHtipo"    		value="GASTO"/>
					<cfinvokeargument name="CCHTrelacionada"    value="#rsLiquidacion.GELid#"/>
					<cfinvokeargument name="CCHTtrelacionada"   value="GASTO"/>
				</cfinvoke>	
				<!--- Actulización del estado del Anticipo--->
				<cfquery name="rsActualiza" datasource="#session.DSN#">
						update GEliquidacion set 
								GELestado =2, 
								CCHid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CCHid#">
						where GELid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLiquidacion.GELid#">
						and Ecodigo=#session.Ecodigo#
				</cfquery>
				
				<!--- Crea la transaccion del Custodio--->
				<cfinvoke component="sif.tesoreria.Componentes.TESCustodio" method="TranCustodioP" returnvariable="LvarCCHTCid">
					<cfinvokeargument name="CCHTCestado"        value="POR CONFIRMAR"/>
					<cfinvokeargument name="CCHTtipo"       	value="#LvarTipo#"/>
					<cfinvokeargument name="CCHTCconfirmador"	value="#session.usucodigo#"/>
					<cfinvokeargument name="CCHTCrelacionada"   value="#rsLiquidacion.GELid#"/>
					<cfinvokeargument name="CCHTid"         	value="#LvarCCHTid#"/>
				</cfinvoke>  
				
					<!---Verificación de Presupuesto--->
					<cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="CreaReintegro" returnvariable="LvarImporte">
					<cfinvokeargument name="CCHid"				value="#rsCajaChica.CCHid#">
					<cfinvokeargument name="CCHTtipo" 			value="GASTOS" > 
					<cfinvokeargument name="ImporteA"      		value="#rsLiquidacion.GELtotalAnticipos#">
					<cfinvokeargument name="ImporteL"      		value="#rsLiquidacion.GELtotalGastos#">  
					<cfinvokeargument name="Id_liquidacion"  	value="#rsLiquidacion.GELid#">
					<cfinvokeargument name="ImporteD"  	        value="#rsLiquidacion.GELtotalDepositos#"> 
				</cfinvoke>
			<cfelse>
				<cf_errorCode	code = "50726" msg = "No hay disponible en Caja.">
			</cfif>
	</cfif>
	
</cffunction>

<!--- Funcion que Aprueba las Liquidaciones que van por Tesoreria--->
<cffunction name="ALTESORERIA" access="public">

	<cfargument name="GELid" type="numeric" required="yes">
	
	<!---Aprueba por Tesoreria--->
	<cfquery name="Busqueda" datasource="#session.dsn#">
		select GELid,GELtotalGastos,CCHTid,CFid,TESBid,Mcodigo,Ecodigo,GELreembolso from GEliquidacion
		where GELid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GELid#">
	</cfquery>
	<!--- Valida El Usuario Aprobador--->
	<cfquery name="rsSPaprobador" datasource="#session.dsn#">
		Select TESUSPmontoMax, TESUSPcambiarTES
		from TESusuarioSP
		where CFid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Busqueda.CFid#">
		and Usucodigo	= #session.Usucodigo#
		and TESUSPaprobador = 1
	</cfquery>
	<cfset LvarEsAprobadorSP = (rsSPaprobador.RecordCount GT 0)>
	
	<cfif not LvarEsAprobadorSP>
		<cfabort showerror="El Usuario no es Aprobador">	
	</cfif>
	<!--- FIN Valida El Usuario Aprobador--->
	
	<cfif Busqueda.GELreembolso GT 0>
	<cfquery name="rsAnticipos" datasource="#session.dsn#">
			select a.GEAid,a.GEAnumero, sum(GEADmonto - GEADutilizado - TESDPaprobadopendiente - coalesce(GELAtotal,0)) as SaldoSinLiquidar
				from GEanticipo a
					inner join GEanticipoDet b
						left join GEliquidacionAnts c 
							inner join GEliquidacion e
							on e.GELid  = c.GELid
							and e.GELestado  in (0,1)
						on c.GELid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GELid#">
						and c.GEADid = b.GEADid
					on b.GEAid = a.GEAid
				where a.TESBid            = #Busqueda.TESBid#
				  and a.GEAestado      = 4  -- DEBE SER 4=Pagado
				  and a.Mcodigo              = #Busqueda.Mcodigo#
				  and a.Ecodigo               = #Busqueda.Ecodigo#
			group by a.GEAid,a.GEAnumero
			having sum(GEADmonto - GEADutilizado - TESDPaprobadopendiente - coalesce(GELAtotal,0)) > 0
		</cfquery>
		<cfif rsAnticipos.recordcount gt 0>
		
			<font color="FF0000" size="+2">
			El empleado tiene Anticipos con saldos en contra que debe liquidar antes de poderle reintegar dinero
			</font>			
			<table border="1" width="75%" bordercolor="333399">
				<tr>
					<td align="center"><strong><font color="0000FF">
						NumeroAnticipo
					</font></strong>
					</td>				
					<td align="center"><strong><font color="0000FF">
						Saldo a Liquidar</font></strong>
					</td>
					
				</tr>
				<cfoutput>
				<tr>
					<td>#rsAnticipos.GEAnumero#</td>
					<td>#rsAnticipos.SaldoSinLiquidar#</td>
				
				</tr>
				</cfoutput>
			</table>	
			<cfabort>		
		<cfelse>
			<!---CreaSP--->
			<!---Actualiza lineas--->
			<cfset lineax = 1>
			<cfquery name="rsSQLA" datasource="#session.DSN#">
				select a.GELid,a.GEADid from GEliquidacionAnts  a
				inner join GEliquidacion l
				on  a.GELid=l.GELid	
				where a.GELid=<cfqueryparam value="#Arguments.GELid#" cfsqltype="cf_sql_numeric">
			</cfquery>
			
			<cfloop query="rsSQLA">
				<cfquery name="Cualquier" datasource="#session.dsn#">
					update GEliquidacionAnts 
					set Linea=#lineax#
					where GEADid=#rsSQLA.GEADid#
					and GELid=<cfqueryparam value="#Arguments.GELid#" cfsqltype="cf_sql_numeric">
				</cfquery>
				<cfset lineax= #lineax#+1>
			</cfloop>
			
			<cfquery name="rsSQLG" datasource="#session.dsn#">
				select b.GELid,b.GELGid from GEliquidacionGasto  b
				inner join GEliquidacion l
				on b.GELid=l.GELid	
				where l.GELid=<cfqueryparam value="#Arguments.GELid#" cfsqltype="cf_sql_numeric">
			</cfquery>
			
			<cfloop query="rsSQLG">
				<cfquery name="updateGastos" datasource="#session.dsn#">
					update GEliquidacionGasto set Linea=#lineax#
					where GELGid=#rsSQLG.GELGid#
					and GELid=<cfqueryparam value="#Arguments.GELid#" cfsqltype="cf_sql_numeric">
				</cfquery>
				<cfset lineax= #lineax#+1>
			</cfloop>
			
			<cfquery name="rsSQLD" datasource="#session.dsn#">
				select b.GELid,b.GELDid from GEliquidacionDeps b
				inner join GEliquidacion l
				on b.GELid=l.GELid	
				where l.GELid=<cfqueryparam value="#Arguments.GELid#" cfsqltype="cf_sql_numeric">
			</cfquery>	
			
			<cfloop query="rsSQLD">
				<cfquery name="updateDeposito" datasource="#session.dsn#">
					update GEliquidacionDeps set Linea=#lineax#
					where GELDid=#rsSQLD.GELDid#
					and GELid=<cfqueryparam value="#Arguments.GELid#" cfsqltype="cf_sql_numeric">
				</cfquery>
				<cfset lineax= #lineax#+1>
			</cfloop><!---*****--->
			
			
				<cfquery datasource="#session.dsn#" name="rsForm">
					select
					GELtipo,TESBid,GELfecha,Mcodigo,CFid,GELdescripcion,GELtipoCambio,GELnumero
					,GELreembolso
					from GEliquidacion a	
					where a.Ecodigo	= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and a.GELid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GELid#">
					and a.GELtipo	= 7
				</cfquery>
					
				<cfset valorf=0>
				<cfinvoke method="sbAprobarLiquidacionConSP" returnVariable="rs">
					<cfinvokeargument name="TESBid" 		 	value="#rsForm.TESBid#">
					<cfinvokeargument name="GELfecha" 	 		value="#rsForm.GELfecha#">
					<cfinvokeargument name="Mcodigo" 			value="#rsForm.Mcodigo#"> 	
					<cfinvokeargument name="CFid" 				value="#rsForm.CFid#">
					<cfinvokeargument name="GELreembolso" 		value="#rsForm.GELreembolso#">
					<cfinvokeargument name="GELtipo" 			value="#rsForm.GELtipo#">  
					<cfinvokeargument name="GELdescripcion" 	value="#rsForm.GELdescripcion#"> 
					<cfinvokeargument name="GELtipoCambio"		value="#rsForm.GELtipoCambio#">
					<cfinvokeargument name="GELnumero"			value="#rsForm.GELnumero#">
					<cfinvokeargument name="GELid"  	 		value="#Arguments.GELid#"> 
					<cfinvokeargument name="LvarSigno"			value="#valorf#"> 
				</cfinvoke>
				
				<cfquery datasource="#session.dsn#" name="rsUpdate">
					Update  GEliquidacion 
					set GELestado=<cfqueryparam cfsqltype="cf_sql_numeric" value="2">,
					TESSPid=#rs#
					where GELid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GELid#">		
				</cfquery>				
			
	
		</cfif>
	
	<cfelse>
		<!---Sin SP--->
		<!---Actualiza lineas--->
		<cfquery name="rsGastos" datasource="#session.DSN#">
			select 
				e.GELid,
				e.GELnumero,
				e.GELtotalGastos,
				c.GEADmonto - (c.GEADutilizado) as saldo,
				e.GELtotalDepositos,
				e.GELtotalAnticipos,
				a.GELAtotal, 
				c.GEADid,
				c.GEADutilizado, 
				c.TESDPaprobadopendiente,
				c.GEADutilizado + a.GELAtotal   as montoUtilizado,
				c.TESDPaprobadopendiente - a.GELAtotal   as montoaprobado
			from 
				GEanticipoDet c,GEliquidacionAnts a,GEliquidacion e 		
			where 
				e.GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GELid#" null="#Len(Arguments.GELid) Is 0#">
				and a.GELid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GELid#" null="#Len(Arguments.GELid) Is 0#">
				and c.GEADid=a.GEADid
		</cfquery>	
		
	<!--- Operaciones para Aprobar--->
		<cfset mensaje="error">
		<cfset montoGasto=#rsGastos.GELtotalGastos#>
		<cfset montoDepositos=#rsGastos.GELtotalDepositos#>
		<cfset montoAnticipos=#rsGastos.GELtotalAnticipos#>
			
		<cfif montoGasto eq "">
			<cfset montoGasto=0>
		</cfif>
		
		<cfif montoDepositos eq "">
			<cfset montoDepositos=0>
		</cfif>
		
		<cfif montoAnticipos eq "">
			<cfset montoAnticipos=0>
		</cfif>
		<!--- verifico si los gastos + los depositos son mayores a los anticipos--->	
		<cfset resultaG= #montoGasto# + #montoDepositos#>
		<cfset resultaFinal=0>
		<cfset resultaFinal= #resultaG#-#montoAnticipos#> 
		
		
		<cfif resultaG EQ montoAnticipos>
			<cfquery name="ActualizaEncabe" datasource="#session.dsn#">
				update GEliquidacionGasto 
						set  GELGestado = 4
				where GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GELid#" null="#Len(Arguments.GELid) Is 0#">
			</cfquery>
			<cfquery name="ActualizaEncabe" datasource="#session.dsn#">
				update GEliquidacion
						set GELestado= 4
				where GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GELid#" null="#Len(Arguments.GELid) Is 0#">	
			</cfquery>
				
		</cfif>	
				
		<cfset lineax = 1>
	
		<cfquery name="rsSQLA" datasource="#session.DSN#">
			select a.GELid,a.GEADid from GEliquidacionAnts  a
			inner join GEliquidacion l
			on  a.GELid=l.GELid	
			where a.GELid=<cfqueryparam value="#Arguments.GELid#" cfsqltype="cf_sql_numeric">
		</cfquery>
				
		<cfloop query="rsSQLA">
			<cfquery name="Cualquier" datasource="#session.dsn#">
				update GEliquidacionAnts 
				set Linea=#lineax#
				where GEADid=#rsSQLA.GEADid#
				and GELid=<cfqueryparam value="#Arguments.GELid#" cfsqltype="cf_sql_numeric">
			</cfquery>
			<cfset lineax= #lineax#+1>
		</cfloop>
	
		<cfquery name="rsSQLG" datasource="#session.dsn#">
			select b.GELid,b.GELGid from GEliquidacionGasto  b
			inner join GEliquidacion l
			on b.GELid=l.GELid	
			where l.GELid=<cfqueryparam value="#Arguments.GELid#" cfsqltype="cf_sql_numeric">
		</cfquery>
					
		<cfloop query="rsSQLG">
			<cfquery name="updateGastos" datasource="#session.dsn#">
				update GEliquidacionGasto set Linea=#lineax#
				where GELGid=#rsSQLG.GELGid#
				and GELid=<cfqueryparam value="#Arguments.GELid#" cfsqltype="cf_sql_numeric">
			</cfquery>
			<cfset lineax= #lineax#+1>
		</cfloop>
					
		<cfquery name="rsSQLD" datasource="#session.dsn#">
			select b.GELid,b.GELDid from GEliquidacionDeps b
			inner join GEliquidacion l
			on b.GELid=l.GELid	
			where l.GELid=<cfqueryparam value="#Arguments.GELid#" cfsqltype="cf_sql_numeric">
		</cfquery>	
					
		<cfloop query="rsSQLD">
			<cfquery name="updateDeposito" datasource="#session.dsn#">
				update GEliquidacionDeps set Linea=#lineax#
				where GELDid=#rsSQLD.GELDid#
				and GELid=<cfqueryparam value="#Arguments.GELid#" cfsqltype="cf_sql_numeric">
			</cfquery>
			<cfset lineax= #lineax#+1>
		</cfloop><!---*****--->
		<cfinvoke method="sbAprobarLiquidacionSinSP" >
			<cfinvokeargument name="GELid" value="#Arguments.GELid#"> 
		</cfinvoke>
	</cfif>
	
	<!---Actualiza el estado de las transacciones En proceso He inserta en seguimiento--->
	<cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="CambiaEstadoTP">
		<cfinvokeargument name="CCHTid"    			value="#Busqueda.CCHTid#"/>
		<cfinvokeargument name="CCHTestado" 		value="EN APROBACION TES"/>
		<cfinvokeargument name="CCHtipo"    		value="GASTO"/>
		<cfinvokeargument name="CCHTrelacionada"    value="#Busqueda.GELid#"/>
		<cfinvokeargument name="CCHTtrelacionada"   value="GASTO"/>
	</cfinvoke>
</cffunction>





<!---                               FUNCIONES DE ANTICIPOS A EMPLEADO                                                    --->
<!---GENERA SOLICITUD DE PAGO DE ANTICIPOS--->
<cffunction name="AprobarSolicitudAnticipo" returntype="numeric" access="public">
	<cfargument name="GEAid"  			type="numeric"  required="yes"> 

	<cfquery datasource="#session.dsn#" name="rsForm">
		select
			a.GEAid,
			a.GEAtipo,
			a.TESBid,
			a.GEAfechaPagar,
			a.Mcodigo,
			a.GEAtotalOri,
			a.GEAnumero,
			a.CFid,
			a.CFcuenta,
			a.GEAdescripcion,
			a.GEAdesde,a.GEAhasta,
			a.GEAmanual,
			b.CFcuenta  as CFCU,
			b.GEADid
		from GEanticipo a
			left join GEanticipoDet b
				on a.GEAid=b.GEAid	
		where a.Ecodigo		= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.GEAid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GEAid#">
		and a.GEAtipo		= 6
	</cfquery>
	<cfquery name="rsDetalle" datasource="#session.dsn#">
		select CFcuenta,GEADid from GEanticipoDet
		where GEAid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GEAid#">
	</cfquery>
	<cfinvoke method="GeneraSPAnticipo" returnVariable="LvarTESSPid">
		<cfinvokeargument name="GEAtipo" 			value="#rsForm.GEAtipo#">
		<cfinvokeargument name="TESBid" 			value="#rsForm.TESBid#"> 
		<cfinvokeargument name="GEAfechaPagar" 		value="#rsForm.GEAfechaPagar#"> 
		<cfinvokeargument name="Mcodigo" 			value="#rsForm.Mcodigo#"> 			
		<cfinvokeargument name="GEAtotalOri" 		value="#rsForm.GEAtotalOri#"> 		
		<cfinvokeargument name="CFid" 				value="#rsForm.CFid#"> 
		<cfinvokeargument name="GEAdescripcion" 	value="#rsForm.GEAdescripcion#"> 
		<cfinvokeargument name="GEAdesde"  			value="#LSDateFormat(rsForm.GEAdesde,'dd/mm/yyyy')#"> 
		<cfinvokeargument name="GEAhasta"  			value="#LSDateFormat(rsForm.GEAhasta,'dd/mm/yyyy')#"> 
		<cfinvokeargument name="GEAmanual"  		value="#rsForm.GEAmanual#">
		<cfinvokeargument name="GEAnumero"  		value="#rsForm.GEAnumero#">
		<cfinvokeargument name="ConTransaccion" 	value="false"> 
		<cfinvokeargument name="GEAid"  			value="#Arguments.GEAid#">
		<cfinvokeargument name="CFcuenta"			value="#rsForm.CFcuenta#"> 
	</cfinvoke>
	<cfquery datasource="#session.dsn#" name="rsUpdate">
		Update  GEanticipo 
		   set 	GEAestado=1,
				TESSPid=#LvarTESSPid#,
				GEAtipoP=0
		 where 	GEAid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GEAid#">
	</cfquery>
	
	<cfinvoke component="sif.tesoreria.Componentes.TESaplicacion" method="sbAprobarSP">
		<cfinvokeargument name="SPid" value="#LvarTESSPid#">
		<cfinvokeargument name="fechaPagoDMY" value="#LSDateFormat(rsForm.GEAfechaPagar,'dd/mm/yyyy')#">
		<cfinvokeargument name="generarOP" value="false">
		<cfinvokeargument name="NAP" value="-1">
		
		<cfinvokeargument name="PRES_Origen" 		value="TEGE">
		<cfinvokeargument name="PRES_Documento" 	value="#rsForm.GEAnumero#">
		<cfinvokeargument name="PRES_Referencia" 	value="GE.Ant,APROBACION">
	</cfinvoke>

	<cfquery name="rsSPNAP" datasource="#session.dsn#">
		select TESSPid,NAP
		from TESsolicitudPago
		where TESSPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarTESSPid#">
	</cfquery>

	<cfquery datasource="#session.dsn#" name="NumNAP">
		update GEanticipo 
		set GEAestado=2 ,
			CPNAPnum= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSPNAP.NAP#">
		where 
		GEAid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GEAid#">
	</cfquery>
	<cfreturn LvarTESSPid>
</cffunction>

<cffunction name="GeneraSPAnticipo" returntype="numeric" access="public">
	<cfargument name="GEAtipo" 			type="numeric" 	required="yes"> 
	<cfargument name="TESBid"    		type="numeric" 	required="yes"> 
	<cfargument name="GEAfechaPagar" 	type="date"    	required="yes"> 
	<cfargument name="Mcodigo" 	 		type="numeric" 	required="yes"> 
	<cfargument name="GEAtotalOri" 		type="numeric"  required="yes"> 		
	<cfargument name="CFid"   			type="numeric" 	required="yes"> 
	<cfargument name="CFcuenta"  		type="any"		required="yes">
	<cfargument name="GEAnumero"  		type="numeric" 	required="yes">
	<cfargument name="GEAdescripcion"   type="string"  	required="no" default=""> 
	<cfargument name="Instrucciones" 	type="string"  	required="no" default=""> 
	<cfargument name="CuentaBanco" 		type="string"  	required="no" default=""> 
	<cfargument name="fDesde" 	 		type="string"  	required="no" default=""> 
	<cfargument name="fHasta" 		  	type="string"  	required="no" default=""> 
	<cfargument name="GEAmanual"		type="numeric" 	required="no" default="1"> 
	<cfargument name="ConTransaccion" 	type="boolean" 	required="no" default="true">
	<cfargument name="GEAid"  			type="numeric"  required="yes"> 
	<cfinclude template="../Solicitudes/TESid_Ecodigo.cfm">
<!---OBTENER EL TESSPnumero--->	
<cflock type="exclusive" name="TesSolPago#session.Ecodigo#" timeout="3">		
    <cfquery name="Solicitud" datasource="#session.dsn#">
        select coalesce(max(TESSPnumero),0) + 1 as id
        from TESsolicitudPago
        where EcodigoOri=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
    </cfquery>
        
    <!---ENVIO DE LA SOLICITUD A QUE SEA APROBADA EN ESTADO 1--->			
    <cfquery datasource="#session.dsn#" name="insSolApr">
        insert into TESsolicitudPago(
            TESid,
            CFid,
            EcodigoOri,
            TESSPnumero,
            TESSPtipoDocumento, 
            TESSPestado, 
            TESBid,
            TESSPfechaPagar, 
            McodigoOri, 
            TESSPtotalPagarOri, 
            TESSPfechaSolicitud,
            UsucodigoSolicitud, 
            BMUsucodigo,
            TESOPinstruccion,
            CBid
            <cfif #GEAmanual# NEQ "">
            ,TESSPtipoCambioOriManual
            </cfif>
            )
        values (
            <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Tesoreria.TESid#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#CFid#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#Solicitud.id#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#GEAtipo#">, 
            <cfqueryparam cfsqltype="cf_sql_integer" value="1">,  
            <cfqueryparam cfsqltype="cf_sql_numeric" value="#TESBid#">,
            <cfqueryparam value="#LSparseDateTime(GEAfechaPagar)#" cfsqltype="cf_sql_timestamp">,
            <cfqueryparam cfsqltype="cf_sql_numeric" value="#Mcodigo#">,
            <cfqueryparam cfsqltype="cf_sql_money" value="#GEAtotalOri#">,
            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
            <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
            <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#rtrim(Instrucciones)#"	null="#rtrim(Instrucciones) EQ ""#">,
            <cfqueryparam cfsqltype="cf_sql_numeric" value="#rtrim(CFcuenta)#"	null="#rtrim(CFcuenta) EQ ""#">
        <cfif #GEAmanual# NEQ "">
        ,<cfqueryparam cfsqltype="cf_sql_money" value="#GEAmanual#">
        </cfif>
        )
    	<cf_dbidentity1 datasource="#session.DSN#" name="insSolApr" verificar_transaccion="false">
	</cfquery>
    <cf_dbidentity2 datasource="#session.DSN#" name="insSolApr" returnvariable="LvarTESSPid" verificar_transaccion="false">
</cflock>				
<!---OBTENCION DEL TESSPid DE LA NUEVA SOLICITUD, PARA REFERENCIAR EL DETALLE--->	
		<cfquery name="resulset" datasource="#session.dsn#">
			select * from TESsolicitudPago where TESSPnumero=#Solicitud.id#
		</cfquery>
<!---SELECCION DEL CODIGO DE LA OFICINA--->
		<cfquery name="CFuncional" datasource="#session.dsn#">
			select Ocodigo from CFuncional where CFid=#CFid#
		</cfquery>
<!---SELECCIONAR EL ISO DE LA MONEDA--->
		<cfquery name="sigMoneda" datasource="#session.dsn#">
			select Miso4217
			from Monedas
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Mcodigo#">
		</cfquery>
<!--- Seleccion la Oficina del Centro Funcional Asociado al Anticipo--->
		<cfquery name="rsAnticipos" datasource="#session.dsn#">
			select  a.CFid, cf.Ocodigo
			from GEanticipo a
				inner join CFuncional cf
				   on cf.CFid = a.CFid
			where GEAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.GEAid#" null="#Len(arguments.GEAid) Is 0#">
		</cfquery>
<!--- Selecciona El concepto de Pagos a Terceros--->
		<cfquery name="rsCPT" datasource="#session.dsn#">
			select min (TESRPTCid) as TESRPTCid
			from TESRPTconcepto
			where CEcodigo= #session.CEcodigo#
			and TESRPTCdevoluciones=0			
		</cfquery>
		<cfset referencia='Anticipo a Empleado'>
<!--- DETALLE DE LA SOLICITUD DE PAGO EN ESTADO 1--->
	
	<cfquery datasource="#session.dsn#">
		insert into TESdetallePago 
			(
				TESDPestado,
				EcodigoOri,
				TESid,
				TESSPid,
				TESDPtipoDocumento,
				TESDPidDocumento,
				TESDPmoduloOri,
				TESDPdocumentoOri,
				TESDPreferenciaOri,
				TESDPfechaVencimiento,
				TESDPfechaSolicitada,
				TESDPfechaAprobada,
				Miso4217Ori,
				TESDPmontoVencimientoOri,
				TESDPmontoSolicitadoOri,
				TESDPmontoAprobadoOri,
				TESDPdescripcion,
				CFcuentaDB,
				OcodigoOri,
				TESRPTCid,
				CFid,
				TESSPlinea,
				TESDPtipoCambioSP,
				CFcuentaDB_SP
				)			
			select		1, 
						a.Ecodigo, 
						<cfqueryparam cfsqltype="cf_sql_numeric"   	value="#session.Tesoreria.TESid#">,
						<cfqueryparam cfsqltype="cf_sql_numeric"   	value="#LvarTESSPid#">,
						a.GEAtipo,
						a.GEAid,
						'TEGE',
						<cf_dbfunction name="to_char" args="a.GEAnumero">,
						<cfqueryparam cfsqltype="cf_sql_varchar"   	value="#referencia#" >,
						a.GEAfechaPagar,
						a.GEAfechaPagar,
						a.GEAfechaPagar,
						<cfqueryparam cfsqltype="cf_sql_char" 	   	value="#sigMoneda.Miso4217#" >,
						b.GEADmonto,
						b.GEADmonto,
						b.GEADmonto,
					<cfif #fDesde# NEQ "" AND #fHasta# NEQ "">	
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#rtrim(GEAdescripcion)# (#fDesde# - #fHasta#) "null="#rtrim(GEAdescripcion) EQ ""#">,
					<cfelse>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#rtrim(GEAdescripcion)#" null="#rtrim(GEAdescripcion) EQ ""#">,
					</cfif>
						a.CFcuenta,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAnticipos.Ocodigo#">,
						#rsCPT.TESRPTCid#,
						a.CFid,
						b.Linea,
						a.GEAmanual,
						b.CFcuenta as CuentaDeta
		 from GEanticipo a
			inner join GEanticipoDet b
			on a.GEAid=b.GEAid	
		where	a.GEAid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.GEAid#">
		and 	a.Ecodigo		= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.GEAtipo		= 6
	</cfquery>
	<cfreturn LvarTESSPid>
	
</cffunction>
	
<!---Rechaza una solicitud--->

<cffunction name="sbRechazarAnticipo" access="public">
	<cfargument name="GEAid" 	 			type="numeric" required="yes"> 
	<cfargument name="TESSPmsgRechazo"    	type="string"  required="yes">
		<cfquery datasource="#session.dsn#">
			update GEanticipo 
			set GEAestado  = 3				  
			 where GEAid 	 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.GEAid#">
			  and Ecodigo 	 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		</cfquery>	
</cffunction>

<!---                                            LIQUIDACIONES                                                       --->
<!---                                              Crea SP                                                           --->

<!---Aprobar Liquidaciones que crean Solicitud de pago--->

<cffunction name="sbAprobarLiquidacionConSP" returntype="numeric" access="public">
	<cfargument name="TESBid"  			 		type="numeric" 	required="yes"> 
	<cfargument name="GELfecha" 	 			type="date" 	required="yes"> 
	<cfargument name="Mcodigo" 					type="numeric" 	required="yes">  	
	<cfargument name="CFid" 					type="numeric" 	required="yes">
	<cfargument name="GELreembolso"   			type="any" 		required="yes">
	<cfargument name="GELtipo"					type="numeric" 	required="yes">
	<cfargument name="GELdescripcion" 	    	type="string" 	required="yes"> 
	<cfargument name="GELtipoCambio"			type="numeric" 	required="yes"> 
	<cfargument name="GELnumero"				type="numeric" 	required="yes"> 
	<cfargument name="GELid"  	 				type="numeric" 	required="yes">
	<cfargument name="LvarSigno"				type="numeric"  required="no">
	<cfdump var="#arguments#">
	<cfinclude template="../Solicitudes/TESid_Ecodigo.cfm">
    <cflock type="exclusive" name="TesSolPago#session.Ecodigo#" timeout="3">
		<!---OBTENER EL TESSPnumero(ultimo numero de solicitud) --->			
            <cfquery name="SolicitudPago" datasource="#session.dsn#">
                select coalesce(max(TESSPnumero),0) + 1 as numero
                from TESsolicitudPago
                where EcodigoOri=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
            </cfquery>
        <!---Obtener la relacion entre la tabla de Anticipo y la de Liquidacion--->
            <cfquery name="rsOcodigo" datasource="#session.dsn#">
                select a.GELid,a.CFid, cf.Ocodigo
                from GEliquidacion a
                    inner join CFuncional cf
                        on a.CFid = cf.CFid
                where a.GELid=#Arguments.GELid#
            </cfquery>
        <!--- Selecciona El concpeto de Pagos a Terceros--->
            <cfquery name="rsCPT" datasource="#session.dsn#">
                select min (TESRPTCid) as TESRPTCid
                from TESRPTconcepto
                where CEcodigo= #session.CEcodigo#
                and TESRPTCdevoluciones=0			
            </cfquery>
        <!---ENVIO DE LA SOLICITUD A QUE SEA APROBADA EN ESTADO 1--->			
                <cfquery datasource="#session.dsn#" name="insSolApr">
                    insert into TESsolicitudPago(
                        TESid,
                        CFid,
                        EcodigoOri,
                        TESSPnumero,
                        TESSPtipoDocumento, 
                        TESSPestado, 
                        TESBid,
                        TESSPfechaPagar, 
                        McodigoOri, 
                        TESSPtotalPagarOri, 
                        TESSPfechaSolicitud,
                        UsucodigoSolicitud, 
                        BMUsucodigo,
                        TESSPfechaAprobacion,
                        UsucodigoAprobacion,
                        TESSPtipoCambioOriManual
                        )
                    values (
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#CFid#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#SolicitudPago.numero#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#GELtipo#">, 
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="1">,  
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#TESBid#">,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#GELfecha#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#Mcodigo#">,
                        <cfqueryparam cfsqltype="cf_sql_money" value="#GELreembolso#">,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
                        <cfqueryparam cfsqltype="cf_sql_money" value="#GELtipoCambio#">
                    )		
                        <cf_dbidentity1 datasource="#session.DSN#" name="insSolApr" verificar_transaccion="false">
                </cfquery>
					<cf_dbidentity2 datasource="#session.DSN#" name="insSolApr" returnvariable="LvarTESSPid" verificar_transaccion="false">
	</cflock>
<!---SELECCION DEL CODIGO DE LA OFICINA--->
		<cfquery name="CFuncional" datasource="#session.dsn#">
			select Ocodigo from CFuncional where CFid=#Arguments.CFid#
		</cfquery>
<!---SELECCIONAR EL ISO DE LA MONEDA--->
		<cfquery name="sigMoneda" datasource="#session.dsn#">
			select Miso4217
			from Monedas
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Mcodigo#">
		</cfquery>		

<!--- 
	1) Anticipos: CxC y CtaGasto
	2) Gastos Ejecutados
	3) Depositos
 --->
<!---Agregar Detalle Anticipos--->
	<cfquery datasource="#session.dsn#">
		insert into TESdetallePago 
			(
				TESDPestado,
				EcodigoOri,
				TESid,
				TESSPid,
				TESDPtipoDocumento,
				TESDPidDocumento,
				TESDPmoduloOri,
				TESDPdocumentoOri,
				TESDPreferenciaOri,
				TESDPfechaVencimiento,
				TESDPfechaSolicitada,
				TESDPfechaAprobada,
				Miso4217Ori,
				TESDPmontoVencimientoOri,
				TESDPmontoSolicitadoOri,
				TESDPmontoAprobadoOri,
				TESDPdescripcion,
				CFcuentaDB,
				OcodigoOri,
				TESRPTCid,
				CFid,
				TESSPlinea,
				TESDPtipoCambioSP,
				CFcuentaDB_SP,
				NAPref_SP,
				LINref_SP
			)			
			select		1, 
						a.Ecodigo, 
						<cfqueryparam cfsqltype="cf_sql_numeric"   	value="#session.Tesoreria.TESid#">,
						<cfqueryparam cfsqltype="cf_sql_numeric"   	value="#LvarTESSPid#">,
						6,
						a.GEAid,
						'TEGE',
						<cf_dbfunction name="to_char" args="a.GEAnumero">,
						'Anticipo',
						a.GEAfechaPagar,
						a.GEAfechaPagar,
						a.GEAfechaPagar,
						<cfqueryparam cfsqltype="cf_sql_char" 	   	value="#sigMoneda.Miso4217#" >,
						-l.GELAtotal,
						-l.GELAtotal,
						-l.GELAtotal,
						a.GEAdescripcion,
						a.CFcuenta as CxC,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOcodigo.Ocodigo#">,
						#rsCPT.TESRPTCid#,
						a.CFid,
						l.Linea,
						a.GEAmanual,
						b.CFcuenta as CuentaGasto, a.CPNAPnum, -b.Linea	<!--- Desreserva Especial del Gasto reservado en la SP original --->
			 from GEliquidacionAnts l
				inner join GEanticipo a
				on a.GEAid=l.GEAid	
				inner join GEanticipoDet b
				on b.GEADid=l.GEADid	
			where a.Ecodigo		= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and l.GELid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GELid#">
	</cfquery>				
<!---Agregar Detalle Gastos--->
	<cfquery datasource="#session.dsn#">
		insert into TESdetallePago 
			(
				TESDPestado,
				EcodigoOri,
				TESid,
				TESSPid,
				TESDPtipoDocumento,
				TESDPidDocumento,
				TESDPmoduloOri,
				TESDPdocumentoOri,
				TESDPreferenciaOri,
				TESDPfechaVencimiento,
				TESDPfechaSolicitada,
				TESDPfechaAprobada,
				Miso4217Ori,
				TESDPmontoVencimientoOri,
				TESDPmontoSolicitadoOri,
				TESDPmontoAprobadoOri,
				TESDPdescripcion,
				CFcuentaDB,
				OcodigoOri,
				TESRPTCid,
				CFid,
				TESSPlinea,
				TESDPtipoCambioSP
			)
		select  
				<cfqueryparam cfsqltype="cf_sql_integer"   value="2">,
				<cfqueryparam cfsqltype="cf_sql_integer"   value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_integer"   value="#session.Tesoreria.TESid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric"   value="#LvarTESSPid#">,
				7,
				a.GELid,
				'TEGE',
				<cf_dbfunction name="to_char" args="a.GELnumero">,
				'Liquidacion Gasto',
				a.GELfecha,
				a.GELfecha,
				a.GELfecha,
				<cfqueryparam cfsqltype="cf_sql_char" 	   value="#sigMoneda.Miso4217#" >,
				b.GELGtotalOri,
				b.GELGtotalOri,
				b.GELGtotalOri,
				b.GELGdescripcion,
				b.CFcuenta,
				<cfqueryparam cfsqltype="cf_sql_integer"   value="#CFuncional.Ocodigo#">,
				#rsCPT.TESRPTCid#,
				a.CFid,
				b.Linea,
				a.GELtipoCambio
			from GEliquidacion a
				inner join GEliquidacionGasto b
					on a.GELid=b.GELid
					and b.GELid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GELid#">
			where a.Ecodigo		= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and a.GELid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GELid#">
	</cfquery>				
<!---Agregar Detalle Depositos--->
	<cfquery datasource="#session.dsn#">
		insert into TESdetallePago 
			(
				TESDPestado,
				EcodigoOri,
				TESid,
				TESSPid,
				TESDPtipoDocumento,
				TESDPidDocumento,
				TESDPmoduloOri,
				TESDPdocumentoOri,
				TESDPreferenciaOri,
				TESDPfechaVencimiento,
				TESDPfechaSolicitada,
				TESDPfechaAprobada,
				Miso4217Ori,
				TESDPmontoVencimientoOri,
				TESDPmontoSolicitadoOri,
				TESDPmontoAprobadoOri,
				TESDPdescripcion,
				CFcuentaDB,
				OcodigoOri,
				TESRPTCid,
				CFid,
				TESSPlinea,
				TESDPtipoCambioSP
			)
		select  
				<cfqueryparam cfsqltype="cf_sql_integer"   value="2">,
				<cfqueryparam cfsqltype="cf_sql_integer"   value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_integer"   value="#session.Tesoreria.TESid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric"   value="#LvarTESSPid#">,
				7,
				a.GELid,
				'TEGE',
				<cf_dbfunction name="to_char" args="b.GELDreferencia">,
				'Liquidacion Deposito',
				a.GELfecha,
				a.GELfecha,
				a.GELfecha,
				(
					select Miso4217 from Monedas where Mcodigo = b.Mcodigo
				),
				b.GELDtotalOri,
				b.GELDtotalOri,
				b.GELDtotalOri,
				c.CBcodigo,
				(
					select min(CFcuenta) from CFinanciera where Ccuenta = c.Ccuenta
				),
				<cfqueryparam cfsqltype="cf_sql_integer"   value="#CFuncional.Ocodigo#">,
				#rsCPT.TESRPTCid#,
				a.CFid,
				b.Linea,
				b.GELDtipoCambio
			from GEliquidacion a
				inner join GEliquidacionDeps b
					inner join CuentasBancos c
						on c.CBid = b.CBid
					on a.GELid=b.GELid
					and b.GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GELid#">
			where a.Ecodigo		= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and a.GELid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GELid#">
	</cfquery>				
	<cfset varReturn=#LvarTESSPid#>
<!---4)Update AprobadoPendiente<cfset sbAprobarLiquidacionAnticipo()>--->
		<cfquery name="UPmonto" datasource="#session.dsn#">
			update GEanticipoDet
			set TESDPaprobadopendiente = TESDPaprobadopendiente + 
								(
					select x.GELAtotal 
							from GEliquidacionAnts x
							where x.GELid =#arguments.GELid#
							and x.GEADid = GEanticipoDet.GEADid
						)
				where 
						(
						select count(1)
							from GEliquidacionAnts x,GEanticipoDet d
							where x.GELid =#arguments.GELid#
							and x.GEADid = GEanticipoDet.GEADid
						) > 0
		</cfquery>
<!---		<cfquery name="rss1" datasource="#session.dsn#">
			select * from TESsolicitudPago where TESSPid=#LvarTESSPid#
		</cfquery>
		<cfquery name="rss" datasource="#session.dsn#">
			select * from TESdetallePago where TESSPid=#LvarTESSPid#
		</cfquery>
		<cfdump var="#rss1#">
		<cfdump var="#rss#">--->
	<cfinvoke component="sif.tesoreria.Componentes.TESaplicacion" method="sbAprobarSP">
		<cfinvokeargument name="SPid" value="#LvarTESSPid#">
		<cfinvokeargument name="fechaPagoDMY" value="#LSDateFormat(GELfecha,'dd/mm/yyyy')#">
		<cfinvokeargument name="generarOP" value="false">
		<cfinvokeargument name="NAP" value="-1">
		
		<cfinvokeargument name="PRES_Origen" 		value="TEGE">
		<cfinvokeargument name="PRES_Documento" 	value="#GELnumero#">
		<cfinvokeargument name="PRES_Referencia" 	value="GE.Liq,APROBACION">
	</cfinvoke>

	<cfquery name="rsSPNAP" datasource="#session.dsn#">
		select TESSPid,NAP
		from TESsolicitudPago
		where TESSPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarTESSPid#">
	</cfquery>

	<cfquery name="ActualizaDet" datasource="#session.dsn#">
		update GEliquidacionGasto 
		set  GELGestado = 2
		where GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GELid#">
	</cfquery>
	
	<cfquery name="ActualizaEncabe" datasource="#session.dsn#">
		update GEliquidacion
		set GELestado= 2, CPNAPnum = #rsSPNAP.NAP#
		where GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GELid#">	
	</cfquery>
	<cfreturn LvarTESSPid>
</cffunction>
<!---*********************************************************************************************--->



<cffunction name="sbAprobarLiquidacionSinSP" access="public">
	<cfargument name="GELid" type="numeric" required="yes">

	<cfset INTARC= request.intarc>
	<!--- 1) Genera Movimientos Presupuestarios y Contables y Bancos --->
	<cfset this.sbPresupuestoLiquidacionGE(arguments.GELid)>
	<cfset this.sbContabilidadAnticipo(arguments.GELid)>
	<cfset this.sbContabilidadGastos(arguments.GELid)>
	<cfset this.sbContabilidadDepositos(arguments.GELid)>
	<cfset this.sbMovimientoDepositos(arguments.GELid)>

	<cfobject component="sif.Componentes.PRES_Presupuesto" name="LobjControl">	
	
	<!--- 2) Ejecutar el Control de Presupuesto: Crea NAP --->
	<cfquery name="rsPresupuesto" datasource="#session.DSN#" >
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
			rsPresupuesto.ModuloOrigen,
			rsPresupuesto.NumeroDocumento,
			rsPresupuesto.NumeroReferencia,
			rsPresupuesto.FechaDocumento,
			rsPresupuesto.AnoDocumento,
			rsPresupuesto.MesDocumento,
			session.DSN,
			session.Ecodigo
		)
	>
			
	<cfif LvarNAP lt 0>
		<cflocation url="/cfmx/sif/presupuesto/consultas/ConsNRP.cfm?ERROR_NRP=#abs(LvarNAP)#">
	</cfif>
	<cfquery datasource="#session.dsn#" name="NumNAP">
		update GEliquidacion
		set 
			CPNAPnum= <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarNAP#">
		where 
			GELid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GELid#">
	</cfquery>
	<cfset LvarDescripcion='Pago GE: #rsPresupuesto.NumeroReferencia#'>

	<!--- 3) Ejecutar el Genera Asiento --->
	<cfquery name="busOf" datasource="#session.dsn#">
		select Ocodigo from CFuncional where CFid=(select CFid  from GEliquidacion where GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GELid#">)
	</cfquery>

	 <cfinvoke component="sif/componentes/CG_GeneraAsiento" returnvariable="retIDcontable" method="GeneraAsiento"
		Oorigen 		= "TEGE"
		Eperiodo		= "#rsPresupuesto.AnoDocumento#"
		Emes			= "#rsPresupuesto.MesDocumento#"
		Efecha			= "#rsPresupuesto.FechaDocumento#"
		Edescripcion	= "#LvarDescripcion#"
		Edocbase		= "#rsPresupuesto.NumeroDocumento#"
		Ereferencia		= "#rsPresupuesto.NumeroReferencia#"
		usuario 		= "#session.Usucodigo#"
		Ocodigo 		= "#busOf.Ocodigo#"
		Usucodigo 		= "#session.Usucodigo#"
		debug			= "false"
		NAP				= "#LvarNAP#"
	/>

	<!--- 3) Modifica estados de la Liquidación --->
	<cfquery name="UPmonto" datasource="#session.dsn#">
		update GEanticipoDet 
		set GEADutilizado = GEADutilizado + 
				(
				select x.GELAtotal 
					from GEliquidacionAnts x
					where x.GELid =#arguments.GELid#
					and x.GEADid = GEanticipoDet.GEADid
				)
		where 
				(
				select count(1)
					from GEliquidacionAnts x,GEanticipoDet d
					where x.GELid =#arguments.GELid#
					and x.GEADid = GEanticipoDet.GEADid
				) > 0
	</cfquery>

	<cfquery name="ActualizaDet" datasource="#session.dsn#">
		update GEliquidacionGasto 
		set  GELGestado = 4
		where GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GELid#">
	</cfquery>
	
	<cfquery name="ActualizaEncabe" datasource="#session.dsn#">
		update GEliquidacion
		set GELestado= 4
		where GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GELid#">	
	</cfquery>
</cffunction>

<!---                                              No crea SP                                                             --->
<!---
1)-Desreserva anticipo
2)+Ejecuta Cxc
3)+Ejecuta gastos
4)+Ejecuta Deps
5)Aprobar LiquidacionCREA NAP
--->
<cffunction name="sbPresupuestoLiquidacionGE"  access="public">
<cfargument name="GELid" type="numeric" required="yes">
<!--- 
	1) Anticipos:
		1.1) DesReserva Anticipo-CtaGasto (Generado en la aprobación de la SP del Anticipo)
		1.2) Ejecución Anticipo-CtaCxC
	2) Ejecución Gastos
	3) Ejecución Depositos
 --->
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

	<!--- 1) Anticipos --->
		<!--- 1.1) DesReserva Anticipo-CtaGasto --->
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
				LINreferencia
			)
			select 'TEGE', <!--- as ModuloOrigen --->
				<cf_dbfunction name="to_char" args="le.GELnumero" > as TESLnumero, <!--- NumeroDocumento --->
				'LiqGE sin SP', <!--- NumeroReferencia --->
				<cf_dbfunction name="to_date00" args="le.GELfecha" > as GELfecha, <!--- FechaDocumento --->
				#rsPeriodoAuxiliar.Pvalor# as Periodo, <!--- AnoDocumento --->
				#rsMesAuxiliar.Pvalor# as Mes, <!--- as MesDocumento --->
				-x.Linea,
				d.CFcuenta, <!--- GEanticipoDet.CFuenta = Cta Anticipo Gasto --->
				f.Ocodigo, <!--- Oficina --->
				e.Mcodigo, <!--- Mcodigo --->
				-CASE 
					when x.GELAtotal >= 0 AND cm.Ctipo IN ('A','G') 
						then round(abs(x.GELAtotal),2)
							when x.GELAtotal < 0 AND cm.Ctipo NOT IN ('A','G') 
						then round(abs(x.GELAtotal),2)
					else -round(abs(x.GELAtotal),2)
					END as INTMOE, 
					e.GEAmanual, <!--- as TipoCambio --->
				-CASE 
					when x.GELAtotal >= 0 AND cm.Ctipo IN ('A','G') 
						then round(abs(x.GELAtotal) * e.GEAmanual,2)
					when x.GELAtotal < 0 AND cm.Ctipo NOT IN ('A','G') 
						then round(abs(x.GELAtotal) * e.GEAmanual,2)
					else -round(abs(x.GELAtotal) * e.GEAmanual,2)
				END as INTMON, 
				'RC' as Tipo, <!--- as TipoMovimiento --->
				e.CPNAPnum,
				-d.Linea	
			from GEliquidacionAnts x
				inner join GEliquidacion le
				on le.GELid = x.GELid
				inner join GEanticipoDet d
					inner join GEanticipo e
						inner join CFuncional f
						on f.CFid = e.CFid
						inner join CFinanciera cf
							inner join CtasMayor cm
								on cm.Ecodigo = cf.Ecodigo
								and cm.Cmayor = cf.Cmayor
						on cf.CFcuenta = e.CFcuenta
					on e.GEAid = d.GEAid
				on d.GEADid = x.GEADid
			where  x.GELid =<cfqueryparam value="#Arguments.GELid#" cfsqltype="cf_sql_numeric">
		</cfquery>
		<!--- 1.2) -Ejecución Anticipo-CtaCxC --->
		<cfquery datasource="#session.DSN#" name="mp">
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
				TipoMovimiento
			)
				select 'TEGE', <!--- as ModuloOrigen --->
				<cf_dbfunction name="to_char" args="le.GELnumero" > as TESLnumero, <!--- NumeroDocumento --->
				'LiqGE sin SP', <!--- NumeroReferencia --->
				<cf_dbfunction name="to_date00" args="le.GELfecha" > as GELfecha, <!--- FechaDocumento --->
				#rsPeriodoAuxiliar.Pvalor# as Periodo, <!--- AnoDocumento --->
				#rsMesAuxiliar.Pvalor# as Mes, <!--- as MesDocumento --->
				x.Linea,
				e.CFcuenta, <!--- GEanticipo.CFuenta = Cta Anticipo CxC --->
				f.Ocodigo, <!--- Oficina --->
				e.Mcodigo, <!--- Mcodigo --->
				-CASE 
					when x.GELAtotal >= 0 AND cm.Ctipo IN ('A','G') 
						then round(abs(x.GELAtotal),2)
							when x.GELAtotal < 0 AND cm.Ctipo NOT IN ('A','G') 
						then round(abs(x.GELAtotal),2)
					else -round(abs(x.GELAtotal),2)
					END as INTMOE, 
					e.GEAmanual, <!--- as TipoCambio --->
				-CASE 
					when x.GELAtotal >= 0 AND cm.Ctipo IN ('A','G') 
						then round(abs(x.GELAtotal) * e.GEAmanual,2)
					when x.GELAtotal < 0 AND cm.Ctipo NOT IN ('A','G') 
						then round(abs(x.GELAtotal) * e.GEAmanual,2)
					else -round(abs(x.GELAtotal) * e.GEAmanual,2)
				END as INTMON, 
				'E' as Tipo <!--- as TipoMovimiento --->
				from GEliquidacionAnts x
					inner join GEliquidacion le
					on le.GELid = x.GELid
					inner join GEanticipoDet d
						inner join GEanticipo e
							inner join CFuncional f
							on f.CFid = e.CFid
							inner join CFinanciera cf
								inner join CtasMayor cm
									on cm.Ecodigo = cf.Ecodigo
									and cm.Cmayor = cf.Cmayor
							on cf.CFcuenta = e.CFcuenta
						on e.GEAid = d.GEAid
					on d.GEADid = x.GEADid
				where  x.GELid =<cfqueryparam value="#Arguments.GELid#" cfsqltype="cf_sql_numeric">
		</cfquery>

	<!--- 2) Ejecución Gastos Ejecutados --->
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
				TipoMovimiento
			)
			select 'TEGE', <!--- as ModuloOrigen --->
				<cf_dbfunction name="to_char" args="e.GELnumero" > as TESLnumero, <!--- NumeroDocumento --->
				'LiqGE sin SP', <!--- NumeroReferencia --->
				e.GELfecha, <!--- FechaDocumento --->
				#rsPeriodoAuxiliar.Pvalor# as Periodo, <!--- AnoDocumento --->
				#rsMesAuxiliar.Pvalor# as Mes, <!--- as MesDocumento --->
				d.Linea, <!--- NumeroLinea --->
				d.CFcuenta, <!--- CFuenta --->
				f.Ocodigo, <!--- Oficina --->
				e.Mcodigo, <!--- Mcodigo --->
				CASE 
					when d.GELGtotalOri   >= 0 AND m.Ctipo IN ('A','G') 
						then round(abs(d.GELGtotalOri  ),2)
							when d.GELGtotalOri    < 0 AND m.Ctipo NOT IN ('A','G') 
						then round(abs(d.GELGtotalOri   ),2)
					else -round(abs(d.GELGtotalOri   ),2)
					END as INTMOE, 
					d.GELGtipoCambio, <!--- as TipoCambio --->
				CASE 
					when d.GELGtotalOri   >= 0 AND m.Ctipo IN ('A','G') 
						then round(abs(d.GELGtotalOri  ) * d.GELGtipoCambio,2)
					when d.GELGtotalOri   < 0 AND m.Ctipo NOT IN ('A','G') 
						then round(abs(d.GELGtotalOri  ) * d.GELGtipoCambio,2)
					else -round(abs(d.GELGtotalOri  ) * d.GELGtipoCambio,2)
				END as INTMON, 
				'E' as Tipo
				from 	
					GEliquidacion e
						inner join GEliquidacionGasto d
							inner join CFinanciera cf
								inner join CtasMayor m
								on m.Ecodigo = cf.Ecodigo
								and m.Cmayor = cf.Cmayor
							on cf.CFcuenta = d.CFcuenta
						on d.GELid= e.GELid
						inner join CFuncional f
						on f.CFid = e.CFid	
			where e.GELid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GELid#">
			  and e.Ecodigo = #session.Ecodigo#
		</cfquery>

	<!--- 3) Ejecución Depositos --->
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
				TipoMovimiento
			)
			select 'TEGE', <!--- as ModuloOrigen --->
				<cf_dbfunction name="to_char" args="e.GELnumero" > as TESLnumero, <!--- NumeroDocumento --->
				'LiqGE sin SP', <!--- NumeroReferencia --->
				d.GELDfecha, <!--- FechaDocumento --->
				#rsPeriodoAuxiliar.Pvalor# as Periodo, <!--- AnoDocumento --->
				#rsMesAuxiliar.Pvalor# as Mes, <!--- as MesDocumento --->
				d.Linea, <!--- NumeroLinea --->
				c.Ccuenta, <!--- CFuenta --->
				f.Ocodigo, <!--- Oficina --->
				e.Mcodigo, <!--- Mcodigo --->
				CASE 
					when d.GELDtotalOri   >= 0 AND m.Ctipo IN ('A','G') 
						then round(abs(d.GELDtotalOri  ),2)
							when d.GELDtotalOri    < 0 AND m.Ctipo NOT IN ('A','G') 
						then round(abs(d.GELDtotalOri  ),2)
					else -round(abs(d.GELDtotalOri  ),2)
					END as INTMOE, 
					d.GELDtipoCambio, <!--- as TipoCambio --->
				CASE 
					when d.GELDtotalOri   >= 0 AND m.Ctipo IN ('A','G') 
						then round(abs(d.GELDtotalOri  ) * d.GELDtipoCambio,2)
					when d.GELDtotalOri   < 0 AND m.Ctipo NOT IN ('A','G') 
						then round(abs(d.GELDtotalOri  ) * d.GELDtipoCambio,2)
					else -round(abs(d.GELDtotalOri  ) * d.GELDtipoCambio,2)
				END as INTMON, 
				'E' as Tipo
			 from GEliquidacionDeps d
					inner join GEliquidacion e
						inner join CFuncional f
						on f.CFid=e.CFid
					on e.GELid=d.GELid
						inner join CuentasBancos c
							inner join CContables cc
								inner join CtasMayor m
								on m.Ecodigo=cc.Ecodigo
								and m.Cmayor=cc.Cmayor
							on cc.Ccuenta=c.Ccuenta
					on c.CBid=d.CBid	
			where d.GELid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GELid#">
		</cfquery>
</cffunction>

<!------------------------------------------------5)Aprobar Liquidacion---------------------------------------------------->
<cffunction name="sbAprobarLiquidacion" access="public" >
	<cfargument name="GELid" type="numeric" required="yes">
	<cfquery name="ActualizaDet" datasource="#session.dsn#">
		update GEliquidacionGasto 
		set  GELGestado = 2
		where GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GELid#">
	</cfquery>
	
	<cfquery name="ActualizaEncabe" datasource="#session.dsn#">
		update GEliquidacion
		set GELestado= 2
		where GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GELid#">	
	</cfquery>
	
	<cfobject component="sif.Componentes.PRES_Presupuesto" name="LobjControl">	
	<!---<cfset LobjControl.CreaTablaIntPresupuesto (session.dsn)/>	--->			
	
	<!---Crea NAP--->	
		<cfquery name="rsSQL" datasource="#session.DSN#" >
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
		<cfquery datasource="#session.dsn#" name="NumNAP">
			update GEliquidacion
			set 
			CPNAPnum= <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarNAP#">
			where 
			GELid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GELid#">
		</cfquery>
</cffunction>


<!---                                                         Crea SP                                                   --->
<!---
1)Llamar a la funcion sbAprobarLiquidacionAnticipo
2)+Reserva de gasto
3)+Reserva de depositos
4)Llamas a sbAprobarLiquidacion
Contabilidad
Bancos
--->

<!--------------------------------------------------2) Reserva de Gasto---------------------------------------------------->
<cffunction name="sbReservarLiquidacionGasto"  access="public">
<cfargument name="GELid" type="numeric" required="yes">

	
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
					TipoMovimiento
				)
					select 'TEGE', <!--- as ModuloOrigen --->
					<cf_dbfunction name="to_char" args="e.GELnumero" > as TESLnumero, <!--- NumeroDocumento --->
					'RCGastos', <!--- NumeroReferencia --->
					<cf_dbfunction name="to_date00" args="e.GELfecha" > as GELfecha, <!--- FechaDocumento --->
					#rsPeriodoAuxiliar.Pvalor# as Periodo, <!--- AnoDocumento --->
					#rsMesAuxiliar.Pvalor# as Mes, <!--- as MesDocumento --->
					d.Linea, <!--- NumeroLinea --->
					d.CFcuenta, <!--- CFuenta --->
					f.Ocodigo, <!--- Oficina --->
					e.Mcodigo, <!--- Mcodigo --->
					CASE 
						when d.GELGtotalOri   >= 0 AND m.Ctipo IN ('A','G') 
							then round(abs(d.GELGtotalOri  ),2)
								when d.GELGtotalOri    < 0 AND m.Ctipo NOT IN ('A','G') 
							then round(abs(d.GELGtotalOri   ),2)
						else -round(abs(d.GELGtotalOri   ),2)
						END as INTMOE, 
						d.GELGtipoCambio, <!--- as TipoCambio --->
					CASE 
						when d.GELGtotalOri   >= 0 AND m.Ctipo IN ('A','G') 
							then round(abs(d.GELGtotalOri  ) * d.GELGtipoCambio,2)
						when d.GELGtotalOri   < 0 AND m.Ctipo NOT IN ('A','G') 
							then round(abs(d.GELGtotalOri  ) * d.GELGtipoCambio,2)
						else -round(abs(d.GELGtotalOri  ) * d.GELGtipoCambio,2)
					END as INTMON, 
					'RC' as Tipo
					from 	
						GEliquidacion e
							inner join GEliquidacionGasto d
								inner join CFinanciera cf
									inner join CtasMayor m
									on m.Ecodigo = cf.Ecodigo
									and m.Cmayor = cf.Cmayor
								on cf.CFcuenta = d.CFcuenta
							on d.GELid= e.GELid
							inner join CFuncional f
							on f.CFid = e.CFid	
					where e.GELid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GELid#">
					and e.Ecodigo = #session.Ecodigo#
			</cfquery>
</cffunction>
<!--------------------------------------------------2) Reserva de Deposito------------------------------------------------>
<cffunction name="sbReservarLiquidacionDeposito"  access="public">
<cfargument name="GELid" type="numeric" required="yes">

	
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
					TipoMovimiento
				)
				
				select 'TEGE', <!--- as ModuloOrigen --->
					<cf_dbfunction name="to_char" args="e.GELnumero" > as TESLnumero, <!--- NumeroDocumento --->
					'RCDeposito', <!--- NumeroReferencia --->
					<cf_dbfunction name="to_date00" args="d.GELDfecha" > as GELfecha, <!--- FechaDocumento --->
					#rsPeriodoAuxiliar.Pvalor# as Periodo, <!--- AnoDocumento --->
					#rsMesAuxiliar.Pvalor# as Mes, <!--- as MesDocumento --->
					d.Linea, <!--- NumeroLinea --->
					c.Ccuenta, <!--- CFuenta --->
					f.Ocodigo, <!--- Oficina --->
					e.Mcodigo, <!--- Mcodigo --->
					CASE 
						when d.GELDtotalOri   >= 0 AND m.Ctipo IN ('A','G') 
							then round(abs(d.GELDtotalOri  ),2)
								when d.GELDtotalOri  < 0 AND m.Ctipo NOT IN ('A','G') 
							then round(abs(d.GELDtotalOri  ),2)
						else -round(abs(d.GELDtotalOri  ),2)
						END as INTMOE, 
						d.GELDtipoCambio, <!--- as TipoCambio --->
					CASE 
						when d.GELDtotalOri   >= 0 AND m.Ctipo IN ('A','G') 
							then round(abs(d.GELDtotalOri  ) * d.GELDtipoCambio,2)
						when d.GELDtotalOri   < 0 AND m.Ctipo NOT IN ('A','G') 
							then round(abs(d.GELDtotalOri  ) * d.GELDtipoCambio,2)
						else -round(abs(d.GELDtotalOri  ) * d.GELDtipoCambio,2)
					END as INTMON, 
					'RC' as Tipo
						 from GEliquidacionDeps d
							inner join GEliquidacion e
								inner join CFuncional f
								on f.CFid=e.CFid
							on e.GELid=d.GELid
								inner join CuentasBancos c
									inner join CContables cc
										inner join CtasMayor m
										on m.Ecodigo=cc.Ecodigo
										and m.Cmayor=cc.Cmayor
									on cc.Ccuenta=c.Ccuenta
								on c.CBid=d.CBid	
						where d.GELid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GELid#">
			</cfquery>
</cffunction>
<!---                                                     Contabilidad                                                  --->
<!---
1)CxC CR Anticipos
2)Gastos DB Gastos
3)Bcos DB Depositos
--->
<!--------------------------------------------------1)CxC CR Anticipos----------------------------------------------------->
<cffunction name="sbContabilidadAnticipo"  access="public">
<cfargument name="GELid" type="numeric" required="yes">
	
    <cfinclude template="../../Utiles/sifConcat.cfm">
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
		
	<!---inserta datos en intarc--->

		<cfquery datasource="#session.dsn#">
		insert into #INTARC# 
			( 
				INTORI,INTREL,
				INTDOC,INTREF,
				INTFEC,Periodo, Mes, Ocodigo,
				INTTIP, INTDES, 
				CFcuenta, Ccuenta, 
				Mcodigo, INTMOE, INTCAM, INTMON
			)
		select 
				'TEGE',1,
				'Liquidacion',<cf_dbfunction name="to_char" args="le.GELnumero">,
				'#DateFormat(now(),"YYYYMMDD")#', #rsPeriodoAuxiliar.Pvalor#, #rsPeriodoAuxiliar.Pvalor#, cf.Ocodigo,
				'C',
				'LiquidacionAnticipo.' #_Cat# <cf_dbfunction name="to_char" args="a.GEAnumero">  #_Cat# ':' #_Cat# cg.GECdescripcion,
				a.CFcuenta, 0, 
				a.Mcodigo, 
				x.GELAtotal, 
				le.GELtipoCambio, 
				round(x.GELAtotal*le.GELtipoCambio,2)
					from GEliquidacionAnts x
						inner join GEanticipo a
							inner join CFuncional cf
							on cf.CFid=a.CFid
						on a.GEAid=x.GEAid	
							inner join GEanticipoDet d
								inner join GEconceptoGasto cg
								on cg.GECid =d.GECid
							on d.GEADid=x.GEADid
						inner join GEliquidacion le
						on le.GELid=x.GELid
					where x.GELid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GELid#">
			</cfquery>
</cffunction>
	
<!--------------------------------------------------2)Gastos DB Gastos----------------------------------------------------->
<cffunction name="sbContabilidadGastos"  access="public">
<cfargument name="GELid" type="numeric" required="yes">
	
	<cfinclude template="../../Utiles/sifConcat.cfm">
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
		
	<!---inserta datos en intarc--->
		<cfquery datasource="#session.dsn#">
		insert into #INTARC# 
			( 
				INTORI, INTREL, 
				INTDOC, INTREF, 
				INTFEC, Periodo, Mes, Ocodigo, 
				INTTIP, INTDES, 
				CFcuenta, Ccuenta, 
				Mcodigo, INTMOE, INTCAM, INTMON
			)
		select 
				'TEGE',1,
				'Liquidacion',<cf_dbfunction name="to_char" args="le.GELnumero">,
				'#DateFormat(now(),"YYYYMMDD")#', #rsPeriodoAuxiliar.Pvalor#, #rsPeriodoAuxiliar.Pvalor#, cf.Ocodigo,
				'D',
				'LiquidacionGasto.' #_Cat# <cf_dbfunction name="to_char" args="d.GELGnumeroDoc"> #_Cat# ': ' #_Cat# d.GELGdescripcion,
				d.CFcuenta, 0, 
				d.Mcodigo, 
				d.GELGtotalOri, 
				d.GELGtipoCambio, 
				round(d.GELGtotalOri*d.GELGtipoCambio,2)	
					from GEliquidacionGasto d
						inner join GEliquidacion le
							inner join CFuncional cf
							on cf.CFid=le.CFid
						on le.GELid=d.GELid
					where d.GELid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GELid#">
	</cfquery>
</cffunction>

<!-------------------------------------------------3)Bcos DB Depositos----------------------------------------------------->
<cffunction name="sbContabilidadDepositos"  access="public">
<cfargument name="GELid" type="numeric" required="yes">
	
	<cfinclude template="../../Utiles/sifConcat.cfm">
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
		
	<!---inserta datos en intarc--->
		<cfquery datasource="#session.dsn#">
		insert into #INTARC# 
			( 
				INTORI, INTREL, 
				INTDOC, INTREF, 
				INTFEC, Periodo, Mes, Ocodigo, 
				INTTIP, INTDES, 
				CFcuenta, Ccuenta, 
				Mcodigo, INTMOE, INTCAM, INTMON
			)
		select 
			'TEGE',1,
				'Liquidacion',<cf_dbfunction name="to_char" args="le.GELnumero">,
				'#DateFormat(now(),"YYYYMMDD")#', #rsPeriodoAuxiliar.Pvalor#, #rsPeriodoAuxiliar.Pvalor#, f.Ocodigo,
				'D',
			'LiquidacionDeposito.' #_Cat# <cf_dbfunction name="to_char" args="d.GELDreferencia"> ,
				null,c.Ccuenta, 
				d.Mcodigo, 
				d.GELDtotalOri, 
				d.GELDtipoCambio, 
				round(d.GELDtotalOri*d.GELDtipoCambio,2)		
				from GEliquidacionDeps d
						inner join GEliquidacion le
						inner join CFuncional f
						on f.CFid=le.CFid
						on le.GELid=d.GELid
						inner join CuentasBancos c
						inner join CContables cc
						inner join CtasMayor m
						on m.Ecodigo=cc.Ecodigo
						and m.Cmayor=cc.Cmayor
						on cc.Ccuenta=c.Ccuenta
						on c.CBid=d.CBid	
						where d.GELid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GELid#">
	</cfquery>
</cffunction>
<!---                                                     Movimientos                                                    --->
<!---
1)Movimiento Bancario (Depositos)
--->
<cffunction name="sbMovimientoDepositos" access="public" >
	<cfargument name="GELid" type="numeric" required="yes">
	<cfinclude template="../../Utiles/sifConcat.cfm">
    
	<cftry>
		<cfquery name="rsOPs" datasource="#session.dsn#">
			select * from GEliquidacionDeps d
				inner join GEliquidacion le
					inner join CFuncional f
					on f.CFid=le.CFid
				on le.GELid=d.GELid
			inner join CuentasBancos c
				inner join CContables cc
					inner join CtasMayor m
					on m.Ecodigo=cc.Ecodigo
					and m.Cmayor=cc.Cmayor
				on cc.Ccuenta=c.Ccuenta
			on c.CBid=d.CBid
			where d.GELid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GELid#">			
			</cfquery>
		<cfif rsOPs.recordCount EQ 0>
			<cfreturn>
		</cfif>
		
		<!---- Carga el periodo de rsAsientos.EcodigoOri --->
		<cfquery name="rsParametros" datasource="#session.DSN#">
			select <cf_dbfunction name="to_number" args="Pvalor"> as Periodo
			from Parametros
			Where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOPs.Ecodigo#">
				and Mcodigo = 'GN'
				and Pcodigo = 50		
		</cfquery>			
		<cfif isdefined("rsParametros") and rsParametros.RecordCount GT 0>
			<cfset LvarAuxPeriodo =  rsParametros.Periodo>			
		</cfif>
		
		<!---- Carga el mes de rsAsientos.EcodigoOri --->
		<cfquery name="rsMes" datasource="#session.DSN#">
			select <cf_dbfunction name="to_number" args="Pvalor"> as Mes
			from Parametros
			Where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOPs.Ecodigo#">
				and Mcodigo = 'GN'
				and Pcodigo = 60		
		</cfquery>			
		<cfif isdefined("rsMes") and rsMes.RecordCount GT 0>
			<cfset LvarAuxMes =  rsMes.Mes>			
		</cfif>
		
		<cfset LvarMLids = "">
		<cfloop query="rsOPs">
	<cfset LvarBTid = fnVerificaMLibrosTraeBT (rsOPs.Ecodigo, rsOPs.CBid,rsOPs.GELDreferencia,rsOPs.BTid)>
			<cfquery datasource="#session.dsn#" name="insert">
				insert into	MLibros
					(
						Ecodigo, 
						Bid, 
						BTid, 
						CBid, 
						Mcodigo, 
						MLfechamov, 
						MLfecha, 
						MLreferencia, 
						MLdocumento, 
						MLdescripcion, 
						MLconciliado, 
						IDcontable, 
						MLtipocambio, 
						MLmonto, 
						MLmontoloc, 
						MLperiodo, 
						MLmes, 
						MLtipomov, 
						MLusuario
					)
					select
						d.Ecodigo, 
						cb.Bid ,
						d.BTid,
						d.CBid, 
						m.Mcodigo,  
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
						<cfqueryparam cfsqltype="cf_sql_date" value="#rsOPs.GELDfecha#">,
						'Liquidacion',
						d.GELDreferencia,					
						#_SUBSTR#('GE.Liquidacion,' #_Cat# <cf_dbfunction name="to_char" args="le.GELnumero">
						#_Cat# ' : a ' #_Cat# rtrim(be.TESBeneficiario),1,75), 
						'S',
						NULL, 
						d.GELDtipoCambio, 
						d.GELDtotalOri,
						round(d.GELDtipoCambio * d.GELDtotalOri, 2), 
						<cfqueryparam cfsqltype="cf_sql_integer" value="#LvarAuxPeriodo#">, 
						<cfqueryparam cfsqltype="cf_sql_integer" value="#LvarAuxMes#">, 
						'D',
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Usulogin#">								
							from GEliquidacionDeps d
								inner join GEliquidacion le
									inner join TESbeneficiario be
									on be.TESBid=le.TESBid
								on le.GELid=d.GELid
								inner join CuentasBancos cb
								on cb.CBid=d.CBid
								and cb.Ecodigo=d.Ecodigo
								inner join Monedas m 
								on m.Mcodigo= d.Mcodigo
							where d.GELid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GELid#">
				<cf_dbidentity1 datasource="#session.DSN#" name="insert" verificar_transaccion="no">
			</cfquery>
			<cf_dbidentity2 datasource="#session.DSN#" name="insert" verificar_transaccion="no" returnvariable="LvarMLid">
			<cfset LvarMLids = LvarMLids & LvarMLid & ",">
		</cfloop>
	<cfcatch type="any">
		<cftransaction action="rollback" />
		<cfrethrow> 
	</cfcatch>
	</cftry>
</cffunction>

<cffunction name="fnVerificaMLibrosTraeBT" output="false" access="private" returntype="void">
	<cfargument name="Ecodigo"  type="numeric" required="yes">
	<cfargument name="CBid"     type="numeric" required="yes">
	<cfargument name="MLdoc"    type="string" required="yes">
	<cfargument name="BTid"     type="numeric" required="yes">
	
	<cfquery name="rsMLibros" datasource="#session.dsn#">
		select count(1) as cantidad
		  from MLibros
		 where MLdocumento 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MLdoc#">
		   and BTid			= #Arguments.BTid#
		   and CBid 		= #Arguments.CBid#
	</cfquery>
	
	<cfif rsMLibros.cantidad GT 0>
		<cfquery name="rsBTran" datasource="#session.dsn#">
			select BTcodigo, BTdescripcion
			  from BTransacciones 
			 where BTid = #Arguments.BTid#
		</cfquery>
		<cf_errorCode	code = "51604"
						msg  = "El Documento '@errorDat_1@' con Transacción '@errorDat_2@=@errorDat_3@' ya está registrado en Libros Bancarios"
						errorDat_1="#Arguments.MLdoc#"
						errorDat_2="#rsBTran.BTcodigo#"
						errorDat_3="#rsBTran.BTdescripcion#"
		>
	</cfif>
</cffunction>
<!---                                                     Emision de Cheque                                              --->
<!---
1)-Desreservar el gasto
2)-Desreservar el deposito
3)Llamar a la funcion sbEjecutaLiquidacionGasto
4)Llamar a la funcion sbEjecutaLiquidacionDeposito
Contabilidad
Bancos
--->


<!---**********************************************************************************************************************--->
<!-----------------------------------------------1)Desagregar la Reserva de Gasto--------------------------------------------->
<cffunction name="sbCancelaLiquidacionGasto" returntype="numeric" access="public">
<cfargument name="GELid" type="numeric" required="yes">

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
					TipoMovimiento
				)
					select 'TEGE', <!--- as ModuloOrigen --->
					<cf_dbfunction name="to_char" args="e.GELnumero" > as TESLnumero, <!--- NumeroDocumento --->
					'Gasto2', <!--- NumeroReferencia --->
					e.GELfecha, <!--- FechaDocumento --->
					#rsPeriodoAuxiliar.Pvalor# as Periodo, <!--- AnoDocumento --->
					#rsMesAuxiliar.Pvalor# as Mes, <!--- as MesDocumento --->
					d.Linea, <!--- NumeroLinea --->
					d.CFcuenta, <!--- CFuenta --->
					f.Ocodigo, <!--- Oficina --->
					e.Mcodigo, <!--- Mcodigo --->
					-CASE 
						when d.GELGtotalOri   >= 0 AND m.Ctipo IN ('A','G') 
							then round(abs(d.GELGtotalOri  ),2)
								when d.GELGtotalOri    < 0 AND m.Ctipo NOT IN ('A','G') 
							then round(abs(d.GELGtotalOri   ),2)
						else -round(abs(d.GELGtotalOri   ),2)
						END as INTMOE, 
						d.GELGtipoCambio, <!--- as TipoCambio --->
					-CASE 
						when d.GELGtotalOri   >= 0 AND m.Ctipo IN ('A','G') 
							then round(abs(d.GELGtotalOri  ) * d.GELGtipoCambio,2)
						when d.GELGtotalOri   < 0 AND m.Ctipo NOT IN ('A','G') 
							then round(abs(d.GELGtotalOri  ) * d.GELGtipoCambio,2)
						else -round(abs(d.GELGtotalOri  ) * d.GELGtipoCambio,2)
					END as INTMON, 
					'RC' as Tipo
					from 	
						GEliquidacion e
							inner join GEliquidacionGasto d
							on d.GELid= e.GELid
								inner join CFuncional f
								on f.CFid = e.CFid	
									inner join CFinanciera cf
										inner join CtasMayor m
										on m.Ecodigo = cf.Ecodigo
										and m.Cmayor = cf.Cmayor
									on cf.CFcuenta = d.CFcuenta
						where e.GELid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GELid#">
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
</cffunction>

<!---<cffunction name="sbEmitirLiquidacion" output="false" access="public">
		<cfargument name="GELid" type="numeric" required="true">
		
		<cfquery datasource="#session.dsn#">
			update GEliquidacion
				set GELestado = 4
			 where GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GELid#">
			   and Ecodigo = #session.Ecodigo#
			   and GELestado = 2
		</cfquery>
	
		<cf_errorCode	code = "51631" msg = "No se ha implementado la Emisión de Liquidación a Gastos de Empleado">
	</cffunction>--->

<!---                                        EMISION DE ORDENES DE PAGO                                                   --->
<cffunction name="sbOP_MovimientosAnticiposGE" output="true" access="package">
	<cfargument name="TESOPid" 		type="numeric" 	required="yes">
	<cfargument name="rsAsientos" 	type="query" 	required="yes">
	<cfargument name="IDcontable" 	type="numeric" 	required="yes">
	<cfargument name="Anulacion" 	type="boolean" 	required="yes">

	<cfif Arguments.Anulacion>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select count(1) as cantidad
			  from GEanticipo g
			  	inner join GEanticipoDet gd
					 on gd.GEAid = g.GEAid
				 inner join TESdetallePago dp
					 on dp.TESid				= #session.Tesoreria.TESid#
					and dp.TESOPid				= #arguments.TESOPid#
					and dp.EcodigoOri 			= #rsAsientos.EcodigoOri#
					and dp.TESDPtipoDocumento 	= 6
					and dp.TESDPidDocumento	= g.GEAid
				where gd.GEADutilizado <> 0
		</cfquery>

		<cfif rsSQL.cantidad gt 0>
			<cf_errorCode	code = "51632" msg = "El Anticipo no se puede anular porque ya ha sido liquidado">
		</cfif>
	</cfif>

	<cfquery datasource="#session.dsn#">
		update GEanticipo
	<cfif Arguments.Anulacion>
		   set GEAestado = 3
	<cfelse>
		   set GEAestado = 4
	</cfif>
		 where exists
			(
				select 1
				  from TESdetallePago dp
				 where dp.TESid		= #session.Tesoreria.TESid#
				   and dp.TESOPid	= #arguments.TESOPid#
				   and dp.EcodigoOri = #rsAsientos.EcodigoOri#
				   and dp.TESDPtipoDocumento 	= 6
				   and dp.TESDPidDocumento		= GEanticipo.GEAid
			)
	</cfquery>
</cffunction>

<cffunction name="sbOP_MovimientosLiquidacionGE" output="true" access="package">
	<cfargument name="TESOPid" 		type="numeric" 	required="yes">
	<cfargument name="rsAsientos" 	type="query" 	required="yes">
	<cfargument name="IDcontable" 	type="numeric" 	required="yes">
	<cfargument name="Anulacion" 	type="boolean" 	required="yes">


	<cfquery name="rsSQL" datasource="#session.dsn#">
		select count(1) as cantidad
		  from TESdetallePago dp
		 where dp.TESid		= #session.Tesoreria.TESid#
		   and dp.TESOPid	= #arguments.TESOPid#
		   and dp.EcodigoOri = #rsAsientos.EcodigoOri#
		   and dp.TESDPtipoDocumento 	= 7
	</cfquery>

	<cfquery datasource="#session.dsn#">
		update GEliquidacion
	<cfif Arguments.Anulacion>
		   set GELestado = 3
	<cfelse>
		   set GELestado = 4

	</cfif>
		 where GELid=
			(
				select max(l.GELid) from TESsolicitudPago p 
				inner join GEliquidacion l
				on l.TESSPid=p.TESSPid
				where p.TESOPid=#arguments.TESOPid#
			)
	</cfquery>

	<!--- Actualiza el TESSPaprobadopendiente y GEADutilizado --->
	<cfquery name="upMontos" datasource="#session.dsn#">
			update GEanticipoDet
			set  TESDPaprobadopendiente = TESDPaprobadopendiente - 
			(
				select sum(x.GELAtotal)
				from GEliquidacionAnts x
					inner join GEliquidacion e
						   inner join TESsolicitudPago sp
						   on sp.TESOPid =#arguments.TESOPid#
						   and sp.TESSPid = e.TESSPid
					on e.GELid = x.GELid
				where x.GEADid = GEanticipoDet.GEADid
			),
			GEADutilizado = GEADutilizado + 
			(
			select sum(x.GELAtotal)
			from GEliquidacionAnts x
				inner join GEliquidacion e
				   inner join TESsolicitudPago sp
				   on sp.TESOPid = #arguments.TESOPid#
					and sp.TESSPid = e.TESSPid
				on e.GELid = x.GELid
			where x.GEADid = GEanticipoDet.GEADid
							)
			where 
			(
				select count(1)
					from GEliquidacionAnts x
						inner join GEliquidacion e
						   inner join TESsolicitudPago sp
						   on sp.TESOPid = #arguments.TESOPid#
							and sp.TESSPid = e.TESSPid
					on e.GELid = x.GELid
			where x.GEADid = GEanticipoDet.GEADid
							) > 0
	</cfquery>
<!--- Actualiza el Estado de los Anticipos involucrados --->
<cfquery datasource="#session.dsn#">
		update GEanticipo
	<cfif Arguments.Anulacion>
		   set GEAestado = 4  	<!--- Vuelven a pagados porque o estaban en pagados o ya no están liquidados --->
	<cfelse>
		   set GEAestado = 5		<!--- Se convierten en liquidados si no tienen ningun saldo --->
	</cfif>
		 where exists
			(
				select 1
				  from TESdetallePago dp
				 where dp.TESid		= #session.Tesoreria.TESid#
				   and dp.TESOPid	= #arguments.TESOPid#
				   and dp.EcodigoOri = #rsAsientos.EcodigoOri#
				   and dp.TESDPtipoDocumento 	= 7
				   and dp.TESDPreferenciaOri		= 'Anticipo'
				   and dp.TESDPidDocumento		= GEanticipo.GEAid
			)
	<cfif NOT Arguments.Anulacion>
		   and (
				select count(1)
				  from GEanticipoDet
				 where GEAid = GEanticipo.GEAid
				   and NOT (
				   		GEADmonto = GEADutilizado
				   	and TESDPaprobadopendiente = 0
						)
			) = 0
	</cfif>
</cfquery>
</cffunction>
</cfcomponent>


