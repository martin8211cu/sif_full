<!--- 
	Modificado por: Yu Hui 26 de Mayo 2005 
	Motivo: Cambio de Tag de Empleados
--->

<!--- Modo --->
<cfset modo = 'ALTA'>
<cfif isdefined("url.arbol_pos") and len(trim(url.arbol_pos))>
	<cfset form.FVid = url.arbol_pos>
	<cfset modo = 'CAMBIO'>
</cfif>

<!--- Consultas --->
<!-- 1. Vendedores -->
<cfif modo NEQ "Alta">
	<cfquery name="rsFVendedores" datasource="#Session.DSN#">
		select FVid,FVnombre, convert(varchar, EUcodigo) as EUcodigo, convert(varchar,Usucodigo) as Usucodigo, Ulocalizacion, Ocodigo, DEid, FVjefe, ts_rversion
		from FVendedores
		where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer" >
		  and FVid = <cfqueryparam value="#Form.FVid#" cfsqltype="cf_sql_numeric" >
	</cfquery>
	
	<cfif len(trim(rsFVendedores.FVjefe)) >
		<cfquery name="rsJefe" datasource="#session.DSN#">
			select FVnombre as FVjefenombre
			from FVendedores
			where FVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsFVendedores.FVjefe#">
		</cfquery>
	</cfif>
	

<!--- <cfdump var="#form#">
<cfdump var="#rsFVendedores#">
<cfabort>
 --->	<cfquery name="rsUsuarios" datasource="asp">
		select distinct b.Pnombre + rtrim(' ' + b.Papellido1 + rtrim(' ' + b.Papellido2)) as Nombre
		from Usuario a, DatosPersonales b, UsuarioProceso c
		where a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsFVendedores.EUcodigo#">
		and a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
		and a.datos_personales = b.datos_personales
		and a.Usucodigo = c.Usucodigo
		and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.EcodigoSDC#">
		and c.SScodigo = 'SIF'
		order by Nombre
	</cfquery>


	<cfquery name="rsRegistrosRef" datasource="#Session.DSN#">
		select count(*) cant from DTransacciones
		where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		and FVid = <cfqueryparam value="#Form.FVid#" cfsqltype="cf_sql_numeric">
	</cfquery>

</cfif>

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
	
	function doConlisUsuarios() {
		popUpWindow("ConlisUsuarios.cfm?form=form1&catalogo=ve&EUcodigo=EUcodigo&Usucodigo=Usucodigo&Ulocalizacion=Ulocalizacion&Usulogin=Usulogin&Nombre=FVnombre",250,200,650,350);
	}

	function doConlisVendedor() {
		var params ="";
		params = "?form=form1&id=FVjefe&name=FVjefenombre";
		popUpWindow("/cfmx/sif/fa/catalogos/conlisVendedores.cfm"+params,250,200,650,400);
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

<!--- Form --->
<form action="SQLVendedores.cfm" method="post" name="form1" onSubmit="MM_validateForm('FVnombre','','R'); if (document.MM_returnValue){ document.form1.FVnombre.disabled = false; return true} else{return false;}">
	<table width="100%" border="0" cellspacing="0" cellpadding="2">
		<tr>
			<td nowrap align="right" width="10%" >Usuario:&nbsp;</td>
			<td nowrap colspan="2">
				<input type="text" name="FVnombre" value="<cfif modo NEQ "ALTA"><cfoutput>#JSStringFormat(rsUsuarios.Nombre)#</cfoutput></cfif>" size="55" maxlength="80" readonly >
				<cfif modo EQ "ALTA"><a href="#" tabindex="-1"><img src="../../imagenes/Description.gif" alt="Lista de Usuarios" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlisUsuarios();"></a></cfif>
				<input type="hidden" name="EUcodigo" value="<cfif modo NEQ "ALTA"><cfoutput>#rsFVendedores.EUcodigo#</cfoutput></cfif>"> 
				<input type="hidden" name="Usucodigo" value="<cfif modo NEQ "ALTA"><cfoutput>#rsFVendedores.Usucodigo#</cfoutput></cfif>"> 
				<input type="hidden" name="Ulocalizacion" value="<cfif modo NEQ "ALTA"><cfoutput>#rsFVendedores.Ulocalizacion#</cfoutput></cfif>">
				<input type="hidden" name="Usulogin" value=""><!--- No se utiliza en este catálogo pero se pone para soportar el conlis creado para UsuariosCaja--->
				<input type="hidden" name="Nombre" value="">
			</td>
		</tr>
		
		<tr>
			<td nowrap align="right" >Oficina:&nbsp;</td>
			<cfquery name="rsOficinas" datasource="#session.DSN#">
				select Ocodigo, Odescripcion
				from Oficinas
				where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>
			<td nowrap colspan="2">
				<select name="Ocodigo">
					<cfoutput query="rsOficinas">
						<option value="#rsOficinas.Ocodigo#" <cfif modo neq 'ALTA' and rsOficinas.Ocodigo eq rsFVendedores.Ocodigo>selected</cfif> >#rsOficinas.Odescripcion#</option> 
					</cfoutput>
				</select>
			</td>
		</tr>

		<tr>
			<td nowrap align="right" >Jefe:&nbsp;</td>
			<td nowrap width="1%" >
				<input type="text" name="FVjefenombre" id="FVjefenombre" tabindex="1" readonly value="<cfif modo neq 'ALTA' and isdefined("rsJefe")><cfoutput>#rsJefe.FVjefenombre#</cfoutput></cfif>" 
					size="55" maxlength="80">
					<a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Vendedores" name="Vimagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisVendedor();'></a>
				<input type="hidden" name="FVjefe" value="<cfoutput><cfif modo neq 'ALTA'>#rsFVendedores.FVjefe#</cfif></cfoutput>">
			</td>
			<cfif modo neq 'ALTA'><input type="hidden" name="_FVjefe" value="<cfoutput>#rsFVendedores.FVjefe#</cfoutput>"></cfif>
			<td>
				<table width="100%">
					<tr><td><img alt="Borrar Jefe" src="../../imagenes/Borrar01_S.gif" style="cursor:hand;" onClick="document.form1.FVjefenombre.value=''; document.form1.FVjefe.value='';"></td></tr>
				</table>
			</td>
		</tr>
		
		<tr>
			<td nowrap align="right" >Empleado:&nbsp;</td>
			<td>
				<!---
				<cfif modo neq 'ALTA'>
					<cf_rhempleados nombre="deidNombre" idempleado="#rsFVendedores.DEid#" size="40">
				<cfelse>
					<cf_rhempleados nombre="deidNombre" size="40">
				</cfif>
				--->
				<cfif modo neq 'ALTA'>
					<cf_rhempleado size="40" Nombre="deidNombre" DEidentificacion="Pid" validateUser="true" idempleado="#rsFVendedores.DEid#">
				<cfelse>
					<cf_rhempleado size="40" Nombre="deidNombre" DEidentificacion="Pid" validateUser="true">
				</cfif>
				<td>
					<table width="100%">
						<tr><td><img alt="Borrar Empleado" src="../../imagenes/Borrar01_S.gif" style="cursor:hand;" onClick="document.form1.deidNombre.value=''; document.form1.DEid.value='';"></td></tr>
					</table>
				</td>
			</td>
		</tr>

		<tr>
			<td nowrap colspan="3">
				<cfoutput>
				<cfif modo NEQ "ALTA">
					<input type="hidden" name="FVid" value="#rsFVendedores.FVid#"> 
					<input type="hidden" name="registrosRef" value="#rsRegistrosRef.cant#">
				</cfif>
				</cfoutput>
			</td>
		</tr>
	</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr><td>&nbsp;</td></tr>	
  <tr>
  	<td nowrap align="center">
<!--- 		Copiado del portlet de botones para eliminar modificado y poner funcion en el borrado--->
		<cf_templatecss>
		<cfoutput>
		<cfif modo EQ "ALTA">
			<input type="submit" name="Alta" value="#Translate('BotonAgregar','Agregar','/sif/Utiles/Generales.xml')#">
			<input type="reset" name="Limpiar" value="#Translate('BotonLimpiar','Limpiar','/sif/Utiles/Generales.xml')#">
		<cfelse>	
			<input type="submit" name="Cambio" value="#Translate('BotonCambiar','Modificar','/sif/Utiles/Generales.xml')#">
			<input type="submit" name="Baja" value="#Translate('BotonBorrar','Eliminar','/sif/Utiles/Generales.xml')#" onclick="javascript:return confirm('¿Desea Eliminar el Registro?');">
			<input type="submit" name="Nuevo" value="#Translate('BotonNuevo','Nuevo','/sif/Utiles/Generales.xml')#" >
		</cfif>
		</cfoutput>
		<input name="txtEnterSI" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb">
<!--- 		Copiado del portlet de botones para eliminar modificado y poner funcion en el borrado--->
	</td>
  </tr>
<tr><td>&nbsp;</td></tr>	
</table>

		<cfoutput>
		<cfset ts = "">	
		<cfif modo neq "ALTA">
			<cfinvoke 
				component="sif.Componentes.DButils"
				method="toTimeStamp"
				returnvariable="ts">
				<cfinvokeargument name="arTimeStamp" value="#rsFVendedores.ts_rversion#"/>
			</cfinvoke>
			<input type="hidden" name="ts_rversion" value="#ts#">
		</cfif>
		</cfoutput>



</form>

<!-- Texto para las validaciones -->
<script language="JavaScript1.1">
	document.form1.FVnombre.alt = "El campo Usuario" 
</script>