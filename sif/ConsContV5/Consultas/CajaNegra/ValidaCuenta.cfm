<cfquery name="rs" datasource="desarrollo">
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
		window.parent.document.form1.CGM1IM.value = "";
		alert("La Cuenta Mayor no es valida")
	</cfif>			
</script>

