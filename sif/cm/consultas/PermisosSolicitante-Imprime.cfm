<cfinclude template="../../Utiles/sifConcat.cfm">
<cfif isdefined("url.CMScodigoD") and len(trim(url.CMScodigoD)) and not isdefined("form.CMScodigoD") >
	<cfset form.CMScodigoD = url.CMScodigoD >
</cfif>
<cfif (isdefined("url.CMScodigoH") and len(trim(url.CMScodigoH)))  and not isdefined("form.CMScodigoH")>
	<cfset form.CMScodigoH = url.CMScodigoH >
</cfif>

<!--- Asigna a la variable navegacion los filtros  --->
<cfset navegacion = "">
<cfif isdefined("form.CMScodigoD") and len(trim(form.CMScodigoD)) >
	<cfset navegacion = navegacion & "&CMScodigoD=#form.CMScodigoD#">
</cfif>

<cfif isdefined("form.CMScodigoH") and len(trim(form.CMScodigoH)) >
	<cfset navegacion = navegacion & "&CMScodigoH=#form.CMScodigoH#">
</cfif>

<cfif isdefined("url.fCFcodigoD") and not isdefined("form.fCFcodigoD")>
	<cfset form.fCFcodigoD = url.fCFcodigoD>
</cfif>
<cfif isdefined("url.fCFcodigoH") and not isdefined("form.fCFcodigoH")>
	<cfset form.fCFcodigoH = url.fCFcodigoH>
</cfif>


<!--- Query que indica si la empresa esta utilizando la interfaz de RH --->
<cfquery name="rsUsaRH" datasource="#session.DSN#">
	select 	Pvalor 
	from 	Parametros 
	where 	Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Pcodigo=520
</cfquery>
	
<!--- Query de los datos del solicitante si hay integracion o no ---->
<cfif rsUsaRH.Pvalor EQ 'S'>
	<cfquery name="rsSolIntegracion" datasource="#session.DSN#">
		select 	a.DEid, a.DEidentificacion, a.DEnombre#_Cat#' '#_Cat#a.DEapellido1#_Cat#' '#_Cat#a.DEapellido2 as Apellidos, 
				a.DEdireccion, a.DEtelefono1, a.DEtelefono2, a.DEemail, 
				b.CMSid, b.CMScodigo
		from DatosEmpleado a
				inner join CMSolicitantes b
					on a.DEid = b.DEid
					and a.Ecodigo = b.Ecodigo
				left outer join CFuncional c
				   on b.Ecodigo = c.Ecodigo
				   and b.CFid = c.CFid
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							
			<cfif isdefined("form.CMScodigoD") and len(trim(form.CMScodigoD)) and (isdefined("form.CMScodigoH") and len(trim(form.CMScodigoH))) >
				<cfif form.CMScodigoD  GT form.CMScodigoH >
					and b.CMScodigo  between <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CMScodigoH#">
					and <cfqueryparam cfsqltype="cf_sql_char" value="#form.CMScodigoD#">
				<cfelseif form.CMScodigoD  EQ form.CMScodigoH >
					and b.CMScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CMScodigoD#">
				<cfelse>
					and b.CMScodigo between <cfqueryparam cfsqltype="cf_sql_char" value="#form.CMScodigoD#">
					and <cfqueryparam cfsqltype="cf_sql_char" value="#form.CMScodigoH#">
				</cfif>
			</cfif>
			
			<cfif isdefined("form.CMScodigoD") and len(trim(form.CMScodigoD)) and (not isdefined("form.CMScodigoH") and not len(trim(form.CMScodigoH)))>
					and b.CMScodigo >= <cfqueryparam cfsqltype="cf_sql_char" value="#form.CMScodigoD#">
			</cfif>
	
			<cfif isdefined("form.CMScodigoH") and len(trim(form.CMScodigoH)) and (not isdefined("form.CMScodigoD") and not len(trim(form.CMScodigoD)))>
					and b.CMScodigo <= <cfqueryparam cfsqltype="cf_sql_char" value="#form.CMScodigoH#">
			</cfif>
			
			<cfif isdefined("Form.fCFcodigoD") and len(trim(Form.fCFcodigoD)) and isdefined("Form.fCFcodigoH") and len(trim(Form.fCFcodigoH))>
				and upper(b.CFcodigo) between upper('#Form.fCFcodigoD#') and
				upper('#Form.fCFcodigoH#')
			<cfelseif isdefined("Form.fCFcodigoD") and len(trim(Form.fCFcodigoD)) >
				and upper(b.CFcodigo) >= upper('#Form.fCFcodigoD#') 
			<cfelseif isdefined("Form.fCFcodigoH") and  len(trim(Form.fCFcodigoH))>
				and upper(b.CFcodigo) <= upper('#Form.fCFcodigoH#') 
			</cfif>


		</cfquery>
		
		
<!------------------------------------- Si NO hay integracion ------------------------------------------->
<cfelse>
	<cfquery name="rsSNIntegracion" datasource="#session.DSN#">
		select a.CMSid, a.CMScodigo,a.CMSnombre , c.CFdescripcion
		from CMSolicitantes a
		left outer join CFuncional c
				   on a.Ecodigo = c.Ecodigo
				   and a.CFid = c.CFid
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							
		<cfif isdefined("form.CMScodigoD") and len(trim(form.CMScodigoD)) and (isdefined("form.CMScodigoH") and len(trim(form.CMScodigoH))) >
			<cfif form.CMScodigoD  GT form.CMScodigoH >
				and a.CMScodigo  between <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CMScodigoH#">
				and <cfqueryparam cfsqltype="cf_sql_char" value="#form.CMScodigoD#">
			<cfelseif form.CMScodigoD  EQ form.CMScodigoH >
				and a.CMScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CMScodigoD#">
			<cfelse>
				and a.CMScodigo between <cfqueryparam cfsqltype="cf_sql_char" value="#form.CMScodigoD#">
				and <cfqueryparam cfsqltype="cf_sql_char" value="#form.CMScodigoH#">
			</cfif>
		</cfif>
							
		<cfif isdefined("form.CMScodigoD") and len(trim(form.CMScodigoD))  and  (not isdefined("form.CMScodigoH"))>
			and a.CMScodigo >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CMScodigoD#">									
		</cfif>
		
		<cfif isdefined("form.CMScodigoH") and len(trim(form.CMScodigoH))  and  (not isdefined("form.CMScodigoD"))>
			and a.CMScodigo <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CMScodigoH#">									
		</cfif>
		
		<cfif isdefined("Form.fCFcodigoD") and len(trim(Form.fCFcodigoD)) and isdefined("Form.fCFcodigoH") and len(trim(Form.fCFcodigoH))>
			and upper(c.CFcodigo) between upper('#Form.fCFcodigoD#') and
			upper('#Form.fCFcodigoH#')
		<cfelseif isdefined("Form.fCFcodigoD") and len(trim(Form.fCFcodigoD)) >
			and upper(c.CFcodigo) >= upper('#Form.fCFcodigoD#') 
		<cfelseif isdefined("Form.fCFcodigoH") and  len(trim(Form.fCFcodigoH))>
			and upper(c.CFcodigo) <= upper('#Form.fCFcodigoH#') 
		</cfif>
		

		
	</cfquery>
	<cfif isdefined("rsSNIntegracion") and rsSNIntegracion.RecordCount NEQ 0>
		<cfset rsCMSid = ValueList(rsSNIntegracion.CMSid)>
	<cfelse>
		<cfset rsCMSid = 0>
	</cfif>
	
</cfif>

<cfoutput>
<!------------------------- Pintado del reporte ------------------------------------>
<!----- Pintado Encabezado ----->
<table width="99%" align="center" border="0" cellspacing="0" cellpadding="2">
	<tr><td colspan="5" align="center" class="tituloAlterno"><strong>#session.enombre#</strong></td></tr>
	<tr><td colspan="5" nowrap>&nbsp;</td></tr>
	<tr><td colspan="5" align="center"><strong>Consulta de Permisos Por Solicitante</strong></td></tr>
	<tr><td colspan="5" align="center"><strong>Fecha de la Consulta:&nbsp;</strong>#LSDateFormat(Now(),'dd/mm/yyyy')#&nbsp;<strong>Hora:&nbsp;</strong>#TimeFormat(Now(),'medium')#</td></tr>
	<tr><td colspan="5" nowrap>&nbsp;</td></tr>

<!-----------------------------  SI hay integracion  RH --------------------------------------->
<cfif rsUsaRH.Pvalor EQ 'S'>		
	<cfloop query="rsSolIntegracion">
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>		
		
		<tr class="tituloListas">			
			<td nowrap width="20%"><strong>&nbsp;Solicitante:</strong> #rsSolIntegracion.CMScodigo# - #rsSolIntegracion.Apellidos#&nbsp;</td>
			<td nowrap width="5%"><strong>&nbsp;Teléfono: </strong> #rsSolIntegracion.DEtelefono1#&nbsp;</td>
			<td nowrap width="5%"><strong>&nbsp;Fax:</strong> #rsSolIntegracion.DEtelefono2#&nbsp;</td>
			<td nowrap colspan="2" width="5%"><strong>&nbsp;E-mail:</strong> #rsSolIntegracion.DEemail#&nbsp;</td>
		</tr>
	
		<tr>
			<td width="15%" nowrap  bgcolor="##999999" style="padding-left:5px; border-bottom: 1px solid black; border-top:1px solid black; border-left:1px solid black;"><strong>Ctro Funcional</strong></td>
			<td width="20%" nowrap  bgcolor="##999999" style="padding-left:5px; border-bottom: 1px solid black; border-top:1px solid black;"><strong>Responsable</strong></td>
			<td width="15%" nowrap  bgcolor="##999999" style="padding-left:5px; border-bottom: 1px solid black; border-top:1px solid black;"><strong>Tipo Solicitud</strong></td>
			<td width="10%" nowrap  bgcolor="##999999" style="padding-left:5px; border-bottom: 1px solid black; border-top:1px solid black;"><strong>Tipo Item</strong></td>
			<td width="20%" nowrap  bgcolor="##999999" style="padding-left:5px; border-bottom: 1px solid black; border-top:1px solid black; border-right:1px solid black;"><strong>Línea Especialización</strong></td>
		</tr>		
	
		
		<cfquery name="rsLista" datasource="#session.DSN#">
			select  b.CFcodigo, b.CFid, b.CFdescripcion, b.CFuresponsable,
					c.RHPdescripcion		
			from CMSolicitantesCF a
				inner join CFuncional b
					on a.CFid=b.CFid
					and b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				inner join RHPlazas c
					on c.RHPid = b.RHPid
					and c.Ecodigo = b.Ecodigo
			where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and a.CMSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSolIntegracion.CMSid#">  
			
		  
			<cfif isdefined("Form.fCFcodigoD") and len(trim(Form.fCFcodigoD)) and isdefined("Form.fCFcodigoH") and len(trim(Form.fCFcodigoH))>
				and upper(b.CFcodigo) between upper('#Form.fCFcodigoD#') and
				upper('#Form.fCFcodigoH#')
			<cfelseif isdefined("Form.fCFcodigoD") and len(trim(Form.fCFcodigoD)) >
				and upper(b.CFcodigo) >= upper('#Form.fCFcodigoD#') 
			<cfelseif isdefined("Form.fCFcodigoH") and  len(trim(Form.fCFcodigoH))>
				and upper(b.CFcodigo) <= upper('#Form.fCFcodigoH#') 
			</cfif>
			  
			order by b.CFcodigo
		</cfquery>						
	
		<cfset corte = ''>

		<cfif rsLista.recordcount EQ 0>
			<tr><td colspan="5" align="center" style="text-align:center; "> -------------------  No hay registros  -------------------</td></tr>
		<cfelse>
			<cfloop query="rsLista">		
				<cfif currentRow mod 25 EQ 1>
					<cfif currentRow NEQ 1>
						<tr class="pageEnd"><td colspan="3">&nbsp;</td></tr>
					</cfif>
				</cfif>									
				<cfif corte neq rsLista.CFid>
					<tr class="titulolistas">
						<td width="25%" nowrap style="padding-left:5px;border-bottom:1px solid black; border-left:1px solid black;"><strong>&nbsp;#rsLista.CFcodigo# - #rsLista.CFdescripcion#&nbsp;</strong></td>
						<td width="20%" nowrap style="padding-left:5px;border-bottom:1px solid black;">&nbsp;#rsLista.RHPdescripcion#</td>
						<td style="padding-left:5px;border-bottom:1px solid black;">&nbsp;</td>
						<td style="padding-left:5px;border-bottom:1px solid black;">&nbsp;</td>
						<td style="padding-left:5px;border-bottom:1px solid black; ">&nbsp;</td>
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
							and b.CMSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSolIntegracion.CMSid#">
							and c.CMElinea in (select CMElinea 
												from CMEspecializacionTSCF e
												where c.CMElinea = e.CMElinea )							
					</cfquery>
					<!--------------------------------------->
					<cfif rsDatos.recordcount EQ 0>
						<tr><td colspan="5" align="center" style="text-align:center; border-bottom:1px solid black; border-left:1px solid black; border-right:1px solid black;"> ----------  No hay Líneas de Especialización para este Centro Funcional  ----------</td></tr>
					<cfelse>			
						<cfloop query="rsDatos">							
							<tr>
								<td colspan="2" style="border-left:1px solid black; border-right:1px solid black; <cfif rsDatos.RecordCount eq rsDatos.CurrentRow>border-bottom:1px solid black;</cfif>" >&nbsp;</td>
								<td nowrap width="15%" style="padding-left:5px; border-bottom:1px solid black; border-right:1px solid black;">&nbsp;#rsDatos.CMTSdescripcion#&nbsp;</td>
								<cfif rsDatos.Tipo EQ 'A'>
									<td nowrap width="10%" style="padding-left:5px;border-bottom:1px solid black; border-right:1px solid black;">&nbsp;Artículo&nbsp;</td>							
								<cfelseif rsDatos.Tipo EQ 'F'>
									<td nowrap width="10%" style="padding-left:5px;border-bottom:1px solid black; border-right:1px solid black;">&nbsp;Activo&nbsp;</td>							
								<cfelse>
									<td nowrap width="10%" style="padding-left:5px;border-bottom:1px solid black; border-right:1px solid black;">&nbsp;Servicio&nbsp;</td>							
								</cfif>
								<td nowrap width="20%" style="padding-left:5px;border-bottom:1px solid black; border-right:1px solid black;">&nbsp;#rsDatos.Descripcion#&nbsp;</td>															
							</tr>					
						</cfloop>  <!----Fin del loop rsDatos --->
						<!----<tr><td colspan="5" style="border-bottom: 1px solid black;">&nbsp;</td></tr>---->
					</cfif> <!---Fin del if si hay datos en rsDatos ---> 														
				</cfif>	<!---Fin del corte por centro funcional --->
				<cfset corte=rsLista.CFid>
			</cfloop> <!--- Fin del loop de rsLista --->
		</cfif> <!---Fin del if di hay registros en rsLista --->
</cfloop> <!--- Fin del loop de Solicitantes cuando esta integrado --->		

<!------------------------------- Si NO esta integrado con RH ------------------------------------------->	
<cfelse>
	<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">

	<cfloop query="rsSNIntegracion">
		<cfset datos = sec.getUsuarioByRef (rsSNIntegracion.CMSid, session.EcodigoSDC, 'CMSolicitantes') >																							
		
		
		<cfquery name="rsLista" datasource="#session.DSN#">
			select  b.CFcodigo, b.CFid, b.CFdescripcion, b.CFuresponsable,
			(select Pnombre#_Cat#' '#_Cat# Papellido1 
			from DatosPersonales x, Usuario y 
			where x.datos_personales=y.datos_personales and y.Usucodigo=b.CFuresponsable) as responsable
			from CMSolicitantesCF a
			inner join CFuncional b
			on a.CFid=b.CFid
			and b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			

			and a.CMSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSNIntegracion.CMSid#">  

			<cfif isdefined("Form.fCFcodigoD") and len(trim(Form.fCFcodigoD)) and isdefined("Form.fCFcodigoH") and len(trim(Form.fCFcodigoH))>
				and upper(b.CFcodigo) between upper('#Form.fCFcodigoD#') and
				upper('#Form.fCFcodigoH#')
			<cfelseif isdefined("Form.fCFcodigoD") and len(trim(Form.fCFcodigoD)) >
				and upper(b.CFcodigo) >= upper('#Form.fCFcodigoD#') 
			<cfelseif isdefined("Form.fCFcodigoH") and  len(trim(Form.fCFcodigoH))>
				and upper(b.CFcodigo) <= upper('#Form.fCFcodigoH#') 
			</cfif>


			order by b.CFcodigo
		</cfquery>
	
		<cfset corte = ''>
	
		<cfif rsLista.recordcount EQ 0>												
			<!--- <tr align="center"><td colspan="6" align="center" style="text-align:center"> -------------------  No hay registros  -------------------</td></tr> --->
		<cfelse>
			<tr><td>&nbsp;</td></tr>
			<tr><td>&nbsp;</td></tr>
			
			<tr class="tituloListas">
				<td nowrap width="20%"><strong>&nbsp;Solicitante:&nbsp;</strong>#trim(rsSNIntegracion.CMScodigo)# - #datos.Pnombre# #datos.Papellido1# #datos.Papellido2#&nbsp;</td>
				<td nowrap width="5%"><strong>&nbsp;Teléfono: </strong> #datos.Poficina#&nbsp;</td>
				<td nowrap width="5%" ><strong>&nbsp;Fax: </strong> #datos.Pfax#&nbsp;</td>
				<td colspan="2" nowrap width="5%"><strong>&nbsp;E-mail:</strong> #datos.Pemail1#&nbsp;</td>
			</tr>
			
			<tr>
				<td width="15%" nowrap  bgcolor="##999999" style="padding-left:5px; border-bottom: 1px solid black; border-top:1px solid black; border-left:1px solid black;"><strong>Ctro Funcional</strong></td>
				<td width="20%" nowrap  bgcolor="##999999" style="padding-left:5px; border-bottom: 1px solid black; border-top:1px solid black;"><strong>Responsable</strong></td>
				<td width="15%" nowrap  bgcolor="##999999" style="padding-left:5px; border-bottom: 1px solid black; border-top:1px solid black;"><strong>Tipo Solicitud</strong></td>
				<td width="10%" nowrap  bgcolor="##999999" style="padding-left:5px; border-bottom: 1px solid black; border-top:1px solid black;"><strong>Tipo Item</strong></td>
				<td width="20%" nowrap  bgcolor="##999999" style="padding-left:5px; border-bottom: 1px solid black; border-top:1px solid black; border-right:1px solid black;"><strong>Línea Especialización</strong></td>
			</tr>		
			<cfloop query="rsLista">											
				<cfif corte neq rsLista.CFid>													
					<tr class="titulolistas">
						<td width="15%" nowrap style="padding-left:5px;border-bottom:1px solid black;border-left:1px solid black;"><strong>&nbsp;#rsLista.CFcodigo# - #rsLista.CFdescripcion#&nbsp;</strong></td>
						<td width="20%" nowrap style="padding-left:5px;border-bottom:1px solid black;">&nbsp;#rsLista.responsable#</td>
						<td style="padding-left:5px;border-bottom:1px solid black; ">&nbsp;</td>
						<td style="padding-left:5px;border-bottom:1px solid black; ">&nbsp;</td>
						<td style="padding-left:5px;border-bottom:1px solid black; border-right:1px solid black;">&nbsp;</td>
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
							and b.CMSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSNIntegracion.CMSid#">
							and c.CMElinea in (select CMElinea 
												from CMEspecializacionTSCF e
												where c.CMElinea = e.CMElinea )							
					</cfquery>
					<!--------------------------------------->
					<cfif rsDatos.recordcount EQ 0>
						<tr><td colspan="5" align="center" style="text-align:center; border-bottom:1px solid black; border-left:1px solid black; border-right:1px solid black;"> ----------  No hay Líneas de Especialización para este Centro Funcional  ----------</td></tr>
					<cfelse>			
						<cfloop query="rsDatos">
							<cfif currentRow mod 25 EQ 1>
								<cfif currentRow NEQ 1>
									<tr class="pageEnd"><td colspan="3">&nbsp;</td></tr>
								</cfif>
							</cfif>
							<tr>
								<td colspan="2" style="border-left:1px solid black; border-right:1px solid black; <cfif rsDatos.RecordCount eq rsDatos.CurrentRow>border-bottom:1px solid black;</cfif>" >&nbsp;</td>
								<td nowrap width="15%" style="border-bottom:1px solid black; border-right:1px solid black;">&nbsp;#rsDatos.CMTSdescripcion#&nbsp;</td>
								<cfif rsDatos.Tipo EQ 'A'>
									<td nowrap width="10%" style="padding-left:5px;border-bottom:1px solid black; border-right:1px solid black;">&nbsp;Artículo&nbsp;</td>							
								<cfelseif rsDatos.Tipo EQ 'F'>
									<td nowrap width="10%" style="padding-left:5px;border-bottom:1px solid black; border-right:1px solid black;">&nbsp;Activo&nbsp;</td>							
								<cfelse>
									<td nowrap width="10%" style="padding-left:5px;border-bottom:1px solid black; border-right:1px solid black;">&nbsp;Servicio&nbsp;</td>							
								</cfif>
								<td nowrap width="20%" style="padding-left:5px;border-bottom:1px solid black; border-right:1px solid black;">&nbsp;#rsDatos.Descripcion#&nbsp;</td>															
							</tr>					
						</cfloop>  <!----Fin del loop rsDatos --->
						<!---<tr><td colspan="5" style="border-bottom: 1px solid black; border-left:1px solid black; border-right:1px solid black;">&nbsp;</td></tr>--->
					</cfif> <!---Fin del if si hay datos en rsDatos ---> 														
				</cfif>	<!---Fin del corte por centro funcional --->
				<cfset corte=rsLista.CFid>
			</cfloop> <!--- Fin del loop de rsLista --->
		</cfif> <!---Fin del if di hay registros en rsLista --->
	</cfloop> <!--- Fin del loop de solicitantes --->
</cfif> <!---Fin del If si hay o no INTEGRACION CON RH --->
</table>
</cfoutput>

