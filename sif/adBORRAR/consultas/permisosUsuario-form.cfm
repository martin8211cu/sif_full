<cfif isdefined("url.opcion") and not isdefined("form.opcion") >
	<cfset form.opcion = url.opcion >
</cfif>
<cfif isdefined("url.SScodigo") and not isdefined("form.SScodigo") >
	<cfset form.SScodigo = url.SScodigo >
</cfif>
<cfif isdefined("url.empresa") and not isdefined("form.empresa") >
	<cfset form.empresa = url.empresa >
</cfif>

<cfif form.opcion eq 'rol'>
	<cfif isdefined("url.SRcodigo") and not isdefined("form.SRcodigo") >
		<cfset form.SRcodigo = url.SRcodigo >
	</cfif>
<cfelse>
	<cfset form.opcion = 'sistema' >
	<cfif isdefined("url.SMcodigo") and not isdefined("form.SMcodigo") >
		<cfset form.SMcodigo = url.SMcodigo >
	</cfif>
	<cfif isdefined("url.SPcodigo") and not isdefined("form.SPcodigo") >
		<cfset form.SPcodigo = url.SPcodigo >
	</cfif>
</cfif>
<cfsavecontent variable="myquery">
	<cfoutput>
	<cfif isdefined("form.opcion") and form.opcion eq 'rol'>
		<!--- USUARIOS POR ROL --->
		select ur.SScodigo, ur.SRcodigo, r.SRdescripcion, ur.Ecodigo, e.Enombre, ur.Usucodigo, dp.Pnombre, dp.Papellido1, dp.Papellido2, dp.Pid 
			from UsuarioRol ur
				inner join Empresa e
		 			on e.CEcodigo = #session.CEcodigo#
				   and e.Ecodigo  = ur.Ecodigo
				inner join Usuario u
					on u.Usucodigo=ur.Usucodigo
				inner join DatosPersonales dp
					on dp.datos_personales = u.datos_personales
				inner join SRoles r
					on r.SScodigo=ur.SScodigo
				   and r.SRcodigo=ur.SRcodigo
		  where ur.SScodigo = '#form.SScodigo#'

		<cfif isdefined("form.empresa") and len(trim(form.empresa))>
			and ur.Ecodigo = #form.empresa#
		</cfif>

		<cfif isdefined("form.SRcodigo") and len(trim(form.SRcodigo))>
			and ur.SRcodigo = '#form.SRcodigo#'
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
		order by ur.SScodigo, ur.SRcodigo, e.Enombre, dp.Pid		
	<cfelse>
		<cfif isdefined("form.SMcodigo") and len(trim(form.SMcodigo)) and isdefined("form.SPcodigo") and len(trim(form.SPcodigo)) >
			<!--- USUARIOS POR PROCESO --->
			select vup.Usucodigo, 
				vup.SScodigo, 
				s.SSdescripcion, 
				vup.SMcodigo, 
				m.SMdescripcion, 
				vup.SPcodigo,
				p.SPdescripcion,
				vup.Usucodigo, 
				dp.Pnombre, 
				dp.Papellido1, 
				dp.Papellido2, 
				dp.Pid,
				e.Enombre
			 
			from vUsuarioProcesos vup
				inner join Empresa e
			 		on e.CEcodigo = #session.CEcodigo#
				   and e.Ecodigo=vup.Ecodigo
			inner join SSistemas s
					on s.SScodigo= vup.SScodigo
			inner join SModulos m
					on m.SScodigo= vup.SScodigo
				   and m.SMcodigo= vup.SMcodigo
			inner join SProcesos p
					on p.SScodigo= vup.SScodigo
				   and p.SMcodigo= vup.SMcodigo
			       and p.SPcodigo= vup.SPcodigo
			inner join Usuario u
					on u.Usucodigo = vup.Usucodigo
			inner join DatosPersonales dp
					on dp.datos_personales = u.datos_personales
			where vup.SScodigo='#form.SScodigo#'
			  and vup.SMcodigo='#form.Smcodigo#'
			  and vup.SPcodigo='#form.SPcodigo#'
			
			<cfif isdefined("form.empresa") and len(trim(form.empresa))>
				and vup.Ecodigo = #form.empresa#
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
			
			order by 13, 12
		<cfelseif isdefined("form.SMcodigo") and len(trim(form.SMcodigo)) >
			select up.SScodigo,
				  s.SSdescripcion,	
				  up.SMcodigo,
				  m.SMdescripcion,
				  up.Ecodigo, 
				  up.Usucodigo,
				  dp.Pid,
				  dp.Pnombre,
				  dp.Papellido1,
				  dp.Papellido2, 
				  u.Usulogin, 
				  e.Enombre
			from UsuarioProceso up
				inner join Empresa e
					on e.CEcodigo = #session.CEcodigo#
				   and e.Ecodigo=up.Ecodigo
				inner join Usuario u 
                	on u.Usucodigo = up.Usucodigo 
				inner join DatosPersonales dp 
                	on dp.datos_personales = u.datos_personales
				inner join SSistemas s 
                	on s.SScodigo=up.SScodigo 
				inner join SModulos m 
                	on m.SScodigo=up.SScodigo 
                   and m.SMcodigo=up.SMcodigo 
			where up.SScodigo='#form.SScodigo#'
			  and up.SMcodigo='#form.SMcodigo#'
			<cfif isdefined("form.empresa") and len(trim(form.empresa))>
				and up.Ecodigo = #form.empresa#
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
            			
			union
			
			select ur.SScodigo,
				s.SSdescripcion,	
				pr.SMcodigo,
				  m.SMdescripcion,
				ur.Ecodigo,	
				ur.Usucodigo,
				dp.Pid,
				  dp.Pnombre,
				  dp.Papellido1,
				  dp.Papellido2, 
				  u.Usulogin, 
				  e.Enombre
			from UsuarioRol ur
				inner join Empresa e
			 		on e.CEcodigo = #session.CEcodigo#
				   and e.Ecodigo  = ur.Ecodigo
			inner join SSistemas s
				on s.SScodigo = ur.SScodigo
			   and s.SScodigo = '#form.SScodigo#'
			inner join SProcesosRol pr
				on pr.SScodigo = ur.SScodigo
			   and pr.SRcodigo = ur.SRcodigo
			   and pr.SMcodigo = '#form.SMcodigo#'
			inner join SModulos m
				on m.SScodigo = pr.SScodigo
			   and m.SMcodigo = pr.SMcodigo
			inner join Usuario u
				on u.Usucodigo = ur.Usucodigo
			inner join DatosPersonales dp
				on dp.datos_personales = u.datos_personales

			where 1=1
			<cfif isdefined("form.empresa") and len(trim(form.empresa))>
				and ur.Ecodigo = #form.empresa#
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
		
			order by 1, 3, 12, 7
		<cfelse>
			select up.SScodigo, up.Ecodigo, up.Usucodigo, u.Usulogin, dp.Pid, dp.Pnombre, dp.Papellido1, dp.Papellido2, 
            	e.Enombre
			from UsuarioProceso up
				inner join Empresa e
					on e.CEcodigo = #session.CEcodigo#
				   and e.Ecodigo=up.Ecodigo
                inner join Usuario u 
                	on u.Usucodigo = up.Usucodigo
                inner join DatosPersonales dp 
                	on dp.datos_personales = u.datos_personales
			where  up.SScodigo='#form.SScodigo#'
			<cfif isdefined("form.empresa") and len(trim(form.empresa))>
				and up.Ecodigo = #form.empresa#
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

			union
			
			select ur.SScodigo, ur.Ecodigo, ur.Usucodigo, u.Usulogin, dp.Pid, dp.Pnombre, dp.Papellido1, dp.Papellido2, 
				  e.Enombre
			from UsuarioRol ur
				inner join Empresa e
					on e.CEcodigo = #session.CEcodigo#
				   and e.Ecodigo  = ur.Ecodigo
                inner join Usuario u
                	on u.Usucodigo = ur.Usucodigo
                inner join DatosPersonales dp
                	on dp.datos_personales = u.datos_personales
			
			where ur.SScodigo='#form.SScodigo#'
			<cfif isdefined("form.empresa") and len(trim(form.empresa))>
				and ur.Ecodigo = #form.empresa#
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
			order by  1, 9, 5
		</cfif>
	</cfif>
	</cfoutput>
</cfsavecontent>

<cfif isdefined("form.empresa") and len(trim(form.empresa))>
	<cfquery name="rsEmpresa" datasource="asp">
		select Ecodigo, Enombre as Enombre
		from Empresa
		where Ecodigo = #form.empresa#
		order by Enombre
	</cfquery>
</cfif>
<cfquery name="rsSistema" datasource="asp">
	select SScodigo, SSdescripcion
	from SSistemas
	where SScodigo='#form.SScodigo#'
</cfquery>

<br>
<cfset registros = 0 >

<cfif isdefined("form.SScodigo") and len(trim(form.SScodigo))>
	<cfquery name="rsSistema" datasource="asp">
		select SSdescripcion
		from SSistemas
		where SScodigo = '#form.SScodigo#'
	</cfquery>
</cfif>

<cfif isdefined("form.opcion") and form.opcion eq 'rol'>
	<cfoutput>
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr><td align="center" style="font-size:36px;"><strong><font >#session.Enombre#</font></strong></td></tr>
		<tr><td align="center"><strong><font >Consulta de Usuarios por Grupo de Permiso</font></strong></td></tr>	
		<cfif isdefined("form.empresa") and len(trim(form.empresa))>
			<tr><td align="center"><strong><font >Empresa:&nbsp;</font></strong>#rsEmpresa.Enombre#</td></tr>	
		</cfif>
		<cfif isdefined("form.SScodigo") and len(trim(form.SScodigo))>
			<tr><td align="center"><strong><font >Sistema:&nbsp;</font></strong>#trim(form.SScodigo)# - #rsSistema.SSdescripcion#</td></tr>	
		</cfif>
		<cfif isdefined("form.SRcodigo") and len(trim(form.SRcodigo))>
			<cfquery name="rsRol" datasource="asp">
				select SRdescripcion
				from SRoles
				where SScodigo = '#form.SScodigo#'
 				  and SRcodigo = '#form.SRcodigo#'
			</cfquery>
			<tr><td align="center"><strong><font >Grupo de Permiso:&nbsp;</font></strong>#trim(form.SRcodigo)# - #rsRol.SRdescripcion#</td></tr>	
		</cfif>
		<tr><td>&nbsp;</td></tr>
	</table>
	</cfoutput>
	<cfinclude template="permisosUsuario-roles.cfm">
<cfelse>
	<cfif isdefined("form.SMcodigo") and len(trim(form.SMcodigo)) and isdefined("form.SPcodigo") and len(trim(form.SPcodigo)) >
		<cfoutput>
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr><td align="center" style="font-size:36px;"><strong><font >#session.Enombre#</font></strong></td></tr>
			<tr><td align="center"><strong><font >Consulta de Usuarios por Procesos</font></strong></td></tr>	
			<cfif isdefined("form.empresa") and len(trim(form.empresa))>
				<tr><td align="center"><strong><font >Empresa:&nbsp;</font></strong>#rsEmpresa.Enombre#</td></tr>	
			</cfif>
			<cfif isdefined("form.SScodigo") and len(trim(form.SScodigo))>
				<tr><td align="center"><strong><font >Sistema:&nbsp;</font></strong>#trim(form.SScodigo)# - #rsSistema.SSdescripcion#</td></tr>	
			</cfif>
			<cfquery name="rsModulo" datasource="asp">
				select SMdescripcion
				from SModulos
				where SScodigo = '#form.SScodigo#'
				  and SMcodigo = '#form.SMcodigo#'
			</cfquery>
			<tr><td align="center"><strong><font >Módulo:&nbsp;</font></strong>#trim(form.SMcodigo)# - #rsModulo.SMdescripcion#</td></tr>	

			<cfquery name="rsProceso" datasource="asp">
				select SPdescripcion
				from SProcesos
				where SScodigo = '#form.SScodigo#'
				  and SMcodigo = '#form.SMcodigo#'
				  and SPcodigo = '#form.SPcodigo#'
			</cfquery>
			<tr><td align="center"><strong><font >Módulo:&nbsp;</font></strong>#trim(form.SPcodigo)# - #rsProceso.SPdescripcion#</td></tr>	
			<cfinclude template="permisosUsuario-procesos.cfm">
			<tr><td>&nbsp;</td></tr>
		</table>
		</cfoutput>

	<cfelseif isdefined("form.SMcodigo") and len(trim(form.SMcodigo)) >
		<cfoutput>
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr><td align="center" style="font-size:36px;"><strong><font >#session.Enombre#</font></strong></td></tr>
			<tr><td align="center"><strong><font >Consulta de Usuarios por Módulos</font></strong></td></tr>	
			<cfif isdefined("form.empresa") and len(trim(form.empresa))>
				<tr><td align="center"><strong><font >Empresa:&nbsp;</font></strong>#rsEmpresa.Enombre#</td></tr>	
			</cfif>
			<cfif isdefined("form.SScodigo") and len(trim(form.SScodigo))>
				<tr><td align="center"><strong><font >Sistema:&nbsp;</font></strong>#trim(form.SScodigo)# - #rsSistema.SSdescripcion#</td></tr>	
			</cfif>
			<cfif isdefined("form.SMcodigo") and len(trim(form.SMcodigo))>
				<cfquery name="rsModulo" datasource="asp">
					select SMdescripcion
					from SModulos
					where SScodigo = '#form.SScodigo#'
					  and SMcodigo = '#form.SMcodigo#'
				</cfquery>
				<tr><td align="center"><strong><font >Módulo:&nbsp;</font></strong>#trim(form.SMcodigo)# - #rsModulo.SMdescripcion#</td></tr>	
			</cfif>
			<tr><td>&nbsp;</td></tr>
		</table>
		</cfoutput>
		<cfinclude template="permisosUsuario-modulos.cfm">
	<cfelse>
		<cfoutput>
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr><td align="center" style="font-size:36px;"><strong><font >#session.Enombre#</font></strong></td></tr>
			<tr><td align="center"><strong><font >Consulta de Usuarios por Sistema</font></strong></td></tr>	
			<cfif isdefined("form.empresa") and len(trim(form.empresa))>
				<tr><td align="center"><strong><font >Empresa:&nbsp;</font></strong>#rsEmpresa.Enombre#</td></tr>	
			</cfif>
			
			<cfif isdefined("form.SScodigo") and len(trim(form.SScodigo))>
				<tr><td align="center"><strong><font >Sistema:&nbsp;</font></strong>#trim(form.SScodigo)# - #rsSistema.SSdescripcion#</td></tr>	
			</cfif>
			
			<tr><td>&nbsp;</td></tr>
		</table>
		</cfoutput>
		<cfinclude template="permisosUsuario-sistemas.cfm">
	</cfif>
</cfif>