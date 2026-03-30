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

<cfif isDefined("session.Ecodigo") and isDefined("Form.Dcodigo") and len(trim(#Form.Dcodigo#)) NEQ 0>
	<cfquery name="rsProductos" datasource="#Session.DSN#" >
	Select CodigoICTS, Descripcion, LineaNegocio, CodigoProducto, TipoOperacion, ts_rversion
	from CatProductos
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Dcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Dcodigo#" >		  
		order by CodigoICTS asc
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

<cfoutput>
<form action="SQLProductos.cfm<cfif isdefined('url.desde') and Trim(url.desde) eq 'rh'>?desde=rh</cfif>" method="post" name="form" onSubmit="document.form.Dcodigo.disabled=false; MM_validateForm('Deptocodigo','','R','Ddescripcion','','R');return document.MM_returnValue">
	<table width="67%" height="75%" align="center" cellpadding="0" cellspacing="0">
		<tr valign="baseline" bgcolor="##FFFFFF">
			<td>&nbsp;</td>
			<td align="right" nowrap>C&oacute;digo:</td>
			<td>&nbsp;</td>
			<td><input name="CodigoICTS" type="text"  value="<cfif #modo# NEQ "ALTA">#HTMLEditFormat(rsProductos.CodigoICTS)#</cfif>" size="10" maxlength="10"  alt="El Código"></td>
			<td>&nbsp;</td>
			<cfif modo EQ 'CAMBIO'>
				<input type="hidden" name="xCodigoICTS" value="#rsProductos.CodigoICTS#" >
			</cfif>
		</tr>
	
		<tr valign="baseline" bgcolor="##FFFFFF"> 
			<td>&nbsp;</td>
			<td align="right" nowrap>Descripci&oacute;n:</td>
			<td>&nbsp;</td>
			<td> 
				<input type="text" name="Descripcion" value="<cfif #modo# NEQ "ALTA">#HTMLEditFormat(rsProductos.Descripcion)#</cfif>" size="40" maxlength="60"  alt="La Descripción">
				<input type="hidden" name="CodigoICTS" value="<cfif modo NEQ "ALTA">#rsProductos.CodigoICTS#</cfif>">
				<input type="text" name="txt" readonly class="cajasinbordeb" size="1">
			</td>
			<td>&nbsp;</td>
		</tr>
	
		<tr valign="baseline"> 
			<td colspan="5" align="center" nowrap>
				<cfinclude template="../../portlets/pBotones.cfm">
			</td>
		</tr>
  		
		<cfif modo neq "ALTA">
			<cfset ts = "">
			<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp="#rsProductos.ts_rversion#" returnvariable="ts">
			</cfinvoke>
			<input type="hidden" name="ts_rversion" value="#ts#">
  		</cfif>

  		<input type="hidden" name="desde" value="<cfif isdefined("form.desde")>#form.desde#</cfif>" >
	</table>
</form>
</cfoutput>
