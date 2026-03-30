<cfinclude template="../../Utiles/sifConcat.cfm">
<cfif isdefined("url.CMSid") and not isdefined("form.CMSid")>
	<cfset form.CMSid = Url.CMSid>
</cfif>

<cfif isdefined("url.CFid") and not isdefined("form.CFid")>
	<cfset form.CFid = Url.CFid>
</cfif>

<!--- Query que indica si la empresa esta utilizando la interfaz de RH --->
<cfquery name="rsUsaRH" datasource="#session.DSN#">
	select 	Pvalor 
	from 	Parametros 
	where 	Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Pcodigo=520
</cfquery>

<cfquery name="rsSolicitante" datasource="#session.DSN#">
	select CMSnombre,CMScodigo 
	from CMSolicitantes
	where CMSid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CMSid#">
</cfquery>
<!--------a.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">----->

<cfoutput>
<table width="99%" align="center" border="0" cellspacing="0" cellpadding="2">
	<tr><td colspan="6" align="center" class="tituloAlterno"><strong>#session.enombre#</strong></td></tr>
	<tr><td colspan="6" nowrap>&nbsp;</td></tr>
	<tr><td colspan="6" align="center"><strong>Consulta de Datos de Solicitantes</strong></td></tr>
	<tr><td colspan="6" align="center"><strong>Fecha de la Consulta:&nbsp;</strong>#LSDateFormat(Now(),'dd/mm/yyyy')#&nbsp;<strong>Hora:&nbsp;</strong>#TimeFormat(Now(),'medium')#</td></tr>
	<tr><td colspan="6" nowrap>&nbsp;</td></tr>
	<tr><td colspan="6" ><strong>Solicitante:&nbsp; #rsSolicitante.CMScodigo# - #rsSolicitante.CMSnombre#</strong></td></tr>
	<tr><td colspan="6" >&nbsp;</td></tr>

	<tr>
		<td width="25%" nowrap  bgcolor="##999999" style="padding-left:5px; border-bottom: 1px solid black; border-top:1px solid black; border-left:1px solid black;"><strong>Ctro Funcional</strong></td>
		<td width="20%" nowrap  bgcolor="##999999" style="padding-left:5px; border-bottom: 1px solid black; border-top:1px solid black;"><strong>Responsable</strong></td>
		<td width="20%" nowrap  bgcolor="##999999" style="padding-left:5px; border-bottom: 1px solid black; border-top:1px solid black;"><strong>Tipo Solicitud</strong></td>
		<td width="10%" nowrap  bgcolor="##999999" style="padding-left:5px; border-bottom: 1px solid black; border-top:1px solid black;"><strong>Tipo Item</strong></td>
		<td width="25%" nowrap  bgcolor="##999999" style="padding-left:5px; border-bottom: 1px solid black; border-top:1px solid black; border-right:1px solid black;"><strong>Línea Especialización</strong></td>
	</tr>		
	
	<input type="hidden" name="CMSid"  value="">	
	<input type="hidden" name="CFid"  value="">	
	<input type="hidden" name="CFcodigo"  value="">			
	<input type="hidden" name="CFdescripcion"  value="">																							

	<cfif rsUsaRH.Pvalor EQ 'S'>
		<!--- Si esta integrado con RH --->
		<cfquery name="rsLista" datasource="#session.DSN#">
			select  b.CFcodigo, b.CFid, b.CFdescripcion, b.CFuresponsable,'#rsUsaRH.Pvalor#' as Pvalor, #form.CMSid# as CMSid,
					c.RHPdescripcion		
			from CMSolicitantesCF a
				inner join CFuncional b
					on a.CFid=b.CFid
					and b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				inner join RHPlazas c
					on c.RHPid = b.RHPid
					and c.Ecodigo = b.Ecodigo
			where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and a.CMSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMSid#">
			order by b.CFdescripcion
		</cfquery>						

		<cfset corte = ''>

		<cfif rsLista.recordcount EQ 0>
			<tr><td colspan="6" align="center" style="text-align:center"> -------------------  No hay registros  -------------------</td></tr>
		<cfelse>
			<cfloop query="rsLista">		
				<cfif currentRow mod 35 EQ 1>
					<cfif currentRow NEQ 1>
						<tr class="pageEnd"><td colspan="3">&nbsp;</td></tr>
					</cfif>
				</cfif>									
				<cfif corte neq rsLista.CFid>
					<tr>
						<td class="titulolistas" width="25%" nowrap style="padding-left:5px;border-bottom:1px solid black; border-left:1px solid black;border-right:1px solid black;"><strong>&nbsp;#rsLista.CFcodigo# - #rsLista.CFdescripcion#&nbsp;</strong></td>
						<td class="titulolistas" width="20%" nowrap style="padding-left:5px;border-bottom:1px solid black;border-right:1px solid black;">&nbsp;#rsLista.RHPdescripcion#</td>
						<td class="titulolistas" style="padding-left:5px;border-bottom:1px solid black; border-right:1px solid black;">&nbsp;</td>
						<td class="titulolistas" style="padding-left:5px;border-bottom:1px solid black; border-right:1px solid black;">&nbsp;</td>
						<td class="titulolistas" style="padding-left:5px;border-bottom:1px solid black; border-right:1px solid black;">&nbsp;</td>
					</tr>
					<!------------ Query de las lineas de especializacion por c/centro funcional -------------->
					<cfquery name="rsDatos" datasource="#session.DSN#">
						select  d.CMTSdescripcion,a.CCid, a.CMElinea, a.CFid,
								a.CMEtipo as Tipo, case a.CMEtipo when 'A' then Cdescripcion
								when 'S' then CCdescripcion
								when 'F' then j.ACdescripcion#_Cat#'/'#_Cat#k.ACdescripcion end as Descripcion
						 
						from  CMSolicitantes b
							inner join CMESolicitantes c
								on b.CMSid = c.CMSid
							
							inner join CMEspecializacionTSCF a
								on c.CMElinea = a.CMElinea
							
							inner join CMTiposSolicitud d
								on a.CMTScodigo = d.CMTScodigo
								
							-- Articulos
							left outer join Clasificaciones f
							on a.Ccodigo=f.Ccodigo
							and a.Ecodigo=f.Ecodigo
							and f.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
								  
							-- Conceptos
							left outer join CConceptos h
							on a.CCid=h.CCid
							and a.Ecodigo=h.Ecodigo
							
							-- Activos
							left outer join ACategoria j
							on a.ACcodigo=j.ACcodigo
							and a.Ecodigo=j.Ecodigo
							 
							left outer join AClasificacion k
							on a.ACcodigo=k.ACcodigo
							and a.ACid=k.ACid
							and a.Ecodigo=k.Ecodigo
							 
							where a.CFid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsLista.CFid#">
							and b.Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
							and b.CMSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMSid#">
							and c.CMElinea in (select CMElinea 
												from CMEspecializacionTSCF e
												where c.CMElinea = e.CMElinea )							
					</cfquery>
					<!--------------------------------------->
					<cfif rsDatos.recordcount EQ 0>
						<tr><td colspan="6" align="center" style="text-align:center; border-bottom:1px solid black; border-left:1px solid black; border-right:1px solid black;"> ----------  No hay Líneas de Especialización para este Centro Funcional  ----------</td></tr>
					<cfelse>			
						<cfloop query="rsDatos">
							<cfif currentRow mod 35 EQ 1>
								<cfif currentRow NEQ 1>
									<tr class="pageEnd"><td colspan="3">&nbsp;</td></tr>
								</cfif>
							</cfif>
							<tr>
								<td colspan="2" style="border-left:1px solid black; <cfif rsDatos.RecordCount eq rsDatos.CurrentRow>border-bottom:1px solid black;</cfif>" >&nbsp;</td>
								<td nowrap width="20%" style="padding-left:5px; border-bottom:1px solid black; border-right:1px solid black; border-left:1px solid black;">&nbsp;#rsDatos.CMTSdescripcion#&nbsp;</td>
								<cfif rsDatos.Tipo EQ 'A'>
									<td nowrap width="10%" style="padding-left:5px;border-bottom:1px solid black; border-right:1px solid black;">&nbsp;Artículo&nbsp;</td>							
								<cfelseif rsDatos.Tipo EQ 'F'>
									<td nowrap width="10%" style="padding-left:5px;border-bottom:1px solid black; border-right:1px solid black;">&nbsp;Activo&nbsp;</td>							
								<cfelse>
									<td nowrap width="10%" style="padding-left:5px;border-bottom:1px solid black; border-right:1px solid black;">&nbsp;Servicio&nbsp;</td>							
								</cfif>
								<td nowrap width="25%" style="padding-left:5px;border-bottom:1px solid black; border-right:1px solid black;">&nbsp;#rsDatos.Descripcion#&nbsp;</td>							
							</tr>					
						</cfloop>  <!----Fin del loop rsDatos --->
					</cfif> <!---Fin del if si hay datos en rsDatos ---> 										
				</cfif>	<!---Fin del if del corte por centro funcional --->
			  <cfset corte = rsLista.CFid>				
			</cfloop> <!--- Fin del loop de rsLista --->
		</cfif> <!---Fin del if si hay registros en rsLista --->
	</tr>	
	<tr><td>&nbsp;</td></tr>
	
<!------------------------------- Si NO esta integrado con RH ------------------------------------------->	
	<cfelse>
		<cfquery name="rsLista" datasource="#session.DSN#">
			select  b.CFcodigo, b.CFid, b.CFdescripcion, b.CFuresponsable,'#rsUsaRH.Pvalor#' as Pvalor, #form.CMSid# as CMSid,
			(select Pnombre#_Cat#' '#_Cat# Papellido1 
			from DatosPersonales x, Usuario y 
			where x.datos_personales=y.datos_personales and y.Usucodigo=b.CFuresponsable) as responsable
			from CMSolicitantesCF a
			inner join CFuncional b
			on a.CFid=b.CFid
			and b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			where a.CMSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMSid#">
			order by b.CFdescripcion
		</cfquery>

		<cfset corte = ''>

		<cfif rsLista.recordcount EQ 0>												
			<tr align="center"><td colspan="6" align="center" style="text-align:center"> -------------------  No hay registros  -------------------</td></tr>
		<cfelse>
			<cfloop query="rsLista">											
				<cfif corte neq rsLista.CFid>													
					<tr>
						<td class="titulolistas" width="25%" nowrap style="padding-left:5px;border-bottom:1px solid black; border-left:1px solid black;border-right:1px solid black;"><strong>&nbsp;#rsLista.CFcodigo# - #rsLista.CFdescripcion#&nbsp;</strong></td>
						<td class="titulolistas" width="20%" nowrap style="padding-left:5px;border-bottom:1px solid black;border-right:1px solid black;">&nbsp;#rsLista.responsable#</td>
						<td class="titulolistas" style="padding-left:5px;border-bottom:1px solid black; border-right:1px solid black;">&nbsp;</td>
						<td class="titulolistas" style="padding-left:5px;border-bottom:1px solid black; border-right:1px solid black;">&nbsp;</td>
						<td class="titulolistas" style="padding-left:5px;border-bottom:1px solid black; border-right:1px solid black;">&nbsp;</td>
					</tr>				
					<!------------ Query de las lineas de especializacion por c/centro funcional -------------->
					<cfquery name="rsDatos" datasource="#session.DSN#">
						select  d.CMTSdescripcion,a.CCid, a.CMElinea, a.CFid,
								a.CMEtipo as Tipo, case a.CMEtipo when 'A' then Cdescripcion
								when 'S' then CCdescripcion
								when 'F' then j.ACdescripcion#_Cat#'/'#_Cat#k.ACdescripcion end as Descripcion
						 
						from  CMSolicitantes b
							inner join CMESolicitantes c
								on b.CMSid = c.CMSid
							
							inner join CMEspecializacionTSCF a
								on c.CMElinea = a.CMElinea
							
							inner join CMTiposSolicitud d
								on a.CMTScodigo = d.CMTScodigo
								
							<!----- Articulos--->
							left outer join Clasificaciones f
							on a.Ccodigo=f.Ccodigo
							and a.Ecodigo=f.Ecodigo
							and f.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
								  
							<!----- Conceptos--->
							left outer join CConceptos h
							on a.CCid=h.CCid
							and a.Ecodigo=h.Ecodigo
							
							<!----- Activos--->
							left outer join ACategoria j
							on a.ACcodigo=j.ACcodigo
							and a.Ecodigo=j.Ecodigo
							 
							left outer join AClasificacion k
							on a.ACcodigo=k.ACcodigo
							and a.ACid=k.ACid
							and a.Ecodigo=k.Ecodigo
							 
							where a.CFid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsLista.CFid#">
							and b.Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
							and b.CMSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMSid#">
							and c.CMElinea in (select CMElinea 
												from CMEspecializacionTSCF e
												where c.CMElinea = e.CMElinea )							
					</cfquery>
					<!--------------------------------------->
					<cfif rsDatos.recordcount EQ 0>
						<tr><td colspan="6" align="center" style="text-align:center; border-bottom:1px solid black; border-left:1px solid black; border-right:1px solid black;"> ----------  No hay Líneas de Especialización para este Centro Funcional  ----------</td></tr>
					<cfelse>			
						<cfloop query="rsDatos">
							<cfif currentRow mod 35 EQ 1>
								<cfif currentRow NEQ 1>
									<tr class="pageEnd"><td colspan="3">&nbsp;</td></tr>
								</cfif>
							</cfif>
							<tr>
								<td colspan="2" style="border-left:1px solid black; <cfif rsDatos.RecordCount eq rsDatos.CurrentRow>border-bottom:1px solid black;</cfif>" >&nbsp;</td>
								<td nowrap width="20%" style="padding-left:5px; border-bottom:1px solid black; border-right:1px solid black; border-left:1px solid black;">&nbsp;#rsDatos.CMTSdescripcion#&nbsp;</td>
								<cfif rsDatos.Tipo EQ 'A'>
									<td nowrap width="10%" style="padding-left:5px;border-bottom:1px solid black; border-right:1px solid black;">&nbsp;Artículo&nbsp;</td>							
								<cfelseif rsDatos.Tipo EQ 'F'>
									<td nowrap width="10%" style="padding-left:5px;border-bottom:1px solid black; border-right:1px solid black;">&nbsp;Activo&nbsp;</td>							
								<cfelse>
									<td nowrap width="10%" style="padding-left:5px;border-bottom:1px solid black; border-right:1px solid black;">&nbsp;Servicio&nbsp;</td>							
								</cfif>
								<td nowrap width="25%" style="padding-left:5px;border-bottom:1px solid black; border-right:1px solid black;">&nbsp;#rsDatos.Descripcion#&nbsp;</td>							
							</tr>					
						</cfloop>  <!----Fin del loop rsDatos --->
					</cfif> <!---Fin del if si hay datos en rsDatos ---> 										
				</cfif>	<!---Fin del corte por centro funcional --->
				<cfset corte=rsLista.CFid>
			</cfloop> <!--- Fin del loop de rsLista --->
		</cfif> <!---Fin del if di hay registros en rsLista --->
<!---</tr>--->
	</cfif> <!---Fin del If si hay o no INTEGRACION CON RH --->
</table>
</cfoutput>

<script language='javascript' type='text/JavaScript' >
	function procesar(valor,CFid,codigo,descripcion) {
		document.form1.action = 'DatosSolicitanteTS-lista.cfm';
		document.form1.CMSid.value = valor;
		document.form1.CFid.value = CFid;
		document.form1.CFcodigo.value = codigo;
		document.form1.CFdescripcion.value = descripcion;
		document.form1.submit();
	}
</script>

<!---style="padding:3px; cursor:hand;" 
							onClick="javascript:procesar(#form.CMSid#,#rsLista.CFid#,'#JSStringFormat(rsLista.CFcodigo)#','#JSStringFormat(rsLista.CFdescripcion)#');" 
							class="<cfif rsLista.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>" 
							onmouseover = "style.backgroundColor='##E4E8F3';"
							onmouseout = "style.backgroundColor='<cfif  rsLista.CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';"> --->					
