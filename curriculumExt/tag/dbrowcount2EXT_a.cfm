<!--- 
	Se debe utilizar en el WHERE cuando la instrucción SQL finaliza con una clausula diferente a WHERE
	<cfquery ...>
		<cf_dbrowcount1EXT ...>
		select CAMPOS
		  from TABLA
		 where CONDICION
		<cf_dbrowcount2EXT_a ...>
		 order by CAMPOS_ORDEN
		<cf_dbrowcount2EXT_b ...>
	</cfquery>
 --->
<cfparam name="Attributes.rows" type="numeric" default="100">
<cfparam name="Attributes.datasource" type="string" default="">

<!--- Validar el datasource --->
<cfif Len(Attributes.datasource) Is 0>
	<cfif IsDefined('session.dsn') and Len(session.dsn) neq 0>
		<cfset Attributes.datasource = session.dsn>
	<cfelse>
		<cfthrow message="Falta el atributo datasource, y session.dsn no est&aacute; definida.">
	</cfif>
</cfif>

<!--- Asegurarse de que la informacion sobre las conexiones este disponible --->
<cfif not StructKeyExists(Application.dsinfo, Attributes.datasource)>
<cfinvoke component="home.Componentes.DbUtils" method="generate_dsinfo" datasource="#Attributes.datasource#"  />
</cfif>
<cfif not StructKeyExists(Application.dsinfo, Attributes.datasource)>
	<cfthrow message="Datasource no definido: #HTMLEditFormat(Attributes.datasource)#">
</cfif>

<cfif ListFind('sybase,sqlserver', Application.dsinfo[Attributes.datasource].type)>
	<!--- Sybase, sqlserver finaliza en dbrowcount2_b --->
<cfelseif Application.dsinfo[Attributes.datasource].type is 'oracle'>
	and rownum <= <cfoutput>#Attributes.rows#</cfoutput>
<cfelseif Application.dsinfo[Attributes.datasource].type is 'db2'>
<cfelse>
	<cfthrow message="DBMS no soportado: #Application.dsinfo[Attributes.datasource].type#">
</cfif>
