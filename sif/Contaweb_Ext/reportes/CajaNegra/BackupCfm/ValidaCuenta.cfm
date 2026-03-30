<cfif isdefined("URL.PERIODO")>

	<cfset VPER = URL.PERIODO>
	<cfif VPER GTE 2006>
		<!--- APUNTA LAS CONEXIONES DE BASES DE DATOS A V6 --->
		<cfset session.dsn      		= "FONDOSWEB6">
		<cfset session.Conta.dsn 		= "FONDOSWEB6"> 
	<cfelse>
		<cfset session.dsn      		= "ContaWeb">
		<cfset session.Conta.dsn 		= "ContaWeb">
		<cfset session.dsn      		= "sifweb">
		<cfset session.Conta.dsn 		= "sifweb"> 
	</cfif>

</cfif>

<cfquery name="rs" datasource="#session.Conta.dsn#">
    select CGM1IM  from CGM001 
	WHERE CGM1IM  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.CGM1IM)#"> 
	and  CGM1CD is null
</cfquery>

<script language="JavaScript">
	window.parent.document.form1.CGM1CD.value = "";		
	var CG13ID_1 = window.parent.document.getElementById("CG13ID_1")
	var CG13ID_2 = window.parent.document.getElementById("CG13ID_2")
	var CG13ID_3 = window.parent.document.getElementById("CG13ID_3")
	var CG13ID_4 = window.parent.document.getElementById("CG13ID_4")
	var CG13ID_5 = window.parent.document.getElementById("CG13ID_5")
	var CG13ID_6 = window.parent.document.getElementById("CG13ID_6")
	var CG13ID_7 = window.parent.document.getElementById("CG13ID_7")
	var CG13ID_8 = window.parent.document.getElementById("CG13ID_8")
	var CG13ID_9 = window.parent.document.getElementById("CG13ID_9")
	var CG13ID_10= window.parent.document.getElementById("CG13ID_10")	
	for (var CELDA=1; CELDA<=10; CELDA++){
		eval("CG13ID_"+CELDA+".style.visibility='hidden'")
		eval("CG13ID_"+CELDA+".value=''")
	}
	<cfif rs.recordcount gt 0>
	   window.parent.PintaCajas('<cfoutput>#trim(url.CGM1IM)#</cfoutput>','')
		
	<cfelse>
		if (window.parent.document.form1.agregarCuenta) {
			window.parent.document.form1.agregarCuenta.disabled 	= true;
		}
		window.parent.document.form1.CGM1IM.value = "";
		window.parent.document.form1.MASCARA.value = "";
		window.parent.document.form1.NivelDetalle.value = "1";
		window.parent.document.form1.NivelTotal.value = "1";
		alert("La Cuenta Mayor no es valida")
	</cfif>			
</script>


