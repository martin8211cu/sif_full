<!--- ------
	Modificado por: Ana Villavicencio
	Fecha de modificación: 20 de mayo del 2005
	Motivo:	corrección de nombre en la llamada de un componente, problema con mayusculas y minusculas que se presenta en servidores linux.
	Linea:  56 DBUtils --> DButils
-------- --->
<cfif isdefined('url.Pagina')>
	<cfset form.Pagina = url.Pagina>
</cfif>
<cfif isdefined('url.Filtro_CDIdentificacion') and LEN(TRIM(url.Filtro_CDIdentificacion))>
	<cfset form.Filtro_CDIdentificacion=url.Filtro_CDIdentificacion>
</cfif>
<cfif isdefined('url.Filtro_CDnombre') and LEN(TRIM(url.Filtro_CDnombre))>
	<cfset form.Filtro_CDnombre=url.Filtro_CDnombre>
</cfif>
<cfif isdefined('url.Filtro_rotulo') and LEN(TRIM(url.Filtro_rotulo))>
	<cfset form.Filtro_rotulo=url.Filtro_rotulo>
</cfif>
<cfif IsDefined('url.CDid')><cfset form.CDid=url.CDid></cfif>
<cfset params = ''>
<cfset navegacion = ''>
<cfif isdefined('form.Pagina')>
	<cfset params = params & '&Pagina=#form.Pagina#'>
	<cfset navegacion = navegacion & '&Pagina=#form.Pagina#'>
</cfif>
<cfif isdefined('form.Filtro_CDIdentificacion') and LEN(TRIM(form.Filtro_CDIdentificacion))>
	<cfset params = params & '&Filtro_CDIdentificacion=#form.Filtro_CDIdentificacion#'>
	<cfset navegacion = navegacion & '&Filtro_CDIdentificacion=#form.Filtro_CDIdentificacion#'>
</cfif>
<cfif isdefined('form.Filtro_CDnombre') and LEN(TRIM(form.Filtro_CDnombre))>
	<cfset params = params & '&Filtro_CDnombre=#form.Filtro_CDnombre#'>
	<cfset navegacion = navegacion & '&Filtro_CDnombre=#form.Filtro_CDnombre#'>
</cfif>
<cfif isdefined('form.Filtro_rotulo') and LEN(TRIM(form.Filtro_rotulo))>
	<cfset params = params & '&Filtro_rotulo=#form.Filtro_rotulo#'>
	<cfset navegacion = navegacion & '&Filtro_rotulo=#form.Filtro_rotulo#'>
</cfif>
<cfif IsDefined('form.CDid')>
	<cfset navegacion = navegacion & '&CDid=#form.CDid#'>
</cfif>

<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<cf_templateheader title="#nav__SPdescripcion#">
		<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
			<cfoutput>#pNavegacion#</cfoutput>
			
			<cfparam name="form.CDid" type="numeric">
			<cfparam name="form.TDid" type="numeric" default="0">
			<cfparam name="form.CDDid" type="numeric" default="0">
			
			
			<cfquery name="rsClienteDetallista" datasource="#Session.DSN#" >
				Select CEcodigo ,CDid ,CDTid , CDactivo,
					case when CDactivo = 'P' then 'En Proceso' when CDactivo = 'A' then 'Aprobado' when CDactivo = 'R' then 'Rechazado' when CDactivo = 'I' then 'Inactivo' else 'No definido' end as rotulo, 
					
					CDidentificacion ,CDnombre ,CDapellido1 ,CDapellido2 ,CDdireccion1 ,CDdireccion2 ,CDpais, CDciudad  ,
					CDestado ,CDcodPostal ,CDoficina ,CDcasa ,CDcelular ,CDfax ,CDemail ,CDcivil ,CDfechanac ,CDingreso ,CDsexo, CDtrabajo ,CDantiguedad ,
					CDvivienda ,CDrefcredito ,CDrefbancaria ,CDestudios, CDdependientes, ts_rversion 
				from ClienteDetallista
				where CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.CEcodigo#">
				and CDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CDid#" >		
			</cfquery>
			<cfquery name="documentos" datasource="#session.dsn#">
				select a.CDid, a.TDid, a.CDDid, a.CDDfecha, b.TDdescripcion, a.CDDvalidohasta
				<cfif isdefined('form.Pagina')>
					,#form.Pagina# as Pagina
				</cfif>
				<cfif isdefined('form.Filtro_CDIdentificacion') and LEN(TRIM(form.Filtro_CDIdentificacion))>
					,'#form.Filtro_CDIdentificacion#' as Filtro_CDIdentificacion
				</cfif>
				<cfif isdefined('form.Filtro_CDnombre') and LEN(TRIM(form.Filtro_CDnombre))>
					,'#form.Filtro_CDnombre#' as Filtro_CDnombre
				</cfif>
				<cfif isdefined('form.Filtro_rotulo') and LEN(TRIM(form.Filtro_rotulo))>
					,'#form.Filtro_rotulo#' as Filtro_rotulo
				</cfif>

				from ClienteDetallistaDoc a
					join ClienteDetallistaTipoDoc b
						on a.CEcodigo = b.CEcodigo
						and a.TDid = b.TDid
				where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.CEcodigo#">
				and a.CDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CDid#" >		  
				order by a.CDDfecha, b.TDdescripcion, a.CDDvalidohasta
			</cfquery>
			
			<cfquery name="tipo_doc" datasource="#session.dsn#">
				select TDid, TDdescripcion from ClienteDetallistaTipoDoc
				where CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.CEcodigo#">
				order by TDdescripcion
			</cfquery>
			
			<cfquery name="data" datasource="#session.dsn#">
				select *
				from ClienteDetallistaDoc
				where CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.CEcodigo#">
				  and CDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CDid#" >		
				  and TDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TDid#" >		
				  and CDDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CDDid#" >
			</cfquery>
			<cfinvoke component="sif.Componentes.DButils" method="toTimestamp" arTimeStamp='#data.ts_rversion#' returnvariable="ts" />
			<table width="100%"  align="center" cellpadding="0" cellspacing="0">
				<tr><td colspan="2">&nbsp;</td></tr>
				<tr> 
					<td colspan="2" align="center">									
						<strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">
							Registro de Documentos
						</strong>
					</td>
				</tr>	
				<tr> 
					<td colspan="2" align="center">
						<font size="2">
							<strong> Cliente: </strong><cfoutput>#rsClienteDetallista.CDidentificacion# &nbsp; - &nbsp; #rsClienteDetallista.CDnombre# &nbsp;#rsClienteDetallista.CDapellido1# &nbsp;#rsClienteDetallista.CDapellido2# </cfoutput>
					  </font>
				  </td>
				</tr>
				<tr><td colspan="2">&nbsp;</td></tr>
				<tr>
					<td width="31%" align="center" valign="top">
						<cfparam name="form.Pagina" default="1">
						<cfparam name="form.MaxRows" default="15">
						<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" 
							query="#documentos#"
							desplegar="CDDfecha, TDdescripcion, CDDvalidohasta"
							etiquetas="Fecha de registro, Tipo de Documento, Válido hasta"
							formatos="D,S,D"
							align="left,left,left"
							irA="Documentos.cfm"
							keys="CDid,TDid,CDDid"
							MaxRows="#form.MaxRows	#"
							showEmptyListMsg="true"
							totales="total"
							PageIndex="2"
							navegacion="#navegacion#">
						</cfinvoke>
					</td>
	                <td width="69%" align="center" valign="top">
						<form action="Documentos-sql.cfm" enctype="multipart/form-data" method="post" name="form1">
							<cfoutput>
								<cfif isdefined('form.Pagina')>
									<input name="Pagina" type="hidden" value="#form.Pagina#" tabindex="-1">
								</cfif>
								<cfif isdefined('form.Filtro_CDIdentificacion') and LEN(TRIM(form.Filtro_CDIdentificacion))>
									<input name="Filtro_CDIdentificacion" type="hidden" value="#form.Filtro_CDIdentificacion#" tabindex="-1">
								</cfif>
								<cfif isdefined('form.Filtro_CDnombre') and LEN(TRIM(form.Filtro_CDnombre))>
									<input name="Filtro_CDnombre" type="hidden" value="#form.Filtro_CDnombre#" tabindex="-1	">
								</cfif>
								<cfif isdefined('form.Filtro_rotulo') and LEN(TRIM(form.Filtro_rotulo))>
									<input name="Filtro_rotulo" type="hidden" value="#form.Filtro_rotulo#" tabindex="-1">
								</cfif>
								<input type="hidden" name="CDid" value="#form.CDid#">
								<input type="hidden" name="CDDid" value="#form.CDDid#">
							</cfoutput>
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
                            	<tr><td colspan="3" class="subTitulo">Registrar Nuevo Documento </td></tr>
                                <tr><td colspan="3">&nbsp;</td></tr>
                                <tr>
									<td colspan="2">&nbsp;</td>
                                  	<td>Tipo de documento </td>
                                </tr>
                                <tr>
                                	<td colspan="2">&nbsp;</td>
                                  	<td>
										<select name="TDid" id="TDid" tabindex="1">
                                    		<cfoutput query="tipo_doc">
                                      		<option value="#TDid#" <cfif tipo_doc.TDid is form.TDid>selected</cfif>>#HTMLEditFormat(tipo_doc.TDdescripcion)#</option>
                                    		</cfoutput>
                                  		</select>
									</td>
                                </tr>
								<cfif form.CDDid is 0>
									<tr>
										<td>&nbsp;</td><td>&nbsp;</td>
										<td>Ubicaci&oacute;n del documento digitalizado / escaneado</td>
									</tr>
									<tr>
										<td>&nbsp;</td><td>&nbsp;</td>
										<td><input type="file" name="CDDdocumento" onChange="preview_docu(this)" tabindex="1"></td>
									</tr>
								</cfif>
                                <tr>
                                  	<td>&nbsp;</td><td>&nbsp;</td>
                                  	<td>Vista previa </td>
                                </tr>
                                <tr>
                                  	<td>&nbsp;</td><td>&nbsp;</td>
                                 	<td>
										<cfset image_src = 'blank.gif'>
										<cfif form.TDid>
											<cfset image_src = 'doc_blob.cfm?CDid=#URLEncodedFormat(form.CDid)#&amp;TDid=#URLEncodedFormat(form.TDid)#&amp;CDDid=#URLEncodedFormat(form.CDDid)#&amp;ts=#ts#'>
										</cfif>
										<cfoutput>
											<img onClick="popup_doc(this.src)" src="#image_src#" id="img_preview" width="240" height="240" style="border:1px solid gray;cursor:pointer">
										</cfoutput>
									</td>
                                </tr>
                                <tr><td colspan="3">&nbsp;</td></tr>
                                <tr>
									<cfset modo='ALTA'>
								  	<cfif form.TDid><cfset modo='CAMBIO'></cfif>
								  	<td>&nbsp;</td><td>&nbsp;</td>
                                  	<td nowrap align="center">
										<cf_botones modo="#modo#" include="Regresar,AprobarCliente" includevalues="Regresar,Aprobaci&oacute;n de clientes &gt;&gt;" tabindex="1">
									</td>
								</tr>
								<!--- <tr>
									<td colspan="2">&nbsp;</td>
									<td>
										<input type="button" onClick="funcAprobarCliente()" value="Aprobaci&oacute;n de clientes &gt;&gt;">
									</td>
								</tr> --->
                                <tr><td colspan="3">&nbsp;</td>
                             	</tr>
                      		</table>
						</form>
					</td>
	  			</tr>	
			</table>
			<cfif modo EQ 'ALTA'>
			<cf_qforms>
				<cf_qformsRequiredField name="CDDdocumento" description="Ubicación del documento">
				<cf_qformsRequiredField name="TDid" description="Tipo de Documentos">
			</cf_qforms>
			</cfif>
			<script type="text/javascript">
			<!--
				function preview_docu (fileobj) {
					var imagen = document.all ? document.all.img_preview : document.getElementById('img_preview');
					imagen.src = fileobj.value;
				}
				function funcRegresar() {
					<cfoutput>
						location.href = 'DatosClientes.cfm?CDid=#URLEncodedFormat(form.CDid)##params#';
						return false;
					</cfoutput>
				}
				function funcAprobarCliente(){
					<cfoutput>
						location.href = 'AprobarCliente.cfm?CDid=#URLEncodedFormat(form.CDid)##params#';
						return false;
					</cfoutput>
				}
				
				
				var popUpWin = 0;
				function closePopUp(){
					if(popUpWin) {
						if(!popUpWin.closed) popUpWin.close();
						popUpWin = null;
					}
				}
				function popUpWindow(URLStr, left, top, width, height)
				{
					closePopUp();
					popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+',top='+top+',screenX='+left+',screenY='+top);
					window.onfocus = closePopUp;
				}
				function popup_doc(src) {
					if (src.indexOf('blank.gif') == -1)
						popUpWindow(src.replace('doc_blob','doc_show'), 300,150,400,400);
				}
			//-->
			</script>
		<cf_web_portlet_end>
	<cf_templatefooter>
