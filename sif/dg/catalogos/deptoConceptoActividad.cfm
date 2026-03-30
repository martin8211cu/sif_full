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

<!--- lee la tabla de parametros para obtener el id de catalogo --->
<cfset vCatalogo = '' >
<cfquery name="rscatalogo" datasource="#session.DSN#">
	select Pvalor as valor
	from DGParametros
	where Pcodigo=10
</cfquery>
<cfif len(trim(rscatalogo.valor)) eq 0>
	<cfquery name="rsInsCatalogo" datasource="#session.DSN#">
		select min(PCEcatid) as valor
		from PCECatalogo
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	</cfquery>
	<cfif len(trim(rsInsCatalogo.valor))>
		<cfquery datasource="#session.DSN#">
			insert INTO DGParametros(Pcodigo, Pvalor, BMfechaalta, BMUsucodigo)
			values (	10, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsInsCatalogo.valor#">, 
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#"> )
		</cfquery>
		<cfset vCatalogo = rsInsCatalogo.valor >
	</cfif>
<cfelse>
	<cfset vCatalogo = rscatalogo.valor >
</cfif>
<cfif len(trim(vCatalogo)) eq 0>
	<cf_errorCode	code = "50369" msg = "No se puede recuperar el Catálogo del plan de Cuentas. Revise los parámetros de la apliación.">
</cfif>
<!--- =================================================================== --->

<cfoutput>
<form style="margin:0;" method="post" name="form4" id="form4" action="deptoConceptoActividad-sql.cfm" >
<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
			<td>
				<table width="100%" cellpadding="2" cellspacing="0">
					<tr>
						<td><strong>Departamento:&nbsp;</strong></td>
						<td>
						<cf_conlis
							campos="PCDcatid,PCDvalor,PCDdescripcion"
							desplegables="N,S,S"
							modificables="N,S,N"
							size="0,10,30"
							title="Lista de Departamentos"
							tabla="PCDCatalogo"
							columnas="PCDcatid,PCDvalor,PCDdescripcion"
							filtro="PCEcatid=#vCatalogo# order by PCDvalor, PCDdescripcion"
							desplegar="PCDvalor,PCDdescripcion"
							filtrar_por="PCDvalor,PCDdescripcion"
							etiquetas="Código,Descripción"
							formatos="S,S"
							align="left,left"
							asignar="PCDcatid,PCDvalor,PCDdescripcion"
							asignarformatos="S,S,S"
							showEmptyListMsg="true"
							EmptyListMsg="-- No se encontraron Departamentos --"
							tabindex="1"
							form="form4"/>
						</td>
					</tr>
					
					<tr>
						<td><strong>Concepto:&nbsp;</strong></td>
						<td>
							<cf_conlis
								campos="DGCid2, DGCcodigo, DGdescripcion"
								desplegables="N,S,S"
								modificables="N,S,N"
								size="0,10,30"
								title="Lista de Conceptos"
								tabla="DGConceptosER"
								columnas="DGCid as DGCid2, DGCcodigo, DGdescripcion"
								filtro="CEcodigo=#SESSION.CECODIGO# order by DGCcodigo, DGdescripcion"
								desplegar="DGCcodigo, DGdescripcion"
								filtrar_por="DGCcodigo, DGdescripcion"
								etiquetas="Código, Descripción"
								formatos="S,S"
								align="left,left"
								asignar="DGCid2, DGCcodigo, DGdescripcion"
								asignarformatos="S, S, S"
								showEmptyListMsg="true"
								EmptyListMsg="-- No se encontraron Conceptos --"
								tabindex="1"
								form="form4" >
						</td>
					</tr>
					
					<tr><td colspan="2" align="center"><cf_botones modo="ALTA" exclude="Limpiar"></td></tr>
				</table>
			</td>

			<input type="hidden" name="pagenum_lista" value="#form.pagenum_lista#"  /> 
			<input type="hidden" name="tab" value="2" /> 
			<input type="hidden" name="tab2" value="1" /> 
			<input type="hidden" name="DGAid" value="#form.DGAid#" />
			<input type="hidden" name="DGCid" value="#form.DGCid#" />
			<input type="hidden" name="PCEcatid" value="#vCatalogo#" />
	
			<cfif isdefined("form.filtro_DGAcodigo") and len(trim(form.filtro_DGAcodigo))>
				<input type="hidden" name="filtro_DGAcodigo" value="#form.filtro_DGAcodigo#"  /> 
			</cfif>
			<cfif isdefined("form.filtro_DGAdescripcion") and len(trim(form.filtro_DGAdescripcion))>
				<input type="hidden" name="filtro_DGAdescripcion" value="#form.filtro_DGAdescripcion#"  /> 
			</cfif>
		
		<cf_qforms form="form4" objForm="objForm4">
		<script language="javascript1.2" type="text/javascript">
			objForm4.PCDcatid.required = true;
			objForm4.PCDcatid.description = 'Departamento';	
			objForm4.DGCid2.required = true;
			objForm4.DGCid2.description = 'Concepto';	
		</script>		
		
	</tr>
	<tr>
		<td>
			<cfset navegacion = '&tab=2&tab2=1&DGAid=#form.DGAid#&DGCid=#form.DGCid#' >
            <cfinclude template="../../Utiles/sifConcat.cfm">
			<cf_dbfunction name="to_char"	args="a.DGCADid" returnvariable="DGCADid">
			<cfquery datasource="#session.DSN#" name="rsLista">
				select a.DGCADid,
						a.PCEcatid,
					   rtrim(b.PCDvalor) #_Cat#' - '#_Cat# b.PCDdescripcion as descripcion,	
					   rtrim(c.DGCcodigo) #_Cat#' - '#_Cat# c.DGdescripcion as Concepto,	
				 	   '<img border=''0'' onClick=eliminar2(''' #_Cat# #DGCADid# #_Cat# '''); src=''/cfmx/sif/imagenes/Borrar01_S.gif'' >' as eliminar
				from DGConceptosActividadDepto a
				
				inner join PCDCatalogo b
				on b.PCDcatid=a.PCDcatid
				
				left join DGConceptosER c
				on c.DGCid = a.DGCid2
									
				where a.DGAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGAid#">
				and a.DGCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGCid#">
				order by descripcion
			</cfquery>

			<cfinvoke
			component="sif.Componentes.pListas"
			method="pListaQuery"
			returnvariable="pListaRet"
			query="#rsLista#"
			desplegar="descripcion,concepto,eliminar"
			etiquetas="Departamento,Concepto"
			formatos="S,S,S"
			align="left,left,center"
			ira="actividades-tabs.cfm"
			nuevo="actividades-tabs.cfm"
			showemptylistmsg="true"
			showlink="false"
			maxrows="30"
			incluyeForm="false"
			navegacion="#navegacion#" />
		</td>
	</tr>
</table>
</form>
<script language="javascript1.2" type="text/javascript">
	function deshabilitarValidacion(){
		objForm4.PCDcatid.required = false;
		objForm4.DGCid2.required = false;
	}

	function eliminar2(id){
		if ( confirm('Desea eliminar el Departamento?') ){
			deshabilitarValidacion();
			document.form4.action = 'deptoConceptoActividad-sql.cfm?idEliminar='+id;
			document.form4.submit();
		}
	}
</script>
</cfoutput>


