<cfif isdefined("rsMenues_")>
	<cfexit>
</cfif>

<cfquery name="rsPermisos" datasource="asp">
	select count(1) as CantidadPermisos
	  from vUsuarioProcesos
	where Usucodigo = 27
</cfquery>
<cfparam name="session.menues.CantidadPermisos" default="">
<cfif session.menues.CantidadPermisos EQ rsPermisos.CantidadPermisos>
	<cfset LvarHora = 1>
<cfelse>
	<cfset session.menues.CantidadPermisos = rsPermisos.CantidadPermisos>
	<cfset LvarHora = 0>
</cfif>

<cfquery name="rsMenues_" datasource="asp" cachedwithin="#CreateTimeSpan(0,LvarHora,0,0)#">
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
	   and p.SPmenu = 1 
	  , SSistemas s, SModulos m
 	 where mn.SScodigo = s.SScodigo
	   and mn.SScodigo = m.SScodigo
	   and mn.SMcodigo = m.SMcodigo
	   and s.SSmenu = 1 
	   and m.SMmenu = 1 
	   and mn.SMNnivel <> 0
	   and exists (
			select *
			  from SMenues mnp, vUsuarioProcesos up
			 where up.Usucodigo = 27
			   and up.Ecodigo = 2
			   and up.SScodigo = mnp.SScodigo
			   and up.SMcodigo = mnp.SMcodigo
			   and up.SPcodigo = mnp.SPcodigo
			   and mn.SScodigo = mnp.SScodigo
			   and mn.SMcodigo = mnp.SMcodigo
			   <!---and mnp.SMNpath like mn.SMNpath || '%' --->
			   and mnp.SMNpath >= mn.SMNpath
			   and mnp.SMNpath < mn.SMNpath || '~'

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
	where up.Usucodigo = 27
	  and up.Ecodigo = 2
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


<script type="text/javascript" language="javascript1.2" src="sothink/stm31.js"></script>
		<script language="JavaScript1.2" type="text/javascript">
		var GvarNivel = 0;
		var GvarNivelOpciones = false;
		function sbMenuInicializa()
		{
			stm_bm(["LvarMnu0",310,"/cfmx/sif/js/DHTMLMenu/","blank.gif",0,"","",0,0,250,0,1000,1,0,0]);
			stm_bp("LvarMnu1",[1,4,0,0,2,1,10,7,100,"",-2,"",-2,90,0,0,"#000000","#ffffff","",3,1,0,"#003300 #ffffff #003300 #003300"]);
			GvarNivel = 1;
			GvarNivelOpciones = false;
		}
		function sbMenuAgregaSubmenu(pTitulo, pNivel)
		{
			if (fnMenuAjustaNivel(pNivel)) // Solo incluye en el nivel actual
			{
				var flecha=document.stm31Right?"arrow_l.gif":"arrow_r.gif";
				stm_ai("LvarMnu2",[0,fnMenuAjustaTexto(pTitulo),"","",-1,-1,0,"","_self","","","","",10,0,0,flecha,flecha,-1,-1,0,0,1,"#ffffff",0,"#E4EAF4",0,"","",3,3,0,0,"#000000","#000000","#000000","#000000","8pt Tahoma, Verdana, Helvetica, Sans-Serif;","8pt Tahoma, Verdana, Helvetica, Sans-Serif;",0,0]);
				stm_bp("LvarMnu2",[1,document.stm31Right?1:2,0,0,2,2,0,4,100,"",-2,"",-2,90,0,0,"#000000","#ffffff","",3,1,1,"#003300"]);
				GvarNivel++;
				GvarNivelOpciones = false;
			}
		}
		function sbMenuAgregaOpcion(pTitulo, pUri, pNivel)
		{
			if (pUri!=null && pUri!="")
			{
				if (pUri.substring(0,1) != '/') 
					pUri = "/" + pUri;
				if (pUri.substring(0,6) != '/cfmx/') 
					pUri = "/cfmx" + pUri;
			}
		
			if (fnMenuAjustaNivel(pNivel)) // Solo incluye en el nivel actual
			{
				stm_ai("LvarMnu1",[0,fnMenuAjustaTexto(pTitulo),"","",-1,-1,0,pUri,"_self",pUri,"","","",10,0,0,"","",-1,-1,0,0,1,"#ffffff",0,"#E4EAF4",0,"","",3,3,0,0,"#000000","#000000","#000000","#000000","8pt Tahoma, Verdana, Helvetica, Sans-Serif;","8pt Tahoma, Verdana, Helvetica, Sans-Serif;",0,0]);
				GvarNivelOpciones = true;
			}
		}
		function sbMenuAgregaEnConstruccion(pTitulo, pNivel)
		{
			if (fnMenuAjustaNivel(pNivel)) // Solo incluye en el nivel actual
			{
				var pUri = "javascript:alert('La Opción no está disponible en este momento');"
				stm_ai("LvarMnu1",[0,fnMenuAjustaTexto(pTitulo),"","",-1,-1,0,pUri,"_self",pUri,"","","",10,0,0,"","",-1,-1,0,0,1,"#ffffff",0,"#E4EAF4",0,"","",3,3,0,0,"#000000","#000000","#000000","#000000","8pt Tahoma, Verdana, Helvetica, Sans-Serif;","8pt Tahoma, Verdana, Helvetica, Sans-Serif;",0,0]);
				GvarNivelOpciones = true;
			}
		}
		function sbMenuAgregaTitulo(pTitulo, pNivel)
		{
			if (fnMenuAjustaNivel(pNivel)) // Solo incluye en el nivel actual
			{
				stm_ai("LvarMnu1",[0,fnMenuAjustaTexto(pTitulo),"","",-1,-1,0,"","_self","","","","",10,0,0,"","",-1,-1,0,0,1,"#ffffff",0,"#ffffff",0,"","",3,3,0,0,"#000000","#000000","#000000","#000000","bold 8pt Tahoma, Verdana, Helvetica, Sans-Serif;","bold 8pt Tahoma, Verdana, Helvetica, Sans-Serif;",0,0]);
				GvarNivelOpciones = true;
			}
		}
		function fnMenuAjustaNivel(pNivel)
		{
			// !pNivel   : Nivel Actual
			// pNivel = 0: Nivel Actual
			// pNivel > 0: Nivel Absoluto, ir al nivel indicado
			// pNivel < 0: Nivel Relativo, bajar tantos niveles
			// pNivel > Actual: Se ignora la opcion
			if (!pNivel)	pNivel = 0;
			if (pNivel > 0)
			{
				if ( (!GvarNivelOpciones) && (pNivel < GvarNivel) )
					stm_ai("LvarOpc1",[0,"Opción no está Disponible","","",-1,-1,0,"","_self","","","","",10,0,0,"","",-1,-1,0,0,1,"#ffffff",0,"#E4EAF4",0,"","",3,3,0,0,"#000000","#000000","#000000","#000000","8pt Tahoma, Verdana, Helvetica, Sans-Serif;","8pt Tahoma, Verdana, Helvetica, Sans-Serif;",0,0]);
		
				while (pNivel < GvarNivel)
				{
				  stm_ep(); GvarNivel--;
				}
			}
			else if (pNivel < 0) // Baja los niveles indicados
				for (var i=0; (i < pNivel) && (GvarNivel > 1); i++)
				{
				  stm_ep(); GvarNivel--;
				}
				
			return (pNivel == 0) || (pNivel == GvarNivel);
		}

		// Agrega un linea separadora
		function sbMenuAgregaLinea(){
			stm_ai("LvarMnu",[6,1,"#000000","",-1,-1,0]);
		}

		function sbMenuFinaliza()
		{
			while (GvarNivel > 0)
			{
			  stm_ep(); GvarNivel--;
			}
			stm_em();
		}
		function fnMenuAjustaTexto(pText) 
		{
			var LvarPto = 25;
			if (pText.length < LvarPto) return pText;
			var sp = pText.indexOf(" ",parseInt(LvarPto-5));
			if (sp>LvarPto) sp = pText.indexOf(" ",parseInt(LvarPto/2)); 
			if (sp==-1) sp = pText.indexOf(" ",parseInt(LvarPto/3)); 
			if (sp==-1) sp = pText.indexOf(" ",parseInt(LvarPto/4)); 
			if (sp==-1) sp = pText.indexOf(" ");
			if (sp==-1) sp = LvarPto;
			if (pText.indexOf("<br>")!=-1) return pText;
			
			return pText.substring(0,sp) + "<br>" + pText.substring(sp+1).substring(0,LvarPto);
		}
		




		sbMenuInicializa();
		sbMenuAgregaOpcion("Inicio", "/cfmx/home/menu/index.cfm");
		sbMenuAgregaLinea();
		<cfquery name="rsSistemas" dbtype="query">
			select distinct SScodigo
			  from rsMenues_
		</cfquery>
		<cfif rsSistemas.recordCount GT 1>
			<cfset LvarNivelSis = 1>
		<cfelse>
			<cfset LvarNivelSis = 0>
		</cfif>
		<cfset LvarNivelMod = 0>
		<cfset LvarSScodigo="">
		<cfset LvarSScodigo="">
		<cfoutput query="rsMenues_">
			<cfif LvarSScodigo NEQ rsMenues_.SScodigo>
				<cfset LvarSScodigo = rsMenues_.SScodigo>
				<cfset LvarSMcodigo = rsMenues_.SMcodigo>
				<cfquery name="rsModulos" dbtype="query">
					select distinct SMcodigo
					  from rsMenues_
					 where SScodigo = '#rsMenues_.SScodigo#'
				</cfquery>
				<cfset LvarNivelMod = 0>
				<cfif rsModulos.recordCount GT 1>
					<cfset LvarNivelMod = 1>
				<cfelseif LvarNivelSis EQ 0>
					<cfquery name="rsPrimerNivel" dbtype="query">
						select SMNcodigo
						  from rsMenues_
						 where SScodigo = '#rsMenues_.SScodigo#'
						   and SMcodigo = '#rsMenues_.SMcodigo#'
						   and SMNnivel = 1
					</cfquery>
					<cfif rsPrimerNivel.recordCount GT 10>
						<cfset LvarNivelSis = 1>
					</cfif>
				</cfif>
				<cfif len(rsMenues_.SShomeuri) NEQ 0>
					sbMenuAgregaOpcion("#rsMenues_.SSdescripcion#", "/cfmx/home/menu/pagina.cfm?s=#URLEncodedFormat(rsMenues_.SScodigo)#", "#1+LvarNivelSis+LvarNivelMod#");						
				<cfelseif LvarNivelSis EQ 1>
					sbMenuAgregaSubmenu("#rsMenues_.SSdescripcion#",1);
				<cfelse>
					sbMenuAgregaTitulo("#rsMenues_.SSdescripcion#",1);
				</cfif>
				<cfif len(rsMenues_.SShomeuri) NEQ 0>
				<cfelseif len(rsMenues_.SMhomeuri) NEQ 0>
					sbMenuAgregaOpcion("#rsMenues_.SMdescripcion#", "/cfmx/home/menu/pagina.cfm?s=#URLEncodedFormat(rsMenues_.SScodigo)#&m=#URLEncodedFormat(rsMenues_.SMcodigo)#", "#LvarNivelSis+LvarNivelMod#");
				<cfelseif LvarNivelMod EQ 1>
					sbMenuAgregaSubmenu("#rsMenues_.SMdescripcion#",#LvarNivelSis+LvarNivelMod#);
				</cfif>
			<cfelseif LvarSMcodigo NEQ rsMenues_.SMcodigo>
				<cfset LvarSMcodigo = rsMenues_.SMcodigo>
				<cfif len(rsMenues_.SShomeuri) NEQ 0>
				<cfelseif len(rsMenues_.SMhomeuri) NEQ 0>
					sbMenuAgregaOpcion("#rsMenues_.SMdescripcion#", "/cfmx/home/menu/pagina.cfm?s=#URLEncodedFormat(rsMenues_.SScodigo)#&m=#URLEncodedFormat(rsMenues_.SMcodigo)#", "#LvarNivelSis+LvarNivelMod#");						
				<cfelse>
					sbMenuAgregaSubmenu("#rsMenues_.SMdescripcion#",#LvarNivelSis+LvarNivelMod#);
				</cfif>
			</cfif>
			<cfif len(rsMenues_.SShomeuri) NEQ 0 or len(rsMenues_.SMhomeuri) NEQ 0>
			<cfelseif rsMenues_.SMNenConstruccion EQ "1" OR (rsMenues_.SMNtipo EQ "P" AND fnUriBis(rsMenues_.SPhomeuri) EQ "/cfmx/")>
				sbMenuAgregaEnConstruccion("#rsMenues_.SMNtitulo#", "#rsMenues_.SMNnivel+LvarNivelSis+LvarNivelMod#");
			<cfelseif rsMenues_.SMNtipo EQ "M">
				sbMenuAgregaSubmenu("#rsMenues_.SMNtitulo#",#rsMenues_.SMNnivel+LvarNivelSis+LvarNivelMod#);
			<cfelseif rsMenues_.SMNtipo EQ "S">
				sbMenuAgregaOpcion("#rsMenues_.SMNtitulo#", "/cfmx/home/menu/pagina.cfm?s=#URLEncodedFormat(rsMenues_.SScodigo)#&m=#URLEncodedFormat(rsMenues_.SMcodigo)#&p=#URLEncodedFormat(rsMenues_.SPcodigo)#", "#rsMenues_.SMNnivel+LvarNivelSis+LvarNivelMod#");
			<cfelse>
				sbMenuAgregaOpcion("#rsMenues_.SMNtitulo#", "/cfmx/home/menu/pagina.cfm?n=#URLEncodedFormat(rsMenues_.SMNcodigo)#");
			</cfif>
		</cfoutput>
		
		fnMenuAjustaNivel(1);
		sbMenuAgregaLinea();
		sbMenuAgregaOpcion("Cambiar<br> contrase&ntilde;a", "/cfmx/home/menu/passch.cfm");
		sbMenuAgregaLinea();
		sbMenuAgregaOpcion("Salir", "/cfmx/home/public/logout.cfm");
		sbMenuFinaliza();
		
		</script> 
<cffunction name="fnUriBis" output="false" returntype="string">
	<cfargument name="pUri" type="string">
	<cfif mid(pUri, 1, 6) NEQ "/cfmx/">
		<cfif mid(pUri, 1, 1) EQ "/">
			<cfreturn "/cfmx" & pUri>
		<cfelse>
			<cfreturn "/cfmx/" & pUri>
		</cfif>
	</cfif>
</cffunction>
