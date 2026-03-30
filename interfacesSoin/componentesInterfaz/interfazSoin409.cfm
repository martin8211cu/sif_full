<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>

<!--- <cfif listLen(GvarXML_IE) NEQ 1>
	<cfthrow message="Solo se requiere un Dato de entrada y es el Formato: Cformato">
</cfif>
<cfset LvarCformato		= listGetAt(GvarXML_IE,1)> --->

<cfset XMLD = xmlParse(GvarXML_IE) />
<cfset Datos = xmlSearch(XMLD,'/resultset/row')>
<cfset datosXML = xmlparse(Datos[1]) />

<cfset LvarCformato	 = #datosXML.row.LvarCformato.xmltext#>

<cfquery name="rsSQL" datasource="#session.dsn#">
	Select Cformato 
	  from CContables
	 where Ecodigo	= #session.Ecodigo#
	  and Cformato= '#LvarCformato#'
</cfquery>

<cfif rsSQL.recordcount EQ 0>
	<cfthrow message="El formato '#LvarCformato#' no está definido en las cuentas de la Empresa">
</cfif>

<cfquery name="rsSQL" datasource="#session.dsn#">
	Select 
	    Cformato,
	    Cdescripcion,
	    Cbalancen,
		Cmovimiento
	  from CContables
	 where Ecodigo	= #session.Ecodigo#
	  and Cformato= '#LvarCformato#'
</cfquery>

<cfset GvarXML_OE = "<recordset>
    <row>
        <Empresa>#session.Ecodigo#</Empresa>
        <Formato>#rsSQL.Cformato#</Formato>
		<Descripcion>#rsSQL.Cdescripcion#</Descripcion>
		<Balance>#rsSQL.Cbalancen#</Balance>
		<Movimiento>#rsSQL.Cmovimiento#</Movimiento>  
    </row>
<recordset>
">

