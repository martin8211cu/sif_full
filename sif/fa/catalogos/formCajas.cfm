<cfif isdefined("Form.Cambio")  or ( isdefined("form.FCid") and len(trim(form.FCid)) gt 0 )>
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
<cfquery name="rsAlmacenes" datasource="#Session.DSN#">
	select convert(varchar, Aid) as Aid, Bdescripcion
	from Almacen
	where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
	order by Bdescripcion
</cfquery>

<!-- 2. Oficinas -->
<cfquery name="rsOficinas" datasource="#Session.DSN#">
	select Ecodigo, Ocodigo, Odescripcion from Oficinas
	where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
</cfquery>

<!-- 3. TItems -->
<cfquery name="rsTItems" datasource="#Session.DSN#">
	select null Titemid, null Titemdesc
	union select 'A' Titemid, 'Artículo' Titemdesc
	union select 'S' Titemid, 'Servicio' Titemdesc
</cfquery>


<cfif modo NEQ "ALTA">
	<!-- 4. Cajas -->
	<cfquery name="rsCajas" datasource="#Session.DSN#">
		select
			convert(varchar,a.FCid) as FCid, a.FCcodigo,a.FCcodigoAlt, a.FCdesc, a.FCalmmodif, convert(varchar,a.Aid) as Aid,
			convert(varchar,a.Ccuenta) as Ccuenta, b.Cdescripcion, b.Cformato, a.FCcomplemento,
			convert(varchar,a.Ccuentadesc) as Ccuentadesc, c.Cdescripcion as descCcuentadesc, c.Cformato as formatoCcuentadesc,
			a.FCestado, a.FCproceso, a.FCresponsable, a.FCtipodef, a.Ocodigo, a.ts_rversion, a.CcuentaFalt, a.CcuentaSob,a.FCimportacion
		from FCajas a
		Inner Join CContables b
		ON a.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		and a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">
		and a.Ccuenta = b.Ccuenta
		Left outer join
		CContables c
		ON a.Ccuentadesc = c.Ccuenta
	</cfquery>

    <cfquery name="rsCajaImportacion" datasource="#Session.DSN#">
		select
			 a.FCcodigo, a.FCdesc, a.FCid
           from FCajas a
		where a.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		and a.FCid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">
        and a.FCimportacion = 1
	</cfquery>


	<!--- 5. Usuarios --->
	<cfquery name="rsUsuariosSRC" datasource="#Session.DSN#">
		Select b.FCcodigo, a.FCid, a.EUcodigo, a.Usucodigo, a.Ulocalizacion, a.Usulogin
		From UsuariosCaja a, FCajas b
		Where a.FCid = b.FCid
		and b.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		and a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">
	</cfquery>

	<cfset aux = "">
	<cfset EUcodigos = "">
	<cfloop query="rsUsuariosSRC">
		<cfset EUcodigos = EUcodigos & aux & Eucodigo>
		<cfset aux = ",">
	</cfloop>
	<cfif rsUsuariosSRC.RecordCount GT 0>
    	<cfinclude template="../../Utiles/sifConcat.cfm">
		<cfquery name="rsUNombres" datasource="asp">
			select a.Usucodigo as EUcodigo,
				   b.Pnombre #_Cat# ' ' #_Cat# b.Papellido1 #_Cat# ' ' #_Cat# b.Papellido2 as Nombre
			from Usuario a left outer join DatosPersonales b
			on a.datos_personales = b.datos_personales
			where a.Usucodigo in (#EUcodigos#)
		</cfquery>
		<cfquery name="rsUsuarios" dbtype="query">
			select rsUsuariosSRC.EUcodigo,
			       rsUNombres.Nombre
			from rsUsuariosSRC, rsUNombres
			where rsUsuariosSRC.EUcodigo = rsUNombres.EUcodigo
		</cfquery>
	<cfelse>
		<cfquery name="rsUsuarios" dbtype="query">
			select * from rsUsuariosSRC
		</cfquery>
	</cfif>

	<!--- 6. Cantidad de Transacciones --->
	<cfquery name="rsRegistrosRef" datasource="#Session.DSN#">
		select count(*) as cant from ETransacciones
		where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		and FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">
	</cfquery>
</cfif>

<!--- 7. Codigos existentes --->
<cfquery name="rsCodigos" datasource="#session.DSN#">
	select rtrim(FCcodigo) as FCcodigo
	from FCajas
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	<cfif modo neq "ALTA">
		and FCid != <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">
	</cfif>
</cfquery>

<!--- 8. Codigos Alternos existentes --->
<cfquery name="rsCodigosAlt" datasource="#session.DSN#">
	select rtrim(FCcodigoAlt) as FCcodigoAlt
	from FCajas
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	<cfif modo neq "ALTA">
		and FCid != <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">
	</cfif>
</cfquery>

<script language="JavaScript1.2" src="/cfmx/sif/js/utilesMonto.js"></script>
<script language="JavaScript1.2" type="text/JavaScript">

<!--
function codigos(obj){
	if (obj.value != "") {
		var empresa = <cfoutput>#session.Ecodigo#</cfoutput>
		var dato    = obj.value + "|" + empresa;
		var temp    = new String();

		<cfloop query="rsCodigos">
			temp = '<cfoutput>#rsCodigos.FCcodigo#</cfoutput>' + "|" + empresa
			if (dato == temp){
				alert('El Código de Caja ya existe.');
				obj.value = "";
				obj.focus();
				return false;
			}
		</cfloop>
	}
	return true;
}

function codigosAlt(obj){
	if (obj.value != "") {
		var empresa = <cfoutput>#session.Ecodigo#</cfoutput>
		var dato    = obj.value + "|" + empresa;
		var temp    = new String();

		<cfloop query="rsCodigosAlt">
			temp = '<cfoutput>#rsCodigosAlt.FCcodigoAlt#</cfoutput>' + "|" + empresa
			if (dato == temp){
				alert('El Código Alterno ya existe.');
				obj.value = "";
				obj.focus();
				return false;
			}
		</cfloop>
	}
	return true;
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
  } if (errors) alert('Se presentaron los siguientes errores:\n\n'+errors);
  document.MM_returnValue = (errors == '');
}

function MM_validateReference(cant) {
  //cant = Cantidad de Registros Asociados
  var errors='';
  if (cant>0) {
  	errors += 'El registro no se puede borrar porque tiene registros asociados en otras tablas.';
  }
  if (errors) alert('Se presentaron los siguientes errores:\n\n'+errors);
  return cant==0;
}

function usuarios(){
	document.form1.action = "UsuariosCaja.cfm"
	document.form1.submit();
}

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
	popUpWindow("conlisUsuarios.cfm?form=form1&catalogo=uc&EUcodigo=EUcodigo&Usucodigo=Usucodigo&Ulocalizacion=Ulocalizacion&Usulogin=Usulogin&Nombre=Nombre&fcid="+fcid,250,200,750,350);
}

//-->
</script>

<style type="text/css">
	.cuadro{
		border: 1px solid #999999;
	}

	.bottomline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-right-style: none;
		border-top-style: none;
		border-left-style: none;
		border-bottom-color: #CCCCCC;
	}
</style>
<form action="<cfoutput>#LvarSQLPagina#</cfoutput>" method="post" name="form1" onSubmit="MM_validateForm('FCcodigo','','R','FCcodigoAlt','','R','FCdesc','','R','Aid','','R','Ocodigo','','R','Ccuenta','','R');return document.MM_returnValue">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td width="30%" align="right" nowrap>C&oacute;digo de caja:&nbsp;</td>
      <td colspan="2" nowrap> <input name="FCcodigo" type="text" size="44" maxlength="15" value="<cfif modo NEQ 'ALTA'><cfoutput>#trim(rsCajas.FCcodigo)#</cfoutput></cfif>" tabindex="1"  onBlur="javascript:codigos(this);" onFocus="javascript:this.select();" alt="El C&oacute;digo de Caja"></td>
    </tr>
	 <tr>
      <td width="30%" align="right" nowrap>C&oacute;digo Alterno:&nbsp;</td>
      <td colspan="2" nowrap> <input name="FCcodigoAlt" type="text" size="44" maxlength="15" value="<cfif modo NEQ 'ALTA'><cfoutput>#trim(rsCajas.FCcodigoAlt)#</cfoutput></cfif>" tabindex="1"  onBlur="javascript:codigosAlt(this);" onFocus="javascript:this.select();" alt="El C&oacute;digo Alterno"></td>
    </tr>
    <tr>
      <td align="right" nowrap>Almac&eacute;n:&nbsp;</td>
      <td colspan="2" nowrap><select name="Aid">
          <cfoutput query="rsAlmacenes">
            <cfif modo EQ 'ALTA'>
              <option value="#rsAlmacenes.Aid#">#rsAlmacenes.Bdescripcion#</option>
              <cfelse>
              <option value="#rsAlmacenes.Aid#" <cfif #rsCajas.Aid# EQ #rsAlmacenes.Aid#>selected</cfif>>#rsAlmacenes.Bdescripcion#</option>
            </cfif>
          </cfoutput> </select></td>
    </tr>
    <tr>
      <td align="right" nowrap>&nbsp; </td>
      <td width="2%" nowrap>
		<input name="FCalmmodif" type="checkbox"  value="<cfif modo NEQ "ALTA">#rsCajas.FCalmmodif#</cfif>" <cfif modo NEQ "ALTA"><cfif #rsCajas.FCalmmodif# EQ 1> checked </cfif></cfif>>
      	Almac&eacute;n modificable
	  </td>
    </tr>
    <tr>
      <td align="right" nowrap>&nbsp; </td>
      <td width="2%" colspan="2" ><input name="FCimportacion"  onclick="verificaExistencia();" type="checkbox" value="<cfif modo NEQ "ALTA">#rsCajas.FCimportacion#</cfif>" <cfif modo NEQ "ALTA"><cfif #rsCajas.FCimportacion# EQ 1> checked </cfif></cfif>>Caja Especial para importación</td>
       <input type="hidden"  name="ExisteCajaImportacion" value="<cfif isdefined('rsCajaImportacion') and rsCajaImportacion.recordcount gt 0>1<cfelse>0</cfif>"/>
       <input type="hidden"  name="ECajaDescripcion" value="<cfif isdefined('rsCajaImportacion') and rsCajaImportacion.recordcount gt 0><cfoutput>#rsCajaImportacion.FCdesc#</cfoutput></cfif>"/>
       <input type="hidden"  name="ECajaCodigo" value="<cfif isdefined('rsCajaImportacion') and rsCajaImportacion.recordcount gt 0><cfoutput>#rsCajaImportacion.FCcodigo#</cfoutput></cfif>"/>
       <input type="hidden"  name="ECaja" value="<cfif isdefined('rsCajaImportacion') and rsCajaImportacion.recordcount gt 0><cfoutput>#rsCajaImportacion.FCid#</cfoutput></cfif>"/>
    </tr>
    <tr>
      <td align="right" nowrap>Oficina:&nbsp;</td>
      <td colspan="2" nowrap><select name="Ocodigo">
          <cfif modo EQ 'ALTA'>
               <option value="">--- Seleccione ----</option>
             </cfif>
          <cfoutput query="rsOficinas">
            <cfif modo EQ 'ALTA'>
              <option value="#rsOficinas.Ocodigo#">#rsOficinas.Odescripcion#</option>
              <cfelse>
              <option value="#rsOficinas.Ocodigo#" <cfif #rsCajas.Ocodigo# EQ #rsOficinas.Ocodigo#>selected</cfif>>#rsOficinas.Odescripcion#</option>
            </cfif>
          </cfoutput> </select></td>
    </tr>
    <tr>
      <td align="right" nowrap>Descripci&oacute;n:&nbsp;</td>
      <td colspan="2"><input name="FCdesc" type="text" size="80" maxlength="80" <cfif modo NEQ 'ALTA'><cfoutput>value="#JSStringFormat(rsCajas.FCdesc)#"</cfoutput></cfif>></td>
    </tr>
    <tr>
      <td align="right" nowrap>Cuenta contable:&nbsp;</td>
      <td colspan="2" nowrap> <cfif modo NEQ "ALTA">
          <cfquery name="rsCC" dbtype="query">
          Select Ccuenta, Cdescripcion, Cformato from rsCajas
          </cfquery>
          <cf_cuentas conexion="#Session.DSN#" conlis="S" query="#rsCC#" auxiliares="N" movimiento="S">
          <cfelse>
          <cf_cuentas conexion="#Session.DSN#" conlis="S" auxiliares="N" movimiento="S">
        </cfif> </td>
    </tr>
     <tr>
      <td align="right" nowrap>Cuenta Faltante:&nbsp;</td>
      <td colspan="2" nowrap> <cfif modo NEQ "ALTA" and len(trim(rsCajas.CcuentaFalt)) gt 0 >
          <cfquery name="rsCCfalt" datasource="#session.DSN#">
          Select  Ccuenta as CcuentaFalt,  Cdescripcion as descCcuentaFalt,
          Cformato as formatoCcuentaFalt from CContables
            where Ccuenta = #rsCajas.CcuentaFalt#
            and Ecodigo = #session.Ecodigo#
          </cfquery>
          <cf_cuentas conexion="#Session.DSN#" frame="frcuenta2" conlis="S" query="#rsCCfalt#" auxiliares="N" movimiento="S" ccuenta="CcuentaFalt" cdescripcion="descCcuentaFalt" cformato="formatoCcuentaFalt">
          <cfelse>
          <cf_cuentas conexion="#Session.DSN#" frame="frcuenta2" conlis="S" auxiliares="N" movimiento="S" ccuenta="CcuentaFalt" cdescripcion="descCcuentaFalt" cformato="formatoCcuentaFalt">
        </cfif></td>
    </tr>
     <tr>
      <td align="right" nowrap>Cuenta Sobrante:&nbsp;</td>
      <td colspan="2" nowrap> <cfif modo NEQ "ALTA" and len(trim(rsCajas.CcuentaSob)) gt 0 >
          <cfquery name="rsCCsob" datasource="#session.DSN#">
          Select  Ccuenta as CcuentaSob,  Cdescripcion as descCcuentaSob, Cformato as formatoCcuentaSob
           from CContables
           where Ccuenta = #rsCajas.CcuentaSob#
           and Ecodigo = #session.Ecodigo#
          </cfquery>
          <cf_cuentas conexion="#Session.DSN#" frame="frcuenta3" conlis="S" query="#rsCCsob#" auxiliares="N" movimiento="S" ccuenta="CcuentaSob" cdescripcion="descCcuentaSob" cformato="formatoCcuentaSob">
          <cfelse>
          <cf_cuentas conexion="#Session.DSN#" frame="frcuenta3" conlis="S" auxiliares="N" movimiento="S" ccuenta="CcuentaSob" cdescripcion="descCcuentaSob" cformato="formatoCcuentaSob">
        </cfif></td>
    </tr>
    <tr>
       <td align="right">Complemento:</td>
       <td><input type="text" name="ComplementoCaja" id="ComplementoCaja" size="12" <cfif modo NEQ 'ALTA'><cfoutput>value="#rsCajas.FCcomplemento#"</cfoutput></cfif>></td>
    </tr>
    <!--- <tr>
      <td align="right" nowrap>Cuenta descuentos:&nbsp;</td>
      <td colspan="2" nowrap> <cfif modo NEQ "ALTA">
          <cfquery name="rsCC" dbtype="query">
          Select Ccuentadesc Ccuenta, descCcuentadesc Cdescripcion, formatoCcuentadesc
          Cformato from rsCajas
          </cfquery>
          <cf_cuentas conexion="#Session.DSN#" frame="frcuenta4" conlis="S" query="#rsCC#" auxiliares="N" movimiento="S" ccuenta="Ccuentadesc" cdescripcion="descCcuentadesc" cformato="formatoCcuentadesc">
          <cfelse>
          <cf_cuentas conexion="#Session.DSN#" frame="frcuenta4" conlis="S" auxiliares="N" movimiento="S" ccuenta="Ccuentadesc" cdescripcion="descCcuentadesc" cformato="formatoCcuentadesc">
        </cfif> </td>
    </tr> --->
    <tr>
      <td align="right" nowrap>Responsable:&nbsp;</td>
      <td colspan="2" nowrap><input name="FCresponsable" type="text" size="80" maxlength="80" <cfif modo NEQ 'ALTA'><cfoutput>value="#rsCajas.FCresponsable#"</cfoutput></cfif>></td>
    </tr>
    <tr>
      <td align="right" nowrap>Tipo de item default:&nbsp;</td>
      <td colspan="2" nowrap><select name="FCtipodef">
          <cfoutput query="rsTitems">
            <cfif modo EQ 'ALTA'>
              <option value="#rsTitems.Titemid#">#rsTitems.Titemdesc#</option>
              <cfelse>
              <option value="#rsTitems.Titemid#" <cfif #rsCajas.FCtipodef# EQ #rsTitems.Titemid#>selected</cfif>>#rsTitems.Titemdesc#</option>
            </cfif>
          </cfoutput> </select></td>
    </tr>
    <tr>
      <td colspan="3" nowrap>&nbsp;</td>
    </tr>
    <tr>
      <td nowrap colspan="3"> <cfif modo NEQ "ALTA">
          <cfset ts = "">
          <cfinvoke
				component="sif.Componentes.DButils"
				method="toTimeStamp"
				returnvariable="ts">
            <cfinvokeargument name="arTimeStamp" value="#rsCajas.ts_rversion#"/>
          </cfinvoke>
        </cfif> <cfif modo NEQ "ALTA">
          <cfoutput>
            <input type="hidden" name="FCid" value="#rsCajas.FCid#">
            <input type="hidden" name="ts_rversion" value="#ts#">
          </cfoutput> </cfif> </td>
    </tr>
    <tr>
      <td nowrap colspan="3"> <cfif modo NEQ "ALTA">
          <input type="hidden" name="registrosRef" value="<cfoutput>#rsRegistrosRef.cant#</cfoutput>">
        </cfif> </td>
    </tr>
    <!--- UsuariosXCaja.Inicio --->
    <cfif modo NEQ "ALTA">
      <tr>
        <td colspan="3" align="center">
          <table width="60%" border="0" cellspacing="0" cellpadding="0" align="center">
            <tr>
              <td align="center"> <fieldset>
                <legend><b>Asignaci&oacute;n de Usuarios</b></legend>
                <table align="center">
                  <tr>
                    <td nowrap><b>Usuario:&nbsp;</b></td>
                    <td nowrap>&nbsp;</td>
                  </tr>
                  <tr>
                    <td nowrap> <input type="text" name="Nombre" size="40" maxlength="80" readonly = "true" disabled = "true">
                      <a href="#" tabindex="-1"><img src="/sif/imagenes/Description.gif" alt="Lista de Usuarios" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlisUsuarios(<cfoutput>#Form.FCid#</cfoutput>);"></a>
                      <input type="hidden" name="EUcodigo" > <input type="hidden" name="Usucodigo" >
                      <input type="hidden" name="Ulocalizacion" > <input type="hidden" name="Usulogin" >
                    </td>
                    <td nowrap> <input type="submit" name="btnAceptar" value="Aceptar" onClick="javascript: MM_validateForm('EUcodigo','','R');
							return document.MM_returnValue;"> </td>
                  </tr>
                  <cfoutput query="rsUsuarios">
                    <tr <cfif CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>>
                      <td nowrap>#Nombre#</td>
                      <td nowrap>
                        <input  name="btnBorrar" type="image" alt="Eliminar elemento"
							onClick="javascript: Editar('#EUcodigo#');" src="/sif/imagenes/Borrar01_T.gif" width="16" height="16">
                      </td>
                    </tr>
                  </cfoutput>
                  <tr>
                    <td nowrap><input type="hidden" name="Eulin"></td>
                    <td nowrap>&nbsp;</td>
                  </tr>
                </table>
                </fieldset></td>
            </tr>
          </table></td>
      </tr>
    </cfif>
  </table>
  <!--- CuentasSocios.Fin --->
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr><td>&nbsp;</td></tr>
  <tr>
  	<td nowrap align="center">
<!--- 		Copiado del portlet de botones para poner el botón Usuarios--->
		<cf_templatecss>
		<cfoutput>
		<cfif modo EQ "ALTA">
			<input type="submit" name="Alta" value="#Translate('BotonAgregar','Agregar','/sif/Utiles/Generales.xml')#">
			<input type="reset" name="Limpiar" value="#Translate('BotonLimpiar','Limpiar','/sif/Utiles/Generales.xml')#">
		<cfelse>
			<input type="submit" name="Cambio" value="#Translate('BotonCambiar','Modificar','/sif/Utiles/Generales.xml')#">
			<input type="submit" name="Baja" value="#Translate('BotonBorrar','Eliminar','/sif/Utiles/Generales.xml')#" onclick="javascript: return MM_validateReference(document.form1.registrosRef.value) && confirm('¿Desea Eliminar el Registro?');">
			<input type="submit" name="Nuevo" value="#Translate('BotonNuevo','Nuevo','/sif/Utiles/Generales.xml')#" >
		</cfif>
		</cfoutput>
		<input name="txtEnterSI" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb">
<!--- 		Copiado del portlet de botones para poner el botón Usuarios--->
	</td>
  </tr>
</table>
</form>

<!-- Texto para las validaciones -->
<script language="JavaScript1.1">
	document.form1.FCcodigo.alt =	"El campo código de caja"
	document.form1.FCcodigoAlt.alt ="El campo código Alterno"
	document.form1.FCdesc.alt =		"El campo descripción"
	document.form1.Aid.alt =		"El campo almacén"
	document.form1.Ocodigo.alt =	"El campo oficina"
	document.form1.Ccuenta.alt =	"El campo Cuenta contable"
	<cfif modo NEQ "ALTA">
		document.form1.EUcodigo.alt = "El campo Usuario"
		function Editar(Eulin) {
			document.form1.Eulin.value = Eulin;
		}
	</cfif>

	function verificaExistencia()
	{
	 if(document.form1.ExisteCajaImportacion.value == 1)
	 {
	   var CF= document.form1.ECajaDescripcion.value;
	   var Codigo =  document.form1.ECajaCodigo.value;

		  var Cambio = confirm("La caja: " + Codigo+" - " + CF +", ya esta definida como caja de importación. Desea cambiarla?");
		  {
			  if(Cambio == false)
			   document.form1.FCimportacion.checked = false;
		   }
	 }
	}
</script>