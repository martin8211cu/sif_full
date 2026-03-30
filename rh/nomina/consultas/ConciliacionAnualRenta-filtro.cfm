<!--- CONSULTAS --->
	<!--- OBTIENE LOS DATOS DE LIQUIDACION DE RENTA DEL EMMPLEADO Y QUE NO SE HAYA APLICADO --->
	<cfquery name="rsEIRidsaplicados" datasource="#session.dsn#">
		select distinct EIRid 
	  	from RHLiquidacionRenta
	  	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		  and Estado = 30
	</cfquery>
	<cfquery name="rsIRs" datasource="sifcontrol">
		select a.EIRid, 
			<cf_dbfunction name="date_part"   args="mm, a.EIRdesde"> as mesDesde,
			<cf_dbfunction name="date_part"   args="yy, a.EIRdesde"> as periodoDesde,
			<cf_dbfunction name="date_part"   args="mm, a.EIRhasta"> as mesHasta,
			<cf_dbfunction name="date_part"   args="yy, a.EIRhasta"> as periodoHasta,
			b.IRcodigo, 
			b.IRdescripcion, a.EIRdesde, a.EIRhasta
		from EImpuestoRenta a
			inner join ImpuestoRenta b
			on a.IRcodigo = b.IRcodigo
		where <cf_whereInList Column="a.EIRid" ValueList="#ValueList(rsEIRidsaplicados.EIRid)#" cfsqltype="cf_sql_numeric">
	</cfquery>
	
<cfoutput>
	<table width="600" align="center">
		<cfif rsIRS.RecordCount>
		<tr>
			<td>
				<form action="ConciliacionAnualRenta.cfm" method="get" name="form1" style="margin:0">
					<table width="100%" align="center" border="0" cellpadding="0" cellspacing="0" style="margin:0">
						<tr><td colspan="2">&nbsp;</td></tr>
						<tr>
							<td align="right" nowrap="nowrap"><strong><cf_translate key="LB_TablasDeRenta">Tabla de Renta</cf_translate>:&nbsp;</strong>	</td>
							<td>
								<select name="EIRid" onchange="javascript:this.form.submit();">
									<cfloop query="rsIRs">
										<option value="#rsIRs.EIRid#" <cfif isdefined("form.EIRid") and form.EIRid eq rsIRs.EIRid>selected</cfif>>#rsIRs.IRcodigo#-#rsIRs.IRdescripcion# (#LSDateFormat(rsIRs.EIRdesde,'dd/mm/yyyy')#-#LSDateFormat(rsIRs.EIRhasta,'dd/mm/yyyy')#)</option>
									</cfloop>
								</select>
							</td>
						 </tr>
						<tr><th scope="row"  colspan="2" class="fileLabel"><cf_botones values="Ver">&nbsp;</th></tr>
					</table>
				</form>
			</td>
		</tr>
		<cfelse>
		<tr><td align="center">#LB_NOHAYLIQUIDACIONESDERENTAAPLICADAS#</td></tr>
		</cfif>
	</table>
<cfif rsIRS.RecordCount>
<cf_qforms>
	<cf_qformsrequiredfield name="EIRid" description="#LB_TablaDeRenta#">
</cf_qforms>
</cfif>
</cfoutput>