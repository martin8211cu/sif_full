<CF_NAVEGACION NAME="GEid">
<CF_NAVEGACION NAME="periodo">
<CF_NAVEGACION NAME="mes">
<CF_NAVEGACION NAME="nivel">
<CF_NAVEGACION NAME="tipo">
<CF_NAVEGACION NAME="Mcodigo">

<!---►►Tabla de las empresas del reporte◄◄--->
<cf_dbtemp name="empresa1">
	<cf_dbtempcol name="id"  		type="int" identity="yes" mandatory="yes" >			
	<cf_dbtempcol name="nombre"		type="varchar(100)"	>
	<cf_dbtempcol name="codigo"  	type="int" >
</cf_dbtemp>

<cfset empresas = temp_table >

<!---►►2. Tabla de Cuentas◄◄--->
<cf_dbtemp name="fcuentas">
	<cf_dbtempcol name="Cformato"  		type="varchar(100)" >			
	<cf_dbtempcol name="Cdescripcion"	type="varchar(100)"	>
	<cf_dbtempcol name="Cmayor"  		type="char(4)" >
	<cf_dbtempcol name="subtipo"  		type="int" >
	<cf_dbtempcol name="tipo" 	 		type="char(1)" >
</cf_dbtemp>

<cfset fcuentas = temp_table >

<!---►►3. Tabla de Saldos x Cuenta x Empresa◄◄--->
<cf_dbtemp name="saldosxempresa">
	<cf_dbtempcol name="Ccuenta"  type="numeric" 		mandatory="yes" >			
	<cf_dbtempcol name="Ecodigo"  type="int" 			mandatory="yes" >
	<cf_dbtempcol name="Cformato" type="varchar(100)" 	mandatory="yes" >
	<cf_dbtempcol name="nivel"    type="int" >
	<cf_dbtempcol name="saldo"    type="money" 			mandatory="yes" >
	<cf_dbtempcol name="tipo"	  type="char(1)"		mandatory="yes" >
</cf_dbtemp>

<cfset saldosxempresa = temp_table >

<cfparam name="form.chkNivelSeleccionado" default="0">
<cfset session.Conta.balances.nivelSeleccionado = (form.chkNivelSeleccionado EQ "1")>

<!--- Funcion para saber si una cuenta es hoja o no --->
<cffunction name="esHoja" returntype="string" description="Retorna S, si es Hoja, de lo contrario retorna N">
	<cfargument name="Cformato" type="string" required="yes">
    <cfquery name="rsObtenerCMovimiento" datasource="#Session.DSN#">
    	Select A.Cmovimiento
        From CContables A
        Where A.Cformato = '#arguments.Cformato#'
  	</cfquery>
    <cfreturn rsObtenerCMovimiento.Cmovimiento>
</cffunction>

<cfif isdefined("Form.nivel") and Form.nivel neq "-1">
	<cfset varNivel = Form.nivel>
<cfelse>
	<cfset varNivel = "0">
</cfif>

<cftransaction>

    <cfquery datasource="#session.DSN#">
        insert into #empresas# (nombre, codigo)
        values ('CONSOLIDADO', 0)
    </cfquery>

    <cfquery datasource="#session.DSN#">
        insert into #empresas# (nombre, codigo)
        select e.Edescripcion, e.Ecodigo
        from AnexoGEmpresaDet dg
            inner join Empresas e
                on e.Ecodigo = dg.Ecodigo
        where dg.GEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEid#" >
        order by e.Ecodigo
    </cfquery>

    <cfquery name="rsSaldos" datasource="#session.DSN#">
        insert into #saldosxempresa#
            (	
                Ccuenta,
                Ecodigo,
                Cformato,
                nivel,
                tipo,
                saldo
            )
        select distinct
                cu.Ccuentaniv,
                cc.Ecodigo,
                cc.Cformato,
                cu.PCDCniv,
                cm.Ctipo,
                0.00
        from #empresas# e
            INNER JOIN CtasMayor cm
                ON cm.Ecodigo = e.codigo 
            INNER JOIN CContables cc
                 ON cc.Ecodigo = cm.Ecodigo
                AND cc.Cmayor  = cm.Cmayor
            INNER JOIN PCDCatalogoCuenta cu <cfif Application.dsinfo[session.dsn].type is 'sybase'>(index PCDCatalogoCuenta_04)</cfif>
                ON cu.Ccuentaniv = cc.Ccuenta
            where 
                <cfif form.tipo eq 1 >
                  cm.Ctipo in ('A', 'P', 'C')
                <cfelse>
                  cm.Ctipo in ('I', 'G')
                </cfif>
              and cu.PCDCniv <= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.nivel#">
              
        select distinct
                cu.Ccuentaniv,
                cc.Ecodigo,
                cc.Cformato,
                cu.PCDCniv,
                cm.Ctipo,
                0.00
        from #empresas# e
            INNER JOIN CtasMayor cm
                ON cm.Ecodigo = e.codigo 
            INNER JOIN CContables cc
                 ON cc.Ecodigo = cm.Ecodigo
                AND cc.Cmayor  = cm.Cmayor
            INNER JOIN PCDCatalogoCuenta cu <cfif Application.dsinfo[session.dsn].type is 'sybase'>(index PCDCatalogoCuenta_04)</cfif>
                ON cu.Ccuentaniv = cc.Ccuenta
            where 
                <cfif form.tipo eq 1 >
                  cm.Ctipo in ('A', 'P', 'C')
                <cfelse>
                  cm.Ctipo in ('I', 'G')
                </cfif>
              and cu.PCDCniv <= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.nivel#">		              
              
    </cfquery>  

<!---	<cfdump var="#form.nivel#">
	<cf_dump var="#rsSaldos#">--->

    <cfquery name="rsMoneda" datasource="#Session.DSN#">
        select Miso4217 
        from Monedas m
        where Mcodigo = #form.Mcodigo#
          and Ecodigo = #session.Ecodigo#
    </cfquery>

	<cfquery name="rsEmpresas" datasource="#Session.DSN#">
        select e2.Ecodigo, m.Mcodigo, m.Miso4217, e2.Edescripcion
         from Monedas m
            inner join #empresas# e
                on e.codigo = m.Ecodigo
            inner join Empresas e2
                on e2.Ecodigo = e.codigo
               and e2.Mcodigo = m.Mcodigo
        where m.Miso4217 <> '#rsMoneda.Miso4217#'
	</cfquery>

    <cfloop query="rsEmpresas">
        <cfquery name="rsParametro" datasource="#Session.DSN#">
            select p.Ecodigo
            from Parametros p
            inner join Monedas m
            on m.Mcodigo = <cf_dbfunction name="to_number" args="p.Pvalor">
            where p.Pcodigo = 660
            and p.Ecodigo = #rsEmpresas.Ecodigo#
            and m.Miso4217 = '#rsMoneda.Miso4217#'
        </cfquery>
        
        <cfif rsParametro.recordcount eq 0>
            <cfthrow message="La empresa #rsEmpresas.Edescripcion#, no se le ha realizado el proceso de Conversi&oacute;n de Estados Financieros">
        <cfelseif rsParametro.recordcount gt 0>
            <cfquery name="rsSaldosConvertidos" datasource="#Session.DSN#">
                select scc.Ccuenta
                 from SaldosContablesConvertidos scc
                  inner join Monedas m
                  	on m.Mcodigo = scc.Mcodigo
                   and m.Ecodigo = scc.Ecodigo
                where scc.Ecodigo  = #rsEmpresas.Ecodigo#
                  and scc.Speriodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.periodo#">
                  and scc.Smes     = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.mes#">
                  and m.Miso4217   = '#rsMoneda.Miso4217#'
            </cfquery>
            <cfif rsSaldosConvertidos.recordcount eq 0>
                <cfthrow message="La empresa #rsEmpresas.Edescripcion#, no se le ha realizado el proceso de Conversi&oacute;n de Estados Financieros para el Periodo: #form.periodo# y Mes: #form.mes#">
            </cfif>
        </cfif>
    </cfloop>
    
    <cfquery name="dos" datasource="#session.DSN#">
        update #saldosxempresa#
        set saldo = coalesce(( 
                select sum(SLinicialGE + DLdebitos - CLcreditos)
                from SaldosContablesConvertidos sc
                where sc.Ccuenta = #saldosxempresa#.Ccuenta
                  and sc.Speriodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.periodo#">
                  and sc.Smes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.mes#">), 0.00)
    </cfquery>

<cfquery datasource="#session.DSN#">
	update #saldosxempresa#
	set saldo = coalesce(( 
			select sum(SLinicialGE + DLdebitos - CLcreditos)
			from SaldosContables sc
			where sc.Ccuenta = #saldosxempresa#.Ccuenta
			  and sc.Speriodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.periodo#">
			  and sc.Smes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.mes#">
              ), 0.00)
	where #saldosxempresa#.Ccuenta not in (select scc.Ccuenta
                                    from SaldosContablesConvertidos scc
                                    where scc.Ccuenta = #saldosxempresa#.Ccuenta
                                      and scc.Speriodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.periodo#">
                                      and scc.Smes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.mes#">
              						)
</cfquery>

<!--- Borrar las cuentas que tengan saldo en cero --->
<cfquery datasource="#session.DSN#">
	delete from #saldosxempresa#
	where saldo = 0.00
	  and nivel <> 0
</cfquery>
<!--- Cambiar el signo estandar de las cuentas:  P=Pasivo, C=Capital, I=Ingreso  pues tienen saldos normalmente al Credito  --->
<cfquery datasource="#session.DSN#">
	update #saldosxempresa#
	set saldo = -saldo
	where tipo in ('P', 'C', 'I')
</cfquery>

<!--- Insertar todas las cuentas diferentes encontradas --->
<cfquery datasource="#session.DSN#">
	insert into #fcuentas# (Cformato, Cdescripcion, Cmayor, tipo, subtipo)
	select distinct 
		se.Cformato, 
		' ', 
		c.Cmayor, 
		se.tipo,
		case se.tipo
			when 'A' then 200 
			when 'P' then 210 
			when 'C' then 220 
			else cm.Csubtipo 
		end as subtipo
	from #saldosxempresa# se
			inner join CContables c
					inner join CtasMayor cm
						on cm.Ecodigo=c.Ecodigo
						and cm.Cmayor=c.Cmayor
			  on c.Ccuenta=se.Ccuenta
</cfquery>

<cfif form.tipo eq 1 >
		<!--- Insertar la cuenta de utilidad por cada empresa --->
		<cfquery datasource="#session.DSN#">
			insert into #fcuentas# (Cformato, Cdescripcion, Cmayor, tipo, subtipo)
			select 
				'zzzzzzzz', 
				'Utilidad del Periodo', 
				'zzzz', 
				'C',
				220 
             from dual
		</cfquery>
		
		<cfquery datasource="#session.DSN#">
			insert into #saldosxempresa#
				(	
					Ccuenta,
					Ecodigo,
					Cformato,
					nivel,
					tipo,
					saldo
				)
			select 	0,
					e.codigo,
					'zzzzzzzz',
					0,
					'C',
					coalesce((
						select sum(-s.SLinicialGE - s.DLdebitos + s.CLcreditos)
						from CContables c
								inner join CtasMayor m
									 on m.Cmayor = c.Cmayor
									and m.Ecodigo = c.Ecodigo
								inner join SaldosContables s
									on s.Ccuenta = c.Ccuenta
						where c.Ecodigo  = e.codigo
						  and c.Cformato = c.Cmayor
						  and m.Ctipo in ('I', 'G')
						  and s.Speriodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.periodo#">
						  and s.Smes     = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.mes#">
					), 0.00) as saldo
			from #empresas# e
			where e.codigo <> 0
		</cfquery>
</cfif>

<!--- Actualizar la descripcion de la cuenta.  Pueden tener descripciones distintas, por lo que se usa la primera --->
<cfquery datasource="#session.DSN#">
	update #fcuentas#
	set Cdescripcion = coalesce(( select min(c.Cdescripcion)
						  		  from #empresas# e, CContables c
								  where c.Ecodigo = e.codigo
								    and c.Cformato = #fcuentas#.Cformato), 'N/A')
	where Cformato <> 'zzzzzzzz'
</cfquery>

<!--- Insertar las cuentas y saldos de la empresa CONSOLIDADA --->
<cfquery datasource="#session.DSN#">
	insert into #saldosxempresa# (
			Ccuenta,
			Ecodigo,
			Cformato,
			nivel,
			tipo,
			saldo)
	select 0, 0, Cformato, nivel, min(tipo), sum(saldo)
	from #saldosxempresa#
	group by Cformato, nivel
</cfquery>

<!--- Cantidad de columnas a generar -  A esto se debe sumar dos columnas de la cuenta y la descripcion --->
<cfquery name="empresa" datasource="#session.DSN#">
	select id as Columna, codigo as Codigo, nombre as Nombre
	from #empresas# 
	where codigo > 0
	order by id
</cfquery>	
	
<!--- Salida para generar la tabla HTML --->
<cfquery datasource="#session.DSN#" name="datos">	
	select 	fc.Cformato as Cuenta, 
			fc.Cdescripcion as Cdescripcion, 
			e.id as Columna, 
			e.codigo as Ecodigo, 
			e.nombre as NombreEmpresa, 
			se.nivel, 
			coalesce(se.saldo, 0.00) as Saldo,
			fc.tipo,
			fc.subtipo
	from #fcuentas# fc
		inner join #empresas# e
			on 1=1
    	left outer join #saldosxempresa# se
           on e.codigo    = se.Ecodigo
          and se.Cformato = fc.Cformato 
	order by fc.subtipo, fc.Cformato, fc.Cdescripcion, e.id
</cfquery>

</cftransaction>
<!--- Estructura para totalizar --->
<cfset subtotales = structnew()>
<cfset subtotales['0'] = 0>
<cfset totales = structnew()>
<cfset totales['0'] = 0>
<cfset subtotalizar = 0>

<cfcontent reset="yes">
<cfif not isdefined('form.btnDownload')>
	<cf_templatecss>
<cfelse>
	<cfset oldlocale = SetLocale("French (Canadian)")>
</cfif>    
<cf_htmlReportsHeaders irA="consolidado-cuentas-filtro.cfm" FileName="consolidado.xls" title="Consolidado de Empresas">
<cfsetting enablecfoutputonly="no">

<cfflush interval="1000">

<style type="text/css">
	.negrita{ font-weight:bold; }
	
	.encabReporte {
		background-color: #006699;
		font-weight: bold;
		color: #FFFFFF;
		padding-top: 2px;
		padding-bottom: 2px;
		font-size:12px;
		font:Arial, Helvetica, sans-serif;
		text-transform:uppercase;
	}
</style> 

<cfinclude template="consolidado-cuentas-impr.cfm">
</body></html>