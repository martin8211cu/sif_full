<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_ResumenMinisterioDeTrabajo" default="Resumen Ministerio de Trabajo" returnvariable="LB_ResumenMinisterioDeTrabajo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_NoHayDatosRelacionados" default="No hay datos relacionados" returnvariable="LB_NoHayDatosRelacionados" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Fecha" default="Fecha" returnvariable="LB_Fecha" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Periodo" default="Periodo" returnvariable="LB_Periodo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Mes" default="Mes" returnvariable="LB_Mes" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Nomina" default="N&oacute;mina" returnvariable="LB_Nomina" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->
<!--- CREACION DEL RANGO DE FECHAS --->
<cfset Lvar_FechaInicio = CreateDate(#url.anno#,#url.Mes#,1)>
<cfset Lvar_FechaFin = DateAdd('d',-1,DateAdd('m',1,Lvar_FechaInicio))>

	<!--- TABLA TEMPORAL PARA LOS EMPLEADOS --->
    <cf_dbtemp name="EmpleadosListaMTR" returnvariable="empleados1">
    	<cf_dbtempcol name="DEid"   		type="numeric"     	mandatory="yes">
        <cf_dbtempcol name="LTid"   		type="numeric"     	mandatory="yes">
        <cf_dbtempkey cols="DEid">
    </cf_dbtemp>

	<!--- TABLA TEMPORAL PARA LOS EMPLEADOS --->
    <cf_dbtemp name="salidaEmpleadosResMT" returnvariable="empleados">
    	<cf_dbtempcol name="DEid"   		type="numeric"     	mandatory="yes">
        <cf_dbtempcol name="LTid"   		type="numeric"     	mandatory="yes">
        <cf_dbtempcol name="Dias"			type="int" 			mandatory="no">
        <cf_dbtempcol name="Horas"			type="float"		mandatory="no">
        <cf_dbtempcol name="Nomina"			type="char(5)"		mandatory="no">
        <cf_dbtempcol name="CFid"			type="numeric"		mandatory="no">
        <cf_dbtempcol name="CFcodigo"		type="char(10)"		mandatory="no">
        <cf_dbtempcol name="CFdescripcion"	type="varchar(60)"	mandatory="no">
        <cf_dbtempkey cols="DEid,LTid">
    </cf_dbtemp>
    <!--- INGRESA LOS DATOS DE LOS EMPLEADOS QUE HAN TRABAJADO EN EL PERIODO INDICADO --->
    <cfset fecha = Now()>
    <cfset fecha1_temp = createdate( 6100, 01, 01 )>
    <!--- <cftransaction> --->
    <cfquery name="rsListaEmpleados" datasource="#session.DSN#">
    	<!--- insert into #empleados1# (DEid,LTid)--->
    	select lt.DEid, max(lt.LTid) as LTid
        from LineaTiempo lt
        where lt.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			 and (LTdesde between <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaInicio#">
        					and <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaFin#">
			   or LThasta between <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaInicio#">
        					and <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaFin#">
			   or (LTdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaInicio#"> 
			   		and LThasta > <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaFin#">)
			   or (LTdesde < <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaInicio#"> 
			   		and LThasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaFin#">)
			   )
		and lt.Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#url.Tcodigo#">
        group by lt.DEid
    </cfquery>
    <cfloop query="rsListaEmpleados">
        <cfquery name="rsListaEmpleados" datasource="#session.DSN#">
            insert into #empleados1# (DEid,LTid)
            values(#DEid#,#LTid#)
        </cfquery>
    </cfloop>

    <cfquery name="rsListaEmpleados" datasource="#session.DSN#">
    	<!---insert into #empleados# (DEid,LTid,Nomina,CFid, CFcodigo, CFdescripcion)--->
        select lt.DEid,lt.LTid,Tcodigo, cf.CFid, cf.CFcodigo, cf.CFdescripcion
        from #empleados1# e1
		inner join LineaTiempo lt
			on lt.LTid = e1.LTid
			and lt.DEid = e1.DEid
        inner join RHPlazas p
			on p.RHPid = lt.RHPid
		inner join CFuncional cf
			on cf.CFid = p.CFid
    </cfquery>
   	<cfloop query="rsListaEmpleados">
        <cfquery name="rsListaEmpleados" datasource="#session.DSN#">
            insert into #empleados# (DEid,LTid,Nomina,CFid, CFcodigo, CFdescripcion)
            values(#DEid#,#LTid#,'#Tcodigo#',#CFid#,'#CFcodigo#','#CFdescripcion#')
        </cfquery>
    </cfloop>
    <!--- </cftransaction> --->
    <!--- ACTUALIZA LOS DIAS PAGADOS EN EL CALENDARIO DE PAGO --->
	<cfquery name="rsDias" datasource="#session.DSN#">
    	update #empleados#
        set Dias = coalesce((select sum(PEcantdias)
                            from HPagosEmpleado
                            where DEid = #empleados#.DEid
                              and (PEdesde between <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaInicio#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaFin#">
                              or PEhasta between <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaInicio#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaFin#">)
                            group by DEid),0)
    </cfquery>
    <!--- MONTO DE DIAS DE INCIDENCIAS POR HORAS --->
    <cfquery name="rsSalarioOrd" datasource="#session.DSN#">
    	update #empleados#
        set Horas = coalesce((select sum(ICvalor)
                            from HIncidenciasCalculo ic
                            inner join RHJornadas j
                                on ic.RHJid = j.RHJid
                                and ic.CIid = j.RHJincHJornada 
                            where DEid = #empleados#.DEid	
                              and ic.ICfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaInicio#">
                              				and <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaFin#">
                           ),0)
    </cfquery>
    <cfquery name="rsReporte" datasource="#session.DSN#">
    	select CFid, CFcodigo, CFdescripcion,
        		sum(Dias)/count(1) as Dias, sum(Horas)/count(1) as Horas,
                count(1) as cantidad
        from #empleados#
        group by CFid,CFcodigo, CFdescripcion
    </cfquery>
<!--- <cf_dump var="#rsReporte#"> --->
    <!--- FIN DE RECOLECCION DE DATOS DEL REPORTE --->
    <!--- Busca el nombre de la Empresa --->
    <cfquery name="rsEmpresa" datasource="#session.DSN#">
        select Edescripcion
        from Empresas
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
    </cfquery>
    <cfquery name="rsTipoNomina" datasource="#session.DSN#">
    	select Tdescripcion
        from TiposNomina
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
          and Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#url.Tcodigo#">
    </cfquery>
    <style>
	h1.corte {
		PAGE-BREAK-AFTER: always;}
	.tituloAlterno {
		font-size:20px;
		font-weight:bold;
		text-align:center;}
	.titulo_empresa2 {
		font-size:18px;
		font-weight:bold;
		text-align:center;}
	.titulo_reporte {
		font-size:16px;
		font-style:italic;
		text-align:center;}
	.titulo_filtro {
		font-size:14px;
		font-style:italic;
		text-align:center;}
	.titulolistas {
		font-size:14px;
		font-weight:bold;
		background-color:#CCCCCC;
		}
	.titulo_columnar {
		font-size:14px;
		font-weight:bold;
		background-color:#CCCCCC;
		text-align:right;}
	.listaCorte {
		font-size:10px;
		font-weight:bold;
		background-color: #F4F4F4;
		text-align:left;}
	.listaCorte3 {
		font-size:10px;
		font-weight:bold;
		background-color:  #E8E8E8;
		text-align:left;}
	.listaCorte2 {
		font-size:10px;
		font-weight:bold;
		background-color: #D8D8D8;
		text-align:left;}
	.listaCorte1 {
		font-size:14px;
		font-weight:bold;
		background-color: #7A7A7A;
		text-align:left;}
	.total {
		font-size:14px;
		font-weight:bold;
		text-align:right;}

	.detalle {
		font-size:14px;
		text-align:left;}
	.detaller {
		font-size:14px;
		text-align:right;}
	.detallec {
		font-size:14px;
		text-align:center;}	
	.mensaje {
		font-size:14px;
		text-align:center;}
	.paginacion {
		font-size:14px;
		text-align:center;}
</style>
	
    <table width="500" border="0" align="center" cellpadding="2" cellspacing="0">
    	<cfoutput>
        <tr><td align="center" class="titulo_empresa2" colspan="5"><strong>#rsEmpresa.Edescripcion#</strong></td></tr>
        <tr><td align="center" class="titulo_empresa2" colspan="5"><strong>#LB_ResumenMinisterioDeTrabajo#</strong></td></tr>
        <tr><td align="center" class="titulo_empresa2" colspan="5"><strong>#LB_Nomina#: #rsTipoNomina.Tdescripcion#</strong></td></tr>
        <tr><td align="center" class="titulo_empresa2" colspan="5"><strong>#LB_Periodo#: #url.anno# &nbsp; #LB_Mes#: #url.mes#	</strong></td></tr>
        <tr><td colspan="5">&nbsp;</td></tr>
        </cfoutput>
    
    	<tr><td height="1" bgcolor="000000" colspan="5"></td>
        <tr  class="listaCorte1">
        	<td><cf_translate key="LB_CentroDeCosto">Centro de Costo</cf_translate></td>
            <td align="center"><cf_translate key="LB_Personal">Personal</cf_translate></td>
            <td align="center"><cf_translate key="LB_DiasLaborados">D&iacute;as Laborados</cf_translate></td>
            <td align="center"><cf_translate key="LB_Horas">Horas</cf_translate></td>
            <td align="center"><cf_translate key="LB_Total">Total</cf_translate></td>
        </tr>
        <tr><td height="1" bgcolor="000000" colspan="5"></td>
        <cfsilent>
			<cfset Lvar_Dias = 0>
            <cfset Lvar_Horas = 0>
            <cfset Lvar_Personas = 0>
        </cfsilent>
        <cfoutput query="rsReporte">
        <tr>
       		<td align="center" class="detalle">#CFcodigo# - #CFdescripcion#</td>
            <td align="center" class="detallec">#cantidad#</td>
            <td align="center" class="detallec">#Horas#</td>
            <td align="center" class="detallec">#LSCurrencyFormat(Dias,'none')#</td>
            <td align="center" class="detaller">&nbsp;</td>
      	</tr>
        <cfsilent>
			<cfset Lvar_Dias = Lvar_Dias + Dias>
            <cfset Lvar_Horas = Lvar_Horas + Horas>
            <cfset Lvar_Personas = Lvar_Personas + cantidad>
        </cfsilent>
        </cfoutput>
        <cfoutput>
        <tr><td height="1" bgcolor="000000" colspan="5"></td>
        <tr class="total">
        	<td class="detaller"><cf_translate key="LB_Total">Total</cf_translate></td>
            <td class="detallec">#Lvar_Personas#</td>
            <td class="detaller" colspan="2">&nbsp;</td>
            <td class="detaller">&nbsp;</td>
        </tr>
        <tr><td height="1" bgcolor="000000" colspan="5"></td>
        </cfoutput>
    </table>

