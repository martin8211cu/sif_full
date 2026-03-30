
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


<cfset modo3 = 'ALTA'>
<cfif isdefined("form.DGAid") and len(trim(form.DGAid)) and isdefined("form.DGGDid") and len(trim(form.DGGDid)) >
	<cfset modo3 = 'CAMBIO'>

	<cfquery name="data" datasource="#session.DSN#">
		select a.DGAid, 
			   a.DGGDid, 
			   b.DGAcodigo, 
			   b.DGAdescripcion, 
			   c.DGGDcodigo, 
			   c.DGGDdescripcion, 
			   a.Criterio, 
			   a.ValorFactor,
			   a.DGCid,
			   a.DGCDid 
		from DGGastosActividad a
		
		inner join DGActividades b
		on b.DGAid=a.DGAid
		
		inner join DGGastosDistribuir c
		on  c.DGGDid = a.DGGDid
		
		where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#" >
		  and a.DGAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGAid#" > 
		  and a.DGGDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGGDid#" > 
	</cfquery>
	
	<cfif len(trim(data.DGCid))>
		<cfquery name="rsConceptos" datasource="#session.DSN#">
			select DGCid, DGCcodigo, DGdescripcion
			from DGConceptosER
			where DGCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.DGCid#">
		</cfquery>
		<cfset vConceptos[1] = rsConceptos.DGCid >
		<cfset vConceptos[2] = rsConceptos.DGCcodigo >
		<cfset vConceptos[3] = rsConceptos.DGdescripcion >
	</cfif>
	

	<cfif len(trim(data.DGCDid))>
		<cfquery name="rsCriterio" datasource="#session.DSN#">
			select DGCDid, DGCDcodigo, DGCDdescripcion
			from DGCriteriosDistribucion
			where DGCDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.DGCDid#">
		</cfquery>
		<cfset vCriterios[1] = rsCriterio.DGCDid >
		<cfset vCriterios[2] = rsCriterio.DGCDcodigo >
		<cfset vCriterios[3] = rsCriterio.DGCDdescripcion >
	</cfif>

</cfif>

<cfif not isdefined("rsGasto")>
	<cfquery name="rsGasto" datasource="#session.DSN#">
		select DGGDid, DGGDcodigo, DGGDdescripcion
		from DGGastosDistribuir
		where DGGDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGGDid#">
	</cfquery>
</cfif>

	<table width="100%" cellpadding="3" bgcolor="#ececff" >
		<tr><td align="center"><font color="#006699"><strong>Actividades</strong></font></td></tr>
		<tr><td align="center"><font color="#006699"><strong>Gasto:&nbsp;<cfoutput>#trim(rsGasto.DGGDcodigo)# - #rsGasto.DGGDdescripcion#</cfoutput></strong></font></td></tr>
	</table>
	<br />


<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td width="50%" valign="top">
			<CFOUTPUT>
			<form style="margin:0" action="gastosDistribuir-tabs.cfm" method="post" name="lista3" id="lista3" >
				<cfquery name="rsLista" datasource="#session.DSN#">
					select a.DGAid,b.DGAcodigo, b.DGAdescripcion, a.ValorFactor 
					from DGGastosActividad a
					
					inner join DGActividades b
					on b.DGAid=a.DGAid
					
					inner join DGGastosDistribuir c
					on  c.DGGDid = a.DGGDid
					
					where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#" >
					  and a.DGGDid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGGDid#" >
					order by b.DGAcodigo, b.DGAdescripcion
				</cfquery>
			
						<cfset navegacion = '&tab=3&DGGDid=#form.DGGDid#' >
						<cfinvoke
						component="sif.Componentes.pListas"
						method="pListaQuery"
						returnvariable="pListaRet"
						query="#rsLista#"
						desplegar="DGAcodigo, DGAdescripcion"
						etiquetas="C&oacute;dogo,Descripci&oacute;n"
						formatos="S,S"
						align="left,left"
						ira="gastosDistribuir-tabs.cfm"
						nuevo="gastosDistribuir-tabs.cfm"
						showemptylistmsg="true"
						maxrows="30"
						incluyeForm="false"
						navegacion="#navegacion#"
						formname="lista3" />
				<input type="hidden" name="tab" value="3" />

			<input type="hidden" name="pagenum_lista" value="#form.pagenum_lista#"  /> 
			<input type="hidden" name="DGGDid" value="#data.DGGDid#" />			

			<cfif isdefined("form.filtro_DGGDcodigo") and len(trim(form.filtro_DGGDcodigo))>
				<input type="hidden" name="filtro_DGGDcodigo" value="#form.filtro_DGGDcodigo#"  /> 
			</cfif>
			<cfif isdefined("form.filtro_DGGDdescripcion") and len(trim(form.filtro_DGGDdescripcion))>
				<input type="hidden" name="filtro_DGGDdescripcion" value="#form.filtro_DGGDdescripcion#"  /> 
			</cfif>

			<cfif isdefined("form.proceso")>
				<input type="hidden" name="proceso" value="ok" />
				<input type="hidden" name="periodo" value="#form.periodo#" />
				<input type="hidden" name="mes" value="#form.mes#" />
			</cfif>


			</form>			
			</CFOUTPUT>

		</td>

		<td width="50%" valign="top">
			<cfoutput>
			<form style="margin:0" action="gastosActividad-sql.cfm" method="post" name="form3" id="form3" >
			<table align="center" border="0" cellspacing="0" cellpadding="4" width="100%" >

				<tr>
					<td align="right" valign="middle" width="45%" nowrap="nowrap"><strong>Actividad:</strong></td>
					<td>
						<cfif modo3 neq 'ALTA'>
							#trim(data.DGAcodigo)# - #data.DGAdescripcion#
							<input type="hidden" name="DGAid" value="#data.DGAid#" />
						<cfelse>
							<cf_conlis
								campos="DGAid, DGAcodigo, DGAdescripcion"
								desplegables="N,S,S"
								modificables="N,S,N"
								size="0,10,30"
								title="Lista de Actividades"
								tabla="DGActividades"
								columnas="DGAid, DGAcodigo, DGAdescripcion"
								filtro="CEcodigo=#SESSION.CECODIGO# order by DGAcodigo, DGAdescripcion"
								desplegar="DGAcodigo, DGAdescripcion"
								filtrar_por="DGAcodigo, DGAdescripcion"
								etiquetas="Código, Descripción"
								formatos="S,S"
								align="left,left"
								asignar="DGAid, DGAcodigo, DGAdescripcion"
								asignarformatos="S, S, S"
								showEmptyListMsg="true"
								EmptyListMsg="-- No se encontraron Actividades --"
								tabindex="1"
								form="form3" >
						</cfif>
						
					</td>
				</tr>
				
				<!---
				<tr >
					<td align="right" valign="middle" width="1%" nowrap="nowrap"><strong>Valor/Factor:</strong></td>
					<td>
						<cfset valor = '' >
						<cfif modo3 neq 'ALTA'>
							<cfset valor = data.ValorFactor >
						</cfif>
						<cf_monto name="ValorFactor" size="17" value="#valor#" tabindex="1" >
					</td>
				</tr>
				--->
				
				<tr>
					<td colspan="4" align="center"><cf_botones modo="#modo3#" include="Regresar" tabindex="2"></td>
				</tr>
			</table>
			<input type="hidden" name="pagenum_lista" value="#form.pagenum_lista#"  /> 
			<input type="hidden" name="DGGDid" value="#data.DGGDid#" />			
			<input type="hidden" name="ValorFactor" value="0" />

			<cfif isdefined("form.filtro_DGGDcodigo") and len(trim(form.filtro_DGGDcodigo))>
				<input type="hidden" name="filtro_DGGDcodigo" value="#form.filtro_DGGDcodigo#"  /> 
			</cfif>
			<cfif isdefined("form.filtro_DGGDdescripcion") and len(trim(form.filtro_DGGDdescripcion))>
				<input type="hidden" name="filtro_DGGDdescripcion" value="#form.filtro_DGGDdescripcion#"  /> 
			</cfif>

			<input type="hidden" name="Criterio" value="0">
			
			
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


		
		<cf_qforms objForm="objForm3" form="form3">
		<script language="javascript1.2" type="text/javascript">
			<cfif modo3 eq 'ALTA'>
				objForm3.DGAid.required = true;
				objForm3.DGAid.description = 'Actividad';			
	
				objForm3.DGGDid.required = true;
				objForm3.DGGDid.description = 'Gasto por Distribuir';			
			</cfif>

			objForm3.ValorFactor.required = true;
			objForm3.ValorFactor.description = 'Valor/Factor';
			
			function deshabilitarValidacion(){
				objForm3.DGAid.required = false;
				objForm3.DGGDid.required = false;
				objForm3.ValorFactor.required = false;
			}
			
		</script>