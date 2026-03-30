<!--- Modo --->
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
<!-- 1. Paquetes -->
<cfif modo NEQ "Alta">
	<cfquery name="rsPaquetes" datasource="#Session.DSN#">
		select 	tipo = case isnull(p.Aid,0)
					when 0 then 1
					else 0
				end,
				convert(varchar,isnull(p.Aid,0)) as Aid, convert(varchar,isnull(p.Cid,0)) as Cid, convert(varchar,isnull(p.Alm_Aid,0)) as Alm_Aid, p.Pfactor, p.ts_rversion,
				a.Adescripcion, c.Cdescripcion, b.Bdescripcion
		from Paquetes p, Articulos a, Conceptos c, Almacen b
		where p.Aid *= a.Aid
		and p.Cid *= c.Cid
		and p.Alm_Aid *= b.Aid
		and LPlinea=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.LPlinea#">
		and p.Pid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Pid#">
	</cfquery>
</cfif>
<!-- 2. Almacenes -->
<cfquery name="rsAlmacenes" datasource="#Session.DSN#">
	select convert(varchar,0) as Aid, '' as Bdescripcion
	union
	select convert(varchar, Aid) as Aid, Bdescripcion
	from Almacen 
	where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
	order by Bdescripcion
</cfquery>
<!-- 3. Tipos -->
<cfquery name="rsTipos" datasource="#Session.DSN#">
	select 0 as id, 'Artículo' as descripcion
	union
	select 1 as id, 'Concepto' as descripcion
</cfquery>

<!--- JavaScript --->
<script language="JavaScript1.2" src="../../js/utilesMonto.js"></script>
<script language="JavaScript" type="text/JavaScript">
<!--

	var popUpWin=0; 
	function popUpWindow(URLStr, left, top, width, height)
	{
	  if(popUpWin)
	  {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
	
	function doConlisConcepto() {
		popUpWindow("ConlisConceptos.cfm?form=form1&id=Cid&desc=Cdescripcion&origen=P",250,200,650,350);
	}

	function doConlisArticulo() {
		popUpWindow("ConlisArticulos.cfm?form=form1&id=Aid&desc=Adescripcion&origen=P",250,200,650,350);
	}

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
	
	function ValidateForm() {
		document.form1.Pfactor.value=qf(document.form1.Pfactor);
		var div_a = document.getElementById("divA");
		if (div_a.style.display == '')
			MM_validateForm('Adescripcion','','R','Alm_Aid','','R');
		else
			MM_validateForm('Cdescripcion','','R');
	}
	function ocultarCampos(val) {
		var div_a = document.getElementById("divA");
		var div_b = document.getElementById("divB");
		if (val==0) {
			div_a.style.display = '' ;
			div_b.style.display = 'none' ;
		}
		else {
			div_a.style.display = 'none' ;
			div_b.style.display = '' ;
		}
	}
//-->
</script>

<!--- Form --->
<form action="SQLPaquetes.cfm" method="post" name="form1" onSubmit="ValidateForm(); return document.MM_returnValue;">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td align="right" nowrap>Tipo:&nbsp;</td>
    <td nowrap><select name="Tipo" onChange="javascript: ocultarCampos(this.value);" >
		<cfoutput query="rsTipos">
			<cfif modo EQ 'ALTA'>
				<option value="#rsTipos.id#">#rsTipos.descripcion#</option>
			<cfelse>
				<option value="#rsTipos.id#" <cfif #rsPaquetes.tipo# EQ #rsTipos.id#>selected</cfif>>#rsTipos.descripcion#</option>
			</cfif>
		</cfoutput>
	</select></td>
  </tr>
  <tr>
    <td nowrap colspan="2">
	<div id="divA" style="display: none ;">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
	<td nowrap align="right" width="30%">Art&iacute;culo:&nbsp;</td>
    <td nowrap>
		<input type="text" name="Adescripcion" value="<cfif modo NEQ "ALTA"><cfoutput>#rsPaquetes.Adescripcion#</cfoutput></cfif>" size="40" maxlength="80" readonly = "true" disabled = "true">
       	<a href="#" tabindex="-1"><img src="../../imagenes/Description.gif" alt="Lista de Artículos" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlisArticulo();"></a> 
        <input type="hidden" name="Aid" value="<cfif modo NEQ "ALTA"><cfoutput>#rsPaquetes.Aid#</cfoutput></cfif>">
    </td>
	</tr>
	<tr>
    <td align="right" nowrap>Almac&eacute;n:&nbsp;</td>
    <td nowrap><select name="Alm_Aid">
		<cfoutput query="rsAlmacenes">					
			<cfif modo EQ 'ALTA'>
				<option value="#rsAlmacenes.Aid#">#rsAlmacenes.Bdescripcion#</option>
			<cfelse>	
				<option value="#rsAlmacenes.Aid#" <cfif #rsPaquetes.Alm_Aid# EQ #rsAlmacenes.Aid#>selected</cfif>>#rsAlmacenes.Bdescripcion#</option>
			</cfif>
		</cfoutput>
	</select></td>
  	</tr>
	</table>
	</div>
	</td>
  </tr>
  <tr>
  <td nowrap colspan="2">
	<div id="divB" style="display: none ;">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td nowrap align="right" width="30%">Concepto:&nbsp;</td>
		<td nowrap>
			<input type="text" name="Cdescripcion" value="<cfif modo NEQ "ALTA"><cfoutput>#rsPaquetes.Cdescripcion#</cfoutput></cfif>" size="40" maxlength="80" readonly = "true" disabled = "true">
			<a href="#" tabindex="-1"><img src="../../imagenes/Description.gif" alt="Lista de Conceptos" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlisConcepto();"></a> 
			<input type="hidden" name="Cid" value="<cfif modo NEQ "ALTA"><cfoutput>#rsPaquetes.Cid#</cfoutput></cfif>">
		</td>
	  </tr>
	 </table>
  	</div>
  </td>
  </tr>
  <tr>
    <td nowrap align="right" width="30%">Factor:&nbsp;</td>
    <td nowrap>
        <input 	type="text" 
				name="Pfactor" 
				tabindex="2" 
				style="text-align:right" 
				onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
				onFocus="javascript:document.form1.Pfactor.select();" 
				onchange="javascript: fm(this,2);" 
				value="<cfif modo NEQ "ALTA"><cfoutput>#LSCurrencyFormat(rsPaquetes.Pfactor,'none')#</cfoutput><cfelse><cfoutput>0.00</cfoutput></cfif>"
				size="10" 
				maxlength="10">
    </td>
  </tr>
  <tr>
  	<td nowrap colspan="2">
		<cfoutput>
		  <cfif modo NEQ "ALTA">
			<cfset ts = "">	
			<cfinvoke 
				component="sif.Componentes.DButils"
				method="toTimeStamp"
				returnvariable="ts">
				<cfinvokeargument name="arTimeStamp" value="#rsPaquetes.ts_rversion#"/>
			</cfinvoke>
			<input type="hidden" name="ts_rversion" value="#ts#">
			<input type="hidden" name="Pid" value="#Form.Pid#">
		  </cfif>
		  <input type="hidden" name="modo" value="CAMBIO">
		  <input type="hidden" name="dmodo" value="CAMBIO">
		  <input type="hidden" name="LPid" value="#Form.LPid#">
		  <input type="hidden" name="LPlinea" value="#Form.LPlinea#">
		</cfoutput>
	</td>
  </tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
  	<td nowrap align="center">
			<cf_templatecss>
			<input name="txtEnterSI" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb">
			<cfoutput>
			<cfif modo EQ "ALTA">
				<input type="submit" name="Alta" value="#Request.Translate('BotonAgregar','Agregar','/sif/Utiles/Generales.xml')#">
				<input type="reset" name="Limpiar" value="#Request.Translate('BotonLimpiar','Limpiar','/sif/Utiles/Generales.xml')#" onClick="javascript: CambiarTipo();">
			<cfelse>	
				<input type="submit" name="Cambio" value="#Request.Translate('BotonCambiar','Modificar','/sif/Utiles/Generales.xml')#">
				<input type="submit" name="Baja" value="#Request.Translate('BotonBorrar','Eliminar','/sif/Utiles/Generales.xml')#" onclick="javascript:return confirm('¿Desea Eliminar el Registro?');">
				<input type="submit" name="Nuevo" value="#Request.Translate('BotonNuevo','Nuevo','/sif/Utiles/Generales.xml')#" >
			</cfif>
			</cfoutput>
	</td>
  </tr>
</table>
</form>

<!-- Texto para las validaciones -->
<script language="JavaScript1.1">
	document.form1.Adescripcion.alt = "El campo Artículo";
	document.form1.Cdescripcion.alt = "El campo Concepto";
	document.form1.Alm_Aid.alt = "El campo Almacén";
	ocultarCampos(document.form1.Tipo.value);
	function CambiarTipo(){
		document.form1.Tipo.value=0;
		ocultarCampos(document.form1.Tipo.value);
	}
</script>