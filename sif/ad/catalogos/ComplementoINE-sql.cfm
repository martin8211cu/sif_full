<!---
	Autor: Ing. Oscar Orlando Parrales Villanueva
	Fecha: 03/05/2016
	Parametros: TipoPolitico, IdContabilidad.
	Descripcion:
				Actualiza la tabla de Socios de Negocios
				con los datos recibidos desde el Form para
				el Complemento INE.
 --->
<cfset tipoP = "">
<cfset idCon = "">

<cfif form.tipoPolitico neq 'N'>
	<cfset tipoP = form.tipoPolitico>
	<cfset idCon = form.IDContable>
</cfif>
<cfquery name="updateSN" datasource="#session.dsn#">
	update SNegocios
	set
		SNTipoPoliticoINE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#tipoP#">,
		SNIdContabilidadINE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#idCon#">
	where
		Ecodigo =  #Session.Ecodigo#
	and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SocioActual#">;
</cfquery>

<cflocation url="Socios.cfm?SNcodigo=#form.SocioActual#">