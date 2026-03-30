<!---
<cfif isdefined("LvarInfo")>
	<cfset LvarIrA  = 'ReporteCuentasMapeo_INFO.cfm'>
<cfelse>--->
	<cfset LvarIrA  = 'ReporteCuentasMapeoB15.cfm'>
<!---</cfif>--->

<!--- Incluir el monto de utilidad en la cuenta de utilidad del periodo.  Por defecto se define como verdadero --->
<cfif isdefined("form.Utilidad") and form.Utilidad eq 1>
	<cfset LvarIncluirUtil = true>
<cfelse>
	<cfset LvarIncluirUtil = false>
</cfif>

<!--- Presentar la información financiera convertida.  True identifica que se utiliza la tabla de saldos convertidos --->
<cfquery name="rsCGIC_Empresa" datasource="#Session.DSN#">
	select 
		MonedaConvertida 
	from CGIC_Empresa
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and CGICMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CGICMid#">
</cfquery>	
<cfif isdefined("rsCGIC_Empresa.MonedaConvertida") and rsCGIC_Empresa.MonedaConvertida eq 1>
	<cfset LvarConvertida = true>
<cfelse>
	<cfset LvarConvertida = false>
</cfif>


<!--- Presentar la información financiera convertida.  True identifica que se utiliza la tabla de saldos convertidos --->
<cfif isdefined("form.SCero") and form.SCero eq 1>
	<cfset LvarSCero = true>
<cfelse>
	<cfset LvarSCero = false>
</cfif>

<cfset retorno = ValidaSalida("#form.CGICMid#", "1", #session.Ecodigo#, #form.Periodo#, #form.Mes#, "#session.DSN#")>
<cfif retorno>
	<cfset retorno = GeneraSalidaExterna("#form.CGICMid#", "1", #session.Ecodigo#, #form.Periodo#, #form.Mes#, "#session.DSN#", #LvarIncluirUtil#, #LvarConvertida#, #LvarSCero#)>
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
		where CGICMid = #Arguments.FormatoSalida#
		  and CGICLsal = #arguments.NumeroSalida#
	</cfquery>
	
	<cfif rsValida.Cantidad LT 1>
		<form name="form1" method="post" action="<cfoutput>#LvarIrA#</cfoutput>">
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

	<!--- Validar que estén mapeadas todas las cuentas que no sean de orden.  Las cuentas de Orden pueden estar mapeadas, pero no se exigen --->
	<cfquery name="rsValida" datasource="#Arguments.datasource#">
		select count(1) as Cantidad
		from CContables c
			inner join CtasMayor m
			on m.Cmayor = c.Cmayor
			and m.Ecodigo = c.Ecodigo
		where c.Ecodigo = #Arguments.Ecodigo#
		  and c.Cmayor <> c.Cformato
		  and c.Cmovimiento = 'S'
		  and m.Ctipo in ('A', 'P', 'C', 'I', 'G')
		  and ((
		  	select count(1)
			from CGIC_Cuentas cm
			where cm.Ccuenta = c.Ccuenta
			  and cm.CGICMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FormatoSalida#">
			  )) = 0
	</cfquery>

	<cfif rsValida.Cantidad GT 0>
		<cfquery name="rsValida" datasource="#Arguments.datasource#">
			select c.Cformato, c.Cdescripcion
			from CContables c
				inner join CtasMayor m
				on m.Cmayor = c.Cmayor
				and m.Ecodigo = c.Ecodigo
			where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			  and c.Cmayor <> c.Cformato
			  and c.Cmovimiento = 'S'
			  and m.Ctipo in ('A', 'P', 'C', 'I', 'G')
			  and ((
				select count(1)
				from CGIC_Cuentas cm
				where cm.Ccuenta = c.Ccuenta
				  and cm.CGICMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FormatoSalida#">
				  )) = 0
			order by c.Cformato
		</cfquery>
		
		<form name="form1" method="post" action="<cfoutput>#LvarIrA#</cfoutput>">
			<table width="100%">
				<tr><td>&nbsp;</td></tr>
				<tr><td colspan="3" align="center"><strong>ERROR.  No se puede procesar el informe!</strong></td></tr>
				<tr><td>&nbsp;</td></tr>
				<tr><td colspan="3" align="center"><strong>NO estan mapeadas las siguientes cuentas:</strong></td></tr>
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td><strong><cf_translate key=LB_Cuenta>Cuenta</cf_translate></strong></td>
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
	
	<cfquery name="rsValida" datasource="#Arguments.datasource#">
		select count(1) as Cantidad
		from CGIC_Empresa c
		where c.Ecodigo = #Arguments.Ecodigo#
		  and c.CGICMid = #Arguments.FormatoSalida#
	</cfquery>

	<cfif rsValida.Cantidad EQ 0>
		<cfquery datasource="#Arguments.datasource#">
			insert into CGIC_Empresa (CGICMid, Ecodigo) values(#Arguments.FormatoSalida#, #Arguments.Ecodigo#)
		</cfquery>
	</cfif>

	<cfreturn true>
</cffunction>

<cffunction name="GeneraSalidaExterna" output="true" access="private">
	<cfargument name="FormatoSalida" type="numeric" required="yes">
	<cfargument name="NumeroSalida"  type="numeric" required="yes">      <!--- Se asume 1 por el momento, falta tabla padre con la descripción de las salidas --->
	<cfargument name="Ecodigo" 		 type="numeric" required="yes">
	<cfargument name="Periodo" 		 type="numeric" required="yes">
	<cfargument name="Mes" 			 type="numeric" required="yes">
	<cfargument name="datasource" 	 type="string"  default="#session.DSN#" required="no">
	<cfargument name="IncluirUtil" 	 type="boolean" default="yes" required="no">
	<cfargument name="SaldosConv" 	 type="boolean" default="no" required="no">
	<cfargument name="IncluirCeros"  type="boolean" default="no" required="no">

	<cfset LvarTablaSaldos = "SaldosContablesConvertidos">

	<cfset Pcodigo_utilidad = 290>
	<cfset LvarcuentaUtilidad = 0>
    <cfset LvarCtaFuncional = 3810>
     <cfset LvarCtaInforme = 3900>
    
	
	<cfquery name="rsCuentaUtilidad" datasource="#session.dsn#">
		select Pvalor as cuenta
		from Parametros
		where Pcodigo = #Pcodigo_utilidad#
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
    
    <cfquery name="rsMonedaF" datasource="#session.dsn#">
		select Pvalor as cuenta
		from Parametros
		where Pcodigo = #LvarCtaFuncional#
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>

	<cfquery name="rsMonedaI" datasource="#session.dsn#">
		select Pvalor as cuenta
		from Parametros
		where Pcodigo = #LvarCtaInforme#
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>


	<cfif rsCuentaUtilidad.recordcount GT 0>
		<cfset LvarcuentaUtilidad = rsCuentaUtilidad.cuenta>
	</cfif>
	
	<!--- Crear una tabla temporal para soportar la inclusión de la cuenta de utilidad del período --->
	<cf_dbtemp name="SaldosContab">
		<cf_dbtempcol name="Ccuenta"		type="numeric"		mandatory="yes">
		<cf_dbtempcol name="Ecodigo"		type="integer"		mandatory="yes">
		<cf_dbtempcol name="Mcodigo"		type="numeric"		mandatory="yes">
		<cf_dbtempcol name="Ocodigo"		type="integer"		mandatory="yes">
		<cf_dbtempcol name="Speriodo"		type="integer"		mandatory="yes">
		<cf_dbtempcol name="Smes"			type="integer"		mandatory="yes">

		<cf_dbtempcol name="SLinicial"		type="money"		mandatory="no">
		<cf_dbtempcol name="DLdebitos"		type="money"		mandatory="no">
		<cf_dbtempcol name="CLcreditos"		type="money"		mandatory="no">
		<cf_dbtempcol name="SOinicial"		type="money"		mandatory="no">
		<cf_dbtempcol name="DOdebitos"		type="money"		mandatory="no">
		<cf_dbtempcol name="COcreditos"		type="money"		mandatory="no">
		
		<cf_dbtempkey cols="Ccuenta, Speriodo, Smes, Ocodigo, Mcodigo">
	</cf_dbtemp>
	<cfset LvarTablaSaldos = temp_table>

	<!---<cfif Arguments.SaldosConv>--->
		<!--- Obtener la moneda de conversión, cuando se solicitan los saldos convertidos --->
        <cfif isdefined("form.Conversion") and form.Conversion EQ 1 >
        	<cfset lvarMonedaConversion = #rsMonedaF.cuenta#>
       	<cfelseif isdefined("form.Conversion") and form.Conversion EQ 2 >
        	<cfset lvarMonedaConversion = #rsMonedaI.cuenta#>
        <cfelseif isdefined("form.Conversion") and (form.Conversion NEQ 1 and form.Conversion NEQ 2) >        
        	<cfthrow message="Error: Debe seleccionar el Tipo de conversión que desea consultar!">
		<cfelse>
        	<cfthrow message="Error: No se ha definido la moneda para esta conversión!">        
		</cfif>

		<!--- Generar la tabla de Saldos Convertidos --->
		<cfquery datasource="#Arguments.datasource#">
			insert into #LvarTablaSaldos# (
				Ccuenta, Ecodigo, Mcodigo, Ocodigo, Speriodo, Smes, 
				SLinicial, DLdebitos, CLcreditos, SOinicial, DOdebitos, COcreditos)
			select 
				Ccuenta, Ecodigo, Mcodigo, Ocodigo, Speriodo, Smes, 
				sum(SLinicial), sum(DLdebitos), sum(CLcreditos), sum(SLinicial), sum(DLdebitos), sum(CLcreditos)
			from SaldosContablesConvertidos
			where Ecodigo  = #Arguments.Ecodigo#
			  and Speriodo = #Arguments.Periodo#
			  and Smes     = #Arguments.Mes#
			  and Mcodigo  = #lvarMonedaConversion#
           <cfif isdefined("form.Conversion") and form.Conversion EQ 1 >
           	  and B15 = 1
           <cfelseif isdefined("form.Conversion") and form.Conversion EQ 2>
              and B15 = 2
           </cfif>	
			 group by Ccuenta, Ecodigo, Mcodigo, Ocodigo, Speriodo, Smes
		</cfquery>

<!---	<cfelse>

		<!--- Generar la tabla de Saldos Contables --->
		<cfquery datasource="#Arguments.datasource#">
			insert into #LvarTablaSaldos# (
				Ccuenta, Ecodigo, Mcodigo, Ocodigo, Speriodo, Smes, 
				SLinicial, DLdebitos, CLcreditos, SOinicial, DOdebitos, COcreditos)
			select 
				Ccuenta, Ecodigo, Mcodigo, Ocodigo, Speriodo, Smes, 
				sum(SLinicial), sum(DLdebitos), sum(CLcreditos), sum(SLinicial), sum(DLdebitos), sum(CLcreditos)
			from SaldosContables
			where Ecodigo  = #Arguments.Ecodigo#
			  and Speriodo = #Arguments.Periodo#
			  and Smes     = #Arguments.Mes#
			 group by Ccuenta, Ecodigo, Mcodigo, Ocodigo, Speriodo, Smes
		</cfquery>
	</cfif>--->

	<cfif Arguments.IncluirCeros>
		<cfquery datasource="#Arguments.datasource#">
			insert into #LvarTablaSaldos# (
				Ccuenta, Ecodigo, Mcodigo, Ocodigo, Speriodo, Smes, 
				SLinicial, DLdebitos, CLcreditos, SOinicial, DOdebitos, COcreditos)
			select 
				c.Ccuenta, c.Ecodigo, s.Mcodigo, s.Ocodigo, #Arguments.Periodo#, #Arguments.Mes#,
				0.00, 0.00, 0.00, 0.00, 0.00, 0.00
			from CContables c
				inner join SaldosContablesConvertidos s
					on  s.Ccuenta = c.Ccuenta 
					and s.Speriodo = #Arguments.Periodo#
					and s.Smes = #Arguments.Mes#
					and s.Ecodigo = c.Ecodigo
			where c.Ecodigo = #Arguments.Ecodigo#
			  and c.Cmovimiento = 'S'
			  and c.Cformato <> c.Cmayor
			  and not exists(
			  		select count(1)
					from #LvarTablaSaldos# s
					where s.Ccuenta  = c.Ccuenta
					  and s.Ocodigo  = s.Ocodigo
					  and s.Mcodigo  = s.Mcodigo
					   and Ecodigo    = #Arguments.Ecodigo# 
					    and s.Speriodo = #Arguments.Periodo#
					  and s.Smes 	 = #Arguments.Mes# 
				)
		</cfquery>
	</cfif>

	<cfif Arguments.IncluirUtil>
		<!--- 
			Incluir la utilidad del periodo ( cuentas de ingreso o gasto ) 
			de la misma tabla temporal generada
			La tabla se genera por cuenta, oficina y moneda.
			La utilidad en la cuenta especificada se actualiza en el subquery 
			a la misma oficina y moneda.
		--->
		<cfquery datasource="#Arguments.datasource#">
			insert into #LvarTablaSaldos# (
				Ccuenta, Ecodigo, Mcodigo, Ocodigo, Speriodo, Smes, 
				SLinicial, DLdebitos, CLcreditos, SOinicial, DOdebitos, COcreditos)
			select 
				c.Ccuenta, c.Ecodigo, m.Mcodigo, o.Ocodigo, #Arguments.Periodo#, #Arguments.Mes#,
				0.00, 0.00, 0.00, 0.00, 0.00, 0.00
			from CContables c
				inner join Oficinas o
				on o.Ecodigo = c.Ecodigo

				inner join Monedas m
				on m.Ecodigo = c.Ecodigo
			where c.Ccuenta = #LvarcuentaUtilidad#
			  and c.Ecodigo = #Arguments.Ecodigo#
			  and ((
			  		select count(1)
					from #LvarTablaSaldos# s
					where s.Ccuenta = c.Ccuenta
					  and s.Ocodigo = o.Ocodigo
					  and s.Mcodigo = m.Mcodigo
				)) = 0
		</cfquery>

		<cfquery datasource="#Arguments.datasource#">
			update #LvarTablaSaldos#
			set SLinicial = SLinicial + coalesce(( 
					select sum(s.SLinicial + s.DLdebitos - s.CLcreditos)
					from #LvarTablaSaldos# s
						inner join CContables c
							inner join CtasMayor m
							on m.Cmayor = c.Cmayor
							and m.Ecodigo = c.Ecodigo
						on c.Ccuenta = s.Ccuenta
					where s.Ocodigo = #LvarTablaSaldos#.Ocodigo
					  and s.Mcodigo = #LvarTablaSaldos#.Mcodigo
					  and m.Ctipo in ('I', 'G')
					  and c.Cformato = c.Cmayor <!--- Solo cuentas de mayor --->
					  ),0.00)
			where Ccuenta = #LvarcuentaUtilidad#
		</cfquery>
	</cfif>

	<cfif not Arguments.IncluirCeros>
		<cfquery datasource="#Arguments.datasource#">
			delete from #LvarTablaSaldos# 
			where SLinicial = 0
			  and DLdebitos = 0
			  and CLcreditos = 0
			  and (SLinicial + DLdebitos - CLcreditos) = 0
		</cfquery>
	</cfif>
	
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
			inner join  CGIC_Empresa em
				inner join Empresas e
					inner join Monedas mon
                          on mon.Mcodigo  = #lvarMonedaConversion#
				on e.Ecodigo = em.Ecodigo
			on em.CGICMid = m.CGICMid
			and em.Ecodigo = #session.Ecodigo#

			inner join CGIC_Catalogo me
				inner join CGIC_Cuentas mc

					inner join #LvarTablaSaldos# s
					on s.Ccuenta    = mc.Ccuenta

				on mc.CGICCid = me.CGICCid
			on me.CGICMid = m.CGICMid
		where m.CGICMid = #Arguments.FormatoSalida#
  

		<cfif LvarGroup NEQ "">
		group by #PreserveSingleQuotes(LvarGroup)#
		order by #PreserveSingleQuotes(LvarGroup)#
		</cfif>
	</cfquery>

	<cf_htmlReportsHeaders 
		title="Impresion de Informacion Financiera Convertida" 
		filename="PMI.xls"
		irA="#LvarIrA#"
		>
	<!---  Pintar una columna de la tabla por cada columna obtenida --->
	<table style="width:100%" cellpadding="2" cellspacing="2" border="0">
		<tr bgcolor="##999999">
		<cfoutput query="rsObtieneColumnas">
			<td align="right">#rsObtieneColumnas.CGICLhead#</td>
		</cfoutput>
		</tr>
<!---        <cf_dump var = "#data#">--->

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


