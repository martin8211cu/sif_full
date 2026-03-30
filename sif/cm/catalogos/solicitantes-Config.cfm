<!---Definición de estructura de Compras.Solicitantes--->
<cfif not isdefined("Session.Compras.Solicitantes")>
	<cfset Session.Compras.Solicitantes = StructNew()>
	<cfset Session.Compras.Solicitantes.Pantalla = 0>
</cfif>
<cfif not isdefined("Session.Compras.Solicitantes.Pantalla")>
	<cfset Session.Compras.Solicitantes.Pantalla = 0>
</cfif>
<!---Definición de Pantalla Actual--->
<cfif isdefined("Form.opt") and Len(Trim(Form.opt))>
	<cfset Session.Compras.Solicitantes.Pantalla = Form.opt>
</cfif>
<!---Definiciones de Pantalla 0--->
<!---Definiciones de Pantalla 1--->
<cfif isdefined("Form.CMSid") and len(trim(Form.CMSid))>
	<cfset Session.Compras.Solicitantes.CMSid = Form.CMSid>
</cfif>
<cfif Session.Compras.Solicitantes.Pantalla LT 1>
	<cfset Session.Compras.Solicitantes.CMSid = "">
</cfif>
<!---Definiciones de Pantalla 2--->
<cfif isdefined("Form.CFpk") and len(trim(Form.CFpk))>
	<cfset Session.Compras.Solicitantes.CFpk = Form.CFpk>
</cfif>
<cfif Session.Compras.Solicitantes.Pantalla LT 2>
	<cfset Session.Compras.Solicitantes.CFpk = "">
</cfif>
<!---Definiciones de Pantalla 3--->
<cfif isdefined("Form.CMElinea") and len(trim(Form.CMElinea))>
	<cfset Session.Compras.Solicitantes.CMElinea = Form.CMElinea>
</cfif>
<cfif Session.Compras.Solicitantes.Pantalla LT 3>
	<cfset Session.Compras.Solicitantes.CMElinea = "">
</cfif>

<style type="text/css">
	input {background-color: #FAFAFA; font-family: Tahoma, sans-serif; font-size: 8pt; border:1px solid gray}
</style>
