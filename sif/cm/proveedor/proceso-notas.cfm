<cf_templatecss> 
<cfif isdefined("url.PCPid") and not isdefined("form.PCPid")>
	<cfset form.PCPid = url.PCPid >
</cfif>

<cfquery name="rsLista" datasource="sifpublica">
	select CMNid, PCPid, CMNtipo, CMNnota, CMNtel, CMNemail 
	from CMNotas 
	where PCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PCPid#">
</cfquery>
<cfif rsLista.recordCount eq 1>
	<cfset form.CMNid = rsLista.CMNid >
</cfif>

<cfif isdefined("form.CMNid") and len(trim(form.CMNid))>
	<cfquery name="rsNota" datasource="sifpublica">
		select CMNtipo, CMNresp, CMNnota, CMNtel, CMNemail
		from CMNotas 
		where PCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PCPid#">
		and CMNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMNid#">
	</cfquery>
</cfif>

<table width="100%" cellpadding="0" cellspacing="0" border="0">
	<cfif rsLista.recordCount gt 0>
		<cfif rsLista.recordCount gt 1>
			<tr>
				<td nowrap colspan="2"><strong>Lista de Notas asociadas al proceso de Compra</strong><hr size="1"></td>
			</tr>		
		</cfif>
		
		<tr>
			<cfif rsLista.recordCount gt 1>
				<td nowrap valign="top">
					<table width="100%">
						<tr>
							<td valign="top">
								<cfinvoke 
								 component="sif.Componentes.pListas" 
								 method="pListaQuery"
								 returnvariable="pListaRet">
									<cfinvokeargument name="query" value="#rsLista#"/>
									<cfinvokeargument name="desplegar" value="CMNtipo"/>
									<cfinvokeargument name="etiquetas" value="Nota"/>
									<cfinvokeargument name="formatos" value="S"/>
									<cfinvokeargument name="align" value="left"/>
									<cfinvokeargument name="ajustar" value="N"/>
									<cfinvokeargument name="checkboxes" value="N"/>
									<cfinvokeargument name="irA" value="proceso-notas.cfm"/>
									<cfinvokeargument name="keys" value="PCPid,CMNid"/>
								</cfinvoke>
							</td>
						</tr>	
					</table>
				</td>
			</cfif>	
			
			<cfoutput>
			<td align="center" width="60%" valign="top">
				<cfif isdefined("form.CMNid") and Len(trim(form.CMNid))>
					<table width="100%" cellpadding="2" cellspacing="0">
						<tr>
							<td width="1%"><strong>Tipo:</strong></td>
							<td>#rsNota.CMNtipo#</td>
						</tr>
						<tr>
							<td width="1%"><strong>Responsable:</strong></td>
							<td>#rsNota.CMNresp#</td>
						</tr>
						<tr>
							<td colspan="2"><strong>Texto de la Nota:</strong></td>
						</tr>
						
						<tr>
							<td  width="1%" nowrap colspan="2">
								<table width="100%" bgcolor="##F5F5F5" style="border-style:solid; border-width:1px; border-color:##000000">
									<tr><td>&nbsp;</td></tr>
									<tr><td>#rsNota.CMNnota#</td></tr>
									<tr><td>&nbsp;</td></tr>
								</table>
							</td>
						</tr>
						<tr><td align="right" colspan="2"><a href="javascript:cerrar()">Cerrar Ventana</a></td></tr>

					</table>
				<cfelseif rsLista.recordCount gt 1>
					<table width="100%" cellpadding="0" cellspacing="0" class="areaFiltro">
						<tr><td align="center"><b>Si desea ver el detalle de alguna nota, seleccionela de la lista a su izquierda.</b></td></tr>
					</table>
				</cfif>
			</td>
			</cfoutput>
			
		</tr>
	<cfelse>
		<tr><td align="center">El proceso de Compra no tiene Notas Asociadas</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td align="center"><input type="button" value="Cerrar" onClick="window.close();"></td></tr>
	</cfif>	
</table>
<script type="text/javascript" language="javascript1.2">
	function cerrar(){
		window.close();
	}
</script>
