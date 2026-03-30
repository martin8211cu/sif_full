<cfoutput>
<cfquery name="rsDEid" datasource="#session.dsn#">
	select llave from UsuarioReferencia where Usucodigo=#session.Usucodigo# and Ecodigo=#session.ecodigosdc#
	and STabla='DatosEmpleado'
</cfquery>

<input type="hidden" name="DEid" value="#rsDEid.llave#" />

<cfset form.DEid=rsDEid.llave>
<cfif isdefined ('url.RHCMid') and len(trim(url.RHCMid)) gt 0 and not isdefined('form.RHCMid')>
	<cfset form.RHCMid=url.RHCMid>
</cfif>
<cfset modo = 'Alta'>
<table width="100%">
	<tr>
		<td>
			<cfinclude template="/rh/portlets/pEmpleado.cfm">		</td>
	</tr>
</table>

<table border="0" width="100%">
	<tr>
		<td width="50%">
			<cfinclude template="registro-lista.cfm">
		<td width="50%">
			<form name="form1" action="registro-sql.cfm" method="post" onSubmit="return validar();">
			<input type="hidden" name="DEid" value="#rsDEid.llave#" />
			<cfif isdefined ('form.RHCMid') and len(trim(form.RHCMid)) gt 0>
				<input type="hidden" name="RHCMid" value="#form.RHCMid#" />
				<!--- DAG 14/05/2007: SE ESTANDARIZA PARA DBMSS: ORACLE, MSSQLSERVER, SYBASE --->
				<!--- Date Part de fecha hora reloj --->
				<cf_dbfunction name="date_part" args="hh, a.fechahorareloj" returnvariable="Lvar_fechahorareloj_hh">
				<cf_dbfunction name="date_part" args="mi, a.fechahorareloj" returnvariable="Lvar_fechahorareloj_mi">
				<!--- To char del Date Part de fecha hora reloj --->
				<cf_dbfunction name="to_char" args="#Lvar_fechahorareloj_hh#" returnvariable="Lvar_to_char_fechahorareloj_hh">
				<cf_dbfunction name="to_char" args="#Lvar_fechahorareloj_hh#-12" returnvariable="Lvar_to_char_fechahorareloj_hh_m12">
				<cf_dbfunction name="to_char" args="#Lvar_fechahorareloj_mi#" returnvariable="Lvar_to_char_fechahorareloj_mi">
				<!--- Date Part de fecha hora marca --->
				<cf_dbfunction name="date_part" args="hh, a.fechahoramarca" returnvariable="Lvar_fechahoramarca_hh">
				<cf_dbfunction name="date_part" args="mi, a.fechahoramarca" returnvariable="Lvar_fechahoramarca_mi">
				<!--- To char del Date Part de fecha hora marca --->
				<cf_dbfunction name="to_char" args="#Lvar_fechahoramarca_hh#" returnvariable="Lvar_to_char_fechahoramarca_hh">
				<cf_dbfunction name="to_char" args="#Lvar_fechahoramarca_hh#-12" returnvariable="Lvar_to_char_fechahoramarca_hh_m12">
				<cf_dbfunction name="to_char" args="#Lvar_fechahoramarca_mi#" returnvariable="Lvar_to_char_fechahoramarca_mi">
				<cfquery name="rsform" datasource="#session.dsn#">
						select 	a.DEid,
						a.tipomarca, 
						a.fechahorareloj,
						a.RHCMid,
							a.fechahoramarca,
							case when (#PreserveSingleQuotes(Lvar_fechahoramarca_hh)#) > 12 then 
									(#PreserveSingleQuotes(Lvar_fechahoramarca_hh)#) - 12 
								when (#PreserveSingleQuotes(Lvar_fechahoramarca_hh)#) = 0 then 
									12 
								else 
									(#PreserveSingleQuotes(Lvar_fechahoramarca_hh)#) 
							end as horas,
						(#PreserveSingleQuotes(Lvar_fechahoramarca_mi)#) as minutos,
						case when (#PreserveSingleQuotes(Lvar_fechahoramarca_hh)#) < 12 then 'AM' else 'PM' end as segundos,
						a.RHASid,
						a.registroaut,
						a.justificacion
				from RHControlMarcas a
				where a.RHCMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCMid#">
				</cfquery>
				<input type="hidden" name="tipo" value="#ltrim(rtrim(rsform.tipomarca))#" />
				<cfif rsform.recordcount gt 0>
					<cfset modo = 'Cambio'>
				</cfif>
			</cfif>
			<table width="100%" align="center" border="0">
				<cfif modo NEQ 'ALTA'>
					<tr>
					  <td align="right"><strong>
						<cf_translate key="LB_FechaYHoraReloj">Fecha y hora del reloj</cf_translate>
						:&nbsp;</strong></td>
					  <td colspan="2">
						<cfif len(trim(rsform.fechahorareloj))>
						 #LSDateFormat(rsform.fechahorareloj,'dd/mm/yyyy')#
						</cfif>
						  <!--- #rsDatos.horaReloj#  --->
						#TimeFormat(rsform.fechahorareloj,"hh:mm:ss tt")# 
					  </td>
					</tr>
				</cfif>
				  <tr>
					<td width="41%" align="right" nowrap="nowrap"><strong>
					<cf_translate key="LB_FechaYHoraDeLaMarca">Fecha y hora de la marca:&nbsp;</cf_translate>  </strong></td>
					<td width="59%">
						<cfif modo NEQ 'ALTA'>
						  <cf_sifcalendario  tabindex="3" form="form1" name="fechahoramarca" value="#LSDateFormat(rsform.fechahoramarca,'dd/mm/yyyy')#">
						  <cfelse>
						  <cf_sifcalendario  tabindex="3" form="form1" name="fechahoramarca">
						</cfif>
					</td>
				</tr>
				<tr>
				<cfif modo eq 'Alta' or ( modo eq 'Cambio' and ltrim(rtrim(rsform.tipomarca)) eq 'E')>
					<td width="41%"><div align="right"><strong>Entrada:</strong></div></td>
					<td>
						<select id="horamarca_h" name="horamarca_h" tabindex="4">
						  <cfloop index="i" from="1" to="12">
							<option value="#i#"
								<cfif modo NEQ 'ALTA' and rsform.horas EQ i>selected</cfif>>
								  <cfif Len(Trim(i)) EQ 1>
									0
								  </cfif>
								  #i# </option>
						  </cfloop>
						</select>
						  :
						  <select id="horamarca_m" name="horamarca_m" tabindex="5">
							<cfloop index="i" from="0" to="59">
							  <option value="#i#"<cfif modo NEQ 'ALTA' and rsform.minutos EQ i>selected</cfif>>
								<cfif Len(Trim(i)) EQ 1>
								  0
								</cfif>
								#i# </option>
							</cfloop>
						  </select>
						  <select id="horamarca_s"  name="horamarca_s" tabindex="6">
							<option value="AM" <cfif modo NEQ 'ALTA' and rsform.segundos EQ 'AM'>selected</cfif>>AM</option>
							<option value="PM" <cfif modo NEQ 'ALTA' and rsform.segundos EQ 'PM'>selected</cfif>>PM</option>
						  </select>
					</td>
					</cfif>
				</tr>
				<tr>
				<cfif modo eq 'Alta' or (modo eq 'Cambio' and ltrim(rtrim(rsform.tipomarca)) eq 'S')>
					<td width="41%" nowrap="nowrap" align="left"><div align="right"><strong>Salida:</strong></div></td>
					<td>
						<select id="horamarca_hs" name="horamarca_hs" tabindex="4">
						  <cfloop index="i" from="1" to="12">
							<option value="#i#"<cfif modo NEQ 'ALTA' and rsform.horas EQ i>selected</cfif>>
							  <cfif Len(Trim(i)) EQ 1>
								0
							  </cfif>
							  #i# </option>
						  </cfloop>
						</select>
						  :
						  <select id="horamarca_ms" name="horamarca_ms" tabindex="5">
							<cfloop index="i" from="0" to="59">
							  <option value="#i#"<cfif modo NEQ 'ALTA' and rsform.minutos EQ i>selected</cfif>>
								<cfif Len(Trim(i)) EQ 1>
								  0
								</cfif>
								#i# </option>
							</cfloop>
						  </select>
						  <select id="horamarca_ss"  name="horamarca_ss" tabindex="6">
							<option value="AM" <cfif modo NEQ 'ALTA' and rsform.segundos EQ 'AM'>selected</cfif>>AM</option>
							<option value="PM" <cfif modo NEQ 'ALTA' and rsform.segundos EQ 'PM'>selected</cfif>>PM</option>
						  </select>
					</td>
					</cfif>
				  </tr>		
				  <tr>
					<td colspan="5">
						<cfif modo eq 'Alta'>
							<cf_botones modo="#modo#">
						<cfelse>
							<cf_botones modo="Cambio">
						</cfif>
					</td>
				  </tr>
			</table>		
			</cfoutput>
			
		</td>
	</tr>
	<tr>	
	<td colspan="1" align="left"><cf_botones names="Aplicar" values="Aplicar"></td></form>
  </tr>
</table>

<script language="javascript">
	function validar(){
	if (btnSelected('Alta',document.form1)){
		if (document.form1.horamarca_hs.value== document.form1.horamarca_h.value){
			if (document.form1.horamarca_m.value==document.form1.horamarca_ms.value){
				if (document.form1.horamarca_s.value==document.form1.horamarca_ss.value){
						alert('No se puede registrar una hora extra con la misma fecha y la misma hora.')
						return false;
					}
				else{return true;}
					
				}else{
				return true;}
		}else{return true;}
	}}
</script>
		