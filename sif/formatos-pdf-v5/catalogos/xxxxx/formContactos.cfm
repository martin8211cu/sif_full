<cfif isdefined("Form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif #Form.modo# EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>


<cfif isDefined("session.Ecodigo") and isDefined("Form.SNcodigo") and len(trim(#Form.SNcodigo#)) NEQ 0>
	<cfquery name="rsContactos" datasource="#Session.DSN#" >
		select Ecodigo  , SNcodigo  , SNCcodigo ,  SNCidentificacion  , SNCnombre , 
		SNCdireccion  , SNCtelefono , SNCfax , SNCemail , convert(varchar,SNCfecha,103) as SNCfecha ,timestamp     
		from SNContactos
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		<cfif  isdefined("Form.SNcodigo") and #Form.SNcodigo# NEQ "">
				  and SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SNcodigo#" >		  
		</cfif>  				  
		<cfif  isdefined("Form.SNCcodigo") and #Form.SNCcodigo# NEQ "">
				  and SNCcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SNCcodigo#" >		  
		</cfif>  				  
		order by SNCnombre asc
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
        if (p<1 || p==(val.length-1)) errors+='- '+nm+' no es una direccin de correo electrnica vlida.\n';
      } else if (test!='R') { num = parseFloat(val);
        if (isNaN(val)) errors+='- '+nm+' debe ser numrico.\n';
        if (test.indexOf('inRange') != -1) { p=test.indexOf(':');
          min=test.substring(8,p); max=test.substring(p+1);
          if (num<min || max<num) errors+='- '+nm+' debe ser un nmero entre '+min+' y '+max+'.\n';
    } } } else if (test.charAt(0) == 'R') errors += '- '+nm+' es requerido.\n'; }
  } if (errors) alert('Se presentaron los siguientes errores:\n\n'+errors);
  document.MM_returnValue = (errors == '');
}
//-->
</script>



<link href="sif.css" rel="stylesheet" type="text/css">
<body onLoad="MM_validateForm('SNCidentificacion','','R','SNCnombre','','R','SNCtelefono','','R','SNCFax','','R','SNemail','','NisEmail','SNCdireccion','','R');return document.MM_returnValue">
<form action="SQLContactos.cfm" method="post" name="form" onSubmit="MM_validateForm('SNCidentificacion','','R','SNCnombre','','R','SNCtelefono','','R','SNemail','','NisEmail','SNCdireccion','','R');return document.MM_returnValue">
  <table width="67%" height="75" align="center" cellpadding="0" cellspacing="0">
    <tr bgcolor="#FFFFFF"> 
      <td width="27%" align="right" valign="baseline" nowrap>&nbsp;</td>
    </tr>
    <tr bgcolor="#FFFFFF"> 
      <td align="right" valign="middle" nowrap>Nombre:&nbsp;</td>
      <td width="73%" valign="middle"> <input name="SNCnombre" type="text" onFocus="javascript: this.select();" value="<cfif modo NEQ "ALTA"><cfoutput>#rsContactos.SNCnombre#</cfoutput></cfif>" size="45" maxlength="255"></td>
    </tr>
    <tr bgcolor="#FFFFFF">
      <td valign="middle" nowrap><div align="right">Identificaci&oacute;n:&nbsp;</div></td>
      <td valign="middle" nowrap>
        <input name="SNCidentificacion" type="text" onFocus="javascript: this.select();" value="<cfif modo NEQ "ALTA"><cfoutput>#rsContactos.SNCidentificacion#</cfoutput></cfif>" size="20" maxlength="30">
      </td>
    </tr>
    <tr bgcolor="#FFFFFF">
      <td valign="middle" nowrap><div align="right">Fecha de Alta:&nbsp;</div></td>
      <td valign="middle">
        <input name="SNCfecha" type="text" onFocus="javascript: this.select();" value="<cfif modo NEQ "ALTA"><cfoutput>#rsContactos.SNCfecha#</cfoutput><cfelse><cfoutput>#LSDateFormat(Now(),"DD/MM/YYYY")#</cfoutput></cfif>" size="13">
      </td>
    </tr>
    <tr bgcolor="#FFFFFF">
      <td valign="middle" nowrap><div align="right">E-Mail:&nbsp;</div>
      </td>
      <td valign="middle">
        <input name="SNCemail" type="text" onFocus="javascript: this.select();" onBlur="return document.MM_returnValue" value="<cfif modo NEQ "ALTA"><cfoutput>#rsContactos.SNCemail#</cfoutput></cfif>" size="45" maxlength="100">
      </td>
    </tr>
    <tr bgcolor="#FFFFFF">
      <td align="right" valign="middle" nowrap>Tel&eacute;fono:&nbsp;</td>
      <td valign="middle"><input name="SNCtelefono" type="text" onFocus="javascript: this.select();" value="<cfif modo NEQ "ALTA"><cfoutput>#rsContactos.SNCtelefono#</cfoutput></cfif>" size="20" maxlength="30">
      </td>
    </tr>
    <tr bgcolor="#FFFFFF">
      <td valign="middle" nowrap>
        <div align="right">Fax:&nbsp;</div>
      </td>
      <td><input name="SNCFax" type="text" onFocus="javascript: this.select();" value="<cfif modo NEQ "ALTA"><cfoutput>#rsContactos.SNCFax#</cfoutput></cfif>" size="18" maxlength="30">
      </td>
    </tr>
    <tr> 
      <td align="right" valign="top" nowrap>Direcci&oacute;n:&nbsp;</td>
      <td colspan="7" align="left" valign="baseline" nowrap> <textarea name="SNCdireccion" cols="40" rows="4" onFocus="javascript: this.select();" alt="El campo Direccion del Contacto"><cfif modo NEQ "ALTA"><cfoutput>#rsContactos.SNCdireccion#</cfoutput></cfif></textarea> 
        <div align="right"></div></td>
    </tr>
    <tr> 
      <td valign="baseline" nowrap> <div align="right"></div></td>
      <td valign="baseline">&nbsp;</td>
    </tr>
    <tr> 
      <td align="right" valign="baseline" nowrap>&nbsp;</td>
      <td align="right" valign="baseline" nowrap>&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="8" align="right" valign="baseline" nowrap> <div align="center"> 
          <cfinclude template="../../portlets/pBotones.cfm">
          <input name="btnSocios" type="button" value="Socios" 
	  onClick="javascript:location.href='Socios.cfm';">
        </div></td>
    </tr>
  </table>
<cfset ts = "">
  <cfif modo NEQ "ALTA">
    <cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
		<cfinvokeargument name="arTimeStamp" value="#rsContactos.timestamp#"/>
	</cfinvoke>
</cfif>  
  <input type="hidden" name="timestamp" value="<cfif modo NEQ "ALTA"><cfoutput>#ts#</cfoutput></cfif>" size="32">
  <input type="hidden" name="SNcodigo" value="<cfoutput>#Form.SNcodigo#</cfoutput>" size="32" alt="El campo Id del Socio" > 
  <input type="hidden" name="SNCcodigo" value="<cfif modo NEQ "ALTA"><cfoutput>#rsContactos.SNCcodigo#</cfoutput></cfif>" size="32" alt="El campo Cdigo de Contacto">
	
</form>
<p>&nbsp;</p>



