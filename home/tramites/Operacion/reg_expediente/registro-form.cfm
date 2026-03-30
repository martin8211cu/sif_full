<link href="/cfmx/home/tramites/tramites.css" rel="stylesheet" type="text/css">
<cfparam name="url.identificacion_persona" default="">
<cfparam name="url.id_tipoident" default="0">

<cfif isdefined("url.identificacion_persona") and not isdefined("form.identificacion_persona")>
	<cfparam name="form.identificacion_persona" default="#url.identificacion_persona#">
</cfif>
<cfif isdefined("url.id_tipoident") and not isdefined("form.id_tipoident")>
	<cfparam name="form.id_tipoident" default="#url.id_tipoident#">
</cfif>

<cfif isdefined("url.id_tipo_F") and not isdefined("form.id_tipo_F")>
	<cfparam name="form.id_tipo_F" default="#url.id_tipo_F#">
</cfif>
<cfif isdefined("url.BMfechamod_F") and not isdefined("form.BMfechamod_F")>
	<cfparam name="form.BMfechamod_F" default="#url.BMfechamod_F#">
</cfif>
<cfif isdefined("url.btnFiltrarDocs") and not isdefined("form.btnFiltrarDocs")>
	<cfparam name="form.btnFiltrarDocs" default="#url.btnFiltrarDocs#">
</cfif>

<cfif IsDefined('url.tabexp')>
	<cfset form.tabexp = url.tabexp>
<cfelse>
	<cfparam name="form.tabexp" default="exp1">
</cfif>
	<cfset validacion = '' >
	<cfquery name="data" datasource="#session.tramites.dsn#">
		select 	p.id_persona,
				p.id_tipoident, 
			   	p.id_direccion, 
				p.identificacion_persona, 
				p.nombre, 
				p.apellido1, 
				p.apellido2, 
				p.nacimiento, 
				p.sexo, 
				p.casa, 
				p.oficina, 
				p.celular, 
				p.fax, 
				p.email1, 
				p.foto, 
				p.nacionalidad, 
				p.extranjero,
				coalesce(d.direccion1, d.direccion2) as direccion,
				p.ts_rversion
		from TPPersona p
		left join TPDirecciones d
		on p.id_direccion = d.id_direccion		
		where identificacion_persona = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.identificacion_persona)#">
		and p.id_tipoident = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tipoident#">
	</cfquery>
	
<table width="540" border="0" align="center">
	<tr><td colspan="4">

		<cfoutput>
		<script type="text/javascript">
			function cambia_persona(f){
				location.href="?loc=gestion&identificacion_persona="+escape(f.identificacion_persona.value);
			}
		</script>
		<cfquery name="tipoidentificacion" datasource="#session.tramites.dsn#">
			select id_tipoident, codigo_tipoident, nombre_tipoident 
			from TPTipoIdent
			<cfif isdefined("url.tipoident") and url.tipoident neq 0>
				where id_tipoident = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.tipoident#">
			</cfif>
		</cfquery>

		<form name="form1" action="index.cfm" method="get" style="margin:0;" onSubmit="return validar_form1(this);">
		<input type="hidden" name="loc" value="gestion">
		<cfif isdefined("url.id_instancia") and len(trim(url.id_instancia))>
			<input type="hidden" name="id_instancia" value="<cfoutput>#url.id_instancia#</cfoutput>">
		</cfif>
		<table border="0" cellpadding="5" cellspacing="0" width="520">
			<tr>
				<td colspan="2" valign="top">
					<cfif data.recordcount eq 0 >
					<table width="510" cellpadding="2" cellspacing="0">
						<tr>
							<td colspan="6" bgcolor="##ECE9D8" style="padding:3px; border-bottom:1px solid black; border-top:1px solid black;"><strong>Buscar</strong></td>
						</tr>

						<tr>
							<td valign="middle" nowrap>
							<strong>Identificaci&oacute;n:&nbsp;</strong>
							</td>
							<td valign="middle"> 
								<select name="id_tipoident">
									<cfloop query="tipoidentificacion">
										<option value="#tipoidentificacion.id_tipoident#" <cfif isdefined("url.id_tipoident") and url.id_tipoident eq tipoidentificacion.id_tipoident>selected</cfif> >#tipoidentificacion.nombre_tipoident#</option>
									</cfloop>
								</select>
							</td>
							<td valign="middle"> 

								<input autocomplete="off" name="identificacion_persona" type="text" value="<cfif len(trim(data.identificacion_persona))>#trim(data.identificacion_persona)#<cfelseif isdefined("url.identificacion_persona")>#trim(url.identificacion_persona)#</cfif>">
								<input name="id_persona" type="hidden" value="#data.id_persona#">
							</td>
							<td width="1%">
								<a href="javascript:doConlis();"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Personas" name="img" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlis();'></a>							
							</td>
							<td align="center"><input class="boton" type="submit" value="Buscar"></td>
							<td align="center"><input class="boton" type="button" value="Cerrar" onclick="location.href='?'"></td>
						</tr>
					</table>
					</cfif>
				</td>
			</tr>
			
			<cfif data.recordcount gt 0 >
			<input type="hidden" name="id_tipoident" value="#data.id_tipoident#">
			<input type="hidden" name="id_persona" value="#data.id_persona#">
			<input type="hidden"   name="identificacion_persona" value="#data.identificacion_persona#">
			<tr>
				<td colspan="5" bgcolor="##ECE9D8" style="padding:3px; border-bottom:1px solid black; border-top:1px solid black;"><strong>Datos Personales</strong></td>
			</tr>
			<tr>
				<td colspan="5">
					<table width="520" cellpadding="2" cellspacing="0">
						<tr>
							<td valign="top">
								<cfif Len(data.foto) GT 1>
									<cfinvoke component="sif.Componentes.DButils"
									method="toTimeStamp"
									returnvariable="tsurl">
									<cfinvokeargument name="arTimeStamp" value="#data.ts_rversion#"/>
									</cfinvoke>
									<img align="middle" width="78" height="90" src="/cfmx/home/tramites/Operacion/gestion/foto_persona.cfm?s=#URLEncodedFormat(data.id_persona)#&amp;ts=#tsurl#" border="0" >
								<cfelse>
									<img align="middle"  width="78" height="90" src="/cfmx/home/public/not_avail.gif" border="0" >
								</cfif>
							</td>
							<td valign="top">
								<table width="100%" cellpadding="2" cellspacing="0" border="0">
									<tr>
										<td valign="middle">
										#tipoidentificacion.nombre_tipoident# #data.identificacion_persona#</td>
										<TD align="right"><input class="boton" type="button" value="Cerrar" onclick="location.href='?'"></TD>
									</tr>

									<tr>
										<td valign="top" colspan="2">
										#data.nombre# #data.apellido1# #data.apellido2#</td>
									</tr>
						
									<tr>
										<td valign="top" colspan="2">  
											<cfif len(trim(data.id_direccion))>
												<cf_tr_direccion key="#data.id_direccion#" action="display">
											</cfif>
										</td>
									</tr>

								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
</form>									
			<tr>
				<td colspan="5">
					<cf_tabs onclick="tab_set_current_inst">
						<cf_tab text="Expediente Personal" id="exp1" selected="#form.tabexp is 'exp1'#">
							<cfif form.tabexp eq 'exp1'>
								<form name="form2" action="index.cfm" method="get" style="margin:0;">
									<input type="hidden"   name="identificacion_persona" value="#data.identificacion_persona#">
									<input type="hidden" name="id_persona" value="#data.id_persona#">
									<input type="hidden" name="id_tipoident" value="#data.id_tipoident#">
									<cfinclude template="expPersonal.cfm">
								</form>
							</cfif>								 
						</cf_tab>
						
 						<cf_tab text="Tr&aacute;mites Completados" id="exp2" selected="#form.tabexp is 'exp2'#">
							<cfif form.tabexp eq 'exp2'>
								<cfinclude template="tramCompl.cfm">
							</cfif>
						</cf_tab>
		
						<cf_tab text="Tr&aacute;mites en Proceso" id="exp3" selected="#form.tabexp is 'exp3'#">
							<cfif form.tabexp eq 'exp3'>
								<cfinclude template="tramEnProc.cfm">	
							</cfif>						
						</cf_tab>
						
						<cf_tab text="Identificaciones" id="exp4" selected="#form.tabexp is 'exp4'#">
							<cfif form.tabexp eq 'exp4'>
							    <cfset modo_ident = 1>
								<form name="form3" method="get" action="index.cfm" style="margin:0;">
									<input type="hidden"   name="identificacion_persona" value="#data.identificacion_persona#">
									<input type="hidden" name="id_persona" value="#data.id_persona#">
									<input type="hidden" name="id_tipoident" value="#data.id_tipoident#">							
								 <cfinclude template="filtroDocs.cfm">
							    </form>								 
								<cfinclude template="documentos.cfm">
							</cfif>
						</cf_tab>
						
						<cf_tab text="Documentos" id="exp5" selected="#form.tabexp is 'exp5'#">
							<cfif form.tabexp eq 'exp5'>
							    <cfset modo_ident = 0>
								<form name="form3" method="get" action="index.cfm" style="margin:0;">
									<input type="hidden"   name="identificacion_persona" value="#data.identificacion_persona#">
									<input type="hidden" name="id_persona" value="#data.id_persona#">
									<input type="hidden" name="id_tipoident" value="#data.id_tipoident#">							
								 <cfinclude template="filtroDocs.cfm">
							    </form>								 
								<cfinclude template="documentos.cfm">
							</cfif>
						</cf_tab>
					</cf_tabs>							
				</td>
			</tr>
			<cfelseif isdefined("url.identificacion_persona") and len(trim(url.identificacion_persona))>
				<tr>
					<td colspan="2" bgcolor="##ECE9D8" style="padding:3px; border-bottom:1px solid black; border-top:1px solid black;"><strong>Datos Personales</strong></td>
				</tr>
				<tr><td colspan="2" align="center">No se encontro la persona</td></tr>
			</cfif>
		</table>
		
		</cfoutput>
	</td></tr>


	<script language="javascript1.2" type="text/javascript">
		function validar_form1(f){

			var msj = '';
			<cfoutput>#validacion#</cfoutput>

			if (msj != ''){
				alert('Se presentaron los siguientes errores:\n' + msj)
				return false;
			}

			return true;
		}
		function tab_set_current_inst (n){
			var param = "";
			<cfif isdefined("form.identificacion_persona") and form.identificacion_persona NEQ ''>
				param = param + "&identificacion_persona=<cfoutput>#JSStringFormat(form.identificacion_persona)#</cfoutput>";
			</cfif>					
			<cfif isdefined("form.id_tipoident") and form.id_tipoident NEQ ''>
				param = param + "&id_tipoident=<cfoutput>#JSStringFormat(form.id_tipoident)#</cfoutput>";
			</cfif>

			location.href='index.cfm?tabexp='+escape(n)+param;
		}		
		
		/* CONLIS DE PERSONAS  */
		var popUpWin=0;
		//Levanta el Conlis
		function popUpWindow(URLStr, left, top, width, height)
		{
			if(popUpWin)
			{
				if(!popUpWin.closed) popUpWin.close();
			}
			popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+',top='+top+',screenX='+left+',screenY='+top);
		}
		//Llama el conlis
		function doConlis() {
			var params ="";
			params = "?formulario=formf&id=id_persona&nombre=nombre&apellido1=apellido1&apellido2=apellido2";
			popUpWindow("/cfmx/home/tramites/Operacion/ventanilla/conlisPersona.cfm"+params,225,110,650,500);
		}
	</script>
</table>