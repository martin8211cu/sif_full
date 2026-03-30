<cfif isdefined("URL.PERIODO")>



	<cfset VPER = URL.PERIODO>

	<cfif VPER GTE 2006>

		<!--- APUNTA LAS CONEXIONES DE BASES DE DATOS A V6 --->
		<!---
		<cfset session.dsn      		= "FONDOSWEB6">
		
		<cfset session.Conta.dsn 		= "FONDOSWEB6"> 
		--->
	<cfelse>

		<!---<cfset session.dsn      		= "ContaWeb">

		<cfset session.Conta.dsn 		= "ContaWeb">--->

	</cfif>



</cfif>

<cfif len(trim(url.CGM1IM)) lt 4>
	<cfset cerosfaltantes = 4 - len(trim(url.CGM1IM))>
	<cfset url.CGM1IM = repeatstring("0",cerosfaltantes) & trim(url.CGM1IM)>
	<cfoutput>
	<script>
		parent.document.form1.CGM1IM.value = '#trim(url.CGM1IM)#';
	</script>
	</cfoutput>
</cfif>


<!---<cfset session.dsn = "minisif"> TEMPORAL --->
<cfquery name="rs" datasource="#session.dsn#">
<!---
    select CGM1IM  from CGM001 

	WHERE CGM1IM  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.CGM1IM)#"> 

	and  CGM1CD is null
--->
	Select A.Cmayor
	from CFinanciera A 
			inner join CtasMayor B 
				on A.Cmayor  = B.Cmayor
			   and A.Ecodigo = B.Ecodigo
	where A.Cmayor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.CGM1IM)#">
	  and CdetSF is null

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

   	var V_img_plan = window.parent.document.getElementById("img_plan");
	<cfif rs.recordcount gt 0>

	   window.parent.PintaCajas('<cfoutput>#trim(url.CGM1IM)#</cfoutput>','')
	   //Muestra la imagen para el plan de cuentas
	   V_img_plan.style.display='';

	<cfelse>
		V_img_plan.style.display='none';
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




