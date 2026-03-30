<cfquery name="rsACAportesTipoList" datasource="#session.dsn#">
    SELECT ACATid, ACATcodigo, ACATdescripcion
    FROM ACAportesTipo
    WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
</cfquery>
<cfparam name="Form.DEid" default="0">	
<cfparam name="Form.ACATid" default="0">	
<form action="registroCuentasAhorro.cfm" method="post" name="form1">
	<input type="hidden" name="Paso" value="#Form.Paso#"> 
	<table width="400" align="center" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<table cellpadding="4" cellspacing="0">
				<cfoutput>
					<tr>
						<td nowrap align="right"><strong>#LB_Asociado#:&nbsp;</strong></td>
						<td colspan="2"><cf_rhempleado idempleado="#Form.DEid#" asociado="true"></td>
					</tr>
					<tr>
						<td nowrap align="right"><strong>#LB_Tipo_de_Aporte#:&nbsp;</strong></td>
						<td colspan="2">
							<select name="ACATid">
								<cfloop query="rsACAportesTipoList">
								<option value="#ACATid#" <cfif ACATid EQ Form.ACATid>selected</cfif>>#ACATcodigo# #ACATdescripcion#</option>
								</cfloop>
							</select>
						</td>
					</tr>
					<cf_botones modo="ALTA" includebefore="" include="Siguiente" exclude="ALTA">
				</cfoutput>    
				</table>
			</td>
		</tr>
	</table>
</form>
<cf_qforms>
   	<cf_qformsrequiredfield args="DEid,#LB_Asociado#">
    <cf_qformsrequiredfield args="ACATid,#LB_Tipo_de_Aporte#">
</cf_qforms>
<cfoutput>
<script language="javascript" type="text/javascript">
	function funcSiguiente(){
		document.form1.Paso.value=#Form.Paso+1#;
		document.form1.action = "registroCuentasAhorro.cfm";
	}
</script>
</cfoutput>