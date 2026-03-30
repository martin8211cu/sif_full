<cfparam name="Attributes.Titulo" 			type="string"  default="">
<cfparam name="Attributes.SubTitulo" 		type="string"  default="">
<cfparam name="Attributes.MostrarPagina"  	type="boolean" default="false"> 
<cfparam name="Attributes.NumPagina"  	    type="string" default="1"> 
<cfparam name="Attributes.tipo"  	  		type="string" default="HTML">
<cfparam name="Attributes.Color"  	        type="string" default="E3EDEF"> 
<cfparam name="Attributes.Conexion" 		type="String"  default="#Session.DSN#"> <!--- Nombre de la conexión --->
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
				font-size: 16pt;
				font-family: Verdana;
				font-weight: bold;
			}
			.SubTitulo {
				font-size: 14pt;
				font-family: Verdana;
				font-weight: bold;
			}	
			.Empresa {
				font-size: 12pt;
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
			<td colspan="3"  class="Titulo"><cfif isdefined("Attributes.Titulo") and len(trim(Attributes.Titulo))>#Attributes.Titulo#<cfelse>&nbsp;</cfif></td>
		</tr>
		<cfif isdefined("Attributes.SubTitulo") and len(trim(Attributes.SubTitulo))>
			<tr>
				<td  colspan="3" class="SubTitulo">#Attributes.SubTitulo#</td>
		  </tr>
		</cfif>
		<tr>
			<td width="90%" class="Empresa">#session.enombre#</td>
			<td width="5%" nowrap class="filtrosNegrita" ><cfif isdefined("Attributes.MostrarPagina") and len(trim(Attributes.MostrarPagina)) and Attributes.MostrarPagina eq true and Attributes.tipo eq "HTML"><cf_translate  key="LB_Pagina">P&aacute;gina</cf_translate>
			    <cfelse>&nbsp;</cfif></td>
			<td width="5%" nowrap class="filtros"><cfif isdefined("Attributes.MostrarPagina") and len(trim(Attributes.MostrarPagina)) and Attributes.MostrarPagina eq true><cfif isdefined("Attributes.tipo") and len(trim(Attributes.tipo)) and Attributes.tipo eq "HTML">#Attributes.NumPagina# <cfelse><cfif isdefined("cfdocument.currentpagenumber")>#cfdocument.currentpagenumber#<cfelse></cfif></cfif><cfelse>&nbsp;</cfif></td>
		</tr>
		<tr>
			<td class="filtros" ><cfif isdefined("Attributes.Filtro1") and len(trim(Attributes.Filtro1))>#Attributes.Filtro1#<cfelse>&nbsp;</cfif></td>
			<td nowrap class="filtrosNegrita"  ><cf_translate  key="LB_Fecha">Fecha</cf_translate></td>
			<td nowrap class="filtros"  >#LSDateFormat(Now(), "dd/mm/yyyy")#</td>
		</tr>
		<tr>
			<td class="filtros" ><cfif isdefined("Attributes.Filtro2") and len(trim(Attributes.Filtro2))>#Attributes.Filtro2#<cfelse>&nbsp;</cfif></td>
			<td nowrap class="filtrosNegrita"  ><cf_translate  key="LB_Hora">Hora</cf_translate></td>
			<td nowrap class="filtros" >#LSTimeFormat(now(),'hh:mm tt')#</td>
		</tr>
		<tr>
			<td class="filtros" ><cfif isdefined("Attributes.Filtro3") and len(trim(Attributes.Filtro3))>#Attributes.Filtro3#<cfelse>&nbsp;</cfif></td>
			<td nowrap class="filtrosNegrita"  ><cf_translate  key="LB_Usuario">Usuario</cf_translate></td>
			<td nowrap class="filtros" >#trim(session.usulogin)#</td>
		</tr>
		<cfset filtroExtra ="">
		<cfloop from="4" to ="20" index="i">
			<cfif isdefined("Attributes.Filtro#i#")> 
				<cfset filtroExtra = Evaluate("Attributes.Filtro#i#")>
				<tr>
					<td class="filtros">#filtroExtra#</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
				</tr>
				<cfset filtroExtra ="">
			</cfif>	
		</cfloop>
		<tr>
			<td colspan="3" valign="bottom"><hr color="black"></td>
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
