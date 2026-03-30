<!---
<cfset xinicio = now() >
<cfoutput>#xinicio#<br></cfoutput>
--->
<cfif not isdefined("session.menues.id_root")>
	<!--- Determina el Menu Default Inicial --->
	
	<!--- 1. El guardado en Preferencias --->
	<cfquery datasource="asp" name="rsRM">
		select id_root
		  from Preferencias
		 where Usucodigo = #session.Usucodigo#
		   and Ecodigo	 = #session.EcodigoSDC#
	</cfquery>
	
	<cfif rsRM.id_root NEQ "">
		<cfset session.menues.id_default = rsRM.id_root>
		<cfset session.menues.id_root = rsRM.id_root>
		<cfset LvarPreferencias = -1>
	<cfelse>
		<cfset LvarPreferencias = rsRM.recordCount>
	<!--- 2. Menu Default del Primer Rol del Usuario --->
		<cfquery datasource="asp" name="rsURM">
			select rm.id_root, rm.default_menu, ur.ts_rversion
			  from UsuarioRol ur
				  inner join SRolMenu rm
				  	 on rm.SScodigo = ur.SScodigo
					and rm.SRcodigo = ur.SRcodigo
			 where ur.Usucodigo 	= #session.Usucodigo#
			   and ur.Ecodigo		= #session.EcodigoSDC#
			 order by ur.ts_rversion
		</cfquery>

		<cfquery name="rsRM" dbtype="query">
			select id_root
			  from rsURM
			 where default_menu = 1
			 order by ts_rversion
		</cfquery>

		<cfif rsRM.id_root NEQ "">
			<cfset session.menues.id_root = rsRM.id_root>
		<cfelse>
	<!--- 3. Primer Menu del Primer Rol del Usuario --->
			<cfif rsURM.id_root NEQ "">
				<cfset session.menues.id_root = rsURM.id_root>
			<cfelse>
	<!--- 4. Menu Default Publico --->
				<cfquery datasource="asp" name="rsRM">
					select id_root
					  from SMenu
					 where default_menu = 1
				</cfquery>
				<cfif rsRM.id_root NEQ "">
					<cfset session.menues.id_root = rsRM.id_root>
				<cfelse>
	<!--- 5. Primer Menu Publico para el Portal --->
					<cfquery datasource="asp" name="rsRM" maxrows="1">
						select id_root
						  from SMenu
						 where publico_menu = 1
						 order by orden_menu
					</cfquery>
					<cfif rsRM.id_root NEQ "">
						<cfset session.menues.id_root = rsRM.id_root>
					<cfelse>
	<!--- 6. No hay Menues --->
						<cfset session.menues.id_root = 0>
					</cfif>
				</cfif>
			</cfif>
		</cfif>
	</cfif>

	<cfif session.menues.id_root EQ 0>
		<cfset LvarId_root = "null">
	<cfelse>
		<cfset LvarId_root = session.menues.id_root>
	</cfif>

	<cfif LvarPreferencias EQ 0>
			<cfquery datasource="asp" name="rsRM">
				insert into Preferencias
					(Usucodigo, Ecodigo, id_root, BMfecha, BMUsucodigo)
				values(#session.Usucodigo#,#session.EcodigoSDC#,#LvarId_root#,#session.Usucodigo#)
			</cfquery>
	<cfelseif LvarPreferencias GT 0>
		<cfquery datasource="asp" name="rsRM">
			update Preferencias
			   set id_root 	 = #LvarId_root#
			 where Usucodigo = #session.Usucodigo#
			   and Ecodigo	 = #session.EcodigoSDC#
		</cfquery>
	</cfif>

</cfif>

<cfif Len(session.menues.id_root) is 0>
	<cfset session.menues.id_root=0>
</cfif>

<cfquery datasource="sifcontrol" name="translate_idioma" maxrows="1" >
	select coalesce(Iid, 0) as Iid
	from Idiomas
	where Icodigo = '#session.Idioma#'
	<cfif Len(session.Idioma) GT 3>
	   or Icodigo = '#Mid(session.Idioma,1,2)#'
	</cfif>
</cfquery>

<cfquery datasource="asp" name="items" cachedwithin="#CreateTimeSpan(0,0,-10,0)#" >
	select
			m.id_item as item, m.etiqueta_item as etiqueta_old, papa.id_padre as papa, r.profundidad, r.ruta as ruta,
			<!--- estos siguientes sirven para determinar si el menu es clicable o no --->
			m.SScodigo, m.SMcodigo, m.SPcodigo, m.id_pagina, m.url_item,
			coalesce((	select VSdesc
						from VSidioma
						where Iid     = #translate_idioma.Iid#
						  and VSgrupo = 124
						  and VSvalor = <cf_dbfunction name="to_char" args="m.id_item" datasource="asp"> ), m.etiqueta_item) as etiqueta,
			(select count(1) from SRelacionado ra where ra.id_padre = m.id_item and ra.profundidad != 0) as es_padre
	from SRelacionado r
			join SMenuItem m
				on m.id_item = r.id_hijo
			join SRelacionado papa
				on papa.id_hijo = m.id_item
				and papa.profundidad = 1
			join SRelacionado papx <!--- asegurarse de que papa sea hijo de session.menues.root --->
				on papx.id_hijo = papa.id_padre
				and papx.id_padre = #session.menues.id_root#
	where r.id_padre = #session.menues.id_root#
		and (m.SScodigo is null or m.SMcodigo is null or m.SPcodigo is null 
			or exists (select * from vUsuarioProcesos x
			where x.SScodigo = m.SScodigo
			  and x.SMcodigo = m.SMcodigo
			  and x.SPcodigo = m.SPcodigo
			  and x.Usucodigo = #session.Usucodigo#
			  and x.Ecodigo = #session.EcodigoSDC#) )
	order by r.ruta, r.profundidad asc
</cfquery>

<cfset menucount = items.RecordCount>
<cfloop from="1" to="10" index="iiii">
	<cfif Len(ValueList(items.papa)) EQ 0>
		<cfbreak>
	</cfif>
	<cfquery dbtype="query" name="items" >
		select * from items where 
		SPcodigo is not null
		or item in (#ValueList(items.papa)#)
	</cfquery>
	<cfif menucount EQ items.RecordCount>
		<cfbreak>
	</cfif>
	<cfset menucount = items.RecordCount>
</cfloop>

<cfset traducir = structnew()>
<cfoutput query="items">
	<cfset StructInsert(traducir, items.item, items.etiqueta) >
</cfoutput>

<cfquery name="padres" dbtype="query">
	select * from items where profundidad = 1
</cfquery>

<cfquery datasource="asp" name="shortcuts">
	select s.id_shortcut, 
		s.descripcion_shortcut, s.id_item,
		s.SScodigo, s.SMcodigo, s.SPcodigo, s.url_shortcut
	from SShortcut s
	where s.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
	order by s.id_item
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

<script type="text/javascript" language="JavaScript1.2" src="/cfmx/sif/js/sothink/stm31.js"></script>
<cfoutput>

<script type="text/javascript" language="javascript1.2">
	function add_shortcut(){
	<cfif IsDefined('ubicacionSP.SPcodigo') and Len(ubicacionSP.SPcodigo)>
		var shortcut_text = prompt('¿Con qué nombre desea agregar esta opción a sus favoritos?','<cfoutput>#JSStringFormat(ubicacionSP.SPdescripcion)#</cfoutput>');
		if (shortcut_text) {
		<cfoutput>
			window.open('/cfmx/home/menu/portlets/shortcut_add.cfm?s=#URLEncodedFormat(ubicacionSS.SScodigo)
				#&m=#URLEncodedFormat(ubicacionSM.SMcodigo)
				#&p=#URLEncodedFormat(ubicacionSP.SPcodigo)
				#&t='+escape(shortcut_text),'menu_action');
		</cfoutput>
		}
	<cfelse>
		alert('No disponible cuando se invoca el menú reducido');
	</cfif>
	}
	
	function sbSeleccionarRol(){
		location.href = "/cfmx/home/menu/portal_rol.cfm?url=" + escape(location.href);
	}
	
	//-->
</script>

<!--- ////////////////////////////////////////////////// --->
<!--- ////////////////////////////////////////////////// --->
<!--- VARIABLES DE CONFIGURACION DEL MENU --->
<!--- definición de colores --->
<cfset Menu_Background = "##152B5D">
<cfset MouseOver_MenuItem = "##FFFFFF"> <!--- Color cuando se para sobre una de las opciones del menu --->
<cfset MouseOut_MenuGlobal ="##FFFFFF">
<cfset MouseOut_AutoScroll = "##FFFFF7">
<cfset MouseOut_PopUpMenu = "##FFFFFF">
<cfset MouseOver_PopUpMenu = "##000000">
<cfset Border_PopUpMenu = "##356595">	<!--- Color del borde de los submenues --->
<cfset Submenu_Background = "##CCE3F8"> <!--- Color de fondo de los submenus --->
<cfset Submenu_ColorLetra = "##000000"> <!--- Color de letra de los submenus --->

<!--- definición de tipo de letra --->
<cfset FontOut = "9pt Arial">
<cfset FontOver = "9pt Arial">

<!--- definición de imagenes --->
<cfset ruta = "/cfmx/sif/js/sothink/" >
<cfset img_updisabled = "#ruta#up_disabled.gif">
<cfset img_upenabled = "#ruta#up_enabled.gif">
<cfset img_sampleredarrow = "#ruta#arrow_main.gif">
<cfset img_downenabled = "#ruta#down_enabled.gif">
<cfset img_downdisabled = "#ruta#down_disabled.gif">
<cfset img_arrowr = "#ruta#arrow_r.gif">
<cfset img_blank = "#ruta#blank.gif">
<!--- ////////////////////////////////////////////////// --->
<!--- ////////////////////////////////////////////////// --->

<table width="100%" cellpadding="0" cellspacing="0" >
<tr>
	<td width="75%">
	<cfset nav = "?_nav=1&root=1">
<cfsavecontent variable="menu">
	stm_bm(["menu7c2d",430,"","#img_blank#",0,"","",0,3,150,250,150,1,1,0,"","100%",0],this);
	stm_sc(1,["transparent","transparent","","",3,3,0,0,"##FFFFF7","##000000","#img_updisabled#","#img_upenabled#",7,9,0,"#img_downdisabled#","#img_downenabled#",7,9,0]);
	stm_bp("p0",[0,4,0,0,1,3,13,13,100,"",-2,"",-2,90,0,0,"##7F7F7F","#Menu_Background#","",3,0,0,"#Border_PopUpMenu#"]);
	
	<cfif isdefined("session.origen") and listcontains(session.origen, 'sistema') >
		<cfset vInicio = '/cfmx/' >
	<cfelse>
		<cfset vInicio = '/cfmx/home/menu/portal.cfm?_nav=1&amp;root=1' >
	</cfif>
	
	stm_ai("p0i0",[0,"<strong>Inicio</strong>","","",-1,-1,0,"#vInicio#","_self","","","","",0,0,0,"","",0,0,0,2,1,"##FFFFFF",1,"##FFFFFF",1,"","",3,3,0,0,"##FFFFFF","##FFFFFF","##FFFFFF","#MouseOver_MenuItem#","#FontOut#","#FontOver#",0,0]);
	
	stm_aix("p0i1","p0i0",[1,"<strong>Favoritos&nbsp;</strong>","","",-1,-1,0,"","_self","","","","",0,0,0,"#img_sampleredarrow#","#img_sampleredarrow#",13,8,0,0]);
	stm_bpx("p1","p0",[1,4,0,0,0,3,0,0,83,"",-2,"",-2,58,0,0,"##7F7F7F","##FFFFFF","",3,1,1]);
	stm_aix("p1i0","p0i0",[1,"Organizar Mis Favoritos","","",-1,-1,0,"/cfmx/home/menu/portlets/shortcut_edit.cfm#nav#","_self","","","","",0,0,0,"","",0,0,0,0,1,"#Submenu_Background#",0,"#MouseOver_MenuItem#",0,"","",3,3,0,0,"#Submenu_ColorLetra#","#Submenu_ColorLetra#","#Submenu_ColorLetra#","#Submenu_ColorLetra#"]);
	stm_aix("p1i1","p0i0",[1,"Personalizar esta página","","",-1,-1,0,"/cfmx/home/menu/portlets/indicadores/personalizar.cfm#nav#","_self","","","","",0,0,0,"","",0,0,0,0,1,"#Submenu_Background#",0,"#MouseOver_MenuItem#",0,"","",3,3,0,0,"#Submenu_ColorLetra#","#Submenu_ColorLetra#","#Submenu_ColorLetra#","#Submenu_ColorLetra#"]);
	<cfif IsDefined('ubicacionSP.SPcodigo') and Len(ubicacionSP.SPcodigo)>
		stm_aix("p1i2","p0i0",[1,"Agregar a Favoritos","","",-1,-1,0,"javascript:add_shortcut()","_self","","","","",0,0,0,"","",0,0,0,0,1,"#Submenu_Background#",0,"#MouseOver_MenuItem#",0,"","",3,3,0,0,"#Submenu_ColorLetra#","#Submenu_ColorLetra#","#Submenu_ColorLetra#","#Submenu_ColorLetra#"]);
	</cfif>

	<cfif shortcuts.recordcount gt 0>
	stm_ai("p1i2",[6,1,"##000000","",0,0,0]);
	</cfif>
	
	<cfset shortcut_link = ''>
	<cfloop query="shortcuts">
		<cfif Len(shortcuts.id_item) >
			<cfset shortcut_link = "/cfmx/home/menu/portal.cfm?_nav=1&amp;i=" & shortcuts.id_item >
		<cfelseif Len(shortcuts.SScodigo) And Len(shortcuts.SMcodigo) And Len(shortcuts.SPcodigo) >
			<cfset shortcut_link = "/cfmx/home/menu/portal.cfm?_nav=1&amp;s=" & URLEncodedFormat(shortcuts.SScodigo) & "&amp;m=" & URLEncodedFormat(shortcuts.SMcodigo) & "&amp;p=" & URLEncodedFormat(shortcuts.SPcodigo) >
		<cfelseif Len(shortcuts.SScodigo) And Len(shortcuts.SMcodigo) >
			<cfset shortcut_link = "/cfmx/home/menu/portal.cfm?_nav=1&amp;s=" & URLEncodedFormat(shortcuts.SScodigo) & "&amp;m=" & URLEncodedFormat(shortcuts.SMcodigo) >
		<cfelseif Len(shortcuts.SScodigo) >
			<cfset shortcut_link = "/cfmx/home/menu/portal.cfm?_nav=1&amp;s=" & URLEncodedFormat(shortcuts.SScodigo) >
		<cfelseif Len(shortcuts.url_shortcut) >
			<cfset shortcut_link = shortcuts.url_shortcut >
			<cfif mid(shortcut_link, 1, 1) EQ '/' And mid(shortcut_link, 1, 6) NEQ '/cfmx/'>
				<cfset shortcut_link = '/cfmx' & shortcut_link >
			</cfif>
		</cfif>
		stm_aix("p1i#shortcuts.currentrow+2#","p0i0",[1,"#shortcuts.descripcion_shortcut#","","",-1,-1,0,"#shortcut_link#","_self","","","","",0,0,0,"","",0,0,0,0,1,"#Submenu_Background#",0,"#MouseOver_MenuItem#",0,"","",3,3,0,0,"#Submenu_ColorLetra#","#Submenu_ColorLetra#","#Submenu_ColorLetra#","#Submenu_ColorLetra#"]);	
	</cfloop>
	stm_ep();
	
	<cfset profundidadant = 1 >
	<cfset cerrar = 0 >

	<cfset vMenu = 1 >
	<cfset cantSMenu = 1 >
	<cfset pila = arraynew(1) >
	<cfset arrayappend(pila, 1) >
	<cfset vHijos = structnew() >
	<cfset structinsert(vHijos, 1, 2) >

	<cfloop query="items" >
		
	<cfif ListFind( ValueList(items.papa), item ) Or Len(items.SPcodigo) >
	
	
		<cfset imagen = '' >
		<cfif items.profundidad gt 1 >
			<cfif items.es_padre gt 0 >
				<cfset imagen = "&nbsp;&nbsp;<img src='/cfmx/sif/js/sothink/arrow_r.gif' border='0'>" >
			</cfif>
		</cfif>
	
		<cfif (items.profundidad gt profundidadant) >
			<cfset cantSMenu = cantSMenu + 1 >
			<cfset vMenu = cantSMenu >
			<cfset arrayappend(pila, vmenu ) >

			stm_bpx('p#vMenu#',"p#profundidadant#",<cfif items.profundidad eq 2>[]<cfelse>[1,2,0,-1]</cfif>); 
			<cfset cerrar = cerrar + 1 >
			<!--- crea entrada en vHijos para este menu --->
			<cfset structinsert(vHijos, vMenu, 1) >
			stm_aix('p#vMenu#i0',"p#vMenu-1#i0",[1,"#HTMLEditFormat(traducir[items.item])##imagen#","","",-1,-1,0,"<cfif len(trim(items.SPcodigo))>/cfmx/home/menu/portal.cfm?_nav=1&amp;i=#items.item#<cfelse>##</cfif>","_self","","","","",0,0,0,"#img_sampleredarrow#","#img_sampleredarrow#"]);

		<cfelseif items.profundidad lt profundidadant >
			<cfset cerrar = cerrar - 1 >
			<cfloop from="1" to="#profundidadant-items.profundidad#" index="i">
				stm_ep();
				<cfset cerrar = cerrar - 1 >
				<!--- saca de menues de la pila --->
				<cfif arraylen(pila) gt 0 >
					<cfset arraydeleteat(pila, arraylen(pila) ) >
				</cfif>
			</cfloop>
			<cfif cerrar lt 0 ><cfset cerrar = 0 ></cfif>
			<!--- asigna el ultimo elemento de la pila, el menu vigente --->
			<cfset vMenu = pila[arraylen(pila)]  >
			<cfset vHijos[vMenu] = vHijos[vMenu]+1  >
			<cfset indice = vHijos[vMenu] >
			<cfif items.profundidad eq 1>
				stm_aix("p#vMenu#i#indice#","p#vMenu-1#i0",[1,"<strong>#HTMLEditFormat(traducir[items.item])#</strong>","","",-1,-1,0,"<cfif len(trim(items.SPcodigo))>/cfmx/home/menu/portal.cfm?_nav=1&amp;i=#items.item#<cfelse>##</cfif>","_self","","","","",0,0,0,"#img_sampleredarrow#","#img_sampleredarrow#",13,8,0,0]);
			<cfelse>
				stm_aix("p#vMenu#i#indice#","p#vMenu-1#i0",[1,"#HTMLEditFormat(traducir[items.item])##imagen#","","",-1,-1,0,"<cfif len(trim(items.SPcodigo))>/cfmx/home/menu/portal.cfm?_nav=1&amp;i=#items.item#<cfelse>##</cfif>","_self","","","","",13,8,"#img_sampleredarrow#","#img_sampleredarrow#"]);
			</cfif>
		<cfelse>
			<!--- asigna el ultimo elemento de la pila, el menu vigente --->
			<cfset vMenu = pila[arraylen(pila)]  >
			<cfset vHijos[vMenu] = vHijos[vMenu]+1  >
			<cfset indice = vHijos[vMenu] >
			<cfif items.profundidad eq 1>
				stm_aix("p#vMenu#i#indice#","p#vMenu-1#i0",[1,"<strong>#HTMLEditFormat(traducir[items.item])#</strong>","","",-1,-1,0,"<cfif len(trim(items.SPcodigo))>/cfmx/home/menu/portal.cfm?_nav=1&amp;i=#items.item#<cfelse>##</cfif>","_self","","","","",0,0,0,"#img_sampleredarrow#","#img_sampleredarrow#",13,8,0,0]);
			<cfelse>
				stm_aix("p#vMenu#i#indice#","p#vMenu-1#i0",[1,"#HTMLEditFormat(traducir[items.item])##imagen#","","",-1,-1,0,"<cfif len(trim(items.SPcodigo))>/cfmx/home/menu/portal.cfm?_nav=1&amp;i=#items.item#<cfelse>##</cfif>","_self","","","","",13,8,"#img_sampleredarrow#","#img_sampleredarrow#"]);
			</cfif>
		</cfif>
		<cfset profundidadant = items.profundidad >
	</cfif>
	</cfloop>
	<cfloop from="1" to="#cerrar#" index="i">
		stm_ep();
	</cfloop>
	stm_em();
</cfsavecontent>
<script type="text/javascript" language="JavaScript1.2">#menu#</script>

	</td>
	<td>
		<script type="text/javascript" language="JavaScript1.2">
		<!--
		stm_bm(["menu7c2d",430,"","#img_blank#",0,"","",0,3,150,250,150,1,1,0,"","100%",0],this);
		stm_sc(1,["transparent","transparent","","",3,3,0,0,"#MouseOut_AutoScroll#","##000000","#img_updisabled#","#img_upenabled#",7,9,0,"#img_downdisabled#","#img_downenabled#",7,9,0]);
		stm_bp("p0",[0,4,0,0,1,3,13,13,100,"",-2,"",-2,90,0,0,"##7F7F7F","#Menu_Background#","",3,0,0,"#Border_PopUpMenu#"]);
		stm_ai("p0i0",[1,"<strong>Compa&ntilde;&iacute;a:&nbsp;#session.Enombre#</strong>&nbsp;","","",-1,-1,0,"","_self","","","","",0,0,0,"#img_sampleredarrow#","#img_sampleredarrow#",13,8,0,0,1,"##FFFFFF",1,"##FFFFFF",1,"","",3,3,0,0,"##FFFFFF","##FFFFFF","##FFFFFF","#MouseOver_MenuItem#","#FontOver#","#FontOut#",0,0]);
		stm_bpx("p1","p0",[1,4,0,0,0,3,0,0,83,"",-2,"",-2,58,0,0,"##7F7F7F","##FFFFFF","",3,1,1]);
		<cfloop query="rsEmpresas">
			<cfif isdefined("session.origen") and listcontains(session.origen, 'sistema') >
				<cfset uri = '/cfmx/home/menu/index.cfm?_nav=1&amp;seleccionar_EcodigoSDC=#rsEmpresas.Ecodigo#' >
			<cfelse>
				<cfset uri = '/cfmx/home/menu/portal.cfm?_nav=1&root=1&amp;seleccionar_EcodigoSDC=#rsEmpresas.Ecodigo#' >
			</cfif>
			stm_aix("p1i#rsEmpresas.currentrow#","p0i0",[1,"<cfif rsEmpresas.Ecodigo is session.EcodigoSDC><strong>&gt;</cfif>#rsEmpresas.Enombre#<cfif rsEmpresas.Ecodigo is session.EcodigoSDC>&lt;</strong></cfif>","","",-1,-1,0,"#uri#","_self","","","","",0,0,0,"","",0,0,0,0,1,"#Submenu_Background#",0,"#MouseOver_MenuItem#",0,"","",3,3,0,0,"#Submenu_ColorLetra#","#Submenu_ColorLetra#","#Submenu_ColorLetra#","#Submenu_ColorLetra#"]);	
		</cfloop>
		stm_ai("p1i4",[6,1,"##000000","",0,0,0]);
		stm_aix("p1i2","p0i0",[1,"Seleccionar Rol","","",-1,-1,0,"javascript:sbSeleccionarRol()","_self","","","","",0,0,0,"","",0,0,0,0,1,"#Submenu_Background#",0,"#MouseOver_MenuItem#",0,"","",3,3,0,0,"##000000","##000000","##000000","##000000"]);
		stm_ep();
		stm_em();
		//-->
		</script>
	</td>
</tr>
</table>

<!---
<cfset xfin = now() >
#xfin#<br>
<cfset xtmp = datediff('s', xinicio, xfin ) >
menu: #xtmp# seg.
--->

</cfoutput>
<iframe width="1" height="1" id="menu_action" name="menu_action" frameborder="0" style="width:1px;height:1px;display:none;visibility:hidden"></iframe>