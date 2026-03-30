<!--- Inicializa Variables --->
<cfset barchivo = 0>
<cfset bcontador = 1>

<cfquery name="rscheck1" datasource="#session.DSN#">
	select a.CBcc as cuentaorigen, b.CPfpago as fpago
	from ERNomina a
		inner join CalendarioPagos b		
			on b.CPid = a.RCNid
			and b.Ecodigo = a.Ecodigo
	where a.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#">
	  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
</cfquery>
<cfset bcuentaorigen = trim(rscheck1.cuentaorigen)>
<cfset bfpago = rscheck1.fpago>

<!--- Calcula el numero de consecutivo(archivo) --->
<cfquery name="rscheck2" datasource="#session.DSN#">
	select * 
	from RHParametros 
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#"> 
		and Pcodigo=210 
</cfquery>
<cfset bcoincidencias =  rscheck2.recordcount>

<cfif bcoincidencias GTE 1>
	<cfquery name="rscheck3" datasource="#session.DSN#">
		select <cf_dbfunction name="to_number" args="coalesce(Pvalor,'1')"> as archivo
		from RHParametros
		where Pcodigo=210
		and Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#"> 
	</cfquery>
	<cfset barchivo = rscheck3.archivo>
<cfelse>
	<cfset barchivo =1>
</cfif> 
<cfif barchivo GTE 1000>
	<cfset barchivo = 0>
</cfif>
<!--- documento --->
<cfset bdocumento =1>

<!--- Recupera la cedula juridica de la empresa--->
<cfquery name="rsCedJ" datasource="#session.DSN#">
	select Eidentificacion as cedulajur
	from Empresa <!--- Ecodigo ASP --->
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.ecodigosdc#">
</cfquery>
<cfset bcedulajur = rsCedJ.cedulajur>

<!--- Quita guiones a la cedula juridica --->
<cfset bcedulajur = replace(bcedulajur,'-','','all')>

<!--- Recupera la cédula del empleado que registra --->
<cfquery name="rsdatos" datasource="#session.DSN#">
	select b.Pid as cedula
	from Usuario a, DatosPersonales b
	where a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
	  and a.datos_personales = b.datos_personales
</cfquery>
<cfset bcedula = rsdatos.cedula>

<cfif len(trim(bcedula)) EQ 0><cfset bcedula = '3337844'></cfif>

<!--- Quita guiones a la cedula del empleado --->
<cfset bcedula = replace(bcedula,'-','','all')>

<!--- Quita guiones de la cuenta de la que se saca la plata --->
<cfset bcuentaorigen = replace(bcuentaorigen,'-','','all')>

<!--- Calculo del testkey--->
<cfquery name="rsResultado1" datasource="#session.DSN#">
	select 
		sum(
			<cf_dbfunction name="to_number" args="substring(CBcc, 6, 3)">
			+ 
			<cf_dbfunction name="to_number" args="substring(CBcc, 9, {fn LENGTH(rtrim(CBcc))}-9)">
		) as resultado1
	from DRNomina 
	where ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#">
	  and Bid = <cfqueryparam  cfsqltype="cf_sql_numeric"  value="#url.Bid#">
	  and {fn LENGTH(rtrim(ltrim(CBcc)))} > 9
</cfquery>  
<cfset bresultado1 = rsResultado1.resultado1> 

<cfquery name="rsResultado2" datasource="#session.DSN#">
	select 
	sum(
			floor(
				<cf_dbfunction name="to_number" args="substring(CBcc, 6, {fn LENGTH(rtrim(CBcc))}-6)">
				/
				(case DRNliquido when 0 then 1 else DRNliquido end)
			)
		) as resultado2
	from DRNomina 
	where ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#">
	  and Bid = <cfqueryparam  cfsqltype="cf_sql_numeric"  value="#url.Bid#">
	  and {fn LENGTH(rtrim(ltrim(CBcc)))} > 9
</cfquery>  
<cfset bresultado2 = rsResultado2.resultado2>

<cfif (len(trim(rsResultado1.resultado1)) EQ 0) or (len(trim(rsResultado2.resultado2)) eq 0)>
	<cfset btestkey = -1>
<cfelse>
	<cfset btestkey = bresultado1 + bresultado2>
</cfif>


<cftransaction>
	<!---Crea tabla temporal con la llave primaria ID--->
	<cf_dbtemp name="RHExportarBCR" returnvariable="RHExportarBCR" datasource="#session.dsn#">
		<cf_dbtempcol name="ID" 	type="numeric"		identity ="yes"> 
		<cf_dbtempcol name="orden" 	type="int" 			mandatory="no"> 
		<cf_dbtempcol name="data"  	type="varchar(255)" mandatory="no">
		<cf_dbtempcol name="linea"  type="int" 			mandatory="no">
		<cf_dbtempkey cols="ID">
	</cf_dbtemp>	
	
	<cfquery name ="ERR" datasource="#session.DSN#">
		insert into #RHExportarBCR# (orden, data, linea)
		select 
			1, 
			<cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring(' ',2)#0"> 
			|| <cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring(' ',12-Len(bcedulajur))&bcedulajur#">
			|| <cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring(' ',3-Len(barchivo))&barchivo#">
				|| <cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring('0',2-Len(Day(bfpago)))&Day(bfpago)&repeatstring('0',2-Len(Month(bfpago)))&Month(bfpago)&mid(Year(bfpago),3,2)#">
			|| <cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring(' ',11-Len(bcedula))&bcedula#">
			<cfif btestkey NEQ -1>
			|| <cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring(' ',12-Len(btestkey))&btestkey#">
			</cfif>
			|| <cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring(' ',19)#0">
			|| <cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring(' ',15)#0">,
			1
		from ERNomina
		where ERNid = <cfqueryparam  cfsqltype="cf_sql_numeric"  value="#url.ERNid#">
	</cfquery>

	<cfquery name ="ERR" datasource="#session.DSN#">
		insert into #RHExportarBCR#(orden, data, linea)
		select 
			2, 
			 <cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring(' ',2)#01">
			|| <cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring(' ',4)#0">
			|| <cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring(' ',2)#1">
			|| <cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring(' ',8 - Len(bcuentaorigen))&bcuentaorigen#">
			||'04'
			|| <cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring(' ',3)#0">
			|| <cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring(' ',6)#1">
			|| replicate(' ',12-{fn LENGTH(<cf_dbfunction name="to_char_integer" args="sum(a.DRNliquido)*100">)}) || <cf_dbfunction name="to_char_integer" args="sum(a.DRNliquido)*100">
			|| <cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring('0',2-Len(Day(bfpago)))&Day(bfpago)&repeatstring('0',2-Len(Month(bfpago)))&Month(bfpago)&mid(Year(bfpago),3,2)#">
			|| '0'
			|| <cf_dbfunction name="to_char" args="b.ERNdescripcion"> || replicate(' ', 30-{fn length(rtrim(b.ERNdescripcion))})
			|| '0',
			1
		from DRNomina a
			inner join ERNomina b
			on b.ERNid = a.ERNid
			and b.ERNid = <cfqueryparam  cfsqltype="cf_sql_numeric"  value="#url.ERNid#">
			and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		where a.Bid is not null
	</cfquery>
	<cfquery name ="ERR" datasource="#session.DSN#">
		insert into #RHExportarBCR#(orden, data, linea)
		select 3, replicate(' ',2)
		 || '0' || substring(a.CBcc,5,1)  <!---Tipo de Cuenta (1 Corriente, 2 Ahorro)--->
		 || replicate(' ',4) || '0'
		 || replicate(' ',3-{fn LENGTH(<cf_dbfunction name="to_char_integer" args="substring(a.CBcc, 6, 3)">)}) <!--- Oficina--->
		 || <cf_dbfunction name="to_char_integer" args="substring(a.CBcc, 6, 3)">
		 || substring(a.CBcc, 9, {fn LENGTH(rtrim(a.CBcc))}-9)
		 || '0'
		 || '2'
		 || <cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring(' ',3)#0">
		 || case when {fn LENGTH(<cf_dbfunction name="to_char" args="DRNlinea">)} < 8 
		 		then replicate(' ', 8 - {fn LENGTH(<cf_dbfunction name="to_char" args="DRNlinea">)}) 
			end
		 || case when {fn LENGTH(<cf_dbfunction name="to_char" args="DRNlinea">)} > 8 
			 then substring(<cf_dbfunction name="to_char" args="DRNlinea"> ,({fn LENGTH(<cf_dbfunction name="to_char" args="DRNlinea">)}-8)+1, 
			 {fn length(<cf_dbfunction name="to_char" args="DRNlinea">)}-({fn length(<cf_dbfunction name="to_char" args="DRNlinea">)}-8))
			 else <cf_dbfunction name="to_char" args="DRNlinea">
			end
		 || replicate(' ',12- {fn length(<cf_dbfunction name="to_char_integer" args="DRNliquido*100">)} ) 
		 || <cf_dbfunction name="to_char_integer" args="DRNliquido*100">
		 || <cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring('0',2-Len(Day(bfpago)))&Day(bfpago)&repeatstring('0',2-Len(Month(bfpago)))&Month(bfpago)&mid(Year(bfpago),3,2)#">
		 || '0'
		 || <cf_dbfunction name="to_char" args="b.ERNdescripcion"> || replicate(' ', 30-{fn length(rtrim(b.ERNdescripcion))})
		 || '0',
		 null
		from DRNomina a
			inner join ERNomina b
				on b.ERNid = a.ERNid
				and b.ERNid=<cfqueryparam  cfsqltype="cf_sql_numeric"  value="#url.ERNid#">
				and b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		where a.Bid = <cfqueryparam  cfsqltype="cf_sql_numeric"  value="#url.Bid#">
			  and a.ERNid=<cfqueryparam  cfsqltype="cf_sql_numeric"  value="#url.ERNid#">
	 		  and {fn LENGTH(rtrim(a.CBcc))} > 9
	</cfquery>
	<cfquery name="rsBusca" datasource="#session.DSN#">
		select data, ID
		from #RHExportarBCR# 
		where orden = 3
	</cfquery>
	<cfloop query="rsBusca">
		<cfquery name="rsBuscaB" datasource="#session.DSN#">
			update #RHExportarBCR# 
				set data = substring(data,1,30) || replicate(' ',4-{fn length(<cfqueryparam cfsqltype="cf_sql_integer" value="#bcontador#">)}) 
				|| <cfqueryparam cfsqltype="cf_sql_integer" value="#bcontador#"> 
				|| substring(data,36,{fn length(data)})<!---, <cfqueryparam cfsqltype="cf_sql_integer" value="#bcontador#">---><!---@contador=@contador + 1 --->
			where orden = 3
			 and ID = #rsBusca.ID#
		</cfquery>
		<cfset bcontador = bcontador + 1>
	</cfloop>	

	<cfset bcontador = 1>

	<cfquery  name="rsBuscaLin" datasource="#session.DSN#">
		select linea, ID
		from #RHExportarBCR#
		where orden = 3
	</cfquery>

	<cfloop query="rsBuscaLin">
		<cfquery name="rsBuscaLinB" datasource="#session.DSN#">
			update #RHExportarBCR# 
			set	linea = <cfqueryparam cfsqltype="cf_sql_integer" value="#bcontador#"><!---@contador, @contador=@contador + 1 --->
			where orden = 3
			and ID = #rsBuscaLin.ID#
		</cfquery>
		<cfset bcontador = bcontador + 1>
	</cfloop>
	
	<cfquery  name="rscheckA" datasource="#session.DSN#">
		select count(1) as c1
		from DRNomina a
			inner join ERNomina b
			on b.ERNid = a.ERNid
				and b.ERNid=<cfqueryparam  cfsqltype="cf_sql_numeric"  value="#url.ERNid#">
				and b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		where a.ERNid=<cfqueryparam  cfsqltype="cf_sql_numeric"  value="#url.ERNid#">
		and a.Bid=<cfqueryparam  cfsqltype="cf_sql_numeric"  value="#url.Bid#">
		and {fn LENGTH(rtrim(a.CBcc))} > 9
	</cfquery>
	<cfset bc1 = rscheckA.c1>
		
	<cfquery  name="rscheckB" datasource="#session.DSN#">
		select count(1) as c2
		from #RHExportarBCR#
		where orden = 3
	</cfquery>
	<cfset bc2 = rscheckB.c2>

<!--- 	<cfdump var="#bc1#">
	<cf_dump var="#bc2#"> --->
	
 	<cfif bc1 NEQ bc2>
		<cfquery name="ERR" datasource="#session.DSN#">
			 select 'La cantidad de Personas generadas en el archivo para este Banco no concuerda con la cantidad de Personas en la Relación de Cálculo!' as MSG 
			 from dual
		</cfquery>
	</cfif>
	<cfif bc1 EQ bc2> <!--- Si todo está Bien: ejecuta --->
		<cfquery name="ERR" datasource="#session.DSN#">
			select data 
			from #RHExportarBCR# 
			order by orden, linea
		</cfquery>
			 
		<!--- actualiza el consecutivo en RHParametros --->
		<cfset barchivo = barchivo +1>
		
		<cfquery name="rsupdateA" datasource="#session.DSN#">
			update RHParametros
			set Pvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#barchivo#"> 
			  where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and Pcodigo=210
		</cfquery>
		<cfquery name="rsupd" datasource="#session.DSN#">
			select Pvalor
			from RHParametros
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Pcodigo=210
		</cfquery>
		<cfif rsupd.RecordCount EQ 0> 
			<cfquery datasource="#session.DSN#">
				insert into RHParametros(Ecodigo, Pcodigo, Pdescripcion, Pvalor)
				values (<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">, 210, 'Consecutivo de Archivo de Planilla', <cfqueryparam cfsqltype="cf_sql_varchar" value="#barchivo#">)
			</cfquery>
		</cfif>
		<cfquery datasource="#session.dsn#">
			drop table #RHExportarBCR#
		</cfquery>
</cfif>			



</cftransaction>
