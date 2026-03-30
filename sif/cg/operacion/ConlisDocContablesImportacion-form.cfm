<!--- 
	Modificado por: Gustavo Fonseca H.
		Fecha: 3-3-2006.
		Motivo: Se agrega la leyenda: PROCESANDO ........... ESPERE POR FAVOR. y se oculta cuando termina de procesar.
 --->

<!---
		Debe Cambiarse el proceso para que invoque el componente de validacion de cuentas.
		Ya lo hizo en DocContablesImportacion-sql.cfm y aqui se hace de nuevo
--->
<cfif isdefined("Url.ECIid") and Len(Trim(Url.ECIid)) and not isdefined("Form.ECIid")>
	<cfparam name="Form.ECIid" default="#Url.ECIid#">
<cfelseif isdefined("Session.ImportarAsientos") and isdefined("Session.ImportarAsientos.ECIid") and Len(Trim(Session.ImportarAsientos.ECIid)) and not isdefined("Form.ECIid")>
	<cfparam name="Form.ECIid" default="#Session.ImportarAsientos.ECIid#">
</cfif>

	<div id="divtrabajando" align="center"><strong>PROCESANDO ........... ESPERE POR FAVOR</strong></div> 
	<cfflush interval="1">

	<cfinvoke 
	 component="sif.Componentes.CG_AplicaImportacionAsiento"
	 method="CG_VerficaImportacionAsiento"
	 returnvariable="LvarMSG">
		<cfinvokeargument name="ECIid" value="#Form.ECIid#"/>
		<cfinvokeargument name="Ecodigo" value="#Session.Ecodigo#"/>
		<cfinvokeargument name="Conexion" value="#Session.DSN#"/>
		<cfinvokeargument name="ValidacionInterfaz16" value="no"/>
	</cfinvoke>
	<script language="javascript1.1" type="text/javascript">
		var a = document.getElementById("divtrabajando");
		a.style.display = "none";
	</script>
	<cfif LvarMSG NEQ "OK" >

			<!---- Se obitnenen TODAS las líneas Incorrectas --->
			<cfquery name="rsRegistrosIncorrectos" datasource="#Session.DSN#">
				select 
					a.DCIconsecutivo as linea,
					coalesce(o.Oficodigo, ' ** N/A **') as Oficina,
					a.EcodigoRef as CodEmpresa,
					CFformato as Formato,
					coalesce(MSG, '  ** N/A **') as Mensaje
				from DContablesImportacion a
					left outer join Oficinas o
						 on o.Ecodigo = a.EcodigoRef
						and o.Ocodigo = a.Ocodigo
				where a.ECIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECIid#">
				  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				  and a.Resultado <> 1
				order by a.DCIconsecutivo
			</cfquery>

			<cfinclude template="Funciones.cfm">
			
			<cfquery datasource="#Session.DSN#" name="rsEmpresa">
				select Edescripcion from Empresas
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			</cfquery>
	
			 <style type="text/css">
				.encabReporte {
					background-color: #006699;
					font-weight: bold;
					color: #FFFFFF;
					padding-top: 2px;
					padding-bottom: 2px;
					font-size:12px;
				}
				.topline {
					border-top-width: 1px;
					border-top-style: solid;
					border-right-style: none;
					border-bottom-style: none;
					border-left-style: none;
					border-top-color: #CCCCCC;
				}
				.bottomline {
					border-bottom-width: 1px;
					border-bottom-style: solid;
					border-right-style: none;
					border-top-style: none;
					border-left-style: none;
					border-bottom-color: #CCCCCC;
				}
				.subTituloRep {
					font-weight: bold; 
					font-size: x-small; 
					background-color: #F5F5F5;
				}
			</style><!--- --->
			
			<cfoutput>
				<cf_sifHTML2Word titulo="Errores en la Importaci&oacute;n de Documentos">
					<form name="form1" method="post">
						<table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 10px" align="center">
							<tr><td colspan="4" class="tituloAlterno" align="center">#rsEmpresa.Edescripcion#</td></tr>
							<tr><td colspan="4">&nbsp;</td></tr>
							<tr><td colspan="4" align="center"><b><font size="2">Errores en la Importaci&oacute;n de Documentos</font></b></td></tr>
							
							<tr><td colspan="4" class="bottomline">&nbsp;</td></tr>
							<tr><td colspan="4" class="tituloListas">&nbsp;</td></tr>
					 
							<tr>
							  <td width="12%" nowrap class="encabReporte"><div align="left">L&iacute;nea &nbsp; &nbsp;</div></td>
								<td width="13%" valign="top" align="left" nowrap class="encabReporte">Oficina &nbsp;&nbsp;</td> 
								<td width="10%" valign="top" align="left" nowrap class="encabReporte">Formato</td>
								<td width="65%" valign="top" class="encabReporte">Mensaje</td>
							</tr>
					
						<cfset i = 1>
						<cfloop query="rsRegistrosIncorrectos">
							<tr  <cfif i MOD 2> class="listaNon"<cfelse> class="listaPar"</cfif>>
								<td align="center" valign="top" nowrap width="12%">#linea#</td>
								<td align="center" valign="top" nowrap width="13%">#Oficina#</td> 
								<td align="left" valign="top" nowrap width="10%"><strong>#Formato#</strong></td>
								<td align="justify"  valign="top" width="65%" >#Mensaje#</td>
							</tr>
							<cfset i = i + 1>
						</cfloop>
	
	
						<tr>
						  <td width="12%">&nbsp;</td> 
						  <td width="13%">&nbsp;</td>
						  <td width="10%">&nbsp;</td>
						  <td width="65%">&nbsp; </td>
						  </tr>
						<tr>
						  <td width="12%">&nbsp;</td> 
						  <td width="13%">&nbsp;</td>
						  <td width="10%">&nbsp;</td>
						  <td width="65%">&nbsp; </td>
						  </tr>
						<tr>
						  <td colspan="4"><div align="center">------------------ Fin del Reporte ------------------</div></td>
						</tr>
						<tr> 
						  <td colspan="4">
						  <div align="right"><input type="button" name="btnCerrar" value="Cerrar Ventana" onClick="javascript:window.close();"></div></td>
						</tr>
					  </table>
					</form>
			
				</cf_sifHTML2Word>	
			</cfoutput>
	<cfelse>
			<table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 10px" align="center">	
				<tr>
					 <td align="center">
						NO SE ENCONTRARON CUENTAS CON PROBLEMAS
					 </td>
				</tr>
				<tr>
					<td><input type="button" name="btnCerrar" value="Cerrar Ventana" onClick="javascript:window.close();"></td>
				</tr>
			  </table>
	</cfif>
