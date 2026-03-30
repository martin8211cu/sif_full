<!---Modo--->
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
<!---Origen--->
<cf_dbfunction name="sPart" args="o.Odescripcion,1,33" returnvariable="corte_var">
<cf_dbfunction name="concat" args="#corte_var#*'...'" returnvariable="concatena_var" delimiters="*">
<cf_dbfunction name="length" args="o.Odescripcion" returnvariable="longitud_var">
<cfquery datasource="#Session.DSN#" name="rsOrigenes" >
	select o.Oorigen, 
	case when #longitud_var# > 33
		 then #preservesinglequotes(concatena_var)#
		 else o.Odescripcion
		end as Odescripcion 
		from Origenes o
			where not exists
			(select 1
					from ConceptoContable 
						where Ecodigo =  #Session.Ecodigo# 
			  			and Oorigen = o.Oorigen
			)
	order by o.Oorigen
</cfquery>
<!---Conceptos--->
<cfquery datasource="#Session.DSN#" name="rsConceptos">
	select Cconcepto,Cdescripcion 
		from ConceptoContableE 
			where Ecodigo =  #Session.Ecodigo# 
</cfquery>
<cfif isdefined("Form.Oorigen")>
	<cfquery name="rs" datasource="#Session.DSN#">
		select Cconcepto,Cdescripcion, Resumir, Chknoreglas, Chknovalmayor, Chknovaloficinas, ts_rversion
			from ConceptoContable 
				where Ecodigo =  #Session.Ecodigo# 
				and Oorigen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Oorigen#">
	</cfquery>
</cfif>
	 
<form method="post" name="form1" onSubmit="if ( (this.botonSel.value != 'Baja') && (this.botonSel.value != 'Nuevo') ){ MM_validateForm('Cdescripcion','','R');return document.MM_returnValue}else{ return true; }" action="SQLConceptoContable.cfm">
	<table align="center">
    	<tr valign="baseline"> 
      		<td nowrap align="right">
				Origen:&nbsp;
			</td>
      		<td>
				<cfif modo NEQ "ALTA">
					<cfquery name="rsOrigen" datasource="#Session.DSN#">
						select Oorigen, Odescripcion 
							from Origenes 
								where Oorigen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Oorigen#">
					</cfquery>
					<cfoutput query="rsOrigen">
						#rsOrigen.Oorigen#-#rsOrigen.Odescripcion#
					</cfoutput>
					<input type="hidden" name="Oorigen" value="<cfoutput>#Form.Oorigen#</cfoutput>">
				<cfelse>
					<select name="Oorigen">
						<cfoutput query="rsOrigenes"> 
							<option value="#rsOrigenes.Oorigen#">
								#rsOrigenes.Oorigen#:#rsOrigenes.Odescripcion#
							</option>
						</cfoutput> 
					</select>
				</cfif>
      		</td>
    	<tr valign="baseline"> 
      		<td nowrap align="right">
				Concepto:&nbsp;
			</td>
      		<td> 
				<select name="Cconcepto">
				  <cfoutput query="rsConceptos"> 
					<option value="#rsConceptos.Cconcepto#" 
						<cfif modo NEQ "ALTA"> 
								<cfif (rsConceptos.Cconcepto EQ rs.Cconcepto)>
									selected
								</cfif>
						</cfif>>
						#rsConceptos.Cdescripcion#
					</option>
				  </cfoutput> 
				</select>
      		</td>
    	<tr valign="baseline"> 
      		<td nowrap align="right">
				Descripci&oacute;n:&nbsp;</td>
      		<td> 
        		<input type="text" name="Cdescripcion" value="<cfif modo NEQ "ALTA"><cfoutput>#rs.Cdescripcion#</cfoutput></cfif>" size="32" onfocus="this.select();" alt="La Descripci&oacute;n del Concepto">
			</td>
    	</tr>
    	<tr > 
      		<td nowrap align="right">
				Agrupamiento 
			</td>
			<td>
			  	<select name="Resumir">
					<option value="0" <cfif modo EQ 'ALTA'>selected<cfelse><cfif modo NEQ 'ALTA' and rs.Resumir eq "0" >selected</cfif></cfif>>No Aplica</option>
					<option value="1" <cfif modo NEQ 'ALTA' and rs.Resumir eq "1" >selected</cfif>>Origen / Mes</option>
					<option value="2" <cfif modo NEQ 'ALTA' and rs.Resumir eq "2" >selected</cfif>> Origen / Mes / Oficina</option>
					<option value="3" <cfif modo NEQ 'ALTA' and rs.Resumir eq "3" >selected</cfif>>Origen / Mes / Oficina / Usuario</option>
					<option value="4" <cfif modo NEQ 'ALTA' and rs.Resumir eq "4" >selected</cfif>>Origen / Mes / Fecha</option>
					<option value="5" <cfif modo NEQ 'ALTA' and rs.Resumir eq "5" >selected</cfif>>Origen / Mes / Fecha / Oficina</option>
					<option value="6" <cfif modo NEQ 'ALTA' and rs.Resumir eq "6" >selected</cfif>>Origen / Mes / Fecha / Oficina / Usuario</option>
			  	</select>
		 	</td>
    	</tr>
		<tr>
			<td colspan="2">
				<cfif isdefined("form.PageNum")>
					<input type="hidden" name="PageNum" value="<cfoutput>#form.PageNum#</cfoutput>">
				</cfif>
			</td>
		</tr>
		<tr>
			<td align="left">&nbsp;
				
			</td>
			<td align="left">
					<p>
						<input type="checkbox" name="chknoreglas" value="1" <cfif modo NEQ "ALTA" and rs.Chknoreglas EQ 1>checked="checked"</cfif>> No validar reglas<br>
						<input type="checkbox" name="chknovalmayor" value="1" <cfif modo NEQ "ALTA" and rs.Chknovalmayor EQ 1>checked="checked"</cfif>> No validar valores por cuenta de mayor<br>
						<input type="checkbox" name="chknovaloficinas" value="1" <cfif modo NEQ "ALTA" and rs.Chknovaloficinas EQ 1>checked="checked"</cfif>> No validar valores por oficina<br>
					</p>
			</td>
		</tr>
		<tr valign="baseline"> 
		  	<td colspan="2" align="center" nowrap>
		  		<cfinclude template="../../portlets/pBotones.cfm">&nbsp; 
			</td>
		</tr>
	</table>
		<cfset ts = "">	
  <cfif modo neq "ALTA">
		<cfinvoke 
			component="sif.Componentes.DButils"
			method="toTimeStamp"
			returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#rs.ts_rversion#"/>
		</cfinvoke>
  </cfif>
  		<input type="hidden" name="ts_rversion" value="<cfif modo NEQ 'ALTA'><cfoutput>#ts#</cfoutput></cfif>">
</form>
<!---Validaciones--->
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
        if (p<1 || p==(val.length-1)) errors+='- '+nm+' no es una direcci&oacute;n de correo electr&oacute;nica válida.\n';
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


