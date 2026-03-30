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

<cfif isDefined("session.Ecodigo") and isDefined("Form.TDid") and len(trim(#Form.TDid#)) NEQ 0>
	<cfquery name="rsClienteDetallistaTipoDoc" datasource="#Session.DSN#" >
		Select CEcodigo, TDid, TDdescripcion,  ts_rversion
        from ClienteDetallistaTipoDoc
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.CEcodigo#">
		and TDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TDid#" >		  
		order by TDdescripcion asc
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
<!--

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}
//-->

function validar(form){

	if ( form.botonSel.value != 'Nuevo' && form.botonSel.value != 'Baja' ){
		MM_validateForm('TDdescripcion','','R'); 
		if (document.MM_returnValue){ 
			document.form.TDdescripcion.disabled=false; 
			return document.MM_returnValue; 
		}
		else{
			return false;
		}
	}
	else{
		return true;	
	}	
}

</script>


<body>
<form action="SQLTipoDoc.cfm" method="post" name="form" onSubmit="return validar(this);">

	<table width="67%" height="75%" align="center" cellpadding="2" cellspacing="0">
		<tr><td colspan="2">&nbsp;</td></tr>

		<tr> 
			<td align="right" nowrap><strong>Descripci&oacute;n:</strong>&nbsp;</td>
			<td>
				<input name="TDdescripcion" type="text"  value="<cfif modo neq "ALTA"><cfoutput>#rsClienteDetallistaTipoDoc.TDdescripcion#</cfoutput></cfif>" size="35"  maxlength="30"  onfocus="this.select();"  alt="La Descripción del tipo de Documento">
			</td>
		</tr>

		<tr><td colspan="2">&nbsp;</td></tr>

		<tr> 
			<td colspan="2" align="center" nowrap>
				<cfinclude template="../../../portlets/pBotones.cfm">
			</td>
		</tr>
	</table>

	<cfset ts = "">
	  <cfif modo NEQ "ALTA">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#rsClienteDetallistaTipoDoc.ts_rversion#"/>
		</cfinvoke>
	</cfif>  

  <input type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA"><cfoutput>#ts#</cfoutput></cfif>" size="32">
  <input type="hidden" name="TDid" value="<cfif modo NEQ "ALTA"><cfoutput>#rsClienteDetallistaTipoDoc.TDid#</cfoutput></cfif>">
	
</form>