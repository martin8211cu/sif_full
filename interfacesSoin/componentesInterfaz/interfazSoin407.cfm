<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>

<!--- <cfif listLen(GvarXML_IE) neq 4>
	<cfthrow message="Los Datos de entrada son periodo">
</cfif>

<cfset LvarCconcepto		= listGetAt(GvarXML_IE,1)>
<cfset LvarEperiodo   		= listGetAt(GvarXML_IE,2)>
<cfset LvarEmes				= listGetAt(GvarXML_IE,3)>
<cfset LvarEdocbase			= listGetAt(GvarXML_IE,4)> --->

<cfset XMLD = xmlParse(GvarXML_IE) />
<cfset Datos = xmlSearch(XMLD,'/resultset/row')>
<cfset datosXML = xmlparse(Datos[1]) />

<cfset LvarCconcepto = #datosXML.row.LvarCconcepto.xmltext#> 
<cfset LvarEperiodo	 = #datosXML.row.LvarEperiodo.xmltext#>
<cfset LvarEmes		 = #datosXML.row.LvarEmes.xmltext#>
<cfset LvarEdocbase	 = #datosXML.row.LvarEdocbase.xmltext#>

<cfquery name="rsSQL" datasource="#session.dsn#">
	Select ECIid 
	  from EContablesImportacion   
	 where Ecodigo		=#session.Ecodigo#
	 	and Eperiodo	=#LvarEperiodo#
	  	and Cconcepto 	=#LvarCconcepto#
	  	and Emes   		=#LvarEmes#
		and Edocbase	='#LvarEdocbase#'
</cfquery>

<cfif rsSQL.recordcount EQ 0>
	<cfthrow message="No existe el Asiento contable para el periodo: #LvarEperiodo#, mes: #LvarEmes# , concepto: #LvarCconcepto# y docBase: #LvarEdocbase#" >
<cfelseif rsSQL.recordcount gt 1>
	<cfthrow message="No se puede eliminar el asiento pues existe mas de un asiento contables para el periodo: #LvarEperiodo#, mes: #LvarEmes# , concepto: #LvarCconcepto# y docBase: #LvarEdocbase#
	<br> si el problema persiste puede eliminar el asiento manualmente en 
	<br> contabilidad general->importadores->importacion de documentos->buscar el asiento e eliminarlo ">
</cfif>


<cfquery datasource="#session.dsn#">
	delete from DContablesImportacion
		where ECIid=#rsSQL.ECIid#
		and Ecodigo=#session.Ecodigo#
</cfquery>
<cfquery datasource="#session.dsn#">
	delete from EContablesImportacion
		where ECIid=#rsSQL.ECIid#
		and Ecodigo=#session.Ecodigo#
</cfquery>
