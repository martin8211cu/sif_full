<title>
		Agenda
</title>	
<link href="/cfmx/home/tramites/tramites.css" rel="stylesheet" type="text/css">
<link href="/cfmx/plantillas/login02/sif_login02.css" rel="stylesheet" type="text/css">

 

<cfset losdias="Domingo,Lunes,Martes,Miércoles,Jueves,Viernes,Sábado"> 

<cfset anno 	= DatePart('yyyy',url.fecha)>
<cfset mes 		= DatePart('m',url.fecha)>
<cfset dia 		= DatePart('d',url.fecha)>
<cfset fechaIni = CreateDateTime(anno,mes,dia,'00','00','00')>
<cfset fechaFin = CreateDateTime(anno,mes,dia,'23','59','59')>

<cfquery datasource="#session.tramites.dsn#" name="traeCitas">
	select nombre || ' '  || apellido1  || ' ' || apellido2 as nombre,identificacion_persona,hora_desde,hora_hasta, 
		case when  b.asistencia  = 1 then 
			'<img border=''0'' src=''/cfmx/home/tramites/images/check-verde.gif''>'
		else
			''
		end
		 as asistencia	,
		case when  b.ausencia  = 1 then 
			'<img border=''0'' src=''/cfmx/home/tramites/images/check-verde.gif''>'
		else
			''
		end
		 as ausencia
	from TPAgenda  a
	join  TPCita  b
		on a.id_agenda       = b.id_agenda 
	join  TPPersona c
		on b.id_persona = c.id_persona
	where id_tiposerv  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_tiposerv#">
	and  id_sucursal   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_sucursal#">	
	and  fecha >=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fechaIni#">
	and  fecha <=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fechaFin#">
	order by  hora_desde,hora_hasta,identificacion_persona 

</cfquery>
<cfset form.id_inst = session.tramites.id_inst>
<cfquery datasource="#session.tramites.dsn#" name="rsInstituciones">
	select distinct  a.id_inst , a.codigo_inst,a.nombre_inst  
	from TPInstitucion a
	where a.id_inst = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_inst#" null="#len(form.id_inst) eq 0#">
</cfquery>

<cfquery datasource="#session.tramites.dsn#" name="rsSucursales">
	select distinct  a.nombre_sucursal 
	from TPSucursal a
	where  id_sucursal = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_sucursal#">
</cfquery>
<cfquery datasource="#session.tramites.dsn#" name="rsServicios">
	select a.nombre_tiposerv
	from TPTipoServicio a
	where  id_tiposerv = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_tiposerv#">	
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
				<strong><font size="5">#rsInstituciones.nombre_inst#</font></strong> 
			</td>
		</tr>		
		<tr>
			<td colspan="2"  align="center" bgcolor="##ECE9D8" style="padding:3px;">
				<strong><font size="4">#rsSucursales.nombre_sucursal#</font></strong> 
			</td>
		</tr>	
		<tr>
			<td colspan="2"  align="center" bgcolor="##ECE9D8" style="padding:3px;">
				<strong><font size="3">Servicio:&nbsp;&nbsp;#rsServicios.nombre_tiposerv#</font></strong> 
			</td>
		</tr>		
		<tr>
			<td colspan="2"  align="center" bgcolor="##ECE9D8" style="padding:3px; border-bottom:1px solid black;">
				<strong><font size="2">Agenda de citas del día&nbsp;#ListGetAt(losdias,DayOfWeek(fecha), ",")#&nbsp;#url.fecha#&nbsp;</font></strong> 
			</td>
		</tr>	
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>												
	</table>
</cfoutput>
<table  width="100%" border="0" cellpadding="2" cellspacing="0">
	<cfoutput query="traeCitas">
		<tr>
		  <td  colspan="4" class="tituloListas" >Hora : De #LSTimeFormat(hora_desde, "hh:mm tt")# a #LSTimeFormat(hora_hasta, "hh:mm tt")#</td>
		</tr>
		<tr>
			<td class="tituloListas" >Identificación</td>
			<td class="tituloListas" >Nombre</td>
			<td align="center"class="tituloListas" >Asistencia</td>
			<td align="center"class="tituloListas" >Ausencia</td>
		</tr>									
		<cfoutput group="hora_desde">
			<tr style="cursor:default;"
			class="<cfif traeCitas.CurrentRow MOD 2>listaNon<cfelse>listaPar</cfif>" 
			onmouseover="style.backgroundColor='##E4E8F3';" 
			onMouseOut="style.backgroundColor='<cfif traeCitas.CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>'"
			>
				<td>#identificacion_persona#</td>
				<td nowrap>#nombre#</td>
				<td  align="center">#asistencia#</td>
				<td  align="center">#ausencia#</td>				
			</tr>
		</cfoutput>
	</cfoutput>
		<tr>
			<td colspan="4">&nbsp;</td>
		</tr>												
		<tr>
			<td  align="center" colspan="4">*** Fin de la Consulta ***</td>
		</tr>			
	</table>
	
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
