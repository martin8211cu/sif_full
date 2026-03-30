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

<cfif isDefined("session.Ecodigo") and isDefined("Form.Cid") and len(trim(#Form.Cid#)) NEQ 0>
	<cfquery name="rsConceptos" datasource="#Session.DSN#" >
		Select Cid, Ecodigo, Ccodigo, Ctipo, Cdescripcion, timestamp
        from Conceptos
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Cid#" >		  
		order by Cdescripcion asc
	</cfquery>
</cfif>

<script language="JavaScript" type="text/JavaScript">
<!--
function CtasConcepto(data1) {
   // alert(data1);
	if (data1!="") {
		document.form.action='CtasConcepto.cfm';
		document.form.submit();
	}
	return false;
}
 
//-->
</script>
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
<script language="JavaScript" type="text/JavaScript">
<!--

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}
//-->
</script>


<link href="sif.css" rel="stylesheet" type="text/css">
<body onLoad="MM_preloadImages('date_d.GIF');MM_validateForm('Aplaca','','R');return document.MM_returnValue">
<form action="SQLConceptos.cfm" method="post" name="form" onSubmit="document.form.Ccodigo.disabled=false;MM_validateForm('Ccodigo','','R','Cdescripcion','','R');return document.MM_returnValue">
  <table width="67%" height="75%" align="center" cellpadding="0" cellspacing="0">
    <tr valign="baseline" bgcolor="#FFFFFF"> 
      <td width="21%" align="center" nowrap><div align="left"><strong><font color="#333366">Tipo</font></strong></div></td>
      <td width="16%" align="right" nowrap>C&oacute;digo:</td>
      <td width="6%" >&nbsp;</td>
      <td width="23%" ><input name="Ccodigo" type="text"   value="<cfif #modo# NEQ "ALTA" ><cfoutput>#rsConceptos.Ccodigo#</cfoutput></cfif>" size="10" maxlength="10"  alt="El campo Cdigo del Concepto" <cfif #modo# NEQ 'ALTA'>disabled</cfif>> 
      </td>
      <td width="34%" nowrap> <div align="right"></div></td>
    </tr>
    <tr valign="baseline" bgcolor="#FFFFFF"> 
      <td align="right" valign="middle" nowrap> <div align="left"> 
<!---           <cfif #modo# NEQ "ALTA" >
 --->         <cfif (#modo# NEQ "ALTA") and (#rsConceptos.Ctipo# EQ "I")>
              <div align="left"><strong> <font color="#0033CC">Ingreso</font> 
                </strong> </div>
              <cfelse>
              <div align="left">Ingreso </div>
	          </cfif>
<!---           </cfif>
 --->        </div></td>
      <td height="20" align="right" valign="middle" nowrap>Tipo: </td>
      <td valign="middle">&nbsp;</td>
      <td valign="middle"> <div align="left"> 
          <select name="Ctipo">
            <option value="I" <cfif (isDefined("rsConceptos.Ctipo") AND "I" EQ rsConceptos.Ctipo)>selected</cfif>>Ingreso</option>
            <option value="G" <cfif (isDefined("rsConceptos.Ctipo") AND "G" EQ rsConceptos.Ctipo)>selected</cfif>>Gasto</option>
          </select>
        </div></td>
      <td valign="middle" nowrap> <div align="right"></div></td>
      <!---       <script language="JavaScript">AgregarCombo(document.form.ACid,document.form.ACcodigo.value);</script>
    --->
    </tr>
    <tr valign="baseline" bgcolor="#FFFFFF"> 
      <td align="right" nowrap> <div align="left"> 
<!---           <cfif #modo# NEQ "ALTA" >
 --->            <cfif (#modo# NEQ "ALTA") and (#rsConceptos.Ctipo# EQ "G")>
              <div align="left"><strong> <font color="#0033CC">Gasto</font> </strong> 
              </div>
              <cfelse>
              <div align="left">Gasto </div>
            </cfif>
<!---           </cfif>
 --->        </div></td>
      <td align="right" nowrap>Descripci&oacute;n:</td>
      <td>&nbsp;</td>
      <td><input name="Cdescripcion" type="text"  value="<cfif #modo# NEQ "ALTA"><cfoutput>#rsConceptos.Cdescripcion#</cfoutput></cfif>" size="35" maxlength="50"  alt="El campo Descripcin del Concepto"></td>
      <td nowrap> <div align="right"></div></td>
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
            <input name="btnContactos" type="button" value="Cuentas por Concepto" 
	  onClick="javascript: document.form.Ccodigo.disabled = false;  document.pEmpresas2.Ecodigo.disabled = false; CtasConcepto('<cfoutput>trim(#rsConceptos.Ccodigo#)</cfoutput>')">
          </cfif>
        </div></td>
    </tr>
  </table>
<cfset ts = "">
  <cfif modo NEQ "ALTA">
    <cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
		<cfinvokeargument name="arTimeStamp" value="#rsConceptos.timestamp#"/>
	</cfinvoke>
</cfif>  
  <input type="hidden" name="timestamp" value="<cfif modo NEQ "ALTA"><cfoutput>#ts#</cfoutput></cfif>" size="32">
  <input type="hidden" name="Cid" value="<cfif modo NEQ "ALTA"><cfoutput>#rsConceptos.Cid#</cfoutput></cfif>">
  <input type="hidden" name="Ccodigo1" value="<cfif modo NEQ "ALTA"><cfoutput>#rsConceptos.Ccodigo#</cfoutput></cfif>">

	
 </form>
<p>&nbsp;</p>



