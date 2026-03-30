<style type="text/css">
<!--
.style3 {font-weight: bold}
-->
</style>

	<form action="benempl.cfm" name="formFiltro" method="post">
		<input type="hidden" name="Mcodigo" value="">
		<input type="hidden" name="BEmonto" value="">
		<input type="hidden" name="BEporcemp" value="">
		<input type="hidden" name="Btercero" value="">
		<input type="hidden" name="SNcodigo" value="">
		<input type="hidden" name="SNnumero" value="">		
		<input type="hidden" name="SNnombre" value="">		
		<cfoutput>
			<table width="100%" border="0" class="areaFiltro">
				<tr>				
				    <td colspan="2">&nbsp;</td>
				</tr>							
				<tr>
					<td width="24%" align="right"><span class="style3">Beneficio:</span></td>
					<td width="39%">
						<cfif isdefined('form.btnFiltrar') and isdefined('form.Bid') and form.Bid NEQ ''>
							<cfquery name="rsBenef" datasource="#session.DSN#">
								Select Bcodigo,Bdescripcion
								from RHBeneficios
								where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
									and Bid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Bid#">
							</cfquery>
							<cfif isdefined('rsBenef') and rsBenef.recordCount GT 0>
								<cf_rhbeneficio form="formFiltro" query="#rsBenef#">
							</cfif>
						<cfelse>
							<cf_rhbeneficio form="formFiltro">
						</cfif>
				  	</td>
				    <td width="37%" align="center">
						<input name="btnFiltrar" type="submit" id="btnFiltrar2" value="Consultar">
					</td>
				</tr>
				<tr>				
				    <td colspan="2">&nbsp;</td>
				</tr>				
			</table>
	  </cfoutput>			
	</form>
	
	<cfif isdefined('form.btnFiltrar') and isdefined('form.Bid')>
		<table width="100%" border="0" align="center">
			<tr>
				<td>
					<cfif isdefined('form.Bid') and form.Bid NEQ ''>
						<cf_rhimprime datos="/rh/beneficios/consultas/benempl-form.cfm" paramsuri="&Bid=#form.Bid#">
					<cfelse>
						<cf_rhimprime datos="/rh/beneficios/consultas/benempl-form.cfm">
					</cfif>
					<cf_sifHTML2Word>
                    	<cfinclude template="benempl-form.cfm">
					</cf_sifHTML2Word>	
				</td>
			</tr>
		</table>
	</cfif>
