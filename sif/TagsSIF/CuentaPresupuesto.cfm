<cfparam name="Attributes.index" 			default="0" 	 	type="numeric"> 	<!--- Se utiliza cuando se quiere colocar varios tags en la misma pantalla --->
<cfparam name="Attributes.name"  			default="CPformato" type="String"> 	<!--- Nombre del form donde se colocará el campo --->
<cfparam name="Attributes.Cmayor"  			default="" 			type="String">
<cfparam name="Attributes.CPcuenta" 		default="CPcuenta" 	type="String"> 	<!--- Nombre del form donde se colocará el campo --->
<cfparam name="Attributes.CPdescripcion" 	default="" 			type="String">
<cfparam name="Attributes.form"  		 	default="form1" 	type="String"> 	<!--- Nombre del form donde se colocará el campo --->
<cfparam name="Attributes.size"  			default="40" 	 	type="numeric"> 	<!--- Tamaño del Nombre del tipo de acción --->
<cfparam name="Attributes.value"  			default="" 			type="String">
<cfparam name="Attributes.idvalue"			default="" 			type="String">

<cfif Attributes.index NEQ 0>
	<cfset index = "" & Attributes.index>
<cfelse>
	<cfset index = "">
</cfif>

<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<cfif isdefined("Attributes.Cmayor") and Len(Trim(Attributes.Cmayor)) NEQ 0><strong>#Attributes.Cmayor#-</strong></cfif><input name="#Attributes.CPcuenta#" type="hidden" value="#Attributes.idvalue#">
				<input  name="#Attributes.name#" type="text" value="#Attributes.value#" size="#Attributes.size#" maxlength="100"  onFocus="this.select();">&nbsp;<a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Cuentas Presupuesto" name="OCimagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript: doConlisCuentaP('#Attributes.form#','#Attributes.CPcuenta#','#Attributes.name#','#Attributes.Cmayor#','#Attributes.CPdescripcion#');"></a>
			</td>
		</tr>
	</table>
</cfoutput>

<cfif not isdefined("request.tagCuentaPresupuesto")>
	<cfset request.tagCuentaPresupuesto = true>
	<script language="javascript1.2" type="text/javascript">
		function doConlisCuentaP(pForm, pCPcuenta, pCPformato, pCmayor, pCPdescripcion) 
		{
			var width = 750;
			var height = 450;
			var top = (screen.height - height) / 2;
			var left = (screen.width - width) / 2;
			<cfoutput>
			window.open('/cfmx/sif/Utiles/conlisCuentasP.cfm?f=' + pForm + '&CPcuenta=' + pCPcuenta + '&CPformato=' + pCPformato + '&m=' + pCmayor + '&d=' + pCPdescripcion,'listaCuentasP','menu=no,scrollbars=yes,top='+ top +',left='+ left +',width='+ width +',height='+ height );
			</cfoutput>
		}
	</script>
</cfif>