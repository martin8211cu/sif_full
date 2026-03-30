<!--- 
	Se debe utilizar al FINAL cuando la instrucción SQL finaliza con una clausula diferente a WHERE
	<cfquery ...>
		<cf_dbrowcount1 ...>
		select CAMPOS
		  from TABLA
		 where CONDICION
		<cf_dbrowcount2_a ...>
		 order by CAMPOS_ORDEN
		<cf_dbrowcount2_b ...>
	</cfquery>
 --->
<cfparam name="Attributes.rows" type="numeric" default="100">
<cfparam name="Attributes.datasource" type="string" default="">
 
<!--- Validar el datasource --->
<cfif Len(Attributes.datasource) Is 0>
	<cfif IsDefined('session.dsn') and Len(session.dsn) neq 0>
		<cfset Attributes.datasource = session.dsn>
	<cfelse>
		<cf_errorCode	code = "50597" msg = "Falta el atributo datasource, y session.dsn no está definida.">
	</cfif>
</cfif>

<!--- Asegurarse de que la informacion sobre las conexiones este disponible --->
<cfif not StructKeyExists(Application.dsinfo, Attributes.datasource)>
<cfinvoke component="home.Componentes.DbUtils" method="generate_dsinfo" datasource="#Attributes.datasource#"  />
</cfif>
<cfif not StructKeyExists(Application.dsinfo, Attributes.datasource)>
	<cf_errorCode	code = "50599"
					msg  = "Datasource no definido: @errorDat_1@"
					errorDat_1="#HTMLEditFormat(Attributes.datasource)#"
	>
</cfif>

<cfif ListFind('sybase,sqlserver', Application.dsinfo[Attributes.datasource].type)>
	set rowcount 0
<cfelseif Application.dsinfo[Attributes.datasource].type is 'oracle'>
	<!--- Oracle finaliza en dbrowcount2_a --->
<cfelseif Application.dsinfo[Attributes.datasource].type is 'db2'>
	FETCH FIRST <cfoutput>#Attributes.rows#</cfoutput> ROWS ONLY
<cfelse>
	<cf_errorCode	code = "50628"
					msg  = "DBMS no soportado: @errorDat_1@"
					errorDat_1="#Application.dsinfo[Attributes.datasource].type#"
	>
</cfif>


