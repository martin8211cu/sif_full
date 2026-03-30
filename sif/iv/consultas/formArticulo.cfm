<cffunction name="get_articulo" access="public" returntype="query">
	<cfargument name="acodigo" type="numeric" required="true" default="<!--- Código de la línea de Título --->">
	<cfquery name="rsget_articulo" datasource="#session.DSN#" >
		select rtrim(Adescripcion) as Adescripcion from Articulos
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and Acodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#acodigo#">
	</cfquery>
	<cfreturn #rsget_articulo#>
</cffunction>

<cffunction name="get_acodigo" access="public" returntype="query">
	<cfargument name="aid" type="numeric" required="true" default="<!--- Código de la línea de Título --->">
	<cfquery name="rsget_acodigo" datasource="#session.DSN#" >
		select Acodigo from Articulos
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#aid#">
	</cfquery>
	<cfreturn #rsget_acodigo#>
</cffunction>

<cfquery datasource="#session.DSN#" name="rsEmpresa">
	select Edescripcion from Empresas
 	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<!--- <cf_sifHTML2Word Titulo="Artículos"> --->

<!--- ======================================================================================================================= --->
<!---   														Rangos														  --->		
<!--- ======================================================================================================================= --->

<!--- 	Validacion de Rangos, valida lo siguiente: 
		1. Asume que Aid, siempre viene, pues hay otras consultas que llaman a esta consulta, y 
		   le mandan el Aid. ( esto podria cambiarse para que devuelva todos los articulos existentes )
		2. Si no existe form.AidF, a la variable acodigof le asigna el valor de acodigoi
		3. Si existe un rango de articulos, debe validar ese rango desde un articulo menor hasta uno mayor, por el Acodigo.
		   Esto para que el select de articulos devuelva los articulos en el orden en que el conlis de seleccion los muestra, 
		   y el conlis de seleccion lo hace por Acodigo y NO por Aid


--->
<cfset acodigoi = "">
<cfset acodigof = "">
<cfif isdefined("form.Aid") and form.Aid neq "" >
	<cfset acodigoi = #get_acodigo(form.Aid).Acodigo# >
</cfif>

<cfif isdefined("form.AidF") and form.AidF neq "" >
	<cfset acodigof = #get_acodigo(form.AidF).Acodigo# >
</cfif>

<cfif isdefined("url.Aid")>
	<cfset acodigof = acodigoi>
</cfif>

<cfif acodigoi neq "" and acodigof neq "" and (compareNoCase(acodigoi, acodigof) eq 1) >
	<cfset tmp      = acodigoi>
	<cfset acodigoi = acodigof>	
	<cfset acodigof = tmp>	
</cfif>

<!--- Clasificaciones --->
<cfset ccodigoi = -1>
<cfset ccodigof = -1>

<cfif isdefined("form.Ccodigo") and len(trim(form.Ccodigo)) >
	<cfset ccodigoi = form.Ccodigo >
</cfif>

<cfif isdefined("form.CcodigoF") and len(trim(form.CcodigoF))>
	<cfset ccodigof = form.CcodigoF >
</cfif>

<cfif isdefined("url.Ccodigo") and len(trim(url.Ccodigo))>
	<cfset ccodigof = ccodigoi>
</cfif>

<cfif ccodigoi neq -1 and ccodigof neq -1 and (ccodigoi gt ccodigof) >
	<cfset tmp      = ccodigoi>
	<cfset ccodigoi = ccodigof>	
	<cfset ccodigof = tmp>	
</cfif>

<!--- ======================================================================================================================= --->
<!--- ======================================================================================================================= --->
<form name="form1" method="post">

<cfif isdefined("form.toExcel")>
	<cfcontent type="application/msexcel">
	<cfheader 	name="Content-Disposition" 
	value="attachment;filename=ArticulosInventario_#session.Usucodigo#_#LSDateFormat(now(), 'yyyymmdd')#_#LSTimeFormat(now(),'HHMmSs')#.xls" >
</cfif>
	<style type="text/css">
		.encabReporte {
			background-color: #006699;
			font-weight: bold;
			color: #FFFFFF;
			padding-top: 2px;
			padding-bottom: 2px;
		}
		.topline {
			border-top-width: 1px;
			border-top-style: solid;
			border-right-style: none;
			border-bottom-style: none;
			border-left-style: none;
			border-top-color: #CCCCCC;
		}
		.bottomline {
			border-bottom-width: 1px;
			border-bottom-style: solid;
			border-right-style: none;
			border-top-style: none;
			border-left-style: none;
			border-bottom-color: #CCCCCC;
		}
		.subTituloRep {
			font-weight: bold; 
			font-size: x-small; 
			background-color: #F5F5F5;
		}
	}
	</style>
  <table width="100%" border="0" cellspacing="0" cellpadding="1" style="padding-left: 5px; padding-right: 10px" align="center">
    <tr> 
      <td colspan="11" class="tituloAlterno" align="center"><cfoutput>#rsEmpresa.Edescripcion#</cfoutput></td>
    </tr>
    <tr> 
      <td colspan="11">&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="11" align="center"><b>Consulta de Artículos de Inventario</b></td>
    </tr>
    <tr> <cfoutput> 
        <td colspan="11" align="center"><b>Fecha de la Consulta:</b> #LSDateFormat(Now(), 'dd/mm/yyyy')# &nbsp; <b>Hora:&nbsp;</b>#TimeFormat(Now(),'medium')#</td>
      </cfoutput> </tr>
		<cfquery name="rsRango" datasource="#session.DSN#">
			select Aid
			from Articulos
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
			and Aid in ( select distinct Aid 
						 from Existencias 
						 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
					   )
			<cfif len(trim(acodigoi)) and len(trim(acodigof))>
				and Acodigo between <cfqueryparam cfsqltype="cf_sql_varchar" value="#acodigoi#"> and <cfqueryparam cfsqltype="cf_sql_varchar" value="#acodigof#">
			<cfelseif len(trim(acodigoi))>
				and Acodigo >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#acodigoi#">
			<cfelseif len(trim(acodigof)) >
				and Acodigo <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#acodigof#">
			</cfif>			

			<!--- clasificacion --->
			<cfif ccodigoi neq -1 and ccodigof neq -1>
				and Ccodigo between <cfqueryparam cfsqltype="cf_sql_integer" value="#ccodigoi#"> and <cfqueryparam cfsqltype="cf_sql_integer" value="#ccodigof#">
			<cfelseif ccodigoi neq -1>
				and Ccodigo >= <cfqueryparam cfsqltype="cf_sql_integer" value="#ccodigoi#">
			<cfelseif ccodigof neq -1 >
				and Ccodigo <= <cfqueryparam cfsqltype="cf_sql_integer" value="#ccodigof#">
			</cfif>			

			order by upper(Acodigo)			
		</cfquery>
		<cfoutput> 
		<cfloop query="rsRango">
		
					<tr> 
					  <td colspan="16" class="bottomline">&nbsp;</td>
					</tr>

					<cfquery name="rsArticulo" datasource="#Session.DSN#">
							select 	
						a.Aid, 
						a.Acodigo, 
						a.Acodalterno, 
						a.Ucodigo, 
						b.Udescripcion, 
						a.Ccodigo, 
						c.Cdescripcion, 
						a.Adescripcion, 
						a.Afecha, 
						d.Alm_Aid, 
						e.Bdescripcion, 
						f.Odescripcion, 
						d.Eestante, 
						d.Ecasilla, 
						coalesce(d.Eexistencia,0.00) as Eexistencia, 
						coalesce(d.Ecostou,0.00) as Ecostou, 
						coalesce(d.Ecostototal,0.00) as Ecostototal 
							from Articulos a
							 inner join Unidades b
							 on a.Ecodigo = b.Ecodigo
							 and a.Ucodigo = b.Ucodigo
								inner join Clasificaciones c
								on a.Ecodigo = c.Ecodigo
								and a.Ccodigo = c.Ccodigo
									left join Existencias d
									on a.Ecodigo = d.Ecodigo
									and a.Aid = d.Aid   
										left join Almacen e
										on d.Alm_Aid = e.Aid
											left join Oficinas f
											on e.Ecodigo = f.Ecodigo 
											and e.Ocodigo = f.Ocodigo 
							where 	a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
							and a.Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Aid#">
							order by a.Acodigo
					</cfquery>
					<cfquery name="rsTotales" dbtype="query">
						select sum(Eexistencia) as TotalExistencias, sum(Ecostototal) as TotalCostoTotal
						from rsArticulo
					</cfquery>
					
					  <tr> 
						<td colspan="4" class="tituloListas" align="left"><div align="center"><font size="3">#rsArticulo.Adescripcion#</font></div></td>
					  </tr>
					  <tr> 
						<td width="24%" nowrap><div align="right">C&oacute;digo:</div></td>
						<td width="33%"><strong>#rsArticulo.Acodigo#</strong></td>
						<td width="13%" nowrap> <div align="right">C&oacute;digo Alterno:</div></td>
						<td colspan="2"><strong>#rsArticulo.Acodalterno#</strong></td>
					  </tr>
					  <tr> 
						<td nowrap> <div align="right">Clasificaci&oacute;n:</div></td>
						<td><strong>#rsArticulo.Cdescripcion#</strong> <div align="right"></div></td>
						<td width="13%"><div align="right">Unidad de Medida:</div></td>
						<td width="30%"><strong>#rsArticulo.Udescripcion#</strong></td>
					  </tr>
					  <tr> 
						<td><div align="right"></div></td>
						<td colspan="2" nowrap>&nbsp;</td>
						<td nowrap></td>
					  </tr>
					  <tr > 
						<td colspan="7"> <table width="100%" cellpadding="0" cellspacing="0">
							<tr class="encabReporte"> 
							  <td width="15%"><strong>&nbsp;Almacén</strong></td>
							  <td width="15%"><strong>Oficina</strong></td>
							  <td width="7%"><strong>Estante</strong></td>
							  <td width="6%"><strong>Casilla</strong></td>
							  <td width="7%"><div align="right"><strong>Existencias</strong></div></td>
							  <td width="15%"><div align="right"><strong>Costo Unitario</strong></div></td>
							  <td width="15%"><div align="right"><strong>Costo Total</strong></div></td>
							</tr>
							<cfloop query="rsArticulo" >
							  <tr <cfif rsArticulo.CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>> 
								<td nowrap>#rsArticulo.Bdescripcion#</td>
								<td nowrap>#rsArticulo.Odescripcion#</td>
								<td>#rsArticulo.Eestante#</td>
								<td>#rsArticulo.Ecasilla#</td>
								<td nowrap><div align="right">#LSNumberFormat(rsArticulo.Eexistencia,',9.00000')#</div></td>
								<td><div align="right">#LSNumberFormat(rsArticulo.Ecostou,',9.00000')#</div></td>
								<td><div align="right">#LSNumberFormat(rsArticulo.Ecostototal,',9.00000')#</div></td>
							  </tr>
							</cfloop>
							<cfoutput>
							  <tr <cfif rsArticulo.CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>>
								<td nowrap>&nbsp;</td>
								<td nowrap>&nbsp;</td>
								<td><div align="right"><strong>Totales</strong>:</div></td>
								<td>&nbsp;</td>
								<td nowrap><div align="right"><strong>#LSNumberFormat(iif(rsTotales.TotalExistencias NEQ '',rsTotales.TotalExistencias,0.00000),',9.00000')#</strong></div></td>
								<td>&nbsp;</td>
								<td><div align="right"><strong>#LSNumberFormat(iif(rsTotales.TotalCostoTotal NEQ '',rsTotales.TotalCostoTotal,0.00000),',9.00000')#</strong></div></td>
							  </tr>
							</cfoutput>
						  </table></td>
					  </tr>
					  <tr> 
						<td colspan="8">&nbsp;</td>
					  </tr>
			</cfloop>					
		</cfoutput> 			
    <tr> 
      <td colspan="11">&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="11" class="topline">&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="11">&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="11"><div align="center"></div></td>
    </tr>
  </table>
</form>
<!--- </cf_sifHTML2Word> --->