<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Control de Parches</title>
<style type="text/css">
.hdrtit {
	background-color:#CCCCCC;
}
</style>
</head>
<body>
<center>
	<h1>Control de Parches</h1>
	<table width="700" border="1" bordercolor="black" cellpadding="2" cellspacing="0">
		<tr>
			<td width="155" valign="top" class="hdrtit"><b>Secuencia:</b></td>
			<td width="209" valign="top"><cfoutput>#HTMLEditFormat(session.parche.info.psec)#</cfoutput></td>
			<td width="166" valign="top" class="hdrtit"><b>N° Parche:</b></td>
			<td width="220" valign="top"><cfoutput>#HTMLEditFormat(session.parche.info.pnum)#</cfoutput></td>
		</tr>
		<tr>
			<td valign="top" class="hdrtit"><b>Folio:</b></td>
			<td valign="top"></td>
			<td valign="top" class="hdrtit"><b>Directorio:</b></td>
			<td valign="top"><cfoutput>#HTMLEditFormat(session.parche.info.pdir)#</cfoutput></td>
		</tr>
		<tr>
			<td valign="top" class="hdrtit"><b>Entregado por:</b></td>
			<td valign="top"><cfoutput>#HTMLEditFormat(session.parche.info.autor)#</cfoutput></td>
			<td valign="top" class="hdrtit"><b>Fecha Entrega:</b></td>
			<td valign="top"><cfset priorLocale = SetLocale("es_CR")>
				<cfoutput>#LSDateFormat(Now(),'full')#</cfoutput>
				<cfset SetLocale(priorLocale)>
			</td>
		</tr>
		<tr>
			<td valign="top" class="hdrtit"><b>Firma:</b></td>
			<td valign="top"></td>
			<td valign="top" class="hdrtit"><b>Parche Ant.</b></td>
			<td valign="top"></td>
		</tr>
		<tr>
			<td valign="top" class="hdrtit"><b>Módulo (s):</b></td>
			<td valign="top"><cfoutput>#HTMLEditFormat(session.parche.info.modulo)#</cfoutput></td>
			<td valign="top" class="hdrtit"><b>Prioridad</b></td>
			<td valign="top"></td>
		</tr>
		<tr>
			<td valign="top" class="hdrtit"><b>Caso (s):</b></td>
			<td valign="top"></td>
			<td valign="top" class="hdrtit"><b>Version SVN</b></td>
			<td valign="top"><cfoutput># HTMLEditFormat(svninfo.Revision)#</cfoutput></td>
		</tr>
		<tr>
			<td colspan="4" valign="top"><u><b>Descripción (Solicitado por, motivo y detalle): </b></u><br />
				<cfoutput>#HTMLEditFormat(session.parche.info.descripcion)#</cfoutput><br />
				<br />
				<br /></td>
		</tr>
	</table>
	<br />
	<!----************************ OPCIONES DE MENU NUEVAS ************************---->
	<table width="700" border="1" bordercolor="black" cellpadding="2" cellspacing="0">
		<tr>
			<td colspan="4" valign="top" class="hdrtit"><b>Opciones de menú nuevas:</b></td>
		</tr>
		<cfquery name="OpcionesNewParche" dbtype="query">
		select * from OpcionesParche where tipo = '1'
	</cfquery>
		<tr>
			<td colspan="4"><table border="1" width="100%" style="border:0;" bordercolor="black" cellpadding="2" cellspacing="0">
					<tr>
						<td valign="top" width="100" style="padding-left:15px; "><em><strong>&nbsp;&nbsp;&nbsp;Módulo</strong></em></td>
						<td valign="top" width="200"><em><strong> Opción</strong></em></td>
						<td valign="top" width="300"><em><strong> Descripción</strong></em></td>
					</tr>
					<cfoutput query="OpcionesNewParche" group="SScodigo">
						<tr>
							<td colspan="3"><b># HTMLEditFormat(Sistema)#</b></td>
						</tr>
						<cfoutput>
							<tr>
								<td valign="top" width="100" style="padding-left:15px; "># HTMLEditFormat(Modulo)#<br/></td>
								<td valign="top" width="200"># HTMLEditFormat(Opcion)#<br></td>
								<td valign="top" width="300"># HTMLEditFormat(detalle)#<br></td>
							</tr>
						</cfoutput> </cfoutput>
					<cfif OpcionesNewParche.RecordCount EQ 0>
						<tr>
							<td colspan="3">&nbsp;</td>
							<!----<em>[Sistema]</em>----->
						</tr>
						<tr>
							<td width="100">&nbsp;</td>
							<td width="200">&nbsp;</td>
							<td width="300">&nbsp;</td>
						</tr>
					</cfif>
				</table></td>
		</tr>
	</table>
	<br/>
	<!----************************************************---->
	<!----************************ OPCIONES DE MENU MODIFICADAS ************************---->
	<cfquery name="OpcionesModParche" dbtype="query">
	select * from OpcionesParche where tipo = '2'
</cfquery>
	<table width="700" border="1" bordercolor="black" cellpadding="2" cellspacing="0">
		<tr>
			<td colspan="4" valign="top" class="hdrtit"><b>Opciones de menú modificadas:</b></td>
		</tr>
		<tr>
			<td colspan="4"><table border="1" width="100%" style="border:0;" bordercolor="black" cellpadding="2" cellspacing="0">
					<tr>
						<td valign="top" width="100" style="padding-left:15px; "><em><strong>&nbsp;&nbsp;&nbsp;Módulo</strong></em></td>
						<td valign="top" width="200"><em><strong> Opción</strong></em></td>
						<td valign="top" width="300"><em><strong> Descripción</strong></em></td>
					</tr>
					<cfoutput query="OpcionesModParche" group="SScodigo">
						<tr>
							<td colspan="3"><b># HTMLEditFormat(Sistema)#</b></td>
						</tr>
						<cfoutput>
							<tr>
								<td valign="top" width="100" style="padding-left:15px; "># HTMLEditFormat(Modulo)#<br/></td>
								<td valign="top" width="200"># HTMLEditFormat(Opcion)#<br></td>
								<td valign="top" width="300"># HTMLEditFormat(detalle)#<br></td>
							</tr>
						</cfoutput> </cfoutput>
					<cfif OpcionesModParche.RecordCount EQ 0>
						<tr>
							<td colspan="3">&nbsp;</td>
						</tr>
						<tr>
							<td width="100">&nbsp;</td>
							<td width="200">&nbsp;</td>
							<td width="300">&nbsp;</td>
						</tr>
					</cfif>
				</table></td>
		</tr>
	</table>
	<br/>
	<!----************************************************---->
	<!----************************ OTROS PROCESOS  ************************---->
	<table width="700" border="1" bordercolor="black" cellpadding="2" cellspacing="0">
		<tr>
			<td colspan="4" valign="top" class="hdrtit"><b>Otros procesos:</b></td>
		</tr>
		<tr>
			<td colspan="4"><table border="1" width="100%" style="border:0;" bordercolor="black" cellpadding="2" cellspacing="0">
					<tr>
						<td valign="top" width="100" style="padding-left:15px; "><em><strong>&nbsp;&nbsp;&nbsp;Módulo</strong></em></td>
						<td valign="top" width="300"><em><strong> Descripción</strong></em></td>
					</tr>
					<cfoutput query="OpcionesOtrosParche" group="SScodigo">
						<tr>
							<td colspan="2"><b># HTMLEditFormat(Sistema)#</b></td>
						</tr>
						<cfoutput>
							<tr>
								<td valign="top" width="100" style="padding-left:15px; "># HTMLEditFormat(Modulo)#<br/></td>
								<td valign="top" width="300"># HTMLEditFormat(detalle)#<br></td>
							</tr>
						</cfoutput> </cfoutput>
					<cfif OpcionesOtrosParche.RecordCount EQ 0>
						<tr>
							<td colspan="2">&nbsp;</td>
						</tr>
						<tr>
							<td width="100">&nbsp;</td>
							<td width="300">&nbsp;</td>
						</tr>
					</cfif>
				</table></td>
		</tr>
	<!----
		<tr>
			<td colspan="3" valign="top" class="hdrtit"><b>Opciones de menú por agregar:</b></td>
		</tr>
		<tr>
			<td width="275" valign="top"><em><strong> Sistema</strong></em></td>
			<td width="329" valign="top"><em><strong> Opción</strong></em></td>
			<td width="150" valign="top"><em><strong> Responsable</strong></em></td>
		</tr>
		<tr>
			<td valign="top"></td>
			<td valign="top" ></td>
			<td valign="top" ></td>
		</tr>
	---->
	</table>
	<br/>

	<table width="700" border="1" bordercolor="black" cellpadding="2" cellspacing="0">
		<tr>
			<td colspan="3" valign="top" class="hdrtit"><b>Versiones de Actualización del Modelo de Base de Datos (DBM):</b></td>
		</tr>
		<tr>
			<td class="hdrtit" valign="top"><em><strong> SCHEMA / MODELO (Version)</strong></em></td>
			<td colspan="2" class="hdrtit" valign="top"><em><strong> Descripción de Version</strong></em></td>
		</tr>
	<cfif rsDBM.recordCount EQ 0>
			<tr>
				<td colspan="1" valign="top"><cfoutput>#HTMLEditFormat("Únicamente Fuentes (0)")#</cfoutput></td>
				<td colspan="2" valign="top"><cfoutput>#HTMLEditFormat("Registro de la Actualización de Fuentes")#</cfoutput></td>
			</tr>
	<cfelse>
		<cfloop query="rsDBM">
			<tr>
				<td colspan="1" valign="top"><cfoutput>#HTMLEditFormat(sch & " / " & modelo)# (#rsDBM.IDver#)</cfoutput></td>
				<td colspan="2" valign="top"><cfoutput>#HTMLEditFormat(version)#</cfoutput></td>
			</tr>
		</cfloop>
	</cfif>
		<tr>
			<td valign="top"></td>
			<td colspan="2" valign="top"></td>
		</tr>
		<tr>
			<td colspan="3" valign="top" class="hdrtit"><b>Contenido de fuentes:</b></td>
		</tr>
		<tr>
			<td width="275" valign="top" class="hdrtit"><em> <strong>Ruta/Archivo (Revisi&oacute;n)</strong></em></td>
			<td width="329" valign="top" class="hdrtit"><em> <strong>Documentación</strong></em></td>
			<td width="150" valign="top" class="hdrtit"><em> <strong>Responsable</strong></em></td>
		</tr>
		<cfquery dbtype="query" name="FuenteByRev">
			select *
			from APFuente
			order by revision,msg,nombre
		</cfquery>
		<cfoutput query="FuenteByRev" group="msg">
			<tr>
				<td valign="top"><cfoutput># HTMLEditFormat(nombre)#&nbsp;(# HTMLEditFormat(revision)#)<br />
					</cfoutput></td>
				<td valign="top" ># HTMLEditFormat(msg)#</td>
				<td valign="top" ># HTMLEditFormat(autor)#</td>
			</tr>
		</cfoutput>
		<tr>
			<td valign="top"></td>
			<td valign="top"></td>
			<td valign="top"></td>
		</tr>
		<tr>
			<td colspan="3" valign="top" class="hdrtit"><b>Listado
				de Scripts de Base de Datos:</b></td>
		</tr>
		<tr>
			<td valign="top"><em><strong> Archivo</strong></em></td>
			<td colspan="2" valign="top"><em><strong> Descripción</strong></em></td>
		</tr>
	<!---
		Esta funcionalidad se sustituye con DBMcontrolParches
		<tr>
			<td valign="top"> Sybase/<cfoutput>#HTMLEditFormat(session.parche.info.nombre)#.sql</cfoutput></td>
			<td colspan="2" valign="top"> Registro del Parche Aplicado Sybase</td>
		</tr>
		<tr>
			<td valign="top"> Oracle/<cfoutput>#HTMLEditFormat(session.parche.info.nombre)#.sql</cfoutput></td>
			<td colspan="2" valign="top"> Registro del Parche Aplicado Oracle</td>
		</tr>
		<tr>
			<td valign="top"> DB2/<cfoutput>#HTMLEditFormat(session.parche.info.nombre)#.sql</cfoutput></td>
			<td colspan="2" valign="top"> Registro del Parche Aplicado DB2</td>
		</tr>
	--->
		<cfloop query="APParcheSQL">
			<tr>
				<cfinvoke component="asp.parches.comp.misc" method="dbms2dbmsdir" dbms="#dbms#" returnvariable="dbmsdir"/>
				<td valign="top"><cfoutput>#dbmsdir#/#HTMLEditFormat(nombre)#</cfoutput></td>
				<td colspan="2" valign="top"><cfoutput> Instrucciones SQL para #dbmsdir#.  Ejecutar en #datasource#.<br />
						# HTMLEditFormat(descripcion)#</cfoutput></td>
			</tr>
		</cfloop>
		<tr>
			<td valign="top"></td>
			<td colspan="2" valign="top"></td>
		</tr>
	</table>
	<br />
	<table width="700" border="1" bordercolor="black" cellpadding="0" cellspacing="0" >
		<tr>
			<td><b>Instrucciones
				Adicionales:</b><br />
				<cfoutput>#HTMLEditFormat(session.parche.info.instrucciones)#</cfoutput><br />
				<br />
				<br />
			</td>
		</tr>
	</table>
	<br />
	<table width="700" border="1" bordercolor="black" cellpadding="0" cellspacing="0" style="page-break-inside:avoid">
		<tr>
			<td colspan="6" valign="top" class="hdrtit"><b>Firmas </b></td>
		</tr>
		<tr height="48">
			<td width="201" valign="top">Recibido
				por:</td>
			<td width="152" valign="top"></td>
			<td width="72" valign="top">Firma:</td>
			<td width="126" valign="top"></td>
			<td width="98" valign="top">Fecha:</td>
			<td width="105" valign="top"></td>
		</tr>
		<tr height="48">
			<td valign="top">Instalado
				por:</td>
			<td valign="top"></td>
			<td valign="top">Firma:</td>
			<td valign="top"></td>
			<td valign="top">Fecha:</td>
			<td valign="top"></td>
		</tr>
		<tr height="48">
			<td valign="top">Certificado
				(1) por:</td>
			<td valign="top"></td>
			<td valign="top">Firma:</td>
			<td valign="top"></td>
			<td valign="top">Fecha:</td>
			<td valign="top"></td>
		</tr>
		<tr height="48">
			<td valign="top">Certificado
				(2) por:</td>
			<td valign="top"></td>
			<td valign="top">Firma:</td>
			<td valign="top"></td>
			<td valign="top">Fecha:</td>
			<td valign="top"></td>
		</tr>
		<tr height="48">
			<td valign="top">Firma
				Finalizado:</td>
			<td colspan="3" valign="top"></td>
			<td valign="top">Fecha:</td>
			<td valign="top"></td>
		</tr>
	</table>
  	<br style="page-break-before:always" />
	<table width="700" border="1" bordercolor="black" cellpadding="0" cellspacing="0">
		<tr>
			<td colspan="2" valign="top" class="hdrtit"><b>Control de Calidad</b></td>
		</tr>
		<tr>
			<td width="392" valign="top"><b>Pantalla o proceso en prueba</b><b></b></td>
			<td width="370" valign="top"><em>* indicar nombre del proceso *</em></td>
		</tr>
		<tr>
			<td valign="top"><b>Pruebas adicionales que 
				
				se  
				requieren 
				para asegurar 
				la  
				calidad de
				esta pantalla  
				o proceso</b></td>
			<td valign="top"><b></b>(indicar aquí) </td>
		</tr>
	</table>
	<table width="700" border="1" bordercolor="black" cellpadding="0" cellspacing="0">
		<tr>
			<td colspan="2" valign="top"><b>Punto de
				Validación</b></td>
			<td width="89" align="center" valign="top"><b>Desarrollo</b></td>
			<td width="55" align="center" valign="top"><b>Certif</b><b>1</b></td>
			<td width="57" align="center" valign="top"><b>Certif</b><b>2</b></td>
		</tr>
		<tr>
			<td width="48" valign="top"><b>1.</b></td>
			<td width="507" valign="top"><b>General</b></td>
			<td valign="top"><b></b></td>
			<td valign="top"><b></b></td>
			<td valign="top"><b></b></td>
		</tr>
		<tr>
			<td valign="top"> 1.1.</td>
			<td valign="top">Es posible ingresar a
				la pantalla (la seguridad está definida)</td>
			<td valign="top"></td>
			<td valign="top"></td>
			<td valign="top"></td>
		</tr>
		<tr>
			<td valign="top"> 1.2.</td>
			<td valign="top">Es posible regresar al
				menú anterior</td>
			<td valign="top"></td>
			<td valign="top"></td>
			<td valign="top"></td>
		</tr>
		<tr>
			<td valign="top"> 1.3.</td>
			<td valign="top">Uso del cf_web_portlet</td>
			<td valign="top"></td>
			<td valign="top"></td>
			<td valign="top"></td>
		</tr>
		<tr>
			<td valign="top"> 1.4.</td>
			<td valign="top">Manejo adecuado de
				errores</td>
			<td valign="top"></td>
			<td valign="top"></td>
			<td valign="top"></td>
		</tr>
		<tr>
			<td valign="top"> 1.5.</td>
			<td valign="top">La pantalla cumple con
				la funcionalidad requerida</td>
			<td valign="top"></td>
			<td valign="top"></td>
			<td valign="top"></td>
		</tr>
		<tr>
			<td valign="top">1.6.</td>
			<td valign="top">La pantalla cumple con los estándares de las CSS.</td>
			<td valign="top"></td>
			<td valign="top"></td>
			<td valign="top"></td>
		</tr>
		<tr>
			<td valign="top">1.7.</td>
			<td valign="top">Se utiliza la pantalla regular de errores, en lugar del cftry/cfcatch con la pantalla BDerror.cfm de antes. </td>
			<td valign="top"></td>
			<td valign="top"></td>
			<td valign="top"></td>
		</tr>
		<tr>
			<td valign="top">1.8.</td>
			<td valign="top">Al terminar de ejecutar los archivos *-SQL.cfm, se regresa a la pantalla anterior usando cflocation en lugar de un form oculto. </td>
			<td valign="top"></td>
			<td valign="top"></td>
			<td valign="top"></td>
		</tr>
		<tr>
			<td valign="top"><b>2.</b></td>
			<td valign="top"><b>Administración de
				catálogos (ABC)</b></td>
			<td valign="top"><b></b></td>
			<td valign="top"><b></b></td>
			<td valign="top"><b></b></td>
		</tr>
		<tr>
			<td valign="top"> 2.1.</td>
			<td valign="top">Pantalla inicial de
				lista</td>
			<td valign="top"></td>
			<td valign="top"></td>
			<td valign="top"></td>
		</tr>
		<tr>
			<td valign="top"> 2.2.</td>
			<td valign="top">Si la lista va a la
				izquierda del formulario, en el ABC se mantiene la navegación.</td>
			<td valign="top"></td>
			<td valign="top"></td>
			<td valign="top"></td>
		</tr>
		<tr>
			<td valign="top"> 2.3.</td>
			<td valign="top">Si la lista va en una pantalla separada, el formulario debe tener un botón de Regresar, para regresar a la lista. </td>
			<td valign="top"></td>
			<td valign="top"></td>
			<td valign="top"></td>
		</tr>
		<tr>
			<td valign="top">2.4</td>
			<td valign="top">Si la lista va en una pantalla separada, al regresar a la lista, se mantiene el filtro y navegación por páginas. </td>
			<td valign="top"></td>
			<td valign="top"></td>
			<td valign="top"></td>
		</tr>
		<tr>
			<td valign="top"> 2.5.</td>
			<td valign="top">Es posible imprimir un
				listado del catálogo desde la pantalla de lista</td>
			<td valign="top"></td>
			<td valign="top"></td>
			<td valign="top"></td>
		</tr>
		<tr>
			<td valign="top"> 2.6.</td>
			<td valign="top">Filtros funcionan
				correctamente</td>
			<td valign="top"></td>
			<td valign="top"></td>
			<td valign="top"></td>
		</tr>
		<tr>
			<td valign="top"> 2.7.</td>
			<td valign="top">Filtros mantienen sus
				valores al aplicarse y al navegar</td>
			<td valign="top"></td>
			<td valign="top"></td>
			<td valign="top"></td>
		</tr>
		<tr>
			<td valign="top"> 2.8.</td>
			<td valign="top">Botones “Filtro”,
				“Nuevo” y “Listado” están en la parte superior derecha</td>
			<td valign="top"></td>
			<td valign="top"></td>
			<td valign="top"></td>
		</tr>
		<tr>
			<td valign="top"> 2.9.</td>
			<td valign="top">Formulario agrupado en
				pestañas (tabs).</td>
			<td valign="top"></td>
			<td valign="top"></td>
			<td valign="top"></td>
		</tr>
		<tr>
			<td valign="top"> 2.10.</td>
			<td valign="top">Encabezado de registro
				encima de las pestañas.</td>
			<td valign="top"></td>
			<td valign="top"></td>
			<td valign="top"></td>
		</tr>
		<tr>
			<td valign="top"> 2.11.</td>
			<td valign="top">Cada pestaña funciona
				independientemente</td>
			<td valign="top"></td>
			<td valign="top"></td>
			<td valign="top"></td>
		</tr>
		<tr>
			<td valign="top"> 2.12.</td>
			<td valign="top">Se validan los campos
				obligatorios en alta</td>
			<td valign="top"></td>
			<td valign="top"></td>
			<td valign="top"></td>
		</tr>
		<tr>
			<td valign="top"> 2.13.</td>
			<td valign="top">En alta se inserta el registro y
				regresa al modo cambio</td>
			<td valign="top"></td>
			<td valign="top"></td>
			<td valign="top"></td>
		</tr>
		<tr>
			<td valign="top"> 2.14.</td>
			<td valign="top">Se validan los campos
				obligatorios en cambio</td>
			<td valign="top"></td>
			<td valign="top"></td>
			<td valign="top"></td>
		</tr>
		<tr>
			<td valign="top"> 2.15.</td>
			<td valign="top">Al ejecutar el cambio se modifica
				el registro y regresa a modo cambio</td>
			<td valign="top"></td>
			<td valign="top"></td>
			<td valign="top"></td>
		</tr>
		<tr>
			<td valign="top"> 2.16.</td>
			<td valign="top">No se validan los campos obligatorios
				en modo baja</td>
			<td valign="top"></td>
			<td valign="top"></td>
			<td valign="top"></td>
		</tr>
		<tr>
			<td valign="top"> 2.17.</td>
			<td valign="top">Al ejecutar la baja, se regresa a
				la lista.<br />
				Si es necesario borrar en cascada, se hace correctamente.</td>
			<td valign="top"></td>
			<td valign="top"></td>
			<td valign="top"></td>
		</tr>
		<tr>
			<td valign="top"> 2.18.</td>
			<td valign="top">Si hay controles de edición
				especiales, se indica su funcionamiento y se documenta en la pantalla (fácil
				de usar)</td>
			<td valign="top"></td>
			<td valign="top"></td>
			<td valign="top"></td>
		</tr>
		<tr>
			<td valign="top">2.19.</td>
			<td valign="top">Se deben validar que los tipos de dato numéricos e identity acepten valores grandes. </td>
			<td valign="top"></td>
			<td valign="top"></td>
			<td valign="top"></td>
		</tr>
		<tr>
			<td valign="top">2.20.</td>
			<td valign="top">Se deben validar los tipos de datos con decimales, que realmente acepten decimales y no se realicen redondeos. </td>
			<td valign="top"></td>
			<td valign="top"></td>
			<td valign="top"></td>
		</tr>
		<tr>
			<td valign="top">2.21.</td>
			<td valign="top"><p>Se debe validar que los valores alfanuméricos funcionen correctamente con los caracteres especiales: &lt; &gt; [ ] ( ) { } ' &quot; , &amp; /  # % ! | @ ~ <span lang="ES-CR" xml:lang="ES-CR">.</span></p></td>
			<td valign="top"></td>
			<td valign="top"></td>
			<td valign="top"></td>
		</tr>
		<tr>
			<td valign="top">2.22.</td>
			<td valign="top"><p>La navegación del formulario por tabs es el correcto (sigue un orden lógico)<span lang="ES-CR" xml:lang="ES-CR">.</span></p></td>
			<td valign="top"></td>
			<td valign="top"></td>
			<td valign="top"></td>
		</tr>
		<tr>
			<td valign="top"><b>3.</b></td>
			<td valign="top"><b>Registro de Transacciones</b></td>
			<td valign="top"><b></b></td>
			<td valign="top"><b></b></td>
			<td valign="top"><b></b></td>
		</tr>
		<tr>
			<td valign="top"> 3.1.</td>
			<td valign="top">Pantalla inicial de
				lista</td>
			<td valign="top"></td>
			<td valign="top"></td>
			<td valign="top"></td>
		</tr>
		<tr>
			<td valign="top"> 3.2.</td>
			<td valign="top">Es posible imprimir un
				listado del los documentos desde la pantalla de lista</td>
			<td valign="top"></td>
			<td valign="top"></td>
			<td valign="top"></td>
		</tr>
		<tr>
			<td valign="top"> 3.3.</td>
			<td valign="top">Filtros funcionan
				correctamente</td>
			<td valign="top"></td>
			<td valign="top"></td>
			<td valign="top"></td>
		</tr>
		<tr>
			<td valign="top"> 3.4.</td>
			<td valign="top">Filtros mantienen sus
				valores al aplicarse y al navegar</td>
			<td valign="top"></td>
			<td valign="top"></td>
			<td valign="top"></td>
		</tr>
		<tr>
			<td valign="top"> 3.5.</td>
			<td valign="top">Si la lista va en una pantalla separada, el formulario debe tener un botón de Regresar, para regresar a la lista. </td>
			<td valign="top"></td>
			<td valign="top"></td>
			<td valign="top"></td>
		</tr>
		<tr>
			<td valign="top">3.6</td>
			<td valign="top">Si la lista va en una pantalla separada, al regresar a la lista, se mantiene el filtro y navegación por páginas. </td>
			<td valign="top"></td>
			<td valign="top"></td>
			<td valign="top"></td>
		</tr>
		<tr>
			<td valign="top"> 3.7.</td>
			<td valign="top">Botones “Filtro”, “Nuevo”
				y “Listado” están en la parte superior derecha</td>
			<td valign="top"></td>
			<td valign="top"></td>
			<td valign="top"></td>
		</tr>
		<tr>
			<td valign="top"> 3.8.</td>
			<td valign="top">Se validan los campos
				obligatorios en alta</td>
			<td valign="top"></td>
			<td valign="top"></td>
			<td valign="top"></td>
		</tr>
		<tr>
			<td valign="top"> 3.9.</td>
			<td valign="top">En alta se inserta el
				registro y regresa al modo cambio</td>
			<td valign="top"></td>
			<td valign="top"></td>
			<td valign="top"></td>
		</tr>
		<tr>
			<td valign="top"> 3.10.</td>
			<td valign="top">Se validan los campos
				obligatorios en cambio</td>
			<td valign="top"></td>
			<td valign="top"></td>
			<td valign="top"></td>
		</tr>
		<tr>
			<td valign="top"> 3.11.</td>
			<td valign="top">Al ejecutar el cambio
				se modifica el registro y regresa a modo cambio</td>
			<td valign="top"></td>
			<td valign="top"></td>
			<td valign="top"></td>
		</tr>
		<tr>
			<td valign="top">3.12.</td>
			<td valign="top">Se deben validar que los tipos de dato numéricos e identity acepten valores grandes. </td>
			<td valign="top"></td>
			<td valign="top"></td>
			<td valign="top"></td>
		</tr>
		<tr>
			<td valign="top">3.13.</td>
			<td valign="top">Se deben validar los tipos de datos con decimales, que realmente acepten decimales y no se realicen redondeos. </td>
			<td valign="top"></td>
			<td valign="top"></td>
			<td valign="top"></td>
		</tr>
		<tr>
			<td valign="top"> 3.14.</td>
			<td valign="top">No se validan los campos
				obligatorios en modo baja</td>
			<td valign="top"></td>
			<td valign="top"></td>
			<td valign="top"></td>
		</tr>
		<tr>
			<td valign="top"> 3.15.</td>
			<td valign="top">Al ejecutar la baja, se regresa a
				la lista</td>
			<td valign="top"></td>
			<td valign="top"></td>
			<td valign="top"></td>
		</tr>
		<tr>
			<td valign="top"> 3.16.</td>
			<td valign="top">Si hay controles de edición
				especiales, se indica su funcionamiento</td>
			<td valign="top"></td>
			<td valign="top"></td>
			<td valign="top"></td>
		</tr>
		<tr>
			<td valign="top"> 3.17.</td>
			<td valign="top">Es posible aplicar el documento
				tanto desde la lista como desde el formulario del documento.</td>
			<td valign="top"></td>
			<td valign="top"></td>
			<td valign="top"></td>
		</tr>
		<tr>
			<td valign="top"> 3.18.</td>
			<td valign="top">Es posible realizar al menos dos
				veces el ciclo completo: crear documento, modificarlo, consultarlo, aplicarlo
				y consultar el histórico.</td>
			<td valign="top"></td>
			<td valign="top"></td>
			<td valign="top"></td>
		</tr>
		<tr>
			<td valign="top"> 3.19.</td>
			<td valign="top">Se han probado todas las
				combinaciones de parámetros que modifiquen la funcionalidad de la pantalla</td>
			<td valign="top"></td>
			<td valign="top"></td>
			<td valign="top"></td>
		</tr>
		<tr>
			<td valign="top">3.20.</td>
			<td valign="top"><p>Se debe validar que los valores alfanuméricos funcionen correctamente con los caracteres especiales: &lt; &gt; [ ] ( ) { } ' &quot; , &amp; /  # % ! | @ ~ <span lang="ES-CR" xml:lang="ES-CR">.</span></p></td>
			<td valign="top"></td>
			<td valign="top"></td>
			<td valign="top"></td>
		</tr>
		<tr>
			<td valign="top">3.21.</td>
			<td valign="top"><p>El la navegación del formulario por tabs es el correcto (sigue un orden lógico)<span lang="ES-CR" xml:lang="ES-CR">.</span></p></td>
			<td valign="top"></td>
			<td valign="top"></td>
			<td valign="top"></td>
		</tr>
		<tr>
			<td valign="top"><b>4.</b></td>
			<td valign="top"><b>Consultas / Reportes</b></td>
			<td valign="top"><b></b></td>
			<td valign="top"><b></b></td>
			<td valign="top"><b></b></td>
		</tr>
		<tr>
			<td valign="top"> 4.1.</td>
			<td valign="top">Los filtros y
				parámetros de la consulta funcionan correctamente</td>
			<td valign="top"></td>
			<td valign="top"></td>
			<td valign="top"></td>
		</tr>
		<tr>
			<td valign="top"> 4.2.</td>
			<td valign="top">El manejo de las
				fechas es correcto</td>
			<td valign="top"></td>
			<td valign="top"></td>
			<td valign="top"></td>
		</tr>
		<tr>
			<td valign="top"> 4.3.</td>
			<td valign="top">El manejo de los
				rangos de códigos es correcto</td>
			<td valign="top"></td>
			<td valign="top"></td>
			<td valign="top"></td>
		</tr>
		<tr>
			<td valign="top"> 4.4.</td>
			<td valign="top">La consulta regresó
				información en al menos un caso</td>
			<td valign="top"></td>
			<td valign="top"></td>
			<td valign="top"></td>
		</tr>
		<tr>
			<td valign="top"> 4.5.</td>
			<td valign="top">Se totaliza
				correctamente </td>
			<td valign="top"></td>
			<td valign="top"></td>
			<td valign="top"></td>
		</tr>
		<tr>
			<td valign="top"> 4.6.</td>
			<td valign="top">El orden y
				agrupamiento de la información es el esperado.</td>
			<td valign="top"></td>
			<td valign="top"></td>
			<td valign="top"></td>
		</tr>
		<tr>
			<td valign="top"> 4.7.</td>
			<td valign="top">La consulta es
				eficiente, se han hecho pruebas con muchos registros.</td>
			<td valign="top"></td>
			<td valign="top"></td>
			<td valign="top"></td>
		</tr>
		<tr>
			<td valign="top"> 4.8.</td>
			<td valign="top">La consulta es legible</td>
			<td valign="top"></td>
			<td valign="top"></td>
			<td valign="top"></td>
		</tr>
		<tr>
			<td valign="top"> 4.9.</td>
			<td valign="top"></td>
			<td valign="top"></td>
			<td valign="top"></td>
			<td valign="top"></td>
		</tr>
		<tr>
			<td valign="top"><b>5.</b></td>
			<td valign="top"><b>Portabilidad</b></td>
			<td valign="top"><b></b></td>
			<td valign="top"><b></b></td>
			<td valign="top"><b></b></td>
		</tr>
		<tr>
			<td valign="top"> 5.1.</td>
			<td valign="top">Utiliza componentes en
				lugar de procedimientos almacenados</td>
			<td valign="top"></td>
			<td valign="top"></td>
			<td valign="top"></td>
		</tr>
		<tr>
			<td valign="top"> 5.2.</td>
			<td valign="top">Encapsula la lógica de
				negocio en componentes</td>
			<td valign="top"></td>
			<td valign="top"></td>
			<td valign="top"></td>
		</tr>
		<tr>
			<td valign="top"> 5.3.</td>
			<td valign="top">Se ha probado la
				funcionalidad completa en SYBASE</td>
			<td valign="top"></td>
			<td valign="top"></td>
			<td valign="top"></td>
		</tr>
		<tr>
			<td valign="top"> 5.4.</td>
			<td valign="top">Se ha probado la
				funcionalidad completa en ORACLE</td>
			<td valign="top"></td>
			<td valign="top"></td>
			<td valign="top"></td>
		</tr>
		<tr>
			<td valign="top"> 5.5.</td>
			<td valign="top">Se ha probado la
				funcionalidad completa en DB2</td>
			<td valign="top"></td>
			<td valign="top"></td>
			<td valign="top"></td>
		</tr>
		<tr>
			<td valign="top"> 5.6.</td>
			<td valign="top">Se ha probado la
				funcionalidad completa en SQL SERVER</td>
			<td valign="top"></td>
			<td valign="top"></td>
			<td valign="top"></td>
		</tr>
		<tr>
			<td valign="top"> 5.7.</td>
			<td valign="top">Se ha probado la
				funcionalidad completa en Microsoft Internet Explorer. Indique la versión.
				(5.5, 6.0)</td>
			<td valign="top"></td>
			<td valign="top"></td>
			<td valign="top"></td>
		</tr>
		<tr>
			<td valign="top"> 5.8.</td>
			<td valign="top">Se ha probado la
				funcionalidad completa en Mozilla Firefox. Indique la versión. (1.0.7, 1.5)</td>
			<td valign="top"></td>
			<td valign="top"></td>
			<td valign="top"></td>
		</tr>
		<tr>
			<td valign="top"> 5.9.</td>
			<td valign="top">La pantalla utiliza
				solamente el framework, coldfusion y javascript.<br />
				Reporte cualquier desviación o tecnología adicional utilizada (flash, Web Services,
				Active X, JSP, etc.).</td>
			<td valign="top"></td>
			<td valign="top"></td>
			<td valign="top"></td>
		</tr>
		<tr>
			<td valign="top"> 5.10.</td>
			<td valign="top"></td>
			<td valign="top"></td>
			<td valign="top"></td>
			<td valign="top"></td>
		</tr>
	</table>
	<b>Instrucciones
	de uso:</b>
	<ol start="1" type="1">
		<li>Utilice una copia de esta tabla para cada
			pantalla, proceso, consulta o reporte que se haya creado o modificado en
			este parche. Incluya solamente las secciones que apliquen según el tipo de
			proceso que esté validando.</li>
		<li>Sustituya * Nombre del Proceso * por el
			nombre de la pantalla.</li>
		<li>Rellenar cada casilla con S (si), N (no)
			o NA (no aplica)</li>
	</ol>
</center>
</body>
</html>
