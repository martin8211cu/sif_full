<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
<!--- 
<cfif listLen(GvarXML_IE) eq 1>
	<cfthrow message="Error:#GvarXML_IE#">
</cfif> --->


<cfset XMLD = xmlParse(GvarXML_IE) />
<cfset Datos = xmlSearch(XMLD,'/resultset/row')>
<cfset datosXML = xmlparse(Datos[1]) />


<!---Traigo los datos del XML   #datosXML.row.Ecodigo.xmltext#>--->
<cfset LvarEcodigo			= #datosXML.row.LvarEcodigo.xmltext#>
<cfset LvarRelacion	        = #datosXML.row.LvarRelacion.xmltext#>
<cfset LvarNota 			= #datosXML.row.LvarNota.xmltext#>
<cfset Lvaridentificacion 	= #datosXML.row.Lvaridentificacion.xmltext#>

<!---****Validaciones de los campos que ingresan del XML****--->

<!--------             Ecodigo             ------------->
<!---Si no pasan el Ecodigo se toma el de la session---->
<cfif len(trim(LvarEcodigo)) eq 0 or LvarEcodigo eq -1>
  <cfset LvarEcodigo = #session.Ecodigo#>
 <cfelse>
	<cfquery name="rsEmpresa" datasource="#session.dsn#">
	 Select count(1) as cantidadE  from Empresa 
	 where Ecodigo = #LvarEcodigo#
	</cfquery>	
	<cfif rsEmpresa.cantidadE eq 0>
	   <cfthrow message="El código de la empresa no coincide con ninguna empresa. Proceso Cancelado!!">
	</cfif>
</cfif>

<!--------                 Id de la relación               ------------->
<!---Se comprueba si el id que se esta pasando de la relacion existe---->
<cfif len(trim(LvarRelacion)) eq 0 or LvarRelacion eq -1>
  <cfthrow message="Se debe de indicar el id del registro de relaciones de evaluación. Proceso Cancelado!!">
 <cfelse>
	<cfquery name="rsEmpresa" datasource="#session.dsn#">
	 Select count(1) as cantidadE  from RHEEvaluacionDes 
	 where RHEEid = #LvarRelacion#
	</cfquery>	
	<cfif rsEmpresa.cantidadE eq 0>
	   <cfthrow message="El id del registro de relaciones de evaluación no es válido. Proceso Cancelado!!">
	</cfif>
</cfif>

<!--------                 Id de la relación               ------------->
<!---Se comprueba si la relación ya fue cerrada                     ---->
<cfif len(trim(LvarRelacion)) eq 0 or LvarRelacion eq -1>
  <cfthrow message="Se debe de indicar el id del registro de relaciones de evaluación. Proceso Cancelado!!">
 <cfelse>
	<cfquery name="rsEmpresa" datasource="#session.dsn#">
	 Select count(1) as cantidadE  from RHEEvaluacionDes 
	 where RHEEid = #LvarRelacion#
	 and RHEEestado=3
	</cfquery>	
	<cfif rsEmpresa.cantidadE eq 0>
	   <cfthrow message="El registro de la relacion de evaluación no ha sido finalizado. Proceso Cancelado!!">
	</cfif>
</cfif>

<!--------             Cedula del Empleado              ------------->
<!---Se comprueba si el id que se esta pasando del empleado existe--->
<cfif len(trim(Lvaridentificacion)) eq 0 or Lvaridentificacion eq -1>
  <cfthrow message="Se debe de indicar la identificación del Colaborador. Proceso Cancelado!!">
 <cfelse>
	<cfquery name="rsEmpresa" datasource="#session.dsn#">
	 Select count(1) as cantidadE from DatosEmpleado 
	 where DEidentificacion =ltrim(rtrim('#Lvaridentificacion#'))
	</cfquery>	
	<cfif rsEmpresa.cantidadE eq 0>
	   <cfthrow message="El id del registro de relaciones de evaluación no es válido. Proceso Cancelado!!">
	 <cfelse>
	 	<cfquery name="rsEmpresa" datasource="#session.dsn#">
			 Select DEid from DatosEmpleado 
			 where DEidentificacion =ltrim(rtrim('#Lvaridentificacion#'))
			 and Ecodigo=#LvarEcodigo#
		</cfquery>	
		<cfset LvarDEid=#rsEmpresa.DEid#>
	</cfif>
</cfif>

<!--------                Nota Obtenida                 ------------->
<!---Se comprueba el registro de la nota                          --->
<cfif len(trim(LvarNota)) eq 0 or LvarNota eq -1>
  <cfthrow message="Se debe de indicar una nota válida. Proceso Cancelado!!">
 <cfelse>
	<cfif len(trim(LvarNota)) eq 0 or LvarNota lt 0>
	   <cfthrow message="La nota debe ser superior de cero. Proceso Cancelado!!">
	</cfif>
	<cfif len(trim(LvarNota)) eq 0 or LvarNota gt 100>
	   <cfthrow message="La nota no debe ser superior de cien. Proceso Cancelado!!">
	</cfif>
</cfif>

<!---Una vez que se terminan las comprobaciones se actualiza el campo correspondiente a la nota de otros--->
<cfquery name="rsUp" datasource="minisif">
	update RHListaEvalDes set RHLEpromotros =#LvarNota#
	where Ecodigo=#LvarEcodigo#
	and RHEEid=#LvarRelacion#
	and DEid=#LvarDEid#
</cfquery>

