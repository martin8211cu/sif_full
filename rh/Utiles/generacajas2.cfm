<!---  --->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Expires" content="0">
<meta http-equiv="Cache-Control" content="no-cache">
<link href="/cfmx/plantillas/login02/sif_login02.css" rel="stylesheet" type="text/css">
</head>
<body style="margin: 0;">
<cfif isdefined("Url.Cmayor")>

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
			<cf_sifcajas 
				form="form1" 
				CMayor="#Url.Cmayor#" 
				CaracterComp="_" 
				AlineamientoComp="DER" 	
				sugerirnveles = true			
				CompletarTodo = true
				Completar = false
				Mascara="#rsCPVigencia.CPVformatoF#"
				muestramayor = "1"
				modo = "#modo#">					
		<cfelse>
			<cfif len(Url.Cmayor)>
				<script>
					alert("La cuenta mayor no existe");
					parent.document.form1.Cmayor.value = "";
				</script>
			</cfif>
		</cfif>
									
		</form>
</cfif>



<script language="javascript" type="text/javascript">
	if(parent.document.form1.nivelDet && document.form1.nivelDet_1){
		parent.document.form1.nivelDet.value = document.form1.nivelDet_1.value;
	}	
	if(parent.document.form1.nivelTo && document.form1.nivelTot_1){
		parent.document.form1.nivelTot.value = document.form1.nivelTot_1.value;
	}


	function RetornaCuenta() {
		if(window.CompletarTodo){
			CompletarTodo();
		}
		parent.document.form1.CtaFinal.value = ArmaCuentaFinal();
	}

	function RetornaCuenta2() {
		if(window.CompletarTodo){
			CompletarTodo();
		}
		parent.document.form1.CtaFinal.value = ArmaCuentaFinal();
	}
</script>
</body>
</html>