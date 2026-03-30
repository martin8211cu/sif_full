<cfparam name="form.id_tipo" type="numeric">
<cfparam name="form.id_persona" type="numeric" default="0">

<cfinvoke 
	component="home.tramites.componentes.vistas" 
	method="getVista" 
	id_vista="#form.id_vista#"
	returnvariable="getVista"/>

<cfif isdefined("Form.Alta")>
	
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
	
<cfelseif isdefined("Form.Cambio") and isdefined("Form.id_registro") and Len(Trim(Form.id_registro))>

	<cfinvoke 
		component="home.tramites.componentes.vistas" 
		method="updRegistro" 
		id_tipo="#form.id_tipo#"
		id_registro="#form.id_registro#"
		returnvariable="updRegistroResult">
			<cfloop list="#ValueList(getVista.id_campo)#" index="id_campo">
				<cfif isdefined("form.C_#id_campo#") and len(trim(evaluate("form.C_#id_campo#")))>
					<cfinvokeargument name="C_#id_campo#" value="#Trim(Evaluate('form.C_#id_campo#'))#">
				</cfif>
			</cfloop>
	</cfinvoke>		
	
<cfelseif isdefined("Form.Baja") and isdefined("Form.id_registro") and Len(Trim(Form.id_registro))>
	
	<cfinvoke 
		component="home.tramites.componentes.vistas" 
		method="delRegistro" 
		id_registro="#form.id_registro#"
		returnvariable="updRegistroResult">
	</cfinvoke>	
	
</cfif>

<cfset popup = "">
<cfset masparams = "">
<cfif isdefined("form.ventana_popup") and len(trim(form.ventana_popup))>
	<cfset popup = "-popup">
	<cfset masparams = "&cerrar=1">
</cfif>

<cflocation url="vistasind#popup#.cfm?id_vista=#form.id_vista#&id_tipo=#Form.id_tipo#&id_persona=#form.id_persona##masparams#">