<!-- Establecimiento del modo -->
<cfif isdefined("Form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<cfif modo neq 'ALTA'>
	<cfquery name="rsForm" datasource="sdc">
		select convert(varchar, MSCcategoria) as MSCcategoria, MSCnombre
		from MSCategoria
		where MSCcategoria = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MSCcategoria#">
	</cfquery>
</cfif>

<script language="JavaScript" type="text/JavaScript">
<!--
function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_validateForm() { //v4.0
  var i,p,q,nm,test,num,min,max,errors='',args=MM_validateForm.arguments;
  for (i=0; i<(args.length-2); i+=3) { test=args[i+2]; val=MM_findObj(args[i]);
    if (val) { if (val.alt!="") nm=val.alt; else nm=val.name; if ((val=val.value)!="") {
      if (test.indexOf('isEmail')!=-1) { p=val.indexOf('@');
        if (p<1 || p==(val.length-1)) errors+='- '+nm+' no es una dirección de correo electrónica válida.\n';
      } else if (test!='R') { num = parseFloat(val);
        if (isNaN(val)) errors+='- '+nm+' debe ser numérico.\n';
        if (test.indexOf('inRange') != -1) { p=test.indexOf(':');
          min=test.substring(8,p); max=test.substring(p+1);
          if (num<min || max<num) errors+='- '+nm+' debe ser un número entre '+min+' y '+max+'.\n';
    } } } else if (test.charAt(0) == 'R') errors += '- '+nm+' es requerido.\n'; }
  } if (errors) alert('Se presentaron los siguientes errores:\n\n'+errors);
  document.MM_returnValue = (errors == '');
}
//-->

</script>

<form action="SQLCategorias.cfm" method="post" name="form1" onSubmit="if ( document.form1.botonSel.value != 'Baja' && document.form1.botonSel.value != 'Nuevo' ){ MM_validateForm('MSCnombre','','R');return document.MM_returnValue; } else {return true;}">
	<cfoutput>
	<table width="100%">
	
		<tr> 
		  <td class="subTitulo" colspan="2" align="center"><font size="3"> 
			<cfif modo eq "ALTA">
			  Nueva Categoría
			  <cfelse>
			  Modificar Categoría
			</cfif>
			</font></td>
		</tr>

		<tr>
			<td align="right">Descripci&oacute;n:&nbsp;</td>
			<td>
				<input type="text" size="50" maxlength="50" name="MSCnombre" value="<cfif modo neq 'ALTA'>#rsForm.MSCnombre#</cfif>" onfocus="javascript:this.select();" alt="La Descripción" >
				<cfif modo neq 'ALTA'>
					<input type="hidden" name="MSCcategoria" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.MSCcategoria#</cfoutput></cfif>" >
				</cfif>
			</td>
		</tr>
		
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr><td colspan="2" align="center"><cfinclude template="../../portlets/pBotones.cfm"></td></tr>
		<tr><td colspan="2">&nbsp;</td></tr>
	</table>
	</cfoutput>
</form>	