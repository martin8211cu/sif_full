<!---    Combo de tipos de documentos --->
<cfquery name="rsTiposDoc" datasource="#session.DSN#">
	select  CPTcodigo, CPTdescripcion  
	from  CPTransacciones 
	where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by  CPTcodigo
</cfquery>

<script language="javascript1.2" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
<cf_templateheader title="Consulta de Transacciones ">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Consulta de Transacciones'>
			<cfinclude template="../../portlets/pNavegacionCM.cfm">
			<cfif isdefined("Form.EDIid") and len(trim(form.EDIid))>
				<!--- ********************************************** --->
				<!--- *****         AREA DEL REPORTE      ********** --->
				<!--- ********************************************** --->
				<cf_rhimprime datos="/sif/cm/consultas/RepAnulaTrans.cfm" paramsuri="&EDIid=#Form.EDIid#"> 
				<cfset title = "Consulta de Transacciones">
				<form name="form1">
					<table width="100%" border="0">
						<tr>
							<td><cfinclude template="RepAnulaTrans.cfm"></td>
						</tr>
						<tr>
							<td><cf_botones values="Regresar" functions="this.form.submit();"></td>
						</tr>
					</table>
					<input type="hidden" name="Estado" value="<cfoutput>#rsEncabezado.EDIestado#</cfoutput>">
				</form>				
			<cfelse>
				<!--- ***************************************************** --->
				<!--- *****         AREA DEL FILTROS Y LISTA     ********** --->
				<!--- ***************************************************** --->

				<!---****  Si los filtros vienen por URL (cambio de pagina) los carga en el form ---->
				<cfif isdefined("url.Ddocumentoini") and not isdefined("form.Ddocumentoini") >
					<cfset form.Ddocumentoini = url.Ddocumentoini >
				</cfif>
				<cfif isdefined("url.Ddocumentofin") and not isdefined("form.Ddocumentofin") >
					<cfset form.Ddocumentofin = url.Ddocumentofin >
				</cfif>
				<cfif isdefined("url.fechaini") and not isdefined("form.fechaini") >
					<cfset form.fechaini = url.fechaini >
				</cfif>
				<cfif isdefined("url.fechafin") and not isdefined("form.fechafin") >
					<cfset form.fechafin = url.fechafin >
				</cfif>
				<cfif isdefined("url.SNcodigo") and not isdefined("form.SNcodigo") >
					<cfset form.SNcodigo = url.SNcodigo >
				</cfif>
				<cfif isdefined("url.EDItipo") and not isdefined("form.EDItipo") >
					<cfset form.EDItipo = url.EDItipo >
				</cfif>
				<cfif isdefined("url.Estado") and not isdefined("form.Estado") >
					<cfset form.Estado = url.Estado >
				</cfif>				
				<!--- *********************** Asigna a la variable navegacion los filtros  *******************************--->
				<cfset navegacion = "">
				<cfif isdefined("form.Ddocumentoini") and len(trim(form.Ddocumentoini)) >
					<cfset navegacion = navegacion & "&Ddocumentoini=#form.Ddocumentoini#">
				</cfif>
				
				<cfif isdefined("form.Ddocumentofin") and len(trim(form.Ddocumentofin)) >
					<cfset navegacion = navegacion & "&Ddocumentofin=#form.Ddocumentofin#">
				</cfif>
	
				<cfif isdefined("Form.fechaini") and len(trim(form.fechaini)) >
					<cfset navegacion = navegacion & "&fechaini=#form.fechaini#">
				</cfif>
				
				<cfif isdefined("Form.fechafin") and len(trim(form.fechafin)) >
					<cfset navegacion = navegacion & "&fechafin=#form.fechafin#">
				</cfif>
	
				<cfif isdefined("Form.SNcodigo") and len(trim(form.SNcodigo))>
					<cfset navegacion = navegacion & "&SNcodigo=#form.SNcodigo#">
				</cfif>
				
				<cfif isdefined("Form.EDItipo") and len(trim(form.EDItipo))>
					<cfset navegacion = navegacion & "&EDItipo=#form.EDItipo#">
				</cfif>

				<cfif isdefined("Form.Estado") and len(trim(form.Estado))>
					<cfset navegacion = navegacion & "&Estado=#form.Estado#">
				</cfif>				
				<cfoutput>
				<form name="form1" action="">
					<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0" class="areaFiltro">
						<!--- ************************************************************************* --->		
						<tr> 
							<td width="15%" align="left" nowrap class="fileLabel" >
								<strong>&nbsp;Factura Inicial:&nbsp;</strong>
							</td>
							<td width="35%" align="left" nowrap class="fileLabel" >
								<input 	type="text" 
										name="Ddocumentoini" 
										size="20" 
										maxlength="20" 
										value="<cfif isdefined('form.Ddocumentoini')><cfoutput>#form.Ddocumentoini#</cfoutput></cfif>" 
										onBlur="" 
										onKeyUp="">
							</td>			
							<td width="15%" align="left" nowrap class="fileLabel" >
								<strong>Final:&nbsp;</strong>
							</td>
							<td colspan="2" width="35%" align="left" nowrap class="fileLabel" >
								<input 	type="text" 
										name="Ddocumentofin" 
										size="20" 
										maxlength="20" 
										value="<cfif isdefined('form.Ddocumentofin')><cfoutput>#form.Ddocumentofin#</cfoutput></cfif>" 
										onBlur="" 
										onKeyUp="">
							</td>							
						</tr>
						<!--- ************************************************************************* --->
						<tr> 
							<td align="left" class="fileLabel" nowrap >
								<strong>&nbsp;Fecha Inicial:&nbsp;</strong>
							</td>
							<td align="left" class="fileLabel" nowrap >
								<cfif isdefined('form.fechaini')>
									<cf_sifcalendario conexion="#session.DSN#" form="form1" name="fechaini" value="#form.fechaini#">
								<cfelse>
									<cf_sifcalendario conexion="#session.DSN#" form="form1" name="fechaini" value="">
								</cfif>
							</td>			
							<td align="left" class="fileLabel" nowrap >
								<strong>Final:&nbsp;</strong>
							</td>
							<td  colspan="2" align="left" class="fileLabel" nowrap >
								<cfif isdefined('form.fechafin')>
									<cf_sifcalendario conexion="#session.DSN#" form="form1" name="fechafin" value="#form.fechafin#">
								<cfelse>
									<cf_sifcalendario conexion="#session.DSN#" form="form1" name="fechafin" value="">
								</cfif>
							</td>							
						</tr>
						<!--- ************************************************************************* --->						
						<tr> 
							<td align="left" class="fileLabel" nowrap >
								<strong>&nbsp;Proveedor:&nbsp;</strong>
							</td>
							<td align="left" class="fileLabel" nowrap >
								<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))>
									<cf_sifsociosnegocios2 idquery="#form.SNcodigo#" form="form1">
								<cfelse>
									<cf_sifsociosnegocios2 form="form1">
								</cfif>
							</td>			
							<td align="left" class="fileLabel" nowrap >
								<strong>Tipo de Documento:&nbsp;</strong>
							</td>
						  <td  colspan="2" align="left" class="fileLabel" nowrap >
								<select name="EDItipo" tabindex="3">
									<option value="" >- No especificado -</option>
									<option value="N" <cfif isdefined("form.EDItipo") and len(trim(form.EDItipo)) and Form.EDItipo EQ 'N'>selected</cfif> >Nota de Crédito</option>
									<option value="F" <cfif isdefined("form.EDItipo") and len(trim(form.EDItipo)) and Form.EDItipo EQ 'F'>selected</cfif> >Factura</option>
									<option value="D" <cfif isdefined("form.EDItipo") and len(trim(form.EDItipo)) and Form.EDItipo EQ 'D'>selected</cfif> >Nota de Débito</option>
								</select>							
							</td>

						</tr>
						<!--- ************************************************************************* --->					
						<tr> 
							<td align="left" class="fileLabel" nowrap >
								<strong>&nbsp;Estado:&nbsp;</strong>
							</td>
						    <td  colspan="2" align="left" class="fileLabel" nowrap >
								<select name="Estado" tabindex="3">
									<option value="60" selected > Anuladas</option>
									<option value="10" <cfif isdefined("form.Estado") and len(trim(form.Estado)) and Form.Estado EQ '10'>selected</cfif> >Aplicadas</option>
									<option value="0"  <cfif isdefined("form.Estado") and len(trim(form.Estado)) and Form.Estado EQ '0'>selected</cfif> >Pendientes</option>				
								</select>							
							</td>
							<td align="left" class="fileLabel" nowrap >
								<input type="submit" name="btnFiltro"  value="Filtrar">		
							</td>					
						</tr>

					</table>
				</form>		
				</cfoutput>	
				<cfquery name="rsLista" datasource="#session.DSN#">
					select A.EDIid,Ddocumento,SNnombre, EDIfecha,Mnombre , 
					(select sum(DDItotallinea) from DDocumentosI B where A.EDIid  = B.EDIid  and A.Ecodigo = B.Ecodigo) as Monto,
					 case when A.EDItipo = 'N' then 'Nota de Crédito' when A.EDItipo = 'F' then 'Factura' when A.EDItipo = 'D' then 'Nota de Débito' end as tipo
					from EDocumentosI A
					inner join Monedas C 			
							on C.Ecodigo = A.Ecodigo 
							and C.Mcodigo = A.Mcodigo
					inner join SNegocios D 			
							on D.Ecodigo = A.Ecodigo 
							and D.SNcodigo = A.SNcodigo 
					where EDIestado = <cfif isdefined("form.Estado")><cfqueryparam cfsqltype="cf_sql_integer" value="#form.Estado#"><cfelse>60</cfif>
					and A.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					
					<cfif isdefined("form.Ddocumentoini") and len(trim(form.Ddocumentoini)) >
						and A.Ddocumento >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ddocumentoini#">
					</cfif>
					<cfif isdefined("form.Ddocumentofin") and len(trim(form.Ddocumentofin)) >
						and A.Ddocumento <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ddocumentofin#">
					</cfif>
					<cfif isdefined("form.fechaini") and len(trim(form.fechaini))>
						and A.EDIfecha >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fechaini)#">
					</cfif>				
					<cfif isdefined("form.fechafin") and len(trim(form.fechafin))>
						and A.EDIfecha <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fechafin)#">
					</cfif>		
					<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))>
						and A.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
					</cfif>
					<cfif isdefined("form.EDItipo") and len(trim(form.EDItipo))>
						and A.EDItipo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.EDItipo#">
					</cfif>					
					order by A.SNcodigo
				</cfquery>
				
				<cfinvoke 
						component="sif.Componentes.pListas"
						method="pListaQuery"
						returnvariable="pListaRet">
						<cfinvokeargument name="query" value="#rsLista#"/>
						<cfinvokeargument name="cortes" value="SNnombre"/>
						<cfinvokeargument name="desplegar" value="Ddocumento,tipo, EDIfecha,  Mnombre, Monto"/>
						<cfinvokeargument name="etiquetas" value="N&uacute;mero Factura, Tipo,Fecha , Moneda, Monto"/>
						<cfinvokeargument name="formatos" value="V, V, D, V, M"/>
						<cfinvokeargument name="align" value="left, left, center, left, right "/>
						<cfinvokeargument name="ajustar" value="N"/>
						<cfinvokeargument name="irA" value="AnulaTransaccion-lista.cfm"/>
						<cfinvokeargument name="showEmptyListMsg" value="true"/>
						<cfinvokeargument name="keys" value="EDIid"/>
						<cfinvokeargument name="navegacion" value="#navegacion#"/> 				
				</cfinvoke>
			</cfif>
			<script language='JavaScript' type='text/JavaScript' src='/cfmx/sif/js/qForms/qforms.js'></script>
			<script language='javascript' type='text/JavaScript' >
			<!--//
				<cfif isdefined("Regresar")>
					function funcRegresar(){
						location.href = "<cfoutput>#Regresar#</cfoutput>";
						return true;
					}
				</cfif>
			//-->
			</script>
		<cf_web_portlet_end>
	<cf_templatefooter>

