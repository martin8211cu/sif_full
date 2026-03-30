<cfsetting requesttimeout="3600">
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	XmlFile="/rh/generales.xml"
	Key="BTN_Regresar"
	Default="Regresar"
	returnvariable="BTN_Regresar"/>		

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_DiasNoAgrupados"
	Default="Reporte Días no agrupados"
	returnvariable="titulo"/>
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Centro_Funcional"
	Default="Centro Funcional"	
	returnvariable="LB_Centro_Funcional"/>		
	
	<cfquery name="rsGrupos" datasource="#session.DSN#">
		select  b.Gdescripcion
		from RHCMGrupos b					
		where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and b.Gid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Gid#">
	</cfquery>
		
				
<cffunction name="getEmpleados" returntype="any">
	<cfargument name="Gid" required="yes" type="numeric">
	<cfset LsEmpleados = "">
	<cfquery name="rs1" datasource="#session.dsn#">
		Select DEid 
		from RHCMEmpleadosGrupo
		Where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Gid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Gid#">
	</cfquery>
	<cfif rs1.recordCount GT 0>
		<cfloop query="rs1">
			<cfset LsEmpleados =LsEmpleados & rs1.DEid & ','>
		</cfloop>
	</cfif>
	<cfset LsEmpleados = LsEmpleados & '-1'>	
	<cfreturn LsEmpleados>
</cffunction>




				
				
<style>
	.LetraHora{
		font-size:9px
	}
	.LetraTitulo{
		font-size:10px;
		font-weight:bold;
	}
	.LetraEmpleado{
		font-size:10px;
	}
</style>
	<cfif isdefined("form.DEid") and len(trim(form.DEid))>
		<cfset LS_DEid = form.DEid >
	<cfelse>
		<cfset LS_DEid = getEmpleados(form.Gid) >
	</cfif>

	<cfif isdefined("url.fdesde") and len(trim(url.fdesde))>
		<cfset form.fdesde = url.fdesde>
	</cfif>
	
	<cfif isdefined("url.fHasta") and len(trim(url.fHasta))>
		<cfset form.fHasta = url.fHasta>
	</cfif>
	<!--- Busca en la tabla  RHCMCalculoAcumMarcas las fechas que se encuentran dentro del rango seleccionado--->
	<cfquery name="rsFechas" datasource="#session.DSN#" >
		select distinct 
			((({fn YEAR(a.CAMfdesde)} * 100 + {fn MONTH(a.CAMfdesde)} ) * 100 ) + {fn DAYOFMONTH(a.CAMfdesde)})  as Fecha
		from RHCMCalculoAcumMarcas a 
		where a.Ecodigo = <cfqueryparam  cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		
		<cfif isdefined("form.fHasta") and len(trim(form.fHasta)) and isdefined("form.fdesde") and len(trim(form.fdesde))>
			and a.CAMfdesde  between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fdesde)#">  
			and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fHasta)#">
		</cfif>
			and a.DEid IN(#LS_DEid#)

	</cfquery>
	<cfset fechas = "">
	<cfif rsFechas.recordCount GT 0>
		<cfloop query="rsFechas">
			<cfset fechas =fechas & rsFechas.Fecha & ','>
		</cfloop>
	</cfif>
	<cfset fechas = fechas & '1'>	
	<!--- copia las fechas en un lista para luego ir a buscar que marcas (RHControlMarcas ) existen en el rango de fechas seleccionado y
	      que no  se encuentra dentro de la lista, ya que estan son las marcas que se encuentran sin agrupar.--->
	
	<cfquery name="rsNoAgrupadas" datasource="#session.DSN#">
		select distinct
		a.DEid,
		d.CFdescripcion,
		e.DEidentificacion, 
		{fn concat(e.DEapellido1,{fn concat(' ',{fn concat(e.DEapellido2,{fn concat(' ',e.DEnombre)})})})}	as Empleado,
		<cf_dbfunction name="date_format" args="a.fechahoramarca,DD/MM/YY"> as fechahoramarca
		from RHControlMarcas a
		inner join LineaTiempo b
				on  a.Ecodigo  = b.Ecodigo
				and a.DEid     = b.DEid  
				and 	((({fn YEAR(a.fechahoramarca)} * 100 + {fn MONTH(a.fechahoramarca)} ) * 100 ) + {fn DAYOFMONTH(a.fechahoramarca)})  
				>=     ((({fn YEAR(b.LTdesde)} * 100   + {fn MONTH(b.LTdesde)}   ) * 100 ) + {fn DAYOFMONTH(b.LTdesde)})    
				
				and 	((({fn YEAR(a.fechahoramarca)} * 100 + {fn MONTH(a.fechahoramarca)} ) * 100 ) + {fn DAYOFMONTH(a.fechahoramarca)})  
				<=     ((({fn YEAR(b.LThasta)} * 100   + {fn MONTH(b.LThasta)}   ) * 100 ) + {fn DAYOFMONTH(b.LThasta)})  
			inner join RHPlazas c
				on b.RHPid = c.RHPid
			inner join CFuncional d
				on  c.Ecodigo  = d.Ecodigo
				and c.CFid = d.CFid
			inner join DatosEmpleado e
				on a.Ecodigo = e.Ecodigo
				and a.DEid = e.DEid		
		where a.Ecodigo = <cfqueryparam  cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		<cfif isdefined("form.DEid") and len(trim(form.DEid))>
				and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		</cfif>
		<cfif isdefined("form.fHasta") and len(trim(form.fHasta)) and isdefined("form.fdesde") and len(trim(form.fdesde))>
			and a.fechahoramarca  between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fdesde)#">  
			and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fHasta)#">
		</cfif>	

		and ((({fn YEAR(a.fechahoramarca)} * 100 + {fn MONTH(a.fechahoramarca)} ) * 100 ) + {fn DAYOFMONTH(a.fechahoramarca)})
		not in (#fechas#)
		group by 
			a.DEid,
			d.CFdescripcion, 
			e.DEidentificacion, 
			{fn concat(e.DEapellido1,{fn concat(' ',{fn concat(e.DEapellido2,{fn concat(' ',e.DEnombre)})})})},
			a.fechahoramarca
		order by d.CFdescripcion,{fn concat(e.DEapellido1,{fn concat(' ',{fn concat(e.DEapellido2,{fn concat(' ',e.DEnombre)})})})},<cf_dbfunction name="date_format" args="a.fechahoramarca,DD/MM/YY">  desc
	</cfquery>

	<cfif rsNoAgrupadas.RecordCount gt 0 and rsNoAgrupadas.RecordCount lt 10000 >
			<cfset LvarFileName = "DiasNoAgrupados_#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">
			<cf_htmlReportsHeaders 
				title="#titulo#" 
				filename="#LvarFileName#"
				irA="DiasNoAgrupados.cfm" 
				>
			<cfif not isdefined("form.btnDownload")>
				<cf_templatecss>
			</cfif>	
	</cfif>	
	
	<table width="100%" cellpadding="2" cellspacing="0" align="center" border="0">
		<cfif rsNoAgrupadas.RecordCount GT 10000>
			<tr><td align="center"><strong><cf_translate key="LB_LaCantidadDeRegistrosSobrepasaElLimite">La cantidad de registros sobrepasa el l&iacute;mite, por favor utilice mas filtros o cambie los seleccionados</cf_translate></strong></td></tr>
		<cfelse>
			<cfoutput>	
			<tr> 
				<td colspan="3">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 5px;" align="center" class="areaFiltro">
					<tr> 
						<td colspan="3" nowrap align="center"><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">#Session.Enombre#</strong></td>
					</tr>
					<tr><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px"> 
						<td nowrap colspan="3" align="center"><strong style="font-family:'Times New Roman', Times, serif; font-size:13pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">#titulo#</strong></td>		
					</tr>	
					<tr>
						<td colspan="3" class="LetraTitulo" align="center">
							<cf_translate key="LB_Desde">Desde</cf_translate>
							:&nbsp;
							#Form.fdesde# 
							<cf_translate key="LB_Hasta">Hasta</cf_translate>
							:&nbsp;
							#Form.fHasta# 
						</td>
					</tr>	
					<tr>
						<td colspan="3" class="LetraTitulo" align="center">
							<cf_translate key="LB_Grupo">Grupo</cf_translate>
							:&nbsp;
							#rsGrupos.Gdescripcion# 
						</td>
					</tr>
					
					
					
					</table>
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			</cfoutput>

			<cfif isdefined("rsNoAgrupadas") and rsNoAgrupadas.RecordCount NEQ 0>
				<cfoutput query="rsNoAgrupadas" group="CFdescripcion">
					<tr>
						<td colspan="3" style=" border-bottom:1px solid black;"><strong>#LB_Centro_Funcional#&nbsp;:&nbsp;#rsNoAgrupadas.CFdescripcion#</strong></td></tr>
					</tr>
					<tr>
						<td nowrap align="center" valign="bottom" width="5%" class="areaFiltro"><cf_translate key="LB_Fecha">Fecha</cf_translate></td>	
						<td nowrap align="left"   valign="bottom" width="30%" class="areaFiltro"><cf_translate key="LB_Nombre">Nombre</cf_translate></td>				
						<td nowrap align="left"  valign="bottom" width="10%" class="areaFiltro"><cf_translate key="LB_Cedula">C&eacute;dula</cf_translate></td>
					</tr>
					<cfoutput>	
						<tr>
							<td align="center" class="LetraHora" style="border-bottom:1px solid black; border-right:1px solid black; border-left:1px solid black;">#LSDateFormat(rsNoAgrupadas.fechahoramarca,'dd/mm/yyyy')#</td>
							<td align="left"   style="border-bottom:1px solid black; border-right:1px solid black; border-left:1px solid black;">#rsNoAgrupadas.Empleado#</td>
							<td align="left"   style="border-bottom:1px solid black; border-right:1px solid black; border-left:1px solid black;">#rsNoAgrupadas.DEidentificacion#</td>
						</tr>
					</cfoutput>
					<tr>
					<td colspan="5" align="center">&nbsp;</td>
				</tr>
				</cfoutput>
				<tr>
					<td colspan="3" align="center"><strong>------ <cf_translate key="LB_Ultimalinea">&Uacute;ltima l&iacute;nea</cf_translate> ------</strong></td>
				</tr>
			<cfelse>
				<tr>
					<td colspan="3" align="center"><strong>------ <cf_translate key="LB_NoSeEncontraronRegistros">No se encontraron registros</cf_translate> ------</strong></td>
				</tr>
			</cfif>
		</cfif>
		<tr><td>&nbsp;</td></tr>
	</table>