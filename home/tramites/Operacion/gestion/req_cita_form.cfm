<cfif isdefined('url.id_persona') and not isdefined('form.id_persona')>
	<cfset form.id_persona = url.id_persona>
</cfif>
<cfif isdefined('url.id_instancia') and not isdefined('form.id_instancia')>
	<cfset form.id_instancia = url.id_instancia>
</cfif>
<cfif isdefined('url.id_tramite') and not isdefined('form.id_tramite')>
	<cfset form.id_tramite = url.id_tramite>
</cfif>
<cfif isdefined('url.id_requisito') and not isdefined('form.id_requisito')>
	<cfset form.id_requisito = url.id_requisito>
</cfif>

<cfif  isdefined("form.id_tiposerv") and len(trim(form.id_tiposerv))>
 	<cfset arreglo = listtoarray(form.id_tiposerv,",")>	
	<cfset form.id_tiposerv = arreglo[1]>
 	<cfif isdefined('arreglo') and ArrayLen(arreglo) GT 1>	
		<cfset form.id_inst = arreglo[2]>	
	</cfif>
</cfif>
<cfset fechabusqueda = now()>
<cfif  isdefined("form.fechabusqueda") and len(trim(form.fechabusqueda)) >
	<cfset fechabusqueda = LSParseDateTime(Form.fechabusqueda)>
</cfif>
<cfset quitardias  = DayOfWeek(fechabusqueda) -1>
<cfset fechainicio = DateAdd("d", -quitardias ,fechabusqueda)>	
<cfset anno 	= DatePart('yyyy',fechainicio)>
<cfset mes 		= DatePart('m',fechainicio)>
<cfset dia 		= DatePart('d',fechainicio)>
<cfset fecha = CreateDateTime(anno,mes,dia,'00','00','00')>
<cfset fechaH = CreateDateTime(DatePart('yyyy',now()),DatePart('m',now()),DatePart('d',now()),'00','00','00')>
<cfset dia_ini = 1>
<cfset dia_fin = dia_ini + 6>

<cfquery datasource="#session.tramites.dsn#" name="rsSucursales">
	select distinct  a.id_inst ,id_tiposerv,a.id_sucursal, a.codigo_sucursal,a.nombre_sucursal 
	from TPSucursal a
	join TPAgenda b
		on   a.id_inst               = b.id_inst 
		and a.id_sucursal       = b.id_sucursal 
	order by id_inst,id_sucursal
</cfquery>
<cfquery datasource="#session.tramites.dsn#" name="rsServicios">
	select distinct  a.id_inst , a.id_tiposerv ,a.codigo_tiposerv, a.nombre_tiposerv
	from TPTipoServicio a
	join TPAgenda b
		on   a.id_inst       = b.id_inst 
		and  a.id_tiposerv   = b.id_tiposerv 
	order by id_inst , id_tiposerv
</cfquery>
<cfquery name="tipoidentificacion" datasource="#session.tramites.dsn#">
	select id_tipoident, codigo_tipoident, nombre_tipoident 
	from TPTipoIdent
</cfquery>

<cfif isdefined("form.id_tramite") and len(trim(form.id_tramite))>
	<cfquery datasource="#session.tramites.dsn#" name="rsRequisito">
		select  id_tiposerv,id_inst from TPRequisito
		where id_requisito =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_requisito#">
	</cfquery>
	<cfquery datasource="#session.tramites.dsn#" name="tipo">
		select  id_tipoident from TPPersona 	
		where  id_persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_persona#">
	</cfquery>
	<cfset form.id_tiposerv      = rsRequisito.id_tiposerv>
	<cfset form.id_inst          = rsRequisito.id_inst>
	<cfset form.id_tipoident     = tipo.id_tipoident>
	<cfquery datasource="#session.tramites.dsn#" name="RSTieneAgenda">
		select count (*)  as cantidad from TPAgenda
		where id_tiposerv = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tiposerv#">
		and id_requisito  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_requisito#">
		and  id_inst      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_inst#">
	</cfquery>	
</cfif>

<cfset losdias="Domingo,Lunes,Martes,Miércoles,Jueves,Viernes,Sábado"> 
<cfset RSdias = QueryNew("horario,fecha,lugar,hora_desde,hora_hasta,cupo,recurso,tengo,mequeda")> 

<cfif  (fechabusqueda gte fechaH) >
	 <cfif  isdefined("form.id_tiposerv") and len(trim(form.id_tiposerv)) and isdefined("form.id_inst") and len(trim(form.id_inst))>
		 <cfquery datasource="#session.tramites.dsn#" name="traeHorarios">
				select a.id_agenda
					,ciudad as direccion
					,ciudad || ' ' || estado as direcciond
					,nombre_recurso
					,hora_desde
					,hora_hasta
					,cupo1,cupo2,cupo3,cupo4,cupo5,cupo6,cupo7
					,b.nombre_recurso
					,dia_semanal
				from TPAgenda a
				join  TPRecurso b
					on a.id_recurso     = b.id_recurso 
				join  TPDirecciones c
					on a.id_direccion   = c.id_direccion 
					where  a.id_tiposerv  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tiposerv#">
						and a.id_inst      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_inst#">	
					<cfif  isdefined("form.id_requisito") and len(trim(form.id_requisito))>
						and a.id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_requisito#">
					</cfif>
					<cfif  isdefined("form.id_sucursal") and len(trim(form.id_sucursal))>
						and a.id_sucursal  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_sucursal#">
					</cfif>					
		 </cfquery>
		 
		<cfloop from="#dia_ini#" to ="#dia_fin#" index="i">
			 <cfset dia = i>
			 <cfif dia gt 7>
			 	 <cfset dia = 1>
			 </cfif>
			  <cfset diaarreglo = dia>
			 <cfif traeHorarios.recordcount gt 0>
				<cfloop query="traeHorarios">
 				    <cfset arreglo = listtoarray(traeHorarios.dia_semanal,",")>	
					<cfif arreglo[diaarreglo] eq '1'>
						<cfset anno 	= DatePart('yyyy',fecha)>
						<cfset mes 		= DatePart('m',fecha)>
						<cfset dia 		= DatePart('d',fecha)>
						<cfset fechaHorario = CreateDateTime(anno,mes,dia,LSTimeFormat(traeHorarios.hora_desde, 'hh'),LSTimeFormat(traeHorarios.hora_desde, 'mm'),LSTimeFormat(traeHorarios.hora_desde, 'ss'))>
						<cfset cupoDia	= 0>
						
 						<cfswitch expression = #diaarreglo#>
							<cfcase value = 1>	<!--- Domingo --->
								<cfset cupoDia	= traeHorarios.cupo1>
							</cfcase>
							<cfcase value = 2>	<!--- Lunes --->
								<cfset cupoDia	= traeHorarios.cupo2>
							</cfcase>
							<cfcase value = 3>	<!--- Martes --->
								<cfset cupoDia	= traeHorarios.cupo3>
							</cfcase>
							<cfcase value = 4>	<!--- Miercoles --->
								<cfset cupoDia	= traeHorarios.cupo4>
							</cfcase>
							<cfcase value = 5>	<!--- Jueves --->
								<cfset cupoDia	= traeHorarios.cupo5>
							</cfcase>
							<cfcase value = 6>	<!--- Viernes --->
								<cfset cupoDia	= traeHorarios.cupo6>
							</cfcase>
							<cfcase value = 7>	<!--- Sabado --->
								<cfset cupoDia	= traeHorarios.cupo7>
							</cfcase>																																										
						</cfswitch>
						
						<cfquery datasource="#session.tramites.dsn#" name="traedatos">
							select case when  coalesce(count(numero_cupo),0) <  #cupoDia# then 'S' else 'N' end as cupo ,(  #cupoDia# - coalesce(count(numero_cupo),0)) as mequeda 
							from TPCita
							where id_agenda = <cfqueryparam cfsqltype="cf_sql_numeric" value="#traeHorarios.id_agenda#">
							and  fecha =  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fechaHorario#">
							and borrado = 0
						</cfquery>
						
						<cfquery datasource="#session.tramites.dsn#" name="rsvalidaferiado">
							select fecha,descripcion  from TPFeriados
							where fecha    = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fecha#">
						</cfquery> 
						<cfset QueryAddRow(RSdias,1)>
						<cfset QuerySetCell(RSdias,"horario",traeHorarios.id_agenda,RSdias.RecordCount)>
						<cfset QuerySetCell(RSdias,"fecha",fecha,RSdias.RecordCount)>
						<cfset QuerySetCell(RSdias,"hora_desde",traeHorarios.hora_desde,RSdias.RecordCount)>
						<cfset QuerySetCell(RSdias,"hora_hasta",traeHorarios.hora_hasta,RSdias.RecordCount)>
						<cfset QuerySetCell(RSdias,"lugar",traeHorarios.direccion,RSdias.RecordCount)>
						<cfset QuerySetCell(RSdias,"tengo",cupoDia,RSdias.RecordCount)>
						<cfset QuerySetCell(RSdias,"mequeda",traedatos.mequeda,RSdias.RecordCount)>
						<cfif fecha lt now()>
							<cfset QuerySetCell(RSdias,"cupo","N",RSdias.RecordCount)>
						 <cfelseif isdefined("rsvalidaferiado") and rsvalidaferiado.recordcount gt 0>
							<cfset QuerySetCell(RSdias,"cupo","F",RSdias.RecordCount)> 
						<cfelse>
							<cfset QuerySetCell(RSdias,"cupo",traedatos.cupo,RSdias.RecordCount)>
						</cfif>
						<cfset QuerySetCell(RSdias,"recurso",traeHorarios.nombre_recurso,RSdias.RecordCount)>
					</cfif>
				</cfloop>
			</cfif>	
			<cfset fecha = DateAdd("d", 1,fecha)>	
		</cfloop>
	</cfif>
</cfif>


	<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td colspan="2" bgcolor="#ECE9D8" style="padding:3px; border-bottom:1px solid black; border-top:1px solid black;"><strong>Horario de citas</strong> </td>
		</tr>		
		<tr>
			<td  colspan="2" align="center" >&nbsp;</td>
		</tr>		
		<tr>
			<td  valign="top" width="90">
				<cfoutput>
				<form action="req_cita_form.cfm" method="post" name="Busqueda" style="margin:0" >
					<table width="100%" border="0">
						 <tr>
							<td align="center">
								<cf_calendario 
									form="Busqueda" 
									includeForm="no" 
									name="fechabusqueda" 
									fontSize="10" 
									value ="#fechabusqueda#"
									onChange="javascript:ocultatabla('S'); Buscar();">
							</td>
						</tr>	 	
						<cfif not isdefined("form.id_tramite") or (isdefined("form.id_tramite") and len(trim(form.id_tramite)) eq 0 )>
							<input type="hidden" name="id_inst" value="<cfif isdefined("form.id_inst")>#form.id_inst#</cfif>">
							<tr>
								<td bgcolor="##ECE9D8" style="padding:3px; border-bottom:1px solid black; border-top:1px solid black;">
									<strong>Servicio</strong>
								</td>
							</tr>
							<tr>
								<td>
									<select name="id_tiposerv" onChange="javascript:CargaSuc(this.value); ocultatabla('S');">
										<option value="">-Selecione un servicio-</option>
										<cfloop query="rsServicios">
											<option  value="#rsServicios.id_tiposerv#,#rsServicios.id_inst#" <cfif isdefined("form.id_tiposerv") and trim(rsServicios.id_tiposerv) EQ trim(form.id_tiposerv)>selected</cfif> >#rsServicios.nombre_tiposerv#</option>
										</cfloop>
									</select>									
								</td>
							</tr>		
						<input type="hidden" name="id_tipoident" 			value="<cfif isdefined("form.id_tipoident")>#form.id_tipoident#</cfif>">
						<input type="hidden" name="identificacion_persona" 	value="<cfif isdefined("form.identificacion_persona")>#form.identificacion_persona#</cfif>">
						<input type="hidden" name="NOMBRE" 					value="<cfif isdefined("form.NOMBRE")>#form.NOMBRE#</cfif>">
						<input type="hidden" name="id_persona" 				value="<cfif isdefined("form.id_persona")>#form.id_persona#</cfif>">
		
						<cfelse>
							<input type="hidden" name="id_inst" value="<cfif isdefined("form.id_inst")>#form.id_inst#</cfif>">
							<input type="hidden" name="id_tiposerv" value="<cfif isdefined("form.id_tiposerv")>#form.id_tiposerv#</cfif>">
							<input type="hidden" name="id_persona" value="<cfif isdefined("form.id_persona")>#form.id_persona#</cfif>">
							<input type="hidden" name="id_tramite" value="<cfif isdefined("form.id_tramite")>#form.id_tramite#</cfif>">
							<input type="hidden" name="id_instancia" value="<cfif isdefined("form.id_instancia")>#form.id_instancia#</cfif>">
							<input type="hidden" name="id_requisito" value="<cfif isdefined("form.id_requisito")>#form.id_requisito#</cfif>">  
						</cfif>		
						<tr>
							<td bgcolor="##ECE9D8" style="padding:3px; border-bottom:1px solid black; border-top:1px solid black;">
								<strong>Sucursal</strong>
							</td>
						</tr>	
						<tr>
							<td>
								<select name="id_sucursal" onChange="javascript:ocultatabla('S');" >
									<option value="">Buscar en todas</option>
								</select>
							</td>
						</tr>		
						<tr>
							<td align="center" >&nbsp;</td>
						</tr>
						<tr>
							<td  nowrap align="center" >
								<input type="button"  onClick="javascript:Buscar();" value="Buscar" class="boton">
							</td>
						</tr>											 				 
					</table>
				</form>
				</cfoutput>
			</td>
			<td   width="380" align="center" valign="top"  style="padding:3px;">
					<form action="req_cita_sql.cfm" method="post" name="form1" style="margin:0" >
						<table  id="tablacitas" width="100%" border="1" cellspacing="1" cellpadding="0" bgcolor="#333333">
						<tr>
							<cfoutput>
							<cfif   RSdias.recordcount gt 0>
								<td bgcolor="##FF9966" colspan="7" align="center" style="font-size:11px"> Las celdas en color gris no son selecionables </td>
							</cfif>
							</cfoutput>
						</tr>						
						<tr>
							<cfoutput>
							<cfif   RSdias.recordcount gt 0>
								<td bgcolor="##ECE9D8" colspan="7" align="center" style="font-size:11px"> Haga clic en el lugar y hora que desea realizar la cita </td>
							</cfif>
							</cfoutput>
						</tr>

						<tr>
						<cfoutput query="RSdias" group="fecha">
							<td align="left" valign="top" bgcolor="white">
								<table width="100%" border="0" cellpadding="2" cellspacing="0" >
									<tr><td bgcolor="##ECE9D8" align="center"><font  style=" font-size:9px;"><b>#ListGetAt(losdias,DayOfWeek(fecha), ',')#</b></font><br></tr></td>
									<tr><td bgcolor="##ECE9D8" align="center"><font  style=" font-size:9px;"></b>#LSDateFormat(fecha, "dd/mm/yyyy")#<b></font><br></tr></td>
									<cfoutput group="hora_desde">
										<tr><td ></tr></td>
										<tr><td bgcolor="lightblue"><font  style=" font-size:8px;"><b>De #LSTimeFormat(hora_desde, "hh:mm tt")# </b></font><br></tr></td>
										<tr><td bgcolor="lightblue"><font  style=" font-size:8px;"><b>a #LSTimeFormat(hora_hasta, "hh:mm tt")#</b></font><br></tr></td>
										<cfoutput group="lugar">
											<cfset cita = ' \n Cupo total:  '& #tengo#  & ' persona (s) \n'>
											<cfset cita =  cita &' Cupo disponible: '& #mequeda#  & ' cupo (s) \n\n Confirmar la siguiente cita \n\n'>
											<cfset cita =  cita & ' Día : ' & ListGetAt(losdias,DayOfWeek(fecha), ',') & ' ' & LSDateFormat(fecha, "dd/mm/yyyy") & '  \n Hora: de ' >
											<cfset cita =  cita & LSTimeFormat(hora_desde, "hh:mm tt") & '  a ' & LSTimeFormat(hora_hasta, "hh:mm tt") & '  \n Lugar: '  &  lugar>
											<tr style="cursor:pointer "
												onmouseover="style.backgroundColor='cornflowerblue';" 
												onMouseOut="style.backgroundColor='white';" 
											>
												<cfif RSdias.cupo eq 'N'>
													<td  align="center"
														onClick="javascript: alert('El día de seleccionado ya se encuentra con todas las citas asignadas');" bgcolor="##CCCCCC">
														<font  style=" font-size:8px;">
														<b>#UCase(lugar)#</b></font>
													</tr>
												<cfelseif RSdias.cupo eq 'F'>
													<td  align="center"
														onClick="javascript: alert('El día de seleccionado es feriado y no se pueden asignar citas');" bgcolor="##CCCCCC">
														<font  style=" font-size:8px;">
														<b>#UCase(lugar)#</b></font>
													</tr>
												<cfelse>
													<td   align="center"
														onClick="javascript: cargadatos('#cita#','#RSdias.horario#','#LSDateFormat(RSdias.fecha,'mm/dd/yyyy')#','#LSTimeFormat(RSdias.hora_desde, 'hh')#','#LSTimeFormat(RSdias.hora_desde, 'mm')#','#LSTimeFormat(RSdias.hora_desde, 'ss')#');">
														<font  style=" font-size:8px;">
														<b>#UCase(lugar)#</b></font>
													</tr>
												</cfif>

											</td>
										</cfoutput>	
									</cfoutput>
								</table>
							</td>
					</cfoutput>
						</tr>
						</table>
					<cfoutput>
						<input type="hidden" name="fecha" value="">  
						<input type="hidden" name="hora" value="">  
						<input type="hidden" name="minutos" value=""> 
						<input type="hidden" name="segundos" value=""> 
						<input type="hidden" name="id_agenda" value=""> 
						<input type="hidden" name="id_persona" value="<cfif isdefined("form.id_persona")>#form.id_persona#</cfif>">
						<input type="hidden" name="id_tramite" value="<cfif isdefined("form.id_tramite")>#form.id_tramite#</cfif>">
						<input type="hidden" name="id_instancia" value="<cfif isdefined("form.id_instancia")>#form.id_instancia#</cfif>">
						<input type="hidden" name="id_requisito" value="<cfif isdefined("form.id_requisito")>#form.id_requisito#</cfif>">  
						<cfif isdefined("form.id_tramite")>
							<cfquery datasource="#session.tramites.dsn#" name="RSinst">
								select  ts_rversion
								from TPInstanciaRequisito
								where id_instancia  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_instancia#">
								and id_requisito =    <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_requisito#">
							</cfquery>
							<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#RSinst.ts_rversion#" returnvariable="ts">
							</cfinvoke>
							<input type="hidden" name="ts_rversion" 	 value="<cfif isdefined("ts")>#ts#</cfif>">
						</cfif>
					</form>
				</cfoutput>
			</td>
		</tr>
	</table>
<script type="text/javascript">
<!--	
	function CargaSuc(valor){
		var form = document.Busqueda;
		var combo2 = form.id_sucursal;
		removeAll(form.id_sucursal)
		combo2.options.selectedIndex = 0
		addElement(combo2,'Buscar en todas','',true)
		var i = 1;
		<cfoutput query="rsSucursales">
			var tmp = '#rsSucursales.id_tiposerv#' ;
			if ( valor != '' && tmp != '' && parseFloat(valor) == parseFloat(tmp) ) {
				addElement(combo2,'#trim(rsSucursales.nombre_sucursal)#','#rsSucursales.id_sucursal#',false)
				<cfif isdefined("form.id_sucursal") and trim(rsSucursales.id_sucursal) EQ trim(form.id_sucursal)>
					combo2.options.selectedIndex = i;
				</cfif>
				i++;
			} 
		</cfoutput>
	}	
	<cfif isdefined("form.id_tiposerv") and  len(trim(form.id_tiposerv))>
		CargaSuc('<cfoutput>#trim(form.id_tiposerv)#</cfoutput>')
	</cfif>		
	function Buscar() {
		todobien = true;
		var msg = '';
		var ctl = null;

		if(document.Busqueda.id_tiposerv.value == ""){
			{ msg += "\n* Seleccione el servicio que desea utilizar"; ctl = ctl?ctl:document.Busqueda.id_tiposerv; }
		}	
		if (msg.length || ctl) {
			alert('Verifique la siguiente información:' + msg);
			todobien = false;
		}
		if (todobien){
			document.Busqueda.action = "req_cita.cfm";
			document.Busqueda.submit();
		}
	}
	
	function addElement(obj,texto,valor,seleccionado) {
	   var option = new Option(texto,valor,"",seleccionado)
	   obj.options[obj.options.length] = option
	}	
	
	function removeElement(obj,item) {   
   		obj.options[item]=null   
	}

	function removeAll(obj) {
	   for (var i=0; i<obj.options.length; i++) {    
			removeElement(obj,i)
			i = -1
	   }
	}
	
	function cargadatos(cita,id,fecha,hh,mm,ss) {
		if ( confirm( cita  ) ) {
			document.form1.fecha.value = fecha;
			document.form1.hora.value    = hh;
			document.form1.minutos.value  = mm;
			document.form1.segundos.value  = ss;
			document.form1.id_agenda.value  = id;
			valida();
		}
	}
	
	function valida() {
		todobien = true;
		var msg = '';
		var ctl = null;
		
		if(document.form1.id_persona.value == ""){
			{ msg += "\n* Digite la identificacion de la persona que desea realizar la cita"; ctl = ctl?ctl:document.formB.identificacion_persona; }
		}	
		
		if (document.form1.fecha.value == '' || document.form1.id_agenda.value == '') { msg += "\n* Seleccione el lugar, la fecha y hora para su cita"; ctl = ctl?ctl:document.form1.fecha; }
		if (msg.length || ctl) {
			alert('Verifique la siguiente información:' + msg);
			todobien = false;
		}
		if (todobien)
			document.form1.submit();
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
	
	
	<cfif(isdefined("RSdias") and RSdias.recordcount gt 0)> 
		ocultatabla('N');
	</cfif>
	
	<cfif (isdefined("data") and data.recordcount eq 0)> 
		ocultatabla('S');
	</cfif>
	<cfoutput>
	function Regresar(){
		<cfif not isdefined("form.id_tramite") or (isdefined("form.id_tramite") and len(trim(form.id_tramite)) eq 0 )>
			location.href="/cfmx/home/menu/modulo.cfm?s=sys&m=TP";
		<cfelse>
			location.href="/cfmx/home/tramites/Operacion/gestion/gestion-form.cfm?identificacion_persona=#form.id_persona#&id_tipoident=#form.id_tipoident#&id_tramite=#form.id_tramite#&loc=gestion";
		</cfif>	
	}


	<cfif not isdefined("form.id_tramite") or (isdefined("form.id_tramite") and len(trim(form.id_tramite)) eq 0 )>
		function TraeIdent(){
			var tipo =  document.formB.id_tipoident.value;
			var dato =  document.formB.identificacion_persona.value;
			var frame = document.getElementById("traeid");
			frame.src = "ValidaID.cfm?tipo="+tipo+"&dato="+dato;
		}
	</cfif>	
	

	
	</cfoutput>
	
//-->
</script>
