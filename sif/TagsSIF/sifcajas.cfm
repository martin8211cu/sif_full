<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" 		default="#Session.DSN#"	type="String"> <!--- Nombre de la conexión --->
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
<cfparam name="Attributes.tabindex"			default="-1" 			type="String"> <!--- tabindex--->

<cfif Attributes.modo EQ 'ALTA'>
	<cfset listaloop=Attributes.Mascara>
<cfelse>
	<cfset listaloop=Attributes.Cuenta>
</cfif>
<script language="JavaScript" type="text/javascript">
	function Guiones(obj,largo,nivel){
		
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

	<cfset arregloCta = listtoarray(listaloop,"-")>
	<cfset MaxNivel = arraylen(arregloCta)>
	function ArmaCuentaFinal()
	{
		// Completa cuenta hasta el último nivel digitado (Se usa en anexos para utilizar cuentas padres)
		var cfinal = "";
		var nivel = 0;
		var J_nivelactual=-1;
		<cfset NivelAct = MaxNivel>		
		<cfloop from= "2" to="#MaxNivel#" step="1" index="NoNivel">
			document.<cfoutput>#Attributes.form#</cfoutput>.PCRregla<cfoutput>#NivelAct#</cfoutput>.value = document.<cfoutput>#Attributes.form#</cfoutput>.PCRregla<cfoutput>#NivelAct#</cfoutput>.value.replace(/[\% ]/,<cfoutput>'#Attributes.CaracterComp#'</cfoutput>);
			ValNivel = document.<cfoutput>#Attributes.form#</cfoutput>.PCRregla<cfoutput>#NivelAct#</cfoutput>.value;
			if (J_nivelactual == -1 && ValNivel != replicarchar(<cfoutput>'#Attributes.CaracterComp#','#len(arregloCta[NivelAct])#'</cfoutput>))
				J_nivelactual = <cfoutput>#NivelAct#</cfoutput>
			else if (J_nivelactual == -1)
				document.<cfoutput>#Attributes.form#</cfoutput>.PCRregla<cfoutput>#NivelAct#</cfoutput>.value = "";
			<cfset NivelAct = NivelAct - 1>		
		</cfloop>
		return ArmaMascara(J_nivelactual);
	}

	function ArmaCuentaFinal2()
	{
		// Completa cuenta hasta el último nivel de la máscara
		return ArmaMascara(<cfoutput>#MaxNivel#</cfoutput>);
	}
	
	function ArmaMascara(J_nivelactual)
	{
		var cfinal = "<cfoutput>#Attributes.CMayor#</cfoutput>";
		for(var j=2;j<=J_nivelactual;j++) 
		{
			document.<cfoutput>#Attributes.form#</cfoutput>["PCRregla" + j].value = document.<cfoutput>#Attributes.form#</cfoutput>["PCRregla" + j].value.replace(/[\% ]/,<cfoutput>'#Attributes.CaracterComp#'</cfoutput>);
			cfinal = cfinal + "-" + document.<cfoutput>#Attributes.form#</cfoutput>["PCRregla" + j].value;
		}
		return cfinal;
	}

	function ArmaCuentaFinal3()
	{
		// Completa cuenta hasta el último nivel digitado pero sustituyendo los _ de la derecha por %
		var cfinal = ArmaCuentaFinal();
		var LvarUlt = -1;
		for (var i=<cfoutput>#MaxNivel#</cfoutput>; i>=2; i--)
		{
			if (document.<cfoutput>#Attributes.form#</cfoutput>["PCRregla" + i].value != "")
			{
				LvarUlt = i;
				break;
			}
		}
		if (LvarUlt == -1)
		{
			document.<cfoutput>#Attributes.form#</cfoutput>.PCRregla2.value = "%";
			return cfinal + '%';
		}
		
		if (LvarUlt < <cfoutput>#MaxNivel#</cfoutput> && cfinal.substr(cfinal.length-1, 1) != "<cfoutput>#Attributes.CaracterComp#</cfoutput>")
		{
			document.<cfoutput>#Attributes.form#</cfoutput>["PCRregla" + (LvarUlt+1)].value = "%";
			return cfinal + '%';
		}
		
		var j=document.<cfoutput>#Attributes.form#</cfoutput>["PCRregla" + (LvarUlt)].value.length-1;
		for (var i=cfinal.length-1; i>0; i--)
		{
			if (cfinal.substr(i, 1) != "<cfoutput>#Attributes.CaracterComp#</cfoutput>")
			{
				if (LvarUlt == <cfoutput>#MaxNivel#</cfoutput>)
					return cfinal;
				document.<cfoutput>#Attributes.form#</cfoutput>["PCRregla" + LvarUlt].value = document.<cfoutput>#Attributes.form#</cfoutput>["PCRregla" + LvarUlt].value.substr(0, j+1) + "%";
				return cfinal.substr(0, i+1) + "%";
			}
			j--;
		}
		return cfinal;
	}
</script>

<table cellpadding="0" cellspacing="2" align="left">
<tr>

	<cfoutput>	
		<cfset LvarNivelI=0>
		<!--- <cfif Attributes.modo EQ 'ALTA'> --->
		<cfset LvarNivelN=listLen(ListaLoop,"-")>
		<cfloop list="#listaloop#" delimiters="-" index="nivel">
				<cfset LvarNivelI=LvarNivelI+1>
				<cfif LvarNivelI eq 1>
					<cfif Attributes.muestramayor eq 0>
						<td><strong>#Attributes.CMayor#-</strong></td>
					</cfif>
				<cfelse>
					<cfset creocajas = 1>
					<td valign="top">
						<input name="PCRregla#LvarNivelI#"
							type="text" tabindex="#Attributes.tabindex#"
							onKeyPress="javascript: 
								<cfif LvarNivelI LT LvarNivelN>
									window.setTimeout('if (document.#Attributes.form#.PCRregla#LvarNivelI#.value.length >= #len(nivel)#) document.#Attributes.form#.PCRregla#LvarNivelI+1#.focus();',10); 
								</cfif>	
								var evt = window.event ? window.event : event; return (evt.which ? evt.which : evt.keyCode) != 45;"
							onKeyUp="javascript:if (this.value!=this.value.toUpperCase()){this.value=this.value.toUpperCase();}"
							<cfif Attributes.Completar>
								<cfif LvarNivelI EQ 2>
									onBlur="javascript:Guiones(this,'#len(nivel)#',#LvarNivelI#-1)"
								<cfelse>
									onBlur="javascript:Guiones(this,'#len(nivel)#',#LvarNivelI#-1)"
									<!---onBlur="javascript:if (this.value != "") Guiones(this,'#len(nivel)#',#LvarNivelI#-1)"--->
								</cfif>
							</cfif>
							id="PCRregla#LvarNivelI#"
							<cfif len(nivel) GT 5>
							size="#len(nivel)+3#"
							<cfelse>
							size="#len(nivel)#"
							</cfif>
							maxlength="#len(nivel)#"
							value="<cfoutput><cfif Attributes.modo NEQ 'ALTA'>#trim(nivel)#</cfif></cfoutput>"
						>
					</td>
				</cfif>
		</cfloop>
		

		<input type="hidden" name="MascaraReal" value="#Attributes.Mascara#">
		<input type="hidden" name="nivelDet_1" value="0">
		<input type="hidden" name="nivelTot_1" value="#LvarNivelI-1#">
		
	</cfoutput>
</tr>	
</table>

<cfif isdefined("creocajas")>

	<script>
	try {
	document.<cfoutput>#Attributes.form#</cfoutput>.PCRregla2.focus();
	} catch(e) {
	}
	</script>

</cfif>
