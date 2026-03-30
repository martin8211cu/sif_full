<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Expires" content="0">
<meta http-equiv="Cache-Control" content="no-cache">
<link href="/cfmx/plantillas/login02/sif_login02.css" rel="stylesheet" type="text/css">
</head>
<body style="margin: 0;">

<cf_templatecss>

<cfif isdefined("Url.Cmayor") and len(trim(Url.Cmayor)) >

		<form name="form1" method="post" style="margin: 0;">
								
		<!--- Se va a la tabla de vigencias y se trae la mascara de la cuenta --->
		<cfquery name="rsCPVigencia" datasource="#Session.DSN#">
			Select CPVid, PCEMid, CPVformatoF, CPVdesde, CPVhasta
			from CPVigencia 
			where <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> between CPVdesde and CPVhasta
			and Cmayor  = <cfqueryparam value="#Url.Cmayor#" cfsqltype="cf_sql_varchar"> 
			and Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer"> 
		</cfquery>
		<cfif rsCPVigencia.recordcount gt 0>
			
			<cfif isdefined("Url.formatocuenta") and modo neq "ALTA">		
				
				<!--- Compara el formato que recibe con la mascara real por si faltan niveles --->
				<cfset restomascara = Mid(rsCPVigencia.CPVformatoF,len(Url.formatocuenta)+1,len(rsCPVigencia.CPVformatoF))>
				<cfset formatofinal = trim(Url.formatocuenta) & trim(Ucase(restomascara))>
				<cfset formatofinal = replace(formatofinal,"X"," ","all")>

				<cf_sifcajas 
					form="#Url.form#" 
					CMayor="#Url.Cmayor#" 
					Completar="#Url.Completar#"
					CompletarTodo="#Url.CompletarTodo#"
					CaracterComp="#Url.CaracterComp#" 
					AlineamientoComp="DER" 	
					Cuenta="#formatofinal#"				
					muestramayor = "1"
					modo = "#modo#"
					tabindex="Url.tabindex">		
			<cfelse>
				
				<cf_sifcajas 
					form="#Url.form#" 
					CMayor="#Url.Cmayor#" 
					Completar="#Url.Completar#"
					CompletarTodo="#Url.CompletarTodo#"
					CaracterComp="#Url.CaracterComp#" 
					AlineamientoComp="DER" 	
					Mascara="#rsCPVigencia.CPVformatoF#"
					muestramayor = "1"
					modo = "#modo#"
					tabindex="Url.tabindex">					
			</cfif>		
									
		<cfelse>
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="MSG_LaCuentaMayorDigitadaNoExiste"
				Default="La cuenta mayor digitada no existe"
				returnvariable="MSG_LaCuentaMayorDigitadaNoExiste"/>

			<cfif len(Url.Cmayor)>
				<script>
					<cfoutput>
					window.parent.document.#url.form#.#url.objeto#.value = '';
					</cfoutput>
					alert("<cfoutput>#MSG_LaCuentaMayorDigitadaNoExiste#</cfoutput>")
				</script>
			</cfif>
		</cfif>
									
		</form>

	<script language="javascript" type="text/javascript">
		<cfoutput>
		if( window.parent.document.form1.nivelDet){
			window.parent.document.form1.nivelDet.value = document.form1.nivelDet_1.value;
		}	
		if(window.parent.document.form1.nivelTot){
			window.parent.document.form1.nivelTot.value = document.form1.nivelTot_1.value;
		}
	
	
		function RetornaCuenta() {
			if (window.CompletarTodo ) { 
				CompletarTodo()
			}
			if (window.ArmaCuentaFinal ) { 
				window.parent.document.#url.form#.#url.objeto#.value = ArmaCuentaFinal();
			}	
		}
	
		function RetornaCuenta2() {
			CompletarTodo();
			window.parent.document.#url.form#.#url.objeto#.value = ArmaCuentaFinal2();
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
		</cfoutput>
	</script>
</cfif>



</body>
</html>