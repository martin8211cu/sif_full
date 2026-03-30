<!-- Establecimiento del modo -->
<cfset modo="ALTA">
<cfif isdefined('form.IACcodigo') and len(trim(form.IACcodigo)) >
	<cfset modo="CAMBIO">
</cfif>

<!-- Consultas -->
<cfif modo neq 'ALTA'>
	<!-- 1. Form -->
	<cfquery datasource="#session.DSN#" name="rsForm">
		select 
			IACcodigo, 
			rtrim(IACcodigogrupo) as IACcodigogrupo,
			IACdescripcion,
			IACinventario,
			IACingajuste,
			IACgastoajuste,
			IACcompra,
			IACingventa,
			IACcostoventa,
			IACdescventa,
			CformatoCompras,
			CformatoIngresos,
			ts_rversion
		from IAContables
		where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer" >
		and IACcodigo  = <cfqueryparam value="#Form.IACcodigo#" cfsqltype="cf_sql_integer">
	</cfquery>


	<cfquery datasource="#session.DSN#" name="rsForm1">
		select IACingajuste as Ccuenta, Cdescripcion, Cformato
		from IAContables a, CContables b
		where a.Ecodigo=b.Ecodigo
		  and a.IACingajuste=b.Ccuenta
		  and a.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer" >
		  and a.IACcodigo  = <cfqueryparam value="#Form.IACcodigo#" cfsqltype="cf_sql_numeric">
	</cfquery>
	
	<cfquery datasource="#session.DSN#" name="rsForm2">
		select IACgastoajuste as Ccuenta, Cdescripcion, Cformato
		from IAContables a, CContables b
		where a.Ecodigo=b.Ecodigo
		  and a.IACgastoajuste=b.Ccuenta
		  and a.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer" >
		  and a.IACcodigo  = <cfqueryparam value="#Form.IACcodigo#" cfsqltype="cf_sql_numeric">

	</cfquery>
	
	<cfquery datasource="#session.DSN#" name="rsForm3">
		select IACcompra as Ccuenta, Cdescripcion, Cformato
		from IAContables a, CContables b
		where a.Ecodigo=b.Ecodigo
		  and a.IACcompra=b.Ccuenta
		  and a.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer" >
		  and a.IACcodigo  = <cfqueryparam value="#Form.IACcodigo#" cfsqltype="cf_sql_numeric">
	</cfquery>
	
	<cfquery datasource="#session.DSN#" name="rsForm4">
		select IACingventa as Ccuenta, Cdescripcion, Cformato
		from IAContables a, CContables b
		where a.Ecodigo=b.Ecodigo
		  and a.IACingventa=b.Ccuenta
		  and a.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer" >
		  and a.IACcodigo  = <cfqueryparam value="#Form.IACcodigo#" cfsqltype="cf_sql_numeric">
	</cfquery>
	
	<cfquery datasource="#session.DSN#" name="rsForm5">
		select IACcostoventa as Ccuenta, Cdescripcion, Cformato
		from IAContables a, CContables b
		where a.Ecodigo=b.Ecodigo
		  and a.IACcostoventa=b.Ccuenta
		  and a.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer" >
		  and a.IACcodigo  = <cfqueryparam value="#Form.IACcodigo#" cfsqltype="cf_sql_numeric">
	</cfquery>
	
	<cfquery datasource="#session.DSN#" name="rsForm6">
		select IACdescventa as Ccuenta, Cdescripcion, Cformato
		from IAContables a, CContables b
		where a.Ecodigo=b.Ecodigo
		  and a.IACdescventa=b.Ccuenta
		  and a.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer" >
		  and a.IACcodigo  = <cfqueryparam value="#Form.IACcodigo#" cfsqltype="cf_sql_numeric">
	</cfquery>
	
	<cfquery datasource="#session.DSN#" name="rsForm7">
		select IACtransito as Ccuenta, Cdescripcion, Cformato
		from IAContables a, CContables b
		where a.Ecodigo=b.Ecodigo
		  and a.IACtransito=b.Ccuenta
		  and a.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer" >
		  and a.IACcodigo  = <cfqueryparam value="#Form.IACcodigo#" cfsqltype="cf_sql_numeric">
	</cfquery>

	<cfquery name="rsForm8" dbtype="query">
		select '' as Ccuenta, '' as Cdescripcion, CformatoCompras as Cformato from rsForm
	</cfquery>
	
	<cfquery name="rsForm9" dbtype="query">
		select '' as Ccuenta, '' as Cdescripcion, CformatoIngresos as Cformato from rsForm
	</cfquery>

</cfif>

<!--- 2. Combo Cuentas --->
<cfquery datasource="#session.DSN#" name="rsCuenta">
	select Ccuenta as Ccuenta, Cdescripcion
	from CContables 
	where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" >
	  and Cmovimiento='S' 
	  and Mcodigo=9
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

<script language="JavaScript1.2" src="../../js/utilesMonto.js"></script>
<form action="SQLCuentasInventario.cfm" method="post" name="cuentas" onSubmit="if ( this.botonSel.value != 'Nuevo' && this.botonSel.value != 'Baja'){MM_validateForm('IACdescripcion','','R','IACinventario','','R','IACingajuste','','R','IACgastoajuste','','R','IACcompra','','R','IACingventa','','R','IACcostoventa','','R','IACdescventa','','R','IACtransito','','R');return document.MM_returnValue}else{return true;}" >
	<cfoutput>
		<input name="Pagina" type="hidden" tabindex="-1" value="#form.Pagina#">	
		<input name="MaxRows" type="hidden" tabindex="-1" value="#form.MaxRows#">		
		<input type="hidden" name="filtro_IACcodigogrupo" value="<cfif isdefined('form.filtro_IACcodigogrupo') and form.filtro_IACcodigogrupo NEQ ''>#form.filtro_IACcodigogrupo#</cfif>">
		<input type="hidden" name="filtro_IACdescripcion" value="<cfif isdefined('form.filtro_IACdescripcion') and form.filtro_IACdescripcion NEQ ''>#form.filtro_IACdescripcion#</cfif>">	
	</cfoutput>
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr>
          <td align="right">C&oacute;digo:&nbsp;</td>
          <td>
            <input tabindex="1" type="text" name="IACcodigogrupo" size="20" maxlength="20" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.IACcodigogrupo#</cfoutput></cfif>" alt="El C&oacute;digo" onfocus="javascript:this.select();" >
            <input type="hidden" name="IACcodigo" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.IACcodigo#</cfoutput></cfif>" >
          </td>
	  </tr>
		<tr>
			<td align="right">Descripci&oacute;n:&nbsp;</td>
			<td>
				<input tabindex="1" type="text" name="IACdescripcion" size="60" maxlength="80" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.IACdescripcion#</cfoutput></cfif>" alt="La Descripci&oacute;n" onfocus="javascript:this.select();" >
			</td>
		</tr>

		<tr>
			<td align="right" nowrap>Cuenta de Inventarios:&nbsp;</td>
			<td>
				<select name="IACinventario" alt='La Cuenta de Inventarios' tabindex="1">
					<cfoutput query="rsCuenta">					
						<cfif modo EQ 'ALTA'>
							<option value="#rsCuenta.Ccuenta#">#rsCuenta.Cdescripcion#</option>
						<cfelseif modo NEQ 'ALTA'>
							<option value="#rsCuenta.Ccuenta#" <cfif #rsForm.IACinventario# EQ #rsCuenta.Ccuenta#>selected</cfif>  >#rsCuenta.Cdescripcion#</option>
						</cfif>
					</cfoutput>						
				</select>
			</td>
		</tr>
		
		<tr>
			<td align="right" nowrap>Cuenta de Ingreso Ajuste:&nbsp;</td>
			<td>
				<cfif modo NEQ 'ALTA' >
					<cf_cuentas tabindex="1" Conexion="#session.DSN#" Conlis="S" frame="frame0" auxiliares="N" movimiento="S" form="cuentas" ccuenta="IACingajuste" Cdescripcion="DIACingajuste" cformato="FIACingajuste" query="#rsForm1#">
				<cfelse>
					<cf_cuentas tabindex="1" Conexion="#session.DSN#" Conlis="S" frame="frame0" auxiliares="N" movimiento="S" form="cuentas" ccuenta="IACingajuste" Cdescripcion="DIACingajuste" cformato="FIACingajuste">
				</cfif>
			</td>
		</tr>

		<tr>
			<td align="right" nowrap>Cuenta de Gasto Ajuste:&nbsp;</td>
			<td>
				<cfif modo NEQ 'ALTA' >
					<cf_cuentas tabindex="1" Conexion="#session.DSN#" Conlis="S" frame="frame1" auxiliares="N" movimiento="S" form="cuentas" ccuenta="IACgastoajuste" Cdescripcion="DIACgastoajuste" cformato="FIACgastoajuste" query="#rsForm2#">
					<cfelse>				  
					<cf_cuentas tabindex="1" Conexion="#session.DSN#" Conlis="S" frame="frame1" auxiliares="N" movimiento="S" form="cuentas" ccuenta="IACgastoajuste" Cdescripcion="DIACgastoajuste" cformato="FIACgastoajuste">
				</cfif>
			</td>
		</tr>
		
		<tr>
			<td align="right" nowrap>Cuenta de Compras:&nbsp;</td>
			<td>
				<cfif modo NEQ 'ALTA' >
					<cf_cuentas tabindex="1" Conexion="#session.DSN#" Conlis="S" frame="frame2" auxiliares="N" movimiento="S" form="cuentas" ccuenta="IACcompra" Cdescripcion="DIACcompra" cformato="FIACcompra" query="#rsForm3#">
				<cfelse>
					<cf_cuentas tabindex="1" Conexion="#session.DSN#" Conlis="S" frame="frame2" auxiliares="N" movimiento="S" form="cuentas" ccuenta="IACcompra" Cdescripcion="DIACcompra" cformato="FIACcompra">
				</cfif>
			</td>
		</tr>

		<tr>
			<td align="right" nowrap>Cuenta de Ingresos Ventas:&nbsp;</td>
			<td>
				<cfif modo NEQ 'ALTA' >
					<cf_cuentas tabindex="1" Conexion="#session.DSN#" Conlis="S" frame="frame3" auxiliares="N" movimiento="S" form="cuentas" ccuenta="IACingventa" Cdescripcion="DIACingventa" cformato="FIACingventa" query="#rsForm4#">
				<cfelse>
					<cf_cuentas tabindex="1" Conexion="#session.DSN#" Conlis="S" frame="frame3" auxiliares="N" movimiento="S" form="cuentas" ccuenta="IACingventa" Cdescripcion="DIACingventa" cformato="FIACingventa">
				</cfif>
			</td>
		</tr>

		<tr>
			<td align="right" nowrap>Cuenta de Costo Ventas:&nbsp;</td>		
			<td>
				<cfif modo NEQ 'ALTA' >
					<cf_cuentas tabindex="1" Conexion="#session.DSN#" Conlis="S" frame="frame4" auxiliares="N" movimiento="S" form="cuentas" ccuenta="IACcostoventa" Cdescripcion="DIACcostoventa" cformato="FIACcostoventa" query="#rsForm5#">
				<cfelse>
					<cf_cuentas tabindex="1" Conexion="#session.DSN#" Conlis="S" frame="frame4" auxiliares="N" movimiento="S" form="cuentas" ccuenta="IACcostoventa" Cdescripcion="DIACcostoventa" cformato="FIACcostoventa">
				</cfif>
			</td>
		</tr>

		<tr>
			<td align="right" nowrap>Cuenta de Descuento Ventas:&nbsp;</td>
			<td>
				<cfif modo NEQ 'ALTA' >
					<cf_cuentas tabindex="1" Conexion="#session.DSN#" Conlis="S" frame="frame5" auxiliares="N" movimiento="S" form="cuentas" ccuenta="IACdescventa" Cdescripcion="DIACdescventa" cformato="FIACdescventa" query="#rsForm6#">
				<cfelse>
					<cf_cuentas tabindex="1" Conexion="#session.DSN#" Conlis="S" frame="frame5" auxiliares="N" movimiento="S" form="cuentas" ccuenta="IACdescventa" Cdescripcion="DIACdescventa" cformato="FIACdescventa">
				</cfif>
			</td>
		</tr>

		<tr>
			<td align="right" nowrap>Cuenta de Tr&aacute;nsito:&nbsp;</td>
			<td>
				<cfif modo NEQ 'ALTA' >
					<cf_cuentas tabindex="1" Conexion="#session.DSN#" Conlis="S" frame="frame6" auxiliares="N" movimiento="S" form="cuentas" ccuenta="IACtransito" Cdescripcion="DIACtransito" cformato="FIACtransito" query="#rsForm7#">
				<cfelse>
					<cf_cuentas tabindex="1" Conexion="#session.DSN#" Conlis="S" frame="frame6" auxiliares="N" movimiento="S" form="cuentas" ccuenta="IACtransito" Cdescripcion="DIACtransito" cformato="FIACtransito">
				</cfif>
			</td>
		</tr>

		<tr>
			<td align="right" nowrap>Cuenta de Compras:&nbsp;</td>
			<td>
				<cfif modo EQ "ALTA">
					<cf_cuentasanexo 
						auxiliares="S" 
						movimiento="N"
						conlis="S"
						cmayor="Cmayor8"
						ccuenta="Ccuenta8" 
						cdescripcion="Cdescripcion8" 
						cformato="Cformato8" 
						conexion="#Session.DSN#"
						form="cuentas"
						frame="frCuentac8"
						tabindex="1"
						comodin="?">
				<cfelse>
					<cf_cuentasanexo 
						auxiliares="S" 
						movimientos="N"
						conlis="S"
						cmayor="Cmayor8"
						ccuenta="Ccuenta8" 
						cdescripcion="Cdescripcion8" 
						cformato="Cformato8" 
						conexion="#Session.DSN#"
						form="cuentas"
						frame="frCuentac8"
						query="#rsForm8#"
						tabindex="1"
						comodin="?">
				</cfif>
			</td>
		</tr>

		<tr>
			<td align="right" nowrap>Cuenta de Ingresos:&nbsp;</td>
			<td>
				<cfif modo EQ "ALTA">
					<cf_cuentasanexo 
						auxiliares="S" 
						movimiento="N"
						conlis="S"
						cmayor="Cmayor9"
						ccuenta="Ccuenta9" 
						cdescripcion="Cdescripcion9" 
						cformato="Cformato9" 
						conexion="#Session.DSN#"
						form="cuentas"
						frame="frCuentac9"
						tabindex="1"
						comodin="?">
				<cfelse>
					<cf_cuentasanexo 
						auxiliares="S" 
						movimientos="N"
						conlis="S"
						cmayor="Cmayor9"
						ccuenta="Ccuenta9" 
						cdescripcion="Cdescripcion9" 
						cformato="Cformato9" 
						conexion="#Session.DSN#"
						form="cuentas"
						frame="frCuentac9"
						query="#rsForm9#"
						tabindex="1"
						comodin="?">
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
	document.cuentas.IACcompra.alt = "La cuenta de Compras";
	document.cuentas.IACgastoajuste.alt = "La cuenta de Gasto Ajuste";
	document.cuentas.IACingajuste.alt = "La cuenta de Ingreso Ajuste";
	document.cuentas.IACingventa.alt = "La cuenta de Ingreso Ventas";
	document.cuentas.IACcostoventa.alt = "La cuenta de Costo Ventas";
	document.cuentas.IACdescventa.alt = "La cuenta de Descuento Ventas";
	document.cuentas.IACtransito.alt = "La cuenta de Tránsito";
	document.cuentas.IACcodigogrupo.focus();
</script>