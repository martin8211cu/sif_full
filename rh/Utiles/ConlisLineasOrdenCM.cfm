<!--- Pasa parámetros recibidos en url al form --->
<cfif isdefined("url.formname") and len(url.formname)><cfset form.formname = url.formname></cfif>
<cfif isdefined("url.EOidorden") and len(url.EOidorden)><cfset form.EOidorden = url.EOidorden></cfif>
<cfif isdefined("url.idlinea") and len(url.idlinea)><cfset form.idlinea = url.idlinea></cfif>
<cfif isdefined("url.iddesc") and len(url.iddesc)><cfset form.iddesc = url.iddesc></cfif>
<cfif isdefined("url.feonumero") and len(url.feonumero)><cfset form.feonumero = url.feonumero></cfif>
<cfif isdefined("url.fobservaciones") and len(url.fobservaciones)><cfset form.fobservaciones = url.fobservaciones></cfif>

<!--- Requeridos en el form: formname, idlinea--->
<cfparam name="form.formname">
<cfparam name="form.idlinea">
<cfparam name="form.iddesc">
<!--- Javascript para asignar valores a la pantalla principal --->
<script language="JavaScript" type="text/javascript">
<!--//
	function Asignar(EOidorden, DOlinea) {
		<cfoutput>
		if (window.opener != null) {
			window.opener.document.#form.formname#.#form.EOidorden#.value = EOidorden;
			window.opener.document.#form.formname#.#form.idlinea#.value = DOlinea;
		
			if (window.opener.cambiarValores) {
					window.opener.cambiarValores(idlinea);
			}
			window.opener.document.#form.formname#.btnAgregar2.value=1;
			window.opener.document.#form.formname#.submit();
			window.close();
		}
		</cfoutput>
	}
//-->
</script>
<!--- Filtro y Navegación del Form del Conlis --->
<cfset navegacion = ''>
<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "formname=" & trim(form.formname)>
<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "idlinea=" & trim(form.idlinea)>
<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "iddesc=" & trim(form.iddesc)>
<html>
<head>
<title>Lista de Ordenes de Compra</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>
			<cfinclude template="sifConcat.cfm">
			<cfquery name="rsLista" datasource="#session.DSN#">
				select DOcantidad
					, a.Ucodigo
					, Udescripcion
					, DOpreciou
					, a.DOlinea
					, b.EOidorden
					, a.DOconsecutivo
					, a.DOdescripcion
					, a.EOnumero
					, <cf_dbfunction name="to_char" args="a.EOnumero">#_Cat#' - '#_Cat#b.Observaciones  as Orden
				from DOrdenCM a
					inner join EOrdenCM b
						on a.EOidorden=b.EOidorden
						and b.EOestado=10
					inner join Impuestos impuestolinea
						on impuestolinea.Icodigo = a.Icodigo
						and impuestolinea.Ecodigo = a.Ecodigo
					inner join Unidades u
						on a.Ucodigo=u.Ucodigo
							and a.Ecodigo=u.Ecodigo
				where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and a.DOcantsurtida < a.DOcantidad
					and CMtipo in ('A','S')					
					<cfif (isdefined("form.feonumero") and len(trim(form.feonumero)) and isnumeric(form.feonumero))>
						 and a.EOnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.feonumero#">
						<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "feonumero=" & trim(form.feonumero)>
					</cfif>
					<cfif isdefined("form.fobservaciones") and len(trim(form.fobservaciones))>
						and upper(DOdescripcion) like '%#UCase(Form.fobservaciones)#%'
						<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fobservaciones=" & trim(form.fobservaciones)>
					</cfif>
										
					and not exists(
									 select 1
									 from DDocumentosI x, EDocumentosI y
									 where x.EDIid = y.EDIid 
										and x.Ecodigo = y.Ecodigo
										and x.DOlinea = a.DOlinea
										and x.Ecodigo = a.Ecodigo
										and y.EDIestado = 0		
								)
					and (a.DOcantidad -(
											select coalesce(sum(DDIcantidad),0) 
											from DDocumentosI x, EDocumentosI y
											where x.EDIid = y.EDIid
												and x.DOlinea = a.DOlinea
												and x.Ecodigo = a.Ecodigo
												and y.EDIestado = 10		
										)
						) > 0				   
				order by a.EOnumero
			</cfquery>



<table width="100%" cellpadding="0" cellspacing="0">
	<tr>
		<td>
			<cfoutput><form style="margin:0;" name="form1" method="post" action="">
				<table width="100%" border="0" cellpadding="3" cellspacing="3" class="areaFiltro">
					<tr>
						<td align="right" nowrap><strong>&nbsp;N&uacute;mero Orden&nbsp;:&nbsp;</strong></td>
						<td> 
							<input name="feonumero" id="feonumero" type="text" size="10" maxlength="80" value="<cfif isdefined("form.feonumero")>#form.feonumero#</cfif>" onFocus="javascript:this.select();">
						</td>
						<td align="right"><strong>&nbsp;Descripci&oacute;n&nbsp;:&nbsp;</strong></td>
						<td> 
							<input name="fobservaciones" id="fobservaciones" type="text" size="40" maxlength="80" value="<cfif isdefined("form.fobservaciones")>#form.fobservaciones#</cfif>" onFocus="javascript:this.select();">
						</td>
						<td align="right" width="100%">
							<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">&nbsp;
						</td>
					</tr>
				</table>
				<input type="hidden" name="formname" id="formname" value="#form.formname#">
				<input type="hidden" name="idlinea" id="idlinea" value="#form.idlinea#">
				<input type="hidden" name="iddesc" id="iddesc" value="#form.iddesc#">
			</form></cfoutput>
		</td>
	</tr>	
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td>
			<cfinvoke 
					component="rh.Componentes.pListas"
					method="pListaQuery"
					returnvariable="pListaRet"> 
				<cfinvokeargument name="query" value="#rsLista#"/> 
				<cfinvokeargument name="Cortes" value="Orden"/>
				<cfinvokeargument name="desplegar" value="DOconsecutivo, DOdescripcion, Udescripcion, DOcantidad, DOpreciou"/> 
				<cfinvokeargument name="etiquetas" value="L&iacute;nea, Descripci&oacute;n, Unidad, Cantidad, Precio Unitario"/> 
				<cfinvokeargument name="formatos" value="S,S,S,N,N"/> 
				<cfinvokeargument name="align" value="left,left,left,rigth,rigth"/> 
				<cfinvokeargument name="ajustar" value="N"/> 
				<cfinvokeargument name="irA" value="ConlisLineasCompra.cfm"/> 
				<cfinvokeargument name="maxrows" value="8"/> 				
				<cfinvokeargument name="debug" value="N"/>
				<cfinvokeargument name="funcion" value="Asignar"/>
				<cfinvokeargument name="fparams" value="EOidorden, DOlinea"/>
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
				<cfinvokeargument name="showEmptyListMsg" value="yes"/>
			</cfinvoke> 
		</td>
	</tr>
</table>
</body>
</html>