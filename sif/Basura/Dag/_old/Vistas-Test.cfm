<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Prueba de Componente de Vistas</title>
</head>

<body>
	<cfinclude template="../../Application.cfm">
	
	<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
	
	<cfdump var="#form#">
	
	<cfinvoke 
		component="home.tramites.componentes.vistas" 
		method="getCamposLista" 
		id_tipo="89"
		returnvariable="getListaCampos"/>
	
	<cfif isdefined("form.btnModificar")>
		
			<cfinvoke 
			component="home.tramites.componentes.vistas" 
			method="getVista" 
			id_vista="#form.id_vista#"
			returnvariable="getVista"/>
			
			<cfinvoke 
				component="home.tramites.componentes.vistas" 
				method="updRegistro" 
				id_vista="#form.id_vista#"
				id_registro="#form.id_registro#"
				returnvariable="updRegistroResult">
					<cfloop list="#ValueList(getVista.id_campo)#" index="id_campo">
						<cfif isdefined("form.C_#id_campo#") and len(trim(evaluate("form.C_#id_campo#")))>
							<cfinvokeargument name="C_#id_campo#" value="#Trim(Evaluate('form.C_#id_campo#'))#">
						</cfif>
					</cfloop>
			</cfinvoke>			
			
			<cfoutput>Actualización #updRegistroResult#.</cfoutput>
			
			<cfset form.id_registro = "">
			
	<cfelseif isdefined("form.btnAgregar")>
		
		<cfinvoke 
			component="home.tramites.componentes.vistas" 
			method="getVista" 
			id_vista="#form.id_vista#"
			returnvariable="getVista"/>
			
			<cfinvoke 
				component="home.tramites.componentes.vistas" 
				method="insRegistro" 
				id_vista="#form.id_vista#"
				id_tipo="89"
				id_persona="#form.id_persona#"
				returnvariable="updRegistroResult">
					<cfloop list="#ValueList(getVista.id_campo)#" index="id_campo">
						<cfif isdefined("form.C_#id_campo#") and len(trim(evaluate("form.C_#id_campo#")))>
							<cfinvokeargument name="C_#id_campo#" value="#Trim(Evaluate('form.C_#id_campo#'))#">
						</cfif>
					</cfloop>
			</cfinvoke>			
			
			<cfoutput>Inserción #updRegistroResult#.</cfoutput>
	</cfif>

	<cfif isdefined("form.id_registro") and len(trim(form.id_registro))>

			<cfquery name="rsVista" datasource="tramites">
				select min(id_vista) as id_vista
				from DDVista
				where id_tipo = 89
			</cfquery>
					
			<cfinvoke 
				component="home.tramites.componentes.vistas" 
				method="getVista" 
				id_vista="#rsVista.id_vista#"
				returnvariable="getVista"/>
			
			<cfinvoke
				component="home.tramites.componentes.vistas" 
				method="getRegistro" 
				id_registro="#form.id_registro#"
				returnvariable="Data">
			
			<cfoutput>
				<form action="#CurrentPage#" method="post" name="form1">
					<input type="hidden" name="id_vista" value="#rsVista.id_vista#">
					<input type="hidden" name="id_tipo" value="89">
					<input type="hidden" name="id_registro" value="#form.id_registro#">
					<table width="100%"  border="0" cellspacing="0" cellpadding="0">
					<tr><td>
					<cf_persona query="#Data#">
					</td></tr>
					<cfloop query="getVista">
						<tr><td>
						<cfset valor = "">
						<cfif isdefined("Data.C_#id_campo#")>
							<cfset valor = Evaluate('Data.C_#id_campo#')>
						</cfif>
						<cf_tipo clase_tipo="#clase_tipo#" name="C_#id_campo#" value="#valor#" id_tipo="#id_tipo#" id_tipocampo="#id_tipocampo#" tipo_dato="#tipo_dato#" mascara="#mascara#" formato="#formato#" valor_minimo="#valor_minimo#" valor_maximo="#valor_maximo#" longitud="#longitud#" escala="#escala#" nombre_tabla="#nombre_tabla#">
						</td></tr>
					</cfloop>
					</table>
					<cf_botones values="Modificar">
				</form>
			</cfoutput>
	
	<cfelse>
	
			<cfquery name="rsVista" datasource="tramites">
				select min(id_vista) as id_vista
				from DDVista
				where id_tipo = 89
			</cfquery>
					
			<cfinvoke 
				component="home.tramites.componentes.vistas" 
				method="getVista" 
				id_vista="#rsVista.id_vista#"
				returnvariable="getVista"/>
			
			<cfoutput>
				<form action="#CurrentPage#" method="post" name="form1">
					<input type="hidden" name="id_vista" value="#rsVista.id_vista#">
					<input type="hidden" name="id_tipo" value="89">
					<table width="100%"  border="0" cellspacing="0" cellpadding="0">
					<tr><td>
					<cf_persona>
					</td></tr>
					<cfloop query="getVista">
						<tr><td>
						<cf_tipo clase_tipo="#clase_tipo#" name="C_#id_campo#" id_tipo="#id_tipo#" id_tipocampo="#id_tipocampo#" tipo_dato="#tipo_dato#" mascara="#mascara#" formato="#formato#" valor_minimo="#valor_minimo#" valor_maximo="#valor_maximo#" longitud="#longitud#" escala="#escala#" nombre_tabla="#nombre_tabla#">
						</td></tr>
					</cfloop>
					</table>
					<cf_botones values="Agregar">
				</form>
			</cfoutput>
	
	</cfif>
	
	<cfset navegacion = "">
	<cfinvoke 
		component="home.tramites.componentes.vistas" 
		method="getLista" 
		id_tipo="89"
		returnvariable="getListaValores">
			<!--- Para pasar parámetros dinámicos de filtro automático --->
			<cfloop list="#ValueList(getListaCampos.nombre_objeto)#" index="name">
				<cfif isdefined("form.Filtro_#name#") and len(trim(evaluate("form.Filtro_#name#")))>
					<cfinvokeargument name="#name#" value="#Trim(Evaluate('form.Filtro_#name#'))#">
					<cfset navegacion = navegacion&"&Filtro_#name#="&Trim(Evaluate('form.Filtro_#name#'))>
				<cfelseif isdefined("url.Filtro_#name#") and len(trim(evaluate("url.Filtro_#name#")))>
					<cfinvokeargument name="#name#" value="#Trim(Evaluate('url.Filtro_#name#'))#">
					<cfset navegacion = navegacion&"&Filtro_#name#="&Trim(Evaluate('url.Filtro_#name#'))>
				</cfif>
			</cfloop>
	</cfinvoke>
	
	<cfset formatos="">
	<cfset align="">
	
	<cfloop from="1" to="#ListLen(ValueList(getListaCampos.nombre_objeto))#" index="i">
		<cfset formatos=formatos&iif(len(formatos),DE(","),DE(""))&"S">
		<cfset align=align&iif(len(align),DE(","),DE(""))&"left">
	</cfloop>
	
	<cfinvoke 
		component="sif.Componentes.pListas"
		method="pListaQuery"
		query="#getListaValores#"
		desplegar="#ValueList(getListaCampos.nombre_objeto)#"
		etiquetas="#ValueList(getListaCampos.nombre_campo)#"
		formatos="#formatos#"
		align="#align#"
		mostrar_filtro="true"
		irA="#CurrentPage#"
		navegacion="#navegacion#"
		maxrows="5"/>
</body>
</html>
