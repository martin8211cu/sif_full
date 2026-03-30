<cfparam name="modo" default="ALTA">

<cfif isdefined('url.AnexoCelId2')>
	<cfparam name="Form.AnexoCelId2" default="#url.AnexoCelId2#">
<cfelse>	
	<cfparam name="Form.AnexoCelId2" default="">
</cfif>

<cfif Len(trim(Form.AnexoCelId2)) NEQ 0>
	<cfset modo = "CAMBIO">
</cfif>

<cfquery name="rsConceptos" datasource="#Session.DSN#">
	SELECT * FROM ConceptoAnexos 
</cfquery>

<cfquery name="rsOficinas" datasource="#Session.DSN#">
	SELECT Ocodigo, Odescripcion FROM Oficinas where Ecodigo = #Session.Ecodigo#
</cfquery>

<cfquery name="rsMeses" datasource="#Session.DSN#">
	select 
		VSvalor, VSdesc 
	from VSidioma where VSgrupo = 1
	order by <cf_dbfunction name="to_char_integer" args="VSvalor">
</cfquery>

<cfquery name="rsLinea" datasource="#Session.DSN#">
	select 
		<cf_dbfunction name="to_char" args="AnexoCelId"> as AnexoCelId, 
		<cf_dbfunction name="to_char" args="AnexoId"> as AnexoId, 
		AnexoRan, AnexoCon, AnexoRel, AnexoMes, AnexoPer, Ocodigo, AnexoNeg 
	from AnexoCel 
	where AnexoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.AnexoId#">
	 <cfif isdefined("Form.AnexoCelId2") and Len(Trim(Form.AnexoCelId2)) neq 0>
	  and AnexoCelId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AnexoCelId2#">
	 </cfif>
</cfquery>

<script language="JavaScript" type="text/JavaScript">
	<!--
	function MostrarCuentas(){
		document.form1.action="Definircuentas.cfm";
		document.form1.submit();
	}
	
	function OcultarPer(valor) {
		if (valor) {
			document.form1.AnexoPer.value=0;
			document.form1.Meses.style.visibility="hidden";
			document.form1.AnexoMes.style.visibility="visible";
			document.form1.AnexoPer.style.visibility="hidden";
			document.form1.lblPeriodo.style.visibility="hidden";
		}
		else {
			document.form1.AnexoPer.style.visibility="visible";
			document.form1.lblPeriodo.style.visibility="visible";
			document.form1.Meses.style.visibility="visible";
			document.form1.AnexoMes.style.visibility="hidden";
		
		}
	}
	
	function MuestrabtnCuentas(valor) {
		<cfif modo EQ "CAMBIO">
		if (parseInt(valor)<20) 
			document.form1.btnCuentas.style.visibility="hidden";
		else
			document.form1.btnCuentas.style.visibility="visible";
		</cfif>
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
  <form action="SQLAnexoCel.cfm" method="post" name="form1" onSubmit="MM_validateForm('AnexoRan','','R','AnexoMes','','RinRange0:99','AnexoPer','','R');return document.MM_returnValue">
    <table align="center">
      <tr valign="baseline"> 
        <td width="90" align="right" nowrap>Rango:</td>
        <td colspan="3"><input type="text" name="AnexoRan" value="<cfif isdefined("Form.AnexoRan2")>#Trim(Form.AnexoRan2)#<cfelseif isdefined('rsLinea.AnexoRan') and Len(trim(Form.AnexoCelId2)) GT 0>#rsLinea.AnexoRan#</cfif>" size="32" onfocus="javascript:this.select();" alt="El nombre del Rango"></td>
      </tr>
      <tr valign="baseline"> 
        <td nowrap align="right">Concepto:</td>
        <td colspan="3"> <select name="AnexoCon" onChange="javascript:MuestrabtnCuentas(this.value);">
            <cfloop query="rsConceptos">
              <option value="#rsConceptos.CAcodigo#.#rsConceptos.CAcodigo#" <cfif (isDefined("rsLinea.AnexoCon") AND rsConceptos.CAcodigo EQ rsLinea.AnexoCon) and modo NEQ "ALTA">selected</cfif>>#rsConceptos.CAdescripcion#</option>
            </cfloop>
          </select> </td>
      <tr valign="baseline"> 
        <td nowrap align="right">&nbsp;</td>
        <td colspan="3"><input type="checkbox" name="AnexoRel" 
	  					value="<cfif modo neq 'ALTA'>#rsLinea.AnexoRel#<cfelse>0</cfif>"
						<cfif modo neq 'ALTA' and rsLinea.AnexoRel EQ 1>checked</cfif>
						onClick="javascript:OcultarPer(this.checked);"
						>
          Mes Relativo</td>
      </tr>
      <tr valign="baseline"> 
        <td nowrap align="right"> 
          <input name="lblMes" type="text" class="cajasinbordeb" tabindex="-1" value="Mes:" size="16" maxlength="16" readonly style="text-align:right">
        </td>
        <td width="32">
						<select name="Meses">
							<cfloop query="rsMeses">
				            	<option value="#rsMeses.VSvalor#" <cfif (isDefined("rsLinea.AnexoMes") AND rsMeses.VSvalor EQ rsLinea.AnexoMes)>selected</cfif>>#rsMeses.VSdesc#</option>
							</cfloop>
			            </select>
					<input type="text" name="AnexoMes" value="<cfif modo neq 'ALTA'>#rsLinea.AnexoMes#<cfelse>0</cfif>" size="3" maxlength="2" onFocus="javascript:this.select()" 
						onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}};"					
						alt="El valor del Mes">
						<script language="JavaScript1.2">
							if (document.form1.AnexoRel.checked)
								document.form1.AnexoMes.style.visibility="visible";
							else
								document.form1.AnexoMes.style.visibility="hidden";
						</script>
		</td>
        <td width="30"><div align="right">
            <input name="lblPeriodo" type="text" class="cajasinbordeb" tabindex="-1" value="Período:" size="16" maxlength="16" readonly style="text-align:right">
          </div></td>
        <td width="182"><input type="text" name="AnexoPer" value="<cfif modo neq 'ALTA'>#rsLinea.AnexoPer#</cfif>" size="3" maxlength="2" onFocus="javascript:this.select();" alt="El valor del Período" 
						onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}};"					
						></td>
      </tr>
						<script language="JavaScript1.2">
						<cfif modo neq 'ALTA' and rsLinea.AnexoRel EQ 1>
							OcultarPer(true);
						</cfif>
						</script>
      <tr valign="baseline"> 
        <td nowrap align="right">Oficina:</td>
        <td colspan="3"> <select name="Ocodigo">
            <option value="-1">Selecionada</option>
            <cfloop query="rsOficinas">
              <option value="#rsOficinas.Ocodigo#" <cfif modo NEQ "ALTA" and rsOficinas.Ocodigo EQ rsLinea.Ocodigo>selected</cfif> >#rsOficinas.Odescripcion#</option>
            </cfloop>
          </select> </td>
      <tr valign="baseline"> 
        <td nowrap align="right">&nbsp;</td>
        <td colspan="3"><input type="checkbox" name="AnexoNeg" 
	  					value="<cfif modo neq 'ALTA'>#rsLinea.AnexoNeg#<cfelse>0</cfif>"
						<cfif modo neq 'ALTA' and rsLinea.AnexoNeg EQ 1>checked</cfif>  >
          Presentar resultado en negativo</td>
      </tr>
      <tr valign="baseline"> 
        <td colspan="4" align="right" nowrap><div align="center"> 
  <input type="hidden" name="AnexoCelId" value="<cfif modo NEQ "ALTA">#Form.AnexoCelId2#</cfif>">
  <input type="hidden" name="AnexoId" value="#url.AnexoId#">
            <cfinclude template="../../portlets/pBotones.cfm">
			<cfif modo EQ "CAMBIO">
            	<input type="button" name="btnCuentas" value="Cuentas" onclick="javascript:MostrarCuentas();">
				<script language="JavaScript1.2">
					MuestrabtnCuentas(<cfoutput>#rsLinea.AnexoCon#</cfoutput>);
				</script>
			</cfif>
			<input type="button" name="btnCerrar" value="Cerrar" onclick="javascript:cerrar();">
</div>
			</td>
      </tr>
    </table>
</form>
</cfoutput>
<script language="JavaScript1.2">
	document.form1.AnexoRan.focus();
	
	function cerrar(){
		window.opener.form1.action = '';
		window.opener.form1.submit();
		window.close();
	} 
	
</script>
