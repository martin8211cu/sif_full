<title>
		Cita Programada
</title>	
<link href="/cfmx/home/tramites/tramites.css" rel="stylesheet" type="text/css">
<link href="/cfmx/plantillas/login02/sif_login02.css" rel="stylesheet" type="text/css">

<cfset losdias="Domingo,Lunes,Martes,Miércoles,Jueves,Viernes,Sábado"> 
<cfquery datasource="#session.tramites.dsn#" name="traeCitas">
	select c.nombre || ' '  || c.apellido1  || ' ' || c.apellido2 as nombre,
	case when  a.id_responsable is null  then 'Sin definir' else cr.nombre || ' '  || cr.apellido1  || ' ' || cr.apellido2  end as nombreR,
	c.identificacion_persona,hora_desde,hora_hasta,
 	nombre_tiposerv,nombre_inst ,nombre_sucursal ,pais,direccion1,direccion2, ciudad ,estado ,b.fecha
	from TPAgenda  a
	join  TPCita  b
		on a.id_agenda       = b.id_agenda 
	join  TPPersona c
		on b.id_persona = c.id_persona
	left outer join  TPPersona cr
		on a.id_responsable = cr.id_persona
	join  TPTipoServicio  d
		on   a.id_tiposerv       =d.id_tiposerv
		and a.id_inst        = d.id_inst 
	join  TPInstitucion e
		on   a.id_inst        = e.id_inst 
	join  TPSucursal f
		on   a.id_inst               = f.id_inst 
		and a.id_sucursal       = f.id_sucursal 
	join  TPDirecciones g
		on   a.id_direccion        = g.id_direccion
	where b.id_cita = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_cita#">	
</cfquery>
<cfoutput>
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr id="btnImprime">
			<td align="right" colspan="2">
				<input type="button"  onClick="javascript:imprimir();" value="Imprimir" class="boton">
			</td>
		</tr>		
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>	
		<tr>
			<td colspan="2"  align="center" bgcolor="##ECE9D8" style="padding:3px; border-top:1px solid black;">
				<strong><font size="4">#traeCitas.nombre_inst#</font></strong> 
			</td>
		</tr>		
		<tr>
			<td colspan="2"  align="center" bgcolor="##ECE9D8" style="padding:3px; border-bottom:1px solid black;">
				<strong><font size="3">#traeCitas.nombre_sucursal#</font></strong> 
			</td>
		</tr>	
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>		
		<tr>
			<td colspan="1"  width="30%" align="left"  style="padding:3px;">
				<strong>Solicitado Por:</strong> 
			</td>
			<td colspan="1"  align="left"  style="padding:3px;">
				#traeCitas.nombre#
			</td>			
		</tr>			
		<tr>
			<td colspan="1"  width="20%" align="left"  style="padding:3px;">
				<strong>Resposable:</strong> 
			</td>
			<td colspan="1"  align="left"  style="padding:3px;">
				#traeCitas.nombreR#
			</td>			
		</tr>			
		<tr>
			<td colspan="1"   align="left"  style="padding:3px;">
				<strong>Servicio Solicitado:</strong> 
			</td>
			<td colspan="1"  align="left"  style="padding:3px;">
				#traeCitas.nombre_tiposerv#
			</td>			
		</tr>		
		<tr>
			<td colspan="1"   align="left"  style="padding:3px;">
				<strong>Fecha:</strong> 
			</td>
			<td colspan="1"  align="left"  style="padding:3px;">
				#ListGetAt(losdias,DayOfWeek(traeCitas.fecha), ",")#&nbsp;#LSDateFormat(traeCitas.fecha,"mm/dd/yyyy")#
			</td>			
		</tr>				
		<tr>
			<td colspan="1"   align="left"  style="padding:3px;">
				<strong>Lugar:</strong> 
			</td>
			<td colspan="1"  align="left"  style="padding:3px;">
				#traeCitas.nombre_sucursal#
			</td>			
		</tr>		
		<tr>
			<td colspan="1"  align="left"  style="padding:3px;">
				<strong>Hora:</strong> 
			</td>
			<td colspan="1"  align="left"  style="padding:3px;">
				De #LSTimeFormat(traeCitas.hora_desde, "hh:mm tt")# a #LSTimeFormat(traeCitas.hora_hasta, "hh:mm tt")#
			</td>			
		</tr>
		<tr>
			<td colspan="1"  align="left"  style="padding:3px;">
				<strong>Ubicación:</strong> 
			</td>
			<td colspan="1"  align="left"  style="padding:3px;">
				#traeCitas.ciudad# - #traeCitas.estado#
			</td>			
		</tr>		
		<tr>
			<td colspan="1"  align="left"  style="padding:3px;">&nbsp;
				
			</td>
			<td colspan="1"  align="left"  style="padding:3px;">
				#traeCitas.direccion1#
			</td>			
		</tr>	
		<tr>
			<td colspan="1"  align="left"  style="padding:3px;">&nbsp;
				
			</td>
			<td colspan="1"  align="left"  style="padding:3px;">
				#traeCitas.direccion2#
			</td>			
		</tr>					
		<tr>
			<td  align="center" colspan="2">*** Fin de la Consulta ***</td>
		</tr>			
												
	</table>
</cfoutput>
<script type="text/javascript">
<!--	
	function imprimir() {
		var botones = document.getElementById("btnImprime");
		botones.style.display = 'none';
		window.print()	
		botones.style.display = ''
	}	
//-->
</script>	
