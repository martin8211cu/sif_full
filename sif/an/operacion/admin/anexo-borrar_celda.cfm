<cfset LvarAnexoId = form.AnexoId>
<cfset LVarAnexoHoja = "">

<cfif isdefined("form.sel_hoja")>
	<cfset LVarAnexoHoja = form.sel_hoja>
</cfif>

<cfif isdefined("btnRegresar") and len(trim(btnRegresar))>
	<cflocation url="anexo.cfm?tab=2&AnexoId=#URLEncodedFormat(LvarAnexoId)#">
</cfif>

<cfif isdefined("btnborrar") and len(trim(btnborrar))>
	<cftransaction action="begin">
		<cfquery datasource="#session.dsn#">
			delete
			from AnexoCelD
			where AnexoCelId in (
				select AnexoCelId
				from AnexoCel c
				where c.AnexoId = #LvarAnexoId#
				<cfif len(trim(LvarAnexoHoja)) GT 0> and c.AnexoHoja = '#LvarAnexoHoja#' </cfif>
				and AnexoCon is null
				and AnexoFila = 0
				and AnexoColumna = 0)
		</cfquery>
	
		<cfquery datasource="#session.dsn#">
			delete
			from AnexoCelConcepto
			where AnexoCelId in (
				select AnexoCelId
				from AnexoCel c
				where c.AnexoId = #LvarAnexoId#
				<cfif len(trim(LvarAnexoHoja)) GT 0> and c.AnexoHoja = '#LvarAnexoHoja#' </cfif>
				and AnexoCon is null
				and AnexoFila = 0
				and AnexoColumna = 0)
		</cfquery>
	
		<cfquery datasource="#session.dsn#">
			delete
			from AnexoCel
			where AnexoId = #LvarAnexoId#
			  <cfif len(trim(LvarAnexoHoja)) GT 0> and AnexoHoja = '#LvarAnexoHoja#' </cfif>
			  and AnexoCon is null
			  and AnexoFila = 0
			  and AnexoColumna = 0
		</cfquery>
	<cftransaction action="commit" />
	</cftransaction>
	<cflocation url="anexo.cfm?tab=2&AnexoId=#URLEncodedFormat(LvarAnexoId)#">
<cfelse>
	<cfquery name="rsHojas" datasource="#session.dsn#">
		select distinct AnexoHoja
		from AnexoCel
		where AnexoId = #LvarAnexoId#
	</cfquery>
	<form action="anexo.cfm" method="post" name="form1">
		<cfoutput>
			<input type="hidden" name="tab" value="2">
			<input type="hidden" name="Eliminar" value="1">
			<input type="hidden" name="AnexoId" value="# HTMLEditFormat(url.AnexoId) #">
		</cfoutput>
		
	
		<!--- Llenar el combo con los datos seleccionados --->
		<cfquery name="rsCeldasaBorrar" datasource="#session.dsn#">
			select 
				c.AnexoHoja, c.AnexoRan, c.AnexoFila, c.AnexoColumna,
				((
					select count(1)
					from AnexoCelD d
					where d.AnexoCelId = c.AnexoCelId
				)) as Cuentas,
				((
					select count(1)
					from AnexoCelConcepto e
					where e.AnexoCelId = c.AnexoCelId
				)) as Conceptos
			from AnexoCel c
			where c.AnexoId = #LvarAnexoId#
			  <cfif len(trim(LvarAnexoHoja)) GT 0>and c.AnexoHoja = '#LvarAnexoHoja#'</cfif>
			  and c.AnexoCon is null
			  and c.AnexoFila = 0
			  and c.AnexoColumna = 0
		</cfquery>
		<table width="100%">
			<tr>
				<td colspan="7">
					<strong>Hoja:</strong>&nbsp; 
					<select name="sel_hoja" tabindex="1">
						<option value="">(todas)</option> 
						<cfoutput query="rsHojas">
							<option value="#AnexoHoja#" <cfif AnexoHoja EQ LVarAnexoHoja> selected </cfif>>#AnexoHoja#</option> 
						</cfoutput>
					</select>
				</td>
			</tr>
			<tr>
				<td colspan="7"><cf_botones values="Filtrar, Borrar, Regresar"></td>
			</tr>
			<tr>
			<td colspan="7">&nbsp;</td>
			</tr>
			
			<tr>
				<td><strong>Hoja</strong></td>
				<td><strong>Rango</strong></td>
				<td><strong>Fila</strong></td>
				<td><strong>Columna</strong></td>
				<td><strong>Estado</strong></td>
				<td><strong>Cuentas</strong></td>
				<td><strong>Conceptos</strong></td>
			</tr>
			<cfflush interval="64">
			<cfoutput query="rsCeldasaBorrar">
				<tr>
					<td>#AnexoHoja#</td>
					<td>#AnexoRan#</td>
					<td>#AnexoFila#</td>
					<td>#AnexoColumna#</td>
					<td>Solo BD</td>
					<td>#NumberFormat(Cuentas,',9')#</td>
					<td>#NumberFormat(Conceptos,',9')#</td>
				</tr>
			</cfoutput>
		</table>
	</form>
</cfif>
