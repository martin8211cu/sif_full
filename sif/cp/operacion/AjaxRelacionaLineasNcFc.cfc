
<cfcomponent output="false">
<cffunction name="init" access="public" returntype="boolean">
		<cfargument name="Ecodigo" required="no" type="numeric" default="#Session.Ecodigo#">
		<cfargument name="Conexion" required="no" type="string" default="#Session.Dsn#">
		<cfargument name="Usucodigo" required="no" type="string" default="#Session.Usucodigo#">
		<cfargument name="Fecha" required="no" type="date" default="#Now()#">
		<cfreturn true>
	</cffunction>

<cffunction name="guardarRelacionLineas" access="remote" returntype="struct">
	<cfargument name="lineaNC" required="yes" type="string">
	<cfargument name="lineaFC" required="yes" type="string">
	<cfargument name="movAplicacion" required="yes" type="string">

	<!--- Primero consulta --->
	<cfquery name="rsValidaExistencia" datasource="#Session.dsn#">
		SELECT * FROM CPrelacionLineasNcFc
		WHERE NCId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.lineaNC#">
		AND FCId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.lineaFC#">
		AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		AND MovAplicacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.movAplicacion#">
	</cfquery>

	<cfif rsValidaExistencia.recordCount GT 0>
		<cfset Local.obj = {MSG='La relaci&oacute;n ya existe.'}>
	<cfelse>
		<cftransaction>
			<cftry>
				<!--- Consulta info NC --->
				<cfquery name="rsGetNC" datasource="#Session.dsn#">
					SELECT d.DDtipo AS ItemNC,
					       d.DDescripcion AS DescNC,
					       (d.DDtotallin + (d.DDtotallin*(i.Iporcentaje/100))) totalNC,
					       d.Icodigo,
					       CASE d.codIEPS
					          WHEN '-' THEN -1
					          WHEN '0' THEN -1
					          ELSE (SELECT Iporcentaje FROM Impuestos WHERE Icodigo = d.codIEPS)
					       END ieps
					FROM DDocumentosCP d
					INNER JOIN Impuestos i ON i.Icodigo = d.Icodigo
					AND d.Ecodigo = i.Ecodigo
					AND d.DDlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.lineaNC#">
				</cfquery>

				<!--- Consulta info NC --->
				<cfquery name="rsGetFC" datasource="#Session.dsn#">
					SELECT d.DDtipo AS ItemFC,
					       d.DDescripcion AS DescFC,
					       (d.DDtotallin + (d.DDtotallin*(i.Iporcentaje/100))) totalFC,
					       d.Icodigo,
					       CASE d.codIEPS
					          WHEN '-' THEN -1
					          WHEN '0' THEN -1
					          ELSE (SELECT Iporcentaje FROM Impuestos WHERE Icodigo = d.codIEPS)
					       END ieps
					FROM DDocumentosCP d
					INNER JOIN Impuestos i ON i.Icodigo = d.Icodigo
					AND d.Ecodigo = i.Ecodigo
					AND d.DDlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.lineaFC#">
				</cfquery>

				<!--- VALIDA QUE LOS IMPUESTOS (IVA) SEAN IGUALES --->
				<cfif rsGetNC.Icodigo NEQ rsGetFC.Icodigo>
					<cfset Local.obj = {MSG='El impuesto de ambas lineas debe ser igual.'}>
					<cfreturn  Local.obj>
				</cfif>

				<!--- VALIDA QUE EL IEPS SEA EL MISMO --->
				<cfif rsGetNC.ieps NEQ rsGetFC.ieps>
					<cfset Local.obj = {MSG='El IEPS de ambas lineas debe ser igual.'}>
					<cfreturn  Local.obj>
				</cfif>

				<!--- VALIDA QUE EL MONTO DE LA NC NO SOBREPASE AL DE FC --->
				<cfif rsGetNC.totalNC GT rsGetFC.totalFC>
					<cfset Local.obj = {MSG='El monto de la linea de NC no puede ser mayor al de la FC.'}>
					<cfreturn  Local.obj>
				</cfif>

				<!--- INSERT --->
				<cfquery name="rsInsertRelacion" datasource="#Session.dsn#">
					INSERT INTO CPrelacionLineasNcFc (MovAplicacion, NCId, ItemNC, DescNC, TotalNC, FCId, Ecodigo)
					VALUES (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.movAplicacion#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.lineaNC#">,<!--- de aqui --->
							<cfqueryparam cfsqltype="CF_SQL_CHAR"    value="#rsGetNC.ItemNC#">,
							<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#rsGetNC.DescNC#">,
							<cfqueryparam cfsqltype="CF_SQL_MONEY"   value="#rsGetNC.totalNC#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.lineaFC#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">)
				</cfquery>

				<!--- update --->
				<cfquery name="rsInsertRelacion" datasource="#Session.dsn#">
					UPDATE CPrelacionLineasNcFc
					SET ItemFC = <cfqueryparam cfsqltype="CF_SQL_CHAR"    value="#rsGetFC.ItemFC#">,
					    DescFC = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#rsGetFC.DescFC#">,
					    TotalFC = <cfqueryparam cfsqltype="CF_SQL_MONEY"   value="#rsGetFC.totalFC#">
					WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
					AND   MovAplicacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.movAplicacion#">
					AND   FCId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.lineaFC#">
				</cfquery>
				<cftransaction action="commit" />
				<cfset Local.obj = {MSG='InsertOK'}>
			<cfcatch type="any">
				<cftransaction action="rollback" />
				<cfset Local.obj = {MSG='Ha ocurrido un error, intente más tarde.'}>
			</cfcatch>
			</cftry>
		</cftransaction>
	</cfif>
	<cfreturn  Local.obj>
</cffunction>

<!--- Consulta Relaciones existentes --->
<cffunction name="consultaRelaciones" access="remote" returntype="boolean">
	<cfargument name="MovAplicacion" required="yes" type="string">

	<cfquery name="rsConsultaRelaciones" datasource="#Session.dsn#">
		SELECT * FROM CPrelacionLineasNcFc
		WHERE MovAplicacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.MovAplicacion#">
		AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	</cfquery>

	<cfif rsConsultaRelaciones.recordCount GT 0>
		<table width="100%" border="0" style="font-family:arial;font-size:12px;" cellspacing="0" cellpadding="0">
			<tr>
				<td colspan="9" align="center" bgcolor="#D9D9D9"><strong>Afectaci&oacute;n por l&iacute;nea</strong></td>
			</tr>
			<tr>
				<td align="center">&nbsp;</td>
				<td colspan="3" align="center"><strong>L&iacute;nea NC</strong></td>
				<td align="center">&nbsp;</td>
				<td colspan="3" align="center"><strong>L&iacute;nea FC</strong></td>
				<td align="center">&nbsp;</td>
			</tr>
			<cfoutput>
				<cfloop query="rsConsultaRelaciones">
					<tr>
						<td align="center">#rsConsultaRelaciones.CurrentRow#</td>
						<td align="center">#rsConsultaRelaciones.ItemNC#</td>
						<td>&nbsp;#rsConsultaRelaciones.DescNC#</td>
						<td align="right">#LSCurrencyFormat(rsConsultaRelaciones.TotalNC,'none')#</td>
						<td align="center">&nbsp;</td>
						<td align="center">#rsConsultaRelaciones.ItemFC#</td>
						<td>&nbsp;#rsConsultaRelaciones.DescFC#</td>
						<td align="right">#LSCurrencyFormat(rsConsultaRelaciones.TotalFC,'none')#</td>
						<td align="center"><img src="/cfmx/sif/imagenes/deletesmall.gif" style="cursor: pointer;" onclick="eliminaUnaRelacion('#rsConsultaRelaciones.Id#');"></</td>
					</tr>
				</cfloop>
			</cfoutput>
			<tr>
				<td colspan="8" align="center">&nbsp;</td>
			</tr>
		</table>
	</cfif>

	<cfreturn  true>
</cffunction>

<!--- Valida si existen relaciones marcadas --->
<cffunction name="existRelations" access="remote" returntype="struct">
	<cfargument name="movAplicacion" required="yes" type="string">
	<cfargument name="totalLineas" required="yes" type="string">
	<cftransaction>
		<cftry>
			<cfquery name="rsConsultaRelaciones" datasource="#Session.dsn#">
				SELECT * FROM CPrelacionLineasNcFc
				WHERE MovAplicacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.MovAplicacion#">
				AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			</cfquery>

			<cfif rsConsultaRelaciones.recordCount GT 0>
				<cfif rsConsultaRelaciones.recordCount LT totalLineas>
					<cfset Local.obj = {MSG='faltan'}>
					<cfreturn  Local.obj>
				</cfif>
				<cfset Local.obj = {MSG='existeOK'}>
			<cfelse>
				<cfset Local.obj = {MSG='noExiste'}>
			</cfif>
			<cftransaction action="commit" />
			<cfcatch type="any">
				<cftransaction action="rollback" />
				<cfset Local.obj = {MSG='Ha ocurrido un error, intente más tarde.'}>
			</cfcatch>
		</cftry>
	</cftransaction>
	<cfreturn  Local.obj>
</cffunction>

<!--- Elimina Relaciones existentes --->
<cffunction name="deleteRelacion" access="remote" returntype="struct">
	<cfargument name="movAplicacion" required="yes" type="string">
	<cftransaction>
		<cftry>
			<cfquery name="rsGetNC" datasource="#Session.dsn#">
				DELETE CPrelacionLineasNcFc
				WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
				AND MovAplicacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.MovAplicacion#">
			</cfquery>
			<cftransaction action="commit" />
			<cfset Local.obj = {MSG='DeleteOK'}>
			<cfcatch type="any">
				<cftransaction action="rollback" />
				<cfset Local.obj = {MSG='Ha ocurrido un error, intente más tarde.'}>
			</cfcatch>
		</cftry>
	</cftransaction>
	<cfreturn  Local.obj>
</cffunction>

<!--- Elimina Solo una relacion --->
<cffunction name="deleteUnaRelacion" access="remote" returntype="struct">
	<cfargument name="movAplicacion" required="yes" type="string">
	<cfargument name="IdLinea" required="yes" type="string">

	<cftransaction>
		<cftry>
			<cfquery name="rsGetNC" datasource="#Session.dsn#">
				DELETE CPrelacionLineasNcFc
				WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
				AND MovAplicacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.MovAplicacion#">
				AND Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.IdLinea#">
			</cfquery>
			<cftransaction action="commit" />
			<cfset Local.obj = {MSG='DeleteOK'}>
			<cfcatch type="any">
				<cftransaction action="rollback" />
				<cfset Local.obj = {MSG='Ha ocurrido un error, intente más tarde.'}>
			</cfcatch>
		</cftry>
	</cftransaction>
	<cfreturn  Local.obj>
</cffunction>

<!--- Refresca tabla de NC --->
<cffunction name="refreshTableNC" access="remote" returntype="boolean">
	<cfargument name="IDdocumento" required="yes" type="string">
	<cfargument name="movAplicacion" required="yes" type="string">

	<cfquery name="rsLineasNC" datasource="#Session.DSN#">
		SELECT d.DDlinea,
		       d.DDtipo AS ItemNC,
		       d.DDescripcion AS DescNC,
		       (d.DDtotallin + (d.DDtotallin*(i.Iporcentaje/100))) totalNC,
		       i.Iporcentaje,
		       d.Ddocumento,
		       CASE d.codIEPS
		          WHEN '-' THEN -1
		          ELSE (SELECT Iporcentaje FROM Impuestos WHERE Icodigo = d.codIEPS)
		       END ieps
		FROM DDocumentosCP d
		INNER JOIN Impuestos i ON i.Icodigo = d.Icodigo
		AND d.Ecodigo = i.Ecodigo
		AND d.IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.IDdocumento#">
		AND d.CPTcodigo = 'NC'
		AND d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		AND d.DDlinea NOT IN (SELECT NCId FROM CPrelacionLineasNcFc WHERE
		  			  		  Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		  			  		  AND MovAplicacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.movAplicacion#">)
		ORDER BY d.DDlinea ASC
	</cfquery>

	<cfif rsLineasNC.recordCount GT 0>
		<cfoutput>
			<table width="100%" border="0" style="font-family:arial;font-size:12px;" cellspacing="0" cellpadding="0">
				<tr><td align="center" colspan="7"><strong>Nota de cr&eacute;dito: #rsLineasNC.Ddocumento#</strong></td></tr>
				<tr>
					<td width="7%">&nbsp;</td>
					<td width="12%" align="center"><strong>N&uacute;m.</strong></td>
					<td width="12%" align="center"><strong>Item</strong></td>
					<td width="15%" align="center"><strong>IVA</strong></td>
					<td width="15%" align="center"><strong>IEPS</strong></td>
					<td><strong>Concepto</strong></td>
					<td align="center"><strong>Monto</strong></td>
				</tr>
				<cfset countNC = 0>
				<cfloop query="rsLineasNC">
					<cfset countNC++>
					<tr>
						<cfset NCporcentajeIVA = "">
						<cfif Len(Trim(#rsLineasNC.Iporcentaje#)) NEQ 0><cfset NCporcentajeIVA = "#rsLineasNC.Iporcentaje#%"></cfif>
						<td width="7%"><input type="radio" name="radgroupNC" id="radgroupNC_#NCporcentajeIVA#_#rsLineasNC.DDlinea#_#rsLineasNC.totalNC#" value="#rsLineasNC.DDlinea#"></td>
						<td width="8%" align="center">#countNC#</td>
						<td width="8%" align="center">#rsLineasNC.ItemNC#</td>
						<td width="12%" align="center"><cfif Len(Trim(#rsLineasNC.Iporcentaje#)) NEQ 0>#rsLineasNC.Iporcentaje&'%'#</cfif></td>
						<td width="12%" align="center"><cfif #rsLineasNC.ieps# NEQ -1>#rsLineasNC.ieps&'%'#</cfif></td>
						<td>#rsLineasNC.DescNC#</td>
						<td align="right">#LSCurrencyFormat(rsLineasNC.totalNC,'none')#</td>
					</tr>
				</cfloop>
			</table>
		</cfoutput>
	<cfelse>
		Nota de cr&eacute;dito sin lineas.
	</cfif>
	<cfreturn  true>
</cffunction>


<!--- Refresca tabla de FC --->
<cffunction name="refreshTableFC" access="remote" returntype="boolean">
	<cfargument name="IDdocumento" required="yes" type="string">
	<cfargument name="movAplicacion" required="yes" type="string">

	<cfquery name="rsLineasFC" datasource="#Session.DSN#">
		SELECT d.DDlinea,
		       d.DDtipo AS ItemFC,
		       d.DDescripcion AS DescFC,
		       (d.DDtotallin + (d.DDtotallin*(i.Iporcentaje/100))) totalFC,
		       i.Iporcentaje,
		       d.Ddocumento,
		       CASE d.codIEPS
		          WHEN '-' THEN -1
		          ELSE (SELECT Iporcentaje FROM Impuestos WHERE Icodigo = d.codIEPS)
		       END ieps
		FROM DDocumentosCP d
		INNER JOIN Impuestos i ON i.Icodigo = d.Icodigo
		AND d.Ecodigo = i.Ecodigo
		AND d.IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.IDdocumento#">
		AND d.CPTcodigo = 'FC'
		AND d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		AND d.DDlinea NOT IN (SELECT FCId FROM CPrelacionLineasNcFc WHERE
		  			  		  Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		  			  		  AND MovAplicacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.movAplicacion#">)
		ORDER BY d.DDlinea ASC
	</cfquery>


	<cfif rsLineasFC.recordCount GT 0>
		<cfoutput>
			<table width="100%" border="0" style="font-family:arial;font-size:12px;" cellspacing="0" cellpadding="0">
				<tr><td align="center" colspan="7"><strong>Factura: #rsLineasFC.Ddocumento#</strong></td></tr>
				<tr>
					<td width="7%">&nbsp;</td>
					<td width="12%" align="center"><strong>N&uacute;m.</strong></td>
					<td width="12%" align="center"><strong>Item</strong></td>
					<td width="15%" align="center"><strong>IVA</strong></td>
					<td width="15%" align="center"><strong>IEPS</strong></td>
					<td><strong>Concepto</strong></td>
					<td align="center"><strong>Monto</strong></td>
				</tr>
				<cfset countFC = 0>
				<cfloop query="rsLineasFC">
					<cfset countFC++>
					<tr>
						<cfset FCporcentajeIVA = "">
						<cfif Len(Trim(#rsLineasFC.Iporcentaje#)) NEQ 0><cfset FCporcentajeIVA = "#rsLineasFC.Iporcentaje#%"></cfif>
						<td width="7%"><input type="radio" name="radgroupFC" id="radgroupFC_#FCporcentajeIVA#_#rsLineasFC.DDlinea#_#rsLineasFC.totalFC#" value="#rsLineasFC.DDlinea#"></td>
						<td width="8%" align="center">#countFC#</td>
						<td width="8%" align="center">#rsLineasFC.ItemFC#</td>
						<td width="12%" align="center"><cfif Len(Trim(#rsLineasFC.Iporcentaje#)) NEQ 0>#rsLineasFC.Iporcentaje&'%'#</cfif></td>
						<td width="12%" align="center"><cfif #rsLineasFC.ieps# NEQ -1>#rsLineasFC.ieps&'%'#</cfif></td>
						<td>#rsLineasFC.DescFC#</td>
						<td align="right">#LSCurrencyFormat(rsLineasFC.totalFC,'none')#</td>
					</tr>
				</cfloop>
		</table>
		</cfoutput>
	<cfelse>
		Factura sin lineas.
	</cfif>
	<cfreturn  true>
</cffunction>

</cfcomponent>
