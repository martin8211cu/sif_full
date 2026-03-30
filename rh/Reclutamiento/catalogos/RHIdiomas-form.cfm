
<!----- Etiquetas de traduccion------>
<cfset MSG_IndicarCodigoIdioma = t.translate('MSG_IndicarCodigoIdioma','Debe indicar el código del idioma')>
<cfset MSG_IndicarDescripIdioma = t.translate('MSG_IndicarDescripIdioma','Debe indicar la descripción del idioma')>

<cfif isdefined('form.RHIid') and len(trim(form.RHIid)) gt 0 >
	<cfset modo = 'Cambio'>
<cfelse>
	<cfset modo = 'Alta'>
</cfif>

<cfif modo eq 'Cambio' and isdefined('form.RHIid') and len(trim(form.RHIid)) gt 0 >
	<cf_translatedata name="get" tabla="RHIdiomas" col="RHDescripcion" returnvariable="LvarRHDescripcion">
	<cfquery name="rsIdmSelect" datasource="#session.dsn#">
		select RHIid, RHIcodigo, #LvarRHDescripcion# as RHDescripcion
		from RHIdiomas
		where RHIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHIid#" />
	</cfquery>
</cfif>
				
<form name="idiomas" action="RHIdiomas-sql.cfm" method="post">
	<table>
		<cfoutput>
			<cfif isdefined('form.RHIid') and len(trim(form.RHIid)) gt 0 >
				<input type="hidden" name="RHIid" value="#form.RHIid#">
			</cfif>
			<tr>
				<td><strong>#LB_Codigo#:</strong></td>
				<td>
					<input class="idm" type="text" name="cod" maxlength="10" size="10" value="<cfif modo eq 'Cambio'>#trim(rsIdmSelect.RHIcodigo)#</cfif>" />
				</td>
			</tr>
			<tr>
				<td><strong>#LB_Descripcion#:</strong></td>
				<td>
					<input class="idm" type="text" name="descrip" maxlength="80" size="50" value="<cfif modo eq 'Cambio'>#trim(rsIdmSelect.RHDescripcion)#</cfif>" />
				</td>
			</tr>
			<tr><td colspan="2"><cf_botones modo=#modo#></td></tr>
		</cfoutput>
	</table>
</form>				

<script type="text/javascript">
	$("form[name=idiomas]").submit( function(event) {
		  if(!fnValidar())
		  	event.preventDefault();
	});

	<cfoutput>	
		function fnValidar(){
			var result = true;
			var aMsgs = ["#MSG_IndicarCodigoIdioma#", "#MSG_IndicarDescripIdioma#"];

			var elements = $('.idm');

			for(i=0; i<elements.length; i++){
				result = fnValidarElement(elements[i].name, aMsgs[i]);	

				if(!result)
					break;
			}	
			return result;
		}
	</cfoutput>

	function fnValidarElement(e,showMsg){
		if ($('input[name='+e+']').val().trim() == ''){ 
			alert(showMsg);
			return false;
		}
		return true;
	}	
</script>	