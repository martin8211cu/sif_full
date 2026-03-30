<cfif isdefined("url.Iid") and not isdefined("form.Iid")>
	<cfset form.Iid = url.Iid >
</cfif>
<cfif isdefined("url.archivo") and not isdefined("form.archivo")>
	<cfset form.archivo = url.archivo >
</cfif>

<cfset vIdioma = ''>
<cfif isdefined("session.IdiomaXml") and len(trim(session.IdiomaXml))>
	<cfset vIdioma = session.IdiomaXml>
<cfelseif isdefined("form.Iid") and len(trim(form.Iid))>
	<cfset vIdioma = form.Iid >
<cfelseif isdefined("url.Iid") and len(trim(url.Iid))>
	<cfset vIdioma = url.Iid >
</cfif>

<cfif not ( isdefined("vIdioma") and len(trim(vIdioma)))>
	<!--- idioma default es_CR --->
	<cfquery datasource="sifcontrol" name="idiomas">
		select Iid,Icodigo,Descripcion,Icodigo as locale_lang
		from Idiomas
		where Icodigo = 'es_CR'	
		order by Icodigo
	</cfquery>
	<cfset form.Iid = idiomas.Iid >
	<cfset url.Iid = idiomas.Iid >
	<cfset form.Icodigo = trim(idiomas.Icodigo) >
<cfelse >
	<cfquery datasource="sifcontrol" name="idiomas">
		select Iid,Icodigo,Descripcion,Icodigo as locale_lang
		from Idiomas
		where Iid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vIdioma#">
	</cfquery>
	<cfset form.Icodigo = trim(idiomas.Icodigo) >
</cfif>

<!--- Separador --->
<cfset separador = CreateObject("java","java.lang.System").getProperty("file.separator")>

<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="translate">

<cfquery datasource="sifcontrol" name="idiomas">
	select Iid,Icodigo,Descripcion,Icodigo as locale_lang
	from Idiomas
	order by Icodigo
</cfquery>

<!--- Proceso de archivos locales --->
<cfset local = false >
<cfif len(trim(form.Icodigo )) gt 6 >
	<cfset local = true >
	<cfset local_p = 'locales' & url.p >
	<cfset local_path = expandpath(separador&local_p) >
</cfif>

<style type="text/css">
.flat, .flattd input {
	border:1px solid gray;
	height:19px;
}
.checkBox1 {height:auto; line-height:normal;}
</style>

<table width="100%" cellpadding="5" cellspacing="0">
	<tr>
		<td width="30%" valign="top" style="border-right:1px solid gray; "><cfinclude template="directorios.cfm"></td>
		<td width="70%" valign="top" align="center">
			<cfquery name="rsVSnuevoBusca" datasource="sifcontrol">
				select distinct ruta from VSnuevo
					where ruta like '#p#/%'
					and ruta not like '#p#/%/%'
					order by ruta
			</cfquery>
		
			<cfset comp = CreateObject("component", "sif.Componentes.Translate")>
			<cfloop query="rsVSnuevoBusca">
				<cfif Not FileExists (ExpandPath(ruta)) >
					<cfset comp.SaveXML( ExpandPath(ruta), comp.NewXML() )>
				</cfif>
			</cfloop>
			<cfdirectory action="list" directory="#path#" name="dir">

			<cfquery dbtype="query" name="files">
				select *
				from dir
				where name not like '~%'
				  and (name like '%.xml' or name like '%.XML')
				  and name not like '[_]%'
				  and name != 'CFIDE'
				  and name != 'WEB-INF'
				  and name != 'META-INF'
				  and name != 'cfdocs'
				  <cfif isdefined("form.archivo") and len(trim(form.archivo))>
				  	and name = '#form.archivo#'
				  </cfif>
				order by name
			</cfquery>

			<cfquery dbtype="query" name="xfiles">
				select name
				from dir
				where name not like '~%'
				  and (name like '%.xml' or name like '%.XML')
				  and name not like '[_]%'
				  and name != 'CFIDE'
				  and name != 'WEB-INF'
				  and name != 'META-INF'
				  and name != 'cfdocs'
				order by name
			</cfquery>
			
			<form name="form1" method="post" action="traduccionXML-sql.cfm" style="margin:0;">
				<cfoutput>
				<input type="hidden" name="modifico" value="">
				<input type="hidden" name="quieremodificar" value="0">
				<input type="hidden" name="idioma" value="#form.Icodigo#">
				<input type="hidden" name="p" value="<cfif not local >#url.p#<cfelse>#local_p#</cfif>" >
				<input type="hidden" name="_p" value="#url.p#" >
				<input type="hidden" name="total" value="#files.recordcount#">
				<input type="hidden" name="local" value="#local#">
				</cfoutput>

				<table width="80%" cellpadding="0" cellspacing="2" style="border:1px solid gray;">
					<tr bgcolor="#FFFFFF">
						<td style="padding-left:5px; ">Seleccione el idioma:</td>
						<td valign="top">
							<select name="Iid" id="Iid" onchange="comboclick()">
							<cfoutput query="idiomas" group="locale_lang">
								<optgroup label="#HTMLEditFormat(idiomas.locale_lang)#">
								<cfoutput>
								<option value="#HTMLEditFormat(idiomas.Iid)#" <cfif idiomas.Iid eq vIdioma>selected</cfif>>#HTMLEditFormat(idiomas.Descripcion)# (#HTMLEditFormat(Trim(idiomas.Icodigo))#)</option>
								</cfoutput>
								</optgroup>
							</cfoutput>
							</select>
							<cfoutput>
							<input type="hidden" name="_Iid" value="#vIdioma#">
							</cfoutput>
						</td>
					</tr>

					<tr bgcolor="#FFFFFF">
						<td style="padding-left:5px; ">Seleccione el archivo(opcional):</td>
						<td valign="top">
							<select name="archivo" id="archivo" onchange="comboclick()">
							<option value="" >-Todos-</option>
							<cfoutput query="xfiles">
								<option value="#xfiles.name#" <cfif isdefined("form.archivo") and xfiles.name eq form.archivo>selected</cfif> >#HTMLEditFormat(xfiles.name)#</option>
							</cfoutput>
							</select>
						</td>
					</tr>



					<tr bgcolor="#FFFFFF"><td colspan="2">&nbsp;</td></tr>
					<cfoutput query="files">
						<cftry>
							<cfset ruta = p >
							<cfset f = translate.OpenXML('#path#'& separador & '#files.name#') ><!--- abre y lee el archivo xml --->
							<cfset local_file_exist = false >
							<cfif local >
								<cfif FileExists('#local_path#'& separador & '#files.name#') >
									<cfset local_file_exist = true >
									<cfset ruta = local_p >
									<cfset local_f = translate.OpenXML('#local_path#'& separador & '#files.name#') ><!--- abre y lee el archivo xml --->
								</cfif>
							</cfif>
						<cfcatch type="any">
							<cfthrow message="Error abriendo archivo #ruta#/#files.name#. El archivo indicado no tiene un formato v&aacute;lido XML: #cfcatch.Message# #cfcatch.Detail#.">
						</cfcatch>
						</cftry>

						<cfset datos = XmlSearch(f, "//Idioma")>
						<cfset etiquetas = '' >
						<cfloop from="1" to="#arraylen(datos)#" index="i">
							<cfloop from="1" to="#arraylen(datos[i].xmlChildren)#" index="j">
								<cfif  ListFindNoCase(etiquetas, datos[i].xmlChildren[j].xmlName) eq 0>
									<cfset etiquetas = ListAppend(etiquetas, datos[i].xmlChildren[j].xmlName ) >
								</cfif>
							</cfloop>
						</cfloop>
						
						<!--- <cfdump var="#ruta#"><br /> ---> 
						<cfset ruta = replace(ruta,'\','/', 'ALL')>
						<cfquery name="rsVSnuevo" datasource="sifcontrol">
							select 
								entrada
							from VSnuevo
								where ruta like '#ruta#/#files.name#'
							order by ruta
						</cfquery>
						<!--- <cfdump var="#rsVSnuevo#"> --->
						<!--- <cf_dump var="#ruta#"><br /> --->
						<cfloop query="rsVSnuevo">
							<cfif ListFindNoCase(etiquetas, entrada) eq 0>
								 <cfset etiquetas = ListAppend(etiquetas, entrada)>  
							 </cfif>
						</cfloop>

						<cfset etiquetas = Listsort(etiquetas, "text", "asc") >
						<cfset contador = 0 >
						<input type="hidden" name="name_#files.currentRow#" value="#files.name#">
							<tr bgcolor="##CCCCCC"><td style="padding-left:10px;" colspan="2"><strong>Archivo: #files.name#</strong></td></tr>
							<cfif listlen(etiquetas) gt 0>
								<cfloop list="#etiquetas#" index="key" >
									<cfset texto = '' >
									<cfif not local>
										<cfset texto = translate.getLabel(f,form.Icodigo,key) > <!--- Obtiene la traducción --->
									<cfelseif local_file_exist >
										<cfset texto = translate.getLabel(local_f,form.Icodigo,key) ><!--- Obtiene la traducción en el idioma indicado--->
									</cfif>
									<cfset contador = contador + 1 >
									<tr>
										<td bgcolor="##FFFFFF" nowrap width="125" style="padding-left:30;">#key#</td>
										<td  bgcolor="##FFFFFF" align="center">
											<input class="flat" name="texto_#files.currentRow#_#contador#" type="text" size="60" maxlength="255" onFocus="this.select();" value="#trim(texto)#" onChange="javascript:modificar();">
											<input name="key_#files.currentRow#_#contador#" type="hidden" value="#key#">
										</td>
									</tr>
								</cfloop>
							<cfelse>
								<tr bgcolor="##FFFFFF"><td colspan="2" align="center">--No hay datos---</td></tr>
							</cfif>
							<input type="hidden" name="total_datos_#files.currentRow#" value="#contador#">
							<tr bgcolor="##FFFFFF"><td colspan="2">&nbsp;</td></tr>
					</cfoutput>
					<cfif files.recordcount gt 0 >
						<TR bgcolor="#FFFFFF"><TD colspan="2">
						<table width="60%" align="center">
							<tr><td align="center" >
								<input type="submit" name="Guardar" value="Guardar">
								<input type="button" name="Cancelar" value="Cancelar" onClick="location.href = '/cfmx/home/menu/modulo.cfm?s=sys&m=apps'">
							</td></tr>
						</table>
						</TD>
						</TR>
					</cfif>
				</table>				
			</form>
		</td>
	</tr>
</table>

<script type="text/javascript" language="javascript1.2">
	function modificar(){
		document.form1.modifico.value = '*';
	}

	function comboclick(){
		if ( document.form1.modifico.value != '' ){
			if ( confirm('Desea guardar los cambios realizados?') ){
				document.form1.quieremodificar.value = 1;
			}
		}
		document.form1.submit();
	}
</script>