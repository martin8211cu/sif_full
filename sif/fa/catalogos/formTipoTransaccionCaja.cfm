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
<!-- Consultas -->
<!-- 1. Almacenes -->
<cfif modo NEQ	"ALTA">
	<cfquery name="rsForm" datasource="#Session.DSN#">
		select b.FCdesc,
				c.CCTdescripcion,
				d.Tdescripcion,
				convert(varchar,a.FCid) as FCid,
				convert(varchar,a.CCTcodigo) as CCTcodigo,
				convert(varchar,a.Tid) as Tid,
				a.FMT01COD,
				a.ts_rversion
		from TipoTransaccionCaja as a
		inner join FCajas as b
		on a.FCid = b.FCid
		and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">
		and a.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CCTcodigo#">
		inner join
		CCTransacciones as c
		on a.CCTcodigo = c.CCTcodigo
		and a.Ecodigo = c.Ecodigo
		inner join
		Talonarios as d
		on a.Tid = d.Tid
		and a.Ecodigo = d.Ecodigo
	</cfquery>
</cfif>
<!-- 2. Formatos -->
<cfquery name="rsFormatos" datasource="#Session.DSN#">
	select '' as FMT01COD, '-- Seleccionar Formato --' as FMT01DES
	union
	select FMT01COD, FMT01DES from FMT001
	<!--- where FMT01TIP = 3 --->
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	order by FMT01COD
</cfquery>
<script language="JavaScript1.2">
    var popUpWin=0;
	function popUpWindow(URLStr, left, top, width, height){
	    if(popUpWin){
	        if(!popUpWin.closed){
			    popUpWin.close();
		    }
	    }
	    popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
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

function doConlisCajas(){
	popUpWindow("conlisFCajas.cfm?form=form1&fcdesc=FCdesc&fcid=FCid&crc=1",250,200,650,350);
}

function doConlisTransacciones(caja){
	if (caja!=''){
		popUpWindow("conlisTransacciones.cfm?form=form1&cctdesc=CCTdescripcion&cctcod=CCTcodigo&caja="+caja,250,200,650,350);
	}
	else
	{
		alert ('Primero debe seleccionar la Caja.');
	}
}

function doConlisTalonarios(){
	popUpWindow("conlisTalonarios.cfm?form=form1&tdesc=Tdescripcion&tid=Tid",250,200,650,350);
}
//-->
</script>
<form name="form1" action="<cfoutput>#LvarSQLPagina#</cfoutput>" method="post" onSubmit="MM_validateForm('FCdesc','','R','CCTdescripcion','','R');return document.MM_returnValue">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td nowrap align="right">Caja:&nbsp;</td>
      <td nowrap> <input name="FCdesc" type="text" value="<cfif modo NEQ "ALTA"><cfoutput>#JSStringFormat(rsForm.FCdesc)#</cfoutput></cfif>" size="40" maxlength="15" disabled="true" readonly="true">
        <input name="FCid" type="hidden" value="<cfif modo NEQ "ALTA"><cfoutput>#rsForm.FCid#</cfoutput></cfif>">
        <cfif modo EQ "ALTA">
          <a href="#" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Cajas" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript: doConlisCajas();"></a>
        </cfif> </td>
    </tr>
    <tr>
      <td nowrap align="right">Transacci&oacute;n:&nbsp;</td>
      <td nowrap> <input name="CCTdescripcion" type="text" value="<cfif modo NEQ "ALTA"><cfoutput>#JSStringFormat(rsForm.CCTdescripcion)#</cfoutput></cfif>" size="40" maxlength="80" disabled="true" readonly="true">
        <input name="CCTcodigo" type="hidden" value="<cfif modo NEQ "ALTA"><cfoutput>#rsForm.CCTcodigo#</cfoutput></cfif>">
        <cfif modo EQ "ALTA">
          <a href="#" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Transacciones" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript: doConlisTransacciones(document.form1.FCid.value);"></a>
        </cfif> </td>
    </tr>
    <tr>
      <td nowrap align="right">Talonario:&nbsp;</td>
      <td nowrap> <input name="Tdescripcion" type="text" value="<cfif modo NEQ "ALTA"><cfoutput>#JSStringFormat(rsForm.Tdescripcion)#</cfoutput></cfif>" size="40" maxlength="60" disabled="true" readonly="true">
        <input name="Tid" type="hidden" value="<cfif modo NEQ "ALTA"><cfoutput>#rsForm.Tid#</cfoutput></cfif>">
        <a href="#" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Talonarios" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript: doConlisTalonarios();"></a>
      </td>
    </tr>
    <tr>
			<input type="hidden" value="0" name="FMT01COD"/>
      <!---<td nowrap align="right">Formato:&nbsp;</td>
      <td nowrap>
	  	<select name="FMT01COD">
		<cfoutput query="rsFormatos">
			<cfif modo neq "ALTA" and Trim(rsForm.FMT01COD) eq Trim(FMT01COD)>
				<option value="#FMT01COD#" selected>#FMT01DES#</option>
			<cfelse>
				<option value="#FMT01COD#">#FMT01DES#</option>
			</cfif>
		</cfoutput>
		</select> --->
      </td>
    </tr>
    <tr>
      <td nowrap colspan="2"> <cfif modo NEQ "ALTA">
          <cfset ts = "">
          <cfinvoke
				component="sif.Componentes.DButils"
				method="toTimeStamp"
				returnvariable="ts">
            <cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
          </cfinvoke>
        </cfif> <cfif modo NEQ "ALTA">
          <cfoutput>
            <input type="hidden" name="ts_rversion" value="#ts#">
          </cfoutput> </cfif> </td>
    </tr>
  </table>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr><td>&nbsp;</td></tr>
  <tr>
  	<td nowrap align="center">
<!--- 		Copiado del portlet de botones para poner Botón de Limpiado en modo Cambio--->
		<cf_templatecss>
		<cfoutput>
		<cfif modo EQ "ALTA">
			<input type="submit" name="Alta" value="#Translate('BotonAgregar','Agregar','/sif/Utiles/Generales.xml')#">
			<input type="reset" name="Limpiar" value="#Translate('BotonLimpiar','Limpiar','/sif/Utiles/Generales.xml')#">
		<cfelse>
			<input type="submit" name="Cambio" value="#Translate('BotonCambiar','Modificar','/sif/Utiles/Generales.xml')#">
			<input type="submit" name="Baja" value="#Translate('BotonBorrar','Eliminar','/sif/Utiles/Generales.xml')#" onclick="javascript:return confirm('¿Desea Eliminar el Registro?');">
			<input type="submit" name="Nuevo" value="#Translate('BotonNuevo','Nuevo','/sif/Utiles/Generales.xml')#" >
			<input type="button" name="Limpiar" value="#Translate('BotonLimpiar','Limpiar','/sif/Utiles/Generales.xml')#" onClick="javascript: document.form1.Tid.value = '';document.form1.Tdescripcion.value = '';">
		</cfif>
		</cfoutput>
		<input name="txtEnterSI" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb">
<!--- 		Copiado del portlet de botones para poner Botón de Limpiado en modo Cambio--->
	</td>
  </tr>
</table>
</form>

<!-- Texto para las validaciones -->
<script language="JavaScript1.1">
	document.form1.FCdesc.alt =	"El campo Caja"
	document.form1.CCTdescripcion.alt =	"El campo Transacción"
</script>