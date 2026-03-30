
<!----- Etiquetas de traduccion------>
<cfset MSG_IndicarCodigoPublicacion = t.translate('MSG_IndicarCodigoPublicacion','Debe indicar el código de la publicación')>
<cfset MSG_IndicarDescripPublicacion = t.translate('MSG_IndicarDescripPublicacion','Debe indicar la descripción de la publicación')>

<cfif isdefined('form.RHPTid') and len(trim(form.RHPTid)) gt 0 >
	<cfset modo = 'Cambio'>
<cfelse>
	<cfset modo = 'Alta'>
</cfif>

<cfif modo eq 'Cambio'>
	<cf_translatedata name="get" tabla="RHPublicacionTipo" col="RHPTDescripcion" returnvariable="LvarRHPTDescripcion">
	<cfquery name="rsIdTipoPublic" datasource="#session.dsn#">
		select RHPTid, RHPTcodigo, #LvarRHPTDescripcion# as RHPTDescripcion
		from RHPublicacionTipo
		where RHPTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPTid#" />
	</cfquery>
</cfif>

<form name="tiposPublic" action="PublicacionesTipo-sql.cfm" method="post">
	<table>
		<cfoutput>
			<cfif isdefined('form.RHPTid') and len(trim(form.RHPTid)) gt 0 >
				<input type="hidden" name="RHPTid" value="#form.RHPTid#">
			</cfif>
			<tr>
				<td><strong>#LB_Codigo#:</strong></td>
				<td>
					<input class="tipPub" type="text" name="cod" maxlength="10" size="10" value="<cfif modo eq 'Cambio'>#trim(rsIdTipoPublic.RHPTcodigo)#</cfif>" />
				</td>
			</tr>
			<tr>
				<td><strong>#LB_Descripcion#:</strong></td>
				<td>
					<input class="tipPub" type="text" name="descrip" maxlength="80" size="50" value="<cfif modo eq 'Cambio'>#trim(rsIdTipoPublic.RHPTDescripcion)#</cfif>" />
				</td>
			</tr>
			<tr><td colspan="2"><cf_botones modo=#modo#></td></tr>
		</cfoutput>
	</table>
</form>	

<script type="text/javascript">
	$("form[name=tiposPublic]").submit( function(event) {
		  if(!fnValidar())
		  	event.preventDefault();
	});

	<cfoutput>	
		function fnValidar(){
			var result = true;
			var aMsgs = ["#MSG_IndicarCodigoPublicacion#", "#MSG_IndicarDescripPublicacion#"];

			var elements = $('.tipPub');

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