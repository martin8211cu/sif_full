<cf_templateheader title=" Inventario F&iacute;sico">
	

		<!--- valores del filtro por url --->
		<cfif isdefined("url.pageNum_lista") and not isdefined("form.pageNum_lista") >
			<cfset form.pageNum_lista = url.pageNum_lista >
		</cfif>
		<cfif isdefined("url.fAid") and not isdefined("form.fAid") >
			<cfset form.fAid = url.fAid >
		</cfif>
		<cfif isdefined("url.fDescripcion")and not isdefined("form.fDescripcion") >
			<cfset form.fDescripcion = url.fDescripcion >
		</cfif>
		<cfif isdefined("url.fEFfecha")and not isdefined("form.fEFfecha")>
			<cfset form.fEFfecha = url.fEFfecha >
		</cfif>
		
		<!--- navegacion --->
		<cfset navegacion = '' >
		<cfif isdefined("form.fAid") and len(trim(form.fAid)) >
			<cfset navegacion = navegacion & "&fAid=#form.fAid#" >
		</cfif>
		<cfif isdefined("form.fDescripcion") and len(trim(form.fDescripcion)) >
			<cfset navegacion = navegacion & "&fDescripcion=#form.fDescripcion#" >
		</cfif>
		<cfif isdefined("form.fEFfecha") and len(trim(form.fEFfecha)) >
			<cfset navegacion = navegacion & "&fEFfecha=#form.fEFfecha#" >
		</cfif>

		<cfquery name="rsLista" datasource="#session.DSN#">
			select a.EFid, a.Aid, b.Almcodigo, b.Bdescripcion, a.EFdescripcion, a.EFfecha 
			from  EFisico a
			
			inner join Almacen b
			on b.Ecodigo=a.Ecodigo
			and b.Aid=a.Aid
			
			<cfif isdefined("form.fAid") and len(trim(form.fAid))>
				and b.Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fAid#">
			</cfif>
			<cfif isdefined("form.fDescripcion") and len(trim(form.fDescripcion))>
				and upper(b.Bdescripcion) like '%#ucase(form.fDescripcion)#%'
			</cfif>
			inner join AResponsables c
           	  on b.Aid = c.Aid
           and c.Usucodigo = <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_integer" >  
           
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and a.EFestado=0
			  and a.Ecodigo = c.Ecodigo
			  <cfif isdefined("form.fEFfecha") and len(trim(form.fEFfecha))>
					and a.EFfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.fEFfecha)#">
			  </cfif>
			
			order by b.Almcodigo, b.Bdescripcion		
		</cfquery>
		
		<!--- almacen para el filtro --->
		<cfset IDalmacen = 0 >
		<cfif isdefined("form.fAid") and len(trim(form.fAid))>
			<cfset IDalmacen = form.fAid >
		</cfif>
		<!--- fecha para el filtro --->
		<cfset vFecha = "" >
		<cfif isdefined("form.fEFfecha") and len(trim(form.fEFfecha))>
			<cfset vFecha = form.fEFfecha >
		</cfif>

		<table width="100%" cellpadding="0" cellspacing="0">
			<tr><td>
				 <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Inventario F&iacute;sico'>
				 	<cfinclude template="../../portlets/pNavegacion.cfm">
					<form name="lista" method="post" action="inventarioFisico.cfm" style="margin:0;">
						<cfoutput>
						<input name="pageNum_lista" type="hidden" value="<cfif isdefined('form.pageNum_lista') and len(trim(form.pageNum_lista))>#form.pageNum_lista#<cfelse>1</cfif>">
						<table width="100%" cellpadding="1" cellspacing="0" class="areaFiltro">
							<tr>
								<td width="1%"><strong>Almac&eacute;n:</strong>&nbsp;</td>
								<td><cf_sifalmacen form="lista" Aid="fAid" id="#IDalmacen#"></td>
								<td width="1%"><strong>Descripci&oacute;n:</strong>&nbsp;</td>
								<td><input type="text" name="fDescripcion" size="40" maxlength="80" value="<cfif isdefined('form.fDescripcion')>#form.fDescripcion#</cfif>"></td>
								<td width="1%"><strong>Fecha:</strong>&nbsp;</td>
								<td><cf_sifcalendario form="lista" name="fEFfecha" value="#vFecha#" ></td>
								<td><input type="submit" class="btnNormal" name="btnFiltrar" value="Filtrar" onClick="javascript:document.lista.action='';"></td>
							</tr>
						</table>
						</cfoutput>
					
						<table width="100%" cellpadding="1" cellspacing="0">
							<tr>
								<td>
									<cfinvoke 
											component="sif.Componentes.pListas"
											method="pListaQuery"
											returnvariable="pListaRet">
										<cfinvokeargument name="query" value="#rsLista#"/>
										<cfinvokeargument name="desplegar" value="Almcodigo, Bdescripcion, EFfecha"/>
										<cfinvokeargument name="etiquetas" value="Almac&eacute;n, Descripci&oacute;n, Fecha"/>
										<cfinvokeargument name="formatos" value="V, V, D"/>
										<cfinvokeargument name="align" value="left, left, left"/>
										<cfinvokeargument name="ajustar" value="N"/>
										<cfinvokeargument name="checkboxes" value="S"/>
										<cfinvokeargument name="irA" value="inventarioFisico.cfm"/>
										<cfinvokeargument name="keys" value="EFid"/>
										<cfinvokeargument name="botones" value="Nuevo,Aplicar,Importar"/>
										<cfinvokeargument name="showEmptyListMsg" value="true"/>
										<cfinvokeargument name="formname" value="lista"/>
										<cfinvokeargument name="incluyeform" value="false"/>
										<cfinvokeargument name="navegacion" value="#navegacion#"/>
										<cfinvokeargument name="maxrows" value="25"/>
									</cfinvoke>
								</td>
							</tr>
						</table>
					</form>
				 <cf_web_portlet_end>
			 </td></tr>
		 </table>

		<script language="javascript1.2" type="text/javascript">
			function funcImportar(){
				location.href = "/cfmx/sif/iv/operacion/inventarioFisico-importar.cfm";
				return false;
			}

			function funcAplicar(){
				var mensaje = '';
	
				var continuar = false;
				if (document.lista.chk) {
					if (document.lista.chk.value) {
						continuar = document.lista.chk.checked;
					}
					else {
						for (var k = 0; k < document.lista.chk.length; k++) {
							if (document.lista.chk[k].checked) {
								continuar = true;
								break;
							}
						}
					}
					if (!continuar) { 
						alert('Se presentaron los siguientes errores:\n - Debe seleccionar al menos un documento para aplicar.'); 
						return false;
					}
				}

				if ( confirm('Desea aplicar los documentos seleccionados?') ){
					document.lista.action = 'inventarioFisico-sql.cfm';
					return true;
				}
				return false;
			}
		</script>


	<cf_templatefooter>