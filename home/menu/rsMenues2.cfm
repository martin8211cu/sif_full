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

<cfquery name="rsMenues_" datasource="asp">
	select 	rtrim(s.SScodigo) as SScodigo,   s.SSdescripcion, s.SSorden, s.SShomeuri,
			rtrim(m.SMcodigo) as SMcodigo,   m.SMdescripcion, m.SMorden, m.SMhomeuri,
			rtrim(mn.SPcodigo) as SPcodigo, 
			mn.SMNcodigo, 
			case when mn.SMNtipo = 'P' then p.SPdescripcion else mn.SMNtitulo end as SMNtitulo,
			mn.SMNtipo, mn.SMNtipoMenu, 
			mn.SMNnivel,
			mn.SMNcodigoPadre,
			p.SPhomeuri,
			mn.SMNenConstruccion,
			mn.SMNpath, -1 SPorden
	  from SMenues mn
	  left outer join SProcesos p
	    on mn.SScodigo = p.SScodigo
	   and mn.SMcodigo = p.SMcodigo
	   and mn.SPcodigo = p.SPcodigo
	  , SSistemas s, SModulos m
 	 where mn.SScodigo = s.SScodigo
	   and mn.SScodigo = m.SScodigo
	   and mn.SMcodigo = m.SMcodigo
	   and s.SSmenu = 1 
	   and m.SMmenu = 1 
	   and p.SPmenu = 1 
	   and mn.SMNnivel <> 0
	   and exists (
			select *
			  from SMenues mnp, vUsuarioProcesos up
			 where up.Usucodigo = #Session.Usucodigo#
			   and up.Ecodigo = #Session.Ecodigosdc#
			   and up.SScodigo = mnp.SScodigo
			   and up.SMcodigo = mnp.SMcodigo
			   and up.SPcodigo = mnp.SPcodigo
			   and mn.SScodigo = mnp.SScodigo
			   and mn.SMcodigo = mnp.SMcodigo
			   <!---and mnp.SMNpath like mn.SMNpath || '%'--->
			   and mnp.SMNpath >= mn.SMNpath
			   and mnp.SMNpath < {fn concat(mn.SMNpath, '~')}			   
			   
		)
UNION
	select 	rtrim(s.SScodigo) as SScodigo,   s.SSdescripcion, s.SSorden, s.SShomeuri,
			rtrim(m.SMcodigo) as SMcodigo,   m.SMdescripcion, m.SMorden, m.SMhomeuri,
			rtrim(p.SPcodigo),
			-1 as SMNcodigo,  p.SPdescripcion,
			'S', 0,
			1,
			-1,
			p.SPhomeuri, 
			0,
			'999' as SMNpath, p.SPorden
	from vUsuarioProcesos up, SSistemas s, SModulos m, SProcesos p
	where up.Usucodigo = #Session.Usucodigo#
	  and up.Ecodigo = #Session.Ecodigosdc#
	  and s.SSmenu = 1 
	  and m.SMmenu = 1 
      and p.SPmenu = 1 
	  and up.SScodigo = s.SScodigo
	  and up.SScodigo = m.SScodigo
	  and up.SMcodigo = m.SMcodigo
	  and up.SScodigo = p.SScodigo
	  and up.SMcodigo = p.SMcodigo
	  and up.SPcodigo = p.SPcodigo
	  and not exists (
			select *
			  from SMenues mnp
			 where up.SScodigo = mnp.SScodigo
			   and up.SMcodigo = mnp.SMcodigo
			   and up.SPcodigo = mnp.SPcodigo
		)
	order by SSorden, SScodigo, SMorden, SMcodigo, SMNpath, SPorden
</cfquery>
