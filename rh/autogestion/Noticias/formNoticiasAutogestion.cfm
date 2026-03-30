<cfinvoke Key="LB_RecursosHumanos" Default="Recursos Humanos" returnvariable="LB_RecursosHumanos" XmlFile="/rh/generales.xml" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Noticias" Default="Noticias de Autogesti&oacute;n" returnvariable="LB_Noticias" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_FechaDeLaNoticia" Default="Fecha de la Noticia" returnvariable="LB_FechaDeLaNoticia" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Titulo" Default="Titulo" returnvariable="LB_Titulo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_ListaDeCategorias" Default="Lista de Categor&iacute;as" returnvariable="LB_ListaDeCategorias" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_FechaDesde" Default="Fecha desde" returnvariable="LB_FechaDesde" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_FechaHasta" Default="Fecha hasta" returnvariable="LB_FechaHasta" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_CodigoCategoria" Default="C&oacute;digo categor&iacute;a" returnvariable="LB_CodigoCategoria" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_DescripcionCategoria" Default="Descripci&oacute;n categor&iacute;a" returnvariable="LB_DescripcionCategoria" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_DeseaEliminarElRegistro" Default="Desea eliminar el registro?" returnvariable="LB_DeseaEliminarElRegistro" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Contenido" Default="CONTENIDO" returnvariable="LB_Contenido" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Categoria" Default="Categoría" returnvariable="LB_Categoria" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Tipo" Default="Tipo" returnvariable="LB_Tipo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Modificar" Default="Modificar" returnvariable="LB_Modificar" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Eliminar" Default="Eliminar" returnvariable="LB_Eliminar" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Agregar" Default="Agregar" returnvariable="LB_Agregar" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Limpiar" Default="Limpiar" returnvariable="LB_Limpiar" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Nuevo" Default="Nuevo" returnvariable="LB_Nuevo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Regresar" Default="Regresar" returnvariable="LB_Regresar" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_ListaPuestos" Default="Lista de Puestos" returnvariable="LB_ListaPuestos" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Codigo" Default="C&oacute;digo" returnvariable="LB_Codigo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Descripcion" Default="Descripci&oacute;n" returnvariable="LB_Descripcion" component="sif.Componentes.Translate" method="Translate"/>

<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>
<cfset va_arrayCategoria=ArrayNew(1)>
<cfset va_arrayPuesto=ArrayNew(1)>
<cfif isdefined("url.IdNoticia") and len(trim(url.IdNoticia))>
	<cfset form.IdNoticia = url.IdNoticia>
</cfif>
<cfset modo = "ALTA">
<cfif isdefined("form.IdNoticia") and len(trim(form.IdNoticia)) and form.IdNoticia neq 0 >
	<cfset modo = "CAMBIO">
</cfif>
<cfif modo neq 'ALTA'>
	<cfquery datasource="#session.dsn#" name="data">
		select a.IdNoticia, a.FechaNoticia, a.Autor, a.Titulo, a.FechaDesde, a.FechaHasta, a.Ecodigo, a.CEcodigo, 
				a.IdCategoria, a.ts_rversion, a.Orden, a.Activa, a.Tipo,
				b.CodCategoria, b.DescCategoria
		from EncabNoticias a 
			inner join CategoriaNoticias b
				on a.IdCategoria = b.IdCategoria
		where IdNoticia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IdNoticia#">
			and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	</cfquery>
	<!---Carga arreglo del conlis de categorias--->
	<cfquery name="rsDetalle" datasource="#session.DSN#">
		select Contenido,RutaImagen
		from DetNoticias
		where IdNoticia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IdNoticia#"> 
	</cfquery>
	<cfif data.RecordCount NEQ 0 and len(trim(data.IdCategoria))>
		<cfset ArrayAppend(va_arrayCategoria, data.IdCategoria)>
	</cfif>
	<cfif data.RecordCount NEQ 0 and len(trim(data.CodCategoria))>
		<cfset ArrayAppend(va_arrayCategoria, data.CodCategoria)>
	</cfif>
	<cfif data.RecordCount NEQ 0 and len(trim(data.DescCategoria))>
		<cfset ArrayAppend(va_arrayCategoria, data.DescCategoria)>
	</cfif>	
	<!---Carga arreglo del conlis de puestos y de centro funcional--->
	<cfquery name="rsDetalleUsuarios" datasource="#session.DSN#">
		select CFid, RHPcodigo
		from DetUsuariosNoticias
		where IdNoticia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IdNoticia#"> 
	</cfquery>
	<cfif rsDetalleUsuarios.RecordCount NEQ 0>
		<cfif len(trim(rsDetalleUsuarios.CFid))>
			<cfquery name="rsCFuncional" datasource="#session.DSN#">
				select CFid as CFidI,CFcodigo as CFcodigoI, CFdescripcion as CFdescripcionI
				from CFuncional
				where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDetalleUsuarios.CFid#">
			</cfquery>
		</cfif>
		<cfif len(trim(rsDetalleUsuarios.RHPcodigo))>
			<cfquery name="rsPuesto" datasource="#session.DSN#">
				select RHPcodigo,RHPdescpuesto
				from RHPuestos
				where RHPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDetalleUsuarios.RHPcodigo#">
			</cfquery>
			<cfif rsPuesto.RecordCount NEQ 0 and len(trim(rsPuesto.RHPcodigo))>
				<cfset ArrayAppend(va_arrayPuesto, rsPuesto.RHPcodigo)>
			</cfif>
			<cfif rsPuesto.RecordCount NEQ 0 and len(trim(rsPuesto.RHPdescpuesto))>
				<cfset ArrayAppend(va_arrayPuesto, rsPuesto.RHPdescpuesto)>
			</cfif>
		</cfif>
	</cfif>
</cfif>

<!---Lista de imagenes subidas al servidor---->
<cfset rootdir = expandpath('')>
<cfset directorio = "#rootdir#/rh/autogestion/Noticias/Imagenes">
<cfset directorio = replace(directorio, '\', '/', 'all') >
<cfdirectory action="list" directory="#directorio#" name="imagenes">
<cfquery dbtype="query" name="imagenes">
	select *					     							 							
	from imagenes 
	where  Type != 'Dir'
</cfquery>
	<cfoutput>
	<form action="SQLNoticiasAutogestion.cfm"  method="post" name="form1" id="form1">
		<table width="100%" cellpadding="0" cellspacing="0" border="0">
			<!----Encabezado de la noticia----->
			<tr>
				<td width="18%" align="right"><strong>#LB_FechaDeLaNoticia#:&nbsp;</strong></td>
				<td width="33%">
					<cfif isdefined('data') and data.recordCount GT 0>
						<cfset fechaNoticia=LSDateFormat(data.FechaNoticia,'dd/mm/yyyy')> 						
					<cfelse>
						<cfset fechaNoticia=LSDateFormat(now(),'dd/mm/yyyy')> 								
					</cfif>		
					<cf_sifcalendario form="form1" value="#fechaNoticia#" name="FechaNoticia" index="1">	
				</td>
				<td width="14%" align="right"><strong>#LB_FechaDesde#:&nbsp;</strong></td>
				<td width="35%">
					<cfif isdefined('data') and data.recordCount GT 0>
						<cfset fechaDesde=LSDateFormat(data.FechaDesde,'dd/mm/yyyy')> 						
					<cfelse>
						<cfset fechaDesde=LSDateFormat(now(),'dd/mm/yyyy')> 								
					</cfif>		
					<cf_sifcalendario form="form1" value="#fechaDesde#" name="FechaDesde" index="6">	
				</td>
			</tr>
			<tr>
				<td align="right"><strong><cf_translate key="LB_Autor">Autor</cf_translate>:&nbsp;</strong></td>
				<td>
					 <input name="Autor" size="40" id="Autor" type="text" value="<cfif modo NEQ 'ALTA'>#trim(data.Autor)#</cfif>" maxlength="260" onfocus="this.select()" tabindex="2">
				</td>
				<td align="right"><strong>#LB_FechaHasta#:&nbsp;</strong></td>
				<td>
					<cfif isdefined('data') and data.recordCount GT 0>
						<cfset fechaHasta=LSDateFormat(data.FechaHasta,'dd/mm/yyyy')> 						
					<cfelse>
						<cfset fechaHasta=LSDateFormat(now(),'dd/mm/yyyy')> 								
					</cfif>		
					<cf_sifcalendario form="form1" value="#fechaHasta#" name="FechaHasta" index="7">	
				</td>
			</tr>
			<tr>
				<td align="right"><strong>#LB_Categoria#:&nbsp;</strong></td>
				<td>
					<cf_conlis title="#LB_ListaDeCategorias#"
					campos = "IdCategoria,CodCategoria,DescCategoria" 
					desplegables = "N,S,S" 
					modificables = "N,S,N" 
					size = "0,7,25"
					asignar="IdCategoria,CodCategoria,DescCategoria"
					asignarformatos="I,S,S"
					tabla="	CategoriaNoticias a"																	
					columnas="IdCategoria,CodCategoria,DescCategoria"
					filtro="a.CEcodigo =#session.CEcodigo#"
					desplegar="CodCategoria,DescCategoria"
					etiquetas="	#LB_CodigoCategoria#, 
								#LB_DescripcionCategoria#"
					formatos="S,S"
					align="left,left"
					showEmptyListMsg="true"
					debug="false"
					form="form1"
					width="800"
					height="500"
					left="70"
					top="20"
					filtrar_por="CodCategoria,DescCategoria"
					valuesarray="#va_arrayCategoria#"
					index="3"> 
				</td>
				<td align="right"><strong><cf_translate key="LB_Imagen">Imagen</cf_translate>:&nbsp;</strong></td>
				<td nowrap>
					<table width="100%" border="0">
						<tr>
							<td nowrap>									
								<CFIF imagenes.RecordCount NEQ 0 and len(trim(imagenes.directory))>
									<cfset ruta = replace(imagenes.directory, '\', '/', 'all') >
									<cfset ruta = MID(ruta, find('/rh/', ruta, 0),LEN(ruta)) >																			
								</CFIF>
								<select name="RutaImagen" tabindex="8">
									<option id=""><cf_translate key="LB_Ninguna">Ninguna</cf_translate></option>
									<cfloop query="imagenes">
										<option value="/cfmx#ruta#/#imagenes.name#" 
											<cfif modo NEQ 'ALTA' and isdefined("rsDetalle") and rsDetalle.RutaImagen EQ '/cfmx#ruta#/#imagenes.name#'>selected</cfif>>
											#imagenes.name#
										</option>
									</cfloop>
								</select>																					
							</td>								
							<td>
								<a href="GuardarImagenes.cfm?Noticia=1<cfif modo NEQ 'ALTA'>&Idnoticia=#data.IdNoticia#</cfif>" tabindex="8">[<cf_translate key="LB_NuevaImagen">Nueva Imagen</cf_translate>]</a>		
							</td>
						</tr>
					</table>								
				</td>
			</tr>
			<tr>
				<td align="right"><strong>#LB_Titulo#:&nbsp;</strong></td>
				<td>
					<input name="Titulo" size="40" id="Titulo" type="text" value="<cfif modo NEQ 'ALTA'>#trim(data.Titulo)#</cfif>" maxlength="60" onfocus="this.select()" tabindex="4">
				</td>
				<td align="right" nowrap><strong><cf_translate key="LB_OrdenAparicion">Orden de aparici&oacute;n</cf_translate>:&nbsp;</strong></td>
				<td>
					 <input name="Orden" size="5" id="Orden" type="text" value="<cfif modo NEQ 'ALTA'>#trim(data.Orden)#</cfif>" maxlength="5" onfocus="this.select()" tabindex="9">
				</td>
			</tr>
			<tr>
				<td align="right"><strong>#LB_Tipo#:&nbsp;</strong></td>
				<td>
					<select name="Tipo" tabindex="5">
						<option value="1" <cfif modo NEQ 'ALTA' and data.Tipo EQ 1>selected</cfif>><cf_translate key="LB_Noticia">Noticia</cf_translate></option>
						<option value="2" <cfif modo NEQ 'ALTA' and data.Tipo EQ 2>selected</cfif>><cf_translate key="LB_SitioDeInteres">Sitio de Inter&eacute;s</cf_translate></option>
					</select>
				</td>
				<td align="right"><strong><cf_translate key="LB_NoticiaActiva">Noticia Activa</cf_translate>:&nbsp;</strong></td>
				<td>
					 <input name="Activa" id="Activa" type="checkbox" <cfif modo NEQ 'ALTA' and data.Activa EQ 1>checked</cfif> onfocus="this.select()" tabindex="10">
				</td>
			</tr>																			
			<tr><td>&nbsp;</td></tr>
			<tr>			
				<td colspan="4" class="formButtons" align="center">
					<cfif modo eq 'ALTA'>
						<input type="submit" name="Alta" value="#LB_Agregar#" onClick="javascript: habilitarValidacion();" tabindex="1">
						<input type="reset" name="Limpiar" value="#LB_Limpiar#" tabindex="1">
					<cfelse>
						<input type="submit" name="Cambio" value="#LB_Modificar#" onClick="habilitarValidacion();" tabindex="1">
						<input type="submit" name="Baja" value="#LB_Eliminar#" onClick="if ( confirm('#LB_DeseaEliminarElRegistro#') ){deshabilitarValidacion(); return true;} return false;" tabindex="1">
						<input type="submit" name="Nuevo" value="#LB_Nuevo#" onClick="deshabilitarValidacion();" tabindex="1">
					</cfif>
					<input type="button" name="btnRegresar" value="#LB_Regresar#" onClick="javascript: funcRegresarLista();">
				</td>
			</tr>
			<!---Detalle de la noticia (Contenido)---->
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td colspan="4"><hr></td>
			</tr>				
			<tr><td align="center" colspan="4"><strong>#LB_Contenido#</strong></td></tr>
			<tr>			
				<td colspan="4">
					<strong>
						<cfset miHTML = "">
						<cfif isdefined("rsDetalle") and rsDetalle.RecordCount NEQ 0>
							<cfset miHTML = rsDetalle.Contenido>
						</cfif>		
					</strong>			
					<strong>
						<cf_sifeditorhtml name="Contenido" indice="11" value="#miHTML#" height="350" toolbarset="Default">
					</strong>
				</td>
			</tr>			
			<tr><td>&nbsp;</td></tr>
			<tr>			
				<td colspan="4" class="formButtons" align="center">
					<cfif modo eq 'ALTA'>
						<input type="submit" name="Alta" value="#LB_Agregar#" onClick="javascript: habilitarValidacion();" tabindex="1">
						<input type="reset" name="Limpiar" value="#LB_Limpiar#" tabindex="1">
					<cfelse>
						<input type="submit" name="Cambio" value="#LB_Modificar#" onClick="habilitarValidacion();" tabindex="1">
						<input type="submit" name="Baja" value="#LB_Eliminar#" onClick="if ( confirm('#LB_DeseaEliminarElRegistro#') ){deshabilitarValidacion(); return true;} return false;" tabindex="1">
						<input type="submit" name="Nuevo" value="#LB_Nuevo#" onClick="deshabilitarValidacion();" tabindex="1">
					</cfif>
					<input type="button" name="btnRegresar" value="#LB_Regresar#" onClick="javascript: funcRegresarLista();">
				</td>
			</tr>
		</table>
		<cfif modo neq 'ALTA'>
			<input type="hidden" name="IdNoticia" value="#data.IdNoticia#">
			<cfset ts = "">
				<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
					artimestamp="#data.ts_rversion#" returnvariable="ts">
				</cfinvoke>
			<input type="hidden" name="ts_rversion" value="#ts#">
		</cfif>
	</form>
	</cfoutput>
	
	<script language="JavaScript" type="text/javascript">	
		qFormAPI.errorColor = "#FFFFCC";
		objForm = new qForm("form1");
		<cfoutput>
		objForm.FechaNoticia.required = true;
		objForm.FechaNoticia.description="#LB_FechaDeLaNoticia#";				
		objForm.IdCategoria.required= true;
		objForm.IdCategoria.description="#LB_Categoria#";	
		objForm.Titulo.required= true;
		objForm.Titulo.description="#LB_Titulo#";	
		objForm.FechaDesde.required= true;
		objForm.FechaDesde.description="#LB_FechaDesde#";
		objForm.FechaHasta.required= true;
		objForm.FechaHasta.description="#LB_FechaHasta#";	
		/*objForm.Contenido.required= true;
		objForm.Contenido.description="#LB_Contenido#";	*/
	
		</cfoutput>
		function habilitarValidacion(){
			objForm.FechaNoticia.required = true;
			objForm.IdCategoria.required = true;
			objForm.Titulo.required = true;
			objForm.FechaDesde.required = true;
			objForm.FechaHasta.required = true;
			//objForm.Contenido.required= true;
		}
	
		function deshabilitarValidacion(){
			objForm.FechaNoticia.required = false;
			objForm.IdCategoria.required = false;
			objForm.Titulo.required = false;
			objForm.FechaDesde.required = false;
			objForm.FechaHasta.required = false;
			//objForm.Contenido.required= false;
		}
		
		function funcRegresarLista(){
			location.href = 'NoticiasAutogestion.cfm';
		}
		
	</script>
