<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Fecha" Default= "Fecha" XmlFile="Contratos_frameAnotacion.xml" returnvariable="LB_Fecha"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Anotacion" Default= "Anotaci&oacute;n" XmlFile="Contratos_frameAnotacion.xml" returnvariable="LB_Anotacion"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_FechaAnotacion" Default= "Fecha Anotaci&oacute;n" XmlFile="Contratos_frameAnotacion.xml" returnvariable="LB_FechaAnotacion"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ArchivoImagen" Default= "Archivo/Imagen" XmlFile="Contratos_frameAnotacion.xml" returnvariable="LB_ArchivoImagen"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Archivo" Default= "Archivo" XmlFile="Contratos_frameAnotacion.xml" returnvariable="LB_Archivo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Descargar" Default= "Descargar" XmlFile="Contratos_frameAnotacion.xml" returnvariable="LB_Descargar"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Mensaje" Default= "La &Uacute;ltima anotaci&oacute;n no registró una im&aacute;gen o archivo del Activo." XmlFile="Contratos_frameAnotacion.xml" returnvariable="LB_Mensaje"/>




<cf_templateheader title="Registro de Contratos">
	<cf_web_portlet_start titulo="Registro Contratos">		


<cfset ListaImg = "JPG,BMP,GIF,PNG">
<cf_dbfunction name="OP_concat"	args="" returnvariable="LvarConcat">
<br />
<cfset archivo = GetFileFromPath(GetTemplatePath())>

<!--- Variables del Form --->
<cfif isdefined("url.CAMBIO") and not isdefined("form.CAMBIO")>
	<cfset form.CAMBIO = url.CAMBIO >
</cfif>


<cfif isdefined("url.CTContid")>
	<cfset url.CTContid = url.CTContid >
<cfelseif  isdefined("form.CTContid")>
	<cfset url.CTContid = form.CTContid >
</cfif>

<cfif isdefined("url.Ecodigo")>
	<cfset url.Ecodigo = url.Ecodigo >
<cfelseif  isdefined("form.Ecodigo")>
	<cfset url.Ecodigo = form.Ecodigo >
</cfif>



<cfif isdefined("url.AFAfecha1") and not isdefined("form.AFAfecha1")>
	<cfset form.AFAfecha1 = url.AFAfecha1 >
</cfif>


<!--- Variables del Filtro --->
<cfif isdefined("url.f_AFAfecha") and not isdefined("form.f_AFAfecha")>
	<cfset form.f_AFAfecha = url.f_AFAfecha >
</cfif>
<cfif isdefined("url.f_AFAtexto") and not isdefined("form.f_AFAtexto")>
	<cfset form.f_AFAtexto = url.f_AFAtexto >
</cfif>
<!-- Establecimiento del modo -->
<cfif isdefined("form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

	<cfset Ecodigo = url.Ecodigo >


<cfif modo neq 'ALTA'>

	<cfquery name="rsForm" datasource="#session.dsn#">
		select b.CTlinea,a.*
		from CTAnotaciones a 
        	inner join CTImagenes b
            	on a.CTContid = b.CTContid
                and a.CTlinea= b.CTlinea
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Ecodigo#">
		and a.CTContid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CTContid#">
		and b.CTlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CTlinea#">
	</cfquery>
    

</cfif>




<cfset navegacion = '&Ecodigo=#Ecodigo#'>
<cfif isdefined("form.f_AFAfecha") and len(trim(form.f_AFAfecha)) >
	<cfset navegacion = navegacion & '&f_AFAfecha = #form.f_AFAfecha#'>
</cfif>
<cfif isdefined("form.f_AFAtexto") and len(trim(form.f_AFAtexto)) >
	<cfset navegacion = navegacion & '&f_AFAtexto = #form.f_AFAtexto#'>
</cfif>

<!--- Se incluye un JavaScript --->
<script language="JavaScript1.2" src="/cfmx/sif/js/utilesMonto.js"></script>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td width="50%" valign="top">
			<cfoutput>
				<form style="margin:0;" name="filtroActivos" method="post" action="Contratos_frameAnotacion.cfm">
					<input type="hidden" name="CTContid" value="#url.CTContid#">
					<input type="hidden" name="Ecodigo" value="#url.Ecodigo#">

					<table border="0" width="100%" cellpadding="0" cellspacing="0" class="tituloListas" >
						<tr>
							<td nowrap ><strong>#LB_Fecha#:&nbsp;</strong></td>
							<td nowrap >&nbsp;</td>
							<td nowrap ><strong>#LB_Anotacion#:&nbsp;</strong></td>
							<td nowrap >&nbsp;</td>
						</tr>
						<tr>
							<td nowrap >
								<cfif isdefined("form.f_AFAfecha") and len(trim(form.f_AFAfecha))>
									<cfset fechaFiltro = LSDateFormat(form.f_AFAfecha,'dd/mm/yyyy')>
								<cfelse>
									<cfset fechaFiltro = ''>
								</cfif>
								<cf_sifcalendario tabindex="1" form="filtroActivos" name="f_AFAfecha" value="#fechaFiltro#">
							</td>
							<td nowrap >&nbsp;</td>
							<td nowrap ><input type="text" name="f_AFAtexto" tabindex="1" value="<cfif isdefined("form.f_AFAtexto") and len(trim(form.f_AFAtexto)) >#form.f_AFAtexto#</cfif>" size="30" maxlength="50"></td>
							<td nowrap align="center"><input type="submit" name="filtrar" value="Filtrar" tabindex="1"></td>
						</tr>
					</table>
				</form>
			</cfoutput>

			<cfquery name="rsLista" datasource="#session.DSN#">
				select a.CTContid, b.CTlinea, a.CTAfecha, a.CTAanotacion
				from CTAnotaciones a 
                	inner join CTImagenes b
                    	on a.CTContid = b.CTContid
                        and a.Ecodigo = b.Ecodigo
                        and a.CTlinea = b.CTlinea
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Ecodigo#">
					and a.CTContid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CTContid#">
					<cfif isdefined("form.f_AFAfecha") and len(trim(form.f_AFAfecha)) >
						and CTAfecha >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedatetime(form.f_AFAfecha)#">
					</cfif>
					<cfif isdefined("form.f_AFAtexto") and len(trim(form.f_AFAtexto)) >
                                and upper(a.CTAanotacion) like  upper('%#form.f_AFAtexto#%')
					</cfif>
			</cfquery>



			<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" name="jos">
				<cfinvokeargument name="query" value="#rsLista#"/>
				<cfinvokeargument name="desplegar" value="CTAfecha,CTAanotacion"/>
				<cfinvokeargument name="etiquetas" value="#LB_Fecha#,#LB_Anotacion#"/>
				<cfinvokeargument name="formatos" value="D,S"/>
				<cfinvokeargument name="align" value="left,left"/>
				<cfinvokeargument name="formName" value="ListaActivos"/>
				<cfinvokeargument name="checkboxes" value="N"/>
				<cfinvokeargument name="keys" value="CTlinea"/>
				<cfinvokeargument name="ira" value="Contratos_frameAnotacion.cfm?CTContid=#url.CTContid#&Ecodigo=#Ecodigo#"/>
				<cfinvokeargument name="MaxRows" value="10"/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<cfinvokeargument name="PageIndex" value="1"/>
			</cfinvoke>
		</td>

		<td width="50%" valign="top">
			<cfoutput>
				<form name="formActivos" method="post" action="Contratos_frameAnotacion_sql.cfm" enctype="multipart/form-data">
					<!--- Se Obtiene el timestamp en modo CAMBIO --->
					<cfif modo NEQ 'ALTA'>
						<cfset ts = "">
						<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" returnvariable="ts">
							<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
						</cfinvoke>
						<input type="hidden" name="ts_rversion" value="#ts#">
						<input type="hidden" name="CTlinea" value="#form.CTlinea#">
					</cfif>
					<input type="hidden" name="CTContid" value="#url.CTContid#">

					<table width="100%" border="0" cellspacing="2" cellpadding="0">
						<tr>
							<td nowrap align="right"><strong>#LB_Anotacion#:</strong>&nbsp;</td>
							<td><input type="text" name="Anotacion" maxlength="80" size="57" tabindex="1" <cfif modo neq "ALTA">value="#rsForm.CTAanotacion#"</cfif>></td>
						</tr>

						<tr>
							<td nowrap align="right"><strong>#LB_ArchivoImagen#:</strong>&nbsp;</td>
							<td><input type="file" name="CTimagen" value="" onChange="javascript:extraeNombre(this.value);" size="40" tabindex="1"></td>
							<input type="hidden" name="CTnombreImagen" value="">
							<input type="hidden" name="CTnombre" value="">
						</tr>

						<tr>
							<td nowrap align="right"><strong>#LB_FechaAnotacion#</strong>&nbsp;</td>
							<td>
								<cfif modo neq "ALTA">
									<cfset fechaAnotacion = LSDateFormat(rsform.CTAfecha,'dd/mm/yyyy')>
								<cfelse>
									<cfset fechaAnotacion = LSDateFormat(now(),'dd/mm/yyyy')>
								</cfif>
								<cf_sifcalendario tabindex="1" form="formActivos" name="AFAfecha1" value="#fechaAnotacion#">
							</td>
						</tr>
                        


						<cfif modo NEQ 'ALTA'>

							<tr><td colspan="2" align="center">
							<cfquery datasource="#session.dsn#" name="rsImagen" maxrows="1">
									select
									a.CTContid, a.CTlinea,
									 a.CTimagen as logo, a.ts_rversion, a.CTextension as extension,
									 b.CTAanotacion,a.CTnombre
									from CTImagenes a   inner join CTAnotaciones b
									   on a.CTContid = b.CTContid 
									where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Ecodigo#">
									and a.CTContid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CTContid#">
									and a.CTlinea = 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.CTlinea#">
							  </cfquery>

                              
								<cfif rsImagen.recordcount and Len(rsImagen.logo) GT 1 >
						
										<table align="center" border="0">
										  <tr>
											<td align="center"><strong>#LB_Archivo#</strong></td>
											<td align="center"><strong>#LB_Descargar#</strong></td>
										</tr>
										<tr>
											<td align="center">#rsImagen.CTnombre#</td>
											<td align="center"><img alt='Descargar Archivo' border='0' style="cursor:pointer;" src='../../imagenes/RS_D.gif' onClick='javascript:sbDownload(<cfoutput>#rsImagen.CTContid#</cfoutput>, <cfoutput>#rsImagen.CTlinea#</cfoutput>);'/> </td>
                                            
										</tr>
										</table>
								<cfelse>
									<table width="50%" align="center" border="0" cellspacing="0" cellpadding="0">
										<tr>

											<td align="center">#LB_Mensaje#</td>

										</tr>
									</table>
								</cfif>
								</td></tr>
						</cfif>
                        <cfif (not isdefined('url.Consulta')) or url.Consulta NEQ 1 >
					
                            <tr><td colspan="2">&nbsp;</td></tr>
    
                            <tr>
                                <td colspan="2" align="center">
                                    <cf_botones modo="#modo#" tabindex="1">
                                </td>
                            </tr>
                    	</cfif>
                        
						<cfif isdefined('url.Consulta') and url.Consulta EQ 1>
                        <tr><td colspan="2">&nbsp;</td></tr>
    
                            <tr>
                                <td colspan="2" align="center">
                            <input name="btnRegresar" class="btnNormal" type="button" value="Regresar" onClick="javascript:location.href='../consultas/contrato-reimprimir.cfm'" >
                                </td>
                            </tr>
                        </cfif>
					</table>

					<!--- Campos ocultos para mantener el filtro (si existe)--->
					<cfif isdefined("form.f_AFAfecha") and len(trim(form.f_AFAfecha))>
						<input type="hidden" name="f_AFAfecha" value="#trim(form.f_AFAfecha)#">
					</cfif>
					<cfif isdefined("form.f_AFAtexto") and len(trim(form.f_AFAtexto))>
						<input type="hidden" name="f_AFAtexto" value="#trim(form.f_AFAtexto)#">
					</cfif>

				</form>
			</cfoutput>
		</td>
	</tr>
</table>

<cf_qforms form="formActivos">
<script language="JavaScript1.2" type="text/javascript">
	<cfoutput>
		objForm.Anotacion.description="#JSStringFormat('Anotación')#";
		objForm.AFAfecha1.description="#JSStringFormat('Fecha Anotación')#";
	</cfoutput>

	function habilitarValidacion() {
		objForm.Anotacion.required = true;
		objForm.AFAfecha1.required = true;
	}

	function deshabilitarValidacion() {
		objForm.Anotacion.required = false;
		objForm.AFAfecha1.required = false;
	}
	function extraeNombre(value){
	 var extensionTemp = "";
	  var nombreArchivo = "";

	 for(i=value.length-1;i>=0;i--)
	  {
		  if(value.charAt(i) == '.')
			{
			   break;
			}
		    else
		    {
		     extensionTemp = value.charAt(i)+extensionTemp ;
		    }
	   }

		document.formActivos.CTnombreImagen.value=extensionTemp;

	 for(i=value.length-1;i>=0;i--)
	  {
		  if(value.charAt(i) == '\\')
			{
			   break;
			}
		    else
		    {
		     nombreArchivo = value.charAt(i)+nombreArchivo ;
		    }
	   }

		document.formActivos.CTnombre.value=nombreArchivo;


	}
	function sbDownload(CTContid,CTlinea)
	{
		location.href = "Contratos_frameAnotacion_sql.cfm?CTContid=" + CTContid + "&CTlinea=" + CTlinea + "&Download";
	}
	objForm.Anotacion.obj.focus();
</script>
	<cf_web_portlet_end>
<cf_templatefooter>
