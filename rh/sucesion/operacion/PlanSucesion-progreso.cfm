<!---*******************************--->
<!--- cuandro que muestra en que    --->
<!--- paso me encuentro             --->
<!---*******************************--->
<cfset activa = 2>
<cfif Gpaso eq  1>
	<cfquery name="rs" datasource="#session.DSN#">
		select *
			from RHPlanSucesion  a
		where a.Ecodigo  =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.RHPcodigo  =  <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#">
	</cfquery>
	<cfif rs.recordcount gt 0>
		<cfset activa = 1>
	</cfif>
</cfif>
<cf_web_portlet_start titulo='Pasos'>
<table width="1%"  border="0" cellspacing="0" cellpadding="0">

  <cfloop from="0" to="#Gmaxpasos#" index="Lpaso"><cfoutput>
   <tr>
	<td width="1%" align="right">
		<cfif Lpaso EQ Gpaso>
			<img src="/cfmx/rh/imagenes/addressGo.gif" border="0">
		<cfelseif Lpaso LTE Gmaxpasoallowed>
			<img src="/cfmx/rh/imagenes/w-check.gif" border="0">
		</cfif>
	</td>
	<td>&nbsp;</td>
	<td align="right"><img src="/cfmx/rh/imagenes/number#Lpaso#_16.gif" border="0"></td>
	<td>&nbsp;</td>
	<td class="etiquetaProgreso" nowrap>
		<cfif Lpaso LTE Gmaxpasoallowed or (Gpaso GTE activa  and Lpaso LT 4 )>
			<cfset params = "">
			<cfif Lpaso GT 0>
				<cfset params = "&RHPcodigo=#Form.RHPcodigo#">
			</cfif>
							

			<a 	href="javascript: window.location.href = 'PlanSucesion.cfm?paso=#Lpaso##params#';" 
				tabindex="-1" 
				onMouseOver="javascript: window.status = ''; return true;" 
				onMouseOut="javascript: window.status = ''; return true;">
		</cfif>
		#Gdescpasos[Lpaso+1]#
		<cfif  Lpaso LTE Gmaxpasoallowed or (Gpaso GTE activa  and Lpaso LT 4 )>
			</a>
		</cfif>
	</td>
  </tr>
  </cfoutput></cfloop>
</table>
<cf_web_portlet_end>