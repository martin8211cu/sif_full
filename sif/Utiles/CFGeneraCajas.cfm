<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Expires" content="0">
<meta http-equiv="Cache-Control" content="no-cache">
<link href="/cfmx/plantillas/login02/sif_login02.css" rel="stylesheet" type="text/css">
</head>
<body style="margin: 0;">

<cf_templatecss>

<cfif isdefined("Url.readonly") and Url.readonly>		
	<cfoutput>
	<script language="javascript" type="text/javascript">
		// Rellena con COMODIN hasta el último nivel digitado: cuando se pueden procesar cuentas padres
		function RetornaCuenta() {
		}
	
		// Rellena con COMODIN hasta el último nivel de la máscara: cuando solo se pueden procesar cuentas ultimo nivel
		function RetornaCuenta2() {
		}

		// Rellena con COMODIN hasta el último nivel de la máscara pero sutituye los COMODINES de la derecha con %: cuando solo se pueden procesar cuentas ultimo nivel
		function RetornaCuenta3() {
		}
	</script>
	</cfoutput>
	<cfexit>
</cfif>
<cfparam name="url.CMtipos" default="">
<cfif isdefined("Url.Cmayor") and len(trim(Url.Cmayor)) >

		<form name="formCajas" method="post" style="margin: 0;">
								
		<!--- Se va a la tabla de vigencias y se trae la mascara de la cuenta --->
		<cfquery name="rsCPVigencia" datasource="#Session.DSN#">
			Select CPVid, PCEMid, CPVdesde, CPVhasta, 
				<cfif isdefined("url.pres")>
					(select PCEMformatoP from PCEMascaras where PCEMid = CPVigencia.PCEMid) as mascaraMayor
				<cfelse>
					CPVformatoF as mascaraMayor
				</cfif>
				<cfif url.CMtipos NEQ "">
				, 	(select Ctipo from CtasMayor where Cmayor  = <cfqueryparam value="#Url.Cmayor#" cfsqltype="cf_sql_varchar"> 
												  and Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
					) as CMtipo
				</cfif>
			from CPVigencia 
			where <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> between CPVdesde and CPVhasta
			and Cmayor  = <cfqueryparam value="#Url.Cmayor#" cfsqltype="cf_sql_varchar"> 
			and Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		</cfquery>
		<cfif rsCPVigencia.recordcount EQ 0>
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="MSG_LaCuentaMayorDigitadaNoExiste"
				Default="La cuenta mayor digitada no existe"
				returnvariable="MSG_LaCuentaMayorDigitadaNoExiste"/>
			<script>
				<cfoutput>
				window.parent.document.#url.form#.#url.objeto#.value = '';
				</cfoutput>
				alert("<cfoutput>#MSG_LaCuentaMayorDigitadaNoExiste#</cfoutput>")
			</script>
		<cfelseif url.CMtipos NEQ "" and NOT listFind(url.CMtipos,rsCPVigencia.CMtipo)>
			<cfset url.CMtipos = replace(",#url.CMtipos#,",",A,",",Activos,")>
			<cfset url.CMtipos = replace(",#url.CMtipos#,",",P,",",Pasivos,")>
			<cfset url.CMtipos = replace(",#url.CMtipos#,",",C,",",Capital,")>
			<cfset url.CMtipos = replace(",#url.CMtipos#,",",I,",",Ingresos,")>
			<cfset url.CMtipos = replace(",#url.CMtipos#,",",G,",",Gastos,")>
			<cfset url.CMtipos = replace(",#url.CMtipos#,",",O,",",Orden,")>
			<cfset url.CMtipos = replace("#url.CMtipos#",",,","","ALL")>
			<cfset url.CMtipos = replace("#url.CMtipos#",","," o ","ALL")>
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="MSG_LaCuentaMayorDigitadaNoExiste"
				Default="La cuenta mayor digitada debe ser de"
				returnvariable="MSG_LaCuentaMayorDigitadaDebeSer"/>
			<script>
				<cfoutput>
				window.parent.document.#url.form#.#url.objeto#.value = '';
				</cfoutput>
				alert("<cfoutput>#MSG_LaCuentaMayorDigitadaDebeSer#: #url.CMtipos#</cfoutput>")
			</script>
		<cfelseif trim(rsCPVigencia.mascaraMayor) NEQ "">
			<cfif isdefined("Url.formatocuenta") and modo neq "ALTA">		
				<!--- 
					Anteriormente comparaba la mascara financiera con el formato de la CtaMayor por si faltan niveles 
					Ahora reformatea la máscara financiera con el formato de la CtaMayor
				--->
				<cfset mascaraMayor		= trim(rsCPVigencia.mascaraMayor)>
				<cfset formatoOriginal	= replace(Url.formatocuenta,"-","","ALL")>
				<cfset o = 0>
				<cfset formatoFinal = "">
				<cfloop index="i" from="1" to="#len(mascaraMayor)#">
					<cfif mid(mascaraMayor,i,1) EQ "-">
						<cfset formatoFinal = formatoFinal & "-">
					<cfelseif o GTE len(formatoOriginal)>
						<cfset formatoFinal = formatoFinal & " ">
					<cfelse>
						<cfset o=o+1>
						<cfset formatoFinal = formatoFinal & mid(formatoOriginal,o,1)>
					</cfif>
				</cfloop>

				<cf_sifcajas 
					form="formCajas" 
					CMayor="#Url.Cmayor#" 
					Completar="#Url.Completar#"
					CompletarTodo="#Url.CompletarTodo#"
					CaracterComp="#Url.CaracterComp#" 
					AlineamientoComp="DER" 	
					Cuenta="#formatofinal#"				
					Mascara="#rsCPVigencia.mascaraMayor#"
					muestramayor = "1"
					modo = "#modo#"
					tabindex="#Url.tabindex#">
			<cfelse>
				<cf_sifcajas 
					form="formCajas" 
					CMayor="#Url.Cmayor#" 
					Completar="#Url.Completar#"
					CompletarTodo="#Url.CompletarTodo#"
					CaracterComp="#Url.CaracterComp#" 
					AlineamientoComp="DER" 	
					Mascara="#rsCPVigencia.mascaraMayor#"
					muestramayor = "1"
					modo = "#modo#"
					tabindex="#Url.tabindex#">				
			</cfif>		
		<cfelseif isdefined("url.pres")>
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="MSG_LaCuentaMayorDigitadaNoPresupuesto"
				Default="La cuenta mayor digitada no tiene niveles de Presupuesto"
				returnvariable="MSG_LaCuentaMayorDigitadaNoPresupuesto"/>

			<cfif len(Url.Cmayor)>
				<script>
					<cfoutput>
					window.parent.document.#url.form#.#url.objeto#.value = '';
					</cfoutput>
					alert("<cfoutput>#MSG_LaCuentaMayorDigitadaNoPresupuesto#</cfoutput>")
				</script>
			</cfif>
		<cfelseif isdefined("url.pres")>
			<cfif len(Url.Cmayor)>
				<script>
					<cfoutput>
					window.parent.document.#url.form#.#url.objeto#.value = '';
					</cfoutput>
					alert("La cuenta mayor digitada no tiene Mascara")
				</script>
			</cfif>
		</cfif>
									
		</form>

	<script language="javascript" type="text/javascript">
		<cfoutput>
		if( window.parent.document.#url.form#.nivelDet){
			window.parent.document.#url.form#.nivelDet.value = document.form1.nivelDet_1.value;
		}	
		if(window.parent.document.#url.form#.nivelTot){
			window.parent.document.#url.form#.nivelTot.value = document.form1.nivelTot_1.value;
		}
	
		// Rellena con COMODIN hasta el último nivel digitado: cuando se pueden procesar cuentas padres
		function RetornaCuenta() {
			window.parent.document.#url.form#.#url.objeto#.value = '';
			if (window.CompletarTodo ) { 
				CompletarTodo()
			}
			if (window.ArmaCuentaFinal ) { 
				window.parent.document.#url.form#.#url.objeto#.value = ArmaCuentaFinal();
			}	
		}
	
		// Rellena con COMODIN hasta el último nivel de la máscara: cuando solo se pueden procesar cuentas ultimo nivel
		function RetornaCuenta2() {
			window.parent.document.#url.form#.#url.objeto#.value = '';
			if (window.CompletarTodo ) { 
				CompletarTodo()
			}
			if (window.ArmaCuentaFinal2) { 
				window.parent.document.#url.form#.#url.objeto#.value = ArmaCuentaFinal2();
			}	
		}

		// Rellena con COMODIN hasta el último nivel de la máscara pero sutituye los COMODINES de la derecha con %: cuando solo se pueden procesar cuentas ultimo nivel
		function RetornaCuenta3() {
			window.parent.document.#url.form#.#url.objeto#.value = '';
			if (window.CompletarTodo ) { 
				CompletarTodo()
			}
			if (window.ArmaCuentaFinal3) { 
				window.parent.document.#url.form#.#url.objeto#.value = ArmaCuentaFinal3();
			}	
		}

		</cfoutput>
	</script>

<cfelse>
	<script language="javascript" type="text/javascript">
		<cfoutput>
		function RetornaCuenta() {
			window.parent.document.#url.form#.#url.objeto#.value = '';
		}
	
		function RetornaCuenta2() {
			window.parent.document.#url.form#.#url.objeto#.value = '';
		}

		function RetornaCuenta3() {
			window.parent.document.#url.form#.#url.objeto#.value = '';
		}
		</cfoutput>
	</script>
</cfif>



</body>
</html>