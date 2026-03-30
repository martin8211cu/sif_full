<cffunction name="almacen" returntype="string" >
	<cfargument name="Dcodigo" type="numeric" required="true" default="">
	<cfquery name="desc" datasource="#session.DSN#">
		select Deptocodigo, Ddescripcion
		from Departamentos
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
		  and Dcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Dcodigo#">
	</cfquery>
	<cfreturn desc.Deptocodigo & '-' & desc.Ddescripcion >
</cffunction>

<cfif isdefined("url.depini") and not isdefined("form.depini")>
	<cfset form.depini = url.depini >
</cfif>
<cfif isdefined("url.depfin") and not isdefined("form.depfin")>
	<cfset form.depfin = url.depfin >
</cfif>


<cf_dbfunction name="to_float" args="k.Kcosto" returnvariable = "Kcosto">
<cfquery name="data" datasource="#session.DSN#">
	select 	
		cf.CFcodigo,
		cf.CFdescripcion,
		a.ERFecha as Fecha,
		a.ERdocumento as Requisicion,
		art.Acodigo as Codigo,
		art.Adescripcion as Descripcion,
		abs(k.Kunidades) as Cantidad,
		case when abs(k.Kcosto) = 0 
		then #PreserveSingleQuotes(Kcosto)#
 		else abs(k.Kcosto) / abs(k.Kunidades) end  as Monto,
		#PreserveSingleQuotes(Kcosto)# as Total,
		d.Deptocodigo,
		d.Ddescripcion,
		o.Oficodigo,
		o.Odescripcion
	
	from HERequisicion a
		inner join Kardex k
			inner join Articulos art
				on art.Aid = k.Aid
			inner join CFuncional cf
				on cf.CFid= k.CFid
				and cf.Ecodigo = k.Ecodigo
			inner join Departamentos d
				on d.Ecodigo = cf.Ecodigo
				and d.Dcodigo = cf.Dcodigo
			inner join Oficinas o
				on o.Ecodigo = cf.Ecodigo
				and o.Ocodigo = cf.Ocodigo
				
		on k.ERid = a.ERid	
			
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		 <!--- Departamento --->
		<cfif isdefined("form.DeptocodigoIni") and len(trim(form.DeptocodigoIni)) and isdefined("form.DeptocodigoFin") and len(trim(form.DeptocodigoFin))>
			and d.Deptocodigo between <cfqueryparam cfsqltype="cf_sql_char" value="#form.DeptocodigoIni#"> 
										and <cfqueryparam cfsqltype="cf_sql_char" value="#form.DeptocodigoFin#">
		<cfelseif isdefined("form.DeptocodigoIni") and len(trim(form.DeptocodigoIni)) >
			and d.Deptocodigo >= <cfqueryparam cfsqltype="cf_sql_char" value="#form.DeptocodigoIni#">
		<cfelseif isdefined("form.DeptocodigoFin") and len(trim(form.DeptocodigoFin)) >
			and d.Deptocodigo <= <cfqueryparam cfsqltype="cf_sql_char" value="#form.DeptocodigoFin#">
		</cfif> <!--- --->
		
		<!--- Fechas Desde / Hasta --->
		  <cfif isdefined("form.fechaDes") and len(trim(form.fechaDes)) and isdefined("form.fechaHas") and len(trim(form.fechaHas))>
			<cfif datecompare(form.fechaDes, form.fechaHas) eq -1> 
				and a.ERFecha between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fechaDes)#"> 
					and <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fechaHas)#">
			<cfelseif datecompare(form.fechaDes, form.fechaHas) eq 1>
				and a.ERFecha between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fechaHas)#">
					and <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fechaDes)#">
			<cfelseif datecompare(form.fechaDes, form.fechaHas) eq 0>
				and a.ERFecha between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fechaDes)#">
					and <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fechaHas)#">
			</cfif>
		<cfelseif isdefined("form.fechaDes") and len(trim(form.fechaDes))>
			and a.ERFecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fechaDes)#">
		<cfelseif isdefined("form.fechaHas") and len(trim(form.fechaHas))>
			and a.ERFecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fechaHas)#">
		</cfif><!---  --->
		
		
		
		<!--- Documento --->
		 <cfif isdefined("form.ERdocumento") and len(trim(form.ERdocumento))>
			and a.ERdocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#form.ERdocumento#">
		</cfif><!--- --->
	
	order by Deptocodigo, CFdescripcion, ERFecha
</cfquery>

<style type="text/css">
	.encabReporte {
		background-color: #006699;
		font-weight: bold;
		color: #FFFFFF;
		padding-top: 1px;
		padding-bottom: 1px;
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
</style>

<table width="98%" border="0" cellpadding="0" cellspacing="0" align="center">
	<tr>
		<td colspan="7">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 5px;" align="center" class="areaFiltro">
				<tr><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px"> 
					<td colspan="7"  valign="middle" align="center"><font size="4"><strong><cfoutput>#session.Enombre#</cfoutput></strong></font></td>
					</strong>
				</tr>
		
				<tr> 
					<strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">
					<td colspan="7" align="center">
						<font size="3">
							<strong>
								Consulta de Consumo por Departamento
							</strong>
						</font>
					</td>
					</strong>
				</tr>

				<cfif isdefined("form.depini") and len(trim(form.depini)) >
					<cfset desde = almacen(form.depini) >
				</cfif>	
				<cfif isdefined("form.depfin") and len(trim(form.depfin)) >
					<cfset hasta = almacen(form.depfin)>
				</cfif>

				
				<cfoutput>
				<tr > 
					<td colspan="7" align="center">
					
							<cfif isdefined("desde") and isdefined("hasta")>
								<cfif desde neq hasta >
									<font size="2"><strong>Depto. Inicial:  #desde# - Depto. Final:  #hasta#</strong></font>
								<cfelse>
									<font size="2"><strong>Departamento: #desde#</strong></font>
								</cfif>
							<cfelseif isdefined("desde")>
								<font size="2"><strong>Depto. Inicial: #desde#</strong></font>
							<cfelseif isdefined("hasta")>
								<font size="2"><strong>Depto. Final: #hasta#</strong></font>
							<cfelse>
								<font size="1"><strong>(Todos los Departamentos)</strong></font>
							</cfif>
					</td>
				</tr>
				</cfoutput>
			</table>
		</td>	
	</tr>
	<!--- <cfdump var="#data#"> --->
	<cfif data.RecordCount gt 0>
		<cfset corte = '' >
		<cfset totalCF = 0>
		 <cfoutput query="data" group="CFdescripcion">
			<cfset totalCF = 0>
				<tr> 
					<td colspan="7" class="bottomline">&nbsp;</td>
				</tr>
			<!---	<tr>
					<td colspan="7" class="tituloListas" align="left" style="padding-left:3;"><div align="left"><font size="3">Centro Funcional: #CFcodigo# - #CFdescripcion# |  Departamento:#data.Deptocodigo# - #data.Ddescripcion# | Oficina: #data.Oficodigo# - #data.Odescripcion#</font></div></td>
				</tr>--->
				
				<tr>
					<td colspan="7" class="tituloListas" align="left" style="padding-left:3;"><div align="left"><font size="3">Departamento: #data.Ddescripcion# | Oficina: #data.Oficodigo# - #data.Odescripcion#</font></div></td>
				</tr>
				<tr>
					<td colspan="7" class="tituloListas" align="left" style="padding-left:3;"><div align="left"><font size="3">Centro Funcional: #CFcodigo# - #CFdescripcion# </font></div></td>
				</tr>
	
				<tr  bgcolor="##B6D0F1" style="padding-left:10; padding:3; "> 
				  <td><strong>Fecha</strong></td>
				  <td><strong>Centro Func.</strong></td>
				  <td><strong>Requisici&oacute;n</strong></td>
				  <td><strong>C&oacute;digo</strong></td>
				  <td><strong>Descripci&oacute;n</strong></td>
				  <td align="right"><strong>Cantidad</strong></td>
				  <td align="right"><strong>Costo Unitario</strong></td>
				  <td align="right"><strong>Total</strong></td>
				</tr>
			<cfoutput>
				<tr style="padding-left:10; cursor:hand;">
					<td nowrap>#LSDateFormat(data.Fecha,'dd/mm/yyyy')#</td>
					<td nowrap>#data.CFdescripcion#</td>					
					<td nowrap>#data.Requisicion#</td>
					<td nowrap>#data.Codigo#</td>
					<td nowrap>#data.Descripcion#</td>
					<td nowrap align="right">#LSNumberFormat(data.Cantidad,",9.00")#</td> 
					<td nowrap align="right">#LSNumberFormat(data.Monto,",9.00")#</td> 
					<td nowrap align="right">#LSNumberFormat(data.Total,",9.00")#</td> 
				</tr>
				<cfset totalCF = totalCF + data.Total>
			</cfoutput>
	
			<!--- <cfset corte = data.Deptocodigo> --->
			
		
			<tr>
			<td nowrap="nowrap" colspan="6" align="right"><strong>Total Centro Funcional #CFcodigo# - #CFdescripcion#:</strong></td>
				
				<td nowrap="nowrap" colspan="1" align="right"><strong>#LSNumberFormat(totalCF,",9.00")#</strong></td>
			</tr>
		</cfoutput>	
		<tr><td colspan="7">&nbsp;</td></tr>
		<tr><td colspan="7" align="center"><strong>------ Fin del Reporte ------</strong></td></tr>
	<cfelse>
		<tr><td>&nbsp;</td></tr>
		<tr><td colspan="7" align="center"><strong>--- No se encontraron Registros ---</strong></td></tr>
	</cfif>
</table>
<br>

