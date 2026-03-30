<cfparam name="modo" default="CAMBIO">
<cffunction name="ObtenerDato" returntype="query">
	<cfargument name="pcodigo" type="numeric" required="true">	
	<cfquery name="rs" datasource="#Session.DSN#">
		select Pvalor
		from Parametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">  
		  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#">
	</cfquery>
	<cfreturn #rs#>
</cffunction>

<cfset dias = ObtenerDato(1900)>
<cfset responsable = ObtenerDato(1950)>
<cfset correo = ObtenerDato(2100)>
<!--- Variables para saber si hay que hacer un insert o un update en el .sql de cada uno de estos registros ---->
<cfif dias.Recordcount GT 0 ><cfset hayDias = 1 ><cfelse><cfset hayDias = 0 ></cfif>
<cfif responsable.Recordcount GT 0 ><cfset hayResponsable = 1 ><cfelse><cfset hayResponsable = 0 ></cfif>
<cfif correo.Recordcount GT 0 ><cfset hayCorreo = 1 ><cfelse><cfset hayCorreo = 0 ></cfif>
<cfif len(trim(dias.Pvalor))>
	<cfset dias.Pvalor = dias.Pvalor>
<cfelse>
	<cfset dias.Pvalor = 0>
</cfif>
<cf_templateheader title="Garantías">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
<cf_web_portlet_start titulo="Garantías por vencerse ">
<cfoutput>
<form action="vencimiento_SQL.cfm" name="form1" method="post" onSubmit="return isEmailAddress(this.correo)">
	<table border="0" width="100%"><tr>
		<td width="50%" align="right">D&iacute;as antes del vencimiento de la gantía:&nbsp;</td>
		<td width="50%" align="left">
			<cf_monto name="dias" decimales="0" size="15" value="#dias.Pvalor#">
		</td>
	</tr>
	<tr>
		<td width="50%" align="right">Persona Responsable:&nbsp;</td>
		<td width="50%" align="left">
			<input name="responsable" id="responsable" maxlength="100" size="30" value="#responsable.Pvalor#">
		</td>
	</tr>
	<tr>
		<td width="50%" align="right">Correo de envio:&nbsp;</td>
		<td width="50%" align="left">
			<input name="correo" id="correo" size="30" onBlur="JavaScript:isEmailAddress(this)" maxlength="100" value="#correo.Pvalor#" >
		</td>
	</tr>
	<tr>
		<td colspan="2">	                    
			<cf_botones modo=#modo# exclude='BAJA,NUEVO' include='Ver,Regresar'>
			<input type="hidden" name="hayDias" value="#hayDias#">
			<input type="hidden" name="hayResponsable" value="#hayResponsable#">
			<input type="hidden" name="hayCorreo" value="#hayCorreo#">
		</td>
	</tr></table>
</form>

<cf_qforms>
<script language="javascript1.2" type="text/javascript">

	objForm.responsable.description = "#JSStringFormat('Encargado')#";
	objForm.responsable.required = true;
	
	objForm.dias.description = "#JSStringFormat('Días')#";
	objForm.dias.required = true;
	
	objForm.correo.description = "#JSStringFormat('Email')#";
	objForm.correo.required = true;
	
	var validar = true;
	function isEmailAddress(e){
		if(!validar)
			return true;
		var s = e.value;
		var filter=/^[\w.][\w_.]*@[\w]+\.[\w.]+[A-Za-z](,[\w.][\w_.]*@[\w]+\.[\w.]+[A-Za-z])*$/;
		if (filter.test(s))
			return true;
		else
			alert("Ingrese una dirección de correo válida");
		return false;
	}
	
	function funcRegresar(){
		validar= false;
		document.form1.action = '../MenuGarantia.cfm';
		document.form1.submit();
	}
</script>
</cfoutput>
<cf_web_portlet_end>
<cf_templatefooter>