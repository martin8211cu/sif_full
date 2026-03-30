<!--- Por defecto toma la fecha de hoy --->

<cfset fechabusquedaI = now()>
<cfif  isdefined("form.fechabusquedaI") and len(trim(form.fechabusquedaI)) >
	<cfset fechabusquedaI = LSParseDateTime(Form.fechabusquedaI)>
</cfif>



<cfif  isdefined("form.fechabusquedaF") and len(trim(form.fechabusquedaF)) >
	<cfset fechabusquedaF = LSParseDateTime(Form.fechabusquedaF)>
</cfif>

<cfif  not isdefined("form.fechabusquedaF") or (isdefined("form.fechabusquedaF") and len(trim(form.fechabusquedaF)) eq 0)>
	<cfset fechabusquedaF = DateAdd("d", 7,fechabusquedaI)>
</cfif>

<cfquery name="rspersona" datasource="#session.tramites.dsn#">
	select  nombre || ' '  || apellido1  || ' ' || apellido2 as nombre,identificacion_persona,nombre_tipoident
	from  TPPersona a, TPTipoIdent b
	where id_persona= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_persona#">
	and  a.id_tipoident  = b.id_tipoident 
</cfquery>

<cfset annoI 	= DatePart('yyyy',fechabusquedaI)>
<cfset mesI 	= DatePart('m',fechabusquedaI)>
<cfset diaI 	= DatePart('d',fechabusquedaI)>
<cfset annoF 	= DatePart('yyyy',fechabusquedaF)>
<cfset mesF 	= DatePart('m',fechabusquedaF)>
<cfset diaF 	= DatePart('d',fechabusquedaF)>

<cfset fechaIni = CreateDateTime(annoI,mesI,diaI,'00','00','00')>
<cfset fechaFin = CreateDateTime(annoF,mesF,diaF,'23','59','59')>
<cfquery name="tipoidentificacion" datasource="#session.tramites.dsn#">
	select id_tipoident, codigo_tipoident, nombre_tipoident 
	from TPTipoIdent
</cfquery>
<cfif  isdefined("fechabusquedaI") and len(trim(fechabusquedaI)) and isdefined("fechabusquedaF") and len(trim(fechabusquedaF)) and isdefined("session.tramites.id_persona") and len(trim(session.tramites.id_persona))>
	<cfquery datasource="#session.tramites.dsn#" name="traeCitas">
		select fecha, a.id_cita , case when  a.id_requisito is null  then 'NO' else 'SI' end as requisito
		,b.hora_desde,b.hora_hasta ,nombre_tiposerv,nombre_inst,
		'<img border=''0'' onClick=''eliminar('||<cf_dbfunction datasource="#session.tramites.dsn#" name="to_char" args="a.id_cita">||');'' src=''/cfmx/sif/imagenes/Borrar01_S.gif''>' as borrar
		from  TPCita a
		join  TPAgenda b
			on a.id_agenda       = b.id_agenda 
		join  TPTipoServicio c
			on b.id_tiposerv       = c.id_tiposerv 
		join  TPInstitucion d
			on c.id_inst        = d.id_inst 
		where  id_persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_persona#">
		and  fecha >=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fechaIni#">
		and  fecha <=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fechaFin#">
		and borrado = 0	
		order by fecha,hora_desde,hora_hasta
	</cfquery>
</cfif>

<table width="100%" border="0">
		<tr>
			<td colspan="2" bgcolor="#ECE9D8" style="padding:3px; border-bottom:1px solid black; border-top:1px solid black;">
				<strong><font  style=" font-size:13px;">Citas Programadas</font></strong> 
			</td>
		</tr>	
		<tr>
			<td colspan="2">
				<cfoutput>
				<form action="req_cita.cfm" method="post" name="formB" style="margin:0" >
					<table width="100%" border="0">
						<tr>
							<td width="20%"  nowrap valign="top"><strong><cfif isdefined("rspersona.nombre_tipoident")  and len(trim(rspersona.nombre_tipoident))>#trim(rspersona.nombre_tipoident)#</cfif>:&nbsp;</strong></td>
							<td colspan="2" width="80%">
								<input autocomplete="off" 
									name="identificacion_persona" 
									type="text" 
									readonly="true"
									onblur="javascript: TraeIdent(); " 
									style="border: medium none; text-align:left; size:auto;"
									value="<cfif isdefined("rspersona.identificacion_persona")  and len(trim(rspersona.identificacion_persona))>#trim(rspersona.identificacion_persona)#</cfif>">
							</td>
						</tr>
						<tr>
							<td  valign="bottom">&nbsp;</td>
							<td colspan="3">
								<INPUT 	TYPE="textbox" 
										NAME="NOMBRE" 
										VALUE="<cfif isdefined("rspersona.NOMBRE")  and len(trim(rspersona.NOMBRE))>#trim(rspersona.NOMBRE)#</cfif>" 
										SIZE="60" 
										readonly="true" 
										MAXLENGTH="60" 
										style="border: medium none; text-align:left; size:auto;"
								>
							 </td>
						</tr>						
					</table>
				</form>
				</cfoutput>			
			</td>
		</tr>				  
	  
	  <tr>
		<td valign="top">
			<cfoutput>
			<form action="cons_cita.cfm" method="post" name="Busqueda" style="margin:0" >
				<table width="100%" border="0">
					<tr>
						<td bgcolor="##ECE9D8" style="padding:3px; border-bottom:1px solid black; border-top:1px solid black;">
							<strong>Fecha Inicial</strong>
						</td>
						<td bgcolor="##ECE9D8" style="padding:3px; border-bottom:1px solid black; border-top:1px solid black;">
							<strong>Fecha Final</strong>
						</td>						
					</tr>	
					 <tr>
						<td align="left">
							<cf_sifcalendario 
							form="Busqueda"  
							value="#LSDateFormat(fechabusquedaI,'DD/MM/YYYY')#" 
							name="fechabusquedaI">						
						</td>
						<td align="left">
							<cf_sifcalendario 
							form="Busqueda"  
							value="#LSDateFormat(fechabusquedaF,'DD/MM/YYYY')#" 
							name="fechabusquedaF">						
						</td>						
						
					</tr>						
					<tr>
						<td  colspan="2" align="center" >&nbsp;</td>
					</tr>
					<tr>
						<td colspan="2" nowrap align="center" >
							<input type="button"  onClick="javascript:Buscar();" value="Buscar" class="boton">
 						    <!--- <input type="button"  onClick="javascript: Regresar();" value="Regresar" class="boton">	 --->
						</td>
					</tr>											 				 
				</table>
				<input type="hidden" name="id_persona" value="<cfif isdefined("session.tramites.id_persona")>#session.tramites.id_persona#</cfif>">
			</form>
			</cfoutput>		
		</td>
	<tr>
	</tr>	
		<td valign="top" align="center">
			<form action="cons_cita_sql.cfm" method="post" name="form1" style="margin:0" >
				<table  id="tablacitas" width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="##333333">
					<tr>
						<cfoutput>
						<cfif  isdefined("traeCitas") and traeCitas.recordcount EQ 0>
							<td  bgcolor="##ECE9D8" colspan="1" align="center" style="font-size:11px"></b>Entre las fechas  #LSDateFormat(fechabusquedaI, "dd/mm/yyyy")#  y #LSDateFormat(fechabusquedaF, "dd/mm/yyyy")# no hay citas programadas</b></td>
						<cfelse>
							<td  bgcolor="##ECE9D8" colspan="1" align="center" style="font-size:11px"><b>Citas programadas entre las fechas #LSDateFormat(fechabusquedaI, "dd/mm/yyyy")# y #LSDateFormat(fechabusquedaF, "dd/mm/yyyy")#</b></td>
						</cfif>
						</cfoutput>
					</tr>
					<tr>
					<cfif  isdefined("traeCitas") and traeCitas.recordcount GT 0>
						<td align="left" valign="top" bgcolor="white">
							<table  width="100%" border="0" cellpadding="2" cellspacing="0">
								<cfoutput query="traeCitas" group="fecha">
									<tr>
										<td  colspan="5"class="tituloListas" >Fecha: #LSDateFormat(fecha, "dd/mm/yyyy")#</td>
									</tr>								
									<tr>
										<td class="tituloListas" >Cita</td>
										<td class="tituloListas" >Horario</td>
										<td class="tituloListas" >Es un trámite</td>
										<td class="tituloListas" >&nbsp;</td>
										<td class="tituloListas" >&nbsp;</td>
									</tr>

									<cfoutput group="hora_desde">
										<cfoutput group="hora_hasta">
											<tr style="cursor:pointer;"
											class="<cfif traeCitas.CurrentRow MOD 2>listaNon<cfelse>listaPar</cfif>" 
											onmouseover="style.backgroundColor='##E4E8F3';" 
											onMouseOut="style.backgroundColor='<cfif traeCitas.CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>'"
											>
												
												<td  nowrap><font  style=" font-size:9px;">#nombre_tiposerv#</font></td>
												<td><font  style=" font-size:9px;">De #LSTimeFormat(hora_desde, "hh:mm tt")# a #LSTimeFormat(hora_hasta, "hh:mm tt")#</font></td>
												<td align="left"><font  style=" font-size:9px;">#requisito#</font></td>
												<td><img  border="0"   height="22" width="22" onClick="javascript:vercita('#id_cita#');" src="../../images/search.gif"></td>
												<td>#borrar#</td>
											</tr>
										</cfoutput>
									</cfoutput>
								</cfoutput>
							</table>
						</td>
					</cfif>
				</tr>
			</table>
			<cfoutput>
				<input type="hidden" name="fechabusqueda" value="<cfif isdefined("form.fechabusqueda")>#form.fechabusqueda#</cfif>">
				<input type="hidden" name="id_persona" value="<cfif isdefined("session.tramites.id_persona")>#session.tramites.id_persona#</cfif>">
				<input type="hidden" name="id_cita" value="">
			</cfoutput>
			</form>
			
		</td>
	  </tr>
</table>

<script type="text/javascript">
<!--	
 
	function Buscar() {
		todobien = true;
		var msg = '';
		var ctl = null;
		
		if(document.form1.id_persona.value == ""){
			{ msg += "\n* Digite la identificacion de la persona que desea realizar la cita"; ctl = ctl?ctl:document.form1.id_persona; }
		}	
		if (msg.length || ctl) {
			alert('Verifique la siguiente información:' + msg);
			todobien = false;
		}
		if (todobien){
			document.Busqueda.action = "cons_cita.cfm";
			document.Busqueda.submit();
		}
	}
	
	function ocultatabla(cond) {
		var tablacitas = document.getElementById("tablacitas");
		if(cond == 'S'){
			tablacitas.style.display = 'none';
		}
		else{
			tablacitas.style.display = '';
		}
	}
	
	function eliminar (id_cita) {
		if (confirm('¿Desea eliminar la cita?')){
			todobien = true;
			var msg = '';
			var ctl = null;
			document.form1.id_cita.value = id_cita;
			if(document.form1.id_cita.value == ""){
				{ msg += "\n* Seleccione la cita que desea cancelar"; ctl = ctl?ctl:document.form1.id_cita; }
			}	
			if(document.form1.id_persona.value == ""){
				{ msg += "\n* Digite la identificacion de la persona que desea cancelar la cita "; ctl = ctl?ctl:document.form1.id_persona; }
			}	
			if (msg.length || ctl) {
				alert('Verifique la siguiente información:' + msg);
				todobien = false;
			}
			if (todobien)
				document.form1.submit();		
		}
	}
	function Regresar(){
			location.href="/cfmx/home/menu/modulo.cfm?s=sys&m=TP";
	}
	function vercita(id_cita){
		var PARAM  = "vercita.cfm?id_cita="+ id_cita ;
		open(PARAM,'','left=300,top=150,scrollbars=yes,resizable=yes,width=500,height=400')
	}

	
	
//-->
</script>