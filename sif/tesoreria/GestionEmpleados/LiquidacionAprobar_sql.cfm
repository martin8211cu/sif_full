<!---Ir a lista--->
<cfif IsDefined("form.irLista")>
</script>
	<cflocation url="AprobarTrans.cfm">
</cfif>


<cfquery datasource="#session.dsn#" name="rsLiquidacion">
	select GELid,GELtotalGastos,CCHTid, CFid,GEAviatico,GEAtipoviatico 
	from GEliquidacion 
	where GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">	
</cfquery>
<cfset LvarCCHTid=rsLiquidacion.CCHTid>

<cfif IsDefined("form.Aprobar")>
	
	<!---Validacion para que no permita la creacion de una liq directa si tiene anticipos pendientes de liquidar--->
	<cfinvoke component="sif.tesoreria.Componentes.GEvalidaciones" method="LiqDirAnticiposSinLiquidarMismoTipo">
		<cfinvokeargument name="GELid"  		value="#form.GELid#">
		<!---<cfinvokeargument name="DEid"  			value="#form.DEid#">--->
	</cfinvoke>
	
	<!---Si es viatico e interior --->
	<cfif #rsLiquidacion.GEAviatico# eq 1 and #rsLiquidacion.GEAtipoviatico# eq 1>
		<!---Valida que no sobrepase el monto máximo de viáticos al interior definido en parametrosGE--->
		<cfinvoke component="sif.tesoreria.Componentes.GEvalidaciones" method="MontoMaxViaticoInt">
			<cfinvokeargument name="DEid"  			value="#form.DEid#">
			<cfinvokeargument name="MontoAnt"  		value="#rsLiquidacion.GELtotalGastos#">
			<cfinvokeargument name="GELid"  		value="#form.GELid#">
		</cfinvoke>	
	</cfif>
	
	<cfset LvarTipo='GASTO'>
	<cfif isdefined ('form.FormaPago') and form.FormaPago EQ 0>
		<cftransaction>
			<!---Proceso Aprobacion Tesoreria--->
			<cfset LobjControl = createObject( "component","sif.Componentes.PRES_Presupuesto")>
			<cfset LobjControl.CreaTablaIntPresupuesto (session.dsn)/>
			<cfinvoke component="sif.Componentes.CG_GeneraAsiento" returnvariable="INTARC" method="CreaIntarc">
				<cfinvoke component="sif.tesoreria.Componentes.TESgastosEmpleado" method="ALTESORERIA">
				<cfinvokeargument name="GELid" 					value="#form.GELid#"/>
				<cfinvokeargument name="referencia" 			value="LT"/>
			</cfinvoke>
		</cftransaction>
	<cfelseif isdefined ('form.FormaPago') and form.FormaPago neq 0>
	<!---Proceso Aprobacion Caja Chica--->
		<cftransaction>
			<cfinvoke component="sif.tesoreria.Componentes.TESgastosEmpleado" method="ALCAJACHICA">
				<cfinvokeargument name="GELid" 				value="#form.GELid#"/>
				<cfinvokeargument name="CCHid" 				value="#form.FormaPago#"/>
			</cfinvoke>
		</cftransaction>
	</cfif>
	<cfif isdefined ('form.FormaPago') and form.FormaPago NEQ 0  and isdefined ('form.chkImprimir') and form.chkImprimir eq 1>
		<cflocation url="LiquidacionImprimirCCH.cfm?GELid=#form.GELid#&url=AprobarTrans.cfm">					
	<cfelseif isdefined ('form.FormaPago') and form.FormaPago EQ 0  and isdefined ('form.chkImprimir') and form.chkImprimir eq 1>
		<cflocation url="LiquidacionImpresion_form.cfm?GELid=#form.GELid#&url=AprobarTrans.cfm"> 
	</cfif>	
	<cflocation url="AprobarTrans.cfm">
</cfif>


<!---Rechazar--->
<cfif IsDefined("form.Rechazar")>
	<cfquery name="ActualizaDet" datasource="#session.dsn#">
			update GEliquidacionGasto 
			   set  GELGestado = 3
			 where GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#" null="#Len(form.GELid) Is 0#">
	</cfquery>
	<cfquery name="ActualizaEncabe" datasource="#session.dsn#">
		update GEliquidacion
			set GELestado= 3
		where GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#" null="#Len(form.GELid) Is 0#">
	</cfquery>

<!---MOTIVO DE RECHAZO --->

	<cfquery name="ActualizaEncabe3" datasource="#session.dsn#">
		update GEliquidacion
		 set  GELmsgRechazo ='#msgRechazo#',
		 UsucodigoRechazo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		where GELid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#" null="#Len(form.GELid) Is 0#">
	</cfquery>
	<cfquery name="EliminaDetalles" datasource="#session.dsn#">
		delete from  GEliquidacionAnts
			where GELid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#" null="#Len(form.GELid) Is 0#">
	</cfquery>
	<cfif isdefined ('form.FormaPago') and form.FormaPago NEQ 0  and isdefined ('form.chkImprimir') and form.chkImprimir eq 1>
		<cflocation url="LiquidacionImprimirCCH.cfm?GELid=#form.GELid#&url=AprobarTrans.cfm">					
	<cfelseif isdefined ('form.FormaPago') and form.FormaPago EQ 0  and isdefined ('form.chkImprimir') and form.chkImprimir eq 1>
		<cflocation url="LiquidacionImpresion_form.cfm?GELid=#form.GELid#&url=AprobarTrans.cfm"> 
	</cfif>		
<cflocation url="AprobarTrans.cfm">

</cfif>


