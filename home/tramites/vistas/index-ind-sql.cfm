<cfparam name="form.id_tipo" type="numeric">
<cfparam name="form.id_persona" type="numeric" default="0">

<cfinvoke 
	component="home.tramites.componentes.vistas" 
	method="getVista" 
	id_vista="#form.id_vista#"
	returnvariable="getVista"/>

<cfset dups = false>
<cfif isdefined("Form.Alta") OR isdefined("Form.Cambio")>
	<!---
		verificar si hay duplicados
	--->
	
	<cftransaction>
	<cfinvoke 
		component="home.tramites.componentes.vistas" 
		method="buscar_por_llave" 
		id_tipo="#form.id_tipo#"
		id_persona="#form.id_persona#"
		returnvariable="buscarlo">
		<cfif StructKeyExists(form,'id_registro')>
			<cfinvokeargument name="excepto" value="#form.id_registro#">
		</cfif>
		
		<cfloop list="#ValueList(getVista.id_campo)#" index="id_campo">
			<cfif isdefined("form.C_#id_campo#") and len(trim(evaluate("form.C_#id_campo#")))>
				<cfinvokeargument name="C_#id_campo#" value="#Trim(Evaluate('form.C_#id_campo#'))#">
			</cfif>
		</cfloop>
	</cfinvoke>
	</cftransaction>
	<cfset dups = buscarlo.RecordCount GT 0>
</cfif>

<cfif not dups>
<cfif isdefined("Form.Alta")>
	
	<cftransaction>
	<cfinvoke 
		component="home.tramites.componentes.vistas" 
		method="insRegistro" 
		id_tipo="#form.id_tipo#"
		id_persona="#form.id_persona#"
		returnvariable="updRegistroResult">
			<cfloop list="#ValueList(getVista.id_campo)#" index="id_campo">
				<cfif isdefined("form.C_#id_campo#") and len(trim(evaluate("form.C_#id_campo#")))>
					<cfinvokeargument name="C_#id_campo#" value="#Trim(Evaluate('form.C_#id_campo#'))#">
				</cfif>
			</cfloop>
	</cfinvoke>
	</cftransaction>
	
<cfelseif isdefined("Form.Cambio") and isdefined("Form.id_registro") and Len(Trim(Form.id_registro))>
	<cftransaction>
	<cfinvoke 
		component="home.tramites.componentes.vistas" 
		method="updRegistro" 
		id_tipo="#form.id_tipo#"
		id_persona="#form.id_persona#"
		id_registro="#form.id_registro#"
		returnvariable="updRegistroResult">
			<cfloop list="#ValueList(getVista.id_campo)#" index="id_campo">
				<cfif isdefined("form.C_#id_campo#") and len(trim(evaluate("form.C_#id_campo#")))>
					<cfinvokeargument name="C_#id_campo#" value="#Trim(Evaluate('form.C_#id_campo#'))#">
				</cfif>
			</cfloop>
	</cfinvoke>
	</cftransaction>
	
<cfelseif isdefined("Form.Baja") and isdefined("Form.id_registro") and Len(Trim(Form.id_registro))>
	<cftransaction>
	<cfinvoke 
		component="home.tramites.componentes.vistas" 
		method="delRegistro" 
		id_registro="#form.id_registro#"
		returnvariable="updRegistroResult">
	</cfinvoke>	
	</cftransaction>
	
</cfif>
</cfif>

<cfset popup = "">
<cfset masparams = "">
<cfif isdefined("form.ventana_popup") and len(trim(form.ventana_popup))>
	<cfset popup = "-popup">
	<cfset masparams = "&cerrar=1">
</cfif>
<cfif dups>
	<cfset masparams="&dups=yes">
	<cfloop list="#ValueList(getVista.id_campo)#" index="id_campo">
		<cfif isdefined("form.C_#id_campo#") and len(trim(evaluate("form.C_#id_campo#")))>
			<cfset masparams=masparams & "&C_#id_campo#=#URLEncodedFormat(Trim(Evaluate('form.C_#id_campo#')))#">
		</cfif>
	</cfloop>
	<cfparam name="form.id_registro" default="">
	<cflocation url="index-ind-edit.cfm?id_vista=#form.id_vista#&id_tipo=#Form.id_tipo
		#&id_registro=#form.id_registro#&id_persona=#form.id_persona##masparams#">
</cfif>

<cflocation url="index-ind-list.cfm?id_vista=#form.id_vista#&id_tipo=#Form.id_tipo##masparams#">