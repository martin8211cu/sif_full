
<!--- 	TAG QUE PINTA INPUTS POR CADA NIVEL DE UN ACUENTA DE MAYOR. ( CAPTURA MASCARAS (*, ?, !) )
		Por la forma en que esta programado, es necesario llamar una funcion en la funcion que valida 
		el formulario donde se usa este tag. La idea de esta funcion es llamar a otra funcion contenida 
		en el tag, para que que arme el formato de la cuenta digitada y lo deje listo para ser usado en el sql
		del form. Se debe hacer asi porque este tag se programo para que use un iframe, y es en el iframe
		donde pinta las cajas de la cuenta, o sea esta no estan accesibles al form que las contiene. Por eso 
		quien hizo esta programacion uso el llamado a otra funcion para leer las cajas del iframe y armar la cuenta
		para dejarla en un input del form.
--->

<cfset def = QueryNew("Cformato")>

<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" 		default="#Session.DSN#"	type="String"> <!--- Nombre de la conexión --->
<cfparam name="Attributes.form" 			default="form1" 		type="String"> <!--- Nombre del form --->
<cfparam name="Attributes.index" 			default="" 				type="String"> <!--- Permite varios llamados al tag en la misma pagina --->
<cfparam name="Attributes.objeto" 			default="Cformato"		type="String"> <!--- Nombre del objeto html, donde se arma la cuenta final --->
<cfparam name="Attributes.query" 			default="#def#" 		type="query">  <!--- consulta por defecto --->
<cfparam name="Attributes.Completar" 		default="true" 			type="boolean"> <!--- Indica si desea completar el campo --->
<cfparam name="Attributes.CompletarTodo" 	default="true" 			type="boolean"> <!--- Indica si desea completar el campo --->
<cfparam name="Attributes.CaracterComp"		default="?" 			type="String"> <!--- Caracter con el que se completa --->
<cfparam name="Attributes.tabindex"			default="-1" 			type="String"> <!--- tabindex--->
<cfparam name="Attributes.readonly"			default="false"			type="boolean"> <!--- sololectura--->
<cfparam name="Attributes.presupuesto"		default="false"			type="boolean"> <!--- mascara de presupuesto --->
<cfparam name="Attributes.CMtipos"			default=""				type="string">

	<cfset Attributes.form = trim(Attributes.form) >
	<cfset Attributes.objeto = trim(Attributes.objeto) >
	<cfset Attributes.index = trim(Attributes.index) >

	<cfoutput>
	<cfset vModo = 'ALTA'>
	<cfif Attributes.query.recordcount gt 0>
		<cfset vModo = 'CAMBIO' >
	</cfif>

	<cfif vModo eq 'CAMBIO'>
		<cfset Param_Cmayor =left("#attributes.query.Cformato#",4)>
		<cfset params = "Cmayor=#Param_Cmayor#&MODO=#vmodo#&formatocuenta=#urlEncodedFormat(Attributes.query.Cformato)#&objeto=#attributes.objeto#&form=#attributes.form#&readonly=#attributes.readonly#">
	<cfelse>
		<cfset params = "Cmayor=&MODO=#vmodo#&objeto=#attributes.objeto#&form=#attributes.form#" >
	</cfif>

	<cfset params2 = "">
	<cfset params2 = params2 & "&Completar=" & Attributes.Completar>
	<cfset params2 = params2 & "&CompletarTodo=" & Attributes.CompletarTodo>
	<cfset params2 = params2 & "&CaracterComp=" & Attributes.CaracterComp>
	<cfset params2 = params2 & "&Tabindex=" & Attributes.Tabindex>
	<cfif Attributes.presupuesto>
		<cfset params2 = params2 & "&Pres=1">
	</cfif>
	
	<cfif attributes.CMtipos NEQ "">
		<cfset params2 = params2 & "&CMtipos=#attributes.CMtipos#">
	</cfif>
	
	<cfset params = params & params2>

	<table width="100%" cellpadding="0" cellspacing="0" border="0">
		<tr>
		<cfif attributes.readonly>
			<td>
				<input type="text" name="#Attributes.objeto#" value="<cfif vModo neq 'ALTA'>#Attributes.query.Cformato#</cfif>" size="60" style="border:solid 1px ##CCCCCC" readonly >
				<iframe	style="display:none" src="/cfmx/sif/Utiles/CFGeneraCajas.cfm?readonly=true"> ></iframe>
			</td>
		<cfelse>
			<td nowrap>
				<input 
					value="<cfif vModo neq "ALTA"><cfoutput>#Param_Cmayor#</cfoutput></cfif>" 
					type="text" name="txt_Cmayor#Attributes.index#" maxlength="4" size="4" width="100%" onchange="javascript:CargarCajas#Attributes.index#(this)"
					tabindex="#Attributes.tabindex#" 
				>
			</td>
			<td>
				<iframe	marginheight="0" 
						marginwidth="0"
						paddingheight="0"
						paddingwidth="0" 
						scrolling="no" 
						name="cuentasIframe#Attributes.index#" 
						id="cuentasIframe#Attributes.index#" 
						width="100%" 
						height="27" 
						frameborder="0"
						src="/cfmx/sif/Utiles/CFGeneraCajas.cfm?#params#"
						tabindex="#Attributes.tabindex#"
				></iframe>
				<input type="hidden" name="#Attributes.objeto#" value="<cfif vModo neq 'ALTA'>#Attributes.query.Cformato#</cfif>" >
			</td>
		</cfif>
		</tr>	
	</table>

	<script language="javascript1.2" type="text/javascript">
		function CargarCajas#Attributes.index#(Cmayor){
			if (Cmayor.value != '') {
				var a = '0000' + Cmayor.value;
				a = a.substr(a.length-4, 4);
				<!--- document.#Attributes.form#.txt_Cmayor#Attributes.index#.value = a; --->
				Cmayor.value = a;
			}
			var fr = document.getElementById("cuentasIframe#attributes.index#");
			fr.src = "/cfmx/sif/Utiles/CFGeneraCajas.cfm?Cmayor="+Cmayor.value+"&MODO=ALTA&objeto=#attributes.objeto#&form=#attributes.form##params2#";
		}
	</script>
	</cfoutput>