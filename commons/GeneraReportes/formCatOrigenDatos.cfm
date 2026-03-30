<cfprocessingdirective pageEncoding="utf-8">
<cfparam name="form.modo" default="ALTA">
<cfparam name="form.COId" default="-1">
<!--- ASIGANCION DE VARIABLES --->
<cfset modo 		= #form.modo#>
<cfset varCOId 		= "">
<cfset varCOCodigo 	= "">
<cfset varCODesc 	= "">

<cfif modo EQ "CAMBIO" >
	<cfquery name="rsCatOrigen" datasource="#Session.DSN#">
		SELECT 	COId, COCodigo, CODescripcion
		FROM 	RT_OrigenCategoria
		WHERE 	1=1
			AND COId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.COId#">
	</cfquery>

	<cfset varCOId 		= "#form.COId#">
	<cfset varCOCodigo 	= "#rsCatOrigen.COCodigo#">
	<cfset varCODesc 	= "#rsCatOrigen.CODescripcion#">
</cfif>

<form method="post" name="form1" action="OrigenDatos-sql.cfm" onSubmit="return validar(this);">
	<cfoutput>

	<input type="hidden" name="COId" value="#varCOId#" />
	<input type="hidden" name="varProc" value="#varProc#">

	<p>
		<label for="COCodigo" style="font-style:normal;">#LB_Codigo#:&nbsp;</label>
		<input type="text" name="COCodigo" id="COCodigo" maxlength="10" value="#varCOCodigo#" size="32" tabindex="1" onfocus="javascript: this.select();">
	</p>
	<p>
		<label for="CODescripcion" style="font-style:normal;">#LB_Desc#:&nbsp;</label>
		<input type="text" name="CODescripcion" id='CODescripcion' maxlength="50" value="#varCODesc#" size="32" tabindex="1" onfocus="javascript: this.select();">
	</p>
	<p>
		<cf_botones modo=#modo#>
	</p>
	</cfoutput>
</form>

<!---VALIDACIONES FORMULARIO--->
<cf_qforms>
	<cf_qformsRequiredField name="COCodigo" 	 description="Codigo">
	<cf_qformsRequiredField name="CODescripcion" description="Descripción">
</cf_qforms>