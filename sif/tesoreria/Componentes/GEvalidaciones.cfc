<cfcomponent>
<!---Se buscan anticipos sin liquidar del mismo tipo--->
	<cffunction name="AnticiposSinLiquidarMismoTipo" access="public">
		<cfargument name="GEAid"   		 		type="numeric" 	required="yes">
		<cfargument name="DEid" 				type="numeric" 	required="yes">
	
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select Pvalor
			  from Parametros
			 where Ecodigo = #session.Ecodigo#
			   and Pcodigo = 1213
		</cfquery>
		<cfif rsSQL.Pvalor NEQ "">
			<cfreturn>
		</cfif>

		<cfquery name="rsSQL" datasource="#session.dsn#">
			select CCHCantsPendientes
			  from CCHconfig 
			 where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		<cfif rsSQL.CCHCantsPendientes EQ "1">
			<cfreturn>
		</cfif>

		<cfquery name="rsViatico" datasource="#session.dsn#">
			select a.GEAviatico, a.GECid, b.GECtipo
			  from GEanticipo a
			  	left join GEcomision b
					on b.GECid = a.GECid
			 where GEAid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#GEAid#" null="#Len(GEAid) Is 0#">
		</cfquery>
		
		<cfquery name="rsAnticipo" datasource="#session.dsn#">
			select a.GEAid,a.GEAnumero,a.TESBid,a.GEAtotalOri,a.GEAdescripcion,a.GEAtipoP,a.GEAviatico,a.GEAtipoviatico
			  from GEanticipo a
				inner join TESbeneficiario b
					on a.TESBid=b.TESBid
			 where a.Ecodigo		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			   and a.GEAestado in(2,4)  <!--- DEBE SER 2=aprobada 4=Pagado --->
			   and b.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
			   and a.GEAviatico=<cfqueryparam cfsqltype="cf_sql_char" value="#rsViatico.GEAviatico#">
 			   and (				<!----- Cuando todavia existan detalles que no estan por liquidar: cantidadXliquidar < cantidadAnticipoD--->
						(
							select count(1)
							  from GEliquidacionAnts d
								inner join GEliquidacion e
								 on e.GELid 		= d.GELid
								and e.GELestado 	in (2,4,5)
							 where d.GEAid = a.GEAid
						) 
						<
						(
							select count(1)
							  from GEanticipoDet f
							 where f.GEAid = a.GEAid
							   and f.GEADmonto - f.GEADutilizado - f.TESDPaprobadopendiente > 0
						) 
					)
			<cfif rsViatico.GECid NEQ "">
			   and a.GECid <> #rsViatico.GECid#
			   and a.GEAtipoviatico = '#rsViatico.GECtipo#'
			</cfif>
		</cfquery>

		<cfif rsAnticipo.recordcount gt 0 >
			<cfoutput>
				<font color="FF0000" size="+2">
					El empleado tiene Anticipos del mismo tipo sin liquidar, debe liquidarlos antes de poder generar otro anticipo.
				</font>			
				<table border="1" width="75%" bordercolor="333399">
					<tr>
						<td align="center"><strong><font color="0000FF">
							NumeroAnticipo
						</font></strong>
						</td>				
						<td align="center"><strong><font color="0000FF">
							Descripcion</font></strong>
						</td>
					</tr>
					
					<tr>
						<td>#rsAnticipo.GEAnumero#</td>
						<td>#rsAnticipo.GEAdescripcion#</td>
					</tr>
				</table>	
			</cfoutput>	
			<cf_abort errorInterfaz="El empleado tiene Anticipos del mismo tipo sin liquidar, debe liquidarlos antes de poder generar otro anticipo">		
		</cfif>	
	</cffunction>	
	
	
<!---Validacion para que no permita la creacion de una liq directa si tiene anticipos pendientes de liquidar--->
	<cffunction name="LiqDirAnticiposSinLiquidarMismoTipo" access="public">
		<cfargument name="GELid"   		 		type="numeric" 	required="yes">
		<cfargument name="DEid" 				type="numeric" 	required="no">
		
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select Pvalor
			  from Parametros
			 where Ecodigo = #session.Ecodigo#
			   and Pcodigo = 1214
		</cfquery>
		<cfif rsSQL.Pvalor NEQ "">
			<cfreturn>
		</cfif>

		<cfquery name="DatoEmpleado" datasource="#session.dsn#">
			select b.DEid 
				from GEliquidacion a
				inner join TESbeneficiario b 
				on a.TESBid = b.TESBid
				where a.GELid  =<cfqueryparam cfsqltype="cf_sql_numeric" value="#GELid#" null="#Len(GELid) Is 0#">
		</cfquery>
		
		<cfquery name="rsExisteAnticipo" datasource="#session.dsn#">
			select GEAid from GEliquidacionAnts 
			where GELid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#GELid#" null="#Len(GELid) Is 0#">
		</cfquery>
		
		<!---Si es 0 es que es LiqDirecta--->
		<cfif rsExisteAnticipo.recordcount eq 0>
		
			<cfquery name="rsViatico" datasource="#session.dsn#">
				select GEAviatico, GECid from GEliquidacion 
				where GELid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#GELid#" null="#Len(GELid) Is 0#">
			</cfquery>
			
			<!---Se buscan anticipos sin liquidar del mismo tipo--->
			<cfquery name="rsAnticipo" datasource="#session.dsn#">
				select a.GEAid,a.GEAnumero,a.TESBid,a.GEAtotalOri,a.GEAdescripcion,a.GEAtipoP,a.GEAviatico,a.GEAtipoviatico
				from GEanticipo a
				inner join TESbeneficiario b
				on a.TESBid=b.TESBid
			
				where 
					 a.Ecodigo		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
					and a.GEAestado in (2,4)  <!--- DEBE SER 2=aprobada 4=Pagado --->
					and b.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#DatoEmpleado.DEid#">
					<cfif len(trim(rsViatico.GEAviatico)) gt 0 and rsViatico.GEAviatico NEQ 0>
						and a.GEAviatico= <cfqueryparam cfsqltype="cf_sql_char" value="#rsViatico.GEAviatico#"> 
					<cfelse>
						and a.GEAviatico= '0'
					</cfif>
						
							and (				<!----- Cuando todavia existan detalles que no estan por liquidar: cantidadXliquidar < cantidadAnticipoD--->
									(
										select count(1)
										  from GEliquidacionAnts d
											inner join GEliquidacion e
											 on e.GELid 		= d.GELid
											and e.GELestado 	in (2,4,5)
										 where d.GEAid = a.GEAid
									) <
									(
										select count(1)
										  from GEanticipoDet f
										 where f.GEAid = a.GEAid
										   and f.GEADmonto - f.GEADutilizado - f.TESDPaprobadopendiente > 0
									) 
							)
				
					<cfif rsViatico.GECid NEQ "">
					   and a.GECid <> #rsViatico.GECid#
					</cfif>
			</cfquery>
			
			<cfif rsAnticipo.recordcount gt 0 >
				<font color="FF0000" size="+2">
					El empleado tiene Anticipos del mismo tipo sin liquidar, debe liquidarlos antes de poder generar la liquidacion directa.
				</font>			
				<table border="1" width="75%" bordercolor="333399">
					<tr>
						<td align="center"><strong><font color="0000FF">
							NumeroAnticipo
						</font></strong>
						</td>				
						<td align="center"><strong><font color="0000FF">
							Descripcion</font></strong>
						</td>
						
					</tr>
					<cfoutput>
					<tr>
						<td>#rsAnticipo.GEAnumero#</td>
						<td>#rsAnticipo.GEAdescripcion#</td>
					
					</tr>
					</cfoutput>
				</table>	
				<cf_abort errorInterfaz="El empleado tiene Anticipos del mismo tipo sin liquidar, debe liquidarlos antes de poder generar la liquidacion directa">		
			</cfif>
		</cfif>
	</cffunction>	

<!---Se buscan anticipos con Saldos en contra --->
	<cffunction name="AnticiposConSaldosContra" access="public">
		<cfargument name="GELid"   		 		type="numeric" 	required="yes">
		<cfargument name="TESBid" 				type="numeric" 	required="yes">
		<cfargument name="Ecodigo" 				type="numeric" 	required="yes">

		<cfquery name="rsSQL" datasource="#session.dsn#">
			select Pvalor
			  from Parametros
			 where Ecodigo = #session.Ecodigo#
			   and Pcodigo = 1215
		</cfquery>
		<cfif rsSQL.Pvalor NEQ "">
			<cfreturn>
		</cfif>

		<cfquery name="rsAnticipos" datasource="#session.dsn#">
			select a.GEAid,a.GEAnumero, sum(GEADmonto - GEADutilizado - TESDPaprobadopendiente - coalesce(GELAtotal,0)) as SaldoSinLiquidar
				from GEanticipo a
					inner join GEanticipoDet b
						left join GEliquidacionAnts c 
							inner join GEliquidacion e
							on e.GELid  = c.GELid
							and e.GELestado  in (0,1)
						on  c.GEADid = b.GEADid
					on b.GEAid = a.GEAid
				where a.TESBid		= #Arguments.TESBid#
				  and a.GEAestado	= 4  <!----- DEBE SER 4=Pagado--->
				  and a.Mcodigo		= #Arguments.Mcodigo#
				  and a.Ecodigo		= #Arguments.Ecodigo#
                  and c.GELid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GELid#">
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
				<cfoutput query="rsAnticipos">
				<tr>
					<td>#rsAnticipos.GEAnumero#</td>
					<td>#rsAnticipos.SaldoSinLiquidar#</td>
				</tr>
				</cfoutput>
			</table>	
			<cf_abort errorInterfaz="El empleado tiene Anticipos con saldos en contra que debe liquidar antes de poderle reintegar dinero">		
		</cfif>
	</cffunction>
	
<!---Valida que no sobrepase el monto máximo de viáticos al interior definido en parametrosGE--->	
	<cffunction name="MontoMaxViaticoNacional"  access="public">
		<cfargument name="DEid" 				type="numeric" 	required="yes">
		<cfargument name="fechaIni" 			type="date" 	required="no">
		<cfargument name="MontoAnt" 			type="numeric" 	required="yes">	
		<cfargument name="GELid" 				type="numeric" 	required="no">	
		
		<cfif isdefined('GELid') and len(trim(#GELid#)) gt 0>
			<cfquery name="rsGELVfechaIni" datasource="#session.dsn#">
				select coalesce(min(<cf_dbfunction name="date_format"	args="GELVfechaIni,DD/MM/YYYY"> ),
				       (select <cf_dbfunction name="date_format"	args="a.GELfecha ,DD/MM/YYYY">  
					   		from GEliquidacion a 
							where a.GELid = #GELid#)
						) as GELVfechaIni 
					from GEliquidacionViaticos
					where GELid=#GELid# 
			</cfquery>	
			
			<cfset fechaIni=#rsGELVfechaIni.GELVfechaIni#>
		</cfif>
	
		<cfset LvarMes= DATEPART("M",fechaIni)>
		
		<cfquery name="rsAnticipo" datasource="#session.dsn#">
			select coalesce(sum(GELtotalGastos),0) as Maximo
			  from GEliquidacion a 
				inner join TESbeneficiario b
					on a.TESBid=b.TESBid
			 where a.Ecodigo= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			   and a.GELestado in(2,4,5)  <!--- DEBE SER 2=aprobada 4=Pagado 5=reintegrar --->
			   and b.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
			   and a.GEAviatico='1'
			   and a.GEAtipoviatico='1'
			   and (
			   		select coalesce( <cf_dbfunction name="date_part"	args="mm, min(GELVfechaIni)"> , <cf_dbfunction name="date_part"	args="mm, a.GELfecha"> )
					  from  GEliquidacionViaticos c
					 where a.GELid = c.GELid
					)  = #LvarMes#
		</cfquery>
		
		<!---Monto maximo de viaticos al interior definido en parametrosGE--->
		<cfquery name="rsMontoMax" datasource="#Session.DSN#">
			select Pvalor
				from Parametros
				where Ecodigo=#session.Ecodigo#
				and Pcodigo=1201
		</cfquery>
		
		<cfset LvarMontoMax=#rsAnticipo.Maximo#+#MontoAnt#>  
		<cfif  LvarMontoMax gt rsMontoMax.Pvalor>
						
			<cfquery name="rsAnticipo2" datasource="#session.dsn#">
				select a.GELid,a.GELnumero,a.GELtotalGastos,a.GELdescripcion,<cf_dbfunction name="date_format"	args="a.GELfecha,DD/MM/YYYY" > as GELfecha
				from GEliquidacion a 
				inner join TESbeneficiario b
				on a.TESBid=b.TESBid
			
				where 
					a.Ecodigo= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
					and a.GELestado in(2,4,5)  <!--- DEBE SER 2=aprobada 4=Pagado 5=reintegrar--->
					and b.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
					and a.GEAviatico='1'
					and a.GEAtipoviatico='1'
					<!---and <cf_dbfunction name="date_part"	args="mm, a.GELfecha"> = #LvarMes#--->
                    and
					((select <cf_dbfunction name="date_part"	args="mm, min(GELVfechaIni)">
						from  GEliquidacionViaticos c
						where a.GELid = c.GELid)  = #LvarMes#)
					order by GELfecha
			</cfquery>
			
			<cfoutput>
				<font color="FF0000" size="+2">
					El empleado sobrepasa el monto máximo de: #rsMontoMax.Pvalor# definido en parámetros de GE, pues suma un total de:#rsAnticipo.Maximo# en liquidaciones  
					y sobrepasaría el total si se suma el monto de la actual operación: #MontoAnt#.
				</font>			
				<table border="1" width="75%" bordercolor="333399">
					<tr>
						<td align="center"><strong><font color="0000FF">
							Fecha
						</font></strong>
						</td>				
						<td align="center"><strong><font color="0000FF">
							Numero Liquidacion</font></strong>
						</td><td align="center"><strong><font color="0000FF">
							Monto
						</font></strong>
						</td>				
						<td align="center"><strong><font color="0000FF">
							Descripcion</font></strong>
						</td>
					</tr>
					<cfloop query="rsAnticipo2">
						<tr>
							<td>#GELfecha#</td>
							<td>#GELnumero#</td>
							<td>#GELtotalGastos#</td>
							<td>#GELdescripcion#</td>
						</tr>
					</cfloop>	
					<tr>
						<td colspan="4">
							Solución realice la operación en otra fecha de pago o modifique el monto máximo de viáticos al interior por mes en parametros de GE.  
						</td>
					</tr>
				</table>	
			</cfoutput>	
			<cf_abort errorInterfaz="El empleado sobrepasa el monto máximo de: #rsMontoMax.Pvalor# definido en parámetros de GE">
		</cfif>	
	</cffunction>	
</cfcomponent>


