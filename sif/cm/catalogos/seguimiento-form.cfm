<cfset modo = 'ALTA'>
<cfif isdefined("form.SRid") and len(trim(form.SRid))>
	<cfset modo = 'CAMBIO'>
</cfif>

<cfquery datasource="#session.DSN#" name="dataReclamo">
	select a.EDRnumero, a.EDRfecharec, a.ERestado, a.SNcodigorec, d.DOdescripcion
	from EReclamos a
	
	inner join DReclamos b
	on a.ERid=b.ERid
	and DRid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DRid#">
	
	inner join DDocumentosRecepcion c
	on b.DDRlinea=c.DDRlinea
	
	inner join DOrdenCM d
	on c.DOlinea=d.DOlinea

	where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and a.ERid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ERid#">
</cfquery>

<cfif modo neq 'ALTA'>
	<cfquery name="data" datasource="#session.DSN#">
		select SRfecha, SRobs, SRestado, ts_rversion
		from SReclamos
		where SRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SRid#">
	</cfquery>
</cfif>

<cfoutput>
<form name="form1" method="post" action="seguimiento-sql.cfm">
	<table width="100%" cellpadding="2" cellspacing="0">

		<tr>
			<td align="right"><strong>Reclamo:&nbsp;</strong></td>
			<td >#dataReclamo.EDRnumero#</td>
		</tr>
		<tr>
			<td align="right"><strong>Fecha:&nbsp;</strong></td>
			<td >#LSdateFormat(dataReclamo.EDRfecharec,'dd/mm/yyyy')#</td>
		</tr>
		<tr>
			<td align="right"><strong>Item:&nbsp;</strong></td>
			<td >#dataReclamo.DOdescripcion#</td>
		</tr>

		<tr>
			<td align="right"><strong>Fecha:&nbsp;</strong></td>
			<td>
				<cfif modo neq 'ALTA'>
					<cf_sifcalendario name="SRfecha" value="#LSDateFormat(data.SRfecha,'dd/mm/yyyy')#">
				<cfelse>
					<cf_sifcalendario name="SRfecha">
				</cfif>
			</td>
		</tr>
		<tr>
			<td align="right"><strong>Estado:&nbsp;</strong></td>
			<td>
				<select name="SRestado">
					<option value="0" <cfif modo neq 'ALTA' and data.SRestado eq 0>selected</cfif> >En Proceso</option>
					<option value="1" <cfif modo neq 'ALTA' and data.SRestado eq 1>selected</cfif> >Conclu&iacute;do</option>
				</select>
			</td>
		</tr>
		<tr>
			<td align="right" valign="top"><strong>Observaciones:&nbsp;</strong></td>
			<td><textarea name="SRobs" rows="6" cols="40"><cfif modo neq 'ALTA'>#data.SRobs#</cfif></textarea></td>
		</tr>

		<tr><td>&nbsp;</td></tr>
		<tr>
			<td>&nbsp;</td>
			<td >
				<cfif modo neq 'CAMBIO'>
					<input type="submit" name="Alta" value="Agregar">
				<cfelse>
					<cfif data.SRestado eq 0>
						<input type="submit" name="Cambio" value="Modificar">
						<input type="submit" name="Baja" value="Eliminar">
					</cfif>
					<input type="submit" name="Nuevo" value="Nuevo" onClick="javascript:deshabilitarValidacion();">
				</cfif>
				<input type="submit" name="Regresar" value="Regresar" onClick="javascript:deshabilitarValidacion(); regresar();">
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
	</table>
	
	<!--- Ocultos --->
	<input type="hidden" name="ERid" value="#form.ERid#">
	<input type="hidden" name="DRid" value="#form.DRid#">
	<cfif modo neq 'ALTA'>
		<input type="hidden" name="SRid" value="#form.SRid#">
	</cfif>

</form>
</cfoutput>

<script language="JavaScript1.2" type="text/javascript">
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
		
	objForm.SRfecha.required = true;
	objForm.SRfecha.description="Fecha";

	objForm.SRobs.required = true;
	objForm.SRobs.description="Observaciones";

	function deshabilitarValidacion(){
		objForm.SRfecha.required = false;
		objForm.SRobs.required = false;
	}

	function regresar(){
		document.form1.action = '../operacion/reclamos.cfm';
		return true;
	}

</script>