<cf_dbfunction name="OP_concat" returnvariable="_Cat">
<cfif isdefined("url.DGAid") and not isdefined("form.DGAid")>
	<cfset form.DGAid = url.DGAid >
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
	<cfquery name="rsActividad" datasource="#session.DSN#">
		select DGAid, DGAcodigo, DGAdescripcion
		from DGActividades
		where DGAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGAid#">
	</cfquery>

	<table width="100%" cellpadding="3" bgcolor="##ececff" >
		<tr><td align="center"><font color="##006699"><strong>Departamentos</strong></font></td></tr>
		<tr><td align="center"><font color="##006699"><strong>Actividad:&nbsp;<cfoutput>#trim(rsActividad.DGAcodigo)# - #rsActividad.DGAdescripcion#</cfoutput></strong></font></td></tr>
	</table>
	<br />

<form style="margin:0;" method="post" name="form8" id="form8" action="departamentosActividad-sql.cfm" >
<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td valign="top">
			<cfset navegacion = '&tab=3&DGAid=#form.DGAid#' >
			<cf_dbfunction name="to_char"	args="a.PCDcatid" returnvariable="PCDcatid">
			<cfquery datasource="#session.DSN#" name="rsLista">
				select  b.PCDvalor as valor,
					   b.PCDdescripcion as descripcion,	
				 	   '<img border=''0'' onClick=eliminar8('''#_Cat#  #PCDcatid# #_Cat# '''); src=''/cfmx/sif/imagenes/Borrar01_S.gif'' >' as eliminar
				from DGDepartamentosA a
				
				inner join PCDCatalogo b
				on b.PCDcatid=a.PCDcatid
									
				where a.DGAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGAid#">
				order by valor
			</cfquery>

			<cfinvoke
			component="sif.Componentes.pListas"
			method="pListaQuery"
			returnvariable="pListaRet"
			query="#rsLista#"
			desplegar="valor,descripcion,eliminar"
			etiquetas="Departamento,Descripcion"
			formatos="S,s,S"
			align="left,left,center"
			ira="actividades-tabs.cfm"
			nuevo="actividades-tabs.cfm"
			showemptylistmsg="true"
			showlink="false"
			maxrows="30"
			incluyeForm="false"
			navegacion="#navegacion#" />
		</td>

			<td valign="top">
				<table width="100%" cellpadding="2" cellspacing="0">
					<tr>
						<td align="right"><strong>Departamento:&nbsp;</strong></td>
						<td>
						<cf_conlis
							campos="PCDcatid,PCDvalor,PCDdescripcion"
							desplegables="N,S,S"
							modificables="N,S,N"
							size="0,10,30"
							title="Lista de Departamentos"
							tabla="PCDCatalogo a"
							columnas="a.PCDcatid,a.PCDvalor,a.PCDdescripcion"
							filtro="a.PCEcatid=#vCatalogo# 
									and not exists (  	select 1 
														from DGDepartamentosA b
														where b.PCEcatid=a.PCEcatid
															and b.PCDcatid=a.PCDcatid )
									order by a.PCDvalor, a.PCDdescripcion"
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
							form="form8"/>
						</td>
					</tr>
					<tr><td colspan="2" align="center"><cf_botones modo="ALTA" exclude="Limpiar"></td></tr>
				</table>
			</td>

			<input type="hidden" name="pagenum_lista" value="#form.pagenum_lista#"  /> 
			<input type="hidden" name="tab" value="2" /> 
			<input type="hidden" name="tab2" value="1" /> 
			<input type="hidden" name="DGAid" value="#form.DGAid#" />
			<input type="hidden" name="PCEcatid" value="#vCatalogo#" />
	
			<cfif isdefined("form.filtro_DGAcodigo") and len(trim(form.filtro_DGAcodigo))>
				<input type="hidden" name="filtro_DGAcodigo" value="#form.filtro_DGAcodigo#"  /> 
			</cfif>
			<cfif isdefined("form.filtro_DGAdescripcion") and len(trim(form.filtro_DGAdescripcion))>
				<input type="hidden" name="filtro_DGAdescripcion" value="#form.filtro_DGAdescripcion#"  /> 
			</cfif>
		
		<cf_qforms form="form8" objForm="objform8">
		<script language="javascript1.2" type="text/javascript">
			objform8.PCDcatid.required = true;
			objform8.PCDcatid.description = 'Departamento';	
		</script>		
		
	</tr>
</table>
</form>
<script language="javascript1.2" type="text/javascript">
	function deshabilitarValidacion(){
		objform8.PCDcatid.required = false;			
	}

	function eliminar8(id){
		if ( confirm('Desea eliminar el Departamento?') ){
			deshabilitarValidacion();
			document.form8.action = 'departamentosActividad-sql.cfm?idEliminar='+id;
			document.form8.submit();
		}
	}
</script>
</cfoutput>

