<!---Validaciones De la Liquidacion.--->
<!---Interfas con Presupuesto--->
<!---Llamado de Componenete--->
<!---Actualizacion de Liquidaciones--->

<!--- Valida El Usuario Aprobador--->
<cfquery datasource="#session.dsn#" name="rsLiquidacion">
	select GELid,CCHTid, CFid,Mcodigo,GELdescripcion,GELtotalGastos, GELtotalDepositos,GELtotalAnticipos, coalesce(GELtotalDevoluciones,0) as GELtotalDevoluciones
	from GEliquidacion 
	where GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.GELid#">	
</cfquery>

<cfquery name="rsCajaChica" datasource="#session.dsn#">
	select 
			CCHid,
			CCHresponsable
	from CCHica 
	where 	CCHid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.FormaPago#">
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
				where a.TESBid         = #Busqueda.TESBid#
				  and a.GEAestado      = 4  <!--- DEBE SER 4=Pagado --->
				  and a.Mcodigo        = #Busqueda.Mcodigo#
				  and a.Ecodigo        = #Busqueda.Ecodigo#
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
				<cftransaction>
					<cfinvoke component="sif.tesoreria.Componentes.TESCajaChicaPresupuesto" method="ReservaGasto">
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
						<cfinvokeargument name="CCHtipo"    		value="#url.LvarTipo#"/>
						<cfinvokeargument name="CCHTrelacionada"    value="#rsLiquidacion.GELid#"/>
						<cfinvokeargument name="CCHTtrelacionada"   value="GASTO"/>
					</cfinvoke>	
					<!--- Actulización del estado del Anticipo--->
					<cfquery name="rsActualiza" datasource="#session.DSN#">
						update GEliquidacion set 
								GELestado =2, 
								CCHid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.FormaPago#">
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
				</cftransaction>
			<cfelse>
				<cf_errorCode	code = "50726" msg = "No hay disponible en Caja.">
			</cfif>
		</cfif>
	<cfelse>
		<cftransaction>
			<!---Verificación de Presupuesto en Caja--->
			<cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="ApruebaImporte" returnvariable="LvarImporte">
				<cfinvokeargument name="CCHid"				value="#rsCajaChica.CCHid#">
				<cfinvokeargument name="CCHTtipo" 			value="GASTOS" > 
				<cfinvokeargument name="ImporteA"      		value="#rsLiquidacion.GELtotalAnticipos#">
				<cfinvokeargument name="ImporteL"      		value="#rsLiquidacion.GELtotalGastos#">  
				<cfinvokeargument name="Id_liquidacion"  	value="#rsLiquidacion.GELid#">
				<cfinvokeargument name="ImporteD"  	        value="#rsLiquidacion.GELtotalDevoluciones#"> 
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
				<cfinvokeargument name="CCHtipo"    		value="#url.LvarTipo#"/>
				<cfinvokeargument name="CCHTrelacionada"    value="#rsLiquidacion.GELid#"/>
				<cfinvokeargument name="CCHTtrelacionada"   value="GASTO"/>
			</cfinvoke>	
			<!--- Actulización del estado del Anticipo--->
			<cfquery name="rsActualiza" datasource="#session.DSN#">
					update GEliquidacion set 
							GELestado =2, 
							CCHid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.FormaPago#">
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
		</cftransaction>
</cfif>

<!---Retorna--->
<cfif isdefined ('url.referencia') and referencia eq 'LA'>
	<cflocation url="LiquidacionAnticipos.cfm">
<cfelse>
	<cflocation url="AprobarTrans.cfm">
</cfif>


