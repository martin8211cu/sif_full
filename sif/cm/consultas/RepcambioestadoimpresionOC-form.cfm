<!---****  Si los filtros vienen por URL (cambio de pagina) los carga en el form ---->
<cfif isdefined("url.fESnumeroD") and not isdefined("form.fESnumeroD") >
	<cfset form.fESnumeroD = url.fESnumeroD >
</cfif>

<cfif isdefined("url.fESnumeroH") and not isdefined("form.fESnumeroH") >
	<cfset form.fESnumeroH = url.fESnumeroH >
</cfif>

<cfif isdefined("url.fechaD") and not isdefined("form.fechaD") >
	<cfset form.fechaD = url.fechaD >
</cfif>
		
<cfif isdefined("url.fechaH") and not isdefined("form.fechaH") >
	<cfset form.fechaH = url.fechaH >
</cfif>

<cfif isdefined("url.CMCcodigo") and not isdefined("form.CMCcodigo") >
	<cfset form.CMCcodigo = url.CMCcodigo >
</cfif>

<cfif isdefined("url.CMCnombre") and not isdefined("form.CMCnombre") >
	<cfset form.CMCnombre = url.CMCnombre >
</cfif>

<cfif isdefined("url.CMCid") and not isdefined("form.CMCid") >
	<cfset form.CMCid = url.CMCid >
</cfif>

<cfif isdefined("url.SNcodigo") and not isdefined("form.SNcodigo") >
	<cfset form.SNcodigo = url.SNcodigo >
</cfif>

<cfif isdefined("url.CMTOcodigo") and not isdefined("form.CMTOcodigo") >
	<cfset form.CMTOcodigo = url.CMTOcodigo >
</cfif>

<cfif isdefined("url.CMTOdescripcion") and not isdefined("form.CMTOdescripcion") >
	<cfset form.CMTOdescripcion = url.CMTOdescripcion >
</cfif>
<cfinclude template="../../Utiles/sifConcat.cfm">
<cfquery name="rsBitacora" datasource="#session.DSN#">
	select 	d.EOnumero,
			case a.Estanterior when 'R' then 'Impresa'
							else 'Pendiente de impresión'
			end EstadoAnterior,
			case a.Estactual when 'R' then 'Impresa'
							else 'Pendiente de impresión'
			end EstadoActual,
			a.Fechacambio,
			c.Pnombre #_Cat#' '#_Cat# c.Papellido1 #_Cat#' '#_Cat# c.Papellido2 as Usuario
		
	from BitEstadoIOC a
		inner join EOrdenCM d
			on a.EOidorden = d.EOidorden
		inner join Usuario b
			on a.BMUsucodigo = b.Usucodigo
	
			left outer join  DatosPersonales c
				on b.datos_personales = c.datos_personales
	where d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		<cfif isdefined("form.CMCid") and len(trim(form.CMCid)) >
			and d.CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMCid#">
		</cfif>
		
		<cfif isdefined("form.fESnumeroD") and len(trim(form.fESnumeroD)) and (isdefined("form.fESnumeroH") and len(trim(form.fESnumeroH))) >
			<cfif form.fESnumeroD  GT form.fESnumeroH>
				and d.EOnumero between <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fESnumeroH#">
				and <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fESnumeroD#">
			<cfelseif form.fESnumeroD EQ form.fESnumeroH>
				and d.EOnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fESnumeroD#">
			<cfelse>
				and d.EOnumero between <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fESnumeroD#">
				and <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fESnumeroH#">
			</cfif>
		</cfif>
		
		<cfif isdefined("form.fESnumeroD") and len(trim(form.fESnumeroD)) and not (isdefined("form.fESnumeroH") and len(trim(form.fESnumeroH))) >
			and d.EOnumero >= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fESnumeroD#">
		</cfif>
		
		<cfif isdefined("form.fESnumeroH") and len(trim(form.fESnumeroH)) and not (isdefined("form.fESnumeroD") and len(trim(form.fESnumeroD))) >
			and d.EOnumero <= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fESnumeroH#">
		</cfif>
		
		<cfif isdefined("form.CMTOcodigo") and len(trim(form.CMTOcodigo)) >
			and d.CMTOcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CMTOcodigo#">
		</cfif>						
	
		<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo)) >
			and d.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
		</cfif>
	
		<cfif isdefined("Form.fechaD") and len(trim(Form.fechaD)) and isdefined("Form.fechaH") and len(trim(Form.fechaH))>
			<cfif form.fechaD EQ form.fechaH>
				and d.EOfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fechaD)#">
			<cfelse>
				and d.EOfecha between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fechaD)#">
				and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fechaH)#">
			</cfif>
		<cfelseif isdefined("vd_fechadesde") and not isdefined("form.fechaD") and isdefined("vd_fechahasta") and not isdefined("Form.fechaH")>
			and d.EOfecha between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(vd_fechadesde)#">
			and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(vd_fechahasta)#">
		</cfif>
		order by d.EOnumero
</cfquery>
<table width="100%" cellpadding="0" cellspacing="0">	
	<tr>
		<td colspan="2" align="center"><strong><cfoutput>#session.Enombre#</cfoutput></strong></td>
	</tr>
	<tr><td align="center" colspan="2"><strong>Cambios de estado de impresi&oacute;n de OC</strong></td></tr>
	<tr><td width="15%">&nbsp;</td></tr>	
	<tr><td width="15%">&nbsp;</td></tr>	
	<cfif rsBitacora.RecordCount EQ 0>
		<tr><td colspan="2" align="center"><strong>---------- No se encontraron registros ----------</strong></td></tr>
	</cfif>
	<cfoutput query="rsBitacora" group="EOnumero">
		<tr>
			<td align="right" class="tituloListas" ><strong>No.Orden compra:</strong></td>
			<td width="85%" class="tituloListas" >#rsBitacora.EOnumero#</td>
		</tr>
		<tr>			
			<td colspan="2">
				<table width="100%" cellpadding="0" cellspacing="0">
					<tr>
						<td width="4%">&nbsp;</td>
						<td width="44%"><strong>Usuario que modific&oacute;</strong></td>
						<td width="16%"><strong>Fecha</strong></td>
						<td width="18%"><strong>Estado anterior</strong></td>
						<td width="18%"><strong>Estado actual</strong></td>				
					</tr>	
					<cfoutput>
						<tr>
							<td width="4%">&nbsp;</td>
							<td>#rsBitacora.Usuario#</td>
							<td>#LSDateFormat(rsBitacora.Fechacambio,'dd/mm/yyyy')#</td>
							<td>#rsBitacora.EstadoAnterior#</td>
							<td>#rsBitacora.EstadoActual#</td>
						</tr>
					</cfoutput>
				</table>
			</td>
		</tr>
	</cfoutput>
	<tr><td>&nbsp;</td></tr>
</table>