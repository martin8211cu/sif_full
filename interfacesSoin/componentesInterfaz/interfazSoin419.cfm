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
<cfset Ecodigo			= #datosXML.row.Ecodigo.xmltext#>
<cfset Relacion	        = #datosXML.row.Relacion.xmltext#>
<cfset Nota 			= #datosXML.row.Nota.xmltext#>
<cfset Identificacion 	= #datosXML.row.Identificacion.xmltext#>

<!---****Validaciones de los campos que ingresan del XML****--->

<!--------             Ecodigo             ------------->
<!---Si no pasan el Ecodigo se toma el de la session---->
<cfif len(trim(Ecodigo)) eq 0 or Ecodigo eq -1>
  <cfset Ecodigo = #session.Ecodigo#>
 <cfelse>
	<cfquery name="rsEmpresa" datasource="#session.dsn#">
	 Select count(1) as cantidadE  from Empresa 
	 where Ecodigo = #Ecodigo#
	</cfquery>	
	<cfif rsEmpresa.cantidadE eq 0>
	   <cfthrow message="El código de la empresa no coincide con ninguna empresa. Proceso Cancelado!!">
	</cfif>
</cfif>

<!--------                 Id de la relación               ------------->
<!---Se comprueba si el id que se esta pasando de la relacion existe---->
<cfif len(trim(Relacion)) eq 0 or Relacion eq -1>
  <cfthrow message="Se debe de indicar el id del registro de relaciones de evaluación. Proceso Cancelado!!">
 <cfelse>
	<cfquery name="rsEmpresa" datasource="#session.dsn#">
	 Select count(1) as cantidadE  from RHEEvaluacionDes 
	 where RHEEid = #Relacion#
	</cfquery>	
	<cfif rsEmpresa.cantidadE eq 0>
	   <cfthrow message="El id del registro de relaciones de evaluación no es válido. Proceso Cancelado!!">
	</cfif>
</cfif>

<!--------                 Id de la relación               ------------->
<!---Se comprueba si la relación ya fue cerrada                     ---->
<cfif len(trim(Relacion)) eq 0 or Relacion eq -1>
  <cfthrow message="Se debe de indicar el id del registro de relaciones de evaluación. Proceso Cancelado!!">
 <cfelse>
	<cfquery name="rsEmpresa" datasource="#session.dsn#">
	 Select count(1) as cantidadE  from RHEEvaluacionDes 
	 where RHEEid = #Relacion#
	 and RHEEestado=3
	</cfquery>	
	<cfif rsEmpresa.cantidadE eq 0>
	   <cfthrow message="El registro de la relacion de evaluación no ha sido finalizado. Proceso Cancelado!!">
	</cfif>
</cfif>

<!--------             Cedula del Empleado              ------------->
<!---Se comprueba si el id que se esta pasando del empleado existe--->
<cfif len(trim(Identificacion)) eq 0 or Identificacion eq -1>
  <cfthrow message="Se debe de indicar la identificación del Colaborador. Proceso Cancelado!!">
 <cfelse>
	<cfquery name="rsEmpresa" datasource="#session.dsn#">
	 Select count(1) as cantidadE from DatosEmpleado 
	 where DEidentificacion =ltrim(rtrim('#Identificacion#'))
	</cfquery>	
	<cfif rsEmpresa.cantidadE eq 0>
	   <cfthrow message="El id del registro de relaciones de evaluación no es válido. Proceso Cancelado!!">
	 <cfelse>
	 	<cfquery name="rsEmpresa" datasource="#session.dsn#">
			 Select DEid from DatosEmpleado 
			 where DEidentificacion =ltrim(rtrim('#Identificacion#'))
			 and Ecodigo=#Ecodigo#
		</cfquery>	
		<cfset LvarDEid=#rsEmpresa.DEid#>
	</cfif>
</cfif>

<!--------                Nota Obtenida                 ------------->
<!---Se comprueba el registro de la nota                          --->
<cfif len(trim(Nota)) eq 0 or Nota eq -1>
  <cfthrow message="Se debe de indicar una nota válida. Proceso Cancelado!!">
 <cfelse>
	<cfif len(trim(Nota)) eq 0 or Nota lt 0>
	   <cfthrow message="La nota debe ser superior de cero. Proceso Cancelado!!">
	</cfif>
	<cfif len(trim(Nota)) eq 0 or Nota gt 100>
	   <cfthrow message="La nota no debe ser superior de cien. Proceso Cancelado!!">
	</cfif>
</cfif>

<!---Una vez que se terminan las comprobaciones se actualiza el campo correspondiente a la nota de otros--->
<cfquery name="rsUp" datasource="minisif">
	update RHListaEvalDes set RHLEpromotros =#Nota#
	where Ecodigo=#Ecodigo#
	and RHEEid=#Relacion#
	and DEid=#LvarDEid#
</cfquery>

