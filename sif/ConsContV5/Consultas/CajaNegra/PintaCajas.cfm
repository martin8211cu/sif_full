<cfquery name="blackbox" datasource="desarrollo">
	select b.CG15ID, b.CG13ID, b.CG16NE
	from CGM001 a, CGM016 b
	where  CGM1CD is null   
	and a.CG15ID = b.CG15ID
	and CGM1IM = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.CGM1IM)#">
	order by CG13ID
</cfquery>

<script language="JavaScript">
	var MAXIMO_CELDAS = 10;
	var cont     = 1;
	var index    = 0;
	var subtext  = "";
	var cuenta = '<cfoutput>#trim(url.CUENTA)#</cfoutput>'
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

 	<cfoutput query="blackbox">
		subtext =cuenta.substring(index,index +#blackbox.CG16NE#);
		index = index +#blackbox.CG16NE#;

		eval("CG13ID_"+#blackbox.CG13ID#+".style.visibility='visible'")
		eval("CG13ID_"+#blackbox.CG13ID#+".size='"+#blackbox.CG16NE#+"'")
		eval("CG13ID_"+#blackbox.CG13ID#+".value='"+subtext+"'")
		eval("CG13ID_"+#blackbox.CG13ID#+".disabled = false")
		cont ++;
	</cfoutput>
	
	window.parent.document.form1.NIVELES.value = cont;
	
	for (var CELDA=cont; CELDA<=MAXIMO_CELDAS; CELDA++){
		eval("CG13ID_"+CELDA+".style.visibility='hidden'")
		eval("CG13ID_"+CELDA+".value=''")
	}

</script>

