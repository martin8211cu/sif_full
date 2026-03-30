<cfif isdefined ('url.GELid') and len(trim(url.GELid)) >
	<cfset form.GELid = url.GELid>
</cfif>
<!---Aprueba por Tesoreria--->
<cfquery name="Busqueda" datasource="#session.dsn#">
	select GELid,GELtotalGastos,CCHTid,CFid,TESBid,Mcodigo,Ecodigo,GELreembolso from GEliquidacion
	where GELid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
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
					on c.GELid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
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
        <cf_translate key = LB_ElEmpleadoTieneAnticiposConSaldosEnContraQueDebeLiquidarAntesDePoderleReintegarDinero xmlfile="LiquidacionAnticiposTesoreria.xml">
		El empleado tiene Anticipos con saldos en contra que debe liquidar antes de poderle reintegar dinero
        </cf_translate>
		</font>			
		<table border="1" width="75%" bordercolor="333399">
			<tr>
				<td align="center"><strong><font color="0000FF">
                <cf_translate key = LB_NumeroAnticipo xmlfile="LiquidacionAnticiposTesoreria.xml">
					Numero Anticipo
                </cf_translate>
				</font></strong>
				</td>				
				<td align="center"><strong><font color="0000FF">
                <cf_translate key = LB_SaldoLiquidar xmlfile="LiquidacionAnticiposTesoreria.xml">
					Saldo a Liquidar
                </cf_translate>
                </font></strong>
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
			where a.GELid=<cfqueryparam value="#form.GELid#" cfsqltype="cf_sql_numeric">
		</cfquery>
		
		<cfloop query="rsSQLA">
			<cfquery name="Cualquier" datasource="#session.dsn#">
				update GEliquidacionAnts 
				set Linea=#lineax#
				where GEADid=#rsSQLA.GEADid#
				and GELid=<cfqueryparam value="#form.GELid#" cfsqltype="cf_sql_numeric">
			</cfquery>
			<cfset lineax= #lineax#+1>
		</cfloop>
		
		<cfquery name="rsSQLG" datasource="#session.dsn#">
			select b.GELid,b.GELGid from GEliquidacionGasto  b
			inner join GEliquidacion l
			on b.GELid=l.GELid	
			where l.GELid=<cfqueryparam value="#form.GELid#" cfsqltype="cf_sql_numeric">
		</cfquery>
		
		<cfloop query="rsSQLG">
			<cfquery name="updateGastos" datasource="#session.dsn#">
				update GEliquidacionGasto set Linea=#lineax#
				where GELGid=#rsSQLG.GELGid#
				and GELid=<cfqueryparam value="#form.GELid#" cfsqltype="cf_sql_numeric">
			</cfquery>
			<cfset lineax= #lineax#+1>
		</cfloop>
		
		<cfquery name="rsSQLD" datasource="#session.dsn#">
			select b.GELid,b.GELDid from GEliquidacionDeps b
			inner join GEliquidacion l
			on b.GELid=l.GELid	
			where l.GELid=<cfqueryparam value="#form.GELid#" cfsqltype="cf_sql_numeric">
		</cfquery>	
		
		<cfloop query="rsSQLD">
			<cfquery name="updateDeposito" datasource="#session.dsn#">
				update GEliquidacionDeps set Linea=#lineax#
				where GELDid=#rsSQLD.GELDid#
				and GELid=<cfqueryparam value="#form.GELid#" cfsqltype="cf_sql_numeric">
			</cfquery>
			<cfset lineax= #lineax#+1>
		</cfloop><!---*****--->
		
		<cfset LobjControl = createObject( "component","sif.Componentes.PRES_Presupuesto")>
		<cfset LobjControl.CreaTablaIntPresupuesto (session.dsn)/>
		<cfinvoke component="sif.Componentes.CG_GeneraAsiento" returnvariable="INTARC" method="CreaIntarc">
		<cftransaction>
			<cfquery datasource="#session.dsn#" name="rsForm">
				select
				GELtipo,TESBid,GELfecha,Mcodigo,CFid,GELdescripcion,,GELnumero
				,GELreembolso
				from GEliquidacion a	
				where a.Ecodigo	= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and a.GELid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
				and a.GELtipo	= 7
			</cfquery>
				GELtipoCambio
			<cfset valorf=0>
			<cfinvoke component="sif.tesoreria.Componentes.TESgastosEmpleado" method="sbAprobarLiquidacionSinOP" returnVariable="rs">
				<cfinvokeargument name="TESBid" 		 	value="#rsForm.TESBid#">
				<cfinvokeargument name="GELfecha" 	 		value="#rsForm.GELfecha#">
				<cfinvokeargument name="Mcodigo" 			value="#rsForm.Mcodigo#"> 	
				<cfinvokeargument name="CFid" 				value="#rsForm.CFid#">
				<cfinvokeargument name="GELreembolso" 		value="#rsForm.GELreembolso#">
				<cfinvokeargument name="GELtipo" 			value="#rsForm.GELtipo#">  
				<cfinvokeargument name="GELdescripcion" 	value="#rsForm.GELdescripcion#"> 
				<cfinvokeargument name="GELtipoCambio"		value="#rsForm.GELtipoCambio#">
				<cfinvokeargument name="GELnumero"			value="#rsForm.GELnumero#">
				<cfinvokeargument name="GELid"  	 		value="#form.GELid#"> 
				<cfinvokeargument name="LvarSigno"			value="#valorf#"> 
			</cfinvoke>
			
			<cfquery datasource="#session.dsn#" name="rsUpdate">
				Update  GEliquidacion 
				set GELestado=<cfqueryparam cfsqltype="cf_sql_numeric" value="2">,
				TESSPid=#rs#
				where GELid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">		
			</cfquery>				
		</cftransaction>

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
			e.GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#" null="#Len(form.GELid) Is 0#">
			and a.GELid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#" null="#Len(form.GELid) Is 0#">
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
			where GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#" null="#Len(form.GELid) Is 0#">
		</cfquery>
		<cfquery name="ActualizaEncabe" datasource="#session.dsn#">
			update GEliquidacion
					set GELestado= 4
			where GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#" null="#Len(form.GELid) Is 0#">	
		</cfquery>
			
	</cfif>	
			
	<cfset lineax = 1>

	<cfquery name="rsSQLA" datasource="#session.DSN#">
		select a.GELid,a.GEADid from GEliquidacionAnts  a
		inner join GEliquidacion l
		on  a.GELid=l.GELid	
		where a.GELid=<cfqueryparam value="#form.GELid#" cfsqltype="cf_sql_numeric">
	</cfquery>
			
	<cfloop query="rsSQLA">
		<cfquery name="Cualquier" datasource="#session.dsn#">
			update GEliquidacionAnts 
			set Linea=#lineax#
			where GEADid=#rsSQLA.GEADid#
			and GELid=<cfqueryparam value="#form.GELid#" cfsqltype="cf_sql_numeric">
		</cfquery>
		<cfset lineax= #lineax#+1>
	</cfloop>

	<cfquery name="rsSQLG" datasource="#session.dsn#">
		select b.GELid,b.GELGid from GEliquidacionGasto  b
		inner join GEliquidacion l
		on b.GELid=l.GELid	
		where l.GELid=<cfqueryparam value="#form.GELid#" cfsqltype="cf_sql_numeric">
	</cfquery>
				
	<cfloop query="rsSQLG">
		<cfquery name="updateGastos" datasource="#session.dsn#">
			update GEliquidacionGasto set Linea=#lineax#
			where GELGid=#rsSQLG.GELGid#
			and GELid=<cfqueryparam value="#form.GELid#" cfsqltype="cf_sql_numeric">
		</cfquery>
		<cfset lineax= #lineax#+1>
	</cfloop>
				
	<cfquery name="rsSQLD" datasource="#session.dsn#">
		select b.GELid,b.GELDid, l.Mcodigo
		  from GEliquidacionDeps b
			 inner join GEliquidacion l
				on b.GELid=l.GELid	
		 where l.GELid=<cfqueryparam value="#form.GELid#" cfsqltype="cf_sql_numeric">
	</cfquery>
				
	<cfloop query="rsSQLD">
		<cfquery name="updateDeposito" datasource="#session.dsn#">
			update GEliquidacionDeps set Linea=#lineax#
			where GELDid=#rsSQLD.GELDid#
			and GELid=<cfqueryparam value="#form.GELid#" cfsqltype="cf_sql_numeric">
		</cfquery>
		<cfset lineax= #lineax#+1>
	</cfloop><!---*****--->

	<cfset LobjControl = createObject( "component","sif.Componentes.PRES_Presupuesto")>
	<cfset LobjControl.CreaTablaIntPresupuesto (session.dsn)/>
	<cfinvoke component="sif.Componentes.CG_GeneraAsiento" returnvariable="INTARC" method="CreaIntarc">
	<cftransaction>
		<cfinvoke component="sif.tesoreria.Componentes.TESgastosEmpleado" method="sbAprobarLiquidacionSinOP" >
			<cfinvokeargument name="GELid" 		value="#form.GELid#"> 
		</cfinvoke>
	</cftransaction>
</cfif>

<!---Actualiza el estado de las transacciones En proceso He inserta en seguimiento--->
<cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="CambiaEstadoTP">
	<cfinvokeargument name="CCHTid"    			value="#Busqueda.CCHTid#"/>
	<cfinvokeargument name="CCHTestado" 		value="EN APROBACION TES"/>
	<cfinvokeargument name="CCHtipo"    		value="#url.LvarTipo#"/>
	<cfinvokeargument name="CCHTrelacionada"    value="#Busqueda.GELid#"/>
	<cfinvokeargument name="CCHTtrelacionada"   value="GASTO"/>
</cfinvoke>
<!---Retorna--->

<cfif isdefined ('url.referencia') and url.referencia eq 'LA'>
	<cflocation url="LiquidacionAnticipos.cfm">
<cfelse>
	<cflocation url="AprobarTrans.cfm">
</cfif>
