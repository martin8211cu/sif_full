<cfset modo = 'ALTA'>
<cfif isdefined("form.AreaEid") and len(trim(form.AreaEid))>
	<cfset modo = 'CAMBIO'>
	<cfquery name="rs_data" datasource="#session.DSN#">
		select AreaEid, CodArea, DescArea
		from AreaIndEncabezado a 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and AreaEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AreaEid#">
	</cfquery>
</cfif>
<cfquery name="rsCuantasAreas" datasource="#session.DSN#">
	select coalesce(count(1)+1 ,1) as cuantasAreas
	from AreaIndEncabezado
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
<cfset vs_codarea = 'A' & rsCuantasAreas.cuantasAreas>
<cfoutput>
<table width="100%" cellpadding="2" cellspacing="0">
	<!---Encabezado--->
	<tr>
		<td>
			<table width="100%" cellpadding="1" cellspacing="0">
				<form name="form1" method="post" action="areasindicador-sql.cfm" style="margin:0;">	
					<input type="hidden" name="AreaEid" value="<cfif modo neq 'ALTA'>#rs_data.AreaEid#</cfif>">
					<tr>
						<td><strong>#LB_CODIGO#:&nbsp;</strong></td>
						<td>
							<input type="text" name="CodArea" value="<cfif modo neq 'ALTA'>#rs_data.CodArea#<cfelse>#vs_codarea#</cfif>" maxlength="20" onfocus="javascript:this.select();" readonly=""><!---readonly=""--->
						</td>
					</tr>
					<tr>
						<td><strong>#LB_DESCRIPCION#:&nbsp;</strong></td>
						<td>
							<input type="text" name="DescArea" value="<cfif modo neq 'ALTA'>#rs_data.DescArea#</cfif>" size="30" maxlength="80" onfocus="javascript:this.select();" ><!---readonly=""--->
						</td>
					</tr>
					<tr>
						<td colspan="2" align="center"><cf_botones modo="#modo#"></td>
					</tr>	
				</form>
			</table>
		</td>
	</tr>
	<!---Detalle--->
	<cfif modo neq 'ALTA'>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td>
				<table width="100%" cellpadding="0" cellspacing="0">
					<tr><td style="padding:3px;" bgcolor="##CCCCCC"><strong><cf_translate key="LB_CtrsFuncionalesDelArea">Centros Funcionales del &Aacute;rea</cf_translate></strong></td></tr>		
					<tr>
						<td><cfinclude template="areasindicador-detalle-form.cfm"></td>
					</tr>
				</table>
			</td>
		</tr>
	</cfif>
</table>
<cf_qforms>
<script type="text/javascript" language="javascript1.2">
	objForm.CodArea.required = true;
	objForm.CodArea.description = "#LB_CODIGO#";
	objForm.DescArea.required = true;
	objForm.DescArea.description = "#LB_DESCRIPCION#";
</script>
</cfoutput>
