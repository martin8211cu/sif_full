<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title><cf_translate  key="LB_ListaDeCuentasContables">Lista de Cuentas Contables</cf_translate></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
<!---
Preparación de variables del Conlis
--->
<!--- Pasa parámetros del URL al Form, para la primera llamada a la página, en cuyo caso los parámetros vienen por get. --->
<cfif (isdefined("Url.movimiento") and not isdefined("Form.movimiento"))>
	<cfset Form.movimiento = Url.movimiento>
</cfif>
<cfif (isdefined("Url.auxiliares") and not isdefined("Form.auxiliares"))>
	<cfset Form.auxiliares = Url.auxiliares>
</cfif>
<cfif (isdefined("Url.Cnx") and not isdefined("Form.Cnx"))>
	<cfset Form.Cnx = Url.Cnx>
</cfif>
<cfif (isdefined("Url.id") and not isdefined("Form.id"))>
	<cfset Form.id = Url.id>
</cfif>
<cfif (isdefined("Url.desc") and not isdefined("Form.desc"))>
	<cfset Form.desc = Url.desc>
</cfif>
<cfif (isdefined("Url.fmt") and not isdefined("Form.fmt"))>
	<cfset Form.fmt = Url.fmt>
</cfif>
<cfif (isdefined("Url.mayor") and not isdefined("Form.mayor"))>
	<cfset Form.mayor = Url.mayor>
</cfif>
<cfif (isdefined("Url.form") and not isdefined("Form.form"))>
	<cfset Form.form = Url.form>
</cfif>
<!--- Pasa parámetros del URL al Form, para cuando se está navegando con las flechas, en cuyo caso los parámetros vienen por get. --->
<cfif (isdefined("Url.FCuenta") and not isdefined("Form.FCuenta"))>
	<cfset Form.FCuenta = Url.FCuenta>
</cfif>
<cfif (isdefined("Url.FDesc") and not isdefined("Form.FDesc"))>
	<cfset Form.FDesc = Url.FDesc>
</cfif>
<!--- Se asegura que siempre existan los parámetros, si no vienen se ponen en  blanco. --->
<!--- opcionales --->
<cfparam name="Form.movimiento" default="N">
<cfparam name="Form.auxiliares" default="N">
<cfparam name="Form.Cnx" default="#Session.DSN#">
<cfparam name="Form.FCuenta" default="">
<cfparam name="Form.FDesc" default="">
<!--- requeridos --->
<cfparam name="Form.id">
<cfparam name="Form.desc">
<cfparam name="Form.fmt">
<cfparam name="Form.mayor">
<cfparam name="Form.form">
<!--- Limpia la Búsqueda --->
<cfif (isdefined("Form.bClear"))>
	<cfset Form.FCuenta = "">
	<cfset Form.FDesc = "">
</cfif>
<!--- Prepara el filtro para el query de la lista y prepara los parámetros que se enviarán por get en caso de la nevegación de la lista. --->
<cfset filtro = "">
<cfset navegacion = "">
<cfif (isdefined('Form.movimiento') and Form.movimiento EQ "S")>
	<cfset filtro = filtro & " and Cmovimiento = 'S'">
	<cfset navegacion = navegacion & iif(len(trim(navegacion)),DE("&"),DE("")) & "movimiento=" & Form.movimiento>
</cfif>	   
<cfif (isdefined('Form.auxiliares') and Form.auxiliares EQ "S")>
	<cfset filtro = filtro & " and coalesce(Mcodigo,1) not in (select distinct Mcodigo from Caracteristicas where Mcodigo != 1)">
	<cfset navegacion = navegacion & iif(len(trim(navegacion)),DE("&"),DE("")) & "auxiliares=" & Form.auxiliares>
</cfif>
<cfif (isdefined("Form.FCuenta") and len(trim(Form.FCuenta)))>
	<cfset filtro = filtro & " and upper(Cformato) like '%#Ucase(Form.FCuenta)#%'">
	<cfset navegacion = navegacion & iif(len(trim(navegacion)),DE("&"),DE("")) & "FCuenta=" & Form.FCuenta>
<cfelseif isdefined("url.Cmayor")>
	<cfset form.FCuenta = url.Cmayor>
	<cfset form.bFiltrar = "Filtrar">
	<cfset filtro = filtro & " and upper(Cformato) like '%#Ucase(Form.FCuenta)#%'">
	<cfset navegacion = navegacion & iif(len(trim(navegacion)),DE("&"),DE("")) & "FCuenta=" & Form.FCuenta>
</cfif>
<cfif (isdefined("Form.FDesc") and len(trim(Form.FDesc)))>
	<cfset filtro = filtro & " and upper(cc.Cdescripcion) like '%#Ucase(Form.FDesc)#%'">
	<cfset navegacion = navegacion & iif(len(trim(navegacion)),DE("&"),DE("")) & "FDesc=" & Form.FDesc>
</cfif>
<cfif (isdefined("Form.id") and len(trim(Form.id)))>
	<cfset navegacion = navegacion & iif(len(trim(navegacion)),DE("&"),DE("")) & "id=" & Form.id>
</cfif>
<cfif (isdefined("Form.desc") and len(trim(Form.desc)))>
	<cfset navegacion = navegacion & iif(len(trim(navegacion)),DE("&"),DE("")) & "desc=" & Form.desc>
</cfif>
<cfif (isdefined("Form.fmt") and len(trim(Form.fmt)))>
	<cfset navegacion = navegacion & iif(len(trim(navegacion)),DE("&"),DE("")) & "fmt=" & Form.fmt>
</cfif>
<cfif (isdefined("Form.mayor") and len(trim(Form.mayor)))>
	<cfset navegacion = navegacion & iif(len(trim(navegacion)),DE("&"),DE("")) & "mayor=" & Form.mayor>
</cfif>
<cfif (isdefined("Form.form") and len(trim(Form.form)))>
	<cfset navegacion = navegacion & iif(len(trim(navegacion)),DE("&"),DE("")) & "form=" & Form.form>
</cfif>
<cfif (isdefined("Form.bFiltrar"))>
	<cfset Url.PageNum_lista = 1>
</cfif>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Cuenta"
Default="Cuenta"
returnvariable="LB_Cuenta"/>	

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Descripcion"
Default="Descripción"
returnvariable="LB_Descripcion"/>		


<!--- Guarda la lista en la variable lista --->
<cfsavecontent variable="lista">
	<!--- Crea la lista --->

	
	<cfinvoke 
	 component="rh.Componentes.pListas"
	 method="pListaRH"
	 returnvariable="pListaRet">
		<cfinvokeargument name="tabla" value="CContables cc JOIN CtasMayor cm ON cc.Ecodigo= cm.Ecodigo AND cc.Cmayor=cm.Cmayor"/>
		<cfinvokeargument name="columnas" value="Ccuenta, Cformato, cc.Cdescripcion, cc.Cmayor, 
						(
							select min(cpv.CPVformatoF)
							  from CPVigencia cpv
							 where cpv.Ecodigo = cm.Ecodigo
							   and cpv.Cmayor = cm.Cmayor
							   and #createODBCdate(Now())# between CPVdesde and CPVhasta
						) as Cmascara		
		"/>
		<cfinvokeargument name="desplegar" value="Cformato, Cdescripcion"/>
		<cfinvokeargument name="etiquetas" value="#LB_Cuenta#,#LB_Descripcion#"/>
		<cfinvokeargument name="Formatos" value="V,V"/>
		<cfinvokeargument name="filtro" value="cc.Ecodigo = #Session.Ecodigo# #filtro# order by Cformato, cc.Cdescripcion"/>
		<cfinvokeargument name="align" value="left, left"/>
		<cfinvokeargument name="ajustar" value="S"/>
		<cfinvokeargument name="irA" value="ConlisCuentasContables.cfm"/>
		<cfinvokeargument name="maxrows" value="10"/>
		<cfinvokeargument name="navegacion" value="#navegacion#"/>
		<cfinvokeargument name="funcion" value="funcAsignar"/>
		<cfinvokeargument name="fparams" value="Ccuenta, Cdescripcion, Cformato, Cmascara"/>
	</cfinvoke>
</cfsavecontent>
</head>

<body>
<table width="100%"  border="0" cellspacing="1" cellpadding="1" style="margin:0;">
  <tr><td class="subTitulo" align="center"><cf_translate  key="LB_ListaDeCuentasContables">Lista de Cuentas Contables</cf_translate></td></tr>
	<tr>
		<td>
			<form name="formfiltro" method="post" action="ConlisCuentasContables.cfm" style="margin:0;">
				<table width="100%"  border="0" cellspacing="1" cellpadding="1" style="margin:0;" class="areaFiltro">
				<tr>
					<td align="left" ><strong><cf_translate  key="LB_Cuenta">Cuenta</cf_translate></strong></td>
					<td align="left" ><strong><cf_translate  key="LB_Descripcion">Descripci&oacute;n</cf_translate></strong></td>
					<td align="left" ><strong>&nbsp;</strong></td>
				</tr>
				<cfoutput>
				<tr>
					<td><input type="text" name="FCuenta" size="40" maxlength="40" value="#Form.FCuenta#"></td>
					<td><input type="text" name="FDesc" size="60" maxlength="60" value="#Form.FDesc#"></td>
					<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="BTN_Filtrar"
					Default="Filtrar"
					returnvariable="BTN_Filtrar"/>		
					
					<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="BTN_Limpiar"
					Default="Limpiar"
					returnvariable="BTN_Limpiar"/>					
					
					
					<td><input type="submit" name="bFiltrar" value="#BTN_Filtrar#">
							<input type="hidden" name="movimiento" value="#Form.movimiento#">
							<input type="hidden" name="auxiliares" value="#Form.auxiliares#">
							<input type="hidden" name="Cnx" value="#Form.Cnx#">
							<input type="hidden" name="id" value="#Form.id#">
							<input type="hidden" name="desc" value="#Form.desc#">
							<input type="hidden" name="fmt" value="#Form.fmt#">
							<input type="hidden" name="mayor" value="#Form.mayor#">
							<input type="hidden" name="form" value="#Form.form#"></td>
					<td><input type="submit" name="bClear" value="#BTN_Limpiar#"></td>
				</tr>
				</cfoutput>
				</table>
			</form>
		</td>
	</tr>
	<tr><td><cfoutput>#lista#</cfoutput></td></tr>
</table>
<script language="javascript">
	//inicio
	document.formfiltro.FCuenta.focus();
	//funcion de asignar valores del form que lo llama
	function funcAsignar(valor1, valor2, valor3, valor4) {
		<cfif isdefined("form.mayor") and len(trim(form.mayor))>
			if (valor3.length >= 4) {
				window.opener.document.<cfoutput>#form.form#.#form.mayor#</cfoutput>.value = valor3.substring(0,4);
			} else {
				window.opener.document.<cfoutput>#form.form#.#form.mayor#</cfoutput>.value = valor3;
			}
		</cfif>
		window.opener.document.<cfoutput>#form.form#.#form.id#</cfoutput>.value=valor1;
		window.opener.document.<cfoutput>#form.form#.#form.desc#</cfoutput>.value=valor2;
		<cfif isdefined("form.fmt") and len(trim(form.fmt))>
			window.opener.document.<cfoutput>#form.form#.#form.fmt#</cfoutput>.value= valor3.substring(5,valor3.length);
			window.opener.document.<cfoutput>#form.form#.#form.fmt#</cfoutput>.disableBlur = false;
		</cfif>
		
		window.opener.document.<cfoutput>#form.form#.#form.mayor#</cfoutput>_mask.value= valor4;
		window.opener.document.<cfoutput>#form.form#.#form.mayor#</cfoutput>.focus();
		window.close();
	}
</script>
</body>
</html>
