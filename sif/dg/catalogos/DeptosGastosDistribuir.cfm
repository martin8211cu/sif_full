
<cfif isdefined("url.DGGDid") and not isdefined("form.DGGDid")>
	<cfset form.DGGDid = url.DGGDid >
</cfif>
<cfif isdefined("url.pagenum_lista")>
	<cfset form.pagenum_lista = url.pagenum_lista >
<cfelse>
	<cfset form.pagenum_lista = 1 >
</cfif>
<cfif isdefined("url.filtro_DGGDcodigo")	and not isdefined("form.filtro_DGGDcodigo")>
	<cfset form.filtro_DGGDcodigo = url.filtro_DGGDcodigo >
</cfif>
<cfif isdefined("url.filtro_DGGDdescripcion")	and not isdefined("form.filtro_DGGDdescripcion")>
	<cfset form.filtro_DGGDdescripcion = url.filtro_DGGDdescripcion >
</cfif>

<cfif isdefined("url.proceso") and not isdefined("form.proceso")>
	<cfset form.proceso = url.proceso >
</cfif>
<cfif isdefined("url.periodo") and not isdefined("form.periodo")>
	<cfset form.periodo = url.periodo >
</cfif>
<cfif isdefined("url.mes") and not isdefined("form.mes")>
	<cfset form.mes = url.mes >
</cfif>


<!--- =================================================================== --->
<!--- =================================================================== --->
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
<!--- =================================================================== --->

<cfset modo2 = 'ALTA'>
<cfif isdefined("form.DGGDid") and len(trim(form.DGGDid)) and isdefined("form.PCEcatid") and len(trim(form.PCEcatid)) and isdefined("form.PCDcatid") and len(trim(form.PCDcatid)) >
	<cfset modo2 = 'CAMBIO'>

	<cfquery name="data" datasource="#session.DSN#">
		select a.DGGDid, 
			  b.DGGDcodigo,
			  b.DGGDdescripcion, 
			  a.PCDcatid, 
			  c.PCDvalor, 
			  c.PCDdescripcion, 
			  a.PCEcatid,
			  d.PCEcodigo,
			  d.PCEdescripcion,
			  a.Ecodigo,
			  e.Edescripcion ,
			  a.Elimina
		
		from DGDeptosGastosDistribuir a
		
		inner join DGGastosDistribuir b
		on b.DGGDid=a.DGGDid
		and b.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#" >
		
		inner join PCDCatalogo c
		on c.PCDcatid=a.PCDcatid
		
		inner join PCECatalogo d
		on d.PCEcatid=a.PCEcatid
	    and d.PCEcatid=c.PCEcatid 

		inner join Empresas e
		on e.Ecodigo=a.Ecodigo
		and e.cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#" >
		
		
		where a.DGGDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGGDid#">
		  and a.PCEcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEcatid#">
		  and a.PCDcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCDcatid#">
  		  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Empresa#">
	</cfquery>
</cfif>

	<cfquery name="rsGasto" datasource="#session.DSN#">
		select DGGDid, DGGDcodigo, DGGDdescripcion
		from DGGastosDistribuir
		where DGGDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGGDid#">
	</cfquery>


	<table width="100%" cellpadding="3" bgcolor="#ececff" >
		<tr><td align="center"><font color="#006699"><strong>Departamentos que integran una cuenta de Gastos por Distribuir</strong></font></td></tr>
		<tr><td align="center"><font color="#006699"><strong>Gasto:&nbsp;<cfoutput>#trim(rsGasto.DGGDcodigo)# - #rsGasto.DGGDdescripcion#</cfoutput></strong></font></td></tr>
	</table>
	<br />

<table width="100%" cellspacing="2" cellspacing="0" >
	<tr>
		<td valign="top" width="50%">
        	<cfinclude template="../../Utiles/sifConcat.cfm">
			<CFOUTPUT>

			<form style="margin:0" action="gastosDistribuir-tabs.cfm" method="post" name="lista2" id="lista2" >
				<cfquery name="rsLista" datasource="#session.DSN#">
					select 
						  rtrim(b.DGGDcodigo)#_Cat#' - '#_Cat#b.DGGDdescripcion as gasto, 
						  a.PCDcatid, 
						  rtrim(c.PCDvalor) #_Cat#' - '#_Cat# c.PCDdescripcion as PCDdescripcion, 
						  a.PCEcatid
					
					from DGDeptosGastosDistribuir a
					
					inner join DGGastosDistribuir b
					on b.DGGDid=a.DGGDid
					and b.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#" >
					
					inner join PCDCatalogo c
					on c.PCDcatid=a.PCDcatid
					
					where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#" >
					  and a.DGGDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGGDid#" >
			
					order by b.DGGDcodigo, c.PCDvalor
				</cfquery>
			
						<cfset navegacion = '&tab=2&DGGDid=#form.DGGDid#' >
						<cfinvoke
						component="sif.Componentes.pListas"
						method="pListaQuery"
						returnvariable="pListaRet"
						query="#rsLista#"
						desplegar="PCDdescripcion"
						etiquetas="Departamento"
						formatos="S"
						align="left"
						ira="gastosDistribuir-tabs.cfm"
						nuevo="gastosDistribuir-tabs.cfm"
						showemptylistmsg="true"
						maxrows="30"
						incluyeForm="false"
						navegacion="#navegacion#"
						formname="lista2" />
				<input type="hidden" name="tab" value="2" />

			<input type="hidden" name="pagenum_lista" value="#form.pagenum_lista#"  /> 

			<cfif isdefined("form.filtro_DGGDcodigo") and len(trim(form.filtro_DGGDcodigo))>
				<input type="hidden" name="filtro_DGGDcodigo" value="#form.filtro_DGGDcodigo#"  /> 
			</cfif>
			<cfif isdefined("form.filtro_DGGDdescripcion") and len(trim(form.filtro_DGGDdescripcion))>
				<input type="hidden" name="filtro_DGGDdescripcion" value="#form.filtro_DGGDdescripcion#"  /> 
			</cfif>

			<input type="hidden" name="DGGDid" value="#form.DGGDid#" />
			<input type="hidden" name="Empresa" value="#session.Ecodigo#" />			

			<cfif isdefined("form.proceso")>
				<input type="hidden" name="proceso" value="ok" />
				<input type="hidden" name="periodo" value="#form.periodo#" />
				<input type="hidden" name="mes" value="#form.mes#" />
			</cfif>

			</form>			
</CFOUTPUT>
		</td>

		<td valign="top" width="50%">
			<cfoutput>
			<form style="margin:0" action="DeptosGastosDistribuir-sql.cfm" method="post" name="form2" id="form2" >
			<table align="center" border="0" cellspacing="0" cellpadding="4" width="100%" >

				<tr>
					<td align="right" valign="middle" nowrap="nowrap" <cfif modo2 neq 'ALTA'>width="35%"</cfif> ><strong>Departamento:</strong></td>
					<td>
						<cfif modo2 neq 'ALTA'>
							#trim(data.PCDvalor)# - #data.PCDdescripcion#
							<input type="hidden" name="PCDcatid" value="#data.PCDcatid#" />
						<cfelse>
						<cf_conlis
							campos="PCDcatid, PCDvalor, PCDdescripcion"
							desplegables="N,S,S"
							modificables="N,S,N"
							size="0,10,30"
							title="Lista de Departamentos"
							tabla="PCDCatalogo"
							columnas="PCDcatid, PCDvalor, PCDdescripcion"
							filtro="PCEcatid=#vCatalogo# order by PCDvalor, PCDdescripcion"
							desplegar="PCDvalor, PCDdescripcion"
							filtrar_por="PCDvalor, PCDdescripcion"
							etiquetas="Código, Descripción"
							formatos="S,S"
							align="left,left"
							asignar="PCDcatid, PCDvalor, PCDdescripcion"
							asignarformatos="S, S, S"
							showEmptyListMsg="true"
							EmptyListMsg="-- No se encontraron Departamentos --"
							tabindex="1"
							form="form2" >
						</cfif>
						<input type="hidden" name="PCEcatid" value="#vCatalogo#" />
					</td>
				</tr>
				
				<!---
				<TR>
					<td></td>
					<td>
						<table width="100%" cellpadding="1" cellspacing="0">
							<tr>
								<td width="1%" valign="middle"><input name="Elimina" type="checkbox" <cfif modo2 neq 'ALTA' and data.Elimina eq 1>checked="checked"</cfif> /></td>
								<td valign="middle">Se elimina </td>
							</tr>
						</table>
					</td>
				</TR>
				--->

				<tr>
					<td colspan="4" align="center"><cf_botones modo="#modo2#" include="Regresar" tabindex="2"></td>
				</tr>
			</table>

			<input type="hidden" name="pagenum_lista" value="#form.pagenum_lista#"  /> 
			<input name="Elimina" type="hidden" value="0" />

			<cfif isdefined("form.filtro_DGGDcodigo") and len(trim(form.filtro_DGGDcodigo))>
				<input type="hidden" name="filtro_DGGDcodigo" value="#form.filtro_DGGDcodigo#"  /> 
			</cfif>
			<cfif isdefined("form.filtro_DGGDdescripcion") and len(trim(form.filtro_DGGDdescripcion))>
				<input type="hidden" name="filtro_DGGDdescripcion" value="#form.filtro_DGGDdescripcion#"  /> 
			</cfif>

			<input type="hidden" name="DGGDid" value="#form.DGGDid#" />
			<input type="hidden" name="Empresa" value="#session.Ecodigo#" />			

			<cfif isdefined("form.proceso")>
				<input type="hidden" name="proceso" value="ok" />
				<input type="hidden" name="periodo" value="#form.periodo#" />
				<input type="hidden" name="mes" value="#form.mes#" />
			</cfif>

		</form>
		</cfoutput>
		</td>
	</tr>
</table>

		<cf_qforms objForm="objForm2" form="form2">
		<script language="javascript1.2" type="text/javascript">
				objForm2.DGGDid.required = true;
				objForm2.DGGDid.description = 'Gasto';			
	
				objForm2.PCEcatid.required = true;
				objForm2.PCEcatid.description = 'Catálogo';			

				objForm2.PCDcatid.required = true;
				objForm2.PCDcatid.description = 'Departamento';

				objForm2.Empresa.required = true;
				objForm2.Empresa.description = 'Empresa';

			
			function deshabilitarValidacion(){
				objForm2.DGGDid.required = false;
				objForm2.PCEcatid.required = false;
				objForm2.PCDcatid.required = false;
				objForm2.Empresa.required = false;
			}
		</script>
		


