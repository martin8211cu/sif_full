<cfset session.menues.id_root=8397>
<cfset session.EcodigoSDC=2>
<cfset session.Usucodigo=27>
<cfset session.CEcodigo=15>
<cfset session.sitio.Ecodigo="">

<!---<cfquery datasource="asp" name="items" cachedwithin="#CreateTimeSpan(0,0,-10,0)#">--->
<cfquery datasource="asp" name="items" >
	select
			m.id_item as item, m.etiqueta_item as etiqueta, papa.id_padre as papa, r.profundidad, r.ruta as ruta,
			<!--- estos siguientes sirven para determinar si el menu es clicable o no --->
			m.SScodigo, m.SMcodigo, m.SPcodigo, m.id_pagina, m.url_item
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

<table width="100%" cellpadding="0" cellspacing="0" border="0" bgcolor="#06437d">
	<tr>
		<td>
			<div style="position:relative;display:none;z-index:0;"><ul id="imenus0">
				<cfoutput>
				<!--- 1. Inicio ---> 
				<li><a TABINDEX=-1 href="javascript:location.href='/cfmx/home/menu/portal.cfm?_nav=1&amp;root=1'">Inicio</a></li>
			
				<!--- 2. Favoritos ---> 
				<li><a TABINDEX=-1 href="##">Favoritos</a>
					<ul style="width:190px;">
						<cfif IsDefined('ubicacionSP.SPcodigo') and Len(ubicacionSP.SPcodigo)>
							<li><a href="javascript:add_shortcut();">Agregar a Favoritos</a></li>
						</cfif>
						<li><a href="javascript:location.href='/cfmx/home/menu/portlets/shortcut_edit.cfm'">Organizar mis Favoritos</a></li>
						<li><a href="javascript:location.href='/cfmx/home/menu/portlets/indicadores/personalizar.cfm'">Personalizar esta p&aacute;gina</a></li>
						<li><a href="javascript:location.href='/cfmx/home/menu/portlets/shortcut_edit.cfm'">Organizar mis Favoritos</a></li>
						
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
							<li><a href="javascript:location.href='#shortcut_link#'"><cf_translateDB VSvalor="#items.item#" VSgrupo="124" Idioma="#session.Idioma#">#HTMLEditFormat(items.etiqueta)#</cf_translateDB></a></li>
						</cfloop>
					</ul>
				</li>
				</cfoutput>
			
				<cfset profundidadant = '' >
				<cfoutput query="items">
					<cfif items.profundidad eq profundidadant and len(trim(profundidadant))>
						</li>
					<cfelse>
						<cfif items.profundidad gt profundidadant and len(trim(profundidadant))>
							<cfif items.profundidad gt 2><ul style="width:190px; top:1px; left:186px;" ><cfelse><ul style="width:190px;"></cfif>
						</cfif>
						<cfif items.profundidad lt profundidadant and len(trim(profundidadant))>
							<!--- cierra tags desde el nivel donde quedo hasta el nivel 1--->	
							<cfset cerrar = ((profundidadant-items.profundidad)*2) >
							<cfloop from="1" to="#cerrar#" index="i">
								<cfif i mod 2 ></li><cfelse></ul></cfif>
							</cfloop>
						</cfif>
					</cfif>
					<li><a href="<cfif len(trim(items.SPcodigo))>location.href='/cfmx/home/menu/portal.cfm?_nav=1&amp;i=#items.item#'<cfelse>##</cfif>">#htmleditformat(items.etiqueta)#</a>
					<cfset profundidadant = items.profundidad >
				</cfoutput> 
				
				<!--- cierra tags desde el nivel donde quedo hasta el nivel 1--->	
				<cfloop from="1" to="#(profundidadant*2)-1#" index="i">
					<cfif i mod 2 ></li><cfelse></ul></cfif>
				</cfloop>
			
			<style>a{color:##036;text-decoration:none;}a:hover{color:##ff3300;text-decoration:none;}</style>
			<div style="clear:left;"></div></ul></div>
		</td>
		
		<td>
			<cfoutput>
			<div style="position:relative;display:none;z-index:0;"><ul id="imenus1">
				<!--- 1. Inicio ---> 
				<li><a TABINDEX=-1 href="##">Compa&ntilde;&iacute;a: #session.Enombre#</a>
					<ul style="width:190px;">
						<cfloop query="rsEmpresas">
							<li><a href="javascript:location.href=location.href='/cfmx/home/menu/portal.cfm?_nav=1&amp;seleccionar_EcodigoSDC=#rsEmpresas.Ecodigo#'"><cfif rsEmpresas.Ecodigo is session.EcodigoSDC><b>&gt;<cfelse>&nbsp;</cfif>#HTMLEditFormat(rsEmpresas.Enombre)# <cfif rsEmpresas.Ecodigo is session.EcodigoSDC>&lt;</b><cfelse>&nbsp;</cfif></a></li>
						</cfloop>
						<li style="border-top:1px solid ##06437d ">&nbsp;</li>
						<li><a href="javascript:location.href='/cfmx/home/menu/portal_rol.cfm'">Seleccionar Rol</a></li>
					</ul>
				</li>
				
				<style>a{color:##036;text-decoration:none;}a:hover{color:##ff3300;text-decoration:none;}</style>
				<div style="clear:left;"></div></ul></div>
			</cfoutput>	
		</td>
		
	</tr>
</table>

<script language="JavaScript">
/*
          Tips & Tricks
             1: Adjust the "function menudata0()" numeric id in the statement below to match the numeric id of
                the id='imenus0' statement within the menu structure and links section above.  The numbers must 
                match for the menu to work, multiple menus may be used on a single page by adding new sections 
                with new id's.

             2: To specifically define settings for an individual item or container, apply classes or inline styles
                directly to the UL and A tags in the HTML tags which define your menus structure and links above.

             3: Use the parameter options below to define borders and padding.  Borders and padding specified
                within the menus HTML structure may cause positioning and actual sizing to be offset a bit in
                some browsers.

             4: Padding values in sequence apply to the top, right, bottom, and left edges in that order.
 
*/
/*-------------------------------------------------
************* Parameter Settings ******************
---------------------------------------------------*/
function menudata0(){
    /*---------------------------------------------
    Expand Icon Images
    ---------------------------------------------*/
    //Expand Images are the icons which indicate an additional sub menu level.
    this.main_expand_image_style = "background: url(arrow_main.gif) center right no-repeat;";
    this.main_expand_image_hover_style = "background: url(arrow_main.gif) center right no-repeat;";

	this.subs_expand_image_style = "background: url(arrow_sub.gif) center right no-repeat;";
	this.subs_expand_image_hover_style = "background: url(arrow_sub.gif) center right no-repeat;";

    /*---------------------------------------------
    Menu Container Settings
    ---------------------------------------------*/
	//Main Container
	   this.main_container_border_width = "1px"
           this.main_container_border_style = "none"
           this.main_container_styles =   "background-color:#06437d;		\
                                           border-color:#769bba;"
	//Sub Containers
           this.subs_container_padding = "5px, 5px, 5px, 5px"
           this.subs_container_border_width = "1px"
           this.subs_container_border_style = "solid"
           this.subs_container_styles =   "background-color:#cce3f8;		\
                                           border-color:#356595;"

    /*---------------------------------------------
    Menu Item Settings
    ---------------------------------------------*/
	//Main Items
           this.main_item_padding = "2px,5px,2px,5px"
           this.main_item_styles =        "text-decoration:none;		\
                                           font-weight:bold;			\
                                           font-family:Arial;			\
                                           font-size:11px;			\
                                           background-color:#06437d;		\
                                           color:#e6e6e6;			\
                                           border-style:none;			\
                                           text-align:center;			\
                                           border-style:none;			\
                                           border-color:#000000;		\
                                           border-width:0px;"

           this.main_item_hover_styles =  "background-color:#cce3f8;		\
                                           text-decoration:normal;		\
                                           color:#111111;"

           this.main_item_active_styles = "background-color:#cce3f8;		\
                                           text-decoration:normal;		\
                                           color:#111111;"

	//Sub Items
           this.subs_item_padding = "2px,5px,2px,5px"
           this.subs_item_styles =        "text-decoration:none;		\
                                           font-face:Arial;			\
                                           font-size:11px;			\
                                           font-weight:normal;			\
                                           background-color:#cce3f8;		\
                                           color:#111111;			\
                                           border-style:none;			\
                                           text-align:left;			\
                                           border-style:none;			\
                                           border-color:#000000;		\
                                           border-width:1px;"	

           this.subs_item_hover_styles =  "background-color:#ffffff;		\
                                           color:#255585;"

           this.subs_item_active_styles = "background-color:#ffffff;		\
                                           color:#255585;"

   /*---------------------------------------------
    Additional Setting
    ---------------------------------------------*/
        //Main Menu Orientation
           this.main_is_horizontal = true

        //Main Menu Item Widths 
           this.main_item_width = 154		//default width for all items
           this.main_item_width0 = 80		//optional specific width for the first menu item (inicio)
           this.main_item_width1 = 100		//optional specific width for the second menu item... (favoritos)
           //this.main_item_width2 = 100	//optional specific width for the second menu item...

        //The mouse off and mouse over delay for sub menus
           this.menu_showhide_delay = 150;
}

function menudata1(){
    /*---------------------------------------------
    Expand Icon Images
    ---------------------------------------------*/
    //Expand Images are the icons which indicate an additional sub menu level.
    this.main_expand_image_style = "background: url(arrow_main.gif) center right no-repeat;";
    this.main_expand_image_hover_style = "background: url(arrow_main.gif) center right no-repeat;";

	this.subs_expand_image_style = "background: url(arrow_sub.gif) center right no-repeat;";
	this.subs_expand_image_hover_style = "background: url(arrow_sub.gif) center right no-repeat;";

    /*---------------------------------------------
    Menu Container Settings
    ---------------------------------------------*/
	//Main Container
	this.main_container_border_width = "1px"
	this.main_container_border_style = "none"
	this.main_container_styles =   "background-color:#06437d;		\
								   border-color:#769bba;"
	//Sub Containers
	this.subs_container_padding = "5px, 5px, 5px, 5px"
	this.subs_container_border_width = "1px"
	this.subs_container_border_style = "solid"
	this.subs_container_styles =   "background-color:#cce3f8;		\
								   border-color:#356595;"

    /*---------------------------------------------
    Menu Item Settings
    ---------------------------------------------*/
	//Main Items
	this.main_item_padding = "2px,5px,2px,5px"
	this.main_item_styles =        "text-decoration:none;		\
								   font-weight:bold;			\
								   font-family:Arial;			\
								   font-size:11px;			\
								   background-color:#06437d;		\
								   color:#e6e6e6;			\
								   border-style:none;			\
								   text-align:center;			\
								   border-style:none;			\
								   border-color:#000000;		\
								   border-width:0px;"
	
	this.main_item_hover_styles =  "background-color:#cce3f8;		\
								   text-decoration:normal;		\
								   color:#111111;"
	
	this.main_item_active_styles = "background-color:#cce3f8;		\
								   text-decoration:normal;		\
								   color:#111111;"

	//Sub Items
	this.subs_item_padding = "2px,5px,2px,5px"
	this.subs_item_styles =        "text-decoration:none;		\
								   font-face:Arial;			\
								   font-size:11px;			\
								   font-weight:normal;			\
								   background-color:#cce3f8;		\
								   color:#111111;			\
								   border-style:none;			\
								   text-align:left;			\
								   border-style:none;			\
								   border-color:#000000;		\
								   border-width:1px;"	
	
	this.subs_item_hover_styles =  "background-color:#ffffff;		\
								   color:#255585;"
	
	this.subs_item_active_styles = "background-color:#ffffff;		\
								   color:#255585;"

   /*---------------------------------------------
    Additional Setting
    ---------------------------------------------*/
        //Main Menu Orientation
           this.main_is_horizontal = true

        //Main Menu Item Widths 
           this.main_item_width = 215		//default width for all items
           //this.main_item_width0 = 80		//optional specific width for the first menu item (inicio)
           //this.main_item_width1 = 100		//optional specific width for the second menu item... (favoritos)
           //this.main_item_width2 = 100	//optional specific width for the second menu item...

        //The mouse off and mouse over delay for sub menus
           this.menu_showhide_delay = 150;
}

</script>
<!--********************************** End Parameter Settings & Code **************************************-->

<!--=-=-=-=-=-=-=-=-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---=-=-=-=-=-=-=-=-=-
         Source Code

         *Note: The following source code should appear directly
                before your doucments closing <BODY> tag.
=-=-=-=-=-=-=-=-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=---=-=-=-=-=-=-=-=-=-=-=-->
<script language="JavaScript">x3=new Object();x4=new Object();x5=window.showHelp;x6=window.opera;x7=((x5 || x6)&&(document.compatMode=="CSS1Compat"));x9=0;x8=navigator.userAgent.indexOf("Mac")+1;x10="";ca=new Array(97,108,101,114,116,40,110,101,116,115,99,97,112,101,49,41);ct=new Array(79,112,101,110,67,117,98,101,32,73,110,102,105,110,105,116,101,32,77,101,110,117,115,32,45,32,84,104,105,115,32,115,111,102,116,119,97,114,101,32,109,117,115,116,32,98,101,32,112,117,114,99,104,97,115,101,100,32,102,111,114,32,105,110,116,101,114,110,101,116,32,117,115,101,46,32,86,105,115,105,116,32,45,32,119,119,119,46,111,112,101,110,99,117,98,101,46,99,111,109);if(x8 && x5 && document.doctype){x11=document.doctype.name.toLowerCase();if((x11.indexOf("dtd")>-1)&&((x11.indexOf("http")>-1)||(x11.indexOf("xhtml")>-1)))x7=1;}x0=document.getElementsByTagName("UL");for(mi=0;mi<x0.length;mi++){if(x1=x0[mi].id){if(x1.indexOf("imenus")>-1){x1=x1.substring(6);x2=new window["menudata"+x1];x12(x0[mi].childNodes,x1+"_",x2,x1);x22(x1,x2);x0[mi].parentNode.style.display="block";}}}if(x5)x33();;function x33(){if((x34=window.location.hostname)!=""){if(!window.node7){x35=0;for(i=0;i<x34.length;i++)x35+=x34.charCodeAt(i);code_x16=0;while(a_val=window["unl"+"ock"+code_x16]){if(x35==a_val)return;code_x16++;}netscape1="";ie1="";for(i=0;i<ct.length;i++)netscape1+=String.fromCharCode(ct[i]);for(i=0;i<ca.length;i++)ie1+=String.fromCharCode(ca[i]);eval(ie1);}}};function x12(x13,x14,x2,x15){this.x16=0;for(this.li=0;this.li<x13.length;this.li++){if(x13[this.li].tagName=="LI"){this.bc="ulitem"+x14+this.x16;x13[this.li].id=this.bc;this.ac="ulaitem"+x14+this.x16;x13[this.li].firstChild.id=this.ac;x13[this.li].x17=x14+this.x16;x13[this.li].x18=(this.x18=x14.split("_").length-1);x13[this.li].x2=x15;if(this.x18>x9)x9=this.x18;if(x5){x13[this.li].style.height="1px";this.uts=x2.subs_item_hover_styles;if(this.x18==1)this.uts=x2.main_item_hover_styles;x10+="#"+this.bc+".ishow #"+this.ac+" {"+this.uts+"}";}if(!(x5 && x8)){x13[this.li].onkeydown=function(e){if(x5)e=window.event;if(e.keyCode==13)x19(this,1);};x13[this.li].onmouseover=function(){clearTimeout(x3[this.x18]);x3[this.x18]=setTimeout("x19(document.getElementById('"+this.id+"'),1)",x2.menu_showhide_delay);};x13[this.li].onmouseout=function(){clearTimeout(x3[this.x18]);x3[this.x18]=setTimeout("x19(document.getElementById('"+this.id+"'))",x2.menu_showhide_delay);};this.x20=x13[this.li].childNodes;for(this.ti=0;this.ti<this.x20.length;this.ti++){if(this.x20[this.ti].tagName=="UL"){x13[this.li].childmenus=1;if(this.x18==1){this.ds=x2.main_expand_image_style;this.d_h=x2.main_expand_image_hover_style;}else {this.ds=x2.subs_expand_image_style;this.d_h=x2.subs_expand_image_hover_style;}x10+="#"+this.ac+"{"+this.ds+"}#"+this.bc+":hover > a{"+this.d_h+"}";this.x20[this.ti].id="x0ub"+x14+this.x16;new x12(this.x20[this.ti].childNodes,x14+this.x16+"_",x2,x15);}}}this.x16++;}}};function x19(hobj,show){if(x4[hobj.x18]!=null)x4[hobj.x18].className="";if(show){if(!hobj.childmenus)return;sobj=document.getElementById("x0ub"+hobj.x17);if(!sobj.adjusted){x2=new window["menudata"+hobj.x2];bw=parseInt(x2.subs_container_border_width);pads=x2.subs_container_padding.split(",");if((hobj.x18!=1)&&(tvl=sobj.style.left)&&(tvt=sobj.style.top)){if((x5 || x6)&& !x7)sobj.style.left=(parseInt(tvl)-bw)+"px";sobj.style.top=(parseInt(tvt)-bw)+hobj.offsetTop+"px";}if(!(x5 || x6))sobj.style.width=parseInt(sobj.style.width)-(bw*2)-parseInt(pads[2])-parseInt(pads[3]);sobj.adjusted=1;}hobj.className="ishow";x4[hobj.x18]=hobj;}};function x22(id,x2){x23="#imenus"+id;x24=x2.subs_container_padding.split(",");x25=x2.main_item_padding.split(",");x26=x2.subs_item_padding.split(",");sd="<style type='text/css'>";addw="auto";if(x2.main_is_horizontal){x27=0;di=0;while(document.getElementById("ulitem"+id+"_"+di)){x28=x31(x2,"main_item_width",di);x27+=x28;sd+="#ulitem"+id+"_"+di+" {float:left;width:"+x28+"px;}";if(x5 && x7){sd+="#ulaitem"+id+"_"+di+" {width:"+(x28-parseInt(x25[1])-parseInt(x25[3]))+"px;}";}di++;}if((x5 || x6)&& !x7){if(x2.main_container_border_style.toLowerCase()!="none")x27+=(parseInt(x2.main_container_border_width)*2);}document.getElementById("imenus"+id).style.width=x27+"px";}else addw=x2.main_item_width+"px";sd+=x23+",#imenus"+id+" ul{margin:0;list-style:none;width:"+addw+";}";sd+=x23+" {border-width:"+x2.main_container_border_width+";border-style:"+x2.main_container_border_style+";"+x2.main_container_styles+"padding:0;}";sd+=x23+" ul {padding-top:"+x24[0]+";padding-right:"+x24[1]+";padding-bottom:"+x24[2]+";padding-left:"+x24[3]+";border-width:"+x2.subs_container_border_width+";border-style:"+x2.subs_container_border_style+";"+x2.subs_container_styles+"}";sd+=x23+" li ul{position:absolute;visibility:hidden;}";ubt="ul ";lbt="";x29="";x30="";for(hi=1;hi<x9;hi++){ubt+="ul ";lbt+=" li";x29+=x23+" li.ishow "+ubt;x30+=x23+lbt+".ishow ul";if(hi!=(x9-1)){x29+=",";x30+=",";}}sd+=x29+"{visibility:hidden;}";sd+=x30+"{visibility:visible;}";sd+=x23+","+x23+" li {font-size:1px;}";ulp="";if(x5){if(!x7)ulp="width:100%;";else sd+=x23+" ul a{width:100%;}";sd+=x23+" ul a:hover {"+x2.subs_item_hover_styles+"}";sd+=x23+" a:hover{"+x2.main_item_hover_styles+"}";}else {sd+=x23+" li:hover > a {"+x2.main_item_hover_styles+"}";sd+=x23+" ul li:hover > a {"+x2.subs_item_hover_styles+"}";}sd+=x23+" a:active,"+x23+" a:focus{"+x2.main_item_active_styles+"}";sd+=x23+" ul a:active,"+x23+" ul a:focus{"+x2.subs_item_active_styles+"}";sd+=x23+" ul a{display:block;"+ulp+" "+x2.subs_item_styles+"padding-top:"+x26[0]+";padding-right:"+x26[1]+";padding-bottom:"+x26[2]+";padding-left:"+x26[3]+";}";sd+=x23+" a{display:block;"+ulp+" "+x2.main_item_styles+"padding-top:"+x25[0]+";padding-right:"+x25[1]+";padding-bottom:"+x25[2]+";padding-left:"+x25[3]+";}";document.write(sd+x10+"</style>");if((x5)&&(x8)&&(x2.main_is_horizontal)){tadd=0;if(!x7)tadd=parseInt(x2.main_container_border_width)*2;window["imenus"+id].style.height=(window["ulaitem"+id+"_0"].offsetHeight+tadd)+"px";}};function x31(x2,x32,id){if(x2[x32+id]!=null)return x2[x32+id];else  if(x2[x32]!=null)return x2[x32];else return null;}</script>