<!----============= TRADUCCION ==============--->
<cfinvoke Key="LB_Lunes" Default="Lunes" xmlfile="/rh/generales.xml" returnvariable="vLunes" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Martes" Default="Martes" xmlfile="/rh/generales.xml" returnvariable="vMartes" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Miercoles" Default="Mi&eacute;rcoles" xmlfile="/rh/generales.xml" returnvariable="vMiercoles" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Jueves" Default="Jueves" xmlfile="/rh/generales.xml" returnvariable="vJueves" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Viernes" Default="Viernes" xmlfile="/rh/generales.xml" returnvariable="vViernes" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Sabado" Default="S&aacute;bado" xmlfile="/rh/generales.xml" returnvariable="vSabado" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Domingo" Default="Domingo" xmlfile="/rh/generales.xml" returnvariable="vDomingo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Jornada" Default="Jornada" xmlfile="/rh/generales.xml" returnvariable="vJornada" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Almuerzo" Default="Almuerzo" returnvariable="vAlmuerzo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_De" Default="De" xmlfile="/rh/marcas/catalogos/JornadasComp.xml" returnvariable="vDE" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_A" Default="A" xmlfile="/rh/marcas/catalogos/JornadasComp.xml" returnvariable="vA" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="BTN_Modificar" Default="Modificar" xmlfile="/rh/generales.xml" returnvariable="vModificar" component="sif.Componentes.Translate" method="Translate"/>

<cfset vbModifica = true><!----Variable para indicar si se pueden modificar(activar) los inputs o no--->

<cfif isdefined("form.RHJid") and len(trim(form.RHJid))>
	<cfquery name="rsDatos" datasource="#session.DSN#">
		select 	jo.RHJid, 
				jo.RHJcodigo, 
				jo.RHJdescripcion, 
				jo.RHJsun, 
				jo.RHJmon, 
				jo.RHJtue, 
				jo.RHJwed, 
				jo.RHJthu, 
				jo.RHJfri, 
				jo.RHJsat, 
				dj.RHDJdia,
				case dj.RHDJdia when 2 then '#vLunes#'
								when 3 then '#vMartes#'
								when 4 then '#vMiercoles#'
								when 5 then '#vJueves#'
								when 6 then '#vViernes#'
								when 7 then '#vSabado#'
								when 1 then '#vDomingo#'
				end as DiaSemana,				
				dj.RHJhoraini, 
				dj.RHJhorafin, 				
				dj.RHJhorainicom, 
				dj.RHJhorafincom, 
				dj.RHJornadahora,
				dj.RHJtipo,
				dj.RHJhoradiaria,
				dj.RHJhorasNormales,
				dj.RHJhorasExtraA,
				dj.RHJhorasExtraB
		from RHDJornadas dj 
			inner join RHJornadas jo
				on dj.RHJid = jo.RHJid
				and dj.Ecodigo = jo.Ecodigo
		where dj.RHJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHJid#">
		  and dj.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfset modo = 'Cambio'>
	<!----Verificar si la jornada ya fue utilizada en alguna planilla ----->
	<cfquery name="rsVerificaPlanilla" datasource="#session.DSN#">
		select 1
		from RHJornadas
		where RHJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHJid#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and exists (select 1
						from HPagosEmpleado
						where RHJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHJid#">) 
	</cfquery>
	<cfif rsVerificaPlanilla.RecordCount NEQ 0>
		<cfset vbModifica = false>
	</cfif>
</cfif>
<cfquery name="rsHorasDia" datasource="#session.DSN#">
	select  RHJhoradiaria from RHJornadas
	where RHJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHJid#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
<script language="JavaScript1.2" src="/cfmx/rh/js/utilesMonto.js"></script>
<cfoutput>
<form name="form1" method="post" action="DetalleJornadas-sql.cfm" onSubmit="javascript:return funcActivar();">
	<input type="hidden" name="tab" value="2">
	<input type="hidden" name="RHJid" value="<cfif isdefined("form.RHJid") and len(trim(form.RHJid))>#form.RHJid#</cfif>">	
	<table width="100%" cellpadding="0" cellspacing="0">		
		<cfif isdefined("rsDatos") and rsDatos.RecordCount NEQ 0>	
			<tr><td align="center"><strong style="font-size:13px; font-variant:small-caps">#vJornada#: #rsDatos.RHJcodigo# - #rsDatos.RHJdescripcion#</strong></td></tr>
			<tr><td align="right">
				<input type="submit" name="btn_modificar" value="#vModificar#" <cfif not vbModifica>disabled</cfif>>
			</td></tr>
			<cfloop query="rsDatos">
			<input type="hidden" name="RHDJdia" value="#rsDatos.RHDJdia#">
			<tr><td colspan="5" valign="bottom"><hr></td></tr>
			<tr>
				<td>
					<table width="90%" align="center" border="0" cellpadding="2" cellspacing="0">						
						<tr>												
							<td colspan="4"><strong style="font-size:12px; font-variant:small-caps">#rsDatos.DiaSemana#</strong></td>
						</tr>
						<tr>
							<td width="25%">#vJornada#:&nbsp;</td>
							<td width="25%">#vAlmuerzo#:&nbsp;</td>
							<td width="25%">&nbsp;</td>
							<td width="25%">&nbsp;</td>
						</tr> 				
						<tr>
							<td valign="top">&nbsp;#vDe#:
								<cfif modo NEQ 'ALTA'>
									<!--- Para cargar la hora inicial de la jornada --->
									<cfset horai_rsDatos.RHDJdia = Hour(rsDatos.RHJhoraini) >			
									<cfset minutoi_rsDatos.RHDJdia  = Minute(rsDatos.RHJhoraini) >			
						
									<cfif InputBaseN(horai_rsDatos.RHDJdia ,10) LT 10>
										<cfset horai_rsDatos.RHDJdia  = "0" & horai_rsDatos.RHDJdia>
									<cfelse>
										<cfif InputBaseN(horai_rsDatos.RHDJdia ,10) GT 12 >
											<cfset horai_rsDatos.RHDJdia  = ToString(InputBaseN(horai_rsDatos.RHDJdia ,10) - 12) >
										</cfif>						
									</cfif>						
									<cfset horai_rsDatos.RHDJdia  = horai_rsDatos.RHDJdia  & " " & LCase(LSTimeFormat(rsDatos.RHJhoraini,'tt'))>
						
									<cfif InputBaseN(minutoi_rsDatos.RHDJdia ,10) LT 10>
										<cfset minutoi_rsDatos.RHDJdia  = "0" & minutoi_rsDatos.RHDJdia  & " min.">
									</cfif>
									<!---  ---------------------------------------- --->
						
									<cfset horaf_rsDatos.RHDJdia  = Hour(rsDatos.RHJhorafin) >
									<cfset minutof_rsDatos.RHDJdia  = Minute(rsDatos.RHJhorafin) >
						
									<cfif InputBaseN(horaf_rsDatos.RHDJdia ,10) LT 10>
										<cfset horaf_rsDatos.RHDJdia  = "0" & horaf_rsDatos.RHDJdia>
									<cfelse>
										<cfif InputBaseN(horaf_rsDatos.RHDJdia ,10) GT 12 >
											<cfset horaf_rsDatos.RHDJdia  = ToString(InputBaseN(horaf_rsDatos.RHDJdia ,10) - 12) >
										</cfif>						
									</cfif>			
									<cfset horaf_rsDatos.RHDJdia  = horaf_rsDatos.RHDJdia  & " " & LCase(LSTimeFormat(rsDatos.RHJhorafin,'tt'))>
									<cfif InputBaseN(minutof_rsDatos.RHDJdia ,10) LT 10>
										<cfset minutof_rsDatos.RHDJdia  = "0" & minutof_rsDatos.RHDJdia  & " min.">
									</cfif>
								</cfif>
						
								<!--- Hora de inicio de jornada laboral --->				
								<select name='horaini_#rsDatos.RHDJdia#' <cfif not vbModifica>disabled</cfif>>
									<cfloop index="i" from="1" to="11">
										<cfset valor = "">
										<!--- si es un nmero de 0 a 9, se aade un 0 a la izquierda por ej. '1' --->
										<cfif i LT 10 ><cfset valor = "0" ></cfif> 
										<cfset valor = valor & "#i# am" >
										<option value='#valor#' <cfif modo NEQ 'ALTA' and (horai_rsDatos.RHDJdia  EQ valor) > selected</cfif>>#valor#</option>			  
									</cfloop>			
								
									<option value='12 pm' <cfif modo NEQ 'ALTA' and (horai_rsDatos.RHDJdia  EQ '12 pm') >selected</cfif>>12 pm</option>
								
									<cfloop index="i" from="1" to="11">
										<cfset valor = "">
										<!--- si es un nmero de 0 a 9, se aade un 0 a la izquierda por ej. '1' --> 01 --->
										<cfif i LT 10 ><cfset valor = "0" ></cfif> 
										<cfset valor = valor & "#i# pm" >
										<option value='#valor#' <cfif modo NEQ 'ALTA' and (horai_rsDatos.RHDJdia  EQ valor) >selected</cfif>>#valor#</option>
									</cfloop>
									<option value='12 am' <cfif modo NEQ 'ALTA' and (horai_rsDatos.RHDJdia  EQ '12 am') >selected</cfif>>12 am</option>
								</select>
						
								<select name='minutoini_#rsDatos.RHDJdia#' <cfif not vbModifica>disabled</cfif>>
									<cfloop index="i" from="0" to="59">
										<cfset valor = "">
										<!--- si es un nmero de 0 a 9, se aade un 0 a la izquierda por ej. '1' --> 01 --->
										<cfif i LT 10 ><cfset valor = "0" ></cfif> 
										<cfset valor = valor & "#i# min." >
										<option value='#valor#' <cfif modo NEQ 'ALTA' and (minutoi_rsDatos.RHDJdia  EQ i) > selected</cfif>>#valor#</option>
									</cfloop>
								</select>  	  
							</td>			
							<td valign="top">&nbsp;#vDe#:					
								<cfset horaicom_rsDatos.RHDJdia  = "">
								<cfset minutoicom_rsDatos.RHDJdia  = "">
								<cfif modo NEQ 'ALTA' and Len(Trim(rsDatos.RHJhorainicom)) GT 0 >
									<!--- Para cargar la hora inicial de la jornada --->
									<cfset horaicom_rsDatos.RHDJdia  = Hour(rsDatos.RHJhorainicom) >			
									<cfset minutoicom_rsDatos.RHDJdia  = Minute(rsDatos.RHJhorainicom) >			
								
									<cfif InputBaseN(horaicom_rsDatos.RHDJdia ,10) LT 10>
										<cfset horaicom_rsDatos.RHDJdia  = "0" & horaicom_rsDatos.RHDJdia  >
									<cfelse>
										<cfif InputBaseN(horaicom_rsDatos.RHDJdia ,10) GT 12 >
											<cfset horaicom_rsDatos.RHDJdia  = ToString(InputBaseN(horaicom_rsDatos.RHDJdia ,10) - 12) >
										</cfif>						
									</cfif>						
									<cfset horaicom_rsDatos.RHDJdia  = horaicom_rsDatos.RHDJdia  & " " & LCase(LSTimeFormat(rsDatos.RHJhorainicom,'tt'))>
									<cfif InputBaseN(minutoicom_rsDatos.RHDJdia ,10) LT 10><cfset minutoicom_rsDatos.RHDJdia  = "0" & minutoicom_rsDatos.RHDJdia  & " min."></cfif>
								</cfif>
								
								<cfset horafcom_rsDatos.RHDJdia  = "">
								<cfset minutofcom_rsDatos.RHDJdia  = "">
								<cfif modo NEQ 'ALTA' and Len(Trim(rsDatos.RHJhorafincom)) GT 0 >			
									<cfset horafcom_rsDatos.RHDJdia  = Hour(rsDatos.RHJhorafincom) >
									<cfset minutofcom_rsDatos.RHDJdia  = Minute(rsDatos.RHJhorafincom) >
								
									<cfif InputBaseN(horafcom_rsDatos.RHDJdia ,10) LT 10>
										<cfset horafcom_rsDatos.RHDJdia  = "0" & horafcom_rsDatos.RHDJdia  >
									<cfelse>
										<cfif InputBaseN(horafcom_rsDatos.RHDJdia ,10) GT 12 >
											<cfset horafcom_rsDatos.RHDJdia  = ToString(InputBaseN(horafcom_rsDatos.RHDJdia ,10) - 12) >
										</cfif>						
									</cfif>			
									<cfset horafcom_rsDatos.RHDJdia  = horafcom_rsDatos.RHDJdia  & " " & LCase(LSTimeFormat(rsDatos.RHJhorafincom,'tt'))>
									<cfif InputBaseN(minutofcom_rsDatos.RHDJdia ,10) LT 10><cfset minutofcom_rsDatos.RHDJdia  = "0" & minutofcom_rsDatos.RHDJdia  & " min."></cfif>
								</cfif>
								
								<!--- Hora de inicio de almuerzo --->	  							
								<select name='horainicom_#rsDatos.RHDJdia#' <cfif not vbModifica>disabled</cfif>>
									<option value=''></option>
									<cfloop index="i" from="1" to="11">
										<cfset valor = "">
										<!--- si es un nmero de 0 a 9, se aade un 0 a la izquierda por ej. '1' --> 01 --->
										<cfif i LT 10 ><cfset valor = "0" ></cfif> 
										<cfset valor = valor & "#i# am" >
										<option value='#valor#' <cfif modo NEQ 'ALTA' and (horaicom_rsDatos.RHDJdia  EQ valor) >selected</cfif>>#valor#</option>			  
									</cfloop>			
									<option value='12 pm' <cfif modo NEQ 'ALTA' and (horaicom_rsDatos.RHDJdia  EQ '12 pm') >selected</cfif>>12 pm</option>
										
									<cfloop index="i" from="1" to="11">
										<cfset valor = "">
										<!--- si es un nmero de 0 a 9, se aade un 0 a la izquierda por ej. '1' --> 01 --->
										<cfif i LT 10 ><cfset valor = "0" ></cfif> 
										<cfset valor = valor & "#i# pm" >
										<option value='#valor#' <cfif modo NEQ 'ALTA' and (horaicom_rsDatos.RHDJdia  EQ valor) >selected</cfif>>#valor#</option>
									</cfloop>
									<option value='12 am' <cfif modo NEQ 'ALTA' and (horaicom_rsDatos.RHDJdia  EQ '12 am') >selected</cfif>>12 am</option>
								</select>
								
								<select name='minutoinicom_#rsDatos.RHDJdia#' <cfif not vbModifica>disabled</cfif>>
									<cfloop index="i" from="0" to="59">
										<cfset valor = "">
										<!--- si es un nmero de 0 a 9, se aade un 0 a la izquierda por ej. '1' --> 01 --->
										<cfif i LT 10 ><cfset valor = "0" ></cfif> 
										<cfset valor = valor & "#i# min." >
										<option value='#valor#' <cfif modo NEQ 'ALTA' and (minutoicom_rsDatos.RHDJdia  EQ i) >selected</cfif>>#valor#</option>
									</cfloop>
								</select>  	  
								&nbsp;
							</td>
							<td align="right">
								<cf_translate key="LB_Horas_de_la_jornada">Horas de la jornada</cf_translate>:
								<input type="text" name="RHJhorasNormales_#rsDatos.RHDJdia#" value="<cfif modo NEQ 'ALTA'>#LSNumberFormat(rsDatos.RHJhorasNormales,',9.00')#</cfif>"
								onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
								onBlur="javascript:fm(this,2); setHEA(); setHEB();" 
								size="5" maxlength="5" style="text-align:right" tabindex="27"
								<cfif not vbModifica>disabled</cfif>>
							</td>	
							<td>&nbsp;</td>	
						</tr>						
						<tr>
							<td valign="top">&nbsp;#vA#:&nbsp;&nbsp;
								<!--- Hora de salida de jornada laboral --->			  
								<select name='horafin_#rsDatos.RHDJdia#' <cfif not vbModifica>disabled</cfif>>
									<cfloop index="i" from="1" to="11">
										<cfset valor = "">
										<!--- si es un nmero de 0 a 9, se aade un 0 a la izquierda por ej. '1' --> 01 --->
										<cfif i LT 10 ><cfset valor = "0" ></cfif> 
										<cfset valor = valor & "#i# am" >
										<option value='#valor#' <cfif modo NEQ 'ALTA' and (horaf_rsDatos.RHDJdia  EQ valor) >selected</cfif>>#valor#</option>			  
									</cfloop>			
									
									<option value='12 pm' <cfif modo NEQ 'ALTA' and (horaf_rsDatos.RHDJdia  EQ '12 pm') >selected</cfif>>12 pm</option>
									
									<cfloop index="i" from="1" to="11">
										<cfset valor = "">
										<!--- si es un nmero de 0 a 9, se aade un 0 a la izquierda por ej. '1' --> 01 --->
										<cfif i LT 10 ><cfset valor = "0" ></cfif> 
										<cfset valor = valor & "#i# pm" >
										<option value='#valor#' <cfif modo NEQ 'ALTA' and (horaf_rsDatos.RHDJdia  EQ valor) > selected</cfif>>#valor#</option>
									</cfloop>
									
									<option value='12 am' <cfif modo NEQ 'ALTA' and (horaf_rsDatos.RHDJdia  EQ '12 am') >selected</cfif>>12 am</option>
								</select>
								
								<select name='minutofin_#rsDatos.RHDJdia#' <cfif not vbModifica>disabled</cfif>>
									<cfloop index="i" from="0" to="59">
										<cfset valor = "">
										<!--- si es un nmero de 0 a 9, se aade un 0 a la izquierda por ej. '1' --> 01--->
										<cfif i LT 10 ><cfset valor = "0" ></cfif> 
										<cfset valor = valor & "#i# min." >
										<option value='#valor#' <cfif modo NEQ 'ALTA' and (minutof_rsDatos.RHDJdia  EQ i) >selected</cfif>>#valor#</option>
									</cfloop>
								</select>  	  
							</td>								
							<td>
								&nbsp;#vA#:&nbsp;&nbsp;								
								<!--- Hora de trmino de almuerzo --->
								<select name='horafincom_#rsDatos.RHDJdia#' <cfif not vbModifica>disabled</cfif>>
									<option value=''></option>
									<cfloop index="i" from="1" to="11">
										<cfset valor = "">
										<!--- si es un nmero de 0 a 9, se aade un 0 a la izquierda por ej. '1' --> 01 --->
										<cfif i LT 10 ><cfset valor = "0" ></cfif> 
										<cfset valor = valor & "#i# am" >
										<option value='#valor#' <cfif modo NEQ 'ALTA' and (horafcom_rsDatos.RHDJdia  EQ valor) >selected</cfif>>#valor#</option>			  
									</cfloop>			
									<option value='12 pm' <cfif modo NEQ 'ALTA' and (horafcom_rsDatos.RHDJdia  EQ '12 pm') >selected</cfif>>12 pm</option>
									<cfloop index="i" from="1" to="11">
										<cfset valor = "">
										<!--- si es un nmero de 0 a 9, se aade un 0 a la izquierda por ej. '1' --> 01 --->
										<cfif i LT 10 ><cfset valor = "0" ></cfif> 
										<cfset valor = valor & "#i# pm" >
										<option value='#valor#' <cfif modo NEQ 'ALTA' and (horafcom_rsDatos.RHDJdia  EQ valor) >selected</cfif>>#valor#</option>
									</cfloop>
									<option value='12 am' <cfif modo NEQ 'ALTA' and (horafcom_rsDatos.RHDJdia  EQ '12 am') >selected</cfif>>12 am</option>
								</select>								
								<select name='minutofincom_#rsDatos.RHDJdia#' <cfif not vbModifica>disabled</cfif>>
									<cfloop index="i" from="0" to="59">
										<cfset valor = "">
										<!--- si es un nmero de 0 a 9, se aade un 0 a la izquierda por ej. '1' --> 01 --->
										<cfif i LT 10 ><cfset valor = "0" ></cfif> 
										<cfset valor = valor & "#i# min." >
										<option value='#valor#' <cfif modo NEQ 'ALTA' and (minutofcom_rsDatos.RHDJdia  EQ i) >selected</cfif>>#valor#</option>
									</cfloop>
								</select>  
							</td>				
							<td align="right">
								<cf_translate key="LB_HorasExtraA">Horas Extra A</cf_translate>:
								<input type="text" name="RHJhorasExtraA_#rsDatos.RHDJdia#" value="<cfif modo NEQ 'ALTA'>#LSNumberFormat(rsDatos.RHJhorasExtraA,',9.00')#</cfif>"
								onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
								onBlur="javascript:if (validateHEA(this)) fm(this,2);" onFocus="javascript:this.select();" size="5" maxlength="5" style="text-align:right" tabindex="27"
								onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
									
								<cfif not vbModifica>disabled</cfif>>
							</td>	
							<td  align="center">
								<cf_translate key="LB_HorasExtraB">Horas Extra B</cf_translate>:
								<input type="text" name="RHJhorasExtraB_#rsDatos.RHDJdia#" value="<cfif modo NEQ 'ALTA'>#LSNumberFormat(rsDatos.RHJhorasExtraB,',9.00')#</cfif>"
								onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
								onBlur="javascript:if (validateHEA(this)) fm(this,2);" onFocus="javascript:this.select();" size="5" maxlength="5" style="text-align:right" tabindex="27"
								<cfif not vbModifica>disabled</cfif>>
							</td>						
						</tr>						
					</table>
				</td>
			</tr>
			</cfloop>
		<cfelseif isdefined("rsDatos") and rsDatos.RecordCount EQ 0>
			<tr><td>&nbsp;</td></tr>
			<tr><td colspan="2" align="center"><strong> ---<cf_translate key="MSG_No_se_han_definido_los_dias_de_la_jornada">No se han definido los d&iacute;as de la jornada</cf_translate>---</strong></td></tr>
		<cfelseif not isdefined("rsDatos")>
			<tr><td>&nbsp;</td></tr>
			<tr><td colspan="2" align="center"><strong> ---<cf_translate key="MSG_Seleccione_la_jornada_para_la_que_desea_definir_el_detalle">Seleccione la jornada para la que desea definir el detalle</cf_translate>---</strong></td></tr>
		</cfif>
		<tr><td>&nbsp;</td></tr>
		<cfif isdefined("rsDatos") and rsDatos.RecordCount NEQ 0>
			<tr><td colspan="2" align="center">
				<input type="submit" name="btn_modificar" value="#vModificar#" <cfif not vbModifica>disabled</cfif>>
			</td></tr>
		</cfif>
	</table>
</form>
</cfoutput>
<script type="text/javascript" language="javascript1.2">
	function funcActivar(){
		<cfloop query="rsDatos">
			<cfoutput>
				document.form1.horaini_#rsDatos.RHDJdia#.disabled = false;
				document.form1.minutoini_#rsDatos.RHDJdia#.disabled = false;
				document.form1.horafin_#rsDatos.RHDJdia#.disabled = false;
				document.form1.minutofin_#rsDatos.RHDJdia#.disabled = false;
				document.form1.horainicom_#rsDatos.RHDJdia#.disabled = false;
				document.form1.minutoinicom_#rsDatos.RHDJdia#.disabled = false;
				document.form1.horafincom_#rsDatos.RHDJdia#.disabled = false;
				document.form1.minutofincom_#rsDatos.RHDJdia#.disabled = false;
			</cfoutput>
		</cfloop>		
	}
	function validateHEA(){
		var v1 = 0.00;
		var v2 = 0.00;
		<cfloop query="rsDatos">
			<cfoutput>
				if (document.form1.RHJhorasExtraA_#rsDatos.RHDJdia#.value!='')
					v1 = parseFloat(qf(document.form1.RHJhorasExtraA_#rsDatos.RHDJdia#.value));
				if (document.form1.RHJhorasNormales_#rsDatos.RHDJdia#.value!='')
					v2 = parseFloat(qf(document.form1.RHJhorasNormales_#rsDatos.RHDJdia#.value));
				if(v1<v2){
					document.form1.RHJhorasExtraA_#rsDatos.RHDJdia#.value=v2;
				}
				setHEB();
			</cfoutput>
		</cfloop>
		return true;
	}
	
	function validateHEB(){
		var v1 = 0.00;
		var v2 = 0.00;
		<cfloop query="rsDatos">
			<cfoutput>
				if (document.form1.RHJhorasExtraB_#rsDatos.RHDJdia#.value!='')
					v1 = parseFloat(qf(document.form1.RHJhorasExtraB_#rsDatos.RHDJdia#.value));
				if (document.form1.RHJhorasExtraA_#rsDatos.RHDJdia#.value!='')
					v2 = parseFloat(qf(document.form1.RHJhorasExtraA_#rsDatos.RHDJdia#.value));
				if(v1<=v2){
					document.form1.RHJhorasExtraB_#rsDatos.RHDJdia#.value=v2;
				}
			</cfoutput>
		</cfloop>
		return true;
	}
	function setHEA(){
		var v1 = 0.00;
		var v2 = 0.00;
		<cfloop query="rsDatos">
			<cfoutput>
			if (document.form1.RHJhorasExtraA_#rsDatos.RHDJdia#.value!='')
				v1 = parseFloat(qf(document.form1.RHJhorasExtraA_#rsDatos.RHDJdia#.value));
			if (document.form1.RHJhorasNormales_#rsDatos.RHDJdia#.value!='')
				v2 = parseFloat(qf(document.form1.RHJhorasNormales_#rsDatos.RHDJdia#.value));
			if(v1<v2){
				document.form1.RHJhorasExtraA_#rsDatos.RHDJdia#.value=fm(v2,2);
			}
			</cfoutput>
		</cfloop>
		return true;
	}

	function setHEB(){
		var v1 = 0.00;
		var v2 = 0.00;
		<cfloop query="rsDatos">
			<cfoutput>
		
				if (document.form1.RHJhorasExtraB_#rsDatos.RHDJdia#.value!='')
					v1 = parseFloat(qf(document.form1.RHJhorasExtraB_#rsDatos.RHDJdia#.value));
				if (document.form1.RHJhorasNormales_#rsDatos.RHDJdia#.value!='')
					v2 = parseFloat(qf(document.form1.RHJhorasNormales_#rsDatos.RHDJdia#.value));
				if (document.form1.RHJhorasExtraA_#rsDatos.RHDJdia#.value!='')
					v2 = parseFloat(qf(document.form1.RHJhorasExtraA_#rsDatos.RHDJdia#.value));
				if(v1<v2){
					document.form1.RHJhorasExtraB_#rsDatos.RHDJdia#.value=fm(v2,2);
				}
			</cfoutput>
		</cfloop>
		return true;
	}
	
</script>