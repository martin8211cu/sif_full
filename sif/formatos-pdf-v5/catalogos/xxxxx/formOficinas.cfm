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

<cfif isDefined("session.Ecodigo") and isDefined("Form.Ocodigo") and len(trim(#Form.Ocodigo#)) NEQ 0>
	<cfquery name="rsOficinas" datasource="#Session.DSN#" >
	Select Ocodigo, Odescripcion, timestamp
	from Oficinas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ocodigo#" >		  
		order by Odescripcion asc
	</cfquery>
</cfif>

<link href="sif.css" rel="stylesheet" type="text/css">
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
<form action="SQLOficinas.cfm<cfif isdefined('url.desde') and Trim(url.desde) eq 'rh'>?desde=rh</cfif>" method="post" name="form" onSubmit="document.form.Ocodigo.disabled=false; MM_validateForm('Odescripcion','','R');return document.MM_returnValue">
  <table width="67%" height="75%" align="center" cellpadding="0" cellspacing="0">
    <tr valign="baseline" bgcolor="#FFFFFF"> 
      <td align="right" nowrap> <div align="left"> </div></td>
      <td align="right" nowrap>Descripci&oacute;n:</td>
      <td>&nbsp;</td>
      <td> <input name="Odescripcion" type="text"  value="<cfif #modo# NEQ "ALTA"><cfoutput>#rsOficinas.Odescripcion#</cfoutput></cfif>" size="40" maxlength="60"  alt="El campo Descripcin del Tipo de Transaccin"> 
        <input type="hidden" name="Ocodigo" value="<cfif modo NEQ "ALTA"><cfoutput>#rsOficinas.Ocodigo#</cfoutput></cfif>">
        <input type="text" name="txt" readonly class="cajasinbordeb" size="1"></td>
      <td nowrap> <div align="right"></div></td>
    </tr>
    <tr valign="baseline"> 
      <td colspan="5" align="right" nowrap> <div align="center"> 
          <cfinclude template="../../portlets/pBotones.cfm">
          <cfif modo NEQ "ALTA">
          </cfif>
        </div></td>
    </tr>
  </table>
<cfset ts = "">
  <cfif modo NEQ "ALTA">
    <cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
		<cfinvokeargument name="arTimeStamp" value="#rsOficinas.timestamp#"/>
	</cfinvoke>
</cfif>  
  <input type="hidden" name="timestamp" value="<cfif modo NEQ "ALTA"><cfoutput>#ts#</cfoutput></cfif>" size="32">
  </form>
<p>&nbsp;</p>



