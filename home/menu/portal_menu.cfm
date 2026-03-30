<cfset niveles = 5>
<cfquery datasource="asp" name="elmenu" cachedwithin="#CreateTimeSpan(0,0,10,0)#">
	select
		<cfloop from="1" to="#niveles#" index="nivel">
			<cfif nivel gt 1>,</cfif>
			m#nivel#.id_item as nivel#nivel#, m#nivel#.etiqueta_item as etiqueta#nivel#, r#nivel#.ruta as ruta#nivel#
		</cfloop>
	<cfloop from="1" to="#niveles#" index="nivel">
		<cfif nivel is 1>from <cfelse>left join</cfif> SRelacionado r#nivel#
			<cfif nivel gt 1>
				on r#nivel#.id_item = r#nivel-1#.id_relacionado
				and r#nivel#.profundidad = 1
			</cfif>
			left join SMenuItem m#nivel#
				on m#nivel#.id_item = r#nivel#.id_relacionado
	</cfloop>
	where r1.id_item = #session.menues.id_root#
	  and r1.profundidad = 1
	  
	<cfloop from="1" to="#niveles#" index="nivel">
				and (m#nivel#.SScodigo is null or m#nivel#.SMcodigo is null or m#nivel#.SPcodigo is null 
				    or exists (select * from vUsuarioProcesos x#nivel#
					where x#nivel#.SScodigo = m#nivel#.SScodigo
					  and x#nivel#.SMcodigo = m#nivel#.SMcodigo
					  and x#nivel#.SPcodigo = m#nivel#.SPcodigo
					  and x#nivel#.Usucodigo = #session.Usucodigo#
					  and x#nivel#.Ecodigo = #session.EcodigoSDC#) )
	</cfloop>
	
	order by <cfloop from="1" to="#niveles#" index="nivel">
			<cfif nivel gt 1>,</cfif>r#nivel#.ruta
			</cfloop>
</cfquery>

<cfquery datasource="asp" name="shortcuts">
	select i.etiqueta_item as shortcut_text, i.id_item as shortcut_item
	from SShortcut s
		join SMenuItem i
			on s.id_item = i.id_item
	where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
	order by i.id_item
</cfquery>

<cfquery name="rsEmpresas" datasource="asp">
	select distinct
		e.Ecodigo,
		e.Enombre,
		e.Ereferencia,
		c.Ccache, e.ts_rversion
		<!--- para manejar el cache de la imagen --->
	from vUsuarioProcesos up, Empresa e, Caches c
	where up.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
	  and e.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
	  and up.Ecodigo = e.Ecodigo
	  and c.Cid = e.Cid
	<cfif Len(session.sitio.Ecodigo) and session.sitio.Ecodigo neq 0>
	  and e.Ecodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.sitio.Ecodigo#">
	<cfelse>
	order by upper( e.Enombre )
	</cfif>
</cfquery>

<!---
reemplazar "#([0-9a-f]{6})" por "##$1"
poner <cfif Len(elmenu.nivel5)></cfif> alrededor de cada arrow_r.gif
--->

stm_bm(["menu2fa0",400,"/cfmx/sif/js/DHTMLMenu/","blank.gif",0,"","",0,0,100,100,1000,1,0,0,""],this);
stm_bp("p0",[0,4,0,0,0,4,0,7,100,"",-2,"",-2,50,0,0,"##e8e8e8","##cccccc","",3,0,0,"##000000"]);
stm_ai("p0i0",[0,"Inicio","","",-1,-1,0,"/cfmx/home/menu/portal.cfm","_self","","","","",0,0,0,"","",7,7,0,0,1,"##cccccc",0,"##b5bed6",0,"","",3,3,0,0,"##fffff7","##000000","##000000","##000000","8pt 'Tahoma','Verdana','sans-serif'","8pt 'Tahoma','Verdana','sans-serif'",0,0]);
//<cfif shortcuts.RecordCount>
stm_ai("p0i1",[0,"Atajos","","",-1,-1,0,"","_self","","","","",0,0,0,"arrow_r.gif","arrow_r.gif",7,7,0,0,1,"##cccccc",0,"##b5bed6",0,"","",3,3,0,0,"##fffff7","##000000","##000000","##000000","8pt 'Tahoma','Verdana','sans-serif'","8pt 'Tahoma','Verdana','sans-serif'",0,0]);
stm_bpx("p1","p0",[1,4,0,0,0,4,0,0,100,"",-2,"",-2,50,0,0,"##e8e8e8","##fffff7","",3,1,1]);
//<cfoutput query="shortcuts">
stm_ai("p1i0",[0,"#shortcut_text#","","",-1,-1,0,"/cfmx/home/menu/portal.cfm?_nav=1&i=#shortcut_item#","_self","","","","",0,0,0,"","",0,0,0,0,1,"##fffff7",0,"##b5bed6",0,"","",3,3,0,0,"##fffff7","##000000","##000000","##000000","8pt 'Tahoma','Verdana','sans-serif'","8pt 'Tahoma','Verdana','sans-serif'",0,0]);
//</cfoutput>
stm_ep();
//</cfif>// shortcuts.RecordCount
//<cfif Len(elmenu.nivel1)><cfoutput query="elmenu" group="nivel1">
stm_ai("p0i2",[0,"#etiqueta1#","","",-1,-1,0,"/cfmx/home/menu/portal.cfm?_nav=1&i=#nivel1#","_self","","","","",0,0,0,"<cfif Len(elmenu.nivel2)>arrow_r.gif</cfif>","<cfif Len(elmenu.nivel2)>arrow_r.gif</cfif>",7,7,0,0,1,"##cccccc",0,"##b5bed6",0,"","",3,3,0,0,"##fffff7","##000000","##000000","##000000","8pt 'Tahoma','Verdana','sans-serif'","8pt 'Tahoma','Verdana','sans-serif'",0,0]);
stm_bpx("p2","p0",[1,4,0,0,0,4,0,7,100,"",-2,"",-2,50,0,0,"##e8e8e8","##fffff7","",3,1,1]);
//<cfif Len(elmenu.nivel2)><cfoutput group="nivel2">
stm_ai("p2i0",[0,"#etiqueta2#","","",-1,-1,0,"/cfmx/home/menu/portal.cfm?_nav=1&i=#nivel2#","_self","","","","",0,0,0,"<cfif Len(elmenu.nivel3)>arrow_r.gif</cfif>","<cfif Len(elmenu.nivel3)>arrow_r.gif</cfif>",7,7,0,0,1,"##fffff7",0,"##b5bed6",0,"","",3,3,0,0,"##fffff7","##000000","##000000","##000000","8pt 'Tahoma','Verdana','sans-serif'","8pt 'Tahoma','Verdana','sans-serif'",0,0]);
stm_bpx("p3","p0",[1,2,0,0,0,4,0,7,100,"",-2,"",-2,50,0,0,"##e8e8e8","##fffff7","",3,1,1]);
//<cfif Len(elmenu.nivel3)><cfoutput group="nivel3">
stm_ai("p3i0",[0,"#etiqueta3#","","",-1,-1,0,"/cfmx/home/menu/portal.cfm?_nav=1&i=#nivel3#","_self","","","","",0,0,0,"<cfif Len(elmenu.nivel4)>arrow_r.gif</cfif>","<cfif Len(elmenu.nivel4)>arrow_r.gif</cfif>",7,7,0,0,1,"##fffff7",0,"##b5bed6",0,"","",3,3,0,0,"##fffff7","##000000","##000000","##000000","8pt 'Tahoma','Verdana','sans-serif'","8pt 'Tahoma','Verdana','sans-serif'",0,0]);
stm_bpx("p4","p0",[1,2,0,0,0,4,0,7,100,"",-2,"",-2,50,0,0,"##e8e8e8","##fffff7","",3,1,1]);
//<cfif Len(elmenu.nivel4)><cfoutput group="nivel4">
stm_ai("p4i0",[0,"#etiqueta4#","","",-1,-1,0,"/cfmx/home/menu/portal.cfm?_nav=1&i=#nivel4#","_self","","","","",0,0,0,"<cfif Len(elmenu.nivel5)>arrow_r.gif</cfif>","<cfif Len(elmenu.nivel5)>arrow_r.gif</cfif>",7,7,0,0,1,"##fffff7",0,"##b5bed6",0,"","",3,3,0,0,"##fffff7","##000000","##000000","##000000","8pt 'Tahoma','Verdana','sans-serif'","8pt 'Tahoma','Verdana','sans-serif'",0,0]);
stm_bpx("p5","p0",[1,2,0,0,0,4,0,0,100,"",-2,"",-2,50,0,0,"##e8e8e8","##fffff7","",3,1,1]);
//<cfif Len(elmenu.nivel5)><cfoutput group="nivel4">
stm_ai("p5i0",[0,"#etiqueta5#","","",-1,-1,0,"/cfmx/home/menu/portal.cfm?_nav=1&i=#nivel5#","_self","","","","",0,0,0,"","",0,0,0,0,1,"##fffff7",0,"##b5bed6",0,"","",3,3,0,0,"##fffff7","##000000","##000000","##000000","8pt 'Tahoma','Verdana','sans-serif'","8pt 'Tahoma','Verdana','sans-serif'",0,0]);
//</cfoutput></cfif>//nivel5
stm_ep();
//</cfoutput></cfif>//nivel4
stm_ep();
//</cfoutput></cfif>//nivel3
stm_ep();
//</cfoutput></cfif>//nivel2
stm_ep();
//</cfoutput></cfif>//nivel1
stm_ai("p0i3",[6,100,"##cccccc","",0,0,0]);
//<cfif session.Usucodigo>
stm_ai("p0i4",[0,"<cfoutput>#session.Enombre#</cfoutput>","","",-1,-1,0,"","_self","","","","",0,0,0,"arrow_r.gif","arrow_r.gif",7,7,0,2,1,"##cccccc",0,"##b5bed6",0,"","",3,3,0,0,"##fffff7","##000000","##000000","##000000","8pt 'Tahoma','Verdana','sans-serif'","8pt 'Tahoma','Verdana','sans-serif'",0,0]);
stm_bpx("p6","p0",[1,4,0,0,0,4,0,0,100,"",-2,"",-2,50,0,0,"##e8e8e8","##cccccc","",3,1,1]);
//<cfoutput query="rsEmpresas">
stm_ai("p6i0",[0,"#rsEmpresas.Enombre#","","",-1,-1,0,"/cfmx/home/menu/portal.cfm?_nav=1&seleccionar_EcodigoSDC=#rsEmpresas.Ecodigo#","_self","","","","",0,0,0,"","",0,0,0,0,1,"##fffff7",0,"##b5bed6",0,"","",3,3,0,0,"##fffff7","##000000","##000000","##000000","8pt 'Tahoma','Verdana','sans-serif'","8pt 'Tahoma','Verdana','sans-serif'",0,0]);
//</cfoutput>
stm_ep();
//</cfif>//session.Usucodigo
stm_ep();
stm_em();
