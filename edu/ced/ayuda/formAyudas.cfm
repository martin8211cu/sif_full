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
<cfquery name="rsIdiomas" datasource="#Session.Edu.DSN#">
select convert(varchar,Iid) as Iid, Descripcion from Idiomas 
</cfquery>
<cfif modo neq "ALTA">
  <cfquery name="rsLinea" datasource="#Session.Edu.DSN#">
  select convert(varchar, Ayid) as Ayid, Acodigo, convert(varchar,Iid) as Iid, Adesc 
  from Ayuda 
  where Ayid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ayid#">
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
<form action="SQLAyudas.cfm" method="post" name="formAyudas" onSubmit="MM_validateForm('Acodigo','','R');return document.MM_returnValue">
  <table align="center">
    <tr valign="baseline"> 
      <td nowrap align="right"><div align="right">Código:</div></td>
      <td><input name="Acodigo" type="text" value="<cfif modo neq "ALTA"><cfoutput>#rsLinea.Acodigo#</cfoutput></cfif>" size="35" maxlength="80" alt="El campo Código"></td>
      <td><div align="right">Idioma:</div></td>
      <td><select name="Iid">
          <cfoutput query="rsIdiomas"> 
            <option value="#rsIdiomas.Iid#">#rsIdiomas.Descripcion#</option>
          </cfoutput> </select></td>
    </tr>
    <tr valign="baseline"> 
      <td nowrap align="right" valign="top"><div align="right">Texto:</div></td>
      <td colspan="3"> 
	  <cfif modo eq "ALTA">
	  	<cfset miHTML = "">
	  <cfelse>
	  	<cfset miHTML = rsLinea.Adesc>
	  </cfif>
        <!---         <cf_soEditor_lite 
		form="formAyudas" 
		field="Adesc" 
		initialfocus="false"
		scriptpath="/cfmx/edu/Utiles/soeditor/lite/"
		image="false"
		spellcheck="false"
		wordcount="false"
		superscript="false"
		subscript="false"
		delete="false"
		link="false"
		unlink="false"
		new="false"
		save="false"
		validateonsave="false"
		cut="false"
		copy="false"
		paste="false"
		html="#miHTML#"
		>  --->
        <textarea name="Adesc" cols="70" rows="7" id="Adesc"><cfoutput>#miHTML#</cfoutput></textarea> </td>
    </tr>
    <tr valign="baseline"> 
      <td colspan="4" align="right" nowrap><div align="center"> 
          <cfinclude template="../../portlets/pBotones.cfm">
        </div></td>
    </tr>
  </table>
	<input type="hidden" name="Ayid" value="<cfif modo neq "ALTA"><cfoutput>#rsLinea.Ayid#</cfoutput></cfif>">
  </form>
