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

<cfquery datasource="#Session.DSN#" name="rsNiveles">
	select Ncodigo, Ndescripcion from Nivel 
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.CEcodigo#">
</cfquery>
<cfif isdefined("Form.Gcodigo") and Form.Gcodigo NEQ ""  and  isdefined("Form.Ncodigo") and Form.Gcodigo NEQ "">
	<cfquery datasource="#Session.DSN#" name="rsGrado">
		select Gcodigo, Ncodigo, Gdescripcion, Ganual, Gorden, Ganterior, Nanterior from Grado 
		where Gcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Gcodigo#">
		  and  Ncodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ncodigo#">
	</cfquery>
</cfif>
<cfif modo NEQ "ALTA" and isdefined("Form.Gcodigo") and len(trim("Form.Gcodigo")) GT 0>
	<cfquery datasource="#Session.DSN#" name="rsHayGrupos">
		select 1 from Grado a, Nivel b, Grupo c
		where a.Ncodigo = <cfqueryparam value="#rsGrado.Ncodigo#" cfsqltype="cf_sql_numeric">
		  and b.CEcodigo =  <cfqueryparam value="#Session.CEcodigo#" cfsqltype="cf_sql_integer">
		  and c.Gcodigo  = <cfqueryparam value="#rsGrado.Gcodigo#" cfsqltype="cf_sql_numeric">
		  and a.Ncodigo = b.Ncodigo
		  and b.Ncodigo = c.Ncodigo
		  and a.Gcodigo = c.Gcodigo
	</cfquery>
</cfif>
<script language="JavaScript" type="text/JavaScript">
<!--

<!--- 
function validaHayGrupos()
{
	alert("Entro");
	<cfif modo NEQ "ALTA" and rsHayGrupos.recordCount NEQ 0>
		alert("Hay Grupo");
		document.form1.Ncodigo.disabled=true;
		return false	
	<cfelse>
		alert("No hay Grupo");
		document.form1.Ncodigo.disabled=false;
		return true
	</cfif>

}
 --->
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





 
<form action="SQLGrado_filtro.cfm" method="post" name="form1" onSubmit="MM_validateForm('Gdescripcion','','R');if (document.MM_returnValue) { document.form1.Ncodigo.disabled = false; return true } else { return false } ">
  <table align="center">
  <tr><td class="subTitulo" colspan="2" align="center"><font size="3"><cfif modo eq "ALTA">Nuevo Grado<cfelse>Modificar Grado</cfif></font></td></tr>
    <tr valign="baseline"> 
      <td align="right" valign="middle" nowrap>Descripción:</td>
      <td><input name="Gdescripcion" type="text" value="<cfif modo NEQ "ALTA"><cfoutput>#rsGrado.Gdescripcion#</cfoutput></cfif>" size="50" maxlength="255" alt="La descripci&oacute;n del Grado" onfocus="this.select();"> 
      </td>
    <tr valign="baseline"> 
      <td nowrap align="right"> Nivel:</td>
      <td nowrap> <select name="Ncodigo" id="Ncodigo" <cfif modo NEQ "ALTA" and rsHayGrupos.recordCount NEQ 0>disabled</cfif>>
          <cfoutput query="rsNiveles"> 
            <option value="#Ncodigo#" <cfif (isDefined("form.Ncodigo") AND #form.Ncodigo# EQ #rsNiveles.Ncodigo#)>selected</cfif>>#rsNiveles.Ndescripcion# 
            </option>
          </cfoutput> </select> <cfif rsNiveles.RecordCount eq 0>
          <a href="../plan/Nivel.cfm?modulo=1" ><img src="../../Imagenes/Documentos2.gif" alt="Agregar Nivel en el Centro Educativo" border="0" align="baseline">&nbsp; 
          Agregar nuevo Nivel en el Centro Educativo</a> </cfif> </td>
      <cfif rsNiveles.recordCount EQ 0>
        <a href="../plan/Nivel.cfm?modulo=1" ><img src="../../Imagenes/Documentos2.gif" alt="Crear Nivel para el Centro Educativo" border="0" align="baseline">&nbsp;Crea 
        nuevo Nivel para éste Centro de Estudio</a> 
      </cfif>
    </tr>
    <tr valign="baseline"> 
      <td nowrap align="right">Orden:</td>
      <td><input name="Gorden" type="text" id="Gorden" size="8" maxlength="8" value="<cfif modo NEQ "ALTA"><cfoutput>#rsGrado.Gorden#</cfoutput></cfif>" onfocus="this.value=qf(this); this.select();" onblur="fm(this,0);"  onkeyup="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" ></td>
    </tr>
    <tr valign="baseline"> 
      <td colspan="2" align="center" nowrap><cfinclude template="../../portlets/pBotones.cfm"> &nbsp; <input type="hidden" name="Gcodigo" value="<cfif modo NEQ "ALTA"><cfoutput>#rsGrado.Gcodigo#</cfoutput></cfif>"> 
        <input type="hidden" name="Ganual" value="<cfif #modo# NEQ "ALTA"><cfoutput>#rsGrado.Ganual#</cfoutput></cfif>"> 
        <input type="hidden" name="_Ncodigo" value="<cfif #modo# NEQ "ALTA"><cfoutput>#rsGrado.Ncodigo#</cfoutput></cfif>">	
		<!--- <input type="hidden" name="Gorden" value="<cfif #modo# NEQ "ALTA"><cfoutput>#rsGrado.Gorden#</cfoutput></cfif>">  --->
    </tr>
  </table>

</form>
<script language="JavaScript1.2" type="text/javascript">
	document.form1.Ncodigo.alt = "El valor de Nivel";
</script> 