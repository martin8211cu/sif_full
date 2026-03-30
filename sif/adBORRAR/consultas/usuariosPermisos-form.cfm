<cfif isdefined("url.empresa") and not isdefined("form.empresa") >
	<cfset form.empresa = url.empresa >
</cfif>
<cfif isdefined("url.Usulogin") and not isdefined("form.Usulogin") >
	<cfset form.Usulogin = url.Usulogin >
</cfif>
<cfif isdefined("url.Usulogin2") and not isdefined("form.Usulogin2") >
	<cfset form.Usulogin2 = url.Usulogin2 >
</cfif>
<cfif isdefined("url.SScodigo") and not isdefined("form.SScodigo") >
	<cfset form.SScodigo = url.SScodigo >
</cfif>

<cfset params = '' >
<cfif isdefined("form.empresa")>
	<cfset params = params & '&empresa=#form.empresa#' >	
</cfif>
<cfif isdefined("form.usulogin")>
	<cfset params = params & '&usulogin=#form.usulogin#' >	
</cfif>
<cfif isdefined("form.usulogin2")>
	<cfset params = params & '&usulogin2=#form.usulogin2#' >	
</cfif>
<cfif isdefined("form.SScodigo")>
	<cfset params = params & '&SScodigo=#form.SScodigo#' >	
</cfif>

<cfsetting requesttimeout="8600">

<cfif form.Usulogin gt form.usulogin2>
	<cfset tmp = form.usulogin > 
	<cfset form.usulogin = form.usulogin2 >
	<cfset form.usulogin2 = tmp >
</cfif>

<cfsavecontent variable="myquery">
	<cfoutput>
	select 	ur.Usucodigo, 
			dp.Pid,
			<cf_dbfunction name="concat" args="dp.Pnombre,dp.Papellido1,' ',dp.Papellido2 "> as nombre,
			u.Usulogin ,
			ur.Ecodigo, 
			e.Enombre,
			ur.SScodigo,
			s.SSdescripcion,	 
			ur.SRcodigo,
			r.SRdescripcion
			
	from UsuarioRol ur
	
	inner join Usuario u
		on u.Usucodigo=ur.Usucodigo
	
	inner join DatosPersonales dp
		on dp.datos_personales=u.datos_personales
	<cfif isdefined("form.Usulogin") and len(trim(form.Usulogin)) and isdefined("form.Usulogin2") and len(trim(form.Usulogin2))>
		and dp.Pid between '#form.Usulogin#' and '#form.Usulogin2#'
	<cfelseif isdefined("form.Usulogin") and len(trim(form.Usulogin))>
		and dp.Pid = '#form.Usulogin#'
	<cfelseif isdefined("form.Usulogin2") and len(trim(form.Usulogin2))>
		and dp.Pid = '#form.Usulogin2#'
	</cfif>	
	
	inner join Empresa e
		on e.Ecodigo=ur.Ecodigo
	inner join SRoles r
		on r.SScodigo=ur.SScodigo
	   and r.SRcodigo=ur.SRcodigo
	inner join SSistemas s
		on s.SScodigo = ur.SScodigo
	where 1=1
	
	<cfif isdefined("form.empresa")	and len(trim(form.empresa))>
		and ur.Ecodigo = #form.empresa#
	</cfif>
	<cfif isdefined("form.SScodigo") and len(trim(form.SScodigo))>
		and ur.SScodigo = '#form.SScodigo#'
	</cfif>
    <cfif isdefined("form.Uestado") and len(trim(form.Uestado))>
    	<cfif form.Uestado EQ 'A'>
        	 and u.Uestado = 1 and u.Utemporal = 0
        <cfelseif form.Uestado EQ 'I'>
        	and u.Uestado = 0
        <cfelseif form.Uestado EQ 'T'>
        	and u.Uestado = 1 and u.Utemporal = 1
        <cfelse>
        	<cfthrow message="Estado del usuario no implementado">
        </cfif>
    </cfif>
	
	order by <cf_dbfunction name="concat" args="dp.Pnombre,dp.Papellido1,dp.Papellido2">, Enombre, ur.SScodigo, ur.SRcodigo
	
	</cfoutput>
</cfsavecontent>

<cfquery name="data" datasource="asp">
	#preservesinglequotes(myquery)#
</cfquery>

<cfif isdefined("form.empresa") and len(trim(form.empresa))>
	<cfquery name="rsEmpresa" datasource="asp">
		select Ecodigo, Enombre
		from Empresa
		where CEcodigo=#session.CEcodigo#
		  and Ecodigo = #form.empresa#
		order by Enombre
	</cfquery>
</cfif>

<cfif isdefined("form.SScodigo") and len(trim(form.SScodigo))>
	<cfquery name="rsSistema" datasource="asp">
		select SScodigo, SSdescripcion
		from SSistemas
		where SScodigo='#form.SScodigo#'
	</cfquery>
</cfif>

<cfif isdefined("url.SRcodigo") and len(trim(url.SRcodigo)) and isdefined("url.vSScodigo") and len(trim(url.vSScodigo)) >
	<cfquery name="rsProcesos" datasource="asp">
		select a.SMcodigo, m.SMdescripcion, a.SPcodigo, b.SPdescripcion 
		from SProcesosRol a
		
		inner join SProcesos b
		on b.SScodigo=a.SScodigo
		and b.SPcodigo=a.SPcodigo
		and b.SMcodigo=a.SMcodigo
		
		inner join SModulos m
		on m.SScodigo = a.SScodigo
		and m.SMcodigo = a.SMcodigo
		
		where a.SScodigo = '#url.vSScodigo#'
		  and a.SRcodigo = '#url.SRcodigo#'
		order by a.SMcodigo, a.SPcodigo
	</cfquery>
</cfif>
	
<br>
<cfset registros = 0 >

<cfoutput>
<table width="100%" cellpadding="2" cellspacing="0">
	<tr><td align="center" style="font-size:36px;"><strong><font >#session.Enombre#</font></strong></td></tr>
	<tr><td align="center"><strong><font >Consulta de Permisos por Usuario</font></strong></td></tr>	
	<cfif isdefined("form.empresa") and len(trim(form.empresa))>
		<tr><td align="center"><strong><font >Empresa:&nbsp;</font></strong>#rsEmpresa.Enombre#</td></tr>	
	</cfif>
	<tr><td>&nbsp;</td></tr>
</table>
</cfoutput>

<cfset colspan = 1 >
<table width="95%" align="center" cellpadding="3" cellspacing="0" border="0">
		<cfoutput query="data" group="nombre">
			<cfset registros = registros + 1 >
			<cfif registros neq 1 >
				<td><td>&nbsp;</td></td>
			</cfif>

			<tr><td bgcolor="##CCCCCC" colspan="5" style="padding:4px;" ><strong>Identificaci&oacute;n: #Pid# </strong></td></tr>
			<tr><td bgcolor="##CCCCCC" colspan="5" style="padding:4px;" ><strong>Nombre: #trim(nombre)# (#usulogin#)</strong></td></tr>			

			<cfoutput group="Enombre">
				<cfif not isdefined("rsEmpresa")>
					<cfset colspan = 2 >
					<tr>
						<td width="40">&nbsp;</td>
						<td bgcolor="##d9d9d9" colspan="4"  ><strong>Empresa:<strong> #trim(Enombre)#</td>
					</tr>
				</cfif>

				<cfoutput group="SScodigo">
					<tr>
						<cfloop from="1" to="#colspan#" index="i" >
							<td width="40">&nbsp;</td>
						</cfloop>
						
						<cfif not isdefined("rsSistema")>
							<td bgcolor="##e5e5e5" colspan="3"  ><strong>Sistema:</strong> #trim(SScodigo)# - #SSdescripcion#</td>
						</cfif>
					</tr>
	
					<tr>
						<cfloop from="1" to="#colspan+1#" index="i" >
							<td width="40">&nbsp;</td>
						</cfloop>
						<td class="tituloListas">C&oacute;digo de Rol</td>
						<td class="tituloListas">Descripci&oacute;n</td>
					</tr>

					<cfoutput>
						<tr <cfif not isdefined("url.imprimir")>style="cursor:pointer;" title="Consultar porcesos asociados el rol #trim(SRcodigo)# - #SRdescripcion#" onclick="javascript:location.href='usuariosPermisos.cfm?dummy=1#params#&usucodigo=#usucodigo#&SRcodigo=#trim(SRcodigo)#&vSScodigo=#trim(SScodigo)#&vEmpresa=#trim(Ecodigo)#'" </cfif>>
							<cfloop from="1" to="#colspan+1#" index="i" >
								<td width="40">&nbsp;</td>
							</cfloop>
							<td nowrap="nowrap" style="padding-left:10px;"><cfif not isdefined("url.imprimir")><a title="Consultar porcesos asociados el rol #trim(SRcodigo)# - #SRdescripcion#" href="usuariosPermisos.cfm?dummy=1#params#&usucodigo=#usucodigo#&SRcodigo=#trim(SRcodigo)#&vSScodigo=#trim(SScodigo)#&vEmpresa=#trim(Ecodigo)#"></cfif>#SRcodigo#<cfif not isdefined("url.imprimir")></a></cfif></td>
							<td >
								<table width="100%" cellpadding="0" cellspacing="0">
									<tr>
										<td width="50%"><cfif not isdefined("url.imprimir")><a title="Consultar porcesos asociados el rol #trim(SRcodigo)# - #SRdescripcion#" href="usuariosPermisos.cfm?dummy=1#params#&usucodigo=#usucodigo#&SRcodigo=#trim(SRcodigo)#&vSScodigo=#trim(SScodigo)#&vEmpresa=#trim(Ecodigo)#"></cfif>#SRdescripcion#<cfif not isdefined("url.imprimir")></a></cfif></td>
										<cfif not isdefined("url.imprimir")><td width="50%" align="center"><img src="../../imagenes/findsmall.gif" /></td></cfif>
									</tr>
								</table>
								
							</td>
						</tr>
						
						<cfif isdefined("url.usucodigo") and len(trim(url.usucodigo)) and url.Usucodigo eq usucodigo >
							<cfif isdefined("url.SRcodigo") and len(trim(url.SRcodigo)) and trim(url.SRcodigo) eq trim(SRcodigo) and isdefined("url.vSScodigo") and len(trim(url.vSScodigo)) and trim(url.vSScodigo) eq trim(SScodigo) and len(trim(url.vSScodigo)) and isdefined("url.vEmpresa") and len(trim(url.vEmpresa)) and trim(url.vEmpresa) eq trim(Ecodigo)>
								<tr>
									<cfloop from="1" to="#colspan+1#" index="i" >
										<td width="40">&nbsp;</td>
									</cfloop>
									<td colspan="3">
										<table border="0" width="95%" align="right" style="border: 1px solid gray;" bgcolor="##f5f5f5">
											<td colspan="3" bgcolor="##e5e5e5"><i><strong>Procesos asociados al rol  #SRcodigo# - #SRdescripcion#</i></strong></td>
											<tr>
												<td style="padding-left:30px;"><strong>M&oacute;dulo</strong></td>
												<td style="padding-left:30px;"><strong>Proceso</strong></td>
											</tr>

											<cfloop query="rsProcesos">
												<tr>
													<td style="padding-left:30px;">#SMcodigo# - #SMdescripcion#</td>
													<td style="padding-left:30px;">#SPcodigo# - #SPdescripcion#</td>
												</tr>
											</cfloop>
										</table>
									</td>
								</tr>
							</cfif>
						</cfif>
						
					</cfoutput>
				</cfoutput>
			</cfoutput>	
		</cfoutput>
		
		<!--- PINTA EL TOTAL DEL ULTIMO CENTRO FUNCIONAL --->
		<cfoutput>
		<cfif registros eq 0>
			<tr><td>&nbsp;</td></tr>
			<tr><td align="center" colspan="5">--- No se encontraron registros ---</td></tr>
			<tr><td>&nbsp;</td></tr>			
		<cfelse>
			<tr><td>&nbsp;</td></tr>
			<tr><td align="center" colspan="5">--- Fin de la consulta ---</td></tr>
			<tr><td>&nbsp;</td></tr>			
		</cfif>
		</cfoutput>		
</table>