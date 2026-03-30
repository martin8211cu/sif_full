<cfquery name="data" datasource="#session.dsn#">
	select ERid, Ecodigo, SNcodigo, EDRid, CMCid, EDRnumero, EDRfecharec,
		   Usucodigo, fechaalta, ERestado, coalesce(SNcodigorec, SNcodigo) as SNcodigorec, ERobs, ts_rversion
	from EReclamos
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and ERid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ERid#">
</cfquery>

<cfif len(trim(data.SNcodigo))>
	<cfquery name="socio" datasource="#session.DSN#">
		select SNnumero, SNnombre
		from SNegocios
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and SNcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#data.SNcodigo#">
	</cfquery>
</cfif>

<cfquery name="rsDetalles" datasource="#session.DSN#">
	select *
	from DReclamos
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and ERid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ERid#">
	and DRestado > 10
</cfquery>

<cfquery name="dataCompradores" datasource="#session.dsn#">
	select CMCid, CMCnombre
	from CMCompradores a 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and CMCestado=1
	<cfif data.ERestado eq 20 or rsDetalles.RecordCount gt 0 >
		and CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.CMCid#">
	</cfif>
</cfquery>

<cfoutput>

<cfset estado = ArrayNew(1)>
<cfset estado[1] = 'Sin asignar'>
<cfset estado[11] = 'En proceso'>
<cfset estado[21] = 'Conclu&iacute;do'>

<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td align="right"><strong>N&uacute;mero:&nbsp;</strong></td>
		<td>#data.EDRnumero#</td>
		<td align="right"><strong>Fecha:&nbsp;</strong></td>
		<td>
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr>
					<td>#LSDateFormat(data.EDRfecharec,'dd/mm/yyyy')#</td>
					<td width="1%" nowrap><input type="hidden" name="ERobs" value="#data.ERobs#"><a href="javascript:info_detalle('ERobs',false);"><strong>Observaciones</strong></a></td>
					<td><img style="cursor: hand;" onClick="javascript:info_detalle('ERobs',false)" src="../../imagenes/iedit.gif"></td>
				</tr>
			</table>
		</td>
		
		<td align="right"><strong>Estado:&nbsp;</strong></td>
		<td>#estado[data.ERestado+1]#</td>
	</tr>
	<tr>
		<td align="right"><strong>Proveedor:&nbsp;</strong></td>
		<td nowrap>
			<input type="hidden" value="SNcodigo" value="#data.SNcodigo#">#socio.SNnumero# - #socio.SNnombre#
		</td>
		<td align="right"><strong>Prov. Reclamo :&nbsp;</strong></td>
		<td>
			<cf_sifsociosnegocios2 idquery="#data.SNcodigorec#" SNcodigo="SNcodigorec" SNnumero="SNnumerorec" SNnombre="SNnombrerec">
			<cfif modo neq 'ALTA'>
				<input type="hidden" name="_SNcodigorec" value="#data.SNcodigorec#">
			</cfif>
		</td>
		<td align="right"><strong>Comprador:&nbsp;</strong></td>
		<td>
			<input type="hidden" name="_CMCid" value="#data.CMCid#">
			<select name="CMCid">
			<cfloop query="dataCompradores">
				<option value="#dataCompradores.CMCid#" <cfif isdefined("data.CMCid") and data.CMCid eq dataCompradores.CMCid >selected</cfif> >#dataCompradores.CMCnombre#</option>
			</cfloop>
			</select>
		</td>
	</tr>
</table>

<!--- Ocultos --->
<input type="hidden" name="ERid" value="#form.ERid#">
</cfoutput>