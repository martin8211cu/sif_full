<cfset RangosArr = ArrayNew(2)>

<cfquery name="rsRangos" datasource="#Session.DSN#">
	select 
		<cf_dbfunction name="to_char" args="AnexoCelId"> as AnexoCelId,
		<cf_dbfunction name="to_char" args="AnexoId"> as AnexoId,
		AnexoRan,
		AnexoCon,
		AnexoRel,
		AnexoMes,
		AnexoPer,
		Ocodigo,
		AnexoNeg	
	from AnexoCel 
	where AnexoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.AnexoId#">
</cfquery>

<cfloop query="rsRangos">
	<cfset Concepto = rsRangos.AnexoCon>
	<cfset Mes = rsRangos.AnexoMes>
	<cfset Per = rsRangos.AnexoPer>
	<cfset Rel = rsRangos.AnexoRel>
	<cfset Neg = rsRangos.AnexoNeg>
	<cfset Ocodigo2 = rsRangos.Ocodigo>
	<cfset AnexoRan = rsRangos.AnexoRan>
	
	<cfif Ocodigo2 EQ "-1">
		<cfset Ocodigo2 = url.OcodigoP>
	</cfif>

	<cfset RangosArr[rsRangos.CurrentRow][1] = Trim(rsRangos.AnexoRan)>

	<cfif Concepto EQ 1> <!--- Empresa --->
			<cfquery name="Empresa" datasource="#Session.DSN#">
				select Edescripcion from Empresas where Ecodigo = #Session.Ecodigo#
			</cfquery>
			<cfset RangosArr[rsRangos.CurrentRow][2] = Trim(Empresa.Edescripcion)>
	</cfif>	

	<cfif Concepto EQ 2> <!--- Oficina --->
			<cfquery name="Oficinas" datasource="#Session.DSN#">
				select Odescripcion 
				from Oficinas 
				where Ecodigo = #Session.Ecodigo# 
				  and Ocodigo = <cfif Ocodigo2 EQ "-1">#url.OcodigoP#<cfelse>#Ocodigo2#</cfif>
			</cfquery>
			<cfset RangosArr[rsRangos.CurrentRow][2] = Trim(Oficinas.Odescripcion)>
	</cfif>	

	<cfif Rel EQ 1>
		<cfset Mest = url.MesP - Mes>
		<cfset Per = url.PerP>
		<cfif Mest LT 1>
			<cfset Mes = 12 + ((url.MesP - Mes) mod 12) >
			<cfset Per = url.PerP - 1 - ((Mes - url.MesP) \ 12)>
		<cfelse>
			<cfset Mes = Mest>
		</cfif>
	<cfelse>
		<cfset Per = url.PerP - Per>
	</cfif>

	<cfif Concepto EQ 10> <!--- Número de Mes seleccionado en la celda--->
			<cfset RangosArr[rsRangos.CurrentRow][2] = Mes>
	</cfif>	

	<cfif Concepto EQ 11> <!--- Nombre del Mes seleccionado en la celda--->
			<cfset RangosArr[rsRangos.CurrentRow][2] = Trim(Monthasstring(Mes))>
	</cfif>	

	<cfif Concepto EQ 12> <!--- Número el Año seleccionado en la celda--->
			<cfset RangosArr[rsRangos.CurrentRow][2] = Trim(Per)>
	</cfif>	

	<cfif Concepto EQ 13> <!--- Numero del mes / Numero del año seleccionado de la celda --->
		<cfset RangosArr[rsRangos.CurrentRow][2] = "#Mes# / #Per#">
	</cfif>
	
	<cfif Concepto EQ 14> <!--- Leyenda de Fin de Mes --->
		<cfset RangosArr[rsRangos.CurrentRow][2] = "Al #DaysInMonth(CreateDate(Per, Mes, 1))# de #MonthAsString(Mes)# del #Per#" >
	</cfif>

	<cfif Concepto GTE 20> <!--- Operaciones con Cuentas --->
		<cfset sql = "select sum(">
		<cfif url.McodigoP EQ -1> 
			<cfif Concepto EQ 20>
				<cfset sql = sql & " SLinicial + DLdebitos - CLcreditos">
			</cfif>
			<cfif Concepto  EQ 21>
				<cfset sql = sql & " SLinicial">
			</cfif>
			<cfif Concepto  EQ 22 or Concepto EQ 32>
				<cfset sql = sql & " DLdebitos">
			</cfif>
			<cfif Concepto  EQ 23 or Concepto EQ 33>
				<cfset sql = sql & " CLcreditos">
			</cfif>
			<cfif Concepto  EQ 24 or Concepto EQ 34>
				<cfset sql = sql & " DLdebitos - CLcreditos">
			</cfif>
		<cfelse>
			<cfif Concepto EQ 20>
				<cfset sql = sql & " SOinicial + DOdebitos - COcreditos">
			</cfif>
			<cfif Concepto  EQ 21>
				<cfset sql = sql & " SOinicial">
			</cfif>
			<cfif Concepto  EQ 22 or Concepto EQ 32>
				<cfset sql = sql & " DOdebitos">
			</cfif>
			<cfif Concepto  EQ 23 or Concepto EQ 33>
				<cfset sql = sql & " COcreditos">
			</cfif>
			<cfif Concepto  EQ 24 or Concepto EQ 34>
				<cfset sql = sql & " DOdebitos - COcreditos">
			</cfif>
		</cfif>

		<cfset sql = sql & " ) " >

		<cfif rsRangos.AnexoNeg EQ 1>
			<cfset sql = sql & "*-1">
		</cfif>
		<cfset sql = sql & " as total
					from AnexoCelD d, CContables c, SaldosContables s
					where d.AnexoCelId = #rsRangos.AnexoCelId#
					  and c.Ecodigo = #Session.Ecodigo#
					  and c.Cformato like d.AnexoCelFmt
					  and (c.Cmovimiento = 'S' or d.AnexoCelMov = 'N')
					  and s.Ccuenta = c.Ccuenta
					  and s.Ecodigo = c.Ecodigo">

		<cfif Concepto LT 32>
			<cfset sql = sql & "  and s.Speriodo = #Per# 
						  and s.Smes = #Mes# ">
		<cfelse>
			<cfquery name="rsParametros" datasource="#Session.DSN#">
				select Pvalor from Parametros where Ecodigo = #Session.Ecodigo# and Pcodigo = 45
			</cfquery>
			<cfset MesInicial = rsParametros.Pvalor>
			<cfif Mes LT MesInicial>
				<cfset PerInicial = Per - 1>
				<cfset PerFinal = Per>
			<cfelse>
				<cfset PerInicial = Per>
				<cfset PerFinal = Per + 1>
			</cfif>

			<cfif MesInicial GT 1>
				<cfset MesFinal = MesInicial - 1>
			<cfelse>
				<cfset MesFinal = 12>
			</cfif>
			<cfset MesInicial = (PerInicial*100)+MesInicial>
			<cfset MesFinal = (PerFinal*100)+MesFinal>
			<cfset sql = sql & "  and s.Speriodo >= #PerInicial# 
						  and s.Speriodo <= #PerFinal#
						  and ((s.Speriodo*100)+s.Smes) between #MesInicial# and #MesFinal#">
		</cfif>
		<cfif url.McodigoP NEQ -1>
			<cfset sql = sql & "  and s.Mcodigo = #McodigoP#">
		</cfif>
		<cfif Ocodigo2 NEQ "-1">
			<cfset sql = sql & "  and s.Ocodigo = #Ocodigo2#">
		</cfif>
	</cfif>
	
	<cfif Concepto GTE 20> <!--- Saldo Final del Mes de las Cuentas Seleccionadas --->
 		<!--- <br><cfdump var="#sql#"><br> --->
		<cfquery name="rsDatos" datasource="#Session.DSN#">
			#PreserveSingleQuotes(sql)#
		</cfquery>
		<cfif len(trim(rsDatos.total)) EQ 0>
			<cfset RangosArr[rsRangos.CurrentRow][2] = "0.00" >		
		<cfelse>
			<cfset RangosArr[rsRangos.CurrentRow][2] = "#rsDatos.total#" >
		</cfif>
	</cfif>
</cfloop>

<script language="JavaScript1.2">
	parent.form1.grid.activeworkbook.unprotect();
</script>

<!--- OJO, aqui hay un error de Javascript si hay elementos en la bd, que no estan definidos en la hoja de calculo --->
<cfloop index="i" from="1" to="#rsRangos.RecordCount#">
	<cftry>
	<script language="JavaScript1.2">
			<cfoutput>
				parent.form1.grid.Range('#RangosArr[i][1]#').value='#RangosArr[i][2]#';
			</cfoutput>	
	</script>
	<cfcatch></cfcatch>
	</cftry>
</cfloop>

<script language="JavaScript1.2">
	parent.form1.grid.activeworkbook.protect();
</script>
