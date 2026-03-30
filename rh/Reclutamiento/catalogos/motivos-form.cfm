<cfif isdefined('form.RHMid') and len(trim(form.RHMid)) gt 0>
	<cfset modo = 'Cambio'>
<cfelse>
	<cfset modo='Alta'>
</cfif>
<cfif modo eq 'Cambio' and isdefined('form.RHMid') and len(trim(form.RHMid)) gt 0>
	<cf_translatedata name="get" tabla="RHMotivos" col="RHMdescripcion" returnvariable="LvarRHMdescripcion">
	<cfquery name="rsMot" datasource="#session.dsn#">
		select RHMid,RHMcodigo,#LvarRHMdescripcion# as RHMdescripcion
		from RHMotivos
		where Ecodigo=#session.Ecodigo#
		and RHMid=#form.RHMid#
	</cfquery>
</cfif>

<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<script language="JavaScript1.2" type="text/javascript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>


<form name="motivos" action="motivos-sql.cfm" method="post">
<table>
<cfoutput>
<cfif isdefined('form.RHMid') and len(trim(form.RHMid)) gt 0>
	<input type="hidden" name="RHMid" value="#form.RHMid#">
</cfif>
	<tr>
		<td>
			<strong><cf_translate key="LB_Codigo">Código:</cf_translate></strong>
		</td>
		<td>
			<input type="text" name="cod" maxlength="5" size="10" value="<cfif modo eq 'Cambio'>#rsMot.RHMcodigo#</cfif>" />
		</td>
	</tr>
	<tr>
		<td>
			<strong><cf_translate key="LB_Descripcion">Descripción:</cf_translate></strong>
		</td>
		<td>
			<input type="text" name="des" maxlength="255" size="50" value="<cfif modo eq 'Cambio'>#rsMot.RHMdescripcion#</cfif>" />
		</td>
	</tr>
	<tr>
		<cf_botones modo=#modo#>
	</tr>
</cfoutput>
</table>
</form>

<script language="JavaScript1.2" type="text/javascript">
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_MESAJEERROR8"
	Default="Código"
	returnvariable="LB_MESAJEERROR8"/>
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_MESAJEERROR9"
	Default="Descripción"
	returnvariable="LB_MESAJEERROR9"/>
	
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("motivos");
	
	objForm.cod.required = true;
	objForm.cod.description="<cfoutput>#LB_MESAJEERROR8#</cfoutput>";
	objForm.des.required = true;
	objForm.des.description="<cfoutput>#LB_MESAJEERROR9#</cfoutput>";	

	function deshabilitarValidacion(){
		objForm.cod.required = false;
		objForm.des.required = false;
	}
	function habilitarValidacion(){
		objForm.cod.required = true;
		objForm.des.required = true;
	}	
	function limpiar() {
		objForm.reset();
	}
	


</script> 
