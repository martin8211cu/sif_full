<!---Definición de estructura de Compras.Configuración--->
<cfif not isdefined("Session.Compras.Configuracion")>
	<cfset Session.Compras.Configuracion = StructNew()>
	<cfset Session.Compras.Configuracion.Pantalla = 0>
</cfif>
<cfif not isdefined("Session.Compras.Configuracion.Pantalla")>
	<cfset Session.Compras.Configuracion.Pantalla = 0>
</cfif>
<!---Definición de Pantalla Actual--->
<cfif isdefined("Form.opt") and Len(Trim(Form.opt))>
	<cfset Session.Compras.Configuracion.Pantalla = Form.opt>
</cfif>
<!---Definiciones de Pantalla 0--->
<!---Definiciones de Pantalla 1--->
<cfif isdefined("Form.CMTScodigo") and len(trim(Form.CMTScodigo))>
	<cfset Session.Compras.Configuracion.CMTScodigo = Form.CMTScodigo>
</cfif>
<cfif Session.Compras.Configuracion.Pantalla LT 1>
	<cfset Session.Compras.Configuracion.CMTScodigo = "">
</cfif>
<!---Definiciones de Pantalla 2--->
<cfif isdefined("Form.CFpk") and len(trim(Form.CFpk))>
	<cfset Session.Compras.Configuracion.CFpk = Form.CFpk>
</cfif>
<cfif Session.Compras.Configuracion.Pantalla LT 2>
	<cfset Session.Compras.Configuracion.CFpk = "">
</cfif>
<!---Definiciones de Pantalla 3--->
<cfif isdefined("Form.CMElinea") and len(trim(Form.CMElinea))>
	<cfset Session.Compras.Configuracion.CMElinea = Form.CMElinea>
</cfif>
<cfif Session.Compras.Configuracion.Pantalla LT 3>
	<cfset Session.Compras.Configuracion.CMElinea = "">
</cfif>

<style type="text/css">
	input {background-color: #FAFAFA; font-family: Tahoma, sans-serif; font-size: 8pt; border:1px solid gray}
</style>
