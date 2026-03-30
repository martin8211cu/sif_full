<!--- Asigna a la variable navegacion los filtros  --->
<cfset navegacion = "">
<cfif isdefined("form.CMScodigoD") and len(trim(form.CMScodigoD)) >
	<cfset navegacion = navegacion & "&CMScodigoD=#form.CMScodigoD#">
</cfif>

<cfif isdefined("form.CMScodigoH") and len(trim(form.CMScodigoH)) >
	<cfset navegacion = navegacion & "&CMScodigoH=#form.CMScodigoH#">
</cfif>

<cfif isdefined("form.CMSestado") and len(trim(form.CMSestado)) >
	<cfset navegacion = navegacion & "&CMSestado=#form.CMSestado#">
</cfif>

<cfif isdefined("Form.CFcodigo") and len(trim(form.CFcodigo)) >
	<cfset navegacion = navegacion & "&CFcodigo=#form.CFcodigo#">
</cfif>

<cfif isdefined("Form.CMSnombre") and len(trim(form.CMSnombre)) >
	<cfset navegacion = navegacion & "&CMSnombre=#form.CMSnombre#">
</cfif>

<!--- Query que indica si la empresa esta utilizando la interfaz de RH --->
<cfquery name="rsUsaRH" datasource="#session.DSN#">
	select 	Pvalor 
	from 	Parametros 
	where 	Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Pcodigo=520
</cfquery>

<cfoutput>
<table width="100%" cellpadding="0" cellspacing="0" border="0">
		
	<tr><td colspan="5" align="center" class="tituloAlterno"><strong>#session.enombre#</strong></td></tr>
	<tr><td colspan="5" nowrap>&nbsp;</td></tr>
	<tr><td colspan="5" align="center"><strong>Consulta de Datos de Solicitantes</strong></td></tr>
	<tr><td colspan="5" align="center"><strong>Fecha de la Consulta:&nbsp;</strong>#LSDateFormat(Now(),'dd/mm/yyyy')#&nbsp;<strong>Hora:&nbsp;</strong>#TimeFormat(Now(),'medium')#</td></tr>
	<tr><td colspan="5" nowrap>&nbsp;</td></tr>
	
	<tr class="tituloListas">
		<td style=" border-bottom: 1px solid black; border-top:1px solid black;"><strong>&nbsp;Código - Nombre</strong></td>
		<td style=" border-bottom: 1px solid black; border-top:1px solid black;"><strong>Teléfono</strong></td>
		<td style=" border-bottom: 1px solid black; border-top:1px solid black;"><strong>Fax</strong></td>
		<td style=" border-bottom: 1px solid black; border-top:1px solid black;"><strong>Centro Funcional</strong></td>
		<td style=" border-bottom: 1px solid black; border-top:1px solid black;"><strong>E-mail</strong></td>
	</tr>
	
	<input type="hidden" name="CMSid" value="" >

	<cfif rsUsaRH.Pvalor EQ 'S'>
		<!--- Si hay integracion ---->
        <cfinclude template="../../Utiles/sifConcat.cfm">
		<cfquery name="rsLista" datasource="#session.DSN#">
			select 	a.DEid, a.DEidentificacion, a.DEnombre#_Cat#' '#_Cat#a.DEapellido1#_Cat#' '#_Cat#a.DEapellido2 as Apellidos, 
					a.DEdireccion, a.DEtelefono1, a.DEtelefono2, a.DEemail, 
					b.CMSid, b.CMScodigo, c.CFcodigo, c.CFdescripcion
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
							
				<cfif isdefined("form.CMSestado") and len(trim(form.CMSestado)) >
					and a.CMSestado = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CMSestado#">
				</cfif>
							
				<cfif isdefined("form.CMSnombre") and len(trim(form.CMSnombre)) >
					and upper(DEnombre) like  upper('%#form.CMSnombre#%')
				</cfif>
			</cfquery>
			
			<cfloop query="rsLista">
				<tr style="padding:3px; cursor:hand;" class="<cfif rsLista.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>" 
					onClick="javascript:procesar(#rsLista.CMSid#);"   
					onmouseover = "style.backgroundColor='##E4E8F3';"
					onmouseout = "style.backgroundColor='<cfif rsLista.CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';">
					<td style="padding-left:10px;">&nbsp;#trim(rsLista.CMScodigo)# - #rsLista.Apellidos#</td>
					<td style="padding-left:10px;">&nbsp;#rsLista.DEtelefono1#</td>
					<td style="padding-left:10px;">&nbsp;#rsLista.DEtelefono2#</td>
					<td style="padding-left:10px;">#rsLista.CFcodigo# - #rsLista.CFdescripcion#</td>
					<td style="padding-left:10px;">&nbsp;#rsLista.DEemail#</td>
				</tr>
			</cfloop>
		
		<cfelse>
			<!--- Si NO hay integracion ---->
			<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">
			
			<cfquery name="rsSolicitantes" datasource="#session.DSN#">
				select a.CMSid, a.CMScodigo,a.CMSnombre , b.CFcodigo,b.CFdescripcion
				from CMSolicitantes a
				left outer join CFuncional b
					  on b.Ecodigo = a.Ecodigo
					  and b.CFid = a.CFid  

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
				
				<cfif isdefined("form.CMSestado") and len(trim(form.CMSestado)) >
					and a.CMSestado = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CMSestado#">
				</cfif>
				
				<cfif isdefined("form.CMSnombre") and len(trim(form.CMSnombre)) >
					and upper(a.CMSnombre) like  upper('%#form.CMSnombre#%')
				</cfif>
			</cfquery>
			
			<cfloop query="rsSolicitantes">
				<tr style="padding:3px; cursor:hand;" class="<cfif rsSolicitantes.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>" 
					onClick="javascript:procesar(#rsSolicitantes.CMSid#);"
					onmouseover = "style.backgroundColor='##E4E8F3';"
					onmouseout = "style.backgroundColor='<cfif rsSolicitantes.CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';">
					<cfset datos = sec.getUsuarioByRef (rsSolicitantes.CMSid, session.EcodigoSDC, 'CMSolicitantes') >																		
					<td style="padding-left:10px;">&nbsp;#trim(rsSolicitantes.CMScodigo)# - #datos.Pnombre# #datos.Papellido1# #datos.Papellido2#</td>
					<td style="padding-left:10px;">&nbsp;#datos.Poficina#</td>
					<td style="padding-left:10px;">&nbsp;#datos.Pfax#</td>
					<td style="padding-left:10px;">&nbsp;#rsSolicitantes.CFcodigo# - #rsSolicitantes.CFdescripcion#</td>
					<td style="padding-left:10px;">&nbsp;#datos.Pemail1#</td>
				</tr>
			</cfloop>
		</cfif>
		
</table>
</cfoutput>

<script language='javascript' type='text/JavaScript' >
	function procesar(valor) {
		document.form1.action = 'DatosSolicitanteCF-lista.cfm';
		document.form1.CMSid.value = valor;
		document.form1.submit();
	}
</script>

