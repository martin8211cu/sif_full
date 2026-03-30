<cf_dbfunction name="to_char" args="alm.Ocodigo" returnvariable ="Ocodigo1"> 
<cf_dbfunction name="concat" args="#preservesinglequotes(Ocodigo1)# + '-' + o.Odescripcion" returnvariable = "Oficina" delimiters = "+">
<cf_dbfunction name="concat" args="rtrim(alm.Almcodigo)+ '-' + alm.Bdescripcion" returnvariable = "Almacen" delimiters = "+">
<cf_dbfunction name="spart" args="c.Cformato,1,25" returnvariable ="Cuenta1"> 

<cfset varCcodigo = 0>
<cfset varCcodigoF = 0>
<!--- Almacenes --->
<cfset Lvaralmini = "">
<cfset Lvaralmfin = "">
<!--- Clasificaciones --->
<cfset LvarCcodigo = "">
<cfset LvarCcodigoF = "">

<cfif isdefined("Url.almini") and Url.almini neq "" >
	<cfset Lvaralmini =Url.almini >
</cfif>	
<cfif isdefined("Url.almfin") and Url.almfin neq "" >
	<cfset Lvaralmfin = Url.almfin>
</cfif>
<cfif isdefined("Url.Ccodigo") and Url.Ccodigo neq "" >
	<cfset LvarCcodigo = Url.Ccodigo>
    <cfset varCcodigo = 1>
</cfif>		
<cfif isdefined("Url.CcodigoF") and Url.CcodigoF neq "" >
	<cfset LvarCcodigoF = Url.CcodigoF>
    <cfset varCcodigoF = 1>
</cfif>
    
<cfif isdefined('Url.CcuentaI') and len(trim(Url.CcuentaI)) gt 0>
    <cfquery name="rsCuentaI" datasource="#session.dsn#">
        select Cformato
        from CContables
        where Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Url.CcuentaI#">
    </cfquery>
    <cfset lvarCcuentaI = rsCuentaI.Cformato>
</cfif>
<cfif isdefined('Url.CcuentaF') and len(trim(Url.CcuentaF)) gt 0>
    <cfquery name="rsCuentaF" datasource="#session.dsn#">
        select Cformato
        from CContables
        where Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Url.CcuentaF#">
    </cfquery>
    <cfset lvarCcuentaF = rsCuentaF.Cformato>
</cfif>

<cfquery name="rsReporte" datasource="#session.DSN#">
	<cfif Url.Mostrar eq 1>
	select Oficina, 
		   Cuenta, 
		   descCuenta, 
		   max(Periodo) as Periodo,
		   max(Mes) as Mes,
		   sum(Costo_Inicial) as Costo_Inicial, 
		   sum(Debitos) as Debitos, 
		   sum(Creditos) as Creditos, 
		   sum(Costo_Final) as Costo_Final 
		from (
	</cfif>	
				Select 
						#preservesinglequotes(Oficina)# as Oficina,
						#preservesinglequotes(Cuenta1)# as Cuenta,
						c.Cdescripcion as descCuenta,
						coalesce(ei.EIperiodo,#Url.Periodo#) as Periodo,
						coalesce(ei.EIMes,#Url.Mes#) as Mes,
						 cs.Cdescripcion, 
						
						<cfif Url.Mostrar eq 2>
							#preservesinglequotes(Almacen)# as Almacen,
							a.Acodigo as Producto,
							coalesce(ei.EIexistencia, 0) as Existencia_Inicial, 
				
							<!---Entradas--->
							coalesce((select sum(K.Kunidades) from(Select sum(Kunidades) as Kunidades
							from Kardex ent 
							where ent.Aid 		  = e.Aid
								and ent.Alm_Aid   = e.Alm_Aid
								and ent.Kperiodo   = <cfqueryparam cfsqltype="cf_sql_integer" value="#Url.Periodo#">
								and ent.Kmes 	      = <cfqueryparam cfsqltype="cf_sql_integer" value="#Url.Mes#">
								and ent.Kunidades >= 0)K),0) as Entradas_Unidades,
					
							<!---Salidas--->
							abs(coalesce((select sum(K.Kunidades) from ((Select sum(Kunidades) as Kunidades
							from Kardex sal
							where sal.Aid 	  = e.Aid
								and sal.Alm_Aid   = e.Alm_Aid
								and sal.Kperiodo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Url.Periodo#">
								and sal.Kmes 	  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Url.Mes#">
								and sal.Kunidades < 0))K),0)) as Salidas_Unidades,
					
							<!---Final: inicial + Entradas - Salidas--->
								
							min(coalesce(ei.EIexistencia,0)) +
							coalesce((select sum(K.Kunidades) from ((
											select sum(Kunidades) as Kunidades
											from Kardex ent
											where ent.Aid 		  = e.Aid
												and ent.Alm_Aid 	  = e.Alm_Aid
												and ent.Kperiodo   = <cfqueryparam cfsqltype="cf_sql_integer" value="#Url.Periodo#">
												and ent.Kmes 	      = <cfqueryparam cfsqltype="cf_sql_integer" value="#Url.Mes#">
												and ent.Kunidades >= 0
											))K),0) +
					
							coalesce((select sum(K.Kunidades)from ((
											Select sum(Kunidades) as Kunidades
											from Kardex sal
											where sal.Aid 		  = e.Aid
												and sal.Alm_Aid 	  = e.Alm_Aid
												and sal.Kperiodo   = <cfqueryparam cfsqltype="cf_sql_integer" value="#Url.Periodo#">
												and sal.Kmes 	      = <cfqueryparam cfsqltype="cf_sql_integer" value="#Url.Mes#">
												and sal.Kunidades < 0
											))K),0) as Existencia_Final,
							
						</cfif>
						sum(coalesce(ei.EIcosto, 0.00)) as Costo_Inicial, 
							
						<!---Creditos--->
						coalesce((select sum(D.Kcosto) from(
										Select sum(Kcosto) as Kcosto
                                        from Kardex ent
										where ent.Aid 		  = e.Aid
											and ent.Alm_Aid 	  = e.Alm_Aid
											and ent.Kperiodo   = <cfqueryparam cfsqltype="cf_sql_integer" value="#Url.Periodo#">
											and ent.Kmes 	      = <cfqueryparam cfsqltype="cf_sql_integer" value="#Url.Mes#">
											and ent.Kunidades >= 0
										)D),0) as Debitos,
				
						<!---Debitos--->
						abs(coalesce((select sum(C.Kcosto) as Kcosto from(	
										Select sum(Kcosto) as Kcosto from Kardex sal 
                                        where sal.Aid 		  = e.Aid
											and sal.Alm_Aid   = e.Alm_Aid
											and sal.Kperiodo   = <cfqueryparam cfsqltype="cf_sql_integer" value="#Url.Periodo#">
											and sal.Kmes 	      = <cfqueryparam cfsqltype="cf_sql_integer" value="#Url.Mes#">
											and sal.Kunidades < 0
										)C),0)) as Creditos,
				
				
						<!---Final: inicial + Debitos - Creditos--->
						sum(coalesce(ei.EIcosto, 0.00))  + 
				
						coalesce((select sum(K.Kcosto) from(	(
										Select sum(Kcosto) as Kcosto
										from Kardex ent
                                        where ent.Aid 		  = e.Aid
											and ent.Alm_Aid 	  = e.Alm_Aid
											and ent.Kperiodo   = <cfqueryparam cfsqltype="cf_sql_integer" value="#Url.Periodo#">
											and ent.Kmes 	      = <cfqueryparam cfsqltype="cf_sql_integer" value="#Url.Mes#">
											and ent.Kunidades >= 0
										))K),0) +
				
						coalesce((select sum(CF.Kcosto) from(	(
										Select sum(Kcosto)as Kcosto from Kardex sal 
                                       where sal.Aid 		  = e.Aid
											and sal.Alm_Aid 	  = e.Alm_Aid
											and sal.Kperiodo   = <cfqueryparam cfsqltype="cf_sql_integer" value="#Url.Periodo#">
											and sal.Kmes 	      = <cfqueryparam cfsqltype="cf_sql_integer" value="#Url.Mes#">
											and sal.Kunidades < 0
										))CF),0)  as Costo_Final
				
				from Articulos a
						inner join Existencias e
							on e.Aid = a.Aid
				
						inner join Clasificaciones cs
							on cs.Ecodigo = a.Ecodigo
							and cs.Ccodigo = a.Ccodigo
							
						inner join Almacen alm
							on alm.Aid = e.Alm_Aid
				
						inner join Oficinas o
							 on o.Ecodigo = alm.Ecodigo
							and o.Ocodigo = alm.Ocodigo
				
						inner join IAContables ci
							on ci.Ecodigo = e.Ecodigo
							and ci.IACcodigo = e.IACcodigo 
				
						inner join CContables c
							on c.Ccuenta = ci.IACinventario
				
						left join ExistenciaInicial ei
							 on ei.Aid = e.Aid
							and ei.Alm_Aid = e.Alm_Aid
							and ei.EIperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Url.Periodo#">
							and ei.EIMes     = <cfqueryparam cfsqltype="cf_sql_integer" value="#Url.Mes#">
				
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					<cfif isdefined('Url.OficodigoI') and len(trim(Url.OficodigoI)) gt 0>
					  and rtrim(o.Oficodigo) >= <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Url.OficodigoI)#">
					</cfif>
					<cfif isdefined('Url.OficodigoF') and len(trim(Url.OficodigoF)) gt 0>
					  and rtrim(o.Oficodigo) <= <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Url.OficodigoF)#">
					</cfif>
					<cfif isdefined('lvarCcuentaI') and len(trim(lvarCcuentaI)) gt 0 >
						and rtrim(c.Cformato) >= <cfqueryparam cfsqltype="cf_sql_char" value="#trim(lvarCcuentaI)#">
					</cfif>
					<cfif isdefined('lvarCcuentaF') and len(trim(lvarCcuentaF)) gt 0>
						and rtrim(c.Cformato) <= <cfqueryparam cfsqltype="cf_sql_char" value="#trim(lvarCcuentaF)#">
					</cfif>
						and alm.Aid between <cfqueryparam cfsqltype="cf_sql_numeric" value="#almini#"> and <cfqueryparam cfsqltype="cf_sql_numeric" value="#almfin#">
					<cfif  varCcodigo eq 1 and varCcodigoF eq 1>
								and a.Ccodigo between <cfqueryparam cfsqltype="cf_sql_integer" value="#Ccodigo#"> 
												and <cfqueryparam cfsqltype="cf_sql_integer" value="#CcodigoF#">
					</cfif>    
					group by e.Alm_Aid,e.Aid,
						#preservesinglequotes(Oficina)#, 
						#preservesinglequotes(Cuenta1)#, 
						c.Cdescripcion, 
						coalesce(ei.EIperiodo,#Url.Periodo#) , 
						coalesce(ei.EIMes,#Url.Mes#),
						cs.Cdescripcion
						<cfif Url.Mostrar eq 2>
						   ,#preservesinglequotes(Almacen)#, 
							a.Acodigo, 
							ei.EIexistencia
						</cfif>
					
					<cfif Url.Mostrar eq 2>				
						order by
							#preservesinglequotes(Oficina)#,
							#preservesinglequotes(Cuenta1)#,
							c.Cdescripcion,
							coalesce(ei.EIperiodo,#Url.Periodo#),
							coalesce(ei.EIMes,#Url.Mes#),
							cs.Cdescripcion,
							#preservesinglequotes(Almacen)#,
							a.Acodigo,
							ei.EIexistencia
					</cfif>
			<cfif Url.Mostrar eq 1>			
			 ) TReportDes
			 
			 group by Oficina, Cuenta, descCuenta			
			 order by Oficina, Cuenta, descCuenta
			 </cfif>			 
</cfquery>


<cfif isdefined("Url.Formato") and len(trim(Url.Formato)) and Url.Formato EQ 1>
	<cfset formatos = "flashpaper">
<cfelseif isdefined("Url.Formato") and len(trim(Url.Formato)) and Url.Formato EQ 2>
	<cfset formatos = "pdf">
<cfelseif isdefined("Url.Formato") and len(trim(Url.Formato)) and Url.Formato EQ 3>
	<cfset formatos = "excel">
</cfif>
<cfif formatos EQ 'excel'>
    <cf_QueryToFile query="#rsReporte#" FILENAME="KardexCuentasC.xls" titulo="Inventario por Cuenta Contable">
<cfelse>
	<cfset lvarFiltroO = "Todas las Oficinas">
    <cfif isdefined('Url.OficodigoI') and len(trim(Url.OficodigoI)) gt 0 and isdefined('Url.OficodigoF') and len(trim(Url.OficodigoF)) gt 0>
        <cfset lvarFiltroO = "Oficina desde #trim(Url.OficodigoI)#-#Url.OdescripcionI# hasta #trim(Url.OficodigoF)#-#Url.OdescripcionF#">
    <cfelseif isdefined('Url.OficodigoI') and len(trim(Url.OficodigoI)) gt 0>
        <cfset lvarFiltroO = "Oficina desde #trim(Url.OficodigoI)#-#Url.OdescripcionI#">
    <cfelseif isdefined('Url.OficodigoF') and len(trim(Url.OficodigoF)) gt 0>
        <cfset lvarFiltroO = "Oficina hasta #trim(Url.OficodigoF)#-#Url.OdescripcionF#">
    </cfif>
    <cfset lvarFiltroC = "Todas las Cuentas">
    <cfif isdefined('lvarCcuentaI') and len(trim(lvarCcuentaI)) gt 0 and isdefined('lvarCcuentaF') and len(trim(lvarCcuentaF)) gt 0>
        <cfset lvarFiltroC = "Cuenta desde #trim(lvarCcuentaI)# hasta #trim(lvarCcuentaF)#">
    <cfelseif isdefined('lvarCcuentaI') and len(trim(lvarCcuentaI)) gt 0>
        <cfset lvarFiltroC = "Cuenta desde #trim(lvarCcuentaI)#">
    <cfelseif isdefined('lvarCcuentaF') and len(trim(lvarCcuentaF)) gt 0>
        <cfset lvarFiltroC = "Cuenta hasta #trim(lvarCcuentaF)#">
    </cfif>
    <cfif Url.Mostrar eq 1><!--- Mostrar resumido --->
        <cfset lvarTemplate = "InventarioPorCuentaRes.cfr">
    <cfelseif not isdefined('Url.Corte')><!--- Mostrar detallado sin corte Almacen --->
        <cfset lvarTemplate = "InventarioPorCuentaDet.cfr">
    <cfelse><!--- Mostrar detallado con corte Almacen --->
        <cfset lvarTemplate = "InventarioPorCuenta.cfr">
    </cfif>
    <!--- INVOCA EL REPORTE --->
    <cfreport format="#formatos#" template= "#lvarTemplate#" query="rsReporte">
        <cfreportparam name="Ecodigo" value="#session.Ecodigo#">
        <cfreportparam name="Edesc" value="#session.Cenombre#">
        <cfreportparam name="FiltroO" value="#lvarFiltroO#">
        <cfreportparam name="FiltroC" value="#lvarFiltroC#">
        <cfif isdefined("Url.Periodo") and len(trim(Url.Periodo)) and Url.Periodo NEQ -1> 
            <cfreportparam name="Periodo" value="#Url.Periodo#">
        <cfelse>
            <cfreportparam name="Periodo" value="1900">
        </cfif>
        <cfif isdefined("Url.Mes") and len(trim(Url.Mes)) and Url.Mes NEQ -1> 
            <cfreportparam name="Mes" value="#Url.Mes#">		
        <cfelse>
            <cfreportparam name="Mes" value="1">
        </cfif>
    </cfreport>
</cfif>