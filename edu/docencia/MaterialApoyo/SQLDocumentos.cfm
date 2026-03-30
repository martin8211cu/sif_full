<cfset tmp = "" >		<!--- comtenido binario de la imagen --->
<cfset contenidoMA = "null" >

<cfif isdefined("Form.fileImage") and Len(Trim(Form.fileImage)) NEQ 0>
	<cftry>
		<cffile action="Upload" fileField="form.fileImage" destination="#GetTempDirectory()#" nameConflict="Overwrite" accept="image/*,application/vnd.ms-excel,application/msword,text/plain,text/html,application/pdf,application/x-zip-compressed,application/vnd.ms-powerpoint,application/vnd.ms-publisher">
		<cfif #cffile.fileSize# GT 2097152>
			<cflocation url="../../errorPages/BDerror.cfm?errType=0&errMsg=Este tamanno de archivo NO es permitido: #cffile.fileSize#. Contacte al administrador para cualquier consulta." addtoken="no">
			<cfabort> 
		</cfif>
		<cfset nombre_arch = "#cffile.clientfile#">
		<cfset content_type = "#cffile.contenttype#/#cffile.contentsubtype#">

		<!--- lee la imagen de la carpeta del servidor y la almacena en la variable tmp --->
		<cffile action="readbinary"  file="#GetTempDirectory()##cffile.ClientFile#" variable="tmp" > 
		<cffile action="delete" file="#GetTempDirectory()##cffile.ClientFileName#.#cffile.ClientFileExt#">
	
		<!--- Formato para sybase --->
		
		<cfset Hex=ListtoArray("0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F")>

		<cfif not isArray(tmp)>
			<cfset contenidoMA = "">
		</cfif>
		<cfset miarreglo=#ListtoArray(ArraytoList(#tmp#,","),",")#>
		<cfset miarreglo2=ArrayNew(1)>
		<cfset temp=ArraySet(miarreglo2,1,8,"")>

		<cfloop index="i" from="1" to=#ArrayLen(miarreglo)#>
			<cfif miarreglo[i] LT 0>
				<cfset miarreglo[i]=miarreglo[i]+256>
			</cfif>
		</cfloop>

		<cfloop index="i" from="1" to=#ArrayLen(miarreglo)#>
			<cfif miarreglo[i] LT 10>
				<cfset miarreglo2[i] = "0" & #toString(Hex[(miarreglo[i] MOD 16)+1])#>
			<cfelse>
				<cfset miarreglo2[i] = #trim(toString(Hex[(miarreglo[i] \ 16)+1]))# & #trim(toString(Hex[(miarreglo[i] MOD 16)+1]))#>
			</cfif>
		</cfloop>
		<cfset temp = #ArrayPrepend(miarreglo2,"0x")#>
		<cfset contenidoMA = #ArraytoList(miarreglo2,"")#>
	<cfcatch type="any">
		<cflocation url="../../errorPages/BDerror.cfm?errType=0&errMsg=No puede subir este tipo de archivo. Contacte al administrador para cualquier consulta." addtoken="no">
	</cfcatch>
	</cftry>
</cfif>

<cfset modo="ALTA">
<cfif isdefined('form.MateriaTipo')>
	<cfset arrayMT = ListToArray(form.MateriaTipo)>
</cfif>

<cfquery datasource="#Session.Edu.DSN#" name="rsAtributos">	
	<cfif isdefined("Form.Cambio")>
		Select convert(varchar,id_atributo) as id_atributo, 
		convert(varchar,maa.id_tipo) as id_tipo,
		nombre_atributo, tipo_atributo
		from MAAtributo maa, MATipoDocumento mtd
		where CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			and maa.id_tipo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cbTipoDoc#">
			and maa.id_tipo=mtd.id_tipo
			and maa.id_atributo not in (
										Select md.id_atributo
										from MAAtributoDocumento md, MAAtributo mat
											where id_documento=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_documento#">
											and md.id_atributo=mat.id_atributo
										)
		order by orden_atributo
	<cfelse>
		Select convert(varchar,id_atributo) as id_atributo, 
		convert(varchar,maa.id_tipo) as id_tipo, 
		nombre_atributo,tipo_atributo
		from MAAtributo maa, MATipoDocumento mtd
		where CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			and maa.id_tipo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cbTipoDoc#">
			and maa.id_tipo=mtd.id_tipo
		order by orden_atributo
	</cfif>	
</cfquery>

<cfif isdefined("Form.Cambio")>
	<cfquery datasource="#Session.Edu.DSN#" name="rsAtributosDocTotal">
		Select convert(varchar,consecutivo) as consecutivo, 
		convert(varchar,id_documento) as id_documento, 
		convert(varchar,md.id_atributo) as id_atributo, 
		convert(varchar,id_valor) as id_valor,
		valor,
		convert(varchar,id_tipo) as id_tipo,
		tipo_atributo
		from MAAtributoDocumento md, MAAtributo mat
			where id_documento=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_documento#">
			and md.id_atributo=mat.id_atributo
	</cfquery>
	<cfquery dbtype="query" name="rsAtributosDoc">
		select *
		from rsAtributosDocTotal
		where id_tipo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.cbTipoDoc#">
	</cfquery>	
</cfif>


<cfif not isdefined("Form.Nuevo")>
	<cftransaction>
		<cftry>
			<cfquery name="ABC_Docum" datasource="#Session.Edu.DSN#">
				set nocount on
				<cfif isdefined("Form.Alta")>
					declare @ultDoc numeric
					
					insert MADocumento (id_tipo, titulo, resumen, fecha, tipo_contenido, nom_archivo, contenido, tipo_contenidodoc, Splaza)
					values (
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cbTipoDoc#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.titulo#">,
						<cfif form.cbTipoCont EQ "T">
							ltrim(rtrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.resumen#">)),
						<cfelse>
							null,
						</cfif>
						getDate(),
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.cbTipoCont#">,
						<cfif form.cbTipoCont EQ "I" OR form.cbTipoCont EQ "D">
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#nombre_arch#">,
						<cfelseif form.cbTipoCont EQ "L">
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nom_archivo#">,
						<cfelse>
							null,
						</cfif>
						<cfif form.cbTipoCont EQ "I" OR form.cbTipoCont EQ "D">
							#contenidoMA#,
						<cfelse>
							null,
						</cfif>
						<cfif form.cbTipoCont EQ "I" OR form.cbTipoCont EQ "D">
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#content_type#">,
						<cfelse>
							null,
						</cfif>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Splaza#">)
						
						select @ultDoc = @@identity	
						
						<!--- Ciclo para la insercion de MAAtributoDocumento --->
						<cfset CodIdAtributo = 0>
						<cfoutput query="rsAtributos">
							<cfset CodIdAtributo = #rsAtributos.id_atributo#>
							<cfset ValorAtrib = "form.ValorAtrib_#rsAtributos.id_tipo#_#CodIdAtributo#">	
							<cfset contValor = Evaluate(ValorAtrib)>
							<cfif isdefined(Evaluate("ValorAtrib")) and len(trim(#contValor#)) NEQ 0>
  								insert MAAtributoDocumento 
 								(id_documento, id_atributo, id_valor, valor) 
								values (@ultDoc,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#CodIdAtributo#">,
									<cfif rsAtributos.tipo_atributo EQ "V">
	 									<cfqueryparam cfsqltype="cf_sql_numeric" value="#contValor#">,null
									<cfelse>
										null,<cfqueryparam cfsqltype="cf_sql_varchar" value="#contValor#">
									</cfif>
									) 		
							</cfif>
						</cfoutput>
						
						<!--- Tipos de amteria en donde aplica el documento --->
						<cfif isdefined('arrayMT') and IsArray(arrayMT) EQ true>
							<cfloop index = "LoopCount" from = "1" to = "#ArrayLen(arrayMT)#"> 
								insert DocumentoMateriaTipo (MTcodigo, id_documento)
								values (
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#arrayMT[LoopCount]#">,
										@ultDoc
										) 								 
							</cfloop>						
						<cfelseif isdefined('form.MateriaTipo')>
							insert DocumentoMateriaTipo (MTcodigo, id_documento)
								values (
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MateriaTipo#">,
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_documento#">
										) 						
						</cfif>						
						 
						<cfset modo="ALTA">
				<cfelseif isdefined("Form.Baja")>
						delete DocumentoMateriaTipo
						where id_documento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_documento#">								
				
						delete MAAtributoDocumento
						where id_documento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_documento#">						
										
						delete MADocumento
						where id_documento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_documento#">
						
					  <cfset modo="ALTA">
				<cfelseif isdefined("Form.Cambio") and isdefined('form.id_documento')>
						update MADocumento set
							id_tipo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.cbTipoDoc#">,
							titulo	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.titulo#">,
							<cfif form.cbTipoCont EQ "T">
								resumen = ltrim(rtrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.resumen#">)),
							<cfelse>
								resumen = null,
							</cfif>
							fecha = getDate(),
							tipo_contenido	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.cbTipoCont#">,
							<cfif form.cbTipoCont EQ "I" OR form.cbTipoCont EQ "D">
								<cfif isdefined("Form.fileImage") and Len(Trim(Form.fileImage)) NEQ 0>
								nom_archivo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#nombre_arch#">,
								</cfif>
							<cfelseif form.cbTipoCont EQ "L">
								nom_archivo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nom_archivo#">,
							<cfelse>
								nom_archivo = null,
							</cfif>
							<cfif form.cbTipoCont EQ "I" OR form.cbTipoCont EQ "D">
								<cfif isdefined("Form.fileImage") and Len(Trim(Form.fileImage)) NEQ 0>
								contenido = #contenidoMA#,
								</cfif>
							<cfelse>
								contenido = null,
							</cfif>
							<cfif form.cbTipoCont EQ "I" OR form.cbTipoCont EQ "D">
								tipo_contenidodoc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#content_type#">,
							<cfelse>
								tipo_contenidodoc = null,
							</cfif>
							Splaza = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Splaza#">
						where id_documento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_documento#">
						
						<!--- Ciclo para el Cambio de MAAtributoDocumento --->
						<cfset CodIdAtributo = 0>
						<cfoutput query="rsAtributosDocTotal">
							<cfset CodIdAtributo = #rsAtributosDoc.id_atributo#>
							<cfset ValorAtrib = "form.Consec_#rsAtributosDocTotal.consecutivo#_#Form.id_documento#_#rsAtributosDocTotal.id_tipo#_#rsAtributosDocTotal.id_atributo#">	
							<cfset contValor = Evaluate(ValorAtrib)>

							<cfquery dbtype="query" name="rsAtributosDoc_Actualizar">
								select *
								from rsAtributosDoc
								where consecutivo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsAtributosDocTotal.consecutivo#">
							</cfquery>	
							
							<cfif isdefined(Evaluate("ValorAtrib")) and rsAtributosDoc_Actualizar.recordCount GT 0>
								update MAAtributoDocumento set
									<cfif rsAtributosDocTotal.tipo_atributo EQ "V">	<!--- Combo de Valores --->
										id_valor = <cfqueryparam cfsqltype="cf_sql_numeric" value="#contValor#">
									<cfelse>
										valor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#contValor#">
									</cfif>
								where consecutivo= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAtributosDocTotal.consecutivo#">
							<cfelse>	<!--- Borrado de Atributos por Documento --->
								delete MAAtributoDocumento 
								where consecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAtributosDocTotal.consecutivo#">
							</cfif>
						</cfoutput>

						<!--- Ciclo para la insercion de MAAtributoDocumento --->
						<cfoutput query="rsAtributos">
							<cfset CodIdAtributo = #rsAtributos.id_atributo#>
							<cfset ValorAtrib = "form.ValorAtrib_#rsAtributos.id_tipo#_#CodIdAtributo#">	
							<cfset contValor = Evaluate(ValorAtrib)>
							<cfif isdefined(Evaluate("ValorAtrib")) and len(trim(#contValor#)) NEQ 0 and isdefined('form.id_documento') and form.id_documento NEQ ''>
  								insert MAAtributoDocumento 
 								(id_documento, id_atributo, id_valor, valor) 
								values (	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_documento#">,
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#CodIdAtributo#">,
											<cfif rsAtributos.tipo_atributo EQ "V">
	 											<cfqueryparam cfsqltype="cf_sql_numeric" value="#contValor#">,null
											<cfelse>
												null,<cfqueryparam cfsqltype="cf_sql_varchar" value="#contValor#">
											</cfif>
									) 		
							</cfif>
						</cfoutput>
						
						<!--- Borrado de todos los registros en la tabla DocumentoMateriaTipo
								para despues volverlos a insertar --->						
						delete DocumentoMateriaTipo
						where id_documento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_documento#">								
						
						<!--- Tipos de amteria en donde aplica el documento --->
						<cfif isdefined('arrayMT') and IsArray(arrayMT) EQ true>
							 <cfloop index = "LoopCount" from = "1" to = "#ArrayLen(arrayMT)#"> 
								insert DocumentoMateriaTipo (MTcodigo, id_documento)
									values (
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#arrayMT[LoopCount]#">,
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_documento#">
											) 								 
							 </cfloop>						
						<cfelseif isdefined('form.MateriaTipo')>
							insert DocumentoMateriaTipo (MTcodigo, id_documento)
								values (
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MateriaTipo#">,
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_documento#">
										) 						
						</cfif>
						
					  <cfset modo="CAMBIO">
				</cfif>
				set nocount off
			</cfquery>
		<cfcatch type="any">
			<cfinclude template="../../errorPages/BDerror.cfm">
			<cfabort>
		</cfcatch>
		</cftry>
	</cftransaction>	
</cfif>
<form action="documentos.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<input name="Splaza" type="hidden" value="<cfif isdefined("Splaza")><cfoutput>#Splaza#</cfoutput></cfif>">
	<input name="id_documento" type="hidden" value="<cfif isdefined("Form.id_documento")><cfoutput>#Form.id_documento#</cfoutput></cfif>">
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")><cfoutput>#Form.Pagina#</cfoutput></cfif>">
<!--- Objetos para el filtro de la lista de Documentos --->
	<input name="tituloFiltro" type="hidden" value="<cfif isdefined("Form.tituloFiltro")><cfoutput>#Form.tituloFiltro#</cfoutput></cfif>">
	<input name="cbTipoDocFiltro" type="hidden" value="<cfif isdefined("Form.cbTipoDocFiltro")><cfoutput>#Form.cbTipoDocFiltro#</cfoutput></cfif>">			
	<input name="cbTipoContFiltro" type="hidden" value="<cfif isdefined("Form.cbTipoContFiltro")><cfoutput>#Form.cbTipoContFiltro#</cfoutput></cfif>">	
	<input name="cbTipoMatFiltro" type="hidden" value="<cfif isdefined("Form.cbTipoMatFiltro")><cfoutput>#Form.cbTipoMatFiltro#</cfoutput></cfif>">	
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>

