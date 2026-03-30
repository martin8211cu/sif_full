<cfquery datasource="#session.dsn#" name="rsForm_OBetapa">
	select a.Ecodigo
	     , a.OBPid, 	op.OBPcodigo, 	op.OBPdescripcion, op.CFformatoPry
	     , a.OBOid, 	oo.OBOcodigo, 	oo.OBOdescripcion, oo.CFformatoObr, PCDcatidObr
	     , a.OBEid, 	a.OBEcodigo, 	a.OBEdescripcion
	     , a.Ocodigo, 	o.Oficodigo, 	o.Odescripcion
		 , case a.OBEestado 
				when '0' then 'Inactivo'
				when '1' then 'Abierto'
				when '2' then 'Cerrado'
			end as Estado
	  from OBetapa a
	  	inner join Oficinas o
		   on o.Ecodigo = a.Ecodigo
		  and o.Ocodigo = a.Ocodigo
		inner join OBproyecto op
		   on op.OBPid = a.OBPid
	  	inner join OBobra oo
		   on oo.OBOid = a.OBOid
	 where a.OBPid = #session.obras.OBPid#
	   and a.OBEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBEid#" null="#Len(form.OBEid) Is 0#">

</cfquery>
<cfset form.OBOid = rsForm_OBetapa.OBOid>
<cfset url.OBOid = rsForm_OBetapa.OBOid>

<cfoutput>
<form name="form_OBetapa" id="form_OBetapa" method="post" action="OBetapa_sql.cfm">
	<table summary="Tabla de entrada">
		<tr>
			<td colspan="2" class="subTitulo">
				Cuentas de una Etapa
			</td>
		</tr>

		<tr>
			<td valign="top">
				<strong>Proyecto</strong>
			</td>
			<td valign="top">
					#rsForm_OBetapa.OBPcodigo#
					#rsForm_OBetapa.OBPdescripcion#
			</td>
		</tr>
		<tr>
			<td valign="top">
				<strong>Obra</strong>
			</td>
			<td valign="top">
					#rsForm_OBetapa.OBOcodigo#
					#rsForm_OBetapa.OBOdescripcion#
			</td>
		</tr>
		<tr>
			<td valign="top">
				<strong>Etapa</strong>
			</td>
			<td valign="top">
				#HTMLEditFormat(rsForm_OBetapa.OBEcodigo)# 
				#HTMLEditFormat(rsForm_OBetapa.OBEdescripcion)#
			</td>
		</tr>
		<tr>
			<td valign="top">
				<strong>Oficina</strong>
			</td>
			<td valign="top">
				#rsForm_OBetapa.Oficodigo#
				#rsForm_OBetapa.Odescripcion#
			</td>
		</tr>

		<tr>
			<td valign="top">
				<strong>Estado</strong>
			</td>
			<td valign="top">
				<strong>#rsForm_OBetapa.Estado#</strong>
			</td>
		</tr>

	</table>
	<a name="etapa"></a>
	<input type="hidden" name="Ecodigo" value="#HTMLEditFormat(rsForm_OBetapa.Ecodigo)#">
	<input type="hidden" name="OBPid" value="#HTMLEditFormat(session.obras.OBPid)#">
	<input type="hidden" name="OBOid" value="#HTMLEditFormat(rsForm_OBetapa.OBOid)#">
	<input type="hidden" name="OBEid" value="#HTMLEditFormat(rsForm_OBetapa.OBEid)#">
</form>

<cfif rsForm_OBetapa.RecordCount>
	<cfinclude template="OBetapaCuentas_list.cfm">
</cfif>
</cfoutput>