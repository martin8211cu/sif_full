<cfif not isdefined("cuenta")>

	<script>
	function sumitir(acc)
	{
		document.form1.accion.value = acc;
		if (acc == 1)		
			if (document.form1.cuenta.value =='')
				alert("Es necesario digitar una cuenta válida")
			else
				document.form1.submit();
		else
			document.form1.submit();
	}
	</script>
	
	<cfquery name="rsPrimeraCuenta" datasource="#session.Conta.dsn#">
		select min(CGM1IM) as Cuenta 
		from CGM001 
		where CGM1CD is null
	</cfquery>
	
	<cfquery name="rsLongCuenta" datasource="#session.Conta.dsn#">
		select datalength(convert(varchar, CGM1IM)) as Long 
		from CGM001 
		where CGM1IM = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPrimeraCuenta.Cuenta#">
		  and CGM1CD is null
	</cfquery>
	
	<cfset long = #rsLongCuenta.Long#>
	
	<cfset H_ACTUAL = Hour(Now())>
	<cfset T_ACTUAL = "AM">
	<cfif H_ACTUAL gt 12>
		<cfset H_ACTUAL = H_ACTUAL - 12>
		<cfset T_ACTUAL = "PM">
	</cfif>
	<cfset M_ACTUAL = Minute(Now())>

	<form action="cmn_MantenimientoHoras.cfm" method="post" name="form1" onSubmit="">
        <cfoutput>
			  <table width="100%" border="0">
					<td align="left" colspan="4">
						<input type="button" name="Agregar" value="Agregar Rango" onClick="javascript:sumitir(1)" tabindex="10">
						<input type="button" name="VerLista" value="Rangos Definidos" onClick="javascript:sumitir(3)" tabindex="10">
					</td>
					<!---********************************************************************************* --->			
					<tr>
						<td align="left" colspan="4" nowrap bgcolor="##CCCCCC"><strong>Definicion de Rangos de Horas</strong></td>
					</tr>
					<!---********************************************************************************* --->
					<tr><td colspan="4">&nbsp;</td></tr>
					<tr>
					  	<td align="left" nowrap width="20%"><strong>Cuenta Mayor:</strong>&nbsp;</td>
					  	<td  colspan="3" nowrap>
							<input type="text" name="cuenta" style="width:50px" maxlength="<cfoutput>#long#</cfoutput>">
					  	</td>
					</tr>
					<!---********************************************************************************* --->
					<tr>
					  <td align="left" nowrap><strong>Hora Inicial:</strong>&nbsp;</td>
					  <td nowrap >
					  		<cfoutput>
							<select id="HORA" name="HORA" tabindex="5">
						  	<cfloop from="1" to="12" index="H">
								<cfif H LT 10>
									<option value="#H#" <cfif H EQ H_ACTUAL>selected</cfif>>0#H#</option>
								<cfelse>	
								   <option value="#H#" <cfif H EQ H_ACTUAL>selected</cfif>>#H#</option>
								</cfif>
							</cfloop>
							</select>
						
							<select id="MINUTOS"  name="MINUTOS" tabindex="5">
						  	<cfloop from="0" to="59" index="M">
								<cfif M LT 10>
									<option value="#M#" <cfif M EQ M_ACTUAL>selected</cfif>>0#M#</option>
								<cfelse>	
								   <option value="#M#" <cfif M EQ M_ACTUAL>selected</cfif>>#M#</option>
								</cfif>
							</cfloop>
							</select>
						
							<select  id="PMAM" name="PMAM" tabindex="5">
							<option value="AM" <cfif "AM" EQ T_ACTUAL>selected</cfif>>AM</option>
							<option value="PM" <cfif "PM" EQ T_ACTUAL>selected</cfif>>PM</option>
							</select>
							</cfoutput>
						</td>
					  </td>
					</tr>
					<tr>
					  <td align="left" nowrap><strong>Hora Final:</strong>&nbsp;</td>
					  <td nowrap >
							<cfoutput>
							<select id="HORA1" name="HORA1" tabindex="5">
						  	<cfloop from="1" to="12" index="H">
								<cfif H LT 10>
									<option value="#H#" <cfif H EQ H_ACTUAL>selected</cfif>>0#H#</option>
								<cfelse>	
								   <option value="#H#" <cfif H EQ H_ACTUAL>selected</cfif>>#H#</option>
								</cfif>
							</cfloop>
							</select>
						
							<select id="MINUTOS1"  name="MINUTOS1" tabindex="5">
						  	<cfloop from="0" to="59" index="M">
								<cfif M LT 10>
									<option value="#M#" <cfif M EQ M_ACTUAL>selected</cfif>>0#M#</option>
								<cfelse>	
								   <option value="#M#" <cfif M EQ M_ACTUAL>selected</cfif>>#M#</option>
								</cfif>
							</cfloop>
							</select>
						
							<select  id="PMAM1" name="PMAM1" tabindex="5">
							<option value="AM" <cfif "AM" EQ T_ACTUAL>selected</cfif>>AM</option>
							<option value="PM" <cfif "PM" EQ T_ACTUAL>selected</cfif>>PM</option>
							</select>
							</cfoutput>
					  </td>
					</tr>
				<!---********************************************************************************* --->
				</table>

        </cfoutput>
		<input type="hidden" name="accion">
      </form>
	  
<cfelse>

	<cfif accion eq 1>
						
		<cftry>

			<!--- Verifica si la cuenta es Válida --->
			<cfquery name="rsVerificaCuenta" datasource="#session.Conta.dsn#">
				Select count(1) as T_cuenta
				from CGM001
				where CGM1IM = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cuenta#">
				  and CGM1CD is null 
			</cfquery>
		
			<cfif rsVerificaCuenta.T_cuenta gt 0>
			
				<cfif PMAM eq "PM">
					<cfset fhora = #hora# + 12>
				<cfelse>
					<cfset fhora = #hora#>
				</cfif>
			
				<cfif PMAM1 eq "PM">
					<cfset fhora1 = #hora1# + 12>
				<cfelse>
					<cfset fhora1 = #hora1#>
				</cfif>
							
				<cfset hora_ini = #timeformat(CreateTime(fhora,minutos,0),"HH:mm:ss")#>
				<cfset hora_fin = #timeformat(CreateTime(fhora1,minutos1,0),"HH:mm:ss")#>				
				<cfset diferencia = #datediff("s",hora_ini,hora_fin)#>
													
				<cfif diferencia gt 0>
			
					<!--- Agregar Rango --->
					<cfquery datasource="#session.Conta.dsn#">
						Insert tbl_horariosrep(CGM1IM, HORAini, HORAfin)
						values('#cuenta#','#hora_ini#','#hora_fin#')
					</cfquery>
				
					<script>
						alert("El Rango definido de horas ha sido insertado con exito")
						document.location = "cmn_mantenimientohoras.cfm"
					</script>	
					
				<cfelse>
					
					<script>
						alert("La hora inicial debe ser mayor o igual a la hora final. Verifique")
						document.location = "cmn_mantenimientohoras.cfm"
					</script>					
					
				</cfif>
				
			<cfelse>
			
				<script>
					alert("La cuenta digitada no existe. Verifique.")
					document.location = "cmn_mantenimientohoras.cfm"
				</script>
				
			</cfif>								
				
			<cfcatch type="any">
				<cftransaction action="rollback"/>
				<script>
					var  mensaje = new String("<cfoutput>#trim(cfcatch.Detail)#</cfoutput>");
					mensaje = mensaje.substring(40,300)
					alert(mensaje)
					document.location = "cmn_mantenimientohoras.cfm"
				</script>
			</cfcatch>			

		</cftry>
								
	</cfif>
			
			
			<cfif accion eq 2><cfinclude template="cmn_eliminarrango.cfm"></cfif>
			
			
			<cfif accion eq 3>
			
				<cfquery name="rsVerRangos" datasource="#session.Conta.dsn#">
				Select * 
				from tbl_horariosrep
				order by CGM1IM
				</cfquery>
									  
			
				<table width="100%" border="0">
				<td align="left" colspan="4">
					<input type="button" name="Eliminar" value="Eliminar Rango" onClick="javascript:sumitir(2)" tabindex="10">						
					<input type="button" name="VerLista" value="Retornar" onClick="javascript:sumitir(3)" tabindex="10">
				</td>
				<!---********************************************************************************* --->							
				<tr>
					<td align="center" colspan="4" nowrap bgcolor="#CCCCCC"><strong>Rangos de Horas Definidos Actualmente</strong></td>
				</tr>
				<tr>
					<td nowrap bgcolor="#CCCCCC"></td>
					<td nowrap bgcolor="#CCCCCC">Cuenta Mayor</td>
					<td nowrap bgcolor="#CCCCCC">Bloqueada Desde</td>
					<td nowrap bgcolor="#CCCCCC">Bloqueada Hasta</td>
				</tr>				
				<cfoutput query="rsVerRangos">
				<tr>
					<td nowrap><input type="checkbox" name="chk_rango" value="2"></td>
					<td nowrap>#CGM1IM#</td>
					<td nowrap>#TimeFormat(Horaini,"HH:mm:ss")#</td>
					<td nowrap>#TimeFormat(Horafin,"HH:mm:ss")#</td>
				</tr>
				</cfoutput>
				</table>
			
			</cfif>

</cfif>