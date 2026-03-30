	<cfquery name="rsOficinas" datasource="#session.dsn#">
				select Ocodigo,Oficodigo,Odescripcion 
				from  Oficinas
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				order by Oficodigo
			</cfquery>			
			
<cfoutput>
<form action="rptActivosVU_sql.cfm" method="get" name="form1" style="margin:0px;">
	<table align="center" border="0" width="100%" cellpadding="0" cellspacing="0">
			<td valign="top" width="50%" align="left" >
				<table width="30%"  border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td>
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
			  		 <tr>
						<td><div align="left"><strong>Categor&iacute;a inicial:</strong></div></td>
						<td>
								<cfset valuesArray = ArrayNew(1)>
							<cfif isdefined("url.codigodesde")>
								<cfset ArrayAppend(valuesArray, url.codigodesde)>
							</cfif>
							<cfif isdefined("url.ACinicio")>
								<cfset ArrayAppend(valuesArray, url.ACinicio)>
							</cfif>
							<cfif isdefined("url.ACdescripciondesde")>							
								<cfset ArrayAppend(valuesArray, url.ACdescripciondesde)>
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
							<cfif isdefined("url.codigohasta")>
								<cfset ArrayAppend(valuesArrayB, url.codigohasta)>
							</cfif>
							<cfif isdefined("url.AChasta")>
								<cfset ArrayAppend(valuesArrayB, url.AChasta)>
							</cfif>
							<cfif isdefined("url.ACdescripcionhasta")>
								<cfset ArrayAppend(valuesArrayB, url.ACdescripcionhasta)>
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
                                      <option value="#Ocodigo#" <cfif isdefined("url.OficinaIni") and url.OficinaIni eq rsOficinas.Ocodigo>selected</cfif>>#Oficodigo#-#Odescripcion#</option>
                                    </cfloop>
                                 </select>
						</td>
						<td><div align="left"><strong>Final</strong></div></td>
						<td>
								 <select name="OficinaFin" tabindex="2">
                                    <option value="" selected></option>
                                    <cfloop query="rsOficinas">
                                      <option value="#Ocodigo#" <cfif isdefined("url.OficinaFin") and url.OficinaFin eq rsOficinas.Ocodigo>selected</cfif>>#Oficodigo#-#Odescripcion#</option>
                                    </cfloop>
                                 </select>
						</td>
					</tr>					
						
						
						
				</fieldset>
				<tr>
					<td align="left" colspan="7"><strong>Exportar a archivo</strong>
						<input type="checkbox" name="exportar" value="ok" /></td>
				</tr>
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

<script language="javascript" type="text/javascript">
	function Cambia(){
		//alert("Filtró por rango de Categoría");
		setReadOnly_form1_codigodesde(false);//para inhabilitar un conlis 
		setReadOnly_form1_codigohasta(false);
		limpiacodigodesde();//para limpiar un conlis
		limpiacodigohasta();
	}
	
	function Cambia2(){
		//alert("Filtró por rango de Clases a partir de una Categoría seleccionada");
		setReadOnly_form1_codigodesde(true);
		setReadOnly_form1_codigohasta(true);
		setReadOnly_form1_ACcodigo(false);
	}
	Cambia()
</script>
<cf_qforms form = 'form1'>
<script language="javascript" type="text/javascript">
	<!---objForm.codigodesde.required=true;
	objForm.codigodesde.description='Categoría Desde';
	objForm.codigohasta.required=true;
	objForm.codigohasta.description='Categoría Hasta';--->
</script>




