	
	<cfif isdefined ('form.CCHid') and len(trim(form.CCHid)) gt 0>
		<cfquery name="rsCFid" datasource="#session.dsn#">
			select CFid from CCHica where CCHid= #form.CCHid# and Ecodigo=#session.Ecodigo#
		</cfquery>
		
		<cfquery name="rsSPaprobador" datasource="#session.dsn#">
			Select count(1) as cantidad
			from TESusuarioSP
			where CFid = #rsCFid.CFid#
				and Usucodigo  = #session.Usucodigo#
				and TESUSPaprobador = 1
		</cfquery>
	</cfif>
<!---                                  Agregar                                           --->
<cfif isdefined ('form.Agregar')>

	<cfquery name="rsSQL" datasource="#session.dsn#">
		select CFcuenta, Mcodigo, CCHresponsable from CCHica where CCHid=#form.CCHid#
		and Ecodigo=#session.Ecodigo#
	</cfquery>
	
	<cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="TranProceso" returnvariable="LvarCCHTidProc">
		<cfinvokeargument name="Mcodigo" value="#rsSQL.Mcodigo#"/>
		<cfinvokeargument name="CFcuenta" value="#rsSQL.CFcuenta#"/>
		<cfinvokeargument name="CCHTdescripcion" value="#form.descrip#"/>
		<cfinvokeargument name="CCHTestado" value="EN PROCESO"/>
		<cfinvokeargument name="CCHTmonto" value="0"/>
		<cfinvokeargument name="CCHTidCustodio" value="#rsSQL.CCHresponsable#"/>
		<cfinvokeargument name="CCHTtipo" value="REINTEGRO"/>
		<cfinvokeargument name="CCHid" value="#form.CCHid#"/>
	</cfinvoke>
	
	<cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="UP_importes">
		<cfinvokeargument name="CCHid"					 value="#form.CCHid#"/>
		<cfinvokeargument name="CCHTid" 				 value="#LvarCCHTidProc#"/>
		<cfinvokeargument name="CCHIreintegroEnProceso"  value="0"/>			
	</cfinvoke>

	<cfquery name="rsReintegro" datasource="#session.dsn#">
			select a.CCHTAid,a.CCHTAtranRelacionada, b.GELdescripcion,b.GELdescripcion,b.GELfecha,b.GELtotalGastos,b.GELtotalAnticipos,b.GELtotalDevoluciones,b.GELnumero
			from CCHTransaccionesAplicadas a
				inner join CCHTransaccionesProceso c
					inner join GEliquidacion b
					 	on c.CCHTrelacionada=b.GELid
						and b.GELestado=5
				on CCHTAtranRelacionada=c.CCHTid
			where a.CCHTtipo='GASTO' 
			and CCHTAreintegro < 0 
			and a.CCHid= #form.CCHid#
	</cfquery>
	
	<cfloop query="rsReintegro">
		<cfquery name="rsUpRe" datasource="#session.dsn#">
			update CCHTransaccionesAplicadas set CCHTAreintegro=#LvarCCHTidProc# where CCHTAid=#rsReintegro.CCHTAid#
		</cfquery>
	</cfloop>

	<cfif rsSPaprobador.cantidad gt 0>
		<cflocation url="CCHReintegro.cfm?CCHTid=#LvarCCHTidProc#&Apro=1">
	<cfelse>
		<cflocation url="CCHReintegro.cfm?CCHTid=#LvarCCHTidProc#&CCHid=#form.CCHid#">
	</cfif>
</cfif>

<!---                                  Regresar                                           --->
<cfif isdefined ('form.Regresar')>
	<cflocation url="CCHReintegro.cfm">
</cfif>

<!---                                  Limpiar                                           --->
<cfif isdefined ('form.Limpiar')>
	<cflocation url="CCHReintegro.cfm?Nuevo=nuevo">
</cfif>

<!---                                  Aplicar                                           --->
<cfif isdefined ('form.BtnAplicar')>
	<cfloop list="#form.chk#" delimiters="," index="re">
			<cfset CCHTAid=#listgetat(re, 1, ',')#>
			<cfquery name="rsUpRe" datasource="#session.dsn#">
				update CCHTransaccionesAplicadas set CCHTAreintegro=#form.CCHTid# where CCHTAid=#CCHTAid#
			</cfquery>
	</cfloop>
		<cflocation url="CCHReintegro.cfm?CCHTid=#form.CCHTid#&CCHid=#form.CCHid#">
</cfif>


<!---                                  Borrar Linea2                                      --->
<cfif isdefined ('form.btnElimina')>
<cfif not isdefined ('form.eli') or len(trim(form.eli)) eq 0>
	<cf_errorCode	code = "51701" msg = "No se escogio ninguna liquidación">
</cfif>
	<cfloop list="#form.eli#" delimiters="," index="Lvar">
		<cfset LvarCCHTAid=#listgetat(Lvar, 1, ',')#>	
		<cfquery name="rsUpRe" datasource="#session.dsn#">
				update CCHTransaccionesAplicadas set CCHTAreintegro=-1 where CCHTAid=#LvarCCHTAid#
		</cfquery>
	</cfloop>
	<cfif rsSPaprobador.cantidad gt 0>
		<cflocation url="CCHReintegro.cfm?CCHTid=#form.CCHTid#&Apro=1&CCHid=#form.CCHid#">
	<cfelse>
		<cflocation url="CCHReintegro.cfm?CCHTid=#form.CCHTid#&CCHid=#form.CCHid#">
	</cfif>
</cfif>


<!---                                  Agregar Linea2                                      --->
<cfif isdefined ('form.btnAgrega')>
<cfif not isdefined ('form.agr') or len(trim(form.agr)) eq 0>
	<cf_errorCode	code = "51701" msg = "No se escogio ninguna liquidación">
</cfif>
	<cfloop list="#form.agr#" delimiters="," index="Lvar">
		<cfset LvarCCHTAid=#listgetat(Lvar, 1, ',')#>	
		<cfquery name="rsUpRe" datasource="#session.dsn#">
				update CCHTransaccionesAplicadas set CCHTAreintegro=#form.CCHTid#
				where CCHTAid= #LvarCCHTAid#
		</cfquery>
	</cfloop>
	<cfif rsSPaprobador.cantidad gt 0>
		<cflocation url="CCHReintegro.cfm?CCHTid=#form.CCHTid#&Apro=1&CCHid=#form.CCHid#">
	<cfelse>
		<cflocation url="CCHReintegro.cfm?CCHTid=#form.CCHTid#&CCHid=#form.CCHid#">
	</cfif>
</cfif>

<!---                                  Nuevo                                            --->
<cfif isdefined ('form.Nuevo')>
	<cflocation url="CCHReintegro.cfm?Nuevo=1">
</cfif>

<!---                                  Eliminar                                          --->
<cfif isdefined ('form.Eliminar')>
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select CCHTestado from CCHTransaccionesProceso where CCHTid=#form.CCHTid#
	</cfquery>
		<cfif rsSQL.CCHTestado eq 'EN PROCESO'>
			<cfquery name="dl1" datasource="#session.dsn#">
				delete  from STransaccionesProceso where CCHTid=#form.CCHTid#
			</cfquery>
			<cfquery name="dl1" datasource="#session.dsn#">
				delete  from CCHTransaccionesProceso where CCHTid=#form.CCHTid#
			</cfquery>
				<cfquery name="rsReintegro" datasource="#session.dsn#">
					select a.CCHTAid
					from CCHTransaccionesAplicadas a
					where a.CCHTtipo='GASTO' 
					and CCHTAreintegro = #form.CCHTid# 
				</cfquery>				
				<cfloop query="rsReintegro">
					<cfquery name="rsUpRe" datasource="#session.dsn#">
						update CCHTransaccionesAplicadas set CCHTAreintegro=-1 where CCHTAid=#rsReintegro.CCHTAid#
					</cfquery>
				</cfloop>
		<cfelse>
			<cf_errorCode	code = "50732" msg = "No se puede eliminar una transacción que tiene estado diferente a 'EN PROCESO'">
		</cfif>
		<cflocation url="CCHReintegro.cfm">
</cfif>

<!---                                  Modificar                                          --->
<cfif isdefined ('form.Modificar')>
	<cfquery name="rsUpRe" datasource="#session.dsn#">
		update CCHTransaccionesProceso set CCHTdescripcion='#form.descrip#' where CCHTid=#form.CCHTid#
	</cfquery>
	<cflocation url="CCHReintegro.cfm?CCHTid=#form.CCHTid#&CCHid=#form.CCHid#">
</cfif>

<!---                                 Enviar                                             --->
<cfif isdefined ('form.Enviar')>
	<cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="modificarTP">
		<cfinvokeargument name="CCHTid" value="#form.CCHTid#"/>
		<cfinvokeargument name="CCHTtipo" value="REINTEGRO"/>
		<cfinvokeargument name="CCHTmontoA" value="#replace(form.montoA,',','','ALL')#"/>
		<cfinvokeargument name="CCHTdescripcion" value="#form.descrip#"/>
		<cfinvokeargument name="CCHid" value="#form.CCHid#"/>
	</cfinvoke>
	
	<cfquery name="rsSQL" datasource="#session.dsn#">
		update CCHTransaccionesProceso set CCHTestado='EN APROBACION CCH' where CCHTid=#form.CCHTid#
	</cfquery>

	<cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="CambiaEstadoTP">
		<cfinvokeargument name="CCHTid" 	value="#form.CCHTid#"/>
		<cfinvokeargument name="CCHTestado" value="EN APROBACION CCH"/>
		<cfinvokeargument name="CCHtipo" 	value="REINTEGRO"/>
	</cfinvoke>	
	<cflocation url="CCHReintegro.cfm">
</cfif>


<!---                                Aprobar                                             --->
<cfif isdefined ('form.aprobar')>

	<cfset LobjControl = createObject( "component","sif.Componentes.PRES_Presupuesto")>
	<cfset LobjControl.CreaTablaIntPresupuesto (session.dsn)/>


	<cftransaction>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select CCHTestado,CCHTtipo,CCHTdescripcion from CCHTransaccionesProceso where CCHTid=#form.CCHTid#
		</cfquery>
		<cfif rsSQL.CCHTestado eq 'EN PROCESO'>
			<cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="modificarTP">
				<cfinvokeargument name="CCHTid" value="#form.CCHTid#"/>
				<cfinvokeargument name="CCHTtipo" value="REINTEGRO"/>
				<cfinvokeargument name="CCHTmontoA" value="#replace(form.montoA,',','','ALL')#"/>
				<cfinvokeargument name="CCHTdescripcion" value="#rsSQL.CCHTdescripcion#"/>
				<cfinvokeargument name="CCHid" value="#form.CCHid#"/>
			</cfinvoke>
		
			<cfquery name="rsSQL1" datasource="#session.dsn#">
				update CCHTransaccionesProceso set CCHTestado='EN APROBACION CCH' where CCHTid=#form.CCHTid#
			</cfquery>
		
			<cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="CambiaEstadoTP">
				<cfinvokeargument name="CCHTid" 	value="#form.CCHTid#"/>
				<cfinvokeargument name="CCHTestado" value="EN APROBACION CCH"/>
				<cfinvokeargument name="CCHtipo" 	value="REINTEGRO"/>
			</cfinvoke>	
		</cfif>
	
		<cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="modificarTP">
			<cfinvokeargument name="CCHTid" value="#form.CCHTid#"/>
			<cfinvokeargument name="CCHTtipo" value="REINTEGRO"/>
			<cfinvokeargument name="CCHTmontoA" value="#replace(form.montoA,',','','ALL')#"/>
			<cfinvokeargument name="CCHTdescripcion" value="#rsSQL.CCHTdescripcion#"/>
			<cfinvokeargument name="CCHid" value="#form.CCHid#"/>
		</cfinvoke>
	
		<cfquery name="rsSQ2L" datasource="#session.dsn#">
			update CCHTransaccionesProceso set CCHTestado='EN APROBACION TES' where CCHTid=#form.CCHTid#
		</cfquery>
	

		<cfquery name="rsCCH" datasource="#session.dsn#">
			select CFcuenta,CCHresponsable,Mcodigo,CFid from CCHica where CCHid=#form.CCHid#
		</cfquery>
	
		<cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="crearSPreintegro" returnvariable="TESSPid">
			<cfinvokeargument name="CCHid" 				value="#form.CCHid#">
			<cfinvokeargument name="CCHtipo" 			value="8">
			<cfinvokeargument name="DEid" 				value="#rsCCH.CCHresponsable#"> 
			<cfinvokeargument name="CCHfechaPagar" 		value="#LSDateFormat(now(),'DD/MM/YYYY')#"> 
			<cfinvokeargument name="Mcodigo" 			value="#rsCCH.Mcodigo#"> 			
			<cfinvokeargument name="CCHtotalOri" 		value="#replace(form.montoA,',','','ALL')#"> 		
			<cfinvokeargument name="CFid" 				value="#rsCCH.CFid#"> 
			<cfinvokeargument name="CFcuenta"  			value="#rsCCH.CFcuenta#"> 			
			<cfinvokeargument name="CCHdescripcion" 	value="#rsSQL.CCHTdescripcion#">  
			<cfinvokeargument name="CCHtransaccion"  	value="#form.CCHTid#"> 
			<cfinvokeargument name="CCHcod"  			value="#form.CCHcod#"> 
			<cfinvokeargument name="CCHTid"   	 		value="#form.CCHTid#">
			<cfinvokeargument name="CCHreferencia"    	value="REINTEGRO">
		</cfinvoke>	

		<cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="CambiaEstadoTP">
			<cfinvokeargument name="CCHTid" 	value="#form.CCHTid#"/>
			<cfinvokeargument name="CCHTestado" value="EN APROBACION TES"/>
			<cfinvokeargument name="CCHtipo" 	value="REINTEGRO"/>
			<cfinvokeargument name="CCHTrelacionada" 	value="#TESSPid#"/>
			<cfinvokeargument name="CCHTtrelacionada" 	value="Solicitud de Pago"/>
		</cfinvoke>	

		<cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="CambiaEstadoTP">
			<cfinvokeargument name="CCHTid" 	value="#form.CCHTid#"/>
			<cfinvokeargument name="CCHTestado" value="POR CONFIRMAR"/>
			<cfinvokeargument name="CCHtipo" 	value="REINTEGRO"/>
		</cfinvoke>	
	</cftransaction>
		<cflocation url="CCHReintegro.cfm">	
</cfif>





