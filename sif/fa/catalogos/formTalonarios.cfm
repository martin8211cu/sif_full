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

<!--- Consultas --->
<cfif modo NEQ "ALTA">
	<cfquery name="rsTalonarios" datasource="#Session.DSN#">
		Select convert(varchar,Tid) as Tid, RIini, RIfin, RIserie, Tdescripcion, ts_rversion
		from Talonarios
		where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		and Tid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Tid#">
	</cfquery>
	<cfquery name="rsRegistrosRef" datasource="#Session.DSN#">
		select count(*) cant from TipoTransaccionCaja
		where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		and Tid = <cfqueryparam value="#Form.Tid#" cfsqltype="cf_sql_numeric">
	</cfquery>
</cfif>

<script language="JavaScript1.2" src="../../js/utilesMonto.js"></script>
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
  }
  if (errors) alert('Se presentaron los siguientes errores:\n\n'+errors);
  document.MM_returnValue = (errors == '');
}

function MM_validateReference(cant) {
  //cant = Cantidad de Registros Asociados
  var errors='',args=MM_validateForm.arguments;
  if (cant>0) {
  	errors += 'El registro no se puede borrar porque tiene registros asociados en otras tablas.';
  }
  if (errors) alert('Se presentaron los siguientes errores:\n\n'+errors);
  return cant==0;
}
//-->
</script>

<form action="<cfoutput>#LvarSQLPagina#</cfoutput>" method="post" name="form1" onSubmit="MM_validateForm('Tdescripcion','','R','RIserie','','R','RIini','','RisNum','RIfin','','RisNum');return document.MM_returnValue">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td align="right" nowrap>Descripción:&nbsp;</td>
    <td nowrap><input name="Tdescripcion" type="text" value="<cfif modo NEQ "ALTA"><cfoutput>#JSStringFormat(rsTalonarios.Tdescripcion)#</cfoutput></cfif>" size="60" maxlength="60"></td>
  </tr>
  <tr>
    <td align="right" nowrap>Serie:&nbsp;</td>
    <td nowrap><input name="RIserie" type="text" maxlength="3" value="<cfif modo NEQ "ALTA"><cfoutput>#rsTalonarios.RIserie#</cfoutput></cfif>" size="15" maxlength="10" <cfif modo NEQ "ALTA"> readonly="true"</cfif>></td>
  </tr>
  <tr>
    <td align="right" nowrap>Documento inicial:&nbsp;</td>
	<td nowrap><input name="RIini" type="text" onkeypress="return soloNumeros(event);" onFocus="javascript:document.form1.RIini.select();" onchange="javascript: fm(this,0);"  value="<cfif modo NEQ "ALTA"><cfoutput>#rsTalonarios.RIini#</cfoutput></cfif>" size="15" maxlength="9" <cfif modo NEQ "ALTA">disabled="true" readonly="true"</cfif>></td>
  </tr>
  <tr>
    <td align="right" nowrap>Documento final:&nbsp;</td>
    <td nowrap><input name="RIfin" type="text" onkeypress="return soloNumeros(event);" onFocus="javascript:document.form1.RIfin.select();" onchange="javascript: fm(this,0);"  value="<cfif modo NEQ "ALTA"><cfoutput>#rsTalonarios.RIfin#</cfoutput></cfif>" size="15" maxlength="9" <cfif modo NEQ "ALTA">disabled="true" readonly="true"</cfif>></td>
  </tr>
  <tr>
  	<td nowrap colspan="2">
		<cfif modo NEQ "ALTA">
			<cfset ts = "">
			<cfinvoke
				component="sif.Componentes.DButils"
				method="toTimeStamp"
				returnvariable="ts">
				<cfinvokeargument name="arTimeStamp" value="#rsTalonarios.ts_rversion#"/>
			</cfinvoke>
		</cfif>
		<cfif modo NEQ "ALTA">
			<cfoutput>
				<input type="hidden" name="Tid" value="#rsTalonarios.Tid#">
				<input type="hidden" name="ts_rversion" value="#ts#">
				<input type="hidden" name="registrosRef" value="#rsRegistrosRef.cant#">
			</cfoutput>
		</cfif>
	</td>
  </tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
  	<td nowrap align="center">
<!--- 		Copiado del portlet de botones para poner funcion en el borrado --->
		<cf_templatecss>
		<cfoutput>
		<cfif modo EQ "ALTA">
			<input type="submit" name="Alta" value="#Translate('BotonAgregar','Agregar','/sif/Utiles/Generales.xml')#">
			<input type="reset" name="Limpiar" value="#Translate('BotonLimpiar','Limpiar','/sif/Utiles/Generales.xml')#">
		<cfelse>
			<input type="submit" name="Cambio" value="#Translate('BotonCambiar','Modificar','/sif/Utiles/Generales.xml')#">
			<input type="submit" name="Baja" value="#Translate('BotonBorrar','Eliminar','/sif/Utiles/Generales.xml')#" onclick="javascript:return MM_validateReference(document.form1.registrosRef.value) && confirm('¿Desea Eliminar el Registro?');">
			<input type="submit" name="Nuevo" value="#Translate('BotonNuevo','Nuevo','/sif/Utiles/Generales.xml')#" >
		</cfif>
		</cfoutput>
		<input name="txtEnterSI" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb">
<!--- 		Copiado del portlet de botones para poner funcion en el borrado --->
	</td>
  </tr>
</table>
</form>

<!-- Texto para las validaciones -->
<script language="JavaScript1.1">
	document.form1.Tdescripcion.alt = "El campo descripción"
	document.form1.RIserie.alt = "El campo serie"
	document.form1.RIini.alt = "El campo documento inicial"
	document.form1.RIfin.alt = "El campo documento final"
</script>

<script type="text/javascript">
	function soloNumeros(e)
	{
		var keynum = window.event ? window.event.keyCode : e.which;
		if ((keynum == 8) || (keynum == 0))
		return true;
		return /\d/.test(String.fromCharCode(keynum));
	}
</script>