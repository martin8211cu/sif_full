<cf_templateheader title="Compras - Compradores por Centro Funcional		">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Compradores por Centro Funcional'>
        	<cfinclude template="../../Utiles/sifConcat.cfm">
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td colspan="3">
						<cfinclude template="../../portlets/pNavegacion.cfm"> 
					</td>
				</tr>
				
				<tr> 
					<td valign="top" width="50%">
						<cfquery name="rsCF" datasource="#session.DSN#">
							select distinct a.CFid, b.CFcodigo 
							from CMCompradoresCF a
							inner join CFuncional b
							on a.CFid = b.CFid
							and b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							order by b.CFcodigo
						</cfquery> 
						
						<cfoutput>
						<form style="margin:0;" name="filtro" method="post" action="CompradoresCFunc.cfm">
							<table width="100%" cellpadding="0" cellspacing="0" class="areaFiltro">
								<tr>
									<td align="right"><strong>Centro Funcional&nbsp;</strong></td>
									<td>
										<select name="fCFcodigo">
											<option value="">Todos</option>
											<cfloop query="rsCF">
												<option value="#rsCF.CFid#" <cfif isdefined("form.fCFcodigo") and len(trim(form.fCFcodigo)) and form.fCFcodigo eq rsCF.CFid>selected</cfif> >#rsCF.CFcodigo#</option>
											</cfloop>
										</select>
									</td>
									<td align="right"><strong>Comprador&nbsp;</strong></td>
									<td><input type="text" name="fCMCnombre" size="20" maxlength="40" value="<cfif isdefined("form.fCMCnombre") and len(trim(form.fCMCnombre))>#form.fCMCnombre#</cfif>"></td>
									<td><input type="submit" name="Filtrar" value="Filtrar"></td>
								</tr>
							</table>
						</form>
						</cfoutput>

						<cfset filtrob = "">
						<cfset filtroc = "">
						<cfset adicional = "">
						
						<cfif isdefined("form.fCMCnombre") and len(trim(form.fCMCnombre))>
							<cfset adicional = ", '#form.fCMCnombre#' as fCMCnombre ">
							<cfset filtrob = " and b.CMCnombre like '%#form.fCMCnombre#%'">
						</cfif>
						
						<cfif isdefined("form.fCFcodigo") and len(trim(form.fCFcodigo))>
							<cfset adicional = adicional & ", '#form.fCFcodigo#' as fCFcodigo ">
							<cfset filtroc = " and c.CFid = #form.fCFcodigo# " >
						</cfif>

						<cfquery name="rsLista" datasource="#session.DSN#">
							select a.CMCid, a.CFid, CMCnombre, 
								   c.CFcodigo #_Cat#'-'#_Cat#c.CFdescripcion as CFdescripcion,
								  '<img alt=''Eliminar'' border=''0'' src=''../../imagenes/Borrar01_S.gif'' onClick=''javascript:eliminar('#_Cat#<cf_dbfunction name="to_char" args="a.CFid">#_Cat#','#_Cat#<cf_dbfunction name="to_char" args="a.CMCid">#_Cat#');''>' as imagen
								  #preservesinglequotes(adicional)#
							from CMCompradoresCF a
							inner join CMCompradores b
								on a.CMCid = b.CMCid
									and b.Ecodigo=#session.Ecodigo# 
									#preservesinglequotes(filtrob)#
								  inner join CFuncional c
								  on a.CFid = c.CFid
								  and c.Ecodigo=#session.Ecodigo# 
								  #filtroc#
							order by CFcodigo
						</cfquery>

						<cfinvoke 
						 component="sif.Componentes.pListas"
						 method="pListaQuery"
						 returnvariable="pListaRet">
							<cfinvokeargument name="query" value="#rsLista#"/>
							<cfinvokeargument name="desplegar" value="CMCnombre, imagen"/>
							<cfinvokeargument name="etiquetas" value="Nombre, Eliminar"/>
							<cfinvokeargument name="formatos" value=""/>
							<cfinvokeargument name="align" value="left, center"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="checkboxes" value="N"/>
							<cfinvokeargument name="irA" value="CompradoresCFunc-sql.cfm"/>
							<cfinvokeargument name="keys" value="CFid,CMCid"/>
							<cfinvokeargument name="Cortes" value="CFdescripcion"/>
							<cfinvokeargument name="MaxRows" value="0"/>
							<cfinvokeargument name="showLink" value="false"/>
							<cfinvokeargument name="showEmptyListMsg" value="true"/>
						</cfinvoke>
					</td>
					<td valign="top" width="50%">
						<cfinclude template="CompradoresCFunc-form.cfm">
					</td>
				</tr>
			</table>
			
			<script type="text/javascript" language="javascript1.2">
				function eliminar(cfid, cmcid){
					if ( confirm('Desea eliminar el registro?') ) {
						document.lista.CFID.value = cfid;
						document.lista.CMCID.value = cmcid;
						document.lista.submit();
					}
				}
			</script>		

		<cf_web_portlet_end>	
	<cf_templatefooter>