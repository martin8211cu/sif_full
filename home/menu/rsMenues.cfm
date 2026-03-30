<cfif isdefined("rsMenues_")>
	<cfexit>
</cfif>
<cfset LvarMenuCFM = (isdefined("menu.cfc"))>
<cfquery name="rsPermisos" datasource="asp">
	select count(1) as CantidadPermisos
	  from vUsuarioProcesos
	where Usucodigo = #Session.Usucodigo#
</cfquery>
<cfparam name="session.menues.CantidadPermisos" default="">
<cfif session.menues.CantidadPermisos EQ rsPermisos.CantidadPermisos>
	<cfset LvarHora = 1>
<cfelse>
	<cfset session.menues.CantidadPermisos = rsPermisos.CantidadPermisos>
	<cfset LvarHora = 0>
</cfif>

<cfquery name="rsMenues_" datasource="asp" cachedwithin="#CreateTimeSpan(0,LvarHora,0,0)#">
	select  rtrim(s.SScodigo) as SScodigo,   
			s.SSorden as SSorden, 
			rtrim(m.SMcodigo) as SMcodigo,   
			m.SMorden as SMorden, 
			rtrim(mn.SPcodigo) as SPcodigo, 
			mn.SMNcodigo as SMNcodigo, 
			mn.SMNtipo as SMNtipo, 
			mn.SMNtipoMenu as SMNtipoMenu, 
			mn.SMNnivel as SMNnivel,
			mn.SMNcodigoPadre as SMNcodigoPadre,
			mn.SMNenConstruccion as SMNenConstruccion,
			mn.SMNpath as SMNpath, 
			-1 as SPorden
			<cfif LvarMenuCFM>
				, s.SSdescripcion as SSdescripcion
				, s.SShomeuri as SShomeuri
				, m.SMdescripcion as SMdescripcion
				, m.SMhomeuri as SMhomeuri
				, case when mn.SMNtipo = 'P' then p.SPdescripcion else mn.SMNtitulo end as SMNtitulo
				, p.SPhomeuri as SPhomeuri
			</cfif>			
	  from SMenues mn
	  	inner join SSistemas s
			on  s.SScodigo = mn.SScodigo

		inner join SModulos m
			on m.SScodigo = mn.SScodigo
			and m.SMcodigo = mn.SMcodigo

		  left outer join SProcesos p
			on mn.SScodigo = p.SScodigo
		   and mn.SMcodigo = p.SMcodigo
		   and mn.SPcodigo = p.SPcodigo

 	 where mn.SMNnivel <> 0
        and s.SSmenu = 1 
        and m.SMmenu = 1			
        and p.SPmenu = 1 
        and (
			select count(1)
			from vUsuarioProcesos up,SMenues mnp
			where up.Usucodigo = #Session.Usucodigo#
			  and up.Ecodigo = #Session.Ecodigosdc#
			  and up.SScodigo = mn.SScodigo
			  and up.SMcodigo = mn.SMcodigo
			  and up.SPcodigo = mn.SPcodigo
			  and mnp.SScodigo = up.SScodigo
			  and mnp.SMcodigo = up.SMcodigo
			  and mnp.SMNpath >= mn.SMNpath
			  and mnp.SMNpath < {fn concat(mn.SMNpath, '~')}
		) > 0
UNION
	select 	rtrim(s.SScodigo) as SScodigo,   
			s.SSorden as SSorden, 
			rtrim(m.SMcodigo) as SMcodigo,   
			m.SMorden as SMorden, 
			rtrim(p.SPcodigo) as SPcodigo,
			-1 as SMNcodigo,  
			'S' as SMNtipo, 
			0 as SMNtipoMenu,
			1 as SMNnivel,
			-1 as SMNcodigoPadre,
			0 as SMNenConstruccion,
			'999' as SMNpath, 
			p.SPorden as SPorden
			<cfif LvarMenuCFM>
				, s.SSdescripcion as SSdescripcion
				, s.SShomeuri as SShomeuri
				, m.SMdescripcion as SMdescripcion
				, m.SMhomeuri as SMhomeuri
				, p.SPdescripcion as SMNtitulo
				, p.SPhomeuri as SPhomeuri
			</cfif>			
	from vUsuarioProcesos up
		inner join SSistemas s
			on s.SScodigo = up.SScodigo
		inner join SModulos m
			on m.SScodigo = up.SScodigo
			and m.SMcodigo = up.SMcodigo
		inner join SProcesos p
			on p.SScodigo = up.SScodigo
			and p.SMcodigo = up.SMcodigo
			and p.SPcodigo = up.SPcodigo
	where up.Usucodigo = #Session.Usucodigo#
	  and up.Ecodigo = #Session.Ecodigosdc#
	  and s.SSmenu = 1 
	  and m.SMmenu = 1 
	  and p.SPmenu = 1 
	  and (
			select count(1)
			  from SMenues mnp
			 where up.SScodigo = mnp.SScodigo
			   and up.SMcodigo = mnp.SMcodigo
			   and up.SPcodigo = mnp.SPcodigo
		) = 0
	<cfif LvarMenuCFM>
		order by SSorden, SScodigo, SMorden, SMcodigo, SMNpath, SPorden
	</cfif>
</cfquery>
