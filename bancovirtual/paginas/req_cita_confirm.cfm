<cfset losdias="Domingo,Lunes,Martes,Miércoles,Jueves,Viernes,Sábado">
<cfset DiaLetras = ListGetAt(losdias,DayOfWeek(url.fecha), ',')>
<cfif isdefined("url.id_persona")>
	<cfset form.id_persona =  #url.id_persona#>
</cfif>
<cfif isdefined("url.id_tramite")>
	<cfset form.id_tramite =  #url.id_tramite#>
</cfif>
<cfif isdefined("url.id_instancia")>
	<cfset form.id_instancia =  #url.id_instancia#>
</cfif>
<cfif isdefined("url.id_requisito")>
	<cfset form.id_requisito =  #url.id_requisito#>
</cfif> 
<cfif isdefined("url.id_tipoident")>
	<cfset form.id_tipoident =  #url.id_tipoident#>
</cfif> 

<cfquery datasource="tramites_cr" name="citainf">
	select a.id_agenda,ciudad ||' ' || estado as direccion ,direccion1,direccion2,nombre_recurso,codigo_recurso,hora_desde,hora_hasta,cupo,
	codigo_tiposerv,nombre_tiposerv,descripcion_tiposerv ,nombre_inst,codigo_inst 
		from TPAgenda a
		join  TPRecurso b
			on a.id_recurso   = b.id_recurso 
		join  TPDirecciones c			
			on a.id_direccion   = c.id_direccion 
		join  TPTipoServicio d			
			on a.id_tiposerv   = d.id_tiposerv
		join  TPInstitucion e		
			on d.id_inst  = e.id_inst
		where  a.id_agenda = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_agenda#">
</cfquery>
<!--- Style para que los botones sean de colores --->
<link href="/cfmx/home/tramites/tramites.css" rel="stylesheet" type="text/css">
<link href="/cfmx/plantillas/portal_asp2/portal.css" rel="stylesheet" type="text/css">
<cfoutput>

<cfset form.imprimir ='S'>


<table width="510" border="0" align="center"  cellpadding="0" cellspacing="0">
	<cfif isdefined("form.id_tramite") and len(trim(form.id_tramite))>
		<tr>
			<td colspan="2">
				<cfinclude template="payment_header.cfm">
			</td>
		</tr>
		<tr>
		  <td valign="top" ><cfinclude template="hdr_tramite.cfm"></td>
		  <td valign="top" ><cfinclude template="hdr_requisito.cfm"></td>
		</tr>	
	</cfif>
	<tr>
		<td colspan="2">
			<table width="100%" border="0" >
				<tr>
					<td colspan="2" bgcolor="##ECE9D8" style="padding:3px; border-bottom:1px solid black; border-top:1px solid black;">
						<strong>Confirmaci&oacute;n de la cita</strong>
					</td>
				</tr>	
				<cfif not isdefined("form.id_tramite") or (isdefined("form.id_tramite") and len(trim(form.id_tramite)) eq 0 )>
					<tr>
						<td  nowrap  style="padding:3px;">
							<strong>Servicio Solicitado </strong>
						</td>
						<td   style="padding:3px;">#citainf.codigo_tiposerv#-#citainf.nombre_tiposerv#
						</td>		
					</tr>	
					<tr>
						<td   style="padding:3px;">&nbsp; 
							
						</td>
						<td   style="padding:3px;">#citainf.descripcion_tiposerv#
						</td>		
					</tr>				
					<tr>
						<td  nowrap  style="padding:3px;">
							<strong>Institución que ofrece el servicio</strong>
						</td>
						<td   style="padding:3px;">#citainf.codigo_inst#-#citainf.nombre_inst#
						</td>		
					</tr>							
				</cfif>				
				<tr>
					<td width="20%"  style="padding:3px;">
						<strong>Día</strong>
					</td>
					<td width="80%"  style="padding:3px;">#DiaLetras#&nbsp;#url.fecha#
						
					</td>		
				</tr>		
				<tr>
					<td  style="padding:3px;">
						<strong>Horario</strong>
					</td>
					<td  style="padding:3px;">De #LSTimeFormat(citainf.hora_desde, "hh:mm tt")# a  #LSTimeFormat(citainf.hora_hasta, "hh:mm tt")#
						
					</td>		
				</tr>		
				<tr>
					<td   style="padding:3px;">
						<strong>Lugar de la cita </strong>
					</td>
					<td   style="padding:3px;">#citainf.direccion#
						
					</td>		
				</tr>		
				<tr>
					<td   style="padding:3px;">&nbsp; 
						
					</td>
					<td   style="padding:3px;">#citainf.direccion1#
					</td>		
				</tr>	
				<tr>
					<td   style="padding:3px;">&nbsp; 
						
					</td>
					<td   style="padding:3px;">#citainf.direccion2#
					</td>		
				</tr>									
				<tr>
					<td   style="padding:3px;">
						<strong>Recurso </strong>
					</td>
					<td   style="padding:3px;">#citainf.codigo_recurso#-#citainf.nombre_recurso#
						
					</td>		
				</tr>		

				<tr>
					<td colspan="2" >&nbsp;
						
					</td>
				</tr>		
				<tr id="botones">
					<td  colspan="2"  align="center">
						<input type="button"  onClick="javascript:INICIO();" value="Regresar" class="boton">
						<cfif not isdefined("form.id_tramite") or (isdefined("form.id_tramite") and len(trim(form.id_tramite)) eq 0 )>
							<input type="button"  onClick="javascript:imprimir();" value="Imprimir" class="boton">
						</cfif>						
					</td>
				</tr>				
			</table>	
		</td>
	</tr>	
</table>
<script type="text/javascript">
<!--	
	function INICIO(){
		<cfif isdefined("form.id_tramite") and len(trim(form.id_tramite))>
			location.href="/cfmx/home/tramites/Operacion/gestion/gestion-form.cfm?identificacion_persona=#form.id_persona#&id_tipoident=#form.id_tipoident#&id_tramite=#form.id_tramite#&loc=gestion";
		<cfelse>
			location.href="/cfmx/home/tramites/Operacion/gestion/req_cita.cfm";			
		</cfif>	
	}

	function imprimir() {
		var botones = document.getElementById("botones");
        botones.style.display = 'none';
		window.print()	
        botones.style.display = ''
	}	
	
//-->
</script>

</cfoutput>
