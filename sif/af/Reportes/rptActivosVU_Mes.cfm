<cfset Regresar = "/sif/af/MenuConsultasAF.cfm">
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<cf_templateheader title="#nav__SPdescripcion#">
		<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
			<cfoutput>#pNavegacion#</cfoutput>
	
		<cfquery name="rsOficinas" datasource="#session.dsn#">
				select Ocodigo,Oficodigo,Odescripcion 
				from  Oficinas
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				order by Oficodigo
			</cfquery>			
<cfoutput>
<form action="rptActivosVU_sql.cfm" method="post" name="form1" style="margin:0px;">
	<table align="center" border="0" width="100%" cellpadding="0" cellspacing="0">
		<td valign="top" width="50%" align="left" >
			<table width="100%"  border="0" cellspacing="10" cellpadding="10">
				<tr>
					<td align="left" nowrap="nowrap">
						<cf_web_portlet_start border="true" titulo="Activos" skin="info1">
						<div align="center">
			  				<p align="justify">En &eacute;ste reporte se muestra la informaci&oacute;n referente a los Activos cuya Vida Útil sea diferente a la de la Categoría-Clase. </p>
						</div>
						<cf_web_portlet_end> 
					</td>
				</tr>
		  </table>
		</td>
			
		<td valign="top" width="60%" align="left">
			<table width="100%" border="0">
				<tr>&nbsp;</tr>
				 <tr>
					<td><div align="left"><strong>Categor&iacute;a inicial:</strong></div></td>
					<td>
						<cfset valuesArray = ArrayNew(1)>
							<cfif isdefined("form.codigodesde")>
								<cfset ArrayAppend(valuesArray, form.codigodesde)>
							</cfif>
							<cfif isdefined("form.ACinicio")>
								<cfset ArrayAppend(valuesArray, form.ACinicio)>
							</cfif>
							<cfif isdefined("form.ACdescripciondesde")>							
								<cfset ArrayAppend(valuesArray, form.ACdescripciondesde)>
							</cfif>
								<cf_conlis
									campos="codigodesde, ACinicio, ACdescripciondesde"
									desplegables="N,S,S"
									modificables="N,S,N"
									size="0,10,40"
									title="Lista de Categor&iacute;as"
									valuesArray="#valuesArray#" 
									tabla="ACategoria"
									columnas="ACcodigo as codigodesde, ACcodigodesc as ACinicio, ACdescripcion as ACdescripciondesde"
									filtro="Ecodigo=#SESSION.ECODIGO# order by ACcodigodesc"
									desplegar="ACinicio, ACdescripciondesde"
									filtrar_por="ACcodigodesc, ACdescripcion"
									etiquetas="Código, Descripción"
									formatos="S,S"
									align="left,left"
									asignar="codigodesde, ACinicio, ACdescripciondesde"
									asignarformatos="S, S, S"
									showEmptyListMsg="true"
									EmptyListMsg="-- No se encontrarón Categor&iacute;as --"
									tabindex="1">	
						</td>
						<td><div align="left"><strong>Final</strong></div></td>
						<td><cfset valuesArrayB = ArrayNew(1)>
							<cfif isdefined("form.codigohasta")>
								<cfset ArrayAppend(valuesArrayB, form.codigohasta)>
							</cfif>
							<cfif isdefined("form.AChasta")>
								<cfset ArrayAppend(valuesArrayB, form.AChasta)>
							</cfif>
							<cfif isdefined("form.ACdescripcionhasta")>
								<cfset ArrayAppend(valuesArrayB, form.ACdescripcionhasta)>
							</cfif>
								<cf_conlis
									campos="codigohasta, AChasta, ACdescripcionhasta"
									desplegables="N,S,S"
									modificables="N,S,N"
									size="0,10,40"
									title="Lista de Categor&iacute;as"
									valuesArray="#valuesArrayB#" 
									tabla="ACategoria"
									columnas="ACcodigo as codigohasta, ACcodigodesc as AChasta, ACdescripcion as ACdescripcionhasta"
									filtro="Ecodigo=#SESSION.ECODIGO# order by ACcodigodesc"
									desplegar="AChasta, ACdescripcionhasta"
									filtrar_por="ACcodigodesc, ACdescripcion"
									etiquetas="Código, Descripción"
									formatos="S,S"
									align="left,left"
									asignar="codigohasta, AChasta, ACdescripcionhasta"
									asignarformatos="S, S, S"
									showEmptyListMsg="true"
									EmptyListMsg="-- No se encontrarón Categor&iacute;as --"
									tabindex="1">			
							</td>
						</tr>
					  <tr>
						<td><div align="left"><strong>Oficina inicial:</strong></div></td>
						<td>
							 <select name="OficinaIni" tabindex="2">
                                 <option value="" selected></option>
                                    <cfloop query="rsOficinas">
                                      <option value="#Ocodigo#" <cfif isdefined("form.OficinaIni") and form.OficinaIni eq rsOficinas.Ocodigo>selected</cfif>>#Oficodigo#-#Odescripcion#</option>
                                    </cfloop>
                                </select>
						</td>
						<td><div align="left"><strong>Final</strong></div></td>
						<td>
							 <select name="OficinaFin" tabindex="2">
                                 <option value="" selected></option>
                        	         <cfloop query="rsOficinas">
                            	        <option value="#Ocodigo#" <cfif isdefined("form.OficinaFin") and form.OficinaFin eq rsOficinas.Ocodigo>selected</cfif>>#Oficodigo#-#Odescripcion#</option>
                                	 </cfloop>
                               </select>
						</td>
					</tr>					
				</fieldset>
					<tr>
						<td colspan="7">
							<cf_botones values="Consultar,Limpiar" tabindex="1">
						</td>
					</tr>
					</tr>
				</table>
			</table>
		</table>	
	</form>
	</cfoutput>
<cf_web_portlet_end>
<cf_templatefooter>