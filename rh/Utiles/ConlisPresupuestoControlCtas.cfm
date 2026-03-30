<!--- 
	Fecha: 13 Octubre 2004
	Cambios: siempre se chequea el disponible aunque el control de presupuesto sea abierto, no se chequea cuando el mes es el mes de auxiliares 
	Solicitud: Ivannia y Oscar
--->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Lista de Cuentas de Presupuesto</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body style="margin:0;">

	<cfquery name="rsMesAuxiliar" datasource="#session.DSN#">
		select a.Pvalor as Ano, m.Pvalor as Mes
		  from Parametros m, Parametros a
		 where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		   and a.Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="50">
		   and m.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		   and m.Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="60">
	</cfquery>
	
	<cfset GvarUrlToFormParam = "">

	<cfset fnUrlToFormParam ("txt_codigo", "")>
	<cfset fnUrlToFormParam ("txt_descripcion", "")>
	<cfset fnUrlToFormParam ("CPPid", "")>
	<cfset fnUrlToFormParam ("CPCano", "")>
	<cfset fnUrlToFormParam ("CPCmes", "")>
	<cfset fnUrlToFormParam ("CFidTipo", "")>
	<cfset fnUrlToFormParam ("CFid", "")>
	<cfset fnUrlToFormParam ("p1", "")>
	<cfset fnUrlToFormParam ("p2", "")>
	<cfset fnUrlToFormParam ("p3", "")>
	<cfset fnUrlToFormParam ("p4", "")>
	<cfset fnUrlToFormParam ("p5", "")>
	<cfset fnUrlToFormParam ("p6", "")>
	<cfset navegacion = GvarUrlToFormParam>
	
	<script language="javascript" type="text/javascript">
		<cfoutput>
			if (!window.opener)
			{
				alert('ERROR DE SEGURIDAD 1');
				window.close();
			}

			if (window.opener.document.#Form.p1#.CFidTipo.value != '#form.CFidTipo#')
			{
				alert('ERROR DE SEGURIDAD 2:'+window.opener.document.#Form.p1#.CFidTipo + '!=#form.CFidTipo#');
				window.close();
			}
			
			if (window.opener.document.#Form.p1#.CFid<cfif form.CFidTipo EQ "O">Origen<cfelseif form.CFidTipo EQ "D">Destino</cfif>.value != '#form.CFid#')
			{
				alert('ERROR DE SEGURIDAD 3:' + '*'+window.opener.document.#Form.p1#.CFid<cfif form.CFidTipo EQ "O">Origen<cfelseif form.CFidTipo EQ "D">Destino</cfif>.value+ '*');
				window.close();
			}
		</cfoutput>
	</script>
	<cfif isdefined("Form.CPcuenta")>
		<cfinvoke component="sif.Componentes.PRES_Presupuesto" 
			method="CalculoDisponible"
			returnvariable="LstrDisponible">
		
			<cfinvokeargument name="CPPid" value="#Form.CPPid#">
			<cfinvokeargument name="CPCano" value="#Form.CPCano#">
			<cfinvokeargument name="CPCmes" value="#Form.CPCmes#">
			<cfinvokeargument name="CPcuenta" value="#Form.CPcuenta#">
			<cfinvokeargument name="Ocodigo" value="#Form.Ocodigo#">
			<cfinvokeargument name="TipoMovimiento" value="T">
			<cfinvokeargument name="Conexion" value="#Session.DSN#">
			<cfinvokeargument name="Ecodigo" value="#Session.Ecodigo#">
		
		</cfinvoke>
	
		<cfset LvarDisponible = LstrDisponible.Disponible>
		<cfif rsMesAuxiliar.Ano*100+rsMesAuxiliar.Mes LT form.CPCano*100+form.CPCmes>
			<cfset LvarMesFuturo = " (Mes Futuro)">
		<cfelse>
			<cfset LvarMesFuturo = "">
		</cfif>

		<script language="javascript" type="text/javascript">
			<cfoutput>
			<cfif form.CFidTipo NEQ "R" AND LstrDisponible.CPCPtipoControl EQ "0">
				window.opener.document.#Form.p1#.#Form.p2##Form.p6#.value = '';
				window.opener.document.#Form.p1#.#Form.p3##Form.p6#.value = '';
				window.opener.document.#Form.p1#.#Form.p4##Form.p6#.value = '';
				alert("ERROR: No se permiten Traslados de Cuentas de Presupuesto con Tipo de Control Abierto");
			<cfelse>
				window.opener.document.#Form.p1#.#Form.p2##Form.p6#.value = '#Form.CPcuenta#';
				window.opener.document.#Form.p1#.#Form.p3##Form.p6#.value = '#Form.Cuenta#';
				window.opener.document.#Form.p1#.#Form.p4##Form.p6#.value = '#Form.Descripcion#';
				if (window.opener.document.#Form.p1#.mensaje) 
				{
					if (window.opener.document.#Form.p1#.cuenta) 
					{
						window.opener.document.#Form.p1#.cuenta.value = '#Form.Cuenta# #Form.Descripcion#';
					}
					<cfif LstrDisponible.CPCPtipoControl EQ "0">
						window.opener.document.#Form.p1#.mensaje.value = 'Control Abierto, Disponible #LvarMesFuturo#: ' + '#LSNumberFormat(LvarDisponible, ',9.00')#';
					<cfelseif form.CFidTipo EQ "D">
						window.opener.document.#Form.p1#.mensaje.value = 'Disponible #LvarMesFuturo#: ' + '#LSNumberFormat(LvarDisponible, ',9.00')#';
					<cfelseif LvarDisponible LTE 0>
						window.opener.document.#Form.p1#.mensaje.value = 'No tiene Presupuesto Disponible#LvarMesFuturo#: ' + '#LSNumberFormat(LvarDisponible, ',9.00')#';
					<cfelse>
						window.opener.document.#Form.p1#.mensaje.value = 'Máximo Disponible #LvarMesFuturo#: ' + '#LSNumberFormat(LvarDisponible, ',9.00')#';
					</cfif>
					if (window.opener.document.#Form.p1#.#Mid(Form.p2, 1, 2)#mensaje#Form.p6#)
					{
						window.opener.document.#Form.p1#.#Mid(Form.p2, 1, 2)#mensaje#Form.p6#.value = window.opener.document.#Form.p1#.mensaje.value;
					}
				}

				if (window.opener.document.#Form.p1#.#Mid(Form.p2, 1, 2)#disponible#Form.p6#) {
					window.opener.document.#Form.p1#.#Mid(Form.p2, 1, 2)#disponible#Form.p6#.value = '#LSNumberFormat(LvarDisponible, ',9.00')#';
				} else if (window.opener.document.#Form.p1#.disponible#Form.p6#) {
					window.opener.document.#Form.p1#.disponible#Form.p6#.value = '#LSNumberFormat(LvarDisponible, ',9.00')#';
				} else if (window.opener.document.#Form.p1#.disponible) {
					window.opener.document.#Form.p1#.disponible.value = '#LSNumberFormat(LvarDisponible, ',9.00')#';
				}

				// Agregado para poder validar el disponible
				if (window.opener.document.#Form.p1#.#Mid(Form.p2, 1, 2)#validarDisponible#Form.p6#) {
				<cfif LstrDisponible.CPCPtipoControl EQ "0">
					window.opener.document.#Form.p1#.#Mid(Form.p2, 1, 2)#validarDisponible#Form.p6#.value = '0';
				<cfelse>
					window.opener.document.#Form.p1#.#Mid(Form.p2, 1, 2)#validarDisponible#Form.p6#.value = '1';
				</cfif>
				} else if (window.opener.document.#Form.p1#.validarDisponible) {
				<cfif LstrDisponible.CPCPtipoControl EQ "0">
					window.opener.document.#Form.p1#.validarDisponible.value = '0';
				<cfelse>
					window.opener.document.#Form.p1#.validarDisponible.value = '1';
				</cfif>
				}
			</cfif>
			window.close();
			</cfoutput>
		</script>
		<cfabort>
	</cfif>

	<cfset filtro = "">
	<cfif Len(Trim(Form.txt_codigo))>
		<cfset filtro = filtro & " and b.CPformato like '%#Form.txt_codigo#%'">
	</cfif>
	<cfif Len(Trim(Form.txt_descripcion))>
		<cfset filtro = filtro & " and upper(coalesce(b.CPdescripcionF,b.CPdescripcion)) like '%#UCase(Form.txt_descripcion)#%'">
	</cfif>
	<cfif Len(Trim(Form.CPPid))>
		<cfset filtro = filtro & " and a.CPPid = " & Form.CPPid>
	</cfif>
	<cfif Len(Trim(Form.CPCano))>
		<cfset filtro = filtro & " and a.CPCano = " & Form.CPCano>
	</cfif>
	<cfif Len(Trim(Form.CPCmes))>
		<cfset filtro = filtro & " and a.CPCmes = " & Form.CPCmes>
	</cfif>

	<!--- TRASLADOS NO PERMITE CONTROL ABIERTO --->	
	<cfif form.CFidTipo NEQ "R">
		<cfset filtro = filtro & " and (select CPCPtipoControl from CPCuentaPeriodo cp where cp.Ecodigo = a.Ecodigo AND cp.CPPid = a.CPPid AND cp.CPcuenta = a.CPcuenta) <> 0">
	</cfif>

	<cfif form.CFidTipo EQ 'O'>
		<cf_CPSegUsu_where aliasCuentas="b" aliasOficina="a" Traslados="yes" sinUsucodigo="no" returnVariable="LvarCPSegUsu">
	<cfelseif form.CFidTipo EQ 'D'>
		<cf_CPSegUsu_where aliasCuentas="b" aliasOficina="a" Traslados="yes" sinUsucodigo="yes" returnVariable="LvarCPSegUsu">
	<cfelseif form.CFidTipo EQ 'R'>
		<cf_CPSegUsu_where aliasCuentas="b" aliasOficina="a" Reservas="yes" returnVariable="LvarCPSegUsu">
	<cfelse>
		<cfthrow message="Falta indicar el tipo de Centro Funcional en la pantalla origen *#form.CFidTipo#*">
	</cfif>
	<cfset filtro = filtro & LvarCPSegUsu>
	<!---
	<cfif Len(Trim(cuenta))>
		<cfset filtro = filtro & " and b.CPformato like '" & cuenta & "%'">
	</cfif>
	--->
	

	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	  <tr>
	    <td align="center" class="tituloListas">Lista de Cuentas de Presupuesto</td>
      </tr>
	  <tr>
		<td class="areaFiltro">
			<cfoutput>
			<form name="filtroCuentas" method="post" style="margin: 0;" action="#GetFileFromPath(GetTemplatePath())#">
				<cfloop collection="#Form#" item="i">
					<cfif FindNoCase('txt_codigo', i) EQ 0 and FindNoCase('txt_descripcion', i) EQ 0>
						<cfset v = StructFind(Form, i)>
						<input type="hidden" name="#i#" value="#v#">
					</cfif>
				</cfloop>
				<table width="100%"  border="0" cellspacing="0" cellpadding="3">
				  <tr>
					<td align="right" class="fileLabel">Cuenta:</td>
					<td>
						<input name="txt_codigo" type="text" size="10" maxlength="100" value="<cfif isdefined('Form.txt_codigo')>#Form.txt_codigo#</cfif>">
					</td>
					<td align="right" class="fileLabel">Descripci&oacute;n:</td>
					<td>
						<input name="txt_descripcion" type="text" size="40" maxlength="80" value="<cfif isdefined('Form.txt_descripcion')>#Form.txt_descripcion#</cfif>">
					</td>
					<td align="center">
						<input name="btnBuscar" type="submit" value="Buscar">
					</td>
				  </tr>
				</table>
			</form>
			</cfoutput>
		</td>
	  </tr>
	  <tr>
		<td align="center">
			<cfoutput>
			<form name="listaCuentas" method="post" action="#GetFileFromPath(GetTemplatePath())#">
				<cfloop collection="#Form#" item="i">
					<cfset v = StructFind(Form, i)>
					<cfif CompareNoCase(i, "txt_codigo") and CompareNoCase(i, "txt_descripcion") and Len(Trim(v))>
						<input type="hidden" name="#i#" value="#v#">
					</cfif>
				</cfloop>
				
				<cfif isdefined("Form.CFid") and Len(Trim(Form.CFid))>
					<cfinvoke 
					 component="rh.Componentes.pListas"
					 method="pListaRH"
					 returnvariable="pListaRet">
						<cfinvokeargument name="tabla" value="CPresupuestoControl a, CPresupuesto b, CFuncional c"/>
						<cfinvokeargument name="columnas" value="distinct a.CPcuenta, rtrim(b.CPformato) as Cuenta, coalesce(b.CPdescripcionF,b.CPdescripcion) as Descripcion, a.Ocodigo"/>
							<cfinvokeargument name="desplegar" value="Cuenta, Descripcion"/>
							<cfinvokeargument name="etiquetas" value="Cuenta, Descripci&oacute;n"/>
							<cfinvokeargument name="formatos" value=""/>
							<cfinvokeargument name="filtro" value="a.Ecodigo = #Session.Ecodigo#
																   and a.CPcuenta = b.CPcuenta
																   and c.CFid = #Form.CFid#
																   and a.Ecodigo = c.Ecodigo
																   and a.Ocodigo = c.Ocodigo
																   #filtro#
																   order by rtrim(b.CPformato)"/>
						<cfinvokeargument name="align" value="left, left"/>
						<cfinvokeargument name="ajustar" value=""/>
						<cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#"/>
						<cfinvokeargument name="formName" value="listaCuentas"/>
						<cfinvokeargument name="incluyeForm" value="false"/>
						<cfinvokeargument name="MaxRows" value="10"/>
						<cfinvokeargument name="debug" value="N"/>
						<cfinvokeargument name="navegacion" value="#navegacion#"/>
						<cfinvokeargument name="showEmptyListMsg" value="true"/>
						<cfinvokeargument name="EmptyListMsg" value="-- No hay cuentas de presupuesto para el Periodo de Presupuesto, Año, Mes y Oficina seleccionados --"/>
					</cfinvoke>
				<cfelse>
					<strong>Falta C&oacute;digo de Centro de Funcional</strong>
				</cfif>
			</form>
			</cfoutput>
		</td>
	  </tr>
	</table>

</body>
</html>

<cffunction name="fnUrlToFormParam">
	<cfargument name="LprmNombre"  type="string" required="yes">
	<cfargument name="LprmDefault" type="string" required="yes">
	
	<cfparam name="url[LprmNombre]" default="#LprmDefault#">
	<cfparam name="form[LprmNombre]" default="#url[LprmNombre]#">
	<cfif isdefined("GvarUrlToFormParam")>
		<cfif len(trim(GvarUrlToFormParam))>
			<cfset GvarUrlToFormParam = GvarUrlToFormParam & "&">
		</cfif>
		<cfset GvarUrlToFormParam = GvarUrlToFormParam & "#LprmNombre#=" & Form[LprmNombre]>
	</cfif>
</cffunction>
