<cfset fnProcesaConsulta()>
<!--- *************************************************** --->
<!--- ****      Area de filtros                      **** --->
<!--- *************************************************** --->
<cfsavecontent variable="LEstadoResultadosHTML">
	<style type="text/css">
        .topline {
            border-top-width: 1px;
            border-top-style: solid;
            border-top-color: #000000;
            border-right-style: none;
            border-bottom-style: none;
            border-left-style: none;
            font-family: "Lucida Sans Unicode";
			font-size:small;
        }
        .leftline {
            border-left-width: 1px;
            border-left-style: solid;
            border-left-color: #000000;
            border-right-style: none;
            border-bottom-style: none;
            border-top-style: none;
			font-family: "Lucida Sans Unicode";
			font-size:small;
        }
        .rightline {
            border-right-width: 1px;
            border-right-style: solid;
            border-right-color: #000000;
            border-left-style: none;
            border-bottom-style: none;
            border-top-style: none;
			font-family: "Lucida Sans Unicode";
			font-size:small;
        }
        .bottomline {
            border-bottom-width: 1px;
            border-bottom-style: solid;
            border-bottom-color: #000000;
            border-right-style: none;
            border-top-style: none;
            border-left-style: none;
            font-family: "Lucida Sans Unicode";
			font-size:small;
        }
        .Lbottomline {
            border-bottom-width: 1px;
            border-bottom-style: solid;
            border-bottom-color: #000000;
            border-left-width: 1px;
            border-left-style: solid;
            border-left-color: #000000;
            border-top-style: none;
            border-right-style: none;
			font-family: "Lucida Sans Unicode";
			font-size:small;
        }
        .Rbottomline {
            border-bottom-width: 1px;
            border-bottom-style: solid;
            border-bottom-color: #000000;
            border-right-width: 1px;
            border-right-style: solid;
            border-right-color: #000000;
            border-top-style: none;
            border-left-style: none;
			font-family: "Lucida Sans Unicode";
			font-size:small;
        }
        .RLbottomline {
            border-bottom-width: 1px;
            border-bottom-style: solid;
            border-bottom-color: #000000;
            border-right-width: 1px;
            border-right-style: solid;
            border-right-color: #000000;
            border-left-width: 1px;
            border-left-style: solid;
            border-left-color: #000000;
            border-top-style: none;
            font-family: "Lucida Sans Unicode";
			font-size:small;
        }
        .RLline {
            border-bottom-style: none;
            border-right-width: 1px;
            border-right-style: solid;
            border-right-color: #000000;
            border-left-width: 1px;
            border-left-style: solid;
            border-left-color: #000000;
            border-top-style: none;
            font-family: "Lucida Sans Unicode";
			font-size:small;
        }
        .LbTottomline {
            border-bottom-width: 1px;
            border-bottom-style: solid;
            border-bottom-color: #000000;
            border-left-width: 1px;
            border-left-style: solid;
            border-left-color: #000000;
            border-top-width: 1px;
            border-top-style: solid;
            border-top-color: #000000;
            border-right-style: none;
            font-family: "Lucida Sans Unicode";
			font-size:small;

        }

        .RLTbottomline {
            border-bottom-width: 1px;
            border-bottom-style: solid;
            border-bottom-color: #000000;
            border-right-width: 1px;
            border-right-style: solid;
            border-right-color: #000000;
            border-left-width: 1px;
            border-left-style: solid;
            border-left-color: #000000;
            border-top-width: 1px;
            border-top-style: solid;
            border-top-color: #000000;
			font-family: "Lucida Sans Unicode";
			font-size:small;
        }
    </style>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_EstadoDeResultados" default="Estado de Resultados"
    returnvariable="LB_EstadoDeResultados" xmlfile="MenuConsultaCG.xml"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Miles" default="en miles"
    returnvariable="LB_Miles" xmlfile="MenuConsultaCG.xml"/>

    <form action="/cfmx/commons/widgets/publico/MenuCG-iframe.cfm" method="post" name="sql">
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td width="100%" bgcolor="gainsboro" align="center">
                <b style="font-size:13px"><cfoutput>#LB_EstadoDeResultados#</cfoutput></b>
            </td>
        </tr>
        <cfif Factor NEQ 1>
            <tr>
                <td width="100%" bgcolor="gainsboro" align="center">
                    <b>(<cfoutput>#LB_Miles#</cfoutput>)</b>
                </td>
            </tr>
        </cfif>
    </table>
    </form>
    <cfif isdefined('rs_CContables') and rs_CContables.recordCount NEQ 0>
        <cfinclude template="formMenuConsultaCG.cfm">
    </cfif>
</cfsavecontent>
<cfset lvarArchivoHTML = expandpath("EstadoResultados_#session.CEcodigo#_#session.ecodigo#.cfm")>
<cffile action="write" file="#lvarArchivoHTML#" output="#LEstadoResultadosHTML#" nameconflict="overwrite">

<!--- *************************************************** --->
<!--- **************  Area de funciones    ************** --->
<!--- *************************************************** --->
<cffunction name="ObtenerDato" returntype="query">
    <cfargument name="pcodigo" type="numeric" required="true">
        <cfquery name="rs" datasource="#Session.DSN#">
            select Pvalor
            from Parametros
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
              and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#">
        </cfquery>
        <cfreturn #rs#>
</cffunction>
<cffunction name="CreaCuentas" access="public" output="false" returntype="string">
	<cf_dbtemp name="CG0006_cuentasER">
		<cf_dbtempcol name="Ecodigo"  		type="integer"    		mandatory="yes">
		<cf_dbtempcol name="Ccuenta"		type="numeric"		mandatory="yes">
		<cf_dbtempcol name="corte"  		type="integer">
		<cf_dbtempcol name="nivel"  		type="integer">
		<cf_dbtempcol name="tipo"  		type="char(1)">
		<cf_dbtempcol name="subtipo"  		type="integer">
		<cf_dbtempcol name="ntipo"  		type="char(40)">
		<cf_dbtempcol name="mayor"  		type="char(4)">
		<cf_dbtempcol name="descrip"  		type="char(80)">
		<cf_dbtempcol name="formato"  		type="char(100)">
		<cf_dbtempcol name="Mes"  		type="integer">
		<cf_dbtempcol name="Anno"  		type="integer">
		<cf_dbtempcol name="saldoini"  		type="money">
		<cf_dbtempcol name="saldofin"  		type="money">
		<cf_dbtempcol name="debitos"  		type="money">
		<cf_dbtempcol name="creditos"		type="money">
		<cf_dbtempcol name="movmes"		type="money">
		<cf_dbtempcol name="MesAnt"  		type="integer">
		<cf_dbtempcol name="AnnoAnt"  		type="integer">
		<cf_dbtempcol name="saldoiniAnt"  	type="money">
		<cf_dbtempcol name="saldofinAnt"  	type="money">
		<cf_dbtempcol name="debitosAnt"  	type="money">
		<cf_dbtempcol name="creditosAnt"	type="money">
		<cf_dbtempcol name="movmesAnt"		type="money">
		<cf_dbtempcol name="MesAnno1"  		type="integer">
		<cf_dbtempcol name="AnnoAnno1" 		type="integer">
		<cf_dbtempcol name="saldoiniAnno1"  	type="money">
		<cf_dbtempcol name="saldofinAnno1"  	type="money">
		<cf_dbtempcol name="debitosAnno1"  	type="money">
		<cf_dbtempcol name="creditosAnno1"	type="money">
		<cf_dbtempcol name="movmesAnno1"	type="money">
		<cf_dbtempcol name="Cbalancen"  	type="char(1)">
		<cf_dbtempkey cols="Ccuenta">
	</cf_dbtemp>
	<cfreturn temp_table>
</cffunction>

<cffunction name="fnProcesaConsulta" output="no" access="private">
	<cfset cantniv = 1>
    <cfset Factor = 1000>
    <!--- *************************************************** --->
    <!--- ****      inicializacion de  variables         **** --->
    <!--- *************************************************** --->
    <cfset RSPvalorPeriodo 		= ObtenerDato(30)>
    <cfset RSPvalorMes 	   	= ObtenerDato(40)>
    <cfset cuentas 			= CreaCuentas()>
    <cfset Periodo 			= RSPvalorPeriodo.Pvalor>
    <cfset Mes 			= RSPvalorMes.Pvalor>
    <cfif Mes eq 1>
        <cfset PeriodoAnt 	= Periodo-1>
        <cfset MesAnt 		= 12>
    <cfelse>
        <cfset MesAnt 		= Mes-1>
        <cfset PeriodoAnt 	= Periodo>
    </cfif>
    <cfset Periodo1 = PeriodoAnt-1>
    <!--- Para presentar el mismo mes de hace un ao --->
    <cfset MesPer                   = Mes>
    <!--- Para Obtener el mes de cierre.  De esta forma se obtiene el cierre del ao anterior --->
    <cfset RSMesPer 		= ObtenerDato(45)>
    <cfset MesPer 			= RSMesPer.Pvalor>
    <cfif not isdefined("Form.nivel")>
        <cfset varNivel = '1'>
    <cfelse>
        <cfset varNivel = Form.nivel>
    </cfif>
    <!--- *************************************************** --->
    <!--- ****      otras variables                      **** --->
    <!--- *************************************************** --->
    <cfset Monloc 		= -1>
    <cfset Edescripcion 	= "">
    <cfset ofiini 		= -1>
    <cfset ofifin 		= -1>
    <cfset nivelcuenta 	= -1>
    <cfset nivelactual 	= 1>
    <cfset nivelanteri 	= 0>
    <cfset Ccuenta 		= -1>
    <cfset Tsaldofin 	= 0>
    <cfset TsaldofinAnt 	= 0>
    <cfset TsaldofinAnno1 	= 0>
    <cfset TsaldofinAnno2 	= 0>
    <cfset TsaldofinAnno3 	= 0>
    <!--- *************************************************** --->
    <!--- ****      Traducción de Etiquetas              **** --->
    <!--- *************************************************** --->
    <cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Meses"
    default="Ene.,Feb.,Mar.,Abr.,May.,Jun.,Jul.,Ago.,Set.,Oct.,Nov.,Dic."
    returnvariable="LB_Meses" xmlfile="MenuConsulta.xml"/>
    <cfinvoke key="MSG_INGRESOS" 					default="INGRESOS"						returnvariable="MSG_INGRESOS"						component="sif.Componentes.Translate" method="Translate"  xmlfile="/sif/cg/consultas/EstadoResultados-form.xml"/>
    <cfinvoke key="MSG_UTILIDAD_BRUTA" 				default="UTILIDAD BRUTA"				returnvariable="MSG_UTILIDAD_BRUTA"					component="sif.Componentes.Translate" method="Translate"  xmlfile="/sif/cg/consultas/EstadoResultados-form.xml"/>
    <cfinvoke key="MSG_UTILIDAD_DE_OPERACION" 		default="UTILIDAD DE OPERACION"			returnvariable="MSG_UTILIDAD_DE_OPERACION"			component="sif.Componentes.Translate" method="Translate"  xmlfile="/sif/cg/consultas/EstadoResultados-form.xml"/>
    <cfinvoke key="MSG_UTILIDAD_ANTES_DE_IMPUESTOS" default="UTILIDAD ANTES DE IMPUESTOS"	returnvariable="MSG_UTILIDAD_ANTES_DE_IMPUESTOS"	component="sif.Componentes.Translate" method="Translate"  xmlfile="/sif/cg/consultas/EstadoResultados-form.xml"/>
    <cfinvoke key="MSG_UTILIDAD_NETA" 				default="UTILIDAD NETA"					returnvariable="MSG_UTILIDAD_NETA"					component="sif.Componentes.Translate" method="Translate"  xmlfile="/sif/cg/consultas/EstadoResultados-form.xml"/>
    <cfinvoke key="MSG_COSTOS_DE_OPERACION" 		default="COSTOS DE OPERACION"			returnvariable="MSG_COSTOS_DE_OPERACION"			component="sif.Componentes.Translate" method="Translate"  xmlfile="/sif/cg/consultas/EstadoResultados-form.xml"/>
    <cfinvoke key="MSG_GASTOS_ADMINISTRATIVOS" 		default="GASTOS ADMINISTRATIVOS"		returnvariable="MSG_GASTOS_ADMINISTRATIVOS"			component="sif.Componentes.Translate" method="Translate"  xmlfile="/sif/cg/consultas/EstadoResultados-form.xml"/>
    <cfinvoke key="MSG_OTROS_INGRESOS_GRAVABLES" 	default="OTROS INGRESOS GRAVABLES"		returnvariable="MSG_OTROS_INGRESOS_GRAVABLES"		component="sif.Componentes.Translate" method="Translate"  xmlfile="/sif/cg/consultas/EstadoResultados-form.xml"/>
    <cfinvoke key="MSG_OTROS_GASTOS_DEDUCIBLES" 	default="OTROS GASTOS DEDUCIBLES"		returnvariable="MSG_OTROS_GASTOS_DEDUCIBLES"		component="sif.Componentes.Translate" method="Translate"  xmlfile="/sif/cg/consultas/EstadoResultados-form.xml"/>
    <cfinvoke key="MSG_OTROS_INGRESOS_NO_GRAVABLES"	default="OTROS INGRESOS NO GRAVABLES"	returnvariable="MSG_OTROS_INGRESOS_NO_GRAVABLES"	component="sif.Componentes.Translate" method="Translate"  xmlfile="/sif/cg/consultas/EstadoResultados-form.xml"/>
    <cfinvoke key="MSG_OTROS_GASTOS_NO_DEDUCIBLES" 	default="OTROS GASTOS NO DEDUCIBLES"	returnvariable="MSG_OTROS_GASTOS_NO_DEDUCIBLES"		component="sif.Componentes.Translate" method="Translate"  xmlfile="/sif/cg/consultas/EstadoResultados-form.xml"/>
    <cfinvoke key="MSG_IMPUESTOS" 					default="IMPUESTOS"						returnvariable="MSG_IMPUESTOS"						component="sif.Componentes.Translate" method="Translate"  xmlfile="/sif/cg/consultas/EstadoResultados-form.xml"/>

    <cfquery name="rsDescAlt" datasource="#Session.DSN#">
        select Pvalor
        from Parametros
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
            and Pcodigo = 99
    </cfquery>

    <!--- ************************************************************** --->
    <!--- ****     busca la cuenta de utilidad de parametros        **** --->
    <!--- ************************************************************** --->
    <cfquery name="rs_Par2" datasource="#Session.DSN#">
        Select coalesce(<cf_dbfunction name="to_number" datasource="#Session.DSN#" args="Pvalor">,0) as Pvalor
        from Parametros
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
          and Pcodigo = 290
    </cfquery>
    <cfif isdefined('rs_Par2') and rs_Par2.recordCount GT 0>
        <cfset Ccuenta = rs_Par2.Pvalor>
    </cfif>
    <cfif Ccuenta NEQ ''>
        <cfquery name="rs_CContables" datasource="#Session.DSN#">
            Select 1
            from CContables
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
              and Ccuenta=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Ccuenta#">
        </cfquery>
    </cfif>
    <!--- *************************************************** --->
    <!--- ****     busca la descripcion de la empresa    **** --->
    <!--- *************************************************** --->
    <cfquery name="rs_EmpresasDes" datasource="#Session.DSN#">
        Select Edescripcion
        from Empresas
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
    </cfquery>
    <cfif isdefined('rs_EmpresasDes') and rs_EmpresasDes.recordCount GT 0>
        <cfset Edescripcion = rs_EmpresasDes.Edescripcion>
    </cfif>
    <cfif isdefined('rs_CContables') and rs_CContables.recordCount NEQ 0>
        <cfquery name="rs_EmpresasDes" datasource="#Session.DSN#">
            insert INTO  #cuentas# (Ecodigo, mayor, descrip, Ccuenta, formato,
                        Mes,Anno, saldoini, debitos, creditos, movmes, saldofin,
                        MesAnt,AnnoAnt, saldoiniAnt, debitosAnt, creditosAnt, movmesAnt, saldofinAnt,
                        MesAnno1,AnnoAnno1, saldoiniAnno1, debitosAnno1, creditosAnno1, movmesAnno1, saldofinAnno1,
                        tipo, subtipo, Cbalancen, nivel)
			select 	#Session.Ecodigo#
                    , b.Cmayor, b.Cdescripcion, a.Ccuenta, a.Cformato,
                    #Mes#,#Periodo#, 	0.00, 0.00, 0.00, 0.00, 0.00,
                    #MesAnt#,#PeriodoAnt#, 	0.00, 0.00, 0.00, 0.00, 0.00,
                    #MesPer#,#Periodo1#, 	0.00, 0.00, 0.00, 0.00, 0.00,
                    b.Ctipo, b.Csubtipo * 10
                    , a.Cbalancen
                    , 0
            from CtasMayor b, CContables a
            where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
              and b.Ctipo in ('I', 'G')
              and b.Csubtipo is not null
              and b.Ecodigo = a.Ecodigo
              and b.Cmayor = a.Cformato
        </cfquery>
        <!--- *************************************************** --->
        <!--- ****     insert a las cuentas por nivel        **** --->
        <!--- *************************************************** --->
        <cfset nivelactual = 1>
        <cfset nivelanteri = 0>
        <cfloop condition = "nivelactual LESS THAN varNivel">
            <cfquery name="A2_Cuentas" datasource="#Session.DSN#">
                insert INTO  #cuentas# (Ecodigo, nivel, mayor, descrip, Ccuenta, formato,
                            Mes,Anno, saldoini, debitos, creditos, movmes, saldofin,
                            MesAnt,AnnoAnt, saldoiniAnt, debitosAnt, creditosAnt, movmesAnt, saldofinAnt,
                            MesAnno1,AnnoAnno1, saldoiniAnno1, debitosAnno1, creditosAnno1, movmesAnno1, saldofinAnno1,
                            tipo, subtipo, Cbalancen)
                select <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                    , <cfqueryparam cfsqltype="cf_sql_integer" value="#nivelactual#">
                    , b.Cmayor, b.Cdescripcion, b.Ccuenta, b.Cformato,
                    #Mes#,#Periodo#, 	0.00, 0.00, 0.00, 0.00, 0.00,
                    #MesAnt#,#PeriodoAnt#, 	0.00, 0.00, 0.00, 0.00, 0.00,
                    #MesPer#,#Periodo1#, 	0.00, 0.00, 0.00, 0.00, 0.00,
                     a.tipo, a.subtipo
                    , b.Cbalancen
                from #cuentas# a, CContables b
                where a.nivel = <cfqueryparam cfsqltype="cf_sql_integer" value="#nivelanteri#">
                  and a.Ccuenta = b.Cpadre
                  and a.Ecodigo = b.Ecodigo
            </cfquery>
            <cfset nivelanteri = nivelactual>
            <cfset nivelactual = nivelactual + 1>
        </cfloop>
        <cfquery name="rsCuenta" datasource="#Session.DSN#">
            select coalesce(max(Ccuenta), 0) + 1 as Ccuenta
            from #cuentas#
        </cfquery>
        <cfif rsCuenta.recordCount>
            <cfset next_cuenta = rsCuenta.Ccuenta>
        <cfelse>
            <cfset next_cuenta = 1>
        </cfif>
        <!--- ***************************************************************** --->
        <!--- ****     INSERTAR UTILIDAD BRUTA LA CTA MAYOR APARECE        **** --->
        <!--- ****     CON UN CERO ASI QUE NO DEBE PINTARSE EN PANTALLA    **** --->
        <!--- ***************************************************************** --->
        <cfquery name="rsUtil1" datasource="#Session.DSN#">
            insert INTO #cuentas# (Ecodigo, nivel, mayor, descrip, Ccuenta, formato,
                       Mes,Anno, saldoini, debitos, creditos, movmes, saldofin,
                       MesAnt,AnnoAnt, saldoiniAnt, debitosAnt, creditosAnt, movmesAnt, saldofinAnt,
                       MesAnno1,AnnoAnno1, saldoiniAnno1, debitosAnno1, creditosAnno1, movmesAnno1, saldofinAnno1,
                       tipo, subtipo, Cbalancen, corte, ntipo)
            values (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                , 0
                , '0', ''
                , <cfqueryparam cfsqltype="cf_sql_numeric" value="#next_cuenta#">
                ,'0',#Mes#,#Periodo#, 0.00, 0.00, 0.00, 0.00, 0.00,
                #MesAnt#,#PeriodoAnt#, 0.00, 0.00, 0.00, 0.00, 0.00,
                #MesPer#,#Periodo1#, 0.00, 0.00, 0.00, 0.00, 0.00,
                'I', 35
                , 'C'
                , 35
                , '#MSG_UTILIDAD_BRUTA#'
            )
        </cfquery>
        <cfset next_cuenta = next_cuenta + 1>
        <!--- ****************************************************************************** --->
        <!--- ****     INSERTAR UTILIDAD ANTES DE IMPUESTOS LA CTA MAYOR APARECE        **** --->
        <!--- ****     CON UN CERO ASI QUE NO DEBE PINTARSE EN PANTALLA    				**** --->
        <!--- ****************************************************************************** --->
        <cfquery name="rsUtil2" datasource="#Session.DSN#">
            insert INTO #cuentas# (Ecodigo, nivel, mayor, descrip, Ccuenta, formato,
                        Mes,Anno, saldoini, debitos, creditos, movmes, saldofin,
                        MesAnt,AnnoAnt, saldoiniAnt, debitosAnt, creditosAnt, movmesAnt, saldofinAnt,
                        MesAnno1,AnnoAnno1, saldoiniAnno1, debitosAnno1, creditosAnno1, movmesAnno1, saldofinAnno1,
                        tipo, subtipo, Cbalancen, corte, ntipo)
            values (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                , 0
                , '0', ''
                , <cfqueryparam cfsqltype="cf_sql_numeric" value="#next_cuenta#">
                ,'0',
                #Mes#,#Periodo#,0.00, 0.00, 0.00, 0.00, 0.00,
                #MesAnt#,#PeriodoAnt#, 0.00, 0.00, 0.00, 0.00, 0.00,
                #MesPer#,#Periodo1#, 0.00, 0.00, 0.00, 0.00, 0.00,
                'I', 55
                , 'C'
                , 55
                , '#MSG_UTILIDAD_ANTES_DE_IMPUESTOS#'
            )
        </cfquery>
        <cfset next_cuenta = next_cuenta + 1>
        <!--- ****************************************************************************** --->
        <!--- ****     INSERTAR UTILIDAD ANTES DE IMPUESTOS LA CTA MAYOR APARECE        **** --->
        <!--- ****     CON UN CERO ASI QUE NO DEBE PINTARSE EN PANTALLA    				**** --->
        <!--- ****************************************************************************** --->
        <cfquery name="rsUtil3" datasource="#Session.DSN#">
            insert INTO #cuentas# (Ecodigo, nivel, mayor, descrip, Ccuenta, formato,
                        Mes,Anno, saldoini, debitos, creditos, movmes, saldofin,
                        MesAnt,AnnoAnt, saldoiniAnt, debitosAnt, creditosAnt, movmesAnt, saldofinAnt,
                        MesAnno1,AnnoAnno1, saldoiniAnno1, debitosAnno1, creditosAnno1, movmesAnno1, saldofinAnno1,
                        tipo, subtipo, Cbalancen, corte, ntipo)
            values (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                , 0
                , '0', ''
                , <cfqueryparam cfsqltype="cf_sql_numeric" value="#next_cuenta#">
                ,'0',
                #Mes#,#Periodo#, 0.00, 0.00, 0.00, 0.00, 0.00,
                #MesAnt#,#PeriodoAnt#, 0.00, 0.00, 0.00, 0.00, 0.00,
                #MesPer#,#Periodo1#, 0.00, 0.00, 0.00, 0.00, 0.00,
                'I', 85
                , 'C'
                , 85
                , '#MSG_UTILIDAD_NETA#'
            )
        </cfquery>
        <!--- ******************************************************* --->
        <!--- ****    Carga de saldos para el mes Actual         **** --->
        <!--- ******************************************************* --->
        <cfquery datasource="#Session.DSN#">
            update #cuentas# set
                saldoini = coalesce(( select sum(SLinicial)
                                    from SaldosContables
                                    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                                      and Ccuenta = #cuentas#.Ccuenta
                                      and Speriodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Periodo#">
                                      and Smes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Mes#">
                                      ), 0.00),
                debitos =  coalesce((  select sum(DLdebitos)
                                      from SaldosContables
                                      where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                                        and Ccuenta = #cuentas#.Ccuenta
                                        and Speriodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Periodo#">
                                        and Smes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Mes#">

                                        ), 0.00),
                creditos =  coalesce((  select sum(CLcreditos)
                                      from SaldosContables
                                      where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                                        and Ccuenta = #cuentas#.Ccuenta
                                        and Speriodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Periodo#">
                                        and Smes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Mes#">
                                        ), 0.00)
        </cfquery>
        <cfquery datasource="#Session.DSN#">
            update #cuentas# set saldofin = (saldoini + debitos - creditos)
            where Anno = #Periodo#
            and   Mes = #Mes#
        </cfquery>
        <cfquery datasource="#Session.DSN#">
            update #cuentas#
                set movmes = (coalesce(debitos,0.00) - coalesce(creditos,0.00))
            where Anno = #Periodo#
            and   Mes = #Mes#
        </cfquery>
        <!--- ********************************************************* --->
        <!--- ****    Carga de saldos para el mes anterior         **** --->
        <!--- ********************************************************* --->
        <cfquery datasource="#Session.DSN#">
            update #cuentas# set
                saldoiniAnt = coalesce(( select sum(SLinicial)
                                    from SaldosContables
                                    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                                      and Ccuenta = #cuentas#.Ccuenta
                                      and Speriodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#PeriodoAnt#">
                                      and Smes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#MesAnt#">
                                      ), 0.00),
                debitosAnt =  coalesce((  select sum(DLdebitos)
                                      from SaldosContables
                                      where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                                        and Ccuenta = #cuentas#.Ccuenta
                                        and Speriodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#PeriodoAnt#">
                                        and Smes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#MesAnt#">
                                        ), 0.00),
                creditosAnt =  coalesce((  select sum(CLcreditos)
                                      from SaldosContables
                                      where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                                        and Ccuenta = #cuentas#.Ccuenta
                                        and Speriodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#PeriodoAnt#">
                                        and Smes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#MesAnt#">
                                        ), 0.00)
        </cfquery>
        <cfquery datasource="#Session.DSN#">
            update #cuentas# set saldofinAnt = (saldoiniAnt + debitosAnt - creditosAnt)
        </cfquery>
        <cfquery datasource="#Session.DSN#">
            update #cuentas#
                set movmesAnt = (coalesce(debitosAnt,0.00) - coalesce(creditosAnt,0.00))
        </cfquery>
        <!--- ********************************************************* --->
        <!--- ****    Carga de saldos para el ANO ACTUAL - 1       **** --->
        <!--- ********************************************************* --->
        <cfquery datasource="#Session.DSN#">
            update #cuentas# set
                saldoiniAnno1 = coalesce(( select sum(SLinicial)
                                    from SaldosContables
                                    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                                      and Ccuenta = #cuentas#.Ccuenta
                                      and Speriodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Periodo1#">
                                      and Smes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#MesPer#">
                                      ), 0.00),
                debitosAnno1 =  coalesce((  select sum(DLdebitos)
                                      from SaldosContables
                                      where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                                        and Ccuenta = #cuentas#.Ccuenta
                                        and Speriodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Periodo1#">
                                        and Smes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#MesPer#">
                                        ), 0.00),
                creditosAnno1 =  coalesce((  select sum(CLcreditos)
                                      from SaldosContables
                                      where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                                        and Ccuenta = #cuentas#.Ccuenta
                                        and Speriodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Periodo1#">
                                        and Smes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#MesPer#">
                                        ), 0.00)
        </cfquery>
        <cfquery datasource="#Session.DSN#">
            update #cuentas# set saldofinAnno1 = (saldoiniAnno1 + debitosAnno1 - creditosAnno1)
        </cfquery>
        <cfquery datasource="#Session.DSN#">
            update #cuentas#
                set movmesAnno1 = (coalesce(debitosAnno1,0.00) - coalesce(creditosAnno1,0.00))
        </cfquery>
        <!--- *********************************************************************** --->
        <!--- ****   Actualizar UTILIDAD BRUTA para el mes Actual 				 **** --->
        <!--- ****   Actualizar UTILIDAD ANTES DE IMPUESTOS para el mes Actual	 **** --->
        <!--- ****   Actualizar UTILIDAD NETA para el mes Actual                 **** --->
        <!--- *********************************************************************** --->
        <cfquery datasource="#Session.DSN#">
            update #cuentas#
                set saldofin = (
                    select sum(saldofin)
                    from #cuentas#
                    where nivel = 0
                    and subtipo < 35
                    and subtipo in (10, 20, 30)
                )
            where subtipo = 35
        </cfquery>
        <cfquery datasource="#Session.DSN#">
            update #cuentas#
                set saldofin = (
                    select sum(saldofin)
                    from #cuentas#
                    where nivel = 0
                    and subtipo < 55
                    and subtipo in (10, 20, 30, 40, 50)
                )
            where subtipo = 55
        </cfquery>
        <cfquery datasource="#Session.DSN#">
            update #cuentas#
                set saldofin = (
                    select sum(saldofin)
                    from #cuentas#
                    where nivel = 0
                    and subtipo < 85
                    and subtipo in (10, 20, 30, 40, 50, 60, 70, 80)
                )
            where subtipo = 85
        </cfquery>
        <cfquery datasource="#Session.DSN#">
            update #cuentas#
                set saldofin = (saldofin * -1), movmes = (movmes * -1)
            where Cbalancen = 'C'
        </cfquery>
        <!--- *********************************************************************** --->
        <!--- ****   Actualizar UTILIDAD BRUTA para el mes Anterior				 **** --->
        <!--- ****   Actualizar UTILIDAD ANTES DE IMPUESTOS para el mes Anterior **** --->
        <!--- ****   Actualizar UTILIDAD NETA para el mes Anterior               **** --->
        <!--- *********************************************************************** --->
        <cfquery datasource="#Session.DSN#">
            update #cuentas#
                set saldofinAnt = (
                    select sum(saldofinAnt)
                    from #cuentas#
                    where nivel = 0
                    and subtipo < 35
                    and subtipo in (10, 20, 30)
                )
            where subtipo = 35
        </cfquery>
        <cfquery datasource="#Session.DSN#">
            update #cuentas#
                set saldofinAnt = (
                    select sum(saldofinAnt)
                    from #cuentas#
                    where nivel = 0
                    and subtipo < 55
                    and subtipo in (10, 20, 30, 40, 50)
                )
            where subtipo = 55
        </cfquery>
        <cfquery datasource="#Session.DSN#">
            update #cuentas#
                set saldofinAnt = (
                    select sum(saldofinAnt)
                    from #cuentas#
                    where nivel = 0
                    and subtipo < 85
                    and subtipo in (10, 20, 30, 40, 50, 60, 70, 80)
                )
            where subtipo = 85
        </cfquery>
        <cfquery datasource="#Session.DSN#">
            update #cuentas#
                set saldofinAnt = (saldofinAnt * -1), movmesAnt = (movmesAnt * -1)
            where Cbalancen = 'C'
        </cfquery>
        <!--- *************************************************************************** --->
        <!--- ****   Actualizar UTILIDAD BRUTA para el  ANO ACTUAL - 1				 **** --->
        <!--- ****   Actualizar UTILIDAD ANTES DE IMPUESTOS para el ANO ACTUAL - 1   **** --->
        <!--- ****   Actualizar UTILIDAD NETA para el ANO ACTUAL - 1                 **** --->
        <!--- *************************************************************************** --->
        <cfquery datasource="#Session.DSN#">
            update #cuentas#
                set saldofinAnno1 = (
                    select sum(saldofinAnno1)
                    from #cuentas#
                    where nivel = 0
                    and subtipo < 35
                    and subtipo in (10, 20, 30)
                )
            where subtipo = 35
        </cfquery>

        <cfquery datasource="#Session.DSN#">
            update #cuentas#
                set saldofinAnno1 = (
                    select sum(saldofinAnno1)
                    from #cuentas#
                    where nivel = 0
                    and subtipo < 55
                    and subtipo in (10, 20, 30, 40, 50)
                )
            where subtipo = 55
        </cfquery>
        <cfquery datasource="#Session.DSN#">
            update #cuentas#
                set saldofinAnno1 = (
                    select sum(saldofinAnno1)
                    from #cuentas#
                    where nivel = 0
                    and subtipo < 85
                    and subtipo in (10, 20, 30, 40, 50, 60, 70, 80)
                )
            where subtipo = 85
        </cfquery>
        <cfquery datasource="#Session.DSN#">
            update #cuentas#
                set saldofinAnno1 = (saldofinAnno1 * -1), movmesAnno1 = (movmesAnno1 * -1)
            where Cbalancen = 'C'
        </cfquery>
        <!--- ************************************* --->
        <!--- ****   Actualizacion de datos    **** --->
        <!--- ************************************* --->
        <cfquery datasource="#Session.DSN#">
            update #cuentas#
                set corte = 10, ntipo = '#MSG_INGRESOS#'
            where tipo = 'I' and subtipo = 10
        </cfquery>
        <!--- ************************************* --->
        <cfquery datasource="#Session.DSN#">
            update #cuentas#
                set corte = 20, ntipo = '#MSG_COSTOS_DE_OPERACION#'
            where tipo = 'G' and subtipo = 20
        </cfquery>
        <!--- ************************************* --->
        <cfquery datasource="#Session.DSN#">
            update #cuentas#
                set corte = 30, ntipo = '#MSG_GASTOS_ADMINISTRATIVOS#'
            where tipo = 'G' and subtipo = 30
        </cfquery>
        <!--- ************************************* --->
        <cfquery datasource="#Session.DSN#">
            update #cuentas#
                set corte = 40, ntipo = '#MSG_OTROS_INGRESOS_GRAVABLES#'
            where tipo = 'I' and subtipo = 40
        </cfquery>
        <!--- ************************************* --->
        <cfquery datasource="#Session.DSN#">
            update #cuentas#
                set corte = 50, ntipo = '#MSG_OTROS_GASTOS_DEDUCIBLES#'
            where tipo = 'G' and subtipo = 50
        </cfquery>
        <!--- ************************************* --->
        <cfquery datasource="#Session.DSN#">
            update #cuentas#
                set corte = 60, ntipo = '#MSG_OTROS_INGRESOS_NO_GRAVABLES#'
            where tipo = 'I' and subtipo = 60
        </cfquery>
        <!--- ************************************* --->
        <cfquery datasource="#Session.DSN#">
            update #cuentas#
                set corte = 70, ntipo = '#MSG_OTROS_GASTOS_NO_DEDUCIBLES#'
            where tipo = 'G' and subtipo = 70
        </cfquery>
        <!--- ************************************* --->
        <cfquery datasource="#Session.DSN#">
            update #cuentas#
                set corte = 80, ntipo = '#MSG_IMPUESTOS#'
            where tipo = 'G' and subtipo = 80
        </cfquery>
        <cfquery datasource="#Session.DSN#">
            delete from #cuentas#
            where saldofin = 0.00
              and   saldofinAnt = 0.00
              and   saldofinAnno1 =  0.00
        </cfquery>
    </cfif>
    <cfquery name="rsProc" datasource="#Session.DSN#">
        select
            Ecodigo,
            Ccuenta,
            corte,
            nivel,
            tipo,
            subtipo,
            ntipo,
            mayor,
            descrip,
            formato,
            Mes,
            Anno,
            coalesce(saldoini,0) as saldoini,
            coalesce(saldofin,0) as saldofin,
            coalesce(debitos,0)  as debitos,
            coalesce(creditos,0) as creditos,
            coalesce(movmes,0)   as movmes,
            MesAnt,
            AnnoAnt,
            coalesce(saldoiniAnt,0) as saldoiniAnt,
            coalesce(saldofinAnt,0) as saldofinAnt,
            coalesce(debitosAnt,0) as debitosAnt,
            coalesce(creditosAnt,0) as creditosAnt,
            coalesce(movmesAnt,0) as movmesAnt,
            MesAnno1,
            AnnoAnno1,
            coalesce(saldoiniAnno1,0) as saldoiniAnno1,
            coalesce(saldofinAnno1,0) as saldofinAnno1,
            coalesce(debitosAnno1,0) as debitosAnno1,
            coalesce(creditosAnno1,0) as creditosAnno1,
            coalesce(movmesAnno1,0) as movmesAnno1,
            Cbalancen
        from #cuentas#
        order by corte, mayor, formato
    </cfquery>
    <cfquery name="rsMayor" dbtype="query">
        select *
        from rsProc
        where nivel = 0
        order by corte, mayor, formato
    </cfquery>

    <cfset meses="#LB_Meses#">
    <cfset Tsaldofin 		= 0>
    <cfset TsaldofinAnt 	= 0>
    <cfset TsaldofinAnno1 	= 0>
    <cfset corteR = 0>
    <cfset corteCtaMayor = 0>
</cffunction>

