<cfset def = QueryNew("Mcodigo")>

<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" default="#Session.DSN#" type="String"> <!--- Nombre de la conexión --->
<cfparam name="Attributes.form" default="form1" type="String"> <!--- Nombre del form --->
<cfparam name="Attributes.BTid" default="BTid" type="string"> <!--- Nombre del código de la moneda --->
<cfparam name="Attributes.BTcodigo" default="BTcodigo" type="string"> <!--- Nombre del código de la moneda --->
<cfparam name="Attributes.empresa" default="#session.Ecodigo#" type="string"> <!--- Nombre del código de la moneda --->
<cfparam name="Attributes.llave" default="" type="string"> <!--- Nombre del código de la moneda --->

<!--- consultas --->
	<cfquery name="transacciones" datasource="#Attributes.Conexion#">
		select BTid, BTcodigo, BTdescripcion 
		from BTransacciones 
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.empresa#">
		order by BTcodigo
	</cfquery>
	
  <table width="" border="0" cellspacing="0" cellpadding="0">
		<tr>		
			<td nowrap><cfoutput>					
			<select name="#Attributes.BTid#">
				<option value="">- seleccionar -</option>
					</cfoutput>
					<cfoutput query="transacciones"> 
					  <option value="#transacciones.BTid#">#trim(transacciones.BTcodigo)# - #transacciones.BTdescripcion#</option>
					</cfoutput>
				</select>
			</td>
			<td nowrap>&nbsp;</td>
		</tr>
  </table>

<cfif len(trim(Attributes.llave))>
	<script language="JavaScript1.2" type="text/javascript">
		<cfoutput>
			document.#Attributes.form#.#Attributes.BTid#.value = '#Attributes.llave#';
		</cfoutput>
	</script>
</cfif>