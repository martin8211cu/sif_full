<cfparam name="Attributes.Titulo" 			type="string"  default="">
<cfparam name="Attributes.SubTitulo" 		type="string"  default="">
<cfparam name="Attributes.showEmpresa"  	type="boolean" default="true"> 
<cfparam name="Attributes.MostrarPagina"  	type="boolean" default="false"> 
<cfparam name="Attributes.NumPagina"  	    type="string" default="1"> 
<cfparam name="Attributes.tipo"  	  		type="string" default="HTML">
<cfparam name="Attributes.Color"  	        type="string" default="E3EDEF"> 
<cfparam name="Attributes.cols"  	        type="string" default="0"> 
<cfparam name="Attributes.Conexion" 		type="String"  default="#Session.DSN#"> <!--- Nombre de la conexión --->

<!----- 20141028 fcastro, si no se selecciona un titulo especifico para el encabezado se le coloca el del proceso de ser posible--->
<cfif not len(trim(Attributes.titulo)) and isDefined("session.monitoreo.SScodigo") and isDefined("session.monitoreo.SMcodigo") and isDefined("session.monitoreo.SPcodigo")>
  <cfquery datasource="asp" name="translate_SPcodigo" maxrows="1">
    select SPdescripcion from SProcesos where SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.monitoreo.SScodigo#"> and SMcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.monitoreo.SMcodigo#"> and SPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.monitoreo.SPcodigo#">
  </cfquery>
  <cfinvoke component="sif.Componentes.TranslateDB" method="Translate" VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#" Default="#translate_SPcodigo.SPdescripcion#" VSgrupo="103" returnvariable="Attributes.titulo"/>
</cfif>

<!--- <cfsilent> --->
	<style type="text/css">
		<!--- Bordes --->
			<!--- Bordes linea  derecha , izquierda ,arriba --->
			.Lin_DER_IZQ_TOP {
				border-bottom-width: none;
				border-right-width: 1px;
				border-right-style: solid;
				border-right-color: #000000;
				border-left-width: 1px;
				border-left-style: solid;
				border-left-color: #000000;
				border-top-width: 1px;
				border-top-style: solid;
				border-top-color: #000000			
			}	
			<!--- Bordes linea  izquierda,arriba --->
			.Lin_IZQ_TOP {
				border-bottom-width: none;
				border-left-width: 1px;
				border-left-style: solid;
				border-left-color: #000000;
				border-top-width: 1px;
				border-top-style: solid;
				border-top-color: #000000			
			}
			<!--- Bordes linea  derecha,arriba --->
			.Lin_DER_TOP {
				border-bottom-width: none;
				border-bottom-width: none;
				border-right-width: 1px;
				border-right-style: solid;
				border-right-color: #000000;
				border-top-width: 1px;
				border-top-style: solid;
				border-top-color: #000000			
			}	
			<!--- Bordes linea  derecha,izquierda,arriba,abajo --->
			.Lin_DER_IZQ_TOP_BOT {
				border-bottom-width: 1px;
				border-bottom-style: solid;
				border-bottom-color: #000000;
				border-right-width: 1px;
				border-right-style: solid;
				border-right-color: #000000;
				border-left-width: 1px;
				border-left-style: solid;
				border-left-color: #000000;
				border-top-width: 1px;
				border-top-style: solid;
				border-top-color: #000000			
			}	
			<!--- Bordes linea  arriba --->
			.Lin_TOP {
					border-top-width: 1px;
					border-top-style: solid;
					border-top-color: #000000;
					border-right-style: none;
					border-bottom-style: none;
					border-left-style: none;
				}
			<!--- Bordes linea  abajo --->
			.Lin_BOT {
					border-bottom-width: 1px;
					border-bottom-style: solid;
					border-bottom-color: #000000;
					border-right-style: none;
					border-top-style: none;
					border-left-style: none;
				}
			<!--- Bordes linea  abajo,derecha --->
			.Lin_DER_BOT {
				border-top-width: none;
				border-left-width: none;
				border-right-width: 1px;
				border-right-style: solid;
				border-right-color: #000000;
				border-bottom-width: 1px;
				border-bottom-style: solid;
				border-bottom-color: #000000			
			}	
			<!--- Bordes linea  abajo,derecha,izquierda --->
			.Lin_DER_IZQ__BOT {
				border-top-width: none;
				border-left-width: 1px;
				border-left-style: solid;
				border-left-color: #000000;
				border-right-width: 1px;
				border-right-style: solid;
				border-right-color: #000000;
				border-bottom-width: 1px;
				border-bottom-style: solid;
				border-bottom-color: #000000			
			}
			<!--- Bordes linea  derecha,izquierda --->
			.Lin_DER_IZQ {
				border-top-width: none;
				border-bottom-width: none;
				border-left-width: 1px;
				border-left-style: solid;
				border-left-color: #000000;
				border-right-width: 1px;
				border-right-style: solid;
				border-right-color: #000000;
			}
		<!--- TiposLetra --->
			.Titulo {
				font-size: 14pt;
				font-family: Verdana;
				font-weight: bold;
			}
			.SubTitulo {
				font-size: 12pt;
				font-family: Verdana;
				font-weight: bold;
			}	
			.Empresa {
				font-size: 10pt;
				font-family: Verdana;
				font-weight: bold;
			}
			.filtros {
				font-size: 8pt;
				font-family: Verdana;
			}
			.filtrosNegrita {
				font-size:8pt;
				font-family: Verdana;
				font-weight: bold;
			}
			
			.General {
				font-size: 9pt;
				font-family: Verdana;
			}
			.GeneralNegrita {
				font-size: 9pt;
				font-family: Verdana;
				font-weight: bold;
			}
			.GeneralNegritaCorte {
				font-size: 9pt;
				font-family: Verdana;
				font-weight: bold; font-style:italic;
			} 
		<!--- Cortepagina --->	
			H1.Corte_Pagina
			{
				PAGE-BREAK-AFTER: always
			}
	</style>
<!--- </cfsilent> --->
<cfsavecontent variable="ENCABEZADO_IMP">
	<cfoutput>
	
	<table width="100%" border="0" cellspacing="1" cellpadding="1" bgcolor="#Attributes.Color#">
 
		<tr>
			<td <cfif isdefined("Attributes.cols")>colspan="#Attributes.cols#"</cfif>>
				<table width="100%" border="0" cellspacing="1" cellpadding="1" bgcolor="#Attributes.Color#">
					<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#" ecodigo="#session.Ecodigo#" pvalor="2665" default="0" returnvariable="UsaLogoEncabezado"/>
					<tr>
						<td colspan="<cfif isdefined("Attributes.cols")>#Attributes.cols#<cfelse>3</cfif>"  class="Titulo"><cfif isdefined("Attributes.Titulo") and len(trim(Attributes.Titulo))>#Attributes.Titulo#<cfelse>&nbsp;</cfif></td>
					<cfif UsaLogoEncabezado eq 1>
						<!--- fcastro 20130531 - Se agrega el logo de la empresa segun parametro 2665---->
						<td colspan="2" style="padding-left: 20px;vertical-align:middle;">
							<img height="45" border="0" alt="logo" src="http://#CGI.SERVER_NAME#:#CGI.SERVER_PORT#/cfmx/home/public/logo_empresa.cfm?EcodigoSDC=<cfoutput>#session.EcodigoSDC#</cfoutput>"/>
						</td>
					</cfif>
					<cfloop from="1" to="2" index="i">
						<cfif isDefined("Attributes.tituloCentrado#i#")>
							<tr>
								<td style="text-align:center;"  colspan="<cfif isdefined("Attributes.cols")>#Attributes.cols#<cfelse>3</cfif>" class="SubTitulo">#attributes['tituloCentrado'&i]#</td>
							</tr>						
						</cfif>						
					</cfloop>
					<cfif isdefined("Attributes.SubTitulo") and len(trim(Attributes.SubTitulo))>
						<tr><td  colspan="<cfif isdefined("Attributes.cols")>#Attributes.cols#<cfelse>3</cfif>" class="SubTitulo">#Attributes.SubTitulo#</td></tr>
					<cfelse>
						<tr><td  colspan="<cfif isdefined("Attributes.cols")>#Attributes.cols#<cfelse>3</cfif>" class="SubTitulo">#Attributes.SubTitulo#</td></tr>
    				</cfif>
					<tr> 
						<cfif isdefined("Attributes.showEmpresa") and Attributes.showEmpresa eq true>
							<td width="90%" class="Empresa" <cfif not(isdefined("Attributes.MostrarPagina") and len(trim(Attributes.MostrarPagina)) and Attributes.MostrarPagina eq true and Attributes.tipo eq "HTML")>colspan="<cfif isdefined("Attributes.cols")>#Attributes.cols#<cfelse>3</cfif>"</cfif>><cf_translate  key="LB_Empresa" xmlFile="/rh/generales.xml">Empresa</cf_translate>: #session.enombre#</td>
						</cfif>
						<cfif isdefined("Attributes.MostrarPagina") and len(trim(Attributes.MostrarPagina)) and Attributes.MostrarPagina eq true and Attributes.tipo eq "HTML">
						<td width="5%" nowrap class="filtrosNegrita" ><cfif isdefined("Attributes.MostrarPagina") and len(trim(Attributes.MostrarPagina)) and Attributes.MostrarPagina eq true and Attributes.tipo eq "HTML"><cf_translate  key="LB_Pagina" xmlFile="/rh/generales.xml">Página</cf_translate>
							<cfelse>&nbsp;</cfif></td>
						<td width="5%" nowrap class="filtros"><cfif isdefined("Attributes.MostrarPagina") and len(trim(Attributes.MostrarPagina)) and Attributes.MostrarPagina eq true><cfif isdefined("Attributes.tipo") and len(trim(Attributes.tipo)) and Attributes.tipo eq "HTML">#Attributes.NumPagina# <cfelse><cfif isdefined("cfdocument.currentpagenumber")>#cfdocument.currentpagenumber#<cfelse></cfif></cfif><cfelse>&nbsp;</cfif></td>
						</cfif>
					</tr>
					<tr>
						<td width="90%"  nowrap="nowrap" class="filtros" colspan="<cfif isdefined("Attributes.cols")>#Attributes.cols-2#<cfelse></cfif>"><cfif isdefined("Attributes.Filtro1") and len(trim(Attributes.Filtro1))>#Attributes.Filtro1#<cfelse>&nbsp;</cfif></td>
						<td width="5%" nowrap class="filtrosNegrita"  ><cf_translate  key="LB_Fecha" xmlFile="/rh/generales.xml">Fecha</cf_translate></td>
						<td width="5%" nowrap class="filtros"  ><cf_locale name="date" value="#Now()#"/></td>
					</tr>
					<tr>
						<td nowrap="nowrap" class="filtros" colspan="<cfif isdefined("Attributes.cols")>#Attributes.cols-2#<cfelse></cfif>"><cfif isdefined("Attributes.Filtro2") and len(trim(Attributes.Filtro2))>#Attributes.Filtro2#<cfelse>&nbsp;</cfif></td>
						<td nowrap class="filtrosNegrita"  ><cf_translate  key="LB_Hora" xmlFile="/rh/generales.xml">Hora</cf_translate></td>
						<td nowrap class="filtros"  >#LSTimeFormat(now(),'hh:mm tt')#</td>
					</tr>
					<tr>
						<td class="filtros" colspan="<cfif isdefined("Attributes.cols")>#Attributes.cols-2#<cfelse></cfif>"><cfif isdefined("Attributes.Filtro3") and len(trim(Attributes.Filtro3))>#Attributes.Filtro3#<cfelse>&nbsp;</cfif></td>
						<td nowrap class="filtrosNegrita"><cf_translate  key="LB_Usuario" xmlFile="/rh/generales.xml">Usuario</cf_translate></td>
						<td nowrap class="filtros" >#trim(session.usulogin)#</td>
					</tr>
					<cfset filtroExtra ="">
					<cfloop from="4" to ="20" index="i">
						<cfif isdefined("Attributes.Filtro#i#")> 
							<cfset filtroExtra = Evaluate("Attributes.Filtro#i#")>
							<tr>
								<td class="filtros" colspan="<cfif isdefined("Attributes.cols")>#Attributes.cols-2#<cfelse></cfif>">#filtroExtra#</td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
							</tr>
							<cfset filtroExtra ="">
						</cfif>	
					</cfloop>
					<tr>
						<td colspan="<cfif isdefined("Attributes.cols")>#Attributes.cols#<cfelse>3</cfif>" valign="bottom"><hr color="black"></td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	</cfoutput>
</cfsavecontent>
<cfoutput>
	<cfif isdefined("Attributes.tipo") and len(trim(Attributes.tipo)) and Attributes.tipo eq "HTML">
		#ENCABEZADO_IMP#
  <cfelse>
		<cfdocumentitem type="header">
			#ENCABEZADO_IMP#
	  </cfdocumentitem>
	</cfif>
</cfoutput>	
