<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Pasos"
Default="Pasos"
returnvariable="LB_Pasos"/> 

<cf_web_portlet_start titulo='#LB_Pasos#'>
<table width="1%" border="0" cellspacing="0" cellpadding="2">
  <cfloop from="0" to="#Gmaxpasos#" index="Lpaso"><cfoutput>
  <tr>
	<td width="1%" align="right" <cfif Lpaso EQ 0> style="border-bottom: 1px solid black; "</cfif>>
		<cfif Lpaso EQ Gpaso>
			<img src="/cfmx/rh/imagenes/addressGo.gif" border="0">
		<cfelseif Lpaso LTE Gmaxpasoallowed>
			<img src="/cfmx/rh/imagenes/w-check.gif" border="0">
		</cfif>
	</td>
	<td <cfif Lpaso EQ 0> style="border-bottom: 1px solid black; "</cfif>>&nbsp;</td>
	<td align="right" <cfif Lpaso EQ 0> style="border-bottom: 1px solid black; "</cfif>><img src="/cfmx/rh/imagenes/number#Lpaso#_16.gif" border="0"></td>
	<td <cfif Lpaso EQ 0> style="border-bottom: 1px solid black; "</cfif>>&nbsp;</td>
	<td class="etiquetaProgreso" nowrap <cfif Lpaso EQ 0> style="border-bottom: 1px solid black; "</cfif>>
		<cfif Lpaso LTE Gmaxpasoallowed>
		<cfset params = "">
		<cfif Lpaso GT 0>
			<cfset params = "&RHPLPid=#RHPLPid#">
		</cfif>
		<a 	href="javascript: window.location.href = '#CurrentPage#?paso=#Lpaso##params#';" 
			tabindex="-1" 
			onMouseOver="javascript: window.status = ''; return true;" 
			onMouseOut="javascript: window.status = ''; return true;">
		</cfif>
		#Gdescpasos[Lpaso+1]#
		<cfif Lpaso LTE Gmaxpasoallowed>
		</a>
		</cfif>
	</td>
  </tr>
  </cfoutput></cfloop>
</table>
<cf_web_portlet_end>
