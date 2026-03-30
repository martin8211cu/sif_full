<!-- Establecimiento del modo -->
<cfset modo="ALTA">
<cfif isdefined('form.TRcodigo') and len(trim(form.TRcodigo)) 
	and isdefined('form.Dcodigo') and len(trim(form.Dcodigo)) >
	<cfset modo="CAMBIO">
</cfif>

<!-- Consultas -->
<!-- 1. Form -->
<cfif modo NEQ 'ALTA'>
	<cfquery datasource="#session.DSN#" name="rsForm">	
		select ctr.Dcodigo, ctr.TRcodigo, ctr.Ccuenta, ctr.ts_rversion, 
			   d.Ddescripcion, tr.TRdescripcion, cc.Cdescripcion, cc.Cformato, ctr.CFcuenta
		from CTipoRequisicion ctr 
	
		inner join Departamentos d
		on ctr.Dcodigo=d.Dcodigo
		   and ctr.Ecodigo=d.Ecodigo
	
		inner join TRequisicion tr
		on ctr.TRcodigo=tr.TRcodigo
		   and ctr.Ecodigo=tr.Ecodigo
	
		inner join CContables cc
		on ctr.Ecodigo=cc.Ecodigo
		   and ctr.Ccuenta = cc.Ccuenta
	
		where ctr.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer" >
			and ctr.Dcodigo  = <cfqueryparam value="#Form.Dcodigo#" cfsqltype="cf_sql_integer">
			and ctr.TRcodigo = <cfqueryparam value="#Form.TRcodigo#" cfsqltype="cf_sql_varchar">
	</cfquery>
</cfif>

<!-- 2. Combo Departamentos -->
<cfquery datasource="#session.DSN#" name="rsDepartamento">
	select Dcodigo, Ddescripcion 
	from Departamentos 
	where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" >
	order by Ddescripcion
</cfquery>

<!-- 3. Requisicion -->
<cfquery datasource="#session.DSN#" name="rsTRequisicion">
	select TRcodigo, TRdescripcion 
	from TRequisicion
	where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" >
	order by TRdescripcion
</cfquery>

<!-- 4. Combo Cuentas -->
<cfquery datasource="#session.DSN#" name="rsCuenta">
	select Ccuenta, Cdescripcion
	from CContables 
	where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" >
	  and Cmovimiento='S' 
	  and Mcodigo=1
	order by upper(Cdescripcion)
</cfquery>

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

<form action="SQLCTipoRequisicion.cfm" method="post" name="CTipoRequisicion" onSubmit="if ( this.botonSel.value != 'Nuevo' && this.botonSel.value != 'Baja'){MM_validateForm('Dcodigo','','R','TRcodigo','','R','Ccuenta','','R');return document.MM_returnValue}else{return true;}" >
	<cfoutput>
		<input name="Pagina" type="hidden" tabindex="-1" value="#form.Pagina#">	
		<input name="MaxRows" type="hidden" tabindex="-1" value="#form.MaxRows#">		
		<input type="hidden" name="filtro_TRdescripcion" value="<cfif isdefined('form.filtro_TRdescripcion') and form.filtro_TRdescripcion NEQ ''>#form.filtro_TRdescripcion#</cfif>">
		<input type="hidden" name="filtro_Cdescripcion" value="<cfif isdefined('form.filtro_Cdescripcion') and form.filtro_Cdescripcion NEQ ''>#form.filtro_Cdescripcion#</cfif>">	
	</cfoutput>	

	<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr>
			<td align="right">Departamento:&nbsp;</td>
			<td>
				<cfif modo EQ 'ALTA'>
					<select name="Dcodigo" tabindex="1">
						<cfoutput query="rsDepartamento">
							<option value="#rsDepartamento.Dcodigo#">#rsDepartamento.Ddescripcion#</option>
						</cfoutput>	
					</select>
				<cfelseif modo NEQ 'ALTA'>
					<input tabindex="1" type="text" name="Ddescripcion" value="<cfoutput>#rsForm.Ddescripcion#</cfoutput>" readonly >
					<input type="hidden" name="Dcodigo" value="<cfoutput>#rsForm.Dcodigo#</cfoutput>" >				
				</cfif>	
			</td>
		</tr>
		<tr>
			<td align="right">Requisici&oacute;n:&nbsp;</td>
			<td>
				<cfif modo EQ 'ALTA'>
					<select name="TRcodigo" tabindex="1">
						<cfoutput query="rsTRequisicion">
							<option value="#rsTRequisicion.TRcodigo#">#rsTRequisicion.TRdescripcion#</option>
						</cfoutput>
					</select>
				<cfelseif modo NEQ 'ALTA'>
					<input tabindex="1" type="text" name="TRdescripcion" size="49" value="<cfoutput>#rsForm.TRdescripcion#</cfoutput>" readonly >
					<input type="hidden" name="TRcodigo" value="<cfoutput>#rsForm.TRcodigo#</cfoutput>" >				
				</cfif>	
			</td>
		</tr>
		<tr>
			<td align="right">Cuenta:&nbsp;</td>
			<td>
				<cfif modo NEQ 'ALTA' >
					<cf_cuentas tabindex="1" Conexion="#session.DSN#" Conlis="S" query="#rsForm#" auxiliares="N" movimiento="S" form="CTipoRequisicion" ccuenta="Ccuenta" Cdescripcion="Cdescripcion" cformato="Cformato">
				<cfelse>
					<cf_cuentas tabindex="1" Conexion="#session.DSN#" Conlis="S" auxiliares="N" movimiento="S" form="CTipoRequisicion" ccuenta="Ccuenta" Cdescripcion="Cdescripcion" cformato="Cformato">
				</cfif>
			</td>
		</tr>
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

<script language="JavaScript1.2" type="text/javascript">	
	// alt para la cuenta contable
	document.CTipoRequisicion.Dcodigo.alt = "El Departamento";
	document.CTipoRequisicion.TRcodigo.alt = "La Requisición";
	document.CTipoRequisicion.Ccuenta.alt = "La Cuenta";
	document.CTipoRequisicion.Dcodigo.focus();
</script>