<!--- 	*** TAG DE Cuentas Cliente ***		
		*** Busca en CuentasBancos por CBcc: Cuenta Cliente ***
--->


<!--- Consulta por Defceto --->

<cfquery name="def" datasource="#Session.DSN#">
	<cfif  Session.dsinfo.TYPE eq 'oracle'>
		select -1  as valor from dual
	<cfelse>
		select -1 
	</cfif>
</cfquery>

<!--- Atributos --->
<cfparam name="Attributes.Conexion" default="#Session.DSN#" type="String"> <!--- Nombre de la conexión --->
<cfparam name="Attributes.form" default="form1" type="String"> <!--- Nombre del form --->
<cfparam name="Attributes.query" default="#def#" type="query"> <!--- consulta por defecto --->
<cfparam name="Attributes.frame" default="frCC" type="string"> <!--- Nombre del frame --->
<cfparam name="Attributes.tabindex" default="" type="string"> <!--- número del tabindex --->
<cfparam name="Attributes.onBlur" default="" type="string"> <!--- función en el evento onBlur --->
<cfparam name="Attributes.CBid" default="CBid" type="string"> <!--- CBid --->
<cfparam name="Attributes.Bid" default="Bid" type="string"> <!--- Bid --->
<cfparam name="Attributes.Ocodigo" default="Ocodigo" type="string"> <!--- Ocodigo --->
<cfparam name="Attributes.Mcodigo" default="Mcodigo" type="string"> <!--- CBcc --->
<cfparam name="Attributes.CBcodigo" default="CBcodigo" type="string"> <!--- CBcodigo --->
<cfparam name="Attributes.CBdescripcion" default="CBdescripcion" type="string"> <!--- CBdescripcion --->
<cfparam name="Attributes.CBcc" default="CBcc" type="string"> <!--- CBcc --->
<cfparam name="Attributes.sizeCBdescripcion" default="80" type="string"> <!--- Tamaño CBdescripcion --->
<cfparam name="Attributes.sizeCBcc" default="25" type="string"> <!--- Tamaño CBcc --->
<cfparam name="Attributes.valor" default="CBcc" type="string"> <!--- Valor CBcc, si viene lo busca y carga los valores respectivos. --->
<cfparam name="Attributes.CBTcodigo" default="CBTcodigo" type="string"> <!--- CBTcodigo --->
<cfparam name="Attributes.vMcodigo" default="-1" type="numeric"> <!--- Si va, filtra por Moneda con esta valor --->
<cfparam name="Attributes.Ecodigo" default="#session.Ecodigo#" type="numeric">
<!--- Consulta Cuenta Cliente --->
<cfif isDefined("Attributes.valor")>
	<cfquery name="rsCuentasCliente" datasource="#Session.DSN#">
		select 	CBid, 
				Bid, 
				Ocodigo, 
				Mcodigo, 
				CBcodigo, 
				CBdescripcion, 
				CBcc, 
				CBTcodigo
		from CuentasBancos
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.Ecodigo#">
        and CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
		and CBcc = <cfqueryparam cfsqltype="cf_sql_char" value="#Attributes.valor#">
		<cfif Attributes.vMcodigo neq -1>	
			and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.vMcodigo#">
		</cfif>
		order by CBcc, CBdescripcion
	</cfquery>
</cfif>
<!--- Arma los parámetros para pasarlos al query y al conlis --->
<cfset params="">
<cfset params=params&"Conexion="&#Attributes.Conexion#>
<cfset params=params&"&Ecodigo="&#Attributes.Ecodigo#>
<cfset params=params&"&form="&#Attributes.form#>
<cfset params=params&"&vMcodigo="&#Attributes.vMcodigo#>
<cfset params=params&"&CBid="&#Attributes.CBid#>
<cfset params=params&"&Bid="&#Attributes.Bid#>
<cfset params=params&"&Ocodigo="&#Attributes.Ocodigo#>
<cfset params=params&"&Mcodigo="&#Attributes.Mcodigo#>
<cfset params=params&"&CBcodigo="&#Attributes.CBcodigo#>
<cfset params=params&"&CBdescripcion="&#Attributes.CBdescripcion#>
<cfset params=params&"&CBcc="&#Attributes.CBcc#>
<cfset params=params&"&CBTcodigo="&#Attributes.CBTcodigo#>
<!--- Funciones JavaScript --->
<script language="JavaScript" type="text/javascript">
	//Obtiene La Información de la Cuenta a Través de CBcc
	<cfoutput>
	function Trae#Attributes.CBcc#(CBcc) {
		document.all["#Attributes.frame#"].src="/cfmx/sif/Utiles/sifCuentaClientequery.cfm?#params#&valor="+CBcc;
		return;
	}
	</cfoutput>
</script>
<!--- --->
<table width="" border="0" cellspacing="0" cellpadding="0">
	<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>
		<cfset CBid= "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.CBid')#')#')">
		<cfset Bid= "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.Bid')#')#')">
		<cfset Ocodigo= "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.Ocodigo')#')#')">
		<cfset MOcodigo= "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.Mcodigo')#')#')">		
		<cfset CBcodigo= "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.CBcodigo')#')#')">
		<cfset CBdescripcion= "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.CBdescripcion')#')#')">
		<cfset CBcc= "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.CBcc')#')#')">
		<cfset CBTcodigo= "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.CBTcodigo')#')#')">
	</cfif>
	<cfoutput>
		<td nowrap>
			<input 	type="text" 
					name="#Attributes.CBcc#" 
					id="#Attributes.CBcc#" 
					maxlength="25" 
					size="#Attributes.sizeCBcc#" 
					onblur="javascript:Trae#Attributes.CBcc#(this.value);#Attributes.onBlur#"
					onfocus="this.select()"				
					value="<cfif isdefined("Attributes.query") and ListLen(Attributes.query.columnList) GT 1>#CBcc#<cfelseif isDefined("rsCuentasCliente") and rsCuentasCliente.RecordCount eq 1>#CBcc#</cfif>"
					tabindex="#Attributes.tabindex#">
					
			<input 	type="text" 
					name="#Attributes.CBdescripcion#" 
					id="#Attributes.CBdescripcion#" 
					maxlength="25" 
					size="#Attributes.sizeCBdescripcion#" 
					value="<cfif isdefined("Attributes.query") and ListLen(Attributes.query.columnList) GT 1>#CBdescripcion#<cfelseif isDefined("rsCuentasCliente") and rsCuentasCliente.RecordCount eq 1>#CBdescripcion#</cfif>"
					readonly="true"
					disabled="true"
					tabindex="-1">
										
			<cf_popup 
					url="/cfmx/sif/Utiles/conlisCuentasCliente.cfm?#params#"
					link="+"
					boton="true" width="650" height="350" left="250" top="200" resize="no" ejecutar="no"
					tabindex = "-1">
					
		</td>
		<input type="hidden" name="#Attributes.CBid#" id="#Attributes.CBid#" value="<cfif isdefined("Attributes.CBid") and ListLen(Attributes.query.columnList) GT 1>#CBid#<cfelseif isDefined("rsCuentasCliente") and rsCuentasCliente.RecordCount eq 1>#CBid#</cfif>">
		<input type="hidden" name="#Attributes.Bid#" id="#Attributes.Bid#" value="<cfif isdefined("Attributes.Bid") and ListLen(Attributes.query.columnList) GT 1>#Bid#<cfelseif isDefined("rsCuentasCliente") and rsCuentasCliente.RecordCount eq 1>#Bid#</cfif>">
		<input type="hidden" name="#Attributes.Ocodigo#" id="#Attributes.Ocodigo#" value="<cfif isdefined("Attributes.Ocodigo") and ListLen(Attributes.query.columnList) GT 1>#Ocodigo#<cfelseif isDefined("rsCuentasCliente") and rsCuentasCliente.RecordCount eq 1>#Ocodigo#</cfif>">
		<input type="hidden" name="#Attributes.Mcodigo#" id="#Attributes.Mcodigo#" value="<cfif isdefined("Attributes.Mcodigo") and ListLen(Attributes.query.columnList) GT 1>#Mcodigo#<cfelseif isDefined("rsCuentasCliente") and rsCuentasCliente.RecordCount eq 1>#Mcdoigo#</cfif>">
		<input type="hidden" name="#Attributes.CBcodigo#" id="#Attributes.CBcodigo#" value="<cfif isdefined("Attributes.CBcodigo") and ListLen(Attributes.query.columnList) GT 1>#CBcodigo#<cfelseif isDefined("rsCuentasCliente") and rsCuentasCliente.RecordCount eq 1>#CBcodigo#</cfif>">
		<input type="hidden" name="#Attributes.CBTcodigo#" id="#Attributes.CBTcodigo#" value="<cfif isdefined("Attributes.CBTcodigo") and ListLen(Attributes.query.columnList) GT 1>#CBTcodigo#<cfelseif isDefined("rsCuentasCliente") and rsCuentasCliente.RecordCount eq 1>#CBTcodigo#</cfif>">
	</cfoutput>
</table>
<!--- iframe para la ejecición de la consulta cuando escriben --->
<iframe name="<cfoutput>#Attributes.frame#</cfoutput>" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="/cfmx/sif/Utiles/sifCuentaClientequery.cfm" ></iframe>
