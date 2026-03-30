<cfsetting enablecfoutputonly="yes">

<!---cuando el FPTVTipo = 05 no se toma en cuenta las estimaciones--->

<cfif isdefined('url.FPTVTipo') and len(trim(url.FPTVTipo))>
	<cfquery datasource="#Session.DSN#" name="rsID_cuenta">
		select distinct b.FPTVTipo,FPTVDescripcion 
		from FPEEstimacion a
			inner join TipoVariacionPres b
			on b.FPTVid = a.FPTVid
		where a.Ecodigo = #session.Ecodigo#
	<cfif isdefined('url.FPTVTipo') and #url.FPTVTipo# eq 01>
			and  b.FPTVTipo in (-1)
		<cfelseif isdefined('url.FPTVTipo') and #url.FPTVTipo# eq 02>
			and  b.FPTVTipo in (0)
		<cfelseif isdefined('url.FPTVTipo') and #url.FPTVTipo# eq 03>
			and  b.FPTVTipo in (1,2,3)
		<cfelseif isdefined('url.FPTVTipo') and #url.FPTVTipo# eq 04>
			and  b.FPTVTipo in (1,2,3)
		<cfelseif isdefined('url.FPTVTipo') and #url.FPTVTipo# eq 06>
			and b.FPTVTipo in (1,2,3)	
		</cfif>	
	</cfquery>

	<tr>
		<td colspan="4" align="center">
			<cfset control = 0>
				<fieldset style="width:85%">
				<legend>Cuentas</legend>	
						<table cellspacing="2">
						<cfif isdefined('url.FPTVTipo') and #url.FPTVTipo# neq 05>
							<cfloop query="rsID_cuenta">
								<cfif control eq 0>
								<tr>
								</cfif>
									<td>
										<div id="contenedor_Cuenta">
											<cfoutput><input type="checkbox" name="dato" tabindex="1" value="#rsID_cuenta.FPTVTipo#"></cfoutput>
										</div>
									</td>
									<td><cfoutput>#rsID_cuenta.FPTVDescripcion#&nbsp;&nbsp;&nbsp;</cfoutput></td>
								<cfif control eq 1>
								</tr>
									<cfset control = 0>
								<cfelse>
										<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
								<cfset control = 1>
							</cfif>
						</cfloop>
						</cfif>
						</table>
			<cfif control eq 1>
		</td>
	</tr>
			</cfif>
</cfif>


			
			
	
			