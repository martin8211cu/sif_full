<cfset def = QueryNew("Mcodigo")>

<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" default="#Session.DSN#" type="String"> <!--- Nombre de la conexión --->
<cfparam name="Attributes.form" default="form1" type="String"> <!--- Nombre del form --->
<cfparam name="Attributes.CPTcodigo" default="CPTcodigo" type="string"> <!--- Nombre del código de la moneda --->
<cfparam name="Attributes.empresa" default="#session.Ecodigo#" type="string"> <!--- Nombre del código de la moneda --->
<cfparam name="Attributes.llave" default="" type="string"> <!--- Nombre del código de la moneda --->

<!--- consultas --->
	<cfquery name="transacciones" datasource="#Attributes.Conexion#">
		select CPTcodigo, CPTdescripcion 
		from CPTransacciones 
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.empresa#">
		order by CPTcodigo
	</cfquery>
	
  <table width="" border="0" cellspacing="0" cellpadding="0">
		<tr>		
			<td nowrap><cfoutput>					
			<select name="#Attributes.CPTcodigo#">
				<option value="">- seleccionar -</option>
					</cfoutput>
					<cfoutput query="transacciones"> 
					  <option value="#transacciones.CPTcodigo#">#transacciones.CPTdescripcion#</option>
					</cfoutput>
				</select>
			</td>
			<td nowrap>&nbsp;</td>
		</tr>
  </table>

<cfif len(trim(Attributes.llave))>
	<script language="JavaScript1.2" type="text/javascript">
		<cfoutput>
			document.#Attributes.form#.#Attributes.CPTcodigo#.value = '#Attributes.llave#';
		</cfoutput>
	</script>
</cfif>