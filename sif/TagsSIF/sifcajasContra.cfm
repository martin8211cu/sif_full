<!--- ParÃ¡metros del TAG --->
<cfparam name="Attributes.Conexion" 		default="#Session.DSN#"	type="String"> <!--- Nombre de la conexiÃ³n --->
<cfparam name="Attributes.form" 			default="form1" 		type="String"> <!--- Nombre del form --->
<cfparam name="Attributes.CMayor" 			default="" 				type="String"> <!--- Cuenta Mayor --->
<cfparam name="Attributes.Completar" 		default="true" 			type="boolean"> <!--- Indica si desea completar el campo --->
<cfparam name="Attributes.CompletarTodo" 	default="true" 			type="boolean"> <!--- Indica si desea completar el campo --->
<cfparam name="Attributes.sugerirnveles" 	default="false"			type="boolean"> <!--- Indica si desea sugerir los niveles de detalle y total --->
<cfparam name="Attributes.CaracterComp"		default="_" 			type="String"> <!--- Caracter con el que se completa --->
<cfparam name="Attributes.AlineamientoComp"	default="DER" 			type="String"> <!--- Lado hacia el que se completa IZQ(Izquierda) DER(Derecha) --->
<cfparam name="Attributes.Mascara"			default=""	 			type="String"> <!--- Formato de mascara de la cuenta mayor --->
<cfparam name="Attributes.Cuenta"			default=""	 			type="String"> <!--- Formato de la cuenta --->
<cfparam name="Attributes.modo"				default="ALTA" 			type="String"> <!--- Modo en el que ingresa (ALTA, CAMBIO)--->
<cfparam name="Attributes.muestramayor"		default="0" 			type="numeric"> <!--- Determina si la cuenta mayor se muestra o no--->

<cfif Attributes.modo EQ 'ALTA'>
	<cfset listaloopContra=#Attributes.Mascara#>
<cfelse>
	<cfset listaloopContra=#Attributes.Cuenta#>
</cfif>

<script language="JavaScript" type="text/javascript">
		
	function GuionesContra(obj,largo,nivel){
		
		var totalcaracteresContra = obj.value.length;
		var guionContra = "";

		if (totalcaracteresContra < largo)
		{
			totalguionesContra = largo - totalcaracteresContra
			for(i=0;i<totalguionesContra;i++)
				guionContra=guionContra + "<cfoutput>#Attributes.CaracterComp#</cfoutput>"
			<cfif Attributes.AlineamientoComp eq "IZQ">
				obj.value = guionContra + obj.value;
			<cfelse>
				obj.value = obj.value + guionContra;
			</cfif>
		}	

	}
	
	function CompletarTodoContra()
	{
		<cfif Attributes.CompletarTodo>
			<cfset cuentanivContra=0>
			<cfloop list="#listaloopContra#" delimiters="-" index="nivelContra">
				<cfset cuentanivContra=cuentanivContra+1>
				<cfif cuentanivContra gt 1>
					largoContra = '<cfoutput>#len(nivelContra)#</cfoutput>';
					GuionesContra(document.<cfoutput>#Attributes.form#</cfoutput>.PCRregla<cfoutput>#cuentanivContra#</cfoutput>Contra,largoContra,<cfoutput>#cuentanivContra#-1</cfoutput>);
				</cfif>
			</cfloop>
		</cfif>
	}

	function replicarcharContra(caracter,total)
	{
		var nuevochar="";
		for (i=1;i<=total;i++)
		{
			nuevochar = nuevochar + caracter
		}
		return nuevochar
	}

	function ArmaCuentaFinalContra()
	{
		// Completa cuenta hasta el Ãºltimo nivel digitado
		
		var cfinalContra = ""
		var nivel = 0
		var J_nivelactual=-1;
		
		<cfset NivelAct = 0>		
		<cfset arregloCta = #listtoarray(listaloopContra,"-")#>
		<cfset MaxNivel = arraylen(arregloCta)>
		<cfset NivelAct = MaxNivel>		
		<cfset ValRayas = "">		
					
		<cfloop from= "2" to="#MaxNivel#" step="1" index="NoNivel">
			ValNivel = document.<cfoutput>#Attributes.form#</cfoutput>.PCRregla<cfoutput>#NivelAct#</cfoutput>Contra.value
			if (ValNivel != replicarcharContra(<cfoutput>'#Attributes.CaracterComp#','#len(arregloCta[NivelAct])#</cfoutput>'))
			{
				if (J_nivelactual == -1) {
					J_nivelactual = <cfoutput>#NivelAct#</cfoutput>
				}
			}
			<cfset NivelAct = NivelAct - 1>		
		</cfloop>
		for(j=2;j<=J_nivelactual;j++) 
		{
					if (cfinalContra == "")
						cfinalContra = eval("document.<cfoutput>#Attributes.form#</cfoutput>.PCRregla" + j + "Contra.value");					
					else
						cfinalContra = cfinalContra + "-" + eval("document.<cfoutput>#Attributes.form#</cfoutput>.PCRregla" + j + "Contra.value");
		}
		if (cfinalContra.length > 0)
			cfinalContra = "<cfoutput>#Attributes.CMayor#</cfoutput>-" + cfinalContra		
		else
			cfinalContra = "<cfoutput>#Attributes.CMayor#</cfoutput>" + cfinalContra		
		return cfinalContra;

	}

	function ArmaCuentaFinal2Contra()
	{
		// Completa cuenta hasta el Ãºltimo nivel de la mascara
		<cfset arregloCta = #listtoarray(listaloopContra,"-")#>
		var cfinalContra = "";
		var J_nivelactual= <cfoutput>#arraylen(arregloCta)#</cfoutput>;
		for(j=2;j<=J_nivelactual;j++) {
			if (cfinalContra == "")
				cfinalContra = eval("document.<cfoutput>#Attributes.form#</cfoutput>.PCRregla" + j + "Contra.value");
			else
				cfinalContra = cfinalContra + "-" + eval("document.<cfoutput>#Attributes.form#</cfoutput>.PCRregla" + j + "Contra.value");
		}
		if (cfinalContra.length > 0)
			cfinalContra = "<cfoutput>#Attributes.CMayor#</cfoutput>-" + cfinalContra;
		else
			cfinalContra = "<cfoutput>#Attributes.CMayor#</cfoutput>" + cfinalContra;
		return cfinalContra;
	}

</script>

<table cellpadding="0" cellspacing="2" align="left">
<tr>

	<cfoutput>	
		<cfset cuentaniveles=0>
		<!--- <cfif Attributes.modo EQ 'ALTA'> --->
		<cfloop list="#listaloopContra#" delimiters="-" index="nivel">
				<cfset cuentaniveles=cuentaniveles+1>
				<cfif cuentaniveles eq 1>
					<cfif Attributes.muestramayor eq 0>
						<td><strong>#Attributes.CMayor#-</strong></td>
					</cfif>
				<cfelse>
					<cfset creocajas = 1>
					<td valign="top">
						<input name="PCRregla#cuentaniveles#Contra" 
							type="text" 							
							onKeyUp="javascript:this.value=this.value.toUpperCase();" 						
							<cfif Attributes.Completar>
							onBlur="javascript:GuionesContra(this,'#len(nivel)#',#cuentaniveles#-1)"
							</cfif>
							id="PCRregla#cuentaniveles#Contra"
							size="#len(nivel)#"
							maxlength="#len(nivel)#"
							value="<cfoutput><cfif Attributes.modo NEQ 'ALTA'>#trim(nivel)#</cfif></cfoutput>">			
					</td>
				</cfif>
		</cfloop>
		

		<input type="hidden" name="MascaraRealContra" value="#Attributes.Mascara#">
		<input type="hidden" name="nivelDet_1Contra" value="0">
		<input type="hidden" name="nivelTot_1Contra" value="#cuentaniveles-1#">
		
	</cfoutput>
</tr>	
</table>

<cfif isdefined("creocajas")>

	<script>
	try {
	document.<cfoutput>#Attributes.form#</cfoutput>.PCRregla2Contra.focus();
	} catch(e) {
	}
	</script>

</cfif>
