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

<!-- 1. UsuariosCaja -->
<cfif modo NEQ "Alta">
	<cfquery name="rsUsuariosCaja" datasource="#Session.DSN#">
		select convert(varchar, EUcodigo) EUcodigo, convert(varchar,Usucodigo) Usucodigo, Ulocalizacion, Usulogin
		from UsuariosCaja a, FCajas b
		where a.FCid = b.FCid
			and b.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer" >
			and a.FCid = <cfqueryparam value="#Form.FCid#" cfsqltype="cf_sql_numeric" >
			and a.EUcodigo = <cfqueryparam value="#Form.EUcodigo#" cfsqltype="cf_sql_numeric" >
	</cfquery>

	<cfquery name="rsUsuarios" datasource="asp">
		select b.Pnombre + rtrim(' ' + b.Papellido1 + rtrim(' ' + b.Papellido2)) as Nombre
		from Usuario a, DatosPersonales b
		where a.Usucodigo = <cfqueryparam value="#Form.EUcodigo#" cfsqltype="cf_sql_numeric">
		and a.datos_personales = b.datos_personales
	</cfquery>
	
</cfif>
<script language="JavaScript1.2">
var popUpWin=0; 
	function popUpWindow(URLStr, left, top, width, height)
	{
	  if(popUpWin)
	  {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
	
	function doConlisUsuarios(fcid) {
		popUpWindow("ConlisUsuarios.cfm?form=form1&catalogo=uc&EUcodigo=EUcodigo&Usucodigo=Usucodigo&Ulocalizacion=Ulocalizacion&Usulogin=Usulogin&Nombre=Nombre&fcid="+fcid,250,200,650,350);
	}
	
	/*
	function doConlisCajas() {
		popUpWindow("ConlisUCCajas.cfm?form=form1",250,200,650,350);
	}
	*/
</script>
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
  } if (errors) alert('Se presentaron los siguientes errores:\n\n'+errors);
  document.MM_returnValue = (errors == '');
}
//-->
</script>

<form action="SQLUsuariosCaja.cfm" method="post" name="form1" onSubmit="MM_validateForm('Nombre','','R');return document.MM_returnValue">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
  <!---
  <tr>
    <td nowrap align="right" width="30%">Caja:&nbsp;</td>
    <td nowrap>
		<input type="text" name="Caja" value="<cfif modo NEQ "ALTA"><cfoutput>#rsCajas.Caja#</cfoutput></cfif>" size="40" maxlength="80" readonly = "true" disabled = "true">
        <cfif modo EQ "ALTA">
        	<a href="#" tabindex="-1"><img src="../../imagenes/Description.gif" alt="Lista de Cajas" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlisCajas();"></a> 
        </cfif> 
		
	</td>
  </tr>
  --->
  <tr>
    <td nowrap align="right" width="30%">Usuario:&nbsp;</td>
    <td nowrap>
		<input type="text" name="Nombre" value="<cfif modo NEQ "ALTA"><cfoutput>#JSStringFormat(rsUsuarios.Nombre)#</cfoutput></cfif>" size="40" maxlength="80" readonly = "true" disabled = "true">
        <cfif modo EQ "ALTA">
        	<a href="#" tabindex="-1"><img src="../../imagenes/Description.gif" alt="Lista de Usuarios" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlisUsuarios(<cfoutput>#Form.FCid#</cfoutput>);"></a> 
        </cfif>
		<input type="hidden" name="EUcodigo" value="<cfif modo NEQ "ALTA"><cfoutput>#rsUsuariosCaja.EUcodigo#</cfoutput></cfif>"> 
		<input type="hidden" name="Usucodigo" value="<cfif modo NEQ "ALTA"><cfoutput>#rsUsuariosCaja.Usucodigo#</cfoutput></cfif>"> 
		<input type="hidden" name="Ulocalizacion" value="<cfif modo NEQ "ALTA"><cfoutput>#rsUsuariosCaja.Ulocalizacion#</cfoutput></cfif>">
		<input type="hidden" name="Usulogin" value="<cfif modo NEQ "ALTA"><cfoutput>#rsUsuariosCaja.Usulogin#</cfoutput></cfif>">
    </td>
  </tr>
  <tr>
  	<td nowrap colspan="2">
		<input type="hidden" name="FCid" value="<cfoutput>#Form.FCid#</cfoutput>"> 
	</td>
  </tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
  	<td nowrap align="center">
<!--- 		Copiado del portlet de botones para eliminar modificado --->
		<cf_templatecss>
		<cfoutput>
		<cfif modo EQ "ALTA">
			<input type="submit" name="Alta" value="#Translate('BotonAgregar','Agregar','/sif/Utiles/Generales.xml')#">
			<input type="reset" name="Limpiar" value="#Translate('BotonLimpiar','Limpiar','/sif/Utiles/Generales.xml')#">
		<cfelse>	
			<!--- <input type="submit" name="Cambio" value="#Translate('BotonCambiar','Modificar','/sif/Utiles/Generales.xml')#"> --->
			<input type="submit" name="Baja" value="#Translate('BotonBorrar','Eliminar','/sif/Utiles/Generales.xml')#" onclick="javascript:return confirm('¿Desea Eliminar el Registro?');">
			<input type="submit" name="Nuevo" value="#Translate('BotonNuevo','Nuevo','/sif/Utiles/Generales.xml')#" >
		</cfif>
		</cfoutput>
		<input name="txtEnterSI" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb">
<!--- 		Copiado del portlet de botones para eliminar modificado--->
	</td>
  </tr>
</table>
</form>

<!-- Texto para las validaciones -->
<script language="JavaScript1.1">
	<!--- document.form1.Caja.alt = "El campo Caja"  --->
	document.form1.Nombre.alt = "El campo Usuario" 
</script>