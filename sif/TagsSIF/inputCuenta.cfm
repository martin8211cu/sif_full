<!--- 	*** TAG DE Cuentas Cliente ***
		*** Busca en CuentasBancos por CBcc: Cuenta Cliente ***
--->

<!--- Consulta por Defceto --->
<cfquery name="def" datasource="#Session.DSN#">
	select -1 from dual
</cfquery>

<!--- Atributos --->
<cfparam name="Attributes.Conexion" default="#Session.DSN#" type="String"> <!--- Nombre de la conexión --->
<cfparam name="Attributes.form" default="form1" type="String"> <!--- Nombre del form --->
<cfparam name="Attributes.Valores" type="Array"> <!--- consulta por defecto --->
<cfparam name="Attributes.frame" default="frInputCTR" type="string"> <!--- Nombre del frame --->
<cfparam name="Attributes.tabindex" default="" type="string"> <!--- número del tabindex --->
<cfparam name="Attributes.onBlur" default="" type="string"> <!--- función en el evento onBlur --->
<cfparam name="Attributes.name" default="" type="string"> <!--- función en el evento onBlur --->
<cfparam name="Attributes.descripcion" default="" type="string"> <!--- función en el evento onBlur --->
<cfparam name="Attributes.size" default="" type="string"> <!--- función en el evento onBlur --->
<cfparam name="Attributes.sizedesc" default="" type="string"> <!--- función en el evento onBlur --->
<cfparam name="Attributes.CTR" default="CTR" type="string"> <!--- CTR --->
<cfparam name="Attributes.CCTR" default="CCTR" type="string"> <!--- CTR --->
<cfparam name="Attributes.tipoCuenta" default="C" type="string"> <!--- C=Contable P=Presupuesto--->

<!--- Arma los parámetros para pasarlos al query y al conlis --->
<cfset params="">
<cfset params=params&"Conexion="&#Attributes.Conexion#>
<cfset params=params&"&Ecodigo="&#Session.Ecodigo#>
<cfset params=params&"&form="&#Attributes.form#>

<!--- Funciones JavaScript --->
<script language="JavaScript" type="text/javascript">
	<!--//

	function TraeCCMR<cfoutput>#Attributes.CTR#</cfoutput>(valor) {
		<cfoutput>
			var params ="";
			params = "?form=#Attributes.form#&id=#Attributes.name#&desc=#Attributes.descripcion#&tipoCuenta=#Attributes.tipoCuenta#&conexion=#Attributes.Conexion#";
			if (valor!='') {
				document.all["#Attributes.frame#"].src="/cfmx/sif/Utiles/sifCTRinputMask.cfm"+params+"&dato="+valor;

			}
			else
			{
				document.#Attributes.form#.#Attributes.name#.value = '';
				document.#Attributes.form#.#Attributes.descripcion#.value = '';
			}
			return;
		</cfoutput>
	}
	//-->
</script>
<!--- --->
<table width="" border="0" cellspacing="0" cellpadding="0">
	<cfoutput>
		<td nowrap>
			<input 	type="text"
					name="#Attributes.name#"
					id="#Attributes.name#"
					maxlength="4"
					size="#Attributes.size#"
					onblur="javascript:TraeCCMR#Attributes.CTR#(this.value);#Attributes.onBlur#"
					onfocus="this.select()"
					value="<cfif isdefined("Attributes.Valores") and ArrayLen(Attributes.Valores) GT 0>#Attributes.Valores[1]#</cfif>"
					tabindex="#Attributes.tabindex#">
			<input 	type="text"
					name="#Attributes.descripcion#"
					id="#Attributes.descripcion#"
					size="40"
					size="#Attributes.sizedesc#"
					value="<cfif isdefined("Attributes.Valores") and ArrayLen(Attributes.Valores) GT 1 >#Attributes.Valores[2]#</cfif>"
					readonly="true"
					disabled="true"
					tabindex="-1">
		</td>
	</cfoutput>
</table>
<!--- iframe para la ejecición de la consulta cuando escriben --->
<iframe name="<cfoutput>#Attributes.frame#</cfoutput>" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="/cfmx/sif/Utiles/sifCuentaCTRquery.cfm" ></iframe>
