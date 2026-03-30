<cf_dbfunction name="OP_concat" returnvariable="_Cat">
<cfif isdefined("url.DGAid") and not isdefined("form.DGAid")>
	<cfset form.DGAid = url.DGAid >
</cfif>
<cfif isdefined("url.DGCid") and not isdefined("form.DGCid")>
	<cfset form.DGCid = url.DGCid >
</cfif>
<cfif isdefined("url.pagenum_lista")>
	<cfset form.pagenum_lista = url.pagenum_lista >
</cfif>
<cfif not isdefined("form.pagenum_lista")>
	<cfset form.pagenum_lista = 1 >
</cfif>
<cfif isdefined("url.filtro_DGAcodigo")	and not isdefined("form.filtro_DGAcodigo")>
	<cfset form.filtro_DGAcodigo = url.filtro_DGAcodigo >
</cfif>
<cfif isdefined("url.filtro_DGAdescripcion")	and not isdefined("form.filtro_DGAdescripcion")>
	<cfset form.filtro_DGAdescripcion = url.filtro_DGAdescripcion >
</cfif>

<cfif not isdefined("form.DGAid")>
	<cf_errorCode	code = "50368" msg = "No se ha seleccionado la actividad.">
</cfif> 
<cfif not isdefined("form.DGCid")>
	<cf_errorCode	code = "50370" msg = "No se ha seleccionado el Concepto.">
</cfif> 

<cfoutput>
<form style="margin:0;" method="post" name="form5" id="form5" action="cuentaConceptoActividad-sql.cfm" >
<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
			<td>
				<table width="100%" cellpadding="2" cellspacing="0">
					<tr>
						<td><strong>Cuenta:&nbsp;</strong></td>
						<td>
						<cfif isdefined("data2.tipo") and data2.tipo eq 'O' >
							<cf_conlis
								campos="PCEcatid,PCDcatid,CodigoTipoGasto,CodigoGasto,NombreGasto"
								desplegables="N,N,S,S,S"
								modificables="N,N,N,N,N"
								size="0,0,5,5,40"
								title="Lista de Objetos de Gasto"
								tabla="dmf_ObjetoGasto"
								columnas="idTipoGasto as PCEcatid, idGasto as PCDcatid, CodigoTipoGasto, CodigoGasto,NombreGasto"
								filtro="1=1 order by CodigoTipoGasto, CodigoGasto"
								desplegar="CodigoTipoGasto,CodigoGasto,NombreGasto"
								filtrar_por="CodigoTipoGasto, CodigoGasto,NombreGasto"
								etiquetas="Tipo,Codigo,Descripción"
								formatos="S,S,S"
								align="left,left,left"
								asignar="PCEcatid,PCDcatid,CodigoTipoGasto, CodigoGasto,NombreGasto"
								asignarformatos="S,S,S,S,S"
								showEmptyListMsg="true"
								EmptyListMsg="-- No se encontraron Objetos de Gasto --"
								tabindex="1"
								form="form5"/>
						</td>
						
						<cfelse>
							<cf_conlis
								campos="PCEcatid,PCDcatid,CodigoLineaProducto,CodigoMarca, CodigoProducto,NombreProducto"
								desplegables="N,N,S,S,S,S"
								modificables="N,N,N,N,N,N"
								size="0,0,5,5,5,40"
								title="Lista de Producto"
								tabla="dmf_producto"
								columnas="idProducto as PCEcatid, idLineaProducto as PCDcatid,CodigoLineaProducto,CodigoMarca, CodigoProducto, NombreProducto"
								filtro="1=1 order by CodigoLineaProducto,CodigoMarca, CodigoProducto,NombreProducto"
								desplegar="CodigoLineaProducto,CodigoMarca, CodigoProducto,NombreProducto"
								filtrar_por="CodigoLineaProducto,CodigoMarca, CodigoProducto,NombreProducto"
								etiquetas="Linea, Marca, Producto, Descripción"
								formatos="S,S,S,S"
								align="left, left, left, left"
								asignar="PCEcatid,PCDcatid,CodigoLineaProducto,CodigoMarca, CodigoProducto,NombreProducto"
								asignarformatos="S,S,S,S,S,S"
								showEmptyListMsg="true"
								EmptyListMsg="-- No se encontraron Producto --"
								tabindex="1"
								form="form5"/>
						</cfif>
					</tr>
					<tr><td colspan="2" align="center"><cf_botones modo="ALTA" exclude="Limpiar"></td></tr>
				</table>
			</td>

			<input type="hidden" name="pagenum_lista" value="#form.pagenum_lista#"  /> 
			<input type="hidden" name="tab" value="2" /> 
			<input type="hidden" name="tab2" value="1" /> 
			<input type="hidden" name="DGAid" value="#form.DGAid#" />
			<input type="hidden" name="DGCid" value="#form.DGCid#" />
	
			<cfif isdefined("form.filtro_DGAcodigo") and len(trim(form.filtro_DGAcodigo))>
				<input type="hidden" name="filtro_DGAcodigo" value="#form.filtro_DGAcodigo#"  /> 
			</cfif>
			<cfif isdefined("form.filtro_DGAdescripcion") and len(trim(form.filtro_DGAdescripcion))>
				<input type="hidden" name="filtro_DGAdescripcion" value="#form.filtro_DGAdescripcion#"  /> 
			</cfif>
		
		<cf_qforms form="form5" objForm="objform5">
		<script language="javascript1.2" type="text/javascript">
			objform5.PCDcatid.required = true;
			objform5.PCDcatid.description = 'Departamento';	
		</script>		
		
	</tr>
	<tr>
		<td>
			<cf_dbfunction name="to_char"	args="a.idCat1" returnvariable="idCat1">
			<cf_dbfunction name="to_char"	args="a.idCat2" returnvariable="idCat2">
			<cfset navegacion = '&tab=2&tab2=1&DGAid=#form.DGAid#&DGCid=#form.DGCid#' >
			<cfif isdefined("data2.tipo") and data2.tipo eq 'O' >
				<cfquery datasource="#session.DSN#" name="rsLista">
					select a.idCat1,
						   a.idCat2,
						   b.NombreGasto as descripcion,
						   b.CodigoTipoGasto,
						   b.CodigoGasto,
						   '<img border=''0'' onClick=eliminarc('''#_Cat# #idCat1# #_Cat# ''',''' #_Cat# #idCat2# #_Cat# '''); src=''/cfmx/sif/imagenes/Borrar01_S.gif'' >' as eliminar
	
					from DGCuentasConceptoActEli a
					
					inner join dmf_ObjetoGasto b
					on b.idTipoGasto=a.idCat1
					and b.idGasto=a.idCat2
	
					where a.DGAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGAid#">
					and a.DGCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGCid#">
				</cfquery>
			<CFELSE>
				<cfquery datasource="#session.DSN#" name="rsLista">
					select a.idCat1,
						   a.idCat2,
						   c.NombreProducto as descripcion,
						   c.CodigoLineaProducto,
						   c.CodigoMarca, 
						   c.CodigoProducto,
						   '<img border=''0'' onClick=eliminarc('''#_Cat# #idCat1# #_Cat# ''',''' #_Cat# #idCat2# #_Cat# '''); src=''/cfmx/sif/imagenes/Borrar01_S.gif'' >' as eliminar
	
					from DGCuentasConceptoActEli a
					
					inner join dmf_producto c
					on c.idProducto=a.idCat1
					and c.idLineaProducto=a.idCat2
										
					where a.DGAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGAid#">
					and a.DGCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGCid#">
				</cfquery>
			</cfif>
			<cfif isdefined("data2.tipo") and data2.tipo eq 'O' >
				
				<cfinvoke
				component="sif.Componentes.pListas"
				method="pListaQuery"
				returnvariable="pListaRet"
				query="#rsLista#"
				desplegar="CodigoTipoGasto,CodigoGasto, descripcion,eliminar"
				etiquetas="Tipo,Código,Cuenta"
				formatos="S,S,S,S"
				align="left,left,left,center"
				ira="actividades-tabs.cfm"
				nuevo="actividades-tabs.cfm"
				showemptylistmsg="true"
				showlink="false"
				maxrows="30"
				incluyeForm="false"
				navegacion="#navegacion#"
				 />
			<cfelse>
			
				<cfinvoke
				component="sif.Componentes.pListas"
				method="pListaQuery"
				returnvariable="pListaRet"
				query="#rsLista#"
				desplegar="CodigoLineaProducto,CodigoMarca,CodigoProducto,descripcion,eliminar"
				etiquetas="Línea, Marca, Código, Cuenta"
				formatos="S,S,S,S,S"
				align="left,left,left,left,center"
				ira="actividades-tabs.cfm"
				nuevo="actividades-tabs.cfm"
				showemptylistmsg="true"
				showlink="false"
				maxrows="30"
				incluyeForm="false"
				navegacion="#navegacion#"
				 />
			</cfif>
		</td>
	</tr>
</table>
</form>
<script language="javascript1.2" type="text/javascript">
	function deshabilitarValidacion(){
		objform5.PCDcatid.required = false;			
	}

	function eliminarc(id,id2){
		if ( confirm('Desea eliminar la Cuenta?') ){
			deshabilitarValidacion();
			document.form5.action = 'cuentaConceptoActividad-sql.cfm?idEliminar='+id+'&idEliminar2='+id2;
			document.form5.submit();
		}
	}
</script>
</cfoutput>

