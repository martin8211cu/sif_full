<cfif isdefined("Url.fdesde") and not isdefined("Form.fdesde")>
	<cfset Form.fdesde = Url.fdesde>
</cfif>
<cfif isdefined("Url.fhasta") and not isdefined("Form.fhasta")>
	<cfset Form.fhasta = Url.fhasta>
</cfif>
<cfif isdefined("Url.CMCcodigo1") and not isdefined("Form.CMCcodigo1")>
	<cfset Form.CMCcodigo1 = Url.CMCcodigo1>
</cfif>
<cfif isdefined("Url.CMCcodigo2") and not isdefined("Form.CMCcodigo2")>
	<cfset Form.CMCcodigo2 = Url.CMCcodigo2>
</cfif>
<cfinclude template="../../Utiles/sifConcat.cfm">
<cfquery name="rsSolicitudesReasignadas" datasource="#Session.DSN#">
	select a.BMCid, a.CMCidorig, a.CMCidnuevo, 
		   a.BMCtipo, a.EOidorden, 
		   a.ESidsolicitud, a.BMCfecha, 
		   a.Usucodigo,
		   b.CMCcodigo #_Cat# ' - ' #_Cat# b.CMCnombre as CompradorOrigen,
		   c.CMCcodigo #_Cat# ' - ' #_Cat# c.CMCnombre as CompradorNuevo,
		   d.ESnumero, d.ESobservacion
	from BMComprador a, CMCompradores b, CMCompradores c, ESolicitudCompraCM d
	where a.BMCtipo = 0
	<cfif isdefined("Form.fdesde") and Len(Trim(Form.fdesde))>
		and a.BMCfecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.fdesde)#">
	</cfif>
	<cfif isdefined("Form.fhasta") and Len(Trim(Form.fhasta))>
		and a.BMCfecha <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('s', -1, DateAdd('d', 1, LSParseDateTime(Form.fhasta)))#">
	</cfif>
	and a.Ecodigo = b.Ecodigo
	and a.CMCidorig = b.CMCid
	<cfif isdefined("Form.CMCcodigo1") and Len(Trim(Form.CMCcodigo1))>
		and b.CMCcodigo >= <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CMCcodigo1#">
	</cfif>
	<cfif isdefined("Form.CMCcodigo2") and Len(Trim(Form.CMCcodigo2))>
		and b.CMCcodigo <= <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CMCcodigo2#">
	</cfif>
	and a.Ecodigo = c.Ecodigo
	and a.CMCidnuevo = c.CMCid
	and a.Ecodigo = d.Ecodigo
	and a.ESidsolicitud = d.ESidsolicitud
</cfquery>

<cfoutput>
	<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
	  <tr><td colspan="3" align="center" class="tituloAlterno"><strong><font size="3">#session.enombre#</font></strong></td></tr>
	  <tr><td  nowrap colspan="3">&nbsp;</td></tr>
	  <tr><td colspan="3" align="center"><strong><font size="3">Consulta de Reasignaci&oacute;n de Solicitudes de Compra</font></strong></td></tr>
	  <tr>
		<td colspan="3" align="center"><font size="2"><strong>Rango de fechas: </strong><cfif not (isdefined("Form.fdesde") and Len(Trim(Form.fdesde))) and not (isdefined("Form.fhasta") and Len(Trim(Form.fhasta)))>Cualquier fecha</cfif> <cfif isdefined("Form.fdesde") and Len(Trim(Form.fdesde))> desde #Form.fdesde#</cfif> <cfif isdefined("Form.fdesde") and Len(Trim(Form.fhasta))>hasta #Form.fhasta#</cfif></font></td>
	  </tr>
	  <tr>
		<td colspan="3" align="center"><font size="2"><strong>Rango de compradores: </strong><cfif not (isdefined("Form.CMCcodigo1") and Len(Trim(Form.CMCcodigo1))) and not (isdefined("Form.CMCcodigo2") and Len(Trim(Form.CMCcodigo2)))>Cualquier comprador</cfif> <cfif isdefined("Form.CMCcodigo1") and Len(Trim(Form.CMCcodigo1))> desde c&oacute;digo #Form.CMCcodigo1#</cfif> <cfif isdefined("Form.CMCcodigo2") and Len(Trim(Form.CMCcodigo2))>hasta c&oacute;digo #Form.CMCcodigo2#</cfif></font></td>
	  </tr>
	  <tr><td colspan="3" align="center"><strong><font size="2">Fecha de la Consulta:&nbsp;</font></strong><font size="2">#LSDateFormat(Now(),'dd/mm/yyyy')#&nbsp;<strong>Hora:&nbsp;</strong>#TimeFormat(Now(),'medium')#</font></td></tr>
	  <tr><td colspan="3" nowrap>&nbsp;</td></tr>
	</table>

	<table width="98%"  border="0" cellspacing="0" cellpadding="2" align="center">
		  <tr>
			<td class="tituloListas">Comprador Origen</td>
			<td class="tituloListas">Comprador Nuevo</td>
			<td class="tituloListas">Fecha Reasignaci&oacute;n</td>
			<td class="tituloListas">No. Solicitud</td>
			<td class="tituloListas">Descripci&oacute;n</td>
		  </tr>
		<cfif rsSolicitudesReasignadas.recordCount>
			<cfloop query="rsSolicitudesReasignadas">
			  <tr class="<cfif CurrentRow mod 2>listaNon<cfelse>listaPar</cfif>">
				<td>#rsSolicitudesReasignadas.CompradorOrigen#</td>
				<td>#rsSolicitudesReasignadas.CompradorNuevo#</td>
				<td>#LSDateFormat(rsSolicitudesReasignadas.BMCfecha, 'dd/mm/yyyy')#</td>
				<td>#rsSolicitudesReasignadas.ESnumero#</td>
				<td>#rsSolicitudesReasignadas.ESobservacion#</td>
			  </tr>
			</cfloop>
		<cfelse>
			<tr>
				<td colspan="5" align="center"><strong>No se encontraron registros con el criterio seleccionado</strong></td>
			</tr>
		</cfif>
	</table>

	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	  <tr>
	    <td align="center">&nbsp;</td>
      </tr>
	  <tr>
		<td align="center"><strong>---------- Fin de Consulta ----------</strong></td>
	  </tr>
	  <tr>
	    <td align="center">&nbsp;</td>
      </tr>
	</table>
	
</cfoutput>
