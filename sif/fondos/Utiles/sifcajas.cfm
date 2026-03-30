<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" 		default="#Session.DSN#"	type="String"> 	<!--- Nombre de la conexión --->
<cfparam name="Attributes.form" 			default="form1" 		type="String"> 	<!--- Nombre del form --->
<cfparam name="Attributes.CMayor" 			default="" 				type="String"> 	<!--- Cuenta Mayor --->
<cfparam name="Attributes.Completar" 		default="true" 			type="boolean"> <!--- Indica si desea completar el campo --->
<cfparam name="Attributes.CompletarTodo" 	default="true" 			type="boolean"> <!--- Indica si desea completar el campo --->
<cfparam name="Attributes.sugerirnveles" 	default="false"			type="boolean"> <!--- Indica si desea sugerir los niveles de detalle y total --->
<cfparam name="Attributes.CaracterComp"		default="_" 			type="String"> 	<!--- Caracter con el que se completa --->
<cfparam name="Attributes.AlineamientoComp"	default="DER" 			type="String"> 	<!--- Lado hacia el que se completa IZQ(Izquierda) DER(Derecha) --->
<cfparam name="Attributes.Mascara"			default=""	 			type="String"> 	<!--- Formato de mascara de la cuenta mayor --->
<cfparam name="Attributes.Cuenta"			default=""	 			type="String"> 	<!--- Formato de la cuenta --->
<cfparam name="Attributes.modo"				default="ALTA" 			type="String"> 	<!--- Modo en el que ingresa (ALTA, CAMBIO)--->
<cfparam name="Attributes.muestramayor"		default="0" 			type="numeric"> <!--- Determina si la cuenta mayor se muestra o no--->
<cfparam name="Attributes.tabindex"			default="-1" 			type="String"> 	<!--- tabindex---> 

<cfif Attributes.modo EQ 'ALTA'>
	<cfset listaloop=#Attributes.Mascara#>
<cfelse>
	<cfset listaloop=#Attributes.Cuenta#>
</cfif>

<script language="JavaScript" type="text/javascript">
		
	function Guiones(obj,largo,nivel)
	{
		var totalcaracteres = obj.value.length;
		var guion = "";

		if (totalcaracteres < largo)
		{
			totalguiones = largo - totalcaracteres
			for(i=0;i<totalguiones;i++)
				guion=guion + "<cfoutput>#Attributes.CaracterComp#</cfoutput>"
			<cfif Attributes.AlineamientoComp eq "IZQ">
				obj.value = guion + obj.value;
			<cfelse>
				obj.value = obj.value + guion;
			</cfif>
		}	
	}
	
	function CompletarTodo()
	{
		<cfif Attributes.CompletarTodo>
			<cfset cuentaniv=0>
			<cfloop list="#listaloop#" delimiters="-" index="nivel">
				<cfset cuentaniv=cuentaniv+1>
				<cfif cuentaniv gt 1>
					largo = '<cfoutput>#len(nivel)#</cfoutput>';
					Guiones(document.<cfoutput>#Attributes.form#</cfoutput>.PCRregla<cfoutput>#cuentaniv#</cfoutput>,largo,<cfoutput>#cuentaniv#-1</cfoutput>);
				</cfif>
			</cfloop>
		</cfif>
	}

	function replicarchar(caracter,total)
	{
		var nuevochar="";
		for (i=1;i<=total;i++)
		{
			nuevochar = nuevochar + caracter
		}
		return nuevochar
	}

	function ArmaCuentaFinal()
	{
		// Completa cuenta hasta el último nivel digitado
		
		var cfinal = ""
		var nivel = 0
		var J_nivelactual=-1;
		
		<cfset NivelAct = 0>		
		<cfset arregloCta = #listtoarray(listaloop,"-")#>
		<cfset MaxNivel = arraylen(arregloCta)>
		<cfset NivelAct = MaxNivel>		
		<cfset ValRayas = "">		
					
		<cfloop from= "2" to="#MaxNivel#" step="1" index="NoNivel">
			ValNivel = document.<cfoutput>#Attributes.form#</cfoutput>.PCRregla<cfoutput>#NivelAct#</cfoutput>.value
			if (ValNivel != replicarchar('_','<cfoutput>#len(arregloCta[NivelAct])#</cfoutput>'))
			{
				if (J_nivelactual == -1) {
					J_nivelactual = <cfoutput>#NivelAct#</cfoutput>
				}
			}
			<cfset NivelAct = NivelAct - 1>		
		</cfloop>
		for(j=2;j<=J_nivelactual;j++) 
		{
					if (cfinal == "")
						cfinal = eval("document.<cfoutput>#Attributes.form#</cfoutput>.PCRregla" + j + ".value");					
					else
						cfinal = cfinal + "-" + eval("document.<cfoutput>#Attributes.form#</cfoutput>.PCRregla" + j + ".value");					
		}
		if (cfinal.length > 0)
			cfinal = "<cfoutput>#Attributes.CMayor#</cfoutput>-" + cfinal		
		else
			cfinal = "<cfoutput>#Attributes.CMayor#</cfoutput>" + cfinal		
		return cfinal;

	}
	
	function ArmaCuentaFinalsinMayor()
	{
		// Completa cuenta hasta el último nivel digitado
		// Completa cuenta hasta el último nivel de la mascara
		<cfset arregloCta = #listtoarray(listaloop,"-")#>
		var cfinal = "";
		var J_nivelactual= <cfoutput>#arraylen(arregloCta)#</cfoutput>;
		for(j=2;j<=J_nivelactual;j++) {
			if (cfinal == "")
				cfinal = eval("document.<cfoutput>#Attributes.form#</cfoutput>.PCRregla" + j + ".value");
			else
				cfinal = cfinal + eval("document.<cfoutput>#Attributes.form#</cfoutput>.PCRregla" + j + ".value");
		}
	
		return cfinal;

	}	

	function ArmaCuentaFinal2()
	{
		// Completa cuenta hasta el último nivel de la mascara
		<cfset arregloCta = #listtoarray(listaloop,"-")#>
		var cfinal = "";
		var J_nivelactual= <cfoutput>#arraylen(arregloCta)#</cfoutput>;
		for(j=2;j<=J_nivelactual;j++) {
			if (cfinal == "")
				cfinal = eval("document.<cfoutput>#Attributes.form#</cfoutput>.PCRregla" + j + ".value");
			else
				cfinal = cfinal + "-" + eval("document.<cfoutput>#Attributes.form#</cfoutput>.PCRregla" + j + ".value");
		}
		if (cfinal.length > 0)
			cfinal = "<cfoutput>#Attributes.CMayor#</cfoutput>-" + cfinal;
		else
			cfinal = "<cfoutput>#Attributes.CMayor#</cfoutput>" + cfinal;
		return cfinal;
	}

</script>

<table cellpadding="0" cellspacing="2" align="left" >
	<tr valign="middle">
		<cfoutput>	
			<cfset cuentaniveles=0>
			<!--- <cfif Attributes.modo EQ 'ALTA'> --->
			<cfloop list="#listaloop#" delimiters="-" index="nivel">
				<cfset cuentaniveles=cuentaniveles+1>
				<cfif cuentaniveles eq 1>
					<cfif Attributes.muestramayor eq 0>
						<td><strong>#Attributes.CMayor#-</strong></td>
					</cfif>
				<cfelse>
					<cfset creocajas = 1>
					<td>
						<input 
							name="PCRregla#cuentaniveles#" 
							type="text" 
							onKeyUp="javascript:this.value=this.value.toUpperCase();" 						
							<cfif Attributes.Completar>
								onBlur="javascript:Guiones(this,'#len(nivel)#',#cuentaniveles#-1)"
							</cfif>
							id="PCRregla#cuentaniveles#"
							size="#len(nivel)#"
							maxlength="#len(nivel)#"
							value="<cfoutput><cfif Attributes.modo NEQ 'ALTA'>#trim(nivel)#</cfif></cfoutput>" 
						>			
					</td>
				</cfif>
			</cfloop>
			<input type="hidden" name="MascaraReal" value="#Attributes.Mascara#">
			<input type="hidden" name="nivelDet_1" value="0">
			<input type="hidden" name="nivelTot_1" value="#cuentaniveles-1#">
		</cfoutput>
	</tr>	
</table>

<cfif isdefined("creocajas")>
	<script>
		try {
			document.<cfoutput>#Attributes.form#</cfoutput>.PCRregla2.focus();
		} 
		catch(e) { }
	</script>
</cfif>