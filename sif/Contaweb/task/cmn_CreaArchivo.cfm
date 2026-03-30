<cfif isdefined ("sqldemon.IDArchivo")> 
	<cfset url.LLAVE = #trim(sqldemon.IDArchivo)#>
</cfif> 
<cfif isdefined ("sqldemon.Usuario")>
	<cfset url.USER = #trim(sqldemon.Usuario)#>
</cfif> 

<cfset LLAVE = #trim(url.LLAVE)#>
<cfset USER = #trim(url.USER)#>
<!--- <cfif isdefined ("url.IRALISTA")>
	<cfheader name="Content-Disposition" value="attachment; filename=#trim(USER)#_#LLAVE#">
	<cfcontent type="text/plain">
</cfif> ---> 
<!--- <cfsetting requesttimeout="3600"> --->
<!--- <cfsetting enablecfoutputonly="yes"> --->
<!--- 
****************************************************
**** ACTUALIZACION DEL ESTADO DE tbl_archivoscf ****
****************************************************
--->
<cfquery datasource="#session.dsn#"  name="sqlup" >	
	update  tbl_archivoscf set 
		Status = 'E',
	    FechaProce = getdate()
		where  
		IDArchivo = #LLAVE#
</cfquery>	

<cfquery datasource="#session.dsn#"  name="sql" >	
	select 	Usuario,BorrarArch,TpoRep,Periodo,MesIni,MesFin,ListaCuenta,Mcodigo,Ofi_Emp,TpoImpresion,Ecodigo
	from 	tbl_archivoscf
	where  	IDArchivo = #LLAVE#
</cfquery>

<!--- 
*****************************
**** CARGA DE VARIABLES  ****
*********************** *****
--->
<cfset Usuario 	    = sql.Usuario>
<cfset BorrarArch 	= sql.BorrarArch>
<cfset TpoRep 		= sql.TpoRep>
<cfset Periodo 		= sql.Periodo>
<cfset MesIni 		= sql.MesIni>
<cfset MesFin 		= sql.MesFin>
<cfset ListaCuenta	= sql.ListaCuenta>
<cfset Mcodigo		= sql.Mcodigo>
<cfset Ofi_Emp 		= sql.Ofi_Emp>
<cfset TpoImpresion = sql.TpoImpresion>
<cfset Ecodigo      = sql.Ecodigo>
<cfset LarrCuentas  = ListToarray(ListaCuenta)>
<cfset cantReg      = ArrayLen(LarrCuentas)>

<cfif isdefined("Mcodigo") and  len(trim(Mcodigo))>
	<cfquery name="rsMISO" datasource="#session.dsn#">
		select MISO4217 from Monedas 
		where Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Mcodigo#">
		and  Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Ecodigo#">
	</cfquery>
	<cfset MISO4217      = rsMISO.MISO4217>
</cfif>

<cfquery name="rsUser" datasource="#session.dsn#">
	Select  Usulogin from Usuario
	where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Usuario#">
</cfquery>
<cfset NOM_ARCH = LLAVE & '_'& rsUser.Usulogin>
<!--- ------------------------------------------------ --->
<!---Manejo de las empresas y oficinas                 --->
<!--- ------------------------------------------------ --->
<cfset Oficina  = true>
<cfset Empresa  = true>
<cfset POficinas = "">
<cfset ListaOficinas  = "">
<cfset ListaEmpresas  =  session.Ecodigo>
<cfset PEmpresas      = session.nombreEmpresa>


<cfif isdefined("sql.Ofi_Emp") and len(trim(sql.Ofi_Emp))>
	<cfset LarrUbicacion = ListToarray(sql.Ofi_Emp)>
		<cfif 	len(trim(LarrUbicacion[1])) and LarrUbicacion[1] eq 'ge'><!--- GRUPO DE EMPRESAS --->
			<cfset Oficina  = false>
			<cfset POficinas = "Todas">
			<cfquery name="rsGE" datasource="#session.dsn#">
				select gd.Ecodigo,em.Enombre
				from AnexoGEmpresa ge
					join AnexoGEmpresaDet gd
						on ge.GEid = gd.GEid
					join Empresa em
						on em.Ecodigo = gd.Ecodigo	
				where ge.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
				  and ge.GEid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LarrUbicacion[2]#">
				order by ge.GEnombre
			 </cfquery>
			 <cfif rsGE.recordcount gt 0>
				<cfset ListaEmpresas ="">
				<cfset PEmpresas ="">
				<cfloop query="rsGE" >
					<cfset ListaEmpresas  = ListaEmpresas & rsGE.Ecodigo>
					<cfset PEmpresas  = PEmpresas & rsGE.Enombre>
					<cfif rsGE.currentRow neq rsGE.recordcount>
						<cfset ListaEmpresas = ListaEmpresas & ",">
						<cfset PEmpresas = PEmpresas & "<br>">
					</cfif>	
				</cfloop>
			 </cfif>
		<cfelseif    len(trim(LarrUbicacion[1])) and LarrUbicacion[1] eq 'go'><!--- GRUPO DE OFICINAS --->
			<cfset Empresa  = false>
			<cfquery name="rsGO" datasource="#session.dsn#">
				select gd.Ocodigo ,Oficodigo 
				from AnexoGOficina ge
					join AnexoGOficinaDet  gd
						on ge.GOid= gd.GOid
					join Oficinas ofi
						on gd.Ocodigo= ofi.Ocodigo	
						and gd.Ecodigo= ofi.Ecodigo
				where ge.GOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LarrUbicacion[2]#">
			</cfquery>	
			 <cfif rsGO.recordcount gt 0>
				<cfloop query="rsGO" >
					<cfset ListaOficinas  = ListaOficinas & rsGO.Ocodigo>
					<cfset POficinas      = POficinas & rsGO.Oficodigo>
					<cfif rsGO.currentRow neq rsGO.recordcount>
						<cfset ListaOficinas = ListaOficinas & ",">
						<cfset POficinas     = POficinas & "<br>">
					</cfif>	
				</cfloop>
			 </cfif>					
		<cfelseif   len(trim(LarrUbicacion[1])) and LarrUbicacion[1] eq 'of'><!--- UNA OFICINAS --->
			<cfset Empresa  = false>
			<cfset ListaOficinas  = LarrUbicacion[2]>
			<cfquery name="rsGO" datasource="#session.dsn#">
				select Oficodigo  from Oficinas 
				where Ecodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				and  Ocodigo = 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#LarrUbicacion[2]#">
			</cfquery>
			<cfset POficinas      = POficinas & rsGO.Oficodigo>
		</cfif>
<cfelse>
	<cfset POficinas = "Todas">
	<cfset Oficina  = false>
	<cfset Empresa  = true>
</cfif>

<!--- ------------------------------------------------ --->
<!---Creando Tabla Temporal         				   --->
<!--- ------------------------------------------------ --->
<cf_dbtemp name="ArchivoConta" returnvariable="reporte">
	<cf_dbtempcol name="Ecodigo" type="int">
	<cf_dbtempcol name="Ccuenta" type="numeric">
	<cf_dbtempcol name="nivel" type="int">
</cf_dbtemp>
<cfswitch expression="#TpoRep#">
	<cfcase value="1"><!--- 1 - SALDOS PARA 1 CUENTA        --->
		<!--- ------------------------------------------------ --->
		<!---PRIMER INSERT                                     --->
		<!---AGREGA TODAS LAS CUENTAS DESDE EL NIVEL O HASTA   --->
		<!---EL NIVEL INDICADO EN EL REPORTE                   --->
		<!--- ------------------------------------------------ --->
		<cfset Valores = ListToarray(LarrCuentas[1],'|')>
		<cfset Pcuentas = trim(Valores[1])>
		<cfset CMayor = mid(Pcuentas,1,4)>
		<cfquery name="rs_primer_insert" datasource="#session.dsn#">
			insert #reporte#
				(Ecodigo,  Ccuenta, nivel)
			select 
				c.Ecodigo,
				c.Ccuenta, 
				cu.PCDCniv 
			from CContables c
				inner join PCDCatalogoCuenta cu
					on cu.Ccuentaniv = c.Ccuenta
					and cu.PCDCniv = <cfqueryparam value="#trim(Valores[2])#" cfsqltype="cf_sql_integer"> 
			where 
				<cfif Empresa eq true>
					c.Ecodigo in (#ListaEmpresas#)
				<cfelse>
					c.Ecodigo =  <cfqueryparam value="#Ecodigo#" 	 cfsqltype="cf_sql_integer"> 
				</cfif>
				and  c.Cmayor =      	<cfqueryparam value="#trim(CMayor)#"	 cfsqltype="cf_sql_varchar">
				and c.Cformato like 	<cfqueryparam value="#trim(Valores[1])#%" cfsqltype="cf_sql_varchar">
			group by c.Ecodigo,c.Ccuenta,cu.PCDCniv
		</cfquery>
		<!--- ------------------------------------------------ --->
		<!---SEGUNDO INSERT                                    --->
		<!---PROCESO DE SUMARIZACION DE LA CUENTAS             --->
		<!--- ------------------------------------------------ --->	
		<cfquery name="rs_segundo_insert" datasource="#session.dsn#">
			insert #reporte# (Ecodigo,  Ccuenta, nivel)
			select a.Ecodigo, cu2.Ccuentaniv,cu2.PCDCniv
			from #reporte# a
				inner join PCDCatalogoCuenta cu
					on cu.Ccuentaniv = a.Ccuenta
					and cu.PCDCniv = a.nivel
				inner join PCDCatalogoCuenta cu2
					on cu2.Ccuenta = cu.Ccuenta
					and cu2.PCDCniv < cu.PCDCniv
					and cu2.PCDCniv >= <cfqueryparam value="#trim(Valores[3])#" cfsqltype="cf_sql_integer"> 
			group by a.Ecodigo, cu2.Ccuentaniv,cu2.PCDCniv	
		</cfquery>

	</cfcase>
	<cfcase value="2"><!---2 - SALDOS PARA RANGO            --->
		<cfset Valores1 = ListToarray(LarrCuentas[1],'|')>
		<cfset Valores2 = ListToarray(LarrCuentas[2],'|')>
		<cfset Pcuentas = trim(Valores1[1]) & "<br>" & trim(Valores2[1])>
		<!--- ------------------------------------------------ --->
		<!---PRIMER INSERT                                     --->
		<!---AGREGA TODAS LAS CUENTAS DESDE EL NIVEL O HASTA   --->
		<!---EL NIVEL INDICADO EN EL REPORTE                   --->
		<!--- ------------------------------------------------ --->
		<cfquery name="rs_primer_insert" datasource="#session.dsn#">
			insert #reporte# (Ecodigo,Ccuenta, nivel)
			select 
				c.Ecodigo,
				c.Ccuenta, 
				cu.PCDCniv 
			from CContables c
				inner join PCDCatalogoCuenta cu
					on cu.Ccuentaniv = c.Ccuenta
					and cu.PCDCniv <= <cfqueryparam value="#Valores1[2]#" cfsqltype="cf_sql_integer"> 
			where 
				<cfif Empresa eq true>
					c.Ecodigo in (#ListaEmpresas#)
				<cfelse>
					c.Ecodigo =  <cfqueryparam value="#Ecodigo#" 	 cfsqltype="cf_sql_integer"> 
				</cfif>
				and c.Cformato between <cfqueryparam value="#trim(Valores1[1])#" cfsqltype="cf_sql_varchar"> 
								   and <cfqueryparam value="#trim(Valores2[1])#" cfsqltype="cf_sql_varchar">
				and c.Cmovimiento = 'S'
			group by c.Ecodigo,c.Ccuenta, cu.PCDCniv
		</cfquery> 
		<!--- ------------------------------------------------ --->
		<!---SEGUNDO INSERT                                    --->
		<!---PROCESO DE SUMARIZACION DE LA CUENTAS             --->
		<!--- ------------------------------------------------ --->				
		<cfquery name="rs_segundo_insert" datasource="#session.dsn#">
			insert #reporte# (Ecodigo,  Ccuenta, nivel)
			select a.Ecodigo, cu2.Ccuentaniv,cu2.PCDCniv
			from #reporte# a
				inner join PCDCatalogoCuenta cu
					on cu.Ccuentaniv = a.Ccuenta
					and cu.PCDCniv = a.nivel
				inner join PCDCatalogoCuenta cu2
					on cu2.Ccuenta = cu.Ccuenta
					and cu2.PCDCniv < cu.PCDCniv
					and cu2.PCDCniv >= <cfqueryparam value="#Valores1[3]#" cfsqltype="cf_sql_integer"> 
			group by a.Ecodigo, cu2.Ccuentaniv,cu2.PCDCniv	
		</cfquery>

	</cfcase>
	
	<cfcase value="3"><!---3 - SALDOS PARA LISTA DE CUENTAS --->
		<cfset Pcuentas = "">
		<cfloop index="i"  from="1" to="#cantReg#">
			<cfset arreglo = listtoarray(LarrCuentas[i],"|")>
			<cfset cuenta = "#arreglo[1]#">
			<cfset Pcuentas = Pcuentas & trim(arreglo[1]) & "<br>" >
			<cfset cMayor = mid(cuenta,1,4)>
			<cfset NIVELDET = "#arreglo[2]#">
			<cfset NIVELTOT = "#arreglo[3]#">
			<!--- ------------------------------------------------ --->
			<!---PRIMER INSERT                                     --->
			<!---AGREGA TODAS LAS CUENTAS DESDE EL NIVEL O HASTA   --->
			<!---EL NIVEL INDICADO EN EL REPORTE                   --->
			<!--- ------------------------------------------------ --->
			<cfquery name="rs_primer_insert" datasource="#session.dsn#">
				insert #reporte# (Ecodigo,Ccuenta, nivel)
				select 
					c.Ecodigo,
					c.Ccuenta, 
					cu.PCDCniv 
				from CContables c
					inner join PCDCatalogoCuenta cu
						on cu.Ccuentaniv = c.Ccuenta
						and cu.PCDCniv = <cfqueryparam value="#NIVELDET#" cfsqltype="cf_sql_integer"> 
				where 
					<cfif Empresa eq true>
						c.Ecodigo in (#ListaEmpresas#)
					<cfelse>
						c.Ecodigo =  <cfqueryparam value="#session.Ecodigo#" 	 cfsqltype="cf_sql_integer"> 
					</cfif>
					and  c.Cmayor =      	<cfqueryparam value="#trim(cMayor)#"	 	cfsqltype="cf_sql_varchar">
					and c.Cformato like 	<cfqueryparam value="#trim(cuenta)#%" 		cfsqltype="cf_sql_varchar">
				group by c.Ecodigo, c.Ccuenta, cu.PCDCniv
			</cfquery> 
			<!--- ------------------------------------------------ --->
			<!---SEGUNDO INSERT                                    --->
			<!---PROCESO DE SUMARIZACION DE LA CUENTAS             --->
			<!--- ------------------------------------------------ --->	
			<cfquery name="rs_segundo_insert" datasource="#session.dsn#">
				insert #reporte# (Ecodigo,  Ccuenta, nivel)
				select a.Ecodigo, cu2.Ccuentaniv,cu2.PCDCniv	
				from #reporte# a
					inner join PCDCatalogoCuenta cu
						on cu.Ccuentaniv = a.Ccuenta
						and cu.PCDCniv = a.nivel
					inner join PCDCatalogoCuenta cu2
						on cu2.Ccuenta = cu.Ccuenta
						and cu2.PCDCniv < cu.PCDCniv
						and cu2.PCDCniv >= <cfqueryparam value="#NIVELTOT#" cfsqltype="cf_sql_integer"> 
				group by a.Ecodigo, cu2.Ccuentaniv,cu2.PCDCniv	
			</cfquery>	 
		</cfloop>

	</cfcase>
</cfswitch> 
<cfoutput>
<!--- 
**************************************************************
**** SELECT DE RESULTADOS SEGUN LO SELECIONADO            ****
****        1 =  Saldos acumulados                        ****
****        2 =  Saldos del periodo                       ****
****        3 =  Movimientos del mes                      ****
****        4 =  Movimientos asiento del mes              ****
****        5 =  Movimientos asiento consecutivo del mes  ****
**************************************************************
--->
<cfquery name="rsCuentasContables" datasource="#session.dsn#" >
	<cfswitch expression="#TpoImpresion#"><!--- *******  Saldos acumulados   ******* --->
		<cfcase value="1">
			select Oficodigo,d.Cformato,s.Speriodo,s.Smes,
			<cfif isdefined("Mcodigo") and  len(trim(Mcodigo))>
				sum(s.DOdebitos) as debitos, 
				sum(s.COcreditos)as creditos,
				sum(s.SOinicial  + s.DOdebitos - s.COcreditos) as Neto 
			<cfelse>
				sum(s.DLdebitos) as debitos, 
				sum(s.CLcreditos)as creditos, 
				sum(s.SLinicial + s.DLdebitos - s.CLcreditos) as Neto
			</cfif> 								
			from SaldosContables s							
			inner join #reporte# c
				on  s.Ecodigo = c.Ecodigo
				and s.Ccuenta = c.Ccuenta
			inner join Oficinas o
				on s.Ecodigo = o.Ecodigo
				and s.Ocodigo = o.Ocodigo
			inner join CContables d
				on s.Ecodigo = d.Ecodigo
				and s.Ccuenta = d.Ccuenta		
			where  	s.Speriodo = 	<cfqueryparam value="#Periodo#" 		cfsqltype="cf_sql_integer"> 
			 and 	s.Smes >= 		<cfqueryparam value="#MesIni#" 			cfsqltype="cf_sql_integer"> 
			 and 	s.Smes <= 		<cfqueryparam value="#MesIni#" 			cfsqltype="cf_sql_integer"> 
			<cfif isdefined("Mcodigo") and  len(trim(Mcodigo))>
				and s.Mcodigo in (select Mcodigo from Monedas where 
					Miso4217  = <cfqueryparam value="#trim(MISO4217)#"	 cfsqltype="cf_sql_varchar">
					and Monedas.Ecodigo = s.Ecodigo)		
			</cfif>	
			group by  s.Speriodo,s.Smes,Oficodigo,d.Cformato,d.Cdescripcion
			order by s.Speriodo,s.Smes,Oficodigo,d.Cformato,d.Cdescripcion
		</cfcase>
		<cfcase value="2"><!--- *******  Saldos del periodo    ******* --->
			select Oficodigo,d.Cformato,s.Speriodo,
			<cfif isdefined("Mcodigo") and  len(trim(Mcodigo))>
				sum(s.DOdebitos) as debitos, 
				sum(s.COcreditos)as creditos,
				sum(s.SOinicial  + s.DOdebitos - s.COcreditos) as Neto 
			<cfelse>
				sum(s.DLdebitos) as debitos, 
				sum(s.CLcreditos)as creditos, 
				sum(s.SLinicial + s.DLdebitos - s.CLcreditos) as Neto
			</cfif> 								
			from SaldosContables s							
			inner join #reporte# c
				on  s.Ecodigo = c.Ecodigo
				and s.Ccuenta = c.Ccuenta
			inner join Oficinas o
				on s.Ecodigo = o.Ecodigo
				and s.Ocodigo = o.Ocodigo
			inner join CContables d
				on s.Ecodigo = d.Ecodigo
				and s.Ccuenta = d.Ccuenta		
			where  	s.Speriodo = 	<cfqueryparam value="#Periodo#" 		cfsqltype="cf_sql_integer"> 
			<cfif isdefined("Mcodigo") and  len(trim(Mcodigo))>
				and s.Mcodigo in (select Mcodigo from Monedas where 
					Miso4217  = <cfqueryparam value="#trim(MISO4217)#"	 cfsqltype="cf_sql_varchar">
					and Monedas.Ecodigo = s.Ecodigo)		
			</cfif>	
			group by s.Speriodo,Oficodigo,d.Cformato,d.Cdescripcion
			order by s.Speriodo,Oficodigo,d.Cformato,d.Cdescripcion
		</cfcase>		
		<cfcase value="3"><!--- *******  Movimientos del mes    ******* --->
			select Oficodigo,d.Cformato,s.Smes,Speriodo,
			<cfif isdefined("Mcodigo") and  len(trim(Mcodigo))>
				sum(s.DOdebitos) as debitos, 
				sum(s.COcreditos)as creditos,
				sum(s.SOinicial  + s.DOdebitos - s.COcreditos) as Neto 
			<cfelse>
				sum(s.DLdebitos) as debitos, 
				sum(s.CLcreditos)as creditos, 
				sum(s.SLinicial + s.DLdebitos - s.CLcreditos) as Neto
			</cfif> 								
			from SaldosContables s							
			inner join #reporte# c
				on  s.Ecodigo = c.Ecodigo
				and s.Ccuenta = c.Ccuenta
			inner join Oficinas o
				on s.Ecodigo = o.Ecodigo
				and s.Ocodigo = o.Ocodigo
			inner join CContables d
				on s.Ecodigo = d.Ecodigo
				and s.Ccuenta = d.Ccuenta		
			where  	s.Speriodo = 	<cfqueryparam value="#Periodo#" 		cfsqltype="cf_sql_integer"> 
			 and 	s.Smes >= 		<cfqueryparam value="#MesIni#" 			cfsqltype="cf_sql_integer"> 
			 and 	s.Smes <= 		<cfqueryparam value="#MesFin#" 			cfsqltype="cf_sql_integer"> 
			<cfif isdefined("Mcodigo") and  len(trim(Mcodigo))>
				and s.Mcodigo in (select Mcodigo from Monedas where 
					Miso4217  = <cfqueryparam value="#trim(MISO4217)#"	 cfsqltype="cf_sql_varchar">
					and Monedas.Ecodigo = s.Ecodigo)		
			</cfif>	
			group by Speriodo,s.Smes,Oficodigo,d.Cformato
			order by Speriodo,s.Smes,Oficodigo,d.Cformato
		</cfcase>		
		<cfcase value="4"><!--- *******  Movimientos asiento del mes   ******* --->
			select o.Oficodigo,d.Cformato,a.Eperiodo,a.Emes,b.Cconcepto,
			<cfif isdefined("Mcodigo") and  len(trim(Mcodigo))>
				sum(case Dmovimiento when 'D'  then Doriginal  else 0 end)as debitos, 
				sum(case Dmovimiento when 'C'  then Doriginal  else 0 end )as creditos 								
			<cfelse>
				sum(case Dmovimiento when 'D'  then Dlocal  else 0 end)as debitos, 
				sum(case Dmovimiento when 'C'  then Dlocal  else 0 end )as creditos 								
			</cfif>
			from HDContables a
			inner join HEContables b
				on a.IDcontable = b.IDcontable
			inner join #reporte# c
				on  a.Ecodigo = c.Ecodigo
				and a.Ccuenta = c.Ccuenta
			inner join Oficinas o
				on a.Ecodigo = o.Ecodigo
				and a.Ocodigo = o.Ocodigo	
			inner join CContables d
				on a.Ecodigo = d.Ecodigo
				and a.Ccuenta = d.Ccuenta				
			where  a.Eperiodo = <cfqueryparam value="#Periodo#" 		cfsqltype="cf_sql_integer">
			and  a.Emes >= 		<cfqueryparam value="#MesIni#" 			cfsqltype="cf_sql_integer">
			and  a.Emes <= 		<cfqueryparam value="#MesFin#" 			cfsqltype="cf_sql_integer">
			<cfif isdefined("Mcodigo") and  len(trim(Mcodigo))>
				and a.Mcodigo in (select Mcodigo from Monedas 
						where Miso4217  = <cfqueryparam value="#trim(MISO4217)#"	 cfsqltype="cf_sql_varchar">
						and Monedas.Ecodigo = b.Ecodigo)
			</cfif>	
			<cfif Oficina eq true>
				and a.Ocodigo in (#ListaOficinas#)
			</cfif>
			group by o.Oficodigo,a.Eperiodo,a.Emes,b.Cconcepto,d.Cformato
			order by o.Oficodigo,a.Eperiodo,a.Emes,b.Cconcepto,d.Cformato	
		</cfcase>
		<cfcase value="5"><!--- *******  Movimientos asiento consecutivo del mes    ******* --->
			select o.Oficodigo,d.Cformato,a.Eperiodo,a.Emes,b.Cconcepto,b.Edocumento,
			<cfif isdefined("Mcodigo") and  len(trim(Mcodigo))>
				sum(case Dmovimiento when 'D'  then Doriginal  else 0 end)as debitos, 
				sum(case Dmovimiento when 'C'  then Doriginal  else 0 end )as creditos 								
			<cfelse>
				sum(case Dmovimiento when 'D'  then Dlocal  else 0 end)as debitos, 
				sum(case Dmovimiento when 'C'  then Dlocal  else 0 end )as creditos 								
			</cfif>
			from HDContables a
			inner join HEContables b
				on a.IDcontable = b.IDcontable
			inner join #reporte# c
				on  a.Ecodigo = c.Ecodigo
				and a.Ccuenta = c.Ccuenta
			inner join Oficinas o
				on a.Ecodigo = o.Ecodigo
				and a.Ocodigo = o.Ocodigo	
			inner join CContables d
				on a.Ecodigo = d.Ecodigo
				and a.Ccuenta = d.Ccuenta				
			where  a.Eperiodo = <cfqueryparam value="#Periodo#" 		cfsqltype="cf_sql_integer">
			and  a.Emes >= 		<cfqueryparam value="#MesIni#" 			cfsqltype="cf_sql_integer">
			and  a.Emes <= 		<cfqueryparam value="#MesFin#" 			cfsqltype="cf_sql_integer">
			<cfif isdefined("Mcodigo") and  len(trim(Mcodigo))>
				and a.Mcodigo in (select Mcodigo from Monedas 
						where Miso4217  = <cfqueryparam value="#trim(MISO4217)#"	 cfsqltype="cf_sql_varchar">
						and Monedas.Ecodigo = b.Ecodigo)
			</cfif>	
			<cfif Oficina eq true>
				and a.Ocodigo in (#ListaOficinas#)
			</cfif>
			group by o.Oficodigo,a.Eperiodo,a.Emes,b.Cconcepto,b.Edocumentod.Cformato
			order by o.Oficodigo,a.Eperiodo,a.Emes,b.Cconcepto,b.Edocumentod.Cformato
		</cfcase>
	</cfswitch>
 </cfquery>

<!---
***********************************************
**** Generación del encabezado del archivo ****
***********************************************
--->
<cfset contenidoBloque ="">
<cfif TpoImpresion EQ 1>
   <cfset NOM_ARCH = NOM_ARCH  &"SAL_ACU.txt">
   <cfset contenidoBloque =  contenidoBloque & 'SEGMENTO' & chr(9)>
   <cfset contenidoBloque =  contenidoBloque & 'FORMATOCUENTA' & chr(9)>
   <cfset contenidoBloque =  contenidoBloque & 'MES' & chr(9)>
   <cfset contenidoBloque =  contenidoBloque &'ANNO' & chr(9)>
   <cfset contenidoBloque =  contenidoBloque & 'DEBITOS' & chr(9)>
   <cfset contenidoBloque =  contenidoBloque & 'CREDITOS' & chr(9)>
   <cfset contenidoBloque =  contenidoBloque & 'NETO' & chr(13)>
<cfelseif TpoImpresion EQ 2>
   <cfset NOM_ARCH = NOM_ARCH  & "SAL_PER.txt">
   <cfset contenidoBloque =  contenidoBloque & 'SEGMENTO' & chr(9)>
   <cfset contenidoBloque =  contenidoBloque & 'FORMATOCUENTA' & chr(9)>
   <cfset contenidoBloque =  contenidoBloque & 'ANNO' & chr(9)>
   <cfset contenidoBloque =  contenidoBloque & 'DEBITOS' & chr(9)>
   <cfset contenidoBloque =  contenidoBloque & 'CREDITOS' & chr(9)>
   <cfset contenidoBloque =  contenidoBloque & 'NETO' & chr(13)>
<cfelseif TpoImpresion EQ 3>
   <cfset NOM_ARCH = NOM_ARCH  &"MOV_MES.txt">
   <cfset contenidoBloque =  contenidoBloque & 'SEGMENTO' & chr(9)>
   <cfset contenidoBloque =  contenidoBloque & 'FORMATOCUENTA' & chr(9)>
   <cfset contenidoBloque =  contenidoBloque & 'MES' & chr(9)>
   <cfset contenidoBloque =  contenidoBloque & 'ANNO' & chr(9)>
   <cfset contenidoBloque =  contenidoBloque & 'DEBITOS' & chr(9)>
   <cfset contenidoBloque =  contenidoBloque & 'CREDITOS' & chr(9)>
   <cfset contenidoBloque =  contenidoBloque & 'NETO' & chr(13)>
<cfelseif TpoImpresion EQ 4>
   <cfset NOM_ARCH = NOM_ARCH  & "MOV_MES_AS.txt">
   <cfset contenidoBloque =  contenidoBloque & 'SEGMENTO' & chr(9)>
   <cfset contenidoBloque =  contenidoBloque & 'FORMATOCUENTA' & chr(9)>
   <cfset contenidoBloque =  contenidoBloque & 'MES' & chr(9)>
   <cfset contenidoBloque =  contenidoBloque & 'ANNO' & chr(9)>
   <cfset contenidoBloque =  contenidoBloque & 'ASIENTO' & chr(9)>
   <cfset contenidoBloque =  contenidoBloque & 'DEBITOS' & chr(9)>
   <cfset contenidoBloque =  contenidoBloque & 'CREDITOS' & chr(9)>
   <cfset contenidoBloque =  contenidoBloque & 'NETO' & chr(13)>
<cfelseif TpoImpresion EQ 5>
   <cfset NOM_ARCH = NOM_ARCH  & "MOV_MES_CONS.txt">
   <cfset contenidoBloque =  contenidoBloque & 'SEGMENTO' & chr(9)>
   <cfset contenidoBloque =  contenidoBloque & 'FORMATOCUENTA' & chr(9)>
   <cfset contenidoBloque =  contenidoBloque & 'MES' & chr(9)>
   <cfset contenidoBloque =  contenidoBloque & 'ANNO' & chr(9)>
   <cfset contenidoBloque =  contenidoBloque & 'ASIENTO' & chr(9)>
   <cfset contenidoBloque =  contenidoBloque & 'CONSECUTIVO' & chr(9)>
   <cfset contenidoBloque =  contenidoBloque & 'DEBITOS' & chr(9)>
   <cfset contenidoBloque =  contenidoBloque & 'CREDITOS' & chr(9)>
   <cfset contenidoBloque =  contenidoBloque & 'NETO' & chr(13)>
</cfif>
<!---
*******************************************
**** Creacion del archivo  y variables ****
*******************************************
--->
<cfset tempfile_TXT = "#GetTempDirectory()##NOM_ARCH#">
<cfoutput>Generando el archivo #tempfile_TXT# <br></cfoutput>

<cffile action="write" file="#tempfile_TXT#" output="#contenidoBloque#" nameconflict="overwrite">
<cfset contenidohtml = "">
<cfset contenidoBloque = "">
<!---
***********************************************
**** define la cantidad de bloques en que  ****
**** recorre el resultset                  ****
***********************************************
--->
<cfif TpoImpresion EQ 1>
	<cfset registrosxcontext = 100>
<cfelseif TpoImpresion EQ 2>
	<cfset registrosxcontext = 100>
<cfelseif TpoImpresion EQ 3>
	<cfset registrosxcontext = 100>
<cfelseif TpoImpresion EQ 4>
	<cfset registrosxcontext = 100>
<cfelseif TpoImpresion EQ 5>
	<cfset registrosxcontext = 100>
</cfif>
<cfset Ciclos = rsCuentasContables.recordcount \ registrosxcontext>
<cfset Ciclos = Ciclos + 1>
<!---
***********************************************
**** Inicia recorido del resultset         ****
**** segun el tipo de archivo              ****
***********************************************
--->
<cfloop  index="Cont_Reg" from="1" to="#Ciclos#">
	<cfset startrow = (Cont_Reg-1) * registrosxcontext + 1>
	<cfset endrow = (Cont_Reg * registrosxcontext)>
	<cfif endrow gt rsCuentasContables.recordcount >
	<cfset endrow = rsCuentasContables.recordcount>
	</cfif>
	<cfloop query="rsCuentasContables" startrow="#startrow#" endrow="#endrow#">
	<cfif rsCuentasContables.debitos NEQ 0.00 or rsCuentasContables.creditos NEQ 0.00 or rsCuentasContables.Neto NEQ 0.00>
			<cfif TpoImpresion EQ 1>
  			   <cfset contenidoBloque =  contenidoBloque & rsCuentasContables.Oficodigo & chr(9)>
  			   <cfset contenidoBloque =  contenidoBloque & rsCuentasContables.Cformato & chr(9)>
  			   <cfset contenidoBloque =  contenidoBloque & rsCuentasContables.Speriodo & chr(9)>
			   <cfset contenidoBloque =  contenidoBloque & rsCuentasContables.Smes & chr(9)>
			   <cfif  rsCuentasContables.Neto GT 0 >
		  			   <cfset contenidoBloque =  contenidoBloque & rsCuentasContables.Neto & chr(9)>
   		  			   <cfset contenidoBloque =  contenidoBloque & "0.00" & chr(13)>
			   <cfelse>
   		  			   <cfset contenidoBloque =  contenidoBloque & "0.00" & chr(9)>
   		  			   <cfset contenidoBloque =  contenidoBloque & rsCuentasContables.Neto * -1 & chr(13)>
			   </cfif>
			<cfelseif TpoImpresion EQ 2>
  			   <cfset contenidoBloque =  contenidoBloque & rsCuentasContables.Oficodigo & chr(9)>
  			   <cfset contenidoBloque =  contenidoBloque & rsCuentasContables.Cformato & chr(9)>
			   <cfset contenidoBloque =  contenidoBloque & rsCuentasContables.Speriodo & chr(9)>
  			   <cfset contenidoBloque =  contenidoBloque & rsCuentasContables.debitos & chr(9)>
   			   <cfset contenidoBloque =  contenidoBloque & rsCuentasContables.creditos & chr(9)>
  			   <cfset contenidoBloque =  contenidoBloque & rsCuentasContables.Neto & chr(13)>
			<cfelseif TpoImpresion EQ 3>
  			   <cfset contenidoBloque =  contenidoBloque & rsCuentasContables.Oficodigo & chr(9)>
  			   <cfset contenidoBloque =  contenidoBloque & rsCuentasContables.Cformato & chr(9)>
  			   <cfset contenidoBloque =  contenidoBloque & rsCuentasContables.Smes & chr(9)>
   			   <cfset contenidoBloque =  contenidoBloque & rsCuentasContables.Speriodo & chr(9)>
  			   <cfset contenidoBloque =  contenidoBloque & rsCuentasContables.debitos & chr(9)>
   			   <cfset contenidoBloque =  contenidoBloque & rsCuentasContables.creditos & chr(9)>
  			   <cfset contenidoBloque =  contenidoBloque & rsCuentasContables.Neto & chr(13)>
			<cfelseif TpoImpresion EQ 4>
  			   <cfset contenidoBloque =  contenidoBloque & rsCuentasContables.Oficodigo & chr(9)>
  			   <cfset contenidoBloque =  contenidoBloque & rsCuentasContables.Cformato & chr(9)>
  			   <cfset contenidoBloque =  contenidoBloque & rsCuentasContables.Emes & chr(9)>
			   <cfset contenidoBloque =  contenidoBloque & rsCuentasContables.Eperiodo & chr(9)>
  			   <cfset contenidoBloque =  contenidoBloque & rsCuentasContables.Cconcepto & chr(9)>
  			   <cfset contenidoBloque =  contenidoBloque & rsCuentasContables.debitos & chr(9)>
   			   <cfset contenidoBloque =  contenidoBloque & rsCuentasContables.creditos & chr(9)>
  			   <cfset contenidoBloque =  contenidoBloque & rsCuentasContables.creditos & chr(13)>
			<cfelseif TpoImpresion EQ 5>
  			   <cfset contenidoBloque =  contenidoBloque & rsCuentasContables.Oficodigo & chr(9)>
  			   <cfset contenidoBloque =  contenidoBloque & rsCuentasContables.Cformato & chr(9)>
  			   <cfset contenidoBloque =  contenidoBloque & rsCuentasContables.Emes & chr(9)>
			   <cfset contenidoBloque =  contenidoBloque & rsCuentasContables.Eperiodo & chr(9)>
  			   <cfset contenidoBloque =  contenidoBloque & rsCuentasContables.Cconcepto & chr(9)>
  			   <cfset contenidoBloque =  contenidoBloque & rsCuentasContables.Edocumento & chr(9)>
  			   <cfset contenidoBloque =  contenidoBloque & rsCuentasContables.debitos & chr(9)>
   			   <cfset contenidoBloque =  contenidoBloque & rsCuentasContables.creditos & chr(9)>
  			   <cfset contenidoBloque =  contenidoBloque & rsCuentasContables.creditos & chr(13)>
			</cfif>
		</cfif>			
	</cfloop>
	<cfset fnGraba(contenidoBloque,false)>
	<cfset contenidoBloque = "">
</cfloop>
<cfset fnGraba(contenidoBloque,true)> 
<!--- 
***************************
**** Cambio de estatus ****
***************************
--->
<cfquery datasource="#session.dsn#"  name="sql" >	
	update  tbl_archivoscf set 
		Status = 'L',
		FechaFin  = getdate(),
		FechaEjec = dateadd(YY,500,getdate()),
		NombreArchivo  = <cfqueryparam  cfsqltype="cf_sql_varchar"  value="#NOM_ARCH#">
		where  
		IDArchivo = <cfqueryparam  cfsqltype="cf_sql_integer"  value="#LLAVE#">
</cfquery>
<cfoutput> #NOM_ARCH# #Now()#<br></cfoutput>

</cfoutput>

<!--- 

<!--- 
******************************************
**** en caso de bajar automaticamente ****
******************************************
--->


<cfif isdefined ("url.IRALISTA")>
	<cfquery datasource="#session.dsn#"  name="sql" >	
		set nocount on
		update  tbl_archivoscf set 
			status = <cfqueryparam cfsqltype="cf_sql_varchar"  value="L">
			where  
			IDArchivo = <cfqueryparam  cfsqltype="cf_sql_integer"  value="#LLAVE#">
		set nocount off
	</cfquery>
	<cfcontent type="text/plain" file="#tempfile_TXT#" deletefile="no">
 </cfif>
 <cfoutput> el archivo #trim(USER)#_#LLAVE# generado exitosamente<br></cfoutput>
</cfoutput>



--->