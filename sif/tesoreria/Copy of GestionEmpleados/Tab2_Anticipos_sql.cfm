<!---General--->
<cfset mensaje="ERROR">

<cfif isdefined ("form.TESSAid")>
		<cfquery name="id" datasource="#session.dsn#">
			select count(1) as cantidad,TESSAid from GASTOE_SoliAnticipos where
			Ecodigo		= #session.Ecodigo#
			and TESSAid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSAid#">
		</cfquery>
		
		<!---<cfif id.cantidad neq 0>
			<cfquery name="ide" datasource="#session.dsn#">
				select TESSAid  from GASTOE_SoliAnticipos where
				Ecodigo		= #session.Ecodigo#
				and TESSAnumero=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSANumero#">
			</cfquery>
		</cfif>--->
		
		<cfquery name="selectAnti" datasource="#session.dsn#">
			select TESDPaprobadopendiente
			GASTOE_SoliAntiD  where
			TESSADid=<cfqueryparam 	cfsqltype="cf_sql_numeric" 	value="#form.TESSADid#">
		</cfquery>
<cfelse>
<cf_errorCode	code = "50748" msg = "El id de la solicitud de anticipo no esta definido">
</cfif>
<!---<cfset id=#id.TESSAid#>--->

<!---Operaciones--->
<!---	<cfset monto=#selectAnticipos.TESSAMonto#-#selectAnticipos.TESSAMutilizado#>
	<cfset saldo=monto-#form.MontoAnticipo#>
	<cfdump var="#form#">--->
	
<!---ALTA--->
<cfif isdefined("Form.AltaAnt")>
		<cfif selectAnti.TESDPaprobadopendiente LT 0>
				<cflocation url="LiquidacionAnticipos.cfm?ID_liquidacion=#form.ID_liquidacion#&Mensaje=#mensaje#">
		<cfelse>
		<!---<cfdump var="#session.Liquidacion.ID_liquidacion#">--->
				<cfquery name="verificar" datasource="#session.dsn#">
						select TESDPaprobadopendiente from GASTOE_SoliAntiD
						where TESSAid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSAid#">		
				</cfquery>
			<cfif #verificar.TESDPaprobadopendiente# GTE 0>				
			    <cflocation url="LiquidacionAnticipos.cfm?ID_liquidacion=#form.ID_liquidacion#&Mensaje1=#mensaje#">
			<cfelse>
					
					<cfquery name="inserta" datasource="#session.dsn#">
							insert into GASTOE_Ant_xliquidar(
							TESSAid,
							ID_liquidacion,
							TESDPaprobadopendiente
							) values(
							<cfqueryparam 	cfsqltype="cf_sql_numeric" 	value="#form.TESSAid#">, 
							<cfqueryparam 	cfsqltype="cf_sql_numeric"value="#form.ID_liquidacion#">, 
							<cfqueryparam 	cfsqltype="cf_sql_money" value="#form.MontoAnticipo#">)
					</cfquery>	
			<cflocation url="LiquidacionAnticipos.cfm?ID_liquidacion=#form.ID_liquidacion#">	

</cfif>		</cfif>			
	
</cfif>

<!---BUSQUEDA--->
<cfif isdefined("Form.BuscarAnt")>
	<cfset modo="BuscarAnt">
	<cfset form.NumAnticipo=#form.NumAnticipo#>
	<cfset form.ID_liquidacion=#form.ID_liquidacion#>
	<cflocation url="LiquidacionAnticipos.cfm?NumAnticipo=#form.NumAnticipo#">
</cfif>

<!---LIMPIAR--->
<cfif isdefined ("Form.Limpiar")>
		<cflocation url="LiquidacionAnticipos.cfm?ID_liquidacion=#session.Liquidacion.ID_liquidacion#">
</cfif>

<!---ELIMINAR--->
<cfif isdefined ("Form.BajaAnt")>
	<cfquery name="elimina" datasource="#session.dsn#">
			delete from GASTOE_Ant_xliquidar where 
			ID_liquidacion=<cfqueryparam 	cfsqltype="numeric" value="#session.Liquidacion.ID_liquidacion#"> 
			and TESSAid=#form.TESSAid#
	</cfquery>
		<cflocation url="LiquidacionAnticipos.cfm?ID_liquidacion=#session.Liquidacion.ID_liquidacion#">
</cfif>

<!---MODIFICAR--->
<cfif isdefined("Form.CambioAnt")>

	<cfquery name="modificaant" datasource="#session.dsn#">
		update GASTOE_Ant_xliquidar set
		TESDPaprobadopendiente=<cfqueryparam 	cfsqltype="cf_sql_money" value="#form.MontoAnticipo#">
		where ID_liquidacion=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ID_liquidacion#">
		and
		TESSAid=<cfqueryparam 	cfsqltype="cf_sql_numeric" 	value="#form.TESSAid#">	
		<cflocation url="LiquidacionAnticipos.cfm?ID_liquidacion=#form.ID_liquidacion#"> 		
	</cfquery>
</cfif>

<!---NUEVO--->
<cfif isdefined ("Form.NuevoAnt")>
	<cflocation url="LiquidacionAnticipos.cfm?ID_liquidacion=#session.Liquidacion.ID_liquidacion#">
</cfif>

