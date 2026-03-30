
<cfif isdefined("url.CMSid") and not isdefined("form.CMSid")>
	<cfset form.CMSid = Url.CMSid>
</cfif>

<cfif isdefined("url.CFid") and not isdefined("form.CFid")>
	<cfset form.CFid = Url.CFid>
</cfif>

<cfif isdefined("url.CFcodigo") and not isdefined("form.CFcodigo")>
	<cfset form.CFcodigo = Url.CFcodigo>
</cfif>

<cfif isdefined("url.CFdescripcion") and not isdefined("form.CFdescripcion")>
	<cfset form.CFdescripcion = Url.CFdescripcion>
</cfif>

<cfquery name="rsSolicitante" datasource="#session.DSN#">
	select CMSnombre,CMScodigo 
	from CMSolicitantes
	where CMSid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CMSid#">
</cfquery>
<!---**************************************** SQL DETALLE ****************************************************----->
<cfinclude template="../../Utiles/sifConcat.cfm">
<cfquery name="rsDatos" datasource="#session.DSN#">
	select  d.CMTSdescripcion,a.CCid, a.CMElinea,
			a.CMEtipo as Tipo, case a.CMEtipo when 'A' then Cdescripcion
			when 'S' then CCdescripcion
			when 'F' then j.ACdescripcion#_Cat#'/'#_Cat#k.ACdescripcion end as Descripcion
	 
	from  CMSolicitantes b
		inner join CMESolicitantes c
			on b.CMSid = c.CMSid
		
		inner join CMEspecializacionTSCF a
			on c.CMElinea = a.CMElinea
		
		inner join CMTiposSolicitud d
			on a.CMTScodigo = d.CMTScodigo
			
		-- Articulos
		left outer join Clasificaciones f
		on a.Ccodigo=f.Ccodigo
		and a.Ecodigo=f.Ecodigo
		and f.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  
		-- Conceptos
		left outer join CConceptos h
		on a.CCid=h.CCid
		and a.Ecodigo=h.Ecodigo
		
		-- Activos
		left outer join ACategoria j
		on a.ACcodigo=j.ACcodigo
		and a.Ecodigo=j.Ecodigo
		 
		left outer join AClasificacion k
		on a.ACcodigo=k.ACcodigo
		and a.ACid=k.ACid
		and a.Ecodigo=k.Ecodigo
		 
		where a.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
		and b.Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and b.CMSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMSid#">
		and c.CMElinea in (select CMElinea 
							from CMEspecializacionTSCF e
							where c.CMElinea = e.CMElinea )
		
</cfquery>
<!---***********************************************************************************----->

<!--- *********************************************** ENCABEZADO ************************************************--->
<cfoutput>
<table width="100%" border="0" cellspacing="0" cellpadding="1" style="padding-left: 5px; padding-right: 10px" align="center">	
	<tr><td colspan="3" align="center" class="tituloAlterno"><strong>#session.enombre#</strong></td></tr>
	<tr><td colspan="3" nowrap>&nbsp;</td></tr>
	<tr><td colspan="3" align="center"><strong>Consulta de Permisos Por Solicitante</strong></td></tr>
	<tr><td colspan="3" align="center"><strong>Fecha de la Consulta:&nbsp;</strong>#LSDateFormat(Now(),'dd/mm/yyyy')#&nbsp;<strong>Hora:&nbsp;</strong>#TimeFormat(Now(),'medium')#</td></tr>
	<tr><td colspan="3" nowrap>&nbsp;</td></tr>
	<tr><td colspan="3" ><strong>Solicitante:&nbsp; #rsSolicitante.CMScodigo# - #rsSolicitante.CMSnombre#</strong></td></tr>
	<tr><td colspan="3" ><strong>Centro Funcional:&nbsp; #form.CFcodigo# - #form.CFdescripcion#</strong></td></tr>	
	<tr><td colspan="3" >&nbsp;</td></tr>	
	<tr>
		<td nowrap width="40%" class="tituloListas" style="padding-right: 5px; padding-left:10px; border-bottom: 1px solid black; border-top:1px solid black;">Tipo Solicitud</td>
		<td nowrap width="10%" class="tituloListas" style="padding-right: 5px; padding-left:10px; border-bottom: 1px solid black; border-top:1px solid black;">Tipo Item</td>
		<td nowrap width="40%" class="tituloListas" style="padding-right: 5px; padding-left:10px; border-bottom: 1px solid black; border-top:1px solid black;">Línea Especialización</td>				
	</tr>			
	<cfif rsDatos.RecordCount EQ 0 >
		<tr><td colspan="10" style="padding-right: 5px; text-align:center">&nbsp;---------- No hay registros ----------&nbsp;</td></tr>
	<cfelse>			
	<cfloop query="rsDatos">
		<cfif currentRow mod 35 EQ 1>
			<cfif currentRow NEQ 1>
				<tr class="pageEnd"><td colspan="3">&nbsp;</td></tr>
			</cfif>
		</cfif>
		<tr>
			<td nowrap width="40%" style="padding-right: 5px;">&nbsp;#rsDatos.CMTSdescripcion#</td>
			<cfif rsDatos.Tipo EQ 'A'>
				<td nowrap width="10%" style="padding-right: 5px; ">&nbsp;Artículo</td>							
			<cfelseif rsDatos.Tipo EQ 'F'>
				<td nowrap width="10%" style="padding-right: 5px;">&nbsp;Activo</td>							
			<cfelse>
				<td nowrap width="10%" style="padding-right: 5px;">&nbsp;Servicio</td>							
			</cfif>
				<td nowrap width="40%" style="padding-right: 5px; ">&nbsp;#rsDatos.Descripcion#</td>							
		</tr>
	</cfloop>
	<tr><td>&nbsp;</td></tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td>&nbsp;</td></tr>
	<td colspan="10" style="padding-right: 5px; text-align:center">&nbsp;------------------------------------------------------ Última Línea ------------------------------------------------------&nbsp;</td>
	</cfif>
</table>
</cfoutput>
<!-----border-bottom: 1px solid black; border-left: 1px solid black; --->