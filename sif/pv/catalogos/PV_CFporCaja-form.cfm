<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_SeleccioneElCentroFuncional"
	Default="Seleccione el Centro Funcional"
	returnvariable="MSG_SeleccioneElCentroFuncionalResponsable"/>
	
<cfquery name="FAM001" datasource="#session.DSN#">
	select FAM01COD, FAM01CODD, FAM01DES 
	from FAM001
	where Ecodigo = #session.Ecodigo#
</cfquery>

<cfif modo EQ "cambio">
	<cfquery name="CajaCentroFuncional" datasource="#session.DSN#">
		select a.PVCajaCFid,a.Ecodigo,a.FAM01COD,a.CFid,a.CFcodigo, b.CFdescripcion, a.ts_rversion
		from CajaCentroFuncional a
			inner join CFuncional b
				on a.CFid = b.CFid
		where a.PVCajaCFid = #form.PVCajaCFid#
	</cfquery>
	<cfset CFid = #CajaCentroFuncional.CFid#>
</cfif>

<form name="form1" method="post" action="PV_CFporCaja-sql.cfm">
	<cfif modo EQ "cambio">
		<input name="PVCajaCFid"  type="hidden" value="<cfoutput>#CajaCentroFuncional.PVCajaCFid#"</cfoutput>/>
		<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp= "#CajaCentroFuncional.ts_rversion#" returnvariable="ts">
		<input name="ts_rversion" type="hidden" value="<cfoutput>#ts#"</cfoutput>/>
	</cfif>
	<table width="100%" cellspacing="0" border="0">
		<tr>
			<td align="right">
				Caja:
			</td>
			<td align="left">
				<cfoutput>
					<select name="FAM01COD">
						<cfloop query="FAM001">
							<option value="#FAM001.FAM01COD#"<cfif isdefined('CajaCentroFuncional') and CajaCentroFuncional.FAM01COD EQ FAM001.FAM01COD> selected="selected"</cfif>>#FAM001.FAM01CODD#-#FAM001.FAM01DES#</option>
						</cfloop>
					</select>
				</cfoutput>
			</td>
		</tr>
		<tr>
			<td align="right">
				Centro Funcional:
			<td>
				<cfif modo EQ 'alta'>
					<cf_rhcfuncional tabindex="1" form="form1" size="30" id="CFid" name="CFcodigo" titulo="#MSG_SeleccioneElCentroFuncionalResponsable#" excluir="-1">
				<cfelse>
					<cf_rhcfuncional tabindex="1" form="form1" size="30" query="#CajaCentroFuncional#" id="CFid" name="CFcodigo" titulo="#MSG_SeleccioneElCentroFuncionalResponsable#" excluir="-1">
				</cfif>
		</tr>
		<tr>
			<td colspan="2" align="center">
				<cf_botones modo='#modo#' tabindex="1">
			</td>
		</tr>
	</table>
</form>
<cf_qforms>
		<cf_qformsRequiredField name="FAM01COD" description="Caja">
		<cf_qformsRequiredField name="CFid" description="Centro Funcional">
</cf_qforms>
