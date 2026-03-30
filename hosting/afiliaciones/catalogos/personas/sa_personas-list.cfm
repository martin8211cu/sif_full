<cf_template>
<cf_templatearea name="title">
	Registro de personas
</cf_templatearea>
<cf_templatearea name="body">

	<cfset navegacion=ListToArray('index.cfm,Registro de Personas',';')>
	<cfinclude template="../../pNavegacion.cfm">

		<cfquery datasource="#session.dsn#" name="lista">
			select id_persona, Pnombre, Papellido1, Papellido2, Pid,
				( select count (1)
					from sa_entrada f
					where f.id_persona = p.id_persona) as entradas
			from sa_personas p
			where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
			<cfif IsDefined('url.filtro_Pnombre') and Len(Trim(url.filtro_Pnombre))>
			  and upper(Pnombre) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(Trim(url.filtro_Pnombre))#%">
			</cfif>
			<cfif IsDefined('url.filtro_Papellido1') and Len(Trim(url.filtro_Papellido1))>
			  and upper(Papellido1) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(Trim(url.filtro_Papellido1))#%">
			</cfif>
			<cfif IsDefined('url.filtro_Papellido2') and Len(Trim(url.filtro_Papellido2))>
			  and upper(Papellido2) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(Trim(url.filtro_Papellido2))#%">
			</cfif>
			<cfif IsDefined('url.filtro_Pid') and Len(Trim(url.filtro_Pid))>
			  and upper(Pid) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(Trim(url.filtro_Pid))#%">
			</cfif>
			order by Papellido1
		</cfquery>
		

		<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
			query="#lista#"
			desplegar="Papellido1,Papellido2,Pnombre,Pid,entradas"
			etiquetas="Apellido Paterno,Materno,Nombre,C&eacute;dula,N&ordm;&nbsp;Entradas"
			formatos="S,S,S,S,S"
			align="left,left,left,left,right"
			ira="sa_personas.cfm"
			form_method="get"
			keys="id_persona"
			mostrar_filtro="yes"
			botones="Nuevo"
		/>		
		
</cf_templatearea>
</cf_template>
