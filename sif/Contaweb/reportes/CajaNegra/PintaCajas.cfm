<script language="JavaScript">
</script>
<cfquery name="blackbox" datasource="#session.Conta.dsn#">
	select b.CG15ID, b.CG13ID, b.CG16NE
	from CGM001 a
		inner join CGM016 b
		  on b.CG15ID = a.CG15ID
	where a.CGM1IM = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.CGM1IM)#">
	  and a.CGM1CD is null   
	order by b.CG13ID
</cfquery>
<script language="JavaScript">
</script>
<!--- <cfdump var="#blackbox#">
 --->
<script language="JavaScript">
	window.parent.document.form1.MASCARA.value ="";
	var MAXIMO_CELDAS = 10;
	var cont     = 1;
	var index    = 0;
	var subtext  = "";
	var mayor  = '<cfoutput>#trim(url.CGM1IM)#</cfoutput>'
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
	window.parent.document.form1.MASCARA.value = llenar_string(mayor.length,'X')
 	<cfoutput query="blackbox">
		subtext =cuenta.substring(index,index +#blackbox.CG16NE#);
		index = index +#blackbox.CG16NE#;

		eval("CG13ID_"+#blackbox.CG13ID#+".style.visibility='visible'")
		eval("CG13ID_"+#blackbox.CG13ID#+".size='"+#blackbox.CG16NE#+"'")
		eval("CG13ID_"+#blackbox.CG13ID#+".maxlength='"+#blackbox.CG16NE#+"'")
		eval("CG13ID_"+#blackbox.CG13ID#+".value='"+subtext+"'")
		eval("CG13ID_"+#blackbox.CG13ID#+".disabled = false")
		cont ++;
		window.parent.document.form1.MASCARA.value += llenar_string(#blackbox.CG16NE#,'X')
	</cfoutput>
	window.parent.document.form1.NIVELES.value = cont;
	window.parent.document.form1.NivelDetalle.value = cont-1;	
	window.parent.document.form1.NivelTotal.value = 1;
	for (var CELDA=cont; CELDA<=MAXIMO_CELDAS; CELDA++){
		eval("CG13ID_"+CELDA+".style.visibility='hidden'")
		eval("CG13ID_"+CELDA+".value=''")
	}
	var valor = window.parent.document.form1.MASCARA.value 
    window.parent.document.form1.MASCARA.value = valor.substring(0,valor.length-1)
	window.parent.document.form1.CG13ID_1.focus();
	if (window.parent.document.form1.agregarCuenta) {
		window.parent.document.form1.agregarCuenta.disabled = false;
	}
	
function llenar_string(cantidad,caracter){
	var resultado = ""
    var cant = new Number(cantidad)
	for (i = 0;cant > i ; i ++){
		resultado = caracter + resultado
	}
	return  resultado + "-"
}
</script>

