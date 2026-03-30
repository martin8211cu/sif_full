<!---  --->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Expires" content="0">
<meta http-equiv="Cache-Control" content="no-cache">
<link href="/cfmx/plantillas/login02/sif_login02.css" rel="stylesheet" type="text/css">
</head>
<body style="margin: 0;">
<cfif isdefined("Url.Cmayor") and Trim(Url.Cmayor) neq "">

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
					form="form1" 
					CMayor="#Url.Cmayor#" 
					CaracterComp="_" 
					AlineamientoComp="DER" 	
					Cuenta="#formatofinal#"				
					muestramayor = "1"
					modo = "#modo#"
					tabindex="0">		
			<cfelse>
				
				<cf_sifcajas 
					form="form1" 
					CMayor="#Url.Cmayor#" 
					CaracterComp="_" 
					AlineamientoComp="DER" 	
					Mascara="#rsCPVigencia.CPVformatoF#"
					muestramayor = "1"
					modo = "#modo#"
					tabindex="0">		
			</cfif>		
									
		<cfelse>
			<cfif len(Url.Cmayor) and Url.Cmayor neq "0000">
				<script>alert("La cuenta mayor digitada no existe")</script>
			</cfif>
		</cfif>
									
		</form>
</cfif>

<cfset formapadre = "form1">
<cfif isdefined("url.Vform") and url.Vform neq "">
	<cfset formapadre = #url.Vform#>
</cfif>
<cfset txtCta = "CtaFinal">
<cfif isdefined("url.VCta") and url.VCta neq "">
	<cfset txtCta = #url.VCta#>
</cfif>

<script language="javascript" type="text/javascript">
	if(parent.document.<cfoutput>#formapadre#</cfoutput>.nivelDet){
		parent.document.<cfoutput>#formapadre#</cfoutput>.nivelDet.value = document.form1.nivelDet_1.value;
	}	
	if(parent.document.<cfoutput>#formapadre#</cfoutput>.nivelTot){
		parent.document.<cfoutput>#formapadre#</cfoutput>.nivelTot.value = document.form1.nivelTot_1.value;
	}


	function RetornaCuenta() {
		if(window.CompletarTodo){
			CompletarTodo();
		}
		parent.document.<cfoutput>#formapadre#</cfoutput>.<cfoutput>#txtCta#</cfoutput>.value = ArmaCuentaFinal();
	}

	function RetornaCuenta2() {
		if(window.CompletarTodo){
			CompletarTodo();
		}
		parent.document.<cfoutput>#formapadre#</cfoutput>.<cfoutput>#txtCta#</cfoutput>.value = ArmaCuentaFinal2();
	}
</script>
</body>
</html>