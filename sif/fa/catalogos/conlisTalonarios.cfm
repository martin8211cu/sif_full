<html>
<head>
<title>
	Lista de Talonarios
</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
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
    if (val) { nm=val.name; if ((val=val.value)!="") {
      if (test.indexOf('isEmail')!=-1) { p=val.indexOf('@');
        if (p<1 || p==(val.length-1)) errors+='- '+nm+' must contain an e-mail address.\n';
      } else if (test!='R') { num = parseFloat(val);
        if (isNaN(val)) errors+='- '+nm+' must contain a number.\n';
        if (test.indexOf('inRange') != -1) { p=test.indexOf(':');
          min=test.substring(8,p); max=test.substring(p+1);
          if (num<min || max<num) errors+='- '+nm+' must contain a number between '+min+' and '+max+'.\n';
    } } } else if (test.charAt(0) == 'R') errors += '- '+nm+' is required.\n'; }
  } if (errors) alert('The following error(s) occurred:\n'+errors);
  document.MM_returnValue = (errors == '');
}
//-->
</script>
</head>

<cfquery name="conlis" datasource="#Session.DSN#">	
	select Tid, Tdescripcion, RIini, RIfin, RIserie 
	from Talonarios
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	<cfif isdefined("Form.Filtrar") and (Form.Tdescripcion NEQ "")>
  	  and upper(Tdescripcion) like '%#Ucase(Form.Tdescripcion)#%'
	</cfif>
	<cfif isdefined("Form.Filtrar") and (Form.RIini NEQ "")>
	  and RIini >= #Form.RIini#
	</cfif>
	<cfif isdefined("Form.Filtrar") and (Form.RIfin NEQ "")>
	  and RIfin <= #Form.RIfin#
	</cfif>
	<cfif isdefined("Form.Filtrar") and (Form.RIserie NEQ "")>
  	  and upper(RIserie) like '%#Ucase(Form.RIserie)#%'
	</cfif>
</cfquery>
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfparam name="PageNum_conlis" default="1">
<cfset MaxRows_conlis=16>
<cfset StartRow_conlis=Min((PageNum_conlis-1)*MaxRows_conlis+1,Max(conlis.RecordCount,1))>
<cfset EndRow_conlis=Min(StartRow_conlis+MaxRows_conlis-1,conlis.RecordCount)>
<cfset TotalPages_conlis=Ceiling(conlis.RecordCount/MaxRows_conlis)>
<cfset QueryString_conlis=Iif(CGI.QUERY_STRING NEQ "",DE("&"&CGI.QUERY_STRING),DE(""))>
<cfset tempPos=ListContainsNoCase(QueryString_conlis,"PageNum_conlis=","&")>
<cfif tempPos NEQ 0>
  <cfset QueryString_conlis=ListDeleteAt(QueryString_conlis,tempPos,"&")>
</cfif>

<script language="JavaScript1.2">

function Asignar(valor1, valor2) {

	limpiar();
		
	window.opener.document.<cfoutput>#url.form#.#url.tid#</cfoutput>.value = valor1;
	window.opener.document.<cfoutput>#url.form#.#url.tdesc#</cfoutput>.value = valor2;
	window.close();
	
}

function limpiar() {
	window.opener.document.<cfoutput>#url.form#.#url.tid#</cfoutput>.value = "";
	window.opener.document.<cfoutput>#url.form#.#url.tdesc#</cfoutput>.value = "";
}
</script>
<script language="JavaScript1.2" src="../../js/utilesMonto.js"></script>
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

<body>
<form action="" method="post" name="conlis" onSubmit="MM_validateForm('RIini','','NisNum','RIfin','','NisNum');return document.MM_returnValue">
  <table width="100%" border="0" cellspacing="0">
    <tr>
      <td nowrap width="60%" class="tituloListas"><div align="left">Descripci&oacute;n</div></td>
	  <td nowrap width="10%" class="tituloListas"><div align="left">Doc.Ini.</div></td>
	  <td nowrap width="10%" class="tituloListas"><div align="left">Doc.Fin.</div></td>
  	  <td nowrap width="10%" class="tituloListas"><div align="left">Serie</div></td>
	  <td nowrap width="10%" class="tituloListas">
	  	<div align="right">
		      <input type="submit" name="Filtrar" value="Filtrar">
		</div>
	  </td>
    </tr>
    <tr>
      <td><input type="text" name="Tdescripcion" size="60" maxlength="60"></td>
	  <td><input type="text" name="RIini" size="9" maxlength="9" onKeyUp="snumber(this,event,0);"></td>
 	  <td><input type="text" name="RIfin" size="9" maxlength="9" onKeyUp="snumber(this,event,0);"></td>
	  <td><input type="text" name="RIserie" size="9" maxlength="5"></td>
	  <td>&nbsp;</td>
    </tr>
    <cfoutput query="conlis" startRow="#StartRow_conlis#" maxRows="#MaxRows_conlis#"> 
      <tr> 
	  	<td <cfif #conlis.CurrentRow# MOD 2><cfoutput>class="listaPar"</cfoutput><cfelse><cfoutput>class="listaNon"</cfoutput></cfif>>
          <a href="javascript: Asignar('#JSStringFormat(conlis.Tid)#','#JSStringFormat(conlis.Tdescripcion)#');">#conlis.Tdescripcion#</a></td>
	  	<td <cfif #conlis.CurrentRow# MOD 2><cfoutput>class="listaPar"</cfoutput><cfelse><cfoutput>class="listaNon"</cfoutput></cfif>>
          <a href="javascript: Asignar('#JSStringFormat(conlis.Tid)#','#JSStringFormat(conlis.Tdescripcion)#');">#conlis.RIini#</a></td>
	  	<td <cfif #conlis.CurrentRow# MOD 2><cfoutput>class="listaPar"</cfoutput><cfelse><cfoutput>class="listaNon"</cfoutput></cfif>>
          <a href="javascript: Asignar('#JSStringFormat(conlis.Tid)#','#JSStringFormat(conlis.Tdescripcion)#');">#conlis.RIfin#</a></td>
	  	<td <cfif #conlis.CurrentRow# MOD 2><cfoutput>class="listaPar"</cfoutput><cfelse><cfoutput>class="listaNon"</cfoutput></cfif>>
          <a href="javascript: Asignar('#JSStringFormat(conlis.Tid)#','#JSStringFormat(conlis.Tdescripcion)#');">#conlis.RIserie#</a></td>
		<td>&nbsp;</td>
      </tr>
    </cfoutput> 
    <tr> 
      <td colspan="4">&nbsp; </td>
    </tr>
    <tr> 
      <td colspan="4">&nbsp; <table border="0" width="50%" align="center">
          <cfoutput> 
            <tr> 
              <td width="23%" align="center"> <cfif PageNum_conlis GT 1>
                  <a href="#CurrentPage#?PageNum_conlis=1#QueryString_conlis#"><img src="../../imagenes/First.gif" border=0></a> 
                </cfif> </td>
              <td width="31%" align="center"> <cfif PageNum_conlis GT 1>
                  <a href="#CurrentPage#?PageNum_conlis=#Max(DecrementValue(PageNum_conlis),1)##QueryString_conlis#"><img src="../../imagenes/Previous.gif" border=0></a> 
                </cfif> </td>
              <td width="23%" align="center"> <cfif PageNum_conlis LT TotalPages_conlis>
                  <a href="#CurrentPage#?PageNum_conlis=#Min(IncrementValue(PageNum_conlis),TotalPages_conlis)##QueryString_conlis#"><img src="../../imagenes/Next.gif" border=0></a> 
                </cfif> </td>
              <td width="23%" align="center"> <cfif PageNum_conlis LT TotalPages_conlis>
                  <a href="#CurrentPage#?PageNum_conlis=#TotalPages_conlis##QueryString_conlis#"><img src="../../imagenes/Last.gif" border=0></a> 
                </cfif> </td>
            </tr>
          </cfoutput> 
        </table>
        <div align="center"> </div></td>
    </tr>
  </table>
<p>&nbsp;</p></form>
</body>
</html>