<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Programar_titulo"
	Default="Programaci&oacute;n de Cursos"
	returnvariable="LB_Programar_proceso"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Dia"
	Default="D&iacute;a"
	returnvariable="lb_dia"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Desde"
	xmlfile="/rh/generales.xml"
	Default="Desde"
	returnvariable="lb_de"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Hasta"
	Default="Hasta"
	xmlfile="/rh/generales.xml"
	returnvariable="lb_a"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Horas"
	Default="Horas"
	returnvariable="lb_horas"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Programar"
	Default="Programar"
	returnvariable="lb_programar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Curso"
	Default="Curso"
	returnvariable="lb_curso"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Fecha_de_Inicio"
	Default="Fecha de Inicio"
	returnvariable="LB_Inicio"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Fecha_de_Finalizacion"
	Default="Fecha de Finalizacion"
	returnvariable="LB_Fin"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_horario"
	Default="Horario"
	returnvariable="LB_horario"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_duracion"
	Default="Duraci&oacute;n"
	returnvariable="LB_duracion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Regresar"
	Default="Regresar"
	returnvariable="LB_Regresar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Eliminar"
	Default="Eliminar"
	returnvariable="LB_Eliminar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Eliminar"
	Default="Esta seguro que desea eliminar de la programacion del curso, los dias seleccionados?"
	returnvariable="MSG_Eliminar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Dia_deshabilitado"
	Default="Este d&iacute;a no habra asistencia al curso"
	returnvariable="MSG_Dia_deshabilitado"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_La_informacion_de_la_programacion_aun_no_ha_sido_almacenada._Por_favor_presione_el_boton_Programar"
	Default="La informaci&oacute;n de la programaci&oacute;n a&uacute;n no ha sido almacenada. Por favor presione el bot&oacute;n Programar"
	returnvariable="MSG_INFO_Guardar"/>
<!--- FIN VARIABLES DE TRADUCCION --->

<cfif isdefined("url.RHCid") and not isdefined("form.RHCid")>
	<cfset form.RHCid = url.RHCid >
</cfif>

<!--- Componente --->
<cfinvoke component="rh.Componentes.RH_ProgramacionCursos" method="init" returnvariable="curso">
<!--- recupera la informacion del curso --->
<cfset rs_datoscurso = curso.obtenerCurso(form.RHCid, session.DSN, session.Usucodigo) >
<cfset rs_programacion = curso.obtenerProgramacion( form.RHCid ) >

<!--- fechas del curso --->
<cfset fecha_inicio   = rs_datoscurso.RHCfdesde >
<cfset fecha_final 	  = rs_datoscurso.RHCfhasta >
<cfset hora_inicio   = createdatetime(year(rs_datoscurso.horaini), month(rs_datoscurso.horaini), day(rs_datoscurso.horaini), hour(rs_datoscurso.horaini), minute(rs_datoscurso.horaini), second(rs_datoscurso.horaini) )  >
<cfset hora_final   = createdatetime(year(rs_datoscurso.horafin), month(rs_datoscurso.horafin), day(rs_datoscurso.horafin), hour(rs_datoscurso.horafin), minute(rs_datoscurso.horafin), second(rs_datoscurso.horafin) )  >
<cfset duracion_por_dia = abs(datediff('n', hora_inicio, hora_final))/60 >
<cfset fecha_iterador = createdate(year(fecha_inicio), month(fecha_inicio), day(fecha_inicio)) >	<!--- controlar la iteracion--->
<!---<cfset duracion_por_dia = rs_datoscurso.duracion/IIf(datediff('d', fecha_inicio, fecha_final) gt 0, datediff('d', fecha_inicio, fecha_final), 1)  >--->
<cfset contador = 0 >	<!--- controlar la iteracion--->

<cfoutput>
<cf_templateheader title="#LB_RecursosHumanos#">
	<cf_web_portlet_start titulo="#LB_Programar_proceso#">
	<form name="form1" method="post" action="programar-sql.cfm">
 	<table width="100%" border="0" cellspacing="6">
		<tr>
			<td>
				<table width="85%" bgcolor="##CCCCCC" align="center" style="border:##000000 thin solid;">
					<tr>
						<td width="1%" nowrap="nowrap"><strong>#lb_curso#:</strong></td>
						<td colspan="3">#trim(rs_datoscurso.RHCcodigo)# - #trim(rs_datoscurso.RHCnombre)#</td>
					</tr>
					<tr>
						<td nowrap="nowrap"><strong>#LB_inicio#:</strong></td>
						<td>#LSDateFormat(rs_datoscurso.RHCfdesde, 'dd/mm/yyyy')#</td>
						<td nowrap="nowrap"><strong>#LB_fin#:</strong></td>
						<td>#LSDateFormat(rs_datoscurso.RHCfhasta, 'dd/mm/yyyy')#</td>
					</tr>
					<tr>
						<td nowrap="nowrap"><strong>#LB_horario#:</strong></td>
						<td>#TimeFormat(rs_datoscurso.horaini, 'hh:mm tt')# - #TimeFormat(rs_datoscurso.horafin, 'hh:mm tt')#</td>
						<td nowrap="nowrap"><strong>#LB_duracion#:</strong></td>
						<cfif rs_programacion.recordcount gt 0 >
							<td>#LSNumberFormat(rs_datoscurso.duracion, ',9.00')# #lb_horas#</td>
						<cfelse>
							<cfset cantidad_dias = abs(datediff('d', fecha_final, fecha_inicio))+1>
							<cfset horas_total = cantidad_dias * duracion_por_dia >
							<td>#LSNumberFormat(horas_total, ',9.00')# #lb_horas#</td>
						</cfif>
					</tr>
				</table>			
			</td>
		</tr>
		<tr><td>
			<table width="85%" align="center" cellpadding="3" cellspacing="0" >
				<cfif datediff('d', fecha_inicio, fecha_final) gt 40 >
					<tr>
						<td align="center" colspan="6">
							<input type="submit" name="Programar" class="btnAplicar" value="#lb_programar#" tabindex="1">
							<!---<input type="submit" name="Eliminar" class="btnEliminar" value="#lb_eliminar#" tabindex="1" onclick="javascript: return funcEliminar();">--->
							<input type="button" name="Regresar" class="btnAnterior" value="#lb_regresar#" tabindex="1" onclick="javascript:location.href='index.cfm?RHCid=#form.RHCid#'">
						</td>
					</tr>	
				</cfif>

				<tr bgcolor="##CCCCCC">
					<td valign="top" ><strong>#lb_dia#</strong></td>
					<td valign="top" ><strong>#lb_de#</strong></td>
					<td valign="top" ><strong>#lb_a#</strong></td>
					<td valign="top" ><strong>#lb_horas#</strong></td>
					<td valign="top" align="center" ><strong>#lb_eliminar#</strong></td>
					<td valign="top" align="center" ></td>
				</tr>

				<!--- genera una salida para cada uno de los dias comprendidos entre la fecha de inicio y finalizacion del curso --->
				<cfloop condition="DateCompare(fecha_iterador, fecha_final) lte 0 ">
					<cfset contador = contador + 1 >
					<cfset struct_hora_inicio = curso.obtenerFechaMeridiano(hora_inicio) >
					<cfset struct_hora_final = curso.obtenerFechaMeridiano(hora_final) >
					<cfset datos_dia = curso.obtenerProgramacion( form.RHCid, LSDateFormat(fecha_iterador, 'dd/mm/yyyy'), session.DSN) >
					<cfif datos_dia.recordcount gt 0 >
						<cfset struct_hora_inicio = curso.obtenerFechaMeridiano( createdatetime(year(datos_dia.RHDChorainicio), month(datos_dia.RHDChorainicio), day(datos_dia.RHDChorainicio), hour(datos_dia.RHDChorainicio), minute(datos_dia.RHDChorainicio), second(datos_dia.RHDChorainicio) ) ) >
						<cfset struct_hora_final = curso.obtenerFechaMeridiano( createdatetime(year(datos_dia.RHDChorafinal), month(datos_dia.RHDChorafinal), day(datos_dia.RHDChorafinal), hour(datos_dia.RHDChorafinal), minute(datos_dia.RHDChorafinal), second(datos_dia.RHDChorafinal) ) ) >
						<cfset duracion_por_dia = datos_dia.RHDChoras >
					</cfif>
					
					<tr bgcolor="<cfif isdefined("datos_dia") and datos_dia.RHDCactivo eq 0>##E2EDFE<cfelse><cfif contador mod 2>##f5f5f5</cfif></cfif>">
						<td valign="top">#LSDateFormat(fecha_iterador, 'dd/mm/yyyy')#<input type="hidden" name="fecha_#contador#" value="#LSDateFormat(fecha_iterador, 'dd/mm/yyyy')#" /></td>
						<td valign="top">
							<select id="horaini_#contador#" name="horaini_#contador#" tabindex="#contador#" onchange="javascript:cambio_horas(#contador#);">
							<cfloop from="1" to="12" index="h">
								<cfif h lt 10>
									<option value="#h#" <cfif h EQ struct_hora_inicio.hora>selected</cfif>>0#h#</option>
								<cfelse>	
									<option value="#h#" <cfif H EQ struct_hora_inicio.hora>selected</cfif>>#h#</option>
								</cfif>
							</cfloop>
							</select>
							<select id="minutosini_#contador#"  name="minutosini_#contador#"  tabindex="#contador#" onchange="javascript:cambio_horas(#contador#);">
							<cfloop from="0" to="59" index="m">
								<cfif m lt 10>
									<option value="#m#" <cfif m EQ struct_hora_inicio.minutos>selected</cfif>>0#m#</option>
								<cfelse>	
									<option value="#m#" <cfif M EQ struct_hora_inicio.minutos>selected</cfif>>#m#</option>
								</cfif>
							</cfloop>
							</select>
							<select  id="meridianoini_#contador#" name="meridianoini_#contador#"  tabindex="#contador#" onchange="javascript:cambio_horas(#contador#);">
								<option value="AM" <cfif "AM" EQ struct_hora_inicio.meridiano>selected</cfif> >AM</option>
								<option value="PM" <cfif "PM" EQ struct_hora_inicio.meridiano>selected</cfif>  >PM</option>
							</select>
						</td>
						<td valign="top">
							<select id="horafin_#contador#" name="horafin_#contador#"  tabindex="#contador#" onchange="javascript:cambio_horas(#contador#);">
							<cfloop from="1" to="12" index="h">
								<cfif h lt 10>
									<option value="#h#" <cfif h EQ struct_hora_final.hora>selected</cfif>>0#h#</option>
								<cfelse>	
									<option value="#h#" <cfif H EQ struct_hora_final.hora>selected</cfif>>#h#</option>
								</cfif>
							</cfloop>
							</select>
							<select id="minutosfin_#contador#"  name="minutosfin_#contador#"  tabindex="#contador#" onchange="javascript:cambio_horas(#contador#);">
							<cfloop from="0" to="59" index="m">
								<cfif m lt 10>
									<option value="#m#" <cfif m EQ struct_hora_final.minutos>selected</cfif>>0#m#</option>
								<cfelse>	
									<option value="#m#" <cfif m EQ struct_hora_final.minutos>selected</cfif>>#m#</option>
								</cfif>
							</cfloop>
							</select>
							<select  id="meridianofin_#contador#" name="meridianofin_#contador#"  tabindex="#contador#" onchange="javascript:cambio_horas(#contador#);">
								<option value="AM" <cfif "AM" EQ struct_hora_final.meridiano >selected</cfif> >AM</option>
								<option value="PM" <cfif "PM" EQ struct_hora_final.meridiano >selected</cfif>  >PM</option>
							</select>

						</td>
						<td valign="top"><cf_inputnumber name="horas_#contador#" enteros="5" decimales="2" value="#duracion_por_dia#"  tabindex="#contador#"></td>
						<td valign="top" align="center"><input type="checkbox" name="eliminar_#contador#" value="" <cfif isdefined("datos_dia") and datos_dia.RHDCactivo eq 0>checked="checked"</cfif> /></td>
						<td><cfif isdefined("datos_dia") and datos_dia.RHDCactivo eq 0><img src="/cfmx/rh/imagenes/idelete.gif" title="#MSG_Dia_deshabilitado#" /></cfif></td>
					</tr>
					<cfset fecha_iterador = dateadd('d', 1, fecha_iterador) >
				</cfloop> 
			</table>
		</td></tr>
		<tr>
			<td align="center">
				<input type="submit" name="Programar" class="btnAplicar" value="#lb_programar#" tabindex="#contador+1#">
				<!---<input type="submit" name="Eliminar" class="btnEliminar" value="#lb_eliminar#" tabindex="#contador+1#" onclick="javascript: return funcEliminar();">--->
				<input type="button" name="Regresar" class="btnAnterior" value="#lb_regresar#" tabindex="#contador+1#" onclick="javascript:location.href='index.cfm?RHCid=#form.RHCid#'">
			</td>
		</tr>
		
		<cfif rs_programacion.recordcount eq 0 >
			<tr><td align="center"><font color="##FF0000">#MSG_INFO_Guardar#</font></td></tr>
		</cfif>
		
	</table>
	<input type="hidden" name="contador" value="#contador#" />
	<input type="hidden" name="RHCid" value="#form.RHCid#" />
	</form>

	<script language="javascript1.2" type="text/javascript">
		function funcEliminar(){
			return confirm('#MSG_Eliminar#');
		}
		
		function cambio_horas(i){
			obj = eval("document.form1.horas_"+i);
			obj.value = '';
		}
	</script>

<cf_templatefooter	>
</cfoutput>