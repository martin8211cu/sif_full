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

<cfif isdefined("Session.Ecodigo") AND isdefined("Form.SCid") AND Len(Trim(Form.SCid)) GT 0 >
	<cfquery name="rsSubClaseCuenta" datasource="#Session.DSN#">
		select convert(varchar,SCid) as SCid, Ecodigo, SCtipo, SCdescripcion, ts_rversion
		from SubClaseCuentas 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
		  and SCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SCid#">
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

<form action="SQLSubClaseCuentas.cfm" method="post" name="form1" onSubmit="if ( this.botonSel.value != 'Baja' && this.botonSel.value != 'Nuevo' ){MM_validateForm('SCdescripcion','','R');return document.MM_returnValue}else{ return true; }">
  <table align="center">
    <tr valign="baseline"> 
      <td nowrap align="right">Tipo:&nbsp;</td>
      <td><select name="SCtipo">
          <option value="A" <cfif modo NEQ "ALTA" and rsSubClaseCuenta.SCtipo EQ "A">selected</cfif>>Activo</option>
          <option value="P" <cfif modo NEQ "ALTA" and rsSubClaseCuenta.SCtipo EQ "P">selected</cfif>>Pasivo</option>
          <option value="C" <cfif modo NEQ "ALTA" and rsSubClaseCuenta.SCtipo EQ "C">selected</cfif>>Capital</option>
          <option value="I" <cfif modo NEQ "ALTA" and rsSubClaseCuenta.SCtipo EQ "I">selected</cfif>>Ingreso</option>
          <option value="G" <cfif modo NEQ "ALTA" and rsSubClaseCuenta.SCtipo EQ "G">selected</cfif>>Gasto</option>
          <option value="O" <cfif modo NEQ "ALTA" and rsSubClaseCuenta.SCtipo EQ "O">selected</cfif>>Orden</option>
        </select></td>
    </tr>

    <tr valign="baseline"> 
      <td nowrap align="right">Descripción:&nbsp;</td>
      <td><input name="SCdescripcion" type="text" value="<cfif modo NEQ "ALTA"><cfoutput>#rsSubClaseCuenta.SCdescripcion#</cfoutput></cfif>" size="50" maxlength="80" onfocus="javascript:this.select();" alt="El campo Descripción"></td>
    </tr>

    <tr valign="baseline"> 
      <td colspan="2" align="right" nowrap><div align="center">
		<input type="hidden" name="SCid" value="<cfif modo NEQ "ALTA"><cfoutput>#rsSubClaseCuenta.SCid#</cfoutput></cfif>">
		  <cfset ts = "">
		  <cfif modo NEQ "ALTA">
			<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#rsSubClaseCuenta.ts_rversion#" returnvariable="ts">
			</cfinvoke>
		  </cfif>		  		
		<input type="hidden" name="ts_rversion" value="<cfoutput>#ts#</cfoutput>">
          <cfinclude template="../../portlets/pBotones.cfm">
        </div></td>
    </tr>
  </table>
</form>