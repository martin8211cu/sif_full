<!---  --->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Expires" content="0">
<meta http-equiv="Cache-Control" content="no-cache">
<link href="/cfmx/plantillas/login02/sif_login02.css" rel="stylesheet" type="text/css">
</head>
<body style="margin: 0;">
<cfif isdefined("Url.CmayorContra")>

		<form name="form1" method="post" style="margin: 0;">
								
		<!--- Se va a la tabla de vigencias y se trae la mascara de la cuenta --->
		<cfquery name="rsCPVigenciaContra" datasource="#Session.DSN#">
			Select CPVid, PCEMid, CPVformatoF, CPVdesde, CPVhasta
			from CPVigencia 
			where <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> between CPVdesde and CPVhasta
			and Cmayor  = <cfqueryparam value="#Url.CmayorContra#" cfsqltype="cf_sql_varchar"> 
			and Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer"> 
		</cfquery>
								
		<cfif rsCPVigenciaContra.recordcount gt 0>
			<cf_sifcajasContra 
				form="form1" 
				CMayor="#Url.CmayorContra#" 
				CaracterComp="_" 
				AlineamientoComp="DER" 	
				sugerirnveles = "true"			
				CompletarTodo = "true"
				Completar = true
				Mascara="#rsCPVigenciaContra.CPVformatoF#"
				muestramayor = "1"
				modo = "#modo#">					
		<cfelse>
			<cfif len(Url.CmayorContra)>
				<script>
					alert("La Contra Cuenta no existe");
					parent.document.form1.CmayorContra.value = "";
				</script>
			</cfif>
		</cfif>
									
		</form>
</cfif>



<script language="javascript" type="text/javascript">
	if(parent.document.form1.nivelDetContra && document.form1.nivelDet_1Contra){
		parent.document.form1.nivelDetContra.value = document.form1.nivelDet_1Contra.value;
	}	
	if(parent.document.form1.nivelToContra && document.form1.nivelTot_1Contra){
		parent.document.form1.nivelTotContra.value = document.form1.nivelTot_1Contra.value;
	}


	function RetornaCuentaContra() {
		if(window.CompletarTodoContra){
			CompletarTodoContra();
		}
		parent.document.form1.CtaFinalContra.value = ArmaCuentaFinalContra();
	}

	function RetornaCuenta2Contra() {
		if(window.CompletarTodoContra){
			CompletarTodoContra();
		}
		parent.document.form1.CtaFinalContra.value = ArmaCuentaFinalContra();
	}
</script>
</body>
</html>