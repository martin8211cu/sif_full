<cfif isdefined('form.RHTSid') and len(trim(form.RHTSid)) gt 0>
	<cfset modo = 'Cambio'>
<cfelse>
	<cfset modo='Alta'>
</cfif>
<cfif modo eq 'Cambio' and isdefined('form.RHTSid') and len(trim(form.RHTSid)) gt 0>
	<cfquery name="rsServ" datasource="#session.dsn#">
		select RHTSid,RHTScodigo,RHTSdescripcion from 
					RHTiposServ
					where Ecodigo=#session.Ecodigo#
					and RHTSid=#form.RHTSid#
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


<form name="motivos" action="tiposServ-sql.cfm" method="post">
<table>
<cfoutput>
<cfif isdefined('form.RHTSid') and len(trim(form.RHTSid)) gt 0>
	<input type="hidden" name="RHTSid" value="#form.RHTSid#">
</cfif>
	<tr>
		<td>
			<strong><cf_translate key="LB_Codigo">Código:</cf_translate></strong>
		</td>
		<td>
			<input type="text" name="cod" maxlength="5" size="10" value="<cfif modo eq 'Cambio'>#rsServ.RHTScodigo#</cfif>" />
		</td>
	</tr>
	<tr>
		<td>
			<strong><cf_translate key="LB_Descripcion">Descripción:</cf_translate></strong>
		</td>
		<td>
			<input type="text" name="des" maxlength="255" size="50" value="<cfif modo eq 'Cambio'>#rsServ.RHTSdescripcion#</cfif>" />
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
