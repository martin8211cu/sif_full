
<cfset retorno = ValidaSalida("#form.CGICMid#", "1", #session.Ecodigo#, #form.Periodo#, #form.Mes#, "#session.DSN#")>
<cfif retorno>
	<cfset retorno = GeneraSalidaExterna("#form.CGICMid#", "1", #session.Ecodigo#, #form.Periodo#, #form.Mes#, "#session.DSN#")>
</cfif>

<cffunction name="ValidaSalida" output="true" access="private">
	<cfargument name="FormatoSalida" type="numeric" required="yes">
	<cfargument name="NumeroSalida"  type="numeric" required="yes"> <!--- Se asume 1 por el momento, falta tabla padre con la descripción de las salidas --->
	<cfargument name="Ecodigo" 		 type="numeric" required="yes">
	<cfargument name="Periodo" 		 type="numeric" required="yes">
	<cfargument name="Mes" 			 type="numeric" required="yes">
	<cfargument name="datasource" 	 type="string"  default="#session.DSN#" required="no">

	<cfquery name="rsValida" datasource="#Arguments.datasource#">
		select count(1) as Cantidad
		from CGIC_Layout
		where CGICMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FormatoSalida#">
		  and CGICLsal = #arguments.NumeroSalida#
	</cfquery>
	
	<cfif rsValida.Cantidad LT 1>
		<form name="form1" method="post" action="ReporteCuentasMapeo.cfm">
			<table width="100%">
				<tr><td>&nbsp;</td></tr>
				<tr><td>&nbsp;</td></tr>
				<tr><td>&nbsp;</td></tr>
				<tr><td>&nbsp;</td></tr>
				<tr><td>&nbsp;</td></tr>
				<tr><td align="center"><strong>ERROR.  No se puede procesar el informe!</strong></td></tr>
				<tr><td>&nbsp;</td></tr>
				<tr>
				<td align="center" ><strong>No Se encontr&oacute; definici&oacute;n de salida para el Mapeo Seleccionado</strong></td>
				</tr> 
				<tr><td>&nbsp;</td></tr>
				<tr><td align="center"><input type="submit" value="Regresar" name="Regresar" /></td></tr>
			</table>
		</form>
		<cfreturn false>
	</cfif>

	<cfquery name="rsValida" datasource="#Arguments.datasource#">
		select count(1) as Cantidad
		from CContables c
		where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
		  and c.Cmayor <> c.Cformato
		  and c.Cmovimiento = 'S'
		  and not exists(
		  	select 1
			from CGIC_Cuentas cm
			where cm.Ccuenta = c.Ccuenta
			  and cm.CGICMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FormatoSalida#">
			  )
	</cfquery>

	<cfif rsValida.Cantidad GT 0>
		<cfquery name="rsValida" datasource="#Arguments.datasource#">
			select c.Cformato, c.Cdescripcion
			from CContables c
			where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			  and c.Cmayor <> c.Cformato
			  and c.Cmovimiento = 'S'
			  and not exists(
				select 1
				from CGIC_Cuentas cm
				where cm.Ccuenta = c.Ccuenta
				  and cm.CGICMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FormatoSalida#">
				  )
			order by c.Cformato
		</cfquery>
		
		<form name="form1" method="post" action="ReporteCuentasMapeo.cfm">
			<table width="100%">
				<tr><td>&nbsp;</td></tr>
				<tr><td colspan="3" align="center"><strong>ERROR.  No se puede procesar el informe!</strong></td></tr>
				<tr><td>&nbsp;</td></tr>
				<tr><td colspan="3" align="center"><strong>NO estan mapeadas las siguientes cuentas:</strong></td></tr>
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td><strong>Cuenta</strong></td>
					<td>&nbsp;</td>
					<td><strong>Descripci&oacute;n</strong></td>
				</tr>
				<cfoutput query="rsValida">
					<tr>
						<td>#rsValida.Cformato#</td>
						<td>&nbsp;</td>
						<td>#rsValida.Cdescripcion#</td>
					</tr>
				</cfoutput>
				<tr><td>&nbsp;</td></tr>
				<tr><td colspan="3" align="center"><input type="submit" value="Regresar" name="Regresar" /></td></tr>
			</table>
		</form>
		<cfreturn false>
	</cfif>

	<cfreturn true>
</cffunction>


<cffunction name="GeneraSalidaExterna" output="true" access="private">
	<cfargument name="FormatoSalida" type="numeric" required="yes">
	<cfargument name="NumeroSalida"  type="numeric" required="yes"> <!--- Se asume 1 por el momento, falta tabla padre con la descripción de las salidas --->
	<cfargument name="Ecodigo" 		 type="numeric" required="yes">
	<cfargument name="Periodo" 		 type="numeric" required="yes">
	<cfargument name="Mes" 			 type="numeric" required="yes">
	<cfargument name="datasource" 	 type="string"  default="#session.DSN#" required="no">

	<cfquery name="rsOBtieneColumnas" datasource="#Arguments.datasource#">
		select CGICMid, CGICLcol, CGICLhead, CGICLtipo,	CGICLcampo, CGICLconst
		from CGIC_Layout
		where CGICMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FormatoSalida#">
		  and CGICLsal = #arguments.NumeroSalida#
		order by CGICLcol
	</cfquery>
	<!--- <cfdump var="#rsOBtieneColumnas#"> --->
	
	<cfset LvarSelect = "">
	<cfset LvarGroup  = "">
	<cfset LvarTipoCol = arraynew(1)>

	<cfloop query="rsObtieneColumnas">
		<cfif LvarSelect NEQ "">
			<cfset LvarSelect = LvarSelect & ', '>
		</cfif>
		<cfset col = rsObtieneColumnas.CGICLcol>
		<cfset LvarTipoCol[col] = rsObtieneColumnas.CGICLtipo>
		<cfif rsObtieneColumnas.CGICLtipo EQ 1>
			<!--- Es una Columna constante --->
			<cfset LvarSelect = LvarSelect & "'#rsObtieneColumnas.CGICLconst#' as Col#rsObtieneColumnas.CGICLcol#">
		<cfelse>
			<!--- Es una Columna de Base de Datos --->
			<cfset LvarSelect = LvarSelect & "#rsObtieneColumnas.CGICLcampo# as Col#rsObtieneColumnas.CGICLcol#">
			<cfif find("sum(",rsObtieneColumnas.CGICLcampo,1)>
				<!--- No va en el group ni en el order by --->
			<cfelse>
				<cfif LvarGroup NEQ "">
					<cfset LvarGroup = LvarGroup & ", ">
				</cfif>
				<cfset LvarGroup = LvarGroup & #rsObtieneColumnas.CGICLcampo#>
			</cfif>
		</cfif>
	</cfloop>

	<cfquery name="data" datasource="#Arguments.datasource#">
		select #PreserveSingleQuotes(LvarSelect)#
		from CGIC_Mapeo m
			inner join CGIC_Catalogo me
				inner join CGIC_Cuentas mc
					inner join SaldosContablesConvertidos s
                    	inner join Monedas mon
							inner join Empresas e							
							on e.Ecodigo = s.Ecodigo
                        on mon.Mcodigo = s.Mcodigo
					on s.Ccuenta = mc.Ccuenta
					and s.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
					and s.Speriodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Periodo#">
					and s.Smes     = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Mes#">
                    and s.B15 = 0
				on mc.CGICCid = me.CGICCid
			on me.CGICMid = m.CGICMid
		where m.CGICMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FormatoSalida#">
		<cfif LvarGroup NEQ "">
		group by #PreserveSingleQuotes(LvarGroup)#
		order by #PreserveSingleQuotes(LvarGroup)#
		</cfif>
	</cfquery>

	<cf_htmlReportsHeaders 
		title="Impresion PMI" 
		filename="PMI.xls"
		irA="ReporteCuentasMapeo.cfm"
		>
	<!---  Pintar una columna de la tabla por cada columna obtenida --->
	<table style="width:100%" cellpadding="2" cellspacing="2" border="0">
		<tr bgcolor="##999999">
		<cfoutput query="rsObtieneColumnas">
			<td align="right">#rsObtieneColumnas.CGICLhead#</td>
		</cfoutput>
		</tr>

		<cfoutput query="data">
			<tr>
			<cfloop index="i" from="1" to="#rsObtieneColumnas.recordcount#">
				<cfif LvarTipoCol[i] EQ 3>
					<td align="right">#LSnumberformat(evaluate("data.col" & i), ",9.00")#</td>			
				<cfelse>
					<td align="right">#evaluate("data.col" & i)#</td>			
				</cfif>
			</cfloop>
			</tr>
		</cfoutput>
		
	</table>
</cffunction>


