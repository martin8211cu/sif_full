<!--- Por defecto toma la fecha de hoy --->
<cfset form.id_inst = session.tramites.id_inst>

<cfset losdias="Domingo,Lunes,Martes,Miércoles,Jueves,Viernes,Sábado"> 

<cfset fechabusqueda = now()>
<cfif  isdefined("form.fechabusqueda") and len(trim(form.fechabusqueda)) >
	<cfset fechabusqueda = LSParseDateTime(Form.fechabusqueda)>
</cfif>
<cfset anno 	= DatePart('yyyy',fechabusqueda)>
<cfset mes 		= DatePart('m',fechabusqueda)>
<cfset dia 		= DatePart('d',fechabusqueda)>
<cfset fechaIni = CreateDateTime(anno,mes,dia,'00','00','00')>
<cfset fechaFin = CreateDateTime(anno,mes,dia,'23','59','59')>

<cfquery datasource="#session.tramites.dsn#" name="rsInstituciones">
	select distinct  a.id_inst , a.codigo_inst,a.nombre_inst  
	from TPInstitucion a
	where a.id_inst = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_inst#" null="#len(form.id_inst) eq 0#">
</cfquery>

<cfquery datasource="#session.tramites.dsn#" name="rsServicios">
	select distinct  a.id_inst , a.id_tiposerv ,a.codigo_tiposerv, a.nombre_tiposerv
	from TPTipoServicio a
	join TPAgenda b
		on   a.id_inst       = b.id_inst 
		and  a.id_tiposerv   = b.id_tiposerv 
	order by id_inst , id_tiposerv
</cfquery>

<cfquery datasource="#session.tramites.dsn#" name="rsSucursales">
	select distinct  a.id_inst ,id_tiposerv,a.id_sucursal, a.codigo_sucursal,a.nombre_sucursal 
	from TPSucursal a
	join TPAgenda b
		on   a.id_inst               = b.id_inst 
		and a.id_sucursal       = b.id_sucursal 
	order by id_inst,id_tiposerv,id_sucursal
</cfquery>
<cfif  isdefined("form.id_sucursal") and len(trim(form.id_sucursal)) and  isdefined("form.id_tiposerv") and len(trim(form.id_tiposerv)) and isdefined("form.fechabusqueda") and len(trim(form.fechabusqueda))> 
	<cfquery datasource="#session.tramites.dsn#" name="traeCitas">
		select nombre || ' '  || apellido1  || ' ' || apellido2 as nombre,identificacion_persona,hora_desde,hora_hasta,
		case when  b.asistencia  = 0 then 
			'<img border=''0'' onClick=''asistencia('||<cf_dbfunction datasource="#session.tramites.dsn#" name="to_char" args="b.id_cita">||');'' src=''/cfmx/home/tramites/images/forward.gif''>'
		else
			'<img border=''0'' src=''/cfmx/home/tramites/images/check-verde.gif''>'
		end
		 as llego
		from TPAgenda  a
		join  TPCita  b
			on a.id_agenda       = b.id_agenda 
		join  TPPersona c
			on b.id_persona = c.id_persona
		where id_tiposerv  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tiposerv#">
		and  id_sucursal   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_sucursal#">	
		and  fecha >=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fechaIni#">
		and  fecha <=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fechaFin#">
		order by  hora_desde,hora_hasta,identificacion_persona 
	</cfquery>

	<cfquery datasource="#session.tramites.dsn#" name="rsSucursalesL">
		select distinct  a.nombre_sucursal 
		from TPSucursal a
		where  id_sucursal = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_sucursal#">
	</cfquery>
	<cfquery datasource="#session.tramites.dsn#" name="rsServiciosL">
		select a.nombre_tiposerv
		from TPTipoServicio a
		where  id_tiposerv = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tiposerv#">	
	</cfquery>
	
</cfif>
<table width="100%" border="0">
		<tr>
			<td colspan="2" bgcolor="#ECE9D8" style="padding:3px; border-bottom:1px solid black; border-top:1px solid black;">
				<strong>Actividades para el día <cfoutput>#LSDateFormat(fechabusqueda, "dd/mm/yyyy")#</cfoutput></strong> 
			</td>
		</tr>	
	  <tr>
		<td   valign="top">
			<cfoutput>
			<form action="cons_citaxRec.cfm" method="post" name="Busqueda" style="margin:0" >
				<input type="hidden" name="id_inst" value="<cfif isdefined("form.id_inst")>#form.id_inst#</cfif>">
				<table width="100%" border="0">
					 <tr>
						<td  align="left">
							<cf_calendario 
								form="Busqueda" 
								includeForm="no" 
								name="fechabusqueda" 
								fontSize="10" 
								value ="#fechabusqueda#"
								onChange="javascript:ocultatabla('S'); Buscar();">
						</td>
						<td valign="top"><strong>Servicio</strong>:  
							<select name="id_tiposerv"onChange="javascript:CargaSuc(this.value); ocultatabla('S');" >
								<option value="">-Selecione un servicio -</option>
							</select><br>
							<strong>Sucursal</strong>: 
							<select name="id_sucursal" onChange="javascript:ocultatabla('S');" >
								<option value="">-Selecione una sucursal-</option>
							</select>
						</td>						
					</tr>		
					<tr>
						<td  colspan="2 "align="center" >&nbsp;</td>
					</tr>
					<tr>
						<td  colspan="2 " nowrap align="center" >
							<input type="button"  onClick="javascript:Buscar();" value="Buscar" class="boton">
 						    <!--- <input type="button"  onClick="javascript: Regresar();" value="Regresar" class="boton">	 --->
						</td>
					</tr>											 				 
				</table>
			</form>
			</cfoutput>		
		</td>
		</tr>
		<tr>
		<td  valign="top" align="center">
			<form action="cons_citaxRec_sql.cfm" method="post" name="form1" style="margin:0" >
				<table  id="tablacitas" width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="##333333">
					<cfif  isdefined("traeCitas") and traeCitas.recordcount GT 0>
						<cfoutput>	
						<tr>
							<td  bgcolor="##ECE9D8" colspan="1" align="center" style="font-size:11px">
								<table id="tablacitas2" width="100%" border="0" cellpadding="0" cellspacing="0">
									<tr>
										<td colspan="2"  align="center" bgcolor="##ECE9D8" style="padding:3px; border-top:1px solid black;">
											<strong><font size="1">#rsInstituciones.nombre_inst#</font></strong> 
										</td>
									</tr>		
									<tr>
										<td colspan="2"  align="center" bgcolor="##ECE9D8" style="padding:3px;">
											<strong><font size="1">#rsSucursalesL.nombre_sucursal#</font></strong> 
										</td>
									</tr>	
									<tr>
										<td colspan="2"  align="center" bgcolor="##ECE9D8" style="padding:3px;">
											<strong><font size="1">Servicio:&nbsp;&nbsp;#rsServiciosL.nombre_tiposerv#</font></strong> 
										</td>
									</tr>		
									<tr>
										<td colspan="2"  align="center" bgcolor="##ECE9D8" style="padding:3px; border-bottom:1px solid black;">
											<strong><font size="1">Agenda de citas del día&nbsp;#ListGetAt(losdias,DayOfWeek(fechabusqueda), ",")#&nbsp;#LSDateFormat(fechabusqueda, "dd/mm/yyyy")#&nbsp;</font></strong> 
										</td>
									</tr>	
								</table>
							</td>
						</tr>
						</cfoutput>		
						<tr>
							<td align="left" valign="top" bgcolor="white">
								<table  width="100%" border="0" cellpadding="2" cellspacing="0">
									<cfoutput query="traeCitas">
										<tr>
										  <td  colspan="3" class="tituloListas" >Hora : De #LSTimeFormat(hora_desde, "hh:mm tt")# a #LSTimeFormat(hora_hasta, "hh:mm tt")#</td>
										</tr>
										<tr>
											<td class="tituloListas" >Identificación</td>
											<td class="tituloListas" >Nombre</td>
											<td align="right" class="tituloListas" >Confirmar Asistencia</td>
										</tr>									
										<cfoutput group="hora_desde">
											<tr style="cursor:default;"
											class="<cfif traeCitas.CurrentRow MOD 2>listaNon<cfelse>listaPar</cfif>" 
											onmouseover="style.backgroundColor='##E4E8F3';" 
											onMouseOut="style.backgroundColor='<cfif traeCitas.CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>'"
											>
												<td>#identificacion_persona#</td>
												<td nowrap>#nombre#</td>
												<td  align="right">#llego#</td>
											</tr>
										</cfoutput>
									</cfoutput>
									<tr>
										<td  colspan="3"  align="center">
										<input type="button"  onClick="javascript:ImprimirAG();" value="Imprimir" class="boton">
										</td>
									</tr>	
								</table>
							</td>
						</tr>
				</cfif>
			</table>
			<cfoutput>
				<input type="hidden" name="fechabusqueda" value="<cfif isdefined("form.fechabusqueda")>#form.fechabusqueda#</cfif>">
				<input type="hidden" name="id_cita" value="">
				<input type="hidden" name="id_tiposerv" value="<cfif isdefined("form.id_tiposerv")>#form.id_tiposerv#</cfif>">
				<input type="hidden" name="id_sucursal" value="<cfif isdefined("form.id_sucursal")>#form.id_sucursal#</cfif>">
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
		if(document.Busqueda.id_inst.value == ""){
			{ msg += "\n* Seleccione la institución"; ctl = ctl?ctl:document.Busqueda.id_inst; }
		}	
		if(document.Busqueda.id_tiposerv.value == ""){
			{ msg += "\n* Seleccione el servicio"; ctl = ctl?ctl:document.Busqueda.id_tiposerv; }
		}	
		if(document.Busqueda.id_sucursal.value == ""){
			{ msg += "\n* Seleccione la sucursal"; ctl = ctl?ctl:document.Busqueda.id_sucursal; }
		}	
		
		if (msg.length || ctl) {
			alert('Verifique la siguiente información:' + msg);
			todobien = false;
		}
		if (todobien){
			document.Busqueda.action = "cons_citaxRec.cfm";
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
		<cfif  isdefined("traeCitas") and traeCitas.recordcount GT 0>
			var tablacitas2 = document.getElementById("tablacitas2");
			if(cond == 'S'){
				tablacitas2.style.display = 'none';
			}
			else{
				tablacitas2.style.display = '';
			}
		</cfif>
	}
	
	function Regresar(){
		location.href="/cfmx/home/menu/modulo.cfm?s=sys&m=TP";
	}

	function CargaSuc(valor){
		var form = document.Busqueda;
		var institucion = form.id_inst.value;
		var combo2 = form.id_sucursal;
		removeAll(form.id_sucursal)
		combo2.options.selectedIndex = 0
		addElement(combo2,'-Selecione una sucursal-','',true)
		var i = 1;
		<cfoutput query="rsSucursales">
			var tmp = '#rsSucursales.id_tiposerv#' ;
			var Inst = '#rsSucursales.id_inst#' ;
			if ( valor != '' && tmp != '' && parseFloat(valor) == parseFloat(tmp) && parseFloat(Inst) == parseFloat(institucion) ) {
				addElement(combo2,'#trim(rsSucursales.nombre_sucursal)#','#rsSucursales.id_sucursal#',false)
				<cfif isdefined("form.id_sucursal") and trim(rsSucursales.id_sucursal) EQ trim(form.id_sucursal)>
					combo2.options.selectedIndex = i;
				</cfif>
				i++;
			} 
		</cfoutput>
	}	

	
	function Cargaserv(valor){
		var form = document.Busqueda;
		var combo = form.id_tiposerv;
		removeAll(form.id_tiposerv)
		combo.options.selectedIndex = 0
		addElement(combo,'-Seleccione un servicio-','',true)
		var i = 1;
		<cfoutput query="rsServicios">
			var tmp = #rsServicios.id_inst# ;
			if ( valor != '' && tmp != '' && parseFloat(valor) == parseFloat(tmp) ) {
				addElement(combo,'#trim(rsServicios.nombre_tiposerv)#','#rsServicios.id_tiposerv#',false)
				<cfif isdefined("form.id_tiposerv") and trim(rsServicios.id_tiposerv) EQ trim(form.id_tiposerv)>
					combo.options.selectedIndex = i;
				</cfif>
				i++;
			} 
		</cfoutput>
	}
		
	<cfif isdefined("form.id_inst") and  len(trim(form.id_inst))>
		Cargaserv('<cfoutput>#form.id_inst#</cfoutput>')
	</cfif>
	<cfif isdefined("form.id_tiposerv") and  len(trim(form.id_tiposerv))>
		CargaSuc('<cfoutput>#trim(form.id_tiposerv)#</cfoutput>')
	</cfif>		

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
	<cfif  isdefined("form.id_sucursal") and len(trim(form.id_sucursal)) and  isdefined("form.id_tiposerv") and len(trim(form.id_tiposerv)) and isdefined("form.fechabusqueda") and len(trim(form.fechabusqueda))>
		function ImprimirAG(){
			var fecha 			= '<cfoutput>#LSDateFormat(fechabusqueda,"mm/dd/yyyy")#</cfoutput>';
			var id_tiposerv 	= '<cfoutput>#form.id_tiposerv#</cfoutput>';
			var id_sucursal 	= '<cfoutput>#form.id_sucursal#</cfoutput>';		
			var PARAM  = "imprimir_Agenda.cfm?id_tiposerv="+ id_tiposerv + "&id_sucursal=" + id_sucursal+ "&fecha=" + fecha;
			open(PARAM,'','left=100,top=150,scrollbars=yes,resizable=yes,width=800,height=400')
		}
		
	function asistencia (id_cita) {
		if (confirm('¿Desea confirmar la asistencia a la cita?')){
			todobien = true;
			var msg = '';
			var ctl = null;
			document.form1.id_cita.value = id_cita;
			if(document.form1.id_cita.value == ""){
				{ msg += "\n* Seleccione la persona que desea confirmar"; ctl = ctl?ctl:document.form1.id_cita; }
			}	

			if (msg.length || ctl) {
				alert('Verifique la siguiente información:' + msg);
				todobien = false;
			}
			if (todobien)
				document.form1.submit();		
		}
	}
	</cfif>
//-->
</script>