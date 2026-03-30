<!-- Establecimiento del modo -->
<cfset modo="ALTA">
<cfif isdefined('form.TRcodigo') and len(trim(form.TRcodigo)) >
	<cfset modo="CAMBIO">
</cfif>

<!-- Consultas -->
<!-- 1. Form -->
<cfquery datasource="#session.DSN#" name="rsForm">
	select  TRcodigo, TRdescripcion, ts_rversion, TRreversaCreditoFiscal
	from TRequisicion
	where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer" >
	<cfif isdefined("Form.TRcodigo") and Form.TRcodigo NEQ "" >
		and TRcodigo = <cfqueryparam value="#Form.TRcodigo#" cfsqltype="cf_sql_varchar">
	</cfif>
</cfquery>

<!--- 4. Tiene referencias --->
<cfif modo neq 'ALTA'>
	<cfquery name="rsDelete" datasource="#session.DSN#">
		select 1 from ERequisicion where TRcodigo=<cfqueryparam value="#form.TRcodigo#" cfsqltype="cf_sql_char" > and Ecodigo=<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" >
		union
		select 1 from CTipoRequisicion where TRcodigo=<cfqueryparam value="#form.TRcodigo#" cfsqltype="cf_sql_char" > and Ecodigo=<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" >
		union
		select 1 from Parametros where Ecodigo=<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" > and Pcodigo=360 and Pvalor=<cfqueryparam value="#form.TRcodigo#" cfsqltype="cf_sql_char" >
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

function borrar(){
	<cfif modo neq 'ALTA' AND rsDelete.RecordCount gt 0 >
		alert('El Tipo de Requisición no se puede ser eliminado.');
		return false;
	<cfelse>
		if ( confirm('¿Desea Eliminar el Registro?') ){
			return true;
		}
		else{
			return false;
		}
	</cfif>
}

</script>
<cfoutput>
<form action="SQLTRequisicion.cfm" method="post" name="trequisicion" onSubmit="if ( this.botonSel.value != 'Nuevo' && this.botonSel.value != 'Baja'){ MM_validateForm('TRcodigo','','R','TRdescripcion','','R');return document.MM_returnValue}else{return true;}" >
	<input name="Pagina" type="hidden" tabindex="-1" value="#form.Pagina#">	
	<input name="MaxRows" type="hidden" tabindex="-1" value="#form.MaxRows#">		
	<input type="hidden" name="filtro_TRdescripcion" value="<cfif isdefined('form.filtro_TRdescripcion') and form.filtro_TRdescripcion NEQ ''>#form.filtro_TRdescripcion#</cfif>">

	<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td valign="baseline" align="right">C&oacute;digo:&nbsp;</td>
			<td>
				<input tabindex="1" type="text" name="TRcodigo" size="4" maxlength="4" value="<cfif modo NEQ 'ALTA'>#rsForm.TRcodigo#</cfif>" <cfif modo NEQ 'ALTA'>readonly</cfif> alt="El C&oacute;digo de Requisici&oacute;n" onfocus="javascript:this.select();">
			</td>
		</tr>

		<tr>
			<td valign="baseline" align="right">Descripci&oacute;n:&nbsp;</td>
			<td>
				<input tabindex="1" type="text" name="TRdescripcion" size="50"  maxlength="50" value="<cfif modo NEQ 'ALTA'>#rsForm.TRdescripcion#</cfif>" alt="La Descripci&oacute;n de la Requisici&oacute;n" onfocus="javascript:this.select();">
			</td>
		</tr>

		<tr>
			<td valign="baseline" align="right">Tratamiento de Impuestos:&nbsp;</td>
			<td>
				<select name="TRreversaCreditoFiscal">
					<option value="0">Mantener Credito Fiscal</option>
					<option value="1" <cfif modo NEQ 'ALTA' AND rsForm.TRreversaCreditoFiscal EQ 1>selected</cfif>>Reversar Credito Fiscal</option>
				</select>
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
	</cfoutput>		
		<!--- *************************************************** --->
		<cfif modo NEQ 'ALTA'>
			<tr>
			  <td colspan="2" align="center" class="tituloListas">Complementos Contables</td>
			</tr>
			<tr><td colspan="2" align="center">
			<cf_sifcomplementofinanciero action='display'
					tabla="TRequisicion"
					form = "trequisicion"
					llave="#Form.TRcodigo#" />		
			</td></tr>
		</cfif>	
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr>
			<td align="center" valign="baseline" colspan="2">
				<cf_Botones modo="#modo#" tabindex="1">
			</td>	
		</tr>

		<cfset ts = "">	
		<cfif modo neq "ALTA">
			<cfinvoke 
				component="sif.Componentes.DButils"
				method="toTimeStamp"
				returnvariable="ts">
				<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
			</cfinvoke>
		</cfif>
		<input type="hidden" name="ts_rversion" value="<cfif modo NEQ 'ALTA'><cfoutput>#ts#</cfoutput></cfif>">
	</table>
</form>

<script language="javascript" type="text/javascript">
	document.trequisicion.TRcodigo.focus();
</script>