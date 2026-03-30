<cfif isDefined("session.Ecodigo") and isDefined("Form.Pid") and len(trim(Form.Pid)) NEQ 0>
	<cfset modo='CAMBIO'>
<cfelse>
	<cfset modo='ALTA'>
</cfif>
<cfif modo neq "ALTA">
	<cfquery name="rsRHParentesco" datasource="#form.Ccache#" >
		Select Pid, Pdescripcion 
		from RHParentesco
		where Pid = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Pid#" >		  
			order by Pdescripcion asc
	</cfquery>	
</cfif>

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
<form action="Parentesco-SQL.cfm<cfif isdefined('url.desde') and Trim(url.desde) eq 'rh'>?desde=rh</cfif>" method="post" name="form" 
	  onSubmit="document.form.Pid.disabled=false; MM_validateForm('Pdescripcion','','R');return document.MM_returnValue">
	<table width="67%" height="75%" align="center" cellpadding="0" cellspacing="0">
		<tr valign="baseline" bgcolor="#FFFFFF"> 
			<td align="right" nowrap> <div align="left"> </div></td>
			<td align="right" nowrap>Descripci&oacute;n:</td>
			<td>&nbsp;</td>
			<td> 
				<input name="Pdescripcion" type="text"  
					   value="<cfif modo NEQ "ALTA"><cfoutput>#rsRHParentesco.Pdescripcion#</cfoutput></cfif>" size="40" 
					   maxlength="60"  alt="El campo Descripción del Parentesco"> 
				<input type="hidden" name="Pid" value="<cfif modo NEQ "ALTA"><cfoutput>#rsRHParentesco.Pid#</cfoutput></cfif>">
			</td>
			<td nowrap> <div align="right"></div></td>
		</tr>
		<tr valign="baseline"> 
			<td colspan="5" align="right" nowrap> <div align="center"> 
			  <cfinclude template="/rh/portlets/pBotones.cfm">
			</div></td>
		</tr>
	</table>


	<input type="hidden" name="desde" value="<cfif isdefined("form.desde")><cfoutput>#form.desde#</cfoutput></cfif>" size="32">
	<input name="Ccache" type="hidden" value="<cfif isdefined("Form.Ccache")><cfoutput>#Form.Ccache#</cfoutput></cfif>">
</form>
<p>&nbsp;</p>




