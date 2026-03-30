<cfparam default="0" name="url.Iid">
<cfparam default="0" name="url.cod">

<cfoutput>

<!---NOTA: esto lo podemos ingresar en una tabla para que sea dinamico--->
<cfif url.cod EQ 1> 
	<cfset mensaje = "La incidencia se encuentra pendiente de aprobar por el Jefe">
<cfelseif url.cod EQ 2>
	<cfset mensaje = "La incidencia se encuentra aprobada por el Jefe">
<cfelseif url.cod EQ 3>
	<cfset mensaje = "La incidencia se encuentra rechazada por el Jefe">
<cfelseif url.cod EQ 4>
	<cfset mensaje = "La incidencia se encuentra pendiente de aprobar por el Administrador">
<cfelseif url.cod EQ 5>
	<cfset mensaje = "La incidencia se encuentra aprobada por el Administrador">
<cfelseif url.cod EQ 6>
	<cfset mensaje = "La incidencia se encuentra rechazada por el Administrador">
<cfelseif url.cod EQ 10>
	<cfset mensaje = "La incidencia estaba aprobada por el Jefe y el Administrador de Nomina pero fue RECHAZADA por el Administrador de Incidencias.">
<cfelseif url.cod EQ 11>
	<cfset mensaje = "La incidencia estaba pendiente de aprobar por el jefe y fue denegada por el Administrador de Incidencias.">
<cfelseif url.cod EQ 12>
	<cfset mensaje = "La incidencia estaba pendiente de aprobar por el Administrador de Nomina  y fue denegada por el Administrador de Incidencias.">

<cfelseif url.cod EQ 13>
	<cfset mensaje = "La incidencia se encuentra en estado de ingresada.">
<cfelseif url.cod EQ 14>
	<cfset mensaje = "La incidencia se encontraba en estado de ingresada  y fue DENEGADA por el Administrador de Incidencias.">
<cfelseif url.cod EQ 15>
	<cfset mensaje = "La incidencia estaba en estado ingresada y fue APROBADA en ambos niveles por el Administrador de Incidencias.">
<cfelseif url.cod EQ 16>
	<cfset mensaje = "La incidencia estaba pendiente de aprobar por el Jefe y el Administrador de Nomina y fue APROBADA en ambos niveles por el Administrador de Incidencias.">
<cfelseif url.cod EQ 17>
	<cfset mensaje = "La incidencia estaba pendiente de aprobar por el Jefe y  por el Administrador de Nomina.">
<cfelseif url.cod EQ 18>
	<cfset mensaje = "La incidencia estaba aprobada por el Jefe y el Administrador de Nomina pero fue RECHAZADA por el Administrador de Incidencias.">
<cfelse>
	<!---7,8,9 usadas para presupuesto--->
	<cfset mensaje = "No aplica.">
</cfif>

<cfquery name="rsIncidencia" datasource="#session.DSN#">
	select 
		Ijustificacion,
		Iobservacion,
		<cfif url.cod EQ 1> 
			-1 as UsuResponsable
		<cfelseif url.cod EQ 2>
			usuCF as UsuResponsable
		<cfelseif url.cod EQ 3>
			usuCF as UsuResponsable
		<cfelseif url.cod EQ 4>
			-1 as UsuResponsable
		<cfelseif url.cod EQ 5>
			Iusuaprobacion as UsuResponsable
		<cfelseif url.cod EQ 6>
			Iusuaprobacion as UsuResponsable
		<cfelse>
			BMUsucodigo as UsuResponsable
		</cfif>
		
	from Incidencias
	where Iid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Iid#">
	 Union 
	 
	 select 
		
		Ijustificacion,
		Iobservacion,
		<cfif url.cod EQ 1> 
			-1 as UsuResponsable
		<cfelseif url.cod EQ 2>
			usuCF as UsuResponsable
		<cfelseif url.cod EQ 3>
			usuCF as UsuResponsable
		<cfelseif url.cod EQ 4>
			-1 as UsuResponsable
		<cfelseif url.cod EQ 5>
			Iusuaprobacion as UsuResponsable
		<cfelseif url.cod EQ 6>
			Iusuaprobacion as UsuResponsable
		<cfelseif url.cod GT 10>
			coalesce(HBMUsucodigo,-1) as UsuResponsable
		<cfelse>
			BMUsucodigo as UsuResponsable
		</cfif>
		
	from HIncidencias
	where Iid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Iid#">
	
</cfquery>

<cfif rsIncidencia.RecordCount GT 0>
	<cfquery datasource="#Session.DSN#" name="rsU">
		select {fn concat(dp.Pid,{fn concat(' ',{fn concat(dp.Pnombre,{fn concat(' ',{fn concat(dp.Papellido1,{fn concat(' ',dp.Papellido2)})})})})})} as Nombre
		from DatosPersonales dp
		inner join Usuario u 
			on dp.datos_personales = u.datos_personales
		where u.Usucodigo = #rsIncidencia.UsuResponsable#
	</cfquery>
</cfif>

<strong>Mensaje:</strong><br>
#mensaje#  <br> 
<br>

<cfif listFindNoCase('3,6,10,11,12,14,18',url.cod,',')>
	<cfset etiqueta= 'Justificacion'>
	<cfset dato= rsIncidencia.Ijustificacion>
<cfelse>
	<cfset etiqueta= 'Observacion'>
	<cfset dato= rsIncidencia.Iobservacion>
</cfif>

<cfif len(trim(dato))>
<strong>#etiqueta#</strong><br>
#dato#<br><br>
</cfif>

<cfif rsU.RecordCount GT 0>
	<strong>Responsable</strong><br>
	#rsU.Nombre#<br><br>
</cfif>


<center><input name="BTNcerrar" value="Cerrar" type="button" onClick="javascript: ColdFusion.Window.hide('Window#cod#_#url.Iid#')"></center>
</cfoutput>