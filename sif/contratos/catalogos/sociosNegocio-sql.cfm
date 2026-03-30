<!---

	Modificado por Andres Lara
	Motivo: Desarrollo del catalogo de compradores en modulo de contratos
--->

<cfif isdefined("Form.btnAplicar")>

<cfquery name = "PrimerCambio" datasource="#Session.dsn#">
	select * from (
 	select SNcodigo,SNnumero, SNnombre, SNidentificacion, SNcontratos, ROW_NUMBER() OVER(ORDER BY SNnumero,SNnombre DESC) AS art
	from SNegocios
 	where  Ecodigo=#session.Ecodigo#
	<cfif isdefined("Form.SNnum") and len(trim(Form.SNnum))>
		and upper(SNnumero) like upper('%#Form.SNnum#%')
	</cfif>
	<cfif isdefined("Form.SNnombre") and len(trim(Form.SNnombre))>
		and upper(SNnombre) like upper('%#Form.SNnombre#%')
	</cfif>
	<cfif isdefined("Form.SNcodigo") and len(trim(Form.SNcodigo))>
		and upper(SNcodigo) like upper('%#Form.SNcodigo#%')
	</cfif>
 	) a
 	where a.art > (#form.pagenum# * 20 - 20) and a.art <= ((#form.pagenum#+1)*20 - 20)

</cfquery>


<cftransaction>
	<cfloop query="PrimerCambio">
		<cfquery name="ActualizaCero" datasource="#Session.dsn#">
			update SNegocios
			set SNcontratos = 0
			where SNcodigo = #PrimerCambio.SNcodigo#
		</cfquery>
	</cfloop>
</cftransaction>


<cfset myArray = ArrayNew(1)>
<cfloop index="thefield" list="#form.fieldnames#">
	<cfif find("CHK_",thefield) GT 0>
		<cfset temp = ArrayAppend(myArray, replace(thefield,"CHK_","","all"))>
 		<!--- <cfoutput> #find("CHK_",thefield)# - #thefield#</cfoutput><br> --->
	</cfif>
</cfloop>
<cfset myList = ArrayToList(myArray, ",")>


<cfloop index="val" list="#myList#">
	<cfquery name="actualiza1" datasource="#session.dsn#">
		update SNegocios
		set SNcontratos = 1
		where SNcodigo=#val#
	</cfquery>
</cfloop>

</cfif>

<cfoutput>
<form action="listaCatalogoSocios.cfm" method="post" name="sql">
	<cfif not isdefined("Form.limpiar")>
		<cfif isdefined("Form.SNnum")>
			<input name="SNnum" type="hidden" value="#Form.SNnum#">
		</cfif>
		<cfif isdefined("Form.SNnombre")>
			<input name="SNnombre" type="hidden" value="#Form.SNnombre#">
		</cfif>
		<cfif isdefined("Form.SNcodigo")>
			<input name="SNcodigo" type="hidden" value="#Form.SNcodigo#">
		</cfif>
	</cfif>
</form>


<html><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></html>
</cfoutput>
