<cfset def = QueryNew("Bid")>

<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" default="#Session.DSN#" type="String"> <!--- Nombre de la conexión --->
<cfparam name="Attributes.form" default="form1" type="String"> <!--- Nombre del form --->
<cfparam name="Attributes.Bid" default="Bid" type="string"> <!--- Nombre del código de la moneda --->
<cfparam name="Attributes.empresa" default="#session.Ecodigo#" type="string"> <!--- Nombre del código de la moneda --->
<cfparam name="Attributes.llave" default="" type="string"> <!--- Nombre del código de la moneda --->

<!--- consultas --->
	<cfquery name="bancos" datasource="#Attributes.Conexion#">
		select Bid, Bdescripcion 
		from Bancos
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.empresa#">
		order by Bdescripcion
	</cfquery>
	
  <table width="" border="0" cellspacing="0" cellpadding="0">
		<tr>		
			<td nowrap><cfoutput>					
			<select name="#Attributes.Bid#">
				<option value="">- seleccionar -</option>
					</cfoutput>
					<cfoutput query="bancos"> 
					  <option value="#bancos.Bid#">#bancos.Bdescripcion#</option>
					</cfoutput>
				</select>
			</td>
			<td nowrap>&nbsp;</td>
		</tr>
  </table>

<cfif len(trim(Attributes.llave))>
	<script language="JavaScript1.2" type="text/javascript">
		<cfoutput>
			document.#Attributes.form#.#Attributes.Bid#.value = '#Attributes.llave#';
		</cfoutput>
	</script>
</cfif>