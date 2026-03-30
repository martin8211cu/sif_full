<cfinvoke  key="Msg_SePreSigErr" default="Se presentaron los siguientes errores:\n\n" component="sif.Componentes.Translate" method="Translate"
returnvariable="Msg_SePreSigErr"  xmlfile="Htipocambio.xml"/>
<cfinvoke  key="Msg_esreq" default="es requerido.\n" component="sif.Componentes.Translate" method="Translate"
returnvariable="Msg_esreq"  xmlfile="Htipocambio.xml"/>
<cfinvoke  key="Msg_ELTpoCambCompra" default="El Tipo de Cambio de Compra" component="sif.Componentes.Translate" method="Translate"
returnvariable="Msg_ELTpoCambCompra"  xmlfile="Htipocambio.xml"/>
<cfinvoke  key="Msg_ELTpoCambVenta" default="El Tipo de Cambio de Venta" component="sif.Componentes.Translate" method="Translate"
returnvariable="Msg_ELTpoCambVenta"  xmlfile="Htipocambio.xml"/>
<cfinvoke  key="Msg_ELTpoCambProm" default="El Tipo de Cambio promedio" component="sif.Componentes.Translate" method="Translate"
returnvariable="Msg_ELTpoCambProm"  xmlfile="Htipocambio.xml"/>


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

<cfquery datasource="#Session.DSN#" name="rsHtipocambio">
	select htc.Mcodigo, Hfecha, TCcompra, TCventa,TCpromedio, Husuario, Mnombre, htc.ts_rversion
	from Htipocambio htc, Monedas m
	where htc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	<cfif isdefined("Form.Hfecha") and form.Hfecha NEQ "">
 		and Hfecha = <cfqueryparam cfsqltype="cf_sql_timestamp"  value="#Form.Hfecha#">
		and htc.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#Form.Mcodigo#">
	</cfif>
	  and htc.Ecodigo = m.Ecodigo
	  and htc.Mcodigo = m.Mcodigo
</cfquery>

<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
	select Mcodigo from Empresas where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>
<cfoutput>
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
    } } } else if (test.charAt(0) == 'R') errors += '- '+nm+' #Msg_esreq#'; }
  } if (errors) alert('#Msg_SePreSigErr#'+errors);
  document.MM_returnValue = (errors == '');
}
//-->
</script>
</cfoutput>
<cfset LvarAction = 'SQLHtipocambio.cfm'>
<cfif isdefined("LvarQPass")>
	<cfset LvarAction = 'QPassTCSQL.cfm'>
</cfif>
<form action="<cfoutput>#LvarAction#</cfoutput>" method="post" name="form1" onSubmit="MM_validateForm('Mcodigo','','R','Hfecha','','R','TCcompra','','R','TCventa','','R','TCpromedio','','R');return document.MM_returnValue">
  <table align="center">
		<tr valign="baseline">
      		<td nowrap align="right"><cf_translate key=LB_Moneda>Moneda</cf_translate>:&nbsp;</td>
      		<td>
			<cfif MODO EQ "ALTA">
				<cf_sifmonedas tabindex="1">

				<!--- Quita del combo la moneda local --->
				<script language="JavaScript1.2">
					var existeMonedaLocal = false;
					var long = document.form1.Mcodigo.length;
					for (var i = 0; i < long - 1; i++) {
						if (document.form1.Mcodigo.options[i].value == "<cfoutput>#Trim(rsMonedaLocal.Mcodigo)#</cfoutput>")
							existeMonedaLocal = true;
						if (existeMonedaLocal) {
							document.form1.Mcodigo.options[i].value = document.form1.Mcodigo.options[i+1].value;
							document.form1.Mcodigo.options[i].text = document.form1.Mcodigo.options[i+1].text;
						}
					}
					document.form1.Mcodigo.length = long - 1;
					document.form1.Mcodigo.alt = 'La Moneda ';
				</script>
			<cfelse>
				<input type="text" name="Mnombre" value="<cfoutput>#rsHtipocambio.Mnombre#</cfoutput>"  size="30" maxlength="30" readonly="readonly" tabindex="1">
				<input type="hidden" name="Mcodigo" value="<cfoutput>#rsHtipocambio.Mcodigo#</cfoutput>">
			</cfif>

			</td>
    	</tr>

    	<tr valign="baseline">

      <td valign="middle"><div align="right"><cf_translate key=LB_Fecha>Fecha</cf_translate>:&nbsp;</div></td>
		    <td>
			<cfif MODO EQ "ALTA">
				<cf_sifcalendario name="Hfecha" value="#LSDateFormat(Now(),'DD/MM/YYYY')#" tabindex="1">
			<cfelse>
				<input name="Hfecha" type="text" value="<cfoutput>#LSDateFormat(rsHtipocambio.Hfecha,'DD/MM/YYYY')#</cfoutput>" size="10" maxlength="10"  tabindex="-1" readonly alt="El campo Fecha"/>
			</cfif>
			</td>
		</tr>

    	<tr valign="baseline">
      		<td nowrap align="right"><cf_translate key=LB_Compra>Compra</cf_translate>:&nbsp;</td>

      		<td>
                <input type="text" name="TCcompra" onBlur="javascript:calPromedio();" tabindex="1" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsHtipocambio.TCcompra#</cfoutput></cfif>"  size="10" maxlength="10" style="text-align: right;" onblur="javascript:fm(this,4);"  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}" alt=<cfoutput>"#Msg_ELTpoCambCompra#"</cfoutput>>
			</td>

    	</tr>

    	<tr valign="baseline">
      		<td nowrap align="right"><cf_translate key=LB_Venta>Venta</cf_translate>:&nbsp;</td>
      		<td>
				<input type="text" name="TCventa" onBlur="javascript:calPromedio();" tabindex="1" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsHtipocambio.TCventa#</cfoutput></cfif>"  size="10" maxlength="10" style="text-align: right;" onblur="javascript:fm(this,4);"  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}" alt=<cfoutput>"#Msg_ELTpoCambVenta#"</cfoutput>>
			</td>
    	</tr>

		<tr valign="baseline">
      		<td nowrap align="right"><cf_translate key=LB_Promedio>Promedio</cf_translate>:&nbsp;</td>
      		<td>
				<input type="text" name="TCpromedio" onBlur="javascript:calPromedio();" tabindex="1" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsHtipocambio.TCpromedio#</cfoutput></cfif>"  size="10" maxlength="10" style="text-align: right;" onblur="javascript:fm(this,4);"  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}" alt=<cfoutput>"#Msg_ELTpoCambProm#"</cfoutput>>
			</td>
    	</tr>

		<tr valign="baseline">
			<cfset tabindex = 1>
			<td colspan="2" align="right" nowrap><cfinclude template="../../portlets/pBotones.cfm"></td>
		</tr>
  </table>

	<cfset ts = "">
  <cfif modo neq "ALTA">
		<cfinvoke
		 component="sif.Componentes.DButils"
		 method="toTimeStamp"
		 returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#rsHtipocambio.ts_rversion#"/>
		</cfinvoke>
  </cfif>
  <input type="hidden" name="ts_rversion" value="<cfif modo NEQ 'ALTA'><cfoutput>#ts#</cfoutput></cfif>">
</form>

<script language="JavaScript1.2" src="../../js/utilesMonto.js"></script>
<script language="JavaScript1.2" type="text/javascript">
	<cfif modo neq 'ALTA'>
		fm(document.form1.TCcompra,4);
		fm(document.form1.TCventa,4);
		fm(document.form1.TCpromedio,4);
	</cfif>
	function calPromedio()
	{
	<!----	Valor promedio = (Valor de Venta + Valor de Compra) / 2	--->
		var venta=document.form1.TCventa.value;
		var compra=document.form1.TCcompra.value;
		var promedio=((parseFloat(venta) + parseFloat(compra))/2);

		document.form1.TCpromedio.value=promedio+"";
	}
</script>