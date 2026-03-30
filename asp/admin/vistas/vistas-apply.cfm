<cf_templateheader title="Creando Vistas"><cf_web_portlet_start titulo="Creando Vistas">
<cfinclude template="/home/menu/pNavegacion.cfm">


<cfinclude template="vistas-list.cfm">

<cfinvoke component="home.Componentes.DbUtils" method="generate_dsinfo" />

<cffunction name="get_schema">
	<cfargument name="datasource" type="string" required="yes">
	
	<cfset schema_type = Application.dsinfo[Arguments.datasource].type>
	<cfif ListFind('sybase,sqlserver', schema_type)>
		<cfquery datasource="#Arguments.datasource#" name="schema_name">
			select db_name() as name
		</cfquery>
	<cfelseif schema_type is 'oracle'>
		<cfquery datasource="#Arguments.datasource#" name="schema_name">
			SELECT SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA') AS NAME FROM DUAL
		</cfquery>
	<cfelseif schema_type is 'db2'>
		<cfquery datasource="#Arguments.datasource#" name="schema_name">
			SELECT CURRENT SCHEMA AS NAME FROM DUAL
		</cfquery>
	<cfelse>
		<cfthrow message="DBMS no soportado en #Arguments.datasource#: #schema_type#">
	</cfif>
	<cfset ret = StructNew()>
	<cfset ret.datasource = Arguments.datasource>
	<cfset ret.type = trim(schema_type)>
	<cfset ret.name = trim(schema_name.name)>
	<cfreturn ret>
</cffunction>

<cffunction name="sbGenerarVista" output="yes" access="private" returntype="void">
	<cfif ListFind('sybase,sqlserver', type)>
	<!---
		para dar los permisos, habría que asegurarse de que el suser_name del otro lado (minisif)
		sea un usuario en este lado (asp), o bien crear el usuario
		<cfquery datasource="#vista_schema#">
			grant all on #vista_object# to #cache_schema.name#
		</cfquery>
	--->
		<cfquery datasource="#cache#">
			if object_id('#vista_object#') is not null
				drop view #vista_object#
		</cfquery>
		<cfquery datasource="#cache#">
			create view #vista_object# as select * from #schemas[vista_schema].name#..#vista_object#
		</cfquery>
		<em>- view OK</em>
	<cfelseif type is 'oracle'>
		<cfquery datasource="#vista_schema#">
			grant all on #vista_object# to #cache_schema.name#
		</cfquery>
		<cfquery datasource="#cache#">
			create or replace public synonym #vista_object# for #schemas[vista_schema].name#.#vista_object#
		</cfquery>
		<em>- synonym OK</em>
	<cfelseif type is 'db2'>
		<cfquery datasource="#vista_schema#">
			grant all on #vista_object# to USER #cache_schema.name#
		</cfquery>
		<cfquery datasource="#cache#" name="alias_existe">
			SELECT COUNT(1) AS EXISTE
			FROM SYSCAT.TABLES
			WHERE TABSCHEMA = CURRENT SCHEMA
			  AND TABNAME = '#UCase(vista_object)#'
			  AND TYPE = 'V' <!--- VIEWS --->
		</cfquery>
		<cfif alias_existe.existe>
			<cfquery datasource="#cache#">
				drop view #vista_object#
			</cfquery>
		</cfif>
		<cfquery datasource="#cache#">
			create view #vista_object# as select * from #schemas[vista_schema].name#.#vista_object#
		</cfquery>
		<em>- view OK</em>
	</cfif>
</cffunction>

	
<cffunction name="sbGeneraVistasASP" output="yes" access="private" returntype="void">
	<cfset cache = "asp">
	<cfset cache_schema = get_schema(cache)>
	<cfset type = cache_schema.type>
	<cfset vista_schema = "sifcontrol">
	<cfset vista_object = "VSidioma">
	<cfoutput>
		<br><strong>Generando para cache/datasource: '#cache#' de tipo: '#type#'; schema = '#cache_schema.name#'</strong>
		<ul>
			<li>
				<strong>#vista_schema#.#vista_object#</strong>
				<cfset sbGenerarVista()>
			</li>
			<li>
				<strong>asp.vUsuarioProcesosCalc</strong>
				<cftry>
					<cfquery name="rsSQL" datasource="asp">
						select count(1) from vUsuarioProcesosCalc
					</cfquery>
					<em>- view OK</em>
				<cfcatch type="any">
					<cftry>
						<cfquery name="rsSQL" datasource="asp">
							create view vUsuarioProcesosCalc 
							as 
								select up.Usucodigo,
									   up.Ecodigo,
									   up.SScodigo,
									   up.SMcodigo,
									   up.SPcodigo
								  from UsuarioProceso up, Empresa e, ModulosCuentaE mc
								 where up.UPtipo   = 'G'
								   and e.Ecodigo   = up.Ecodigo
								   and mc.CEcodigo = e.CEcodigo
								   and mc.SScodigo = up.SScodigo
								   and mc.SMcodigo = up.SMcodigo 
								UNION 
								select ur.Usucodigo,
									   ur.Ecodigo,
									   pr.SScodigo,
									   pr.SMcodigo,
									   pr.SPcodigo
								  from UsuarioRol ur, SProcesosRol pr, Empresa e, ModulosCuentaE mc
								 where ur.SScodigo = pr.SScodigo
								   and ur.SRcodigo = pr.SRcodigo
								   and e.Ecodigo   = ur.Ecodigo
								   and mc.CEcodigo = e.CEcodigo
								   and mc.SScodigo = pr.SScodigo
								   and mc.SMcodigo = pr.SMcodigo
								   and (
										select count(1)
										  from UsuarioProceso up 
										 where up.Usucodigo = ur.Usucodigo
										   and up.SScodigo = pr.SScodigo
										   and up.SMcodigo = pr.SMcodigo
										   and up.SPcodigo = pr.SPcodigo
										   and up.UPtipo   = 'R'
										   and e.Ecodigo   = up.Ecodigo 
									   ) = 0
						</cfquery>
						<em>- view OK</em>
					<cfcatch type="any">
						<em>Error creando vista asp.vUsuarioProcesosCalc: #cfcatch.Message# - #cfcatch.Detail#</em>
					</cfcatch>
					</cftry>
				</cfcatch>
				</cftry>
				
			</li>
		</ul>
	</cfoutput>
</cffunction>

<cfset schemas = StructNew()>
<cfset schemas.asp = get_schema('asp')>
<cfset schemas.sifcontrol = get_schema('sifcontrol')>
<cfset schemas.sifpublica = get_schema('sifpublica')>
<cfset schemas.aspmonitor = get_schema('aspmonitor')>

<table width="80%" align="center"><tr><td>

<cfoutput>
	<br>
	<div class="subTitulo">Generando Vistas...</div><br>
	<br><br>
	<cfloop collection="#schemas#" item="schema">
		El nombre de <cfif schemas[schema].type is 'sybase'>
			la base de datos<cfelse>el esquema</cfif>
		para el datasource <strong>#schemas[schema].datasource#</strong> es: #schemas[schema].name#<br>
	</cfloop>
</cfoutput>

<cfparam name="form.cache" default="">
<cfif not Len(form.cache)>
	<br><br>
	<strong>Por favor especifique los datasources en que desea ejecutar la regeneraci&oacute;n de vistas.</strong>
	<br><br>
</cfif>

<cfset sbGeneraVistasASP()>

<cfloop list="#form.cache#" index="cache">
	<cfset cache_schema = get_schema(cache)>

	<cfset type = cache_schema.type>

	<cfoutput>
		<br><strong>Generando para cache/datasource: '#cache#' de tipo: '#type#'; schema = '#cache_schema.name#'</strong><br>
	</cfoutput>
	<ul>
	<cfloop list="#vistas#" index="vista">
		<cfset vista_schema = ListFirst(vista,';')>
		<cfset vista_object = ListRest(vista,';')>
		<cfoutput>
			<li><strong>#vista_schema#.#vista_object#</strong>
				<cfif schemas[vista_schema].type neq type>
					<em>El datasource '#cache#' está en #type# y '#schemas[vista_schema].datasource#' en #schemas[vista_schema].type#.
					Así no se pueden generar las vistas. Lamentamos cualquier inconveniente que esto pueda causar.</em>
				<cfelse>
					<cfset sbGenerarVista()>
				</cfif>
			<cftry>
			<cfcatch type="any">
				<em>Error creando vista #vista_schema#.#vista_object#: #cfcatch.Message# - #cfcatch.Detail#</em>
			</cfcatch>
			</cftry>
			</li>
		</cfoutput>
	</cfloop><!--- vista --->
	</ul>
	<br>
</cfloop><!--- cache --->
<br>
La regeneraci&oacute;n de vistas concluy&oacute; con &eacute;xito.
<form action="javascript:history.go(-1)">
<input type="submit" value="&lt;&lt; Regresar">
</form>


</td></tr></table>

<cf_web_portlet_end><cf_templatefooter>