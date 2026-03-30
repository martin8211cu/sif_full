<cfcomponent>
  <cffunction name="describeClase" returntype="string" output="false">
    <cfargument name="es_documento" type="boolean">
    <cfargument name="clase_tipo"   type="string">
    <cfargument name="tipo_dato"    type="string">
    <cfargument name="nombre_tabla" type="string">
    <cfif Arguments.es_documento>
      <cfreturn 'Documento'>
    </cfif>
    <cfif Arguments.clase_tipo EQ 'S'>
      <cfreturn 'Simple'>
    </cfif>
    <cfif Arguments.clase_tipo EQ 'L'>
      <cfreturn 'Lista Valores'>
    </cfif>
    <cfif Arguments.clase_tipo EQ 'T'>
      <cfreturn 'Concepto Interno'>
    </cfif>
    <cfif Arguments.clase_tipo EQ 'C'>
      <cfreturn 'Complejo'>
    </cfif>
    <cfreturn ''>
  </cffunction>
  <cffunction name="describeTipo" returntype="string" output="false">
    <cfargument name="es_documento" type="boolean">
    <cfargument name="clase_tipo"   type="string">
    <cfargument name="tipo_dato"    type="string">
    <cfargument name="nombre_tabla" type="string">
    <cfargument name="longitud"     type="string">
    <cfargument name="escala"       type="string">
    <cfargument name="nombre_documento" type="string">
    <cfif Arguments.es_documento >
      <cfreturn Arguments.nombre_documento>
    </cfif>
    <cfif Arguments.clase_tipo EQ 'S' and Arguments.tipo_dato EQ 'F'>
      <cfreturn 'Fecha'>
    </cfif>
    <cfif Arguments.clase_tipo EQ 'S' and Arguments.tipo_dato EQ 'N'>
      <cfset retval = 'Número'>
      <cfif Len(Arguments.longitud)>
        <cfset retval = retval & '(' & Arguments.longitud >
      </cfif>
      <cfif Len(Arguments.escala)>
        <cfset retval = retval & ',' & Arguments.escala >
      </cfif>
      <cfif Len(Arguments.longitud)>
        <cfset retval = retval & ')' >
      </cfif>
      <cfreturn retval>
    </cfif>
    <cfif Arguments.clase_tipo EQ 'S' and Arguments.tipo_dato EQ 'B'>
      <cfreturn 'Sí/No'>
    </cfif>
    <cfif Arguments.clase_tipo EQ 'S' and Arguments.tipo_dato EQ 'S'>
      <cfset retval = 'Alfanumérico'>
      <cfif Len(Arguments.longitud)>
        <cfset retval = retval & '(' & Arguments.longitud >
      </cfif>
      <cfif Len(Arguments.escala)>
        <cfset retval = retval & ',' & Arguments.escala >
      </cfif>
      <cfif Len(Arguments.longitud)>
        <cfset retval = retval & ')' >
      </cfif>
      <cfreturn retval>
      <cfreturn 'Alfanumérico'>
    </cfif>
    <cfif Arguments.clase_tipo EQ 'L'>
      <cfreturn ' '>
    </cfif>
    <cfif Arguments.clase_tipo EQ 'C'>
      <cfreturn ' '>
    </cfif>
    <cfif Arguments.clase_tipo EQ 'T'>
      <cfreturn Arguments.nombre_tabla>
    </cfif>
    <cfreturn ''>
  </cffunction>
  <cffunction name="describeClaseyTipo" returntype="string" output="false">
    <cfargument name="es_documento" type="boolean">
    <cfargument name="clase_tipo"   type="string">
    <cfargument name="tipo_dato"    type="string">
    <cfargument name="nombre_tabla" type="string">
    <cfargument name="longitud"     type="string">
    <cfargument name="escala"       type="string">
    <cfargument name="nombre_documento" type="string">
    <cfif ListFind('L,C', Arguments.clase_tipo ) and not Arguments.es_documento>
      <cfreturn This.describeClase(
		Arguments.es_documento,
		Arguments.clase_tipo,
		Arguments.tipo_dato,
		Arguments.nombre_tabla,
		Arguments.longitud,
		Arguments.escala,
		Arguments.nombre_documento)>
    </cfif>
    <cfreturn This.describeTipo(
		Arguments.es_documento,
		Arguments.clase_tipo,
		Arguments.tipo_dato,
		Arguments.nombre_tabla,
		Arguments.longitud,
		Arguments.escala,
		Arguments.nombre_documento)>
  </cffunction>
</cfcomponent>
