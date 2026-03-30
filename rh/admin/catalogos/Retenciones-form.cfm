<!--- Definición del modo --->
<cfif isdefined("Form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>
<cfif modo neq 'ALTA'>
	<cfquery name="rsDeduccionReb" datasource="#Session.DSN#">
		select CIid,TDid,SNcodigo,Descripcion,Porcentaje,ts_rversion
		  from RHDeduccionesReb
		 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		   and CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid#">
		   and TDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TDid#">
	</cfquery>
	<cfinvoke 
		component="sif.Componentes.DButils"
		method="toTimeStamp"
		returnvariable="ts">
		<cfinvokeargument name="arTimeStamp" value="#rsDeduccionReb.ts_rversion#"/>
	</cfinvoke>
</cfif>
<cfoutput>
	<form name="form1" method="post" action="Retenciones-sql.cfm">
		<input name="CIid" type="hidden" value="#form.CIid#" tabindex="-1">
		<input type="hidden" name="ts_rversion" value="<cfif modo NEQ 'ALTA'><cfoutput>#ts#</cfoutput></cfif>">
		<table width="95%" align="center" border="0" cellspacing="2" cellpadding="0">
			<tr class="tituloAlterno"><td colspan="2">#LB_Retenciones#</td></tr>
			<tr><td colspan="2">&nbsp</td></tr>
			<tr>
				<td align="right"><strong>#LB_Retencion#:</strong>&nbsp</td>
				<td>
					<cfset valuesArray = ArrayNew(1)>
					<cfif isdefined("form.TDid") and len(trim(form.TDid))>
						<cfquery name="rsDeduccion" datasource="#session.dsn#">
							select TDid,TDcodigo,TDdescripcion
							from TDeduccion
							where TDid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TDid#">
						</cfquery>
						<cfif rsDeduccion.recordcount gt 0>
							<cfset ArrayAppend(valuesArray,'#rsDeduccion.TDid#')>
							<cfset ArrayAppend(valuesArray,'#rsDeduccion.TDcodigo#')>
							<cfset ArrayAppend(valuesArray,'#rsDeduccion.TDdescripcion#')>
						</cfif>
					<cfelse>
						<cfset ArrayAppend(valuesArray,'')>
						<cfset ArrayAppend(valuesArray,'')>
						<cfset ArrayAppend(valuesArray,'')>
					</cfif>	
					<cfif modo NEQ "ALTA">
						<input name="TDid" type="hidden" value="#rsDeduccion.TDid#" tabindex="-1">
						<input name="TDcodigo" type="text" size="4" value="#rsDeduccion.TDcodigo#" class="cajasinborde" tabindex="-1" readonly="true">
						<input name="TDdescripcion" type="text" size="30" value="#rsDeduccion.TDdescripcion#"  class="cajasinborde" readonly="true" tabindex="-1">
					<cfelse>
						<cf_conlis
							campos="TDid,TDcodigo,TDdescripcion"
							desplegables="N,S,S"
							modificables="N,S,N"
							valuesArray="#valuesArray#"
							size="0,5,30"
							title="#LB_ListaDeRetenciones#"
							tabla="TDeduccion"
							columnas="TDid,TDcodigo,TDdescripcion,TDobligatoria,
									{fn concat('<img border=''0'' src=''/cfmx/sif/rh/imagenes/',{fn concat((case TDobligatoria when 0 then 'un' else null end),'checked.gif''>')})} as Obligatorio,
									TDprioridad,'' as esp"
							filtro="Ecodigo=#session.Ecodigo# 
									order by 1 ,2"
							desplegar="TDcodigo,TDdescripcion,Obligatorio,TDprioridad,esp"
							etiquetas="#LB_Codigo#, #LB_Descripcion#, #LB_Obligatoria#,#LB_Prioridad#, "
							filtrar_por="TDcodigo,TDdescripcion,Obligatorio,TDprioridad,esp"
							formatos="S,S,S,S,US"
							align="left,left,center,center,center"
							asignar="TDid,TDcodigo,TDdescripcion" 
							asignarformatos="S,S,S"
							showEmptyListMsg="true"
							EmptyListMsg="-- #vNoRegistros# --"
							tabindex="1"
							width="550"
							height="450"> 
					</cfif>
				</td>
			</tr>
			<tr>
				<td align="right"><strong>#LB_Descripcion#:</strong>&nbsp</td>
				<td>
					<input name="Descripcion" type="Text" 
						value="<cfif modo NEQ 'ALTA' and LEN(TRIM(rsDeduccionReb.Descripcion))>#rsDeduccionReb.Descripcion#</cfif>" tabindex="1" size="40">
				</td>
			</tr>
			<tr>
				<td align="right"><strong>#LB_Socio#:</strong>&nbsp</td>
				<td>
					<cfif modo NEQ 'ALTA'>
						<cf_sifsociosnegocios2 form="form1" size="40" tabindex="1" idquery="#rsDeduccionReb.SNcodigo#">
					<cfelse>
						<cf_sifsociosnegocios2 form="form1" size="40" tabindex="1">
					</cfif>
				</td>
			</tr>
			<tr>
				<td align="right"><strong>#LB_Porcentaje#:</strong>&nbsp</td>
				<td>
					<input name="Porcentaje" type="Text" style="text-align=right;" maxlength="3"
						value="<cfif modo NEQ 'ALTA' and LEN(TRIM(rsDeduccionReb.Porcentaje))>#rsDeduccionReb.Porcentaje#</cfif>" tabindex="1" size="4"> %
				</td>
			</tr>
			<tr><td colspan="2">&nbsp</td></tr>
			<tr>
				<td colspan="2" align="center">
					<cfset regresa = 'TiposIncidencia.cfm?CIid=#form.CIid#'>
					<cf_botones modo="#modo#" tabindex="1" regresar="#regresa#">
				</td>
			</tr>
		</table>
	</form>
</cfoutput>
<SCRIPT LANGUAGE="JavaScript">
	 function vPorcentaje(){
     	if (objForm._allowSubmitOnError) return;
	    if (this.value<0||this.value>100) this.error="<cfoutput>#MSG_ElPorcentajeDebeEstarEntre0Y100#</cfoutput>";
      }


</SCRIPT>
<cf_qforms>
	<cf_qformsrequiredfield args="TDid,#LB_Retencion#">
	<cf_qformsrequiredfield args="Descripcion,#LB_Descripcion#">
	<cf_qformsrequiredfield args="SNcodigo,#LB_Socio#">
	<cf_qformsrequiredfield args="Porcentaje,#LB_Porcentaje#,vPorcentaje">
</cf_qforms>