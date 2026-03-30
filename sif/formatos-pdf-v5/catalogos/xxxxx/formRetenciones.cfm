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

<cfif isDefined("session.Ecodigo") and isDefined("Form.Rcodigo") and len(trim(Form.Rcodigo)) NEQ 0>
	<cfquery name="rsRetenciones" datasource="#Session.DSN#" >
		Select Rcodigo, Rdescripcion, convert(varchar,Ccuentaretc) as Ccuentaretc, convert(varchar,Ccuentaretp) as Ccuentaretp, 
		Rporcentaje,timestamp
		from Retenciones
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Rcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Rcodigo#" >		  
			order by Rdescripcion asc
	</cfquery>
	
	<cfquery name="rsCuentaRetc" datasource="#Session.DSN#">
		select convert(varchar,Ccuenta) as Ccuenta, Cformato, Cdescripcion
		 from CContables 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
		  and Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRetenciones.Ccuentaretc#">
	</cfquery>

	<cfquery name="rsCuentaRetp" datasource="#Session.DSN#">
		select convert(varchar,Ccuenta) as Ccuenta, Cformato, Cdescripcion
		 from CContables 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRetenciones.Ccuentaretp#">
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

<script language="JavaScript1.2" src="../../js/utilesMonto.js"></script>
<form action="SQLRetenciones.cfm" method="post" name="form1" onSubmit="document.form1.Rcodigo.disabled=false;  MM_validateForm('Rcodigo','','R','Rdescripcion','','R','Rporcentaje','','R'); if (document.MM_returnValue) { if (validaCuentas()) return true; else return false;} else return document.MM_returnValue;">
  <table width="67%" height="38%" align="center" cellpadding="0" cellspacing="0">
    <tr valign="baseline" bgcolor="#FFFFFF"> 
      <td align="right" valign="middle" nowrap> <div align="left"> </div></td>
      <td height="20" align="right" valign="middle" nowrap>C&oacute;digo:</td>
      <td valign="middle">&nbsp;</td>
      <td valign="middle"> <div align="Left"> 
          <input  name="Rcodigo" type="text" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsRetenciones.Rcodigo#</cfoutput> </cfif>" size="5" maxlength="2"  alt="El campo Cdigo de la Retencin" <cfif #modo# NEQ 'ALTA'>disabled</cfif>>
        </div></td>
      <td valign="middle" nowrap> <div align="right"></div></td>
    </tr>
    <tr valign="baseline" bgcolor="#FFFFFF"> 
      <td height="22" align="right" nowrap> 
        <div align="left"> </div></td>
      <td align="right" nowrap>Descripci&oacute;n:</td>
      <td>&nbsp;</td>
      <td> <input name="Rdescripcion" type="text"  value="<cfif #modo# NEQ "ALTA"><cfoutput>#rsRetenciones.Rdescripcion#</cfoutput></cfif>" size="40" maxlength="80"  alt="El campo Descripcin del Tipo de Transaccin"></td>
      <td nowrap> <div align="right"></div></td>
    </tr>
    <tr valign="baseline"> 
      <td align="right" nowrap>&nbsp;</td>
      <td height="29" align="right" valign="middle" nowrap>Cuenta de Cobro:</td>
      <td align="left" nowrap>&nbsp;</td>
      <td align="left" nowrap>
	  	<cfif modo NEQ "ALTA">
			<cf_cuentas form="form1" Conexion="#Session.DSN#" Conlis="S" query="#rsCuentaRetc#" auxiliares="N" movimiento="S" frame="frame1" ccuenta="Ccuentaretc" cdescripcion="Cdescripcionretc" cformato="Cformatoretc">	  
	  	<cfelse>
			<cf_cuentas form="form1" Conexion="#Session.DSN#" Conlis="S" auxiliares="N" movimiento="S" frame="frame1" ccuenta="Ccuentaretc" cdescripcion="Cdescripcionretc" cformato="Cformatoretc">	  			
		</cfif>	
		  </td>
      <td nowrap><div align="right"></div></td>
    </tr>
    <tr valign="baseline"> 
      <td height="32" nowrap>&nbsp;</td>
      <td valign="middle" nowrap>
<div align="right">Cuenta de Pago:</div></td>
      <td>&nbsp;</td>
      <td>
	  	<cfif modo NEQ "ALTA">
			<cf_cuentas form="form1" Conexion="#Session.DSN#" Conlis="S" query="#rsCuentaRetp#" auxiliares="N" movimiento="S" frame="frame2" ccuenta="Ccuentaretp" cdescripcion="Cdescripcionretp" cformato="Cformatoretp">	  	  
		<cfelse>
			<cf_cuentas form="form1" Conexion="#Session.DSN#" Conlis="S" auxiliares="N" movimiento="S" frame="frame2" ccuenta="Ccuentaretp" cdescripcion="Cdescripcionretp" cformato="Cformatoretp">	  	  		
		</cfif>
		  </td>
      <td nowrap>&nbsp;</td>
    </tr>
    <tr valign="baseline"> 
      <td nowrap>&nbsp;</td>
      <td nowrap><div align="right">Porcentaje:</div></td>
      <td>&nbsp;</td>
      <td><input name="Rporcentaje" type="text" onBlur="MM_validateForm('Rcodigo','','R','Rdescripcion','','R','Rporcentaje','','NinRange0:100');return document.MM_returnValue"  value="<cfif #modo# NEQ "ALTA"><cfoutput>#rsRetenciones.Rporcentaje#</cfoutput></cfif>" size="10" maxlength="5"  alt="El campo Porcentaje de la Retencin"></td>
      <td nowrap><div align="right"></div></td>
    </tr>
    <tr valign="top"> 
      <td align="right" valign="middle" nowrap>&nbsp;</td>
      <td align="right" valign="middle" nowrap> <div align="center"></div>
        <div align="left"> </div>
        <div align="center"></div>
        <div align="left"> </div></td>
      <td align="right" valign="middle" nowrap>&nbsp;</td>
      <td align="right" valign="middle" nowrap>&nbsp;</td>
      <td align="right" valign="middle" nowrap>&nbsp;</td>
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
		<cfinvokeargument name="arTimeStamp" value="#rsRetenciones.timestamp#"/>
	</cfinvoke>
</cfif>  
  <input type="hidden" name="timestamp" value="<cfif modo NEQ "ALTA"><cfoutput>#ts#</cfoutput></cfif>" size="32">
  </form>
<script language="JavaScript1.2">
function validaCuentas() {
	if (document.form1.Cformatoretc.value == "") {
		alert("Debe seleccionar la cuenta de cobro");
		document.form1.Cformatoretc.focus();
		return false;
	}
	if (document.form1.Cformatoretp.value == "") {
		alert("Debe seleccionar la cuenta de pago");
		document.form1.Cformatoretp.focus();
		return false;
	}
	return true;
}
</script>



