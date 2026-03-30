<!---►►Funciones--->
<cffunction name="esHoja" returntype="string" description="Retorna S, si es Hoja, de lo contrario retorna N">
	<cfargument name="idCuenta" type="numeric" required="yes">
    <cfquery name="rsObtenerCMovimiento" datasource="#Session.DSN#">
    	Select A.Cmovimiento
        From CContables A
        Where A.Ccuenta = #arguments.idCuenta#
  	</cfquery>
    <cfreturn rsObtenerCMovimiento.Cmovimiento>
</cffunction>
	<script>
		!window.jQuery && document.write('<script src="/cfmx/jquery/Core/jquery-1.6.1.js"><\/script>');
	</script>
<!---►►Estilos◄◄--->
<style type="text/css">
	.encabReporte {
		background-color: #006699;
		font-weight: bold;
		color: #FFFFFF;
		padding-top: 2px;
		padding-bottom: 2px;
		font-size:12px;
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
	.tituloLeyenda {
		font-weight: bold;
		font-size:16px;
		color:#0000FF; 
	}
</style>
<cfinclude template="Funciones.cfm">
<!---►►Etiquetas◄◄--->
<cfinvoke key="MSG_Oficina" 			default="Oficina"							returnvariable="MSG_Oficina"			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="LB_Todas"	 			default="Todas"								returnvariable="LB_Todas"				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="MSG_Periodo" 			default="Período"							returnvariable="MSG_Periodo"			component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Moneda" 				default="Moneda" 							returnvariable="MSG_Moneda" 			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="MSG_Local" 				default="Local"								returnvariable="MSG_Local"				component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Informe_B15" 		default="Informe B15"						returnvariable="MSG_Informe_B15"		component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Origen" 				default="Origen"							returnvariable="MSG_Origen"				component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="CMB_Mes" 				default="Mes" 								returnvariable="CMB_Mes" 				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="LB_Nivel" 				default="Nivel"								returnvariable="LB_Nivel"				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="LB_ConCodigo"			default="Con Código"						returnvariable="LB_ConCodigo"			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="MSG_NivelSeleccionado" 	default="Mostrar solo nivel seleccionado"	returnvariable="MSG_NivelSeleccionado"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_GrupoOficinas" 		default="Grupo de Oficinas"					returnvariable="MSG_GrupoOficinas"		component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="CBM_Ninguno" 			default="Ninguno"							returnvariable="CBM_Ninguno"			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="MSG_ComboTipo" 			default="Tipo de Informe"					returnvariable="MSG_ComboTipo"			component="sif.Componentes.Translate" method="Translate"/>
<!---►►Meses◄◄--->
<cfinvoke key="CMB_Enero" 			default="Enero" 	returnvariable="CMB_Enero" 		component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Febrero" 		default="Febrero"	returnvariable="CMB_Febrero"	component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Marzo" 			default="Marzo" 	returnvariable="CMB_Marzo" 		component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Abril" 			default="Abril"		returnvariable="CMB_Abril"		component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Mayo" 			default="Mayo"		returnvariable="CMB_Mayo"		component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Junio" 			default="Junio" 	returnvariable="CMB_Junio" 		component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Julio" 			default="Julio"		returnvariable="CMB_Julio"		component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Agosto" 			default="Agosto" 	returnvariable="CMB_Agosto" 	component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Setiembre"		default="Setiembre"	returnvariable="CMB_Setiembre"	component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Octubre" 		default="Octubre"	returnvariable="CMB_Octubre"	component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Noviembre" 		default="Noviembre" returnvariable="CMB_Noviembre" 	component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Diciembre" 		default="Diciembre"	returnvariable="CMB_Diciembre"	component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfset meses="#CMB_Enero#,#CMB_Febrero#,#CMB_Marzo#,#CMB_Abril#,#CMB_Mayo#,#CMB_Junio#,#CMB_Julio#,#CMB_Agosto#,#CMB_Setiembre#,#CMB_Octubre#,#CMB_Noviembre#,#CMB_Diciembre#">

<cf_navegacion name="Back">
<cf_navegacion name="chkConCodigo" 		   default="0">
<cf_navegacion name="chkNivelSeleccionado" default="0">

<!---►►Oficinas◄◄--->
<cfquery name="rsOficinas" datasource="#Session.DSN#">
    select Ocodigo, Odescripcion 
    from Oficinas 
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<!---►►Periodos Procesados◄◄--->	
<cfquery name="rsPer" datasource="#Session.DSN#">
    select distinct Speriodo as Eperiodo
    from CGPeriodosProcesados
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
    order by Eperiodo desc
</cfquery>
<!---►►Moneda Local◄◄--->
<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
    select a.Mcodigo, b.Mnombre, b.Msimbolo, b.Miso4217
    from Empresas a
    	inner join Monedas b 
        	on a.Mcodigo = b.Mcodigo
    where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>
<!---►►Monedas◄◄--->			
<cfquery name="rsMonedas" datasource="#Session.DSN#">
    select Mcodigo as Mcodigo, Mnombre, Msimbolo, Miso4217, ts_rversion 
    from Monedas
    where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
</cfquery>
<!---►►Grupo de Oficinas◄◄--->
<cfquery name="rsGruposOficina" datasource="#Session.DSN#">
    select GOid, GOcodigo, GOnombre
    from AnexoGOficina
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
    order by GOcodigo
</cfquery>
<!---►►Empresa◄◄--->
<cfquery datasource="#Session.DSN#" name="rsEmpresa">
	select Edescripcion from Empresas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>
<!---►►Periodo Contable◄◄--->
<cfset periodo	= get_val(30).Pvalor>
<!---►►Mes Contable◄◄--->
<cfset mes		= get_val(40).Pvalor>
<!---►►Informe B15◄◄--->	
	<cfset lvarB15V = get_val(3900).Pvalor>
<cfif len(trim(lvarB15V)) gt 0>
    <cfset lvarB15M = get_moneda(lvarB15V).Mnombre>
<cfelse>
    <cfset lvarB15M = "">
</cfif>
<!---►►Niveles◄◄--->
<cfset cantniv 	= ArrayLen(listtoarray(get_val(10).Pvalor,'-'))>

<!---►►Variables de Homologación, para configurar el Reporte◄◄--->
<cfset CG_CambiosSituacion = "CG_Rep_CSF">
<cfset descrip 			   = "Estado de Cambios en la Situación Financiera con Base de Efectivo">
<cfset codhomoga1 		   = "CG_EGO">
<cfset descrhomoga1 	   = "Efectivo Generado en la Opreacion">
<cfset codhomoga2 		   = "Bancos">
<cfset descrhomoga2 	   = "Bancos">
<cfquery name="rsExiste" datasource="#session.dsn#">
	select ANHid,ANHcodigo, ANHdescripcion
	 from ANhomologacion
	where Ecodigo   = #session.Ecodigo#
	  and ANHcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CG_CambiosSituacion#">
</cfquery>

<cfif rsExiste.recordcount eq 0>
	<cfquery name="insert" datasource="#session.dsn#">
		insert into ANhomologacion(
			Ecodigo, 
			ANHcodigo,
			ANHdescripcion,
			BMUsucodigo 
		)
		values(
			#session.Ecodigo#,
			'#CG_CambiosSituacion#',
			'#descrip#',
			#session.Usucodigo#
		)
		<cf_dbidentity1 datasource="#session.DSN#" name="insert">   
	</cfquery>
	<cf_dbidentity2 datasource="#session.DSN#" name="insert" returnvariable="LvarANHid">
	<cfquery name="rsInsert1" datasource="#Session.DSN#">
		insert into ANhomologacionCta (
			   ANHid,
			   ANHCcodigo,
			   ANHCdescripcion,
			   Ecodigo,
			   BMUsucodigo
			  )
		values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarANHid#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#codhomoga1#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#descrhomoga1#">,
				#Session.Ecodigo#,
				#session.Usucodigo#
			)
		  <cf_dbidentity1 datasource="#session.DSN#" name="rsInsert1">   
	</cfquery>
	<cf_dbidentity2 datasource="#session.DSN#" name="rsInsert1" returnvariable="LvarANHidCta1">
	
	<cfquery name="rsInsert2" datasource="#Session.DSN#">
		insert into ANhomologacionCta (
				ANHid,
			   ANHCcodigo,
			   ANHCdescripcion,
			   Ecodigo,
			   BMUsucodigo
			  )
		values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarANHid#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#codhomoga2#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#descrhomoga2#">,
				#Session.Ecodigo#,
				#session.Usucodigo#
			)
		  <cf_dbidentity1 datasource="#session.DSN#" name="rsInsert2">   
	</cfquery>
	<cf_dbidentity2 datasource="#session.DSN#" name="rsInsert2" returnvariable="LvarANHidCta2">
	<cfset ANHCid1 = LvarANHidCta1>
	<cfset ANHCid2 = LvarANHidCta2>
	<cfset LvarBotones = "Configuración">
	<cfset IDANhomologacion = LvarANHid >
<cfelse>
	 <cfset IDANhomologacion = rsExiste.ANHid >
     <cfset existeConfig = true >
     <cfset cont =1>

    <cfquery name="rsExisteHomologa" datasource="#session.dsn#">
        select *
            from ANhomologacionFmts f
                inner join ANhomologacionCta c
                 on c.ANHCid = f.ANHCid
            where c.ANHid = #rsExiste.ANHid#
    </cfquery>
	<cfif rsExisteHomologa.recordcount eq 0>
       <cfset existeConfig = false >
    </cfif>
   
    <cfif not existeConfig>
         <cfset LvarBotones = "Configuración">
    <cfelse>
         <cfset LvarBotones = "Consultar,Configuración">
    </cfif>
</cfif>
<!---►►CFM para retorno y Submit◄◄--->
<cfset LvarIrA = "CambioSituacionBaseEfectivo.cfm">
<!---►►Nombre del Archivo A Generar◄◄--->
<cfset LvarFileName = "CambioSituacionBaseEfectivo#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">

<cfset LvarTitle = "Estado de Cambios en la Situación Financiera con Base de Efectivo">

<cfif (isdefined('form.Consultar') or isdefined('form.Exportar')) and NOT isdefined('form.Back')>
	<!---►►Reporte◄◄--->
    <cfif not isdefined("form.Exportar")>
        <cf_templatecss>
    </cfif>	
    <!---►►Moneda seleccionada◄◄--->
    <cfset monedaSelected ="">
	<cfif isdefined("Form.mcodigoopt") and Form.mcodigoopt EQ "-2">
        <cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
            select a.Mcodigo, b.Mnombre, b.Msimbolo, b.Miso4217
            from Empresas a, Monedas b 
            where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
              and a.Mcodigo = b.Mcodigo
        </cfquery>
        <cfset monedaSelected =rsMonedaLocal.Mnombre>
    <cfelseif isdefined("Form.mcodigoopt") and Form.mcodigoopt EQ "-3">
        <cfquery name="rsParam" datasource="#Session.DSN#">
            select Pvalor
            from Parametros
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
            and Pcodigo = 660
        </cfquery>
        <cfif rsParam.recordCount> 
            <cfquery name="rsMonedaConvertida" datasource="#Session.DSN#">
                select Mcodigo, Mnombre
                from Monedas
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsParam.Pvalor#">
            </cfquery>
        </cfif>
        <cfset monedaSelected ='Convertida a ' & rsMonedaConvertida.Mnombre>
    <cfelseif isdefined("Form.mcodigoopt") and Form.mcodigoopt EQ "-4">
        <cfquery name="rsParam" datasource="#Session.DSN#">
            select Pvalor
            from Parametros
            where Ecodigo = #Session.Ecodigo#
            and Pcodigo = 3900
        </cfquery>
        <cfif rsParam.recordCount> 
            <cfquery name="rsMonedaB15" datasource="#Session.DSN#">
                select Mcodigo, Mnombre
                from Monedas
                where Ecodigo = #Session.Ecodigo#
                and Mcodigo = #rsParam.Pvalor#
            </cfquery>
            <cfset LvarMcodigo = rsMonedaB15.Mcodigo>
        </cfif>
        <cfset monedaSelected ='Informe B15 en ' & rsMonedaB15.Mnombre>
    <cfelseif  isdefined("Form.mcodigoopt") and Form.mcodigoopt EQ "0">
        <cfquery name="rsMonedaSel" datasource="#Session.DSN#">
            select Mcodigo, Mnombre
            from Monedas
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
            and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">
        </cfquery>
        <cfset monedaSelected ='Montos en ' & rsMonedaSel.Mnombre>
    </cfif>
    <!---►►Oficina seleccionada◄◄--->
    <cfquery datasource="#Session.DSN#" name="rsOficinaSelected">
        select Odescripcion
        from Oficinas
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
          and Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.oficina#">
	</cfquery>
	<cfset oficinaSelected = "Todas">
    <cfif rsOficinaSelected.recordCount eq 1>
        <cfset oficinaSelected = rsOficinaSelected.Odescripcion>
    </cfif>
	<cfif isdefined("Form.Oficina") and len(trim(Form.Oficina))>
    	<cfset varOcodigo = Form.Oficina>
    <cfelse>
    	<cfset varOcodigo = "-1">
    </cfif>
    <!---►►Nivel de Detalle◄◄--->
	<cfif isdefined("Form.Nivel") and Form.Nivel neq "-1">
    	<cfset varNivel = Form.Nivel>
    <cfelse>
    	<cfset varNivel = "0">
    </cfif>
    <!---►►Moneda◄◄--->
    <cfif isdefined("Form.mcodigoopt") and Form.mcodigoopt EQ "0">
		<cfset varMonedas = Form.Mcodigo>
    <cfelse>
    	<cfset varMonedas = Form.mcodigoopt>
    </cfif>
    <!---►►Grupo de Oficinas◄◄--->
    <cfif isdefined("Form.GOid") and len(trim(Form.GOid))>
		<cfset varGOid = Form.GOid>
    <cfelse>
        <cfset varGOid = "-1">
    </cfif>
   
  	 <cfquery name="rsOperacion" datasource="#session.dsn#">
      select AnexoCelFmt from ANhomologacionCta CTa
        inner join ANhomologacionFmts ANFm
            on ANFm.ANHCid = Cta.ANHCid
       where CTa.ANHCcodigo =<cfqueryparam cfsqltype="cf_sql_varchar" value="#codhomoga1#">
	</cfquery>
   
      <cfquery name="rsBancos"  datasource="#session.dsn#">
      select AnexoCelFmt from ANhomologacionCta CTa
        inner join ANhomologacionFmts ANFm
            on ANFm.ANHCid = Cta.ANHCid
      where CTa.ANHCcodigo =<cfqueryparam cfsqltype="cf_sql_varchar" value="#codhomoga2#">
   </cfquery>
   
	 <cfset MascarasExcluir = ArrayNew(1)>
     <cfset MascarasIncluir = ArrayNew(1)>
     
	 <cfloop query="rsOperacion">
		<cfset ArrayAppend(MascarasExcluir,rsOperacion.AnexoCelFmt)><!---DEP ACUM--->
        <cfset ArrayAppend(MascarasIncluir,rsOperacion.AnexoCelFmt)><!---DEP ACUM--->
	</cfloop>
  	<cfloop  query="rsBancos">
    	<cfset ArrayAppend(MascarasExcluir,rsBancos.AnexoCelFmt)><!---BANCO--->
    </cfloop>  
    
    <!---►►Se Obtienen los Datos del Reporte◄◄--->
    <cfinvoke returnvariable="rsProc" component="sif.Componentes.sp_SIF_CG0005" method="balanceGeneral">
		<cfinvokeargument name="Ecodigo" 		 value="#Session.Ecodigo#">
		<cfinvokeargument name="periodo" 		 value="#Form.periodo#">
		<cfinvokeargument name="mes" 			 value="#Form.mes#">
        <cfinvokeargument name="TipoCalculo" 	 value="#Form.ComboTipo#">
		<cfinvokeargument name="ceros" 			 value="N">
		<cfinvokeargument name="nivel" 			 value="#varNivel#">
		<cfinvokeargument name="Mcodigo" 		 value="#varMonedas#">
		<cfinvokeargument name="Ocodigo" 		 value="#varOcodigo#">
		<cfinvokeargument name="GOid" 			 value="#varGOid#">
        <cfinvokeargument name="MascarasExcluir" value="#MascarasExcluir#">
	</cfinvoke>
    <!---►►Se Obtienen los Datos del Reporte◄◄--->
    <cfinvoke returnvariable="rsProcOperacion" component="sif.Componentes.sp_SIF_CG0005" method="balanceGeneral">
		<cfinvokeargument name="Ecodigo" 		 value="#Session.Ecodigo#">
		<cfinvokeargument name="periodo" 		 value="#Form.periodo#">
		<cfinvokeargument name="mes" 			 value="#Form.mes#">
        <cfinvokeargument name="TipoCalculo" 	 value="#Form.ComboTipo#">
		<cfinvokeargument name="ceros" 			 value="N">
		<cfinvokeargument name="nivel" 			 value="#varNivel#">
		<cfinvokeargument name="Mcodigo" 		 value="#varMonedas#">
		<cfinvokeargument name="Ocodigo" 		 value="#varOcodigo#">
		<cfinvokeargument name="GOid" 			 value="#varGOid#">
        <cfinvokeargument name="MascarasIncluir" value="#MascarasIncluir#">
	</cfinvoke>
    <!---►►Descripcion de las cuentas◄◄--->
	<cfif form.chkConCodigo EQ "1">
   		<cfset LvarCta = "formato + ' ' + descrip as descrip">
    <cfelse>
    	<cfset LvarCta = "descrip">
    </cfif>
    <!---►►Datos de EFECTIVO GENERADO EN LA OPERACIÓN--->
    <cfquery name="rsCuentasOperacion" dbtype="query">
        select Ccuenta, nivel, #preservesinglequotes(LvarCta)#, saldofin, saldofinA 
         from rsProcOperacion
    </cfquery>
    <cfquery name="sumrsCuentasOperacion" dbtype="query">
        select sum(saldofin) as total,sum(saldofinA) as totalA 
           from rsProcOperacion 
        where nivel = 0 
    </cfquery>
    <cfquery name="rsCuentasA" dbtype="query">
        select Ccuenta, nivel, #preservesinglequotes(LvarCta)#, saldofin, saldofinA 
         from rsProc 
        where tipo = 'A' 
    </cfquery>
    <cfquery name="sumA" dbtype="query">
        select sum(saldofin) as total,sum(saldofinA) as totalA 
           from rsCuentasA 
        where nivel = 0 
    </cfquery>
    <cfquery name="rsCuentasP" dbtype="query">
		select Ccuenta, nivel, #preservesinglequotes(LvarCta)#, saldofin, saldofinA  
         from rsProc 
        where tipo = 'P' 
	</cfquery>
    <cfquery name="sumP" dbtype="query">
        select sum(saldofin) as total,sum(saldofinA) as totalA
         from rsCuentasP 
        where nivel = 0 
    </cfquery>
    <cfquery name="rsCuentasC" dbtype="query">
	    select nivel, Ccuenta, #preservesinglequotes(LvarCta)#, saldofin, saldofinA 
        	from rsProc 
        where tipo = 'C' 
    </cfquery>
    <cfquery name="sumC" dbtype="query">
        select sum(saldofin) as total,sum(saldofinA) as totalA
         from rsCuentasC 
        where nivel = 0 
    </cfquery>

	<cfinclude template="CambioSituacionBaseEfectivo-Report.cfm">
<cfelse>
   	<!---►►Filtros de Entrada◄◄--->
	<cfinclude template="CambioSituacionBaseEfectivo-form.cfm">
</cfif>