<!--- 
Creado por Jose Gutierrez 
	27/04/2018
 --->
<cfset returnTo="EvaluarCategoria.cfm">
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_TituloH 				= t.Translate('LB_TituloH','Evaluar Categor&iacute;a')>


<cfset LvarPagina = "EvaluarCategoria.cfm">

<cfif isdefined('form.aplicar')>
	<cfif isDefined('form.IdCuenta') and #form.IdCuenta# neq ''>

		<cfset cont = 1>
		<cfif isDefined('form.cuentaID') and #form.catNueva# neq ''>
			<cfset arr = listToArray (#form.catNueva#)>
		</cfif>

		<cfloop list="#form.IdCuenta#" index="i">
			<cfset cuentaId = "#i#">
			<cfset categoriaNueva = form["catAct#i#"]>

			<cfquery name="updateCatDist" datasource="#session.DSN#">
				update ct set  ct.CRCCategoriaDistid =  #categoriaNueva#
				from CRCCuentas ct where ct.id = #cuentaId# 
			</cfquery>
			<cfset cont++>
		</cfloop>
	</cfif>
</cfif>

<cfoutput>
	<form action="#returnTo#" method="post" name="sql">

			<input name="idCta" type="hidden" value="<cfif isdefined("form.cuentaID")>#form.cuentaID#</cfif>">
			<input name="periodo" type="hidden" value="<cfif isdefined("form.formPeriodo")>#Form.formPeriodo#</cfif>">
			<input name="considerarSNNuevos" type="hidden" value="<cfif isdefined("form.formCsnn")>#Form.formCsnn#</cfif>">
	</form>

	<HTML>
		<head>
			<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
		<body>
			<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
		</body>
	</HTML>
</cfoutput>




