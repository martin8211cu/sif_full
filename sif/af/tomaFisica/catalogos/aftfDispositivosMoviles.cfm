<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>
	<cf_web_portlet_start titulo="#nav__SPdescripcion#">
		<!--- Aqui se incluye el form --->
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr><td>&nbsp;</td></tr>
		  <tr>
			<td>&nbsp;</td>
			<td valign="top" width="45%">
				<!---  VARIABLE LAVE PARA CUANDO VIENE DEL SQL --->
				<cfif isdefined("url.AFTFid_dispositivo") and len(trim(url.AFTFid_dispositivo))>
					<cfset form.AFTFid_dispositivo = url.AFTFid_dispositivo>
				</cfif>
				<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL--->
				<cfif isdefined("url.Pagina") and len(trim(url.Pagina))>
					<cfset form.Pagina = url.Pagina>
				</cfif>					
				<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
				<cfif isdefined("url.PageNum_Lista") and len(trim(url.PageNum_Lista))>
					<cfset form.Pagina = url.PageNum_Lista>
					<!--- RESETEA LA LLAVE CUANDO NAVEGA --->
					<cfset form.AFTFid_dispositivo = 0>
				</cfif>					
				<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA LISTA--->
				<cfif isdefined("form.PageNum") and len(trim(form.PageNum))>
					<cfset form.Pagina = form.PageNum>
				</cfif>
				<!--- VARIABLES DE FILTROS PARA CUANDO VIENE DEL SQL --->
				<cfif isdefined("url.Filtro_AFTFcodigo_dispositivo") and len(trim(url.Filtro_AFTFcodigo_dispositivo))>
					<cfset form.Filtro_AFTFcodigo_dispositivo = url.Filtro_AFTFcodigo_dispositivo>
				</cfif>
				<cfif isdefined("url.Filtro_AFTFnombre_dispositivo") and len(trim(url.Filtro_AFTFnombre_dispositivo))>
					<cfset form.Filtro_AFTFnombre_dispositivo = url.Filtro_AFTFnombre_dispositivo>
				</cfif>
				<cfif isdefined("url.Filtro_AFTFestatus_dispositivo") and len(trim(url.Filtro_AFTFestatus_dispositivo))>
					<cfset form.Filtro_AFTFestatus_dispositivo = url.Filtro_AFTFestatus_dispositivo>
				</cfif>					
				<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
				<cfparam name="form.Pagina" default="1">					
				<cfparam name="form.Filtro_AFTFcodigo_dispositivo" default="">
				<cfparam name="form.Filtro_AFTFnombre_dispositivo" default="">
				<cfparam name="form.Filtro_AFTFestatus_dispositivo" default="">
				<cfparam name="form.MaxRows" default="15">
				<!--- QUERY PARA COMBO DE ESTADOS --->
				<cfset rsAFTFestatus_dispositivo = QueryNew("value,description")>
				<cfset QueryAddRow(rsAFTFestatus_dispositivo,1)>
				<cfset QuerySetCell(rsAFTFestatus_dispositivo,"value","",rsAFTFestatus_dispositivo.recordcount)>
				<cfset QuerySetCell(rsAFTFestatus_dispositivo,"description","--Todos--",rsAFTFestatus_dispositivo.recordcount)>
				<cfset QueryAddRow(rsAFTFestatus_dispositivo,1)>
				<cfset QuerySetCell(rsAFTFestatus_dispositivo,"value",0,rsAFTFestatus_dispositivo.recordcount)>
				<cfset QuerySetCell(rsAFTFestatus_dispositivo,"description","Inactivo",rsAFTFestatus_dispositivo.recordcount)>
				<cfset QueryAddRow(rsAFTFestatus_dispositivo,1)>
				<cfset QuerySetCell(rsAFTFestatus_dispositivo,"value",1,rsAFTFestatus_dispositivo.recordcount)>
				<cfset QuerySetCell(rsAFTFestatus_dispositivo,"description","Activo",rsAFTFestatus_dispositivo.recordcount)>
				<!--- LISTA DEL MANTENIMIENTO --->
				<cfset LvarFuncion1 = "aftfDispositivosMoviles">
				<cfoutput>
				<script language="javascript" type="text/javascript">
					var popUpWin#LvarFuncion1#=null;
					function popUpWindow#LvarFuncion1#(URLStr, left, top, width, height)
					{
					  if(popUpWin#LvarFuncion1#)
					  {
						if(!popUpWin#LvarFuncion1#.closed) popUpWin#LvarFuncion1#.close();
					  }
					  popUpWin#LvarFuncion1# = open(URLStr, 'popUpWin#LvarFuncion1#', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
					  if (! popUpWin#LvarFuncion1# && !document.popupblockerwarning) {
						alert('Aviso: Su bloqueador de ventanas emergentes (popup blocker) \nestá evitando que se abra la ventana.\nPor favor revise las opciones de su navegador (browser), y \nacepte las ventanas emergentes de este sitio: ' + location.hostname);
						document.popupblockerwarning = 1;
					  }
					}
				</script>
				<fieldset><legend>Lista de Dispositivos Móviles (<a href="##" onclick="javascript:popUpWindow#LvarFuncion1#(('aftfDispositivosMoviles-rpt.cfm'),50,50,600,400);">Imprimir</a> <a href="##" onclick="javascript:popUpWindow#LvarFuncion1#(('aftfDispositivosMoviles-rpt.cfm'),50,50,600,400);"><img src="/cfmx/sif/imagenes/impresora.gif" border="0"></a>)</legend>
				</cfoutput>
				<cfinvoke 
				 component="sif.Componentes.pListas"
				 method="pLista"
				 returnvariable="pListaRet">
					<cfinvokeargument name="tabla" value="AFTFDispositivo a"/>
					<cfinvokeargument name="columnas" value="a.AFTFid_dispositivo, a.AFTFcodigo_dispositivo, a.AFTFnombre_dispositivo, 
																					case a.AFTFestatus_dispositivo 
																						when 1 then '<img border=""0"" id=""imgActivo"" height=""16"" width=""16"" src=""/cfmx/sif/imagenes/checked.gif"" />'
																						else '<img border=""0"" id=""imgActivo"" height=""16"" width=""16"" src=""/cfmx/sif/imagenes/unchecked.gif"" />'
																					end as AFTFestatus_dispositivo, 
																					case coalesce((select min(1) from AFTFHojaConteo b where b.AFTFid_dispositivo = a.AFTFid_dispositivo and b.AFTFestatus_hoja < 3),0)
																						when 0 then null
																						else a.AFTFid_dispositivo
																					end as AFTFinactivar_checkbox,
																					'' as AFTFespacio_en_blanco" />
					<cfinvokeargument name="filtro" value="a.CEcodigo = #session.CEcodigo# order by AFTFcodigo_dispositivo"/>
					<cfinvokeargument name="desplegar" value="AFTFcodigo_dispositivo, AFTFnombre_dispositivo, 
																					AFTFestatus_dispositivo, AFTFespacio_en_blanco"/>
					<cfinvokeargument name="etiquetas" value="C&oacute;digo, Descripci&oacute;n, Activo, "/>
					<cfinvokeargument name="formatos" value="S,S,I,U"/>
					<cfinvokeargument name="align" value="left,left,right,right"/>
					<cfinvokeargument name="ajustar" value="N,N,N"/>
					<cfinvokeargument name="irA" value="aftfDispositivosMoviles.cfm"/>
					<cfinvokeargument name="conexion" value="#session.dsn#"/>
					<cfinvokeargument name="mostrar_filtro" value="true"/>
					<cfinvokeargument name="filtrar_automatico" value="true"/>
					<cfinvokeargument name="rsAFTFestatus_dispositivo" value="#rsAFTFestatus_dispositivo#"/>
					<cfinvokeargument name="keys" value="AFTFid_dispositivo"/>
					<cfinvokeargument name="MaxRows" value="#form.MaxRows#"/>
					<cfinvokeargument name="checkboxes" value="S"/>
					<cfinvokeargument name="inactivecol" value="AFTFinactivar_checkbox"/>
					<cfinvokeargument name="Botones" value="Activar,Inactivar,Eliminar"/>
				</cfinvoke>
				<script language="javascript" type="text/javascript">
					<!--//
					/*Funciones de Activar e Inactivar de la Lista*/
					function funcActivar(){
						if (fnAlgunoMarcadolista()){
							if (confirm("¿Está seguro de que desea Activar los Dispositivos Móviles seleccionados?")) {
								document.lista.action = "aftfDispositivosMoviles-sql.cfm";
								return true;
							}
						} else {
							alert('Debe seleccionar un Dispositivo Móvil a Activar!');
						}		
						return false;
					}
					function funcInactivar(){
						if (fnAlgunoMarcadolista()){
							if (confirm("¿Está seguro de que desea Inactivar los Dispositivos Móviles seleccionados?")) {
								document.lista.action = "aftfDispositivosMoviles-sql.cfm";
								return true;
							}
						} else {
							alert('Debe seleccionar un Dispositivo Móvil a Inactivar!');
						}		
						return false;
					}
					function funcEliminar(){
						if (fnAlgunoMarcadolista()){
							if (confirm("¿Está seguro de que desea Eliminar los Dispositivos Móviles seleccionados?")) {
								document.lista.action = "aftfDispositivosMoviles-sql.cfm";
								return true;
							}
						} else {
							alert('Debe seleccionar un Dispositivo Móvil a Eliminar!');
						}		
						return false;
					}
					//-->
				</script>
				</fieldset>
			</td>
			<td>&nbsp;</td>
			<td valign="top" width="45%">
				<!--- MANTENIMIENTO --->
				<cfinclude template="aftfDispositivosMoviles-form.cfm">
			</td>
			<td>&nbsp;</td>
		  </tr>
		  <tr><td>&nbsp;</td></tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>