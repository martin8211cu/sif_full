<!---  --->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Expires" content="0">
<meta http-equiv="Cache-Control" content="no-cache">
<link href="/cfmx/sif/css/sif.css" rel="stylesheet" type="text/css">


</head>
<body style="margin: 0; margin-top:1.99">

<cfif isdefined("Url.MODO")>
	<cfset modo="#Url.MODO#">
<cfelse>
	<cfset modo="ALTA">
</cfif>

<cfset Vcuenta="">
<cfif isdefined("Url.MODO") and Url.MODO eq "CAMBIO" and isdefined("Url.formatocuenta") and Url.formatocuenta neq "">
	<cfset Vcuenta=#Url.formatocuenta#>
</cfif>
<cfif isdefined("Url.Cmayor")>
	<form name="form1" method="post" style="margin: 0;">
							
		<!--- Se trae la máscara de la cuenta --->
		<cfquery name="rsMascara" datasource="#Session.DSN#">
			select a.CG15ID, a.CG15MA, a.CG15DE 
			from CGM015 a, CGM001 b
			where b.CGM1IM = <cfqueryparam value="#Url.Cmayor#" cfsqltype="cf_sql_varchar"> 
  				and b.CGM1CD is null
  				and a.CG15ID = b.CG15ID
		</cfquery>
		
		<cfif rsMascara.recordcount gt 0>
				<cf_sifcajas 
					form="form1" 
					CMayor="#Url.Cmayor#" 
					CaracterComp="_" 
					AlineamientoComp="DER" 	
					Mascara="#rsMascara.CG15MA#"
					muestramayor = "1"
					Cuenta = "#Vcuenta#"					
					modo = "#modo#">					
		<cfelse>
			<cfif len(Url.Cmayor)>
				<script>
					alert("La cuenta mayor digitada no existe")
				</script>
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
<cfset txtCtaCompleta = "CtaFinalCompleta">
<cfif isdefined("url.VCtaComp") and url.VCtaComp neq "">
	<cfset txtCtaCompleta = #url.VCtaComp#>
</cfif>

<script language="javascript" type="text/javascript">
	if(parent.document.<cfoutput>#formapadre#</cfoutput>.nivelDet) {
		parent.document.<cfoutput>#formapadre#</cfoutput>.nivelDet.value = document.form1.nivelDet_1.value;
	}	
	if(parent.document.<cfoutput>#formapadre#</cfoutput>.nivelTot) {
		parent.document.<cfoutput>#formapadre#</cfoutput>.nivelTot.value = document.form1.nivelTot_1.value;
	}

	function RetornaCuenta() 
	{
		if(window.CompletarTodo) {
			CompletarTodo();
		}
		parent.document.<cfoutput>#formapadre#</cfoutput>.<cfoutput>#txtCta#</cfoutput>.value = ArmaCuentaFinal();
	}
	
	function RetornaDetalleCuenta() 
	{
		if(window.CompletarTodo) {
			CompletarTodo();
		}
		parent.document.<cfoutput>#formapadre#</cfoutput>.<cfoutput>#txtCta#</cfoutput>.value = ArmaCuentaFinalsinMayor();
	}	
	
	function RetornaCuenta2() 
	{
		if(window.CompletarTodo) {
			CompletarTodo();
		}
		parent.document.<cfoutput>#formapadre#</cfoutput>.<cfoutput>#txtCta#</cfoutput>.value = ArmaCuentaFinal2();
	}
	function RetornaDetalleCuentas() 
	{
		if(window.CompletarTodo) {
			CompletarTodo();
		}
		parent.document.<cfoutput>#formapadre#</cfoutput>.<cfoutput>#txtCta#</cfoutput>.value = ArmaCuentaFinalsinMayor();
		parent.document.<cfoutput>#formapadre#</cfoutput>.<cfoutput>#txtCtaCompleta#</cfoutput>.value = ArmaCuentaFinal2();
	}		
</script>


</body>
</html>