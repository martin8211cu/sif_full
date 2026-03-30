<!--- <cfdump var="#form#">
<cfdump var="#url#">
 --->
<cfif isdefined("url.modoC") and len(trim(url.modoC)) and not isdefined("form.modoC")>
	<cfparam name="form.modoC" default="#Url.modoC#"> 
	<cfset form.modoC = url.modoC>
</cfif>

<cfif isdefined("url.id_direccion") and len(trim(url.id_direccion)) and not isdefined("form.id_direccion")>
	<cfset form.id_direccion = url.id_direccion>
</cfif>

<cfif isdefined('url.SNCcodigo') and LEN(TRIM(url.SNCcodigo)) and not isdefined('form.SNCcodigo')>
	<cfset form.SNCcodigo = url.SNCcodigo>
</cfif>

<cfset modoC='ALTA'>

<cfif isdefined('form.SNCcodigoLista') and Len(form.SNCcodigoLista)>
	<cfset modoC="CAMBIO">
<cfelse>
	<cfset modoC="ALTA">
</cfif>



<!--- <cfif isdefined("Form.Cambio")>
	<cfset modoC="ALTA">
<cfelse>
	<cfif not isdefined("Form.modoC")>
		<cfset modoC="ALTA">
	<cfelseif #Form.modoC# EQ "CAMBIO">
		<cfset modoC="CAMBIO">
	<cfelse>
		<cfset modoC="ALTA">
	</cfif>
</cfif> --->

<cfif isdefined("url.SNCcodigo") and len(trim(url.SNCcodigo)) and not isdefined("form.SNCcodigo")>
	<cfset form.SNCcodigo = url.SNCcodigo>
</cfif>




<!--- <cfdump var="#form#"> --->
<cfif isDefined("session.Ecodigo") and isDefined("Form.SNcodigo") and len(trim(#Form.SNcodigo#))>
	<cfquery name="rsContactosD" datasource="#Session.DSN#">
		select Ecodigo, SNcodigo, SNCcodigo, SNCidentificacion, SNCnombre , 
		SNCdireccion, SNCtelefono, SNCfax, SNCemail, SNCfecha,ts_rversion     
		from SNDContactos
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		<cfif  isdefined("Form.SNcodigo") and len(trim(Form.SNcodigo))>
			and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">		  
		</cfif>  				  
		<cfif  isdefined("Form.SNCcodigoLista") and len(trim(Form.SNCcodigoLista))>
			and SNCcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SNCcodigoLista#">
		</cfif>  				  
		order by SNCnombre asc
	</cfquery>
</cfif> <!--- <cfdump var="#rsContactosD#">  --->
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
<form action="SQLContactosxDireccion.cfm" method="post" name="formCD"><!--- onSubmit="if (this.botonSel.value != 'Baja' && this.botonSel.value != 'Nuevo'){ MM_validateForm('SNCidentificacion','','R','SNCnombre','','R','SNCtelefono','','R','SNemail','','NisEmail','SNCdireccion','','R');return document.MM_returnValue}else{return true;}" --->
  <table width="67%" height="75" align="center" cellpadding="0" cellspacing="0">
    <tr> 
      <td width="27%" align="right" valign="baseline" nowrap>&nbsp;</td>
    </tr>
    <tr> 
      <td align="right" valign="middle" nowrap>Nombre:&nbsp;</td>
      <td width="73%" valign="middle"><input name="SNCDnombre" tabindex="1" type="text" onFocus="javascript: this.select();" value="<cfif modoC NEQ "ALTA">#rsContactosD.SNCnombre#</cfif>" size="45" maxlength="255" alt="El Nombre"></td>
    </tr>
    <tr>
      <td valign="middle" nowrap><div align="right">Identificaci&oacute;n:&nbsp;</div></td>
      <td valign="middle" nowrap>
        <input tabindex="1" name="SNCDidentificacion" type="text" onFocus="javascript: this.select();" value="<cfif modoC NEQ "ALTA">#rsContactosD.SNCidentificacion#</cfif>" size="20" maxlength="30" alt="La Identificación">
      </td>
    </tr>
    <tr>
      <td valign="middle" nowrap><div align="right">Fecha:&nbsp;</div></td>
      <td valign="middle">
			<cfoutput>
				<cfset fechadoc = LSDateFormat(Now(),'dd/mm/yyyy') >
				<cfif modoC neq 'ALTA'>
					<cfset fechadoc = LSDateFormat(rsContactosD.SNCfecha,'dd/mm/yyyy') >
				</cfif>
			</cfoutput>			
			<cf_sifcalendario value="#fechadoc#" form="formCD" tabindex="1" name="SNCDfecha">			  
      </td>
    </tr>
    <tr>
      <td valign="middle" nowrap><div align="right">E-Mail:&nbsp;</div>
      </td>
      <td valign="middle">
        <input name="SNCDemail" tabindex="1" type="text" onFocus="javascript: this.select();" onBlur="return document.MM_returnValue" value="<cfif modoC NEQ "ALTA">#rsContactosD.SNCemail#</cfif>" size="45" maxlength="100" alt="El E-mail">
      </td>
    </tr>
    <tr>
      <td align="right" valign="middle" nowrap>Tel&eacute;fono:&nbsp;</td>
      <td valign="middle"><input name="SNCDtelefono" tabindex="1" type="text" onFocus="javascript: this.select();" value="<cfif modoC NEQ "ALTA">#rsContactosD.SNCtelefono#</cfif>" size="20" maxlength="30" alt="El Teléfono">
      </td>
    </tr>
    <tr>
      <td valign="middle" nowrap>
        <div align="right">Fax:&nbsp;</div>
      </td>
      <td><input name="SNCDFax" tabindex="1" type="text" onFocus="javascript: this.select();" value="<cfif modoC NEQ "ALTA">#rsContactosD.SNCFax#</cfif>" size="18" maxlength="30" alt="El Fax">
      </td>
    </tr>
    <tr> 
      <td align="right" valign="top" nowrap>Direcci&oacute;n:&nbsp;</td>
      <td colspan="7" align="left" valign="baseline" nowrap> <textarea tabindex="1" name="SNCDdireccion" cols="40" rows="4" onFocus="javascript: this.select();" alt="La Dirección del Contacto"><cfif modoC NEQ "ALTA">#rsContactosD.SNCdireccion#</cfif></textarea> 
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
         <!---  <cfinclude template="../../portlets/pBotones.cfm"> --->
		 <cf_botones modo=#modoC# sufijo="ContactoD" form="formCD" tabindex="1">
          
        </div></td>
    </tr>
  </table>
<cfset ts = "">
  <cfif modoC NEQ "ALTA">
    <cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
		<cfinvokeargument name="arTimeStamp" value="#rsContactosD.ts_rversion#"/>
	</cfinvoke>
</cfif>  
  <input type="hidden" name="ts_rversion" value="<cfif modoC NEQ "ALTA">#ts#</cfif>" size="32">
  <input type="hidden" name="SNcodigo" value="#Form.SNcodigo#"> 
  <input type="hidden" name="id_direccion" value="#Form.id_direccion#"> 
  <input type="hidden" name="SNCcodigolista" value="<cfif rsContactosD.recordcount GT 0>#rsContactosD.SNCcodigo#</cfif>"
  	alt="El campo Código de Contacto">
	<input type="hidden" name="modo" value="<cfif isdefined("form.modo")>#form.modo#</cfif>">
  <input type="hidden" name="modoC" value="#modoC#">
</form>

</cfoutput>



