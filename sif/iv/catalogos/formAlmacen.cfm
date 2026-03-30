<cfif isdefined('url.filtro_Almcodigo') and not isdefined('form.filtro_Almcodigo')>
	<cfset form.filtro_Almcodigo = url.filtro_Almcodigo>
</cfif>
<cfif isdefined('url.filtro_Bdescripcion') and not isdefined('form.filtro_Bdescripcion')>
	<cfset form.filtro_Bdescripcion = url.filtro_Bdescripcion>
</cfif>			

<!-- Establecimiento del modo -->
<cfset modo = 'ALTA' >
<cfif isdefined("form.Aid") and len(trim(form.Aid))>
	<cfset modo = 'CAMBIO' >
</cfif>

<!-- Consultas -->
<!-- 1. Form -->
<cfif modo NEQ 'ALTA'>
	<cfquery datasource="#session.DSN#" name="rsForm">
		select Aid, Bdescripcion, rtrim(Almcodigo) as Almcodigo,
			   Bdireccion, Btelefono, Ocodigo, Dcodigo, ts_rversion
		from Almacen
		where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer" >
		and Aid = <cfqueryparam value="#form.Aid#" cfsqltype="cf_sql_numeric">
	</cfquery>
</cfif>

<cfquery datasource="#session.DSN#" name="rsCountReg">
	Select count(Aid) as cant
	from Almacen
	where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer" >
</cfquery>

<!-- 2. Combo Oficinas -->
<cfquery datasource="#session.DSN#" name="rsOficinas">
	select Ocodigo, Odescripcion 
	from Oficinas 
	where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" >
	order by Odescripcion
</cfquery>

<!-- 3. Combo Departamentos -->
<cfquery datasource="#session.DSN#" name="rsDepartamentos">
	select Dcodigo, Ddescripcion 
	from Departamentos
	where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" >
	order by Ddescripcion
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


<!--- Javascripts Generales --->
<!--- Qforms --->
<!--- Carga el API de Qforms --->
<script language="javascript" type="text/javascript" src="../../js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	qFormAPI.errorColor = '##FFFFCC';
	//-->
</script>

<form action="SQLAlmacen.cfm" method="post"  enctype="multipart/form-data" name="almacen" onSubmit="if ( this.botonSel.value != 'Nuevo' && this.botonSel.value != 'Baja'){ MM_validateForm('Bdescripcion','','R', 'Ocodigo','','R', 'Dcodigo','','R','Almcodigo','','R');return document.MM_returnValue}else{ return true; }">
	<cfoutput>
		<input name="Pagina" type="hidden" tabindex="-1" value="#form.Pagina#">	
		<input name="MaxRows" type="hidden" tabindex="-1" value="#form.MaxRows#">	
		<input name="filtro_Almcodigo" type="hidden" value="<cfif isdefined('form.filtro_Almcodigo')>#form.filtro_Almcodigo#</cfif>">
		<input name="filtro_Bdescripcion" type="hidden" value="<cfif isdefined('form.filtro_Bdescripcion')>#form.filtro_Bdescripcion#</cfif>">
	</cfoutput>
	<table width="100%" border="0" cellpadding="2" cellspacing="0">
		<tr><td>&nbsp;</td></tr>
		<tr>
          <td valign="baseline" align="right">C&oacute;digo:&nbsp;</td>
          <td>
            <input tabindex="1" type="text" name="Almcodigo" size="20"  maxlength="20" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.Almcodigo#</cfoutput></cfif>" alt="C&oacute;digo del Almac&eacute;n" onfocus="javascript:this.select();" >
            <input type="hidden" name="Almcodigo2" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.Almcodigo#</cfoutput></cfif>">
		  </td>
	  </tr>
		<tr>
			<td valign="baseline" align="right">Descripci&oacute;n:&nbsp;</td>
			<td>
				<input tabindex="1" type="text" name="Bdescripcion" size="60"  maxlength="60" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.Bdescripcion#</cfoutput></cfif>" alt="La Descripci&oacute;n del Almac&eacute;n" onfocus="javascript:this.select();" >
	      </td>
		</tr>

		<tr>
			<td valign="baseline" align="right">Direcci&oacute;n:&nbsp;</td>
			<td>
				<input tabindex="1" type="text" name="Bdireccion" size="60"  maxlength="255" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.Bdireccion#</cfoutput></cfif>" onfocus="javascript:this.select();" >
			</td>
		</tr>
		
		<tr>
			<td valign="baseline" align="right">Tel&eacute;fono:&nbsp;</td>
			<td>
				<input tabindex="1" type="text" name="Btelefono" size="15"  maxlength="80" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.Btelefono#</cfoutput></cfif>" onfocus="javascript:this.select();" >
			</td>
		</tr>
		

		<tr>
			<td valign="baseline" align="right">Oficina:&nbsp;</td>
			<td>
	            <input type="hidden" name="Ocodigo2" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.Ocodigo#</cfoutput></cfif>">
				<select name="Ocodigo" tabindex="1">
					<cfoutput query="rsOficinas">					
						<cfif modo EQ 'ALTA'>
							<option value="#rsOficinas.Ocodigo#">#rsOficinas.Odescripcion#</option>
						<cfelseif modo NEQ 'ALTA'>
							<option value="#rsOficinas.Ocodigo#" <cfif #rsForm.Ocodigo# EQ #rsOficinas.Ocodigo#>selected</cfif>  >#rsOficinas.Odescripcion#</option>
						</cfif>
					</cfoutput>						
				</select>
			</td>
		</tr>
		
		<tr>
			
      <td valign="baseline" align="right">Departamento:&nbsp;</td>
			<td>
				<select name="Dcodigo" tabindex="1">
					<cfoutput query="rsDepartamentos">					
						<cfif modo EQ 'ALTA'>
							<option value="#rsDepartamentos.Dcodigo#">#rsDepartamentos.Ddescripcion#</option>
						<cfelseif modo NEQ 'ALTA'>
							<option value="#rsDepartamentos.Dcodigo#" <cfif rsForm.Dcodigo EQ rsDepartamentos.Dcodigo>selected</cfif>  >#rsDepartamentos.Ddescripcion#</option>
						</cfif>
					</cfoutput>						
				</select>
			</td>
		</tr>

		<tr><td colspan="2">&nbsp;</td></tr>
		<!--- *************************************************** --->
		<cfif modo NEQ 'ALTA'>
			<tr>
			  <td colspan="2" align="center" class="tituloListas">Complementos Contables</td>
			</tr>
			<tr><td colspan="2" align="center">
			<cf_sifcomplementofinanciero action='display'
					tabla="Almacen"
					form = "almacen"
					llave="#form.Aid#" 
					tabindex="1"/>		
			</td></tr>
		</cfif>	
		<!--- *************************************************** --->
		<tr>
			<td align="center" valign="baseline" colspan="2">
				<cfif isdefined('rsCountReg') and rsCountReg.cant GT 1>
					<cf_botones modo='#MODO#' tabindex="1">							
				<cfelse>
					<cf_botones modo='#MODO#' exclude="Baja" tabindex="1">					
				</cfif>
			</td>
		</tr>
		
		<tr>
			<td colspan="2">
				<input type="hidden" name="Aid" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.Aid#</cfoutput></cfif>" >
			</td>
		</tr>
	  
		<cfset ts = "">	
		<cfif modo neq "ALTA">
			<cfinvoke 
				component="sif/Componentes/DButils" 
				method="toTimeStamp" 
				arTimeStamp="#rsForm.ts_rversion#" 
				returnvariable="ts">
			</cfinvoke>
		</cfif>
		<input type="hidden" name="ts_rversion" value="<cfif modo NEQ 'ALTA'><cfoutput>#ts#</cfoutput></cfif>">
	</table>
</form>

<script language="JavaScript1.2" type="text/javascript">
	document.almacen.Ocodigo.alt = "La Oficina"
	document.almacen.Dcodigo.alt = "El Departamento"	
	document.almacen.Almcodigo.focus();
</script>