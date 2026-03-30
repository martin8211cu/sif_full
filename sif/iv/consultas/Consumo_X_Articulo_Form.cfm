<cffunction name="Articulo" returntype="string" >
	<cfargument name="Aid" type="numeric" required="true" default="">
	<cfquery name="desc" datasource="#session.DSN#">
		select Acodigo, Adescripcion
		from Articulos
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
		  and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Aid#">
	</cfquery>
	<cfreturn desc.Acodigo & '-' & desc.Adescripcion >
</cffunction>

<cfif isdefined("url.AidIni") and not isdefined("form.AidIni")>
	<cfset form.AidIni = url.AidIni >
</cfif>
<cfif isdefined("url.AidFin") and not isdefined("form.AidFin")>
	<cfset form.AidFin = url.AidFin >
</cfif>

<cf_dbfunction name="to_float" args="k.Kcosto" returnvariable = "Kcosto">
<cfquery name="data" datasource="#session.DSN#">
	select 	
	cf.CFdescripcion,
	cf.CFcodigo,
	cf.CFdescripcion,
	a.ERFecha as Fecha,
	a.ERdescripcion as Requisicion,
	art.Acodigo as Codigo,
	art.Adescripcion as Descripcion,
	abs(k.Kunidades) as Cantidad,
	case when abs(k.Kcosto) = 0 then #PreserveSingleQuotes(Kcosto)# else abs(k.Kcosto) / abs(k.Kunidades) end  as Monto,
	#PreserveSingleQuotes(Kcosto)# as Total
	
from HERequisicion a
	inner join Kardex k
		inner join Articulos art
			on art.Aid = k.Aid
		inner join CFuncional cf
			on cf.CFid= k.CFid
			and cf.Ecodigo = k.Ecodigo
	on k.ERid = a.ERid
			
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		<!---Centro Funcional ---->
		<cfif isdefined('form.CFcodigo2') and LEN(TRIM(form.CFcodigo2)) gt 0>
			and cf.CFcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CFcodigo2#">
		</cfif>
		 <!--- Departamento --->
		<cfif isdefined("form.AcodigoIni") and len(trim(form.AcodigoIni)) and isdefined("form.AcodigoFin") and len(trim(form.AcodigoFin))>
			and upper(art.Acodigo) between <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(form.AcodigoIni)#"> 
										and <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(form.AcodigoFin)#">
		<cfelseif isdefined("form.AcodigoIni") and len(trim(form.AcodigoIni)) >
			and upper(art.Acodigo) >= <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(form.AcodigoIni)#">
		<cfelseif isdefined("form.AcodigoFin") and len(trim(form.AcodigoFin)) >
			and upper(art.Acodigo) <= <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(form.AcodigoFin)#">
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
	
	order by upper(art.Acodigo), a.ERFecha, a.ERdescripcion
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
								Consulta de Consumo por Art&iacute;culo
							</strong>
						</font>
					</td>
					</strong>
				</tr>

				<cfif isdefined("form.AidIni") and len(trim(form.AidIni)) >
					<cfset desde = Articulo(form.AidIni) >
				</cfif>	
				<cfif isdefined("form.AidFin") and len(trim(form.AidFin)) >
					<cfset hasta = Articulo(form.AidFin)>
				</cfif>

				
				<cfoutput>
				<tr > 
					<td colspan="7" align="center">
					
							<cfif isdefined("desde") and isdefined("hasta")>
								<cfif desde neq hasta >
									<font size="2"><strong>Art&iacute;culo Inicial:  #desde# - Art&iacute;culo Final:  #hasta#</strong></font>
								<cfelse>
									<font size="2"><strong>Departamento: #desde#</strong></font>
								</cfif>
							<cfelseif isdefined("desde")>
								<font size="2"><strong>Art&iacute;culo Inicial: #desde#</strong></font>
							<cfelseif isdefined("hasta")>
								<font size="2"><strong>Art&iacute;culo Final: #hasta#</strong></font>
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
		<cfset TotalArt = 0>
		<cfoutput query="data" group="Codigo">
				<cfset TotalArt = 0>
				<tr> 
					<td colspan="7" class="bottomline">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="7" class="tituloListas" align="left" style="padding-left:3;"><div align="left"><font size="3">Art&iacute;culo: #Codigo# - #Descripcion#</font></div></td>
				</tr>
	
				<tr  bgcolor="##B6D0F1" style="padding-left:10; padding:3; "> 
				  <td><strong>Fecha</strong></td>
				  <td><strong>Requisici&oacute;n</strong></td>
				  <td><strong>C. Funcional</strong></td>
				  <td align="right"><strong>Cantidad</strong></td>
				  <td align="right"><strong>Costo Unitario</strong></td>
				  <td align="right"><strong>Total</strong></td>
				</tr>
			<cfoutput>
				<tr style="padding-left:10; cursor:hand;">
					<td nowrap>#LSDateFormat(data.Fecha,'dd/mm/yyyy')#</td>
					<td nowrap>#data.Requisicion#</td>
					<td nowrap>#data.CFdescripcion#</td>
					<td nowrap align="right">#LSNumberFormat(data.Cantidad,",9.0000")#</td> 
					<td nowrap align="right">#LSNumberFormat(data.Monto,",9.0000")#</td> 
					<td nowrap align="right">#LSNumberFormat(data.Total,",9.0000")#</td> 
				</tr>
				<cfset TotalArt = TotalArt + data.Total>
			</cfoutput>
				<tr>
					<td colspan="5" align="right"><strong>Total Art&iacute;culo #Codigo# - #Descripcion#</strong></td>
					<td align="right"><strong>#LSNumberFormat(TotalArt,",9.0000")#</strong></td>
				</tr>

		</cfoutput>
		<tr><td>&nbsp;</td></tr>
		<tr><td colspan="7" align="center"><strong>------ Fin del Reporte ------</strong></td></tr>
	<cfelse>
		<tr><td>&nbsp;</td></tr>
		<tr><td colspan="7" align="center"><strong>--- No se encontraron Registros ---</strong></td></tr>
	</cfif>
</table>
<br>

