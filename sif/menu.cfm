<!---
<script type="text/javascript" language="JavaScript" src="/cfmx/sif/js/DHTMLMenu/stm31.js"></script>

<cfset jsproot="/jsp">

<cfquery datasource="asp" name="rsmenu">
	select distinct c.SMcodigo as STcodigo, 
		   c.SMdescripcion as STdescripcion,
		   c.SMcodigo as SMcodigo, 
		   'C' as Stipo, 
		   c.SMdescripcion as SMdescripcion , 
		   d.SPcodigo as Sproceso, 
		   d.SPdescripcion as Snombre, 
		   d.SPhomeuri as Suri, a.SScodigo
	from vUsuarioProcesos a, SSistemas b, SModulos c, SProcesos d
	where a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
	and b.SSmenu = 1 
	and c.SMmenu = 1 
    and d.SPmenu = 1 
	and a.SScodigo = b.SScodigo
	and a.SScodigo = c.SScodigo
	and a.SMcodigo = c.SMcodigo
	and a.SScodigo = d.SScodigo
	and a.SMcodigo = d.SMcodigo
	and a.SPcodigo = d.SPcodigo
	order by a.SScodigo, c.SMcodigo
</cfquery>	

<!--- <link href="/cfmx/sif/css/menu.css" rel="stylesheet" type="text/css"> --->
<cf_web_portlet Titulo="&nbsp;" skin="#Session.Preferences.SkinMenu#" border="true">
		<!---<table width="80%" height="100%" border="0" cellpadding="0" cellspacing="0">--->
		<table border="0" cellpadding="0" cellspacing="0">

			<tr> 
			  <td colspan="2" valign="top"></td>
			</tr>
			<tr > 
			  <td colspan="2"></td>
			</tr>

			<tr> 
			  <td width="1%" ><!---<img src="/cfmx/sif/imagenes/logoizq.gif" alt="Servicios Digitales al ciudadano" width="16" height="254" align="middle" />---></td>

			  <td width="99%" align="center">
				<script language="JavaScript1.2" type="text/javascript">
					<!--- Separa el texto para un menu principal en dos lineas si es muy largo --->
					function mtext(text) {
						if (text.length < 10) return text;
						var sp = text.indexOf(9," ");
						if (sp==-1) sp = text.indexOf(" ");
						if (sp==-1) return text;
						if (sp==-1) sp = text.length / 2;
						return text.substring(0,sp) + "<br>" + text.substring(sp+1);
					}
					<!--- Genera una opcion de menu con un uri de JSP --->
					function menu_item_uri(text,uri,padre,hijo) {
						flecha="";
						if (uri != null && uri != "" && uri.substring(0,1) != '/') {
							uri = "/" + uri;
						}
						if (uri==null || uri=="")
							flecha="arrow_r.gif"
						stm_ai(padre,[0,text,"","",-1,-1,0,uri,"_self",uri,"","","",10,0,0,flecha,flecha,-1,-1,0,0,1,"#ffffff",0,"#E4EAF4",0,"","",3,3,0,0,"#000000","#000000","#000000","#000000","8pt Tahoma, Verdana, Helvetica, Sans-Serif;","8pt Tahoma, Verdana, Helvetica, Sans-Serif;",0,0]);
					}
					<!--- Genera una opcion de menu con un modulo de PowerDynamo --->
					function menu_item_db (text,tipo,modulo,uri,padre)
					{
						if (tipo == 'D') {
							menu_item_uri (text, "<cfoutput>#jsproot#/sdc/p/dynamo.jsp?modulo=" + modulo<cfif isdefined('Session.sess_pk')>+"&sess_pk=#Session.sess_pk#"</cfif>,padre</cfoutput>);
						} else if (tipo == 'C') {
							menu_item_uri (text, "/cfmx" + uri,padre);
						} else { // tipo == 'J'
							<cfoutput>
							menu_item_uri (text, "#jsproot#" + uri,padre);
							</cfoutput>
						}
					}

					<!--- Generacion del menu --->
					stm_bm(["menu1032804911",310,"/cfmx/sif/js/DHTMLMenu/","blank.gif",0,"","",0,0,250,0,1000,1,0,0]);
					stm_bp("p0",[0,4,0,0,2,1,10,7,100,"",-2,"",-2,90,0,0,"#000000","#ffffff","",3,1,0,"#003300 #ffffff #003300 #003300"]);
				

					<cfoutput>
						menu_item_uri("Inicio", "/cfmx/sif/index.cfm","p0i0");
					</cfoutput>
					<!--- Elementos del menu segun los roles del usuario --->
					stm_ai("p0i0",[6,1,"#000000","",-1,-1,0]);					
				
					<cfset uSTcodigo=-1>

					// ***
					<cfoutput query="rsmenu">
						<cfif #uSTcodigo# NEQ #STcodigo# >
							<cfif #uSTcodigo# NEQ -1>
								stm_ep();
							</cfif>
							menu_item_uri(mtext("#STdescripcion#"),"","p0");
							stm_bp("p#rsmenu.CurrentRow#",[1,4,0,0,2,2,0,0,100,"",-2,"",-2,90,0,0,"##000000","##ffffff","",3,1,1,"##003300"]);
							<cfset uSTcodigo=STcodigo>
						</cfif>
						menu_item_db("#Snombre#", "#Stipo#", "#Sproceso#", "#Suri#","p0");
					</cfoutput>

					<cfif #uSTcodigo# NEQ -1>
						stm_ep();
					</cfif>

					<!--- Elementos generales del menu (utilitarios) --->
					stm_ai("p0i0",[6,1,"#000000","",-1,-1,0]);					
					<cfoutput>
						menu_item_uri("Cambiar<br> contrase&ntilde;a", "/cfmx/home/menu/passch.cfm","p0");

						/*
						menu_item_uri("Agenda", "#jsproot#/sdc/org/agenda/","p0");
						menu_item_uri("Directorio", "#jsproot#/sdc/org/dir/","p0");
						menu_item_uri("Tareas", "#jsproot#/sdc/org/cosas/","p0");
						menu_item_uri("Buz&oacute;n", "#jsproot#/sdc/org/buzon/","p0");
						menu_item_uri("Canales", "#jsproot#/sdc/org/cfg/Canales.jsp","p0");
						menu_item_db("Compras",  "D", "W06","p0");
						menu_item_db("Anuncios", "D", "W08","p0");
						menu_item_db("Foros",    "D", "W10","p0");
						menu_item_db("Cont&aacute;ctenos", "D", "W12","p0");
						*/

					</cfoutput>
					stm_ai("p0i0",[6,1,"#000000","",-1,-1,0]);					
					<cfoutput>
						menu_item_uri("Salir", "/cfmx/home/public/logout.cfm","p0");
					</cfoutput>
					stm_ep();
					stm_em();
				</script> 
			  </td>

			</tr>

			<tr> 
			  <td colspan="2"></td>
			</tr>
			<tr> 
			  <td colspan="2" valign="top"></td>
			</tr>

</table>
</cf_web_portlet>
--->