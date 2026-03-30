<cfif isdefined("request.tabChoice")>
	<cfdump var="#request.tabChoice#">
</cfif>

<cf_templateheader title="Compras">
		<cfinclude template="../portlets/pNavegacion.cfm">
		
		<cfsavecontent variable="m1">
			<cfinclude template="MIV-OpcionesGEN.cfm">
		</cfsavecontent>
		<cfsavecontent variable="m2">
			<cfinclude template="MIV-OpcionesOTR.cfm">
		</cfsavecontent>

		<cfset tabChoice = 1>
		
		<cfif isdefined("url.o") and len(trim(url.o))>
			<cfset tabChoice = url.o >
		<cfelse>
			<cfset m1List = "">
			<cfloop from="1" to="#ArrayLen(menu1)#" index="i">
				<cfset m1List = ListAppend(m1List, menu1[i].uri, '!')>
			</cfloop>
			<cfset m2List = "">
			<cfloop from="1" to="#ArrayLen(menu2)#" index="i">
				<cfset m2List = ListAppend(m2List, menu2[i].uri, '!')>
			</cfloop>

			<cfif isdefined("cgi.HTTP_REFERER") and Len(Trim(cgi.HTTP_REFERER))>
				<cfif FindNoCase('/sif', cgi.HTTP_REFERER) GT 0>
					<cfif ListFindNoCase(m1List, Mid(cgi.HTTP_REFERER, FindNoCase('/sif', cgi.HTTP_REFERER), Len(cgi.HTTP_REFERER)), '!')>
						<cfset tabChoice = 1>
						<cfset Request.tabChoice = 1>
					<cfelseif ListFindNoCase(m2List, Mid(cgi.HTTP_REFERER, FindNoCase('/sif', cgi.HTTP_REFERER), Len(cgi.HTTP_REFERER)), '!')>
						<cfset tabChoice = 2>
						<cfset Request.tabChoice = 2>
					</cfif>
				<cfelse>
					<cfset tabChoice = 1>
					<cfset Request.tabChoice = 1>
				</cfif>
			<cfelse>
				<cfset tabChoice = 1>
				<cfset Request.tabChoice = 1>
			</cfif>
		</cfif>

		<!--- ======================== --->
		<!--- Nombres de los TABS--->
		<!--- ======================== --->
		<cfset tabNames = ArrayNew(1)>
		<cfset tabNames[1] = "Operaci&oacute;n">
		<cfset tabNames[2] = "Producci&oacute;n">
		
		<cfset tabLinks = ArrayNew(1)>
		<cfset tabLinks[1] = "MenuCM_2.cfm?o=1">
		<cfset tabLinks[2] = "MenuCM_2.cfm?o=4">
		
		<cfset tabStatusText = ArrayNew(1)>
		<cfset tabStatusText[1] = "1">
		<cfset tabStatusText[2] = "2">

		<!--- ======================== --->
		<!--- Pinta los TABS--->
		<!--- ======================== --->
		<br>
		<table align="center" border="0" cellspacing="0" cellpadding="5" width="99%" style="vertical-align:top; ">
			<tr>
			  <cfloop index="i" from="1" to="#ArrayLen(tabNames)#">
				<cfoutput>
				  <td id="td_#i#" class="<cfif tabChoice eq i>#Session.Preferences.Skin#_tabsel<cfelse>#Session.Preferences.Skin#_tabnorm</cfif>" nowrap>
						<cfif tabLinks[i] neq "">
							<a href="javascript: opciones(#i#,'#tabLinks[i]#',#ArrayLen(tabNames)#);" onMouseOver="javascript: window.status='#tabStatusText[i]#'; return true;" onMouseOut="javascript: window.status=''; return true;" tabindex="-1">
						</cfif>
						#tabNames[i]#
						<cfif tabLinks[i] neq "">
							</a>
						</cfif>
				  </td>
				</cfoutput>
			  </cfloop>
			  <td width="100%" style="border-bottom: 1px solid black;">&nbsp;</td>
			</tr>
			
			<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">
			<tr>
				<td colspan="5" valign="top">
					<table width="100%" cellpadding="0" cellspacing="0" style="vertical-align:top; ">
						<tr>
							<td valign="top">
								<div id="opcion1" <cfif tabChoice neq 1>style="display:none; vertical-align:top"</cfif>>
									<cfoutput>#m1#</cfoutput>
								</div>

								<div id="opcion2" <cfif tabChoice neq 2>style="display:none; vertical-align:top"</cfif>>
									<cfoutput>#m2#</cfoutput>
								</div>
							</td>
							<td valign="top" align="center" width="25%">
								<table width="95%"  border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td>&nbsp;</td>
									</tr>
									<tr>
										<td><cfinclude template="MenuCatalogosIV2.cfm"></td>
									</tr>
									<tr>
										<td>&nbsp;</td>
									</tr>
									<tr>
										<td><cfinclude template="MenuConsultasIV2.cfm"></td>
									</tr>
									<tr>
										<td>&nbsp;</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			
		</table>
		
		<!--- ======================================== --->
		<!--- HACE LA REDIRECCION AL TAB SELECCIONADO  --->
		<!--- ======================================== --->
		<script language="JavaScript" type="text/javascript">

			function getCookie(name) { // use: getCookie("name");
				var re = new RegExp(name + "=([^;]+)");
				var value = re.exec(window.document.cookie);
				return (value != null) ? unescape(value[1]) : null;
			}
			
			function setCookie(name, value) { // use: setCookie("name", value);
				var today = new Date();
				var expiry = new Date(today.getTime() + 0.167 * 24 * 60 * 60 * 1000); // plus 1/6 day: el cookie dura como 4 horas
				document.cookie=name + "=" + escape(value) + "; expires=" + expiry.toGMTString();
			}

			function opciones(seleccion,liga,cantidad){
				var noSeleccionada = '<cfoutput>#Session.Preferences.Skin#_tabnorm</cfoutput>';
				var seleccionada = '<cfoutput>#Session.Preferences.Skin#_tabsel</cfoutput>';
				
				setCookie('tabIV',seleccion);

				for ( var i=1; i<=cantidad; i++  ){
					if (seleccion==i){
						document.getElementById("td_"+i).className = seleccionada;
						document.getElementById("opcion"+i).style.display = '';
					}
					else{
						document.getElementById("td_"+i).className = noSeleccionada;
						document.getElementById("opcion"+i).style.display = 'none';
					}
				}
			}
			
			var valorCookie = getCookie('tabIV');

			// esta preguntando por los valores 1,2 porque no pude hacer que preguntra por el valor null!!
			// esto significa qe si se agrega un tab mas, tambien hay que agregar la parte del if aqui...
			// si alguien sabe como hacer que compare contra null, cambie esto para que no quede tan tieso!
			if ( (valorCookie == 1) || (valorCookie == 2) ){
				opciones(valorCookie,'',<cfoutput>#ArrayLen(tabNames)#</cfoutput>);
			}
			
		</script>
	<cf_templatefooter>
