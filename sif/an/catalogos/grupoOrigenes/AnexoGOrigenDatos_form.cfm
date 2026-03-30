<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_GrupoODC" 	default="Grupo de Origenes de Datos para Calculo" returnvariable="LB_GrupoODC" xmlfile="AnexoGOrigenDatos_form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_GrupoOD" 	default="Grupo de Origenes de Datos"
 returnvariable="LB_GrupoOD" xmlfile="AnexoGOrigenDatos_form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_MarcaGrupoOD" 	default="Marque los Origenes de Datos que desea incluir en el Grupo"  returnvariable="LB_MarcaGrupoOD" xmlfile="AnexoGOrigenDatos_form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_IncluirEmpresa" 	default="Incluir Empresa"
 returnvariable="LB_IncluirEmpresa" xmlfile="AnexoGOrigenDatos_form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_IncluirOficinas" 	default="Incluir Oficinas de la Empresa"
 returnvariable="LB_IncluirOficinas" xmlfile="AnexoGOrigenDatos_form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_IncluirGpoOficinas" 	default="Incluir Grupo de Oficinas de la Empresa"  returnvariable="LB_IncluirGpoOficinas" xmlfile="AnexoGOrigenDatos_form.xml"/>
 <cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_IncluirGpoEmpresas" 	default="Incluir Grupo de Empresas"  returnvariable="LB_IncluirGpoEmpresas" xmlfile="AnexoGOrigenDatos_form.xml"/>
 

<cfquery datasource="#session.dsn#" name="rsForm">
	select GODid
	     , GODdescripcion
	     , ts_rversion
	
	  from AnexoGOrigenDatos
	 where Ecodigo = #session.Ecodigo#
	   and GODid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GODid#" null="#Len(form.GODid) Is 0#">
</cfquery>

<cfif rsForm.RecordCount EQ 0>
	<cfset MODO = "ALTA">
<cfelse>
	<cfset MODO = "CAMBIO">
</cfif>
<cfoutput>
<form name="form1" id="form1" method="post" action="AnexoGOrigenDatos_sql.cfm">
	<table summary="Tabla de entrada">
		<tr>
			<td colspan="2" class="subTitulo">
				<cfoutput>#LB_GrupoODC#</cfoutput>
			</td>
		</tr>

		<tr>
			<td valign="top">
				<strong><cfoutput>#LB_GrupoOD#</cfoutput></strong>
			</td>
			<td valign="top">

				<input type="text" name="GODdescripcion" id="GODdescripcion" 
						value="#HTMLEditFormat(rsForm.GODdescripcion)#" 
						size="40" maxlength="40"
						onfocus="this.select()"  
				>

			</td>
		</tr>

		<tr>
			<td colspan="2" class="formButtons">
			<cfif rsForm.RecordCount>
				<cf_botones  regresar='AnexoGOrigenDatos.cfm' modo='CAMBIO'>
			<cfelse>
				<cf_botones  regresar='AnexoGOrigenDatos.cfm' modo='ALTA'>
			</cfif>
			</td>
		</tr>
	</table>
	<input type="hidden" name="GODid" value="#HTMLEditFormat(rsForm.GODid)#">

	<cfset ts = "">
	<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
		artimestamp="#rsForm.ts_rversion#" returnvariable="ts">
	</cfinvoke>
	<input type="hidden" name="ts_rversion" value="#ts#">
	<cfif MODO NEQ "ALTA">
		<cfset fnTablaOrigenes()>
	</cfif>
</form>
<cf_qforms form="form1" objForm="LobjQForm">
</cf_qforms>
</cfoutput>

<cffunction name="fnTablaOrigenes">
	<table summary="Tabla de entrada">
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td colspan="3" class="subTitulo">
				<cfoutput>#LB_MarcaGrupoOD#</cfoutput>
			</td>
		</tr>
		<cfquery name="rsLista" datasource="#session.dsn#">
			select 	1 as orden
					, '*' as Codigo
					, e.Ecodigo  as EcodigoCal
					, d.Ocodigo
					, d.GEid
					, d.GOid
					, e.Edescripcion as Descripcion
					, d.GODDid
			  from Empresas e
			  		left join AnexoGOrigenDatosDet d
						 on d.Ecodigo 	 = #session.Ecodigo#
						and d.GODid		 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GODid#">
						and d.EcodigoCal = #session.Ecodigo#
						and d.Ocodigo 	is null
						and d.GEid		is null
						and d.GOid		is null
			  	where e.Ecodigo = #session.Ecodigo#
			UNION
			select 	2 as orden
					, e.Oficodigo as Codigo
					, e.Ecodigo as EcodigoCal
					, e.Ocodigo
					, d.GEid
					, d.GOid
					, e.Odescripcion as Descripcion
					, d.GODDid
			  from Oficinas e
			  		left join AnexoGOrigenDatosDet d
						 on d.Ecodigo 	 = #session.Ecodigo#
						and d.GODid		 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GODid#">
						and d.EcodigoCal = #session.Ecodigo#
						and d.Ocodigo 	 = e.Ocodigo
						and d.GEid		 is null
						and d.GOid		 is null
			  	where e.Ecodigo = #session.Ecodigo#
			UNION
			select 	3 as orden
					, e.GOcodigo as codigo
					, e.Ecodigo as EcodigoCal
					, d.Ocodigo
					, d.GEid
					, e.GOid
					, e.GOnombre as Descripcion
					, d.GODDid
			  from AnexoGOficina e
			  		left join AnexoGOrigenDatosDet d
						 on d.Ecodigo 	 = #session.Ecodigo#
						and d.GODid		 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GODid#">
						and d.EcodigoCal = #session.Ecodigo#
						and d.Ocodigo 	 is null
						and d.GEid		 is null
						and d.GOid		 = e.GOid
			  	where e.Ecodigo = #session.Ecodigo#
			UNION
			select 	4 as orden
					, e.GEcodigo as codigo
					, d.EcodigoCal
					, d.Ocodigo
					, e.GEid
					, d.GOid
					, e.GEnombre as Descripcion
					, d.GODDid
			  from AnexoGEmpresa e
					inner join AnexoGEmpresaDet gd
					   on e.GEid = gd.GEid
					  and gd.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			  		 left join AnexoGOrigenDatosDet d
					   on d.Ecodigo 	 = #session.Ecodigo#
					  and d.GODid		 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GODid#">
					  and d.EcodigoCal is null
					  and d.Ocodigo 	 is null
					  and d.GEid		= e.GEid	
					  and d.GOid		 is null
			  	where e.CEcodigo = #session.CEcodigo#
			order by orden
		</cfquery>

		<cfoutput group="orden" query="rsLista">
			<tr>
				<cfif rsLista.orden EQ 1>
				<td width="1">
					<input type="checkbox" 
							onclick="document.getElementById('ifrOPdet').src='AnexoGOrigenDatos_sql.cfm?OPdet=' + ((this.checked) ? 'A' : 'B') + '&GODid=#GODid#&EcodigoCal=#EcodigoCal#&R=' + Math.random();"
							<cfif GODDid NEQ "">checked</cfif>
					/>
				</td>
				<td colspan="2"><strong>#LB_IncluirEmpresa#:</strong> #Descripcion#</td>
				<cfelseif rsLista.orden EQ 2>
				<td colspan="3"><strong>#LB_IncluirOficinas#</strong></td>
				<cfelseif rsLista.orden EQ 3>
				<td colspan="3"><strong>#LB_IncluirGpoOficinas#</strong></td>
				<cfelseif rsLista.orden EQ 4>
				<td colspan="3"><strong>#LB_IncluirGpoEmpresas#</strong></td>
				</cfif>
				<td>
				</td>
			</tr>
			<cfoutput>
				<cfif rsLista.orden NEQ 1>
					<tr>
						<cfif rsLista.orden NEQ 1>
						<td width="1">
							<input type="checkbox" 
								onclick="document.getElementById('ifrOPdet').src='AnexoGOrigenDatos_sql.cfm?OPdet=' + ((this.checked) ? 'A' : 'B') + '&GODid=#GODid#&EcodigoCal=#EcodigoCal#&Ocodigo=#Ocodigo#&GOid=#GOid#&GEid=#GEid#&R=' + Math.random();"
								<cfif GODDid NEQ "">checked</cfif>
							/>
						</td>
						<td>#Codigo#</td>
						<td>#Descripcion#</td>
						</cfif>
					</tr>
				</cfif>
			</cfoutput>
		</cfoutput>
	</table>
	<iframe name="ifrOPdet"  id="ifrOPdet" width="0" height="0">
</cffunction>