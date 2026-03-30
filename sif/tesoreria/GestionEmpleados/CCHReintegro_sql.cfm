<!---                                  Regresar                                           --->
<cfif isdefined ('form.Regresar')>
	<cflocation url="CCHReintegro.cfm">
</cfif>

<!---                                  Limpiar                                           --->
<cfif isdefined ('form.Limpiar')>
	<cflocation url="CCHReintegro.cfm?Nuevo=nuevo">
</cfif>

<!---                                  Nuevo                                            --->
<cfif isdefined ('form.Nuevo')>
	<cflocation url="CCHReintegro.cfm?Nuevo=1">
</cfif>
	
<cfif isdefined ('form.CCHid') and len(trim(form.CCHid)) gt 0>
	<cfquery name="rsCCHid" datasource="#session.dsn#">
		select CFid, CCHtipo from CCHica where CCHid= #form.CCHid# and Ecodigo=#session.Ecodigo#
	</cfquery>
	
	<cfquery name="rsSPaprobador" datasource="#session.dsn#">
		Select count(1) as cantidad
		from TESusuarioSP
		where CFid = #rsCCHid.CFid#
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
	
	<cfinvoke 	component="sif.tesoreria.Componentes.TEScajaChica" 
				method="TranProceso" 
				returnvariable="LvarCCHTidProc">
		<cfinvokeargument name="Mcodigo" value="#rsSQL.Mcodigo#"/>
		<cfinvokeargument name="CFcuenta" value="#rsSQL.CFcuenta#"/>
		<cfinvokeargument name="CCHTdescripcion" value="#form.descrip#"/>
		<cfinvokeargument name="CCHTestado" value="EN PROCESO"/>
		<cfinvokeargument name="CCHTmonto" value="0"/>
		<cfinvokeargument name="CCHTidCustodio" value="#rsSQL.CCHresponsable#"/>
		<cfinvokeargument name="CCHTtipo" value="REINTEGRO"/>
		<cfinvokeargument name="CCHid" value="#form.CCHid#"/>
	</cfinvoke>
	
	<cfif rsCCHid.CCHtipo EQ 1>
		<cfquery name="rsReintegro" datasource="#session.dsn#">
			select a.CCHTAid,a.CCHTAtranRelacionada, b.GELdescripcion,b.GELdescripcion,b.GELfecha,b.GELtotalGastos,b.GELtotalAnticipos,b.GELtotalDevoluciones,b.GELnumero
			from CCHTransaccionesAplicadas a
				inner join CCHTransaccionesProceso c
					inner join GEliquidacion b
						 on b.GELid 	= c.CCHTrelacionada
						and b.GELestado	= 5
				on CCHTAtranRelacionada = c.CCHTid
			where a.CCHTtipo	='GASTO' 
			  and CCHTAreintegro < 0 
			  and a.CCHid = #form.CCHid#
		</cfquery>
		
		<cfloop query="rsReintegro">
			<cfquery name="rsUpRe" datasource="#session.dsn#">
				update CCHTransaccionesAplicadas set CCHTAreintegro=#LvarCCHTidProc# where CCHTAid=#rsReintegro.CCHTAid#
			</cfquery>
		</cfloop>
	<cfelseif rsCCHid.CCHtipo EQ 2>
		<cfquery name="rsReintegro" datasource="#session.dsn#">
			update CCHespecialMovs
			   set CCHTid_reintegro = #LvarCCHTidProc#
			where CCHid= #form.CCHid#
			  and CCHTid_reintegro IS NULL
		</cfquery>
	<cfelse>
		<cfthrow message="La caja no puede reintegrarse: tipo = #rsCCHtipo#">		
	</cfif>
	
	<cfif rsSPaprobador.cantidad gt 0>
		<cflocation url="CCHReintegro.cfm?CCHTid=#LvarCCHTidProc#&Apro=1">
	<cfelse>
		<cflocation url="CCHReintegro.cfm?CCHTid=#LvarCCHTidProc#&CCHid=#form.CCHid#">
	</cfif>
</cfif>

<!---                                  Eliminar                                          --->
<cfif isdefined ('form.Eliminar')>
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select CCHTestado from CCHTransaccionesProceso where CCHTid=#form.CCHTid#
	</cfquery>
	<cfif rsSQL.CCHTestado eq 'EN PROCESO'>
		<cfquery name="rsUpRe" datasource="#session.dsn#">
			update CCHespecialMovs set CCHTid_reintegro=null where CCHTid_reintegro = #form.CCHTid# 
		</cfquery>
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
		<cfinvokeargument name="CCHTmontoA" value="#replace(form.montoReintegro,',','','ALL')#"/>
		<cfinvokeargument name="CCHTdescripcion" value="#form.descrip#"/>
		<cfinvokeargument name="CCHid" value="#form.CCHid#"/>
		<cfinvokeargument name="CCHTestado" value="EN APROBACION CCH"/>
	</cfinvoke>
	
	<cflocation url="CCHReintegro.cfm">
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

<!---                                  MOVIMIENTOS DETALLE CAJA CHICA                     --->
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

<!---                                MOVIMIENTOS DETALLE CAJA ESPECIAL                   --->
<!---                                  Borrar Linea2                                      --->
<cfif isdefined ('form.btnEliminaEsp')>
<cfif not isdefined ('form.eli') or len(trim(form.eli)) eq 0>
	<cf_errorCode	code = "51701" msg = "No se escogio ninguna liquidación">
</cfif>
	<cfloop list="#form.eli#" delimiters="," index="Lvar">
		<cfset LvarCCHEMid=#listgetat(Lvar, 1, ',')#>	
		<cfquery name="rsUpRe" datasource="#session.dsn#">
				update CCHespecialMovs set CCHTid_reintegro=null where CCHEMid=#LvarCCHEMid#
		</cfquery>
	</cfloop>
	<cfif rsSPaprobador.cantidad gt 0>
		<cflocation url="CCHReintegro.cfm?CCHTid=#form.CCHTid#&Apro=1&CCHid=#form.CCHid#">
	<cfelse>
		<cflocation url="CCHReintegro.cfm?CCHTid=#form.CCHTid#&CCHid=#form.CCHid#">
	</cfif>
</cfif>


<!---                                  Agregar Linea2                                      --->
<cfif isdefined ('form.btnAgregaEsp')>
<cfif not isdefined ('form.agr') or len(trim(form.agr)) eq 0>
	<cf_errorCode	code = "51701" msg = "No se escogio ninguna liquidación">
</cfif>
	<cfloop list="#form.agr#" delimiters="," index="Lvar">
		<cfset LvarCCHEMid=#listgetat(Lvar, 1, ',')#>	
		<cfquery name="rsUpRe" datasource="#session.dsn#">
				update CCHespecialMovs set CCHTid_reintegro=#form.CCHTid#
				 where CCHEMid= #LvarCCHEMid#
		</cfquery>
	</cfloop>
	<cfif rsSPaprobador.cantidad gt 0>
		<cflocation url="CCHReintegro.cfm?CCHTid=#form.CCHTid#&Apro=1&CCHid=#form.CCHid#">
	<cfelse>
		<cflocation url="CCHReintegro.cfm?CCHTid=#form.CCHTid#&CCHid=#form.CCHid#">
	</cfif>
</cfif>


<!---                                Aprobar                                             --->
<cfif isdefined ('form.aprobar')>

	<cfset LobjControl = createObject( "component","sif.Componentes.PRES_Presupuesto")>
	<cfset LobjControl.CreaTablaIntPresupuesto (session.dsn)/>


	<cftransaction>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select CCHTestado,CCHTtipo,CCHTdescripcion, coalesce(SEC_NAP,0) as SEC_NAP from CCHTransaccionesProceso where CCHTid=#form.CCHTid#
		</cfquery>
		<cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="modificarTP">
			<cfinvokeargument name="CCHTid" value="#form.CCHTid#"/>
			<cfinvokeargument name="CCHTtipo" value="REINTEGRO"/>
			<cfinvokeargument name="CCHTmontoA" value="#replace(form.montoReintegro,',','','ALL')#"/>
			<cfinvokeargument name="CCHTdescripcion" value="#rsSQL.CCHTdescripcion#"/>
			<cfinvokeargument name="CCHid" value="#form.CCHid#"/>
		</cfinvoke>

		<cfif rsSQL.CCHTestado eq 'EN PROCESO'>
			<cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="CambiaEstadoTP">
				<cfinvokeargument name="CCHTid" 	value="#form.CCHTid#"/>
				<cfinvokeargument name="CCHTestado" value="EN APROBACION CCH"/>
				<cfinvokeargument name="CCHtipo" 	value="REINTEGRO"/>
			</cfinvoke>	
		</cfif>
	
		<cfquery name="rsCCH" datasource="#session.dsn#">
			select CFcuenta,CCHresponsable,Mcodigo,CFid,CCHtipo as CCHtipo_caja from CCHica where CCHid=#form.CCHid#
		</cfquery>
		<cfif rsSQL.SEC_NAP gt 0>
        	<cfset form.CCHcod = form.CCHcod&'- #rsSQL.SEC_NAP#'>
        </cfif>
		<cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="crearSPreintegro" returnvariable="TESSPid">
			<cfinvokeargument name="CCHid" 				value="#form.CCHid#">
			<cfinvokeargument name="CCHtipo_caja"		value="#rsCCH.CCHtipo_caja#">
			<cfinvokeargument name="DEid" 				value="#rsCCH.CCHresponsable#"> 
			<cfinvokeargument name="CCHfechaPagar" 		value="#LSDateFormat(now(),'DD/MM/YYYY')#"> 
			<cfinvokeargument name="Mcodigo" 			value="#rsCCH.Mcodigo#"> 			
			<cfinvokeargument name="CCHtotalOri" 		value="#replace(form.montoReintegro,',','','ALL')#"> 		
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
	</cftransaction>
	<cflocation url="CCHReintegro.cfm">	
</cfif>





