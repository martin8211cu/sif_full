
<cfloop from="1" to="2" index="i">
	<cfquery datasource="#session.dsn#" name="busca">
		select RHRid, RHRdescripcion, RHRcodigo
		from RHRelojMarcador
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		  and RHRcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="AUTOGESTION">
	</cfquery>
	<cfif busca.RecordCount>
		<cfset session.RHRid = busca.RHRid>
		<cfset session.RHRcodigo = busca.RHRcodigo>
		<cfbreak>
	<cfelse>
		<cfquery datasource="#session.dsn#" name="mincfid">
			select min(CFid) as CFid from CFuncional
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		</cfquery>
		<cfif Len(mincfid.CFid) Is 0>
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="MSG_NoHayNingunCentroFuncionalDefinidoParaEstaEmpresa"
				Default="No hay ningún centro funcional definido para esta empresa"
				returnvariable="MSG_NoHayNingunCentroFuncionalDefinidoParaEstaEmpresa"/>
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="MSG_SeRequiereDeUnCentroFuncionalCualquieraParaAdjuntarloAlRelojMarcadorDeAutogestion"
				Default="Se requiere de un centro funcional (cualquiera) para adjuntarlo al reloj marcador de autogesti&oacute;n"
				returnvariable="MSG_SeRequiereDeUnCentroFuncionalCualquieraParaAdjuntarloAlRelojMarcadorDeAutogestion"/>				
			<cfthrow message="#MSG_NoHayNingunCentroFuncionalDefinidoParaEstaEmpresa#" 
				detail="#MSG_SeRequiereDeUnCentroFuncionalCualquieraParaAdjuntarloAlRelojMarcadorDeAutogestion#.">
		</cfif>
		<cfquery datasource="#session.dsn#">
			insert into RHRelojMarcador 
				(Ecodigo, CFid, RHRcodigo, RHRpasswd, RHRdescripcion, BMUsucodigo)
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#mincfid.CFid#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="AUTOGESTION">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="sin acceso">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="Reloj marcador para autogestión">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">)
		</cfquery>
	</cfif>
</cfloop>

<!--- Verifica si el sistema requiere digitar la clave--->
<cfquery name="rsRelojMarcador" datasource="#session.DSN#">
	select Pvalor
	from RHParametros 
	where Pcodigo = 570 
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 	
</cfquery>

<!---Verifica si el usuario se encuentra registrado en el mantenimiento de empleados--->
<cfquery name="rsUsuarioEmpleado" datasource="asp">
	select * from UsuarioReferencia 
	where STabla='DatosEmpleado' 
	and Usucodigo = #session.Usucodigo#	
</cfquery>

<cfif isdefined("rsUsuarioEmpleado.llave") and len(trim(rsUsuarioEmpleado.llave))>
	<cfquery name="rsEmpleado" datasource="#session.dsn#">
		select DEid,DEidentificacion,DEnombre,DEapellido1,DEapellido2,DEpassword 
		from DatosEmpleado 
		where DEid= #rsUsuarioEmpleado.llave#
		and Ecodigo = #session.Ecodigo#	
	</cfquery>
</cfif>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ValidandoInformacion"
	Default="Validando Información"
	returnvariable="MSG_ValidandoInformacion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_SuRelojEstaDesajustado"
	Default="Su reloj está desajustado"
	returnvariable="MSG_SuRelojEstaDesajustado"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ErrorEnComunicaciones"
	Default="Error en comunicaciones"
	returnvariable="MSG_ErrorEnComunicaciones"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Lunes"
	Default="Lunes"
	returnvariable="LB_Lunes"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Martes"
	Default="Martes"
	returnvariable="LB_Martes"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Miercoles"
	Default="Miércoles"
	returnvariable="LB_Miercoles"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Jueves"
	Default="Jueves"
	returnvariable="LB_Jueves"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Viernes"
	Default="Viernes"
	returnvariable="LB_Viernes"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Sabado"
	Default="Sábado"
	returnvariable="LB_Sabado"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Domingo"
	Default="Domingo"
	returnvariable="LB_Domingo"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Cedula"
	Default="Cédula"
	returnvariable="LB_Cedula"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Clave"
	Default="Clave"
	returnvariable="LB_Clave"/>	

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Entrada"
	Default="Entrada"
	returnvariable="BTN_Entrada"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Salida"
	Default="Salida"
	returnvariable="BTN_Salida"/>	
	
	
<cfparam name="session.RHRid" type="numeric">
<cfparam name="session.RHRcodigo" type="string">
<cfparam name="session.locReloj" type="numeric" default="1">
<cfif session.RHRid is 0><cflocation url="index.cfm" addtoken="no"></cfif>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><cf_translate key="Reloj Marcador">Reloj Marcador</cf_translate></title>
<script type="text/JavaScript">
<!--
function dijitaNumero(){
	var key=window.event.keyCode;
	if (key < 48 || key > 57){
	window.event.keyCode=0;
}}

function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}

function goSubmit(accion)
{
	var err = '';

	<cfif rsRelojMarcador.Pvalor EQ 1 or not isdefined("rsEmpleado.DEid")>
		if (document.form1.u.value == ''){
			err= 'Dijite la cedula.\n'
		}
		if (document.form1.k.value == ''){
			err= err + 'Dijite la clave.\n'
		}
	</cfif>

	if(err ==''){
		document.form1.Accion.value = accion;
		document.form1.submit();
	}
	else{
		alert(err);
	}
}

//-->
</script>
</head>
<body bgcolor="#ffffff" onload="MM_preloadImages('../imagenes/btnentradagt2.jpg')">
<!--url's used in the movie-->
<!--text used in the movie-->
<table border="0" cellpadding="0" cellspacing="0">
<tr>
<td>

	<object  style=" background-color:#FF0000" border="0"classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" tabindex="1" 
		codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0" width="450" height="550" id="RelojMarcador" align="middle">
	<param name="allowScriptAccess" value="sameDomain" />
	<cfoutput>
	<param name="movie" value="RelojMarcador.swf?p=#Rand()#" />
	</cfoutput>
	
	<param name="quality" value="high" />
	<param name="bgcolor" value="#ffffff" />
	
	<!---<embed src="RelojMarcador.swf?p=<cfoutput>#Rand()#&ValidInfo=#MSG_ValidandoInformacion#&RelojDesajustado=#MSG_SuRelojEstaDesajustado#&ErrorComunic=#MSG_ErrorEnComunicaciones#&Lunes=#LB_Lunes#&Martes=#LB_Martes#&Miercoles=#LB_Miercoles#&Jueves=#LB_Jueves#&Viernes=#LB_Viernes#&Sabado=#LB_Sabado#&Domingo=#LB_Domingo#&LBCedula=#LB_Cedula#&LBClave=#LB_Clave#&LBEntrada=#BTN_Entrada#&LBSalida=#BTN_Salida#</cfoutput>" quality="high" bgcolor="#ffffff" 
		 width="950" height="550" name="RelojMarcador" align="middle"  
		 allowScriptAccess="sameDomain" type="application/x-shockwave-flash" 
		 pluginspage="http://www.macromedia.com/go/getflashplayer" />--->
	
	<embed src="RelojMarcador.swf?p=<cfoutput>#Rand()#</cfoutput>" quality="high" bgcolor="#ffffff" 
		 width="550" height="550" name="RelojMarcador" align="middle"  
		 allowScriptAccess="sameDomain" type="application/x-shockwave-flash" 
		 pluginspage="http://www.macromedia.com/go/getflashplayer" />
	
	</object>
</td>

<td>
	<form name="form1" enctype="multipart/form-data" method="post" action="reloj-submit.cfm"> 
		<input name="Accion" id="Accion" type="hidden" value="" />
		<table border="0" cellpadding="0" cellspacing="0" align="center">
		<tr><td colspan="2"><font size="+4" color="#999999">Cédula</font></td></tr>
		<tr><td colspan="2">
			<cfif isdefined("rsEmpleado.DEidentificacion") and rsEmpleado.DEidentificacion>
				<font size="+3"><cfoutput>#rsEmpleado.DEidentificacion#  - #rsEmpleado.DEnombre# #rsEmpleado.DEapellido1# #rsEmpleado.DEapellido2#</cfoutput></font>
				<input name="u" type="hidden" value="<cfoutput>#rsEmpleado.DEidentificacion#</cfoutput>" style="width:200px; height:30px; font-size:16px;"/>
			<cfelse>
				<input name="u" type="text" value="" style="width:200px; height:30px; font-size:16px;"/>
			</cfif>
			</td></tr> <!--- onkeypress="Javascript: dijitaNumero()"--->
		
			<!---solicita la clave si el sistema lo requiere o si el usuario asociado no esta registrado como empleado--->
			<cfif rsRelojMarcador.Pvalor EQ 1 or not isdefined("rsEmpleado") or rsEmpleado.RecordCount EQ 0>
			<tr><td colspan="2"><font size="+4" color="#999999">Clave</font></td></tr>
			<tr><td colspan="2">
				<input name="k" type="password" value="" style="width:200px; height:30px; font-size:16px"/>
			</td></tr>
			<cfelse>
				<tr><td colspan="2">
				<input name="k" type="hidden" value="" style="width:200px; height:30px; font-size:16px"/>
				</td></tr>
			</cfif>
		
		</table>
		<br/><br/>
	</form>
	<table border="0" cellpadding="2" cellspacing="2">
	<tr><td>
		<img onclick="javascript: goSubmit('Entrada');" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image3','','../imagenes/btnentradagt2.jpg',1)" src="../imagenes/btnentradagt.jpg" name="Image3" width="236" height="54" border="0" id="Image3" />
	</td>
	<td>
		<img src="../imagenes/btnsalidagt.jpg" name="Image2" width="236" height="54" border="0" id="Image2" onclick="javascript: goSubmit('Salida');"onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image2','','../imagenes/btnsalidagt2.jpg',1)"/>
	</td>
	</tr>
	
	<cfif isdefined("url.msg") and len(trim(url.msg))>
		<tr><td colspan="2" align="center" style="font-size:14px; color:##FF0000">
			<font size="+3" color="#990000"><strong><cfoutput>#url.msg#</cfoutput></strong></font>
		</td></tr>
	</cfif>
	
	</table>
</td>

</tr>
</table>
</body>
</html>
